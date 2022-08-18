Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F00D5980A7
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 11:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiHRJRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 05:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238208AbiHRJRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 05:17:36 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE5967CB9;
        Thu, 18 Aug 2022 02:17:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660814219; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=EIsC7FHOjXOlY5bTlhQwiggONhG2wvuJkKRV9XDBEvkYkhz5JxGIu7JoFrTwWbWrtbBqCpSkb2ACbC0VG+K8/UdHqwOUwMVu1CR9UCP0aaz39dmRc12NdMf5pn012Oxm1d0Ke7/G7lq7S0OVOJtncq/Jp0kOQhj0zpb+vVbk7sQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660814219; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=H5il8SQXZ0PUGfPI0E3JkFSwueZxe2N6hD1oee9wSV4=; 
        b=X58HP+jpMWyRagRKBKPQuDr9qBshq9q4UxSrLugB3xv4Ee2dqcH6v855wARSKF85Senuw6MlhTF/XiJwGcQYNBEjyJM3KrEnpNgdGoYu7B81xFLViJ/LXJQhgfs2EMdD0zzKtbl94ISNdPvD4l4Nqdigds2fwXSDrTRUBdi82NQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660814219;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=H5il8SQXZ0PUGfPI0E3JkFSwueZxe2N6hD1oee9wSV4=;
        b=ZHZGM3qxhGu1Exq2WOUYd3seDJwPVn1wEaiKdTZMxVHnrKMlKhmrGJf4+2Rjl2La
        vGc9ZTSCTcT81d+1QmHFv0CRaRcD2zaQZ4um+43E5ZzhlkAPUfdH+PTcQ6R3aojope9
        6QhrBnDbpvAWFSx1SvdjysSXhyjHXrg4k0c1t2nA=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1660814217619717.9051921463371; Thu, 18 Aug 2022 02:16:57 -0700 (PDT)
From:   =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH v3 3/6] dt-bindings: net: dsa: mediatek,mt7530: update examples
Date:   Thu, 18 Aug 2022 12:16:24 +0300
Message-Id: <20220818091627.51878-4-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818091627.51878-1-arinc.unal@arinc9.com>
References: <20220818091627.51878-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the examples on the binding.

- Add examples which include a wide variation of configurations.
- Make example comments YAML comment instead of DT binding comment.
- Add interrupt controller to the examples. Include header file for
interrupt.
- Change reset line for MT7621 examples.
- Pretty formatting for the examples.
- Change switch reg to 0.
- Change port labels to fit the example, change port 4 label to wan.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 402 +++++++++++++++---
 1 file changed, 347 insertions(+), 55 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 4c99266ce82a..657e162a1c01 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -210,42 +210,111 @@ allOf:
 unevaluatedProperties: false
 
 examples:
+  # Example 1: Standalone MT7530
   - |
     #include <dt-bindings/gpio/gpio.h>
+
     mdio {
         #address-cells = <1>;
         #size-cells = <0>;
+
         switch@0 {
             compatible = "mediatek,mt7530";
             reg = <0>;
 
+            reset-gpios = <&pio 33 0>;
+
             core-supply = <&mt6323_vpa_reg>;
             io-supply = <&mt6323_vemc3v3_reg>;
-            reset-gpios = <&pio 33 GPIO_ACTIVE_HIGH>;
 
             ethernet-ports {
                 #address-cells = <1>;
                 #size-cells = <0>;
+
                 port@0 {
                     reg = <0>;
-                    label = "lan0";
+                    label = "lan1";
                 };
 
                 port@1 {
                     reg = <1>;
-                    label = "lan1";
+                    label = "lan2";
                 };
 
                 port@2 {
                     reg = <2>;
-                    label = "lan2";
+                    label = "lan3";
                 };
 
                 port@3 {
                     reg = <3>;
+                    label = "lan4";
+                };
+
+                port@4 {
+                    reg = <4>;
+                    label = "wan";
+                };
+
+                port@6 {
+                    reg = <6>;
+                    label = "cpu";
+                    ethernet = <&gmac0>;
+                    phy-mode = "rgmii";
+
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                        pause;
+                    };
+                };
+            };
+        };
+    };
+
+  # Example 2: MT7530 in MT7623AI SoC
+  - |
+    #include <dt-bindings/reset/mt2701-resets.h>
+
+    mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        switch@0 {
+            compatible = "mediatek,mt7530";
+            reg = <0>;
+
+            mediatek,mcm;
+            resets = <&ethsys MT2701_ETHSYS_MCM_RST>;
+            reset-names = "mcm";
+
+            core-supply = <&mt6323_vpa_reg>;
+            io-supply = <&mt6323_vemc3v3_reg>;
+
+            ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                    reg = <0>;
+                    label = "lan1";
+                };
+
+                port@1 {
+                    reg = <1>;
+                    label = "lan2";
+                };
+
+                port@2 {
+                    reg = <2>;
                     label = "lan3";
                 };
 
