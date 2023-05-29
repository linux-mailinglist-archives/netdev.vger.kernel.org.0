Return-Path: <netdev+bounces-6060-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B99A714954
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 14:21:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10592280E8A
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 12:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4417D6FD3;
	Mon, 29 May 2023 12:21:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B086AB6
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 12:21:27 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BCAD8;
	Mon, 29 May 2023 05:21:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9rir+lBmKaQn9/heKNz6WSNCvsLAcp34l2d+GKPPjamkklU2MpWrU1XOmbnapiSAvKdV3wEkrKESUjXsLIp4psMHW1psramYwqMhChMSr62jBC3ZKhg8ia0CzmYwqPIFQexqEVdvsjSdtFwD68ka8ysnC7H0gjJuVRzDYpIbEjChzfv80a7dpLdFHn6AtDZDwmpPMTsmeGEMKqarfrYeVVAuWUnIcqfONWm0vWrZFBglOfsVHFv/8/XTFebqu9Y2zKwdLmtZ0G6C+/zEG7KijEW6VkQdPmBXSptKH2gQAMeLDCPi8YLzu/a2uTtUIoCCgjKqOOVr+edlztJuAC8fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=evFuvQFKEzQkY71godVaQxvaiKLxBd3WQf+cex88TRY=;
 b=jNabTALaCsRdZPHHUtxIQUVqwlVN6c12+BIiZqgP487DNB0yKOhWft/6l7sjNEHrjAWR1MAaB/d+UDxj7/N7pO8QjXR/hT7Vc4q8X33x3U1D3Bh+M4jdUGtT24Da3Ob9+c4Ktn8M/5HxJm4lBzvIDnup0EYvOvi5LhsPHaFCnJRRy95swpUt1+jrCmfpq1it5OOn+mufYcgzqvXJ+hls2PqGivlfvna2HoptjN65JxQAvBX5xONs7NfstuA7NfUJzikrpVZtfIovipEHpRYjjYIfCy22bv4pUWLOd7fGyywVAwJyb+SXZsxSL2XXBOcPgQhb5K1bWifn4wYHvkWIDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lunn.ch smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=evFuvQFKEzQkY71godVaQxvaiKLxBd3WQf+cex88TRY=;
 b=QKWXt1AtfCg2TLy2krRjWIOBRQABOblsYWME3RL0RhvnnwT/MgFEhdnmeJIhuHCPgBylIuDAkVbQKQOgCej6h7f7QH83+cbej2UsxAwuYCaZJbOBJeAyQWbycepS/ZuCs00ohFCtPky/dlWjXflEVfmD6XvGB0kN4B4KGEAf3oU=
Received: from MW4PR04CA0362.namprd04.prod.outlook.com (2603:10b6:303:81::7)
 by SA3PR12MB8802.namprd12.prod.outlook.com (2603:10b6:806:312::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 12:21:21 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::d8) by MW4PR04CA0362.outlook.office365.com
 (2603:10b6:303:81::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23 via Frontend
 Transport; Mon, 29 May 2023 12:21:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.21 via Frontend Transport; Mon, 29 May 2023 12:21:20 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 29 May
 2023 07:20:37 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Mon, 29 May 2023 07:20:33 -0500
From: Harini Katakam <harini.katakam@amd.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
	<pabeni@redhat.com>, <vladimir.oltean@nxp.com>,
	<wsa+renesas@sang-engineering.com>, <simon.horman@corigine.com>,
	<david.epping@missinglinkelectronics.com>, <mk+kernel@armlinux.org.uk>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<harinikatakamlinux@gmail.com>, <michal.simek@amd.com>,
	<harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next v5 2/2] phy: mscc: Add support for RGMII delay configuration
