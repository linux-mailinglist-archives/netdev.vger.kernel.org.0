Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24CE14ADDA7
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381853AbiBHPwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376280AbiBHPwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:52:23 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84841C061579;
        Tue,  8 Feb 2022 07:52:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeUvhhK2ZBlyK7eJ4F2r4khfKx++K9lRMWF2G7xYa9BiEiIpILU+yfpwsATXElATq1hP4P8Oka7M/HnEkjLvBw/Mb+2UfPUQ4kQiHY+S/PL65B66YQpiHnV2E4M/7ZgNuPCwcB9hfLS14FpuTduY5CeWuJ4Lmu98PUz9hQ5fskoI08QmQel//VYkwzd/jaQ7H3rhLUop4u0QXjgHNHSTfIKe5dAEiDZ9AAWhfEyQbsFhf7wsbiofhhC+yzIQak1MmN+rQY5cpIc09Ils4bVExoclkLyYDY7nyZ7IW86aO7stjSE8MOXuC8o+V9vuq7t1KNTgUpwPd3Df2qCPBqW5Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VcsVLRBAK5JKotjr/PZnpfox5eHfXvmkxZKbc32faXM=;
 b=nAhb7aSQ9/vsCrApodx1uN4SSpQSo45KrAX22eV423aCMEQMdlphDJH9/MBJyoCRCEQr4IxsTHBGP4i66Y8YpPmVHTqh06PG14ncysOuAQ30Jh+VmZGhErARbIMUNEGRWuaRiXDFeNMwT5qmxQPpsvpQ3YRLjqtJ8oH2I7FjHPvcyCEQYStpxOh/guJXr2nOjPBDR+Fh87pvJW0PRuhJGwbY/6A99N9HWs3QM8wfrovrb4LUuHP5S8kdIY4DMIbY7kuF4BmSClRY1j/oYXvM0RnWyyjp2qnkThD4hmEo+BtyhxheQ+l9cpevv21DLXtNhLUOFULy8XUwq7XYsLlnKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=grandegger.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VcsVLRBAK5JKotjr/PZnpfox5eHfXvmkxZKbc32faXM=;
 b=jp1Db41dNoJh7k07Hp7ZHe1bAynsuC8ZzkBn600Gj/qaC0vRdZ3AqUpi+vn5nP7aYgNwua51iP1h+OYpAE5rL1tqZ670KDE3jzErBNhtlfN/Tbfmj9ykVJWt/7vdWMItqpeZboA3dD2YYRFIXgTWZC2gW5VkwLmEI3MxtMQJFz8=
