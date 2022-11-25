Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D18639099
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 21:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiKYUUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 15:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiKYUUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 15:20:14 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87D6554C0;
        Fri, 25 Nov 2022 12:20:13 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 60B0D5C008F;
        Fri, 25 Nov 2022 15:20:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 25 Nov 2022 15:20:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1669407613; x=1669494013; bh=4c
        1cMnkTEJZm+mQLhdjy+zCeDwbsQQc7VBHfsOzrPzM=; b=XBHa7MWT9f40zij+SK
        VM6iar65GqZ01iLF6f26SRHxGtwgdGYR419omOnLhks9GGoNzNLpmM9FR0Z8aUcF
        j62C/slPL33hI0J2d84u9AaJbIE/tck5IQKK7mN9FPKxeD5OpVqNesI+s0t+Cnw0
        JN1ft31WppGKk+GnBQI7/aLEah35srtF5WSAdOQp9v50mqDvzgkN5Gl1UWXbwK/r
        p+I7V9O1sqzBFC0g05ruGPoBXUh54Q7IyPxyLZBqezJadgSAI+6PDGk2FMV64JaR
        h5K2tKPdbEGmpaBSKsb7Jh0K5ADutWt284y1ZP2Og38U1bscH8hH4Coej2Owi5gD
        dwfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1669407613; x=1669494013; bh=4c1cMnkTEJZm+
        mQLhdjy+zCeDwbsQQc7VBHfsOzrPzM=; b=NxuXiYt74eIVw/a352okmbm8OJZLb
        1/Y22nZgdrCztlywNLJKJeHzsWHmUnTgrnEuwK9Hm9I+O/l/Co10+xfi5SDaWys8
        AMtg9jv3jCFFmiw33n8haz806nd+2r3ab0r4EG3pY4t2H34O8KBanIjzw0q5R5wX
        woI/t/AQHgZbLs83dQ3vjrWj6s7CLHskSb38DnWUS33Z+4WXpa4T2aJ+wGjjomxM
        0xnemnFPRA9eyfAnnoU0w/sTZ8gWsIFLH/5C6GQUUyZvt5NurmI5iOvJy49r2Uo9
        s+bEh3FkQSXT6LSpOOGazrFctJ7LwRgpEGfYRA5WNAxzPSY7vY295xN9w==
X-ME-Sender: <xms:fSOBY8sYIQ7d1ni5V2rDy6w0lIBL8YOQ3lQ2dNAEpTMKzp-If5b5Lw>
    <xme:fSOBY5cMeO3c8rFigDKCGbxYg_MaeZkXRQdOmYuN5jM-zen5GDBY-qPMzJXkKtrwz
    9rS39RUOw_c2Ha9qw>
X-ME-Received: <xmr:fSOBY3xeAXxCty8t1X03xLdUAWEJM38K_aGbyoSaiDNpvKN77VhFmsYb3-L2FV14aNeTCBoGePdUpxr4qEm-NL9h3LCvFP1-adiXfSrKWmp821TgJPYXAceZHJNYFuDeRin46A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrieehgddufeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhu
    vghlucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecugg
    ftrfgrthhtvghrnhepudekteeuudehtdelteevgfduvddvjefhfedulefgudevgeeghefg
    udefiedtveetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepshgrmhhuvghlsehshhholhhlrghnugdrohhrgh
X-ME-Proxy: <xmx:fSOBY_MOrO5IKanL1KbuEp0eLbFxgCHlEiJ6N9nS2ubNKFo3XZ7MZQ>
    <xmx:fSOBY89z-PJjP-6YQNKe9dcLLeQc-XU9u8jARXiSCF92aHgGd4L_NQ>
    <xmx:fSOBY3Xlj3FgxacfGY_QJ_td04H_4TF6ZiTAXstWRj54ExKov9fCCQ>
    <xmx:fSOBYwW8smdzKifE90qk0pDDOA1k6eOpwb0VTsT4N5m9u0Z0CdV-nw>
Feedback-ID: i0ad843c9:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Nov 2022 15:20:12 -0500 (EST)
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
Subject: [PATCH 2/3] dt-bindings: net: sun8i-emac: Fix snps,dwmac.yaml inheritance
Date:   Fri, 25 Nov 2022 14:20:07 -0600
Message-Id: <20221125202008.64595-3-samuel@sholland.org>
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

The sun8i-emac binding extends snps,dwmac.yaml, and should accept all
properties defined there, including "mdio", "resets", and "reset-names".
However, validation currently fails for these properties because the
local binding sets "unevaluatedProperties: false", and snps,dwmac.yaml
is only included inside an allOf block. Fix this by referencing
snps,dwmac.yaml at the top level.

Signed-off-by: Samuel Holland <samuel@sholland.org>
---

 .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml     | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
index 1432fda3b603..34a47922296d 100644
--- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
+++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
@@ -10,6 +10,8 @@ maintainers:
   - Chen-Yu Tsai <wens@csie.org>
   - Maxime Ripard <mripard@kernel.org>
 
+$ref: "snps,dwmac.yaml#"
+
 properties:
   compatible:
     oneOf:
@@ -60,7 +62,6 @@ required:
   - syscon
 
 allOf:
-  - $ref: "snps,dwmac.yaml#"
   - if:
       properties:
         compatible:
-- 
2.37.4

