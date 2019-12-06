FROM centos:latest
MAINTAINER Vadim Aleksandrov <valeksandrov@me.com>

COPY rootfs /

RUN dnf update -y && \
    dnf install -y epel-release && \
    dnf install -y python36 git which && \
    pip3 install --upgrade pip && \
    echo "export PATH=~/.local/bin:$PATH" >> ~/.bashrc && \
    source ~/.bashrc && \
    pip3 install git+https://github.com/verdel/j2cli.git && \
    update-ca-trust && \
    # Clean up
    dnf clean all && \
    rm -rf \
    /usr/share/man \
    /tmp/* \
    /var/cache/dnf

# Add s6-overlay
ENV S6_OVERLAY_VERSION v1.22.1.0

RUN curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz \
    | tar xvfz - -C / && \
    mv /bin /bin-s6 && \
    rm /usr/bin/execlineb && \
    /bin-s6/s6-update-symlinks /bin /bin-s6 /usr/bin && \
    ln -s /bin/execlineb /usr/bin/execlineb && \
    mv /sbin /sbin-s6 && \
    /bin-s6/s6-update-symlinks /sbin /sbin-s6 /usr/sbin

ENTRYPOINT ["/init"]
CMD []
