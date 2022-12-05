Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0617642A06
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 15:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiLEOBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 09:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiLEOBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 09:01:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6894C11C33
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 06:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670248817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8OCKUcvVUiiQ7IfzEODOSINfUx7armQoVZuIx3qsy5I=;
        b=ECBxrFKMZvdkf+FF6h7wXaAhPO8ChPa6PCQnS9MnACoSvxRYB/UrgDw1+THUhVGjg6oY+W
        OOPQzx9Bvtdk9XCW04cctoIM7iVw2y/PCBo1rp4jmG0shGxDneM9SMCc7PWivqBubyj4NM
        /qeBlBIVeIyDyIipbwrMh23I7jHPm9M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-99-JyS-wpNSMXiQM-Epg0VyAQ-1; Mon, 05 Dec 2022 09:00:16 -0500
X-MC-Unique: JyS-wpNSMXiQM-Epg0VyAQ-1
Received: by mail-wm1-f70.google.com with SMTP id r203-20020a1c44d4000000b003d153a83d27so2763859wma.0
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 06:00:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8OCKUcvVUiiQ7IfzEODOSINfUx7armQoVZuIx3qsy5I=;
        b=AGuq/u47EVboqJQTsjGGFRquziQCIG8wkMBhRofGgop0iS0kIgbC2eA1m1/ItQmxui
         TDRMgeERmQjqBpg2j2Jc0ooCGH0vv726QD/A/LaDgqyTkB8wrdpLR7VXlvfXML28LmCI
         7hZBGVR60dq5M1mf4rJbJBO3QbBlKs+a63EPtnrdwR0k12iUqROvdKKPGjqCZvote6Y+
         ocGUFTDAquDo4K7Wb1dZwDV+nHdip3WQHpvByb6BOi+q8R0/hn1LIcYdVaZW9DOenUNI
         UCL5SXWE1xhrHVrv8HJqo3j02X/K327SWL4xXF3BAR4iXN26Wu3w3iOQvlFV3MiNYDgO
         zXqQ==
X-Gm-Message-State: ANoB5pkWMQlzOSV8E9eK6GnVvzaU6F7o2exe3MCaf7gnf036WCTCTs2C
        x2n9fYrzJTRo42ZEP3k1v5PXL1LEOuGvdHzNnXVujOOaNQnwBpRrFA9G7yOkXxeFVuKaM1vKt/c
        KCSlSJxpat74i6EiW
X-Received: by 2002:a5d:48c3:0:b0:241:784b:1b7f with SMTP id p3-20020a5d48c3000000b00241784b1b7fmr52016016wrs.38.1670248814961;
        Mon, 05 Dec 2022 06:00:14 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4PptkJ602kvEF0ImAHsmpZ3A+evn3kXI2mb1oedVpx07OIOZE15VzNBFrSlPJxLpHVvVjmHQ==
X-Received: by 2002:a5d:48c3:0:b0:241:784b:1b7f with SMTP id p3-20020a5d48c3000000b00241784b1b7fmr52015991wrs.38.1670248814636;
        Mon, 05 Dec 2022 06:00:14 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id y15-20020a5d4acf000000b00241e5b917d0sm17246682wrs.36.2022.12.05.06.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 06:00:14 -0800 (PST)
Date:   Mon, 5 Dec 2022 15:00:03 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 4/4] test/vsock: vsock_perf utility
Message-ID: <20221205140003.lhtnwoozwaudjfd6@sgarzare-redhat>
References: <6bd77692-8388-8693-f15f-833df1fa6afd@sberdevices.ru>
 <9cc7610f-bcf5-6f77-96fe-4239efb67ca7@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9cc7610f-bcf5-6f77-96fe-4239efb67ca7@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 07:24:33PM +0000, Arseniy Krasnov wrote:
>This adds utility to check vsock rx/tx performance.
>
>Usage as sender:
>./vsock_perf --port <port> --mb <bytes to send)
>Usage as receiver:
>./vsock_perf --cid <cid> --port <port> --so_rcvlowat <SO_RCVLOWAT>
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/Makefile     |   1 +
> tools/testing/vsock/README       |  34 +++
> tools/testing/vsock/vsock_perf.c | 449 +++++++++++++++++++++++++++++++
> 3 files changed, 484 insertions(+)
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

I think we can add "vsock_perf" to "all" target.

>
> CFLAGS += -g -O2 -Werror -Wall -I. -I../../include -I../../../usr/include -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE
> .PHONY: all test clean
>diff --git a/tools/testing/vsock/README b/tools/testing/vsock/README
>index 4d5045e7d2c3..64c5757b7ecc 100644
>--- a/tools/testing/vsock/README
>+++ b/tools/testing/vsock/README
>@@ -35,3 +35,37 @@ Invoke test binaries in both directions as follows:
>                        --control-port=$GUEST_IP \
>                        --control-port=1234 \
>                        --peer-cid=3
>+
>+vsock_perf utility
>+-------------------
>+'vsock_perf' is a simple tool to measure vsock performance. It works in
>+sender/receiver modes: sender waits for connection at specified port,
>+and after accepting it, starts data transmission to the receiver. After data
>+processing is done, it prints several metrics(see below).
>+
>+Usage:
>+# run as sender
>+# listen port 1234, tx buffer size is 1MB, send of 1G data
>+./vsock_perf --sender --port 1234 --buf-size 1MB --mb 1G
>+
>+Output:
>+tx performance: A Gb/s
>+
>+Output explanation:
>+A is calculated as "number of bytes to send" / "time in tx loop"
>+
>+# run as receiver
>+# connect to CID 2, port 1234, rx buffer size is 1MB, peer buf is 1G, SO_RCVLOWAT is 65536
>+./vsock_perf --cid 2 --port 1234 --buf-size 1MB --vsk-size 1G -so_rcvlowat 65536
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
>index 000000000000..69e3b24868d7
>--- /dev/null
>+++ b/tools/testing/vsock/vsock_perf.c
>@@ -0,0 +1,449 @@
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

