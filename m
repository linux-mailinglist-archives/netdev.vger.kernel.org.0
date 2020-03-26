Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90D3819407A
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 14:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgCZNwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 09:52:34 -0400
Received: from mail-eopbgr60089.outbound.protection.outlook.com ([40.107.6.89]:57111
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727733AbgCZNwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 09:52:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbIaKmFpxWybnXif/pUabYu75+kHvv5cXc8Tkj0+NC79tLVt8qf7dwQX1vrwd9B3ybqLbgJlYKKcrDn6tO1sCW1oF8vqIzINoc2ozOkQhxJAUSwZD8dauvf7VfpEn/knSzNR5UAH2p7WFlkkAblaMAjdkMnnbrikrfFqJdguSumNEQO5svK3/bdwgFcVXY7Ln4eoJb0NMOE42oMobJfurbfbvxA5fLSHtdWvDWaEFDSue0sZn4txUO+k+ggXZtvX0V5s766KQOAvIeBS5/7AyUrcu01vKp56S8I7Yd6Pw4Hr8JjvHc08W1EcV7XXqzglUKcBtXhrQ1TNkuBhbXpX5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4UM+jO7/Y+hKjL377Mm1nilPThbE8dmXjZPI7dybpU=;
 b=a8n7uDk/ESA3qRLulplPk1xHDyYuI5s+pJIwDwkGR243diRX5zfD7wukTNvNXOt/mdfTmE4ItcgIFtwkKowK/ZpyWAS9Nme7g/MotjxB75DclDXFwV1bEAlgBIDiaOnCHAf8mphFrmkChOkd9AU7yHUWb7t76ESgNlZij9Ac/g5zXtCZTn+i6+WNmNgnhc4Yb4ad/MW+Ecxw/EdmDi31L0t+ASuPi9YTnZK//4irGZG6yCUAjouG+3fP9OQmdTM+APajBGHDA03BJqsUhSdeIlto6Onz/QSLM9e1qv2EpQDMfuZrQTMcXtXTirjX3D/GKCQYXetQD4CQjyjuzIdm+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4UM+jO7/Y+hKjL377Mm1nilPThbE8dmXjZPI7dybpU=;
 b=O4U98BTtuvc8s5ZiOoH6JxMEQpQLZXJGAFuAE797fUOvHHV0NeoLqBUT/e2BIJaa9OcdGMbmYEqEVNHyPCmsNcM12IjS0jRn37dlVq8aJ1HEIb0Y34iniLbowLBqsRGD4LWI9xbfFDUHpAr4/K1jFYLLRiElWrZEhyqma99fA1E=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com (20.178.122.87) by
 VI1PR04MB4272.eurprd04.prod.outlook.com (10.171.182.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Thu, 26 Mar 2020 13:52:12 +0000
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8]) by VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8%3]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 13:52:12 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next 6/9] net: phy: add backplane kr driver support
Date:   Thu, 26 Mar 2020 15:51:19 +0200
Message-Id: <1585230682-24417-7-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0142.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::47) To VI1PR04MB5454.eurprd04.prod.outlook.com
 (2603:10a6:803:d1::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (89.37.124.34) by AM0PR01CA0142.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2835.20 via Frontend Transport; Thu, 26 Mar 2020 13:52:11 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [89.37.124.34]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9ecc01e6-9461-4fe3-6abb-08d7d18ce2b0
X-MS-TrafficTypeDiagnostic: VI1PR04MB4272:|VI1PR04MB4272:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB427214D5929ABD12E7BD7858FBCF0@VI1PR04MB4272.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(26005)(478600001)(186003)(16526019)(956004)(81166006)(3450700001)(36756003)(81156014)(8936002)(44832011)(4326008)(8676002)(5660300002)(2616005)(7416002)(2906002)(66946007)(86362001)(6486002)(30864003)(66556008)(316002)(6506007)(6512007)(66476007)(52116002)(579004)(559001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4272;H:VI1PR04MB5454.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r+5uHRSBUO0jcgTrPSkP1zRIKS4cvK9gHm2y6zo6qysktwLrqiwjzmCoLn74caXKDtL/uFKQPthlRh2bDf37NuJYJvXds65G9SyIzyTQ+rA5nSSm2c9n/O2wkPx9M8Joc+KEGx+O7DOV8d1e1O0TKpsfEaDjRhOF1UJ0pQpvx8YC8SnJfUQzP66fgjaJMiWVTU0725vNh01My7Rvk/2f4VU9v4h6Z3RG+Yv4NCyBhr8hdYJhsKtORR/x+YqCdw5F4nELBDU0cKIM5X/PwZTTM+Lj6koG4A2u6hJTAqVWc0dJVVBMwrjCopQByq9/1cUMoPSQbVl4bpI5SXq60iMxClFD8VFczG6MmDEeY2AM0tLLVu6y+fhV20P2gq2ZtLEPB0nnMhjgRZ+0axZ9alJsSwBEyMPjTlL0+K84P5NJmXsInTWtQKfxESl+eU92LTjI
X-MS-Exchange-AntiSpam-MessageData: XgCrfxyh8/eg9+tbfh1VQg9Xg6l+YRIYLGz11R8O685QDFZFafrIlIZpa4sAvjnn9vF6pqdZ/CKn1YB5oqTT8jJwz1ArF9Qw5lLGCbhTu9tTIu0mbT/JfUpLSaKyAKaGFEBGkMUTzV7aqvGoFkGZ0w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ecc01e6-9461-4fe3-6abb-08d7d18ce2b0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 13:52:12.7642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HDRVFaVMHnbK453d+t9WwUKybodzNsSxvePPrwUPNIcEMMUVRzyg89RH7Ml/xnwMBEUVohq/6KpxODc8ygctzitDiaft/hhK5eE/JgXqCV0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4272
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for backplane kr generic driver including link training
(ieee802.3ap/ba) and fixed equalization algorithm

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/phy/Kconfig                   |    2 +
 drivers/net/phy/Makefile                  |    1 +
 drivers/net/phy/backplane/Kconfig         |   20 +
 drivers/net/phy/backplane/Makefile        |    9 +
 drivers/net/phy/backplane/backplane.c     | 1538 +++++++++++++++++++++++++++
 drivers/net/phy/backplane/backplane.h     |  262 +++++
 drivers/net/phy/backplane/eq_fixed.c      |   83 ++
 drivers/net/phy/backplane/equalization.h  |  282 +++++
 drivers/net/phy/backplane/link_training.c | 1604 +++++++++++++++++++++++++++++
 drivers/net/phy/backplane/link_training.h |   34 +
 10 files changed, 3835 insertions(+)
 create mode 100644 drivers/net/phy/backplane/Kconfig
 create mode 100644 drivers/net/phy/backplane/Makefile
 create mode 100644 drivers/net/phy/backplane/backplane.c
 create mode 100644 drivers/net/phy/backplane/backplane.h
 create mode 100644 drivers/net/phy/backplane/eq_fixed.c
 create mode 100644 drivers/net/phy/backplane/equalization.h
 create mode 100644 drivers/net/phy/backplane/link_training.c
 create mode 100644 drivers/net/phy/backplane/link_training.h

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index cc7f1df..abab4e5 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -523,6 +523,8 @@ config XILINX_GMII2RGMII
 	  the Reduced Gigabit Media Independent Interface(RGMII) between
 	  Ethernet physical media devices and the Gigabit Ethernet controller.
 
+source "drivers/net/phy/backplane/Kconfig"
+
 endif # PHYLIB
 
 config MICREL_KS8995MA
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 70774ab..0b867fb 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -101,3 +101,4 @@ obj-$(CONFIG_STE10XP)		+= ste10Xp.o
 obj-$(CONFIG_TERANETICS_PHY)	+= teranetics.o
 obj-$(CONFIG_VITESSE_PHY)	+= vitesse.o
 obj-$(CONFIG_XILINX_GMII2RGMII) += xilinx_gmii2rgmii.o
+obj-$(CONFIG_ETH_BACKPLANE)	+= backplane/
diff --git a/drivers/net/phy/backplane/Kconfig b/drivers/net/phy/backplane/Kconfig
new file mode 100644
index 0000000..9ec54b5
--- /dev/null
+++ b/drivers/net/phy/backplane/Kconfig
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+config ETH_BACKPLANE
+	tristate "Ethernet Backplane support"
+	depends on OF_MDIO
+	help
+	  This module provides driver support for Ethernet Operation over
+	  Electrical Backplanes. It includes Backplane generic
+	  driver including support for Link Training (IEEE802.3ap/ba).
+	  Based on the link quality, a signal equalization is required.
+	  The standard specifies that a start-up algorithm should be in place
+	  in order to get the link up.
+
+config ETH_BACKPLANE_FIXED
+	tristate "Fixed: No Equalization algorithm"
+	depends on ETH_BACKPLANE
+	help
+	  This module provides a driver to setup fixed user configurable
+	  coefficient values for backplanes equalization. This means
+	  No Equalization algorithm is used to adapt the initial coefficients
+	  initially set by the user.
\ No newline at end of file
diff --git a/drivers/net/phy/backplane/Makefile b/drivers/net/phy/backplane/Makefile
new file mode 100644
index 0000000..ded6f2d
--- /dev/null
+++ b/drivers/net/phy/backplane/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+#
+# Makefile for Ethernet Backplane driver
+#
+
+obj-$(CONFIG_ETH_BACKPLANE) += eth_backplane.o
+obj-$(CONFIG_ETH_BACKPLANE_FIXED) += eq_fixed.o
+
+eth_backplane-objs	:= backplane.o link_training.o
diff --git a/drivers/net/phy/backplane/backplane.c b/drivers/net/phy/backplane/backplane.c
new file mode 100644
index 0000000..1b580bc
--- /dev/null
+++ b/drivers/net/phy/backplane/backplane.c
@@ -0,0 +1,1538 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Backplane driver
+ *
+ * Copyright 2015 Freescale Semiconductor, Inc.
+ * Copyright 2018-2020 NXP
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mii.h>
+#include <linux/mdio.h>
+#include <linux/ethtool.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_net.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/timer.h>
+#include <linux/delay.h>
+#include <linux/workqueue.h>
+#include <linux/netdevice.h>
+#include <linux/list.h>
+
+#include "backplane.h"
+#include "link_training.h"
+
+/* KR timeouts in milliseconds */
+#define KR_TIMEOUT_1				100
+#define KR_TIMEOUT_2				1000
+#define KR_DENY_RT_INTERVAL			3000
+#define KR_LT_TIMEOUT				500
+
+/* KR timings in interations */
+#define KR_AN_WAIT_ITERATIONS			5
+#define KR_TRAIN_STEP_ITERATIONS		2
+#define CDR_LOCK_RETRY_COUNT			3
+
+/* AN status register (Clause 45) (MMD 7): MDIO_STAT1 */
+#define AN_LINK_UP_MASK				0x04
+
+/* Logging buffer size */
+#define LOG_BUFFER_SIZE				200
+
+/* Backplane custom logging */
+#define BPDEV_LOG(name) \
+	char log_buffer[LOG_BUFFER_SIZE]; \
+	va_list args; va_start(args, msg); \
+	vsnprintf(log_buffer, LOG_BUFFER_SIZE - 1, msg, args); \
+	if (!bpphy->attached_dev) \
+		dev_##name(&bpphy->mdio.dev, log_buffer); \
+	else \
+		dev_##name(&bpphy->mdio.dev, "%s: %s", \
+			netdev_name(bpphy->attached_dev), log_buffer); \
+	va_end(args)
+
+/* Backplane features */
+__ETHTOOL_DECLARE_LINK_MODE_MASK(backplane_features) __ro_after_init;
+EXPORT_SYMBOL(backplane_features);
+
+const int backplane_common_features_array[] = {
+	ETHTOOL_LINK_MODE_Backplane_BIT,
+	ETHTOOL_LINK_MODE_Autoneg_BIT,
+	ETHTOOL_LINK_MODE_MII_BIT,
+};
+
+const int backplane_protocol_features_array[] = {
+	ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+	ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
+};
+
+/* map string key to pointer data */
+struct spmap_node {
+	struct list_head entry;
+	const char *key;
+	void *pdata;
+};
+
+/* registered equalization algorithms info */
+static LIST_HEAD(eqalg_list);
+
+/* lanes attached to an equalization algorithm */
+static LIST_HEAD(lnalg_list);
+
+/* Backplane mutex between all KR PHY threads */
+static struct mutex backplane_lock;
+
+static int get_backplane_speed(phy_interface_t bp_mode)
+{
+	switch (bp_mode) {
+	case PHY_INTERFACE_MODE_10GKR:
+		return SPEED_10000;
+	case PHY_INTERFACE_MODE_40GKR4:
+		return SPEED_40000;
+	default:
+		pr_err("%s: Unsupported backplane phy interface\n",
+		       BACKPLANE_DRIVER_NAME);
+		return SPEED_UNKNOWN;
+	}
+	return SPEED_UNKNOWN;
+}
+
+static enum ethtool_link_mode_bit_indices
+	get_backplane_supported_mode(phy_interface_t bp_mode)
+{
+	switch (bp_mode) {
+	case PHY_INTERFACE_MODE_10GKR:
+		return ETHTOOL_LINK_MODE_10000baseKR_Full_BIT;
+	case PHY_INTERFACE_MODE_40GKR4:
+		return ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT;
+	default:
+		pr_err("%s: Unsupported backplane phy interface\n",
+		       BACKPLANE_DRIVER_NAME);
+		return ETHTOOL_LINK_MODE_Backplane_BIT;
+	}
+	return ETHTOOL_LINK_MODE_Backplane_BIT;
+}
+
+static int spmap_add(struct list_head *list, const char *key, void *pdata)
+{
+	struct spmap_node *node;
+
+	/* create a new entry with desired key */
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return -ENOMEM;
+
+	node->key = key;
+	node->pdata = pdata;
+
+	list_add(&node->entry, list);
+
+	return 0;
+}
+
+static const struct equalization_algorithm *eq_find(const char *key)
+{
+	struct spmap_node *eqalg, *eqalg_tmp;
+
+	if (!key)
+		return NULL;
+
+	/* search desired single key */
+	list_for_each_entry_safe(eqalg, eqalg_tmp, &eqalg_list, entry) {
+		if (strcmp(eqalg->key, key) == 0)
+			return (struct equalization_algorithm *)eqalg->pdata;
+	}
+	return NULL;
+}
+
+static void backplane_features_init(void)
+{
+	linkmode_set_bit_array(backplane_common_features_array,
+			       ARRAY_SIZE(backplane_common_features_array),
+			       backplane_features);
+
+	linkmode_set_bit_array(backplane_protocol_features_array,
+			       ARRAY_SIZE(backplane_protocol_features_array),
+			       backplane_features);
+}
+
+static u32 le_ioread32(void __iomem *reg)
+{
+	return ioread32(reg);
+}
+
+static void le_iowrite32(u32 value, void __iomem *reg)
+{
+	iowrite32(value, reg);
+}
+
+static u32 be_ioread32(void __iomem *reg)
+{
+	return ioread32be(reg);
+}
+
+static void be_iowrite32(u32 value, void __iomem *reg)
+{
+	iowrite32be(value, reg);
+}
+
+static void training_status_init(struct training_status *trst)
+{
+	trst->done_training = false;
+	trst->remote_tx_complete = false;
+	trst->remote_tx_running = false;
+	trst->sent_init = false;
+	trst->lp_rx_ready = 0;
+	trst->local_tx_running = false;
+}
+
+static void init_krln(struct kr_lane_info *krln, bool revert_default)
+{
+	if (revert_default)
+		backplane_default_kr_lane(krln);
+
+	training_status_init(&krln->trst);
+	krln->state = DETECTING_LP;
+	krln->an_acquired = false;
+
+	krln->ld_update = 0;
+	krln->prev_ld_update = 0;
+	krln->ld_last_nonhold_update = 0;
+	krln->lp_status = 0;
+	krln->lp_last_change_status = 0;
+	krln->last_lp_update_status[C_M1] = 0;
+	krln->last_lp_update_status[C_Z0] = 0;
+	krln->last_lp_update_status[C_P1] = 0;
+	krln->ld_status = 0;
+	krln->move_back_prev = false;
+	krln->move_back_cnt = 0;
+	krln->move_back_lp_status = 0;
+
+	lt_init_ld(krln);
+}
+
+static void setup_supported_linkmode(struct phy_device *bpphy)
+{
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	int i;
+
+	/* Clear all supported backplane protocols features
+	 * and setup only the currently configured protocol
+	 */
+	for (i = 0; i < ARRAY_SIZE(backplane_protocol_features_array); i++)
+		linkmode_clear_bit(backplane_protocol_features_array[i],
+				   bpphy->supported);
+
+	linkmode_set_bit(get_backplane_supported_mode(bp_phy->bp_mode),
+			 bpphy->supported);
+}
+
+/* Read AN Link Status */
+static int is_an_link_up(struct phy_device *bpphy)
+{
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	int ret, val = 0;
+
+	mutex_lock(&bp_phy->bpphy_lock);
+
+	/* Read twice because Link_Status is LL (Latched Low) bit */
+	val = phy_read_mmd(bpphy, MDIO_MMD_AN, bp_phy->bp_dev.mdio.an_status);
+	val = phy_read_mmd(bpphy, MDIO_MMD_AN, bp_phy->bp_dev.mdio.an_status);
+
+	mutex_unlock(&bp_phy->bpphy_lock);
+
+	ret = (val & AN_LINK_UP_MASK) ? 1 : 0;
+
+	return ret;
+}
+
+static void start_kr_state_machine(struct kr_lane_info *krln, u32 timeout)
+{
+	/* Check if equalization algorithm is installed */
+	if (!krln->eq_alg)
+		return;
+
+	/* Check if link training is used */
+	if (!krln->eq_alg->use_local_tx_training &&
+	    !krln->eq_alg->use_remote_tx_training)
+		return;
+
+	queue_delayed_work(system_power_efficient_wq, &krln->kr_wk,
+			   msecs_to_jiffies(timeout));
+}
+
+static void stop_kr_state_machine(struct kr_lane_info *krln)
+{
+	/* Check if equalization algorithm is installed */
+	if (!krln->eq_alg)
+		return;
+
+	/* Check if link training is used */
+	if (!krln->eq_alg->use_local_tx_training &&
+	    !krln->eq_alg->use_remote_tx_training)
+		return;
+
+	cancel_delayed_work_sync(&krln->kr_wk);
+}
+
+static void setup_default_settings(struct kr_lane_info *krln)
+{
+	struct lane_kr_params krparam;
+
+	krln->bp_phy->bp_dev.lane_ops->read_lane_kr(krln->reg_base, &krparam);
+
+	if (krln->bp_phy->bp_dev.coef_def_dt) {
+		krln->def_ratio_preq = krln->bp_phy->bp_dev.cm_def;
+		krln->def_ratio_pstq = krln->bp_phy->bp_dev.cp_def;
+		krln->def_adpt_eq = krln->bp_phy->bp_dev.cz_def;
+	} else {
+		krln->def_ratio_preq = krparam.ratio_preq;
+		krln->def_ratio_pstq = krparam.ratio_pstq;
+		krln->def_adpt_eq = krparam.adpt_eq;
+	}
+
+	if (krln->bp_phy->bp_dev.ampr_def_dt)
+		krln->def_amp_red = krln->bp_phy->bp_dev.amp_red_def;
+	else
+		krln->def_amp_red = krparam.amp_red;
+}
+
+static void kr_reset_master_lane(struct kr_lane_info *krln)
+{
+	struct phy_device *bpphy = krln->bpphy;
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	const struct lane_io_ops *lane_ops = krln->bp_phy->bp_dev.lane_ops;
+
+	if (backplane_is_multi_lane(bp_phy)) {
+		/* Reset only the Master Lane */
+		if (krln->idx == MASTER_LANE)
+			lane_ops->reset_lane(krln->reg_base, LANE_RX_TX);
+	} else {
+		lane_ops->reset_lane(krln->reg_base, LANE_RX_TX);
+	}
+}
+
+static void print_single_lane_trained(struct kr_lane_info *krln)
+{
+	struct phy_device *bpphy = krln->bpphy;
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+
+	bpdev_info(bpphy,
+		   "%s link trained, Tx equalization: preq = 0x%x, pstq = 0x%x, adpt_eq = 0x%x\n",
+		   phy_modes(bp_phy->bp_mode),
+		   krln->tuned_ratio_preq, krln->tuned_ratio_pstq,
+		   krln->tuned_adpt_eq);
+}
+
+static void print_multi_lane_trained(struct kr_lane_info *krln)
+{
+	struct phy_device *bpphy = krln->bpphy;
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	int i;
+
+	bpdev_info(bpphy,
+		   "%s link trained, Tx equalization:\n",
+		   phy_modes(bp_phy->bp_mode));
+
+	for (i = 0; i < bp_phy->num_lanes; i++)
+		bpdev_info(bpphy,
+			   "\t|- Lane %d: preq = 0x%x, pstq = 0x%x, adpt_eq = 0x%x\n",
+			   i + 1, bp_phy->krln[i].tuned_ratio_preq,
+			   bp_phy->krln[i].tuned_ratio_pstq,
+			   bp_phy->krln[i].tuned_adpt_eq);
+}
+
+static void kr_link_trained(struct kr_lane_info *krln)
+{
+	struct phy_device *bpphy = krln->bpphy;
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+
+	mutex_lock(&bp_phy->trained_lock);
+	/* Setup lane state as TRAINED inside the phy trained lock
+	 * to avoid duplicated message printed on multi-lane PHYs
+	 */
+	krln->state = TRAINED;
+
+	mutex_lock(&backplane_lock);
+
+	if (backplane_is_single_lane(bp_phy))
+		print_single_lane_trained(krln);
+	else
+		if (backplane_are_all_lanes_trained(bp_phy))
+			print_multi_lane_trained(krln);
+
+	mutex_unlock(&backplane_lock);
+	mutex_unlock(&bp_phy->trained_lock);
+}
+
+static void kr_train_step(struct kr_lane_info *krln)
+{
+	struct training_status *trst = &krln->trst;
+	u32 lt_timeout = KR_LT_TIMEOUT;
+	u64 dead_line;
+	int i = 0;
+
+	/* Check if equalization algorithm is installed */
+	if (!krln->eq_alg)
+		return;
+
+	/* Check if link training is used */
+	if (!krln->eq_alg->use_local_tx_training &&
+	    !krln->eq_alg->use_remote_tx_training)
+		return;
+
+	lt_start(krln);
+
+	while (i < KR_TRAIN_STEP_ITERATIONS) {
+		dead_line = jiffies + msecs_to_jiffies(lt_timeout);
+		while (time_before(jiffies, (unsigned long)dead_line)) {
+			/* check if the LT is already failed */
+			if (lt_is_training_failure(krln)) {
+				/* LT failed already, reset lane to avoid
+				 * it run into hanging, then start LT again.
+				 */
+				kr_reset_master_lane(krln);
+				lt_start(krln);
+			} else if (lt_is_frame_lock(krln)) {
+				break;
+			}
+			/* wait frame lock (without training_failure) */
+			usleep_range(100, 500);
+		}
+
+		if (!lt_is_frame_lock(krln)) {
+			i++;
+			continue;
+		}
+
+		/* the LT should be finished in 500ms, failed or OK. */
+		dead_line = jiffies + msecs_to_jiffies(lt_timeout);
+		while (time_before(jiffies, (unsigned long)dead_line)) {
+			/* check if the LT is already failed */
+			if (lt_is_training_failure(krln)) {
+				kr_reset_master_lane(krln);
+				break;
+			}
+
+			if (krln->eq_alg->use_local_tx_training)
+				lt_train_local_tx(krln);
+
+			if (krln->eq_alg->use_remote_tx_training)
+				lt_train_remote_tx(krln);
+
+			if (krln->lt_error)
+				break;
+
+			if (trst->lp_rx_ready && trst->remote_tx_complete)
+				break;
+
+			usleep_range(100, 500);
+		}
+
+		i++;
+		/* check if LT Error occurred */
+		if (krln->lt_error) {
+			init_krln(krln, false);
+			continue;
+		} else {
+			break;
+		}
+	}
+
+	lt_stop(krln);
+
+	/* check if Link is successfully TRAINED */
+	if (lt_is_rx_trained(krln))
+		kr_link_trained(krln);
+	else
+		kr_reset_master_lane(krln);
+}
+
+static void an_request_restart(struct kr_lane_info *krln)
+{
+	struct phy_device *bpphy = krln->bpphy;
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	const struct lane_io_ops *lane_ops = krln->bp_phy->bp_dev.lane_ops;
+	int i;
+
+	if (time_before(jiffies, (unsigned long)krln->rt_time))
+		return;
+	if (!backplane_is_mode_kr(bp_phy->bp_mode))
+		return;
+
+	for (i = 0; i < bp_phy->num_lanes; i++) {
+		init_krln(&bp_phy->krln[i], true);
+		/* Reset the lane to recover from link down */
+		lane_ops->reset_lane(bp_phy->krln[i].reg_base, LANE_RX_TX);
+		lt_reset(&bp_phy->krln[i]);
+	}
+	/* Start AN only for Master Lane */
+	lt_start_an(&bp_phy->krln[MASTER_LANE]);
+
+	krln->rt_time = jiffies + msecs_to_jiffies(KR_DENY_RT_INTERVAL);
+}
+
+static bool detect_lp(struct kr_lane_info *krln)
+{
+	struct phy_device *bpphy = krln->bpphy;
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	u32 an_bp_eth_status = krln->bp_phy->bp_dev.mdio.an_bp_eth_status;
+	bool start_train = false;
+	int an_state;
+
+	/* Check AN state on Master Lane */
+	an_state = backplane_read_mmd(&bp_phy->krln[MASTER_LANE], MDIO_MMD_AN,
+				      an_bp_eth_status);
+
+	/* The link training occurs after auto-negotiation
+	 * has determined the link to be a Base-KR link.
+	 * This is indicated by asserting the corresponding
+	 * technology bit within the BP_ETH_STATUS register.
+	 * Note that this occurs before auto-negotiation can declare
+	 * auto-negotiation complete,
+	 * as this requires the PCS to report a valid link.
+	 */
+	if (an_state &
+	    bp_phy->bp_dev.mdio.get_an_bp_eth_status_bit(bp_phy->bp_mode)) {
+		/* AN acquired:
+		 * Train all lanes in order starting with Master Lane
+		 */
+		krln->an_acquired = true;
+		krln->an_wait_count = 0;
+		start_train = true;
+	} else {
+		/* AN lost or not yet acquired */
+		if (krln->an_acquired) {
+			/* AN acquired first time but now was lost */
+			if (!backplane_is_link_up(bpphy)) {
+				/* Link is down: restart training */
+				krln->an_wait_count = 0;
+				an_request_restart(krln);
+			} else {
+				/* Link is up:
+				 * wait few iterations for AN to be acquired
+				 */
+				if (krln->an_wait_count >=
+							KR_AN_WAIT_ITERATIONS) {
+					krln->an_wait_count = 0;
+					an_request_restart(krln);
+				} else {
+					krln->an_wait_count++;
+				}
+			}
+		}
+		/* else: AN was not yet acquired first time
+		 * DO nothing, just wait AN to be acquired first time
+		 */
+	}
+
+	return start_train;
+}
+
+static void detect_hotplug(struct kr_lane_info *krln)
+{
+	struct phy_device *bpphy = krln->bpphy;
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	int i;
+
+	if (krln->idx == MASTER_LANE) {
+		/* check if all lanes are trained
+		 * only if current lane is  Master Lane
+		 */
+		if (backplane_are_all_lanes_trained(bp_phy)) {
+			bpdev_info(bpphy, "Detect hotplug, restart training\n");
+			for (i = 0; i < bp_phy->num_lanes; i++) {
+				/* initializations on Detect hotplug / restart:
+				 * they must not be part of init_krln
+				 */
+				bp_phy->krln[i].first_recv_init = false;
+			}
+			an_request_restart(krln);
+		}
+	}
+}
+
+static void bp_kr_state_machine(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct kr_lane_info *krln = container_of(dwork, struct kr_lane_info,
+						 kr_wk);
+	struct phy_device *bpphy = krln->bpphy;
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	bool start_train = false;
+	u32 kr_timeout = KR_TIMEOUT_1;
+
+	if (!backplane_is_mode_kr(bp_phy->bp_mode))
+		return;
+
+	/* Check if equalization algorithm is installed */
+	if (!krln->eq_alg)
+		return;
+
+	/* Check if link training is used */
+	if (!krln->eq_alg->use_local_tx_training &&
+	    !krln->eq_alg->use_remote_tx_training)
+		return;
+
+	if (!bp_phy->bp_dev.mdio.get_an_bp_eth_status_bit) {
+		bpdev_err(bpphy,
+			  "Unknown AN_BP_ETHERNET_STATUS KR detection bit\n");
+		return;
+	}
+
+	mutex_lock(&krln->lane_lock);
+	switch (krln->state) {
+	case DETECTING_LP:
+		start_train = detect_lp(krln);
+		break;
+	case TRAINED:
+		kr_timeout = KR_TIMEOUT_2;
+		if (!backplane_is_link_up(bpphy)) {
+			kr_timeout = KR_TIMEOUT_1;
+			detect_hotplug(krln);
+		}
+		break;
+	}
+
+	if (start_train)
+		kr_train_step(krln);
+
+	mutex_unlock(&krln->lane_lock);
+	start_kr_state_machine(krln, kr_timeout);
+}
+
+static void init_kr_state_machine(struct kr_lane_info *krln)
+{
+	/* Check if equalization algorithm is installed */
+	if (!krln->eq_alg)
+		return;
+
+	/* Check if link training is used */
+	if (!krln->eq_alg->use_local_tx_training &&
+	    !krln->eq_alg->use_remote_tx_training)
+		return;
+
+	INIT_DELAYED_WORK(&krln->kr_wk, bp_kr_state_machine);
+}
+
+/* backplane_write_mmd - Wrapper function for phy_write_mmd
+ * for writing a register on an MMD on a given PHY.
+ *
+ * Same rules as for phy_write_mmd();
+ */
+int backplane_write_mmd(struct kr_lane_info *krln, int devad, u32 regnum,
+			u16 val)
+{
+	struct phy_device *bpphy = krln->bpphy;
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	int mdio_addr = bpphy->mdio.addr;
+	int err;
+
+	mutex_lock(&bp_phy->bpphy_lock);
+
+	if (devad == MDIO_MMD_AN && backplane_is_multi_lane(bp_phy)) {
+		/* Multilane AN: prepare mdio address
+		 * for writing bpphy AN registers on respective lane
+		 * AN MDIO address offset for multilane is equal
+		 * to number of lanes
+		 */
+		bpphy->mdio.addr = bp_phy->num_lanes + krln->idx;
+	}
+
+	err = phy_write_mmd(bpphy, devad, regnum, val);
+	if (err)
+		bpdev_err(bpphy,
+			  "Writing PHY (%p) MMD = 0x%02x register = 0x%02x failed with error code: 0x%08x\n",
+			  bpphy, devad, regnum, err);
+
+	if (devad == MDIO_MMD_AN && backplane_is_multi_lane(bp_phy)) {
+		/* Multilane AN: restore mdio address */
+		bpphy->mdio.addr = mdio_addr;
+	}
+
+	mutex_unlock(&bp_phy->bpphy_lock);
+
+	return err;
+}
+
+/* backplane_read_mmd - Wrapper function for phy_read_mmd
+ * for reading a register from an MMD on a given PHY.
+ *
+ * Same rules as for phy_read_mmd();
+ */
+int backplane_read_mmd(struct kr_lane_info *krln, int devad, u32 regnum)
+{
+	struct phy_device *bpphy = krln->bpphy;
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	int mdio_addr = bpphy->mdio.addr;
+	int ret;
+
+	mutex_lock(&bp_phy->bpphy_lock);
+
+	if (devad == MDIO_MMD_AN && backplane_is_multi_lane(bp_phy)) {
+		/* Multilane AN: prepare mdio address
+		 * for reading bpphy AN registers on respective lane
+		 * AN MDIO address offset for multilane is equal to
+		 * number of lanes
+		 */
+		bpphy->mdio.addr = bp_phy->num_lanes + krln->idx;
+	}
+
+	ret = phy_read_mmd(bpphy, devad, regnum);
+
+	if (devad == MDIO_MMD_AN && backplane_is_multi_lane(bp_phy)) {
+		/* Multilane AN: restore mdio address */
+		bpphy->mdio.addr = mdio_addr;
+	}
+
+	mutex_unlock(&bp_phy->bpphy_lock);
+
+	return ret;
+}
+
+/* backplane_get_current_taps
+ * convert coefficient taps from internal backplane driver to link training
+ */
+void backplane_get_current_taps(struct kr_lane_info *krln, u32 *coef)
+{
+	coef[C_M1] = krln->ratio_preq;
+	coef[C_Z0] = krln->adpt_eq;
+	coef[C_P1] = krln->ratio_pstq;
+}
+
+/* backplane_set_current_taps
+ * convert coefficient taps from link training to internal backplane driver
+ */
+void backplane_set_current_taps(struct kr_lane_info *krln, u32 *coef)
+{
+	krln->ratio_preq = coef[C_M1];
+	krln->adpt_eq = coef[C_Z0];
+	krln->ratio_pstq = coef[C_P1];
+}
+
+/* backplane_set_all_taps_to_max
+ * setup all coefficients to MAX values from IEEE802.3ap perspective
+ */
+void backplane_set_all_taps_to_max(struct kr_lane_info *krln)
+{
+	krln->ratio_pstq = krln->bp_phy->bp_dev.cp_max;
+	krln->adpt_eq = krln->bp_phy->bp_dev.cz_max;
+	krln->ratio_preq = krln->bp_phy->bp_dev.cm_max;
+}
+
+void backplane_tune_kr_lane(struct kr_lane_info *krln, bool reset_lane)
+{
+	struct phy_device *bpphy = krln->bpphy;
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	struct lane_kr_params krparams;
+	bool reset = false;
+
+	if (backplane_is_multi_lane(bp_phy)) {
+		/* Reset only the Master Lane */
+		reset = (krln->idx == MASTER_LANE);
+	} else {
+		reset = true;
+	}
+
+	/* Do not reset the lane if this is how it was asked */
+	if (!reset_lane)
+		reset = false;
+
+	krparams.ratio_preq = krln->ratio_preq;
+	krparams.ratio_pstq = krln->ratio_pstq;
+	krparams.adpt_eq = krln->adpt_eq;
+	krparams.amp_red = krln->def_amp_red;
+	krln->bp_phy->bp_dev.lane_ops->tune_lane_kr(krln->reg_base, &krparams,
+						    reset);
+
+	krln->tuned_ratio_preq = krln->ratio_preq;
+	krln->tuned_ratio_pstq = krln->ratio_pstq;
+	krln->tuned_adpt_eq = krln->adpt_eq;
+}
+
+void backplane_default_kr_lane(struct kr_lane_info *krln)
+{
+	krln->ratio_preq = krln->def_ratio_preq;
+	krln->ratio_pstq = krln->def_ratio_pstq;
+	krln->adpt_eq = krln->def_adpt_eq;
+
+	backplane_tune_kr_lane(krln, true);
+}
+
+void bpdev_err(struct phy_device *bpphy, char *msg, ...)
+{
+	BPDEV_LOG(err);
+}
+EXPORT_SYMBOL(bpdev_err);
+
+void bpdev_warn(struct phy_device *bpphy, char *msg, ...)
+{
+	BPDEV_LOG(warn);
+}
+EXPORT_SYMBOL(bpdev_warn);
+
+void bpdev_info(struct phy_device *bpphy, char *msg, ...)
+{
+	BPDEV_LOG(info);
+}
+EXPORT_SYMBOL(bpdev_info);
+
+void bpdev_dbg(struct phy_device *bpphy, char *msg, ...)
+{
+	BPDEV_LOG(dbg);
+}
+EXPORT_SYMBOL(bpdev_dbg);
+
+/* backplane_eq_register
+ *
+ * Registers an equalization algorithm with the specified key
+ *
+ * key: desired key on which eq algorithm must be registered
+ * eq_info: eq algorithm information to be registered
+ *
+ * Returns: Zero for success or error code in case of failure
+ */
+int backplane_eq_register(const char *key,
+			  const struct equalization_algorithm *eq_info)
+{
+	struct spmap_node *eqalg, *eqalg_tmp;
+
+	/* check if desired key already exists */
+	list_for_each_entry_safe(eqalg, eqalg_tmp, &eqalg_list, entry) {
+		if (strcmp(eqalg->key, key) == 0) {
+			pr_err("%s: Equalization algorithm registration failed: key '%s' already exists\n",
+			       BACKPLANE_DRIVER_NAME, key);
+			return -EEXIST;
+		}
+	}
+
+	spmap_add(&eqalg_list, key, (void *)eq_info);
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_eq_register);
+
+/* backplane_eq_unregister
+ *
+ * Unregisters all equalization algorithm for the specified key
+ *
+ * key: desired key for which all registered eq algorithms must be removed
+ *
+ * Returns: None
+ */
+void backplane_eq_unregister(const char *key)
+{
+	struct spmap_node *node, *node_tmp;
+	struct kr_lane_info *krln;
+
+	if (!key)
+		return;
+
+	/* search all keys in lanes list */
+	list_for_each_entry_safe(node, node_tmp, &lnalg_list, entry) {
+		if (strcmp(node->key, key) == 0) {
+			krln = (struct kr_lane_info *)node->pdata;
+			if (krln->eq_alg->ops.destroy)
+				krln->eq_alg->ops.destroy(krln->eq_priv);
+			krln->eq_alg = NULL;
+			krln->eq_priv = NULL;
+			list_del_init(&node->entry);
+			kfree(node);
+		}
+	}
+
+	/* search single key in eq algorithms list */
+	list_for_each_entry_safe(node, node_tmp, &eqalg_list, entry) {
+		if (strcmp(node->key, key) == 0) {
+			list_del_init(&node->entry);
+			kfree(node);
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL(backplane_eq_unregister);
+
+void backplane_setup_mdio_c45(struct backplane_dev_info *bp_dev)
+{
+	/* KR PMD registers */
+	lt_setup_c45(bp_dev);
+
+	bp_dev->mdio.pmd_ctrl_1 = MDIO_CTRL1;
+
+	/* KX/KR AN registers: IEEE802.3 Clause 45 (MMD 7) */
+	bp_dev->mdio.an_control = MDIO_CTRL1;
+	bp_dev->mdio.an_status = MDIO_STAT1;
+	bp_dev->mdio.an_ad_ability_0 = MDIO_PMA_EXTABLE_10GBKR;
+	bp_dev->mdio.an_ad_ability_1 = MDIO_PMA_EXTABLE_10GBKR + 1;
+	bp_dev->mdio.an_lp_base_page_ability_1 = MDIO_PMA_EXTABLE_10GBKR + 4;
+}
+EXPORT_SYMBOL(backplane_setup_mdio_c45);
+
+void backplane_setup_kr_lt_mmd(struct backplane_dev_info *bp_dev, int devad,
+			       u32 base)
+{
+	lt_setup_memmap(bp_dev, devad, base);
+}
+EXPORT_SYMBOL(backplane_setup_kr_lt_mmd);
+
+bool backplane_is_mode_kr(phy_interface_t bp_mode)
+{
+	return (bp_mode >= PHY_INTERFACE_MODE_10GKR &&
+		bp_mode <= PHY_INTERFACE_MODE_40GKR4);
+}
+EXPORT_SYMBOL(backplane_is_mode_kr);
+
+bool backplane_is_valid_mode(phy_interface_t bp_mode)
+{
+	return (bp_mode >= PHY_INTERFACE_MODE_10GKR &&
+		bp_mode <= PHY_INTERFACE_MODE_40GKR4);
+}
+EXPORT_SYMBOL(backplane_is_valid_mode);
+
+u8 backplane_num_lanes(phy_interface_t bp_mode)
+{
+	const char *bp_name;
+	char num_lanes;
+	int len;
+
+	if (!backplane_is_valid_mode(bp_mode))
+		return 0;
+
+	bp_name = phy_modes(bp_mode);
+	if (!bp_name)
+		return 0;
+	if (strcmp(bp_name, "unknown") == 0)
+		return 0;
+
+	len = strlen(bp_name);
+	if (len == 0)
+		return 0;
+	num_lanes = bp_name[len - 1];
+	if (num_lanes >= '0' && num_lanes <= '9')
+		return num_lanes - '0';
+
+	return 1;
+}
+EXPORT_SYMBOL(backplane_num_lanes);
+
+bool backplane_is_single_lane(struct backplane_phy_info *bp_phy)
+{
+	return (bp_phy->num_lanes == 1);
+}
+EXPORT_SYMBOL(backplane_is_single_lane);
+
+bool backplane_is_multi_lane(struct backplane_phy_info *bp_phy)
+{
+	return (bp_phy->num_lanes > 1);
+}
+EXPORT_SYMBOL(backplane_is_multi_lane);
+
+/* backplane_is_cdr_lock
+ *
+ * Checks clock and data recovery bit: CDR Lock
+ *
+ * krln: desired lane to be verified
+ * retry: boolean value that specifies if to retry the check
+ *
+ * Returns: true if CDR_Lock bit is asserted or false otherwise
+ */
+bool backplane_is_cdr_lock(struct kr_lane_info *krln, bool retry)
+{
+	int i;
+
+	if (krln->bp_phy->bp_dev.lane_ops->is_cdr_lock(krln->reg_base))
+		return true;
+
+	if (!retry)
+		return false;
+
+	/* Try RX_RESET: Allow for few retries */
+	for (i = 0; i < CDR_LOCK_RETRY_COUNT; i++) {
+		krln->bp_phy->bp_dev.lane_ops->reset_lane(krln->reg_base,
+							  LANE_RX);
+		usleep_range(10, 50);
+
+		if (krln->bp_phy->bp_dev.lane_ops->is_cdr_lock(krln->reg_base))
+			return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL(backplane_is_cdr_lock);
+
+/* backplane_is_link_up
+ * Generic Link-up Status: use AN link-up
+ */
+int backplane_is_link_up(struct phy_device *bpphy)
+{
+	return is_an_link_up(bpphy);
+}
+EXPORT_SYMBOL(backplane_is_link_up);
+
+int backplane_get_lanes_trained_count(struct backplane_phy_info *bp_phy)
+{
+	int i, lanes_trained = 0;
+
+	for (i = 0; i < bp_phy->num_lanes; i++) {
+		if (bp_phy->krln[i].state == TRAINED)
+			lanes_trained++;
+	}
+	return lanes_trained;
+}
+EXPORT_SYMBOL(backplane_get_lanes_trained_count);
+
+int backplane_are_all_lanes_trained(struct backplane_phy_info *bp_phy)
+{
+	int i;
+
+	for (i = 0; i < bp_phy->num_lanes; i++) {
+		if (bp_phy->krln[i].state != TRAINED)
+			return 0;
+	}
+	return 1;
+}
+EXPORT_SYMBOL(backplane_are_all_lanes_trained);
+
+int backplane_create(struct phy_device *bpphy)
+{
+	struct device_node *bpphy_node;
+	struct backplane_phy_info *bp_phy;
+
+	bpphy_node = bpphy->mdio.dev.of_node;
+	if (!bpphy_node) {
+		bpdev_err(bpphy, "No associated device tree node\n");
+		return -EINVAL;
+	}
+
+	/* allocate memory for backplane info structure */
+	bp_phy = devm_kzalloc(&bpphy->mdio.dev, sizeof(*bp_phy), GFP_KERNEL);
+	if (!bp_phy)
+		return -ENOMEM;
+
+	bpphy->priv = bp_phy;
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_create);
+
+/* backplane_parse_dt
+ * parses the device tree and saves backplane relevant data
+ * in backplane phy info structure
+ */
+int backplane_parse_dt(struct phy_device *bpphy)
+{
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	struct device_node *bpphy_node;
+	const char *eqa;
+	u32 eqinit[4];
+	int proplen;
+	int ret;
+
+	if (!bp_phy) {
+		bpdev_err(bpphy, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+
+	bpphy_node = bpphy->mdio.dev.of_node;
+	if (!bpphy_node) {
+		bpdev_err(bpphy, "No associated device tree node\n");
+		return -EINVAL;
+	}
+
+	if (!backplane_is_valid_mode(bpphy->interface))
+		return -EINVAL;
+
+	bp_phy->bp_mode = bpphy->interface;
+	bp_phy->num_lanes = backplane_num_lanes(bpphy->interface);
+
+	ret = of_property_read_string(bpphy_node, "eq-algorithm", &eqa);
+	/* if eq-algorithm node is not found then use the default algorithm */
+	if (ret == 0)
+		bp_phy->bp_dev.eqa_name = eqa;
+	else
+		bp_phy->bp_dev.eqa_name = DEFAULT_EQ_ALGORITHM;
+
+	/* if eq-init node exists then use the DTS specified values
+	 * if eq-init node doesn't exist then use values already found in HW
+	 */
+	proplen = of_property_count_u32_elems(bpphy_node, "eq-init");
+	if (proplen > 0) {
+		/* There are 3 standard equalization coefficient taps */
+		if (proplen > C_NO)
+			proplen = C_NO;
+		ret = of_property_read_u32_array(bpphy_node, "eq-init",
+						 (u32 *)eqinit, proplen);
+		if (ret == 0) {
+			bp_phy->bp_dev.coef_def_dt = true;
+			bp_phy->bp_dev.cm_def = eqinit[0];
+			bp_phy->bp_dev.cp_def = eqinit[1];
+			bp_phy->bp_dev.cz_def = eqinit[2];
+		}
+	}
+
+	/* setup ioread/iowrite according to endianness */
+	if (bp_phy->bp_dev.is_little_endian) {
+		bp_phy->bp_dev.io.read32 = le_ioread32;
+		bp_phy->bp_dev.io.write32 = le_iowrite32;
+	} else {
+		bp_phy->bp_dev.io.read32 = be_ioread32;
+		bp_phy->bp_dev.io.write32 = be_iowrite32;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_parse_dt);
+
+/* backplane_setup_mdio
+ */
+int backplane_setup_mdio(struct phy_device *bpphy)
+{
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+
+	if (!bp_phy) {
+		bpdev_err(bpphy, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+
+	/* By default setup MDIO Clause 45 */
+	backplane_setup_mdio_c45(&bp_phy->bp_dev);
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_setup_mdio);
+
+/* backplane_setup_lanes
+ * Allocates lanes memory map and setup lanes relevant data
+ * Requires:
+ *	- backplane_dev_info#lane_ops
+ *		for lane access operations
+ *	- backplane_dev_info#equalizer
+ *		for specific Equalizer access
+ *	- backplane_dev_info#lane_io_ops#memmap_size
+ *		for lane memory map allocation
+ *	- backplane_dev_info#cx_def
+ *		for default coefficient setup
+ */
+int backplane_setup_lanes(struct phy_device *bpphy)
+{
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	struct kr_lane_info *krln;
+	struct eq_setup_info eq_setup;
+	int i;
+
+	if (!bp_phy) {
+		bpdev_err(bpphy, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+	if (!bp_phy->bp_dev.lane_ops) {
+		bpdev_err(bpphy, "Backplane lane ops is not set\n");
+		return -EINVAL;
+	}
+	if (!bp_phy->bp_dev.equalizer) {
+		bpdev_err(bpphy, "Backplane equalizer info is not set\n");
+		return -EINVAL;
+	}
+	if (bp_phy->bp_dev.lane_ops->memmap_size == 0) {
+		bpdev_err(bpphy, "Lane memory map size is zero\n");
+		return -EINVAL;
+	}
+
+	if (backplane_is_mode_kr(bp_phy->bp_mode)) {
+		if (bp_phy->bp_dev.cm_def == 0 && bp_phy->bp_dev.cz_def == 0 &&
+		    bp_phy->bp_dev.cp_def == 0)
+			bpdev_warn(bpphy,
+				   "All default values for KR parameters are zero\n");
+	}
+
+	for (i = 0; i < bp_phy->num_lanes; i++) {
+		krln = &bp_phy->krln[i];
+
+		/* setup lane memory map size */
+		krln->memmap_size = bp_phy->bp_dev.lane_ops->memmap_size;
+
+		krln->reg_base = devm_ioremap(&bpphy->mdio.dev,
+					      krln->lane_addr,
+					      krln->memmap_size);
+		if (!krln->reg_base) {
+			bpdev_err(bpphy, "Lane memory map allocation failed\n");
+			return -ENOMEM;
+		}
+
+		krln->idx = i;
+		krln->bpphy = bpphy;
+		krln->bp_phy = bp_phy;
+		krln->rt_time = jiffies + msecs_to_jiffies(KR_DENY_RT_INTERVAL);
+
+		if (backplane_is_mode_kr(bp_phy->bp_mode)) {
+			setup_default_settings(krln);
+
+			/* Find EQ Algorithm info */
+			krln->eq_alg = eq_find(bp_phy->bp_dev.eqa_name);
+			if (!krln->eq_alg) {
+				/* key for desired algorithm was not found */
+				bpdev_err(bpphy,
+					  "Equalization algorithm '%s' is not registered\n",
+					  bp_phy->bp_dev.eqa_name);
+				return -EINVAL;
+			}
+			if (!krln->eq_alg->ops.create) {
+				bpdev_err(bpphy,
+					  "Equalization algorithm creation failed: create operation is not available\n");
+				return -EINVAL;
+			}
+
+			/* Setup EQ Algorithm */
+			eq_setup.krlane = krln;
+			eq_setup.bpphy = krln->bpphy;
+			eq_setup.reg_base = krln->reg_base;
+			eq_setup.equalizer = *krln->bp_phy->bp_dev.equalizer;
+
+			/* Create EQ Algorithm */
+			krln->eq_priv = krln->eq_alg->ops.create(eq_setup);
+
+			/* register lane attached to an algorithm */
+			spmap_add(&lnalg_list, bp_phy->bp_dev.eqa_name, krln);
+
+			if (krln->eq_alg->use_remote_tx_training) {
+				if (!krln->eq_alg->ops.is_rx_ok)
+					bpdev_warn(bpphy,
+						   "Required operation for remote Tx training is missing: is_rx_ok\n");
+				if (!krln->eq_alg->ops.is_eq_done)
+					bpdev_warn(bpphy,
+						   "Required operation for remote Tx training is missing: is_eq_done\n");
+				if (!krln->eq_alg->ops.collect_statistics)
+					bpdev_warn(bpphy,
+						   "Required operation for remote Tx training is missing: collect_statistics\n");
+				if (!krln->eq_alg->ops.generate_request)
+					bpdev_warn(bpphy,
+						   "Required operation for remote Tx training is missing: generate_request\n");
+			}
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_setup_lanes);
+
+/* backplane_initialize
+ * Initializes all PHY and lane mutexes and
+ * starts lane timers for running the algorithm
+ */
+int backplane_initialize(struct phy_device *bpphy)
+{
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	int i;
+
+	if (!bp_phy) {
+		bpdev_err(bpphy, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+
+	mutex_init(&bp_phy->bpphy_lock);
+	mutex_init(&bp_phy->trained_lock);
+
+	for (i = 0; i < bp_phy->num_lanes; i++)
+		mutex_init(&bp_phy->krln[i].lane_lock);
+
+	bpphy->speed = get_backplane_speed(bp_phy->bp_mode);
+	if (bpphy->speed < 0) {
+		bpdev_err(bpphy, "Unsupported backplane mode\n");
+		return -EINVAL;
+	}
+
+	if (backplane_is_mode_kr(bp_phy->bp_mode)) {
+		for (i = 0; i < bp_phy->num_lanes; i++)
+			init_kr_state_machine(&bp_phy->krln[i]);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_initialize);
+
+/* backplane_probe
+ *
+ * Probe function for backplane driver to provide generic device behavior
+ *
+ * bpphy: backplane phy device
+ *	this is an internal phy block controlled by the software
+ *	which contains other component blocks like: PMA/PMD, PCS, AN
+ *
+ * Return: Zero for success or error code in case of failure
+ */
+int backplane_probe(struct phy_device *bpphy)
+{
+	return backplane_create(bpphy);
+}
+EXPORT_SYMBOL(backplane_probe);
+
+void backplane_remove(struct phy_device *bpphy)
+{
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+
+	if (!bp_phy) {
+		bpdev_err(bpphy, "Backplane phy info is not allocated\n");
+		return;
+	}
+
+	kfree(bp_phy);
+	bpphy->priv = NULL;
+}
+EXPORT_SYMBOL(backplane_remove);
+
+/* backplane_config_init
+ *
+ * Config_Init function for backplane driver to provide generic device behavior
+ *
+ * bpphy: backplane phy device
+ *
+ * Return: Zero for success or error code in case of failure
+ */
+int backplane_config_init(struct phy_device *bpphy)
+{
+	int ret;
+
+	ret = backplane_parse_dt(bpphy);
+	if (ret)
+		return ret;
+
+	ret = backplane_setup_mdio(bpphy);
+	if (ret)
+		return ret;
+
+	ret = backplane_setup_lanes(bpphy);
+	if (ret)
+		return ret;
+
+	ret = backplane_initialize(bpphy);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_config_init);
+
+int backplane_aneg_done(struct phy_device *bpphy)
+{
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+
+	if (!bpphy->mdio.dev.of_node) {
+		bpdev_err(bpphy, "No associated device tree node\n");
+		return -EINVAL;
+	}
+	if (!bp_phy) {
+		bpdev_err(bpphy, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+
+	bp_phy->aneg_done = true;
+	bpphy->state = PHY_RUNNING;
+
+	return 1;
+}
+EXPORT_SYMBOL(backplane_aneg_done);
+
+int backplane_config_aneg(struct phy_device *bpphy)
+{
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	struct kr_lane_info *krln;
+	struct equalization_ops ops;
+	int i;
+
+	if (!bpphy->mdio.dev.of_node) {
+		bpdev_err(bpphy, "No associated device tree node\n");
+		return -EINVAL;
+	}
+	if (!bp_phy) {
+		bpdev_err(bpphy, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+	if (backplane_get_lanes_trained_count(bp_phy) > 0) {
+		bpdev_err(bpphy, "Incorrectly trained lanes detected\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < bp_phy->num_lanes; i++) {
+		krln = &bp_phy->krln[i];
+		if (krln->eq_alg) {
+			ops = krln->eq_alg->ops;
+			if (ops.dump_algorithm_context)
+				ops.dump_algorithm_context(krln->eq_priv);
+		}
+	}
+
+	if (backplane_is_mode_kr(bp_phy->bp_mode)) {
+		/* Warning:
+		 * Order of the operations below is important
+		 * otherwise the training may be failing
+		 * with error: 'link_training_failed'
+		 */
+
+		/* setup all lanes to default */
+		for (i = 0; i < bp_phy->num_lanes; i++)
+			setup_default_settings(&bp_phy->krln[i]);
+
+		/* Initialize all lanes and reset LT */
+		for (i = 0; i < bp_phy->num_lanes; i++) {
+			init_krln(&bp_phy->krln[i], true);
+			lt_reset(&bp_phy->krln[i]);
+		}
+	}
+
+	/* Warning:
+	 * speed and protocol setup operation
+	 * must be done just before AN and state machine start
+	 * otherwise if it is done earlier,
+	 * the error: 'REQ Timeout' will occur
+	 */
+	/* setup supported speed and protocol */
+	bpphy->speed = get_backplane_speed(bp_phy->bp_mode);
+	if (bpphy->speed < 0) {
+		bpdev_err(bpphy, "Unsupported backplane mode\n");
+		return -EINVAL;
+	}
+
+	setup_supported_linkmode(bpphy);
+	linkmode_copy(bpphy->advertising, bpphy->supported);
+	bpphy->duplex = DUPLEX_FULL;
+
+	if (backplane_is_mode_kr(bp_phy->bp_mode)) {
+		/* Start AN only for Master Lane */
+		lt_start_an(&bp_phy->krln[MASTER_LANE]);
+		/* start state machine on all lanes */
+		for (i = 0; i < bp_phy->num_lanes; i++)
+			start_kr_state_machine(&bp_phy->krln[i], KR_TIMEOUT_1);
+	}
+
+	bp_phy->aneg_config = true;
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_config_aneg);
+
+int backplane_suspend(struct phy_device *bpphy)
+{
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	int i;
+
+	if (!bpphy->mdio.dev.of_node) {
+		bpdev_err(bpphy, "No associated device tree node\n");
+		return -EINVAL;
+	}
+	if (!bp_phy) {
+		bpdev_err(bpphy, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+
+	if (bp_phy->aneg_config && !bp_phy->phy_suspended) {
+		if (backplane_is_mode_kr(bp_phy->bp_mode)) {
+			for (i = 0; i < bp_phy->num_lanes; i++)
+				stop_kr_state_machine(&bp_phy->krln[i]);
+		}
+		bp_phy->phy_suspended = true;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_suspend);
+
+int backplane_resume(struct phy_device *bpphy)
+{
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	int i;
+
+	if (!bpphy->mdio.dev.of_node) {
+		bpdev_err(bpphy, "No associated device tree node\n");
+		return -EINVAL;
+	}
+	if (!bp_phy) {
+		bpdev_err(bpphy, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+
+	if (bp_phy->aneg_config && bp_phy->phy_suspended) {
+		if (backplane_is_mode_kr(bp_phy->bp_mode)) {
+			for (i = 0; i < bp_phy->num_lanes; i++) {
+				init_krln(&bp_phy->krln[i], true);
+				start_kr_state_machine(&bp_phy->krln[i],
+						       KR_TIMEOUT_1);
+			}
+		}
+		bp_phy->phy_suspended = false;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_resume);
+
+int backplane_read_status(struct phy_device *bpphy)
+{
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+
+	if (!bpphy->mdio.dev.of_node) {
+		bpdev_err(bpphy, "No associated device tree node\n");
+		return -EINVAL;
+	}
+	if (!bp_phy) {
+		bpdev_err(bpphy, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+
+	/* Linkup method proposal for training stability:
+	 * Don't raise linkup until all lanes are trained
+	 * in order to prevent interface sending packets that may
+	 * interfere with the training packets
+	 */
+	if (backplane_is_link_up(bpphy))
+		if (backplane_is_mode_kr(bp_phy->bp_mode))
+			bpphy->link = backplane_are_all_lanes_trained(bp_phy);
+		else
+			bpphy->link = 1;
+	else
+		bpphy->link = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_read_status);
+
+int backplane_match_phy_device(struct phy_device *bpphy)
+{
+	struct device_node *bpphy_node;
+
+	if (!bpphy->mdio.dev.of_node)
+		return 0;
+
+	if (!bpphy->is_c45)
+		return 0;
+
+	bpphy_node = bpphy->mdio.dev.of_node;
+	if (!bpphy_node) {
+		bpdev_err(bpphy, "No associated device tree node\n");
+		return 0;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL(backplane_match_phy_device);
+
+static int __init backplane_module_init(void)
+{
+	pr_info("%s: Backplane driver version %s\n",
+		BACKPLANE_DRIVER_NAME, BACKPLANE_DRIVER_VERSION);
+	mutex_init(&backplane_lock);
+	backplane_features_init();
+	return 0;
+}
+
+static void __exit backplane_module_exit(void)
+{
+	pr_info("%s: Backplane driver version %s unloaded\n",
+		BACKPLANE_DRIVER_NAME, BACKPLANE_DRIVER_VERSION);
+}
+
+module_init(backplane_module_init);
+module_exit(backplane_module_exit);
+
+MODULE_DESCRIPTION("Backplane driver");
+MODULE_AUTHOR("Florinel Iordache <florinel.iordache@nxp.com>");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/phy/backplane/backplane.h b/drivers/net/phy/backplane/backplane.h
new file mode 100644
index 0000000..911e418
--- /dev/null
+++ b/drivers/net/phy/backplane/backplane.h
@@ -0,0 +1,262 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Backplane driver
+ *
+ * Copyright 2018-2020 NXP
+ */
+
+#ifndef __BACKPLANE_H
+#define __BACKPLANE_H
+
+#include <linux/phy.h>
+#include <linux/mutex.h>
+
+#include "equalization.h"
+
+/* Backplane Driver name */
+#define BACKPLANE_DRIVER_NAME			"backplane"
+
+/* Backplane Driver version */
+#define BACKPLANE_DRIVER_VERSION		"1.0.0"
+
+/* Maximum number of lanes per phy */
+#define MAX_KR_LANES_PER_PHY			4
+
+/* Lanes definitions */
+#define MASTER_LANE				0
+#define SINGLE_LANE				0
+
+extern __ETHTOOL_DECLARE_LINK_MODE_MASK(backplane_features) __ro_after_init;
+
+#define BACKPLANE_FEATURES ((unsigned long *)&backplane_features)
+
+enum train_state {
+	DETECTING_LP,
+	TRAINED,
+};
+
+enum lane_req {
+	LANE_INVALID,
+	LANE_RX,
+	LANE_TX,
+	LANE_RX_TX
+};
+
+struct lane_kr_params {
+	u32 ratio_preq;
+	u32 ratio_pstq;
+	u32 adpt_eq;
+	u32 amp_red;
+};
+
+/* Generic Lane operations */
+struct lane_io_ops {
+	const void *priv;	/* device specific private info */
+	u32 memmap_size;	/* lane memory map size */
+	void (*reset_lane)(void __iomem *reg, enum lane_req req);
+	void (*tune_lane_kr)(void __iomem *reg, struct lane_kr_params *params,
+			     bool reset);
+	void (*read_lane_kr)(void __iomem *reg, struct lane_kr_params *params);
+	bool (*is_cdr_lock)(void __iomem *reg);
+};
+
+/* Endianness specific memory I/O operations
+ */
+struct mem_io_ops {
+	u32 (*read32)(void __iomem *addr);
+	void (*write32)(u32 value, void __iomem *addr);
+};
+
+struct training_status {
+	bool done_training;
+	bool remote_tx_complete;
+	bool remote_tx_running;
+	bool sent_init;
+	bool lp_rx_ready;
+	bool local_tx_running;
+};
+
+struct kr_mdio_info {
+	/* MDIO_XFI_PMD Registers */
+	int lt_devad;
+	u32 pmd_ctrl_1;
+	/* MDIO_XFI_PMD LT Registers */
+	u32 lt_kr_pmd_control;
+	u32 lt_kr_pmd_status;
+	u32 lt_kr_lp_cu;
+	u32 lt_kr_lp_status;
+	u32 lt_kr_ld_cu;
+	u32 lt_kr_ld_status;
+	u32 lt_prbs_berr_lower;
+	u32 lt_prbs_berr_upper;
+	/* MDIO_XFI_AN Registers: MMD 7 */
+	u32 an_control;
+	u32 an_status;
+	u32 an_ad_ability_0;
+	u32 an_ad_ability_1;
+	u32 an_lp_base_page_ability_1;
+	u32 an_bp_eth_status;
+	/* MDIO AN register ops */
+	u32 (*get_an_bp_eth_status_bit)(phy_interface_t bp_mode);
+	u32 (*get_an_ad_ability_1_init)(phy_interface_t bp_mode);
+};
+
+/* Backplane device info */
+struct backplane_dev_info {
+	u32 cm_min;
+	u32 cm_max;
+	u32 cz_min;
+	u32 cz_max;
+	u32 cp_min;
+	u32 cp_max;
+	u32 sum_ratio_numer;
+	u32 sum_ratio_denom;
+	u32 cm_def;
+	u32 cz_def;
+	u32 cp_def;
+	u32 amp_red_def;
+	bool coef_def_dt; /* defaults for eq coef initialized from DT */
+	bool ampr_def_dt; /* defaults for amp red initialized from DT */
+	bool is_little_endian; /* serdes endianness */
+	u32 base_addr;		/* serdes base address */
+	u32 memmap_size;	/* serdes memory map size */
+	const char *eqa_name; /* EQ algorithm name */
+	struct mem_io_ops io;
+	const struct lane_io_ops *lane_ops;
+	const struct equalizer_info *equalizer;
+	struct kr_mdio_info mdio;
+};
+
+struct backplane_phy_info;
+
+/* KR Lane info */
+struct kr_lane_info {
+	/* generic KR data */
+	void __iomem *reg_base;	/* lane memory map: registers base address */
+	u32 memmap_size;	/* lane memory map size */
+	u32 lane_addr;		/* lane address */
+	u8 idx;			/* lane relative index inside multi-lane PHY */
+	struct phy_device *bpphy; /* backplane phy device */
+	struct backplane_phy_info *bp_phy;
+	const struct equalization_algorithm *eq_alg;
+	struct eq_data_priv *eq_priv;
+	struct training_status trst;
+	struct delayed_work kr_wk;
+	/* mutex for multiple lanes training case */
+	struct mutex lane_lock;
+	enum train_state state;
+	/* KR LD/LP updates and status */
+	u32 ld_update;
+	u32 prev_ld_update;
+	u32 ld_last_nonhold_update; /* last change (non-hold) update */
+	u32 ld_status;
+	u32 lp_status;
+	u32 lp_last_change_status; /* last change (non-zero) status */
+	u32 last_lp_update_status[C_NO];
+	/* training status data */
+	bool lt_error;
+	bool move_back_prev;
+	u32 move_back_cnt;
+	u32 move_back_lp_status;
+	u32 req_ld_update_init_count;
+	u32 repeat_request_count;
+	u64 init_handshake_time;
+	bool first_recv_init;
+	bool an_acquired;
+	u32 an_wait_count;
+	u64 rt_time;
+	/* KR parameters (current, default, tunned) */
+	u32 ratio_preq;
+	u32 ratio_pstq;
+	u32 adpt_eq;
+	u32 def_ratio_preq;
+	u32 def_ratio_pstq;
+	u32 def_adpt_eq;
+	u32 def_amp_red;
+	u32 tuned_ratio_preq;
+	u32 tuned_ratio_pstq;
+	u32 tuned_adpt_eq;
+};
+
+struct backplane_phy_info {
+	phy_interface_t bp_mode;
+	u8 num_lanes;
+	bool aneg_config;
+	bool aneg_done;
+	bool phy_suspended;
+	struct backplane_dev_info bp_dev;
+	struct kr_lane_info krln[MAX_KR_LANES_PER_PHY];
+	/* bpphy mutexes */
+	struct mutex bpphy_lock;
+	/* mutex between multiple lanes training */
+	struct mutex trained_lock;
+};
+
+bool backplane_is_mode_kr(phy_interface_t bp_mode);
+
+bool backplane_is_valid_mode(phy_interface_t bp_mode);
+
+u8 backplane_num_lanes(phy_interface_t bp_mode);
+
+bool backplane_is_single_lane(struct backplane_phy_info *bp_phy);
+
+bool backplane_is_multi_lane(struct backplane_phy_info *bp_phy);
+
+int backplane_is_link_up(struct phy_device *bpphy);
+
+void backplane_setup_mdio_c45(struct backplane_dev_info *bp_dev);
+
+void backplane_setup_kr_lt_mmd(struct backplane_dev_info *bp_dev, int devad,
+			       u32 base);
+
+int backplane_read_mmd(struct kr_lane_info *krln, int devad, u32 regnum);
+
+int backplane_write_mmd(struct kr_lane_info *krln, int devad, u32 regnum,
+			u16 val);
+
+void backplane_default_kr_lane(struct kr_lane_info *krln);
+
+void backplane_get_current_taps(struct kr_lane_info *krln, u32 *coef);
+
+void backplane_set_current_taps(struct kr_lane_info *krln, u32 *coef);
+
+void backplane_set_all_taps_to_max(struct kr_lane_info *krln);
+
+void backplane_tune_kr_lane(struct kr_lane_info *krln, bool reset_lane);
+
+int backplane_are_all_lanes_trained(struct backplane_phy_info *bp_phy);
+
+int backplane_get_lanes_trained_count(struct backplane_phy_info *bp_phy);
+
+/* generic main operations to be used on probe callback */
+
+int backplane_create(struct phy_device *bpphy);
+
+int backplane_parse_dt(struct phy_device *bpphy);
+
+int backplane_setup_mdio(struct phy_device *bpphy);
+
+int backplane_setup_lanes(struct phy_device *bpphy);
+
+int backplane_initialize(struct phy_device *bpphy);
+
+/* predefined phy_driver callback functions */
+
+int backplane_probe(struct phy_device *bpphy);
+
+void backplane_remove(struct phy_device *bpphy);
+
+int backplane_config_init(struct phy_device *bpphy);
+
+int backplane_aneg_done(struct phy_device *bpphy);
+
+int backplane_config_aneg(struct phy_device *bpphy);
+
+int backplane_suspend(struct phy_device *bpphy);
+
+int backplane_resume(struct phy_device *bpphy);
+
+int backplane_read_status(struct phy_device *bpphy);
+
+int backplane_match_phy_device(struct phy_device *bpphy);
+
+#endif /* __BACKPLANE_H */
diff --git a/drivers/net/phy/backplane/eq_fixed.c b/drivers/net/phy/backplane/eq_fixed.c
new file mode 100644
index 0000000..5244cec
--- /dev/null
+++ b/drivers/net/phy/backplane/eq_fixed.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Fixed: No Equalization algorithm
+ *
+ * Copyright 2019-2020 NXP
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "equalization.h"
+
+#define ALGORITHM_NAME		"backplane_fixed"
+#define ALGORITHM_DESCR		"Fixed Equalization"
+#define ALGORITHM_VERSION	"1.0.0"
+
+/* Fixed Algorithm API */
+
+/* Create Fixed Equalization Algorithm */
+static struct eq_data_priv *create(struct eq_setup_info setup)
+{
+	return NULL;
+}
+
+static const struct equalization_algorithm eq_alg = {
+	.name = ALGORITHM_NAME,
+	.descr = ALGORITHM_DESCR,
+	.version = ALGORITHM_VERSION,
+	.use_local_tx_training = false,
+	.use_remote_tx_training = false,
+	.ops = {
+		.create = create,
+		.destroy = NULL,
+		.is_rx_ok = NULL,
+		.is_eq_done = NULL,
+		.collect_statistics = NULL,
+		.generate_request = NULL,
+		.process_bad_state = NULL,
+		.dump_algorithm_context = NULL,
+	}
+};
+
+static const char * const alg_keys[] = {
+	DEFAULT_EQ_ALGORITHM,
+	"bypass",
+};
+
+static int __init fixed_init(void)
+{
+	int i, err;
+
+	pr_info("%s: %s algorithm version %s\n",
+		ALGORITHM_NAME, ALGORITHM_DESCR, ALGORITHM_VERSION);
+
+	/* register Fixed algorithm: */
+	for (i = 0; i < ARRAY_SIZE(alg_keys); i++) {
+		err = backplane_eq_register(alg_keys[i], &eq_alg);
+		if (err) {
+			pr_err("%s: '%s' equalization algorithm registration failed\n",
+			       ALGORITHM_NAME, alg_keys[i]);
+		}
+	}
+
+	return 0;
+}
+
+static void __exit fixed_exit(void)
+{
+	int i;
+
+	/* unregister Fixed algorithm: */
+	for (i = 0; i < ARRAY_SIZE(alg_keys); i++)
+		backplane_eq_unregister(alg_keys[i]);
+
+	pr_info("%s: %s algorithm version %s unloaded\n",
+		ALGORITHM_NAME, ALGORITHM_DESCR, ALGORITHM_VERSION);
+}
+
+module_init(fixed_init);
+module_exit(fixed_exit);
+
+MODULE_DESCRIPTION("Fixed Equalization Algorithm");
+MODULE_AUTHOR("Florinel Iordache <florinel.iordache@nxp.com>");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/phy/backplane/equalization.h b/drivers/net/phy/backplane/equalization.h
new file mode 100644
index 0000000..167c9f1
--- /dev/null
+++ b/drivers/net/phy/backplane/equalization.h
@@ -0,0 +1,282 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Equalization interface
+ * for Equalization and Link Training (IEEE802.3ap/ba)
+ *
+ * Copyright 2019-2020 NXP
+ */
+
+#ifndef __EQUALIZATION_H
+#define __EQUALIZATION_H
+
+#include <linux/phy.h>
+
+/* Default equalization algorithm */
+#define DEFAULT_EQ_ALGORITHM			"fixed"
+
+struct kr_lane_info;
+struct eq_setup_info;
+
+/* EQ Algorithms Interface used by Link Training
+ * to call equalization algorithms callbacks
+ */
+
+/* Equalization private data
+ * specifically defined by each algorithm to be used internally
+ */
+struct eq_data_priv;
+
+/* Equalization Algorithm operations */
+struct equalization_ops {
+	/* Mandatory operations: */
+	struct eq_data_priv *(*create)(struct eq_setup_info setup);
+	void (*destroy)(struct eq_data_priv *priv);
+	/* Required operations for remote Tx link training: */
+	bool (*is_rx_ok)(struct eq_data_priv *priv);
+	bool (*is_eq_done)(struct eq_data_priv *priv);
+	bool (*collect_statistics)(struct eq_data_priv *priv);
+	void (*generate_request)(struct eq_data_priv *priv);
+	/* Optional operations: */
+	void (*process_bad_state)(struct eq_data_priv *priv);
+	void (*dump_algorithm_context)(struct eq_data_priv *priv);
+};
+
+/* Equalization Algorithm description data */
+struct equalization_algorithm {
+	const char *name;
+	const char *descr;
+	const char *version;
+	bool use_local_tx_training;
+	bool use_remote_tx_training;
+	struct equalization_ops ops;
+};
+
+/* Equalizer Interface for EQ Algorithms:
+ * Used by equalization algorithms to collect equalizer statistics
+ * required to take correct decisions for tuning equalization parameters
+ */
+
+/* Equalizer counters type
+ *
+ * Equalizer Binning Counters for Data Dependent Edge Statistics:
+ *
+ *   Bin(s) = (# late edges - # early edges)
+ *            Prior/Next Edge at T -/+ #UI (Unit Interval)
+ *   Bin_1: 1UI wide pulses: Prior Edge at T - 1UI
+ *      final edges on short pulses:
+ *      - contains the scoring of final edges on pulses that are 1UI long
+ *      - represents the difference between the number of short pulse late edges
+ *        and the number of short pulse early edges
+ *   Bin_2: 2UI wide pulses: Prior Edge at T - 2UI
+ *   Bin_3: 3UI (or >=3UI) wide pulses: Prior Edge at T - 3UI (or T - >=3UI)
+ *   Bin_4: 4UI (or >=4UI) wide pulses: Prior Edge at T - 4UI (or T - >=4UI)
+ *   Bin_Med: >=5UI and <=7UI wide pulses:
+ *      Prior Edge in between T - >=5UI and T - <=7UI
+ *      final edges on medium pulses:
+ *      - contains the scoring of final edges on pulses between 5UI and 7UI long
+ *   Bin_Long: >=8UI wide pulses: Prior Edge at T - >=8UI
+ *      final edges on long pulses:
+ *      - contains the scoring of final edges on pulses longer than 7UI long
+ *      - represents the difference between the number of long pulse late edges
+ *        and the number of long pulse early edges
+ *   Bin_M1: 1UI wide pulses: Next Edge at T + 1UI
+ *      initial edges on short pulses following non-single bits:
+ *      - contains the scoring of initial edges on pulses that are 1UI long
+ *        following non-single bits
+ *      - the next edge is 1UI away and prior edge is more than 1UI away
+ *   Bin_M2: 2UI wide pulses: Next Edge at T + 2UI
+ *   Bin_M3: 3UI (or >=3UI) wide pulses: Next Edge at T + 3UI (or T + >=3UI)
+ *   Bin_M4: 4UI (or >=4UI) wide pulses: Next Edge at T + 4UI (or T + >=4UI)
+ *   Bin_MMed: >=5UI and <=7UI wide pulses:
+ *      Next Edge in between T + >=5UI and T + <=7UI
+ *      initial edges on medium pulses following non-single bits:
+ *      - contains the scoring of initial edges on pulses between 5UI and 7UI
+ *      following non-single bits
+ *   Bin_MLong: >=8UI wide pulses: Next Edge at T + >=8UI
+ *      initial edges on long pulses following non-single bits:
+ *      - contains the scoring of initial edges on pulses longer than 7UI long
+ *      - represents the difference between the number of long pulse late edges
+ *        and the number of long pulse early edges
+ *
+ *   Bin_Offset = [(# late rising edges + # early falling edges) -
+ *                 (# early rising edges + # late falling edges)]
+ *      - contains the transition information for the difference between
+ *        all bits that are narrower than expected and
+ *        all bits that are wider than expected
+ *
+ *   Bin_Avg: Low Pass Filter of Running Disparity
+ *      - Bin_Avg provides a time weighted, filtered average of disparity which
+ *        indicates the BLW potential of recently received data
+ *        New Bin_Avg = Bin_Avg - Bin_Avg/8 + block_disparity
+ *                      where block_disparity = (#of ones - #of zeros)
+ *
+ *   Bin_BLW: Bin Baseline Wander
+ *      - BinBLW accumulates the correlation between Bin_Avg and Bin_Offset
+ *      - Low frequency deficiency (LFD) causes BLW effect
+ *        New Bin_BLW = Bin_BLW + Bin_Avg, for Bin_Offset > 0
+ *                    = Bin_BLW - Bin_Avg, for Bin_Offset < 0
+ *                    = Bin_BLW,           for Bin_Offset = 0
+ *
+ * Equalizer gains:
+ *   GAIN_LF: Low-frequency gain of the equalizer amplifier
+ *   GAIN_MF: Middle-frequency gain of the equalizer amplifier
+ *   GAIN_HF: High-frequency gain of the equalizer amplifier
+ *
+ * Equalizer status:
+ *   EQOFFSET: equalization offset status
+ *      Binary coded status of RX Adaptive Equalization offset controls of lane
+ */
+enum eqc_type {
+	EQC_BIN_1,
+	EQC_BIN_2,
+	EQC_BIN_3,
+	EQC_BIN_4,
+	EQC_BIN_MED,
+	EQC_BIN_LONG,
+	EQC_BIN_M1,
+	EQC_BIN_M2,
+	EQC_BIN_M3,
+	EQC_BIN_M4,
+	EQC_BIN_MMED,
+	EQC_BIN_MLONG,
+	EQC_BIN_OFFSET,
+	EQC_BIN_AVG,
+	EQC_BIN_BLW,
+	EQC_GAIN_LF,
+	EQC_GAIN_MF,
+	EQC_GAIN_HF,
+	EQC_EQOFFSET,
+};
+
+/* Equalizer counters range */
+struct eqc_range {
+	s16 min;
+	s16 max;
+	s16 mid_low;
+	s16 mid_high;
+};
+
+/* Equalizer counters collection operations */
+struct equalizer_ops {
+	int (*collect_counters)(void *reg, enum eqc_type type, s16 *counters,
+				u8 size);
+	int (*collect_multiple_counters)(void *reg, enum eqc_type type[],
+					 u8 type_no, s16 *counters, u8 size);
+	struct eqc_range *(*get_counter_range)(enum eqc_type type);
+};
+
+/* Equalizer info and operations */
+struct equalizer_info {
+	const char *name;
+	const char *version;
+	struct equalizer_ops ops;
+};
+
+/* Equalization setup information */
+struct eq_setup_info {
+	struct phy_device *bpphy;
+	/* kr lane info used as parameter for link training API */
+	struct kr_lane_info *krlane;
+	void *reg_base;
+	struct equalizer_info equalizer;
+};
+
+/* Link Training Interface used by EQ Algorithms
+ * to interact with IEEE802.3ap/ba standards
+ */
+
+/* update request type
+ * Identifies the LP update request type according to IEEE802.3ap-2007
+ * which must be sent to LP to request coefficients update
+ *
+ * HOLD: Request LP to Hold all coefficients update
+ * INC: Request LP to Increment the specified coefficient
+ * DEC: Request LP to Decrement the specified coefficient
+ * INIT: Request LP to Initialize all coefficients
+ * PRESET: Request LP to set all coefficients to Preset
+ * INVALID: Invalid request type: should not be used as LP request
+ */
+enum req_type {
+	REQ_HOLD,
+	REQ_INC,
+	REQ_DEC,
+	REQ_INIT,
+	REQ_PRESET,
+	REQ_INVALID
+};
+
+/* coefficient field
+ * Identifies the coefficient field on which must take a desired action
+ * according to IEEE802.3ap-2007
+ *
+ * coefficients:
+ *  M1: C(-1): Pre-cursor
+ *  Z0: C(0):  Main cursor
+ *  P1: C(+1): Post-cursor
+ *  NO: Number of coefficients (this is not a valid coefficient field)
+ */
+enum coef_field {
+	C_M1,
+	C_Z0,
+	C_P1,
+	C_NO
+};
+
+/* coefficient status
+ * Specifies the coefficient status according to IEEE802.3ap-2007:
+ * 72.6.10.2.5 Coefficient update process
+ *
+ * NOTUPDATED: Coefficient is not updated
+ * UPDATED: Coefficient is updated
+ * MIN: Coefficient has reached the minimum threshold
+ * MAX: Coefficient has reached the maximum threshold
+ * INVALID: Invalid coefficient status
+ */
+enum coef_status {
+	COEF_NOTUPDATED,
+	COEF_UPDATED,
+	COEF_MIN,
+	COEF_MAX,
+	COEF_INVALID
+};
+
+void lt_lp_update(struct kr_lane_info *krln, u32 update);
+
+u32 lt_encode_request(u32 base_update, enum req_type req,
+		      enum coef_field field);
+
+u32 lt_encode_startup_request(enum req_type req);
+
+enum req_type lt_decode_coef_update(u32 update, enum coef_field field);
+
+bool lt_is_update_of_type(u32 update, enum req_type type);
+
+bool lt_is_lp_at_startup(struct kr_lane_info *krln, enum req_type type);
+
+enum coef_status lt_get_lp_coef_status(struct kr_lane_info *krln,
+				       enum coef_field field);
+
+void lt_move_lp_back(struct kr_lane_info *krln);
+
+void lt_set_error(struct kr_lane_info *krln, bool err);
+
+/* Backplane Driver Interface for EQ Algorithms:
+ * Used by equalization algorithms to interact
+ * with backplane driver during equalization
+ */
+
+/* equalization algorithm registration */
+int backplane_eq_register(const char *key,
+			  const struct equalization_algorithm *eq_info);
+void backplane_eq_unregister(const char *key);
+
+bool backplane_is_cdr_lock(struct kr_lane_info *krln, bool retry);
+
+void bpdev_err(struct phy_device *bpphy, char *msg, ...);
+
+void bpdev_warn(struct phy_device *bpphy, char *msg, ...);
+
+void bpdev_info(struct phy_device *bpphy, char *msg, ...);
+
+void bpdev_dbg(struct phy_device *bpphy, char *msg, ...);
+
+#endif /* __EQUALIZATION_H */
diff --git a/drivers/net/phy/backplane/link_training.c b/drivers/net/phy/backplane/link_training.c
new file mode 100644
index 0000000..2afecd4
--- /dev/null
+++ b/drivers/net/phy/backplane/link_training.c
@@ -0,0 +1,1604 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Link Training (IEEE802.3ap/ba)
+ * Ethernet Operation over Electrical Backplanes
+ *
+ * Copyright 2019-2020 NXP
+ */
+
+#include <linux/mdio.h>
+#include <linux/timer.h>
+#include <linux/delay.h>
+
+#include "link_training.h"
+
+/* KR LP/LD Coefficients */
+#define PRESET_MASK			0x2000
+#define INIT_MASK			0x1000
+#define COP1_MASK			0x30
+#define COP1_SHIFT			4
+#define COZ0_MASK			0xc
+#define COZ0_SHIFT			2
+#define COM1_MASK			0x3
+#define COM1_SHIFT			0
+#define ALL_COEF_MASK		(COP1_MASK | COZ0_MASK | COM1_MASK)
+#define LD_ALL_MASK		(PRESET_MASK | INIT_MASK | ALL_COEF_MASK)
+
+/* KR LP Status Report */
+#define LP_STATUS_ALL_COEF_UPDATED	0x15
+
+/* KR LP/LD Status Report:
+ * RX_READY_MASK - Receiver Ready
+ * 0b - The LP/LD receiver is requesting that training continue
+ * 1b - The LP/LD receiver has determined that training is complete
+ * and is prepared to receive data.
+ */
+#define RX_READY_MASK			0x8000
+
+/* Increment/Decrement Requests */
+#define HOLD					0
+#define INCREMENT				1
+#define DECREMENT				2
+#define RESERVED				3
+
+/* Increment/Decrement Steps */
+#define STEP_INCREMENT_P1			-1
+#define STEP_INCREMENT_Z0			1
+#define STEP_INCREMENT_M1			-1
+
+/* KR PMD Control defines */
+#define TRAIN_EN				0x3
+#define TRAIN_DISABLE				0x1
+#define PMD_RESET				0x1
+
+/* KR PMD Status defines */
+#define PMD_STATUS_TRAIN_FAIL			0x8
+#define PMD_STATUS_SUP_STAT			0x4
+#define PMD_STATUS_FRAME_LOCK			0x2
+#define PMD_STATUS_RX_STAT			0x1
+
+/* KR PMD control register (Register 1.150) */
+#define REGISTER_KR_PMD_CTRL			150
+
+/* Link training KR PMD registers offsets */
+#define OFFSET_KR_PMD_CTRL			0x0
+#define OFFSET_KR_PMD_STATUS			0x1
+#define OFFSET_KR_LP_CU				0x2
+#define OFFSET_KR_LP_STATUS			0x3
+#define OFFSET_KR_LD_CU				0x4
+#define OFFSET_KR_LD_STATUS			0x5
+#define OFFSET_KR_PRBS_BERR_LOWER		0x7F6B
+#define OFFSET_KR_PRBS_BERR_UPPER		0x7F6C
+
+/* Timeouts */
+#define TIMEOUT_MOVE_BACK_PREV			6
+#define TIMEOUT_REPEAT_REQUEST			10
+
+/* Backplane Ethernet status (Register 7.48) */
+#define AN_BP_ETH_STATUS_OFFSET			0x30
+
+/* AN registers initialization */
+#define AN_CTRL_INIT				0x1200
+
+/* Training for Remote Tx */
+
+static u32 get_mask_for_req(enum req_type req)
+{
+	u32 cmd = HOLD;
+
+	switch (req) {
+	case REQ_HOLD:
+		cmd = HOLD;
+		break;
+	case REQ_INC:
+		cmd = INCREMENT;
+		break;
+	case REQ_DEC:
+		cmd = DECREMENT;
+		break;
+	case REQ_INIT:
+		cmd = INIT_MASK;
+		break;
+	case REQ_PRESET:
+		cmd = PRESET_MASK;
+		break;
+	case REQ_INVALID:
+		cmd = RESERVED;
+		break;
+	default:
+		cmd = HOLD;
+		break;
+	}
+	return cmd;
+}
+
+static enum req_type get_req_for_mask(u32 cmd)
+{
+	enum req_type req = REQ_HOLD;
+
+	switch (cmd) {
+	case HOLD:
+		req = REQ_HOLD;
+		break;
+	case INCREMENT:
+		req = REQ_INC;
+		break;
+	case DECREMENT:
+		req = REQ_DEC;
+		break;
+	case INIT_MASK:
+		req = REQ_INIT;
+		break;
+	case PRESET_MASK:
+		req = REQ_PRESET;
+		break;
+	case RESERVED:
+		req = REQ_INVALID;
+		break;
+	default:
+		req = REQ_HOLD;
+		break;
+	}
+	return req;
+}
+
+/* ld_coef_status
+ * 72.6.10.2.5 Coefficient update process
+ * Once the updated, maximum, or minimum state is reported it continues
+ * to be reported until a hold request is received,
+ * after which the status reverts to not_updated.
+ */
+static void ld_coef_status(struct kr_lane_info *krln)
+{
+	backplane_write_mmd(krln, krln->bp_phy->bp_dev.mdio.lt_devad,
+			    krln->bp_phy->bp_dev.mdio.lt_kr_ld_status,
+			    krln->ld_status);
+}
+
+/* ld_coef_update
+ * LD sends to LP the specified request for coefficients update
+ */
+static void ld_coef_update(struct kr_lane_info *krln)
+{
+	backplane_write_mmd(krln, krln->bp_phy->bp_dev.mdio.lt_devad,
+			    krln->bp_phy->bp_dev.mdio.lt_kr_ld_cu,
+			    krln->ld_update);
+}
+
+/* get_lp_lcs
+ * get LP lcs (last change status)
+ * returns the last LP change (non-zero) status:
+ * meaning the last LP status resulted from a change request
+ * 72.6.10.2.5 Coefficient update process
+ * Once the updated, maximum, or minimum state is reported it continues
+ * to be reported until a hold request is received,
+ * after which the status reverts to not_updated.
+ */
+static u32 get_lp_lcs(struct kr_lane_info *krln)
+{
+	return krln->lp_last_change_status;
+}
+
+static bool is_all_status(u32 status, enum coef_status cs)
+{
+	return ((status & ALL_COEF_MASK) ==
+		(cs << COP1_SHIFT | cs << COZ0_SHIFT | cs << COM1_SHIFT));
+}
+
+/* Training for Local Tx */
+
+static void initialize(struct kr_lane_info *krln)
+{
+	backplane_default_kr_lane(krln);
+
+	krln->ld_status &= ~ALL_COEF_MASK;
+	krln->ld_status |= COEF_UPDATED << COP1_SHIFT |
+			   COEF_UPDATED << COZ0_SHIFT |
+			   COEF_UPDATED << COM1_SHIFT;
+
+	ld_coef_status(krln);
+}
+
+/* preset
+ * Preset as defined by: IEEE 802.3, sub-clause 72.6.10.2.3.1
+ * Setup all coefficients to MAX values from IEEE802.3 perspective
+ */
+static void preset(struct kr_lane_info *krln)
+{
+	backplane_set_all_taps_to_max(krln);
+
+	backplane_tune_kr_lane(krln, true);
+
+	krln->ld_status &= ~ALL_COEF_MASK;
+	krln->ld_status |= COEF_MAX << COP1_SHIFT |
+			   COEF_MAX << COZ0_SHIFT |
+			   COEF_MAX << COM1_SHIFT;
+
+	ld_coef_status(krln);
+}
+
+static bool is_rx_ready(u32 status)
+{
+	return ((status & RX_READY_MASK) != 0);
+}
+
+/* is_ld_valid
+ * LD coefficient values have hardware restrictions
+ * Check if all ld coefficients are in range
+ */
+static int is_ld_valid(struct kr_lane_info *krln, u32 *ld_coef)
+{
+	u32 ratio_pstq = ld_coef[C_P1];
+	u32 adpt_eq = ld_coef[C_Z0];
+	u32 ratio_preq = ld_coef[C_M1];
+	struct backplane_dev_info *bp_dev = &krln->bp_phy->bp_dev;
+
+	/* HW restrictions:
+	 * Section 5.3.1 10GBaseKR Transmit Adaptive Equalization Control
+	 * additional restrictions set down by 802.3 specification Clause 72,
+	 * specifically 72.7.1.11 Transmitter output waveform requirements
+	 *
+	 * Maintaining the following relationships limit transmit equalization
+	 * to reasonable levels compliant with the KR specification
+	 */
+
+	/* 1. [condition (1) was moved below for optimization purpose] */
+
+	/* Basic HW restrictions: */
+
+	/* 2. tx_ratio_preq <= MIN_C(-1) */
+	if (ratio_preq > bp_dev->cm_min)
+		return -ERANGE;
+	/* 3. tx_ratio_post1q <= MIN_C(+1) */
+	if (ratio_pstq > bp_dev->cp_min)
+		return -ERANGE;
+	/* 4. MIN_C(0) <= tx_adpt_eq <= MAX_C(0) */
+	if (adpt_eq < bp_dev->cz_min)
+		return -ERANGE;
+	if (adpt_eq > bp_dev->cz_max)
+		return -ERANGE;
+	/* 5. tx_ratio_post1q >= tx_ratio_preq */
+	if (ratio_pstq < ratio_preq)
+		return -ERANGE;
+
+	/* Additional HW restrictions:
+	 * 1. MIN_C(0) <= tx_ratio_preq + tx_adpt_eq +
+	 *                                tx_ratio_post1q <= MAX_C(0)
+	 */
+	if ((ratio_preq + ratio_pstq + adpt_eq) < bp_dev->cz_min)
+		return -ERANGE;
+	if ((ratio_preq + ratio_pstq + adpt_eq) > bp_dev->cz_max)
+		return -ERANGE;
+	/* 6.
+	 * ( tx_adpt_eq + tx_ratio_preq + tx_ratio_post1q ) /
+	 * ( tx_adpt_eq - tx_ratio_preq - tx_ratio_post1q ) <
+	 *    sum_ratio_numerator / sum_ratio_denominator
+	 */
+	if (((adpt_eq + ratio_preq + ratio_pstq) * bp_dev->sum_ratio_denom) >=
+	    ((adpt_eq - ratio_preq - ratio_pstq) * bp_dev->sum_ratio_numer))
+		return -ERANGE;
+
+	return 0;
+}
+
+static bool update_ld_status(struct kr_lane_info *krln, enum coef_field field,
+			     enum coef_status cs)
+{
+	u32 mask, val;
+	u32 ld_cs = cs;
+
+	if (cs == COEF_INVALID)
+		return false;
+
+	switch (field) {
+	case C_P1:
+		mask = COP1_MASK;
+		val = ld_cs << COP1_SHIFT;
+		break;
+	case C_Z0:
+		mask = COZ0_MASK;
+		val = ld_cs << COZ0_SHIFT;
+		break;
+	case C_M1:
+		mask = COM1_MASK;
+		val = ld_cs << COM1_SHIFT;
+		break;
+	default:
+		return false;
+	}
+
+	krln->ld_status &= ~mask;
+	krln->ld_status |= val;
+
+	return true;
+}
+
+static enum coef_status inc_dec(struct kr_lane_info *krln,
+				enum coef_field field, int request)
+{
+	u32 ld_coef[C_NO], step[C_NO], ld_limit[C_NO];
+	int err;
+
+	backplane_get_current_taps(krln, ld_coef);
+
+	step[C_P1] = STEP_INCREMENT_P1;
+	step[C_Z0] = STEP_INCREMENT_Z0;
+	step[C_M1] = STEP_INCREMENT_M1;
+
+	/* 72.6.10.2.5 Coefficient update process
+	 * Upon execution of a received increment or decrement request,
+	 * the status is reported as updated, maximum, or minimum.
+	 */
+	switch (request) {
+	case INCREMENT:
+		ld_limit[C_P1] = krln->bp_phy->bp_dev.cp_max;
+		ld_limit[C_Z0] = krln->bp_phy->bp_dev.cz_max;
+		ld_limit[C_M1] = krln->bp_phy->bp_dev.cm_max;
+		if (ld_coef[field] != ld_limit[field])
+			ld_coef[field] += step[field];
+		else
+			return COEF_MAX;
+		break;
+	case DECREMENT:
+		ld_limit[C_P1] = krln->bp_phy->bp_dev.cp_min;
+		ld_limit[C_Z0] = krln->bp_phy->bp_dev.cz_min;
+		ld_limit[C_M1] = krln->bp_phy->bp_dev.cm_min;
+		if (ld_coef[field] != ld_limit[field])
+			ld_coef[field] -= step[field];
+		else
+			return COEF_MIN;
+		break;
+	default:
+		break;
+	}
+
+	err = is_ld_valid(krln, ld_coef);
+	if (!err) {
+		/* accept new ld coefficients */
+		backplane_set_current_taps(krln, ld_coef);
+		backplane_tune_kr_lane(krln, false);
+	} else {
+		if (request == DECREMENT)
+			return COEF_MIN;
+		if (request == INCREMENT)
+			return COEF_MAX;
+	}
+
+	/* UPDATED */
+	return COEF_UPDATED;
+}
+
+static void check_request(struct kr_lane_info *krln, int request)
+{
+	int cop1_req, coz0_req, com1_req;
+	int old_status;
+	enum coef_status cu = COEF_INVALID;
+
+	cop1_req = (request & COP1_MASK) >> COP1_SHIFT;
+	coz0_req = (request & COZ0_MASK) >> COZ0_SHIFT;
+	com1_req = (request & COM1_MASK) >> COM1_SHIFT;
+
+	/* IEEE802.3-2008, 72.6.10.2.5
+	 * Ensure we only act on INCREMENT/DECREMENT when we are in NOT UPDATED
+	 *
+	 * 72.6.10.2.5 Coefficient update process
+	 * An increment or decrement request will only be acted upon when
+	 * the state of the tap is not_updated.
+	 */
+	old_status = krln->ld_status;
+
+	if (cop1_req && !(krln->ld_status & COP1_MASK)) {
+		cu = inc_dec(krln, C_P1, cop1_req);
+		update_ld_status(krln, C_P1, cu);
+	}
+
+	if (coz0_req && !(krln->ld_status & COZ0_MASK)) {
+		cu = inc_dec(krln, C_Z0, coz0_req);
+		update_ld_status(krln, C_Z0, cu);
+	}
+
+	if (com1_req && !(krln->ld_status & COM1_MASK)) {
+		cu = inc_dec(krln, C_M1, com1_req);
+		update_ld_status(krln, C_M1, cu);
+	}
+
+	if (old_status != krln->ld_status)
+		ld_coef_status(krln);
+}
+
+static void training_complete(struct kr_lane_info *krln)
+{
+	struct training_status *trst = &krln->trst;
+
+	/* update training status */
+	trst->remote_tx_complete = true;
+	trst->remote_tx_running = false;
+
+	/* report LD status */
+	krln->ld_status |= RX_READY_MASK;
+	ld_coef_status(krln);
+
+	/* update PMD status and tell LP we are ready */
+	backplane_write_mmd(krln, krln->bp_phy->bp_dev.mdio.lt_devad,
+			    krln->bp_phy->bp_dev.mdio.lt_kr_pmd_status,
+			    PMD_STATUS_RX_STAT);
+}
+
+/* Link Training general API */
+
+/* Setup standard KR LT memory map registers
+ * 45.2.1.76 10GBASE-KR PMD control register (Register 1.150)
+ */
+void lt_setup_c45(struct backplane_dev_info *bp_dev)
+{
+	bp_dev->mdio.an_bp_eth_status = AN_BP_ETH_STATUS_OFFSET;
+
+	lt_setup_memmap(bp_dev, MDIO_MMD_PMAPMD, REGISTER_KR_PMD_CTRL);
+}
+
+/* Setup KR LT memory map registers
+ * IEEE Std 802.3ap-2007: Table 45.3 PMA/PMD registers
+ */
+void lt_setup_memmap(struct backplane_dev_info *bp_dev, int devad, u32 base)
+{
+	bp_dev->mdio.lt_devad = devad;
+	bp_dev->mdio.lt_kr_pmd_control = base + OFFSET_KR_PMD_CTRL;
+	bp_dev->mdio.lt_kr_pmd_status = base + OFFSET_KR_PMD_STATUS;
+	bp_dev->mdio.lt_kr_lp_cu = base + OFFSET_KR_LP_CU;
+	bp_dev->mdio.lt_kr_lp_status = base + OFFSET_KR_LP_STATUS;
+	bp_dev->mdio.lt_kr_ld_cu = base + OFFSET_KR_LD_CU;
+	bp_dev->mdio.lt_kr_ld_status = base + OFFSET_KR_LD_STATUS;
+	bp_dev->mdio.lt_prbs_berr_lower = base + OFFSET_KR_PRBS_BERR_LOWER;
+	bp_dev->mdio.lt_prbs_berr_upper = base + OFFSET_KR_PRBS_BERR_UPPER;
+}
+
+/* lt_is_lp_rx_ready
+ * Reports if LP Receiver is ready
+ * false: The LP receiver is requesting that training continue
+ * true: The LP receiver has determined that training is complete
+ * and is prepared to receive data.
+ */
+bool lt_is_lp_rx_ready(struct kr_lane_info *krln)
+{
+	struct kr_mdio_info *mdio = &krln->bp_phy->bp_dev.mdio;
+
+	/* Read LP Status */
+	krln->lp_status = backplane_read_mmd(krln,
+					     mdio->lt_devad,
+					     mdio->lt_kr_lp_status);
+	return is_rx_ready(krln->lp_status);
+}
+
+/* lt_is_ld_rx_ready
+ * Reports if LD Receiver is ready
+ * false: The LD receiver is requesting that training continue
+ * true: The LD receiver has determined that training is complete
+ * and is prepared to receive data.
+ */
+bool lt_is_ld_rx_ready(struct kr_lane_info *krln)
+{
+	return is_rx_ready(krln->ld_status);
+}
+
+void lt_start(struct kr_lane_info *krln)
+{
+	backplane_write_mmd(krln, krln->bp_phy->bp_dev.mdio.lt_devad,
+			    krln->bp_phy->bp_dev.mdio.lt_kr_pmd_control,
+			    TRAIN_EN);
+}
+
+void lt_stop(struct kr_lane_info *krln)
+{
+	backplane_write_mmd(krln, krln->bp_phy->bp_dev.mdio.lt_devad,
+			    krln->bp_phy->bp_dev.mdio.lt_kr_pmd_control,
+			    TRAIN_DISABLE);
+}
+
+void lt_reset(struct kr_lane_info *krln)
+{
+	backplane_write_mmd(krln, krln->bp_phy->bp_dev.mdio.lt_devad,
+			    krln->bp_phy->bp_dev.mdio.pmd_ctrl_1, PMD_RESET);
+	backplane_write_mmd(krln, krln->bp_phy->bp_dev.mdio.lt_devad,
+			    krln->bp_phy->bp_dev.mdio.lt_kr_pmd_control,
+			    TRAIN_DISABLE);
+	backplane_write_mmd(krln, krln->bp_phy->bp_dev.mdio.lt_devad,
+			    krln->bp_phy->bp_dev.mdio.lt_kr_ld_cu, 0);
+	backplane_write_mmd(krln, krln->bp_phy->bp_dev.mdio.lt_devad,
+			    krln->bp_phy->bp_dev.mdio.lt_kr_ld_status, 0);
+	backplane_write_mmd(krln, krln->bp_phy->bp_dev.mdio.lt_devad,
+			    krln->bp_phy->bp_dev.mdio.lt_kr_pmd_status, 0);
+	backplane_write_mmd(krln, krln->bp_phy->bp_dev.mdio.lt_devad,
+			    krln->bp_phy->bp_dev.mdio.lt_kr_lp_cu, 0);
+	backplane_write_mmd(krln, krln->bp_phy->bp_dev.mdio.lt_devad,
+			    krln->bp_phy->bp_dev.mdio.lt_kr_lp_status, 0);
+}
+
+/* lt_is_rx_trained
+ * IEEE Std 802.3ap-2007: Table 72.3 MDIO/PMD status variable mapping
+ * PMD status variable: rx_trained
+ */
+bool lt_is_rx_trained(struct kr_lane_info *krln)
+{
+	struct phy_device *bpphy = krln->bpphy;
+	int val;
+	int timeout = 100;
+
+	val = backplane_read_mmd(krln, krln->bp_phy->bp_dev.mdio.lt_devad,
+				 krln->bp_phy->bp_dev.mdio.lt_kr_pmd_status);
+
+	if ((val & PMD_STATUS_RX_STAT) && !(val & PMD_STATUS_TRAIN_FAIL)) {
+		while (timeout--) {
+			if (backplane_is_link_up(bpphy))
+				return true;
+
+			usleep_range(100, 500);
+		}
+	}
+	return false;
+}
+
+/* lt_is_training_failure
+ * IEEE Std 802.3ap-2007: Table 72.3 MDIO/PMD status variable mapping
+ * PMD status variable: PMD_fault
+ */
+bool lt_is_training_failure(struct kr_lane_info *krln)
+{
+	struct kr_mdio_info *mdio = &krln->bp_phy->bp_dev.mdio;
+	int lt_state;
+
+	lt_state = backplane_read_mmd(krln, mdio->lt_devad,
+				      mdio->lt_kr_pmd_status);
+
+	/* according to spec: 8023ap-2007.pdf
+	 * training_failure
+	 * Boolean variable that is set to TRUE when the training state machine
+	 * has timed out due to expiration of the max_wait_timer while in the
+	 * SEND_TRAINING, TRAIN_LOCAL, or
+	 * TRAIN_REMOTE states and is set to FALSE otherwise.
+	 */
+	if (lt_state & PMD_STATUS_TRAIN_FAIL)
+		return true;
+
+	return false;
+}
+
+/* lt_is_frame_lock
+ * IEEE Std 802.3ap-2007: Table 72.3 MDIO/PMD status variable mapping
+ * PMD status variable: frame_lock
+ */
+bool lt_is_frame_lock(struct kr_lane_info *krln)
+{
+	struct kr_mdio_info *mdio = &krln->bp_phy->bp_dev.mdio;
+	int lt_state;
+
+	lt_state = backplane_read_mmd(krln, mdio->lt_devad,
+				      mdio->lt_kr_pmd_status);
+
+	if ((lt_state & PMD_STATUS_SUP_STAT) &&
+	    (lt_state & PMD_STATUS_FRAME_LOCK))
+		return true;
+
+	return false;
+}
+
+void lt_start_an(struct kr_lane_info *krln)
+{
+	struct phy_device *bpphy = krln->bpphy;
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	struct kr_mdio_info *mdio = &bp_phy->bp_dev.mdio;
+	u32 an_ad_ability_1 = mdio->an_ad_ability_1;
+	u32 init_an_ad_ab1;
+	int i;
+	int err;
+
+	if (!backplane_is_mode_kr(bp_phy->bp_mode))
+		return;
+
+	if (!mdio->get_an_ad_ability_1_init) {
+		bpdev_err(bpphy, "Unknown AN_AD_ABILITY_1 init value\n");
+		return;
+	}
+
+	init_an_ad_ab1 = mdio->get_an_ad_ability_1_init(bp_phy->bp_mode);
+
+	if (krln->idx == MASTER_LANE) {
+		for (i = 0; i < bp_phy->num_lanes; i++) {
+			err = backplane_write_mmd(&bp_phy->krln[i], MDIO_MMD_AN,
+						  an_ad_ability_1,
+						  init_an_ad_ab1);
+			if (err)
+				bpdev_err(bpphy,
+					  "Setting AN register 0x%02x on lane %d failed with error code: 0x%08x\n",
+					  an_ad_ability_1,
+					  bp_phy->krln[i].idx, err);
+		}
+		udelay(1);
+		err = backplane_write_mmd(krln, MDIO_MMD_AN, mdio->an_control,
+					  AN_CTRL_INIT);
+		if (err)
+			bpdev_err(bpphy,
+				  "Setting AN register 0x%02x on Master Lane failed with error code: 0x%08x\n",
+				  MDIO_CTRL1, err);
+	}
+}
+
+/* Training for Remote Tx
+ * This is the main routine for Remote Tx training
+ */
+void lt_train_remote_tx(struct kr_lane_info *krln)
+{
+	struct training_status *trst = &krln->trst;
+	u32 prev_req_init, prev_req_preset;
+	u32 prev_req_cp1, prev_req_cz0, prev_req_cm1;
+	u32 status_cp1, status_cz0, status_cm1;
+	u64 lp_resp_time;
+
+	/* Check stop condition for Remote Tx training */
+	if (trst->remote_tx_complete)
+		return;
+
+	/* Check if equalization algorithm is installed */
+	if (!krln->eq_alg)
+		return;
+
+	/* Check that all required callback operations are installed */
+	if (!krln->eq_alg->ops.collect_statistics ||
+	    !krln->eq_alg->ops.is_rx_ok ||
+	    !krln->eq_alg->ops.generate_request ||
+	    !krln->eq_alg->ops.is_eq_done)
+		return;
+
+	/* Start new Remote Tx training step */
+	trst->remote_tx_running = true;
+
+	/* Store current state as previous state */
+	krln->prev_ld_update = krln->ld_update;
+	if ((krln->prev_ld_update & ALL_COEF_MASK) != HOLD)
+		krln->ld_last_nonhold_update = krln->prev_ld_update;
+
+	prev_req_init = krln->prev_ld_update & INIT_MASK;
+	prev_req_preset = krln->prev_ld_update & PRESET_MASK;
+	prev_req_cp1 = (krln->prev_ld_update & COP1_MASK) >> COP1_SHIFT;
+	prev_req_cz0 = (krln->prev_ld_update & COZ0_MASK) >> COZ0_SHIFT;
+	prev_req_cm1 = (krln->prev_ld_update & COM1_MASK) >> COM1_SHIFT;
+
+	/* Training Done condition */
+	if (krln->eq_alg->ops.is_eq_done(krln->eq_priv))
+		trst->done_training = true;
+
+	/* Check if Training is Done */
+	if (trst->done_training) {
+		training_complete(krln);
+		return;
+	}
+
+	/* Read LP Status */
+	krln->lp_status =
+		backplane_read_mmd(krln, krln->bp_phy->bp_dev.mdio.lt_devad,
+				   krln->bp_phy->bp_dev.mdio.lt_kr_lp_status);
+
+	if ((krln->lp_status & ALL_COEF_MASK) != 0)
+		krln->lp_last_change_status = krln->lp_status;
+
+	status_cp1 = (krln->lp_status & COP1_MASK) >> COP1_SHIFT;
+	status_cz0 = (krln->lp_status & COZ0_MASK) >> COZ0_SHIFT;
+	status_cm1 = (krln->lp_status & COM1_MASK) >> COM1_SHIFT;
+
+	if (status_cp1 == COEF_UPDATED || status_cp1 == COEF_MIN ||
+	    status_cp1 == COEF_MAX)
+		krln->last_lp_update_status[C_P1] = status_cp1;
+	if (status_cz0 == COEF_UPDATED || status_cz0 == COEF_MIN ||
+	    status_cz0 == COEF_MAX)
+		krln->last_lp_update_status[C_Z0] = status_cz0;
+	if (status_cm1 == COEF_UPDATED || status_cm1 == COEF_MIN ||
+	    status_cm1 == COEF_MAX)
+		krln->last_lp_update_status[C_M1] = status_cm1;
+
+	/* IEEE802.3-2008, 72.6.10.2.3.2
+	 * we send initialize to the other side to ensure default settings
+	 * for the LP. Naturally, we should do this only once.
+	 */
+	if (!trst->sent_init) {
+		/* All status MUST be NOTUPDATED for INIT to be executed
+		 * otherwise send HOLD first
+		 */
+		if (status_cp1 == COEF_NOTUPDATED &&
+		    status_cz0 == COEF_NOTUPDATED &&
+		    status_cm1 == COEF_NOTUPDATED) {
+			trst->sent_init = true;
+			krln->ld_update = INIT_MASK;
+			krln->req_ld_update_init_count = 1;
+			krln->init_handshake_time = jiffies_to_msecs(jiffies);
+		} else {
+			/* send HOLD before sending subsequent Init requests
+			 * this is not the very first Init sent
+			 */
+			krln->ld_update = HOLD;
+		}
+		ld_coef_update(krln);
+		return;
+	}
+	/* continue to sent init request until LP responds to init */
+	if (prev_req_init) {
+		if (krln->lp_status == 0) {
+			/* nothing to do here for now...
+			 * perhaps the partner board LP has not yet started
+			 * so continue to send INIT requests
+			 * this will happen in the next condition anyway...
+			 */
+		}
+		/* 72.6.10.2.3.2 Initialize
+		 * The initialize control shall only be initially sent when all
+		 * coefficient status fields indicate not_updated,
+		 * and will then continue to be sent
+		 * until no coefficient status field indicates not_updated.
+		 */
+		if (status_cp1 == COEF_NOTUPDATED ||
+		    status_cz0 == COEF_NOTUPDATED ||
+		    status_cm1 == COEF_NOTUPDATED) {
+			krln->ld_update = INIT_MASK;
+			ld_coef_update(krln);
+			krln->req_ld_update_init_count++;
+		} else {
+			/* IEEE802.3-2008, 72.6.10.2.3.2
+			 * We may clear INITIALIZE when no coefficients
+			 * show NOT UPDATED.
+			 */
+			/* v1: krln->ld_update &= ~INIT_MASK; */
+			/* better send request: HOLD ALL
+			 * should be equivalent since only INIT is set now
+			 */
+			krln->ld_update = HOLD;
+
+			lp_resp_time = jiffies_to_msecs(jiffies) -
+					       krln->init_handshake_time;
+			if (!krln->first_recv_init) {
+				/* Init handshake not done yet,
+				 * but will be soon
+				 */
+				krln->req_ld_update_init_count = 1;
+				lp_resp_time = 0;
+			}
+			ld_coef_update(krln);
+		}
+		return;
+	}
+
+	/* 72.6.10.2.3.1 Preset
+	 * The preset control shall only be initially sent when all coefficient
+	 * status fields indicate not_updated,
+	 * and will then continue to be sent until the status for all
+	 * coefficients indicates updated or maximum
+	 */
+	/* IEEE802.3-2008, 72.6.10.2.3.1
+	 * We may clear PRESET when all coefficients show UPDATED or MAX.
+	 */
+	/* check if previous request was preset */
+	if (prev_req_preset) {
+		if ((status_cp1 == COEF_UPDATED || status_cp1 == COEF_MAX) &&
+		    (status_cz0 == COEF_UPDATED || status_cz0 == COEF_MAX) &&
+		    (status_cm1 == COEF_UPDATED || status_cm1 == COEF_MAX)) {
+			krln->ld_update &= ~PRESET_MASK;
+		} else {
+			/* All status MUST be NOTUPDATED for INIT to be executed
+			 * otherwise send HOLD first
+			 */
+			if (status_cp1 == COEF_NOTUPDATED &&
+			    status_cz0 == COEF_NOTUPDATED &&
+			    status_cm1 == COEF_NOTUPDATED) {
+				krln->ld_update = PRESET_MASK;
+			} else {
+				/* send HOLD before sending subsequent
+				 * Preset requests
+				 */
+				krln->ld_update = HOLD;
+			}
+			ld_coef_update(krln);
+			return;
+		}
+	}
+
+	/* IEEE802.3-2008, 72.6.10.2.3.3
+	 * We only request coefficient updates when no PRESET/INITIALIZE is
+	 * pending. We also only request coefficient updates when the
+	 * corresponding status is NOT UPDATED and nothing is pending.
+	 */
+	if (krln->ld_update & (PRESET_MASK | INIT_MASK))
+		return;
+
+	/* continue to move back to previous request until LP responds to it
+	 * Move back to previous C(-1), C(0), C(+1) and HOLD
+	 */
+	if (krln->move_back_prev) {
+		/* can exit from here only with: DONE Training */
+		if (krln->move_back_cnt == TIMEOUT_MOVE_BACK_PREV) {
+			trst->done_training = true;
+			training_complete(krln);
+			return;
+		}
+		krln->move_back_cnt++;
+
+		if (status_cp1 == COEF_UPDATED)
+			krln->move_back_lp_status |=
+						(COEF_UPDATED << COP1_SHIFT);
+		if (status_cz0 == COEF_UPDATED)
+			krln->move_back_lp_status |=
+						(COEF_UPDATED << COZ0_SHIFT);
+		if (status_cm1 == COEF_UPDATED)
+			krln->move_back_lp_status |=
+						(COEF_UPDATED << COM1_SHIFT);
+
+		if ((krln->move_back_lp_status & ALL_COEF_MASK) ==
+						LP_STATUS_ALL_COEF_UPDATED) {
+			trst->done_training = true;
+			training_complete(krln);
+			return;
+		}
+
+		/* Move back to previous C(-1), C(0), C(+1) */
+		krln->ld_update = krln->prev_ld_update;
+		ld_coef_update(krln);
+		return;
+	}
+
+	/* 72.6.10.2.5 Coefficient update process
+	 * Once the updated, maximum, or minimum state is reported it continues
+	 * to be reported until a hold request is received,
+	 * after which the status reverts to not_updated.
+	 */
+
+	/* IEEE802.3-2008, 72.6.10.2.3.3
+	 * We set coefficient requests to HOLD when we get the information
+	 * about any updates On clearing our prior response, we also update
+	 * our internal status.
+	 */
+
+	/* send a Hold if want to send another INC same as previous
+	 * and received status: NOTUPDATED
+	 * 1. Continue to send previous REQ until receive status UPDATED
+	 * 2. Continue to send HOLD until receive status NOTUPDATED
+	 */
+
+	/* 3. LP can remain stuck ~42 ms in reset Rx lane: so we should wait
+	 * around ~50 ms and only after that issue Timeout error message
+	 */
+
+	switch (prev_req_cp1) {
+	case HOLD:
+		/* previous request was: HOLD */
+		if (status_cp1 == COEF_NOTUPDATED) {
+			/* All good here:
+			 * continue to check the other coefficient requests
+			 * and if all are good then proceed to
+			 * generate coefficient tuning requests
+			 */
+		} else {
+			/* Continue to send the same request: (2.)
+			 * Continue to send HOLD until receive status NOTUPDATED
+			 */
+			if (krln->repeat_request_count >=
+					TIMEOUT_REPEAT_REQUEST) {
+				bpdev_err(krln->bpphy,
+					  "REQ Timeout: Repeating C(+1) HOLD request without LP response timeout !\n");
+				/* Hold Request Timeout:
+				 * continue to send HOLD until LP responds
+				 * with NOTUPDATED
+				 */
+				krln->repeat_request_count = 0;
+			} else {
+				/* Allow LP some time to respond
+				 * and repeat request
+				 */
+				msleep(20);
+				/* Allow LP more time to respond,
+				 * as the last chance, on the last time
+				 * before issuing timeout error: (3.)
+				 */
+				if (krln->repeat_request_count ==
+						TIMEOUT_REPEAT_REQUEST - 1)
+					msleep(30);
+				krln->repeat_request_count++;
+			}
+			ld_coef_update(krln);
+			return;
+		}
+		break;
+	case INCREMENT:
+	case DECREMENT:
+		/* previous request was: INC/DEC */
+		if (status_cp1 == COEF_NOTUPDATED) {
+			/* Continue to send the same request: (1.)
+			 * Continue to send previous REQ
+			 * until receive status UPDATED
+			 */
+			if (krln->repeat_request_count >=
+					TIMEOUT_REPEAT_REQUEST) {
+				if (prev_req_cp1 == INCREMENT)
+					bpdev_err(krln->bpphy,
+						  "REQ Timeout: Repeating C(+1) INC request without LP response timeout !\n");
+				else
+					bpdev_err(krln->bpphy,
+						  "REQ Timeout: Repeating C(+1) DEC request without LP response timeout !\n");
+				/* Request Timeout:
+				 * just continue: proceed again to
+				 * generate coefficient tuning requests
+				 */
+			} else {
+				/* Allow LP some time to respond
+				 * and repeat request
+				 */
+				msleep(20);
+				/* Allow LP more time to respond,
+				 * as the last chance,
+				 * on the last time before
+				 * issuing timeout error: (3.)
+				 */
+				if (krln->repeat_request_count ==
+						TIMEOUT_REPEAT_REQUEST - 1)
+					msleep(30);
+				krln->repeat_request_count++;
+				ld_coef_update(krln);
+				return;
+			}
+		} else {
+			/* All good here:
+			 * LP responded to this Request
+			 * Sent HOLD for this coefficient
+			 * before asking another request
+			 * continue to check the other coefficient requests
+			 */
+			krln->ld_update &= ~COP1_MASK;
+		}
+		break;
+	default:
+		/* previous request was: RESERVED: do nothing */
+		break;
+	}
+
+	switch (prev_req_cz0) {
+	case HOLD:
+		/* previous request was: HOLD */
+		if (status_cz0 == COEF_NOTUPDATED) {
+			/* All good here:
+			 * continue to check the other coefficient requests
+			 * and if all are good then proceed to
+			 * generate coefficient tuning requests
+			 */
+		} else {
+			/* Continue to send the same request: (2.)
+			 * Continue to send HOLD until receive status NOTUPDATED
+			 */
+			if (krln->repeat_request_count >=
+					TIMEOUT_REPEAT_REQUEST) {
+				bpdev_err(krln->bpphy,
+					  "REQ Timeout: Repeating C(0) HOLD request without LP response timeout !\n");
+				/* Hold Request Timeout:
+				 * continue to send HOLD until LP responds
+				 * with NOTUPDATED
+				 */
+				krln->repeat_request_count = 0;
+			} else {
+				/* Allow LP some time to respond
+				 * and repeat request
+				 */
+				msleep(20);
+				/* Allow LP more time to respond,
+				 * as the last chance,
+				 * on the last time before issuing
+				 * timeout error: (3.)
+				 */
+				if (krln->repeat_request_count ==
+						TIMEOUT_REPEAT_REQUEST - 1)
+					msleep(30);
+				krln->repeat_request_count++;
+			}
+			ld_coef_update(krln);
+			return;
+		}
+		break;
+	case INCREMENT:
+	case DECREMENT:
+		/* previous request was: INC/DEC */
+		if (status_cz0 == COEF_NOTUPDATED) {
+			/* Continue to send the same request: (1.)
+			 * Continue to send previous REQ until receive
+			 * status UPDATED
+			 */
+			if (krln->repeat_request_count >=
+					TIMEOUT_REPEAT_REQUEST) {
+				if (prev_req_cz0 == INCREMENT)
+					bpdev_err(krln->bpphy,
+						  "REQ Timeout: Repeating C(0) INC request without LP response timeout !\n");
+				else
+					bpdev_err(krln->bpphy,
+						  "REQ Timeout: Repeating C(0) DEC request without LP response timeout !\n");
+				/* Request Timeout:
+				 * just continue: proceed again to
+				 * generate coefficient tuning requests
+				 */
+			} else {
+				/* Allow LP some time to respond
+				 * and repeat request
+				 */
+				msleep(20);
+				/* Allow LP more time to respond, as the last
+				 * chance, on the last time before issuing
+				 * timeout error: (3.)
+				 */
+				if (krln->repeat_request_count ==
+						TIMEOUT_REPEAT_REQUEST - 1)
+					msleep(30);
+				krln->repeat_request_count++;
+				ld_coef_update(krln);
+				return;
+			}
+		} else {
+			/* All good here:
+			 * LP responded to this Request
+			 * Sent HOLD for this coefficient
+			 * before asking another request
+			 * continue to check the other coefficient requests
+			 */
+			krln->ld_update &= ~COZ0_MASK;
+		}
+		break;
+	default:
+		/* previous request was: RESERVED: do nothing */
+		break;
+	}
+
+	switch (prev_req_cm1) {
+	case HOLD:
+		/* previous request was: HOLD */
+		if (status_cm1 == COEF_NOTUPDATED) {
+			/* All good here:
+			 * continue to check the other coefficient requests
+			 * and if all are good then proceed to
+			 * generate coefficient tuning requests
+			 */
+		} else {
+			/* Continue to send the same request: (2.)
+			 * Continue to send HOLD until receive status
+			 * NOTUPDATED
+			 */
+			if (krln->repeat_request_count >=
+					TIMEOUT_REPEAT_REQUEST) {
+				bpdev_err(krln->bpphy,
+					  "REQ Timeout: Repeating C(-1) HOLD request without LP response timeout !\n");
+				/* Hold Request Timeout:
+				 * continue to send HOLD until
+				 * LP responds with NOTUPDATED
+				 */
+				krln->repeat_request_count = 0;
+			} else {
+				/* Allow LP some time to respond
+				 * and repeat request
+				 */
+				msleep(20);
+				/* Allow LP more time to respond,
+				 * as the last chance,
+				 * on the last time
+				 * before issuing timeout error: (3.)
+				 */
+				if (krln->repeat_request_count ==
+						TIMEOUT_REPEAT_REQUEST - 1)
+					msleep(30);
+				krln->repeat_request_count++;
+			}
+			ld_coef_update(krln);
+			return;
+		}
+		break;
+	case INCREMENT:
+	case DECREMENT:
+		/* previous request was: INC/DEC */
+		if (status_cm1 == COEF_NOTUPDATED) {
+			/* Continue to send the same request: (1.)
+			 * Continue to send previous REQ until receive status
+			 * UPDATED
+			 */
+			if (krln->repeat_request_count >=
+						TIMEOUT_REPEAT_REQUEST) {
+				if (prev_req_cm1 == INCREMENT)
+					bpdev_err(krln->bpphy,
+						  "REQ Timeout: Repeating C(-1) INC request without LP response timeout !\n");
+				else
+					bpdev_err(krln->bpphy,
+						  "REQ Timeout: Repeating C(-1) DEC request without LP response timeout !\n");
+				/* Request Timeout:
+				 * just continue: proceed again to
+				 * generate coefficient tuning requests
+				 */
+			} else {
+				/* Allow LP some time to respond and repeat
+				 * request
+				 */
+				msleep(20);
+				/* Allow LP more time to respond, as the last
+				 * chance, on the last time before issuing
+				 * timeout error: (3.)
+				 */
+				if (krln->repeat_request_count ==
+						TIMEOUT_REPEAT_REQUEST - 1)
+					msleep(30);
+				krln->repeat_request_count++;
+				ld_coef_update(krln);
+				return;
+			}
+		} else {
+			/* All good here:
+			 * LP responded to this Request
+			 * Sent HOLD for this coefficient
+			 * before asking another request
+			 * continue to check the other coefficient requests
+			 */
+			krln->ld_update &= ~COM1_MASK;
+		}
+		break;
+	default:
+		/* previous request was: RESERVED: do nothing */
+		break;
+	}
+
+	/* Reset repeat request counter:
+	 * must be after all prev_req verifications above
+	 */
+	krln->repeat_request_count = 0;
+
+	if (krln->prev_ld_update != krln->ld_update) {
+		ld_coef_update(krln);
+		/* Redo these status checks and updates until we have no more
+		 * changes, to speed up the overall process.
+		 */
+		return;
+	}
+
+	/* Do nothing if we have pending request. */
+	if (prev_req_cp1 || prev_req_cz0 || prev_req_cm1)
+		return;
+	else if (krln->lp_status & ALL_COEF_MASK)
+		/* No pending request but LP status was not reverted to
+		 * not updated.
+		 */
+		return;
+
+	/* Initialize status for the current step */
+	krln->lt_error = false;
+
+	/* if CDR_LOCK = 0: Statistics are invalid */
+	if (!backplane_is_cdr_lock(krln, true)) {
+		if (krln->eq_alg->ops.process_bad_state)
+			krln->eq_alg->ops.process_bad_state(krln->eq_priv);
+		return;
+	}
+
+	/* collect bit edge statistics */
+	if (!krln->eq_alg->ops.collect_statistics(krln->eq_priv))
+		return;
+
+	/* if CDR_LOCK = 0: Statistics are invalid */
+	if (!backplane_is_cdr_lock(krln, true)) {
+		if (krln->eq_alg->ops.process_bad_state)
+			krln->eq_alg->ops.process_bad_state(krln->eq_priv);
+		return;
+	}
+
+	/* Check Rx */
+	if (!krln->eq_alg->ops.is_rx_ok(krln->eq_priv)) {
+		if (krln->eq_alg->ops.process_bad_state)
+			krln->eq_alg->ops.process_bad_state(krln->eq_priv);
+		return;
+	}
+	krln->eq_alg->ops.generate_request(krln->eq_priv);
+
+	/* All C are in Hold and both Bins are stopped:
+	 * So the Training is done
+	 */
+	if (krln->eq_alg->ops.is_eq_done(krln->eq_priv)) {
+		trst->done_training = true;
+		training_complete(krln);
+	}
+}
+
+/* Training for Local Tx
+ * Initialize LD (Local Device)
+ */
+void lt_init_ld(struct kr_lane_info *krln)
+{
+	/* report initial ld status to lp */
+	krln->ld_status = 0;
+	ld_coef_status(krln);
+}
+
+/* Training for Local Tx
+ * This is the main routine for Local Tx training
+ */
+void lt_train_local_tx(struct kr_lane_info *krln)
+{
+	struct training_status *trst = &krln->trst;
+	int request, old_ld_status;
+
+	/* Check stop condition for Local Tx training */
+	trst->lp_rx_ready = lt_is_lp_rx_ready(krln);
+	if (trst->lp_rx_ready) {
+		/* LP receiver is ready
+		 * As soon as the LP shows ready,
+		 * no need to do any more updates.
+		 */
+		krln->ld_status &= ~ALL_COEF_MASK;
+		ld_coef_status(krln);
+
+		trst->local_tx_running = false;
+		return;
+	}
+
+	/* Start new Local Tx training step */
+	trst->local_tx_running = true;
+
+	/* get request from LP */
+	request = backplane_read_mmd(krln, krln->bp_phy->bp_dev.mdio.lt_devad,
+				     krln->bp_phy->bp_dev.mdio.lt_kr_lp_cu) &
+					LD_ALL_MASK;
+
+	old_ld_status = krln->ld_status;
+
+	/* IEEE802.3-2008, 72.6.10.2.5
+	 * Ensure we always go to NOT UDPATED for status reporting in
+	 * response to HOLD requests.
+	 * IEEE802.3-2008, 72.6.10.2.3.1/2
+	 * ... but only if PRESET/INITIALIZE are not active to ensure
+	 * we keep status until they are released.
+	 *
+	 * 72.6.10.2.5 Coefficient update process
+	 * Once the updated, maximum, or minimum state is reported it continues
+	 * to be reported until a hold request is received,
+	 * after which the status reverts to not_updated.
+	 */
+	if (!(request & (PRESET_MASK | INIT_MASK))) {
+		/* Reset status on HOLD request */
+		if (!(request & COP1_MASK))
+			krln->ld_status &= ~COP1_MASK;
+
+		if (!(request & COZ0_MASK))
+			krln->ld_status &= ~COZ0_MASK;
+
+		if (!(request & COM1_MASK))
+			krln->ld_status &= ~COM1_MASK;
+
+		ld_coef_status(krln);
+	}
+
+	/* IEEE802.3-2008, 72.6.10.2.3.1/2
+	 * only act on PRESET/INITIALIZE if all status is NOT UPDATED.
+	 */
+	if (request & (PRESET_MASK | INIT_MASK)) {
+		if (!(krln->ld_status & ALL_COEF_MASK)) {
+			if (request & PRESET_MASK)
+				preset(krln);
+
+			if (request & INIT_MASK) {
+				if (!krln->first_recv_init) {
+					krln->first_recv_init = true;
+					/* Init requests must be counted
+					 * from initial handshake
+					 */
+					krln->req_ld_update_init_count = 1;
+					krln->init_handshake_time =
+						jiffies_to_msecs(jiffies);
+				}
+				initialize(krln);
+			}
+		} else {
+			/* Inform the partner about current ld status
+			 * which should be: ALL UPDATED for INIT  and
+			 * ALL MAX for PRESET
+			 */
+			ld_coef_status(krln);
+		}
+	}
+
+	/* check if LP Coefficient are not in HOLD */
+	if (request & ALL_COEF_MASK)
+		check_request(krln, request & ALL_COEF_MASK);
+
+	/* Make sure the partner is always informed about the current ld status
+	 * this will ensure avoidance of several training issues and errors:
+	 *   'link_training_failed'
+	 *   'Repeating request without LP response'
+	 */
+	ld_coef_status(krln);
+}
+
+/* Training for Remote Tx API */
+
+/* lt_lp_update
+ *
+ * Sends to LP the specified request for coefficients update
+ *
+ * krln: desired lane for which to send lp update
+ * update: desired update request to be sent to LP
+ *
+ * Returns: None
+ */
+void lt_lp_update(struct kr_lane_info *krln, u32 update)
+{
+	krln->ld_update = update;
+	ld_coef_update(krln);
+}
+EXPORT_SYMBOL(lt_lp_update);
+
+/* lt_encode_request
+ *
+ * Encodes a request in the update word
+ * and adds it to other bit requests already existent in the update word
+ *
+ * base_update: base update word used to add a new desired request
+ * req: desired request type to be encoded
+ * field: the field for which the request must be encoded
+ *
+ * Returns: the encoded update word
+ */
+u32 lt_encode_request(u32 base_update, enum req_type req,
+		      enum coef_field field)
+{
+	u32 new_cmd = base_update;
+	u32 cmd;
+
+	if (req >= REQ_INIT)
+		return RESERVED;
+
+	cmd = get_mask_for_req(req);
+
+	switch (field) {
+	case C_P1:
+		new_cmd |= (cmd << COP1_SHIFT);
+		break;
+	case C_Z0:
+		new_cmd |= (cmd << COZ0_SHIFT);
+		break;
+	case C_M1:
+		new_cmd |= (cmd << COM1_SHIFT);
+		break;
+	default:
+		return RESERVED;
+	}
+	return new_cmd;
+}
+EXPORT_SYMBOL(lt_encode_request);
+
+/* lt_encode_startup_request
+ *
+ * Encodes a startup request in the update word
+ *
+ * req: desired startup request type to be encoded
+ *
+ * Returns: the encoded update word
+ */
+u32 lt_encode_startup_request(enum req_type req)
+{
+	if (req == REQ_HOLD || req == REQ_INIT || req == REQ_PRESET)
+		return get_mask_for_req(req);
+
+	return RESERVED;
+}
+EXPORT_SYMBOL(lt_encode_startup_request);
+
+/* lt_decode_coef_update
+ *
+ * Decodes a request update for the specified field
+ *
+ * update: update word to be decoded
+ * field: desired field for which to decode the update
+ *
+ * Returns: the decoded request type
+ */
+enum req_type lt_decode_coef_update(u32 update, enum coef_field field)
+{
+	u32 cmd = HOLD;
+
+	switch (field) {
+	case C_P1:
+		cmd = (update & COP1_MASK) >> COP1_SHIFT;
+		break;
+	case C_Z0:
+		cmd = (update & COZ0_MASK) >> COZ0_SHIFT;
+		break;
+	case C_M1:
+		cmd = (update & COM1_MASK) >> COM1_SHIFT;
+		break;
+	default:
+		return REQ_INVALID;
+	}
+
+	return get_req_for_mask(cmd);
+}
+EXPORT_SYMBOL(lt_decode_coef_update);
+
+/* lt_is_update_of_type
+ *
+ * Checks if a request update is according to the specified type
+ * by checking the specific request bit in update word
+ *
+ * update: desired update word to be verified
+ * type: desired type to check against
+ *
+ * Returns: true if update is according to asked type or false otherwise
+ */
+bool lt_is_update_of_type(u32 update, enum req_type type)
+{
+	u32 mask = HOLD;
+
+	switch (type) {
+	case REQ_HOLD:
+		return (update == HOLD);
+	case REQ_INC:
+		mask |= (INCREMENT << COP1_SHIFT);
+		mask |= (INCREMENT << COZ0_SHIFT);
+		mask |= (INCREMENT << COM1_SHIFT);
+		return ((update & mask) != 0);
+	case REQ_DEC:
+		mask |= (DECREMENT << COP1_SHIFT);
+		mask |= (DECREMENT << COZ0_SHIFT);
+		mask |= (DECREMENT << COM1_SHIFT);
+		return ((update & mask) != 0);
+	case REQ_INIT:
+		return ((update & INIT_MASK) != 0);
+	case REQ_PRESET:
+		return ((update & PRESET_MASK) != 0);
+	default:
+		return false;
+	}
+	return false;
+}
+EXPORT_SYMBOL(lt_is_update_of_type);
+
+/* lt_is_lp_at_startup
+ *
+ * Checks if LP status is still at startup status: INIT or PRESET
+ *
+ * krln: desired lane to be verified
+ * req: request type to check startup status
+ *	it makes sense only for INIT or PRESET requests
+ *
+ * Returns: true if LP status is still at startup status or false otherwise
+ */
+bool lt_is_lp_at_startup(struct kr_lane_info *krln, enum req_type type)
+{
+	u32 lp_st = krln->lp_status;
+	u32 lp_lcs = get_lp_lcs(krln);
+	bool lp_startup;
+
+	/* LP status still at Init/Preset:
+	 * IF now LP status is Init/Preset
+	 * OR (now LP status is NOTUPDATED
+	 * AND the last nonzero LP status was Init/Preset)
+	 */
+	switch (type) {
+	case REQ_INIT:
+		if (is_all_status(lp_st, COEF_UPDATED))
+			lp_startup = true;
+		else
+			lp_startup = is_all_status(lp_st, COEF_NOTUPDATED) &&
+					is_all_status(lp_lcs, COEF_UPDATED);
+		break;
+	case REQ_PRESET:
+		/* LP status still at Preset
+		 * if now LP status is Preset
+		 * OR now LP status is NOTUPDATED
+		 *    AND the last nonzero LP status was Preset
+		 */
+		if (is_all_status(lp_st, COEF_MAX) ||
+		    is_all_status(lp_st, COEF_UPDATED))
+			lp_startup = true;
+		else
+			lp_startup = is_all_status(lp_st, COEF_NOTUPDATED) &&
+					(is_all_status(lp_lcs, COEF_MAX) ||
+					 is_all_status(lp_lcs, COEF_UPDATED));
+		break;
+	default:
+		return false;
+	}
+
+	return lp_startup;
+}
+EXPORT_SYMBOL(lt_is_lp_at_startup);
+
+/* lt_get_lp_coef_status
+ *
+ * Determines the last LP coefficient status
+ * according to IEEE802.3ap-2007:
+ * 72.6.10.2.5 Coefficient update process
+ *
+ * krln: desired lane to be verified
+ * field: coefficient field to be verified
+ *
+ * Returns: the last LP coefficient status
+ */
+enum coef_status lt_get_lp_coef_status(struct kr_lane_info *krln,
+				       enum coef_field field)
+{
+	return krln->last_lp_update_status[field];
+}
+EXPORT_SYMBOL(lt_get_lp_coef_status);
+
+/* lt_set_error
+ *
+ * Sets or resets the LT (Link Training) Error flag
+ * This is used to signal to the generic kr training step procedure
+ * that an LT error state has occurred
+ * and link training cannot be successfully finished
+ *
+ * krln: desired lane to set lt error
+ * err: boolean value that specifies if set or reset the error flag
+ *
+ * Returns: None
+ */
+void lt_set_error(struct kr_lane_info *krln, bool err)
+{
+	krln->lt_error = err;
+}
+EXPORT_SYMBOL(lt_set_error);
+
+/* lt_move_lp_back
+ * Request LP to move back to previous coefficients setup and HOLD
+ * The procedure for sending this request is based on reverting the
+ * latest change request (non-hold update) for all coefficients
+ * This procedure should be used to exit from bad states like not CDR_Lock
+ *
+ * krln: desired lane for which to send lp update
+ *
+ * Returns: None
+ */
+void lt_move_lp_back(struct kr_lane_info *krln)
+{
+	u32 prev_req_cp1 = (krln->ld_last_nonhold_update & COP1_MASK) >>
+				COP1_SHIFT;
+	u32 prev_req_cz0 = (krln->ld_last_nonhold_update & COZ0_MASK) >>
+				COZ0_SHIFT;
+	u32 prev_req_cm1 = (krln->ld_last_nonhold_update & COM1_MASK) >>
+				COM1_SHIFT;
+	u32 temp;
+
+	/* Move back to previous C(-1), C(0), C(+1) and HOLD */
+	temp = HOLD;
+	switch (prev_req_cp1) {
+	case INCREMENT:
+		temp |= DECREMENT << COP1_SHIFT;
+		break;
+	case DECREMENT:
+		temp |= INCREMENT << COP1_SHIFT;
+		break;
+	}
+	switch (prev_req_cz0) {
+	case INCREMENT:
+		temp |= DECREMENT << COZ0_SHIFT;
+		break;
+	case DECREMENT:
+		temp |= INCREMENT << COZ0_SHIFT;
+		break;
+	}
+	switch (prev_req_cm1) {
+	case INCREMENT:
+		temp |= DECREMENT << COM1_SHIFT;
+		break;
+	case DECREMENT:
+		temp |= INCREMENT << COM1_SHIFT;
+		break;
+	}
+
+	krln->ld_update = temp;
+	ld_coef_update(krln);
+
+	/* start the procedure for sending request to move LP back
+	 * to previous setup until LP responds to it
+	 */
+	krln->move_back_prev = true;
+	krln->move_back_cnt = 0;
+	krln->move_back_lp_status = 0;
+	if (prev_req_cp1 == HOLD)
+		krln->move_back_lp_status |= (COEF_UPDATED << COP1_SHIFT);
+	if (prev_req_cz0 == HOLD)
+		krln->move_back_lp_status |= (COEF_UPDATED << COZ0_SHIFT);
+	if (prev_req_cm1 == HOLD)
+		krln->move_back_lp_status |= (COEF_UPDATED << COM1_SHIFT);
+}
+EXPORT_SYMBOL(lt_move_lp_back);
diff --git a/drivers/net/phy/backplane/link_training.h b/drivers/net/phy/backplane/link_training.h
new file mode 100644
index 0000000..54374aa
--- /dev/null
+++ b/drivers/net/phy/backplane/link_training.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Link Training (IEEE802.3ap/ba)
+ *
+ * Copyright 2019-2020 NXP
+ */
+
+#ifndef __LINK_TRAINING_H
+#define __LINK_TRAINING_H
+
+#include "backplane.h"
+
+/* Link Training interface with backplane driver */
+
+void lt_setup_c45(struct backplane_dev_info *bp_dev);
+void lt_setup_memmap(struct backplane_dev_info *bp_dev, int devad, u32 base);
+
+void lt_start(struct kr_lane_info *krln);
+void lt_stop(struct kr_lane_info *krln);
+void lt_reset(struct kr_lane_info *krln);
+
+bool lt_is_rx_trained(struct kr_lane_info *krln);
+bool lt_is_training_failure(struct kr_lane_info *krln);
+bool lt_is_frame_lock(struct kr_lane_info *krln);
+
+bool lt_is_lp_rx_ready(struct kr_lane_info *krln);
+bool lt_is_ld_rx_ready(struct kr_lane_info *krln);
+
+void lt_init_ld(struct kr_lane_info *krln);
+void lt_start_an(struct kr_lane_info *krln);
+
+void lt_train_remote_tx(struct kr_lane_info *krln);
+void lt_train_local_tx(struct kr_lane_info *krln);
+
+#endif /* __LINK_TRAINING_H */
-- 
1.9.1

