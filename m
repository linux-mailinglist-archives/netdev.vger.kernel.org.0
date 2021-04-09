Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03DD135A576
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhDISO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:14:27 -0400
Received: from mail-bn8nam08on2078.outbound.protection.outlook.com ([40.107.100.78]:27008
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234690AbhDISOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 14:14:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSAf5WKIsaNyCYqs3euCcSsGgeUbBKjyp8YNSVnKXUxFTz0nD2QaYAhUBld0jOXjuXzYiy9YZpABtj15mH5LTwo/mvhEFGMGbWjxMXU5Yl3KzD7urNmsq905rGSNizqES+PwKE6RWOHA8tSbxVOyYu+vbIaTF7eJAQw43tQpDrjF/YhRH/St/NZHV3GSYPdHrYj4i0pXMP3PTAMfb7xg68tjTjQ7w0zenx+v5upqybF+0Sg6FwpZwGDXkuhD2iVMD8Q+40qhfjLIra4ru+78PxGbbrEySPr299gAtVtTv1IBexvG3pVLfBFgWbq6lKSy77mx2OSgxFtwXFXegQgnyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9KW4Mi2FWsAHgvLd3fZurWlR5nynOKP42kiI6xYI7w=;
 b=YWFKI/y7WBW5yyAWK6d4TC3f0n02dz5LcNTgzstXGi8TiyHBex2KYPaxzeodzm12hRbqd7waTlnAPsGcuOprFX5jEGplKEcQAhxCELUccgdXcKjmKqup6SMD1RNvAb97wCaM6wQ9NIafHUttI6gUrT+D4tuwbCc9LR1SpMyeNabHJYmm85ZIszGchbhVMdigi13bA3WNBzcrk3tUnmvTz5T7N1bCk1VBikABUlF93HUmv/EP37JkCWaQiYKj2E6J5rLN6y+8eRIML8xFK3BXTQKhH4NPe6kM+P68PNv6EGfHxz7Lw9EFWyv/64lvyiZpOF7dbTvMHjtAh6eKF135HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9KW4Mi2FWsAHgvLd3fZurWlR5nynOKP42kiI6xYI7w=;
 b=CLEbejNZXaNrxXBP9WN+eYlwdQ5SNmkjrR/tSTV7qldrpMNUHELrBo5m/zGXwn+/SUCuL0IWX/EXavbLfz29MFcxACAPU28NqqdRXvB8TZaq7LqlgU66Thc7Ap0m+5455Z60ESCWIRrrfNUOM5VAotBxD5VN3Rn4Tdvl8FJwKyk=
Received: from BL1PR13CA0223.namprd13.prod.outlook.com (2603:10b6:208:2bf::18)
 by DM6PR02MB4185.namprd02.prod.outlook.com (2603:10b6:5:a3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 9 Apr
 2021 18:14:06 +0000
Received: from BL2NAM02FT012.eop-nam02.prod.protection.outlook.com
 (2603:10b6:208:2bf:cafe::28) by BL1PR13CA0223.outlook.office365.com
 (2603:10b6:208:2bf::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.8 via Frontend
 Transport; Fri, 9 Apr 2021 18:14:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BL2NAM02FT012.mail.protection.outlook.com (10.152.77.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 18:14:05 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 9 Apr 2021 11:13:44 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2106.2 via Frontend Transport; Fri, 9 Apr 2021 11:13:44 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 robh+dt@kernel.org,
 vkoul@kernel.org,
 linux-arm-kernel@lists.infradead.org,
 devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.106] (port=33563 helo=xhdvnc125.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1lUvdX-0003DD-0s; Fri, 09 Apr 2021 11:13:43 -0700
Received: by xhdvnc125.xilinx.com (Postfix, from userid 13245)
        id 24F6A121108; Fri,  9 Apr 2021 23:43:29 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <michal.simek@xilinx.com>, <vkoul@kernel.org>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [RFC PATCH 2/3] dt-bindings: net: xilinx_axienet: Introduce dmaengine binding support
Date:   Fri, 9 Apr 2021 23:43:21 +0530
Message-ID: <1617992002-38028-3-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1617992002-38028-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1617992002-38028-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7140eab-e305-4116-fe9a-08d8fb834302
X-MS-TrafficTypeDiagnostic: DM6PR02MB4185:
X-Microsoft-Antispam-PRVS: <DM6PR02MB4185F2B73D77472F5A77D7BEC7739@DM6PR02MB4185.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FCYvAj6C5Ao1R9kRnHQOZjscITwq3jnZnqys5Dsue+jyr2/MmrT02FrTgMzJPm6JYqQsWYoHZCiVYQxMi0LRHXITVLpDFskBFRdP5szFg+MhUWPj1HaGyaShwjbqzxgxbS4cjwjwgHdcC+TQ+gSiqqz81n6qmRNcongRB/OKKdlh0oY6W4H0A0lUFYNFwoistFWOqF9+DUFgT8dNYbvt2+Ps5PYUiNsJezPQfUWLNXf9TM7O+R+3e+wZgSO5BcwqJFtmFaCIDT0b3Uc2kZU08AE8jw/n7tcK3mzq/E9pOAli5fM6MOwF1QrpM+fOHquIEcYPTovBKyw3BCdoDFa4i+EuME7ZFbBK2e/Jx8fHGsHvcqFfQJIQfrNY6QovexvYpptqyZxPkVju2JXoS1iMUJo1NjmSY5lS3UJZvfVSqLJAyFbFRfbblKKazHBmpBG1vMnlrX5UxG9S0VwfX/bOZM6BsIv/3D8TjTvTvbTtYggBTqJkCT3vivTpNM1LXn0Ac2TQL2n4+GLlqkbtnbfmyfhWI6EhB2Uwx7A5pYRIakGzGXJFl+nC/WY4GZwzZRHL1/nmh/r+RDqhi8+Z2V+pu5QL7GpQIXQ7+PxjFu1VCGjaprmFpTgokVPwJCODh7njOppOjrtNJZMgTZWnxcjIwNBnNj+Snq08dSOb+9hht7qlAOs9RLNdRGTvetpCBqGK
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(46966006)(36840700001)(70586007)(47076005)(36860700001)(110136005)(316002)(82310400003)(2906002)(5660300002)(336012)(42186006)(6666004)(36906005)(83380400001)(70206006)(8936002)(8676002)(26005)(6266002)(107886003)(356005)(426003)(2616005)(54906003)(7636003)(478600001)(82740400003)(36756003)(4326008)(186003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 18:14:05.5143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7140eab-e305-4116-fe9a-08d8fb834302
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BL2NAM02FT012.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB4185
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The axiethernet driver will now use dmaengine framework to communicate
with dma controller IP instead of built-in dma programming sequence.

To request dma transmit and receive channels the axiethernet driver uses
generic dmas, dma-names properties. It deprecates axistream-connected
property, remove axidma reg and interrupt properties from the ethernet
node. Just to highlight that these DT changes are not backward compatible
due to major driver restructuring/cleanup done in adopting the dmaengine
framework.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 .../devicetree/bindings/net/xilinx_axienet.yaml    | 40 +++++++++++++---------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.yaml b/Documentation/devicetree/bindings/net/xilinx_axienet.yaml
index 6a00e03e8804..0ea3972fefef 100644
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.yaml
+++ b/Documentation/devicetree/bindings/net/xilinx_axienet.yaml
@@ -14,10 +14,8 @@ description: |
   offloading TX/RX checksum calculation off the processor.
 
   Management configuration is done through the AXI interface, while payload is
-  sent and received through means of an AXI DMA controller. This driver
-  includes the DMA driver code, so this driver is incompatible with AXI DMA
-  driver.
-
+  sent and received through means of an AXI DMA controller using dmaengine
+  framework.
 
 allOf:
   - $ref: "ethernet-controller.yaml#"
@@ -36,19 +34,13 @@ properties:
 
   reg:
     description:
-      Address and length of the IO space, as well as the address
-      and length of the AXI DMA controller IO space, unless
-      axistream-connected is specified, in which case the reg
-      attribute of the node referenced by it is used.
-    maxItems: 2
+      Address and length of the IO space.
+    maxItems: 1
 
   interrupts:
     description:
-      Can point to at most 3 interrupts. TX DMA, RX DMA, and optionally Ethernet
-      core. If axistream-connected is specified, the TX/RX DMA interrupts should
-      be on that node instead, and only the Ethernet core interrupt is optionally
-      specified here.
-    maxItems: 3
+      Ethernet core interrupt.
+    maxItems: 1
 
   phy-handle: true
 
@@ -109,15 +101,29 @@ properties:
       for the AXI DMA controller used by this device. If this is specified,
       the DMA-related resources from that device (DMA registers and DMA
       TX/RX interrupts) rather than this one will be used.
+    deprecated: true
 
   mdio: true
 
+  dmas:
+    items:
+      - description: TX DMA Channel phandle and DMA request line number
+      - description: RX DMA Channel phandle and DMA request line number
+
+  dma-names:
+    items:
+      - const: tx_chan0
+      - const: rx_chan0
+
+
 required:
   - compatible
   - reg
   - interrupts
   - xlnx,rxmem
   - phy-handle
+  - dmas
+  - dma-names
 
 additionalProperties: false
 
@@ -127,11 +133,13 @@ examples:
       compatible = "xlnx,axi-ethernet-1.00.a";
       device_type = "network";
       interrupt-parent = <&microblaze_0_axi_intc>;
-      interrupts = <2>, <0>, <1>;
+      interrupts = <1>;
       clock-names = "s_axi_lite_clk", "axis_clk", "ref_clk", "mgt_clk";
       clocks = <&axi_clk>, <&axi_clk>, <&pl_enet_ref_clk>, <&mgt_clk>;
       phy-mode = "mii";
-      reg = <0x40c00000 0x40000>,<0x50c00000 0x40000>;
+      reg = <0x40c00000 0x40000>;
+      dmas = <&xilinx_dma 0>, <&xilinx_dma 1>;
+      dma-names = "tx_chan0", "rx_chan0";
       xlnx,rxcsum = <0x2>;
       xlnx,rxmem = <0x800>;
       xlnx,txcsum = <0x2>;
-- 
2.7.4

