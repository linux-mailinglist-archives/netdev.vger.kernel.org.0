Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D97685F45
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjBAFvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjBAFvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:51:16 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D059B5CD31
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 21:50:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgcrQDa9VCWrWuI5l28cYChBuePEQFaacXcicgGY9LLw33wkfS33O6ITLkWvaG/W6octgb6T/BXenVki/cIxZDTQT+SY2xdFTuhidCKWHX3BTdkytWV+l5IFScXJ9uvfhIiWx6TpH7vI8S6oQZgTiG8dcGUaysPwn45IyKhoI+Y2Z2tHx63GijZH4e3yr+XmkScJfeiyFQ3M9MhB4CvU8EsjOlMmtvIvSRLI5qN7ZEDT4/3F6ZmcrqztY0WY2gmcarYS6HHixYPkXmgFbm0DmCuiEQ79uTLW07whnMKz7YkLlENxY3ICHBjRgyIGYib04W0xtq0zRSNDsi1cejuGTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RP2W19Xg+qO2rufD3xw8NRLqfdYU/8z8djKcGE8jbOY=;
 b=KQA+0kv4rrSDjRCCiPmbNOPKg2nRiTtejDfdLD0sB/tVmM2JpRFySty9Un0wMqmW7qBeE6rfOt29b2XPToFppGnkxxv1cDxYwZ01BTr/tlUuq69K80dF6cqGtzv8Na36ULjHaZUysqaMWoMKIc9srPCThoHC+w5+vkHrhkRTaP2jyzKMPX1Lp9U/WX+T3Do515YAwklkN564Hez7UgOWrjXb9TB+FAIz7XTouR9xRBoAOj0MvjNxIL+Flp6zHD6avgu2ZM4ZKCaSoP63sCpqg6o7RiumWgoG1BZAOdryweTki/5Xac/4+qRNCz34PkhErjJ18/NdtMvLOSAN+YnX3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RP2W19Xg+qO2rufD3xw8NRLqfdYU/8z8djKcGE8jbOY=;
 b=kT/+fZmUJwHdL95G9UOVCgF+KRHmhDE6VxqYHDVFCqu6uU8XU7oxZtZksf+yUbndbwNAilAKQ+2YVa5Bznt3mQmHJmwmrYpNGy4stiwls36v7/uHZRhREVB8bNBq1vkrQazrdlXY+nEYuAd68UHHe3V2Dljs9bu+TuZgQxRXYs0=
