Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D035416CD0
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 09:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244367AbhIXH3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 03:29:38 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:37139 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237158AbhIXH3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 03:29:35 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id AD1FB58106B;
        Fri, 24 Sep 2021 03:28:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 24 Sep 2021 03:28:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=cFDFoyaqnCn2I
        5ZksUWo2yuQAH5y0cTLJm3fOAlTUiM=; b=AuuX645LSEKLR1h3NZIzGOd2jGtWH
        wLlpw5MVuMdQMxEqIJ4ObCCqPFFryb3FT6npgGyFrFdHqniDjgshWLIvN7q6oVT8
        VRSKMpg5wW/ST7iGpSbbtERLk8AP5zEKgvw0MTJNzuJTTdvimlpVrVmLISmxJs0g
        xy1KCs77kAkFHZayPAY8QrW4U4GkuWztFeyUXZsMGaPLZIgC51Bokf3hfAjWecb/
        92+DnpGL89UTiTYblNlPwYWEzWoMixm4CW2vn20oODzWhmDkIHQXWRwKXBwY2SkW
        QcwhJTIQRKaIy4xvem6bBiQ3cuGf3ztFjoiK1/Uuslm3K9m9TNMGTFnOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=cFDFoyaqnCn2I5ZksUWo2yuQAH5y0cTLJm3fOAlTUiM=; b=B+4MOzi1
        MTE3f08DkNevqUD+1Ivg41QN7VG4cU9f5juwolojTRepHTUmQs8R2KS3MIO+QpVG
        sqFpXKFSCauCyOflitigNz4IgCZkHzFWaVEYASHhe9aH9XKODcPI6TX+I0npZomD
        1SB6fUiEeBdcIMbcQP+M6Zz563GTVgXk5Nl5faPxp7ju2sotOva5IPi+CrwT77c8
        BsiMlj/6bPeepN9igwk7QUSSgZp2KHzhh8tSsFqTzjfaFFJkdOYN/FTaAEmhPvlm
        19cyrj3vCedhdyGNLZsYdiAMPrQawZZJ6TA7cWSfW90MLDYZ1dfDTaDmycS2RtPY
        EBEfiy80ef/nTQ==
X-ME-Sender: <xms:AX5NYeiQplt0oMF8BMPzk29e2_WZT36hAWwjKa3yv7GJ6O-q6NVwbA>
    <xme:AX5NYfA-8rkGl4KJ3lodwFH-4_8DrD-EiLhcuptIFLKj-P9zGA71SeyifVaTM2ejg
    5w0aDRNBjSqkS1mtT8>
X-ME-Received: <xmr:AX5NYWHEUO00bKGf30hIF3L8dJpc61BFrG_dqeJ2X3L0f-fR2qRNLGDCfr0VcVzgfZqBZES08f2VYFv4DKArlOFBUN71gm_7yysy>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudejtddguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepofgrgihi
    mhgvucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrg
    htthgvrhhnpedvkeelveefffekjefhffeuleetleefudeifeehuddugffghffhffehveev
    heehvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hmrgigihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:AX5NYXQvIgghykbuqELaP2a4-hbml1cs3BSBANE2UfEU-FBP8i_8kQ>
    <xmx:AX5NYbwwZMDcU4pvS_g5fmx3IjaG4G7qAVf3UolRK-20AtffI8oXbA>
    <xmx:AX5NYV5EqGSaRW-KRRpNlu8u69SQxXnlrWOsV5iXL8cDIOPVxPhPcA>
    <xmx:An5NYTiH_MgfMoEF9SaJLcExsKkksL5lC2IbRZWyVDwED2HfuqENrw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Sep 2021 03:28:01 -0400 (EDT)
From:   Maxime Ripard <maxime@cerno.tech>
To:     Chen-Yu Tsai <wens@csie.org>, Maxime Ripard <maxime@cerno.tech>,
        =?UTF-8?q?Jernej=20=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-sunxi@lists.linux.dev,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: [RESEND v2 3/4] dt-bindings: net: dwmac: Fix typo in the R40 compatible
Date:   Fri, 24 Sep 2021 09:27:55 +0200
Message-Id: <20210924072756.869731-3-maxime@cerno.tech>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924072756.869731-1-maxime@cerno.tech>
References: <20210924072756.869731-1-maxime@cerno.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even though both the driver and the device trees all use the
allwinner,sun8i-r40-gmac compatible, we documented the compatible as
allwinner,sun8i-r40-emac in the binding. Let's fix this.

Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: netdev@vger.kernel.org
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
---
 .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml  | 4 ++--
 Documentation/devicetree/bindings/net/snps,dwmac.yaml       | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
index 9eb4bb529ad5..407586bc366b 100644
--- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
+++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
@@ -15,7 +15,7 @@ properties:
     oneOf:
       - const: allwinner,sun8i-a83t-emac
       - const: allwinner,sun8i-h3-emac
-      - const: allwinner,sun8i-r40-emac
+      - const: allwinner,sun8i-r40-gmac
       - const: allwinner,sun8i-v3s-emac
       - const: allwinner,sun50i-a64-emac
       - items:
@@ -93,7 +93,7 @@ allOf:
         compatible:
           contains:
             enum:
-              - allwinner,sun8i-r40-emac
+              - allwinner,sun8i-r40-gmac
 
     then:
       properties:
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 42689b7d03a2..3de8bca418f0 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -49,7 +49,7 @@ properties:
         - allwinner,sun7i-a20-gmac
         - allwinner,sun8i-a83t-emac
         - allwinner,sun8i-h3-emac
-        - allwinner,sun8i-r40-emac
+        - allwinner,sun8i-r40-gmac
         - allwinner,sun8i-v3s-emac
         - allwinner,sun50i-a64-emac
         - loongson,ls2k-dwmac
@@ -316,7 +316,7 @@ allOf:
               - allwinner,sun7i-a20-gmac
               - allwinner,sun8i-a83t-emac
               - allwinner,sun8i-h3-emac
-              - allwinner,sun8i-r40-emac
+              - allwinner,sun8i-r40-gmac
               - allwinner,sun8i-v3s-emac
               - allwinner,sun50i-a64-emac
               - ingenic,jz4775-mac
@@ -364,7 +364,7 @@ allOf:
               - allwinner,sun7i-a20-gmac
               - allwinner,sun8i-a83t-emac
               - allwinner,sun8i-h3-emac
-              - allwinner,sun8i-r40-emac
+              - allwinner,sun8i-r40-gmac
               - allwinner,sun8i-v3s-emac
               - allwinner,sun50i-a64-emac
               - loongson,ls2k-dwmac
-- 
2.31.1

