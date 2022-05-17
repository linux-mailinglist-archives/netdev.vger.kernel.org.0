Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1DD529AE3
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241453AbiEQHdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237596AbiEQHd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:33:29 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2080.outbound.protection.outlook.com [40.107.100.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A387C4838B;
        Tue, 17 May 2022 00:33:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BD6LfDTrxGCoazV8HhWK84l3a+p5VHi1FlII+TS2aYhA7SeQKiDctNtWcXqMP7TyYox2UpYDe50pQdIMFxiewJNLZEJ1AW52iMsrFPOM4yfShN+R8rcmwaeXkYYh9o+5UipGa0j2luHYntbB3EHL9+iolGrHajkw6femXZkDrjYckmJgcHcah7oMSXxc5Xg6uqv+Px/78WhmBAKnJjtokRAbp/wl/ue/fBLevle2OobIK2OtRGQS3Ovgvq0vjzk0ukuMJYgR4we6rucz00DZB+GmUDzVDyss5SD9PkmlAmIMf/qfpQHLw3hLMBsuYOdy7SxF1qLp6VuW7jcxQ4E4Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hS0yfoKTWVc5n57rM+isadaiNORc71iaMto9Cq2lWjg=;
 b=nYWhO04NBuK8fFKE1Ok2L5q1guyavS6wjglaKrUMOnk9zDWSBFPr4qmamSdboTlHd7mXJ+Qr9HlypiR/iqowyz4Z33Y40yDR0iuE9A7uFuzIXPO1Ejd2EmKRGmX7dMzl1MwipvDxAIEX8BltxGac1V8Mkf8Rl2h2e+h27LGrugU2ffenAsa+1KIqYUx40/xjhgbqQETJS0HbVkwOxtIw4efO8N/FnWtXpcvd821G/NEyxGnIZxuQQ4cBOIETHPmoSOvqjNi6ySp5hOHQliqHe6as+GZsi4ljZVLtSk6sAqwOcaDUF1MlNH/DdGXHvz3uXM/JgOHqAgO+IrniDdoZjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hS0yfoKTWVc5n57rM+isadaiNORc71iaMto9Cq2lWjg=;
 b=XT2Mp/0oqu/WZkbbet5M3NtRa9nzSAzp8sSMfrv3iWnGKWoS/Mpo0qYUApXHDYCRRqqmqFyhtsbqqkS2ogNpffAw1XiL1OnxsOfiA1kBNhuX9s8SvYG1DhwEWYYgOyAUySqlvtaAd9q4knK7eq7mBfknUC89RlpYvw9haFrpwkM=
Received: from DS7PR05CA0002.namprd05.prod.outlook.com (2603:10b6:5:3b9::7) by
 DM6PR02MB6731.namprd02.prod.outlook.com (2603:10b6:5:222::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.14; Tue, 17 May 2022 07:33:22 +0000
Received: from DM3NAM02FT027.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::8) by DS7PR05CA0002.outlook.office365.com
 (2603:10b6:5:3b9::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13 via Frontend
 Transport; Tue, 17 May 2022 07:33:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT027.mail.protection.outlook.com (10.13.5.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 07:33:22 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 17 May 2022 00:33:10 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 17 May 2022 00:33:10 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 richardcochran@gmail.com,
 claudiu.beznea@microchip.com,
 kuba@kernel.org,
 pabeni@redhat.com,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com
Received: from [10.140.6.13] (port=40442 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1nqrhe-000GAX-5C; Tue, 17 May 2022 00:33:10 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH 2/3] net: macb: Enable PTP unicast
Date:   Tue, 17 May 2022 13:02:58 +0530
Message-ID: <20220517073259.23476-3-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220517073259.23476-1-harini.katakam@xilinx.com>
References: <20220517073259.23476-1-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ed68958-a3fc-4f5f-6d8e-08da37d78599
X-MS-TrafficTypeDiagnostic: DM6PR02MB6731:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB673106A0D988B58DD0BFE51DC9CE9@DM6PR02MB6731.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hleKh0og5s5o0gs8S24CnxwYgs75yb528vpOeuzQSffawDC2xUoLF4pB1/eItgXgPiVT2r8mV+YMPIYgyobsnpOnNU1HCMTUgH+V3EIvZZaUt4mJhqLjHX7mczosNqQ6xSrvSYMjUYTPgb1fI/RlyiqRmlmlGSQ0PjxjeLBQO1msIIhyUGuoEMeLFeBuCytvF+ry3raGr373ViH7LuNpiLRcj727wdUo5I/RiCltUdSEhFb7EFoUYq/cu7Bwt5GXi7dh8lz55wxCEjgLz9cLMe95HojWwTahdTS7xZd37MraFQmBb8qblDTXLtcIPhNjWDNKZubPCJNSLyPCbWtQEkFNHiuXQZIqcB5tKkLwWT+irHnWZdbgPwmDIueeRUwffYZDtAjH727CArP4A4IZVL2tFix2UqM+Xr/UgwkqbBeTecYW2o2oey6XvaGLU8EiItbPnsTDd6GdLwwW2OoDdbYHWzA6rE8vZHEV63iO4eOd9IJPnSIp/VxpKSD82hH4YzfsRoytZPkZ8ED5QGJHC8yqA0EGCwU/PfunHC++CAr4NZzoVrre8o3AnhNWgiaXGe+sNJ9xtC6Bnb211mOvaEf03G+lupwl4stFPx5JBB2p3DmKaOGD/Qk+KSvcuSyfFf6TBSox4X5pp9ls83v93O7zdC/vScCiPtwNkaU+gdb0uSgX9qoPCtZzkkLZzGa0Uby1HThYhp7dztYcLf0j+w==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(7636003)(6666004)(2906002)(54906003)(426003)(356005)(336012)(47076005)(186003)(1076003)(82310400005)(316002)(7696005)(110136005)(36860700001)(83380400001)(9786002)(40460700003)(5660300002)(508600001)(44832011)(70206006)(70586007)(4326008)(8936002)(8676002)(26005)(36756003)(2616005)(107886003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 07:33:22.4330
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ed68958-a3fc-4f5f-6d8e-08da37d78599
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT027.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6731
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable transmission and reception of PTP unicast packets by
updating PTP unicast config bit and setting current HW mac
address as allowed address in PTP unicast filter registers.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/cadence/macb.h      | 4 ++++
 drivers/net/ethernet/cadence/macb_main.c | 7 +++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 7ca077b65eaa..d245fd78ec51 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -95,6 +95,8 @@
 #define GEM_SA4B		0x00A0 /* Specific4 Bottom */
 #define GEM_SA4T		0x00A4 /* Specific4 Top */
 #define GEM_WOL			0x00b8 /* Wake on LAN */
+#define GEM_RXPTPUNI		0x00D4 /* PTP RX Unicast address */
+#define GEM_TXPTPUNI		0x00D8 /* PTP TX Unicast address */
 #define GEM_EFTSH		0x00e8 /* PTP Event Frame Transmitted Seconds Register 47:32 */
 #define GEM_EFRSH		0x00ec /* PTP Event Frame Received Seconds Register 47:32 */
 #define GEM_PEFTSH		0x00f0 /* PTP Peer Event Frame Transmitted Seconds Register 47:32 */
@@ -245,6 +247,8 @@
 #define MACB_TZQ_OFFSET		12 /* Transmit zero quantum pause frame */
 #define MACB_TZQ_SIZE		1
 #define MACB_SRTSM_OFFSET	15 /* Store Receive Timestamp to Memory */
+#define MACB_PTPUNI_OFFSET	20 /* PTP Unicast packet enable */
+#define MACB_PTPUNI_SIZE	1
 #define MACB_OSSMODE_OFFSET	24 /* Enable One Step Synchro Mode */
 #define MACB_OSSMODE_SIZE	1
 #define MACB_MIIONRGMII_OFFSET	28 /* MII Usage on RGMII Interface */
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index e23a03e8badf..19276583811e 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -290,6 +290,9 @@ static void macb_set_hwaddr(struct macb *bp)
 	top = cpu_to_le16(*((u16 *)(bp->dev->dev_addr + 4)));
 	macb_or_gem_writel(bp, SA1T, top);
 
+	gem_writel(bp, RXPTPUNI, bottom);
+	gem_writel(bp, TXPTPUNI, bottom);
+
 	/* Clear unused address register sets */
 	macb_or_gem_writel(bp, SA2B, 0);
 	macb_or_gem_writel(bp, SA2T, 0);
@@ -723,8 +726,8 @@ static void macb_mac_link_up(struct phylink_config *config,
 
 	spin_unlock_irqrestore(&bp->lock, flags);
 
-	/* Enable Rx and Tx */
-	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE));
+	/* Enable Rx and Tx; Enable PTP unicast */
+	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE) | MACB_BIT(PTPUNI));
 
 	netif_tx_wake_all_queues(ndev);
 }
-- 
2.17.1

