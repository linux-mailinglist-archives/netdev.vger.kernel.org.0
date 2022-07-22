Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4359457D937
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 06:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbiGVEGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 00:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiGVEGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 00:06:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2097.outbound.protection.outlook.com [40.107.220.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBE889A87;
        Thu, 21 Jul 2022 21:06:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0O+/DRDvEQi50M85QvzHYMgrJ11ItdhxUHQAywTMVW8Zw1s2uMswpxVOw+CnhzL3VgLoU9wEnJ061L4tPj8DX7Zqq6Q3IB5RggQysSHmxPiNlhRC7LOo/hVLKAjd/zTzP6/DxkqWHbNOVIT8UoSI2FTcwfNkERgLk6NN978kxlfWCEabioQno/JP6oLKMJotHRqDn/KgHqHEGDjI/W0wbBqdvYWWXHCbeGB/bk5Dr8HHHPUsmmWRBNe9K9bAKryiYT8qo70YMnhXr4Tny9CVfwJjIlPzvcQP4Qe5Z9Hqi2L/1BG1je8o8elFDumv2QUKaebWdFJv0zDBmxXTuBFfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kK8A1qhc8RxFrx0hyJytdFxYW1S6bsYH2mPTOT+0jtQ=;
 b=lZDYdaXFyZnk/tGmMO8zLpQMrKQMCZfR39sbK3XakM8oiYQTke0ug+Sfjbc1ld8Ymi8y4r5Q78pwCDmRXhthdHa0TwqHvvytTemO9e8+bGvGqtcE0MAwhGzrTZSZQqoQ57FGzpYZ9XKSEAitNPw4OFLhYgdSLcGtqiMKsUTN4+/uVOf58YMrCIWkwYXxaTyodn2AwWhOyqRT2LOuVuBR867HmJ0pdDCSae+r7sN2ocefuJKirdPZIeOzMFbc1Q1W2NxmU/0U1MCWmjd/3t61UmaBlfGxkoTj7spB7gku6Bi+7Rwsl2DLFMiMcsauXbhMbr/gMj7+E8lUHj4eJ5BUtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kK8A1qhc8RxFrx0hyJytdFxYW1S6bsYH2mPTOT+0jtQ=;
 b=ScbxJ1//sweJdXF/FQOw08rk15xG4WGalrG30CRJWlPQ7vSp6TLGDlKWm/ivWcJkGMqhSU9lyMvfRVGd5r8HN5CKO3fJYTdvSipxQ9YnZ0M/fUgAMls/8BdVd6etGesGESR14jXqNHW+V+rHSAPjFD7NzfMfjze0GTF1wbJVL2M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN2PR10MB3919.namprd10.prod.outlook.com
 (2603:10b6:208:1be::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Fri, 22 Jul
 2022 04:06:30 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912%7]) with mapi id 15.20.5438.023; Fri, 22 Jul 2022
 04:06:30 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [PATCH v14 mfd 6/9] pinctrl: microchip-sgpio: add ability to be used in a non-mmio configuration
Date:   Thu, 21 Jul 2022 21:06:06 -0700
Message-Id: <20220722040609.91703-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220722040609.91703-1-colin.foster@in-advantage.com>
References: <20220722040609.91703-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0044.namprd03.prod.outlook.com
 (2603:10b6:303:8e::19) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b228a45c-243f-4d10-72cb-08da6b978e05
