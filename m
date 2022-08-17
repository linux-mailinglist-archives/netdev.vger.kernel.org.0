Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCED59760A
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241275AbiHQSno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241135AbiHQSnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:43:33 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EB3A1B6;
        Wed, 17 Aug 2022 11:43:19 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 359725C0055;
        Wed, 17 Aug 2022 14:43:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 17 Aug 2022 14:43:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1660761798; x=1660848198; bh=hU
        qykRDwILhCITAtALZZkYpFiByuoa6EiG1tm0Y5Woc=; b=aNcEtMYDSt33Sv2NFA
        DSsKn3kz5two2fafq+tTDqitbC9RjCVu6ytWIRbqcaC7CoX94m9sL9qxXuOqOOlU
        0mnGRxsEz+oeJd25RAUoX8e8Xle6BoweQPijtVEt9l1/2MxSaUC/al/xIt86rB/W
        gwDZ6vKpzoKlbJbJ5SO3AjqSOXuPwdIQytM1M+CYTZUcNXOwLUYFR/vmrlrmE3XY
        C2AzMgs9y3qFJnUDGGjMfK6ifFmmzuEzmxqId3gCCsITZID5bolSi9LUk5m1RaXP
        ZHd/vbHulyVAYgHH+ydOqVTo8t9XMOqg3ec/Dv0CHQGXiHod2qJHLxSt8zk/mM16
        mcbg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1660761798; x=1660848198; bh=hUqykRDwILhCI
        TAtALZZkYpFiByuoa6EiG1tm0Y5Woc=; b=4U88ijj3auGnnhzInGqSf263lwrxn
        4vdpWGE4/3cP5kZPxCNeget6ljXMxjnpIf4iv2MKCLTIGRldyx8e+7yRAomwtvaM
        nkNszleDwQ81Aum1pEsTd6FP2a9xQQeQt8PJadVkGAjFJgx2qpAEGef6rB3qy2c1
        +sD+YsTFb3QjtBzTmWVeLL0RKTsLJjKbnu8UEejSpmFmC0V44TRdjgwCDZAKJpWk
        7Zecc9PtCFk6HWac16iSNkLScD/EWJIrqcv+Vff7cAdcUqrKIOuSUSg50/UTyWGO
        J4Wujp2khjltI6IpQHhp81SLM4S8XWvRLJ0r1asWIZ7/qsooc1ZmoftAg==
X-ME-Sender: <xms:xjb9YthPy_VSdxT389tQTw3zH8E2Hdd41QjDS_fsrMDlK9hpD6As3g>
    <xme:xjb9YiArY4RTmtx9oE3hCu_N0Nd51HtDYvqXBgEUIXRpztcbIqvd9Xlk9cxvr8uzQ
    4PoIhPD1rNvIjNChg>
X-ME-Received: <xmr:xjb9YtF02O-EmKwEYp1wQxZ4pYhMq781Kxp430AQX39uGfp6eUR89JZuPYyKmykFUaWrAkSxaUVAUS5icmQvMIr_qubLEe2QXpDL>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehiedguddvlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:xjb9YiTvrMsNYNoVHew_vOJdun-Y1x-T2xncaKi_etnXxTwAjrZ-Gw>
    <xmx:xjb9Yqzu7wAD2W3UMYqlEoNztLDMaSJIphNrEPysgPZeh6EZUvPS8Q>
    <xmx:xjb9Yo7DDaba-IYcdMIg6yF8VQU_BFtzym5gRO8ZhYJ9_sxdY0U2UQ>
    <xmx:xjb9YvqDH1OZoMu2nR46yRHyvWsOTyLECASKj62QdK0-LIDvCsSQUw>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 Aug 2022 14:43:17 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 2/4] bpf: Add stub for btf_struct_access()
Date:   Wed, 17 Aug 2022 12:43:00 -0600
Message-Id: <3a707dd1ec4a2441425a8882072c69ffb774ed4d.1660761470.git.dxu@dxuuu.xyz>
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

Add corresponding unimplemented stub for when CONFIG_BPF_SYSCALL=n

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 include/linux/bpf.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a627a02cf8ab..24069eccb30c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2148,6 +2148,15 @@ static inline struct bpf_prog *bpf_prog_by_id(u32 id)
 	return ERR_PTR(-ENOTSUPP);
 }
 
+static inline int btf_struct_access(struct bpf_verifier_log *log,
+				    const struct btf *btf,
+				    const struct btf_type *t, int off, int size,
+				    enum bpf_access_type atype,
+				    u32 *next_btf_id, enum bpf_type_flag *flag)
+{
+	return -EACCES;
+}
+
 static inline const struct bpf_func_proto *
 bpf_base_func_proto(enum bpf_func_id func_id)
 {
-- 
2.37.1

