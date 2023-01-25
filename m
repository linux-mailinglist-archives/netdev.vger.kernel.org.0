Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6BC867B93D
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 19:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235736AbjAYSXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 13:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235818AbjAYSXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 13:23:45 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2110.outbound.protection.outlook.com [40.107.6.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AF25AA42;
        Wed, 25 Jan 2023 10:23:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQeKBWCOWwKAlzeVm1m3zg6qgeGLtgg+jonTF4QLfQ8Z3ese4BRp/q3oGN0L8ZsTnS9i1eWT2bR5x1I5DlIz7vttLEWPh/KuoOmau6nq8hvz4af+O3fnDfm+L5CmamBR/hPlmw74ELki0mMexotCIpKqis0eToFUv2q29mzUihaNgUG+p6KlYUPTsFStZLzOpqp7WUwUk3YQT77kMIzpWrG9Xe7RfVxKhX4j6UbY/U77N9PpToESChfZFZydrQrWi24SmxIJecd/s1gHV0NIGLBqLQVThcrQM/oxyJRj2AIdnkgwJfVLmZbZuaCWKdP3XbgNEZd6hHAkozQ814shoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cS4WXpVGCsC/OGV2DQM1+rgR3U8vlkHV/vTITd7URwI=;
 b=gg0tEgfGgRXUzSAcmRl6PxfWiCB028KNC1/QgahA9RelXjp3S09MldCll15SWb2Ib7SFJRQYb13yfOk/zMvX71YldCTRmClJ1HjkpJtqK51khF2MdtJiKzh42TInRd9+enQKWrd/b+TJ9p/MvQzD7MakIRNe7J5MwIM81gPo/0QLxSp0k82dfLwo3LHtjLxUDAvqMO6X6vGPycf8OyDbyzMc7xcoU4thKcFlzwbN++jJGmuCQspNvJUt+c/VGhq4IlXztCjI42bQ0dzOn8mLuGGMYbXWyTZMNYJvV7uMz56cLTUDjCVo7OYcHC8qScBGBFMreEX5njJahQYCZMlLPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 52.137.61.15) smtp.rcpttodomain=lunn.ch smtp.mailfrom=sma.de; dmarc=fail
 (p=quarantine sp=quarantine pct=100) action=quarantine header.from=sma.de;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sma.de; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cS4WXpVGCsC/OGV2DQM1+rgR3U8vlkHV/vTITd7URwI=;
 b=TD+GP3Dt3vEyYs+SdERuCf4lCsPmfXJu6dDFHA7ajapOMonwS9+2qufePbJ9BZla7OFb6g9++FyGX5kZ+u5CIS/zdmhDzzecgeiF5RSaoxG+xwe5GU0aETHO9BaDxDYPqakR93R22tAECHTN8BrBe+p833NmR3Ebj2Ka+cjFyGA=
Received: from AM6PR0502CA0068.eurprd05.prod.outlook.com
 (2603:10a6:20b:56::45) by DB9PR04MB8123.eurprd04.prod.outlook.com
 (2603:10a6:10:243::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 18:23:30 +0000
Received: from VI1EUR02FT051.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:20b:56:cafe::d4) by AM6PR0502CA0068.outlook.office365.com
 (2603:10a6:20b:56::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Wed, 25 Jan 2023 18:23:30 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is 52.137.61.15)
 smtp.mailfrom=sma.de; dkim=none (message not signed) header.d=none;dmarc=fail
 action=quarantine header.from=sma.de;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning sma.de
 discourages use of 52.137.61.15 as permitted sender)
