Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFB32B13B1
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 02:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgKMBJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 20:09:49 -0500
Received: from mail-mw2nam10on2048.outbound.protection.outlook.com ([40.107.94.48]:38093
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725965AbgKMBJt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 20:09:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5KPWi50jg1zOQyYxFHUtjPWP4xhfeLJ/dK8QR8g6+NXGKEehWuHBuKDVilgTdmFAdeAYBgtelRge86AVYWlLGAMh/LilcZzPFZcZibB/kmmgT7YAaT0lpSBkFXjv9W52z+zs9G2FuxmGNJBBwkSN5XZe2gFU3TSbzo21no8mRAJ+fXG+5RIg5NKXD6llmopKYkO8+lU1wDfGOANrb18f+1DNAj4cEQp6SmkcfuIk2wlEhgJsrCO/Tf5+DaDUAq9XtO7Oz5itf8Fc4iKMUtpqw2ZybfiLE6EwNss/mKx47yqf0AizkbRBdMZcwgus3LVkz4jD9sfujAScwWvV6WlQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhESFavzaKU15ChczYkGQ1rzdorjERuiwDgQb9ApXAI=;
 b=jidGbrUbyDBa4iDdw+1hchhBXeGBqc3H55VwEixptkYq9rF3fblqgsLFUZZIG1VYGVZURlK9a6CUJ5c3rM/nQohb4Z0bIFpQCNcci2+RFt2Zj1BvtVoEAheh+eurR0N8oqtLGNHoE2uhU0xB//MCs63uoXf7MATsqz83ewZ7Lj15QeI+jDSC0ZWePgTRz21KbytIqVum/D+nOF6QTD7kqgYiudxD080+eOkJTpsNpDnLpBTvIzf6/bqs3O76yP5pciKF5mVeOo2h3zy0V7d70bAmpv0ChXVWik7QBSYnRvKsdv8zmBD0sMdirRlk6Q67AwaABC9fzhicA7U0iq5TWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhESFavzaKU15ChczYkGQ1rzdorjERuiwDgQb9ApXAI=;
 b=Xw8pnGz1N8UkCdRoeoxzj7vqholbW8CVXiVlcxT41wW7zFuobzpqSC4wmbprj8Hr7NVba5l83HcTUn38MeJtH1zPt+b7xm4gNVDLzGvGJDqrOOTwYMZJUDRjEL0yHBawxR73TsSIXdkrRn1ZsjBmf+cXbnpskNGjKoowaKNJG6g=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=synaptics.com;
Received: from SN2PR03MB2383.namprd03.prod.outlook.com (2603:10b6:804:d::23)
 by SN6PR03MB4543.namprd03.prod.outlook.com (2603:10b6:805:fb::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Fri, 13 Nov
 2020 01:09:46 +0000
Received: from SN2PR03MB2383.namprd03.prod.outlook.com
 ([fe80::49be:5ea3:8961:a22]) by SN2PR03MB2383.namprd03.prod.outlook.com
 ([fe80::49be:5ea3:8961:a22%6]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 01:09:46 +0000
Date:   Fri, 13 Nov 2020 09:09:02 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: stmmac: dwmac_lib: enlarge dma reset timeout
Message-ID: <20201113090902.5c7aab1a@xhacker.debian>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: PH0PR07CA0005.namprd07.prod.outlook.com
 (2603:10b6:510:5::10) To SN2PR03MB2383.namprd03.prod.outlook.com
 (2603:10b6:804:d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by PH0PR07CA0005.namprd07.prod.outlook.com (2603:10b6:510:5::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 13 Nov 2020 01:09:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9da37048-c95b-4e8f-0c35-08d88770cf53
X-MS-TrafficTypeDiagnostic: SN6PR03MB4543:
X-Microsoft-Antispam-PRVS: <SN6PR03MB4543742F46D00126BFE0907FEDE60@SN6PR03MB4543.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3nT+4mK5XG+8ahAA2wUs6AQO3PUsfX23/+X8CLNhxGlWT4rg1cxVIaijIg7YNDb1/+03PJc7e/mU4KpTFqPPPNcYG3vaQEkrTIpHhY4ki6IwxNVldA9MrbDeYc2GyViQMiJjMf1F/yj8/OAUrvNlJRXNGLxMnC2aKRSyZEUPhm2pMeb6R0OqWnQkGKCERAmmLgj5tYMEI7HpxcXoarxTsIvHmRrahU+KmNpRQBEoQMT4iBxNy/yOep81yJN1ZPnw/veGfoYHNR9MTvAqgZ2BeDE8lViy3kGm9T3fLHSfwEagKgU0q6hu+oa6qEVh4QZjLSZlyJkxXeOaF+PYexfl3VgKqzL08zomlGNInUhTK5QBpWxwfWU4JQgqKTj/aG4twJyMpVwGyXk9m0wDb8p/IQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN2PR03MB2383.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(366004)(136003)(346002)(52116002)(186003)(16526019)(6506007)(4744005)(83380400001)(55016002)(5660300002)(956004)(8936002)(110136005)(7416002)(8676002)(7696005)(6666004)(26005)(316002)(478600001)(66946007)(66556008)(86362001)(2906002)(9686003)(4326008)(1076003)(66476007)(161623001)(147533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YTJ3lkjuZW08rGdiYy892fksMHq9kJX4ZF2DQzxaGPlOe1InyOZrCGabLsFE98SBQHzqkPjpTWWHtiZts6LxqIZrL/VdleVO5tPp2M2Ci+p7V2au1pXZVu5NNgqKApsDv0o/IfpleoUEXaeJLhZWjMUV7HajlnLhlUmD96W6rC2sBvdN/WFn7zYZJdsErzl8AYYBBHMR0nDbThAEoNuKMNtrQa/ZcIlRmroqnXxF7cS2YT6VEBUFwKtlepmmhjEmSjFMxA9ywhmNKvJlImNCLITo9/ygBsoPvq+drKiwJfnWNfXxbdI+SMrueyuRRxlxCfNiwky9T9wAJzWNcJNQswVICWNbXlFmmDJ+FJwjTTErJMN1EgpGqQBg5Bk1UJpAIsSzQnX07rn1vSSY62hVuBgc26e5hNCcyqWz8wKcAV19eOCu8gyL0e8YTYRG+5vpFrHfY3yQLkFmGbl9OsxwyCet8r7kkJx8U2j9XWBjXo06UnZFHgEy2LTOV+NLss2kTHc1ihRmhn40OtYpIDmmBF4yQ8qV2wUl/TViFUFFiLxz/LvzFfdFRSBOz011AAdDVjE+vJDSQoE4KhCT2755lpYDwb2VGo4alEWKia/BuijTKPWxogJe1PIHcCxXmmr5iqYvTl+Y/tmXbLBJBTagOA==
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da37048-c95b-4e8f-0c35-08d88770cf53
X-MS-Exchange-CrossTenant-AuthSource: SN2PR03MB2383.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2020 01:09:45.9237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wX2nCq8xSClDDi0pNY5wxvlnLunWJiRxFkJLM/pePIPpQj848355dYSxqumXMBmd7oisFq4MK6RiAKffVkv12g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR03MB4543
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the phy enables power saving technology, the dwmac's software reset
needs more time to complete, enlarge dma reset timeout to 200000us.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
index cb87d31a99df..57a53a600aa5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
@@ -23,7 +23,7 @@ int dwmac_dma_reset(void __iomem *ioaddr)
 
 	return readl_poll_timeout(ioaddr + DMA_BUS_MODE, value,
 				 !(value & DMA_BUS_MODE_SFT_RESET),
-				 10000, 100000);
+				 10000, 200000);
 }
 
 /* CSR1 enables the transmit DMA to check for new descriptor */
-- 
2.29.2

