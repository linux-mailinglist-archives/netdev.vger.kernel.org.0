Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65DC369599
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 17:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243031AbhDWPG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 11:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242953AbhDWPGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 11:06:55 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984F6C061574;
        Fri, 23 Apr 2021 08:06:15 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d124so34216774pfa.13;
        Fri, 23 Apr 2021 08:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LM2G1xdk+VigTZmhGItgIeRSCgpXfSuUVttMoYD5OTo=;
        b=H6zRX90b9lSNhF5uDvvwPSzKtL56aj1hk3smzk5MI3Wo3n3Nf6voQAClmkzvQvzRrV
         sH8/iW5RVIqBnB3iFK/xz6h4LqbOsnoSOH+AqCYMmmxgluWAo719qdPdmeIGiyQwYre8
         W57E+Y/FgrsmFiO+8tcS3qV5Vlk51UM/56gI4npPEut3wtQsjKBwn5OKuQYy7IYsHaVI
         2fV5RwIbfZhuAdG1XiJzzo8ja3xYfApvtPiMKcBmbA3JBXglCwqldw3jRYPJ7KNOeGI6
         3Cmw/xmJhOwS4+dW0JC4AaWPXx9/JCxMus1bhvdzIVQjtaLP9q33SJA2jiVAt+8X7IUv
         keJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LM2G1xdk+VigTZmhGItgIeRSCgpXfSuUVttMoYD5OTo=;
        b=m4GTEG3eY5KicqF7s/qxh/kKgruEeay3fz+xz8JEDnbZX03pRhP5QO2FUDWauIh7YR
         8PmJU4YvDWu/mWPI0RhPzlQvEsZCtUCFI7TXz75mDCp1Ub5cdCKYF9hc04s6NADOpxFt
         jZRFHm7glljEIYFUx7tslDaMR27QVgDZiBBF8p9qux+34Qx+GjHdltnvLBnWeUfgSmA6
         2Mr+z7hxDrVSU9LvH3phhwiuZRFRdB44vW3RRcnCr+ODpy4ayMAhqIXsxlgXBHFr0Xlv
         Qy1eQ1f8yp/7Ur9seqgN0G73543Gqdpldp84DkCT4qf6oD0GL4c6L5lrLxG9QQj1ubRx
         oBJw==
X-Gm-Message-State: AOAM5315JuaCPR1ycwxG2ho6JOBIfXUbPTWkjvtgOPtGemajufx2LYVh
        CCh+9TDGl1J+pI5kz8mtbS9KtMIMACd55w==
X-Google-Smtp-Source: ABdhPJxhOlBGv0zZEKLNKhYjIa/P3Kkz1s3ekhcMY1y+wy0vwxpgtsdUICzjLbOFGjdyVy6Np6ngtg==
X-Received: by 2002:a63:575b:: with SMTP id h27mr4322501pgm.180.1619190374888;
        Fri, 23 Apr 2021 08:06:14 -0700 (PDT)
Received: from localhost ([112.79.255.145])
        by smtp.gmail.com with ESMTPSA id m9sm5201084pgt.65.2021.04.23.08.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 08:06:14 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 3/3] libbpf: add selftests for TC-BPF API
