Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EE0483DD9
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiADILY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:11:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55821 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234006AbiADILB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:11:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641283860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uDTf/DGOXxIRO6kbaoXtydGSDRn5G2e6XLZL3XY5bwo=;
        b=fENM+a/lWCRoTH+IzKvPDiJ8PPchrPlGbbQJUtZyCMjULZ/1jn5PwDXO90XWhovlnef8Mq
        oJJuAbd7HLTWP0g0AgtKUtfzVYOxusDH3j37/sUkl9cpxm6Nxqb+KFPnojkI8pAkBMcjeZ
        vgQ88swtJEdXS2Wd6kWXSLsGpP/NHWU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-apv1CmUyOyuvVad2ASJlqw-1; Tue, 04 Jan 2022 03:10:59 -0500
X-MC-Unique: apv1CmUyOyuvVad2ASJlqw-1
Received: by mail-ed1-f71.google.com with SMTP id h6-20020a056402280600b003f9967993aeso3843284ede.10
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 00:10:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uDTf/DGOXxIRO6kbaoXtydGSDRn5G2e6XLZL3XY5bwo=;
        b=aEBzRphOUXiIpliKRljyG/AABxp3WEy8yUiCQ4H8nwGfm3Vt1AoYMgWDhjnOIygtJ7
         18Brwk8XJaTzG0h+IH+ypGFSW0CtZMjHFXn0SzUKsX7GxWWkH16bx5KUASQS582kF8tZ
         Q3tSgjK98CjMTNCu46owQBPd6Uv2xFSdeoaTIR4OelVd5Kz5IbyItgJofzoj/+FEAiWd
         QtkEWGc8V3eeCozhaEyalI0KZwHjGiPjnjRkBsY0lk1XZvNQ+r1pIPrnL/SXlG0iyo+V
         SWkKB3y2N/+40u6bvkFzYhmSeBDl1pzxXqRL/ZXm1p//PIpBth418P/GVC/RimtIu0Qw
         b/zQ==
X-Gm-Message-State: AOAM530N1gLfSy2NYEsTg62oQbT3b8QaOBJmPJLJSKqu0q4s9Bk2K+Ge
        bmQeJq6dNjIjF+3SwN7WgvQ8NMV06HDwXQSet/EbZVFYVHyNE0wqHpP+42YXpKBC9rWfvZtKdAJ
        KtVaLVlsW3tkGC65l
X-Received: by 2002:aa7:d783:: with SMTP id s3mr47284050edq.172.1641283857964;
        Tue, 04 Jan 2022 00:10:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxBMvHVw8fcuawLiGOLreMDQWzlHCbdPW8CKjAs+4VUl7EscPuiyQQnMoKFCTlLhYONR9SQ9g==
X-Received: by 2002:aa7:d783:: with SMTP id s3mr47284028edq.172.1641283857793;
        Tue, 04 Jan 2022 00:10:57 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id hb17sm11158384ejc.195.2022.01.04.00.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 00:10:57 -0800 (PST)
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
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 12/13] selftest/bpf: Add raw kprobe attach test
Date:   Tue,  4 Jan 2022 09:09:42 +0100
Message-Id: <20220104080943.113249-13-jolsa@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220104080943.113249-1-jolsa@kernel.org>
References: <20220104080943.113249-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding raw kprobe attach test that uses new interface
to attach multiple kprobes with new kprobe link.

The test is attaching to bpf_fentry_test* functions and
single trampoline program to use bpf_prog_test_run to
trigger bpf_fentry_test* functions.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/raw_kprobe_test.c          | 92 +++++++++++++++++++
 .../testing/selftests/bpf/progs/raw_kprobe.c  | 58 ++++++++++++
 2 files changed, 150 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/raw_kprobe_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/raw_kprobe.c

diff --git a/tools/testing/selftests/bpf/prog_tests/raw_kprobe_test.c b/tools/testing/selftests/bpf/prog_tests/raw_kprobe_test.c
new file mode 100644
index 000000000000..5ade44c57c9e
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/raw_kprobe_test.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "raw_kprobe.skel.h"
+#include "trace_helpers.h"
+
+static void test_skel_api(void)
+{
+	struct raw_kprobe *skel = NULL;
+	__u32 duration = 0, retval;
+	int err, prog_fd;
+
+	skel = raw_kprobe__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "raw_kprobe__open_and_load"))
+		goto cleanup;
+
+	err = raw_kprobe__attach(skel);
+	if (!ASSERT_OK(err, "raw_kprobe__attach"))
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
+	raw_kprobe__destroy(skel);
+}
+
+static void test_link_api(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	int err, prog_fd, link1_fd = -1, link2_fd = -1;
+	struct raw_kprobe *skel = NULL;
+	__u32 duration = 0, retval;
+	__u64 addrs[8];
+
+	skel = raw_kprobe__open_and_load();
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
+	opts.kprobe.addrs = (__u64) addrs;
+	opts.kprobe.cnt = 8;
+
+	prog_fd = bpf_program__fd(skel->progs.test2);
+	link1_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_RAW_KPROBE, &opts);
+	if (!ASSERT_GE(link1_fd, 0, "link_fd"))
+		goto cleanup;
+
+	opts.flags = BPF_F_KPROBE_RETURN;
+	prog_fd = bpf_program__fd(skel->progs.test3);
+	link2_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_RAW_KPROBE, &opts);
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
+	raw_kprobe__destroy(skel);
+}
+
+void test_raw_kprobe_test(void)
+{
+	test_skel_api();
+	test_link_api();
+}
diff --git a/tools/testing/selftests/bpf/progs/raw_kprobe.c b/tools/testing/selftests/bpf/progs/raw_kprobe.c
new file mode 100644
index 000000000000..baf7086203f9
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/raw_kprobe.c
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
2.33.1

