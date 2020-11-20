Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392542BA8F2
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 12:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgKTLXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 06:23:44 -0500
Received: from mailout07.rmx.de ([94.199.90.95]:41301 "EHLO mailout07.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727197AbgKTLXn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 06:23:43 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout07.rmx.de (Postfix) with ESMTPS id 4CcvLd3qZvzBx68;
        Fri, 20 Nov 2020 12:23:37 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CcvKQ4YnCz2TTL1;
        Fri, 20 Nov 2020 12:22:34 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.143) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 20 Nov
 2020 12:22:03 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Kurt Kanzenbach" <kurt.kanzenbach@linutronix.de>,
        Marek Vasut <marex@denx.de>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "Christian Eggers" <ceggers@arri.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 1/4] dt-bindings: net: dsa: convert ksz bindings document to yaml
Date:   Fri, 20 Nov 2020 12:21:04 +0100
Message-ID: <20201120112107.16334-2-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201120112107.16334-1-ceggers@arri.de>
References: <20201120112107.16334-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.143]
X-RMX-ID: 20201120-122234-4CcvKQ4YnCz2TTL1-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the bindings document for Microchip KSZ Series Ethernet switches
from txt to yaml. Removed spi-cpha and spi-cpol flags is this should be
handled by the device driver.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 .../devicetree/bindings/net/dsa/ksz.txt       | 125 ---------------
 .../bindings/net/dsa/microchip,ksz.yaml       | 148 ++++++++++++++++++
 MAINTAINERS                                   |   2 +-
 3 files changed, 149 insertions(+), 126 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/ksz.txt
 create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/ksz.txt b/Documentation/devicetree/bindings/net/dsa/ksz.txt
