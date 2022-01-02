Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B943D482C06
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbiABQVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbiABQVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:21:42 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8211CC061761;
        Sun,  2 Jan 2022 08:21:42 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id x15so23412745plg.1;
        Sun, 02 Jan 2022 08:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yPVZrGJSFLRS6MIPiaFyGFav5aw9HfAuGJBQzAxNJDU=;
        b=jYjZmxqyb0x7j0wZLvdd/zx6WOUZ6rfI/hNF9gSRRuHsWRjSc4B9r2Fp1eO2enGd2h
         tgPbrswiUf+U94p2zlkUmvPwZX8y4ZfZGBIcjGsyzoiLvvE50MJ3lWINDgwkXA111UxV
         fe/FbFPYV1h2f5CFocQUi5f4FiiRW1HR2MjCcATqOp7NlVL94sMOHNAzLw7yp2uJyyPz
         qBin/8iVTxrd5anAV13afErmnOR8ELWT/1NrzL1Ee4VzziL3nvKGGZRfpMyp1ad0TPP9
         nIAh7ZUKXRd/EiXyTBEl/BMrdK7tdeV2/llkF1SBSWbUDTXIyggks0K6F2TJoP3HfBBf
         PSaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yPVZrGJSFLRS6MIPiaFyGFav5aw9HfAuGJBQzAxNJDU=;
        b=hiIGmpy1qloxoU7rH4ClEDvA15NZPaDUjK/+pHFCnL2IIXtCCjqMDRkSJyb46Fv+Rj
         1eC1k5om0caVIngr9In+GL5lS0p7hp7EJy602qJhff64loteH3fAh+MHdVgagWAeRIKh
         UHX7zlquD6oFH4bAlI6mhNYAWfKMAgByYvpTxgGEHLgHW5yGvsbyMnCvyLBTjkmTQGAL
         az6gZoDPeypogPOQ+BVjCocgvRC22PTYMnEGMKx9IlBvoizEVa5GyJml0Oj6MHhQIbMH
         HXUseRd9+8Kza4jvVm2aelVMdfXflklArT4XRjvj0HeFqxoIrrxi8uCaCf+SLCou2v9G
         UcDA==
X-Gm-Message-State: AOAM530krapb4QPnlHRK0cb/t44Apj8yeVCeD6Zmic23izLjkxEnXuiL
        7SotKnRXkNWeEdLcBV2IXydizkrVQS8=
X-Google-Smtp-Source: ABdhPJzGry/Y4PiqF/CUxfIgm6nFJEiIi7ZAV9oGmWYV6Sxfy/K15tRVpmVhof3b+U2CwLG3xGcolA==
X-Received: by 2002:a17:902:db0b:b0:149:dd3:846b with SMTP id m11-20020a170902db0b00b001490dd3846bmr41961968plx.49.1641140501885;
        Sun, 02 Jan 2022 08:21:41 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id ke3sm37504672pjb.46.2022.01.02.08.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 08:21:41 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v6 08/11] selftests/bpf: Add test for unstable CT lookup API
Date:   Sun,  2 Jan 2022 21:51:12 +0530
Message-Id: <20220102162115.1506833-9-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220102162115.1506833-1-memxor@gmail.com>
References: <20220102162115.1506833-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8429; h=from:subject; bh=MBQICqrG+a3pqkvnxVBoDyjAg1t3txFFGYd3KBFCLtU=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh0dCK9BbKUvHCnIWf7yQ60wl78R6gMFoTU7Qav50x ByYaS2uJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYdHQigAKCRBM4MiGSL8RyhvjEA CC+kM7wp3zJ/TY1VlWh31YGD7pMKT0kYxORGrhD2T1D9FnSaJV4hmZmEW8fIZE+IkzVoSzjH+hRy38 4xuixNDSwCQ4Ekj1HjvxpOWX//q/4z1MRkGHAAZPdqZIajGG1aXVOzQ3AzYuxLaMHyKBSeVo+5beYN nKwXorSUZCInSmRsIu8hFWo1cTv/jkqwPn6MdgotzpZYl8RoIeNIBbrXpVKj1zQWmxav7V+HuUzAxY Sx3uJNedkq/r9ttbLWbrBUvHFoTwTZPEVxpHCYOMcMK83SSWJ6t6+icFsKtaQ6eRzEMjYKpM9ODSNa FUUKO6A1FwbW4orqwEffC2ZoLgX6nYcyyunEv7iIb5UqlqRWNfNaS/mYh7/Bk+4Y2ceGKljJ6yI+fj YUa7xvlXxVbIXBSEd4kFkj9rvHBODmHgojSXABXWkRACqXsdm+ZS8bQd4NLDBAHAcJEXQlRFq2BEfl krvvUeIQTM3K10WyY18uOe+69DStVu5EkqgDQzJ+67y8a4UrcQyAE7u+13QEzlYBoD4YKkn3f+329l wCLP6viEwOdV6KDDmPkpNs2smWgQ/s+oUkq3eKOjgWsli5b5eIJKNEWOavY+AU+SSojWV+Jbf1AjVG d+5FcoSjP0AvxLOWcY5p1eFkJOMz2JOlS2ji+TF86icBWmQjEMEvDleKIpKA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This tests that we return errors as documented, and also that the kfunc
calls work from both XDP and TC hooks.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/config            |   4 +
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  48 ++++++++
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 105 ++++++++++++++++++
 3 files changed, 157 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_nf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index f6287132fa89..32d80e77e910 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -48,3 +48,7 @@ CONFIG_IMA_READ_POLICY=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_FUNCTION_TRACER=y
 CONFIG_DYNAMIC_FTRACE=y
