Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B7E615EDD
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 10:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiKBJGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 05:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiKBJFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 05:05:37 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2068.outbound.protection.outlook.com [40.107.212.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4223F27FD1;
        Wed,  2 Nov 2022 02:03:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7VCkOD7aomm4yiiQkyCbncgnQ+g4XcQ6F1+A+52UaVlR8yo+h0imrtkEjysLgfXoS9CWqKLdm7gtr833b0KnPCfpFEWC/ommKp0wCwfHF6G2UMrKuStKTglEjxJjp6PcBPWmE2Wz1F9orPRgH8pBdyHDXblxcOgLERfTEdbk64SVb+6Gc6njwKu4J82ESHZoCQ/JKPZ+ngmYHA2WK1oQ0dFF+e/D8IG5QdfjfSHj3kmolHUnX0AXD84z665M9fiSxSp7aTnB2Z5Ii+CU+gzexAaN+J3WDCaYDUxeEVzwntjjScdVuHKU7gbAhnPaimY4vxlSMKJnYNphiMVLzE/Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hfnOoDCb/eOqV//RzzvWRydY2mY3dA0GM3klfOvqtgM=;
 b=YdD7xvHAHklyODJce8Mbrzl8W6gexjf5o2e3L4GnGb1Y+hb7oblrOwK0EE6qLiqTEGWE0tMEABIIdPqiM6VFMRqmubKwVFve75kPgl9P7CqNdzYo/bFHD2UYeEmub1+xGjNip5esWLK8uxP7igZ3vCf/id7zMwSR/1f168haiwtz4J9d4GP97579KlNmgV4Y1x4l1F/1PIit2HAUxSpXzay2RPgmTTVPNhjnzxgVrjeJkcqXm0jyBTr6vB7KDmv+tKrudPziUw90X8eKPVY8c9LoFsIyUwW6YhlPj+oodA2pjBjMWRH5135fJ0/160zlXSKEGoVeVEy6sxSwN+1k8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfnOoDCb/eOqV//RzzvWRydY2mY3dA0GM3klfOvqtgM=;
 b=cnoBpp6ozZZqaSbAp2nUVzqnx5TkaBNwvoIoyPhOcOZjV81s63M+ypRmpOkyl3ZHvNiyBv4O1ulsQmFSbKygJ5TyfwCHGc4KBDRZaTinsofNbBq1X6ZM/WwYmvw3Qp5lVV2CLM+sO/V2UD2P0g5F+KdVlt9Q11ampAk/TWv0ru8=
Received: from DS7P222CA0028.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::21) by
 BY5PR12MB4965.namprd12.prod.outlook.com (2603:10b6:a03:1c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Wed, 2 Nov
 2022 09:03:40 +0000
Received: from DM6NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2e:cafe::51) by DS7P222CA0028.outlook.office365.com
 (2603:10b6:8:2e::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21 via Frontend
 Transport; Wed, 2 Nov 2022 09:03:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT073.mail.protection.outlook.com (10.13.173.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Wed, 2 Nov 2022 09:03:38 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 2 Nov
 2022 04:03:37 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 2 Nov
 2022 02:03:37 -0700
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.31 via Frontend
 Transport; Wed, 2 Nov 2022 04:03:33 -0500
From:   Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>
CC:     <michal.simek@xilinx.com>, <radhey.shyam.pandey@xilinx.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <anirudha.sarangi@amd.com>,
        <harini.katakam@amd.com>, <sarath.babu.naidu.gaddam@amd.com>,
        <git@amd.com>
Subject: [PATCH net-next] dt-bindings: net: xlnx,axi-ethernet: convert bindings document to yaml
Date:   Wed, 2 Nov 2022 14:33:32 +0530
Message-ID: <20221102090332.3602018-1-sarath.babu.naidu.gaddam@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT073:EE_|BY5PR12MB4965:EE_
X-MS-Office365-Filtering-Correlation-Id: 33b68be1-5461-4559-9d3f-08dabcb121dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vhKTM/7a3WqtDQXDDSg2XMXZmkuF0ypeIV+cGx9qNuaouQJPmhBEV6edGGyHzNcv345YuepwgvZVycJhK6geuCJlnisrvDwwhG+icL3MI7nSiT12cGLzdBxeW5k1D6MbOKPnVwYHQv5y8Ay4X0c3qFojNAanXd6KaxvfpjcmDrEHr1ZRw+3FECgbVuRMT/My/TokRrwBMdra1JtJxgPqma8QqTk7/U1903kMrd5zG5DmynLxq7xT2CXk6Z8KnHCVvfjthfIDKp0AZdAgcjPKasfC/V8fmUJ/Y93HKjhorxMNQ1mGjB0skSaVs6mPMPDYV/6yX/smqK2BKbLEtpkGOQnMvq9u2KpKjHd+8t9v9kfuoy5f1g4QZC8AS6SpkmXD/dKhoaVZ3AsgUCGjGyGZC/Yj3h/ugVNSNG0EqJ2EuVCD1LEtG0ELnZ98XIYqmyDkJiChnMXjHKNG98tUK1622b3gsNtmgT/5c/QefKVtxtYmUDwCpJP0a96KAN6A1OY+pKMMDIzWg/kSuCS5am3kYp4pXjAiY95nleMGlOsq6HdnZUCIVInqM77H5gWKwWW4ywW/ddjcO8jwEqNKkIhzl4hlsk+em+QFhRiV+ixtdw3MLlVF2gSGaA1NClteBReF+UacGY5HAfaU9Qzl0ZadFeb6loJIM1oBXYvcYdV7nzGBqr06pUOriP6gKy8RdKaZHIBE9HQ1t3lPQE1VIPiDlmsaBLv13dD6MrdQbpVXswwqtH7Rr2dMbld80a60TOsKoOOAj8Ll1pm/Eab5drpaDQK+NBAzcIjG0mNkpG3vC7+H5UVAj+FcwvtHRWyR00G2ymmNbGrJa+ucZlk5S1Um+Wckohnz+8L7oXSwzm13DTBzxjvrLJ/2meIak0aEDTJK
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(82740400003)(336012)(2906002)(47076005)(426003)(40460700003)(86362001)(316002)(41300700001)(70586007)(40480700001)(26005)(2616005)(70206006)(103116003)(1076003)(110136005)(54906003)(356005)(82310400005)(186003)(81166007)(36756003)(30864003)(4326008)(8936002)(5660300002)(7416002)(8676002)(966005)(83380400001)(36860700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2022 09:03:38.9061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33b68be1-5461-4559-9d3f-08dabcb121dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4965
X-Spam-Status: No, score=-0.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

Convert the bindings document for Xilinx AXI Ethernet Subsystem
from txt to yaml. No changes to existing binding description.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
---
 .../bindings/net/xilinx_axienet.txt           |  99 ------------
 .../bindings/net/xlnx,axi-ethernet.yaml       | 150 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 3 files changed, 151 insertions(+), 99 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/xilinx_axienet.txt
 create mode 100644 Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
deleted file mode 100644
index 1aa4c6006cd0..000000000000
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ /dev/null
@@ -1,99 +0,0 @@
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
-- phy-handle	: Should point to the external phy device if exists. Pointing
-		  this to the PCS/PMA PHY is deprecated and should be avoided.
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
-- clock-names: 	  Tuple listing input clock names. Possible clocks:
-		  s_axi_lite_clk: Clock for AXI register slave interface
-		  axis_clk: AXI4-Stream clock for TXD RXD TXC and RXS interfaces
-		  ref_clk: Ethernet reference clock, used by signal delay
-			   primitives and transceivers
-		  mgt_clk: MGT reference clock (used by optional internal
-			   PCS/PMA PHY)
-
-		  Note that if s_axi_lite_clk is not specified by name, the
-		  first clock of any name is used for this. If that is also not
-		  specified, the clock rate is auto-detected from the CPU clock
-		  (but only on platforms where this is possible). New device
-		  trees should specify all applicable clocks by name - the
-		  fallbacks to an unnamed clock or to CPU clock are only for
-		  backward compatibility.
-- clocks: 	  Phandles to input clocks matching clock-names. Refer to common
-		  clock bindings.
-- axistream-connected: Reference to another node which contains the resources
-		       for the AXI DMA controller used by this device.
-		       If this is specified, the DMA-related resources from that
-		       device (DMA registers and DMA TX/RX interrupts) rather
-		       than this one will be used.
- - mdio		: Child node for MDIO bus. Must be defined if PHY access is
-		  required through the core's MDIO interface (i.e. always,
-		  unless the PHY is accessed through a different bus).
-
- - pcs-handle: 	  Phandle to the internal PCS/PMA PHY in SGMII or 1000Base-X
-		  modes, where "pcs-handle" should be used to point
-		  to the PCS/PMA PHY, and "phy-handle" should point to an
-		  external PHY if exists.
-
-Example:
-	axi_ethernet_eth: ethernet@40c00000 {
-		compatible = "xlnx,axi-ethernet-1.00.a";
-		device_type = "network";
-		interrupt-parent = <&microblaze_0_axi_intc>;
-		interrupts = <2 0 1>;
-		clock-names = "s_axi_lite_clk", "axis_clk", "ref_clk", "mgt_clk";
-		clocks = <&axi_clk>, <&axi_clk>, <&pl_enet_ref_clk>, <&mgt_clk>;
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
diff --git a/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
new file mode 100644
index 000000000000..6fcc21c25aeb
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
@@ -0,0 +1,150 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/xlnx,axi-ethernet.yaml#
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
+  - $ref: ethernet-controller.yaml#
+
+maintainers:
+  - Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
+
+properties:
+  compatible:
+    enum:
+      - xlnx,axi-ethernet-1.00.a
+      - xlnx,axi-ethernet-1.01.a
+      - xlnx,axi-ethernet-2.01.a
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
+      TX DMA, RX DMA, and optionally Ethernet core. If axistream-connected is
+      specified, the TX/RX DMA interrupts should be on that node instead, and
+      only the Ethernet core interrupt is optionally specified here.
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
+    type: boolean
+    description:
+      Indicate the Ethernet core is configured to support both 1000BaseX and
+      SGMII modes. If set, the phy-mode should be set to match the mode
+      selected on core reset (i.e. by the basex_or_sgmii core input line).
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
+  pcs-handle:
+    description: Phandle to the internal PCS/PMA PHY in SGMII or 1000Base-X
+      modes, where "pcs-handle" should be used to point to the PCS/PMA PHY,
+      and "phy-handle" should point to an external PHY if exists.
+    $ref: /schemas/types.yaml#/definitions/phandle
+
+required:
+  - compatible
+  - interrupts
+  - reg
+  - xlnx,rxmem
+  - phy-handle
+
+additionalProperties: false
+
+examples:
+  - |
+    axi_ethernet_eth: ethernet@40c00000 {
+        compatible = "xlnx,axi-ethernet-1.00.a";
+        interrupt-parent = <&microblaze_0_axi_intc>;
+        interrupts = <2>, <0>, <1>;
+        clock-names = "s_axi_lite_clk", "axis_clk", "ref_clk", "mgt_clk";
+        clocks = <&axi_clk>, <&axi_clk>, <&pl_enet_ref_clk>, <&mgt_clk>;
+        phy-mode = "mii";
+        reg = <0x40c00000 0x40000>,<0x50c00000 0x40000>;
+        xlnx,rxcsum = <0x2>;
+        xlnx,rxmem = <0x800>;
+        xlnx,txcsum = <0x2>;
+        phy-handle = <&phy0>;
+
+        axi_ethernetlite_0_mdio: mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+            phy0: ethernet-phy@1 {
+                device_type = "ethernet-phy";
+                reg = <1>;
+            };
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 5c6ce094e55e..f9e748afba45 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22556,6 +22556,7 @@ F:	drivers/iio/adc/xilinx-ams.c
 XILINX AXI ETHERNET DRIVER
 M:	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
 S:	Maintained
+F:	Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
 F:	drivers/net/ethernet/xilinx/xilinx_axienet*
 
 XILINX CAN DRIVER
-- 
2.25.1

