Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA4951EF37
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbiEHTGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382483AbiEHS5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 14:57:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2101.outbound.protection.outlook.com [40.107.223.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C09A1B1;
        Sun,  8 May 2022 11:53:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDO6auMHmZC5hWKHVnrgWvXg2NOcnV2hFSXeDJG5DujNRx+PMspGye/hsymfltjraREkzgm1f+YOuYHIfc7iI0xlJKJMis4GWo6Fr7SM+HZ3XSF364p0gKtmKHDiCikNGciZjNl492a7ezOCqJl+/4dM3OrF4+SvEj8x1K7LT9zYu0sg9VKjo8a5bR+j2Hedoqis/RZGmYn1qFq3YYosvp7lTpIKBjmk/l3Vz6i77XcYfS1pecOylbnLOfJOjDDJ3/cWlLZM+FlerAL74M+GByawkwIvmf5xiSZMBZ7CLVB6Goz0Cn4z44s2XFJV0Wk1TQaoF4kRrR1hGjrlYuKdFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/FmacZDFUQIVji0E8MajyeMKm4ENAYkDUSpt5UbVjAQ=;
 b=cOGL3axXO/NulGAXUcX1OEsYGprzdKoE4FpxGkw5IWGV3Sy1vLTzwSn2ZDQGS8Kcde02WzN/pPLgNYV03n1qsyC6SsPHnKFREAGgtpkAAyS+5lw1ZqpmQQ1WjGATzwPUqPRKykR4yroCV78qA4nU6OvjMuO8vU92eRba4s+XAy/xLXdwjhM7m0MipgxLow3m2QywwpgoBppadESjTWfBnxhucGsolveL/3Jj4DGtZwP54Icz3R23yEFULZqtw2hn+gUhZhFu1wQhgaNhxZ9LNS1MzCo0elWIfiIFmxJbBxY5OhYZ3XOR42cRF1DYjiBm89aOltlDpFJCbyIwnB2B2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/FmacZDFUQIVji0E8MajyeMKm4ENAYkDUSpt5UbVjAQ=;
 b=RDu/MznGgbMsbtm1vC1Svd+fTBmlTHzks+HJ/Ky5RXmkHtvy3XfBOSN+9/sySBAAr+cekkLLoAxkhkoSFaws2b2efdF0NGaZNuGitOVyYNZQPyfRGeCPOfb7cLWLpoU1SiNLsznYTrG9sZ2keuOaWthWbduPrANS1hJrjqWDODE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5533.namprd10.prod.outlook.com
 (2603:10b6:a03:3f7::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 18:53:38 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Sun, 8 May 2022
 18:53:38 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>, Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v8 net-next 05/16] pinctrl: ocelot: add ability to be used in a non-mmio configuration
Date:   Sun,  8 May 2022 11:53:02 -0700
Message-Id: <20220508185313.2222956-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185313.2222956-1-colin.foster@in-advantage.com>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c869601-28dd-4be5-8b61-08da31240f9e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5533:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB55332232762EB4C5B5BFD1A7A4C79@SJ0PR10MB5533.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QHsWOUZt8In5ERMyAr8PxZ/8ERRcZ9CdXHk3sXRnettrtvK7wZp/sLHiVgxylro2FjcdYX2wEcjo3fmFzK5AKq7l3V0Lx+eg4RUvFOtNxuViUNthSzcNBiTMvnEjHcnlEOmdX1aOsxIN+xm0MPNqby9wQHGJDJDmgZmeqS75yFMXx2a3FQUIpw1a8Rv4bKUHtS0FX6jjgu1B7waIu5A1vLdoA+CHotQWcWi2hNUidDJwiPjXZNvcUFvi6q9KYhF6E+LyiaTN8vl+0k6sEASR3Akb/YP/ku+4ohh97Qi+FlBycqQAAykwBwu3mS4Nkz72k5e5HQE+oboU0iwjHOCmcRDuq+bYTUOjfoUsOYaByw4X4IDAWNejcn5mZFq8/+z2uyEiuOmAIMJoHX3FGyjhOcitJIgOfm4rbgWoSkDAjY5MDqg42vODeSIg6LxEQqCGx9AHoP+4nDsZeqIAaCS/7moOvkNxf+ZHu+tqizRcwopbkgKPsd95pKSeg45Vx4c7EOFRxoMoFIoxULaRtyYjjwEFGjGtCzO6Cmzj40PoYvQfnYYd6xWUt5jl3nhTFvJ2IKXRgm2nCUUf45tU4qdYaRgIerdY8ptGcMLrseyO5zaBOMOEPjRims1rz7FYM8aWwSBolhosriYlhWb9e8XfRWem0s1gcTuSAPDQDm7QCtzLB5h/Z8cQNvGSbCMSBJ+/olqbyJ9uXTEsT9LKCdgPVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39840400004)(136003)(376002)(366004)(396003)(346002)(316002)(66946007)(6666004)(26005)(66556008)(508600001)(44832011)(6512007)(6486002)(66476007)(52116002)(186003)(86362001)(2906002)(4326008)(54906003)(8676002)(38100700002)(2616005)(38350700002)(6506007)(83380400001)(8936002)(7416002)(1076003)(36756003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qu7S5vKj7kmxYol5/y8Ct5idX2fmmHQ4EMYMhxnJRr99hFpe1IMnUA0bH6Dq?=
 =?us-ascii?Q?KqMjcT6cNvLgLqqO/tz+AU4flqL+SQCRcWVDEUu9gGwwwUW5LXCrqqFZ5FnB?=
 =?us-ascii?Q?CP6NDtGWretM2n1kJPzoiKj6KUuEWCn3iiVOMvRTxO+d9EdvZ6f5Cz2w6qVd?=
 =?us-ascii?Q?726qve192lqAzAy/gNOJQaguLN9n7Orf5wC6ZcY8VLex5kszT5hMRclTnyZV?=
 =?us-ascii?Q?KKpbje3rjGxM6GyufoMhJAMc5YuTEhJTSLK6XHVLOmbfyXaEx2YKrPg7woI9?=
 =?us-ascii?Q?gKCsHD54ZYhuaIt4jQFRaV2raRCP1ZLrms1L+0Do+H83NmVMThTu7dpCvX04?=
 =?us-ascii?Q?TcTa0sGSbPEA1z5e/VaA27W4pxvVyEcmH4/NtgkIgIbhUKJlM7yTwacKXtV6?=
 =?us-ascii?Q?sqXbgmFWYfzPDaTgWJHsCLbmohAEguEQo6P2VMYszXMDV+tHgcFoV0H+hM4N?=
 =?us-ascii?Q?ps7pZlIMwIATr4ihm3q8ss8GQkDVExtsR8q3PfQwpNaRgbwaLThf6ZCuXe9Z?=
 =?us-ascii?Q?nPGLkYolGsvUYsTccWbB5veW9vPC4v70/Iq8LsfUt09vL0q0oLCB36nxd055?=
 =?us-ascii?Q?Ag+wHxT4bKdYczWWkQ+rBU7EA0Avv4wq7GqZUDhbyaU4T5LHNKQrYOIQwVfV?=
 =?us-ascii?Q?tKSCaUbI6MvPT0qMUxLSYs2OHwL40FVz59XoyLIHDTQ5qOPHtCCI/zNEXjY/?=
 =?us-ascii?Q?ByIhgrg3pdllyphZhQ2f3ELA1vRf0W+1TWaPOtMF4AXNvVwhKn6Be4gWD4Pp?=
 =?us-ascii?Q?KxJVXhYQaisn7hKr2z2yvBReIMIMUrt8Nv4bNfnigoZ60dTHK+KYVE/GFjL4?=
 =?us-ascii?Q?8OUBLXBRB0HenqEC2xfr+dNUGAL5JTJ8NddFthc0H3fH5Sh1P7CYOkjW5+ut?=
 =?us-ascii?Q?cnVL5FYDZba/aYLVfr3KIlX5jOdfeenShzlLNgsI4tqrwfNI7yWsE7Tivm9u?=
 =?us-ascii?Q?ESEIHlP6Hci2cobp5KMqNOsfg2BJ0gbWJs5tQVK7J7gDVO18Ocf1e3cTd8/w?=
 =?us-ascii?Q?Biaf6sbSw4voPbOX2mjDd1iPpb/rps7wF+FCfl0+tPwLpMx65ayQYlFHiv7a?=
 =?us-ascii?Q?Y4HLDHeV4o/xO6RGzMtbNFr8A2nzUlv7rYLO9wQGrN4NiNP4ADX52xvbnTuA?=
 =?us-ascii?Q?SvUCMXGNyK2LC/LqinnVLG42Ffj56mpg/ZKMTt9qIGF34wCEjgfvn8ddemZg?=
 =?us-ascii?Q?6ZyKdcf/l0uwirXvErIwyIhmKtEIwjftvFMjnCi0C0NT+kvd7pOotpZqj3wg?=
 =?us-ascii?Q?7FSL5p0AeAD+xK4SW0tSnrrD/RaBVjHwvbep1rIzL6Ku5JlDugCtdSZ0PWDv?=
 =?us-ascii?Q?32V81HX8k9W3NEsJOqQ1t7JbOgMHTTPYjhVXxvBdIYVY6/7QQfCfBkpILaAk?=
 =?us-ascii?Q?k7FdTTSiRG1dD8lZYcewQbbKGdxW4+aRYKGc49rd+23tCLxAvYmdZwCA3koq?=
 =?us-ascii?Q?Fp0aGB6zDFbLK4RryNb0F1fLjGMVj0cNb5QNGOHD5dTMj15GCoWxuYyCsiRp?=
 =?us-ascii?Q?Ez+rOqWCT2XH/xPlEEL6cBVItCuUbBdDEixU06PQe0vgbrms2FIIgzkS+Oi9?=
 =?us-ascii?Q?F6ZFx0IQRmgrR+vtaFR5beguBaf8y1QzaHn1VWdttYkSE+OZEny4sf+0ATwb?=
 =?us-ascii?Q?H5P4R5eIazximMZjaA2xWgD8TWMYqLJb0KFOS3XMM12QbeyHSGamnOx2B4iT?=
 =?us-ascii?Q?XoP58HjCa8Jp8dOIYSh+/5WJmtUscBXwDhiYEs8ScdLVt+bOAZk17bh2VsoL?=
 =?us-ascii?Q?bfdAZIWPZ/Fvt24lBqsIOmIjKchb62oRMZYt3pR84hWUrf2ku2ll?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c869601-28dd-4be5-8b61-08da31240f9e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 18:53:37.9166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jJiJAvtQfAji+qfDePq94hLMSKHBPfl0an3Lq1lAoHIvoIW9edIEj60e6s2E5Oy61QTFCetCsXYa9cN4y54425usd2H1D5Rs9RqduKZ49w8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5533
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few Ocelot chips that contain pinctrl logic, but can be
controlled externally. Specifically the VSC7511, 7512, 7513 and 7514. In
the externally controlled configurations these registers are not
memory-mapped.

Add support for these non-memory-mapped configurations.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/pinctrl/pinctrl-ocelot.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 30577fedb7fc..4995c90019c5 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
+#include <soc/mscc/ocelot.h>
 
 #include "core.h"
 #include "pinconf.h"
@@ -1215,6 +1216,9 @@ static int lan966x_pinmux_set_mux(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
+#if defined(REG)
+#undef REG
+#endif
 #define REG(r, info, p) ((r) * (info)->stride + (4 * ((p) / 32)))
 
 static int ocelot_gpio_set_direction(struct pinctrl_dev *pctldev,
@@ -1908,6 +1912,7 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct ocelot_pinctrl *info;
 	struct regmap *pincfg;
+	struct resource *res;
 	void __iomem *base;
 	int ret;
 	struct regmap_config regmap_config = {
@@ -1922,16 +1927,28 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 
 	info->desc = (struct pinctrl_desc *)device_get_match_data(dev);
 
-	base = devm_ioremap_resource(dev,
-			platform_get_resource(pdev, IORESOURCE_MEM, 0));
-	if (IS_ERR(base))
-		return PTR_ERR(base);
+	base = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
+	if (IS_ERR(base)) {
+		/*
+		 * Fall back to using IORESOURCE_REG, which is possible in an
+		 * MFD configuration
+		 */
+		res = platform_get_resource(pdev, IORESOURCE_REG, 0);
+		if (!res) {
+			dev_err(dev, "Failed to get resource\n");
+			return -ENODEV;
+		}
 
-	info->stride = 1 + (info->desc->npins - 1) / 32;
+		info->map = ocelot_init_regmap_from_resource(dev, res);
+	} else {
+		regmap_config.max_register =
+			OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
 
-	regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
+		info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
+	}
+
+	info->stride = 1 + (info->desc->npins - 1) / 32;
 
-	info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
 	if (IS_ERR(info->map)) {
 		dev_err(dev, "Failed to create regmap\n");
 		return PTR_ERR(info->map);
-- 
2.25.1

