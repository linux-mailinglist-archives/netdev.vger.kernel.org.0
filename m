Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C8D35A573
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbhDISOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:14:25 -0400
Received: from mail-mw2nam10on2065.outbound.protection.outlook.com ([40.107.94.65]:45408
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234629AbhDISOP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 14:14:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kmCPz6KfgDMYqMnIqYmzba7n2tcm/+L9myvKY/EZqqKoiFpKmReVaIt+pSgNzVr/scQbbF95CzxEAcDInkvuRCdquoiGqeKno8wRfSnl6cBj2Gi9Xg53iEl8Z+ob6avMFxgHP2usXa9QZ/jcqk6aSMCXpVmxC8O/42OKMQWt4FsiB3x+6fVcGDAiUFCQZaVVjTvGjm8YvdVnhlO7RldEv3k7/jV2e1KUQQ4+B2ARLivCbf9Vyi6zt6fmpAE19ELZ3AFsk3xq0vq8ClACHUbXwTn4WmRY+54F3ajXaF8KcieRUsGLLKoV5uiei/Hh2bQVvzbt9+i/1/Z9Y+giA0EscQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2L8AhPELLygZ2ju6V0gFfQ+8vfi/mukY1MTzcb1+1E=;
 b=XnTkJyopMn8qVLebvFszFmqVgaIYSzHH5v7BHlh9gPsdnU0cVS+Q044FYupaqW+DE5rKMQPdBAridZ9oLts90cYF4DZZwzx8xZre/McEh20521t/t3Tn91U5qxDOdGGUoQwN73eTORbrm6nMURqpMj0igObISQVk3Dya7QBmUlEkGgmy2lisnSPwsy4ZW9UYUgV9uUZUaDtE06yuMt2zEQa7q4TeFMfBeb/TCpfWAJMFatocenkPuUXFDpcoJFBxht8cihBMtPrR0RIH+WRlCFSm8okQf2aRP+oDaW1XFlDlkGH4hUynPcqF7TJKRhmuJJehXr7v52y+Rgsg0pTTog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2L8AhPELLygZ2ju6V0gFfQ+8vfi/mukY1MTzcb1+1E=;
 b=cW8eBOr6mjTPPEXj/uVdnG7UzCcBOrEpwdKAU7P7yyNkqX2ttVX1mQoC4qngcNVMQRmcr9XQkPtPDHFREV4FeOrvF46NluKhRGXBTfT10kLU0SvXq809z4zoY/ZsJ3Z6cYfbmJg7QFvqWKCXBCpalx2CkMR8b36Cwqg55+nARUM=
Received: from BL1PR13CA0382.namprd13.prod.outlook.com (2603:10b6:208:2c0::27)
 by BYAPR02MB5816.namprd02.prod.outlook.com (2603:10b6:a03:126::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 9 Apr
 2021 18:14:00 +0000
Received: from BL2NAM02FT019.eop-nam02.prod.protection.outlook.com
 (2603:10b6:208:2c0:cafe::82) by BL1PR13CA0382.outlook.office365.com
 (2603:10b6:208:2c0::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.8 via Frontend
 Transport; Fri, 9 Apr 2021 18:14:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BL2NAM02FT019.mail.protection.outlook.com (10.152.77.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 18:13:59 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 9 Apr 2021 11:13:57 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2106.2 via Frontend Transport; Fri, 9 Apr 2021 11:13:57 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 robh+dt@kernel.org,
 vkoul@kernel.org,
 linux-arm-kernel@lists.infradead.org,
 devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.106] (port=33565 helo=xhdvnc125.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1lUvdk-0004ml-Ab; Fri, 09 Apr 2021 11:13:56 -0700
Received: by xhdvnc125.xilinx.com (Postfix, from userid 13245)
        id 25C3212164D; Fri,  9 Apr 2021 23:43:29 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <michal.simek@xilinx.com>, <vkoul@kernel.org>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [RFC PATCH 1/3] dt-bindings: net: xilinx_axienet: convert bindings document to yaml
Date:   Fri, 9 Apr 2021 23:43:20 +0530
Message-ID: <1617992002-38028-2-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1617992002-38028-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1617992002-38028-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6778c757-c9d6-4e13-3c0f-08d8fb833fb4
X-MS-TrafficTypeDiagnostic: BYAPR02MB5816:
X-Microsoft-Antispam-PRVS: <BYAPR02MB58167F7348ADD5DF71D78A2AC7739@BYAPR02MB5816.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kpNgrtvn2Y+o2YQRzu4NwpnQf2HXTdmuGY9A+KXPRVRV/bVaMpi/6Vbz0yH66eM9G71W0qHjMhLXSXwT3C66axmV/ZFEr+uLquqcyqBg0YqzTRXmMYj8DfCBVdkryrb4Q1wurz9Z2i3k9H6FELkici0GjkuoFGWNnIPqFSV/YMAcugsiRQTlmjGHC4ARgov1fuIZJgWHt2qZJv13kIVtaDUZy2tK3xNZa7MItKir2U/h/701/vNdguZheg6pRFM1J+nMs51S7pcnmnqFHhhMGmXDvHeLjpTyObHGXppGswUkROS8jpTLtFCZJouzf/L9He2RURS0CGiEfO6ve28sVl/zTz9lI+ySVE3abEFUK0vnW9cP6xr/M9X5tH6om+zsJYMQ1bXSPKQbVjXjUCVqp+N9ljZdixem2u6/NxUGeqmHucy7545MNpP8jR+zrfLP2XMp2lgKrysgLRbm3Icp6/ipyBWuUTwNrbLxLjBJB2P1j+ecNG81vJdDcCKUtesPIj1DaCmd18pylvi8yYpBYuLDEqTYjIItm18q47pfJ0Nj63Yb8ZCToYduIlCccNlC9IWTlWPErCI9CDfk/sFexHzJNOkRq7Xbu956w6+32+78Z8anM9v7M+QIcb2rxm85OoKEyjoKoYHduXn6ns0VSU3vigpz6dLMOeLL/KFMtFw3tlbllkTWdVzGv1D2ZGQfTA81/FwWW5abf7K28nfmLQTM3+VqdJ4TikkSe6VD7eWlYyjzvWIe1aYPOq6LCB2f
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(36840700001)(46966006)(107886003)(316002)(26005)(356005)(6666004)(2616005)(2906002)(5660300002)(426003)(54906003)(8676002)(4326008)(36906005)(8936002)(42186006)(110136005)(186003)(336012)(83380400001)(7636003)(6266002)(47076005)(36860700001)(70586007)(70206006)(82740400003)(478600001)(36756003)(82310400003)(966005)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 18:13:59.9581
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6778c757-c9d6-4e13-3c0f-08d8fb833fb4
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BL2NAM02FT019.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the bindings document for Xilinx AXI Ethernet Subsystem
from txt to yaml. No changes to existing binding description.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
Pending: Fix below remaining dt_binding_check warning:

ethernet@40c00000: 'device_type' does not match any of
the regexes: 'pinctrl-[0-9]+
---
 .../devicetree/bindings/net/xilinx_axienet.txt     |  80 -----------
 .../devicetree/bindings/net/xilinx_axienet.yaml    | 147 +++++++++++++++++++++
 MAINTAINERS                                        |   1 +
 3 files changed, 148 insertions(+), 80 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/xilinx_axienet.txt
 create mode 100644 Documentation/devicetree/bindings/net/xilinx_axienet.yaml

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
deleted file mode 100644
index 2cd452419ed0..000000000000
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ /dev/null
@@ -1,80 +0,0 @@
-XILINX AXI ETHERNET Device Tree Bindings
---------------------------------------------------------
-
-Also called  AXI 1G/2.5G Ethernet Subsystem, the xilinx axi ethernet IP core
-provides connectivity to an external ethernet PHY supporting different
-interfaces: MII, GMII, RGMII, SGMII, 1000BaseX. It also includes two
-segments of memory for buffering TX and RX, as well as the capability of
-offloading TX/RX checksum calculation off the processor.
-
-Management configuration is done through the AXI interface, while payload is
-sent and received through means of an AXI DMA controller. This driver
-includes the DMA driver code, so this driver is incompatible with AXI DMA
-driver.
-
-For more details about mdio please refer phy.txt file in the same directory.
-
-Required properties:
-- compatible	: Must be one of "xlnx,axi-ethernet-1.00.a",
-		  "xlnx,axi-ethernet-1.01.a", "xlnx,axi-ethernet-2.01.a"
-- reg		: Address and length of the IO space, as well as the address
-                  and length of the AXI DMA controller IO space, unless
-                  axistream-connected is specified, in which case the reg
-                  attribute of the node referenced by it is used.
-- interrupts	: Should be a list of 2 or 3 interrupts: TX DMA, RX DMA,
-		  and optionally Ethernet core. If axistream-connected is
-		  specified, the TX/RX DMA interrupts should be on that node
-		  instead, and only the Ethernet core interrupt is optionally
-		  specified here.
-- phy-handle	: Should point to the external phy device.
-		  See ethernet.txt file in the same directory.
-- xlnx,rxmem	: Set to allocated memory buffer for Rx/Tx in the hardware
-
-Optional properties:
-- phy-mode	: See ethernet.txt
-- xlnx,phy-type	: Deprecated, do not use, but still accepted in preference
-		  to phy-mode.
-- xlnx,txcsum	: 0 or empty for disabling TX checksum offload,
-		  1 to enable partial TX checksum offload,
-		  2 to enable full TX checksum offload
-- xlnx,rxcsum	: Same values as xlnx,txcsum but for RX checksum offload
-- xlnx,switch-x-sgmii : Boolean to indicate the Ethernet core is configured to
-		  support both 1000BaseX and SGMII modes. If set, the phy-mode
-		  should be set to match the mode selected on core reset (i.e.
-		  by the basex_or_sgmii core input line).
-- clocks	: AXI bus clock for the device. Refer to common clock bindings.
-		  Used to calculate MDIO clock divisor. If not specified, it is
-		  auto-detected from the CPU clock (but only on platforms where
-		  this is possible). New device trees should specify this - the
-		  auto detection is only for backward compatibility.
-- axistream-connected: Reference to another node which contains the resources
-		       for the AXI DMA controller used by this device.
-		       If this is specified, the DMA-related resources from that
-		       device (DMA registers and DMA TX/RX interrupts) rather
-		       than this one will be used.
- - mdio		: Child node for MDIO bus. Must be defined if PHY access is
-		  required through the core's MDIO interface (i.e. always,
-		  unless the PHY is accessed through a different bus).
-
-Example:
-	axi_ethernet_eth: ethernet@40c00000 {
-		compatible = "xlnx,axi-ethernet-1.00.a";
-		device_type = "network";
-		interrupt-parent = <&microblaze_0_axi_intc>;
-		interrupts = <2 0 1>;
-		clocks = <&axi_clk>;
-		phy-mode = "mii";
-		reg = <0x40c00000 0x40000 0x50c00000 0x40000>;
-		xlnx,rxcsum = <0x2>;
-		xlnx,rxmem = <0x800>;
-		xlnx,txcsum = <0x2>;
-		phy-handle = <&phy0>;
-		axi_ethernetlite_0_mdio: mdio {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			phy0: phy@0 {
-				device_type = "ethernet-phy";
-				reg = <1>;
-			};
-		};
-	};
diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.yaml b/Documentation/devicetree/bindings/net/xilinx_axienet.yaml
new file mode 100644
index 000000000000..6a00e03e8804
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/xilinx_axienet.yaml
@@ -0,0 +1,147 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/xilinx_axienet.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: AXI 1G/2.5G Ethernet Subsystem
+
+description: |
+  Also called  AXI 1G/2.5G Ethernet Subsystem, the xilinx axi ethernet IP core
+  provides connectivity to an external ethernet PHY supporting different
+  interfaces: MII, GMII, RGMII, SGMII, 1000BaseX. It also includes two
+  segments of memory for buffering TX and RX, as well as the capability of
+  offloading TX/RX checksum calculation off the processor.
+
+  Management configuration is done through the AXI interface, while payload is
+  sent and received through means of an AXI DMA controller. This driver
+  includes the DMA driver code, so this driver is incompatible with AXI DMA
+  driver.
+
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+
+maintainers:
+  - Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - enum:
+              - xlnx,axi-ethernet-1.00.a
+              - xlnx,axi-ethernet-1.01.a
+              - xlnx,axi-ethernet-2.01.a
+
+  reg:
+    description:
+      Address and length of the IO space, as well as the address
+      and length of the AXI DMA controller IO space, unless
+      axistream-connected is specified, in which case the reg
+      attribute of the node referenced by it is used.
+    maxItems: 2
+
+  interrupts:
+    description:
+      Can point to at most 3 interrupts. TX DMA, RX DMA, and optionally Ethernet
+      core. If axistream-connected is specified, the TX/RX DMA interrupts should
+      be on that node instead, and only the Ethernet core interrupt is optionally
+      specified here.
+    maxItems: 3
+
+  phy-handle: true
+
+  xlnx,rxmem:
+    description:
+      Set to allocated memory buffer for Rx/Tx in the hardware.
+    $ref: /schemas/types.yaml#/definitions/uint32
+
+  phy-mode: true
+
+  xlnx,phy-type:
+    description:
+      Do not use, but still accepted in preference to phy-mode.
+    deprecated: true
+    $ref: /schemas/types.yaml#/definitions/uint32
+
+  xlnx,txcsum:
+    description:
+      TX checksum offload. 0 or empty for disabling TX checksum offload,
+      1 to enable partial TX checksum offload and 2 to enable full TX
+      checksum offload.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [0, 1, 2]
+
+  xlnx,rxcsum:
+    description:
+      RX checksum offload. 0 or empty for disabling RX checksum offload,
+      1 to enable partial RX checksum offload and 2 to enable full RX
+      checksum offload.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [0, 1, 2]
+
+  xlnx,switch-x-sgmii:
+    description:
+      Indicate the Ethernet core is configured to support both 1000BaseX and
+      SGMII modes. If set, the phy-mode should be set to match the mode
+      selected on core reset (i.e. by the basex_or_sgmii core input line).
+    type: boolean
+
+  clocks:
+    items:
+      - description: Clock for AXI register slave interface.
+      - description: AXI4-Stream clock for TXD RXD TXC and RXS interfaces.
+      - description: Ethernet reference clock, used by signal delay primitives
+                     and transceivers.
+      - description: MGT reference clock (used by optional internal PCS/PMA PHY)
+
+  clock-names:
+    items:
+      - const: s_axi_lite_clk
+      - const: axis_clk
+      - const: ref_clk
+      - const: mgt_clk
+
+  axistream-connected:
+    type: object
+    description: Reference to another node which contains the resources
+      for the AXI DMA controller used by this device. If this is specified,
+      the DMA-related resources from that device (DMA registers and DMA
+      TX/RX interrupts) rather than this one will be used.
+
+  mdio: true
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - xlnx,rxmem
+  - phy-handle
+
+additionalProperties: false
+
+examples:
+  - |
+    axi_ethernet_eth: ethernet@40c00000 {
+      compatible = "xlnx,axi-ethernet-1.00.a";
+      device_type = "network";
+      interrupt-parent = <&microblaze_0_axi_intc>;
+      interrupts = <2>, <0>, <1>;
+      clock-names = "s_axi_lite_clk", "axis_clk", "ref_clk", "mgt_clk";
+      clocks = <&axi_clk>, <&axi_clk>, <&pl_enet_ref_clk>, <&mgt_clk>;
+      phy-mode = "mii";
+      reg = <0x40c00000 0x40000>,<0x50c00000 0x40000>;
+      xlnx,rxcsum = <0x2>;
+      xlnx,rxmem = <0x800>;
+      xlnx,txcsum = <0x2>;
+      phy-handle = <&phy0>;
+      axi_ethernetlite_0_mdio: mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        phy0: ethernet-phy@1 {
+          device_type = "ethernet-phy";
+          reg = <1>;
+          };
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index d92f85ca831d..23d6f69eddee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19679,6 +19679,7 @@ F:	include/uapi/linux/fsmap.h
 XILINX AXI ETHERNET DRIVER
 M:	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
 S:	Maintained
+F:	Documentation/devicetree/bindings/net/xilinx_axienet.yaml
 F:	drivers/net/ethernet/xilinx/xilinx_axienet*
 
 XILINX CAN DRIVER
-- 
2.7.4

