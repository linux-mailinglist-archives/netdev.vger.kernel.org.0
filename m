Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A990E2A19FF
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgJaSwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbgJaSwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 14:52:14 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FD9C0617A6;
        Sat, 31 Oct 2020 11:52:13 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 13so7771315pfy.4;
        Sat, 31 Oct 2020 11:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=BTkJC6gfB4fUeAGrezObleGfjUo2WRhyCWpQEr0iPRY=;
        b=ZhC1PQOo8U1BE5j/S1NTcJtYm5KzZCbtGSwXwVnWsiWRnuGPHNS+r5WC9g9hqvAkYB
         VHNyPqWvGljutsHDSFi/JA77Fsd2rTfkHbWDrnZJR/BXHqEw9fuGdVIndQkrzqXIjocg
         9vWb7SOUTJgBaDAod+CsqD4eXzh8YYJ4sVpeylkY8kSApgWXa4w2LHxQPIJ3HfmX1VxO
         kzf2YmDltV5273iSx++4HV2dNtQvFfy8LYaT2ESFLqwSM2jj8UXl3r7B++xSLMdw64jb
         5WHiwj5J0R/POQZHRt9TxxXvtabUBgNJP5fLfxuPRYbKabLvyc/gT/yv0iCTIs5c8uCx
         Kh6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=BTkJC6gfB4fUeAGrezObleGfjUo2WRhyCWpQEr0iPRY=;
        b=cJyBHDzBn/AK4WLprCBfjhhlvg1Q/KZUyQE7wjQkH689u/AsJJZ7tsGfYYIr/NRS3+
         xaaoPF1a3fzzxgUhNyaXv9jbSsaN4Yz59XOjpfBtObKrFycpMEUa1Pw5kRYKaaaig87S
         Iv2MzULOH2e5MvBZU5zneLYK8c/BOsrAFgNxBx+FfVkTqzfgqCoeUxawqq2kaiSOEbpE
         VYuv82d2rb0SxVVqBpNM81OMq5q0T4toPvenWiTd2fhjhxnPZSAKVXTq6W+SL59OqE6S
         ba2vHFj/S6hgVe19gkTqt+bbgbeflHoZ7sjqK7xCzfDedwpxgBXtLP/jKPs9uHtB1c6/
         o/Jg==
X-Gm-Message-State: AOAM531h06AprlJKqSsRUk7xkCOkrUJjyimlrhQSG+C8fHSJHXmlvZp4
        MibyHkG4/khZLmLm5bpx4xo=
X-Google-Smtp-Source: ABdhPJxQgBEx6TWleLxEtd9oVo100nK7ZI5FVwvHiDpQerpp8JoUB2J3Qo9uvVZ54IhRD5TLepCr5A==
X-Received: by 2002:a63:da4e:: with SMTP id l14mr7399688pgj.131.1604170333092;
        Sat, 31 Oct 2020 11:52:13 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 10sm7479024pjt.50.2020.10.31.11.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 11:52:12 -0700 (PDT)
Subject: [bpf-next PATCH v2 1/5] selftests/bpf: Move test_tcppbf_user into
 test_progs
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        john.fastabend@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org, edumazet@google.com, brakmo@fb.com,
        andrii.nakryiko@gmail.com, alexanderduyck@fb.com
Date:   Sat, 31 Oct 2020 11:52:11 -0700
Message-ID: <160417033167.2823.10759249192027767614.stgit@localhost.localdomain>
In-Reply-To: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
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
3. Switched over to using test_progs specific cgroup functions
4. Replaced printf calls with fprintf to stderr
5. Renamed main to test_tcpbpf_user
6. Dropped return value in favor of CHECK_FAIL to check for errors

The general idea is that I wanted to keep the changes as small as possible
while moving the file into the test_progs framework. The follow-on patches
are meant to clean up the remaining issues such as the use of CHECK_FAIL.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 tools/testing/selftests/bpf/.gitignore             |    1 
 tools/testing/selftests/bpf/Makefile               |    3 -
 .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   63 ++++++--------------
 3 files changed, 21 insertions(+), 46 deletions(-)
 rename tools/testing/selftests/bpf/{test_tcpbpf_user.c => prog_tests/tcpbpf_user.c} (70%)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 3ab1200e172f..395ae040ce1f 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -8,7 +8,6 @@ FEATURE-DUMP.libbpf
 fixdep
 test_dev_cgroup
 /test_progs*
