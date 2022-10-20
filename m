Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC6960577E
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 08:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiJTGnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 02:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiJTGnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 02:43:18 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2068.outbound.protection.outlook.com [40.107.100.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0823412909E
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 23:43:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1Cpqipk/34jshL9yBRvUOtKHwh94ujMSHTKbvUs/bITxcxjHKG9ve3ja872Zwb9cY3CG6Nw8vEwqX8kkVCQHS4bTukKd1PfE3b2Lw317Mg/aFQwI46ceJzWXD5oRad1i8nDrRohBtuz46cSB5tbrN4VodeDhyDva/bvKGtYL1bRHLhvsjorUUbS52h7RScgYxJejr8C+aDGSj01fGp2eozY1D1e1fsXHHlk2MM287ouIErKE9TmpkkWlgjxq9mzlUrdByZ+QfMGw9g/ygEd2kqmUbxkSwQOfr9jCdR0R+KSMLcl2IZlFeZ4hbNC2KaVQXJ04hQocGxRDtxyjnGpfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGlSxQPXyzrUzd+jYSzF6choFX6TtKm4HvOKGJ9qOf4=;
 b=O1F2CCluNT1fZ2e8zLbJaXP/y69VSctrdwbM4mo7CT9skk+eKK35waVUbWXr/ZOvJFcNJC3nMoaNTWLyG+JlicvGYAwW+msgmzdxnA2YWxAxrOkgVR/gzIHadzgYX+N4gJRJgQCVZTaf1eKyw+9z9En/SjA/ifavwIAhPF7KHIRUejEYth03AChKAmDDlh0Jd5y1FCNyXGuiSBxOKt0k8p3rUdN/2gt/2lXQi1XketxUPiRfa5pXL45pW/vygZuPIdf52/yLmc3tUF2fOCI85PTGOwyrT03l/KKMIA2QANxqA1VEFWZ8oGRu7btPnvqPNDfNWEXNmm13bdyzWPgXvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGlSxQPXyzrUzd+jYSzF6choFX6TtKm4HvOKGJ9qOf4=;
 b=4NuvrBpbI5K4VsSkoNmYhr7GG24XkQLGh7lZTuN8W5ZGfHQycFWdhbmAetwTiiMMyaEjY7Nq+uhYKStSIychzXrgim/KdWN/U+NOuaoHSDfXqTYQQtX5WKFnEKFoN6kmQDxnjJ9bG19z8u8VpwWqoXFqx9rGZSCRaH+hCvmNf98=
Received: from DM6PR03CA0074.namprd03.prod.outlook.com (2603:10b6:5:333::7) by
 PH8PR12MB7157.namprd12.prod.outlook.com (2603:10b6:510:22b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.34; Thu, 20 Oct 2022 06:43:14 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::13) by DM6PR03CA0074.outlook.office365.com
 (2603:10b6:5:333::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34 via Frontend
 Transport; Thu, 20 Oct 2022 06:43:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Thu, 20 Oct 2022 06:43:13 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 20 Oct
 2022 01:43:11 -0500
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Rajesh1.Kumar@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH v3 net 2/5] amd-xgbe: use enums for mailbox cmd and sub_cmds
Date:   Thu, 20 Oct 2022 12:12:12 +0530
Message-ID: <20221020064215.2341278-3-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221020064215.2341278-1-Raju.Rangoju@amd.com>
References: <20221020064215.2341278-1-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT033:EE_|PH8PR12MB7157:EE_
X-MS-Office365-Filtering-Correlation-Id: ad37d006-c0d6-4529-4abb-08dab2665cdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G8z607Vt6an1cy6qIF7/WJ+E0QmZnkkLD5QUAMgmaRum/mgAQUyPd3aJqeZvwmWQ7re4jfa6G8zE+lukMlK0ee1/Qigf8tTx/cx3QjGClXw6eMRX0vzfwlx37I40t8slFtMfAsZ+RKtAaaLP1LDJMMcYmkS0n9uoI5LM74f/MX5NuTVeVeiS0ZKpEPdjktQcdCoGZJPPPsgZrLVQ1kEVeB1MQ5gXPgehZoAnIYur3iV4HmPboXl6eylnk1NTQmnzhE9Vs3GjXifCR+wfeJmMTN7ukxOzrs/MKgJCqtOR6io9VO+mq2epczqwt8xnhfjAsmnsC1DieGA2oYjWjQWF7BApVK/A2mk2c9g73Qg7qkaIAiNSIqap4s+4wQU4qmy/OTETHUBnz2oHDAxwLI1Imc/gSVt/kpKJbyekDxuE5QDaeJhmDErjptgIrS6sTfABSrquHNTf5moftx4v7z7TdrrL7TODhcqujgeST+YKtmIpn63TYwtmMei9miec/0KO9g0gCrJrzK8qSvYO9atdshzUTPWjHMxQJ3lAHW5M35IbjEydX8jPaZkMJK20Z+it8pFGoH3BFGeuJn6merZAwDiI/QHh5dykcPA/JOpwYQC3PUxrek9XBsfylE9FJm/uc/U4IxhwN5EhLbMy+T/ws0EjmsspyU73BsU2XIxrGTwJphTfeCSSq3SIicXUeqTsLSw2icLCcWcLp1qB0dPHBOwWIG7E9NdUARJW5xhNWVkKwXk+vNsmDepErws2GeXHynC3lLqw8NSalBjJNlB0/dhBI7oWpUOkpixiB082OqaAJKW03DEbXQLhYivPLE4z
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(81166007)(2906002)(356005)(186003)(1076003)(16526019)(2616005)(15650500001)(82310400005)(478600001)(40460700003)(54906003)(426003)(86362001)(8676002)(47076005)(4326008)(110136005)(40480700001)(82740400003)(36860700001)(8936002)(26005)(7696005)(70206006)(36756003)(41300700001)(83380400001)(316002)(70586007)(336012)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 06:43:13.9849
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad37d006-c0d6-4529-4abb-08dab2665cdb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7157
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using hardcoded values, use enumerations for mailbox command
and sub commands.

Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 29 ++++++++++++---------
 drivers/net/ethernet/amd/xgbe/xgbe.h        | 25 ++++++++++++++++++
 2 files changed, 41 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 19b943eba560..8cf5d81fca36 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1989,7 +1989,7 @@ static void xgbe_phy_pll_ctrl(struct xgbe_prv_data *pdata, bool enable)
 }
 
 static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
