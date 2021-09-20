Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2F14116AB
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239984AbhITORz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 10:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237100AbhITORo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 10:17:44 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B97C0613D8;
        Mon, 20 Sep 2021 07:16:07 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id h3-20020a17090a580300b0019ce70f8243so816765pji.4;
        Mon, 20 Sep 2021 07:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UEq+Y5CQwsqGuSVeljYsMjr1dnOEynCwvC9AfsACIYY=;
        b=ba3RgOFkiQReW3dM8fZ1ZgrAgteOB2vud20BTNaB8vpPtESNZANJigpCql4vxSotJL
         MIi5tP4XsOU6hL8nosx1pLQGrgZN1so/xXVnsDPBQ7gBJxDbQtSwcbq1GWVhil2Cf1FB
         wYcik69XuQtozqxYhiW2ARi4WUC6PqSa6Tn1ynminolnILDYovFxqdFYHQ4POus3E58J
         XU5ARq/FGWeigJ1j16YYaawPbU5GTjJBnMR+0ItELrDuTTm6mswHJRpA86sYwrOWthpX
         ISotTW81SG57n178uCJaqEkABqjpKO1KpIWyZHAXDgi2uePK+Jy6pOE1XwYwlGlWm8uf
         5EQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UEq+Y5CQwsqGuSVeljYsMjr1dnOEynCwvC9AfsACIYY=;
        b=neDU0Ln/VWkeJrD1yEtki+bOKXl1oIk6mxI2geTlAtEF32RYUSUa3evgjGkosmjgoW
         AkDg9xCZ4CyTfHhHf/y5eJwakaWf9O+YBTw6A8MIR4WFp7N71UGzFgPvX9eT47T4/rQX
         27YZU1w7Ij59pckJVX4Nhow3j26YFFbEcY1/viA7eV1/v55wJJjBVuxLfB3sIneR+OAc
         YuiCu15YX3lTuYeOVuXf5Ael6w2PrpeRp7YvkZARg5bLe2DPDMrXhtP48mX4LGlzfiiF
         GTl0uilAiLls5R3OqXcyOuhdNOH62NJUlYi+RJvB7j5gWJsFZBpHBajjsQId3JDVVL7d
         2FDA==
X-Gm-Message-State: AOAM533rmS3JyRH/EeHRiwvSvjH5U/WtexhT65NrSd9zydMYP0k4xoXf
        WyD5Z4LpQ1aqmUV1tsUSJzAs1Pixz76OcQ==
X-Google-Smtp-Source: ABdhPJzMcAojg1MqxuMzZnWKiEolDQaYbAnXC4ohP5Mw5SPvGsC7N0rutGZu5JLMD3xKKPQFfwVkjQ==
X-Received: by 2002:a17:902:760b:b0:13b:122:5ff0 with SMTP id k11-20020a170902760b00b0013b01225ff0mr22758132pll.22.1632147366744;
        Mon, 20 Sep 2021 07:16:06 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id g22sm8989124pfj.15.2021.09.20.07.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:16:05 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 11/11] bpf: selftests: Add selftests for module kfunc support
