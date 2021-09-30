Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF6D41D36E
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 08:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348373AbhI3GcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 02:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348364AbhI3GcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 02:32:01 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62045C06176D;
        Wed, 29 Sep 2021 23:30:19 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k23-20020a17090a591700b001976d2db364so4003176pji.2;
        Wed, 29 Sep 2021 23:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mluCNZL9ssNvtV+CwRXSKnTklLxnlq6sGQs6X3WK1a4=;
        b=WGklZ+FlG8bVnO2+eleZbXPg4Zk4DNL2cWEcbamQTHEeX5YbiX5pz6E/bi71EfBe8K
         7gU/Zaj8pjiv3shpwyhT/gXfnZ01knwurz1jM5BrO22SE2xAodWKVPLH54fApBEg59P4
         J13h6VXjhOie2CUSRYWLvQv149OLX0uC64f/m/Ck2qXJrN79Dy89DTV9IaZ3mX++Gci8
         f5/5MEHDT8ig3dCqmPKyzH5lbneBIqHSqp7mB1+cy0LIQLk9Q/zLVIWXAhoFAadgbvqV
         P6qiD0C+X+YaBxvGmWpuwtwFANue6m3CRJd5tK7w2yPJCTsFlmE01mjfsd0NlHBDdtPU
         ngOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mluCNZL9ssNvtV+CwRXSKnTklLxnlq6sGQs6X3WK1a4=;
        b=kd4kVNfEkqRhCKUsVXu8TGqCt3S1zoSRlkhQZxP5aBE5WVUylaf8FRjc3X6KAXdA5G
         /x7Ojor1QSmslVjIaIejzDulUZlOBFgfqiERAOeoyr/47dl5JjWPS7EQMqZvix3KNm+y
         GRo8I/gbopa0MqpDqInGz8aUiGEkXYkeGknuOe5s58/AHkRBg5Vr7+8+q+R1d48dek5F
         wBUaO4dGMZkXwf/Vqe/u1EWIV0LhXRf+6aHKswoCoeJvuzDrSQ6rX/EenRJnQ7cU7H0g
         FVESSYA8MWg+qUKuRtny0SVt5L8RV9bClARlwgXSldltTOafh7UKUh8MdJ3BFl3ApuRs
         RHzA==
X-Gm-Message-State: AOAM5307uDuOtJ0MwupDGlE4go9zRbgZT66NQg1ElqspASazzdXQqT3b
        1fK/KZkFcwyv4WUWrRA/IvaRUkEW2UM=
