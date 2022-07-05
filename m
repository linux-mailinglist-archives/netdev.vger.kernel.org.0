Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D1656789E
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 22:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbiGEUsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 16:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiGEUsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 16:48:17 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2094.outbound.protection.outlook.com [40.107.95.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D33EEE1C;
        Tue,  5 Jul 2022 13:48:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwtheqiOmbC7jyfqGNACD7IIOy3PjH/DgoB8wMTEljXzbg7pA7VWPlicHm1I7+0ewGelryK3mu1u6Sfe4rIWFVMT7VL1+tL2NHvXvePPJx4A4JWzHNzpVIHOMBUSQkc7/lHFocc6lsg3ogV+0g+V9rCc8UZbf9n36QU9EtYIPma/NtmONRmBCMpfDcuHV3+svofaXZbZ3Sa17H2FTuAJFXsCZeD5iFnyxyJYl5Xj7oQiSgGaX2XboDEDyYrDmV3SFlG1EopXTf9KPgpI0fjzveL0IYzU92vDxxO1hnHJl6gDYMtrKK916PuF9MFd01oiXs2FAIj1D5txTfgn8cOyAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfIkPfu7Ud9GCgd7Lv2zW+ZXZUK4xd6exVIbNLcmw9I=;
 b=irPs82/91sQQ6TA/9f3YMxeSypey6Vm/9mbygmdhKY5S9/U6/MDraybfFLRYZiVLgu3fx0eBmWzeGmJk2zpKbKpXZJhck/ZLG8ikBhW71YaXQlmd9OEULiiSzJINo6FZzGfYO9ottyUo3Pnq3EJgAEwJItwfiTzGQG9d0uWZo8mA4vzBtCEiUxY6/DgNlvGK1wcHzwjBSk2dPZHWUqh+z8llKx1b+kF3rqk1tA+5WjQwET9DkJ6NWyAF+cfu9YYVzpi+ckYiWJfobxP8DtAazOgXVBZmaFUn5w6+TSClIDsmIh8FvUmOC5x9Fm+B31/01cfq3bIwusc+W9PSeAWjIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfIkPfu7Ud9GCgd7Lv2zW+ZXZUK4xd6exVIbNLcmw9I=;
 b=zC+v61p5Xdm7uRQj7HauyqAypwoCDVfwsmVkMMjHnmbPvp6HV/HpUach0J7sH9rksVFSyXLW8IvTgczE1G85E59M7QhKPcl1iqlp1m/WTcVbWnzVkzpJWb4T3ObifeKPbOYhF29MW6mPG/HPM9pcGxZMVuBh4nH6Cw+ZOkMq4XM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1934.namprd10.prod.outlook.com
 (2603:10b6:300:113::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 20:48:14 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5395.020; Tue, 5 Jul 2022
 20:48:14 +0000
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
Subject: [PATCH v13 net-next 6/9] pinctrl: microchip-sgpio: add ability to be used in a non-mmio configuration
Date:   Tue,  5 Jul 2022 13:47:40 -0700
Message-Id: <20220705204743.3224692-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220705204743.3224692-1-colin.foster@in-advantage.com>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR2101CA0001.namprd21.prod.outlook.com
 (2603:10b6:302:1::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc76f6d9-f8c2-423d-6459-08da5ec7ae14
X-MS-TrafficTypeDiagnostic: MWHPR10MB1934:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P2cxkGm1XAttLxchzmKk7he8E88HhQiLDJB+cJpEE6+PLXtiuhHdpNEwj+/VCGhYyTEd4w1BfYE/WIN8KAldAou9ooG59X5IbA31A84dw3LCDaTEqKrcCgoli3p03p2SV56vdb09hqhC4cd6Uetex/byEySHTdsWuH+tbwo4cPJE4S1MX8Afnje/6PVyNiCz7EQF2LopPEUG2N8v8ukTHnrrXNvmfX3N/DS/i3DN8N01M0CGvOX++SnYEKX51xR2VLkTspB0BElgDdu87Yk+E51c6JHnyhsAg38K5eXOD+iddrL37JODDDRr3VhqxTCTDExQ/GERRSuSCYcc//voE5fCI1Rv2Y+67er62vDUgQ8zuGx5SBMA8w4ThVNcoNrVvnoRCuaBfKemDQqcefJvRRWTsZMpqBsd3WPFwOSYkCnFE+CkPDRwpwKGyYB0pqxLzO7a+taLrdH3PTXQHqYazwG+4rjHhG2+k3bOLXNM4MHXK/OnNRpw2n6yzGC5WPNrvlwPv0mhLVWudkEWLP1IvP/i/fc9Z1Zz/Ay3+YBUw3RXJYSzipt/64sf70Tc0hKML/UV9Q/OzIq6IBk8vk8uX0ZQMtN1d5yLlb3MCMjwvbucj+t1oQETzXJdzqKSuepVrYUdqoUxIa43IYw5W02kDS5c1OAl/9t/V+QEaqzgp7P31sTE2o/deMzvsjG6D2xDjBcQhwSvqWUiVqTFo8g1BfyuX+UsUhiEVNx22BTGuS6mYLCtzwn5rZMbSRKFmjTcMnaie44i9WaMZp2ViwBBYCC8w/v1fcHoTmsWDYRkJCQA2r/fsjv/ZR6uJJh7Oj/1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(396003)(136003)(39830400003)(366004)(7416002)(44832011)(478600001)(5660300002)(8936002)(6486002)(52116002)(6506007)(86362001)(26005)(6512007)(41300700001)(2906002)(6666004)(38100700002)(38350700002)(2616005)(107886003)(186003)(1076003)(83380400001)(66946007)(66556008)(66476007)(54906003)(36756003)(316002)(4326008)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p8KWKFE3Mf+RLTNYIzqp4kPOLEei9gGJ/sL7WllnbtNKk9+Y8d5wlxcmbkw+?=
 =?us-ascii?Q?auSHfgw4OVTz6PEoBfvt4Ecwenxf/Tmwy2BItcW4T/ZmQ/9NXk4xRYBqvq/k?=
 =?us-ascii?Q?DFPSuqLStZ1DvbiHkcnXlRQs1KaKgydoj1o3ndHkKgokquJju93sTuW4ilCm?=
 =?us-ascii?Q?ii86PUEQ1qiDWFIkkp6Jol2PBGFCeP32MYhvkXLf0QpYfVqQJw/i8Vb9f1Bi?=
 =?us-ascii?Q?VmD5kIvKwQFufG+S4JacJzUQcW685VhztxwxiNGzUZGEzhFwVeXLFZ1ditwV?=
 =?us-ascii?Q?O4ZeCZOK6AHbTtB4Lc/2hRW3YtucMdjzZmRWWsAHNJlp+EX3OGQxaJa4bp0H?=
 =?us-ascii?Q?Ox8LiC74gCL2kKnV/oRskqjYivpGqdD7gCt0DSwusPCjGbPyjspWNzf8mh2Q?=
 =?us-ascii?Q?r1NSVh0+lBuRPrEOxMk7HNhIiHNQ+/ICCrnENbG53KJUajq5TshkoqYJGuhg?=
 =?us-ascii?Q?H2HWaQjonpJ0AvR9yIuCCP0rEhdv3qfQgml0KejhQ58nthw9efrFMm2Ekikh?=
 =?us-ascii?Q?ewQOHU2oQogca+HdZ/IxdP+9r5S2Q8dbzpwS5noZEz3wx8Vk3Uny11ZQNZbF?=
 =?us-ascii?Q?b/c7hhhflRXysHZLYIhf4m7HKa0DKFAlwWXku97QcUgNOIGcODxLmv8icK/1?=
 =?us-ascii?Q?ysiLl7vy0FALpoDjOWX1vrRIS/oPmGloJJ9CB4JlHUR7Lg1bNcvePJ4RgC4k?=
 =?us-ascii?Q?Vv108skwyUdxCeBDgSmSNl3OVIpM+bZowfjiE/pnV+gQe1EJcMoyRDyrvOrN?=
 =?us-ascii?Q?X86mx+l78+JrAHzUN0KE4JFwt4St4DocmFOfok5++KSqqOHXVqPBopeMPK5L?=
 =?us-ascii?Q?nmYr/sucz3GYVhz0r82qQiDON671wgaTkJ8S4cMjs+hmqk+QyJq1zV36XcB0?=
 =?us-ascii?Q?o47my1xlrzPA+Q5BZ1O2pZKxibIKNKg88TZ35UtmNJgQii7eNbzGR3k6BdRI?=
 =?us-ascii?Q?QI1oARvFlNYS9Jj9xFJaRSmkG/lK9k8tyyK45uQMprdaTPTkDf/9OHbIZiKu?=
 =?us-ascii?Q?24+A1zul3QahKIe6Qxfj/uKWSYC3NDfCcfzb8eF5x9opUesnHSxsJeOPRQgk?=
 =?us-ascii?Q?vSM5PSCJuzHgakE0G38b3icQsB4eju186g7y6k8rj/UGkeZuuds3qex3/K0M?=
 =?us-ascii?Q?i5mcV197bF5nm5gvBuqhUJTn6+gHCQE+V8AHhzdOIRNlqFmUscOhkFYTeuQB?=
 =?us-ascii?Q?+agZVKxIwvx69yUA2mKJg8KKCxWS6wboIoBmPu4aPVDAciVsyUWPSMltWWhF?=
 =?us-ascii?Q?PQGmd+N9Ghj27v23zyxv4Wtl7+6IC1jja2ut+ZfOxPe1dTBpcBTtLp6sYSVm?=
 =?us-ascii?Q?1qp9ql/Dls65yqPGIfwYjTINvJB3N3xtrKmtcOa5doaHydMeePB6qIlNLW+d?=
 =?us-ascii?Q?Weqe0tkO7hdH+z9PqN40Kf6CdoQLPhwbsXEJylULlFfJGN2ZObofucj5oN2r?=
 =?us-ascii?Q?JJjCAVb0N5uW5E44WdsEHRpaVjQxjF+4Mr+4Omt4hVAOtNSTY53iqCSGAN9l?=
 =?us-ascii?Q?C9QWoWIaDZS5Ka7TlWdHf+Kgv1dpuVtifYD4DA+6eFcvfMVgDQ7ndLa+c9zf?=
 =?us-ascii?Q?Q6Im8oSfbzqGOAbPTO57a2UT/zZNNGU6wWuDewceyzhSBaOqFwRKd/3+XZdp?=
 =?us-ascii?Q?1Q=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc76f6d9-f8c2-423d-6459-08da5ec7ae14
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 20:48:14.0608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NtFsFFtVIMLJEavfrc3NTvgBUCMTZFZw0NjaHLFvfFF8HQo/VNfPaxC9eS6v0q3wPsBLE6/tukFsalwZbKnCF6eWeAw2CGbc+HRbBvPdK3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1934
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

