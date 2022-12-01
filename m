Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD6163ED97
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiLAKXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiLAKXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:23:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853F322280
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 02:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669890126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xoPax3jULmyNPRBQAOAyG4eZNgpJaR2/NZ388qv7Cls=;
        b=WxXzAaa24w+lyvtHyTx6nH6B77Cgq+UHaps9iJqPchfHOiBzRaXwlqbeTwG0Kl25i/IsL9
        bbbBMLpb7oFiFbX87bhpHwRLV2oNTGmtEqX0IregZiVMIrefNAuMLv8DXUAJGY51xlTY1W
        bf8Vch456kTAlG8yGF0FzyDM4ovv5R8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-664-qIXeEdGzNlmFqOq7Bo4s_Q-1; Thu, 01 Dec 2022 05:22:05 -0500
X-MC-Unique: qIXeEdGzNlmFqOq7Bo4s_Q-1
Received: by mail-wr1-f70.google.com with SMTP id j29-20020adfb31d000000b0024237066261so274573wrd.14
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 02:22:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xoPax3jULmyNPRBQAOAyG4eZNgpJaR2/NZ388qv7Cls=;
        b=2OvgPhRwmxmbuhdrrXmK3lZ3ZmUdxNyyCmx/CxNn0pi3XsOCmMuCUQbhAB3VzOjS6D
         cr74LRS+oGinw+UsmpDgZfn9jT75+Wt63hwg1dxivj2OQoQ2ZTqDoXEQaHJiIlLxFLeO
         pmXRfkqCEfseYezQ+4Tv/jQZVgnRFDOV6gk+3TVlL2zVKnVNmXqHGlcCsIExhSF78keE
         CvRs9l64RbIL6vDDcGtfmcIfo00fNSN5ijdigPxlSO4pNOlzCZjrsP61q1cPs+ouW1Ab
         DNl/8qFuRni4XaqfQ/k2sQeE9r+HIx1a0GbEjW12nSf7sAivByUOsJMkLl9/FpNpkKVb
         KmUA==
X-Gm-Message-State: ANoB5pnTgANf5BVFzxvbzWFMQlrEERldILDE+x/gbsUmvwAO4NheEeU4
        jzNWcsmCv1JLTBwM9uZZbI90j7M05ANe+IUbZZRnQ2pC5ukBG1+mFtcJ1fwQQhAw/swsR65Rt3L
        1AVcYp2AUtLFbsuTx
X-Received: by 2002:a05:6000:1e0f:b0:238:3d2a:cd12 with SMTP id bj15-20020a0560001e0f00b002383d2acd12mr40496802wrb.172.1669890124101;
        Thu, 01 Dec 2022 02:22:04 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7/6SPLV7WLGix8AFoMaorddK5kjKey9+TIwMrbhpSJanYvm2KPLO+aCIKGzA9h0jZku9ccUw==
X-Received: by 2002:a05:6000:1e0f:b0:238:3d2a:cd12 with SMTP id bj15-20020a0560001e0f00b002383d2acd12mr40496782wrb.172.1669890123810;
        Thu, 01 Dec 2022 02:22:03 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id d10-20020adffbca000000b002366f9bd717sm4862207wrs.45.2022.12.01.02.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 02:22:03 -0800 (PST)
Date:   Thu, 1 Dec 2022 11:21:53 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v2 6/6] test/vsock: vsock_perf utility
Message-ID: <20221201102153.nhi3xw7gkabdckfc@sgarzare-redhat>
References: <9d96f6c6-1d4f-8197-b3bc-8957124c8933@sberdevices.ru>
 <93a19249-e3f3-c1f8-c58a-0f549b94f1b5@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <93a19249-e3f3-c1f8-c58a-0f549b94f1b5@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 05:15:08PM +0000, Arseniy Krasnov wrote:
