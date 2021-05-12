Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6991937BABF
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 12:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhELKgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 06:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhELKgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 06:36:36 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F15C06174A;
        Wed, 12 May 2021 03:35:27 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id h16so5432763pfk.0;
        Wed, 12 May 2021 03:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vGWJ24v/McpgEUyugnvW/tCwpGA5iy0kPXE8+MGE2i0=;
        b=gDgtQi/s9O0YfV/+7rh+q/tp5JGaeGxdKWp1V4YatNkWbNe7SwKoA3LR94NARpEs2I
         hZVBi67/mS6iIEEwCa1M6gq+fEg1azjwjTG5JPx4KKd3/K3H/uVp5GXkFBE8sKIeqxfn
         9pEVMsft1cNPWt//UR7oli/gYpVaBUsMIYLJJWGQDhUh94wP93EjC3veZ9McAooHSw3c
         lhEYREuAzfjSPeKiIv5tkkbIWrhO26ZC/3jrR5eJkS0x8MtwEBVe3EhFNhYavJ/QRAnD
         4VsYARIBzAANjY41uP/zu5/Lz84Fpb15LkX6pAHTvgh5YcAo/v2KF+KzzEfSu1O5fR2M
         rfJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vGWJ24v/McpgEUyugnvW/tCwpGA5iy0kPXE8+MGE2i0=;
        b=XKEJlwVUVKU3PlwKmvDaIUeLYbwn4FSY0dHC96GB3FZFNvDfZZRttMlUqh7GkFleiv
         tZX5BtnG1xkByvW52tNVZ88uIzaLpH6PrC/z2W+0IejLzXYETHDy9Z7rHhrQ+gl393VP
         ZTeDJ6gJqoKdrZsWZQ6/TkNyiZC1mruRy/wgmM7315YN61N6CjC2Fj7FrMSZvWgbBMmv
         TbFIPdO8cSJySYSH2++d1J+uJRJiTpseDwxxXPorQU7+6prvNe3gVOL72Hu+cTKvv1Xh
         YIHEKbvUtfFYc2rVyDY2ZgyZFt+CW4h1yEzK7QhWxhRBh7f/cn6nBdrLXG+6ppIaB8Cq
         HxHQ==
X-Gm-Message-State: AOAM532au2aLly71d7G+o26mg4yMYWZ+tcwD2Wk4i6ALWv6sg1ORDq0N
        WG5BLg9abE2MsRC576bbCnjns7+MmjDGAw==
X-Google-Smtp-Source: ABdhPJzy3a5TxbepDc18DWsgA6LvWNbbwIigSFdpjOXCzB64dAJTq3XHNuvXep5CMlr52ct5OAqnjg==
X-Received: by 2002:a63:6f81:: with SMTP id k123mr35156345pgc.230.1620815726593;
        Wed, 12 May 2021 03:35:26 -0700 (PDT)
