Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524CB48B554
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 19:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350166AbiAKSG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 13:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350387AbiAKSGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 13:06:01 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3B4C034005;
        Tue, 11 Jan 2022 10:05:18 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id q14so18434045plx.4;
        Tue, 11 Jan 2022 10:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yPVZrGJSFLRS6MIPiaFyGFav5aw9HfAuGJBQzAxNJDU=;
        b=JJBBKtcNCdnhlXBMnR+bvpnszX6d76upuZPiuGSYDEA3KUrfwiHrXhpUS+C9Ap6iN/
         EsCZDKn+V5VM1L7PDdT0JqFHlFNltxlusu2U68wQnc6UURPW3FVr3ebKTVqdK/pE28Q4
         fwQpUoRw024JLQRliC/nyE4mGVhzvQ6gGz/X+Cgy+sqkbA5AloqtWhQcgHMLcj7o6ctD
         Oxk9VvlfjvflDn6USRhkRrW7ZCaLrP09QIR4Ox7UnExAJTSaJAoUkNPehggewH/4P3Sv
         Qob9ScMr4ulIi5JafAzniUlFgQVpWQ0bYjyKck5C4FGbsZZo/baljd2ku27oIRW0xvAj
         wDmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yPVZrGJSFLRS6MIPiaFyGFav5aw9HfAuGJBQzAxNJDU=;
        b=2HcH1HHNFbs+gogYjPE/CYHs4fX61wADEr+G+yfN4fMbxTDrSF4YzjgBY8983fufVI
         vhlYkvP8yW/14v4Ql1ec5/lDKW0drZz+K2+Zep1WKd0/438btNS00ISZ3hg5qz+X0On1
         Lqrtqjt4ErJ0uSTkxA7t0Svdzch/pDJaHsFAnQ7V/A1QRN+fnBwVRlj/9etvR6xzGtIO
         UXoUo7fqotNz6fFcIIKdKZkdLcdqANQQB3UL8YG+t1Xb4kw2z0zz0Prx6zs6CHZrqcfM
         4YuweOjg7zxPWCS77SkQXGPM+B76kC/WdF9xQu2IiRli5zWV1C1qtxZWjgrdLxE3aHN0
         /yUA==
X-Gm-Message-State: AOAM531/K/j/dQXE7UmBDOHn6I5oPjHiRoX5/b4Lt+eRMbh90cTwS/gu
        4/k4DWfvE7W5L+A6IAuk5ptCtywvZhSgnQ==
X-Google-Smtp-Source: ABdhPJx52lH0L2/XyyuNoAmZ5VAhEW0h1lMh/iCjIKnFIowMHuqHEpSwhMyjPZtJ57vQg08Mxk370g==
X-Received: by 2002:a17:90a:460f:: with SMTP id w15mr4426509pjg.123.1641924317446;
        Tue, 11 Jan 2022 10:05:17 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id h5sm11426927pfi.46.2022.01.11.10.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 10:05:17 -0800 (PST)
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
Subject: [PATCH bpf-next v7 07/10] selftests/bpf: Add test for unstable CT lookup API
Date:   Tue, 11 Jan 2022 23:34:25 +0530
Message-Id: <20220111180428.931466-8-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111180428.931466-1-memxor@gmail.com>
References: <20220111180428.931466-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8429; h=from:subject; bh=MBQICqrG+a3pqkvnxVBoDyjAg1t3txFFGYd3KBFCLtU=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh3caj9BbKUvHCnIWf7yQ60wl78R6gMFoTU7Qav50x ByYaS2uJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYd3GowAKCRBM4MiGSL8Ryq2/D/ 4yNtB7QsSjFwJlpnCxdiPycWX/tdKNAQ6sV413mooIAjB3MkcilO6L8rOLp7pZAuqY19Mu17RRMCgp 0BEJEGaYF9kLEE+8gqyJBMgIVBiqg39E3M6j/RcqoBVKrfUC0K9Xbrf4isaUiG644MYIT6qFlFv7Uf qQpldefggygajk6YehTGhgaE+OftcysPkIFFx7mLgzWV7Uwb+03XbBcVWntDPkSvxvrJJ5GrZ3+mjA EX6MCsWX2HbrS/SxlSD7M++i2zsOIWVsi7zSWhGAr/uA0SI/Jm7dnR7IxNj0Z280/D/JCWODSbNGyj OndzWH2NflS+EGtYNlRaZgeMyG+sKrHihGNrs9PEG7wJYawvY+mgxFGCOXpOamEL+x82NpHywfrbOW 2lzbXD06zLvOMQ8YugrtGcf4nBqtNkn9xfyAAUjTChP6pd8ftJh3RkOSurEvFugOmSQB+0BhM26nob 8k61FuezpaGTlsz1ELUsC4Hlh3r8ubjQ7CH2tbjzXBL5XHw3AAIFe3b/Tj9cSz1+EXeckXSEPVYFKh 09XOcwJTDjKxEWqrbfhzsFYYYRYfrGFHK29lX017eMSGCY2EbZMrAmcF/0ApzZHn4aI1OhYO35BYlI /SgWbkGHzXwLjsS1a8zEcT+UYay5ornXX0hXfHBRcLUkCaCeBgzE9c4vHuCw==
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

