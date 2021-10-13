Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826FB42B937
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 09:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238503AbhJMHgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 03:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238504AbhJMHgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 03:36:13 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA27C061570;
        Wed, 13 Oct 2021 00:34:10 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g184so1499256pgc.6;
        Wed, 13 Oct 2021 00:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qbGo4wG3gt4pjoUoMrdXI7XbEU3KYhvYRlct/YMJVo4=;
        b=LbnllyqdA9pdo440+T6f90Xq04tUyCk8zIBmSqYKNF8NB5nGpBIA7cHQ2CS6lo2aQt
         pFc3yjXfCGe/Lhw1pBbCpT/MndtjsY5ZlKXxxzWAx6E38WaUr1i9rMLyXlgPiD1hHngl
         80HYgoQ5PiwnYppRitXlNrQsZn3xbiZhoCobUsOKWuksxEU8FMEUapH1rOuGIveXJui0
         lQBl23WfwJmeGe+9EVqRH14K7XZr9qOpSuXjUajb5YQsHYSInr5XDuqDmdDbt9aTkCVA
         PL8mwC/DuN4iGeiTat+nds7hMzZQKC3bpl22PCN9h4eFZV4SdkILJaFkR1YDLansj5du
         +HXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qbGo4wG3gt4pjoUoMrdXI7XbEU3KYhvYRlct/YMJVo4=;
        b=eNYBrYYvMH3FojYB7nbq5Uao714IQXJ5Inl8LZhHnPEUKO/Z6EzwXieF2jl87xzokE
         WNryLOi/gd9Ho15HY1dZrQAoFpGsXMQaJXTse8+2p9ne8FLhLOAC3ditVc4UoZkXlOFX
         XXGhCdKA5F0JEETSJfa0xXNl/DnpM3WaEwr/vP2LIFniJRSF7SXuU7riq4/kO1Ejk8Bx
         +1OIvHvDHM4nK8C/1QPwdAVM5qGfYQVwd9jDEga8G3GhEFoXuuXdAS9SrSSN5sK0EQIw
         wIYR1GJgjbcblQhBa21tuvMulnb2V7q8dquCm8rBTMStIEWH62DkDSqrTwWyOALYiiFQ
         wT4A==
X-Gm-Message-State: AOAM530Jcr+lYWJEdmoz9PvZYLX73S9r9n6OpN/QohW68hnjv/GVUxi8
        64ldSVmPskgv38nMqdipOgOlV56ZjiY=
X-Google-Smtp-Source: ABdhPJzZJ+1ThuEixhm7ejHdJ1l2Wohd2neqaB70u646Qe8+AMLUTaOAux5FifB7sOrET9/ZGhgpyw==
X-Received: by 2002:a05:6a00:a1e:b0:44c:7602:e1ee with SMTP id p30-20020a056a000a1e00b0044c7602e1eemr36381580pfh.80.1634110449849;
        Wed, 13 Oct 2021 00:34:09 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id n22sm6984022pfo.15.2021.10.13.00.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 00:34:09 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 6/8] selftests/bpf: Add weak/typeless ksym test for light skeleton
Date:   Wed, 13 Oct 2021 13:03:46 +0530
Message-Id: <20211013073348.1611155-7-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013073348.1611155-1-memxor@gmail.com>
References: <20211013073348.1611155-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9292; h=from:subject; bh=cMq8uTjSHpzrUaBvQLnxunJI5MsYfZgnVFAVbicOEDE=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhZovSFbi286v049c0guENJOqNcZ0BPZHvAzyAq//s CCe2o3OJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYWaL0gAKCRBM4MiGSL8Rys7YD/ 91eqAGQGnPe6Ds+oEV1ihJHpn3KjOsKXks3+JACUn1UtBhGBvbFgbJStv/KVV5GQ6ipgxUNzBwVonS 7+vEQPUBpxXylOI9W2pP4GqXbYKVXoaNKsZOKU+7BjPxOEhwVSeh2e/lrArRvZd8YRvGsSHhJuIL0v KtxDAjQWsYPuq6rZWexnmtpVPLeXp15zF2VynQ1W9t7m62gFe7T3rbnidY2buizqJm/GBTD1H0RN0W 7ShzJHZUNXYVIVK9HhJvOf25H5UXIe3eQy29yxjUPhVZdCynj8Dv5RqGh4yYn/kY5OTQAch0V6Lsje Sec2qLxluEaTFdDLN4sEfKxoUxSbFyEPHEIgO548BRc92u//vcc7OJkhr3/e2kkD/f9JZ+86YXYWLI 1U2CU04aMhhTkBnm8n0PgDkdOgdAr7zM5cfQ2AJ05jYZdYMqZujdI7BUecN/pQqRoxf9KbJwNS1R4x /DnSQ2TdWfzqVabSV7s50witgrzUrYvC4ZC2NU7pZMIWiO5HVaCbl/LYYi5za6/Ku8MJfoPujgGUJ1 oEElzw0heDzu7R9vhmARzTOtOzT1fCNE30tgJf6z46djS2hJy4dKmPO93r2+NdOI1rKKFMd8VZ7wGC c6j+Z4N8b9bvlKH4TDajdfLbjggLnO0yqUasSWa8cK069MoULueC0V0b1JXQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also, avoid using CO-RE features, as lskel doesn't support CO-RE, yet.
Create a file for testing libbpf skeleton as well, so that both
gen_loader and libbpf get tested.

