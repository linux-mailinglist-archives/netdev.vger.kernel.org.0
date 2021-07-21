Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D003D10A4
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 16:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238998AbhGUNYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 09:24:47 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:47177 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238984AbhGUNYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 09:24:46 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 75C4658046C;
        Wed, 21 Jul 2021 10:05:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 21 Jul 2021 10:05:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=Ea94zwXQbb3Z8
        123Qjj41Rj/cyfKIW+87Iuz3U3ONO4=; b=SdOdJM3dpf09sXH0OOSXj/mNE5XAZ
        ofowEjPVbkMlUyHC6972sowuQl667FxUZa93+OvXnN5Ctn5oLjWfbMfc5F9vazOY
        SbQHEhNYLRWynYG8n0t8S1Bt5YIPf/Tr6alVYay5wyVlUkVpbSN4aqQxt+pGsIEz
        s77zFxpL0dAdoBQ1PEB3sx2Qc7mMWKghmECS/G+/kjMUaPYAv1MbNlh8rC45Q0Et
        Nm1uDwKY6H0WvkIIrm5AaHR3M6dVvgAv/9+usgVMeA+/zAgNF1LOOzQn2UA/Qs9a
        fjTcGvHdQb7VqgOZ11C6ntvHQkKpwqd50ZmJaOQL3llnvfsGyAXDR4njg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Ea94zwXQbb3Z8123Qjj41Rj/cyfKIW+87Iuz3U3ONO4=; b=lwC9NCpX
        VKuT6qRRrhD6VEaAKT/2VfHEokntYTbQumkrt2m8b8RS6dVbKX7NT//vl9Ss1XRc
        tiCeOerOQUcBmOHnl3RUi23lT4mizIGb1q09oxBhk9Y+VRIuy7lhoushPo2fdBUG
        mrw00WuhRgX2kbvU1f1Sb+Dz1qlemUbyYc2LlhF+MXUAOMlZhcN4KhOWbb4c5CGI
        uF930LMSupE0Emk+xqL88tyF94QK5wUa8sNCjqbwl7CVHrcjupLi3BcD80BG9hZl
        2p22H17PValJaPCj9ou/bji5Z5HUWpkOPTln3oRS4V4IHeiGf4TV4ym55NE5dAiP
        liTb8e2BnRbGuQ==
X-ME-Sender: <xms:oSn4YEZ_APZMSk9hL3vGiayWZIb4aaZDKxOVOFJy6GahNeMXOAkfBA>
    <xme:oSn4YPYwDYFqXGEYuLlhfvV2-rN2E2AxOs-CoF60bHMZzv5ruGTKts9LTfgv3-yf3
    -JZpxCUkVgLLvlEcns>
X-ME-Received: <xmr:oSn4YO80wzqEQCeEE9x9EHvtrj_HXbgkaFVyBeltbL4tM259rRFx4Y7E6IfpodaEvYjUFDhqkt6MTsk5yW-9eGdDwlVvylFQIfjo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfeeggdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepofgrgihimhgv
    ucftihhprghrugcuoehmrgigihhmvgestggvrhhnohdrthgvtghhqeenucggtffrrghtth
    gvrhhnpedvkeelveefffekjefhffeuleetleefudeifeehuddugffghffhffehveevheeh
    vdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrg
    igihhmvgestggvrhhnohdrthgvtghh
X-ME-Proxy: <xmx:oSn4YOqv47k0QOWjMqQ6VMVLIulx8s9tiMalv5MHvJxOZjJtt23aLQ>
    <xmx:oSn4YPrm-QmIBy5P6h3gMhqwBC-X9r5_6IG9FBJ254cqwDN33gbwhA>
    <xmx:oSn4YMSQSgCeNTXjxE5QrKjnnLW8SWJF1Kdyd4Xwy_tgzqUbF3Tbng>
    <xmx:oin4YNh__sbYtFYhKeytOKdKn34SG3Pw8PPnerooHEXMLJrXzbmRLg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jul 2021 10:05:21 -0400 (EDT)
From:   Maxime Ripard <maxime@cerno.tech>
To:     Chen-Yu Tsai <wens@csie.org>, Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: [PATCH 26/54] dt-bindings: net: dwmac: Fix typo in the R40 compatible
Date:   Wed, 21 Jul 2021 16:03:56 +0200
Message-Id: <20210721140424.725744-27-maxime@cerno.tech>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210721140424.725744-1-maxime@cerno.tech>
References: <20210721140424.725744-1-maxime@cerno.tech>
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
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
---
 .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml  | 4 ++--
 Documentation/devicetree/bindings/net/snps,dwmac.yaml       | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
index 7f2578d48e3f..9919d1912cc1 100644
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
@@ -91,7 +91,7 @@ allOf:
         compatible:
           contains:
             enum:
-              - allwinner,sun8i-r40-emac
+              - allwinner,sun8i-r40-gmac
 
     then:
       properties:
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index d7652596a09b..6872caa05737 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -48,7 +48,7 @@ properties:
         - allwinner,sun7i-a20-gmac
         - allwinner,sun8i-a83t-emac
         - allwinner,sun8i-h3-emac
-        - allwinner,sun8i-r40-emac
+        - allwinner,sun8i-r40-gmac
         - allwinner,sun8i-v3s-emac
         - allwinner,sun50i-a64-emac
         - loongson,ls2k-dwmac
@@ -314,7 +314,7 @@ allOf:
               - allwinner,sun7i-a20-gmac
               - allwinner,sun8i-a83t-emac
               - allwinner,sun8i-h3-emac
-              - allwinner,sun8i-r40-emac
+              - allwinner,sun8i-r40-gmac
               - allwinner,sun8i-v3s-emac
               - allwinner,sun50i-a64-emac
               - ingenic,jz4775-mac
@@ -362,7 +362,7 @@ allOf:
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