X-Google-Smtp-Source: ABdhPJxbF7SrLrAYQRgR+rOnckP6bBZQHiIm1rwxjyV5Cq371fT5mRJXo98jsgx+UASBPhVDvBi3wQ==
X-Received: by 2002:a17:902:7b84:b0:13b:90a7:e270 with SMTP id w4-20020a1709027b8400b0013b90a7e270mr2724899pll.21.1632983417239;
        Wed, 29 Sep 2021 23:30:17 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id j6sm1541875pgh.17.2021.09.29.23.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 23:30:17 -0700 (PDT)
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
Subject: [PATCH bpf-next v6 9/9] bpf: selftests: Add selftests for module kfunc support
Date:   Thu, 30 Sep 2021 11:59:48 +0530
Message-Id: <20210930062948.1843919-10-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210930062948.1843919-1-memxor@gmail.com>
References: <20210930062948.1843919-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11830; h=from:subject; bh=UZqjqYaFzZ2tVZCWioY9RRVun0cAE8aMB7weHUdAfs4=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhVVlCVT1dOm5MdkowqjV9lxKHuAqPHqFLPC7R5NRs 0n/9H/2JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVVZQgAKCRBM4MiGSL8RynwiD/ 41sF/XbTZewSXX7fT/LJ39i2nIkxaP4QNzM91333ryz+qNztc4DYYj7xR6x36rfm7QKtfexIAzOBP8 XGEmL8a0Hj5a471HyMWURHBWVTyboSH2PoF0/0loMeqVtYV6wrrzAoq2NaJEOQwTrHCHfegWpnwrK8 VmzAodKTU+jI7TNd1uB4xRisrvz/SYeqlybqg7pxjMd9JscA8cvpdHaVPOw5sEQUN5IwqD3d7XXalF U2ViWFDl0S/Or1ejhOoKZiNahn6aVYbmohiTtG816OVDsnV47ZDK84ajwRmh8rUKm3FDJ/GRgf2Idz zfqVeg1VGExN2xtT+IYW+w8jZDTLV6p+CaBTGkRTano0BcTqEoPFhg/cqAeNbx3DTa0YjqDT7fnAH7 AKOic0Qj7Rmj3CnlmNeIsJvdfyF5bOwOWxaJ1uQ4dPAIM+vE+n8pYxeUHeEw5L6hxJ/J38JX6jN/uo 1WBOXavIGcwYolAJCAgjc+nSmhvC3uTvukNJSOqSu5mmVYwsJGSem7A5m4z1AGhugZnl7mqnBF4l9c kGMXkURVfAifxYQjCN4SWluul33oc3ghXR9mct0oLEiG2uaGWficyYu3G3GiTmS2iMN1iJ8xWlZCm/ oSvdewQ7osNgNPSj1Geqi/EcWJTz3fjI+y3B1OuuhXQ15vD3GT+gW4h3jrrw==
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
 include/linux/btf.h                           |  2 +
 kernel/bpf/btf.c                              |  2 +
 net/bpf/test_run.c                            |  5 +-
 tools/testing/selftests/bpf/Makefile          |  8 ++--
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 23 +++++++++-
 .../selftests/bpf/prog_tests/ksyms_module.c   | 29 ++++++------
 .../bpf/prog_tests/ksyms_module_libbpf.c      | 28 +++++++++++
 .../selftests/bpf/progs/test_ksyms_module.c   | 46 ++++++++++++++-----
 tools/testing/selftests/bpf/verifier/calls.c  | 23 ++++++++++
 9 files changed, 135 insertions(+), 31 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 8dc65ff02bd6..4075cc24b88a 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -270,7 +270,9 @@ static inline void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 					 THIS_MODULE }
 
 extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
+extern struct kfunc_btf_id_list prog_test_kfunc_list;
 
 DECLARE_CHECK_KFUNC_CALLBACK(tcp_ca);
+DECLARE_CHECK_KFUNC_CALLBACK(prog_test);
 
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 423744378fc8..2d84b739ec22 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6397,3 +6397,5 @@ EXPORT_SYMBOL_GPL(unregister_kfunc_btf_id_set);
 
 DEFINE_KFUNC_BTF_ID_LIST(bpf_tcp_ca_kfunc_list);
 DEFINE_CHECK_KFUNC_CALLBACK(tcp_ca, bpf_tcp_ca_kfunc_list);
+DEFINE_KFUNC_BTF_ID_LIST(prog_test_kfunc_list);
+DEFINE_CHECK_KFUNC_CALLBACK(prog_test, prog_test_kfunc_list);
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index b5dfe6cac274..26cdba88adec 100644
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
+	return __bpf_prog_test_check_kfunc_call(kfunc_id, owner);
 }
 
 static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index e1ce73be7a5b..df461699932d 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -174,6 +174,7 @@ $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_tes
 	$(Q)$(RM) bpf_testmod/bpf_testmod.ko # force re-compilation
 	$(Q)$(MAKE) $(submake_extras) -C bpf_testmod
 	$(Q)cp bpf_testmod/bpf_testmod.ko $@
+	$(Q)$(RESOLVE_BTFIDS) -b $(VMLINUX_BTF) bpf_testmod.ko
 
 $(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
 	$(call msg,CC,,$@)
@@ -315,8 +316,9 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
 		linked_vars.skel.h linked_maps.skel.h
 
 LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
-	test_ksyms_module.c test_ringbuf.c atomics.c trace_printk.c \
-	trace_vprintk.c
+	test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c
+# Generate both light skeleton and libbpf skeleton for these
+LSKELS_EXTRA := test_ksyms_module.c
 SKEL_BLACKLIST += $$(LSKELS)
 
 test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
@@ -346,7 +348,7 @@ TRUNNER_BPF_OBJS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.o, $$(TRUNNER_BPF_SRCS)
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

