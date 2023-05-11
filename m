Return-Path: <netdev+bounces-1760-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3702F6FF121
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:09:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 470ED1C20F4A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70FA819E40;
	Thu, 11 May 2023 12:09:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C28D65B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:09:08 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA37B9001;
	Thu, 11 May 2023 05:08:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LUyqJ89kxPemJ4nRoiWDDMEX4NFM0RSEN13GGP1lOflOneIF/lcHvi4lUR5KxQ5j+ZjMvb8Jr2KUA4AakNkfh+ft6IbLi/XMkFVjhBrqU0wzhxgmRUFeFNTAOV4kovq34eUB4o41bWlK8T4jMZUqqLEznHzXHIeA6bteStbbGxdc0mZEh441uMbpBuGPAoMSTFqAcZ/Nr3lULBpP7erFnume4OQX7GEmz8e31aG78FH/i2kim12CwRSxjbcD0lUZtvpH1MrGjhFwgTDTvsRYlTeqq+rNS72kcbM02nNP/V3RdZu8ap3Hf41BMj7JMEMeQWaxH+hXa9pRl40KT2roTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R578/ZAwyPw4Zbv8Rszn4UrKMKi8DO9LSCgUrzUNIAA=;
 b=XzLN94zPqCiuOCJK9P1Aq0F24w4Aga/4UtWxQn1uW5TBHBfrcX3bV88hWaVkJbGZLScj4/Vlq9sC8hu8gYMnzAO8UyehfSr+FC3dMNXWwDeCw35eGcfxOQj8vc93g7pL+RTi1nVdjk4z4mEye6kYFsxhN40NOCW2XIUZJANxasN/Zo5KzGgUdLE2lFmqBdzh927YdXnMgwOBE8aBx6Jtg/+55zhjY3xT9QYAObn8yiALuHT6DpA7q1L32/tAR1W7p4/wedVSO0asMz+cPIs2kfY/a+ZalYJ5KfEZjCnOfG5NMmcK92J3bI9ngEjBm0n/cpn5WigtR22E2iIPJ6F+bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lunn.ch smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R578/ZAwyPw4Zbv8Rszn4UrKMKi8DO9LSCgUrzUNIAA=;
 b=3li8acMBBXgaZpbXZVG8yD4qCUz74ndQvR7oWBduOqyHiSOn+iAwCaCbfDxdLJU1o8ZGLbcQqXVELLkxZ6FJNKqe37P37oFQWpdtKXeYnKfobaBNK7XmdtzgHOi81d1LyKXayuKrAxsBM3gNyK+pRYsBjF3az38C07b9odzSY4k=
Received: from MW4PR02CA0015.namprd02.prod.outlook.com (2603:10b6:303:16d::6)
 by PH0PR12MB8798.namprd12.prod.outlook.com (2603:10b6:510:28d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 12:08:28 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::24) by MW4PR02CA0015.outlook.office365.com
 (2603:10b6:303:16d::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22 via Frontend
 Transport; Thu, 11 May 2023 12:08:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.22 via Frontend Transport; Thu, 11 May 2023 12:08:28 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 07:08:28 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 07:08:27 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 11 May 2023 07:08:23 -0500
From: Harini Katakam <harini.katakam@amd.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
	<pabeni@redhat.com>, <vladimir.oltean@nxp.com>,
	<wsa+renesas@sang-engineering.com>, <simon.horman@corigine.com>,
	<mkl@pengutronix.de>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<harinikatakamlinux@gmail.com>, <michal.simek@amd.com>,
	<harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next v3 2/3] phy: mscc: Add support for RGMII delay configuration
