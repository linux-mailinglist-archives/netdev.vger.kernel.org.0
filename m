Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559A457D927
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 06:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbiGVEGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 00:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbiGVEGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 00:06:30 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2097.outbound.protection.outlook.com [40.107.220.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3761D89A68;
        Thu, 21 Jul 2022 21:06:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cf9t2ELfDgLK4kPJbtynYOjsoKOt9+YV/R8QXg6WT/dUM02Q/TxcHRzUrB0vX0H078pJP0Ft4lDaQ5xgFVkN6R/xE7zdxOMhvA2MWzOchORxq2PTzuhCAqABK30Ro3ToAmsKLdZXa/gJ2gc2VtG/PitsBAoQVntZ9c/nF6sOjHI1nTQWxLmCz/9N6Sgb/IOjO9YexVeGK4YeYVv6T6zKjESMrpCCKqI5Wa7I7ZCuurAro9LFLFkRRLjdH7UBC8jHNBcJC1QvfX8zPekgme7uu8CcmCC4i6kgrbu4sGWeMxrk6CWGwECTRSjoWmwKWLRVvaDPG8BFlyo7u/7tYUUZ/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PAchGmMFX/04T3UU1T0/gNCIsHcZw3dbC8/DL+At50U=;
 b=XOdx1sXPC0Orei/tIHVMH9yaHKpkcr9SHuv6lC2I/WMXt2NgwNmuI1b1B2/palqU2E5eFKYM7AiQldq0/aPhwvB0DJ8JVG5+CwA0ne8s6aTUCYUEULAs1s6C2q1jisO1oNMZD+IWKFTUcvWJkjupWLkoTxNyF8hE2ceg4te1CMwu6P9wHsdbLj2v4ZatBQApJoa8o8d5LOqk0YBY0uvtHOtbsYdtLlmVkjdohV3bWtZRpKHQThoQVn2S2MY7vTmaBSEpZY/BNZZp2HGLn4mRcIL3V58haaLzUyZdPvuWl/oKetJVBkJbroeamI4kI6tB+/ry++yrweL3UGVgfjtL5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAchGmMFX/04T3UU1T0/gNCIsHcZw3dbC8/DL+At50U=;
 b=LsyHSQPUaw/kIXkjPBsmYbJItFUJtmFa4ZOLzn10w73Z+VO+Z2+I2XeSiVlk3oHTyunaOyBEd2P9FTb2Vyv/Uqwp8VTE4OPLGUJk8vK20fkD22VdMxR2H3xEycr1b/RooEqMDTivnWI8IfrBGxa5Nwv+QNhBpIgzrP2vsf7bS/k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN2PR10MB3919.namprd10.prod.outlook.com
 (2603:10b6:208:1be::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Fri, 22 Jul
 2022 04:06:27 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912%7]) with mapi id 15.20.5438.023; Fri, 22 Jul 2022
 04:06:27 +0000
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
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [PATCH v14 mfd 1/9] mfd: ocelot: add helper to get regmap from a resource
Date:   Thu, 21 Jul 2022 21:06:01 -0700
Message-Id: <20220722040609.91703-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220722040609.91703-1-colin.foster@in-advantage.com>
References: <20220722040609.91703-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0044.namprd03.prod.outlook.com
 (2603:10b6:303:8e::19) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad0ad3a1-d9fd-4afc-e634-08da6b978bc6
