Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED9857D930
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 06:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbiGVEGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 00:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbiGVEGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 00:06:34 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2097.outbound.protection.outlook.com [40.107.220.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B919089A82;
        Thu, 21 Jul 2022 21:06:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njb/JYboHI1t64/rDsbczUGqXhtMwPrCR3mj5b8pf7CVodXBb/vnEjb1o92urYMGw5OyDP1fF2PNa5aysklnSuZnUxjEDEr3AjBnGRdr5irVWVfsDUnk4nD0VyYDvJlsiEJerPqOLjfa8n21u1P2QW46aefJ0qElRDEeLO75WVO6bGkQ05CQW3THMp75UbtnvZD/+zmNoMOYGY21fsM+zajqWFvvjLDKdAdIC+6RayAdjZbsyE3Zar+xfk8/Jgd2wGOh1T0JQI1+5oHtL7MSNQ+JK3KQK/E3MSUQGyP5MF+sv9gJkJP4Cj2+UOLv8eP6LezWIBXWqcYEvfys/pWD1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w6yr94A9Iz2XvtHkLHQBCRjbbiW4Vk8lDV+gYVxAFAk=;
 b=fL31QMjXdKIZYTPtJHHqRtrc+2w68A1INn4WZAl0w9wbtB+9x3gDPYuF42J3+VTrtzC/TOc563mvgJErGvSeAePlYIDnU288W9YWAQsBHAOh+Q+uqDTWpOZ8R2INWai+mrUYqKU8m1d1NcSno8qV4T38x1y6WcmOdPOq28tWKSWF0T4sCPDTjKIG4q07BFIMUzmSBkGJCx3QZsGK0TyAkjO1HPsLZpQTHPGHzA2bxeLdYHSjqBPbBjslhaai+l+YAqZ8Aa/wStC5cY4bBg269gM/iaWivcyF7a7NTjY6ePLonzFmugOhKW3Iducy1KF2jQnkXtUK1CeZ75iXJdM8SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w6yr94A9Iz2XvtHkLHQBCRjbbiW4Vk8lDV+gYVxAFAk=;
 b=myTeIu3wDViy/a0GLqMFdHG787yRq9LWtKLxhpCHEZYqDaTJ4N+cjJmvKswypIwpg8cKuF5T4r5RCsNZLJdcIrsTxVaiJIMpFXktMroFzHfExnE314jEV+mt0gWQ7ilsrphFE4RECE/22Fbjt+GG90UZEfyPAWC/0SBT+wSpz0Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN2PR10MB3919.namprd10.prod.outlook.com
 (2603:10b6:208:1be::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Fri, 22 Jul
 2022 04:06:29 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912%7]) with mapi id 15.20.5438.023; Fri, 22 Jul 2022
 04:06:29 +0000
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
Subject: [PATCH v14 mfd 4/9] pinctrl: ocelot: add ability to be used in a non-mmio configuration
Date:   Thu, 21 Jul 2022 21:06:04 -0700
Message-Id: <20220722040609.91703-5-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: a0da7609-ab0e-4c5d-4932-08da6b978cf3
X-MS-TrafficTypeDiagnostic: MN2PR10MB3919:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: deOvO3FbizIbfwGrBpYjRwEYHprhe2x/hNE/1/VpcSiDiE8qW0zeLTnP/H7+Pq3J39cruyugvU9RfT76dVrXkyDv8YPKEf5DR5GSY5ugfceGfLCnkHQkVoFcLjm4ULWfetMTf7zD+zdurnj6XAAZ91xr1o55LywUL8oI3DLa39HvOiJjySbwWNXp6/9XxpHFUmKD6UCwKMsNb/fjg9YWpt7XSglQcWIJOex7o6fkzHKwATQ3sYl9Xf4uUywLcVicjnwov5xbxHXY89UZQB6zq2ti5IYnSGVwrTQj20npoNBbmI7+W+eQWRE5zRrQ7tOrFMy7gkRnTdTfG/Cm3YSTPQJHd1Wx5ExfZBE9CMfXnbrPjcqlewDCJaqxk8hCdCcrx7h2fxnFk1rN/uE/vQGrIwpCRzr5KDMg48i9XUw0dZFFC0xwz8NQlApxLnGmOEOt2bON0d41SPQCQCmAdldx9r0vG44ubbu6i59gx817v0Fe05PKLbY3G0bd4vU1SWE5kQ6tFNQ4++qpwMyP9EHErHazBlg18hT2NJjNplRJ8mRY6EaGm1xCz98wqUD3q6eoUSVxJyF72zCpXT2sGYk2A7JLWJwb6jlHU11jRjQQp4hdwAU7wv1YGPhVZC4f7jpB3yBxH9W3uh/6+zGUlzRFcOVMgp7WgD+MxUge7LQ0gw/p0RRctATuZ+LgHYelLYpDRysOlI3TXsFbKiByT1FrNVJLhDHijhGk+aYgszxWxrhWEn6Ak7b/6iF4ZKOGoOuruERpO08nJQUuy8OSKNWx3PKsMx0WzeoUQD3JmNGZCK5EU5t89F18WthnbwV1EwfD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(376002)(136003)(396003)(39840400004)(36756003)(6506007)(2906002)(44832011)(41300700001)(52116002)(5660300002)(1076003)(66556008)(8676002)(8936002)(4326008)(66476007)(186003)(6486002)(478600001)(6666004)(6512007)(7416002)(83380400001)(26005)(316002)(86362001)(38100700002)(107886003)(2616005)(38350700002)(54906003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+dxyMUufvD4MI7robNnn7kHvSkw4SPkjTSGLpb3EAi9IkmJmaDFXZtoovwaH?=
 =?us-ascii?Q?FvGmH0wGqPWOynsd7agq2RYHQrjXmZeQSoUF/vL6bES1nIQ4w3vdYPGXL1hv?=
 =?us-ascii?Q?vh4r4/zuWAxzJZG6U/ofwKn4Rt67MDqOajSJ7xtKcXQHzRVpj627NEIPpSHX?=
 =?us-ascii?Q?cXMSEmQNn20v/tIoDnJGXizsJ6FqdJWfPcTzIaehQdr9xz0dd7ZvizLPouXx?=
 =?us-ascii?Q?4Po3nS3WRVWqnjpmfBgSn/4k+eL/36NbLf5gm8gOlDrcLmIHill0a1RwNNJ9?=
 =?us-ascii?Q?h1Vet3mvY7/zpe2adjj9zD4wHDZpRXsL6EHMxIUxsRNqmWz08bM+zyJ2sI2G?=
 =?us-ascii?Q?JnpvqDKL+z0sCGHvnn9nTG7gvBtXpFDB+QYOhhdYQL7CWxKXnh+yVsvtJnIL?=
 =?us-ascii?Q?BuvxLLlGMyKyWQIAjL/04CHFPqPyOi6+KmJLWrYtf+nOZXdWrQVuUwFlUwR6?=
 =?us-ascii?Q?tlyE+i0ndbBM1bqP6Rw15O8pYKnpnIxZR9iWatzDA17D78lekz7c7d7q63O0?=
 =?us-ascii?Q?P/LsFfxnuRwhBEwtrspHmnWUxxRtSS4z5L2dhXU6Y11lIGoCQAt1Hm+37bc/?=
 =?us-ascii?Q?MwmMb0kBYZNFEgvXwVnyZPtEkORO5FL61olgc53QHxRz4XqU+Rg5KqNaz3mg?=
 =?us-ascii?Q?alb/EUwSgdB3/B5OlqRzagJ8TT9k4WeBiY3NOgsdX0AUCvOG3KchdP2L9JEz?=
 =?us-ascii?Q?NxcpskfFe+YDVLgSYE2nrR8zHsDZHVMU/QZ7UFKhy/Hn2huZPmsQedkHcRob?=
 =?us-ascii?Q?Hzsxskk5XoMPT6PDjHrX7i2ySjm5FI6PLdL2uUAmDzIqvy6P6vupCEZvn1P+?=
 =?us-ascii?Q?zjEU3eNxCunedEy8SV3hrz/pjJKpzbCyCuR/GX7r+8viNeAHIh1/lG00ZaMn?=
 =?us-ascii?Q?Wyu6/XwrlZI50sH7lHYIcyfvUb5483/9/Sv2uIIMTVeL4ZkZKOnzIYb1BeFv?=
 =?us-ascii?Q?ymJxneN9oEzUSJbnn1kVL0x2D8SZLoMGqFNWacGqr/nBWT7u0O6vnthhJlsn?=
 =?us-ascii?Q?uqyHurjNlBrycqIm/ag84LgzUrDMEf3rGrJDFbngqfO3fXcifXoYpSmulwr7?=
 =?us-ascii?Q?g7HujIWFrD37NUKYjjSIfgpISiDkrAzpaPxkU9JyWWpQtfevS7YbItZTKMg3?=
 =?us-ascii?Q?rNKmoIDEt4Pldw4dw3JCqe2ni1F1CtgmNnUXu6/+1ZLSpiXhFLo9xz2h+Xki?=
 =?us-ascii?Q?L8K4LOdqw9Gqsi+NmF/8LR6p2woNFidC8UUoOErbSwFU7ZSN5tuUk0yj1XPi?=
 =?us-ascii?Q?JZRxstrJagcBabraBLa6X6XPpU4YVOPgU9ai2EaFK0L3BZp1leX039ww+ZFY?=
 =?us-ascii?Q?MIBsEBfzwyJB8+lEyS7da6ezmVpLHhXM6qq/e14q6YGc3abnH0mUNjBkPOGG?=
 =?us-ascii?Q?3jTzSdomn9De0fkH0xAhmiGvPHWd5OTBUsRCjX4RrB10tTAoMqHHcGTaOLA+?=
 =?us-ascii?Q?jfCuNK1MnG/lIb1uwDidO2LhLkX8ac5W8NbPYRyykGNObKMrINvyH5wzeAbd?=
 =?us-ascii?Q?yzmaKlhom6QXyU6BhMVEeRzLS1im7i6Sl1bI2b/HvYT1W69/6EuCYuLLjEiE?=
 =?us-ascii?Q?GQ8659gUr4bF9SMobeXBJzJMIDkLymbykRaBKwzDRuahSGeOtjaDKCeX01H1?=
 =?us-ascii?Q?kLyfumoLiOrZ1/M/+Xp1RsA=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0da7609-ab0e-4c5d-4932-08da6b978cf3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 04:06:27.7209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QNj0MpQ+GXM5RBlN+Oe0Dr5jVOtBoREsPHybL3qyy9DNenN3ioElfn5qC+Nq5abzK6lH5++6iCdsmolU78YL0jVgTCkH5boI96EWBJYcKnc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3919
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---

v14
    * Add Reviewed and Acked tags

---
 drivers/pinctrl/pinctrl-ocelot.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index d18047d2306d..80a3bba520cb 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -10,6 +10,7 @@
 #include <linux/gpio/driver.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/mfd/ocelot.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
@@ -1918,7 +1919,6 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 	struct ocelot_pinctrl *info;
 	struct reset_control *reset;
 	struct regmap *pincfg;
-	void __iomem *base;
 	int ret;
 	struct regmap_config regmap_config = {
 		.reg_bits = 32,
@@ -1938,20 +1938,14 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 				     "Failed to get reset\n");
 	reset_control_reset(reset);
 
-	base = devm_ioremap_resource(dev,
-			platform_get_resource(pdev, IORESOURCE_MEM, 0));
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
 	info->stride = 1 + (info->desc->npins - 1) / 32;
 
 	regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
 
-	info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
-	if (IS_ERR(info->map)) {
-		dev_err(dev, "Failed to create regmap\n");
-		return PTR_ERR(info->map);
-	}
+	info->map = ocelot_regmap_from_resource(pdev, 0, &regmap_config);
+	if (IS_ERR(info->map))
+		return dev_err_probe(dev, PTR_ERR(info->map),
+				     "Failed to create regmap\n");
 	dev_set_drvdata(dev, info->map);
 	info->dev = dev;
 
-- 
2.25.1

