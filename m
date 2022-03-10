Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1DE4D4D33
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235989AbiCJPkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiCJPkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:40:23 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2067.outbound.protection.outlook.com [40.107.96.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CE3180D32;
        Thu, 10 Mar 2022 07:39:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HiCp9qdmfs6zW8vI0NOVUUmr1RSUWI1oCdt4Fbnvo1NF5Ro1PGXm7jQYVWGgPLUU22wbggzvzFZZ8K8JzjvjeEKl5mE7L5hNGhg17bGxMgeGoLUnrOJ4O2TBwoJboCmKO7CXe34FQnj+K4ihOlUVQKPwrKIfyQe1l/vBV1W/u1OlcL1SmdljkC9AKgysBso9hfKuoKswwBJ1bo4CoMj8fxD4knfsLELexg1z7a0aEQvKG6LIaTgkgx829DHSe8OR/JCe8+lOCFIkSOysmQbHeor72GcYFAFTcqPf7vLnen76/TleZjPKLMlZhT94eq+9BViYgzci/lMLkPr/PCTaFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SQ+BFbICNAvVEOHug11pkOHzBy0M7gSUISiUaHxXpyg=;
 b=E/EZFQUij4BXEgeW1thzng5w+3bXDsQS1vP4XJpp7CtVfhNS7g76bxY3z1vTeF82kr6Q7OXkKfrV0HHO+rrd0kczF4d5ySCzwb3CKwPllcoraxAEPQYj+JaIXtG+MbsaMR1+haRjzyqxLRRuW/DWf71EyTyGWCFxH2pzMPXB+gsFf7dXFr2AotM8hlICPa0poiMTwth6UrqVpBdtX37jHYo3vc7izE9sEaefKV/EQmNwWa3US965scmdhXDyLdRooTR631KTi0MIxAkZReIWykBAUXL7Lk1HLnCTbyLpy11AM3zrhIol/2sV0Ziz67QIM+Q34jI3tPYkLFAkspCodg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=grandegger.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SQ+BFbICNAvVEOHug11pkOHzBy0M7gSUISiUaHxXpyg=;
 b=Y03oA2/XekROrZGNlxTUWtnquKtU7FMRMAnrahMY8AVbKBojx/4vDVf9jj2L/y7ZiVmKSUfmuqfDI+YwCfaXZUBl2LvXtjhc/b0jupVy5jwHCkYl7ewmICzv92vhkHdyJU85tZANR6+apSsNcBFZBL0k6jLu/M6YPi3yZ4idwcg=
Received: from SA9PR10CA0015.namprd10.prod.outlook.com (2603:10b6:806:a7::20)
 by SA2PR02MB7594.namprd02.prod.outlook.com (2603:10b6:806:140::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 10 Mar
 2022 15:39:20 +0000
Received: from SN1NAM02FT0033.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:a7:cafe::40) by SA9PR10CA0015.outlook.office365.com
 (2603:10b6:806:a7::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Thu, 10 Mar 2022 15:39:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0033.mail.protection.outlook.com (10.97.5.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5061.22 via Frontend Transport; Thu, 10 Mar 2022 15:39:19 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 10 Mar 2022 07:39:16 -0800
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 10 Mar 2022 07:39:16 -0800
Envelope-to: git@xilinx.com,
 wg@grandegger.com,
 mkl@pengutronix.de,
 kuba@kernel.org,
 robh+dt@kernel.org,
 linux-can@vger.kernel.org,
 netdev@vger.kernel.org,
 devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Received: from [10.140.6.18] (port=57574 helo=xhdlakshmis40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <amit.kumar-mahapatra@xilinx.com>)
        id 1nSKsl-000ACT-JN; Thu, 10 Mar 2022 07:39:16 -0800
From:   Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <kuba@kernel.org>,
        <robh+dt@kernel.org>, <appana.durga.rao@xilinx.com>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <michal.simek@xilinx.com>,
        <git@xilinx.com>, <akumarma@xilinx.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Subject: [PATCH v3] dt-bindings: can: xilinx_can: Convert Xilinx CAN binding to YAML
Date:   Thu, 10 Mar 2022 21:09:09 +0530
Message-ID: <20220310153909.30933-1-amit.kumar-mahapatra@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bfd0aa79-e8e8-4add-7fbe-08da02ac247b
X-MS-TrafficTypeDiagnostic: SA2PR02MB7594:EE_
X-Microsoft-Antispam-PRVS: <SA2PR02MB75947CC8F15BA54E0F82103BBA0B9@SA2PR02MB7594.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OLzHqkkhshaQ5im3/jT9nJ8nsje3A3iPyOODV5IxAr/mZzuD/2AR5HdkOlsxzGlU2IkP9dAi7iTDh+5pSRT6MP1exmRZVDcSjD/JkAAI2J1gap4pUjQnWnizqWqEE1ZwmvqdMUQ9Hb3YqEyyOOEuEE3vzF5D3HVU4eDAqsmfC0a3xL0tPJ/BbPfOUsSyaNf/vXSdGeU0S3O38KzZFFh5ETaTSbPGZw+QzZ0JEg6TQIO+wR5Cmb8HutgyWY4Cg6Qzoafcsoz8oZMnZ6faDybpiRWJYKjShUyhYRhwk2HqBfbbBWOV19a1Wxz0rwOrGHeYG58LMrZcUOYRUl+P2a5t9yy24H6CEgFRVsOORSXt63b6/N3B/fZ3nb6k28gUugPU+swdoDaAyy/DI4H4wVVbusLkijy0qTxhrflUhafyGn6P5si1CtRr4fjZoHitTIAhXDnrLrj4aKAD13jNaWRKyOtDLZb+8IYsStTNtqPEbWM1yLfurqAzsDX3YUyaNStF05zHiWG6VZvCr+kqTS5+btsvuxwx4diiRVyJadQ/XtaMiQp+4FL3d6kVrRXKlnlA22WtjPj4WxXmhqgAONWlx5oVOtQV8FEXGq8AGMWRMRAQVP22LqFwpHI4qxrojoUOGOrfKIDd4indUn7KvDwJRF+Sqj9P79koFH73ESQoRt4QDQ83m19wBHPxq8bUG5xOcS0n6LJY73+wfV8yX/x55dIBK63hfnWpsaDEeDy8wHrVXeaDToxtSlG1ksnndiby0Ug/EiKJ0v3pdgd0MNd0N4ieiL6c07JZNLO//w6MP7lBGmJW29bbHik25aJuSwm5nxPCHrSCGh0ecYY8GHgYJQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(356005)(6636002)(54906003)(110136005)(316002)(9786002)(186003)(70206006)(70586007)(7636003)(8676002)(36756003)(36860700001)(107886003)(966005)(508600001)(4326008)(5660300002)(6666004)(1076003)(26005)(40460700003)(83380400001)(2616005)(8936002)(47076005)(336012)(426003)(7696005)(2906002)(82310400004)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 15:39:19.5112
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd0aa79-e8e8-4add-7fbe-08da02ac247b
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0033.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7594
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert Xilinx CAN binding documentation to YAML.

Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
---
BRANCH: yaml

Changes in v2:
 - Added reference to can-controller.yaml
 - Added example node for canfd-2.0

Changes in v3:
 - Changed yaml file name from xilinx_can.yaml to xilinx,can.yaml
 - Added "power-domains" to fix dts_check warnings
 - Grouped "clock-names" and "clocks" together
 - Added type $ref for all non-standard fields
 - Defined compatible strings as enum
 - Used defines,instead of hard-coded values, for GIC interrupts
 - Droped unused labels in examples
 - Droped description for standard feilds
---
 .../bindings/net/can/xilinx,can.yaml          | 161 ++++++++++++++++++
 .../bindings/net/can/xilinx_can.txt           |  61 -------
 2 files changed, 161 insertions(+), 61 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/xilinx,can.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.txt

diff --git a/Documentation/devicetree/bindings/net/can/xilinx,can.yaml b/Documentation/devicetree/bindings/net/can/xilinx,can.yaml
new file mode 100644
index 000000000000..78398826677d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/xilinx,can.yaml
@@ -0,0 +1,161 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/can/xilinx,can.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title:
+  Xilinx Axi CAN/Zynq CANPS controller
+
+maintainers:
+  - Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
+
+properties:
+  compatible:
+    enum:
+      - xlnx,zynq-can-1.0
+      - xlnx,axi-can-1.00.a
+      - xlnx,canfd-1.0
+      - xlnx,canfd-2.0
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    minItems: 1
+    maxItems: 2
+
+  clock-names:
+    maxItems: 2
+
+  power-domains:
+    maxItems: 1
+
+  tx-fifo-depth:
+    $ref: "/schemas/types.yaml#/definitions/uint32"
+    description: CAN Tx fifo depth (Zynq, Axi CAN).
+
+  rx-fifo-depth:
+    $ref: "/schemas/types.yaml#/definitions/uint32"
+    description: CAN Rx fifo depth (Zynq, Axi CAN, CAN FD in sequential Rx mode)
+
+  tx-mailbox-count:
+    $ref: "/schemas/types.yaml#/definitions/uint32"
+    description: CAN Tx mailbox buffer count (CAN FD)
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+
+additionalProperties: false
+
+allOf:
+  - $ref: can-controller.yaml#
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - xlnx,zynq-can-1.0
+
+    then:
+      properties:
+        clock-names:
+          items:
+            - const: can_clk
+            - const: pclk
+      required:
+        - tx-fifo-depth
+        - rx-fifo-depth
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - xlnx,axi-can-1.00.a
+
+    then:
+      properties:
+        clock-names:
+          items:
+            - const: can_clk
+            - const: s_axi_aclk
+      required:
+        - tx-fifo-depth
+        - rx-fifo-depth
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - xlnx,canfd-1.0
+              - xlnx,canfd-2.0
+
+    then:
+      properties:
+        clock-names:
+          items:
+            - const: can_clk
+            - const: s_axi_aclk
+      required:
+        - tx-mailbox-count
+        - rx-fifo-depth
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    can@e0008000 {
+        compatible = "xlnx,zynq-can-1.0";
+        clocks = <&clkc 19>, <&clkc 36>;
+        clock-names = "can_clk", "pclk";
+        reg = <0xe0008000 0x1000>;
+        interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-parent = <&intc>;
+        tx-fifo-depth = <0x40>;
+        rx-fifo-depth = <0x40>;
+    };
+
+  - |
+    can@40000000 {
+        compatible = "xlnx,axi-can-1.00.a";
+        clocks = <&clkc 0>, <&clkc 1>;
+        clock-names = "can_clk","s_axi_aclk" ;
+        reg = <0x40000000 0x10000>;
+        interrupt-parent = <&intc>;
+        interrupts = <GIC_SPI 59 IRQ_TYPE_EDGE_RISING>;
+        tx-fifo-depth = <0x40>;
+        rx-fifo-depth = <0x40>;
+    };
+
+  - |
+    can@40000000 {
+        compatible = "xlnx,canfd-1.0";
+        clocks = <&clkc 0>, <&clkc 1>;
+        clock-names = "can_clk", "s_axi_aclk";
+        reg = <0x40000000 0x2000>;
+        interrupt-parent = <&intc>;
+        interrupts = <GIC_SPI 59 IRQ_TYPE_EDGE_RISING>;
+        tx-mailbox-count = <0x20>;
+        rx-fifo-depth = <0x20>;
+    };
+
+  - |
+    can@ff060000 {
+        compatible = "xlnx,canfd-2.0";
+        clocks = <&clkc 0>, <&clkc 1>;
+        clock-names = "can_clk", "s_axi_aclk";
+        reg = <0xff060000 0x6000>;
+        interrupt-parent = <&intc>;
+        interrupts = <GIC_SPI 59 IRQ_TYPE_EDGE_RISING>;
+        tx-mailbox-count = <0x20>;
+        rx-fifo-depth = <0x40>;
+    };
diff --git a/Documentation/devicetree/bindings/net/can/xilinx_can.txt b/Documentation/devicetree/bindings/net/can/xilinx_can.txt
deleted file mode 100644
index 100cc40b8510..000000000000
--- a/Documentation/devicetree/bindings/net/can/xilinx_can.txt
+++ /dev/null
@@ -1,61 +0,0 @@
-Xilinx Axi CAN/Zynq CANPS controller Device Tree Bindings
----------------------------------------------------------
-
-Required properties:
-- compatible		: Should be:
-			  - "xlnx,zynq-can-1.0" for Zynq CAN controllers
-			  - "xlnx,axi-can-1.00.a" for Axi CAN controllers
-			  - "xlnx,canfd-1.0" for CAN FD controllers
-			  - "xlnx,canfd-2.0" for CAN FD 2.0 controllers
-- reg			: Physical base address and size of the controller
-			  registers map.
-- interrupts		: Property with a value describing the interrupt
-			  number.
-- clock-names		: List of input clock names
-			  - "can_clk", "pclk" (For CANPS),
-			  - "can_clk", "s_axi_aclk" (For AXI CAN and CAN FD).
-			  (See clock bindings for details).
-- clocks		: Clock phandles (see clock bindings for details).
-- tx-fifo-depth		: Can Tx fifo depth (Zynq, Axi CAN).
-- rx-fifo-depth		: Can Rx fifo depth (Zynq, Axi CAN, CAN FD in
-                          sequential Rx mode).
-- tx-mailbox-count	: Can Tx mailbox buffer count (CAN FD).
-- rx-mailbox-count	: Can Rx mailbox buffer count (CAN FD in mailbox Rx
-			  mode).
-
-
-Example:
-
-For Zynq CANPS Dts file:
-	zynq_can_0: can@e0008000 {
-			compatible = "xlnx,zynq-can-1.0";
-			clocks = <&clkc 19>, <&clkc 36>;
-			clock-names = "can_clk", "pclk";
-			reg = <0xe0008000 0x1000>;
-			interrupts = <0 28 4>;
-			interrupt-parent = <&intc>;
-			tx-fifo-depth = <0x40>;
-			rx-fifo-depth = <0x40>;
-		};
-For Axi CAN Dts file:
-	axi_can_0: axi-can@40000000 {
-			compatible = "xlnx,axi-can-1.00.a";
-			clocks = <&clkc 0>, <&clkc 1>;
-			clock-names = "can_clk","s_axi_aclk" ;
-			reg = <0x40000000 0x10000>;
-			interrupt-parent = <&intc>;
-			interrupts = <0 59 1>;
-			tx-fifo-depth = <0x40>;
-			rx-fifo-depth = <0x40>;
-		};
-For CAN FD Dts file:
-	canfd_0: canfd@40000000 {
-			compatible = "xlnx,canfd-1.0";
-			clocks = <&clkc 0>, <&clkc 1>;
-			clock-names = "can_clk", "s_axi_aclk";
-			reg = <0x40000000 0x2000>;
-			interrupt-parent = <&intc>;
-			interrupts = <0 59 1>;
-			tx-mailbox-count = <0x20>;
-			rx-fifo-depth = <0x20>;
-		};
-- 
2.17.1

