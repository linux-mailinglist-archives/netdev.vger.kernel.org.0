Return-Path: <netdev+bounces-6061-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57FCA714957
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 14:21:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1443C280E4A
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 12:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ACE96FDF;
	Mon, 29 May 2023 12:21:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592426FD3
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 12:21:32 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2089.outbound.protection.outlook.com [40.107.212.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524D8C2;
	Mon, 29 May 2023 05:21:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmv1ZCmT6OZxZoZ6o7dxDTUNnbvC2XMbewUu7T7kht2ztWTIzzG2jZTAYhYVqSRjSKTHqg0joQFUB5LF9A0KhCjdehKBlgWmbZeIjyYCyOiH7LSqLcz5a4M1lo5ScuDtdsV5owf8bBbJ3Qg2xY6femOrmzZkMtmrE0O1UaAMd0b0uSiW/gGrCwsHtzX/c03/AFdnY756wMhXcDs5AgjCNpdz3CvlgAHo6h7/7i9A10GS050CxQW7V9aCEOb1wCjrs3oeWewfMZ9vA8rkUX7BkPWJUqLdKr2t3fkjAnjrwk4FWdoL/3nRufiB3miT72DcQeZccCUrj/mCQI0R/2LEzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F3kRpLjC/3PMMIONYNySw10CzAo9uMi29dR1HlvbDYg=;
 b=JnuI33uIr0A5fAEh8Tu5jAwa+wNspFyde2dkqNlttjNqMcvxUDZXnufT5aMjMPPRsGY0JaruZ4lMFI4LXDgDQJ3rWCpwp8KTrU67q0PDuCfkzvvqMAHyDbv30yBiU63W8dZgRWGEWNLenhhXGyuC7KEc7nqwM2cPkGvfpW9BEkRIwCkJThQtDmAuJARoEzBHQsq8raPiebWbtkM7s5MQtiIo/H10H8Tvwsv3XPPn7xMKbsr+1ZPG612nTHZP52lnAMQWEnQ40Bp6gssxkXz0dFwiV9IjgM5UiAfie1vXcT9YcbIzsA1LIwayJ9OUz3zHuCHkH9YXlABQhW1Cg9relw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lunn.ch smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3kRpLjC/3PMMIONYNySw10CzAo9uMi29dR1HlvbDYg=;
 b=AMn98jb/K30hPBns513hCLaZz4Q9EE+e26X36omCn66yPj9/TQhwaudw3k4WktErQjtqaHMilPnbjy7K+cAEYxr9TClE1y4V9nu0iGljmZHARHFGhFCV2SKl4qdlzdYD3Yht6GRhDqZBswiN/GLYx42RWlo8YtM1aVCcGuqcmkA=
Received: from MW4PR04CA0388.namprd04.prod.outlook.com (2603:10b6:303:81::33)
 by BL1PR12MB5993.namprd12.prod.outlook.com (2603:10b6:208:399::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Mon, 29 May
 2023 12:21:25 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::2e) by MW4PR04CA0388.outlook.office365.com
 (2603:10b6:303:81::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22 via Frontend
 Transport; Mon, 29 May 2023 12:21:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.20 via Frontend Transport; Mon, 29 May 2023 12:21:24 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 29 May
 2023 07:20:33 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 29 May
 2023 07:20:32 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Mon, 29 May 2023 07:20:28 -0500
From: Harini Katakam <harini.katakam@amd.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
	<pabeni@redhat.com>, <vladimir.oltean@nxp.com>,
	<wsa+renesas@sang-engineering.com>, <simon.horman@corigine.com>,
	<david.epping@missinglinkelectronics.com>, <mk+kernel@armlinux.org.uk>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<harinikatakamlinux@gmail.com>, <michal.simek@amd.com>,
	<harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next v5 1/2] phy: mscc: Use PHY_ID_MATCH_VENDOR to minimize PHY ID table
Date: Mon, 29 May 2023 17:50:16 +0530
Message-ID: <20230529122017.10620-2-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230529122017.10620-1-harini.katakam@amd.com>
References: <20230529122017.10620-1-harini.katakam@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT049:EE_|BL1PR12MB5993:EE_
X-MS-Office365-Filtering-Correlation-Id: 45976d67-4905-4ddd-080b-08db603f3850
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	FYnPYN15ltXULQh5VQQ4MPGQYTXAJaeiCcG5EFYdDxnXWTuOpVvu9c5yv+sybIrjAI63aKBzNc8GqyCKFUBwpnp10ZVrgAax9D1CU0zAVZ8v8k0I1NjIBr576iEGIDuaq3aVnPQVgudY9hfFkc2IOjKHKdd9o3LArddjm+pl8jgDjyazBUAjKDkZk44uT+0WBirh2TaIJK+0vE3SBMSglGwmlTg39LNb0BJ+YXnN/1MCwu/Bi2LLBQ4hBhYZfMXtejYSQY/ItKq6wm080WuBUiEORatwfnrbfFE13E8A9lktxCOZr9WuWlbOLtknPQMVjWLlFAKXRchrjFpVaVuBPdxnO4PgGbGtahl5AnKQtXab+D4xeWwc48Wc/yIEve8ReLs/96yZSq34akfButGqlGY+b96hnfUEUu4ykHN1aXEj7HnMkP8JNspitMDpwryCVISnidS2FvHexz0g/O9BTU+iJpGyTSFAIvDo2kGj0cv/6BFNUP5mGAoAg07h3TLSGM+qDAxyz712SeRP91OqrwYba6dX3Y7GhAkOB5duh47TNCbQeb3W+pwGwY1knFmapymm3285I/XHkwOkxQ87UBLhhksU/YJiZ4t8hHM5kc1TMB8U9xEJUg0ODh7reeUDwf2ekZdwnHKAUMcaZkg3cjcm9UqRGUGkf8v1+PIK42H4Hw2MqX/bElc7kiDS19o9R5bHVvh2Sjq6KdrWlKr4RX31An7kRqsql/GODXI0edv85Z3F1KCNp+S1SGCdgE8m1OUXIsOBFHkn5aqtGIwiOdEddM2JykGbV8J7LR5/pAg=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199021)(36840700001)(46966006)(40470700004)(82310400005)(41300700001)(86362001)(40480700001)(4326008)(40460700003)(6666004)(316002)(36756003)(70206006)(70586007)(7416002)(36860700001)(5660300002)(186003)(2906002)(44832011)(1076003)(2616005)(26005)(426003)(47076005)(336012)(83380400001)(478600001)(54906003)(110136005)(81166007)(8936002)(8676002)(82740400003)(356005)(921005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 12:21:24.5626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45976d67-4905-4ddd-080b-08db603f3850
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5993
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

All the PHY devices variants specified have the same mask and
hence can be simplified to one vendor look up for 0x00070400.
Any individual config can be identified by PHY_ID_MATCH_EXACT
in the respective structure.

Signed-off-by: Harini Katakam <harini.katakam@amd.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v5:
Rebased on top latest net-next
v4:
Added Andrew's tag
v3:
Correct vendor ID
v2:
New patch
 drivers/net/phy/mscc/mscc.h      |  1 +
 drivers/net/phy/mscc/mscc_main.c | 16 +---------------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index defe5cc6d4fc..7a962050a4d4 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -292,6 +292,7 @@ enum rgmii_clock_delay {
 #define PHY_ID_VSC8575			  0x000707d0
 #define PHY_ID_VSC8582			  0x000707b0
 #define PHY_ID_VSC8584			  0x000707c0
+#define PHY_VENDOR_MSCC			0x00070400
 
 #define MSCC_VDDMAC_1500		  1500
 #define MSCC_VDDMAC_1800		  1800
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 28df8a2e4230..fc074bcc894d 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2678,21 +2678,7 @@ static struct phy_driver vsc85xx_driver[] = {
 module_phy_driver(vsc85xx_driver);
 
 static struct mdio_device_id __maybe_unused vsc85xx_tbl[] = {
-	{ PHY_ID_VSC8501, 0xfffffff0, },
-	{ PHY_ID_VSC8502, 0xfffffff0, },
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


