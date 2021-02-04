Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BED30F049
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 11:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbhBDKQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 05:16:24 -0500
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:11334
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235298AbhBDKQV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 05:16:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bt6raflU6Y7KKMVzv/UWJLXfQUo+uS9x4vDmgX5qYpd8QQRWJTzsHwkPc24TTSEdpUYQndrGQ0n8Njvt8dfQ7W0UUwjIvrTWtZid/pP1mmS238hvy03qzTFXY/4Py2tvV+RrPkWUkXanb0AFzlSvIOh49lU8If+XCcgnaR51nKl6a30azl0mylO6M1nGUZHi9omm0b1efW28HkoDb2OCMRlPKDxBCtyQnsNSLdZJNgi6H6eYZaEBy6DTljPkFSZQ3PnGzSjJImaKabGQRfuQIrBQjQrhJlGwgZgQ0fCnGmtLdQcDXo4GpsbzFWv106k2F8gSMD5h0Ao6KxuGrH55FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMF+eIomc07M1aaurkyMl3E56xVyIvVQKQAjRYpKjzo=;
 b=Vo3gtwUtQNMk71NXzmWpBFZHFXsx9kqYrXzEQ8HKE1fiNHvZ8617aUFfKaub5I1u9gE6CH9VyiTqACMYX86NMzRCXJMo7Zo/nFXewjFpawdaJMvTFnJaTMVcJ7eoPnHv519v1nqncNW+QdsDFOqFdJsYmG/LqiNxqzYQDVK3WalFlM3r1RtOXS0nOm0e/clogKG3lujZt2V1Dkn2/EaGcgzefdL6nNWv7D3s1egcWoTjm+6FKH+IVAQ7Msw6yd0nfCTAnCJsM5Y4TZoyVdt4BFlkVpIrLTpfMhzQ+O6gHcWWGQuqLbYU/fzX1ciDcRWEokTUxRcfc+/GY35c8eGw3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMF+eIomc07M1aaurkyMl3E56xVyIvVQKQAjRYpKjzo=;
 b=VGWtKcPT88Mwu+f0lyHqNC3FiqhhWU49KI4I1/qy0UHi8/kVzja3irS4khaQjV8X5WgjKd5wTXa9pYT6MATlGTnmRTR/7XYk9guqV47Ez32MgwfPZoK0nTh25cqgDZyhAjqPpE1d0CMB6o8Rhye6nI1VCOibew/AQycZ+OXte5Q=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VI1PR04MB3055.eurprd04.prod.outlook.com (2603:10a6:802:9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 4 Feb
 2021 10:15:32 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14%9]) with mapi id 15.20.3825.019; Thu, 4 Feb 2021
 10:15:32 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCH net-next 2/2] net: stmmac: slightly adjust the order of the codes in stmmac_resume()
Date:   Thu,  4 Feb 2021 18:15:50 +0800
Message-Id: <20210204101550.21595-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210204101550.21595-1-qiangqing.zhang@nxp.com>
References: <20210204101550.21595-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2P153CA0032.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::19)
 To VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2P153CA0032.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.1 via Frontend Transport; Thu, 4 Feb 2021 10:15:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a6a35f43-329b-405e-33bf-08d8c8f5ce05