Date:   Mon, 20 Sep 2021 19:45:26 +0530
Message-Id: <20210920141526.3940002-12-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920141526.3940002-1-memxor@gmail.com>
References: <20210920141526.3940002-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=18843; h=from:subject; bh=9oaki4DdqaEzmp0XdWmwbTkYK1LrGPYRZn0nGYiaB3Y=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhSJaEQflotWbuNhBxaQoGjvEnS0oRBHjMrmwLtVhd nZEdONGJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUiWhAAKCRBM4MiGSL8RykVKEA CIr9Pb6xeV61MusfvnVkB7n0JF7OX+G2ITvi7sogQIllOYjlSsL4HxPHMSKqVQsHiETUNwJy413AAx ll4ONwNtcg4futPy0RQltEIb2Wo0XHpUVyqglBymS8ZsVTzWkfl1Lm3lqBTFCLTceM3u8tvCqUXrI6 xkKNpr99YrCt0P381B+bC16R5MMNp54ZgJFmHmIaf+MXLmuBYsMXpgh+05XY8bON+9sJYut+q4Pp4R qHYx3uQmWEujWuN/kjwCLH2z19EuNYksCRdH3Ft1HfdT8TK+FvtLH+pQmTESVdrBByzcZqwZjgQDO5 n0fGUck1P9Ys3IZaAGrobKZldg7nCM9smcSNVmT5rCeEmJDaiCL58Gk3LiA2QKIvcLFiaUIypbWDA2 XB82PfVhlQ+VMBFHNdU50wMyE6iOHneeIDfR0cvOlvRcEGHbA85IambufzbLG0WTAkDBkZObWr3PME RKnzGe6ScquhQEk1k6TewpG3ujAiisy1wQ+k6c1nz4IoBhwTE7rHRTxixUEJvRcQByK5m99RL3wnkP wJHFiZFf9nJoZOjBxh0AgFFmuabRF9XfgVdHYZ5BB2Efg+SlnVCDVHrs0dGPFHmTm6l3cTMvWVwQ4A YEF6yUsT5NnBhYU6cgTS3mHhdZQWlo7SXDLx9680jZb8P4sz9pJY0MzpM5AA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds selftests that tests the success and failure path for modules
kfuncs (in presence of invalid kfunc calls) for both libbpf and
gen_loader. It also adds a prog_test kfunc_btf_id_list so that we can
add module BTF ID set from bpf_testmod.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf.h                           |  2 +
 kernel/bpf/btf.c                              |  2 +
 net/bpf/test_run.c                            |  5 +-
 tools/testing/selftests/bpf/Makefile          |  5 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 26 ++++++-
 .../selftests/bpf/prog_tests/ksyms_module.c   | 52 ++++++++++----
 .../bpf/prog_tests/ksyms_module_libbpf.c      | 44 ++++++++++++
 .../selftests/bpf/progs/test_ksyms_module.c   | 41 ++++++++---
 .../bpf/progs/test_ksyms_module_fail.c        | 29 ++++++++
 .../progs/test_ksyms_module_fail_toomany.c    | 19 +++++
 .../bpf/progs/test_ksyms_module_libbpf.c      | 71 +++++++++++++++++++
 .../bpf/progs/test_ksyms_module_util.h        | 48 +++++++++++++
 12 files changed, 317 insertions(+), 27 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_fail_toomany.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_libbpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_util.h

diff --git a/include/linux/btf.h b/include/linux/btf.h
index f5ae81e225be..cab6aadf59de 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -270,7 +270,9 @@ static inline void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 					 THIS_MODULE }
 
 extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
+extern struct kfunc_btf_id_list prog_test_kfunc_list;
 
 DECLARE_CHECK_KFUNC_CALLBACK(bpf_tcp_ca);
+DECLARE_CHECK_KFUNC_CALLBACK(prog_test);
 
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 671b4f713a51..998aca7f42d0 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6397,3 +6397,5 @@ EXPORT_SYMBOL_GPL(unregister_kfunc_btf_id_set);
 
 DEFINE_KFUNC_BTF_ID_LIST(bpf_tcp_ca_kfunc_list);
 DEFINE_CHECK_KFUNC_CALLBACK(bpf_tcp_ca, bpf_tcp_ca_kfunc_list);
+DEFINE_KFUNC_BTF_ID_LIST(prog_test_kfunc_list);
+DEFINE_CHECK_KFUNC_CALLBACK(prog_test, prog_test_kfunc_list);
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index fe5c34f414a2..caa6831c1849 100644
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
+	return __bpf_check_prog_test_kfunc_call(kfunc_id, owner);
 }
 
 static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 326ea75ce99e..d20ff0563120 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -174,6 +174,7 @@ $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_tes
 	$(Q)$(RM) bpf_testmod/bpf_testmod.ko # force re-compilation
 	$(Q)$(MAKE) $(submake_extras) -C bpf_testmod
 	$(Q)cp bpf_testmod/bpf_testmod.ko $@
