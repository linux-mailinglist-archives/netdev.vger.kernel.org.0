Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99763366828
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 11:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbhDUJgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 05:36:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238340AbhDUJgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 05:36:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618997762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ACqY+6Q4cI9VoecQi1p0SEw3gzRohNqiuStWl9wmApY=;
        b=UigBYRz/aIkod6IdJs6M4DhYhVKRDUDQU89YYXBxZkir9cxE9/SiWfhkqUwdHz3lIrH5ny
        vC2H+H4n6dRZUx4NY3YMiOhusLHjLv5mUnczrXm+2kXNuUQFhl1Wxk8Yd9WKvc+4XtoCP7
        uX+0Wc9kUrE78fnjQQ1OCQ/iHu/3GHo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-RvTGTbD-Od2dEJ3-Zy2mUw-1; Wed, 21 Apr 2021 05:35:59 -0400
X-MC-Unique: RvTGTbD-Od2dEJ3-Zy2mUw-1
Received: by mail-ed1-f71.google.com with SMTP id v5-20020a0564023485b029037ff13253bcso14691323edc.3
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 02:35:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ACqY+6Q4cI9VoecQi1p0SEw3gzRohNqiuStWl9wmApY=;
        b=ZDaNVQQguD7zX4wGSopl/Q54j/UHevQvILEIuab8/hL2KBjEDhv0LP9S9RqD3O8Fyt
         SilWw/cW8AC+gDQuM4ff3rBwzXkKdX/bvjtJhOCFIG55KXPhEGX4kqr7CpHFDJRP+mcm
         /XSmqiY3sSXda6JtqottWn3pOuAXCazrNzdIFQecp56up7pUJKUZ4tofLDTz+kb47F4W
         vfxn94nQ4WTPJRUJ1YEcwmhRAXk/RVc1nJxYA7XtvMtTZLImiQYpEBzSn09EPWsXLsYs
         6uzrHp4jx9zoghD1/MscjEVfkopR7vMRyhFeGIhHFSD6qNGeualesY4rmFTBlHS9MCCU
         7Ybg==
X-Gm-Message-State: AOAM5309jiYy6AZPAFZQ/4GjnOcUrt9B481tI6A9Q7ayRZ6gQo46ZSoi
        MT56exCVJlsjFH2nouHD8Vz8wZBTPCtaG4lpjQTwbiAENovWDCHoiI0BvwnLsCezccxvwlWjD3b
        cwyXyG1OJPvPoLwD/
X-Received: by 2002:aa7:d2da:: with SMTP id k26mr37681364edr.156.1618997758239;
        Wed, 21 Apr 2021 02:35:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJXDahCktxfXYwURao9+4dGAANy5jTDVWd/ahoUUrBTut9yRSYVXom1JKkvyS3Gy9Il0hI6A==
X-Received: by 2002:aa7:d2da:: with SMTP id k26mr37681335edr.156.1618997758036;
        Wed, 21 Apr 2021 02:35:58 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id g20sm2552335edb.7.2021.04.21.02.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 02:35:57 -0700 (PDT)
Date:   Wed, 21 Apr 2021 11:35:54 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        David Brazdil <dbrazdil@google.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v8 17/19] vsock_test: add SOCK_SEQPACKET tests
Message-ID: <20210421093554.y45al5r7xhoo7dwh@steredhat>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
 <20210413124701.3407363-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210413124701.3407363-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 03:46:58PM +0300, Arseny Krasnov wrote:
>This adds test of SOCK_SEQPACKET socket: it transfer data and
>then tests MSG_TRUNC flag. Cases for connect(), bind(), etc. are
>not tested, because it is same as for stream socket.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
>v7 -> v8:
> - Test for MSG_EOR flags now removed.

Why did we remove it?

Thanks,
Stefano