Received: from SN7PR18CA0012.namprd18.prod.outlook.com (2603:10b6:806:f3::35)
 by BYAPR02MB4869.namprd02.prod.outlook.com (2603:10b6:a03:45::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 15:52:19 +0000
Received: from SN1NAM02FT0040.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:f3:cafe::ac) by SN7PR18CA0012.outlook.office365.com
 (2603:10b6:806:f3::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Tue, 8 Feb 2022 15:52:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0040.mail.protection.outlook.com (10.97.5.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4951.12 via Frontend Transport; Tue, 8 Feb 2022 15:52:19 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 8 Feb 2022 07:52:15 -0800
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 8 Feb 2022 07:52:15 -0800
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
Received: from [10.140.6.18] (port=57654 helo=xhdlakshmis40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <amit.kumar-mahapatra@xilinx.com>)
        id 1nHSmt-000Bhv-1m; Tue, 08 Feb 2022 07:52:15 -0800
From:   Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
To:     <appana.durga.rao@xilinx.com>, <wg@grandegger.com>,
        <mkl@pengutronix.de>, <davem@davemloft.net>, <kuba@kernel.org>,
        <robh+dt@kernel.org>
CC:     <git@xilinx.com>, <naga.sureshkumar.relli@xilinx.com>,
        <michal.simek@xilinx.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Amit Kumar Mahapatra" <amit.kumar-mahapatra@xilinx.com>
Subject: [PATCH] dt-bindings: can: xilinx_can: Convert Xilinx CAN binding to YAML
Date:   Tue, 8 Feb 2022 21:22:09 +0530
Message-ID: <20220208155209.25926-1-amit.kumar-mahapatra@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cb79005-e24b-4a6d-ed4b-08d9eb1afcb8
X-MS-TrafficTypeDiagnostic: BYAPR02MB4869:EE_
X-Microsoft-Antispam-PRVS: <BYAPR02MB4869CA4545FE38346799D64CBA2D9@BYAPR02MB4869.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a3J0SJut709RW7Kvsik48icIJEZz227eKWrDKGVvl9K8KaPjQ70afMQU56jsTSvBqdNi/3M2ENDWDVRpoO0/K1oeouEkbWnBKs1qvW7J2UNwD+43u5YKkYDDlG1E1pUdvcMg0aUNIgsU4cjAEfPMC+jqyK3pCZchpUmelLEaF0kd0bovY/zbdb4xcXkm2UsXhXLTQ6hax5djoH3guWxvSWbbuZuwvITwRdguT6Fzv5M1j/Q8wYPQFNX5FJab0vFL2zOdSFd66gVjH7oOww96l8tcUslS5Wy84YxGAFvq/7d5/iS0ZW16XMWJRVAEbpJC1we4IhRdBLNrEOfInPmbF0qZzCPEq6YuU3KLYuOaGnagSCH7VU6jg+PXQUmYai/68HELAj6QdFXsnA/iJVdDolT/1UmkysgOzgnaaly/x1mx+OoOxAKSdPL4vTr4YMM6E1F4OoJ81F75S6Wf+/U74Bprmhx9yAm7OvScUDuOsDuuhl7wqqL4iPUewjPEdqsIOaK3fSKQBsunXnMMxzcWw8mdhpwkcGY/BAAzeikPPP8zqkUd5oNkvRCjSGnmnXNhEksJTlWyZIslCZ/1D5HvkW5QqTm2ZXGW+EvtdK7LIVRx0iyKi3bzonIR4e9PIiV72y5WLoOI/Fytpl0NRK5gG3pK6htD+QbdSKJLDY8sOV2HdnCjOtRJ+2LwcGkK5wmmF247IL8S4JULprVKOFzEyMzDcoVPGQTNCNj3YXxsEZTKoBhlFeeFWlwvH65UnYvwxgRU++NilPFWwsjua/CGGj0Ezsu+ZaylS9cVwQqX8Tc=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(4326008)(508600001)(8936002)(70206006)(36860700001)(316002)(9786002)(966005)(70586007)(426003)(54906003)(47076005)(2906002)(8676002)(110136005)(82310400004)(36756003)(7416002)(7636003)(336012)(356005)(7696005)(5660300002)(107886003)(2616005)(1076003)(26005)(186003)(6666004)(83380400001)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 15:52:19.0353
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb79005-e24b-4a6d-ed4b-08d9eb1afcb8
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0040.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4869
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
---
 .../bindings/net/can/xilinx_can.txt           |  61 --------
 .../bindings/net/can/xilinx_can.yaml          | 146 ++++++++++++++++++
 2 files changed, 146 insertions(+), 61 deletions(-)
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
index 000000000000..cdf2e4a20662
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/xilinx_can.yaml
@@ -0,0 +1,146 @@
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
+            const: xlnx,canfd-1.0
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
+    can@e0008000 {
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
+    axi-can@40000000 {
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
+    canfd@40000000 {
+        compatible = "xlnx,canfd-1.0";
+        clocks = <&clkc 0>, <&clkc 1>;
+        clock-names = "can_clk", "s_axi_aclk";
+        reg = <0x40000000 0x2000>;
+        interrupt-parent = <&intc>;
+        interrupts = <0 59 1>;
+        tx-mailbox-count = <0x20>;
+        rx-fifo-depth = <0x20>;
+    };
-- 
2.17.1

