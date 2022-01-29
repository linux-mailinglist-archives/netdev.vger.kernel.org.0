Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2CE4A3240
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 23:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiA2WDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 17:03:08 -0500
Received: from mail-dm3nam07on2115.outbound.protection.outlook.com ([40.107.95.115]:64192
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353320AbiA2WCt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jan 2022 17:02:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3oSsh8THE6lJsTe1vq8n20SPyzyyYj2foU+xgLro09k2wxFqx2lUnwKS7ZQqkQeqHrbMnWLSYlSc8tPQAyYXl3d239wRPpTUektoIhB2pVfwzi63Y850dMxMy+I8RN2AE/Yw6vV4zCXX3zmW1WnuoNaSmrRbjPL052zA8K7fHGqZ1ng8pRtXubHKROI1OdfY5nS8QvTkdGkEwabvY5TBc7uzq1LE+dHzDaLw7OWXoJ0ox5ZvKvXFaR3qxbNcxInugJFL04Gu/5k8kz1i0NlfwAsoZ68jhLBtS3to73cM4D+He22R/zfec3/lMjygnGDwXu6FDEKEMmNZ67ePYrxew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+jBsLBxId7mR5rihhs3Mlgj8tXBRT9r6EaKHf+IhkeA=;
 b=KUUoECI7mL8cHPPSC0bZgFMlfc1rQFWSSqvE7fxsIfYEpXpuLMxL/uAVWQceL+0ZebTWl801Apw28tg/jJ5o2MumlecsTk+SX/+3hi7EX6F7wB9LoFVoSKlyCwnn1V2r609F1c0vInwQqYFklwoUHrzNx967QGnEZf73XccBp2b8Lg7bgEWjkM7mftgUd+HEm+B5qHbE9PkbsgaSAwaFUf5HFJftBmR6x28Scf1EG7nMieejX5ONvexLBUJLG+GjmumpzHqQjgzHpMR3NPw4MS50/h510a1E6LmDXgNR+2bD9XSURWZeoxveKhiwSK6dZ8OQYuVctKq84xbSWWxfMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+jBsLBxId7mR5rihhs3Mlgj8tXBRT9r6EaKHf+IhkeA=;
 b=ckf+tLWLRXpdVhMOM0HrXgsxSiMjSNW1mi6ls94YCu0eaQuGcYPgwVPgQ4qhWkTOw8OwZoCSOGdaIkYhzXjB41llDXptsxhUnRbmHGC2FUhbEqg62ZOeCLdmRwFzbdslNPDcfFc6eIOrsKC66KXywCoNhQf3WpbHWxiMsbovjbI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB2968.namprd10.prod.outlook.com
 (2603:10b6:a03:85::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Sat, 29 Jan
 2022 22:02:46 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4930.020; Sat, 29 Jan 2022
 22:02:46 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
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
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [RFC v6 net-next 9/9] net: dsa: ocelot: add external ocelot switch control
Date:   Sat, 29 Jan 2022 14:02:21 -0800
Message-Id: <20220129220221.2823127-10-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220129220221.2823127-1-colin.foster@in-advantage.com>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO1PR15CA0113.namprd15.prod.outlook.com
 (2603:10b6:101:21::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f15f9a1b-69cc-4ff7-0cdf-08d9e37314bf
X-MS-TrafficTypeDiagnostic: BYAPR10MB2968:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2968A5FD62463F4EB1CD73ADA4239@BYAPR10MB2968.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oss/mGPDhr8LrTpeRjqBPUzvBukWIqnSIlnFxRLOrW8sdDTpwgvRvbLqnIiFW/lmZ1GaZWX+pp2OneZ2uV/Uy4CazSSDYyEMhlTazmMhqn2qM5qSTfaJOnmICpIgtr1LbecIMKsbEKS/zK6U7mkrzBDA4bT+rAH1wl+BYOnGpdt1CxF8U03hHbezHzc2XTUGIXu//V717XrCkV/zKO+ovSCIvi/HNgmHimxRzc1L8FnRh6du72d5D+zKxIgJc7q6JOE/pUXyV1/xxNlH/T9c78NVoOejTwdf90f767qY7p5YnFSJMnyAVbneRGCULJInvfUPfWfcopMcHIb4IpejmnWu0WaRpLvrPzKbzKyR6S8j7vjGXDSea4NCwZf4JajLBZVy6AaWRAsne+jUMx53DfyX2SK582t6ezwdy7b5uCtkSLZ1tQjjHIbwBj0KoYVaRCl0VsVxLF67xHM2rYeLhcUt6yeA1vxIuh0jMNTEYqvsc0o9canaEQ9sIPxO/PqhvWD9B2KruLkGpvB5DVvXhmWSxs/5whMUgxFCuazbC4C8cm/v+ryb0MHHK7Ial9zkeA7EA0hhSgPGmyur3VsNe3mqwSVgCExPgwgFb6djmEyh7q/F8qNuEyl8XTZCtSZVnU9/yn56ariBuC5wKFyX8PsM+h21nn6p6Abr6na0Al2+PIpNHGvPfH7Y3K5yqNedSb2Vwko/zQe2YZ0D/qcenQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(376002)(346002)(42606007)(396003)(39830400003)(366004)(186003)(508600001)(5660300002)(6486002)(1076003)(86362001)(66946007)(8676002)(66476007)(26005)(4326008)(66556008)(8936002)(7416002)(107886003)(6506007)(38350700002)(6512007)(2906002)(30864003)(44832011)(6666004)(2616005)(52116002)(38100700002)(83380400001)(316002)(36756003)(54906003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nAXFlq78aSVXmQennnxClZlbQ416poxp/frdsgsQ8zmzlxDKJVLOSIKdJkH2?=
 =?us-ascii?Q?+dO6iyd0aJ8njubOqBl8pOwi63T6woRcpjeEp2gIxhLESFstFMxbu9SsP+Lq?=
 =?us-ascii?Q?5Zzukj+L+BUEGsfplhXGUS+QiKojkad8kb3AIL2WuN8yREOHEs2iJ+Z/ry+A?=
 =?us-ascii?Q?HUEu5dkhjP4NMK9iLHoXCz5rKS2ggLj+gmbwd9BkzEZ50mgN2AN+VfEbcli+?=
 =?us-ascii?Q?PwOEVu/qlMPPUAUYzXn56h4ijQc59rmaZmIt6ziQZOLcFG/jIz+wugaxOVVE?=
 =?us-ascii?Q?LGgG5desqIrmQubNpnyB9psqCbMzb1X5UvL7LixSc0diNTdXmCbraZ50Yg15?=
 =?us-ascii?Q?plmSYKvLlABDAsHlrYKrXLfm9FqHR7RYHgRgGqh7wrTpAIfWw+BSFeq48YXR?=
 =?us-ascii?Q?sHTxWkjjq8ujslsaKlrnXiM4kTvxuQj4ytaOrW2ee0Ys0hksEZOu/HxFOr2D?=
 =?us-ascii?Q?Chw3XsnAe7harVxx6u+VTbQ5ZwgDAyvtxv1EsCD27lU/J8CNfcApHeMWUcDS?=
 =?us-ascii?Q?2pN+0Axk5YiugVd3EA9Xr7fmhychYvROZ6jeqnihK0doiubNPi7Cpm0xmBHp?=
 =?us-ascii?Q?fYTJcT/sr55Q0m3LPr0nkzyxThdJ6E+myXUV7JZ4rYqziftstlETtwAMQbMF?=
 =?us-ascii?Q?DIFnTNk7QmqI75KG5QhW1Bgnz+DgRU3VqByfxBW4ovqMC9IZqpWJtpEU6J68?=
 =?us-ascii?Q?NmMiYyUidPAKt/VWcQ6AROSeAWlL7N/zVRuKVZjvVW8T63nfl3MHTrKDA31t?=
 =?us-ascii?Q?BzuatMUqokL0fyGN9BeWbhO1lxus/qcYvMv9KMcA37d6VSP03gwcowb3xoQB?=
 =?us-ascii?Q?DtoNKzIOGJitdrkexrSpaPr1+5H8Wmzczx9/neJugZKEvmtLdojaLr7m7i+A?=
 =?us-ascii?Q?zY9SQB4bOuXOBPJ/o48yvlmQr3P7XvxD9ECqTQmG/flfE3QxeGifNPzoZvKh?=
 =?us-ascii?Q?ilnpiJImi/JIgmg5Dn7Bd8qws6a30GQCHqIqULqQKiOW30161VnCgpeThn+2?=
 =?us-ascii?Q?cIpfaZ0Z6ts3q5PXqBXgmcwxDdmlW39AWuu0XS2/uUr+ICH4+TJC9+VuizT0?=
 =?us-ascii?Q?kBmW67Gc8j3YugUionZOOdcfttaGTyh2jKwsZxD1/jP10RtgSod8qrC3V6hi?=
 =?us-ascii?Q?xYyvDC4Nl/r0Mx+IgDgJoYsq7RW/rjyg2boANC1fGYMB+/EgCeXgZaAjimlS?=
 =?us-ascii?Q?J9MCAtj1274IuyCFRzBjVYL+aGzP4pVGHmF7UfKTvGY6wtjweq+1jN0DSqjt?=
 =?us-ascii?Q?lWEx7JT6PVycO0+hWQNDy7FES1XdoTfqwdMym7xEXSYXKKROFgeFnOxwesI1?=
 =?us-ascii?Q?F8RxvFzeavb51pQA+U3QWbDCjhn7lZm5ljFGQsFImhg5g7XBbCzUycOblzw9?=
 =?us-ascii?Q?MCfwDEdNXgnjOXJQwe9mS2oK3CzX+I0kyWjYIpiRWi3eg6J0pxG4br6c3W2b?=
 =?us-ascii?Q?QpyUzVRtUjxagnHTuBcBGSGZYvq7cBG64a/6/pfOQTB0dr59MwhDbjiky6Kx?=
 =?us-ascii?Q?CHQDksGTEu/1bSnlq97L+ko6D+OC3kim4cVRWvx1KXD336VgV9nu3Dqzg7Cs?=
 =?us-ascii?Q?VUVnG5TXkfuG+OhzqJvXSun3x5fOx8FGrSGFo7eF9oijsIvX2TtPGY/VpGSr?=
 =?us-ascii?Q?Bdsc0mda0YWQuu4Jylsa8OQAwXZq/g9SUTIpLAjI5BQF3VAVGFaF4T7QVvYE?=
 =?us-ascii?Q?nYwmffb3I3Lw4jboBKtqQfxei+s=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f15f9a1b-69cc-4ff7-0cdf-08d9e37314bf
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2022 22:02:46.0632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: thVyjXSDjb7LbfL6GeRunIB8lLgnRmSl1reJuMMAP+pWb+ePcYVnzEM6YqU/GpdPnRfJI36uTw4Am9DH9/QB0qhLh2foR01F8m2WG8DJeLQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add control of an external VSC7512 chip by way of the ocelot-mfd interface.

Currently the four copper phy ports are fully functional. Communication to
external phys is also functional, but the SGMII / QSGMII interfaces are
currently non-functional.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/mfd/ocelot-core.c           |   4 +
 drivers/net/dsa/ocelot/Kconfig      |  14 +
 drivers/net/dsa/ocelot/Makefile     |   5 +
 drivers/net/dsa/ocelot/ocelot_ext.c | 681 ++++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h           |   2 +
 5 files changed, 706 insertions(+)
 create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index 590489481b8c..17a77d618e92 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -122,6 +122,10 @@ static const struct mfd_cell vsc7512_devs[] = {
 		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
 		.resources = vsc7512_miim1_resources,
 	},
+	{
+		.name = "ocelot-ext-switch",
+		.of_compatible = "mscc,vsc7512-ext-switch",
+	},
 };
 
 int ocelot_core_init(struct ocelot_core *core)
diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 220b0b027b55..f40b2c7171ad 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -1,4 +1,18 @@
 # SPDX-License-Identifier: GPL-2.0-only
+config NET_DSA_MSCC_OCELOT_EXT
+	tristate "Ocelot External Ethernet switch support"
+	depends on NET_DSA && SPI
+	depends on NET_VENDOR_MICROSEMI
+	select MDIO_MSCC_MIIM
+	select MFD_OCELOT_CORE
+	select MSCC_OCELOT_SWITCH_LIB
+	select NET_DSA_TAG_OCELOT_8021Q
+	select NET_DSA_TAG_OCELOT
+	help
+	  This driver supports the VSC7511, VSC7512, VSC7513 and VSC7514 chips
+	  when controlled through SPI. It can be used with the Microsemi dev
+	  boards and an external CPU or custom hardware.
+
 config NET_DSA_MSCC_FELIX
 	tristate "Ocelot / Felix Ethernet switch support"
 	depends on NET_DSA && PCI
diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
index f6dd131e7491..d7f3f5a4461c 100644
--- a/drivers/net/dsa/ocelot/Makefile
+++ b/drivers/net/dsa/ocelot/Makefile
@@ -1,11 +1,16 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_MSCC_FELIX) += mscc_felix.o
+obj-$(CONFIG_NET_DSA_MSCC_OCELOT_EXT) += mscc_ocelot_ext.o
 obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) += mscc_seville.o
 
 mscc_felix-objs := \
 	felix.o \
 	felix_vsc9959.o
 