Date: Mon, 29 May 2023 17:50:17 +0530
Message-ID: <20230529122017.10620-3-harini.katakam@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT040:EE_|SA3PR12MB8802:EE_
X-MS-Office365-Filtering-Correlation-Id: 2058c530-5729-4c36-faaa-08db603f35be
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OT/WfUdB5sdQ/lRyAX0ybCXFJ+GT1MqbPeoSzCPJpFZ2xtMPoT54IcDg2/EG2MCl3l73ZUAByRxNCQG3ennfyV+FDlv6JJ7hkRm0vJbSLP15lmralR9HM8wyvpnkhsMWS1QxRAsFxeh84tlo0ZFlP4477wUbfFnJaYLhYsdXLHK41Oacrlb/ghp0P1FG48+KSgm+We8Uwe66J1+nyJbsl0lBWqx7HmQi2PTP2d9o43gihfizArxg5ejcOMpjyoE5yjtLyWGL0xk80lX0oiM2+fa8dTmcN3xqrwIjCYYmKtAzqmBJ7+idLeZRrg1zvID7hMqyM/XX1RqWeDFtevwRhdLpcX9yNm7ZQFRv+UjdNgR2YyeOMkS5yI8RqaQeiOxKqU3j/V5dNPv+y9LYlnbfnYivWSlkQ0SNln8DmJJFkA6M2qkU1mgwucs/0NYwwXU0O5aQBBXXpld/4W2uK3Q8FerjHzbQCY1l+0Nr94L6nHA4N87o/c0ZiC3r/PLiteCFsQdhwvC+OH42mGQq5Hnu2gDMqx7+l2VsNZrXbnwY/AssCNT7OrIrxWFKyswXEiqz6CWkoGhI/6JZVJVjETbITICJlyLAst42O+34LuvG6BUmHvqTywuWpVr6f7QVAPgDIl0fqncLGddNinxHGKhxDOzzJo3pEmDSP9oBOl15Jc5v9e2jinnEN1yvAeLU+bm2Jl5mzl/vjBxqT+u+86z6pt6CG4XGhfObjoBsE9il27naHDZZOn2xR2uayy8rcWQIdgp4zOPvQndtnllOX85e0Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199021)(40470700004)(36840700001)(46966006)(40140700001)(26005)(36860700001)(1076003)(41300700001)(966005)(6666004)(186003)(47076005)(83380400001)(336012)(426003)(2616005)(478600001)(110136005)(40460700003)(54906003)(82740400003)(4326008)(70586007)(921005)(356005)(70206006)(40480700001)(316002)(81166007)(5660300002)(2906002)(8676002)(8936002)(7416002)(44832011)(86362001)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 12:21:20.2565
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2058c530-5729-4c36-faaa-08db603f35be
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8802
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
v5:
- Rebase on top VSC8501 series, to avoid conflicts
- Rename _internal_delay to use vsc86xx, move declaration and
simplify format of pointer to above
- Acquire DT delay values in vsc85xx_update_rgmii_cntl instead of
vsc85xx_config_init to accommodate all VSC phy versions
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

 drivers/net/phy/mscc/mscc_main.c | 35 ++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index fc074bcc894d..669a4a7a28ce 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -107,6 +107,9 @@ static const struct vsc8531_edge_rate_table edge_table[] = {
 };
 #endif
 
+static const int vsc85xx_internal_delay[] = {200, 800, 1100, 1700, 2000, 2300,
+					     2600, 3400};
+
 static int vsc85xx_phy_read_page(struct phy_device *phydev)
 {
 	return __phy_read(phydev, MSCC_EXT_PAGE_ACCESS);
@@ -525,8 +528,12 @@ static int vsc85xx_update_rgmii_cntl(struct phy_device *phydev, u32 rgmii_cntl,
 {
 	u16 rgmii_rx_delay_pos = ffs(rgmii_rx_delay_mask) - 1;
 	u16 rgmii_tx_delay_pos = ffs(rgmii_tx_delay_mask) - 1;
+	int delay_size = ARRAY_SIZE(vsc85xx_internal_delay);
+	struct device *dev = &phydev->mdio.dev;
 	u16 reg_val = 0;
 	u16 mask = 0;
+	s32 rx_delay;
+	s32 tx_delay;
 	int rc = 0;
 
 	/* For traffic to pass, the VSC8502 family needs the RX_CLK disable bit
@@ -541,12 +548,28 @@ static int vsc85xx_update_rgmii_cntl(struct phy_device *phydev, u32 rgmii_cntl,
 	if (phy_interface_is_rgmii(phydev))
 		mask |= rgmii_rx_delay_mask | rgmii_tx_delay_mask;
 
-	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
-	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
-		reg_val |= RGMII_CLK_DELAY_2_0_NS << rgmii_rx_delay_pos;
-	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
-	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
-		reg_val |= RGMII_CLK_DELAY_2_0_NS << rgmii_tx_delay_pos;
+	rx_delay = phy_get_internal_delay(phydev, dev, vsc85xx_internal_delay,
+					  delay_size, true);
+	if (rx_delay < 0) {
+		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
+		    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
+			rx_delay = RGMII_CLK_DELAY_2_0_NS;
+		else
+			rx_delay = RGMII_CLK_DELAY_0_2_NS;
+	}
+
+	tx_delay = phy_get_internal_delay(phydev, dev, vsc85xx_internal_delay,
+					  delay_size, false);
+	if (tx_delay < 0) {
+		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
+		    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
+			rx_delay = RGMII_CLK_DELAY_2_0_NS;
+		else
+			rx_delay = RGMII_CLK_DELAY_0_2_NS;
+	}
+
+	reg_val |= rx_delay << rgmii_rx_delay_pos;
+	reg_val |= tx_delay << rgmii_tx_delay_pos;
 
 	if (mask)
 		rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2,
-- 
2.17.1


