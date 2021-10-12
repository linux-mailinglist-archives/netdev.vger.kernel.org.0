Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C0F42AAE8
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 19:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhJLRjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 13:39:47 -0400
Received: from mail-mw2nam10on2053.outbound.protection.outlook.com ([40.107.94.53]:12705
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230268AbhJLRjq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 13:39:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QeuMCy4sCT/D8DEqcu08fZf2U9vyPd7JOTPlPaV35+hDfQX5BGuMiiYbtslD6HaJaSHMdZRZy9QVglHPoMDkFbOPBk6/pk0XS/LEvnOKvO43jQYgWT1goz8CqbCeXr2znUZtnpzX68vOafbRDhki70s1Rwp9HoMTCy6lYEEST9z/q8ELBgyRuCzXKz5QYuuwQ27F1rFvwr1HzVqHZLaMWnQ2Fm6KYj4RG7RqdeOserXAzN4zIIX5X2ydTvs3/jbQCU1wyGgTO9evCwzdKakfu83IDyDbMC4OqhBxWx+i1r5weCyNvLfYc6Wbwc+bLJqwb9D44iIg9+vjcFfaVhBfpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h0Iin5jbWbYVv6wRerHaalFuUILzxONED7+2fkPRX9Y=;
 b=Y9WtTMObR8siH1Hdkc/4RORLUOme4429KrLYEOCMOZUyyD/pyGSh6zpfT9uMaZd08+NiKCDEa0pdp/4p/296FtQuvq/AAexH9UpuTuX++soeobjU6QrH6wYmrK+6gVSCtZ10MV0E8UsGekOXh+qYOT10h95TvyVLUnm9AA3QzrjSQdno0eWgJY84PBQCCee2w8eDh7aKBXwo47K2dkP2DDMHi4h2KTRWV9X6DjMcPOhSDVOLFDnICK/CUy1gk3LrzyVPYKmL4HG5i10ua3js/3ZEGjapmySqC2RG2XjjWlAfkixUnVuiEHn6dJ0wXsIVCH/aNdJxQxpIgeFSD7Apgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0Iin5jbWbYVv6wRerHaalFuUILzxONED7+2fkPRX9Y=;
 b=xzhS2GQ39lMO0msrDs8uxOP8+gmzJt6DEre8Z31fD1PKP+15IQ7Sd8rnitA/cxbmv0YhPFUR/7Gy35kP2ztW6m0g1pYGfs4cw7HLQZfn3w2N1fCa6UDURVFJkIPK9lDnLtfJOIQNReec+iYGgS9m8Kbg0YStQEQwuDS6bU4jRk8=
Received: from MWHPR18CA0044.namprd18.prod.outlook.com (2603:10b6:320:31::30)
 by BN6PR1201MB0129.namprd12.prod.outlook.com (2603:10b6:405:55::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 17:37:41 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:31:cafe::d8) by MWHPR18CA0044.outlook.office365.com
 (2603:10b6:320:31::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend
 Transport; Tue, 12 Oct 2021 17:37:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 17:37:40 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Tue, 12 Oct
 2021 12:37:36 -0500
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Raju.Rangoju@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: [PATCH 1/2] net: amd-xgbe: Toggle PLL settings during rate change
Date:   Tue, 12 Oct 2021 23:07:08 +0530
Message-ID: <20211012173709.3453585-1-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e9cc422-ff49-4f70-9c89-08d98da6fd5f
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0129:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB01291397972E64B377EFFA7E9AB69@BN6PR1201MB0129.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LDR15Hj/oJ7HaHOaUaEzVroZgU7iI7fTng34F3JuI6FU168NEUyNzh7rX3iiC+jUeRwMUiS+xkea+gm/EhURZ8qpDTyWpdlYX5M/quI/rS00igWFkHw0jLUsY6nnMo6YmPh9RStgMWAxAR7LZ2jQ5Dh56xru+/0nYaczfKhwOzPsOKXJgEgkXdiGjbjEG563UsPWSe+nksZqEUGO2JFKy/kdAyUt8u3kg1nT82sg1yivldBkj6lfJ0PdDvJ2QmYxOfLYFxkEGTh2wD9IkNUPBydxkPJw+9PwdvV8pKX5xTxrztT7MgHp7gYCKDhsSa9guyW2qwvzCRQwPXlWUW0NLSp6A1ViUyOoZqmNPAYdcOWadMyjKBbpcm+0si2X9Fkn06+ztsNPRLYgm1x6w52WiMaaJZupGWIV/p2s8XVnCGm4TnYTR16vjfKjCMi+Xev5bIhBO8onxR6FcaEfYLu6X4V6hq73Z9yiRYk4NUnp+S2i2ONzWPNdcdl6v/FHUn++xT6NHInXLcY/9rqQBR/QytGF2jBgHZb5Fwlkzm1/Y1ISWUa1NmY+CeB0B+jMIsoEPVlqwmFzcxQ6pqYJJ7dkebfq+jDto3At0y50tDLVo4XJD5bt2acFssqy9qxxhPFlSFWNEeAORUedrsPA+F0T/voDAo4DELcfUHgkVIDBUGCyGag930H9TjxJti82pFIT6oPyBGeGa7ry1UC+ziSdsARxZBmYmmbma4rzSZvUJF0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(82310400003)(47076005)(5660300002)(54906003)(83380400001)(36756003)(26005)(426003)(8676002)(2616005)(16526019)(86362001)(8936002)(70586007)(316002)(6666004)(110136005)(336012)(81166007)(2906002)(186003)(356005)(70206006)(1076003)(36860700001)(508600001)(7696005)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 17:37:40.3075
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e9cc422-ff49-4f70-9c89-08d98da6fd5f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For each rate change command submission, the FW has to do phy
power off sequence internally. For this to happen correctly, the
PLL re-initialization control setting has to be turned off before
sending mailbox commands and re-enabled once the command submission
is complete.

Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
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

