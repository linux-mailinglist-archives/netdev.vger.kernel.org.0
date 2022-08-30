Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00EB5A5FF8
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiH3J5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiH3J4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:56:19 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11BF6110D;
        Tue, 30 Aug 2022 02:56:06 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9CDD81BF203;
        Tue, 30 Aug 2022 09:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661853362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2upS5x8bELO5egxRtlEvOnCPCGAo4dfN/QbP9X8KiYE=;
        b=GW+3p7KS+9LSLOxT1YwnCCIJr7c5phma1YIsrTPD/KmfblOk0FF2a4l5KQ2ZY5sc2J9qyT
        YRPicnhAaKDK2lO5zQTb8CpwmqxwtUjDdgvIc0VLggtGL3Qw9SvngDfRpYaLwKUnNYspWb
        kZU2Kq/QDhux2ODYhNgWsr22cHgWJ+QfLID9U0tfeYAIKkAqdoIYt0bMkWmoFm1/ReuVSF
        lBvHa6LcJ+o0w1U2EMq9fn8vqXZnQAUVWrAuAGXfl+giCr5JI2+FvakjslgGMOZX5m4kHe
        rpfBGz6+F+dl5KGZz3Ygoql+qfgpxnU3nhrTiREorxO7GAtcNK4OZI/MWBUWEg==
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
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH net-next v2 5/5] dt-bindings: net: altera: tse: add an optional pcs register range
Date:   Tue, 30 Aug 2022 11:55:49 +0200
Message-Id: <20220830095549.120625-6-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220830095549.120625-1-maxime.chevallier@bootlin.com>
References: <20220830095549.120625-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
V1->V2 :
 - Fixed example

 .../devicetree/bindings/net/altr,tse.yaml     | 29 ++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/altr,tse.yaml b/Documentation/devicetree/bindings/net/altr,tse.yaml
index 1676e13b8c64..4b314861a831 100644
--- a/Documentation/devicetree/bindings/net/altr,tse.yaml
+++ b/Documentation/devicetree/bindings/net/altr,tse.yaml
@@ -39,6 +39,7 @@ allOf:
       properties:
         reg:
           minItems: 6
+          maxItems: 7
         reg-names:
           minItems: 6
           items:
@@ -48,6 +49,7 @@ allOf:
             - const: rx_resp
             - const: tx_csr
             - const: tx_desc
+            - const: pcs
 
 properties:
   compatible:
@@ -58,7 +60,7 @@ properties:
 
   reg:
     minItems: 4
-    maxItems: 6
+    maxItems: 7
 
   reg-names:
     minItems: 4
@@ -69,6 +71,7 @@ properties:
       - const: rx_resp
       - const: tx_csr
       - const: tx_desc
+      - const: pcs
       - const: s1
 
   interrupts:
@@ -122,6 +125,30 @@ required:
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
+        local-mac-address = [ 00 0C ED 00 00 02 ];
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

