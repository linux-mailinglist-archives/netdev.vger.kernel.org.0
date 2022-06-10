Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A13546E59
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 22:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350745AbiFJUZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 16:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350750AbiFJUYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 16:24:37 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2093.outbound.protection.outlook.com [40.107.94.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499F630E755;
        Fri, 10 Jun 2022 13:23:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZuRTmkiy5I6VsByaeu0ZKBFD0v+KnvrMPO4aRspKiGf17aaepxKdapV+GemsriCDU0mzyexfqdFwJTCXGnfxNTD1HbLbZYt2HQhDw2zJij/K92zy5ejS9ltNk8nwsUDN5pbvW2QNZwKo55hSOojlebIfNV1ThYkziBt+eFhXGq3/qfdkHpsht5mvMSwAlq4Gj7PDaaiJX835oTuL8fwrkUo8AUJ2hU8dW5ETSxUjAvv1KwGxXP73+kMeGKtm1C5lVQluX15PApxrAhx3KIXscFj6uzuHlLkR9MksrgvYAGiPC198/o0SMIcx/N/J5OAZNISltxVR9ypoBQTJLNdvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6B4X2S6ByfrNayHTGMhOyw2kSy23jsOuPxVkk6Em5g=;
 b=jANdFjGSPfFXgVFgC9AA6S1Ao6TmhTWaUq+UwFR8CbxR2VFu6IPLCUzoD0IusQ8m3io6Bm+zaUByYDolsd97xCGxBdvbrR9HNl/1ewuRMaYGSIl2PIMj9PtnwFmMpSXeiScUO/e43vyrbBfMl0y/le8ZSgPhVniCeQA3nQ36+i3KJ2A7GwlpzSrZvRrwr9C3O+PrJ3rVijbgShqF6Vc8G9MyR2udpjoURbNXsGHE0A5N4WbV9CVWX4uzDN4P4rv4nD1R2sP0DYda4gDLZZwUDNRbhhXJ0mDCsRT6ylzicJl2FyQEGR2Q8cukh632yDY7Q4KV0/vGWWGPTU01r46cyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6B4X2S6ByfrNayHTGMhOyw2kSy23jsOuPxVkk6Em5g=;
 b=sU5eDW69yUZpmroQOr0KCVD+4cD1oSQkPXDaAn4jr2LOSDgSQkB861MSvb60kpugpFbmk2RVUnUk6xnuxYDT1V1PwzRaIh1kRQPsJvuLnyCqwVycppu0JfKdi7K4tFqQFVbDB/eWQFi6vjZiBhXSVmbQSCwpp1CFXtLUIUy88FU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1629.namprd10.prod.outlook.com
 (2603:10b6:301:9::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 20:23:48 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Fri, 10 Jun 2022
 20:23:48 +0000
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
Subject: [PATCH v10 net-next 4/7] pinctrl: microchip-sgpio: add ability to be used in a non-mmio configuration
Date:   Fri, 10 Jun 2022 13:23:27 -0700
Message-Id: <20220610202330.799510-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610202330.799510-1-colin.foster@in-advantage.com>
References: <20220610202330.799510-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0246.namprd04.prod.outlook.com
 (2603:10b6:303:88::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86cc6a30-447d-42b1-f675-08da4b1f205d
X-MS-TrafficTypeDiagnostic: MWHPR10MB1629:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB16295E8BCE1C9D5EED655DC0A4A69@MWHPR10MB1629.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aCf8yudlVX5wrzJhaKPX/IJJDn23OAU0a7+hsHK0PiVl9Kt05ZI6bXAEHzCIlndqHtrrPYmVKaxTNZG5NbhEkD21G7R1O++dRbAuraLYAuSKmBWPzu1e5/XICbDMIcrKfbdYtGk/pSNlg6YXZwOFsJtIXlsFL2kDq5EsMkXa/AgE6+oh9wzaMmMyEXnMkzBMYBjY5lsUdVkbJmyccXoKMFF9TvBC/m+GitlCTC+lhOizayB43hq+NHsVQ6Xx7PrTwx29gCxac+9Io8YSySUslglWVdYQSZvHdqyBkPzDHB9QkmxdYTZMgQWHNQncsaSITKapuYTpq2q+sTkqMWN+dcD0LQt5DMQKslb7yzZOp2HILStmOf/jmrpjD6R+aU7lKBWerdzC7iIHyCFE6xAN2nzG8c0i5conu5pRh7Dylc/w6M+D1rj2VtwWCNSMLCm05uw6eATGcdCkZZUkhlfHz/ckYBPWm9/0B2uCTYLc76e1dp8L6fv+aitSMSqKO/+LLYuUWHJXwvnSjGDaKVIW01VuTee3bXJVk99bPQF5QyRy+R7ovlnS8T1YO73/gJ46xb1pbo1zbGOgQWxhmQgtIy1/ug+10pPZcprVOtGqEZ5t1zlGEIYXdAtUMyQUxT8aC069Da8dfpLuzw8G/ozfUp95uMHI8DJmPWpyH0Zky9BCeRdHygtBC62gqO07XNy3Zyor1sF82mujUZ5b/pWLqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39830400003)(396003)(366004)(346002)(316002)(83380400001)(2616005)(2906002)(1076003)(6486002)(54906003)(8936002)(36756003)(6666004)(52116002)(6512007)(6506007)(26005)(186003)(41300700001)(86362001)(44832011)(66556008)(66476007)(38100700002)(38350700002)(5660300002)(4326008)(7416002)(8676002)(508600001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5FKofilow+BUxlGaq/p+vuh3MasfmAMEClKF3ZgwDPdxbZQEcWEK/X+sS/0n?=
 =?us-ascii?Q?t5Pal+BZfVt2QH3cjrF/2ExR13TR7eeRn0MCEHyo/eAcCAAXgPqGPJ91hlBm?=
 =?us-ascii?Q?pR5pvgEjlv7qGwSmxCeHelhvJ+uAXVBB7+GreFfCviViabrehjdFCcQc1T23?=
 =?us-ascii?Q?nHaDmdVm1wJ2wzi2tjsJ1oWHqaEkJbGUbXKRpraMmdMPbSShOirEq4LjBT2y?=
 =?us-ascii?Q?grywntFDXFB/4QDiaqQJk6nT7wfwT4MtxwXSvODSo665YW9Brj7UmskjSQQt?=
 =?us-ascii?Q?UL1dFQyu+SkSxgO9I9hWVwh738doNcDn4OMAqWCDGR1UP13prDLwynOxeCDF?=
 =?us-ascii?Q?4LpuTR1e8zVrc+MMXoVz17dYBYTAD7iYfyf2df94J3lxb4B40aOlchk+wf/T?=
 =?us-ascii?Q?DK+biNe8Pvd41I83Ux1PVa1c9Rj5Dcomq/GA01QKXVEhnxNVNbhSN3/ef9Td?=
 =?us-ascii?Q?CRrg/taHuaRkCgT8T/BZg447iffveIUpjZelnVMIpZN+67LcWE02DL8y3E9m?=
 =?us-ascii?Q?/34FJsdSFsGJFtL0LHApQybbeKRfr5HYFny4P4IAFa1yNij/lmc4Vac1DcL1?=
 =?us-ascii?Q?VCps0ZURVZCuyHZkZ7A7cYhS9wKUBs1UBcVXn3Qtv+A6CR0CS2cCWtVVsmQP?=
 =?us-ascii?Q?i1nKHRd9BWI+lI1ujwCKzv65nzI5IwOGLtKFBDA6bA/a+HwGk8Rgvo96XBAi?=
 =?us-ascii?Q?yF/YL1mC4pzHve6Lpm5NO+1+8Cf3QXfqUpatAmbhagUuRzrFVXSEWH68sog0?=
 =?us-ascii?Q?hXItGSM8ysmvL2tJwbugBCcbLj6tuNKn9MXme5whzOUZ2DsWF6ZkoFVXlzPq?=
 =?us-ascii?Q?UPuBZwLfE55TkCOMaPR65gwHWTbNTtVh4X5akeEgztAlmUym1SiqV6JZ9/NY?=
 =?us-ascii?Q?8cQQ6ijDplORqmC1dVG37bQ5Hr4IgGHMZxAAsozoK8+Zmyxr8q7EpdeZ4hkx?=
 =?us-ascii?Q?Jne9s7iajx02oKyVgk9Ifan1XdTvcex66VKF0lzKjLbcHzBR+ajOQoAuYD8B?=
 =?us-ascii?Q?UpdKpRSaBim/EO6jwatA7Yr/6ZhrrvyEQSOFfJ5co1Rcp+fGn55+c7KwrbBX?=
 =?us-ascii?Q?wrVrVBl2K6Wse49ar/hD23HmtrIFvEADu+TMy0lpmdWVz73g04h9Pu6mE7I2?=
 =?us-ascii?Q?eSdTVD7Qg2VoMOQhw2KLFrqkDUXSDdgdfwN/BU59gwXd5vUt9z+zM/3eb6pm?=
 =?us-ascii?Q?f8jnZ6MCN79heKqriz/oQhswOmkDFQy3BXEKvFOtaPcTz9plYnyZd9c2epzp?=
 =?us-ascii?Q?B4DZqHAMmRJHOecS5t96m9W4Y4pHTfpTuOeQhiUG0t2AF2MxHzW1cuuEFx6c?=
 =?us-ascii?Q?GCH8GUFOQA0A2pz3q2AdAArrEmqINFQkH5Cp3k0z04oHq89pd2Fd7L+w34/Q?=
 =?us-ascii?Q?iIQzF+S0l6gzYcpzutEWJmBYSWGqHLx1OxORmDAN1pkpcyuBgdwt+zjH70lV?=
 =?us-ascii?Q?As+C+Z1aUVsN4yu8XbcTZizF+QH+uicLpI+0dNHhJ/TBd00Lo8omuIKv2Yng?=
 =?us-ascii?Q?BjJ0D79EuhWRXfnPpaTPqIyW/XJ9qCyPW8UfGXyxgBgL36uTPFZc1sn0EXYJ?=
 =?us-ascii?Q?u/nBuo05p+yKvseV9MLM5eGK2ofu5n1DqvDXK2jvSSxPBuKKh5leiOnrNE2t?=
 =?us-ascii?Q?oiHui3l84vSfbX/wT8qGNl/J6uNxm0NuBjeVAMCRJqR+4eK39ORfVyN+17ni?=
 =?us-ascii?Q?pJdgpaNJHWVbIGn4BSuYmLeOSvtpkYif591OShthVlYsT0sHiniHL3FVmcMw?=
 =?us-ascii?Q?1CBMD40ZSAD/wD+YEKG9ET3F703RFwDpyAs0pyT7Tm5hGCowqMTT?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86cc6a30-447d-42b1-f675-08da4b1f205d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 20:23:48.7788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8aDeXPntdFJRRrRX+SJ+yMUENjVQqyxSrZOrOgzzcrmDSd2d5feab1qHnujORMzowRQ24ZBeP2roYWfNTw/4lfNaV+mvrnkS8BbibeFsVa0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1629
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

