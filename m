Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FACC2AB230
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 09:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgKIIJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 03:09:25 -0500
Received: from mail-eopbgr680064.outbound.protection.outlook.com ([40.107.68.64]:2360
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726127AbgKIIJZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 03:09:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUK3XGvU24Z6erpJHKIwWoGMY3XuYuC/dv7A0laXiqQn11w+BjJpYbwN7zjgGM8ivYQ9dtnb5w57ESuKSH586rVxJRmVCYa8tpZnUv7uhf49BLUjTaY6ap/pkQMoAoqp17H/Rv611FwMilhVTL75fw5SDs8tuwyUkc/+eSAtrjGQKOGdzTyp144NCOzXIbmIu37EtA2Hwjt1M7hJRIx/A0rPKWuKK6Gkxc1jETOxj768QX48y37oky5P/NEJqfLUBJNENxzju8aW22HHtvHYPiKyZ0YC5fB+1JDiG2YdD9lliJcFVdMaZ/HweyFAGP8SjZykw4LFJoSaT0Uw3fE/KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NeA8XPqu6J6oj+l/n+V1tpX30ykZIQjdgF34coqDul0=;
 b=LugJr5yrZQAbqgcScvz4x8/tjqD+7MsoYnyTZxlFzgQUBciRCq85C5Bb/2u+Eh8Vi6joxpImqmMs5Z90MciRWJRX4DO/pqsSU0NziBydYdtthbRXotd/StUjxGy2cgFBFnXh9pDSRTJbwINVYXzMa8IWnwbPGuPPRq7pGstBFWjt0KMb0YmUWs/Zl8bZyyquu435Uz593tOqMEHv9GOVh5ef0nx9L9S8Ko/zyWoYBGmI6uXvy5knpX5POwkKC5Pdx+1fdFys3Ab0AaciGaLnu+6gnOY+wW+zSvQfwh6Zop1YxAwxGeWZhwTG0xoUjCH98lwUVicHmEw8cZG5zTnpeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NeA8XPqu6J6oj+l/n+V1tpX30ykZIQjdgF34coqDul0=;
 b=FSUFWXT5aXf2wsRHtjr84GvkxrddCHV44f5AZffq3Nlhks5wRbfbK7QIrO4irusdNFOvgi7zZ0aJMeIsIqH2vh/jKYGSl2eXe1tuwj7p/iPkveAfysIsC2cR5ycSK5dPgfzgBmaUBYBVOsExQdH6XND4F/yR+yK8RgtKxvp7cy4=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=synaptics.com;
Received: from SN2PR03MB2383.namprd03.prod.outlook.com (2603:10b6:804:d::23)
 by SN6PR03MB3616.namprd03.prod.outlook.com (2603:10b6:805:4b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28; Mon, 9 Nov
 2020 08:09:22 +0000
Received: from SN2PR03MB2383.namprd03.prod.outlook.com
 ([fe80::49be:5ea3:8961:a22]) by SN2PR03MB2383.namprd03.prod.outlook.com
 ([fe80::49be:5ea3:8961:a22%6]) with mapi id 15.20.3541.024; Mon, 9 Nov 2020
 08:09:22 +0000
Date:   Mon, 9 Nov 2020 16:09:10 +0800
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
Subject: [PATCH net-next] net: stmmac: platform: use optional clk/reset get
 APIs
Message-ID: <20201109160855.24e911b6@xhacker.debian>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: SJ0PR03CA0205.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::30) To SN2PR03MB2383.namprd03.prod.outlook.com
 (2603:10b6:804:d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by SJ0PR03CA0205.namprd03.prod.outlook.com (2603:10b6:a03:2ef::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Mon, 9 Nov 2020 08:09:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f2649b3-46b5-4efd-e0e9-08d88486c433
X-MS-TrafficTypeDiagnostic: SN6PR03MB3616:
X-Microsoft-Antispam-PRVS: <SN6PR03MB36160419F4E9D81E8E6192C7EDEA0@SN6PR03MB3616.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:245;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8nSzezWrOi4E6FLd9HqxRGPnuITdgR7oEBPYtF/Mt31kc5GH793kPuAbMxhkAyh0YfAb6Uepbm4yziGvWo59eUFQFommD7t8g3fESLukFhC98U/gCEqdwCOSfcl7cRpAJ8FxO7QeX6bxgLh6vGCuGU1t28h4Fo0+jiDnoF8AYeajoBe6+qB2/Rpgp4Vq4cdnX2+2/bBq3VoB6T2hbDGawFMOjB8/aUd5mBr5NxCy6iAjK2VdDNaje45afQizkSZuKaD1V/hRiHLgooU8qYJhq79Boh3QZXlOY1wM3gMcqL2GP4OXvhtnX/ELVxIpQaxJ/vTUy1yq7QhATIJvhC/1dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN2PR03MB2383.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39850400004)(346002)(136003)(376002)(66476007)(66946007)(9686003)(66556008)(2906002)(8936002)(8676002)(55016002)(478600001)(956004)(6666004)(7696005)(110136005)(83380400001)(5660300002)(4326008)(16526019)(6506007)(86362001)(186003)(1076003)(316002)(52116002)(26005)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rz5PzpdyP0VkTtzH7CYPaGqgnPYxq9dVkEwpwv49vA94wMAjxZ5f9lCAyQpLAEvgi/WwwpFkMqrekpsXNRF5EoRVqOB9G66hrYQK+Xt5l70y7i6crz0rJ/Cf+cee/R+WMKwR+xZjUEoKzQoWW2A3MPONpKcqQ5HT+1Su48Uzw+sS2lwoNi9X1P27OVjuBiothHmY6ybDJVrqUopV4echs/d5Hl9N2IfXp72etWBATRGoaSzfblaBCiPYg/VcISam7KXiQbiuCdvVccglaqaNhfnmf93lZEaZRr6PkM+6cZDDLa1yW2fkjxxLTcVo1JUToH4fSSy7rU87X1nNT7MfmdvxsSZewt5lt04vsVEiXZyl94fsdtR9kxKRMqVGxPy/rXVIfIewbQEO/t9S726oxoOW10+zfAys0plIqQTGnpwrxOeMqEKCN4X2aYcS9QeurDy+C/ZRKsVzYtK7/r8J7qtxQZtZhdjUfYQxGNZL5HhyVoOgPbRZ+EWCYwspycbf6LrWyrNOuDxjtiMPOsJC5DqPe4HkKnbQAIw+Uo4Lh7or6/afp1SlURCwuHA/GxQ4QSB4dw2P9nBJlhDXwkW5QHDIfArlaDnOHNjUSgqRkd/Ht2fu/KdEKTZc3IUDgkNZ77M4Bj1J6WBkpJhHwz0Q8g==
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f2649b3-46b5-4efd-e0e9-08d88486c433
X-MS-Exchange-CrossTenant-AuthSource: SN2PR03MB2383.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 08:09:22.6492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MO0zKEU3Ecpl/excJUd76AnEii0mBesNlglI/JP8hIQ9++gvRkw6WMWx6WmeWDEqXPMa1sGf3U/YpPkjv2fPrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR03MB3616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the devm_reset_control_get_optional() and devm_clk_get_optional()
rather than open coding them.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 21 +++++++------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index af34a4cadbb0..f1d5b2ce1039 100644
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
 
@@ -596,14 +595,10 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 		dev_dbg(&pdev->dev, "PTP rate %d\n", plat->clk_ptp_rate);
 	}
 
-	plat->stmmac_rst = devm_reset_control_get(&pdev->dev,
-						  STMMAC_RESOURCE_NAME);
+	plat->stmmac_rst = devm_reset_control_get_optional(&pdev->dev, STMMAC_RESOURCE_NAME);
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
@@ -613,7 +608,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 error_pclk_get:
 	clk_disable_unprepare(plat->stmmac_clk);
 
-	return ERR_PTR(-EPROBE_DEFER);
+	return ret;
 }
 
 /**
-- 
2.29.2

