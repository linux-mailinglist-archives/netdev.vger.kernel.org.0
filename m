Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2564AF8BD
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 18:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238472AbiBIRtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 12:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238447AbiBIRs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 12:48:59 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8115DC05CB86;
        Wed,  9 Feb 2022 09:49:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EHX84i0APCdE9SpCbbaJD7nclp0jM1U+KAFvtKoK8xYjJa0ISaQf0PejfDVuE6WguOQuP8AOgYldj41PuGUMApmAM6/IfNgg+plpPXDw00JAr4avThkQqDIiZJbBIY58dnkttpyAnXwAGjA2ypeP16JshhtCZxs5NQjnu38GdonU8mG7z1Ntlq+0+S1S11r5bUyFVc3+2BtACswMiQ+VmnFDmQgf0GVHUpxhOuSjsVpZmOy/s1O0lg5cw3L4baxtnRNl1aVcvkSVKY5Syo+mzr2LBro65JPxFPuGrZ4J7TkLj5HwH0YPlbA4t9Zf0X85VHQNmNR5mufaZVHNNMal4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+/Reo+7sUBSvK16LJQzjj62ruSCU9mY56sUUAqUOWAc=;
 b=Z2YFXPqOaLtiZYsGAHKiCbbwhFYkDdhL0dadQzIdewidHfsNxI6iIscgpIA2jaPsC0wASRI1HqD3udkUHSUR7AARK9mDqveoP2jg0GBQGfaM/9mdIKJ5rJCq65PrqEwROBwyJ0merimL4h0cgcaHVK3CsovTR7VCd5jLUxsfcMIA6TsSC5WxN9yC0lRiLH6T8Vqrl5zKz0av3s4Yhvx9zxmyEgtscls/LupaLxLhu7FRMyu6l9iwN5TlG8qQi8d4HNP7RlcaKH1c+5ZX4f5RHxaYu/OqrQAMgyZemdqihPGcIWDJSMAWTLIROoIyLccmt4VvI6IHFqRhmv6XJwXo4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=grandegger.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/Reo+7sUBSvK16LJQzjj62ruSCU9mY56sUUAqUOWAc=;
 b=K42YRjYzJmwN2mZSfEiqwsMfiBQsIxmSUkQ5XkF9pIqQ5saT7w2EnaHFtCqc9jcR/2HSU4JK0S7ukIW2LrUSpsDjBRlF4oKO16TXop+GnKBqTa+v/7biX1NlNH9+8EfM2g9V87UNFIQqCv+0kaptwboVdyNb9wFEt9NFhMdXdGg=
