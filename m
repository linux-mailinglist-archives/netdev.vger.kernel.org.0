Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306712EBD76
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 13:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbhAFMIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 07:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbhAFMIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 07:08:06 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAA7C06134C;
        Wed,  6 Jan 2021 04:07:25 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id o19so6072166lfo.1;
        Wed, 06 Jan 2021 04:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/5A7Up4cnnkmj6K5HCxgyoOk/Z092Op/G4d4uppmdSk=;
        b=jWbByTYYErSZPRWkhUdXSfHj2C+dYga3nEVVRJVbyE3+r+joN3cn9cuM1+zukPFQao
         Fx0fC8xLC4gchIxkPBrCQuvQKYjLs5SQlPmu5kMdISKxNaoPFO3EKAdSZNm7VjPn9K96
         iZfVZr0OHDRp90pkl1t1PpKotmG3xcgydGnsyhStFNpe2Yw8zTCu+ZajudF+9nHvLmqo
         i5L8QbZ8S2mw7R5xOJ5XYUTi6/w3i+7xYTrrN91QBlfyDooWA+U9Bo5iD9fhHgMbpab7
         ZXqOfZL03P5qX1wLWsQr5dB4qaPlTjsI8Pt9FSmofJLc34OHLX8gKdgc6uT2WlfMzROh
         bSqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/5A7Up4cnnkmj6K5HCxgyoOk/Z092Op/G4d4uppmdSk=;
        b=SuYWmAQHUC7rVVz54fdxdCkgleC5XNHq6WIvs2bPYVKUVvytzAbLGuXAJdTnfZ/CLT
         UNMGwi9QARFzecjcoC7/OrfMadFavMcLJ7jRGOSEBmCxc5kvlyrMYeWL6fNkWjEYP5QE
         4ZuTUmSPWzNmIgO7KPgGKTahRbcPBY09waYilRIy8i1xB/378wkRuRiTIllInlOfq9gM
         nFNf5G54N/1Ow9v/hZa8nsWKR5k47P173LiiTgfpaWCw5TZZbUnAMOmZWlEqwba7GSyj
         6G5u5q3T3YNd36M02epMcCtaxC+pMXgtcbyTnOYd7iINgLRuhjNtlfuoD7iAZSH9SNe7
         KSDQ==
X-Gm-Message-State: AOAM530JuffLKgtuB4+HK/tQuSxyiijDqkpcSnbG3X/soZhRLYE1LCsQ
        NYqMSLw52Ns/WOaPtO+fbEw=
X-Google-Smtp-Source: ABdhPJzaDGohnIcDq+T2a6tpYaexlX60h0UtH/exoWrD0ZqyRpCH148CEEVuGE2dwohXwNpxwLeCMA==
X-Received: by 2002:a19:6b19:: with SMTP id d25mr1749292lfa.282.1609934842547;
        Wed, 06 Jan 2021 04:07:22 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id v5sm316096lfd.103.2021.01.06.04.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 04:07:21 -0800 (PST)
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
Subject: [PATCH net-next 1/3] dt-bindings: net: convert Broadcom Starfighter 2 binding to the json-schema
Date:   Wed,  6 Jan 2021 13:07:09 +0100
Message-Id: <20210106120711.630-1-zajec5@gmail.com>
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
 .../bindings/net/brcm,bcm7445-switch-v4.0.txt | 101 +-------------
 .../devicetree/bindings/net/dsa/brcm,sf2.yaml | 132 ++++++++++++++++++
 2 files changed, 135 insertions(+), 98 deletions(-)
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
index 000000000000..a7dba2e0fc9c
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
@@ -0,0 +1,132 @@
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
+allOf:
+  - $ref: "dsa.yaml#"
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - brcm,bcm7445-switch-v4.0
+          - brcm,bcm7278-switch-v4.0
+          - brcm,bcm7278-switch-v4.8
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
+    items:
+      - description: switch's main clock (valid for both BCM7445 and BCM7278)
+      - description: only applicable to BCM7445 and is to support dividing the switch core clock.
+
+  clock-names:
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

