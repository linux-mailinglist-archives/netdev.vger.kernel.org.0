Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E7E59C62D
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237061AbiHVS11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237437AbiHVS0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:26:23 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4FD481D9;
        Mon, 22 Aug 2022 11:26:22 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id D2ABF3200A25;
        Mon, 22 Aug 2022 14:26:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 22 Aug 2022 14:26:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1661192780; x=1661279180; bh=Yi
        pKfE5H7K9Z8GqiZelawUT7boFvb7Vr7t0y/LekHjU=; b=BjnRpj3un69fCqI7K8
        +h4BOVNnUKPSj3h5Y2Oq4o+dPFH9nyiQP34eHOGv4UA/8BqmEAC9nX5Y4l2BcTUK
        HLrx+AEdn6fkjz2ujTe2gk88yAIOjZIlClbk9NzZZypTlVdK9aXjdYEkMH5tGEpX
        DRcE1JmtL7ZBodysiTtJwKCgOYYtu2kkzqRtbbho+RkZ9IGOXBzFhtW5sIGjd7lk
        2Z09vNIZEMdAoUs57QxRyDevuCAEtzUy3caT+5l1AyIhDhrmhFhMRsACLTYZbaw8
        430jfJ1LFukB8Ve1S/aLyrvqlJPaUOvIFV/wX2hWSatp5E5nKCYE5U6u5hSwfJYE
        9VvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1661192780; x=1661279180; bh=YipKfE5H7K9Z8
        GqiZelawUT7boFvb7Vr7t0y/LekHjU=; b=zUBuXfsO2yenZAvfYbLL4RFmzP4As
        875nTr4gVI6UwkE7UqmPttzgWIkRL9wIAhsboXQzEwUQat7E7mdxVeDLq8AsGDz5
        2yHp3gJNVejCJGxUN6/lR2yN+TjkQ5AjirIwxW6QNC6XW1C+vYujm7AzciEg7lOP
        +ndlqpaAiQ83bQSH9e2zUDIZcXgeyW/6yYkgH8JFXteFztCYK7tlgUgtCgxCZKgn
        skgKW3FtuhCmGdWN5bpXBHW2vaV81PhRQHaLSch28qDWl6n6UKh2FLtk6cGZLDsy
        PV8teWum8qqgnHTlIds4nFqDmZiZYCxyh+w9d3Gc4Y/+XxDYHe0wBJPUw==
X-ME-Sender: <xms:TMoDYzXA2AQ-rlLFIrXooOJr3sjAsk0PGJYEPlJyr6fsptYqcK-iLA>
    <xme:TMoDY7mQyztENySA-JbxWClfQgNeasxPxPhpgfn-sgNKgclz8Vp-sIOQ0wGID6Ksv
    raLD32mA2cy3bD-mg>
X-ME-Received: <xmr:TMoDY_YsnynBlhvT3hgHMjEa5QhCbtu6LmkjsbigVDTS3ZSn6v-5OO1B3DIiMe83qdCRTXiG06Q5N3F6ex6LteCZh4zMVf5STntE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeijedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:TMoDY-WU1sZxUUPJZI5OFT9eJp8qokAgiX0Pe3Gn30Ds_kr6fX-boA>
    <xmx:TMoDY9nngogJr8wvh1iyo4g5RnMKaCJxQJXEfk5b3-MH8RRLrZmY2Q>
    <xmx:TMoDY7dJ_CYkY67-g0nKJ6UBxsBS0fR_QZb4ShSx3qmbWprK4TZbOg>
    <xmx:TMoDYzc4JCRV6jpi2B3EVbHUZDpR65B04n4dRg0nlLxE5hpgesHDWA>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Aug 2022 14:26:19 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v4 5/5] selftests/bpf: Add tests for writing to nf_conn:mark
Date:   Mon, 22 Aug 2022 12:25:55 -0600
Message-Id: <d28f0b6f9358fe7f9586db42ebe036211f2b1e03.1661192455.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1661192455.git.dxu@dxuuu.xyz>
References: <cover.1661192455.git.dxu@dxuuu.xyz>
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

