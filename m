Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349CF5678AE
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 22:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbiGEUsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 16:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbiGEUsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 16:48:17 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2113.outbound.protection.outlook.com [40.107.92.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5A5101EA;
        Tue,  5 Jul 2022 13:48:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYtG0gaiPydjClfVaVYvMjH6JmxqqWsVb2Cx6cgWXcQ7OQZRDD1jEwNC6TPtenHoprj9Vg96H0fG5/9Vl//QTkRcqEFBejCfERkeXqgfRidVD/HvURUfOJnOY1uVQ0+uJZjT/gKvaqr2fIY4wVjh4nn6TmfKLeQF4XUAEnYwv2tmtQdkfmt4qLr6Mo9bjdKYIEp92J/CbBEKnO6zNgiYsg4gBOcmPfc+MYuIW9FROBpoRp4ydaSRs+tbiFrtcnN6r+n9RXhih1jR2M4ZDt4NJiihaWQ0jgb5jo1gqqz5oG6n9v+8GoYNd2CfJ0YKlGu7zmdheXHJ2pzufI0U2UDcwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mMFdAGzwoQHjdpAqZlZIm/n61SF9csxZswK30YGhLRY=;
 b=JjOpnPQTpXfyVNN4j71KjN4nw+rgmbgNpYNuVrrTE3ewDNBl8Do9XVXEoHKN7iVDo6SBMQty01p6FzU6EvgB8APm0knizBaJ3yiZlMpWKkx0rqGR9T3M9x+mok1E/cZH5pE9kp7tMal0CFQNyudUV9zwW7k6AhJ6LwmD/90Yx/96Tsg4lA9WwrtL6CaWsTgxJeMF0PLfz7h7iOGji3BuOm2IpWSnZVnsiZpd8okOCeTHGYXrjWbEGJ3E6qAsSgfq3QtgXKxEKyb/M7NDEgJmFEoCFSBRX2yv602CvxVw4rr5G8Ex1WlPyaHIuqr5agmub6Ot4b972WwXwAJBw1sspw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mMFdAGzwoQHjdpAqZlZIm/n61SF9csxZswK30YGhLRY=;
 b=As29xDqqi2hJZbODvVFAB+Hy/h2VZIQ9L6voPIy8BTweF1SF4AQ0m/L4qf/LNMMh0AII8UGI0kX/5qcbi4Ut7vE0yRbQylmMKyRJjxSwdj1yxXQr4e20tUXjRUhO7MThlxmqUtjol3s+qtt7NRJrXI/yby8L/DFYVoCt769bdog=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BL0PR10MB2898.namprd10.prod.outlook.com
 (2603:10b6:208:75::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 20:48:12 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5395.020; Tue, 5 Jul 2022
 20:48:12 +0000
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
Subject: [PATCH v13 net-next 3/9] pinctrl: ocelot: allow pinctrl-ocelot to be loaded as a module
Date:   Tue,  5 Jul 2022 13:47:37 -0700
Message-Id: <20220705204743.3224692-4-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: cb1fdb1d-957b-44d5-15d8-08da5ec7acdc
X-MS-TrafficTypeDiagnostic: BL0PR10MB2898:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m0po4xwYcSZIYwRJXL8hMqHuulnGs8SRGef0UFVWjsofUZfbYOkX6IHQWF3t7CeEEitA5x8+G0qkvH7SrAW95eZa1kbRc+w3+O0tl0yhICaBJ+lGmHkUgHvBVfpAwhbPt2qoiM12t6USbW5LCMLz8PLKBLQHKTht1pGJoxwlbrd+SQDmqEnsxgjVkHiaMOeWsfZhS93/R4AwSgUjHcSz5AeIsYVHdc1X3UCpoTAm6wLmDXthZnKj8SSyco1uJjN+8K3CPR7O9ljom06ExQmGJQO7mu0dj+tTcpFtHwE1mP+5ypWzMqumlUOb1TSsFpfSPJ7ahxduEWM3bjLeND9XA3djYOh/NM5JNzNXM3R9ec6PKo/KVdnurZBAd1KqxN6TNVx9emEwK5gxNsqS7gv+id4QNgnow7Fzt6yM2YWdtcY5yaRvSop3m62CaNfe7ISsK/E7nEQN/dNB3OGB8KRiTO9Xc2CvGXP198IUOCQZaJQlZ4qwP3t5zoNnWINCQiMv7uqza7z5gYFwLLtna7vOmF/61zz280N6MG0jSACP37p36CDAa1HAljZ6AycfPu2JghYicsKFgz7eE7eeHoFY5jWKgq+QK3sEp9W6cbG8BQ/FTNysfW7OvybZZi3axId23NxH10OBz5PP4w3CN4g4rQx6nOdtBsEdpXBANyXfzyS9NLORXBC9bK/2lfzt1j5WAU6N7STZHJ50wF4oDjAN0Ji7uaHs7iwIFrSPtnGPmmjtHJeFA5KIhONNPvGk0aTmpm1jYYmOaj98dWEAeFc6IG4DskFb4bakjdDnNBMXCxt+CD6qWbGGOitsw2hdrGvg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39830400003)(376002)(346002)(136003)(396003)(366004)(478600001)(38350700002)(66556008)(66476007)(8676002)(66946007)(4326008)(316002)(38100700002)(186003)(2616005)(1076003)(6486002)(41300700001)(26005)(6506007)(6666004)(52116002)(6512007)(54906003)(83380400001)(5660300002)(86362001)(2906002)(44832011)(7416002)(36756003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5BGREWkgNC1FXH2nzxc45s0xSilz2OZB0EnQp/A7fUKmLgAAPkPGQbSHSMAk?=
 =?us-ascii?Q?HQurINdqHQeJC75QhCBz1FtgfdDkUDadjJhxGutz2HqwcgvnQ1tthrdtnJz6?=
 =?us-ascii?Q?NtJGmizA2cJ3W/6xXyT4sSafyYjyTTzB9CkwOjhsMLEIy5GL/B8XfrnLqDdw?=
 =?us-ascii?Q?W3a+cChX/uMIebxJZ9lp28ttPzbbkVTFbM+L+vwnpS44PPPvUgb2hKTDQVYb?=
 =?us-ascii?Q?R/TH9f5q8wyS7T0ETzznckuRfHjJSKhOem8pDIdGQKEFXcYYhMEP8NHTDq1p?=
 =?us-ascii?Q?ZRlsyH9GcrS8IST2o/+AzKaHwCinzdcVX03qwnEaTVLy4sWN4oJ9XoYtWTuy?=
 =?us-ascii?Q?PDFbhIobO7uotreZ7ZObXDXwyX7wwkRFigo/0xgZGQM8vsIzoCRyw8psJUnd?=
 =?us-ascii?Q?olw0a1pBurBzBLUIvsYkH2Q02NEjR9TVH6YbnCCellRnraP+SFfMRPuJxTIa?=
 =?us-ascii?Q?yTyojnpljugsyB+EFkr19oJEse/RAQg+MM/7c97MDgsL74jbubirvNUt6/E4?=
 =?us-ascii?Q?hDf5fBOU5xLO5JigwWad+tChA0/Jn8NMyxU0vquU8yON0SCpasLwyHuQMCZz?=
 =?us-ascii?Q?yqbEoyrMgEeBfBiLe04+z6/auvc42ORGoejgfh9aPv69ASRaE60C41yLVCRA?=
 =?us-ascii?Q?YkrPApIOXOj4uB1KG0ekVjTlnwIYCLjcberIN97twm1N65SVimvGjwlk942x?=
 =?us-ascii?Q?DJpRMIDpEtJUbtXVE5BNB82xCm4z8gKnNjZH9E4WkZynp2Vbjz8JifHH3m/e?=
 =?us-ascii?Q?DhJmg0K+//19H+GXj6GZ/I82FvvCE6+eAUE+5qTCEDqGKfGYjbtMGPY1ZKeg?=
 =?us-ascii?Q?6rsSqQMIT2blf0E4K67lScYh/HI3GYRJEa92MJ/YcNoHNGcbV3gYw4r9CxKf?=
 =?us-ascii?Q?LTwyX2g+qR/NwLOXU3alhn2B/79QeWhphRrwC54o5ZBxgOePdGEY/9oKvWLA?=
 =?us-ascii?Q?74NIgaZx2eQ20jMFO0rFb6gTOAOauBT53/2Fiw9/GXafYgYqfw4C6eqIMgyf?=
 =?us-ascii?Q?Oh7VKrLj+mfIMNf0AhzFjc3JUMcCos5NHjno9dxMLDHgNR9eKoWPrsbbFq4y?=
 =?us-ascii?Q?zV15he10N0EnohMki+jNHA+c1tZ5YbyX5rjKCmJhgyEhYajVYDuXy6GibjBv?=
 =?us-ascii?Q?xw+VEhEvzCfKjfo/SVbJhAhlJtjSILolaaHa7LwmHUWQgbnKF0xNwWYo3LT3?=
 =?us-ascii?Q?j1Skb3mMnWIdt5qBxJ4YCPrKvvmPFcJSgeHAEpBInhVojhDCN2w7IK7WlFrg?=
 =?us-ascii?Q?5BsgLyQxiXYLO4sE5/n4dJzOsa4S5N/JpaA6ZGdg28xsF6mloj9rBnGgBeC7?=
 =?us-ascii?Q?pT/LkJIrQdHliXxOez8dQZhUIZCRKm3UjfRwNL7dBWZo/kNaFO/a8Snjd6+l?=
 =?us-ascii?Q?DDlRb1UTCLEqyB8LHsLSXWxjwQsESNJxLLGljUr4PPdQFBMhFCdyuWOO2MzJ?=
 =?us-ascii?Q?p0cNbY9OlN2CKeR6R6LmO0zfaCGfLn7cG0FcaBjFQ4yi4lCoAGtw8TYifIk6?=
 =?us-ascii?Q?FXCD13iyhhXlkdi/nV10GpRjOXAVyfYS+/jy24ttWL7eTGPK/c8hZZTLvVmP?=
 =?us-ascii?Q?ldzNBB5/1pqOto6g7bVAp8JxkATkibO2M02uxp34u66mLEuaYc5cTQVstCIb?=
 =?us-ascii?Q?eg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb1fdb1d-957b-44d5-15d8-08da5ec7acdc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 20:48:11.9672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xaqd7fzkiZTBZFKUaj0UZsYQhBVuQyKaVmwVVeU0BS+DS8mPBy6lLgRzi/JBFt/kDMz3hTR/T6oVuzWCwDyGa6kaRWkeDl05SufZORPYFkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2898
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

