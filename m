Return-Path: <netdev+bounces-4283-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E58C70BE47
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:29:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF7C6280F62
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6DC512B68;
	Mon, 22 May 2023 12:29:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51D74408
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:29:15 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20602.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::602])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC5130DD;
	Mon, 22 May 2023 05:28:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZJmbhzffQd9NjlKb6HsuwotfwwYgiBJqq1squoZM/2By8VryNuXa2lhS/xO94vx/SSF62G2d4jKkYROfHYwZrE+2i/KgCZeFdQEXSnFo4k2UAE4h+e27fCrqEfcfsG6FycFOxCbVhIkmESFRkDat7umoSR/6aaNBB6qPhT1/snx0roPBsyuma403JFqs8PngRM7IG14ltvLLsOF+7bhYWwzN+UAf5/y0rthEoHMrYVsDZ+tDHJVNJGKckg7ZtOg2TggUmgkJRv1zsC+aohlxCBRLOk1v9ONTT4gCGmpk5zmpjYJgn8AHxg1Dph/dj4jl+HniB5Mb/Yitn30ogWqmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7r/kjK4NRKOVUW/2dCy/XmqFpNCgUrBXxtbeQJXiRc=;
 b=TvtSMIkObbP3tw/Pg+2GI57CS63PsgcJ2N9VoK1C6oFL61Xz324Vq0GlvzyevafRPLMcSJIP6kRSF6wmSrbwiB5pnM21q+2OyLnOK3rucirAPtfrGaxQwuGpixtLiI3NDZT9UHxFKTZfOItkG0iH2hWGiTRDNPDb+u9ifb1TE7HwX75CzTFmRByt5/JLiAvu3CACN2a6/24RGlC2+TJ7APHsfrZ/lMYXrqKkeQwUH5DTRQBGObL7IvAK2fdzhocxdjwk/IB1gycAMojXeoZS3bKxTaPcUjnabEc2K4UVQ+WdmGLt+vKqyesh1bUXsieoTPSJmrGR+Zl4a/Th3d0elA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lunn.ch smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7r/kjK4NRKOVUW/2dCy/XmqFpNCgUrBXxtbeQJXiRc=;
 b=hgjMu+IJYk+ng4HnWhOTJo2ljMKb/xbmfOgqjvkpy/1Uh6AwmvkdifPnEIbX7nm4fIktKLb9BwgfXBSBibpVhd84x9kbAKXuXWm4BSIrZdtyqQU0JdPqLUrxVbCJz5+A6dKcP2umaYC11cNdiEONEH+41XGuMBz9bEWmZ9r3EvI=
