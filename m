Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D9C41F91A
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 03:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbhJBBU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 21:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbhJBBUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 21:20:13 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986C2C061775;
        Fri,  1 Oct 2021 18:18:28 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so323345pjc.3;
        Fri, 01 Oct 2021 18:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x6uiy0Fi4DBzMHCmE4tRzDc8+wcLbvPYqf7wbXv9smM=;
        b=I90FULdfuWqnh5dhJdsAKb5sHc/c5yRWfiWPoMerR2iczavYwSrdkujxbxoMwarast
         xAVYtY0nYQi5mslqIywDRAB4bDVERLJS46p7yYs0WSppnP/Sbcii2A9PXHGzSTjMfK2U
         p2FZabnnuOcgUOxPBuzz/KQuAuIsm+s6yIJ4l9aOmOrTpD+a6QW19vL4jhfhlH2WRfH3
         0De6fqi/y2e3cYxPGNaXQccKtAzzOLyFV+up+9OfPKax/o87oGwu1CeEeR2LvFGSdnJL
         LoaLNmit3ZuFRRTVOpgDwteFjp/ySMKpAnO+T9FpSyTdEeOteKKqE0ANl+fVCWhdt9fu
         8uxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x6uiy0Fi4DBzMHCmE4tRzDc8+wcLbvPYqf7wbXv9smM=;
        b=1M2sW8G+o9EFI+Uf+thmqOg+qhddKym8Ws+/hw7UbNQNKpfd4quPx0GfPoVYSR8dgg
         gWEX0JIUroUTtG7py0t0R9ikBDmXyXXMeJjJyHluN/APe/qGUFQdRhYWImXiMm7Q2NVa
         u8vnsUaG9hmk6YWJ15+HYIVfwaWr20OBVqa1ZcFBIa+XRkjky7aRnmefiZyKtYYcw9b3
         7rKVl1Adqy5tE8JmjpWEV9eMm7K3W3sM+8ZRndB6DTruR00vXQxIG+smz+CJVP5o2Lsn
         BpIaiCHkNF48Pqi/YBcR7V4E233wF18Z9+9VMbIJGwKO3j131ShJBXsXSdUknV9ykaLx
         61bg==
X-Gm-Message-State: AOAM531a4dsXqtsDKyS0pjN6HPNYdrCdP2IEzcKivtpBtoOQKv8egQHy
        y7xD6zpa7MVPQncT92cQ9NgcTXX9N6A=
