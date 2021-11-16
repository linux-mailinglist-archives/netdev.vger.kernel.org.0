Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7B4452AE3
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhKPGbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:31:09 -0500
Received: from mail-bn8nam12on2126.outbound.protection.outlook.com ([40.107.237.126]:16577
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231693AbhKPG3G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:29:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JUecT4rKb8j4CnKM9b0Fqe+rGECSo73NyhVTvlpQFcBz1/UUdMdEJfNJqOR9Ynlv8t+rXf2UzczGs6O26j81MrPeKcxfTCVbs0ohrvM1cq5kHBJqr5c7auj0HlP3VP61Jm5NBG9lUGcjiuSMluaGOf3Ijxt2Dq+Rl3wUSYLkVDmEatTLUyBtw68Ruj/A2yxthZAhYQtwTV9APlN4qHSxZF96BWuT3ZLLa/o6mFqwGvGPi06384ZFvBJumZGxcFOH9vnW76Pf7wL/F8t0w8PXNz76Cmpr09JK6gfRIAMmoGGSV5hn1GMAaX1/QneNf4XNNWajPno5LRtIgRjLCan9nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KG6HdwFp/L6MLCNn8O0qkjIsstEXdp5Lz8uEeWCsBSM=;
 b=cnRgr3yDWtP2TXjtXDA+lt/uUNtr+JqyVOKbOGqrxtnNSzIBepx09JqciffJ+tDzDm7cVAiusEcNBdqMDXJ4+9vCRMDdEEtJpLLwaXgkJpfDekuXpMjUPFHHIXKpSpsnDf5LT+8dqD3gA3ad2V1Wf/ZIr0cDMRZAqTul+ZHtRfGOgBBtLwAaurXog01owjtcRni9g8M5eXtfGLrVY6796MFB/e6hj96RMKD9wYZOhORSNrd0cvU6NQmfqpmfXSze5QdpY4ZQ95DYhzRxBGmg12A+m0jha1mmwe27RzZHsTQ1i3XdnNW1fT9By6EnzjvQmF0sn2oQ741GKJL83mamvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KG6HdwFp/L6MLCNn8O0qkjIsstEXdp5Lz8uEeWCsBSM=;
 b=EXLBQADKZmbJY8K3EgVgUasV9RadoGRabR3d8BpROmKFHALV+wYw9CVjBiXs6SAc41Vr5gpdbQzKGeCBCkljQBSd8XolPlAIMjrL/PaKpvA5HZPT1aYQQDi+UO4dmjCN8iTtB5Xd8UtLdzoTEs+5zS57ipSqqFkH46Wgc4lnlE0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 06:23:53 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:53 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 14/23] pinctrl: microchip-sgpio: update to support regmap
