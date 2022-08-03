Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73240588703
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 07:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237116AbiHCFuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 01:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236888AbiHCFta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 01:49:30 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2121.outbound.protection.outlook.com [40.107.244.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E61F57251;
        Tue,  2 Aug 2022 22:48:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mp2fyOOZrk3PNwa+JaLYjRgpgms5aSfv8khq/sJczhmTcbsjRrOfUYWmi144i6WNbRfzsYTql1aqMllVjTWgzdm1AI0+FpMYV1BauKlCiJG6EgA3Psqfw9PFgu/1/iSveU1DYNrW30MDUFe8n0FdGx3ufq8fJWi7FyjvJAQr2o8arNhXBjoaCrUKFZzQByS+/20o2/a+Fh8cukwjcWCWGDXQE8Qjjj6isitRMRWwy4rEHxrkcl/iVFjgTu0zSwYSJU0WnMWDSgP0chkLqHBHl0679emYiHDGokN/5O8IoO6yR+rpBnHdPsmUnk0rgE3WDgtJ8RQETxhm6VueqVvbnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N9ApTt8+C/9FCDPCYB/3MlTRONAvgEq0ampuqyXSH0s=;
 b=OXRM2NepmwjvJcb+QEjiWGttPTDOO+kPkwKXYrENWCY+EcV6Fr7EMXTzHsGIn9j7CDh7YQa3IPlL3krhfgFgZ0ODdXOWbr4AyVMWzILDZ6qHYrB+CErCzdrWlUyHJZSYvl3p4TnlGLZx8xX5Fbac6l+fhvWwv1JTxQ12yyBsqB0P9+clI9chSV9/ElRD0LysUxs7xE5sZQVPktxsOBrHVfGAIkdHuwLLtU6JbWMzGq/UgVGrpM0kFRI0xph4BZVw1rF518jikvb2g2zZeCKbvcfvJvZ/P6rjhfelQdkH+aESqrVjTJMJ82kdn9nWFD4kPG9xGvexJELV9rqhNXFfxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9ApTt8+C/9FCDPCYB/3MlTRONAvgEq0ampuqyXSH0s=;
 b=gi8AJtG4736MZmGqDWVZb/EebvV15Jcd4CV6tcHS5kxfpuEdQk7SXFcrFHSffyUjFs6ABSHufpNufYx/0v87EOO5GsShsXkzWSdkmKuDbWZxcsQJAKD//gB4bGoL2SR19LEPrEfXH3GCY4/yTpubKs0C0u66S6MB2bpFzlTvVfA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB6438.namprd10.prod.outlook.com
 (2603:10b6:303:218::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 05:47:57 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5482.014; Wed, 3 Aug 2022
 05:47:57 +0000
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
Subject: [PATCH v15 mfd 9/9] mfd: ocelot: add support for the vsc7512 chip via spi
Date:   Tue,  2 Aug 2022 22:47:28 -0700
Message-Id: <20220803054728.1541104-10-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803054728.1541104-1-colin.foster@in-advantage.com>
References: <20220803054728.1541104-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0026.prod.exchangelabs.com (2603:10b6:a02:80::39)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1213a96-6857-4652-0b5d-08da7513b7b2
X-MS-TrafficTypeDiagnostic: MW4PR10MB6438:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bvaQHCiqWZ2iEg9N8J14ULMwIswGA2MsW5/GSm6r/PZe1HDZWyeP2eQkfL/0/Vz60t98B30FKFk66ADq06US3oNMIU9SaT1d2JHrJxdeDV93vKczwLfjB0BybFaiTANetE7UoVVCmBYVYS/m+3CjjuSG8BszHVjmjXwG6/cHI3Ag3Fqe0hTFYKvMNsuzXM1Y4c0q0VWNW0EzNDEHyadcnI9Ztnwli3opEFGRXf9IA/ywOyOhefehTqWlBX20S/oQNX4bBYIi8JSDgzCaC1K6FxfFRlSxY1zAGJ02u1emV3JjaMR1betI/kdISrJiT3h+FUdMJP4PkZK+uyJ9Wh3QiMy/eeB/pluwIXIqa/erH46Q6vMgcV+/CaC4kjePVmQhIYlHFyu/zpQbCrVMZ9eSZly7kmCCegFmaNgZ1s3qxRE6Vy5+fGTeJ8nhU2CfrLUHlsYiovF4t6JdkzDv02dkmWnEGLuP1/P+ev3HTJ4hPtzzGuQBmBCeN+pELXOETFjqi2o5HMKrXPVlXQmFeqFLgq+fdNKOLwWPIJAimX0SayRknxy828UMeTMHMXH1P5Lt//5XnfYI/qpBHGx5RingvP2PRbqNbQyDuFDvdEQtJWdRyu0zd0/B6eKJrzlFjYfyyJG44g9D6gAaE5L4KVgSLyznrV752/Cl3lBo5QHPVSL0wM/zU6u7e2G29SQUp8JHCWaRUjNNtkMMLbjZm7ulVgULU0woh3P3nVirtC1m7L8LCbKKW4A7YmOgWj7UhvnsVUEJR+NSydha+1b6tbS32+wg09FnWKHnXQQJKEsKlK8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(346002)(136003)(39830400003)(396003)(186003)(41300700001)(6666004)(2906002)(6512007)(26005)(52116002)(1076003)(6506007)(107886003)(2616005)(38350700002)(38100700002)(86362001)(83380400001)(5660300002)(36756003)(7416002)(6486002)(478600001)(8676002)(4326008)(66476007)(66556008)(66946007)(8936002)(44832011)(316002)(30864003)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SG3e9u89yVYoNmYTfvNBv+aTjm1xI5FQaFT0LNc51nnPr++hqUpNpoX5Zt+m?=
 =?us-ascii?Q?4JeCmMgUrGtqLdJwnroeKf7GZTgvmYjeFBIiXWHlsnEJyvxbZ3kRge626d8p?=
 =?us-ascii?Q?L22ZS98RU4TSQer9lx0+6Ur+Qe0wSSloPf1dVRy3HIV0t8CPNS5VfzSPX5PL?=
 =?us-ascii?Q?12ZmiKkFEAy/zxqMO15nbibhpZPf0iU4oPVX3nVK0GFntViiw49vhEj9AMKP?=
 =?us-ascii?Q?t+Y925Sbimd6MT8uLMO0TGB4zNZnInIr+iPqYds73HXsv5ojvIZV21LDewUW?=
 =?us-ascii?Q?pw7H+laFY1bae/4Exn0R1dfsEiwTMPRty3QinUGtPPnMuq7Qg/3dH4rkmQDY?=
 =?us-ascii?Q?p5yKl1z+6NlF1DJJU7um8dNJxrMeeOmliNjQoPFN4bUlqQjhYqUO9Io3uRFv?=
 =?us-ascii?Q?0GoRSnKdflH9JLjQxmJHf/t1PmmXrfaxWGwKvhX3h5bStlQ1H3rhRTYosFdN?=
 =?us-ascii?Q?CuBwBlIwMyKlyUy7AdljHyvJKl8BfZ0PTDXvlnmKDcGCKupje3hpSFmTWQiK?=
 =?us-ascii?Q?X4e9B0+eDVN/QtU66PLWr2Hhelg9QzqN8jx1fVDa1wlufNOI/h3CIIlHSU+q?=
 =?us-ascii?Q?1sCT2X1vLliqRYE3PRiKWdacUeLLrYxksuOVbGgCVTP6uOA624g1E/f4VD3p?=
 =?us-ascii?Q?rDzpcAdhP7/CvzXFKwII1C0JxeDfacLrEqQa6GDLD5pyxbXO9SyPIGAiGPCC?=
 =?us-ascii?Q?9Uxx0K2s1ORu4/NjWn92kAtMlBLBGhmU+ztTvR+7qoXJv8BQpbEomRiJ0S2x?=
 =?us-ascii?Q?n+WbM/tS5UrdxtxWKasMiz4R9u/VC95f0TKGwj9cfcwqO3S5oK/e6CXCpz+U?=
 =?us-ascii?Q?AXR0EM3QwNfQLO9p0UQaNkCL50+9ss4Sn2o9a2XNN9P92t4Orspe7xqubdTM?=
 =?us-ascii?Q?RtGwFIWKIa2rkCxx0hATzLWS0moKG0PrpOZ1yeuJ1ndqZhT36A61DmSPWcdK?=
 =?us-ascii?Q?Y7vDwCHFeLakOKAimYB2pLi3IQtA1Lkux7yl6cdIeuQklXMB3mScgKQeBlRj?=
 =?us-ascii?Q?zoYzIvjUMHxu5sr1uYPhhmsG/EW6NKzhhzZdqFB2XSekQG3iKbtUrLJzZeeW?=
 =?us-ascii?Q?b9kGSSzaUy4qlxdk6sWexjYMycS2UVW7g1l/M6x+A4nFowP9J7FT5NWfgnrZ?=
 =?us-ascii?Q?JE0XJ7XTzdLbO6ID5+CNFghMrXtFceie3h1nDGPIGkJSpmNSUCaSuwJDGe+Y?=
 =?us-ascii?Q?v8U40TBkxDh/ym9GRJSM2pJB/36GavfueusubNjmbHsMM6ZLYK46Kp6utaOY?=
 =?us-ascii?Q?Pw7JDa2pRObBJrAVpZdK36dL+eVizzitv1wmmrGw0FetWJrR5kSW2eLlRl0A?=
 =?us-ascii?Q?y5Xqy6e8ajbUPy0s5be+vkNJQ6+sxwakhET5CpHQyWokXlPdzR987vPMCLBM?=
 =?us-ascii?Q?tDlZqYe/LsY0YAfu8EE83QX9u/OY5FhpmXPa5t4t6lLzHYD/mvFTfQ7xQ+9g?=
 =?us-ascii?Q?YIgkJ/OZ5B1s6xElGKqOLIjTNvPpkJ5OnKS1fxnYcuJ2Xl3e7XkKHr9zNUHb?=
 =?us-ascii?Q?WuWHFT9i/+AAtkt8/p691DMIzrW6j7R4jxVvB7HYsSvsppF2QXj7KqJCvi0R?=
 =?us-ascii?Q?h1Uu1iTVwISnPnMc5sBp7s1lDRlXrvN7pC5AZt52xS/lxWSzKwQN0Tj6UOh7?=
 =?us-ascii?Q?TEBUEIRsyUQZcO2Pgcj5tDo=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1213a96-6857-4652-0b5d-08da7513b7b2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 05:47:57.5261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sg09OGw1hZChVQEoPD5XNnYFWFnFekQoWJQ8t1VkGPOqsR6Bfr+dN+6FlMTq+pynv7k1gnNz8cDtFcXgL/Q39aWEGHGqPYxP2yw/DBFvS2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6438
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VSC7512 is a networking chip that contains several peripherals. Many of
these peripherals are currently supported by the VSC7513 and VSC7514 chips,
but those run on an internal CPU. The VSC7512 lacks this CPU, and must be
controlled externally.

Utilize the existing drivers by referencing the chip as an MFD. Add support
for the two MDIO buses, the internal phys, pinctrl, and serial GPIO.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v15
    * Add missed include bits.h
    * Clean _SIZE macros to make them all the same width (e.g. 0x004)
    * Remove unnecessary ret = ...; return ret; calls
    * Utilize spi_message_init_with_transfers() instead of
      spi_message_add_tail() calls in the bus_read routine
    * Utilize HZ_PER_MHZ from units.h instead of a magic number
    * Remove unnecessary err < 0 checks
    * Fix typos in comments

v14
    * Add Reviewed tag
    * Copyright ranges are now "2021-2022"
    * 100-char width applied instead of 80
    * Remove invalid dev_err_probe return
    * Remove "spi" and "dev" elements from ocelot_ddata struct.
    Since "dev" is available throughout, determine "ddata" and "spi" from
    there instead of keeping separate references.
    * Add header guard in drivers/mfd/ocelot.h
    * Document ocelot_ddata struct

---
 MAINTAINERS               |   1 +
 drivers/mfd/Kconfig       |  21 +++
 drivers/mfd/Makefile      |   3 +
 drivers/mfd/ocelot-core.c | 157 ++++++++++++++++++++
 drivers/mfd/ocelot-spi.c  | 296 ++++++++++++++++++++++++++++++++++++++
 drivers/mfd/ocelot.h      |  49 +++++++
 6 files changed, 527 insertions(+)
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 5e798c42fa08..e3299677cd4a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14471,6 +14471,7 @@ OCELOT EXTERNAL SWITCH CONTROL
 M:	Colin Foster <colin.foster@in-advantage.com>
 S:	Supported
 F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
+F:	drivers/mfd/ocelot*
 F:	include/linux/mfd/ocelot.h
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3b59456f5545..0ef433d170dc 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -962,6 +962,27 @@ config MFD_MENF21BMC
 	  This driver can also be built as a module. If so the module
 	  will be called menf21bmc.
 
+config MFD_OCELOT
+	tristate "Microsemi Ocelot External Control Support"
+	depends on SPI_MASTER
+	select MFD_CORE
+	select REGMAP_SPI
+	help
+	  Ocelot is a family of networking chips that support multiple ethernet
+	  and fibre interfaces. In addition to networking, they contain several
+	  other functions, including pinctrl, MDIO, and communication with
+	  external chips. While some chips have an internal processor capable of
+	  running an OS, others don't. All chips can be controlled externally
+	  through different interfaces, including SPI, I2C, and PCIe.
+
+	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
+	  VSC7513, VSC7514) controlled externally.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called ocelot-soc.
+
+	  If unsure, say N.
+
 config EZX_PCAP
 	bool "Motorola EZXPCAP Support"
 	depends on SPI_MASTER
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 858cacf659d6..0004b7e86220 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -120,6 +120,9 @@ obj-$(CONFIG_MFD_MC13XXX_I2C)	+= mc13xxx-i2c.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
+ocelot-soc-objs			:= ocelot-core.o ocelot-spi.o
+obj-$(CONFIG_MFD_OCELOT)	+= ocelot-soc.o
+
 obj-$(CONFIG_EZX_PCAP)		+= ezx-pcap.o
 obj-$(CONFIG_MFD_CPCAP)		+= motorola-cpcap.o
 
diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
new file mode 100644
index 000000000000..fd97d878d6e8
--- /dev/null
+++ b/drivers/mfd/ocelot-core.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Core driver for the Ocelot chip family.
+ *
+ * The VSC7511, 7512, 7513, and 7514 can be controlled internally via an
+ * on-chip MIPS processor, or externally via SPI, I2C, PCIe. This core driver is
+ * intended to be the bus-agnostic glue between, for example, the SPI bus and
+ * the child devices.
+ *
+ * Copyright 2021-2022 Innovative Advantage Inc.
+ *
+ * Author: Colin Foster <colin.foster@in-advantage.com>
+ */
+
+#include <linux/bits.h>
+#include <linux/kernel.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/ocelot.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/types.h>
+
+#include <soc/mscc/ocelot.h>
+
+#include "ocelot.h"
+
+#define REG_GCB_SOFT_RST		0x0008
+
+#define BIT_SOFT_CHIP_RST		BIT(0)
+
+#define VSC7512_MIIM0_RES_START		0x7107009c
+#define VSC7512_MIIM1_RES_START		0x710700c0
+#define VSC7512_MIIM_RES_SIZE		0x024
+
+#define VSC7512_PHY_RES_START		0x710700f0
+#define VSC7512_PHY_RES_SIZE		0x004
+
+#define VSC7512_GPIO_RES_START		0x71070034
+#define VSC7512_GPIO_RES_SIZE		0x06c
+
+#define VSC7512_SIO_CTRL_RES_START	0x710700f8
+#define VSC7512_SIO_CTRL_RES_SIZE	0x100
+
+#define VSC7512_GCB_RST_SLEEP_US	100
+#define VSC7512_GCB_RST_TIMEOUT_US	100000
+
+static int ocelot_gcb_chip_rst_status(struct ocelot_ddata *ddata)
+{
+	int val, err;
+
+	err = regmap_read(ddata->gcb_regmap, REG_GCB_SOFT_RST, &val);
+	if (err)
+		return err;
+
+	return val;
+}
+
+int ocelot_chip_reset(struct device *dev)
+{
+	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
+	int ret, val;
+
+	/*
+	 * Reset the entire chip here to put it into a completely known state.
+	 * Other drivers may want to reset their own subsystems. The register
+	 * self-clears, so one write is all that is needed and wait for it to
+	 * clear.
+	 */
+	ret = regmap_write(ddata->gcb_regmap, REG_GCB_SOFT_RST, BIT_SOFT_CHIP_RST);
+	if (ret)
+		return ret;
+
+	return readx_poll_timeout(ocelot_gcb_chip_rst_status, ddata, val, !val,
+				  VSC7512_GCB_RST_SLEEP_US, VSC7512_GCB_RST_TIMEOUT_US);
+}
+EXPORT_SYMBOL_NS(ocelot_chip_reset, MFD_OCELOT);
+
+static const struct resource vsc7512_miim0_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_MIIM0_RES_START, VSC7512_MIIM_RES_SIZE, "gcb_miim0"),
+	DEFINE_RES_REG_NAMED(VSC7512_PHY_RES_START, VSC7512_PHY_RES_SIZE, "gcb_phy"),
+};
+
+static const struct resource vsc7512_miim1_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_MIIM1_RES_START, VSC7512_MIIM_RES_SIZE, "gcb_miim1"),
+};
+
+static const struct resource vsc7512_pinctrl_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_GPIO_RES_START, VSC7512_GPIO_RES_SIZE, "gcb_gpio"),
+};
+
+static const struct resource vsc7512_sgpio_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_SIO_CTRL_RES_START, VSC7512_SIO_CTRL_RES_SIZE, "gcb_sio"),
+};
+
+static const struct mfd_cell vsc7512_devs[] = {
+	{
+		.name = "ocelot-pinctrl",
+		.of_compatible = "mscc,ocelot-pinctrl",
+		.num_resources = ARRAY_SIZE(vsc7512_pinctrl_resources),
+		.resources = vsc7512_pinctrl_resources,
+	}, {
+		.name = "ocelot-sgpio",
+		.of_compatible = "mscc,ocelot-sgpio",
+		.num_resources = ARRAY_SIZE(vsc7512_sgpio_resources),
+		.resources = vsc7512_sgpio_resources,
+	}, {
+		.name = "ocelot-miim0",
+		.of_compatible = "mscc,ocelot-miim",
+		.of_reg = VSC7512_MIIM0_RES_START,
+		.use_of_reg = true,
+		.num_resources = ARRAY_SIZE(vsc7512_miim0_resources),
+		.resources = vsc7512_miim0_resources,
+	}, {
+		.name = "ocelot-miim1",
+		.of_compatible = "mscc,ocelot-miim",
+		.of_reg = VSC7512_MIIM1_RES_START,
+		.use_of_reg = true,
+		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
+		.resources = vsc7512_miim1_resources,
+	},
+};
+
+static void ocelot_core_try_add_regmap(struct device *dev,
+				       const struct resource *res)
+{
+	if (dev_get_regmap(dev, res->name))
+		return;
+
+	ocelot_spi_init_regmap(dev, res);
+}
+
+static void ocelot_core_try_add_regmaps(struct device *dev,
+					const struct mfd_cell *cell)
+{
+	int i;
+
+	for (i = 0; i < cell->num_resources; i++)
+		ocelot_core_try_add_regmap(dev, &cell->resources[i]);
+}
+
+int ocelot_core_init(struct device *dev)
+{
+	int i, ndevs;
+
+	ndevs = ARRAY_SIZE(vsc7512_devs);
+
+	for (i = 0; i < ndevs; i++)
+		ocelot_core_try_add_regmaps(dev, &vsc7512_devs[i]);
+
+	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs, ndevs, NULL, 0, NULL);
+}
+EXPORT_SYMBOL_NS(ocelot_core_init, MFD_OCELOT);
+
+MODULE_DESCRIPTION("Externally Controlled Ocelot Chip Driver");
+MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(MFD_OCELOT_SPI);
diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
new file mode 100644
index 000000000000..5836788b7152
--- /dev/null
+++ b/drivers/mfd/ocelot-spi.c
@@ -0,0 +1,296 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * SPI core driver for the Ocelot chip family.
+ *
+ * This driver will handle everything necessary to allow for communication over
+ * SPI to the VSC7511, VSC7512, VSC7513 and VSC7514 chips. The main functions
+ * are to prepare the chip's SPI interface for a specific bus speed, and a host
+ * processor's endianness. This will create and distribute regmaps for any
+ * children.
+ *
+ * Copyright 2021-2022 Innovative Advantage Inc.
+ *
+ * Author: Colin Foster <colin.foster@in-advantage.com>
+ */
+
+#include <linux/ioport.h>
+#include <linux/kconfig.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/spi/spi.h>
+#include <linux/units.h>
+
+#include <asm/byteorder.h>
+
+#include "ocelot.h"
+
+#define REG_DEV_CPUORG_IF_CTRL		0x0000
+#define REG_DEV_CPUORG_IF_CFGSTAT	0x0004
+
+#define CFGSTAT_IF_NUM_VCORE		(0 << 24)
+#define CFGSTAT_IF_NUM_VRAP		(1 << 24)
+#define CFGSTAT_IF_NUM_SI		(2 << 24)
+#define CFGSTAT_IF_NUM_MIIM		(3 << 24)
+
+#define VSC7512_DEVCPU_ORG_RES_START	0x71000000
+#define VSC7512_DEVCPU_ORG_RES_SIZE	0x38
+
+#define VSC7512_CHIP_REGS_RES_START	0x71070000
+#define VSC7512_CHIP_REGS_RES_SIZE	0x14
+
+static const struct resource vsc7512_dev_cpuorg_resource =
+	DEFINE_RES_REG_NAMED(VSC7512_DEVCPU_ORG_RES_START,
+			     VSC7512_DEVCPU_ORG_RES_SIZE,
+			     "devcpu_org");
+
+static const struct resource vsc7512_gcb_resource =
+	DEFINE_RES_REG_NAMED(VSC7512_CHIP_REGS_RES_START,
+			     VSC7512_CHIP_REGS_RES_SIZE,
+			     "devcpu_gcb_chip_regs");
+
+static int ocelot_spi_initialize(struct device *dev)
+{
+	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
+	u32 val, check;
+	int err;
+
+	val = OCELOT_SPI_BYTE_ORDER;
+
+	/*
+	 * The SPI address must be big-endian, but we want the payload to match
+	 * our CPU. These are two bits (0 and 1) but they're repeated such that
+	 * the write from any configuration will be valid. The four
+	 * configurations are:
+	 *
+	 * 0b00: little-endian, MSB first
+	 * |            111111   | 22221111 | 33222222 |
+	 * | 76543210 | 54321098 | 32109876 | 10987654 |
+	 *
+	 * 0b01: big-endian, MSB first
+	 * | 33222222 | 22221111 | 111111   |          |
+	 * | 10987654 | 32109876 | 54321098 | 76543210 |
+	 *
+	 * 0b10: little-endian, LSB first
+	 * |              111111 | 11112222 | 22222233 |
+	 * | 01234567 | 89012345 | 67890123 | 45678901 |
+	 *
+	 * 0b11: big-endian, LSB first
+	 * | 22222233 | 11112222 |   111111 |          |
+	 * | 45678901 | 67890123 | 89012345 | 01234567 |
+	 */
+	err = regmap_write(ddata->cpuorg_regmap, REG_DEV_CPUORG_IF_CTRL, val);
+	if (err)
+		return err;
+
+	/*
+	 * Apply the number of padding bytes between a read request and the data
+	 * payload. Some registers have access times of up to 1us, so if the
+	 * first payload bit is shifted out too quickly, the read will fail.
+	 */
+	val = ddata->spi_padding_bytes;
+	err = regmap_write(ddata->cpuorg_regmap, REG_DEV_CPUORG_IF_CFGSTAT, val);
+	if (err)
+		return err;
+
+	/*
+	 * After we write the interface configuration, read it back here. This
+	 * will verify several different things. The first is that the number of
+	 * padding bytes actually got written correctly. These are found in bits
+	 * 0:3.
+	 *
+	 * The second is that bit 16 is cleared. Bit 16 is IF_CFGSTAT:IF_STAT,
+	 * and will be set if the register access is too fast. This would be in
+	 * the condition that the number of padding bytes is insufficient for
+	 * the SPI bus frequency.
+	 *
+	 * The last check is for bits 31:24, which define the interface by which
+	 * the registers are being accessed. Since we're accessing them via the
+	 * serial interface, it must return IF_NUM_SI.
+	 */
+	check = val | CFGSTAT_IF_NUM_SI;
+
+	err = regmap_read(ddata->cpuorg_regmap, REG_DEV_CPUORG_IF_CFGSTAT, &val);
+	if (err)
+		return err;
+
+	if (check != val)
+		return -ENODEV;
+
+	return 0;
+}
+
+static const struct regmap_config ocelot_spi_regmap_config = {
+	.reg_bits = 24,
+	.reg_stride = 4,
+	.reg_downshift = 2,
+	.val_bits = 32,
+
+	.write_flag_mask = 0x80,
+
+	.use_single_write = true,
+	.can_multi_write = false,
+
+	.reg_format_endian = REGMAP_ENDIAN_BIG,
+	.val_format_endian = REGMAP_ENDIAN_NATIVE,
+};
+
+static int ocelot_spi_regmap_bus_read(void *context, const void *reg, size_t reg_size,
+				      void *val, size_t val_size)
+{
+	struct spi_transfer xfers[3] = {0};
+	struct device *dev = context;
+	struct ocelot_ddata *ddata;
+	struct spi_device *spi;
+	struct spi_message msg;
+	unsigned int index = 0;
+
+	ddata = dev_get_drvdata(dev);
+	spi = to_spi_device(dev);
+
+	xfers[index].tx_buf = reg;
+	xfers[index].len = reg_size;
+	index++;
+
+	if (ddata->spi_padding_bytes) {
+		xfers[index].len = ddata->spi_padding_bytes;
+		xfers[index].tx_buf = ddata->dummy_buf;
+		xfers[index].dummy_data = 1;
+		index++;
+	}
+
+	xfers[index].rx_buf = val;
+	xfers[index].len = val_size;
+	index++;
+
+	spi_message_init_with_transfers(&msg, xfers, index);
+
+	return spi_sync(spi, &msg);
+}
+
+static int ocelot_spi_regmap_bus_write(void *context, const void *data, size_t count)
+{
+	struct device *dev = context;
+	struct spi_device *spi = to_spi_device(dev);
+
+	return spi_write(spi, data, count);
+}
+
+static const struct regmap_bus ocelot_spi_regmap_bus = {
+	.write = ocelot_spi_regmap_bus_write,
+	.read = ocelot_spi_regmap_bus_read,
+};
+
+struct regmap *ocelot_spi_init_regmap(struct device *dev, const struct resource *res)
+{
+	struct regmap_config regmap_config;
+
+	memcpy(&regmap_config, &ocelot_spi_regmap_config, sizeof(regmap_config));
+
+	regmap_config.name = res->name;
+	regmap_config.max_register = res->end - res->start;
+	regmap_config.reg_base = res->start;
+
+	return devm_regmap_init(dev, &ocelot_spi_regmap_bus, dev, &regmap_config);
+}
+EXPORT_SYMBOL_NS(ocelot_spi_init_regmap, MFD_OCELOT_SPI);
+
+static int ocelot_spi_probe(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct ocelot_ddata *ddata;
+	struct regmap *r;
+	int err;
+
+	ddata = devm_kzalloc(dev, sizeof(*ddata), GFP_KERNEL);
+	if (!ddata)
+		return -ENOMEM;
+
+	spi_set_drvdata(spi, ddata);
+
+	if (spi->max_speed_hz <= 500000) {
+		ddata->spi_padding_bytes = 0;
+	} else {
+		/*
+		 * Calculation taken from the manual for IF_CFGSTAT:IF_CFG.
+		 * Register access time is 1us, so we need to configure and send
+		 * out enough padding bytes between the read request and data
+		 * transmission that lasts at least 1 microsecond.
+		 */
+		ddata->spi_padding_bytes = 1 + (spi->max_speed_hz / HZ_PER_MHZ + 2) / 8;
+
+		ddata->dummy_buf = devm_kzalloc(dev, ddata->spi_padding_bytes, GFP_KERNEL);
+		if (!ddata->dummy_buf)
+			return -ENOMEM;
+	}
+
+	spi->bits_per_word = 8;
+
+	err = spi_setup(spi);
+	if (err)
+		return dev_err_probe(&spi->dev, err, "Error performing SPI setup\n");
+
+	r = ocelot_spi_init_regmap(dev, &vsc7512_dev_cpuorg_resource);
+	if (IS_ERR(r))
+		return PTR_ERR(r);
+
+	ddata->cpuorg_regmap = r;
+
+	r = ocelot_spi_init_regmap(dev, &vsc7512_gcb_resource);
+	if (IS_ERR(r))
+		return PTR_ERR(r);
+
+	ddata->gcb_regmap = r;
+
+	/*
+	 * The chip must be set up for SPI before it gets initialized and reset.
+	 * This must be done before calling init, and after a chip reset is
+	 * performed.
+	 */
+	err = ocelot_spi_initialize(dev);
+	if (err)
+		return dev_err_probe(dev, err, "Error initializing SPI bus\n");
+
+	err = ocelot_chip_reset(dev);
+	if (err)
+		return dev_err_probe(dev, err, "Error resetting device\n");
+
+	/*
+	 * A chip reset will clear the SPI configuration, so it needs to be done
+	 * again before we can access any registers.
+	 */
+	err = ocelot_spi_initialize(dev);
+	if (err)
+		return dev_err_probe(dev, err, "Error initializing SPI bus after reset\n");
+
+	err = ocelot_core_init(dev);
+	if (err)
+		return dev_err_probe(dev, err, "Error initializing Ocelot core\n");
+
+	return 0;
+}
+
+static const struct spi_device_id ocelot_spi_ids[] = {
+	{ "vsc7512", 0 },
+	{ }
+};
+
+static const struct of_device_id ocelot_spi_of_match[] = {
+	{ .compatible = "mscc,vsc7512" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ocelot_spi_of_match);
+
+static struct spi_driver ocelot_spi_driver = {
+	.driver = {
+		.name = "ocelot-soc",
+		.of_match_table = ocelot_spi_of_match,
+	},
+	.id_table = ocelot_spi_ids,
+	.probe = ocelot_spi_probe,
+};
+module_spi_driver(ocelot_spi_driver);
+
+MODULE_DESCRIPTION("SPI Controlled Ocelot Chip Driver");
+MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
+MODULE_LICENSE("Dual MIT/GPL");
+MODULE_IMPORT_NS(MFD_OCELOT);
diff --git a/drivers/mfd/ocelot.h b/drivers/mfd/ocelot.h
new file mode 100644
index 000000000000..1c0e941f9baa
--- /dev/null
+++ b/drivers/mfd/ocelot.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/* Copyright 2021, 2022 Innovative Advantage Inc. */
+
+#ifndef _MFD_OCELOT_H
+#define _MFD_OCELOT_H
+
+#include <asm/byteorder.h>
+
+struct device;
+struct regmap;
+struct resource;
+
+/**
+ * struct ocelot_ddata - Private data for an external Ocelot chip
+ * @gcb_regmap:		General Configuration Block regmap. Used for
+ *			operations like chip reset.
+ * @cpuorg_regmap:	CPU Device Origin Block regmap. Used for operations
+ *			like SPI bus configuration.
+ * @spi_padding_bytes:	Number of padding bytes that must be thrown out before
+ *			read data gets returned. This is calculated during
+ *			initialization based on bus speed.
+ * @dummy_buf:		Zero-filled buffer of spi_padding_bytes size. The dummy
+ *			bytes that will be sent out between the address and
+ *			data of a SPI read operation.
+ */
+struct ocelot_ddata {
+	struct regmap *gcb_regmap;
+	struct regmap *cpuorg_regmap;
+	int spi_padding_bytes;
+	void *dummy_buf;
+};
+
+int ocelot_chip_reset(struct device *dev);
+int ocelot_core_init(struct device *dev);
+
+/* SPI-specific routines that won't be necessary for other interfaces */
+struct regmap *ocelot_spi_init_regmap(struct device *dev,
+				      const struct resource *res);
+
+#define OCELOT_SPI_BYTE_ORDER_LE 0x00000000
+#define OCELOT_SPI_BYTE_ORDER_BE 0x81818181
+
+#ifdef __LITTLE_ENDIAN
+#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_LE
+#else
+#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_BE
+#endif
+
+#endif
-- 
2.25.1

