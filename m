Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7980E366051
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 21:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233791AbhDTTi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 15:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbhDTTi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 15:38:27 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B823C06138A;
        Tue, 20 Apr 2021 12:37:55 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id y32so27374032pga.11;
        Tue, 20 Apr 2021 12:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ggSnWKXUJLE6iHcOs0eUWOJm8Vh5SmESAPT+YojILTs=;
        b=ZkUENDZH0Dfzhu3yQhk2ckxI79uQ/YN8MF/ZzdjvRJYty1qkQSl+5AWbCMoeIiPYzJ
         xa53ShKa4XGlecfYUHuXLEOXyDAead5kghszWVKO6DYH0wT0O7oSD3uudMwQhgpQ6t7x
         YZ2JRGwGjfw9p5iURmNzh+fUNF4XZNdRY6imEjYA+jYG40Nd1QbgjqarXa4MWjJkKGr2
         73pbGVvacPqraYGSmn9S2n4oRPUzw0NQ+9WUEDLu2Oo+oSW6S7kAJ26GHkstKIbqu4ac
         dIaNWgM69ht4UuBWBJJQELSEvq5kMuadquT04dpQlTS4/JZI8bPeFAUFekW0v5ixeuXt
         y6NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ggSnWKXUJLE6iHcOs0eUWOJm8Vh5SmESAPT+YojILTs=;
        b=RX7+hQuvKF9rOosO102EX/Ium9nWNE8GbbWoxsVw5Sfu4joLUTyIAJbc0Ti2M7vN/O
         KuKrw02Wps4FRQLR6wCGBMZJgYcd3D19HqXJIJPSkCy8vVMQAxqoZpgHDFe/x+0f38Lr
         9gyv4RR9CYrKudzcVLeP90aw7LgYmLhSCN9PO2irD+gSV97hmMz9tpJj/gpyA6FAh7KA
         TZLo0zn6pvOGZgDSiAI856B3ujUxOiZH0RzTK6d8h7nXJM3gBH8xb4OIoGoUzw5TSKpN
         8plZhoFfFlJ31oTT+4MFN7ncNZra4U4Tb1oC8DHrjCref9Kq4hE+aRAMrY5bp0sOFtMk
         sOSQ==
X-Gm-Message-State: AOAM532mBhRPGO44S0d0i1+7xNQgKtV4wCWABcXTmnqBqlEkKWNlO6kU
        9WWud50tEFuuWlGgKcn+xiCfi7MFsEw8DA==
X-Google-Smtp-Source: ABdhPJz1Vyx87oJ0VKjUuP7ZO7nPIrrWmgbTjs1OprdgRfIjMp9RwNjF1walaOY49VihKz2QUFy/sQ==
X-Received: by 2002:a62:4d86:0:b029:252:c889:2dd8 with SMTP id a128-20020a624d860000b0290252c8892dd8mr27264030pfb.41.1618947474750;
        Tue, 20 Apr 2021 12:37:54 -0700 (PDT)
Received: from localhost ([112.79.227.195])
        by smtp.gmail.com with ESMTPSA id p22sm3063937pjg.39.2021.04.20.12.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 12:37:54 -0700 (PDT)
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
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 3/3] libbpf: add selftests for TC-BPF API
Date:   Wed, 21 Apr 2021 01:07:40 +0530
Message-Id: <20210420193740.124285-4-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420193740.124285-1-memxor@gmail.com>
References: <20210420193740.124285-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds some basic tests for the low level bpf_tc_* API.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../selftests/bpf/prog_tests/test_tc_bpf.c    | 169 ++++++++++++++++++
 .../selftests/bpf/progs/test_tc_bpf_kern.c    |  12 ++
 2 files changed, 181 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c b/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
