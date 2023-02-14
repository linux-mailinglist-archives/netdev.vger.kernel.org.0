Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E7F69625A
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 12:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbjBNLXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 06:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbjBNLXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 06:23:10 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712DD4C1B;
        Tue, 14 Feb 2023 03:23:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqyX6cGwqosZamHaBGLQ+KXPXncQbffKLMXn9rs0UUBECO9P1FLuADMSSU8Q3i/FqMX+2zqKJBMnyNa6gOFzHhiCakdzycRZJKU7jW5ukqwNZ56vlhtEoILL4HUwEqVeOsgBhoYrCSxcCV6cTTvv8lqgssClchXLraXzpBQ8FiOzpISqTpBUgaoGX9A2XUQhFp2V+uNLHs50tSK3uQPOQmRYT8goQMWP7FngyiexqU9uuoHzG6CKv7ksA18vWl6NErkA7bxSKGAyHExEg21E8R238t4LhTui76yIYGB46QMdGHyfa6C3lGnxIzD7lKnoardcRVm03cjKkJ5cQ/4nFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C13vDGbnG2NBILiJ3SF2ziTXYJ27FaIZe2ug5j1/Wek=;
 b=Cd3fq7B96uruepfrrD0tMuIK1fDgZKyOr5Tep3m/+L7iutx9p6w5h95gPiHsO+o1LNn5MryAIml/hxyS6POo//v7BO1L6lSvN3KpAk13yJUdPcvYM3l3GG/wwWlH7exNHwTTGCoQtmXSmHranmFmVcWYvaY3xo7gc4uHrJdgGiBFE8UAzuvOQoOH6TaxJjbIzSnS6Use3xlyURR3nAwzLLO+I9ZmwXkSwScQfw0rRXCAPMNT/oJCgpJ7gLRvGuiPp+whfSklzO2mkwvi290OB0oBVplKmaDSrOcmC1VbiWqMOzFUEXDs/KAzu5xqDryCTjmCFfnHn5AGNdN4sVW4ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C13vDGbnG2NBILiJ3SF2ziTXYJ27FaIZe2ug5j1/Wek=;
 b=yn+T/rpsnpSh8my2aHuHBJoeXlbYIc8q/WpuE2tgfTUydF7kSkgbP/eCkHF6SBG4ZKJZc3K4KNZujY/kasP+m24D0gH26W98u70N/8GAbsGfKapa6hQAGMWm4xE5iXZEml2qq1bugYNfyll+onHFM2QKFJHvvEjLloHSOFU0Wqg=