Date:   Fri, 23 Apr 2021 20:36:00 +0530
Message-Id: <20210423150600.498490-4-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423150600.498490-1-memxor@gmail.com>
References: <20210423150600.498490-1-memxor@gmail.com>
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
 .../testing/selftests/bpf/prog_tests/tc_bpf.c | 204 ++++++++++++++++++
 .../testing/selftests/bpf/progs/test_tc_bpf.c |  12 ++
 2 files changed, 216 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf.c

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_bpf.c b/tools/testing/selftests/bpf/prog_tests/tc_bpf.c
new file mode 100644
index 000000000000..47505b92e50a
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/tc_bpf.c
@@ -0,0 +1,204 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include <linux/pkt_cls.h>
+
+#include "test_tc_bpf.skel.h"
+
+#define LO_IFINDEX 1
+
+static const __u32 tcm_parent[2] = {
+	[BPF_TC_INGRESS] = TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS),
+	[BPF_TC_EGRESS] = TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS),
+};
+
+static int test_tc_internal(struct bpf_tc_ctx *ctx, int fd,
+			    enum bpf_tc_attach_point parent)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 10);
+	struct bpf_prog_info info = {};
+	__u32 info_len = sizeof(info);
+	int ret;
+
+	ret = bpf_obj_get_info_by_fd(fd, &info, &info_len);
+	if (!ASSERT_EQ(ret, 0, "bpf_obj_get_info_by_fd"))
+		return ret;
+
+	ret = bpf_tc_attach(ctx, fd, &opts);
+	if (!ASSERT_EQ(ret, 0, "bpf_tc_attach"))
+		return ret;
+
+	if (!ASSERT_EQ(opts.handle, 1, "handle set") ||
+	    !ASSERT_EQ(opts.priority, 10, "priority set") ||
+	    !ASSERT_EQ(opts.parent, tcm_parent[parent], "parent set") ||
+	    !ASSERT_NEQ(opts.prog_id, 0, "prog_id set"))
+		goto end;
+
+	opts.prog_id = 0;
+	ret = bpf_tc_query(ctx, &opts);
+	if (!ASSERT_EQ(ret, 0, "bpf_tc_query"))
+		goto end;
+
+	if (!ASSERT_NEQ(opts.prog_id, 0, "prog_id set") ||
+	    !ASSERT_EQ(info.id, opts.prog_id, "prog_id matching"))
+		goto end;
+
+	/* Atomic replace */
+	opts.replace = true;
+	opts.parent = opts.prog_id = 0;
+	ret = bpf_tc_attach(ctx, fd, &opts);
+	if (!ASSERT_EQ(ret, 0, "bpf_tc_attach replace mode"))
+		return ret;
+	opts.replace = false;
+
+end:
+	opts.prog_id = 0;
+	ret = bpf_tc_detach(ctx, &opts);
+	ASSERT_EQ(ret, 0, "bpf_tc_detach");
+	return ret;
+}
+
+int test_tc_invalid(struct bpf_tc_ctx *ctx, int fd)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 10,
+			    .parent = tcm_parent[BPF_TC_INGRESS]);
+	struct bpf_tc_ctx *inv_ctx;
+	int ret, saved_errno;
+
+	inv_ctx = bpf_tc_ctx_init(0, BPF_TC_INGRESS, NULL);
+	saved_errno = errno;
+	if (!ASSERT_EQ(inv_ctx, NULL, "bpf_tc_ctx_init invalid ifindex = 0"))
+		return -EINVAL;
+
+	ASSERT_EQ(saved_errno, EINVAL, "errno");
+
+	inv_ctx = bpf_tc_ctx_init(LO_IFINDEX, 0xdeadc0de, NULL);
+	saved_errno = errno;
+	if (!ASSERT_EQ(inv_ctx, NULL,
+		       "bpf_tc_ctx_init invalid parent >= _BPF_TC_PARENT_MAX"))
+		return -EINVAL;
+
+	ASSERT_EQ(saved_errno, EINVAL, "errno");
+
+	ret = bpf_tc_ctx_destroy(NULL);
+	if (!ASSERT_EQ(ret, 0, "bpf_tc_ctx_destroy ctx = NULL"))
+		return -EINVAL;
+
+	ret = bpf_tc_detach(NULL, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid ctx = NULL"))
+		return -EINVAL;
+
+	ret = bpf_tc_detach(ctx, NULL);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid opts = NULL"))
+		return -EINVAL;
+
+	ret = bpf_tc_query(NULL, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid ctx = NULL"))
+		return -EINVAL;
+
+	ret = bpf_tc_query(ctx, NULL);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid opts = NULL"))
+		return -EINVAL;
+
+	opts.replace = true;
+	ret = bpf_tc_detach(ctx, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid replace set"))
+		return -EINVAL;
+	ret = bpf_tc_query(ctx, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid replace set"))
+		return -EINVAL;
+	opts.replace = false;
+
+	opts.prog_id = 42;
+	ret = bpf_tc_detach(ctx, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid prog_id set"))
+		return -EINVAL;
+	ret = bpf_tc_query(ctx, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid prog_id set"))
+		return -EINVAL;
+	opts.prog_id = 0;
+
+	opts.handle = 0;
+	ret = bpf_tc_detach(ctx, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid handle unset"))
+		return -EINVAL;
+	ret = bpf_tc_query(ctx, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid handle unset"))
+		return -EINVAL;
+	opts.handle = 1;
+
+	opts.priority = 0;
+	ret = bpf_tc_detach(ctx, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid priority unset"))
+		return -EINVAL;
+	ret = bpf_tc_query(ctx, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid priority unset"))
+		return -EINVAL;
+	opts.priority = 10;
+
+	opts.parent = 0;
+	ret = bpf_tc_detach(ctx, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid parent unset"))
+		return -EINVAL;
+	ret = bpf_tc_query(ctx, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid parent unset"))
+		return -EINVAL;
+
+	ret = bpf_tc_attach(NULL, fd, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid ctx = NULL"))
+		return -EINVAL;
+
+	ret = bpf_tc_attach(ctx, -1, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid fd < 0"))
+		return -EINVAL;
+
+	ret = bpf_tc_attach(ctx, fd, NULL);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid opts = NULL"))
+		return -EINVAL;
+
+	opts.prog_id = 42;
+	ret = bpf_tc_attach(ctx, fd, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid prog_id set"))
+		return -EINVAL;
+	opts.prog_id = 0;
+
+	return 0;
+}
+
+void test_tc_bpf(void)
+{
+	struct bpf_tc_ctx *ctx_ing = NULL, *ctx_eg = NULL;
+	struct test_tc_bpf *skel = NULL;
+	int cls_fd, ret;
+
+	skel = test_tc_bpf__open_and_load();
+	if (!ASSERT_NEQ(skel, NULL, "test_tc_bpf skeleton"))
+		goto end;
+
+	cls_fd = bpf_program__fd(skel->progs.cls);
+
+	ctx_ing = bpf_tc_ctx_init(LO_IFINDEX, BPF_TC_INGRESS, NULL);
+	if (!ASSERT_NEQ(ctx_ing, NULL, "bpf_tc_ctx_init(BPF_TC_INGRESS)"))
+		goto end;
+
+	ctx_eg = bpf_tc_ctx_init(LO_IFINDEX, BPF_TC_EGRESS, NULL);
+	if (!ASSERT_NEQ(ctx_eg, NULL, "bpf_tc_ctx_init(BPF_TC_EGRESS)"))
+		goto end;
+
+	ret = test_tc_internal(ctx_ing, cls_fd, BPF_TC_INGRESS);
+	if (!ASSERT_EQ(ret, 0, "test_tc_internal ingress"))
+		goto end;
+
+	ret = test_tc_internal(ctx_eg, cls_fd, BPF_TC_EGRESS);
+	if (!ASSERT_EQ(ret, 0, "test_tc_internal egress"))
+		goto end;
+
+	ret = test_tc_invalid(ctx_ing, cls_fd);
+	if (!ASSERT_EQ(ret, 0, "test_tc_invalid"))
+		goto end;
+
+end:
+	bpf_tc_ctx_destroy(ctx_eg);
+	bpf_tc_ctx_destroy(ctx_ing);
+	test_tc_bpf__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_tc_bpf.c b/tools/testing/selftests/bpf/progs/test_tc_bpf.c
new file mode 100644
index 000000000000..18a3a7ed924a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_tc_bpf.c
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