>
> tools/testing/vsock/util.c       | 32 +++++++++++++---
> tools/testing/vsock/util.h       |  3 ++
> tools/testing/vsock/vsock_test.c | 63 ++++++++++++++++++++++++++++++++
> 3 files changed, 93 insertions(+), 5 deletions(-)
>
>diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>index 93cbd6f603f9..2acbb7703c6a 100644
>--- a/tools/testing/vsock/util.c
>+++ b/tools/testing/vsock/util.c
>@@ -84,7 +84,7 @@ void vsock_wait_remote_close(int fd)
> }
>
> /* Connect to <cid, port> and return the file descriptor. */
>-int vsock_stream_connect(unsigned int cid, unsigned int port)
>+static int vsock_connect(unsigned int cid, unsigned int port, int type)
> {
> 	union {
> 		struct sockaddr sa;
>@@ -101,7 +101,7 @@ int vsock_stream_connect(unsigned int cid, unsigned int port)
>
> 	control_expectln("LISTENING");
>
>-	fd = socket(AF_VSOCK, SOCK_STREAM, 0);
>+	fd = socket(AF_VSOCK, type, 0);
>
> 	timeout_begin(TIMEOUT);
> 	do {
>@@ -120,11 +120,21 @@ int vsock_stream_connect(unsigned int cid, unsigned int port)
> 	return fd;
> }
>
>+int vsock_stream_connect(unsigned int cid, unsigned int port)
>+{
>+	return vsock_connect(cid, port, SOCK_STREAM);
>+}
>+
>+int vsock_seqpacket_connect(unsigned int cid, unsigned int port)
>+{
>+	return vsock_connect(cid, port, SOCK_SEQPACKET);
>+}
>+
> /* Listen on <cid, port> and return the first incoming connection.  The remote
>  * address is stored to clientaddrp.  clientaddrp may be NULL.
>  */
>-int vsock_stream_accept(unsigned int cid, unsigned int port,
>-			struct sockaddr_vm *clientaddrp)
>+static int vsock_accept(unsigned int cid, unsigned int port,
>+			struct sockaddr_vm *clientaddrp, int type)
> {
> 	union {
> 		struct sockaddr sa;
>@@ -145,7 +155,7 @@ int vsock_stream_accept(unsigned int cid, unsigned int port,
> 	int client_fd;
> 	int old_errno;
>
>-	fd = socket(AF_VSOCK, SOCK_STREAM, 0);
>+	fd = socket(AF_VSOCK, type, 0);
>
> 	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
> 		perror("bind");
>@@ -189,6 +199,18 @@ int vsock_stream_accept(unsigned int cid, unsigned int port,
> 	return client_fd;
> }
>
>+int vsock_stream_accept(unsigned int cid, unsigned int port,
>+			struct sockaddr_vm *clientaddrp)
>+{
>+	return vsock_accept(cid, port, clientaddrp, SOCK_STREAM);
>+}
>+
>+int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
>+			   struct sockaddr_vm *clientaddrp)
>+{
>+	return vsock_accept(cid, port, clientaddrp, SOCK_SEQPACKET);
>+}
>+
> /* Transmit one byte and check the return value.
>  *
>  * expected_ret:
>diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>index e53dd09d26d9..a3375ad2fb7f 100644
>--- a/tools/testing/vsock/util.h
>+++ b/tools/testing/vsock/util.h
>@@ -36,8 +36,11 @@ struct test_case {
> void init_signals(void);
> unsigned int parse_cid(const char *str);
> int vsock_stream_connect(unsigned int cid, unsigned int port);
>+int vsock_seqpacket_connect(unsigned int cid, unsigned int port);
> int vsock_stream_accept(unsigned int cid, unsigned int port,
> 			struct sockaddr_vm *clientaddrp);
>+int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
>+			   struct sockaddr_vm *clientaddrp);
> void vsock_wait_remote_close(int fd);
> void send_byte(int fd, int expected_ret, int flags);
> void recv_byte(int fd, int expected_ret, int flags);
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 5a4fb80fa832..ffec985fd36f 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -14,6 +14,8 @@
> #include <errno.h>
> #include <unistd.h>
> #include <linux/kernel.h>
>+#include <sys/types.h>
>+#include <sys/socket.h>
>
> #include "timeout.h"
> #include "control.h"
>@@ -279,6 +281,62 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
> 	close(fd);
> }
>
>+#define MESSAGE_TRUNC_SZ 32
>+static void test_seqpacket_msg_trunc_client(const struct test_opts *opts)
>+{
>+	int fd;
>+	char buf[MESSAGE_TRUNC_SZ];
>+
>+	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (send(fd, buf, sizeof(buf), 0) != sizeof(buf)) {
>+		perror("send failed");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_writeln("SENDDONE");
>+	close(fd);
>+}
>+
>+static void test_seqpacket_msg_trunc_server(const struct test_opts *opts)
>+{
>+	int fd;
>+	char buf[MESSAGE_TRUNC_SZ / 2];
>+	struct msghdr msg = {0};
>+	struct iovec iov = {0};
>+
>+	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_expectln("SENDDONE");
>+	iov.iov_base = buf;
>+	iov.iov_len = sizeof(buf);
>+	msg.msg_iov = &iov;
>+	msg.msg_iovlen = 1;
>+
>+	ssize_t ret = recvmsg(fd, &msg, MSG_TRUNC);
>+
>+	if (ret != MESSAGE_TRUNC_SZ) {
>+		printf("%zi\n", ret);
>+		perror("MSG_TRUNC doesn't work");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (!(msg.msg_flags & MSG_TRUNC)) {
>+		fprintf(stderr, "MSG_TRUNC expected\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	close(fd);
>+}
>+
> static struct test_case test_cases[] = {
> 	{
> 		.name = "SOCK_STREAM connection reset",
>@@ -309,6 +367,11 @@ static struct test_case test_cases[] = {
> 		.run_client = test_stream_msg_peek_client,
> 		.run_server = test_stream_msg_peek_server,
> 	},
>+	{
>+		.name = "SOCK_SEQPACKET send data MSG_TRUNC",
>+		.run_client = test_seqpacket_msg_trunc_client,
>+		.run_server = test_seqpacket_msg_trunc_server,
>+	},
> 	{},
> };
>
>-- 
>2.25.1
>

