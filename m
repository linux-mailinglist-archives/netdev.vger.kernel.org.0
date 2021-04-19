Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696A5364181
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 14:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239207AbhDSMTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 08:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239175AbhDSMTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 08:19:11 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF542C06174A;
        Mon, 19 Apr 2021 05:18:37 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p12so24125327pgj.10;
        Mon, 19 Apr 2021 05:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=523lx1zruoa/L3sPQjk8cCBknzg8JrQTDqhjRSnM/8o=;
        b=RkjJKb2cVIQnU+oZcUJA1EtWRFb1NdFq/aT8bC6XDLOBVajw0RYu1LXRnmHRMKMTAw
         PaydQzKQR8JXEFBm53iATXlSY7APhiCBh1LVkULl4GbgXXlF5T0mGwKSKM7iRDqzE4CC
         FZshiNtv6r+1+HQyNR2ZOMqbnXjzJgQvz9mSEalUU3U8nArvciMTzW4/qx8Lhb4thCUN
         SD7ujnCbpdT7dYH471schJE974xmFMesnM6mFyVuxdPPAu7uilfpoTnE7PeGz/gyMmsQ
         I6Zcs8+/DsfJnd+MZ1gIjFOBCD/HZxZxrRIBwCFrOUVe2198gsWq/rO2AnaeuGt+KwK+
         nFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=523lx1zruoa/L3sPQjk8cCBknzg8JrQTDqhjRSnM/8o=;
        b=CG1o3uk8SyFSrNeYiCF3pKHNfgAD5d0b/WkehM7ED0QkZbO2kTEW/np4Qdbm24UVFY
         QMiOuRXhMzmUutVVtkTbOWRshF4jx7sqLkdMd1dz4GXO/hCZYQVSQP+CTDuTzmIMsHNy
         zCAbtIlF7OAlmYpKNx6e244gjVz4aF3qcwlcV7CJtwdkFQ43JFsBq3ozaMKBS1Ht8nIf
         EMKHzd2PEUV/eWNt8tuvkhyhrHvv/k6QejbmQCrKnKfyhwUWNc4LnL36ezcicWbEhUNG
         Ju9m5WV7A/ZwbUF/Y1ZamnDFUGYYF4TmLCaBwnEdHlTwDJNrQgSZhBs/fn2fwt1o6X07
         G01A==
X-Gm-Message-State: AOAM530fXD+0CcZrIRxK9ZhCp6/ydumA/I8huimVDZLZrYw3lA7GQh9B
        aEB8X3Q6GiCgn3dn5dVMTU+gUcYDXPhYtQ==
X-Google-Smtp-Source: ABdhPJyGmvnirYv8KEt+qk7jMIRiNk0Uqvtp7W8brp7JtSKIrUJ0bkWljRpoa+UcAGksqJvqo54whg==
X-Received: by 2002:a63:4415:: with SMTP id r21mr11614309pga.222.1618834717106;
        Mon, 19 Apr 2021 05:18:37 -0700 (PDT)
Received: from localhost ([112.79.253.181])
        by smtp.gmail.com with ESMTPSA id g24sm14205466pgn.18.2021.04.19.05.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 05:18:36 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 4/4] libbpf: add selftests for TC-BPF API
Date:   Mon, 19 Apr 2021 17:48:11 +0530
Message-Id: <20210419121811.117400-5-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419121811.117400-1-memxor@gmail.com>
References: <20210419121811.117400-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds some basic tests for the low level bpf_tc_cls_* API.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../selftests/bpf/prog_tests/test_tc_bpf.c    | 112 ++++++++++++++++++
 .../selftests/bpf/progs/test_tc_bpf_kern.c    |  12 ++
 2 files changed, 124 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c b/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
