Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFFF9546E55
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 22:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350771AbiFJUYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 16:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347709AbiFJUYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 16:24:19 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2123.outbound.protection.outlook.com [40.107.96.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF35430A455;
        Fri, 10 Jun 2022 13:23:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EXqD7K0IzzA+WAEqYXfkS0xR/JMH35igw9YfhdpwHtC/ThehsTglq4DVpZlszL7fPbVAHdziBmE+RVcdO1u/6e+xekp4VZsRZydoEXludVgCCILYRF4TjmgjwT+Bpr1Esh9CxIGj3Ni5ofdhgxXnUCu1iVRNIXcRrc20Cr2oEPKMREQhVJO26QAHV1M6cPvv2ENswhvCPTDwpmvvrX2PxcIxM46Tpjtf4c/NqkRWktPv5wOysbIZvLceve04ug4GfRMUSygi5dvpf3iI+R4IdFSfrhzJjlDwhXXmGpQ9tEnygjVvcM9c30xPw7Wv4vwPVmlobbON78IbrMYe7w1BpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9x7kWRSNpD+mSE0GFZSzfzBcOugNaKgLSOz2TG7srtE=;
 b=Z0KTs0m4JrPM3f/HSJjVaRbl7WkdcwLOEOR3nXTyJrTivwQ+JQgMlEcMgMEvm9vV5WmMQyWeyiwn8E6eBURP678vkd8g0q7zkH/mTHoipFFc2vdBaCR6ohAYU6mQ/ptVhTzRZx/cAYMp0SMzlMA7/GGEJztP2g8YTy97YfJ1gYOJqCexwNpB2W9T8+PF0yzmRrCTcUpMR2PJJD/RTfZTuJ+6Y3pI+2xKKB89z6V4JSwi1fZiNgeW38/ahqXuo75s49iCnq6Rojn8CckpGTtexP8xpNp34+J1dqGnhpUe2N1c/fTlOAPsijs/GojNFaYo7+byr9iXfex9zeLCMSrGhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9x7kWRSNpD+mSE0GFZSzfzBcOugNaKgLSOz2TG7srtE=;
 b=EHRqFLdpUFRwT4INPqsryuIk5pE418HYV70RivHfz4/2BjImrq9jcrGhMyCAkxbs5PiBqW91U+0TXR0LDAyibc3CX4UaPKHBWeGoSavs0/M9JxJbDZfB16pWOx78C6eAoV4RMNwVz0IO2Tx670tWmoBSmfsMb73JvYcpX/3uPq4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1629.namprd10.prod.outlook.com
 (2603:10b6:301:9::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 20:23:46 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Fri, 10 Jun 2022
 20:23:46 +0000
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
Subject: [PATCH v10 net-next 1/7] mfd: ocelot: add helper to get regmap from a resource
Date:   Fri, 10 Jun 2022 13:23:24 -0700
Message-Id: <20220610202330.799510-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610202330.799510-1-colin.foster@in-advantage.com>
References: <20220610202330.799510-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0246.namprd04.prod.outlook.com
 (2603:10b6:303:88::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 409485c7-5b1b-40f5-d8c0-08da4b1f1e91
X-MS-TrafficTypeDiagnostic: MWHPR10MB1629:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1629A1B355FFAC820F0DB4EEA4A69@MWHPR10MB1629.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j5JVdAmMpAvQbvyCu6E/GEYkIVWwmYpn5W5ni/RJDOx3gEfgrmhN1shBk++4sbSWUmuSQ0sijqtkPYneZTFA+w/FqhLgZsa7mCr1UPe5CoRhPaW5z1sRYS6nYpGihq+Mi8mp9fn3CZJ/yGO6rMB7UpbXgeEfY9bh0HTH70mW63btWb/ZfoZeRrn2gKorjPHV7xh1dPdLLQbJnCJCPVVt4ye7PMuGoUD9cTiguJ0gA9Zfr63oZT9aozxMy3XMXgiyB2Qq1ytgSF14tN+LpAx8f8joQkGWNxbhDzwFjDud0Ww+QQLc1Mq+xu0f26R5g1hOpmop09KbDzg3V0k8oMbBVcfX3jducVTokm4PNnCm+5P5aYnyj6kLLINVH9ZXflmjhRj8WbXqxC9RKmUrSIhMMXFks5ijGbRKu1LI4RLmXmkFclQeO/H5DB3IWCrhJ3y/bG8v2VaTfL95dekPakxB68EO+00tH29aPfIwq+Clgwt76h2xQmiTJN11NoG4D9EInWQ5nMgoz8AYnf16Q978aGwf41hsjehoZv5y6EYfHo6Zm0ryC+K2oENy8CI2pTTN7FwFzl8wXmWANeZS8K3ILF0ARlIi5HMx++Pkr2AfMgxG1/FbJin0hSnSEkIWICsr+OBnirTkjbOQGDlf5Jc90x5BSOEsn8S7tYs5hXC/8eFixeaf5hdqawqUVm+YXsxfzOXf2VJg2wHEUs3iCxu49w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39830400003)(396003)(366004)(346002)(316002)(83380400001)(2616005)(2906002)(1076003)(6486002)(54906003)(8936002)(36756003)(6666004)(52116002)(6512007)(6506007)(26005)(186003)(41300700001)(86362001)(44832011)(66556008)(66476007)(38100700002)(38350700002)(5660300002)(4326008)(7416002)(8676002)(508600001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XzekJcFAMJdjonIO5mbRqOTFxvCoEh1uA0AUy7GDIVzNIpCIBXjzejjl28k4?=
 =?us-ascii?Q?PjDUZHJpipaPffGQlP3OsNzl0G5wPBP4+V581YcgmYroJN2myl2Z9rgqw4EY?=
 =?us-ascii?Q?RUuS02iwXFajxyNtPYlBowq0S9+eTRrkLjNtDsoFsYXABiQ114RAhv1BIMrl?=
 =?us-ascii?Q?15uhkkJS37EDVtXZ9u2QQtM/joW4Wcdd+hqWFhcVcugpa9k37525TphmsvJB?=
 =?us-ascii?Q?S0L4rH+hP5nKl0euBlGRBM9JJOQRfn17WhNFz9zYFDR5HZuUCoAA7eRTHj29?=
 =?us-ascii?Q?5PyP9D2a7fr6MiQucOvPyTVWZ0DP6/Qs6Lp7qLVntPQpqBff1Dm9W2mVK2cD?=
 =?us-ascii?Q?pygJ4/+dBb77In68pUWfEoLhAem79wt1OPS9dUe/Dm49WPzTfUZOhWXpAWwB?=
 =?us-ascii?Q?8fa0nGZXB3KZnJ6kuOdoaPHHmuyySN6OhBheFGNdobostaStW0JxyVcQcoMr?=
 =?us-ascii?Q?nmpCurGmbtu56Gm1WTegodB7SEIVXp9rOBIDu6UBtIhLy58FGxNnci8nK0zS?=
 =?us-ascii?Q?pXaGb9zcESb4tWQIL/BGy+AzTZIgXF3TYaSf/z/4Oli3vt6hvdow+Spiiz5P?=
 =?us-ascii?Q?elhu1OqM7wyc4QRTy+6OKh4IXvm5CIJO5euJlDcAaoCUHB+TgzSUNCQmexYE?=
 =?us-ascii?Q?mSIbK+Uj4/N695zgVOOXpUSmoycFsfEkPHcHVywwit1nc5dThXpMyW7T0chT?=
 =?us-ascii?Q?GUlP5cchdXk2vSO3mu3YbUbDIyit0+yRruCZfGWcOBcL4ZtzPt/G/J8bsRF1?=
 =?us-ascii?Q?flSdnKWIjhswYM3qr+6v/kVzMAOKV3afQ5uo0oVMIUynzTWWtUArjB1Oba9n?=
 =?us-ascii?Q?af2l8apODzX1VHyjvrZIi5G7kyvjsRwdqiZp7knORU3hITA6Fxijekt9a54G?=
 =?us-ascii?Q?0cTlmuZ/JTWC/09fWgoYmj12o9l4/bf3qDabc72Y49NdG5YdVcc/S39AEbPb?=
 =?us-ascii?Q?QnMeTJSicDfocEcyvtB0t0f5a30fiK79MnqnUysvufL4RH7uFv9nQ6iKcZHO?=
 =?us-ascii?Q?2v7zkFt87a5xzPsx/Pm0Fpnag0kw14jlTyz+Uh/2IWXEJ5bwYQFA7b8nmUTh?=
 =?us-ascii?Q?+n6RIawa+6t2LPifhZ0g2+BF7pIVqojBOUiEm2Bm97F7AfcAcFtpgigioQGo?=
 =?us-ascii?Q?cw0Thn2zPyS1R4j3/mBfjOwp8w0IWHI1vgJ9eCFg6/rnzQToWhfU6zMO2PpD?=
 =?us-ascii?Q?ygnxweg7UrhcHbwKHMaKxtK8RjtPQ8X5IDbog67xwJ2Fax3HLbR/LC4JnUlh?=
 =?us-ascii?Q?mMWSYPIKxIECaC2O03VqwMe/ampj7Nnvgo9li3INXTKKSDOlxcLCX3/Bu20e?=
 =?us-ascii?Q?lt3xLUppessszYImK7jmiXb3FXH28uOtEXgjJKVfuyOrKeNwVnrPtLIV8+Fb?=
 =?us-ascii?Q?Z49to5P1ZcDPfm5Rz+j6EMQhDCRueog3d7TgxAXqM9/4oCug5NUqjxwNMxD9?=
 =?us-ascii?Q?zmjvxuWz/us2qVuaDUGynVaddyKeCKi8DCbIYbUkkW/Uj2jlWx0zlt7Re9PD?=
 =?us-ascii?Q?flz+AFj8bxLwH3ox1zu41Hm16TAX6lep02JS7CP+3ncUAD/ubE0sETm3BAar?=
 =?us-ascii?Q?ypImmY1HfNVj/jX8wyx801RxebtlMBHPV9i2xOBNC3Q/fE/YF8UCB6wPl/UG?=
 =?us-ascii?Q?IARl9D8F+1TUacBlgGhIsb9+vQS8Rg6fwDvRFZPz6Vsd/AHVcgthNXITkNNl?=
 =?us-ascii?Q?0snzWc8jBtGjNwRcveSYuN3RtX0B5BuY8oWzAaRpWApi1myFmAsgzA//v54f?=
 =?us-ascii?Q?BVZ6/7+avsfxv3jnITlCqSkCwR3iTs2tcwUwZYo6bcGguXnBYf/Q?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 409485c7-5b1b-40f5-d8c0-08da4b1f1e91
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 20:23:45.8259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JZAfrfHAfR9freUzlaa651DctPLaYAOlFb/Bo8Vh1v2h5xs7V22eKJfLWrGns2r4hthJQFOrAomqKDtNJN2peLJkKq1i3YXqAd6oFt/3cjk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1629
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