+CONFIG_NETFILTER=y
+CONFIG_NF_DEFRAG_IPV4=y
+CONFIG_NF_DEFRAG_IPV6=y
+CONFIG_NF_CONNTRACK=y
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
new file mode 100644
index 000000000000..e3166a81e989
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+#include "test_bpf_nf.skel.h"
+
+enum {
+	TEST_XDP,
+	TEST_TC_BPF,
+};
+
+void test_bpf_nf_ct(int mode)
+{
+	struct test_bpf_nf *skel;
+	int prog_fd, err, retval;
+
+	skel = test_bpf_nf__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_bpf_nf__open_and_load"))
+		return;
+
+	if (mode == TEST_XDP)
+		prog_fd = bpf_program__fd(skel->progs.nf_xdp_ct_test);
+	else
+		prog_fd = bpf_program__fd(skel->progs.nf_skb_ct_test);
+
+	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4), NULL, NULL,
+				(__u32 *)&retval, NULL);
+	if (!ASSERT_OK(err, "bpf_prog_test_run"))
+		goto end;
+
+	ASSERT_EQ(skel->bss->test_einval_bpf_tuple, -EINVAL, "Test EINVAL for NULL bpf_tuple");
+	ASSERT_EQ(skel->bss->test_einval_reserved, -EINVAL, "Test EINVAL for reserved not set to 0");
+	ASSERT_EQ(skel->bss->test_einval_netns_id, -EINVAL, "Test EINVAL for netns_id < -1");
+	ASSERT_EQ(skel->bss->test_einval_len_opts, -EINVAL, "Test EINVAL for len__opts != NF_BPF_CT_OPTS_SZ");
+	ASSERT_EQ(skel->bss->test_eproto_l4proto, -EPROTO, "Test EPROTO for l4proto != TCP or UDP");
+	ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONET for bad but valid netns_id");
+	ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT for failed lookup");
+	ASSERT_EQ(skel->bss->test_eafnosupport, -EAFNOSUPPORT, "Test EAFNOSUPPORT for invalid len__tuple");
+end:
+	test_bpf_nf__destroy(skel);
+}
+
+void test_bpf_nf(void)
+{
+	if (test__start_subtest("xdp-ct"))
+		test_bpf_nf_ct(TEST_XDP);
+	if (test__start_subtest("tc-bpf-ct"))
+		test_bpf_nf_ct(TEST_TC_BPF);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
new file mode 100644
index 000000000000..d6d4002ad69c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+#define EAFNOSUPPORT 97
+#define EPROTO 71
+#define ENONET 64
+#define EINVAL 22
+#define ENOENT 2
+
+int test_einval_bpf_tuple = 0;
+int test_einval_reserved = 0;
+int test_einval_netns_id = 0;
+int test_einval_len_opts = 0;
+int test_eproto_l4proto = 0;
+int test_enonet_netns_id = 0;
+int test_enoent_lookup = 0;
+int test_eafnosupport = 0;
+
+struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *, struct bpf_sock_tuple *, u32,
+				  struct bpf_ct_opts *, u32) __ksym;
+struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock_tuple *, u32,
+				  struct bpf_ct_opts *, u32) __ksym;
+void bpf_ct_release(struct nf_conn *) __ksym;
+
+#define nf_ct_test(func, ctx)                                                  \
+	({                                                                     \
+		struct bpf_ct_opts opts_def = { .l4proto = IPPROTO_TCP,        \
+						.netns_id = -1 };              \
+		struct bpf_sock_tuple bpf_tuple;                               \
+		struct nf_conn *ct;                                            \
+		__builtin_memset(&bpf_tuple, 0, sizeof(bpf_tuple.ipv4));       \
+		ct = func(ctx, NULL, 0, &opts_def, sizeof(opts_def));          \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_einval_bpf_tuple = opts_def.error;                \
+		opts_def.reserved[0] = 1;                                      \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def));                                   \
+		opts_def.reserved[0] = 0;                                      \
+		opts_def.l4proto = IPPROTO_TCP;                                \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_einval_reserved = opts_def.error;                 \
+		opts_def.netns_id = -2;                                        \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def));                                   \
+		opts_def.netns_id = -1;                                        \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_einval_netns_id = opts_def.error;                 \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def) - 1);                               \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_einval_len_opts = opts_def.error;                 \
+		opts_def.l4proto = IPPROTO_ICMP;                               \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def));                                   \
+		opts_def.l4proto = IPPROTO_TCP;                                \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_eproto_l4proto = opts_def.error;                  \
+		opts_def.netns_id = 0xf00f;                                    \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def));                                   \
+		opts_def.netns_id = -1;                                        \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_enonet_netns_id = opts_def.error;                 \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def));                                   \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_enoent_lookup = opts_def.error;                   \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4) - 1,         \
+			  &opts_def, sizeof(opts_def));                        \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_eafnosupport = opts_def.error;                    \
+	})
+
+SEC("xdp")
+int nf_xdp_ct_test(struct xdp_md *ctx)
+{
+	nf_ct_test(bpf_xdp_ct_lookup, ctx);
+	return 0;
+}
+
+SEC("tc")
+int nf_skb_ct_test(struct __sk_buff *ctx)
+{
+	nf_ct_test(bpf_skb_ct_lookup, ctx);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.34.1

