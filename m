Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33474A7252
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 14:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343550AbiBBNya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 08:54:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34439 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344629AbiBBNyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 08:54:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643810061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bLaeMerEotaa1PvsxAUE2R3tXfnbR0hxnx4SsL7NZbg=;
        b=T5AvYGZjIs9OJrp4dJ2aMexJ8FB4RHMhD63MfGewDrE6m8GARDkPqTywm+q8HbGRY30/D/
        TTSn6/Ta1I7XJRa9Sxszg/Bbg51AfyBkf6rGL1UroKtDtka5n2hSS5y7qicXmJhVu0NAfj
        35UwfjD1xmII8HZcLkkS3k15R6VOvgY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-WXYkcK46MHiy0DXHUnni-g-1; Wed, 02 Feb 2022 08:54:20 -0500
X-MC-Unique: WXYkcK46MHiy0DXHUnni-g-1
Received: by mail-ej1-f70.google.com with SMTP id ky6-20020a170907778600b0068e4bd99fd1so8155819ejc.15
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 05:54:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bLaeMerEotaa1PvsxAUE2R3tXfnbR0hxnx4SsL7NZbg=;
        b=uappf1PJPECMHEkXJh1bARzsE3PpFNc/SmJCJmUJ+bVoh1MUDXKIvpZLv0pz+TVqsD
         I9iQFLdiRpGZR4Ah8tXRunzCufsp1eTmuDItN+dlMCuTu8fjUi/8ghirZ4cqmHfhv6kk
         Uzj8U2LSAY6xxWVz5w0q3uzgJw2vXyBCLJVho6FYZtkHsF7c7bon/dCtTBT+dNyXGG8l
         tWIHNMUNiYRq08SsuyTyaP+IL3sh7Zscmk97aV3YupCjEQFYzZm57HQX6p/LsV3HRQwF
         x2riLRM+3SquEHpEgUIWzOmYLe8sdl1Q8bgj8d4LTKl+SwTXcHmTHnSrONQUmC8nhFMK
         NLYQ==
X-Gm-Message-State: AOAM530n5kOGYSVHGl+8rQ1et0uArraSJ5Fc/6Rs/AxB9DGoSsGCqGhx
        X88CBeucYSBEXos6JeYSycNK9tBgOOjWvbPi5GmX0qHMY9BHkf6LU/39q5O3vqOQmgBKOP10IYf
        ik+Pmcfgz7efMPBpy
X-Received: by 2002:a17:907:7da8:: with SMTP id oz40mr19493094ejc.328.1643810059319;
        Wed, 02 Feb 2022 05:54:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz1VYc7yglvMYwmqUOo2giJKTPpWpi3bTqqc0M8BtqUBkJ+RuokTlGaYir/ixadM+hilTAryg==
X-Received: by 2002:a17:907:7da8:: with SMTP id oz40mr19493065ejc.328.1643810059057;
        Wed, 02 Feb 2022 05:54:19 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id jl17sm16087939ejc.13.2022.02.02.05.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 05:54:18 -0800 (PST)
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
Subject: [PATCH 7/8] selftest/bpf: Add fprobe attach test
Date:   Wed,  2 Feb 2022 14:53:32 +0100
Message-Id: <20220202135333.190761-8-jolsa@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202135333.190761-1-jolsa@kernel.org>
References: <20220202135333.190761-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding kprobe attach test that uses new fprobe interface
to attach kprobe program to multiple functions.

The test is attaching to bpf_fentry_test* functions and
uses single trampoline program bpf_prog_test_run to trigger
bpf_fentry_test* functions.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/fprobe_test.c    | 117 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/fprobe.c    |  58 +++++++++
 2 files changed, 175 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fprobe_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/fprobe.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fprobe_test.c b/tools/testing/selftests/bpf/prog_tests/fprobe_test.c
