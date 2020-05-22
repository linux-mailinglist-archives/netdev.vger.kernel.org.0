Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9E51DDEE6
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 06:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgEVEZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 00:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgEVEZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 00:25:46 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D23C061A0E;
        Thu, 21 May 2020 21:25:45 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t11so4431370pgg.2;
        Thu, 21 May 2020 21:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=C2PrZsnGw7CdFe42LfRM4EShMI/0cNnS9PEyERV/Oxc=;
        b=XCUuu9vnpHAuS7SH5ThPflJTUsCWlaVowNyWpo44Kii3mTSDc78RTvwYTCBrYXkWVl
         ZQQefHs6KI/adzGjX2Sq5JTWBHzq2ZWgy0l5CM9yv0Ae23YoliflapNjJPbkRhW9/6bw
         /X7+tFPx9dV1OsDsUJMGegj/u2MImvj3DNPgodCElGVnKqQ9IiMhPD2tHBHAfBPgs+ZS
         X4butDEKfnFD72lh00JqwHFM+O3KWJUx8NJ8uArfQsNvYwz7E5AUG5vvUZFW8A8laqdl
         Uo3h7fEZA3+BRcKBrBoM7YFSLIAA1h3ggONdU233ZqTVtLDYY4JNYQIi5i5yb1Gt78gQ
         uH/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=C2PrZsnGw7CdFe42LfRM4EShMI/0cNnS9PEyERV/Oxc=;
        b=tZduN3/2dBTCvo2z79oZM7fQmZbbHAURTemUw6bgnb/5+VMIwByaRIuREzbNGpGHd/
         yI4nMfrJPrrzJcfBYz+nwIB2gMCwaCW8qHX8SuorlBTL0Lsmsco1q6/6g7Z2FNaKZVUT
         61132EdRwBCSR5FKJwevc2QAYdrKy71eC8ZWgD9Mp5q70sR4YrjjFAQFyM+DWXo+j4Nm
         GchNBb9AZjNZ/RkwuHWzmoiWnDSmvDMXej+o5gdrT/r6wat7PeV7n6rdvL7F8PfB6KVm
         rQ2iTHKg4icPkrp+FVgStJF+qG1Sz1Y5hLUe1jVcO8dsKP3oGkIhg4a6uYyFLbAtK3Mp
         LkeA==
X-Gm-Message-State: AOAM530KGytXdsAHjJgy50EGIgiOSScrAifLsUKetZB2ZE4U08DGOPBL
        UkVuUgMQ+uoP2BE82fw+2Lw=
X-Google-Smtp-Source: ABdhPJwGdOFdWj4bANaeCelduHQkDc0MuBHdpVVy0Dd/tB4PqzE/dE10Le7eI6VCMZLEP/EL4UEMEQ==
X-Received: by 2002:a17:90b:897:: with SMTP id bj23mr2296717pjb.82.1590121545573;
        Thu, 21 May 2020 21:25:45 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r25sm5929929pfg.145.2020.05.21.21.25.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 21:25:44 -0700 (PDT)
Subject: [bpf-next PATCH v4 5/5] bpf: selftests,
 test probe_* helpers from SCHED_CLS
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, jakub@cloudflare.com, lmb@cloudflare.com
Date:   Thu, 21 May 2020 21:25:29 -0700
Message-ID: <159012152966.14791.8918300114023263488.stgit@john-Precision-5820-Tower>
In-Reply-To: <159012108670.14791.18091717338621259928.stgit@john-Precision-5820-Tower>
References: <159012108670.14791.18091717338621259928.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lets test using probe* in SCHED_CLS network programs as well just
to be sure these keep working. Its cheap to add the extra test
and provides a second context to test outside of sk_msg after
we generalized probe* helpers to all networking types.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../testing/selftests/bpf/prog_tests/skb_helpers.c |   30 ++++++++++++++++++
 .../testing/selftests/bpf/progs/test_skb_helpers.c |   33 ++++++++++++++++++++
 2 files changed, 63 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skb_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skb_helpers.c

diff --git a/tools/testing/selftests/bpf/prog_tests/skb_helpers.c b/tools/testing/selftests/bpf/prog_tests/skb_helpers.c
new file mode 100644
index 0000000..f302ad8
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/skb_helpers.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+
+void test_skb_helpers(void)
+{
+	struct __sk_buff skb = {
+		.wire_len = 100,
+		.gso_segs = 8,
+		.gso_size = 10,
+	};
+	struct bpf_prog_test_run_attr tattr = {
+		.data_in = &pkt_v4,
+		.data_size_in = sizeof(pkt_v4),
+		.ctx_in = &skb,
+		.ctx_size_in = sizeof(skb),
+		.ctx_out = &skb,
+		.ctx_size_out = sizeof(skb),
+	};
+	struct bpf_object *obj;
+	int err;
+
+	err = bpf_prog_load("./test_skb_helpers.o", BPF_PROG_TYPE_SCHED_CLS, &obj,
+			    &tattr.prog_fd);
+	if (CHECK_ATTR(err, "load", "err %d errno %d\n", err, errno))
+		return;
+	err = bpf_prog_test_run_xattr(&tattr);
+	CHECK_ATTR(err, "len", "err %d errno %d\n", err, errno);
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_skb_helpers.c b/tools/testing/selftests/bpf/progs/test_skb_helpers.c
new file mode 100644
index 0000000..54c0993
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_skb_helpers.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+#define TEST_COMM_LEN 16
+
+struct {
+	__uint(type, BPF_MAP_TYPE_CGROUP_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, u32);
+	__type(value, u32);
+} cgroup_map SEC(".maps");
+
+char _license[] SEC("license") = "GPL";
+
+SEC("classifier/test_skb_helpers")
+int test_skb_helpers(struct __sk_buff *skb)
+{
+	struct task_struct *task;
+	char comm[TEST_COMM_LEN];
+	int ctask, ret = 0;
+	__u32 tpid;
+
+	ctask = bpf_current_task_under_cgroup(&cgroup_map, 0);
+	if (ctask)
+		ret = 1;
+	task = (struct task_struct *)bpf_get_current_task();
+
+	bpf_probe_read_kernel(&tpid , sizeof(tpid), &task->tgid);
+	bpf_probe_read_kernel_str(&comm, sizeof(comm), &task->comm);
+	return ret;
+}