Received: from DM6PR18CA0004.namprd18.prod.outlook.com (2603:10b6:5:15b::17)
 by PH7PR12MB7819.namprd12.prod.outlook.com (2603:10b6:510:27f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 12:28:40 +0000
Received: from DS1PEPF0000E639.namprd02.prod.outlook.com
 (2603:10b6:5:15b:cafe::8c) by DM6PR18CA0004.outlook.office365.com
 (2603:10b6:5:15b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28 via Frontend
 Transport; Mon, 22 May 2023 12:28:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E639.mail.protection.outlook.com (10.167.17.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6433.12 via Frontend Transport; Mon, 22 May 2023 12:28:39 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 22 May
 2023 07:28:39 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 22 May
 2023 07:28:38 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Mon, 22 May 2023 07:28:34 -0500
From: Harini Katakam <harini.katakam@amd.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
	<pabeni@redhat.com>, <vladimir.oltean@nxp.com>,
	<wsa+renesas@sang-engineering.com>, <simon.horman@corigine.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<harinikatakamlinux@gmail.com>, <michal.simek@amd.com>,
	<harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next v4 1/2] phy: mscc: Use PHY_ID_MATCH_VENDOR to minimize PHY ID table
Date: Mon, 22 May 2023 17:58:28 +0530
Message-ID: <20230522122829.24945-2-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230522122829.24945-1-harini.katakam@amd.com>
References: <20230522122829.24945-1-harini.katakam@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E639:EE_|PH7PR12MB7819:EE_
X-MS-Office365-Filtering-Correlation-Id: 5125cf15-5dc7-473a-cca1-08db5ac012b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	64FT0+rNetagS4n5bg6tY4BJn8G+ZqLGOuzKnU4ePpu6+zxE8yAPHwgBS89P9WFr9Dxx8TZMA/I3X23mUYnN0ufqZknDC8xQpF5m1Z9HWvpH04j6rh2G1sDrtvyeCJkjFmWXiMjcNsj+jA+0PZDqgO7xtdeS7XNfWfsqOTbZhHGWasU39HaSzI8J3w8asVnSh30NPDbjcyIBFMDj2Q6gFa/vsGaJ2XtzmtHZhDuGteC6t8OR5MKnAxY/sp9jgoYOZuUw59PSi64hq2gEf/H0mEZ5X/9Xf4yXsUjvseUmX1TfWVVU/qDHSjf9WASAmAFUcITASNuyK/ibzuF5yKZYvb+qFoOEj53zVHtnmGQasro0HoNR/VuHRWQYvb7mZQCt9gDYEBmcGX3uKjQeLwtkJqAvJTVGics+gSPsp6d85kiaWx4aKY0pwId0e8Zhc97r+/EmUZoczrrCqCkAcVAdbK+2tUlBT5s++T1HeZ1vBCP8zhLXZ+TAiRBxXdnedhcosggZFIrs3ueKWDAJBEAtYoirhJlf2deBFBYKs4rjTaZH+CY/XFRt1VgObC3Zlq8qJ8syOCLRRqBmPCSg2h1fWvGq3xkVQWiRA8S2AkivpzmeFdk2KLBNrnWSVcoQYIm34EhGDWR60iWm1dHe6SmmLpjoD2LaNmpOQg/ubnTeP7GMV1uamrWwfgwdCasAteSzzs2yVqpRRvhCf9RaZF+W/MdeOvHqO4OVelRypkJ0GQsZLyfURFKZ+XhmYI+lerk3BoRX8qV0bEsmcmn//fVaqfu/pgVeHwon9HkqUa0TDJY=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199021)(36840700001)(46966006)(40470700004)(478600001)(54906003)(110136005)(5660300002)(26005)(41300700001)(6666004)(186003)(316002)(4326008)(44832011)(1076003)(7416002)(336012)(8936002)(8676002)(426003)(2906002)(47076005)(2616005)(36860700001)(83380400001)(70206006)(70586007)(82740400003)(356005)(921005)(81166007)(36756003)(82310400005)(40460700003)(86362001)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 12:28:39.6662
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5125cf15-5dc7-473a-cca1-08db5ac012b9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0000E639.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7819
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

All the PHY devices variants specified have the same mask and
hence can be simplified to one vendor look up for 0x00070400.
Any individual config can be identified by PHY_ID_MATCH_EXACT
in the respective structure.

Signed-off-by: Harini Katakam <harini.katakam@amd.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v4:
Added Andrew's tag
v3:
Correct vendor ID
v2:
New patch
 drivers/net/phy/mscc/mscc.h      |  1 +
 drivers/net/phy/mscc/mscc_main.c | 14 +-------------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index a50235fdf7d9..9acee8759105 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -290,6 +290,7 @@ enum rgmii_clock_delay {
 #define PHY_ID_VSC8575			  0x000707d0
 #define PHY_ID_VSC8582			  0x000707b0
 #define PHY_ID_VSC8584			  0x000707c0
+#define PHY_VENDOR_MSCC			0x00070400
 
 #define MSCC_VDDMAC_1500		  1500
 #define MSCC_VDDMAC_1800		  1800
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 62bf99e45af1..91010524e03d 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2656,19 +2656,7 @@ static struct phy_driver vsc85xx_driver[] = {
 module_phy_driver(vsc85xx_driver);
 
 static struct mdio_device_id __maybe_unused vsc85xx_tbl[] = {
-	{ PHY_ID_VSC8504, 0xfffffff0, },
-	{ PHY_ID_VSC8514, 0xfffffff0, },
-	{ PHY_ID_VSC8530, 0xfffffff0, },
-	{ PHY_ID_VSC8531, 0xfffffff0, },
-	{ PHY_ID_VSC8540, 0xfffffff0, },
-	{ PHY_ID_VSC8541, 0xfffffff0, },
-	{ PHY_ID_VSC8552, 0xfffffff0, },
-	{ PHY_ID_VSC856X, 0xfffffff0, },
-	{ PHY_ID_VSC8572, 0xfffffff0, },
-	{ PHY_ID_VSC8574, 0xfffffff0, },
-	{ PHY_ID_VSC8575, 0xfffffff0, },
-	{ PHY_ID_VSC8582, 0xfffffff0, },
-	{ PHY_ID_VSC8584, 0xfffffff0, },
+	{ PHY_ID_MATCH_VENDOR(PHY_VENDOR_MSCC) },
 	{ }
 };
 
-- 
2.17.1


