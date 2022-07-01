Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CF8563A01
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 21:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbiGAT1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 15:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbiGAT0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 15:26:35 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2118.outbound.protection.outlook.com [40.107.100.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA62D433A1;
        Fri,  1 Jul 2022 12:26:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0BTON1lqRfgHffLz4pBP1lv2uQfh8UxMejM2j61sQtFBjIm8HfBd2Y6IOBhrfpBcgRgDgvoMi3qkjcODCRnRgAfpoMOJuT1P5l/US0Id34opnGZ5kT7T3KJVBmz5rHa7+Wf4Zc26tABSgJz6KFG6aBZNncHy/BefWWonhKdNhnASI1qhR7bym3eWja8FRuqIePqbQeSoXiZM4KFdks02txFLnIVNeD8csJ6ln4FvYLCyhuHTeeo5TfNSUHsQhXO9CLMlzbTvK/+zEqLWczz66eD2BVtdcOxhanv9TpVeaEYvmUUdJKENyWGnLVUgzQVjJKFd8zEIj158edZx47FAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wsipl4Dhzz66yWytQ36F+CkMn/5GXBq+zPApv1zsxNw=;
 b=htck+6UUnXE12m6UH+mvFX96TIwAkXU/Z1dAZQHxqYG8QnGexRQq5HmYcUQtk/XxI6egZNsiC6EfHq0rZ+R3kqYLq2M4K8ADh1uY4DkiNHGSdb2WWPjeUk4F2MR02yULFa2L/Hs7NM6MMk4uc9aDcsyPzZyeH3b92389EZU9i7rEjVxsRCyWDjP28UIkXPLbtjp/JrDIbOegPuWTPp5Qgb4hetAS4w5v4RNUMtOc0Sd1GLek1QriaJPvrMGKnyvALoKK2Or1f3EH23zeIG/DpKoETAiQmtllg4NkPHB5hq6XaMUdQI7cTCkXzrABQscJU7Qmck9zfuBArFk+apf3ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wsipl4Dhzz66yWytQ36F+CkMn/5GXBq+zPApv1zsxNw=;
 b=uQp93qeYe6iqs6QMALWxTfdhpt0V5Ztiqx9WCilZhCijyslegdRIJ4KeT3DKQVY7YbHGT1cKjYBp1L8+j3MlEDWZetuQYVB810YZcSSHVt7KDAX1HAi9MQHn4Y3lFk+YPfqhsI3ka5l0LjrrDChO4FHT1QtXIa5ybGmhkzI+qEQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR1001MB2230.namprd10.prod.outlook.com
 (2603:10b6:910:46::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 1 Jul
 2022 19:26:21 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Fri, 1 Jul 2022
 19:26:21 +0000
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
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: [PATCH v12 net-next 4/9] pinctrl: ocelot: add ability to be used in a non-mmio configuration
Date:   Fri,  1 Jul 2022 12:26:04 -0700
Message-Id: <20220701192609.3970317-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220701192609.3970317-1-colin.foster@in-advantage.com>
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1601CA0006.namprd16.prod.outlook.com
 (2603:10b6:300:da::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f73c74a-9c65-478c-a94d-08da5b979472
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2230:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sIGrjGGgdTgpE2THD557dAoD+DZS5J71eA5nh7pkgIzzBTzL9r+B8cTmA5LA5CmFoN4Ssyxj9x4FCJMFQl8BRqlTWWfTc6Cm+gizDuYlD/y4KS1M+X0qOFqjgyUEv6wEIy22UjStuQu+SYQ5YeOwAzVtm4jmu9MAnb8VkpMJ0RvKh1oFFdIq0rvBbuNQGWy1js46J3NWlzmxs7jb+CRhunIOwDnHnsUsmvW/fO5eLFdTM0UWVv89JoiC9goPuliJkbYIMyqLzY4diQI5bh0IvxRulukLAYgIxapzQ/HFUqmJWRtPyaaR26LoFX61RjRZ6jn0wdsXrpPSfqGee8KU3qvuN69x/Oqs6mAfZrcVtfbvFKtw7YLJTDvEYDekn2q7DBuRaDo+/LpYctbBiw/HXzAe3VEQ4KbzwCklylAbm27DmFdYi66kvRgQsXtx0t9H97swRgwcz61L8dBO2yoqE+r2XtxiV0H+vc75xwbGgMr5zIjU2DpezyfGXszoDWDAMXqhK1P60Y1oD/yaYqqRRuxqUQumSzcINNOEwXI7RTXQQGnhcoQMAWXRFRTybfBz4F9z5pCYhD5rOQkjKOECH8k+NBEGm61y+zGz7wXsqQbla2tavK3bl4PAzM/y55RcnfdpKajR1vpdRttfYlfypcbGwYbsgKJUFSMYjunu5tW3FWurvqlXzqSQiszBpupLbqOfdMrtc7j2UW1iCCW6Y4O/jMUBwMyP8JK7T/z8xhuLLfmUGGYaFvDQC6jnjT0wdsAxZ5WniZCeJ/0bQ5yRd42tQa9a/sX3JYB5NqunjSYu4PXFC/Rz5v94jd593yte
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(39830400003)(376002)(136003)(396003)(66476007)(38350700002)(186003)(8676002)(8936002)(4326008)(86362001)(66946007)(1076003)(5660300002)(6666004)(38100700002)(107886003)(83380400001)(66556008)(7416002)(41300700001)(478600001)(316002)(36756003)(52116002)(44832011)(2906002)(6512007)(2616005)(6506007)(6486002)(26005)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5so72e+uzufBTkzns9q8JQEZ1IzusyEReZV0+WTpeXOD5fqVIV//3Ys+FjMp?=
 =?us-ascii?Q?3Rgk9EWwBGzRqMcktPXQnCbnIfxZrA2EXQHnYtLLMFv1vw0rIrsO8alaWchH?=
 =?us-ascii?Q?crxImrGpyy4z7ZO8REAUZ05UlexLXVeuwj5UJvjEmAob5Xc4tnJDKvAdqb2/?=
 =?us-ascii?Q?EpWREUMH3IYCpeY67J0h7IymyuP6DJv/gx+aOHovPnY8TSycGLn1OAQ/jTs7?=
 =?us-ascii?Q?37oYEkvhHAQaFL1nSA0B/3fRdT6HzuKtkixmx2vdFh2mF+YK21v7zV6T50rk?=
 =?us-ascii?Q?Qxbi5dkR2E8vNoNHJ+a5X2K0HFYOQx46lHIxiG6j3CmcdMzAT0c/ptEH7CNf?=
 =?us-ascii?Q?L8PpWWo5a+vTJ8Nizd6NAJ3+U+a48aWpmJlJHUs0JbcwdjIXhcj+TMMOrJ7t?=
 =?us-ascii?Q?8jZVllNy6u2/2w5zG01Ed6dQozmZ+ZAfequyZxb71jsKqgNx79189DfaAnCP?=
 =?us-ascii?Q?sOpOVB8y43NKHfujcRYQ2Rggp6fmFCYrOQrbGhHe25MfqWGw4WL1RVwuxOXf?=
 =?us-ascii?Q?mGqEmomBwHVqskyV/zHSeRYQ7oidqNFU7SIBlJBzTWGuVTZ5RQCTMOiSVXFt?=
 =?us-ascii?Q?dr9igNlBLmqj4oEemc9gn4qirQsSQOC6KZ3wKhAVfcxI/by620REXJH8quV6?=
 =?us-ascii?Q?+5oUEMeaghkDOrDnLDy3k1OnmjbPD2LzN+rsLYmnrksMPoPEMTO9CFSmfhPa?=
 =?us-ascii?Q?BBm0bxTujOaEWuR+BwiYbjnSu94IyX+UlovheaaKzIY1JnOjHgG2dCWrjSk9?=
 =?us-ascii?Q?6foz00w20GN7Wha1rbcOezr6NCBexcclh7lGyPsZ13LqniSfDhbzcff2x3my?=
 =?us-ascii?Q?t62OBFqHHaJUUSCFHUFThNzIq7s8rcuZrGxKjv/2awJQlp9DNsax1Bf/c9Yo?=
 =?us-ascii?Q?HvZp7yGJh8oRuRJl002pbXttIM8/XZGVw4U7gYKbhbhxNv1EL9QcgPsR3MXs?=
 =?us-ascii?Q?qsEJ+caygTF36Klvr4OR4JmEPV6Yl+hnkWun+q3XYwTZhDBYB1ry+UjFFcgS?=
 =?us-ascii?Q?bNOLAvPROnNKshNIHaWwEkKM38vC7urJ8J9rtbAVGwV9Mr7XfiS3/nahJjqS?=
 =?us-ascii?Q?s+NoXRJoGMYuM7bWF4L3gnArFkWthtpH20SfJvSyy5BUTRJC2iSa0zeuqblI?=
 =?us-ascii?Q?ZQTMviaB+0zPqXsmmUKtNSt5rru26WNGLhcyU35J2YxNakGJnwy5CpnZJ7kM?=
 =?us-ascii?Q?v7DFfWjd/kaKSUtksBDU/VxBkO0o+Mn4yccWd6FIgzoPlT/m2j6PS3obk6Ds?=
 =?us-ascii?Q?4v0xQnKT/nPBzQJ3384jm8HI77dpnc9w6Xc5oHR/juP9m73foF0EwsARZBT9?=
 =?us-ascii?Q?hH8wx+cusqb0mNK9dAayK0Ori0pJAaeSRsz0pRCjt6vLfUpQy8RnsmjURH73?=
 =?us-ascii?Q?avV8FxBHque1cho5u8BEcMtWEruKTtMXNOSd0dJLAqVOzUr4KHdVfaTHrewO?=
 =?us-ascii?Q?f/t3q1NVnM8DNB0ZrxRXfCPs/GN6QNeTXrd1TktCnAjJq7tq6oGnWFyuSNEc?=
 =?us-ascii?Q?u0EpBJdFtIGwrdxUCdutdVJ3hmcJBXsTwSzdiCASxWfYLhYAGy7tHZ9OFmcl?=
 =?us-ascii?Q?z0qYk510KWWcNrQ6G6D5hV/1BW2rQb5+dce6z8/wT+PegVDsr7iQyAbtQUkS?=
 =?us-ascii?Q?TQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f73c74a-9c65-478c-a94d-08da5b979472
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 19:26:21.7109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8sMwa05cwh6WcODFKi9AD6rSCM9TTbKx6FO9aP+fF/ui3QgXb6x7fBZ9Zugt/fNj6FPyZm6ZPbolzYG8IWprPqwXmSn6lPVe56KJ+7JeqMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2230
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
 drivers/pinctrl/pinctrl-ocelot.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index d18047d2306d..2e51d313c049 100644
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
@@ -1918,7 +1919,6 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 	struct ocelot_pinctrl *info;
 	struct reset_control *reset;
 	struct regmap *pincfg;
-	void __iomem *base;
 	int ret;
 	struct regmap_config regmap_config = {
 		.reg_bits = 32,
@@ -1938,16 +1938,11 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
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
+	info->map = ocelot_regmap_from_resource(pdev, 0, &regmap_config);
 	if (IS_ERR(info->map)) {
 		dev_err(dev, "Failed to create regmap\n");
 		return PTR_ERR(info->map);
-- 
2.25.1

