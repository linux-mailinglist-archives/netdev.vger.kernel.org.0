Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2052AB21E
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 09:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbgKIIFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 03:05:30 -0500
Received: from mail-eopbgr680066.outbound.protection.outlook.com ([40.107.68.66]:15006
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727077AbgKIIF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 03:05:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VxRnT2Z6VeA7gKyrKIayDLna6nUZKHYfh7Nml15mr0vCHdIlCt+FVXNpJVLOEYInUJ7fmAgiczWJvQI7hm+qCFV7DbTiLmE+hbZn4r0G1nBHhnnSSufiEV3e+7Ev2CLB+ogPZKnLcMUR3MdnXsmXhw8qBsUe5Qo9UCQQ9KnbLumQwp5MKbWKriFRxnfszqE7MBdNaZZFFH6UEmGd6IW5AsldLxXuVpUHj2gri3Il1GMtUfdI4p7l5ehv2Ugv3HZ9K3t6R3/Ff6uD5bern2rHAUk2enSBpkPQ6bQL6YrNl8sVFNLU3KRsOHHAt9p8g/HekjugcfzAmIaEgkDSKNhaRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVzYQ7WyKGSlenh/Imy5VDY/ypXBBeSCNPH66uNYmXg=;
 b=DJhXIkckadqX+YGqP8j4HG/QrTNxrkiLQMLZWZoA3btbzvXR0eDCsam9luopym0NeGYtiZ/ixBsPhLa5j1BWZKjwAUMq9cn678keVg4LQRdHD8jBFa+KevcnRSV+Pu7wrKc6y/qvC/5zV4gEtGRaUomEpY1smcMxoXp64gOWLbSvSC7/+8NfBKemzYstSnVWDroCarVQRShdJqHGRaO15PbqoooKcn1B3m2Y1b9rnAyu5kzvplBEtcSLo+3dJ9yEODv2D/oi5eHyYb6j072lzIv8Pd7UiZvft8Bs2TzFcub+BZ5/SfT810q5xs2hnecD2jB7RVLLfmJaOU88qJ8n+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVzYQ7WyKGSlenh/Imy5VDY/ypXBBeSCNPH66uNYmXg=;
 b=ZgRxtAGE44Fi27QHyl0GvW/XGru1k9cqwbr0t5Vpif8gtjVoTW28XDCSqJgYSX7TDRoDDLYrcDaCPbZtgzYXedI1RnXR9fwF6BWNBeHTao3KRZriTojCT6Ira2yGg1wCjRz78Au6BNFFkql/S5Qvo/3k+eKJ3Ve+mfePMQ+BD8s=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=synaptics.com;
Received: from SN2PR03MB2383.namprd03.prod.outlook.com (2603:10b6:804:d::23)
 by SN6PR03MB3616.namprd03.prod.outlook.com (2603:10b6:805:4b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28; Mon, 9 Nov
 2020 08:05:27 +0000
Received: from SN2PR03MB2383.namprd03.prod.outlook.com
 ([fe80::49be:5ea3:8961:a22]) by SN2PR03MB2383.namprd03.prod.outlook.com
 ([fe80::49be:5ea3:8961:a22%6]) with mapi id 15.20.3541.024; Mon, 9 Nov 2020
 08:05:26 +0000
Date:   Mon, 9 Nov 2020 16:05:14 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: stmmac: dwc-qos: Change the
 dwc_eth_dwmac_data's .probe prototype
Message-ID: <20201109160440.3a736ee3@xhacker.debian>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BYAPR05CA0087.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::28) To SN2PR03MB2383.namprd03.prod.outlook.com
 (2603:10b6:804:d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BYAPR05CA0087.namprd05.prod.outlook.com (2603:10b6:a03:e0::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.10 via Frontend Transport; Mon, 9 Nov 2020 08:05:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2a3eeff-be34-455f-e74c-08d884863798
X-MS-TrafficTypeDiagnostic: SN6PR03MB3616:
X-Microsoft-Antispam-PRVS: <SN6PR03MB3616013726919494271CCA02EDEA0@SN6PR03MB3616.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7V8NvBFgJeVE3PQWyLHMDDbEXf0oswbmpCq+fC6LgUDtl/9VSsDJ71h/AFmOFND+N9Ft3tRmPt4CHlsRtAsLRJOimY4OPRuMg+SS652bs9MtN/X0evBcZZ+2f9gO2103aY8LmgAgkRPRvt99mQuSu7PIsoc5cXj8GgIzBYf8Oaq3uxrxdjVw1VCKHsqYfK9J847/wdhYVvZds4cuu70wmodwDatdKXdh003LKtrG9E7x8DTUi0nXN4LaEVUiItliIRs1QsJEDvgQSUnCyCcie0vnyu6ibMxvANunrK+n/FSy1mjRBfpWoWASjAnZUWP86DcaqM/iEzLIk9xsk36Q7JHldHw5gPz2OKP6LiXBilVURIlCnCr5GHXWTQI8TlUl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN2PR03MB2383.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39850400004)(346002)(136003)(376002)(66476007)(66946007)(9686003)(66556008)(2906002)(8936002)(8676002)(55016002)(478600001)(956004)(6666004)(7696005)(110136005)(83380400001)(5660300002)(4326008)(16526019)(6506007)(86362001)(186003)(1076003)(316002)(52116002)(26005)(7416002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: h3V3TCL0vQAz+iTikWE6U4Q3wOR8hwaJlcwyzxTIJQNihnLHfniYXZhjvQxYyliBFXsHpYO1xNRYgVAP15j8v3ZLXTgHi+xJeD4a8nt0jMq55oWsBknCXUB5UQQ3TEAElsVOGERLEeFfNvWKgwHWWMXUnBC1SUQF8dXjgOLfm8t3DTbVBLijIFktHSLFogE43up9roKiwrtzYPTYwz0kPj2347PcdEYs7DirF8bRzZTXf0Vryt8Kuw1u4Sc+a9pvym7bt59/yaURO2PWxNVzvOMXmj7xSidno30aFAO5fL+w6d42FK2UfUaaF0ukDpvo4yWPQ1Ny8+RTIKVVwNa+1bqYOOZaEHrwP+vwwPHSchj0a43y0Ne+yE0kfEvPbQWx11nJBHs2WeHgGKW0MxepH8AJu8pNYfAC/neQ5mnxqPaLP7n49jvWPcGdESAD1E+8kXAI4nzzZKFY31LGdG6M1+Gl6kG+YSeuCo+SfvvoAdtLdVx9wMORMzrFgMFAY7fbKV94BBURdUp1/7UH0HRv+AouZ3VKGxd5LeeacvFRwR5Lsb4eRcvIaJpxbO/S78HNv0sbHT51bJEH/Gsx+m+g1Q9DPCqfXwOO7hP36y/6wC5H+jlOBCe/D7XkNDtQv+yrDP+r/EODuhN3V5yq01tqNQ==
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2a3eeff-be34-455f-e74c-08d884863798
X-MS-Exchange-CrossTenant-AuthSource: SN2PR03MB2383.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 08:05:26.8275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: npxpU02FLEjidXha2j5SWeUYdhvelJPs6JnYNSgPO/OQnil8GB3B05XMwNubqC+TBgaJ1e0Nbo/S2uZ5pzuSlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR03MB3616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return pointer of dwc_eth_dwmac_data's .probe isn't used, and
"probe" usually return int, so change the prototype to follow standard
way. Secondly, it can simplify the tegra_eqos_probe() code.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 .../stmicro/stmmac/dwmac-dwc-qos-eth.c        | 46 ++++++++-----------
 1 file changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index 2342d497348e..27254b27d7ed 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -119,23 +119,23 @@ static int dwc_eth_dwmac_config_dt(struct platform_device *pdev,
 	return 0;
 }
 
-static void *dwc_qos_probe(struct platform_device *pdev,
-			   struct plat_stmmacenet_data *plat_dat,
-			   struct stmmac_resources *stmmac_res)
+static int dwc_qos_probe(struct platform_device *pdev,
+			 struct plat_stmmacenet_data *plat_dat,
+			 struct stmmac_resources *stmmac_res)
 {
 	int err;
 
 	plat_dat->stmmac_clk = devm_clk_get(&pdev->dev, "apb_pclk");
 	if (IS_ERR(plat_dat->stmmac_clk)) {
 		dev_err(&pdev->dev, "apb_pclk clock not found.\n");
-		return ERR_CAST(plat_dat->stmmac_clk);
+		return PTR_ERR(plat_dat->stmmac_clk);
 	}
 
 	err = clk_prepare_enable(plat_dat->stmmac_clk);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to enable apb_pclk clock: %d\n",
 			err);
-		return ERR_PTR(err);
+		return err;
 	}
 
 	plat_dat->pclk = devm_clk_get(&pdev->dev, "phy_ref_clk");
@@ -152,11 +152,11 @@ static void *dwc_qos_probe(struct platform_device *pdev,
 		goto disable;
 	}
 
-	return NULL;
+	return 0;
 
 disable:
 	clk_disable_unprepare(plat_dat->stmmac_clk);
-	return ERR_PTR(err);
+	return err;
 }
 
 static int dwc_qos_remove(struct platform_device *pdev)
@@ -267,19 +267,17 @@ static int tegra_eqos_init(struct platform_device *pdev, void *priv)
 	return 0;
 }
 
