Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EB82ACBBE
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731801AbgKJDbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731523AbgKJDbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 22:31:45 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9CCC0613CF;
        Mon,  9 Nov 2020 19:31:43 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id e21so8948231pgr.11;
        Mon, 09 Nov 2020 19:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5S2dxf5ZBT8GMg7IucYtvzhLC6Ir46d9kuCR+7OEg7c=;
        b=IR2+xrszCjBV8MolUuck7ampgZVjR8YgOs/ceXTEYCTfvyc+jKinThQEEQr6AhxpS0
         hCU9FOBr3E+0LYVRwyRUlKXjGxboUKhcSBJQiNzeKfVImrYZZhxACZu6qtP9Ke6O6b86
         +Yx6+RqufFeMRIH/S8koF5P3Yt0OMeNnGBYxbpZUgnEpimaCC4kLzU15K8M//hM3T1Q5
         8heAzvQ1bBclGTLkhditx5sqPF7zxZnzhfMnBb4V5fvJsoOE9SVBz8RTtNpGE4WBXmds
         s5zEPt7DZV7x7LTNW9odzG43uGNbCIiNcfp/XLLUqH+m+hpTW2UaoYEK+ZjGCQCoaFYD
         10uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5S2dxf5ZBT8GMg7IucYtvzhLC6Ir46d9kuCR+7OEg7c=;
        b=XquLBAoq77RC/z9+TdeD9/sVc3MetMOFUpMmHN7Dm6sgdGLDJZie6qmRGonrnrgAgf
         n1QVtuM+WNbMFtE5vUhR1bMSO1qFM+Fq0M1CuT5vATWlscObfjNPL+7iWpYqUY279cdO
         W5QUh32+cMuJp5N6RZbD2yT6vDhUtU+k0iDtlhjowfvfgP3GpzRN9nGcxGdBKb6fdKrx
         36CSQZqpj9MBVLi2vYmzEm7TzbohOX13KwN0MZ6WZRxTRemS/P/mYQ1miArWM5wokmlk
         x7R2LqNN/yxGK0ah7PNeES7Tdinsjie4smFEtUBOIDHqkPH8/m+Kg9+9bq4FLXabz4l3
         rmHw==
X-Gm-Message-State: AOAM533oEkWsssZUTS9GA7z0aSkuMIOuqJizAC1k3lNr6oAKEqbsvDNT
        ewVcOwj3AWXufWG7AVjeGlDTqUR7z4A=
X-Google-Smtp-Source: ABdhPJwBnwDcay9tMAuFfah7q1IDbkruYbZg9q5Ms9lz9WiwXwm/4NXZffqrnQCP5/rG1vx2X/TcxA==
X-Received: by 2002:a17:90a:170b:: with SMTP id z11mr2656643pjd.83.1604979102979;
        Mon, 09 Nov 2020 19:31:42 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k12sm965677pjf.22.2020.11.09.19.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 19:31:42 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Kurt Kanzenbach <kurt@kmk-computers.de>,
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
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE)
Subject: [PATCH 10/10] dt-bindings: net: dsa: b53: Add YAML bindings
Date:   Mon,  9 Nov 2020 19:31:13 -0800
Message-Id: <20201110033113.31090-11-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201110033113.31090-1-f.fainelli@gmail.com>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@kmk-computers.de>

Convert the b53 DSA device tree bindings to YAML in order to allow
for automatic checking and such.

Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
---
 .../devicetree/bindings/net/dsa/b53.txt       | 149 -----------
 .../devicetree/bindings/net/dsa/b53.yaml      | 249 ++++++++++++++++++
 MAINTAINERS                                   |   2 +-
 3 files changed, 250 insertions(+), 150 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/b53.txt
 create mode 100644 Documentation/devicetree/bindings/net/dsa/b53.yaml

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
diff --git a/Documentation/devicetree/bindings/net/dsa/b53.yaml b/Documentation/devicetree/bindings/net/dsa/b53.yaml
new file mode 100644
index 000000000000..4fcbac1de95b
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/b53.yaml
@@ -0,0 +1,249 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/b53.yaml#
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
+        switch@1e {
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
index 3da6d8c154e4..d2e2ea9eb527 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3377,7 +3377,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 L:	netdev@vger.kernel.org
 L:	openwrt-devel@lists.openwrt.org (subscribers-only)
 S:	Supported
-F:	Documentation/devicetree/bindings/net/dsa/b53.txt
+F:	Documentation/devicetree/bindings/net/dsa/b53.yaml
 F:	drivers/net/dsa/b53/*
 F:	include/linux/platform_data/b53.h
 
-- 
2.25.1

