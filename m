Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FAE3723FC
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 02:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhEDAvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 20:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbhEDAve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 20:51:34 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED4BC0613ED;
        Mon,  3 May 2021 17:50:40 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id n16so3777201plf.7;
        Mon, 03 May 2021 17:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9chQ41Coa2wXvL3pgdc5XcJkG24OdjPgfeYUHKBa+L8=;
        b=Rnls9Q5yEgGiMkq8Ix1vZ4Zl5DPsCpiMGgc91Mn43g4/YLSDwtzOqFPMlVMQXRFAYz
         bWDd4UNMl0YHk3I617X5LH2hK6V5+rU0bCYJRQOQJKJ7YeoCNOsIxV4tCY22w36kzBMt
         kSpWMOj/I4aZPN1fekoUStowFgNz+rpDEcgvrP+UvhKsynuOG89F/FgPg9srWZfCe8DA
         s56bCx7pP9oymOCpREE4T60BKfazHnVPKE2NXq3j2bmTAv0oo+wJORFTOg81wLmovvqH
         epquTBXGCoGrPuojcy5z3HVa56Tr6gPDLA19Z0AnCO6j2jkZ/XvJ5V9xnJLWz5ro0Yqf
         8X9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9chQ41Coa2wXvL3pgdc5XcJkG24OdjPgfeYUHKBa+L8=;
        b=ESn8ZW5RmtPJaFbPvmEO+QFeHUz26Bm1IEusW/8aB4O18Bjjm8JW+fSQJ/meKsgOMg
         kYth4AmjxvJ13vNUGIXzLlHJLUF3UqhZUUL/wYM5RaD6dPxdLIkjGZ/tfUUjaxMM0/ga
         OJN4+FqLoRdLKmiJEQ7ziZK53C68CMjRBt/hfZiAXc2QSporvAYC6m3L+MGA7gTMpPmg
         qeTjeFYihMygOZXuq2Efpfw287JBjePJT4TK85n22XxnX9Rgta32Xb5JtdtqjsA3VHHi
         UPVQHCOo1eaZXnQGioM5K/b7ihONly0J41wglabLKrq9JlD9+KhvoAWGZWkcZJqhVWKN
         9Nxg==
X-Gm-Message-State: AOAM53195b4QQvUI6ictl+xzxg7a/+vpSyRMVLDWGg2XbI/RZHD+MQBB
        mGT5We0LTP/Ebi+Z7uGuyOWmG2TFrUj3KQ==
X-Google-Smtp-Source: ABdhPJwgG+4InSRjEA10ctoE+yAhqnsikg+YsF8j8OUjorbBsjfkhZzUHG5SAbtipQ8dT4GNls5hMQ==
X-Received: by 2002:a17:903:3106:b029:e9:15e8:250e with SMTP id w6-20020a1709033106b02900e915e8250emr23182944plc.33.1620089439667;
        Mon, 03 May 2021 17:50:39 -0700 (PDT)
