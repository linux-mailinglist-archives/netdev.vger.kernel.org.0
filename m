Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF361E08CA
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 10:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731372AbgEYI1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 04:27:12 -0400
Received: from mail-eopbgr10052.outbound.protection.outlook.com ([40.107.1.52]:45540
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726222AbgEYI1M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 04:27:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCdxTxf0bq3GX/MJlsmxDAv2C8wpNZEK4lopVDC9nZjj6mM580h8mz3AO7md0jJc1Ka7oboXYW96a/1OKbvxOEOH56tCyoosYOqM9Sd5jaxv9cu5izk36XDOf6Naq4ONZDIWeVivDy7ijdfFWBoEtbLVUIu2Zc6ytRawDDaWmliItlcYFXpsB0y/rp7OVEmr2Wx0LwleqRVQK1sk+GrSSJko8o2rXYAyEoYHrJ6Ck2oX2DHtR3B0EJ1/X07Qis4a0Js3GBe40bbcErPbNsHB1RJInSceJNdNTDscZPAnryZ4ekLEYaIzHl8F8JmSnbcQ/UbKH1boghg9GUoEd+YFdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFdjN/JXXqvv0lsNW3a8zBy04sdNGohdrwgi4teeuJ0=;
 b=MbVA5n+8GGUpC01tKfcrSYpdhOdxTXqtC4hP+r5uWKuTjdmhrbjpRr6W44VK8/ohHWyZGseFu3qoWWDrWlFVzrzgtnTGr/j9m636VphAbKeflJdN0fwz3nvg7ecjvhHmuZMMEGr6F8OCRfCMZ7CTr3iWjHT61+QM24RM2M7aydKqa/UtPhH26CBCxTWUan2YV1qoXp7FZxtdww1ugVeDoTshWccgMK9sRrs5H4Y+m/NVWpYQjhIXj/k2gIetXLORa6LJ+m5oBzGEOkXFb2hMBWbfHsGIDlkNa+K6/6ASau/6tiVJImBV7ONlxCrbhpOIzVQfDulMKHu1A9kErjsV7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFdjN/JXXqvv0lsNW3a8zBy04sdNGohdrwgi4teeuJ0=;
 b=mR+uToXK4gpxWrVZ71yVaFOyCgMW6at5HYVhwfEp9VoceRhKVMmWl/7YqE1SwhxuukvpOz7/hN0gcQ3/1/yl9VfSpWpB+gST3+D/etLqAADPSsZO8A3K27Zqt9/xV7rLlXXDeIhuCJQNhWl3XUbrDtyuNq0gp9SifjK8ZGptmNY=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3717.eurprd04.prod.outlook.com
 (2603:10a6:209:25::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Mon, 25 May
 2020 08:27:09 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 08:27:09 +0000
From:   Fugang Duan <fugang.duan@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, fugang.duan@nxp.com
Subject: [PATCH] stmmac: platform: add "snps,dwmac-5.10a" IP compatible string
Date:   Mon, 25 May 2020 16:22:25 +0800
Message-Id: <1590394945-5571-1-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0096.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::22) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR01CA0096.apcprd01.prod.exchangelabs.com (2603:1096:3:15::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 08:27:06 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 34283803-76ee-42ad-3e7a-08d800856aa1
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB37177D3521AD465EA3023A68FFB30@AM6PR0402MB3717.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7tmdLx/mWiT7T0KjQs/7m4PYoIPVMX7yWHwTXQiA1gQw3K3cNqRdJSs4yeVOlG82M/n/4KnZcsKpBmMhky/VqIP+/udAiuoZq0uzwgndaITKo6v6w7ywFhJUb6tO3dAKFv332Jbv3SsYTLj4je0VTRYRYBGUD0yC+zmd21mhkH5k8n+8wHWnjdlK5GLGiy1a33XyhG3KtG52oSyc8mMcwkuROYcS7gi/iHAMLcm0NsZAvF/hCgKMTG/r1qNVki+/0QCA6QOvImHxNcetjNUZ3As4KuHO3WBDeuH4YZ0sy5pB9H3u9WjQZX/cIOP8K1XbrY+8nj8FteB1T99oNNDfx6bLUdwyY6pcMD61PtBFKvUVE4rb13t46cA7X9IqiYDF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(2616005)(44832011)(956004)(66946007)(66556008)(66476007)(36756003)(4326008)(316002)(8936002)(52116002)(478600001)(8676002)(186003)(16526019)(2906002)(86362001)(6506007)(7416002)(6512007)(26005)(6486002)(5660300002)(4744005)(6666004)(142933001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: a/OKwdTnEbm8U7FZrfITj3SCq4hk8gFZbQQPeCXhdfWgDhzpvGh+tdQtaaJe/n8lx8CnD1YmZqK5jFfgNMg9tSzyAjB8Ww5nmhZ7TEbsAMh9TmzLOPVF0m4u+3NIkLqYqqoA08UwQn4/a30mo9KEM5AkqxywZyHcT0E4PRkZ//sHZD3MJubgqk7g0YzE87aA/AzNLbNj28ihjxGCYrwvDI1IBYKbCtxHBlUzgYCddHyxG+xErtTcfdfkhMZV/e2mLTGbL5Ph0h/MBFLFXMRkOSWqi1edR+yGHPcOR6nzHCaePY5s52Pfi2iqMIj9KIBefebWgoJ2FAA2kVNn0X762E2cS9uAkPbyLUjONFQSTJ6rVbbUScbSCDW5x4EiZQn1rQ3XWnw5qvSIdu8uPyJ7XYp4Zw+9DzsNztnYx/Q/obBdCKNnfUOh4G40/0dyhLlM5YX0UbJ+l5Odgtw/9Sq51bIwGjRCzOYhcpezm74ByLYuySUjeOi6vvgjQToSPuz9
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34283803-76ee-42ad-3e7a-08d800856aa1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 08:27:09.6165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ekRoixmJDNl6nCOKD9Clat+hAiD/UKOto3C/m0IRswkXV9l9+RUxHHIY+/zrVnR7c/ilNyqZl1GAFjKsv+iOBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3717
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add "snps,dwmac-5.10a" compatible string for 5.10a version that can
avoid to define some plat data in glue layer.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index bcda49d..f32317f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -507,7 +507,8 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 
 	if (of_device_is_compatible(np, "snps,dwmac-4.00") ||
 	    of_device_is_compatible(np, "snps,dwmac-4.10a") ||
-	    of_device_is_compatible(np, "snps,dwmac-4.20a")) {
+	    of_device_is_compatible(np, "snps,dwmac-4.20a") ||
+	    of_device_is_compatible(np, "snps,dwmac-5.10a")) {
 		plat->has_gmac4 = 1;
 		plat->has_gmac = 0;
 		plat->pmt = 1;
-- 
2.7.4

