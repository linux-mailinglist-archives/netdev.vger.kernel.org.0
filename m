Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AB142B224
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 03:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbhJMBTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 21:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbhJMBSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 21:18:52 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF283C061766;
        Tue, 12 Oct 2021 18:16:45 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id ec8so3170475edb.6;
        Tue, 12 Oct 2021 18:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I2PCDgZW10PDkITbSOYGlhlQQVxVxhG9cpTlPQzqCng=;
        b=e0YkVY0rCCJNaPNYoQfOhzEzuGNnLLhZvUgkdU5JLoHyxUy4Y4QUkxge8+uvLmJfOi
         8reLgPAx4dVM3qr5b3pw/DizPcL6sQFgdcz5m7ptSJN2jncyLgqSAU62iUcRhgtzP70e
         bT8cYSDys5/5+J/j0mQNdGT7EBQXjdyU//7oQxK0zGpJa7O2VXhME9VaXuhW9EsUf89t
         0Sj4jacutklbtcnp54wRUP+xSkSKAh7KzQAmFwM+XHb6gbobV5NqLWu/K+02thoHMA1M
         /U1c3krUY1M8m7FzV8Ahwf71GGCfqNBR4Wh3rmdIyGcqN4Rb/y7J2tM2tGR5qGUM8iKp
         XGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I2PCDgZW10PDkITbSOYGlhlQQVxVxhG9cpTlPQzqCng=;
        b=CVRUosedo2FMgOP/evDGwD/jpUYX2zPXG84aoSHVj/lhj6ABvW9JVRu796PuDu98Ik
         XOSFp4eXdQxEC5MTYD+8oW9HM4POw1pG3yljA4C6KTj7cFpmRbcasSkhYH2yvzDrLyJQ
         DXCFzmT2tpW0LmELIONnYuqQ7TXsyaHv/GC4vsxNIT+Gh0fW6iv4x21id+DzzlMX54Yr
         Uv7NkyMzacUuIf+v94G8kFHDW4OkzcHwaRI9KSNt8rh4u3oBVKlpZhuWYls0ovVzr/yS
         52ChFQOkkXInKb/XmZZzgdyVkUxihb0EYur0zzJsTKRQuwbqPhK1OOPfns3519GYo4w8
         4vyw==
X-Gm-Message-State: AOAM5332QElhTuS0JLGVA9cwL27xUaz0TFj9l7t2+1nRCOS1qgpD+55/
        p8BQv93lnhoQ0T7W6PaHQK4=
X-Google-Smtp-Source: ABdhPJwgdxkL8tE0S/7Lhq+jOjBG20KGMEZ/tbIB6cUi1AGaTpuKYnBqPniENuETYOYxSRPLzuqDwA==
X-Received: by 2002:a17:906:53c8:: with SMTP id p8mr36298106ejo.422.1634087803968;
        Tue, 12 Oct 2021 18:16:43 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v13sm6894630ede.79.2021.10.12.18.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 18:16:43 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Cc:     Matthew Hagan <mnhagan88@gmail.com>
Subject: [net-next PATCH v6 15/16] dt-bindings: net: dsa: qca8k: convert to YAML schema
Date:   Wed, 13 Oct 2021 03:16:21 +0200
Message-Id: <20211013011622.10537-16-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013011622.10537-1-ansuelsmth@gmail.com>
References: <20211013011622.10537-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Hagan <mnhagan88@gmail.com>

Convert the qca8k bindings to YAML format.

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Co-developed-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/dsa/qca8k.txt     | 245 ------------
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 362 ++++++++++++++++++
 2 files changed, 362 insertions(+), 245 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.txt
 create mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