Received: from localhost ([47.8.22.213])
        by smtp.gmail.com with ESMTPSA id n18sm940735pgj.71.2021.05.03.17.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 17:50:39 -0700 (PDT)
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
Subject: [PATCH bpf-next v6 3/3] libbpf: add selftests for TC-BPF API
Date:   Tue,  4 May 2021 06:20:23 +0530
Message-Id: <20210504005023.1240974-4-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504005023.1240974-1-memxor@gmail.com>
References: <20210504005023.1240974-1-memxor@gmail.com>
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
 .../testing/selftests/bpf/prog_tests/tc_bpf.c | 544 ++++++++++++++++++
 .../testing/selftests/bpf/progs/test_tc_bpf.c |  12 +
 2 files changed, 556 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf.c

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_bpf.c b/tools/testing/selftests/bpf/prog_tests/tc_bpf.c
new file mode 100644
index 000000000000..88e318566cee
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/tc_bpf.c
@@ -0,0 +1,544 @@
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
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_i, .prog_id = 42);                                   \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_r, .flags = BPF_TC_F_REPLACE);                       \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_hp, .handle = 1, .priority = 1);                     \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_hf, .handle = 1, .prog_fd = __fd);                   \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_hi, .handle = 1, .prog_id = 42);                     \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_pf, .priority = 1, .prog_fd = __fd);                 \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_pi, .priority = 1, .prog_id = 42);                   \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_hpf, .handle = 1, .priority = 1, .prog_fd = __fd);   \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_hpi, .handle = 1, .priority = 1, .prog_id = 42);     \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_hpr, .handle = 1, .priority = 1,                     \
+			    .flags = BPF_TC_F_REPLACE);                                            \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_hpfi, .handle = 1, .priority = 1, .prog_fd = __fd,   \
+			    .prog_id = 42);                                                        \
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts_prio_max, .handle = 1, .priority = UINT16_MAX + 1);
+
+static int test_tc_internal(const struct bpf_tc_hook *hook, int fd)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 1, .prog_fd = fd);
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, info_opts, .prog_fd = fd);
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, info_opts2, 0);
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
+	ret = bpf_tc_query(hook, &info_opts);
+	if (!ASSERT_OK(ret, "bpf_tc_query"))
+		goto end;
+
+	info_opts2.prog_id = info.id;
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
+	opts.flags = BPF_TC_F_REPLACE;
+	ret = bpf_tc_attach(hook, &opts);
+	if (!ASSERT_OK(ret, "bpf_tc_attach replace mode"))
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
+	/* hook invalid flags */
+	hook->flags = 42;
+	ret = bpf_tc_hook_create(hook);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_create invalid flags"))
+		return -EINVAL;
+
+	ret = bpf_tc_hook_create(hook);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_destroy invalid flags"))
+		return -EINVAL;
+
+	ret = bpf_tc_hook_destroy(NULL);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_hook_destroy invalid hook = NULL"))
+		return -EINVAL;
+	hook->flags = 0;
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
+		if (!ASSERT_EQ(ret, -ENOENT, "bpf_tc_query valid opts = NULL"))
+			return -EINVAL;
+
+		ret = bpf_tc_query(hook, &opts_r);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid flags set"))
+			return -EINVAL;
+
+		ret = bpf_tc_query(hook, &opts_hpf);
+		if (!ASSERT_EQ(ret, -ENOENT, "bpf_tc_query valid only prog_fd set"))
+			return -EINVAL;
+
+		ret = bpf_tc_query(hook, &opts_hpi);
+		if (!ASSERT_EQ(ret, -ENOENT, "bpf_tc_query valid only prog_id set"))
+			return -EINVAL;
+
+		ret = bpf_tc_query(hook, &opts_hpfi);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid both prog_fd and prog_id set"))
+			return -EINVAL;
+
+		ret = bpf_tc_query(hook, &opts_pf);
+		if (!ASSERT_EQ(ret, -ENOENT, "bpf_tc_query valid handle unset"))
+			return -EINVAL;
+
+		ret = bpf_tc_query(hook, &opts_hf);
+		if (!ASSERT_EQ(ret, -ENOENT, "bpf_tc_query valid priority unset"))
+			return -EINVAL;
+
+		ret = bpf_tc_query(hook, &opts_prio_max);
+		if (!ASSERT_EQ(ret, -EINVAL, "bpf_tc_query invalid priority > UINT16_MAX"))
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
+static int test_tc_query(const struct bpf_tc_hook *hook, int fd)
+{
+	struct test_tc_bpf *skel = NULL;
+	int new_fd, ret, i = 0;
+	TEST_DECLARE_OPTS(fd);
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
+
+		ret = bpf_tc_attach(hook, &opts);
+		if (!ASSERT_OK(ret, "bpf_tc_attach"))
+			goto end;
+	}
+
+	opts_hpf.prog_fd = new_fd;
+	ret = bpf_tc_attach(hook, &opts_hpf);
+	if (!ASSERT_OK(ret, "bpf_tc_attach"))
+		goto end;
+	i++;
+	ASSERT_EQ(opts_hpf.handle, 1, "handle match");
+	ASSERT_EQ(opts_hpf.priority, 1, "priority match");
+	ASSERT_NEQ(opts_hpf.prog_id, 0, "prog_id set");
+
+	/* search with handle, priority, prog_id */
+	opts_hpi.prog_id = opts_hpf.prog_id;
+	ret = bpf_tc_query(hook, &opts_hpi);
+	if (!ASSERT_OK(ret, "bpf_tc_query"))
+		goto end;
+	ASSERT_EQ(opts_hpi.handle, 1, "handle match");
+	ASSERT_EQ(opts_hpi.priority, 1, "priority match");
+	ASSERT_NEQ(opts_hpi.prog_id, 0, "prog_id set");
+
+	/* search with handle, prog_id */
+	opts_hi.prog_id = opts_hpf.prog_id;
+	ret = bpf_tc_query(hook, &opts_hi);
+	if (!ASSERT_OK(ret, "bpf_tc_query"))
+		goto end;
+	ASSERT_EQ(opts_hi.handle, 1, "handle match");
+	ASSERT_EQ(opts_hi.priority, 1, "priority match");
+	ASSERT_NEQ(opts_hi.prog_id, 0, "prog_id set");
+
+	/* search with priority, prog_id */
+	opts_pi.prog_id = opts_hpf.prog_id;
+	ret = bpf_tc_query(hook, &opts_pi);
+	if (!ASSERT_OK(ret, "bpf_tc_query"))
+		goto end;
+	ASSERT_EQ(opts_pi.handle, 1, "handle match");
+	ASSERT_EQ(opts_pi.priority, 1, "priority match");
+	ASSERT_NEQ(opts_pi.prog_id, 0, "prog_id set");
+
+	/* search with prog_id */
+	opts_i.prog_id = opts_hpf.prog_id;
+	ret = bpf_tc_query(hook, &opts_i);
+	if (!ASSERT_OK(ret, "bpf_tc_query"))
+		goto end;
+	ASSERT_EQ(opts_i.handle, 1, "handle match");
+	ASSERT_EQ(opts_i.priority, 1, "priority match");
+	ASSERT_NEQ(opts_i.prog_id, 0, "prog_id set");
+
+	while (i != 1) {
+		DECLARE_LIBBPF_OPTS(bpf_tc_opts, del_opts, .prog_fd = fd);
+
+		ret = bpf_tc_query(hook, &del_opts);
+		if (!ASSERT_OK(ret, "bpf_tc_query"))
+			goto end;
+		ASSERT_NEQ(del_opts.prog_id, opts_i.prog_id, "prog_id should not be same");
+		ASSERT_NEQ(del_opts.priority, 1, "priority should not be 1");
+
+		del_opts.prog_fd = del_opts.prog_id = 0;
+		ret = bpf_tc_detach(hook, &del_opts);
+		if (!ASSERT_OK(ret, "bpf_tc_detach"))
+			goto end;
+		i--;
+	}
+
+	opts_f.prog_fd = fd;
+	ret = bpf_tc_query(hook, &opts_f);
+	ASSERT_EQ(ret, -ENOENT, "bpf_tc_query == -ENOENT");
+
+	opts_f.prog_fd = new_fd;
+	opts_f.prog_id = 0;
+	ret = bpf_tc_query(hook, &opts_f);
+	ASSERT_OK(ret, "bpf_tc_query for new_fd");
+
+end:
+	while (i--) {
+		DECLARE_LIBBPF_OPTS(bpf_tc_opts, del_opts, 0);
+
+		ret = bpf_tc_query(hook, &del_opts);
+		if (!ASSERT_OK(ret, "bpf_tc_query"))
+			break;
+
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
+	if (ret == 0) {
+		hook_created = true;
+		/* also test replace */
+		hook.flags = BPF_TC_F_REPLACE;
+		ret = bpf_tc_hook_create(&hook);
+		hook.flags = 0;
+
+		if (!ASSERT_OK(ret, "bpf_tc_hook_create replace"))
+			goto end;
+	}
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
2.30.2

