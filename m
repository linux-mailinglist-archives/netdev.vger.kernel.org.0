Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901545975FA
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241279AbiHQSnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241146AbiHQSnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:43:33 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42452EF;
        Wed, 17 Aug 2022 11:43:21 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 474385C00A1;
        Wed, 17 Aug 2022 14:43:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 17 Aug 2022 14:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1660761800; x=1660848200; bh=5Z
        RUO9fZWr4iLqIUqA1TD+ufCzt/V4tcVExTpw7qFl8=; b=h3n3pAdJt3ejoO7aLQ
        BlGI2Pa9ucgv9iX0QmGpT5JfMFEi2agl22xNw9eeBxCGOeeb+n83rcz0226yiweq
        tkBhyouzK3Y4XppKGeKX4YXniUPzZ8xezN2Lj9PgOQ5QKz9gWYDgGu4Q3FPdbQmg
        C1P/wU0USGCyjPWP7N3mVyLjjWu6CIt0v6J4dfBo28BJva14Yowf0LZQbQ2zRwvH
        EsSh/4Ak79TbFVNXlP2Q9dYXah271U5TgKMXVzzwS6enjWu3bGd5fIqONTZQvBRV
        +8fd/kLxrE+CacFMFFkWxqgrqSTolJXNSJ0j6Zu3a3r/aT9HTyoSaDLnLQPlfojV
        R9tQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1660761800; x=1660848200; bh=5ZRUO9fZWr4iL
        qIUqA1TD+ufCzt/V4tcVExTpw7qFl8=; b=eIgAPf1eAe+D0ES+0UaLm/zfPLPSc
        RLQPOgO6ReGpfeae/muAL5y8M86z1gp0++TRno9JTxu2Oofyp0A6vEHBXCwssboe
        mRH+mOlaF0MQYS1J5XuZcFp8njOGtrthOu2SKq39xnByGaWEsqHMUpZvJ1xQBhTG
        0TTM3oDEOIaPSiIPlNIS1qaJE0BDFyGmaerQN2R9/GJydfzvkQbTpJxhB271JMcI
        Y/HZh+oWSHtKaVWkA/d+Q/f9RkijsTV6H56zKhHMtLZRLAbJ4VgcOwz9nm6y+s6U
        Wqe48w4WxNHE3wlEMLcMfI7AMWAZskoC9x0LwjwnoNHowsjhawdMfwVGA==
X-ME-Sender: <xms:yDb9YjFjvJpCLr-Le3vMTe-Cc-ew-HFnn-ucRPQcIoKJ7CJKMWLyTw>
    <xme:yDb9YgVedlqMTqpf4de2eIT27hk6Jw0g3WquL9sDQRMgGr3hVKIMxeyH-02i5A76Z
    b5c6KMXbi6kx11e3Q>
X-ME-Received: <xmr:yDb9YlLe2tbqjOlVtHkrlvkJ3a7CS3nsWinW3QtQV_q2JfGp5T_RDPvpCe1e4xIA-U-mgYftVCJyclXZ6vm53MkW74FrLUf2I7Pl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehiedgudeftdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:yDb9YhHBaXOv6jFRvv4dzsIKJBr_CMCnO6Z_KIY7toGptyDqpenfxw>
    <xmx:yDb9YpU-bB3BWgO-9-KR_OPDoCDxvsOfbiJfGRnDNcDIEpIKkkRPxQ>
    <xmx:yDb9YsMfky9eXeWhVupNeScy-x4GisrC9BBXMumLbjCkVvEoVZ3AOg>
    <xmx:yDb9YiOg4xwcSaBCIxbFph-Td1ppj95wLQvfToY1QPh1rMo4W5LpWg>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 Aug 2022 14:43:19 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 4/4] selftests/bpf: Add tests for writing to nf_conn:mark
Date:   Wed, 17 Aug 2022 12:43:02 -0600
Message-Id: <7519a65ba6bd6e41ba0c580c81d4202c5982ea64.1660761470.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660761470.git.dxu@dxuuu.xyz>
References: <cover.1660761470.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a simple extension to the existing selftest to write to
nf_conn:mark. Also add a failure test for writing to unsupported field.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |  1 +
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |  6 ++++--
 .../testing/selftests/bpf/progs/test_bpf_nf_fail.c | 14 ++++++++++++++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index 544bf90ac2a7..45389c39f211 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -17,6 +17,7 @@ struct {
 	{ "set_status_after_insert", "kernel function bpf_ct_set_status args#0 expected pointer to STRUCT nf_conn___init but" },
 	{ "change_timeout_after_alloc", "kernel function bpf_ct_change_timeout args#0 expected pointer to STRUCT nf_conn but" },
 	{ "change_status_after_alloc", "kernel function bpf_ct_change_status args#0 expected pointer to STRUCT nf_conn but" },
+	{ "write_not_allowlisted_field", "no write support to nf_conn at off" },
 };
 
 enum {
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index 2722441850cc..638b6642d20f 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -175,8 +175,10 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
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