X-MS-TrafficTypeDiagnostic: MN2PR10MB3919:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QlFVrgh4YyKTScuubrFoMllhDBmxaz+R1BENR/tJ1WVk8pHD8a75gYIiMZ6HLR0wTfZIe37/2U/o8MKNh74nGOo9EC58ymGGiwSzYF/giCmBVYpIa4NA2vhS6BemYXvs6DrRwc76rZLkmNG9vKy7+cbuoMe/nJh/vMqFpBl/1G39Wh3PEsa16SvAu/hnROE1g6R0nFGFB9ghddPn+bfY2LNBuQ60N1qVgVi3dMpt8wDjBoZCJ0rAzFfv4a4z8EwXn9v4zpghMWj89uXuZ5lHRK5yfOell0E/g8hEZc0Bv8i0vqf7XBXroPTWOmkQ44Mb2PIZiDP4113NRaqD/v39kpL3ENs56H5n6PDXBRVijIeTE2Qp2XtemzGXmXlD/Q7xFePbFwapJbYXYSqtqYHiVU/RxP0HXXAPu1gFFEIrrrm9TBjxi7nhNaf/XQXeC0Y8WVFXQ8ErHHJvmsTqfhsmC2g32ANRyltLk3C/V62pVbjjlecoU4WtU6pDNDFmJR4FcNKmLLvBxa/YiUTVlf7tCPt2byvkmIyplUjXMmPR9p5EEXA9tNTGNU2s15aiMOApt5g9jA3CdJX41sIT70tmxlGyM8OfAdRuwN+lc4I/6qHFxKZsUI7U+i2h+c5fcdt4bIyACnEO0CLDBeOxeN0YnEctIPKwEo8Zx5uExQJSTvGarRqgH/lPseY8/MNxYjUAW0QdzIZ4dM7+bGwzBj56vf9A+RsESiKefn3cbwKoh1S54n0RfaHn9qd8hIQvcWEdPxbS04sykfQFnw4jpIYE2VRbgUtf8BL99xl6PK53uOkty0dpWNsPOFudJ0kTaPni
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(376002)(136003)(396003)(39840400004)(36756003)(6506007)(2906002)(44832011)(41300700001)(52116002)(5660300002)(1076003)(66556008)(8676002)(8936002)(4326008)(66476007)(186003)(6486002)(478600001)(6666004)(6512007)(7416002)(83380400001)(26005)(316002)(86362001)(38100700002)(107886003)(2616005)(38350700002)(54906003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r1RGFXmnVXjF4r8rekSI5i/aH3cF3JV+Hi3Is+WQDhZJbQ4HReWk/un+KkqW?=
 =?us-ascii?Q?dz7emaIb+AD8E2KM8YiKLxm84hJN3aneBej+8HE9icM2F6W645Lq5QspRHC4?=
 =?us-ascii?Q?tIqoxLHHwN2a32NwkGFmwvU/CYWYkK1oGRo3dBGX46AkNgcgUNG7zBXOwlAh?=
 =?us-ascii?Q?3Op/eeSf6W0n+0D2KdDTkGX+UxlWYo1cMCP3U2jcpf1R0y1uxX1m9VlpjROG?=
 =?us-ascii?Q?OiorpYzWhzxIfBMkh2hTzmpcsVkHCto/P6ipba57pfCEEp7qXx4ayuyYeQV8?=
 =?us-ascii?Q?LGXOY7DX96mFotQ/UJI8J+1xiQfvRJ3dwBCcSXUss+PsH5De88gMDVVMiHsH?=
 =?us-ascii?Q?DCFLk1p1X+3L7DrfdMNoXZTPkQAEWJpQ95JkX6L7IQL5p4BcZeLV/HATl5p+?=
 =?us-ascii?Q?vHHzyMIyL/00v/w8MPKsXu2qWd/xou/HAGhzOR6QpMmhDorPPVfONb3NePL6?=
 =?us-ascii?Q?eG/zrjpKwaEZsHKePP+j2ywt8DZbfCPTZWXUE+Z74lxwrpBcHitrdpY0cCmO?=
 =?us-ascii?Q?q1bfmmrs606hzX7uhQ24XsTBklie4XUmDYKTeCL3e++BG/TSQhqrl8MfZB1O?=
 =?us-ascii?Q?1IHFobC7sRZA8aw9XSOgVf30y5W7ZDDzoWNhuMilSab9c09gBdORqM1VgV58?=
 =?us-ascii?Q?6/5VrL+o+uLPMx/IHjYvWr7QzD9yrCPt77g+J6oj4gqWA8wgIGOMJKHbw9Tx?=
 =?us-ascii?Q?UMljKqXb8xWTEx9POevl4YY15fbnomHNh1Z6UsKChJs7QmPgLe6abugTFeOu?=
 =?us-ascii?Q?wTWL1x3W6/Q9RNrcm6IWuTqEKjaC+ZfdCJCYF+3+UnXevjrGcQZ2ezZrg1HW?=
 =?us-ascii?Q?JaGirXiGIb1ktwNG4EEHCg4MVhF4YiDWKNhlUW0wbQzAQ6nIWEl2i267Yn77?=
 =?us-ascii?Q?8lRDxo3SXd01HOFbWPj44dxJzxllL8e+opw3Rxj2YcDIIpvX3quC2CU1Ix45?=
 =?us-ascii?Q?MAZ39cZwNrN+kV7FgXSE66l+309NMMHo7MfbNeh1hRfx9DfmVpqU6+4RvGiV?=
 =?us-ascii?Q?7fLbfZOqDXVAfDVzjykt6Rw5Lyih7k3CBWMf2gjKfdjjkIkdm+mp0lYSOfwf?=
 =?us-ascii?Q?4ETjgbOM2fiROXlc5KPiMO0jTIxWNq9LBYvWVdFg0pbw7/aMJ2GHEcR7IoGO?=
 =?us-ascii?Q?BIZ/isOKoX1brYmcTsrlzek+FnR4lBPtT1Z7M2zm0adQigWH6tzO5LvDwure?=
 =?us-ascii?Q?INaZCjDuWXYUx8ndzA6EFXnCV4kBka0jtZdEA4VqQJHkv6oqbJH/hJ1oyA5U?=
 =?us-ascii?Q?ykhiw1GD43MaP5vDeM5ThDYppDwk54ersUD9MARkHbW+kOC6TNtCClgYovcO?=
 =?us-ascii?Q?QQKWU7nm6L30pOxv3r4xxy18aAZYIarhHhJeEG5+MSMzagscYJvmY0dIgKVI?=
 =?us-ascii?Q?ZoNCG6iJHUl1uJKwT7F8NB24Ct7fOV411sGGSkoBhAsSfBg7gYBR1eBVgsqI?=
 =?us-ascii?Q?E4BROrDqrQb8vR62aRRGKHvSQwkWmzN5nYsyrvMiNkEamWrexxjAZh0yvfNi?=
 =?us-ascii?Q?/MNQAXmWuICPzdggMgZy3yfKyZfDEi1qdrf50m047+olCtx3nHvJxSqR4cVF?=
 =?us-ascii?Q?ZrDZCFxlgDwYxaiJtT+dfzD3HzJ5t8sWxM7BK2PZtaUzKSqgZEPnAxd+xZwn?=
 =?us-ascii?Q?vikojdu/677UNr2+2GUfMDs=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad0ad3a1-d9fd-4afc-e634-08da6b978bc6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 04:06:25.7679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UymYj496281dIDUKMUCB3vz5pSb6OEDx95jSFKUKy7H9MWI4BQCgxwa5UikfypAXVV3mCrEEAcovQz2eDpBy451u0l9HuwYvCo12AGhhy3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3919
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several ocelot-related modules are designed for MMIO / regmaps. As such,
they often use a combination of devm_platform_get_and_ioremap_resource and
devm_regmap_init_mmio.

Operating in an MFD might be different, in that it could be memory mapped,
or it could be SPI, I2C... In these cases a fallback to use IORESOURCE_REG
instead of IORESOURCE_MEM becomes necessary.

When this happens, there's redundant logic that needs to be implemented in
every driver. In order to avoid this redundancy, utilize a single function
that, if the MFD scenario is enabled, will perform this fallback logic.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v14
    * Add header guard
    * Change regs type from u32* to void*
    * Add Reviewed-by tag

---
 MAINTAINERS                |  5 ++++
 include/linux/mfd/ocelot.h | 60 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)
 create mode 100644 include/linux/mfd/ocelot.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 28108e4fdb8f..f781caceeb38 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14467,6 +14467,11 @@ F:	net/dsa/tag_ocelot.c
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
index 000000000000..7abca80ba7dc
--- /dev/null
+++ b/include/linux/mfd/ocelot.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/* Copyright 2022 Innovative Advantage Inc. */
+
+#ifndef _LINUX_MFD_OCELOT_H
+#define _LINUX_MFD_OCELOT_H
+
+#include <linux/err.h>
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
+	 * Don't use get_and_ioremap_resource here, since that will invoke
+	 * prints of "invalid resource" which simply add confusion
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

