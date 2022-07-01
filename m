Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978E65639D6
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 21:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbiGAT0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 15:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbiGAT0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 15:26:34 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2118.outbound.protection.outlook.com [40.107.100.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA0840931;
        Fri,  1 Jul 2022 12:26:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4pGT50tuzEblnXAtvt1fMqsh2d0+sBZeWWXoexaYMALXkcqUCVcok/C0ickHfGXhtlczqXEkBzyTned4x3jGniMu2myk24zaHvr+IG2DVQlnuc2rgNVYtiOud74foLpRrKOGWwGsfIzprJwRXp8JB5HBvO+vsxoU+ihiX0NrG+zkXmS4di8svjzsFWPoAPNI2jQ5yvQGEM2zLaPAyvq9oKafzaWkqT4ggmUmG6OB9I+AbdnjgcjPm2Yt378TyaKaN/IwABe1IC1sVGK0ZKTmCwGwB1TALZq+L3vzrWWwKZFA2avU0GYM4ZFAfB9SIW7odVwZn09PVHPsL23wZfzfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISgX5RxlgROtQbYVXVHHPAIyZqNI+v7quic2qv3dMB8=;
 b=jA5uW+9gxyl60Mu9ARh6/gSnmARbL3r1Y8nXkEMb84kLFcQUdceXVN9wBOD7i2LRGw7iPIh7y+FFpRrpDQhf8KN+KJ0tpxPLbw/rC31wnZ1YrZfJXIAQTPmWAUz93dGVfPHwKmf4ogGVXvKPIw7CwoSujr86NSuxz4+pN1yb/DlPmFZXwM91qtls3UmLMezR5mDBZ0vMqhucaoorm/b8IAUQKVdFi1TlXsBN1FfSHVlatwBfRr9mx3f2//lDCiwlX9xVnh+Qf8DmY2weTOkID/PeUWfMjNJ8KKBQFccfp26p0CSEnS3ve2fzC9d5LJNf5mIRnJHpoMXirSN1a72XFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISgX5RxlgROtQbYVXVHHPAIyZqNI+v7quic2qv3dMB8=;
 b=dG+Fl0W4mbrU8gpowCvUR/TECbudnknLW6dBkJ/Wxi3MuNfy0nktPiWHwVDUh49FoIgt50lQO0Un3fkDY75iPkIkXjjjsBaytqv63Xltdjw55ZNKXq0ytlHB1B9cEWL6yxD9pMFWmX6XUhLTFnayOnkejeeKQdZWu+F+IF9rTLQ=
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
        katie.morris@in-advantage.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v12 net-next 3/9] pinctrl: ocelot: allow pinctrl-ocelot to be loaded as a module
