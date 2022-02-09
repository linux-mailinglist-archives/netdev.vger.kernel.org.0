Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334E04AFB66
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 19:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240528AbiBISo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 13:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240533AbiBISoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 13:44:32 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA91DC02B66E;
        Wed,  9 Feb 2022 10:42:43 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id o192-20020a4a2cc9000000b00300af40d795so3459021ooo.13;
        Wed, 09 Feb 2022 10:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5WmYTrbQRDdEzH1ym4NAfERL0hhKso000kaJiLvIddQ=;
        b=lgyNFL3E71l9kFUMuyALcTXwf4uY7Mx6Y8+YgXzjf0sEfXYtogzS1vyXi0ldtHL/Fb
         crFjPShwWU40ol/UbOjYPwy70F3bChOy69N3n0sWuAOlqbKyxkdljTsiaIKpgN6+ibLy
         9sAJAl9g5YMh9FGGZPuFK7ZPYKj2FdOiKFWiq1y3m6+mnza4v96TKmxsSidRotx0K3Lc
         RsrTPkRhDlnDUka2IsAGjrOrKIJlncT/7A2feuTPmvbuk9JUEh0fhWEpWg6F0qUei7WP
         eKxzrym4utoOI0YsaBvIEfZVyGZksW5tCiG+97+Z6OISPA2u0LIUls9aRIUcO6f9ggoy
         GlpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5WmYTrbQRDdEzH1ym4NAfERL0hhKso000kaJiLvIddQ=;
        b=S1yBIh4255wVtKDT+o6APg4YYlEKea897k0D3xFd+zePYJYXkaXpDXQ8D4uDsAscPA
         XC2I0DNFxEcEfwWB1A8Kcx0y+viLGDCZbiOgoRudvevF3Ju9yLmwMR7F/4lJHS3SQBji
         gYxyVS7J5yIDm7vw6LCo/cp5rvn9Lu6k0HEUHO1U4Aal/k0qzkeZXXJ4+2IcA5+X89J7
         InaMXEjeHYRamh9lbA6VDa5cm0dpXYDpu6t8BuY/6CJHq5UBUWYVynY15m44MtIKSD2d
         GSgGNMGzXWVjIW9rzakbzKIEsm6TN/+nR7436uDY3EjYktVoLA82banbnbgfu2Bn8X+o
         djgA==
X-Gm-Message-State: AOAM5313IFL0R+euHUmJSq6Jel6Zb0BcalP1OcFPhg7prbjFSqFBB1ZX
        2TmX1RpkvFYDL1yUGEoFzEzjombMKX9imA==
X-Google-Smtp-Source: ABdhPJwN8P08M1sgoIBPQ//ld0Hf/vARouiCs2CgiqbFsngjhygE+F6iPsXfgyNA9YGUOnGa8cHDoA==
X-Received: by 2002:a05:6870:37c2:: with SMTP id p2mr1383410oai.90.1644432155240;
        Wed, 09 Feb 2022 10:42:35 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id h9sm7028322otk.42.2022.02.09.10.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 10:42:34 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     devicetree@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH v2] dt-bindings: net: dsa: realtek: convert to YAML schema, add MDIO
Date:   Wed,  9 Feb 2022 15:41:16 -0300
Message-Id: <20220209184116.18094-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Schema changes:

- support for mdio-connected switches (mdio driver), recognized by
  checking the presence of property "reg"
- new compatible strings for rtl8367s and rtl8367rb
- "interrupt-controller" was not added as a required property. It might
  still work polling the ports when missing.

Examples changes:

- renamed "switch_intc" to make it unique between examples
- removed "dsa-mdio" from mdio compatible property
- renamed phy@0 to ethernet-phy@0 (not tested with real HW)
  phy@ requires #phy-cells

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 .../bindings/net/dsa/realtek-smi.txt          | 240 -----------
 .../devicetree/bindings/net/dsa/realtek.yaml  | 394 ++++++++++++++++++
 2 files changed, 394 insertions(+), 240 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
 create mode 100644 Documentation/devicetree/bindings/net/dsa/realtek.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
