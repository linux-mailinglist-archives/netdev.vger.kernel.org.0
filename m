Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919AB10B755
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 21:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfK0USW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 15:18:22 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45030 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbfK0USV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 15:18:21 -0500
Received: by mail-lf1-f65.google.com with SMTP id v201so17152403lfa.11
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 12:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zhItHYyRpROl20O6Q10reTpn6F5PgUqWpU9th+0YblM=;
        b=ZkEcyZX392H/0zQcXa1ylngiMI6UR+46W/vMDBjhgkKA1bKfvAQo66gyzWMVreO0NV
         A+E8stc15xlHX8JoE5wj3xPjS+V5nY80oJVooiYXfXpg2OF9o2pANQy0EcJ4hJmgbcFc
         7HlxJLBxaYKn+vrE8VqeQe6pEwfgAiracBrd9wxeSvdQdTFyEbNoOkXK3hk3sIcgKev3
         gJLgW+VEAnWKkgrihabN0pZam6Mm4Y+GR+7Ps3YlMpesTfJoI5mjrhv8CwG6QUpXwTs7
         bJXcsCyVxwY9l+sXLnymvs/qz0xs7fJOI0TysePPjVEzERzzgUrEwUGM583PPhWayHlM
         Pjtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zhItHYyRpROl20O6Q10reTpn6F5PgUqWpU9th+0YblM=;
        b=XGw9K7fX+snbKQ3z0FLu62J2tjgLCYhKQGtPF39SRykn8bHftDiyTqsocCC4kj/iv2
         WiIpQU2DDtxiEaDpGAyYq+Fiixe/2RO7RBEe4QBVsDiQEWmrpVoTGZx1+wuj1NeeJCHa
         3ogD2QnYZy2BOQ1Idz5g+ovZYPy3vWlq+mvdUkYcjdq0C2q0On9xhzUvJpBndCHqKovK
         M0Qa3mXyV+Br5ekfBXHy9GELRXEL+AV9Jjzb00+287HR7s4KMI4xsU5H9TiyB4BfTR6p
         jbIuZ1ampZJUBQWilkFv+/Fdf65PsoRi2l+LYqSfRodr4wfBMxYt+V20SC2LlErZTLx2
         Nh+Q==
X-Gm-Message-State: APjAAAXVf4BlIAGe58uQ2wLHTZhQgNU6QezGx5wiLSBHREtxvbNRPrs/
        EMaG35pteZPL7rKSkhDYqUgFMQ==
X-Google-Smtp-Source: APXvYqx5ZDmzpuAaRuRn1RPhrNuSJc8Xix+B4kop2KdpIvnkNQ0ZcrMDab1O/dXXSc072MhvI4vt/Q==
X-Received: by 2002:ac2:5462:: with SMTP id e2mr20407657lfn.181.1574885898805;
        Wed, 27 Nov 2019 12:18:18 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r22sm7759739lji.71.2019.11.27.12.18.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2019 12:18:18 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net 8/8] selftests: bpf: correct perror strings
Date:   Wed, 27 Nov 2019 12:16:46 -0800
Message-Id: <20191127201646.25455-9-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127201646.25455-1-jakub.kicinski@netronome.com>
References: <20191127201646.25455-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

perror(str) is basically equivalent to
print("%s: %s\n", str, strerror(errno)).
New line or colon at the end of str is
a mistake/breaks formatting.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 tools/testing/selftests/bpf/test_sockmap.c | 38 +++++++++++-----------
 tools/testing/selftests/bpf/xdping.c       |  2 +-
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 8b838e91cfe5..4a851513c842 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -240,14 +240,14 @@ static int sockmap_init_sockets(int verbose)
 	addr.sin_port = htons(S1_PORT);
 	err = bind(s1, (struct sockaddr *)&addr, sizeof(addr));
 	if (err < 0) {
-		perror("bind s1 failed()\n");
+		perror("bind s1 failed()");
 		return errno;
 	}
 
 	addr.sin_port = htons(S2_PORT);
 	err = bind(s2, (struct sockaddr *)&addr, sizeof(addr));
 	if (err < 0) {
-		perror("bind s2 failed()\n");
+		perror("bind s2 failed()");
 		return errno;
 	}
 
@@ -255,14 +255,14 @@ static int sockmap_init_sockets(int verbose)
 	addr.sin_port = htons(S1_PORT);
 	err = listen(s1, 32);
 	if (err < 0) {
-		perror("listen s1 failed()\n");
+		perror("listen s1 failed()");
 		return errno;
 	}
 
 	addr.sin_port = htons(S2_PORT);
 	err = listen(s2, 32);
 	if (err < 0) {
-		perror("listen s1 failed()\n");
+		perror("listen s1 failed()");
 		return errno;
 	}
 
