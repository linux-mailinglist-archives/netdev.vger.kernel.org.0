Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94921546C0C
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347362AbiFJR5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350243AbiFJR5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:57:17 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2121.outbound.protection.outlook.com [40.107.223.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E999E9399C;
        Fri, 10 Jun 2022 10:57:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YoGWJqU8fcO3WbZbtVWc9Qdn8PLZNM6+NYJWoV+FnEGQTm2OFFrGcBKHPze4PEtEtz6hBRVSQttG/Aj9phq8W4fXIl3M8u/v7joEYbZF9/TUaorpjuBdBAoLYXXuc6IIxguNSIb1HMupPVajuFaWR54y6nDUFt7lTho0MdQT9i0XiPf3husVbEUgMscAPyMOb+fnoMFQMMvfiC0vu0dbMriwLvGPU85tHDHEOsb3VQWHyvS/Mjbm49KCZclwIWnDYwG9fePaiWayhXSH5F+wL6EDry0RaHcOku2WBMeZAUFL6vkK33Gc+uH+nep6fh8Q5N8KiHQCGZ/WM41z8Zj4BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6B4X2S6ByfrNayHTGMhOyw2kSy23jsOuPxVkk6Em5g=;
 b=aGA3PMZEH5Obnj1FUEnx/N6nkoIcPkZqg++2CuAjg8RtJDPUh96iVqbYtjOo7L6SQ8qGsBzfZrI+xaLW3fop8dPPtiqKsMKRhvO1rjqfh/e6nx380Zey4W4sBvKJ5TEEjKLLNbjUbLQpS+njn69VS4P5FZlQRXGuSmSbJx6MDZ/FWfjXsvO6oWql0F+NdHIh58CuTreKT/I67gzrRjtAkZH3wprT3hIAxYBxZ1IPcSxmnKGbVqT5v1G8xbp9tgGxuZd6ZYiS/wUVamTcRjWVWVnaAGgB5d6VNP2uSd5VWQX3MjVoMDskvuABuTVxNQ5JIcJ85q6Xz2bJZz7oyAZ7HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6B4X2S6ByfrNayHTGMhOyw2kSy23jsOuPxVkk6Em5g=;
 b=UIuScHOstBdZ9PqoV0WdqXWLE0g3JapJqp89GJgAyXpXidRvCiW7oAagL6+NaDa7rmKGj7AX+VJPhWOL4k+IOMLqmx6BMoAONZe61/8WLS3IvBTiZ5+w0CZhXujgiDJAK0XqmAeVPwpmDbU1iJ47qOEs+XL/1TjJnNq5si1yxxc=
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
Subject: [PATCH v9 net-next 4/7] pinctrl: microchip-sgpio: add ability to be used in a non-mmio configuration
Date:   Fri, 10 Jun 2022 10:56:52 -0700
Message-Id: <20220610175655.776153-5-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 33cd7c9f-960e-471c-5336-08da4b0aa2f6
X-MS-TrafficTypeDiagnostic: DM6PR10MB3356:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB33565B95197749BA18542DF1A4A69@DM6PR10MB3356.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MJw36KAeSgqSXE9yXxY9Wc/vT9jc1zKWpmfNVaJUghr17pFfNI1JTXWr4ZpqSNiDx7qzEpnVrrH5Y4h9mrNeutLmw6qNONSZwCxMBzESz6OLvOG45Ktno6JEoHwCXXuTYz92CMJZWsBDyShuLxFtuPn50fOQkhqPbf2YOVWgxVS2sYEKWpezUP8YVJnTESubPZTlRHjBspySsm8WrsuMn2qRb7EeM/xjuIK5ZHmcJ9YSCVaYi/oLVmiDbWr6I9wGDCOr7tfTklQ+wQtZBCbNKEXIWVx+KsAZ2yl8vbQz3EYrnkBPBJbrVY0yigBouqNHYOPWedyN0hjIKgvI4NlJ0sC5b0Z2Zkntbz1X1RfYIxyLusLGQpxN+eVEfPs+pz3p6w+n/Bns+woL6uJPq3j6a8eEvFyrOWXJ97ENE75gVEnpuE15ad8uFOLH5VHH+iFoCOP+o76jF6Nn6+oKVVgCkRcwkupG4QMsxP3T2mjL/Hqbtvknk9bysx7FwxZE/DKa8zkc2no1HpUSYLNsTQCCyZh2F5vATFj4QeFlmx4B89lnZIfFlVS/viUVkAJDPVJv6LP0zM3ecuKU/uKUbyhcN6vxpsDrKL0raHIZk5p0eAye2xugwcY7j8s0CZje1HXk6Va/9lNszvvwrQ0INuPUvA4FYdEBseK7BOIwonozzElybJxc5CTqPIsjvQFtiKn2YGR+fntErY9a0t4vYXyjQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(366004)(396003)(136003)(39830400003)(1076003)(54906003)(316002)(4326008)(52116002)(8676002)(2616005)(86362001)(508600001)(6512007)(26005)(6506007)(6666004)(41300700001)(6486002)(186003)(83380400001)(2906002)(38350700002)(44832011)(8936002)(36756003)(38100700002)(66556008)(66946007)(66476007)(7416002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NtKH7vyOR6OjMUT0bRzI9iRDUo7v7SFHSMF91ZapKL836Xn9ui/VHeuf1wQD?=
 =?us-ascii?Q?E/XXcxgEGAu2lzQODVoKBFuE9AG9dfn35NsCf6++bRPMDrFsVz2xeZwjjlRc?=
 =?us-ascii?Q?2a91UXAt7BTqj5zqUUY7vYN5bA7rYkUk5410188Z+d7dWltg1kgo7IKT3pWP?=
 =?us-ascii?Q?lZi/VAkBfDfiSyxpFqa/fdhIsM4g0boiGnplF1YrKXYUjm3gVyG2UhKUgvbo?=
 =?us-ascii?Q?+CL/wSU2SCVWzzRLR25VjJ4/0GsVIw6svKgDylfvQ5f9oWZHpBQiH2KN66On?=
 =?us-ascii?Q?l7CsMcK0yHMjM6qw/QI79K1JPQzTFo7XivBZo0tdtN3CXlNr3LP9iiMhkvTX?=
 =?us-ascii?Q?xmu6Ki7Rf/YTT6srhx2Xqp9Jh3dfosNNYrGZbVTRnQ+xkpXUIu+Y4kSs1WIc?=
 =?us-ascii?Q?kvjrRqBnpst17fASOJmxPPgKirbZsxdsteya8tXcafxbQ8eF/tSJ9rgPi3IG?=
 =?us-ascii?Q?EApbpjX4W703C09TTT8+ZSQjDMrBnN5wRvH0RJTtYYFdQWgIvLsxv8wPBD/U?=
 =?us-ascii?Q?JnuyG3/prDE7wlNjKeN3jJBn74PP6aQwdyZRi6I2nEvYmCCWg37WhUsudVqo?=
 =?us-ascii?Q?FzaxabV59WoeAvkSrxBHKoYHFVyNoKkCt3isLHazzwTA7E3d3jDOAAX2cwCJ?=
 =?us-ascii?Q?ELlUdOXEeUa0QftJjWVJ8Ce7wLFYwX5o5rU9Q+OLs+3Xdv5xr8mYW+J9WpR3?=
 =?us-ascii?Q?U+0TJnKU+bQutbj/SE/Xyy6cD5JUjxwqG3d/FGewjsDTTh/XeiWNtOIO9oHI?=
 =?us-ascii?Q?vN1zuPnh4+09xR+0hhVZfbFaHoOckPN0jW9hFHorZqPxQKsFib1HeHETzf8l?=
 =?us-ascii?Q?w8QtxGDvU5dseR4Krb0bdiq+nrWUYCbzNSUxF0Rbij/Y0YcUOrRdnExB9R4k?=
 =?us-ascii?Q?Dfaa07Nl9XFYex86JqoeRVPVhKdMUTOM1prMpTZVsh6sGfMf678mYpFZ3uRd?=
 =?us-ascii?Q?qHJzYoPWikNdjqmn8t4IUabWLtJxHYJKiFdMAqxS0hhUfq/xSTTtsxhm9Vmi?=
 =?us-ascii?Q?F+9HLDOe1ZVDNX/mn1btQ4ufewNyDXG0rW5EUU81aexweh3D8rqGqcjMEo38?=
 =?us-ascii?Q?VujhSYptz5iGAGF+WBfYoE/e65YrK3CD4oMASubKAjSlVtoyI+/1clLSgPqe?=
 =?us-ascii?Q?iRaatVWczFJv+ccppTD1eiwo/EIaiHecIRCKDOkTQlQr6X6kEAzvgWr4zKix?=
 =?us-ascii?Q?/Y49ysoOOHw7jbdxPF7Sen0q7uHC7tsmwZLHY3fheoHWt/eP7sCssaFYKhMw?=
 =?us-ascii?Q?vZTNJJEI3o9UpVE++3l6XjdE7JJKhcQ+Lq08ukLFPvaoL6W0qO1bw+KVcJRB?=
 =?us-ascii?Q?dwZIlQpEB9H2sq3Kyf/vI3HTDELKsC5awZ2di0yjBGtBe/zdY8SHsXOahYpQ?=
 =?us-ascii?Q?4wejBOgQv4nKQwmzD3HIP5zIrR4YxFm/S9rGSvuLawRBP9o6WVukoYxZkQR5?=
 =?us-ascii?Q?jR/cYJVG1KeKK1+Vr7UiHtOA7YXDglnAUmBpfmbBgOdU/+ciss8l65zrbm+O?=
 =?us-ascii?Q?an283oVtUiDiWCIF9wxPhqLn0ZF7VTfask7OT1NYlVdCAjzLYr9vdjfRhUeY?=
 =?us-ascii?Q?+Cu6GaEpgGF/79bmkeVMGpxgp6ju/YF/jwhvelOZ/yKUBcGoLwolvTBODe0/?=
 =?us-ascii?Q?+VvMJ9GyLRe8XYRzU2hRhVdHRsVaHkKhmgtmgB+kuo3somRgcncaJl8ue3dh?=
 =?us-ascii?Q?wL8AkNWs8sMO42J5sHz3yB/6Gv+gUzX6DS0rgukLGf4yQ/uvAKFPpfywTowA?=
 =?us-ascii?Q?X8LaJeFKOFWctoptW3hO6uiTDs9Krx0q0ggkWe9nz6eUw2rcy2VC?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33cd7c9f-960e-471c-5336-08da4b0aa2f6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 17:57:08.4967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7yAc734C0BsIgdymLflxeJkCSHV2Q+mGNYpZYJ24fHIpIN/wwf9ukqqPaj8ODKbFK932l9YgG5jeIGft0OaHp63VwRYpt2WLSMcJErXItKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3356
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
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
index 6f55bf7d5e05..25fe57a0c26e 100644
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
@@ -937,11 +937,8 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(regs))
-		return PTR_ERR(regs);
-
-	priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
+	ocelot_platform_init_regmap_from_resource(pdev, 0, &priv->regs, NULL,
+						  &regmap_config);
 	if (IS_ERR(priv->regs))
 		return PTR_ERR(priv->regs);
 
-- 
2.25.1

