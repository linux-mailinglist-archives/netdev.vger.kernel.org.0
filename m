Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F22945B6CD
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241611AbhKXIqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:46:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22785 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241549AbhKXIpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:45:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637743327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XE2SVTrDU43kAFgXUbiTJeyLZudA8SDW3kmGcRKb0Vw=;
        b=PAj6FqcVSK+qWYru73oNDmpVge3CMaWZMfRbKD72WnWacez/c3KO+vq+bz/+P4jN4FYn+L
        Web7x1K9BmO3HfDY37cj+940ypO4iaWRcyPlaneL8K0CJaEFcUnCMxWSuyWuZcD730yH5d
        SzaFNr4HTO441nwmovrvL/1q7s4fjQ4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-LCvw2lHdOjqluZfd-5UPEA-1; Wed, 24 Nov 2021 03:42:05 -0500
X-MC-Unique: LCvw2lHdOjqluZfd-5UPEA-1
Received: by mail-wm1-f69.google.com with SMTP id g11-20020a1c200b000000b003320d092d08so948478wmg.9
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 00:42:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XE2SVTrDU43kAFgXUbiTJeyLZudA8SDW3kmGcRKb0Vw=;
        b=6w99QksqRUcKL8EsNW40OTiN4TVUVOAMNdi9I3mvvcdYHvNAFXvRMk+VKhYWqZIOLB
         M1g3Og8HOAfps2Qj30X5h1hOfq+B3rk+etmPvtaDmY25q6jcURr1/7ZV4Fe5ij9ACyr4
         p04WgqPa+K76k7Chla444Wh41W5rLBO5xd5rgpM5Q8TX9qKqz4J8BAAaWLwCKwD6/d0G
         MbYVEX9LwZJTO1GP+kcIkfqIMzLBKINi3vTGgLAqeJIOEBqgICy4fPJwxg5DF04FoCDb
         owZ/+81dtTX8EzQM+Ykj9dPPF5qbUFeUXVBMOfH1SWBPhE4yssknsRSC0goGN2KcgzbW
         uZjg==
X-Gm-Message-State: AOAM531YhX5BmM/qMWGCgOqjZsGpvpbIcgfJJwv2dJmeO91gwUUm1eP4
        792w3tWsAsy9u8lsXhFMBX/xSboeZ8FUhld5ktFbE5eBBeDVOjEsX2T38NwPXrIO8nPs5sslmX+
        yUPRBLs6935Up9jz1
X-Received: by 2002:a7b:cf18:: with SMTP id l24mr13013264wmg.145.1637743324587;
        Wed, 24 Nov 2021 00:42:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwI2m6uwjDLqQTtYRIdkFde1rsCNcXtW90vlfMyykQKNBK2ibWnzj4IPWNvsza0uD6UQJjz1w==
X-Received: by 2002:a7b:cf18:: with SMTP id l24mr13013193wmg.145.1637743324248;
        Wed, 24 Nov 2021 00:42:04 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id 10sm19080756wrb.75.2021.11.24.00.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 00:42:04 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Subject: [PATCH 7/8] selftest/bpf: Add kprobe multi attach test
Date:   Wed, 24 Nov 2021 09:41:18 +0100
Message-Id: <20211124084119.260239-8-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124084119.260239-1-jolsa@kernel.org>
References: <20211124084119.260239-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding kprobe multi attach test that uses new interface
to attach multiple probes within single perf event.

The test is attaching to bpf_fentry_test* functions and
single trampoline program to use bpf_prog_test_run to
trigger bpf_fentry_test* functions.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/multi_kprobe_test.c        | 83 +++++++++++++++++++
 .../selftests/bpf/progs/multi_kprobe.c        | 58 +++++++++++++
 2 files changed, 141 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_kprobe_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_kprobe.c

diff --git a/tools/testing/selftests/bpf/prog_tests/multi_kprobe_test.c b/tools/testing/selftests/bpf/prog_tests/multi_kprobe_test.c
new file mode 100644
index 000000000000..4aae472f9c16
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/multi_kprobe_test.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "multi_kprobe.skel.h"
+#include "trace_helpers.h"
+
+static void test_funcs_api(void)
+{
+	struct multi_kprobe *skel = NULL;
+	__u32 duration = 0, retval;
+	int err, prog_fd;
+
+	skel = multi_kprobe__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "fentry_multi_skel_load"))
+		goto cleanup;
+
+	err = multi_kprobe__attach(skel);
+	if (!ASSERT_OK(err, "fentry_attach"))
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
+	multi_kprobe__destroy(skel);
+}
+
+static void test_addrs_api(void)
+{
+	struct bpf_link *link1 = NULL, *link2 = NULL;
+	DECLARE_LIBBPF_OPTS(bpf_kprobe_opts, opts);
+	struct multi_kprobe *skel = NULL;
+	__u32 duration = 0, retval;
+	int err, prog_fd;
+	__u64 addrs[8];
+
+	skel = multi_kprobe__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "fentry_multi_skel_load"))
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
+	opts.multi.cnt = 8;
+	opts.multi.addrs = (__u64 *) &addrs;
+	link1 = bpf_program__attach_kprobe_opts(skel->progs.test2, NULL, &opts);
+	if (!ASSERT_OK_PTR(link1, "link1"))
+		goto cleanup;
+
+	link2 = bpf_program__attach_kprobe_opts(skel->progs.test3, NULL, &opts);
+	if (!ASSERT_OK_PTR(link1, "link1"))
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
+	bpf_link__destroy(link1);
+	bpf_link__destroy(link2);
+	multi_kprobe__destroy(skel);
+}
+void test_multi_kprobe_test(void)
+{
+	test_funcs_api();
+	test_addrs_api();
+}
diff --git a/tools/testing/selftests/bpf/progs/multi_kprobe.c b/tools/testing/selftests/bpf/progs/multi_kprobe.c
new file mode 100644
index 000000000000..67fe4c2486fc
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/multi_kprobe.c
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
+SEC("kprobe.multi/bpf_fentry_test*")
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
+SEC("kretprobe.multi/bpf_fentry_test*")
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

