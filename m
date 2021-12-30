Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B67481ECC
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 18:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241554AbhL3RvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 12:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241558AbhL3RvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 12:51:00 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9F1C061756;
        Thu, 30 Dec 2021 09:50:59 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id a23so22032037pgm.4;
        Thu, 30 Dec 2021 09:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fz9vy7/aGEiUYf9pqOatTXUfbGE4vFMqOfv+wqNuBPo=;
        b=OFK7K3bj8a71PfLQC3FaToXZ19PqrSd9Wdr4xXqeXO4H03WV1QPDdoC/iL2Z9EUCc2
         VRhoSQbngfAZg1zPYGJYY2NQlF28qZ6sMdI/aqD9OdAT3Noy5howVHkOaJiUoPl4qI+g
         y/Tg3uh1LLB16ApzIA2j5sNi/1qSBcFsFWak/rHSusv13hyuyqIQfbinyIe4V6WB33wo
         Z5nBDdiG5SiAHSH1iMpFt4giCdppWYnV6Il+k472IEIUvV07dD12coCU1jAHJqkvyqK3
         fLCOk2eoK8PfZk5Hu2d6j1VOMLmFFy4W/hOWBWz7zp1ibqoTqfNTKXgzUXOwu6YwWhM6
         uzLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fz9vy7/aGEiUYf9pqOatTXUfbGE4vFMqOfv+wqNuBPo=;
        b=PQ1QDGC29VT3srnbPNb+FziLgbVBoZZSyr6ageO1Py8WZvTFLW3s4lt58p06KEDj1+
         UeOPqgqX/d3k7FLGJSBgETAgGtzvhreR0aTtyBBoRjDHwwat+J4TpqTGlVxKjd5JznAU
         cn2SoUEEhKYUSxgLLinrDrU/gCS6INqDvwisQ8nhXGYSxMI/uAc/ilSmGJjTEQ5fpTTX
         Sk4mvbZBeOsGGIHUcfq9DlN/lA4kDDpGeUxhghxAc17zO888U3kgcFSlbzHhsXW6cQpD
         cqgiqj80pvKg3w7uMulMQKx2ab0VO5+9vvitr5tw3JwhP5vvYq44hBp/3kNTTPWCy7ix
         AUeg==
X-Gm-Message-State: AOAM531ouBSUShLDp7AC4K6gTJFfbbVDlCvOjdobnvzaDaO04IMeAWrC
        zAnT5d/mCyWpYO3RIYZV6UKbLhnQhiGj/g==
X-Google-Smtp-Source: ABdhPJyUawROy3Zq8oZLjL8lgxurbqWkGAZ0xYzp6dEmZar09jXrcHGL1AW65InF086NVhXjWIaBcQ==
X-Received: by 2002:a62:b503:0:b0:4bc:1f47:3b26 with SMTP id y3-20020a62b503000000b004bc1f473b26mr12460162pfe.9.1640886658858;
        Thu, 30 Dec 2021 09:50:58 -0800 (PST)
Received: from integral2.. ([180.254.126.2])
        by smtp.gmail.com with ESMTPSA id s34sm29980811pfg.198.2021.12.30.09.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 09:50:58 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        Nugra <richiisei@gmail.com>
Subject: [RFC PATCH liburing v1 4/5] test: Add sendto_recvfrom test program
Date:   Fri, 31 Dec 2021 00:50:18 +0700
Message-Id: <20211230174548.178641-5-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211230174548.178641-1-ammar.faizi@intel.com>
References: <20211230174548.178641-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test program for `IORING_OP_SENDTO` and `IORING_OP_RECVFROM`.

This test is based on `send_recv` test. Additional thing that needs
extra attention here is that `sendto` and `recvfrom` can specify
explicit destination and source.

Apart from that, it is exactly the same with `send` and `recv`, but
with 5-th and 6-th argument be zero.

IOW:
  `recv(sockfd, buf, len, flags)` call

is equivalent to:

  `recvfrom(sockfd, buf, len, flags, NULL, NULL)` call.

And
  `send(sockfd, buf, len, flags)` call

is equivalent to:

  `sendto(sockfd, buf, len, flags, NULL, 0)` call.

Tested-by: Nugra <richiisei@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
 .gitignore             |   1 +
 test/Makefile          |   2 +
 test/sendto_recvfrom.c | 384 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 387 insertions(+)
 create mode 100644 test/sendto_recvfrom.c

