Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690145639D2
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 21:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbiGAT0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 15:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiGAT03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 15:26:29 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2120.outbound.protection.outlook.com [40.107.100.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244A53E0E7;
        Fri,  1 Jul 2022 12:26:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4YrrszoDT3tRSFOWo30E17kV8/b/iIroM2VSHN/+lFA3E4xj3YJpiwK/bqGx3/G544nWfKhdKhJdsRj8WNQ4EbmabRg307D7cT37ldujAeRTzsok5UIT5d7GofUrExwGbAfzAoxhvpA6VtM33Kz74trPp32phhAT3xo7gpEm8jDCHuBr7lvKUH0pbgx+Zdus2X12DZSz3dxGqsMCwTnDf5CvlP7Di3gGYun6LVsvhgEW3lShFWaQJCm8Vtf8ohXHja2RUKJd3hkD4Cfbky/dpUYzmzKicjhKxit6Cdc36LHL3IpMnszxslOmbsxK6Y/EH6q0+jRqXlQpbxBJ4qcxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fu5BLJ4wyxD8/R+wc7kPGgRPGpkGra+PziMdc6sLFIo=;
 b=mgVYGKPX0n5bHwaQVOLoPYJDMahKUTm3pDT8u+2XO95XbKYDDNFYi0bfmdNooF7xM8e6zM0H2/l4a7Nzu0FoTAeZo+XnxrfvnNS5/k5/nPGY2jfXstIYIdGL3kD1zwTI6qb5NNCatiGX9UtX1CqNUHhBEbzg/sa/JBGD/5XOlzc9tb2SrF1anLUTaHTCsqaZ23Jl1RyJGNPKlw48QtDRmLgDqmIvGW9FtYLMoEIrjCo4HG5EWlnCz2E29m6rUahxsF9z9OYvsr65uBsiigD460cc5IGs0SFIbbpxvf5eQPxUEPKGHA8J/XH+xO29P2Mci8WKhEtRl9pmaQyTf700UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fu5BLJ4wyxD8/R+wc7kPGgRPGpkGra+PziMdc6sLFIo=;
 b=fTB77PrRiseyH/qr6xxksJof4IbsAtmrKyd2lCDhH6WMZ944yE134AT04T3tTWwZg0sOXjf2dzvA6ahDPr8WfJVv+243GmR+CVbbO4mVDHcq7v5KdW4pxqAHC43U9sWyb4DdlAVBeqISeJXTZFNJp/XURtztykbKwt4NQQektxA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR1001MB2230.namprd10.prod.outlook.com
 (2603:10b6:910:46::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 1 Jul
 2022 19:26:20 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Fri, 1 Jul 2022
 19:26:20 +0000
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
Subject: [PATCH v12 net-next 1/9] mfd: ocelot: add helper to get regmap from a resource
Date:   Fri,  1 Jul 2022 12:26:01 -0700
Message-Id: <20220701192609.3970317-2-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: ee98224e-1202-4b30-9653-08da5b979335
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2230:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: giJ+jjKGBGP/I5APyudV+PHFfvcsOYJuOLPf5FTWLrGn5l5hhk26e/ia5IMPdZy/wLGJgzoc/IdKhRE9L4uGYV/v6Xd8cTqk9Y6d2H/OBjBVMrTeqFRjmmhE2llaFpk4OBD7xuNf70RuVTGca2PiMbW19gh/0Yuz9yNVQfGw6pcxgoRavIoSN2LvajriqPX4ET+gpGu+1k+9YFKJPXPfcCJ05MDNDpPRz0tEGFAAgjwj03+U2YoWCYGnT2tDaBccuZ97cknJByVLiMqBhAwUT6NgTE6VZGwXuOjZMLZ7I+Uq4EvI+75EQm+ylQTWSOBt+JfwOY4qTCfZ9ln9Z58py/EhtfGibrUslUYlN9gbRcFD05bKotr0f2IiMS2kgcwQAv11Gbit+GTPhLsEcQRVFJ/2/HnBmF9pisiTQo8zwMzwtkYHIVB4Xb2MJXEVtzaFO02T7iCJ1GTA7gwCiAHpkyFKlDeoaFcH+0LX83Wld483AsJlP6I10ExSD0UgyNQ74WlnsEcq73UPQlaMjOniRbIvvVqV3XSn648GYtxCtIyOkU+zDqQ658AZZ0/tIQoGyWKU1K5rAtatihr8NyZNFnX82EkYkFXRHVgpc46WMwGFOjN4RZGKYsKtxkt5jnTNKHVfs6+lREq8PJoPSuWi9imZw/uKFI931A+UpSEwsY4Z2YF0qUjtJY+E9gh0tMaepjUKiWGhorxLaeoovqM+L7Nk1/soVau+QRuIyJp4XdrPmkVyfeYp4jtM6zIk1kUzR9Yx7tIphHYctKZHGvQ2f9ggKmbsemdvLAr47QW0Sw57xGVMC/ULEmdDtohqAYez
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(39830400003)(376002)(136003)(396003)(66476007)(38350700002)(186003)(8676002)(8936002)(4326008)(86362001)(66946007)(1076003)(5660300002)(6666004)(38100700002)(107886003)(83380400001)(66556008)(7416002)(41300700001)(478600001)(316002)(36756003)(52116002)(44832011)(2906002)(6512007)(2616005)(6506007)(6486002)(26005)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cHyHsSlNfwmnT+pvkqGNBg4bvnCkeFSAtu+Jx17DfEDPc9qsZov7GB8KYmbl?=
 =?us-ascii?Q?eJXpKMD9OQ04FCCJ0U/Na/4i1DunJTVh7oyopks4jSHaoNV+UFUbkK6rT/J0?=
 =?us-ascii?Q?Db/kyuh08wmFZxu3sQ8PRO2029Nga3tnjus+tyYfF7jS8Xroqhhu2WTWTJ28?=
 =?us-ascii?Q?vnpB4b0VOkH74V2UNkaevusNNiZ9LPuBxNnw60CKAGY9hiZ4a36g+vI2Jg5e?=
 =?us-ascii?Q?EX/UeFcPAKgRekZ4PjS0cC7/AJ+WUbZKS3b+cq2QwMfGX6K6E3RtoX6SUI2x?=
 =?us-ascii?Q?bZZB+FNe0fdPTgEyYtvq9dc+WQxCAMjfGDrEOugPTTWFHCegOSHINrnWPBB1?=
 =?us-ascii?Q?8CzDdfhbrf8rtSBl3Zu8LnE5LQZGF2N0e8hUf0E1NXYO9sH8Q1tXe9kQysNR?=
 =?us-ascii?Q?9kFma180CJ1JplNmOC578y/uIyz0Y5Sij8PIkaZsLACz4CDKh4lrI9IKvm2v?=
 =?us-ascii?Q?Ntr3/pUvT+w1IbCvrXmo3S/fdj0O7CLFY0JZgrLR9jGqeKAUPkW4PdlMmpEp?=
 =?us-ascii?Q?1KuDr5otO3z6rSTXPFjqcL4QZhuPLmrSIeX6JJSDm7IwNnUWyDrSfkLHk+uw?=
 =?us-ascii?Q?ztQLvfxeen2TCkdbcaTmIcCBepuhqs9qGUEjHAARUzlPJfLe8wIRCsNKbJyh?=
 =?us-ascii?Q?TsqNSN5XX3T1mIWbmdVrlBevbjszCp/7hnCrfgQG3P3O9kGrrO9tkABJbkEG?=
 =?us-ascii?Q?mZ+aRdT1tl2BG6xbOPON6kFgA9zRez5lqBJsbqft1OGFDy4oivvLzXmyf/Gf?=
 =?us-ascii?Q?sXIbmVe/GEHA3wFAEO+XS3BDsiTinmmV/eRSSULYqkyuD8UOnzszCNip1k2A?=
 =?us-ascii?Q?Glxjw/oFRavfiTxojLofUJsRpIZqkWuM7rL+58s5K3J0lZWIlM7O/qGMFgx1?=
 =?us-ascii?Q?GLZLtSh7j0TD3Zik5KmJFquN7TDr4lyTf/qOAFS/aXro3YWv9VAD4ciSB37V?=
 =?us-ascii?Q?eKRPirg1k2YFj93HxfagcW9iZIGf5RieKdcfEFABFWrnxzVM+1zpb5KqPoPc?=
 =?us-ascii?Q?jTIV02dZ1k+WU6qbyj9QWc54A5xTg/gxiKjx126N3DM1lZVBcKuSp0QQOE6/?=
 =?us-ascii?Q?hNRU3XICujY190VNvIl7Uy2ODY84CYymrGUc67biNNQWhl/TeBAV07lT7hWw?=
 =?us-ascii?Q?7+gR/1EOiWOUVE/I38MroG501e0W7bivAGM7QI9HMuEQqGHTgfueFtngCrY8?=
 =?us-ascii?Q?ChuqfXjQuRR0wYP4jqO3OLaN2mKcVAW6oPIJ+YpK0n/xOsyaK50PHcuJ8Wxo?=
 =?us-ascii?Q?OhgF0N52SnMe5rsZEGsqnSaEB+z9kcsibqCIirRL4Pn3ub0U6b0TdjqxG9n/?=
 =?us-ascii?Q?+kvRCmPQl1uhuYKCsefAkYroRG4QxUmeKYz2Gx02YECiNa3e1hQWPa2GMjej?=
 =?us-ascii?Q?mT2qFuNxKwdOwzijwSmBJ6kZN8JFK97XnLgBlNuJf9hxLye346fV0m0IhuZ1?=
 =?us-ascii?Q?KkkjW0abM3/Xdcudks4QN12+Gsn/Up+SYFu3ur0eekzXGq6QnFVRA0jKJAKb?=
 =?us-ascii?Q?eogg7UxlHam/3yHnU3bkU16OZ6Ul43P0C2J/CY4Nw61ERrRYTxoX9b2XMk/I?=
 =?us-ascii?Q?vr07GWZpInjw5KaUCUFKhc7PLSKzkQ1eJT/aJZp5wEO9YS1y+tpCNQMLqIc3?=
 =?us-ascii?Q?ag=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee98224e-1202-4b30-9653-08da5b979335
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 19:26:19.6485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XDBtop+uGIc8H1GR4NLm6qOI6xglcV4bS2aWdbDfjZ5C1t5nyGsI/8F6XlcvPOs+1WGknIQzAlQcnlCFR63a7MY4v9LrMjOIrSNUR1m3j2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2230
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
 include/linux/mfd/ocelot.h | 51 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)
 create mode 100644 include/linux/mfd/ocelot.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 7c029ab73265..c2f61ed1b730 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14413,6 +14413,11 @@ F:	net/dsa/tag_ocelot.c
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
index 000000000000..7e64870b75ca
--- /dev/null
+++ b/include/linux/mfd/ocelot.h
@@ -0,0 +1,51 @@
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
+	return (map) ? map : ERR_PTR(-ENOENT);
+}
-- 
2.25.1

