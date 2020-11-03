Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D3B2A572D
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732222AbgKCVg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732301AbgKCVew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 16:34:52 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14310C0613D1;
        Tue,  3 Nov 2020 13:34:52 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id 12so12802327qkl.8;
        Tue, 03 Nov 2020 13:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=NsjjxFZzTXqmInDEDHwBdp0oyW2WVSDONEXFS3a/zfw=;
        b=fak9GnQTQQFa+0+RVRVzV8h7ZtLK5t32useZat7rXjyTftDRzOu8tLVSCdMG193Zid
         U8NxJuVv6O2sXlmJAidb35vBRAUi9Xd2aWzlT/wfrY40JMEjoeGyZ4Rm8LoZrmc4aXDm
         mUw6fe+jpRYWYH9+orVmzhBS4adyAte5joLG6PG32lCCy0+RiDEazKDYL5BynQNB322n
         KreH8vKdb+iz0rTnXy3ta8RaZdCSIo5DGpB4kDaRhL9EpNQlHF9fHnDGzWQt1n6K+Web
         s3veyFd8puYF5H77T5WWILehHbZxzYkah8hagvw3oKaiNJc0XFnXgNERhKNSsY5FKx0X
         6avQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=NsjjxFZzTXqmInDEDHwBdp0oyW2WVSDONEXFS3a/zfw=;
        b=cuZlJGgxkNe99kfG5cgG7moxJaW3I8PaaeD2cdIYtpmyk6K3PxtKtB6yZEic7hJAk0
         oVd/r89M5PaYYfH8IG+o3YWTGO+ARTUYbM19UCUgQjUVHxSfDbE5wcm62n/VNoAD6o+/
         HBkwwlEKEmYgT0RRzufUR70CgW5yXWsTzi1wU+2dK/HvKzS2eswpURLtQoNyRtBDZ9b0
         Rmr/X9mKtzAgc/eD+KIzz0wFYObNnfrU77chlouF6UrBttv3QVSZv/wfJDF52W3muirG
         UkmmnVgB92u/7NPGiLv9DV0m8bFATP7TDfqQMIGTPhRC+JY1u0Tsx5bOqWvY4B/VmKWk
         ow+A==
X-Gm-Message-State: AOAM533cg5u64InriefXSRQ2QAWaNqbOtuWH0DhDV6bmkomiQYQzq4V+
        9IbWCnwGp0UcStS+IolXELw=
X-Google-Smtp-Source: ABdhPJyMeaHOqbpGeGVSvQbE6opM32VYsQKDCf0HOG1vq7sF/cJdWefy6ZwYibE8UKlTEom0Cg33kg==
X-Received: by 2002:a05:620a:112a:: with SMTP id p10mr22167699qkk.446.1604439291158;
        Tue, 03 Nov 2020 13:34:51 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 185sm10814635qkm.113.2020.11.03.13.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 13:34:50 -0800 (PST)
Subject: [bpf-next PATCH v3 1/5] selftests/bpf: Move test_tcppbf_user into
 test_progs
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        john.fastabend@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org, edumazet@google.com, brakmo@fb.com,
        andrii.nakryiko@gmail.com, alexanderduyck@fb.com
Date:   Tue, 03 Nov 2020 13:34:48 -0800
Message-ID: <160443928881.1086697.17661359319919165370.stgit@localhost.localdomain>
In-Reply-To: <160443914296.1086697.4231574770375103169.stgit@localhost.localdomain>
References: <160443914296.1086697.4231574770375103169.stgit@localhost.localdomain>
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
4. Renamed main to test_tcpbpf_user
5. Dropped return value in favor of CHECK_FAIL to check for errors

The general idea is that I wanted to keep the changes as small as possible
while moving the file into the test_progs framework. The follow-on patches
are meant to clean up the remaining issues such as the use of CHECK_FAIL.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 tools/testing/selftests/bpf/.gitignore             |    1 
 tools/testing/selftests/bpf/Makefile               |    3 -
 .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   42 ++++----------------
 3 files changed, 10 insertions(+), 36 deletions(-)
 rename tools/testing/selftests/bpf/{test_tcpbpf_user.c => prog_tests/tcpbpf_user.c} (81%)

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
similarity index 81%
rename from tools/testing/selftests/bpf/test_tcpbpf_user.c
rename to tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
index 74a9e49988b6..caa8d3adec8a 100644
--- a/tools/testing/selftests/bpf/test_tcpbpf_user.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
@@ -1,21 +1,11 @@
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
@@ -102,7 +78,7 @@ int main(int argc, char **argv)
 	__u32 key = 0;
 	int rv;
 
-	cg_fd = cgroup_setup_and_join(cg_path);
+	cg_fd = test__join_cgroup(CG_NAME);
 	if (cg_fd < 0)
 		goto err;
 
@@ -155,11 +131,11 @@ int main(int argc, char **argv)
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


