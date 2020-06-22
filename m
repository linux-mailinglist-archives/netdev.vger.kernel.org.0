Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119FD203829
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbgFVNgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:36:21 -0400
Received: from mail-db8eur05on2055.outbound.protection.outlook.com ([40.107.20.55]:24081
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729103AbgFVNgQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:36:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HS4gDf0+/ynVxooDmKjcUSlOIuNuJuj3qQh+ZdcU8yFW/4w1ujZ6rhsWzgX3fdQPb1V3LtSKfPNxFwy7KRGO9jZ6DJnS9R8u/qx9vhgfA/x8y9Udz6xP5NmmZIFkMe1JMWmcRdK9jxDY6JMozeyJaNfp+52vh4Esj/DzSIhGJwEhWpqEzjTME4pRQqxBSS0eOGW1CSYiLiHly8vSwP5kQSvi460E+3AJvR7FR2J9JqoWQbt7VO6NHpxLW86WANUXLiE2yLarK6xBlxwmgZOEJfqKHkcbQUImZOmnvhdjvzE+6p4UbOSG4FxaPU4ijOnANznQnrz6qTN48gdlyJtQXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Bop+vhFZMti8SjR3m5sEO7m7f3PqLGhBfZKGrfiqI8=;
 b=ivJ2ZAuL33RvZaRk5aCDoXMS+M7Hz/qGM+OZ1mTpv4mLqABDNdtc3wJgGtMr9tzbr/+iX5Y/FovQECOiUQX7QAQ+Koo+Q5k7C+kbFudRJsYOeCWX+3l0hQmkwBvnkruErp1F07LRcGNMRmHEex7DLLctc6P6bHigps1IVvEEd6vBBsaNKAydR9m1Xd9Zoo4YK+AhtGsjzo+Us1axRhX/WnhbfGn2Pb+1NR+f3ZUm/FUVUnx0vqVl+7K1cU2dCy6dEIpAu1fy5tQnaBpj8zRGzM6z+dJJorJ/+y1S0fSf796kveRpKBRI68pIHevCY2gJNlgCVjTauEjqDW/jGKArfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Bop+vhFZMti8SjR3m5sEO7m7f3PqLGhBfZKGrfiqI8=;
 b=f+iLbS3ARKF+DwEzD4pJp+vBGNscu6eumclDu74aHr9x50hZHrxnHV+BeasF0mpokxgQS3K66xzxSpTwRsSguVu0aXxUZcqU6AxrWCYBPMBLWDqw0wWRZPHmPLDb7ii2M7F9CXLJXGnSMrKN5kfz1uD64GkMWSvlIqR/vV+Gjt8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5075.eurprd04.prod.outlook.com (2603:10a6:208:bf::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 13:35:57 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 13:35:57 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next v3 5/7] net: phy: enable qoriq backplane support
Date:   Mon, 22 Jun 2020 16:35:22 +0300
Message-Id: <1592832924-31733-6-git-send-email-florinel.iordache@nxp.com>
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
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM3PR07CA0086.eurprd07.prod.outlook.com (2603:10a6:207:6::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3131.12 via Frontend Transport; Mon, 22 Jun 2020 13:35:56 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6676f2ec-0f96-46b3-ffd4-08d816b131be
X-MS-TrafficTypeDiagnostic: AM0PR04MB5075:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB507531D843DB5633F5625241FB970@AM0PR04MB5075.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:660;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TXAvmFUvdjtsZrLcj+6rAFt3c5XfsprHUwum2UMUGvTs0PnTkq0GtWqjwTKbxC1ltLjQV9m2j/nOWjCxas/9dIlevlPrpWzXw/IwFUq2EqaDRUP/ePxWu210yqc395pYZAAyZ4upHgjkVPFhMNuDzScxeca20P7OyiWi61a90SA7VEFDW97CLb6oG1058zCVh06wRggHBsqEP5IBQnjUWqaupVRvPygN2JwiN5W8qiUPdMMbd5jyVtjBnTUsKjcmCeauT35hoegIVNUejDLVvO9EIWFJ7HUgUbDHUT5gf2nE3LAIaFiDy0A9iZO1j/tu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(66476007)(66556008)(66946007)(83380400001)(5660300002)(2616005)(30864003)(956004)(44832011)(86362001)(6666004)(2906002)(8676002)(6512007)(52116002)(16526019)(186003)(26005)(3450700001)(6506007)(4326008)(6486002)(316002)(478600001)(8936002)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PIm69d1hgYvcjdDyFN6fyk0xlgpERIFo0VzdTcKws8un66pzPZBtOVxfqUpSRRTqWNoyk+fOJcG03dg2qnwqO8jA03WbzYRnSzNt8CLBqSEpXDYwPrM7KPs2OoFSKR326rvOTK9BTbciUIxjv/YpA2TGelJPOvlfpL/h0RndmolJUJdyHuJsiU5XKICZd0sQhG6Q0WdcP5BjCWK7zX/eHxQU5vfKfeKG6U9TWS3GBuPurJhVdQUubOUOFHK8qfal+HWsEDZLgEyIMZpDwldJB/03Y+jSB/cKaqhRBlgs0kRFUjaG2fBP4V8QvyaZAbGoJR+pNjdAz5JtzgQW+J4feR1X6vJfPjmiR9PqgoN775wNmUgtLdAHGVn2600fEZHtbHGSNswHdgddzQZfxVSXCWsSdm/Fa4RbFDn5OtbSSwJmlFs/37sOPD2l5Fn8X29qgr6Cs1WI2o85Tdp40Xiai2Pb447V7SRPLt9rWlHhXQQ=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6676f2ec-0f96-46b3-ffd4-08d816b131be
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 13:35:57.4597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7bHJnJpyjmzT0WRHGeiu2iUbHYblULIgg2fdSPLdy/fbInYZHN4LDRxG0//Im4xx/KqwwxOinSq8adR2oifLDvSjnz77Wo+Wi6aiB/joFBA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5075
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable backplane support for qoriq family of devices

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/phy/backplane/Kconfig            |  11 +-
 drivers/net/phy/backplane/Makefile           |   2 +
 drivers/net/phy/backplane/qoriq_backplane.c  | 473 ++++++++++++++++++++++++++
 drivers/net/phy/backplane/qoriq_backplane.h  |  42 +++
 drivers/net/phy/backplane/qoriq_serdes_10g.c | 486 +++++++++++++++++++++++++++
 5 files changed, 1013 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/phy/backplane/qoriq_backplane.c
 create mode 100644 drivers/net/phy/backplane/qoriq_backplane.h
 create mode 100644 drivers/net/phy/backplane/qoriq_serdes_10g.c

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
index ded6f2d..3ae3d8b 100644
--- a/drivers/net/phy/backplane/Makefile
+++ b/drivers/net/phy/backplane/Makefile
@@ -5,5 +5,7 @@
 
 obj-$(CONFIG_ETH_BACKPLANE) += eth_backplane.o
 obj-$(CONFIG_ETH_BACKPLANE_FIXED) += eq_fixed.o
+obj-$(CONFIG_ETH_BACKPLANE_QORIQ) += eth_backplane_qoriq.o
 
 eth_backplane-objs	:= backplane.o link_training.o
+eth_backplane_qoriq-objs	:= qoriq_backplane.o qoriq_serdes_10g.o
diff --git a/drivers/net/phy/backplane/qoriq_backplane.c b/drivers/net/phy/backplane/qoriq_backplane.c
new file mode 100644
index 0000000..eb22e02
--- /dev/null
+++ b/drivers/net/phy/backplane/qoriq_backplane.c
@@ -0,0 +1,473 @@
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
+		phydev_err(phydev,
+			   "Setting AN register 0x%02x on lane %d failed with error code: 0x%08x\n",
+			   qoriq_drv->an_adv1, lane->idx, err);
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
+		phydev_err(phydev, "No associated device tree node\n");
+		return -EINVAL;
+	}
+	if (!bpdev) {
+		phydev_err(phydev, "Backplane phy info is not allocated\n");
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
+	if (bpdev->num_lanes > MAX_KR_LANES_PER_PHY) {
+		phydev_err(phydev, "Unsupported number of lanes per phy: %d\n",
+			   bpdev->num_lanes);
+		return -EINVAL;
+	}
+
+	proplen = of_property_count_u32_elems(dev_node, "lane-handle");
+	if (proplen < bpdev->num_lanes) {
+		phydev_err(phydev, "Unspecified lane handles\n");
+		return -EINVAL;
+	}
+	serdes_node = NULL;
+	for (i = 0; i < bpdev->num_lanes; i++) {
+		lane_node = of_parse_phandle(dev_node, "lane-handle", i);
+		if (!lane_node) {
+			phydev_err(phydev, "parse lane-handle failed\n");
+			return -EINVAL;
+		}
+		if (i == 0)
+			serdes_node = lane_node->parent;
+		ret = of_address_to_resource(lane_node, 0, &res);
+		if (ret) {
+			phydev_err(phydev,
+				   "could not obtain lane memory map for index=%d, ret = %d\n",
+				   i, ret);
+			return ret;
+		}
+		/* setup lane address */
+		bpdev->lane[i].lane_addr = res.start;
+
+		of_node_put(lane_node);
+	}
+	if (!serdes_node) {
+		phydev_err(phydev, "serdes node not found\n");
+		return -EINVAL;
+	}
+	bpdev->drv.is_little_endian = of_property_read_bool(serdes_node,
+							    "little-endian");
+
+	ret = of_address_to_resource(serdes_node, 0, &res);
+	if (ret) {
+		phydev_err(phydev,
+			   "could not obtain serdes memory map, ret = %d\n",
+			   ret);
+		return ret;
+	}
+	bpdev->drv.base_addr = res.start;
+	bpdev->drv.memmap_size = res.end - res.start + 1;
+
+	serdes = get_serdes_type(serdes_node);
+	if (serdes == SERDES_INVAL) {
+		phydev_err(phydev, "Unknown serdes-type\n");
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
+	default:
+		phydev_err(phydev, "Serdes type not supported\n");
+		return -EINVAL;
+	}
+	if (!lane_ops) {
+		phydev_err(phydev, "Lane ops not available\n");
+		return -EINVAL;
+	}
+	if (!qoriq_drv) {
+		phydev_err(phydev, "Qoriq driver not available\n");
+		return -EINVAL;
+	}
+	if (!qoriq_equalizer) {
+		phydev_err(phydev, "Qoriq Equalizer not available\n");
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
+		phydev_err(phydev, "QorIQ lane ops not available\n");
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
+		phydev_err(phydev, "No associated device tree node\n");
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
+	default:
+		phydev_err(phydev, "Unknown serdes-type\n");
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
index 0000000..09a3600
--- /dev/null
+++ b/drivers/net/phy/backplane/qoriq_backplane.h
@@ -0,0 +1,42 @@
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
+
+const struct equalizer_device *qoriq_get_equalizer_10g(void);
+
+const struct qoriq_driver *get_qoriq_driver_10g(void);
+
+void qoriq_setup_mem_io_10g(struct mem_io memio);
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
-- 
1.9.1

