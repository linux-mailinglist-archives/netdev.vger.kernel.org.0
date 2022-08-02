Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2638587AEA
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 12:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbiHBKoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 06:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbiHBKn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 06:43:59 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2060.outbound.protection.outlook.com [40.107.100.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846A722539;
        Tue,  2 Aug 2022 03:43:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TsGQIXLvRsTQLV0wZKa12wAr7ULvDtmorSrZT5x1sZis3UoCyDZS1l1/X5KT11wQqmsB+TEUm7hXtFoLVhXMf68+FrxGrg40t/s7JHJ9lW1ZfHrI/gJgtInnPJKo9A2gS2HC3XM7VpmPkJGXDfzhQi8Ku3VrFh5LS5brqpS3rb6HbXUpYS/rFz5tceB2W8KqmASrEVziPgWW8TXr23zAHG6/hd0MHeO5H3leJ08TXz5PrvM9Ai14OD3GB0lhgzl2GaTnewXSvkCEnIMEv16yqWK+28YexL/PIGQK6XTyYmiwxJ1l5bRsbK8li0Nq4uGj86A3zNZ+5oXo336MPUQbdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e8jGniR/wuHhyuYjd0VjgYkAhaOr9fqVOzr0MU9A/bU=;
 b=EwPGb3amtGuLXvInrgGNPN172GDPbOSW8N9pz/EKAIyyXbn6A5UNrjaaNk2Ub7Av4GAT0eofIWTQsn7VBnsGCC12KujgGSKyeaWDNeiXvwpkLzFJfMwyGw2lZw0rCkqMDnCVtLXQj3KfiGlY6+Ei3vjbRd6xX2h1p+LtpaIFx9q6+Khb7YaTmy6eqeuRgk/xbN3ORkqMmmEeQ//8DSjkfqXk8ylMu34DRGIG3UzVwshSf02+pAKTkHgS9RtT3pG7NxdRzCuyeowxt7LNjILtbur0UJwRZj6h5feh/923W7D2goXF8CG8pZD7U6f/29Wr3RTPWuKXto51f7RXTBo7Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e8jGniR/wuHhyuYjd0VjgYkAhaOr9fqVOzr0MU9A/bU=;
 b=Sra0HThkJLm3ETYwQQH5Mu+QY02r+tcfE6sKgwLKrXe5GChNxhrR/neAy82Z6orJG3n3nPxBvofx971hkoSWjmHfjx3ugD08npc75xDyg9EelIRRve2jSku8dkNJREI4YFvZzjsNxFsTykpMGeP94d0nzE+wl47mddq4jVHA4n0=
Received: from DM6PR18CA0003.namprd18.prod.outlook.com (2603:10b6:5:15b::16)
 by CY4PR0201MB3539.namprd02.prod.outlook.com (2603:10b6:910:94::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Tue, 2 Aug
 2022 10:43:56 +0000
Received: from DM3NAM02FT061.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::25) by DM6PR18CA0003.outlook.office365.com
 (2603:10b6:5:15b::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12 via Frontend
 Transport; Tue, 2 Aug 2022 10:43:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT061.mail.protection.outlook.com (10.13.4.230) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Tue, 2 Aug 2022 10:43:55 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 2 Aug 2022 03:43:55 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 2 Aug 2022 03:43:55 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 richardcochran@gmail.com,
 claudiu.beznea@microchip.com,
 andrei.pistirica@microchip.com,
 kuba@kernel.org,
 edumazet@google.com,
 pabeni@redhat.com,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com,
 michal.simek@amd.com,
 harini.katakam@amd.com,
 radhey.shyam.pandey@amd.com
Received: from [10.140.6.13] (port=38092 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1oIpNT-0004qa-3e; Tue, 02 Aug 2022 03:43:55 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <michal.simek@amd.com>,
        <harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [PATCH 1/2] net: macb: Enable PTP unicast
Date:   Tue, 2 Aug 2022 16:13:45 +0530
Message-ID: <20220802104346.29335-2-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220802104346.29335-1-harini.katakam@xilinx.com>
References: <20220802104346.29335-1-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 296306ce-697f-40fa-6923-08da7473e644
X-MS-TrafficTypeDiagnostic: CY4PR0201MB3539:EE_
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 56EnZtgYXcJhM2n+Q/v+B1DEmx/erz4uYAHciiqHq7uwo+RZzAjAZyAZWvlYLujqIGLw4YXfMj6gONBO201gP6m/kLsbL2zGY59tL+rFp0wxitn8kfL+WIpJSUsdB99FjxVaKQOHnzDBS7c2otS2V9jY/wns6glPGtR6PmpX56jkdxb3O1YPDTFDiyKu8cFIrpiX09GYPNLXAChWvUJ9fs9TwHB6gwlKg9ALDzn1Ma0nh+TY5wcNKZcQPYUEJ750fW1yDGVGWKieNzQjYBOjTSAYuerfOwkXU3O39h9EIPmzdibRY9l8XTcCLSS8/8+fWI6N3H9EZfzCywqUhO/E+VJ3Qb5dqkH+f/C9b2MKS/T8d0xi7Mg6FSZzEHENDH/Pr9e7YkIH1z92CaaR5FbIHZ2eWnSwjmHh56iuVLA8YgfTBsJCnWJ6o8K2qL2egTxzIjTxyrQOeRbYSiJS14zWu7Hi7mv09V1sNvXPe0ZSR/uuhwyAWen1JxxqDq0gHh/5asZTDXwedDfXBDhaQwSHT8dW1ZDFHb653XTd+PidEZvQ4uAKfdcBaQiZ+Hyr21jOTgvtE0S0aAQC7Liy7QAXQUvbrq9y2XcvjwLmFLVyU+RNHSxlYFuGzoE113Y4rm1xzoSQJ7TGuDJw3qSkCN4RYGliXZcW5/ubxApnZWIoCDPrjtmP0vmBQFw9cfUR6cfs76Z5hXO40cqkRUsTxcoBSNFhdydqE9OmImVfW1L+YZLT73uZRfOo8Zx5h9iCh6EAG7pHyIB8fSEEHQK6lI3VzVJgb5ewLiVIhtDZoIfwg9/zMOth71J61Vl7+WRf4WcMWZY5AmoeaZs4vegemWjPpA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(376002)(346002)(46966006)(40470700004)(36840700001)(44832011)(83380400001)(1076003)(2616005)(426003)(36860700001)(336012)(186003)(47076005)(9786002)(8936002)(36756003)(2906002)(8676002)(7416002)(5660300002)(4326008)(70206006)(70586007)(40480700001)(82310400005)(54906003)(478600001)(110136005)(41300700001)(7696005)(6666004)(26005)(40460700003)(82740400003)(316002)(7636003)(356005)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 10:43:55.8713
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 296306ce-697f-40fa-6923-08da7473e644
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT061.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0201MB3539
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
Added check for gem_has_ptp as per Claudiu's comments.

 drivers/net/ethernet/cadence/macb.h      |  4 ++++
 drivers/net/ethernet/cadence/macb_main.c | 13 ++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 9c410f93a103..1aa578c1ca4a 100644
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
index 494fe961a49d..4699699a1593 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -287,6 +287,13 @@ static void macb_set_hwaddr(struct macb *bp)
 	top = cpu_to_le16(*((u16 *)(bp->dev->dev_addr + 4)));
 	macb_or_gem_writel(bp, SA1T, top);
 
+#ifdef CONFIG_MACB_USE_HWSTAMP
+	if (gem_has_ptp(bp)) {
+		gem_writel(bp, RXPTPUNI, bottom);
+		gem_writel(bp, TXPTPUNI, bottom);
+	}
+#endif
+
 	/* Clear unused address register sets */
 	macb_or_gem_writel(bp, SA2B, 0);
 	macb_or_gem_writel(bp, SA2T, 0);
@@ -720,7 +727,11 @@ static void macb_mac_link_up(struct phylink_config *config,
 
 	spin_unlock_irqrestore(&bp->lock, flags);
 
-	/* Enable Rx and Tx */
+	/* Enable Rx and Tx; Enable PTP unicast */
+#ifdef CONFIG_MACB_USE_HWSTAMP
+	if (gem_has_ptp(bp))
+		macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(PTPUNI));
+#endif
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE));
 
 	netif_tx_wake_all_queues(ndev);
-- 
2.17.1