Date: Thu, 11 May 2023 17:38:07 +0530
Message-ID: <20230511120808.28646-3-harini.katakam@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT049:EE_|PH0PR12MB8798:EE_
X-MS-Office365-Filtering-Correlation-Id: a5efe008-b101-4362-e359-08db52186e48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kKHv6GCAGJuU9vebXE3Tlqj2IyCci6qmd1VsbbI3AhuS8trxd2PhQ3yTq5Kf8hs7fZGs/AdIWjx1R/fcQIP9+StnV75Y6BznD4S1KfKarNDF7S8e7JZPaGCNtKnq10OwNvRbBAr3G0ZjM1C+zzPuOSjTUTWUr4OTuHuv2zC33g+AHn+xjkcT0dlJxy08fFqUAO7PpGhaTZKnnllQoonEHXgIt5s37mYqc6SpsZpGRttMSU4aTmA76Z19LzGm58okfgdEvWbdYV15BSER/eeHf2Sm6H0xYxuhZfQ6HUlHinLu7ePmveOf9JED+J32qh4AUw6arJOW/OMndm+2cpTy78Eb0Od3/2Z9UDuDCyluMfgae6D0c9D6TaAItyagcXCTfuZGI7cS5FRJiV3lu6X4EKMMMrT1F9B92O1tII5PArh8ececsPkm3E39thc6FaAkt6byDhVgfUUR40sqDR3ZJ9Ws+/PEaL2YW3YCrL+PbBzBXUJk2gX5it6hFoXNMEvFMUsLvzltKEmclDJoYJaSByjGYCdT6HOV2qwx/PH0wC9mp6UUkRqWTnEY+E4I6/4LN1uK2545hw2ivOLbra6nspumSSCU0JHdmGrYNet3/ygSjILeUxXWnyD8QA2W72GZBmt0cee64uE/Q0F+Ajf9WQCYNwmfe4IcKwsgCZlu4qf9BKnGE0qFS5lAwzFUQMAAimqgRVviK4E9pe7fPSTvpw9nRwFuFolSrsDyqoQaL52IxSj86x3laQymRamIzVqI
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(451199021)(36840700001)(46966006)(40470700004)(478600001)(54906003)(83380400001)(47076005)(426003)(36860700001)(2616005)(336012)(6666004)(86362001)(40480700001)(26005)(1076003)(356005)(82740400003)(316002)(921005)(110136005)(70206006)(4326008)(70586007)(41300700001)(186003)(81166007)(8936002)(7416002)(8676002)(5660300002)(44832011)(40460700003)(2906002)(40140700001)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 12:08:28.4458
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5efe008-b101-4362-e359-08db52186e48
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8798
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for optional rx/tx-internal-delay-ps from devicetree.
- When rx/tx-internal-delay-ps is/are specified, these take priority
- When either is absent,
1) use 2ns for respective settings if rgmii-id/rxid/txid is/are present
2) use 0.2ns for respective settings if mode is rgmii

Signed-off-by: Harini Katakam <harini.katakam@amd.com>
---
v3 - Patch split:
- Use rx/tx-internal-delay-ps with phy_get_internal_delay
- Change RGMII delay selection precedence
- Update commit description and subject everywhere to say RGMII delays
instead of RGMII tuning.

 drivers/net/phy/mscc/mscc.h      |  2 ++
 drivers/net/phy/mscc/mscc_main.c | 35 +++++++++++++++++++++++++-------
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 9acee8759105..ab6c0b7c2136 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -374,6 +374,8 @@ struct vsc8531_private {
 	 * package.
 	 */
 	unsigned int base_addr;
+	u32 rx_delay;
+	u32 tx_delay;
 
 #if IS_ENABLED(CONFIG_MACSEC)
 	/* MACsec fields:
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 91010524e03d..9e856231e464 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -525,17 +525,14 @@ static int vsc85xx_rgmii_set_skews(struct phy_device *phydev, u32 rgmii_cntl,
 {
 	u16 rgmii_rx_delay_pos = ffs(rgmii_rx_delay_mask) - 1;
 	u16 rgmii_tx_delay_pos = ffs(rgmii_tx_delay_mask) - 1;
+	struct vsc8531_private *vsc8531 = phydev->priv;
 	u16 reg_val = 0;
 	int rc;
 
 	mutex_lock(&phydev->lock);
 
-	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
-	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
-		reg_val |= RGMII_CLK_DELAY_2_0_NS << rgmii_rx_delay_pos;
-	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
-	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
-		reg_val |= RGMII_CLK_DELAY_2_0_NS << rgmii_tx_delay_pos;
+	reg_val |= vsc8531->rx_delay << rgmii_rx_delay_pos;
+	reg_val |= vsc8531->tx_delay << rgmii_tx_delay_pos;
 
 	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2,
 			      rgmii_cntl,
@@ -1808,10 +1805,34 @@ static irqreturn_t vsc8584_handle_interrupt(struct phy_device *phydev)
 	return IRQ_HANDLED;
 }
 
+static const int vsc8531_internal_delay[] = {200, 800, 1100, 1700, 2000, 2300,
+					     2600, 3400};
 static int vsc85xx_config_init(struct phy_device *phydev)
 {
-	int rc, i, phy_id;
+	int delay_size = ARRAY_SIZE(vsc8531_internal_delay);
 	struct vsc8531_private *vsc8531 = phydev->priv;
+	struct device *dev = &phydev->mdio.dev;
+	int rc, i, phy_id;
+
+	vsc8531->rx_delay = phy_get_internal_delay(phydev, dev, &vsc8531_internal_delay[0],
+						   delay_size, true);
+	if (vsc8531->rx_delay < 0) {
+		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
+		    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
+			vsc8531->rx_delay = RGMII_CLK_DELAY_2_0_NS;
+		else
+			vsc8531->rx_delay = RGMII_CLK_DELAY_0_2_NS;
+	}
+
+	vsc8531->tx_delay = phy_get_internal_delay(phydev, dev, &vsc8531_internal_delay[0],
+						   delay_size, false);
+	if (vsc8531->tx_delay < 0) {
+		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
+		    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
+			vsc8531->rx_delay = RGMII_CLK_DELAY_2_0_NS;
+		else
+			vsc8531->rx_delay = RGMII_CLK_DELAY_0_2_NS;
+	}
 
 	rc = vsc85xx_default_config(phydev);
 	if (rc)
-- 
2.17.1