X-Google-Smtp-Source: ABdhPJy5xRgFwPn8ApSm7zjRY5YGoRzE8eiljTE4ZVZwyKRco7BqDbVpZpuf60HNT3zSR44sYRAUGQ==
X-Received: by 2002:a17:902:aa0a:b0:13e:1658:2a68 with SMTP id be10-20020a170902aa0a00b0013e16582a68mr12139745plb.24.1633137507906;
        Fri, 01 Oct 2021 18:18:27 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id k35sm1159288pjc.53.2021.10.01.18.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 18:18:27 -0700 (PDT)
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
Subject: [PATCH bpf-next v7 9/9] bpf: selftests: Add selftests for module kfunc support
Date:   Sat,  2 Oct 2021 06:47:57 +0530
Message-Id: <20211002011757.311265-10-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211002011757.311265-1-memxor@gmail.com>
References: <20211002011757.311265-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11306; h=from:subject; bh=ZUDX3rLoh1AVY1xe05tHRwOp0U8dtr+0b7TOe/01Luk=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhV7MR+DmmPHPOq25vb3gk4VPHV3HhvGvnKUO2s+xZ uCLRQamJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVezEQAKCRBM4MiGSL8RypJZD/ 9T5+7L81j1qOzufsxs4kE4ORODY9KH7ok2CN8ZkzVVEF9p6bZvznEwYT41EpXg/9xUo4utHlvAM3j9 s8I9VTYhX6vvFxZG9AsgDXO+bY8KU/iquQ9UXq7FlVE5npSwJqphO29eKX0eYoZwPTkib9Wh5cYQa/ 2vnBHF/JHmDR1YV6QTFo17E+equhYkg7elD0iyN/dcNFs7znkNbUXxiwFAo1GRmPNJHqWA2z9YGVpv qsvWyPiVA9Mbdy8gjFIVi8mjWcdsjcUmVGRd8AiZ/2ZXkSVM0X3XpfeOZ2ijSRmoVjX6uANnbiN0LR L9j8UIiydo/SQ5LSVqvOa1Lq1VrsksRTI4rre6oFE9jMbRr1xmONTnaaOePlzOYcLlsmBxEY5kMIKk aLcF4aUTN97SxKNA9i05WKew1Tc0onXCALZMROTwcWxBRJEutn7yubHmoeiuZGy2uBRs33pNRovI10 5yGRcF9oDDLnkqzmPnQ9I861eJBH3OO++7IyUzod/dgSgH+9m5RYf/B58nJW5gYnDFXkVDiTEAs7TJ RZ6Wu7dChKqsmDF32g+Ikhs7DoLzP/jDU3pL1ltDc61JEMkZAwpJDUK6FMw1dVTvNP4ca87iSjOrrL 2YmkQjd97dY3ItZHzFVrL++WeOQsQG4FRj8CG+agJUIrV+iPesNEubkbMqeQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds selftests that tests the success and failure path for modules
kfuncs (in presence of invalid kfunc calls) for both libbpf and
gen_loader. It also adds a prog_test kfunc_btf_id_list so that we can
add module BTF ID set from bpf_testmod.

This also introduces  a couple of test cases to verifier selftests for
validating whether we get an error or not depending on if invalid kfunc
call remains after elimination of unreachable instructions.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf.h                           |  1 +
 kernel/bpf/btf.c                              |  1 +
 net/bpf/test_run.c                            |  5 +-
 tools/testing/selftests/bpf/Makefile          |  7 +--
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 23 +++++++++-
 .../selftests/bpf/prog_tests/ksyms_module.c   | 29 ++++++------
 .../bpf/prog_tests/ksyms_module_libbpf.c      | 28 +++++++++++
 .../selftests/bpf/progs/test_ksyms_module.c   | 46 ++++++++++++++-----
 tools/testing/selftests/bpf/verifier/calls.c  | 23 ++++++++++
 9 files changed, 132 insertions(+), 31 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 1d56cd2bb362..203eef993d76 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -275,5 +275,6 @@ static inline bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist,
 					 THIS_MODULE }
 
 extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
+extern struct kfunc_btf_id_list prog_test_kfunc_list;
 
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 1460dff3c154..2ebffb9f57eb 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6397,3 +6397,4 @@ bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
 	EXPORT_SYMBOL_GPL(name)
 
 DEFINE_KFUNC_BTF_ID_LIST(bpf_tcp_ca_kfunc_list);
+DEFINE_KFUNC_BTF_ID_LIST(prog_test_kfunc_list);
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index b5dfe6cac274..39c1b5e97a29 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2017 Facebook
  */
 #include <linux/bpf.h>
+#include <linux/btf.h>
 #include <linux/btf_ids.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
@@ -243,7 +244,9 @@ BTF_SET_END(test_sk_kfunc_ids)
 
 bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner)
 {
-	return btf_id_set_contains(&test_sk_kfunc_ids, kfunc_id);
+	if (btf_id_set_contains(&test_sk_kfunc_ids, kfunc_id))
+		return true;
+	return bpf_check_mod_kfunc_call(&prog_test_kfunc_list, kfunc_id, owner);
 }
 
 static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index e1ce73be7a5b..770d364be332 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -315,8 +315,9 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
 		linked_vars.skel.h linked_maps.skel.h
 
 LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