new file mode 100644
index 000000000000..dcbde37ec369
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/fprobe_test.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "fprobe.skel.h"
+#include "trace_helpers.h"
+
+static void test_skel_api(void)
+{
+	struct fprobe *skel = NULL;
+	__u32 duration = 0, retval;
+	int err, prog_fd;
+
+	skel = fprobe__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "fprobe__open_and_load"))
+		goto cleanup;
+
+	err = fprobe__attach(skel);
+	if (!ASSERT_OK(err, "fprobe__attach"))
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
+	fprobe__destroy(skel);
+}
+
+static void test_link_api(struct bpf_link_create_opts *opts)
+{
+	int err, prog_fd, link1_fd = -1, link2_fd = -1;
+	struct fprobe *skel = NULL;
+	__u32 duration = 0, retval;
+
+	skel = fprobe__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "fentry_raw_skel_load"))
+		goto cleanup;
+
+	prog_fd = bpf_program__fd(skel->progs.test2);
+	link1_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_FPROBE, opts);
+	if (!ASSERT_GE(link1_fd, 0, "link_fd"))
+		goto cleanup;
+
+	opts->fprobe.flags = BPF_F_FPROBE_RETURN;
+	prog_fd = bpf_program__fd(skel->progs.test3);
+	link2_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_FPROBE, opts);
+	if (!ASSERT_GE(link2_fd, 0, "link_fd"))
+		goto cleanup;
+
+	skel->bss->test2_result = 0;
+	skel->bss->test3_result = 0;
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
+	if (link1_fd != -1)
+		close(link1_fd);
+	if (link2_fd != -1)
+		close(link2_fd);
+	fprobe__destroy(skel);
+}
+
+static void test_link_api_addrs(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	__u64 addrs[8];
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
+	opts.fprobe.addrs = (__u64) addrs;
+	opts.fprobe.cnt = 8;
+	test_link_api(&opts);
+}
+
+static void test_link_api_syms(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	const char *syms[8] = {
+		"bpf_fentry_test1",
+		"bpf_fentry_test2",
+		"bpf_fentry_test3",
+		"bpf_fentry_test4",
+		"bpf_fentry_test5",
+		"bpf_fentry_test6",
+		"bpf_fentry_test7",
+		"bpf_fentry_test8",
+	};
+
+	opts.fprobe.syms = (__u64) syms;
+	opts.fprobe.cnt = 8;
+	test_link_api(&opts);
+}
+
+void test_fprobe_test(void)
+{
+	test_skel_api();
+	test_link_api_syms();
+	test_link_api_addrs();
+}
diff --git a/tools/testing/selftests/bpf/progs/fprobe.c b/tools/testing/selftests/bpf/progs/fprobe.c
new file mode 100644
index 000000000000..baf7086203f9
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/fprobe.c
@@ -0,0 +1,58 @@
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
+	__u64 addr = bpf_get_func_ip(ctx);
+
+	test2_result += (const void *) addr == &bpf_fentry_test1 ||
+			(const void *) addr == &bpf_fentry_test2 ||
+			(const void *) addr == &bpf_fentry_test3 ||
+			(const void *) addr == &bpf_fentry_test4 ||
+			(const void *) addr == &bpf_fentry_test5 ||
+			(const void *) addr == &bpf_fentry_test6 ||
+			(const void *) addr == &bpf_fentry_test7 ||
+			(const void *) addr == &bpf_fentry_test8;
+	return 0;
+}
+
+__u64 test3_result = 0;
+
+SEC("kretprobe/bpf_fentry_test*")
+int test3(struct pt_regs *ctx)
+{
+	__u64 addr = bpf_get_func_ip(ctx);
+
+	test3_result += (const void *) addr == &bpf_fentry_test1 ||
+			(const void *) addr == &bpf_fentry_test2 ||
+			(const void *) addr == &bpf_fentry_test3 ||
+			(const void *) addr == &bpf_fentry_test4 ||
+			(const void *) addr == &bpf_fentry_test5 ||
+			(const void *) addr == &bpf_fentry_test6 ||
+			(const void *) addr == &bpf_fentry_test7 ||
+			(const void *) addr == &bpf_fentry_test8;
+	return 0;
+}
-- 
2.34.1