Received: from mailrelay01.sma.de (52.137.61.15) by
 VI1EUR02FT051.mail.protection.outlook.com (10.13.60.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Wed, 25 Jan 2023 18:23:29 +0000
Received: from pc6682 (10.9.12.142) by azwewpexc-1.sma.de (172.26.34.8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.20; Wed, 25 Jan
 2023 19:23:27 +0100
Date:   Wed, 25 Jan 2023 19:23:26 +0100
From:   Andre Kalb <svc.sw.rte.linux@sma.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Felix Riemann <felix.riemann@sma.de>
Subject: [PATCH net] net: phy: dp83822: Fix null pointer access on
 DP83825/DP83826 devices
Message-ID: <Y9FzniUhUtbaGKU7@pc6682>
Reply-To: Andre Kalb <andre.kalb@sma.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [10.9.12.142]
X-ClientProxiedBy: azwewpexc-2.sma.de (172.26.34.10) To azwewpexc-1.sma.de
 (172.26.34.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR02FT051:EE_|DB9PR04MB8123:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bd88a96-031d-4688-461d-08daff014247
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qn3AFrKEhKGx/xu87kNms/9ORHyV3CIzm6AFDR/w5AsZyUyVuv746Tlm5UMLjzFrA+d5P6QyjSo0yx7zABC6wLhKwRtI6ClkeSAaRfHBoB5Bxf6e9fSyrvYAS+A51ei00+IZMpDsvJyrBEqwb/ZNJWstOMYK3zW8NBKKReX3fx6rvHNDcUcCs+KJ5Jjcj8/gexEtP6ldWFEHV243HGQxOo2MfZz7eLq3zDWlpLiJwRJX03IU+laN/b6t9qA0UVWOF7FjQ07KpT5tnAlvdC74csQUfuUkC4XWYSbmGADpusJOJa450kk/w7ckWrLnCr81xeKM89eeinTCcnk8UfCFiPjHZVG+n6q1fEz6PiyNe+oCFtZ578HVFN1Q6hNGBu0cEysQpREl3lyOKmNh+e6OzdFk3BrxfWYNOzeqhR3F2pXyndR7LyCic8Cq9UsODA8xkS5SIjJCUUVKKFZ9uRZoYE3lEUYwE24CW1TnqBCf3DhAizcxHGdumGHDJl7CqDzxTNMrm9LHCfyLucLicKQVSffnu0I82PtMHugE/aotZsBnyVH9U/GdWCl1hY4sPXu4pNkRwJf/wBJI+4kymWd9wL+XvKhmL2fWw6CfkGjH8VKb+S+yi/0I6T8XAIyvcZdlykhXDxPC8vfCpYNubqLXViKDuSoUz1At+0n1oPuT5JQJCeI6ni5OJ2A/TjxuXaM5tXELzCUjsyubIzTIlcEYeoCe5WAnZnhl19yNLu1oht8=
X-Forefront-Antispam-Report: CIP:52.137.61.15;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay01.sma.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(39860400002)(396003)(346002)(451199018)(40470700004)(46966006)(36840700001)(9576002)(36860700001)(26005)(83380400001)(426003)(336012)(478600001)(8676002)(186003)(47076005)(9686003)(70206006)(70586007)(110136005)(356005)(2906002)(82740400003)(86362001)(41300700001)(55016003)(81166007)(5660300002)(40480700001)(16526019)(33716001)(316002)(40460700003)(4326008)(8936002)(82310400005)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: sma.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 18:23:29.7738
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd88a96-031d-4688-461d-08daff014247
X-MS-Exchange-CrossTenant-Id: a059b96c-2829-4d11-8837-4cc1ff84735d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a059b96c-2829-4d11-8837-4cc1ff84735d;Ip=[52.137.61.15];Helo=[mailrelay01.sma.de]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR02FT051.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8123
X-Spam-Status: No, score=-1.6 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Kalb <andre.kalb@sma.de>

The probe() function is only used for the DP83822 PHY, leaving the
private data pointer uninitialized for the smaller DP83825/26 models.
While all uses of the private data structure are hidden in 82822 specific
callbacks, configuring the interrupt is shared across all models.
This causes a NULL pointer dereference on the smaller PHYs as it accesses
the private data unchecked. Verifying the pointer avoids that.

Fixes: 5dc39fd5ef35 ("net: phy: DP83822: Add ability to advertise Fiber connection")
Signed-off-by: Andre Kalb <andre.kalb@sma.de>
---
 drivers/net/phy/dp83822.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 0b511abb5422..f070aa97c77b 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -232,7 +232,8 @@ static int dp83822_config_intr(struct phy_device *phydev)
 				DP83822_ENERGY_DET_INT_EN |
 				DP83822_LINK_QUAL_INT_EN);
 
-		if (!dp83822->fx_enabled)
+		/* Private data pointer is NULL on DP83825/26 */
+		if (!dp83822 || !dp83822->fx_enabled)
 			misr_status |= DP83822_ANEG_COMPLETE_INT_EN |
 				       DP83822_DUP_MODE_CHANGE_INT_EN |
 				       DP83822_SPEED_CHANGED_INT_EN;
@@ -252,7 +253,8 @@ static int dp83822_config_intr(struct phy_device *phydev)
 				DP83822_PAGE_RX_INT_EN |
 				DP83822_EEE_ERROR_CHANGE_INT_EN);
 
-		if (!dp83822->fx_enabled)
+		/* Private data pointer is NULL on DP83825/26 */
+		if (!dp83822 || !dp83822->fx_enabled)
 			misr_status |= DP83822_ANEG_ERR_INT_EN |
 				       DP83822_WOL_PKT_INT_EN;
 
-- 
2.35.3

