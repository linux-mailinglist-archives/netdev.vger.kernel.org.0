Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40A71E00C2
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 18:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387792AbgEXQwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 12:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387707AbgEXQwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 12:52:13 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA78AC061A0E;
        Sun, 24 May 2020 09:52:12 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n18so7851444pfa.2;
        Sun, 24 May 2020 09:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=c+kV5gNWJS1YZqZMTWzL6tHSr3iTCMvs+TA8dfrV6Vc=;
        b=DcEFeqWklfSCALhxg0ovVbBLPa76pWTU4yxD7IrcXlxMLIACnyFR5+PJN4NfJibuNQ
         IBvBLpBZC7UVNxO7EWNvCCHtjBjcsGGU/F1lFUqcRQzLpt4obqKNmTbIkyaLKpXEaL3x
         KktuameQqxfbGPfHsI4eFRERXLxPe48vWhrz9Q5w3aIRxo1W1n6fycaRzGC8Tqo5hOQS
         VcjqPwCtV5f/L1qmYhFgJpVZ/yB0Lj6yLm2ANgybKygpcfNzX7LFq+5JriMeiwhD6fwY
         T+LM0BHaMFoDcT7IEhIt/n18dt8Y5anNBz6wwsRdIbCcATwvk4r/Rk51D4Jl6AamHKn5
         UC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=c+kV5gNWJS1YZqZMTWzL6tHSr3iTCMvs+TA8dfrV6Vc=;
        b=dKvuyVT0QvIwjvzZALPGAolX09iQjTxGRpqgdAQCwlWm17IYtyaFlhrOTq7mF+khVB
         tuJBo1AXmsk81lMU1N/jQGaO/iGS8TQh44y6x08SGZ3w+NtW/LJ6iOgKzPYbjDkfmxY9
         54WOyuweB0IyQuOYF5DxoUc5JQCEWkFekDuQSCbg8y0ahRY/yaVJTOFfOyXOHHFw2kkb
         /VdYhiVrvOqJFqujNUayuZ/CPSl2LGotCyOEln+axNrPDY+z5nhM59MZKf6KXPVywC/X
         5qIUXfywrCVxp9L7g917Fg4EBWPImCe8Csw1nnEyvHwuwTLmUYzs/lMlseSS94twGMoZ
         we+g==
X-Gm-Message-State: AOAM5321unR0u3kzr7cjEbVMFtMsJFEylrCjG0CqmWgecRhw6biO11aR
        tjOPeyiGiCPhdY1er0qOKKA=
X-Google-Smtp-Source: ABdhPJwaFDGJEQb7ER83PlbyJyBzESCKiZJWxuFZMPm1w85ohEjH6gX4HGe48gd9+B5wb+o2mylKSg==
X-Received: by 2002:aa7:99c8:: with SMTP id v8mr10245515pfi.36.1590339132361;
        Sun, 24 May 2020 09:52:12 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t12sm8747564pjf.3.2020.05.24.09.52.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 09:52:11 -0700 (PDT)
Subject: [bpf-next PATCH v5 5/5] bpf,
 selftests: test probe_* helpers from SCHED_CLS
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Sun, 24 May 2020 09:51:57 -0700
Message-ID: <159033911685.12355.15951980509828906214.stgit@john-Precision-5820-Tower>
In-Reply-To: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
References: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
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
 .../testing/selftests/bpf/prog_tests/skb_helpers.c |   30 ++++++++++++++++++++
 .../testing/selftests/bpf/progs/test_skb_helpers.c |   28 +++++++++++++++++++
 2 files changed, 58 insertions(+)
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
index 0000000..bb3fbf1
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_skb_helpers.c
@@ -0,0 +1,28 @@
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
+	__u32 tpid;
+
+	task = (struct task_struct *)bpf_get_current_task();
+	bpf_probe_read_kernel(&tpid , sizeof(tpid), &task->tgid);
+	bpf_probe_read_kernel_str(&comm, sizeof(comm), &task->comm);
+	return 0;
+}

