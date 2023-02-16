Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320456998E9
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjBPPap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjBPPan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:30:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BB25BA5
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 07:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676561394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O+OnUaBkHzkHXcVUDxA2W+iWYjA7NHTym1Lcryt4gOY=;
        b=BlBArEi1fqRBDPqUTWr0uQTLiUx2aowq8Q2/GYc6gpSKhpQ5uNTP7+UY7xrmP47oWgUh1F
        LxUVMcKIRLS/pG1mqoxtjBeEt/NjgxhhWSJo9fo2WPuXtYHxp+deFdVv2uy3Z5uS0P3gUe
        mOLt5QSWrLY9m1G6udAi2HnSLL/pXrI=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-652-rVMUtqxxN2iMY-7jw-66KQ-1; Thu, 16 Feb 2023 10:29:52 -0500
X-MC-Unique: rVMUtqxxN2iMY-7jw-66KQ-1
Received: by mail-qt1-f198.google.com with SMTP id j26-20020ac84c9a000000b003b9b7c60108so1385568qtv.16
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 07:29:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O+OnUaBkHzkHXcVUDxA2W+iWYjA7NHTym1Lcryt4gOY=;
        b=fuNVAlOvMYsDcWZjtjwnKgPjLLr2vHCs3WJuViT6+HXmyKifNKOuC/FHbBzU19vkTD
         c12ifkuucmSTLPXYhUh+KbY2s4SB91DRH+NyPFig9qIl26Hbcoqgf8bc2FtlO08EsLDc
         aEwGV8tpsMUaGcMz9Pp5es2AWo+m2sn9VLYtUHA4YYR9+Ml0xbG3dxEDeokV4LO6xWgT
         iUjCzPbBnU14iJijgOy2Sfgb2to5MFZjjaRUb7yKhL7Prjqxpm+nkQE53ZQ50Kz3gNFD
         IEXhPmMzTmMSJUiue9DuHlpjtgf/7nrZvxKVM+AHLOo2fclW6SNTwXXgxVCE63PcUvsN
         4W5g==
X-Gm-Message-State: AO0yUKVjPc/aTeo/D/2YHbrl9qNSuJk38QpG+kkEP47OrPVTQlCueBmR
        XJw8/NGoR6JsgwHLLrKVS7M6+D4qD/nSgrKbkBQKo1/C0/+ur6UHHwkN88CzCxyi5pVw8CUbGn+
        BFNGpXD6DHhkMatED
X-Received: by 2002:a05:6214:20aa:b0:56e:adc7:da2c with SMTP id 10-20020a05621420aa00b0056eadc7da2cmr11354172qvd.45.1676561392255;
        Thu, 16 Feb 2023 07:29:52 -0800 (PST)
X-Google-Smtp-Source: AK7set8jujUmYvQoNbsqIW6FTw3ePLT8M+JBb9cOjPHIvg9BVyvokaD0baxtMbtkCTkLtlm/CuRZaA==
X-Received: by 2002:a05:6214:20aa:b0:56e:adc7:da2c with SMTP id 10-20020a05621420aa00b0056eadc7da2cmr11354147qvd.45.1676561391923;
        Thu, 16 Feb 2023 07:29:51 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-167.retail.telecomitalia.it. [82.57.51.167])
        by smtp.gmail.com with ESMTPSA id b64-20020a37b243000000b0072ad54e36b2sm1349762qkf.93.2023.02.16.07.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 07:29:51 -0800 (PST)
Date:   Thu, 16 Feb 2023 16:29:45 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 12/12] test/vsock: MSG_ZEROCOPY support for
 vsock_perf
Message-ID: <20230216152945.qdh6vrq66pl2bfxe@sgarzare-redhat>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
 <03570f48-f56a-2af4-9579-15a685127aeb@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <03570f48-f56a-2af4-9579-15a685127aeb@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 07:06:32AM +0000, Arseniy Krasnov wrote:
>To use this option pass '--zc' parameter:

--zerocopy or --zero-copy maybe better follow what we did with the other 
parameters :-)