Received: from MW4P221CA0022.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::27)
 by CY5PR12MB6372.namprd12.prod.outlook.com (2603:10b6:930:e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.23; Wed, 1 Feb
 2023 05:50:11 +0000
Received: from CO1NAM11FT116.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::46) by MW4P221CA0022.outlook.office365.com
 (2603:10b6:303:8b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Wed, 1 Feb 2023 05:50:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT116.mail.protection.outlook.com (10.13.174.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.23 via Frontend Transport; Wed, 1 Feb 2023 05:50:11 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 31 Jan
 2023 23:50:08 -0600
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <Shyam-sundar.S-k@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH net-next v2 2/2] amd-xgbe: add support for rx-adaptation
Date:   Wed, 1 Feb 2023 11:19:32 +0530
Message-ID: <20230201054932.212700-3-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230201054932.212700-1-Raju.Rangoju@amd.com>
References: <20230201054932.212700-1-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT116:EE_|CY5PR12MB6372:EE_
X-MS-Office365-Filtering-Correlation-Id: f2cc649d-eb0e-4ae6-f721-08db04182f0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W3WgaTxxmSs1AX+9RJgUHQFo6LLFAen+2V1MkynOzuGUknqqJY8QwhgQ0mweFk0683GKEKuz4h/RMIf5mVOEu/xvOIC2Oyz+lGMOT4i9tNUJKXt7PX80SVF9d0q5mYIxTjYBjAHlxnJ3Jr6jbbr2kEjOtNVnFFW+nr3mPFtcnPBfMO8TWEeMcW6eFyG0ccERNteaQzuMSxd/pSP69L6EwQpBwHy15qwQL++i8TKACA/ftkHtn0nXWpV4tiuzUgU14mjy028y6O5J0Ip94Yr3GdBtTycujjF3VirDVIP/Wz1yFIQuwZwtd4JI6d7ZCf6lvhR8/PKix9Mn15JjwIrZA7jjgtfdXRvDeEwLU1lVhhfSJ3XjlnwU/h5QlWRd5bR+5rzxVg0GkriUmqe2uYggRt/7VC3H2YLRU7Fy0HDgY8EL3Y+wjWI2VIvwQNXOe0Hy1svHxLblGTjaKwRPP3aqCdkrLp1fkn34NG0i8ydlXiZjjRwhotNRiZS98oLQ7w3NL78r3YBL25Jp2Mbkfvt3ELUZvJtnO0eiLaGJjzuWoHgud5nARCVkSCOBPCndByqZlQHNaw4x1khJCB9+RY8u8333GqYOS81G0k2vNuxVOK2n7peEWzNtlZ6/Ue2vWmuxO4D3TZB0KYBgP46cVwzTX7Q5ouwtJ5b/OYQZWWyPlmX37sL3W2ZGGOnNpm79AJq4cP0oHzM7MLSVvPrvklbUMSqoWiiInVL+Sg7vXB5xYUs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199018)(46966006)(40470700004)(36840700001)(6666004)(1076003)(26005)(186003)(16526019)(478600001)(82310400005)(2616005)(7696005)(83380400001)(336012)(426003)(30864003)(2906002)(47076005)(86362001)(316002)(36756003)(81166007)(8676002)(5660300002)(36860700001)(40480700001)(54906003)(8936002)(82740400003)(70206006)(40460700003)(70586007)(41300700001)(6916009)(4326008)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 05:50:11.6952
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2cc649d-eb0e-4ae6-f721-08db04182f0f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT116.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6372
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing implementation for non-Autonegotiation 10G speed modes does
not enable RX adaptation in the Driver and FW. The RX Equalization
settings (AFE settings alone) are manually configured and the existing
link-up sequence in the driver does not perform rx adaptation process as
mentioned in the Synopsys databook. There's a customer request for 10G
backplane mode without Auto-negotiation and for the DAC cables of more
significant length that follow the non-Autonegotiation mode. These modes
require PHY to perform RX Adaptation.

The proposed logic adds the necessary changes to Yellow Carp devices to
ensure seamless RX Adaptation for 10G-SFI (LONG DAC) and 10G-KR without
AN (CL72 not present). The RX adaptation core algorithm is executed by
firmware, however, to achieve that a new mailbox sub-command is required
to be sent by the driver.

Co-developed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-common.h |  38 +++++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 172 +++++++++++++++++++-
 drivers/net/ethernet/amd/xgbe/xgbe.h        |   5 +
 3 files changed, 211 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-common.h b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
index 3fd9728f817f..3b70f6737633 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-common.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
@@ -1285,6 +1285,22 @@
 #define MDIO_PMA_RX_CTRL1		0x8051
 #endif
 
+#ifndef MDIO_PMA_RX_LSTS
+#define MDIO_PMA_RX_LSTS		0x018020
+#endif
+
+#ifndef MDIO_PMA_RX_EQ_CTRL4
+#define MDIO_PMA_RX_EQ_CTRL4		0x0001805C
+#endif
+
+#ifndef MDIO_PMA_MP_MISC_STS
+#define MDIO_PMA_MP_MISC_STS		0x0078
+#endif
+
+#ifndef MDIO_PMA_PHY_RX_EQ_CEU
+#define MDIO_PMA_PHY_RX_EQ_CEU		0x1800E
+#endif
+
 #ifndef MDIO_PCS_DIG_CTRL
 #define MDIO_PCS_DIG_CTRL		0x8000
 #endif
@@ -1395,6 +1411,28 @@
 #define XGBE_PMA_RX_RST_0_RESET_ON	0x10
 #define XGBE_PMA_RX_RST_0_RESET_OFF	0x00
 
