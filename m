Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3E31D5C15
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgEOWHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726179AbgEOWHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 18:07:34 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B538C061A0C;
        Fri, 15 May 2020 15:07:34 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id j3so4058273ilk.11;
        Fri, 15 May 2020 15:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=z33mlGjEz4I59W1+QKMq9lrKs++29fGwAD1ltXgXi64=;
        b=o3Y1DFLrbGYwuOHt8YEkkBXoWsc2pFqIMHo/giphTezCSjQum+r1wJ3z3Tz9wNWQoC
         yGz5r8EgXKCdxjJZactHz9fVa+3DRFwDpTKVgERzP3MNdRbTitX/BnGBnEYjw4Bmx+hQ
         tuZn8cL4UqlSN/zz2MyIEaA8gGx1vrYNqwKh0CgtCOmR1Yh3AkPVJqjilTo4OTFl5a18
         HAjMm+HQC0yL6GfIAK22cWdMqhfP165XjM5iMhtGVJimYQhJVyJPTSF9V97bITmpwTyb
         Up/MANjBY0F9B7YTxihJ6YKV5uGELdt9u/GBne/0U6EPdrSzragUJgajJe9HMksh04u7
         z+Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=z33mlGjEz4I59W1+QKMq9lrKs++29fGwAD1ltXgXi64=;
        b=HAXNvbjmNKicQj3D4AC2AG4RG1dofnsDLt6DOK3Nsqy4ZNYF3C3KH34FjBnqpKZP4W
         swLlD94UtfljzjK7w4+7SxBtz47X9j1oTvmig8pSIZ+163bGbuU9W20Kybno21W1EJVz
         jKAk24EgwhW9mNiqQRQkRCEztaCwKCjSlmGjrbepWlo0YWhkg9/YOL7RU2HLx+3fYebl
         x95CYdtn2iDK9+NwIfzrAaB5X/HsSL6qk1pLCbZsi9m8vY+M5w48nGlv438WKqtiEHiW
         Kd7EIcGbftiZqnEQqcpRSMlOTJoJPgSqjTNEZ2BVl32GD6WYW2LXZJWQs5RuKSSO2u2G
         MUqQ==
X-Gm-Message-State: AOAM531t6lJGfWu+hnEXa99F20z13bNBeT5/gUs6uViDtDxjaK9XMNih
        ROQMw7iWryP9KSEUBMY4En0=
X-Google-Smtp-Source: ABdhPJwff0wuXbjRSQh7sZsNfuZE1qnracD7horXU1HxglhUQoND710bAis6R0gsOe/Eai86jaME7A==
X-Received: by 2002:a92:4911:: with SMTP id w17mr5574961ila.254.1589580453636;
        Fri, 15 May 2020 15:07:33 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p7sm1154237iob.7.2020.05.15.15.07.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 May 2020 15:07:32 -0700 (PDT)
Subject: [bpf-next PATCH v2 5/5] bpf: selftests,
 test probe_* helpers from SCHED_CLS
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, netdev@vger.kernel.org
Date:   Fri, 15 May 2020 15:07:19 -0700
Message-ID: <158958043927.12532.9117835889381363621.stgit@john-Precision-5820-Tower>
In-Reply-To: <158958022865.12532.5430684453474460041.stgit@john-Precision-5820-Tower>
References: <158958022865.12532.5430684453474460041.stgit@john-Precision-5820-Tower>
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

