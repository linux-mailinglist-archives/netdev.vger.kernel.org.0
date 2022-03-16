Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7BD74DB6F0
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 18:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244678AbiCPRMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 13:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237728AbiCPRMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 13:12:32 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215A512AEF;
        Wed, 16 Mar 2022 10:11:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQEYmpY2sVgpJM1wgkARVOFYY02a1fKQmd5lsn8mv7ZE66MlCCyw36znsdqHaJlQAz776fj68qrZVQftjyzTAbjY88S/CGshxfL+kyiZX8QZrZ5u5x3q9roWxnzElHeaFYBNF9VqZGA6E+hziJFSNuxlwg5URHOl1fH/kkQP5py3k8L0r/6RvwH0WtVJdiivQyanHVA9ne7HaXc14BrVP8ndDPHMRvE+VGfO4DCDTVAosUKQnJykspO2m22/I2ChGK+ud2FbDaX7/i5J/hQXEjpE6fAS3REiPYsW6xAl9d3oe9YPZxuRlkr7XIBVbzyq04ew1VT2dPnC7VRggxSrSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFSyUBwgNdWE08Cy+O7YY2A8zJqd1BO5RQqAu2h54ys=;
 b=dxe690bjUbiFVjqMG0AzW3lyfkTX3QZgBmlwdVXbnmghoypnBk4wWT04sZM2vyU68K5d/ucjwAkh8g63fn7ESfSJNOho0J1AkvIbSeseJOEDStH0/nCTBAJnyqGQF4fvRnxlc+mI3ZON/miaeBRvfS/PjkfsD4//Cwqn5dizVu00Y/gYBKfEZDLBs3mxvBtDrcHWwmY9c+Ndax9ZpF2ICWpXOPBd9M35K5omDq5OnGEOqRUcMyt710N0eH1B8OAqnAN/gX8TQV3gj44a3Mun46Vw46I/rhermSg1r6Mw1GvK9SEXAzmK37h+sHhP/ItROh9x9xTJOelV5CJ0MqQ2Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=grandegger.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFSyUBwgNdWE08Cy+O7YY2A8zJqd1BO5RQqAu2h54ys=;
 b=Leys4t4z6PQWOpbFvPggfoWOsvR06T1iyAjFg56Xx8DWcSQCBhtRm0dqeAKLUw3k38fBWh3PVcGuPxD6eRtXpSVg9PLjgkz7fkvtDIoIPElbn5K23JYOl5THCWe4cpy7RNlNC678rSguGqOsRx1GjHzNVZRFxdgSgR6Gf00M8iU=