Date:   Fri,  1 Jul 2022 12:26:03 -0700
Message-Id: <20220701192609.3970317-4-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 78fdd666-ac9e-41fe-ff2c-08da5b979404
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2230:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bzsUBcyqW/fsvwxP4Xhd0mmE7WJYuMYoryx+LyPt/MeqIV43DLgcaEb3uYRJAj8POQykDXCWRb+OmfbdNYtfarw39NR+JMxzNq/DGwB+8pHXgSmVjYwme3YWm3+1HEGzlsxxxZ8/Awx4pxQ1IxuXvpH7hxjRzlOq482r6X1IbrzUSteg/8XCQ9fpdxorYGJOUTPuWec2fIhcV5I/DZdFPCcL8bkhkBG4qG1ls54oE6T/ATyFuyl96YA8zJf8tXSbHPmymvRi15VXV82JXwKuNPBLWsIS2HFV8rYRWZW1TWNdOhxpKz9gr7O4Dw38G7xpzozanNP2xrPFmVuM7B3su+vP4AghgXlDIgrS58nQSPQYNQg51Hmi/w5pY3ZEtDQe/cHJD4VRb4+uCj2nAF46etNrbC2IAO3jX/TKHBnQUqm6yZ3Wz/1RpD2qx/53UVhkCw5TQrmsjuU0OBB22ZUM6YWy48A4jjM/Vup8Qd9a8GFX37oJNj6FjLD30gsDa/9d1GH+LrzxkcYgpMZ8c0Ym750k8vLlYvRLeqKSpcAv8ZreegXrCrsJUcOZJumKtKpB+jqsvkCiHBaToVYE7sQuCqltEq1FMezy3eKjAq9wN8MT3JUEkRn6CZSzPRVJCtKEqcuZOwDCk60t/4GMt8GLFtUWt5w3rYk1iZfvhO86AszJ8DwT2z1+Rmn3CA0T5C99ABdOV5/VnduHtCl16Wfqf2pd9pgkOJaYVDBePnu3jQ2VBBPEGKH+wfAWPXPiILqRAaXiJGUeohfidvwnJ7VsQPuS7ZOCDbP7HhuXlB279//dSfmeHowqGthTQUPOVDkt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(39830400003)(376002)(136003)(396003)(66476007)(38350700002)(186003)(8676002)(8936002)(4326008)(86362001)(66946007)(1076003)(5660300002)(6666004)(38100700002)(83380400001)(66556008)(7416002)(41300700001)(478600001)(316002)(36756003)(52116002)(44832011)(2906002)(6512007)(2616005)(6506007)(6486002)(26005)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l1GFxRoFpM6DgqOJ8rOmR7RKIgI3YOv0ne6393w2Kv3SD0g0J4H7IiUA/2LY?=
 =?us-ascii?Q?IyAEynfmkDw1ME1zWUKZee8AB2d+HXmCq9EvrK7aI+wkONw97X45Zn0qHgIg?=
 =?us-ascii?Q?hNVW1vASHXDSdmeFiWlk3uAeiooTFH9XAuPIhmZzfzAY++JcnBL1apIYqbUn?=
 =?us-ascii?Q?qZ632RMjphczPBoC7jiBJhJR0aw+PxJ2qOwYUcf3KHxtNS/+WhMupvOxFPFz?=
 =?us-ascii?Q?RQVNCJTGtl4+hoTizOPRYQiTM6vt0JaeAH6TFIl2xJp7FGXG10Ys8T6QmIze?=
 =?us-ascii?Q?KsEdzwwE+JuAYQBqRZy8qQnZfb3Sk5Srrf3XhM9NAsejjAM1VaxSOnkfp/xs?=
 =?us-ascii?Q?P/kcdsUnkDwl8CQNmasP4IfRKr2yx4alM0fJINmDJRgz0ZvgtLSJHq6EaUhF?=
 =?us-ascii?Q?vU55YQtLuuXR2j3R7yxc+lyk+2VdAL72s2uUuaU+ma5FLnvYcm1QvVDxgKk5?=
 =?us-ascii?Q?vWBvnZ5F9z492eo2SnwCdUccf0/yhWC9BRJahxj5f4w7nczcus8R4buTsY89?=
 =?us-ascii?Q?IOhFXJgJOdNk1PwigfCMdLAVMR1y8xy3JDzd0bjg4GBkHdlN4ntSHTrjx/16?=
 =?us-ascii?Q?oScAg9MuxRWZCNk0Mn6IWBwYxes5qyCnfsvRPy59Hi8xB5dyZY0bCUZmrC2l?=
 =?us-ascii?Q?0219hX1ftAjduIt8TF2SrvQdsEZ2gAdi5O2q7UvTwDhCoqNb83DtawNh0bDn?=
 =?us-ascii?Q?RHRrY01rMK7MHhdsxtPAj5aBY8BuiEdrzSDwxx+NGm03qfaxS6RctioLnPg+?=
 =?us-ascii?Q?dfwOxsNrnX6+amRUeE7ZtdTpLCF0ICfuGpoz6UpUsIeMxM5+m6dtSfPNIGZy?=
 =?us-ascii?Q?MSI8E6Cwg4e7hUTT2WYb5MvyviyR410x6x9AGWoW7VW0Ljig4ix4z0CGVPOP?=
 =?us-ascii?Q?gJGpNNWiEkNs/cl9YdrfeSUPwx9jmRecyTgVJTe1CyLRdp1lMoM6fYuOZNgg?=
 =?us-ascii?Q?wDUhUwiQ+eLfpTeR0b68fEVIiV6pj7I9iiB/Dv2tJcxyAc/CWIUDoKKXVkq9?=
 =?us-ascii?Q?UnWhbUyQRlqJHQ3Z3b7i/K2DEiq0n/h1QWr16PAKu5K9z88n6g8PJsfIQhFl?=
 =?us-ascii?Q?iLlyMutE7OqBN6ui8dHtYibb6jZQlLwKkjrQUcpVaG5Bj6v3Q6VkCKq3mdlg?=
 =?us-ascii?Q?phUiIOn0/XdTBEgtuzD8QGYVeJfUV1TATf1Lirf/KPhNv8+cgEJjspetIhJl?=
 =?us-ascii?Q?EF1n41jcXN6wNlePV6RunsvzTlmWkjzfOZQyxhv4u5swg8iyJg6iDegGJA1P?=
 =?us-ascii?Q?MVvlQsaa+1+P7u8wxXpnB0in3vqXPSQUPKYwdjdXM3WNxWJKsLgmvZhqolrv?=
 =?us-ascii?Q?Tgw/YNCsdeXDAOZulbhrI2tuN0+xFE0an7eUDevJqyzNY9mer8XaK8KDf78g?=
 =?us-ascii?Q?tWR41DDbfOO42hWtoyxQP4ypKpoKpUY7MCNdi2Qr/Kn3Ei7hK2dnE3HNW75+?=
 =?us-ascii?Q?/8u9OsFBJOoCG8B5/36ABIXVbHaXUuvEwqHiTC/nMTHZe9al0Rb7Lz0jXDow?=
 =?us-ascii?Q?syn+xAav2NoYcyxA1rhxjYCu+xXOYIJt1DqABtII8vsdaBQwsYy7Wf8O8aci?=
 =?us-ascii?Q?G50M2TkuefLYn6Zoqv/X3McfTHp3kjCt6mt+vQ1i2wmnbaj1wnDHrXztyc5J?=
 =?us-ascii?Q?2Q=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78fdd666-ac9e-41fe-ff2c-08da5b979404
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 19:26:20.9922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dUCNkbrNFYFmWfy7JMaBVLPGmyfl6LVz0Mn41OnR6njGPIaBeECBjzaUHjAaORwrD8xarKQg26xp0WxFHoC+9JnlQ7bDmeakHs3axeLds94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2230
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/pinctrl/Kconfig          | 2 +-
 drivers/pinctrl/pinctrl-ocelot.c | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index f52960d2dfbe..257b06752747 100644
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

