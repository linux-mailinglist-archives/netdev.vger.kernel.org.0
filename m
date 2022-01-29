Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E4E4A3229
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 23:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353288AbiA2WCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 17:02:44 -0500
Received: from mail-dm3nam07on2115.outbound.protection.outlook.com ([40.107.95.115]:64192
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229737AbiA2WCn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jan 2022 17:02:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZxN5onQgHIk+Rkk7OZSpK3xRn4UWcqcOXt9YAIIPKGdAcaFWgjDckaJJyAlgekiEjuUN68J5IFjr4LJEBbTiG9EisskEV4qRxu06XrUfLtOC+YY+Q/5LKVpgsefEmWv8LjXXKmQALL6L74+nvgKZ6BLZi5Zx9m5Wm64YnY551sMOk262P45bpOkyjz87oIdlYAO3UqdZ638nLB/PvgmTkb41+4h8yLacjueXQL6BLE3lv3TKG2iadp2wlWia/jQHtBrJZ+wgEDovfErRfT8iGLhVkOIkpSZcu+Ck7plIIy86eMNV2ijpPWzfVUsbVfCl+00TbKd9nG2m2Gh0WAKqXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e3v4FS47HcZev4Y6YYfHm4/rqAxgU9EHSxcAEMO0q40=;
 b=ThBrpSjzDMjRxAqmk1z4e3HQkjg2wFPRkhOcKyorQRhkIM+2Intvn0HHr26I34TId4nPed3HYp1vP7jyL7pSoOZuEvtcQ5KUdp/epnRW7eD6V0lEQoDplJCrSldXacaXlJOEOAUJ85VmeKVmdwHZc58ieFTsTIdk/iy3AVTMm9NZyPCrWI+Sl/qWN3aDEwWjZSxE8cnmUPprFRj5kCCzeseouO5rU1VMktpwqKsGHYCGjG/dg3Pr8+jTFXLwewR2MvrmtGEQ6g213XtlRtMULxx8t6CxZm+SgunN+LHBpf9wRKqyKS6KXbmmElvdQwQzpDq9+Iz+DGuzNnsNlKyKzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3v4FS47HcZev4Y6YYfHm4/rqAxgU9EHSxcAEMO0q40=;
 b=ky8/8YYOftA2He303YL/Swjnv8AkiI4qP7BVKDf6ad70p7M1Gj81Lu69fl2SOKJE6mAUzA5lTWPOhlaS4M436h1hZ76GhKpuuDW8wpfemDoAWWXb5VlWalUkZx6NqS9iy1BHBcCtf61P3J/UBeN/UiVqF9Qa6qVNfupqafaze6w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB2968.namprd10.prod.outlook.com
 (2603:10b6:a03:85::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Sat, 29 Jan
 2022 22:02:40 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4930.020; Sat, 29 Jan 2022
 22:02:40 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [RFC v6 net-next 1/9] pinctrl: ocelot: allow pinctrl-ocelot to be loaded as a module
Date:   Sat, 29 Jan 2022 14:02:13 -0800
Message-Id: <20220129220221.2823127-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220129220221.2823127-1-colin.foster@in-advantage.com>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO1PR15CA0113.namprd15.prod.outlook.com
 (2603:10b6:101:21::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 370ede25-dde9-401d-6efe-08d9e3731143
X-MS-TrafficTypeDiagnostic: BYAPR10MB2968:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2968853DDDC0A1B8910B4C9AA4239@BYAPR10MB2968.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pu6WBvYENCWU0KK/udd+R7dkJCBTtWBn1HSF56NCM/Gf3s5bA88lxhfgjGqmUcZjkMe3ALXn4CU8XO+TWoJyYPeNLzrrB0vCR5fI3rs2WUaOd70MkmMwCc2dqrY3x4Uprm8xvj0t6lfccT72P7EVQe30inGWGZYu2Xp9YTdvGy1gR0U8bUV4Kk561ltZfDhzRiaIan2XL0QabN3BiNoXDGLBz0r6OFHQzrsykQjh5wnmwLChU/rH8J4p23nJEq1440zn+5JYMxLd5veo2CJG6rvB/Uffw1J60GCkkIpxxZ/q2br80jjtiv6BCewz29weHT9JtX9IzTNAwGwZkQ/yTzdfHoq2Yc9wzYf44e21c0shVlu4V6oih9BS43hS3SKU9A593u2ZITMQ8VVvPEKDu0/7yeO1txmeKmF8hNeUYx73PufW8m15DSpKjCyDzLod2lMY819Y7SY5Sxys8YPSELWV3GPLSw+50h190IX+Oax8frMdlAp6GCJV+588ZuS+wVrEUBQ8ryi3pphOdW9649whTeiK7v39d1NuMtOywTLuGapyacCZwRbDdjMzPR0pvLYytRln731ZtElLuefpZSQ44mA43pQWKI+eDAAsZ5lq8OIbNyJ2ez1sPMGPg9TDorZkZ6siNyTYAzuvPcZAQLXcz8ppOwCg9TFlAb2XxL1UrjtPIxNjdfLPHOeaayBOpnUWUqsM/cc+LPGqy0NMxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(376002)(346002)(42606007)(396003)(39830400003)(366004)(186003)(508600001)(5660300002)(6486002)(1076003)(86362001)(66946007)(8676002)(66476007)(26005)(4326008)(66556008)(8936002)(7416002)(107886003)(6506007)(38350700002)(6512007)(2906002)(44832011)(6666004)(2616005)(52116002)(38100700002)(83380400001)(316002)(36756003)(54906003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0NY9U/yZwx87PXhfbfQLQZOdvXhDIPveF9yB9BOuIcDL+TkbrHMGR+elznOy?=
 =?us-ascii?Q?PvrFtin6/li802jQORRHxos/SYGsdXzqsrCe15xBBcwPhM4zBEMfHFFwASdT?=
 =?us-ascii?Q?Cenxw5Zbyrt9deg/UqBPgbcwPezUcCQGWtmcIPvfZl3TT1FcKPkcAjg4hKSU?=
 =?us-ascii?Q?dfvQvKtl1XmCvzZBZUDYSR79l6MPP+EqQurf+JQ2IqV3b6wRqUTmrYCB2xLK?=
 =?us-ascii?Q?AKgE2LAYWRQsSV5PXxzB987QXkSPJGCGgv9WmIYhMDLbyq0u17f9Op9S42AB?=
 =?us-ascii?Q?kqWfhhRdkakk88eco7I94Uy0JobVMnHAgViScsOy3zWEkZqONdGRAyNzeQl0?=
 =?us-ascii?Q?iZNnDmIemiU4CJYtDgZ5xVSqPTXYIlPl8bzv3/YSCB4NOQur1AIOrpmVCmGO?=
 =?us-ascii?Q?n7X5rrPYRZF49GzqFoDaTEtzONdM2XAxrMKY6ICrQEjZ+rOVpC/z3PslivY3?=
 =?us-ascii?Q?lOjkzo5KFYLiDY74Egof3cjPaQBCk189KDzAWtRA8fzthk1rE823JB9WYHJj?=
 =?us-ascii?Q?+bYXYr7llgLO5vQUTVA8BWNgSTGMlyaTeikKpp8nY0S9RwhsIxAyeM5Wjl19?=
 =?us-ascii?Q?YMN3dvh40BKCjtqHCAwgXQXdjzeg0cFCZ4yivls3mdh0LXYaUqadZ+heiXrm?=
 =?us-ascii?Q?wSYhz3/ZixPrlbxgEBwBsb8eCOc5Hh/L4t14z0DGFkPGi0Ovpd8NGj9iDSS9?=
 =?us-ascii?Q?zX1OSv4W/ZAeJAwLjfCzkNiHUs9bsa8MD5B6JnAlaoV24G/V2W0Ydr9SpoFq?=
 =?us-ascii?Q?QH6KjFv1uu59fY7XnfStsFf5PT3CEvw0xWzrAXHgVSSQCI79n1htzlEGVc4P?=
 =?us-ascii?Q?WJrW9ZOGropznKZU3bazTCalYaX4/+FwCAQ0MKArsAGpogAemDEfsKquvWmM?=
 =?us-ascii?Q?APNalPL1wI+e1Ng4e3QQAC0OMndKGltbL4r1nDiZHVDWQt78n3o/EWVsokBa?=
 =?us-ascii?Q?btSya+Hx1InJsaJiANSHv31fupjBN8ScE77agzJ/XBKzA7N47hWivTWdJslQ?=
 =?us-ascii?Q?taRS23PTzE32pB52OjpDSjp5sCxvtCLVaJemt1T1iq4XmAu3BYgmHbs4dZho?=
 =?us-ascii?Q?HO6YM3e+W+rqci5A2uA8/B0RxAAXCrSV4B9/ipnGAj+oeTEPnt8wjB8DjX5b?=
 =?us-ascii?Q?8q3sDyC+9Z9o6J06dvqWDb5NWfFTcRXwcGnswPCcBWFvh90avtquFrzQF52F?=
 =?us-ascii?Q?Kj2cxfziwblQIcjTeos37SQp8ymt8thmUFzjptZHykMQ/6Xw0NMDH50Mgq7V?=
 =?us-ascii?Q?3gcvLz4lq4LNRXxW5vZvxkvRGFsjaAxNAWMTSc9P7lSAXdUM3462PtkH1U2A?=
 =?us-ascii?Q?uJ5ENKUszLFH4iC8KVXswQNoC+PKq2Zxtk4DNM/kbvU9B+5fJfDzqDx5qbZt?=
 =?us-ascii?Q?ZoJPq1zTnHv/UDCnH5ofgByTNSLovaeONozUtHJqWBK1r1wsj1wMAhJql6jp?=
 =?us-ascii?Q?S4WKLsghbrwT5Ro26opccECK/LDdAZDA412DW9Q/USTMHMeXzpbnJ/O70S0R?=
 =?us-ascii?Q?ykQ3+NmA0/kAuynx4FCKwQ6CCJFq3wxsLdcP8ETGAnyn9gbFZdDDK4NWO2ih?=
 =?us-ascii?Q?YHl0uLtacgL7AIo8chpr4GKd/fk1xF2pSjCyQq8n2bSRAhZq6tBM6VsIth4I?=
 =?us-ascii?Q?/Tq7fS/U/mQ5YsamajokvOegysyYaLK/++c+AUzgrIIbnOnfD0rVvzb64dg1?=
 =?us-ascii?Q?WyKCiQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 370ede25-dde9-401d-6efe-08d9e3731143
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2022 22:02:40.2511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Y5umALmqAN7fCOOnbUECdEx9W41GtjChETwP4hoqBdTk0KFoQNwOL9yC5Q+frqbhZoO7SCbb7QxB0I72W4DpuukpEWEjr/LKd4eddKKSrY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Work is being done to allow external control of Ocelot chips. When pinctrl
drivers are used internally, it wouldn't make much sense to allow them to
be loaded as modules. In the case where the Ocelot chip is controlled
externally, this scenario becomes practical.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/pinctrl/Kconfig          | 2 +-
 drivers/pinctrl/pinctrl-ocelot.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 6fc56d6598e2..1b367f423ceb 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -311,7 +311,7 @@ config PINCTRL_MICROCHIP_SGPIO
 	  LED controller.
 
 config PINCTRL_OCELOT
-	bool "Pinctrl driver for the Microsemi Ocelot and Jaguar2 SoCs"
+	tristate "Pinctrl driver for the Microsemi Ocelot and Jaguar2 SoCs"
 	depends on OF
 	depends on HAS_IOMEM
 	select GPIOLIB
diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index fc969208d904..b6ad3ffb4596 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -1778,6 +1778,7 @@ static const struct of_device_id ocelot_pinctrl_of_match[] = {
 	{ .compatible = "microchip,lan966x-pinctrl", .data = &lan966x_desc },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ocelot_pinctrl_of_match);
 
 static struct regmap *ocelot_pinctrl_create_pincfg(struct platform_device *pdev)
 {
@@ -1866,3 +1867,6 @@ static struct platform_driver ocelot_pinctrl_driver = {
 	.probe = ocelot_pinctrl_probe,
 };
 builtin_platform_driver(ocelot_pinctrl_driver);
+
+MODULE_DESCRIPTION("Ocelot Chip Pinctrl Driver");
+MODULE_LICENSE("Dual MIT/GPL");
-- 
2.25.1