In c48e51c8b07a ("bpf: selftests: Add selftests for module kfunc support"),
I added support for generating both lskel and libbpf skel for a BPF
object, however the name parameter for bpftool caused collisions when
included in same file together. This meant that every test needed a
separate file for a libbpf/light skeleton separation instead of
subtests.

Change that by appending a "_light" suffix to the name for files listed
in LSKELS_EXTRA, such that both light and libbpf skeleton can be used in
the same file for subtests, leading to better code sharing.

While at it, improve the build output by saying GEN-LSKEL instead of
GEN-SKEL for light skeleton generation recipe.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/Makefile          |  7 ++--
 .../selftests/bpf/prog_tests/ksyms_btf.c      | 35 +++++++++++++++-
 .../selftests/bpf/prog_tests/ksyms_module.c   | 40 +++++++++++++++++--
 .../bpf/prog_tests/ksyms_module_libbpf.c      | 28 -------------
 .../selftests/bpf/progs/test_ksyms_weak.c     |  3 +-
 5 files changed, 74 insertions(+), 39 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 498222543c37..1c3c8befc249 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -325,7 +325,7 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
 LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
 	test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c
 # Generate both light skeleton and libbpf skeleton for these
-LSKELS_EXTRA := test_ksyms_module.c
+LSKELS_EXTRA := test_ksyms_module.c test_ksyms_weak.c
 SKEL_BLACKLIST += $$(LSKELS)
 
 test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
@@ -399,12 +399,13 @@ $(TRUNNER_BPF_SKELS): %.skel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$(Q)$$(BPFTOOL) gen skeleton $$(<:.o=.linked3.o) name $$(notdir $$(<:.o=)) > $$@
 
 $(TRUNNER_BPF_LSKELS): %.lskel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
-	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
+	$$(call msg,GEN-LSKEL,$(TRUNNER_BINARY),$$@)
 	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked1.o) $$<
 	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked2.o) $$(<:.o=.linked1.o)
 	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked3.o) $$(<:.o=.linked2.o)
 	$(Q)diff $$(<:.o=.linked2.o) $$(<:.o=.linked3.o)
-	$(Q)$$(BPFTOOL) gen skeleton -L $$(<:.o=.linked3.o) name $$(notdir $$(<:.o=)) > $$@
+	$$(eval LSKEL_NAME := $$(notdir $$(<:.o=$$(if $$(filter $$(notdir $$(<:.o=.c)),$(LSKELS_EXTRA)),_light,))))
+	$(Q)$$(BPFTOOL) gen skeleton -L $$(<:.o=.linked3.o) name $$(LSKEL_NAME) > $$@
 
 $(TRUNNER_BPF_SKELS_LINKED): $(TRUNNER_BPF_OBJS) $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$$(call msg,LINK-BPF,$(TRUNNER_BINARY),$$(@:.skel.h=.o))
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
index cf3acfa5a91d..9f4853781702 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
@@ -7,6 +7,7 @@
 #include "test_ksyms_btf.skel.h"
 #include "test_ksyms_btf_null_check.skel.h"
 #include "test_ksyms_weak.skel.h"
+#include "test_ksyms_weak.lskel.h"
 
 static int duration;
 
@@ -89,11 +90,11 @@ static void test_weak_syms(void)
 	int err;
 
 	skel = test_ksyms_weak__open_and_load();
-	if (CHECK(!skel, "test_ksyms_weak__open_and_load", "failed\n"))
+	if (!ASSERT_OK_PTR(skel, "test_ksyms_weak__open_and_load"))
 		return;
 
 	err = test_ksyms_weak__attach(skel);
-	if (CHECK(err, "test_ksyms_weak__attach", "skeleton attach failed: %d\n", err))
+	if (!ASSERT_OK(err, "test_ksyms_weak__attach"))
 		goto cleanup;
 
 	/* trigger tracepoint */
@@ -109,6 +110,33 @@ static void test_weak_syms(void)
 	test_ksyms_weak__destroy(skel);
 }
 
