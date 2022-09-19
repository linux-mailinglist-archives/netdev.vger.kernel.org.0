Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741BD5BD553
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 21:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiISToz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 15:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiISTox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 15:44:53 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E1F101C8;
        Mon, 19 Sep 2022 12:44:52 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id EBC225C0488;
        Mon, 19 Sep 2022 15:44:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 19 Sep 2022 15:44:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1663616691; x=1663703091; bh=sP
        o69fFVvKLwOXSYw31EJYP+b5qawO8I8dVcp2zd/Ow=; b=hG6x10uK3nsRQy9Cmx
        hcSGSnpCz/f3j3YF19pie65RjsOkjAhMZYLs39OurOAvPZD/Ut6JSzpfM7ZKJ81f
        ri8aG8vIwSBEK/hIlhIRbq4yce+gibJRNjgfAeKoZkus1K1QhWho5i7LEadbp5sh
        EwYNrOa9/1JE5fsgNRIvNbLs+iKVlUDQxSwTP/DsMU+KMKn25tq/1SAv1FVdg0rA
        bZIohLpnfzZKFddyiR11IHGoo8SBcok6oTZAtro/cd3LPHCeIWsKnpKCjni0vOhw
        LJGMJwimtaM7WlEW9TkEUp76Tl9Ikz5hpycfKehSqp9uECk2TaA4Xj1ioSsfmf1Q
        Lb7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1663616691; x=1663703091; bh=sPo69fFVvKLwO
        XSYw31EJYP+b5qawO8I8dVcp2zd/Ow=; b=xEarfzqVHBrCgLb3M0/nk0s+flGNa
        TcvQtFGI/o5uUr0D/5fLIMUCNlExomMwFxdBCqmF9iu3G17qTrPPvdsbe5UvZt1S
        mxGnF44LgJVAgv/wAwq70dqOCCL+kvteuTX7m8G1YENeHjJGeSJI0K/GCKEkL7z+
        FZnyUJjksiyhFI/xwL5wjDqHBRADiQ3wlA/4aFpOygPJle1esKdniy0HYr5VzLXb
        PH8WklP9vpW7BqLiFG6qjrWku0SMqfoax09u4f0wkqiCczQlZWGnUCedRt5odb/s
        18xC5S9cSgmQC3DC4vBkIZcKS676JHa3BLHlfdkU4U7bNcFjT3xbbObrA==
X-ME-Sender: <xms:s8YoYytagmfPHLdxdtmVV41sZrBAHiP-EPnc-dlWizrUOfS3jlYhsA>
    <xme:s8YoY3ciHeGqpcYNSnpFOo-0S3iS0J1c4LbHQRFA25b3aZBmA_gWLBnOziXRWb0xm
    OiTXenTPCOGfPJjAA>
X-ME-Received: <xmr:s8YoY9zucvUeOpEzfv-WAlza08BjUJQ7GICdAyqfD4TDb8HZ4TlE2TiDm_3VzaUB_SP86TX3dTOpCfs1hM4hfX2n82WwzhjjyzR89YE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvjedgudegfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:s8YoY9PHPAR2jCcyQHqXIWzXkqY4a_tkzRG2UCcBPAH5e0H_E7pbnw>
    <xmx:s8YoYy9rMNbFEIYyFxUN09_PAN5m3uDRuZAr2oKQspxiW-zTXukj3g>
    <xmx:s8YoY1V5JMWqiBgf3VZbP9x_weW7FZnEiL6H0o-4SXATxgO5-9fiYQ>
    <xmx:s8YoY1WLT3Aq-hWB3-QuQRXDJeP4uyfslLiEh7-VnutrX1tWWVCBWQ>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Sep 2022 15:44:50 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com, martin.lau@linux.dev
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 1/3] bpf: Remove unused btf_struct_access stub
Date:   Mon, 19 Sep 2022 13:44:35 -0600
Message-Id: <cb42e1772d4af5f5328d59dbd899b556c9869087.1663616584.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1663616584.git.dxu@dxuuu.xyz>
References: <cover.1663616584.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,T_PDS_OTHER_BAD_TLD
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This stub was not being used anywhere.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 include/net/netfilter/nf_conntrack_bpf.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
index a61a93d1c6dc..73f2b78232e5 100644
--- a/include/net/netfilter/nf_conntrack_bpf.h
+++ b/include/net/netfilter/nf_conntrack_bpf.h
@@ -31,16 +31,6 @@ static inline void cleanup_nf_conntrack_bpf(void)
 {
 }
 
-static inline int nf_conntrack_btf_struct_access(struct bpf_verifier_log *log,
-						 const struct btf *btf,
-						 const struct btf_type *t, int off,
-						 int size, enum bpf_access_type atype,
-						 u32 *next_btf_id,
-						 enum bpf_type_flag *flag)
-{
-	return -EACCES;
-}
-
 #endif
 
 #endif /* _NF_CONNTRACK_BPF_H */
-- 
2.37.1

