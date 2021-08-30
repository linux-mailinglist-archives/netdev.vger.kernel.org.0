Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AA93FBB17
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 19:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238311AbhH3RgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 13:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238261AbhH3Rfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 13:35:48 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59A7C0617AD;
        Mon, 30 Aug 2021 10:34:54 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mw10-20020a17090b4d0a00b0017b59213831so10693pjb.0;
        Mon, 30 Aug 2021 10:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uq3gikbj9ewA7OoQZE5RrbQJ4kDybRdWpRwwwDYF+Bc=;
        b=btAijSkwjyJ0gPbL855v79Ydv9rUshd+tb+9yz6/E3eSubHKK67VeXmkGB6Wxxfijc
         4X22oOzDFERfXELni5lmQ9sHcsiL9sMMEHgBXLTQtWljyQAODLmUXuCXENstx7lP7YW5
         kSQLAHlZ57BcABRukgpyTMru+E3yvahSjv+UcvTY00CFPoRrwiLaR5Fb2rL0+RmCAiL0
         rErAkjteQ+H8wxWwDdG9duJFwTLNS8XS4dCQzFW4PH7GeQEMrb2ChN5tDlC6aQh541/Z
         D0VuTaA0gGeKkY7ysC6WlJ5iJ2nzX8Ttv01VMuGVJhvgOM7bv4nLzfK11srFiG3jQ/0g
         rO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uq3gikbj9ewA7OoQZE5RrbQJ4kDybRdWpRwwwDYF+Bc=;
        b=M6CBdyRyNk7zWuPpuXm5C0+2C5+5kOk65gNlwEotnNPGgbPw2fD0ggY1aK5xfp9jfT
         USMfONvkQWXMvg/J8BEspPJ3tZDpjqOdOFZVznbRk+PeSfMY1ZCcMK1/OXta4LCWEb+8
         s7/IoMLCl8uQ7bZOS2uZeyl0QuCymbZCO0ol7gBAG/ARwMj51T3W9V5o12guRD3UzfYN
         otWlOyVIi1sPXVqc6uQmz0w1KwHai7J8DK5USXGoa4EvgubocDC6rreEzGkuPjwz8yIs
         RHRuHF0i7Xvibc/PZxkFQvSRx4321OMTtV1b2ylA3SdI7nJ9VdE2vX9wMxrGThqasLG0
         h+cg==
X-Gm-Message-State: AOAM532vqxHp/lI+ku1zrrdGVtgBsNn3pyiaXiO9yjdsGTN8dK8SvtsX
        zX5O/Wgbz5g958fhb+DiJFXhkoh5mc3LSw==
