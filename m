Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE9C4CEF7B
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbiCGCOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbiCGCNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:13:42 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2104.outbound.protection.outlook.com [40.107.93.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507C017E0C;
        Sun,  6 Mar 2022 18:12:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFtDWmeQR/sHTmLOv9U2QF0F+qJct4tgdTxugy2qB4gVsqbRpTI1ba0Tj299lXF2G/1Ok+ttvOoJrVBsL8rUjH2SdGiqTu4XbZ0fUD6uYWQGexQ1idA2ljoXUrGCf2wLgxJZooaGhDCroQU6JHgl2i4aBQNPtIw7Gqx3UBMRAZQTFpxjivBqlKOW1DHMBetTMK1JZ8Kvc4AtYWTOGKPCCJP1c/cDClW5+0IwKyKt8k7jUfE020Uu0y13ZIV3ZedY4gy6TpDAEseCtCAPn+KxXtDfk+Vp8ZlhOmncVXYxK7U3U6vOlVQiK90LJpzom7QPYh2dgVeCXp7ItJvlCUQFyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3nqSzYmpIY27bENt2yAEAnV8f/TVDEC8NiooUaOlEI=;
 b=Os3IUEWaGyuLRz/2qUXgakr1ItTx7apyy7x9xXd/u5bNPA/D6sL1Dkp5EEjbJG9SsDghNMsjYcC0ByPc0KBfgoxBgitUeCvR5qBLctj4Ft6OltFywOahh23OKaaHhvHVExtH1RiIIsaPsqi94u9XCyQfYGtpD1d3mXgS5U+dEmtDExxY3yHKPuPaTTPdchYNhbDNXwN45WHhHzfA6ibttqWkH0gw8jU1hVVCZMaliqoMXJ1mu3Sr/DX7cIr+QuJ4PivNi6aIbAO8Nc/zLdcnWXAEQri4/aZEN8gJBABjLAcKtSrsWTI4yUyBbk2L6eBbzElvmsUz51rm+5d43MbP7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3nqSzYmpIY27bENt2yAEAnV8f/TVDEC8NiooUaOlEI=;
 b=HohgSOU5Py0r93p96XxYaXarycFrhCCqdjjhYSZxBsFYlC+xP7PpqB6EtQobFLTykPlTsHqCICLS+zPKi7tTQ2Moik/ZR5hNFeEmWak54wYCAzuKSddEmfspAV4ISYhKQB7FIXZ6aIXczWS1MJI6MiOTh+6hrYb20+f0yPgGuQ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4553.namprd10.prod.outlook.com
 (2603:10b6:806:11a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 02:12:30 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 02:12:30 +0000
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
Subject: [RFC v7 net-next 07/13] pinctrl: microchip-sgpio: add ability to be used in a non-mmio configuration
Date:   Sun,  6 Mar 2022 18:12:02 -0800
Message-Id: <20220307021208.2406741-8-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 93b568c6-ee85-4036-6c1d-08d9ffdfeee0
X-MS-TrafficTypeDiagnostic: SA2PR10MB4553:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB45534018A5BDA340D3EDFF27A4089@SA2PR10MB4553.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8qgFddhEOoXo3kfHyX9okcDbGNJWZoiiN9vdbrr864KJuZqFUJEhtsu/mkqJj4kgznNYk2wLiErf8UPZ1M30/RuYFXdhZkae+vb+aCoWfsf4Fxv+/4HnIJ/yPbC/0JOepCQkUNyPzpu2wPhbrxpFIRnUcGLenzZRqyk+3+2yMxBcgqD4Hh3x41pfMaD+hvwGaPkuu+qmTckHuxBEYgv4kDPAv57xtlnreofmz6fOWXsgu738rq27ZS7X2NPcmPbpXeg8NftEivi/EolfA3JMS9DcZKcM4epTZLVbmT5Nf3uNkQpuW9aVrDXZHloA83Kv5VbUiG8YmD0WlAaj40q1FgI9rYudJ7eXbnvrVH2cdB3R6KRu/WE0c0fcYbrXPjlcpuxoPZcEJIDCQ3eu3jVnTc8HRGzBSDkL48p6zySFL0urKH9549tj8bfWiE8PQT2lynkeOu/5KWHYhmsNU/j09Dtnk6aTgx6FgtONQY8Gelngz7NUj+82DazgeNVCTKvX9wK1nwpUsSShKZUjI3rrHiYYyIGR+lKZt3PoZ1cuuhTwau815+dsQKhMfBx2yZG64JPiSeQVuBkG2wyWRtzSCkzVIZ4JZdefUf4SAHMlKRRTjBS5DUnginhS6dbPK/jW/OUhWJUArF4pptwrpEZhCV+sifD+oNZfb0RgfJMTjGF6TuWKx1sZ2MGVN4oMIftFbC0IMCs2r7wInkoCwt+mCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(42606007)(396003)(136003)(39840400004)(346002)(38350700002)(86362001)(508600001)(107886003)(38100700002)(6486002)(54906003)(36756003)(44832011)(6666004)(6506007)(66556008)(66946007)(4326008)(316002)(66476007)(8676002)(6512007)(26005)(186003)(8936002)(83380400001)(52116002)(1076003)(5660300002)(7416002)(2616005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z+Bii9yW/zsqc7m3g7xbTLU6iXHeH9APOQvuhO/wJ8kQY0PTNFwLA3SZJ1h+?=
 =?us-ascii?Q?15rEUuLEJOeiMl5+rIO0tHf8/SkQFmuIbpKP02mt8c2RHpdCUryVEwd8GmJz?=
 =?us-ascii?Q?UpSofxD3TY8uSYjSCR2eZ6Hm/MIAY1X5KMtVsfRwgV4ke/cWaqDU9daIXfGD?=
 =?us-ascii?Q?CBjykb6f0EQ8CifZpJ84kuj1ZNchIvcQ9DY+gvNFdjbyjej7/B4Ermn53cCU?=
 =?us-ascii?Q?7l6L+X6lGSi+LIlSlS61bU8Fiwsd4Id1yAYdjm/4wVsLYMZHD4gJqK10ABLR?=
 =?us-ascii?Q?OR6APkLoqQQLiL3L7HlQO7b7PFd738l4chVzz2k+hptGZayFuwVVd5ANbdZQ?=
 =?us-ascii?Q?LbJLG5Zki4lb1CzaVEAbD0rR7V/OOR0s+OnjlSXS5xi0QU9wPy4af+uS4dI7?=
 =?us-ascii?Q?RfzHlE8XFvNB+waQh2908D8aiZIoD8z+w4CWgEASfi+iZ2zc3eU05G5846eX?=
 =?us-ascii?Q?LTrGolmHFKdnBv1DAoOv/YelvY58RvJTMHdP77a+zulKuLgxJ9q8b2Djc83W?=
 =?us-ascii?Q?ACgVKpPu9esg7144+YKqtpGqBxexos/kMuoDY9Vg0ifqcEWbpdz9R8AzDnb0?=
 =?us-ascii?Q?3x09nre3/uP8AXQXRjHrAQvEqdtxPWd8zqx2cX96B/vr8tQRcuMW+X9razQO?=
 =?us-ascii?Q?P9mipG9J6OxaBm/e/Ok7kW+pH2BKA4Q4s0vGVlEmd/XB8UeZGMX5goSv2aOc?=
 =?us-ascii?Q?DUUpq+PQpKaYdRoiDn48EfqPShvI6rJOywG2GjePmCfnHSlyA/UueW/Apc42?=
 =?us-ascii?Q?a2BLQr52cxZV7p9pQ5ZjFmWbYS5Oalhl5AjQxLgPhBthJtzO1q2yGhS1dZsf?=
 =?us-ascii?Q?326lYVbvjbI4wr6ZClKknegKBLkxB0Ksd0vMjJnqKzFN6pXj4TFiOazzo1le?=
 =?us-ascii?Q?5PVVt3lxVlBMgo64rtCaHoJ/qDGvZROPi9VbDqjxaowSg+0MamHJvXgzqzJh?=
 =?us-ascii?Q?j+GyFtiwNUxu5UtPEbddj6DcnpcVLA5iBo34yjLZsJr8cT2T0EX8awSqyx1F?=
 =?us-ascii?Q?irRwWuNUv/muXtpZ+CdnOPzeFTPiRvr7Huk8uMLjMhLYsBoPwE6vPC/hQJYt?=
 =?us-ascii?Q?FrpcfXveLMCrFyNpcDSaU1ju6VxxYPDr3cPn+cdzxgxcteN6XezijJGbfvwM?=
 =?us-ascii?Q?ne2jPk71IR2NhYQ+6trnqwLvPgsp6fgOKM2G+acklTs5/LbwaDu1BLHYYLj7?=
 =?us-ascii?Q?KB44aCc3ojJ5I1eoeO60AWh8Lb7sGzFUBAUWO88qmGiDlc3s0YeGm6cfVsQ2?=
 =?us-ascii?Q?3n8iMCuu3Gu9bRS9W0o7QfGabD/ialXe9/A4fze9G+Q6P3xW1B4ZpXB88dma?=
 =?us-ascii?Q?1Md6lkWVeTSuk7n37c4sGh3VLcHRyBoYDfJFffXuFyYn2NuDPtjTMVgYvSB0?=
 =?us-ascii?Q?oM34WnPIiwkyeVYUAhLBqc9Wx/f6yjluvAbfFK69BGjp2grS6ZLC4YXHLMSz?=
 =?us-ascii?Q?LF/Y4P/WNLJ3wa/tX+/+Tswj7dSrNgvaQB6Ex99SdnSB2s30XFzU+jBsF1Kp?=
 =?us-ascii?Q?UZRac9pLBEC/TMPbu4NKFrknRw4SY7lmInQ8JqwpNioPa22li62xQexK/bTX?=
 =?us-ascii?Q?cqDNK9gYgMxsODa5ksZVDUbk4gVCjT0Q0NaE0a78BkEGS88rr8Qqxp2Z+1rr?=
 =?us-ascii?Q?3c/Y/KQ8IpuhPfSL9bqA8INzfl7IxiXxV9iYlxtKNxPZgHjdo5Pz0/GIZluJ?=
 =?us-ascii?Q?AppwGQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93b568c6-ee85-4036-6c1d-08d9ffdfeee0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 02:12:30.2923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QS8n2noJZUc5OMwcUcrNlVkcP5Gyb4mbGTd0xjp6ti/bGpmhiGahr1/MTekwX1pGwS5AnjUWX2MIVvMa2OCVlYfrIKRzeKJiK8hSkajuudE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few Ocelot chips that can contain SGPIO logic, but can be
controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
the externally controlled configurations these registers are not
memory-mapped.

Add support for these non-memory-mapped configurations.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
index e8e47a6808e6..a91272936c8f 100644
--- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
+++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
@@ -19,6 +19,7 @@
 #include <linux/property.h>
 #include <linux/regmap.h>
 #include <linux/reset.h>
+#include <soc/mscc/ocelot.h>
 
 #include "core.h"
 #include "pinconf.h"
@@ -819,6 +820,7 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 	struct fwnode_handle *fwnode;
 	struct reset_control *reset;
 	struct sgpio_priv *priv;
+	struct resource *res;
 	struct clk *clk;
 	u32 __iomem *regs;
 	u32 val;
@@ -851,11 +853,23 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(regs))
-		return PTR_ERR(regs);
+	regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
+	if (IS_ERR(regs)) {
+		/*
+		 * Fall back to using IORESOURCE_REG, which is possible in an
+		 * MFD configuration
+		 */
+		res = platform_get_resource(pdev, IORESOURCE_REG, 0);
+		if (!res) {
+			dev_err(dev, "Failed to get resource\n");
+			return -ENODEV;
+		}
+
+		priv->regs = ocelot_get_regmap_from_resource(dev, res);
+	} else {
+		priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
+	}
 
-	priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
 	if (IS_ERR(priv->regs))
 		return PTR_ERR(priv->regs);
 
-- 
2.25.1

