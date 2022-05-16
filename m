Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24C6528999
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 18:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245641AbiEPQH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 12:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245738AbiEPQHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 12:07:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C36B37A90;
        Mon, 16 May 2022 09:07:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 705A2CE16C9;
        Mon, 16 May 2022 16:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1524FC3411A;
        Mon, 16 May 2022 16:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652717265;
        bh=aSYMxoghmBGi6PfPfKaZsOsTEC8kXQeaqa+ZGO11hk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahRiq8qzeZmvXj2gpcyNfY6uxf8QpCXe5OUzQac4DziIFYOwhGI5U8rvF0Qm0JKaH
         ZnbgP+VtopvVLZ3z7tlItBnq5hI2NpgDBpH+QdT6LW1SH7Tkz3CHENfkKWUFAnUtpV
         JSaE2Z5YIRDm4UJVqhJZtAddLvBWssWoTDjlF3KGbSpD31QyVar2repVofv/TzA9If
         M+0hLSdCypvI4wg0K/mQtsSsN/jTclJuYdKIhz6VYyFw45eEqZCu0DFgCLYdVB6zac
         ah7x8kepn7jhM+bn00CP+/74Kzf4cB0Pq2zvt2pPbtcsXa2uMMPkHvKQbKC3dpHpg9
         WwEK5X0qJI1Xg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net-next 02/15] dt-bindings: net: mediatek,net: add mt7986-eth binding
Date:   Mon, 16 May 2022 18:06:29 +0200
Message-Id: <aa934c3185c9e04893d9c285ed655495a049fa4f.1652716741.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1652716741.git.lorenzo@kernel.org>
References: <cover.1652716741.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce dts bindings for mt7986 soc in mediatek,net.yaml.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../devicetree/bindings/net/mediatek,net.yaml | 141 +++++++++++++++++-
 1 file changed, 139 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mediatek,net.yaml b/Documentation/devicetree/bindings/net/mediatek,net.yaml
index 43cc4024ef98..699164dd1295 100644
--- a/Documentation/devicetree/bindings/net/mediatek,net.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek,net.yaml
@@ -21,6 +21,7 @@ properties:
       - mediatek,mt7623-eth
       - mediatek,mt7622-eth
       - mediatek,mt7629-eth
+      - mediatek,mt7986-eth
       - ralink,rt5350-eth
 
   reg:
@@ -28,7 +29,7 @@ properties:
 
   interrupts:
     minItems: 3
-    maxItems: 3
+    maxItems: 4
 
   power-domains:
     maxItems: 1
@@ -88,6 +89,9 @@ allOf:
               - mediatek,mt7623-eth
     then:
       properties:
+        interrupts:
+          maxItems: 3
+
         clocks:
           minItems: 4
           maxItems: 4
@@ -112,6 +116,9 @@ allOf:
             const: mediatek,mt7622-eth
     then:
       properties:
+        interrupts:
+          maxItems: 3
+
         clocks:
           minItems: 11
           maxItems: 11
@@ -155,6 +162,9 @@ allOf:
             const: mediatek,mt7629-eth
     then:
       properties:
+        interrupts:
+          maxItems: 3
+
         clocks:
           minItems: 17
           maxItems: 17
@@ -189,6 +199,42 @@ allOf:
           minItems: 2
           maxItems: 2
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: mediatek,mt7986-eth
+    then:
+      properties:
+        interrupts:
+          minItems: 4
+
+        clocks:
+          minItems: 15
+          maxItems: 15
+
+        clock-names:
+          items:
+            - const: fe
+            - const: gp2
+            - const: gp1
+            - const: wocpu1
+            - const: wocpu0
+            - const: sgmii_tx250m
+            - const: sgmii_rx250m
+            - const: sgmii_cdr_ref
+            - const: sgmii_cdr_fb
+            - const: sgmii2_tx250m
+            - const: sgmii2_rx250m
+            - const: sgmii2_cdr_ref
+            - const: sgmii2_cdr_fb
+            - const: netsys0
+            - const: netsys1
+
+        mediatek,sgmiisys:
+          minItems: 2
+          maxItems: 2
+
 patternProperties:
   "^mac@[0-1]$":
     type: object
