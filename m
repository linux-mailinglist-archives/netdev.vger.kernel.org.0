Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9116446A3A7
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346858AbhLFSEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346247AbhLFSE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:04:27 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCDDC061D5F;
        Mon,  6 Dec 2021 10:00:58 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 71so11239866pgb.4;
        Mon, 06 Dec 2021 10:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Glli2G3nC8dxP+En8m4e+HBjuVPO66nGVLRacQBgUXs=;
        b=BvHBJZ6kAfK7nl47VDMesFxySbPQO6zQzYiE6UlcyBljaaWAtdrbJoknjCpXdMqq4p
         4jo3fbfkr9c8z0n4XTdWQ1PUg2v1iMWDIR9ScEF5kke67Is1Rw5JioKBhfT5P7OLTZyx
         ecNFb6fu78ttqbvaXL8HnA/t+akcanXKVKRQiAMKN+kvTYAn9SGRPsXglUJfa+PNutNK
         n7j8hDkxKFNWwHFvqhBw1+bOTsbJ0e/ARxWUtGIGY41xvSZZeHvvWSO1yahVsmUKbZ2t
         pewf6zl18kUb5rW6nAyYoSFS1htehKTyH+bxo5DxG715/LzAF78J7CCT56p2qnjh18M+
         Y8gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Glli2G3nC8dxP+En8m4e+HBjuVPO66nGVLRacQBgUXs=;
        b=XEZN6YzsExol7kyreMy59I5yfxRcjDQlInRzYdzqXJg8KJk+KWGozy5kglgLgSlUKm
         tR+tAZ4rG6xsDGKV6GiETtZBBmospW8LSllsyxEKiHZzqDtfVX8DwmnI6hk/T/FuaC+2
         ild4SbLauElFeilacS0YHMxDL9Lp2/sfkNVwCR8gK5qOe3Cn+DYsab+vFewHO7GgBWVn
         FLA5zAAUGBlj+ZWFgrYbzqo1e9j9ZlZUyZ7oFzFXJuZgpGwZcFXfQATg1r/tuBBW5t5F
         nKJ0yKntqePjF3EL6q98w0pPNydN/2wThP5B6d0BtkUr5glyDaq1vWh8xjQlE+EnDwDD
         m6hw==
X-Gm-Message-State: AOAM532l357JWdfmrIta4V9+IHgQ714+teq+bWOOYCFBLICRA8mTwJVV
        w7AMPOir1qLZVLuKI8hSz+a85A/t4b4=
X-Google-Smtp-Source: ABdhPJxmzy/roEL855bjlUiWdG3HdOmxKdCTk9ikMOP4Sk2AlYiLTxo3zC5DAgec9g5qS7igxtS3Ig==
X-Received: by 2002:a63:e801:: with SMTP id s1mr6483306pgh.543.1638813657742;
        Mon, 06 Dec 2021 10:00:57 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u11sm5444070pfg.120.2021.12.06.10.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:00:57 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     devicetree@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC GBIT
        ETHERNET DRIVER), Doug Berger <opendmb@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE),
        linux-phy@lists.infradead.org (open list:GENERIC PHY FRAMEWORK)
Subject: [PATCH v3 4/8] dt-bindings: net: Convert GENET binding to YAML
Date:   Mon,  6 Dec 2021 10:00:45 -0800
Message-Id: <20211206180049.2086907-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206180049.2086907-1-f.fainelli@gmail.com>
References: <20211206180049.2086907-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the GENET binding to YAML, leveraging brcm,unimac-mdio.yaml and
the standard ethernet-controller.yaml files.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../devicetree/bindings/net/brcm,bcmgenet.txt | 125 ---------------
 .../bindings/net/brcm,bcmgenet.yaml           | 145 ++++++++++++++++++
 MAINTAINERS                                   |   2 +-
 3 files changed, 146 insertions(+), 126 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,bcmgenet.txt b/Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
