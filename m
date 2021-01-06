Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498232EC5C3
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 22:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbhAFVcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 16:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbhAFVcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 16:32:53 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5992DC061575;
        Wed,  6 Jan 2021 13:32:13 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id y19so9746516lfa.13;
        Wed, 06 Jan 2021 13:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=swjzxgNgdFwMaW1XS6NoCIl7n4hzVMa78pM5N63kujo=;
        b=d9nXQ7cwe0rN31o6hBKHcOHt6N+RlUdysFXNTAcH5jzZhb5vimJOjJ4ZqqWJiuoeo8
         xIP49r4cl9lk0aBdfbeVKXM7jvilZu91vHf2U8+BHSu5eeXLHPV3e9mX9XjM2snaZGtB
         BKkBIzTC56fQRHN71n9Uf/Ierp3QVp9lsD70PVZcXyPB3yYjcxBfoFFjs6FNuU6Xt6EI
         7rMMYcx+0ojhmCkt2zTjiVNy4axs+ofB/GTRdeHwOm1RJmEZOrxjyPIVVQ0NEWQeUlDn
         LCsYxp6W39W884RT+q4jfi0wblyvAWi+suOBHw65YNvo3VTyFcslTrCRwFQwUbXJh7v5
         A5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=swjzxgNgdFwMaW1XS6NoCIl7n4hzVMa78pM5N63kujo=;
        b=RKrD3529hAuw32nMqakfEEm9Hg/+3di1L9GWf9M2zT44ei886r4H7uH0JUeoAd40d+
         +lehsv7oZ2W/NH0ZeEpSs7HWzB9hV5eALylJk7f8ghmAlZ7aJP0iWrnvWEk96gJG4owv
         /+OS5GAxb/O3UoM8w6dHXJXSpSBa5jLnlEV0VSuewQYyaD7+T3xBC+LlnR2l22EBWEaw
         ZFjVqWf1v3PAqs/11L2RQ9qPQM0Z9lx74hrKO4TUW1GunltqrhT5Qw7gao/29JKjcNfB
         GEkc3pC3kEhqTNIV5oVxtRCGl6PM8Cwvb7a1AcAlK7S8mScgS77M9Y2ZDLmV2tJH9lac
         sfsw==
X-Gm-Message-State: AOAM531gayscnTItPi9GsPL0KY6995KqOA4I1Ny+ZcoyX2KjP5XH5Ge+
        ybXf6UcA3AOSPkqjFOqLceI=
X-Google-Smtp-Source: ABdhPJxEdUvb47WxwP6dptf6PJ+Rgo4TJm5/70lNY5xAsvTKwieFuDW0cwL5DcRd6p0HOoVKJR3xGg==
X-Received: by 2002:a2e:92d6:: with SMTP id k22mr2645127ljh.219.1609968731773;
        Wed, 06 Jan 2021 13:32:11 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id d21sm623436lfe.19.2021.01.06.13.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 13:32:11 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 net-next 1/3] dt-bindings: net: convert Broadcom Starfighter 2 binding to the json-schema
Date:   Wed,  6 Jan 2021 22:32:00 +0100
Message-Id: <20210106213202.17459-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This helps validating DTS files. Only the current (not deprecated one)
binding was converted.

Minor changes:
1. Dropped dsa/dsa.txt references
2. Updated node name to match dsa.yaml requirement
3. Fixed 2 typos in examples

The new binding was validated using the dt_binding_check.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: "compatible" based "clocks" and "clock-names" validation
    Include "clocks" and "clock-names" in the example

NOTE:
This patch purposefully doesn't add *global* "clocks" and "clock-names"
requirement. It's to prepare YAML for the next patch that follows (the
one adding "brcm,bcm4908-switch").
---
 .../bindings/net/brcm,bcm7445-switch-v4.0.txt | 101 +---------
 .../devicetree/bindings/net/dsa/brcm,sf2.yaml | 172 ++++++++++++++++++
 2 files changed, 175 insertions(+), 98 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt b/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt
index 97ca62b0e14d..d0935d2afef8 100644
--- a/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt
+++ b/Documentation/devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt
@@ -1,108 +1,13 @@
 * Broadcom Starfighter 2 integrated swich
 
-Required properties:
+See dsa/brcm,bcm7445-switch-v4.0.yaml for the documentation.
 
-- compatible: should be one of
-	"brcm,bcm7445-switch-v4.0"
-	"brcm,bcm7278-switch-v4.0"
-	"brcm,bcm7278-switch-v4.8"
-- reg: addresses and length of the register sets for the device, must be 6
-  pairs of register addresses and lengths
-- interrupts: interrupts for the devices, must be two interrupts
-- #address-cells: must be 1, see dsa/dsa.txt
-- #size-cells: must be 0, see dsa/dsa.txt
-
-Deprecated binding required properties:
+*Deprecated* binding required properties:
 
 - dsa,mii-bus: phandle to the MDIO bus controller, see dsa/dsa.txt
 - dsa,ethernet: phandle to the CPU network interface controller, see dsa/dsa.txt
 - #address-cells: must be 2, see dsa/dsa.txt
 
-Subnodes:
-
-The integrated switch subnode should be specified according to the binding
-described in dsa/dsa.txt.
-
-Optional properties:
-
-- reg-names: litteral names for the device base register addresses, when present
-  must be: "core", "reg", "intrl2_0", "intrl2_1", "fcb", "acb"
-
-- interrupt-names: litternal names for the device interrupt lines, when present
-  must be: "switch_0" and "switch_1"
-
-- brcm,num-gphy: specify the maximum number of integrated gigabit PHYs in the
-  switch
-
-- brcm,num-rgmii-ports: specify the maximum number of RGMII interfaces supported
-  by the switch
-
-- brcm,fcb-pause-override: boolean property, if present indicates that the switch
-  supports Failover Control Block pause override capability
-
-- brcm,acb-packets-inflight: boolean property, if present indicates that the switch
-  Admission Control Block supports reporting the number of packets in-flight in a
-  switch queue
-
-- resets: a single phandle and reset identifier pair. See
-  Documentation/devicetree/bindings/reset/reset.txt for details.
-
-- reset-names: If the "reset" property is specified, this property should have
-  the value "switch" to denote the switch reset line.
-
-- clocks: when provided, the first phandle is to the switch's main clock and
-  is valid for both BCM7445 and BCM7278. The second phandle is only applicable
-  to BCM7445 and is to support dividing the switch core clock.
-
-- clock-names: when provided, the first phandle must be "sw_switch", and the
-  second must be named "sw_switch_mdiv".
-
-Port subnodes:
-
-Optional properties:
-
-- brcm,use-bcm-hdr: boolean property, if present, indicates that the switch
-  port has Broadcom tags enabled (per-packet metadata)
-
-Example:
-
-switch_top@f0b00000 {
-	compatible = "simple-bus";
-	#size-cells = <1>;
-	#address-cells = <1>;
-	ranges = <0 0xf0b00000 0x40804>;
-
-	ethernet_switch@0 {
-		compatible = "brcm,bcm7445-switch-v4.0";
-		#size-cells = <0>;
-		#address-cells = <1>;
-		reg = <0x0 0x40000
-			0x40000 0x110
-			0x40340 0x30
-			0x40380 0x30
-			0x40400 0x34
-			0x40600 0x208>;
-		reg-names = "core", "reg", intrl2_0", "intrl2_1",
-			    "fcb, "acb";
-		interrupts = <0 0x18 0
-				0 0x19 0>;
-		brcm,num-gphy = <1>;
-		brcm,num-rgmii-ports = <2>;
-		brcm,fcb-pause-override;
-		brcm,acb-packets-inflight;
-
-		ports {
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			port@0 {
-				label = "gphy";
-				reg = <0>;
-			};
-		};
-	};
-};
-
 Example using the old DSA DeviceTree binding:
 
 switch_top@f0b00000 {
@@ -132,7 +37,7 @@ switch_top@f0b00000 {
 		switch@0 {
 			reg = <0 0>;
 			#size-cells = <0>;
-			#address-cells <1>;
+			#address-cells = <1>;
 
 			port@0 {
 				label = "gphy";
diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
new file mode 100644
index 000000000000..9de69243cf79
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
@@ -0,0 +1,172 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/brcm,sf2.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom Starfighter 2 integrated swich
+
+maintainers:
+  - Florian Fainelli <f.fainelli@gmail.com>
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - brcm,bcm7278-switch-v4.0
+          - brcm,bcm7278-switch-v4.8
+          - brcm,bcm7445-switch-v4.0
+
+  reg:
+    minItems: 6
+    maxItems: 6
+
+  reg-names:
+    items:
+      - const: core
+      - const: reg
+      - const: intrl2_0
+      - const: intrl2_1
+      - const: fcb
+      - const: acb
+
+  interrupts:
+    minItems: 2
+    maxItems: 2
+
+  interrupt-names:
+    items:
+      - const: switch_0
+      - const: switch_1
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    const: switch
+
+  clocks:
+    minItems: 1
+    maxItems: 2
+    items:
+      - description: switch's main clock
+      - description: dividing of the switch core clock
+
+  clock-names:
+    minItems: 1
+    maxItems: 2
+    items:
+      - const: sw_switch
+      - const: sw_switch_mdiv
+
+  brcm,num-gphy:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: maximum number of integrated gigabit PHYs in the switch
+
+  brcm,num-rgmii-ports:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: maximum number of RGMII interfaces supported by the switch
+
+  brcm,fcb-pause-override:
+    description: if present indicates that the switch supports Failover Control
+      Block pause override capability
+    type: boolean
+
+  brcm,acb-packets-inflight:
+    description: if present indicates that the switch Admission Control Block
+      supports reporting the number of packets in-flight in a switch queue
+    type: boolean
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+  ports:
+    type: object
+
+    properties:
+      brcm,use-bcm-hdr:
+        description: if present, indicates that the switch port has Broadcom
+          tags enabled (per-packet metadata)
+        type: boolean
+
+required:
+  - reg
+  - interrupts
+  - "#address-cells"
+  - "#size-cells"
+
+allOf:
+  - $ref: "dsa.yaml#"
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - brcm,bcm7278-switch-v4.0
+              - brcm,bcm7278-switch-v4.8
+    then:
+      properties:
+        clocks:
+          minItems: 1
+          maxItems: 1
+        clock-names:
+          minItems: 1
+          maxItems: 1
+      required:
+        - clocks
+        - clock-names
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: brcm,bcm7445-switch-v4.0
+    then:
+      properties:
+        clocks:
+          minItems: 2
+          maxItems: 2
+        clock-names:
+          minItems: 2
+          maxItems: 2
+      required:
+        - clocks
+        - clock-names
+
+additionalProperties: false
+
+examples:
+  - |
+    switch@f0b00000 {
+            compatible = "brcm,bcm7445-switch-v4.0";
+            #address-cells = <1>;
+            #size-cells = <0>;
+            reg = <0xf0b00000 0x40000>,
+                  <0xf0b40000 0x110>,
+                  <0xf0b40340 0x30>,
+                  <0xf0b40380 0x30>,
+                  <0xf0b40400 0x34>,
+                  <0xf0b40600 0x208>;
+            reg-names = "core", "reg", "intrl2_0", "intrl2_1",
+                        "fcb", "acb";
+            interrupts = <0 0x18 0>,
+                         <0 0x19 0>;
+            clocks = <&sw_switch>, <&sw_switch_mdiv>;
+            clock-names = "sw_switch", "sw_switch_mdiv";
+            brcm,num-gphy = <1>;
+            brcm,num-rgmii-ports = <2>;
+            brcm,fcb-pause-override;
+            brcm,acb-packets-inflight;
+
+            ports {
+                    #address-cells = <1>;
+                    #size-cells = <0>;
+
+                    port@0 {
+                            label = "gphy";
+                            reg = <0>;
+                    };
+            };
+    };
-- 
2.26.2

