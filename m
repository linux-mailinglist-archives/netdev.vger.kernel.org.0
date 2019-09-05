Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 150D7AA747
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 17:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390420AbfIEP1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 11:27:18 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:56689 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390412AbfIEP1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 11:27:17 -0400
Received: by mail-pl1-f201.google.com with SMTP id v4so1646278plp.23
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 08:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bj3xTPEhTNL/GdpXBmTQIcsjFTPbC6eexVZEhONF5Rc=;
        b=gVluAko2a/F3Nvstd2Tgbn2vJ3LuQ5zcIg8HCyr3CKxebMMzhLdhz9ipZbHPFzaQaH
         nhBSSHyoIio375Z7jF8AwkBTeRYu8fYoXvu8ffw8axc0ajO21RJDSkaLb+4Ofjvh30cV
         4sQ8TAkgpV7w9pmaYZhrBGxXeSio+3NAgygFBibqYd9oWzeBKd/kYDEFMtLI1t6etTXp
         kqnv2vibb24J4VO7qArGYbIH/Y4deah667PDvfFQGXZG6COmwBRyXQ5E3aGgNReR4mRM
         QHlR5y8u7W7BtMJ5V1+2mIX5mT8QERSxZCoGmIn9m2SG3+V7Pe14PHhIDEc4Yrh8hVmx
         MbKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bj3xTPEhTNL/GdpXBmTQIcsjFTPbC6eexVZEhONF5Rc=;
        b=KwGPa9RCJo7usig9wMfHiS6OOpNg2F0OwrHwSu2gFzp6QwElA24ORDXJWLn27ffo8U
         MMWUFUf6pemvYEME2XOW6sFNWgW5e70t7Y0cyrhD55J5iWOwSLMXaSCNC5SnkLvrTW5N
         MI+UfRQhaAAQwbzcU4K9q7sGA31RrPLi2ptyvOODuWrKF41H0/tqAIOYKvH1Qhk/4q0g
         ciQ9qw4xllOQUWjT9+5fFikovJ/HXZ21jYEJx+jfh99REzAEoSni3rb2VrjO1GpRb5CK
         FYih/KzhzZ8v56+y7OCKvYZluOsI/aZn0d+2R+zcHNQ/a454+lN0E6KMAPbBQQ+YUU+n
         j7gQ==
X-Gm-Message-State: APjAAAWrsD5mGoV8U3leTZAJoLMjO28ReFEnDL3mSvOdmQ0NWQBcfsG+
        0aSLAQ8pEQtuzVIcZyq1TYhZ0oM7EzR+MOV9o73icsUV7mRp50kb7aj/RnEn6Al3sn/ywu/MyQc
        4PSqLnkdyOYb47mE1akZGciTsUxjj2crgZXE2t1jbgx9I9m50PESb2A==
X-Google-Smtp-Source: APXvYqyfrHAthA0CDE+zTEexx3zhUbqwQ6vy3mtZ675LFmKAm7PW+ioig4IqJgxkqpJ2Gg/lhRFwAMs=
X-Received: by 2002:a65:464d:: with SMTP id k13mr3309155pgr.99.1567697236440;
 Thu, 05 Sep 2019 08:27:16 -0700 (PDT)
Date:   Thu,  5 Sep 2019 08:27:05 -0700
In-Reply-To: <20190905152709.111193-1-sdf@google.com>
Message-Id: <20190905152709.111193-3-sdf@google.com>
Mime-Version: 1.0
References: <20190905152709.111193-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH bpf-next v2 2/6] selftests/bpf: test_progs: convert test_sockopt
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
 .../{test_sockopt.c => prog_tests/sockopt.c}  | 50 +++----------------
 3 files changed, 8 insertions(+), 46 deletions(-)
 rename tools/testing/selftests/bpf/{test_sockopt.c => prog_tests/sockopt.c} (96%)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 60c9338cd9b4..0315120eac8f 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -39,7 +39,6 @@ libbpf.so.*
 test_hashmap
 test_btf_dump
 xdping
-test_sockopt
 test_sockopt_sk
 test_sockopt_multi
 test_sockopt_inherit
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index e145954d3765..08e2183974d5 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -28,7 +28,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
-	test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk \
+	test_btf_dump test_cgroup_attach xdping test_sockopt_sk \
 	test_sockopt_multi test_sockopt_inherit test_tcp_rtt
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
@@ -109,7 +109,6 @@ $(OUTPUT)/test_netcnt: cgroup_helpers.c
 $(OUTPUT)/test_sock_fields: cgroup_helpers.c
 $(OUTPUT)/test_sysctl: cgroup_helpers.c
 $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
-$(OUTPUT)/test_sockopt: cgroup_helpers.c
 $(OUTPUT)/test_sockopt_sk: cgroup_helpers.c
 $(OUTPUT)/test_sockopt_multi: cgroup_helpers.c
 $(OUTPUT)/test_sockopt_inherit: cgroup_helpers.c
diff --git a/tools/testing/selftests/bpf/test_sockopt.c b/tools/testing/selftests/bpf/prog_tests/sockopt.c
similarity index 96%
rename from tools/testing/selftests/bpf/test_sockopt.c
rename to tools/testing/selftests/bpf/prog_tests/sockopt.c
index 23bd0819382d..64cffb94307c 100644
--- a/tools/testing/selftests/bpf/test_sockopt.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt.c
@@ -1,22 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
-
-#include <errno.h>
-#include <stdio.h>
-#include <unistd.h>
-#include <sys/types.h>
-#include <sys/socket.h>
-#include <netinet/in.h>
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
 static char bpf_log_buf[4096];
 static bool verbose;
 
@@ -983,39 +968,18 @@ static int run_test(int cgroup_fd, struct sockopt_test *test)
 	return ret;
 }
 
-int main(int args, char **argv)
+void test_sockopt(void)
 {
-	int err = EXIT_FAILURE, error_cnt = 0;
 	int cgroup_fd, i;
 
-	if (setup_cgroup_environment())
-		goto cleanup_obj;
-
-	cgroup_fd = create_and_get_cgroup(CG_PATH);
-	if (cgroup_fd < 0)
-		goto cleanup_cgroup_env;
-
-	if (join_cgroup(CG_PATH))
-		goto cleanup_cgroup;
+	cgroup_fd = test__join_cgroup("/sockopt");
+	if (CHECK_FAIL(cgroup_fd < 0))
+		return;
 
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
-		int err = run_test(cgroup_fd, &tests[i]);
-
-		if (err)
-			error_cnt++;
-
-		printf("#%d %s: %s\n", i, err ? "FAIL" : "PASS",
-		       tests[i].descr);
+		printf("#%d %s:\n", i, tests[i].descr);
+		CHECK_FAIL(run_test(cgroup_fd, &tests[i]));
 	}
 
-	printf("Summary: %ld PASSED, %d FAILED\n",
-	       ARRAY_SIZE(tests) - error_cnt, error_cnt);
-	err = error_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
-
-cleanup_cgroup:
 	close(cgroup_fd);
-cleanup_cgroup_env:
-	cleanup_cgroup_environment();
-cleanup_obj:
-	return err;
 }
-- 
2.23.0.187.g17f5b7556c-goog

