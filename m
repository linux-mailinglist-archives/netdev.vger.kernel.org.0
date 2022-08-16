Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84AB7595B3A
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 14:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbiHPMGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 08:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235138AbiHPMFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 08:05:47 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E441EAE5;
        Tue, 16 Aug 2022 04:55:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DgOSvLXCPqI0QcT5v/ZOH8WLN1l6pJRCnb0ntp9bdrFTDS8zSF0pggpJD6deMz8leMtVBw4hNorJIQsSHWx6J/6sxv464QRoOgR6PcZPq8eANxCwmPB7DMSpsH5j3A3KmF/ZJrIgY27AB6WiVm8EInit0BfJYAzlRe7KNcB81Q7H0aNs7wX/bLy1lxfSDnUNUD/t/gFx1QrfgP2z11EewcLyZ9MwD9XoBUjGKtgKO1tOc3a+JiKDaX+VYX6Th56R7zjC3D+pDpVFBr2xTEtF0msV8SdLrG8JxZZ5dUWaaEhW92cLHhIwcm663pyvXn/L8myoQ2tTfnpclrlPTSm3BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rdSB/JB+feraDgtChGlyHmoUDda20mPwBDTMGIFer4k=;
 b=Bp0Nmfre3ftNaiRSAukri0mZK8WyD3YZEW/ElGca9GL5S/Bpv6Xs7ChoEa/jLZjY8pk3sL3lnAQ+QOvSdu09PL8Lyzz6gpouQpW/Z8vxI92FhtFr1+wm4pdFMQIm3ETyUWQCz27Mlg9JQrex5H37PmC8p60+gx6rOBsKMkJL9tHRkFGzlInX1lu4cTGswVNuaNAx4jIIJ0Xs1vstnji/PO4uzJFem6VyZPbN7GezWyLe2/E/mLwhSBOyEIOtFvjIzNga/RZqCogOj4YV1qkU8yGwgVQ1GSon8TSb/UrUDECO8i5Bh3TqT8BZS5FtKgGj2GbgyVe/Hv7QGOkeykwNvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rdSB/JB+feraDgtChGlyHmoUDda20mPwBDTMGIFer4k=;
 b=GVlFNkZqQlK/jC/K/tfhG7Fusby6YK327A6t4yT1l+Kl6Zm9zFMUGoDE0J0AycH9V5sddo3tmg9fj4DchhLt68CHTAAE3iu81gX07mhqgrtAlfWGz5RXHCKsUvNiaCO0YC1ZbT8pTi1UeOKMOV+CxgEgjjdYcPSqT+P80yD733U=
Received: from MW4PR04CA0037.namprd04.prod.outlook.com (2603:10b6:303:6a::12)
 by DM5PR1201MB2475.namprd12.prod.outlook.com (2603:10b6:3:e6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Tue, 16 Aug
 2022 11:55:13 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::13) by MW4PR04CA0037.outlook.office365.com
 (2603:10b6:303:6a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19 via Frontend
 Transport; Tue, 16 Aug 2022 11:55:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Tue, 16 Aug 2022 11:55:13 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 16 Aug
 2022 06:55:12 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 16 Aug
 2022 06:55:11 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Tue, 16 Aug 2022 06:55:07 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <michal.simek@amd.com>,
        <harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [RESEND PATCH 1/2] net: macb: Enable PTP unicast
Date:   Tue, 16 Aug 2022 17:24:59 +0530
Message-ID: <20220816115500.353-2-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220816115500.353-1-harini.katakam@amd.com>
References: <20220816115500.353-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 513b43e1-2bc7-4690-2a65-08da7f7e2da4
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2475:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tm9t5Wv3LouoCFCRBVk07xbttMbCvb0OGUGiqYFiAxkYSJXRYqOdri+RxK+iLBy4PQSzznvnKE7OQnBckk1qgo+RzhiIXamFfYxfFUX71cmWyNo/yTgTLG1F/h/HHI7C1uempbi1evh1NsFLcQE+qScu5PqK0PdzJFaOACc/c1hwpB91vbLrGaMpvMtO8fuVH02NaYX/Vy8yWwx+sDzMWknBQia/TfUBdxxsjFHdzztnYCiF6QUvDuxF8Pj+OHefg0mbhixwkMr0KAwTshwtnkdOHt6aCTi4KH1muJZSdmCfa7hDYIbmMKi9IlJODZlhgCh/fBWNBk5oCwOveOS55GfRuPIDpowMtNb8jCD0bGHQE1Q0Po5qMU2TytDDfINQPTa/gzVJjW1LU0w3cGIygEcg7Io0ZE7tEb/RhhVzlwPduM1DCmK4mo15YJAXf56CEkcmkSZK4nuuA07CYxmqcAGAE/fDzy6envsnrmjjR5hroSf17E1eRSwHv61FbdCwaIB6rf5rzn0KjMO9NzwoHoUcruIGLLgjIJVQb3ihKEZxll38+3fY09H9JeOuvSTbebj+mym8PK7jnCsoYPCO2Nw8YJr9SO0nn2KpQmfddRseCzeKrhQ/rPjbMiB8VqDTNBsBvpo/ytgHGHYrHwoZDabqZ+MEV1SddTieU33Vbwu2pZ84or7KG9no/Y/Fwvr0h4IiF7H/xer1ME9+6vfkRLgRkv3yOUpnP6js75m6EmyLq4wy/bOEDE/8Rb94d+ruepJHljpUfcXzHxVf7Uz8dJpX9pi0bjso7LgG+mOoDYAE4eSTYPJmtQ9RLp5kSrEWw4HJqmbZDddUOtvNID1Flg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(396003)(346002)(46966006)(40470700004)(36840700001)(41300700001)(86362001)(356005)(36860700001)(40460700003)(83380400001)(81166007)(40480700001)(70206006)(82740400003)(70586007)(26005)(478600001)(316002)(82310400005)(8676002)(54906003)(2616005)(336012)(2906002)(36756003)(1076003)(110136005)(44832011)(47076005)(6666004)(426003)(7416002)(4326008)(186003)(8936002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 11:55:13.2811
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 513b43e1-2bc7-4690-2a65-08da7f7e2da4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2475
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

