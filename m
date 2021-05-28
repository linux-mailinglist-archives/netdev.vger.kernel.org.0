Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C503947AD
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 22:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhE1UCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 16:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhE1UCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 16:02:43 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E910C061761;
        Fri, 28 May 2021 13:01:07 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id c12so4063522pfl.3;
        Fri, 28 May 2021 13:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v0gErz0uqwdqBiFc655CeWUaRW+WaS1J/1ZNEDecRN8=;
        b=YhndZvsgN/o14ThNjXRxqp9ybdOVXN9P17BYntEoue2WxPMi0hwLQodhzSRxWbDv5r
         F6PO14zfj+0WKq4Brfzx4dI7SaEedgFbLwad5ik2qBaIKmBYNecrkeIT2Mq1xnR7NS/q
         +1eDz9hUbsV56pw5cJxt/8xG3gLWk/6H5vvyf75joGns8QBGuAyV6i1MUkA9rpykTDab
         PFUaLAt2ns1SVnOWROhHjOInBDafgIZxvOhIZNQSZnY6jPKy9avYLFnzwF5yV+az5TyK
         7CpyaLiDLM8J9Lo8TPaRFgBrb/2eEvAvj6rZ9tqKk9lrg7kmCsx1nIazHIsj4Du7qP/w
         +wCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v0gErz0uqwdqBiFc655CeWUaRW+WaS1J/1ZNEDecRN8=;
        b=kCp2M38gi8QXK4WP72t41SqvDDOJceHJAHq4qU8J1pc/GO5jfv+l8wxdyx/yYp+cqd
         s8NRsBJkuKeT8DerqxeiPEj5xW1HG9ttAzVZc8TiQu14d3x+a+waAgWCRw8TMGGbmNaE
         4BCr8bwZOAnCAlfOqWS6F80YwklmYZP9pZTq89oPeO7zMGbEo1CQA1y7+akd0Sb9sf71
         mzW2FQbO49gugiqln8g20/MxFHQhsQOJe49EgYq9u64FZatP8om62olUBI+9OTKltd4T
         uIMFGF+qbgzG76CCAlsi61Hk07VTfF+Sl3fl2JM8/fBdhfndlteVUvYOCEIWv7JwsvI5
         Tx/Q==
X-Gm-Message-State: AOAM530VMFo1EXVnr23VzMETBS8TjzdglCTzym2IOOHNM5ckmQDRkdKg
        IN9eVtociBUvDvjd1ldbCtbSVVKJtQM=
X-Google-Smtp-Source: ABdhPJzUIctahvW7lt6Fkjpz7VnEZarMxaVJIt0txY+v7SibTNVukt7IRBiXQlUajM4C/glEzzzm9Q==
X-Received: by 2002:a62:3344:0:b029:28c:6f0f:cb90 with SMTP id z65-20020a6233440000b029028c6f0fcb90mr5457438pfz.58.1622232065927;
        Fri, 28 May 2021 13:01:05 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id i3sm1348540pfk.96.2021.05.28.13.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 13:01:05 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH RFC bpf-next 7/7] libbpf: add selftest for bpf_link based TC-BPF management API
Date:   Sat, 29 May 2021 01:29:46 +0530
Message-Id: <20210528195946.2375109-8-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528195946.2375109-1-memxor@gmail.com>
References: <20210528195946.2375109-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This covers basic attach/detach/update, and tests interaction with the
netlink API. It also exercises the bpf_link_info and fdinfo codepaths.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../selftests/bpf/prog_tests/tc_bpf_link.c    | 285 ++++++++++++++++++
 1 file changed, 285 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c b/tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c
