Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3014604F89
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiJSSVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiJSSVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:21:48 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598AA1BE416
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:21:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFKQVm5HUZP3es2B4yBG5Lfe70JG1Va6FktZIaffeeZ+gJ0XB0PzuJdrijAuCNk7bDZ39e5LUmBMhIpmbfTP+Vway3tZY39WUeOAYkUplrOJB9JfB0WPFZF9oVPsBIZJiKcFh4MO1eJYsiDmSgxp9YenyEIpuGEEtR7sAf6mpWwhADFxXrXl64Fzqez8O3lI0m0GIb0jzEFmxMNvZyCwPBgOVLL/9ovKYJvd5L4erOIPshve8+SNrKRsJxqEkLCJRGgISm5H+9EnSoD84itTqK7YdD1Bn1ym2pR3bV2XtlPqvSrfesb0r7WtTbdtF02F+1cp9uKkGL5jDbjNi6Uf1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGlSxQPXyzrUzd+jYSzF6choFX6TtKm4HvOKGJ9qOf4=;
 b=AhQJgCqO3qebOxVmkksEHD9qUgAq/ClX1jPBmp0X6Bp9a+EhxZ3H8Y6TU9+yIvzxQAtupWZTP7zvTs/Cqkp+bB51gwLMSe0tUJ4Nl8J7MRsge9vdsyW8ylITlEB2jC4S+yAEtSnGc60MAnrWrnUe/W4OLAipI98IRHg+GVXX8eZfbO9HiMT099ieTWdGAk6Pm3LPYxNT81Q8f8aTNnpTSbWEMMoArFzUOUCL1DxJdlc5+9jcSEFuTmoPDJ5ixsO0j5qIzWeZ4p2OQE1ZPmaMFM25LxFUiHW8AhgMinvwGXSWaE3EveQs43zRKGZSQW5yECiwkIA6yry4GjV3sXgRtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGlSxQPXyzrUzd+jYSzF6choFX6TtKm4HvOKGJ9qOf4=;
 b=B7zib8316e1SpE7wo6V3aL5/d++EraNir3zF5PJbDOr//nK7CClN3/CG0iGU4S1hT8dfsggxX7huYTumoV/6EnmcU+86rjMq2Lc4NbjSf5ivZUaTr3TA0KF8yyLT+4ihntO23b0pr5Ofqdrwqeb7TES8Tv3R//4kJDtlBuFyAcA=
Received: from MW4PR03CA0062.namprd03.prod.outlook.com (2603:10b6:303:b6::7)
 by DM4PR12MB6256.namprd12.prod.outlook.com (2603:10b6:8:a3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.20; Wed, 19 Oct 2022 18:21:45 +0000
Received: from CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::c4) by MW4PR03CA0062.outlook.office365.com
 (2603:10b6:303:b6::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34 via Frontend
 Transport; Wed, 19 Oct 2022 18:21:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT082.mail.protection.outlook.com (10.13.175.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Wed, 19 Oct 2022 18:21:44 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 19 Oct
 2022 13:21:41 -0500
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <thomas.lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>
CC:     <netdev@vger.kernel.org>, <rajesh1.kumar@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH v2 net 2/5] amd-xgbe: use enums for mailbox cmd and sub_cmds
Date:   Wed, 19 Oct 2022 23:50:18 +0530
Message-ID: <20221019182021.2334783-3-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221019182021.2334783-1-Raju.Rangoju@amd.com>
References: <20221019182021.2334783-1-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT082:EE_|DM4PR12MB6256:EE_
X-MS-Office365-Filtering-Correlation-Id: 721182cd-c77b-4d34-9709-08dab1fec75f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: smsnQQuuux/pPSZ3QV1x8JD9H7W0ye7nu24bdr2XK1ZZzHBnMF3U8i8k/ew0Y+P5ox81VQjcTejhVNSRsaKH1TxrMKswq2Rq+89TpbATMny7+nslOOhuB/vT+JSAbAL7CWrY585lwJ/U1INnqMy0bCxo6DBNqUuAXnB78Wt8ze0KlW8u9CROuEvhHDP/EYz+xo7b0TALXBZzZvlLr1Tbf8owPr5Xq+rSVK1LzFj3X6/6sYDvZZmx9bBgICiStxb+VCXwLeTyi+PYWFzXxEqgsVscomPWxLSpQjSmUy5i0gQkMGCjAbRkCHHAvq5VMFVXLPVUEJNLRs3l7XvMt8Dfrgpe0EGDsbVkZFMo3d2H52W6J4th27Zj8aDLQyrmtaZi9vsn2YnQNt++uHKU7gOda+tfGLWmAn1h5Gz3qiv0jbStHYMQRp6dg3utjTbulLcwUYvqZa2Z0BjkkX1e3oOEdIA0F4Q/OqN6l86VWn5v/1P0GP2dGPATXXyk53UEydH8Muquhn/l0N2IrNZ4/C17RgJ9a7iFzaXR/M4VoPZ3jpoOlXOcdCRvXUirrw0xAnt3N7MNh84hDzLo/LhhLvGZnlLbnbJfL85h3pZrtMaZ1hOwgnX4n16hJzBBgisKmm0Hj0bhbSqhN0QWgq7SYWCTjUpqRP1XK0qGYscLl0ZGrg4M5QHH63Hx6YbLXqKll2ycVjp1UI2UwEOMuvL3b7DnU3e0aAZds5S0zXvCxNPU8NFqYHD/912+lHpMVTfANfOydegSuRsrExgNdv1vgXPMGma0g1MFsVrjFuPFuaSepsMIP0alq2AY89mGa+Grjj9K
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(6636002)(186003)(2616005)(36860700001)(1076003)(83380400001)(7696005)(6666004)(426003)(47076005)(26005)(336012)(40460700003)(16526019)(2906002)(15650500001)(5660300002)(40480700001)(316002)(41300700001)(110136005)(82310400005)(8936002)(478600001)(8676002)(4326008)(70586007)(70206006)(54906003)(36756003)(86362001)(82740400003)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 18:21:44.9367
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 721182cd-c77b-4d34-9709-08dab1fec75f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6256
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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

