Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5258832C421
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbhCDALa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:11:30 -0500
Received: from mail-vi1eur05on2082.outbound.protection.outlook.com ([40.107.21.82]:65280
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1357284AbhCCKtU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 05:49:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4I9IQYrUp6oG6omAgiVZ/uTNA7BpeqbBg57ckf7FCVUuaIsUPNtWDPiGnTJlVZW6N21gjQl7cJKB9iS3jxtSbwgjy9nHdmceJma2H+cTesh1ILTRi7mYdu/rK30GFEL37PN9EubNolkGZIIKazypjGseJTmges5mQospwv8ayWM2gqPw/AO6Pb6giFfKr8gfSsft+JOgyErKlbT/dAfTXDBP0nESom8SxqZsStxEEIAhQBJ0Db4NExEvbMGYJETGfNDWpRmU14rz0nxSVNbsTMX5b7vEvqzZfkA6DYhRPbd6wEp3KmPMYF1kj2LMhj8xm5xelgSAjbbKU5pjI80rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNBWC0oARNa5FS8KraonBtwqLcIkzolvcXvFT0yuCXM=;
 b=MYYbSlmEP0wbvCmqgAOJYmbIg7LPpPgJnYTB1qdCIQJ/cDMLGOmHjYDEWC/zbwRHHC2gSa31EoApnjfTWIvbT84VRdbyLrPhHLf67PaNbwk1sHc4LFCAix0l2kAPQMWM/rPxaUmS0ecVRCh1ZDi3qWCb27sh2nQiBf2lY1ISF47FpWoesK4EikJ5q1iiuwFaaintQcrlrgI2E5FeNImst7/LXxc4l7AlvItDjSaOrkH60lq1dfNNOi/Gi6TkxCTqXNNUg+a1VAM8p5aL6rTxNZMUQKzyd1oS+/6glC0Gnz0URh4qjoMfnFrRbNM4XMSJuM5OKlY1I7UbMdqL96vpWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNBWC0oARNa5FS8KraonBtwqLcIkzolvcXvFT0yuCXM=;
 b=qDrx2yFbO1r8orI5pQo5pI+fAHOh2WvD56QdkX7Gx7OHqpp1qSIgvkyQTg6VK0UZUjINuWSVKl1lnFv1cHQvPrpqNTrJ3tUoWLi7wvZNLwaTTuQWd0y+pfB+pXa8PFMvxn1wOSKen4A1wTxb3M5tupehxN2ZLB5KavfTudmADtk=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6252.eurprd04.prod.outlook.com (2603:10a6:10:c8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Wed, 3 Mar
 2021 10:47:32 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3890.029; Wed, 3 Mar 2021
 10:47:32 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [RFC V3 net-next 3/3] net: stmmac: dwmac-imx: add platform level clocks management for i.MX
Date:   Wed,  3 Mar 2021 18:47:24 +0800
Message-Id: <20210303104724.1316-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210303104724.1316-1-qiangqing.zhang@nxp.com>
References: <20210303104724.1316-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR04CA0068.apcprd04.prod.outlook.com
 (2603:1096:202:15::12) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR04CA0068.apcprd04.prod.outlook.com (2603:1096:202:15::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 3 Mar 2021 10:47:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2814bb5f-a3c1-4f14-0388-08d8de31bfa5
X-MS-TrafficTypeDiagnostic: DBBPR04MB6252:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB625247EB7EDDD90AFDB9B267E6989@DBBPR04MB6252.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:632;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ivsiwz8fMwzZmZsFpsmz6wojfm35glqlJm1GKpyB4zkzE+onfpSad6+BzLisrz9Bs2YLsSxtOcPHrsKRdsjMSquCOfH8vsSH6k9oLMkAx0ogBEmuo1A8pk8crr2F3KsGJWMr3n7/j7UF3MkJMqdhq3+kx3yvqpPuPbrtsiqd04/H+tsdLFxy22rVCDtISZxeIBn9JPF86d6Dr+wfrpBVZCeaRuFnG6ereisMaOKscyHG47oOHPCyu7+u9KLsRf9gskkbQU3aXgmykYC7cES3rvOLR+FLn0ymHHhj6t2/mraYstEqimOpKFpNJn4Bk0fZC7j8C7NODzt4jKCN2dJpxQ/jdm8gtpXEL5zaJvxuXJ6AM0SsR5RauCc/dW3qS+KBzlQdlqyhBySu31ze67WQ7KRb/T0tK3iUBKmTcaQgbDr+tn93LU9DKaBqP1lQg5SU3e7gV6zBpjIfewkzYnOHPUSPl/MgX4D/YfCFiU5fxGt5O6KA4Cxtw3UxNOfO6pTaqN0Ah8wd0csXiEyI7dA1lWgn7UBu8lVbRiILCE85APijmh1WYNm2Kw23fmAciqDVTU1oK5iiXZhJeV7dytxkMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(478600001)(956004)(316002)(6486002)(66946007)(66556008)(16526019)(186003)(2616005)(26005)(66476007)(8936002)(2906002)(4326008)(8676002)(52116002)(5660300002)(36756003)(6512007)(6666004)(83380400001)(86362001)(1076003)(6506007)(69590400012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?O0Q8oLi9FeGm3jovyYHFnesRZxWj+l72+XHbGtjUDL8aUJS2zf63tB8thtcq?=
 =?us-ascii?Q?mPAMIOfk1hSFcS4mTKrcy03jB4HGV4WHOOFQSwVO4UfRLp6vK0s1SnkP9yqp?=
 =?us-ascii?Q?Q9jnakgjjm2yO4JLH/TffpFa+nZ2WNV1SchXS9d9ugv9103ZiJnbGu4pXCN5?=
 =?us-ascii?Q?NG4EGWbOm/r4Lbw/v0lajoZ4vci1N/P2y3MxORkRhgbxACDONuuHEeWyvFvl?=
 =?us-ascii?Q?bDUKt1jJBIlUyMZubNGwvcvPZLIcmbXkY9jFG2C+YflbbpPWLny8YQ+Wj1rW?=
 =?us-ascii?Q?K2rJ+MyjzN8b4zWWAUDkDu/BXuLUg6lz3eQk99GuggBrwzjBmcpNf3WuFFFc?=
 =?us-ascii?Q?rj5xXgBT+n2Uxrrgk6qWIkoqKybetQSEotNe+Vz9//uN+sdyi8HNgNsAKgUT?=
 =?us-ascii?Q?o5vxcHibZ/cisla5DQrx2KJMz+avPoUUmYkSOwfZ67DKEh/hweuF9/75wcZ0?=
 =?us-ascii?Q?1dO0rVQsN+MJirApF8LWsPIZ/zAdlkHk93NhUmaew+qT8iCzAPTgLhLbh0pG?=
 =?us-ascii?Q?24HbHno5dNA4CBUvqqOrSWAUZAxxHxPu5lkQ2NjKpRjU1EtYxyTczyd0zxn+?=
 =?us-ascii?Q?H94++nDt0XhnMIYPSkZcsbu1AzOKiWR+0hkY3BhwPeEfqAxjbXYasazArc0U?=
 =?us-ascii?Q?DGPHAbWy+b1v9pA3AI6ADpv+F+GnCwNyTKBTEh0oEBo/ZHI0wKUuc11NTWmF?=
 =?us-ascii?Q?ScXeybmqyBplqfkPconyETaN2TDsuy8gT7X9fK4ez4ljszDbgGAWtEAchk/V?=
 =?us-ascii?Q?HHLNfQM1BxYTypQCro0RDXmNAMnYlAb2HC/FLEXa8aVZtK/S2g1ohNeT4UJQ?=
 =?us-ascii?Q?A0D1Ykd8p6NakSI9iSTbTrN7w6XEYfka2e3mmpq41U9BsoNMW90d/6CHvGln?=
 =?us-ascii?Q?ibjr88tEeuXpuyy57SSVS/Biuu88KLszht6/WXAcdkaXrLUCoHmOjygD6++A?=
 =?us-ascii?Q?0L2cuui+yPdoD06zeDiFzLrXtuqcOG5hCSiN6UURrGS2At3VwgIZ6BWttvSN?=
 =?us-ascii?Q?pc/z7fHRL0524FrgbzA8GJIGH9yWtmAkHG5i+0juWOnnzFnU7Y8bLz7Y2uqn?=
 =?us-ascii?Q?0p1lfyQCfrcqjC/9OWEFCwc3xOiS4ayhoASwRIDWkr5mEo+Hy73pTRDwM5dR?=
 =?us-ascii?Q?O4ndP21EQMISSS9flhPqTJMMSW1JoN4N+d3k80DIlbAKcwF2XEGtPIpwaYvN?=
 =?us-ascii?Q?f2UM0Nu0nC6grkn/iaf049VJgWkZvkCOnszp1Hy7YdOJlowV14QylPKPftxa?=
 =?us-ascii?Q?aA952UqMkD79F9bGGjpT/sxzJU2CShwij6jXu57INNFn4svX/koMaCMCKyWw?=
 =?us-ascii?Q?cI7Pd9D6zEhmfSZDjKKATTLw?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2814bb5f-a3c1-4f14-0388-08d8de31bfa5
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 10:47:32.4464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SxjqMRw7LCpGDViRJjl6P5NpRE6RqZUA11GlHWLgxawOB4kuTLYPTVDrq5TKpH3pSpjfnn8IoOTSWe/XSLPwqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split clocks settings from init callback into clks_config callback,
which could support platform level clocks management.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 60 +++++++++++--------
 1 file changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index 223f69da7e95..c1a361305a5a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -90,6 +90,32 @@ imx8dxl_set_intf_mode(struct plat_stmmacenet_data *plat_dat)
 	return ret;
 }
 
+static int imx_dwmac_clks_config(void *priv, bool enabled)
+{
+	struct imx_priv_data *dwmac = priv;
+	int ret = 0;
+
+	if (enabled) {
+		ret = clk_prepare_enable(dwmac->clk_mem);
+		if (ret) {
+			dev_err(dwmac->dev, "mem clock enable failed\n");
+			return ret;
+		}
+
+		ret = clk_prepare_enable(dwmac->clk_tx);
+		if (ret) {
+			dev_err(dwmac->dev, "tx clock enable failed\n");
+			clk_disable_unprepare(dwmac->clk_mem);
+			return ret;
+		}
+	} else {
+		clk_disable_unprepare(dwmac->clk_tx);
+		clk_disable_unprepare(dwmac->clk_mem);
+	}
+
+	return ret;
+}
+
 static int imx_dwmac_init(struct platform_device *pdev, void *priv)
 {
 	struct plat_stmmacenet_data *plat_dat;
@@ -98,39 +124,18 @@ static int imx_dwmac_init(struct platform_device *pdev, void *priv)
 
 	plat_dat = dwmac->plat_dat;
 
-	ret = clk_prepare_enable(dwmac->clk_mem);
-	if (ret) {
-		dev_err(&pdev->dev, "mem clock enable failed\n");
-		return ret;
-	}
-
-	ret = clk_prepare_enable(dwmac->clk_tx);
-	if (ret) {
-		dev_err(&pdev->dev, "tx clock enable failed\n");
-		goto clk_tx_en_failed;
-	}
-
 	if (dwmac->ops->set_intf_mode) {
 		ret = dwmac->ops->set_intf_mode(plat_dat);
 		if (ret)
-			goto intf_mode_failed;
+			return ret;
 	}
 
 	return 0;
-
-intf_mode_failed:
-	clk_disable_unprepare(dwmac->clk_tx);
-clk_tx_en_failed:
-	clk_disable_unprepare(dwmac->clk_mem);
-	return ret;
 }
 
 static void imx_dwmac_exit(struct platform_device *pdev, void *priv)
 {
-	struct imx_priv_data *dwmac = priv;
-
-	clk_disable_unprepare(dwmac->clk_tx);
-	clk_disable_unprepare(dwmac->clk_mem);
+	/* nothing to do now */
 }
 
 static void imx_dwmac_fix_speed(void *priv, unsigned int speed)
@@ -249,10 +254,15 @@ static int imx_dwmac_probe(struct platform_device *pdev)
 	plat_dat->addr64 = dwmac->ops->addr_width;
 	plat_dat->init = imx_dwmac_init;
 	plat_dat->exit = imx_dwmac_exit;
+	plat_dat->clks_config = imx_dwmac_clks_config;
 	plat_dat->fix_mac_speed = imx_dwmac_fix_speed;
 	plat_dat->bsp_priv = dwmac;
 	dwmac->plat_dat = plat_dat;
 
+	ret = imx_dwmac_clks_config(dwmac, true);
+	if (ret)
+		goto err_clks_config;
+
 	ret = imx_dwmac_init(pdev, dwmac);
 	if (ret)
 		goto err_dwmac_init;
@@ -263,9 +273,11 @@ static int imx_dwmac_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_dwmac_init:
 err_drv_probe:
 	imx_dwmac_exit(pdev, plat_dat->bsp_priv);
+err_dwmac_init:
+	imx_dwmac_clks_config(dwmac, false);
+err_clks_config:
 err_parse_dt:
 err_match_data:
 	stmmac_remove_config_dt(pdev, plat_dat);
-- 
2.17.1