-static void *tegra_eqos_probe(struct platform_device *pdev,
-			      struct plat_stmmacenet_data *data,
-			      struct stmmac_resources *res)
+static int tegra_eqos_probe(struct platform_device *pdev,
+			    struct plat_stmmacenet_data *data,
+			    struct stmmac_resources *res)
 {
 	struct device *dev = &pdev->dev;
 	struct tegra_eqos *eqos;
 	int err;
 
 	eqos = devm_kzalloc(&pdev->dev, sizeof(*eqos), GFP_KERNEL);
-	if (!eqos) {
-		err = -ENOMEM;
-		goto error;
-	}
+	if (!eqos)
+		return -ENOMEM;
 
 	eqos->dev = &pdev->dev;
 	eqos->regs = res->addr;
@@ -368,9 +366,7 @@ static void *tegra_eqos_probe(struct platform_device *pdev,
 	if (err < 0)
 		goto reset;
 
-out:
-	return eqos;
-
+	return 0;
 reset:
 	reset_control_assert(eqos->rst);
 reset_phy:
@@ -384,8 +380,7 @@ static void *tegra_eqos_probe(struct platform_device *pdev,
 disable_master:
 	clk_disable_unprepare(eqos->clk_master);
 error:
-	eqos = ERR_PTR(err);
-	goto out;
+	return err;
 }
 
 static int tegra_eqos_remove(struct platform_device *pdev)
@@ -403,9 +398,9 @@ static int tegra_eqos_remove(struct platform_device *pdev)
 }
 
 struct dwc_eth_dwmac_data {
-	void *(*probe)(struct platform_device *pdev,
-		       struct plat_stmmacenet_data *data,
-		       struct stmmac_resources *res);
+	int (*probe)(struct platform_device *pdev,
+		     struct plat_stmmacenet_data *data,
+		     struct stmmac_resources *res);
 	int (*remove)(struct platform_device *pdev);
 };
 
@@ -424,7 +419,6 @@ static int dwc_eth_dwmac_probe(struct platform_device *pdev)
 	const struct dwc_eth_dwmac_data *data;
 	struct plat_stmmacenet_data *plat_dat;
 	struct stmmac_resources stmmac_res;
-	void *priv;
 	int ret;
 
 	data = device_get_match_data(&pdev->dev);
@@ -448,10 +442,8 @@ static int dwc_eth_dwmac_probe(struct platform_device *pdev)
 	if (IS_ERR(plat_dat))
 		return PTR_ERR(plat_dat);
 
-	priv = data->probe(pdev, plat_dat, &stmmac_res);
-	if (IS_ERR(priv)) {
-		ret = PTR_ERR(priv);
-
+	ret = data->probe(pdev, plat_dat, &stmmac_res);
+	if (ret < 0) {
 		if (ret != -EPROBE_DEFER)
 			dev_err(&pdev->dev, "failed to probe subdriver: %d\n",
 				ret);
-- 
2.29.2

