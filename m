Return-Path: <netdev+bounces-1759-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C6606FF11F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:09:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD27E280C09
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 046E919E55;
	Thu, 11 May 2023 12:08:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FBB19E54
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:08:45 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0B330F4;
	Thu, 11 May 2023 05:08:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0ujwsmctC/AzaqZ3WK1aCaSF9qFX3Lpp/bN/g7Z7a7X0O2mPii3pXvHphUKcqc6eDdTYaLmju0O8m4JAdDUb/GxPKyzDJrtF+DR2gugzzWPVnlvlD3g1YqrvIpooA2zz63Ph9peld3YTKV65e++zAVRLpgbpFkym/OVXdyMha1idXUKwmLA4Wchi6nhMFKZz8MXCYMrXyf3W2zV4KTMY/mlw3TkD2LlpY7aGsn/uO9LOzJZh84pTzxLoItywXTyrV/WeizkNxdJIzxIrohThftpKDEP1CfpubymBcbQlI7x+nRMSccPDNdWk+ja1HK/5gg1T1I0fLlLtpCPqeWK1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cjFUQItrzTXqsKUOyRwjpzUqpirQmGqgEmJOOvB52Vg=;
 b=kraSsAR9GIzdbWZRVJ8ymS535DRbfjAADfGM7JSSCR3289jXdEtRjwscRaORl/v/JpfSu1Yfwf97xx2QcBsOYx+D9WRMk/CG6tTc4oC1y50G+g4d9XI5rhMSXYgvBvDx7o/i+ea7ZULOeqf2fo/whyVAzDvSjJ2lV8jh19wgjc4uKyQ3pA80nmCw494ePBk8rAWpbNtwgm+jMZELV2EEWAK65sZz0TTJe4ZTvsqLMZqQ7J7rr50A79jA03KzSHln2QhuY+8AopSKbcCv8viez8Qtely9iXpwLViODURGQ2ibK00nJeyIf9NbSeRxbu6JlcxnD0gwH/cCh0uM26HUYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lunn.ch smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cjFUQItrzTXqsKUOyRwjpzUqpirQmGqgEmJOOvB52Vg=;
 b=HZ6b+TeBAeVoJn4ZtvwvgEszjDatIE03A48gpkIlMV29pR05EDHW4yTqXg4yVJ23vTZon0Utq2+Ubk4/C8Eg4AN2dfO0ztYaqF2GC7x4yykiFD3op8yRjHTqk9PVbpq0fluksBNZL1TRf0C8qoPuN7H/7ofWq4R1aOfkRWMc1jM=
Received: from MW4PR02CA0009.namprd02.prod.outlook.com (2603:10b6:303:16d::20)
 by MW3PR12MB4443.namprd12.prod.outlook.com (2603:10b6:303:2d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 12:08:35 +0000
Received: from CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::1c) by MW4PR02CA0009.outlook.office365.com
 (2603:10b6:303:16d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22 via Frontend
 Transport; Thu, 11 May 2023 12:08:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT077.mail.protection.outlook.com (10.13.175.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.21 via Frontend Transport; Thu, 11 May 2023 12:08:34 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 07:08:32 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 07:08:32 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 11 May 2023 07:08:28 -0500
From: Harini Katakam <harini.katakam@amd.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
	<pabeni@redhat.com>, <vladimir.oltean@nxp.com>,
	<wsa+renesas@sang-engineering.com>, <simon.horman@corigine.com>,
	<mkl@pengutronix.de>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<harinikatakamlinux@gmail.com>, <michal.simek@amd.com>,
	<harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next v3 3/3] phy: mscc: Add support for VSC8531_02
Date: Thu, 11 May 2023 17:38:08 +0530
Message-ID: <20230511120808.28646-4-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230511120808.28646-1-harini.katakam@amd.com>
References: <20230511120808.28646-1-harini.katakam@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT077:EE_|MW3PR12MB4443:EE_
X-MS-Office365-Filtering-Correlation-Id: dcbdf84b-bf9b-4690-5d82-08db521871d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3OY6XvoIVU6jHVAP0sMjXF8d0VumrrnqC0Hsbz7l9+nTXe2MgrlmDJHZTBvUq8ngNT5yjzxiQ/LiBABdLwoM/D1M/J3TLAmLuXqnzBEm6N6AiK9kQAtE8O+O8bVD9IjN/37ppYA3PYuDyHXTwoLHa2DzFPZ2dGT0xAuKJlUYLCJ4cLdi7t65TClk83qKXr2nuJPkAQd6CpNQWQ0SYBkHba4BKGwdwmeNQ7lPwcCCZF+B2ed9uZ4vizol3LXaHOPy8FaA0JB/35qDxmCah39lUWBbr4k4kCsQNijX8tUXNQ7iZM6P9w15IbsR7xD+CSuNK73JgJOaTkZSolnsHWUcyFsSpEFQTYUioGeo3De8XfbrBz7kKqM8o+cy4uG/hJ651h065y3M2afdZ6fFdxCM640DZ0cu2FNzSL7EjmXV+VM4CZIaF/9mUAh9VpM5XE61+1JAfBPPLRiLqFnHCq/GrlhMQ1lE0D0AO+XgG/is+FUuF5LlrXQ+ttQrUY8YSkjfVlroXB2TMLzwuqu8OyoQq/w/saC37BmxAUpl75+rP6079L4PFQmeyvyobl4TtMwCGqdvpcMSQm84+BRkI5lwFIaFpCFYtRfowQCsXJQElKQ80rd/f4UhcyzqW6evtJn5FdiECBgqZWpDVqsUUw7d0i/u6VHpAxTvuywdFT/FF3iBFHATz9Gu33MQyXXI6Mi/HwIg8A1TTQ8w2CGBjf9V9S1x0UAdNsB75T3VENetNlr5xCPvnYRif0Z/2bvYr1p79rW1i8QN3y2ou/r3BpCAoViiWpTsyOXf/mX7ld5oVmI=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199021)(36840700001)(40470700004)(46966006)(81166007)(41300700001)(186003)(26005)(2906002)(40480700001)(1076003)(5660300002)(40460700003)(44832011)(8936002)(82740400003)(7416002)(110136005)(316002)(54906003)(478600001)(36860700001)(336012)(83380400001)(2616005)(8676002)(47076005)(426003)(36756003)(356005)(86362001)(6666004)(82310400005)(921005)(70206006)(4326008)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 12:08:34.3996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dcbdf84b-bf9b-4690-5d82-08db521871d5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4443
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for VSC8531_02 (Rev 2) device. Use exact PHY ID match.

