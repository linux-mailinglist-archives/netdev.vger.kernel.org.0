Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD34B37F915
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 15:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbhEMNsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 09:48:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58415 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234160AbhEMNsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 09:48:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620913650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A0dkUXbD61yHxsoYQsJu5ao3/IUZG53e3Y4MDccE/hg=;
        b=dR/EPBRuSjW4N/CYZEMIyy73JeRb47RXJX2QZuD2KV5PoB8TTi6lAOnj+oswUD50l1PddJ
        Ng0U9z+hWxQKutzhngNrx1kkrYLzl6h/wJnMQTHI4sWRunbCUcaHt6KxKNnZ2Xy/BVDr4w
        J1/FB60L3Gnr2KG0NHLBoVwlhRXCv4s=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-FAsyjGziOg-gXoa3wwO0vw-1; Thu, 13 May 2021 09:47:27 -0400
X-MC-Unique: FAsyjGziOg-gXoa3wwO0vw-1
Received: by mail-ej1-f70.google.com with SMTP id zo1-20020a170906ff41b02903973107d7b5so8342583ejb.21
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 06:47:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A0dkUXbD61yHxsoYQsJu5ao3/IUZG53e3Y4MDccE/hg=;
        b=rR0QVUXPaaZMeDa8NA7e3BBcgyREXaRavZ50MzjfxMIxYUji4bEOsYNDU1eoDjRCcM
         q5gCJERgHS5OhuKgPZCrxEsBfRsfopI5ERuUMb5B/Hovdd55Q9wcWJcBEgCDBBOqR0ZE
         Jpsf9bqPilu+ZCJeNyb/CZLVGird3kqFwEt08ODWCKG7RvLWQKYhthKJHWytZBAbOrp/
         9Y0q10Btb7YK1eU2twqewkURFMs1CKXoewg6h2fs6HbOWO30xH+7RKQQgG78KyMGNZTt
         7M8R4WjrFTvElRLEsXlg0aAeQH+R0AclQE3D1q+qj6X4r0PVWNbb7vTfMUtk/hMxfguh
         DLtg==
X-Gm-Message-State: AOAM5327VoFfoxSyo9gZED/HJ/dK4bNR5II3fDIRFI8o+YArPxbJY6Kx
        DnPCmS5Yevxo7LAjljM2J8hcdTmpRt/05XANeRTX/mkZoLOuEDyHYUWuoth6jml3S3Be/1i1kQH
        Mm6dIti2gTDBLKrgf
X-Received: by 2002:a05:6402:1a:: with SMTP id d26mr50917871edu.99.1620913646401;
        Thu, 13 May 2021 06:47:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxguXOshUlXIdgN5o0x789QBKRhPy8p6rcPd+Tw/RguN6tZBLRGwCFOYqpyXK4ryGcq9iJdZw==
X-Received: by 2002:a05:6402:1a:: with SMTP id d26mr50917841edu.99.1620913646200;
        Thu, 13 May 2021 06:47:26 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id x18sm1882118eju.45.2021.05.13.06.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 06:47:25 -0700 (PDT)
Date:   Thu, 13 May 2021 15:47:22 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v9 17/19] vsock_test: add SOCK_SEQPACKET tests
Message-ID: <20210513134722.i2mn54fsi5pyq4vq@steredhat>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163704.3432731-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210508163704.3432731-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 07:37:00PM +0300, Arseny Krasnov wrote:
>This adds two tests of SOCK_SEQPACKET socket: both transfer data and
>then test MSG_EOR and MSG_TRUNC flags. Cases for connect(), bind(),
            ^
We removed the MSG_EOR tests, right?

>etc. are not tested, because it is same as for stream socket.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
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

