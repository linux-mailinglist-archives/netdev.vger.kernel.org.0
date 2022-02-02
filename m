Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF8E4A725E
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 14:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237853AbiBBNye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 08:54:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51528 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344737AbiBBNy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 08:54:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643810067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ndZKvuTAfuQTlyvC6PEP1xi3KVMCTEpQydu3XzbTIRw=;
        b=B+F3+zJYMQGXEcQEKAbkiBr4Xwk3mI8zsaxPXEudX+YwaZuKxJ2WARBO3SZ1JCrdts7Y9n
        gw5lghS74xdgUTXd0FJ5E/uQkwPfbbZ4WM3NrqXSnECQWeU3MGXjnDz3n1n94M2LqpRjPL
        G7mdP9lq5ixEUzif55s1rbQYcHe5nE4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-Emtwb9R5NBK89B5voV1Ngw-1; Wed, 02 Feb 2022 08:54:26 -0500
X-MC-Unique: Emtwb9R5NBK89B5voV1Ngw-1
Received: by mail-ej1-f71.google.com with SMTP id i21-20020a1709063c5500b006b4c7308c19so8155150ejg.14
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 05:54:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ndZKvuTAfuQTlyvC6PEP1xi3KVMCTEpQydu3XzbTIRw=;
        b=yBLFjg23p1dbijxr03wzKqnPghg5QiJs6vtDiq0CBIFCr0fBTFJqcRjXZ181/EJ2Y/
         n7ZSlolIrhhMe1nuMjZYonSaEKUDdNqjGd5CmsBtjq3Wb4DA2vx1GoivFl1vJ/7p1C6X
         x/ym7+ikLivWV2DE34Us8sRDLhHWQ7wDnQwxNJ+X+W0GDKhTWEkIMNJWbW734r4ECr98
         roHviFL0gVF8/yyiI8yTo9ehuVggSbPr/dImp54roNVwKULyYpN0nmB4QZ8YAQy+fusB
         x6mRxpN8Ysx3g1ShT4OQCMIgBD5XzSrg4WSLZ4ZWCsE/RD89CtIkcmyqC7FZvkyNpV3N
         jacA==
X-Gm-Message-State: AOAM532lb5oibwkAVQE3l0jQzH7YaJQrrNtB4tNAweV/cZVr/GD7hNsU
        qHdgljBaWsGiZ34+kVmkguVVM8Di1VNgKKgRWhLFaz/KOsymDfmJSGHHgaAJmym9fRpj7ll8YVR
        1wj+3FqkVZDowgzee
X-Received: by 2002:a05:6402:16cf:: with SMTP id r15mr30306462edx.406.1643810065534;
        Wed, 02 Feb 2022 05:54:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy6fmv5Qiwb3TMVnK4uiLl9uYsqBio1+nlTWUQc1NRXW+Y88hbgmFWbH25fj5/DYfJhAAS34w==
X-Received: by 2002:a05:6402:16cf:: with SMTP id r15mr30306452edx.406.1643810065387;
        Wed, 02 Feb 2022 05:54:25 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id kw5sm8493321ejc.140.2022.02.02.05.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 05:54:24 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
Subject: [PATCH 8/8] selftest/bpf: Add fprobe test for bpf_cookie values
Date:   Wed,  2 Feb 2022 14:53:33 +0100
Message-Id: <20220202135333.190761-9-jolsa@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202135333.190761-1-jolsa@kernel.org>
References: <20220202135333.190761-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding bpf_cookie test for kprobe attached by fprobe link.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/bpf_cookie.c     | 73 +++++++++++++++++++
 .../selftests/bpf/progs/fprobe_bpf_cookie.c   | 62 ++++++++++++++++
 2 files changed, 135 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/fprobe_bpf_cookie.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
index cd10df6cd0fc..bf70d859c598 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
@@ -7,6 +7,7 @@
 #include <unistd.h>
 #include <test_progs.h>
 #include "test_bpf_cookie.skel.h"
+#include "fprobe_bpf_cookie.skel.h"
 
 /* uprobe attach point */
 static void trigger_func(void)
@@ -63,6 +64,76 @@ static void kprobe_subtest(struct test_bpf_cookie *skel)
 	bpf_link__destroy(retlink2);
 }
 