-	test_ksyms_module.c test_ringbuf.c atomics.c trace_printk.c \
-	trace_vprintk.c
+	test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c
+# Generate both light skeleton and libbpf skeleton for these
+LSKELS_EXTRA := test_ksyms_module.c
 SKEL_BLACKLIST += $$(LSKELS)
 
 test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
@@ -346,7 +347,7 @@ TRUNNER_BPF_OBJS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.o, $$(TRUNNER_BPF_SRCS)
 TRUNNER_BPF_SKELS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.skel.h,	\
 				 $$(filter-out $(SKEL_BLACKLIST) $(LINKED_BPF_SRCS),\
 					       $$(TRUNNER_BPF_SRCS)))
-TRUNNER_BPF_LSKELS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.lskel.h, $$(LSKELS))
+TRUNNER_BPF_LSKELS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.lskel.h, $$(LSKELS) $$(LSKELS_EXTRA))
 TRUNNER_BPF_SKELS_LINKED := $$(addprefix $$(TRUNNER_OUTPUT)/,$(LINKED_SKELS))
 TEST_GEN_FILES += $$(TRUNNER_BPF_OBJS)
 
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index 50fc5561110a..b892948dc134 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
 #include <linux/error-injection.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -13,6 +15,12 @@
 
 DEFINE_PER_CPU(int, bpf_testmod_ksym_percpu) = 123;
 
