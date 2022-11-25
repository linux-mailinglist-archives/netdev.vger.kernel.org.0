Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C9D639098
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 21:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiKYUUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 15:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKYUUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 15:20:13 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954E6554C9;
        Fri, 25 Nov 2022 12:20:12 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 011825C0082;
        Fri, 25 Nov 2022 15:20:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 25 Nov 2022 15:20:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1669407611; x=1669494011; bh=Xv
        Yd3O3PElFieIucJx8p0pjVLEo0Fa7C1MYYL6bHqkA=; b=Y7VZu00xSWWOgOpwTX
        EMdOQPnr2noQl2MWEaqECbZH0F60MGPpkfGKsytkL8VTMgJxgS3bZi+vU43TaZMj
        X1hvF8JHVc1Om2A+RvQD5UtRDxRx6pFC0Chmz0Q2m5ceVZbC14fCgcDfVTw8Eu9l
        CUqDtv1iBJke8m67Ic5L9pitjdolo11+KOvYi+caGNZvF4yIkyuLOcuM0OhUw5Uj
        p1wtd9c+AGpejoK23IzQCQBDvLcCH9OvAdr5z7mlrrs5uLbyJ5oa/ydQMBNNiq4l
        9Gmt5FDfaFIwo6dAxv6pKdhHW9b0xLh/u5lGNK7JDhDkPvO+Xib9Ho/Sb5hqG++I
        S0aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1669407611; x=1669494011; bh=XvYd3O3PElFie
        IucJx8p0pjVLEo0Fa7C1MYYL6bHqkA=; b=UolxMNLaLjzNN/7vY1jUCODVUOXSO
        FniIPtmZllgypn4vrvtJTHiqwRhyA0rYRdELdUY2XD0U5YzkC8oxhw5vG+RJ6IE1
        giZN+L2UqXcADphQfvTAYI8kSqle03nRRW/ncv2m+hdO2vtLrZ+5wy8/I9RRWUID
        Uqw31kWXqqws6+afOT2mvbuVqNY04cTSSDiC36OAFW40SEljRvrZc2Z/Ay+FvtyN
        zSbVwiRL9fJWArfkUBRNG9/MwYFZj8vBLDKMe2M7gzG0D+RMBvbBFAn03Q23dU4v
        QL02VnKizjo+YuQlEC51s2wtyuEXZDxepmI2fgxldLd73K0PGAnWKtb7Q==
X-ME-Sender: <xms:eyOBYzGi-8Kd2Brlafv19aSilH5sJi7VrOW3_xV-kNe-L-kvOe2Djw>
    <xme:eyOBYwUx_mNvBMHgA-bskr5T_HnqYsG9OAst1P4gT1hu-0AUaguy4jIyamYUNI1H0
    VjN8IasvL-l01afaw>
X-ME-Received: <xmr:eyOBY1K1QXFHeWyM8wwQcuyL9NYa58_0tQPFtrwotpliEAN6NyrQW3siftj7QiQtiqWIo7ZSJI3eOFIjO5cgE-06MQXM_V2_38qo11SuGMecHfWG9XBcTcmz_P55ewLZ1D7DHA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrieehgddufeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhu
    vghlucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecugg
    ftrfgrthhtvghrnhepgffhvefhgfehjeehgfekheeuffegheffjeegheeuudeufeffhffh
    ueeihfeufffhnecuffhomhgrihhnpeguvghvihgtvghtrhgvvgdrohhrghenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhh
    ohhllhgrnhgurdhorhhg
X-ME-Proxy: <xmx:eyOBYxFMXcp5wVXIPDmB7JDB0EuKezR_i2jbrkPLQc5r0K2LCVHj3A>
    <xmx:eyOBY5VtABadoJ-EXNuzVsHuHX6kNWMcva6PGXcepwZP6XgYILvRyQ>
    <xmx:eyOBY8Mi5XxjLQ0TI4eSnQONSiRDwwRSo_cZvR9AA8_31wxNJVN5RA>
    <xmx:eyOBY6shTwokLcW8Gpj5mfC4xNFs_y7iNQhSAkrOvFJYljnAcTFJbw>
Feedback-ID: i0ad843c9:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Nov 2022 15:20:10 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Samuel Holland <samuel@sholland.org>,
        LABBE Corentin <clabbe.montjoie@gmail.com>,
        Maxime Ripard <mripard@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org
Subject: [PATCH 1/3] dt-bindings: net: sun7i-gmac: Fix snps,dwmac.yaml inheritance
Date:   Fri, 25 Nov 2022 14:20:06 -0600
Message-Id: <20221125202008.64595-2-samuel@sholland.org>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221125202008.64595-1-samuel@sholland.org>
References: <20221125202008.64595-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sun7i-gmac binding extends snps,dwmac.yaml, and should accept all
properties defined there, including "mdio", "resets", and "reset-names".
However, validation currently fails for these properties because the
local binding sets "unevaluatedProperties: false", and snps,dwmac.yaml
is only included inside an allOf block. Fix this by referencing
snps,dwmac.yaml at the top level.

Signed-off-by: Samuel Holland <samuel@sholland.org>
---

 .../devicetree/bindings/net/allwinner,sun7i-a20-gmac.yaml    | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.yaml
index 3bd912ed7c7e..7d2c62b4ccad 100644
--- a/Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.yaml
+++ b/Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.yaml
@@ -6,13 +6,12 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: Allwinner A20 GMAC
 
-allOf:
-  - $ref: "snps,dwmac.yaml#"
-
 maintainers:
   - Chen-Yu Tsai <wens@csie.org>
   - Maxime Ripard <mripard@kernel.org>
 
+$ref: "snps,dwmac.yaml#"
+
 properties:
   compatible:
     const: allwinner,sun7i-a20-gmac
-- 
2.37.4