Date:   Mon, 15 Nov 2021 22:23:19 -0800
Message-Id: <20211116062328.1949151-15-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25c95e5f-8e39-4057-47e1-08d9a8c9a949
X-MS-TrafficTypeDiagnostic: CO1PR10MB4722:
X-Microsoft-Antispam-PRVS: <CO1PR10MB47225EEC6038BA6CFED6523EA4999@CO1PR10MB4722.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ysz77RgxhCcXrr5gFIO76s/4tqkdvcsIcb+Ew/PMu04IBkTJ8h1RxNAjVJ9Ct5bYmYke0InmZp4vsyFr//6o3Umm5MytisKSZ9kgcWGyiO07cErESN/vViTJ1oN7LXuaxjsot42gVMaZVaUKl5S3/QqinTIgCP15S6TnNrDj+6u9fdogxCX5JYXeUbTZ4xyUkdjK1BOU1ddzB3rBlhJlMR2ci6NTxFHxcgxPMYD6WqnZ/CblgwgkN8NP0dd5ivxL28E3XdWEPxUMWVobZEI11uElLZL1ZA3yc0NhqBB25r6aP1xzLxneqzmaP8LJ9VtRzh0EHeRhsk+4Ve2YCnZMmhh88wIzRJyDBsW8chHlikO5sD70d+F8XwzP+o69uqzZ3lp5cFooivFCQQPd8wUx5FxyiQuUgpA/oZR6O+BQnpp1UR8cZvcOkkuFT4KBs4fFP4YGBhZFmPBJm1+2rwtYX3fJIAxgLvPK/0b/bEn+fFkAbJYQCxYPVx2zld4Sd3BxdGCVgMpvIt+9YmVUC27UUGlfzHk94sSJhZrnJMt6hhTnKT1wkK/Y6OJXbCG/3rkrNcQVD9eIZ/jpESazpbFbaLE7ra1pRBKpVeHa+H/d6GVikEVog745hVWnh9iAZD7idRvAfCTXqS7TWLSLK/50L1NEVCpVh8UQhKL5ZAckJ0QkcfQ3tDBl5Cj+j68qkk8/GQBraMDOX9VRv+LE0ER7Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(39840400004)(346002)(83380400001)(6666004)(54906003)(5660300002)(2906002)(7416002)(6486002)(44832011)(956004)(86362001)(2616005)(4326008)(316002)(508600001)(8676002)(186003)(6512007)(38100700002)(38350700002)(1076003)(8936002)(52116002)(26005)(6506007)(36756003)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D7kw/LUUg6OCvPv/NVS0yVluf8onIpRVX6xJC5dIh4yu3yEI0GiPZ4o9w6Fo?=
 =?us-ascii?Q?EKqlcbJHiWwsQtsn/3BX0JA16iTnoc6eXMKh46NeMCNt8sOW1u3e16/eaP/4?=
 =?us-ascii?Q?YbUEfDW7VtbsdcTZW0C49RD+ZXzzJOwytbD6mys0Jv+T5WAmSw+ts6+KAuTH?=
 =?us-ascii?Q?cuF2V1C8Vr/GCmaIWQ9qy3NOHMhJVy/I2+qL+M/X6lK48GVHSzWyVGbRKuKk?=
 =?us-ascii?Q?+1B5Uc29VNyFoWIYsXufqtbvD7QcdfzMYeHhKNFgTQwuWCce9pklFZm0pnAW?=
 =?us-ascii?Q?qVj4150dp+ZiwoNsCBvxx3rjcBZqv2ciEJTtMmDystcnu/Ar1tqSQBXlQ5Xp?=
 =?us-ascii?Q?vlaa9vRE7yz7N5cmYM4wDfFYZHUnERdQfHo+/fjY24SIQfMm0B4j9wY7G64H?=
 =?us-ascii?Q?2xXHGJJxqyMOhntjv3/+Fdg2evaZakgzJuX9xRbs2NmdCb2GgpyQr+mq6KkM?=
 =?us-ascii?Q?SLk4RHAjVbmXz55C87q/CqfiJmmnstvwuG5Q41Q+E7VQ9EJ/ouNpWiRxhHwW?=
 =?us-ascii?Q?UUGlECQZrFGRz1TC2bWVnkZQcEFcbyBA5sU+xsy0rEc7TwhSEHoZhlcuRWPc?=
 =?us-ascii?Q?t+va1TXHIRqR64GU6OnKsTlI2nkysuglD5FwVLCroiM2Vkw7HBVqSRYi2qP3?=
 =?us-ascii?Q?YWAoQqsNtaHHPKxILfpMjukYz6a/gXJQLK30KpJX8XINKL6kW1SUKByG0oxY?=
 =?us-ascii?Q?4bTtz7n2kMpSRyB067GvKxWGdrhGa9U8z3QZIZodKjHTnNrw7bDjADGZbPsN?=
 =?us-ascii?Q?3Bfe9m+OP468DstgYze5oLq6VffNOKxxfajvUCNQQuWfFtnm6E/Y7BmxSSjD?=
 =?us-ascii?Q?h4UHRsnyOitYm0iarO6oo93iJyGM1xgeZOx2gGKFlpqW093/Ma9AKgwe4dYw?=
 =?us-ascii?Q?T0E9XSEU/QDV6ej4p8R1D75OWlFZeBY3Ifk7aON1haK1prsE8l/hFzb1IjKG?=
 =?us-ascii?Q?qBPcbktUNX5UUQbofrixGSlPnGGDwAk0g3QHfW4KBOgBepsag1Z+MAjAgrMj?=
 =?us-ascii?Q?yD6/AzLuK/q6VOgP9nQa9qgO5uR7ysd0Hsh6TNDN8/BwUVa+mGoAowxOix3Q?=
 =?us-ascii?Q?mUuKT4cgWWBCafFpAzqwyuRWeZqhliJMJ7v5OWJWToBpCmU8DcAaOWvcRcZS?=
 =?us-ascii?Q?M0QZBdWRJ19AER03TfUpvU787bsBJ5pbTcM7DN92EchkVosmfjewZkZPTv6s?=
 =?us-ascii?Q?Jk5stcLIP1Iof9RlgJNt2/VhDqlgwU9HE+7aTysght5IVtpLd8Mf55ow79G6?=
 =?us-ascii?Q?XW0sY2PjC8tDxJ7qV2fN8qxmDxpTqoPB3xv1wXakSK/wOxkIuBx4/u09L85K?=
 =?us-ascii?Q?a1LCgvUFo8IJtvId5U8pralgTetwRZh+U2S/bva0X+vSUqOiUa8/DTvVFap4?=
 =?us-ascii?Q?gJHOA9PQpbVgCg2T4IGh86MQipY0W7Ln6YX2ndcZCswqGIKaAW9tVjj8XfXS?=
 =?us-ascii?Q?lZLpyM1cDn6ckpKBfxx3LjzZNwtmAHBuhTf8+JC0WUe3d1vs+bN/rt59pSWM?=
 =?us-ascii?Q?RiNJpJKHejnTX6oQM0hsAx/+AnFPkbrCtZOD1gc9pFdgMD+iyd74avBRJ2Dl?=
 =?us-ascii?Q?SgzsqhbTUfq1Fja/Xg+Wi2KleUzP+7JAdq6j/48Ycc5kzc2pRANLmx6Hb6Y6?=
 =?us-ascii?Q?oyk8Htr8mj1dI+gd3AcCY5qu45wl9gd8Wd+hdCDNrMxazqnU6go86Jwu97YT?=
 =?us-ascii?Q?JO8eeHu9Nm7Cfs2FIE8HQPBWBG0=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25c95e5f-8e39-4057-47e1-08d9a8c9a949
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:53.3849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SzC1pPiseQGl6CNFNmglpWJQWxYXufPUTOhm5ZXPSb7Q7KjBmYzcjPUyVBHvJQGZmoz5yL2gbPkw39BTOAeVZi8388G4hHQYLLTNyUMPx/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4722
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adopt regmap instead of a direct memory map so that custom regmaps and
other interfaces can be supported

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 37 +++++++++++++++++------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
index 78765faa245a..762611f76438 100644
--- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
+++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
@@ -17,6 +17,7 @@
 #include <linux/pinctrl/pinmux.h>
 #include <linux/platform_device.h>
 #include <linux/property.h>
