Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC300A8D18
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731646AbfIDQZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:25:20 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:38141 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731623AbfIDQZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 12:25:20 -0400
Received: by mail-qk1-f201.google.com with SMTP id l64so23684988qkb.5
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 09:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Tbz4Llm/4l7fjtRQCiC4O/nrvoLwptRAGpztTTGChds=;
        b=s0VQNg6llkx51zJubhuRV81XkomkbxAV/nmtQdncZWrGz5ct5Ynp9JZhnkpoS0muNv
         2FM6bhTEWbDWZpKbi3Wdjz1ktBxLw1v1Vu97sRwWvh5RXbQjmWPn8c99H8OpSySrL+Tb
         xD3bjRe6vRSWH1ta/iDhItbjgNrKNwqiDZwn+qw0CuK9zOUQrflwvJBCTgfJjMcPPQm6
         WJysAvSDjEOI7uJNhkc+tXGwvvMHWh74SDXzfYnHGER0L+CI+mhPnc7BRHpG9Ax+Y1Pm
         WCrEVnt7lUoqu6RuXh9lijsdFgqC9M4Yu//Q4ta5Wrgt1WYr+2+abPAhcIa9tJzNcOB+
         RT4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Tbz4Llm/4l7fjtRQCiC4O/nrvoLwptRAGpztTTGChds=;
        b=FsJScUpx3iieQnc5zRtUC0OsBC5ngtjA6dM/PQkWDuzrLHVliTWPbtVB4H0lA723JC
         dsDKcMKwj5PMQY/Lc7Fbi/AEOFD8THMLWdm0Va9tm2gCKQ8g0Lg+GGTZ4nTdCPilYcd9
         nDwQXMDv+8WYpDpq1KgoXWJ7jfTIqdmGWf1HpxFjIBKVyX4wocjsBga7wBMKyT5m94U8
         tmYZae6F+GMfVoAn3/oxMPBCX6ipMEmq7RUu/9S2X4/VM0OYCc0p4EvVJahi887Fofh5
         OgHOPOIZ65L97ZSA3BSsZoB648Bktpzdje/qZUA3NzNB/yLLMWwkUgPI6M6PRDcDYX+/
         6PiQ==
X-Gm-Message-State: APjAAAXyMl0iL0AADPP18OlxOKKdcR9EF+RrWux5I+lcJ4NSuVjf5/Uf
        uLE6F4epflbgf2+ZQ4xjSGLqtdSj6fWgvvzu5CnYi0JdHRWfrW+Ecv06qBT0z0e7+LsuWb6FgwL
        t/E+dqbkf67tEfL4zneSmIJKi3Xenuy6CerzE2SRPy2KdmqyazH9ubw==
X-Google-Smtp-Source: APXvYqwYVnKA79WdSsPE3RVtyuyaYVCq8vJILrhSa54pH2Ae1s8MRx8Eg3ZI3MzsEGswEsR34s/s9lw=
X-Received: by 2002:a37:470a:: with SMTP id u10mr11515071qka.17.1567614319295;
 Wed, 04 Sep 2019 09:25:19 -0700 (PDT)
Date:   Wed,  4 Sep 2019 09:25:06 -0700
In-Reply-To: <20190904162509.199561-1-sdf@google.com>
Message-Id: <20190904162509.199561-4-sdf@google.com>
Mime-Version: 1.0
References: <20190904162509.199561-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH bpf-next 3/6] selftests/bpf: test_progs: convert test_sockopt_sk
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the files, adjust includes, remove entry from Makefile & .gitignore

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/.gitignore        |  1 -
 tools/testing/selftests/bpf/Makefile          |  3 +-
 .../sockopt_sk.c}                             | 60 ++++---------------
 tools/testing/selftests/bpf/test_progs.h      |  3 +-
 4 files changed, 15 insertions(+), 52 deletions(-)
 rename tools/testing/selftests/bpf/{test_sockopt_sk.c => prog_tests/sockopt_sk.c} (79%)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 0315120eac8f..bc83c1a7ea1b 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -39,7 +39,6 @@ libbpf.so.*
 test_hashmap
 test_btf_dump
 xdping
