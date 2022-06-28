Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765BB55D814
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244829AbiF1ITl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243947AbiF1IS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:18:58 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2136.outbound.protection.outlook.com [40.107.212.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5452D1F5;
        Tue, 28 Jun 2022 01:17:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1s44+BipLKdrqut1FOUESR8S0v269HR7qn0m2JfMCejN43qvpTnjUp2Pg9m2gcOYpxpu3T0MZ0SEyhRqsDanZwW7BmDGiJA/CwBpXiz2THubBq7xqx3Jxp1QCRd1iv+6bypK7F0XwyQcsvJ4XJ79FHFPDutkqTVwZ6XwB28JrlDP4oqIjuIdSEJVBDYVTeawuXs60hvOmqH8AxhHKadPZjqTCdd8Ncd7jVCWRAjQ15CRD9sYxrb6gGSM0Uzb+35t1YponmkMFkqPi6d/HyoM32Kw+Yzxw8FJxxg0fF4rflCx3rwr2jLsyKA34QhsMzQmfCD8ca5XRT9ALQRkeyvVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vj88WRfFsVodv5LPCLp1LsJWC/szl038VLhyrxtp6Aw=;
 b=eN3TfcMg8ecB9nYE+OhbZBjDTX9uw5kGJWxBw326jLhghP2c3qFai/d/n3ngSI73m1DGqGvAKiP9PMX/ywx1a0BD+22iFXBzWPBH6wbTg6BF/fKcRKFcHLgircUnv0N4Oto/M11zYyqo3kRl+6DclLG5uUEFC6GP7r4G1q7+GM7USl8Tuhb93YkyMGhGdILsPMMO/JX3lmsWPiULlgNVSqmHMrOdNBgyTtjXZJVXfya4Jox7L7D2zcLMhDYcMc9pf3QFtPcT3K0H/panTaPnSV+8vNv3tJDnyOf1WfKlhulp2Qhe55j4kgYtJZtPTUw31Nnv37YU+0MGGOdnXtKb+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vj88WRfFsVodv5LPCLp1LsJWC/szl038VLhyrxtp6Aw=;
 b=OYkKd/WoqEbzWXb70q5j68xdxMgTtujeEZaER9IfiCcHLfIDBYT5CF3QXo7QRO9i5LEn6zafODzjl+SNm2PoY6TfEjsbKpgAaqAytisZGyS3xJwa/Mn4p2Pn36+nx4vTfSXqWi5/NnEhqD+Ww7fDzM1PanHfUpVnS2aWPNobu3A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5891.namprd10.prod.outlook.com
 (2603:10b6:a03:425::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 08:17:28 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 08:17:28 +0000
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
Subject: [PATCH v11 net-next 4/9] pinctrl: ocelot: add ability to be used in a non-mmio configuration
Date:   Tue, 28 Jun 2022 01:17:04 -0700
Message-Id: <20220628081709.829811-5-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: d04a2e34-2d5d-44b2-89c1-08da58dea3a1
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5891:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N0Z+mMToR2oZeYXQ9gEGThd6u5Y6+KS3XN74Vjq3SRi++7MdJ2LVI28Oa32QrTHv0f8L+DBTwDea7Z0i18K+vy32V2YDSKQbE5Z9EPIjcpW1uDQv5/JHaIV83broowQNQ8filwUiWob7T6mwPt1w+M6CCfWRxHhAS9jCu+Adk4kzAw3SLlD2N8ZhSDsASaCWLMDu6QEhsxAAKIkLPl9OQzUBop8zu7x5og6dzGr4YeRwPpDOOXrIpUJKIv405gDRn05cHZhU0duJBcesOPgLvP8VVI3yyzmc4xhQO9D59cfzc20IfFG7yrG5Lgx3cQkGy7IpDlRbWznXdmCjdSAx+H278DJRVB7C1WbfrVaVtwsPfMWaY+X3hQBSWRbiSSbzCIFJa4Stax0Tkey33Y0Wzt0SJ+jKU9iNXMPuKtOgB98YkR+e4hBa9Qsxp33wOyCHa3YaJ27NzU9HTW9MLPHNlkzRAWbQ9JFbMI3bmfbQVJbpr+Y39fygNE006X2jffR0EyMh5Kd1FTtFD9+G0eDkiLzthnvlBSFXoKuRPotBbNuUXCrt8fvka9x8ajH+yEsKBbujs3kHvCJ4P69X5qVlg2NZy5toybHkehalmGxWfZfOGfmxe+/AXuMTo7eYwOEp7M3IIP1dmetoxAewp4Hhmh37ayDgvM26Pp0K+DnQ9hHKOZrrDfpFmDZkdbz8JhBgnVqu3ZmH7pC89YpFB1N+TK96FGovPxzVFbelO1MeovkVVO0aBhgxkj6dGPYsn58d0yXTMBr+ULPLm/U6lht047cPe+G2/ockYfY8EQpW9+4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39840400004)(376002)(136003)(36756003)(38100700002)(6512007)(6666004)(41300700001)(38350700002)(44832011)(478600001)(8676002)(4326008)(2616005)(66946007)(66556008)(66476007)(6506007)(2906002)(54906003)(86362001)(1076003)(6486002)(8936002)(186003)(5660300002)(7416002)(316002)(83380400001)(26005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6TiD9pnTU9Fiv4BVVdWXElLgfcWzUl1v/S1FktuBwtstw7NOtqxtCPZJA6fE?=
 =?us-ascii?Q?nGjZc7lnfICJYPazM04k54kY18p9nfWXdmVOXWMJgdaLhONkXkWS9CXg7skq?=
 =?us-ascii?Q?2evzmXYZQRmCtN61/kX5sjot4cljSt2/QN5/cpDYn7Gaq6jHfFlfZMDqVJoa?=
 =?us-ascii?Q?YL0ChRIAWWVkxLBODgIkGz4Qa6Qg8hpAQuIuB58Wiigapc7ow3k1LHr0cnd7?=
 =?us-ascii?Q?IbZECPDLWGvbSVhA9OMiisAZHsqQg767QdLgm/rpR2AkpS4i5S7df1V6XH58?=
 =?us-ascii?Q?FIuH31CrpC8Bmj/TLfcVSn1M1l6LRAsbk4yBwEifxMldmAw36Rmmroo3yAfR?=
 =?us-ascii?Q?LQEmH+WjwIPhEy5W5pJpKy7kXlZFoqQ4qp0n2+3tN/Hw63o6XkL5FvSR/R1v?=
 =?us-ascii?Q?Va0+GTsaGhYsGn5BO2VpxgjTJRiEp6UqL3c6g9aC69YBEG+kZNpCOuvRhbiB?=
 =?us-ascii?Q?l/lvDRZhsf90HXMc0sOoDQv4xTeJcAHzjnAG6YX79yUVTAcBfn1IwO5qp8+2?=
 =?us-ascii?Q?ZAlMJ1a2hHyXRulL2hw3w1nO61CAbslUIJ2Oicrqy2TV0YcubvQmxTUNHdK8?=
 =?us-ascii?Q?t3TzWSLHC03T6WQVR2DWroAp6ZfbXLq8s62yIjYygwddcSMKeFnzYLzfPU2O?=
 =?us-ascii?Q?+Rai6+NBgW7Ta90k9N3Re3Ye/FPtdR6nHJ8RngLPqIdj+n/KWdmT6x141vSs?=
 =?us-ascii?Q?Mvo0EORXwzpOfavRRJz6/GC+K+p6KQ4e8/h2PJXnvMMYJBCSapSWX5kDgIrP?=
 =?us-ascii?Q?Zj1rH8DHOnovW6QUlKT05j490ACuBCkUlTGkZSYRzNDEb5FE0V7dVEzfzRwy?=
 =?us-ascii?Q?vnRv2eqc5+6lkewGA6ebkrBbTnzkq3cFYjFR8j3rjO68uXt7BGn/BcaHla6j?=
 =?us-ascii?Q?P5oAGmZ+lQxVH/aNHQS5z8rTFv9zyO9A8ML5h2w7+8nYq2+e97RqlwyTCetw?=
 =?us-ascii?Q?nBH0HRRdOm+xLirBwDmkQ71M+35PvWLyfEMwamJGDd9zRRfJfAuRGBLzjyMh?=
 =?us-ascii?Q?0vQe3k+QQyer0wFU/bbJhkS/qCXM1EC/0T9GY6ydwMQf2ghrzlOz78QPXaNh?=
 =?us-ascii?Q?Jb5zhQHor1I9WrrHkUBHGdCXKX+A5oERM/eI/RTBwZsLxhSUzN0nZAJPrlmQ?=
 =?us-ascii?Q?VE6Sa+XEVEnj4DKjn3F/eKO1w0YS7pl86ijT6ipED9iFLeyxoK3dA2//4qrp?=
 =?us-ascii?Q?z2BB2ODa1gmzIdY9imcoNgs+Tv3wztPM7oC4SwkWq3mG/6Dj7qpIUySUaacx?=
 =?us-ascii?Q?CYkzG7x8zHORPYgZ6NIQmjpHkjJHgv+Ba9dXoERXqKmAqMnPPuqEq8PoJhHY?=
 =?us-ascii?Q?wvknnvtbZTNRdSpZzZQHNCVLOFa98/w7buF9XHVWIYicz6R7i4E0a3MUALlo?=
 =?us-ascii?Q?MeFIUtt1TdIeVb7O/X5d+hyy160nZVvOCRkY8NUoDunbDp19P99tuoVfApnn?=
 =?us-ascii?Q?pDyD7RQLpjzSdQ4uU1VKOFrnUF9MJc/8F6IbyL/qVm5F9wmn4Xfb3yM4LF4Q?=
 =?us-ascii?Q?gDsKUZ2rdS4EPz05mdEHHzexLkr2BzTdCflsv+2StmXYKkTSTAhEZgGO8CEx?=
 =?us-ascii?Q?+hupXRlt9VdIe4mp2d1Z1F5J9+0lwN+OIHZMLyrEUrlc/84NJOGMV1sYjQYI?=
 =?us-ascii?Q?Fg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d04a2e34-2d5d-44b2-89c1-08da58dea3a1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 08:17:27.9634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A7s22QZou7VCfLBADuw1q3q39H9vlc06Fs939O4ocSy5aBtfF5E1KrJ/sIw8jptm3MpA4v7CXbzopS9jFVRst39C5QmnHNvfC/QpuQiUZx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5891
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
 drivers/pinctrl/pinctrl-ocelot.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 5554c3014448..655bada7cc4b 100644
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
@@ -1938,16 +1938,12 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
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
+	info->map = ocelot_platform_init_regmap_from_resource(pdev, 0,
+							      &regmap_config);
 	if (IS_ERR(info->map)) {
 		dev_err(dev, "Failed to create regmap\n");
 		return PTR_ERR(info->map);
@@ -1989,3 +1985,4 @@ builtin_platform_driver(ocelot_pinctrl_driver);
 
 MODULE_DESCRIPTION("Ocelot Chip Pinctrl Driver");
 MODULE_LICENSE("Dual MIT/GPL");
+MODULE_IMPORT_NS(MFD_OCELOT);
-- 
2.25.1

