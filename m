Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC035639DD
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 21:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbiGAT1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 15:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbiGAT0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 15:26:35 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2120.outbound.protection.outlook.com [40.107.100.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA541433A0;
        Fri,  1 Jul 2022 12:26:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5G6ertzgo2U+5lAbVcAWlBv9Q4Cjw/N7Cd+bnU4RMYKxBQTqgNw+wQjZGD7BEuaD77yNhPzVrp3YoEV7mqZAtLjx+xR+dtKWinwB8OBtAh5C8CYUIaJGJNB7YgSqUF8ooV4k0LEoTdqn5Kx5zgtGyJgEUcLi1YWvPouUA2M+MNWGcPtGnIQnUMwbsVReWJcmhgPl8CuuhH27EBRGmC5zhOKsMqFD/VogMYwS9mhIpeob/JNJeOD2T9ajCF5qdqAImhV4dMCDSMQ0PacUtyjUiBPuld8AEU0s2xxtVXon/VRGPJONeixqyB0E8fsRs0+gFmLG/vmwY+cKnjPjSurTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4jUaz6Xbg3jv5mcYI5lspObxF2Ar1D8xIbjR6vjT8jA=;
 b=UXBIDsEfLRkizds2ykjdMyxQMixQ8VJjZmH1647L5PuQev9xbWKI6bv2AFeUO/EY+wK4UInpHgDKTebMuUDeZ/Hlf4i5EaEKd3JJ/eewqv5OhUpWD3DYCIBpPpQDvgBhVhE6TtTL7ia9zAcKoSFlXowVMw6wrt0FjSXleQnQslgeSEZBeIAhQ3Bq5z2u5zEOO95FGDnvw7gvfQGBuM6oFwM0f3L+x5zjwqNzFx6hGmDeooTUuTWgnnWtN6J6YlSJ2AGtlDHcG8dyMjUlQhnGZmK7h+PA08hiAjb1BLui8guYVTAwE84BA++EMikB1OBY8NvNgBVDFIEhpGurXxHvVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4jUaz6Xbg3jv5mcYI5lspObxF2Ar1D8xIbjR6vjT8jA=;
 b=NAICCWBgmu2mb+i4wv03nhufhQslNKosAgVMGEaoSugyN9NzYS5UjJDs5utkJx5U6eCJQ/GIxjucfLBrvzFd47o5lDxafMYgs3Y5axIgBbOi67u+ErWC13QKI9Jq59z0ulL6uFj8zYNbMZnfTnLhZtJ5hvFbp/NUTqQl9t/uZGg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR1001MB2230.namprd10.prod.outlook.com
 (2603:10b6:910:46::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 1 Jul
 2022 19:26:22 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Fri, 1 Jul 2022
 19:26:22 +0000
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
Subject: [PATCH v12 net-next 5/9] pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
Date:   Fri,  1 Jul 2022 12:26:05 -0700
Message-Id: <20220701192609.3970317-6-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: f09d29fb-d8cb-44cd-2c99-08da5b9794d9
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2230:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yKC8dV2AOED0ejCKvCy1TnrlNIUsOmBHkQLh3/OKAPKtv8pNBGc9GjMSZioALTtXAbqrivX8bE0k79zq3pTsOGfYYJDsizJZ7q09jYOOnDeN2zakNtxxV14+mVfzLuNVeRxqrlHem1TljZQuvCU7A+/7IEsgjP9scJcnAA7WId1kRK+Cw/W40yJny5e855NzipfaQ2n3ixXrMUMW6QYMEvgU/8dSvxwVK8GBB0Aysc5JzkYfda0PLngs+La3YMpcj7AEn2FoNnAhaVBKMMlxkzkO32WHeRCBtCFMIwtRBizkK+xR1TEdeKXMpm96kTDxstwTF9P8arHbQ8RKzVD6k4lK6dD0xDYRu0kpDGVPhCgrpLRbWqnGvTc0k1zH8EROOubYjCBctaxIwwlL5M1nGV5J3BqBB1w2DmPaPnDjFIE/8CafCtfVqU+NXiu6xilfYjTKSkponYE2pPb9zufSRDKX56J8gHh6Z4fy6fwzQZP8MHr3YYsREj/LLmKOa6IInaURUZIVyeCajHGi10XjvNRPkQRdDxnhQ6z96HssC5jZ4IUNXjFkl8FdpzvmIhxw5Qo8sJTXB/91FT8NtC3fBOFl+ojHbbyzTpVMnaAeEnvsnwrKxyckEdgP5CPei8faw7jGoQx+FVeDMTcUQ7Vh8LQ24XWdnq5/U/u4OHrtwCEh4JJtZiLCpDPYCUzxLQs/BfGn5Lve9sa+zxw6WQFH8GkxawCgTE4m8Hr78TznKIogjx3DL1JDfwrH/DtxPZ9ubhCU66GJJKzvZETkTUBvEU0uLMbMvzj3sKNI7yBScSo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(39830400003)(376002)(136003)(396003)(66476007)(38350700002)(186003)(8676002)(8936002)(4326008)(86362001)(66946007)(1076003)(5660300002)(6666004)(38100700002)(83380400001)(66556008)(7416002)(41300700001)(478600001)(316002)(36756003)(52116002)(44832011)(2906002)(6512007)(2616005)(6506007)(6486002)(26005)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iIG4WW1xbNpOZZA0S53eRdBJo6Gk5EiPkhWPrQll8MoWoVivM5WIZtcc8EQy?=
 =?us-ascii?Q?FrOACALvULzIui7UwcdhNEh2YohpT43vMULWBpSF7W1/z4R0QwnuUtF21JKT?=
 =?us-ascii?Q?4xN4n3s5VSlEHptfosvAt7lr9XY6p+ugwJVRcAkkfK1TPfwoCQENxLNNyOUP?=
 =?us-ascii?Q?4w6UollAZIgXmqkmXGTv1WsqG6jRIfEV+Ajsp5MWDZogIbOnS9nS7Nh6thci?=
 =?us-ascii?Q?3UJAXcib2vD/B2ttCwahhUothN6jMs2PkCqkLWPG4EC0PjL2sK5iwmGYRRM5?=
 =?us-ascii?Q?mRQhoBAWk3EOr2Riu6gwErNx9Nc+Qw+geNxj7TRDMTy+pPgUxV6OcNsyE7SV?=
 =?us-ascii?Q?uYz/+o+nWqfqogXkCFFl4eyrY1Pc9PkA7xHAw9eNtUCAh/GGv2lwf76CcdTV?=
 =?us-ascii?Q?SgR1JCzdpouhjo/CI9ao7qTb5TAucWyqfOqG5x6IAl9bofWjSjpeasxC8ta3?=
 =?us-ascii?Q?svbtAjiIcEjz6wR68odpwy1gmaEOX7AA66hHTs6eeueb4eC/mlW0+wlWWECd?=
 =?us-ascii?Q?oO6b+k0aP9c8+QEsPF/0vu1QAp55EkjCVu4sxs9qd9Z++hj2i8sFDDyW5OEo?=
 =?us-ascii?Q?k/aavQcwtQZ5TcevOMfUgj4tmbMpFvGkO7AtsbCVEvEftIBbNQrK+rgtykQr?=
 =?us-ascii?Q?xlyXOz7xJgqMm59s07rMxbvRnqJLmnCriZUYOuIzRUHgbAXLF8yfEsmNyh2Y?=
 =?us-ascii?Q?yqBgA4qEZ5iC1ztZlsiCALXgcAhQMmdtUGD0uZOIJxcl/uL/PSz8+esn2PVk?=
 =?us-ascii?Q?ECfrbuNjLFzYcheSwveaC7o4mSFkX3HnWgs4ecStLWTqMyQ3t/naLKY08X8r?=
 =?us-ascii?Q?FpCbvC/4mSdAHbl/gDyTJZNW2CCoXWVdd9GQXEDn3mdPoD2Ds/iZuKsYz0Gn?=
 =?us-ascii?Q?UQJudb3x+h1Rt7JCognRnLuNV/P6ih0IJLJWJdBZ5gR6Y9u9Dqv6YOBqHKx+?=
 =?us-ascii?Q?/lWGVsV+orLV8Homm697mctShqZ1IIpzZgY0pva1rG3+EIosqk6FBuXdV1tJ?=
 =?us-ascii?Q?ovWRxpqRibfxeRtUpdlK3LNam6zshI40N7NBee9GvRULZ+UWKLThHvv6gimk?=
 =?us-ascii?Q?uwhXdXtDaJj7AdebuZ7Pj/egumAKsHbhmteHfjD8rX2DbJfKkE/YtKXEyIRR?=
 =?us-ascii?Q?1WzYd9K6MgHxn2GGTOloChKzAN3IjUBgNB3WWdpgb/OzwSLRqheeVuEN0afl?=
 =?us-ascii?Q?qciTsIXek2whwQhfx9Q82v5fKKISZo0xXGZPCW4hYNDYCVd86fGQoQmZFCHb?=
 =?us-ascii?Q?jxpq4yHco6idBqf+P+mGElKbRJYDR6RztKj415OaXdTMIFEH2ei1xrk8/mH5?=
 =?us-ascii?Q?nNQrEduA6utIfvYsiZ0OSQkXO/NAX/3XZQE+wubMPNN0gI1ymnLivs/FZzOh?=
 =?us-ascii?Q?kBrOC+KZ8ODiqOiwbXMfmX4UVoD6wAEXNdz3X4B/6WMZWAouSbBryFHJmTh1?=
 =?us-ascii?Q?msaW5LMkLLdQ0PhSbjMxJjyDYL87hCO4VB1GMMMQi7W4tBotmMlxMs1dkukE?=
 =?us-ascii?Q?diIcXszbVMuH49h2i35DQ+OAlkIT9A5ZgmkA9Nh1jSPz4H5CUWWPNxDE1/f0?=
 =?us-ascii?Q?CCnaBwJbie8pQ8SW4yPup7x5YLsWskl4pmKy3AAdU1sKYH7O1r9vW4fRuz0b?=
 =?us-ascii?Q?dQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f09d29fb-d8cb-44cd-2c99-08da5b9794d9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 19:26:22.3671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ApCpvCjhbQrID0o5s77+xkThL//7hCZtwmtb3K/yEDqOksSGbw/ocs2uLb514cJx1dJB4KeklFtxS4oug9pYsbZVZ8ZoADkI7IC5R0JI9xs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2230
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
 drivers/pinctrl/Kconfig                   | 2 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 257b06752747..40d243bc91f8 100644
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