-test_sockopt_sk
 test_sockopt_multi
 test_sockopt_inherit
 test_tcp_rtt
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 08e2183974d5..ea790901297c 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -28,7 +28,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
-	test_btf_dump test_cgroup_attach xdping test_sockopt_sk \
+	test_btf_dump test_cgroup_attach xdping \
 	test_sockopt_multi test_sockopt_inherit test_tcp_rtt
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
@@ -109,7 +109,6 @@ $(OUTPUT)/test_netcnt: cgroup_helpers.c
 $(OUTPUT)/test_sock_fields: cgroup_helpers.c
 $(OUTPUT)/test_sysctl: cgroup_helpers.c
 $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
-$(OUTPUT)/test_sockopt_sk: cgroup_helpers.c
 $(OUTPUT)/test_sockopt_multi: cgroup_helpers.c
 $(OUTPUT)/test_sockopt_inherit: cgroup_helpers.c
 $(OUTPUT)/test_tcp_rtt: cgroup_helpers.c
diff --git a/tools/testing/selftests/bpf/test_sockopt_sk.c b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
similarity index 79%
rename from tools/testing/selftests/bpf/test_sockopt_sk.c
rename to tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
index e4f6055d92e9..2061a6beac0f 100644
--- a/tools/testing/selftests/bpf/test_sockopt_sk.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
@@ -1,23 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
-
-#include <errno.h>
-#include <stdio.h>
-#include <unistd.h>
-#include <sys/types.h>
-#include <sys/socket.h>
-#include <netinet/in.h>
-#include <netinet/tcp.h>
-
-#include <linux/filter.h>
-#include <bpf/bpf.h>
-#include <bpf/libbpf.h>
-
-#include "bpf_rlimit.h"
-#include "bpf_util.h"
+#include <test_progs.h>
 #include "cgroup_helpers.h"
 
-#define CG_PATH				"/sockopt"
-
 #define SOL_CUSTOM			0xdeadbeef
 
 static int getsetsockopt(void)
@@ -176,7 +160,7 @@ static int prog_attach(struct bpf_object *obj, int cgroup_fd, const char *title)
 	return 0;
 }
 
-static int run_test(int cgroup_fd)
+static void run_test(int cgroup_fd)
 {
 	struct bpf_prog_load_attr attr = {
 		.file = "./sockopt_sk.o",
@@ -186,51 +170,31 @@ static int run_test(int cgroup_fd)
 	int err;
 
 	err = bpf_prog_load_xattr(&attr, &obj, &ignored);
-	if (err) {
-		log_err("Failed to load BPF object");
-		return -1;
-	}
+	if (CHECK_FAIL(err))
+		return;
 
 	err = prog_attach(obj, cgroup_fd, "cgroup/getsockopt");
-	if (err)
+	if (CHECK_FAIL(err))
 		goto close_bpf_object;
 
 	err = prog_attach(obj, cgroup_fd, "cgroup/setsockopt");
-	if (err)
+	if (CHECK_FAIL(err))
 		goto close_bpf_object;
 
-	err = getsetsockopt();
+	CHECK_FAIL(getsetsockopt());
 
 close_bpf_object:
 	bpf_object__close(obj);
-	return err;
 }
 
-int main(int args, char **argv)
+void test_sockopt_sk(void)
 {
 	int cgroup_fd;
-	int err = EXIT_SUCCESS;
-
-	if (setup_cgroup_environment())
-		goto cleanup_obj;
-
-	cgroup_fd = create_and_get_cgroup(CG_PATH);
-	if (cgroup_fd < 0)
-		goto cleanup_cgroup_env;
-
-	if (join_cgroup(CG_PATH))
-		goto cleanup_cgroup;
-
-	if (run_test(cgroup_fd))
-		err = EXIT_FAILURE;
 
-	printf("test_sockopt_sk: %s\n",
-	       err == EXIT_SUCCESS ? "PASSED" : "FAILED");
+	cgroup_fd = test__join_cgroup("/sockopt_sk");
+	if (CHECK_FAIL(cgroup_fd < 0))
+		return;
 
-cleanup_cgroup:
+	run_test(cgroup_fd);
 	close(cgroup_fd);
-cleanup_cgroup_env:
-	cleanup_cgroup_environment();
-cleanup_obj:
-	return err;
 }
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index e518bd5da3e2..0c48f64f732b 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -16,9 +16,10 @@ typedef __u16 __sum16;
 #include <linux/if_packet.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
-#include <linux/tcp.h>
+#include <netinet/tcp.h>
 #include <linux/filter.h>
 #include <linux/perf_event.h>
+#include <linux/socket.h>
 #include <linux/unistd.h>
 
 #include <sys/ioctl.h>
-- 
2.23.0.187.g17f5b7556c-goog

