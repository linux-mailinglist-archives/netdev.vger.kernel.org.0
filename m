Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89DB72AFCE9
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgKLBdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:33:17 -0500
Received: from mail-mw2nam10on2052.outbound.protection.outlook.com ([40.107.94.52]:50656
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728253AbgKLB14 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 20:27:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=br1MW68h4MKNqvwsq90TCrvq+uUe+MWJb8pBEcSPNzW48Ji8AKO0+3f0qS8ypm6vbicbzq4gDAjFZzwrxCnL5Wjxv3VLYB9/6N9ZJBVIVOC1/wuADI0wGDEfLduHPitc0RmaqNOLEtpUI6SSM3S041Yk23Ji7/mTJ7tF+KnC+FO362XQ2vnUmL7R4+pF9xmvQp2ZMoJkiCNICxYIQ5hG49snhoSgoUIszKVYKYnHKsbGZE8P2lnYNK1XBWu17DTCJgNvdiByPgG0dO5LtKUIXDTYwkoP8YsOOlmfGl+3pQ3AZXyuul64Co9BAnXIpu8sCb5hWAslojl50Q9Uza6xSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6MtVlYWl5Y+NGiGapJva11AJxWpQWcFTMW0UnEKToI=;
 b=mlgK8JeqfndWIsUuon0gxQzTk/VQFPpvQJ1hjDipBdYlM2eIWjmoI52vA2Wx5yjHG0sMnrw5uT96Iilp6MVSP7zF2pd7xbpmywfmQeJI2/ldg6FVQUBbLXIjN/S4sCKAfgkt9grfvau1V/B66zAevFYwfOD0cb5/Ox1dFw7oLUAVigxLFgnXbY7Qm1Ruk42N644GcTSpkNgr6tFgdgZhmllbv49CBAL/cShvLmoLxurRKJvdbx+NupYzlx1oWdcIkKAaHzx0GMD129LUrA1+wzpWbaO0N8rBHi5MdfN1eSstOGUHYGkb2EMzHkD99YLJZ5S+1MxjxcPpRSaSfE0y4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6MtVlYWl5Y+NGiGapJva11AJxWpQWcFTMW0UnEKToI=;
 b=fhjI7souQPZK3spH2/NpVYfVB2HlBuv1jbfWM4aEv83vI6GntB4ptZW2VTvoxAKMShcuR65si3uHt3FQ3liMJftzZRcKfPVL3p5XmLDrqmMGDPLdNEB4ayNUtxU7ugIfRhHPORnMJr4FrU5AWC6WwD0ZU42ZwaTbk0MkTPm7FY8=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=synaptics.com;
Received: from SN2PR03MB2383.namprd03.prod.outlook.com (2603:10b6:804:d::23)
 by SN2PR03MB2240.namprd03.prod.outlook.com (2603:10b6:804:b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.22; Thu, 12 Nov
 2020 01:27:53 +0000
Received: from SN2PR03MB2383.namprd03.prod.outlook.com
 ([fe80::49be:5ea3:8961:a22]) by SN2PR03MB2383.namprd03.prod.outlook.com
 ([fe80::49be:5ea3:8961:a22%6]) with mapi id 15.20.3541.025; Thu, 12 Nov 2020
 01:27:53 +0000
Date:   Thu, 12 Nov 2020 09:27:37 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next] net: stmmac: platform: use optional clk/reset
 get APIs
Message-ID: <20201112092606.5173aa6f@xhacker.debian>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BYAPR01CA0006.prod.exchangelabs.com (2603:10b6:a02:80::19)
 To SN2PR03MB2383.namprd03.prod.outlook.com (2603:10b6:804:d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BYAPR01CA0006.prod.exchangelabs.com (2603:10b6:a02:80::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 12 Nov 2020 01:27:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65191673-06ba-46c3-2c32-08d886aa2cdb
X-MS-TrafficTypeDiagnostic: SN2PR03MB2240:
X-Microsoft-Antispam-PRVS: <SN2PR03MB22401E87C877901CC2DBA77BEDE70@SN2PR03MB2240.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:288;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sMzDtCuM2eMgH7QLQWxaalzxX6w23yrjg8jjFlM7dHy3Evoto5FTgO6bNuxU9tqQVPZWlQZd2+yFjWMS01CJ7JLs836uENaGlAH8XfeovB4q3Uywq9tIGg+m0vasOm+SfwA2yDtUpd5UmZnIRQQyO7b8Pr7QzUuo5xWxl1l7nZ7gIQ1XSnssepVSYuufaQh8/j95c0lAVQZj4/OySw3ZqkLaH+osz6NtNs3fkepsBXsCLAqbDmHmKk+KKAalVcwhFnFqmwj057N9WY67TvT1uYm+ZXmi5+rGGCcU1kJ5ZRTVHmNxTXkviVuUAttVeLAEDfIV3s/Sovstq7qd6PFECQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN2PR03MB2383.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(83380400001)(8936002)(7696005)(26005)(186003)(86362001)(66946007)(66476007)(66556008)(55016002)(1076003)(956004)(5660300002)(8676002)(2906002)(4326008)(9686003)(7416002)(16526019)(52116002)(6506007)(6666004)(478600001)(110136005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tIHJBZVs5tX1bsC3eetj2f7VtRR7ia5iW2+SqbckTlPOOSMKGEQDghj5NnwWaTEGo+zCuzviSVc4YgmoJVCu0ClvtccQ79RsXT2fFGk5HvYTO8C5WseA3E5uyyXXmLfTVKc5k7e4U9r5mpxHX4Vk3x9s0ClaqAjVVdcgoY2vwIWuKvCYsJHvMLsAKfDXWYkcZsCcsYay5ktz2uVQrsJUfb5Amb1nRpihsEd8M2Sfkq2jhDolRQRavKjICZaxN7DmN1MmWFi8HcMAhdoowP+1FxW2x5kvPcQHBAWdxBBvExesQ0X4M4MR88eVnWd5bKkLR2o1QB8QhMdWehI8T/NaZtZN4b3IAbYp/vAgLxz0uW9p+d3QyM9T+nfcgJqBvYatM26puQ3lufgNsjYxkM+c3WRGO2KcqnlrPiSbGwnTDzd0X3m3FEDnzx9zNzE7B5RKMAHHvYc4tPePU+qf/tnApktvJ32HfwbYEbuhiCR+Ocmb5aclamNsOouF5dqyTo/D5l9D4kIn0FkCGBoyWAKNLECSVw40CFLm/U29lBW8Og6MmN9zY1MIQ9FSjUr51s8s86wDAo1WRvhWndQBiZL4vdnQdOdEgIN7aDUG5D6EsALjENeutO2DHAy+dUQiXg1iTNhssOaCvishBoyy6lLdDA==
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65191673-06ba-46c3-2c32-08d886aa2cdb
X-MS-Exchange-CrossTenant-AuthSource: SN2PR03MB2383.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2020 01:27:52.9627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XbLgTa/bFhwMDKJmkpnkf+jjx5v+Kl1TVwQiG4CnWiwubegyTTGuUb+zUetWMEe3Aim+S3XJDono//y2guh3yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR03MB2240
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the devm_reset_control_get_optional() and devm_clk_get_optional()
rather than open coding them.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
Since v1:
 - keep wrapped as suggested by Jakub

 .../ethernet/stmicro/stmmac/stmmac_platform.c | 22 ++++++++-----------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index af34a4cadbb0..6dc9f10414e4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -399,6 +399,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	struct device_node *np = pdev->dev.of_node;
 	struct plat_stmmacenet_data *plat;
 	struct stmmac_dma_cfg *dma_cfg;
+	void *ret;
 	int rc;
 
 	plat = devm_kzalloc(&pdev->dev, sizeof(*plat), GFP_KERNEL);
@@ -576,12 +577,10 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 		clk_prepare_enable(plat->stmmac_clk);
 	}
 
-	plat->pclk = devm_clk_get(&pdev->dev, "pclk");
+	plat->pclk = devm_clk_get_optional(&pdev->dev, "pclk");
 	if (IS_ERR(plat->pclk)) {
-		if (PTR_ERR(plat->pclk) == -EPROBE_DEFER)
-			goto error_pclk_get;
-
-		plat->pclk = NULL;
+		ret = plat->pclk;
+		goto error_pclk_get;
 	}
 	clk_prepare_enable(plat->pclk);
 
@@ -596,14 +595,11 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 		dev_dbg(&pdev->dev, "PTP rate %d\n", plat->clk_ptp_rate);
 	}
 
-	plat->stmmac_rst = devm_reset_control_get(&pdev->dev,
-						  STMMAC_RESOURCE_NAME);
+	plat->stmmac_rst = devm_reset_control_get_optional(&pdev->dev,
+							   STMMAC_RESOURCE_NAME);
 	if (IS_ERR(plat->stmmac_rst)) {
-		if (PTR_ERR(plat->stmmac_rst) == -EPROBE_DEFER)
-			goto error_hw_init;
-
-		dev_info(&pdev->dev, "no reset control found\n");
-		plat->stmmac_rst = NULL;
+		ret = plat->stmmac_rst;
+		goto error_hw_init;
 	}
 
 	return plat;
@@ -613,7 +609,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 error_pclk_get:
 	clk_disable_unprepare(plat->stmmac_clk);
 
-	return ERR_PTR(-EPROBE_DEFER);
+	return ret;
 }
 
 /**
-- 
2.29.2

