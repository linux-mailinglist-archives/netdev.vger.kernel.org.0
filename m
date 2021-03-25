Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0747349179
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhCYMDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbhCYMC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:02:58 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E9DC06174A;
        Thu, 25 Mar 2021 05:02:58 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so2615440pjc.2;
        Thu, 25 Mar 2021 05:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EBCc1b3VS8OAWVirBhTJFkz3T9KQdBDUNva6rSRKOyc=;
        b=YtdfuQmfquFeqs9/wkrr6hcvZcyGec5OWKtR/QYXwyGuDhleOgBluZI6q7jPcLbTec
         81XJdXmbvgR/v8mHTB3ihFAkkj5R90bk8hP4kDy9wevfIZ9lJYyV4qGZdrcbYDqU8Rx7
         2PCM0EvEZX3yUAywih94in7FiPB5YyZRXDxf7HNqjT5yKsX1DRc/VWoMocYMTCo4aQIM
         o/VpjKy09pPRXD3knn+oAEdBxy+L4J4aal/YPHF4kJPz6OMFPqoe0YkWPDOSSlfb1z6N
         jGWus99jdg9EVHrBP7ZZ1ep8YUh00CuQ0GiZ7yyoONk+ZgabAGkwrLe5oxdkUH6HDXi0
         ZTdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EBCc1b3VS8OAWVirBhTJFkz3T9KQdBDUNva6rSRKOyc=;
        b=Gdyl8Nbgl42KWTxCMPfOgTJJW4CuPWDyj1OSv4Yr4sa9M+8QWU1TPZWpqmlcfbaiXr
         JyaB/2jTUsVDHE5ZVGjmQ2OYJrZfdqQepGTlqiYfTuDnLNHyS1yHJ2Dg6UIWHm98Q4A/
         nGJuUwYzOaS96d2gobET8I7GUqZ9TvP93MoEL1T5pb++ejsnhsfUdDArS3Rr/Mg7ueg4
         5ffwLitC1NqnpIHf3wJFtayZhpBFCY6+4hq5zcoV3e4YUlX/kIYF6rSQILKvGiH68Emy
         Xm15AmYKMm3nrig+dASecU0ZbhecBeoGqBoQIayTYBJFIJHHUsjq6lKx3Raak+y4hJ6G
         GA2A==
X-Gm-Message-State: AOAM533hm7T0wFDY41MBrPusrQR1VtwarwnbcnKKJBQN8Wqie2J8rzFh
        JLx8MwOn7cOCiaAQWnEw/tEJMFvh4jDiUw==
X-Google-Smtp-Source: ABdhPJzRLzxXur1jJPtFOouZ41pHnvy6ZvO1lbd0T3GjZTi0VRpCQW29ZcHvSTnOsYMUx4wzuFRn0g==
X-Received: by 2002:a17:90a:5b11:: with SMTP id o17mr8909425pji.32.1616673777368;
        Thu, 25 Mar 2021 05:02:57 -0700 (PDT)
Received: from localhost ([112.79.237.176])
        by smtp.gmail.com with ESMTPSA id y24sm5718750pfn.213.2021.03.25.05.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 05:02:57 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     brouer@redhat.com, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 5/5] libbpf: add selftests for TC-BPF API
Date:   Thu, 25 Mar 2021 17:30:03 +0530
Message-Id: <20210325120020.236504-6-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325120020.236504-1-memxor@gmail.com>
References: <20210325120020.236504-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds some basic tests for the low level bpf_tc_* API and its
bpf_program__attach_tc_* wrapper on top.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../selftests/bpf/prog_tests/test_tc_bpf.c    | 261 ++++++++++++++++++
 .../selftests/bpf/progs/test_tc_bpf_kern.c    |  18 ++
 2 files changed, 279 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c b/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
