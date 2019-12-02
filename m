Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED1710F174
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 21:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfLBUVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 15:21:16 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:56174 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727468AbfLBUVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 15:21:15 -0500
Received: by mail-pj1-f73.google.com with SMTP id e7so560381pjt.22
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 12:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=bvI+VvT0mwJRxV4CSGLKiI5FoFxR8nOIzAj80OgL9+4=;
        b=BeqormwBbgHEK7VDNCrRV9zamznJ4fto1eMMn7VtThTRILbqLZOdgg/bmW2JBSrGXm
         yHuB1iYq035WBwRW146ZAf6IKKoEcAq2Kfv4RbUw/fzY6yVPswjXySPaN4ePegLXXsz1
         OCCLANwKhdWgbh0wh2qkDsT2LzucHsL8fVlbsKZ9YAIz0bHSUY+t1Y6YDF3wPu5Tpx5I
         khEJ/cz5RTEk0cg4WUN3pXO0im3QQyBLk9JzUppV9NDA0H+6YmQO615mXRY+5G28T8YC
         UzCk717X89vI4wqqEsytWbNu/HrQZDMUC6lCAeODiXCEohJSCVSyipPl5pwPb3RMs1d2
         wY/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=bvI+VvT0mwJRxV4CSGLKiI5FoFxR8nOIzAj80OgL9+4=;
        b=BTF9VcHON64ATYAptSJwae0onW87tRoEX9WZzFp3ge2RLqCu7MEtooM3hS6C4yLYmT
         MVDDp2NihkTqIDKKP5JnTiledXyjnuoISbq/lDZX74dzLBKfMvgpB7UfMVBSOssyBCMU
         NlBucPHNoOxhn8ZilKC1JycCLZA43Y1NcyVXgshn8xBNidDtFmnG3ReGmIZm+Xm+cbLR
         I76jbaIw16W5HsgG3JhKEGxxo4yJxDNizautjIClI//LUYpyKJDd7YRHxGsOFYgYWHCm
         lRPJvUR43ZDFCB4Y5aCa/rf0Bm3bc2wG8Dhw/LOJkCSBg4U0uZhIl+genuplyKta/+W7
         8NKQ==
X-Gm-Message-State: APjAAAVBqb8GV4mYAMyAoKf/j4gVcTkJ25P5ZOHyuunhG0lW53Bywfyc
        AbLQUfDKpN3Krv8qxsFnI1Vqj4kxglh5tKw13oIzYj+UodeUicfWvNhguNAOj9+xmTIgoJs39BV
        TrFzQcSMsaTipL4KdoqG/1HlnNjSOmWIk+TOuaEuyeNZiQSXWnrNl/A==
X-Google-Smtp-Source: APXvYqwMPO9gNr/fsyfvWR42Goj0GowjCDi5ISu25G2LQ3t+kcEWzztyk3v9BE9v44D468VqvtzlYXo=
X-Received: by 2002:a63:e216:: with SMTP id q22mr1003136pgh.362.1575318074945;
 Mon, 02 Dec 2019 12:21:14 -0800 (PST)
Date:   Mon,  2 Dec 2019 12:21:12 -0800
Message-Id: <20191202202112.167120-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH bpf] selftests/bpf: bring back c++ include/link test
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 5c26f9a78358 ("libbpf: Don't use cxx to test_libpf target")
converted existing c++ test to c. We still want to include and
link against libbpf from c++ code, so reinstate this test back,
this time in a form of a selftest with a clear comment about
its purpose.

Fixes: 5c26f9a78358 ("libbpf: Don't use cxx to test_libpf target")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/.gitignore                                    | 1 -
 tools/lib/bpf/Makefile                                      | 5 +----
 tools/testing/selftests/bpf/.gitignore                      | 1 +
 tools/testing/selftests/bpf/Makefile                        | 6 +++++-
 .../test_libbpf.c => testing/selftests/bpf/test_cpp.cpp}    | 0
 5 files changed, 7 insertions(+), 6 deletions(-)
 rename tools/{lib/bpf/test_libbpf.c => testing/selftests/bpf/test_cpp.cpp} (100%)

diff --git a/tools/lib/bpf/.gitignore b/tools/lib/bpf/.gitignore
index 35bf013e368c..e97c2ebcf447 100644
--- a/tools/lib/bpf/.gitignore
+++ b/tools/lib/bpf/.gitignore
@@ -1,7 +1,6 @@
 libbpf_version.h
 libbpf.pc
 FEATURE-DUMP.libbpf
-test_libbpf
 libbpf.so.*
 TAGS
 tags
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 3d3d024f7b94..defae23a0169 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -152,7 +152,7 @@ GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN_SHARED) | \
 VERSIONED_SYM_COUNT = $(shell readelf -s --wide $(OUTPUT)libbpf.so | \
 			      grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
 
-CMD_TARGETS = $(LIB_TARGET) $(PC_FILE) $(OUTPUT)test_libbpf
+CMD_TARGETS = $(LIB_TARGET) $(PC_FILE)
 
 all: fixdep
 	$(Q)$(MAKE) all_cmd
@@ -196,9 +196,6 @@ $(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN_SHARED)
 $(OUTPUT)libbpf.a: $(BPF_IN_STATIC)
 	$(QUIET_LINK)$(RM) $@; $(AR) rcs $@ $^
 
-$(OUTPUT)test_libbpf: test_libbpf.c $(OUTPUT)libbpf.a
-	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(INCLUDES) $^ -lelf -o $@
-
 $(OUTPUT)libbpf.pc:
 	$(QUIET_GEN)sed -e "s|@PREFIX@|$(prefix)|" \
 		-e "s|@LIBDIR@|$(libdir_SQ)|" \
diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 4865116b96c7..419652458da4 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -37,5 +37,6 @@ libbpf.so.*
 test_hashmap
 test_btf_dump
 xdping
+test_cpp
 /no_alu32
 /bpf_gcc
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 085678d88ef8..ba394f0bd631 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -71,7 +71,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 # Compile but not part of 'make run_tests'
 TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
-	test_lirc_mode2_user xdping
+	test_lirc_mode2_user xdping test_cpp
 
 TEST_CUSTOM_PROGS = urandom_read
 
@@ -317,6 +317,10 @@ verifier/tests.h: verifier/*.c
 $(OUTPUT)/test_verifier: test_verifier.c verifier/tests.h $(BPFOBJ) | $(OUTPUT)
 	$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
 
+# Make sure we are able to include and link libbpf against c++.
+$(OUTPUT)/test_cpp: test_cpp.cpp $(BPFOBJ)
+	$(CXX) $(CFLAGS) $^ -lelf -o $@
+
 EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)					\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
 	feature $(OUTPUT)/*.o $(OUTPUT)/no_alu32 $(OUTPUT)/bpf_gcc
diff --git a/tools/lib/bpf/test_libbpf.c b/tools/testing/selftests/bpf/test_cpp.cpp
similarity index 100%
rename from tools/lib/bpf/test_libbpf.c
rename to tools/testing/selftests/bpf/test_cpp.cpp
-- 
2.24.0.393.g34dc348eaf-goog