deleted file mode 100644
index f057117764af..000000000000
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ /dev/null
@@ -1,245 +0,0 @@
-* Qualcomm Atheros QCA8xxx switch family
-
-Required properties:
-
-- compatible: should be one of:
-    "qca,qca8328": referenced as AR8328(N)-AK1(A/B) QFN 176 pin package
-    "qca,qca8327": referenced as AR8327(N)-AL1A DR-QFN 148 pin package
-    "qca,qca8334": referenced as QCA8334-AL3C QFN 88 pin package
-    "qca,qca8337": referenced as QCA8337N-AL3(B/C) DR-QFN 148 pin package
-
-- #size-cells: must be 0
-- #address-cells: must be 1
-
-Optional properties:
-
-- reset-gpios: GPIO to be used to reset the whole device
-- qca,ignore-power-on-sel: Ignore power on pin strapping to configure led open
-                           drain or eeprom presence. This is needed for broken
-                           devices that have wrong configuration or when the oem
-                           decided to not use pin strapping and fallback to sw
-                           regs.
-- qca,led-open-drain: Set leds to open-drain mode. This requires the
-                      qca,ignore-power-on-sel to be set or the driver will fail
-                      to probe. This is needed if the oem doesn't use pin
-                      strapping to set this mode and prefers to set it using sw
-                      regs. The pin strapping related to led open drain mode is
-                      the pin B68 for QCA832x and B49 for QCA833x
-
-Subnodes:
-
-The integrated switch subnode should be specified according to the binding
-described in dsa/dsa.txt. If the QCA8K switch is connect to a SoC's external
-mdio-bus each subnode describing a port needs to have a valid phandle
-referencing the internal PHY it is connected to. This is because there's no
-N:N mapping of port and PHY id.
-To declare the internal mdio-bus configuration, declare a mdio node in the
-switch node and declare the phandle for the port referencing the internal
-PHY is connected to. In this config a internal mdio-bus is registered and
-the mdio MASTER is used as communication.
-
-Don't use mixed external and internal mdio-bus configurations, as this is
-not supported by the hardware.
-
-This switch support 2 CPU port. Normally and advised configuration is with
-CPU port set to port 0. It is also possible to set the CPU port to port 6
-if the device requires it. The driver will configure the switch to the defined
-port. With both CPU port declared the first CPU port is selected as primary
-and the secondary CPU ignored.
-
-A CPU port node has the following optional node:
-
-- fixed-link            : Fixed-link subnode describing a link to a non-MDIO
-                          managed entity. See
-                          Documentation/devicetree/bindings/net/fixed-link.txt
-                          for details.
-- qca,sgmii-rxclk-falling-edge: Set the receive clock phase to falling edge.
-                                Mostly used in qca8327 with CPU port 0 set to
-                                sgmii.
-- qca,sgmii-txclk-falling-edge: Set the transmit clock phase to falling edge.
-- qca,sgmii-enable-pll  : For SGMII CPU port, explicitly enable PLL, TX and RX
-                          chain along with Signal Detection.
-                          This should NOT be enabled for qca8327. If enabled with
-                          qca8327 the sgmii port won't correctly init and an err
-                          is printed.
-                          This can be required for qca8337 switch with revision 2.
-                          A warning is displayed when used with revision greater
-                          2.
-                          With CPU port set to sgmii and qca8337 it is advised
-                          to set this unless a communication problem is observed.
-
-For QCA8K the 'fixed-link' sub-node supports only the following properties:
-
-- 'speed' (integer, mandatory), to indicate the link speed. Accepted
-  values are 10, 100 and 1000
-- 'full-duplex' (boolean, optional), to indicate that full duplex is
-  used. When absent, half duplex is assumed.
-
-Examples:
-
-for the external mdio-bus configuration:
-
-	&mdio0 {
-		phy_port1: phy@0 {
-			reg = <0>;
-		};
-
-		phy_port2: phy@1 {
-			reg = <1>;
-		};
-
-		phy_port3: phy@2 {
-			reg = <2>;
-		};
-
-		phy_port4: phy@3 {
-			reg = <3>;
-		};
-
-		phy_port5: phy@4 {
-			reg = <4>;
-		};
-
-		switch@10 {
-			compatible = "qca,qca8337";
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			reset-gpios = <&gpio 42 GPIO_ACTIVE_LOW>;
-			reg = <0x10>;
-
-			ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
-				port@0 {
-					reg = <0>;
-					label = "cpu";
-					ethernet = <&gmac1>;
-					phy-mode = "rgmii";
-					fixed-link {
-						speed = 1000;
-						full-duplex;
-					};
-				};
-
-				port@1 {
-					reg = <1>;
-					label = "lan1";
-					phy-handle = <&phy_port1>;
-				};
-
-				port@2 {
-					reg = <2>;
-					label = "lan2";
-					phy-handle = <&phy_port2>;
-				};
-
-				port@3 {
-					reg = <3>;
-					label = "lan3";
-					phy-handle = <&phy_port3>;
-				};
-
-				port@4 {
-					reg = <4>;
-					label = "lan4";
-					phy-handle = <&phy_port4>;
-				};
-
-				port@5 {
-					reg = <5>;
-					label = "wan";
-					phy-handle = <&phy_port5>;
-				};
-			};
-		};
-	};
-
-for the internal master mdio-bus configuration:
-
-	&mdio0 {
-		switch@10 {
-			compatible = "qca,qca8337";
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			reset-gpios = <&gpio 42 GPIO_ACTIVE_LOW>;
-			reg = <0x10>;
-
-			ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				port@0 {
-					reg = <0>;
-					label = "cpu";
-					ethernet = <&gmac1>;
-					phy-mode = "rgmii";
-					fixed-link {
-						speed = 1000;
-						full-duplex;
-					};
-				};
-
-				port@1 {
-					reg = <1>;
-					label = "lan1";
-					phy-mode = "internal";
-					phy-handle = <&phy_port1>;
-				};
-
-				port@2 {
-					reg = <2>;
-					label = "lan2";
-					phy-mode = "internal";
-					phy-handle = <&phy_port2>;
-				};
-
-				port@3 {
-					reg = <3>;
-					label = "lan3";
-					phy-mode = "internal";
-					phy-handle = <&phy_port3>;
-				};
-
-				port@4 {
-					reg = <4>;
-					label = "lan4";
-					phy-mode = "internal";
-					phy-handle = <&phy_port4>;
-				};
-
-				port@5 {
-					reg = <5>;
-					label = "wan";
-					phy-mode = "internal";
-					phy-handle = <&phy_port5>;
-				};
-			};
-
-			mdio {
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				phy_port1: phy@0 {
-					reg = <0>;
-				};
-
-				phy_port2: phy@1 {
-					reg = <1>;
-				};
-
-				phy_port3: phy@2 {
-					reg = <2>;
-				};
-
-				phy_port4: phy@3 {
-					reg = <3>;
-				};
-
-				phy_port5: phy@4 {
-					reg = <4>;
-				};
-			};
-		};
-	};
diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
new file mode 100644
index 000000000000..0f833b28d37a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -0,0 +1,362 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/qca8k.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm Atheros QCA83xx switch family
+
+maintainers:
+  - John Crispin <john@phrozen.org>
+
+description:
+  If the QCA8K switch is connect to an SoC's external mdio-bus, each subnode
+  describing a port needs to have a valid phandle referencing the internal PHY
+  it is connected to. This is because there is no N:N mapping of port and PHY
+  ID. To declare the internal mdio-bus configuration, declare an MDIO node in
+  the switch node and declare the phandle for the port, referencing the internal
+  PHY it is connected to. In this config, an internal mdio-bus is registered and
+  the MDIO master is used for communication. Mixed external and internal
+  mdio-bus configurations are not supported by the hardware.
+
+properties:
+  compatible:
+    oneOf:
+      - enum:
+          - qca,qca8327
+          - qca,qca8328
+          - qca,qca8334
+          - qca,qca8337
+    description: |
+      qca,qca8328: referenced as AR8328(N)-AK1(A/B) QFN 176 pin package
+      qca,qca8327: referenced as AR8327(N)-AL1A DR-QFN 148 pin package
+      qca,qca8334: referenced as QCA8334-AL3C QFN 88 pin package
+      qca,qca8337: referenced as QCA8337N-AL3(B/C) DR-QFN 148 pin package
+
+  reg:
+    maxItems: 1
+
+  reset-gpios:
+    description:
+      GPIO to be used to reset the whole device
+    maxItems: 1
+
+  qca,ignore-power-on-sel:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      Ignore power-on pin strapping to configure LED open-drain or EEPROM
+      presence. This is needed for devices with incorrect configuration or when
+      the OEM has decided not to use pin strapping and falls back to SW regs.
+
+  qca,led-open-drain:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      Set LEDs to open-drain mode. This requires the qca,ignore-power-on-sel to
+      be set, otherwise the driver will fail at probe. This is required if the
+      OEM does not use pin strapping to set this mode and prefers to set it
+      using SW regs. The pin strappings related to LED open-drain mode are
+      B68 on the QCA832x and B49 on the QCA833x.
+
+  mdio:
+    type: object
+    description: Qca8k switch have an internal mdio to access switch port.
+                 If this is not present, the legacy mapping is used and the
+                 internal mdio access is used.
+                 With the legacy mapping the reg corresponding to the internal
+                 mdio is the switch reg with an offset of -1.
+
+    properties:
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
+patternProperties:
+  "^(ethernet-)?ports$":
+    type: object
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      "^(ethernet-)?port@[0-6]$":
+        type: object
+        description: Ethernet switch ports
+
+        properties:
+          reg:
+            description: Port number
+
+          label:
+            description:
+              Describes the label associated with this port, which will become
+              the netdev name
+            $ref: /schemas/types.yaml#/definitions/string
+
+          link:
+            description:
+              Should be a list of phandles to other switch's DSA port. This
+              port is used as the outgoing port towards the phandle ports. The
+              full routing information must be given, not just the one hop
+              routes to neighbouring switches
+            $ref: /schemas/types.yaml#/definitions/phandle-array
+
+          ethernet:
+            description:
+              Should be a phandle to a valid Ethernet device node.  This host
+              device is what the switch port is connected to
+            $ref: /schemas/types.yaml#/definitions/phandle
+
+          phy-handle: true
+
+          phy-mode: true
+
+          fixed-link: true
+
+          mac-address: true
+
+          sfp: true
+
+          qca,sgmii-rxclk-falling-edge:
+            $ref: /schemas/types.yaml#/definitions/flag
+            description:
+              Set the receive clock phase to falling edge. Mostly commonly used on
+              the QCA8327 with CPU port 0 set to SGMII.
+
+          qca,sgmii-txclk-falling-edge:
+            $ref: /schemas/types.yaml#/definitions/flag
+            description:
+              Set the transmit clock phase to falling edge.
+
+          qca,sgmii-enable-pll:
+            $ref: /schemas/types.yaml#/definitions/flag
+            description:
+              For SGMII CPU port, explicitly enable PLL, TX and RX chain along with
+              Signal Detection. On the QCA8327 this should not be enabled, otherwise
+              the SGMII port will not initialize. When used on the QCA8337, revision 3
+              or greater, a warning will be displayed. When the CPU port is set to
+              SGMII on the QCA8337, it is advised to set this unless a communication
+              issue is observed.
+
+        required:
+          - reg
+
+        additionalProperties: false
+
+oneOf:
+  - required:
+      - ports
+  - required:
+      - ethernet-ports
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: true
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+
+    mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        external_phy_port1: ethernet-phy@0 {
+            reg = <0>;
+        };
+
+        external_phy_port2: ethernet-phy@1 {
+            reg = <1>;
+        };
+
+        external_phy_port3: ethernet-phy@2 {
+            reg = <2>;
+        };
+
+        external_phy_port4: ethernet-phy@3 {
+            reg = <3>;
+        };
+
+        external_phy_port5: ethernet-phy@4 {
+            reg = <4>;
+        };
+
+        switch@10 {
+            compatible = "qca,qca8337";
+            #address-cells = <1>;
+            #size-cells = <0>;
+            reset-gpios = <&gpio 42 GPIO_ACTIVE_LOW>;
+            reg = <0x10>;
+
+            ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                    reg = <0>;
+                    label = "cpu";
+                    ethernet = <&gmac1>;
+                    phy-mode = "rgmii";
+
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                    };
+                };
+
+                port@1 {
+                    reg = <1>;
+                    label = "lan1";
+                    phy-handle = <&external_phy_port1>;
+                };
+
+                port@2 {
+                    reg = <2>;
+                    label = "lan2";
+                    phy-handle = <&external_phy_port2>;
+                };
+
+                port@3 {
+                    reg = <3>;
+                    label = "lan3";
+                    phy-handle = <&external_phy_port3>;
+                };
+
+                port@4 {
+                    reg = <4>;
+                    label = "lan4";
+                    phy-handle = <&external_phy_port4>;
+                };
+
+                port@5 {
+                    reg = <5>;
+                    label = "wan";
+                    phy-handle = <&external_phy_port5>;
+                };
+            };
+        };
+    };
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+
+    mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        switch@10 {
+            compatible = "qca,qca8337";
+            #address-cells = <1>;
+            #size-cells = <0>;
+            reset-gpios = <&gpio 42 GPIO_ACTIVE_LOW>;
+            reg = <0x10>;
+
+            ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                    reg = <0>;
+                    label = "cpu";
+                    ethernet = <&gmac1>;
+                    phy-mode = "rgmii";
+
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                    };
+                };
+
+                port@1 {
+                    reg = <1>;
+                    label = "lan1";
+                    phy-mode = "internal";
+                    phy-handle = <&internal_phy_port1>;
+                };
+
+                port@2 {
+                    reg = <2>;
+                    label = "lan2";
+                    phy-mode = "internal";
+                    phy-handle = <&internal_phy_port2>;
+                };
+
+                port@3 {
+                    reg = <3>;
+                    label = "lan3";
+                    phy-mode = "internal";
+                    phy-handle = <&internal_phy_port3>;
+                };
+
+                port@4 {
+                    reg = <4>;
+                    label = "lan4";
+                    phy-mode = "internal";
+                    phy-handle = <&internal_phy_port4>;
+                };
+
+                port@5 {
+                    reg = <5>;
+                    label = "wan";
+                    phy-mode = "internal";
+                    phy-handle = <&internal_phy_port5>;
+                };
+
+                port@6 {
+                    reg = <0>;
+                    label = "cpu";
+                    ethernet = <&gmac1>;
+                    phy-mode = "sgmii";
+
+                    qca,sgmii-rxclk-falling-edge;
+
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                    };
+                };
+            };
+
+            mdio {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                internal_phy_port1: ethernet-phy@0 {
+                    reg = <0>;
+                };
+
+                internal_phy_port2: ethernet-phy@1 {
+                    reg = <1>;
+                };
+
+                internal_phy_port3: ethernet-phy@2 {
+                    reg = <2>;
+                };
+
+                internal_phy_port4: ethernet-phy@3 {
+                    reg = <3>;
+                };
+
+                internal_phy_port5: ethernet-phy@4 {
+                    reg = <4>;
+                };
+            };
+        };
+    };
\ No newline at end of file
-- 
2.32.0

