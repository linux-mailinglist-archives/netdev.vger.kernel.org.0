Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9AE95A9A89
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 16:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234901AbiIAOgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 10:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbiIAOgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 10:36:02 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C781F5465C;
        Thu,  1 Sep 2022 07:35:58 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6EDD060011;
        Thu,  1 Sep 2022 14:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662042957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NF52+xLcIEThjLiFO1gELqrQWicn4xwgjjKQhbMn/D4=;
        b=X26EB0e1agGhOGxUST4DGOlNm9LO+GVXfQ4qDtr8AgiM/BhTq0pCvzxHL2XmxPi6WVuvLD
        6Wfx8Xa6O2BEyPDdONCviVJR3VvWF80FSd+IFtrkuyvEUuRlx0yEVBybIB+o+GOTPIYI0d
        f8dskRMeX57oJAmd/KKRhxMIyQHG0q1eFqwx37PMQg0fzMIOSelazl9hivv68bfr2pEOWB
        Pr8daWouejF3ObKpWvKSynRrrKh5q58JjrB/7eStXvErQbZaOBrk74iHLnrH7U1DR+ziq5
        +/caSBSSwlceUMF43crIuNfbgIJRrNj3VOjlLE3qpO0f7cudgUF9xgOian6K2g==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v3 5/5] dt-bindings: net: altera: tse: add an optional pcs register range
Date:   Thu,  1 Sep 2022 16:35:43 +0200
Message-Id: <20220901143543.416977-6-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220901143543.416977-1-maxime.chevallier@bootlin.com>
References: <20220901143543.416977-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some implementations of the TSE have their PCS as an external bloc,
exposed at its own register range. Document this, and add a new example
showing a case using the pcs and the new phylink conversion to connect
an sfp port to a TSE mac.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V2->V3 :
 - Fixed construct of reg/reg-names
 - Fixed example to use an all-zero mac-addr
V1->V2 :
 - Fixed example

 .../devicetree/bindings/net/altr,tse.yaml     | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/altr,tse.yaml b/Documentation/devicetree/bindings/net/altr,tse.yaml
index 78c7a2047910..8d1d94494349 100644
--- a/Documentation/devicetree/bindings/net/altr,tse.yaml
+++ b/Documentation/devicetree/bindings/net/altr,tse.yaml
@@ -95,7 +95,9 @@ allOf:
       properties:
         reg:
           minItems: 6
+          maxItems: 7
         reg-names:
+          minItems: 6
           items:
             - const: control_port
             - const: rx_csr
@@ -103,10 +105,35 @@ allOf:
             - const: rx_resp
             - const: tx_csr
             - const: tx_desc
+            - const: pcs
 
 unevaluatedProperties: false
 
 examples:
+  - |
+    tse_sub_0: ethernet@c0100000 {
+        compatible = "altr,tse-msgdma-1.0";
+        reg = <0xc0100000 0x00000400>,
+              <0xc0101000 0x00000020>,
+              <0xc0102000 0x00000020>,
+              <0xc0103000 0x00000008>,
+              <0xc0104000 0x00000020>,
+              <0xc0105000 0x00000020>,
+              <0xc0106000 0x00000100>;
+        reg-names = "control_port", "rx_csr", "rx_desc", "rx_resp", "tx_csr", "tx_desc", "pcs";
+        interrupt-parent = <&intc>;
+        interrupts = <0 44 4>,<0 45 4>;
+        interrupt-names = "rx_irq","tx_irq";
+        rx-fifo-depth = <2048>;
+        tx-fifo-depth = <2048>;
+        max-frame-size = <1500>;
+        local-mac-address = [ 00 00 00 00 00 00 ];
+        altr,has-supplementary-unicast;
+        altr,has-hash-multicast-filter;
+        sfp = <&sfp0>;
+        phy-mode = "sgmii";
+        managed = "in-band-status";
+    };
   - |
     tse_sub_1_eth_tse_0: ethernet@1,00001000 {
         compatible = "altr,tse-msgdma-1.0";
-- 
2.37.2