Received: from SN4PR0701CA0013.namprd07.prod.outlook.com
 (2603:10b6:803:28::23) by CH2PR02MB6150.namprd02.prod.outlook.com
 (2603:10b6:610:9::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Wed, 16 Mar
 2022 17:11:13 +0000
Received: from SN1NAM02FT0026.eop-nam02.prod.protection.outlook.com
 (2603:10b6:803:28:cafe::a2) by SN4PR0701CA0013.outlook.office365.com
 (2603:10b6:803:28::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25 via Frontend
 Transport; Wed, 16 Mar 2022 17:11:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0026.mail.protection.outlook.com (10.97.5.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5081.14 via Frontend Transport; Wed, 16 Mar 2022 17:11:13 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 16 Mar 2022 10:11:11 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 16 Mar 2022 10:11:11 -0700
Envelope-to: git@xilinx.com,
 wg@grandegger.com,
 mkl@pengutronix.de,
 davem@davemloft.net,
 kuba@kernel.org,
 robh+dt@kernel.org,
 linux-can@vger.kernel.org,
 netdev@vger.kernel.org,
 devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Received: from [10.140.6.18] (port=35714 helo=xhdlakshmis40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <amit.kumar-mahapatra@xilinx.com>)
        id 1nUXB0-000EES-Vt; Wed, 16 Mar 2022 10:11:11 -0700
From:   Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>, <robh+dt@kernel.org>,
        <appana.durga.rao@xilinx.com>
CC:     <git@xilinx.com>, <michal.simek@xilinx.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <akumarma@xilinx.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Subject: [PATCH v4] dt-bindings: can: xilinx_can: Convert Xilinx CAN binding to YAML
Date:   Wed, 16 Mar 2022 22:41:05 +0530
Message-ID: <20220316171105.17654-1-amit.kumar-mahapatra@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 412bdbfa-4128-47b0-0d8b-08da076ff95f
X-MS-TrafficTypeDiagnostic: CH2PR02MB6150:EE_
X-Microsoft-Antispam-PRVS: <CH2PR02MB6150325916FABA2139988E73BA119@CH2PR02MB6150.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LDARUACNbDnS+KahbiLMGNxPzmcXqiTGMLHrjHM7krNWUhqPZ9yeJ7D6yDnNgqGR53fKA0oivQ0HW8j76scaRriD4kDb5Q9ZEcekC8NLwhgkAePJgbcyCkC1v8LwATGTPG6hRFOhv/W2p9YO9se/qy+MydjVrKPoQC+E9smHNkq19gcpuwMxYvXX2iVFCk2EYt7+/mGsOT/bOUIIen9h16kznqbCe9jj9EoVwHFNQHvOKNqXX4zIYN8Xi//qKAz442SDvHLmKXz/udDVil+D/O21nTZhVFsqbUw1MBItrayQpbsmo5JDgghx6W2hLr2+2m98zlJq5c1Tf6IijclpUnT3P2P4qRIxQkQzBm/nd92UFoW7EZqW/2ATmry/TBGDPLdIrD51DY41QwmzPKQdjBAP0yhvb03+6H2D/aRl8OqAjnFlqS5i8A7ZhXze7SXXnJyw8U2HbWUZtRR8qGGZMWeNAsqDayEkNNBCzVYb3rsWY89lCThmGpaFdzPgicSmrWcihbAWdiw7WsiL6CyVwRm7vxi/Y379sH9vxtx37Kw60JssQxROsZnEU+2gyKj54zyRj2nfgvstUYBLv++0tvMXIH0LmfPunp7aFyqRMJCkcgYuRFKrA0bpTuig8HtyAUIa8xk7oI5IecbRUI5LOsdLNDmD8HX2E8LuVRLkXDik7kiVeboyVkTm2d7Gc9SOn4MN0te8HAYj2XMa/IyZYxbp3Pf5Cbyz+67KjW/uWHvc+0NAjpDWJsoeP6YWvUh+HBztBks0Z6TWfYKiTxRlOrKZXPX/ts1zUaFq5gb1AA5SBh+R5aKhPOSFXFLJ76QM0L65yNumrOtm6pJ0/cRjvg==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(8676002)(82310400004)(6666004)(7696005)(7416002)(107886003)(2616005)(1076003)(426003)(26005)(336012)(8936002)(186003)(40460700003)(4326008)(2906002)(47076005)(508600001)(83380400001)(5660300002)(36860700001)(70206006)(70586007)(9786002)(7636003)(966005)(54906003)(110136005)(316002)(356005)(6636002)(36756003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 17:11:13.2085
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 412bdbfa-4128-47b0-0d8b-08da076ff95f
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0026.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6150
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
 - Droped description for standard fields

Changes in v4:
 - Replaced additionalProperties with unevaluatedProperties
 - Moved reg property just after compatible in all examples
---
 .../bindings/net/can/xilinx,can.yaml          | 161 ++++++++++++++++++
 .../bindings/net/can/xilinx_can.txt           |  61 -------
 2 files changed, 161 insertions(+), 61 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/xilinx,can.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.txt

diff --git a/Documentation/devicetree/bindings/net/can/xilinx,can.yaml b/Documentation/devicetree/bindings/net/can/xilinx,can.yaml
new file mode 100644
index 000000000000..65af8183cb9c
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
+unevaluatedProperties: false
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
+        reg = <0xe0008000 0x1000>;
+        clocks = <&clkc 19>, <&clkc 36>;
+        clock-names = "can_clk", "pclk";
+        interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-parent = <&intc>;
+        tx-fifo-depth = <0x40>;
+        rx-fifo-depth = <0x40>;
+    };
+
+  - |
+    can@40000000 {
+        compatible = "xlnx,axi-can-1.00.a";
+        reg = <0x40000000 0x10000>;
+        clocks = <&clkc 0>, <&clkc 1>;
+        clock-names = "can_clk", "s_axi_aclk";
+        interrupt-parent = <&intc>;
+        interrupts = <GIC_SPI 59 IRQ_TYPE_EDGE_RISING>;
+        tx-fifo-depth = <0x40>;
+        rx-fifo-depth = <0x40>;
+    };
+
+  - |
+    can@40000000 {
+        compatible = "xlnx,canfd-1.0";
+        reg = <0x40000000 0x2000>;
+        clocks = <&clkc 0>, <&clkc 1>;
+        clock-names = "can_clk", "s_axi_aclk";
+        interrupt-parent = <&intc>;
+        interrupts = <GIC_SPI 59 IRQ_TYPE_EDGE_RISING>;
+        tx-mailbox-count = <0x20>;
+        rx-fifo-depth = <0x20>;
+    };
+
+  - |
+    can@ff060000 {
+        compatible = "xlnx,canfd-2.0";
+        reg = <0xff060000 0x6000>;
+        clocks = <&clkc 0>, <&clkc 1>;
+        clock-names = "can_clk", "s_axi_aclk";
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

