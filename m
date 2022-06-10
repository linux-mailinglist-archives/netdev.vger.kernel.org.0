Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D2C546E66
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 22:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350811AbiFJU0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 16:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350492AbiFJUZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 16:25:50 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2093.outbound.protection.outlook.com [40.107.94.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86163149BF;
        Fri, 10 Jun 2022 13:24:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RUFLFQIcgEs5fAwcOLIPHyUDw96buS3NQWoVZL6jv9MEcub28hRK/pJkZejMpjXjMGOri/EhNCSRg9Gn/mja0Wd5zJtY/vfh0VQ+6T3ssIFA7K0YjJYX04VLg2xMxdpiACK5O5BN/5yciKs1pbLXgN532TsljfVHR4d4Qe/vSFyze8/MZ+eVaCBZPoDIEPMd+33Xey68el/creaePgUVUtFtJ/jMYJYt69JZeoyBQqGEh786i/22dxV+WkK+PSRa/u1uHxxSefmbGApoAkiQb7dDw2esa/clnO/xqiv2aq1FfiKCwBkM0hny/SssZpB1+qh2v0/1EKR+DJecowU3Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cwnsPo0wRnz1YiT6eiolrvkTeqX/VXDDVkcIOExa3iQ=;
 b=Mb7+WynaqAkxkKzkQ+9i9Vuit0uw8Mx/6PNKQeA7N2DAwCPb1vRsnwphkcZogmdWOdr7InI35YEq+cWChdQ7921ihXW1AGPVojf4mrK9COtH8Tj6+AD/6Z2yp36s2VeBwcwbCzIg9oeHmkvJsk+J8Ha3YHbhJpZHl3i1B1o5xUI7d/tnh5/B1e0+/BoXNQUybBXlBSEpJMZ3ypJ751ueyEa9fOXu2n7XcjWmtUnjSsAeqP73vutQmCeHZzq4ie1QJJHM1g1Bj+rL5GPMBz1dQWeXlP7Z5Is0YvsiDk+SJ3hrrtxyUv78U9nq/83dHUEF3wmnrjc0YJjvDgyKXvnRLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cwnsPo0wRnz1YiT6eiolrvkTeqX/VXDDVkcIOExa3iQ=;
 b=fe4GhD+b6COvM8nlJ751H1uouCuLQ2ptlmrogETUx62yvtQN5jYv4CAMCMIS4Dna5ZK64zpnHaFoOLPCc1a+uR/XgdlfQJp+07ntGpSSnQoz82pNSPrMQXV7KosS9CF7D2fwKNkGuJ2775N/bx/+/beepbzbLZq654eo9rN+LPU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1629.namprd10.prod.outlook.com
 (2603:10b6:301:9::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 20:23:51 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Fri, 10 Jun 2022
 20:23:51 +0000
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
Subject: [PATCH v10 net-next 7/7] mfd: ocelot: add support for the vsc7512 chip via spi
Date:   Fri, 10 Jun 2022 13:23:30 -0700
Message-Id: <20220610202330.799510-8-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9a3b1176-5521-4240-69fb-08da4b1f21bc
X-MS-TrafficTypeDiagnostic: MWHPR10MB1629:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB162911FACD9AF1FC7FC6455DA4A69@MWHPR10MB1629.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LHwwh+AuVYdaPiOENwicfJJ2CNU0llGofqp4dbq5w71+kHvAp17Q2KoWw1EYH4JgXuMokvsriu5YniRtPjNvXTSPBpmmtSsPYEGgWgP5VX5N0CdRlrufm/sDw6EJqv985tyWeV4rKEiBrBTAPBhezrI7EVFsthqhNdMPoWVljwkS3YqMfFNnveF1KJTQdXNAZsWGH7IU60Q4r8PfY9Vh6aZ3SEMv8lG9oLap2DpY32SnWCH8XcSSVciivjFWvSxo+TMzZZR3X0OF5ckN6wI68Vu5OqqHWYYiLMhVQORS81jNUewwN1iN6kkM70RtMgat3qE+NPDQji0WboZmmvjZUc9grNzioTBT3TFeO5i4wGxv1M5BysoFWy3v7Nfao4+I0cjTMB1T0S65NdTASaLQJnEPA7kzt0UvbOy7gIgvWpJ4Y0fr3zXbJQB2Ni3q7hTxpcflJSvEnihBjkPtuJwjZex3CRXssWvxtq3LArIV+Rf0QBAHMLbCVHHdyiyF3WMpqBgEv1yfdQEdqHQyXREbc7NW5+hLv389WTRqsRpj8QLmBAl0pCqua0pw9EaLRYB3J7tCrbGl7dGURwCFcDTAX3Vdk5sXGl8FW1wLpiBQes9niMOAMT5LAVsZOgxS9QD4QrcRrwfuAPQjulARuEoWM3W5nNQzUYr//ysR4PFkbesAUuQJ6myB928Z+9uMInhDc2C3/cvcbUcR+LdmW4nyDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39830400003)(396003)(366004)(346002)(316002)(83380400001)(2616005)(2906002)(1076003)(6486002)(54906003)(8936002)(36756003)(6666004)(52116002)(6512007)(6506007)(26005)(186003)(41300700001)(86362001)(44832011)(66556008)(66476007)(38100700002)(38350700002)(5660300002)(4326008)(7416002)(8676002)(30864003)(508600001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QLQFLCET69UgnADzwKfmm6MP2aOMBwo5jkIUEJhl1jaOuzoiviSlujm05uKd?=
 =?us-ascii?Q?lAa0O1tymMNyUZd7q8Uc7tT1u8Ds/huBz5wg4BWugDM3fD3gSs+8CSsnmJQh?=
 =?us-ascii?Q?H2ExtqJ5mYQvnR+ulHtOHIvD2MjhwwI6zwOIEVAJsDu/aIGLWT55gT3puXr8?=
 =?us-ascii?Q?Im56M9eprDEBN3i/e72T/hOu0e8NhBdEsR8b1YvMn0ONbdOs7XS1R9MJOnVx?=
 =?us-ascii?Q?YBn4gX+6YjJYtodJ28hvz+oitA8knYxqFWu90CPoCpf+IhmrBh1LLFPFgYR8?=
 =?us-ascii?Q?vJH9BeGkZc7bWf+jkENPXFh2Sg0mJv2R8ve1FPBD2UNcrqooil8p+G5jULfG?=
 =?us-ascii?Q?hK0R1FE5ITVUAX+2lhlf/nVW93inhpOkK+ksVKrBZWT9Pn+my6xFvhFKuvN7?=
 =?us-ascii?Q?a6JaoYX/nrPiu6uqbkHcQDeDso4O3VyR+t82M87+dCt8j951OsHqA/KaU10K?=
 =?us-ascii?Q?GJSSuVZxmwdixQZjhxv8Lm0gzgKoFXyY8Kns6mB4+O5fenf8E2Be2U2pEIWs?=
 =?us-ascii?Q?ztgTQrm6Fqfyi5Rr3neDIl/CRi2Y/K0f+ut1LeOm3WO4HONh1BkYHBHEtYXZ?=
 =?us-ascii?Q?oOYNBWZy26LpoVRBK4rdyUA0dAN0LbIwXqP+tnutcFmpzmsaxAebyXm/pZnZ?=
 =?us-ascii?Q?a1tDotde7San7nf8ErbN7MbkiVXZsVRCNr+y83t8VYunIaQ/codmgs8C+iaW?=
 =?us-ascii?Q?yRb7OLSsYcl/u94tTGTJpHNejQBy0kxf7ei4Vleh+AlcAopTQfEEsTSy8tE0?=
 =?us-ascii?Q?MIkPyFcTW3ONuwFiTjkgE7v9hfkCCkTLWs1ROB3dHhwwlwL9TAJxqYSwnCB4?=
 =?us-ascii?Q?VeB/WnMZ1hKnpJm2j13LyTDSjvmQU3QboCqw7m4Ju871tHL0ub+I/djdWayl?=
 =?us-ascii?Q?Zfs7anR6TvCJmGsKza8+8kRP+Zztxic533XgqPT9I/S7tuSIEDAG3kgHue0P?=
 =?us-ascii?Q?/57DVkTC8TVHsx2d6fP/GGxrbZtwDtqCc78NfE5Byb1T3aFgf49ORk5ZJP1s?=
 =?us-ascii?Q?lI1uzRIj59aL0uHbGMH03xz+gZXEgh9huqiyh0vEaayzj7itRKooq5gPObaM?=
 =?us-ascii?Q?vgoCAzIKK8LZWBicA7WBbTCTF5XVUSdPJI2DcDuB/6umAAi7ICLsuZjE5ufb?=
 =?us-ascii?Q?ivnUcH6qf6SDHz49hJLZ09/BkBwySWQ42Z12UTZ7b2hCF/f5Ja+gZNSAuglU?=
 =?us-ascii?Q?6behZ5g4+gvLJHZiqDR/lxKrSPZw5Eh4+4AbpdqkWx5O4olLXaYTl84fAjAc?=
 =?us-ascii?Q?pjxJ/5B1o0YjVkbTx9aSXgvGzYxTYNlNb3obd05XAoQe3HBEDFhZ2SEXdiaj?=
 =?us-ascii?Q?PRzQZBkzcSMWoxvsB/kjgqAOBrn0TxP4tyqfG7yT1PwbpLFz+o3GcJMlhkX4?=
 =?us-ascii?Q?SZReFYd+OrbYgPMh8F64RFqHqdHSuVvPi3711Ei1n13iVJK1uIVnn9QbjGEi?=
 =?us-ascii?Q?UGc8SYIHgYIv88/QDGfrgm2f7WDh7v2Y66ZQn1vErmyivfjiksCMQdTXkgOf?=
 =?us-ascii?Q?GjSQSlLLLmCu/8wXrrR2op6yRMiLr58BHWNitgHXawG2etDgW2rL8bgQIpZF?=
 =?us-ascii?Q?LAn6ZfWB0y6Bqhgt735goLxdlMaY7xAn+4RIQRnF26ErbFY5IR6XU6XTtWKS?=
 =?us-ascii?Q?KZIdWwYiBLYu99Llb2phJ0vIl8uO62AM/XiGMVgG9LW+YClM2aIOnnFe0nyM?=
 =?us-ascii?Q?RqOQyMVyJuCx0y5TbraaBV6oOK9E0JwELx0HMIRhECR7XOWiptxeUGtmLLI4?=
 =?us-ascii?Q?0WxpDAAUjsbFxuFC6AuCySwg//yOWqcbOaRUTyqvMHeiKgAwhk0v?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a3b1176-5521-4240-69fb-08da4b1f21bc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 20:23:51.0911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gUjVWKDa4Bg5TBwRcvKP88AZ2d2BXZs62OyUg8hyz/ddZ3ak6c5rWkHN1FOIo2F1I5I7d4XnGMxiMzVtlh2zDphC2rjSy/h4P+NTRl+LI98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1629
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
---
 MAINTAINERS                |   1 +
 drivers/mfd/Kconfig        |  18 +++
 drivers/mfd/Makefile       |   2 +
 drivers/mfd/ocelot-core.c  | 175 +++++++++++++++++++++
 drivers/mfd/ocelot-spi.c   | 313 +++++++++++++++++++++++++++++++++++++
 drivers/mfd/ocelot.h       |  28 ++++
 include/linux/mfd/ocelot.h |  10 ++
 7 files changed, 547 insertions(+)
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 119fb4207ba3..d24ec7c591a6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14356,6 +14356,7 @@ OCELOT EXTERNAL SWITCH CONTROL
 M:	Colin Foster <colin.foster@in-advantage.com>
 S:	Supported
 F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
+F:	drivers/mfd/ocelot*
 F:	include/linux/mfd/ocelot.h
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3b59456f5545..6887b513b3fb 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -962,6 +962,24 @@ config MFD_MENF21BMC
 	  This driver can also be built as a module. If so the module
 	  will be called menf21bmc.
 
+config MFD_OCELOT
+	bool "Microsemi Ocelot External Control Support"
+	depends on SPI_MASTER
+	select MFD_CORE
+	select REGMAP_SPI
+	help
+	  Ocelot is a family of networking chips that support multiple ethernet
+	  and fibre interfaces. In addition to networking, they contain several
+	  other functions, including pictrl, MDIO, and communication with
+	  external chips. While some chips have an internal processor capable of
+	  running an OS, others don't. All chips can be controlled externally
+	  through different interfaces, including SPI, I2C, and PCIe.
+
+	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
+	  VSC7513, VSC7514) controlled externally.
+
+	  If unsure, say N.
+
 config EZX_PCAP
 	bool "Motorola EZXPCAP Support"
 	depends on SPI_MASTER
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 858cacf659d6..bc517632ba5f 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -120,6 +120,8 @@ obj-$(CONFIG_MFD_MC13XXX_I2C)	+= mc13xxx-i2c.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
+obj-$(CONFIG_MFD_OCELOT)	+= ocelot-core.o ocelot-spi.o
+
 obj-$(CONFIG_EZX_PCAP)		+= ezx-pcap.o
 obj-$(CONFIG_MFD_CPCAP)		+= motorola-cpcap.o
 
diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
new file mode 100644
index 000000000000..7ec5245f24c6
--- /dev/null
+++ b/drivers/mfd/ocelot-core.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Core driver for the Ocelot chip family.
+ *
+ * The VSC7511, 7512, 7513, and 7514 can be controlled internally via an
+ * on-chip MIPS processor, or externally via SPI, I2C, PCIe. This core driver is
+ * intended to be the bus-agnostic glue between, for example, the SPI bus and
+ * the child devices.
+ *
+ * Copyright 2021, 2022 Innovative Advantage Inc.
+ *
+ * Author: Colin Foster <colin.foster@in-advantage.com>
+ */
+
+#include <linux/mfd/core.h>
+#include <linux/mfd/ocelot.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <soc/mscc/ocelot.h>
+
+#include "ocelot.h"
+
+#define GCB_SOFT_RST			0x0008
+
+#define SOFT_CHIP_RST			0x1
+
+#define VSC7512_MIIM0_RES_START		0x7107009c
+#define VSC7512_MIIM0_RES_SIZE		0x24
+
+#define VSC7512_MIIM1_RES_START		0x710700c0
+#define VSC7512_MIIM1_RES_SIZE		0x24
+
+#define VSC7512_PHY_RES_START		0x710700f0
+#define VSC7512_PHY_RES_SIZE		0x4
+
+#define VSC7512_GPIO_RES_START		0x71070034
+#define VSC7512_GPIO_RES_SIZE		0x6c
+
+#define VSC7512_SIO_CTRL_RES_START	0x710700f8
+#define VSC7512_SIO_CTRL_RES_SIZE	0x100
+
+#define VSC7512_GCB_RST_SLEEP		100
+#define VSC7512_GCB_RST_TIMEOUT		100000
+
+static int ocelot_gcb_chip_rst_status(struct ocelot_ddata *ddata)
+{
+	int val, err;
+
+	err = regmap_read(ddata->gcb_regmap, GCB_SOFT_RST, &val);
+	if (err)
+		val = -1;
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
+	ret = regmap_write(ddata->gcb_regmap, GCB_SOFT_RST, SOFT_CHIP_RST);
+	if (ret)
+		return ret;
+
+	ret = readx_poll_timeout(ocelot_gcb_chip_rst_status, ddata, val, !val,
+				 VSC7512_GCB_RST_SLEEP,
+				 VSC7512_GCB_RST_TIMEOUT);
+	if (ret)
+		return dev_err_probe(ddata->dev, ret, "timeout: chip reset\n");
+
+	return 0;
+}
+EXPORT_SYMBOL_NS(ocelot_chip_reset, MFD_OCELOT);
+
+static const struct resource vsc7512_miim0_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_MIIM0_RES_START, VSC7512_MIIM0_RES_SIZE,
+			     "gcb_miim0"),
+	DEFINE_RES_REG_NAMED(VSC7512_PHY_RES_START, VSC7512_PHY_RES_SIZE,
+			     "gcb_phy"),
+};
+
+static const struct resource vsc7512_miim1_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_MIIM1_RES_START, VSC7512_MIIM1_RES_SIZE,
+			     "gcb_miim1"),
+};
+
+static const struct resource vsc7512_pinctrl_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_GPIO_RES_START, VSC7512_GPIO_RES_SIZE,
+			     "gcb_gpio"),
+};
+
+static const struct resource vsc7512_sgpio_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_SIO_CTRL_RES_START,
+			     VSC7512_SIO_CTRL_RES_SIZE,
+			     "gcb_sio"),
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
+		.of_reg = vsc7512_miim0_resources[0].start,
+		.use_of_reg = true,
+		.num_resources = ARRAY_SIZE(vsc7512_miim0_resources),
+		.resources = vsc7512_miim0_resources,
+	}, {
+		.name = "ocelot-miim1",
+		.of_compatible = "mscc,ocelot-miim",
+		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
+		.of_reg = vsc7512_miim1_resources[0].start,
+		.use_of_reg = true,
+		.resources = vsc7512_miim1_resources,
+	},
+};
+
+void
+ocelot_platform_init_regmap_from_resource(struct platform_device *pdev,
+					  unsigned int index,
+					  struct regmap **map,
+					  struct resource **res,
+					  const struct regmap_config *config)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *resource;
+	struct resource **pres;
+	u32 __iomem *regs;
+
+	*map = ERR_PTR(ENODEV);
+	pres = res ? res : &resource;
+
+	regs = devm_platform_get_and_ioremap_resource(pdev, index, res);
+	if (IS_ERR(regs)) {
+		/*
+		 * Fall back to using IORESOURCE_REG, which is possible in an
+		 * MFD configuration
+		 */
+		*pres = platform_get_resource(pdev, IORESOURCE_REG, index);
+		if (!*pres) {
+			dev_err_probe(dev, PTR_ERR(*pres),
+				      "Failed to get resource\n");
+			return;
+		}
+
+		*map = ocelot_spi_init_regmap(dev->parent, dev, *pres);
+	} else {
+		*map = devm_regmap_init_mmio(dev, regs, config);
+	}
+}
+
+int ocelot_core_init(struct device *dev)
+{
+	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs,
+				    ARRAY_SIZE(vsc7512_devs), NULL, 0, NULL);
+}
+EXPORT_SYMBOL_NS(ocelot_core_init, MFD_OCELOT);
+
+MODULE_DESCRIPTION("Externally Controlled Ocelot Chip Driver");
+MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
new file mode 100644
index 000000000000..e07dc1d040a8
--- /dev/null
+++ b/drivers/mfd/ocelot-spi.c
@@ -0,0 +1,313 @@
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
+ * Copyright 2021, 2022 Innovative Advantage Inc.
+ *
+ * Author: Colin Foster <colin.foster@in-advantage.com>
+ */
+
+#include <linux/iopoll.h>
+#include <linux/kconfig.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/spi/spi.h>
+
+#include <asm/byteorder.h>
+
+#include "ocelot.h"
+
+#define DEV_CPUORG_IF_CTRL		0x0000
+#define DEV_CPUORG_IF_CFGSTAT		0x0004
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
+	err = regmap_write(ddata->cpuorg_regmap, DEV_CPUORG_IF_CTRL, val);
+	if (err)
+		return err;
+
+	/*
+	 * Apply the number of padding bytes between a read request and the data
+	 * payload. Some registers have access times of up to 1us, so if the
+	 * first payload bit is shifted out too quickly, the read will fail.
+	 */
+	val = ddata->spi_padding_bytes;
+	err = regmap_write(ddata->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT, val);
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
+	err = regmap_read(ddata->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT, &val);
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
+static int ocelot_spi_regmap_bus_read(void *context,
+				      const void *reg, size_t reg_size,
+				      void *val, size_t val_size)
+{
+	struct ocelot_ddata *ddata = context;
+	static const u8 dummy_buf[16] = {0};
+	struct spi_transfer tx, padding, rx;
+	struct spi_device *spi = ddata->spi;
+	struct spi_message msg;
+
+	spi = ddata->spi;
+
+	spi_message_init(&msg);
+
+	memset(&tx, 0, sizeof(tx));
+
+	tx.tx_buf = reg;
+	tx.len = reg_size;
+
+	spi_message_add_tail(&tx, &msg);
+
+	if (ddata->spi_padding_bytes) {
+		memset(&padding, 0, sizeof(padding));
+
+		padding.len = ddata->spi_padding_bytes;
+		padding.tx_buf = dummy_buf;
+		padding.dummy_data = 1;
+
+		spi_message_add_tail(&padding, &msg);
+	}
+
+	memset(&rx, 0, sizeof(rx));
+	rx.rx_buf = val;
+	rx.len = val_size;
+
+	spi_message_add_tail(&rx, &msg);
+
+	return spi_sync(spi, &msg);
+}
+
+static int ocelot_spi_regmap_bus_write(void *context, const void *data,
+				       size_t count)
+{
+	struct ocelot_ddata *ddata = context;
+	struct spi_device *spi = ddata->spi;
+
+	return spi_write(spi, data, count);
+}
+
+static const struct regmap_bus ocelot_spi_regmap_bus = {
+	.write = ocelot_spi_regmap_bus_write,
+	.read = ocelot_spi_regmap_bus_read,
+};
+
+struct regmap *
+ocelot_spi_init_regmap(struct device *dev, struct device *child,
+		       const struct resource *res)
+{
+	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
+	struct regmap_config regmap_config;
+
+	memcpy(&regmap_config, &ocelot_spi_regmap_config,
+	       sizeof(regmap_config));
+
+	regmap_config.name = res->name;
+	regmap_config.max_register = res->end - res->start;
+	regmap_config.reg_base = res->start;
+
+	return devm_regmap_init(child, &ocelot_spi_regmap_bus, ddata,
+				&regmap_config);
+}
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
+	ddata->dev = dev;
+	dev_set_drvdata(dev, ddata);
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
+		ddata->spi_padding_bytes = 1 +
+			(spi->max_speed_hz / 1000000 + 2) / 8;
+	}
+
+	ddata->spi = spi;
+
+	spi->bits_per_word = 8;
+
+	err = spi_setup(spi);
+	if (err < 0) {
+		return dev_err_probe(&spi->dev, err,
+				     "Error performing SPI setup\n");
+	}
+
+	r = ocelot_spi_init_regmap(dev, dev, &vsc7512_dev_cpuorg_resource);
+	if (IS_ERR(r))
+		return PTR_ERR(r);
+
+	ddata->cpuorg_regmap = r;
+
+	r = ocelot_spi_init_regmap(dev, dev, &vsc7512_gcb_resource);
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
+	 * again before we can access any registers
+	 */
+	err = ocelot_spi_initialize(dev);
+	if (err) {
+		return dev_err_probe(dev, err,
+				     "Error initializing SPI bus after reset\n");
+	}
+
+	err = ocelot_core_init(dev);
+	if (err < 0) {
+		return dev_err_probe(dev, err,
+				     "Error initializing Ocelot core\n");
+		return err;
+	}
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
+	{ .compatible = "mscc,vsc7512-spi" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ocelot_spi_of_match);
+
+static struct spi_driver ocelot_spi_driver = {
+	.driver = {
+		.name = "ocelot_spi",
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
diff --git a/drivers/mfd/ocelot.h b/drivers/mfd/ocelot.h
new file mode 100644
index 000000000000..cf33c3ab89c2
--- /dev/null
+++ b/drivers/mfd/ocelot.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/* Copyright 2021, 2022 Innovative Advantage Inc. */
+
+#include <asm/byteorder.h>
+
+struct ocelot_ddata {
+	struct device *dev;
+	struct regmap *gcb_regmap;
+	struct regmap *cpuorg_regmap;
+	int spi_padding_bytes;
+	struct spi_device *spi;
+};
+
+int ocelot_chip_reset(struct device *dev);
+int ocelot_core_init(struct device *dev);
+
+/* SPI-specific routines that won't be necessary for other interfaces */
+struct regmap *ocelot_spi_init_regmap(struct device *dev, struct device *child,
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
diff --git a/include/linux/mfd/ocelot.h b/include/linux/mfd/ocelot.h
index effa4cc0fc43..6879932a8c68 100644
--- a/include/linux/mfd/ocelot.h
+++ b/include/linux/mfd/ocelot.h
@@ -2,9 +2,18 @@
 /* Copyright 2022 Innovative Advantage Inc. */
 
 #include <linux/err.h>
+#include <linux/kconfig.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 
+#if IS_ENABLED(CONFIG_MFD_OCELOT)
+void
+ocelot_platform_init_regmap_from_resource(struct platform_device *pdev,
+					  unsigned int index,
+					  struct regmap **map,
+					  struct resource **res,
+					  const struct regmap_config *config);
+#else
 static inline void
 ocelot_platform_init_regmap_from_resource(struct platform_device *pdev,
 					  unsigned int index,
@@ -20,3 +29,4 @@ ocelot_platform_init_regmap_from_resource(struct platform_device *pdev,
 	else
 		*map = ERR_PTR(ENODEV);
 }
+#endif
-- 
2.25.1

