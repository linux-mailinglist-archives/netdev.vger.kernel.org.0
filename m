Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8AC5678B6
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 22:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbiGEUs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 16:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbiGEUsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 16:48:18 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2094.outbound.protection.outlook.com [40.107.95.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D735711142;
        Tue,  5 Jul 2022 13:48:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ls7ICjpjtInlTfCEcKKiQnwt6Abyx2EijSE6i79B7boNRqjHvsatZHRdOe1DLtFj1bQbhTfz4b2k5H1OhW7qBdL/WIvq40Yfg0rHgGvXlh+/YyzHMs2/9I+Uspj/5TgDB87AS2yLFoLozkTHjXClOPlaItSl7GIMkbgEP3m4mb2Jgbu7twRfzVTeffQQr95ILvDCZOeWnQKUkXVp4lQ1vLGwzJpfDUtvc7GBG1ATvEH0KRBU3ZNQ5C0W55lUhGjSNjfKC6Wt84ArNTqdTTT27hRXz8p0Dp2rcu1ZN9NgsUicK130Rj7Fm0drJJ/owm6LrdNJShPOT44YEi4aZDXlqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDtdjPOljDaYnS77m34kA1EJPU4pciTzcmeMhp0u6n8=;
 b=I+nkPTLIwVOE+xAuVOixdUsyHLdZJahddzCWZU3EGIQTEJwSFu4lSPS50+yMx43H+X03qsZA448i3PB3RbEdOfeMVsGGtjspB5KAqldzd7w5gdCEvm8p2jLP/iDai1yZk/pawq+GUwsIl50yGD0A2s9+GkiKtRcdoy++Ni4b1DpYSWPLj8h9hieT353ZfJwO02SY9ZEztBCMi+drVZPlZdeVdN7orzLzL7Fp1zBfKBJsNMNfueAbgp5DORWA8IOJukRzIBNvcP9yTrPWl+aU3Vmueuq1+J2I0vPeSFIEG2KeEAJRbRpBckm+3YxVENRlIPQcmrrtYOqsz8jqMCugSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDtdjPOljDaYnS77m34kA1EJPU4pciTzcmeMhp0u6n8=;
 b=ZkN9jQLEUcgWGWC7HMDPZXm+FZbjcO9mGfaHbjMTXJI7tSd9roladLtZgZCS3DhrykODGHX/Pu98ryyVi0P4fFvCohOVG9cNivOom7FgtkuWB1cTeCUnAhCKtVeaVDNe3uc0pDg3BH+ul31mZqKmbpmi7cjd4wzE5424zko6wKk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1934.namprd10.prod.outlook.com
 (2603:10b6:300:113::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 20:48:13 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5395.020; Tue, 5 Jul 2022
 20:48:13 +0000
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
Subject: [PATCH v13 net-next 5/9] pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
Date:   Tue,  5 Jul 2022 13:47:39 -0700
Message-Id: <20220705204743.3224692-6-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 69ee0b59-b305-4639-7ecc-08da5ec7adab
X-MS-TrafficTypeDiagnostic: MWHPR10MB1934:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IwguaRtskkT8sHO2JMpGiBi/qz/asgnsuDrOSiAqy9HcIxjqy5aeCv71GGKNezoGNMIoGjHtVb88rPjzQdTw0S/XkypadVB/9wq9UxlLoDVThQQkOzhAggihzqWPTQE5PfMVKi0cNGew2UvzHEYT02cw67x3m6IstauDQN5ITquU35vTZulsHI5kcrYG13i67v3UrOHlB1L6g2HX2TKw73lNleL101MOzPKEhurU3vYjtdhU8b+W693K7Z7VJdfe3nvIf/8v0UgzH8n4f8R3/cwFlQ7EFOdLc8BbUmqL1Oc0NyP8D9QUrkSauHXDUWo6TUMrMQZuLnHQ11zWOCJxpOzmNEJkPmutCBcEMCs4jwKMzplPEzLZSum8pLZ2RChfI/PWvKKdm+dZtpitGCBUP3xb8Ukx6uHgDpbNDaTO4muihsrEQsW/IXceoHpOM6AOXaPO4bETsSfZqweIebdsda2KeCH7rDAaaIKbFKe/IO41LMMZtwng5X7Xlrs5OtyVsTPX4gl8DOkaKLANRAep94M4raSMlZwTi37+G5mKck2Y79o6mDgRcKG3rvkncG9qTEOHIDTne+XcVM1bxs4U02ToDVXoU4WCKXGMzhFPwKkbORPyLbQ+14s+uKLpz4rKi8c4OtJogQFfreVThlebyl3jCHasQDRxQC//DajQIECRTrXwzDtFfofBDhlM/70ptFTXaoZGvMPGIslgMxs70h9YMheLCnFuDGuIJEJPkC9pejePyV/XdOUCWvEFLAhQjQlTsREJKEtP+Xwh0QZnx7ws4DbbZkdTlzeNwdrdOKg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(396003)(136003)(39830400003)(366004)(7416002)(44832011)(478600001)(5660300002)(8936002)(6486002)(52116002)(6506007)(86362001)(26005)(6512007)(41300700001)(2906002)(6666004)(38100700002)(38350700002)(2616005)(186003)(1076003)(83380400001)(66946007)(66556008)(66476007)(54906003)(36756003)(316002)(4326008)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1UWvWVEbRpzeB3rZdsL12wntZVIGiuyU7ucDqqeptAtq6+RhykTn/0f/N7wh?=
 =?us-ascii?Q?caXMN4t6kYm3v4lkLWIRhthC1YVj3niIWSAQkKV1NUnCjnvunYSL4V0/FCeZ?=
 =?us-ascii?Q?JTgIeddL4tj59Fe/5Ow/WR2xBKzZaZ7TOyRdxqsURMky5+OZFLBcIozzPqdr?=
 =?us-ascii?Q?gpfO9y8FGEWUKCAoAq5OktGbgwTZ2wyA6ElqJV4FTxy91K1WzRHstWChAHrS?=
 =?us-ascii?Q?91wfVyZ9YkfRVtE8i5iV8IMMFOI1sISNZrMR1SI8RySphn3hTEiXN0KPgYWW?=
 =?us-ascii?Q?R3rbQL+YS/g5vn6zTrrVBMTWYHCb6v+t2lO4v1RS+JkQRoGpiXm48rvpGETE?=
 =?us-ascii?Q?Mi6rLtUUqXgWCpzyKFguf8K5XiaRgvhPE6TQMHpnjv75RS15G6uhy6soebKZ?=
 =?us-ascii?Q?LhMi7wiWb7+ryLZCb7jif5kTARo8sP1RZUpZgtu/WMkeg9ATBw7P6FpJtVb4?=
 =?us-ascii?Q?m6sAeDp+V4YKQLOCw1vJM9livn63s9g5LDoeSbALPgBFnwe+hywh/OxEi32T?=
 =?us-ascii?Q?SVlprlUQLfbueVc4b3wiLzAMyx1N5IXpbD1fv6Alq89FZosrTykzg5NE3C3F?=
 =?us-ascii?Q?wkAOtNEQKIVPMeCsvNRbSpeN1DOpiPDXp3FYhS7rJsd/dQVhoUXGmX+GcgxA?=
 =?us-ascii?Q?VBDO+FNNYASFvTnSl/QVJYtzbzNXwVaF3cx4SZvKxw81jJTzfw69Ka/RIdAK?=
 =?us-ascii?Q?DI+xNaeoZXwYjQmtJ+uB1I570q7kXq8dDA3mkmQm4j8+q2yuazViixkWCGID?=
 =?us-ascii?Q?asbnAD9pqWK7hXXMs8y9LUPSrGi5Z7gJaMmBjmH4bFFtw1x7ulw+/vLKzZWC?=
 =?us-ascii?Q?F2Vg1AKtGC3l1Pqlp3plyA9I/KlpTGSd3pLxsXhTdf7pzRntHkZXgMDmyrGK?=
 =?us-ascii?Q?AU/eVWTD9vteg7xd6VX7cvi6n4TFxLaOhN4wF9HnJaaHy3tmAE9Keg0oMHMA?=
 =?us-ascii?Q?2EidYT0+qWIwor5VKOnOXv8ky0TYf9Usaz7MZsgrpzpkYAuDSjuX5bD2IpA2?=
 =?us-ascii?Q?NvwOCIJl9IABH+eelss0opI6GhEEw64GZaKzYNsRw2cyqF2EgYo7j/aOkoox?=
 =?us-ascii?Q?ZRmuByshTpJ7GLnvODH/6vkeBHk9kyCwYqNBEQdZdPB3UOGOatJRvcTYPBK7?=
 =?us-ascii?Q?WFId4hX3HjOU9rdSmClvQl5uapeLjE/Y55yRG/XsZPeLlV8Rbeys8cqQalTe?=
 =?us-ascii?Q?+zi9bjU73cazoOAHucfg6nyaX38/o3Gk0R6hP8K4bxEUpxR0CWMiJHrywLal?=
 =?us-ascii?Q?QOvEoqMNYQPuYLDSYnnaYeF/OYHcJOsxMTXAXyatark5/lPa4QKf8h79h1Ky?=
 =?us-ascii?Q?EHg+Awd3bdr1JC2CAoTKRn+CEWgmazaNdadlaYXRNHgwF7hx+r4WWnUbUyGL?=
 =?us-ascii?Q?fxXi0VbUL+8LP96KR5qsbHFoE2gVAM5JPYxdV3tCJl5Txpfzp/N14gbu6ndY?=
 =?us-ascii?Q?JfMVh6R7aYOcP1D74wQiJkuPiHMWN0UHTcVoYCHvGyxFazRzLag9z8m6G2TE?=
 =?us-ascii?Q?H4rqb/RxrJAGE/mHA0X64m5mJjaytmK7MhwvQ17dKDCqMka8wDJA8yfyAA3U?=
 =?us-ascii?Q?DTpT9XMwZLp9Lx/MUFvZpVQvvXsp+TMuBigZ1GYt+WRmEDXEgToYFeRbl3o0?=
 =?us-ascii?Q?qw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ee0b59-b305-4639-7ecc-08da5ec7adab
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 20:48:13.3577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fZYaoK+J8KqIako23iHHmEGtC2pM+tfyijG1I85DKKouLaxH1yqXLixYnZQ5T1iADlAWY20foOJ6dsHpaelcg2Xagxv3ei7N/a5ZgxM9Kmc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1934
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

