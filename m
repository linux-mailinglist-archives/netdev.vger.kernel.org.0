Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54DB555D6A7
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244947AbiF1ITs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244023AbiF1IS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:18:59 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2136.outbound.protection.outlook.com [40.107.212.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E5E2DA96;
        Tue, 28 Jun 2022 01:17:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+9r7svwppcMyaZDcOLPj/af/sORu80bJSiHWGmtPQIoqR6zChJXbuJYFOHEz7ve617KTw/oEd6zyivrHA2VKk2eKS6rrzGRhKaBm2QvPPrQ3m6ChbqhTwdOPXRKOn3K88C9XLcSmRO9eM0oqEH7A45GlfedwvMsCUBm80i3yWmIODblzyP/J1V2bJP6KXazFSNcln17Xx3OS3C0KgJQ41o2S3uJ1mbgYdmjkV0plhSnGjG7n/Pby5JUZhCIqRKWMOZ09B5SCeJAT9UPH+yxxKZ4sjIPbYBKtxVm/vrtcGHoHmYCylel48TxUfjBARKjGha1UeqlokOJSnhVfohNMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hz8l3dmutRiH5cPvPX48O7gaWF1rOkq/6lmdFFpPong=;
 b=LvLchjVQrAy1nBP9iilQdgB7MKeLQnIBee+iOfYxYDmkguYycqtAPzTqIxCmN3BgwyQYidVvW17mQN1fi8afTK+pYVVPemce89VCQUNe794d3eJbOjMirvVlNHM1Nmc8y35A3xLtcpijK/iiCsMjpth3Mvbpwm0rj/2/SBEVs/MnraB7QbChrHWUJY2O9VqchPnsH2bh9aveXsV7DtPJLZMiO6YR3wgh/pD7EXg4uO1DMDho69YhEj16od6kD79tiekD/mMdXPyFfLcM86DG00V5tqlxAykpkOVJCKf0oN80HHr+zNPh7NtNzcS+ZZqbEsLuin8QySQsD3cgAnznUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hz8l3dmutRiH5cPvPX48O7gaWF1rOkq/6lmdFFpPong=;
 b=aL9Aho+UPk/hczC6ucNDryasFUm5G0AN3GiFy0yB92/5Z8K/jz39mNb4trY19MN57CX3EwswlbgbFlmqLOBurj+TPAE1oLDZqHpOIs9Ksi7M7igwlSh94W6dRKqTND52J8f0INlgRGabFPtpRGk+CaieiLCohKBL9R3RlFQX7cc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5891.namprd10.prod.outlook.com
 (2603:10b6:a03:425::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 08:17:29 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 08:17:29 +0000
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
Subject: [PATCH v11 net-next 6/9] pinctrl: microchip-sgpio: add ability to be used in a non-mmio configuration
Date:   Tue, 28 Jun 2022 01:17:06 -0700
Message-Id: <20220628081709.829811-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628081709.829811-1-colin.foster@in-advantage.com>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0259.namprd04.prod.outlook.com
 (2603:10b6:303:88::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8217e62-8a55-4d6d-0726-08da58dea465
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5891:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6hOjN06Q8eGcSBps/Uk6Uky6CWZ0r5idDFiogJ7wKuucgC8ive2m3eiuiBJ80DZ3YJzU/U9Zpbq2PyH7ldB3rNPPGy9tqesc0Byk7yK3Xow5fcxhMRURw5bnAtffJyu30JBXiiuwqX92D5Do7KTeXGezM97jTODcCAqrvzIW4UrvNARu1d1mMuwOV9riHuSv2UcX5XmzmykoAoyHs6zQV4tm0A1+rvS7ZnLC9BAgRfrtsSj8/yp2ENQU3+9eTR5YNbMh7KWwO+yfwXWfV9wsqeWauuF+ulh9Xe0z352nLYN6ipTEViJGjnIrqfjEoAwLh+afiROTSwHdsht1NalBXZVS6rXYd6i49Qah8RPSbh4X/A3FqIQCnjhZXuwFA22+gLjt4cZSeOnmKYgrZDUbxXIz/GU7W/PAW/c0OByUGz1oJpb/tOX1GMGHXH/yaaazCW8hxpgnAjiHeibQax5L5vdpnJU1Pmd1cP63+4sIQhCvDHv+ktKeFFoaL6ACqgXGa4KRcz3STHap3YExLNdmY7qwpM7WKEC7MHFq3zcsakOmu08XHZfOarDLqVlSx2WPq6HxJO0hCJ5N0L3R5zz06YBymWjxmLmuaVQlARxE+dCqtJvY2+ZpyfJv9WYmoRoCN6XvOYfB+FtKEMUndbfQ0Jjv8xJz4RMPq60CT0go9a/D4QH1BGWxqZ0jcyYOpeIpTjP79XIl0MmqpZZjZ067Rst3IzTo+IJjQquRD0ULw6kH3zSQQZ0I8Q8b3G9CpYQ7DgA08ndNEkL3qX9tvCihG4YL0kLJ10DS0BAlttojT3I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39840400004)(376002)(136003)(36756003)(38100700002)(6512007)(6666004)(41300700001)(38350700002)(44832011)(478600001)(8676002)(4326008)(2616005)(66946007)(66556008)(66476007)(6506007)(2906002)(54906003)(86362001)(1076003)(6486002)(8936002)(186003)(5660300002)(7416002)(316002)(83380400001)(26005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YWPC9TAijY7IJjxCgunvFV/qko5w38UfdPk+Pz+yWdXYMWLybxJcrmza1iHT?=
 =?us-ascii?Q?hOtYQn9nSvaBxG5MFu6CXowaJ5LhVA+3oE4gOAU3I6nAjml6X8W0eDZigQjE?=
 =?us-ascii?Q?yBv31x8/RJPELDIgS7UD3RJuMSIkRl5NCouQaWwivb2dxNp7MfxUly6MtrlX?=
 =?us-ascii?Q?GGFOoMPR2DPKcgMBMnSxcGxrNFi2rkT5/ZHUUYBLF9Czgar0grWsUpMbZw4d?=
 =?us-ascii?Q?BRhF6CUq8a3K2a6W/zRmmOpuUJob8yQ7eHFdrEJLzISwCTXZADQSj/0FbtPC?=
 =?us-ascii?Q?j4/w6WSUtho3y/x/PqioBT6zvyKBVWs2BiiodbMD7pDoZ1EVzerAmeBSySmW?=
 =?us-ascii?Q?yOH7lijkqMP4O3uDuP9gflSPyn67mjvuG5KJmmATIqVIK2je44VvhwdJVrMu?=
 =?us-ascii?Q?B3ag3rJ5bN7TX6hGEOo6mdWkIGo2+2LnXP72vNFnvlSRBjqKosJv9ov1MXbX?=
 =?us-ascii?Q?kUYEvX/qRxqYR/JG7hTya2JAyg12WoM6bQ0+11co4+aJahCDADc1uuCgChPe?=
 =?us-ascii?Q?LmnT93iITcxb9Zp8ECeaWfTdhgellKsVROPAJ5fY/n9h26y5EyC4Z7WNEAxH?=
 =?us-ascii?Q?qrfXNGGjXnMGpK4QOV2JtdsKKm2ZquG9YbNNQ5qBEypXs9FJ0WH9lldc3okk?=
 =?us-ascii?Q?KZcjJDDp4X1kOkirOJD8WWp5vPQwaNRmnKB/ouaa6S+GJTwhjCbxspsxDSiw?=
 =?us-ascii?Q?Lm9UHK3Tz4vPNbmNtskMOtTSd0jXa22n/KoN4weuGWJlJla984UIWayK3Khs?=
 =?us-ascii?Q?mxMzzt2qXkC8FQNVwT+4GeL0v/sPdnaSDTajztoQmcC622M1YTYiXca7xMuY?=
 =?us-ascii?Q?AZK0Uq5souc35o8uD99QuCdJNLu5dVpLKs7BcuwWS9xOjpZLIBj22UnvqAbA?=
 =?us-ascii?Q?3QTYJHmklC+lTK/f5m1xt0o/VJV/2Obvgd69obhcqMXmjxpseOSDYQwAe1jZ?=
 =?us-ascii?Q?NaHtHyIcyfwiIKGti5VuohXazkV9vGICL5LCyKYfYPo0z/3NCThVMExlfFXg?=
 =?us-ascii?Q?1fX6Rfw2iYnLI8hOQX7ITCrEdBVSlER9NZ+1+SD3wrF1RSpm4wUXR5CbLr/C?=
 =?us-ascii?Q?saWvr27eyY/7tPM0lGj+XowTthGoFN10CsK/k41mYj2G+xOtLET6IxrVpBSD?=
 =?us-ascii?Q?zjuftpOj3EJnwjPVahcn+pvbYn7uJ9yZF1Xm3eO6xNpHrqKsldaiu4U+mrSk?=
 =?us-ascii?Q?gpDn75xXeqmscHzagukREXXcq+wGFfdQ98f3ivJ1we7IwG4hXiaCllhQUOVt?=
 =?us-ascii?Q?0dN3AHox/on8bTIwIb+9L3e4uDn68CBFuBtQ2d25C2mLR26hTZgYF4sxFGN/?=
 =?us-ascii?Q?2Gax7M94HSWz9Hllqkt+M4eBRgFKEOppSz6hvRNGTZ6ZoAZu+Vt8RhlDT2iL?=
 =?us-ascii?Q?Nfh1VZKZU+A+v1mNRvWOnwRsReBMeSdGpyf7Y7CLJSdIiWdogkEjkgoIiP3i?=
 =?us-ascii?Q?W50SJSQFPotc5OhXov3nwBFZuT49M3DEIQdD+wTCT7TP4Z6c+ruHr28+TjKZ?=
 =?us-ascii?Q?GZg5jzo9UT963oyoWchNUN7pUXITurzJZKcIRolbKT1UQfC6a4kHvV45u3RX?=
 =?us-ascii?Q?5tL2PitiqlS6NHXXj0PpJKBd1cIw3poXar4DWzhVAdNFfWerrR0h01zJM0J/?=
 =?us-ascii?Q?7Q=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8217e62-8a55-4d6d-0726-08da58dea465
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 08:17:29.2289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4DWB10UyAEavLbVlBZh3A7MUHID1TybGlfalNkuNYrZFgDN9pnI6AjN5ZIXawQl4M1s7E94Sm+Mg0y5xlC0CVA/1K5rzAiuhi0krWieL/vM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5891
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
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
index 47b479c1fb7c..c924605f9d03 100644
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
+	priv->regs = ocelot_platform_init_regmap_from_resource(pdev, 0,
+							       &regmap_config);
 	if (IS_ERR(priv->regs))
 		return PTR_ERR(priv->regs);
 
@@ -1013,3 +1010,4 @@ builtin_platform_driver(microchip_sgpio_pinctrl_driver);
 
 MODULE_DESCRIPTION("Microchip SGPIO Pinctrl Driver");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(MFD_OCELOT);
-- 
2.25.1

