Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9596E6CA21A
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 13:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbjC0LHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 07:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjC0LHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 07:07:08 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C476546A6;
        Mon, 27 Mar 2023 04:06:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZyioYEVbB23iM7kdFMGQkNBFWCuZwnSYG1fwXjZXG5l2/AkgG5i6NXolHeF4Ubwb+x42/xhhzhJf049XeQprdKfd7r6WNBNpo+1Vp55rnk8fcAIQ8UY1bXVrAQKbAiMM4vuIoCM7ZsloOYsCZ4f7Iwmufi7lu8kNpln0YfUQNqxrKARMTVaRSpQyQiKdh25mcsSFVMqRkxDtFFtnouAuCWF3MdTQ6AN8ysAOvo9q8ge9PPbsvhDjxg8LKeHPpxAwX7beBAZYaRC8L96+LTc3gSgMKYzsvbNzEBa0NkyMPafQfcVCHMk32haYegbm+46ChDJpmk6lmbrdqDwaSmN1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PvEfM7eFDANdWGdIwIUHZ7Dn+qMTX0hyO3ElqEwHaEM=;
 b=ZlCS3rmI99JLBg3jRRILGtK/opDQpq9HmAEN5jlP7Wo5UlDlKs8kYKUgwxpngrMU2rkW83O0w0Nf409adUblKWuFfVGvUc26mNY9X9CuLM1+Ysg1qRinen02JxMMw+NN/9q6HSFu3WupVH3t3aPyM42Pi0pXum6GVyvmTTVbT1zpMZ18XLTSbcjzc9lFU9nWQBf+ytkO/kMY4q5oBkeMOMD5+L0Bc/VVt1Djoxbynxfzx12SDewneZ3xEiptfoS9St85sfKwMInxXJUzQ0B1tGci2R5Zbxzb+JKtAmEh4lhcq+gxmMONSQLqeM6FDjcUzvx+ypui4aerabtZMLTeuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvEfM7eFDANdWGdIwIUHZ7Dn+qMTX0hyO3ElqEwHaEM=;
 b=DyxZJaBKFydsHSo4L6DAFDXXkA1HPUsGTldWNlnopHFHYQxpzYZCGmP9fymqdO7U1kW6KydlL2+DjoeeByc2mvvYbZC9wSLDqUyty+lr0WeRssnBOcYSkfS9oir8KfAoVrCMdsruP78KXlc7cHwe67tazr75CnSkh9hzKh8AyEc=
Received: from BN0PR04CA0040.namprd04.prod.outlook.com (2603:10b6:408:e8::15)
 by CH0PR12MB5299.namprd12.prod.outlook.com (2603:10b6:610:d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 11:06:55 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::8e) by BN0PR04CA0040.outlook.office365.com
 (2603:10b6:408:e8::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.43 via Frontend
 Transport; Mon, 27 Mar 2023 11:06:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Mon, 27 Mar 2023 11:06:54 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 06:06:50 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 06:06:19 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Mon, 27 Mar 2023 06:06:15 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next v3 2/3] net: macb: Enable PTP unicast
Date:   Mon, 27 Mar 2023 16:36:06 +0530
Message-ID: <20230327110607.21964-3-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327110607.21964-1-harini.katakam@amd.com>
References: <20230327110607.21964-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT056:EE_|CH0PR12MB5299:EE_
X-MS-Office365-Filtering-Correlation-Id: 34799ebf-2d04-46d3-f434-08db2eb36022
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7cCfa4y0ldOjhpDWgktiY/zRGy/Yg4zNh2Uup4apiEToR7Mpc/xzQKltTsZL/crg3+HZC3CjzR+2PcKiGVYP6s7/RmhDjJux5CmfkKvdiPMuvBxhRJ/7Ij+bu28F6aeGyWzsQxtxqN59XJghW00grMztf/n80IRHTKVk/FMo4AnAwrydKLPIffaCC/xdp7fJ4jaGFT+4zTSa/+5bV6qGZel+SrwsmpPcEbPIUPR0qygVToXbHPrydKTy57nsfp1zeJY0byFgJuoWwoPwAA4MCC1/29No12pznXCiTdi4OoY0/JTzJkQei6UOvoVRSzCYoL+hW8NKPR4/bOOMY+ar4g3rXtEyjWQrpOXGc3cK6TDfOrbNMhvdNb7obPYfmUahSelZOzxx4EPB78TlDI85dcNHNzyEpkj6JU3SgXpFHkcSrXlDsqVWFUQ6JT8R8hutX7NnNtNymyHKhL+/xr6LjzOcy9hOjUpAeM2Whcmctx9OMMLuDgK5ykERQCtrzjU+csZ+WDiC7k6kqpJ8wEPrqD0UwTD9gvcDoR+UsKMr2qtXZ3oBAlwhJQKOXz5A6ps7Te4pxvLufGVZa/TIMo5SkMNLdoUNNgL5lRiXZbXf5YLydToFbTw4aQSC60723HlkwChRWvhqGhqYX5Nx1idQWZ+NTtc0JV4POZLusegiD94oDLHkgSZtXlXuXXwFYwrDI6q+5U7xT9LlnzC6hTabwUCQF2rZupotgTbs0gaGA0s=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199021)(46966006)(36840700001)(40470700004)(70586007)(6666004)(356005)(2616005)(40460700003)(86362001)(426003)(40480700001)(47076005)(70206006)(4326008)(8676002)(82310400005)(82740400003)(41300700001)(316002)(110136005)(54906003)(186003)(36756003)(478600001)(36860700001)(336012)(83380400001)(26005)(2906002)(7416002)(81166007)(8936002)(5660300002)(1076003)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 11:06:54.9515
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34799ebf-2d04-46d3-f434-08db2eb36022
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5299
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>

Enable transmission and reception of PTP unicast packets by
updating PTP unicast config bit and setting current HW mac
address as allowed address in PTP unicast filter registers.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
v3:
Remove config check as it is handled in gem_has_ptp
v2:
Handle operation using a single write as suggested by Cladiu

 drivers/net/ethernet/cadence/macb.h      |  4 ++++
 drivers/net/ethernet/cadence/macb_main.c | 13 +++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index b6c5ecbd572c..709e3b560883 100644
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
index bcda6a08706f..9b85b05c20cd 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -287,6 +287,11 @@ static void macb_set_hwaddr(struct macb *bp)
 	top = cpu_to_le16(*((u16 *)(bp->dev->dev_addr + 4)));
 	macb_or_gem_writel(bp, SA1T, top);
 
+	if (gem_has_ptp(bp)) {
+		gem_writel(bp, RXPTPUNI, bottom);
+		gem_writel(bp, TXPTPUNI, bottom);
+	}
+
 	/* Clear unused address register sets */
 	macb_or_gem_writel(bp, SA2B, 0);
 	macb_or_gem_writel(bp, SA2T, 0);
@@ -773,8 +778,12 @@ static void macb_mac_link_up(struct phylink_config *config,
 
 	spin_unlock_irqrestore(&bp->lock, flags);
 
-	/* Enable Rx and Tx */
-	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE));
+	/* Enable Rx and Tx; Enable PTP unicast */
+	ctrl = macb_readl(bp, NCR);
+	if (gem_has_ptp(bp))
+		ctrl |= MACB_BIT(PTPUNI);
+
+	macb_writel(bp, NCR, ctrl | MACB_BIT(RE) | MACB_BIT(TE));
 
 	netif_tx_wake_all_queues(ndev);
 }
-- 
2.17.1

