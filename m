Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063B95AD761
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237807AbiIEQWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236506AbiIEQWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:22:02 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2113.outbound.protection.outlook.com [40.107.102.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373485AC7F;
        Mon,  5 Sep 2022 09:22:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6vFV/F9M1z7ZzkcItSz4HXXM0CPvIZFNSRzcqc3m6QwWYB5MmymJQZ08RXbPiqgh8SI/Mn2s2p8/q8Cg1P6L5mA3y18hG/xrVqmULTotz4wwfrds5DfKpmcTdAXfioqm5VjPoQCa5n6M0ADrN/tMukVxAZmTu8IZnMdtWdQJrwWM4dknSPoEyJRroYj21XSmGFVjyi5ZosNwJlp9kpKSL0k6w9OAGfmQ6dNKbcpC8UXmKQVJC8h7m4vxIy9cTU0gyWclvMaT301PLYRlaIhTw8pBYD6k0522FTW2NuidD/k8MxaEKJors4MJqAOOwbYpIBaj65T5InNmSwvWVAYKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CkSt1DE0vzKc6FUZaF6mG5wilqZzfirnN8MpyLbR5hc=;
 b=Gv94njxz4ejox/rJ47Ijgjj4i5NBIh44sxAgyicTnAcy/GKUBhCJyFZzk4+lHzYPAhUc6iq3hyqWoRGjSztX//c36LQktEeCi7nnScfZjHedqyPQnq7h2Wqzgu6ZhMiEvdjj47Fe8QxmEVZLF8f9u83Ggj9sh5+3Kbx3SC1+dBGiusnMEeEyGpKYCMNRgHMW+t4fIlt8Hse1vNRJSyCoqd5ptqWv72dTqAl2go1RnoniH5ZbgSejwEFSOJDqD/gq1JMmSt1UciYiYvA7LLTrVENvoZcIvZms0tpflGoC9RpqIkCXJXXCi/mfBtGkVajqLAstZKO+pyWEvKxhVgmLeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkSt1DE0vzKc6FUZaF6mG5wilqZzfirnN8MpyLbR5hc=;
 b=jr9w4IJtxp8+I0y6Dqw6kEZdSDWuceOtFDfBxBrcEKMaS4nd9Kxfmn6fG/E3AcQXCENbA0JwwKeStaRjQspAYo9J/g0WOU1PlI6Iqq7ckL/Hp6YKN5h5yQv001EXcT7er4JYwJpByQssfOX5igNegGzRTh5nO/1TVudLsa3bZak=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB5848.namprd10.prod.outlook.com
 (2603:10b6:510:149::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Mon, 5 Sep
 2022 16:21:56 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.012; Mon, 5 Sep 2022
 16:21:56 +0000
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
Subject: [RESEND PATCH v16 mfd 8/8] mfd: ocelot: add support for the vsc7512 chip via spi
Date:   Mon,  5 Sep 2022 09:21:32 -0700
Message-Id: <20220905162132.2943088-9-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: f84f4755-003a-41a0-8c1e-08da8f5ac002
X-MS-TrafficTypeDiagnostic: PH0PR10MB5848:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: miNQOexZu5k9HVXK3s/SKUD3vQf56nzoGOayFdu0TeqyxUnuhTqF/4cOlJU+FIAXvFpnVHcxLRJudvxtzGAc10y/3SpLMSlvDg/xO/72JFfXFytTSbqhdXErVG0YcEDjLGDtUebQgo4ASPI3nR86PE/7ucgdUNK40Js9nDFaZ8Tg7bP3sJVWbYe/3kZl8tU72F7o/2ctm6G1+uCYNzi1HpRyHtl+drSHWFack4VAWgKmTNiXZI7v8w2R5F1y2sYzdgWNaeYp8nbLeN3tmVY5llFp43mWo4HmAOnxpSfbIavguwxaScuR0WMHl3pdDIv2UR3PncS2JWcSN/wKmeVoUlKnsP9IqqQbxewpWOz938sx8I+DIoXEuNx6wi3DeiO4xRJO8KpAH9NnYgLu0VPPH7/hFwwYPeTbBkAuLcff9w5+OkmoR5MD4fQRCethAq4BUUsTs0WmkSLb4mFKY1ZxP7ZnnCvCPeUdhey8aml7qob8sfXZpDRGTiItlK8n9wWKAJy9t/2R8Rz9tmiYDbq+oQTqaxTDprtNdvw9NmeosB5VO/83ihp4WTPKz/Px07z1KSC22criv7QtVVJ3U0/RdXxmHDt+PuUa5T1tfMuJqvmU9Z1ssnBOEAiMC9uPLRK9MhyDQL1gYMPIm3LpJIUQ1aleG0meFS5F7oAHKmGOD9VHVaByMtQYInnWgSe2B/a6QI7uC9uoFBRRwNuLJ8+L5/kg34Xv/IxP7ExTc1CNkmDt73vSYzpX5tYpLDNfEX4B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(376002)(39830400003)(136003)(366004)(66946007)(5660300002)(8936002)(66556008)(54906003)(6486002)(41300700001)(6666004)(107886003)(52116002)(30864003)(186003)(2906002)(1076003)(7416002)(2616005)(44832011)(6512007)(36756003)(6506007)(316002)(83380400001)(26005)(38350700002)(38100700002)(4326008)(86362001)(66476007)(8676002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hYzcvizrOvQrewjkZrmo8nLBc0ZM3EHGWmaN80fuyEoYi4iec5RNpNGLrQju?=
 =?us-ascii?Q?ENpZYNI9nQiLoI63yVTohUZVIaLeszrtrQDIo1eH7YW35bmNjAK0LpOYQ3dJ?=
 =?us-ascii?Q?HBOOuyJbRZYlmGzwCjxKyCeauGgGewhDE+2aRRIeKp0mK2ChFru/FYkL7ZIZ?=
 =?us-ascii?Q?Y332S6jO4/FNuRCLLsVPK/yxm1eEA0EIv6Z3OftAcDJx1N7za+OnEro1ERW6?=
 =?us-ascii?Q?shD0ueMbIahC1tpJrXjSs2N9jmOeHh1lAwASgftzijIRjC9Gnqa06iTfLc0z?=
 =?us-ascii?Q?FTxc9JJHlCO1kC6Z/iUpRw8mHD2KX7RgbNAvpgyrTKoF1bljJzk16geJzL6/?=
 =?us-ascii?Q?Zwc+aEfttxMgvsntrfT8RdR87DToEfFQoDCsxJEfCci5QFy2kGgHCa6BpIXV?=
 =?us-ascii?Q?K93nHdDjfMSoHspTyfwY9qMLXFD9JliSRS7bfJqMimLBpT4H0OVYcOKv+FMS?=
 =?us-ascii?Q?mdBobi3M9rESdJj2iwXxvi1mXDafbz9K2CjZWCibxRWJeaFkPlsMRt+zm2/G?=
 =?us-ascii?Q?HV/i3+LRFw44WmSIgK0uMCSdAxUHApvQiPmaHl1EckSaPFSUeD+C6WgJzvqy?=
 =?us-ascii?Q?l66nTt66AO+H2j9M8KgkCWNH6wm24JLAEgeUO2PS8+2qjVoa7/orYghOT5Jz?=
 =?us-ascii?Q?q5wOf3Disb+7LUzM5ModiK8IlfXGpm434SlvwFR1JPVHWUO3Pn9qPAlI3N81?=
 =?us-ascii?Q?2VXai2acmOVRKJr5r/HbdOp9hF/Fxz8xgcBlx0Th6UzbVQEidIoXc6mpRHC8?=
 =?us-ascii?Q?RSWohzEIl++FIILi3dUSTMuTIltu054q5njaG6v7XgTYJnDQ4NkVlw318k+l?=
 =?us-ascii?Q?LrqzFWSFBXX4lIg4f79CJ7+MSriygUFKbslEjqfcrexp1bqo5mlB8FaDlkVf?=
 =?us-ascii?Q?v3vSgG/leAjExWMbNP8pZbpLNc5M49JRplLTg3nfNvn0ztvnM2I5YA+dabk9?=
 =?us-ascii?Q?DqcBBih4AORjmaDWD2ytuagTIM6ry6ll57sHIG4QS2HuR7iHPeURWsy7o/DK?=
 =?us-ascii?Q?0CG03btD7o9n2+C5uqFyvQSmgbPASusB21pwuMvLhe4h+QXTjoifYyrjN+EG?=
 =?us-ascii?Q?10atpxKGDVVB+Pu0oGlDs0NAG5vhLIHU4w+7ArSjyXN3lTDZZSJ+6FqakLwT?=
 =?us-ascii?Q?Zxv3CK17j/DtnQNKX9rQSJvPKSLm0hfZzTcKMD9ELc0F9WTAhXc+DaSFPE83?=
 =?us-ascii?Q?kDOFDT+WBgqEQ9A7anh5bxAZqHyTXnxEpBUrOMFOuHZM9xzN17VF/bVijykC?=
 =?us-ascii?Q?kqSa9uAPQUiDZfNvbX0FnWPW3EtKQchrjBJQYCdnUbt+9OzlE1CNVIyVG6K7?=
 =?us-ascii?Q?IHgFBcOKE9VIMcs+xPVlS9Kczwi/BuEs5zlLnJrKd/xvLNmhf0dPUdabLKDE?=
 =?us-ascii?Q?ezRX1c6xKalePsZzkKjhNYwRC+wIRFoSA3JlvENQlQkqzpCwS1EfnR/0dETd?=
 =?us-ascii?Q?nxW4PVowLQXDFe2xYebLGfTrAOP8z+xFHuYoHXSFsbC2LtXm5ZPX5xoKl/5J?=
 =?us-ascii?Q?jYOzmhJSEweI47tS41W7un6xhygPK65d29cmFxsN8L8wrdFt1chf50XyYjOx?=
 =?us-ascii?Q?RNB7DHvimq8jpxhaI9XcFKJIcuokdflCfdGbkmtwbQcDuLYtQwqi4ucxkgnW?=
 =?us-ascii?Q?zQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f84f4755-003a-41a0-8c1e-08da8f5ac002
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 16:21:55.9754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 65XStQiSuhHoAfX0r8r79pmuSe3GQ97Q7Z/d3drcBHwWMEAW914Ol1z8Dwli4lP63BrMcOA6zn0bN57FCDxFqvxo2uwGn5wZ1w9tKNa2yh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

v16
    * Includes fixups:
    *  ocelot-core.c add includes device.h, export.h, iopoll.h, ioport,h
    *  ocelot-spi.c add includes device.h, err.h, errno.h, export.h, 
       mod_devicetable.h, types.h
    *  Move kconfig.h from ocelot-spi.c to ocelot.h
    *  Remove unnecessary byteorder.h
    * Utilize resource_size() function

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
 drivers/mfd/ocelot-core.c | 161 ++++++++++++++++++++
 drivers/mfd/ocelot-spi.c  | 299 ++++++++++++++++++++++++++++++++++++++
 drivers/mfd/ocelot.h      |  49 +++++++
 6 files changed, 534 insertions(+)
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h

diff --git a/MAINTAINERS b/MAINTAINERS
index a5df3b0b9601..90a873dd04b0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14745,6 +14745,7 @@ OCELOT EXTERNAL SWITCH CONTROL
 M:	Colin Foster <colin.foster@in-advantage.com>
 S:	Supported
 F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
+F:	drivers/mfd/ocelot*
 F:	include/linux/mfd/ocelot.h
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index abb58ab1a1a4..c3dd1fe8d8c9 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -963,6 +963,27 @@ config MFD_MENF21BMC
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
index 000000000000..1816d52c65c5
--- /dev/null
+++ b/drivers/mfd/ocelot-core.c
@@ -0,0 +1,161 @@
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
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/iopoll.h>
+#include <linux/ioport.h>
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
index 000000000000..0f097f4829d1
--- /dev/null
+++ b/drivers/mfd/ocelot-spi.c
@@ -0,0 +1,299 @@
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
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <linux/ioport.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/spi/spi.h>
+#include <linux/types.h>
+#include <linux/units.h>
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
+	regmap_config.max_register = resource_size(res) - 1;
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
index 000000000000..b8bc2f1486e2
--- /dev/null
+++ b/drivers/mfd/ocelot.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/* Copyright 2021, 2022 Innovative Advantage Inc. */
+
+#ifndef _MFD_OCELOT_H
+#define _MFD_OCELOT_H
+
+#include <linux/kconfig.h>
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

