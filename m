Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74C240BF36
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 07:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236311AbhIOFLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 01:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236362AbhIOFLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 01:11:38 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9E8C0613C1;
        Tue, 14 Sep 2021 22:10:19 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so3455033pjb.1;
        Tue, 14 Sep 2021 22:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oAIgKggekxG0Lf87kB6sX8dp5MLXUQYGPXIr+5dWXEs=;
        b=ZQbA1C7vhfAyWaBnRWrP0qG+M1HGZbD7R6JCBSnBdQix/Vb8XTjqdEOBYRUCPzt5QI
         Fxtlzx/pjoQ+tcrVgSYPUH9UDi6A0F0R5k+0exe7yLdv5Qv0e/+BMwGNtI46T3FS9i68
         xbFmZH47SGxCSOtJkA7KPVWEeEArd4GxjXa4Pvnwu3R73CIyVTsxAwVy6tbfEY7wv8Ws
         b5LxMNX9zF6WVlAydhw+jHdTm7fGIVHFcTyvsrdpURNwAAMTlySSaxXN22leOvKZ7UGs
         n+mZSrBATQl2TbK8K4WsjLMMU0ziIGEqtAmSH7WnpMabfSzj3E/PUyurWMdUATtfaZcO
         gc4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oAIgKggekxG0Lf87kB6sX8dp5MLXUQYGPXIr+5dWXEs=;
        b=GUfJMkQ2f7q43fepMv46XxISeSYMXQf0pImSD5pSm//HwmhkkMX9l8AEZFC1hPgrLH
         vc4IO1+hxsLe2nlaLNPBa6588EeGZfJ1MN6fc7N744ICRwlpS995sk/96E30heNjt8XO
         tYzqm5bpwGjzO0BetRI1AdzjnpBK/MFgrGr+63RleNUpqNxVg5YEAmvAzJ+HPkJQc/8G
         Vm/n/a3ViZYdSRihHoaIvC5LTIgNAEndyVL9OH52rfVqNnHSbNL2F74pd0S0E4bKqZcT
         mBm15f/u/s3NuJZRqraytXF1wTU6KcIPpRb7Ktw6iaxouF3VfqqO2aP14hB88Y9nKSgI
         xBFQ==
X-Gm-Message-State: AOAM532TX9DEk6rl1UqI8Kp5EhRrauCS2Z2J+Vp4pjD36gz75kPEPkwS
        0Fr8+apZzRVFnV4AdUnUY0WBTRlJrMALvA==
X-Google-Smtp-Source: ABdhPJyG1A8i7LjRPB7ivcJuxUdZeRTlhW4nWM9uvOKSfqujtpkuH8QTNRKgUoIYCRF3WhLZy5Y/bg==
X-Received: by 2002:a17:90b:1e43:: with SMTP id pi3mr6304642pjb.135.1631682618261;
        Tue, 14 Sep 2021 22:10:18 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id z131sm12098110pfc.159.2021.09.14.22.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 22:10:18 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 10/10] bpf, selftests: Add basic test for module kfunc call
