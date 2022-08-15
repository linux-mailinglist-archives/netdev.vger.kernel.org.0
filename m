Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C95A594652
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 01:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345597AbiHOWCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 18:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350148AbiHOWBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 18:01:53 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3F4112FBA;
        Mon, 15 Aug 2022 12:36:10 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3431B5C01C5;
        Mon, 15 Aug 2022 15:36:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Aug 2022 15:36:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1660592168; x=1660678568; bh=5Z
        RUO9fZWr4iLqIUqA1TD+ufCzt/V4tcVExTpw7qFl8=; b=i5vCNCqszLM1beHaJQ
        2wBEJ4Y/JZqn54UHXUt78W1fRMBTqQpZV1jPSTcbb1usCqGjbV+i3K0a6BMJb24w
        tukKM1y/DFLAf+hYuWdnYilWVRZT9912p9/eO0e6jaaHoHQBfYnzg5O3ojtd0Qb6
        xbTY24k7YDLTtgEKPeKFkhKBknZfHUFaXf0O5W/MQ9PoAzg136mFOzWScwGaXN/Q
        4Rah4FEwPFsrzy5kD/Mk1eV2WYTsFFPmwxQpEbbbEH2lfQwGKPLn6gY/1ahaQYa1
        YlPUwL2fv3cUGooz4/Jz7McftasUAUjJDEqPRklpre4EKRpH70nnViqJUdBRv+Sh
        W2DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1660592168; x=1660678568; bh=5ZRUO9fZWr4iL
        qIUqA1TD+ufCzt/V4tcVExTpw7qFl8=; b=UPkL0h3Q3B/mjFdU2ZfLxpsb4humL
        Z/LW7WAPCV/SjSFPd6/9lzS4fo0zzrtOh719YB1DacXb7J4hvXBFPs3J8Vn1NrJ4
        UKKlHxZOQsRQXuRprCwGkbjirgkVM0rBXfXohq8PjNO5Fi40hmEx90ODbcEu611+
        wj3D0Owc8fbGQkqvPHEPzbSsbJSrCYhNQtmsL5x6i2xagfRzVeWdKgCR/jtnglGF
        49+UabBz5/r11KHlqCFd97Pc6DtJoGFG3QnOUVoz0Muf0CYzQ+781rZirmJVWoPO
        09MQ+ccxzdCzk9LkCmmr9VchNX+xZiAlkDG9kuHavEsMI/YYOqFqjStiQ==
X-ME-Sender: <xms:J6D6YnhD8kw8M9N2ZUE_vzH6LoeHcekkInkLlv2cCCL6roHcYbNRgw>
    <xme:J6D6YkCmWvZ7wU_b51a1hDvPfwi8nQ38vqQ_8F2o3LltMsyohp0tfXM9hUyU-_mVE
    03p8gJpsfGmKL9-XA>
X-ME-Received: <xmr:J6D6YnGhVhBzQVf4X6wRfWxm9ZtyYa8VfMifmyyh21KRHI56wEisXpRmOD8yHLmCqzxJXMDN49M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehvddgudegudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:J6D6YkSv_eCsCsfChPNFF0vcx8M5qf2j-0R8D9Mve3lEzpWM5FMAUw>
    <xmx:J6D6Ykx8bn78CFx_913-nu3ZDgRD46BNPSjNb-06spHEJ2Z-ABBqag>
    <xmx:J6D6Yq7QrRcThNzpcipMVK5okzw9xgtD1tlJbGLA9Ijm2gnKEMM1RQ>
    <xmx:KKD6YgcprSMorS4VMKJJsDlssICHwT0hTPYcWuf3ecux_Flkke8d4Q>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 15:36:06 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 3/3] selftests/bpf: Add tests for writing to nf_conn:mark
Date:   Mon, 15 Aug 2022 13:35:48 -0600
Message-Id: <2407d87f6b6f9e0c66101cd68dcb1e2cfbd135c3.1660592020.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660592020.git.dxu@dxuuu.xyz>
References: <cover.1660592020.git.dxu@dxuuu.xyz>
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

