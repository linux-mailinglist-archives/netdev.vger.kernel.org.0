Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9AA25F689C
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 15:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJFN4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 09:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiJFN4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 09:56:34 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2082.outbound.protection.outlook.com [40.107.237.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9C990830
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 06:56:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqsUHcGKr+8RsDCEdO7k8xVFAJ1Q12ADcj8Vp7WYkPOR+3jga8aiqvJD0adM3x5R9ZpsZAhzE+Kwii5eahOp7aYi11VO/VN5dkeKl1OilDM/k6XLFBXcj8N7auJEpcm1G2lKuWVaIeBTxYC33MgvvGaT31sLgnJqPLiVyxaAq+/88EvvQwyKWsr6vSsFJyNboIhhysTJk5C2LV++0SujETXZCLGisfoTJyrnO/ECCvOSQdrnW3v6fwQC0tHorYW5Ef6Vm2hDn44wz3un8dffsnhHUuleeOnMGODibVLDZHH/zJ7syX4/UXlhQhlV0O1NKYYKwsr58RG9oAmQT5Jebw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJTtWv/k7/+hxGHF0GtnNdwJLJdnkBq2kaXi1RVJy3k=;
 b=c5l/4E6ECZk390arAEBTTHT0Zwmndz7GIo1xZ8NAXY7sBVx9uI5suwskwlTSV/RyoloMlVuzaZRiKmmA9xK0d2iziBu6Hqrf5LYx6tvhKR5axr/O/z3Wlq9tqDVudpVw3im5VcwC3fJULItZDgqbdLsU/7R21ASI8ARaeTLXhyjwzugl4LSQGfmp08Dpe5w7HwXSVk5gh5eMm/mmNLCwvyEy1YkW8cVYg1vdGzmaTsgTazyBYVWJsMfxOLE1EaYNrqhKjOIodxSUXXNEIPS/AI1CYZqvuuBYPE2YUlkgjpaQKkOu3qdsfGcu5eHCR2VkJVl0D+QzZNM/BH3ifoNzEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJTtWv/k7/+hxGHF0GtnNdwJLJdnkBq2kaXi1RVJy3k=;
 b=gDc0vKYlk8/VyasVAilZQHyV9oKLaCgtLJVX46ACArLRg3Cp/YjpS3PVC2bOjRFOqxnQlnMjGRha5b4L8X5t/w8zAMpohsPQ7Wcwxr7mZq/Ds2mm0C0XT4A2srNBWsCv0q8cHNPCvNIArbYP4hUyRI1xDLvHlTqK7s9TiUL6cTU=
Received: from MN2PR15CA0030.namprd15.prod.outlook.com (2603:10b6:208:1b4::43)
 by BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Thu, 6 Oct
 2022 13:56:31 +0000
Received: from BL02EPF0000C407.namprd05.prod.outlook.com
 (2603:10b6:208:1b4:cafe::ff) by MN2PR15CA0030.outlook.office365.com
 (2603:10b6:208:1b4::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.34 via Frontend
 Transport; Thu, 6 Oct 2022 13:56:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0000C407.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5676.13 via Frontend Transport; Thu, 6 Oct 2022 13:56:30 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 6 Oct
 2022 08:55:53 -0500
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <rrangoju@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH net 2/3] amd-xgbe: enable PLL_CTL for fixed PHY modes only
Date:   Thu, 6 Oct 2022 19:24:39 +0530
Message-ID: <20221006135440.3680563-3-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221006135440.3680563-1-Raju.Rangoju@amd.com>
References: <20221006135440.3680563-1-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000C407:EE_|BL1PR12MB5062:EE_
X-MS-Office365-Filtering-Correlation-Id: a4cb0aa4-2179-4340-53e2-08daa7a29253
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n2ERqHtpNciihdgsBURMJgJVIhcZlemSGVfV4wW3DcoQASHas3PfgzrIt9Jt+nNzTh5yZjDgksRtQzFnvLXf8i2rZJRcL33WWsUAWpJn6Hpm19AL2jnGKLW2ke9ofH80BonQmp/vO4QAoR8Fa8sZXVrtVTVXgtdPyVwz0HOKqhYK4LwalA3XfdpCVIuZnjK7trQ553GXqUcd1C+uqwuiBSLyq6OVUB+yVqqM5K8qliWUGvdC3PRFFQYirZTyJu18cawMUpcRqqKijowLuzc1bD/2xZ/rt/WIGhdFW3abxoYnxU/nhj/WPqAhETSERi8ZUYja4Rwt4klTgw31hVFMS3pt53tAvoQ+PDjya25/6UEneg3RAT/V9LjD7z1uzRDEc7yw+/UO2B1Iez/Gs/1fbja2DMCXVW/ttHM4B5ZE0s9HrAqQlG1YnN9o3mAHN9oRWxQPYymDSQkqExLXrazVL45ZlWz6MGip2FIvA0GnHLzkkRNXP7LwsP7s+4+HoxjJsWTCt3x9tntE3XZ/qkj1S/OjNCpx5I6dEEaELkUpDWcC2sp6SUhphZ3/jUzGxrklapIuAqrVajyMt8LGKRPh6aYQm/hyWbfwWYiTxxGYYw1VNb/X1DC9rf/Oorat08f/PC5AgiZjBNMmt2/NMT1nUTnpyaKxy3XjbWRmPHTUr+1dLOkJ+Ma8FW7uEMdFoOcuUCAV0XHdUM7U8Yf8mf+6/ZHUk1O8ejC7V41twJ9h0yKFzcdbL2WRnf5Lag6OtW5tzudzrjtXkEvbMMamx/+Fl5DwZwZ6lrlAM9gms3mVXzbDKUWHRvFaEQrkJFy4zzil
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(2906002)(7696005)(36756003)(26005)(336012)(82740400003)(6666004)(40480700001)(86362001)(82310400005)(81166007)(5660300002)(478600001)(41300700001)(40460700003)(8936002)(356005)(47076005)(1076003)(186003)(426003)(2616005)(16526019)(36860700001)(83380400001)(316002)(70206006)(54906003)(110136005)(8676002)(4326008)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 13:56:30.7040
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4cb0aa4-2179-4340-53e2-08daa7a29253
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000C407.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5062
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PLL control setting(HW RRCM) is needed only in fixed PHY configuration
to fix the peer-peer issues. Without the PLL control setting, the link
up takes longer time in a fixed phy configuration.

Driver implements SW RRCM for Autoneg On configuration, hence PLL
control setting (HW RRCM) is not needed for AN On configuration, and
can be skipped.

Also, PLL re-initialization is not needed for PHY Power Off and RRCM
commands. Otherwise, they lead to mailbox errors. Added the changes
accordingly.

Fixes: daf182d360e5 ("net: amd-xgbe: Toggle PLL settings during rate change")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 21 +++++++++++++--------
 drivers/net/ethernet/amd/xgbe/xgbe.h        | 10 ++++++++++
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 19b943eba560..23fbd89a29df 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1979,13 +1979,16 @@ static void xgbe_phy_rx_reset(struct xgbe_prv_data *pdata)
 
 static void xgbe_phy_pll_ctrl(struct xgbe_prv_data *pdata, bool enable)
 {
-	XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_VEND2_PMA_MISC_CTRL0,
-			 XGBE_PMA_PLL_CTRL_MASK,
-			 enable ? XGBE_PMA_PLL_CTRL_ENABLE
-				: XGBE_PMA_PLL_CTRL_DISABLE);
+	/* PLL_CTRL feature needs to be enabled for fixed PHY modes (Non-Autoneg) only */
+	if (pdata->phy.autoneg == AUTONEG_DISABLE) {
+		XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_VEND2_PMA_MISC_CTRL0,
+				 XGBE_PMA_PLL_CTRL_MASK,
+				 enable ? XGBE_PMA_PLL_CTRL_ENABLE
+					: XGBE_PMA_PLL_CTRL_DISABLE);
 
-	/* Wait for command to complete */
-	usleep_range(100, 200);
+		/* Wait for command to complete */
+		usleep_range(100, 200);
+	}
 }
 
 static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