Signed-off-by: Harini Katakam <harini.katakam@amd.com>
---
v3 - Patch split

 drivers/net/phy/mscc/mscc.h      |  1 +
 drivers/net/phy/mscc/mscc_main.c | 26 ++++++++++++++++++++++++--
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index ab6c0b7c2136..6a0521ff61d2 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -281,6 +281,7 @@ enum rgmii_clock_delay {
 #define PHY_ID_VSC8514			  0x00070670
 #define PHY_ID_VSC8530			  0x00070560
 #define PHY_ID_VSC8531			  0x00070570
+#define PHY_ID_VSC8531_02		  0x00070572
 #define PHY_ID_VSC8540			  0x00070760
 #define PHY_ID_VSC8541			  0x00070770
 #define PHY_ID_VSC8552			  0x000704e0
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 9e856231e464..aa1df69043e5 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2434,9 +2434,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_stats      = &vsc85xx_get_stats,
 },
 {
-	.phy_id		= PHY_ID_VSC8531,
+	PHY_ID_MATCH_EXACT(PHY_ID_VSC8531),
 	.name		= "Microsemi VSC8531",
-	.phy_id_mask    = 0xfffffff0,
 	/* PHY_GBIT_FEATURES */
 	.soft_reset	= &genphy_soft_reset,
 	.config_init    = &vsc85xx_config_init,
@@ -2457,6 +2456,29 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
 },
+{
+	PHY_ID_MATCH_EXACT(PHY_ID_VSC8531_02),
+	.name		= "Microsemi VSC8531-02",
+	/* PHY_GBIT_FEATURES */
+	.soft_reset	= &genphy_soft_reset,
+	.config_init	= &vsc85xx_config_init,
+	.config_aneg	= &vsc85xx_config_aneg,
+	.read_status	= &vsc85xx_read_status,
+	.handle_interrupt	= vsc85xx_handle_interrupt,
+	.config_intr	= &vsc85xx_config_intr,
+	.suspend	= &genphy_suspend,
+	.resume		= &genphy_resume,
+	.probe		= &vsc85xx_probe,
+	.set_wol	= &vsc85xx_wol_set,
+	.get_wol	= &vsc85xx_wol_get,
+	.get_tunable	= &vsc85xx_get_tunable,
+	.set_tunable	= &vsc85xx_set_tunable,
+	.read_page	= &vsc85xx_phy_read_page,
+	.write_page	= &vsc85xx_phy_write_page,
+	.get_sset_count = &vsc85xx_get_sset_count,
+	.get_strings	= &vsc85xx_get_strings,
+	.get_stats	= &vsc85xx_get_stats,
+},
 {
 	.phy_id		= PHY_ID_VSC8540,
 	.name		= "Microsemi FE VSC8540 SyncE",
-- 
2.17.1


