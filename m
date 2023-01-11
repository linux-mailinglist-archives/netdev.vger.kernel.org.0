Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19061666201
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 18:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbjAKRdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 12:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbjAKRdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 12:33:18 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2053.outbound.protection.outlook.com [40.107.102.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542DB64DA
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 09:31:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iE0ZU26eurI7XcPqNnMhJMXKAYLQbKGnIrR7DrVs+Hc//ijibEP/JY0ijkYYiGwo5ltA6YGcZcnyJQmPgBH1uyntK7Z/k4iEFR/7VGCriOkP28n7eJqeA2bCUD8JN6s+hx6jDvv21gfmH8pY4xbBOettBe9X3dco1T2M2cgKwAmlYyx2Wn09o8T/+8AMv+NB1Gpte/WxEi1KpyyHG7taJuaXG+SVEVfC6R1D2aG5/d8P1tqaix9sBQJazrWChidWLz3iDzVb26E1XsfveB/FP7MDsb++g6RKaQhaPSfRV6Dc305Vj3Y2tp8H1QnJ613JqBkVkzwTmgVBzwvovegWTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3nMgDf7WUQnkdRSR1/gJhF3mV2jgIA96szQzdvXEZv4=;
 b=jfj5IbGiKQcS+2Mf+vsIvN96lUVJ9S68mDuX4qDpqsctWR+r/KyBvbaUo4aSz3PFppR53ivwnD3aEsbfjX3Q4GAOTtgBIfUMTK2uGNdMHoy3/DvK+HKeteRgg6BDPPJQCq1NULuyTGXFeSeJ0Pec4hErtDEPSK9EXpBZtZlKj1sm27XfqzXl8rx5DmcXKDYASSQYXTlJOV8asl8bnd+g40ChGyfVsHGBtoVNfdyxsDe+Dve3Vrcw6yzZ01hBPYG9YCYYUdMwob46VnCf/NDffn2Po1DqwqRflzJ2iFXOqLXX1NH7V0xvMY6RUOFtN/EDbDTQUwxM1RfM8tZjGAFzmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nMgDf7WUQnkdRSR1/gJhF3mV2jgIA96szQzdvXEZv4=;
 b=QQNgvazLKk4R5DB3OrQQqHPZ987birNnEgl8vQBKA6u2SxWGSMEDlb8HqTRxpuxGrvyJr0Gk3rn0tKS0yFTXxLAjIpzSYsKqnfRQrHH4KTrWY8NgjJ8lw1n8g93NOd+fAPSijFXf0A4fhNlrVYXjKkS/oKF6pbgZeyoqX+JQhBk=
Received: from MW4PR03CA0200.namprd03.prod.outlook.com (2603:10b6:303:b8::25)
 by SJ1PR12MB6100.namprd12.prod.outlook.com (2603:10b6:a03:45d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 11 Jan
 2023 17:30:59 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::e6) by MW4PR03CA0200.outlook.office365.com
 (2603:10b6:303:b8::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13 via Frontend
 Transport; Wed, 11 Jan 2023 17:30:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5986.18 via Frontend Transport; Wed, 11 Jan 2023 17:30:59 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 11 Jan
 2023 11:30:19 -0600
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <Shyam-sundar.S-k@amd.com>,
        <Raju.Rangoju@amd.com>, Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: [PATCH net 2/2] amd-xgbe: Delay AN timeout during KR training
Date:   Wed, 11 Jan 2023 22:58:52 +0530
Message-ID: <20230111172852.1875384-3-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230111172852.1875384-1-Raju.Rangoju@amd.com>
References: <20230111172852.1875384-1-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT028:EE_|SJ1PR12MB6100:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f21d6bc-4683-43d7-220e-08daf3f99a89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RsFtkTaW0fqcBMbQu1aXYBsQg7nUfvqoeS3DgtC0j+E0/jSXLJX9/Z4hqxQ8lqMED38Pk9KrBwRQN9hjALdmvsh886baiBFRsMtCRNWC7RmJsWK4CqAWgcT3CNNO5X8whHEewvDWcjW9S6P+U/VvO5xOgQoZaop/1xaFTmjZpvsICnk4AaYyddE6+p6sZdtP3cRKJf3zt7cuOoW9PXdFAxcXN9fXUFw4+Gd/YuFJNPligLnd81HSSaxkuFE/l4TRas4tfc6+YQ4FLrCSp00zURPPhLaHHqE+ZpEoNTwGb3Q+aAyPGwurnAY2KiqOVjb8om3/VC9JZkzPb0+kQgp5IEasS+t9DgK9dtGpafMn8Ux7Htn+/kpNmr5LWbQmKDiijUFGyqAsFq0b2SL1b6sfgfZ9plE6Q46UYxkJAc3RyILv/kAQTLjlklAu6XX/KSIfOkFX/i5GQK+ir6CpJ121YOCUILar9l9jw7cwXOzH7l/ntxIbnd/LgSCPxod8mepUpaOR46aKqUNGwlHkzBdWhuMvLOSXsXDcACEyXxhWZpwE0RdUA+UKTJRfLfY9VUnVtKECLQzijBW9fGWo8hRV9qig1vVIw4n+cYrNcuDau5o6DPWsdu1LyamSckrBmUzSooAZBFhDo5ZQjdTN0TbXghPNxWrPDlVYqHx4N4lja0Z6Xp2MbTccU8WhuAP4HIfaTByTnZ4Sd6sepSutXWczHQCbuuvMP63jfbESAlELCLE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199015)(46966006)(36840700001)(40470700004)(82740400003)(426003)(41300700001)(356005)(81166007)(478600001)(47076005)(86362001)(1076003)(40460700003)(316002)(54906003)(2616005)(70586007)(336012)(26005)(40480700001)(7696005)(82310400005)(186003)(8676002)(4326008)(6916009)(16526019)(36756003)(70206006)(5660300002)(6666004)(36860700001)(2906002)(8936002)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 17:30:59.0025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f21d6bc-4683-43d7-220e-08daf3f99a89
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AN restart triggered during KR training not only aborts the KR training
process but also move the HW to unstable state. Driver has to wait upto
500ms or until the KR training is completed before restarting AN cycle.

Fixes: 7c12aa08779c ("amd-xgbe: Move the PHY support into amd-xgbe")
Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 24 +++++++++++++++++++++++
 drivers/net/ethernet/amd/xgbe/xgbe.h      |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 0c5c1b155683..43fdd111235a 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -496,6 +496,7 @@ static enum xgbe_an xgbe_an73_tx_training(struct xgbe_prv_data *pdata,
 	reg |= XGBE_KR_TRAINING_ENABLE;
 	reg |= XGBE_KR_TRAINING_START;
 	XMDIO_WRITE(pdata, MDIO_MMD_PMAPMD, MDIO_PMA_10GBR_PMD_CTRL, reg);
+	pdata->kr_start_time = jiffies;
 
 	netif_dbg(pdata, link, pdata->netdev,
 		  "KR training initiated\n");
@@ -632,6 +633,8 @@ static enum xgbe_an xgbe_an73_incompat_link(struct xgbe_prv_data *pdata)
 
 	xgbe_switch_mode(pdata);
 
+	pdata->an_result = XGBE_AN_READY;
+
 	xgbe_an_restart(pdata);
 
 	return XGBE_AN_INCOMPAT_LINK;
@@ -1275,9 +1278,30 @@ static bool xgbe_phy_aneg_done(struct xgbe_prv_data *pdata)
 static void xgbe_check_link_timeout(struct xgbe_prv_data *pdata)
 {
 	unsigned long link_timeout;
+	unsigned long kr_time;
+	int wait;
 
 	link_timeout = pdata->link_check + (XGBE_LINK_TIMEOUT * HZ);
 	if (time_after(jiffies, link_timeout)) {
+		if ((xgbe_cur_mode(pdata) == XGBE_MODE_KR) &&
+		    pdata->phy.autoneg == AUTONEG_ENABLE) {
+			/* AN restart should not happen while KR training is in progress.
+			 * The while loop ensures no AN restart during KR training,
+			 * waits up to 500ms and AN restart is triggered only if KR
+			 * training is failed.
+			 */
+			wait = XGBE_KR_TRAINING_WAIT_ITER;
+			while (wait--) {
+				kr_time = pdata->kr_start_time +
+					  msecs_to_jiffies(XGBE_AN_MS_TIMEOUT);
+				if (time_after(jiffies, kr_time))
+					break;
+				/* AN restart is not required, if AN result is COMPLETE */
+				if (pdata->an_result == XGBE_AN_COMPLETE)
+					return;
+				usleep_range(10000, 11000);
+			}
+		}
 		netif_dbg(pdata, link, pdata->netdev, "AN link timeout\n");
 		xgbe_phy_config_aneg(pdata);
 	}
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index 71f24cb47935..7a41367c437d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -290,6 +290,7 @@
 /* Auto-negotiation */
 #define XGBE_AN_MS_TIMEOUT		500
 #define XGBE_LINK_TIMEOUT		5
+#define XGBE_KR_TRAINING_WAIT_ITER	50
 
 #define XGBE_SGMII_AN_LINK_STATUS	BIT(1)
 #define XGBE_SGMII_AN_LINK_SPEED	(BIT(2) | BIT(3))
@@ -1280,6 +1281,7 @@ struct xgbe_prv_data {
 	unsigned int parallel_detect;
 	unsigned int fec_ability;
 	unsigned long an_start;
+	unsigned long kr_start_time;
 	enum xgbe_an_mode an_mode;
 
 	/* I2C support */
-- 
2.25.1

