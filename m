Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646AA324F7E
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 12:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhBYLvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 06:51:35 -0500
Received: from mail-eopbgr60088.outbound.protection.outlook.com ([40.107.6.88]:24657
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233896AbhBYLva (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 06:51:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQkkAuxnbBEkgEFreZmIWzBdMcjcW1yz4J9CteOjbPm38v1/3pk+oNY3wN6KAuwIYu2XJ2vpjc6wbAquE+VRoKF3HybMFYrt5blQ3VHkH4uFpg5POG84Atu24hW0Tr+av0i5GLRGmZfToaGzC0Ik0VIO1iySV+bFVcf6qoXvNTJJsiELTwKlJ+qKba1ipDEK+1TF5+H6jN+ldjWbdbsGnQB5MqzJMxp/2G6jakESCT85o/yFRx1hMN9PSpqRLh6CSiuY03gN9QYziyt6gKwCmzOM6e2g3kUJZFGk00oFgfKUfRTMhUYY7V8iNzLfoJqV50V8voi1zMR7i/AhBmn51Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwlpXMc9HeU0HUozihgQ9MCQZSvHXQlYtz+rjy0O8LU=;
 b=Cb9XKsg9b1H/xmyTpKrqoUeLA7d+MBbavByedHQ4Dk7qpPfgkqC8uIvoJo4T6KTpVcjvF4WFQwBG2vEd309HJNOgRB5IHI+F1NmxvONHe4f0MXcSKGhgAlMH0eytUo1J3AM9716qO+IBbZ7D1utz8yt2N+GVN60XLgzNkwfdKaxoqfcR+0YUAk4K9ebfYa/ExuRJtd9gG+rJDF7HGdO/E+J6AlNTZvscS77Z50rE5L0BB+IuuS5zEfxl7rDGtYmj5ia3OzfV0ktOzne7qfkHCEzhZn8GTuKRnAFY/fKMMdvytvHqV1g8/SzlJXBzg9SXi6rlOASjbT2Snmuyy5q+9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwlpXMc9HeU0HUozihgQ9MCQZSvHXQlYtz+rjy0O8LU=;
 b=SJl4mDS0B4gOrz5MG6NopGxfRiqvkxYCLTXBL8b6ksGf+/CnSRc3VIHIytrck5nqor9Lr01xzKzYlcWytxtYY0FOuOHsOMBevNOmO2a3cmFaYhXYghMgEeS1NTCNP6N0TRqu+kr20Q6eFfDdaC60VBLSKbWb+Caim+97U/MnI9g=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2503.eurprd04.prod.outlook.com (2603:10a6:4:35::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Thu, 25 Feb
 2021 11:50:37 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Thu, 25 Feb 2021
 11:50:37 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [RFC V2 net-next 3/3] net: stmmac: add platform level clocks management for i.MX
Date:   Thu, 25 Feb 2021 19:50:50 +0800
Message-Id: <20210225115050.23971-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210225115050.23971-1-qiangqing.zhang@nxp.com>
References: <20210225115050.23971-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR04CA0132.apcprd04.prod.outlook.com
 (2603:1096:3:16::16) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR04CA0132.apcprd04.prod.outlook.com (2603:1096:3:16::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Thu, 25 Feb 2021 11:50:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d7d303b3-8e4c-48e8-7d4b-08d8d98390eb
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2503:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB250372F7713A5CD7D8DA1DBCE69E9@DB6PR0401MB2503.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:632;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kCUBaOe3oZITws/j+2tJgdoF5kM9iLdzEMQ3vPlx5o57zFTHr6+CwlvzvDwql9rS7AhvmDuzf8D1ncYaASIBnW/Q/FX/0leZrCiiQgVvjkOMuEkYRbfDghJ2t1anb6diuIsqWBixo7J0y434s7NCSppyyZh/ud03tQZkX3mVS6HsHWwW6/ZUJuHBcd97gdwemDhjv1AmXJu0NRLmlfAVp0y8mQ0J2n+4BQ9jgX/6Meg8Fe8hyeeLmBn2+mIKpTnb9fnIGsO7YEECTCOs5dmbiQriVSmjvhPQGUDf4avx8Qd/I/eT8hq3YdAZBA5C2cYhiZe9n6sZAQUYjuUaaT99AowrwHgVy/lUb6MVAEXgfKSIbbuDVtASPVVejjyziSnjkFdYhw4Bd7J1n+9DIVCHRGJa5q1RyJbchCvOXWO5Wq3WQUepfoYSFkgkQM+n8fT9Gq+ZfPWcTmechnJwg8rxnAq36SBANsTFxYzOqQBfW1spGIGvY8+j2XxjyU/RuC+mspzsgr/IqddC7cI4FOGXNd+SLYdh2OpLApyMYTYo2GlVmwZwHCwRGL7EyZ/OCRIISM+++2wCD0kee2dMte6CyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(8936002)(5660300002)(6666004)(8676002)(2906002)(52116002)(4326008)(316002)(6506007)(66556008)(66946007)(1076003)(69590400012)(956004)(2616005)(6486002)(16526019)(186003)(36756003)(83380400001)(26005)(478600001)(86362001)(66476007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?v+P6EGRKi749TZQal5Om1l7EWkr3qnxOTNoXkYqie+WQ7FQFnUxAcIKPCfkz?=
 =?us-ascii?Q?r749fy2+8IrNzjXvu0ElpMIlpRLVdMxYd+1bSoCYLigDO7hbD9Kxh//ctWuC?=
 =?us-ascii?Q?Sc7oILB+TJ/Xz1wbb8uvwio9M9nwYwymx7PVElCYVJrhu+H/3YOU1LbcEIOp?=
 =?us-ascii?Q?khp/OjxpQlYUbzWs1on6e3RlxlUMrYm40gGLnjNUGKD6QoSBgxSGAO7PsLPk?=
 =?us-ascii?Q?NMVBFL9TyN7atMHi+q7qjKjk/65rUiIUHYPrN8dKlqHopY9Vpd41/4VkU2+x?=
 =?us-ascii?Q?xMjJB36H/61Ynbh8E21cV321Iv5YwfI2xPfIuMAuSe7jANPoS6pZh3JlOvCD?=
 =?us-ascii?Q?1LYIT0WmQW/3NzZMtSRYWzoLXAXnRGoNPkmBQPE6/hRk+AldlPPIXvibV7Ki?=
 =?us-ascii?Q?HMBhHJ7FR2Beic0j2K33O9HXd4nv0kWBfpKU5EH7ka91+mCmfsMkdrcf6K12?=
 =?us-ascii?Q?l9Nap/FQakJCiCzpPzp31JTr+zAnfp/qcdG2is/fhBmxTJi264nLVahOmLX8?=
 =?us-ascii?Q?rtqUEdPQxZ2YIMIn7m7yYqDXES50PRM68mcOJo0tQ9IXi8+DFIJ9V0E5Io9m?=
 =?us-ascii?Q?sVtb11lZqgEX9PwC8aI7T5lqvl/QP8bJUqM1EIkr9c3jtCUXbW+lScjraUQo?=
 =?us-ascii?Q?zqJiuWBOPvyR2xlNkpqtOuRVJ0Sg7AuEo6ALYVIBYvErw74OV7dZd/gSPWtD?=
 =?us-ascii?Q?snvV0I8xpaMiOsk4IUtHFSJDbNW1YZ8Uj7Hf/O3lusOodFkXTpA69kmK3aGT?=
 =?us-ascii?Q?IEV1+eURecNexCrWrO4viOfBWiaMeWlLU2BjV2V91g1c3IbYKnqEOdR/zBLh?=
 =?us-ascii?Q?oiQ05e/4o/pms1s7m8DVefIcmWSaiY+WjmRXeM2UDbrcQDI4P+byAkITZJVp?=
 =?us-ascii?Q?NsT+jerCoSsY50QoLZfmuSm+KYxh6KZpTNBxgagh2yiTYILbMOewtz2bsfSq?=
 =?us-ascii?Q?T7Driap6kJ7OULh+03D8uHNtgs2veMFsY75y3CR8rkbpDBbzMcnCdKYcYBpT?=
 =?us-ascii?Q?DvkxiwOfT+JVhua1ATqIArU8zWC8OacrrUkvPDXgzzsVCC87qq3tR12gnyIx?=
 =?us-ascii?Q?UYla5tVyMxZhej4sJtQfIVlp6LbvlHT9s7j9iH01yItHmGKepPStxROHAlfP?=
 =?us-ascii?Q?c8FgSN4IguGNYFp+m1/wAwrofJBccSk3hO7dSTPh+dJdb3c4MSzTxr+rgTs+?=
 =?us-ascii?Q?fSX7ZEf2KE0QV8dU3H1OsPGIztTzc8YmZYtk40lm7vME1vIa2pWhYs3R4+Hr?=
 =?us-ascii?Q?5VxVOtu7F1seVhUzETxVUyTv20QYu23UuNgrZdve1Nji85ell6+XLaIHyihw?=
 =?us-ascii?Q?OM3ubt3YOWH3pwPLUXCFS/9A?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7d303b3-8e4c-48e8-7d4b-08d8d98390eb
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 11:50:37.2670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c6J0qQlop9lbByMkcBc1bviLB9XVX3Pqxb4yETxTWudJ1AApStgK5Rb9i7h60hiYTF0vQRzfoT4QbAaDEWlYwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2503
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split clocks settings from init callback into clks_config callback,
which could support platform level clocks management.

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