-test_tcpbpf_user
 test_verifier_log
 feature
 test_sock
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
diff --git a/tools/testing/selftests/bpf/test_tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
similarity index 70%
rename from tools/testing/selftests/bpf/test_tcpbpf_user.c
rename to tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
index 74a9e49988b6..54f1dce97729 100644
--- a/tools/testing/selftests/bpf/test_tcpbpf_user.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
@@ -1,28 +1,18 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <inttypes.h>
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
+#include <test_progs.h>
 
 #include "test_tcpbpf.h"
 
+#define CG_NAME "/tcpbpf-user-test"
+
 /* 3 comes from one listening socket + both ends of the connection */
 #define EXPECTED_CLOSE_EVENTS		3
 
 #define EXPECT_EQ(expected, actual, fmt)			\
 	do {							\
 		if ((expected) != (actual)) {			\
-			printf("  Value of: " #actual "\n"	\
+			fprintf(stderr, "  Value of: " #actual "\n"	\
 			       "    Actual: %" fmt "\n"		\
 			       "  Expected: %" fmt "\n",	\
 			       (actual), (expected));		\
@@ -76,25 +66,11 @@ int verify_sockopt_result(int sock_map_fd)
 	return ret;
 }
 
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
+void test_tcpbpf_user(void)
 {
 	const char *file = "test_tcpbpf_kern.o";
 	int prog_fd, map_fd, sock_map_fd;
 	struct tcpbpf_globals g = {0};
-	const char *cg_path = "/foo";
 	int error = EXIT_FAILURE;
 	struct bpf_object *obj;
 	int cg_fd = -1;
@@ -102,24 +78,24 @@ int main(int argc, char **argv)
 	__u32 key = 0;
 	int rv;
 
-	cg_fd = cgroup_setup_and_join(cg_path);
+	cg_fd = test__join_cgroup(CG_NAME);
 	if (cg_fd < 0)
 		goto err;
 
 	if (bpf_prog_load(file, BPF_PROG_TYPE_SOCK_OPS, &obj, &prog_fd)) {
-		printf("FAILED: load_bpf_file failed for: %s\n", file);
+		fprintf(stderr, "FAILED: load_bpf_file failed for: %s\n", file);
 		goto err;
 	}
 
 	rv = bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_SOCK_OPS, 0);
 	if (rv) {
-		printf("FAILED: bpf_prog_attach: %d (%s)\n",
-		       error, strerror(errno));
+		fprintf(stderr, "FAILED: bpf_prog_attach: %d (%s)\n",
+		       errno, strerror(errno));
 		goto err;
 	}
 
 	if (system("./tcp_server.py")) {
-		printf("FAILED: TCP server\n");
+		fprintf(stderr, "FAILED: TCP server\n");
 		goto err;
 	}
 
@@ -134,32 +110,33 @@ int main(int argc, char **argv)
 retry_lookup:
 	rv = bpf_map_lookup_elem(map_fd, &key, &g);
 	if (rv != 0) {
-		printf("FAILED: bpf_map_lookup_elem returns %d\n", rv);
+		fprintf(stderr, "FAILED: bpf_map_lookup_elem returns %d\n", rv);
 		goto err;
 	}
 
 	if (g.num_close_events != EXPECTED_CLOSE_EVENTS && retry--) {
-		printf("Unexpected number of close events (%d), retrying!\n",
-		       g.num_close_events);
+		fprintf(stderr,
+			"Unexpected number of close events (%d), retrying!\n",
+			g.num_close_events);
 		usleep(100);
 		goto retry_lookup;
 	}
 
 	if (verify_result(&g)) {
-		printf("FAILED: Wrong stats\n");
+		fprintf(stderr, "FAILED: Wrong stats\n");
 		goto err;
 	}
 
 	if (verify_sockopt_result(sock_map_fd)) {
-		printf("FAILED: Wrong sockopt stats\n");
+		fprintf(stderr, "FAILED: Wrong sockopt stats\n");
 		goto err;
 	}
 
-	printf("PASSED!\n");
 	error = 0;
 err:
 	bpf_prog_detach(cg_fd, BPF_CGROUP_SOCK_OPS);
-	close(cg_fd);
-	cleanup_cgroup_environment();
-	return error;
+	if (cg_fd != -1)
+		close(cg_fd);
+
+	CHECK_FAIL(error);
 }