>
>./vsock_perf --zc --sender <cid> --port <port> --bytes <bytes to send>
>
>With this option MSG_ZEROCOPY flag will be passed to the 'send()' call.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/vsock_perf.c | 127 +++++++++++++++++++++++++++++--
> 1 file changed, 120 insertions(+), 7 deletions(-)
>
>diff --git a/tools/testing/vsock/vsock_perf.c b/tools/testing/vsock/vsock_perf.c
>index a72520338f84..1d435be9b48e 100644
>--- a/tools/testing/vsock/vsock_perf.c
>+++ b/tools/testing/vsock/vsock_perf.c
>@@ -18,6 +18,8 @@
> #include <poll.h>
> #include <sys/socket.h>
> #include <linux/vm_sockets.h>
>+#include <sys/mman.h>
>+#include <linux/errqueue.h>
>
> #define DEFAULT_BUF_SIZE_BYTES	(128 * 1024)
> #define DEFAULT_TO_SEND_BYTES	(64 * 1024)
>@@ -28,9 +30,14 @@
> #define BYTES_PER_GB		(1024 * 1024 * 1024ULL)
> #define NSEC_PER_SEC		(1000000000ULL)
>
>+#ifndef SOL_VSOCK
>+#define SOL_VSOCK 287
>+#endif

I thought we use the current kernel headers when we compile the tests,
do we need to fix something in the makefile?

