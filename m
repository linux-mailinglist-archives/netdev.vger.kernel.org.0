Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32944546B55
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346466AbiFJRGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344980AbiFJRGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:06:13 -0400
Received: from mxout2.routing.net (mxout2.routing.net [IPv6:2a03:2900:1:a::b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5E327FE2;
        Fri, 10 Jun 2022 10:06:10 -0700 (PDT)
Received: from mxbox2.masterlogin.de (unknown [192.168.10.89])
        by mxout2.routing.net (Postfix) with ESMTP id 27A505FBCB;
        Fri, 10 Jun 2022 17:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1654880768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xWhTK4R919gzcw8H7A5SmTbiVYCMiIHiCGx1oIL6MOA=;
        b=F/CaaZqZrYtfOBplU1tsgFHTl4qxQTtoMYMIXgeF5uiVRQhSdXc/AIN8tNHaRkw4JxsobS
        9z2s057vu034EUoNa6EjVZpp6JCsbw7SFDKNOGTsgWdlmn9VqZOlLCeBVH7NAUHGDttUtU
        VGQDRpTgmNlmTdriCHJ1EnJJpCILJPo=
Received: from frank-G5.. (fttx-pool-217.61.154.155.bambit.de [217.61.154.155])
        by mxbox2.masterlogin.de (Postfix) with ESMTPSA id 5E78B100394;
        Fri, 10 Jun 2022 17:06:06 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-rockchip@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>
Subject: [PATCH v4 1/6] dt-bindings: net: dsa: convert binding for mediatek switches
Date:   Fri, 10 Jun 2022 19:05:36 +0200
Message-Id: <20220610170541.8643-2-linux@fw-web.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610170541.8643-1-linux@fw-web.de>
References: <20220610170541.8643-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: c5560985-c828-4dd8-8779-5dd5ffb6263b
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

Convert txt binding to yaml binding for Mediatek switches.

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
---
v4:
- fix squash of port 5 as cpu-port
- drop type from interrupt-controller and add depency for this
- use ethernet-ports in examples
- drop address-/size-cells

v3:
- include standalone patch in mt7530 series
- drop some descriptions (gpio-cells,reset-gpios,reset-names)
- drop | from descriptions
- move patternProperties above allOf

v2:
- rename mediatek.yaml => mediatek,mt7530.yaml
- drop "boolean" in description
- drop description for interrupt-properties
- drop #interrupt-cells as requirement
- example: eth=>ethernet,mdio0=>mdio,comment indention
- replace 0 by GPIO_ACTIVE_HIGH in first example
- use port(s)-pattern from dsa.yaml
- adress/size-cells not added to required because this
  is defined at mdio-level inc current dts , not switch level
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 406 ++++++++++++++++++
 .../devicetree/bindings/net/dsa/mt7530.txt    | 327 --------------
 2 files changed, 406 insertions(+), 327 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/mt7530.txt

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
new file mode 100644
index 000000000000..112cfaa7e3f6
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -0,0 +1,406 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/mediatek,mt7530.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Mediatek MT7530 Ethernet switch
+
+maintainers:
+  - Sean Wang <sean.wang@mediatek.com>
+  - Landen Chao <Landen.Chao@mediatek.com>
+  - DENG Qingfang <dqfext@gmail.com>
+
+description: |
+  Port 5 of mt7530 and mt7621 switch is muxed between:
+  1. GMAC5: GMAC5 can interface with another external MAC or PHY.
+  2. PHY of port 0 or port 4: PHY interfaces with an external MAC like 2nd GMAC
+     of the SOC. Used in many setups where port 0/4 becomes the WAN port.
+     Note: On a MT7621 SOC with integrated switch: 2nd GMAC can only connected to
+       GMAC5 when the gpios for RGMII2 (GPIO 22-33) are not used and not
+       connected to external component!
+
+  Port 5 modes/configurations:
+  1. Port 5 is disabled and isolated: An external phy can interface to the 2nd
+     GMAC of the SOC.
+     In the case of a build-in MT7530 switch, port 5 shares the RGMII bus with 2nd
+     GMAC and an optional external phy. Mind the GPIO/pinctl settings of the SOC!
+  2. Port 5 is muxed to PHY of port 0/4: Port 0/4 interfaces with 2nd GMAC.
+     It is a simple MAC to PHY interface, port 5 needs to be setup for xMII mode
+     and RGMII delay.
+  3. Port 5 is muxed to GMAC5 and can interface to an external phy.
+     Port 5 becomes an extra switch port.
+     Only works on platform where external phy TX<->RX lines are swapped.
+     Like in the Ubiquiti ER-X-SFP.
+  4. Port 5 is muxed to GMAC5 and interfaces with the 2nd GAMC as 2nd CPU port.
+     Currently a 2nd CPU port is not supported by DSA code.
+
+  Depending on how the external PHY is wired:
+  1. normal: The PHY can only connect to 2nd GMAC but not to the switch
+  2. swapped: RGMII TX, RX are swapped; external phy interface with the switch as
+     a ethernet port. But can't interface to the 2nd GMAC.
+
+    Based on the DT the port 5 mode is configured.
+
+  Driver tries to lookup the phy-handle of the 2nd GMAC of the master device.
+  When phy-handle matches PHY of port 0 or 4 then port 5 set-up as mode 2.
+  phy-mode must be set, see also example 2 below!
+  * mt7621: phy-mode = "rgmii-txid";
+  * mt7623: phy-mode = "rgmii";
+
+  CPU-Ports need a phy-mode property:
+    Allowed values on mt7530 and mt7621:
+      - "rgmii"
+      - "trgmii"
+    On mt7531:
+      - "1000base-x"
+      - "2500base-x"
+      - "sgmii"
+
+
+properties:
+  compatible:
+    enum:
+      - mediatek,mt7530
+      - mediatek,mt7531
+      - mediatek,mt7621
+
+  core-supply:
+    description:
+      Phandle to the regulator node necessary for the core power.
+
+  "#gpio-cells":
+    const: 2
+
+  gpio-controller:
+    type: boolean
+    description:
+      if defined, MT7530's LED controller will run on GPIO mode.
+
+  "#interrupt-cells":
+    const: 1
+
+  interrupt-controller: true
+
+  interrupts:
+    maxItems: 1
+
+  io-supply:
+    description:
+      Phandle to the regulator node necessary for the I/O power.
+      See Documentation/devicetree/bindings/regulator/mt6323-regulator.txt
+      for details for the regulator setup on these boards.
+
+  mediatek,mcm:
+    type: boolean
+    description:
+      if defined, indicates that either MT7530 is the part on multi-chip
+      module belong to MT7623A has or the remotely standalone chip as the
+      function MT7623N reference board provided for.
+
+  reset-gpios:
+    maxItems: 1
+
+  reset-names:
+    const: mcm
+
+  resets:
+    description:
+      Phandle pointing to the system reset controller with line index for
+      the ethsys.
+    maxItems: 1
+
+patternProperties:
+  "^(ethernet-)?ports$":
+    type: object
+
+    patternProperties:
+      "^(ethernet-)?port@[0-9]+$":
+        type: object
+        description: Ethernet switch ports
+
+        unevaluatedProperties: false
+
+        properties:
+          reg:
+            description:
+              Port address described must be 6 for CPU port and from 0 to
+              5 for user ports.
+
+        allOf:
+          - $ref: dsa-port.yaml#
+          - if:
+              properties:
+                label:
+                  items:
+                    - const: cpu
+            then:
+              required:
+                - reg
+                - phy-mode
+
+required:
+  - compatible
+  - reg
+
+allOf:
+  - $ref: "dsa.yaml#"
+  - if:
+      required:
+        - mediatek,mcm
+    then:
+      required:
+        - resets
+        - reset-names
+    else:
+      required:
+        - reset-gpios
+
+  - dependencies:
+      interrupt-controller: [ interrupts ]
+
+  - if:
+      properties:
+        compatible:
+          items:
+            - const: mediatek,mt7530
+    then:
+      required:
+        - core-supply
+        - io-supply
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+    mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        switch@0 {
+            compatible = "mediatek,mt7530";
+            reg = <0>;
+
+            core-supply = <&mt6323_vpa_reg>;
+            io-supply = <&mt6323_vemc3v3_reg>;
+            reset-gpios = <&pio 33 GPIO_ACTIVE_HIGH>;
+
+            ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+                port@0 {
+                    reg = <0>;
+                    label = "lan0";
+                };
+
+                port@1 {
+                    reg = <1>;
+                    label = "lan1";
+                };
+
+                port@2 {
+                    reg = <2>;
+                    label = "lan2";
+                };
+
+                port@3 {
+                    reg = <3>;
+                    label = "lan3";
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
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                    };
+                };
+            };
+        };
+    };
+
+  - |
+    //Example 2: MT7621: Port 4 is WAN port: 2nd GMAC -> Port 5 -> PHY port 4.
+
+    ethernet {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        gmac0: mac@0 {
+            compatible = "mediatek,eth-mac";
+            reg = <0>;
+            phy-mode = "rgmii";
+
+            fixed-link {
+                speed = <1000>;
+                full-duplex;
+                pause;
+            };
+        };
+
+        gmac1: mac@1 {
+            compatible = "mediatek,eth-mac";
+            reg = <1>;
+            phy-mode = "rgmii-txid";
+            phy-handle = <&phy4>;
+        };
+
+        mdio: mdio-bus {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            /* Internal phy */
+            phy4: ethernet-phy@4 {
+                reg = <4>;
+            };
+
+            mt7530: switch@1f {
+                compatible = "mediatek,mt7621";
+                reg = <0x1f>;
+                mediatek,mcm;
+
+                resets = <&rstctrl 2>;
+                reset-names = "mcm";
+
+                ethernet-ports {
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+
+                    port@0 {
+                        reg = <0>;
+                        label = "lan0";
+                    };
+
+                    port@1 {
+                        reg = <1>;
+                        label = "lan1";
+                    };
+
+                    port@2 {
+                        reg = <2>;
+                        label = "lan2";
+                    };
+
+                    port@3 {
+                        reg = <3>;
+                        label = "lan3";
+                    };
+
+                    /* Commented out. Port 4 is handled by 2nd GMAC.
+                    port@4 {
+                        reg = <4>;
+                        label = "lan4";
+                    };
+                    */
+
+                    port@6 {
+                        reg = <6>;
+                        label = "cpu";
+                        ethernet = <&gmac0>;
+                        phy-mode = "rgmii";
+
+                        fixed-link {
+                            speed = <1000>;
+                            full-duplex;
+                            pause;
+                        };
+                    };
+                };
+            };
+        };
+    };
+
+  - |
+    //Example 3: MT7621: Port 5 is connected to external PHY: Port 5 -> external PHY.
+
+    ethernet {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        gmac_0: mac@0 {
+            compatible = "mediatek,eth-mac";
+            reg = <0>;
+            phy-mode = "rgmii";
+
+            fixed-link {
+                speed = <1000>;
+                full-duplex;
+                pause;
+            };
+        };
+
+        mdio0: mdio-bus {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            /* External phy */
+            ephy5: ethernet-phy@7 {
+                reg = <7>;
+            };
+
+            switch@1f {
+                compatible = "mediatek,mt7621";
+                reg = <0x1f>;
+                mediatek,mcm;
+
+                resets = <&rstctrl 2>;
+                reset-names = "mcm";
+
+                ethernet-ports {
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+
+                    port@0 {
+                        reg = <0>;
+                        label = "lan0";
+                    };
+
+                    port@1 {
+                        reg = <1>;
+                        label = "lan1";
+                    };
+
+                    port@2 {
+                        reg = <2>;
+                        label = "lan2";
+                    };
+
+                    port@3 {
+                        reg = <3>;
+                        label = "lan3";
+                    };
+
+                    port@4 {
+                        reg = <4>;
+                        label = "lan4";
+                    };
+
+                    port@5 {
+                        reg = <5>;
+                        label = "lan5";
+                        phy-mode = "rgmii";
+                        phy-handle = <&ephy5>;
+                    };
+
+                    cpu_port0: port@6 {
+                        reg = <6>;
+                        label = "cpu";
+                        ethernet = <&gmac_0>;
+                        phy-mode = "rgmii";
+
+                        fixed-link {
+                            speed = <1000>;
+                            full-duplex;
+                            pause;
+                        };
+                    };
+                };
+            };
+        };
+    };
diff --git a/Documentation/devicetree/bindings/net/dsa/mt7530.txt b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
deleted file mode 100644
index 18247ebfc487..000000000000
--- a/Documentation/devicetree/bindings/net/dsa/mt7530.txt
+++ /dev/null
@@ -1,327 +0,0 @@
-Mediatek MT7530 Ethernet switch
-================================
-
-Required properties:
-
-- compatible: may be compatible = "mediatek,mt7530"
-	or compatible = "mediatek,mt7621"
-	or compatible = "mediatek,mt7531"
-- #address-cells: Must be 1.
-- #size-cells: Must be 0.
-- mediatek,mcm: Boolean; if defined, indicates that either MT7530 is the part
-	on multi-chip module belong to MT7623A has or the remotely standalone
-	chip as the function MT7623N reference board provided for.
-
-If compatible mediatek,mt7530 is set then the following properties are required
-
-- core-supply: Phandle to the regulator node necessary for the core power.
-- io-supply: Phandle to the regulator node necessary for the I/O power.
-	See Documentation/devicetree/bindings/regulator/mt6323-regulator.txt
-	for details for the regulator setup on these boards.
-
-If the property mediatek,mcm isn't defined, following property is required
-
-- reset-gpios: Should be a gpio specifier for a reset line.
-
-Else, following properties are required
-
-- resets : Phandle pointing to the system reset controller with
-	line index for the ethsys.
-- reset-names : Should be set to "mcm".
-
-Required properties for the child nodes within ports container:
-
-- reg: Port address described must be 6 for CPU port and from 0 to 5 for
-	user ports.
-- phy-mode: String, the following values are acceptable for port labeled
-	"cpu":
-	If compatible mediatek,mt7530 or mediatek,mt7621 is set,
-	must be either "trgmii" or "rgmii"
-	If compatible mediatek,mt7531 is set,
-	must be either "sgmii", "1000base-x" or "2500base-x"
-
-Port 5 of mt7530 and mt7621 switch is muxed between:
-1. GMAC5: GMAC5 can interface with another external MAC or PHY.
-2. PHY of port 0 or port 4: PHY interfaces with an external MAC like 2nd GMAC
-   of the SOC. Used in many setups where port 0/4 becomes the WAN port.
-   Note: On a MT7621 SOC with integrated switch: 2nd GMAC can only connected to
-	 GMAC5 when the gpios for RGMII2 (GPIO 22-33) are not used and not
-	 connected to external component!
-
-Port 5 modes/configurations:
-1. Port 5 is disabled and isolated: An external phy can interface to the 2nd
-   GMAC of the SOC.
-   In the case of a build-in MT7530 switch, port 5 shares the RGMII bus with 2nd
-   GMAC and an optional external phy. Mind the GPIO/pinctl settings of the SOC!
-2. Port 5 is muxed to PHY of port 0/4: Port 0/4 interfaces with 2nd GMAC.
-   It is a simple MAC to PHY interface, port 5 needs to be setup for xMII mode
-   and RGMII delay.
-3. Port 5 is muxed to GMAC5 and can interface to an external phy.
-   Port 5 becomes an extra switch port.
-   Only works on platform where external phy TX<->RX lines are swapped.
-   Like in the Ubiquiti ER-X-SFP.
-4. Port 5 is muxed to GMAC5 and interfaces with the 2nd GAMC as 2nd CPU port.
-   Currently a 2nd CPU port is not supported by DSA code.
-
-Depending on how the external PHY is wired:
-1. normal: The PHY can only connect to 2nd GMAC but not to the switch
-2. swapped: RGMII TX, RX are swapped; external phy interface with the switch as
-   a ethernet port. But can't interface to the 2nd GMAC.
-
-Based on the DT the port 5 mode is configured.
-
-Driver tries to lookup the phy-handle of the 2nd GMAC of the master device.
-When phy-handle matches PHY of port 0 or 4 then port 5 set-up as mode 2.
-phy-mode must be set, see also example 2 below!
- * mt7621: phy-mode = "rgmii-txid";
- * mt7623: phy-mode = "rgmii";
-
-Optional properties:
-
-- gpio-controller: Boolean; if defined, MT7530's LED controller will run on
-	GPIO mode.
-- #gpio-cells: Must be 2 if gpio-controller is defined.
-- interrupt-controller: Boolean; Enables the internal interrupt controller.
-
-If interrupt-controller is defined, the following properties are required.
-
-- #interrupt-cells: Must be 1.
-- interrupts: Parent interrupt for the interrupt controller.
-
-See Documentation/devicetree/bindings/net/dsa/dsa.txt for a list of additional
-required, optional properties and how the integrated switch subnodes must
-be specified.
-
-Example:
-
-	&mdio0 {
-		switch@0 {
-			compatible = "mediatek,mt7530";
-			#address-cells = <1>;
-			#size-cells = <0>;
-			reg = <0>;
-
-			core-supply = <&mt6323_vpa_reg>;
-			io-supply = <&mt6323_vemc3v3_reg>;
-			reset-gpios = <&pio 33 0>;
-
-			ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
-				reg = <0>;
-				port@0 {
-					reg = <0>;
-					label = "lan0";
-				};
-
-				port@1 {
-					reg = <1>;
-					label = "lan1";
-				};
-
-				port@2 {
-					reg = <2>;
-					label = "lan2";
-				};
-
-				port@3 {
-					reg = <3>;
-					label = "lan3";
-				};
-
-				port@4 {
-					reg = <4>;
-					label = "wan";
-				};
-
-				port@6 {
-					reg = <6>;
-					label = "cpu";
-					ethernet = <&gmac0>;
-					phy-mode = "trgmii";
-					fixed-link {
-						speed = <1000>;
-						full-duplex;
-					};
-				};
-			};
-		};
-	};
-
-Example 2: MT7621: Port 4 is WAN port: 2nd GMAC -> Port 5 -> PHY port 4.
-
-&eth {
-	gmac0: mac@0 {
-		compatible = "mediatek,eth-mac";
-		reg = <0>;
-		phy-mode = "rgmii";
-
-		fixed-link {
-			speed = <1000>;
-			full-duplex;
-			pause;
-		};
-	};
-
-	gmac1: mac@1 {
-		compatible = "mediatek,eth-mac";
-		reg = <1>;
-		phy-mode = "rgmii-txid";
-		phy-handle = <&phy4>;
-	};
-
-	mdio: mdio-bus {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		/* Internal phy */
-		phy4: ethernet-phy@4 {
-			reg = <4>;
-		};
-
-		mt7530: switch@1f {
-			compatible = "mediatek,mt7621";
-			#address-cells = <1>;
-			#size-cells = <0>;
-			reg = <0x1f>;
-			pinctrl-names = "default";
-			mediatek,mcm;
-
-			resets = <&rstctrl 2>;
-			reset-names = "mcm";
-
-			ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				port@0 {
-					reg = <0>;
-					label = "lan0";
-				};
-
-				port@1 {
-					reg = <1>;
-					label = "lan1";
-				};
-
-				port@2 {
-					reg = <2>;
-					label = "lan2";
-				};
-
-				port@3 {
-					reg = <3>;
-					label = "lan3";
-				};
-
-/* Commented out. Port 4 is handled by 2nd GMAC.
-				port@4 {
-					reg = <4>;
-					label = "lan4";
-				};
-*/
-
-				cpu_port0: port@6 {
-					reg = <6>;
-					label = "cpu";
-					ethernet = <&gmac0>;
-					phy-mode = "rgmii";
-
-					fixed-link {
-						speed = <1000>;
-						full-duplex;
-						pause;
-					};
-				};
-			};
-		};
-	};
-};
-
-Example 3: MT7621: Port 5 is connected to external PHY: Port 5 -> external PHY.
-
-&eth {
-	gmac0: mac@0 {
-		compatible = "mediatek,eth-mac";
-		reg = <0>;
-		phy-mode = "rgmii";
-
-		fixed-link {
-			speed = <1000>;
-			full-duplex;
-			pause;
-		};
-	};
-
-	mdio: mdio-bus {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		/* External phy */
-		ephy5: ethernet-phy@7 {
-			reg = <7>;
-		};
-
-		mt7530: switch@1f {
-			compatible = "mediatek,mt7621";
-			#address-cells = <1>;
-			#size-cells = <0>;
-			reg = <0x1f>;
-			pinctrl-names = "default";
-			mediatek,mcm;
-
-			resets = <&rstctrl 2>;
-			reset-names = "mcm";
-
-			ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				port@0 {
-					reg = <0>;
-					label = "lan0";
-				};
-
-				port@1 {
-					reg = <1>;
-					label = "lan1";
-				};
-
-				port@2 {
-					reg = <2>;
-					label = "lan2";
-				};
-
-				port@3 {
-					reg = <3>;
-					label = "lan3";
-				};
-
-				port@4 {
-					reg = <4>;
-					label = "lan4";
-				};
-
-				port@5 {
-					reg = <5>;
-					label = "lan5";
-					phy-mode = "rgmii";
-					phy-handle = <&ephy5>;
-				};
-
-				cpu_port0: port@6 {
-					reg = <6>;
-					label = "cpu";
-					ethernet = <&gmac0>;
-					phy-mode = "rgmii";
-
-					fixed-link {
-						speed = <1000>;
-						full-duplex;
-						pause;
-					};
-				};
-			};
-		};
-	};
-};
-- 
2.34.1