+static void test_weak_syms_light(void)
+{
+	struct test_ksyms_weak_light *skel;
+	struct test_ksyms_weak_light__data *data;
+	int err;
+
+	skel = test_ksyms_weak_light__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_ksyms_weak_light__open_and_load"))
+		return;
+
+	err = test_ksyms_weak_light__attach(skel);
+	if (!ASSERT_OK(err, "test_ksyms_weak_light__attach"))
+		goto cleanup;
+
+	/* trigger tracepoint */
+	usleep(1);
+
+	data = skel->data;
+	ASSERT_EQ(data->out__existing_typed, 0, "existing typed ksym");
+	ASSERT_NEQ(data->out__existing_typeless, -1, "existing typeless ksym");
+	ASSERT_EQ(data->out__non_existent_typeless, 0, "nonexistent typeless ksym");
+	ASSERT_EQ(data->out__non_existent_typed, 0, "nonexistent typed ksym");
+
+cleanup:
+	test_ksyms_weak_light__destroy(skel);
+}
+
 void test_ksyms_btf(void)
 {
 	int percpu_datasec;
@@ -136,4 +164,7 @@ void test_ksyms_btf(void)
 
 	if (test__start_subtest("weak_ksyms"))
 		test_weak_syms();
+
+	if (test__start_subtest("weak_ksyms_light"))
+		test_weak_syms_light();
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
index 831447878d7b..653a1352ccb8 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
@@ -4,10 +4,11 @@
 #include <test_progs.h>
 #include <network_helpers.h>
 #include "test_ksyms_module.lskel.h"
+#include "test_ksyms_module.skel.h"
 
-void test_ksyms_module(void)
+void test_ksyms_module_light(void)
 {
-	struct test_ksyms_module *skel;
+	struct test_ksyms_module_light *skel;
 	int retval;
 	int err;
 
@@ -16,8 +17,8 @@ void test_ksyms_module(void)
 		return;
 	}
 
-	skel = test_ksyms_module__open_and_load();
-	if (!ASSERT_OK_PTR(skel, "test_ksyms_module__open_and_load"))
+	skel = test_ksyms_module_light__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_ksyms_module_light__open_and_load"))
 		return;
 	err = bpf_prog_test_run(skel->progs.load.prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
 				NULL, NULL, (__u32 *)&retval, NULL);
@@ -25,6 +26,37 @@ void test_ksyms_module(void)
 		goto cleanup;
 	ASSERT_EQ(retval, 0, "retval");
 	ASSERT_EQ(skel->bss->out_bpf_testmod_ksym, 42, "bpf_testmod_ksym");
+cleanup:
+	test_ksyms_module_light__destroy(skel);
+}
+
+void test_ksyms_module_libbpf(void)
+{
+	struct test_ksyms_module *skel;
+	int retval, err;
+
+	if (!env.has_testmod) {
+		test__skip();
+		return;
+	}
+
+	skel = test_ksyms_module__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_ksyms_module__open"))
+		return;
+	err = bpf_prog_test_run(bpf_program__fd(skel->progs.load), 1, &pkt_v4,
+				sizeof(pkt_v4), NULL, NULL, (__u32 *)&retval, NULL);
+	if (!ASSERT_OK(err, "bpf_prog_test_run"))
+		goto cleanup;
+	ASSERT_EQ(retval, 0, "retval");
+	ASSERT_EQ(skel->bss->out_bpf_testmod_ksym, 42, "bpf_testmod_ksym");
 cleanup:
 	test_ksyms_module__destroy(skel);
 }
+
+void test_ksyms_module(void)
+{
+	if (test__start_subtest("light"))
+		test_ksyms_module_light();
+	if (test__start_subtest("libbpf"))
+		test_ksyms_module_libbpf();
+}
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
deleted file mode 100644
index e6343ef63af9..000000000000
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
+++ /dev/null
@@ -1,28 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include <test_progs.h>
-#include <network_helpers.h>
-#include "test_ksyms_module.skel.h"
-
-void test_ksyms_module_libbpf(void)
-{
-	struct test_ksyms_module *skel;
-	int retval, err;
-
-	if (!env.has_testmod) {
-		test__skip();
-		return;
-	}
-
-	skel = test_ksyms_module__open_and_load();
-	if (!ASSERT_OK_PTR(skel, "test_ksyms_module__open"))
-		return;
-	err = bpf_prog_test_run(bpf_program__fd(skel->progs.load), 1, &pkt_v4,
-				sizeof(pkt_v4), NULL, NULL, (__u32 *)&retval, NULL);
-	if (!ASSERT_OK(err, "bpf_prog_test_run"))
-		goto cleanup;
-	ASSERT_EQ(retval, 0, "retval");
-	ASSERT_EQ(skel->bss->out_bpf_testmod_ksym, 42, "bpf_testmod_ksym");
-cleanup:
-	test_ksyms_module__destroy(skel);
-}
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_weak.c b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
index 5f8379aadb29..521e7b99db08 100644
--- a/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_weak.c
@@ -21,7 +21,6 @@ __u64 out__non_existent_typed = -1;
 extern const struct rq runqueues __ksym __weak; /* typed */
 extern const void bpf_prog_active __ksym __weak; /* typeless */
 
-
 /* non-existent weak symbols. */
 
 /* typeless symbols, default to zero. */
@@ -38,7 +37,7 @@ int pass_handler(const void *ctx)
 	/* tests existing symbols. */
 	rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, 0);
 	if (rq)
-		out__existing_typed = rq->cpu;
+		out__existing_typed = 0;
 	out__existing_typeless = (__u64)&bpf_prog_active;
 
 	/* tests non-existent symbols. */
-- 
2.33.0

