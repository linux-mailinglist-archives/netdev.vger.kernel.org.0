Return-Path: <netdev+bounces-9863-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6DF872B006
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 04:57:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED8E21C20A96
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 02:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 794CF1365;
	Sun, 11 Jun 2023 02:57:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685E510F5
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 02:57:13 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768BF134
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 19:57:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8phS9TgwOCz/bUe8u27Wx3KmWp8VafxMGkTlIDwNeN+I5RI8r3TlcOfT5FwBEHv39O81dXLOAtIpVbOmZWs8E2NPNLWHvmKbi+XJpfMPv0IS0BeTLI/h+3pzjO/rmlAiivkNx0PgMkcChxYIYrOvTEuWBKrZFbbRNxivESgG6C36KpKFXUc6Kog2ui6B9ysQ2CDYTWW/OCbyF3ybjn1cZqrtfqjMtFuKV4Qk8lOqw7v+wUdKWqJxeWgQwxzXQLcA2xBNf42bmDpa2uILW5tzHsOLXK/+FtwQdfAjszCL2tsOt07mWaCBZWnd2Hn732T+QK6nHrK0IOk71kdlpXOnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RxLV7HLG4OsEeqsjljDofMUS6s7VxOcgNumuz33aE98=;
 b=XbPnjiiO8rO4q4sf5giMb7G92Dv3jUQta2mhPIaJyHvgMCbGwL7ZbXUGmApj3w6XTZPpVZ7VLo3RW9tEMpzIqwIe+2foPdy7MtXVXSCAb8YpMOt2EdsESPQXTrNfbi/3ZG6uTIdFfnSSfyCAbLXS/qgxz4XW4RG+/LRNRi3MFGSDcwIMVx3QWWJwg1IT2cvnHZs+kn97AfBMBABlQKllLMFPvY2RNew6+SP+VKAz2oFVWs1hxxU4bSf14HOxffvSU2svZTiPqWLWUHHdmFKWxT9N3AWLmiej5o8pNU6ETmzUJe1+6OGtoS4zXctxfXbqMRnt7/dYbM4oAiOBZwgrZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RxLV7HLG4OsEeqsjljDofMUS6s7VxOcgNumuz33aE98=;
 b=2c2D5nGudHXuiWKj3byZ01L1JcgzwXtFsp9HGO+DGd9XLsvxgmAQKya1XJ7Qz+87cre+aYbqYR/TYB0PH+mLJKVEFdMx/Er2ntnqWJnWY14zzyWkIHaDRd4jaxFXmk5XWY1M+N9+vNyT6fXt+HiqpRS2pcFMFeADx0RjBROeTPM=