deleted file mode 100644
index 95e91e84151c..000000000000
--- a/Documentation/devicetree/bindings/net/dsa/ksz.txt
+++ /dev/null
@@ -1,125 +0,0 @@
-Microchip KSZ Series Ethernet switches
-==================================
-
-Required properties:
-
-- compatible: For external switch chips, compatible string must be exactly one
-  of the following:
-  - "microchip,ksz8765"
-  - "microchip,ksz8794"
-  - "microchip,ksz8795"
-  - "microchip,ksz9477"
-  - "microchip,ksz9897"
-  - "microchip,ksz9896"
-  - "microchip,ksz9567"
-  - "microchip,ksz8565"
-  - "microchip,ksz9893"
-  - "microchip,ksz9563"
-  - "microchip,ksz8563"
-
-Optional properties:
-
-- reset-gpios		: Should be a gpio specifier for a reset line
-- microchip,synclko-125 : Set if the output SYNCLKO frequency should be set to
-			  125MHz instead of 25MHz.
-
-See Documentation/devicetree/bindings/net/dsa/dsa.txt for a list of additional
-required and optional properties.
-
-Examples:
-
-Ethernet switch connected via SPI to the host, CPU port wired to eth0:
-
-	eth0: ethernet@10001000 {
-		fixed-link {
-			speed = <1000>;
-			full-duplex;
-		};
-	};
-
-	spi1: spi@f8008000 {
-		pinctrl-0 = <&pinctrl_spi_ksz>;
-		cs-gpios = <&pioC 25 0>;
-		id = <1>;
-
-		ksz9477: ksz9477@0 {
-			compatible = "microchip,ksz9477";
-			reg = <0>;
-
-			spi-max-frequency = <44000000>;
-			spi-cpha;
-			spi-cpol;
-
-			ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
-				port@0 {
-					reg = <0>;
-					label = "lan1";
-				};
-				port@1 {
-					reg = <1>;
-					label = "lan2";
-				};
-				port@2 {
-					reg = <2>;
-					label = "lan3";
-				};
-				port@3 {
-					reg = <3>;
-					label = "lan4";
-				};
-				port@4 {
-					reg = <4>;
-					label = "lan5";
-				};
-				port@5 {
-					reg = <5>;
-					label = "cpu";
-					ethernet = <&eth0>;
-					fixed-link {
-						speed = <1000>;
-						full-duplex;
-					};
-				};
-			};
-		};
-		ksz8565: ksz8565@0 {
-			compatible = "microchip,ksz8565";
-			reg = <0>;
-
-			spi-max-frequency = <44000000>;
-			spi-cpha;
-			spi-cpol;
-
-			ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
-				port@0 {
-					reg = <0>;
-					label = "lan1";
-				};
-				port@1 {
-					reg = <1>;
-					label = "lan2";
-				};
-				port@2 {
-					reg = <2>;
-					label = "lan3";
-				};
-				port@3 {
-					reg = <3>;
-					label = "lan4";
-				};
-				port@6 {
-					reg = <6>;
-					label = "cpu";
-					ethernet = <&eth0>;
-					fixed-link {
-						speed = <1000>;
-						full-duplex;
-					};
-				};
-			};
-		};
-	};
diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
new file mode 100644
index 000000000000..9f7d131bbcef
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -0,0 +1,148 @@
+# SPDX-License-Identifier: GPL-2.0-only
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/microchip,ksz.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Microchip KSZ Series Ethernet switches
+
+maintainers:
+  - Marek Vasut <marex@denx.de>
+  - Woojung Huh <Woojung.Huh@microchip.com>
+
+allOf:
+  - $ref: dsa.yaml#
+
+properties:
+  # See Documentation/devicetree/bindings/net/dsa/dsa.yaml for a list of additional
+  # required and optional properties.
+  compatible:
+    enum:
+      - microchip,ksz8765
+      - microchip,ksz8794
+      - microchip,ksz8795
+      - microchip,ksz9477
+      - microchip,ksz9897
+      - microchip,ksz9896
+      - microchip,ksz9567
+      - microchip,ksz8565
+      - microchip,ksz9893
+      - microchip,ksz9563
+      - microchip,ksz8563
+
+  reset-gpios:
+    description:
+      Should be a gpio specifier for a reset line.
+    maxItems: 1
+
+  microchip,synclko-125:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      Set if the output SYNCLKO frequency should be set to 125MHz instead of 25MHz.
+
+required:
+  - compatible
+  - reg
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+
+    // Ethernet switch connected via SPI to the host, CPU port wired to eth0:
+    eth0 {
+        fixed-link {
+            speed = <1000>;
+            full-duplex;
+        };
+    };
+
+    spi0 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        pinctrl-0 = <&pinctrl_spi_ksz>;
+        cs-gpios = <&pioC 25 0>;
+        id = <1>;
+
+        ksz9477: switch@0 {
+            compatible = "microchip,ksz9477";
+            reg = <0>;
+            reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
+
+            spi-max-frequency = <44000000>;
+
+            ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+                port@0 {
+                    reg = <0>;
+                    label = "lan1";
+                };
+                port@1 {
+                    reg = <1>;
+                    label = "lan2";
+                };
+                port@2 {
+                    reg = <2>;
+                    label = "lan3";
+                };
+                port@3 {
+                    reg = <3>;
+                    label = "lan4";
+                };
+                port@4 {
+                    reg = <4>;
+                    label = "lan5";
+                };
+                port@5 {
+                    reg = <5>;
+                    label = "cpu";
+                    ethernet = <&eth0>;
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                    };
+                };
+            };
+        };
+
+        ksz8565: switch@1 {
+            compatible = "microchip,ksz8565";
+            reg = <1>;
+
+            spi-max-frequency = <44000000>;
+
+            ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+                port@0 {
+                    reg = <0>;
+                    label = "lan1";
+                };
+                port@1 {
+                    reg = <1>;
+                    label = "lan2";
+                };
+                port@2 {
+                    reg = <2>;
+                    label = "lan3";
+                };
+                port@3 {
+                    reg = <3>;
+                    label = "lan4";
+                };
+                port@6 {
+                    reg = <6>;
+                    label = "cpu";
+                    ethernet = <&eth0>;
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                    };
+                };
+            };
+        };
+    };
+...
diff --git a/MAINTAINERS b/MAINTAINERS
index 18b5b7896af8..d1003033412f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11508,7 +11508,7 @@ M:	Woojung Huh <woojung.huh@microchip.com>
 M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/net/dsa/ksz.txt
+F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
 F:	drivers/net/dsa/microchip/*
 F:	include/linux/platform_data/microchip-ksz.h
 F:	net/dsa/tag_ksz.c
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

