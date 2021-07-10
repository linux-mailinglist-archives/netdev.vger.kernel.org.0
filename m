Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD103C3669
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 21:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhGJT30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 15:29:26 -0400
Received: from mail-bn7nam10on2110.outbound.protection.outlook.com ([40.107.92.110]:51932
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231286AbhGJT3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 15:29:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxCzBYq7DhA5ACJyiEykDYLP2KM49a89+0HrTKUieqrbfZDm0oMTc7s7uRAwX8tuwXDpygU8SBPydmxR0RGMDt3MXRTTTs2ElAz9f1ZdRwxjxmhous+tAM++1WAu4nomoyZVYiHCuOA5ytZT7IPA2yk6zuoeXVdbsmDrpPcoaoBNk6GzshPCY6MACSRJjH6Y1kT+gWzFsqfjKyULQfAr8pJSjVAdn91CHNiaT9mSFamMKw5RZuZDSqkYfSJWgx+vzGnY0+Hv90sDSCNkC8fwvO0hZMj1IUbiHMg/IM/XNGEwS/IeDi4jlB3h7ddXf3qLoy8cxGdhFY3vtj/RQcm1Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yj2QgVgaWHhnroy/hd1RTTPXmhsNSCSjUMHFjDU6ho=;
 b=DG28OtDeepm4jD44zMJIfcoLiBsqpZXU3LZ3pUZn0yugpWIZKp8oOHQGnV5enMgtUmx2QWpvr1po1Y+l7H8D5TXFAxTyO7C32Fc2jaGZcmQz5TqspgpXcWWfCxc6hsplYE3b29bI+LRDBy81bgxhF1FskcVYqJL05xFo7f+BNktDb60CZJhG/AhaOCpc+tRahZ/Ti5GdKRa9f18JcLIgCgvJk2bLh8Dgb1MWKP1OghiCP/SsgxHAaSKeS4ZPTTj0dTTFH8WXdSFZHl31x5E+XQ5/9Dn73ILGJzyQjEwmuUU42SnHy1nDeYsz+rr5h5Cz5G2XaSd1XBtU75UkdhM/aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yj2QgVgaWHhnroy/hd1RTTPXmhsNSCSjUMHFjDU6ho=;
 b=ucoMfyGoNFPLNno+Aup5KGc6lRNgF7tQIPigKF4ifBZOeyWZmGLuxKIpV6+znZ8XKzXLMYQAqL3BfEpESI+In7Z/lZCyAAWVZ7vYj1wlQJ0E7Xw96GIIsG6+r40PEuTcIiruxtG/RdxYOK5m9EKOd3RBCDGYiiUc4Zc6l0i7fuY=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1709.namprd10.prod.outlook.com
 (2603:10b6:301:7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Sat, 10 Jul
 2021 19:26:20 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4287.033; Sat, 10 Jul 2021
 19:26:20 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 net-next 7/8] net: dsa: ocelot: felix: add support for VSC75XX control over SPI
Date:   Sat, 10 Jul 2021 12:26:01 -0700
Message-Id: <20210710192602.2186370-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210710192602.2186370-1-colin.foster@in-advantage.com>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR12CA0042.namprd12.prod.outlook.com
 (2603:10b6:301:2::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MWHPR12CA0042.namprd12.prod.outlook.com (2603:10b6:301:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Sat, 10 Jul 2021 19:26:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9156d6d-4b18-4913-8bbd-08d943d898df
X-MS-TrafficTypeDiagnostic: MWHPR10MB1709:
X-Microsoft-Antispam-PRVS: <MWHPR10MB170952B121D7BEC980AE6305A4179@MWHPR10MB1709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:983;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F/+JVrZ3je+vD6DVyT6EiIZIF8oDmDa85FlYBc0MXIX3qS9s5o5aHVrNavKLz5+zAbiHgMEbbvu5GPnz0jkpjhOiQ0Nw54OEEadoaDd0rFQYSinsyliVRmZWVcfh72UaxLNctBumLxo/bD+WGoXeOB0pB1IgI9dpZfF087nGuB4kT6B3r4TNbAENAGVCq7ML85Zli22uFlOORPc4PKZVBDy6stcRuX21vFnPvOIFqat1o21R26lDrFp49LPMzycMOzqGJ6aYz3I19m+US7So4O2W6HRMOzZMxa+BrLS0B+QoH7GUCRWPCVFuQFcqGfE8A85R3g10gpxlDlHOO35luURxnxhYfm6L74yHOWBHe3ZneI89ZYlOzUQNGI7VqYMEnimCUZSlDfK2kQ5LKVl1TXS2hQsAWLzxbVmo3i/L0zx4uQNF3lEDxMCQaXhOfsSODhY4XrmOxyHDj5aThiHHdbfzh8FfrUS3dSZeOK4f30wT77O6nWZtUrucjgmFphVv8zXIdkHT8nTyq8VC10r59K/NaPnKXEXxKSfe0tvgCYGSGk4JUiLcMAkseMf6GafcFzFIjEsTVyQVTdZUxhSo9GVWBJ4xbfa7vbf8XHqc+p7pa96Dk7MPYE7ZdRzr/TwdS6TuMNZBV5VdNztKikFAjWzVTy7mVvmhelshnmLOPGW0L+S4PWjF4Ogqf1IyldgcjPRTXU5Vlav6uf/f5+C6PIOx+GV6S2Yx1eFjw41pR4I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39830400003)(136003)(366004)(8936002)(7416002)(6506007)(5660300002)(2906002)(66556008)(26005)(2616005)(8676002)(44832011)(6486002)(6512007)(66476007)(6666004)(38100700002)(38350700002)(52116002)(66946007)(921005)(4326008)(956004)(83380400001)(1076003)(316002)(30864003)(36756003)(86362001)(186003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LGIh4ZsLmmIRwRuQ9yfzVmzwSkISWbj1h+eID31y4ELAqqlm4Cn8MjzUZajJ?=
 =?us-ascii?Q?3GGrsgJv2iHYfN1p0iMXebaFgS5CgULbLphw+dyJXXvloo4Q8YUe+IJnq/Zv?=
 =?us-ascii?Q?s7GEsAkk+7Y2PILt5HuqLRjHWh1xfzbvrcPqIdEUz+Q/ezag3K81dNE/g4vE?=
 =?us-ascii?Q?/Kifam/F37zuNlVNOW7Ym5mQom37ycTKhAls1ldifJ4BadYo9HfAEp/OMXSk?=
 =?us-ascii?Q?6o7Ctrg4SGyM3w2U95rhTjysWWAIr5HGlzUntVQCd05ofl9M0avgZ5ITl627?=
 =?us-ascii?Q?M9Qw2LbVr8YCuKtPy+XaWEKbiwB6moVyre3rPsbUV2kd5EBXwqAtly64/DkI?=
 =?us-ascii?Q?A281lc58Z2wSlULcKlPmw0JD5fPVHA6V1Ek5c0olo7WA8WhHPSQvad3vV1Ql?=
 =?us-ascii?Q?nmVDyEEG2+EN3QjFxni6uGKSCl5FFqZnYFlYkp5iPG7wRkHt4apCBppgNKi7?=
 =?us-ascii?Q?YoGKzQuyWG3Crlnzv/W4gT4jwG5u9dEMN8H3DM48m8CmVPcBemRrA0exuIAQ?=
 =?us-ascii?Q?tza7tVwjwTn5E39nE7uok0Frx3MMhGVbFxjV/WMD11COw22zY4fDewWPCoFY?=
 =?us-ascii?Q?aiENMMYdpjh2RpkhzBeKxxTKud9na4ickmKwLBdSLrUV5Ae/uDg2dPtSH5eI?=
 =?us-ascii?Q?cvj3/P/htMeTLrvPTn/61gZplfGUQ0xg+qNaGTuiw4Om37cUd44VNMgWuwTK?=
 =?us-ascii?Q?KIRssRNCywzSy1vIFIBTI4gUSA6hrrazmQDPCj+wcexu61NC1WV6q+Vpuloi?=
 =?us-ascii?Q?GEfZwNvYwBkR8U5C7d21TEYJufMK2Qx973zFZb2HDl8WqEFtT9KSpavrfZUm?=
 =?us-ascii?Q?Hk8yZJOXH6jrMW+HDXzNtuWcQqf+gbYIzuenTGLUTYg59yLiCTPKHBO4+m+i?=
 =?us-ascii?Q?3/TtLPFIAHYcTCKFmw7a/rqD9hFaGXZSnOEdXmRZ0ReConclI2Cl8f+EVEZa?=
 =?us-ascii?Q?30hz9yWh+ppw5PAtIlva9IVtBc8MMmDFNGuoY4ouGOb6TghdRBA2iiNXjF1d?=
 =?us-ascii?Q?tr+wKqm8P01j3cdZhSjtboB09zxSS1dvZOhW64BaTa82aIgYwrnmWEy301IR?=
 =?us-ascii?Q?4ksTu+gra1Iuuun3Pj8wiHi58c5xDfRvCwvWL/ZvKU+i2LxfySRyOQK1JtUs?=
 =?us-ascii?Q?Lkcx+e1d/EXybU0TkQhfxRquVogjtLZNJkb/POv+0b8kEK0Z6TVTZmmWXL5q?=
 =?us-ascii?Q?Ar4C/biICXHEtWbjj8+Bid9V8RYJwenL9lTP8C4DcTb4Wccz/M93xJuMEbN+?=
 =?us-ascii?Q?jMHMQZ40VgV/uj9mM4y2FSi9obtmlvqcsEvhwp9PVjUJ4OGoT1ikJZ/zeZfw?=
 =?us-ascii?Q?E08hal9AaDKfXZwpPXfRy2TQ?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9156d6d-4b18-4913-8bbd-08d943d898df
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2021 19:26:20.8368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tofSgv0CCuBkrK3vDfBHjLlI2JYKN5PXbfaphYBvQXLsQNdxsfc0JZWnWtTRBwPLwjy89Iy9bjKPSnCkbKq8oaC0/6jzuZ3kOHDz9x97Z2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize the Felix and Ocelot drivers to allow control of the VSC7511,
VSC7512, VSC7513 and VAC7514 chips from an external CPU over SPI.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/Kconfig              |   12 +
 drivers/net/dsa/ocelot/Makefile             |    6 +
 drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c | 1068 +++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c          |    8 +
 include/soc/mscc/ocelot.h                   |   19 +
 5 files changed, 1113 insertions(+)
 create mode 100644 drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 932b6b6fe817..4528a0bb0a18 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -14,6 +14,18 @@ config NET_DSA_MSCC_FELIX
 	  This driver supports the VSC9959 (Felix) switch, which is embedded as
 	  a PCIe function of the NXP LS1028A ENETC RCiEP.
 
+config NET_DSA_MSCC_OCELOT_SPI
+	tristate "Ocelot Ethernet SPI switch support"
+	depends on NET_DSA && SPI
+	depends on NET_VENDOR_MICROSEMI
+	select MSCC_OCELOT_SWITCH_LIB
+	select NET_DSA_TAG_OCELOT_8021Q
+	select NET_DSA_TAG_OCELOT
+	help
+	  This driver supports the VSC7511, VSC7512, VSC7513 and VSC7514 chips
+	  when controlled through SPI. It can be used with the Microsemi dev
+	  boards and an external CPU or custom hardware.
+
 config NET_DSA_MSCC_SEVILLE
 	tristate "Ocelot / Seville Ethernet switch support"
 	depends on NET_DSA
diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
index 34b9b128efb8..6ccd5482de7b 100644
--- a/drivers/net/dsa/ocelot/Makefile
+++ b/drivers/net/dsa/ocelot/Makefile
@@ -1,11 +1,17 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_MSCC_FELIX) += mscc_felix.o
+obj-$(CONFIG_NET_DSA_MSCC_OCELOT_SPI) += mscc_ocelot_spi.o
 obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) += mscc_seville.o
 
 mscc_felix-objs := \
 	felix.o \
 	felix_vsc9959.o
 
+mscc_ocelot_spi-objs := \
+	felix.o \
+	felix_mdio.o \
+	ocelot_vsc7512_spi.o
+
 mscc_seville-objs := \
 	felix.o \
 	felix_mdio.o \
diff --git a/drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c b/drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c
new file mode 100644
index 000000000000..5ff028572a5a
--- /dev/null
+++ b/drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c
@@ -0,0 +1,1068 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Copyright 2017 Microsemi Corporation
+ * Copyright 2018-2019 NXP Semiconductors
+ * Copyright 2021 Innovative Advantage Inc.
+ */
+
+#include <asm/byteorder.h>
+#include <linux/spi/spi.h>
+#include <linux/iopoll.h>
+#include <linux/kconfig.h>
+#include <linux/mdio.h>
+#include <soc/mscc/ocelot_qsys.h>
+#include <soc/mscc/ocelot_vcap.h>
+#include <soc/mscc/ocelot_ptp.h>
+#include <soc/mscc/ocelot_regs.h>
+#include <soc/mscc/ocelot_sys.h>
+#include <soc/mscc/ocelot.h>
+#include "felix.h"
+#include "felix_mdio.h"
+
+struct ocelot_spi_data {
+	int spi_padding_bytes;
+	struct felix felix;
+	struct spi_device *spi;
+};
+
+static const u32 vsc7512_dev_cpuorg_regmap[] = {
+	REG(DEV_CPUORG_IF_CTRL,			0x0000),
+	REG(DEV_CPUORG_IF_CFGSTAT,		0x0004),
+	REG(DEV_CPUORG_ORG_CFG,			0x0008),
+	REG(DEV_CPUORG_ERR_CNTS,		0x000c),
+	REG(DEV_CPUORG_TIMEOUT_CFG,		0x0010),
+	REG(DEV_CPUORG_GPR,			0x0014),
+	REG(DEV_CPUORG_MAILBOX_SET,		0x0018),
+	REG(DEV_CPUORG_MAILBOX_CLR,		0x001c),
+	REG(DEV_CPUORG_MAILBOX,			0x0020),
+	REG(DEV_CPUORG_SEMA_CFG,		0x0024),
+	REG(DEV_CPUORG_SEMA0,			0x0028),
+	REG(DEV_CPUORG_SEMA0_OWNER,		0x002c),
+	REG(DEV_CPUORG_SEMA1,			0x0030),
+	REG(DEV_CPUORG_SEMA1_OWNER,		0x0034),
+};
+
+static const u32 vsc7512_gcb_regmap[] = {
+	REG(GCB_SOFT_RST,			0x0008),
+	REG(GCB_MIIM_MII_STATUS,		0x009c),
+	REG(GCB_MIIM_MII_CMD,			0x00a4),
+	REG(GCB_MIIM_MII_DATA,			0x00a8),
+	REG(GCB_PHY_PHY_CFG,			0x00f0),
+	REG(GCB_PHY_PHY_STAT,			0x00f4),
+};
+
+static const u32 *vsc7512_regmap[TARGET_MAX] = {
+	[ANA] = ocelot_ana_regmap,
+	[QS] = ocelot_qs_regmap,
+	[QSYS] = ocelot_qsys_regmap,
+	[REW] = ocelot_rew_regmap,
+	[SYS] = ocelot_sys_regmap,
+	[S0] = ocelot_vcap_regmap,
+	[S1] = ocelot_vcap_regmap,
+	[S2] = ocelot_vcap_regmap,
+	[PTP] = ocelot_ptp_regmap,
+	[GCB] = vsc7512_gcb_regmap,
+	[DEV_GMII] = ocelot_dev_gmii_regmap,
+	[DEV_CPUORG] = vsc7512_dev_cpuorg_regmap,
+};
+
+#define VSC7512_BYTE_ORDER_LE 0x00000000
+#define VSC7512_BYTE_ORDER_BE 0x81818181
+#define VSC7512_BIT_ORDER_MSB 0x00000000
+#define VSC7512_BIT_ORDER_LSB 0x42424242
+
+static void ocelot_spi_reset_phys(struct ocelot *ocelot)
+{
+	ocelot_write(ocelot, 0x1ff, GCB_PHY_PHY_CFG);
+}
+
+struct ocelot_spi_data *felix_to_ocelot_spi(struct felix *felix)
+{
+	return container_of(felix, struct ocelot_spi_data, felix);
+}
+
+struct ocelot_spi_data *ocelot_to_ocelot_spi(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	return felix_to_ocelot_spi(felix);
+}
+
+static int ocelot_spi_init_bus(struct ocelot *ocelot)
+{
+	struct ocelot_spi_data *ocelot_spi;
+	struct spi_device *spi;
+	u32 val, check;
+
+	ocelot_spi = ocelot_to_ocelot_spi(ocelot);
+	spi = ocelot_spi->spi;
+
+	val = 0;
+
+#ifdef __LITTLE_ENDIAN
+	val |= VSC7512_BYTE_ORDER_LE;
+#else
+	val |= VSC7512_BYTE_ORDER_BE;
+#endif
+
+	ocelot_write(ocelot, val, DEV_CPUORG_IF_CTRL);
+
+	val = ocelot_spi->spi_padding_bytes;
+	ocelot_write(ocelot, val, DEV_CPUORG_IF_CFGSTAT);
+
+	check = val | 0x02000000;
+
+	val = ocelot_read(ocelot, DEV_CPUORG_IF_CFGSTAT);
+	if (check != val) {
+		dev_err(&spi->dev,
+			"Error configuring SPI bus. V: 0x%08x != 0x%08x\n", val,
+			check);
+		return -ENODEV;
+	}
+
+	/* The internal copper phys need to be enabled before the mdio bus is
+	 * scanned.
+	 */
+	ocelot_spi_reset_phys(ocelot);
+
+	return 0;
+}
+
+static int vsc7512_reset(struct ocelot *ocelot)
+{
+	int retries = 100;
+	int ret, val;
+
+	ocelot_field_write(ocelot, GCB_SOFT_RST_CHIP_RST, 1);
+
+	/* Note: This is adapted from the PCIe reset strategy. The manual doesn't
+	 * suggest how to do a reset over SPI, and the register strategy isn't
+	 * possible.
+	 */
+	msleep(100);
+
+	ret = ocelot_spi_init_bus(ocelot);
+	if (ret)
+		return ret;
+
+	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
+	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
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
+	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
+
+	return 0;
+}
+
+static int vsc7512_spi_bus_init(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	int rval;
+
+	rval = ocelot_spi_init_bus(ocelot);
+	if (rval) {
+		dev_err(ocelot->dev, "error initializing SPI bus\n");
+		goto clear_mdio;
+	}
+
+	rval = felix_mdio_register(ocelot);
+	if (rval)
+		dev_err(ocelot->dev, "error registering MDIO bus\n");
+
+	felix->ds->slave_mii_bus = felix->imdio;
+
+	return rval;
+
+clear_mdio:
+	felix->imdio = NULL;
+	return rval;
+}
+
+static const struct ocelot_ops vsc7512_ops = {
+	.bus_init	= vsc7512_spi_bus_init,
+	.reset		= vsc7512_reset,
+	.wm_enc		= ocelot_wm_enc,
+	.wm_dec		= ocelot_wm_dec,
+	.wm_stat	= ocelot_wm_stat,
+	.port_to_netdev	= felix_port_to_netdev,
+	.netdev_to_port	= felix_netdev_to_port,
+};
+
+/* Addresses are relative to the SPI device's base address, downshifted by 2*/
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
+		.end	= 0x710701ff,
+		.name	= "devcpu_gcb",
+	},
+	[DEV_CPUORG] = {
+		.start	= 0x71000000,
+		.end	= 0x710003ff,
+		.name	= "devcpu_org",
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
+	[GCB_SOFT_RST_CHIP_RST] = REG_FIELD(GCB_SOFT_RST, 0, 0),
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
+	[GCB_MIIM_MII_STATUS_PENDING] = REG_FIELD(GCB_MIIM_MII_STATUS, 2, 2),
+	[GCB_MIIM_MII_STATUS_BUSY] = REG_FIELD(GCB_MIIM_MII_STATUS, 3, 3),
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
+static unsigned int ocelot_spi_translate_address(unsigned int reg)
+{
+	return cpu_to_be32((reg & 0xffffff) >> 2);
+}
+
+struct ocelot_spi_regmap_context {
+	struct spi_device *spi;
+	u32 base;
+};
+
+static int ocelot_spi_reg_read(void *context, unsigned int reg,
+			       unsigned int *val)
+{
+	struct ocelot_spi_regmap_context *regmap_context = context;
+	struct spi_transfer tx, padding, rx;
+	struct ocelot_spi_data *ocelot_spi;
+	struct spi_message msg;
+	struct spi_device *spi;
+	unsigned int addr;
+	u8 *tx_buf;
+
+	BUG_ON(!val);
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
+	if (ocelot_spi->spi_padding_bytes > 0) {
+		u8 dummy_buf[16] = {0};
+
+		memset(&padding, 0, sizeof(struct spi_transfer));
+
+		/* Just toggle the clock for padding bytes */
+		padding.len = ocelot_spi->spi_padding_bytes;
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
+	phylink_set(mask, Autoneg);
+	phylink_set(mask, Pause);
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
+	switch (phy_mode) {
+	case PHY_INTERFACE_MODE_INTERNAL:
+		if (port < 4)
+			return 0;
+		return -EOPNOTSUPP;
+	case PHY_INTERFACE_MODE_SGMII:
+		if (port < 8)
+			return 0;
+		return -EOPNOTSUPP;
+	case PHY_INTERFACE_MODE_QSGMII:
+		if (port == 7 || port == 8 || port == 10)
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
+static const struct vcap_field vsc7512_vcap_es0_keys[] = {
+	[VCAP_ES0_EGR_PORT]			= { 0,   4 },
+	[VCAP_ES0_IGR_PORT]			= { 4,   4 },
+	[VCAP_ES0_RSV]				= { 8,   2 },
+	[VCAP_ES0_L2_MC]			= { 10,  1 },
+	[VCAP_ES0_L2_BC]			= { 11,  1 },
+	[VCAP_ES0_VID]				= { 12, 12 },
+	[VCAP_ES0_DP]				= { 24,  1 },
+	[VCAP_ES0_PCP]				= { 25,  3 },
+};
+
+static const struct vcap_field vsc7512_vcap_es0_actions[]   = {
+	[VCAP_ES0_ACT_PUSH_OUTER_TAG]		= { 0,   2 },
+	[VCAP_ES0_ACT_PUSH_INNER_TAG]		= { 2,   1 },
+	[VCAP_ES0_ACT_TAG_A_TPID_SEL]		= { 3,   2 },
+	[VCAP_ES0_ACT_TAG_A_VID_SEL]		= { 5,   1 },
+	[VCAP_ES0_ACT_TAG_A_PCP_SEL]		= { 6,   2 },
+	[VCAP_ES0_ACT_TAG_A_DEI_SEL]		= { 8,   2 },
+	[VCAP_ES0_ACT_TAG_B_TPID_SEL]		= { 10,  2 },
+	[VCAP_ES0_ACT_TAG_B_VID_SEL]		= { 12,  1 },
+	[VCAP_ES0_ACT_TAG_B_PCP_SEL]		= { 13,  2 },
+	[VCAP_ES0_ACT_TAG_B_DEI_SEL]		= { 15,  2 },
+	[VCAP_ES0_ACT_VID_A_VAL]		= { 17, 12 },
+	[VCAP_ES0_ACT_PCP_A_VAL]		= { 29,  3 },
+	[VCAP_ES0_ACT_DEI_A_VAL]		= { 32,  1 },
+	[VCAP_ES0_ACT_VID_B_VAL]		= { 33, 12 },
+	[VCAP_ES0_ACT_PCP_B_VAL]		= { 45,  3 },
+	[VCAP_ES0_ACT_DEI_B_VAL]		= { 48,  1 },
+	[VCAP_ES0_ACT_RSV]			= { 49, 24 },
+	[VCAP_ES0_ACT_HIT_STICKY]		= { 73,  1 },
+};
+
+static const struct vcap_field vsc7512_vcap_is1_keys[] = {
+	[VCAP_IS1_HK_TYPE]			= { 0,    1 },
+	[VCAP_IS1_HK_LOOKUP]			= { 1,    2 },
+	[VCAP_IS1_HK_IGR_PORT_MASK]		= { 3,   12 },
+	[VCAP_IS1_HK_RSV]			= { 15,   9 },
+	[VCAP_IS1_HK_OAM_Y1731]			= { 24,   1 },
+	[VCAP_IS1_HK_L2_MC]			= { 25,   1 },
+	[VCAP_IS1_HK_L2_BC]			= { 26,   1 },
+	[VCAP_IS1_HK_IP_MC]			= { 27,   1 },
+	[VCAP_IS1_HK_VLAN_TAGGED]		= { 28,   1 },
+	[VCAP_IS1_HK_VLAN_DBL_TAGGED]		= { 29,   1 },
+	[VCAP_IS1_HK_TPID]			= { 30,   1 },
+	[VCAP_IS1_HK_VID]			= { 31,  12 },
+	[VCAP_IS1_HK_DEI]			= { 43,   1 },
+	[VCAP_IS1_HK_PCP]			= { 44,   3 },
+	/* Specific Fields for IS1 Half Key S1_NORMAL */
+	[VCAP_IS1_HK_L2_SMAC]			= { 47,  48 },
+	[VCAP_IS1_HK_ETYPE_LEN]			= { 95,   1 },
+	[VCAP_IS1_HK_ETYPE]			= { 96,  16 },
+	[VCAP_IS1_HK_IP_SNAP]			= { 112,  1 },
+	[VCAP_IS1_HK_IP4]			= { 113,  1 },
+	/* Layer-3 Information */
+	[VCAP_IS1_HK_L3_FRAGMENT]		= { 114,  1 },
+	[VCAP_IS1_HK_L3_FRAG_OFS_GT0]		= { 115,  1 },
+	[VCAP_IS1_HK_L3_OPTIONS]		= { 116,  1 },
+	[VCAP_IS1_HK_L3_DSCP]			= { 117,  6 },
+	[VCAP_IS1_HK_L3_IP4_SIP]		= { 123, 32 },
+	/* Layer-4 Information */
+	[VCAP_IS1_HK_TCP_UDP]			= { 155,  1 },
+	[VCAP_IS1_HK_TCP]			= { 156,  1 },
+	[VCAP_IS1_HK_L4_SPORT]			= { 157, 16 },
+	[VCAP_IS1_HK_L4_RNG]			= { 173,  8 },
+	/* Specific Fields for IS1 Half Key S1_5TUPLE_IP4 */
+	[VCAP_IS1_HK_IP4_INNER_TPID]		= { 47,   1 },
+	[VCAP_IS1_HK_IP4_INNER_VID]		= { 48,  12 },
+	[VCAP_IS1_HK_IP4_INNER_DEI]		= { 60,   1 },
+	[VCAP_IS1_HK_IP4_INNER_PCP]		= { 61,   3 },
+	[VCAP_IS1_HK_IP4_IP4]			= { 64,   1 },
+	[VCAP_IS1_HK_IP4_L3_FRAGMENT]		= { 65,   1 },
+	[VCAP_IS1_HK_IP4_L3_FRAG_OFS_GT0]	= { 66,   1 },
+	[VCAP_IS1_HK_IP4_L3_OPTIONS]		= { 67,   1 },
+	[VCAP_IS1_HK_IP4_L3_DSCP]		= { 68,   6 },
+	[VCAP_IS1_HK_IP4_L3_IP4_DIP]		= { 74,  32 },
+	[VCAP_IS1_HK_IP4_L3_IP4_SIP]		= { 106, 32 },
+	[VCAP_IS1_HK_IP4_L3_PROTO]		= { 138,  8 },
+	[VCAP_IS1_HK_IP4_TCP_UDP]		= { 146,  1 },
+	[VCAP_IS1_HK_IP4_TCP]			= { 147,  1 },
+	[VCAP_IS1_HK_IP4_L4_RNG]		= { 148,  8 },
+	[VCAP_IS1_HK_IP4_IP_PAYLOAD_S1_5TUPLE]	= { 156, 32 },
+};
+
+static const struct vcap_field vsc7512_vcap_is1_actions[] = {
+	[VCAP_IS1_ACT_DSCP_ENA]			= { 0,   1 },
+	[VCAP_IS1_ACT_DSCP_VAL]			= { 1,   6 },
+	[VCAP_IS1_ACT_QOS_ENA]			= { 7,   1 },
+	[VCAP_IS1_ACT_QOS_VAL]			= { 8,   3 },
+	[VCAP_IS1_ACT_DP_ENA]			= { 11,  1 },
+	[VCAP_IS1_ACT_DP_VAL]			= { 12,  1 },
+	[VCAP_IS1_ACT_PAG_OVERRIDE_MASK]	= { 13,  8 },
+	[VCAP_IS1_ACT_PAG_VAL]			= { 21,  8 },
+	[VCAP_IS1_ACT_RSV]			= { 29,  9 },
+	/* The fields below are incorrectly shifted by 2 in the manual */
+	[VCAP_IS1_ACT_VID_REPLACE_ENA]		= { 38,  1 },
+	[VCAP_IS1_ACT_VID_ADD_VAL]		= { 39, 12 },
+	[VCAP_IS1_ACT_FID_SEL]			= { 51,  2 },
+	[VCAP_IS1_ACT_FID_VAL]			= { 53, 13 },
+	[VCAP_IS1_ACT_PCP_DEI_ENA]		= { 66,  1 },
+	[VCAP_IS1_ACT_PCP_VAL]			= { 67,  3 },
+	[VCAP_IS1_ACT_DEI_VAL]			= { 70,  1 },
+	[VCAP_IS1_ACT_VLAN_POP_CNT_ENA]		= { 71,  1 },
+	[VCAP_IS1_ACT_VLAN_POP_CNT]		= { 72,  2 },
+	[VCAP_IS1_ACT_CUSTOM_ACE_TYPE_ENA]	= { 74,  4 },
+	[VCAP_IS1_ACT_HIT_STICKY]		= { 78,  1 },
+};
+
+static const struct vcap_field vsc7512_vcap_is2_keys[] = {
+	/* Common: 46 bits */
+	[VCAP_IS2_TYPE]				= { 0,    4 },
+	[VCAP_IS2_HK_FIRST]			= { 4,    1 },
+	[VCAP_IS2_HK_PAG]			= { 5,    8 },
+	[VCAP_IS2_HK_IGR_PORT_MASK]		= { 13,  12 },
+	[VCAP_IS2_HK_RSV2]			= { 25,   1 },
+	[VCAP_IS2_HK_HOST_MATCH]		= { 26,   1 },
+	[VCAP_IS2_HK_L2_MC]			= { 27,   1 },
+	[VCAP_IS2_HK_L2_BC]			= { 28,   1 },
+	[VCAP_IS2_HK_VLAN_TAGGED]		= { 29,   1 },
+	[VCAP_IS2_HK_VID]			= { 30,  12 },
+	[VCAP_IS2_HK_DEI]			= { 42,   1 },
+	[VCAP_IS2_HK_PCP]			= { 43,   3 },
+	/* MAC_ETYPE / MAC_LLC / MAC_SNAP / OAM common */
+	[VCAP_IS2_HK_L2_DMAC]			= { 46,  48 },
+	[VCAP_IS2_HK_L2_SMAC]			= { 94,  48 },
+	/* MAC_ETYPE (TYPE=000) */
+	[VCAP_IS2_HK_MAC_ETYPE_ETYPE]		= { 142, 16 },
+	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD0]	= { 158, 16 },
+	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD1]	= { 174,  8 },
+	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD2]	= { 182,  3 },
+	/* MAC_LLC (TYPE=001) */
+	[VCAP_IS2_HK_MAC_LLC_L2_LLC]		= { 142, 40 },
+	/* MAC_SNAP (TYPE=010) */
+	[VCAP_IS2_HK_MAC_SNAP_L2_SNAP]		= { 142, 40 },
+	/* MAC_ARP (TYPE=011) */
+	[VCAP_IS2_HK_MAC_ARP_SMAC]		= { 46,  48 },
+	[VCAP_IS2_HK_MAC_ARP_ADDR_SPACE_OK]	= { 94,   1 },
+	[VCAP_IS2_HK_MAC_ARP_PROTO_SPACE_OK]	= { 95,   1 },
+	[VCAP_IS2_HK_MAC_ARP_LEN_OK]		= { 96,   1 },
+	[VCAP_IS2_HK_MAC_ARP_TARGET_MATCH]	= { 97,   1 },
+	[VCAP_IS2_HK_MAC_ARP_SENDER_MATCH]	= { 98,   1 },
+	[VCAP_IS2_HK_MAC_ARP_OPCODE_UNKNOWN]	= { 99,   1 },
+	[VCAP_IS2_HK_MAC_ARP_OPCODE]		= { 100,  2 },
+	[VCAP_IS2_HK_MAC_ARP_L3_IP4_DIP]	= { 102, 32 },
+	[VCAP_IS2_HK_MAC_ARP_L3_IP4_SIP]	= { 134, 32 },
+	[VCAP_IS2_HK_MAC_ARP_DIP_EQ_SIP]	= { 166,  1 },
+	/* IP4_TCP_UDP / IP4_OTHER common */
+	[VCAP_IS2_HK_IP4]			= { 46,   1 },
+	[VCAP_IS2_HK_L3_FRAGMENT]		= { 47,   1 },
+	[VCAP_IS2_HK_L3_FRAG_OFS_GT0]		= { 48,   1 },
+	[VCAP_IS2_HK_L3_OPTIONS]		= { 49,   1 },
+	[VCAP_IS2_HK_IP4_L3_TTL_GT0]		= { 50,   1 },
+	[VCAP_IS2_HK_L3_TOS]			= { 51,   8 },
+	[VCAP_IS2_HK_L3_IP4_DIP]		= { 59,  32 },
+	[VCAP_IS2_HK_L3_IP4_SIP]		= { 91,  32 },
+	[VCAP_IS2_HK_DIP_EQ_SIP]		= { 123,  1 },
+	/* IP4_TCP_UDP (TYPE=100) */
+	[VCAP_IS2_HK_TCP]			= { 124,  1 },
+	[VCAP_IS2_HK_L4_DPORT]			= { 125, 16 },
+	[VCAP_IS2_HK_L4_SPORT]			= { 141, 16 },
+	[VCAP_IS2_HK_L4_RNG]			= { 157,  8 },
+	[VCAP_IS2_HK_L4_SPORT_EQ_DPORT]		= { 165,  1 },
+	[VCAP_IS2_HK_L4_SEQUENCE_EQ0]		= { 166,  1 },
+	[VCAP_IS2_HK_L4_FIN]			= { 167,  1 },
+	[VCAP_IS2_HK_L4_SYN]			= { 168,  1 },
+	[VCAP_IS2_HK_L4_RST]			= { 169,  1 },
+	[VCAP_IS2_HK_L4_PSH]			= { 170,  1 },
+	[VCAP_IS2_HK_L4_ACK]			= { 171,  1 },
+	[VCAP_IS2_HK_L4_URG]			= { 172,  1 },
+	[VCAP_IS2_HK_L4_1588_DOM]		= { 173,  8 },
+	[VCAP_IS2_HK_L4_1588_VER]		= { 181,  4 },
+	/* IP4_OTHER (TYPE=101) */
+	[VCAP_IS2_HK_IP4_L3_PROTO]		= { 124,  8 },
+	[VCAP_IS2_HK_L3_PAYLOAD]		= { 132, 56 },
+	/* IP6_STD (TYPE=110) */
+	[VCAP_IS2_HK_IP6_L3_TTL_GT0]		= { 46,   1 },
+	[VCAP_IS2_HK_L3_IP6_SIP]		= { 47, 128 },
+	[VCAP_IS2_HK_IP6_L3_PROTO]		= { 175,  8 },
+	/* OAM (TYPE=111) */
+	[VCAP_IS2_HK_OAM_MEL_FLAGS]		= { 142,  7 },
+	[VCAP_IS2_HK_OAM_VER]			= { 149,  5 },
+	[VCAP_IS2_HK_OAM_OPCODE]		= { 154,  8 },
+	[VCAP_IS2_HK_OAM_FLAGS]			= { 162,  8 },
+	[VCAP_IS2_HK_OAM_MEPID]			= { 170, 16 },
+	[VCAP_IS2_HK_OAM_CCM_CNTS_EQ0]		= { 186,  1 },
+	[VCAP_IS2_HK_OAM_IS_Y1731]		= { 187,  1 },
+};
+
+static const struct vcap_field vsc7512_vcap_is2_actions[] = {
+	[VCAP_IS2_ACT_HIT_ME_ONCE]		= { 0,   1 },
+	[VCAP_IS2_ACT_CPU_COPY_ENA]		= { 1,   1 },
+	[VCAP_IS2_ACT_CPU_QU_NUM]		= { 2,   3 },
+	[VCAP_IS2_ACT_MASK_MODE]		= { 5,   2 },
+	[VCAP_IS2_ACT_MIRROR_ENA]		= { 7,   1 },
+	[VCAP_IS2_ACT_LRN_DIS]			= { 8,   1 },
+	[VCAP_IS2_ACT_POLICE_ENA]		= { 9,   1 },
+	[VCAP_IS2_ACT_POLICE_IDX]		= { 10,  9 },
+	[VCAP_IS2_ACT_POLICE_VCAP_ONLY]		= { 19,  1 },
+	[VCAP_IS2_ACT_PORT_MASK]		= { 20, 11 },
+	[VCAP_IS2_ACT_REW_OP]			= { 31,  9 },
+	[VCAP_IS2_ACT_SMAC_REPLACE_ENA]		= { 40,  1 },
+	[VCAP_IS2_ACT_RSV]			= { 41,  2 },
+	[VCAP_IS2_ACT_ACL_ID]			= { 43,  6 },
+	[VCAP_IS2_ACT_HIT_CNT]			= { 49, 32 },
+};
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
+		.keys = vsc7512_vcap_es0_keys,
+		.actions = vsc7512_vcap_es0_actions,
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
+		.keys = vsc7512_vcap_is1_keys,
+		.actions = vsc7512_vcap_is1_actions,
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
+		.keys = vsc7512_vcap_is2_keys,
+		.actions = vsc7512_vcap_is2_actions,
+	},
+};
+
+static struct regmap *vsc7512_regmap_init(struct ocelot *ocelot,
+					  struct resource *res)
+{
+	struct ocelot_spi_regmap_context *context;
+	struct regmap_config regmap_config;
+	struct ocelot_spi_data *ocelot_spi;
+	struct regmap *regmap;
+	struct device *dev;
+	char name[32];
+
+	ocelot_spi = ocelot_to_ocelot_spi(ocelot);
+	dev = &ocelot_spi->spi->dev;
+
+	context = devm_kzalloc(dev, sizeof(struct ocelot_spi_regmap_context),
+			       GFP_KERNEL);
+
+	if (IS_ERR(context))
+		return ERR_CAST(context);
+
+	context->base = res->start;
+	context->spi = ocelot_spi->spi;
+
+	memcpy(&regmap_config, &ocelot_spi_regmap_config,
+	       sizeof(ocelot_spi_regmap_config));
+
+	/* A unique bus name is required for each regmap */
+	if (res->name)
+		snprintf(name, sizeof(name) - 1, "ocelot_spi-%s", res->name);
+	else
+		snprintf(name, sizeof(name) - 1, "ocelot_spi@0x%08x",
+			 res->start);
+
+	regmap_config.name = name;
+	regmap_config.max_register = res->end - res->start;
+
+	regmap = devm_regmap_init(dev, NULL, context, &regmap_config);
+
+	if (IS_ERR(regmap))
+		return ERR_CAST(regmap);
+
+	return regmap;
+}
+
+static const struct felix_info ocelot_spi_info = {
+	.target_io_res			= vsc7512_target_io_res,
+	.port_io_res			= vsc7512_port_io_res,
+	.regfields			= vsc7512_regfields,
+	.map				= vsc7512_regmap,
+	.ops				= &vsc7512_ops,
+	.stats_layout			= vsc7512_stats_layout,
+	.num_stats			= ARRAY_SIZE(vsc7512_stats_layout),
+	.vcap				= vsc7512_vcap_props,
+	.num_mact_rows			= 1024,
+
+	/* The 7512 and 7514 both have support for up to 10 ports. The 7511 and
+	 * 7513 have support for 4. Due to lack of hardware to test and
+	 * validate external phys, this is currently limited to 4 ports.
+	 * Expanding this to 10 for the 7512 and 7514 and defining the
+	 * appropriate phy-handle values in the device tree should be possible.
+	 */
+	.num_ports			= 4,
+	.num_tx_queues			= OCELOT_NUM_TC,
+	.mdio_bus_alloc			= felix_mdio_bus_alloc,
+	.mdio_bus_free			= felix_mdio_bus_free,
+	.phylink_validate		= vsc7512_phylink_validate,
+	.prevalidate_phy_mode		= vsc7512_prevalidate_phy_mode,
+	.port_setup_tc			= vsc7512_port_setup_tc,
+	.init_regmap			= vsc7512_regmap_init,
+};
+
+static int ocelot_spi_probe(struct spi_device *spi)
+{
+	struct ocelot_spi_data *ocelot_spi;
+	struct dsa_switch *ds;
+	struct ocelot *ocelot;
+	struct felix *felix;
+	struct device *dev;
+	int err;
+
+	dev = &spi->dev;
+
+	ocelot_spi = devm_kzalloc(dev, sizeof(struct ocelot_spi_data),
+				  GFP_KERNEL);
+
+	if (!ocelot_spi)
+		return -ENOMEM;
+
+	if (spi->max_speed_hz <= 500000) {
+		ocelot_spi->spi_padding_bytes = 0;
+	} else {
+		/* Calculation taken from the manual for IF_CFGSTAT:IF_CFG. Err
+		 * on the side of more padding bytes, as having too few can be
+		 * difficult to detect at runtime.
+		 */
+		ocelot_spi->spi_padding_bytes = 1 +
+			(spi->max_speed_hz / 1000000 + 2) / 8;
+	}
+
+	dev_set_drvdata(dev, ocelot_spi);
+	ocelot_spi->spi = spi;
+
+	spi->bits_per_word = 8;
+
+	err = spi_setup(spi);
+	if (err < 0) {
+		dev_err(&spi->dev, "Error %d initializing SPI\n", err);
+		return err;
+	}
+
+	felix = &ocelot_spi->felix;
+
+	ocelot = &felix->ocelot;
+	ocelot->dev = dev;
+
+	/* Not sure about this */
+	ocelot->num_flooding_pgids = 1;
+
+	felix->info = &ocelot_spi_info;
+
+	ds = kzalloc(sizeof(*ds), GFP_KERNEL);
+	if (!ds) {
+		err = -ENOMEM;
+		dev_err(dev, "Failed to allocate DSA switch\n");
+		return err;
+	}
+
+	ds->dev = &spi->dev;
+	ds->num_ports = felix->info->num_ports;
+	ds->num_tx_queues = felix->info->num_tx_queues;
+	ds->ops = &felix_switch_ops;
+	ds->priv = ocelot;
+	felix->ds = ds;
+
+	err = dsa_register_switch(ds);
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
+static int ocelot_spi_remove(struct spi_device *spi)
+{
+	struct ocelot_spi_data *ocelot_spi;
+	struct felix *felix;
+
+	ocelot_spi = spi_get_drvdata(spi);
+	felix = &ocelot_spi->felix;
+
+	dsa_unregister_switch(felix->ds);
+
+	kfree(felix->ds);
+
+	devm_kfree(&spi->dev, ocelot_spi);
+
+	return 0;
+}
+
+const struct of_device_id vsc7512_of_match[] = {
+	{ .compatible = "mscc,vsc7514" },
+	{ .compatible = "mscc,vsc7513" },
+	{ .compatible = "mscc,vsc7512" },
+	{ .compatible = "mscc,vsc7511" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, vsc7512_of_match);
+
+static struct spi_driver ocelot_vsc7512_spi_driver = {
+	.driver = {
+		.name = "vsc7512",
+		.of_match_table = of_match_ptr(vsc7512_of_match),
+	},
+	.probe = ocelot_spi_probe,
+	.remove = ocelot_spi_remove,
+};
+module_spi_driver(ocelot_vsc7512_spi_driver);
+
+MODULE_DESCRIPTION("Ocelot Switch SPI driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index adfb9781799e..10937dc59fce 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2016,6 +2016,14 @@ int ocelot_init(struct ocelot *ocelot)
 	int i, ret;
 	u32 port;
 
+	if (ocelot->ops->bus_init) {
+		ret = ocelot->ops->bus_init(ocelot);
+		if (ret) {
+			dev_err(ocelot->dev, "Bus init failed\n");
+			return ret;
+		}
+	}
+
 	if (ocelot->ops->reset) {
 		ret = ocelot->ops->reset(ocelot);
 		if (ret) {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index ff6e65a266d6..f5383804e724 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -129,6 +129,7 @@ enum ocelot_target {
 	PTP,
 	GCB,
 	DEV_GMII,
+	DEV_CPUORG,
 	TARGET_MAX,
 };
 
@@ -407,6 +408,8 @@ enum ocelot_reg {
 	GCB_MIIM_MII_STATUS,
 	GCB_MIIM_MII_CMD,
 	GCB_MIIM_MII_DATA,
+	GCB_PHY_PHY_CFG,
+	GCB_PHY_PHY_STAT,
 	DEV_CLOCK_CFG = DEV_GMII << TARGET_OFFSET,
 	DEV_PORT_MISC,
 	DEV_EVENTS,
@@ -446,6 +449,20 @@ enum ocelot_reg {
 	PCS1G_TSTPAT_STATUS,
 	DEV_PCS_FX100_CFG,
 	DEV_PCS_FX100_STATUS,
+	DEV_CPUORG_IF_CTRL = DEV_CPUORG << TARGET_OFFSET,
+	DEV_CPUORG_IF_CFGSTAT,
+	DEV_CPUORG_ORG_CFG,
+	DEV_CPUORG_ERR_CNTS,
+	DEV_CPUORG_TIMEOUT_CFG,
+	DEV_CPUORG_GPR,
+	DEV_CPUORG_MAILBOX_SET,
+	DEV_CPUORG_MAILBOX_CLR,
+	DEV_CPUORG_MAILBOX,
+	DEV_CPUORG_SEMA_CFG,
+	DEV_CPUORG_SEMA0,
+	DEV_CPUORG_SEMA0_OWNER,
+	DEV_CPUORG_SEMA1,
+	DEV_CPUORG_SEMA1_OWNER,
 };
 
 enum ocelot_regfield {
@@ -504,6 +521,7 @@ enum ocelot_regfield {
 	SYS_RESET_CFG_MEM_ENA,
 	SYS_RESET_CFG_MEM_INIT,
 	GCB_SOFT_RST_SWC_RST,
+	GCB_SOFT_RST_CHIP_RST,
 	GCB_MIIM_MII_STATUS_PENDING,
 	GCB_MIIM_MII_STATUS_BUSY,
 	SYS_PAUSE_CFG_PAUSE_START,
@@ -560,6 +578,7 @@ struct ocelot;
 struct ocelot_ops {
 	struct net_device *(*port_to_netdev)(struct ocelot *ocelot, int port);
 	int (*netdev_to_port)(struct net_device *dev);
+	int (*bus_init)(struct ocelot *ocelot);
 	int (*reset)(struct ocelot *ocelot);
 	u16 (*wm_enc)(u16 value);
 	u16 (*wm_dec)(u16 value);
-- 
2.25.1

