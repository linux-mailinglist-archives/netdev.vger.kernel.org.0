Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BAC3FD689
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 11:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243562AbhIAJUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 05:20:54 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:37853 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243336AbhIAJUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 05:20:47 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 262F8580AF6;
        Wed,  1 Sep 2021 05:19:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 01 Sep 2021 05:19:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cerno.tech; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm3; bh=Wh2os84AeZ39d
        7kI1r3BGOSpUG+qp5Q8HILRUY1TAGQ=; b=UhrISUMqZ8U+looHsiYWbKzwmAu94
        4mgWtwYladpPFDCL3AqrAL0wvIX4M/fUUN0F8oYjwLhECe2KXZL6cQo8dWASO7CE
        95RrsMHxSUcNwnVMTmUyxYXYTKsEGE8+IlbVm7BqgOk8HIUWZu1e5+NE+Ggsbk/O
        d0X6vSnowPolHEETiODtiKboKOwosZeo4IlPYBtYB0ph/PmlbYZNSU2eKX5JvbCR
        xeEoplDNHWjBt5nV0e2gCu/5btn+PuGAhRrvkxfsPOF94GGD5EY6S71tMRUVtECk
        CYyDI54J3ktoo3YvHN4vxSsgn5sWFLV6FNdcCR4DWjZrnGDjkOYg7dIWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Wh2os84AeZ39d7kI1r3BGOSpUG+qp5Q8HILRUY1TAGQ=; b=qKB/c00o
        x5wfHBlpmhEiYMSoNhubxCG+ZcyfJ4FjNQI4859dvUexL1OY3dmzXA+IpCi1DtRf
        cMS++hyk4wXSDlGRHhUjVIqM/hxBP41lqnufHKq4wv2AHOuRepGmihx3GdrA4nAL
        Z7xy9o3IYUsGPKY2zTYQ8T2PVaRTdLdfhgfhSwc6C1iYvpvHOyaldxWsijtGAA2H
        pEbbFpLitG8l3CRhWAQ7krkqXtt3d6aWGRUlA+fMQTpJYQdIkZbb+fD5Dkov6R1n
        8P08/QLXQ90neAYease1JBDuFOYMDADXa7cF5ecksBQ9UbQf8N9Jved/okIVaGVe
        cCUwH544xI4VMA==
X-ME-Sender: <xms:tkUvYQGj7MiDRPaq5UaSn60E2WCtfsfQw_Ux77aLDR6ChLxOeYugsQ>
    <xme:tkUvYZVpFpJVatGCTWN5_CL8bxIobaYrwG-sfnpre2D_4yAgNYWYtmXj5EZR292Vt
    PrNz1zYUTyajh8Hz1M>
X-ME-Received: <xmr:tkUvYaIqI9nM4DvH26FxXp1zhUB3g73cxXa2tpDAyerXXpZt6We5Xkg8LaN5TOmsqYVzaxlfRKIfsT2AT9uStiDY4z0zM_9z4c9X>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvfedgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeforgigihhm
    vgcutfhiphgrrhguuceomhgrgihimhgvsegtvghrnhhordhtvggthheqnecuggftrfgrth
    htvghrnhepvdekleevfeffkeejhfffueelteelfeduieefheduudfggffhhfffheevveeh
    hedvnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepmh
    grgihimhgvsegtvghrnhhordhtvggthh
X-ME-Proxy: <xmx:tkUvYSEfghon1rHZ_wPV55BV1EPrVjPIirBTJYL1BnUbHDrlz9bURQ>
    <xmx:tkUvYWWrDr7MocKVp5aJ90GD9UO71HTn8D6D_TZDHBwkZvg-JHx3ow>
    <xmx:tkUvYVNUPjJlokgDRN3RfUkb40_dTKu4ghlzmDqd3po12nExqoE8Vw>
    <xmx:t0UvYfX97k9PvxP1VBOH1ogCRgK4lWJxHQlu1qEBOzgCBQgsvQscYg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Sep 2021 05:19:50 -0400 (EDT)
From:   Maxime Ripard <maxime@cerno.tech>
To:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        =?UTF-8?q?Jernej=20=C5=A0krabec?= <jernej.skrabec@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v2 31/52] dt-bindings: net: dwmac: Fix typo in the R40 compatible
Date:   Wed,  1 Sep 2021 11:18:31 +0200
Message-Id: <20210901091852.479202-32-maxime@cerno.tech>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901091852.479202-1-maxime@cerno.tech>
References: <20210901091852.479202-1-maxime@cerno.tech>
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
Reviewed-by: Rob Herring <robh@kernel.org>
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

