Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B071959A95A
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 01:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244214AbiHSXYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 19:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244180AbiHSXYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 19:24:01 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB3E2ED4C;
        Fri, 19 Aug 2022 16:24:00 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id BF5093200657;
        Fri, 19 Aug 2022 19:23:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 19 Aug 2022 19:23:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1660951437; x=1661037837; bh=Yi
        pKfE5H7K9Z8GqiZelawUT7boFvb7Vr7t0y/LekHjU=; b=MaETqA0YX0tuMj9POq
        4bGjhmm6hTEKneb0RfbtNfcFGNpfelMXxp4FPCYM24938MdflRQrvwG+/cczXTrn
        d4/mSlpDOWyVWidCAILby7WQehR2NU62oQSIfeU16gu4ehY3wnviZDeVfEyvpMKS
        WlqVxzlz6Hrp4HDjPjlvpTvbxOm5KqCqvGbL+6lkiBuQSN+f2YKoywpIP6gavt88
        d+Y1kk2qbZ2gXfynCFN7x1nuvAGd110UOFonPZY44shKIh3oqkesv/9vmP+mlJIt
        KNnyflzpnplhN+f5PharV3gj1egKua4qIuQNOE3OBAZ4mfNLEK6FfGl70av72nLw
        zbAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1660951437; x=1661037837; bh=YipKfE5H7K9Z8
        GqiZelawUT7boFvb7Vr7t0y/LekHjU=; b=F4JQ1nwbHO5/R7xw+xCHr+XwtXFp1
        nm/MvCGfyoh72iRGRFENxUEP58Fdr2IJoC1DDl04g7QyY3wN4yPnIKcp0UW3OMix
        Qdu59JPgSLJNJfblENytYTxHqJ3N7kDoMDitYXoUjhKE0AlRYej2nPpSJCYeHdzN
        vyLwX+K+yoGIAakGYw9Q98u+JIU8XNZJE3xnQC242cO0uj+m03HOcFa7Ahr9G4gj
        cq1u3/PGCNvJyKcoASwrSp24/8DMdggo9EytrY+b7j3P6U3mZ5IPTZ7p6YmjInF/
        3YjqprUrLLEPw+uJw+ODfUoqYJnA/xEnNyfb4ITF+gmt2N9HFpmzhX70A==
X-ME-Sender: <xms:jRsAY1irPVIpEk36IWPx9d819_9QtR5mPlsDgQloXt85KQBQIMGmaw>
    <xme:jRsAY6AgSfm4PUKDMrRTf4M72S1-KhRycfWjfx_1OvKliww1HLfOZ_XFg2W5YuLiw
    4dZMpZ69GwyEqnCYQ>
X-ME-Received: <xmr:jRsAY1H8UqJyS4FspUGGmQqsZTDVEe8xdqYh8eGWwGzr0TKLcnzP5IMxkFdPm_66LNV0LAqN6nyuB-LWTcKxvxcn_6QMLfrDY7wo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeivddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdljedtmdenucfjughrpefhvf
    evufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceo
    ugiguhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepgfefgfegjefhudeike
    dvueetffelieefuedvhfehjeeljeejkefgffeghfdttdetnecuvehluhhsthgvrhfuihii
    vgepudenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:jRsAY6SglckYl_Kqb8J31l0repszBhR4o4hQPFXb6RwiWT2aJy-0bg>
    <xmx:jRsAYyyCfM5uFNhsDOkOE3tMJz-wz5l_dllAWLhgM0FqkelgV0AZBg>
    <xmx:jRsAYw6RbXElkUqRV5cPVBk3Q62VDfkHYtatvnaGbzR9JmlEL9_dpA>
    <xmx:jRsAY04D4uDLuZDO87hGHeVULktPE5Kmd5sk80yzSu0QtyDSDVjkWw>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Aug 2022 19:23:56 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 5/5] selftests/bpf: Add tests for writing to nf_conn:mark
