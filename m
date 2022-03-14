Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29EBA4D8BB8
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243868AbiCNSWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243807AbiCNSWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:22:10 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607703B298;
        Mon, 14 Mar 2022 11:20:48 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mr24-20020a17090b239800b001bf0a375440so30585pjb.4;
        Mon, 14 Mar 2022 11:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LwRv/0tj6zCgGj3pI1Se02RhnO0T/lVbf6tKA/QGNbk=;
        b=KNVUXH8jS87Y9Tplys6nAeZmV+e5UV1/ODUHleZLVVsRoWbuwxxE3drpo6wkCuGCmS
         w4Jzpf/QM0ZHCTO6d3gAsxzSFToY6rDlfdUuuBGWRjqcm/arZ7NEzw9FXH2GA+unAcxX
         k89vtqFnac8d9d6hkfSg0hUU8hQskUlNDYay7C699AcYrkd+/e6b8Z3PNKdtwWukMi41
         P0k6Ozyg8LWkFtUToJbESLY65VDehIfCW4Q8tb/tHdVh6llyI/xDQDmjenm2PGP9NnEE
         fMY66yM/Jx054p0PphsoiCADqfwuXIuO98VE3U1zwtDb6dkhpCMSrngV4zU2Hfq8a4Iw
         thNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=LwRv/0tj6zCgGj3pI1Se02RhnO0T/lVbf6tKA/QGNbk=;
        b=R/7Yz+l55+Gj7f9e1Rlaab8zkMfCw928iLggpLAn2znYifrzVvZFyadb9qdhE9schj
         31X31OctE4wuinxsuT9KUpZkWTl1qnGjqToJxu8KVF9I2Lo4JuSkHZ5glxbyRVJnXyUi
         1Kq3TVLE+lvEUidsqG/ypN36mVLTPa4YsWOM0CpRyEPDl8SBBWRRuaApPJyZCVBdrlPn
         rrJ2J8Iq46Wt2i9nzjda0VI0I2cs/AvzNYRzV3uiXSy+adNKQ7koIBAzaXm+JblwOqSS
         QA3QeCxZbmNPAFbfuMTt8WUrGz8OfJSrEE3jlJk2mYbj9MPaLD1ssdnG9bwZv514lgy9
         Cn9g==
X-Gm-Message-State: AOAM532LN/GGdpafhr4t+SHfOHpsnr/zp9OsIifzIjHSsZLeZ3rbBAxu
        OeSLRh4h8IXiadA0lYw1CuMCgDXU7/g=
X-Google-Smtp-Source: ABdhPJwfgwfbYR+MSsb6+uvXVc7YQ4N7x6f3PIXIqoKW8NE8YizKm8JbpZKuKHw1BayFy12dBzrvnQ==
X-Received: by 2002:a17:90b:2486:b0:1bc:9d6a:f22 with SMTP id nt6-20020a17090b248600b001bc9d6a0f22mr428416pjb.211.1647282047851;
        Mon, 14 Mar 2022 11:20:47 -0700 (PDT)
Received: from balhae.hsd1.ca.comcast.net ([2601:647:4800:3540:62a:d25b:6c78:634e])
        by smtp.gmail.com with ESMTPSA id o65-20020a17090a0a4700b001bef5cffea7sm619410pjo.0.2022.03.14.11.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 11:20:47 -0700 (PDT)
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
Subject: [PATCH v3 2/2] bpf/selftests: Test skipping stacktrace
Date:   Mon, 14 Mar 2022 11:20:42 -0700
Message-Id: <20220314182042.71025-2-namhyung@kernel.org>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
In-Reply-To: <20220314182042.71025-1-namhyung@kernel.org>
References: <20220314182042.71025-1-namhyung@kernel.org>
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
v3)
 * add pid filter
 * change assert condition

 .../bpf/prog_tests/stacktrace_map_skip.c      | 63 +++++++++++++++++
 .../selftests/bpf/progs/stacktrace_map_skip.c | 68 +++++++++++++++++++
 2 files changed, 131 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
 create mode 100644 tools/testing/selftests/bpf/progs/stacktrace_map_skip.c

diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
new file mode 100644
index 000000000000..1932b1e0685c
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
@@ -0,0 +1,63 @@
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
+	if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
+		return;
+
+	/* find map fds */
+	stackid_hmap_fd = bpf_map__fd(skel->maps.stackid_hmap);
+	if (!ASSERT_GE(stackid_hmap_fd, 0, "stackid_hmap fd"))
+		goto out;
+
+	stackmap_fd = bpf_map__fd(skel->maps.stackmap);
+	if (!ASSERT_GE(stackmap_fd, 0, "stackmap fd"))
+		goto out;
+
+	stack_amap_fd = bpf_map__fd(skel->maps.stack_amap);
+	if (!ASSERT_GE(stack_amap_fd, 0, "stack_amap fd"))
+		goto out;
+
+	skel->bss->pid = getpid();
+
+	err = stacktrace_map_skip__attach(skel);
+	if (!ASSERT_OK(err, "skel_attach"))
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
+	if (!ASSERT_OK(err, "compare_map_keys stackid_hmap vs. stackmap"))
+		goto out;
+
+	err = compare_map_keys(stackmap_fd, stackid_hmap_fd);
+	if (!ASSERT_OK(err, "compare_map_keys stackmap vs. stackid_hmap"))
+		goto out;
+
+	stack_trace_len = TEST_STACK_DEPTH * sizeof(__u64);
+	err = compare_stack_ips(stackmap_fd, stack_amap_fd, stack_trace_len);
+	if (!ASSERT_OK(err, "compare_stack_ips stackmap vs. stack_amap"))
+		goto out;
+
+	if (!ASSERT_EQ(skel->bss->failed, 0, "skip_failed"))
+		goto out;
+
+out:
+	stacktrace_map_skip__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c b/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c
new file mode 100644
index 000000000000..2eb297df3dd6
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/stacktrace_map_skip.c
@@ -0,0 +1,68 @@
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
+int pid = 0;
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
+	if (pid != (bpf_get_current_pid_tgid() >> 32))
+		return 0;
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

