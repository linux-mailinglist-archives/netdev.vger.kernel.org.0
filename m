Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C534353A6
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 21:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhJTTSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 15:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhJTTSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 15:18:01 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64384C06161C;
        Wed, 20 Oct 2021 12:15:47 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id n8-20020a17090a2bc800b00196286963b9so1264843pje.3;
        Wed, 20 Oct 2021 12:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=okPjonIu2jOHO+f6qmEV/MQUpNLPFAQnLmDe4OUzVKA=;
        b=FLPLBmqOJk0Fv5ns9MpbrA5NO+v8RhJP3YInIB7T1Z4iUXe67U9InOxb5WGZ2QzThs
         4QYc0/vWuQAgTzCB9BtQQqbUFdWg6kfY7ybvuviAHjWWSwhjfQCrluNfgCx+dfMLrnEn
         uFKsq1bO6MHGKJjVljYWi6Zgj5XDzRkJF3bIsVr7+7SOFGJh+TdQfv427AtcB+vurhvZ
         J3D2MRdEfSRSyoAsRTBTnqodkBIDiK6G2twSqndCKYKxNfnWLQPUsxrC3NE5+rs57xM2
         1NFZAuIRTZQewYKQfQS9mmFL44cY/R/vrfxWLNL7O88HpEi2pcyhOXo206UuWAichHqM
         SdYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=okPjonIu2jOHO+f6qmEV/MQUpNLPFAQnLmDe4OUzVKA=;
        b=sktrvkWBuiPzx4xHLR6oIDEKNLYV6I4893ptWXDYvU8Ht03XYZcE9WWy/cRNA8ATQH
         RFYBfRyflBpwY2SkNXJt+D6xux3Ah/D8g8Zd6rJCc94w+9sAj62V4RUs1ZOTl00SIYIm
         ogc3gAhIF1sz/cnqu8Xa1we/+k8R+joxsbyd4XRa+ShqNj7C1kNDjHdBqUkK8UUTAyCT
         piAckRHX/2vFep+5YQrxwCkfi6VFhVnspcGVWRrzLEv9Gz/izcLcadl+bj0+fRYGSFPY
         Ns0vi5go4Q6U0i05Bvxuw+x8x2EVSvd8gP10++zO6fAo1tCb5aESGG34G03fB7nZqc1q
         SDIg==
X-Gm-Message-State: AOAM5316adcFRjqp99ZwqGkVdKQb2mlGzgd/5vqoeXHKluR1FRF4Rjjw
        ws7Psvda5NiN9v77jSAd/rniYxgtbO74yg==
X-Google-Smtp-Source: ABdhPJyg/v2QgDMYyoOXAnioMgN0qpzsjx1uOd/lAsp7lwrQP+g+0NWLCyjiIttib0N1yI2LeH3Wmg==
X-Received: by 2002:a17:90b:4b4d:: with SMTP id mi13mr812929pjb.187.1634757346740;
        Wed, 20 Oct 2021 12:15:46 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id q6sm2896952pgc.1.2021.10.20.12.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 12:15:46 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 6/8] selftests/bpf: Add weak/typeless ksym test for light skeleton
Date:   Thu, 21 Oct 2021 00:45:24 +0530
Message-Id: <20211020191526.2306852-7-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211020191526.2306852-1-memxor@gmail.com>
References: <20211020191526.2306852-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9277; h=from:subject; bh=3tlllnBa+3mGbVRKiws2/GC60aYzJM+M9O43CSU15wk=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhcGoeUJ841bUdqoR80w7C67W9PT9LH5iWDNm+6pXj 0vKcylKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYXBqHgAKCRBM4MiGSL8Ryp8aEA DCVTn5vNUxYFarWKhqRDeTy0iQQG2uDAd0fybzmnzBOTcUxrUSbGb3E5Ckrh35vUqGM9epLsELJrG+ rvjgE8KjuRI6CKwIzMQP5+W4dIDdcrZ8Qh0Gk2IUxMOTx0sRK6z58Ywv7inGUC6XtjX8/NKZGLamCr WoJACExSRrOpVBBfpnXXr/jZdqyaqEIjJSbZ4/eHNceonMymi9hkuUgd1OYlnL458Hd4d7+D24W1Qg erWVBSUTbUFoWtIt1WaF9VMNs5bkuQS3ZUcO2gw63+wdLGD5kvjlRKuUY8edpY5Yq6qUwhtMWOaNLA +J7MV7462mqJ0JfcId3WpjsBSnwqDk9eqVeUyGjwieZTkTFtacAoJAZxzHeIgH60WXUpDQes2pG+Tz y8DbSIKAo6gg0DEhgQp3eh4U4MTeK04BNdsCEpi9NuNdtNDVJPIDO7RHJIIp08qjVuI3PQA/mez8OH EoybKiG2D9INmDtZeOqAE9J4+7tbLLKvMAGK5XFLKBlROhyqKbm1F8SmFcb4lKzy+nquBX/PVI3qkg eyaECQNe0HOv3EKMWoDinPE9oGCoUq8SJDUFKRE+pTIK3IWsLuRxI60i0jDmoS/RlrsYLgvmlLw4Va uHDZorQkDPhgEpDaoUu38WGqTCy8iObQ/h9Ok/azXQu4EqEeYig7URpHoLUA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also, avoid using CO-RE features, as lskel doesn't support CO-RE, yet.
Include both light and libbpf skeleton in same file to test both of them
together.

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
2.33.1