+#define XGBE_PMA_RX_SIG_DET_0_MASK	BIT(4)
+#define XGBE_PMA_RX_SIG_DET_0_ENABLE	BIT(4)
+#define XGBE_PMA_RX_SIG_DET_0_DISABLE	0x0000
+
+#define XGBE_PMA_RX_VALID_0_MASK	BIT(12)
+#define XGBE_PMA_RX_VALID_0_ENABLE	BIT(12)
+#define XGBE_PMA_RX_VALID_0_DISABLE	0x0000
+
+#define XGBE_PMA_RX_AD_REQ_MASK		BIT(12)
+#define XGBE_PMA_RX_AD_REQ_ENABLE	BIT(12)
+#define XGBE_PMA_RX_AD_REQ_DISABLE	0x0000
+
+#define XGBE_PMA_RX_ADPT_ACK_MASK	BIT(12)
+#define XGBE_PMA_RX_ADPT_ACK		BIT(12)
+
+#define XGBE_PMA_CFF_UPDTM1_VLD		BIT(8)
+#define XGBE_PMA_CFF_UPDT0_VLD		BIT(9)
+#define XGBE_PMA_CFF_UPDT1_VLD		BIT(10)
+#define XGBE_PMA_CFF_UPDT_MASK		(XGBE_PMA_CFF_UPDTM1_VLD |\
+					 XGBE_PMA_CFF_UPDT0_VLD | \
+					 XGBE_PMA_CFF_UPDT1_VLD)
+
 #define XGBE_PMA_PLL_CTRL_MASK		BIT(15)
 #define XGBE_PMA_PLL_CTRL_ENABLE	BIT(15)
 #define XGBE_PMA_PLL_CTRL_DISABLE	0x0000
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index eea06e07b4a0..7d88caa4e623 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -388,6 +388,9 @@ struct xgbe_phy_data {
 static DEFINE_MUTEX(xgbe_phy_comm_lock);
 
 static enum xgbe_an_mode xgbe_phy_an_mode(struct xgbe_prv_data *pdata);
+static void xgbe_phy_rrc(struct xgbe_prv_data *pdata);
+static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
+					unsigned int cmd, unsigned int sub_cmd);
 
 static int xgbe_phy_i2c_xfer(struct xgbe_prv_data *pdata,
 			     struct xgbe_i2c_op *i2c_op)
@@ -2038,6 +2041,93 @@ static void xgbe_phy_set_redrv_mode(struct xgbe_prv_data *pdata)
 	xgbe_phy_put_comm_ownership(pdata);
 }
 
