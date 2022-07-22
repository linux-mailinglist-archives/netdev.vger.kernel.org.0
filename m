Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6B357D92F
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 06:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbiGVEGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 00:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbiGVEGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 00:06:34 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2097.outbound.protection.outlook.com [40.107.220.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017E889A7F;
        Thu, 21 Jul 2022 21:06:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhceq1diDPZWpwGIdKbJvrcMMVufATVvdVDhMjx/lIaJD0T7lUnOHCBcREU+PM01P3iljfu85qWt+D0/2ZfEb+75CJOBVtZ8zedqWkaLcN4tukyE6mCE8EEqiqoOms7j30HUx0AXEtnn+tm9y/mi8lMV9rGlTrTXwaiTbH6spDu+3sC25xhUYRQUBLCoJn0Dmb60bz5IecV6AkSeFH6vWJtrgDwXTsl7pW1QjDTVZTnRJFp3axiB1T0Lx6prjV0iCgFIK7dsIDj3xkjCb/gcHET6i7Qj/WqGsdT3VvnfEKuatfiOad/HISAu0poLojqonQZAjL9rechxxpH//3FlmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oM7NXLchwVPorq6qyp5HaDRVFe11Us8AHLYVghdpYUU=;
 b=kFUWTLAohkX2z4/LsnnsBQviBqbfQYVbZrFmE081/exAi/FOzeBy2Ba2Cu3YlgT53McxYg/Awnh/OA9PpNuHw27gd8Vw22NwOHx1X2/Qd9+5k2y30MwgK1Oc5EtQHUXyMS+VC/UkiZg9Q/jUuV7MRrtkFSGujJuUoHjKjEsP9aqcMN0P0JDfUvuJ883pT/Dr6Cy6LQBo6O+pFD8y9mShfu5ItZBvsaEx1HuPv5p8dv45AlfrGU9rIgHSfErShYZemklGOnWdricQvBUyGHBJ67QPPlHJSBuNWJffRdYutJCLQjCbhMJ57b7awRNkkl+HeG+Wo5WvBglCqBUuRJLuFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oM7NXLchwVPorq6qyp5HaDRVFe11Us8AHLYVghdpYUU=;
 b=u8DWlItTvsBtq3WmKJfF9Nvbrnso7qTFCcsinSkfhsDybgUoMF16GTR2BPPgq3zzR381E3DOrjnRM5SxMrp70XWGc8MJXbQH+8iSs2kb0vBC1SyggbVhy1H0UA49D8J4WygB5Yf/hX/ZP7X7y7A6HtDyKqOUkmKPbt8RPwl495w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN2PR10MB3919.namprd10.prod.outlook.com
 (2603:10b6:208:1be::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Fri, 22 Jul
 2022 04:06:28 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912%7]) with mapi id 15.20.5438.023; Fri, 22 Jul 2022
 04:06:28 +0000
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
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v14 mfd 3/9] pinctrl: ocelot: allow pinctrl-ocelot to be loaded as a module
Date:   Thu, 21 Jul 2022 21:06:03 -0700
Message-Id: <20220722040609.91703-4-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: f747090e-1546-4612-2835-08da6b978c8f
X-MS-TrafficTypeDiagnostic: MN2PR10MB3919:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D7GZPKoLdCWzJ540TPEP2a+/TihdyZP1rJ2bleMBr3zK69GsehsjTurD2XlhXcVHlGl1Wv/fWcjbrBN3/odVRHULbnE3mONiV5xbKxLZchAYcCDD432fCjtax/vSkQZ2kyWKKwlxRaUF/BVhxblv08F6MIJgL1fQ5YfQZtQ+ZjZ6oeqcccDe/eg4hlSmnzgjuPPuUD3RXB12+7zyYH2jlQ+lt8n3l0LKeR+NG2yH/rb+Asavk+KeX04SD1InUPGDv57Bqrc2z2vh0YSjwidpjo2T0ldGK1Y5Mb8YVwtDHHolNpPidtKZ/pTBlAElP7v4J9ol/Wow9DwRz6Xd+aG3wsjRHSPdX7lbX4DB6gWJEon4gqmZuTtUq5qHG9L5lqtODt0BcYL/IuO1ASh7bFuX5tfhqo7FqQk53cAb7WmSBQ4cc3Zt/ZTHW2QE8scja2xpC0niu/2SWbksMvKzqELbH1DVmIZqCAspgTXjfLVeIaEEFVgGhmI0xHG37GumtJ9sYp7Z6yQKnt+a1AhdOP1aSA3hbzEULj9Ix6veqw/dNtaAAGxQEWi/PxuIalOAPTTle8A1p4gk9xg3qgfVqdt/zUoTMIsw75qvVOKeT57YeXAcLK/qB/OT+/eeGCccelgJkCtoR8D8cVhJTEBNFep2Mw/Fc2mufO4Ueer0rG2kaBgjT8rS22jWSUs53/RaUFfZ4bGBmaoU0O9ppvYH8K/lo6SQuI6jRqFrxGCoIM8WETavVlCGKQCTZ68w25idXNdqSk5pidqXp56PyW7aCFIM5t8dbBLPbUuck7xxLsxVHvKEezGBqvALn2LwUjiui96C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(376002)(136003)(396003)(39840400004)(36756003)(6506007)(2906002)(44832011)(41300700001)(52116002)(5660300002)(1076003)(66556008)(8676002)(8936002)(4326008)(66476007)(186003)(6486002)(478600001)(6666004)(6512007)(7416002)(83380400001)(26005)(316002)(86362001)(38100700002)(2616005)(38350700002)(54906003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pXBiAU1fYboxrM/QeN7nUHOrrDwwAsU3yCowN9XSN7GzELpJkXtHjhdTq08Y?=
 =?us-ascii?Q?mw78k2v4xoK92cjLqdV5hAkxUQcycidQEUGn+xv7tC2Kg4BYhINBT8sFZWKx?=
 =?us-ascii?Q?Y/mOwvo5lGigFrvkgHD2fRWVxJKjbPtvtJvXQupJO3p+ta+SX/MW55qNCilA?=
 =?us-ascii?Q?aLAOEgztUyIw0PtMa8vc+dhRfaWZwyV+0afpzCB6Q8DdWhBlu7HYkfIYHWOK?=
 =?us-ascii?Q?9tUTrGiBIL4ePjfqKnLqyALYjuJ4mLoGbwTx4w5jhiwJylFfdVWykVh2cIk/?=
 =?us-ascii?Q?HhHfilRBpuHomccpFaMW3tyvr+sRuSFtNYjsGQvoTQv2i2o1t3lscqyD2awN?=
 =?us-ascii?Q?c478zPo2StReqMe4Jo0bH1W7edj8xKEnpMoa3Gb+elO6cC/Kc2NBkMlv4XAE?=
 =?us-ascii?Q?wkM2H7Wa+Zw9i8zMNrqVmK0+NhQypW4dyLqbhI/plpKDnZpavs39lMd22m0e?=
 =?us-ascii?Q?2GRSgEjc4dXi5B8nza0XxxegueAxUA9BtzEEr6m21FgCY982Lba5dAo2Mboi?=
 =?us-ascii?Q?I9cgA3iuUlPj45b+wqkgvm5oplmTIutInQdGdcLiNLv8/9mAKJfTwjfJDT5O?=
 =?us-ascii?Q?nB4aFpaypL34LvnBM6ZWLlSKNcZjAGiSD51KzN0E0ZBeMr+krVJBPt2AQjPc?=
 =?us-ascii?Q?CD8zKDuoyrxDy5C8y7d/H1gYco56Aq2zOrsnIJN6MZE9HkJa7J9nL2YTJoeY?=
 =?us-ascii?Q?sJiQjDf+MG6fGHuWGuKTikCrg2LFTaHomclGToh55abwJ99FHGWI1Dod9egX?=
 =?us-ascii?Q?+hsp7e1SHB3A2fPPWMqK734F7iGR7vNfN+MhqD3I8e1H18XFZlNtdfaFyFuo?=
 =?us-ascii?Q?e4r7BVposIAHYdyWTIIjNY/WxeD0ZZk/oTgX+fvjdaPU3rl5eFQiSj5tWSqC?=
 =?us-ascii?Q?7AI5S6pB9D7prKhk4cv3LqaXLOYwG3bGRKX5JmK+SmeTqA5qRO1wvUy7YzQQ?=
 =?us-ascii?Q?Sz7twEclDGynFdd7xwqVEQg3z3njTKQ++rppQ67WUxlb7NiTFMmSHe226t6b?=
 =?us-ascii?Q?IpUsN3M58WRA825IS1Fz9H30R97A6YufB8/j7TEZSWAVfKIYy6I4pqi0alOY?=
 =?us-ascii?Q?Y2eVpkpssdaAzkiNTeXrcVLmUTXV6vwOS9mdTL721gC9GthrlTPm1Bw5DDyY?=
 =?us-ascii?Q?VoBa2ERPc52DMYIjRhEpr0e4Juy3PMmCMlwyQnxCaZmil5RoGRTBhmKJhdHR?=
 =?us-ascii?Q?10JIMN6eQqy1Y29w8Cr2fkkhTBhXlZfh+sKnfkONH3mKGP/aSpOgoBW7J1pF?=
 =?us-ascii?Q?3A4ZhddP4QumWrOsjLwz5kLxGhrwiObAwbsGkBm+wggGbtEZvNOnx/e5gO5U?=
 =?us-ascii?Q?YPECEpCvduFhNFyJz9IZviYVI5DLe/IMLs2x68Mxc+MBvTt/FDQnSolmyhNL?=
 =?us-ascii?Q?wizagjcIci+n//C0hrCm8qRNf7i3WVVNoS1/J9vM181EzkazWLgo1Q+Hz4Zb?=
 =?us-ascii?Q?lWsdfCGKg4OfUXRkAXzKoxsC4HTTSXO2lZv30l9AsdV7raJ4eTj3ZUAPYQdz?=
 =?us-ascii?Q?RWCF7iL442/xAjv3NRVAkHmvNl6MttSDtsjplF6NHrw0r7rFaVDfZz6lVU4Y?=
 =?us-ascii?Q?cFp0yac0zy7DCxc4WPr0KjxbPhefeuwQB74Mv/I9sTtOcFUavI/IoHj/3FV6?=
 =?us-ascii?Q?8O41/l89ao9AQMbpGNN/Bd0=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f747090e-1546-4612-2835-08da6b978c8f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 04:06:27.0491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BbNW3BSr7AcFTuEfo1OUKRt/BQ7DzZcEKDz0Sx7nUydaDvVEfQ7rk1ZJ/2YtXV6pzjgHEy3AYGZKaMrs86vlbrKxdso0aAinNt3jfwtcOM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3919
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Work is being done to allow external control of Ocelot chips. When pinctrl
drivers are used internally, it wouldn't make much sense to allow them to
be loaded as modules. In the case where the Ocelot chip is controlled
externally, this scenario becomes practical.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v14
    * No changes

---
 drivers/pinctrl/Kconfig          | 7 ++++++-
 drivers/pinctrl/pinctrl-ocelot.c | 6 +++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index f52960d2dfbe..ba48ff8be6e2 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -311,7 +311,7 @@ config PINCTRL_MICROCHIP_SGPIO
 	  LED controller.
 
 config PINCTRL_OCELOT
-	bool "Pinctrl driver for the Microsemi Ocelot and Jaguar2 SoCs"
+	tristate "Pinctrl driver for the Microsemi Ocelot and Jaguar2 SoCs"
 	depends on OF
 	depends on HAS_IOMEM
 	select GPIOLIB
@@ -321,6 +321,11 @@ config PINCTRL_OCELOT
 	select GENERIC_PINMUX_FUNCTIONS
 	select OF_GPIO
 	select REGMAP_MMIO
+	help
+	  Support for the internal GPIO interfaces on Microsemi Ocelot and
+	  Jaguar2 SoCs.
+
+	  If conpiled as a module, the module name will be pinctrl-ocelot.
 
 config PINCTRL_OXNAS
 	bool
diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 5f4a8c5c6650..d18047d2306d 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -1889,6 +1889,7 @@ static const struct of_device_id ocelot_pinctrl_of_match[] = {
 	{ .compatible = "microchip,lan966x-pinctrl", .data = &lan966x_desc },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ocelot_pinctrl_of_match);
 
 static struct regmap *ocelot_pinctrl_create_pincfg(struct platform_device *pdev)
 {
@@ -1984,4 +1985,7 @@ static struct platform_driver ocelot_pinctrl_driver = {
 	},
 	.probe = ocelot_pinctrl_probe,
 };
-builtin_platform_driver(ocelot_pinctrl_driver);
+module_platform_driver(ocelot_pinctrl_driver);
+
+MODULE_DESCRIPTION("Ocelot Chip Pinctrl Driver");
+MODULE_LICENSE("Dual MIT/GPL");
-- 
2.25.1

