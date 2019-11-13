Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC98FB572
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 17:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbfKMQnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 11:43:40 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:40230 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbfKMQnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 11:43:39 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xADGhXJ5086483;
        Wed, 13 Nov 2019 10:43:33 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1573663413;
        bh=vnh+SkUmaagamUe7oJMNSXcvT3/zcQua5Zrl595B/7A=;
        h=From:To:CC:Subject:Date;
        b=VsGiYHOnORhnpzFd9coaTYQRcxnNh52JeaAEQKiG6AAmFe+mJEq44bP7Rs/wv0Y2d
         Ne9/u+EByZy/BESQXf+hVzwSiRymRdWN8AWRF3BecaEjd5wmuLyz1kjjHTCGwZmHYv
         1fk4TXnDprPC4+q/kT531ozvEACCfkAJpr/PdRCs=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xADGhXhO042259
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 Nov 2019 10:43:33 -0600
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 13
 Nov 2019 10:43:15 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 13 Nov 2019 10:43:15 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xADGhWQc066997;
        Wed, 13 Nov 2019 10:43:32 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>, Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v3 1/2] dt-bindings: net: dp83869: Add TI dp83869 phy
Date:   Wed, 13 Nov 2019 10:42:25 -0600
Message-ID: <20191113164226.3281-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.22.0.214.g8dca754b1e
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dt bindings for the TI dp83869 Gigabit ethernet phy
device.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
CC: Rob Herring <robh+dt@kernel.org>
---

v3 - Moved dt-bindings header file from patch 2/2 to here

 .../devicetree/bindings/net/ti,dp83869.yaml   | 84 +++++++++++++++++++
 include/dt-bindings/net/ti-dp83869.h          | 43 ++++++++++
 2 files changed, 127 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ti,dp83869.yaml
 create mode 100644 include/dt-bindings/net/ti-dp83869.h

diff --git a/Documentation/devicetree/bindings/net/ti,dp83869.yaml b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
new file mode 100644
index 000000000000..6fe3e451da8a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
@@ -0,0 +1,84 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 Texas Instruments Incorporated
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/ti,dp83869.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: TI DP83869 ethernet PHY
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+
+maintainers:
+  - Dan Murphy <dmurphy@ti.com>
+
+description: |
+  The DP83869HM device is a robust, fully-featured Gigabit (PHY) transceiver
+  with integrated PMD sublayers that supports 10BASE-Te, 100BASE-TX and
+  1000BASE-T Ethernet protocols. The DP83869 also supports 1000BASE-X and
+  100BASE-FX Fiber protocols.
+  This device interfaces to the MAC layer through Reduced GMII (RGMII) and
+  SGMII The DP83869HM supports Media Conversion in Managed mode. In this mode,
+  the DP83869HM can run 1000BASE-X-to-1000BASE-T and 100BASE-FX-to-100BASE-TX
+  conversions.  The DP83869HM can also support Bridge Conversion from RGMII to
+  SGMII and SGMII to RGMII.
+
+  Specifications about the charger can be found at:
+    http://www.ti.com/lit/ds/symlink/dp83869hm.pdf
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
+       MAC Interface Impedance control to set the programmable output impedance
+       to a maximum value (70 ohms).
+
+  tx-fifo-depth:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+       Transmitt FIFO depth see dt-bindings/net/ti-dp83869.h for values
+
+  rx-fifo-depth:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+       Receive FIFO depth see dt-bindings/net/ti-dp83869.h for values
+
+  ti,clk-output-sel:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+       Muxing option for CLK_OUT pin see dt-bindings/net/ti-dp83869.h for values.
+
+  ti,op-mode:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+       Operational mode for the PHY.  If this is not set then the operational
+       mode is set by the straps. see dt-bindings/net/ti-dp83869.h for values
+
+required:
+  - reg
+
+examples:
+  - |
+    #include <dt-bindings/net/ti-dp83869.h>
+    mdio0 {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      ethphy0: ethernet-phy@0 {
+        reg = <0>;
+        tx-fifo-depth = <DP83869_PHYCR_FIFO_DEPTH_4_B_NIB>;
+        rx-fifo-depth = <DP83869_PHYCR_FIFO_DEPTH_4_B_NIB>;
+        ti,op-mode = <DP83869_RGMII_COPPER_ETHERNET>;
+        ti,max-output-impedance = "true";
+        ti,clk-output-sel = <DP83869_CLK_O_SEL_CHN_A_RCLK>;
+      };
+    };
diff --git a/include/dt-bindings/net/ti-dp83869.h b/include/dt-bindings/net/ti-dp83869.h
new file mode 100644
index 000000000000..863074be52c7
--- /dev/null
+++ b/include/dt-bindings/net/ti-dp83869.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Device Tree constants for the Texas Instruments DP83869 PHY
+ *
+ * Author: Dan Murphy <dmurphy@ti.com>
+ *
+ * Copyright:   (C) 2019 Texas Instruments, Inc.
+ */
+
+#ifndef _DT_BINDINGS_TI_DP83869_H
+#define _DT_BINDINGS_TI_DP83869_H
+
+/* PHY CTRL bits */
+#define DP83869_PHYCR_FIFO_DEPTH_3_B_NIB	0x00
+#define DP83869_PHYCR_FIFO_DEPTH_4_B_NIB	0x01
+#define DP83869_PHYCR_FIFO_DEPTH_6_B_NIB	0x02
+#define DP83869_PHYCR_FIFO_DEPTH_8_B_NIB	0x03
+
+/* IO_MUX_CFG - Clock output selection */
+#define DP83869_CLK_O_SEL_CHN_A_RCLK		0x0
+#define DP83869_CLK_O_SEL_CHN_B_RCLK		0x1
+#define DP83869_CLK_O_SEL_CHN_C_RCLK		0x2
+#define DP83869_CLK_O_SEL_CHN_D_RCLK		0x3
+#define DP83869_CLK_O_SEL_CHN_A_RCLK_DIV5	0x4
+#define DP83869_CLK_O_SEL_CHN_B_RCLK_DIV5	0x5
+#define DP83869_CLK_O_SEL_CHN_C_RCLK_DIV5	0x6
+#define DP83869_CLK_O_SEL_CHN_D_RCLK_DIV5	0x7
+#define DP83869_CLK_O_SEL_CHN_A_TCLK		0x8
+#define DP83869_CLK_O_SEL_CHN_B_TCLK		0x9
+#define DP83869_CLK_O_SEL_CHN_C_TCLK		0xa
+#define DP83869_CLK_O_SEL_CHN_D_TCLK		0xb
+#define DP83869_CLK_O_SEL_REF_CLK		0xc
+
+#define DP83869_RGMII_COPPER_ETHERNET		0x00
+#define DP83869_RGMII_1000_BASE			0x01
+#define DP83869_RGMII_100_BASE			0x02
+#define DP83869_RGMII_SGMII_BRIDGE		0x03
+#define DP83869_1000M_MEDIA_CONVERT		0x04
+#define DP83869_100M_MEDIA_CONVERT		0x05
+#define DP83869_SGMII_COPPER_ETHERNET		0x06
+
+#endif
+
-- 
2.22.0.214.g8dca754b1e