@@ -2029,8 +2032,10 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 	xgbe_phy_rx_reset(pdata);
 
 reenable_pll:
-	/* Enable PLL re-initialization */
-	xgbe_phy_pll_ctrl(pdata, true);
+	/* Enable PLL re-initialization, not needed for PHY Power Off cmd */
+	if (cmd != XGBE_MAILBOX_CMD_POWER_OFF &&
+	    cmd != XGBE_MAILBOX_CMD_RRCM)
+		xgbe_phy_pll_ctrl(pdata, true);
 }
 
 static void xgbe_phy_rrc(struct xgbe_prv_data *pdata)
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index 49d23abce73d..c7865681790c 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -611,6 +611,16 @@ enum xgbe_mdio_mode {
 	XGBE_MDIO_MODE_CL45,
 };
 
+enum XGBE_MAILBOX_CMD {
+	XGBE_MAILBOX_CMD_POWER_OFF	= 0,
+	XGBE_MAILBOX_CMD_SET_1G		= 1,
+	XGBE_MAILBOX_CMD_SET_2_5G	= 2,
+	XGBE_MAILBOX_CMD_SET_10G_SFI	= 3,
+	XGBE_MAILBOX_CMD_SET_10G_KR	= 4,
+	XGBE_MAILBOX_CMD_RRCM		= 5,
+	XGBE_MAILBOX_CMD_UNKNOWN	= 6
+};
+
 struct xgbe_phy {
 	struct ethtool_link_ksettings lks;
 
-- 
2.25.1