+#define MAX_RX_ADAPT_RETRIES		1
+#define XGBE_PMA_RX_VAL_SIG_MASK	(XGBE_PMA_RX_SIG_DET_0_MASK | \
+					 XGBE_PMA_RX_VALID_0_MASK)
+
+static void xgbe_set_rx_adap_mode(struct xgbe_prv_data *pdata,
+				  enum xgbe_mode mode)
+{
+	if (pdata->rx_adapt_retries++ >= MAX_RX_ADAPT_RETRIES) {
+		pdata->rx_adapt_retries = 0;
+		return;
+	}
+
+	xgbe_phy_perform_ratechange(pdata,
+				    mode == XGBE_MODE_KR ?
+				    XGBE_MB_CMD_SET_10G_KR :
+				    XGBE_MB_CMD_SET_10G_SFI,
+				    XGBE_MB_SUBCMD_RX_ADAP);
+}
+
+static void xgbe_rx_adaptation(struct xgbe_prv_data *pdata)
+{
+	struct xgbe_phy_data *phy_data = pdata->phy_data;
+	unsigned int reg;
+
+	/* step 2: force PCS to send RX_ADAPT Req to PHY */
+	XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_PMA_RX_EQ_CTRL4,
+			 XGBE_PMA_RX_AD_REQ_MASK, XGBE_PMA_RX_AD_REQ_ENABLE);
+
+	/* Step 3: Wait for RX_ADAPT ACK from the PHY */
+	msleep(200);
+
+	/* Software polls for coefficient update command (given by local PHY) */
+	reg = XMDIO_READ(pdata, MDIO_MMD_PMAPMD, MDIO_PMA_PHY_RX_EQ_CEU);
+
+	/* Clear the RX_AD_REQ bit */
+	XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_PMA_RX_EQ_CTRL4,
+			 XGBE_PMA_RX_AD_REQ_MASK, XGBE_PMA_RX_AD_REQ_DISABLE);
+
+	/* Check if coefficient update command is set */
+	if ((reg & XGBE_PMA_CFF_UPDT_MASK) != XGBE_PMA_CFF_UPDT_MASK)
+		goto set_mode;
+
+	/* Step 4: Check for Block lock */
+
+	/* Link status is latched low, so read once to clear
+	 * and then read again to get current state
+	 */
+	reg = XMDIO_READ(pdata, MDIO_MMD_PCS, MDIO_STAT1);
+	reg = XMDIO_READ(pdata, MDIO_MMD_PCS, MDIO_STAT1);
+	if (reg & MDIO_STAT1_LSTATUS) {
+		/* If the block lock is found, update the helpers
+		 * and declare the link up
+		 */
+		netif_dbg(pdata, link, pdata->netdev, "Block_lock done");
+		pdata->rx_adapt_done = true;
+		pdata->mode_set = false;
+		return;
+	}
+
+set_mode:
+	xgbe_set_rx_adap_mode(pdata, phy_data->cur_mode);
+}
+
+static void xgbe_phy_rx_adaptation(struct xgbe_prv_data *pdata)
+{
+	unsigned int reg;
+
+rx_adapt_reinit:
+	reg = XMDIO_READ_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_PMA_RX_LSTS,
+			      XGBE_PMA_RX_VAL_SIG_MASK);
+
+	/* step 1: Check for RX_VALID && LF_SIGDET */
+	if ((reg & XGBE_PMA_RX_VAL_SIG_MASK) != XGBE_PMA_RX_VAL_SIG_MASK) {
+		netif_dbg(pdata, link, pdata->netdev,
+			  "RX_VALID or LF_SIGDET is unset, issue rrc");
+		xgbe_phy_rrc(pdata);
+		if (pdata->rx_adapt_retries++ >= MAX_RX_ADAPT_RETRIES) {
+			pdata->rx_adapt_retries = 0;
+			return;
+		}
+		goto rx_adapt_reinit;
+	}
+
+	/* perform rx adaptation */
+	xgbe_rx_adaptation(pdata);
+}
+
 static void xgbe_phy_rx_reset(struct xgbe_prv_data *pdata)
 {
 	int reg;
@@ -2103,7 +2193,7 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 	wait = XGBE_RATECHANGE_COUNT;
 	while (wait--) {
 		if (!XP_IOREAD_BITS(pdata, XP_DRIVER_INT_RO, STATUS))
-			goto reenable_pll;
+			goto do_rx_adaptation;
 
 		usleep_range(1000, 2000);
 	}
@@ -2113,6 +2203,20 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 
 	/* Reset on error */
 	xgbe_phy_rx_reset(pdata);
+	goto reenable_pll;
+
+do_rx_adaptation:
+	if (pdata->en_rx_adap && sub_cmd == XGBE_MB_SUBCMD_RX_ADAP &&
+	    (cmd == XGBE_MB_CMD_SET_10G_KR || cmd == XGBE_MB_CMD_SET_10G_SFI)) {
+		netif_dbg(pdata, link, pdata->netdev,
+			  "Enabling RX adaptation\n");
+		pdata->mode_set = true;
+		xgbe_phy_rx_adaptation(pdata);
+		/* return from here to avoid enabling PLL ctrl
+		 * during adaptation phase
+		 */
+		return;
+	}
 
 reenable_pll:
 	/* Enable PLL re-initialization, not needed for PHY Power Off and RRC cmds */
@@ -2141,6 +2245,31 @@ static void xgbe_phy_power_off(struct xgbe_prv_data *pdata)
 	netif_dbg(pdata, link, pdata->netdev, "phy powered off\n");
 }
 
