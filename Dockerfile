# Build with: docker build -t="wmernagh/ruby193-coffee-phantom-node:v3" .
# Push with: docker push wmernagh/ruby193-coffee-phantom-node:v3
FROM ruby:1.9.3-p547
MAINTAINER Will Mernagh <wmernagh@gmail.com>

# If you don't want to use therubyracer gem or similar,
# install Node.js as your preferred JS runtime
RUN curl -sL https://deb.nodesource.com/setup | bash -
 

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN curl -sL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# Install dependencies needed by Rails, followed by cleanup
RUN apt-get update -q && \
    apt-get install -qy build-essential postgresql-client-9.6 libpq-dev libqt4-dev xvfb nodejs imagemagick libqtwebkit4 libqtwebkit-dev --no-install-recommends && \
    apt-get clean && \
    npm install -g coffee-script && \
    npm install -g gulp && \
    cd /var/lib/apt/lists && rm -fr *Release* *Sources* *Packages* && \
    truncate -s 0 /var/log/*log

# PhantomJS
RUN cd /tmp && \
    curl -L -O https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2 && \
    tar xjf /tmp/phantomjs-1.9.7-linux-x86_64.tar.bz2 -C /tmp && \
    mv /tmp/phantomjs-1.9.7-linux-x86_64/bin/phantomjs /usr/local/bin && \
    rm -rf /tmp/phantomjs-1.9.7-linux-x86_64

RUN adduser web --home /home/web --shell /bin/bash --disabled-password --gecos ""
RUN mkdir -p /ruby_gems/1.9.3 && chmod 755 /ruby_gems/1.9.3

RUN mkdir /webapp

USER web

ENV GEM_HOME /ruby_gems/1.9.3
ENV PATH /ruby_gems/1.9.3/bin:$PATH

WORKDIR /webapp