diff --git a/.gitignore b/.gitignore
index 4e70f20..6fe0df2 100644
--- a/.gitignore
+++ b/.gitignore
@@ -98,6 +98,7 @@
 /test/send_recv
 /test/send_recvmsg
 /test/sendmsg_fs_cve
+/test/sendto_recvfrom
 /test/shared-wq
 /test/short-read
 /test/shutdown
diff --git a/test/Makefile b/test/Makefile
index 357c9f7..48c8182 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -118,6 +118,7 @@ test_srcs := \
 	rw_merge_test.c \
 	self.c \
 	sendmsg_fs_cve.c \
+	sendto_recvfrom.c \
 	send_recv.c \
 	send_recvmsg.c \
 	shared-wq.c \
@@ -219,6 +220,7 @@ thread-exit: override LDFLAGS += -lpthread
 ring-leak2: override LDFLAGS += -lpthread
 poll-mshot-update: override LDFLAGS += -lpthread
 exit-no-cleanup: override LDFLAGS += -lpthread
+sendto_recvfrom: override LDFLAGS += -lpthread
 
 install: $(test_targets) runtests.sh runtests-loop.sh
 	$(INSTALL) -D -d -m 755 $(datadir)/liburing-test/
diff --git a/test/sendto_recvfrom.c b/test/sendto_recvfrom.c
new file mode 100644
index 0000000..720f52f
--- /dev/null
+++ b/test/sendto_recvfrom.c
@@ -0,0 +1,384 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Simple test case showing using sendto and recvfrom through io_uring
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <arpa/inet.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <pthread.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+static char str[] = "This is a test of sendto and recvfrom over io_uring!";
+
+#define MAX_MSG	128
+
+#define PORT2	10201
+#define PORT	10200
+#define HOST	"127.0.0.1"
+
+struct recvfrom_data {
+	pthread_mutex_t mutex;
+	int use_sqthread;
+	int registerfiles;
+	int explicit_dst_src;
+	struct sockaddr_in recvfrom_src;
+};
+
+static int recvfrom_prep(struct io_uring *ring, struct iovec *iov, int *sock,
+			 struct recvfrom_data *rd)
+{
+	struct sockaddr_in saddr;
+	struct sockaddr *saddr_p;
+	socklen_t *saddr_len_p;
+	socklen_t saddr_len;
+	struct io_uring_sqe *sqe;
+	int sockfd, ret, val, use_fd;
+
+	memset(&saddr, 0, sizeof(saddr));
+	saddr.sin_family = AF_INET;
+	saddr.sin_addr.s_addr = htonl(INADDR_ANY);
+	saddr.sin_port = htons(PORT);
+
+	sockfd = socket(AF_INET, SOCK_DGRAM, 0);
+	if (sockfd < 0) {
+		perror("socket");
+		return 1;
+	}
+
+	val = 1;
+	setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
+
+	ret = bind(sockfd, (struct sockaddr *)&saddr, sizeof(saddr));
+	if (ret < 0) {
+		perror("bind");
+		goto err;
+	}
+
+	if (rd->explicit_dst_src) {
+		memset(&rd->recvfrom_src, 0, sizeof(rd->recvfrom_src));
+		saddr_len = sizeof(rd->recvfrom_src);
+		saddr_p = (struct sockaddr *) &rd->recvfrom_src;
+		saddr_len_p = &saddr_len;
+	} else {
+		saddr_p = NULL;
+		saddr_len_p = NULL;
+	}
+
+	if (rd->registerfiles) {
+		ret = io_uring_register_files(ring, &sockfd, 1);
+		if (ret) {
+			fprintf(stderr, "file reg failed\n");
+			goto err;
+		}
+		use_fd = 0;
+	} else {
+		use_fd = sockfd;
+	}
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_recvfrom(sqe, use_fd, iov->iov_base, iov->iov_len, 0,
+			       saddr_p, saddr_len_p);
+
+	if (rd->registerfiles)
+		sqe->flags |= IOSQE_FIXED_FILE;
+	sqe->user_data = 2;
+
+	ret = io_uring_submit(ring);
+	if (ret <= 0) {
+		fprintf(stderr, "submit failed: %d\n", ret);
+		goto err;
+	}
+
+	*sock = sockfd;
+	return 0;
+err:
+	close(sockfd);
+	return 1;
+}
+
+static int do_recv(struct io_uring *ring, struct iovec *iov,
+		   struct recvfrom_data *rd)
+{
+	struct io_uring_cqe *cqe;
+	int ret;
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stdout, "wait_cqe: %d\n", ret);
+		goto err;
+	}
+	if (cqe->res == -EINVAL) {
+		fprintf(stdout, "recvfrom not supported, skipping\n");
+		return 0;
+	}
+	if (cqe->res < 0) {
+		fprintf(stderr, "failed cqe: %d\n", cqe->res);
+		goto err;
+	}
+
+	if (cqe->res -1 != strlen(str)) {
+		fprintf(stderr, "got wrong length: %d/%d\n", cqe->res,
+							(int) strlen(str) + 1);
+		goto err;
+	}
+
+	if (strcmp(str, iov->iov_base)) {
+		fprintf(stderr, "string mismatch\n");
+		goto err;
+	}
+
+	if (rd->explicit_dst_src) {
+		if (rd->recvfrom_src.sin_family != AF_INET) {
+			fprintf(stderr, "wrong saddr2.sin_family\n");
+			goto err;
+		}
+
+		if (rd->recvfrom_src.sin_addr.s_addr != inet_addr(HOST)) {
+			fprintf(stderr, "wrong saddr2.s_addr\n");
+			goto err;
+		}
+
+		if (rd->recvfrom_src.sin_port != htons(PORT2)) {
+			fprintf(stderr, "wrong saddr2.sin_port\n");
+			goto err;
+		}
+	}
+
+	return 0;
+err:
+	return 1;
+}
+
+static void *recvfrom_fn(void *data)
+{
+	struct recvfrom_data *rd = data;
+	char buf[MAX_MSG + 1];
+	struct iovec iov = {
+		.iov_base = buf,
+		.iov_len = sizeof(buf) - 1,
+	};
+	struct io_uring_params p = { };
+	struct io_uring ring;
+	int ret, sock;
+
+	if (rd->use_sqthread)
+		p.flags = IORING_SETUP_SQPOLL;
+	ret = t_create_ring_params(1, &ring, &p);
+	if (ret == T_SETUP_SKIP) {
+		pthread_mutex_unlock(&rd->mutex);
+		ret = 0;
+		goto err;
+	} else if (ret < 0) {
+		pthread_mutex_unlock(&rd->mutex);
+		goto err;
+	}
+
+	if (rd->use_sqthread && !rd->registerfiles) {
+		if (!(p.features & IORING_FEAT_SQPOLL_NONFIXED)) {
+			fprintf(stdout, "Non-registered SQPOLL not available, skipping\n");
+			pthread_mutex_unlock(&rd->mutex);
+			goto err;
+		}
+	}
+
+	ret = recvfrom_prep(&ring, &iov, &sock, rd);
+	if (ret) {
+		fprintf(stderr, "recvfrom_prep failed: %d\n", ret);
+		goto err;
+	}
+	pthread_mutex_unlock(&rd->mutex);
+	ret = do_recv(&ring, &iov, rd);
+
+	close(sock);
+	io_uring_queue_exit(&ring);
+err:
+	return (void *)(intptr_t)ret;
+}
+
+static int bind_socket_for_sendto(int sockfd)
+{
+	struct sockaddr_in saddr;
+	int ret, val;
+
+	memset(&saddr, 0, sizeof(saddr));
+	saddr.sin_family = AF_INET;
+	saddr.sin_addr.s_addr = inet_addr(HOST);
+	saddr.sin_port = htons(PORT2);
+
+	val = 1;
+	setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
+
+	ret = bind(sockfd, (struct sockaddr *)&saddr, sizeof(saddr));
+	if (ret < 0) {
+		perror("bind in bind_socket_for_sendto");
+		return 1;
+	}
+
+
+	return 0;
+}
+
+static int do_sendto(struct recvfrom_data *rd)
+{
+	struct sockaddr_in saddr;
+	struct iovec iov = {
+		.iov_base = str,
+		.iov_len = sizeof(str),
+	};
+	struct io_uring ring;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct sockaddr *saddr_p;
+	socklen_t saddr_len;
+	int sockfd, ret;
+
+	ret = io_uring_queue_init(1, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue init failed: %d\n", ret);
+		return 1;
+	}
+
+	memset(&saddr, 0, sizeof(saddr));
+	saddr.sin_family = AF_INET;
+	saddr.sin_port = htons(PORT);
+	inet_pton(AF_INET, HOST, &saddr.sin_addr);
+
+	sockfd = socket(AF_INET, SOCK_DGRAM, 0);
+	if (sockfd < 0) {
+		perror("socket");
+		return 1;
+	}
+
+	if (rd->explicit_dst_src) {
+		saddr_p = (struct sockaddr *)&saddr;
+		saddr_len = sizeof(saddr);
+
+		/*
+		 * We need to bind() here because the recvfrom() side
+		 * will use an explicit source (addr and port).
+		 */
+		bind_socket_for_sendto(sockfd);
+	} else {
+		saddr_p = NULL;
+		saddr_len = 0;
+		/*
+		 * Only connect() when sendto() is done without explicit
+		 * destination (addr and port).
+		 */
+		ret = connect(sockfd, (struct sockaddr *)&saddr, sizeof(saddr));
+		if (ret < 0) {
+			perror("connect");
+			return 1;
+		}
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_sendto(sqe, sockfd, iov.iov_base, iov.iov_len, 0,
+			     saddr_p, saddr_len);
+	sqe->user_data = 1;
+
+	ret = io_uring_submit(&ring);
+	if (ret <= 0) {
+		fprintf(stderr, "submit failed: %d\n", ret);
+		goto err;
+	}
+
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (cqe->res == -EINVAL) {
+		fprintf(stdout, "sendto not supported, skipping\n");
+		close(sockfd);
+		return 0;
+	}
+	if (cqe->res != iov.iov_len) {
+		fprintf(stderr, "failed cqe: %d\n", cqe->res);
+		goto err;
+	}
+
+	close(sockfd);
+	return 0;
+err:
+	close(sockfd);
+	return 1;
+}
+
+static int test(int use_sqthread, int regfiles, int explicit_dst_src)
+{
+	pthread_mutexattr_t attr;
+	pthread_t recvfrom_thread;
+	struct recvfrom_data rd;
+	int ret;
+	void *retval;
+
+	pthread_mutexattr_init(&attr);
+	pthread_mutexattr_setpshared(&attr, 1);
+	pthread_mutex_init(&rd.mutex, &attr);
+	pthread_mutex_lock(&rd.mutex);
+	rd.use_sqthread = use_sqthread;
+	rd.registerfiles = regfiles;
+	rd.explicit_dst_src = explicit_dst_src;
+
+	ret = pthread_create(&recvfrom_thread, NULL, recvfrom_fn, &rd);
+	if (ret) {
+		fprintf(stderr, "Thread create failed: %d\n", ret);
+		pthread_mutex_unlock(&rd.mutex);
+		return 1;
+	}
+
+	pthread_mutex_lock(&rd.mutex);
+	do_sendto(&rd);
+	pthread_join(recvfrom_thread, &retval);
+	return (int)(intptr_t)retval;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	if (argc > 1)
+		return 0;
+
+	ret = test(0, 0, 0);
+	if (ret) {
+		fprintf(stderr, "test sqthread=0 failed\n");
+		return ret;
+	}
+
+	ret = test(1, 1, 0);
+	if (ret) {
+		fprintf(stderr, "test sqthread=1 reg=1 failed\n");
+		return ret;
+	}
+
+	ret = test(1, 0, 0);
+	if (ret) {
+		fprintf(stderr, "test sqthread=1 reg=0 failed\n");
+		return ret;
+	}
+
+	ret = test(0, 0, 1);
+	if (ret) {
+		fprintf(stderr, "test sqthread=0 explicit_dst_src=1 failed\n");
+		return ret;
+	}
+
+	ret = test(1, 1, 1);
+	if (ret) {
+		fprintf(stderr, "test sqthread=1 reg=1 explicit_dst_src=1 failed\n");
+		return ret;
+	}
+
+	ret = test(1, 0, 1);
+	if (ret) {
+		fprintf(stderr, "test sqthread=1 reg=0 explicit_dst_src=1 failed\n");
+		return ret;
+	}
+
+	return 0;
+}
-- 
2.32.0

