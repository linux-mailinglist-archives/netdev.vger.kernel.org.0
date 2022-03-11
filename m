Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D454D5B52
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 07:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241449AbiCKGJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 01:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346927AbiCKGIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 01:08:11 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C282136857;
        Thu, 10 Mar 2022 22:07:09 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id z4so6634602pgh.12;
        Thu, 10 Mar 2022 22:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jhDqNslIb5crcHWUHx5agX9YI38yZBROYKqLO5ehE+c=;
        b=oYx782kfAK2tUJhIiSZ525ggBKIMLxhzj8hoxyROuJr4AZS3F8oRmsAXFipQ6bOeje
         NLLdjK2LfAF6IU0C0VTgahuVHjzziw51MhdSSLctXcpzN0VbrIKA6rvitc80Dc0c26+2
         KC0BfEJ1KpsEei80meW7gY80euTrOfzs6kl12YCep3Q6hCQ2/G5FSdY8QRjx+tBl7Gav
         +n9FtsDu3ikMUsX6CoWfC0YZt6O4ro7Err8SpnbXDqwp1Dz5EjqJSrfRLvQkmu/Qp3is
         qv0sINt9a12dLUQ0OUysYKBMkkQqiEmZ1Y3n26XvYHgpGBw6Y0Ya/mZxdfyUwludXfPX
         SqPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=jhDqNslIb5crcHWUHx5agX9YI38yZBROYKqLO5ehE+c=;
        b=6eWqcI0A2cW9zXW15AuPH9MSQI30uY42CcgM111U5gMVAPY8ZeTmjFtU1JFAiq7PAU
         ec7O7hjk3birlScHe2m5IwQj3GMw33pZw1IrI9iRC77dZXTFTENIb+5VMXhVO3RRwA+R
         W+ozAqQAyMoM7PDAxXpS4M4W6Y8R2zsx2s9lg5IR6/4hWEAofE1Tl8HmLE/bUY4VIuaD
         zDmZfazNRlitKcu4rjfpXcpE9wuUyDDstPx3nEwRqcBi+VCNi9878jpBuJgdRSsnL4I7
         +ARoRNL3FJAz/gpMrg1e/Rga6fVtPt67WrbLMYtL7PK1boAXbfP7OtvDLCBbEb7smgjY
         j7cg==
X-Gm-Message-State: AOAM533KkhtSNGad6nB/CZI5mMSGZMwdwBLnbTVLh7pfZHPNmyaxTMO/
        Z+QXIXNMxZYHfQwKneBrzhE=
X-Google-Smtp-Source: ABdhPJy+nxoTmji/m/GZPjJesHdTQAgSzLWd4Usfc5fsJiTYaR9x0YVciAO59U8rtA6ZAA3QSOvrHg==
X-Received: by 2002:a05:6a00:170a:b0:4f7:918a:1eac with SMTP id h10-20020a056a00170a00b004f7918a1eacmr351675pfc.16.1646978828741;
        Thu, 10 Mar 2022 22:07:08 -0800 (PST)
Received: from balhae.hsd1.ca.comcast.net ([2601:647:4800:3540:6133:9635:732f:1e6b])
        by smtp.gmail.com with ESMTPSA id k62-20020a17090a4cc400b001bf0d92e1c7sm7801014pjh.41.2022.03.10.22.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 22:07:08 -0800 (PST)
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
Subject: [PATCH v2 2/2] bpf/selftests: Test skipping stacktrace
Date:   Thu, 10 Mar 2022 22:07:03 -0800
Message-Id: <20220311060703.1856509-2-namhyung@kernel.org>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
In-Reply-To: <20220311060703.1856509-1-namhyung@kernel.org>
References: <20220311060703.1856509-1-namhyung@kernel.org>
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
 .../bpf/prog_tests/stacktrace_map_skip.c      | 61 ++++++++++++++++++
 .../selftests/bpf/progs/stacktrace_map_skip.c | 64 +++++++++++++++++++
 2 files changed, 125 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
 create mode 100644 tools/testing/selftests/bpf/progs/stacktrace_map_skip.c

diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
new file mode 100644
index 000000000000..5fe938f4a66c
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "stacktrace_map_skip.skel.h"
+
+#define TEST_STACK_DEPTH  2
+
+void test_stacktrace_map_skip(void)
+{
+	struct stacktrace_map_skip *skel;
+	int stackid_hmap_fd, stackmap_fd, stack_amap_fd;
+	int err, stack_trace_len;
+
+	skel = stacktrace_map_skip__open_and_load();
+	if (ASSERT_OK_PTR(skel, "skel_open_and_load"))
+		return;
+
+	/* find map fds */
+	stackid_hmap_fd = bpf_map__fd(skel->maps.stackid_hmap);
+	if (ASSERT_GE(stackid_hmap_fd, 0, "stackid_hmap fd"))
+		goto out;
+
+	stackmap_fd = bpf_map__fd(skel->maps.stackmap);
+	if (ASSERT_GE(stackmap_fd, 0, "stackmap fd"))
+		goto out;
+
+	stack_amap_fd = bpf_map__fd(skel->maps.stack_amap);
+	if (ASSERT_GE(stack_amap_fd, 0, "stack_amap fd"))
+		goto out;
+
+	err = stacktrace_map_skip__attach(skel);
+	if (ASSERT_OK(err, "skel_attach"))
+		goto out;
+
+	/* give some time for bpf program run */
+	sleep(1);
+
+	/* disable stack trace collection */
+	skel->bss->control = 1;
+
+	/* for every element in stackid_hmap, we can find a corresponding one
+	 * in stackmap, and vise versa.
+	 */
+	err = compare_map_keys(stackid_hmap_fd, stackmap_fd);
+	if (ASSERT_OK(err, "compare_map_keys stackid_hmap vs. stackmap"))
+		goto out;
+
+	err = compare_map_keys(stackmap_fd, stackid_hmap_fd);
+	if (ASSERT_OK(err, "compare_map_keys stackmap vs. stackid_hmap"))
+		goto out;
+
+	stack_trace_len = TEST_STACK_DEPTH * sizeof(__u64);
+	err = compare_stack_ips(stackmap_fd, stack_amap_fd, stack_trace_len);
+	if (ASSERT_OK(err, "compare_stack_ips stackmap vs. stack_amap"))
+		goto out;
+
+	if (ASSERT_EQ(skel->bss->failed, 0, "skip_failed"))
+		goto out;
+
+out:
+	stacktrace_map_skip__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c b/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c
new file mode 100644
index 000000000000..5c50bd57083a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+#define TEST_STACK_DEPTH	2
+#define TEST_MAX_ENTRIES	16384
+
+typedef __u64 stack_trace_t[TEST_STACK_DEPTH];
+
+struct {
+	__uint(type, BPF_MAP_TYPE_STACK_TRACE);
+	__uint(max_entries, TEST_MAX_ENTRIES);
+	__type(key, __u32);
+	__type(value, stack_trace_t);
+} stackmap SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, TEST_MAX_ENTRIES);
+	__type(key, __u32);
+	__type(value, __u32);
+} stackid_hmap SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, TEST_MAX_ENTRIES);
+	__type(key, __u32);
+	__type(value, stack_trace_t);
+} stack_amap SEC(".maps");
+
+int control = 0;
+int failed = 0;
+
+SEC("tracepoint/sched/sched_switch")
+int oncpu(struct trace_event_raw_sched_switch *ctx)
+{
+	__u32 max_len = TEST_STACK_DEPTH * sizeof(__u64);
+	__u32 key = 0, val = 0;
+	__u64 *stack_p;
+
+	if (control)
+		return 0;
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
+	} else {
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

