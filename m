Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20344203835
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgFVNgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:36:37 -0400
Received: from mail-db8eur05on2051.outbound.protection.outlook.com ([40.107.20.51]:36110
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729076AbgFVNg3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:36:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4oNLyzendWmGESLDLAlhAPiFZUHJj573LYFqmmmu1M2vTaKJ5WqfyXeB+01AH41Ocu6Xml/UUnTDJMEKsUpg9ODVGvbOwOPIZnCActiM2Wj1wV94GbMMvk53dL8MWBpzCjdchWjIeO38lzu7jjzrCDyuE6bRBhyGOHO8I4TKCcQHilc2XJ/+YT9lDXLjQmBvB2lveEj+vU+yy7SaT00VzLEHl20WmvTITy8haJz3c8r21MYXTPhk4nFvFMYzmctd+XpwtF0xDugt8awXrvecdpnnerKy7yco30004Lj2w/vo7J02cVYQ+k3zInNpGUMB0zcV5gI98fvWQwFGKafQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6LZb2KO5kJ/ueOyBBnA4T52KylABg5FxSlVtxLg0BU=;
 b=Ej0MSiUGr/AKyBIJCXWJyeYgxy/zwlfLzVSp5A2hQeNxWQyXxB1M2i11vQS7Q0a4vNbedIwsicZh4H7gdkb0QADlO5PgzUiNOpjlbYp38NEE4GFODwWbsvmHWUGXB+zs0aurU8g2xrP5KpBKyocuYysJmojY1XtNgBDRx6TADE5pehyC6PJAlIKInOR1cCrHz+Fu8O+6JD++2lrHHdVlt1O/sgirqLnmiCKfGO05FC5LIDTHFMP8gwkmasYAAlPtwwWzyPSGsAr1yM7hKTyrn9cTpWu/2iQbpO/pMIA+YcjST50f+VXTWVJTwpmRJDnyvOX3kYGrRNk8HgSIrVyvQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6LZb2KO5kJ/ueOyBBnA4T52KylABg5FxSlVtxLg0BU=;
 b=Unfc6FuzTz2OYiCD/03U/vnUpoOKGsYHGqYRLZIxFLuL/2XxSElFBbHFXBsHBmAwzFmsaGxbPh5BQz8ULDc4pUf/9ug1rvymdxUP/q39aKsL1mlZuwRV2DpPG8TrHmU120mz9DjV35XMi6qUHw4QuxpAnegiscOILcfyCBqgcsI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5075.eurprd04.prod.outlook.com (2603:10a6:208:bf::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 13:35:56 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 13:35:56 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next v3 4/7] net: phy: add backplane kr driver support
Date:   Mon, 22 Jun 2020 16:35:21 +0300
Message-Id: <1592832924-31733-5-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
References: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0086.eurprd07.prod.outlook.com
 (2603:10a6:207:6::20) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM3PR07CA0086.eurprd07.prod.outlook.com (2603:10a6:207:6::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3131.12 via Frontend Transport; Mon, 22 Jun 2020 13:35:55 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0a2785e9-2cf2-41f2-38cd-08d816b13100
X-MS-TrafficTypeDiagnostic: AM0PR04MB5075:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB507592256AD3E0992E8C7EB0FB970@AM0PR04MB5075.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xioB7JQcjGeiS3T8dZ+YNNUyEL8aLEFYuD7g3kBjQhMT0VTNxpm5m3jyY1KzIBzE2CsHRAWcvlhOYonIJ/w3GvoiQgXLTGFZkFceqvxT3BkVugm4L2xk3mCZsbvhDv19L+pCmnTQWZhciAJd9u+2wtVoUtn1neKVI0bO+//Wu9VhVM3XorHKpDbDJu8qpYz/bXr1K6wk7bE1x7GSn1T6xtN9rk2rSyAA/F0BX3V2M73QUVMjkyAVDaaLn1el10lf5aIdgEWzOj5N8dh0zN6rcGBV9mtgXRmPsh+dAM3BPzfQuB5YRgD10QbwpB4a/DpHi4MW1St1+X5LFIckSvNrYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(66476007)(66556008)(66946007)(83380400001)(5660300002)(2616005)(30864003)(956004)(44832011)(86362001)(6666004)(2906002)(8676002)(6512007)(52116002)(16526019)(186003)(26005)(3450700001)(6506007)(4326008)(6486002)(316002)(478600001)(8936002)(7416002)(36756003)(579004)(559001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: m/W6qPtj8xal3btln//Dhc5OeLIHjm/+9fKI3V3mkZ5VIdnM9Yd8ED2VQax029mi/dmdL+NWMKwTeSXtKM5aBx1dtOciSucwSTaiuK63PrxbPhu/KG4mhgvrOyWHChPk671YWAj+s8Cy8hS+Q2GfIHV4L2aNA3rCNFmJNnLqQzUU3Xye8EmjC4zcuBkrGnH4Ily/BVZ97sodD5OjZti4Z4+3+6aeXNmFZ3HObAwi8MFtnbdATVPlDOQbpJl6q637fI0Qb6nDZH9WVTGjBHnzQ9P7KqUj4Lph77IUydJKpXL7YQBcy6vnqaUTFq9YzgvbmnNIUkwo2pl1xdd0q7c25E675khCfth6lB4lRq7BuyTysLSUzOlr78KifYN6+xbUKuX5baqJQQVW8+mQOkawgLBLsU4qGGkmKzl+U8qbdOxrX6NHAK2WpQ2wdNwjlGXKHAOwhGWVkZS4xH/4vHSSPADO9BoV5jYi40VJ0RjsJmQ=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a2785e9-2cf2-41f2-38cd-08d816b13100
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 13:35:56.2444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2onu3eBzo37Jz7ZoVvcaUlq2KpOx5q5Y4tdWbms1CuA2bqEJCJBl3f458+eJDjQjz/rnSaR1giuR8xGKPvfph3ad0FyybP3boJ9hegOCfk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5075
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
 drivers/net/phy/backplane/backplane.c     | 1557 +++++++++++++++++++++++++++++
 drivers/net/phy/backplane/backplane.h     |  293 ++++++
 drivers/net/phy/backplane/eq_fixed.c      |   83 ++
 drivers/net/phy/backplane/equalization.h  |  275 +++++
 drivers/net/phy/backplane/link_training.c | 1529 ++++++++++++++++++++++++++++
 drivers/net/phy/backplane/link_training.h |   32 +
 10 files changed, 3801 insertions(+)
 create mode 100644 drivers/net/phy/backplane/Kconfig
 create mode 100644 drivers/net/phy/backplane/Makefile
 create mode 100644 drivers/net/phy/backplane/backplane.c
 create mode 100644 drivers/net/phy/backplane/backplane.h
 create mode 100644 drivers/net/phy/backplane/eq_fixed.c
 create mode 100644 drivers/net/phy/backplane/equalization.h
 create mode 100644 drivers/net/phy/backplane/link_training.c
 create mode 100644 drivers/net/phy/backplane/link_training.h

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index f257023..fa48b8e 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -549,6 +549,8 @@ config XILINX_GMII2RGMII
 	  the Reduced Gigabit Media Independent Interface(RGMII) between
 	  Ethernet physical media devices and the Gigabit Ethernet controller.
 
+source "drivers/net/phy/backplane/Kconfig"
+
 endif # PHYLIB
 
 config MICREL_KS8995MA
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index dc9e53b..4849c16 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -104,3 +104,4 @@ obj-$(CONFIG_STE10XP)		+= ste10Xp.o
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
index 0000000..d9a4770
--- /dev/null
+++ b/drivers/net/phy/backplane/backplane.c
@@ -0,0 +1,1557 @@
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
+#define KR_AN_TIMEOUT				3000
+#define KR_LT_TIMEOUT				500
+
+/* KR timings in interations */
+#define KR_AN_WAIT_ITERATIONS			5
+#define KR_TRAIN_STEP_ITERATIONS		2
+#define CDR_LOCK_RETRY_COUNT			3
+
+/* AN register initialization */
+#define AN_CTRL_INIT				0x1200
+
+/* AN status register (Clause 45) (MMD 7): MDIO_STAT1 */
+#define AN_LINK_UP_MASK				0x04
+
+/* Backplane Ethernet status (Register 7.48) */
+#define AN_BP_ETH_STATUS			48
+
+/* AN masks: Backplane Ethernet status: register 7.48 */
+#define AN_MASK_10GBASE_KR			0x08
+
+/* AN advertisement 1 (Register 7.17) */
+#define AN_ADVERTISEMENT_1			17
+
+/* AN advertisement initialization for register 7.17 */
+#define AN_ADV1_KR_INIT_10G			0x85
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
+static int get_backplane_speed(phy_interface_t interface)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_10GKR:
+		return SPEED_10000;
+	default:
+		pr_err("%s: Unsupported backplane interface\n",
+		       BACKPLANE_DRIVER_NAME);
+		return SPEED_UNKNOWN;
+	}
+	return SPEED_UNKNOWN;
+}
+
+static enum ethtool_link_mode_bit_indices
+	get_backplane_supported_mode(phy_interface_t interface)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_10GKR:
+		return ETHTOOL_LINK_MODE_10000baseKR_Full_BIT;
+	default:
+		pr_err("%s: Unsupported backplane interface\n",
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
+static void init_kr_lane(struct lane_device *lane, bool revert_default)
+{
+	if (revert_default)
+		backplane_default_kr_lane(lane);
+
+	training_status_init(&lane->krln.trst);
+	lane->krln.state = DETECTING_LP;
+	lane->krln.an_kr_detected = false;
+
+	lane->krln.ld_update = 0;
+	lane->krln.prev_ld_update = 0;
+	lane->krln.ld_last_nonhold_update = 0;
+	lane->krln.lp_status = 0;
+	lane->krln.lp_last_change_status = 0;
+	lane->krln.last_lp_update_status[C_M1] = 0;
+	lane->krln.last_lp_update_status[C_Z0] = 0;
+	lane->krln.last_lp_update_status[C_P1] = 0;
+	lane->krln.ld_status = 0;
+	lane->krln.move_back_prev = false;
+	lane->krln.move_back_cnt = 0;
+	lane->krln.move_back_lp_status = 0;
+
+	lt_init_ld(lane);
+}
+
+static void setup_supported_linkmode(struct phy_device *phydev)
+{
+	int i;
+
+	/* Clear all supported backplane protocols features
+	 * and setup only the currently configured protocol
+	 */
+	for (i = 0; i < ARRAY_SIZE(backplane_protocol_features_array); i++)
+		linkmode_clear_bit(backplane_protocol_features_array[i],
+				   phydev->supported);
+
+	linkmode_set_bit(get_backplane_supported_mode(phydev->interface),
+			 phydev->supported);
+}
+
+/* Read AN Link Status */
+static int is_an_link_up(struct phy_device *phydev)
+{
+	struct backplane_device *bpdev = phydev->priv;
+	int ret, val = 0;
+
+	mutex_lock(&bpdev->bpphy_lock);
+
+	/* Read twice because Link_Status is LL (Latched Low) bit */
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
+
+	mutex_unlock(&bpdev->bpphy_lock);
+
+	ret = (val & AN_LINK_UP_MASK) ? 1 : 0;
+
+	return ret;
+}
+
+static void start_kr_state_machine(struct lane_device *lane, u32 timeout)
+{
+	/* Check if equalization algorithm is installed */
+	if (!lane->krln.eq_alg)
+		return;
+
+	/* Check if link training is used */
+	if (!lane->krln.eq_alg->use_local_tx_training &&
+	    !lane->krln.eq_alg->use_remote_tx_training)
+		return;
+
+	queue_delayed_work(system_power_efficient_wq, &lane->krwk,
+			   msecs_to_jiffies(timeout));
+}
+
+static void stop_kr_state_machine(struct lane_device *lane)
+{
+	/* Check if equalization algorithm is installed */
+	if (!lane->krln.eq_alg)
+		return;
+
+	/* Check if link training is used */
+	if (!lane->krln.eq_alg->use_local_tx_training &&
+	    !lane->krln.eq_alg->use_remote_tx_training)
+		return;
+
+	cancel_delayed_work_sync(&lane->krwk);
+}
+
+static void setup_default_settings(struct lane_device *lane)
+{
+	if (lane->bpdev->bpkr.valid_eq_init)
+		lane->krln.def_kr = lane->bpdev->bpkr.def_kr;
+	else
+		lane->bpdev->drv.lane_ops->read_lane_kr(lane->reg_base,
+							&lane->krln.def_kr);
+
+	/* HW specific default settings */
+	if (lane->bpdev->drv.bp_ops.setup_default_settings)
+		lane->bpdev->drv.bp_ops.setup_default_settings(lane);
+}
+
+static void kr_reset_master_lane(struct lane_device *lane)
+{
+	const struct lane_ops *lane_ops = lane->bpdev->drv.lane_ops;
+	struct backplane_device *bpdev = lane->bpdev;
+
+	if (backplane_is_multi_lane(bpdev)) {
+		/* Reset only the Master Lane */
+		if (lane->idx == MASTER_LANE)
+			lane_ops->reset_lane(lane->reg_base, LANE_RX_TX);
+	} else {
+		lane_ops->reset_lane(lane->reg_base, LANE_RX_TX);
+	}
+}
+
+static void print_single_lane_trained(struct lane_device *lane)
+{
+	struct phy_device *phydev = lane->phydev;
+
+	phydev_info(phydev,
+		    "%s link trained, Tx equalization: C(-1)=0x%x, C(0)=0x%x, C(+1)=0x%x\n",
+		    phy_modes(phydev->interface),
+		    lane->krln.tuned_kr.preq, lane->krln.tuned_kr.mainq,
+		    lane->krln.tuned_kr.postq);
+}
+
+static void print_multi_lane_trained(struct lane_device *lane)
+{
+	struct backplane_device *bpdev = lane->bpdev;
+	struct phy_device *phydev = lane->phydev;
+	int i;
+
+	phydev_info(phydev,
+		    "%s link trained, Tx equalization:\n",
+		    phy_modes(phydev->interface));
+
+	for (i = 0; i < bpdev->num_lanes; i++)
+		phydev_info(phydev,
+			    "\t|- Lane %d: C(-1)=0x%x, C(0)=0x%x, C(+1)=0x%x\n",
+			    i + 1, bpdev->lane[i].krln.tuned_kr.preq,
+			    bpdev->lane[i].krln.tuned_kr.mainq,
+			    bpdev->lane[i].krln.tuned_kr.postq);
+}
+
+static void kr_link_trained(struct lane_device *lane)
+{
+	struct backplane_device *bpdev = lane->bpdev;
+
+	mutex_lock(&bpdev->trained_lock);
+	/* Setup lane state as TRAINED inside the phy trained lock
+	 * to avoid duplicated message printed on multi-lane PHYs
+	 */
+	lane->krln.state = TRAINED;
+
+	mutex_lock(&backplane_lock);
+
+	if (backplane_is_single_lane(bpdev))
+		print_single_lane_trained(lane);
+	else
+		if (backplane_are_all_lanes_trained(bpdev))
+			print_multi_lane_trained(lane);
+
+	mutex_unlock(&backplane_lock);
+	mutex_unlock(&bpdev->trained_lock);
+}
+
+static void kr_train_step(struct lane_device *lane)
+{
+	struct training_status *trst = &lane->krln.trst;
+	u32 lt_timeout = KR_LT_TIMEOUT;
+	u64 dead_line;
+	int i = 0;
+
+	/* Check if equalization algorithm is installed */
+	if (!lane->krln.eq_alg)
+		return;
+
+	/* Check if link training is used */
+	if (!lane->krln.eq_alg->use_local_tx_training &&
+	    !lane->krln.eq_alg->use_remote_tx_training)
+		return;
+
+	lt_start(lane);
+
+	while (i < KR_TRAIN_STEP_ITERATIONS) {
+		dead_line = jiffies + msecs_to_jiffies(lt_timeout);
+		while (time_before(jiffies, (unsigned long)dead_line)) {
+			/* check if the LT is already failed */
+			if (lt_is_training_failure(lane)) {
+				/* LT failed already, reset lane to avoid
+				 * it run into hanging, then start LT again.
+				 */
+				kr_reset_master_lane(lane);
+				lt_start(lane);
+			} else if (lt_is_frame_lock(lane)) {
+				break;
+			}
+			/* wait frame lock (without training_failure) */
+			usleep_range(100, 500);
+		}
+
+		if (!lt_is_frame_lock(lane)) {
+			i++;
+			continue;
+		}
+
+		/* the LT should be finished in 500ms, failed or OK. */
+		dead_line = jiffies + msecs_to_jiffies(lt_timeout);
+		while (time_before(jiffies, (unsigned long)dead_line)) {
+			/* check if the LT is already failed */
+			if (lt_is_training_failure(lane)) {
+				kr_reset_master_lane(lane);
+				break;
+			}
+
+			if (lane->krln.eq_alg->use_local_tx_training)
+				lt_train_local_tx(lane);
+
+			if (lane->krln.eq_alg->use_remote_tx_training)
+				lt_train_remote_tx(lane);
+
+			if (lane->krln.lt_error)
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
+		if (lane->krln.lt_error) {
+			init_kr_lane(lane, false);
+			continue;
+		} else {
+			break;
+		}
+	}
+
+	lt_stop(lane);
+
+	/* check if Link is successfully TRAINED */
+	if (lt_is_rx_trained(lane))
+		kr_link_trained(lane);
+	else
+		kr_reset_master_lane(lane);
+}
+
+static void an_init(struct lane_device *masterln)
+{
+	struct backplane_device *bpdev = masterln->bpdev;
+	struct phy_device *phydev = masterln->phydev;
+	struct lane_device *lane;
+	u32 init_an_adv1;
+	int i, err;
+
+	if (!backplane_is_mode_kr(phydev->interface))
+		return;
+
+	if (masterln->idx != MASTER_LANE)
+		return;
+
+	init_an_adv1 = backplane_get_an_adv1_init(phydev->interface);
+
+	/* setup AN init on each lane */
+	for (i = 0; i < bpdev->num_lanes; i++) {
+		lane = &bpdev->lane[i];
+		if (bpdev->drv.bp_ops.an_advertisement_init) {
+			bpdev->drv.bp_ops.an_advertisement_init(lane);
+		} else {
+			err = backplane_write_mmd(lane, MDIO_MMD_AN,
+						  AN_ADVERTISEMENT_1,
+						  init_an_adv1);
+			if (err)
+				phydev_err(phydev,
+					   "Setting AN register 0x%02x on lane %d failed with error code: 0x%08x\n",
+					   AN_ADVERTISEMENT_1, lane->idx, err);
+		}
+	}
+
+	udelay(1);
+
+	err = backplane_write_mmd(masterln, MDIO_MMD_AN, MDIO_CTRL1,
+				  AN_CTRL_INIT);
+	if (err)
+		phydev_err(phydev,
+			   "Setting AN register 0x%02x on Master Lane failed with error code: 0x%08x\n",
+			   MDIO_CTRL1, err);
+}
+
+static void an_request_restart(struct lane_device *lane)
+{
+	const struct lane_ops *lane_ops = lane->bpdev->drv.lane_ops;
+	struct backplane_device *bpdev = lane->bpdev;
+	struct phy_device *phydev = lane->phydev;
+	int i;
+
+	if (time_before(jiffies, (unsigned long)lane->krln.an_kr_timeout))
+		return;
+	if (!backplane_is_mode_kr(phydev->interface))
+		return;
+
+	for (i = 0; i < bpdev->num_lanes; i++) {
+		init_kr_lane(&bpdev->lane[i], true);
+		/* Reset the lane to recover from link down */
+		lane_ops->reset_lane(bpdev->lane[i].reg_base, LANE_RX_TX);
+		lt_reset(&bpdev->lane[i]);
+	}
+	/* AN init only for Master Lane */
+	an_init(&bpdev->lane[MASTER_LANE]);
+
+	lane->krln.an_kr_timeout = jiffies + msecs_to_jiffies(KR_AN_TIMEOUT);
+}
+
+static bool detect_lp(struct lane_device *lane)
+{
+	struct backplane_device *bpdev = lane->bpdev;
+	struct phy_device *phydev = lane->phydev;
+	struct lane_device *masterln;
+	bool start_train = false;
+	bool an_kr_link;
+	int an_state;
+	u32 an_mask;
+
+	if (bpdev->drv.bp_ops.is_an_link_detected) {
+		an_kr_link = bpdev->drv.bp_ops.is_an_link_detected(lane);
+	} else {
+		/* Check AN state only on Master Lane */
+		masterln = &bpdev->lane[MASTER_LANE];
+		an_mask = backplane_get_an_bp_eth_status_bit(phydev->interface);
+		an_state = backplane_read_mmd(masterln, MDIO_MMD_AN,
+					      AN_BP_ETH_STATUS);
+		an_kr_link = an_state & an_mask;
+	}
+
+	/* The link training occurs after auto-negotiation
+	 * has determined the link to be a Base-KR link.
+	 * This is indicated by asserting the corresponding bit.
+	 * This occurs before auto-negotiation can declare auto-negotiation
+	 * complete, as this requires the PCS to report a valid link.
+	 */
+	if (an_kr_link) {
+		/* AN acquired:
+		 * Train all lanes in order starting with Master Lane
+		 */
+		lane->krln.an_kr_detected = true;
+		lane->krln.an_kr_wait_count = 0;
+		start_train = true;
+	} else {
+		/* AN lost or not yet acquired */
+		if (lane->krln.an_kr_detected) {
+			/* AN acquired first time but now was lost */
+			if (!backplane_is_link_up(phydev)) {
+				/* Link is down: restart training */
+				lane->krln.an_kr_wait_count = 0;
+				an_request_restart(lane);
+			} else {
+				/* Link is up:
+				 * wait few iterations for AN to be acquired
+				 */
+				if (lane->krln.an_kr_wait_count >=
+							KR_AN_WAIT_ITERATIONS) {
+					lane->krln.an_kr_wait_count = 0;
+					an_request_restart(lane);
+				} else {
+					lane->krln.an_kr_wait_count++;
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
+static void detect_hotplug(struct lane_device *lane)
+{
+	struct backplane_device *bpdev = lane->bpdev;
+	struct phy_device *phydev = lane->phydev;
+	int i;
+
+	if (lane->idx == MASTER_LANE) {
+		/* check if all lanes are trained
+		 * only if current lane is  Master Lane
+		 */
+		if (backplane_are_all_lanes_trained(bpdev)) {
+			phydev_info(phydev, "Detect hotplug, restart training\n");
+			for (i = 0; i < bpdev->num_lanes; i++) {
+				/* initializations on Detect hotplug / restart:
+				 * they must not be part of init_kr_lane
+				 */
+				bpdev->lane[i].krln.first_recv_init = false;
+			}
+			an_request_restart(lane);
+		}
+	}
+}
+
+static void bp_kr_state_machine(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct backplane_device *bpdev;
+	u32 kr_timeout = KR_TIMEOUT_1;
+	struct phy_device *phydev;
+	struct lane_device *lane;
+	bool start_train = false;
+
+	lane = container_of(dwork, struct lane_device, krwk);
+	if (!lane)
+		return;
+
+	bpdev = lane->bpdev;
+	phydev = lane->phydev;
+
+	if (!backplane_is_mode_kr(phydev->interface))
+		return;
+
+	/* Check if equalization algorithm is installed */
+	if (!lane->krln.eq_alg)
+		return;
+
+	/* Check if link training is used */
+	if (!lane->krln.eq_alg->use_local_tx_training &&
+	    !lane->krln.eq_alg->use_remote_tx_training)
+		return;
+
+	mutex_lock(&lane->lane_lock);
+	switch (lane->krln.state) {
+	case DETECTING_LP:
+		start_train = detect_lp(lane);
+		break;
+	case TRAINED:
+		kr_timeout = KR_TIMEOUT_2;
+		if (!backplane_is_link_up(phydev)) {
+			kr_timeout = KR_TIMEOUT_1;
+			detect_hotplug(lane);
+		}
+		break;
+	}
+
+	if (start_train)
+		kr_train_step(lane);
+
+	mutex_unlock(&lane->lane_lock);
+	start_kr_state_machine(lane, kr_timeout);
+}
+
+static void init_kr_state_machine(struct lane_device *lane)
+{
+	/* Check if equalization algorithm is installed */
+	if (!lane->krln.eq_alg)
+		return;
+
+	/* Check if link training is used */
+	if (!lane->krln.eq_alg->use_local_tx_training &&
+	    !lane->krln.eq_alg->use_remote_tx_training)
+		return;
+
+	INIT_DELAYED_WORK(&lane->krwk, bp_kr_state_machine);
+}
+
+/* backplane_get_current_taps
+ * convert coefficient taps from internal backplane driver to link training
+ */
+void backplane_get_current_taps(struct lane_device *lane, u32 *coef)
+{
+	coef[C_M1] = lane->krln.crt_kr.preq;
+	coef[C_Z0] = lane->krln.crt_kr.mainq;
+	coef[C_P1] = lane->krln.crt_kr.postq;
+}
+
+/* backplane_set_current_taps
+ * convert coefficient taps from link training to internal backplane driver
+ */
+void backplane_set_current_taps(struct lane_device *lane, u32 *coef)
+{
+	lane->krln.crt_kr.preq = coef[C_M1];
+	lane->krln.crt_kr.mainq = coef[C_Z0];
+	lane->krln.crt_kr.postq = coef[C_P1];
+}
+
+/* backplane_set_all_taps_to_max
+ * setup all coefficients to MAX values from IEEE802.3ap perspective
+ */
+void backplane_set_all_taps_to_max(struct lane_device *lane)
+{
+	lane->krln.crt_kr = lane->bpdev->bpkr.max_kr;
+}
+
+void backplane_tune_kr_lane(struct lane_device *lane, bool reset_lane)
+{
+	struct backplane_device *bpdev = lane->bpdev;
+	bool reset = false;
+
+	if (backplane_is_multi_lane(bpdev)) {
+		/* Reset only the Master Lane */
+		reset = (lane->idx == MASTER_LANE);
+	} else {
+		reset = true;
+	}
+
+	/* Do not reset the lane if this is how it was asked */
+	if (!reset_lane)
+		reset = false;
+
+	lane->bpdev->drv.lane_ops->tune_lane_kr(lane->reg_base,
+						&lane->krln.crt_kr, reset);
+	lane->krln.tuned_kr = lane->krln.crt_kr;
+}
+
+void backplane_default_kr_lane(struct lane_device *lane)
+{
+	lane->krln.crt_kr = lane->krln.def_kr;
+
+	backplane_tune_kr_lane(lane, true);
+}
+
+/* backplane_write_mmd - Wrapper function for phy_write_mmd
+ * for writing a register on an MMD on a given PHY.
+ *
+ * Same rules as for phy_write_mmd();
+ */
+int backplane_write_mmd(struct lane_device *lane, int devad, u32 regnum,
+			u16 val)
+{
+	struct backplane_device *bpdev = lane->bpdev;
+	struct phy_device *phydev = lane->phydev;
+	int err;
+
+	mutex_lock(&bpdev->bpphy_lock);
+
+	err = phy_write_mmd(phydev, devad, regnum, val);
+	if (err)
+		phydev_err(phydev,
+			   "Writing PHY (%p) MMD = 0x%02x register = 0x%02x failed with error code: 0x%08x\n",
+			   phydev, devad, regnum, err);
+
+	mutex_unlock(&bpdev->bpphy_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(backplane_write_mmd);
+
+/* backplane_read_mmd - Wrapper function for phy_read_mmd
+ * for reading a register from an MMD on a given PHY.
+ *
+ * Same rules as for phy_read_mmd();
+ */
+int backplane_read_mmd(struct lane_device *lane, int devad, u32 regnum)
+{
+	struct backplane_device *bpdev = lane->bpdev;
+	struct phy_device *phydev = lane->phydev;
+	int ret;
+
+	mutex_lock(&bpdev->bpphy_lock);
+
+	ret = phy_read_mmd(phydev, devad, regnum);
+
+	mutex_unlock(&bpdev->bpphy_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(backplane_read_mmd);
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
+	const struct equalization_algorithm *eq_alg;
+	struct spmap_node *node, *node_tmp;
+	struct lane_device *lane;
+
+	if (!key)
+		return;
+
+	/* search all keys in lanes list */
+	list_for_each_entry_safe(node, node_tmp, &lnalg_list, entry) {
+		if (strcmp(node->key, key) == 0) {
+			lane = (struct lane_device *)node->pdata;
+			eq_alg = lane->krln.eq_alg;
+			if (eq_alg->ops.destroy)
+				eq_alg->ops.destroy(lane->krln.eq_priv);
+			lane->krln.eq_alg = NULL;
+			lane->krln.eq_priv = NULL;
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
+bool backplane_is_mode_kr(phy_interface_t interface)
+{
+	return (interface == PHY_INTERFACE_MODE_10GKR);
+}
+EXPORT_SYMBOL(backplane_is_mode_kr);
+
+bool backplane_is_valid_mode(phy_interface_t interface)
+{
+	return backplane_is_mode_kr(interface);
+}
+EXPORT_SYMBOL(backplane_is_valid_mode);
+
+u8 backplane_num_lanes(phy_interface_t interface)
+{
+	const char *bp_name;
+	char num_lanes;
+	int len;
+
+	if (!backplane_is_valid_mode(interface))
+		return 0;
+
+	bp_name = phy_modes(interface);
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
+/* Backplane Ethernet Status Register Register 7.48 (an_bp_eth_status)
+ *	- AN_MASK_10GBASE_KR for 10GBase-KR
+ */
+u32 backplane_get_an_bp_eth_status_bit(phy_interface_t interface)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_10GKR:
+		return AN_MASK_10GBASE_KR;
+	/* add AN support for other backplane modes here */
+	default:
+		pr_err("%s: Unsupported backplane interface\n",
+		       BACKPLANE_DRIVER_NAME);
+		return 0;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(backplane_get_an_bp_eth_status_bit);
+
+u32 backplane_get_an_adv1_init(phy_interface_t interface)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_10GKR:
+		return AN_ADV1_KR_INIT_10G;
+	/* add AN support for other backplane modes here */
+	default:
+		pr_err("%s: Unsupported backplane interface\n",
+		       BACKPLANE_DRIVER_NAME);
+		return 0;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(backplane_get_an_adv1_init);
+
+void backplane_kr_lt_mmd_c45(struct backplane_kr *bpkr)
+{
+	lt_mmd_c45(bpkr);
+}
+EXPORT_SYMBOL(backplane_kr_lt_mmd_c45);
+
+void backplane_kr_lt_mmd_setup(struct backplane_kr *bpkr, int devad, u32 base)
+{
+	lt_mmd_setup(bpkr, devad, base);
+}
+EXPORT_SYMBOL(backplane_kr_lt_mmd_setup);
+
+bool backplane_is_single_lane(struct backplane_device *bpdev)
+{
+	return (bpdev->num_lanes == 1);
+}
+EXPORT_SYMBOL(backplane_is_single_lane);
+
+bool backplane_is_multi_lane(struct backplane_device *bpdev)
+{
+	return (bpdev->num_lanes > 1);
+}
+EXPORT_SYMBOL(backplane_is_multi_lane);
+
+/* backplane_is_cdr_lock
+ *
+ * Checks clock and data recovery bit: CDR Lock
+ *
+ * lane: desired lane to be verified
+ * retry: boolean value that specifies if to retry the check
+ *
+ * Returns: true if CDR_Lock bit is asserted or false otherwise
+ */
+bool backplane_is_cdr_lock(struct lane_device *lane, bool retry)
+{
+	const struct lane_ops *lane_ops = lane->bpdev->drv.lane_ops;
+	int i;
+
+	if (lane_ops->is_cdr_lock(lane->reg_base))
+		return true;
+
+	if (!retry)
+		return false;
+
+	/* Try RX_RESET: Allow for few retries */
+	for (i = 0; i < CDR_LOCK_RETRY_COUNT; i++) {
+		lane_ops->reset_lane(lane->reg_base, LANE_RX);
+		usleep_range(10, 50);
+
+		if (lane_ops->is_cdr_lock(lane->reg_base))
+			return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL(backplane_is_cdr_lock);
+
+/* backplane_is_link_up
+ * Generic Link-up Status: use AN link-up
+ */
+int backplane_is_link_up(struct phy_device *phydev)
+{
+	return is_an_link_up(phydev);
+}
+EXPORT_SYMBOL(backplane_is_link_up);
+
+int backplane_get_lanes_trained_count(struct backplane_device *bpdev)
+{
+	int i, lanes_trained = 0;
+
+	for (i = 0; i < bpdev->num_lanes; i++) {
+		if (bpdev->lane[i].krln.state == TRAINED)
+			lanes_trained++;
+	}
+	return lanes_trained;
+}
+EXPORT_SYMBOL(backplane_get_lanes_trained_count);
+
+int backplane_are_all_lanes_trained(struct backplane_device *bpdev)
+{
+	int i;
+
+	for (i = 0; i < bpdev->num_lanes; i++) {
+		if (bpdev->lane[i].krln.state != TRAINED)
+			return 0;
+	}
+	return 1;
+}
+EXPORT_SYMBOL(backplane_are_all_lanes_trained);
+
+int backplane_create(struct phy_device *phydev)
+{
+	struct backplane_device *bpdev;
+	struct device_node *dev_node;
+
+	dev_node = phydev->mdio.dev.of_node;
+	if (!dev_node) {
+		phydev_err(phydev, "No associated device tree node\n");
+		return -EINVAL;
+	}
+
+	/* allocate memory for backplane info structure */
+	bpdev = devm_kzalloc(&phydev->mdio.dev, sizeof(*bpdev), GFP_KERNEL);
+	if (!bpdev)
+		return -ENOMEM;
+
+	bpdev->phydev = phydev;
+
+	/* save bpdev as phy private data pointer */
+	phydev->priv = bpdev;
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_create);
+
+/* backplane_parse_dt
+ * parses the device tree and saves backplane relevant data
+ * in backplane phy info structure
+ */
+int backplane_parse_dt(struct phy_device *phydev)
+{
+	struct backplane_device *bpdev = phydev->priv;
+	struct device_node *dev_node;
+	u32 eqinit[C_NO];
+	const char *eqa;
+	int proplen;
+	int ret;
+
+	if (!bpdev) {
+		phydev_err(phydev, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+
+	dev_node = phydev->mdio.dev.of_node;
+	if (!dev_node) {
+		phydev_err(phydev, "No associated device tree node\n");
+		return -EINVAL;
+	}
+
+	if (!backplane_is_valid_mode(phydev->interface))
+		return -EINVAL;
+
+	ret = of_property_read_string(dev_node, "eq-algorithm", &eqa);
+	/* if eq-algorithm node is not found then use the default algorithm */
+	if (ret == 0)
+		bpdev->bpkr.eqa_name = eqa;
+	else
+		bpdev->bpkr.eqa_name = DEFAULT_EQ_ALGORITHM;
+
+	/* if eq-init node exists then use the DTS specified values
+	 * if eq-init node doesn't exist then use values already found in HW
+	 */
+	proplen = of_property_count_u32_elems(dev_node, "eq-init");
+	if (proplen > 0) {
+		/* There are 3 standard equalization coefficient taps */
+		if (proplen > C_NO)
+			proplen = C_NO;
+		ret = of_property_read_u32_array(dev_node, "eq-init",
+						 (u32 *)eqinit, proplen);
+		if (ret == 0) {
+			bpdev->bpkr.valid_eq_init = true;
+			bpdev->bpkr.def_kr.preq = eqinit[C_M1];
+			bpdev->bpkr.def_kr.mainq = eqinit[C_Z0];
+			bpdev->bpkr.def_kr.postq = eqinit[C_P1];
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_parse_dt);
+
+/* backplane_setup_memio
+ * Setup memory I/O access
+ */
+int backplane_setup_memio(struct phy_device *phydev)
+{
+	struct backplane_device *bpdev = phydev->priv;
+
+	if (!bpdev) {
+		phydev_err(phydev, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+
+	/* setup ioread/iowrite according to endianness */
+	if (bpdev->drv.is_little_endian) {
+		bpdev->drv.io.read32 = le_ioread32;
+		bpdev->drv.io.write32 = le_iowrite32;
+	} else {
+		bpdev->drv.io.read32 = be_ioread32;
+		bpdev->drv.io.write32 = be_iowrite32;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_setup_memio);
+
+/* backplane_setup_mmd
+ * Setup default MMD (MDIO Managed Device)
+ */
+int backplane_setup_mmd(struct phy_device *phydev)
+{
+	struct backplane_device *bpdev = phydev->priv;
+
+	if (!bpdev) {
+		phydev_err(phydev, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+
+	/* By default setup LT MMD Clause 45 */
+	backplane_kr_lt_mmd_c45(&bpdev->bpkr);
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_setup_mmd);
+
+/* backplane_setup_lanes
+ * Allocates lanes memory map and setup lanes relevant data
+ * Requires:
+ *	- backplane_driver#lane_ops
+ *		for lane access operations
+ *	- backplane_driver#lane_ops#memmap_size
+ *		for lane memory map allocation
+ *	- backplane_kr#equalizer
+ *		for specific Equalizer access
+ *	- backplane_kr#cx_def
+ *		for default coefficient setup
+ */
+int backplane_setup_lanes(struct phy_device *phydev)
+{
+	struct backplane_device *bpdev = phydev->priv;
+	const struct equalization_algorithm *eq_alg;
+	struct equalizer_driver eqdrv;
+	struct lane_device *lane;
+	int i;
+
+	if (!bpdev) {
+		phydev_err(phydev, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+	if (!bpdev->drv.lane_ops) {
+		phydev_err(phydev, "Backplane lane ops is not set\n");
+		return -EINVAL;
+	}
+	if (!bpdev->bpkr.equalizer) {
+		phydev_err(phydev, "Backplane equalizer info is not set\n");
+		return -EINVAL;
+	}
+	if (bpdev->drv.lane_ops->memmap_size == 0) {
+		phydev_err(phydev, "Lane memory map size is zero\n");
+		return -EINVAL;
+	}
+
+	bpdev->num_lanes = backplane_num_lanes(phydev->interface);
+	if (bpdev->num_lanes > MAX_KR_LANES_PER_PHY) {
+		phydev_err(phydev, "Unsupported number of lanes per phy: %d\n",
+			   bpdev->num_lanes);
+		return -EINVAL;
+	}
+
+	if (backplane_is_mode_kr(phydev->interface)) {
+		if (bpdev->bpkr.valid_eq_init &&
+		    bpdev->bpkr.def_kr.preq == 0 &&
+		    bpdev->bpkr.def_kr.mainq == 0 &&
+		    bpdev->bpkr.def_kr.postq == 0)
+			phydev_warn(phydev,
+				    "All KR default values from DT are zero\n");
+	}
+
+	for (i = 0; i < bpdev->num_lanes; i++) {
+		lane = &bpdev->lane[i];
+
+		/* setup lane memory map size */
+		lane->memmap_size = bpdev->drv.lane_ops->memmap_size;
+
+		lane->reg_base = devm_ioremap(&phydev->mdio.dev,
+					      lane->lane_addr,
+					      lane->memmap_size);
+		if (!lane->reg_base) {
+			phydev_err(phydev, "Lane memory map allocation failed\n");
+			return -ENOMEM;
+		}
+
+		lane->idx = i;
+		lane->phydev = phydev;
+		lane->bpdev = bpdev;
+		lane->krln.an_kr_timeout =
+				jiffies + msecs_to_jiffies(KR_AN_TIMEOUT);
+
+		if (backplane_is_mode_kr(phydev->interface)) {
+			setup_default_settings(lane);
+
+			/* Find EQ Algorithm info */
+			eq_alg = eq_find(bpdev->bpkr.eqa_name);
+			if (!eq_alg) {
+				/* key for desired algorithm was not found */
+				phydev_err(phydev,
+					   "Equalization algorithm '%s' is not registered\n",
+					   bpdev->bpkr.eqa_name);
+				return -EINVAL;
+			}
+			if (!eq_alg->ops.create) {
+				phydev_err(phydev,
+					   "Equalization algorithm creation failed: create operation is not available\n");
+				return -EINVAL;
+			}
+			lane->krln.eq_alg = eq_alg;
+
+			/* Setup EQ Algorithm */
+			eqdrv.lane = lane;
+			eqdrv.phydev = lane->phydev;
+			eqdrv.reg_base = lane->reg_base;
+			eqdrv.equalizer = lane->bpdev->bpkr.equalizer;
+
+			/* Create EQ Algorithm */
+			lane->krln.eq_priv = eq_alg->ops.create(eqdrv);
+
+			/* register lane attached to an algorithm */
+			spmap_add(&lnalg_list, bpdev->bpkr.eqa_name, lane);
+
+			if (eq_alg->use_remote_tx_training) {
+				if (!eq_alg->ops.is_rx_ok)
+					phydev_warn(phydev,
+						    "Required operation for remote Tx training is missing: is_rx_ok\n");
+				if (!eq_alg->ops.is_eq_done)
+					phydev_warn(phydev,
+						    "Required operation for remote Tx training is missing: is_eq_done\n");
+				if (!eq_alg->ops.collect_statistics)
+					phydev_warn(phydev,
+						    "Required operation for remote Tx training is missing: collect_statistics\n");
+				if (!eq_alg->ops.generate_request)
+					phydev_warn(phydev,
+						    "Required operation for remote Tx training is missing: generate_request\n");
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
+int backplane_initialize(struct phy_device *phydev)
+{
+	struct backplane_device *bpdev = phydev->priv;
+	int i;
+
+	if (!bpdev) {
+		phydev_err(phydev, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+
+	mutex_init(&bpdev->bpphy_lock);
+	mutex_init(&bpdev->trained_lock);
+
+	for (i = 0; i < bpdev->num_lanes; i++)
+		mutex_init(&bpdev->lane[i].lane_lock);
+
+	phydev->speed = get_backplane_speed(phydev->interface);
+	if (phydev->speed < 0) {
+		phydev_err(phydev, "Unsupported backplane mode\n");
+		return -EINVAL;
+	}
+
+	if (backplane_is_mode_kr(phydev->interface)) {
+		for (i = 0; i < bpdev->num_lanes; i++)
+			init_kr_state_machine(&bpdev->lane[i]);
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
+ * phydev: backplane phy device
+ *	this is an internal phy block controlled by the software
+ *	which contains other component blocks like: PMA/PMD, PCS, AN
+ *
+ * Return: Zero for success or error code in case of failure
+ */
+int backplane_probe(struct phy_device *phydev)
+{
+	return backplane_create(phydev);
+}
+EXPORT_SYMBOL(backplane_probe);
+
+void backplane_remove(struct phy_device *phydev)
+{
+	struct backplane_device *bpdev = phydev->priv;
+
+	if (!bpdev) {
+		phydev_err(phydev, "Backplane phy info is not allocated\n");
+		return;
+	}
+
+	kfree(bpdev);
+	phydev->priv = NULL;
+}
+EXPORT_SYMBOL(backplane_remove);
+
+/* backplane_config_init
+ *
+ * Config_Init function for backplane driver to provide generic device behavior
+ *
+ * phydev: backplane phy device
+ *
+ * Return: Zero for success or error code in case of failure
+ */
+int backplane_config_init(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = backplane_parse_dt(phydev);
+	if (ret)
+		return ret;
+
+	ret = backplane_setup_memio(phydev);
+	if (ret)
+		return ret;
+
+	ret = backplane_setup_mmd(phydev);
+	if (ret)
+		return ret;
+
+	ret = backplane_setup_lanes(phydev);
+	if (ret)
+		return ret;
+
+	ret = backplane_initialize(phydev);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_config_init);
+
+int backplane_aneg_done(struct phy_device *phydev)
+{
+	struct backplane_device *bpdev = phydev->priv;
+
+	if (!phydev->mdio.dev.of_node) {
+		phydev_err(phydev, "No associated device tree node\n");
+		return -EINVAL;
+	}
+	if (!bpdev) {
+		phydev_err(phydev, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+
+	bpdev->aneg_done = true;
+	phydev->state = PHY_RUNNING;
+
+	return 1;
+}
+EXPORT_SYMBOL(backplane_aneg_done);
+
+int backplane_config_aneg(struct phy_device *phydev)
+{
+	struct backplane_device *bpdev = phydev->priv;
+	struct equalization_ops ops;
+	struct lane_device *lane;
+	int i;
+
+	if (!phydev->mdio.dev.of_node) {
+		phydev_err(phydev, "No associated device tree node\n");
+		return -EINVAL;
+	}
+	if (!bpdev) {
+		phydev_err(phydev, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+	if (backplane_get_lanes_trained_count(bpdev) > 0) {
+		phydev_err(phydev, "Incorrectly trained lanes detected\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < bpdev->num_lanes; i++) {
+		lane = &bpdev->lane[i];
+		if (lane->krln.eq_alg) {
+			ops = lane->krln.eq_alg->ops;
+			if (ops.dump_algorithm_context)
+				ops.dump_algorithm_context(lane->krln.eq_priv);
+		}
+	}
+
+	if (backplane_is_mode_kr(phydev->interface)) {
+		/* Warning:
+		 * Order of the operations below is important
+		 * otherwise the training may be failing
+		 * with error: 'link_training_failed'
+		 */
+
+		/* setup all lanes to default */
+		for (i = 0; i < bpdev->num_lanes; i++)
+			setup_default_settings(&bpdev->lane[i]);
+
+		/* Initialize all lanes and reset LT */
+		for (i = 0; i < bpdev->num_lanes; i++) {
+			init_kr_lane(&bpdev->lane[i], true);
+			lt_reset(&bpdev->lane[i]);
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
+	phydev->speed = get_backplane_speed(phydev->interface);
+	if (phydev->speed < 0) {
+		phydev_err(phydev, "Unsupported backplane mode\n");
+		return -EINVAL;
+	}
+
+	setup_supported_linkmode(phydev);
+	linkmode_copy(phydev->advertising, phydev->supported);
+	phydev->duplex = DUPLEX_FULL;
+
+	if (backplane_is_mode_kr(phydev->interface)) {
+		/* AN init only for Master Lane */
+		an_init(&bpdev->lane[MASTER_LANE]);
+		/* start state machine on all lanes */
+		for (i = 0; i < bpdev->num_lanes; i++)
+			start_kr_state_machine(&bpdev->lane[i], KR_TIMEOUT_1);
+	}
+
+	bpdev->aneg_config = true;
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_config_aneg);
+
+int backplane_suspend(struct phy_device *phydev)
+{
+	struct backplane_device *bpdev = phydev->priv;
+	int i;
+
+	if (!phydev->mdio.dev.of_node) {
+		phydev_err(phydev, "No associated device tree node\n");
+		return -EINVAL;
+	}
+	if (!bpdev) {
+		phydev_err(phydev, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+
+	if (bpdev->aneg_config && !bpdev->phy_suspended) {
+		if (backplane_is_mode_kr(phydev->interface)) {
+			for (i = 0; i < bpdev->num_lanes; i++)
+				stop_kr_state_machine(&bpdev->lane[i]);
+		}
+		bpdev->phy_suspended = true;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_suspend);
+
+int backplane_resume(struct phy_device *phydev)
+{
+	struct backplane_device *bpdev = phydev->priv;
+	int i;
+
+	if (!phydev->mdio.dev.of_node) {
+		phydev_err(phydev, "No associated device tree node\n");
+		return -EINVAL;
+	}
+	if (!bpdev) {
+		phydev_err(phydev, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+
+	if (bpdev->aneg_config && bpdev->phy_suspended) {
+		if (backplane_is_mode_kr(phydev->interface)) {
+			for (i = 0; i < bpdev->num_lanes; i++) {
+				init_kr_lane(&bpdev->lane[i], true);
+				start_kr_state_machine(&bpdev->lane[i],
+						       KR_TIMEOUT_1);
+			}
+		}
+		bpdev->phy_suspended = false;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_resume);
+
+int backplane_read_status(struct phy_device *phydev)
+{
+	struct backplane_device *bpdev = phydev->priv;
+
+	if (!phydev->mdio.dev.of_node) {
+		phydev_err(phydev, "No associated device tree node\n");
+		return -EINVAL;
+	}
+	if (!bpdev) {
+		phydev_err(phydev, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+
+	/* Linkup method proposal for training stability:
+	 * Don't raise linkup until all lanes are trained
+	 * in order to prevent interface sending packets that may
+	 * interfere with the training packets
+	 */
+	if (backplane_is_link_up(phydev))
+		if (backplane_is_mode_kr(phydev->interface))
+			phydev->link = backplane_are_all_lanes_trained(bpdev);
+		else
+			phydev->link = 1;
+	else
+		phydev->link = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL(backplane_read_status);
+
+int backplane_match_phy_device(struct phy_device *phydev)
+{
+	struct device_node *dev_node;
+
+	if (!phydev->is_c45)
+		return 0;
+
+	dev_node = phydev->mdio.dev.of_node;
+	if (!dev_node) {
+		phydev_err(phydev, "No associated device tree node\n");
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
+
+	mutex_init(&backplane_lock);
+	backplane_features_init();
+
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
index 0000000..d142e83
--- /dev/null
+++ b/drivers/net/phy/backplane/backplane.h
@@ -0,0 +1,293 @@
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
+#define MAX_KR_LANES_PER_PHY			1
+
+/* Lanes definitions */
+#define MASTER_LANE				0
+#define SINGLE_LANE				0
+
+/* Number of device specific kr coefficients (device specific extension) */
+#define DEVICE_KR_COEF_NO			6
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
+struct kr_coef {
+	u32 preq;
+	u32 mainq;
+	u32 postq;
+	/* device specific extension */
+	u32 dev_coef[DEVICE_KR_COEF_NO];
+};
+
+/* Endianness specific memory I/O */
+struct mem_io {
+	u32 (*read32)(void __iomem *addr);
+	void (*write32)(u32 value, void __iomem *addr);
+};
+
+/* Generic Lane operations */
+struct lane_ops {
+	/* device specific private extension */
+	const void *priv;
+	/* lane memory map size */
+	u32 memmap_size;
+	void (*reset_lane)(void __iomem *reg, enum lane_req req);
+	void (*tune_lane_kr)(void __iomem *reg, struct kr_coef *coef,
+			     bool reset);
+	void (*read_lane_kr)(void __iomem *reg, struct kr_coef *coef);
+	bool (*is_cdr_lock)(void __iomem *reg);
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
+struct backplane_device;
+
+/* Lane kr */
+struct lane_kr {
+	/* KR parameters (current, default, tuned) */
+	struct kr_coef crt_kr;
+	struct kr_coef def_kr;
+	struct kr_coef tuned_kr;
+	/* equalization */
+	const struct equalization_algorithm *eq_alg;
+	struct eq_data_priv *eq_priv;
+	/* training status */
+	struct training_status trst;
+	enum train_state state;
+	/* AN KR status */
+	bool an_kr_detected;
+	u32 an_kr_wait_count;
+	u64 an_kr_timeout;
+	/* KR LD/LP updates and status */
+	u32 ld_update;
+	u32 prev_ld_update;
+	/* last change (non-hold) update */
+	u32 ld_last_nonhold_update;
+	u32 ld_status;
+	u32 lp_status;
+	/* last change (non-zero) status */
+	u32 lp_last_change_status;
+	u32 last_lp_update_status[C_NO];
+	/* link training status */
+	bool lt_error;
+	u32 req_ld_update_init_count;
+	u32 repeat_request_count;
+	u64 init_handshake_time;
+	bool first_recv_init;
+	/* move lp back */
+	bool move_back_prev;
+	u32 move_back_cnt;
+	u32 move_back_lp_status;
+};
+
+/* Lane device */
+struct lane_device {
+	/* lane memory map: registers base address */
+	void __iomem *reg_base;
+	/* lane memory map size */
+	u32 memmap_size;
+	/* lane address */
+	u32 lane_addr;
+	/* lane relative index inside multi-lane PHY */
+	u8 idx;
+	/* device specific private extension */
+	void *priv;
+	/* phy device */
+	struct phy_device *phydev;
+	struct backplane_device *bpdev;
+	struct lane_kr krln;
+	struct delayed_work krwk;
+	/* mutex between multiple lanes */
+	struct mutex lane_lock;
+};
+
+/* KR LT MMD (MDIO Managed Device) */
+struct kr_lt_mmd {
+	int devad;
+	u32 control;
+	u32 status;
+	u32 lp_cu;
+	u32 lp_status;
+	u32 ld_cu;
+	u32 ld_status;
+};
+
+/* Backplane kr */
+struct backplane_kr {
+	struct kr_coef min_kr;
+	struct kr_coef max_kr;
+	struct kr_coef def_kr;
+	/* defaults for eq kr are initialized from DT: eq-init */
+	bool valid_eq_init;
+	/* defaults for eq params are initialized from DT: eq-params */
+	bool valid_eq_params;
+	/* EQ algorithm name */
+	const char *eqa_name;
+	const struct equalizer_device *equalizer;
+	struct kr_lt_mmd ltmmd;
+};
+
+/* Backplane device specific callbacks */
+struct backplane_ops {
+	/* AN register ops */
+	void (*an_advertisement_init)(struct lane_device *lane);
+	bool (*is_an_link_detected)(struct lane_device *lane);
+	/* default settings ops */
+	void (*setup_default_settings)(struct lane_device *lane);
+	/* LT coefficients validation ops */
+	int (*lt_validation)(struct lane_device *lane, u32 *ld_coef);
+};
+
+/* Backplane driver */
+struct backplane_driver {
+	/* serdes base address */
+	u32 base_addr;
+	/* serdes memory map size */
+	u32 memmap_size;
+	/* serdes endianness */
+	bool is_little_endian;
+	/* memory I/O */
+	struct mem_io io;
+	/* backplane ops */
+	struct backplane_ops bp_ops;
+	/* lane ops */
+	const struct lane_ops *lane_ops;
+	/* device specific private extension */
+	void *priv;
+};
+
+/* Backplane device */
+struct backplane_device {
+	struct phy_device *phydev;
+	u8 num_lanes;
+	bool aneg_config;
+	bool aneg_done;
+	bool phy_suspended;
+	/* backplane management functions */
+	struct backplane_driver drv;
+	/* backplane kr */
+	struct backplane_kr bpkr;
+	/* kr lanes array: valid elements = num_lanes */
+	struct lane_device lane[MAX_KR_LANES_PER_PHY];
+	/* device specific private extension */
+	void *priv;
+	/* bpphy mutexes */
+	struct mutex bpphy_lock;
+	/* mutex between multiple lanes training */
+	struct mutex trained_lock;
+};
+
+bool backplane_is_mode_kr(phy_interface_t interface);
+
+bool backplane_is_valid_mode(phy_interface_t interface);
+
+u8 backplane_num_lanes(phy_interface_t interface);
+
+u32 backplane_get_an_bp_eth_status_bit(phy_interface_t interface);
+
+u32 backplane_get_an_adv1_init(phy_interface_t interface);
+
+bool backplane_is_single_lane(struct backplane_device *bpdev);
+
+bool backplane_is_multi_lane(struct backplane_device *bpdev);
+
+int backplane_are_all_lanes_trained(struct backplane_device *bpdev);
+
+int backplane_get_lanes_trained_count(struct backplane_device *bpdev);
+
+int backplane_is_link_up(struct phy_device *phydev);
+
+void backplane_kr_lt_mmd_c45(struct backplane_kr *bpkr);
+
+void backplane_kr_lt_mmd_setup(struct backplane_kr *bpkr, int devad, u32 base);
+
+int backplane_read_mmd(struct lane_device *lane, int devad, u32 regnum);
+
+int backplane_write_mmd(struct lane_device *lane, int devad, u32 regnum,
+			u16 val);
+
+void backplane_default_kr_lane(struct lane_device *lane);
+
+void backplane_get_current_taps(struct lane_device *lane, u32 *coef);
+
+void backplane_set_current_taps(struct lane_device *lane, u32 *coef);
+
+void backplane_set_all_taps_to_max(struct lane_device *lane);
+
+void backplane_tune_kr_lane(struct lane_device *lane, bool reset_lane);
+
+/* generic main operations to be used on probe callback */
+
+int backplane_create(struct phy_device *phydev);
+
+int backplane_parse_dt(struct phy_device *phydev);
+
+int backplane_setup_memio(struct phy_device *phydev);
+
+int backplane_setup_mmd(struct phy_device *phydev);
+
+int backplane_setup_lanes(struct phy_device *phydev);
+
+int backplane_initialize(struct phy_device *phydev);
+
+/* predefined phy_driver callback functions */
+
+int backplane_probe(struct phy_device *phydev);
+
+void backplane_remove(struct phy_device *phydev);
+
+int backplane_config_init(struct phy_device *phydev);
+
+int backplane_aneg_done(struct phy_device *phydev);
+
+int backplane_config_aneg(struct phy_device *phydev);
+
+int backplane_suspend(struct phy_device *phydev);
+
+int backplane_resume(struct phy_device *phydev);
+
+int backplane_read_status(struct phy_device *phydev);
+
+int backplane_match_phy_device(struct phy_device *phydev);
+
+#endif /* __BACKPLANE_H */
diff --git a/drivers/net/phy/backplane/eq_fixed.c b/drivers/net/phy/backplane/eq_fixed.c
new file mode 100644
index 0000000..827450e
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
+static struct eq_data_priv *create(struct equalizer_driver eqdrv)
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
index 0000000..767f0159
--- /dev/null
+++ b/drivers/net/phy/backplane/equalization.h
@@ -0,0 +1,275 @@
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
+struct lane_device;
+struct equalizer_driver;
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
+	struct eq_data_priv *(*create)(struct equalizer_driver eqdrv);
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
+/* Equalizer device and operations */
+struct equalizer_device {
+	const char *name;
+	const char *version;
+	struct equalizer_ops ops;
+};
+
+/* Equalization driver */
+struct equalizer_driver {
+	struct phy_device *phydev;
+	/* lane info used as parameter for link training API */
+	struct lane_device *lane;
+	/* lane reg base used as parameter for equalizer ops */
+	void *reg_base;
+	const struct equalizer_device *equalizer;
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
+void lt_lp_update(struct lane_device *lane, u32 update);
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
+bool lt_is_lp_at_startup(struct lane_device *lane, enum req_type type);
+
+enum coef_status lt_get_lp_coef_status(struct lane_device *lane,
+				       enum coef_field field);
+
+void lt_move_lp_back(struct lane_device *lane);
+
+void lt_set_error(struct lane_device *lane, bool err);
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
+bool backplane_is_cdr_lock(struct lane_device *lane, bool retry);
+
+#endif /* __EQUALIZATION_H */
diff --git a/drivers/net/phy/backplane/link_training.c b/drivers/net/phy/backplane/link_training.c
new file mode 100644
index 0000000..3aa26f9
--- /dev/null
+++ b/drivers/net/phy/backplane/link_training.c
@@ -0,0 +1,1529 @@
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
+#define PRESET_MASK				0x2000
+#define INIT_MASK				0x1000
+#define COP1_MASK				0x30
+#define COP1_SHIFT				4
+#define COZ0_MASK				0xc
+#define COZ0_SHIFT				2
+#define COM1_MASK				0x3
+#define COM1_SHIFT				0
+#define ALL_COEF_MASK		(COP1_MASK | COZ0_MASK | COM1_MASK)
+#define LD_ALL_MASK		(PRESET_MASK | INIT_MASK | ALL_COEF_MASK)
+
+/* KR LP Status Report */
+#define LP_STATUS_ALL_COEF_UPDATED		0x15
+
+/* KR LP/LD Status Report:
+ * RX_READY_MASK - Receiver Ready
+ * 0b - The LP/LD receiver is requesting that training continue
+ * 1b - The LP/LD receiver has determined that training is complete
+ * and is prepared to receive data.
+ */
+#define RX_READY_MASK				0x8000
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
+#define KR_PMD_BASE_OFFSET			150
+
+/* Link training KR PMD registers offsets (relative to base) */
+#define OFFSET_KR_PMD_CTRL			0x0
+#define OFFSET_KR_PMD_STATUS			0x1
+#define OFFSET_KR_LP_CU				0x2
+#define OFFSET_KR_LP_STATUS			0x3
+#define OFFSET_KR_LD_CU				0x4
+#define OFFSET_KR_LD_STATUS			0x5
+
+/* Timeouts */
+#define TIMEOUT_MOVE_BACK_PREV			6
+#define TIMEOUT_REPEAT_REQUEST			10
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
+static void ld_coef_status(struct lane_device *lane)
+{
+	backplane_write_mmd(lane, lane->bpdev->bpkr.ltmmd.devad,
+			    lane->bpdev->bpkr.ltmmd.ld_status,
+			    lane->krln.ld_status);
+}
+
+/* ld_coef_update
+ * LD sends to LP the specified request for coefficients update
+ */
+static void ld_coef_update(struct lane_device *lane)
+{
+	backplane_write_mmd(lane, lane->bpdev->bpkr.ltmmd.devad,
+			    lane->bpdev->bpkr.ltmmd.ld_cu,
+			    lane->krln.ld_update);
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
+static u32 get_lp_lcs(struct lane_device *lane)
+{
+	return lane->krln.lp_last_change_status;
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
+static void initialize(struct lane_device *lane)
+{
+	backplane_default_kr_lane(lane);
+
+	lane->krln.ld_status &= ~ALL_COEF_MASK;
+	lane->krln.ld_status |= COEF_UPDATED << COP1_SHIFT |
+				COEF_UPDATED << COZ0_SHIFT |
+				COEF_UPDATED << COM1_SHIFT;
+
+	ld_coef_status(lane);
+}
+
+/* preset
+ * Preset as defined by: IEEE 802.3, sub-clause 72.6.10.2.3.1
+ * Setup all coefficients to MAX values from IEEE802.3 perspective
+ */
+static void preset(struct lane_device *lane)
+{
+	backplane_set_all_taps_to_max(lane);
+
+	backplane_tune_kr_lane(lane, true);
+
+	lane->krln.ld_status &= ~ALL_COEF_MASK;
+	lane->krln.ld_status |= COEF_MAX << COP1_SHIFT |
+				COEF_MAX << COZ0_SHIFT |
+				COEF_MAX << COM1_SHIFT;
+
+	ld_coef_status(lane);
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
+static int is_ld_valid(struct lane_device *lane, u32 *ld_coef)
+{
+	struct backplane_kr *bpkr = &lane->bpdev->bpkr;
+	u32 mainq = ld_coef[C_Z0];
+	u32 postq = ld_coef[C_P1];
+	u32 preq = ld_coef[C_M1];
+
+	/* Basic HW restrictions: */
+
+	/* 1. tx_preq <= MIN_C(-1) */
+	if (preq > bpkr->min_kr.preq)
+		return -ERANGE;
+	/* 2. tx_ratio_post1q <= MIN_C(+1) */
+	if (postq > bpkr->min_kr.postq)
+		return -ERANGE;
+	/* 3. MIN_C(0) <= tx_mainq <= MAX_C(0) */
+	if (mainq < bpkr->min_kr.mainq)
+		return -ERANGE;
+	if (mainq > bpkr->max_kr.mainq)
+		return -ERANGE;
+	/* 4. tx_ratio_post1q >= tx_preq */
+	if (postq < preq)
+		return -ERANGE;
+
+	/* Additional HW restrictions:
+	 * LT custom HW validation: Device specific HW restrictions
+	 */
+	if (lane->bpdev->drv.bp_ops.lt_validation)
+		return lane->bpdev->drv.bp_ops.lt_validation(lane, ld_coef);
+
+	return 0;
+}
+
+static bool update_ld_status(struct lane_device *lane, enum coef_field field,
+			     enum coef_status cs)
+{
+	u32 ld_cs = cs;
+	u32 mask, val;
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
+	lane->krln.ld_status &= ~mask;
+	lane->krln.ld_status |= val;
+
+	return true;
+}
+
+static enum coef_status inc_dec(struct lane_device *lane,
+				enum coef_field field, int request)
+{
+	u32 ld_coef[C_NO], step[C_NO], ld_limit[C_NO];
+	int err;
+
+	backplane_get_current_taps(lane, ld_coef);
+
+	step[C_M1] = STEP_INCREMENT_M1;
+	step[C_Z0] = STEP_INCREMENT_Z0;
+	step[C_P1] = STEP_INCREMENT_P1;
+
+	/* 72.6.10.2.5 Coefficient update process
+	 * Upon execution of a received increment or decrement request,
+	 * the status is reported as updated, maximum, or minimum.
+	 */
+	switch (request) {
+	case INCREMENT:
+		ld_limit[C_M1] = lane->bpdev->bpkr.max_kr.preq;
+		ld_limit[C_Z0] = lane->bpdev->bpkr.max_kr.mainq;
+		ld_limit[C_P1] = lane->bpdev->bpkr.max_kr.postq;
+		if (ld_coef[field] != ld_limit[field])
+			ld_coef[field] += step[field];
+		else
+			return COEF_MAX;
+		break;
+	case DECREMENT:
+		ld_limit[C_M1] = lane->bpdev->bpkr.min_kr.preq;
+		ld_limit[C_Z0] = lane->bpdev->bpkr.min_kr.mainq;
+		ld_limit[C_P1] = lane->bpdev->bpkr.min_kr.postq;
+		if (ld_coef[field] != ld_limit[field])
+			ld_coef[field] -= step[field];
+		else
+			return COEF_MIN;
+		break;
+	default:
+		break;
+	}
+
+	err = is_ld_valid(lane, ld_coef);
+	if (!err) {
+		/* accept new ld coefficients */
+		backplane_set_current_taps(lane, ld_coef);
+		backplane_tune_kr_lane(lane, false);
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
+static void check_request(struct lane_device *lane, int request)
+{
+	enum coef_status cu = COEF_INVALID;
+	int cop1_req, coz0_req, com1_req;
+	int old_status;
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
+	old_status = lane->krln.ld_status;
+
+	if (cop1_req && !(lane->krln.ld_status & COP1_MASK)) {
+		cu = inc_dec(lane, C_P1, cop1_req);
+		update_ld_status(lane, C_P1, cu);
+	}
+
+	if (coz0_req && !(lane->krln.ld_status & COZ0_MASK)) {
+		cu = inc_dec(lane, C_Z0, coz0_req);
+		update_ld_status(lane, C_Z0, cu);
+	}
+
+	if (com1_req && !(lane->krln.ld_status & COM1_MASK)) {
+		cu = inc_dec(lane, C_M1, com1_req);
+		update_ld_status(lane, C_M1, cu);
+	}
+
+	if (old_status != lane->krln.ld_status)
+		ld_coef_status(lane);
+}
+
+static void training_complete(struct lane_device *lane)
+{
+	struct training_status *trst = &lane->krln.trst;
+
+	/* update training status */
+	trst->remote_tx_complete = true;
+	trst->remote_tx_running = false;
+
+	/* report LD status */
+	lane->krln.ld_status |= RX_READY_MASK;
+	ld_coef_status(lane);
+
+	/* update PMD status and tell LP we are ready */
+	backplane_write_mmd(lane, lane->bpdev->bpkr.ltmmd.devad,
+			    lane->bpdev->bpkr.ltmmd.status,
+			    PMD_STATUS_RX_STAT);
+}
+
+/* Link Training general API */
+
+/* Setup standard KR LT MMD (MDIO Managed Device) for Clause 45
+ * 45.2.1.76 10GBASE-KR PMD control register (Register 1.150)
+ */
+void lt_mmd_c45(struct backplane_kr *bpkr)
+{
+	lt_mmd_setup(bpkr, MDIO_MMD_PMAPMD, KR_PMD_BASE_OFFSET);
+}
+
+/* Setup KR LT MMD (MDIO Managed Device)
+ * IEEE Std 802.3ap-2007: Table 45.3 PMA/PMD registers
+ */
+void lt_mmd_setup(struct backplane_kr *bpkr, int devad, u32 base)
+{
+	bpkr->ltmmd.devad = devad;
+	bpkr->ltmmd.control = base + OFFSET_KR_PMD_CTRL;
+	bpkr->ltmmd.status = base + OFFSET_KR_PMD_STATUS;
+	bpkr->ltmmd.lp_cu = base + OFFSET_KR_LP_CU;
+	bpkr->ltmmd.lp_status = base + OFFSET_KR_LP_STATUS;
+	bpkr->ltmmd.ld_cu = base + OFFSET_KR_LD_CU;
+	bpkr->ltmmd.ld_status = base + OFFSET_KR_LD_STATUS;
+}
+
+/* lt_is_lp_rx_ready
+ * Reports if LP Receiver is ready
+ * false: The LP receiver is requesting that training continue
+ * true: The LP receiver has determined that training is complete
+ * and is prepared to receive data.
+ */
+bool lt_is_lp_rx_ready(struct lane_device *lane)
+{
+	struct kr_lt_mmd *ltmmd = &lane->bpdev->bpkr.ltmmd;
+
+	/* Read LP Status */
+	lane->krln.lp_status = backplane_read_mmd(lane,
+						  ltmmd->devad,
+						  ltmmd->lp_status);
+	return is_rx_ready(lane->krln.lp_status);
+}
+
+/* lt_is_ld_rx_ready
+ * Reports if LD Receiver is ready
+ * false: The LD receiver is requesting that training continue
+ * true: The LD receiver has determined that training is complete
+ * and is prepared to receive data.
+ */
+bool lt_is_ld_rx_ready(struct lane_device *lane)
+{
+	return is_rx_ready(lane->krln.ld_status);
+}
+
+void lt_start(struct lane_device *lane)
+{
+	backplane_write_mmd(lane, lane->bpdev->bpkr.ltmmd.devad,
+			    lane->bpdev->bpkr.ltmmd.control,
+			    TRAIN_EN);
+}
+
+void lt_stop(struct lane_device *lane)
+{
+	backplane_write_mmd(lane, lane->bpdev->bpkr.ltmmd.devad,
+			    lane->bpdev->bpkr.ltmmd.control,
+			    TRAIN_DISABLE);
+}
+
+void lt_reset(struct lane_device *lane)
+{
+	backplane_write_mmd(lane, lane->bpdev->bpkr.ltmmd.devad, MDIO_CTRL1,
+			    PMD_RESET);
+	backplane_write_mmd(lane, lane->bpdev->bpkr.ltmmd.devad,
+			    lane->bpdev->bpkr.ltmmd.control,
+			    TRAIN_DISABLE);
+	backplane_write_mmd(lane, lane->bpdev->bpkr.ltmmd.devad,
+			    lane->bpdev->bpkr.ltmmd.ld_cu, 0);
+	backplane_write_mmd(lane, lane->bpdev->bpkr.ltmmd.devad,
+			    lane->bpdev->bpkr.ltmmd.ld_status, 0);
+	backplane_write_mmd(lane, lane->bpdev->bpkr.ltmmd.devad,
+			    lane->bpdev->bpkr.ltmmd.status, 0);
+	backplane_write_mmd(lane, lane->bpdev->bpkr.ltmmd.devad,
+			    lane->bpdev->bpkr.ltmmd.lp_cu, 0);
+	backplane_write_mmd(lane, lane->bpdev->bpkr.ltmmd.devad,
+			    lane->bpdev->bpkr.ltmmd.lp_status, 0);
+}
+
+/* lt_is_rx_trained
+ * IEEE Std 802.3ap-2007: Table 72.3 MDIO/PMD status variable mapping
+ * PMD status variable: rx_trained
+ */
+bool lt_is_rx_trained(struct lane_device *lane)
+{
+	struct phy_device *phydev = lane->phydev;
+	int timeout = 100;
+	int val;
+
+	val = backplane_read_mmd(lane, lane->bpdev->bpkr.ltmmd.devad,
+				 lane->bpdev->bpkr.ltmmd.status);
+
+	if ((val & PMD_STATUS_RX_STAT) && !(val & PMD_STATUS_TRAIN_FAIL)) {
+		while (timeout--) {
+			if (backplane_is_link_up(phydev))
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
+bool lt_is_training_failure(struct lane_device *lane)
+{
+	struct kr_lt_mmd *ltmmd = &lane->bpdev->bpkr.ltmmd;
+	int lt_state;
+
+	lt_state = backplane_read_mmd(lane, ltmmd->devad, ltmmd->status);
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
+bool lt_is_frame_lock(struct lane_device *lane)
+{
+	struct kr_lt_mmd *ltmmd = &lane->bpdev->bpkr.ltmmd;
+	int lt_state;
+
+	lt_state = backplane_read_mmd(lane, ltmmd->devad, ltmmd->status);
+
+	if ((lt_state & PMD_STATUS_SUP_STAT) &&
+	    (lt_state & PMD_STATUS_FRAME_LOCK))
+		return true;
+
+	return false;
+}
+
+/* Training for Remote Tx
+ * This is the main routine for Remote Tx training
+ */
+void lt_train_remote_tx(struct lane_device *lane)
+{
+	const struct equalization_algorithm *eq_alg = lane->krln.eq_alg;
+	struct training_status *trst = &lane->krln.trst;
+	u32 prev_req_cp1, prev_req_cz0, prev_req_cm1;
+	u32 status_cp1, status_cz0, status_cm1;
+	u32 prev_req_init, prev_req_preset;
+	u64 lp_resp_time;
+
+	/* Check stop condition for Remote Tx training */
+	if (trst->remote_tx_complete)
+		return;
+
+	/* Check if equalization algorithm is installed */
+	if (!eq_alg)
+		return;
+
+	/* Check that all required callback operations are installed */
+	if (!eq_alg->ops.collect_statistics ||
+	    !eq_alg->ops.is_rx_ok ||
+	    !eq_alg->ops.generate_request ||
+	    !eq_alg->ops.is_eq_done)
+		return;
+
+	/* Start new Remote Tx training step */
+	trst->remote_tx_running = true;
+
+	/* Store current state as previous state */
+	lane->krln.prev_ld_update = lane->krln.ld_update;
+	if ((lane->krln.prev_ld_update & ALL_COEF_MASK) != HOLD)
+		lane->krln.ld_last_nonhold_update = lane->krln.prev_ld_update;
+
+	prev_req_init = lane->krln.prev_ld_update & INIT_MASK;
+	prev_req_preset = lane->krln.prev_ld_update & PRESET_MASK;
+	prev_req_cp1 = (lane->krln.prev_ld_update & COP1_MASK) >> COP1_SHIFT;
+	prev_req_cz0 = (lane->krln.prev_ld_update & COZ0_MASK) >> COZ0_SHIFT;
+	prev_req_cm1 = (lane->krln.prev_ld_update & COM1_MASK) >> COM1_SHIFT;
+
+	/* Training Done condition */
+	if (eq_alg->ops.is_eq_done(lane->krln.eq_priv))
+		trst->done_training = true;
+
+	/* Check if Training is Done */
+	if (trst->done_training) {
+		training_complete(lane);
+		return;
+	}
+
+	/* Read LP Status */
+	lane->krln.lp_status =
+		backplane_read_mmd(lane, lane->bpdev->bpkr.ltmmd.devad,
+				   lane->bpdev->bpkr.ltmmd.lp_status);
+
+	if ((lane->krln.lp_status & ALL_COEF_MASK) != 0)
+		lane->krln.lp_last_change_status = lane->krln.lp_status;
+
+	status_cp1 = (lane->krln.lp_status & COP1_MASK) >> COP1_SHIFT;
+	status_cz0 = (lane->krln.lp_status & COZ0_MASK) >> COZ0_SHIFT;
+	status_cm1 = (lane->krln.lp_status & COM1_MASK) >> COM1_SHIFT;
+
+	if (status_cp1 == COEF_UPDATED || status_cp1 == COEF_MIN ||
+	    status_cp1 == COEF_MAX)
+		lane->krln.last_lp_update_status[C_P1] = status_cp1;
+	if (status_cz0 == COEF_UPDATED || status_cz0 == COEF_MIN ||
+	    status_cz0 == COEF_MAX)
+		lane->krln.last_lp_update_status[C_Z0] = status_cz0;
+	if (status_cm1 == COEF_UPDATED || status_cm1 == COEF_MIN ||
+	    status_cm1 == COEF_MAX)
+		lane->krln.last_lp_update_status[C_M1] = status_cm1;
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
+			lane->krln.ld_update = INIT_MASK;
+			lane->krln.req_ld_update_init_count = 1;
+			lane->krln.init_handshake_time =
+						jiffies_to_msecs(jiffies);
+		} else {
+			/* send HOLD before sending subsequent Init requests
+			 * this is not the very first Init sent
+			 */
+			lane->krln.ld_update = HOLD;
+		}
+		ld_coef_update(lane);
+		return;
+	}
+	/* continue to sent init request until LP responds to init */
+	if (prev_req_init) {
+		if (lane->krln.lp_status == 0) {
+			/* nothing to do here for now
+			 * perhaps the partner board LP has not yet started
+			 * so continue to send INIT requests
+			 * this will happen in the next condition anyway
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
+			lane->krln.ld_update = INIT_MASK;
+			ld_coef_update(lane);
+			lane->krln.req_ld_update_init_count++;
+		} else {
+			/* IEEE802.3-2008, 72.6.10.2.3.2
+			 * We may clear INITIALIZE when no coefficients
+			 * show NOT UPDATED.
+			 */
+			/* v1: lane->krln.ld_update &= ~INIT_MASK; */
+			/* better send request: HOLD ALL
+			 * should be equivalent since only INIT is set now
+			 */
+			lane->krln.ld_update = HOLD;
+
+			lp_resp_time = jiffies_to_msecs(jiffies) -
+					       lane->krln.init_handshake_time;
+			if (!lane->krln.first_recv_init) {
+				/* Init handshake not done yet,
+				 * but will be soon
+				 */
+				lane->krln.req_ld_update_init_count = 1;
+				lp_resp_time = 0;
+			}
+			ld_coef_update(lane);
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
+			lane->krln.ld_update &= ~PRESET_MASK;
+		} else {
+			/* All status MUST be NOTUPDATED for INIT to be executed
+			 * otherwise send HOLD first
+			 */
+			if (status_cp1 == COEF_NOTUPDATED &&
+			    status_cz0 == COEF_NOTUPDATED &&
+			    status_cm1 == COEF_NOTUPDATED) {
+				lane->krln.ld_update = PRESET_MASK;
+			} else {
+				/* send HOLD before sending subsequent
+				 * Preset requests
+				 */
+				lane->krln.ld_update = HOLD;
+			}
+			ld_coef_update(lane);
+			return;
+		}
+	}
+
+	/* IEEE802.3-2008, 72.6.10.2.3.3
+	 * We only request coefficient updates when no PRESET/INITIALIZE is
+	 * pending. We also only request coefficient updates when the
+	 * corresponding status is NOT UPDATED and nothing is pending.
+	 */
+	if (lane->krln.ld_update & (PRESET_MASK | INIT_MASK))
+		return;
+
+	/* continue to move back to previous request until LP responds to it
+	 * Move back to previous C(-1), C(0), C(+1) and HOLD
+	 */
+	if (lane->krln.move_back_prev) {
+		/* can exit from here only with: DONE Training */
+		if (lane->krln.move_back_cnt == TIMEOUT_MOVE_BACK_PREV) {
+			trst->done_training = true;
+			training_complete(lane);
+			return;
+		}
+		lane->krln.move_back_cnt++;
+
+		if (status_cp1 == COEF_UPDATED)
+			lane->krln.move_back_lp_status |=
+						(COEF_UPDATED << COP1_SHIFT);
+		if (status_cz0 == COEF_UPDATED)
+			lane->krln.move_back_lp_status |=
+						(COEF_UPDATED << COZ0_SHIFT);
+		if (status_cm1 == COEF_UPDATED)
+			lane->krln.move_back_lp_status |=
+						(COEF_UPDATED << COM1_SHIFT);
+
+		if ((lane->krln.move_back_lp_status & ALL_COEF_MASK) ==
+						LP_STATUS_ALL_COEF_UPDATED) {
+			trst->done_training = true;
+			training_complete(lane);
+			return;
+		}
+
+		/* Move back to previous C(-1), C(0), C(+1) */
+		lane->krln.ld_update = lane->krln.prev_ld_update;
+		ld_coef_update(lane);
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
+			if (lane->krln.repeat_request_count >=
+						TIMEOUT_REPEAT_REQUEST) {
+				phydev_err(lane->phydev,
+					   "REQ Timeout: Repeating C(+1) HOLD request without LP response timeout !\n");
+				/* Hold Request Timeout:
+				 * continue to send HOLD until LP responds
+				 * with NOTUPDATED
+				 */
+				lane->krln.repeat_request_count = 0;
+			} else {
+				/* Allow LP some time to respond
+				 * and repeat request
+				 */
+				msleep(20);
+				/* Allow LP more time to respond,
+				 * as the last chance, on the last time
+				 * before issuing timeout error: (3.)
+				 */
+				if (lane->krln.repeat_request_count ==
+						TIMEOUT_REPEAT_REQUEST - 1)
+					msleep(30);
+				lane->krln.repeat_request_count++;
+			}
+			ld_coef_update(lane);
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
+			if (lane->krln.repeat_request_count >=
+						TIMEOUT_REPEAT_REQUEST) {
+				if (prev_req_cp1 == INCREMENT)
+					phydev_err(lane->phydev,
+						   "REQ Timeout: Repeating C(+1) INC request without LP response timeout !\n");
+				else
+					phydev_err(lane->phydev,
+						   "REQ Timeout: Repeating C(+1) DEC request without LP response timeout !\n");
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
+				if (lane->krln.repeat_request_count ==
+						TIMEOUT_REPEAT_REQUEST - 1)
+					msleep(30);
+				lane->krln.repeat_request_count++;
+				ld_coef_update(lane);
+				return;
+			}
+		} else {
+			/* All good here:
+			 * LP responded to this Request
+			 * Sent HOLD for this coefficient
+			 * before asking another request
+			 * continue to check the other coefficient requests
+			 */
+			lane->krln.ld_update &= ~COP1_MASK;
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
+			if (lane->krln.repeat_request_count >=
+						TIMEOUT_REPEAT_REQUEST) {
+				phydev_err(lane->phydev,
+					   "REQ Timeout: Repeating C(0) HOLD request without LP response timeout !\n");
+				/* Hold Request Timeout:
+				 * continue to send HOLD until LP responds
+				 * with NOTUPDATED
+				 */
+				lane->krln.repeat_request_count = 0;
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
+				if (lane->krln.repeat_request_count ==
+						TIMEOUT_REPEAT_REQUEST - 1)
+					msleep(30);
+				lane->krln.repeat_request_count++;
+			}
+			ld_coef_update(lane);
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
+			if (lane->krln.repeat_request_count >=
+						TIMEOUT_REPEAT_REQUEST) {
+				if (prev_req_cz0 == INCREMENT)
+					phydev_err(lane->phydev,
+						   "REQ Timeout: Repeating C(0) INC request without LP response timeout !\n");
+				else
+					phydev_err(lane->phydev,
+						   "REQ Timeout: Repeating C(0) DEC request without LP response timeout !\n");
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
+				if (lane->krln.repeat_request_count ==
+						TIMEOUT_REPEAT_REQUEST - 1)
+					msleep(30);
+				lane->krln.repeat_request_count++;
+				ld_coef_update(lane);
+				return;
+			}
+		} else {
+			/* All good here:
+			 * LP responded to this Request
+			 * Sent HOLD for this coefficient
+			 * before asking another request
+			 * continue to check the other coefficient requests
+			 */
+			lane->krln.ld_update &= ~COZ0_MASK;
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
+			if (lane->krln.repeat_request_count >=
+						TIMEOUT_REPEAT_REQUEST) {
+				phydev_err(lane->phydev,
+					   "REQ Timeout: Repeating C(-1) HOLD request without LP response timeout !\n");
+				/* Hold Request Timeout:
+				 * continue to send HOLD until
+				 * LP responds with NOTUPDATED
+				 */
+				lane->krln.repeat_request_count = 0;
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
+				if (lane->krln.repeat_request_count ==
+						TIMEOUT_REPEAT_REQUEST - 1)
+					msleep(30);
+				lane->krln.repeat_request_count++;
+			}
+			ld_coef_update(lane);
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
+			if (lane->krln.repeat_request_count >=
+						TIMEOUT_REPEAT_REQUEST) {
+				if (prev_req_cm1 == INCREMENT)
+					phydev_err(lane->phydev,
+						   "REQ Timeout: Repeating C(-1) INC request without LP response timeout !\n");
+				else
+					phydev_err(lane->phydev,
+						   "REQ Timeout: Repeating C(-1) DEC request without LP response timeout !\n");
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
+				if (lane->krln.repeat_request_count ==
+						TIMEOUT_REPEAT_REQUEST - 1)
+					msleep(30);
+				lane->krln.repeat_request_count++;
+				ld_coef_update(lane);
+				return;
+			}
+		} else {
+			/* All good here:
+			 * LP responded to this Request
+			 * Sent HOLD for this coefficient
+			 * before asking another request
+			 * continue to check the other coefficient requests
+			 */
+			lane->krln.ld_update &= ~COM1_MASK;
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
+	lane->krln.repeat_request_count = 0;
+
+	if (lane->krln.prev_ld_update != lane->krln.ld_update) {
+		ld_coef_update(lane);
+		/* Redo these status checks and updates until we have no more
+		 * changes, to speed up the overall process.
+		 */
+		return;
+	}
+
+	/* Do nothing if we have pending request. */
+	if (prev_req_cp1 || prev_req_cz0 || prev_req_cm1)
+		return;
+	else if (lane->krln.lp_status & ALL_COEF_MASK)
+		/* No pending request but LP status was not reverted to
+		 * not updated.
+		 */
+		return;
+
+	/* Initialize status for the current step */
+	lane->krln.lt_error = false;
+
+	/* if CDR_LOCK = 0: Statistics are invalid */
+	if (!backplane_is_cdr_lock(lane, true)) {
+		if (eq_alg->ops.process_bad_state)
+			eq_alg->ops.process_bad_state(lane->krln.eq_priv);
+		return;
+	}
+
+	/* collect bit edge statistics */
+	if (!eq_alg->ops.collect_statistics(lane->krln.eq_priv))
+		return;
+
+	/* if CDR_LOCK = 0: Statistics are invalid */
+	if (!backplane_is_cdr_lock(lane, true)) {
+		if (eq_alg->ops.process_bad_state)
+			eq_alg->ops.process_bad_state(lane->krln.eq_priv);
+		return;
+	}
+
+	/* Check Rx */
+	if (!eq_alg->ops.is_rx_ok(lane->krln.eq_priv)) {
+		if (eq_alg->ops.process_bad_state)
+			eq_alg->ops.process_bad_state(lane->krln.eq_priv);
+		return;
+	}
+	eq_alg->ops.generate_request(lane->krln.eq_priv);
+
+	/* All C are in Hold and both Bins are stopped:
+	 * So the Training is done
+	 */
+	if (eq_alg->ops.is_eq_done(lane->krln.eq_priv)) {
+		trst->done_training = true;
+		training_complete(lane);
+	}
+}
+
+/* Training for Local Tx
+ * Initialize LD (Local Device)
+ */
+void lt_init_ld(struct lane_device *lane)
+{
+	/* report initial ld status to lp */
+	lane->krln.ld_status = 0;
+	ld_coef_status(lane);
+}
+
+/* Training for Local Tx
+ * This is the main routine for Local Tx training
+ */
+void lt_train_local_tx(struct lane_device *lane)
+{
+	struct training_status *trst = &lane->krln.trst;
+	int request, old_ld_status;
+
+	/* Check stop condition for Local Tx training */
+	trst->lp_rx_ready = lt_is_lp_rx_ready(lane);
+	if (trst->lp_rx_ready) {
+		/* LP receiver is ready
+		 * As soon as the LP shows ready,
+		 * no need to do any more updates.
+		 */
+		lane->krln.ld_status &= ~ALL_COEF_MASK;
+		ld_coef_status(lane);
+
+		trst->local_tx_running = false;
+		return;
+	}
+
+	/* Start new Local Tx training step */
+	trst->local_tx_running = true;
+
+	/* get request from LP */
+	request = backplane_read_mmd(lane, lane->bpdev->bpkr.ltmmd.devad,
+				     lane->bpdev->bpkr.ltmmd.lp_cu) &
+					LD_ALL_MASK;
+
+	old_ld_status = lane->krln.ld_status;
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
+			lane->krln.ld_status &= ~COP1_MASK;
+
+		if (!(request & COZ0_MASK))
+			lane->krln.ld_status &= ~COZ0_MASK;
+
+		if (!(request & COM1_MASK))
+			lane->krln.ld_status &= ~COM1_MASK;
+
+		ld_coef_status(lane);
+	}
+
+	/* IEEE802.3-2008, 72.6.10.2.3.1/2
+	 * only act on PRESET/INITIALIZE if all status is NOT UPDATED.
+	 */
+	if (request & (PRESET_MASK | INIT_MASK)) {
+		if (!(lane->krln.ld_status & ALL_COEF_MASK)) {
+			if (request & PRESET_MASK)
+				preset(lane);
+
+			if (request & INIT_MASK) {
+				if (!lane->krln.first_recv_init) {
+					lane->krln.first_recv_init = true;
+					/* Init requests must be counted
+					 * from initial handshake
+					 */
+					lane->krln.req_ld_update_init_count = 1;
+					lane->krln.init_handshake_time =
+						jiffies_to_msecs(jiffies);
+				}
+				initialize(lane);
+			}
+		} else {
+			/* Inform the partner about current ld status
+			 * which should be: ALL UPDATED for INIT  and
+			 * ALL MAX for PRESET
+			 */
+			ld_coef_status(lane);
+		}
+	}
+
+	/* check if LP Coefficient are not in HOLD */
+	if (request & ALL_COEF_MASK)
+		check_request(lane, request & ALL_COEF_MASK);
+
+	/* Make sure the partner is always informed about the current ld status
+	 * this will ensure avoidance of several training issues and errors:
+	 *   'link_training_failed'
+	 *   'Repeating request without LP response'
+	 */
+	ld_coef_status(lane);
+}
+
+/* Training for Remote Tx API */
+
+/* lt_lp_update
+ *
+ * Sends to LP the specified request for coefficients update
+ *
+ * lane: desired lane for which to send lp update
+ * update: desired update request to be sent to LP
+ *
+ * Returns: None
+ */
+void lt_lp_update(struct lane_device *lane, u32 update)
+{
+	lane->krln.ld_update = update;
+	ld_coef_update(lane);
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
+ * lane: desired lane to be verified
+ * req: request type to check startup status
+ *	it makes sense only for INIT or PRESET requests
+ *
+ * Returns: true if LP status is still at startup status or false otherwise
+ */
+bool lt_is_lp_at_startup(struct lane_device *lane, enum req_type type)
+{
+	u32 lp_lcs = get_lp_lcs(lane);
+	u32 lp_st = lane->krln.lp_status;
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
+ * lane: desired lane to be verified
+ * field: coefficient field to be verified
+ *
+ * Returns: the last LP coefficient status
+ */
+enum coef_status lt_get_lp_coef_status(struct lane_device *lane,
+				       enum coef_field field)
+{
+	return lane->krln.last_lp_update_status[field];
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
+ * lane: desired lane to set lt error
+ * err: boolean value that specifies if set or reset the error flag
+ *
+ * Returns: None
+ */
+void lt_set_error(struct lane_device *lane, bool err)
+{
+	lane->krln.lt_error = err;
+}
+EXPORT_SYMBOL(lt_set_error);
+
+/* lt_move_lp_back
+ * Request LP to move back to previous coefficients setup and HOLD
+ * The procedure for sending this request is based on reverting the
+ * latest change request (non-hold update) for all coefficients
+ * This procedure should be used to exit from bad states like not CDR_Lock
+ *
+ * lane: desired lane for which to send lp update
+ *
+ * Returns: None
+ */
+void lt_move_lp_back(struct lane_device *lane)
+{
+	u32 prev_req_cp1 = (lane->krln.ld_last_nonhold_update & COP1_MASK) >>
+				COP1_SHIFT;
+	u32 prev_req_cz0 = (lane->krln.ld_last_nonhold_update & COZ0_MASK) >>
+				COZ0_SHIFT;
+	u32 prev_req_cm1 = (lane->krln.ld_last_nonhold_update & COM1_MASK) >>
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
+	lane->krln.ld_update = temp;
+	ld_coef_update(lane);
+
+	/* start the procedure for sending request to move LP back
+	 * to previous setup until LP responds to it
+	 */
+	lane->krln.move_back_prev = true;
+	lane->krln.move_back_cnt = 0;
+	lane->krln.move_back_lp_status = 0;
+	if (prev_req_cp1 == HOLD)
+		lane->krln.move_back_lp_status |= (COEF_UPDATED << COP1_SHIFT);
+	if (prev_req_cz0 == HOLD)
+		lane->krln.move_back_lp_status |= (COEF_UPDATED << COZ0_SHIFT);
+	if (prev_req_cm1 == HOLD)
+		lane->krln.move_back_lp_status |= (COEF_UPDATED << COM1_SHIFT);
+}
+EXPORT_SYMBOL(lt_move_lp_back);
diff --git a/drivers/net/phy/backplane/link_training.h b/drivers/net/phy/backplane/link_training.h
new file mode 100644
index 0000000..fae5f35
--- /dev/null
+++ b/drivers/net/phy/backplane/link_training.h
@@ -0,0 +1,32 @@
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
+void lt_start(struct lane_device *lane);
+void lt_stop(struct lane_device *lane);
+void lt_reset(struct lane_device *lane);
+void lt_init_ld(struct lane_device *lane);
+
+void lt_mmd_c45(struct backplane_kr *bpkr);
+void lt_mmd_setup(struct backplane_kr *bpkr, int devad, u32 base);
+
+bool lt_is_rx_trained(struct lane_device *lane);
+bool lt_is_training_failure(struct lane_device *lane);
+bool lt_is_frame_lock(struct lane_device *lane);
+
+bool lt_is_lp_rx_ready(struct lane_device *lane);
+bool lt_is_ld_rx_ready(struct lane_device *lane);
+
+void lt_train_remote_tx(struct lane_device *lane);
+void lt_train_local_tx(struct lane_device *lane);
+
+#endif /* __LINK_TRAINING_H */
-- 
1.9.1

