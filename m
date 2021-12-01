Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B044645BA
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 05:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346593AbhLAEQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 23:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346552AbhLAEQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 23:16:02 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4BBC061757;
        Tue, 30 Nov 2021 20:12:40 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 71so22186374pgb.4;
        Tue, 30 Nov 2021 20:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S6MkhaIHME8udF9GGOHXv3Gk6l/Mg/lYh8+TNbZFaI0=;
        b=Gwoa4drV5DpGfWUKssMGYOHR//e5TJYyP1J9r7wwqpCIIGwPWujeg4lQuxSTXSy1s+
         aMCIdh4YiPfeNSepLNCJnO/jvY8pssca7FL33146Gc7aP49bJR9M62zGw0GA/AlAyi1E
         Bdtkek9AGLnnkeEayp9s4X7uOXc+YAh6gBWJjo8U+9ScpL2WMBo6+B/WV5tgu+bdPHca
         Q8kTaFuKgrDWVwC0hdiFn5ep0umYUr3wMcTN8vzlN+g+gJUJEWd/GILUrELml6VLFpLm
         3KcMIp+2bykc7fBJdaVxnE3zn1uoeFh61FyFMTl54HHQzN6SxXQSswPYwyHZk5Z0Zro5
         ozng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S6MkhaIHME8udF9GGOHXv3Gk6l/Mg/lYh8+TNbZFaI0=;
        b=R5uQCi07GOLnyS4bzz5Aq8vY1Z1RkxIKLUK/NlAEnc1LDlNqFNzpjwQ0+Q8WlPG8jr
         jlONI5KA4g/9CQzMj/HcghfqzZnU9ie61EPmOkcx3pdiFi2KFjmLSkdaYxIHcg7xIUY7
         7AWsBorsoAUuZ7pugn27M8KJRCJtGxYY4cvBrPVTlUUa91kSqdF25B9h7Id5NhfEn++u
         7AVZipNQfrzC/xrmQieEVXwAmwoUjAiia+4v1zrE/kjCgn7SXQGShkIvW8uEs8ITzg4W
         Uzcc/oM899elmYxxPtLRJdBn8vOLm0kPvBrXIImAbSyGuZ3vqzq+3sK55f3dDStEQdWn
         SfoQ==
X-Gm-Message-State: AOAM530uEqnYBqlCuk8mW7y8RiDemeXVbqRHpJpBvnbMx3wnsm5g2D6X
        eKPW/zziRpz1F9ZfLKp00/+J9VKtN2o=
X-Google-Smtp-Source: ABdhPJxRf1uxWNKwa+wdIf+UoSvUN1Rl464eu8ICPeCv1mBsXX4jMtDHbFTHYu3HWUT4a/gdYlm6Nw==
X-Received: by 2002:a63:293:: with SMTP id 141mr2819081pgc.25.1638331959583;
        Tue, 30 Nov 2021 20:12:39 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id s8sm4296451pfe.196.2021.11.30.20.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:12:39 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC GBIT
        ETHERNET DRIVER), Doug Berger <opendmb@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE)
Subject: [PATCH net-next 4/7] dt-bindings: net: Convert GENET binding to YAML
Date:   Tue, 30 Nov 2021 20:12:25 -0800
Message-Id: <20211201041228.32444-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201041228.32444-1-f.fainelli@gmail.com>
References: <20211201041228.32444-1-f.fainelli@gmail.com>
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
 .../bindings/net/brcm,bcmgenet.yaml           | 146 ++++++++++++++++++
 MAINTAINERS                                   |   2 +-
 3 files changed, 147 insertions(+), 126 deletions(-)
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
index 000000000000..a500ccf1ed3e
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,bcmgenet.yaml
@@ -0,0 +1,146 @@
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
+    maxItems: 3
+    items:
+      - description: general purpose interrupt line
+      - description: RX and TX rings interrupt line
+      - description: Wake-on-LAN interrupt line
+
+
+  clocks:
+    minItems: 1
+    maxItems: 3
+    items:
+      - description: main clock
+      - description: EEE clock
+      - description: Wake-on-LAN clock
+
+  clock-names:
+    minItems: 1
+    maxItems: 3
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
index da2fb287c4b3..eb0f6caf0062 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3830,7 +3830,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
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

