Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4942AFF0C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgKLFdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729118AbgKLEwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 23:52:54 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96434C061A4B;
        Wed, 11 Nov 2020 20:51:54 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id g7so3394766pfc.2;
        Wed, 11 Nov 2020 20:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WhuYA1a6TERII5H+wgmmnG4EhgqA+DZXglaNonkZwz4=;
        b=JhzIVeWx81eexEi3AeJHg1mMK3yPoixKMojlX1N72qHq4lnFoP568Iq7SE+/46h/2b
         Z0H0tW+eQO5KoelEREnWBJ1He2sDnsijEiyP+7JoeR4+640Q4ZAT5Knxe9X5aAmmEjxR
         6UcCwLPJ4M6qBQPjpzlQZkpP589pgrgAS8ZUGNM1LAurqrKC/W3vdOpZOtZq6bQyd03r
         o0zTZd+xYEFnbPZNT42LHYfGyyhDZgDGAqBzxQli3q//asxWmtzO60ihmTTQsUl/b7av
         ZBTa/B6KvyKLfv3ySQ6BCiYo+HuH7TJNi8TX524c4ol/CidOZiZLnCg77GUBWXhp3lSS
         oUxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WhuYA1a6TERII5H+wgmmnG4EhgqA+DZXglaNonkZwz4=;
        b=pAM4s70iYXs0+xGnTRvUKOCu74UtXFUvVblzySMJvgTYIScyiHIcrvkQP+FZKwfHA/
         VgTbNMPKAuYkX7dVI6wcQ02OyTB9Ppc9pfEKDVX5OC0SDA6uKClGkfiyNNRWPJQgpAsS
         S/72xQ6XdPMrFaZcEKT3XYAtgXuXRN5uZ29ufFaG761sUAFuqYJVcLHsCgUKt3uNbd0q
         KjhhjphNYxyhDswftYDsbaepHfUi/AY/o+ovCqRpkYM3CO5gGL1z6rAEZQh/ESoXZU1L
         9cPVW3fiTpbwu1W5BqsXAcz21nPnzULBrQW0H5zdSQdpfi1LeHzR81ymEMPQarrsRYIq
         IDUw==
X-Gm-Message-State: AOAM533jO9vWXPmZUdgkXtOXYe/GXSBBNXeYK/2QqwEQYBMqNqj/bgB6
        1kvJnXoJqoIsMnFDzKFLAhY=
X-Google-Smtp-Source: ABdhPJyQJfGr595gk9r5bWUCaSBbmEGS7XMmoDf64r3aRYSfVqpN94GQLFOwmfTsAK59x3VdGMAMVQ==
X-Received: by 2002:a17:90a:5b16:: with SMTP id o22mr7824361pji.224.1605156714133;
        Wed, 11 Nov 2020 20:51:54 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gk22sm4189087pjb.39.2020.11.11.20.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 20:51:53 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Kurt Kanzenbach <kurt@kmk-computers.de>,
        Rob Herring <robh@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC ARM
        ARCHITECTURE), Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 10/10] dt-bindings: net: dsa: b53: Add YAML bindings
Date:   Wed, 11 Nov 2020 20:50:20 -0800
Message-Id: <20201112045020.9766-11-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112045020.9766-1-f.fainelli@gmail.com>
References: <20201112045020.9766-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@kmk-computers.de>

Convert the b53 DSA device tree bindings to YAML in order to allow
for automatic checking and such.

Reviewed-by: Rob Herring <robh@kernel.org>
Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
---
 .../devicetree/bindings/net/dsa/b53.txt       | 149 -----------
 .../devicetree/bindings/net/dsa/brcm,b53.yaml | 249 ++++++++++++++++++
 MAINTAINERS                                   |   2 +-
 3 files changed, 250 insertions(+), 150 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/b53.txt
 create mode 100644 Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/b53.txt b/Documentation/devicetree/bindings/net/dsa/b53.txt
