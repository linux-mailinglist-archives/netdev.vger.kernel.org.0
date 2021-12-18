Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53645479DAC
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbhLRVuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:50:10 -0500
Received: from mail-mw2nam10on2096.outbound.protection.outlook.com ([40.107.94.96]:43520
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232297AbhLRVuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 16:50:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTvh5OQNNMA+e57P/v9WYu70sMr5j8Kl9dbMXHzqL9rS7Kywp4I2ULxdHThtQ/Kh692TYLMfEEkDKjORwivUkT7+xKIdm/VOQuGDWd5rNHPYMkZtJvlZt6KjJRSeYBWwswmNvTDlq57FJljW5Vubo6kccfkgFVG4i8x3GsmkI0SqfDbWTI7FK50VWV6BJZp3+Qy+SoWeaqF0IKTDrE9OGg1hKULS+L/a2kcUTJxAtOg7zb6RxNdZmeoCOf9qT71Cztil4sMlgmktxCwRtRLhEKRSb6h//Fi+aIhdiYYLhIEa8OWNqQ6u10OVoRfVy8IeJ/cnDHuvH36ajyn5bN1c7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hNO80KltN2iFqUnbBrfM2Se4jiYKvh7CvDdR7MdvFmo=;
 b=IH3Dq/MMSOZDTYIieNreKxVat+zKPqJiYCUbdet60SV3A1yYZWGVB9fA8OiU//1P7khzKfGZvIR84u+iG9CzRnGlPVz443U6DsKDzuAF5gmXN+oEQfc3fqIoepgEeTFTbMKhiMFykVLsecpiqCDPMvDCyu2+QUOG3vPX/TDccBv1ZAySkpQ/wwGq3lcyDnaFT/WMgdOXZJgoy5EyLvJ+YHUWW9yHj23PVl7Q5eOPhyDmBwLWy4RSwwmSWay27yrhzB1Qi6kzYXwJb5ifAypQA/9608MN4iyvD6AOSsuhsac/V7Msrpwojz41gbtSXfYtEIwxF71Nx5jx93vuesIdcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hNO80KltN2iFqUnbBrfM2Se4jiYKvh7CvDdR7MdvFmo=;
 b=kiACsCBsQx1ikc1dAt+Xqlwr0CfGkKKhKUrKe82IXutMlFubHTIKjj48AlxIar8ejvYHekqYce4K4l1LI/J+Z4JTaJPtMKWBIz2Pbp/PlomB+159iLGMKwUp+0oIEne1Be53JXTHenZSEVV6TNe0BfJ897BmgpoHl585xj9aSxA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5633.namprd10.prod.outlook.com
 (2603:10b6:303:148::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sat, 18 Dec
 2021 21:50:06 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4801.017; Sat, 18 Dec 2021
 21:50:06 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v5 net-next 01/13] mfd: ocelot: add support for external mfd control over SPI for the VSC7512
Date:   Sat, 18 Dec 2021 13:49:42 -0800
Message-Id: <20211218214954.109755-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218214954.109755-1-colin.foster@in-advantage.com>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:300:4b::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7aa40a9-dbfa-4510-52c5-08d9c2705a8d
X-MS-TrafficTypeDiagnostic: CO6PR10MB5633:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB56337355CB871598AEEF3860A4799@CO6PR10MB5633.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 82yHhSX1cekxWX+DvX55zjA/6dNjvuRAV29W4IUU1RtUnWwh8EfJFvfdqOlGnfficErhGbdXlCqX5N0gkqHC0LmDpF0LyxvNc0EIA20fI4KpD3m8ZsDwMnITbTLDn+Nr4U4uG/lkoA5qPV7DhjUxHtzPICHmu4JmDPsxY2xwEwq75QtG1fnvSGWLoq4fN+HMQotJHLQ9++zqnMxFu9eCGDmz7eCIdOu8jz5XGbPAtelnLp3zYVynZYk4DtgmzmaZ22dYvqlMzmxNeuFn8ThLampSAt+y3UNyFUNLUcBX/oW0748DQF1gXKFrlq9yBL25qJLgyMQCUgLbFBfBtLME4au+ro4Gh7iTVdndCbTK97oSceR/vKn1RuGylBEBvw1kq86Yt1Ok1ctC8fmRYVtvs9OHLb5VZ2AdPzVWPSuJn//sas7eJ9CsJSDeSM29u2+qarJtQp14xWNgqhk09zSdMlKLuDr10dWD3E9y5znKW6S9QLVmOJqMwRzMK6wv3CvddIO95fkvDjLBd0miIPMhi0sf/bvIeX/Kk8dr4rFBsOQmCEXR1icSxg1fCCt6DQN/d/JAWmM/vtJFV67j0GBbm5HDfbx2Qglh2b9kZit/W4eOstgDf9WVGTYfp6lGRpICCEAPvVJ2xYe6MwgVxnOp1MX3NCvGVQA3yvLsb3Qp2XDdneGE30rZLoBqGpCa717O+/+bcLgx/NTvInqie8jSfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(6486002)(6506007)(7416002)(2906002)(36756003)(6512007)(26005)(86362001)(66556008)(66476007)(186003)(1076003)(6666004)(4326008)(83380400001)(30864003)(66946007)(2616005)(44832011)(8936002)(8676002)(316002)(54906003)(38100700002)(5660300002)(508600001)(52116002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r5oAXYYyDRhXUCcS3JgSgHaaWVcIZPaFW7zs6/WDOvnBAv8nPbqbypPhjJKT?=
 =?us-ascii?Q?2o3BQZFLo27pjARETdHoXoG1O7dVD3iiM8RIG99CjcRV5s03eYfLOIKaEoPZ?=
 =?us-ascii?Q?YtcPqTyMvtd6+BltNqd9+XNnYHeXHlaC7jcR4FLiz2X1egJlTcNthIW/Owg9?=
 =?us-ascii?Q?LdgKmarGh0H5OedIoqB2pUOs3MiUfuQM7E/JjWRgCinYd02aUARAAEXAW6I8?=
 =?us-ascii?Q?kNhxPyW+yD7/0YhWRLXvL2ErpEvHsui0DbVUQ1BXmBRAqttzpbgp7BFlpiuG?=
 =?us-ascii?Q?0KRo7L7jd6mgveSu2WYcvB/T0Ipqza22wsQL9fdc3WfgTEQd5MR+OT9Pi6mC?=
 =?us-ascii?Q?EFO2e4sosyjPf4hC3lbbevST2ExpU8/BjtPlUFXs1cA3NQbJJBvw1YVEMnl/?=
 =?us-ascii?Q?yw5Kr5ZhOvaEtyP+d6ariOKQpya9qpPKX2fGZooxJ0oe0xkq9Xkp6egIfIMR?=
 =?us-ascii?Q?D/Z2RRtKxmkh93BKCDGu8fhZyfKI/Cm1hEllEscbCKgMlIt0u+ecHObmNhHr?=
 =?us-ascii?Q?m1ojZoiVFM7b5VhU71KZjXhzsU+D3lbqZgVlVBJnmUfcPhSdMjfktJpi0ben?=
 =?us-ascii?Q?16hgVcO8cNV8bA7BPSM44OP/dfPFn3qe5kmFvrag7TETP3ST1FwbZOijSBxJ?=
 =?us-ascii?Q?0KwLFMUqHSMZcAOmrKcJtfJG9wZNg4No0lgDNKsOKJRRl4snw9orpsmPNH46?=
 =?us-ascii?Q?7pwpqHvizwJ7uPaz3y31VMJVvybs5ZqOWlgDUHvkYWpYkiPXsujOYBd4fPm4?=
 =?us-ascii?Q?nagofvEJDQqlk/v2aNylr9eaqQ3TduAXrt6FY9Q825QfoKKfH8xiN1eNUJX3?=
 =?us-ascii?Q?eQ0xVSOFkghqkHEzGY4o3vczuJwYXooukK81wqn8yg09MQcOUZOyqbkD6IC8?=
 =?us-ascii?Q?7nlDm06QJDgsTZfp/nU2apU3jnK2yf195wcctMNYIe0EGqlkG3XDjY5NGsZH?=
 =?us-ascii?Q?HB1ofJHh54pkd0d4lXHQrvhq9l1C6ZYJsoh4ZaG5QCvT9B4plZ0e9ZCA1gdc?=
 =?us-ascii?Q?h8CAip1X6T5piLwCSCHPbZCSLRbWem5m6PJo9l70hrhTDRfNoBv2ZCnPcGEz?=
 =?us-ascii?Q?3MwFrKn+Wd1FMQ34/B6ILGGSop0MYfMN/FC6S0jY4it0EauvwCjYmA6npcYf?=
 =?us-ascii?Q?7cTaFx4OWbkiVjU54YxxAsZ5nHlZpGQXgFwEmtVqT7XLTnaYVrGUdHE6AdZw?=
 =?us-ascii?Q?J+ACCyLwROrpbQLuqHQU8aYhiUsOBpYEDUhCBcOzQiucQaqkQvmMws9d7HpQ?=
 =?us-ascii?Q?cbHfCbu6pf8kLf51qRkL985kTa9Zc61SAArAVRM7yj3yKtej6Q1vpYA3IHb5?=
 =?us-ascii?Q?OR4R7nQwv4u7AJ/fswXZ0rbD5XaiQLFDksBcIdGQLW4GRLaJtHeQQQPlJSHc?=
 =?us-ascii?Q?0T0KmOauOjdnQ4NXMYYRRqtcHUMQO3Axx17lM0ISlEyiN80LNS+PhFhQ++nq?=
 =?us-ascii?Q?j0ONbKxCFYVhlOsSxTEv3lyA3uF1wfK/C37ERkZD1GvbTHBrD554ffBC8622?=
 =?us-ascii?Q?9VWqMiOqUnqhjnoNr5ao97M7yBO7FxrvHJG1YFr6WSMMNuLC5/JPqrjSUHR8?=
 =?us-ascii?Q?GPI9PpJ8HTOrbKMj4IlVcdocOOXaBhLuMqg/WwuMJJxZMx61EOiWL4L+E9XN?=
 =?us-ascii?Q?ubx7JhOkuaRlUS0I5lTXiZ4DXJm9EnGtPOcNrX1ceyNbKWP4NHEuqkjRhiqH?=
 =?us-ascii?Q?LpnPAw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7aa40a9-dbfa-4510-52c5-08d9c2705a8d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2021 21:50:06.2847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JkuJQjuii18uSzORArQQPzxsmwBqPEY83o6uuSa8CIItSJkImm+nTrwQYbVohddKOSDzRWP9kLUGMegymEly3opAkv+sqIXLDzivClEDtfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a single SPI MFD ocelot device that manages the SPI bus on the
external chip and can handle requests for regmaps. This should allow any
ocelot driver (pinctrl, miim, etc.) to be used externally, provided they
utilize regmaps.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/mfd/Kconfig       |  15 ++
 drivers/mfd/Makefile      |   3 +
 drivers/mfd/ocelot-core.c | 149 +++++++++++++++
 drivers/mfd/ocelot-mfd.h  |  19 ++
 drivers/mfd/ocelot-spi.c  | 374 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 560 insertions(+)
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-mfd.h
 create mode 100644 drivers/mfd/ocelot-spi.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3fb480818599..af76c9780a10 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -954,6 +954,21 @@ config MFD_MENF21BMC
 	  This driver can also be built as a module. If so the module
 	  will be called menf21bmc.
 
+config MFD_OCELOT_CORE
+	tristate "Microsemi Ocelot External Control Support"
+	select MFD_CORE
+	help
+	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
+	  VSC7513, VSC7514) controlled externally.
+
+config MFD_OCELOT_SPI
+	tristate "Microsemi Ocelot SPI interface"
+	depends on MFD_OCELOT_CORE
+	depends on SPI_MASTER
+	select REGMAP_SPI
+	help
+	  Say yes here to add control to the MFD_OCELOT chips via SPI.
+
 config EZX_PCAP
 	bool "Motorola EZXPCAP Support"
 	depends on SPI_MASTER
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 0b1b629aef3e..dff83f474fb5 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -120,6 +120,9 @@ obj-$(CONFIG_MFD_MC13XXX_I2C)	+= mc13xxx-i2c.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
+obj-$(CONFIG_MFD_OCELOT_CORE)	+= ocelot-core.o
+obj-$(CONFIG_MFD_OCELOT_SPI)	+= ocelot-spi.o
+
 obj-$(CONFIG_EZX_PCAP)		+= ezx-pcap.o
 obj-$(CONFIG_MFD_CPCAP)		+= motorola-cpcap.o
 
diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
new file mode 100644
index 000000000000..a65619a8190b
--- /dev/null
+++ b/drivers/mfd/ocelot-core.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Copyright 2021 Innovative Advantage Inc.
+ */
+
+#include <asm/byteorder.h>
+#include <linux/spi/spi.h>
+#include <linux/kconfig.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+
+#include "ocelot-mfd.h"
+
+#define REG(reg, offset)	[reg] = offset
+
+enum ocelot_mfd_gcb_regs {
+	GCB_SOFT_RST,
+	GCB_REG_MAX,
+};
+
+enum ocelot_mfd_gcb_regfields {
+	GCB_SOFT_RST_CHIP_RST,
+	GCB_REGFIELD_MAX,
+};
+
+static const u32 vsc7512_gcb_regmap[] = {
+	REG(GCB_SOFT_RST,	0x0008),
+};
+
+static const struct reg_field vsc7512_mfd_gcb_regfields[GCB_REGFIELD_MAX] = {
+	[GCB_SOFT_RST_CHIP_RST] = REG_FIELD(vsc7512_gcb_regmap[GCB_SOFT_RST], 0, 0),
+};
+
+struct ocelot_mfd_core {
+	struct ocelot_mfd_config *config;
+	struct regmap *gcb_regmap;
+	struct regmap_field *gcb_regfields[GCB_REGFIELD_MAX];
+};
+
+static const struct resource vsc7512_gcb_resource = {
+	.start	= 0x71070000,
+	.end	= 0x7107022b,
+	.name	= "devcpu_gcb",
+};
+
+static int ocelot_mfd_reset(struct ocelot_mfd_core *core)
+{
+	int ret;
+
+	dev_info(core->config->dev, "resetting ocelot chip\n");
+
+	ret = regmap_field_write(core->gcb_regfields[GCB_SOFT_RST_CHIP_RST], 1);
+	if (ret)
+		return ret;
+
+	/*
+	 * Note: This is adapted from the PCIe reset strategy. The manual doesn't
+	 * suggest how to do a reset over SPI, and the register strategy isn't
+	 * possible.
+	 */
+	msleep(100);
+
+	ret = core->config->init_bus(core->config);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+void ocelot_mfd_get_resource_name(char *name, const struct resource *res,
+				  int size)
+{
+	if (res->name)
+		snprintf(name, size - 1, "ocelot_mfd-%s", res->name);
+	else
+		snprintf(name, size - 1, "ocelot_mfd@0x%08x", res->start);
+}
+EXPORT_SYMBOL(ocelot_mfd_get_resource_name);
+
+static struct regmap *ocelot_mfd_regmap_init(struct ocelot_mfd_core *core,
+					     const struct resource *res)
+{
+	struct device *dev = core->config->dev;
+	struct regmap *regmap;
+	char name[32];
+
+	ocelot_mfd_get_resource_name(name, res, sizeof(name) - 1);
+
+	regmap = dev_get_regmap(dev, name);
+
+	if (!regmap)
+		regmap = core->config->get_regmap(core->config, res, name);
+
+	return regmap;
+}
+
+int ocelot_mfd_init(struct ocelot_mfd_config *config)
+{
+	struct device *dev = config->dev;
+	const struct reg_field *regfield;
+	struct ocelot_mfd_core *core;
+	int i, ret;
+
+	core = devm_kzalloc(dev, sizeof(struct ocelot_mfd_config), GFP_KERNEL);
+	if (!core)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, core);
+
+	core->config = config;
+
+	/* Create regmaps and regfields here */
+	core->gcb_regmap = ocelot_mfd_regmap_init(core, &vsc7512_gcb_resource);
+	if (!core->gcb_regmap)
+		return -ENOMEM;
+
+	for (i = 0; i < GCB_REGFIELD_MAX; i++) {
+		regfield = &vsc7512_mfd_gcb_regfields[i];
+		core->gcb_regfields[i] =
+			devm_regmap_field_alloc(dev, core->gcb_regmap,
+						*regfield);
+		if (!core->gcb_regfields[i])
+			return -ENOMEM;
+	}
+
+	/* Prepare the chip */
+	ret = ocelot_mfd_reset(core);
+	if (ret) {
+		dev_err(dev, "ocelot mfd reset failed with code %d\n", ret);
+		return ret;
+	}
+
+	/* Create and loop over all child devices here */
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_mfd_init);
+
+int ocelot_mfd_remove(struct ocelot_mfd_config *config)
+{
+	/* Loop over all children and remove them */
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_mfd_remove);
+
+MODULE_DESCRIPTION("Ocelot Chip MFD driver");
+MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mfd/ocelot-mfd.h b/drivers/mfd/ocelot-mfd.h
new file mode 100644
index 000000000000..6af8b8c5a316
--- /dev/null
+++ b/drivers/mfd/ocelot-mfd.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright 2021 Innovative Advantage Inc.
+ */
+
+#include <linux/regmap.h>
+
+struct ocelot_mfd_config {
+	struct device *dev;
+	struct regmap *(*get_regmap)(struct ocelot_mfd_config *config,
+				     const struct resource *res,
+				     const char *name);
+	int (*init_bus)(struct ocelot_mfd_config *config);
+};
+
+void ocelot_mfd_get_resource_name(char *name, const struct resource *res,
+				  int size);
+int ocelot_mfd_init(struct ocelot_mfd_config *config);
+int ocelot_mfd_remove(struct ocelot_mfd_config *config);
diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
new file mode 100644
index 000000000000..65ceb68f27af
--- /dev/null
+++ b/drivers/mfd/ocelot-spi.c
@@ -0,0 +1,374 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Copyright 2021 Innovative Advantage Inc.
+ */
+
+#include <asm/byteorder.h>
+#include <linux/spi/spi.h>
+#include <linux/iopoll.h>
+#include <linux/kconfig.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/regmap.h>
+
+#include "ocelot-mfd.h"
+
+#define REG(reg, offset)	[reg] = offset
+
+struct ocelot_spi {
+	int spi_padding_bytes;
+	struct spi_device *spi;
+	struct ocelot_mfd_config config;
+	struct regmap *cpuorg_regmap;
+	const u32 *map;
+};
+
+enum ocelot_dev_cpuorg_regs {
+	DEV_CPUORG_IF_CTRL,
+	DEV_CPUORG_IF_CFGSTAT,
+	DEV_CPUORG_REG_MAX,
+};
+
+static const u32 vsc7512_dev_cpuorg_regmap[] = {
+	REG(DEV_CPUORG_IF_CTRL,		0x0000),
+	REG(DEV_CPUORG_IF_CFGSTAT,	0x0004),
+};
+
+static const struct resource vsc7512_dev_cpuorg_resource = {
+	.start	= 0x71000000,
+	.end	= 0x710002ff,
+	.name	= "devcpu_org",
+};
+
+#define VSC7512_BYTE_ORDER_LE 0x00000000
+#define VSC7512_BYTE_ORDER_BE 0x81818181
+#define VSC7512_BIT_ORDER_MSB 0x00000000
+#define VSC7512_BIT_ORDER_LSB 0x42424242
+
+static struct ocelot_spi *
+config_to_ocelot_spi(struct ocelot_mfd_config *config)
+{
+	return container_of(config, struct ocelot_spi, config);
+}
+
+static int ocelot_spi_init_bus(struct ocelot_spi *ocelot_spi)
+{
+	struct spi_device *spi;
+	struct device *dev;
+	u32 val, check;
+	int err;
+
+	spi = ocelot_spi->spi;
+	dev = &spi->dev;
+
+	dev_info(dev, "initializing SPI interface for chip\n");
+
+	val = 0;
+
+#ifdef __LITTLE_ENDIAN
+	val |= VSC7512_BYTE_ORDER_LE;
+#else
+	val |= VSC7512_BYTE_ORDER_BE;
+#endif
+
+	err = regmap_write(ocelot_spi->cpuorg_regmap,
+			   ocelot_spi->map[DEV_CPUORG_IF_CTRL], val);
+	if (err)
+		return err;
+
+	val = ocelot_spi->spi_padding_bytes;
+	err = regmap_write(ocelot_spi->cpuorg_regmap,
+			   ocelot_spi->map[DEV_CPUORG_IF_CFGSTAT], val);
+	if (err)
+		return err;
+
+	check = val | 0x02000000;
+
+	err = regmap_read(ocelot_spi->cpuorg_regmap,
+			  ocelot_spi->map[DEV_CPUORG_IF_CFGSTAT], &val);
+	if (err)
+		return err;
+
+	if (check != val) {
+		dev_err(dev, "Error configuring SPI bus. V: 0x%08x != 0x%08x\n",
+			val, check);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int ocelot_spi_init_bus_from_config(struct ocelot_mfd_config *config)
+{
+	struct ocelot_spi *ocelot_spi = config_to_ocelot_spi(config);
+
+	return ocelot_spi_init_bus(ocelot_spi);
+}
+
+static unsigned int ocelot_spi_translate_address(unsigned int reg)
+{
+	return cpu_to_be32((reg & 0xffffff) >> 2);
+}
+
+struct ocelot_spi_regmap_context {
+	struct spi_device *spi;
+	u32 base;
+	int padding_bytes;
+};
+
+static int ocelot_spi_reg_read(void *context, unsigned int reg,
+			       unsigned int *val)
+{
+	struct ocelot_spi_regmap_context *regmap_context = context;
+	struct spi_transfer tx, padding, rx;
+	struct ocelot_spi *ocelot_spi;
+	struct spi_message msg;
+	struct spi_device *spi;
+	unsigned int addr;
+	u8 *tx_buf;
+
+	WARN_ON(!val);
+
+	spi = regmap_context->spi;
+
+	ocelot_spi = spi_get_drvdata(spi);
+
+	addr = ocelot_spi_translate_address(reg + regmap_context->base);
+	tx_buf = (u8 *)&addr;
+
+	spi_message_init(&msg);
+
+	memset(&tx, 0, sizeof(struct spi_transfer));
+
+	/* Ignore the first byte for the 24-bit address */
+	tx.tx_buf = &tx_buf[1];
+	tx.len = 3;
+
+	spi_message_add_tail(&tx, &msg);
+
+	if (regmap_context->padding_bytes > 0) {
+		u8 dummy_buf[16] = {0};
+
+		memset(&padding, 0, sizeof(struct spi_transfer));
+
+		/* Just toggle the clock for padding bytes */
+		padding.len = regmap_context->padding_bytes;
+		padding.tx_buf = dummy_buf;
+		padding.dummy_data = 1;
+
+		spi_message_add_tail(&padding, &msg);
+	}
+
+	memset(&rx, 0, sizeof(struct spi_transfer));
+	rx.rx_buf = val;
+	rx.len = 4;
+
+	spi_message_add_tail(&rx, &msg);
+
+	return spi_sync(spi, &msg);
+}
+
+static int ocelot_spi_reg_write(void *context, unsigned int reg,
+				unsigned int val)
+{
+	struct ocelot_spi_regmap_context *regmap_context = context;
+	struct spi_transfer tx[2] = {0};
+	struct spi_message msg;
+	struct spi_device *spi;
+	unsigned int addr;
+	u8 *tx_buf;
+
+	spi = regmap_context->spi;
+
+	addr = ocelot_spi_translate_address(reg + regmap_context->base);
+	tx_buf = (u8 *)&addr;
+
+	spi_message_init(&msg);
+
+	/* Ignore the first byte for the 24-bit address and set the write bit */
+	tx_buf[1] |= BIT(7);
+	tx[0].tx_buf = &tx_buf[1];
+	tx[0].len = 3;
+
+	spi_message_add_tail(&tx[0], &msg);
+
+	memset(&tx[1], 0, sizeof(struct spi_transfer));
+	tx[1].tx_buf = &val;
+	tx[1].len = 4;
+
+	spi_message_add_tail(&tx[1], &msg);
+
+	return spi_sync(spi, &msg);
+}
+
+static const struct regmap_config ocelot_spi_regmap_config = {
+	.reg_bits = 24,
+	.reg_stride = 4,
+	.val_bits = 32,
+
+	.reg_read = ocelot_spi_reg_read,
+	.reg_write = ocelot_spi_reg_write,
+
+	.max_register = 0xffffffff,
+	.use_single_write = true,
+	.use_single_read = true,
+	.can_multi_write = false,
+
+	.reg_format_endian = REGMAP_ENDIAN_BIG,
+	.val_format_endian = REGMAP_ENDIAN_NATIVE,
+};
+
+static struct regmap *
+ocelot_spi_get_regmap(struct ocelot_mfd_config *config,
+		      const struct resource *res, const char *name)
+{
+	struct ocelot_spi *ocelot_spi = config_to_ocelot_spi(config);
+	struct ocelot_spi_regmap_context *context;
+	struct regmap_config regmap_config;
+	struct regmap *regmap;
+	struct device *dev;
+
+
+	dev = &ocelot_spi->spi->dev;
+
+	/* Don't re-allocate another regmap if we have one */
+	regmap = dev_get_regmap(dev, name);
+	if (regmap)
+		return regmap;
+
+	context = devm_kzalloc(dev, sizeof(struct ocelot_spi_regmap_context),
+			       GFP_KERNEL);
+
+	if (IS_ERR(context))
+		return ERR_CAST(context);
+
+	context->base = res->start;
+	context->spi = ocelot_spi->spi;
+	context->padding_bytes = ocelot_spi->spi_padding_bytes;
+
+	memcpy(&regmap_config, &ocelot_spi_regmap_config,
+	       sizeof(ocelot_spi_regmap_config));
+
+	regmap_config.name = name;
+	regmap_config.max_register = res->end - res->start;
+
+	regmap = devm_regmap_init(dev, NULL, context, &regmap_config);
+	if (IS_ERR(regmap))
+		return ERR_CAST(regmap);
+
+	return regmap;
+}
+
+static int ocelot_spi_probe(struct spi_device *spi)
+{
+	struct ocelot_spi *ocelot_spi;
+	struct device *dev;
+	char name[32];
+	int err;
+
+	dev = &spi->dev;
+
+	ocelot_spi = devm_kzalloc(dev, sizeof(struct ocelot_spi),
+				      GFP_KERNEL);
+
+	if (!ocelot_spi)
+		return -ENOMEM;
+
+	if (spi->max_speed_hz <= 500000) {
+		ocelot_spi->spi_padding_bytes = 0;
+	} else {
+		/*
+		 * Calculation taken from the manual for IF_CFGSTAT:IF_CFG. Err
+		 * on the side of more padding bytes, as having too few can be
+		 * difficult to detect at runtime.
+		 */
+		ocelot_spi->spi_padding_bytes = 1 +
+			(spi->max_speed_hz / 1000000 + 2) / 8;
+	}
+
+	ocelot_spi->spi = spi;
+	ocelot_spi->map = vsc7512_dev_cpuorg_regmap;
+
+	spi->bits_per_word = 8;
+
+	err = spi_setup(spi);
+	if (err < 0) {
+		dev_err(&spi->dev, "Error %d initializing SPI\n", err);
+		return err;
+	}
+
+	dev_info(dev, "configured SPI bus for speed %d, rx padding bytes %d\n",
+			spi->max_speed_hz, ocelot_spi->spi_padding_bytes);
+
+	/* Ensure we have devcpu_org regmap before we call ocelot_mfd_init */
+	ocelot_mfd_get_resource_name(name, &vsc7512_dev_cpuorg_resource,
+				     sizeof(name) - 1);
+
+	/*
+	 * Since we created dev, we know there isn't a regmap, so create one
+	 * here directly.
+	 */
+	ocelot_spi->cpuorg_regmap =
+		ocelot_spi_get_regmap(&ocelot_spi->config,
+				      &vsc7512_dev_cpuorg_resource, name);
+	if (!ocelot_spi->cpuorg_regmap)
+		return -ENOMEM;
+
+	ocelot_spi->config.init_bus = ocelot_spi_init_bus_from_config;
+	ocelot_spi->config.get_regmap = ocelot_spi_get_regmap;
+	ocelot_spi->config.dev = dev;
+
+	spi_set_drvdata(spi, ocelot_spi);
+
+	/*
+	 * The chip must be set up for SPI before it gets initialized and reset.
+	 * Do this once here before calling mfd_init
+	 */
+	err = ocelot_spi_init_bus(ocelot_spi);
+	if (err) {
+		dev_err(dev, "Error %d initializing Ocelot SPI bus\n", err);
+		return err;
+	}
+
+	err = ocelot_mfd_init(&ocelot_spi->config);
+	if (err < 0) {
+		dev_err(dev, "Error %d initializing Ocelot MFD\n", err);
+		return err;
+	}
+
+	dev_info(&spi->dev, "ocelot spi mfd probed\n");
+
+	return 0;
+}
+
+static int ocelot_spi_remove(struct spi_device *spi)
+{
+	struct ocelot_spi *ocelot_spi;
+
+	ocelot_spi = spi_get_drvdata(spi);
+	devm_kfree(&spi->dev, ocelot_spi);
+	return 0;
+}
+
+const struct of_device_id ocelot_mfd_of_match[] = {
+	{ .compatible = "mscc,vsc7514_mfd_spi" },
+	{ .compatible = "mscc,vsc7513_mfd_spi" },
+	{ .compatible = "mscc,vsc7512_mfd_spi" },
+	{ .compatible = "mscc,vsc7511_mfd_spi" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ocelot_mfd_of_match);
+
+static struct spi_driver ocelot_mfd_spi_driver = {
+	.driver = {
+		.name = "ocelot_mfd_spi",
+		.of_match_table = of_match_ptr(ocelot_mfd_of_match),
+	},
+	.probe = ocelot_spi_probe,
+	.remove = ocelot_spi_remove,
+};
+module_spi_driver(ocelot_mfd_spi_driver);
+
+MODULE_DESCRIPTION("Ocelot Chip MFD SPI driver");
+MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
+MODULE_LICENSE("Dual MIT/GPL");
-- 
2.25.1