+                port@3 {
+                    reg = <3>;
+                    label = "lan4";
+                };
+
                 port@4 {
                     reg = <4>;
                     label = "wan";
@@ -256,85 +325,219 @@ examples:
                     label = "cpu";
                     ethernet = <&gmac0>;
                     phy-mode = "trgmii";
+
                     fixed-link {
                         speed = <1000>;
                         full-duplex;
+                        pause;
                     };
                 };
             };
         };
     };
 
+  # Example 3: Standalone MT7531
   - |
-    //Example 2: MT7621: Port 4 is WAN port: 2nd GMAC -> Port 5 -> PHY port 4.
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
 
-    ethernet {
+    mdio {
         #address-cells = <1>;
         #size-cells = <0>;
-        gmac0: mac@0 {
-            compatible = "mediatek,eth-mac";
+
+        switch@0 {
+            compatible = "mediatek,mt7531";
             reg = <0>;
-            phy-mode = "rgmii";
 
-            fixed-link {
-                speed = <1000>;
-                full-duplex;
-                pause;
+            reset-gpios = <&pio 54 0>;
+
+            interrupt-controller;
+            #interrupt-cells = <1>;
+            interrupt-parent = <&pio>;
+            interrupts = <53 IRQ_TYPE_LEVEL_HIGH>;
+
+            ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                    reg = <0>;
+                    label = "lan1";
+                };
+
+                port@1 {
+                    reg = <1>;
+                    label = "lan2";
+                };
+
+                port@2 {
+                    reg = <2>;
+                    label = "lan3";
+                };
+
+                port@3 {
+                    reg = <3>;
+                    label = "lan4";
+                };
+
+                port@4 {
+                    reg = <4>;
+                    label = "wan";
+                };
+
+                port@6 {
+                    reg = <6>;
+                    label = "cpu";
+                    ethernet = <&gmac0>;
+                    phy-mode = "2500base-x";
+
+                    fixed-link {
+                        speed = <2500>;
+                        full-duplex;
+                        pause;
+                    };
+                };
             };
         };
+    };
+
+  # Example 4: MT7530 in MT7621AT, MT7621DAT and MT7621ST SoCs
+  - |
+    #include <dt-bindings/interrupt-controller/mips-gic.h>
+    #include <dt-bindings/reset/mt7621-reset.h>
 
-        gmac1: mac@1 {
+    mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        switch@0 {
+            compatible = "mediatek,mt7621";
+            reg = <0>;
+
+            mediatek,mcm;
+            resets = <&sysc MT7621_RST_MCM>;
+            reset-names = "mcm";
+
+            interrupt-controller;
+            #interrupt-cells = <1>;
+            interrupt-parent = <&gic>;
+            interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
+
+            ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                    reg = <0>;
+                    label = "lan1";
+                };
+
+                port@1 {
+                    reg = <1>;
+                    label = "lan2";
+                };
+
+                port@2 {
+                    reg = <2>;
+                    label = "lan3";
+                };
+
+                port@3 {
+                    reg = <3>;
+                    label = "lan4";
+                };
+
+                port@4 {
+                    reg = <4>;
+                    label = "wan";
+                };
+
+                port@6 {
+                    reg = <6>;
+                    label = "cpu";
+                    ethernet = <&gmac0>;
+                    phy-mode = "trgmii";
+
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                        pause;
+                    };
+                };
+            };
+        };
+    };
+
+  # Example 5: MT7621: mux MT7530's phy4 to SoC's gmac1
+  - |
+    #include <dt-bindings/interrupt-controller/mips-gic.h>
+    #include <dt-bindings/reset/mt7621-reset.h>
+
+    ethernet {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        pinctrl-names = "default";
+        pinctrl-0 = <&rgmii2_pins>;
+
+        mac@1 {
             compatible = "mediatek,eth-mac";
             reg = <1>;
-            phy-mode = "rgmii-txid";
-            phy-handle = <&phy4>;
+
+            phy-mode = "rgmii";
+            phy-handle = <&example5_ethphy4>;
         };
 
-        mdio: mdio-bus {
+        mdio {
             #address-cells = <1>;
             #size-cells = <0>;
 
-            /* Internal phy */
-            phy4: ethernet-phy@4 {
+            /* MT7530's phy4 */
+            example5_ethphy4: ethernet-phy@4 {
                 reg = <4>;
             };
 
-            mt7530: switch@1f {
+            switch@0 {
                 compatible = "mediatek,mt7621";
-                reg = <0x1f>;
-                mediatek,mcm;
+                reg = <0>;
 
-                resets = <&rstctrl 2>;
+                mediatek,mcm;
+                resets = <&sysc MT7621_RST_MCM>;
                 reset-names = "mcm";
 
+                interrupt-controller;
+                #interrupt-cells = <1>;
+                interrupt-parent = <&gic>;
+                interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
+
                 ethernet-ports {
                     #address-cells = <1>;
                     #size-cells = <0>;
 
                     port@0 {
                         reg = <0>;
-                        label = "lan0";
+                        label = "lan1";
                     };
 
                     port@1 {
                         reg = <1>;
-                        label = "lan1";
+                        label = "lan2";
                     };
 
                     port@2 {
                         reg = <2>;
-                        label = "lan2";
+                        label = "lan3";
                     };
 
                     port@3 {
                         reg = <3>;
-                        label = "lan3";
+                        label = "lan4";
                     };
 
-                    /* Commented out. Port 4 is handled by 2nd GMAC.
+                    /* Commented out, phy4 is muxed to gmac1.
                     port@4 {
                         reg = <4>;
-                        label = "lan4";
+                        label = "wan";
                     };
                     */
 
@@ -342,7 +545,7 @@ examples:
                         reg = <6>;
                         label = "cpu";
                         ethernet = <&gmac0>;
-                        phy-mode = "rgmii";
+                        phy-mode = "trgmii";
 
                         fixed-link {
                             speed = <1000>;
@@ -355,82 +558,171 @@ examples:
         };
     };
 
+  # Example 6: MT7621: mux external phy to SoC's gmac1
   - |
-    //Example 3: MT7621: Port 5 is connected to external PHY: Port 5 -> external PHY.
+    #include <dt-bindings/interrupt-controller/mips-gic.h>
+    #include <dt-bindings/reset/mt7621-reset.h>
 
     ethernet {
         #address-cells = <1>;
         #size-cells = <0>;
-        gmac_0: mac@0 {
+
+        pinctrl-names = "default";
+        pinctrl-0 = <&rgmii2_pins>;
+
+        mac@1 {
             compatible = "mediatek,eth-mac";
-            reg = <0>;
+            reg = <1>;
+
             phy-mode = "rgmii";
+            phy-handle = <&example6_ethphy7>;
+        };
+
+        mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            /* External PHY */
+            example6_ethphy7: ethernet-phy@7 {
+                reg = <7>;
+                phy-mode = "rgmii";
+            };
+
+            switch@0 {
+                compatible = "mediatek,mt7621";
+                reg = <0>;
+
+                mediatek,mcm;
+                resets = <&sysc MT7621_RST_MCM>;
+                reset-names = "mcm";
+
+                interrupt-controller;
+                #interrupt-cells = <1>;
+                interrupt-parent = <&gic>;
+                interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
+
+                ethernet-ports {
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+
+                    port@0 {
+                        reg = <0>;
+                        label = "lan1";
+                    };
+
+                    port@1 {
+                        reg = <1>;
+                        label = "lan2";
+                    };
+
+                    port@2 {
+                        reg = <2>;
+                        label = "lan3";
+                    };
+
+                    port@3 {
+                        reg = <3>;
+                        label = "lan4";
+                    };
+
+                    port@4 {
+                        reg = <4>;
+                        label = "wan";
+                    };
 
-            fixed-link {
-                speed = <1000>;
-                full-duplex;
-                pause;
+                    port@6 {
+                        reg = <6>;
+                        label = "cpu";
+                        ethernet = <&gmac0>;
+                        phy-mode = "trgmii";
+
+                        fixed-link {
+                            speed = <1000>;
+                            full-duplex;
+                            pause;
+                        };
+                    };
+                };
             };
         };
+    };
 
-        mdio0: mdio-bus {
+  # Example 7: MT7621: mux external phy to MT7530's port 5
+  - |
+    #include <dt-bindings/interrupt-controller/mips-gic.h>
+    #include <dt-bindings/reset/mt7621-reset.h>
+
+    ethernet {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        pinctrl-names = "default";
+        pinctrl-0 = <&rgmii2_pins>;
+
+        mdio {
             #address-cells = <1>;
             #size-cells = <0>;
 
-            /* External phy */
-            ephy5: ethernet-phy@7 {
+            /* External PHY */
+            example7_ethphy7: ethernet-phy@7 {
                 reg = <7>;
+                phy-mode = "rgmii";
             };
 
-            switch@1f {
+            switch@0 {
                 compatible = "mediatek,mt7621";
-                reg = <0x1f>;
-                mediatek,mcm;
+                reg = <0>;
 
-                resets = <&rstctrl 2>;
+                mediatek,mcm;
+                resets = <&sysc MT7621_RST_MCM>;
                 reset-names = "mcm";
 
+                interrupt-controller;
+                #interrupt-cells = <1>;
+                interrupt-parent = <&gic>;
+                interrupts = <GIC_SHARED 23 IRQ_TYPE_LEVEL_HIGH>;
+
                 ethernet-ports {
                     #address-cells = <1>;
                     #size-cells = <0>;
 
                     port@0 {
                         reg = <0>;
-                        label = "lan0";
+                        label = "lan1";
                     };
 
                     port@1 {
                         reg = <1>;
-                        label = "lan1";
+                        label = "lan2";
                     };
 
                     port@2 {
                         reg = <2>;
-                        label = "lan2";
+                        label = "lan3";
                     };
 
                     port@3 {
                         reg = <3>;
-                        label = "lan3";
+                        label = "lan4";
                     };
 
                     port@4 {
                         reg = <4>;
-                        label = "lan4";
+                        label = "wan";
                     };
 
                     port@5 {
                         reg = <5>;
-                        label = "lan5";
-                        phy-mode = "rgmii";
-                        phy-handle = <&ephy5>;
+                        label = "extphy";
+                        phy-mode = "rgmii-txid";
+                        phy-handle = <&example7_ethphy7>;
                     };
 
-                    cpu_port0: port@6 {
+                    port@6 {
                         reg = <6>;
                         label = "cpu";
-                        ethernet = <&gmac_0>;
-                        phy-mode = "rgmii";
+                        ethernet = <&gmac0>;
+                        phy-mode = "trgmii";
 
                         fixed-link {
                             speed = <1000>;
-- 
2.34.1