Received: from MW4PR04CA0292.namprd04.prod.outlook.com (2603:10b6:303:89::27)
 by PH7PR12MB8596.namprd12.prod.outlook.com (2603:10b6:510:1b7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Sun, 11 Jun
 2023 02:57:08 +0000
Received: from CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::17) by MW4PR04CA0292.outlook.office365.com
 (2603:10b6:303:89::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.31 via Frontend
 Transport; Sun, 11 Jun 2023 02:57:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT025.mail.protection.outlook.com (10.13.175.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.31 via Frontend Transport; Sun, 11 Jun 2023 02:57:07 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sat, 10 Jun
 2023 21:57:01 -0500
From: Raju Rangoju <Raju.Rangoju@amd.com>
To: <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <Thomas.Lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>,
	Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH] amd-xgbe: extend 10Mbps support to MAC version 21H
Date: Sun, 11 Jun 2023 08:26:37 +0530
Message-ID: <20230611025637.1211722-1-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT025:EE_|PH7PR12MB8596:EE_
X-MS-Office365-Filtering-Correlation-Id: 6701e7fd-65e9-49f7-da82-08db6a278b81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xXI1fqRnGFyhR4Jjv/ru0JRYxjygNfYdGyxxTI9SiM53h6tPjYX5MQS88SZ/q47C9zooNB8BZDlx3HAf+aOdDsYdkce32nwjjkskdw6rs0LqmRpq3fQV94Ku8maR8LXuhJ+Jq//psaxRZZ4LvSpqU1XqrCY8V2KwwdkILBF9J8F7rchv/J2h48s0+Vf2OSvhYqu+MPbhf40yy6x01ggySThw9jWyV+u+VmdFEu0mVjJ9gMtx82zcY9wky8N01ajvgCEtIvZFrrqG0DsOKFH0xAe4EzW96OBF7NZHCpx1FVbpKP7j+0GmOVFfNabkz8CFBpeIQu4Yegv0O+H5emyisw3iELcKpr3Zt/Q8ejzyq7xSvulnrMcEZ7W9vQccFR2OXetHK3A2VMAN5DpCS108fp2ZQhIa09QkrxyiJmtVWcMwl/MI5lj5PFQDV+yZi1VDpPg7oP8KJvpUu27uvdi2aI7bK8beGlJtOFeg/uOn+exADMtTcrGpzxbjGFww4uoiOAt6Ll9IhkoZpH9HN5d0MwAhQP6J/Bbxdfs5q6wwaVbfEOUdnGKhCD2JejpjTYgUrurH/crJUjjqA5IBIIk/pKMNLZ/TIUl9/eqA0Xj6vWCkorqYRt4+tFShxrCi1Q1O7NDZL6PX3BFNb35DKcoOzLzxthWixWndwH06pUBD4aLPyxD0Aq5a9wUDCIvYTxzCDdMfAThdlVo3a7gv38O25l9akuQq0jEsVeFii6E5Fw/Aji4kRaSyJeuffM/0pzpbJ7Kwv3xIg5i5nM5kLx9KaQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199021)(36840700001)(40470700004)(46966006)(47076005)(83380400001)(26005)(1076003)(2616005)(41300700001)(316002)(36860700001)(16526019)(186003)(426003)(336012)(7696005)(6666004)(82310400005)(86362001)(40460700003)(54906003)(36756003)(2906002)(5660300002)(8676002)(8936002)(40480700001)(82740400003)(81166007)(70206006)(356005)(6916009)(4326008)(70586007)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2023 02:57:07.8462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6701e7fd-65e9-49f7-da82-08db6a278b81
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8596
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

MAC version 21H supports the 10Mbps speed. So, extend support to
platforms that support it.

Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 16e7fb2c0dae..6a716337f48b 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -2782,9 +2782,9 @@ static bool xgbe_phy_valid_speed_baset_mode(struct xgbe_prv_data *pdata,
 
 	switch (speed) {
 	case SPEED_10:
-		/* Supported in ver >= 30H */
+		/* Supported in ver 21H and ver >= 30H */
 		ver = XGMAC_GET_BITS(pdata->hw_feat.version, MAC_VR, SNPSVER);
-		return (ver >= 0x30) ? true : false;
+		return (ver == 0x21 || ver >= 0x30);
 	case SPEED_100:
 	case SPEED_1000:
 		return true;
@@ -2806,9 +2806,10 @@ static bool xgbe_phy_valid_speed_sfp_mode(struct xgbe_prv_data *pdata,
 
 	switch (speed) {
 	case SPEED_10:
-		/* Supported in ver >= 30H */
+		/* Supported in ver 21H and ver >= 30H */
 		ver = XGMAC_GET_BITS(pdata->hw_feat.version, MAC_VR, SNPSVER);
-		return (ver >= 0x30) && (phy_data->sfp_speed == XGBE_SFP_SPEED_100_1000);
+		return ((ver == 0x21 || ver >= 0x30) &&
+			(phy_data->sfp_speed == XGBE_SFP_SPEED_100_1000));
 	case SPEED_100:
 		return (phy_data->sfp_speed == XGBE_SFP_SPEED_100_1000);
 	case SPEED_1000:
@@ -3158,9 +3159,9 @@ static bool xgbe_phy_port_mode_mismatch(struct xgbe_prv_data *pdata)
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
 	unsigned int ver;
 
-	/* 10 Mbps speed is not supported in ver < 30H */
+	/* 10 Mbps speed is supported in ver 21H and ver >= 30H */
 	ver = XGMAC_GET_BITS(pdata->hw_feat.version, MAC_VR, SNPSVER);
-	if (ver < 0x30 && (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10))
+	if ((ver < 0x30 && ver != 0x21) && (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10))
 		return true;
 
 	switch (phy_data->port_mode) {
-- 
2.25.1