Received: from DS7PR03CA0246.namprd03.prod.outlook.com (2603:10b6:5:3b3::11)
 by LV2PR12MB6014.namprd12.prod.outlook.com (2603:10b6:408:170::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Tue, 14 Feb
 2023 11:23:05 +0000
Received: from DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::b5) by DS7PR03CA0246.outlook.office365.com
 (2603:10b6:5:3b3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Tue, 14 Feb 2023 11:23:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT029.mail.protection.outlook.com (10.13.173.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.26 via Frontend Transport; Tue, 14 Feb 2023 11:23:05 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Feb
 2023 05:23:04 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 14 Feb
 2023 03:23:04 -0800
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 14 Feb 2023 05:23:00 -0600
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
Subject: [PATCH net-next V5] dt-bindings: net: xlnx,axi-ethernet: convert bindings document to yaml
Date:   Tue, 14 Feb 2023 16:52:59 +0530
Message-ID: <20230214112259.4076450-1-sarath.babu.naidu.gaddam@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT029:EE_|LV2PR12MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fc7640f-fd7a-4908-b3a4-08db0e7dd77d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9VqjFe6ykC3zCJUisJd/OjgAqStSXVyFTT/Zcm2Om5Swzrokx+Nbmw+KAdAUCPY5xG1UaCzSGjo3w54o5QkJLKE3BIrzHKMVj2CEK0LO0/g8yAbu+SwOrl2Ryc/jZ7qoF60KzKdrFE2A8ek1dOZFTEppqo7XcLXDjTYd2fFOeAoX4b2/ahXn9Y1KKn0cAQCvsLC7EKAoeAVLmDSd3VN3lKzQK56uDHfgF4uY8B60hSTqtobJEw9gXxJckcyb4e2ktsWH9wGnVD4+q+evMAbdt/zJH2wKNJULnL3IzlmUEJl1Nd6RnPcYH/bcY4eg5Jiq9ZVc338G+7p4hWiaDEiKOJRyuR6m57mIWND4AP8tCdyriYu9vM/nRUEIdn8ID8gpeXKyxyExX8Yq12rWq4MPekO+GJ5AG35Dnc4WmND7mp8kOad/G5xML/VWWvn6zw79asOftJiIvjBeUEl9x+fxBn7O4fJFXmuBdoqqy2kxWPla3NsLleIkEqjMFuFgyRjD18TG+FIY1MZkIMAep6ZgwzI5tpmBwclBjAlBhiy4Z6n3ODqeZ7WxzLRyuvTlXtOM45ztS5VYwCj8EG4Lx70yqu9XzS/sqhWBHifEJLpfW2ZEsOp9Y1BKRHR9/hEmHzWWVSlgvRD+UrzSThF5fA6biIYP5qR8F+BNFTPdTWkXWTQbFpRZXGl9TMxojnZyP5HIEZMJhv3pZHAuxofiwrSfDh0nSEVak0vc/4RTRkd9pD/L9Cjn5R2lzeW4cs3MPaNw
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(316002)(426003)(54906003)(47076005)(110136005)(70586007)(8936002)(7416002)(36756003)(5660300002)(40480700001)(36860700001)(30864003)(82740400003)(2906002)(83380400001)(103116003)(8676002)(81166007)(356005)(40460700003)(70206006)(4326008)(1076003)(41300700001)(478600001)(2616005)(966005)(82310400005)(336012)(186003)(86362001)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 11:23:05.1316
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fc7640f-fd7a-4908-b3a4-08db0e7dd77d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6014
X-Spam-Status: No, score=1.0 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
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
Chanages in V5:
1) Removed .txt file which was missed in V4

Changes in V4:
1)Changed the interrupts property and add allOf:if:then for it.

Changes in V3:
1) Moved RFC to PATCH.
2) Addressed below review comments
	a) Indentation.
	b) maxItems:3 does not match your description.
	c) Filename matching compatibles.

Changes in V2:
1) remove .txt and change the name of file to xlnx,axiethernet.yaml.
2) Fix DT check warning('device_type' does not match any of the regexes:
   'pinctrl-[0-9]+' From schema: Documentation/devicetree/bindings/net
    /xilinx_axienet.yaml).
---
 .../bindings/net/xilinx_axienet.txt           | 101 -----------
 .../bindings/net/xlnx,axi-ethernet.yaml       | 166 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 3 files changed, 167 insertions(+), 101 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/xilinx_axienet.txt
 create mode 100644 Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
deleted file mode 100644
index 80e505a2fda1..000000000000
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ /dev/null
@@ -1,101 +0,0 @@
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
-		  Non-standard MDIO bus frequency is supported via
-		  "clock-frequency", see mdio.yaml.
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
index 000000000000..d2d276d4858f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
@@ -0,0 +1,166 @@
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
+    items:
+      - description: Ethernet core interrupt
+      - description: Tx DMA interrupt
+      - description: Rx DMA interrupt
+    description:
+      Ethernet core interrupt is optional. If axistream-connected property is
+      present DMA node should contains TX/RX DMA interrupts else DMA interrupt
+      resources are mentioned on ethernet node.
+    minItems: 1
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
+allOf:
+  - if:
+      required:
+        - axistream-connected
+
+    then:
+      properties:
+        interrupts:
+          minItems: 2
+          maxItems: 3
+
+    else:
+      properties:
+        interrupts:
+          maxItems: 1
+
+additionalProperties: false
+
+examples:
+  - |
+    axi_ethernet_eth: ethernet@40c00000 {
+        compatible = "xlnx,axi-ethernet-1.00.a";
+        interrupt-parent = <&microblaze_0_axi_intc>;
+        interrupts = <2 0 1>;
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
index 2cf9eb43ed8f..0bf527552dc9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22895,6 +22895,7 @@ F:	drivers/iio/adc/xilinx-ams.c
 XILINX AXI ETHERNET DRIVER
 M:	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
 S:	Maintained
+F:	Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
 F:	drivers/net/ethernet/xilinx/xilinx_axienet*
 
 XILINX CAN DRIVER
-- 
2.25.1

