Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 553DDAA74F
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 17:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390439AbfIEP1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 11:27:24 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:48822 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390429AbfIEP1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 11:27:23 -0400
Received: by mail-pl1-f201.google.com with SMTP id r9so1654847plo.15
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 08:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PKBNn7QHICb88J96DR4dcB71cwak21YXIgp4bI9raYQ=;
        b=F2XORRjW42vLc+Dr4Fybkid7ICSDsRkq8sQZLq5LP2eBNCmhFFmY6TX+hJ19yQ4Qbn
         RlUslw80Vf3NGFrrAKD6FJ0+UGQvE+lEySR2TomNesKBkXlUwQQOjmUG9FtfdV92HIIg
         go/uVWbgOvFuL5u7mblwpDtRbnrrYbJdRo9e66oLvL7DRT4zO2rYzPvsFUdtZ6fDc8Hy
         zV3wkMqgmS2RekUwgN1ckQOGh5OvDCgh9sP+tRioANEHlpQxxvu8a3V0kFJ++Infh4s5
         byXyzslu2RagyIwiaYDwi3vPugkHef94VSikVC1yU1DV1QZ25F4z9PursChIF0D5ebHk
         SsNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PKBNn7QHICb88J96DR4dcB71cwak21YXIgp4bI9raYQ=;
        b=tGDu5AzXXhnJs5OHI98yR3VlM95KXLR83PXQyVbPt+MkD9vEP+cO2xat4I5HAOgkEN
         pkY+9A71T48Z6PChl+um5fuwMceMbDL8hIQ7oLTiRC59/IoN7CLs7ajesGI+UG0VtbBq
         jSgJKnBoarQADhj7pSYejVkvlXOXrJT4UFLLh0v1TtOxfmnEW1wJbB2WxtOmsHR4IFHT
         9aHrFg1cCKBWU/qq8j+ctTgQz5Ji+AqRj/XdqWMICo9QCqbRl4InyddDKczkc1DSZWrT
         Q3JRahemvtycrxCTvzUZzQddCd19G+VI8y1Yp916/eWGCEnEfDbe12+X/8Kwflg4y0RE
         0OOA==
X-Gm-Message-State: APjAAAXFFJ4KvGHmAtKhJs28U826pvTxHOMA9abE8G4n6cWNSXb7YnMT
        pDuMlywLqS8pQbOqVpr/14M2LHVDnvmk8JwY4lp2tVWXL25edJE0PZcCWbsHl6+Qha4Yb9FfPX2
        kKzq3HZ4XbGdlkamZaLHCKKWBEccxkMLrUgT/Mk6OofjTnB8lZBU90w==
X-Google-Smtp-Source: APXvYqwvtRzM3yZx+LcV3hYVAFTJ9ZOr6zoo/ux0/mAhLsU8ZILtsNjs7jGd/jbag1PTNb2cEH4N3nw=
X-Received: by 2002:a65:62d1:: with SMTP id m17mr3858400pgv.271.1567697241474;
 Thu, 05 Sep 2019 08:27:21 -0700 (PDT)
Date:   Thu,  5 Sep 2019 08:27:07 -0700
In-Reply-To: <20190905152709.111193-1-sdf@google.com>
Message-Id: <20190905152709.111193-5-sdf@google.com>
Mime-Version: 1.0
References: <20190905152709.111193-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH bpf-next v2 4/6] selftests/bpf: test_progs: convert test_sockopt_multi
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
 .../sockopt_multi.c}                          | 62 +++----------------
 3 files changed, 11 insertions(+), 55 deletions(-)
 rename tools/testing/selftests/bpf/{test_sockopt_multi.c => prog_tests/sockopt_multi.c} (83%)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index bc83c1a7ea1b..4143add5a11e 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -39,6 +39,5 @@ libbpf.so.*
 test_hashmap
 test_btf_dump
 xdping
-test_sockopt_multi
 test_sockopt_inherit
 test_tcp_rtt
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index ea790901297c..271f8ce89c97 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -29,7 +29,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
 	test_btf_dump test_cgroup_attach xdping \
