Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2330C6B853C
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjCMWwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjCMWwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:52:08 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0264512866;
        Mon, 13 Mar 2023 15:51:40 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 19318E0EB2;
        Tue, 14 Mar 2023 01:51:08 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=pK/cCmy7hQrJyE9NQeB9yO2KIq8yqVfTtGldxs03tag=; b=U7y0JqJZtuQk
        TZbJt1w2qXDtOvlw+MFw+lU2b/i7IxrJ0odcBIOIq3uAqDxT6HwpQDxrFhYDhVla
        DqnKru53elR3fQ/RIOOTVo6EsI1HSVORdl6lOMv3/lmWXeQ7a5dWz9bR93RGMoNs
        jOTmLTyCHgVdOihClF39lFNerh2dxPI=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 025FDE0E6A;
        Tue, 14 Mar 2023 01:51:08 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:51:07 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Rob Herring <robh@kernel.org>
Subject: [PATCH net-next 01/16] dt-bindings: net: dwmac: Validate PBL for all IP-cores
Date:   Tue, 14 Mar 2023 01:50:48 +0300
Message-ID: <20230313225103.30512-2-Sergey.Semin@baikalelectronics.ru>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.8.30.10]
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indeed the maximum DMA burst length can be programmed not only for DW
xGMACs, Allwinner EMACs and Spear SoC GMAC, but in accordance with [1]
for Generic DW *MAC IP-cores. Moreover the STMMAC set of drivers parse
the property and then apply the configuration for all supported DW MAC
devices. All of that makes the property being available for all IP-cores
the bindings supports. Let's make sure the PBL-related properties are
validated for all of them by the common DW MAC DT schema.

[1] DesignWare Cores Ethernet MAC Universal Databook, Revision 3.73a,
    October 2013, p. 380.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Rob Herring <robh@kernel.org>

---

Changelog v1:
- Use correct syntax of the JSON pointers, so the later would begin
  with a '/' after the '#'.
---
 .../devicetree/bindings/net/snps,dwmac.yaml   | 77 +++++++------------
 1 file changed, 26 insertions(+), 51 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 16b7d2904696..a0a0437eb4f0 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -426,6 +426,32 @@ properties:
     description:
       Use Address-Aligned Beats
 
+  snps,pbl:
+    description:
+      Programmable Burst Length (tx and rx)
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [2, 4, 8]
+
+  snps,txpbl:
+    description:
+      Tx Programmable Burst Length. If set, DMA tx will use this
+      value rather than snps,pbl.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [2, 4, 8]
+
+  snps,rxpbl:
+    description:
+      Rx Programmable Burst Length. If set, DMA rx will use this
+      value rather than snps,pbl.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [2, 4, 8]
+
+  snps,no-pbl-x8:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      Don\'t multiply the pbl/txpbl/rxpbl values by 8. For core
+      rev < 3.50, don\'t multiply the values by 4.
+
   snps,fixed-burst:
     $ref: /schemas/types.yaml#/definitions/flag
     description:
@@ -556,57 +582,6 @@ dependencies:
 
 allOf:
   - $ref: "ethernet-controller.yaml#"
-  - if:
-      properties:
-        compatible:
-          contains:
-            enum:
-              - allwinner,sun7i-a20-gmac
-              - allwinner,sun8i-a83t-emac
-              - allwinner,sun8i-h3-emac
-              - allwinner,sun8i-r40-gmac
-              - allwinner,sun8i-v3s-emac
-              - allwinner,sun50i-a64-emac
-              - ingenic,jz4775-mac
-              - ingenic,x1000-mac
-              - ingenic,x1600-mac
-              - ingenic,x1830-mac
-              - ingenic,x2000-mac
-              - snps,dwmac-3.50a
-              - snps,dwmac-4.10a
-              - snps,dwmac-4.20a
-              - snps,dwxgmac
-              - snps,dwxgmac-2.10
-              - st,spear600-gmac
-
-    then:
-      properties:
-        snps,pbl:
-          description:
-            Programmable Burst Length (tx and rx)
-          $ref: /schemas/types.yaml#/definitions/uint32
-          enum: [1, 2, 4, 8, 16, 32]
-
-        snps,txpbl:
-          description:
-            Tx Programmable Burst Length. If set, DMA tx will use this
-            value rather than snps,pbl.
-          $ref: /schemas/types.yaml#/definitions/uint32
-          enum: [1, 2, 4, 8, 16, 32]
-
-        snps,rxpbl:
-          description:
-            Rx Programmable Burst Length. If set, DMA rx will use this
-            value rather than snps,pbl.
-          $ref: /schemas/types.yaml#/definitions/uint32
-          enum: [1, 2, 4, 8, 16, 32]
-
-        snps,no-pbl-x8:
-          $ref: /schemas/types.yaml#/definitions/flag
-          description:
-            Don\'t multiply the pbl/txpbl/rxpbl values by 8. For core
-            rev < 3.50, don\'t multiply the values by 4.
-
   - if:
       properties:
         compatible:
-- 
2.39.2


