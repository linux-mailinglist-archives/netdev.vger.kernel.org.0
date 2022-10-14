Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463C85FE910
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 08:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiJNGsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 02:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiJNGsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 02:48:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08AB1B2BBD;
        Thu, 13 Oct 2022 23:48:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MSakksebsBoVlBz6Uvc/8v5pI+DMhDWFfYXWsyQU1OOALB2MVja+n8xajiTNVZzoS0GUuS6vRmNFoxjdsqFIX2ra4fNpkZKMwWbXrlvQJisyB0P/iE2DCO0MLxetJ281SZbp8fJhMmKEEnNHG1v9EJshtHwwAbkIv8IzDTQj3udZ8VGhg0x6WINJznObHX9/TPPUyvm9+ZQ+x9oKmhc7HcK3IYt5v/cZoFc9BP2++iIkptWuxshgaj8FeZQL1GNESglURMumvq3ClxO5hJ52UpOMRBkF23T8IuIRgboiIs2igXqQIQ8tBAmNRjcETYgmY27FavoP3aOLLGVLebrliw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDmWzcUen+mdB4+xmOQKivrfbK/4IZyLLtzcH5L/Ajs=;
 b=TBxWrmkdkJRep4YKRGrw0tKEI5euJBWbHCePn8Iy9PMIVSTBjUespQbtoVcVsRjhnRwBIxBTY25yg/6lstOosOT8qZvIRqtuLeExZyG1SRfu8ko1jHaUe1tghe1ewYNctcpZD9cR005uI/q6tidgiuK3oENN8QeztKunJE+bn4hAI6a+22M/BNNMHiztJ9CwbzpyEchbJJuU4UwpWv339t/9Y2YiaHS0yRjKViVUC4OjjQ/BCc6I+qHDfeVumpVxH/UJTSaQdiBvli4MJraC325BNVJGzL1hBX5ZfIyeKPRYhuBhOWnpnJUK+12W821EciIgeXu81bvGiu3hiAogjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lunn.ch smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDmWzcUen+mdB4+xmOQKivrfbK/4IZyLLtzcH5L/Ajs=;
 b=Bl6DpjHwC46pa700YPSLTI92k4G4/558J/DnX/TSR8q9qFA/kJPxH4xeORhWkc7NGFfTxC+MgmQz36hzO9VA3MTdKfB/2PT/yOztOnECJn+/PvO5nf//oui3aFAide/o2Z7nNYgqJm1lKuWCgAME/PL6Fhw19uUF1qj4xr/p3GQ=
Received: from DM6PR07CA0130.namprd07.prod.outlook.com (2603:10b6:5:330::22)
 by SN7PR12MB6912.namprd12.prod.outlook.com (2603:10b6:806:26d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Fri, 14 Oct
 2022 06:48:07 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::d3) by DM6PR07CA0130.outlook.office365.com
 (2603:10b6:5:330::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.28 via Frontend
 Transport; Fri, 14 Oct 2022 06:48:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Fri, 14 Oct 2022 06:48:05 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 14 Oct
 2022 01:48:00 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 14 Oct
 2022 01:47:53 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Fri, 14 Oct 2022 01:47:50 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <harinikatakamlinux@gmail.com>, <michal.simek@amd.com>,
        <harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [PATCH v2] net: phy: dp83867: Extend RX strap quirk for SGMII mode
Date:   Fri, 14 Oct 2022 12:17:35 +0530
Message-ID: <20221014064735.18928-1-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT060:EE_|SN7PR12MB6912:EE_
X-MS-Office365-Filtering-Correlation-Id: 878fbc3a-fd10-4c39-5682-08daadb00beb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yyjLL1uIOl67nawkELuKLsng6iWu7k8fd761z+Vkk930DZ98uHZCrbiKkZInGlvsrgHy+Bi2w3uGGq07ARrjsfv9MheUDOB3cTGMiivi8A7afCdEsVAfjmzp+NxsYiD26ihFhLNLX7rKjsHoTEr9MuyDACauTV+FIbMlDKPVyFzJ3rtuOFR2PPZiNQ3+qJN3JQvLdvQB2EAJdJbMjaHUnRVF5ldiZk/HS5PXOT7Pxd6d5TakcQME/Vy3ZMcDPPCRedeUvWgi46xV+6FIqraeCruNYtwE9OZ3qOZmf8wUUmpwk5YHd3Ux3AREqFkIe0HIBJFWENllqxdT65AuLARBk3/AHoe3Fyd711D7jmlt9Bf+I0FYZNA1Wm4D/MXtCRD2kREXI7ekELhqYTavrKqHzFq9Ccj6H22y3lv06G9wSeY5brAK15k4d58MSeo1GL8eDHzjtphduHHhVz4wfxVYaCdTRqPHwnFRPHW0exrJp1h8+AFbS/ea3Fqz0/4nNNjvvHUSkQS9odUzcrvSsg4niECf/Lo2i49p9+3PMEa8Jy3EHU9ovn+Cu2LV3mOMyfdFiXx9IKYlprhv40Oz3/udgxM+F2SmJdlM2RgsdxClt8HrDvQV5HhioTA08QMCWTQ08NGZW9ioEF5GIvlds9hHu6Nw2iTyV6m81xQDTKjBcS2tss2hjv/q1tmXWbCfLE/7+sIsLvC/XdVIhSS45yTJL3dfHTs0YFlNrqCu8bqEEow7keJrGOoqTC/xcU4Av/CtKguJm2/27EUKsEoxKuTpaa4FeSMARTiDAbvawWrULb4CvFi1FDyiab2yL4S6y2k4
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199015)(36840700001)(40470700004)(46966006)(426003)(8936002)(82740400003)(5660300002)(4326008)(8676002)(6666004)(47076005)(110136005)(40460700003)(54906003)(82310400005)(356005)(81166007)(26005)(478600001)(41300700001)(316002)(70206006)(36860700001)(36756003)(70586007)(86362001)(44832011)(336012)(2906002)(40480700001)(2616005)(7416002)(1076003)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 06:48:05.1543
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 878fbc3a-fd10-4c39-5682-08daadb00beb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6912
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When RX strap in HW is not set to MODE 3 or 4, bit 7 and 8 in CF4
register should be set. The former is already handled in
dp83867_config_init; add the latter in SGMII specific initialization.

Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")
Signed-off-by: Harini Katakam <harini.katakam@amd.com>
---
 drivers/net/phy/dp83867.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 6939563d3b7c..417527f8bbf5 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -853,6 +853,14 @@ static int dp83867_config_init(struct phy_device *phydev)
 		else
 			val &= ~DP83867_SGMII_TYPE;
 		phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_SGMIICTL, val);
+
+		/* This is a SW workaround for link instability if RX_CTRL is
+		 * not strapped to mode 3 or 4 in HW. This is required for SGMII
+		 * in addition to clearing bit 7, handled above.
+		 */
+		if (dp83867->rxctrl_strap_quirk)
+			phy_set_bits_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4,
+					 BIT(8));
 	}
 
 	val = phy_read(phydev, DP83867_CFG3);
-- 
2.17.1

