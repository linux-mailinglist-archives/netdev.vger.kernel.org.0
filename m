Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FFC1D3603
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 18:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgENQIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 12:08:46 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59114 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgENQIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 12:08:46 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04EG8cRY051077;
        Thu, 14 May 2020 11:08:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589472518;
        bh=DWuRI69VJhwA75p0adY2f23XQmUB8NXX6FfYCzE7bCM=;
        h=From:To:CC:Subject:Date;
        b=Ztt20Lw38DPeUIV8HkE08ppOj7nK/PvvvemjraFSJR1DRyEA4NBnLbuXaaysF+sPv
         tTjle5SJUmFXBG8W4vA4aPqa/uyKqdN0Ckj6IHdZPU8r3O/tJXw07Alx+N3d8raQ2G
         dWxXB6lYPOcZpVB5/9buX/2DJuHENY+ydaimqdYo=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04EG8cNH088896
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 11:08:38 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 14
 May 2020 11:08:38 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 14 May 2020 11:08:38 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04EG8bJD003060;
        Thu, 14 May 2020 11:08:38 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next] dt-bindings: dp83867: Convert DP83867 to yaml
Date:   Thu, 14 May 2020 10:59:05 -0500
Message-ID: <20200514155905.26845-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the dp83867 binding to yaml.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 .../devicetree/bindings/net/ti,dp83867.txt    |  68 ----------
 .../devicetree/bindings/net/ti,dp83867.yaml   | 127 ++++++++++++++++++
 2 files changed, 127 insertions(+), 68 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/ti,dp83867.txt
 create mode 100644 Documentation/devicetree/bindings/net/ti,dp83867.yaml

diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.txt b/Documentation/devicetree/bindings/net/ti,dp83867.txt
deleted file mode 100644
index 44e2a4fab29e..000000000000
--- a/Documentation/devicetree/bindings/net/ti,dp83867.txt
+++ /dev/null
@@ -1,68 +0,0 @@
-* Texas Instruments - dp83867 Giga bit ethernet phy
-
-Required properties:
-	- reg - The ID number for the phy, usually a small integer
-	- ti,rx-internal-delay - RGMII Receive Clock Delay - see dt-bindings/net/ti-dp83867.h
-		for applicable values. Required only if interface type is
-		PHY_INTERFACE_MODE_RGMII_ID or PHY_INTERFACE_MODE_RGMII_RXID
-	- ti,tx-internal-delay - RGMII Transmit Clock Delay - see dt-bindings/net/ti-dp83867.h
-		for applicable values. Required only if interface type is
-		PHY_INTERFACE_MODE_RGMII_ID or PHY_INTERFACE_MODE_RGMII_TXID
-
-Note: If the interface type is PHY_INTERFACE_MODE_RGMII the TX/RX clock delays
-      will be left at their default values, as set by the PHY's pin strapping.
-      The default strapping will use a delay of 2.00 ns.  Thus
-      PHY_INTERFACE_MODE_RGMII, by default, does not behave as RGMII with no
-      internal delay, but as PHY_INTERFACE_MODE_RGMII_ID.  The device tree
-      should use "rgmii-id" if internal delays are desired as this may be
-      changed in future to cause "rgmii" mode to disable delays.
-
-Optional property:
-	- ti,min-output-impedance - MAC Interface Impedance control to set
-				    the programmable output impedance to
-				    minimum value (35 ohms).
-	- ti,max-output-impedance - MAC Interface Impedance control to set
-				    the programmable output impedance to
-				    maximum value (70 ohms).
-	- ti,dp83867-rxctrl-strap-quirk - This denotes the fact that the
-				    board has RX_DV/RX_CTRL pin strapped in
-				    mode 1 or 2. To ensure PHY operation,
-				    there are specific actions that
-				    software needs to take when this pin is
-				    strapped in these modes. See data manual
-				    for details.
-	- ti,clk-output-sel - Muxing option for CLK_OUT pin.  See dt-bindings/net/ti-dp83867.h
-			      for applicable values.  The CLK_OUT pin can also
-			      be disabled by this property.  When omitted, the
-			      PHY's default will be left as is.
-	- ti,sgmii-ref-clock-output-enable - This denotes which
-				    SGMII configuration is used (4 or 6-wire modes).
-				    Some MACs work with differential SGMII clock.
-				    See data manual for details.
-
-	- ti,fifo-depth - Transmitt FIFO depth- see dt-bindings/net/ti-dp83867.h
-		for applicable values (deprecated)
-
-	-tx-fifo-depth - As defined in the ethernet-controller.yaml.  Values for
-			 the depth can be found in dt-bindings/net/ti-dp83867.h
-	-rx-fifo-depth - As defined in the ethernet-controller.yaml.  Values for
-			 the depth can be found in dt-bindings/net/ti-dp83867.h
-
-Note: ti,min-output-impedance and ti,max-output-impedance are mutually
-      exclusive. When both properties are present ti,max-output-impedance
-      takes precedence.
-
-Default child nodes are standard Ethernet PHY device
-nodes as described in Documentation/devicetree/bindings/net/phy.txt
-
-Example:
-
-	ethernet-phy@0 {
-		reg = <0>;
-		ti,rx-internal-delay = <DP83867_RGMIIDCTL_2_25_NS>;
-		ti,tx-internal-delay = <DP83867_RGMIIDCTL_2_75_NS>;
-		tx-fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
-	};
-
-Datasheet can be found:
-http://www.ti.com/product/DP83867IR/datasheet
diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.yaml b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
new file mode 100644
index 000000000000..554dcd7a40a9
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ti,dp83867.yaml
@@ -0,0 +1,127 @@
+# SPDX-License-Identifier: (GPL-2.0+ OR BSD-2-Clause)
+# Copyright (C) 2019 Texas Instruments Incorporated
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/ti,dp83867.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: TI DP83867 ethernet PHY
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+
+maintainers:
+  - Dan Murphy <dmurphy@ti.com>
+
+description: |
+  The DP83867 device is a robust, low power, fully featured Physical Layer
+  transceiver with integrated PMD sublayers to support 10BASE-Te, 100BASE-TX
+  and 1000BASE-T Ethernet protocols.
+
+  The DP83867 is designed for easy implementation of 10/100/1000 Mbps Ethernet
+  LANs. It interfaces directly to twisted pair media via an external
+  transformer. This device interfaces directly to the MAC layer through the
+  IEEE 802.3 Standard Media Independent Interface (MII), the IEEE 802.3 Gigabit
+  Media Independent Interface (GMII) or Reduced GMII (RGMII).
+
+  Specifications about the charger can be found at:
+    https://www.ti.com/lit/gpn/dp83867ir
+
+properties:
+  reg:
+    maxItems: 1
+
+  ti,min-output-impedance:
+    type: boolean
+    description: |
+       MAC Interface Impedance control to set the programmable output impedance
+       to a minimum value (35 ohms).
+
+  ti,max-output-impedance:
+    type: boolean
+    description: |
+      MAC Interface Impedance control to set the programmable output impedance
+      to a maximum value (70 ohms).
+      Note: ti,min-output-impedance and ti,max-output-impedance are mutually
+        exclusive. When both properties are present ti,max-output-impedance
+        takes precedence.
+
+  tx-fifo-depth:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+       Transmitt FIFO depth see dt-bindings/net/ti-dp83867.h for values
+
+  rx-fifo-depth:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+       Receive FIFO depth see dt-bindings/net/ti-dp83867.h for values
+
+  ti,clk-output-sel:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+      Muxing option for CLK_OUT pin.  See dt-bindings/net/ti-dp83867.h
+      for applicable values. The CLK_OUT pin can also be disabled by this
+      property.  When omitted, the PHY's default will be left as is.
+
+  ti,rx-internal-delay:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+      RGMII Receive Clock Delay - see dt-bindings/net/ti-dp83867.h
+      for applicable values. Required only if interface type is
+      PHY_INTERFACE_MODE_RGMII_ID or PHY_INTERFACE_MODE_RGMII_RXID.
+
+  ti,tx-internal-delay:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+      RGMII Transmit Clock Delay - see dt-bindings/net/ti-dp83867.h
+      for applicable values. Required only if interface type is
+      PHY_INTERFACE_MODE_RGMII_ID or PHY_INTERFACE_MODE_RGMII_TXID.
+
+        Note: If the interface type is PHY_INTERFACE_MODE_RGMII the TX/RX clock
+          delays will be left at their default values, as set by the PHY's pin
+          strapping. The default strapping will use a delay of 2.00 ns.  Thus
+          PHY_INTERFACE_MODE_RGMII, by default, does not behave as RGMII with no
+          internal delay, but as PHY_INTERFACE_MODE_RGMII_ID.  The device tree
+          should use "rgmii-id" if internal delays are desired as this may be
+          changed in future to cause "rgmii" mode to disable delays.
+
+  ti,dp83867-rxctrl-strap-quirk:
+    type: boolean
+    description: |
+      This denotes the fact that the board has RX_DV/RX_CTRL pin strapped in
+      mode 1 or 2. To ensure PHY operation, there are specific actions that
+      software needs to take when this pin is strapped in these modes.
+      See data manual for details.
+
+  ti,sgmii-ref-clock-output-enable:
+    type: boolean
+    description: |
+      This denotes which SGMII configuration is used (4 or 6-wire modes).
+      Some MACs work with differential SGMII clock. See data manual for details.
+
+  ti,fifo-depth:
+    deprecated: true
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+      Transmitt FIFO depth- see dt-bindings/net/ti-dp83867.h for applicable
+      values.
+
+required:
+  - reg
+
+examples:
+  - |
+    #include <dt-bindings/net/ti-dp83867.h>
+    mdio0 {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      ethphy0: ethernet-phy@0 {
+        reg = <0>;
+        tx-fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
+        rx-fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
+        ti,max-output-impedance;
+        ti,clk-output-sel = <DP83867_CLK_O_SEL_CHN_A_RCLK>;
+        ti,rx-internal-delay = <DP83867_RGMIIDCTL_2_25_NS>;
+        ti,tx-internal-delay = <DP83867_RGMIIDCTL_2_75_NS>;
+      };
+    };
-- 
2.26.2