+#include <linux/regmap.h>
 #include <linux/reset.h>
 
 #include "core.h"
@@ -113,7 +114,8 @@ struct sgpio_priv {
 	u32 bitcount;
 	u32 ports;
 	u32 clock;
-	u32 __iomem *regs;
+	struct regmap *regs;
+	u32 regs_offset;
 	const struct sgpio_properties *properties;
 };
 
@@ -136,29 +138,32 @@ static inline int sgpio_addr_to_pin(struct sgpio_priv *priv, int port, int bit)
 
 static inline u32 sgpio_readl(struct sgpio_priv *priv, u32 rno, u32 off)
 {
-	u32 __iomem *reg = &priv->regs[priv->properties->regoff[rno] + off];
+	u32 val = 0;
+
+	regmap_read(priv->regs,
+		    priv->properties->regoff[rno] + off + priv->regs_offset,
+		    &val);
 
-	return readl(reg);
+	return val;
 }
 
 static inline void sgpio_writel(struct sgpio_priv *priv,
 				u32 val, u32 rno, u32 off)
 {
-	u32 __iomem *reg = &priv->regs[priv->properties->regoff[rno] + off];
-
-	writel(val, reg);
+	regmap_write(priv->regs,
+		     priv->properties->regoff[rno] + off + priv->regs_offset,
+		     val);
 }
 
 static inline void sgpio_clrsetbits(struct sgpio_priv *priv,
 				    u32 rno, u32 off, u32 clear, u32 set)
 {
-	u32 __iomem *reg = &priv->regs[priv->properties->regoff[rno] + off];
-	u32 val = readl(reg);
+	u32 val = sgpio_readl(priv, rno, off);
 
 	val &= ~clear;
 	val |= set;
 
-	writel(val, reg);
+	sgpio_writel(priv, val, rno, off);
 }
 
 static inline void sgpio_configure_bitstream(struct sgpio_priv *priv)
@@ -807,7 +812,13 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 	struct reset_control *reset;
 	struct sgpio_priv *priv;
 	struct clk *clk;
+	u32 __iomem *regs;
 	u32 val;
+	struct regmap_config regmap_config = {
+		.reg_bits = 32,
+		.val_bits = 32,
+		.reg_stride = 4,
+	};
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -832,9 +843,15 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	priv->regs = devm_platform_ioremap_resource(pdev, 0);
+	regs = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
+
+	priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
 	if (IS_ERR(priv->regs))
 		return PTR_ERR(priv->regs);
+
+	priv->regs_offset = 0;
 	priv->properties = device_get_match_data(dev);
 	priv->in.is_input = true;
 
-- 
2.25.1

