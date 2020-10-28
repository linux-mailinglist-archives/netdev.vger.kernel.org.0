Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B91829DB4B
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389257AbgJ1Xsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389258AbgJ1Xsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:48:50 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCACC0613CF;
        Wed, 28 Oct 2020 16:48:50 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id n18so558088vsl.2;
        Wed, 28 Oct 2020 16:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=L7flsRsQxIpBLiql8dmiQFwWEZHi3eNldjPGgTqCKcw=;
        b=GYiwevX/H0DvZ/srmuL+lI0XJJ5/J34TCvRWFvZSt77kbuLc/jxBxCYG066nnvPRNl
         6dUljXutH2zENIlFRVcvg5MdNqXbyefoQVd78DqAIjqfF/CMgLz2tgHpMBERQQY/fgZM
         jrIz0UwwSDH5BZHOyyrB/eD4AMOVDnsGIe3Qzi7SUq+5/KSt1aca6HII4ntouJLafTq7
         1HYgyzEC5f9WvqSaGrzrXbPdmueBlx8770yGfTTRrcAv7WIJuoTOOVDcCBUpgSJ9jIk8
         8wnYUCA2MJnURUokCw1sK8obKfBF6OjNdLAfpYW98QinXFuJABDktcYQW5IBTdobjGCx
         HIxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=L7flsRsQxIpBLiql8dmiQFwWEZHi3eNldjPGgTqCKcw=;
        b=dRnr2/oN0z8JUjBCihMiZhq+va5pLfiZ5c+s9Zyz3/yd5+62pRIpDQ9YnSP+juGE+l
         1Z037li0gh3B9frQ+W6g2gJbYWGmfnntGwQzNLIujL0NQFb7RMQ8mDQP21CA96an1A3B
         ANc+I9mlSVQIRQOEPOXYSHLvR8KiRuhHc9EA3m9PXnYs9IPA8wgIM6bLO41FklU1PgEg
         EMNqni0P4cClXkAn0daMsdUBNG8o0LDYumabTT10lq2ay7PuYadJKM1LCoFn9n53k4qm
         B9e81hRMozI7cfv9ChwahmE8ooHJk5TNXfJ7zrwZNP21iKo7Mfk8ifSE9D+wpUO2B6KO
         QGDQ==
X-Gm-Message-State: AOAM531me7gCT/kesrM9hhDZ5+CiTY/rJcsy2yNWVZcrZ0YeNQHb62/f
        FtVisBTNVXxzeckesjSfdA0BF10bylIq1g==
X-Google-Smtp-Source: ABdhPJzHUDRHU4/MFY9RcnJq7v8pC0Zu8Xz8EH8Eiz/ye0ylVUT/gfMQRz3lfyVSuYibm5bbLwMSAw==
X-Received: by 2002:a0c:8d05:: with SMTP id r5mr5509623qvb.31.1603849627928;
        Tue, 27 Oct 2020 18:47:07 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id h125sm2107799qkc.36.2020.10.27.18.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 18:47:07 -0700 (PDT)
Subject: [bpf-next PATCH 1/4] selftests/bpf: Move test_tcppbf_user into
 test_progs
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        john.fastabend@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org, edumazet@google.com, brakmo@fb.com,
        alexanderduyck@fb.com
Date:   Tue, 27 Oct 2020 18:47:05 -0700
Message-ID: <160384962569.698509.4528110378641773523.stgit@localhost.localdomain>
In-Reply-To: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
References: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

Recently a bug was missed due to the fact that test_tcpbpf_user is not a
part of test_progs. In order to prevent similar issues in the future move
the test functionality into test_progs. By doing this we can make certain
that it is a part of standard testing and will not be overlooked.

As a part of moving the functionality into test_progs it is necessary to
integrate with the test_progs framework and to drop any redundant code.
This patch:
1. Cleans up the include headers
2. Dropped a duplicate definition of bpf_find_map
3. Replaced printf calls with fprintf to stderr
4. Renamed main to test_tcpbpf_user
5. Dropped return value in favor of CHECK calls to check for errors

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 tools/testing/selftests/bpf/Makefile               |    3 
 .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |  138 +++++++++++++++++
 tools/testing/selftests/bpf/test_tcpbpf_user.c     |  165 --------------------
 3 files changed, 139 insertions(+), 167 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
 delete mode 100644 tools/testing/selftests/bpf/test_tcpbpf_user.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 542768f5195b..50e5b18fc455 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -32,7 +32,7 @@ LDLIBS += -lcap -lelf -lz -lrt -lpthread
 
 # Order correspond to 'make run_tests' order
 TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test_progs \
