Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A834A322C
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 23:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353299AbiA2WCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 17:02:44 -0500
Received: from mail-dm3nam07on2115.outbound.protection.outlook.com ([40.107.95.115]:64192
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353281AbiA2WCn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jan 2022 17:02:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2eek2g99CxNTl0KypgVpNH/9OX2nK290TfAAURCWzSGJj/gtVUShWTWbp/URqOS3btM0vvT1V5XPo+9ceONz9NzHYiVEWSpSRGxQVXXzHVz0GO3RREISarN6X5PlUvFrXi1QpjmSZlk64nLjRl0cDc9QL7a6tY3Aav1h7cczuR/wRvTwrSb8cpb/o5cO1Kee15Fe8ofxkXHegkvmvLZNdX7uS9GTGDq/KJVL87sApkxwaEcfUTrEtPNY0nVlJC3TM3cbzf8RWzM9R1s++te5dit/UKVdbDYsE7zEqvKxCADftM2l3b3uwi1a/pfg80PtylMi1BeHASCtIzVnALHUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=avtWfeMglmtFD8xqIjpbS8FGYDBcMjNGkAW41+u+N9Y=;
 b=Vn0AEWSS0hsQz97EEvSaIi0qyXKt5RrBjC0/uWu2bT3dObsUfYiweoXwGs6tC+Oa4n9GEUKj5ZRE8oW30yOYPVMDGqc1E4zldgpjwQKw3NvxAIge/Z8zd/ebyHoojLsA+vyH5Z/2cJMScLYeqoHYSFHbzn2C1Kx+saetJn5jJDt9skl/OH9mbAjlTIzpudMmR9YKRxQsDwFlHoYORlLC/Fj9B+dkttSGjKNuAFRGGBMu6icy3Tv41kUsVjE5YjZ56/exW1jitOLAniZCXTqdv56M/JTIipMPo4uH1L+f9riwf8qcNsgVNNh5OVN1Aw09A2eURRjUBWFrHluOLc8erg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avtWfeMglmtFD8xqIjpbS8FGYDBcMjNGkAW41+u+N9Y=;
 b=YEqFS63vXjB7AUcKVNe2KrdHClCIeU05tj7+i+w0cnJz9fvaO5wdxdoegIKUqOh02XOXIvpQWznxJwxK3vMf9lFDmSrbHfsUUzSzsDr0rAB8FztckgIhDMAhcI4iATfTKFFFWJ3IyrIBb6+rCNGDi7TNrNrZNFv4+XI+gWZGy9k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB2968.namprd10.prod.outlook.com
 (2603:10b6:a03:85::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Sat, 29 Jan
 2022 22:02:41 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4930.020; Sat, 29 Jan 2022
 22:02:41 +0000
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
Subject: [RFC v6 net-next 2/9] pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
Date:   Sat, 29 Jan 2022 14:02:14 -0800
Message-Id: <20220129220221.2823127-3-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5c2ff40b-5511-42e4-047f-08d9e37311bd
X-MS-TrafficTypeDiagnostic: BYAPR10MB2968:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB296859536AD9A463D73BE6C6A4239@BYAPR10MB2968.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:294;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: biH2OV0zx8jl+yfiZcT2+3R5Vxu4jEih2X+dCSPflr5ze8Q8zdlYliNQuI19JpihNN2P2Xpm5DRouuL+CtI9halLr5VZREqkgXfyi661LIlfRW9MKAQyY0vcXWRmzo4QD9uFAIjg8cNMFJygfzIA2VfwI6WOcQn9IVSYQA/yKSe7CoiBXjHDATslUQbdDBjohEGejEg5bl64Rror+zAI8MosikFrcRqhJNsWwqN5WHr3gmj28bZvkqgM4gXBrbS3dfM9B0Is2AY8l6qrnAUoEO2aOhYGkRwtjKFN78gjf1FDx3IngkCYPke7hosDQegcaLnHsuZbRMRjmesP9SPQTbvRFyygszNL3YhAGFQPHFutl33YJsVptoiHXrlXhLjzPwxPoZNzvmhiOyLez1OqUur/JjzFQVMPEQO6MKPCA/k38tLjqTPATZvlbpxTwOMs3CLnXjtF0e7vwmGml6Kt0bFoUvK4iCTfGOHL9oe71vsCdLTK8Ov19Ro8b9LZKBlljowQlJ9eFb5uU8Zafh+uCASrhmrekHnidOBwmjHMXqku8DMWFFh4t5/W3FIx0PolCG8l0EvRMYwKWTiSzl1VQXF3OdAcbSo7cDbQ1RVkzVqj1QQ08cSUha9y8/qbstb43H13xP+KwjARgrGf2vB/Hd0titXMXGmmRgn6gg3iB1oWvsyN9leFf8PJ85OSLV/x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(376002)(346002)(42606007)(396003)(39830400003)(366004)(186003)(508600001)(5660300002)(6486002)(1076003)(86362001)(66946007)(8676002)(66476007)(26005)(4326008)(66556008)(8936002)(7416002)(107886003)(6506007)(38350700002)(6512007)(2906002)(44832011)(6666004)(2616005)(52116002)(38100700002)(83380400001)(316002)(36756003)(54906003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ycvr+AfwIzoiY9yBOyiBzwlUChKLcLN+n9AG1G50L5xf0IFrO/Rw4Cy6KqT+?=
 =?us-ascii?Q?D/GUs1imXlnMcXkWLBU1nC/EOMfGgQGH6ezg8wecwG0+XXWS+4u0KPfOhqPc?=
 =?us-ascii?Q?NNSIiAbSDdk4xDh43I6l/nuricVeQDW3nrCqbu9TV4oUVNP/j8M/wI/UBOdb?=
 =?us-ascii?Q?L77woWt4775R2qifIOcWnbz/prb9iFflbUADJJ+aDMG8AjuskjLI8Bw4lKvX?=
 =?us-ascii?Q?nyd2pzbgUyuKzZ/tdcnlK5apkwl01TB2otQ5ZphOdCccBbfrYh6QOQOYqHYV?=
 =?us-ascii?Q?f9LayGtJ6qmzvM4GGVAEj+aVSRj2NOnovB/N9HNt/IP3Xm0uTX6Sx5Swwjd5?=
 =?us-ascii?Q?9BhO+2jLXAmUro2UP11Pb2JlQRoMnxkD9tPTCsPDUhruEW+Z2IyDfYnrbRwm?=
 =?us-ascii?Q?QYLSRgySKqbdyeBAHugcmpdaG0su2gkzYPz1+td65wXy+EwILBge3jgKObfa?=
 =?us-ascii?Q?a2GtCkI5S7SbRu4z01SGq6TXpMUP/gCUkqAjbp7g+Z2jGKuUDmZ6Uq+PIOVM?=
 =?us-ascii?Q?Ni/6kBmOFq2LFQ2GUmCaTCt3eoaOqclHK59pSwWPTIN0i7dX+LMeKHOabF3M?=
 =?us-ascii?Q?nSryQ9PJaFH+ImoDZQtxRUoOHWieaLyT27AAjtb/cJm9oImEOy3DnGIZs8Ei?=
 =?us-ascii?Q?tMJRC4Q6cDtGpxQlBsa5bGHtZs/0Bo5kw0CArl3Yoa5YiOM6W4F4B+02jc5/?=
 =?us-ascii?Q?WsDmT5UCu8Hzle1/S2aN/+oK+1qwO4hmPaP9nAEnABPbj5B1IjmVGVbJZFIL?=
 =?us-ascii?Q?W35Ea5073K8/kq/dsw3bMvszZ5l26QJCd/xgu+J/u8MILEwQLjGgj2NdZ4CM?=
 =?us-ascii?Q?teh+6zWi6tZt2/D1BPgPckzyTvb4FvC20JUcX40oN87ETkj12ex9aZzi2J47?=
 =?us-ascii?Q?XzBmYI4HIKzQ5MtMywNgUMTxYX9EHcTKMxWZaHq+fD8H5N+tRoCdOcGWJHXS?=
 =?us-ascii?Q?W0ufxlLzFWE0vhd5iBfBIfaIt5cu2uuMR4l1R8N/lVf8DLr12gSdJspp2aRr?=
 =?us-ascii?Q?p65HR5Y90xMxl0oQPWTSfLj7sZBTMtF9sb+SEgf+SGI0LybyT8LBNSsj2byy?=
 =?us-ascii?Q?kvI7MU3pDJvj9WIxFfDlOlkNmcGJaMWGjopZpUqjIHxb9CVRztiz7rRtybUU?=
 =?us-ascii?Q?z33xZPoHnE7qtGAJylM7SZzyizAumvQ48brMvjn0RHDSHJX2MneHadOlcOEe?=
 =?us-ascii?Q?Q+XhIwzbCE0YI221iRLMMZpsUEiNmYP57cHnQiyKQ6wwslX9ygt6qud3FKjJ?=
 =?us-ascii?Q?xxxdtis0qslO3cbaerSNtXEWdbpmWH+TOe4lMtTUF9ujgjsIgwUODtpG3YNQ?=
 =?us-ascii?Q?IkAupz6tMje23XhAG90MBCOLvxkN9FzaJUqc9Cb7qeZJj2Yn6+atYaWYciCU?=
 =?us-ascii?Q?RRtcnO59FbWeSXKs4+Ss6Zk4WyqywoY3+qQOhip4UZijSrJl/tO9BPEWv1za?=
 =?us-ascii?Q?WcahCUy5AsR1w1abmwqvtvzmO7pD2xc0RReZB+07F7xNwCKM55q3WVn2dvC2?=
 =?us-ascii?Q?7x7J+7IUYkF6H72xpoiWYLFeE4O/wWioFowqB6RuAiD1iHm+Bi5Jdok6e9x5?=
 =?us-ascii?Q?zW5U2FnuLP139tHs4Zy9C3mb8egxEE6VPCOUjqDljUD4HmGWAoptYRIcc9Au?=
 =?us-ascii?Q?EBxk+s9yymC+HnafRCGfx2mFo1ZUbwUEql1+l9zwni+ocyWIQ9TzMoky+LMx?=
 =?us-ascii?Q?8+OECg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c2ff40b-5511-42e4-047f-08d9e37311bd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2022 22:02:40.9386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h5kPQtnJkMfsBU0pjJnPWBWB+2KFCbDYqY1S4+S32LfVaenY8oKheEXKWhQEf4wzusiGWjAkZmJ26S4vAKnDeAOfLCsS4k57NXAOBXJFYw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the commit message suggests, this simply adds the ability to select
SGPIO pinctrl as a module. This becomes more practical when the SGPIO
hardware exists on an external chip, controlled indirectly by I2C or SPI.
This commit enables that level of control.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/pinctrl/Kconfig                   | 2 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 1b367f423ceb..7ff00c560775 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -292,7 +292,7 @@ config PINCTRL_MCP23S08
 	  corresponding interrupt-controller.
 
 config PINCTRL_MICROCHIP_SGPIO
-	bool "Pinctrl driver for Microsemi/Microchip Serial GPIO"
+	tristate "Pinctrl driver for Microsemi/Microchip Serial GPIO"
 	depends on OF
 	depends on HAS_IOMEM
 	select GPIOLIB
diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
index 8e081c90bdb2..8db3caf15cf2 100644
--- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
+++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
@@ -912,6 +912,7 @@ static const struct of_device_id microchip_sgpio_gpio_of_match[] = {
 		/* sentinel */
 	}
 };
+MODULE_DEVICE_TABLE(of, microchip_sgpio_gpio_of_match);
 
 static struct platform_driver microchip_sgpio_pinctrl_driver = {
 	.driver = {
@@ -922,3 +923,6 @@ static struct platform_driver microchip_sgpio_pinctrl_driver = {
 	.probe = microchip_sgpio_probe,
 };
 builtin_platform_driver(microchip_sgpio_pinctrl_driver);
+
+MODULE_DESCRIPTION("Microchip SGPIO Pinctrl Driver");
+MODULE_LICENSE("GPL v2");
-- 
2.25.1

