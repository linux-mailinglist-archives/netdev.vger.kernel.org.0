Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA31436DCFD
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 18:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240929AbhD1Q1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 12:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240811AbhD1Q04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 12:26:56 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CDAC061573;
        Wed, 28 Apr 2021 09:26:10 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id p17so7234898plf.12;
        Wed, 28 Apr 2021 09:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jGBOmJj4JIBaLUD9Oaj2UB4kWD0yjcksRfAhWdzA1t8=;
        b=rC3ugNo3rdDVNG2qCBT44LX93vameBWS36ItWpdWSMLKmS1AhpIa1QJtag51Jrsbe8
         mstO0PBbzknmB9zQzw9sZC4PX0wPPSjq7fRmu2Mt7RanzugajGKGBdbnrVCbvtZYtvjT
         JMvAVIiPYw9/axrfwVYuBCwcuDFsP2Ho67olRulz6WNF3T4dp7KkkuIl/WTgh/w9h4fv
         X5SZiQ8ZLy3VK+xFO18Zkt2vfUXcw9hkteMwdEeryhooA7+15eNBcmVeGz+FHF/8Zl/p
         NDDWYKFIPhQVhvD4JQxUzqXNcLS2mRmKc3AqR1KSpYodXrvN55ZbQtkQDwIc7EJkxlgc
         yGEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jGBOmJj4JIBaLUD9Oaj2UB4kWD0yjcksRfAhWdzA1t8=;
        b=KXyEE/fCzcRAeLPb1UpxUCx5la53PI96WFzCgA1NBVNcESSeqzAEav4FVc4Jr5bUfN
         D40CqhkxYUsW8yO+1/nGInuv6sDCySNQtUHixM4DRkWmwwlFxodm3RE3nrmker2K64y7
         NdyXw1wzX8VQAqNk6jxnv4LNvw5ungT2TYGSanGrIkGYBmw6ZbD7Os74EtyHu5MUcTm+
         SdYZneixav8VCaCOyoKmRgn11hXO4SyDf7lIeFQ0FLXxwxuGhXjpcNB/RQnZZp7iDhcn
         ZTG7kdbVjn2GfovKxv5IYQtXBgO7PTo2gsLmLxIYyh4o6M5lBZ8DZ+LIqxIZk3i375sc
         khsQ==
X-Gm-Message-State: AOAM530cSpU7mYfjFHjzI4j6Y1WvnlUpzPIrSOPCAEIU5n77Y3NbPiq2
        BUyIs51BcLKB4hzer62EuEIFt/lYxFuaFQ==
X-Google-Smtp-Source: ABdhPJz7pBl3glrXbfwwbxNL9LKj23gqjkB7dkeIW35oPWaKGiHQH3OtCK1IfipAx38FuX2/t3WEZQ==
X-Received: by 2002:a17:902:8b81:b029:eb:5a4:9cae with SMTP id ay1-20020a1709028b81b02900eb05a49caemr31382137plb.13.1619627169484;
        Wed, 28 Apr 2021 09:26:09 -0700 (PDT)
Received: from localhost ([112.79.247.72])
        by smtp.gmail.com with ESMTPSA id lk6sm5616546pjb.36.2021.04.28.09.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 09:26:09 -0700 (PDT)
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
        Shaun Crampton <shaun@tigera.io>, netdev@vger.kernel.org