Received: from SA9PR13CA0018.namprd13.prod.outlook.com (2603:10b6:806:21::23)
 by CH0PR02MB8150.namprd02.prod.outlook.com (2603:10b6:610:10b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 17:48:59 +0000
Received: from SN1NAM02FT0031.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:21:cafe::33) by SA9PR13CA0018.outlook.office365.com
 (2603:10b6:806:21::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.8 via Frontend
 Transport; Wed, 9 Feb 2022 17:48:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0031.mail.protection.outlook.com (10.97.4.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4975.11 via Frontend Transport; Wed, 9 Feb 2022 17:48:58 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 9 Feb 2022 09:48:56 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 9 Feb 2022 09:48:56 -0800
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
Received: from [10.140.6.18] (port=59086 helo=xhdlakshmis40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <amit.kumar-mahapatra@xilinx.com>)
        id 1nHr5M-000F7w-Ap; Wed, 09 Feb 2022 09:48:56 -0800
From:   Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
To:     <appana.durga.rao@xilinx.com>, <naga.sureshkumar.relli@xilinx.com>,
        <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>, <robh+dt@kernel.org>
CC:     <git@xilinx.com>, <michal.simek@xilinx.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Amit Kumar Mahapatra" <amit.kumar-mahapatra@xilinx.com>
Subject: [PATCH v2] dt-bindings: can: xilinx_can: Convert Xilinx CAN binding to YAML
Date:   Wed, 9 Feb 2022 23:18:50 +0530
Message-ID: <20220209174850.32360-1-amit.kumar-mahapatra@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57d89c4d-539c-42f7-1716-08d9ebf47345
X-MS-TrafficTypeDiagnostic: CH0PR02MB8150:EE_
X-Microsoft-Antispam-PRVS: <CH0PR02MB8150DDDEF833C021D9F3E71CBA2E9@CH0PR02MB8150.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QtIs+UUwUf0WFY4rwFAGfSIXBPBrBZkDdqA8xzQJ7QKtAc2hq+qYRaJUtPInPuV2Z6GJYoWKyeCCJZkUyHFG8x1+19zkHkKdUVQlwOiNvZilRnyC8tBER71agH7nSmnJfTQlMO46mTI3y1Jpl6Uve56ZDhzmj41a7dcqmLAVxgiaqs86Nzuz5wD+B8lpn/y6an9vRmvsNBD1zZEE4AYDhZQwrDCNh5b4GqrJGfGVeOHeP3/xi3xM+YoVJLBkmuUI4JczSFXbL3FbOp70pIYw1SgyNb18fXkSta2hLEv5KoxqBaE0fHcjmaMnrOqzPkEBKPKbZAHBYu2hr/9oRxr2EZ39rowyfz0sEmCP6cwUhh+PQrR9xhJmNtktJGmbPfjpwfHS9HdyaDgJAwmtIvMeWy3zuMg3BoFEpE2rDZ6UY+P7F/EbA6102uknwXJz/YoyYyFOQLOnkaM7FBqI+IBse+QIgxzbkSCWeVxoupMd1byt503mKpRpLvj4QPjWQKBYbNG0+GuGLQG4R3bsnEAatI5oYKx417CCs3OcX1SIZJy22JrKgxhS2scEpH1ge2i4LzNqTwjLYMh4M1DhVVV7eP6r2IC42YSZNvqNA/z6f94wxDT/QmNIGweyhHmdsItS2b1QFEo3O9ui8XKOD7+ZHBV/8Wr4JYFr2t5N2PeeeQJ+mPXedFQf+OtTf2SYqUln7eAfEqENL2FGy42tE9WWUYzRrKHCLp4n2+BQNzQI1TR7cecFn/0YW4oCvcjV741DMPgpm9ItFgnStTyRM0LXFA5pw2VIOXlkbHsijVrZwGV4HKaKRUAzTPJx4bxP1Knbenj6UDdmD1IrYP0BfoAUrg==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(8676002)(4326008)(9786002)(70586007)(70206006)(8936002)(54906003)(6666004)(36860700001)(966005)(5660300002)(426003)(47076005)(40460700003)(316002)(508600001)(7696005)(110136005)(26005)(186003)(82310400004)(356005)(7416002)(2616005)(1076003)(83380400001)(7636003)(107886003)(336012)(36756003)(2906002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 17:48:58.7153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57d89c4d-539c-42f7-1716-08d9ebf47345
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0031.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB8150
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
---
 .../bindings/net/can/xilinx_can.txt           |  61 -------
 .../bindings/net/can/xilinx_can.yaml          | 160 ++++++++++++++++++
 2 files changed, 160 insertions(+), 61 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.yaml

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
diff --git a/Documentation/devicetree/bindings/net/can/xilinx_can.yaml b/Documentation/devicetree/bindings/net/can/xilinx_can.yaml
new file mode 100644
index 000000000000..50ff9b40fe87
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/xilinx_can.yaml
@@ -0,0 +1,160 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/can/xilinx_can.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title:
+  Xilinx Axi CAN/Zynq CANPS controller Binding
+
+maintainers:
+  - Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
+
+properties:
+  compatible:
+    oneOf:
+      - const: xlnx,zynq-can-1.0
+        description: For Zynq CAN controller
+      - const: xlnx,axi-can-1.00.a
+        description: For Axi CAN controller
+      - const: xlnx,canfd-1.0
+        description: For CAN FD controller
+      - const: xlnx,canfd-2.0
+        description: For CAN FD 2.0 controller
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    description: |
+      CAN functional clock phandle
+    maxItems: 2
+
+  tx-fifo-depth:
+    description: |
+      CAN Tx fifo depth (Zynq, Axi CAN).
+
+  rx-fifo-depth:
+    description: |
+      CAN Rx fifo depth (Zynq, Axi CAN, CAN FD in sequential Rx mode)
+
+  tx-mailbox-count:
+    description: |
+      CAN Tx mailbox buffer count (CAN FD)
+
+  rx-mailbox-count:
+    description: |
+      CAN Rx mailbox buffer count (CAN FD in mailbox Rx  mode)
+
+  clock-names:
+    maxItems: 2
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
+            const: xlnx,zynq-can-1.0
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
+            const: xlnx,axi-can-1.00.a
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
+            anyOf:
+              - const: xlnx,canfd-1.0
+              - const: xlnx,canfd-2.0
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
+    zynq_can_0: can@e0008000 {
+        compatible = "xlnx,zynq-can-1.0";
+        clocks = <&clkc 19>, <&clkc 36>;
+        clock-names = "can_clk", "pclk";
+        reg = <0xe0008000 0x1000>;
+        interrupts = <0 28 4>;
+        interrupt-parent = <&intc>;
+        tx-fifo-depth = <0x40>;
+        rx-fifo-depth = <0x40>;
+    };
+  - |
+    axi_can_0: can@40000000 {
+        compatible = "xlnx,axi-can-1.00.a";
+        clocks = <&clkc 0>, <&clkc 1>;
+        clock-names = "can_clk","s_axi_aclk" ;
+        reg = <0x40000000 0x10000>;
+        interrupt-parent = <&intc>;
+        interrupts = <0 59 1>;
+        tx-fifo-depth = <0x40>;
+        rx-fifo-depth = <0x40>;
+    };
+  - |
+    canfd_0: can@40000000 {
+        compatible = "xlnx,canfd-1.0";
+        clocks = <&clkc 0>, <&clkc 1>;
+        clock-names = "can_clk", "s_axi_aclk";
+        reg = <0x40000000 0x2000>;
+        interrupt-parent = <&intc>;
+        interrupts = <0 59 1>;
+        tx-mailbox-count = <0x20>;
+        rx-fifo-depth = <0x20>;
+    };
+  - |
+    canfd_1: can@ff060000 {
+        compatible = "xlnx,canfd-2.0";
+        clocks = <&clkc 0>, <&clkc 1>;
+        clock-names = "can_clk", "s_axi_aclk";
+        reg = <0xff060000 0x6000>;
+        interrupt-parent = <&intc>;
+        interrupts = <0 59 1>;
+        tx-mailbox-count = <0x20>;
+        rx-fifo-depth = <0x40>;
+    };
-- 
2.17.1

