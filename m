Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24121B75D8
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 14:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgDXMrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 08:47:21 -0400
Received: from mail-am6eur05on2053.outbound.protection.outlook.com ([40.107.22.53]:26784
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727809AbgDXMrT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 08:47:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nISyH/GdH/yaEqf7ooTw9DGTQHKAz9CuUgA1J/nDANDDZelJ06K3XXaQDCewBbRPJO24AaHS79f1COGKsXibHPI29aZNJC3E8zwLX8/bxNyM9dh+29iEOWyNfJADz0e+dfVsHb8uoMs9gwpUou6NqHf/W7YNvWdZIoyc13/lnaoWWB8HgtBs/x7XBIh9B3M12cODYRC/xCNGJskg99P4sHn/72r/aqQ2MJh/ukzlrP+7t8Xx8B/cyWWrKNqzSWHWZy62kxF2/jfulCNh4IZtYbAjnC7eT8pk5Vrwqe6TOKPhpqE9tHP327RZRh5XGi9y3LR3rssdMdUvZGGxeKIo6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edy2sVij7QiTMMOIrQFiew0TqC5r+/grdYuEzyFWuew=;
 b=jddo7CrIiZfA9kaYRBs+IWEEl378e2WLMoirTdgyt/URwi0SNC+EGczonEQu/KXL6GuHtR3Ak4w4kjU8fY1GVsEaaCO0NVzMIh1EEuOMrw0QHyc+e7HuxInFojy9hss8HxyletTUjMMvposYjhvBSNX3q+Y0xIEOzcA5PSZ/TnW6YT/hEwLIR/ORlz0sVcfafN4wePH4wy01EKRKf7nW58RKTX4Cdtj/vu0kNKbJfnnE+V5UYy8dYnUP5/DfhabCTNF3lsGx2qN69ow1ggOCUc1G31sGfmqV4nuiWcMGhPCl316RNkkWdoSncDyGyI6g2itAgmu2CDMdFopfNLQEog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edy2sVij7QiTMMOIrQFiew0TqC5r+/grdYuEzyFWuew=;
 b=SK0wlWRNH6ZpQOXsaLdimVEYFXW/+nYPsNMLrh3fOP/F2IJBicTULkC0HWcH+p30oVBtJPNSXEMztuV9Lqh59DCoq4Avi+S86EUMkQSdG9/Rq7a5BdowF1qgd2CaSeVErk/jNPZwajDwIi+m6bgy6++WhFJ3gtIQSW2RI8DH2RA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5937.eurprd04.prod.outlook.com (2603:10a6:208:119::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 12:46:54 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860%2]) with mapi id 15.20.2937.012; Fri, 24 Apr 2020
 12:46:54 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next v2 7/9] net: phy: enable qoriq backplane support
Date:   Fri, 24 Apr 2020 15:46:29 +0300
Message-Id: <1587732391-3374-8-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
References: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0025.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::35) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0P190CA0025.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 12:46:50 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fa79e457-2459-4b1c-fec1-08d7e84d8f52
X-MS-TrafficTypeDiagnostic: AM0PR04MB5937:|AM0PR04MB5937:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB59370001786ABA9B6C566976FBD00@AM0PR04MB5937.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:660;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(52116002)(2616005)(86362001)(44832011)(6486002)(2906002)(30864003)(8676002)(4326008)(66476007)(66946007)(6666004)(66556008)(8936002)(5660300002)(81156014)(6512007)(3450700001)(16526019)(956004)(186003)(6506007)(36756003)(316002)(26005)(7416002)(478600001)(579004);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4ga/N78/vcjUBtiXsfXqhSLFQ/F9dxjvwGbTfdlwN891wfOsb4NHBX9W4KNPqCdxC5leBOvWfEKj/6JuePiVnWVnlB3plJS2E6GQXbecALQznvzbLm1UlQwKVj6WOUx3209W5VkT1zixQnbJATX9K+bdTWUz5gnio9ljJlEqg5R+CQG1IjmJ/r6h6SISXTTn7qT0UcTdIs8Y9gywJZKqWeqDAP+T2xPh2gHzeRit5A7MF0UaGOwEoT6xYWQ91tF7qVc8JZAeZyC9/g+eXn2hIgXrrG2oBSp/IJzsidfjdisM0f1ZdkJwDx20JUC80oCcCSZ7GzpS7FpmAfWtJ20cqcetLb1+zw0LmLw/hcnk2x5rllPSGL50AVCDOMPeneUk5QUsMg/avrbak1f6u3aAzggNbKABAZJapd2oZUtS8wAIlYFyaXHcr3VvenkEQemi
X-MS-Exchange-AntiSpam-MessageData: vjPjCj/dD5hnl/MqJkzWOOEAtW24vptgiy7BiDeLfb4kIUOxUO+AzamaQlMmwCUl9avAIQJskwRXPIfPM4ax21+QqFHLb/gspD723Dj/iQnqlSq1e2OufhBd3KV5y0pypIQDrCxjJLqYbAhKpUnI9Q==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa79e457-2459-4b1c-fec1-08d7e84d8f52
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 12:46:51.2570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aTbnF4lYyj8q8JMNpUHOCERYMWf2pZ66p4RwmCIfbYjnW1SVeh/zHMGkTnFnEGQ8wTdwLYGNX2IqVkS2ZopGyk4uA/DewFM/D82NtNhgY1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5937
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable backplane support for qoriq family of devices

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/phy/backplane/Kconfig            |  11 +-
 drivers/net/phy/backplane/Makefile           |   2 +
 drivers/net/phy/backplane/qoriq_backplane.c  | 501 ++++++++++++++++++++++++
 drivers/net/phy/backplane/qoriq_backplane.h  |  46 +++
 drivers/net/phy/backplane/qoriq_serdes_10g.c | 486 ++++++++++++++++++++++++
 drivers/net/phy/backplane/qoriq_serdes_28g.c | 547 +++++++++++++++++++++++++++
 6 files changed, 1592 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/phy/backplane/qoriq_backplane.c
 create mode 100644 drivers/net/phy/backplane/qoriq_backplane.h
 create mode 100644 drivers/net/phy/backplane/qoriq_serdes_10g.c
 create mode 100644 drivers/net/phy/backplane/qoriq_serdes_28g.c

diff --git a/drivers/net/phy/backplane/Kconfig b/drivers/net/phy/backplane/Kconfig
index 9ec54b5..3e20a78 100644
--- a/drivers/net/phy/backplane/Kconfig
+++ b/drivers/net/phy/backplane/Kconfig
@@ -17,4 +17,13 @@ config ETH_BACKPLANE_FIXED
 	  This module provides a driver to setup fixed user configurable
 	  coefficient values for backplanes equalization. This means
 	  No Equalization algorithm is used to adapt the initial coefficients
-	  initially set by the user.
\ No newline at end of file
+	  initially set by the user.
+
+config ETH_BACKPLANE_QORIQ
+	tristate "QorIQ Ethernet Backplane driver"
+	depends on ETH_BACKPLANE
+	help
+	  This module provides a driver for Ethernet Operation over
+	  Electrical Backplanes enabled for QorIQ family of devices.
+	  This driver is using the services provided by the generic
+	  backplane and link training modules.
\ No newline at end of file
diff --git a/drivers/net/phy/backplane/Makefile b/drivers/net/phy/backplane/Makefile
index ded6f2d..d8f95ac 100644
--- a/drivers/net/phy/backplane/Makefile
+++ b/drivers/net/phy/backplane/Makefile
@@ -5,5 +5,7 @@
 
 obj-$(CONFIG_ETH_BACKPLANE) += eth_backplane.o
 obj-$(CONFIG_ETH_BACKPLANE_FIXED) += eq_fixed.o
+obj-$(CONFIG_ETH_BACKPLANE_QORIQ) += eth_backplane_qoriq.o
 
 eth_backplane-objs	:= backplane.o link_training.o
