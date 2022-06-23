Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0722B55893E
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiFWTjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiFWTio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:38:44 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10470B40;
        Thu, 23 Jun 2022 12:27:22 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s185so361300pgs.3;
        Thu, 23 Jun 2022 12:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LDMMB1Ic1udOjwnYTAF9EAvUIDzwYnAfTIRHXo9zgGc=;
        b=WYOP9uI12vWvIF/VGoaDfCyjLyLrIQG3HeAQHx6AlNAO3ymev1wcPw7NPRxao1CSf4
         6By8IHNN9wjHi2C3vcHf0Ou/+3mBlRsMCOFYOhgWK1ZQHTt3Pf8UQolLXdVAUeVfmufS
         d0eeHFlXHVA9mPCHK8B2WfDV5C+z01xYpqXEVK2pGFIHgYaGMnhVOv9d3N/jVzzf3/35
         pbIA6idvKhbpjBs+IWJbzpYVebj79CS2/F7Wu3d/tW3rI+gcVIyZozUV37KoPzDzPLbQ
         qoHx0Hw5+yqN6IQQJ5Do4IdWrt305/a2k/F+aE+qKKbMZxdXELj1UvAayfLli72t5MAu
         dzpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LDMMB1Ic1udOjwnYTAF9EAvUIDzwYnAfTIRHXo9zgGc=;
        b=cwmacTu28H/AfRSpt20Bu7pHXWCVUjmAI733qvOC4ejnmZ10ZN4GVz19plcOzrdkK/
         lpx7vuqR+oi+v4qGSAU0dihCT2iTEcKasWNSwx6MW0knYGFskoJx7pvDCq0IyXHlWnv2
         aXbRxMvunbdYPCLzCNYH32o0WmmGr1U6p695nlOWFKCQLU6ghg5230OLBfAJnV+p+tJY
         A/tfIq0hkW7m69fWrw3CYJzj3rBoRbBvULksw4OoEFYhpOdfpCEhynSKbp9ZHLt4Y8Ib
         JgC6lT4mETEUngSEYp5lvCE4Pb3ziBos1zaGBenJtZmFgnY+H2r6w8l7ihQTQOHVQB8S
         vj/A==
X-Gm-Message-State: AJIora8XaCpHclbB9fHYJsJFFn9g4WJ8cjJjoAGi72aDT+NWct8F2A5g
        u8bo81xylZbaof+nqsUfbXzSp4PThNGvvw==
X-Google-Smtp-Source: AGRyM1uIwlj8y+VCuthdxDkYDoyBb/AtuvfZbEHxND69OlSl93Kj36LqGbaKmgjCczFvZytzbAbapA==
X-Received: by 2002:a63:9516:0:b0:40c:c3b9:f984 with SMTP id p22-20020a639516000000b0040cc3b9f984mr8801249pgd.116.1656012441571;
        Thu, 23 Jun 2022 12:27:21 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0c0:79de:f3f4:353c:8616])
        by smtp.gmail.com with ESMTPSA id x9-20020a170902820900b0016a11e839fcsm154218pln.208.2022.06.23.12.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 12:27:21 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v5 7/8] selftests/bpf: Add tests for new nf_conntrack kfuncs
