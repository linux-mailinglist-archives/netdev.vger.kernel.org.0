Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62BC6CFA90
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 07:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjC3FId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 01:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjC3FIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 01:08:31 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7F45BAB;
        Wed, 29 Mar 2023 22:08:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ankjwb2zdbxnLnf82bN3IqcHDjEnhNJxnwMjcHSsOX1Jlop4BiPCpE45GrCznqyNBJ3R87Lw1HK7OgMddyS6s2m/BvjUMCCfsKO28ZKiTxzTma43NMiTfw9X1mpMtQTe86mU1gyNDR2Hx/LBMWs3Lep6rnENKgke4AIAoCVnoUAY5+MfhGs4UgL+PJIRxmp2lNRpD4PkrjxokgN5lUyq/qfEdPL1KLqm67cqyQxn4UhtR5JkadctSlUFxeIDh8/kkTh55hnQUTaK4EBHkZMffop2EWcbcmGmQ1hGUNpopXYCSbpLyC7D/tmANiCUQFU/w7bsX2JzTciNu0bX+8WYfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QUwt/eGcfM8NlhSUCuGI8k970cE04K38r5SINOYbyDY=;
 b=MhFQCJfn8w3l9ENg6t815enDarX4v/erZiK13Qw2E3U0POLnnytgONY3zNOWLPyVc0KXrZegTdkrewNN9hLgjD9XBHE2nCBYfde6sXa0WNYHpBadmm9j2S67WVt2VuswUPPw141WxvhOW+CsqDOluUNhYp6xawubYuJAcyJgSPFUZfD6sbnCCi8xl0Zci3ODJi6n6pjp8fwuqvQBk1DjhsBBz+cuo8U9usv+9glyypMM/XdCADnke2gUu1ETR1AAKflBOaFX48JL4TU1XjsYw3L2yA6VJOfwaM94hc6rhW+R+txshBFGiUijyyEoV1m/vGY/eNrcshGn6/JHYhDlSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QUwt/eGcfM8NlhSUCuGI8k970cE04K38r5SINOYbyDY=;
 b=arYQ38HL6oq6WBnNOi9ZV8y6yj2/hfkBsoFmBnUEv9mUx1s4Eoe75l0vrnNPVrPhndVmE5YqM2178W75Azdi78CvfPNnpNE3dExyREgscicy+xDFCuTc7fOQ8rpABUB+TMTWeX0yB1tXPyvGT8LVVdwdsqCAO/fXNk8B7SbJxDU=
Received: from BN9PR03CA0101.namprd03.prod.outlook.com (2603:10b6:408:fd::16)
 by MN0PR12MB6296.namprd12.prod.outlook.com (2603:10b6:208:3d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.32; Thu, 30 Mar
 2023 05:08:26 +0000
Received: from BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::70) by BN9PR03CA0101.outlook.office365.com
 (2603:10b6:408:fd::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Thu, 30 Mar 2023 05:08:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT075.mail.protection.outlook.com (10.13.176.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.22 via Frontend Transport; Thu, 30 Mar 2023 05:08:26 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 00:08:26 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 00:08:25 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 30 Mar 2023 00:08:22 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next v4 2/3] net: macb: Enable PTP unicast
Date:   Thu, 30 Mar 2023 10:38:08 +0530
Message-ID: <20230330050809.19180-3-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230330050809.19180-1-harini.katakam@amd.com>
References: <20230330050809.19180-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT075:EE_|MN0PR12MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: 51d6c0f4-390b-40d7-97af-08db30dccb3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qrdk2dAiKuhcnwdxZWBI47Yn7OUWdDUgFOGNmsXUsRIMfb5VXC+UEVBsyrWE2QEDRh2ERk3IXN/hEueo+VLzx76Ub+uS6QjIopRpmbrT5fjQrz5ej89H+hhaOBvwdPBu/Kmh1d1NFObg2VWpIT2x+U226AHH8Q9mCimjtQ0edyXAzdKHTruXMznT3IgVIiFSuJ+PtK0CLPoq680VAIj/dZPe9bGi2IP/XK0+NVBPAazFV4YkJO0I+mRViJJUh3k82PWO+2pxZ2uTreLu6z9pN3Knp/IyOAQWaex1vGhoIkZiAiavNpbxIrXbdZoU79cDiIOhrxREoYHSfBx0eQ3Pb5bsXzbQMSl0K/rsWi1UeQiEIlNmpLanxMyRYRoHHIWXfKI/eluvnw/11KmXCEi4SKWnAs5VUiisP4HlmchaJMwSNc2K/DprAxCUVjygxgtzrXXy9bYKgj3h9fo+mIUYRKdBngVIW+9Nyg0Yozz7fOwL3ZCalD97/Ufon8/XScHPebuJMcZyaBySvt3Fh37fo7ghTxbGUqLKXOXDs93aukqeSDF1K4dGc8M/QCVsQYBsmPSUcSZKliaW79W1+/eXdmU0rTZ0MwpuG1gzC1uqEIqp13hgF7dzHKjnwugVQIWY0Y0rEr4v+fvvHIt47fwL8eDf5G60PLxlogxQ6l+ZJ4eCYHSVeRhv4a1T2JUWl5YnibLCZlNCaXg6SeyNiI5hmW7QfyHvxDUmfmd/oojEc30=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199021)(46966006)(36840700001)(40470700004)(478600001)(40460700003)(5660300002)(316002)(82740400003)(36860700001)(8936002)(70586007)(70206006)(4326008)(41300700001)(356005)(54906003)(8676002)(7416002)(26005)(186003)(44832011)(47076005)(1076003)(6666004)(426003)(336012)(83380400001)(81166007)(110136005)(2616005)(40480700001)(82310400005)(36756003)(86362001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 05:08:26.3469
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51d6c0f4-390b-40d7-97af-08db30dccb3f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6296
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
v4:
No change
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
index eab2d41fa571..e941ea365db1 100644
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