new file mode 100644
index 000000000000..beaf06e0557c
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c
@@ -0,0 +1,285 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include <linux/pkt_cls.h>
+
+#include "test_tc_bpf.skel.h"
+
+#define LO_IFINDEX 1
+
+static int test_tc_bpf_link_basic(struct bpf_tc_hook *hook,
+				  struct bpf_program *prog)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_link_opts, opts, .handle = 1, .priority = 1);
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, qopts, .handle = 1, .priority = 1);
+	struct bpf_prog_info info = {};
+	__u32 info_len = sizeof(info);
+	struct bpf_link *link, *invl;
+	int ret;
+
+	link = bpf_program__attach_tc(prog, hook, &opts);
+	if (!ASSERT_OK_PTR(link, "bpf_program__attach_tc"))
+		return PTR_ERR(link);
+
+	ret = bpf_obj_get_info_by_fd(bpf_program__fd(prog), &info, &info_len);
+	if (!ASSERT_OK(ret, "bpf_obj_get_info_by_fd"))
+		goto end;
+
+	ret = bpf_tc_query(hook, &qopts);
+	if (!ASSERT_OK(ret, "bpf_tc_query"))
+		goto end;
+
+	if (!ASSERT_EQ(qopts.prog_id, info.id, "prog_id match"))
+		goto end;
+
+	opts.gen_flags = ~0u;
+	invl = bpf_program__attach_tc(prog, hook, &opts);
+	if (!ASSERT_ERR_PTR(invl, "bpf_program__attach_tc with invalid flags")) {
+		bpf_link__destroy(invl);
+		ret = -EINVAL;
+	}
+
+end:
+	bpf_link__destroy(link);
+	return ret;
+}
+
+static int test_tc_bpf_link_netlink_interaction(struct bpf_tc_hook *hook,
+						struct bpf_program *prog)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, lopts,
+			    .old_prog_fd = bpf_program__fd(prog));
+	DECLARE_LIBBPF_OPTS(bpf_tc_link_opts, opts, .handle = 1, .priority = 1);
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, nopts, .handle = 1, .priority = 1);
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, dopts, .handle = 1, .priority = 1);
+	struct bpf_link *link;
+	int ret;
+
+	/* We need to test the following cases:
+	 *	1. BPF link owned filter cannot be replaced by netlink
+	 *	2. Netlink owned filter cannot be replaced by BPF link
+	 *	3. Netlink cannot do targeted delete of BPF link owned filter
+	 *	4. Filter is actually deleted (with chain cleanup)
+	 *	   We actually (ab)use the kernel behavior of returning EINVAL when
+	 *	   target chain doesn't exist on tc_get_tfilter (which maps to
+	 *	   bpf_tc_query) here, to know if the chain was really cleaned
+	 *	   up on tcf_proto destruction. Our setup is so that there is
+	 *	   only one reference to the chain.
+	 *
+	 *	   So on query, chain ? (filter ?: ENOENT) : EINVAL
+	 */
+
+	link = bpf_program__attach_tc(prog, hook, &opts);
+	if (!ASSERT_OK_PTR(link, "bpf_program__attach_tc"))
+		return PTR_ERR(link);
+
+	nopts.prog_fd = bpf_program__fd(prog);
+	ret = bpf_tc_attach(hook, &nopts);
+	if (!ASSERT_EQ(ret, -EEXIST, "bpf_tc_attach without replace"))
+		goto end;
+
+	nopts.flags = BPF_TC_F_REPLACE;
+	ret = bpf_tc_attach(hook, &nopts);
+	if (!ASSERT_EQ(ret, -EPERM, "bpf_tc_attach with replace"))
+		goto end;
+
+	ret = bpf_tc_detach(hook, &dopts);
+	if (!ASSERT_EQ(ret, -EPERM, "bpf_tc_detach"))
+		goto end;
+
+	lopts.flags = BPF_F_REPLACE;
+	ret = bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog),
+			      &lopts);
+	ASSERT_OK(ret, "bpf_link_update");
+	ret = ret < 0 ? -errno : ret;
+
+end:
+	bpf_link__destroy(link);
+	if (!ret && !ASSERT_EQ(bpf_tc_query(hook, &dopts), -EINVAL,
+			       "chain empty delete"))
+		ret = -EINVAL;
+	return ret;
+}
+
+static int test_tc_bpf_link_update_ways(struct bpf_tc_hook *hook,
+					struct bpf_program *prog)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_link_opts, opts, .handle = 1, .priority = 1);
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, uopts, 0);
+	struct test_tc_bpf *skel;
+	struct bpf_link *link;
+	int ret;
+
+	skel = test_tc_bpf__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_tc_bpf__open_and_load"))
+		return PTR_ERR(skel);
+
+	link = bpf_program__attach_tc(prog, hook, &opts);
+	if (!ASSERT_OK_PTR(link, "bpf_program__attach_tc")) {
+		ret = PTR_ERR(link);
+		goto end;
+	}
+
+	ret = bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog),
+			      &uopts);
+	if (!ASSERT_OK(ret, "bpf_link_update no old prog"))
+		goto end;
+
+	uopts.old_prog_fd = bpf_program__fd(prog);
+	ret = bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog),
+			      &uopts);
+	if (!ASSERT_TRUE(ret < 0 && errno == EINVAL,
+			 "bpf_link_update with old prog without BPF_F_REPLACE")) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	uopts.flags = BPF_F_REPLACE;
+	ret = bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog),
+			      &uopts);
+	if (!ASSERT_OK(ret, "bpf_link_update with old prog with BPF_F_REPLACE"))
+		goto end;
+
+	uopts.old_prog_fd = bpf_program__fd(skel->progs.cls);
+	ret = bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog),
+			      &uopts);
+	if (!ASSERT_TRUE(ret < 0 && errno == EINVAL,
+			 "bpf_link_update with wrong old prog")) {
+		ret = -EINVAL;
+		goto end;
+	}
+	ret = 0;
+
+end:
+	test_tc_bpf__destroy(skel);
+	return ret;
+}
+
+static int test_tc_bpf_link_info_api(struct bpf_tc_hook *hook,
+				     struct bpf_program *prog)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_link_opts, opts, .handle = 1, .priority = 1);
+	__u32 ifindex, parent, handle, gen_flags, priority;
+	char buf[4096], path[256], *begin;
+	struct bpf_link_info info = {};
+	__u32 info_len = sizeof(info);
+	struct bpf_link *link;
+	int ret, fdinfo;
+
+	link = bpf_program__attach_tc(prog, hook, &opts);
+	if (!ASSERT_OK_PTR(link, "bpf_program__attach_tc"))
+		return PTR_ERR(link);
+
+	ret = bpf_obj_get_info_by_fd(bpf_link__fd(link), &info, &info_len);
+	if (!ASSERT_OK(ret, "bpf_obj_get_info_by_fd"))
+		goto end;
+
+	ret = snprintf(path, sizeof(path), "/proc/self/fdinfo/%d",
+		       bpf_link__fd(link));
+	if (!ASSERT_TRUE(!ret || ret < sizeof(path), "snprintf pathname"))
+		goto end;
+
+	fdinfo = open(path, O_RDONLY);
+	if (!ASSERT_GT(fdinfo, -1, "open fdinfo"))
+		goto end;
+
+	ret = read(fdinfo, buf, sizeof(buf));
+	if (!ASSERT_GT(ret, 0, "read fdinfo")) {
+		ret = -EINVAL;
+		goto end_file;
+	}
+
+	begin = strstr(buf, "ifindex");
+	if (!ASSERT_OK_PTR(begin, "find beginning of fdinfo info")) {
+		ret = -EINVAL;
+		goto end_file;
+	}
+
+	ret = sscanf(begin, "ifindex:\t%u\n"
+			    "parent:\t%u\n"
+			    "handle:\t%u\n"
+			    "priority:\t%u\n"
+			    "gen_flags:\t%u\n",
+			    &ifindex, &parent, &handle, &priority, &gen_flags);
+	if (!ASSERT_EQ(ret, 5, "sscanf fdinfo")) {
+		ret = -EINVAL;
+		goto end_file;
+	}
+
+	ret = -EINVAL;
+
+#define X(a, b, c) (!ASSERT_EQ(a, b, #a " == " #b) || !ASSERT_EQ(b, c, #b " == " #c))
+	if (X(info.tc.ifindex, ifindex, 1) ||
+	    X(info.tc.parent, parent,
+	      TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)) ||
+	    X(info.tc.handle, handle, 1) ||
+	    X(info.tc.gen_flags, gen_flags, TCA_CLS_FLAGS_NOT_IN_HW) ||
+	    X(info.tc.priority, priority, 1))
+#undef X
+		goto end_file;
+
+	ret = 0;
+
+end_file:
+	close(fdinfo);
+end:
+	bpf_link__destroy(link);
+	return ret;
+}
+
+void test_tc_bpf_link(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex = LO_IFINDEX,
+			    .attach_point = BPF_TC_INGRESS);
+	struct test_tc_bpf *skel = NULL;
+	bool hook_created = false;
+	int ret;
+
+	skel = test_tc_bpf__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_tc_bpf__open_and_load"))
+		return;
+
+	ret = bpf_tc_hook_create(&hook);
+	if (ret == 0)
+		hook_created = true;
+
+	ret = ret == -EEXIST ? 0 : ret;
+	if (!ASSERT_OK(ret, "bpf_tc_hook_create(BPF_TC_INGRESS)"))
+		goto end;
+
+	ret = test_tc_bpf_link_basic(&hook, skel->progs.cls);
+	if (!ASSERT_OK(ret, "test_tc_bpf_link_basic"))
+		goto end;
+
+	bpf_tc_hook_destroy(&hook);
+
+	hook.attach_point = BPF_TC_EGRESS;
+	ret = test_tc_bpf_link_basic(&hook, skel->progs.cls);
+	if (!ASSERT_OK(ret, "test_tc_bpf_link_basic"))
+		goto end;
+
+	bpf_tc_hook_destroy(&hook);
+
+	ret = test_tc_bpf_link_netlink_interaction(&hook, skel->progs.cls);
+	if (!ASSERT_OK(ret, "test_tc_bpf_link_netlink_interaction"))
+		goto end;
+
+	bpf_tc_hook_destroy(&hook);
+
+	ret = test_tc_bpf_link_update_ways(&hook, skel->progs.cls);
+	if (!ASSERT_OK(ret, "test_tc_bpf_link_update_ways"))
+		goto end;
+
+	bpf_tc_hook_destroy(&hook);
+
+	ret = test_tc_bpf_link_info_api(&hook, skel->progs.cls);
+	if (!ASSERT_OK(ret, "test_tc_bpf_link_info_api"))
+		goto end;
+
+end:
+	if (hook_created) {
+		hook.attach_point = BPF_TC_INGRESS | BPF_TC_EGRESS;
+		bpf_tc_hook_destroy(&hook);
+	}
+	test_tc_bpf__destroy(skel);
+}
-- 
2.31.1

