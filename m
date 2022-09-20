Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B505BDCBE
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 07:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiITF5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 01:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiITF52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 01:57:28 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FE413DE6;
        Mon, 19 Sep 2022 22:57:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDoF2oafn4EH94/M/I0at7udi61vYbsSQF5HO12aGC4kimt3JbrspSl7dedtCV4jIAf22sST6swDgLcJKE7KdLRTPdvC7UhyiRZbhI9BcT8NNovCJXy7Foxgw01bsHvUWAD7kdiTQPeRwgoBBhB0A4aw7DvInsilgkEsr7VAWwFqx4IiPQ1nfcskozSDgTIEBVrV6WYQxJgeM+IhZ20Cppwkunu1KuTfnpof04pthXFYVxcyHLihP4f7gWNw9OrjXXjE7oY9XH3Q0vJSmVZDC15Kha3ypUN2nzt1kbeQj1RohiFfXXONI9Ahc7lRP4PF/hhq+41bh5DMT9qZaf4b7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+LKwP9Fvk+OBB3C17Ye9TSgXi59+F0bqEzBU8LqtiSw=;
 b=MVKk3ZIYGjGu4iNR4tgu2CXFULlUGySHjmaxA+VSQmDxxoa/JuOXq+nZ/2O1NYgn3rvATXxQ3qtlh0w5zZv6CCVUOJJ++/Q4EDRVJCncwc6C1JyI/e//SxEF2cCRCjcXAnfldlPWjq3/xwUcfvRSyjpqHnTVvM5fDRz1TDfNLVusxCfjEEdDhYDdrAO1zrEIWBqvzV1dUcf31ZMMkQVNB6hnFteXk4nW4UC5Hl+MWiXPVabYYupeaf3SM2UWs9gAR2J6fD/eG5SoWp0ektioD7Uqgwco4Dv7pgaIApzr1msjGBT/cYSV6V9kBsUrRc0XjAsa1so6gkrpa0K6QhhqeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+LKwP9Fvk+OBB3C17Ye9TSgXi59+F0bqEzBU8LqtiSw=;
 b=vTUnudv+kcZvNNitodD1HIHLWI4/kCysNCowYPgxszmbNwvjjYkl+tZmqtEntyNZdjmfrUJHyNEEGAUZSz7qPskFFSxyZUrDcWrMzac/j+AIqUCe94Yeq/w2eVFe7VXVc1oV1E7x45SohgPpLyxO228IYDvnWkuX3qg7D0+etOM=