X-MS-TrafficTypeDiagnostic: MN2PR10MB3919:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ddl6Yjogfxkg0C8wc/On9U/+/JgGY1rSR0hNsd4q5aZ3D9Kdk1odifKDuCgwDpl665tYQWLpr4Jhzg8MzKdZYKf+0BaSdjlzoZwprUnAcWEoq3ZZE51UDMY7RLrTeFHCEHmhb8DK3Z3WU97OgbcClpx/oitAq2bDl6/RpkeAtUhxeCQRROAqJV4Idw2E/5DS3Kh4Hmyfq4FolbKjg9ASFQvwDEJikNGOlJfHEa+8nBFz1lMl8kLdHGXRb9SlKvpqE3lmTJabTYdr44c36D3ZKkuugjhJk8QkAyBiC0JUQHut7qp01uvfSY4ZIHPmv7aq7EoBMGDcgV7LMRooiVIFMVZZSM8RLRW+ObTtoI2GclUp0/fOhpL7kkYk53FF/5S4csNEVIvDerhOSQMnX3yQXbRCS6aS4HRRidUjDe/+RnhnolOkDcr9URr/Dx5z4ADYTih8hHOJLHu5+t2aVNRadugNR0UPZObZ2FyoAXeFID+Gjp1gJnsVrKcscVYPG1scjl9nJmzrF2UuBdLjnI5tGGXTfZ5oNcYhTWlK4RVkIS8XTtTY038Nuj+E9BSiDezMbJ7XNWiFPn/2Yi7PnFd+6hgaRGz/PcE7V/yCImDXbV+IrBgeomGODArYURw8J8FMY/KGr7/rUexjPdXvOhacp/91trHXuqmnaXbZQIChYoHWGft7deN0z/PBUYfvNPQj09PzEdkcU8cECOz3c8jyItSDecieWo0IJIHxelAcMoPoiLWrUHa9qF3EpJk2St7Mvx6rpTdps4HRJd28aoa1Dt87BizfUkqBH9cQqWgZ/jY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(376002)(136003)(396003)(39840400004)(36756003)(6506007)(2906002)(44832011)(41300700001)(52116002)(5660300002)(1076003)(66556008)(8676002)(8936002)(4326008)(66476007)(186003)(6486002)(478600001)(6666004)(6512007)(7416002)(83380400001)(26005)(316002)(86362001)(38100700002)(107886003)(2616005)(38350700002)(54906003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?67j/+GtpdNYSdNjHdBrlnw2SjpQbQd4A/812voHoG3tsq3Seb+LM3fTe3yN+?=
 =?us-ascii?Q?VIL62FFxLUAhPL6pvcHxBnajUj9OUQNnI55nsZD167++fh1AQU4tTbi4noKP?=
 =?us-ascii?Q?W8BJl9HI28HWa3KqucqzBJEJV8KOVnrQ6kSN8y4djWwVq1zUpiPJ6H2AtfsN?=
 =?us-ascii?Q?e40qiSW6iTw2eEXxwLc75jgX0pKmNFEm7ZFqdJxZngMPj6fB4TdYVSYjg1iR?=
 =?us-ascii?Q?CHl6H0WgU3C3w8DJYqbhyXnfRenP8Lkc+cBMIc8p/hhTWoOyx4pBreypbeK/?=
 =?us-ascii?Q?wH7PZDlp7mLQvbvMrhTRgKZDPrjfQBz6ynyf0u0a3bnpJxslfhXbGbrAur6K?=
 =?us-ascii?Q?Mm+XWa6/vKd8s0ChGt3stmnWtqo5zXm6i3fMTUUWkxkBLeqsfRE/DPiW1pt3?=
 =?us-ascii?Q?4zhtitZZ0MoGGkb0ubYy7sxTdQg5deCLVY6NqQ73TOyWdRt1uhsr09YhYW+8?=
 =?us-ascii?Q?tA+4tiFyL7adCyqUJp43PGbz6jC64wGci6zWxFugwO/nMkvqxa7jW9McMgV6?=
 =?us-ascii?Q?2hcI9EbT93sVfxlMH3zGBzsjENMEsOJbKogMUoW1dhi7Ly2sMwopPEAD63f0?=
 =?us-ascii?Q?u32bM6nuVyBDU3JmbJVMetFLWKRTveFCkvffE44dpXK4zMW0KvN6qAsC4/By?=
 =?us-ascii?Q?CfftOPh6N4tl0TLOvDeZ0zFY0XSD5HT0YFc4RHIXLU6RBEEfb8VCIygElS/i?=
 =?us-ascii?Q?vey1+kAxsUfRl6R9+8ojplk93nMGv9e5Yxt9D2Kk7eB5M8wY7chCaWYawtU4?=
 =?us-ascii?Q?kEorMVOu92Px3dBPR0/aj9s437zOMKg9/Pw1U4+o/sM3YlanUq+IhM+Mdtl2?=
 =?us-ascii?Q?Y+hpMER9YauQ0zDuyZHCpRQESP1ovQoG9YQr6G9dsCQWAnTKlcOJuFFBq3JJ?=
 =?us-ascii?Q?Apmhmyn73RGEVLwicarCtJTtxJppNfWCfET9dgH7vCjQPB/RJgXgttgzdes7?=
 =?us-ascii?Q?95FbCNTEANuto9U6Xq34/fX0ktCb27ubDOmLaS013CqOueP8PpWmHagKYMzo?=
 =?us-ascii?Q?QmtZpLic9EHFgKQ2WLDbGAFvVD6Dz979WiHe+HLNuIncEFhofo2q0VKVUpS5?=
 =?us-ascii?Q?0qkbjYe31V7LFavFCNEylYXQwNfMPAon/wSnOx8Ep5MW58/7oFxXx623IoF0?=
 =?us-ascii?Q?8AVMRlJJjef6cozJaecM/RsSnFnFoyfH4O6SalqT5HXvXVBSVgbmlZCUr38Q?=
 =?us-ascii?Q?YQn/E1KcVj5Cghd6UerNaedFuatatVElMqQhz8SO8EJkFhErDfna1vEdYGLu?=
 =?us-ascii?Q?wJANl1s50dNm1Mpit7KXz77iOeDkDaT1gGFfVqToVJDoDUa/beDWpwoTurou?=
 =?us-ascii?Q?W3do247CfoYcOGiTWBcHx9vmmKXFNBCIelp43aRFHdeN7mtm++1voW5LZGPY?=
 =?us-ascii?Q?ecxDJIYLn7BpSy2dRFeahRbyrv0+Ao2ahZta+BLXZELhyPc8NHnXZZQNxl35?=
 =?us-ascii?Q?yEZb/fUW/rPL/FoNZMf69ID5GCRE8NgA6F6WQjo3BhOg7ySO1HbPTiLySBdx?=
 =?us-ascii?Q?dYdjlr9fCUVsVUb9zPJwCydn2FDMjjYI3k7arFsHi4WaZzeKLSCxpwP5xSyh?=
 =?us-ascii?Q?iYs6HJr03cj0OzSgXjOIj2S0+ZNGda16cyVe/cbQUpf0UVslhhtZDqnJkreY?=
 =?us-ascii?Q?cQBGDcZPSPISArDf3cwp6os=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b228a45c-243f-4d10-72cb-08da6b978e05
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 04:06:29.5176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 96eVxerX0Ts6ZqRzjKx8GiNUYZTWoJ1VFy6pnbLireqwX+rcDbLDCK1tNk99h/onK6B3ZaGw1cUaXNTSxnup5gT++f/cGgf0oG58DDCIqno=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3919
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few Ocelot chips that can contain SGPIO logic, but can be
controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
the externally controlled configurations these registers are not
memory-mapped.

Add support for these non-memory-mapped configurations.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---

v14
    * Add Reviewed and Acked tags

---
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
index e56074b7e659..2b4167a09b3b 100644
--- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
+++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
@@ -12,6 +12,7 @@
 #include <linux/clk.h>
 #include <linux/gpio/driver.h>
 #include <linux/io.h>
+#include <linux/mfd/ocelot.h>
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/pinctrl/pinmux.h>
@@ -904,7 +905,6 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 	struct reset_control *reset;
 	struct sgpio_priv *priv;
 	struct clk *clk;
-	u32 __iomem *regs;
 	u32 val;
 	struct regmap_config regmap_config = {
 		.reg_bits = 32,
@@ -937,11 +937,7 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(regs))
-		return PTR_ERR(regs);
-
-	priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
+	priv->regs = ocelot_regmap_from_resource(pdev, 0, &regmap_config);
 	if (IS_ERR(priv->regs))
 		return PTR_ERR(priv->regs);
 
-- 
2.25.1