new file mode 100644
index 000000000000..945f3a1a72f8
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <linux/err.h>
+#include <linux/limits.h>
+#include <bpf/libbpf.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <test_progs.h>
+#include <linux/if_ether.h>
+
+#define LO_IFINDEX 1
+
+static int test_tc_cls_internal(int fd, __u32 parent_id)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_cls_opts, opts, .handle = 1, .priority = 10,
+			    .class_id = TC_H_MAKE(1UL << 16, 1),
+			    .chain_index = 5);
+	struct bpf_tc_cls_attach_id id = {};
+	struct bpf_tc_cls_info info = {};
+	int ret;
+
+	ret = bpf_tc_cls_attach(fd, LO_IFINDEX, parent_id, &opts, &id);
+	if (CHECK_FAIL(ret < 0))
+		return ret;
+
+	ret = bpf_tc_cls_get_info(fd, LO_IFINDEX, parent_id, NULL, &info);
+	if (CHECK_FAIL(ret < 0))
+		goto end;
+
+	ret = -1;
+
+	if (CHECK_FAIL(info.id.handle != id.handle) ||
+	    CHECK_FAIL(info.id.chain_index != id.chain_index) ||
+	    CHECK_FAIL(info.id.priority != id.priority) ||
+	    CHECK_FAIL(info.id.handle != 1) ||
+	    CHECK_FAIL(info.id.priority != 10) ||
+	    CHECK_FAIL(info.class_id != TC_H_MAKE(1UL << 16, 1)) ||
+	    CHECK_FAIL(info.id.chain_index != 5))
+		goto end;
+
+	ret = bpf_tc_cls_replace(fd, LO_IFINDEX, parent_id, &opts, &id);
+	if (CHECK_FAIL(ret < 0))
+		return ret;
+
+	if (CHECK_FAIL(info.id.handle != 1) ||
+	    CHECK_FAIL(info.id.priority != 10) ||
+	    CHECK_FAIL(info.class_id != TC_H_MAKE(1UL << 16, 1)))
+		goto end;
+
+	/* Demonstrate changing attributes */
+	opts.class_id = TC_H_MAKE(1UL << 16, 2);
+
+	ret = bpf_tc_cls_change(fd, LO_IFINDEX, parent_id, &opts, &info.id);
+	if (CHECK_FAIL(ret < 0))
+		goto end;
+
+	ret = bpf_tc_cls_get_info(fd, LO_IFINDEX, parent_id, NULL, &info);
+	if (CHECK_FAIL(ret < 0))
+		goto end;
+
+	if (CHECK_FAIL(info.class_id != TC_H_MAKE(1UL << 16, 2)))
+		goto end;
+	if (CHECK_FAIL((info.bpf_flags & TCA_BPF_FLAG_ACT_DIRECT) != 1))
+		goto end;
+
+end:
+	ret = bpf_tc_cls_detach(LO_IFINDEX, parent_id, &id);
+	CHECK_FAIL(ret < 0);
+	return ret;
+}
+
+void test_test_tc_bpf(void)
+{
+	const char *file = "./test_tc_bpf_kern.o";
+	struct bpf_program *clsp;
+	struct bpf_object *obj;
+	int cls_fd, ret;
+
+	obj = bpf_object__open(file);
+	if (CHECK_FAIL(IS_ERR_OR_NULL(obj)))
+		return;
+
+	clsp = bpf_object__find_program_by_title(obj, "classifier");
+	if (CHECK_FAIL(IS_ERR_OR_NULL(clsp)))
+		goto end;
+
+	ret = bpf_object__load(obj);
+	if (CHECK_FAIL(ret < 0))
+		goto end;
+
+	cls_fd = bpf_program__fd(clsp);
+
+	system("tc qdisc del dev lo clsact");
+
+	ret = test_tc_cls_internal(cls_fd, BPF_TC_CLSACT_INGRESS);
+	if (CHECK_FAIL(ret < 0))
+		goto end;
+
+	if (CHECK_FAIL(system("tc qdisc del dev lo clsact")))
+		goto end;
+
+	ret = test_tc_cls_internal(cls_fd, BPF_TC_CLSACT_EGRESS);
+	if (CHECK_FAIL(ret < 0))
+		goto end;
+
+	CHECK_FAIL(system("tc qdisc del dev lo clsact"));
+
+end:
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c b/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c
new file mode 100644
index 000000000000..3dd40e21af8e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+// Dummy prog to test TC-BPF API
+
+SEC("classifier")
+int cls(struct __sk_buff *skb)
+{
+	return 0;
+}
-- 
2.30.2

