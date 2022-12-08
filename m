Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4846468F7
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 07:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiLHGQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 01:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLHGQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 01:16:22 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46539AE12;
        Wed,  7 Dec 2022 22:16:21 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 73ECA320029B;
        Thu,  8 Dec 2022 01:16:19 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 08 Dec 2022 01:16:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm2; t=1670480178; x=1670566578; bh=x0me3RKZeq0yeb9T+A/Cz7qCe
        2YIzalCfRlQG3BTeKE=; b=K2oJX4eFTEWB9WOxAJUc23gDWQ8FAWBMusXLae2tW
        P6Zh0RT3DqkvyIQQE02DxwlutY2ZNjMz2h7+VHeDCfKE9fxGeJeEgub+nLhJQRND
        KPuI2r+NIskj/JylWfrTBntujKb0TFA2w2qETg8+wOVpQQoc/8QOgykkg3BGMtHI
        BhRa2PDrMILL1kWFVSo8fz5VGuDoushbvd5w04yOxB2R9ZCFi4z8jJA4RFXmtugW
        bCfDeL9ynrhOTH/lV7NPJvw3jUe/UsK+6L7VQZNRZ44E9uql8DAo7gIpD2Gsh8tl
        M0xSG+92z08PmJWQnDgfUZ/kXNpSL5n44b3qhrZ9p3hhA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1670480178; x=1670566578; bh=x0me3RKZeq0yeb9T+A/Cz7qCe2YIzalCfRl
        QG3BTeKE=; b=NZRvslDJ35NLwJfLfOKpottBlDkIoqAcMjQiNRJBy6piuqEOqfJ
        icyHbG4Mtb+YirsBhlKo1e2NiHobJXllhAlWrA93RCdxV3oUF3KY7o/9xeW6PG/p
        xabCCfQI/xzgrRj55CdfI6loXvBRcrFlzjLmUut/IlIoGOCzRDzlMILBLynzpDJW
        iWvV5CIuBlUJPf3EAmf9b5cU5lHobXVHJU1L8lwjR68N2lfLeMnIjSSGH+3zG9Pn
        sETQOpl05IWu6wmhg8eDV4jGOcEnmbCWpszx0qI9YPflKhCmKS3Ufz0ADVzjsWT7
        ftaG5sYsjYt2a8Rki0cNF7HYsgrF8/t+fQw==
X-ME-Sender: <xms:MoGRY8U5eOBbbzsGsJjDycaXhpuajJdHZXBapPc1yj6I9lIpfbq7RQ>
    <xme:MoGRYwmzqfaKt3IZB7FSM-CNISNNJH34HObu1JRBvvHj3r5I_DHSr9YGvMGCN1nfx
    aVuff55MfQLw5LiSg>
X-ME-Received: <xmr:MoGRYwapx06IkOpboMsipny0lGLTw2-DEgp1I8BLWwy8gc7plN8-5ArwAjUfB-RQ41LXaoMBCUy7Hxckzl4gRtCXKK1quiyocSjlh1sp7hDTLm6lAafYVwlMPCkZazxltFYPmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudelgdelhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgvlhcu
    jfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtffrrg
    htthgvrhhnpeekveelhfejueelleetvdejvdeffeetgeelheeujeffhefgffefkeehhffh
    keekgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hsrghmuhgvlhesshhhohhllhgrnhgurdhorhhg
X-ME-Proxy: <xmx:MoGRY7XHSTdwRUN0PBCA6yc6vG6477iQCZyOoT7diDvetfv5wNo5pQ>
    <xmx:MoGRY2lq9iAJmJkoAsQ1QWPRUcPEGmOfy9WP9mWX2uV0oFQbT0EarA>
    <xmx:MoGRYwdBOBQVqQklUK2inER0ny6GM1GmpBI-j78MrqKDPbyarfTL6A>
    <xmx:MoGRYw3d_BzNbdPXeim_HbCYEiJwxbpQmYcx1mGJOhvPSyBop9BC4Q>
Feedback-ID: i0ad843c9:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Dec 2022 01:16:17 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Samuel Holland <samuel@sholland.org>,
        Rob Herring <robh@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        LABBE Corentin <clabbe.montjoie@gmail.com>,
        Maxime Ripard <mripard@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org
Subject: [PATCH v2] dt-bindings: net: sun8i-emac: Add phy-supply property
Date:   Thu,  8 Dec 2022 00:16:16 -0600
Message-Id: <20221208061616.7806-1-samuel@sholland.org>
X-Mailer: git-send-email 2.37.4
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

This property has always been supported by the Linux driver; see
commit 9f93ac8d4085 ("net-next: stmmac: Add dwmac-sun8i"). In fact, the
original driver submission includes the phy-supply code but no mention
of it in the binding, so the omission appears to be accidental. In
addition, the property is documented in the binding for the previous
hardware generation, allwinner,sun7i-a20-gmac.

Document phy-supply in the binding to fix devicetree validation for the
25+ boards that already use this property.

Fixes: 0441bde003be ("dt-bindings: net-next: Add DT bindings documentation for Allwinner dwmac-sun8i")
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
---

Changes in v2:
 - Drop the rest of the series, which was obsoleted by the dt-schema fix
 - Add Acked-by/Reviewed-by tags

 .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml     | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
index 1432fda3b603..47bc2057e629 100644
--- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
+++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
@@ -40,6 +40,9 @@ properties:
   clock-names:
     const: stmmaceth
 
+  phy-supply:
+    description: PHY regulator
+
   syscon:
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
-- 
2.37.4

