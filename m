Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FD951EF8B
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbiEHTGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382416AbiEHS5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 14:57:22 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2115.outbound.protection.outlook.com [40.107.223.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21166BC2A;
        Sun,  8 May 2022 11:53:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pp81Js4oveiF982QmC2XDgMRWXUC60Jo3ljBJJoa+gpx7yBgE8LCfdKeUzju3PtAveuMbcH3DYfIbQzNlB3SIpVxk143lDAgE8SXXdY4cNGFzwPoPd29H7mmu0uxGXoB2Wl9f8vM1ecOqWAUBvgjGnWy5etjvmKiskwTNDGNbar1vz/4HJA43NP9jGssGPsSQPXehcc56V1QHSZ6l7wCnpTZVKh3uPLjGKJ5z0jbB80p5V9xVtSEDAL6gNoClngFFmSyIMXHDb7XByNbqUbVTG5cju0KNOva2Cm8+SpZKcdWKfyNj9u/gXDLDHyxcQ8HBDbi3Go4P6i+/q44nt3Vvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iXQwP9b20MbV9INks6JY8ByAOW473YppEkbxqaEpYQ8=;
 b=ClP2HOQRb8klDGJsKsF9bUnHIWiFIKFNko+HJlsQLodXIZcwIYKPQdL+6M2V/jm98sTOWrH6PhIvGizNGWzzg9gurbG+/T0swAqJ6lvIfyYEf26SmzXbV/wtCIGz2t6PqnyMLzLwMDmw5nyIeCh95inXWgG23SgIsPAW6RPfzj5wat8W9c4/O5ueKNSPA3x9HQWTBwK7ZS4m6D0QnD7j4tRLHyIOmXWdCc5M77xS60FhP9qSK4ehcycLSuMVtZMac1sj0QFl47I7BYhQhKnASc0YC/LUYH3YEUKISezQyXwQ+uFfTqGUls2jdzpVkksnxeOK3bfTU6rXjMwHq54Cew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iXQwP9b20MbV9INks6JY8ByAOW473YppEkbxqaEpYQ8=;
 b=zv3F682WnixpIp53ybxMdovXgFEouAaCQLJTsjFsQGHRBfuq6BFt/gtWQm9dLaS5K/hvCXwx0QZRupx9WYx0TSLxKemXCEE1p3QnXDyXOYVqC8teFmVkb+2InlZF3sIGfqnJJin46WnkU1kww7iTCYSFQz/YeLBAT3NorHIPYLU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5533.namprd10.prod.outlook.com
 (2603:10b6:a03:3f7::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 18:53:30 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Sun, 8 May 2022
 18:53:30 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>, Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v8 net-next 02/16] pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
Date:   Sun,  8 May 2022 11:52:59 -0700
Message-Id: <20220508185313.2222956-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185313.2222956-1-colin.foster@in-advantage.com>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 652e6004-73af-4e3b-6211-08da31240aef
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5533:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB55333B04E215B852CC768E09A4C79@SJ0PR10MB5533.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mqDiAsf7jqYTw2x0hJLek69w7Sz/nqkDqYJnvjMSoSKawy5L+Geb4HuY7sp4jE8XIDaxzcZDaIFOIw0JUmbl/y76momEb7XXcRNIfdnFmSq/CpTd9VbNFh2fZDXHOtnWFoD/4JAr/uYPF1GoUaDNO37OZThupmEstOV9Eyz1pir9hJOexZKN6CzDlZ0Pthii2uvZODe91c5fvfDleJ6MZ5OVGNA1fCiBp6gTQ11OwHVvxl4Rlqa58QClNyJIHde8zfGXlNwBulD7Obb0lIcYdxyQB8lN/TfEmKj0mixSrAs4BvbOBAOrSYREWRN2xQoXc9SmuvapxWeeTkDJ3gpvrUiVMWIW4ngUqKLa9XfdOuKJ60P/mLEDdKctdcK5gM/9l4CRBhU7+r9bM837NyoAVVTKsKWzuj71IlUK9EOfxSqoRcvtsK+X5jgVNSGRqJM9iWLYNTUocY7na+5FySQEQ6kaFPLaWylb4U06AWnIdKVaIPnPeYbj1pCyB8eIZMjHjkA7KQW83/jB2wkNhdSE/y+9++4zb5XJE+dD467LYgaWClOI3lhzPfYj+8ehfytkoOK1XK/vx5plfvnJFyL6moEcIExsoqt0obZ/xwA5XhTZJEyTqNS8tKr1j4Pl7tuyLQJeip1Z0p/PX97aiv57vc3Hq2gioHnITTWo/F18Gem+hWWfpRd/CPu40o6MSpsf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(376002)(366004)(396003)(346002)(316002)(66946007)(6666004)(26005)(66556008)(508600001)(44832011)(6512007)(6486002)(66476007)(52116002)(186003)(86362001)(2906002)(4326008)(54906003)(8676002)(38100700002)(2616005)(38350700002)(6506007)(83380400001)(8936002)(7416002)(1076003)(36756003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jkqoCMfhFUpI0To0IB9UsTYZsTJOr393L8yXqAg18NgqdReuNzjrs4uHO03q?=
 =?us-ascii?Q?Ro+K0RuW+x2+w9fV4QPv7/sJ8pL/bUzXBe0JGaJKTgBEh69FpX5uIFhEKdzE?=
 =?us-ascii?Q?Js9nd+iRctVKk7OCZ2lSp+pJr/xU5FL6CZznveHbY9j/eeBbny8XDLSpt9Bh?=
 =?us-ascii?Q?HUyC2KWiUcrz3XAUAsGJa5VZ3Datf/rwmqVA6oIU2us0u97TtyneD66QpoJW?=
 =?us-ascii?Q?z3Tskc+jsybtNg++0IvlAK7D245biLzuW2X4hs0Zmz8NKWcOzVEbO6vtMdYU?=
 =?us-ascii?Q?xHLPGf1gUya0O4V/k5bwcJqaj6A8j6RO+zTNJ06tFk0I8UGg4jteKBTJhL3k?=
 =?us-ascii?Q?h6lr7QnW0kQFf2I+jjfQG1KjS/XOkO8RBufga7gUycGIRN675gUgUcyTmk3U?=
 =?us-ascii?Q?l4Z24l1BjiEzb2EU5JRBk4FT8/fqmLAsJJfOtkeoJvm+TwP3Ysj6c13fNRHN?=
 =?us-ascii?Q?C+EnHCIfT/v6vEP9gjLRO5YmWT8DuZ4cgrw6F4+OLsow9ewdW/qvoP4OHUKz?=
 =?us-ascii?Q?jj4OBrc7Cw6U10nTJGSJJcagagjauXqjerQMbq7AyvRhjl/VmnfPX7jAx9yC?=
 =?us-ascii?Q?J0LeeA5A/Vt/av2GyvSv2Eak38ywVZpnUoHVbUz+xbw38FGW59wr3kYIXX/V?=
 =?us-ascii?Q?mDQDKFj3t6vCVnQ69BytHO1ZX6RvoJEIGH5n83BTKT355yLrDAlCT/KASxxs?=
 =?us-ascii?Q?OajV031rEsS/qRk/7S1+yd23chjEWoCfwThQxxL3VyqVnWOxdxladWNNtKSv?=
 =?us-ascii?Q?hsJ2J7GOKNAS0O8rX29W2nJuqeaHRhD2d2gCh/bxQRPl0/ida8wpoQn0Q8NX?=
 =?us-ascii?Q?70vS29fymVPEbOZaoB1ilgqwh/tliwdhxLTocGjYi01w4NaLZEkZB/7AGTzm?=
 =?us-ascii?Q?tyn+VtzQU9nWErSkiEWSCvOXvHmCvX7nR8J5Gnj+iA5Q591QvsXm/F4r25zX?=
 =?us-ascii?Q?rDxOX/oTBxVqML1zHsCVDFZchhWO93+CxkM4tSLGChkOnr8mxyyeDAEcYfNr?=
 =?us-ascii?Q?RJOznXFjbss4vjruHA+7ym3Xqk1xYMzpW0llu0ZsyUhMKAlj0wQHFhDqKitM?=
 =?us-ascii?Q?BIaBWaBMFUOlLqr53SCY8gcL5mS/gpttcXXh/2qod89KPrmDDlyrNkqTiete?=
 =?us-ascii?Q?e19/2Zf10CYFWed4Etu1pJnZNDrGS37Zt4lIbHIN9wrw0661YLycUwv5Z78U?=
 =?us-ascii?Q?JZIdWRwpdgKWbS0WTa/Oa0ll6Zl7/n3+0/MpWDsoTMBWhkVfHVpqKOdQNCNO?=
 =?us-ascii?Q?SMHWoIhTX9ghKDptMe8yofhLgQCsbS3/92NDcnYSpKHqF5/DoQJwdzUnCJ4d?=
 =?us-ascii?Q?Fof8ElcL/xhoMk8b3Dlqd/maGPMHm6+zoWD6Vj3FKRgVbFQOhVKk1jaPTELC?=
 =?us-ascii?Q?HQw0w+chHMDaVbsFFyzqNHIIvB31f5/EwDFe2f5WG3tYk2Uf0q4sBJgEnx/h?=
 =?us-ascii?Q?3nwaE12+NcHJORRYIyXey5fy1B7m4rlGK4hu6W8nbrNeaxZAvUtLq+dfg14P?=
 =?us-ascii?Q?0KW3cBjVTxPVOzxeQySUC9HT9MMGTxaXciyxydMPGS0i8QHQdsJVd68Jz113?=
 =?us-ascii?Q?BHvVjQbH813nXVXGjLXlApQMsPffoBIplbmyw40HDtKk4PDjU70NIZ9Z8P1p?=
 =?us-ascii?Q?HmE3gLqoOuiBkG84Cxssf8Uh9rD9RM2otUUdrvCtCpmlmUQLF82iqe0ZEUoE?=
 =?us-ascii?Q?IZ9EDXYmCTlQk8JExeUJvJJwezukrxbj3TOTzXu/SP0pJ0Lssd+OpORgY2Og?=
 =?us-ascii?Q?sDhhjIXAD9t1fj+wi/W7iS54nYYVwf6t8FT859q8LAFot8zkWDtO?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 652e6004-73af-4e3b-6211-08da31240aef
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 18:53:30.0734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W6IK4VVDY6oQl8jEKOezzb/N4Tilr1nsT9xaFwqDbMrzu87M+yGxsdsaheuzbxKmORdaquqnM/eoYwzkFqbdifmvr6AO1G+XBTfBE6CBHR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5533
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
---
 drivers/pinctrl/Kconfig                   | 2 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

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
index 80a8939ad0c0..8953175c7e3e 100644
--- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
+++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
@@ -995,6 +995,7 @@ static const struct of_device_id microchip_sgpio_gpio_of_match[] = {
 		/* sentinel */
 	}
 };
+MODULE_DEVICE_TABLE(of, microchip_sgpio_gpio_of_match);
 
 static struct platform_driver microchip_sgpio_pinctrl_driver = {
 	.driver = {
@@ -1005,3 +1006,6 @@ static struct platform_driver microchip_sgpio_pinctrl_driver = {
 	.probe = microchip_sgpio_probe,
 };
 builtin_platform_driver(microchip_sgpio_pinctrl_driver);
+
+MODULE_DESCRIPTION("Microchip SGPIO Pinctrl Driver");
+MODULE_LICENSE("GPL");
-- 
2.25.1