Subject: [PATCH bpf-next v5 3/3] libbpf: add selftests for TC-BPF API
Date:   Wed, 28 Apr 2021 21:55:53 +0530
Message-Id: <20210428162553.719588-4-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428162553.719588-1-memxor@gmail.com>
References: <20210428162553.719588-1-memxor@gmail.com>
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
 .../testing/selftests/bpf/prog_tests/tc_bpf.c | 467 ++++++++++++++++++
 .../testing/selftests/bpf/progs/test_tc_bpf.c |  12 +
 2 files changed, 479 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf.c

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_bpf.c b/tools/testing/selftests/bpf/prog_tests/tc_bpf.c
new file mode 100644
index 000000000000..40441f4e23e2
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/tc_bpf.c
@@ -0,0 +1,467 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include <linux/pkt_cls.h>
+
+#include "test_tc_bpf.skel.h"
+
+#define LO_IFINDEX 1
+
+static int test_tc_internal(const struct bpf_tc_hook *hook, int fd)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 1,
+			    .prog_fd = fd);
+	struct bpf_prog_info info = {};
+	int ret;
+
+	ret = bpf_obj_get_info_by_fd(fd, &info, &(__u32){sizeof(info)});
+	if (!ASSERT_OK(ret, "bpf_obj_get_info_by_fd"))
+		return ret;
+
+	ret = bpf_tc_attach(hook, &opts, 0);
+	if (!ASSERT_OK(ret, "bpf_tc_attach"))
+		return ret;
+
+	if (!ASSERT_EQ(opts.handle, 1, "handle set") ||
+	    !ASSERT_EQ(opts.priority, 1, "priority set") ||
+	    !ASSERT_EQ(opts.prog_id, info.id, "prog_id set"))
+		goto end;
+
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, info_opts, .prog_fd = fd);
+	ret = bpf_tc_query(hook, &info_opts);
+	if (!ASSERT_OK(ret, "bpf_tc_query"))
+		goto end;
+
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, info_opts2, .prog_id = info.id);
+	ret = bpf_tc_query(hook, &info_opts2);
+	if (!ASSERT_OK(ret, "bpf_tc_query"))
+		goto end;
+
+	if (!ASSERT_EQ(opts.handle, 1, "handle set") ||
+	    !ASSERT_EQ(opts.priority, 1, "priority set") ||
+	    !ASSERT_EQ(opts.prog_id, info.id, "prog_id set"))
+		goto end;
+
+	opts.prog_id = 0;
+	ret = bpf_tc_attach(hook, &opts, BPF_TC_F_REPLACE);
+	if (!ASSERT_OK(ret, "bpf_tc_attach replace mode"))
+		return ret;
+
+end:
+	opts.prog_fd = opts.prog_id = 0;
+	ret = bpf_tc_detach(hook, &opts);
+	ASSERT_OK(ret, "bpf_tc_detach");
+	return ret;
+}
+
+static int test_tc_bpf_api(struct bpf_tc_hook *hook, int fd)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 1);
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, attach_opts, .handle = 1, .priority = 1,
+			    .prog_fd = fd);
+	DECLARE_LIBBPF_OPTS(bpf_tc_hook, inv_hook, .attach_point = BPF_TC_INGRESS);
+	int ret;
+
+	ret = bpf_tc_hook_create(NULL, 0);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_create invalid hook = NULL"))
+		return -EINVAL;
+
+	ret = bpf_tc_hook_create(hook, 42);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_create invalid flags"))
+		return -EINVAL;
+	ret = bpf_tc_hook_destroy(NULL);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_destroy invalid hook = NULL"))
+		return -EINVAL;
+
+	/* hook ifindex = 0 */
+	ret = bpf_tc_hook_create(&inv_hook, 0);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_create invalid hook ifindex == 0"))
+		return -EINVAL;
+	ret = bpf_tc_hook_destroy(&inv_hook);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_destroy invalid hook ifindex == 0"))
+		return -EINVAL;
+	ret = bpf_tc_attach(&inv_hook, &attach_opts, 0);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid hook ifindex == 0"))
+		return -EINVAL;
+	ret = bpf_tc_detach(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid hook ifindex == 0"))
+		return -EINVAL;
+	ret = bpf_tc_query(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid hook ifindex == 0"))
+		return -EINVAL;
+
+	/* hook ifindex < 0 */
+	inv_hook.ifindex = -1;
+	ret = bpf_tc_hook_create(&inv_hook, 0);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_create invalid hook ifindex < 0"))
+		return -EINVAL;
+	ret = bpf_tc_hook_destroy(&inv_hook);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_destroy invalid hook ifindex < 0"))
+		return -EINVAL;
+	ret = bpf_tc_attach(&inv_hook, &attach_opts, 0);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid hook ifindex < 0"))
+		return -EINVAL;
+	ret = bpf_tc_detach(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid hook ifindex < 0"))
+		return -EINVAL;
+	ret = bpf_tc_query(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid hook ifindex < 0"))
+		return -EINVAL;
+	inv_hook.ifindex = LO_IFINDEX;
+
+	/* hook.attach_point invalid */
+	inv_hook.attach_point = 0xabcd;
+	ret = bpf_tc_hook_create(&inv_hook, 0);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_create invalid hook.attach_point"))
+		return -EINVAL;
+	ret = bpf_tc_hook_destroy(&inv_hook);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_destroy invalid hook.attach_point"))
+		return -EINVAL;
+	ret = bpf_tc_attach(&inv_hook, &attach_opts, 0);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid hook.attach_point"))
+		return -EINVAL;
+	ret = bpf_tc_detach(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid hook.attach_point"))
+		return -EINVAL;
+	ret = bpf_tc_query(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid hook.attach_point"))
+		return -EINVAL;
+	inv_hook.attach_point = BPF_TC_INGRESS;
+
+	/* hook.attach_point valid, but parent invalid */
+	inv_hook.parent = TC_H_MAKE(1UL << 16, 10);
+	ret = bpf_tc_hook_create(&inv_hook, 0);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_create invalid hook parent"))
+		return -EINVAL;
+	ret = bpf_tc_hook_destroy(&inv_hook);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_destroy invalid hook parent"))
+		return -EINVAL;
+	ret = bpf_tc_attach(&inv_hook, &attach_opts, 0);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid hook parent"))
+		return -EINVAL;
+	ret = bpf_tc_detach(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid hook parent"))
+		return -EINVAL;
+	ret = bpf_tc_query(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid hook parent"))
+		return -EINVAL;
+
+	inv_hook.attach_point = BPF_TC_CUSTOM;
+	inv_hook.parent = 0;
+	/* These return EOPNOTSUPP instead of EINVAL as parent is checked after
+	 * attach_point of the hook.
+	 */
+	ret = bpf_tc_hook_create(&inv_hook, 0);
+	if (!ASSERT_EQ(ret, -EOPNOTSUPP, "bpf_tc_hook_create invalid hook parent"))
+		return -EINVAL;
+	ret = bpf_tc_hook_destroy(&inv_hook);
+	if (!ASSERT_EQ(ret, -EOPNOTSUPP, "bpf_tc_hook_destroy invalid hook parent"))
+		return -EINVAL;
+	ret = bpf_tc_attach(&inv_hook, &attach_opts, 0);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid hook parent"))
+		return -EINVAL;
+	ret = bpf_tc_detach(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid hook parent"))
+		return -EINVAL;
+	ret = bpf_tc_query(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid hook parent"))
+		return -EINVAL;
+	inv_hook.attach_point = BPF_TC_INGRESS;
+
+	/* detach */
+	ret = bpf_tc_detach(NULL, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid hook = NULL"))
+		return -EINVAL;
+	opts.prog_fd = 42;
+	ret = bpf_tc_detach(hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid prog_fd set"))
+		return -EINVAL;
+	opts.prog_fd = 0;
+	opts.prog_id = 42;
+	ret = bpf_tc_detach(hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid prog_id set"))
+		return -EINVAL;
+	opts.prog_id = 0;
+	opts.handle = 0;
+	ret = bpf_tc_detach(hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid handle unset"))
+		return -EINVAL;
+	opts.handle = 1;
+	opts.priority = 0;
+	ret = bpf_tc_detach(hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid priority unset"))
+		return -EINVAL;
+	opts.priority = UINT16_MAX + 1;
+	ret = bpf_tc_detach(hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid priority > UINT16_MAX"))
+		return -EINVAL;
+	opts.priority = 1;
+	ret = bpf_tc_detach(hook, NULL);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid opts = NULL"))
+		return -EINVAL;
+
+	/* query */
+	ret = bpf_tc_query(NULL, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid hook = NULL"))
+		return -EINVAL;
+	opts.prog_fd = fd;
+	ret = bpf_tc_query(hook, &opts);
+	if (!ASSERT_EQ(ret, -ENOENT, "bpf_tc_query valid only prog_fd set"))
+		return -EINVAL;
+	opts.prog_fd = 0;
+	opts.prog_id = 42;
+	ret = bpf_tc_query(hook, &opts);
+	if (!ASSERT_EQ(ret, -ENOENT, "bpf_tc_query valid only prog_id set"))
+		return -EINVAL;
+	opts.prog_fd = opts.prog_id = 42;
+	ret = bpf_tc_query(hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid both prog_fd and prog_id set"))
+		return -EINVAL;
+	opts.prog_fd = opts.prog_id = 0;
+	opts.handle = 0;
+	ret = bpf_tc_query(hook, &opts);
+	if (!ASSERT_EQ(ret, -ENOENT, "bpf_tc_query valid handle unset"))
+		return -EINVAL;
+	opts.handle = 1;
+	opts.priority = 0;
+	ret = bpf_tc_query(hook, &opts);
+	if (!ASSERT_EQ(ret, -ENOENT, "bpf_tc_query valid priority unset"))
+		return -EINVAL;
+	opts.priority = UINT16_MAX + 1;
+	ret = bpf_tc_query(hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid priority > UINT16_MAX"))
+		return -EINVAL;
+	opts.priority = 1;
+	ret = bpf_tc_query(hook, NULL);
+	if (!ASSERT_EQ(ret, -ENOENT, "bpf_tc_query valid opts = NULL"))
+		return -EINVAL;
+
+	/* attach */
+	ret = bpf_tc_attach(NULL, &attach_opts, 0);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid hook = NULL"))
+		return -EINVAL;
+	ret = bpf_tc_attach(hook, &attach_opts, 42);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid flags"))
+		return -EINVAL;
+	attach_opts.prog_fd = 0;
+	ret = bpf_tc_attach(hook, &attach_opts, 0);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid prog_fd unset"))
+		return -EINVAL;
+	attach_opts.prog_fd = fd;
+	attach_opts.prog_id = 42;
+	ret = bpf_tc_attach(hook, &attach_opts, 0);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid prog_id set"))
+		return -EINVAL;
+	attach_opts.prog_id = 0;
+	attach_opts.handle = 0;
+	ret = bpf_tc_attach(hook, &attach_opts, 0);
+	if (!ASSERT_OK(ret, "bpf_tc_attach valid handle unset"))
+		return -EINVAL;
+	attach_opts.prog_fd = attach_opts.prog_id = 0;
+	ASSERT_OK(bpf_tc_detach(hook, &attach_opts), "bpf_tc_detach");
+	attach_opts.prog_fd = fd;
+	attach_opts.handle = 1;
+	attach_opts.priority = 0;
+	ret = bpf_tc_attach(hook, &attach_opts, 0);
+	if (!ASSERT_OK(ret, "bpf_tc_attach valid priority unset"))
+		return -EINVAL;
+	attach_opts.prog_fd = attach_opts.prog_id = 0;
+	ASSERT_OK(bpf_tc_detach(hook, &attach_opts), "bpf_tc_detach");
+	attach_opts.prog_fd = fd;
+	attach_opts.priority = UINT16_MAX + 1;
+	ret = bpf_tc_attach(hook, &attach_opts, 0);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid priority > UINT16_MAX"))
+		return -EINVAL;
+	attach_opts.priority = 0;
+	attach_opts.handle = attach_opts.priority = 0;
+	ret = bpf_tc_attach(hook, &attach_opts, 0);
+	if (!ASSERT_OK(ret, "bpf_tc_attach valid both handle and priority unset"))
+		return -EINVAL;
+	attach_opts.prog_fd = attach_opts.prog_id = 0;
+	ASSERT_OK(bpf_tc_detach(hook, &attach_opts), "bpf_tc_detach");
+	ret = bpf_tc_attach(hook, NULL, 0);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid opts = NULL"))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int test_tc_query(const struct bpf_tc_hook *hook, int fd)
+{
+	struct test_tc_bpf *skel = NULL;
+	int new_fd, ret, i = 0;
+
+	skel = test_tc_bpf__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_tc_bpf__open_and_load"))
+		return -EINVAL;
+
+	new_fd = bpf_program__fd(skel->progs.cls);
+
+	/* make sure no other filters are attached */
+	ret = bpf_tc_query(hook, NULL);
+	if (!ASSERT_EQ(ret, -ENOENT, "bpf_tc_query == -ENOENT"))
+		goto end_destroy;
+
+	for (i = 0; i < 5; i++) {
+		DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .prog_fd = fd);
+		ret = bpf_tc_attach(hook, &opts, 0);
+		if (!ASSERT_OK(ret, "bpf_tc_attach"))
+			goto end;
+	}
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 1,
+			    .prog_fd = new_fd);
+	ret = bpf_tc_attach(hook, &opts, 0);
+	if (!ASSERT_OK(ret, "bpf_tc_attach"))
+		goto end;
+	i++;
+
+	ASSERT_EQ(opts.handle, 1, "handle match");
+	ASSERT_EQ(opts.priority, 1, "priority match");
+	ASSERT_NEQ(opts.prog_id, 0, "prog_id set");
+
+	opts.prog_fd = 0;
+	/* search with handle, priority, prog_id */
+	ret = bpf_tc_query(hook, &opts);
+	if (!ASSERT_OK(ret, "bpf_tc_query"))
+		goto end;
+
+	ASSERT_EQ(opts.handle, 1, "handle match");
+	ASSERT_EQ(opts.priority, 1, "priority match");
+	ASSERT_NEQ(opts.prog_id, 0, "prog_id set");
+
+	opts.priority = opts.prog_fd = 0;
+	/* search with handle, prog_id */
+	ret = bpf_tc_query(hook, &opts);
+	if (!ASSERT_OK(ret, "bpf_tc_query"))
+		goto end;
+
+	ASSERT_EQ(opts.handle, 1, "handle match");
+	ASSERT_EQ(opts.priority, 1, "priority match");
+	ASSERT_NEQ(opts.prog_id, 0, "prog_id set");
+
+	opts.handle = opts.prog_fd = 0;
+	/* search with priority, prog_id */
+	ret = bpf_tc_query(hook, &opts);
+	if (!ASSERT_OK(ret, "bpf_tc_query"))
+		goto end;
+
+	ASSERT_EQ(opts.handle, 1, "handle match");
+	ASSERT_EQ(opts.priority, 1, "priority match");
+	ASSERT_NEQ(opts.prog_id, 0, "prog_id set");
+
+	opts.handle = opts.priority = opts.prog_fd = 0;
+	/* search with prog_id */
+	ret = bpf_tc_query(hook, &opts);
+	if (!ASSERT_OK(ret, "bpf_tc_query"))
+		goto end;
+
+	ASSERT_EQ(opts.handle, 1, "handle match");
+	ASSERT_EQ(opts.priority, 1, "priority match");
+	ASSERT_NEQ(opts.prog_id, 0, "prog_id set");
+
+	while (i != 1) {
+		DECLARE_LIBBPF_OPTS(bpf_tc_opts, del_opts, .prog_fd = fd);
+		ret = bpf_tc_query(hook, &del_opts);
+		if (!ASSERT_OK(ret, "bpf_tc_query"))
+			goto end;
+		ASSERT_NEQ(del_opts.prog_id, opts.prog_id, "prog_id should not be same");
+		ASSERT_NEQ(del_opts.priority, 1, "priority should not be 1");
+		del_opts.prog_fd = del_opts.prog_id = 0;
+		ret = bpf_tc_detach(hook, &del_opts);
+		if (!ASSERT_OK(ret, "bpf_tc_detach"))
+			goto end;
+		i--;
+	}
+
+	opts.handle = opts.priority = opts.prog_id = 0;
+	opts.prog_fd = fd;
+	ret = bpf_tc_query(hook, &opts);
+	ASSERT_EQ(ret, -ENOENT, "bpf_tc_query == -ENOENT");
+
+end:
+	while (i--) {
+		DECLARE_LIBBPF_OPTS(bpf_tc_opts, del_opts, 0);
+		ret = bpf_tc_query(hook, &del_opts);
+		if (!ASSERT_OK(ret, "bpf_tc_query"))
+			break;
+		del_opts.prog_id = 0;
+		ret = bpf_tc_detach(hook, &del_opts);
+		if (!ASSERT_OK(ret, "bpf_tc_detach"))
+			break;
+	}
+	ASSERT_EQ(bpf_tc_query(hook, NULL), -ENOENT, "bpf_tc_query == -ENOENT");
+end_destroy:
+	test_tc_bpf__destroy(skel);
+	return ret;
+}
+
+void test_tc_bpf(void)
+{
+	struct test_tc_bpf *skel = NULL;
+	bool hook_created = true;
+	int cls_fd, ret;
+
+	skel = test_tc_bpf__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_tc_bpf__open_and_load"))
+		return;
+
+	cls_fd = bpf_program__fd(skel->progs.cls);
+
+	DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex = LO_IFINDEX,
+			    .attach_point = BPF_TC_INGRESS);
+	ret = bpf_tc_hook_create(&hook, 0);
+	if (ret < 0 && ret == -EEXIST) {
+		hook_created = false;
+		ret = 0;
+	}
+	if (!ASSERT_OK(ret, "bpf_tc_hook_create(BPF_TC_INGRESS)"))
+		goto end;
+
+	hook.attach_point = BPF_TC_CUSTOM;
+	hook.parent = TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS);
+	ret = bpf_tc_hook_create(&hook, 0);
+	if (!ASSERT_EQ(ret, -EOPNOTSUPP, "bpf_tc_hook_create invalid hook.attach_point"))
+		goto end;
+
+	ret = test_tc_internal(&hook, cls_fd);
+	if (!ASSERT_OK(ret, "test_tc_internal ingress"))
+		goto end;
+
+	ret = bpf_tc_hook_destroy(&hook);
+	if (!ASSERT_EQ(ret, -EOPNOTSUPP, "bpf_tc_hook_destroy invalid hook.attach_point"))
+		goto end;
+
+	hook.attach_point = BPF_TC_INGRESS;
+	hook.parent = 0;
+	bpf_tc_hook_destroy(&hook);
+
+	ret = test_tc_internal(&hook, cls_fd);
+	if (!ASSERT_OK(ret, "test_tc_internal ingress"))
+		goto end;
+
+	bpf_tc_hook_destroy(&hook);
+
+	hook.attach_point = BPF_TC_EGRESS;
+	ret = test_tc_internal(&hook, cls_fd);
+	if (!ASSERT_OK(ret, "test_tc_internal egress"))
+		goto end;
+
+	bpf_tc_hook_destroy(&hook);
+
+	ret = test_tc_bpf_api(&hook, cls_fd);
+	if (!ASSERT_OK(ret, "test_tc_bpf_api"))
+		goto end;
+
+	bpf_tc_hook_destroy(&hook);
+
+	ret = test_tc_query(&hook, cls_fd);
+	if (!ASSERT_OK(ret, "test_tc_query"))
+		goto end;
+
+end:
+	if (hook_created) {
+		hook.attach_point = BPF_TC_INGRESS|BPF_TC_EGRESS;
+		bpf_tc_hook_destroy(&hook);
+	}
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

