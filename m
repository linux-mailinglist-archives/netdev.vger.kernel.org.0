Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74DCD52F226
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352436AbiETSMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352435AbiETSM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:12:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DDC18C064;
        Fri, 20 May 2022 11:12:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF66BB82D90;
        Fri, 20 May 2022 18:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA46BC34118;
        Fri, 20 May 2022 18:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653070344;
        bh=H60Wh+bnJHjx+ZsgY6FYl2p/uE81sYQWMHIPyF7iYtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LxIif3A2b8O7l6j75jjy8dWKZDajpGQjSoCGgLcjL05kqz88YR9PJz4APlVCTNWQ+
         DpwZQlwM4XOgXDwL7x3ADH+zZyLp0nHc5d/3PJIkIDIlbuKVtjq8GJFHUmQle1ZFZF
         ISwmshCUHfiXBKBFyJtwecBPvHDbTbqhQCDFzS3qaMpQVPLAUWFwbUQV/9KX4gtmtV
         ODBxgr8/6UgInoyS2i4mf/aUP2YOJM5QsV5PXH45qighIDd5HcRoiR4QQNzQn/SEHi
         O8ECfAdsBJPsBlqDkpPrl2hE7NkDqNMqYB6JfKYnqWXvbg9p73eD+tJIyrM8ttk57A
         a+/vqjUPL2Eig==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v3 net-next 02/16] dt-bindings: net: mediatek,net: add mt7986-eth binding
Date:   Fri, 20 May 2022 20:11:25 +0200
Message-Id: <ac939187e5953713703102bad1709b2639473d21.1653069056.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653069056.git.lorenzo@kernel.org>
References: <cover.1653069056.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce dts bindings for mt7986 soc in mediatek,net.yaml.

Reviewed-by: Rob Herring <robh@kernel.org>
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

