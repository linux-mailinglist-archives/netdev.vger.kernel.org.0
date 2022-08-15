Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDD3592749
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 03:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiHOA4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 20:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiHOA4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 20:56:36 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2126.outbound.protection.outlook.com [40.107.100.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A92FBCB1;
        Sun, 14 Aug 2022 17:56:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMhNONdFpIBpXpaMlSuGT3+FTtT5cwoXounCGpiM7bl+DOoz9ZRbiC32Om5BqhXURmIml6V9T6o6QnmuFlO3KnrF9w9xB0pjeZKyUf2xhkGbrpQ4+/0GZI4y9Gq1YM99Sag8K5+BtEO+PCr2jTOKID0Fsd8WQoFVLB4SSgx9S/+Wu/mrvvaaEIjHgO53LBKkCy9PlAsEbTlxuWAMbjZcp2VdcDdToLGr3Z5BBqY3o/RIhn+CX+qvtP91nllH/sI+O7hDd3UJ3IhWZQ5nujd9ZgfkuIxnDvPI72JjjNxVlmLbFNPItVW0hudpJZwqbcIZAwX4WBPvzC9GT56nDcm33w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T5opAq0Wal163efo4bIJB29QMAdu4+IcusfP/GfBH4w=;
 b=ZsP64Bvl42Q0eVCueaTbBk04+O6V6X3x925zPr0o9sKo4Y5TXA4lgyRSN1zGivXQfYDLEl6HLDx0Q736yyI7HqpuAqt3OZlYJrC4yHhmsxblrdv9eFVP04RggLWsfePM7OPrA4WNPZ3rLjKJi4lUkZxGL2ehhH37bgsU4DYSmtoLuqex8l2Rcf2zevvBzbbKG8uBwe2E8ZaYwhOOIQVC4UjDuLUVdZi1lQh2t0TSyOQE+fX2qtk5y1pk8eLaW3cIDEh76at1gu51oiWxOYh26gG+xv7/adhOyMOSTSkKLhxL9c68YkrgcNMX3kxWNp2frTzME0fILRR60sqUjludpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T5opAq0Wal163efo4bIJB29QMAdu4+IcusfP/GfBH4w=;
 b=OyiQwDQAY8UvOVrP0IkMd+kp/CQyyH8AoZt89w9DlPVnCmaheEZPxXud58huI/xCaGl5Jz4U/dA/aqv47awjRSgJcuyZn/RMCc3CDW/dqgS6mu2OAN8v9yTn3OFxjwLSOSTlxFaH/Xuqa3UiIy/THQMY5+ZsH22z/MW6g3ecZuM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH2PR10MB3862.namprd10.prod.outlook.com
 (2603:10b6:610:8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Mon, 15 Aug
 2022 00:56:11 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Mon, 15 Aug 2022
 00:56:11 +0000
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
        Dan Williams <dan.j.williams@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v16 mfd 4/8] pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
Date:   Sun, 14 Aug 2022 17:55:49 -0700
Message-Id: <20220815005553.1450359-5-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: a2c45aa0-4bec-4331-961d-08da7e58f269
X-MS-TrafficTypeDiagnostic: CH2PR10MB3862:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q9Jk+bRH12gldUt2H6YkvHNyPRxymK6d4xRw1YtDxuTP2j+qJHpzjrIqLbfHobsDgwM/f4sTfW+0GbdU1xYIAC4pYN6Lk/XaH+lcILNLj1coYwVVvT9N8PQDui1k1hI+Bm2HoN4eDKa8AeOEffV7tuctbpPJgJ19vUmvCvJVc1b+vkiFlVfRwmIeVoZOWjO0Bg8ErNNRqKcviTtFEY1upibe/Suv88YMX8om8t6VkmvChGVCklYo2i++LGBzU2ur8Y4VkHHMRzhSPSq7K8WkhbRle6+BOdcq7uRT2cMMmdFZW86lkkZVgrUvj6BNepihliRv3JL9lK+hIvmBw1yhjDpAa0lpSunqXNIejFYG+mQ7ZVc0UuQWnzE3UUZeyyS2GyF9MuNWo+yk+oxMGxjaYKX4jMiVaFscFF4GVjVyltl6FOmhSiKlBXXxlEN+9aMu67KtFIGxhQYPXTl84FNN5J5gpDSPhHU2DOwFenBUaUERBeEJRUnBfPiLNDICXZ4oCItUgPUhfJedQ0Cj0OJLZwedND04Tbl457wduCns6hvZINgyfPx0XkCQXrVclhjv+jwf3BWyFlTC6RNMc+yBrTZZlOnU/yyody/g3zutLFx6DBBJgNpchB1el6ozCA02iVC8dp9LSRNaYA/a12YzEzwh/bwO+H4Unwrhtb3JSXhUllI77qogE6sB8K41BMJxa/+8nVmpNRPKgTEz4qqRDTldJlNRmV9fddG2+IJwnuMTzCeAZcZfp/sU8qfUdaeLHMm8/5shKTEX51pYvYmCunO/sXp7U/hOrEFUUxHf4rk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39830400003)(396003)(136003)(346002)(376002)(1076003)(54906003)(41300700001)(52116002)(2616005)(6666004)(86362001)(186003)(6506007)(26005)(36756003)(6512007)(316002)(83380400001)(4326008)(66946007)(66556008)(66476007)(2906002)(478600001)(6486002)(5660300002)(44832011)(8676002)(7416002)(8936002)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sh1jH6ruosWZjCSiXyKUUMnN+CMkIwSmkePG026CRmdX7lBlyx3Ebj3mbVlz?=
 =?us-ascii?Q?fQxLx9LKe5ZfeL68H5/i4HAxywPNC3+B8Od0nqMwRyjHyxN5KP0PIRJRsmG6?=
 =?us-ascii?Q?4/sGpBA4JH0nv8ptUHjgSP7G5GVKHOKAnjD8UuII3dGMO/trBiG1bW676Quc?=
 =?us-ascii?Q?IIJcOWjXPjyg4PRgTTr+T2BK5rXQUiDmur6J1t83bFAQK4Kqv/D7gZKicEXJ?=
 =?us-ascii?Q?yyWVjKuPoSTy9p4v6DhDnRpDno2oEYgZ9E7VdPBUsjmCumqj6nZaImgLLWyt?=
 =?us-ascii?Q?xmNqcVfb2N1/ZGa6gYh1Wbl/vT4Rq/uxJy3mCHDsW0J15HXZb/YPf+a1X7Pw?=
 =?us-ascii?Q?yucLVL9OgOj4UDRvytm+WzuyGK+MFBDNT9c65h47oiVATmps4mJGGfZAmF0W?=
 =?us-ascii?Q?CMFeJYiUrAVK5WkXDX8UTQU41UddXxRCeV86zQI6YYnUrpJVKUGk/u//D3EW?=
 =?us-ascii?Q?fdO+EgpsYmEIijkAt92VuzbXSTktipK8XKWnEOngZs2PotLk1tgNoc3TpE0g?=
 =?us-ascii?Q?5dv0n2hltxm0msNIvGmEc1/dVrqyRZnSK4m8kZfvmO68FM8NA2leXZwGzabY?=
 =?us-ascii?Q?NR8fGGUAWPeNa38gAg/wM6Fi6RBUfclXnZzpHY6qkRNzpHB3/9uGjaJPwJJ3?=
 =?us-ascii?Q?knd8iffrsUjjLcgCeGcLt37/3K54yLjGctUEculP+sS/uClc3rKFHXSNO4Fm?=
 =?us-ascii?Q?MzMSbIS8dOMPmThqFe4PcjY9Y//iWJEkGtZdu+WQR0uJJF/hRP2uQDbyd3+O?=
 =?us-ascii?Q?LplbDykqoLES+sFol9O+KyuDAjOQ4yiv5Fnzepbzzq34pLGHOTQb6Fw63O9p?=
 =?us-ascii?Q?bFyksyD19R+9EgzyZ9K2BQvvlPKbXl31vmi5bMKhg3qvgcnjY60IBwNe+5c5?=
 =?us-ascii?Q?EoX+tAPYYTHfNm8t4f5rtcgKrRjRKgZISYrSlWDZrDrTbWQZWCN2ZshZ2MEa?=
 =?us-ascii?Q?W1qsaWGpCSBGSOMR8YODNwvwca2rcnj1xA8f67IHDJrHCQbeN/fTOpNdmUIY?=
 =?us-ascii?Q?uEwDEEwhDbcx4ZPJ+mPjNFAvu2/tzmoP5vZpf/QRKJ/kCrrilQDbvtv7kY5B?=
 =?us-ascii?Q?3aXbU3EDG+iR+e6bOAt5ei4YnTP/+MK9/iLuu77LvpQZTiJ6nBOevxFGzXI6?=
 =?us-ascii?Q?s94fL0mCQDMxAxmr+l+wqcTHQyzZNWvKPYXu5S+dsdUZhMiL7GLAB2IhFxLW?=
 =?us-ascii?Q?6EyoPnB3ajVu8PvvpCXyYz3CNSvb4phZ+CR2wdGPnN02+fzC/EWSZ/sn0mW/?=
 =?us-ascii?Q?eyb2Cwb8909cniCxL9Dg0rY6dKZ88D5iyjudshEVCAKqkLnJlYRXnFZuTUbB?=
 =?us-ascii?Q?Z4lgoP+W0tG6FwqEwi0mkBYx7G4osaNWic8F7BjIsYIbMfgykQqy1JVZOq6k?=
 =?us-ascii?Q?LOBsu1nO4UswekrFOfC/fAOfE9/PSBWyK5Qll2fWqQ9tpk/ZxGeQ5cvpn4zh?=
 =?us-ascii?Q?L725tSDf5xea/RauteHEG3+YUfV5SWRS+W0Edd/Il9R7vIyJPx1fWoZZzTjL?=
 =?us-ascii?Q?WSTMkq/iJk6cE6tyvJEK33+85vuA57dBo+w3uCxiE4ekT8HDfeybgdJ2Tif6?=
 =?us-ascii?Q?ghW36XHCotLYUh2FACqlyiy8xmDgMojzn6tef+Ww4LlWyC7O2HbUE7MY/5xK?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2c45aa0-4bec-4331-961d-08da7e58f269
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 00:56:11.7136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sq8a5iUatvzX4MlKko4hpawID+w6aiuya8SiVzK8AhpG/6mgpYPkCUsgl1PWAbyT5OL+n6MDA6/B5bkh9Dqy4ggPjk1iRUprczsQUhWo0IE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3862
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---

v16
    * Add Andy Reviewed-by tag

v14,15
    * No changes

---
 drivers/pinctrl/Kconfig                   | 5 ++++-
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 1cf74b0c42e5..d768dcf75cf1 100644
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