Received: from BN0PR07CA0028.namprd07.prod.outlook.com (2603:10b6:408:141::27)
 by CY8PR12MB7099.namprd12.prod.outlook.com (2603:10b6:930:61::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 05:57:18 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::c1) by BN0PR07CA0028.outlook.office365.com
 (2603:10b6:408:141::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14 via Frontend
 Transport; Tue, 20 Sep 2022 05:57:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5632.12 via Frontend Transport; Tue, 20 Sep 2022 05:57:17 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 20 Sep
 2022 00:57:16 -0500
Received: from xhdswatia40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Tue, 20 Sep 2022 00:57:10 -0500
From:   Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <michal.simek@amd.com>,
        <radhey.shyam.pandey@amd.com>, <anirudha.sarangi@amd.com>,
        <harini.katakam@amd.com>, <sarath.babu.naidu.gaddam@amd.com>,
        <git@xilinx.com>, <git@amd.com>
Subject: [RFC V2 PATCH 1/3] dt-bindings: net: xilinx_axienet:convert bindings document to yaml
Date:   Tue, 20 Sep 2022 11:27:01 +0530
Message-ID: <20220920055703.13246-2-sarath.babu.naidu.gaddam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220920055703.13246-1-sarath.babu.naidu.gaddam@amd.com>
References: <20220920055703.13246-1-sarath.babu.naidu.gaddam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT065:EE_|CY8PR12MB7099:EE_
X-MS-Office365-Filtering-Correlation-Id: 492b5ff9-2944-4752-7268-08da9accf97b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kdDR0PysOmFrEbp+0fjEQKZDZbJbfWtyHbN6JsNTCID4LuG4v8K0Yeaenw+9MfpEj8nz2WxOHxwhpgdDjRqLd7Tb3cpYCDNk+UN/A7gKpqRMtLgIkJHyTVITFUDnvo7zkJsLrj+OpnNxpZq7VRzZcsELkDu6Kkkfn6JNqvzyO1wY/oQuKNkZXfXvhS36Me02R+B/B5ZS6PbLoBT+Td3DWRhz6C6qRZ8GFIet86d+8U1izOfKYmNJ93Z8PFKB/gkBVBKeghrszY7ZSrFCQD3dpHZvEY90ndLIV8B5f7VI41mjJVoPU6dt3FzCROW8zpcYROq32i5H8aLJ21EabEgAfKpSB7uumxA4ztx+AfbzWJcuzxHZFYu+qmz3m1+S7p3tup94TOVmYWcOyDpt0bqexPNYObrTk5jj+SlIfMEo99AVxgIIKo9hUU6sBQ6u/cmsVDPka4szjR2fMRfwBa1s5O+R7M4jhlko8HQU0OHPgSMCE22Jxkhpk4XXLTdh7o4cLnBKCBTTwocJOgrT7de5Pyv2KpFPAIHbl+xTn0dKnAtl7sKQC+bjpzeM9R6LGvbbozu7cXE4n6TfqNmEaWsKhURFLS8vbjHCWwr5Z1sdgqdjcg8hbrhezjkdQhS6VYUUGN4wnASYdR4PDPNCCM/4bE+v40702AXJ5M3mtnrs/d6TOL6LKmHV6KTev/Fx8arP+etmM6wrkXka0tVrQctw3ueupBOKsrspQ1+8HgnFuVnZIsPKaaNFBhBFG59n1T1OA6PJW30+/ffnNhmCq2VlOQwP3i9/iT8jb0d8xkvV5AeQaf5h0lmQV5ptpIw+t6ggqbU2bTwdGaBaWqFixNlc0UwSV7JI/CvTo6K4QpVOyZcJ4+LyZWfCHs+vWaImn5jD
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(39860400002)(346002)(451199015)(40470700004)(46966006)(36840700001)(36756003)(6666004)(26005)(40460700003)(82740400003)(4326008)(82310400005)(70586007)(54906003)(70206006)(41300700001)(110136005)(356005)(36860700001)(40480700001)(966005)(81166007)(103116003)(86362001)(426003)(2616005)(83380400001)(186003)(1076003)(336012)(47076005)(478600001)(8676002)(2906002)(316002)(30864003)(5660300002)(7416002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 05:57:17.5344
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 492b5ff9-2944-4752-7268-08da9accf97b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7099
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
Changes in V2:
1) remove .txt and change the name of file to xlnx,axiethernet.yaml.
2) Fix DT check warning('device_type' does not match any of the regexes:
   'pinctrl-[0-9]+' From schema: Documentation/devicetree/bindings/net
    /xilinx_axienet.yaml).
---
 .../devicetree/bindings/net/xilinx_axienet.txt     |   99 -------------
 .../devicetree/bindings/net/xlnx,axiethernet.yaml  |  152 ++++++++++++++++++++
 MAINTAINERS                                        |    1 +
 3 files changed, 153 insertions(+), 99 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/xilinx_axienet.txt
 create mode 100644 Documentation/devicetree/bindings/net/xlnx,axiethernet.yaml

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
deleted file mode 100644
index 1aa4c60..0000000
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
diff --git a/Documentation/devicetree/bindings/net/xlnx,axiethernet.yaml b/Documentation/devicetree/bindings/net/xlnx,axiethernet.yaml
new file mode 100644
index 0000000..780edf3
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/xlnx,axiethernet.yaml
@@ -0,0 +1,152 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/xlnx,axiethernet.yaml#
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
+      compatible = "xlnx,axi-ethernet-1.00.a";
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
index 9479f77..1f5fbde 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22285,6 +22285,7 @@ F:	drivers/iio/adc/xilinx-ams.c
 XILINX AXI ETHERNET DRIVER
 M:	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
 S:	Maintained
+F:	Documentation/devicetree/bindings/net/xilinx_axienet.yaml
 F:	drivers/net/ethernet/xilinx/xilinx_axienet*
 
 XILINX CAN DRIVER
-- 
1.7.1

