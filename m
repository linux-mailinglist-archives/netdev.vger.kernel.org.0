Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D896142AB88
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 20:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhJLSG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 14:06:57 -0400
Received: from mail-dm6nam10on2074.outbound.protection.outlook.com ([40.107.93.74]:23905
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230002AbhJLSG4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 14:06:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=meSVLhq0UEH1zSW89UgOzQgEyl8MOraxjanrdVicFE2YmtC9gksR2iOaDBv37jC4Tm1/C3ReYuLXpA2uPPUR3BG0bGv3vqZkm+9crGdruUEQzpNq/6EocLVUa6zNQvXWbdr3tXaQVXUCY+MDQrjr6yatx1XAQYpFGEaDF2PGQlIhZfRhjsWOz/c8eDSGBN4prh3nPBETcQzd8HNvj5z8E0fhR/byLd3aPI00D7+vYaadl7tyMDul2KD3q+q/UBoNZeD6DLMNIdPIUwVJN7uFrvtVX72e3H5As3NrZPyq7ve6IBD6X/TOlZmynBxkYpZHZ99s4ld+b/mW/dWfyQn+7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jCQOuweJqFfoWSZaz03HcOFvWuwiimHH3AFKlYRZXE4=;
 b=UE9HUFysLtb9MLoOL+GekGum2DKqp0cH65kKL+MWqVQOq9k6qX+BfrEhEb0jFFNEa0nvtnIoIH7x4eAJtWjeEcgHJR+jgy1zvWd3M33En0NcD6wi1u8OqiP5m9rCjHyhCISvMnvpd8SGGKR8eydInOaAoGAlYqDQjp3/V0mq6I/as6WLl0pKHMUuHSTtQ4JlgWOomsWw24SpRhQpMVL1CTbAyDmRe056rYtc+MWEKAxoXzumQV2hJAg63lQTu8xz9q00yet99zHZd6mPPcld8WilRyqJ6qyssFj/Z1/YR/TUEzw3QztRAWesHlUTlfYIsjkFlrA78ynvxaY82gsI7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCQOuweJqFfoWSZaz03HcOFvWuwiimHH3AFKlYRZXE4=;
 b=DGihh2JkDLGK7cxq9AIKaJ66Oe6c5W9R5lloTNTetHzCDO63l295fu78XVvFi+DhgZAJZO1bmuqFCfa9nva5QfuLs7oMzOkXKqItUDfud+KFK08eHCGdguH2L0P+wMxVB2BrjtMz43oOgPBBa4GlendWoSMbKbM6ZvjIazZMMm8=
Received: from DM6PR03CA0088.namprd03.prod.outlook.com (2603:10b6:5:333::21)
 by DM5PR12MB2535.namprd12.prod.outlook.com (2603:10b6:4:b5::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 18:04:52 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::fe) by DM6PR03CA0088.outlook.office365.com
 (2603:10b6:5:333::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19 via Frontend
 Transport; Tue, 12 Oct 2021 18:04:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 18:04:51 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Tue, 12 Oct
 2021 13:04:48 -0500
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Raju.Rangoju@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: [PATCH v2 1/2] net: amd-xgbe: Toggle PLL settings during rate change
Date:   Tue, 12 Oct 2021 23:34:14 +0530
Message-ID: <20211012180415.3454346-1-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce65ea60-b79c-4e39-c264-08d98daac98a
X-MS-TrafficTypeDiagnostic: DM5PR12MB2535:
X-Microsoft-Antispam-PRVS: <DM5PR12MB253536D1C558A62C1BB5DDB19AB69@DM5PR12MB2535.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uqnchcmg5KcpFH3YpiVd7/Rc60t4fPAJX2+hwp4iSHAGwd4zIxyzAuEQsYWiAQUhuppLZ5aTMtbwVQ7CWNglziFm7VNlapfzJGGZhg4SfBsdvjvQhLqtUSxfntNWoGr6JyMFKG53YYcmYasJye9d7dAoLoqmGl9lnnTPChpKrb2VGeqYef/VcVuFBNkFk5l1etbsQMz69ngFK4ctsPewP6aLJDM7K5gvKr7aX1ACV2NNRP8FzR7BfLOV4UuGnPqAWP8OJ2QU77RcAfVfIS4PaP4MLcHK0BVk0medKAbWe6v/5ejN6iPRC7fQc33Rr7YRSYF6SWrc5wWd8expQOr8Ixs/SG0RAgZ5myrTSYLax3Ut74ej/uCmRwUWPnQyqO1lCVQ5RjiIalJw/AjtwdZmq46fBFt9UjbT1PAas/d5SPErHUEK2cNmG4V5/udoMMM6xnFIrLtDSCdi/rKC+/ycr4cbMmpM6BEzutNJrJv8RFqnNbnZ+d4qMp3b2H+TJBOQoEIRT6LYXiLFWqQc/kV06+YDY1qguJd6uWXmzGUO4wluUE/6sTA4hmWwbf5rT+F/LyX7NSflFNheWGBjCOb2bnm9znTntVsge94OSmAC6xKfrZ6W5zJIY36CcUb1lRTj9YJFbpNco5BPiIWa4jP2tch9aJIsxa58la6234HgWFLAXjnah0+MCGrRg3qHfvPGPbArSvyyIRaqmEVgh8Kzz0aWZHUG3XEl+WVLAq4umRg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(70206006)(81166007)(82310400003)(70586007)(508600001)(2906002)(316002)(356005)(7696005)(2616005)(1076003)(16526019)(8936002)(8676002)(186003)(26005)(86362001)(4326008)(5660300002)(47076005)(110136005)(336012)(426003)(6666004)(83380400001)(36756003)(54906003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 18:04:51.4097
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce65ea60-b79c-4e39-c264-08d98daac98a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2535
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For each rate change command submission, the FW has to do phy
power off sequence internally. For this to happen correctly, the
PLL re-initialization control setting has to be turned off before
sending mailbox commands and re-enabled once the command submission
is complete.

Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
v2: add a missing Co-developed-by tag

 drivers/net/ethernet/amd/xgbe/xgbe-common.h |  8 ++++++++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 20 +++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-common.h b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
index b2cd3bdba9f8..3ac396cf94e0 100644
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
+#define XGBE_PMA_PLL_CTRL_SET		BIT(15)
+#define XGBE_PMA_PLL_CTRL_CLEAR		0x0000
+
 /* Bit setting and getting macros
  *  The get macro will extract the current bit field value from within
  *  the variable
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 18e48b3bc402..4465af9b72cf 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1977,12 +1977,26 @@ static void xgbe_phy_rx_reset(struct xgbe_prv_data *pdata)
 	}
 }
 
+static void xgbe_phy_pll_ctrl(struct xgbe_prv_data *pdata, bool enable)
+{
+	XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_VEND2_PMA_MISC_CTRL0,
+			 XGBE_PMA_PLL_CTRL_MASK,
+			 enable ? XGBE_PMA_PLL_CTRL_SET
+			 : XGBE_PMA_PLL_CTRL_CLEAR);
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
 
+	/* Clear the PLL so that it helps in power down sequence */
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
+	/* Re-enable the PLL control */
+	xgbe_phy_pll_ctrl(pdata, true);
 }
 
 static void xgbe_phy_rrc(struct xgbe_prv_data *pdata)
-- 
2.25.1