-	test_sockopt_multi test_sockopt_inherit test_tcp_rtt
+	test_sockopt_inherit test_tcp_rtt
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
@@ -109,7 +109,6 @@ $(OUTPUT)/test_netcnt: cgroup_helpers.c
 $(OUTPUT)/test_sock_fields: cgroup_helpers.c
 $(OUTPUT)/test_sysctl: cgroup_helpers.c
 $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
-$(OUTPUT)/test_sockopt_multi: cgroup_helpers.c
 $(OUTPUT)/test_sockopt_inherit: cgroup_helpers.c
 $(OUTPUT)/test_tcp_rtt: cgroup_helpers.c
 
diff --git a/tools/testing/selftests/bpf/test_sockopt_multi.c b/tools/testing/selftests/bpf/prog_tests/sockopt_multi.c
similarity index 83%
rename from tools/testing/selftests/bpf/test_sockopt_multi.c
rename to tools/testing/selftests/bpf/prog_tests/sockopt_multi.c
index 4be3441db867..29188d6f5c8d 100644
--- a/tools/testing/selftests/bpf/test_sockopt_multi.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_multi.c
@@ -1,19 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-
-#include <error.h>
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
 
 static int prog_attach(struct bpf_object *obj, int cgroup_fd, const char *title)
@@ -308,7 +294,7 @@ static int run_setsockopt_test(struct bpf_object *obj, int cg_parent,
 	return err;
 }
 
-int main(int argc, char **argv)
+void test_sockopt_multi(void)
 {
 	struct bpf_prog_load_attr attr = {
 		.file = "./sockopt_multi.o",
@@ -319,56 +305,28 @@ int main(int argc, char **argv)
 	int err = -1;
 	int ignored;
 
-	if (setup_cgroup_environment()) {
-		log_err("Failed to setup cgroup environment\n");
-		goto out;
-	}
-
-	cg_parent = create_and_get_cgroup("/parent");
-	if (cg_parent < 0) {
-		log_err("Failed to create cgroup /parent\n");
-		goto out;
-	}
-
-	cg_child = create_and_get_cgroup("/parent/child");
-	if (cg_child < 0) {
-		log_err("Failed to create cgroup /parent/child\n");
+	cg_parent = test__join_cgroup("/parent");
+	if (CHECK_FAIL(cg_parent < 0))
 		goto out;
-	}
 
-	if (join_cgroup("/parent/child")) {
-		log_err("Failed to join cgroup /parent/child\n");
+	cg_child = test__join_cgroup("/parent/child");
+	if (CHECK_FAIL(cg_child < 0))
 		goto out;
-	}
 
 	err = bpf_prog_load_xattr(&attr, &obj, &ignored);
-	if (err) {
-		log_err("Failed to load BPF object");
+	if (CHECK_FAIL(err))
 		goto out;
-	}
 
 	sock_fd = socket(AF_INET, SOCK_STREAM, 0);
-	if (sock_fd < 0) {
-		log_err("Failed to create socket");
+	if (CHECK_FAIL(sock_fd < 0))
 		goto out;
-	}
 
-	if (run_getsockopt_test(obj, cg_parent, cg_child, sock_fd))
-		err = -1;
-	printf("test_sockopt_multi: getsockopt %s\n",
-	       err ? "FAILED" : "PASSED");
-
-	if (run_setsockopt_test(obj, cg_parent, cg_child, sock_fd))
-		err = -1;
-	printf("test_sockopt_multi: setsockopt %s\n",
-	       err ? "FAILED" : "PASSED");
+	CHECK_FAIL(run_getsockopt_test(obj, cg_parent, cg_child, sock_fd));
+	CHECK_FAIL(run_setsockopt_test(obj, cg_parent, cg_child, sock_fd));
 
 out:
 	close(sock_fd);
 	bpf_object__close(obj);
 	close(cg_child);
 	close(cg_parent);
-
-	printf("test_sockopt_multi: %s\n", err ? "FAILED" : "PASSED");
-	return err ? EXIT_FAILURE : EXIT_SUCCESS;
 }
-- 
2.23.0.187.g17f5b7556c-goog

