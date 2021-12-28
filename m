Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAD14806F8
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 08:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbhL1H1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 02:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbhL1H1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 02:27:06 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43522C061574;
        Mon, 27 Dec 2021 23:27:06 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id p19so15441268qtw.12;
        Mon, 27 Dec 2021 23:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a/w8DeC10QfUAvXQkxj22HE5Ll4UkxcKK8OJp0Nrpcc=;
        b=JiTmjkeg3ZDUzTxReURE1hC4/yhwt0/d66GtNEP2NdK4TQbbDTcpp+xC0i3PMeWyVj
         ceURFHMAEzyEtwmZmYRsnDewpM8j5drv1L2Y0F36951Xtc1BD2CWBJpZvrIyVltBZGy5
         iL4X5UnvvMadnmfVMXjlgHr09QQXpa05wCMQgJskdQ5ZxJxGdv3g9XHBVjbxCkN6Y0XH
         NKi65klYWoBnZ4lLOLPXMtDyUYp+uxXL78vmrdBYgEV5Pima+FIiT0LNTWnbK5GTv8Yg
         4f8kKAECGRpQkePgdf0B/xeOZnySdt5Vaz4X+j6s0cQkO8BMkmCSuzBt/F8UifBtyNRm
         XsDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a/w8DeC10QfUAvXQkxj22HE5Ll4UkxcKK8OJp0Nrpcc=;
        b=Sd3d8eN1Oj1m4TdOmeF0/KlcGLsMVgjaD0rwI7CpbA7qdnFIS3aITH5kdXDS1XgEZS
         RA79h1vFYeHBh+3kDA3Upc1U+Np5S56GEZpxib7Rap8vNicrky8qAToxTDhcL5zf5kDP
         WEsx7EIHmRq7cO6O3oiq66A1KpJR2VEmIza/m5On4ageZ8hPyuIuHW0tq6fUoqAYrmCB
         swhSbeN2sJ1ZvXp3GoFry391KlESvOtOE90EGDGyJeHdzN+CMRfQDzvm9mlSJj8JPtmz
         P+N1LbHWqyH7RlkdJVy2pNfhNO8tby9Om3TSWNsjNjMw0mqIl919A4Cfokumqv8E9Z+i
         PtkA==
X-Gm-Message-State: AOAM5338HT76cV+i6ctfTJlAdLlTWSDl8UGys/5x528kvpJwRqLQasyX
        syNvvcPy8MnFARd4PsAhw2Pf2Rlmse49tw==
X-Google-Smtp-Source: ABdhPJwkY1WYpfWw8DkUf95b7xqURgG9qpkYmy9Al7dmv4QAAzdUmvurbns+5Olgk0JYEimH1D0nUg==
X-Received: by 2002:a05:622a:48e:: with SMTP id p14mr17183615qtx.553.1640676424911;
        Mon, 27 Dec 2021 23:27:04 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id ay32sm14430439qkb.63.2021.12.27.23.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 23:27:04 -0800 (PST)
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
Subject: [PATCH] dt-bindings: net: dsa: realtek-smi: convert to YAML schema
Date:   Tue, 28 Dec 2021 04:26:45 -0300
Message-Id: <20211228072645.32341-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Schema changes:

- "interrupt-controller" was not added as a required property. It might
  still work polling the ports when missing
- "interrupt" property was mentioned but never used. According to its
  description, it was assumed it was really "interrupt-parent"

Examples changes:

