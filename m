Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42515886EB
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 07:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235999AbiHCFrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 01:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236006AbiHCFru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 01:47:50 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2121.outbound.protection.outlook.com [40.107.244.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF8E422E3;
        Tue,  2 Aug 2022 22:47:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPt1LAFvX653SYKycQU23JpSNzS7TRxDmgS+VXLMfHvFqIRerBYKofkirJfJzoq0tqJcxF8YaIs56DdfsgA1FTVnEwP3pJVgpPcF6nnFYLSlYk9+iwfMc4zKQApkaZOHypF5a+BYeiWjBMKvE2dGY13cc4+D6Y80gK8KOLQWRfYyV7Bm+1xX9ZyKQIHWV6SvHRozdxHOdPkq/GWL7Zvbfv/yND1QvPsHfIOvPgYkZbn8q0Qr9wcu6qFZbQKbYxHdThC978lUMetD7bzTgQ2OpGSt/apjL9s3tsIAVBSy3WpSw6ZlWxeikpVQ6rZOpl7z8A+WJSNKXhIp2ILsEjq3oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ONhj7qLTGlhFD69mVtCxhS+oEMNKIdl/tpoi1u9Mmw0=;
 b=E+tyzhIJhvioB5iw/sHPb6mqCBMmnoNlUniG8f8UjQWe7h36CoDYWdDn8KAWmzJ/MDLuD7xmCo31sPpSEZ6Wv5eRl/8qzoUoH/d7K9vdu7P9Q+yrzZIzCAi6/pz8Ph0gUB4CqRj8Yn3UQvtbN7GJjaAphJf1BZG6UlCgrKVEbR60zAUm0aqvvw/AzUuPfJeeswKQTzOkJ2Yhqxb96rCA1Xyj+Zxae7Mr2YcOcc/MVp216MJHT/pCOjFdnpDC+coet0jyM5L5a5XghvCezhAGCO1txIqd+mIxz2N5hJgRIcdikCxV7HGdZgH2C9c8ALFWQJrNDfbHyA754G1C1YXLdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ONhj7qLTGlhFD69mVtCxhS+oEMNKIdl/tpoi1u9Mmw0=;
 b=rO82DUWgEirhixFav0ZNCKqs3SBQHcWfQ+pMYcDNeRUFycUZj1Vzy/JLMEqQimiVDG2i3RzYndC59u3IhzhcI/l5/3vFtcxnkm+dQYSjqxcCRMRDPnshevt11YMqgVeeJo+DjoR2LulVekGVggYPzS9I9HLinE0JLSDXUXREyCQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB6438.namprd10.prod.outlook.com
 (2603:10b6:303:218::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 05:47:48 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5482.014; Wed, 3 Aug 2022
 05:47:47 +0000
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
Subject: [PATCH v15 mfd 3/9] pinctrl: ocelot: allow pinctrl-ocelot to be loaded as a module
Date:   Tue,  2 Aug 2022 22:47:22 -0700
Message-Id: <20220803054728.1541104-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803054728.1541104-1-colin.foster@in-advantage.com>
References: <20220803054728.1541104-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0026.prod.exchangelabs.com (2603:10b6:a02:80::39)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 859cbd7a-a4dc-4c09-7e74-08da7513b1f5
X-MS-TrafficTypeDiagnostic: MW4PR10MB6438:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9RjZYdOWhALZkfjonYjKJE/KDAIlFMVoxFrrfHhVhFW3dk0+OV4vZWJ7B20Y/n4n7X16n4C6M5RUkaVNTSepVQnZS1w3IxKLxD9X8VU2ngCdiiVlMPAgzCh30vc0AE1+OL8UIvLVQKOCg6VzBXkTuzFCeWDI+6GMuTxkZiVG+chj1WnFqb8JhIpDdh2HTp3FMfZReP7AqH9vMlx7mLaBD1WNTOFEkD0Y3Mjko6Ek8WP5SdekUmQHeX9eJsiHwHXRMapYu9fTJ2QsN36sfl89aS0gHgp2rHeUPNNouFUX7w1+G7U/zP8Z6y7nKuDBn7VpUuCivmAaEOh9K8Hrj5pQR+MCE+AGiqhMpYu3ER1NddH26LVu2+S8w+K6DYYs7YmQhjNpmMJO846vdPW33Ak5bQ8d73mj57iR0PF8CPoWvAD9IUwdPbncIa62xc3YzENL2MhJtGUC8WnjJ6r9IwVaFyfHiq19N0gRgwcc9lfn3V00cRY/nGDEgmpNT4dBFiUVv7dN5sGe0iBZvQF1/M5ry4fy3JTXl9dc+Kbpqp6BpjpXX29J+YyT1KwAa5O7kfCucN7MhZwG1FmjuPlrYnXDJtZ+UPkaDzEAUrjXp8TjQldYA1oqdL5ZZM6UwLz8Uf82elaophVeFl3FcctdxVzZjmfeYYDmeuSI2ZdZlEDyAreDJCF8ePgEv3E8pxKvrCQLLx/fU/PnGGSO01s4jcLIYayzUfLzgssZ0fnggxfccQSwqZPUDi5QoBnnCEyAbfc80H1AlqcUvP1oJlXXeb/ZxoTctKpuJ95ATsJ0mBo+//A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(346002)(136003)(39830400003)(396003)(186003)(41300700001)(6666004)(2906002)(6512007)(26005)(52116002)(1076003)(6506007)(2616005)(38350700002)(38100700002)(86362001)(83380400001)(5660300002)(36756003)(7416002)(6486002)(478600001)(8676002)(4326008)(66476007)(66556008)(66946007)(8936002)(44832011)(316002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?puo+tDmrB7iIJ7ifHNJ9BWcIdpAfx3Qc/MsrxlnRr4x9E6G5YpIuWQlv1wXL?=
 =?us-ascii?Q?rptecDOi6uK5hEqOt/jdKvW0ZQJ/TTNHMJU8Mvdidpq8//UHAugMxYYHSw3/?=
 =?us-ascii?Q?Pt7+VjFUmFJWDm9p2jIMWQze9Fxbrjt0JuM8AjOYAeOKAdhNEz1XCVQ+VNjZ?=
 =?us-ascii?Q?jSdl13cIsi0dIECgrTb7uSgWb5ruKe73usWYD/8jALbKYzdFTOZr1kyATAP8?=
 =?us-ascii?Q?XW7jjNb9UsQT+W/VeXpZ1dy8KBAsbUAyGF2FGpp773HX1lCyfl4eS/iZxaQM?=
 =?us-ascii?Q?SeVoBOyiBghU/FFP/RLfodyh8lVn8F1fbzkyIz9QCd0OyGNNedhsori16unh?=
 =?us-ascii?Q?MQiYUZULZkyuAvZLZooDPHKNU4idzFFVw9hxc6eHZn0FQV2xZa+aLek1thdE?=
 =?us-ascii?Q?u9t4Z6+Q5ykK9iv7WdC5U2jU82TsQ2cSNIOHC8P35wFD4fZ/O7VPgqx7rf0S?=
 =?us-ascii?Q?6cn56r1KNNZmd0US+g05XBk+6AqWi3iDy2e64/yzorqNQr3EgsaNbUg1rSdv?=
 =?us-ascii?Q?s9J6cQ7L6gzBW38iJ67808fOe/4WpLuGTMo8S0cWqohhJVoViZzBNByKfnq2?=
 =?us-ascii?Q?qt/DdihqBP15rMBGR+VrA3JfvHwNlZClSwkqtOgFnumVTPgnx6/h4e80dl4E?=
 =?us-ascii?Q?sbnCqpDHEWOrcFa8NkCzbCDhpc0aNmCd78ATjZ8fi4BBvd7We1ZTj8lWCKzo?=
 =?us-ascii?Q?aO+Iv1ey/wPu9R2g8l2lgAwMhmxwJP0qqg/9PJp/z2S3NvFgetiwS+vVqTrk?=
 =?us-ascii?Q?dd25rU14ZGhur9ENe+hbwHTcZJd2QL4mFXDjcCk/vrvHAQeIdkiMithD2b8T?=
 =?us-ascii?Q?g1/bNoHT2GGNyjbP7/xWaBLvKiWgc+twgETlT03BLbubsggERLXfWSYY8iDd?=
 =?us-ascii?Q?2ywLvy0ditBC8wNIEZaUBPLw6tkcTe99Bsbo3NR+SsNLqFUKNONU2dD6C2mw?=
 =?us-ascii?Q?ormtU0LxWYxeGD58iolU9srBRj/u2RiRuT1X3QBfWBJkRviIkwpou8Dk8Rv7?=
 =?us-ascii?Q?3NUwcCu3kWzJwd9V0XGqFesSDco1eQdoAKxpyCKlkZATETNgpOJILCDLScEn?=
 =?us-ascii?Q?J4jKlOW34KcdbcMSckpXW3cAVD24cExi+k5cyWJ148bpbFW+0nFr6yP4eiCW?=
 =?us-ascii?Q?eJlZwx0FBiqLiruCwWnipPVX3jhhCq2a4b3NSoxT+aAzOBue3NRvghGPPsxE?=
 =?us-ascii?Q?a/66UcT+Rp4bXASzf4TuVzR/43BGCOkgwRQf2TtQmc+kfXlZZ7Ec5f3hg9mJ?=
 =?us-ascii?Q?YpjNRZUvpSnNXnvijJHWZjPhtLq5xH47y7vDa7iQUGvFFBU60mhygxOc1Rb6?=
 =?us-ascii?Q?ReRSCfpYsIvT76zkGArF/N1MrQTrC74ZrlpKNsqezQNqJihEQOU9bsXvOn+a?=
 =?us-ascii?Q?OFZULwjb3OnCEBs+QR/z+SFjgtMSv7x5VQeTIu1KyOXGSwRI7Kh0WVUolEro?=
 =?us-ascii?Q?r1y65l7bQM/kM0iR5YJnAlgpmqLkfzQ3i24561GEgMwFtEHpbup6o/YM+pS9?=
 =?us-ascii?Q?XzOOKUGVZX+tvnl7204MJLKDpv9oHBTFus/yFN0wxfb8wMct1THF6JsMhMfh?=
 =?us-ascii?Q?jldaxTdBR8B3Bw7zgtKKag8b78mPbzgWP5UhKJLLXpYVYEaybi32vpp0pCjv?=
 =?us-ascii?Q?Qg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 859cbd7a-a4dc-4c09-7e74-08da7513b1f5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 05:47:47.8393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s6DePjYlR+AVsHzV13oBUKzy7DHaOSkWLKn3a/I1a+Ss956aLSU+f7g0qtD6prHyUqbZZG6oQ95m28R0I+2VyVu5i84on2L2eAc1FhlW05Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6438
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

(No changes since before v14)

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

