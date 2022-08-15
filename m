Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67A2592729
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 02:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiHOA4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 20:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiHOA4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 20:56:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2104.outbound.protection.outlook.com [40.107.94.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1555FA46F;
        Sun, 14 Aug 2022 17:56:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3K9AdVt/5BUEv8LCH1k9vDNRE83u2rE8QXvAaS9NRnZf0QvKErcNBWNBdMU4bzBe/yV9h0T/DSwXKWh2z/I92b+jSbGdtnaXeECNXd7lT/Jr74FZb1eSkr60JXWKwTRCcEBDip7aB+cOIbkMAUspkxhOUtgKC4kYS1xAwjfn5mzMZHv3VRFD+LROrqx1w4aNHN47/xlHYmSY1ScBT43brrG/JwnwoIyovtbbZaLm4Dfc5Yz7+ynipZJVMN4scUy/BpcDKNfRICiXMOanbUq6LVak7yAEPcglfuY722f7AjJaLMcgPgw3MaysUhOQ9Z215IGkgUhvy41ZRLxkSEzpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gb+PD0ps/NW6gcSs2B7caK5rMMUizct8apoO41vF6h0=;
 b=jdm0Z9yjWCErqZ4E6uwcEySJu3Wn5XhFD2FR5EhyGtWf4SNUxWHraIl0TQq76Blj8Q/C2L5lBDtCrX3P0LF4KOHRiX/EhD0Kr3UJp35009ZO+b1Du5ovViUGbB1H7e6aYLy3m4DfMndh2lGnZjqbPDnZDjgzEkCYG4jscpsFMw0BAeDui8RBbkAq/N9wg7xOA/mNjG/DcH1oouENDo+HLGZjrMKI4iCnGKNRfc6OrQTQYOuhcAaXpWYiAvcf6vVsf5fkRRLMWu2oPeD5FKc+m68PzYbyeAC+QKZhKx1zkFHYkxkAyFyrlf1wkF93k9oEmJym3qBsmwHCZrnQs8Z+EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gb+PD0ps/NW6gcSs2B7caK5rMMUizct8apoO41vF6h0=;
 b=i5ICY5vKu4JDvQVJUMnBvOu7a68S0o5+jv8uKgGUBhKPKwxm5SKLzJSLxKF5L2IVPA4PLkjtb1ORDML//waA4XfCwy6a+XHDR+5HYtJqmpRnDLBIA/eJiNOdxH3q7dgT88GnToYZRVx8vkRvq0SEQs4gll7Q1rYUNZ2VRrPIseQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SN7PR10MB6286.namprd10.prod.outlook.com
 (2603:10b6:806:26e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Mon, 15 Aug
 2022 00:56:06 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Mon, 15 Aug 2022
 00:56:06 +0000
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
        Lee Jones <lee.jones@linaro.org>,
        katie.morris@in-advantage.com,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v16 mfd 1/8] mfd: ocelot: add helper to get regmap from a resource
Date:   Sun, 14 Aug 2022 17:55:46 -0700
Message-Id: <20220815005553.1450359-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220815005553.1450359-1-colin.foster@in-advantage.com>
References: <20220815005553.1450359-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0034.namprd08.prod.outlook.com
 (2603:10b6:a03:100::47) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71a607ad-ca60-439e-dbde-08da7e58ef56
X-MS-TrafficTypeDiagnostic: SN7PR10MB6286:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LQrdvag9mI0RL7EuZuwwYheRZRVe4DSsEquchs8AyCfwQv9sOxBGXLf9QB0dPT9TRlSrXsoBQWeMeQo+134eAajjtkVDYKeUGvB4bRE1gJvW2PLBG7rFfix9TXrfUK17UlgNjW3rpkJtOvLTV3eSNXmBb8Oo3cwuOAaGPp42adoACKGIn3DKwjheKNs/sNMnaAim/pASGJa9b/XOBE8PCDWSBa554mKVga/msz9yBEm0Os1qMjxIyr1Mp/W2bTmazkHMXzr1m7ViIRGN3/qKJiormmF3Y+Mdkx6AZzCjUzWz+1rTnQ/Z48xEMDLIPRc3HjH1NSssk7ADVgC3H3ekx3QZCeB3P7HCa7xMvikkQhd24+Mo4/LqnJlVtZ5mD58+PZEuaPdSbpqgIDvloFpAOm9zHAyL9v+GSis1R0gmmgYsrSa/cDa5hQZw+GkxVAPbAWO9NOMED2Ys9YM12qm7ujjBDA1ZYOQAD7XxzvQ78B448rdkRB+s4JxBR+XWOlv1/GPyR1KYPTBWEzLQzTDax0t4fgVmLWUZYo/e6AvFR+5z0oenrqLvBRQGKe6YLzD6AXfXyPd7CYJEAI4iP5mkg42oCjUHVtQgbqSc1JxClwylFk3RohkIxJcI1lzK7B2/KWIvpRT35bpNwQRZyOZO2w8Jk8whOgSu9XgDU9uFnBML43zX4NvPHp2P+IoewKpNOKx2jlGKETotRKwdvOpK8kXyZqeA5wWFTyni2rh8dgqwXeQy1+Da+bMx/O2b/R/PJNAVe/uRT77t9SNWluURmSJi6S0aNc2cZn+CUl1BB0u32dbjnQkMc2tLMJwM/aew
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39830400003)(366004)(136003)(396003)(346002)(376002)(38350700002)(5660300002)(7416002)(2906002)(44832011)(86362001)(38100700002)(52116002)(6666004)(41300700001)(6506007)(478600001)(2616005)(6486002)(186003)(316002)(1076003)(6512007)(26005)(83380400001)(8676002)(66556008)(66946007)(66476007)(4326008)(8936002)(54906003)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DHsFHiBQtHsLDsu0ftWeG3pzq9O1vPGTNC6jbHMBdXCEOrR+9bxldUhVGnI6?=
 =?us-ascii?Q?dH3Cuoj0yOK41jk2mVwvYk3yrzvvxCY29I5es9g/AHt5f5cBvU+mpCZUhL1n?=
 =?us-ascii?Q?q3Ql/k6GCPLPpo39GYzg/3aMYFtDkCI83jMIlHWLWpZyRJMwVrV06JFm+TOL?=
 =?us-ascii?Q?s8ws5j4Jxr8aIPm8+QsjeRHgQ8qrjEP9Aaw+51o/ryD7R5LkQupU7/QAGql2?=
 =?us-ascii?Q?0486biWkp7B/vcrIH+csUGAUBCErmt0p94M7GJ9KgvMXsHoriKuybM6JRsQg?=
 =?us-ascii?Q?dDuH8fnwCtalBdb8eUgWqTSjE31ciOUBvdXwzEdF8XSuB46uMHJhZL8TX71j?=
 =?us-ascii?Q?TO5Nfqa/k/EXWjxwL1L2drVp2lQ/X0MpbEZct2YSKVf+y9jOIPn59VKyjY4P?=
 =?us-ascii?Q?cDqbVDzTCQOqTqc2eGiWrnFGHNDVUUWrR8Ntl9AiSpyEBDwb4X4xWyEkwjkz?=
 =?us-ascii?Q?m2m4KLkQRpjyUq8pFnmf/d5BWYlzxssMgTVjwyzy9uJXJqNTlwqumQdZKu8c?=
 =?us-ascii?Q?1CFSNJ/PMiF1kmBMIKcq06UHzOZ9PmpS3loxmqpClhH2MRhiDiuIIvvngPl9?=
 =?us-ascii?Q?NSdGM2x5KiRz7Dt4vzj7B2REGoHKvZQN+pv0jSHFiy+t5HCGXCWHF6l/xyxe?=
 =?us-ascii?Q?mxi1aacoZ9FUnEI6i2t3jN+cgOc9EK4YCI8h17thPFeRcC+jq0qhzG3yQjKI?=
 =?us-ascii?Q?Mh0NztkyzEWJ363tsXapy9c88b2/cIzQAF1gtb8YHw74pgNyiVPAqaL6t8NS?=
 =?us-ascii?Q?Y1Awo9AHELeXVsre7uR3dXvidCUq+y8bxUrZGKYwS+A7EZAQnnFv7hiCCHZp?=
 =?us-ascii?Q?ftAUoQvXJAJL3FoGotTlkPaxRxXzkX5xzTg5hG3AcuyZk8UT7jbMwhY2SHGH?=
 =?us-ascii?Q?R4UpeOXM73ZZbhdtYh6LdubrkFrCKOiyQtMXmZ1dO9s1jCXDg9M7gTH0t39J?=
 =?us-ascii?Q?mJURhoC9r46JQrfCF39AXat+gPAn3+ivZCYxTzmtkTLU4Oott578nmJnPH/I?=
 =?us-ascii?Q?tnM0Q/fApQ/Calrsn1PTtBIPQa7TezBboZUjLv/U11R7tyf4F3dS7u38roEv?=
 =?us-ascii?Q?omhAncFpaLT16oQgF6fvgT7v0mdOdGF1pOr7zSsSsq8t+Vh5dWcbsNlRcQzw?=
 =?us-ascii?Q?g5nbu1UVS2y6OVvXu3WZuaYESaTk8O1rJG3ITmWxAeKxRJlfshsZvhR9RAn8?=
 =?us-ascii?Q?wxX1TMYCShaKP886B4JLBoFgc2EUZD1gvMQ/suOaKUlTf7F9KKlVQQ4qn4Yt?=
 =?us-ascii?Q?HjDmzVDbkttVMseIYkE309n8PoJUzSr8a/L5M5H4nqtevD5g/iDtIT9Y6ThN?=
 =?us-ascii?Q?gliBc8fqL9ci8SG3MrnvqjCP7RRNtkawgT1JcY3F8zI3dbOf/vA3t/6K9ABo?=
 =?us-ascii?Q?FBkVjsbuxT5tFppGTvPAxrZ7pRweR9vh3RgzAC6/jLMZpK9FRcuF7yCFU/Vj?=
 =?us-ascii?Q?Tx70pgjaEVraCeqJEkrnamhoM7YckdtqDJAaOThnxYLwcGrdBGudb7Qtgy6b?=
 =?us-ascii?Q?JNZr7dHFIWS16PJa1Y2SaF57qBgttrm79iaN4Mxx1AxOJf4xHUObBjicNiKK?=
 =?us-ascii?Q?GAbwi9B557abY3WLQ5se37TYtaM5YpgVmU9Yqu8NVvBWBQJNeZF+7NnC+i88?=
 =?us-ascii?Q?MnCAfmY2eEyPdW8p1WU1Efw=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a607ad-ca60-439e-dbde-08da7e58ef56
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 00:56:06.5733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l7rHDy6P1Twbxh05XnBNFrtWFRaW3WYPSwkfOH4f/H86a+wvqJcOmE8aArhPHlpAT15KC3VYPS+pvUZjoFUlsyXLpSLIARg3zrCc1DhAvdc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6286
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