deleted file mode 100644
index 7959ec237983..000000000000
--- a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
+++ /dev/null
@@ -1,240 +0,0 @@
-Realtek SMI-based Switches
-==========================
-
-The SMI "Simple Management Interface" is a two-wire protocol using
-bit-banged GPIO that while it reuses the MDIO lines MCK and MDIO does
-not use the MDIO protocol. This binding defines how to specify the
-SMI-based Realtek devices.
-
-Required properties:
-
-- compatible: must be exactly one of:
-      "realtek,rtl8365mb" (4+1 ports)
-      "realtek,rtl8366"
-      "realtek,rtl8366rb" (4+1 ports)
-      "realtek,rtl8366s"  (4+1 ports)
-      "realtek,rtl8367"
-      "realtek,rtl8367b"
-      "realtek,rtl8368s"  (8 port)
-      "realtek,rtl8369"
-      "realtek,rtl8370"   (8 port)
-
-Required properties:
-- mdc-gpios: GPIO line for the MDC clock line.
-- mdio-gpios: GPIO line for the MDIO data line.
-- reset-gpios: GPIO line for the reset signal.
-
-Optional properties:
-- realtek,disable-leds: if the LED drivers are not used in the
-  hardware design this will disable them so they are not turned on
-  and wasting power.
-
-Required subnodes:
-
-- interrupt-controller
-
-  This defines an interrupt controller with an IRQ line (typically
-  a GPIO) that will demultiplex and handle the interrupt from the single
-  interrupt line coming out of one of the SMI-based chips. It most
-  importantly provides link up/down interrupts to the PHY blocks inside
-  the ASIC.
-
-Required properties of interrupt-controller:
-
-- interrupt: parent interrupt, see interrupt-controller/interrupts.txt
-- interrupt-controller: see interrupt-controller/interrupts.txt
-- #address-cells: should be <0>
-- #interrupt-cells: should be <1>
-
-- mdio
-
-  This defines the internal MDIO bus of the SMI device, mostly for the
-  purpose of being able to hook the interrupts to the right PHY and
-  the right PHY to the corresponding port.
-
-Required properties of mdio:
-
-- compatible: should be set to "realtek,smi-mdio" for all SMI devices
-
-See net/mdio.txt for additional MDIO bus properties.
-
-See net/dsa/dsa.txt for a list of additional required and optional properties
-and subnodes of DSA switches.
-
-Examples:
-
-An example for the RTL8366RB:
-
-switch {
-	compatible = "realtek,rtl8366rb";
-	/* 22 = MDIO (has input reads), 21 = MDC (clock, output only) */
-	mdc-gpios = <&gpio0 21 GPIO_ACTIVE_HIGH>;
-	mdio-gpios = <&gpio0 22 GPIO_ACTIVE_HIGH>;
-	reset-gpios = <&gpio0 14 GPIO_ACTIVE_LOW>;
-
-	switch_intc: interrupt-controller {
-		/* GPIO 15 provides the interrupt */
-		interrupt-parent = <&gpio0>;
-		interrupts = <15 IRQ_TYPE_LEVEL_LOW>;
-		interrupt-controller;
-		#address-cells = <0>;
-		#interrupt-cells = <1>;
-	};
-
-	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		reg = <0>;
-		port@0 {
-			reg = <0>;
-			label = "lan0";
-			phy-handle = <&phy0>;
-		};
-		port@1 {
-			reg = <1>;
-			label = "lan1";
-			phy-handle = <&phy1>;
-		};
-		port@2 {
-			reg = <2>;
-			label = "lan2";
-			phy-handle = <&phy2>;
-		};
-		port@3 {
-			reg = <3>;
-			label = "lan3";
-			phy-handle = <&phy3>;
-		};
-		port@4 {
-			reg = <4>;
-			label = "wan";
-			phy-handle = <&phy4>;
-		};
-		port@5 {
-			reg = <5>;
-			label = "cpu";
-			ethernet = <&gmac0>;
-			phy-mode = "rgmii";
-			fixed-link {
-				speed = <1000>;
-				full-duplex;
-			};
-		};
-	};
-
-	mdio {
-		compatible = "realtek,smi-mdio", "dsa-mdio";
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		phy0: phy@0 {
-			reg = <0>;
-			interrupt-parent = <&switch_intc>;
-			interrupts = <0>;
-		};
-		phy1: phy@1 {
-			reg = <1>;
-			interrupt-parent = <&switch_intc>;
-			interrupts = <1>;
-		};
-		phy2: phy@2 {
-			reg = <2>;
-			interrupt-parent = <&switch_intc>;
-			interrupts = <2>;
-		};
-		phy3: phy@3 {
-			reg = <3>;
-			interrupt-parent = <&switch_intc>;
-			interrupts = <3>;
-		};
-		phy4: phy@4 {
-			reg = <4>;
-			interrupt-parent = <&switch_intc>;
-			interrupts = <12>;
-		};
-	};
-};
-
-An example for the RTL8365MB-VC:
-
-switch {
-	compatible = "realtek,rtl8365mb";
-	mdc-gpios = <&gpio1 16 GPIO_ACTIVE_HIGH>;
-	mdio-gpios = <&gpio1 17 GPIO_ACTIVE_HIGH>;
-	reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
-
-	switch_intc: interrupt-controller {
-		interrupt-parent = <&gpio5>;
-		interrupts = <1 IRQ_TYPE_LEVEL_LOW>;
-		interrupt-controller;
-		#address-cells = <0>;
-		#interrupt-cells = <1>;
-	};
-
-	ports {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		reg = <0>;
-		port@0 {
-			reg = <0>;
-			label = "swp0";
-			phy-handle = <&ethphy0>;
-		};
-		port@1 {
-			reg = <1>;
-			label = "swp1";
-			phy-handle = <&ethphy1>;
-		};
-		port@2 {
-			reg = <2>;
-			label = "swp2";
-			phy-handle = <&ethphy2>;
-		};
-		port@3 {
-			reg = <3>;
-			label = "swp3";
-			phy-handle = <&ethphy3>;
-		};
-		port@6 {
-			reg = <6>;
-			label = "cpu";
-			ethernet = <&fec1>;
-			phy-mode = "rgmii";
-			tx-internal-delay-ps = <2000>;
-			rx-internal-delay-ps = <2000>;
-
-			fixed-link {
-				speed = <1000>;
-				full-duplex;
-				pause;
-			};
-		};
-	};
-
-	mdio {
-		compatible = "realtek,smi-mdio";
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		ethphy0: phy@0 {
-			reg = <0>;
-			interrupt-parent = <&switch_intc>;
-			interrupts = <0>;
-		};
-		ethphy1: phy@1 {
-			reg = <1>;
-			interrupt-parent = <&switch_intc>;
-			interrupts = <1>;
-		};
-		ethphy2: phy@2 {
-			reg = <2>;
-			interrupt-parent = <&switch_intc>;
-			interrupts = <2>;
-		};
-		ethphy3: phy@3 {
-			reg = <3>;
-			interrupt-parent = <&switch_intc>;
-			interrupts = <3>;
-		};
-	};
-};
diff --git a/Documentation/devicetree/bindings/net/dsa/realtek.yaml b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
new file mode 100644
index 000000000000..8756060895a8
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
@@ -0,0 +1,394 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/realtek.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Realtek switches for unmanaged switches
+
+allOf:
+  - $ref: dsa.yaml#
+
+maintainers:
+  - Linus Walleij <linus.walleij@linaro.org>
+
+description:
+  Realtek advertises these chips as fast/gigabit switches or unmanaged
+  switches. They can be controlled using different interfaces, like SMI,
+  MDIO or SPI.
+
+  The SMI "Simple Management Interface" is a two-wire protocol using
+  bit-banged GPIO that while it reuses the MDIO lines MCK and MDIO does
+  not use the MDIO protocol. This binding defines how to specify the
+  SMI-based Realtek devices. The realtek-smi driver is a platform driver
+  and it must be inserted inside a platform node.
+
+  The MDIO-connected switches use MDIO protocol to access their registers.
+  The realtek-mdio driver is an MDIO driver and it must be inserted inside
+  an MDIO node.
+
+properties:
+  compatible:
+    enum:
+      - realtek,rtl8365mb
+      - realtek,rtl8366
+      - realtek,rtl8366rb
+      - realtek,rtl8366s
+      - realtek,rtl8367
+      - realtek,rtl8367b
+      - realtek,rtl8367rb
+      - realtek,rtl8367s
+      - realtek,rtl8368s
+      - realtek,rtl8369
+      - realtek,rtl8370
+    description: |
+      realtek,rtl8365mb: 4+1 ports
+      realtek,rtl8366: 5+1 ports
+      realtek,rtl8366rb: 5+1 ports
+      realtek,rtl8366s: 5+1 ports
+      realtek,rtl8367:
+      realtek,rtl8367b:
+      realtek,rtl8367rb: 5+2 ports
+      realtek,rtl8367s: 5+2 ports
+      realtek,rtl8368s: 8 ports
+      realtek,rtl8369: 8+1 ports
+      realtek,rtl8370: 8+2 ports
+
+  mdc-gpios:
+    description: GPIO line for the MDC clock line.
+    maxItems: 1
+
+  mdio-gpios:
+    description: GPIO line for the MDIO data line.
+    maxItems: 1
+
+  reset-gpios:
+    description: GPIO to be used to reset the whole device
+    maxItems: 1
+
+  realtek,disable-leds:
+    type: boolean
+    description: |
+      if the LED drivers are not used in the hardware design,
+      this will disable them so they are not turned on
+      and wasting power.
+
+  interrupt-controller:
+    type: object
+    description: |
+      This defines an interrupt controller with an IRQ line (typically
+      a GPIO) that will demultiplex and handle the interrupt from the single
+      interrupt line coming out of one of the Realtek switch chips. It most
+      importantly provides link up/down interrupts to the PHY blocks inside
+      the ASIC.
+
+    properties:
+
+      interrupt-controller: true
+
+      interrupts:
+        maxItems: 1
+        description:
+          A single IRQ line from the switch, either active LOW or HIGH
+
+      '#address-cells':
+        const: 0
+
+      '#interrupt-cells':
+        const: 1
+
+    required:
+      - interrupt-controller
+      - '#address-cells'
+      - '#interrupt-cells'
+
+  mdio:
+    $ref: /schemas/net/mdio.yaml#
+    unevaluatedProperties: false
+
+    properties:
+      compatible:
+        const: realtek,smi-mdio
+
+if:
+  required:
+    - reg
+
+then:
+  not:
+    required:
+      - mdc-gpios
+      - mdio-gpios
+      - mdio
+
+  properties:
+    mdc-gpios: false
+    mdio-gpios: false
+    mdio: false
+
+else:
+  required:
+    - mdc-gpios
+    - mdio-gpios
+    - mdio
+    - reset-gpios
+
+required:
+  - compatible
+
+    #  - mdc-gpios
+    #  - mdio-gpios
+    #  - reset-gpios
+    #  - mdio
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    platform {
+            switch {
+                    compatible = "realtek,rtl8366rb";
+                    /* 22 = MDIO (has input reads), 21 = MDC (clock, output only) */
+                    mdc-gpios = <&gpio0 21 GPIO_ACTIVE_HIGH>;
+                    mdio-gpios = <&gpio0 22 GPIO_ACTIVE_HIGH>;
+                    reset-gpios = <&gpio0 14 GPIO_ACTIVE_LOW>;
+
+                    switch_intc1: interrupt-controller {
+                            /* GPIO 15 provides the interrupt */
+                            interrupt-parent = <&gpio0>;
+                            interrupts = <15 IRQ_TYPE_LEVEL_LOW>;
+                            interrupt-controller;
+                            #address-cells = <0>;
+                            #interrupt-cells = <1>;
+                    };
+
+                    ports {
+                            #address-cells = <1>;
+                            #size-cells = <0>;
+                            port@0 {
+                                    reg = <0>;
+                                    label = "lan0";
+                                    phy-handle = <&phy0>;
+                            };
+                            port@1 {
+                                    reg = <1>;
+                                    label = "lan1";
+                                    phy-handle = <&phy1>;
+                            };
+                            port@2 {
+                                    reg = <2>;
+                                    label = "lan2";
+                                    phy-handle = <&phy2>;
+                            };
+                            port@3 {
+                                    reg = <3>;
+                                    label = "lan3";
+                                    phy-handle = <&phy3>;
+                            };
+                            port@4 {
+                                    reg = <4>;
+                                    label = "wan";
+                                    phy-handle = <&phy4>;
+                            };
+                            port@5 {
+                                    reg = <5>;
+                                    label = "cpu";
+                                    ethernet = <&gmac0>;
+                                    phy-mode = "rgmii";
+                                    fixed-link {
+                                            speed = <1000>;
+                                            full-duplex;
+                                    };
+                            };
+                    };
+
+                    mdio {
+                            compatible = "realtek,smi-mdio";
+                            #address-cells = <1>;
+                            #size-cells = <0>;
+
+                            phy0: ethernet-phy@0 {
+                                    reg = <0>;
+                                    interrupt-parent = <&switch_intc1>;
+                                    interrupts = <0>;
+                            };
+                            phy1: ethernet-phy@1 {
+                                    reg = <1>;
+                                    interrupt-parent = <&switch_intc1>;
+                                    interrupts = <1>;
+                            };
+                            phy2: ethernet-phy@2 {
+                                    reg = <2>;
+                                    interrupt-parent = <&switch_intc1>;
+                                    interrupts = <2>;
+                            };
+                            phy3: ethernet-phy@3 {
+                                    reg = <3>;
+                                    interrupt-parent = <&switch_intc1>;
+                                    interrupts = <3>;
+                            };
+                            phy4: ethernet-phy@4 {
+                                    reg = <4>;
+                                    interrupt-parent = <&switch_intc1>;
+                                    interrupts = <12>;
+                            };
+                    };
+            };
+    };
+
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    platform {
+            switch {
+                    compatible = "realtek,rtl8365mb";
+                    mdc-gpios = <&gpio1 16 GPIO_ACTIVE_HIGH>;
+                    mdio-gpios = <&gpio1 17 GPIO_ACTIVE_HIGH>;
+                    reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
+
+                    switch_intc2: interrupt-controller {
+                            interrupt-parent = <&gpio5>;
+                            interrupts = <1 IRQ_TYPE_LEVEL_LOW>;
+                            interrupt-controller;
+                            #address-cells = <0>;
+                            #interrupt-cells = <1>;
+                    };
+
+                    ports {
+                            #address-cells = <1>;
+                            #size-cells = <0>;
+                            port@0 {
+                                    reg = <0>;
+                                    label = "swp0";
+                                    phy-handle = <&ethphy0>;
+                            };
+                            port@1 {
+                                    reg = <1>;
+                                    label = "swp1";
+                                    phy-handle = <&ethphy1>;
+                            };
+                            port@2 {
+                                    reg = <2>;
+                                    label = "swp2";
+                                    phy-handle = <&ethphy2>;
+                            };
+                            port@3 {
+                                    reg = <3>;
+                                    label = "swp3";
+                                    phy-handle = <&ethphy3>;
+                            };
+                            port@6 {
+                                    reg = <6>;
+                                    label = "cpu";
+                                    ethernet = <&fec1>;
+                                    phy-mode = "rgmii";
+                                    tx-internal-delay-ps = <2000>;
+                                    rx-internal-delay-ps = <2000>;
+
+                                    fixed-link {
+                                            speed = <1000>;
+                                            full-duplex;
+                                            pause;
+                                    };
+                            };
+                    };
+
+                    mdio {
+                            compatible = "realtek,smi-mdio";
+                            #address-cells = <1>;
+                            #size-cells = <0>;
+
+                            ethphy0: ethernet-phy@0 {
+                                    reg = <0>;
+                                    interrupt-parent = <&switch_intc2>;
+                                    interrupts = <0>;
+                            };
+                            ethphy1: ethernet-phy@1 {
+                                    reg = <1>;
+                                    interrupt-parent = <&switch_intc2>;
+                                    interrupts = <1>;
+                            };
+                            ethphy2: ethernet-phy@2 {
+                                    reg = <2>;
+                                    interrupt-parent = <&switch_intc2>;
+                                    interrupts = <2>;
+                            };
+                            ethphy3: ethernet-phy@3 {
+                                    reg = <3>;
+                                    interrupt-parent = <&switch_intc2>;
+                                    interrupts = <3>;
+                            };
+                    };
+            };
+    };
+
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            switch@29 {
+                    compatible = "realtek,rtl8367s";
+                    reg = <29>;
+
+                    reset-gpios = <&gpio2 20 GPIO_ACTIVE_LOW>;
+
+                    switch_intc3: interrupt-controller {
+                            interrupt-parent = <&gpio0>;
+                            interrupts = <11 IRQ_TYPE_EDGE_FALLING>;
+                            interrupt-controller;
+                            #address-cells = <0>;
+                            #interrupt-cells = <1>;
+                    };
+
+                    ports {
+                            #address-cells = <1>;
+                            #size-cells = <0>;
+
+                            port@0 {
+                                    reg = <0>;
+                                    label = "lan4";
+                            };
+
+                            port@1 {
+                                    reg = <1>;
+                                    label = "lan3";
+                            };
+
+                            port@2 {
+                                    reg = <2>;
+                                    label = "lan2";
+                            };
+
+                            port@3 {
+                                    reg = <3>;
+                                    label = "lan1";
+                            };
+
+                            port@4 {
+                                    reg = <4>;
+                                    label = "wan";
+                            };
+
+                            port@7 {
+                                    reg = <7>;
+                                    ethernet = <&ethernet>;
+                                    phy-mode = "rgmii";
+                                    tx-internal-delay-ps = <2000>;
+                                    rx-internal-delay-ps = <0>;
+
+                                    fixed-link {
+                                            speed = <1000>;
+                                            full-duplex;
+                                    };
+                            };
+                    };
+            };
+      };
-- 
2.35.1