-					unsigned int cmd, unsigned int sub_cmd)
+					enum xgbe_mb_cmd cmd, enum xgbe_mb_subcmd sub_cmd)
 {
 	unsigned int s0 = 0;
 	unsigned int wait;
@@ -2036,7 +2036,7 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 static void xgbe_phy_rrc(struct xgbe_prv_data *pdata)
 {
 	/* Receiver Reset Cycle */
-	xgbe_phy_perform_ratechange(pdata, 5, 0);
+	xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_RRC, XGBE_MB_SUBCMD_NONE);
 
 	netif_dbg(pdata, link, pdata->netdev, "receiver reset complete\n");
 }
@@ -2046,7 +2046,7 @@ static void xgbe_phy_power_off(struct xgbe_prv_data *pdata)
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
 
 	/* Power off */
-	xgbe_phy_perform_ratechange(pdata, 0, 0);
+	xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_POWER_OFF, XGBE_MB_SUBCMD_NONE);
 
 	phy_data->cur_mode = XGBE_MODE_UNKNOWN;
 
@@ -2061,14 +2061,17 @@ static void xgbe_phy_sfi_mode(struct xgbe_prv_data *pdata)
 
 	/* 10G/SFI */
 	if (phy_data->sfp_cable != XGBE_SFP_CABLE_PASSIVE) {
-		xgbe_phy_perform_ratechange(pdata, 3, 0);
+		xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_SET_10G_SFI, XGBE_MB_SUBCMD_ACTIVE);
 	} else {
 		if (phy_data->sfp_cable_len <= 1)
-			xgbe_phy_perform_ratechange(pdata, 3, 1);
+			xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_SET_10G_SFI,
+						    XGBE_MB_SUBCMD_PASSIVE_1M);
 		else if (phy_data->sfp_cable_len <= 3)
-			xgbe_phy_perform_ratechange(pdata, 3, 2);
+			xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_SET_10G_SFI,
+						    XGBE_MB_SUBCMD_PASSIVE_3M);
 		else
-			xgbe_phy_perform_ratechange(pdata, 3, 3);
+			xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_SET_10G_SFI,
+						    XGBE_MB_SUBCMD_PASSIVE_OTHER);
 	}
 
 	phy_data->cur_mode = XGBE_MODE_SFI;