-	test_verifier_log test_dev_cgroup test_tcpbpf_user \
+	test_verifier_log test_dev_cgroup \
 	test_sock test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage \
 	test_netcnt test_tcpnotify_user test_sysctl \
@@ -163,7 +163,6 @@ $(OUTPUT)/test_sock: cgroup_helpers.c
 $(OUTPUT)/test_sock_addr: cgroup_helpers.c
 $(OUTPUT)/test_socket_cookie: cgroup_helpers.c
 $(OUTPUT)/test_sockmap: cgroup_helpers.c
-$(OUTPUT)/test_tcpbpf_user: cgroup_helpers.c
 $(OUTPUT)/test_tcpnotify_user: cgroup_helpers.c trace_helpers.c
 $(OUTPUT)/get_cgroup_id_user: cgroup_helpers.c
 $(OUTPUT)/test_cgroup_storage: cgroup_helpers.c
diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
new file mode 100644
index 000000000000..5becab8b04e3
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <inttypes.h>
+#include <test_progs.h>
+
+#include "test_tcpbpf.h"
+#include "cgroup_helpers.h"
+
+#define CG_NAME "/tcpbpf-user-test"
+
+/* 3 comes from one listening socket + both ends of the connection */
+#define EXPECTED_CLOSE_EVENTS		3
+
+#define EXPECT_EQ(expected, actual, fmt)			\
+	do {							\
+		if ((expected) != (actual)) {			\
+			fprintf(stderr, "  Value of: " #actual "\n"	\
+			       "    Actual: %" fmt "\n"		\
+			       "  Expected: %" fmt "\n",	\
+			       (actual), (expected));		\
+			ret--;					\
+		}						\
+	} while (0)
+
+int verify_result(const struct tcpbpf_globals *result)
+{
+	__u32 expected_events;
+	int ret = 0;
+
+	expected_events = ((1 << BPF_SOCK_OPS_TIMEOUT_INIT) |
+			   (1 << BPF_SOCK_OPS_RWND_INIT) |
+			   (1 << BPF_SOCK_OPS_TCP_CONNECT_CB) |
+			   (1 << BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB) |
+			   (1 << BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB) |
+			   (1 << BPF_SOCK_OPS_NEEDS_ECN) |
+			   (1 << BPF_SOCK_OPS_STATE_CB) |
+			   (1 << BPF_SOCK_OPS_TCP_LISTEN_CB));
+
+	EXPECT_EQ(expected_events, result->event_map, "#" PRIx32);
+	EXPECT_EQ(501ULL, result->bytes_received, "llu");
+	EXPECT_EQ(1002ULL, result->bytes_acked, "llu");
+	EXPECT_EQ(1, result->data_segs_in, PRIu32);
+	EXPECT_EQ(1, result->data_segs_out, PRIu32);
+	EXPECT_EQ(0x80, result->bad_cb_test_rv, PRIu32);
+	EXPECT_EQ(0, result->good_cb_test_rv, PRIu32);
+	EXPECT_EQ(1, result->num_listen, PRIu32);
+	EXPECT_EQ(EXPECTED_CLOSE_EVENTS, result->num_close_events, PRIu32);
+
+	return ret;
+}
+
+int verify_sockopt_result(int sock_map_fd)
+{
+	__u32 key = 0;
+	int ret = 0;
+	int res;
+	int rv;
+
+	/* check setsockopt for SAVE_SYN */
+	rv = bpf_map_lookup_elem(sock_map_fd, &key, &res);
+	EXPECT_EQ(0, rv, "d");
+	EXPECT_EQ(0, res, "d");
+	key = 1;
+	/* check getsockopt for SAVED_SYN */
+	rv = bpf_map_lookup_elem(sock_map_fd, &key, &res);
+	EXPECT_EQ(0, rv, "d");
+	EXPECT_EQ(1, res, "d");
+	return ret;
+}
+
+void test_tcpbpf_user(void)
+{
+	const char *file = "test_tcpbpf_kern.o";
+	int prog_fd, map_fd, sock_map_fd;
+	struct tcpbpf_globals g = {0};
+	struct bpf_object *obj;
+	int cg_fd = -1;
+	int retry = 10;
+	__u32 key = 0;
+	int rv;
+
+	cg_fd = cgroup_setup_and_join(CG_NAME);
+	if (CHECK_FAIL(cg_fd < 0))
+		goto err;
+
+	if (CHECK_FAIL(bpf_prog_load(file, BPF_PROG_TYPE_SOCK_OPS, &obj, &prog_fd))) {
+		fprintf(stderr, "FAILED: load_bpf_file failed for: %s\n", file);
+		goto err;
+	}
+
+	rv = bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_SOCK_OPS, 0);
+	if (CHECK_FAIL(rv)) {
+		fprintf(stderr, "FAILED: bpf_prog_attach: %d (%s)\n",
+		       errno, strerror(errno));
+		goto err;
+	}
+
+	if (CHECK_FAIL(system("./tcp_server.py"))) {
+		fprintf(stderr, "FAILED: TCP server\n");
+		goto err;
+	}
+
+	map_fd = bpf_find_map(__func__, obj, "global_map");
+	if (CHECK_FAIL(map_fd < 0))
+		goto err;
+
+	sock_map_fd = bpf_find_map(__func__, obj, "sockopt_results");
+	if (CHECK_FAIL(sock_map_fd < 0))
+		goto err;
+
+retry_lookup:
+	rv = bpf_map_lookup_elem(map_fd, &key, &g);
+	if (CHECK_FAIL(rv != 0)) {
+		fprintf(stderr, "FAILED: bpf_map_lookup_elem returns %d\n", rv);
+		goto err;
+	}
+
+	if (g.num_close_events != EXPECTED_CLOSE_EVENTS && retry--) {
+		fprintf(stderr,
+			"Unexpected number of close events (%d), retrying!\n",
+			g.num_close_events);
+		usleep(100);
+		goto retry_lookup;
+	}
+
+	if (CHECK_FAIL(verify_result(&g))) {
+		fprintf(stderr, "FAILED: Wrong stats\n");
+		goto err;
+	}
+
+	if (CHECK_FAIL(verify_sockopt_result(sock_map_fd))) {
+		fprintf(stderr, "FAILED: Wrong sockopt stats\n");
+		goto err;
+	}
+err:
+	bpf_prog_detach(cg_fd, BPF_CGROUP_SOCK_OPS);
+	close(cg_fd);
+	cleanup_cgroup_environment();
+}
diff --git a/tools/testing/selftests/bpf/test_tcpbpf_user.c b/tools/testing/selftests/bpf/test_tcpbpf_user.c
deleted file mode 100644
index 74a9e49988b6..000000000000
--- a/tools/testing/selftests/bpf/test_tcpbpf_user.c
+++ /dev/null
@@ -1,165 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <inttypes.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <errno.h>
-#include <string.h>
-#include <linux/bpf.h>
-#include <sys/types.h>
-#include <bpf/bpf.h>
-#include <bpf/libbpf.h>
-
-#include "bpf_rlimit.h"
-#include "bpf_util.h"
-#include "cgroup_helpers.h"
-
-#include "test_tcpbpf.h"
-
-/* 3 comes from one listening socket + both ends of the connection */
-#define EXPECTED_CLOSE_EVENTS		3
-
-#define EXPECT_EQ(expected, actual, fmt)			\
-	do {							\
-		if ((expected) != (actual)) {			\
-			printf("  Value of: " #actual "\n"	\
-			       "    Actual: %" fmt "\n"		\
-			       "  Expected: %" fmt "\n",	\
-			       (actual), (expected));		\
-			ret--;					\
-		}						\
-	} while (0)
-
-int verify_result(const struct tcpbpf_globals *result)
-{
-	__u32 expected_events;
-	int ret = 0;
-
-	expected_events = ((1 << BPF_SOCK_OPS_TIMEOUT_INIT) |
-			   (1 << BPF_SOCK_OPS_RWND_INIT) |
-			   (1 << BPF_SOCK_OPS_TCP_CONNECT_CB) |
-			   (1 << BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB) |
-			   (1 << BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB) |
-			   (1 << BPF_SOCK_OPS_NEEDS_ECN) |
-			   (1 << BPF_SOCK_OPS_STATE_CB) |
-			   (1 << BPF_SOCK_OPS_TCP_LISTEN_CB));
-
-	EXPECT_EQ(expected_events, result->event_map, "#" PRIx32);
-	EXPECT_EQ(501ULL, result->bytes_received, "llu");
-	EXPECT_EQ(1002ULL, result->bytes_acked, "llu");
-	EXPECT_EQ(1, result->data_segs_in, PRIu32);
-	EXPECT_EQ(1, result->data_segs_out, PRIu32);
-	EXPECT_EQ(0x80, result->bad_cb_test_rv, PRIu32);
-	EXPECT_EQ(0, result->good_cb_test_rv, PRIu32);
-	EXPECT_EQ(1, result->num_listen, PRIu32);
-	EXPECT_EQ(EXPECTED_CLOSE_EVENTS, result->num_close_events, PRIu32);
-
-	return ret;
-}
-
-int verify_sockopt_result(int sock_map_fd)
-{
-	__u32 key = 0;
-	int ret = 0;
-	int res;
-	int rv;
-
-	/* check setsockopt for SAVE_SYN */
-	rv = bpf_map_lookup_elem(sock_map_fd, &key, &res);
-	EXPECT_EQ(0, rv, "d");
-	EXPECT_EQ(0, res, "d");
-	key = 1;
-	/* check getsockopt for SAVED_SYN */
-	rv = bpf_map_lookup_elem(sock_map_fd, &key, &res);
-	EXPECT_EQ(0, rv, "d");
-	EXPECT_EQ(1, res, "d");
-	return ret;
-}
-
-static int bpf_find_map(const char *test, struct bpf_object *obj,
-			const char *name)
-{
-	struct bpf_map *map;
-
-	map = bpf_object__find_map_by_name(obj, name);
-	if (!map) {
-		printf("%s:FAIL:map '%s' not found\n", test, name);
-		return -1;
-	}
-	return bpf_map__fd(map);
-}
-
-int main(int argc, char **argv)
-{
-	const char *file = "test_tcpbpf_kern.o";
-	int prog_fd, map_fd, sock_map_fd;
-	struct tcpbpf_globals g = {0};
-	const char *cg_path = "/foo";
-	int error = EXIT_FAILURE;
-	struct bpf_object *obj;
-	int cg_fd = -1;
-	int retry = 10;
-	__u32 key = 0;
-	int rv;
-
-	cg_fd = cgroup_setup_and_join(cg_path);
-	if (cg_fd < 0)
-		goto err;
-
-	if (bpf_prog_load(file, BPF_PROG_TYPE_SOCK_OPS, &obj, &prog_fd)) {
-		printf("FAILED: load_bpf_file failed for: %s\n", file);
-		goto err;
-	}
-
-	rv = bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_SOCK_OPS, 0);
-	if (rv) {
-		printf("FAILED: bpf_prog_attach: %d (%s)\n",
-		       error, strerror(errno));
-		goto err;
-	}
-
-	if (system("./tcp_server.py")) {
-		printf("FAILED: TCP server\n");
-		goto err;
-	}
-
-	map_fd = bpf_find_map(__func__, obj, "global_map");
-	if (map_fd < 0)
-		goto err;
-
-	sock_map_fd = bpf_find_map(__func__, obj, "sockopt_results");
-	if (sock_map_fd < 0)
-		goto err;
-
-retry_lookup:
-	rv = bpf_map_lookup_elem(map_fd, &key, &g);
-	if (rv != 0) {
-		printf("FAILED: bpf_map_lookup_elem returns %d\n", rv);
-		goto err;
-	}
-
-	if (g.num_close_events != EXPECTED_CLOSE_EVENTS && retry--) {
-		printf("Unexpected number of close events (%d), retrying!\n",
-		       g.num_close_events);
-		usleep(100);
-		goto retry_lookup;
-	}
-
-	if (verify_result(&g)) {
-		printf("FAILED: Wrong stats\n");
-		goto err;
-	}
-
-	if (verify_sockopt_result(sock_map_fd)) {
-		printf("FAILED: Wrong sockopt stats\n");
-		goto err;
-	}
-
-	printf("PASSED!\n");
-	error = 0;
-err:
-	bpf_prog_detach(cg_fd, BPF_CGROUP_SOCK_OPS);
-	close(cg_fd);
-	cleanup_cgroup_environment();
-	return error;
-}


