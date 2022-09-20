Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C315BDCC2
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 07:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiITF5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 01:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiITF5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 01:57:30 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4728E40BF1;
        Mon, 19 Sep 2022 22:57:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8k4xeCNH3r90B5pFRN7ZJsvtigg7N2j5bZZS35ZYgW0xB9A46rVb6FO+bItAe2Ve8Xafd0MPpHV6f6t+sx7Q9xMnOnRg9wETn3l0uFtYO8zawcNzdYQ3SxpNFWZCCoclvf3ogQ4cb3yE88KxFDs/K3AJuMkHzuZQ2KVYbr2bb9Mtpc4fvM5aMN6QXkTTYaQNiw+LS2Ir+RiHH0ab0zEK8XT58IxWDIanm3oRfoHR9PkYWfDABcP8KIGnsqbiPiscutgWwNmU0f1iRMevdyVxYTjEG+YfCkAMonZsjKOtJuIbHveVDtVcJc3kJ8Q18CzUoXAfIdnWAkeAIQBJXbTUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bHgvPnz3Sp65Mu1rF+/vhYuvzPDcPXC+UgxBzZPggYQ=;
 b=S9IR60ZWXC+8FekYQd09ukwO03XbV5jEobpYK+3q1bVP7cbSP1/VUkWcw/2bk4/K6yTEZnse6y33wEqyhHZiR2Qi5PZgiCbg/GgH1pe22YRznnej3DOx7Qp8V9ckUOZdDg4NbQ2Kwf/JrCdwfXKF9v2LQ7f8yqhMTK9WlTmN3OpFNYfJV7I0N6reg2aGMcJtUqVVEgu+17ZSsZyPAHb9jD6pfnV3KdDJQmsfz4amMnDspWMj85mjwnPNNb7vbXe6BrFIY0CYe7rj05KDXPsdlDtdT+xSrHam6+dksFeiTJfsdsUyCmCXsDCIgD9Iuq9P3ursLyiu3HDk04f/KFigNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bHgvPnz3Sp65Mu1rF+/vhYuvzPDcPXC+UgxBzZPggYQ=;
 b=mpzZeYoiM433iKtqN+sY+n0NBsiyE9QpDq/ML0LOAShPXlUhD6sTUEINy2iccs1g8a6bypjHXl9q2Y8GDLJ4TPbibWSSxFgd0KG12x2YuGezgP4fgUw26LLZeV/wNBmtWV1oLc0YubuBH1fw0S/0Faof/SKVBNND+Enb8efkrx0=