X-MS-TrafficTypeDiagnostic: VI1PR04MB3055:
X-Microsoft-Antispam-PRVS: <VI1PR04MB30557E0AB4F766E1D154CD53E6B39@VI1PR04MB3055.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x5LV8OEMvUN5wIbnaIU8whDEROD4GbgyE4RbPstN8SH8STtDvF4A0aFgF41pQVIkIIOaoYe4yXE6Oo6a/rSoqvbdmotPjgIQzUS424YXCoQpO1BlY9lL5jiAbPReAaXc9lQN8eGfVkzKqsZHsoO6fVK1TucM2cmnTz8IizxYWxgBz63pzAha+B8wCKeCTFHaQOTHWBTeRtJvnWVSlHNEdIDOCf6DQ2dHbIWtu94MaFWlzVoTFTLQA+wWHr5EwoiFupiJMTNYhdv1E6++WufEV2Ga2x/sqM1sQT6NigBqdz31lqiqQxfxfQHlDcB+zqsHcNlwNlHwaeTDMZidalit7afkCWNq5G7B1XMGs1Gv4qmdWgPcchtEDa3e/uJklFyinY9VrccMTMMCGXet01EamRQpPAD3xLIzN0VO7HtWib2skR3+XYoufFoqdP1w51DhiV2H4XhBZjgjIDPMQB9yGVQMOfuVJymornI+8+VCkDkwhivKUsm1ccW0++IUP6wK8OwBzSaJ6Xu52SPeJXAFAHiRKeg7HxYe4Y8D2Uog/lZaMO4WMAAYGPi6eZ9KGqI6sakoEc9WZ4dGg4UgGz3aoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(39860400002)(376002)(136003)(6512007)(86362001)(8676002)(83380400001)(8936002)(36756003)(6506007)(6666004)(1076003)(5660300002)(66556008)(478600001)(6486002)(26005)(16526019)(52116002)(66476007)(2906002)(2616005)(956004)(186003)(316002)(69590400011)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?l6HdUUYTdQqppz+FB0sJUTglhW71cWNi3PafbexgqJPHCy6l0wxJeSWqTlG4?=
 =?us-ascii?Q?G9kb1afMxD87c9DR6gtvrTNAnCenHcqcvFgj/+rUR2QgNPra8jMt6UuMgCec?=
 =?us-ascii?Q?BVeV47UYSF7OBTvQd5ppSnAuiYiSoG47G7z8e3ui7xqg+C9AtPIdGgCGa0rs?=
 =?us-ascii?Q?IGj2Cr3r8pVyid6LzG8qtVj60DK1P+ifg4mlItu/qayP+sLCpzGetridtwBQ?=
 =?us-ascii?Q?crHN3+FNmYBTRVQWh+SF0zML64s9zfHGefGJliuPQO/Qj/PcbrFTzOh6RepX?=
 =?us-ascii?Q?d+VnsPgnAQjQYc9wHURMbiYAJIFQbsq/De9kd0+kj0LdB/JwpkdtqPZOjnTj?=
 =?us-ascii?Q?aqcHWhxk6p4EgHW+2DfdaNj/S72biOI/GwwvlVDqttamwMJqGRpKv3TkYDef?=
 =?us-ascii?Q?YqF4ANcSfF/PY+vz4znKacyx0JnKZLDXzPtRAqcAcT5B3j2IkhRZ5r6FRzry?=
 =?us-ascii?Q?SU7c3ebksdkMa+VbYMlEKvW8FTOLHFuJGKBwkIok093rrMS0YsBSIyuuZ6A/?=
 =?us-ascii?Q?EXR3HGwNgGcfYicw3AAmFMsS9NMoq12H2H5zlJX9tFteBiamR/8tBi3EPrTZ?=
 =?us-ascii?Q?HJMqd5z75bac24J0zpDl0lSxa1KXLaQSM3465G3hkaTKtTEEPlDGIIGzDQLj?=
 =?us-ascii?Q?lVB1/ooGxtZihKz2RdbkmWZDY0xhV12+PW2xVYTqr+Ze4Sv+yqCtMWPLpPD8?=
 =?us-ascii?Q?6mi7uYRrcVO7QbLCC4w48B0oND1rqQCb0dodY+0RIbaSuDLYtU10qWHFk7YE?=
 =?us-ascii?Q?fADXu3wdTSOJI80lpRH9hT/g3D3bnUIpmpHDrdhpl0JOO1wJ6OH3IgPcl8SS?=
 =?us-ascii?Q?Zkb3GsHFw/npLgKhp6itomnsjXELcAVnpqzNlMvgDaPzGCxjDlK6r+nQBHbT?=
 =?us-ascii?Q?4UD7PJyMHVvMlY3cqvG3kNucoV28BiXuppzmSh/xGDLVm+wL1RtQA8F3fiFH?=
 =?us-ascii?Q?p2pTC4geGcoZE0HRqsGlXqwfpsOMw+FGfnWiEpA9vLs2F3DtLXUKkRxyA9aj?=
 =?us-ascii?Q?NAwbYY3lodRQfcQy2M6wgzAVrHKWoU+IQKUVdgf0S2po1PpBSE8cKWV6LqkD?=
 =?us-ascii?Q?m1WsNmg8?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6a35f43-329b-405e-33bf-08d8c8f5ce05
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 10:15:32.6096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0aRjLkCRYNP8zphRlKjp6qE5TbMRKsj3+fmLh4X4IvzNZTxbCj+VGLKAGWxpeExLe2U+KyedgBr18SE8xDf9/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3055
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Slightly adjust the order of the codes in stmmac_resume(), remove the
check "if (!device_may_wakeup(priv->device) || !priv->plat->pmt)".

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 11e0b30b2e01..94d4f5d294f4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5295,6 +5295,12 @@ int stmmac_resume(struct device *dev)
 		/* reset the phy so that it's ready */
 		if (priv->mii)
 			stmmac_mdio_reset(priv->mii);
+
+		rtnl_lock();
+		phylink_start(priv->phylink);
+		/* We may have called phylink_speed_down before */
+		phylink_speed_up(priv->phylink);
+		rtnl_unlock();
 	}
 
 	if (priv->plat->serdes_powerup) {
@@ -5305,14 +5311,6 @@ int stmmac_resume(struct device *dev)
 			return ret;
 	}
 
-	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
-		rtnl_lock();
-		phylink_start(priv->phylink);
-		/* We may have called phylink_speed_down before */
-		phylink_speed_up(priv->phylink);
-		rtnl_unlock();
-	}
-
 	rtnl_lock();
 	mutex_lock(&priv->lock);
 
-- 
2.17.1