+mscc_ocelot_ext-objs := \
+	felix.o \
+	ocelot_ext.o
+
 mscc_seville-objs := \
 	felix.o \
 	seville_vsc9953.o
diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot/ocelot_ext.c
new file mode 100644
index 000000000000..6fdff016673e
--- /dev/null
+++ b/drivers/net/dsa/ocelot/ocelot_ext.c
@@ -0,0 +1,681 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Copyright 2021 Innovative Advantage Inc.
+ */
+
+#include <asm/byteorder.h>
+#include <linux/iopoll.h>
+#include <linux/kconfig.h>
+#include <linux/mdio/mdio-mscc-miim.h>
+#include <linux/of_mdio.h>
+#include <linux/phylink.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <soc/mscc/ocelot_ana.h>
+#include <soc/mscc/ocelot_dev.h>
+#include <soc/mscc/ocelot_qsys.h>
+#include <soc/mscc/ocelot_vcap.h>
+#include <soc/mscc/ocelot_ptp.h>
+#include <soc/mscc/ocelot_sys.h>
+#include <soc/mscc/ocelot.h>
+#include <soc/mscc/vsc7514_regs.h>
+#include "felix.h"
+
+#define VSC7512_NUM_PORTS		11
+
+#define OCELOT_SPI_PORT_MODE_INTERNAL	(1 << 0)
+#define OCELOT_SPI_PORT_MODE_SGMII	(1 << 1)
+#define OCELOT_SPI_PORT_MODE_QSGMII	(1 << 2)
+
+const u32 vsc7512_port_modes[VSC7512_NUM_PORTS] = {
+	OCELOT_SPI_PORT_MODE_INTERNAL,
+	OCELOT_SPI_PORT_MODE_INTERNAL,
+	OCELOT_SPI_PORT_MODE_INTERNAL,
+	OCELOT_SPI_PORT_MODE_INTERNAL,
+	OCELOT_SPI_PORT_MODE_SGMII | OCELOT_SPI_PORT_MODE_QSGMII,
+	OCELOT_SPI_PORT_MODE_SGMII | OCELOT_SPI_PORT_MODE_QSGMII,
+	OCELOT_SPI_PORT_MODE_SGMII | OCELOT_SPI_PORT_MODE_QSGMII,
+	OCELOT_SPI_PORT_MODE_SGMII | OCELOT_SPI_PORT_MODE_QSGMII,
+	OCELOT_SPI_PORT_MODE_SGMII | OCELOT_SPI_PORT_MODE_QSGMII,
+	OCELOT_SPI_PORT_MODE_SGMII,
+	OCELOT_SPI_PORT_MODE_SGMII | OCELOT_SPI_PORT_MODE_QSGMII,
+};
+
+struct ocelot_ext_data {
+	struct felix felix;
+	const u32 *port_modes;
+};
+
+static const u32 vsc7512_gcb_regmap[] = {
+	REG(GCB_SOFT_RST,			0x0008),
+	REG(GCB_MIIM_MII_STATUS,		0x009c),
+	REG(GCB_PHY_PHY_CFG,			0x00f0),
+	REG(GCB_PHY_PHY_STAT,			0x00f4),
+};
+
+static const u32 *vsc7512_regmap[TARGET_MAX] = {
+	[ANA] = vsc7514_ana_regmap,
+	[QS] = vsc7514_qs_regmap,
+	[QSYS] = vsc7514_qsys_regmap,
+	[REW] = vsc7514_rew_regmap,
+	[SYS] = vsc7514_sys_regmap,
+	[S0] = vsc7514_vcap_regmap,
+	[S1] = vsc7514_vcap_regmap,
+	[S2] = vsc7514_vcap_regmap,
+	[PTP] = vsc7514_ptp_regmap,
+	[GCB] = vsc7512_gcb_regmap,
+	[DEV_GMII] = vsc7514_dev_gmii_regmap,
+};
+
+#define VSC7512_BYTE_ORDER_LE 0x00000000
+#define VSC7512_BYTE_ORDER_BE 0x81818181
+#define VSC7512_BIT_ORDER_MSB 0x00000000
+#define VSC7512_BIT_ORDER_LSB 0x42424242
+
+static struct ocelot_ext_data *felix_to_ocelot_ext(struct felix *felix)
+{
+	return container_of(felix, struct ocelot_ext_data, felix);
+}
+
+static struct ocelot_ext_data *ocelot_to_ocelot_ext(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	return felix_to_ocelot_ext(felix);
+}
+
+static void ocelot_ext_reset_phys(struct ocelot *ocelot)
+{
+	ocelot_write(ocelot, 0, GCB_PHY_PHY_CFG);
+	ocelot_write(ocelot, 0x1ff, GCB_PHY_PHY_CFG);
+	mdelay(500);
+}
+
+static int ocelot_ext_reset(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct device *dev = ocelot->dev;
+	struct device_node *mdio_node;
+	int retries = 100;
+	int err, val;
+
+	ocelot_ext_reset_phys(ocelot);
+
+	mdio_node = of_get_child_by_name(dev->of_node, "mdio");
+	if (!mdio_node)
+		dev_info(ocelot->dev,
+			 "mdio children not found in device tree\n");
+
+	err = of_mdiobus_register(felix->imdio, mdio_node);
+	if (err) {
+		dev_err(ocelot->dev, "error registering MDIO bus\n");
+		return err;
+	}
+
+	felix->ds->slave_mii_bus = felix->imdio;
+
+	/* We might need to reset the switch core here, if that is possible */
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
+	if (err)
+		return err;
+
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+	if (err)
+		return err;
+
+	do {
+		msleep(1);
+		regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
+				  &val);
+	} while (val && --retries);
+
+	if (!retries)
+		return -ETIMEDOUT;
+
+	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
+
+	return err;
+}
+
+static u32 ocelot_offset_from_reg_base(struct ocelot *ocelot, u32 target,
+				       u32 reg)
+{
+	return ocelot->map[target][reg & REG_MASK];
+}
+
+static const struct ocelot_ops vsc7512_ops = {
+	.reset		= ocelot_ext_reset,
+	.wm_enc		= ocelot_wm_enc,
+	.wm_dec		= ocelot_wm_dec,
+	.wm_stat	= ocelot_wm_stat,
+	.port_to_netdev	= felix_port_to_netdev,
+	.netdev_to_port	= felix_netdev_to_port,
+};
+
+static const struct resource vsc7512_target_io_res[TARGET_MAX] = {
+	[ANA] = {
+		.start	= 0x71880000,
+		.end	= 0x7188ffff,
+		.name	= "ana",
+	},
+	[QS] = {
+		.start	= 0x71080000,
+		.end	= 0x710800ff,
+		.name	= "qs",
+	},
+	[QSYS] = {
+		.start	= 0x71800000,
+		.end	= 0x719fffff,
+		.name	= "qsys",
+	},
+	[REW] = {
+		.start	= 0x71030000,
+		.end	= 0x7103ffff,
+		.name	= "rew",
+	},
+	[SYS] = {
+		.start	= 0x71010000,
+		.end	= 0x7101ffff,
+		.name	= "sys",
+	},
+	[S0] = {
+		.start	= 0x71040000,
+		.end	= 0x710403ff,
+		.name	= "s0",
+	},
+	[S1] = {
+		.start	= 0x71050000,
+		.end	= 0x710503ff,
+		.name	= "s1",
+	},
+	[S2] = {
+		.start	= 0x71060000,
+		.end	= 0x710603ff,
+		.name	= "s2",
+	},
+	[GCB] =	{
+		.start	= 0x71070000,
+		.end	= 0x7107022b,
+		.name	= "devcpu_gcb",
+	},
+};
+
+static const struct resource vsc7512_port_io_res[] = {
+	{
+		.start	= 0x711e0000,
+		.end	= 0x711effff,
+		.name	= "port0",
+	},
+	{
+		.start	= 0x711f0000,
+		.end	= 0x711fffff,
+		.name	= "port1",
+	},
+	{
+		.start	= 0x71200000,
+		.end	= 0x7120ffff,
+		.name	= "port2",
+	},
+	{
+		.start	= 0x71210000,
+		.end	= 0x7121ffff,
+		.name	= "port3",
+	},
+	{
+		.start	= 0x71220000,
+		.end	= 0x7122ffff,
+		.name	= "port4",
+	},
+	{
+		.start	= 0x71230000,
+		.end	= 0x7123ffff,
+		.name	= "port5",
+	},
+	{
+		.start	= 0x71240000,
+		.end	= 0x7124ffff,
+		.name	= "port6",
+	},
+	{
+		.start	= 0x71250000,
+		.end	= 0x7125ffff,
+		.name	= "port7",
+	},
+	{
+		.start	= 0x71260000,
+		.end	= 0x7126ffff,
+		.name	= "port8",
+	},
+	{
+		.start	= 0x71270000,
+		.end	= 0x7127ffff,
+		.name	= "port9",
+	},
+	{
+		.start	= 0x71280000,
+		.end	= 0x7128ffff,
+		.name	= "port10",
+	},
+};
+
+static const struct reg_field vsc7512_regfields[REGFIELD_MAX] = {
+	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 11, 11),
+	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 10),
+	[ANA_ANEVENTS_MSTI_DROP] = REG_FIELD(ANA_ANEVENTS, 27, 27),
+	[ANA_ANEVENTS_ACLKILL] = REG_FIELD(ANA_ANEVENTS, 26, 26),
+	[ANA_ANEVENTS_ACLUSED] = REG_FIELD(ANA_ANEVENTS, 25, 25),
+	[ANA_ANEVENTS_AUTOAGE] = REG_FIELD(ANA_ANEVENTS, 24, 24),
+	[ANA_ANEVENTS_VS2TTL1] = REG_FIELD(ANA_ANEVENTS, 23, 23),
+	[ANA_ANEVENTS_STORM_DROP] = REG_FIELD(ANA_ANEVENTS, 22, 22),
+	[ANA_ANEVENTS_LEARN_DROP] = REG_FIELD(ANA_ANEVENTS, 21, 21),
+	[ANA_ANEVENTS_AGED_ENTRY] = REG_FIELD(ANA_ANEVENTS, 20, 20),
+	[ANA_ANEVENTS_CPU_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 19, 19),
+	[ANA_ANEVENTS_AUTO_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 18, 18),
+	[ANA_ANEVENTS_LEARN_REMOVE] = REG_FIELD(ANA_ANEVENTS, 17, 17),
+	[ANA_ANEVENTS_AUTO_LEARNED] = REG_FIELD(ANA_ANEVENTS, 16, 16),
+	[ANA_ANEVENTS_AUTO_MOVED] = REG_FIELD(ANA_ANEVENTS, 15, 15),
+	[ANA_ANEVENTS_DROPPED] = REG_FIELD(ANA_ANEVENTS, 14, 14),
+	[ANA_ANEVENTS_CLASSIFIED_DROP] = REG_FIELD(ANA_ANEVENTS, 13, 13),
+	[ANA_ANEVENTS_CLASSIFIED_COPY] = REG_FIELD(ANA_ANEVENTS, 12, 12),
+	[ANA_ANEVENTS_VLAN_DISCARD] = REG_FIELD(ANA_ANEVENTS, 11, 11),
+	[ANA_ANEVENTS_FWD_DISCARD] = REG_FIELD(ANA_ANEVENTS, 10, 10),
+	[ANA_ANEVENTS_MULTICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 9, 9),
+	[ANA_ANEVENTS_UNICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 8, 8),
+	[ANA_ANEVENTS_DEST_KNOWN] = REG_FIELD(ANA_ANEVENTS, 7, 7),
+	[ANA_ANEVENTS_BUCKET3_MATCH] = REG_FIELD(ANA_ANEVENTS, 6, 6),
+	[ANA_ANEVENTS_BUCKET2_MATCH] = REG_FIELD(ANA_ANEVENTS, 5, 5),
+	[ANA_ANEVENTS_BUCKET1_MATCH] = REG_FIELD(ANA_ANEVENTS, 4, 4),
+	[ANA_ANEVENTS_BUCKET0_MATCH] = REG_FIELD(ANA_ANEVENTS, 3, 3),
+	[ANA_ANEVENTS_CPU_OPERATION] = REG_FIELD(ANA_ANEVENTS, 2, 2),
+	[ANA_ANEVENTS_DMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 1, 1),
+	[ANA_ANEVENTS_SMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 0, 0),
+	[ANA_TABLES_MACACCESS_B_DOM] = REG_FIELD(ANA_TABLES_MACACCESS, 18, 18),
+	[ANA_TABLES_MACTINDX_BUCKET] = REG_FIELD(ANA_TABLES_MACTINDX, 10, 11),
+	[ANA_TABLES_MACTINDX_M_INDEX] = REG_FIELD(ANA_TABLES_MACTINDX, 0, 9),
+	[GCB_SOFT_RST_SWC_RST] = REG_FIELD(GCB_SOFT_RST, 1, 1),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_VLD] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 20, 20),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_FP] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 8, 19),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_PORTNO] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 4, 7),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_SEL] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 1, 3),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_T] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 0, 0),
+	[SYS_RESET_CFG_CORE_ENA] = REG_FIELD(SYS_RESET_CFG, 2, 2),
+	[SYS_RESET_CFG_MEM_ENA] = REG_FIELD(SYS_RESET_CFG, 1, 1),
+	[SYS_RESET_CFG_MEM_INIT] = REG_FIELD(SYS_RESET_CFG, 0, 0),
+	/* Replicated per number of ports (12), register size 4 per port */
+	[QSYS_SWITCH_PORT_MODE_PORT_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 14, 14, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 11, 13, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_YEL_RSRVD] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 10, 10, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 9, 9, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 1, 8, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 0, 0, 12, 4),
+	[SYS_PORT_MODE_DATA_WO_TS] = REG_FIELD_ID(SYS_PORT_MODE, 5, 6, 12, 4),
+	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 12, 4),
+	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 12, 4),
+	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_START] = REG_FIELD_ID(SYS_PAUSE_CFG, 10, 18, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_STOP] = REG_FIELD_ID(SYS_PAUSE_CFG, 1, 9, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 12, 4),
+};
+
+static const struct ocelot_stat_layout vsc7512_stats_layout[] = {
+	{ .offset = 0x00,	.name = "rx_octets", },
+	{ .offset = 0x01,	.name = "rx_unicast", },
+	{ .offset = 0x02,	.name = "rx_multicast", },
+	{ .offset = 0x03,	.name = "rx_broadcast", },
+	{ .offset = 0x04,	.name = "rx_shorts", },
+	{ .offset = 0x05,	.name = "rx_fragments", },
+	{ .offset = 0x06,	.name = "rx_jabbers", },
+	{ .offset = 0x07,	.name = "rx_crc_align_errs", },
+	{ .offset = 0x08,	.name = "rx_sym_errs", },
+	{ .offset = 0x09,	.name = "rx_frames_below_65_octets", },
+	{ .offset = 0x0A,	.name = "rx_frames_65_to_127_octets", },
+	{ .offset = 0x0B,	.name = "rx_frames_128_to_255_octets", },
+	{ .offset = 0x0C,	.name = "rx_frames_256_to_511_octets", },
+	{ .offset = 0x0D,	.name = "rx_frames_512_to_1023_octets", },
+	{ .offset = 0x0E,	.name = "rx_frames_1024_to_1526_octets", },
+	{ .offset = 0x0F,	.name = "rx_frames_over_1526_octets", },
+	{ .offset = 0x10,	.name = "rx_pause", },
+	{ .offset = 0x11,	.name = "rx_control", },
+	{ .offset = 0x12,	.name = "rx_longs", },
+	{ .offset = 0x13,	.name = "rx_classified_drops", },
+	{ .offset = 0x14,	.name = "rx_red_prio_0", },
+	{ .offset = 0x15,	.name = "rx_red_prio_1", },
+	{ .offset = 0x16,	.name = "rx_red_prio_2", },
+	{ .offset = 0x17,	.name = "rx_red_prio_3", },
+	{ .offset = 0x18,	.name = "rx_red_prio_4", },
+	{ .offset = 0x19,	.name = "rx_red_prio_5", },
+	{ .offset = 0x1A,	.name = "rx_red_prio_6", },
+	{ .offset = 0x1B,	.name = "rx_red_prio_7", },
+	{ .offset = 0x1C,	.name = "rx_yellow_prio_0", },
+	{ .offset = 0x1D,	.name = "rx_yellow_prio_1", },
+	{ .offset = 0x1E,	.name = "rx_yellow_prio_2", },
+	{ .offset = 0x1F,	.name = "rx_yellow_prio_3", },
+	{ .offset = 0x20,	.name = "rx_yellow_prio_4", },
+	{ .offset = 0x21,	.name = "rx_yellow_prio_5", },
+	{ .offset = 0x22,	.name = "rx_yellow_prio_6", },
+	{ .offset = 0x23,	.name = "rx_yellow_prio_7", },
+	{ .offset = 0x24,	.name = "rx_green_prio_0", },
+	{ .offset = 0x25,	.name = "rx_green_prio_1", },
+	{ .offset = 0x26,	.name = "rx_green_prio_2", },
+	{ .offset = 0x27,	.name = "rx_green_prio_3", },
+	{ .offset = 0x28,	.name = "rx_green_prio_4", },
+	{ .offset = 0x29,	.name = "rx_green_prio_5", },
+	{ .offset = 0x2A,	.name = "rx_green_prio_6", },
+	{ .offset = 0x2B,	.name = "rx_green_prio_7", },
+	{ .offset = 0x40,	.name = "tx_octets", },
+	{ .offset = 0x41,	.name = "tx_unicast", },
+	{ .offset = 0x42,	.name = "tx_multicast", },
+	{ .offset = 0x43,	.name = "tx_broadcast", },
+	{ .offset = 0x44,	.name = "tx_collision", },
+	{ .offset = 0x45,	.name = "tx_drops", },
+	{ .offset = 0x46,	.name = "tx_pause", },
+	{ .offset = 0x47,	.name = "tx_frames_below_65_octets", },
+	{ .offset = 0x48,	.name = "tx_frames_65_to_127_octets", },
+	{ .offset = 0x49,	.name = "tx_frames_128_255_octets", },
+	{ .offset = 0x4A,	.name = "tx_frames_256_511_octets", },
+	{ .offset = 0x4B,	.name = "tx_frames_512_1023_octets", },
+	{ .offset = 0x4C,	.name = "tx_frames_1024_1526_octets", },
+	{ .offset = 0x4D,	.name = "tx_frames_over_1526_octets", },
+	{ .offset = 0x4E,	.name = "tx_yellow_prio_0", },
+	{ .offset = 0x4F,	.name = "tx_yellow_prio_1", },
+	{ .offset = 0x50,	.name = "tx_yellow_prio_2", },
+	{ .offset = 0x51,	.name = "tx_yellow_prio_3", },
+	{ .offset = 0x52,	.name = "tx_yellow_prio_4", },
+	{ .offset = 0x53,	.name = "tx_yellow_prio_5", },
+	{ .offset = 0x54,	.name = "tx_yellow_prio_6", },
+	{ .offset = 0x55,	.name = "tx_yellow_prio_7", },
+	{ .offset = 0x56,	.name = "tx_green_prio_0", },
+	{ .offset = 0x57,	.name = "tx_green_prio_1", },
+	{ .offset = 0x58,	.name = "tx_green_prio_2", },
+	{ .offset = 0x59,	.name = "tx_green_prio_3", },
+	{ .offset = 0x5A,	.name = "tx_green_prio_4", },
+	{ .offset = 0x5B,	.name = "tx_green_prio_5", },
+	{ .offset = 0x5C,	.name = "tx_green_prio_6", },
+	{ .offset = 0x5D,	.name = "tx_green_prio_7", },
+	{ .offset = 0x5E,	.name = "tx_aged", },
+	{ .offset = 0x80,	.name = "drop_local", },
+	{ .offset = 0x81,	.name = "drop_tail", },
+	{ .offset = 0x82,	.name = "drop_yellow_prio_0", },
+	{ .offset = 0x83,	.name = "drop_yellow_prio_1", },
+	{ .offset = 0x84,	.name = "drop_yellow_prio_2", },
+	{ .offset = 0x85,	.name = "drop_yellow_prio_3", },
+	{ .offset = 0x86,	.name = "drop_yellow_prio_4", },
+	{ .offset = 0x87,	.name = "drop_yellow_prio_5", },
+	{ .offset = 0x88,	.name = "drop_yellow_prio_6", },
+	{ .offset = 0x89,	.name = "drop_yellow_prio_7", },
+	{ .offset = 0x8A,	.name = "drop_green_prio_0", },
+	{ .offset = 0x8B,	.name = "drop_green_prio_1", },
+	{ .offset = 0x8C,	.name = "drop_green_prio_2", },
+	{ .offset = 0x8D,	.name = "drop_green_prio_3", },
+	{ .offset = 0x8E,	.name = "drop_green_prio_4", },
+	{ .offset = 0x8F,	.name = "drop_green_prio_5", },
+	{ .offset = 0x90,	.name = "drop_green_prio_6", },
+	{ .offset = 0x91,	.name = "drop_green_prio_7", },
+};
+
+static void vsc7512_phylink_validate(struct ocelot *ocelot, int port,
+				     unsigned long *supported,
+				     struct phylink_link_state *state)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	if (state->interface != PHY_INTERFACE_MODE_NA &&
+	    state->interface != ocelot_port->phy_mode) {
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		return;
+	}
+
+	phylink_set_port_modes(mask);
+
+	phylink_set(mask, Pause);
+	phylink_set(mask, Autoneg);
+	phylink_set(mask, Asym_Pause);
+	phylink_set(mask, 10baseT_Half);
+	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 100baseT_Half);
+	phylink_set(mask, 100baseT_Full);
+	phylink_set(mask, 1000baseT_Half);
+	phylink_set(mask, 1000baseT_Full);
+
+	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static int vsc7512_prevalidate_phy_mode(struct ocelot *ocelot, int port,
+					phy_interface_t phy_mode)
+{
+	struct ocelot_ext_data *ocelot_ext = ocelot_to_ocelot_ext(ocelot);
+
+	switch (phy_mode) {
+	case PHY_INTERFACE_MODE_INTERNAL:
+		if (ocelot_ext->port_modes[port] &
+				OCELOT_SPI_PORT_MODE_INTERNAL)
+			return 0;
+		return -EOPNOTSUPP;
+	case PHY_INTERFACE_MODE_SGMII:
+		if (ocelot_ext->port_modes[port] & OCELOT_SPI_PORT_MODE_SGMII)
+			return 0;
+		return -EOPNOTSUPP;
+	case PHY_INTERFACE_MODE_QSGMII:
+		if (ocelot_ext->port_modes[port] & OCELOT_SPI_PORT_MODE_QSGMII)
+			return 0;
+		return -EOPNOTSUPP;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int vsc7512_port_setup_tc(struct dsa_switch *ds, int port,
+				 enum tc_setup_type type, void *type_data)
+{
+	return -EOPNOTSUPP;
+}
+
+static struct vcap_props vsc7512_vcap_props[] = {
+	[VCAP_ES0] = {
+		.action_type_width = 0,
+		.action_table = {
+			[ES0_ACTION_TYPE_NORMAL] = {
+				.width = 73,
+				.count = 1,
+			},
+		},
+		.target = S0,
+		.keys = vsc7514_vcap_es0_keys,
+		.actions = vsc7514_vcap_es0_actions,
+	},
+	[VCAP_IS1] = {
+		.action_type_width = 0,
+		.action_table = {
+			[IS1_ACTION_TYPE_NORMAL] = {
+				.width = 78,
+				.count = 4,
+			},
+		},
+		.target = S1,
+		.keys = vsc7514_vcap_is1_keys,
+		.actions = vsc7514_vcap_is1_actions,
+	},
+	[VCAP_IS2] = {
+		.action_type_width = 1,
+		.action_table = {
+			[IS2_ACTION_TYPE_NORMAL] = {
+				.width = 49,
+				.count = 2,
+			},
+			[IS2_ACTION_TYPE_SMAC_SIP] = {
+				.width = 6,
+				.count = 4,
+			},
+		},
+		.target = S2,
+		.keys = vsc7514_vcap_is2_keys,
+		.actions = vsc7514_vcap_is2_actions,
+	},
+};
+
+static struct regmap *vsc7512_regmap_init(struct ocelot *ocelot,
+					  struct resource *res)
+{
+	struct device *dev = ocelot->dev;
+	struct regmap *regmap;
+
+	regmap = ocelot_get_regmap_from_resource(dev->parent, res);
+	if (IS_ERR(regmap))
+		return ERR_CAST(regmap);
+
+	return regmap;
+}
+
+static int vsc7512_mdio_bus_alloc(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct device *dev = ocelot->dev;
+	u32 mii_offset, phy_offset;
+	struct mii_bus *bus;
+	int err;
+
+	mii_offset = ocelot_offset_from_reg_base(ocelot, GCB,
+						 GCB_MIIM_MII_STATUS);
+
+	phy_offset = ocelot_offset_from_reg_base(ocelot, GCB, GCB_PHY_PHY_CFG);
+
+	err = mscc_miim_setup(dev, &bus, "ocelot_ext MDIO bus",
+			       ocelot->targets[GCB], mii_offset,
+			       ocelot->targets[GCB], phy_offset);
+	if (err) {
+		dev_err(dev, "failed to setup MDIO bus\n");
+		return err;
+	}
+
+	felix->imdio = bus;
+
+	return err;
+}
+
+
+static void vsc7512_mdio_bus_free(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	if (felix->imdio)
+		mdiobus_unregister(felix->imdio);
+}
+
+static const struct felix_info ocelot_ext_info = {
+	.target_io_res			= vsc7512_target_io_res,
+	.port_io_res			= vsc7512_port_io_res,
+	.regfields			= vsc7512_regfields,
+	.map				= vsc7512_regmap,
+	.ops				= &vsc7512_ops,
+	.stats_layout			= vsc7512_stats_layout,
+	.num_stats			= ARRAY_SIZE(vsc7512_stats_layout),
+	.vcap				= vsc7512_vcap_props,
+	.num_mact_rows			= 1024,
+	.num_ports			= VSC7512_NUM_PORTS,
+	.num_tx_queues			= OCELOT_NUM_TC,
+	.mdio_bus_alloc			= vsc7512_mdio_bus_alloc,
+	.mdio_bus_free			= vsc7512_mdio_bus_free,
+	.phylink_validate		= vsc7512_phylink_validate,
+	.prevalidate_phy_mode		= vsc7512_prevalidate_phy_mode,
+	.port_setup_tc			= vsc7512_port_setup_tc,
+	.init_regmap			= vsc7512_regmap_init,
+};
+
+static int ocelot_ext_probe(struct platform_device *pdev)
+{
+	struct ocelot_ext_data *ocelot_ext;
+	struct dsa_switch *ds;
+	struct ocelot *ocelot;
+	struct felix *felix;
+	struct device *dev;
+	int err;
+
+	dev = &pdev->dev;
+
+	ocelot_ext = devm_kzalloc(dev, sizeof(struct ocelot_ext_data),
+				  GFP_KERNEL);
+
+	if (!ocelot_ext)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, ocelot_ext);
+
+	ocelot_ext->port_modes = vsc7512_port_modes;
+	felix = &ocelot_ext->felix;
+
+	ocelot = &felix->ocelot;
+	ocelot->dev = dev;
+
+	ocelot->num_flooding_pgids = 1;
+
+	felix->info = &ocelot_ext_info;
+
+	ds = kzalloc(sizeof(*ds), GFP_KERNEL);
+	if (!ds) {
+		err = -ENOMEM;
+		dev_err(dev, "Failed to allocate DSA switch\n");
+		return err;
+	}
+
+	ds->dev = dev;
+	ds->num_ports = felix->info->num_ports;
+	ds->num_tx_queues = felix->info->num_tx_queues;
+
+	ds->ops = &felix_switch_ops;
+	ds->priv = ocelot;
+	felix->ds = ds;
+	felix->tag_proto = DSA_TAG_PROTO_OCELOT;
+
+	err = dsa_register_switch(ds);
+
+	if (err) {
+		dev_err(dev, "Failed to register DSA switch: %d\n", err);
+		goto err_register_ds;
+	}
+
+	return 0;
+
+err_register_ds:
+	kfree(ds);
+	return err;
+}
+
+static int ocelot_ext_remove(struct platform_device *pdev)
+{
+	struct ocelot_ext_data *ocelot_ext;
+	struct felix *felix;
+
+	ocelot_ext = dev_get_drvdata(&pdev->dev);
+	felix = &ocelot_ext->felix;
+
+	dsa_unregister_switch(felix->ds);
+
+	kfree(felix->ds);
+
+	devm_kfree(&pdev->dev, ocelot_ext);
+
+	return 0;
+}
+
+const struct of_device_id ocelot_ext_switch_of_match[] = {
+	{ .compatible = "mscc,vsc7512-ext-switch" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ocelot_ext_switch_of_match);
+
+static struct platform_driver ocelot_ext_switch_driver = {
+	.driver = {
+		.name = "ocelot-ext-switch",
+		.of_match_table = of_match_ptr(ocelot_ext_switch_of_match),
+	},
+	.probe = ocelot_ext_probe,
+	.remove = ocelot_ext_remove,
+};
+module_platform_driver(ocelot_ext_switch_driver);
+
+MODULE_DESCRIPTION("External Ocelot Switch driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 8b8ebede5a01..62cd61d4142e 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -399,6 +399,8 @@ enum ocelot_reg {
 	GCB_MIIM_MII_STATUS,
 	GCB_MIIM_MII_CMD,
 	GCB_MIIM_MII_DATA,
+	GCB_PHY_PHY_CFG,
+	GCB_PHY_PHY_STAT,
 	DEV_CLOCK_CFG = DEV_GMII << TARGET_OFFSET,
 	DEV_PORT_MISC,
 	DEV_EVENTS,
-- 
2.25.1

