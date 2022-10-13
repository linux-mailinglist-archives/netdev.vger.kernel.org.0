Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E9B5FD587
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 09:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiJMH2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 03:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJMH2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 03:28:43 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31558108DF8;
        Thu, 13 Oct 2022 00:28:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVQ/sUPU0LYHogl/rQ6GJlLRMjT88PtwRN2U/dCqAS5bKzSxt48TkmnMJsVstkx1POuNlulqZHgJV+JBqTDaZ9eTaWBiGRay1+t/yacgjPgrKNlbv+AN6janqPE8ugwM4zxhSRp/9kl5CViOdQuhxpLWEn9H3A1rQl7bMzcT4DDLKqO3PuS7QsKo6EcklVunBFwpINrSCxrS8W55g5IsowJGPT2lO6LYGEL2spSYFgB5S6IfG7IZYPEEzRBusZxaruaUdy6ByAYXBLKNYQhJMUOGr09cgiBzGa+wJq7GN76LFRKRs8DeMPZ4VQ8+rIL80xxnX9yeDcD7Xng/svZuwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WNrQj3Xj4uZJK9BtF7jEqBxOLoFk4ODZvhUj+8gStYM=;
 b=UOKm9xhfhcDY1QwwUalokJ6zc4v09qsQfgJJrxOGnxMnaIBqksoM1PDPB+jrGI7zvZA41VTaRz6RajXXYLguXyg6Duevxa4L/lpm4yBKbJtLdf+tzZSpsCuuNgKvE0abtKsXqake1qm8Oo/i5IZDiNs/2VkOQn0lYhglGvKoJvKUA7E8aWwcoX6E1mGvH1Qj6buCwv5HD17p7r2vQzBOyoOfw934WKQGbwNYW1f75RZGFRuV2wXSdNKP8cp/o3q+akSqgRidVJY3cCMgi2D0u8x6UgT7MLfgf7trnlGPgyVvlDBzN8eZbzqgzP8/EEeffJqus27vyp83LB/az46Nnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lunn.ch smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WNrQj3Xj4uZJK9BtF7jEqBxOLoFk4ODZvhUj+8gStYM=;
 b=RvpeRrAU9vRAI7PfkOIJkmWAQwCjcOIYHu5ypzg+vFvcN5u6FYhk7PVIKj3btV7L1Yz0yGCPyzUYc2d/fe71mjpd6yMG5CZxSPRMCoaO2n+NcQ7YnaTy03Vh6+IUoAQZiaHDysExOpGSV5XpYtUVnz7bGGpXHwir467pVV3UYto=
Received: from MW4PR04CA0287.namprd04.prod.outlook.com (2603:10b6:303:89::22)
 by DM4PR12MB6039.namprd12.prod.outlook.com (2603:10b6:8:aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Thu, 13 Oct
 2022 07:28:40 +0000
Received: from CO1NAM11FT090.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::ca) by MW4PR04CA0287.outlook.office365.com
 (2603:10b6:303:89::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26 via Frontend
 Transport; Thu, 13 Oct 2022 07:28:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT090.mail.protection.outlook.com (10.13.175.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Thu, 13 Oct 2022 07:28:39 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 02:28:38 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 00:28:37 -0700
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Thu, 13 Oct 2022 02:28:33 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <harinikatakamlinux@gmail.com>, <michal.simek@amd.com>,
        <harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [PATCH] net: phy: dp83867: Extend RX strap quirk for SGMII mode
Date:   Thu, 13 Oct 2022 12:58:33 +0530
Message-ID: <20221013072833.28558-1-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT090:EE_|DM4PR12MB6039:EE_
X-MS-Office365-Filtering-Correlation-Id: f8f76d68-5c64-4355-7311-08daacec8c94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f8Y6+I6tNlMpa0agCmRbakoGA8kAFlYCtQGujDbQKINc5X85RHSN6itssxNt9gVGJDB9/r8AVtzGqN0JiwMJBVFRvrhN4H+l/IETN13lD8HWwNFRjYc+NZX1j6ZDPT7zILCeJ3DN8NFAivcM2pX6eEysYGaBhjor/6+x1wxfqyVWdx3XM1NfaahRMz9zgHBBg2XIJkMONocY1d9v3i5B2NqteHaY1RlojxYhl3VbdkGE2sWZOztZD9ke9Qf/LJm8XM+ls9UV+35Qd6IorYxCxA0pA2D4xlamFsAtbZJYE5WbgkmujGBdU8NuFnessDmX2bkp/f2MWbGN4r+OibKPUHr3KOmx+Bw0foGw+iVBOQpPza18uU4UWKZoEM17d3Q6PIFFlDMKoyt0XGUHCHWx67SCo4HKBjjbTlZWpLrhvYhhNpaP4woRtv7zXOYI+AramXwV9l8/Q4xtr+PJD8sKaMgbrxUtXs4dz58ZIJv20kOF9e+mUFixjFDgFv65+M9jc0KfAWyjv1O4vUKTPTEfV4LaGD6h4Q4gKV/ggN91Vc2tf7MJUsqr6+/M3Foo++HUs0W/n32Jl7So/fl/G6F36rlw+sCghzI34c3OKa0E0J6F/qRkFuclhj3Sk1UyA98ki2RWSe+vaJVuNIFrdHOuGZsClzhXZyMS/sSX0r9x8QDTt0TsjePV6c0VslZzZ+BOykWuBwXG5M+aIQGAujTQYtnNTyFu+HfcfHP4gaZI+CgrgTGTu8/xwSwJQgjt0xwAcQqum0VBj2WkBNxsiJ9oRy1gM+oSDNFRJR+Xpwh9rsxn7D1Cj5UymbCQKlZEHJn8
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199015)(40470700004)(36840700001)(46966006)(1076003)(2616005)(336012)(47076005)(426003)(186003)(8676002)(356005)(81166007)(36860700001)(5660300002)(7416002)(82740400003)(40460700003)(41300700001)(44832011)(82310400005)(4326008)(40480700001)(26005)(316002)(2906002)(478600001)(110136005)(70206006)(70586007)(54906003)(8936002)(36756003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 07:28:39.5269
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f76d68-5c64-4355-7311-08daacec8c94
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT090.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6039
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

Signed-off-by: Harini Katakam <harini.katakam@amd.com>
---
 drivers/net/phy/dp83867.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 6939563d3b7c..a2aac9032af6 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -853,6 +853,13 @@ static int dp83867_config_init(struct phy_device *phydev)
 		else
 			val &= ~DP83867_SGMII_TYPE;
 		phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_SGMIICTL, val);
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

