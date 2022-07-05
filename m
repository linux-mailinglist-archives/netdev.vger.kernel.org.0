Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA685678A9
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 22:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbiGEUsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 16:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiGEUsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 16:48:15 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2113.outbound.protection.outlook.com [40.107.92.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F833DF5E;
        Tue,  5 Jul 2022 13:48:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8LSAYUE/eRfWWtWjNUQBKLdLE7zRnAMMyGnvu2pypuoQnpapJKT0onKgBOiFHB/G9cxccJgJTusTMK/77qQ9yUM9Kp3uqebaFcaqLyykHFrBDZug9K0ZvIR1wCrwHZq8W6cAKVuDHei2G8ZFv/UAA9RsekqRr915+NPg3DxV8kJGyBguf7l1A2K64uN/jwg+rcdM46CNhCq6U09tXoZzY5MQDeXPK/gTgjARspBRZS0j6l+LEDJ/IQ9LTjsxnBdXyg2c5HHrmam/WyLVT3cSN0mVgEP87iu0lgxSeUYq5t5OoHFKjoB/Z3iigR1g3DJtaOUsnSoJ4Q3ifmx4XYX5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDfZ6IcgECARpNv2ssu6cgnoLYn5EHLGLSD1wNA6jJw=;
 b=jOni2LTOiXJZUyMz0yCUJmgqSuMRPJSNys/pm692C9hYzpmFTiovzpgSJ1PwrC8XReUWPESextUfaonz1BuoeqsHjC/R2bLKyQeZfFLEb3JqNJdZ9Jw6tNvgP1OL5ZBznqzThBTG5+WU4vLZEDOORsrNgcYm7T5a8M0HeV1H32uerHz9DFB42EZicRhEOvgB3ku6P7KLAPICHhow8R3nC7g/W5PZ/mXWGbEfNc6XWlS4bwQ/7gUyRvzcG9FHI6HVr84NZZD78qrSzdXJeLO6JX9lHgbE2Bvly7GmyspZAkWixuVbeCFDeH420fvnh7fIAZ6p0umDldkkGNCS0oCBrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDfZ6IcgECARpNv2ssu6cgnoLYn5EHLGLSD1wNA6jJw=;
 b=sh6Lk3tGvTtuAIeryvFjZTO3y/XDb8VxCjwtVk4D8N3cdUqUOB+Xn/BaomPmI7YeiI3tL9VesKAh3AOWu7KCI6dKb8ww6feF/9Wtly5d1b++0FhljrW+cEB/xnVXhKzS0FmJUtlgmWJjRSC9yebdX+YndG0Lz1cd3CKm9YK4ZwY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BL0PR10MB2898.namprd10.prod.outlook.com
 (2603:10b6:208:75::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 20:48:10 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5395.020; Tue, 5 Jul 2022
 20:48:10 +0000
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
        katie.morris@in-advantage.com
Subject: [PATCH v13 net-next 1/9] mfd: ocelot: add helper to get regmap from a resource
Date:   Tue,  5 Jul 2022 13:47:35 -0700
Message-Id: <20220705204743.3224692-2-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: eb9dd48d-3723-4a9f-23ae-08da5ec7ac03
X-MS-TrafficTypeDiagnostic: BL0PR10MB2898:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z0iMTArs0h4Ryu40QGYx67J8WyUAh1BXajjI2CfUw/PyYl7iBEap6ZMPeKS32iDf+gkJUfUBKUayDn6Qb7c2DE7wTZUGmImBjzNxlQ/2x6O0gvUPAObbU4KCThfmmzokxgq8wn9g2L4He0YHOjKLyVccorvYzps4WEJR9N1snT8r6Cqsy/cpwuSZRhZhvlhtufo+YYrKDK2Sjd9YziW/xpOSZstE2qbQtTTpj/odObw/rqsoBO9mPF5/H+AFT5xmK7jlt4rB1p9vdzSJCeR9+U4Z3nrkjx8wO669meG9BgFyxCIIr1nAqSLqnZBv0GKflTL52X+N9HGDBcdOmvsY1gnGHQXgfyK8NlG8BpuORvFjrQ6I99wC1b/KmvMtMdFWqyCvx04UuSRU9AOS0Jde7ppq8Hu9S3A6OM/8RxQjW/MT30UTNS/bxo9PlMtSo5f9HtcJjNfpPUa2DFBMxVZ2mIxutMJX0bd0+fkuD0HqD4GXV1/ISipq+ijsWLlEOOWi+Le2L6aK2FX6QE9lyy/cBxyghIpcmK+57EarupRhE9qiV6q6G9zNJhEz2Tkr9vrjeAkBHX+Q5P/469jLhdzhiWnW+uCh8/ricxS0RAIM9U9f1EEiuSu+McmHiosEK72B4PGTA+bv7MjVc2MErUF6Jo9WCtMOujAwTa6LXbpr6Rgod3l1UReUjpbIEoopwPbKwtgao+zHCHUAOJjsuKgT/zmW7aqGiZb+85t5a95tbwe8wKndYBlRVZ6/HThQ/FXSAoV5qT/M07GAd367kzK4UANCdjzXpitbk6EJgVniV5Yxf6HTKrXe22wJUqtKaFF1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39830400003)(376002)(346002)(136003)(396003)(366004)(478600001)(38350700002)(66556008)(66476007)(8676002)(66946007)(4326008)(316002)(38100700002)(186003)(107886003)(2616005)(1076003)(6486002)(41300700001)(26005)(6506007)(6666004)(52116002)(6512007)(54906003)(83380400001)(5660300002)(86362001)(2906002)(44832011)(7416002)(36756003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hdgu1CvzX5EI/QCqSAA/HDZsJcZZ7r9NTsPSKKzEHpKsdfr9g5chGOmwTYPN?=
 =?us-ascii?Q?xRMHP9H1pkEcVlw/63Cq0M047gFGOO4A9HBd1t0KBxkUVW81U2rSBZOA8/ol?=
 =?us-ascii?Q?zPiIZPLTJZ5ysjGfTA1vQpJEuECT6hwDMjGpWoT1c1Dh+Bq8kZC5+xmjLVR/?=
 =?us-ascii?Q?wLf6gjfGuvJp+8keiEus9qslgipQClviYgGMwfLpFVwNww2r8GCYCx4RQmPj?=
 =?us-ascii?Q?cz5X/FX/qXhLe7Mlji7bll3ikAYRK3579/3kn9ELoNJnQxQKnNiZ020khDcG?=
 =?us-ascii?Q?ZlPjTvzWxfszaRmCM24bRZsYNnYnOzm7gPBpQ03tFgXMsJokquD1cMfAR0V2?=
 =?us-ascii?Q?wWDdRQPksTRQhU5Re3O9MMwz6RFn3nohmoGj3j8nJOo2QxPBhMovLzy2qAkP?=
 =?us-ascii?Q?Zfxtx0U67tIjJN1G+Gv1KnZ8MDElQ2sqs46WSeuCq4pTuoXWWCmj6NmayfNx?=
 =?us-ascii?Q?eaazA8NjyvQ8ElRf8REeJVYb4rOyCdIEPfxrOehvEzad8/heIlNziTYSI4QI?=
 =?us-ascii?Q?NTnzyRYvjQV8uvcWnl7X7m+UuxZNEwh1dSYfPsF+wkPD+Tg/EAJdtKBS5pPI?=
 =?us-ascii?Q?J4e/4WJva4/a71xrVlJyCPDOx5ZnM8GXrSgTUMvhRGPcJcQU6TtVmOZb+5C4?=
 =?us-ascii?Q?7c7yls/oNEoqG1yK98ugr+MFf/HWA7Lv7qWZGnN6dNuJ/NO7/eJFZs8/KiO/?=
 =?us-ascii?Q?+yRFGCKEgmL9FzwDaHA1S6Cq7t5zp4soJef8VGBD6P6Iam+t65AtjVih1/5O?=
 =?us-ascii?Q?gHL2xilhxtYp167PYCEGSZ2UF8h7c/DTMPYc8aVlMUpcKZpLv+BJpgpZQ1rx?=
 =?us-ascii?Q?kbD38B5G6yEKXMuVFrsyKnDG26pwKg6SwPandgQ1cEnkdP9vXCIcMRjZ+Z6N?=
 =?us-ascii?Q?YSelShpOdJtYMU1H35kaYqeeExOcg3qVCJnBedDvuN8VFjgS+lG/XtbdYsAb?=
 =?us-ascii?Q?jGIgTxZJbToMqsldIJr1TbeGK8zA2wIuwSitNQ3g45g63ZZs8IGhXNMnAPPD?=
 =?us-ascii?Q?HyFpfN4XJlgF4mS9eD4xds9EcISVCSdtE/yujVgokuYtNNlf0sAyqMXEqn5J?=
 =?us-ascii?Q?S1u9J/h7Y9lPENwY5vLsFYDKJ4HuX0YXVAOyZw2kTUipa+mhldmODoiMvBdR?=
 =?us-ascii?Q?kOqv7wdxFbZ2MrVfF6kqQdWoTGy80I9DOrnFOb8jEr4xjPSvErFOMzP/GUaI?=
 =?us-ascii?Q?xqrBRasoIl9MlZqZth1EWUDWBZ15CmcxM+BAc6nwBqOvnrmaywD6P9lYsF2H?=
 =?us-ascii?Q?E8jnm8DmHOfp4R0sdOZHDzed9C1I5Vp1ti8FULtm5HYMF5C+A/sC57uQi7FU?=
 =?us-ascii?Q?AbS1fyF2jcs/tRxxTFrjvyeoo0cNfe/DZHs1oKmdmKjm604g14k7q5FncziK?=
 =?us-ascii?Q?i+UNPzIQP2pQMhzqgheuMRP2onHxM4H3iaJHmkW9Jw63hGakeMTZ5DyE9bEo?=
 =?us-ascii?Q?XIFICAOXinaXIyJcnMnnFBT4u4gtdcm1LkWKNGtTiQq9KlyTbTwkEXhVLZLv?=
 =?us-ascii?Q?Lhd/z+3FH7+xFqZbrd1376UxqMNQPFLa0FNZYQq8hAjMHGQdS+oTjASa/f9y?=
 =?us-ascii?Q?sRfbrtqLy3+gXEgjT1zU9QlcaysDCt9nAVwIJE4fZdxqvfznaiQq1eprWOxO?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb9dd48d-3723-4a9f-23ae-08da5ec7ac03
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 20:48:10.5767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zBkaiGC75ZID4f3w5AlfK4F0u4vA3nfY/vs6U+64UE9A4ASmH2+OfQ8+W9NFwsRs5w6l3atyv5eoGXUgTge05r6qWMEBjVnYbwQAUQBfDn0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2898
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
---
 MAINTAINERS                |  5 ++++
 include/linux/mfd/ocelot.h | 55 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)
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
index 000000000000..353b7c2ee445
--- /dev/null
+++ b/include/linux/mfd/ocelot.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/* Copyright 2022 Innovative Advantage Inc. */
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
+	u32 __iomem *regs;
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
-- 
2.25.1