Date:   Fri, 24 Jun 2022 00:56:36 +0530
Message-Id: <20220623192637.3866852-8-memxor@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623192637.3866852-1-memxor@gmail.com>
References: <20220623192637.3866852-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8248; i=memxor@gmail.com; h=from:subject; bh=RpoFKQKq9TIc9XqrOPJ2hB0Jl5vDHPj07vqbLlf3DWg=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBitL5Mz1wl9nNkK93InlETkiO4rTzBrNyJVMNaKsz2 O8CO30WJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYrS+TAAKCRBM4MiGSL8RytsfD/ 4qy+L3ljg5vGv2kVUdOUqOQNNpTlOrGkc80d1eVedutHQvPrXBQ+ndXaBIG9CeaKdmV6lQCBwWwWG8 aDMNCGJzUvVW/UNdlNgvXJPuVjirR2lnE2WjzM04i6QZfiySLS1cMH2wOOXreO6Lrzm0YgEbpXjaVh x0f7t94qnGp2zM6ctfUTXE/wSd6kHHREJAL5frZ1n/ieZoxMqf4XpWTD0h36e6zhzrqv25vzvIHS2h jTdXD70eAIxuvdXqXw7oxGjZw4dhO9lLJ2UY7Pb91BObCOcyAlUTg9Oo3YF4h3Cmg59YLwhpPJKvno e1JHZwJqFg04eBrG0qEdI1UoPqUx/msrEpqr5cKSFtEFN2qnsQwTeLDDscm/k6Pyxz9ZtcIIbckS0D cwF0d08IWgh7ZRHvUPEIitZ79wfwjGvAZWu75DXURWOhYoPgb3DQZCanrC3bOuTyhDhc3DFSrYC/zc hhk4jCLuNvBzQ/zZ0KitccI6QD650WeoNpEiz1znu/XTa1AOhMGoV7VicRpEX6rlfsEQPH91nUJgD1 b4vzLOYw1l9+eBBbaz+JMMUvd7L8BhKZrIuj2IXNitS9itv2T2Y007LAOhvEvL3tOEnLJOC9eL4mf5 hMPLP1z2nSB4qdFprymKU2Gk8XP7f7MeYCskWnfvh24AXeVjvWGcNU7TnJ/w==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Introduce selftests for the following kfunc helpers:
- bpf_xdp_ct_alloc
- bpf_skb_ct_alloc
- bpf_ct_insert_entry
- bpf_ct_set_timeout
- bpf_ct_change_timeout
- bpf_ct_set_status
- bpf_ct_change_status

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  8 ++
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 85 ++++++++++++++++---
 2 files changed, 81 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index dd30b1e3a67c..6d53686a7e46 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -39,6 +39,14 @@ void test_bpf_nf_ct(int mode)
 	ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONET for bad but valid netns_id");
 	ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT for failed lookup");
 	ASSERT_EQ(skel->bss->test_eafnosupport, -EAFNOSUPPORT, "Test EAFNOSUPPORT for invalid len__tuple");
+	ASSERT_EQ(skel->data->test_alloc_entry, 0, "Test for alloc new entry");
+	ASSERT_EQ(skel->data->test_insert_entry, 0, "Test for insert new entry");
+	ASSERT_EQ(skel->data->test_succ_lookup, 0, "Test for successful lookup");
+	/* allow some tolerance for test_delta_timeout value to avoid races. */
+	ASSERT_GT(skel->bss->test_delta_timeout, 9, "Test for min ct timeout update");
+	ASSERT_LE(skel->bss->test_delta_timeout, 10, "Test for max ct timeout update");
+	/* expected status is IPS_SEEN_REPLY */
+	ASSERT_EQ(skel->bss->test_status, 2, "Test for ct status update ");
 end:
 	test_bpf_nf__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index f00a9731930e..196cd8dfe42a 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -8,6 +8,8 @@
 #define EINVAL 22
 #define ENOENT 2
 
+extern unsigned long CONFIG_HZ __kconfig;
+
 int test_einval_bpf_tuple = 0;
 int test_einval_reserved = 0;
 int test_einval_netns_id = 0;
@@ -16,6 +18,11 @@ int test_eproto_l4proto = 0;
 int test_enonet_netns_id = 0;
 int test_enoent_lookup = 0;
 int test_eafnosupport = 0;
+int test_alloc_entry = -EINVAL;
+int test_insert_entry = -EAFNOSUPPORT;
+int test_succ_lookup = -ENOENT;
+u32 test_delta_timeout = 0;
+u32 test_status = 0;
 
 struct nf_conn;
 
@@ -26,31 +33,44 @@ struct bpf_ct_opts___local {
 	u8 reserved[3];
 } __attribute__((preserve_access_index));
 
+struct nf_conn *bpf_xdp_ct_alloc(struct xdp_md *, struct bpf_sock_tuple *, u32,
+				 struct bpf_ct_opts___local *, u32) __ksym;
 struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *, struct bpf_sock_tuple *, u32,
 				  struct bpf_ct_opts___local *, u32) __ksym;
+struct nf_conn *bpf_skb_ct_alloc(struct __sk_buff *, struct bpf_sock_tuple *, u32,
+				 struct bpf_ct_opts___local *, u32) __ksym;
 struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock_tuple *, u32,
 				  struct bpf_ct_opts___local *, u32) __ksym;
+struct nf_conn *bpf_ct_insert_entry(struct nf_conn *) __ksym;
 void bpf_ct_release(struct nf_conn *) __ksym;
+void bpf_ct_set_timeout(struct nf_conn *, u32) __ksym;
+int bpf_ct_change_timeout(struct nf_conn *, u32) __ksym;
+int bpf_ct_set_status(struct nf_conn *, u32) __ksym;
+int bpf_ct_change_status(struct nf_conn *, u32) __ksym;
 
 static __always_inline void
-nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
-				   struct bpf_ct_opts___local *, u32),
+nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
+					struct bpf_ct_opts___local *, u32),
+	   struct nf_conn *(*alloc_fn)(void *, struct bpf_sock_tuple *, u32,
+				       struct bpf_ct_opts___local *, u32),
 	   void *ctx)
 {
 	struct bpf_ct_opts___local opts_def = { .l4proto = IPPROTO_TCP, .netns_id = -1 };
 	struct bpf_sock_tuple bpf_tuple;
 	struct nf_conn *ct;
+	int err;
 
 	__builtin_memset(&bpf_tuple, 0, sizeof(bpf_tuple.ipv4));
 
-	ct = func(ctx, NULL, 0, &opts_def, sizeof(opts_def));
+	ct = lookup_fn(ctx, NULL, 0, &opts_def, sizeof(opts_def));
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_einval_bpf_tuple = opts_def.error;
 
 	opts_def.reserved[0] = 1;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		       sizeof(opts_def));
 	opts_def.reserved[0] = 0;
 	opts_def.l4proto = IPPROTO_TCP;
 	if (ct)
@@ -59,21 +79,24 @@ nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
 		test_einval_reserved = opts_def.error;
 
 	opts_def.netns_id = -2;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		       sizeof(opts_def));
 	opts_def.netns_id = -1;
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_einval_netns_id = opts_def.error;
 
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def) - 1);
+	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		       sizeof(opts_def) - 1);
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_einval_len_opts = opts_def.error;
 
 	opts_def.l4proto = IPPROTO_ICMP;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		       sizeof(opts_def));
 	opts_def.l4proto = IPPROTO_TCP;
 	if (ct)
 		bpf_ct_release(ct);
@@ -81,37 +104,75 @@ nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
 		test_eproto_l4proto = opts_def.error;
 
 	opts_def.netns_id = 0xf00f;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		       sizeof(opts_def));
 	opts_def.netns_id = -1;
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_enonet_netns_id = opts_def.error;
 
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		       sizeof(opts_def));
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_enoent_lookup = opts_def.error;
 
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4) - 1, &opts_def, sizeof(opts_def));
+	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4) - 1, &opts_def,
+		       sizeof(opts_def));
 	if (ct)
 		bpf_ct_release(ct);
 	else
 		test_eafnosupport = opts_def.error;
+
+	bpf_tuple.ipv4.saddr = bpf_get_prandom_u32(); /* src IP */
+	bpf_tuple.ipv4.daddr = bpf_get_prandom_u32(); /* dst IP */
+	bpf_tuple.ipv4.sport = bpf_get_prandom_u32(); /* src port */
+	bpf_tuple.ipv4.dport = bpf_get_prandom_u32(); /* dst port */
+
+	ct = alloc_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		      sizeof(opts_def));
+	if (ct) {
+		struct nf_conn *ct_ins;
+
+		bpf_ct_set_timeout(ct, 10000);
+		bpf_ct_set_status(ct, IPS_CONFIRMED);
+
+		ct_ins = bpf_ct_insert_entry(ct);
+		if (ct_ins) {
+			struct nf_conn *ct_lk;
+
+			ct_lk = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4),
+					  &opts_def, sizeof(opts_def));
+			if (ct_lk) {
+				/* update ct entry timeout */
+				bpf_ct_change_timeout(ct_lk, 10000);
+				test_delta_timeout = ct_lk->timeout - bpf_jiffies64();
+				test_delta_timeout /= CONFIG_HZ;
+				test_status = IPS_SEEN_REPLY;
+				bpf_ct_change_status(ct_lk, IPS_SEEN_REPLY);
+				bpf_ct_release(ct_lk);
+				test_succ_lookup = 0;
+			}
+			bpf_ct_release(ct_ins);
+			test_insert_entry = 0;
+		}
+		test_alloc_entry = 0;
+	}
 }
 
 SEC("xdp")
 int nf_xdp_ct_test(struct xdp_md *ctx)
 {
-	nf_ct_test((void *)bpf_xdp_ct_lookup, ctx);
+	nf_ct_test((void *)bpf_xdp_ct_lookup, (void *)bpf_xdp_ct_alloc, ctx);
 	return 0;
 }
 
 SEC("tc")
 int nf_skb_ct_test(struct __sk_buff *ctx)
 {
-	nf_ct_test((void *)bpf_skb_ct_lookup, ctx);
+	nf_ct_test((void *)bpf_skb_ct_lookup, (void *)bpf_skb_ct_alloc, ctx);
 	return 0;
 }
 
-- 
2.36.1