@@ -2083,7 +2086,7 @@ static void xgbe_phy_x_mode(struct xgbe_prv_data *pdata)
 	xgbe_phy_set_redrv_mode(pdata);
 
 	/* 1G/X */
-	xgbe_phy_perform_ratechange(pdata, 1, 3);
+	xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_SET_1G, XGBE_MB_SUBCMD_1G_KX);
 
 	phy_data->cur_mode = XGBE_MODE_X;
 
@@ -2097,7 +2100,7 @@ static void xgbe_phy_sgmii_1000_mode(struct xgbe_prv_data *pdata)
 	xgbe_phy_set_redrv_mode(pdata);
 
 	/* 1G/SGMII */
-	xgbe_phy_perform_ratechange(pdata, 1, 2);
+	xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_SET_1G, XGBE_MB_SUBCMD_1G_SGMII);
 
 	phy_data->cur_mode = XGBE_MODE_SGMII_1000;
 
@@ -2111,7 +2114,7 @@ static void xgbe_phy_sgmii_100_mode(struct xgbe_prv_data *pdata)
 	xgbe_phy_set_redrv_mode(pdata);
 
 	/* 100M/SGMII */
-	xgbe_phy_perform_ratechange(pdata, 1, 1);
+	xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_SET_1G, XGBE_MB_SUBCMD_100MBITS);
 
 	phy_data->cur_mode = XGBE_MODE_SGMII_100;
 
@@ -2125,7 +2128,7 @@ static void xgbe_phy_kr_mode(struct xgbe_prv_data *pdata)
 	xgbe_phy_set_redrv_mode(pdata);
 
 	/* 10G/KR */
-	xgbe_phy_perform_ratechange(pdata, 4, 0);
+	xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_SET_10G_KR, XGBE_MB_SUBCMD_NONE);
 
 	phy_data->cur_mode = XGBE_MODE_KR;
 
@@ -2139,7 +2142,7 @@ static void xgbe_phy_kx_2500_mode(struct xgbe_prv_data *pdata)
 	xgbe_phy_set_redrv_mode(pdata);
 
 	/* 2.5G/KX */
-	xgbe_phy_perform_ratechange(pdata, 2, 0);
+	xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_SET_2_5G, XGBE_MB_SUBCMD_NONE);
 
 	phy_data->cur_mode = XGBE_MODE_KX_2500;
 
@@ -2153,7 +2156,7 @@ static void xgbe_phy_kx_1000_mode(struct xgbe_prv_data *pdata)
 	xgbe_phy_set_redrv_mode(pdata);
 
 	/* 1G/KX */
-	xgbe_phy_perform_ratechange(pdata, 1, 3);
+	xgbe_phy_perform_ratechange(pdata, XGBE_MB_CMD_SET_1G, XGBE_MB_SUBCMD_1G_KX);
 
 	phy_data->cur_mode = XGBE_MODE_KX_1000;
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index 49d23abce73d..71f24cb47935 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -611,6 +611,31 @@ enum xgbe_mdio_mode {
 	XGBE_MDIO_MODE_CL45,
 };
 
+enum xgbe_mb_cmd {
+	XGBE_MB_CMD_POWER_OFF = 0,
+	XGBE_MB_CMD_SET_1G,
+	XGBE_MB_CMD_SET_2_5G,
+	XGBE_MB_CMD_SET_10G_SFI,
+	XGBE_MB_CMD_SET_10G_KR,
+	XGBE_MB_CMD_RRC
+};
+
+enum xgbe_mb_subcmd {
+	XGBE_MB_SUBCMD_NONE = 0,
+
+	/* 10GbE SFP subcommands */
+	XGBE_MB_SUBCMD_ACTIVE = 0,
+	XGBE_MB_SUBCMD_PASSIVE_1M,
+	XGBE_MB_SUBCMD_PASSIVE_3M,
+	XGBE_MB_SUBCMD_PASSIVE_OTHER,
+
+	/* 1GbE Mode subcommands */
+	XGBE_MB_SUBCMD_10MBITS = 0,
+	XGBE_MB_SUBCMD_100MBITS,
+	XGBE_MB_SUBCMD_1G_SGMII,
+	XGBE_MB_SUBCMD_1G_KX
+};
+
 struct xgbe_phy {
 	struct ethtool_link_ksettings lks;
 
-- 
2.25.1