new file mode 100644
index 000000000000..8bab56b4dea0
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
@@ -0,0 +1,261 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <linux/err.h>
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
+	struct bpf_tc_cls_attach_id id = {};
+	struct bpf_tc_cls_info info = {};
+	int ret;
+	DECLARE_LIBBPF_OPTS(bpf_tc_cls_opts, opts, .handle = 1, .priority = 10,
+			    .class_id = TC_H_MAKE(1UL << 16, 1),
+			    .chain_index = 5);
+
+	ret = bpf_tc_cls_attach_dev(fd, LO_IFINDEX, parent_id, ETH_P_IP, &opts,
+				    &id);
+	if (CHECK_FAIL(ret < 0))
+		return ret;
+
+	ret = bpf_tc_cls_get_info_dev(fd, LO_IFINDEX, parent_id, ETH_P_IP, NULL,
+				      &info);
+	if (CHECK_FAIL(ret < 0))
+		goto end;
+
+	ret = -1;
+
+	if (CHECK_FAIL(info.id.ifindex != id.ifindex) ||
+	    CHECK_FAIL(info.id.parent_id != id.parent_id) ||
+	    CHECK_FAIL(info.id.handle != id.handle) ||
+	    CHECK_FAIL(info.id.protocol != id.protocol) ||
+	    CHECK_FAIL(info.id.chain_index != id.chain_index) ||
+	    CHECK_FAIL(info.id.priority != id.priority) ||
+	    CHECK_FAIL(info.id.ifindex != LO_IFINDEX) ||
+	    CHECK_FAIL(info.id.parent_id != parent_id) ||
+	    CHECK_FAIL(info.id.handle != 1) ||
+	    CHECK_FAIL(info.id.priority != 10) ||
+	    CHECK_FAIL(info.id.protocol != ETH_P_IP) ||
+	    CHECK_FAIL(info.class_id != TC_H_MAKE(1UL << 16, 1)) ||
+	    CHECK_FAIL(info.id.chain_index != 5))
+		goto end;
+
+	opts.direct_action = true;
+	ret = bpf_tc_cls_replace_dev(fd, id.ifindex, id.parent_id, id.protocol,
+				     &opts, &id);
+	if (CHECK_FAIL(ret < 0))
+		return ret;
+
+end:;
+	ret = bpf_tc_cls_detach_dev(&id);
+	CHECK_FAIL(ret < 0);
+	return ret;
+}
+
+static int test_tc_cls(struct bpf_program *prog, __u32 parent_id)
+{
+	struct bpf_tc_cls_info info = {};
+	struct bpf_link *link;
+	int ret;
+	DECLARE_LIBBPF_OPTS(bpf_tc_cls_opts, opts, .priority = 10, .handle = 1,
+			    .class_id = TC_H_MAKE(1UL << 16, 1));
+
+	link = bpf_program__attach_tc_cls_dev(prog, LO_IFINDEX, parent_id,
+					      ETH_P_ALL, &opts);
+	if (CHECK_FAIL(IS_ERR_OR_NULL(link)))
+		return PTR_ERR(link);
+
+	ret = bpf_tc_cls_get_info_dev(bpf_program__fd(prog), LO_IFINDEX,
+				      parent_id, ETH_P_ALL, NULL, &info);
+	if (CHECK_FAIL(ret < 0))
+		goto end;
+
+	ret = -1;
+
+	if (CHECK_FAIL(info.id.ifindex != LO_IFINDEX) ||
+	    CHECK_FAIL(info.id.handle != 1) ||
+	    CHECK_FAIL(info.id.priority != 10) ||
+	    CHECK_FAIL(info.id.protocol != ETH_P_ALL) ||
+	    CHECK_FAIL(info.class_id != TC_H_MAKE(1UL << 16, 1)))
+		goto end;
+
+	/* Demonstrate changing attributes (e.g. to direct action) */
+	opts.class_id = TC_H_MAKE(1UL << 16, 2);
+	opts.direct_action = true;
+
+	/* Disconnect as we drop to the lower level API, which invalidates the
+	 * link.
+	 */
+	bpf_link__disconnect(link);
+
+	ret = bpf_tc_cls_change_dev(bpf_program__fd(prog), info.id.ifindex,
+				    info.id.parent_id, info.id.protocol, &opts,
+				    &info.id);
+	if (CHECK_FAIL(ret < 0))
+		goto end;
+
+	ret = bpf_tc_cls_get_info_dev(bpf_program__fd(prog), info.id.ifindex,
+				      info.id.parent_id, info.id.protocol, NULL,
+				      &info);
+	if (CHECK_FAIL(ret < 0))
+		goto end;
+
+	ret = -1;
+
+	if (CHECK_FAIL(info.class_id != TC_H_MAKE(1UL << 16, 2)))
+		goto end;
+	if (CHECK_FAIL((info.bpf_flags & TCA_BPF_FLAG_ACT_DIRECT) != 1))
+		goto end;
+
+	ret = bpf_tc_cls_detach_dev(&info.id);
+	if (CHECK_FAIL(ret < 0))
+		goto end;
+
+end:
+	ret = bpf_link__destroy(link);
+	CHECK_FAIL(ret < 0);
+	return ret;
+}
+
+static int test_tc_act_internal(int fd)
+{
+	struct bpf_tc_act_info info = {};
+	__u32 index = 0;
+	int ret;
+	DECLARE_LIBBPF_OPTS(bpf_tc_act_opts, opts, 0);
+
+	ret = bpf_tc_act_attach(fd, &opts, &index);
+	if (CHECK_FAIL(ret < 0 || !index))
+		goto end;
+
+	index = 0;
+	ret = bpf_tc_act_attach(fd, &opts, &index);
+	if (CHECK_FAIL(ret < 0 || !index))
+		goto end;
+
+	opts.index = 3;
+	index = 0;
+	ret = bpf_tc_act_attach(fd, &opts, &index);
+	if (CHECK_FAIL(ret < 0 || !index))
+		goto end;
+
+	index = 0;
+	ret = bpf_tc_act_replace(fd, &opts, &index);
+	if (CHECK_FAIL(ret < 0 || !index))
+		goto end;
+
+	opts.index = 1;
+	ret = bpf_tc_act_attach(fd, &opts, &index);
+	if (CHECK_FAIL(!ret || ret != -EEXIST)) {
+		ret = -1;
+		goto end;
+	}
+
+	for (int i = 0; i < 3; i++) {
+		memset(&info, 0, sizeof(info));
+
+		ret = bpf_tc_act_get_info(fd, &info);
+		if (CHECK_FAIL(ret < 0 && ret != -ESRCH))
+			goto end;
+
+		if (CHECK_FAIL(ret == -ESRCH))
+			goto end;
+
+		if (CHECK_FAIL(info.refcnt != 1))
+			goto end;
+
+		ret = bpf_tc_act_detach(info.index);
+		if (CHECK_FAIL(ret < 0))
+			goto end;
+	}
+
+	CHECK_FAIL(bpf_tc_act_get_info(fd, &info) == -ESRCH);
+
+end:
+	ret = bpf_tc_act_detach(0);
+	CHECK_FAIL(ret < 0);
+	return ret;
+}
+
+static int test_tc_act(struct bpf_program *prog)
+{
+	struct bpf_tc_act_info info = {};
+	struct bpf_link *link;
+	int ret;
+	DECLARE_LIBBPF_OPTS(bpf_tc_act_opts, opts, .index = 42);
+
+	link = bpf_program__attach_tc_act(prog, &opts);
+	if (CHECK_FAIL(IS_ERR_OR_NULL(link)))
+		return PTR_ERR(link);
+
+	ret = bpf_tc_act_get_info(bpf_program__fd(prog), &info);
+	if (CHECK_FAIL(ret < 0))
+		goto end;
+
+	if (CHECK_FAIL(info.index != 42))
+		goto end;
+
+end:
+	ret = bpf_link__destroy(link);
+	CHECK_FAIL(ret < 0);
+	return ret;
+}
+
+void test_test_tc_bpf(void)
+{
+	const char *file = "./test_tc_bpf_kern.o";
+	int cls_fd, act_fd, ret;
+	struct bpf_program *clsp, *actp;
+	struct bpf_object *obj;
+
+	obj = bpf_object__open(file);
+	if (CHECK_FAIL(IS_ERR_OR_NULL(obj)))
+		return;
+
+	clsp = bpf_object__find_program_by_title(obj, "classifier");
+	if (CHECK_FAIL(IS_ERR_OR_NULL(clsp)))
+		goto end;
+
+	actp = bpf_object__find_program_by_title(obj, "action");
+	if (CHECK_FAIL(IS_ERR_OR_NULL(clsp)))
+		goto end;
+
+	ret = bpf_object__load(obj);
+	if (CHECK_FAIL(ret < 0))
+		goto end;
+
+	cls_fd = bpf_program__fd(clsp);
+	act_fd = bpf_program__fd(actp);
+
+	if (CHECK_FAIL(system("tc qdisc add dev lo clsact")))
+		goto end;
+
+	ret = test_tc_cls_internal(cls_fd, BPF_TC_CLSACT_INGRESS);
+	if (CHECK_FAIL(ret < 0))
+		goto end;
+
+	ret = test_tc_cls(clsp, BPF_TC_CLSACT_EGRESS);
+	if (CHECK_FAIL(ret < 0))
+		goto end;
+
+	system("tc qdisc del dev lo clsact");
+
+	ret = test_tc_act_internal(act_fd);
+	if (CHECK_FAIL(ret < 0))
+		goto end;
+
+	ret = test_tc_act(actp);
+	if (CHECK_FAIL(ret < 0))
+		goto end;
+
+end:
+	bpf_object__close(obj);
+	return;
+}
diff --git a/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c b/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c
new file mode 100644
index 000000000000..d39644ea0fd7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+// Dummy prog to test tc_bpf API
+
+SEC("classifier")
+int cls(struct __sk_buff *skb)
+{
+	return 0;
+}
+
+SEC("action")
+int act(struct __sk_buff *skb)
+{
+	return 0;
+}
-- 
2.30.2

