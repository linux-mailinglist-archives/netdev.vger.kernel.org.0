Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27981588702
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 07:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbiHCFsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 01:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236110AbiHCFr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 01:47:56 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2121.outbound.protection.outlook.com [40.107.244.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673A85724B;
        Tue,  2 Aug 2022 22:47:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BWQskssOTaTB49pbXOTP2eq5ODVSX4xij9CGkkVoKuuxG5zM3zjKmg3nNwvnAqY/YWGR+T8UpNuI0OSPifCXmVxJ+0VFjJKccWdh1AcW3EAe/J7HpJLaOkoUjc2snyeKvuzq0jr8WMUurbGy57ZUmvIYZvdk27Hex05meR5OL8nhmiDIwMb3bZFN8FHqNKBYBcdqmXb3Ae8GVfJKxUfLJ3GMPDErZagu+MPeuK99+VvVCdfXrzvw5w3+m8pZu5pSnzxQY18GhB/Yu7xtAZ2Xgvljta9N+IBgMsHmmjQPczNMt8AbEafi2RJWQ2Vkett28m2Ud+RcJPt6WU+7OkEpsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b4iqxIpL6SYkOcLWwCQPALRq2mAuAYQ0gxMxQkH7C+0=;
 b=HFPZE/z/16SQLYnhyoX9MfokhkOrfARRdUfnaPMwyrYuOEx8ubISBvvrNaomVmSpvinEiYzKHChLHKLUKIXOVPAHMc0vMwiF1Jphxm1HrJ4/NVJeGXCA6Btwe/t+gcaEsRnRDJeWpxif/0e4OXrQGIzTNw7YfODv96x2H2SISUsbNi7QlFc3PlNCn3lJNytUwyixd8OqA1lfbFksEuCYi6rQ4mEQgMBTLJ8/uQeul+bsyQbT76Op5e4cJiEVKgRsGa/oN6w1trbup6GC5j4UmOxkmIFc1G8irUX78bbUFmwWqALwZKYuSXortEMSCbY1vFxXtzbms0jlWMKP0SnlIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4iqxIpL6SYkOcLWwCQPALRq2mAuAYQ0gxMxQkH7C+0=;
 b=RIgaBO4Fw0jr4nLKM7Oe18flppC97CmS19JvIPl5HNx1jomIhs1U6//nUe6/h0uQsSncPzrfL4H4bV57lqPjy/YoYG1ugao7Jfo7bRAUIwC53HopkgqtcKl8zpGUxGBoRbF/3bAnvBx6/n/HXdKa+CKKuckJcohf8RNFuftllG4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB6438.namprd10.prod.outlook.com
 (2603:10b6:303:218::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 05:47:51 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5482.014; Wed, 3 Aug 2022
 05:47:51 +0000
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
Subject: [PATCH v15 mfd 5/9] pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
Date:   Tue,  2 Aug 2022 22:47:24 -0700
Message-Id: <20220803054728.1541104-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803054728.1541104-1-colin.foster@in-advantage.com>
References: <20220803054728.1541104-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0026.prod.exchangelabs.com (2603:10b6:a02:80::39)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e55b853-e4e9-4e5a-d502-08da7513b3db
X-MS-TrafficTypeDiagnostic: MW4PR10MB6438:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: toGplqpGfOBdJ3lmz1Mid4icS6eIH7WIEinVxaQ9SU7mdo29UIWr2dO0pzh7jsAAqWdSrnA2jkRaWYUasf+6RxXHVY5oZt6yUilmPE3Pntaqo+sHOIFs0rggdz+vN6OSc5QUKLlirjElGdvGg67mKRJbz1OfYe0/t0RuUf426yjJwdZhRqrZh8AI+JjZbyi2INzL6CJG04gsGpfTLZ1EuV751UlDWKBhE+qMC/OSArgvQNnSdfJ7/ofecIpUP+SCIsy2aPl9+u+Uq9i5bqtfnn3Am5BSc0SaDKSqLd3mCboW76ZbTaru9DKyHghLIgGs89qlBETfv3ToHQSr18f7LWI14SClllDvt73ioa34Fw4IHWY800tHyuF1JdX3rSLl54AOm6kvgo41rghJenzYndJTAbWQ4OqEty8XdkYtKme5V/1UBqmdRDDaTY0tT5rNNJteNZaO7UEiP5w8GiEwbpdBPzuoO4vauSIOj4VjxKi+yX5P0YsQlaW0RLzRfnxReSDlrl22NOpz/6N5ZbCWPFos1OLpxyhu0NX6jS2XhTrdMPqIwTp1Qz2PTnURJkjAxmo3UWzr/HVAIF5Lw3rUU2M0VLeJ0ta6shmTtq2zGwtbIoXLJDziP28lmGhSefMis8mrUszsKbBxhsofFMi8prDEAvEPB3hgOJ1dgxlUmG71BRqTKqjePizy/buAoWoMd7HE5g2tRRZ1iJqSk+ozKU+NXLFp8p4LhhWPzt8usfSn2ffcaLFGWoOwrnfQqgOLoI9wiMkPnRCaIz4KtGaHgt7tOSGRmz8Tylfx4ahyLzQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(346002)(136003)(39830400003)(396003)(186003)(41300700001)(6666004)(2906002)(6512007)(26005)(52116002)(1076003)(6506007)(2616005)(38350700002)(38100700002)(86362001)(83380400001)(5660300002)(36756003)(7416002)(6486002)(478600001)(8676002)(4326008)(66476007)(66556008)(66946007)(8936002)(44832011)(316002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MY3OkDnpyfyaO0I4fVzqwvWsM2Ki0SPIndn144Q58xKGInDofBwTS/Wq93A9?=
 =?us-ascii?Q?d8ER6tLnEjcxn57+DvnYY3eTqWnbgnY2jtK79vZLUS3soUgpki99NMbE0p1y?=
 =?us-ascii?Q?QOLooFxYPH8i9FWxO4oiJ2DbLZmDLPM64EhGySDqnv1G98eCsemUQbj7Z7eM?=
 =?us-ascii?Q?VjYsKOlZcGsQy++pCp9VxBfh5yA1iyeTGceZvgTteQyqIV8WEwRgaEIz2LUv?=
 =?us-ascii?Q?5GYwcHmG+vIgEkt16QxbZ6PAhheiILvhr/wLZZGw965qqSVhmtlUAulyLu2O?=
 =?us-ascii?Q?53CMmwutXlfvwN2jnJ6UjYFy9Vqikege8zQt6mWgrgPbnyG6oXS3rKKeK6jM?=
 =?us-ascii?Q?73dJwDXNI94ctFKtPjl2/46OOmt1AcNIkvW53OwDdeK6ilg1Ete4IiBK8h+v?=
 =?us-ascii?Q?f9WnuFm0WmoumOt+bIayvoPC6opqRkWyeeeSWsc7s/7xgJcQTkyhdKn7iH9U?=
 =?us-ascii?Q?wGWZBKWMzNvi11toNRokTMCXW3q58eYpN9szmZfTY/FQM4o7Th7e3ne70o5H?=
 =?us-ascii?Q?wZDn/uWYvpkcxbqMSAh5U5cMmnoxgiQCkBVXtfEiU+G1RqUKV5WRDe4AIJMd?=
 =?us-ascii?Q?i6Qeql4NEMVaqE1ZARWUUAo9SBkEZQHPhwGahN5oiw7Ts3j3Ve9fUctdleor?=
 =?us-ascii?Q?WP4+XuKiEYXCVY7CJ3C7LrHGS7sUdKeGxUm8fJDPbQafPPG7fYsX4qfmqkLw?=
 =?us-ascii?Q?6B3AqfNDNnHH0k4MdSOiJjB1eRQI14Ck71/5KsRFftpWw9cpX5/GdQQSfUAN?=
 =?us-ascii?Q?/VFEtEZmsRTa+jFxN/B3vg4xhD7OfBmHr+NjyEby6tgyPgT9cEWf9JL4Zh3n?=
 =?us-ascii?Q?sblGV0pSnD96CAoW1r/1GouGacT8ZdrH4s+kalK0CSldy2nxC7swvuahK+/g?=
 =?us-ascii?Q?IX0ZvuswUj88TaUlnnXvunizCULUcpt2vIXCKj9csjKFQYEoo5m65M1RJbVm?=
 =?us-ascii?Q?1C4x1Z3tcTgnTRoXwYQG9ErpO3QaiSwFqtN294AAyW6AAJpQojv1Zd9/4CBQ?=
 =?us-ascii?Q?pR7WiMJARDl3EY60RAzW9PqjNXA632+SzvQCMd25K7tZpsgje/RQHTBuyxhc?=
 =?us-ascii?Q?UZSvBphnSwyZXJbpk7ifWK18VbwYBZzkCspIbIhdeXC7ZTlzmPHfaS4G+S8S?=
 =?us-ascii?Q?IZwFiQgNGNSUtxkoNwb80MRmAxDGDwmKH1PI8SDj3jT86YiYWdbDKb1kA+Bf?=
 =?us-ascii?Q?xZcc13Vg+HQHOVayxtZr8fADYuKEeB2P02UzqvMfEJNJ37MQraKIbdiw61p5?=
 =?us-ascii?Q?u+QrJDeUT2/LXDfOJqlo1a1CzldO1gQO8jkA8Mfcbz7qkyWTyXOIlNlrxNeA?=
 =?us-ascii?Q?g7le9HRqAeZjlZ106tnQ9jnSvJZ4528cdKVVPAi+LthAP0Qb7naEFqilbP9V?=
 =?us-ascii?Q?BR89he2KEAqH5l1N5isjKHcGJk2A1Ipv1zWsgL6+AjUmwxiB28gon8iKBh1r?=
 =?us-ascii?Q?mLIm/TNQFyz15xJuZgFMAvFdbKj3J3JY336r5zHMosf2aS99qf0JHOjNER9X?=
 =?us-ascii?Q?Dhom43vg8UCH9Ol4A2IEyCLbywMfLuDNhL/S6e6myKR4ya+6FUxC+19M6rNx?=
 =?us-ascii?Q?TwQLxiTZ3AxEduO9tGJhlZpmM6uhg+Fp01osHoejZCBItW7d1Frnj2IqOtE1?=
 =?us-ascii?Q?QA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e55b853-e4e9-4e5a-d502-08da7513b3db
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 05:47:51.0422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eoY/vErf1ZwTIXtE3trUWpM3GWF1pmxND+cEuextDuE+rXa5DZ4+swxmGi4PhMoLvBWSprzhe2YofQzsqtaB7OkG5t1zxvXxyNY2kBpSi0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6438
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the commit message suggests, this simply adds the ability to select
SGPIO pinctrl as a module. This becomes more practical when the SGPIO
hardware exists on an external chip, controlled indirectly by I2C or SPI.
This commit enables that level of control.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

(No changes since before v14)

v14
    * No changes

---
 drivers/pinctrl/Kconfig                   | 5 ++++-
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index ba48ff8be6e2..4e8d0ae6c81e 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -292,7 +292,7 @@ config PINCTRL_MCP23S08
 	  corresponding interrupt-controller.
 
 config PINCTRL_MICROCHIP_SGPIO
-	bool "Pinctrl driver for Microsemi/Microchip Serial GPIO"
+	tristate "Pinctrl driver for Microsemi/Microchip Serial GPIO"
 	depends on OF
 	depends on HAS_IOMEM
 	select GPIOLIB
@@ -310,6 +310,9 @@ config PINCTRL_MICROCHIP_SGPIO
 	  connect control signals from SFP modules and to act as an
 	  LED controller.
 
+	  If compiled as a module, the module name will be
+	  pinctrl-microchip-sgpio.
+
 config PINCTRL_OCELOT
 	tristate "Pinctrl driver for the Microsemi Ocelot and Jaguar2 SoCs"
 	depends on OF
diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
index 6f55bf7d5e05..e56074b7e659 100644
--- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
+++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
@@ -999,6 +999,7 @@ static const struct of_device_id microchip_sgpio_gpio_of_match[] = {
 		/* sentinel */
 	}
 };
+MODULE_DEVICE_TABLE(of, microchip_sgpio_gpio_of_match);
 
 static struct platform_driver microchip_sgpio_pinctrl_driver = {
 	.driver = {
@@ -1008,4 +1009,7 @@ static struct platform_driver microchip_sgpio_pinctrl_driver = {
 	},
 	.probe = microchip_sgpio_probe,
 };
-builtin_platform_driver(microchip_sgpio_pinctrl_driver);
+module_platform_driver(microchip_sgpio_pinctrl_driver);
+
+MODULE_DESCRIPTION("Microchip SGPIO Pinctrl Driver");
+MODULE_LICENSE("GPL");
-- 
2.25.1