As for the previous patch, I would add the opt that is failing to make 
it easier to analyze in case of failure.

>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (setsockopt(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
>+		       &vsock_buf_bytes, sizeof(vsock_buf_bytes))) {
>+		perror("setsockopt");

Ditto.

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
>+	printf("total time in 'read()': %f sec\n", (float)in_read_ns / NSEC_PER_SEC);
>+	printf("POLLIN wakeups: %i\n", read_cnt);
>+	printf("average time in 'read()': %f ns\n", (float)in_read_ns / read_cnt);
>+
>+	munmap(data, buf_size_bytes);
>+	close(fd);
>+}
>+
>+static const char optstring[] = "";
>+static const struct option longopts[] = {
>+	{
>+		.name = "help",
>+		.has_arg = no_argument,
>+		.val = 'H',
>+	},
>+	{
>+		.name = "sender",
>+		.has_arg = no_argument,
>+		.val = 'S',
>+	},
>+	{
>+		.name = "port",
>+		.has_arg = required_argument,
>+		.val = 'P',
>+	},
>+	{
>+		.name = "cid",
>+		.has_arg = required_argument,
>+		.val = 'C',
>+	},
>+	{
>+		.name = "mb",
>+		.has_arg = required_argument,
>+		.val = 'M',
>+	},
>+	{
>+		.name = "buf-size",
>+		.has_arg = required_argument,
>+		.val = 'B',
>+	},
>+	{
>+		.name = "vsk-size",
>+		.has_arg = required_argument,
>+		.val = 'V',
>+	},
>+	{
>+		.name = "so_rcvlowat",
>+		.has_arg = required_argument,
>+		.val = 'R',
>+	},
>+	{},
>+};
>+
>+static void usage(void)
>+{
>+	printf("Help:\n"

Instead of "Help:" I would start with:
"Usage: vsock_perf [--help] [options]"


>+	       "\n"
>+	       "This is benchmarking utility, to test vsock performance.\n"
>+	       "It runs in two modes: sender or receiver. In sender mode, it waits\n"
>+	       "connection from receiver, and when established, sender starts data\n"
>+	       "transmission.\n"
>+	       "\n"
>+	       "Options:\n"
>+	       "  --help			This help message\n"
>+	       "  --sender			Sender mode(receiver default)\n"
                                                            ^ space here 
>+	       "  --port <port>			Port (%d)\n"
>+	       "  --cid <cid>			CID of the peer (%d)\n"

IIUC --cid can be used only by the receiver, so maybe better to use
"CID of the sender to connect to"

What about make the sender initiate the connection, while the receiver
listens?
So we could remove "--cid" and use only --sender:

         --sender <cid>       Sender mode (receiver default).
                              <cid> of the receiver to connect to.

And of course updating the description above.


>+	       "  --mb <bytes to send>		Bytes to send (%d)\n"

I would use --bytes and also add KMG as suffix (in all places where
supported).

E.g.              --bytes <bytes to send>KMG    Bytes to send ...

>+	       "  --buf-size <buffer size>	Rx/Tx buffer size (%d). In sender mode\n"
>+	       "                                it is size of buffer passed to 'write()'.\n"

"it is the buffer size"

>+	       "                                In receiver mode it is size of buffer passed\n"

Ditto.

>+	       "                                to 'read()'.\n"
>+	       "  --vsk-size <peer buffer size>	Socket buffer size (%d)\n"
>+	       "  --so_rcvlowat <SO_RCVLOWAT>	SO_RCVLOWAT (%d)\n"

"--rcvlowat <SO_RCVLOWAT>    SO_RCVLOWAT value in bytes"

>+	       "\n", DEFAULT_PORT, DEFAULT_CID, DEFAULT_TO_SEND_BYTES,
>+	       DEFAULT_BUF_SIZE_BYTES, DEFAULT_VSOCK_BUF_BYTES,
>+	       DEFAULT_RCVLOWAT_BYTES);

For the defaults values I would use (default: %d), otherwise is not
clear what that values are.

The rest LGTM!

Thanks,
Stefano

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
>+
>+	while (1) {
>+		int opt = getopt_long(argc, argv, optstring, longopts, NULL);
>+
>+		if (opt == -1)
>+			break;
>+
>+		switch (opt) {
>+		case 'V': /* Peer buffer size. */
>+			vsock_buf_bytes = memparse(optarg);
>+			break;
>+		case 'R': /* SO_RCVLOWAT value. */
>+			rcvlowat_bytes = memparse(optarg);
>+			break;
>+		case 'C': /* CID to connect to. */
>+			peer_cid = strtolx(optarg);
>+			break;
>+		case 'P': /* Port to connect to. */
>+			port = strtolx(optarg);
>+			break;
>+		case 'M': /* Bytes to send. */
>+			to_send_bytes = memparse(optarg);
>+			break;
>+		case 'B': /* Size of rx/tx buffer. */
>+			buf_size_bytes = memparse(optarg);
>+			break;
>+		case 'S': /* Sender mode. */
>+			receiver_mode = false;
>+			break;
>+		case 'H': /* Help. */
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