+static bool enable_rx_adap(struct xgbe_prv_data *pdata, enum xgbe_mode mode)
+{
+	struct xgbe_phy_data *phy_data = pdata->phy_data;
+	unsigned int ver;
+
+	/* Rx-Adaptation is not supported on older platforms(< 0x30H) */
+	ver = XGMAC_GET_BITS(pdata->hw_feat.version, MAC_VR, SNPSVER);
+	if (ver < 0x30)
+		return false;
+
+	/* Re-driver models 4223 && 4227 do not support Rx-Adaptation */
+	if (phy_data->redrv &&
+	    (phy_data->redrv_model == XGBE_PHY_REDRV_MODEL_4223 ||
+	     phy_data->redrv_model == XGBE_PHY_REDRV_MODEL_4227))
+		return false;
+
+	/* 10G KR mode with AN does not support Rx-Adaptation */
+	if (mode == XGBE_MODE_KR &&
+	    phy_data->port_mode != XGBE_PORT_MODE_BACKPLANE_NO_AUTONEG)
+		return false;
+
+	pdata->en_rx_adap = 1;
+	return true;
+}
+
 static void xgbe_phy_sfi_mode(struct xgbe_prv_data *pdata)
 {
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
@@ -2149,7 +2278,12 @@ static void xgbe_phy_sfi_mode(struct xgbe_prv_data *pdata)
 
 	/* 10G/SFI */
 	if (phy_data->sfp_cable != XGBE_SFP_CABLE_PASSIVE) {
+		pdata->en_rx_adap = 0;
 		xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_SET_10G_SFI, XGBE_MB_SUBCMD_ACTIVE);
+	} else if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE) &&
+		   (enable_rx_adap(pdata, XGBE_MODE_SFI))) {
+		xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_SET_10G_SFI,
+					    XGBE_MB_SUBCMD_RX_ADAP);
 	} else {
 		if (phy_data->sfp_cable_len <= 1)
 			xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_SET_10G_SFI,
@@ -2230,7 +2364,12 @@ static void xgbe_phy_kr_mode(struct xgbe_prv_data *pdata)
 	xgbe_phy_set_redrv_mode(pdata);
 
 	/* 10G/KR */
-	xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_SET_10G_KR, XGBE_MB_SUBCMD_NONE);
+	if (enable_rx_adap(pdata, XGBE_MODE_KR))
+		xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_SET_10G_KR,
+					    XGBE_MB_SUBCMD_RX_ADAP);
+	else
+		xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_SET_10G_KR,
+					    XGBE_MB_SUBCMD_NONE);
 
 	phy_data->cur_mode = XGBE_MODE_KR;
 
@@ -2743,8 +2882,11 @@ static int xgbe_phy_link_status(struct xgbe_prv_data *pdata, int *an_restart)
 			return 0;
 		}
 
-		if (phy_data->sfp_mod_absent || phy_data->sfp_rx_los)
+		if (phy_data->sfp_mod_absent || phy_data->sfp_rx_los) {
+			if (pdata->en_rx_adap)
+				pdata->rx_adapt_done = false;
 			return 0;
+		}
 	}
 
 	if (phy_data->phydev) {
@@ -2766,7 +2908,29 @@ static int xgbe_phy_link_status(struct xgbe_prv_data *pdata, int *an_restart)
 	 */
 	reg = XMDIO_READ(pdata, MDIO_MMD_PCS, MDIO_STAT1);
 	reg = XMDIO_READ(pdata, MDIO_MMD_PCS, MDIO_STAT1);
-	if (reg & MDIO_STAT1_LSTATUS)
+
+	if (pdata->en_rx_adap) {
+		/* if the link is available and adaptation is done,
+		 * declare link up
+		 */
+		if ((reg & MDIO_STAT1_LSTATUS) && pdata->rx_adapt_done)
+			return 1;
+		/* If either link is not available or adaptation is not done,
+		 * retrigger the adaptation logic. (if the mode is not set,
+		 * then issue mailbox command first)
+		 */
+		if (pdata->mode_set) {
+			xgbe_phy_rx_adaptation(pdata);
+		} else {
+			pdata->rx_adapt_done = false;
+			xgbe_phy_set_mode(pdata, phy_data->cur_mode);
+		}
+
+		/* check again for the link and adaptation status */
+		reg = XMDIO_READ(pdata, MDIO_MMD_PCS, MDIO_STAT1);
+		if ((reg & MDIO_STAT1_LSTATUS) && pdata->rx_adapt_done)
+			return 1;
+	} else if (reg & MDIO_STAT1_LSTATUS)
 		return 1;
 
 	if (pdata->phy.autoneg == AUTONEG_ENABLE &&
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index 16e73df3e9b9..ad136ed493ed 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -625,6 +625,7 @@ enum xgbe_mb_cmd {
 
 enum xgbe_mb_subcmd {
 	XGBE_MB_SUBCMD_NONE = 0,
+	XGBE_MB_SUBCMD_RX_ADAP,
 
 	/* 10GbE SFP subcommands */
 	XGBE_MB_SUBCMD_ACTIVE = 0,
@@ -1316,6 +1317,10 @@ struct xgbe_prv_data {
 
 	bool debugfs_an_cdr_workaround;
 	bool debugfs_an_cdr_track_early;
+	bool en_rx_adap;
+	int rx_adapt_retries;
+	bool rx_adapt_done;
+	bool mode_set;
 };
 
 /* Function prototypes*/
-- 
2.25.1