@@ -219,7 +265,6 @@ required:
   - interrupts
   - clocks
   - clock-names
-  - power-domains
   - mediatek,ethsys
 
 unevaluatedProperties: false
@@ -295,3 +340,95 @@ examples:
         };
       };
     };
+
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/clock/mt7622-clk.h>
+
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+
+      eth: ethernet@15100000 {
+        #define CLK_ETH_FE_EN               0
+        #define CLK_ETH_WOCPU1_EN           3
+        #define CLK_ETH_WOCPU0_EN           4
+        #define CLK_TOP_NETSYS_SEL          43
+        #define CLK_TOP_NETSYS_500M_SEL     44
+        #define CLK_TOP_NETSYS_2X_SEL       46
+        #define CLK_TOP_SGM_325M_SEL        47
+        #define CLK_APMIXED_NET2PLL         1
+        #define CLK_APMIXED_SGMPLL          3
+
+        compatible = "mediatek,mt7986-eth";
+        reg = <0 0x15100000 0 0x80000>;
+        interrupts = <GIC_SPI 196 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 197 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 198 IRQ_TYPE_LEVEL_HIGH>,
+                     <GIC_SPI 199 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&ethsys CLK_ETH_FE_EN>,
+                 <&ethsys CLK_ETH_GP2_EN>,
+                 <&ethsys CLK_ETH_GP1_EN>,
+                 <&ethsys CLK_ETH_WOCPU1_EN>,
+                 <&ethsys CLK_ETH_WOCPU0_EN>,
+                 <&sgmiisys0 CLK_SGMII_TX250M_EN>,
+                 <&sgmiisys0 CLK_SGMII_RX250M_EN>,
+                 <&sgmiisys0 CLK_SGMII_CDR_REF>,
+                 <&sgmiisys0 CLK_SGMII_CDR_FB>,
+                 <&sgmiisys1 CLK_SGMII_TX250M_EN>,
+                 <&sgmiisys1 CLK_SGMII_RX250M_EN>,
+                 <&sgmiisys1 CLK_SGMII_CDR_REF>,
+                 <&sgmiisys1 CLK_SGMII_CDR_FB>,
+                 <&topckgen CLK_TOP_NETSYS_SEL>,
+                 <&topckgen CLK_TOP_NETSYS_SEL>;
+        clock-names = "fe", "gp2", "gp1", "wocpu1", "wocpu0",
+                      "sgmii_tx250m", "sgmii_rx250m",
+                      "sgmii_cdr_ref", "sgmii_cdr_fb",
+                      "sgmii2_tx250m", "sgmii2_rx250m",
+                      "sgmii2_cdr_ref", "sgmii2_cdr_fb",
+                      "netsys0", "netsys1";
+        mediatek,ethsys = <&ethsys>;
+        mediatek,sgmiisys = <&sgmiisys0>, <&sgmiisys1>;
+        assigned-clocks = <&topckgen CLK_TOP_NETSYS_2X_SEL>,
+                          <&topckgen CLK_TOP_SGM_325M_SEL>;
+        assigned-clock-parents = <&apmixedsys CLK_APMIXED_NET2PLL>,
+                                 <&apmixedsys CLK_APMIXED_SGMPLL>;
+
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        mdio: mdio-bus {
+          #address-cells = <1>;
+          #size-cells = <0>;
+
+          phy5: ethernet-phy@0 {
+            compatible = "ethernet-phy-id67c9.de0a";
+            phy-mode = "2500base-x";
+            reset-gpios = <&pio 6 1>;
+            reset-deassert-us = <20000>;
+            reg = <5>;
+          };
+
+          phy6: ethernet-phy@1 {
+            compatible = "ethernet-phy-id67c9.de0a";
+            phy-mode = "2500base-x";
+            reg = <6>;
+          };
+        };
+
+        mac0: mac@0 {
+          compatible = "mediatek,eth-mac";
+          phy-mode = "2500base-x";
+          phy-handle = <&phy5>;
+          reg = <0>;
+        };
+
+        mac1: mac@1 {
+          compatible = "mediatek,eth-mac";
+          phy-mode = "2500base-x";
+          phy-handle = <&phy6>;
+          reg = <1>;
+        };
+      };
+    };
-- 
2.35.3