deleted file mode 100644
index 0b5994fba35f..000000000000
--- a/Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
+++ /dev/null
@@ -1,125 +0,0 @@
-* Broadcom BCM7xxx Ethernet Controller (GENET)
-
-Required properties:
-- compatible: should contain one of "brcm,genet-v1", "brcm,genet-v2",
-  "brcm,genet-v3", "brcm,genet-v4", "brcm,genet-v5", "brcm,bcm2711-genet-v5" or
-  "brcm,bcm7712-genet-v5".
-- reg: address and length of the register set for the device
-- interrupts and/or interrupts-extended: must be two cells, the first cell
-  is the general purpose interrupt line, while the second cell is the
-  interrupt for the ring RX and TX queues operating in ring mode.  An
-  optional third interrupt cell for Wake-on-LAN can be specified.
-  See Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
-  for information on the property specifics.
-- phy-mode: see ethernet.txt file in the same directory
-- #address-cells: should be 1
-- #size-cells: should be 1
-
-Optional properties:
-- clocks: When provided, must be two phandles to the functional clocks nodes
-  of the GENET block. The first phandle is the main GENET clock used during
-  normal operation, while the second phandle is the Wake-on-LAN clock.
-- clock-names: When provided, names of the functional clock phandles, first
-  name should be "enet" and second should be "enet-wol".
-
-- phy-handle: See ethernet.txt file in the same directory; used to describe
-  configurations where a PHY (internal or external) is used.
-
-- fixed-link: When the GENET interface is connected to a MoCA hardware block or
-  when operating in a RGMII to RGMII type of connection, or when the MDIO bus is
-  voluntarily disabled, this property should be used to describe the "fixed link".
-  See Documentation/devicetree/bindings/net/fixed-link.txt for information on
-  the property specifics
-
-Required child nodes:
-
-- mdio bus node: this node should always be present regardless of the PHY
-  configuration of the GENET instance
-
-MDIO bus node required properties:
-
-- compatible: should contain one of "brcm,genet-mdio-v1", "brcm,genet-mdio-v2"
-  "brcm,genet-mdio-v3", "brcm,genet-mdio-v4", "brcm,genet-mdio-v5", the version
-  has to match the parent node compatible property (e.g: brcm,genet-v4 pairs
-  with brcm,genet-mdio-v4)
-- reg: address and length relative to the parent node base register address
-- #address-cells: address cell for MDIO bus addressing, should be 1
-- #size-cells: size of the cells for MDIO bus addressing, should be 0
-
-Ethernet PHY node properties:
-
-See Documentation/devicetree/bindings/net/phy.txt for the list of required and
-optional properties.
-
-Internal Gigabit PHY example:
-
-ethernet@f0b60000 {
-	phy-mode = "internal";
-	phy-handle = <&phy1>;
-	mac-address = [ 00 10 18 36 23 1a ];
-	compatible = "brcm,genet-v4";
-	#address-cells = <0x1>;
-	#size-cells = <0x1>;
-	reg = <0xf0b60000 0xfc4c>;
-	interrupts = <0x0 0x14 0x0>, <0x0 0x15 0x0>;
-
-	mdio@e14 {
-		compatible = "brcm,genet-mdio-v4";
-		#address-cells = <0x1>;
-		#size-cells = <0x0>;
-		reg = <0xe14 0x8>;
-
-		phy1: ethernet-phy@1 {
-			max-speed = <1000>;
-			reg = <0x1>;
-			compatible = "ethernet-phy-ieee802.3-c22";
-		};
-	};
-};
-
-MoCA interface / MAC to MAC example:
-
-ethernet@f0b80000 {
-	phy-mode = "moca";
-	fixed-link = <1 0 1000 0 0>;
-	mac-address = [ 00 10 18 36 24 1a ];
-	compatible = "brcm,genet-v4";
-	#address-cells = <0x1>;
-	#size-cells = <0x1>;
-	reg = <0xf0b80000 0xfc4c>;
-	interrupts = <0x0 0x16 0x0>, <0x0 0x17 0x0>;
-
-	mdio@e14 {
-		compatible = "brcm,genet-mdio-v4";
-		#address-cells = <0x1>;
-		#size-cells = <0x0>;
-		reg = <0xe14 0x8>;
-	};
-};
-
-
-External MDIO-connected Gigabit PHY/switch:
-
-ethernet@f0ba0000 {
-	phy-mode = "rgmii";
-	phy-handle = <&phy0>;
-	mac-address = [ 00 10 18 36 26 1a ];
-	compatible = "brcm,genet-v4";
-	#address-cells = <0x1>;
-	#size-cells = <0x1>;
-	reg = <0xf0ba0000 0xfc4c>;
-	interrupts = <0x0 0x18 0x0>, <0x0 0x19 0x0>;
-
-	mdio@e14 {
-		compatible = "brcm,genet-mdio-v4";
-		#address-cells = <0x1>;
-		#size-cells = <0x0>;
-		reg = <0xe14 0x8>;
-
-		phy0: ethernet-phy@0 {
-			max-speed = <1000>;
-			reg = <0x0>;
-			compatible = "ethernet-phy-ieee802.3-c22";
-		};
-	};
-};
diff --git a/Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml b/Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml
new file mode 100644
index 000000000000..ba9a6d156815
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml
@@ -0,0 +1,145 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/brcm,bcmgenet.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom BCM7xxx Ethernet Controller (GENET) binding
+
+maintainers:
+  - Doug Berger <opendmb@gmail.com>
+  - Florian Fainelli <f.fainelli@gmail.com>
+
+properties:
+  compatible:
+    enum:
+      - brcm,genet-v1
+      - brcm,genet-v2
+      - brcm,genet-v3
+      - brcm,genet-v4
+      - brcm,genet-v5
+      - brcm,bcm2711-genet-v5
+      - brcm,bcm7712-genet-v5
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    minItems: 2
+    items:
+      - description: general purpose interrupt line
+      - description: RX and TX rings interrupt line
+      - description: Wake-on-LAN interrupt line
+
+
+  clocks:
+    minItems: 1
+    items:
+      - description: main clock
+      - description: EEE clock
+      - description: Wake-on-LAN clock
+
+  clock-names:
+    minItems: 1
+    items:
+      - const: enet
+      - const: enet-eee
+      - const: enet-wol
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 1
+
+patternProperties:
+  "^mdio@[0-9a-f]+$":
+    type: object
+    $ref: "brcm,unimac-mdio.yaml"
+
+    description:
+      GENET internal UniMAC MDIO bus
+
+required:
+  - reg
+  - interrupts
+  - phy-mode
+  - "#address-cells"
+  - "#size-cells"
+
+allOf:
+  - $ref: ethernet-controller.yaml
+
+additionalProperties: true
+
+examples:
+  #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+  - |
+    ethernet@f0b60000 {
+        phy-mode = "internal";
+        phy-handle = <&phy1>;
+        mac-address = [ 00 10 18 36 23 1a ];
+        compatible = "brcm,genet-v4";
+        reg = <0xf0b60000 0xfc4c>;
+        interrupts = <0x0 0x14 0x0>, <0x0 0x15 0x0>;
+        #address-cells = <1>;
+        #size-cells = <1>;
+
+        mdio0: mdio@e14 {
+           compatible = "brcm,genet-mdio-v4";
+           #address-cells = <1>;
+           #size-cells = <0>;
+           reg = <0xe14 0x8>;
+
+           phy1: ethernet-phy@1 {
+                max-speed = <1000>;
+                reg = <1>;
+                compatible = "ethernet-phy-ieee802.3-c22";
+           };
+        };
+    };
+
+  - |
+    ethernet@f0b80000 {
+        phy-mode = "moca";
+        fixed-link = <1 0 1000 0 0>;
+        mac-address = [ 00 10 18 36 24 1a ];
+        compatible = "brcm,genet-v4";
+        #address-cells = <1>;
+        #size-cells = <1>;
+        reg = <0xf0b80000 0xfc4c>;
+        interrupts = <0x0 0x16 0x0>, <0x0 0x17 0x0>;
+
+        mdio1: mdio@e14 {
+           compatible = "brcm,genet-mdio-v4";
+           #address-cells = <1>;
+           #size-cells = <0>;
+           reg = <0xe14 0x8>;
+        };
+    };
+
+  - |
+    ethernet@f0ba0000 {
+        phy-mode = "rgmii";
+        phy-handle = <&phy0>;
+        mac-address = [ 00 10 18 36 26 1a ];
+        compatible = "brcm,genet-v4";
+        #address-cells = <1>;
+        #size-cells = <1>;
+        reg = <0xf0ba0000 0xfc4c>;
+        interrupts = <0x0 0x18 0x0>, <0x0 0x19 0x0>;
+
+        mdio2: mdio@e14 {
+           compatible = "brcm,genet-mdio-v4";
+           #address-cells = <1>;
+           #size-cells = <0>;
+           reg = <0xe14 0x8>;
+
+           phy0: ethernet-phy@0 {
+                max-speed = <1000>;
+                reg = <0>;
+                compatible = "ethernet-phy-ieee802.3-c22";
+           };
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 7a2345ce8521..5e1064c23f41 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3819,7 +3819,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 L:	bcm-kernel-feedback-list@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
-F:	Documentation/devicetree/bindings/net/brcm,bcmgenet.txt
+F:	Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml
 F:	Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
 F:	drivers/net/ethernet/broadcom/genet/
 F:	drivers/net/ethernet/broadcom/unimac.h
-- 
2.25.1

