Return-Path: <netdev+bounces-1758-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D21566FF11D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0CFD1C208E8
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4399419E41;
	Thu, 11 May 2023 12:08:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF6F817
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:08:44 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E79F49D5;
	Thu, 11 May 2023 05:08:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/OBSda3LM8JRO27iWCaT/bVuys5yLS19ekP7+EZCiOKHJ1Bu67AWZkNUy/wxekUDAuOgNQImkKXXTfj7Q2Z/gS1MblPqjYZmJKAZyqlHbrQ9vtPD6KXPIcqLF8UYreDCzuWWRPwbgk2qC2GZTt67Y5W6a8I8wa4/SYM0iO6ZiA42KOWalHUYxFIifStmIU+QdZgBJ2sv0Atk6+FPYVOcWJaEJQUTkJt+ASipfXjwn8c5YjLoYkDMcc83+1C3rqhQWDD+/lOjdVvLHDuNm0D4e+IGTune9qho9Kd0IE2OJ1n2w9REGksnn8Kjb4HD74D10slgoHv8qCOXXf1DKBEcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46gJb/MrXKjLVsjVGk75JIEk+gFskNQca5JHLqmjurA=;
 b=L+P3P9LrEFASh6Azt3Qq/laDXpAdollE+llPV7akX3AFDsW8Bvhrld5f6wJ4FAXaIaImWpdAHgl/alc7XMcVg+p5KRf//1BsGUF+MnwGv7Pxf3qFg+d62sw69pvcB/VJfay67i/VDjDQQGlu5/pvOL2OnZbKS1fla8yM0LKU2xpgt+BOHNsB8CxN0/AbfedAgNNpFEIBOG8yTFASTWVPOEqWFFOenp7UrjKPtBnKJuCxfccua+UoUFW3qaf+TYm7ZSxW4WqsFNJxkWFRxVYrRHKSq4kTWfmzaijev60AHSpEgKM8mKP4yd3xL78YRS6dHGeHlvHi43BkR/WX2ZjgOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=lunn.ch smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46gJb/MrXKjLVsjVGk75JIEk+gFskNQca5JHLqmjurA=;
 b=KBwUk4Q7NQ+gcLc2BTQ5a7rK19OdfIqk+m7SueUdDjnJsjJowmUcYvEj+mPZn2ZXwJ6nHZ+WnLIQUKNbZzkDLfdXM9HtPikyBAjAb6R/XUVWbrlHvhOzuYSfw4MRa1LUzE6hJ/oTF1aDoTdnUhBWo2I0F0XQwP9amL74o7b6l1o=
Received: from MW4PR02CA0014.namprd02.prod.outlook.com (2603:10b6:303:16d::29)
 by PH7PR12MB9201.namprd12.prod.outlook.com (2603:10b6:510:2e8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 12:08:28 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::e1) by MW4PR02CA0014.outlook.office365.com
 (2603:10b6:303:16d::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22 via Frontend
 Transport; Thu, 11 May 2023 12:08:27 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.22 via Frontend Transport; Thu, 11 May 2023 12:08:26 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 07:08:23 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 07:08:22 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 11 May 2023 07:08:18 -0500
From: Harini Katakam <harini.katakam@amd.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
	<pabeni@redhat.com>, <vladimir.oltean@nxp.com>,
	<wsa+renesas@sang-engineering.com>, <simon.horman@corigine.com>,
	<mkl@pengutronix.de>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<harinikatakamlinux@gmail.com>, <michal.simek@amd.com>,
	<harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next v3 1/3] phy: mscc: Use PHY_ID_MATCH_VENDOR to minimize PHY ID table
Date: Thu, 11 May 2023 17:38:06 +0530
Message-ID: <20230511120808.28646-2-harini.katakam@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT049:EE_|PH7PR12MB9201:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f3c1d26-572e-4157-3307-08db52186d0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Em4M6Vh+Bxs9VGTjir4edthKQc0GYX8RkReUjCw8XDavI3aaGwr1VBxp8p7Fxsic6HfAh/WetMDwnJ+OAfgF9+6MPiTsuNadlZz+dP59obd7ULC6J4eEpKsqAJFU5NykpBdhMqebQsfL/T/avrAl+3LZB1ccB4IGvGuCqjqYjlFpCGG9mwyo+3AKurV+gVwmooG5LzKQa8t8LxG1N/d8UTZbX+Tmyvz+UFlcvQuxeTBh6F0bsBOQDzDPept4ipBDrfMAjzX43jZxs9CKXNvxyzpVX657duih80gkDrQB/uOLRFyH7PB+sO+UpM6KDzWLPGtD6RFf8LVwe3TMpYDYb5VNWvjILOZU83TC2T6cTb1iH5cQCR3hUaejpKoMiawbo5KJ3bFe4Mx9itjeX9i5Xou4HEMwPpyFKcKhGqIIB344XygsruSqXIxhC3sROx0Ju3Y02vAZ1fyQlZ2kmkVg8YProslaCvO8tdYEYSuoX5DChxcmaysGPvNe/VFwVEjKvjIdtmThps3ig+CWsgKs72Xyx+vM8JeScBwWCtPyNKUw/7KRK1veJRDkm3pQyFS3ZOYAsQzqZ8fxVRmrgMK34EGMNgtw9MHFN5leXcNnWHm0w3/81oQn2bCaHmj4y5+VzHOmHKUSYolkpwTXbWTEoxQMIHP/R8Nk4zqdJnUfEEhuOtbM7FMcQ1JqfW8oqUxx8xcMSb7Q+0qpFA4bCWMnRORkXWfR0HDo9rKbsO4LqQYx8KUGHWvypQ6qU1Lr7s0aEC6fH3ulY1daApS5nuFUf4WVFSWHpObWqpR/2hmfp0k=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199021)(36840700001)(40470700004)(46966006)(81166007)(41300700001)(186003)(26005)(2906002)(40480700001)(1076003)(5660300002)(40460700003)(44832011)(8936002)(82740400003)(7416002)(110136005)(316002)(54906003)(478600001)(36860700001)(63370400001)(63350400001)(336012)(83380400001)(2616005)(8676002)(47076005)(426003)(36756003)(356005)(86362001)(6666004)(82310400005)(921005)(70206006)(4326008)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 12:08:26.3834
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f3c1d26-572e-4157-3307-08db52186d0e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9201
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
---
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