Received: from BN9PR03CA0689.namprd03.prod.outlook.com (2603:10b6:408:10e::34)
 by PH7PR12MB6717.namprd12.prod.outlook.com (2603:10b6:510:1b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 05:57:24 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10e:cafe::10) by BN9PR03CA0689.outlook.office365.com
 (2603:10b6:408:10e::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21 via Frontend
 Transport; Tue, 20 Sep 2022 05:57:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5632.12 via Frontend Transport; Tue, 20 Sep 2022 05:57:23 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 20 Sep
 2022 00:57:23 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 19 Sep
 2022 22:57:22 -0700
Received: from xhdswatia40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Tue, 20 Sep 2022 00:57:17 -0500
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
Subject: [RFC V2 PATCH 2/3] dt-bindings: net: xilinx_axienet: Introduce dmaengine binding support
Date:   Tue, 20 Sep 2022 11:27:02 +0530
Message-ID: <20220920055703.13246-3-sarath.babu.naidu.gaddam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220920055703.13246-1-sarath.babu.naidu.gaddam@amd.com>
References: <20220920055703.13246-1-sarath.babu.naidu.gaddam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT032:EE_|PH7PR12MB6717:EE_
X-MS-Office365-Filtering-Correlation-Id: d02937eb-720a-4180-fc03-08da9accfd27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4fDYLdOTaGA7H4c6QMBKkqQCKAP2h4atdG+1Zo0WGflvNJ5QiclaU3be7S9/IcSgwV8n0eXfXh+j2HBMigWeAQFveCZdqDuC3AND7Sq15QhAAOiXdVI28TrIw5feKBYC2nfhDfMjInBcyCSiMiolG9dZif6TvaPi/DrEuIFwKuwf2Wxs4RGPlSbH5mmtdhpMJLUHnuw8dD2Kf5BcgfwtHXwHPoaf8m6sa0SGYLA9BAjWi2X7M5iZUZgY8kV8V57v3Xe5jw2AlyI/5EXhC6pfbCak1q24Q4Vm6iYv6XxjTesa92gnVhu4BVUET0UTULwJWgQpnrlCZFzh1BYKnpnaLEpvKMgEAWbfg42uei9FgWx232nxFRPPLWV/12GjUotDT17mh4qiu6KuzbzJ4mT7vNfAhd5KWKyVfNp70mgNxjVWUtKiaLBN9y1+qlkCXvq1MtteePANzvZ1Tgty6lJpDpPPUFdJy26HYXJ5Vk0zy31pnf7BBsXtYdIPsjjyfju8N+VX4roYOMZsLtLnS6ycAQztc1iFMNo/rbAFLdx36H32098ixncfb5KsMplSsxiaSqCFSKv6T4BEead4rnuFNccMZuqRIXAqlj5ZpBCih2qYfoSQXZa1VhJwsWmNWDSoWxlBcAWw1rh2Re7tVDu+ATt67ZhSGKG6lp9F5VQse9vvIjK22Vcyi1Fkz6STLFzNguAkvXVQb/K8SAdez2+0kYJFEotBU10q1qKN5qLJtcG41VvdZ7LMjfkJ51oT72aoNUV7Z7GUR+RoTALnMyl8pjQ2s2UT363BYFX1UlPD0keVJ4MdhoZZoBYQJ2emTlzw
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(2906002)(7416002)(8936002)(36756003)(81166007)(356005)(82740400003)(86362001)(47076005)(36860700001)(83380400001)(82310400005)(336012)(6666004)(426003)(2616005)(103116003)(26005)(186003)(40460700003)(70586007)(1076003)(478600001)(110136005)(5660300002)(4326008)(8676002)(70206006)(316002)(41300700001)(54906003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 05:57:23.6827
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d02937eb-720a-4180-fc03-08da9accfd27
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6717
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

The axiethernet driver will now use dmaengine framework to communicate
with dma controller IP instead of built-in dma programming sequence.

To request dma transmit and receive channels the axiethernet driver uses
generic dmas, dma-names properties. It deprecates axistream-connected
property, remove axidma reg and interrupt properties from the ethernet
node. Just to highlight that these DT changes are not backward compatible
due to major driver restructuring/cleanup done in adopting the dmaengine
framework.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
---
Changes in V2:
- None.
---
 .../devicetree/bindings/net/xlnx,axiethernet.yaml  |   39 ++++++++++++--------
 1 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/xlnx,axiethernet.yaml b/Documentation/devicetree/bindings/net/xlnx,axiethernet.yaml
index 780edf3..1dc1719 100644
--- a/Documentation/devicetree/bindings/net/xlnx,axiethernet.yaml
+++ b/Documentation/devicetree/bindings/net/xlnx,axiethernet.yaml
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
 
@@ -109,6 +101,7 @@ properties:
       for the AXI DMA controller used by this device. If this is specified,
       the DMA-related resources from that device (DMA registers and DMA
       TX/RX interrupts) rather than this one will be used.
+    deprecated: true
 
   mdio: true
 
@@ -118,12 +111,24 @@ properties:
       and "phy-handle" should point to an external PHY if exists.
     $ref: /schemas/types.yaml#/definitions/phandle
 
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
 required:
   - compatible
   - interrupts
   - reg
   - xlnx,rxmem
   - phy-handle
+  - dmas
+  - dma-names
 
 additionalProperties: false
 
@@ -132,11 +137,13 @@ examples:
     axi_ethernet_eth: ethernet@40c00000 {
       compatible = "xlnx,axi-ethernet-1.00.a";
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
1.7.1