Date:   Wed, 15 Sep 2021 10:39:43 +0530
Message-Id: <20210915050943.679062-11-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915050943.679062-1-memxor@gmail.com>
References: <20210915050943.679062-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=14147; h=from:subject; bh=KBrW1KN4Ln3Dk6mctpImEY4rwY29bfCPGop5hZzFfmg=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQX4cnfIeYOBL7hbLuQdhyJN5wQJDYbx1cuij8tcN Vx9ue5eJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUF+HAAKCRBM4MiGSL8RyrFMD/ 9T1pYhJWY0OdjiUrgLYkViltB6t5YXSeFbF19kBffXYA7Z4/6KqqvxYTSwQO7TZ20KsARDJN//TBUo uhH/nFS+egJLIbP//yzpw6+ZMAfL7E92ePqweC2DPyNxFMu04ZVJ21p6/MMzN4h8zbMLqA8JQpndPS KhzAY4VYTOLOkx0OdSrDCu8oiqo/9HFbj4wqrfh+PPnGOy+6gyT5Q6cT7woFRZgC60occ1vMWYwmt8 U16ATVQbjHx8iGEP3MYnCMLvtZPxt9MwtyQQQThwrYQ9SBy5jy8sTH2uKydWnr/vpHDPDSQBN8iav/ 2CHCuPRNT4muv7OhHD5JEGdBKnfNGuzUQNR98pnrNZEyl8NO7yOpbNu6j0qHZcugdsYQnxCoiy0wcz GALe97DVXlEuNYfhBefLP0KNdXGIqePBg0hn8/eFYzXzyl6iqy22I+kAyr5YZcW7UnCDQKlYNEz/Sj 7raUHpuy0DTNESuvzWha9tPPpayQ6fCidn/vBhh4U8ZhB6T44g0xSWOHHtByat1UUqQC6q1kszXVwb qO+v1DBS6p6Q06Qv1hkX8H1uQfE+GZPIGkRu88a2VWb663TDcgGc03sSXv/zu6PZGK0AgLUHZXXtCk El5/yd1nzlMNjj/b9pKx0o2eSXh9rAWcp6k96poyyETUBgnTtinnYz0mcOyA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This also tests support for invalid kfunc calls we added in prior
changes, such that verifier handles invalid call as long as it is
removed by code elimination pass (before fixup_kfunc_call). A separate
test for libbpf is added, which tests failure in loading.

Also adjust verifier selftests which assume 512 byte stack to now assume
768 byte stack.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf.h                           |  2 ++
 kernel/bpf/btf.c                              |  2 ++
 kernel/trace/bpf_trace.c                      |  1 +
 tools/testing/selftests/bpf/Makefile          |  1 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 23 +++++++++++-
 .../selftests/bpf/prog_tests/ksyms_module.c   | 13 ++++---
 .../bpf/prog_tests/ksyms_module_libbpf.c      | 18 ++++++++++
 .../selftests/bpf/progs/test_ksyms_module.c   |  9 +++++
 .../bpf/progs/test_ksyms_module_libbpf.c      | 35 +++++++++++++++++++
 tools/testing/selftests/bpf/verifier/calls.c  | 22 ++++++------
 .../selftests/bpf/verifier/raw_stack.c        |  4 +--
 .../selftests/bpf/verifier/stack_ptr.c        |  6 ++--
 .../testing/selftests/bpf/verifier/var_off.c  |  4 +--
 13 files changed, 116 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_libbpf.c

diff --git a/include/linux/btf.h b/include/linux/btf.h
index c7b6382123e1..585c66aa0529 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -271,7 +271,9 @@ static inline void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 					 THIS_MODULE }
 
 extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
+extern struct kfunc_btf_id_list raw_tp_kfunc_list;
 
 DECLARE_CHECK_KFUNC_CALLBACK(bpf_tcp_ca);
+DECLARE_CHECK_KFUNC_CALLBACK(raw_tp);
 
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 671b4f713a51..c6632894ed05 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6397,3 +6397,5 @@ EXPORT_SYMBOL_GPL(unregister_kfunc_btf_id_set);
 
 DEFINE_KFUNC_BTF_ID_LIST(bpf_tcp_ca_kfunc_list);
 DEFINE_CHECK_KFUNC_CALLBACK(bpf_tcp_ca, bpf_tcp_ca_kfunc_list);
