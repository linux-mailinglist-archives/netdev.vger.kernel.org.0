Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B034546BEE
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350273AbiFJR5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347308AbiFJR5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:57:16 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2121.outbound.protection.outlook.com [40.107.223.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB7C7CB36;
        Fri, 10 Jun 2022 10:57:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Si/vTeUvBNpeswT60AJCRgL354sCZZNzuVCLNt1fvdsTw6kNvObZAe31kgsVd4ewwHN8rYrIj9r1ZCuM8PqG0zYE40FoVFDUQt17o+LRS/RDbjN3KvdE62pgv3/W+sSkpcOZd8/Q9ZlgdVtXYet1qX8qAv6BYpsDm73mM7dPYC+3Vqk5+UeL/LiPp+xGP+OV9kflkRML8RarBbk16LyBH6AWYhltEsTOkx7hoHPcZDyAYcjbj34AOgKgRPbslveTk+4vpIiOy6O+bKXg93Ro3tZD+ACvMALUqDiGHOlz6mAc6NmSgSnTqcMEqntkWimOH1f0qkHtxPj6I6gB+/Guww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iAdLj5PQta2TPxzuQkdcF5w3vYdR8cuUjFKNyQFjmPE=;
 b=b5CrrBLPrdjfJmZBH0dCESBTnFTghkzx9Em5KzjQGDXrnPbc6k2e0ZRqXhGCKhc3ojufxmQgPNaMqgbRD9bUxBYMt+GXphk0v9pyMlZ5vZPlMIWrUmbOuNneIrTzisDw2LnMmVbLPWFFdhlWy0SrCAJWjfX3DWtAZx8jVe3HYkE7zT0lpumHqG8H8mmZa0bJkySV18k9BcZNWn8NaYvssOVf3BT1el39Lq6wQU/qJZF7oeEABG/7jVTcbeLlrxcSuz0oLIyl2wu2ZpyB7JvP/XJoJ4VOiT+nLq6P5dHQ7ZAllxqAkQPWR3VyL+N4vwnWdxk67BUrUonfWpKLrvh75A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iAdLj5PQta2TPxzuQkdcF5w3vYdR8cuUjFKNyQFjmPE=;
 b=BGC4UwrkSaORc2EdBW+xrZoB0zs+yfalrJnHajg7Z6IFw5KK9WdoLHks840BRSnKogStk309vc8CRP2H6EJQRrhBmf3/6Ur0aFgb/FbPS82juL+IHgdv24HHV/uOBp5PYR+xi+KvNwZC3ej8g6L3u00kU7LhbxKaHPUy31HZC6E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB3356.namprd10.prod.outlook.com
 (2603:10b6:5:1a9::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15; Fri, 10 Jun
 2022 17:57:08 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Fri, 10 Jun 2022
 17:57:08 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v9 net-next 3/7] pinctrl: ocelot: add ability to be used in a non-mmio configuration
Date:   Fri, 10 Jun 2022 10:56:51 -0700
Message-Id: <20220610175655.776153-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610175655.776153-1-colin.foster@in-advantage.com>
References: <20220610175655.776153-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0070.namprd19.prod.outlook.com
 (2603:10b6:300:94::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f595aa6d-b18b-4409-3252-08da4b0aa292
X-MS-TrafficTypeDiagnostic: DM6PR10MB3356:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB33569E223CA11A97281FB1F1A4A69@DM6PR10MB3356.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WXmJfyzVfGPNp/DUELoEwyJJRz3IDlkAxbMkkFvZOnhALiJ1sfkAY/HxnwrX+6aCwsZRJQeUKNRw/Q7PzMrexn/sw3xLnW4hHLmV4kEVUjnrc5uQzI8VogitCVNvOWHR32Zg0YGSUdl8S5eriV/Wcp9FQNJHGy0SPeBbgUkRz4+IZIiRWa8nZ2+NNzC8MMVUR8YyweYE8WguoPciAfnnOg7xvQnQhvw0oIa4RQwF4QguOo2tskw0f4tiXAnXtkSe7L74DTp/7UxG6+RAJgUEhuwtT/38CLKs5RDyis7v1UrM9ohVE6iNGBA2M2Xw9iRfWHxkKTl6FG0c+0ldqNpl3p/WJ69eD2V+Vb7zflu41L1jg4T30eYcMMrWbCA1rcPBqAH4itTc22JVmadxC0ebZ6w+HxhAn3YY/OK6U0iuUYVlF9ZHK9rUi84DcSyrMvnKMc1wGIHDIbXZobC+Rse7yPYP3rdXMSzF76FbenUZ+cthPDzl57HFFCVoEFXuE9+D61g7UcWTnjN2OT75mbr1om4GZk/cbuLaFflf19bO1ZjBrA/yeR3WOL27iQ7HB6JNOuYZvS2ihbg0dooYo9Uj7mX6jh06REdDcCMk03xIy3wllIcW9IwRODyEYzkTeU+ZOGaLmxBwmVrHVtfMH2uKbJAypJFa+UXvDLp/HAGl2y1i2mwhdEFDiSpH2UUshu+XO0Bk7Lj1V6XHujEXEjgLzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(366004)(396003)(136003)(39830400003)(1076003)(54906003)(316002)(4326008)(52116002)(8676002)(2616005)(86362001)(508600001)(6512007)(26005)(6506007)(6666004)(41300700001)(6486002)(186003)(83380400001)(2906002)(38350700002)(44832011)(8936002)(36756003)(38100700002)(66556008)(66946007)(66476007)(7416002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SIMMwBvqdT9q+4RXMCAoemBNTqZwOKl21yKNqCZoZAgNVK0A83ihwaUy/Rjb?=
 =?us-ascii?Q?lO03ERVZ38tvBL/5CjJEtIwwGcNCzSRJL9S0B/cC4gDQZVdURs6XqoqOS68e?=
 =?us-ascii?Q?PL30gnP0Ao9HILB44Y1uLNRzBnaSWPA5Ld2FK3sR0PjD3EcDsM33dkimZfJY?=
 =?us-ascii?Q?v3l/ZU4baiyq00+4anIJQcATjJf7y5s8D10wSHAjjRt0nUPjg8CvpCG2nxsk?=
 =?us-ascii?Q?G8KIPTJDLAe6F05NwwbuobX2XyadjB9tsXEuVH9pxH6i8rycpGuLBZZ2tEGS?=
 =?us-ascii?Q?PskyuiHiyYkZZphoRaD77hzclpw6oreMvRJ4RG20FyR9GiAnPBXM6RKf7SFt?=
 =?us-ascii?Q?oPAx94U0JojFO4ykdW3+t16E3WNbySMfeOoiYPWUn1nMltVwslF+3rE66brH?=
 =?us-ascii?Q?SdF7c6dX7gZ0l93hXMKoP3WdR7iViMYDDfaop5zdz/ROx0jhZKxn3syT5xYN?=
 =?us-ascii?Q?a75Zw5DOrLP3l0h2kkjdHgUNag9YnsT/HEccYvk67RREYht+H/anHp/gCeg+?=
 =?us-ascii?Q?w0qRViyIxE4/p+/K86LQED3pIlo1S44XI7IEVhb/i/L39eEenISAgjXG0SaL?=
 =?us-ascii?Q?Qzhfre4GcoQv/bqzJvKJEERZOYtUvwuJptCGafOJEpP1ajqd4gVh1kXRCiMB?=
 =?us-ascii?Q?6Ov40u1HahavA6GBwIFvPEUiqj5JB7UdNUsV0ja+DJ+kGfy7WgCFMQnEztZm?=
 =?us-ascii?Q?Q4HB+evgVLfYOCW+OkrF1RFBgwIFjtlsfH89YFbDxfHqbPGWOjm4mTv8R7U4?=
 =?us-ascii?Q?XFVkMntxaOQ2V7WVisWXtopd+Mxh9EzZFGlO9VXNgn2AiyLrAvL8KiORBtQ3?=
 =?us-ascii?Q?0vyNOzYdargdK5nQ61mZljBzq+308KU/L6xbwMOoLji/IqOIDhpT7KgFCrtA?=
 =?us-ascii?Q?qBHbZsi7eRY/FRPy6F+bttviVsm8Mbhmmx0jBMIXMALxIG9whdenh7H4Gnwx?=
 =?us-ascii?Q?4Bz8Pl3OEWx4qBC5UQKPjC6LODjIthztWxQE8zmS4v7dajesoVFJU3ceD4Q8?=
 =?us-ascii?Q?cWIWcx/1VTOpf2ZMjoj/tzb9UnfO02ewLki/QMr+8qKnMsVOnRDeM2C3KWVb?=
 =?us-ascii?Q?0I4M9qIdxS/zjucwrWAMESkMl4XZLwA3j8CIC8aEe2Lrhja+g2+HRNmKt9YG?=
 =?us-ascii?Q?rk942GRrfhBW0/L4UFvAS9Y334aga9nb/LZyBdDuZGDT4FUX78Kdp3lAYTRb?=
 =?us-ascii?Q?TREBLd1CUdlfKVreeR40CSd4eJDoJTEmY4wyHYpUDTVpJ5Ut+OCBAlfJgoEL?=
 =?us-ascii?Q?NpUxjRdM7NcOckX9lrGA4oVAZENeJCS+nj0OM2md0M58cwbBIp5K80fMwXko?=
 =?us-ascii?Q?qhx74tWh82UPEL5jsXgkXuy7Lygo3sdthsKVNjAIjbCapU64mtBQXGV8vkLj?=
 =?us-ascii?Q?jnPPW8yO5kvBum6CYRNVflvHJpMyGYWk2udFrvilGBsVEW/yuwl05YZGhd1m?=
 =?us-ascii?Q?PeFwbeERxvAEmo5QfkYOzUlKA2rBskv7QJw8GeRxL7RtB4Dq64Tsn6MPSAA+?=
 =?us-ascii?Q?0CRAiRvLXLF4hXt9Q2YNYddDULty2n9lBhy78wme/Hw0ZxtVtmf6HJf7OQqs?=
 =?us-ascii?Q?lhdBflZYvaNipJW28v2DJMLEZ4Aq2Kuh4cORrJmK2NH4Xh8Cn6jCjKS7upVv?=
 =?us-ascii?Q?VVK6L4fB6Io2pH0w9jGZzMqX0MRIUf0rEbRBNg6CxRcTSVLASHn2AzedwF0D?=
 =?us-ascii?Q?qYp32HZx5FGnJ+S147hB7R+ioo0cnCvhrMb1fMyADRt1ZO0zEvVdBy5d5aon?=
 =?us-ascii?Q?Ckr8VBR6iA6+bKFaVYXb28nBTgytkPUPmp6qdb5fmkzFq8tn+zw6?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f595aa6d-b18b-4409-3252-08da4b0aa292
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 17:57:07.7623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iVgGDqPGZVUEWxU91TUKSbHJOKp8LbdQ9j04AniN1tEVX+vrDEVfl3Q+u3OXlAh0NRzttzC0xOC3twHwVpwWCeZel2gNU6y0nrHMOKdsTJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3356
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
 drivers/pinctrl/pinctrl-ocelot.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 5f4a8c5c6650..7ac12102120f 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -10,6 +10,7 @@
 #include <linux/gpio/driver.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/mfd/ocelot.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
@@ -1917,7 +1918,6 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 	struct ocelot_pinctrl *info;
 	struct reset_control *reset;
 	struct regmap *pincfg;
-	void __iomem *base;
 	int ret;
 	struct regmap_config regmap_config = {
 		.reg_bits = 32,
@@ -1937,16 +1937,12 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 				     "Failed to get reset\n");
 	reset_control_reset(reset);
 
-	base = devm_ioremap_resource(dev,
-			platform_get_resource(pdev, IORESOURCE_MEM, 0));
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
 	info->stride = 1 + (info->desc->npins - 1) / 32;
 
 	regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
 
-	info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
+	ocelot_platform_init_regmap_from_resource(pdev, 0, &info->map, NULL,
+						  &regmap_config);
 	if (IS_ERR(info->map)) {
 		dev_err(dev, "Failed to create regmap\n");
 		return PTR_ERR(info->map);
-- 
2.25.1