>This adds utility to check vsock rx/tx performance.
>
>Usage as sender:
>./vsock_perf -p <port> -m <bytes to send)
>Usage as receiver:
>./vsock_perf -c <cid> -p <port> -r <SO_RCVLOWAT>
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/Makefile     |   1 +
> tools/testing/vsock/README       |  34 +++
> tools/testing/vsock/vsock_perf.c | 400 +++++++++++++++++++++++++++++++
> 3 files changed, 435 insertions(+)
> create mode 100644 tools/testing/vsock/vsock_perf.c
>
>diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
>index f8293c6910c9..d36fdd59fe2e 100644
>--- a/tools/testing/vsock/Makefile
>+++ b/tools/testing/vsock/Makefile
>@@ -3,6 +3,7 @@ all: test
> test: vsock_test vsock_diag_test
> vsock_test: vsock_test.o timeout.o control.o util.o
> vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
>+vsock_perf: vsock_perf.o
>
> CFLAGS += -g -O2 -Werror -Wall -I. -I../../include -I../../../usr/include -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE
> .PHONY: all test clean
>diff --git a/tools/testing/vsock/README b/tools/testing/vsock/README
>index 4d5045e7d2c3..dbeba1d62016 100644
>--- a/tools/testing/vsock/README
>+++ b/tools/testing/vsock/README
>@@ -35,3 +35,37 @@ Invoke test binaries in both directions as follows:
>                        --control-port=$GUEST_IP \
>                        --control-port=1234 \
>                        --peer-cid=3

I'm not a native speaker, so the suggestions below may be wrong.

>+
>+vsock_perf utility
>+-------------------
>+'vsock_perf' is simple tool to measure vsock performance. It works in

is a simple tool

>+sender/receiver modes: sender waits for connection at specified port,
>+and after accept, starts data transmission to receiver. After data
   ^
and after accepting it
                                              ^
                                              to the receiver

>+processing is done, it prints several metrics(see below).
>+
>+Usage:
>+# run as sender
>+# listen port 1234, tx buffer size is 1MB, send of data 1G
>+./vsock_perf -s -p 1234 -b 1MB -m 1G

Like for vsock_test and vsock_diag_test I would use only the long form 
for the parameters (e.g. --sender, --port, etc.)