- renamed "switch_intc" to make it unique between examples
- removed "dsa-mdio" from mdio compatible property
- renamed phy@0 to ethernet-phy@0 (not tested with real HW)
  phy@ requires #phy-cells

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 .../bindings/net/dsa/realtek-smi.txt          | 240 --------------
 .../bindings/net/dsa/realtek-smi.yaml         | 310 ++++++++++++++++++
 2 files changed, 310 insertions(+), 240 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
 create mode 100644 Documentation/devicetree/bindings/net/dsa/realtek-smi.yaml

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
diff --git a/Documentation/devicetree/bindings/net/dsa/realtek-smi.yaml b/Documentation/devicetree/bindings/net/dsa/realtek-smi.yaml
new file mode 100644
index 000000000000..c4cd0038f092
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/realtek-smi.yaml
@@ -0,0 +1,310 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/realtek-smi.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Realtek SMI-based Switches
+
+allOf:
+  - $ref: dsa.yaml#
+
+maintainers:
+  - Linus Walleij <linus.walleij@linaro.org>
+
+description:
+  The SMI "Simple Management Interface" is a two-wire protocol using
+  bit-banged GPIO that while it reuses the MDIO lines MCK and MDIO does
+  not use the MDIO protocol. This binding defines how to specify the
+  SMI-based Realtek devices. The realtek-smi driver is a platform driver
+  and it must be inserted inside a platform node.
+
+properties:
+  compatible:
+    oneOf:
+      - enum:
+          - realtek,rtl8365mb
+          - realtek,rtl8366
+          - realtek,rtl8366rb
+          - realtek,rtl8366s
+          - realtek,rtl8367
+          - realtek,rtl8367b
+          - realtek,rtl8368s
+          - realtek,rtl8369
+          - realtek,rtl8370
+    description: |
+      realtek,rtl8365mb: 4+1 ports
+      realtek,rtl8366:
+      realtek,rtl8366rb:
+      realtek,rtl8366s: 4+1 ports
+      realtek,rtl8367:
+      realtek,rtl8367b:
+      realtek,rtl8368s: 8 ports
+      realtek,rtl8369:
+      realtek,rtl8370:  8+2 ports
+  reg:
+    maxItems: 1
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
+      if the LED drivers are not used in the
+      hardware design this will disable them so they are not turned on
+      and wasting power.
+
+  interrupt-controller:
+    type: object
+    description: |
+      This defines an interrupt controller with an IRQ line (typically
+      a GPIO) that will demultiplex and handle the interrupt from the single
+      interrupt line coming out of one of the SMI-based chips. It most
+      importantly provides link up/down interrupts to the PHY blocks inside
+      the ASIC.
+    
+    properties:
+
+      interrupt-controller:
+        description: see interrupt-controller/interrupts.txt
+
+      interrupts:
+        description: TODO
+
+      '#address-cells':
+        const: 0
+
+      '#interrupt-cells':
+        const: 1
+
+    required:
+      - interrupt-parent
+      - interrupt-controller
+      - '#address-cells'
+      - '#interrupt-cells'
+
+  mdio:
+    type: object
+    description:
+      This defines the internal MDIO bus of the SMI device, mostly for the
+      purpose of being able to hook the interrupts to the right PHY and
+      the right PHY to the corresponding port.
+
+    properties:
+      compatible:
+        const: "realtek,smi-mdio"
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      "^(ethernet-)?phy@[0-4]$":
+        type: object
+
+        allOf:
+          - $ref: "http://devicetree.org/schemas/net/mdio.yaml#"
+
+        properties:
+          reg:
+            maxItems: 1
+
+        required:
+          - reg
+
+required:
+  - compatible
+  - mdc-gpios
+  - mdio-gpios
+  - reset-gpios
+
+additionalProperties: true
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    switch {
+            compatible = "realtek,rtl8366rb";
+            /* 22 = MDIO (has input reads), 21 = MDC (clock, output only) */
+            mdc-gpios = <&gpio0 21 GPIO_ACTIVE_HIGH>;
+            mdio-gpios = <&gpio0 22 GPIO_ACTIVE_HIGH>;
+            reset-gpios = <&gpio0 14 GPIO_ACTIVE_LOW>;
+
+            switch_intc1: interrupt-controller {
+                    /* GPIO 15 provides the interrupt */
+                    interrupt-parent = <&gpio0>;
+                    interrupts = <15 IRQ_TYPE_LEVEL_LOW>;
+                    interrupt-controller;
+                    #address-cells = <0>;
+                    #interrupt-cells = <1>;
+            };
+
+            ports {
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+                    port@0 {
+                            reg = <0>;
+                            label = "lan0";
+                            phy-handle = <&phy0>;
+                    };
+                    port@1 {
+                            reg = <1>;
+                            label = "lan1";
+                            phy-handle = <&phy1>;
+                    };
+                    port@2 {
+                            reg = <2>;
+                            label = "lan2";
+                            phy-handle = <&phy2>;
+                    };
+                    port@3 {
+                            reg = <3>;
+                            label = "lan3";
+                            phy-handle = <&phy3>;
+                    };
+                    port@4 {
+                            reg = <4>;
+                            label = "wan";
+                            phy-handle = <&phy4>;
+                    };
+                    port@5 {
+                            reg = <5>;
+                            label = "cpu";
+                            ethernet = <&gmac0>;
+                            phy-mode = "rgmii";
+                            fixed-link {
+                                    speed = <1000>;
+                                    full-duplex;
+                            };
+                    };
+            };
+
+            mdio {
+                    compatible = "realtek,smi-mdio";
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+
+                    phy0: ethernet-phy@0 {
+                            reg = <0>;
+                            interrupt-parent = <&switch_intc1>;
+                            interrupts = <0>;
+                    };
+                    phy1: ethernet-phy@1 {
+                            reg = <1>;
+                            interrupt-parent = <&switch_intc1>;
+                            interrupts = <1>;
+                    };
+                    phy2: ethernet-phy@2 {
+                            reg = <2>;
+                            interrupt-parent = <&switch_intc1>;
+                            interrupts = <2>;
+                    };
+                    phy3: ethernet-phy@3 {
+                            reg = <3>;
+                            interrupt-parent = <&switch_intc1>;
+                            interrupts = <3>;
+                    };
+                    phy4: ethernet-phy@4 {
+                            reg = <4>;
+                            interrupt-parent = <&switch_intc1>;
+                            interrupts = <12>;
+                    };
+            };
+    };
+
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    switch {
+            compatible = "realtek,rtl8365mb";
+            mdc-gpios = <&gpio1 16 GPIO_ACTIVE_HIGH>;
+            mdio-gpios = <&gpio1 17 GPIO_ACTIVE_HIGH>;
+            reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
+
+            switch_intc2: interrupt-controller {
+                    interrupt-parent = <&gpio5>;
+                    interrupts = <1 IRQ_TYPE_LEVEL_LOW>;
+                    interrupt-controller;
+                    #address-cells = <0>;
+                    #interrupt-cells = <1>;
+            };
+
+            ports {
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+                    port@0 {
+                            reg = <0>;
+                            label = "swp0";
+                            phy-handle = <&ethphy0>;
+                    };
+                    port@1 {
+                            reg = <1>;
+                            label = "swp1";
+                            phy-handle = <&ethphy1>;
+                    };
+                    port@2 {
+                            reg = <2>;
+                            label = "swp2";
+                            phy-handle = <&ethphy2>;
+                    };
+                    port@3 {
+                            reg = <3>;
+                            label = "swp3";
+                            phy-handle = <&ethphy3>;
+                    };
+                    port@6 {
+                            reg = <6>;
+                            label = "cpu";
+                            ethernet = <&fec1>;
+                            phy-mode = "rgmii";
+                            tx-internal-delay-ps = <2000>;
+                            rx-internal-delay-ps = <2000>;
+
+                            fixed-link {
+                                    speed = <1000>;
+                                    full-duplex;
+                                    pause;
+                            };
+                    };
+            };
+
+            mdio {
+                    compatible = "realtek,smi-mdio";
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+
+                    ethphy0: ethernet-phy@0 {
+                            reg = <0>;
+                            interrupt-parent = <&switch_intc2>;
+                            interrupts = <0>;
+                    };
+                    ethphy1: ethernet-phy@1 {
+                            reg = <1>;
+                            interrupt-parent = <&switch_intc2>;
+                            interrupts = <1>;
+                    };
+                    ethphy2: ethernet-phy@2 {
+                            reg = <2>;
+                            interrupt-parent = <&switch_intc2>;
+                            interrupts = <2>;
+                    };
+                    ethphy3: ethernet-phy@3 {
+                            reg = <3>;
+                            interrupt-parent = <&switch_intc2>;
+                            interrupts = <3>;
+                    };
+            };
+    };
-- 
2.34.0

