Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06266546C00
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350245AbiFJR5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347362AbiFJR5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:57:12 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2121.outbound.protection.outlook.com [40.107.223.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C8D6D4E6;
        Fri, 10 Jun 2022 10:57:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHdaGtKhS2F8DYwgoivCYKm9zJIA8PHB5itowYg/+/mWEYN3zn0LSW/NnGk9K0Afl7Oll2Ck6ApgtY3quvrXwuPQtPd5fBLjHAgwRWm+clOO3Syuz2yAVL0fPNo0VROO9EpifAXQFQu9sGykzp+pMA5cXpN5P+OGCgLlB3hw89HX6/OwnzfvyVcLJfPFv2l8FZL9gXcAXN7zmoxbRCaJLm6RfUdYcpqrx9omn9k+kMo5bUiosrVGPtH8+K30tTNGY6tTYkbHL+NiaS1RWsvrb0gw0CPbMOy0tKtGNEiUULmPDZRcxqgA1FPXmzQQjb7C6PgN+A5EzD3miiQVhTEYPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9x7kWRSNpD+mSE0GFZSzfzBcOugNaKgLSOz2TG7srtE=;
 b=hiHCjLa0tvlV0mD9iZViyI0dlWn3peqj/yZNsYumM+8XLtWZgk8iNpD/H4Aj1ZFsd0ORIqeq8HQ6Ee8oYOSJkvuQtvuKaEvX32g9XZJyygDkSpCp1T6nyrtQTKgyrBXqQ1p+VBPXP8ZLcjixmtYiHQsyWo5MK5P3mmpDX5StOExjqU6OXrG4Yfauw9NKObv7QLv0mEL4y7lOSIfrkdBCVOj1444JZOkj347vrD98LwvGiXjSaUdot6WD7cidTKHZYbbCq4Uyj0a34hqBOWSJfH4XWZJ6YUzFDQu/HDD8pNc4YOG0lMCRa57Rq7ZPXCg+jMvzdBnztLKNySso56JdwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9x7kWRSNpD+mSE0GFZSzfzBcOugNaKgLSOz2TG7srtE=;
 b=UVXz8bGfQf0/8G4ZlC4kuY6/4aGpyF3yIViE1v68LypOFlMFOjgAQj7bMYDaEgirQ/hfU073V90myKQ610FUR/V2QVby17P5sPDW6LsMsUyLQ9qky0f1i5UrNLYbGh4Jv078ooKpQsJc8mV6hmK+R3mxtQdZljAKIOBjAJcVecU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB3356.namprd10.prod.outlook.com
 (2603:10b6:5:1a9::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15; Fri, 10 Jun
 2022 17:57:06 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Fri, 10 Jun 2022
 17:57:06 +0000
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
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v9 net-next 1/7] mfd: ocelot: add helper to get regmap from a resource
Date:   Fri, 10 Jun 2022 10:56:49 -0700
Message-Id: <20220610175655.776153-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610175655.776153-1-colin.foster@in-advantage.com>
References: <20220610175655.776153-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0070.namprd19.prod.outlook.com
 (2603:10b6:300:94::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3b09eeb-93ec-40b1-6b12-08da4b0aa182
X-MS-TrafficTypeDiagnostic: DM6PR10MB3356:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3356DBFA7D81B8091A43B36DA4A69@DM6PR10MB3356.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cvfdHP9s4SqwitoGJyhVi/S/u6LiT90tlmDx9lUTAReWWWrM/d12/Onh6MlRiiZQz1CQ56E3ew9WHFpXiZF3dHjPhfSydiCg7hsFZ2KzjDKF/B4erZSHe+zFFZNoRYwiS6+jFbGae/zGTC1ZNTQvGXXHQ4G0wzIaUpC1jY8I9YGL5yTR7qcfDnd6k4WFZVz3Vz5eOSKUiBokLm7FxJKB43s+L6RVReqRym8FR/qcVJMHYEVvbrXnFMBdKf7GHSnSb256IQhdyx9nH69zE4LetqGwXCr+9GIpxsKc8CR6BhVtyNVFXagy0SvqpALckSmTgzTwDOmqeWPn09yAo1lr67zGUAMrtNbGkUaRr5IjWmQb5zQPhOou4oXbb+N1tFlX3w/Ow3WhRq4L2h0pOSlmgQsWLWp3OlO8620s/aRCFoJIkcga9BUPqHAnAUdUlhby8mZU28ttl7q6P7TNysVjDcKPpdNufqSDA7MMf27At2hk4jHkVZLLx0Zp25F5nWhxGZfLwxgcdh2nWevF7o8Jm75a9NWggRLvQBmMWSHNC7+lLRdr+mGiDpDBqtPclExnUs6VEHpFkBGWmaVes0HAuqGG7Kz0oPya6JqXI8X1hpotG/Ym/8jsuLw1Sq/7Ultk+vHgoh6mfdrlW7HYJtLJyh6RbZEuBL2QiBWFCANJFZC4SKWt4AtZmRMO4eJyGz4X8nrbxTMzoR7rTF+vVsClNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(366004)(396003)(136003)(39830400003)(1076003)(54906003)(316002)(4326008)(52116002)(8676002)(2616005)(86362001)(508600001)(6512007)(26005)(6506007)(6666004)(41300700001)(6486002)(186003)(83380400001)(2906002)(38350700002)(44832011)(8936002)(36756003)(38100700002)(66556008)(66946007)(66476007)(7416002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WSCID2o9/FOzJ64AHTauRRdjPwPXpm8Ddiyyw0dZsGuRZbPtmIJtSYhIjkgH?=
 =?us-ascii?Q?X40bTu/TVzRwaM6L6s0rIPv3jSvduevRIPX2Vj2DXmL387I7TsFezmKRZB5k?=
 =?us-ascii?Q?KBTIwPWXnEb6KcM1YCQ3J3snLVwIwLzjbZQRIsK2ZGu/4Cr/9/Nd2gUAf3gT?=
 =?us-ascii?Q?w4FI78x2z4IA6g3V1oqxCpxrGh+vZpoAxTqiJavPXCFcbYJ2yahjZnPsmAR0?=
 =?us-ascii?Q?VpRlCZ3x7FjzS0Hm7YBqNDufLfnHHKo/8v1erTLGYhaDCApe3E+VmiVfIBv2?=
 =?us-ascii?Q?1VmnJ/Ed6T2fZ6lY5H6LZpqiEyeTXcemrDyPI2OKfJUQ+dMoq94f53H9jMm7?=
 =?us-ascii?Q?fCS1PP7QAbeckHK6c4sClMbJYUEYZt30CFbOgtJV6p4XewrQcRzsU7jHu66S?=
 =?us-ascii?Q?LfBFgg+/GUcy+O42MSDKm3gr6nwZ4AHxzDR/kK+5y/4sq/hh/g2/356maj7M?=
 =?us-ascii?Q?dIYqUVklhPSYgURwq9N+KiL4jTHKOC3OEuOGu7g6cSTLrGiNtJdSawnNZqe1?=
 =?us-ascii?Q?/LNE/BqpCJ6ehhWcnXP2RRntz/xfpecfuNsV2ZQNTi6lz7ZE01CbCVhZUvg4?=
 =?us-ascii?Q?1Wit76kenRVQlrkxWHz9MO2sQQUC/TG9ggWCoRFr2FnvMI2bCrpKOhyIqClW?=
 =?us-ascii?Q?Qm2nqZyQKPPs3lrfSUPU/F7aCLuY6PR7S8fsa3xxzPY0xXUZcB7D+u3rYCXo?=
 =?us-ascii?Q?OpPUnWNYA+h7gbhJ4Vwh5Tyuykx1cbK7h0SCQFmJN2tWkg6wZGV0TZIUZdNr?=
 =?us-ascii?Q?JKbcPMZshuaFzUuO5zZOAVKhFfyl9ZZMjHQvQprfjf9ldku7iTusgvxlUo6j?=
 =?us-ascii?Q?7rOoqspbQtM9eM580wlVTb9npXutcv5cK8qJihZ1zzrC5xDYCjnopNgIOZjP?=
 =?us-ascii?Q?lkA8FFGgo+QAB4kLFf6tTDIs02h0KJ3BHQIln9Vf6D/q4y7JJYZ0LS/o5u8Q?=
 =?us-ascii?Q?o4ROgyrscB2ejLyzUCK8ixGyvtBegBNk9Hid6EifUNZbORBEnGw0Tw46fq8o?=
 =?us-ascii?Q?g12lb3/g7plkC3gchCX71ZrqlWbQV+3Ho3VPf9CE0PA5Eg2v0n/aalMYngb1?=
 =?us-ascii?Q?BstYsk3+FalmEPkHDp2ASD28evjwhKeatHeVIYfprB9sm/cQEGLTjr4yV0mP?=
 =?us-ascii?Q?7Io8jmohp8UpFRGaBZtZRaczMExczH/bFxFXoiKYvrm561Pq3rfLl6mjLwC/?=
 =?us-ascii?Q?BGxYK0t+1iEN/I3dEdFnh7UiKEYUKPvHSKg1go8nQCCNW5hJIhaT//8CI5k/?=
 =?us-ascii?Q?GY7azhOzOvLkvW3DdZfq5hE4Z/Dd6A2xg0VEHPdVQl10oXxMAbyDLaayfkJ+?=
 =?us-ascii?Q?3MAeABjgbpittYd3cQPlJGZ6vHww9cxEi3Gn+fesGiSnhZPp/FT5SilPa6cL?=
 =?us-ascii?Q?WZagHOWgxiwBPiUY1vBlMNxzq86q/EMpMC/ee3EhsUFzHIDfmP0A9UX1R+L+?=
 =?us-ascii?Q?l9432sok7pfenG+5EY9vpU01S4FS0ppJ5sNfjUogkg8Hgj/teY+g+IHEXsH6?=
 =?us-ascii?Q?lFXxeWsDQ8wfewqy5c4hnEMYnRnKNE10LP6BNq8Ywk+7TkwMP1mTfzwYW6EP?=
 =?us-ascii?Q?sSp9XVlct7JrYZR/QSA+1hu6bhEgpuvbdyKvLcWtgE4wFKOSM7otCcSy1rHm?=
 =?us-ascii?Q?gbVMchr1PiRtYBvBp+4ama9Tqhis0jcgPJppAKgFvbRCLj7Bv4u4sQh+eF1v?=
 =?us-ascii?Q?OrZQBa+qLqw3BcVokk8w5bPmJUUgRCQKRdpsEV9Zw/8iok25knh7F418J2kz?=
 =?us-ascii?Q?vzZyiOW6iyi1ylP46tA+XuO5lqBEthdjLStfHNQq1O5gVBjZU8xF?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3b09eeb-93ec-40b1-6b12-08da4b0aa182
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 17:57:06.0750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jcc6B59K0fECSVgDFA+hCr3ooNMxqj1IxNrBt5waAPRrzM6GG4Zq7CmNcozdRs+fXpC3eqvXkCBrDfK/Mwegnt1uAap9l12B049G07bK8oo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3356
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
 MAINTAINERS                |  5 +++++
 include/linux/mfd/ocelot.h | 22 ++++++++++++++++++++++
 2 files changed, 27 insertions(+)
 create mode 100644 include/linux/mfd/ocelot.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 033a01b07f8f..91b4151c5ad1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14352,6 +14352,11 @@ F:	net/dsa/tag_ocelot.c
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
index 000000000000..40e775f1143f
--- /dev/null
+++ b/include/linux/mfd/ocelot.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/* Copyright 2022 Innovative Advantage Inc. */
+
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+
+static inline void
+ocelot_platform_init_regmap_from_resource(struct platform_device *pdev,
+					  unsigned int index,
+					  struct regmap **map,
+					  struct resource **res,
+					  const struct regmap_config *config);
+{
+	u32 __iomem *regs =
+		devm_platform_get_and_ioremap_resource(pdev, index, res);
+
+	if (!IS_ERR(regs))
+		*map = devm_regmap_init_mmio(&pdev->dev, regs, config);
+	else
+		*map = ERR_PTR(ENODEV);
+}
-- 
2.25.1

