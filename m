Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C820F4CEF69
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbiCGCNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234708AbiCGCNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:13:42 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2099.outbound.protection.outlook.com [40.107.93.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E570A17A98;
        Sun,  6 Mar 2022 18:12:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gd0ylsI0ZUViY/RwXU0YnGr5rNKuaNJF0avVTrIc+f8V3G1vbUtW8TmoYOBJCee7AzbVuY6QQR94CHsAXLieyvSm1bXeyUzoKL1U+Vc6ISn1en7aF2BnIw1aN09OCddy1kl5Np2US3UKmJ44WImOu+cP+58Sss1sX414DoitGdr7w/Spl2VWbn5JViz8MBBleYQzQSEhcMHMStcaRN8dH7gmMAyRYJfOzF5diqpJbA9G/DnyW8TGc1Jnu732U0Mls8v+/OqL2Wsrll/C4bMoCFnImAxLmilMd0lrYKT9SRyK2aIr5I1IBdDDFCbS3CVJMto2BAhP5SKobXb5n8VZoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CbYwLr3ra++y9HNg8+DqdZvEcgqKSlEQD2pe4QGxE90=;
 b=dy3ut8ZKNU91Lx/JhLAC4+KDkcvw//U0ymwAYjCuxMPx5ZgkWY2/EUqeDT0Thd4ILmfWgDDhplJQ5DuY9KZWfjsEMpT6Bv8B8qBxUy/N27wm1Eqar0sFcZoOc7LmzzJSgaCdDXorVL9tLaFrn2aawCypjk+WEszT4th6/gs1xUAeozomaAwWFx9bDpVfoyvsbt3JIs4WBRbxBmCNdvXo40/QB25GxmO10DizZ+VbkSKcVNKEbIx+qDZmT19TvPqwff2BxB+7KBmzrf87LvrpzyVbQ0d6ISNr49+FCgxKrf5jmC3qTdnP7clIEBfHcNWdTWUd9uS88vSQ/adzmwJthA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CbYwLr3ra++y9HNg8+DqdZvEcgqKSlEQD2pe4QGxE90=;
 b=E0UXyzVgBECHk694JR3N4V8X2HT99tY1oUazKoJRI/Z4v1C8MjRcA0nEo30NYPGLns0zuYcyyWZ2zkmSavye91Qj6Dib88iFcuJCGcs3vIzf7ihXDV7WiZQzpVFeo9gvvcWmjiJz3/E1HB1N+ZRyCGfEZHfrj1Zu2mqJByklRvo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4553.namprd10.prod.outlook.com
 (2603:10b6:806:11a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 02:12:29 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 02:12:29 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Angela Czubak <acz@semihalf.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [RFC v7 net-next 06/13] pinctrl: ocelot: add ability to be used in a non-mmio configuration
Date:   Sun,  6 Mar 2022 18:12:01 -0800
Message-Id: <20220307021208.2406741-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220307021208.2406741-1-colin.foster@in-advantage.com>
References: <20220307021208.2406741-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0174.namprd04.prod.outlook.com
 (2603:10b6:303:85::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2d09bf8-db27-4810-6190-08d9ffdfee51
X-MS-TrafficTypeDiagnostic: SA2PR10MB4553:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4553A08DBA0287A8820BED35A4089@SA2PR10MB4553.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KW4kEHuO3BnhBv5Fma6HdaiTqg0e3FudE3chwqPCAoZ/0k3slVYIa4jJtctxmJb71VK992oQeZfnsyRRthHuiDNpBpLqRbWXy+Th9twyb8sezJ06Vk/pFBfEt+ZcNqHoGMtMwB3PaLAGNA01/mvhJ54QKdCEPgxuKuvp1N5cEHDTYzbFYWyTW42J3a5SMojCgwNxKAWQb1HtGbycshU8Mly4TnrZiZrKqdIFpnAuzO7MoKz51O2ssBaSRswMDQ9qmWOFUM6FHzLq7cKSvr89B/w8VY7pxN+elJ9bNJNwVgOtqthxvMiesg/yd0dALvs9/+kWAaWXD5IfGbt7yt8NOX/Ld1UXQLeBNppegYDDGHThJSUGs66UDMttPTRSpMErwdlVjF9/mGu7P55y/1WAyKsZZ+xJuVEXJdhr2YWumQgZPTHjQy6gVkiP+5nmsSLqEVsdH607zOqHJkYvwfeYVh0b44E/VXL4/fGF5RfJggj8+q5E6/mFotwW5j2p7EsSCW7pCZ1LtFQxJHEZq9OTqr2637i4KlNE5IfYpax4Mq7VSTIv11HTs6/MeQGTktKgB0w8a4kzXulgfUieiYGmssIewE8fVo8K6Qxur6Mn/sFSRx02iRrt05Ev8XHLz/ofoRWOKqon5jmAQFHBflRU0Trgq0Qbdpu3kR8j3GlxMu7lswg1O6ygWlmFb5MpTxZeH91CTkYRdWCpR6iDxatT1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(42606007)(396003)(136003)(39840400004)(346002)(38350700002)(86362001)(508600001)(107886003)(38100700002)(6486002)(54906003)(36756003)(44832011)(6666004)(6506007)(66556008)(66946007)(4326008)(316002)(66476007)(8676002)(6512007)(26005)(186003)(8936002)(83380400001)(52116002)(1076003)(5660300002)(7416002)(2616005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ec7z8MfiweuD5EFbcNLahUuJ6ZWm/JOem76VqAm/BJ9IVyJ7C2K7wgY9kOgN?=
 =?us-ascii?Q?DfktYnMyN/sVnCDl9z/JKuDz34JgEYJ4qtQbdIhowwQyJA/Kyeee2uIg7OJ3?=
 =?us-ascii?Q?8QOo8VoZjC2BLbL3xnnAi2oxbvp1mG7TG6OUY6sogHhN0vb7fSoIHKrjAaw2?=
 =?us-ascii?Q?bUZhBslzgJfihBWRu3aMHTVsUCS7Jl5ZP3aVwqO3vJgULBQQvOEu2fococxK?=
 =?us-ascii?Q?Q1C7xfsQ0bdbXOih/2/hfCyJ1F6k/asT6M/kgmi3ik22gjPLnusLGrTTuej4?=
 =?us-ascii?Q?0pLbg+YUB2MOEMUyu8wde4nXg1NpDhjNRvHBx3RQ+VOnRCJvs/Oqqd0YzoLB?=
 =?us-ascii?Q?uxIyg2yTcp0S8F1Oa90iXhAcp3cNrVNVnUlnQJAXOwToxObiSKT3Qm6yWu3X?=
 =?us-ascii?Q?VmcQfpAdyeJzan+EVkul+LOOr1sfOsGZdhkyBpOPX8k+S8+7tRPIHRDQLuXT?=
 =?us-ascii?Q?7ky880AeIYp01XDeeASaiq15PKH6cDb2FSN4LvKPn/ZEDxpGMqSJsU5vQgLS?=
 =?us-ascii?Q?D8+4Mk2WwRiZ6c33TSiJEGO4RKsurVUjQBwQpXtU7I0NykyMnlHL3N6QlvXM?=
 =?us-ascii?Q?+u3lKT6YSEJILSjfAy7YkLcp8goI5l+GyAVnzQ5vvUAZRa0Cq2wDmRPt3BeB?=
 =?us-ascii?Q?p2h21GyU8rEyg/QDWRd6Ig55tqF6HmSgGDztrkyA9E75rbCB0r96sBbJ0N+8?=
 =?us-ascii?Q?gyZGHvK1cZAL6XTqRqKeB8ehiMARx5SWd+geJSmylj+VJltyLEXcyM5yWAus?=
 =?us-ascii?Q?n93BAaIxTgzQRws6AlP6vnFHNBnr3VrQFd40w8Mt5MoqFSQFXra1PBeJ9Ug+?=
 =?us-ascii?Q?fMdpMiTeD4MpqLf6nD4iWO023j9n/giwJdQ/mpDL5l+X6x1bqwbwsR8FYF1m?=
 =?us-ascii?Q?DeJSJF7Z9Fm/o1qYcGj+Vd3gEdBq0UT1dGzngW9iVjKRUL6fpFshlbN5jVEX?=
 =?us-ascii?Q?jK902qlzCor23mc0Y37WGTT/Wn/bREhHZq/8sI+7VNljfW/PX686iTMdV3u0?=
 =?us-ascii?Q?8XBJpkS0xwH3BXnfO52Q5xPJNmc7JwGEUF0PhzkhoydBIzg/qwqI+wsW42qU?=
 =?us-ascii?Q?u+LoZY1xzXsH/fL6cEY8Se/Y/zkvdAa7DkHxnsn1xWjxO2QtBepWRcIYfhw7?=
 =?us-ascii?Q?YcuNIp32P4bFUci2w+pwpoy/+RTwYjv5zI9MsLuh+TKJAI3cHjhRAcFP4/4u?=
 =?us-ascii?Q?/BRLphk0mFDmfvFB8/KbmzTiXC7H57oha/Zb9AU7bB+FRxw/xXmD634SmKQq?=
 =?us-ascii?Q?pgSnRPW6MdQzr5nzmelIi5SzE0/cWhnw3ld5c77JB9r6AdPaSzMsj/hKnEA7?=
 =?us-ascii?Q?zUCKbRah7ksOdw9cTYXOvwFK2h7/9AJQCXEk8bUTotT9guHzyhW019fAYnAa?=
 =?us-ascii?Q?52RF5ks8t4AyZdNX/ilPFS5sNWCAuEm/N/86CgK/BLo+Gxq8+Spxuu4fHOk6?=
 =?us-ascii?Q?UAsCDhWrgKMId7XcrCIbqwQdHaDHTbVqnRfV9PDf3qK/Q5LxshKrpoupXsFk?=
 =?us-ascii?Q?XTuWuM8JztC/mX1JwMahMtr5MhKpg8ACSuFYgrVajk55oJq/VCBmE2GIVxyP?=
 =?us-ascii?Q?eYGQrN0/lHAksINvyvj4gWJVNgRsuDE8hGFKd8hD8/MVnm7CJtbvCA/OwUJs?=
 =?us-ascii?Q?IkMrnuFjMh5qq21QC9Gb+7QxyERU99qYS/2ZNK/ciEwQuXQBk1LSWK9AnIUe?=
 =?us-ascii?Q?zEfgvA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2d09bf8-db27-4810-6190-08d9ffdfee51
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 02:12:29.3392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OWcSdwh/0HMA7QfQlweKSHCKqgGXegqmdddMZ5COU2Q8UzuS9v5TgfsdtVVDwdtd0oAJo3g6SmMDnEa7ai87FUZouK/ES+nRsmDlj4911X0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few Ocelot chips that contain pinctrl logic, but can be
controlled externally. Specifically the VSC7511, 7512, 7513 and 7514. In
the externally controlled configurations these registers are not
memory-mapped.

Add support for these non-memory-mapped configurations.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/pinctrl/pinctrl-ocelot.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index b6ad3ffb4596..e327bf00d447 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
+#include <soc/mscc/ocelot.h>
 
 #include "core.h"
 #include "pinconf.h"
@@ -1123,6 +1124,9 @@ static int lan966x_pinmux_set_mux(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
+#if defined(REG)
+#undef REG
+#endif
 #define REG(r, info, p) ((r) * (info)->stride + (4 * ((p) / 32)))
 
 static int ocelot_gpio_set_direction(struct pinctrl_dev *pctldev,
@@ -1805,6 +1809,7 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct ocelot_pinctrl *info;
 	struct regmap *pincfg;
+	struct resource *res;
 	void __iomem *base;
 	int ret;
 	struct regmap_config regmap_config = {
@@ -1819,16 +1824,28 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 
 	info->desc = (struct pinctrl_desc *)device_get_match_data(dev);
 
-	base = devm_ioremap_resource(dev,
-			platform_get_resource(pdev, IORESOURCE_MEM, 0));
-	if (IS_ERR(base))
-		return PTR_ERR(base);
+	base = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
+	if (IS_ERR(base)) {
+		/*
+		 * Fall back to using IORESOURCE_REG, which is possible in an
+		 * MFD configuration
+		 */
+		res = platform_get_resource(pdev, IORESOURCE_REG, 0);
+		if (!res) {
+			dev_err(dev, "Failed to get resource\n");
+			return -ENODEV;
+		}
 
-	info->stride = 1 + (info->desc->npins - 1) / 32;
+		info->map = ocelot_get_regmap_from_resource(dev, res);
+	} else {
+		regmap_config.max_register =
+			OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
 
-	regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
+		info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
+	}
+
+	info->stride = 1 + (info->desc->npins - 1) / 32;
 
-	info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
 	if (IS_ERR(info->map)) {
 		dev_err(dev, "Failed to create regmap\n");
 		return PTR_ERR(info->map);
-- 
2.25.1