+DEFINE_KFUNC_BTF_ID_LIST(raw_tp_kfunc_list);
+DEFINE_CHECK_KFUNC_CALLBACK(raw_tp, raw_tp_kfunc_list);
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 067e88c3d2ee..54cba3391f35 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1629,6 +1629,7 @@ int __weak bpf_prog_test_run_tracing(struct bpf_prog *prog,
 const struct bpf_verifier_ops raw_tracepoint_verifier_ops = {
 	.get_func_proto  = raw_tp_prog_func_proto,
 	.is_valid_access = raw_tp_prog_is_valid_access,
+	.check_kfunc_call = __bpf_check_raw_tp_kfunc_call,
 };
 
 const struct bpf_prog_ops raw_tracepoint_prog_ops = {
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 1a4d30ff3275..064eef69e96a 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -174,6 +174,7 @@ $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_tes
 	$(Q)$(RM) bpf_testmod/bpf_testmod.ko # force re-compilation
 	$(Q)$(MAKE) $(submake_extras) -C bpf_testmod
 	$(Q)cp bpf_testmod/bpf_testmod.ko $@
+	$(Q)$(RESOLVE_BTFIDS) -s ../../../../vmlinux bpf_testmod.ko
 
 $(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
 	$(call msg,CC,,$@)
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index 50fc5561110a..5b365a7b3f93 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
 #include <linux/error-injection.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/percpu-defs.h>
@@ -13,6 +15,12 @@
 
 DEFINE_PER_CPU(int, bpf_testmod_ksym_percpu) = 123;
 
+noinline void
+bpf_testmod_test_mod_kfunc(int i)
+{
+	pr_info("mod kfunc i=%d\n", i);
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
+	register_kfunc_btf_id_set(&raw_tp_kfunc_list, &bpf_testmod_kfunc_btf_set);
+	return 0;
 }
 
 static void bpf_testmod_exit(void)
 {
+	unregister_kfunc_btf_id_set(&raw_tp_kfunc_list, &bpf_testmod_kfunc_btf_set);
 	return sysfs_remove_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
 }
 
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
index 2cd5cded543f..7643141ec67b 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
@@ -6,19 +6,22 @@
 #include <bpf/btf.h>
 #include "test_ksyms_module.lskel.h"
 
-static int duration;
-
 void test_ksyms_module(void)
 {
-	struct test_ksyms_module* skel;
+	struct test_ksyms_module *skel;
 	int err;
 
+	if (!env.has_testmod) {
+		test__skip();
+		return;
+	}
+
 	skel = test_ksyms_module__open_and_load();
-	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+	if (!ASSERT_OK_PTR(skel, "test_ksyms_module__open_and_load"))
 		return;
 
 	err = test_ksyms_module__attach(skel);
-	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+	if (!ASSERT_OK(err, "test_ksyms_module__attach"))
 		goto cleanup;
 
 	usleep(1);
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
new file mode 100644
index 000000000000..61fa2a0e156e
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include "test_ksyms_module_libbpf.skel.h"
+
+void test_ksyms_module_libbpf(void)
+{
+	struct test_ksyms_module_libbpf *skel;
+
+	if (!env.has_testmod) {
+		test__skip();
+		return;
+	}
+
+	skel = test_ksyms_module_libbpf__open_and_load();
+	if (!ASSERT_EQ(skel, NULL, "test_ksyms_module__open_and_load"))
+		test_ksyms_module_libbpf__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_module.c b/tools/testing/selftests/bpf/progs/test_ksyms_module.c
index d6a0b3086b90..d3fff47791fc 100644
--- a/tools/testing/selftests/bpf/progs/test_ksyms_module.c
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_module.c
@@ -6,8 +6,11 @@
 #include <bpf/bpf_helpers.h>
 
 extern const int bpf_testmod_ksym_percpu __ksym;
+extern void bpf_testmod_test_mod_kfunc(int i) __ksym;
+extern void bpf_testmod_invalid_mod_kfunc(void) __ksym __weak;
 
 int out_mod_ksym_global = 0;
+const volatile int x = 0;
 bool triggered = false;
 
 SEC("raw_tp/sys_enter")
@@ -16,6 +19,12 @@ int handler(const void *ctx)
 	int *val;
 	__u32 cpu;
 
+	/* This should be preserved by clang, but DCE'd by verifier, and still
+	 * allow loading the raw_tp prog
+	 */
+	if (x)
+		bpf_testmod_invalid_mod_kfunc();
+	bpf_testmod_test_mod_kfunc(42);
 	val = (int *)bpf_this_cpu_ptr(&bpf_testmod_ksym_percpu);
 	out_mod_ksym_global = *val;
 	triggered = true;
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_module_libbpf.c b/tools/testing/selftests/bpf/progs/test_ksyms_module_libbpf.c
new file mode 100644
index 000000000000..52162858d25d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_module_libbpf.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+
+extern void bpf_testmod_test_mod_kfunc(int i) __ksym;
+extern void bpf_testmod_invalid_mod_kfunc(void) __ksym __weak;
+
+const volatile int x = 0;
+
+SEC("raw_tp/sys_enter")
+int handler_pass(const void *ctx)
+{
+	/* This should be preserved by clang, but DCE'd by verifier, and still
+	 * allow loading the raw_tp prog
+	 */
+	if (x)
+		bpf_testmod_invalid_mod_kfunc();
+	bpf_testmod_test_mod_kfunc(42);
+	return 0;
+}
+
+SEC("raw_tp/sys_enter")
+int handler_fail(const void *ctx)
+{
+	/* This call should be preserved by clang, but fail verification.
+	 */
+	if (!x)
+		bpf_testmod_invalid_mod_kfunc();
+	bpf_testmod_test_mod_kfunc(42);
+	return 0;
+}
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/verifier/calls.c b/tools/testing/selftests/bpf/verifier/calls.c
index 336a749673d1..03467053996c 100644
--- a/tools/testing/selftests/bpf/verifier/calls.c
+++ b/tools/testing/selftests/bpf/verifier/calls.c
@@ -750,12 +750,12 @@
 	"calls: stack overflow using two frames (pre-call access)",
 	.insns = {
 	/* prog 1 */
-	BPF_ST_MEM(BPF_B, BPF_REG_10, -300, 0),
+	BPF_ST_MEM(BPF_B, BPF_REG_10, -400, 0),
 	BPF_RAW_INSN(BPF_JMP|BPF_CALL, 0, 1, 0, 1),
 	BPF_EXIT_INSN(),
 
 	/* prog 2 */
-	BPF_ST_MEM(BPF_B, BPF_REG_10, -300, 0),
+	BPF_ST_MEM(BPF_B, BPF_REG_10, -400, 0),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
@@ -768,11 +768,11 @@
 	.insns = {
 	/* prog 1 */
 	BPF_RAW_INSN(BPF_JMP|BPF_CALL, 0, 1, 0, 2),
-	BPF_ST_MEM(BPF_B, BPF_REG_10, -300, 0),
+	BPF_ST_MEM(BPF_B, BPF_REG_10, -400, 0),
 	BPF_EXIT_INSN(),
 
 	/* prog 2 */
-	BPF_ST_MEM(BPF_B, BPF_REG_10, -300, 0),
+	BPF_ST_MEM(BPF_B, BPF_REG_10, -400, 0),
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
@@ -846,12 +846,12 @@
 	/* B */
 	BPF_JMP_IMM(BPF_JGT, BPF_REG_1, 2, 1),
 	BPF_RAW_INSN(BPF_JMP|BPF_CALL, 0, 1, 0, -6), /* call A */
-	BPF_ST_MEM(BPF_B, BPF_REG_10, -256, 0),
+	BPF_ST_MEM(BPF_B, BPF_REG_10, -512, 0),
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_XDP,
-	/* stack_main=64, stack_A=224, stack_B=256
-	 * and max(main+A, main+A+B) > 512
+	/* stack_main=64, stack_A=224, stack_B=512
+	 * and max(main+A, main+A+B) > 768
 	 */
 	.errstr = "combined stack",
 	.result = REJECT,
@@ -865,14 +865,14 @@
 	 * }
 	 * void func1(int alloc_or_recurse) {
 	 *   if (alloc_or_recurse) {
-	 *     frame_pointer[-300] = 1;
+	 *     frame_pointer[-400] = 1;
 	 *   } else {
 	 *     func2(alloc_or_recurse);
 	 *   }
 	 * }
 	 * void func2(int alloc_or_recurse) {
 	 *   if (alloc_or_recurse) {
-	 *     frame_pointer[-300] = 1;
+	 *     frame_pointer[-400] = 1;
 	 *   }
 	 * }
 	 */
@@ -888,13 +888,13 @@
 	BPF_EXIT_INSN(),
 	/* A */
 	BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 2),
-	BPF_ST_MEM(BPF_B, BPF_REG_10, -300, 0),
+	BPF_ST_MEM(BPF_B, BPF_REG_10, -400, 0),
 	BPF_EXIT_INSN(),
 	BPF_RAW_INSN(BPF_JMP|BPF_CALL, 0, 1, 0, 1), /* call B */
 	BPF_EXIT_INSN(),
 	/* B */
 	BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 1),
-	BPF_ST_MEM(BPF_B, BPF_REG_10, -300, 0),
+	BPF_ST_MEM(BPF_B, BPF_REG_10, -400, 0),
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_XDP,
diff --git a/tools/testing/selftests/bpf/verifier/raw_stack.c b/tools/testing/selftests/bpf/verifier/raw_stack.c
index cc8e8c3cdc03..238dedb3aa47 100644
--- a/tools/testing/selftests/bpf/verifier/raw_stack.c
+++ b/tools/testing/selftests/bpf/verifier/raw_stack.c
@@ -197,7 +197,7 @@
 	.insns = {
 	BPF_MOV64_IMM(BPF_REG_2, 4),
 	BPF_ALU64_REG(BPF_MOV, BPF_REG_6, BPF_REG_10),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, -513),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, -769),
 	BPF_MOV64_REG(BPF_REG_3, BPF_REG_6),
 	BPF_MOV64_IMM(BPF_REG_4, 8),
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_skb_load_bytes),
@@ -205,7 +205,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid indirect access to stack R3 off=-513 size=8",
+	.errstr = "invalid indirect access to stack R3 off=-769 size=8",
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 },
 {
diff --git a/tools/testing/selftests/bpf/verifier/stack_ptr.c b/tools/testing/selftests/bpf/verifier/stack_ptr.c
index 8ab94d65f3d5..566d79299ccd 100644
--- a/tools/testing/selftests/bpf/verifier/stack_ptr.c
+++ b/tools/testing/selftests/bpf/verifier/stack_ptr.c
@@ -165,7 +165,7 @@
 	"PTR_TO_STACK check low 2",
 	.insns = {
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -513),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -769),
 	BPF_ST_MEM(BPF_B, BPF_REG_1, 1, 42),
 	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1, 1),
 	BPF_EXIT_INSN(),