new file mode 100644
index 000000000000..563a3944553c
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
@@ -0,0 +1,169 @@
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
+static int test_tc_internal(int fd, __u32 parent_id)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 10,
+			    .class_id = TC_H_MAKE(1UL << 16, 1));
+	struct bpf_tc_attach_id id = {};
+	struct bpf_tc_info info = {};
+	int ret;
+
+	ret = bpf_tc_attach(fd, LO_IFINDEX, parent_id, &opts, &id);
+	if (!ASSERT_EQ(ret, 0, "bpf_tc_attach"))
+		return ret;
+
+	ret = bpf_tc_get_info(LO_IFINDEX, parent_id, &id, &info);
+	if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
+		goto end;
+
+	if (!ASSERT_EQ(info.id.handle, id.handle, "handle mismatch") ||
+	    !ASSERT_EQ(info.id.priority, id.priority, "priority mismatch") ||
+	    !ASSERT_EQ(info.id.handle, 1, "handle incorrect") ||
+	    !ASSERT_EQ(info.chain_index, 0, "chain_index incorrect") ||
+	    !ASSERT_EQ(info.id.priority, 10, "priority incorrect") ||
+	    !ASSERT_EQ(info.class_id, TC_H_MAKE(1UL << 16, 1),
+		       "class_id incorrect") ||
+	    !ASSERT_EQ(info.protocol, ETH_P_ALL, "protocol incorrect"))
+		goto end;
+
+	opts.replace = true;
+	ret = bpf_tc_attach(fd, LO_IFINDEX, parent_id, &opts, &id);
+	if (!ASSERT_EQ(ret, 0, "bpf_tc_attach in replace mode"))
+		return ret;
+
+	/* Demonstrate changing attributes */
+	opts.class_id = TC_H_MAKE(1UL << 16, 2);
+
+	ret = bpf_tc_attach(fd, LO_IFINDEX, parent_id, &opts, &id);
+	if (!ASSERT_EQ(ret, 0, "bpf_tc attach in replace mode"))
+		goto end;
+
+	ret = bpf_tc_get_info(LO_IFINDEX, parent_id, &id, &info);
+	if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
+		goto end;
+
+	if (!ASSERT_EQ(info.class_id, TC_H_MAKE(1UL << 16, 2),
+		       "class_id incorrect after replace"))
+		goto end;
+	if (!ASSERT_EQ(info.bpf_flags & TCA_BPF_FLAG_ACT_DIRECT, 1,
+		       "direct action mode not set"))
+		goto end;
+
+end:
+	ret = bpf_tc_detach(LO_IFINDEX, parent_id, &id);
+	ASSERT_EQ(ret, 0, "detach failed");
+	return ret;
+}
+
+int test_tc_info(int fd)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 10,
+			    .class_id = TC_H_MAKE(1UL << 16, 1));
+	struct bpf_tc_attach_id id = {}, old;
+	struct bpf_tc_info info = {};
+	int ret;
+
+	ret = bpf_tc_attach(fd, LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &opts, &id);
+	if (!ASSERT_EQ(ret, 0, "bpf_tc_attach"))
+		return ret;
+	old = id;
+
+	ret = bpf_tc_get_info(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &id, &info);
+	if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
+		goto end_old;
+
+	if (!ASSERT_EQ(info.id.handle, id.handle, "handle mismatch") ||
+	    !ASSERT_EQ(info.id.priority, id.priority, "priority mismatch") ||
+	    !ASSERT_EQ(info.id.handle, 1, "handle incorrect") ||
+	    !ASSERT_EQ(info.chain_index, 0, "chain_index incorrect") ||
+	    !ASSERT_EQ(info.id.priority, 10, "priority incorrect") ||
+	    !ASSERT_EQ(info.class_id, TC_H_MAKE(1UL << 16, 1),
+		       "class_id incorrect") ||
+	    !ASSERT_EQ(info.protocol, ETH_P_ALL, "protocol incorrect"))
+		goto end_old;
+
+	/* choose a priority */
+	opts.priority = 0;
+	ret = bpf_tc_attach(fd, LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &opts, &id);
+	if (!ASSERT_EQ(ret, 0, "bpf_tc_attach"))
+		goto end_old;
+
+	ret = bpf_tc_get_info(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &id, &info);
+	if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
+		goto end;
+
+	if (!ASSERT_NEQ(id.priority, old.priority, "filter priority mismatch"))
+		goto end;
+	if (!ASSERT_EQ(info.id.priority, id.priority, "priority mismatch"))
+		goto end;
+
+end:
+	ret = bpf_tc_detach(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &id);
+	ASSERT_EQ(ret, 0, "detach failed");
+end_old:
+	ret = bpf_tc_detach(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &old);
+	ASSERT_EQ(ret, 0, "detach failed");
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
+	if (!ASSERT_OK_PTR(obj, "bpf_object__open"))
+		return;
+
+	clsp = bpf_object__find_program_by_title(obj, "classifier");
+	if (!ASSERT_OK_PTR(clsp, "bpf_object__find_program_by_title"))
+		goto end;
+
+	ret = bpf_object__load(obj);
+	if (!ASSERT_EQ(ret, 0, "bpf_object__load"))
+		goto end;
+
+	cls_fd = bpf_program__fd(clsp);
+
+	system("tc qdisc del dev lo clsact");
+
+	ret = test_tc_internal(cls_fd, BPF_TC_CLSACT_INGRESS);
+	if (!ASSERT_EQ(ret, 0, "test_tc_internal INGRESS"))
+		goto end;
+
+	if (!ASSERT_EQ(system("tc qdisc del dev lo clsact"), 0,
+		       "clsact qdisc delete failed"))
+		goto end;
+
+	ret = test_tc_info(cls_fd);
+	if (!ASSERT_EQ(ret, 0, "test_tc_info"))
+		goto end;
+
+	if (!ASSERT_EQ(system("tc qdisc del dev lo clsact"), 0,
+		       "clsact qdisc delete failed"))
+		goto end;
+
+	ret = test_tc_internal(cls_fd, BPF_TC_CLSACT_EGRESS);
+	if (!ASSERT_EQ(ret, 0, "test_tc_internal EGRESS"))
+		goto end;
+
+	ASSERT_EQ(system("tc qdisc del dev lo clsact"), 0,
+		  "clsact qdisc delete failed");
+
+end:
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c b/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c
new file mode 100644
index 000000000000..18a3a7ed924a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+/* Dummy prog to test TC-BPF API */
+
+SEC("classifier")
+int cls(struct __sk_buff *skb)
+{
+	return 0;
+}
-- 
2.30.2