+	$(Q)$(RESOLVE_BTFIDS) -s ../../../../vmlinux bpf_testmod.ko
 
 $(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
 	$(call msg,CC,,$@)
@@ -315,8 +316,8 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
 		linked_vars.skel.h linked_maps.skel.h
 
 LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
-	test_ksyms_module.c test_ringbuf.c atomics.c trace_printk.c \
-	trace_vprintk.c
+	test_ksyms_module.c test_ksyms_module_fail.c test_ksyms_module_fail_toomany.c \
+	test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c
 SKEL_BLACKLIST += $$(LSKELS)
 
 test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index 50fc5561110a..4157d8497963 100644
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
@@ -10,9 +12,17 @@
 
 #define CREATE_TRACE_POINTS
 #include "bpf_testmod-events.h"
+#include "../progs/test_ksyms_module_util.h"
 
+KFUNC_DEFINE_VALID_DISTINCT_256;
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
@@ -71,13 +81,27 @@ static struct bin_attribute bin_attr_bpf_testmod_file __ro_after_init = {
 	.write = bpf_testmod_test_write,
 };
 
+BTF_SET_START(bpf_testmod_kfunc_ids)
+BTF_ID(func, bpf_testmod_test_mod_kfunc)
+KFUNC_BTF_ID_VALID_DISTINCT_256
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
index 2cd5cded543f..a0dd60f00c57 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
@@ -2,30 +2,54 @@
 /* Copyright (c) 2021 Facebook */
 
 #include <test_progs.h>
-#include <bpf/libbpf.h>
-#include <bpf/btf.h>
+#include <network_helpers.h>
 #include "test_ksyms_module.lskel.h"
+#include "test_ksyms_module_fail.lskel.h"
+#include "test_ksyms_module_fail_toomany.lskel.h"
 
-static int duration;
-
-void test_ksyms_module(void)
+void test_ksyms_module_main(void)
 {
-	struct test_ksyms_module* skel;
+	struct test_ksyms_module *skel;
+	int retval;
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
 
-	err = test_ksyms_module__attach(skel);
-	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+	err = bpf_prog_test_run(skel->progs.handler.prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
+				NULL, NULL, (__u32 *)&retval, NULL);
+	if (!ASSERT_OK(err, "bpf_prog_test_run"))
 		goto cleanup;
+	ASSERT_EQ(retval, 0, "retval");
+	ASSERT_EQ(skel->bss->out_bpf_testmod_ksym, 42, "bpf_testmod_ksym");
+cleanup:
+	test_ksyms_module__destroy(skel);
+}
 
-	usleep(1);
+void test_ksyms_module_fail(void)
+{
+	struct test_ksyms_module_fail_toomany *skel2;
+	struct test_ksyms_module_fail *skel1;
 
-	ASSERT_EQ(skel->bss->triggered, true, "triggered");
-	ASSERT_EQ(skel->bss->out_mod_ksym_global, 123, "global_ksym_val");
+	skel1 = test_ksyms_module_fail__open_and_load();
+	if (!ASSERT_EQ(skel1, NULL, "test_ksyms_module_fail__open_and_load"))
+		test_ksyms_module_fail__destroy(skel1);
 
-cleanup:
-	test_ksyms_module__destroy(skel);
+	skel2 = test_ksyms_module_fail_toomany__open_and_load();
+	if (!ASSERT_EQ(skel2, NULL, "test_ksyms_module_fail_toomany__open_and_load"))
+		test_ksyms_module_fail_toomany__destroy(skel2);
+}
+
+void test_ksyms_module(void)
+{
+	if (test__start_subtest("main"))
+		test_ksyms_module_main();
+	if (test__start_subtest("fail"))
+		test_ksyms_module_fail();
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
new file mode 100644
index 000000000000..d83297724ce8
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include <network_helpers.h>
+#include "test_ksyms_module_libbpf.skel.h"
+
+void test_ksyms_module_libbpf(void)
+{
+	struct test_ksyms_module_libbpf *skel;
+	int retval, err;
+
+	if (!env.has_testmod) {
+		test__skip();
+		return;
+	}
+
+	skel = test_ksyms_module_libbpf__open();
+	if (!ASSERT_OK_PTR(skel, "test_ksyms_module_libbpf__open"))
+		return;
+	err = bpf_program__set_autoload(skel->progs.load_fail1, false);
+	if (!ASSERT_OK(err, "bpf_program__set_autoload false load_fail1"))
+		goto cleanup;
+	err = bpf_program__set_autoload(skel->progs.load_fail2, false);
+	if (!ASSERT_OK(err, "bpf_program__set_autoload false load_fail2"))
+		goto cleanup;
+	err = test_ksyms_module_libbpf__load(skel);
+	if (!ASSERT_OK(err, "test_ksyms_module_libbpf__load"))
+		goto cleanup;
+	err = bpf_prog_test_run(bpf_program__fd(skel->progs.handler), 1, &pkt_v4,
+				sizeof(pkt_v4), NULL, NULL, (__u32 *)&retval, NULL);
+	if (!ASSERT_OK(err, "bpf_prog_test_run"))
+		goto cleanup;
+	ASSERT_EQ(retval, 0, "retval");
+	ASSERT_EQ(skel->bss->out_bpf_testmod_ksym, 42, "bpf_testmod_ksym");
+
+	err = bpf_program__load(skel->progs.load_fail1, "GPL", 0);
+	if (!ASSERT_NEQ(err, 0, "bpf_program__load load_fail1"))
+		goto cleanup;
+	err = bpf_program__load(skel->progs.load_fail2, "GPL", 0);
+	if (!ASSERT_NEQ(err, 0, "bpf_program__load load_fail2"))
+		goto cleanup;
+cleanup:
+	test_ksyms_module_libbpf__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_module.c b/tools/testing/selftests/bpf/progs/test_ksyms_module.c
index d6a0b3086b90..6b460c69a25a 100644
--- a/tools/testing/selftests/bpf/progs/test_ksyms_module.c
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_module.c
@@ -4,22 +4,45 @@
 #include "vmlinux.h"
 
 #include <bpf/bpf_helpers.h>
+#include "test_ksyms_module_util.h"
 
+KFUNC_KSYM_DECLARE_VALID_DISTINCT_256;
 extern const int bpf_testmod_ksym_percpu __ksym;
+extern void bpf_testmod_test_mod_kfunc(int i) __ksym;
+extern void bpf_testmod_invalid_mod_kfunc(void) __ksym __weak;
 
-int out_mod_ksym_global = 0;
-bool triggered = false;
+int out_bpf_testmod_ksym = 0;
+const volatile int x = 0;
 
-SEC("raw_tp/sys_enter")
-int handler(const void *ctx)
+SEC("classifier")
+int handler(struct __sk_buff *skb)
 {
-	int *val;
-	__u32 cpu;
+	/* This should be preserved by clang, but DCE'd by verifier, and still
+	 * allow loading the classifier prog
+	 */
+	if (x) {
+		bpf_testmod_invalid_mod_kfunc();
+		return -1;
+	}
+	bpf_testmod_test_mod_kfunc(42);
+	out_bpf_testmod_ksym = *(int *)bpf_this_cpu_ptr(&bpf_testmod_ksym_percpu);
+	return 0;
+}
 
-	val = (int *)bpf_this_cpu_ptr(&bpf_testmod_ksym_percpu);
-	out_mod_ksym_global = *val;
-	triggered = true;
+SEC("classifier")
+int load_256(struct __sk_buff *skb)
+{
+	/* this will fail if kfunc doesn't reuse its own btf fd index */
+	KFUNC_VALID_SAME_256;
+	KFUNC_VALID_SAME_ONE;
+	return 0;
+}
 
+SEC("classifier")
+int load_distinct256(struct __sk_buff *skb)
+{
+	/* kfuncs with distinct insn->imm, insn->off */
+	KFUNC_VALID_DISTINCT_256;
 	return 0;
 }
 
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_module_fail.c b/tools/testing/selftests/bpf/progs/test_ksyms_module_fail.c
new file mode 100644
index 000000000000..bcf98e814a7a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_module_fail.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+
+extern const int bpf_testmod_ksym_percpu __ksym;
+extern void bpf_testmod_test_mod_kfunc(int i) __ksym;
+extern void bpf_testmod_invalid_mod_kfunc(void) __ksym __weak;
+
+int out_bpf_testmod_ksym = 0;
+const volatile int x = 0;
+
+SEC("classifier")
+int load(struct __sk_buff *skb)
+{
+	/* This should be preserved by clang, but not DCE'd by verifier,
+	 * hence fail loading
+	 */
+	if (!x) {
+		bpf_testmod_invalid_mod_kfunc();
+		return -1;
+	}
+	bpf_testmod_test_mod_kfunc(42);
+	out_bpf_testmod_ksym = *(int *)bpf_this_cpu_ptr(&bpf_testmod_ksym_percpu);
+	return 0;
+}
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_module_fail_toomany.c b/tools/testing/selftests/bpf/progs/test_ksyms_module_fail_toomany.c
new file mode 100644
index 000000000000..633a743a67c7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_module_fail_toomany.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+#include "test_ksyms_module_util.h"
+
+KFUNC_KSYM_DECLARE_VALID_DISTINCT_256;
+extern void bpf_testmod_test_mod_kfunc(int i) __ksym;
+
+SEC("classifier")
+int load(struct __sk_buff *skb)
+{
+	KFUNC_VALID_DISTINCT_256;
+	KFUNC_VALID_SAME_ONE;
+	return 0;
+}
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_module_libbpf.c b/tools/testing/selftests/bpf/progs/test_ksyms_module_libbpf.c
new file mode 100644
index 000000000000..079a039ccda5
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_module_libbpf.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+#include "test_ksyms_module_util.h"
+
+KFUNC_KSYM_DECLARE_VALID_DISTINCT_256;
+extern const int bpf_testmod_ksym_percpu __ksym;
+extern void bpf_testmod_test_mod_kfunc(int i) __ksym;
+extern void bpf_testmod_invalid_mod_kfunc(void) __ksym __weak;
+
+int out_bpf_testmod_ksym = 0;
+const volatile int x = 0;
+
+SEC("classifier")
+int handler(struct __sk_buff *skb)
+{
+	/* This should be preserved by clang, but DCE'd by verifier, and still
+	 * allow loading the classifier prog
+	 */
+	if (x) {
+		bpf_testmod_invalid_mod_kfunc();
+		return -1;
+	}
+	bpf_testmod_test_mod_kfunc(42);
+	out_bpf_testmod_ksym = *(int *)bpf_this_cpu_ptr(&bpf_testmod_ksym_percpu);
+	return 0;
+}
+
+SEC("classifier")
+int load_fail1(struct __sk_buff *skb)
+{
+	/* This should be preserved by clang, but not DCE'd by verifier,
+	 * hence fail loading
+	 */
+	if (!x) {
+		bpf_testmod_invalid_mod_kfunc();
+		return -1;
+	}
+	bpf_testmod_test_mod_kfunc(42);
+	out_bpf_testmod_ksym = *(int *)bpf_this_cpu_ptr(&bpf_testmod_ksym_percpu);
+	return 0;
+}
+
+SEC("classifier")
+int load_fail2(struct __sk_buff *skb)
+{
+	KFUNC_VALID_DISTINCT_256;
+	KFUNC_VALID_SAME_ONE;
+	return 0;
+}
+
+SEC("classifier")
+int load_256(struct __sk_buff *skb)
+{
+	/* this will fail if kfunc doesn't reuse its own btf fd index */
+	KFUNC_VALID_SAME_256;
+	KFUNC_VALID_SAME_ONE;
+	return 0;
+}
+
+SEC("classifier")
+int load_distinct256(struct __sk_buff *skb)
+{
+	/* kfuncs with distinct insn->imm, insn->off */
+	KFUNC_VALID_DISTINCT_256;
+	return 0;
+}
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_module_util.h b/tools/testing/selftests/bpf/progs/test_ksyms_module_util.h
new file mode 100644
index 000000000000..3afa74841ae0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_module_util.h
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef __KSYMS_MODULE_UTIL_H__
+#define __KSYMS_MODULE_UTIL_H__
+
+#define __KFUNC_NR_EXP(Y)							\
+Y(0) Y(1) Y(2) Y(3) Y(4) Y(5) Y(6) Y(7) Y(8) Y(9) Y(10) Y(11) Y(12)		\
+Y(13) Y(14) Y(15) Y(16) Y(17) Y(18) Y(19) Y(20) Y(21) Y(22) Y(23)		\
+Y(24) Y(25) Y(26) Y(27) Y(28) Y(29) Y(30) Y(31) Y(32) Y(33) Y(34)		\
+Y(35) Y(36) Y(37) Y(38) Y(39) Y(40) Y(41) Y(42) Y(43) Y(44) Y(45)		\
+Y(46) Y(47) Y(48) Y(49) Y(50) Y(51) Y(52) Y(53) Y(54) Y(55) Y(56)		\
+Y(57) Y(58) Y(59) Y(60) Y(61) Y(62) Y(63) Y(64) Y(65) Y(66) Y(67)		\
+Y(68) Y(69) Y(70) Y(71) Y(72) Y(73) Y(74) Y(75) Y(76) Y(77) Y(78)		\
+Y(79) Y(80) Y(81) Y(82) Y(83) Y(84) Y(85) Y(86) Y(87) Y(88) Y(89)		\
+Y(90) Y(91) Y(92) Y(93) Y(94) Y(95) Y(96) Y(97) Y(98) Y(99) Y(100)		\
+Y(101) Y(102) Y(103) Y(104) Y(105) Y(106) Y(107) Y(108) Y(109) Y(110)		\
+Y(111) Y(112) Y(113) Y(114) Y(115) Y(116) Y(117) Y(118) Y(119) Y(120)		\
+Y(121) Y(122) Y(123) Y(124) Y(125) Y(126) Y(127) Y(128) Y(129) Y(130)		\
+Y(131) Y(132) Y(133) Y(134) Y(135) Y(136) Y(137) Y(138) Y(139) Y(140)		\
+Y(141) Y(142) Y(143) Y(144) Y(145) Y(146) Y(147) Y(148) Y(149) Y(150)		\
+Y(151) Y(152) Y(153) Y(154) Y(155) Y(156) Y(157) Y(158) Y(159) Y(160)		\
+Y(161) Y(162) Y(163) Y(164) Y(165) Y(166) Y(167) Y(168) Y(169) Y(170)		\
+Y(171) Y(172) Y(173) Y(174) Y(175) Y(176) Y(177) Y(178) Y(179) Y(180)		\
+Y(181) Y(182) Y(183) Y(184) Y(185) Y(186) Y(187) Y(188) Y(189) Y(190)		\
+Y(191) Y(192) Y(193) Y(194) Y(195) Y(196) Y(197) Y(198) Y(199) Y(200)		\
+Y(201) Y(202) Y(203) Y(204) Y(205) Y(206) Y(207) Y(208) Y(209) Y(210)		\
+Y(211) Y(212) Y(213) Y(214) Y(215) Y(216) Y(217) Y(218) Y(219) Y(220)		\
+Y(221) Y(222) Y(223) Y(224) Y(225) Y(226) Y(227) Y(228) Y(229) Y(230)		\
+Y(231) Y(232) Y(233) Y(234) Y(235) Y(236) Y(237) Y(238) Y(239) Y(240)		\
+Y(241) Y(242) Y(243) Y(244) Y(245) Y(246) Y(247) Y(248) Y(249) Y(250)		\
+Y(251) Y(252) Y(253) Y(254) Y(255)
+
+#define __KFUNC_A(nr) bpf_testmod_test_mod_kfunc_##nr();
+#define KFUNC_VALID_DISTINCT_256 __KFUNC_NR_EXP(__KFUNC_A)
+
+#define __KFUNC_B(nr) extern void bpf_testmod_test_mod_kfunc_##nr(void) __ksym;
+#define KFUNC_KSYM_DECLARE_VALID_DISTINCT_256 __KFUNC_NR_EXP(__KFUNC_B)
+
+#define __KFUNC_C(nr) noinline void bpf_testmod_test_mod_kfunc_##nr(void) {};
+#define KFUNC_DEFINE_VALID_DISTINCT_256 __KFUNC_NR_EXP(__KFUNC_C)
+
+#define __KFUNC_D(nr) BTF_ID(func, bpf_testmod_test_mod_kfunc_##nr)
+#define KFUNC_BTF_ID_VALID_DISTINCT_256 __KFUNC_NR_EXP(__KFUNC_D)
+
+#define __KFUNC_E(nr) bpf_testmod_test_mod_kfunc(nr);
+#define KFUNC_VALID_SAME_ONE __KFUNC_E(0)
+#define KFUNC_VALID_SAME_256 __KFUNC_NR_EXP(__KFUNC_E)
+
+#endif
-- 
2.33.0

