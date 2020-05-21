Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B00C1DD020
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 16:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbgEUOge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 10:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729838AbgEUOgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 10:36:33 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D4AC061A0E;
        Thu, 21 May 2020 07:36:32 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id cx22so3174055pjb.1;
        Thu, 21 May 2020 07:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=z33mlGjEz4I59W1+QKMq9lrKs++29fGwAD1ltXgXi64=;
        b=kd/D0i5f36zS9vqDgHlqw0XRXPk3QlOFVcILhfDAfJBn4m0y/Nu6nF0pSLV4C65u6E
         p5dsfEF/fEoF1hejvS3Pk9ai8yr/68/oUjPHi7kA7i/KnbM/+tH5lRaEjjMLmiMWOqWQ
         /rEjhhNiROFNqlRacV/2Mi4TkyeBx66owfwlej8jZBoNDhbiPKOESO37OCB6Iyi5rqbn
         YoVJ0kWKbmR8pf64Uc6CpG5/+opgdGXf2HgmYLP2bH1a8QdBs8QmVcCDJNDNcZd0QorZ
         ObV6K/qouDWpJKMBdtNHpa0NvCJNUZuKYd1aYvkr8iGsZoY/zupbmNnBanGa/KWPKiSW
         MBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=z33mlGjEz4I59W1+QKMq9lrKs++29fGwAD1ltXgXi64=;
        b=EXu2udMlfQ0BieMHLuYBYmgkaEttux2FfbYerBpDZqtZxWTRkIqCwBFxX5vXxSyEDU
         v6/UlMRPNzW2gzl8nPJSUuhKQvJpqQGRMbdEfsIJ+KIBMsmpPyY28og2d7unryTDxuJL
         8Vmnit+tOoO//aVHHE1fqWlNVVOMUuvmouH8bL/HTe53Em+THKfx8ZYHj2OD+OPAATgf
         HQaT+GtJyFfIvYuoJp2QbY+BW3qqU9u/XgJKFgVu8EmyjeZc12WzMToKzRd9F1zuPbgd
         NbZX8UESNMQhAlwWR0OaCM5PWQzXcKk1ZwTIm79po6lLurDjNgNc0HIVpwIV57jpqmW4
         4TKg==
X-Gm-Message-State: AOAM530nTeJqydFr/amrC4U/dtjPWXmeFmpHRkKcDv3gOHYSM/jCbGcn
        aFxrUUMVIq9JwsRetxn3kqk=
X-Google-Smtp-Source: ABdhPJw/VOwVXHlkFSNbGJJUL4zHWBAM89h5E0m+UDRRP1Mc1ZXhmuwEd4+r4YoecUuhAm9RurTrkg==
X-Received: by 2002:a17:90b:ecf:: with SMTP id gz15mr11729408pjb.122.1590071792371;
        Thu, 21 May 2020 07:36:32 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id cv21sm4646401pjb.23.2020.05.21.07.36.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 07:36:31 -0700 (PDT)
Subject: [bpf-next PATCH v3 5/5] bpf: selftests,
 test probe_* helpers from SCHED_CLS
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, netdev@vger.kernel.org
Date:   Thu, 21 May 2020 07:36:18 -0700
Message-ID: <159007177838.10695.12211214514015683724.stgit@john-Precision-5820-Tower>
In-Reply-To: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
References: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
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

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../testing/selftests/bpf/prog_tests/skb_helpers.c |   30 ++++++++++++++++++
 .../testing/selftests/bpf/progs/test_skb_helpers.c |   33 ++++++++++++++++++++
 2 files changed, 63 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skb_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skb_helpers.c

diff --git a/tools/testing/selftests/bpf/prog_tests/skb_helpers.c b/tools/testing/selftests/bpf/prog_tests/skb_helpers.c
new file mode 100644
index 0000000..5a865c4
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
+
+	err = bpf_prog_test_run_xattr(&tattr);
+	CHECK_ATTR(err != 0, "len", "err %d errno %d\n", err, errno);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_skb_helpers.c b/tools/testing/selftests/bpf/progs/test_skb_helpers.c
new file mode 100644
index 0000000..05a1260
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_skb_helpers.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+int _version SEC("version") = 1;
+
+#define TEST_COMM_LEN 10
+
+struct bpf_map_def SEC("maps") cgroup_map = {
+	.type			= BPF_MAP_TYPE_CGROUP_ARRAY,
+	.key_size		= sizeof(u32),
+	.value_size		= sizeof(u32),
+	.max_entries	= 1,
+};
+
+char _license[] SEC("license") = "GPL";
+
+SEC("classifier/test_skb_helpers")
+int test_skb_helpers(struct __sk_buff *skb)
+{
+	struct task_struct *task;
+	char *comm[TEST_COMM_LEN];
+	__u32 tpid;
+	int ctask;
+
+	ctask = bpf_current_task_under_cgroup(&cgroup_map, 0);
+	task = (struct task_struct *)bpf_get_current_task();
+
+	bpf_probe_read_kernel(&tpid , sizeof(tpid), &task->tgid);
+	bpf_probe_read_kernel_str(&comm, sizeof(comm), &task->comm);
+	return 0;
+}