X-Google-Smtp-Source: ABdhPJzNIeyp1JUinKPigV19IybaOhqPTuSwVcbi/RUyZRXSJliVfPQCjua+qy8xmKIiRR7WrjgAoA==
X-Received: by 2002:a17:90a:5b0d:: with SMTP id o13mr187126pji.117.1630344893974;
        Mon, 30 Aug 2021 10:34:53 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id e6sm15392863pfj.183.2021.08.30.10.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 10:34:53 -0700 (PDT)
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
Subject: [PATCH bpf-next RFC v1 8/8] bpf, selftests: Add basic test for module kfunc call
Date:   Mon, 30 Aug 2021 23:04:24 +0530
Message-Id: <20210830173424.1385796-9-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210830173424.1385796-1-memxor@gmail.com>
References: <20210830173424.1385796-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6892; h=from:subject; bh=pt2B+/aXob7wuPacjobW7v2Tj5tIhSAys1tDGS5ZFl4=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhLRX92HznMYm4y07Gr1+Syu02aaDGgf3KGSfNbyCg 0HwoIbOJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYS0V/QAKCRBM4MiGSL8RytU1EA C3uOwMCtuhQFHSjAVW8nHFzS5/MiWbgOcd0w8ER9oJBaCBBNXrFiVxJJMh2SlHx9BiiXcfuIKfJnFa n+KvE5qNLGG9vxzLKS9Gv8syxfUDOUlQlG61hYdmkSHGCz5g7K1wcIjH4xqhh5r/48ptYoz1buQR8H t95FogpTrZY5sIacanC68oBRukgf1FEwyEVCAdIS2NsY8r5j6V5slch1zfL9dxaEFFDf8fIT5aVLwf anNcUG/9BCkyknaPm9O3vYuBg8PzTx+TDE3mDXoIa4kQB8V4Bm+gIysrIJblOFL3QM3rejTpfW+Ug6 tzzWyGc/ho82ZGG3Tn787t4Avdh6Xk/uI99tD+0nHD7711L/WA9IPC1gE87GhK+f0RXxqO8hjDZoWH ET6jTt9aAMfkgOoZoSmrg4wYF6bfW6HBq3vCTg1Vc+4mehMgFuEgyS3M6xmeEX4OotuQ/A+Yq9tnSV 36IUSIRX5WeZhkqLfpA0pUep5u/TU/pheuDwWOZROz6UWsHBpEE/xfzGIvbVo+JomCcYQjsp1BTTo7 CZHv4ddwJM4g3gQLudHbuC+h4+KkUXfTXarAl6phKZ0mopq9AaDy+zjJA8jaPL8nY3ZIrbkdF/MeSu 4FojsrNHEn3bXlvEkV8a7IBkkwdYQGy8wfATa2ozHHQyxEWiayJgxYDnfvxA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This has to drop light skeleton generation and instead use libbpf
skeleton support, as loader program does not support kfunc module calls,
yet. This also tests support for invalid kfunc calls we added in prior
changes, such that verifier handles invalid call as long as it is
removed by code elimination pass (before fixup_kfunc_call).

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf.h                           |  1 +
 kernel/bpf/btf.c                              |  1 +
 kernel/trace/bpf_trace.c                      |  1 +
 tools/testing/selftests/bpf/Makefile          |  3 ++-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 23 ++++++++++++++++++-
 .../selftests/bpf/prog_tests/ksyms_module.c   | 10 ++++----
 .../selftests/bpf/progs/test_ksyms_module.c   |  9 ++++++++
 7 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 8c0f29ed2af9..6e704981c475 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -254,5 +254,6 @@ struct kfunc_btf_set {
 	struct kfunc_btf_set name = { LIST_HEAD_INIT(name.list), (set) }
 
 DECLARE_KFUNC_BTF_SET_REG(bpf_tcp_ca);
+DECLARE_KFUNC_BTF_SET_REG(raw_tp);
 
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index cc12470a55f9..85a0c2737ea1 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6251,3 +6251,4 @@ BTF_ID_LIST_GLOBAL_SINGLE(btf_task_struct_ids, struct, task_struct)
 	EXPORT_SYMBOL_GPL(unregister_##type##_kfunc_btf_set)
 
 DEFINE_KFUNC_BTF_SET_REG(bpf_tcp_ca);
+DEFINE_KFUNC_BTF_SET_REG(raw_tp);
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 8e2eb950aa82..02fe14b5d005 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1599,6 +1599,7 @@ int __weak bpf_prog_test_run_tracing(struct bpf_prog *prog,
 const struct bpf_verifier_ops raw_tracepoint_verifier_ops = {
 	.get_func_proto  = raw_tp_prog_func_proto,
 	.is_valid_access = raw_tp_prog_is_valid_access,
+	.check_kfunc_call = __bpf_check_raw_tp_kfunc_call,
 };
 
 const struct bpf_prog_ops raw_tracepoint_prog_ops = {
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 866531c08e4f..1a4aa71e88f4 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -174,6 +174,7 @@ $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_tes
 	$(Q)$(RM) bpf_testmod/bpf_testmod.ko # force re-compilation
 	$(Q)$(MAKE) $(submake_extras) -C bpf_testmod
 	$(Q)cp bpf_testmod/bpf_testmod.ko $@
+	$(Q)$(RESOLVE_BTFIDS) -s ../../../../vmlinux bpf_testmod.ko
 
 $(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
 	$(call msg,CC,,$@)
@@ -315,7 +316,7 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
 		linked_vars.skel.h linked_maps.skel.h
 
 LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
-	test_ksyms_module.c test_ringbuf.c atomics.c trace_printk.c
+	  test_ringbuf.c atomics.c trace_printk.c
 SKEL_BLACKLIST += $$(LSKELS)
 
 test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index 141d8da687d2..8242f2bb50b4 100644
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
 noinline ssize_t
 bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 		      struct bin_attribute *bin_attr,
@@ -55,13 +63,26 @@ static struct bin_attribute bin_attr_bpf_testmod_file __ro_after_init = {
 	.write = bpf_testmod_test_write,
 };
 
+BTF_SET_START(bpf_testmod_kfunc_ids)
+BTF_ID(func, bpf_testmod_test_mod_kfunc)
+BTF_SET_END(bpf_testmod_kfunc_ids)
+
+static DEFINE_KFUNC_BTF_SET(&bpf_testmod_kfunc_ids, bpf_testmod_kfunc_btf_set);
+
 static int bpf_testmod_init(void)
 {
-	return sysfs_create_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
+	int ret;
+
+	ret = sysfs_create_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
+	if (ret)
+		return ret;
+	register_raw_tp_kfunc_btf_set(&bpf_testmod_kfunc_btf_set);
+	return 0;
 }
 
 static void bpf_testmod_exit(void)
 {
+	unregister_raw_tp_kfunc_btf_set(&bpf_testmod_kfunc_btf_set);
 	return sysfs_remove_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
 }
 
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
index 2cd5cded543f..d3b0adc2a495 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
@@ -4,21 +4,19 @@
 #include <test_progs.h>
 #include <bpf/libbpf.h>
 #include <bpf/btf.h>
-#include "test_ksyms_module.lskel.h"
-
-static int duration;
+#include "test_ksyms_module.skel.h"
 
 void test_ksyms_module(void)
 {
-	struct test_ksyms_module* skel;
+	struct test_ksyms_module *skel;
 	int err;
 
 	skel = test_ksyms_module__open_and_load();
-	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+	if (!ASSERT_OK_PTR(skel, "test_ksyms_module__open_and_load"))
 		return;
 
 	err = test_ksyms_module__attach(skel);
-	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+	if (!ASSERT_OK(err, "test_ksyms_module__attach"))
 		goto cleanup;
 
 	usleep(1);
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_module.c b/tools/testing/selftests/bpf/progs/test_ksyms_module.c
index d6a0b3086b90..81f8790cb99d 100644
--- a/tools/testing/selftests/bpf/progs/test_ksyms_module.c
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_module.c
@@ -6,8 +6,11 @@
 #include <bpf/bpf_helpers.h>
 
 extern const int bpf_testmod_ksym_percpu __ksym;
+extern void bpf_testmod_test_mod_kfunc(int i) __ksym;
+extern void bpf_testmod_invalid_mod_kfunc(void) __ksym;
 
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
-- 
2.33.0