+eth_backplane_qoriq-objs	:= qoriq_backplane.o qoriq_serdes_10g.o qoriq_serdes_28g.o
diff --git a/drivers/net/phy/backplane/qoriq_backplane.c b/drivers/net/phy/backplane/qoriq_backplane.c
new file mode 100644
index 0000000..3dd9716
--- /dev/null
+++ b/drivers/net/phy/backplane/qoriq_backplane.c
@@ -0,0 +1,501 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* QorIQ Backplane driver
+ *
+ * Copyright 2015 Freescale Semiconductor, Inc.
+ * Copyright 2018-2020 NXP
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mii.h>
+#include <linux/mdio.h>
+#include <linux/io.h>
+#include <linux/netdevice.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+
+#include "qoriq_backplane.h"
+
+/* QorIQ Backplane Driver name */
+#define QORIQ_BACKPLANE_DRIVER_NAME		"backplane_qoriq"
+
+/* QorIQ Backplane Driver version */
+#define QORIQ_BACKPLANE_DRIVER_VERSION		"1.0.0"
+
+/* PCS Device Identifier */
+#define PCS_PHY_DEVICE_ID			0x0083e400
+#define PCS_PHY_DEVICE_ID_MASK			0xffffffff
+
+/* Max/Min coefficients range values */
+#define PRE_COEF_MAX				0x0
+#define PRE_COEF_MIN				0x8
+#define POST_COEF_MAX				0x0
+#define POST_COEF_MIN				0x10
+#define ZERO_COEF_MIN				0x1A
+#define ZERO_COEF_MAX				0x30
+
+/* Coefficients sum ratio: (their sum divided by their difference) */
+#define COEF_SUM_RATIO_NUMERATOR		17
+#define COEF_SUM_RATIO_DENOMINATOR		4
+
+/* Number of equalization custom parameters */
+#define EQ_PARAMS_NO				1
+
+/* Serdes types supported by QorIQ devices */
+enum serdes_type {
+	SERDES_10G,
+	SERDES_28G,
+	SERDES_INVAL
+};
+
+static void an_advertisement_init(struct lane_device *lane)
+{
+	struct backplane_device *bpdev = lane->bpdev;
+	struct phy_device *phydev = lane->phydev;
+	struct qoriq_driver *qoriq_drv;
+	u32 init_an_adv1;
+	int err;
+
+	qoriq_drv = (struct qoriq_driver *)bpdev->drv.priv;
+	init_an_adv1 = backplane_get_an_adv1_init(phydev->interface);
+
+	err = backplane_write_mmd(lane, MDIO_MMD_AN, qoriq_drv->an_adv1,
+				  init_an_adv1);
+	if (err)
+		bpdev_err(phydev,
+			  "Setting AN register 0x%02x on lane %d failed with error code: 0x%08x\n",
+			  qoriq_drv->an_adv1, lane->idx, err);
+}
+
+static bool is_an_link_detected(struct lane_device *lane)
+{
+	struct backplane_device *bpdev = lane->bpdev;
+	struct phy_device *phydev = lane->phydev;
+	struct qoriq_driver *qoriq_drv;
+	struct lane_device *masterln;
+	u32 an_bp_eth_status;
+	int an_state;
+	u32 an_mask;
+
+	qoriq_drv = (struct qoriq_driver *)bpdev->drv.priv;
+	an_bp_eth_status = qoriq_drv->an_bp_eth_status;
+
+	/* Check AN state only on Master Lane */
+	masterln = &bpdev->lane[MASTER_LANE];
+
+	/* The link training occurs after auto-negotiation
+	 * has determined the link to be a Base-KR link.
+	 * This is indicated by asserting the corresponding
+	 * technology bit within the BP_ETH_STATUS register.
+	 * Note that this occurs before auto-negotiation can declare
+	 * auto-negotiation complete,
+	 * as this requires the PCS to report a valid link.
+	 */
+	an_mask = backplane_get_an_bp_eth_status_bit(phydev->interface);
+	an_state = backplane_read_mmd(masterln, MDIO_MMD_AN, an_bp_eth_status);
+
+	return (an_state & an_mask);
+}
+
+static void qoriq_setup_default_settings(struct lane_device *lane)
+{
+	const struct lane_ops *lane_ops = lane->bpdev->drv.lane_ops;
+	struct qoriq_lane_ops *qoriq_lane_ops;
+	u32 def_amp_red;
+
+	qoriq_lane_ops = (struct qoriq_lane_ops *)lane_ops->priv;
+
+	if (lane->bpdev->bpkr.valid_eq_params)
+		def_amp_red = lane->bpdev->bpkr.def_kr.dev_coef[IDX_AMP_RED];
+	else
+		def_amp_red = qoriq_lane_ops->read_amp_red(lane->reg_base);
+
+	lane->krln.def_kr.dev_coef[IDX_AMP_RED] = def_amp_red;
+}
+
+/* LT HW restrictions:
+ * Section 5.3.1 10GBaseKR Transmit Adaptive Equalization Control
+ * additional restrictions set down by 802.3 specification Clause 72,
+ * specifically 72.7.1.11 Transmitter output waveform requirements
+ *
+ * Maintaining the following relationships limit transmit equalization
+ * to reasonable levels compliant with the KR specification
+ */
+static int lt_qoriq_validation(struct lane_device *lane, u32 *ld_coef)
+{
+	struct backplane_kr *bpkr = &lane->bpdev->bpkr;
+	u32 mainq = ld_coef[C_Z0];
+	u32 postq = ld_coef[C_P1];
+	u32 preq = ld_coef[C_M1];
+
+	/* Additional HW restrictions:
+	 * 1. MIN_C(0) <= tx_preq + tx_mainq + tx_ratio_post1q <= MAX_C(0)
+	 */
+	if ((preq + postq + mainq) < bpkr->min_kr.mainq)
+		return -ERANGE;
+	if ((preq + postq + mainq) > bpkr->max_kr.mainq)
+		return -ERANGE;
+
+	/* 2.
+	 * ( tx_mainq + tx_preq + tx_ratio_post1q ) /
+	 * ( tx_mainq - tx_preq - tx_ratio_post1q ) <
+	 * coef_sum_ratio_numerator / coef_sum_ratio_denominator
+	 */
+	if (((mainq + preq + postq) * COEF_SUM_RATIO_DENOMINATOR) >=
+	    ((mainq - preq - postq) * COEF_SUM_RATIO_NUMERATOR))
+		return -ERANGE;
+
+	return 0;
+}
+
+enum serdes_type get_serdes_type(struct device_node *serdes_node)
+{
+	enum serdes_type serdes = SERDES_INVAL;
+	const char *serdes_comp;
+	int comp_no, i, ret;
+
+	comp_no = of_property_count_strings(serdes_node, "compatible");
+	for (i = 0; i < comp_no; i++) {
+		ret = of_property_read_string_index(serdes_node, "compatible",
+						    i, &serdes_comp);
+		if (ret == 0) {
+			if (!strcasecmp(serdes_comp, "serdes-10g")) {
+				serdes = SERDES_10G;
+				break;
+			} else if (!strcasecmp(serdes_comp, "serdes-28g")) {
+				serdes = SERDES_28G;
+				break;
+			}
+		}
+	}
+
+	return serdes;
+}
+
+/* install QorIQ specific backplane callbacks:
+ * for AN start/decoding, hw specific defaults and lt validation
+ */
+static const struct backplane_ops qoriq_ops = {
+	.an_advertisement_init = an_advertisement_init,
+	.is_an_link_detected = is_an_link_detected,
+	.setup_default_settings = qoriq_setup_default_settings,
+	.lt_validation = lt_qoriq_validation,
+};
+
+/* qoriq_backplane_probe
+ *
+ * Probe function for QorIQ backplane driver to provide QorIQ device specific
+ * behavior
+ *
+ * phydev: backplane phy device
+ *	this is an internal phy block controlled by the software
+ *	which contains other component blocks like: PMA/PMD, PCS, AN
+ *
+ * Return: Zero for success or error code in case of failure
+ */
+static int qoriq_backplane_probe(struct phy_device *phydev)
+{
+	pr_info_once("%s: QorIQ Backplane driver version %s\n",
+		     QORIQ_BACKPLANE_DRIVER_NAME,
+		     QORIQ_BACKPLANE_DRIVER_VERSION);
+
+	/* call generic driver probe */
+	return backplane_probe(phydev);
+}
+
+/* qoriq_backplane_config_init
+ *
+ * Config_Init function for QorIQ devices to provide QorIQ specific behavior
+ *
+ * phydev: backplane phy device
+ *
+ * Return: Zero for success or error code in case of failure
+ */
+static int qoriq_backplane_config_init(struct phy_device *phydev)
+{
+	struct device_node *dev_node, *serdes_node, *lane_node;
+	const struct equalizer_device *qoriq_equalizer = NULL;
+	struct backplane_device *bpdev = phydev->priv;
+	struct qoriq_lane_ops *qoriq_lane_ops = NULL;
+	const struct qoriq_driver *qoriq_drv = NULL;
+	const struct lane_ops *lane_ops = NULL;
+	enum serdes_type serdes = SERDES_INVAL;
+	u32 eqparams[EQ_PARAMS_NO];
+	struct resource res;
+	int proplen;
+	int i, ret;
+
+	dev_node = phydev->mdio.dev.of_node;
+	if (!dev_node) {
+		bpdev_err(phydev, "No associated device tree node\n");
+		return -EINVAL;
+	}
+	if (!bpdev) {
+		bpdev_err(phydev, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+
+	if (!backplane_is_valid_mode(phydev->interface))
+		return -EINVAL;
+
+	/* call generic driver parse DT */
+	ret = backplane_parse_dt(phydev);
+	if (ret)
+		return ret;
+
+	bpdev->num_lanes = backplane_num_lanes(phydev->interface);
+
+	proplen = of_property_count_u32_elems(dev_node, "lane-handle");
+	if (proplen < bpdev->num_lanes) {
+		bpdev_err(phydev, "Unspecified lane handles\n");
+		return -EINVAL;
+	}
+	serdes_node = NULL;
+	for (i = 0; i < bpdev->num_lanes; i++) {
+		lane_node = of_parse_phandle(dev_node, "lane-handle", i);
+		if (!lane_node) {
+			bpdev_err(phydev, "parse lane-handle failed\n");
+			return -EINVAL;
+		}
+		if (i == 0)
+			serdes_node = lane_node->parent;
+		ret = of_address_to_resource(lane_node, 0, &res);
+		if (ret) {
+			bpdev_err(phydev,
+				  "could not obtain lane memory map for index=%d, ret = %d\n",
+				  i, ret);
+			return ret;
+		}
+		/* setup lane address */
+		bpdev->lane[i].lane_addr = res.start;
+
+		of_node_put(lane_node);
+	}
+	if (!serdes_node) {
+		bpdev_err(phydev, "serdes node not found\n");
+		return -EINVAL;
+	}
+	bpdev->drv.is_little_endian = of_property_read_bool(serdes_node,
+							    "little-endian");
+
+	ret = of_address_to_resource(serdes_node, 0, &res);
+	if (ret) {
+		bpdev_err(phydev,
+			  "could not obtain serdes memory map, ret = %d\n",
+			  ret);
+		return ret;
+	}
+	bpdev->drv.base_addr = res.start;
+	bpdev->drv.memmap_size = res.end - res.start + 1;
+
+	serdes = get_serdes_type(serdes_node);
+	if (serdes == SERDES_INVAL) {
+		bpdev_err(phydev, "Unknown serdes-type\n");
+		return 0;
+	}
+
+	/* if eq-params node exists then use the DTS specified values
+	 * if eq-params node doesn't exist then use values already found in HW
+	 * eq-params is a custom node and variable in size
+	 */
+	proplen = of_property_count_u32_elems(dev_node, "eq-params");
+	if (proplen > 0) {
+		/* we use only 1 custom coefficient tap: amp_red */
+		if (proplen > EQ_PARAMS_NO)
+			proplen = EQ_PARAMS_NO;
+		ret = of_property_read_u32_array(dev_node, "eq-params",
+						 (u32 *)eqparams, proplen);
+		if (ret == 0) {
+			bpdev->bpkr.valid_eq_params = true;
+			bpdev->bpkr.def_kr.dev_coef[IDX_AMP_RED] =
+							eqparams[IDX_AMP_RED];
+		}
+	}
+
+	/* call generic driver setup memio after reading serdes endianness */
+	ret = backplane_setup_memio(phydev);
+	if (ret)
+		return ret;
+
+	/* call generic driver setup mmd */
+	ret = backplane_setup_mmd(phydev);
+	if (ret)
+		return ret;
+
+	/* override default mdio setup and get qoriq specific info */
+	switch (serdes) {
+	case SERDES_10G:
+		lane_ops = qoriq_get_lane_ops_10g();
+		qoriq_drv = get_qoriq_driver_10g();
+		qoriq_setup_mem_io_10g(bpdev->drv.io);
+		qoriq_equalizer = qoriq_get_equalizer_10g();
+		break;
+	case SERDES_28G:
+		lane_ops = qoriq_get_lane_ops_28g();
+		qoriq_drv = get_qoriq_driver_28g();
+		qoriq_setup_mem_io_28g(bpdev->drv.io);
+		qoriq_equalizer = qoriq_get_equalizer_28g();
+		break;
+	default:
+		bpdev_err(phydev, "Serdes type not supported\n");
+		return -EINVAL;
+	}
+	if (!lane_ops) {
+		bpdev_err(phydev, "Lane ops not available\n");
+		return -EINVAL;
+	}
+	if (!qoriq_drv) {
+		bpdev_err(phydev, "Qoriq driver not available\n");
+		return -EINVAL;
+	}
+	if (!qoriq_equalizer) {
+		bpdev_err(phydev, "Qoriq Equalizer not available\n");
+		return -EINVAL;
+	}
+
+	/* setup ops and equalizer */
+	bpdev->drv.lane_ops = lane_ops;
+	bpdev->drv.bp_ops = qoriq_ops;
+	bpdev->drv.priv = (void *)qoriq_drv;
+	bpdev->bpkr.equalizer = qoriq_equalizer;
+	qoriq_lane_ops = (struct qoriq_lane_ops *)lane_ops->priv;
+
+	if (!qoriq_lane_ops) {
+		bpdev_err(phydev, "QorIQ lane ops not available\n");
+		return -EINVAL;
+	}
+
+	/* setup KR LT MMD registers space */
+	backplane_kr_lt_mmd_setup(&bpdev->bpkr, qoriq_drv->kr_lt_devad,
+				  qoriq_drv->kr_lt_base);
+
+	if (backplane_is_mode_kr(phydev->interface)) {
+		/* setup kr coefficients limits */
+		bpdev->bpkr.min_kr.preq = PRE_COEF_MIN;
+		bpdev->bpkr.max_kr.preq = PRE_COEF_MAX;
+		bpdev->bpkr.min_kr.mainq = ZERO_COEF_MIN;
+		bpdev->bpkr.max_kr.mainq = ZERO_COEF_MAX;
+		bpdev->bpkr.min_kr.postq = POST_COEF_MIN;
+		bpdev->bpkr.max_kr.postq = POST_COEF_MAX;
+	}
+
+	/* call generic driver setup lanes */
+	ret = backplane_setup_lanes(phydev);
+	if (ret)
+		return ret;
+
+	/* call generic driver initialize
+	 * start the lane timers used to run the algorithm
+	 */
+	ret = backplane_initialize(phydev);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int qoriq_backplane_match_phy_device(struct phy_device *phydev)
+{
+	struct device_node *dev_node, *serdes_node, *lane_node;
+	enum serdes_type serdes = SERDES_INVAL;
+	int i;
+
+	if (!phydev->mdio.dev.of_node)
+		return 0;
+
+	if (!phydev->is_c45)
+		return 0;
+
+	dev_node = phydev->mdio.dev.of_node;
+	if (!dev_node) {
+		bpdev_err(phydev, "No associated device tree node\n");
+		return 0;
+	}
+
+	/* Get Master lane node */
+	lane_node = of_parse_phandle(dev_node, "lane-handle", 0);
+	if (!lane_node)
+		return 0;
+	serdes_node = lane_node->parent;
+	of_node_put(lane_node);
+	if (!serdes_node)
+		return 0;
+
+	serdes = get_serdes_type(serdes_node);
+
+	switch (serdes) {
+	case SERDES_10G:
+		/* On LS devices we must find the c45 device with correct PHY ID
+		 * Implementation similar with the one existent in phy_device:
+		 * @function: phy_bus_match
+		 */
+		for (i = 1; i < ARRAY_SIZE(phydev->c45_ids.device_ids); i++) {
+			if (!(phydev->c45_ids.devices_in_package & (1 << i)))
+				continue;
+
+			if ((PCS_PHY_DEVICE_ID & PCS_PHY_DEVICE_ID_MASK) ==
+			    (phydev->c45_ids.device_ids[i] &
+			     PCS_PHY_DEVICE_ID_MASK))
+				return 1;
+		}
+		break;
+	case SERDES_28G:
+		/*	 WORKAROUND:
+		 * Required for LX2 devices
+		 * where PHY ID cannot be verified in PCS
+		 * because PCS Device Identifier Upper and Lower registers are
+		 * hidden and always return 0 when they are read:
+		 * 2  02	Device_ID0  RO		Bits 15:0	0
+		 * val = phy_read_mmd(phydev, MDIO_MMD_PCS, 0x2);
+		 * 3  03	Device_ID1  RO		Bits 31:16	0
+		 * val = phy_read_mmd(phydev, MDIO_MMD_PCS, 0x3);
+		 *
+		 * To be removed: After the issue will be fixed on LX2 devices
+		 */
+
+		/* On LX devices we cannot verify PHY ID
+		 * phy id because registers are hidden
+		 * so we are happy only with preliminary verifications
+		 * already made: mdio.dev.of_node, is_c45
+		 * and lane-handle with valid serdes parent
+		 * because we already filtered other undesired devices:
+		 * non clause 45
+		 */
+		return 1;
+	default:
+		bpdev_err(phydev, "Unknown serdes-type\n");
+		return 0;
+	}
+	return 0;
+}
+
+static struct phy_driver qoriq_backplane_driver[] = {
+	{
+	.phy_id		= PCS_PHY_DEVICE_ID,
+	.name		= QORIQ_BACKPLANE_DRIVER_NAME,
+	.phy_id_mask	= PCS_PHY_DEVICE_ID_MASK,
+	.features       = BACKPLANE_FEATURES,
+	.probe          = qoriq_backplane_probe,
+	.remove         = backplane_remove,
+	.config_init    = qoriq_backplane_config_init,
+	.aneg_done      = backplane_aneg_done,
+	.config_aneg	= backplane_config_aneg,
+	.read_status	= backplane_read_status,
+	.suspend	= backplane_suspend,
+	.resume		= backplane_resume,
+	.match_phy_device = qoriq_backplane_match_phy_device,
+	},
+};
+
+module_phy_driver(qoriq_backplane_driver);
+
+static struct mdio_device_id __maybe_unused qoriq_backplane_tbl[] = {
+	{ PCS_PHY_DEVICE_ID, PCS_PHY_DEVICE_ID_MASK },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(mdio, qoriq_backplane_tbl);
+
+MODULE_DESCRIPTION("QorIQ Backplane driver");
+MODULE_AUTHOR("Florinel Iordache <florinel.iordache@nxp.com>");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/phy/backplane/qoriq_backplane.h b/drivers/net/phy/backplane/qoriq_backplane.h
new file mode 100644
index 0000000..74e7f76
--- /dev/null
+++ b/drivers/net/phy/backplane/qoriq_backplane.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* QorIQ Backplane driver
+ *
+ * Copyright 2018-2020 NXP
+ */
+
+#ifndef __QORIQ_BACKPLANE_H
+#define __QORIQ_BACKPLANE_H
+
+#include "backplane.h"
+
+/* Bins thresholds */
+#define QORIQ_BIN_M1_THRESHOLD			3
+#define QORIQ_BIN_LONG_THRESHOLD		2
+
+/* Index of custom parameter: AMP_RED (amplitude reduction) */
+#define IDX_AMP_RED				0
+
+struct qoriq_lane_ops {
+	u32 (*read_tecr0)(void __iomem *reg);
+	u32 (*read_tecr1)(void __iomem *reg);
+	u32 (*read_amp_red)(void __iomem *reg);
+};
+
+struct qoriq_driver {
+	/* KR LT MMD registers */
+	int kr_lt_devad;
+	u32 kr_lt_base;
+	/* KR AN MMD registers */
+	u32 an_adv1;
+	u32 an_bp_eth_status;
+};
+
+const struct lane_ops *qoriq_get_lane_ops_10g(void);
+const struct lane_ops *qoriq_get_lane_ops_28g(void);
+
+const struct equalizer_device *qoriq_get_equalizer_10g(void);
+const struct equalizer_device *qoriq_get_equalizer_28g(void);
+
+const struct qoriq_driver *get_qoriq_driver_10g(void);
+const struct qoriq_driver *get_qoriq_driver_28g(void);
+
+void qoriq_setup_mem_io_10g(struct mem_io memio);
+void qoriq_setup_mem_io_28g(struct mem_io memio);
+
+#endif /* __QORIQ_BACKPLANE_H */
diff --git a/drivers/net/phy/backplane/qoriq_serdes_10g.c b/drivers/net/phy/backplane/qoriq_serdes_10g.c
new file mode 100644
index 0000000..e4e5991
--- /dev/null
+++ b/drivers/net/phy/backplane/qoriq_serdes_10g.c
@@ -0,0 +1,486 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* QorIQ Backplane driver for SerDes 10G
+ *
+ * Copyright 2018-2020 NXP
+ */
+
+#include <linux/io.h>
+#include <linux/delay.h>
+
+#include "qoriq_backplane.h"
+
+#define EQUALIZER_NAME				"qoriq_serdes_10g"
+#define EQUALIZER_VERSION			"1.0.0"
+
+#define BIN_1_SEL				0x00000000
+#define BIN_2_SEL				0x00010000
+#define BIN_3_SEL				0x00020000
+#define BIN_OFFSET_SEL				0x00030000
+#define BIN_BLW_SEL				0x00040000
+#define BIN_AVG_SEL				0x00050000
+#define BIN_M1_SEL				0x00060000
+#define BIN_LONG_SEL				0x00070000
+#define CDR_SEL_MASK				0x00070000
+
+#define RATIO_PREQ_SHIFT			22
+#define RATIO_PST1Q_SHIFT			16
+#define ADPT_EQ_SHIFT				8
+#define AMP_RED_SHIFT				0
+
+#define RATIO_PREQ_MASK				0x03c00000
+#define RATIO_PST1Q_MASK			0x001f0000
+#define ADPT_EQ_MASK				0x00003f00
+#define AMP_RED_MASK				0x0000003f
+
+#define TECR0_INIT				0x24200000
+
+#define GCR0_RESET_MASK				0x00600000
+#define GCR0_TRST_MASK				0x00200000
+#define GCR0_RRST_MASK				0x00400000
+
+#define GCR1_SNP_START_MASK			0x00000040
+#define GCR1_CTL_SNP_START_MASK			0x00002000
+
+#define RECR1_CTL_SNP_DONE_MASK			0x00000002
+#define RECR1_SNP_DONE_MASK			0x00000004
+#define TCSR1_SNP_DATA_MASK			0x00007fc0
+#define TCSR1_SNP_DATA_SHIFT			6
+#define TCSR1_EQ_SNPBIN_SIGN_MASK		0x100
+
+#define TCSR3_CDR_LCK_MASK			0x08000000
+
+#define RECR1_GAINK2_MASK			0x0f000000
+#define RECR1_GAINK2_SHIFT			24
+
+#define RECR1_GAINK3_MASK			0x000f0000
+#define RECR1_GAINK3_SHIFT			16
+
+#define RECR1_EQ_OFFSET_MASK			0x00001f80
+#define RECR1_EQ_OFFSET_SHIFT			7
+
+/* AN advertisement register 7.17 */
+#define AN_AD_ABILITY_1				0x11
+
+/* Backplane Ethernet status (Register 7.48) */
+#define AN_BP_ETH_STATUS_OFFSET			0x30
+
+/* KR PMD control register (Register 1.150) */
+#define KR_PMD_BASE_OFFSET			0x96
+
+/* Bin snapshots thresholds range */
+#define EQ_BIN_MIN				-256
+#define EQ_BIN_MAX				255
+/* Bin snapshots average thresholds range */
+#define EQ_BIN_SNP_AV_THR_LOW			-150
+#define EQ_BIN_SNP_AV_THR_HIGH			150
+
+#define EQ_GAINK_MIN				0xF
+#define EQ_GAINK_MAX				0x0
+#define EQ_GAINK_MIDRANGE_LOW			0xE
+#define EQ_GAINK_MIDRANGE_HIGH			0x1
+
+#define EQ_OFFSET_MIN				0
+#define EQ_OFFSET_MAX				0x3F
+#define EQ_OFFSET_MIDRANGE_LOW			0x10
+#define EQ_OFFSET_MIDRANGE_HIGH			0x2F
+
+#define MEMORY_MAP_SIZE				0x40
+
+struct qoriq_lane_regs {
+	u32 gcr0;	/* 0x00: General Control Register 0 */
+	u32 gcr1;	/* 0x04: General Control Register 1 */
+	u32 gcr2;	/* 0x08: General Control Register 2 */
+	u32 res_0c;	/* 0x0C: Reserved */
+	u32 recr0;	/* 0x10: Receive Equalization Control Register 0 */
+	u32 recr1;	/* 0x14: Receive Equalization Control Register 1 */
+	u32 tecr0;	/* 0x18: Transmit Equalization Control Register 0 */
+	u32 res_1c;	/* 0x1C: Reserved */
+	u32 tlcr0;	/* 0x20: TTL Control Register 0 */
+	u32 tlcr1;	/* 0x24: TTL Control Register 1 */
+	u32 tlcr2;	/* 0x28: TTL Control Register 2 */
+	u32 tlcr3;	/* 0x2C: TTL Control Register 3 */
+	u32 tcsr0;	/* 0x30: Test Control/Status Register 0 */
+	u32 tcsr1;	/* 0x34: Test Control/Status Register 1 */
+	u32 tcsr2;	/* 0x38: Test Control/Status Register 2 */
+	u32 tcsr3;	/* 0x3C: Test Control/Status Register 3 */
+};
+
+static struct mem_io io;
+
+static void reset_lane(void __iomem *reg, enum lane_req ln_req)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+
+	/* reset Tx lane: send reset request */
+	if (ln_req | LANE_TX) {
+		io.write32(io.read32(&reg_base->gcr0) & ~GCR0_TRST_MASK,
+			   &reg_base->gcr0);
+	}
+	/* reset Rx lane: send reset request */
+	if (ln_req | LANE_RX) {
+		io.write32(io.read32(&reg_base->gcr0) & ~GCR0_RRST_MASK,
+			   &reg_base->gcr0);
+	}
+	/* unreset the lane */
+	if (ln_req != LANE_INVALID) {
+		udelay(1);
+		io.write32(io.read32(&reg_base->gcr0) | GCR0_RESET_MASK,
+			   &reg_base->gcr0);
+		udelay(1);
+	}
+}
+
+static u32 read_tecr0(void __iomem *reg)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+
+	return io.read32(&reg_base->tecr0);
+}
+
+static u32 read_tecr1(void __iomem *reg)
+{
+	return 0;
+}
+
+static u32 read_amp_red(void __iomem *reg)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	u32 val, amp_red;
+
+	val = io.read32(&reg_base->tecr0);
+	amp_red = (val & AMP_RED_MASK) >> AMP_RED_SHIFT;
+
+	return amp_red;
+}
+
+static void read_kr_coef(void __iomem *reg, struct kr_coef *coef)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	u32 val;
+
+	val = io.read32(&reg_base->tecr0);
+
+	coef->preq = (val & RATIO_PREQ_MASK) >> RATIO_PREQ_SHIFT;
+	coef->postq = (val & RATIO_PST1Q_MASK) >> RATIO_PST1Q_SHIFT;
+	coef->mainq = (val & ADPT_EQ_MASK) >> ADPT_EQ_SHIFT;
+	coef->dev_coef[IDX_AMP_RED] = (val & AMP_RED_MASK) >> AMP_RED_SHIFT;
+}
+
+static void tune_tecr(void __iomem *reg, struct kr_coef *coef, bool reset)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	u32 val;
+
+	val = TECR0_INIT |
+		coef->mainq << ADPT_EQ_SHIFT |
+		coef->preq << RATIO_PREQ_SHIFT |
+		coef->postq << RATIO_PST1Q_SHIFT |
+		coef->dev_coef[IDX_AMP_RED] << AMP_RED_SHIFT;
+
+	if (reset) {
+		/* reset the lane */
+		io.write32(io.read32(&reg_base->gcr0) &
+			   ~GCR0_RESET_MASK, &reg_base->gcr0);
+		udelay(1);
+	}
+
+	io.write32(val, &reg_base->tecr0);
+	udelay(1);
+
+	if (reset) {
+		/* unreset the lane */
+		io.write32(io.read32(&reg_base->gcr0) | GCR0_RESET_MASK,
+			   &reg_base->gcr0);
+		udelay(1);
+	}
+}
+
+/* collect_gains
+ *
+ * reg: serdes registers memory map
+ * gaink2: High-frequency gain of the equalizer amplifier
+ *         the high-frequency gain of the equalizer amplifier is increased by
+ *         decrementing the value of eq_gaink2 by one
+ * gaink3: Middle-frequency gain of the equalizer amplifier
+ *         the mid-frequency gain of the equalizer amplifier is increased by
+ *         decrementing the value of eq_gaink3 by one
+ * osestat: equalization offset status
+ *          the equalizer offset is reduced by decrementing the value of osestat
+ * size: size of snapshots data collection
+ */
+static int collect_gains(void __iomem *reg, s16 *gaink2, s16 *gaink3,
+			 s16 *osestat, u8 size)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	u32 rx_eq_snp;
+	int timeout;
+	int i;
+
+	for (i = 0; i < size; i++) {
+		/* wait RECR1_CTL_SNP_DONE_MASK has cleared */
+		timeout = 100;
+		while (io.read32(&reg_base->recr1) &
+		       RECR1_CTL_SNP_DONE_MASK) {
+			udelay(1);
+			timeout--;
+			if (timeout == 0)
+				break;
+		}
+
+		/* start snapshot */
+		io.write32((io.read32(&reg_base->gcr1) |
+			    GCR1_CTL_SNP_START_MASK), &reg_base->gcr1);
+
+		/* wait for SNP done */
+		timeout = 100;
+		while (!(io.read32(&reg_base->recr1) &
+		       RECR1_CTL_SNP_DONE_MASK)) {
+			udelay(1);
+			timeout--;
+			if (timeout == 0)
+				break;
+		}
+
+		/* read and save the snapshot */
+		rx_eq_snp = io.read32(&reg_base->recr1);
+
+		if (gaink2)
+			gaink2[i] = (u8)((rx_eq_snp & RECR1_GAINK2_MASK) >>
+					 RECR1_GAINK2_SHIFT);
+		if (gaink3)
+			gaink3[i] = (u8)((rx_eq_snp & RECR1_GAINK3_MASK) >>
+					 RECR1_GAINK3_SHIFT);
+		if (osestat)
+			osestat[i] = (u8)((rx_eq_snp & RECR1_EQ_OFFSET_MASK) >>
+					  RECR1_EQ_OFFSET_SHIFT);
+
+		/* terminate the snapshot by setting GCR1[REQ_CTL_SNP] */
+		io.write32((io.read32(&reg_base->gcr1) &
+			   ~GCR1_CTL_SNP_START_MASK), &reg_base->gcr1);
+	}
+	return i;
+}
+
+static int collect_eq_status(void __iomem *reg, enum eqc_type type[],
+			     u8 type_no, s16 *counters, u8 size)
+{
+	s16 *gaink2 = NULL, *gaink3 = NULL, *osestat = NULL;
+	u8 i;
+
+	for (i = 0; i < type_no; i++) {
+		switch (type[i]) {
+		case EQC_GAIN_HF:
+			gaink2 = counters;
+			break;
+		case EQC_GAIN_MF:
+			gaink3 = counters + size;
+			break;
+		case EQC_EQOFFSET:
+			osestat = counters + 2 * size;
+			break;
+		default:
+			/* invalid type */
+			break;
+		}
+	}
+
+	return collect_gains(reg, gaink2, gaink3, osestat, size);
+}
+
+static int collect_bin_snapshots(void __iomem *reg, enum eqc_type type,
+				 s16 *bin_counters, u8 bin_size)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	int bin_snapshot;
+	int i, timeout;
+	u32 bin_sel;
+
+	/* calculate TCSR1[CDR_SEL] */
+	switch (type) {
+	case EQC_BIN_1:
+		bin_sel = BIN_1_SEL;
+		break;
+	case EQC_BIN_2:
+		bin_sel = BIN_2_SEL;
+		break;
+	case EQC_BIN_3:
+		bin_sel = BIN_3_SEL;
+		break;
+	case EQC_BIN_LONG:
+		bin_sel = BIN_LONG_SEL;
+		break;
+	case EQC_BIN_M1:
+		bin_sel = BIN_M1_SEL;
+		break;
+	case EQC_BIN_OFFSET:
+		bin_sel = BIN_OFFSET_SEL;
+		break;
+	case EQC_BIN_AVG:
+		bin_sel = BIN_AVG_SEL;
+		break;
+	case EQC_BIN_BLW:
+		bin_sel = BIN_BLW_SEL;
+		break;
+	default:
+		/* invalid bin type */
+		return 0;
+	}
+
+	for (i = 0; i < bin_size; i++) {
+		/* wait RECR1_SNP_DONE_MASK has cleared */
+		timeout = 100;
+		while ((io.read32(&reg_base->recr1) &
+			RECR1_SNP_DONE_MASK)) {
+			udelay(1);
+			timeout--;
+			if (timeout == 0)
+				break;
+		}
+
+		/* set TCSR1[CDR_SEL] */
+		io.write32((io.read32(&reg_base->tcsr1) &
+			    ~CDR_SEL_MASK) | bin_sel, &reg_base->tcsr1);
+
+		/* start snapshot */
+		io.write32(io.read32(&reg_base->gcr1) |
+			   GCR1_SNP_START_MASK, &reg_base->gcr1);
+
+		/* wait for SNP done */
+		timeout = 100;
+		while (!(io.read32(&reg_base->recr1) &
+			 RECR1_SNP_DONE_MASK)) {
+			udelay(1);
+			timeout--;
+			if (timeout == 0)
+				break;
+		}
+
+		/* read and save the snapshot:
+		 * 2's complement 9 bit long value (-256 to 255)
+		 */
+		bin_snapshot = (io.read32(&reg_base->tcsr1) &
+				TCSR1_SNP_DATA_MASK) >> TCSR1_SNP_DATA_SHIFT;
+		if (bin_snapshot & TCSR1_EQ_SNPBIN_SIGN_MASK) {
+			/* 2's complement 9 bit long negative number */
+			bin_snapshot &= ~TCSR1_EQ_SNPBIN_SIGN_MASK;
+			bin_snapshot -= 256;
+		}
+
+		/* save collected Bin snapshot */
+		bin_counters[i] = (s16)bin_snapshot;
+
+		/* terminate the snapshot by setting GCR1[REQ_CTL_SNP] */
+		io.write32(io.read32(&reg_base->gcr1) &
+			   ~GCR1_SNP_START_MASK, &reg_base->gcr1);
+	}
+	return i;
+}
+
+static struct eqc_range bin_range = {
+	.min = EQ_BIN_MIN,
+	.max = EQ_BIN_MAX,
+	.mid_low = EQ_BIN_SNP_AV_THR_LOW,
+	.mid_high = EQ_BIN_SNP_AV_THR_HIGH,
+};
+
+static struct eqc_range gaink_range = {
+	.min = EQ_GAINK_MIN,
+	.max = EQ_GAINK_MAX,
+	.mid_low = EQ_GAINK_MIDRANGE_LOW,
+	.mid_high = EQ_GAINK_MIDRANGE_HIGH,
+};
+
+static struct eqc_range osestat_range = {
+	.min = EQ_OFFSET_MIN,
+	.max = EQ_OFFSET_MAX,
+	.mid_low = EQ_OFFSET_MIDRANGE_LOW,
+	.mid_high = EQ_OFFSET_MIDRANGE_HIGH,
+};
+
+static struct eqc_range *get_counter_range(enum eqc_type type)
+{
+	switch (type) {
+	case EQC_BIN_1:
+	case EQC_BIN_2:
+	case EQC_BIN_3:
+	case EQC_BIN_LONG:
+	case EQC_BIN_M1:
+	case EQC_BIN_OFFSET:
+	case EQC_BIN_AVG:
+	case EQC_BIN_BLW:
+		return &bin_range;
+	case EQC_GAIN_HF:
+	case EQC_GAIN_MF:
+		return &gaink_range;
+	case EQC_EQOFFSET:
+		return &osestat_range;
+	default:
+		/* invalid counter type */
+		return NULL;
+	}
+	return NULL;
+}
+
+static bool is_cdr_lock_bit(void __iomem *reg)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+
+	if (io.read32(&reg_base->tcsr3) & TCSR3_CDR_LCK_MASK)
+		return true;
+
+	return false;
+}
+
+static const struct qoriq_lane_ops qoriq_lane_ops_10g = {
+	.read_tecr0 = read_tecr0,
+	.read_tecr1 = read_tecr1,
+	.read_amp_red = read_amp_red,
+};
+
+static const struct lane_ops lane_ops_10g = {
+	.priv = &qoriq_lane_ops_10g,
+	.memmap_size = MEMORY_MAP_SIZE,
+	.reset_lane = reset_lane,
+	.tune_lane_kr = tune_tecr,
+	.read_lane_kr = read_kr_coef,
+	.is_cdr_lock = is_cdr_lock_bit,
+};
+
+const struct lane_ops *qoriq_get_lane_ops_10g(void)
+{
+	return &lane_ops_10g;
+}
+
+static const struct equalizer_device qoriq_equalizer = {
+	.name = EQUALIZER_NAME,
+	.version = EQUALIZER_VERSION,
+	.ops = {
+		.collect_counters = collect_bin_snapshots,
+		.collect_multiple_counters = collect_eq_status,
+		.get_counter_range = get_counter_range,
+	},
+};
+
+const struct equalizer_device *qoriq_get_equalizer_10g(void)
+{
+	return &qoriq_equalizer;
+}
+
+static const struct qoriq_driver qoriq_drv = {
+	/* KR PMD registers */
+	.kr_lt_devad = MDIO_MMD_PMAPMD,
+	.kr_lt_base = KR_PMD_BASE_OFFSET,
+	/* KR AN registers: IEEE802.3 Clause 45 MMD 7 */
+	.an_adv1 = AN_AD_ABILITY_1,
+	.an_bp_eth_status = AN_BP_ETH_STATUS_OFFSET,
+};
+
+const struct qoriq_driver *get_qoriq_driver_10g(void)
+{
+	return &qoriq_drv;
+}
+
+void qoriq_setup_mem_io_10g(struct mem_io memio)
+{
+	io = memio;
+}
diff --git a/drivers/net/phy/backplane/qoriq_serdes_28g.c b/drivers/net/phy/backplane/qoriq_serdes_28g.c
new file mode 100644
index 0000000..8f357fb
--- /dev/null
+++ b/drivers/net/phy/backplane/qoriq_serdes_28g.c
@@ -0,0 +1,547 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* QorIQ Backplane driver for SerDes 28G
+ *
+ * Copyright 2018-2020 NXP
+ */
+
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+
+#include "qoriq_backplane.h"
+
+#define EQUALIZER_NAME				"qoriq_serdes_28g"
+#define EQUALIZER_VERSION			"1.0.0"
+
+#define BIN_1_SEL				0x00000000
+#define BIN_2_SEL				0x00001000
+#define BIN_3_SEL				0x00002000
+#define BIN_4_SEL				0x00003000
+#define BIN_OFFSET_SEL				0x00004000
+#define BIN_BLW_SEL				0x00008000
+#define BIN_AVG_SEL				0x00009000
+#define BIN_M1_SEL				0x0000c000
+#define BIN_LONG_SEL				0x0000d000
+#define CDR_SEL_MASK				0x0000f000
+
+#define RATIO_PREQ_SHIFT			16
+#define RATIO_PST1Q_SHIFT			8
+#define AMP_RED_SHIFT				0
+#define ADPT_EQ_SHIFT				24
+
+#define RATIO_PREQ_MASK				0x000f0000
+#define RATIO_PST1Q_MASK			0x00001f00
+#define ADPT_EQ_MASK				0x3f000000
+#define AMP_RED_MASK				0x0000003f
+
+#define TECR0_INIT				0x20808000
+
+#define RESET_REQ_MASK				0x80000000
+
+#define TCSR0_SD_STAT_OBS_EN_MASK		0x80000000
+#define RECR3_SNP_START_MASK			0x80000000
+#define RECR3_SNP_DONE_MASK			0x40000000
+
+#define RECR4_SNP_DATA_MASK			0x000001ff
+#define RECR4_SNP_DATA_SHIFT			0
+#define RECR4_EQ_SNPBIN_SIGN_MASK		0x100
+
+#define RECR3_GAINK2_MASK			0x1f000000
+#define RECR3_GAINK2_SHIFT			24
+
+#define RECR3_GAINK3_MASK			0x001f0000
+#define RECR3_GAINK3_SHIFT			16
+
+#define RECR4_EQ_OFFSET_MASK			0x003f0000
+#define RECR4_EQ_OFFSET_SHIFT			16
+
+#define RRSTCTL_CDR_LOCK_MASK			0x00001000
+
+/* AN advertisement register 7.3 */
+#define AN_AD_ABILITY_1				0x03
+
+/* Backplane Ethernet status (Register 7.15) */
+#define AN_BP_ETH_STATUS_OFFSET			0x0F
+
+/* Link Training Control and Status Registers: page 1: 0x100 */
+#define KR_LT_BASE_OFFSET			0x100
+
+/* Bin snapshots thresholds range */
+#define EQ_BIN_MIN				-256
+#define EQ_BIN_MAX				255
+/* Bin snapshots average thresholds range */
+#define EQ_BIN_SNP_AV_THR_LOW			-150
+#define EQ_BIN_SNP_AV_THR_HIGH			150
+
+#define EQ_GAINK_MIN				0x1F
+#define EQ_GAINK_MAX				0x0
+#define EQ_GAINK_MIDRANGE_LOW			0x1E
+#define EQ_GAINK_MIDRANGE_HIGH			0x1
+
+#define EQ_OFFSET_MIN				0
+#define EQ_OFFSET_MAX				0x3F
+#define EQ_OFFSET_MIDRANGE_LOW			0x10
+#define EQ_OFFSET_MIDRANGE_HIGH			0x2F
+
+#define MEMORY_MAP_SIZE				0x100
+
+struct qoriq_lane_regs {
+	u32 gcr0;	/* 0x00: General Control Register 0 */
+	u32 res_04[7];	/* 0x04: Reserved */
+	u32 trstctl;	/* 0x20: TX Reset Control Register */
+	u32 tgcr0;	/* 0x24: TX General Control Register 0 */
+	u32 tgcr1;	/* 0x28: TX General Control Register 1 */
+	u32 tgcr2;	/* 0x2C: TX General Control Register 2 */
+	u32 tecr0;	/* 0x30: Transmit Equalization Control Register 0 */
+	u32 tecr1;	/* 0x34: Transmit Equalization Control Register 1 */
+	u32 res_38[2];	/* 0x38: Reserved */
+	u32 rrstctl;	/* 0x40: RX Reset Control Register */
+	u32 rgcr0;	/* 0x44: RX General Control Register 0 */
+	u32 rxgcr1;	/* 0x48: RX General Control Register 1 */
+	u32 res_4c;	/* 0x4C: Reserved */
+	u32 recr0;	/* 0x50: RX Equalization Register 0 */
+	u32 recr1;	/* 0x54: RX Equalization Register 1 */
+	u32 recr2;	/* 0x58: RX Equalization Register 2 */
+	u32 recr3;	/* 0x5C: RX Equalization Register 3 */
+	u32 recr4;	/* 0x60: RX Equalization Register 4 */
+	u32 res_64;	/* 0x64: Reserved */
+	u32 rccr0;	/* 0x68: RX Calibration Register 0 */
+	u32 rccr1;	/* 0x6C: RX Calibration Register 1 */
+	u32 rcpcr0;	/* 0x70: RX Clock Path Register 0 */
+	u32 rsccr0;	/* 0x74: RX Sampler Calibration Control Register 0 */
+	u32 rsccr1;	/* 0x78: RX Sampler Calibration Control Register 1 */
+	u32 res_7c;	/* 0x7C: Reserved */
+	u32 ttlcr0;	/* 0x80: Transition Tracking Loop Register 0 */
+	u32 ttlcr1;	/* 0x84: Transition Tracking Loop Register 1 */
+	u32 ttlcr2;	/* 0x88: Transition Tracking Loop Register 2 */
+	u32 ttlcr3;	/* 0x8C: Transition Tracking Loop Register 3 */
+	u32 res_90[4];	/* 0x90: Reserved */
+	u32 tcsr0;	/* 0xA0: Test Control/Status Register 0 */
+	u32 tcsr1;	/* 0xA4: Test Control/Status Register 1 */
+	u32 tcsr2;	/* 0xA8: Test Control/Status Register 2 */
+	u32 tcsr3;	/* 0xAC: Test Control/Status Register 3 */
+	u32 tcsr4;	/* 0xB0: Test Control/Status Register 4 */
+	u32 res_b4[3];	/* 0xB4: Reserved */
+	u32 rxcb0;	/* 0xC0: RX Control Block Register 0 */
+	u32 rxcb1;	/* 0xC4: RX Control Block Register 1 */
+	u32 res_c8[2];	/* 0xC8: Reserved */
+	u32 rxss0;	/* 0xD0: RX Speed Switch Register 0 */
+	u32 rxss1;	/* 0xD4: RX Speed Switch Register 1 */
+	u32 rxss2;	/* 0xD8: RX Speed Switch Register 2 */
+	u32 res_dc;	/* 0xDC: Reserved */
+	u32 txcb0;	/* 0xE0: TX Control Block Register 0 */
+	u32 txcb1;	/* 0xE4: TX Control Block Register 1 */
+	u32 res_e8[2];	/* 0xE8: Reserved */
+	u32 txss0;	/* 0xF0: TX Speed Switch Register 0 */
+	u32 txss1;	/* 0xF4: TX Speed Switch Register 1 */
+	u32 txss2;	/* 0xF8: TX Speed Switch Register 2 */
+	u32 res_fc;	/* 0xFC: Reserved */
+};
+
+static struct mem_io io;
+
+static void reset_lane(void __iomem *reg, enum lane_req ln_req)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	u64 timeout;
+	u32 val;
+
+	/* reset Tx lane: send reset request */
+	if (ln_req | LANE_TX) {
+		io.write32(io.read32(&reg_base->trstctl) |
+			   RESET_REQ_MASK, &reg_base->trstctl);
+		udelay(1);
+		timeout = 10;
+		while (timeout--) {
+			val = io.read32(&reg_base->trstctl);
+			if (!(val & RESET_REQ_MASK))
+				break;
+			usleep_range(5, 20);
+		}
+	}
+
+	/* reset Rx lane: send reset request */
+	if (ln_req | LANE_RX) {
+		io.write32(io.read32(&reg_base->rrstctl) |
+			   RESET_REQ_MASK, &reg_base->rrstctl);
+		udelay(1);
+		timeout = 10;
+		while (timeout--) {
+			val = io.read32(&reg_base->rrstctl);
+			if (!(val & RESET_REQ_MASK))
+				break;
+			usleep_range(5, 20);
+		}
+	}
+
+	/* wait for a while after reset */
+	if (ln_req != LANE_INVALID) {
+		timeout = jiffies + 10;
+		while (time_before(jiffies, (unsigned long)timeout)) {
+			schedule();
+			usleep_range(5, 20);
+		}
+	}
+}
+
+static u32 read_tecr0(void __iomem *reg)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+
+	return io.read32(&reg_base->tecr0);
+}
+
+static u32 read_tecr1(void __iomem *reg)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+
+	return io.read32(&reg_base->tecr1);
+}
+
+static u32 read_amp_red(void __iomem *reg)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	u32 val, amp_red;
+
+	val = io.read32(&reg_base->tecr0);
+	amp_red = (val & AMP_RED_MASK) >> AMP_RED_SHIFT;
+
+	return amp_red;
+}
+
+static void read_kr_coef(void __iomem *reg, struct kr_coef *coef)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	u32 val;
+
+	val = io.read32(&reg_base->tecr0);
+	coef->preq = (val & RATIO_PREQ_MASK) >> RATIO_PREQ_SHIFT;
+	coef->postq = (val & RATIO_PST1Q_MASK) >> RATIO_PST1Q_SHIFT;
+	coef->dev_coef[IDX_AMP_RED] = (val & AMP_RED_MASK) >> AMP_RED_SHIFT;
+
+	val = io.read32(&reg_base->tecr1);
+	coef->mainq = (val & ADPT_EQ_MASK) >> ADPT_EQ_SHIFT;
+}
+
+static void tune_tecr(void __iomem *reg, struct kr_coef *coef, bool reset)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	u32 val;
+
+	/* reset lanes */
+	if (reset)
+		reset_lane(reg, LANE_RX_TX);
+
+	val = TECR0_INIT |
+		coef->preq << RATIO_PREQ_SHIFT |
+		coef->postq << RATIO_PST1Q_SHIFT |
+		coef->dev_coef[IDX_AMP_RED] << AMP_RED_SHIFT;
+	io.write32(val, &reg_base->tecr0);
+
+	val = coef->mainq << ADPT_EQ_SHIFT;
+	io.write32(val, &reg_base->tecr1);
+
+	udelay(1);
+}
+
+/* collect_gains
+ *
+ * reg: serdes registers memory map
+ * gaink2: High-frequency gain of the equalizer amplifier
+ *         the high-frequency gain of the equalizer amplifier is increased by
+ *         decrementing the value of eq_gaink2 by one
+ * gaink3: Middle-frequency gain of the equalizer amplifier
+ *         the mid-frequency gain of the equalizer amplifier is increased by
+ *         decrementing the value of eq_gaink3 by one
+ * osestat: equalization offset status
+ *          the equalizer offset is reduced by decrementing the value of osestat
+ * size: size of snapshots data collection
+ */
+static int collect_gains(void __iomem *reg, s16 *gaink2, s16 *gaink3,
+			 s16 *osestat, u8 size)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	u32 recr3, recr4;
+	int timeout;
+	int i;
+
+	/* Enable observation of SerDes status on all status registers */
+	io.write32(io.read32(&reg_base->tcsr0) |
+		   TCSR0_SD_STAT_OBS_EN_MASK, &reg_base->tcsr0);
+
+	for (i = 0; i < size; i++) {
+		/* wait RECR3_SNP_DONE_MASK has cleared */
+		timeout = 100;
+		while (io.read32(&reg_base->recr3) & RECR3_SNP_DONE_MASK) {
+			udelay(1);
+			timeout--;
+			if (timeout == 0)
+				break;
+		}
+
+		/* start snapshot */
+		io.write32((io.read32(&reg_base->recr3) |
+			    RECR3_SNP_START_MASK), &reg_base->recr3);
+
+		/* wait for SNP done */
+		timeout = 100;
+		while (!(io.read32(&reg_base->recr3) &
+			 RECR3_SNP_DONE_MASK)) {
+			udelay(1);
+			timeout--;
+			if (timeout == 0)
+				break;
+		}
+
+		/* read and save the snapshot */
+		recr3 = io.read32(&reg_base->recr3);
+		recr4 = io.read32(&reg_base->recr4);
+
+		if (gaink2)
+			gaink2[i] = (u8)((recr3 & RECR3_GAINK2_MASK) >>
+					 RECR3_GAINK2_SHIFT);
+		if (gaink3)
+			gaink3[i] = (u8)((recr3 & RECR3_GAINK3_MASK) >>
+					 RECR3_GAINK3_SHIFT);
+		if (osestat)
+			osestat[i] = (u8)((recr4 & RECR4_EQ_OFFSET_MASK) >>
+					  RECR4_EQ_OFFSET_SHIFT);
+
+		/* terminate the snapshot by setting GCR1[REQ_CTL_SNP] */
+		io.write32((io.read32(&reg_base->recr3) &
+			    ~RECR3_SNP_START_MASK), &reg_base->recr3);
+	}
+	return i;
+}
+
+static int collect_eq_status(void __iomem *reg, enum eqc_type type[],
+			     u8 type_no, s16 *counters, u8 size)
+{
+	s16 *gaink2 = NULL, *gaink3 = NULL, *osestat = NULL;
+	u8 i;
+
+	for (i = 0; i < type_no; i++) {
+		switch (type[i]) {
+		case EQC_GAIN_HF:
+			gaink2 = counters;
+			break;
+		case EQC_GAIN_MF:
+			gaink3 = counters + size;
+			break;
+		case EQC_EQOFFSET:
+			osestat = counters + 2 * size;
+			break;
+		default:
+			/* invalid type */
+			break;
+		}
+	}
+
+	return collect_gains(reg, gaink2, gaink3, osestat, size);
+}
+
+static int collect_bin_snapshots(void __iomem *reg, enum eqc_type type,
+				 s16 *bin_counters, u8 bin_size)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	int bin_snapshot;
+	int i, timeout;
+	u32 bin_sel;
+
+	/* calculate RECR4[EQ_BIN_DATA_SEL] */
+	switch (type) {
+	case EQC_BIN_1:
+		bin_sel = BIN_1_SEL;
+		break;
+	case EQC_BIN_2:
+		bin_sel = BIN_2_SEL;
+		break;
+	case EQC_BIN_3:
+		bin_sel = BIN_3_SEL;
+		break;
+	case EQC_BIN_4:
+		bin_sel = BIN_4_SEL;
+		break;
+	case EQC_BIN_LONG:
+		bin_sel = BIN_LONG_SEL;
+		break;
+	case EQC_BIN_M1:
+		bin_sel = BIN_M1_SEL;
+		break;
+	case EQC_BIN_OFFSET:
+		bin_sel = BIN_OFFSET_SEL;
+		break;
+	case EQC_BIN_AVG:
+		bin_sel = BIN_AVG_SEL;
+		break;
+	case EQC_BIN_BLW:
+		bin_sel = BIN_BLW_SEL;
+		break;
+	default:
+		/* invalid bin type */
+		return 0;
+	}
+
+	/* Enable observation of SerDes status on all status registers */
+	io.write32(io.read32(&reg_base->tcsr0) |
+		   TCSR0_SD_STAT_OBS_EN_MASK, &reg_base->tcsr0);
+
+	for (i = 0; i < bin_size; i++) {
+		/* wait RECR3_SNP_DONE_MASK has cleared */
+		timeout = 100;
+		while ((io.read32(&reg_base->recr3) &
+			RECR3_SNP_DONE_MASK)) {
+			udelay(1);
+			timeout--;
+			if (timeout == 0)
+				break;
+		}
+
+		/* set RECR4[EQ_BIN_DATA_SEL] */
+		io.write32((io.read32(&reg_base->recr4) &
+			    ~CDR_SEL_MASK) | bin_sel, &reg_base->recr4);
+
+		/* start snapshot */
+		io.write32(io.read32(&reg_base->recr3) |
+			   RECR3_SNP_START_MASK, &reg_base->recr3);
+
+		/* wait for SNP done */
+		timeout = 100;
+		while (!(io.read32(&reg_base->recr3) &
+			 RECR3_SNP_DONE_MASK)) {
+			udelay(1);
+			timeout--;
+			if (timeout == 0)
+				break;
+		}
+
+		/* read and save the snapshot:
+		 * 2's complement 9 bit long value (-256 to 255)
+		 */
+		bin_snapshot = (io.read32(&reg_base->recr4) &
+				RECR4_SNP_DATA_MASK) >> RECR4_SNP_DATA_SHIFT;
+		if (bin_snapshot & RECR4_EQ_SNPBIN_SIGN_MASK) {
+			/* 2's complement 9 bit long negative number */
+			bin_snapshot &= ~RECR4_EQ_SNPBIN_SIGN_MASK;
+			bin_snapshot -= 256;
+		}
+
+		/* save collected Bin snapshot */
+		bin_counters[i] = (s16)bin_snapshot;
+
+		/* terminate the snapshot by setting GCR1[REQ_CTL_SNP] */
+		io.write32(io.read32(&reg_base->recr3) &
+			   ~RECR3_SNP_START_MASK, &reg_base->recr3);
+	}
+	return i;
+}
+
+static struct eqc_range bin_range = {
+	.min = EQ_BIN_MIN,
+	.max = EQ_BIN_MAX,
+	.mid_low = EQ_BIN_SNP_AV_THR_LOW,
+	.mid_high = EQ_BIN_SNP_AV_THR_HIGH,
+};
+
+static struct eqc_range gaink_range = {
+	.min = EQ_GAINK_MIN,
+	.max = EQ_GAINK_MAX,
+	.mid_low = EQ_GAINK_MIDRANGE_LOW,
+	.mid_high = EQ_GAINK_MIDRANGE_HIGH,
+};
+
+static struct eqc_range osestat_range = {
+	.min = EQ_OFFSET_MIN,
+	.max = EQ_OFFSET_MAX,
+	.mid_low = EQ_OFFSET_MIDRANGE_LOW,
+	.mid_high = EQ_OFFSET_MIDRANGE_HIGH,
+};
+
+static struct eqc_range *get_counter_range(enum eqc_type type)
+{
+	switch (type) {
+	case EQC_BIN_1:
+	case EQC_BIN_2:
+	case EQC_BIN_3:
+	case EQC_BIN_4:
+	case EQC_BIN_LONG:
+	case EQC_BIN_M1:
+	case EQC_BIN_OFFSET:
+	case EQC_BIN_AVG:
+	case EQC_BIN_BLW:
+		return &bin_range;
+	case EQC_GAIN_HF:
+	case EQC_GAIN_MF:
+		return &gaink_range;
+	case EQC_EQOFFSET:
+		return &osestat_range;
+	default:
+		/* invalid counter type */
+		return NULL;
+	}
+	return NULL;
+}
+
+static bool is_cdr_lock_bit(void __iomem *reg)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+
+	if (io.read32(&reg_base->rrstctl) & RRSTCTL_CDR_LOCK_MASK)
+		return true;
+
+	return false;
+}
+
+static const struct qoriq_lane_ops qoriq_lane_ops_28g = {
+	.read_tecr0 = read_tecr0,
+	.read_tecr1 = read_tecr1,
+	.read_amp_red = read_amp_red,
+};
+
+static const struct lane_ops lane_ops_28g = {
+	.priv = &qoriq_lane_ops_28g,
+	.memmap_size = MEMORY_MAP_SIZE,
+	.reset_lane = reset_lane,
+	.tune_lane_kr = tune_tecr,
+	.read_lane_kr = read_kr_coef,
+	.is_cdr_lock = is_cdr_lock_bit,
+};
+
+const struct lane_ops *qoriq_get_lane_ops_28g(void)
+{
+	return &lane_ops_28g;
+}
+
+static const struct equalizer_device qoriq_equalizer = {
+	.name = EQUALIZER_NAME,
+	.version = EQUALIZER_VERSION,
+	.ops = {
+		.collect_counters = collect_bin_snapshots,
+		.collect_multiple_counters = collect_eq_status,
+		.get_counter_range = get_counter_range,
+	},
+};
+
+const struct equalizer_device *qoriq_get_equalizer_28g(void)
+{
+	return &qoriq_equalizer;
+}
+
+static const struct qoriq_driver qoriq_drv = {
+	/* Link Training Control and Status Registers: page 1: 0x100 */
+	.kr_lt_devad = MDIO_MMD_AN,
+	.kr_lt_base = KR_LT_BASE_OFFSET,
+	/* Auto-Negotiation Control and Status Registers: page 0 */
+	.an_adv1 = AN_AD_ABILITY_1,
+	.an_bp_eth_status = AN_BP_ETH_STATUS_OFFSET,
+};
+
+const struct qoriq_driver *get_qoriq_driver_28g(void)
+{
+	return &qoriq_drv;
+}
+
+void qoriq_setup_mem_io_28g(struct mem_io memio)
+{
+	io = memio;
+}
-- 
1.9.1