Date:   Fri, 19 Aug 2022 17:23:34 -0600
Message-Id: <c131830b9b8f2c2ac5a2471bc00057de3e2f071d.1660951028.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660951028.git.dxu@dxuuu.xyz>
References: <cover.1660951028.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a simple extension to the existing selftest to write to
nf_conn:mark. Also add a failure test for writing to unsupported field.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |  2 ++
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |  9 +++++++--
 .../testing/selftests/bpf/progs/test_bpf_nf_fail.c | 14 ++++++++++++++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index 544bf90ac2a7..ab9117ae7545 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -17,6 +17,7 @@ struct {
 	{ "set_status_after_insert", "kernel function bpf_ct_set_status args#0 expected pointer to STRUCT nf_conn___init but" },
 	{ "change_timeout_after_alloc", "kernel function bpf_ct_change_timeout args#0 expected pointer to STRUCT nf_conn but" },
 	{ "change_status_after_alloc", "kernel function bpf_ct_change_status args#0 expected pointer to STRUCT nf_conn but" },
+	{ "write_not_allowlisted_field", "no write support to nf_conn at off" },
 };
 
 enum {
@@ -113,6 +114,7 @@ static void test_bpf_nf_ct(int mode)
 	ASSERT_LE(skel->bss->test_delta_timeout, 10, "Test for max ct timeout update");
 	/* expected status is IPS_SEEN_REPLY */
 	ASSERT_EQ(skel->bss->test_status, 2, "Test for ct status update ");
+	ASSERT_EQ(skel->bss->test_insert_lookup_mark, 77, "Test for insert and lookup mark value");
 	ASSERT_EQ(skel->data->test_exist_lookup, 0, "Test existing connection lookup");
 	ASSERT_EQ(skel->bss->test_exist_lookup_mark, 43, "Test existing connection lookup ctmark");
 end:
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index 2722441850cc..b5e7079701e8 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -23,6 +23,7 @@ int test_insert_entry = -EAFNOSUPPORT;
 int test_succ_lookup = -ENOENT;
 u32 test_delta_timeout = 0;
 u32 test_status = 0;
+u32 test_insert_lookup_mark = 0;
 __be32 saddr = 0;
 __be16 sport = 0;
 __be32 daddr = 0;
@@ -144,6 +145,7 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
 
 		bpf_ct_set_timeout(ct, 10000);
 		bpf_ct_set_status(ct, IPS_CONFIRMED);
+		ct->mark = 77;
 
 		ct_ins = bpf_ct_insert_entry(ct);
 		if (ct_ins) {
@@ -157,6 +159,7 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
 				test_delta_timeout = ct_lk->timeout - bpf_jiffies64();
 				test_delta_timeout /= CONFIG_HZ;
 				test_status = IPS_SEEN_REPLY;
+				test_insert_lookup_mark = ct_lk->mark;
 				bpf_ct_change_status(ct_lk, IPS_SEEN_REPLY);
 				bpf_ct_release(ct_lk);
 				test_succ_lookup = 0;
@@ -175,8 +178,10 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
 		       sizeof(opts_def));
 	if (ct) {
 		test_exist_lookup = 0;
-		if (ct->mark == 42)
-			test_exist_lookup_mark = 43;
+		if (ct->mark == 42) {
+			ct->mark++;
+			test_exist_lookup_mark = ct->mark;
+		}
 		bpf_ct_release(ct);
 	} else {
 		test_exist_lookup = opts_def.error;
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c b/tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c
index bf79af15c808..0e4759ab38ff 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c
@@ -69,6 +69,20 @@ int lookup_insert(struct __sk_buff *ctx)
 	return 0;
 }
 
+SEC("?tc")
+int write_not_allowlisted_field(struct __sk_buff *ctx)
+{
+	struct bpf_ct_opts___local opts = {};
+	struct bpf_sock_tuple tup = {};
+	struct nf_conn *ct;
+
+	ct = bpf_skb_ct_lookup(ctx, &tup, sizeof(tup.ipv4), &opts, sizeof(opts));
+	if (!ct)
+		return 0;
+	ct->status = 0xF00;
+	return 0;
+}
+
 SEC("?tc")
 int set_timeout_after_insert(struct __sk_buff *ctx)
 {
-- 
2.37.1

