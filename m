Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0DD5AD747
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiIEQWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbiIEQVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:21:54 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2113.outbound.protection.outlook.com [40.107.102.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04345B058;
        Mon,  5 Sep 2022 09:21:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c26rogmFsezdLDJxOcVMfYmddq6cFOi+8wBD/omyCrEo1ccyf39ol3g5omYgw3G1NuPwbGz6ZvV1rmj7yYKWerRTDIygD1QaPBPVw/H/lEq4FWeA20L34xXAN1q2/aoltIHNlGSP1VB9fKji9Td+fL2UXDxIAhHzBK+dyVwBtpFaZZHW+orVaJaIs3iOKJ14bZ7n67RTO6QdQXUDTWt1kb9rwaeWuJ4yBOKqFeOkLH7MWrZPyYkGWJL8JDuinB12zv6oBwNhAlaGGZfL728zPgDBuZdSoLsBxNcACcbCagvTQXNDgENi+hdbZEzVDubEZpCga1GfmAS7T6B2KYzEyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gb+PD0ps/NW6gcSs2B7caK5rMMUizct8apoO41vF6h0=;
 b=fYnaaqQn9GR3vha1RrO1fmCjn+LyETul32JZ/gb43x5hkBBGJr6dAHHafUPxATajET7IBqK6imWwkmEU15KjjZRjTC7IHHYKo8p+i6Kiul+7s12P6O60VZkb3/Gks4qnTirV8oSUr9CgvebJngQin16h4DgkW5tbSQr0YZR8LavRN/Yc8ud8NqfFso4kPZQN9MIFLCHrlEU4CiND+uYcQ5yBdc3OnWYfmZwxd2o3duMc9E2vTtZZsDVGjYwsVBWIcifajTwyUQNtgbUhEvu0reOKKSUFOdc3D9OzMuNxW8zJEhGRcF7APBbvneebtDcCkf0p/SRoicZXw2PCsibdaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gb+PD0ps/NW6gcSs2B7caK5rMMUizct8apoO41vF6h0=;
 b=dtuPBu9ifqEk4tidmwJtIa3nikei/XjHuelOECtwZySSQwibhgfUIUzcKKIfk4QzJFc/1H3C0HPvtSH39NAGCz1Iazpu8m8PBebR9cgPLaQeIucb2wnV0CoyKi8fL5KloL+x8zJIDhvqm3Cz2uhhm2YBRDi2BBZJM17sLOaw6lw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB5848.namprd10.prod.outlook.com
 (2603:10b6:510:149::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Mon, 5 Sep
 2022 16:21:51 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.012; Mon, 5 Sep 2022
 16:21:51 +0000
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
        katie.morris@in-advantage.com
Subject: [RESEND PATCH v16 mfd 1/8] mfd: ocelot: add helper to get regmap from a resource
Date:   Mon,  5 Sep 2022 09:21:25 -0700
Message-Id: <20220905162132.2943088-2-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 17508503-d35e-4aad-94b2-08da8f5abd13
X-MS-TrafficTypeDiagnostic: PH0PR10MB5848:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D+ZvjOlXzyrYsrHbdOjX3FCTGT3AKrfTiXnkl85A3qaDe/9NGR+eMj4NWqEi5t0WOK/KProfZ5LchAQbecu3nXG1bx5Fdi7xowLwV3EdCiGoWs8I70YZVUG2YohI72tVDw0hV90IolrQ6VF9co86yv5e3tIdqFmjeDbm49cFCVZP6MqaSZvqHR167Y8I6eQkMIY9KZSItjNJHzs9nYsd6CJcACibFzoaynuOCix2KYeY7k2prVGpqp6orSLXmvAi19bHnUnYN4XxTvBgv9YlIJryu5iL/02856WTJJJg7lFHtoI2/zpdC3mw5gqeYRW6w4TQ+jJH+qHH9yoL0PQx2DQCryeUnnuV7TwJIgNlqzVRoczMDzlZ/y66QcWk+4boFElIazELH86YqYc72DCR7o1KknS0ydW3ccHpJbzWlPljAC1Gw2aHSED2XKvyL4T7vvdg1PdEgNnVsF1tSC4A+86rIFgZ3Wpqnubs+rz6E64oG+/JXKDzDpaXP8p6k1VpBicdXvU4MKdiQyHj9oJIYz0H64fjHjzYkfdBTlaWdYN45Hd5KkTNU2C+0ERQTfRPEghVWJHFJKfT+EvvWFIWryTffoSakb8YYqPXWsIgqbNNWTevAAcpgmKFOW3f5o1kXAfc3C66SmuvfiIw5NGVeA8NL7Zj+DY6USf7DUz49wa3LlT2EPJcg/SiTsLZh+25yzjM4V2TF0Lrw3hDKJLq65FdvvLNoYOtx2+jODdQomEs59pqBoi1iRf+iJIuhzU3dG3l45g/BHEczO1yIpy/sQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(376002)(39830400003)(136003)(366004)(66946007)(5660300002)(8936002)(66556008)(54906003)(6486002)(41300700001)(6666004)(107886003)(52116002)(186003)(2906002)(1076003)(7416002)(2616005)(44832011)(6512007)(36756003)(6506007)(316002)(83380400001)(26005)(38350700002)(38100700002)(4326008)(86362001)(66476007)(8676002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iRWo1mt8S3mQX/n4phuit9rm68ESZwi7QM1eoI9Oct5e9Xx8lvETK4/UpEXY?=
 =?us-ascii?Q?/7AbuBZVcqtVqv5uvHxVaJyF80E4EXD3DZnkPsb6GEFV0IfvsuT8yj2zByoL?=
 =?us-ascii?Q?G//jGogUrPfCaPIMC/cqWKGPo0mOVdw4HxJE+TgLayPTzMfsWfLTtxjPmYxl?=
 =?us-ascii?Q?bmRK+ceikTU2VBivj8ydEk0eolH/GUJx+CDOeRyFOYbXTdYyXtSd0Fg87Oxz?=
 =?us-ascii?Q?j/uF1cRr24P4yHJk4voe4h8iYxxRYltm+c7U4eGD7ym5F8xbo07lZM9sY5rf?=
 =?us-ascii?Q?oTYCGW0a5+Y85RdvEBu7ux6VELMPXsiJIAcw4rw1VkAlPp/xEniGHxRJO5Tv?=
 =?us-ascii?Q?E3ZbCvNitfs6bLJK0bmgWH8MBqK6IboBsE+rWNtrQCHQKJbaK4u9+hTXED+o?=
 =?us-ascii?Q?Od1W+qAOD3yJpvcvBzcjUyaiisK8kKpqWn8jMMqhmGYlaCoCsolIrXK0Mqmt?=
 =?us-ascii?Q?KwM9Pa5QEbkCbqAQrj+EUMdkQziOPfaDM/tk8ncS5nUAjxGkSLmsKlbTFILC?=
 =?us-ascii?Q?eJ4nsFWtsj/VEhHcveB/K5Xx9Rm964aMlBnc/4BHj/+o19XVe/6/l7GPDwGv?=
 =?us-ascii?Q?Vrk8jBx3Q1Uw52iExi5fkIZlMsMgFNwGYKduZV+KNTUty/J2CPi+zlxcT7gz?=
 =?us-ascii?Q?nnEhlnF9g4aLT6mSOiMy7nfQ9YoYYFA2v6nn94+EhoWjhZazOMQCPoV5P5W4?=
 =?us-ascii?Q?8Rlp4tGb6i9Q11N6cYPJqtBvGVZJJvuZ7vGTVaTws4AxqL3fYlg4t0xYbQnb?=
 =?us-ascii?Q?SVe8GPc4mFkihGEtrfFNNL+hzGr7+oX/9iNxz3EnjhgmtqvZIGlkMlxfuNPW?=
 =?us-ascii?Q?Tem8yn100DLZ4kVk1n7jt0V6IHtLyk7By2GwP3UP1gPLmgTjPM5amWZz66y0?=
 =?us-ascii?Q?nEAgaM3WygKhqqi5B2W8/IkTFktCVCRYN3s41CO8vMUEiSlefJZ8hxrsdQGk?=
 =?us-ascii?Q?68IbNrC9bJ6iCGLPACNJY5f9N51gg24dtem1dbRBtxsiSh4zxZPhg9exoBfu?=
 =?us-ascii?Q?4yByr5y+bqbLYVsadC8jpb07kZTFZ9qZU2NTzxUsu/ACTwXZoSAh93KU4fQq?=
 =?us-ascii?Q?2y3twZm16BsiUxfEaMOHZwvkwsJPKXhq8ZD9/jCaoSEMxXS0CA8PV+ALQH8g?=
 =?us-ascii?Q?r2yBKMgWv4Zt72WQc3gAZ1kyo6yH/0W3swBgbFu0m2InUXoA2y9xPhUhw2+I?=
 =?us-ascii?Q?+YbFehRJZkQ3xqkPUc3rj99ZKsQgTy30dOS87sz4wHA+v/qeyjfHeUwkNFJK?=
 =?us-ascii?Q?ysGtS8vbqLw9QrmjupuShMk9WeV0Mji13E3iyGKckCl+rXWHFkE8psthzFKi?=
 =?us-ascii?Q?nNtyqCyX7MfVgju3HVldRR0zw9RO3BavhHZj3P4KPowhMWTLzoyk1gS7LcgY?=
 =?us-ascii?Q?bAQFIEJgYGP1ZKzXnreIofmQjIvHzPC6WENg52xedhasKG7D5XrvIAjggu7+?=
 =?us-ascii?Q?i70NTphTq41Omh73+6hOagvOZdjnC08MW53xHvUPLb3xtEnky5TuEbt+Vu/Z?=
 =?us-ascii?Q?gI9vwDdGYBwtCG+BgnJLL/Oyc1cCIg6sRHH47ANiTn7dLuC6wEFpgwMwZVYh?=
 =?us-ascii?Q?H8YxwAvlyXq1N2k4HxBJlxPjTBj5TTj/Ptw6W+GLSLPjeX5TlaX/OeurQBqn?=
 =?us-ascii?Q?TA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17508503-d35e-4aad-94b2-08da8f5abd13
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 16:21:50.9914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9K1ao+pKdEVFG3ToghZeyJ5jvIDrbg4o/zQlsnPpfPQvcXyQ/tag5144BVysp6HVO+wMKvibLvop15HbK767H4EF16ntVOq8uN0cj1H96Oc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several ocelot-related modules are designed for MMIO / regmaps. As such,
they often use a combination of devm_platform_get_and_ioremap_resource()
and devm_regmap_init_mmio().

Operating in an MFD might be different, in that it could be memory mapped,
or it could be SPI, I2C... In these cases a fallback to use IORESOURCE_REG
instead of IORESOURCE_MEM becomes necessary.

When this happens, there's redundant logic that needs to be implemented in
every driver. In order to avoid this redundancy, utilize a single function
that, if the MFD scenario is enabled, will perform this fallback logic.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
v16
    * Add Andy Reviewed-by tag

v15
    * Add missed errno.h and ioport.h includes
    * Add () to function references in both the commit log and comments

v14
    * Add header guard
    * Change regs type from u32* to void*
    * Add Reviewed-by tag

---
 MAINTAINERS                |  5 +++
 include/linux/mfd/ocelot.h | 62 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)
 create mode 100644 include/linux/mfd/ocelot.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 8a5012ba6ff9..e0732e9f9090 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14741,6 +14741,11 @@ F:	net/dsa/tag_ocelot.c
 F:	net/dsa/tag_ocelot_8021q.c
 F:	tools/testing/selftests/drivers/net/ocelot/*
 
+OCELOT EXTERNAL SWITCH CONTROL
+M:	Colin Foster <colin.foster@in-advantage.com>
+S:	Supported
+F:	include/linux/mfd/ocelot.h
+
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
 M:	Frederic Barrat <fbarrat@linux.ibm.com>
 M:	Andrew Donnellan <ajd@linux.ibm.com>
diff --git a/include/linux/mfd/ocelot.h b/include/linux/mfd/ocelot.h
new file mode 100644
index 000000000000..dd72073d2d4f
--- /dev/null
+++ b/include/linux/mfd/ocelot.h
@@ -0,0 +1,62 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/* Copyright 2022 Innovative Advantage Inc. */
+
+#ifndef _LINUX_MFD_OCELOT_H
+#define _LINUX_MFD_OCELOT_H
+
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/types.h>
+
+struct resource;
+
+static inline struct regmap *
+ocelot_regmap_from_resource_optional(struct platform_device *pdev,
+				     unsigned int index,
+				     const struct regmap_config *config)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	void __iomem *regs;
+
+	/*
+	 * Don't use _get_and_ioremap_resource() here, since that will invoke
+	 * prints of "invalid resource" which will simply add confusion.
+	 */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, index);
+	if (res) {
+		regs = devm_ioremap_resource(dev, res);
+		if (IS_ERR(regs))
+			return ERR_CAST(regs);
+		return devm_regmap_init_mmio(dev, regs, config);
+	}
+
+	/*
+	 * Fall back to using REG and getting the resource from the parent
+	 * device, which is possible in an MFD configuration
+	 */
+	if (dev->parent) {
+		res = platform_get_resource(pdev, IORESOURCE_REG, index);
+		if (!res)
+			return NULL;
+
+		return dev_get_regmap(dev->parent, res->name);
+	}
+
+	return NULL;
+}
+
+static inline struct regmap *
+ocelot_regmap_from_resource(struct platform_device *pdev, unsigned int index,
+			    const struct regmap_config *config)
+{
+	struct regmap *map;
+
+	map = ocelot_regmap_from_resource_optional(pdev, index, config);
+	return map ?: ERR_PTR(-ENOENT);
+}
+
+#endif
-- 
2.25.1

