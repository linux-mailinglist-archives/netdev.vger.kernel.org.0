Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6E7327C10
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234384AbhCAK1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:27:20 -0500
Received: from mail-am6eur05on2077.outbound.protection.outlook.com ([40.107.22.77]:2529
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233707AbhCAK0r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 05:26:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lGw9lH4w6dk/c/Y05eBgiuPff5VvqXkwD5BnZwL/GwO8HGveNcOYdnKbwQ9YS5yRLJepM6IHkidS/MqPuAb5YSwfEfvMHaMmcPnZzV9klEjPwoEG2l5mCRYvUntJBJI2t6/iSKY+CwPpyicMC0CBcAQoYrhb8rFPE20dGWZ+0NfHkg3NXeFTIoHoKsH7HOgUeAg2B5AOojVj2anaf+jDM0nXqvzcHUl0pHsT4FsrkeqqCEmknc9RS2y3ovrjMVvzeY8aufV9MlfK7T/UQexY9hJNRQ5bq7nLzZoZc/sARjU02j3Jj3fZfn1qx2o4ToVZzmwpbyVBHtjQZ0UgODMxOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwlpXMc9HeU0HUozihgQ9MCQZSvHXQlYtz+rjy0O8LU=;
 b=X0nctaX+wnYA8k3c9ObJA2HuT+t0C+jaaf6jbDloAFIyw1F5cNKz6iFI2qMj3bVghI7fk/LEC0EDmkkOKXCZID/42/aPffmtWaJCm8+FFR2loBOL5fYyA2Fp2ukuIewejKozMv0/bnjCmOe9owytTCLbZ1YkSulHqyM3ywGv7+rZHgPTfwz3q55sG7mnItS0OGc0e9CEG2am2GWba3XV+MYqr30sSM0lL/lFadaUjcDOMWhIxOaFlpDhm48GtAmz/bN98X6DCe296vuHBzBzMFhgwNfByWcEP0gMJxrn1mebAh1XLVlNY5yUcpxxjooR5oqiIxM32bQZdBqwdyUrBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwlpXMc9HeU0HUozihgQ9MCQZSvHXQlYtz+rjy0O8LU=;
 b=jrEMYMldh1O+xLPXWPBbm72Tza3tLPBgHhJFMnjrQ+H303+/oW6DDeheYRVhhgOgXRY9T48SCdpwa/L7ttdV3pZC25QGMLItC/C2ot4PsrF1oPt8jd+EHiuVIzUKXfsPEyjG1m4yRbS0Oc94E5+lGZepM5PGxk+/eTogC5Byvzw=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4953.eurprd04.prod.outlook.com (2603:10a6:10:13::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Mon, 1 Mar
 2021 10:25:23 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 10:25:23 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [RFC V2 resend net-next 3/3] net: stmmac: dwmac-imx: add platform level clocks management for i.MX
Date:   Mon,  1 Mar 2021 18:25:29 +0800
Message-Id: <20210301102529.18573-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210301102529.18573-1-qiangqing.zhang@nxp.com>
References: <20210301102529.18573-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR04CA0045.apcprd04.prod.outlook.com
 (2603:1096:202:14::13) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR04CA0045.apcprd04.prod.outlook.com (2603:1096:202:14::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Mon, 1 Mar 2021 10:25:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 74665ae6-c36e-4d12-c4e5-08d8dc9c529d
X-MS-TrafficTypeDiagnostic: DB7PR04MB4953:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4953863189657FE091410905E69A9@DB7PR04MB4953.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:632;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qXFFKJtpQxRtfPQKyNllPwlpeX/uPjSTyqqTBXtmYl8kTEL6ZJHsuVWxviQrRu3KlaAZ9PSSgUjZX93U67lYI+gp9iujaF5jhG6RS4H731SOIKJcMvSCcZloW9DdmavWcfk+TzogReCwdbE4JiKdTmxSUmqd6npjPFqyb3kQqeKdxRZsqMFeiW85MpNjcgzRd3IT76jRU0fwYVRwuTXnAfXL3zaTdyQ5Pcdj/kzRxjlyDTgqYOvn32TJhxHSRxwiwZSdLQzun6uVwuvdufepP8UxxWnHg50VuaSzt63oJKC/9811h8/xAfKZTMJgH7CTFUiu0VBSdS5JVcvE5Dulf0YeiZWHuS8WIPVouE9JnSks5K/nZgypo+d/3wHNGINKPW4AsRVPeBWVc/rlMXwr+MM7Uno4YSAxH99ghdi48O7i0xo6SdHHq5jTAEMv5wIPCT/JCQyd5AIyGyyt70wuII+yQBP1r/V6MIQrR1P4pi3CXPQzKVOSr329AXGKkMyPGlL1RZti2rQkBfoLrSF6B0G08fT3JrqEHAOZM59R23UsQEGG+Ga93A2Lm8E9JmDBy6X0G+Z1ycxTqbby95aazA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(5660300002)(6512007)(2906002)(1076003)(86362001)(52116002)(6506007)(36756003)(478600001)(6486002)(26005)(69590400012)(186003)(66476007)(8676002)(316002)(16526019)(4326008)(2616005)(956004)(83380400001)(8936002)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?51bHvEaMYatVrPR3o0frJ2nQQmULmBABBmzmyJ7lMYC64ujm1PrEJG7NEIaE?=
 =?us-ascii?Q?bBgfkpzcTv/+x42do1WhJt2rYzBskPJ6uKHfPwg9k1pdz12g4ApBA80qIg+c?=
 =?us-ascii?Q?EsHXI0H3ZlVKE3zEHG81Pg+45n/pnmGh9sIcGTqxpogLxf2r1XMqd8TbS3w1?=
 =?us-ascii?Q?+jWSnDbmxlUEKBddRf4LNeGX65oqfcRJIB6q/8YuDN667exbqQUakcTOCENX?=
 =?us-ascii?Q?HozNJGo8j2sboCbucXB0uldQC/WzWKNI6SgGENO6310OhE7/Nvsd0UOCG9sQ?=
 =?us-ascii?Q?1Q2sIYqMBBUq1D7vCmH7x8IF1XnofNGQdNtaRzKPl/5XzjvXTBNZCYU8TTFP?=
 =?us-ascii?Q?evh2ztBQ77FlX2uxnNVq0zhhtJa1w09VVLTqkBr/EgLO3YcEB6YThqIghDk1?=
 =?us-ascii?Q?elFbueJ5DLozzm8lIcUpmKylmwOS3pL+HyD5gfK0W1ZdUmekTFHjbNfHgCWv?=
 =?us-ascii?Q?kEULYgudpzAS8DXVMLwtqan506XpUoHb2VD77a25YV6q+sVtGkYwstCTJFXf?=
 =?us-ascii?Q?zv4h+myccv2T4NfLG4OVBaBiy1sigCyBexHTy/rvExjz7/d2VhA56+IiFecW?=
 =?us-ascii?Q?zvrIPbY6w7FAjaKKEo5kk8o3HVLIgkTUGKrDxOlGSxiJEKst9dSnS66aAqEO?=
 =?us-ascii?Q?lSj3MWGfbDJwgYz6WPdYqxwWLcz8ODWXhr67lPqRUf+Kr2a6hQVP1USe4wsn?=
 =?us-ascii?Q?BssunbB2teS16kBUndP/4fVWQ1bzzCI/aDvNggEHmCb+N4EjDvUwIzh6sBfW?=
 =?us-ascii?Q?eHxD6npLOvJJoBCBbGu4PBrj71HvoaGqYLLzolADWVJAnmTqqoU8la7mKLEE?=
 =?us-ascii?Q?tPAgJ3zLhamIwESVvj8R0EVWpKgZiUaJGmeNEWa9btL4b2xaHQaLEjQoUlRA?=
 =?us-ascii?Q?xhYoHVTEwzRmA8UIES7EnlT3YVkCoeZ6U5TEQsYOUwVJTfrpAh5+GOhzPbMY?=
 =?us-ascii?Q?6VEkrxzsJRcwAvhNQq7Nfpj+LGZdhYvYSVV+re4poj5mBqekNsZh99Q8UEZS?=
 =?us-ascii?Q?cod+Lyfi/M+4Cs9iJgKWWY/BkGIPQ1vkW50Nje3z2ZlW/Qe88hHvs2qhJFOr?=
 =?us-ascii?Q?yMvG3b4o0PCgLeaBWWg8+F7TvQyO1w1sYQJTY5+k02lc8RYRq1yYbTPwBpAB?=
 =?us-ascii?Q?wl/u85r4t3WSpd7IHbxd6f5VYFvofFYphzoyWacNXNgaOUURAt/4+Toekm4F?=
 =?us-ascii?Q?6n5NJEwM4gKCiyWtUpziJ2RAbmjftw+sKdjLFvgIOYJhFAgSmxJtJJuOwdKM?=
 =?us-ascii?Q?MVoAyTFX21Bz6y0CURfz5LnkLtkWBomNr1lBuz517QU+J05aAb82xUR6epfC?=
 =?us-ascii?Q?xn4XPoL5STk3c2HgkJHRj6VN?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74665ae6-c36e-4d12-c4e5-08d8dc9c529d
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2021 10:25:23.3498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z6NofUVgeAFB40HExdmiAAxHLqia8gtBcLpR8sAPnehAjax4bdpogWpVrGA3y8UvZKTbl/OfE3T3h7ymEE4VNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4953
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