Received: from localhost ([2402:3a80:11c3:45ac:887c:70aa:e004:d014])
        by smtp.gmail.com with ESMTPSA id s3sm17388368pgs.62.2021.05.12.03.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 03:35:26 -0700 (PDT)
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
Subject: [PATCH bpf-next v7 3/3] libbpf: add selftests for TC-BPF API
Date:   Wed, 12 May 2021 16:04:51 +0530
Message-Id: <20210512103451.989420-4-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512103451.989420-1-memxor@gmail.com>
References: <20210512103451.989420-1-memxor@gmail.com>
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
 .../testing/selftests/bpf/prog_tests/tc_bpf.c | 395 ++++++++++++++++++
 .../testing/selftests/bpf/progs/test_tc_bpf.c |  12 +
 2 files changed, 407 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf.c

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_bpf.c b/tools/testing/selftests/bpf/prog_tests/tc_bpf.c
new file mode 100644
index 000000000000..4fc2b9984a28
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/tc_bpf.c
@@ -0,0 +1,395 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include <linux/pkt_cls.h>
+
+#include "test_tc_bpf.skel.h"
+
+#define LO_IFINDEX 1
+
+#define TEST_DECLARE_OPTS(__fd)                                                                   \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_h, .handle = 1);                                     \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_p, .priority = 1);                                   \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_f, .prog_fd = __fd);                                 \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_hp, .handle = 1, .priority = 1);                     \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_hf, .handle = 1, .prog_fd = __fd);                   \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_pf, .priority = 1, .prog_fd = __fd);                 \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_hpf, .handle = 1, .priority = 1, .prog_fd = __fd);   \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_hpi, .handle = 1, .priority = 1, .prog_id = 42);     \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_hpr, .handle = 1, .priority = 1,                     \
+			    .flags = BPF_TC_F_REPLACE);                                            \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_hpfi, .handle = 1, .priority = 1, .prog_fd = __fd,   \
+			    .prog_id = 42);                                                        \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_prio_max, .handle = 1, .priority = UINT16_MAX + 1);
+
+static int test_tc_bpf_basic(const struct bpf_tc_hook *hook, int fd)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 1, .prog_fd = fd);
+	struct bpf_prog_info info = {};
+	__u32 info_len = sizeof(info);
+	int ret;
+
+	ret = bpf_obj_get_info_by_fd(fd, &info, &info_len);
+	if (!ASSERT_OK(ret, "bpf_obj_get_info_by_fd"))
+		return ret;
+
+	ret = bpf_tc_attach(hook, &opts);
+	if (!ASSERT_OK(ret, "bpf_tc_attach"))
+		return ret;
+
+	if (!ASSERT_EQ(opts.handle, 1, "handle set") ||
+	    !ASSERT_EQ(opts.priority, 1, "priority set") ||
+	    !ASSERT_EQ(opts.prog_id, info.id, "prog_id set"))
+		goto end;
+
+	opts.prog_id = 0;
+	opts.flags = BPF_TC_F_REPLACE;
+	ret = bpf_tc_attach(hook, &opts);
+	if (!ASSERT_OK(ret, "bpf_tc_attach replace mode"))
+		goto end;
+
+	opts.flags = opts.prog_fd = opts.prog_id = 0;
+	ret = bpf_tc_query(hook, &opts);
+	if (!ASSERT_OK(ret, "bpf_tc_query"))
+		goto end;
+
+	if (!ASSERT_EQ(opts.handle, 1, "handle set") ||
+	    !ASSERT_EQ(opts.priority, 1, "priority set") ||
+	    !ASSERT_EQ(opts.prog_id, info.id, "prog_id set"))
+		goto end;
+
+end:
+	opts.flags = opts.prog_fd = opts.prog_id = 0;
+	ret = bpf_tc_detach(hook, &opts);
+	ASSERT_OK(ret, "bpf_tc_detach");
+	return ret;
+}
+
+static int test_tc_bpf_api(struct bpf_tc_hook *hook, int fd)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, attach_opts, .handle = 1, .priority = 1, .prog_fd = fd);
+	DECLARE_LIBBPF_OPTS(bpf_tc_hook, inv_hook, .attach_point = BPF_TC_INGRESS);
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 1);
+	int ret;
+
+	ret = bpf_tc_hook_create(NULL);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_create invalid hook = NULL"))
+		return -EINVAL;
+
+	/* hook ifindex = 0 */
+	ret = bpf_tc_hook_create(&inv_hook);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_create invalid hook ifindex == 0"))
+		return -EINVAL;
+
+	ret = bpf_tc_hook_destroy(&inv_hook);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_destroy invalid hook ifindex == 0"))
+		return -EINVAL;
+
+	ret = bpf_tc_attach(&inv_hook, &attach_opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid hook ifindex == 0"))
+		return -EINVAL;
+	attach_opts.prog_id = 0;
+
+	ret = bpf_tc_detach(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid hook ifindex == 0"))
+		return -EINVAL;
+
+	ret = bpf_tc_query(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid hook ifindex == 0"))
+		return -EINVAL;
+
+	/* hook ifindex < 0 */
+	inv_hook.ifindex = -1;
+
+	ret = bpf_tc_hook_create(&inv_hook);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_create invalid hook ifindex < 0"))
+		return -EINVAL;
+
+	ret = bpf_tc_hook_destroy(&inv_hook);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_destroy invalid hook ifindex < 0"))
+		return -EINVAL;
+
+	ret = bpf_tc_attach(&inv_hook, &attach_opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid hook ifindex < 0"))
+		return -EINVAL;
+	attach_opts.prog_id = 0;
+
+	ret = bpf_tc_detach(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid hook ifindex < 0"))
+		return -EINVAL;
+
+	ret = bpf_tc_query(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid hook ifindex < 0"))
+		return -EINVAL;
+
+	inv_hook.ifindex = LO_IFINDEX;
+
+	/* hook.attach_point invalid */
+	inv_hook.attach_point = 0xabcd;
+	ret = bpf_tc_hook_create(&inv_hook);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_create invalid hook.attach_point"))
+		return -EINVAL;
+
+	ret = bpf_tc_hook_destroy(&inv_hook);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_destroy invalid hook.attach_point"))
+		return -EINVAL;
+
+	ret = bpf_tc_attach(&inv_hook, &attach_opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid hook.attach_point"))
+		return -EINVAL;
+
+	ret = bpf_tc_detach(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid hook.attach_point"))
+		return -EINVAL;
+
+	ret = bpf_tc_query(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid hook.attach_point"))
+		return -EINVAL;
+
+	inv_hook.attach_point = BPF_TC_INGRESS;
+
+	/* hook.attach_point valid, but parent invalid */
+	inv_hook.parent = TC_H_MAKE(1UL << 16, 10);
+	ret = bpf_tc_hook_create(&inv_hook);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_create invalid hook parent"))
+		return -EINVAL;
+
+	ret = bpf_tc_hook_destroy(&inv_hook);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_destroy invalid hook parent"))
+		return -EINVAL;
+
+	ret = bpf_tc_attach(&inv_hook, &attach_opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid hook parent"))
+		return -EINVAL;
+
+	ret = bpf_tc_detach(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid hook parent"))
+		return -EINVAL;
+
+	ret = bpf_tc_query(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid hook parent"))
+		return -EINVAL;
+
+	inv_hook.attach_point = BPF_TC_CUSTOM;
+	inv_hook.parent = 0;
+	/* These return EOPNOTSUPP instead of EINVAL as parent is checked after
+	 * attach_point of the hook.
+	 */
+	ret = bpf_tc_hook_create(&inv_hook);
+	if (!ASSERT_EQ(ret, -EOPNOTSUPP, "bpf_tc_hook_create invalid hook parent"))
+		return -EINVAL;
+
+	ret = bpf_tc_hook_destroy(&inv_hook);
+	if (!ASSERT_EQ(ret, -EOPNOTSUPP, "bpf_tc_hook_destroy invalid hook parent"))
+		return -EINVAL;
+
+	ret = bpf_tc_attach(&inv_hook, &attach_opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid hook parent"))
+		return -EINVAL;
+
+	ret = bpf_tc_detach(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid hook parent"))
+		return -EINVAL;
+
+	ret = bpf_tc_query(&inv_hook, &opts);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid hook parent"))
+		return -EINVAL;
+
+	inv_hook.attach_point = BPF_TC_INGRESS;
+
+	/* detach */
+	{
+		TEST_DECLARE_OPTS(fd);
+
+		ret = bpf_tc_detach(NULL, &opts_hp);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid hook = NULL"))
+			return -EINVAL;
+
+		ret = bpf_tc_detach(hook, NULL);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid opts = NULL"))
+			return -EINVAL;
+
+		ret = bpf_tc_detach(hook, &opts_hpr);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid flags set"))
+			return -EINVAL;
+
+		ret = bpf_tc_detach(hook, &opts_hpf);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid prog_fd set"))
+			return -EINVAL;
+
+		ret = bpf_tc_detach(hook, &opts_hpi);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid prog_id set"))
+			return -EINVAL;
+
+		ret = bpf_tc_detach(hook, &opts_p);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid handle unset"))
+			return -EINVAL;
+
+		ret = bpf_tc_detach(hook, &opts_h);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid priority unset"))
+			return -EINVAL;
+
+		ret = bpf_tc_detach(hook, &opts_prio_max);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_detach invalid priority > UINT16_MAX"))
+			return -EINVAL;
+	}
+
+	/* query */
+	{
+		TEST_DECLARE_OPTS(fd);
+
+		ret = bpf_tc_query(NULL, &opts);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid hook = NULL"))
+			return -EINVAL;
+
+		ret = bpf_tc_query(hook, NULL);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid opts = NULL"))
+			return -EINVAL;
+
+		ret = bpf_tc_query(hook, &opts_hpr);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid flags set"))
+			return -EINVAL;
+
+		ret = bpf_tc_query(hook, &opts_hpf);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid prog_fd set"))
+			return -EINVAL;
+
+		ret = bpf_tc_query(hook, &opts_hpi);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid prog_id set"))
+			return -EINVAL;
+
+		ret = bpf_tc_query(hook, &opts_p);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid handle unset"))
+			return -EINVAL;
+
+		ret = bpf_tc_query(hook, &opts_h);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid priority unset"))
+			return -EINVAL;
+
+		ret = bpf_tc_query(hook, &opts_prio_max);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid priority > UINT16_MAX"))
+			return -EINVAL;
+
+		/* when chain is not present, kernel returns -EINVAL */
+		ret = bpf_tc_query(hook, &opts_hp);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query valid handle, priority set"))
+			return -EINVAL;
+	}
+
+	/* attach */
+	{
+		TEST_DECLARE_OPTS(fd);
+
+		ret = bpf_tc_attach(NULL, &opts_hp);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid hook = NULL"))
+			return -EINVAL;
+
+		ret = bpf_tc_attach(hook, NULL);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid opts = NULL"))
+			return -EINVAL;
+
+		opts_hp.flags = 42;
+		ret = bpf_tc_attach(hook, &opts_hp);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid flags"))
+			return -EINVAL;
+
+		ret = bpf_tc_attach(hook, NULL);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid prog_fd unset"))
+			return -EINVAL;
+
+		ret = bpf_tc_attach(hook, &opts_hpi);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid prog_id set"))
+			return -EINVAL;
+
+		ret = bpf_tc_attach(hook, &opts_pf);
+		if (!ASSERT_OK(ret, "bpf_tc_attach valid handle unset"))
+			return -EINVAL;
+		opts_pf.prog_fd = opts_pf.prog_id = 0;
+		ASSERT_OK(bpf_tc_detach(hook, &opts_pf), "bpf_tc_detach");
+
+		ret = bpf_tc_attach(hook, &opts_hf);
+		if (!ASSERT_OK(ret, "bpf_tc_attach valid priority unset"))
+			return -EINVAL;
+		opts_hf.prog_fd = opts_hf.prog_id = 0;
+		ASSERT_OK(bpf_tc_detach(hook, &opts_hf), "bpf_tc_detach");
+
+		ret = bpf_tc_attach(hook, &opts_prio_max);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_attach invalid priority > UINT16_MAX"))
+			return -EINVAL;
+
+		ret = bpf_tc_attach(hook, &opts_f);
+		if (!ASSERT_OK(ret, "bpf_tc_attach valid both handle and priority unset"))
+			return -EINVAL;
+		opts_f.prog_fd = opts_f.prog_id = 0;
+		ASSERT_OK(bpf_tc_detach(hook, &opts_f), "bpf_tc_detach");
+	}
+
+	return 0;
+}
+
+void test_tc_bpf(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex = LO_IFINDEX,
+			    .attach_point = BPF_TC_INGRESS);
+	struct test_tc_bpf *skel = NULL;
+	bool hook_created = false;
+	int cls_fd, ret;
+
+	skel = test_tc_bpf__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_tc_bpf__open_and_load"))
+		return;
+
+	cls_fd = bpf_program__fd(skel->progs.cls);
+
+	ret = bpf_tc_hook_create(&hook);
+	if (ret == 0)
+		hook_created = true;
+
+	ret = ret == -EEXIST ? 0 : ret;
+	if (!ASSERT_OK(ret, "bpf_tc_hook_create(BPF_TC_INGRESS)"))
+		goto end;
+
+	hook.attach_point = BPF_TC_CUSTOM;
+	hook.parent = TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS);
+	ret = bpf_tc_hook_create(&hook);
+	if (!ASSERT_EQ(ret, -EOPNOTSUPP, "bpf_tc_hook_create invalid hook.attach_point"))
+		goto end;
+
+	ret = test_tc_bpf_basic(&hook, cls_fd);
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
+	ret = test_tc_bpf_basic(&hook, cls_fd);
+	if (!ASSERT_OK(ret, "test_tc_internal ingress"))
+		goto end;
+
+	bpf_tc_hook_destroy(&hook);
+
+	hook.attach_point = BPF_TC_EGRESS;
+	ret = test_tc_bpf_basic(&hook, cls_fd);
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
+end:
+	if (hook_created) {
+		hook.attach_point = BPF_TC_INGRESS | BPF_TC_EGRESS;
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
2.31.1