deleted file mode 100644
index f1487a751b1a..000000000000
--- a/Documentation/devicetree/bindings/net/dsa/b53.txt
+++ /dev/null
@@ -1,149 +0,0 @@
-Broadcom BCM53xx Ethernet switches
-==================================
-
-Required properties:
-
-- compatible: For external switch chips, compatible string must be exactly one
-  of: "brcm,bcm5325"
-      "brcm,bcm53115"
-      "brcm,bcm53125"
-      "brcm,bcm53128"
-      "brcm,bcm5365"
-      "brcm,bcm5395"
-      "brcm,bcm5389"
-      "brcm,bcm5397"
-      "brcm,bcm5398"
-
-  For the BCM11360 SoC, must be:
-      "brcm,bcm11360-srab" and the mandatory "brcm,cygnus-srab" string
-
-  For the BCM5310x SoCs with an integrated switch, must be one of:
-      "brcm,bcm53010-srab"
-      "brcm,bcm53011-srab"
-      "brcm,bcm53012-srab"
-      "brcm,bcm53018-srab"
-      "brcm,bcm53019-srab" and the mandatory "brcm,bcm5301x-srab" string
-
-  For the BCM5831X/BCM1140x SoCs with an integrated switch, must be one of:
-      "brcm,bcm11404-srab"
-      "brcm,bcm11407-srab"
-      "brcm,bcm11409-srab"
-      "brcm,bcm58310-srab"
-      "brcm,bcm58311-srab"
-      "brcm,bcm58313-srab" and the mandatory "brcm,omega-srab" string
-
-  For the BCM585xx/586XX/88312 SoCs with an integrated switch, must be one of:
-      "brcm,bcm58522-srab"
-      "brcm,bcm58523-srab"
-      "brcm,bcm58525-srab"
-      "brcm,bcm58622-srab"
-      "brcm,bcm58623-srab"
-      "brcm,bcm58625-srab"
-      "brcm,bcm88312-srab" and the mandatory "brcm,nsp-srab string
-
-  For the BCM63xx/33xx SoCs with an integrated switch, must be one of:
-      "brcm,bcm3384-switch"
-      "brcm,bcm6328-switch"
-      "brcm,bcm6368-switch" and the mandatory "brcm,bcm63xx-switch"
-
-Required properties for BCM585xx/586xx/88312 SoCs:
-
- - reg: a total of 3 register base addresses, the first one must be the
-   Switch Register Access block base, the second is the port 5/4 mux
-   configuration register and the third one is the SGMII configuration
-   and status register base address.
-
- - interrupts: a total of 13 interrupts must be specified, in the following
-   order: port 0-5, 7-8 link status change, then the integrated PHY interrupt,
-   then the timestamping interrupt and the sleep timer interrupts for ports
-   5,7,8.
-
-Optional properties for BCM585xx/586xx/88312 SoCs:
-
-  - reg-names: a total of 3 names matching the 3 base register address, must
-    be in the following order:
-	"srab"
-	"mux_config"
-	"sgmii_config"
-
-  - interrupt-names: a total of 13 names matching the 13 interrupts specified
-    must be in the following order:
-	"link_state_p0"
-	"link_state_p1"
-	"link_state_p2"
-	"link_state_p3"
-	"link_state_p4"
-	"link_state_p5"
-	"link_state_p7"
-	"link_state_p8"
-	"phy"
-	"ts"
-	"imp_sleep_timer_p5"
-	"imp_sleep_timer_p7"
-	"imp_sleep_timer_p8"
-
-See Documentation/devicetree/bindings/net/dsa/dsa.txt for a list of additional
-required and optional properties.
-
-Examples:
-
-Ethernet switch connected via MDIO to the host, CPU port wired to eth0:
-
-	eth0: ethernet@10001000 {
-		compatible = "brcm,unimac";
-		reg = <0x10001000 0x1000>;
-
-		fixed-link {
-			speed = <1000>;
-			full-duplex;
-		};
-	};
-
-	mdio0: mdio@10000000 {
-		compatible = "brcm,unimac-mdio";
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		switch0: ethernet-switch@1e {
-			compatible = "brcm,bcm53125";
-			reg = <30>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				port0@0 {
-					reg = <0>;
-					label = "lan1";
-				};
-
-				port1@1 {
-					reg = <1>;
-					label = "lan2";
-				};
-
-				port5@5 {
-					reg = <5>;
-					label = "cable-modem";
-					fixed-link {
-						speed = <1000>;
-						full-duplex;
-					};
-					phy-mode = "rgmii-txid";
-				};
-
-				port8@8 {
-					reg = <8>;
-					label = "cpu";
-					fixed-link {
-						speed = <1000>;
-						full-duplex;
-					};
-					phy-mode = "rgmii-txid";
-					ethernet = <&eth0>;
-				};
-			};
-		};
-	};
diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
new file mode 100644
index 000000000000..c3c938893ad9
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
@@ -0,0 +1,249 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/brcm,b53.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom BCM53xx Ethernet switches
+
+allOf:
+  - $ref: dsa.yaml#
+
+maintainers:
+  - Florian Fainelli <f.fainelli@gmail.com>
+
+description:
+  Broadcom BCM53xx Ethernet switches
+
+properties:
+  compatible:
+    oneOf:
+      - const: brcm,bcm5325
+      - const: brcm,bcm53115
+      - const: brcm,bcm53125
+      - const: brcm,bcm53128
+      - const: brcm,bcm5365
+      - const: brcm,bcm5395
+      - const: brcm,bcm5389
+      - const: brcm,bcm5397
+      - const: brcm,bcm5398
+      - items:
+          - const: brcm,bcm11360-srab
+          - const: brcm,cygnus-srab
+      - items:
+          - enum:
+              - brcm,bcm53010-srab
+              - brcm,bcm53011-srab
+              - brcm,bcm53012-srab
+              - brcm,bcm53018-srab
+              - brcm,bcm53019-srab
+          - const: brcm,bcm5301x-srab
+      - items:
+          - enum:
+              - brcm,bcm11404-srab
+              - brcm,bcm11407-srab
+              - brcm,bcm11409-srab
+              - brcm,bcm58310-srab
+              - brcm,bcm58311-srab
+              - brcm,bcm58313-srab
+          - const: brcm,omega-srab
+      - items:
+          - enum:
+              - brcm,bcm58522-srab
+              - brcm,bcm58523-srab
+              - brcm,bcm58525-srab
+              - brcm,bcm58622-srab
+              - brcm,bcm58623-srab
+              - brcm,bcm58625-srab
+              - brcm,bcm88312-srab
+          - const: brcm,nsp-srab
+      - items:
+          - enum:
+              - brcm,bcm3384-switch
+              - brcm,bcm6328-switch
+              - brcm,bcm6368-switch
+          - const: brcm,bcm63xx-switch
+
+required:
+  - compatible
+  - reg
+
+# BCM585xx/586xx/88312 SoCs
+if:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - brcm,bcm58522-srab
+          - brcm,bcm58523-srab
+          - brcm,bcm58525-srab
+          - brcm,bcm58622-srab
+          - brcm,bcm58623-srab
+          - brcm,bcm58625-srab
+          - brcm,bcm88312-srab
+then:
+  properties:
+    reg:
+      minItems: 3
+      maxItems: 3
+    reg-names:
+      items:
+        - const: srab
+        - const: mux_config
+        - const: sgmii_config
+    interrupts:
+      minItems: 13
+      maxItems: 13
+    interrupt-names:
+      items:
+        - const: link_state_p0
+        - const: link_state_p1
+        - const: link_state_p2
+        - const: link_state_p3
+        - const: link_state_p4
+        - const: link_state_p5
+        - const: link_state_p7
+        - const: link_state_p8
+        - const: phy
+        - const: ts
+        - const: imp_sleep_timer_p5
+        - const: imp_sleep_timer_p7
+        - const: imp_sleep_timer_p8
+  required:
+    - interrupts
+else:
+  properties:
+    reg:
+      maxItems: 1
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet-switch@1e {
+            compatible = "brcm,bcm53125";
+            reg = <30>;
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
+                port@5 {
+                    reg = <5>;
+                    label = "cable-modem";
+                    phy-mode = "rgmii-txid";
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                    };
+                };
+
+                port@8 {
+                    reg = <8>;
+                    label = "cpu";
+                    phy-mode = "rgmii-txid";
+                    ethernet = <&eth0>;
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                    };
+                };
+            };
+        };
+    };
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    axi {
+        #address-cells = <1>;
+        #size-cells = <1>;
+
+        switch@36000 {
+            compatible = "brcm,bcm58623-srab", "brcm,nsp-srab";
+            reg = <0x36000 0x1000>,
+                  <0x3f308 0x8>,
+                  <0x3f410 0xc>;
+            reg-names = "srab", "mux_config", "sgmii_config";
+            interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 98 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 99 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 100 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 104 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
+            interrupt-names = "link_state_p0",
+                              "link_state_p1",
+                              "link_state_p2",
+                              "link_state_p3",
+                              "link_state_p4",
+                              "link_state_p5",
+                              "link_state_p7",
+                              "link_state_p8",
+                              "phy",
+                              "ts",
+                              "imp_sleep_timer_p5",
+                              "imp_sleep_timer_p7",
+                              "imp_sleep_timer_p8";
+
+            ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                    label = "port0";
+                    reg = <0>;
+                };
+
+                port@1 {
+                    label = "port1";
+                    reg = <1>;
+                };
+
+                port@2 {
+                    label = "port2";
+                    reg = <2>;
+                };
+
+                port@3 {
+                    label = "port3";
+                    reg = <3>;
+                };
+
+                port@4 {
+                    label = "port4";
+                    reg = <4>;
+                };
+
+                port@8 {
+                    ethernet = <&amac2>;
+                    label = "cpu";
+                    reg = <8>;
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                    };
+                };
+            };
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index e73636b75f29..3786322d0bfb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3380,7 +3380,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 L:	netdev@vger.kernel.org
 L:	openwrt-devel@lists.openwrt.org (subscribers-only)
 S:	Supported
-F:	Documentation/devicetree/bindings/net/dsa/b53.txt
+F:	Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
 F:	drivers/net/dsa/b53/*
 F:	include/linux/platform_data/b53.h
 
-- 
2.25.1

