Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65EA5AD75B
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbiIEQWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbiIEQV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:21:59 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2113.outbound.protection.outlook.com [40.107.102.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04F05B05A;
        Mon,  5 Sep 2022 09:21:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBqDV5xJlgiAjeWxk1CRnu82KFzGoB53iqhWxqHhur4mn++d/VxA0+v9erI7XNOUbepjlc52VM6fp05Cnfb3UeGG8A27wwWDt0sjBhMSm1SuoxeI5ungqjhxC6cPN2yUfI1F0oTnzXwp6vVwxer8FAaljejKg3C2S1oZv6bx2PIgvQOCv4nZ2dgVzf9KuaLbGbhwxKIRFCkO4wRO6hl1cw9g5kJg6MxWHxcKRpoJDt0vw6jSY3f6ebZsPBAytTNrApymrJr93+VFSQgi2/iTtykgl+4UB2vGmsxb6rqhOUZ8+fyMBzwBOZroBhciHqPeoXgw2cl+09CRabFXfit54Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T5opAq0Wal163efo4bIJB29QMAdu4+IcusfP/GfBH4w=;
 b=na6ehR6xLGVQkzWDraTeSncw4RdsxA5KhtLdsvAQMRHEiWmiCT4GESNcSLInS4MO585L1cNffyWzsZ3IoQNWVKdm8VOjjr/RSuZ2v9dM6ajWUOMEoDcp2bcwWlKv6erGoj1FoBtMoJwm1kOTAkFAbx5nb16TO+l8vzuPi5lIevCPkEN7tyzo8J2nb6/l/XTRm2mNiENqD49wxdGsyOQBlCr6TwnCJ447351eFaCn5OM7UdddfccLber0maRdHdBlVCoZNIF7mW6ZILQ4LgMU1lLGy/xq2LqKvBJrbqqWwqBvtAkphvst8nSSr/biIODyb7PkAgW4nlinMVyuAndbZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T5opAq0Wal163efo4bIJB29QMAdu4+IcusfP/GfBH4w=;
 b=eRI0AypvgWBLufg9EBhe10/OAJpu8dzPTsDbUbAYhOmj2sK74kEUZmMiGBY3VG8U4Fmft+L8xOXMQAJpN6ixyNwbftHGKFmG7V1Aa4BHayS3h7VsfgCFnUtJt8L/DWLBgei6MY9jHSyU3F2kav96JdPleU61Rr270enntuYS1VU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB5848.namprd10.prod.outlook.com
 (2603:10b6:510:149::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Mon, 5 Sep
 2022 16:21:53 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.012; Mon, 5 Sep 2022
 16:21:53 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
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
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>,
        katie.morris@in-advantage.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [RESEND PATCH v16 mfd 4/8] pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
Date:   Mon,  5 Sep 2022 09:21:28 -0700
Message-Id: <20220905162132.2943088-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220905162132.2943088-1-colin.foster@in-advantage.com>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0263.namprd04.prod.outlook.com
 (2603:10b6:303:88::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e0f9bbb-de08-44af-1e9f-08da8f5abe47
X-MS-TrafficTypeDiagnostic: PH0PR10MB5848:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nIfGt3v2+ylqeZ9izDQHzHaiIrCOXtk5rdur6claQXHVJ8yW3hCRA3qx8WGsZ5TKzTy8UklnvGjFKZkq11ZSNr/85E7FVZKar4Ndx99IetYKb0Jlz68qxBFDo3CXzA7ltBsyqpMbj/Y+H3mnKxdMcX6aD4I9hoa4pPZaVfj7MBkseElTMNwC6rM8jAdbIsAFKYNLa1WXv07Ok99K3NLn4AU3khQYRfb4KBMXvOYva6+/8Q3rfk8pZkvDB29qKXZZNwdGYUJhfEsNa/lkJKUFNJsDboHlc/s+zm+JylKGmseaeBrBhOsLL41vU+qaWhtC4tl4fxgYUyoFGC5pHH9eGaoQXG9BOvyPzLyzPaE6L5J4QQ4eCdg2/DxR2Ss2Gv58PqrlcJzUBW/VFaLBcAAhFpSlbh/zfqdZBQk2+le4OhyORyUjXU7+BqIcND2OPGkyZFfZYltEWHnMXPuG48db3bXKinSl1LD/taEoQpyOCBdWk9eP27AzZ+DsvnkjFpXQ2rjNr003X/q3C/o2RlK/i3qZ6btGWKK/AZwaxtCVfYetEh6VLfrIs30RtVsXyffawAGxyv2v2B2dh9pRfTtt9M+QUP2YkrEalecG94tW+oYgpCQlLacvtljJJIWnzsZ98zT2nlG0Y+ElLEKz+zGDUxXIJ+R1FMBXLjKZ8g3hggZipSuGjKjjFcjOaZt27LwX91NJixP3/gWE24CTfIzCyF00ODkUDBZS2I4Mv4GQGI54xNpQWDvRkiykYh7s/9OR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(376002)(39830400003)(136003)(366004)(66946007)(5660300002)(8936002)(66556008)(54906003)(6486002)(41300700001)(6666004)(52116002)(186003)(2906002)(1076003)(7416002)(2616005)(44832011)(6512007)(36756003)(6506007)(316002)(83380400001)(26005)(38350700002)(38100700002)(4326008)(86362001)(66476007)(8676002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KXWebID8Zsm0EBU7U5EhUPnQ1SPvle7Ei78vas6nsubC18fINTkjL8EaZtm5?=
 =?us-ascii?Q?+4jsBLz7ZSvg/GFoyYMZufFkGnb1LE1jB7WPnv2/Fefl29+/Mx0VYdhE6Umw?=
 =?us-ascii?Q?toDAZsYxxd7BYkZ/E7a8UI9MnVQWq0YB8h4xL4IL6lKC+nM8JWdDqavUydDb?=
 =?us-ascii?Q?AB8pOnuRuS6ATydXYQD93IyHqjIjf5nYN1TqKHvzBvBdPp9MjjSiM13yEsio?=
 =?us-ascii?Q?679GwI2KWN4GvClchAjF71zOxf5ydtImNOyyM31ADGZmwajXKqFrgZejRMA+?=
 =?us-ascii?Q?dai+HqTELUQRYX8u9ccWQ/SdsmZpP5WIzK78Xq+iARN75Zc/U/zYQc7W8vc9?=
 =?us-ascii?Q?EjPJR2TRKZD755cshOfdhHtqD2+jKQS8GZj7260OM0VtIGs7UN0mrJ3ikFZ2?=
 =?us-ascii?Q?FEyz0DoFx4hb+kLWj1ZETHtTNNKC+LEoL6D7YKtZx1+6WFlJJv5Xr03BXC1p?=
 =?us-ascii?Q?ujWzxvbf64qsNgr1aSHKdGHCwqTdH29XordqAiGR7pKjT5ANNpaiBs/a99/f?=
 =?us-ascii?Q?V9PVTmh8FWmP07zbmgBm1uTv1Y9K2RklDr67b7f/RRYrpIWinFFe04m7O+dn?=
 =?us-ascii?Q?uz2a4nyH39iiTcyFZMlYy7tpDLaHq3UQvntOuhD0qnL2WHS+hj8A3dgpIetE?=
 =?us-ascii?Q?XTNWWCMq9fUrDICzpVGzu9q9JlKZNL+GM+q00bUFNG7mRe9PaTxUaSqsVhdA?=
 =?us-ascii?Q?3swq7/p3oxRHZKwyrELHalKBjFUZNtfuKiA/hdaYDXKFjbdxrwhUmOJJg11q?=
 =?us-ascii?Q?CTqjarHhtP6Q84pBmpkjehX3aOGWV2qlwBrYVAq8Hfpmb06+EwfiB5pSflx5?=
 =?us-ascii?Q?tLw0xdHoGVOz/87tAWWDLSKWPytkGBn1KrA5zrcp1Pfn6jT8xue/K62+YWZW?=
 =?us-ascii?Q?MznPR/M3v871klawRr/F720v3BWgj7M0lQqF3GbyGYfklWlAS9t8kmH4PNOS?=
 =?us-ascii?Q?3Gon965ckpkT3STIsr/IeBTirrGk0o1Ts2vZ7D0NEHXFQLWvtr11OcBjxJW4?=
 =?us-ascii?Q?xDeYeqAajHUmhy0MSAjQTv4s2QdfRuIAEvc40xkZtH8GILJxqaGUzCsbUsRm?=
 =?us-ascii?Q?V1IYW9Va6K9dVZULfiMcMKUW7vExyT9uRIuCK50IZwDVlBRQY073h5FIURzx?=
 =?us-ascii?Q?YdbIaKbjqKgC60P9ef1/NOdaqTUFbbzrYydALgutLA3FyH4AAHC5SayX/BAh?=
 =?us-ascii?Q?oA5jFdcNEmNmS9SLWIomBDIqffLu3ZfrcKolzBzpZKZmehT/yaXFRMtJlNPa?=
 =?us-ascii?Q?12secBG8vNqGErfNSx61bvMgceATMArnqS6XRMOYRpZ/HPdmeRA9AGUOMq7V?=
 =?us-ascii?Q?VxqOxX7BDKUi1PQCHoAtScjK7mK79DCh156W2h/Fuuoj3gnNpzQBs8KjN5QW?=
 =?us-ascii?Q?unCx3TMI6fnPKOqXMEiNWHLl3M+DdPuoK7bhK26CUe78XG4CXtOYn2+dbZiS?=
 =?us-ascii?Q?tohCwi4fslQSg4IboG2Y1ISUs+nniG/p6ZyQv4aslK7dx2azL3k00xZao1AS?=
 =?us-ascii?Q?vFhxTe5Agajm0sgwUTxfzoBoA9C5esspyA9Zwxo4aYHOta/qnBZOF7fMrPx/?=
 =?us-ascii?Q?m8YjT05r1xvj77fgFk/UtLKla2UP9uB5gBzFmliUBbVnOZwz8qPx/twZ1/i0?=
 =?us-ascii?Q?Yg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e0f9bbb-de08-44af-1e9f-08da8f5abe47
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 16:21:52.9913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DxMwj5GgKsquFZmDZk8vPAnxkuIsDXFzgbmEQNYtqEDNUfJLjFqDw4tVGrgTX/rv4Cx/bDwa75bPjv0uGYspkg2pfuWjsdxzK8JyeJxOmIw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
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

