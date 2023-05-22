Return-Path: <netdev+bounces-4285-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A60170BE51
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:29:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00012281023
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7739134AF;
	Mon, 22 May 2023 12:29:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C273012B98
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:29:37 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2047.outbound.protection.outlook.com [40.107.95.47])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DBC3A84;
	Mon, 22 May 2023 05:29:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWecK0T7ziFkCDkGw+wxVp/AqLIkFB0NMCDg+DKRZnn08XhXrKZH39PhUlU6N4/dGBzkKvcP4stdNcyC9NEBCQJ0c3q4eoQ5Z86zoQNN2kDcI1jcFSIoo1Vt8EqcdOs5oj5oIMweeWCCY1sReS0YyzQD90AO/4En2w1vtic+PO5lHds5eJ9GSByGltW2zFP27m86oC07++bC5/RnLdGyBX+rjs9bZo9GTc6mhdtir7KHkYK18QXXdgKuE5Dg8SL1db7TOawVPDRh1bNUuAS+Allf7eOOiLNTqUqhSXnjgbTN9s3UpA2v9T2AYtKKvxllxNLch09L4mISCxo8ANj8dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xjWvhhOpIvwNON+JrXCbekbx9u1vYsFFzdO3lBlfwJU=;
 b=Qk0zfuqxw1nD7mA0o1IQWTCO/s2kyg183vswoDrPJG2TaeF5CNZjXYu36mIeglSiX+UtNuvMTFT+GKVbT5hndsiH/m9a4zc1k8TN4/4sJg/ljMSuNGPPGpI40CRYxnGh4tCSGfEe2ZaGcsrOFFZGhOu5FAmRVLEEIM/kKWpMnnrAE5lkHcTum1qIzhZey+Iwx1T9pvaNQ2++ct6obFsX6A5CjVybWG1b2dRutUKu85KSKJ+kvZTBe8EG6BEyIjHWTTw5DEgxj02CNnIXKQytf2LCtwUOraEGxYq2trgxFnHOHOItoKxtDldfOrSf5hFCg2PCDJBsWgXcddKrXGdPTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lunn.ch smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjWvhhOpIvwNON+JrXCbekbx9u1vYsFFzdO3lBlfwJU=;
 b=SylCXFVcR7DlTKVTIX1AVPnxDCifhKxygtow/F+SsviSZjvo3cyALpRAX35jFQ6jW/jL4tzRqjtS2uyuIACwC9coR/QI3x+Oh+AWGsY+tBAlL12IQVVxbE/D38sC5munlGFN32hUNJvUhPNIAY3ptNsn/hlQItaleCs+IrTX5DY=
Received: from BYAPR02CA0012.namprd02.prod.outlook.com (2603:10b6:a02:ee::25)
 by DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 12:28:46 +0000
Received: from DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a02:ee:cafe::3d) by BYAPR02CA0012.outlook.office365.com
 (2603:10b6:a02:ee::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28 via Frontend
 Transport; Mon, 22 May 2023 12:28:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT018.mail.protection.outlook.com (10.13.172.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.28 via Frontend Transport; Mon, 22 May 2023 12:28:45 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 22 May
 2023 07:28:43 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Mon, 22 May 2023 07:28:39 -0500
From: Harini Katakam <harini.katakam@amd.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
	<pabeni@redhat.com>, <vladimir.oltean@nxp.com>,
	<wsa+renesas@sang-engineering.com>, <simon.horman@corigine.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<harinikatakamlinux@gmail.com>, <michal.simek@amd.com>,
	<harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next v4 2/2] phy: mscc: Add support for RGMII delay configuration
Date: Mon, 22 May 2023 17:58:29 +0530
Message-ID: <20230522122829.24945-3-harini.katakam@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT018:EE_|DM8PR12MB5480:EE_
X-MS-Office365-Filtering-Correlation-Id: 0577aaf5-bab9-4261-909d-08db5ac0163a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YqgzBupBGL6SoZHLYpFbHALynBB4Q16ecpfcE3R/PYH9RCcfVifRe7ZK1w7R6HYHP0O8zADkNv/VX5q4k/u0Nzx83bWNgo0w2s9A+a8r16D68/8enwf+FwScSO8HbB3py+FzxOqOZWRT39mjcICtwrOKJ1clHZQfgbVsVofzV1NXBlEmeinJYedjJdMwAv7/1oP6eF58BPPtMfyYofaMnzF6MpUxRVvWT2bBWJp2fmOg/+v2A5kFifnsNjZPAWzIl1GxXJDkA+txD/NlH3IwHEaELzsAh3MOl4I/Bx73UbroGvcxRpBv4A7GS03/OnyzQzsNTJVivV4+MYeVrv0ydjDWPUpcgaU1v/nTqq0HmpRWPtZHbmuiZEjY+HjYG9q45uShXMvoLSyPmGvyeyLgW38xxED8G/XZrI0LlU6Mjwvbk71TtRHWHDNa9cJp1qIQ0bUL8LsvhpPDJ6gpG9JEOwNcXaPAoWq3SHdFKzjXT5m7hSHrflXnJetnJzx4ES/1Fbit7FSku71DQlFcjhoj4KmEzXLtSjDl311egMFoZhNlFbEKDQ7tM5EEcfx9mAwX8h9O3TjYm/Q9WCSdIcmRIbmY2tgdRCZX/YBiUcUZQpTYs0D2SAQPdUwtwnRykpJWEurCekqR9guGrCTBud86BM5XsWmYIxewxDXXkOz3HC40LDhePU/E59K6fbEhCXdAoCvLIz9ILhtvDhowBAywbGiyjTaTw2W2QtBhYsuU7b6/zYE9VwF5iBgC0zBhp2WPLmwJ3eF9h0KYxJq917cnHg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199021)(36840700001)(40470700004)(46966006)(2906002)(110136005)(54906003)(5660300002)(44832011)(7416002)(36860700001)(82310400005)(47076005)(8676002)(8936002)(40460700003)(41300700001)(316002)(70206006)(70586007)(478600001)(4326008)(36756003)(40480700001)(40140700001)(6666004)(966005)(336012)(1076003)(81166007)(86362001)(2616005)(26005)(186003)(83380400001)(82740400003)(921005)(356005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 12:28:45.5277
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0577aaf5-bab9-4261-909d-08db5ac0163a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5480
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
v4:
Fix type of rx_delay and tx_delay
Reported by Simon Horman and
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202305140248.lh4LUw2j-lkp@intel.com/
v3 - Patch split:
- Use rx/tx-internal-delay-ps with phy_get_internal_delay
- Change RGMII delay selection precedence
- Update commit description and subject everywhere to say RGMII delays
instead of RGMII tuning.
 drivers/net/phy/mscc/mscc.h      |  2 ++
 drivers/net/phy/mscc/mscc_main.c | 35 +++++++++++++++++++++++++-------
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 9acee8759105..900bf37db9de 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -374,6 +374,8 @@ struct vsc8531_private {
 	 * package.
 	 */
 	unsigned int base_addr;
+	s32 rx_delay;
+	s32 tx_delay;
 
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