+static void fprobe_subtest(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	int err, prog_fd, link1_fd = -1, link2_fd = -1;
+	struct fprobe_bpf_cookie *skel = NULL;
+	__u32 duration = 0, retval;
+	__u64 addrs[8], cookies[8];
+
+	skel = fprobe_bpf_cookie__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "fentry_raw_skel_load"))
+		goto cleanup;
+
+	kallsyms_find("bpf_fentry_test1", &addrs[0]);
+	kallsyms_find("bpf_fentry_test2", &addrs[1]);
+	kallsyms_find("bpf_fentry_test3", &addrs[2]);
+	kallsyms_find("bpf_fentry_test4", &addrs[3]);
+	kallsyms_find("bpf_fentry_test5", &addrs[4]);
+	kallsyms_find("bpf_fentry_test6", &addrs[5]);
+	kallsyms_find("bpf_fentry_test7", &addrs[6]);
+	kallsyms_find("bpf_fentry_test8", &addrs[7]);
+
+	cookies[0] = 1;
+	cookies[1] = 2;
+	cookies[2] = 3;
+	cookies[3] = 4;
+	cookies[4] = 5;
+	cookies[5] = 6;
+	cookies[6] = 7;
+	cookies[7] = 8;
+
+	opts.fprobe.addrs = (__u64) &addrs;
+	opts.fprobe.cnt = 8;
+	opts.fprobe.bpf_cookies = (__u64) &cookies;
+	prog_fd = bpf_program__fd(skel->progs.test2);
+
+	link1_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_FPROBE, &opts);
+	if (!ASSERT_GE(link1_fd, 0, "link1_fd"))
+		return;
+
+	cookies[0] = 8;
+	cookies[1] = 7;
+	cookies[2] = 6;
+	cookies[3] = 5;
+	cookies[4] = 4;
+	cookies[5] = 3;
+	cookies[6] = 2;
+	cookies[7] = 1;
+
+	opts.flags = BPF_F_FPROBE_RETURN;
+	prog_fd = bpf_program__fd(skel->progs.test3);
+
+	link2_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_FPROBE, &opts);
+	if (!ASSERT_GE(link2_fd, 0, "link2_fd"))
+		goto cleanup;
+
+	prog_fd = bpf_program__fd(skel->progs.test1);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
+
+	ASSERT_EQ(skel->bss->test2_result, 8, "test2_result");
+	ASSERT_EQ(skel->bss->test3_result, 8, "test3_result");
+
+cleanup:
+	close(link1_fd);
+	close(link2_fd);
+	fprobe_bpf_cookie__destroy(skel);
+}
+
 static void uprobe_subtest(struct test_bpf_cookie *skel)
 {
 	DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
@@ -249,6 +320,8 @@ void test_bpf_cookie(void)
 
 	if (test__start_subtest("kprobe"))
 		kprobe_subtest(skel);
+	if (test__start_subtest("rawkprobe"))
+		fprobe_subtest();
 	if (test__start_subtest("uprobe"))
 		uprobe_subtest(skel);
 	if (test__start_subtest("tracepoint"))
diff --git a/tools/testing/selftests/bpf/progs/fprobe_bpf_cookie.c b/tools/testing/selftests/bpf/progs/fprobe_bpf_cookie.c
new file mode 100644
index 000000000000..42cb109e5a30
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/fprobe_bpf_cookie.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+extern const void bpf_fentry_test1 __ksym;
+extern const void bpf_fentry_test2 __ksym;
+extern const void bpf_fentry_test3 __ksym;
+extern const void bpf_fentry_test4 __ksym;
+extern const void bpf_fentry_test5 __ksym;
+extern const void bpf_fentry_test6 __ksym;
+extern const void bpf_fentry_test7 __ksym;
+extern const void bpf_fentry_test8 __ksym;
+
+/* No tests, just to trigger bpf_fentry_test* through tracing test_run */
+SEC("fentry/bpf_modify_return_test")
+int BPF_PROG(test1)
+{
+	return 0;
+}
+
+__u64 test2_result = 0;
+
+SEC("kprobe/bpf_fentry_test*")
+int test2(struct pt_regs *ctx)
+{
+	__u64 cookie = bpf_get_attach_cookie(ctx);
+	__u64 addr = bpf_get_func_ip(ctx);
+
+	test2_result += (const void *) addr == &bpf_fentry_test1 && cookie == 1;
+	test2_result += (const void *) addr == &bpf_fentry_test2 && cookie == 2;
+	test2_result += (const void *) addr == &bpf_fentry_test3 && cookie == 3;
+	test2_result += (const void *) addr == &bpf_fentry_test4 && cookie == 4;
+	test2_result += (const void *) addr == &bpf_fentry_test5 && cookie == 5;
+	test2_result += (const void *) addr == &bpf_fentry_test6 && cookie == 6;
+	test2_result += (const void *) addr == &bpf_fentry_test7 && cookie == 7;
+	test2_result += (const void *) addr == &bpf_fentry_test8 && cookie == 8;
+
+	return 0;
+}
+
+__u64 test3_result = 0;
+
+SEC("kretprobe/bpf_fentry_test*")
+int test3(struct pt_regs *ctx)
+{
+	__u64 cookie = bpf_get_attach_cookie(ctx);
+	__u64 addr = bpf_get_func_ip(ctx);
+
+	test3_result += (const void *) addr == &bpf_fentry_test1 && cookie == 8;
+	test3_result += (const void *) addr == &bpf_fentry_test2 && cookie == 7;
+	test3_result += (const void *) addr == &bpf_fentry_test3 && cookie == 6;
+	test3_result += (const void *) addr == &bpf_fentry_test4 && cookie == 5;
+	test3_result += (const void *) addr == &bpf_fentry_test5 && cookie == 4;
+	test3_result += (const void *) addr == &bpf_fentry_test6 && cookie == 3;
+	test3_result += (const void *) addr == &bpf_fentry_test7 && cookie == 2;
+	test3_result += (const void *) addr == &bpf_fentry_test8 && cookie == 1;
+
+	return 0;
+}
-- 
2.34.1

