Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C80443C709
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241318AbhJ0KAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:00:48 -0400
Received: from mail-dm6nam10on2043.outbound.protection.outlook.com ([40.107.93.43]:2944
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241296AbhJ0KAh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 06:00:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5OVrkxs5bRa/C5K+DyRfiUBNaU7PCNjzTjh+BHFReTVwCAF0Gn3eSvtrZiaflAsfJ1jotslOhxDy+2Excu2pmwzfKNBPDfVq10aB2OIfub2e7tt6BaM+NJm+HQ/Vhb85DW1D+Ucz5VDVerdQvWph0y3+eD+t0cSdFrieQfTnSPXFdQvn1jEKNw3r7G254bSFfrQJ/KP5fua3LAha0YsTTKnhSFLU0v+3tT9NLLAWcw/Jv4ZOJJCVEtDbGrqCgWSeZAsgWNyLrDmXDAg8+5WEN8LldxX91oclaUL1Yl9foUN0rWWMHPw/JxqWoyXJ1bwPpZPd2WQZPA65yRBIJU+/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NHJhKoVoRlv8Sa+xo2K2JZfhyU0UlvFcqnZfdbaf0p0=;
 b=mDkKDtCfPNpDxKoIEhx86SSeuHAlq2KasIDqIsB4lHBRYVzJHOpTnoOyFX1cPJ3LPFc4Ww0qm6m7gq+SbHkhwGJffK3Xwr5vuetBsEdA5oWg10HBvrcbruE3NE+tWzfb0b1lnZfjeLYXStRS8dGWcuaQjlJpshYRSKaVz7lzg2+TNWFbLMu5QOW5tEAtPNnC5tNXhUEGvbMNQw8enLV64x2sOQH2Jn8lq76uEkrgVIhvZpSbwdtf1M20slJnW43wlJaOwPd+gr2jPZ/3araXRflF8uZrSY4QGgegkLFgaNqGSKH3YCzQmL7LQyGP6HsO6btmi9k2GOacVEC+5WThKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHJhKoVoRlv8Sa+xo2K2JZfhyU0UlvFcqnZfdbaf0p0=;
 b=B6Qh9eL0Lx7FR7nK0PMer3wINGr4lhGrEp6ERw1TLLTvqAkfO5pGlWK0lbjuEdteQo2sd2Hlc97Ja+FSZZWKj4QNwwJRe0HNF2kC4b5l8kIvHBHFZedu7hjsACylfzWkcQK3eFEPtJ4ABHwWYoHpoc9GUySd0aDjQMxRJP/m/0g=
Received: from MW4PR03CA0299.namprd03.prod.outlook.com (2603:10b6:303:b5::34)
 by DM4PR12MB5056.namprd12.prod.outlook.com (2603:10b6:5:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 09:58:11 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::a0) by MW4PR03CA0299.outlook.office365.com
 (2603:10b6:303:b5::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 09:58:10 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Wed, 27 Oct
 2021 04:58:07 -0500
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Raju.Rangoju@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: [net,v3] net: amd-xgbe: Toggle PLL settings during rate change
Date:   Wed, 27 Oct 2021 15:27:27 +0530
Message-ID: <20211027095727.2072881-1-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ce866ad-91eb-4f66-e133-08d99930489f
X-MS-TrafficTypeDiagnostic: DM4PR12MB5056:
X-Microsoft-Antispam-PRVS: <DM4PR12MB505672CBC800130B5380E5389A859@DM4PR12MB5056.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:451;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JXkkGuOzmhHd6gfa2cy6oPlHeOViP56LQHD3WxhTqCU8/9jGXbBjeXuQRgdiGyrf7hML4HeOHr4aNOWV37x1WApFxWtqeDpgA3ckbVZ9s10eBZfDF9pqRKtxxHVnUdCmauzGFUDak4aBTbhO4YrGmjccCOXqpWs/z4TtFJS2P5GbJP94s/xAOYNRaMdLiJ9tumyYp1q7EXpBQtznVyQdSeKKQLr0ulhp8m/dc+Eya1YGVbheNSKnkgZ+B/y+3S81elS+9Ph1ywS7VvBCVq0dG1DCe9SREI5vbbI4O/nMSJ1O9nRtznuhYVxRVfVxN+QFy06fIGSdGcX11ImDVn1sPfWFN0fC9NyqJTiSISiaXxV/QYfuE9aHYDxb28pbkVO9uJmAjmGwcvu0zth9KJ0B7nTj5J/09ABiq33svm5aivgEOZ7SfXsvcTk8iQfVMl3hf6BG7ha3gfTnNPosUsCOFfzegcszp45kKJ+mjqb2WKSfyStUODcC1GHSCVgHAkpYzYC59gGoNd11jrxNRE6cTcvv4+IyY1QUM5J0xLtAH69J8RgUABiKhUMg3jt1Xshbp57CfeoZ0tBxKt74Q0RxFsyw+EuCCehrLH3eZsja7ZexBBcGCEZ39AnQIY51WdFhGy0f4PB0RMFYdVWiO58MaPTBN9uYMvcziVK4qMi+k4BaGreSn3Ow23qgLwOGNdyEWOfCJCQMVgc7ECBffAlXi1P0YKyP3hJBt02jaK0vPjw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8936002)(2906002)(54906003)(316002)(7696005)(426003)(356005)(81166007)(1076003)(186003)(47076005)(508600001)(70206006)(36756003)(82310400003)(6666004)(36860700001)(8676002)(336012)(5660300002)(2616005)(4326008)(86362001)(83380400001)(26005)(110136005)(16526019)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 09:58:10.3954
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce866ad-91eb-4f66-e133-08d99930489f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5056
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For each rate change command submission, the FW has to do a phy
power off sequence internally. For this to happen correctly, the
PLL re-initialization control setting has to be turned off before
sending mailbox commands and re-enabled once the command submission
is complete.

Without the PLL control setting, the link up takes longer time in a
fixed phy configuration.

Fixes: 47f164deab22 ("amd-xgbe: Add PCI device support")
Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
---
v1->v2:
- Add Co-Developed-by: tag

v2->v3:
- Code Alignment
- Add Fixes: tag
- Add more information in the commit message.

 drivers/net/ethernet/amd/xgbe/xgbe-common.h |  8 ++++++++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 20 +++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-common.h b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
index b2cd3bdba9f8..533b8519ec35 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-common.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
@@ -1331,6 +1331,10 @@
 #define MDIO_VEND2_PMA_CDR_CONTROL	0x8056
 #endif
 
+#ifndef MDIO_VEND2_PMA_MISC_CTRL0
+#define MDIO_VEND2_PMA_MISC_CTRL0	0x8090
+#endif
+
 #ifndef MDIO_CTRL1_SPEED1G
 #define MDIO_CTRL1_SPEED1G		(MDIO_CTRL1_SPEED10G & ~BMCR_SPEED100)
 #endif
@@ -1389,6 +1393,10 @@
 #define XGBE_PMA_RX_RST_0_RESET_ON	0x10
 #define XGBE_PMA_RX_RST_0_RESET_OFF	0x00
 
+#define XGBE_PMA_PLL_CTRL_MASK		BIT(15)
+#define XGBE_PMA_PLL_CTRL_ENABLE	BIT(15)
+#define XGBE_PMA_PLL_CTRL_DISABLE	0x0000
+
 /* Bit setting and getting macros
  *  The get macro will extract the current bit field value from within
  *  the variable
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 18e48b3bc402..213769054391 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1977,12 +1977,26 @@ static void xgbe_phy_rx_reset(struct xgbe_prv_data *pdata)
 	}
 }
 
+static void xgbe_phy_pll_ctrl(struct xgbe_prv_data *pdata, bool enable)
+{
+	XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_VEND2_PMA_MISC_CTRL0,
+			 XGBE_PMA_PLL_CTRL_MASK,
+			 enable ? XGBE_PMA_PLL_CTRL_ENABLE
+				: XGBE_PMA_PLL_CTRL_DISABLE);
+
+	/* Wait for command to complete */
+	usleep_range(100, 200);
+}
+
 static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 					unsigned int cmd, unsigned int sub_cmd)
 {
 	unsigned int s0 = 0;
 	unsigned int wait;
 
+	/* Disable PLL re-initialization during FW command processing */
+	xgbe_phy_pll_ctrl(pdata, false);
+
 	/* Log if a previous command did not complete */
 	if (XP_IOREAD_BITS(pdata, XP_DRIVER_INT_RO, STATUS)) {
 		netif_dbg(pdata, link, pdata->netdev,
@@ -2003,7 +2017,7 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 	wait = XGBE_RATECHANGE_COUNT;
 	while (wait--) {
 		if (!XP_IOREAD_BITS(pdata, XP_DRIVER_INT_RO, STATUS))
-			return;
+			goto reenable_pll;
 
 		usleep_range(1000, 2000);
 	}
@@ -2013,6 +2027,10 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 
 	/* Reset on error */
 	xgbe_phy_rx_reset(pdata);
+
+reenable_pll:
+	/* Enable PLL re-initialization */
+	xgbe_phy_pll_ctrl(pdata, true);
 }
 
 static void xgbe_phy_rrc(struct xgbe_prv_data *pdata)
-- 
2.25.1

