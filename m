Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85B34D4266
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 09:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240278AbiCJIXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 03:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbiCJIXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 03:23:10 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C15D1301B6;
        Thu, 10 Mar 2022 00:22:10 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id mm23-20020a17090b359700b001bfceefd8c6so1339992pjb.3;
        Thu, 10 Mar 2022 00:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z/Mr8oh0sWKEm17KedkzMdcKpYvzoba3uTd2uHZZr9s=;
        b=X5ihtfVuum0YUKHMU2jEqc/tEzjv6a/y4+REtlgaXQECTGRJCtu/aJJcsq4m7/KfJK
         UMf4hBdUYJGwVdbYQU94a57SU+/YGmMW5CpdGa+K+enoInnOnlkuQh3oKmJpphJLPZIl
         g6wHG7Gb7E38d32RU4uxaz0ZXrnkuXDBBwUqkvhJdDUvd92wYPEmD1j8chbQ4sBo78xS
         +uy4b2cX5ouWwTKYhmfgqn6lWt88VxBQcyZ5pzEofdgRvdjJx0R5iv4xvk6HweHwxP8R
         L/mhBMQcw/f/ODTz0BevBtf7MG6muzgCjI3QRjpWzHLkYgayzOmhnQDnxJRKbAmQYIn7
         wF2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=z/Mr8oh0sWKEm17KedkzMdcKpYvzoba3uTd2uHZZr9s=;
        b=Jr5vYbi+27vFnlf0Hpg+G1x5Y3PgAUo5gsbVD7pSdjGH12XqjjioGH1YnWJgcyMtZG
         f7WkA1qnv80bxblPv9R7E7Khe+q+ZLpnhRBBlJfwk72exXS91rbLUDnsvHIznrmQWELF
         QFQRw9kL9jhhndkrXV/tt5gPon71dfv/xQb/0n1N8Wxz2kIX23H49jbg5Oow/bLSnAcM
         DYp33yAbnxC3sqFkRfFsGMl3DEPJGQB8uBiTMGXhZaVF6JbCVj3EZLQcO9iwmc9WWHbq
         3E2vQ8Y6t5y4NyhSrxwFqMqtfTRcbhsU/GMbymhwLjQbMxjN39z7fGEsVZOM98OHl7jT
         NQwg==
X-Gm-Message-State: AOAM532MnYzqx2AjoVEqfgbDvpEBX8sx1kmmqiyV/ZtWTiCjLWoci8r0
        Vo0x2YDwxZwThhAvfh5dNBzasvU1QRs=
X-Google-Smtp-Source: ABdhPJxaKvATvJcKM/p3sRrZdAYUBZaW3EkkpE4vAwzzsPiNpXHpRAotjVf4CnOg/RpQyF5KKuyVMg==
X-Received: by 2002:a17:90b:2092:b0:1be:e373:2ed9 with SMTP id hb18-20020a17090b209200b001bee3732ed9mr3773083pjb.128.1646900529744;
        Thu, 10 Mar 2022 00:22:09 -0800 (PST)
Received: from balhae.hsd1.ca.comcast.net ([2601:647:4800:3540:e7f1:5749:9be:64e1])
        by smtp.gmail.com with ESMTPSA id a12-20020a056a000c8c00b004e1a76f0a8asm5903008pfv.51.2022.03.10.00.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 00:22:09 -0800 (PST)
Sender: Namhyung Kim <namhyung@gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Eugene Loh <eugene.loh@oracle.com>, Hao Luo <haoluo@google.com>
Subject: [PATCH 2/2] bpf/selftests: Test skipping stacktrace
Date:   Thu, 10 Mar 2022 00:22:02 -0800
Message-Id: <20220310082202.1229345-2-namhyung@kernel.org>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
In-Reply-To: <20220310082202.1229345-1-namhyung@kernel.org>
References: <20220310082202.1229345-1-namhyung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test case for stacktrace with skip > 0 using a small sized
buffer.  It didn't support skipping entries greater than or equal to
the size of buffer and filled the skipped part with 0.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 .../bpf/prog_tests/stacktrace_map_skip.c      | 72 ++++++++++++++++
 .../selftests/bpf/progs/stacktrace_map_skip.c | 82 +++++++++++++++++++
 2 files changed, 154 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
 create mode 100644 tools/testing/selftests/bpf/progs/stacktrace_map_skip.c

diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
new file mode 100644
index 000000000000..bcb244aa3c78
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "stacktrace_map_skip.skel.h"
+
+#define TEST_STACK_DEPTH  2
+
+void test_stacktrace_map_skip(void)
+{
+	struct stacktrace_map_skip *skel;
+	int control_map_fd, stackid_hmap_fd, stackmap_fd, stack_amap_fd;
+	int err, stack_trace_len;
+	__u32 key, val, duration = 0;
+
+	skel = stacktrace_map_skip__open_and_load();
+	if (CHECK(!skel, "skel_open_and_load", "skeleton open failed\n"))
+		return;
+
+	/* find map fds */
+	control_map_fd = bpf_map__fd(skel->maps.control_map);
+	if (CHECK_FAIL(control_map_fd < 0))
+		goto out;
+
+	stackid_hmap_fd = bpf_map__fd(skel->maps.stackid_hmap);
+	if (CHECK_FAIL(stackid_hmap_fd < 0))
+		goto out;
+
+	stackmap_fd = bpf_map__fd(skel->maps.stackmap);
+	if (CHECK_FAIL(stackmap_fd < 0))
+		goto out;
+
+	stack_amap_fd = bpf_map__fd(skel->maps.stack_amap);
+	if (CHECK_FAIL(stack_amap_fd < 0))
+		goto out;
+
+	err = stacktrace_map_skip__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed\n"))
+		goto out;
+
+	/* give some time for bpf program run */
+	sleep(1);
+
+	/* disable stack trace collection */
+	key = 0;
+	val = 1;
+	bpf_map_update_elem(control_map_fd, &key, &val, 0);
+
+	/* for every element in stackid_hmap, we can find a corresponding one
+	 * in stackmap, and vise versa.
+	 */
+	err = compare_map_keys(stackid_hmap_fd, stackmap_fd);
+	if (CHECK(err, "compare_map_keys stackid_hmap vs. stackmap",
+		  "err %d errno %d\n", err, errno))
+		goto out;
+
+	err = compare_map_keys(stackmap_fd, stackid_hmap_fd);
+	if (CHECK(err, "compare_map_keys stackmap vs. stackid_hmap",
+		  "err %d errno %d\n", err, errno))
+		goto out;
+
+	stack_trace_len = TEST_STACK_DEPTH * sizeof(__u64);
+	err = compare_stack_ips(stackmap_fd, stack_amap_fd, stack_trace_len);
+	if (CHECK(err, "compare_stack_ips stackmap vs. stack_amap",
+		  "err %d errno %d\n", err, errno))
+		goto out;
+
+	if (CHECK(skel->bss->failed, "check skip",
+		  "failed to skip some depth: %d", skel->bss->failed))
+		goto out;
+
+out:
+	stacktrace_map_skip__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c b/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c
new file mode 100644
index 000000000000..323248b17ae4
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+#define TEST_STACK_DEPTH         2
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} control_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 16384);
+	__type(key, __u32);
+	__type(value, __u32);
+} stackid_hmap SEC(".maps");
+
+typedef __u64 stack_trace_t[TEST_STACK_DEPTH];
+
+struct {
+	__uint(type, BPF_MAP_TYPE_STACK_TRACE);
+	__uint(max_entries, 16384);
+	__type(key, __u32);
+	__type(value, stack_trace_t);
+} stackmap SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 16384);
+	__type(key, __u32);
+	__type(value, stack_trace_t);
+} stack_amap SEC(".maps");
+
+/* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
+struct sched_switch_args {
+	unsigned long long pad;
+	char prev_comm[TASK_COMM_LEN];
+	int prev_pid;
+	int prev_prio;
+	long long prev_state;
+	char next_comm[TASK_COMM_LEN];
+	int next_pid;
+	int next_prio;
+};
+
+int failed = 0;
+
+SEC("tracepoint/sched/sched_switch")
+int oncpu(struct sched_switch_args *ctx)
+{
+	__u32 max_len = TEST_STACK_DEPTH * sizeof(__u64);
+	__u32 key = 0, val = 0, *value_p;
+	__u64 *stack_p;
+
+	value_p = bpf_map_lookup_elem(&control_map, &key);
+	if (value_p && *value_p)
+		return 0; /* skip if non-zero *value_p */
+
+	/* it should allow skipping whole buffer size entries */
+	key = bpf_get_stackid(ctx, &stackmap, TEST_STACK_DEPTH);
+	if ((int)key >= 0) {
+		/* The size of stackmap and stack_amap should be the same */
+		bpf_map_update_elem(&stackid_hmap, &key, &val, 0);
+		stack_p = bpf_map_lookup_elem(&stack_amap, &key);
+		if (stack_p) {
+			bpf_get_stack(ctx, stack_p, max_len, TEST_STACK_DEPTH);
+			/* it wrongly skipped all the entries and filled zero */
+			if (stack_p[0] == 0)
+				failed = 1;
+		}
+	} else if ((int)key == -14/*EFAULT*/) {
+		/* old kernel doesn't support skipping that many entries */
+		failed = 2;
+	}
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.35.1.723.g4982287a31-goog

