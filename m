Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A695AD746
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbiIEQWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbiIEQV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:21:56 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2113.outbound.protection.outlook.com [40.107.102.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D952657E27;
        Mon,  5 Sep 2022 09:21:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bpo4hU+xoBoowd9DM2RGlUJXYdq60ThTt9icTX5ADeX442qphOPwyCk4vDe/jtga4yzs4ujuGQ/HP9M/qFgIs+A7SC9El3wY+51Jf+MtUWqiEOHP5/FABWPS4N8WhNtyQWmdp63IM/FosSElcsrW28JVzmacmIWTqygjj31bzv0bAGubM3k+opDDbMcqJdTPH1lZIYrGwdzdqjUCULrT9FEwCTWISO6VTWnVE6UVRzBrjwvG03x0Im7GCKr9lH68G3/1JRwWMQ4/rW+cPWrdgAVeumSrveJlJV5OhMF+44ktrthkMa4B7yK31rKuFKxgDbQObcdncozDvG6frXTfUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X5YiTOizMEq699Jb164Rl8ZUbsPRl90dx3bmh4H/GhM=;
 b=aU1H/jXMI8RF4hyndcW6wQQPm8BPhAC2+9tADJpyiGBlDXRLqwhvoxd6yWXrNfS+yfqhEVpspGkTH0i0hwixfLxzSbQ9ZkREI+GqsNYXffvpon4XYDNz1kCCsb6H3cz2UB8HpUzTy4svGm3CfxkuwgrJfmaSMtSLP1L/LMcalJQuaENxV4CY9mctYp1QBWFTk6AcqyZ+Na+1DtxQ8mbL3us+9ZMo5+OXrX0fDgsLYYP0zKCypbElmoans55AeImvCMV5WF/HR3yy4zZIqlImAtC+ADnfhwHIY9wAl3Sc50UBGHKCcKUGGGDWPzuK/cZ1ZgIN2bIRetFp0EeR4ECv2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X5YiTOizMEq699Jb164Rl8ZUbsPRl90dx3bmh4H/GhM=;
 b=NeX7qWBOx4fA5RzmeF3Ei7R2I1+YsQ5myX+XtMCjchK/qq3YdliK+f/3CqfrU9J8zsvyQOx22xhOuGM3AbD7iYPjUa+DJvExPkwj+9oP9RFfn7XcH9XQvYF7983aiHJjka+Xv7WxxofJWSgpCJ0+kuBbhDaE87700TW4c6ATMdQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB5848.namprd10.prod.outlook.com
 (2603:10b6:510:149::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Mon, 5 Sep
 2022 16:21:52 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.012; Mon, 5 Sep 2022
 16:21:52 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
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
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>,
        katie.morris@in-advantage.com
Subject: [RESEND PATCH v16 mfd 3/8] pinctrl: ocelot: add ability to be used in a non-mmio configuration
Date:   Mon,  5 Sep 2022 09:21:27 -0700
Message-Id: <20220905162132.2943088-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220905162132.2943088-1-colin.foster@in-advantage.com>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0263.namprd04.prod.outlook.com
 (2603:10b6:303:88::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bd45423-6b15-4f37-38fe-08da8f5abdde
X-MS-TrafficTypeDiagnostic: PH0PR10MB5848:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CvrouJWHnYvyV3iHkBO73x/KE7oi7UfoZWS8wx/9HazRWSVZ7XBrNA+OyeVsjhUc9TQ75nQNW7M8yCz705MXGQoLtpRFWGGX5gcnFm8NpooSlqv61ht1sCfbLF8b0qwekyy7pSz5iDeMG7dF1DXA1GdKubG2FwxbBhFV+huLAZNF0d6BXhcgZjGhSlTv4ky43DKFcWASy0ghao2kxvSpbW2h4CNGbKFKtF5zK+jx6joHqUh6Urv4013dVIpmLU/yWGPFZUCdBpZVzCO8NMw0LkJHvGLw+VCMNBcNG28SOu1CMLIWKxa9VUw/VKvsOuO6wcHBamu4uNQJfJ/qTapm7NRPq9vdXAhelE+TvGcnjdIaAf0xtrUw1wcSGxmwRo3L5WOMiOKz46TSaVdlCD0ERRdNakdRgma8xokhZqWIpVbRABgrPMopuAtIScLyr7hW4M37tntYuBAegGycH87qv2/sNPuvp0+C6xfJv6Gs1J2JhEw679dHFKVwmrDndBjAoruZRAQNJcmO8KgWMDMMheCk24tHbwavjwQ4g42dUtstXasYYWD10Pjs9mM3pultwXkzWcONXcrG788ThODvbzcTjQutwHa2uQWVnr3h4m/mWk6xCI9kvrCWebF9mbFFT5IdJfqM0lXVXhFHx3fYHhwq9CMDHtYhW04RZn0CXpn3sbMZjKB8VJCAmX/LkKf1NvItjW9zY3ctByMtMV3+rBOLVKIi9pT+AtvhJe2hhss45oKrZiQhlfKbXtUGFe/HgEGDt/feMPclTRcWllkhug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(376002)(39830400003)(136003)(366004)(66946007)(5660300002)(8936002)(66556008)(54906003)(6486002)(41300700001)(6666004)(107886003)(52116002)(186003)(2906002)(1076003)(7416002)(2616005)(44832011)(6512007)(36756003)(6506007)(316002)(83380400001)(26005)(38350700002)(38100700002)(4326008)(86362001)(66476007)(8676002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jufrvM/znJd2HAgHAkscTXPYwObU2D5cTBhwzWF3t/UjXsQ+S0DYnQHNLV6N?=
 =?us-ascii?Q?4pO47wY1P+UeL++vHGhCeXCvs7brRyO/swtVDJ57/sLK241KpBPryzBmwfSE?=
 =?us-ascii?Q?Qmmaljjy2oR6i8UJvXrWxnkDgeCJylkPrj9rn0CEvTqv+HDvwHDljyXTGg3X?=
 =?us-ascii?Q?EvKdF5G5IUMI11/xdLEPvu/vPX13CJu1CwfAPW6nO8J8D+yDAUZo/eIFy3Pl?=
 =?us-ascii?Q?mQDmbq2o2SOG5+ySz77fJbzzLafXPOWRAP/K7sHbRCyoa+R3ji1+xpxx60S3?=
 =?us-ascii?Q?KWdvTpPB1k0kg7hMFR071x6H3M5MvGnE6n2GVjcdJkKqT+anSotnAuRNfLzo?=
 =?us-ascii?Q?89gFXhl9y7J/foY5zK/pmgSfxqP4FIh4XghawvojpR5TCdFZsFm0xi/YYXl3?=
 =?us-ascii?Q?uYrMxN3fcJKfFjUs0jLCZAVMjzKBPgiuSWJztXb9BaKt3N/pTrMhALD9R/Si?=
 =?us-ascii?Q?XmscHiFZkIyaArNOWCycwQz54ljFGgVP3QM31Ds8ihNrNLrF26dqsi0+hELe?=
 =?us-ascii?Q?kEHXC3NInRhrDX+2NC9bwJElvKt++ICnkmFXpsjrMGaKl7ur2rfpAElvzTUw?=
 =?us-ascii?Q?K7egSplO3r/+01Ak5Gu5NFqR983H2Yr3j3xJPdVhETL7fyD0kaJFgzNomuNW?=
 =?us-ascii?Q?dCK1A9AciiZW+k9ILCh1ZBr8T5dwzpyp8MQGMeZ9nIhzJOL73rTyt+HxARu9?=
 =?us-ascii?Q?gpT0LjfkgbHVQFz8DSVBwMZbL29zhz/wo08TWoR1/m9V6/69i0vPLPDx3/yc?=
 =?us-ascii?Q?yHL3Frc60ZbJ/zJFgzdc2HBCOuqNL/N+xPJ57RIL91Dkswl08HuIpimHm9x3?=
 =?us-ascii?Q?lpyNsgMYI4PAE9uFRU3ETnkax3A/mcz0uBdt5LvhEZdCVu+Bp4QgZ2IyV+1B?=
 =?us-ascii?Q?au8Tq5LvO9fa34vF7lq7TFCo9bfMph45jRbW0DsulroUPyIAsAPgN2tHGD1q?=
 =?us-ascii?Q?TJXjywAzp9kJY4EHhpK98hT34px0RRtc0/1jAr7YwArcK9DGS+vVvW++UhdY?=
 =?us-ascii?Q?d/jSotyBHYUOZRbzjhFEEqLL+JlHkJV7vmp1MW3gClaMQyjuU0Hydsa4YMD8?=
 =?us-ascii?Q?SpkvQ3Pw9clK6hODA/hjQezN1d2HN1oVBdWlbBcWcaVKa524MjOsBSm0lkR3?=
 =?us-ascii?Q?5LxvMcFYZuK3goy/7PBc0NobvRJpsDg56FcbtExaGJAZ5BO4rVGUerYTEsld?=
 =?us-ascii?Q?3jnZruA85Rwbq5ZgD0ZHrbNcthTYTJbZk2Z7LauV4P+xXZALkixdWgSbaQT1?=
 =?us-ascii?Q?Q652Le1GavbSze5zf1Hkw3Y22IkTVVIqBlrT9/NEAFrT4KVzVnW3weHPDbwv?=
 =?us-ascii?Q?0kdAlvDXTSXxyZ6xyaRiinTaIoBp+9M+b2ITev9DTf9p8sN4GCMDef1iMOcP?=
 =?us-ascii?Q?y0HmwDEeCjDuT/D2HiWyMha0rMJktoWqcH5QLeoOZHGQvBQEOdgq6lOkzcHC?=
 =?us-ascii?Q?94GQPeREWDUNM2LDEhFT/XrTvlhKOdu0lErq17CBMHCYHyXQHgutS5juM3uC?=
 =?us-ascii?Q?Ep4+5qLIjnCDzIrfX9tpIqNTYd6CVDs91s7pRikEZGxA4Yu1DEs4Wlt3pjo0?=
 =?us-ascii?Q?DedT78RyKR+FrQnM7VSxVAD6lbFtLTRSDFUWzM1OHwveUGEjSpJ388EnCAdq?=
 =?us-ascii?Q?dQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bd45423-6b15-4f37-38fe-08da8f5abdde
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 16:21:52.3351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: quvUqnbFyqp2TU1/IKQSO6cFR6Me+bJ88LR/VVhql1fi9CXTlPG47BTTRcrTbCeC0NTE1wOCMehrDs6MTE1Nh0VIE2+me8vgYZJOHUSItcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
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