>+
>+Output:
>+tx performance: A Gb/s
>+
>+Output explanation:
>+A is calculated as "number of bytes to send" / "time in tx loop"
>+
>+# run as receiver
>+# connect to CID 2, port 1234, rx buffer size is 1MB, peer buf is 1G, SO_RCVLOWAT is 65536
>+./vsock_perf -c 2 -p 1234 -b 1MB -v 1G -r 65536
>+
>+Output:
>+rx performance: A Gb/s
>+total in 'read()': B sec
>+POLLIN wakeups: C
>+average in 'read()': D ns
>+
>+Output explanation:
>+A is calculated as "number of received bytes" / "time in rx loop".
>+B is time, spent in 'read()' system call(excluding 'poll()')
>+C is number of 'poll()' wake ups with POLLIN bit set.
>+D is B / C, e.g. average amount of time, spent in single 'read()'.
>diff --git a/tools/testing/vsock/vsock_perf.c b/tools/testing/vsock/vsock_perf.c
>new file mode 100644
>index 000000000000..bca2027de52d
>--- /dev/null
>+++ b/tools/testing/vsock/vsock_perf.c
>@@ -0,0 +1,400 @@
>+// SPDX-License-Identifier: GPL-2.0-only
>+/*
>+ * vsock_perf - benchmark utility for vsock.
>+ *
>+ * Copyright (C) 2022 SberDevices.
>+ *
>+ * Author: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>+ */
>+#include <getopt.h>
>+#include <stdio.h>
>+#include <stdlib.h>
>+#include <stdbool.h>
>+#include <string.h>
>+#include <errno.h>
>+#include <unistd.h>
>+#include <time.h>
>+#include <sys/mman.h>
>+#include <stdint.h>
>+#include <poll.h>
>+#include <sys/socket.h>
>+#include <linux/vm_sockets.h>
>+
>+#define DEFAULT_BUF_SIZE_BYTES	(128 * 1024)
>+#define DEFAULT_TO_SEND_BYTES	(64 * 1024)
>+#define DEFAULT_VSOCK_BUF_BYTES (256 * 1024)
>+#define DEFAULT_RCVLOWAT_BYTES	1
>+#define DEFAULT_PORT		1234
>+#define DEFAULT_CID		2
>+
>+#define BYTES_PER_GB		(1024 * 1024 * 1024ULL)
>+#define NSEC_PER_SEC		(1000000000ULL)
>+
>+static unsigned int port = DEFAULT_PORT;
>+static unsigned long buf_size_bytes = DEFAULT_BUF_SIZE_BYTES;
>+static unsigned long vsock_buf_bytes = DEFAULT_VSOCK_BUF_BYTES;
>+
>+static inline time_t current_nsec(void)
>+{
>+	struct timespec ts;
>+
>+	if (clock_gettime(CLOCK_REALTIME, &ts)) {
>+		perror("clock_gettime");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	return (ts.tv_sec * NSEC_PER_SEC) + ts.tv_nsec;
>+}
>+
>+/* From lib/cmdline.c. */
>+static unsigned long memparse(const char *ptr)
>+{
>+	char *endptr;
>+
>+	unsigned long long ret = strtoull(ptr, &endptr, 0);
>+
>+	switch (*endptr) {
>+	case 'E':
>+	case 'e':
>+		ret <<= 10;
>+	case 'P':
>+	case 'p':
>+		ret <<= 10;
>+	case 'T':
>+	case 't':
>+		ret <<= 10;
>+	case 'G':
>+	case 'g':
>+		ret <<= 10;
>+	case 'M':
>+	case 'm':
>+		ret <<= 10;
>+	case 'K':
>+	case 'k':
>+		ret <<= 10;
>+		endptr++;
>+	default:
>+		break;
>+	}
>+
>+	return ret;
>+}
>+
>+static void vsock_increase_buf_size(int fd)
>+{
>+	if (setsockopt(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
>+		       &vsock_buf_bytes, sizeof(vsock_buf_bytes))) {
>+		perror("setsockopt");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (setsockopt(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
>+		       &vsock_buf_bytes, sizeof(vsock_buf_bytes))) {
>+		perror("setsockopt");
>+		exit(EXIT_FAILURE);
>+	}
>+}
>+
>+static int vsock_connect(unsigned int cid, unsigned int port)
>+{
>+	union {
>+		struct sockaddr sa;
>+		struct sockaddr_vm svm;
>+	} addr = {
>+		.svm = {
>+			.svm_family = AF_VSOCK,
>+			.svm_port = port,
>+			.svm_cid = cid,
>+		},
>+	};
>+	int fd;
>+
>+	fd = socket(AF_VSOCK, SOCK_STREAM, 0);
>+
>+	if (fd < 0)
>+		return -1;
>+
>+	vsock_increase_buf_size(fd);
>+
>+	if (connect(fd, &addr.sa, sizeof(addr.svm)) < 0) {
>+		close(fd);
>+		return -1;
>+	}
>+
>+	return fd;
>+}
>+
>+static float get_gbps(unsigned long bytes, time_t ns_delta)
>+{
>+	return ((float)bytes / BYTES_PER_GB) /
>+	       ((float)ns_delta / NSEC_PER_SEC);
>+}
>+
>+static void run_sender(unsigned long to_send_bytes)
>+{
>+	time_t tx_begin_ns;
>+	size_t total_send;
>+	int client_fd;
>+	char *data;
>+	int fd;
>+	union {
>+		struct sockaddr sa;
>+		struct sockaddr_vm svm;
>+	} addr = {
>+		.svm = {
>+			.svm_family = AF_VSOCK,
>+			.svm_port = port,
>+			.svm_cid = VMADDR_CID_ANY,
>+		},
>+	};
>+	union {
>+		struct sockaddr sa;
>+		struct sockaddr_vm svm;
>+	} clientaddr;
>+
>+	socklen_t clientaddr_len = sizeof(clientaddr.svm);
>+
>+	printf("Run as sender\n");
>+	printf("Listen port %u\n", port);
>+	printf("Send %lu bytes\n", to_send_bytes);
>+	printf("TX buffer %lu bytes\n", buf_size_bytes);
>+	printf("Peer buffer %lu bytes\n", vsock_buf_bytes);
>+
>+	fd = socket(AF_VSOCK, SOCK_STREAM, 0);
>+
>+	if (fd < 0) {
>+		perror("socket");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
>+		perror("bind");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (listen(fd, 1) < 0) {
>+		perror("listen");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	client_fd = accept(fd, &clientaddr.sa, &clientaddr_len);
>+
>+	if (client_fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	vsock_increase_buf_size(client_fd);
>+
>+	data = malloc(buf_size_bytes);
>+
>+	if (!data) {
>+		printf("malloc failed\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	memset(data, 0, buf_size_bytes);
>+	total_send = 0;
>+	tx_begin_ns = current_nsec();
>+
>+	while (total_send < to_send_bytes) {
>+		ssize_t sent;
>+
>+		sent = write(client_fd, data, buf_size_bytes);
>+
>+		if (sent <= 0) {
>+			perror("write");
>+			exit(EXIT_FAILURE);
>+		}
>+
>+		total_send += sent;
>+	}
>+
>+	printf("tx performance: %f Gb/s\n",
>+	       get_gbps(total_send, current_nsec() - tx_begin_ns));
>+
>+	close(client_fd);
>+	close(fd);
>+
>+	free(data);
>+}
>+
>+static void run_receiver(int peer_cid, unsigned long rcvlowat_bytes)
>+{
>+	unsigned int read_cnt;
>+	time_t rx_begin_ns;
>+	time_t in_read_ns;
>+	size_t total_recv;
>+	void *data;
>+	int fd;
>+
>+	printf("Run as receiver\n");
>+	printf("Connect to %i:%u\n", peer_cid, port);
>+	printf("RX buffer %lu bytes\n", buf_size_bytes);
>+	printf("Peer buffer %lu bytes\n", vsock_buf_bytes);
>+	printf("SO_RCVLOWAT %lu bytes\n", rcvlowat_bytes);
>+
>+	fd = vsock_connect(peer_cid, port);
>+
>+	if (fd < 0) {
>+		perror("socket");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (setsockopt(fd, SOL_SOCKET, SO_RCVLOWAT,
>+		       &rcvlowat_bytes,
>+		       sizeof(rcvlowat_bytes))) {
>+		perror("setsockopt");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	data = mmap(NULL, buf_size_bytes, PROT_READ | PROT_WRITE,
>+		    MAP_ANONYMOUS | MAP_PRIVATE | MAP_POPULATE, -1, 0);
>+
>+	if (data == MAP_FAILED) {
>+		perror("mmap");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	read_cnt = 0;
>+	in_read_ns = 0;
>+	total_recv = 0;
>+	rx_begin_ns = current_nsec();
>+
>+	while (1) {
>+		struct pollfd fds = { 0 };
>+
>+		fds.fd = fd;
>+		fds.events = POLLIN | POLLERR | POLLHUP |
>+			     POLLRDHUP | POLLNVAL;
>+
>+		if (poll(&fds, 1, -1) < 0) {
>+			perror("poll");
>+			exit(EXIT_FAILURE);
>+		}
>+
>+		if (fds.revents & POLLERR) {
>+			printf("'poll()' error\n");
>+			exit(EXIT_FAILURE);
>+		}
>+
>+		if (fds.revents & POLLIN) {
>+			ssize_t bytes_read;
>+			time_t t;
>+
>+			t = current_nsec();
>+			bytes_read = read(fd, data, buf_size_bytes);
>+			in_read_ns += (current_nsec() - t);
>+			read_cnt++;
>+
>+			if (!bytes_read)
>+				break;
>+
>+			if (bytes_read < 0) {
>+				perror("recv");
>+				exit(EXIT_FAILURE);
>+			}
>+
>+			total_recv += bytes_read;
>+		}
>+
>+		if (fds.revents & (POLLHUP | POLLRDHUP))
>+			break;
>+	}
>+
>+	printf("rx performance: %f Gb/s\n",
>+	       get_gbps(total_recv, current_nsec() - rx_begin_ns));
>+	printf("total in 'read()': %f sec\n", (float)in_read_ns / NSEC_PER_SEC);

Maybe better "total time in ..."

>+	printf("POLLIN wakeups: %i\n", read_cnt);
>+	printf("average in 'read()': %f ns\n", (float)in_read_ns / read_cnt);

Ditto.

>+
>+	munmap(data, buf_size_bytes);
>+	close(fd);
>+}
>+
>+static void usage(void)
>+{
>+	printf("Help:\n"
>+	       "\n"
>+	       "This is benchmarking utility, to test vsock performance.\n"
>+	       "It runs in two modes: sender or receiver. In sender mode, it waits\n"
>+	       "connection from receiver, and when established, sender starts data\n"
>+	       "transmission.\n"
>+	       "\n"
>+	       "Options:\n"
>+	       "  -h				This help message\n"
>+	       "  -s				Sender mode(receiver default)\n"
>+	       "  -p <port>			Port (%d)\n"
>+	       "  -c <cid>			CID of the peer (%d)\n"
>+	       "  -m <bytes to send>		Bytes to send (%d)\n"
>+	       "  -b <buffer size>		Rx/Tx buffer size (%d). In sender mode\n"
>+	       "                                it is size of buffer passed to 'write()'.\n"
>+	       "                                In receiver mode it is size of buffer passed\n"
>+	       "                                to 'read()'.\n"
>+	       "  -v <peer buffer size>		Peer buffer size (%d)\n"

Instead of "peer buffer", what about "socket buffer"?

>+	       "  -r <SO_RCVLOWAT>		SO_RCVLOWAT (%d)\n"
>+	       "\n", DEFAULT_PORT, DEFAULT_CID, DEFAULT_TO_SEND_BYTES,
>+	       DEFAULT_BUF_SIZE_BYTES, DEFAULT_VSOCK_BUF_BYTES,
>+	       DEFAULT_RCVLOWAT_BYTES);
>+	exit(EXIT_FAILURE);
>+}
>+
>+static long strtolx(const char *arg)
>+{
>+	long value;
>+	char *end;
>+
>+	value = strtol(arg, &end, 10);
>+
>+	if (end != arg + strlen(arg))
>+		usage();
>+
>+	return value;
>+}
>+
>+int main(int argc, char **argv)
>+{
>+	unsigned long to_send_bytes = DEFAULT_TO_SEND_BYTES;
>+	unsigned long rcvlowat_bytes = DEFAULT_RCVLOWAT_BYTES;
>+	bool receiver_mode = true;
>+	int peer_cid = DEFAULT_CID;
>+	int c;
>+
>+	while ((c = getopt(argc, argv, "v:r:c:p:m:b:sh")) != -1) {
>+		switch (c) {
>+		case 'v': /* Peer buffer size. */
>+			vsock_buf_bytes = memparse(optarg);
>+			break;
>+		case 'r': /* SO_RCVLOWAT value. */
>+			rcvlowat_bytes = memparse(optarg);
>+			break;
>+		case 'c': /* CID to connect to. */
>+			peer_cid = strtolx(optarg);
>+			break;
>+		case 'p': /* Port to connect to. */
>+			port = strtolx(optarg);
>+			break;
>+		case 'm': /* Bytes to send. */
>+			to_send_bytes = memparse(optarg);
>+			break;
>+		case 'b': /* Size of rx/tx buffer. */
>+			buf_size_bytes = memparse(optarg);
>+			break;
>+		case 's': /* Sender mode. */
>+			receiver_mode = false;
>+			break;
>+		case 'h': /* Help. */
>+			usage();
>+			break;
>+		default:
>+			usage();
>+		}
>+	}
>+
>+	if (receiver_mode)
>+		run_receiver(peer_cid, rcvlowat_bytes);
>+	else
>+		run_sender(to_send_bytes);
>+
>+	return 0;
>+}
>-- 
>2.25.1

