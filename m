Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084CA5B0A50
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiIGQlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiIGQlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:41:17 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3866F55D;
        Wed,  7 Sep 2022 09:41:16 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C06E65C0143;
        Wed,  7 Sep 2022 12:41:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 07 Sep 2022 12:41:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1662568875; x=1662655275; bh=Yi
        pKfE5H7K9Z8GqiZelawUT7boFvb7Vr7t0y/LekHjU=; b=NuK3uPYJVI4VwIsazO
        MKYEM8cpzAXqUtbTu6FSAX4Ugx8QI2zubhFtYyvnspqgVE33BJzf6HLl3BIYzTag
        waauXsxX54P3Z9eMX+LaHZzlsdp/j1RfuofpOXngviC7YPPNLyhAxEYexPICSmqx
        +VVcdP/hoUGUc8ipXzVwLXOtU3e/5sAuyqzBjvPzEgzi9yPJpMuYr2N0uhaxA3sU
        CTnIa4TOSB9bIxg/GbUVzeeDh29xqGfBVsSOryl0HEhg0fVPVGhYdJU9hDA5mbJS
        bLnj6KoSv54Cfq1D9uHbXzkqkxx6IZRJTFLwcBs0JbH9TNCZDzpFE7F0Vgzcsahg
        6uQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1662568875; x=1662655275; bh=YipKfE5H7K9Z8
        GqiZelawUT7boFvb7Vr7t0y/LekHjU=; b=ubAm8/hxHUIJDSTDNStqDEgXEUKNz
        cdxLmOUdSwQavIQ0iTu28wYTdG1220vY16hif0UGjsQtprBBng31juPpetgK1c/W
        Fsgi5+uc+bFfgnFMSAVtv7zq/YYlIqnuHeySeu7trNYYdec0mo5ZFanYPAexJLPO
        UNqv0bzS9fyN8EYbmWjYhGD/P5RdMhGQNcxC7nXooFpRM3u4NjPvZcvzFbB3/qDO
        cOsnLImFjtmNxOUhWBOfj/CNHPHhv/VDFiC0Sxvx2F1FXU6318tJ8Efj3+AdMofC
        5LL5PhiUqgY6N2VqcyyXW2ybQ2K8uLDeXVRj3rc30lwkm1WC72mGnNHfA==
X-ME-Sender: <xms:q8kYY7YCfB7E_WoD9nxkOoGa245k1bwzYqyS3zXR-CfQBMnETTEFOQ>
    <xme:q8kYY6bH-gBgHErwcO-yhalfUCrgOG3MFQ3ng5mX_7h7xMNGMDDTwn1m2aUQj4q4Z
    keStJ4lCXkKMZaxLw>
X-ME-Received: <xmr:q8kYY999jrKx9eOrMnF8NH-dwepulzljkjQ_Hf9XxS22Wk3vPNmINOiVxRlvilQzrYQHS2ryfPo44dFZNNhS7AaFAbuF_SOgp2O-nAY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedttddguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:q8kYYxpeObwTzdTA7MyqirliUEXWvzpoMYtCHYJeoXcrppPQ91tqvg>
    <xmx:q8kYY2oxNDeAPUloykw-Fx_-2NllS_CI8sID6lgSUx1k8D3vIhiyxg>
    <xmx:q8kYY3TiPGC-U292WtMzUNkR-t95d7KCndPF_7wE-uJm-P4pymmGCA>
    <xmx:q8kYYzR6YES2iOk9yxDFOpXOlrWmoYZC3fqujM_fDfDTNkKeWL6jQg>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Sep 2022 12:41:14 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v5 6/6] selftests/bpf: Add tests for writing to nf_conn:mark
Date:   Wed,  7 Sep 2022 10:40:41 -0600
Message-Id: <f78966b81b9349d2b8ebb4cee2caf15cb6b38ee2.1662568410.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1662568410.git.dxu@dxuuu.xyz>
References: <cover.1662568410.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
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

