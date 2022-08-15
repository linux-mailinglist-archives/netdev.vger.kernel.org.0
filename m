Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4253059273C
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 03:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbiHOA4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 20:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiHOA4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 20:56:36 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2126.outbound.protection.outlook.com [40.107.100.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF43B856;
        Sun, 14 Aug 2022 17:56:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXz78wNYgTSok5mw1l5QdfNuqXkUspgd0c7Rxi2lLKnLHlFiglupLnsbW9jfsamoL7JaMwoRgvTzLQGZRBzRG9Y1fOmpTNrcVcUhxK1CsnvBt7SZ4qzMIkmcLbOjuyDGMXxfYGfPbfpafwsBHfL/6WTmUakl4wV43awkSgEZovixvAbfD0fGnI/Ql3y3i3jpNdrAb+8kqRNqGM0uAJWrw3ftwTDIod4wEtPHjvyo0P0BlKjuVD331zKS95lNhjXnXGH7kaBvlMoHNi3zljEAGjMcLLt+Rk4A6hjNijEnc3UMpd+fpQKhSde1F7S6xkTlnHGVSWrYQ+SZ4sd/bNZPPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X5YiTOizMEq699Jb164Rl8ZUbsPRl90dx3bmh4H/GhM=;
 b=eqSIVgQGEX+bFXG1xpIwGn/9qFuvMzDM0q9N/7iiCa++cFcVSlZrRrpRJH7ewVyfyvZn84mhtGLA1K9vrQrQXPsr6oXomf0/+skLlqsyguN6MHDvQAB/GBtyyvv1ocN+x8vg+BkH08NJouLNWQtjM/rOEip6yV8Iu287Lz43qa2RhdXsf1S4tSrmUoJXFy1f8jpV4W2/i12iWpKp3nNqH3NS61GhSIf5/EktebxMfKD6EohdGigPCc22IlNrpqG8LVN9Zt8ElqvVW+P91vDA06g26b8HgFQwM8cjy9j7hD8aIP9ox0w3HWNEV5rH9d8gIOJRjHMOdrdEfbqJZDUCkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X5YiTOizMEq699Jb164Rl8ZUbsPRl90dx3bmh4H/GhM=;
 b=I/UelCScXdKPqZSQcNwCNJF6qh8j82ifg7rHzh6iIsP0SSefmHcOJ6eucOQKix2eeDhf5XAk37vYJGVsR+bqI5BJN0nSr70FL+oAMJZblk8rFveF+pCVHhkD0+dbFsjSk35de9jy+5pgeUwl0ZYVhxuJOiTDsIrN3yfDbeBt5so=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH2PR10MB3862.namprd10.prod.outlook.com
 (2603:10b6:610:8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Mon, 15 Aug
 2022 00:56:10 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Mon, 15 Aug 2022
 00:56:10 +0000
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
        Lee Jones <lee.jones@linaro.org>,
        katie.morris@in-advantage.com,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v16 mfd 3/8] pinctrl: ocelot: add ability to be used in a non-mmio configuration
Date:   Sun, 14 Aug 2022 17:55:48 -0700
Message-Id: <20220815005553.1450359-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220815005553.1450359-1-colin.foster@in-advantage.com>
References: <20220815005553.1450359-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0034.namprd08.prod.outlook.com
 (2603:10b6:a03:100::47) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fae45f93-82d9-45f2-937c-08da7e58f15e
X-MS-TrafficTypeDiagnostic: CH2PR10MB3862:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rLumUiK6yyCWeSsIgZL+8L4Zot+3M9B+sBbFgGJ5CQ/+CrkU+QKotfNXV43jQvDg+BlwDchcn+dW+zORJKyK+LNs7s/bYsT9tCCnqb45WIibFzvVfBjMzvSLJAa3K4hZlKt1ANwfeqVK3OG8ym7cXKGe9XEmpE5n4zkh7egm8IJ/aoWVsEqlZ7bwAkmBpvML440wfxnCJp2BAJU36QhzcRUvkqBi0C4xMRZUrVpRCJ8vZFyd9QsUjAW1EYfJxnjjD6tvr3vP5jRWV62259vWKRGE1yf9yMHLyqKp4PSP/9UPH7fFWfbgckeYZx+YUczkO4oJ7In6AgZRK7iSU4nM5eIqHhvJtr7F9/xoAxHCtpk6/bXSMfkXOkJG/t/s0boNwkbMTrRnrGbslaUkjehr25OUiM6nSWrtwq0zmXDmS2dPYSH6nkxTE3oFPxE6rpeYIedrZ3eP/wR7u5YJCCBGvGihL6Yj/7TisdgEuKTFzy3rehXTZoKSWu4t0CE87gaelnV3V94ibGOMafVhykpI2lw1TCkcIcn+m/Jf34mqc5BXR7Cr+8firgmsfNRfMTgjd7NgkWlMtBhrNPbEKyOMbOaARte0ziqXCBZ7nFSSV7so51OyUaKdfx3ifZRnj2rzEO3laxmTanvnJxDYL8lOhzuSF44sdSsqqFUMCHbyF+d21EMgf6eSqyRIkarp5/yniMllJGgUH3ryTETFWvyXp3Xdr8TccW2oRwuFcdg22Ggcn/5604nfAQ5ijmTfvZoSY1R7w/xzWclBteNsOJec7uZwFIS7VF++yRPgRPPztTU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39830400003)(396003)(136003)(346002)(376002)(1076003)(54906003)(41300700001)(52116002)(2616005)(6666004)(86362001)(186003)(6506007)(26005)(36756003)(6512007)(316002)(83380400001)(4326008)(66946007)(66556008)(66476007)(2906002)(478600001)(6486002)(5660300002)(44832011)(8676002)(7416002)(8936002)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NvFJ86bZyvzLEreErLjuyH/UsBN4BD+TR2Y+hAXXhz6LaFGyh1PdHVkTM/yV?=
 =?us-ascii?Q?rq6dFlcaEqnf9J+1Lw+k1IW99y6nMnyLHrYnc8sAm8EJyzkiEWUsz+pQcdoF?=
 =?us-ascii?Q?0AiTWYA2+fvMa0l+4Xz18C4MFS7R6u+I0ljpSfS1ODj5Woiw3QG5viZmsmBZ?=
 =?us-ascii?Q?m/6VXgsRmf/S6QlQqcHO3gp45hdN9JLllUWk22iVnL7wl2vUmlMsss65d50g?=
 =?us-ascii?Q?Y4SVJC9AOL9x0WbTSSrOSZt3k6PHlRSgLfJBrxpa8NEeJhdmtbOphCl+/BWU?=
 =?us-ascii?Q?MTwMVEmRpwuOYy2fZ30aGKVqPumlbPEfjK9Jjp6mk3c7DNg1JSHgvEtCdBOe?=
 =?us-ascii?Q?4n+KKA1poRMEF64ogEaHkqHEWev38kDvr/fQ3Mpdh0akuGUoq5GaxleW7mi9?=
 =?us-ascii?Q?VhHEcN21FGP2Cqk7wzPI5lhK/VYhlpo62yp+V/jwmQOSv25I1WUqSbFU0Kdr?=
 =?us-ascii?Q?aLnzAf03gQZZ1Qs02VScqpnhBctSWpVRkyvt+Gy1R6U57V/S5dedns0MsFqt?=
 =?us-ascii?Q?ho+mxNBaWOX6/EA9XbofPlGcLb5L1lQ0sgskeTPc4XAMr0TnAb3nJvkQEJR8?=
 =?us-ascii?Q?jrcPgmN/lp2F7iYulVjmQ8weN/PgXEN71Ximze/As25fTl+ebV0WEiDWoIde?=
 =?us-ascii?Q?/soOUqwW1ozJhlvfzrxdBGA6062Hv4xSsHHrK7PHZy4caH9HWE+v4o9gWg2Q?=
 =?us-ascii?Q?JMumw5rBjZecUUMO6G1SRgRgTjSi5TKNsKfGd6x5dlnwihsVfXtEn5sGloAL?=
 =?us-ascii?Q?Du95CpXeuIAeeHxA5Tm/0BLJJKN+0+C9tlVk0VnXmjh8wz4KpFEWMIu0voNZ?=
 =?us-ascii?Q?MAR5B/n13AvhaZ0CTg3wFtM+g+a2dMod7qab+J+n65rictyilYOAVUt6/gbK?=
 =?us-ascii?Q?HqXIbX+TRiNBWfIG1priZha8b9jnpHnhcRgiw8PAfb6fr+RMFZQClZRJDsin?=
 =?us-ascii?Q?ne1OA4xfDVAGUBb3Wqzyo+uhD4/00rTAw1U2Td+l+EI9bGFxUiXlkF1ZObRg?=
 =?us-ascii?Q?j45T6yaybe9Dr2a2hFdYCeZgjoHu+wZ9GqvWIos8POOI3kuiDSVDr4b/uaVN?=
 =?us-ascii?Q?eScZZRuaqyeIsmxAw54nEm9WhtI3w8rewPfD9BSZXC+7wrlW5va9HCc1pRta?=
 =?us-ascii?Q?0+fZZmi3KuvLIiNxTv/kBy6WaS45FR+0C3DhHDY+a1Ur8gyHmou+VHJGz78X?=
 =?us-ascii?Q?keJ6As6DjeRHZN8ZNrcjfY+/6eaQsYVMOO46CYh0TlEMFvxvcj27ImzoNQxR?=
 =?us-ascii?Q?eukL/QeNj0LWKmtNpR92zvOkhb/KrJH4PuHzFmoEHuGL6ObLonoqzoFsc/0j?=
 =?us-ascii?Q?C3kc8YgvyWfD5K/qK4Ko711fJG7HWIf7hL7eypwn/iEJHJDzYvYUlj6pDOJt?=
 =?us-ascii?Q?0CtCQ5ccuxg2nGoBN7Zp69Y8+Ms4GT/bd9HvvNSjE+Qln44aeekWKXNkVHay?=
 =?us-ascii?Q?Mx3ez/ug7ral2dBxyJrFzSDGJO45qK84braixcMSUPJ7pyS4r8vu5aaHSBUa?=
 =?us-ascii?Q?wtn7ytpVkY/Ch2J+PHjgNtBbZG5vhi6i4Tc4d3e/yZ2aI6/6glrR0PFTmIQl?=
 =?us-ascii?Q?mOfojRurCqFSYuQRGXiP751BHknTmhNfMRPUDR6bUOVjgiliK2rlPRPzcpsH?=
 =?us-ascii?Q?qA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fae45f93-82d9-45f2-937c-08da7e58f15e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 00:56:10.0106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W8E+Xakqg5aoXqTbeIXh+7mOJCuhnde8++MUKMMV7XeqaOKYFNCZcpDECwT/w+vZcIjUcnApqh/kwXG0N2hD2o+UHFooaW6cENuud/MSYjg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3862
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
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---

v16
    * Add Andy Reviewed-by tag

v15
    * No changes

v14
    * Add Reviewed and Acked tags

---
 drivers/pinctrl/pinctrl-ocelot.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index c5fd154990c8..340ca2373429 100644
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
@@ -1975,7 +1976,6 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 	struct ocelot_pinctrl *info;
 	struct reset_control *reset;
 	struct regmap *pincfg;
-	void __iomem *base;
 	int ret;
 	struct regmap_config regmap_config = {
 		.reg_bits = 32,
@@ -2004,20 +2004,14 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
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
-	if (IS_ERR(info->map)) {
-		dev_err(dev, "Failed to create regmap\n");
-		return PTR_ERR(info->map);
-	}
+	info->map = ocelot_regmap_from_resource(pdev, 0, &regmap_config);
+	if (IS_ERR(info->map))
+		return dev_err_probe(dev, PTR_ERR(info->map),
+				     "Failed to create regmap\n");
 	dev_set_drvdata(dev, info->map);
 	info->dev = dev;
 
-- 
2.25.1