@@ -179,13 +179,13 @@
 	"PTR_TO_STACK check low 3",
 	.insns = {
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -513),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -769),
 	BPF_ST_MEM(BPF_B, BPF_REG_1, 0, 42),
 	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1, 0),
 	BPF_EXIT_INSN(),
 	},
 	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
-	.errstr = "invalid write to stack R1 off=-513 size=1",
+	.errstr = "invalid write to stack R1 off=-769 size=1",
 	.result = REJECT,
 },
 {
diff --git a/tools/testing/selftests/bpf/verifier/var_off.c b/tools/testing/selftests/bpf/verifier/var_off.c
index eab1f7f56e2f..407bdee522a6 100644
--- a/tools/testing/selftests/bpf/verifier/var_off.c
+++ b/tools/testing/selftests/bpf/verifier/var_off.c
@@ -196,8 +196,8 @@
 	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
 	/* Make it small and 4-byte aligned */
 	BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 4),
-	BPF_ALU64_IMM(BPF_SUB, BPF_REG_2, 516),
-	/* add it to fp.  We now have either fp-516 or fp-512, but
+	BPF_ALU64_IMM(BPF_SUB, BPF_REG_2, 772),
+	/* add it to fp.  We now have either fp-772 or fp-768, but
 	 * we don't know which
 	 */
 	BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_10),
-- 
2.33.0