>+
> static unsigned int port = DEFAULT_PORT;
> static unsigned long buf_size_bytes = DEFAULT_BUF_SIZE_BYTES;
> static unsigned long vsock_buf_bytes = DEFAULT_VSOCK_BUF_BYTES;
>+static bool zerocopy;
>
> static void error(const char *s)
> {
>@@ -247,15 +254,74 @@ static void run_receiver(unsigned long rcvlowat_bytes)
> 	close(fd);
> }
>
>+static void recv_completion(int fd)
>+{
>+	struct sock_extended_err *serr;
>+	char cmsg_data[128];
>+	struct cmsghdr *cm;
>+	struct msghdr msg;
>+	int ret;
>+
>+	msg.msg_control = cmsg_data;
>+	msg.msg_controllen = sizeof(cmsg_data);
>+
>+	ret = recvmsg(fd, &msg, MSG_ERRQUEUE);
>+	if (ret == -1)
>+		return;
>+
>+	cm = CMSG_FIRSTHDR(&msg);
>+	if (!cm) {
>+		fprintf(stderr, "cmsg: no cmsg\n");
>+		return;
>+	}
>+
>+	if (cm->cmsg_level != SOL_VSOCK) {
>+		fprintf(stderr, "cmsg: unexpected 'cmsg_level'\n");
>+		return;
>+	}
>+
>+	if (cm->cmsg_type) {
>+		fprintf(stderr, "cmsg: unexpected 'cmsg_type'\n");
>+		return;
>+	}
>+
>+	serr = (void *)CMSG_DATA(cm);
>+	if (serr->ee_origin != SO_EE_ORIGIN_ZEROCOPY) {
>+		fprintf(stderr, "serr: wrong origin\n");
>+		return;
>+	}
>+
>+	if (serr->ee_errno) {
>+		fprintf(stderr, "serr: wrong error code\n");
>+		return;
>+	}
>+
>+	if (zerocopy && (serr->ee_code & SO_EE_CODE_ZEROCOPY_COPIED))
>+		fprintf(stderr, "warning: copy instead of zerocopy\n");
>+}
>+
>+static void enable_so_zerocopy(int fd)
>+{
>+	int val = 1;
>+
>+	if (setsockopt(fd, SOL_SOCKET, SO_ZEROCOPY, &val, sizeof(val)))
>+		error("setsockopt(SO_ZEROCOPY)");
>+}
>+
> static void run_sender(int peer_cid, unsigned long to_send_bytes)
> {
> 	time_t tx_begin_ns;
> 	time_t tx_total_ns;
> 	size_t total_send;
>+	time_t time_in_send;
> 	void *data;
> 	int fd;
>
>-	printf("Run as sender\n");
>+	if (zerocopy)
>+		printf("Run as sender MSG_ZEROCOPY\n");
>+	else
>+		printf("Run as sender\n");
>+
> 	printf("Connect to %i:%u\n", peer_cid, port);
> 	printf("Send %lu bytes\n", to_send_bytes);
> 	printf("TX buffer %lu bytes\n", buf_size_bytes);
>@@ -265,25 +331,58 @@ static void run_sender(int peer_cid, unsigned long to_send_bytes)
> 	if (fd < 0)
> 		exit(EXIT_FAILURE);
>
>-	data = malloc(buf_size_bytes);
>+	if (zerocopy) {
>+		enable_so_zerocopy(fd);
>
>-	if (!data) {
>-		fprintf(stderr, "'malloc()' failed\n");
>-		exit(EXIT_FAILURE);
>+		data = mmap(NULL, buf_size_bytes, PROT_READ | PROT_WRITE,
>+			    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>+		if (data == MAP_FAILED) {
>+			perror("mmap");
>+			exit(EXIT_FAILURE);
>+		}
>+	} else {
>+		data = malloc(buf_size_bytes);
>+
>+		if (!data) {
>+			fprintf(stderr, "'malloc()' failed\n");
>+			exit(EXIT_FAILURE);
>+		}
> 	}

Eventually to simplify the code I think we can use the mmaped buffer in
both cases.

>
> 	memset(data, 0, buf_size_bytes);
> 	total_send = 0;
>+	time_in_send = 0;
> 	tx_begin_ns = current_nsec();
>
> 	while (total_send < to_send_bytes) {
> 		ssize_t sent;
>+		size_t rest_bytes;
>+		time_t before;
>+
>+		rest_bytes = to_send_bytes - total_send;
>
>-		sent = write(fd, data, buf_size_bytes);
>+		before = current_nsec();
>+		sent = send(fd, data, (rest_bytes > buf_size_bytes) ?
>+			    buf_size_bytes : rest_bytes,
>+			    zerocopy ? MSG_ZEROCOPY : 0);
>+		time_in_send += (current_nsec() - before);
>
> 		if (sent <= 0)
> 			error("write");
>
>+		if (zerocopy) {
>+			struct pollfd fds = { 0 };
>+
>+			fds.fd = fd;

Which event are we waiting for here?

>+
>+			if (poll(&fds, 1, -1) < 0) {
>+				perror("poll");
>+				exit(EXIT_FAILURE);
>+			}

We need this because we use only one buffer, but if we use more than
one, we could take full advantage of zerocopy, right?

Otherwise, I don't think it's a fair comparison with non-zerocopy.

Thanks,
Stefano

>+
>+			recv_completion(fd);
>+		}
>+
> 		total_send += sent;
> 	}
>
>@@ -294,9 +393,14 @@ static void run_sender(int peer_cid, unsigned long to_send_bytes)
> 	       get_gbps(total_send * 8, tx_total_ns));
> 	printf("total time in 'write()': %f sec\n",
> 	       (float)tx_total_ns / NSEC_PER_SEC);
>+	printf("time in send %f\n", (float)time_in_send / NSEC_PER_SEC);
>
> 	close(fd);
>-	free(data);
>+
>+	if (zerocopy)
>+		munmap(data, buf_size_bytes);
>+	else
>+		free(data);
> }
>
> static const char optstring[] = "";
>@@ -336,6 +440,11 @@ static const struct option longopts[] = {
> 		.has_arg = required_argument,
> 		.val = 'R',
> 	},
>+	{
>+		.name = "zc",
>+		.has_arg = no_argument,
>+		.val = 'Z',
>+	},
> 	{},
> };
>
>@@ -351,6 +460,7 @@ static void usage(void)
> 	       "  --help			This message\n"
> 	       "  --sender   <cid>		Sender mode (receiver default)\n"
> 	       "                                <cid> of the receiver to connect to\n"
>+	       "  --zc				Enable zerocopy\n"
> 	       "  --port     <port>		Port (default %d)\n"
> 	       "  --bytes    <bytes>KMG		Bytes to send (default %d)\n"
> 	       "  --buf-size <bytes>KMG		Data buffer size (default %d). In sender mode\n"
>@@ -413,6 +523,9 @@ int main(int argc, char **argv)
> 		case 'H': /* Help. */
> 			usage();
> 			break;
>+		case 'Z': /* Zerocopy. */
>+			zerocopy = true;
>+			break;
> 		default:
> 			usage();
> 		}
>-- 
>2.25.1
>