@@ -270,14 +270,14 @@ static int sockmap_init_sockets(int verbose)
 	addr.sin_port = htons(S1_PORT);
 	err = connect(c1, (struct sockaddr *)&addr, sizeof(addr));
 	if (err < 0 && errno != EINPROGRESS) {
-		perror("connect c1 failed()\n");
+		perror("connect c1 failed()");
 		return errno;
 	}
 
 	addr.sin_port = htons(S2_PORT);
 	err = connect(c2, (struct sockaddr *)&addr, sizeof(addr));
 	if (err < 0 && errno != EINPROGRESS) {
-		perror("connect c2 failed()\n");
+		perror("connect c2 failed()");
 		return errno;
 	} else if (err < 0) {
 		err = 0;
@@ -286,13 +286,13 @@ static int sockmap_init_sockets(int verbose)
 	/* Accept Connecrtions */
 	p1 = accept(s1, NULL, NULL);
 	if (p1 < 0) {
-		perror("accept s1 failed()\n");
+		perror("accept s1 failed()");
 		return errno;
 	}
 
 	p2 = accept(s2, NULL, NULL);
 	if (p2 < 0) {
-		perror("accept s1 failed()\n");
+		perror("accept s1 failed()");
 		return errno;
 	}
 
@@ -353,7 +353,7 @@ static int msg_loop_sendpage(int fd, int iov_length, int cnt,
 		int sent = sendfile(fd, fp, NULL, iov_length);
 
 		if (!drop && sent < 0) {
-			perror("send loop error:");
+			perror("send loop error");
 			close(fp);
 			return sent;
 		} else if (drop && sent >= 0) {
@@ -472,7 +472,7 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 			int sent = sendmsg(fd, &msg, flags);
 
 			if (!drop && sent < 0) {
-				perror("send loop error:");
+				perror("send loop error");
 				goto out_errno;
 			} else if (drop && sent >= 0) {
 				printf("send loop error expected: %i\n", sent);
@@ -508,7 +508,7 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 		total_bytes -= txmsg_pop_total;
 		err = clock_gettime(CLOCK_MONOTONIC, &s->start);
 		if (err < 0)
-			perror("recv start time: ");
+			perror("recv start time");
 		while (s->bytes_recvd < total_bytes) {
 			if (txmsg_cork) {
 				timeout.tv_sec = 0;
@@ -552,7 +552,7 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 			if (recv < 0) {
 				if (errno != EWOULDBLOCK) {
 					clock_gettime(CLOCK_MONOTONIC, &s->end);
-					perror("recv failed()\n");
+					perror("recv failed()");
 					goto out_errno;
 				}
 			}
@@ -566,7 +566,7 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 
 				errno = msg_verify_data(&msg, recv, chunk_sz);
 				if (errno) {
-					perror("data verify msg failed\n");
+					perror("data verify msg failed");
 					goto out_errno;
 				}
 				if (recvp) {
@@ -574,7 +574,7 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 								recvp,
 								chunk_sz);
 					if (errno) {
-						perror("data verify msg_peek failed\n");
+						perror("data verify msg_peek failed");
 						goto out_errno;
 					}
 				}
@@ -663,7 +663,7 @@ static int sendmsg_test(struct sockmap_options *opt)
 			err = 0;
 		exit(err ? 1 : 0);
 	} else if (rxpid == -1) {
-		perror("msg_loop_rx: ");
+		perror("msg_loop_rx");
 		return errno;
 	}
 
@@ -690,7 +690,7 @@ static int sendmsg_test(struct sockmap_options *opt)
 				s.bytes_recvd, recvd_Bps, recvd_Bps/giga);
 		exit(err ? 1 : 0);
 	} else if (txpid == -1) {
-		perror("msg_loop_tx: ");
+		perror("msg_loop_tx");
 		return errno;
 	}
 
@@ -724,7 +724,7 @@ static int forever_ping_pong(int rate, struct sockmap_options *opt)
 	/* Ping/Pong data from client to server */
 	sc = send(c1, buf, sizeof(buf), 0);
 	if (sc < 0) {
-		perror("send failed()\n");
+		perror("send failed()");
 		return sc;
 	}
 
@@ -757,7 +757,7 @@ static int forever_ping_pong(int rate, struct sockmap_options *opt)
 			rc = recv(i, buf, sizeof(buf), 0);
 			if (rc < 0) {
 				if (errno != EWOULDBLOCK) {
-					perror("recv failed()\n");
+					perror("recv failed()");
 					return rc;
 				}
 			}
@@ -769,7 +769,7 @@ static int forever_ping_pong(int rate, struct sockmap_options *opt)
 
 			sc = send(i, buf, rc, 0);
 			if (sc < 0) {
-				perror("send failed()\n");
+				perror("send failed()");
 				return sc;
 			}
 		}
diff --git a/tools/testing/selftests/bpf/xdping.c b/tools/testing/selftests/bpf/xdping.c
index d60a343b1371..842d9155d36c 100644
--- a/tools/testing/selftests/bpf/xdping.c
+++ b/tools/testing/selftests/bpf/xdping.c
@@ -45,7 +45,7 @@ static int get_stats(int fd, __u16 count, __u32 raddr)
 	printf("\nXDP RTT data:\n");
 
 	if (bpf_map_lookup_elem(fd, &raddr, &pinginfo)) {
-		perror("bpf_map_lookup elem: ");
+		perror("bpf_map_lookup elem");
 		return 1;
 	}
 
-- 
2.23.0