+noinline void
+bpf_testmod_test_mod_kfunc(int i)
+{
+	*(int *)this_cpu_ptr(&bpf_testmod_ksym_percpu) = i;
+}
+
 noinline int bpf_testmod_loop_test(int n)
 {
 	int i, sum = 0;
@@ -71,13 +79,26 @@ static struct bin_attribute bin_attr_bpf_testmod_file __ro_after_init = {
 	.write = bpf_testmod_test_write,
 };
 
+BTF_SET_START(bpf_testmod_kfunc_ids)
+BTF_ID(func, bpf_testmod_test_mod_kfunc)
+BTF_SET_END(bpf_testmod_kfunc_ids)
+
+static DEFINE_KFUNC_BTF_ID_SET(&bpf_testmod_kfunc_ids, bpf_testmod_kfunc_btf_set);
+
 static int bpf_testmod_init(void)
 {
-	return sysfs_create_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
+	int ret;
+
+	ret = sysfs_create_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
+	if (ret)
+		return ret;
+	register_kfunc_btf_id_set(&prog_test_kfunc_list, &bpf_testmod_kfunc_btf_set);
+	return 0;
 }
 
 static void bpf_testmod_exit(void)
 {
+	unregister_kfunc_btf_id_set(&prog_test_kfunc_list, &bpf_testmod_kfunc_btf_set);
 	return sysfs_remove_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
 }
 
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
index 2cd5cded543f..831447878d7b 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
@@ -2,30 +2,29 @@
 /* Copyright (c) 2021 Facebook */
 
 #include <test_progs.h>
-#include <bpf/libbpf.h>
-#include <bpf/btf.h>
+#include <network_helpers.h>
 #include "test_ksyms_module.lskel.h"
 
-static int duration;
-
 void test_ksyms_module(void)
 {
-	struct test_ksyms_module* skel;
+	struct test_ksyms_module *skel;
+	int retval;
 	int err;
 
-	skel = test_ksyms_module__open_and_load();
-	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+	if (!env.has_testmod) {
+		test__skip();
 		return;
+	}
 
-	err = test_ksyms_module__attach(skel);
-	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+	skel = test_ksyms_module__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_ksyms_module__open_and_load"))
+		return;
+	err = bpf_prog_test_run(skel->progs.load.prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
+				NULL, NULL, (__u32 *)&retval, NULL);
+	if (!ASSERT_OK(err, "bpf_prog_test_run"))
 		goto cleanup;
-
-	usleep(1);
-
-	ASSERT_EQ(skel->bss->triggered, true, "triggered");
-	ASSERT_EQ(skel->bss->out_mod_ksym_global, 123, "global_ksym_val");
-
+	ASSERT_EQ(retval, 0, "retval");
+	ASSERT_EQ(skel->bss->out_bpf_testmod_ksym, 42, "bpf_testmod_ksym");
 cleanup:
 	test_ksyms_module__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
new file mode 100644
index 000000000000..e6343ef63af9
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include <network_helpers.h>
+#include "test_ksyms_module.skel.h"
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
+cleanup:
+	test_ksyms_module__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_module.c b/tools/testing/selftests/bpf/progs/test_ksyms_module.c
index d6a0b3086b90..0650d918c096 100644
--- a/tools/testing/selftests/bpf/progs/test_ksyms_module.c
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_module.c
@@ -2,24 +2,48 @@
 /* Copyright (c) 2021 Facebook */
 
 #include "vmlinux.h"
-
 #include <bpf/bpf_helpers.h>
 
+#define X_0(x)
+#define X_1(x) x X_0(x)
+#define X_2(x) x X_1(x)
+#define X_3(x) x X_2(x)
+#define X_4(x) x X_3(x)
+#define X_5(x) x X_4(x)
+#define X_6(x) x X_5(x)
+#define X_7(x) x X_6(x)
+#define X_8(x) x X_7(x)
+#define X_9(x) x X_8(x)
+#define X_10(x) x X_9(x)
+#define REPEAT_256(Y) X_2(X_10(X_10(Y))) X_5(X_10(Y)) X_6(Y)
+
 extern const int bpf_testmod_ksym_percpu __ksym;
+extern void bpf_testmod_test_mod_kfunc(int i) __ksym;
+extern void bpf_testmod_invalid_mod_kfunc(void) __ksym __weak;
 
-int out_mod_ksym_global = 0;
-bool triggered = false;
+int out_bpf_testmod_ksym = 0;
+const volatile int x = 0;
 
-SEC("raw_tp/sys_enter")
-int handler(const void *ctx)
+SEC("tc")
+int load(struct __sk_buff *skb)
 {
-	int *val;
-	__u32 cpu;
-
-	val = (int *)bpf_this_cpu_ptr(&bpf_testmod_ksym_percpu);
-	out_mod_ksym_global = *val;
-	triggered = true;
+	/* This will be kept by clang, but removed by verifier. Since it is
+	 * marked as __weak, libbpf and gen_loader don't error out if BTF ID
+	 * is not found for it, instead imm and off is set to 0 for it.
+	 */
+	if (x)
+		bpf_testmod_invalid_mod_kfunc();
+	bpf_testmod_test_mod_kfunc(42);
+	out_bpf_testmod_ksym = *(int *)bpf_this_cpu_ptr(&bpf_testmod_ksym_percpu);
+	return 0;
+}
 
+SEC("tc")
+int load_256(struct __sk_buff *skb)
+{
+	/* this will fail if kfunc doesn't reuse its own btf fd index */
+	REPEAT_256(bpf_testmod_test_mod_kfunc(42););
+	bpf_testmod_test_mod_kfunc(42);
 	return 0;
 }
 
diff --git a/tools/testing/selftests/bpf/verifier/calls.c b/tools/testing/selftests/bpf/verifier/calls.c
index 336a749673d1..d7b74eb28333 100644
--- a/tools/testing/selftests/bpf/verifier/calls.c
+++ b/tools/testing/selftests/bpf/verifier/calls.c
@@ -1,3 +1,26 @@
+{
+	"calls: invalid kfunc call not eliminated",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.result  = REJECT,
+	.errstr = "invalid kernel function call not eliminated in verifier pass",
+},
+{
+	"calls: invalid kfunc call unreachable",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_JMP_IMM(BPF_JGT, BPF_REG_0, 0, 2),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+	.result  = ACCEPT,
+},
 {
 	"calls: basic sanity",
 	.insns = {
-- 
2.33.0

