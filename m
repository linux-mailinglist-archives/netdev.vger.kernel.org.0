Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64D7A19407E
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 14:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgCZNwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 09:52:42 -0400
Received: from mail-eopbgr60089.outbound.protection.outlook.com ([40.107.6.89]:57111
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727771AbgCZNwl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 09:52:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8u8P4lAD1UcDq7aQhwTbAeHTmIBA4RuqLVyP9rKkyTSYxXqBuDkjWzUX8nwZW0ZNAH1S7H+R8Y+DTNIgCw37SQuOsW8WYqdN6D7eOZyqay4YVseLUpI1opAAlJNSofkAE8RfCwSLA5FGv8BSrRBAMtgIZY04RxQ6I9jom7YJm3heFDmlGTxZHf1+exTw4HNwDNhdTOjDFhSdRAh4Hgj5qVwIZKL2X+gL8DwZitp+MVB0b/xSNjuwOwiXahx8WjjGP4aVo2MaMUF5xCLROu5Zrr0I6hClNy/r53Qkq+o/oWZcJgyaFHTythjYdEhleXSD13V+cu+X0AmJqLbdPot2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDYoVNeFlyMXDF9d3GNHOBxLOmD9cLlShBqYQlKhFgY=;
 b=IzpiHfj62XXr+GEnG4KvNWFw9Tn9dT8a8W/JXaC8JzAHj18t/lLIqDQ6QXJGSHaQ5ILJR/qHPqkZz1pky0NhyAf0pHYWlN6j8x1sz6cq3RYXhs2Xf4lXjQf3Vv2neqMLor99SvSEAdjwTUQa6mI5cK+5Bp6NUvmuHeRMqvK3Noh36r/mDnK9aIjLhgecW6Q3MAAEBKo1/BeEHpbjDB4aUXI1Su9x2bhS3eW80lmczMHtxTYSE+lVxSuxUdsyibz6xMcykKzFRi2OncS2dlJs4t/7qo4vog89P4kcV8PLAiLe6tmHNg2wydgM++PozbJbAHlpXAnHYHSTy1SqbTuvGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDYoVNeFlyMXDF9d3GNHOBxLOmD9cLlShBqYQlKhFgY=;
 b=nn+ZoL8XzWz7AQRcT77DO+B0jXhfDjG7N+cIwRToqlH4sL47IdT4iG1hknrnaA2/IVIBo9d9rw/MengmDgHgCB6vxhKqdrukfOXxoOHb59FgGJOb2OM1PcY02B5TnSzV8vbRADcfBai5ce3JvS/tTx6GYjbSYUyGEQlUFUH/ThQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com (20.178.122.87) by
 VI1PR04MB4272.eurprd04.prod.outlook.com (10.171.182.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Thu, 26 Mar 2020 13:52:16 +0000
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8]) by VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8%3]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 13:52:16 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next 7/9] net: phy: enable qoriq backplane support
Date:   Thu, 26 Mar 2020 15:51:20 +0200
Message-Id: <1585230682-24417-8-git-send-email-florinel.iordache@nxp.com>
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
Received: from fsr-ub1464-128.ea.freescale.net (89.37.124.34) by AM0PR01CA0142.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2835.20 via Frontend Transport; Thu, 26 Mar 2020 13:52:14 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [89.37.124.34]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b070d47e-0bbf-4530-e2e9-08d7d18ce4c3
X-MS-TrafficTypeDiagnostic: VI1PR04MB4272:|VI1PR04MB4272:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB427252B6AD9DE8AFAD612A5BFBCF0@VI1PR04MB4272.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:568;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(26005)(478600001)(186003)(16526019)(956004)(81166006)(3450700001)(36756003)(81156014)(8936002)(44832011)(4326008)(8676002)(5660300002)(2616005)(7416002)(2906002)(66946007)(86362001)(6486002)(30864003)(66556008)(316002)(6506007)(6512007)(6666004)(66476007)(52116002)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4272;H:VI1PR04MB5454.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2K8nihQLkjuZk4T60XKdI2rpBMq2yyGlGM/pi6v+AwUo1dJNcy9m0nLsZD5ffFlcTuuyu8F+BNRyvGuV/us6b612ADRvxp/ZXtY19rbDeSl0iEQzY7x7b8CSg2eDKKC74R6QfyI8iQ/VpsACVko7Jjo3kbXO10iBjL0PDfXkrFg4MLP7Z8PALBKXvjrxUhEkR8gohFkdYF/fe4OSdfcjkcaKFa0QKz0cV2hcshzSe+Iq5e182sUnZoK91rRjdKsT/cOSvLsbwdAfq8MTR/cDMyWP9qYYIN697qvfUNUC90o/8j1fbroM+9brKnspJjRCTwVsR8bkIhkJ2cdJcSvPsEvLcyTF18Q1QHD8tIqzvZ3X1Qy9NZy4qebJRoB2u9ynuCNZZif8i6IphE+Fcp18i4CstwV+mh9jHfWRV/abXvnAfyTjZt2dIHhHcGNNcdlA
X-MS-Exchange-AntiSpam-MessageData: 3dFUKU6xNqPmh51H7l9CfcoPhaVVG481ttA8DLagzYvOGxnAEmF8knKoSrFHwZVvQ4DwwMOKd0qU6geyzhroT8C8MV5BUilAh4svlSla1joIphGTm7nV/PoHsE15F0MVM4sA6L2H3cOHxA8nWCrzww==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b070d47e-0bbf-4530-e2e9-08d7d18ce4c3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 13:52:16.1643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0DYZ3+8b23ZvkvO4rDm52rJDHz4lrsBayAgFsv0jq2RY7rtkyp7wQOOwjW+uf2kWDe/zr/xJVDGxJmfsIcA1dwCfK1uL1B0rcqFTdj5n2R4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4272
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable backplane support for qoriq family of devices

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/phy/backplane/Kconfig            |  11 +-
 drivers/net/phy/backplane/Makefile           |   2 +
 drivers/net/phy/backplane/qoriq_backplane.c  | 442 ++++++++++++++++++++++
 drivers/net/phy/backplane/qoriq_backplane.h  |  33 ++
 drivers/net/phy/backplane/qoriq_serdes_10g.c | 470 +++++++++++++++++++++++
 drivers/net/phy/backplane/qoriq_serdes_28g.c | 533 +++++++++++++++++++++++++++
 6 files changed, 1490 insertions(+), 1 deletion(-)
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
index 0000000..9a2cd4e
--- /dev/null
+++ b/drivers/net/phy/backplane/qoriq_backplane.c
@@ -0,0 +1,442 @@
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
+/* AN registers initialization */
+#define KR_AN_AD1_INIT_10G			0x85
+#define KR_AN_AD1_INIT_40G			0x105
+
+/* AN masks: Backplane Ethernet status (Register 7.48) */
+#define AN_MASK_10GBASE_KR			0x08
+#define AN_MASK_40GBASE_KR4			0x20
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
+/* Backplane Ethernet Status Register (an_bp_eth_status)
+ * chapter: 45.2.7.12 Backplane Ethernet status (Register 7.48)
+ *	- bit AN_MASK_10GBASE_KR for 10GBase-KR
+ *	- bit AN_MASK_40GBASE_KR4 for 40GBase-KR4
+ */
+static u32 get_an_bp_eth_status_bit(phy_interface_t mode)
+{
+	u32 an_mask = 0;
+
+	switch (mode) {
+	case PHY_INTERFACE_MODE_10GKR:
+		an_mask = AN_MASK_10GBASE_KR;
+		break;
+	case PHY_INTERFACE_MODE_40GKR4:
+		an_mask = AN_MASK_40GBASE_KR4;
+		break;
+	/* add AN support for other backplane modes here */
+	default:
+		an_mask = 0;
+		break;
+	}
+	return an_mask;
+}
+
+static u32 get_an_ad_ability_1_init(phy_interface_t mode)
+{
+	u32 init_value = 0;
+
+	switch (mode) {
+	case PHY_INTERFACE_MODE_10GKR:
+		init_value = KR_AN_AD1_INIT_10G;
+		break;
+	case PHY_INTERFACE_MODE_40GKR4:
+		init_value = KR_AN_AD1_INIT_40G;
+		break;
+	/* add AN support for other backplane modes here */
+	default:
+		init_value = 0;
+		break;
+	}
+	return init_value;
+}
+
+/* qoriq_backplane_probe
+ *
+ * Probe function for QorIQ backplane driver to provide QorIQ device specific
+ * behavior
+ *
+ * bpphy: backplane phy device
+ *	this is an internal phy block controlled by the software
+ *	which contains other component blocks like: PMA/PMD, PCS, AN
+ *
+ * Return: Zero for success or error code in case of failure
+ */
+static int qoriq_backplane_probe(struct phy_device *bpphy)
+{
+	static bool one_time_action = true;
+
+	if (one_time_action) {
+		one_time_action = false;
+		pr_info("%s: QorIQ Backplane driver version %s\n",
+			QORIQ_BACKPLANE_DRIVER_NAME,
+			QORIQ_BACKPLANE_DRIVER_VERSION);
+	}
+
+	/* call generic driver probe */
+	return backplane_probe(bpphy);
+}
+
+/* qoriq_backplane_config_init
+ *
+ * Config_Init function for QorIQ devices to provide QorIQ specific behavior
+ *
+ * bpphy: backplane phy device
+ *
+ * Return: Zero for success or error code in case of failure
+ */
+static int qoriq_backplane_config_init(struct phy_device *bpphy)
+{
+	struct backplane_phy_info *bp_phy = bpphy->priv;
+	struct device_node *bpphy_node, *serdes_node, *lane_node;
+	struct resource res;
+	const char *serdes_comp;
+	const struct lane_io_ops *lane_ops = NULL;
+	struct qoriq_lane_ops *qoriq_lane = NULL;
+	const struct equalizer_info *equalizer = NULL;
+	int comp_no, i, ret;
+	int serdes_type = SERDES_INVAL;
+	u32 eqparams[EQ_PARAMS_NO];
+	int proplen;
+
+	bpphy_node = bpphy->mdio.dev.of_node;
+	if (!bpphy_node) {
+		bpdev_err(bpphy, "No associated device tree node\n");
+		return -EINVAL;
+	}
+
+	if (!bp_phy) {
+		bpdev_err(bpphy, "Backplane phy info is not allocated\n");
+		return -EINVAL;
+	}
+
+	if (!backplane_is_valid_mode(bpphy->interface))
+		return -EINVAL;
+
+	bp_phy->bp_mode = bpphy->interface;
+	bp_phy->num_lanes = backplane_num_lanes(bpphy->interface);
+
+	proplen = of_property_count_u32_elems(bpphy_node, "lane-handle");
+	if (proplen < bp_phy->num_lanes) {
+		bpdev_err(bpphy, "Unspecified lane handles\n");
+		return -EINVAL;
+	}
+	serdes_node = NULL;
+	for (i = 0; i < bp_phy->num_lanes; i++) {
+		lane_node = of_parse_phandle(bpphy_node, "lane-handle", i);
+		if (!lane_node) {
+			bpdev_err(bpphy, "parse lane-handle failed\n");
+			return -EINVAL;
+		}
+		if (i == 0)
+			serdes_node = lane_node->parent;
+		ret = of_address_to_resource(lane_node, 0, &res);
+		if (ret) {
+			bpdev_err(bpphy,
+				  "could not obtain lane memory map for index=%d, ret = %d\n",
+				  i, ret);
+			return ret;
+		}
+		/* setup lane address */
+		bp_phy->krln[i].lane_addr = res.start;
+
+		of_node_put(lane_node);
+	}
+	if (!serdes_node) {
+		bpdev_err(bpphy, "serdes node not found\n");
+		return -EINVAL;
+	}
+	bp_phy->bp_dev.is_little_endian = of_property_read_bool(serdes_node,
+								"little-endian");
+
+	ret = of_address_to_resource(serdes_node, 0, &res);
+	if (ret) {
+		bpdev_err(bpphy,
+			  "could not obtain serdes memory map, ret = %d\n",
+			  ret);
+		return ret;
+	}
+	bp_phy->bp_dev.base_addr = res.start;
+	bp_phy->bp_dev.memmap_size = res.end - res.start + 1;
+
+	comp_no = of_property_count_strings(serdes_node, "compatible");
+	for (i = 0; i < comp_no; i++) {
+		ret = of_property_read_string_index(serdes_node, "compatible",
+						    i, &serdes_comp);
+		if (ret == 0) {
+			if (!strcasecmp(serdes_comp, "serdes-10g")) {
+				serdes_type = SERDES_10G;
+				break;
+			} else if (!strcasecmp(serdes_comp, "serdes-28g")) {
+				serdes_type = SERDES_28G;
+				break;
+			}
+		}
+	}
+
+	if (serdes_type == SERDES_INVAL) {
+		bpdev_err(bpphy, "Unknown serdes-type\n");
+		return 0;
+	}
+
+	/* call generic driver parse DT */
+	ret = backplane_parse_dt(bpphy);
+	if (ret)
+		return ret;
+
+	/* call generic driver setup mdio */
+	ret = backplane_setup_mdio(bpphy);
+	if (ret)
+		return ret;
+
+	/* override default mdio setup and initialize lane ops */
+	switch (serdes_type) {
+	case SERDES_10G:
+		qoriq_setup_mdio_10g(&bp_phy->bp_dev);
+		lane_ops = qoriq_get_lane_ops_10g();
+		qoriq_setup_mem_io_10g(bp_phy->bp_dev.io);
+		equalizer = qoriq_get_equalizer_info_10g();
+		break;
+	case SERDES_28G:
+		qoriq_setup_mdio_28g(&bp_phy->bp_dev);
+		lane_ops = qoriq_get_lane_ops_28g();
+		qoriq_setup_mem_io_28g(bp_phy->bp_dev.io);
+		equalizer = qoriq_get_equalizer_info_28g();
+		break;
+	default:
+		bpdev_err(bpphy, "Serdes type not supported\n");
+		return -EINVAL;
+	}
+	if (!lane_ops) {
+		bpdev_err(bpphy, "Lane ops not available\n");
+		return -EINVAL;
+	}
+	if (!equalizer) {
+		bpdev_err(bpphy, "Equalizer not available\n");
+		return -EINVAL;
+	}
+
+	bp_phy->bp_dev.lane_ops = lane_ops;
+	bp_phy->bp_dev.equalizer = equalizer;
+	qoriq_lane = (struct qoriq_lane_ops *)lane_ops->priv;
+
+	/* install AN bp_eth_status decoding callback */
+	bp_phy->bp_dev.mdio.get_an_bp_eth_status_bit = get_an_bp_eth_status_bit;
+	bp_phy->bp_dev.mdio.get_an_ad_ability_1_init = get_an_ad_ability_1_init;
+
+	if (backplane_is_mode_kr(bp_phy->bp_mode)) {
+		/* setup coefficient limits */
+		bp_phy->bp_dev.cm_min = PRE_COEF_MIN;
+		bp_phy->bp_dev.cm_max = PRE_COEF_MAX;
+		bp_phy->bp_dev.cz_min = ZERO_COEF_MIN;
+		bp_phy->bp_dev.cz_max = ZERO_COEF_MAX;
+		bp_phy->bp_dev.cp_min = POST_COEF_MIN;
+		bp_phy->bp_dev.cp_max = POST_COEF_MAX;
+		bp_phy->bp_dev.sum_ratio_numer = COEF_SUM_RATIO_NUMERATOR;
+		bp_phy->bp_dev.sum_ratio_denom = COEF_SUM_RATIO_DENOMINATOR;
+	}
+
+	/* if eq-params node exists then use the DTS specified values
+	 * if eq-params node doesn't exist then use values already found in HW
+	 * eq-params is a custom node and variable in size
+	 */
+	proplen = of_property_count_u32_elems(bpphy_node, "eq-params");
+	if (proplen > 0) {
+		/* we use only 1 custom coefficient tap: amp_red */
+		if (proplen > EQ_PARAMS_NO)
+			proplen = EQ_PARAMS_NO;
+		ret = of_property_read_u32_array(bpphy_node, "eq-params",
+						 (u32 *)eqparams, proplen);
+		if (ret == 0) {
+			bp_phy->bp_dev.ampr_def_dt = true;
+			bp_phy->bp_dev.amp_red_def = eqparams[0];
+		}
+	}
+
+	/* call generic driver setup lanes */
+	ret = backplane_setup_lanes(bpphy);
+	if (ret)
+		return ret;
+
+	/* call generic driver initialize
+	 * start the lane timers used to run the algorithm
+	 */
+	ret = backplane_initialize(bpphy);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int qoriq_backplane_match_phy_device(struct phy_device *bpphy)
+{
+	struct device_node *bpphy_node, *serdes_node, *lane_node;
+	const char *serdes_comp;
+	int comp_no, i, ret;
+	int serdes_type = SERDES_INVAL;
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
+	/* Get Master lane node */
+	lane_node = of_parse_phandle(bpphy_node, "lane-handle", 0);
+	if (!lane_node)
+		return 0;
+	serdes_node = lane_node->parent;
+	of_node_put(lane_node);
+	if (!serdes_node)
+		return 0;
+
+	comp_no = of_property_count_strings(serdes_node, "compatible");
+	for (i = 0; i < comp_no; i++) {
+		ret = of_property_read_string_index(serdes_node, "compatible",
+						    i, &serdes_comp);
+		if (ret == 0) {
+			if (!strcasecmp(serdes_comp, "serdes-10g")) {
+				serdes_type = SERDES_10G;
+				break;
+			} else if (!strcasecmp(serdes_comp, "serdes-28g")) {
+				serdes_type = SERDES_28G;
+				break;
+			}
+		}
+	}
+
+	if (serdes_type == SERDES_INVAL) {
+		bpdev_err(bpphy, "Unknown serdes-type\n");
+		return 0;
+	}
+
+	switch (serdes_type) {
+	case SERDES_10G:
+		/* On LS devices we must find the c45 device with correct PHY ID
+		 * Implementation similar with the one existent in phy_device:
+		 * @function: phy_bus_match
+		 */
+		for (i = 1; i < ARRAY_SIZE(bpphy->c45_ids.device_ids); i++) {
+			if (!(bpphy->c45_ids.devices_in_package & (1 << i)))
+				continue;
+
+			if ((PCS_PHY_DEVICE_ID & PCS_PHY_DEVICE_ID_MASK) ==
+			    (bpphy->c45_ids.device_ids[i] &
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
+		 * val = phy_read_mmd(bpphy, MDIO_MMD_PCS, 0x2);
+		 * 3  03	Device_ID1  RO		Bits 31:16	0
+		 * val = phy_read_mmd(bpphy, MDIO_MMD_PCS, 0x3);
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
+		bpdev_err(bpphy, "Unknown serdes-type\n");
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
index 0000000..bbfdfb5
--- /dev/null
+++ b/drivers/net/phy/backplane/qoriq_backplane.h
@@ -0,0 +1,33 @@
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
+struct qoriq_lane_ops {
+	u32 (*read_tecr0)(void *reg);
+	u32 (*read_tecr1)(void *reg);
+};
+
+const struct lane_io_ops *qoriq_get_lane_ops_10g(void);
+const struct lane_io_ops *qoriq_get_lane_ops_28g(void);
+
+const struct equalizer_info *qoriq_get_equalizer_info_10g(void);
+const struct equalizer_info *qoriq_get_equalizer_info_28g(void);
+
+void qoriq_setup_mem_io_10g(struct mem_io_ops io);
+void qoriq_setup_mem_io_28g(struct mem_io_ops io);
+
+void qoriq_setup_mdio_10g(struct backplane_dev_info *bp_dev);
+void qoriq_setup_mdio_28g(struct backplane_dev_info *bp_dev);
+
+#endif /* __QORIQ_BACKPLANE_H */
diff --git a/drivers/net/phy/backplane/qoriq_serdes_10g.c b/drivers/net/phy/backplane/qoriq_serdes_10g.c
new file mode 100644
index 0000000..8ee7308
--- /dev/null
+++ b/drivers/net/phy/backplane/qoriq_serdes_10g.c
@@ -0,0 +1,470 @@
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
+#define AN_AD_ABILITY_0				0x10
+#define AN_AD_ABILITY_1				0x11
+#define AN_BP_ETH_STATUS_OFFSET			0x30
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
+static struct mem_io_ops io_ops;
+
+static void reset_lane(void __iomem *reg, enum lane_req ln_req)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+
+	/* reset Tx lane: send reset request */
+	if (ln_req | LANE_TX) {
+		io_ops.write32(io_ops.read32(&reg_base->gcr0) & ~GCR0_TRST_MASK,
+			       &reg_base->gcr0);
+	}
+	/* reset Rx lane: send reset request */
+	if (ln_req | LANE_RX) {
+		io_ops.write32(io_ops.read32(&reg_base->gcr0) & ~GCR0_RRST_MASK,
+			       &reg_base->gcr0);
+	}
+	/* unreset the lane */
+	if (ln_req != LANE_INVALID) {
+		udelay(1);
+		io_ops.write32(io_ops.read32(&reg_base->gcr0) | GCR0_RESET_MASK,
+			       &reg_base->gcr0);
+		udelay(1);
+	}
+}
+
+static u32 read_tecr0(void __iomem *reg)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+
+	return io_ops.read32(&reg_base->tecr0);
+}
+
+static u32 read_tecr1(void __iomem *reg)
+{
+	return 0;
+}
+
+static void read_tecr_params(void __iomem *reg, struct lane_kr_params *params)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	u32 val;
+
+	val = io_ops.read32(&reg_base->tecr0);
+
+	params->ratio_preq = (val & RATIO_PREQ_MASK) >> RATIO_PREQ_SHIFT;
+	params->ratio_pstq = (val & RATIO_PST1Q_MASK) >> RATIO_PST1Q_SHIFT;
+	params->adpt_eq = (val & ADPT_EQ_MASK) >> ADPT_EQ_SHIFT;
+	params->amp_red = (val & AMP_RED_MASK) >> AMP_RED_SHIFT;
+}
+
+static void setup_tecr(void __iomem *reg, struct lane_kr_params *params,
+		       bool reset)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	u32 val;
+
+	val = TECR0_INIT |
+		params->adpt_eq << ADPT_EQ_SHIFT |
+		params->ratio_preq << RATIO_PREQ_SHIFT |
+		params->ratio_pstq << RATIO_PST1Q_SHIFT |
+		params->amp_red << AMP_RED_SHIFT;
+
+	if (reset) {
+		/* reset the lane */
+		io_ops.write32(io_ops.read32(&reg_base->gcr0) &
+			       ~GCR0_RESET_MASK, &reg_base->gcr0);
+		udelay(1);
+	}
+
+	io_ops.write32(val, &reg_base->tecr0);
+	udelay(1);
+
+	if (reset) {
+		/* unreset the lane */
+		io_ops.write32(io_ops.read32(&reg_base->gcr0) | GCR0_RESET_MASK,
+			       &reg_base->gcr0);
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
+	u32 rx_eq_snp;
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	int timeout;
+	int i;
+
+	for (i = 0; i < size; i++) {
+		/* wait RECR1_CTL_SNP_DONE_MASK has cleared */
+		timeout = 100;
+		while (io_ops.read32(&reg_base->recr1) &
+		       RECR1_CTL_SNP_DONE_MASK) {
+			udelay(1);
+			timeout--;
+			if (timeout == 0)
+				break;
+		}
+
+		/* start snapshot */
+		io_ops.write32((io_ops.read32(&reg_base->gcr1) |
+				GCR1_CTL_SNP_START_MASK), &reg_base->gcr1);
+
+		/* wait for SNP done */
+		timeout = 100;
+		while (!(io_ops.read32(&reg_base->recr1) &
+		       RECR1_CTL_SNP_DONE_MASK)) {
+			udelay(1);
+			timeout--;
+			if (timeout == 0)
+				break;
+		}
+
+		/* read and save the snapshot */
+		rx_eq_snp = io_ops.read32(&reg_base->recr1);
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
+		io_ops.write32((io_ops.read32(&reg_base->gcr1) &
+			       ~GCR1_CTL_SNP_START_MASK), &reg_base->gcr1);
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
+	int bin_snapshot;
+	u32 bin_sel;
+	int i, timeout;
+	struct qoriq_lane_regs __iomem *reg_base = reg;
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
+		while ((io_ops.read32(&reg_base->recr1) &
+			RECR1_SNP_DONE_MASK)) {
+			udelay(1);
+			timeout--;
+			if (timeout == 0)
+				break;
+		}
+
+		/* set TCSR1[CDR_SEL] */
+		io_ops.write32((io_ops.read32(&reg_base->tcsr1) &
+				~CDR_SEL_MASK) | bin_sel, &reg_base->tcsr1);
+
+		/* start snapshot */
+		io_ops.write32(io_ops.read32(&reg_base->gcr1) |
+			       GCR1_SNP_START_MASK, &reg_base->gcr1);
+
+		/* wait for SNP done */
+		timeout = 100;
+		while (!(io_ops.read32(&reg_base->recr1) &
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
+		bin_snapshot = (io_ops.read32(&reg_base->tcsr1) &
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
+		io_ops.write32(io_ops.read32(&reg_base->gcr1) &
+			       ~GCR1_SNP_START_MASK, &reg_base->gcr1);
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
+	if (io_ops.read32(&reg_base->tcsr3) & TCSR3_CDR_LCK_MASK)
+		return true;
+
+	return false;
+}
+
+static const struct qoriq_lane_ops qoriq_lane = {
+	.read_tecr0 = read_tecr0,
+	.read_tecr1 = read_tecr1,
+};
+
+static const struct lane_io_ops lane_ops = {
+	.priv = &qoriq_lane,
+	.memmap_size = MEMORY_MAP_SIZE,
+	.reset_lane = reset_lane,
+	.tune_lane_kr = setup_tecr,
+	.read_lane_kr = read_tecr_params,
+	.is_cdr_lock = is_cdr_lock_bit,
+};
+
+const struct lane_io_ops *qoriq_get_lane_ops_10g(void)
+{
+	return &lane_ops;
+}
+
+static const struct equalizer_info equalizer = {
+	.name = EQUALIZER_NAME,
+	.version = EQUALIZER_VERSION,
+	.ops = {
+		.collect_counters = collect_bin_snapshots,
+		.collect_multiple_counters = collect_eq_status,
+		.get_counter_range = get_counter_range,
+	},
+};
+
+const struct equalizer_info *qoriq_get_equalizer_info_10g(void)
+{
+	return &equalizer;
+}
+
+void qoriq_setup_mem_io_10g(struct mem_io_ops io)
+{
+	io_ops = io;
+}
+
+void qoriq_setup_mdio_10g(struct backplane_dev_info *bp_dev)
+{
+	/* IEEE802.3 Clause 45 register spaces */
+
+	/* KR PMD registers */
+	backplane_setup_kr_lt_mmd(bp_dev, MDIO_MMD_PMAPMD, KR_PMD_BASE_OFFSET);
+
+	/* KX/KR AN registers: IEEE802.3 Clause 45 MMD 7 */
+	bp_dev->mdio.an_ad_ability_0 = AN_AD_ABILITY_0;
+	bp_dev->mdio.an_ad_ability_1 = AN_AD_ABILITY_1;
+	bp_dev->mdio.an_bp_eth_status = AN_BP_ETH_STATUS_OFFSET;
+}
diff --git a/drivers/net/phy/backplane/qoriq_serdes_28g.c b/drivers/net/phy/backplane/qoriq_serdes_28g.c
new file mode 100644
index 0000000..5d847a4
--- /dev/null
+++ b/drivers/net/phy/backplane/qoriq_serdes_28g.c
@@ -0,0 +1,533 @@
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
+#define AN_AD_ABILITY_0				0x02
+#define AN_AD_ABILITY_1				0x03
+#define AN_BP_ETH_STATUS_OFFSET			0x0F
+#define KR_PMD_BASE_OFFSET			0x100
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
+static struct mem_io_ops io_ops;
+
+static void reset_lane(void __iomem *reg, enum lane_req ln_req)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	u32 val;
+	u64 timeout;
+
+	/* reset Tx lane: send reset request */
+	if (ln_req | LANE_TX) {
+		io_ops.write32(io_ops.read32(&reg_base->trstctl) |
+			       RESET_REQ_MASK, &reg_base->trstctl);
+		udelay(1);
+		timeout = 10;
+		while (timeout--) {
+			val = io_ops.read32(&reg_base->trstctl);
+			if (!(val & RESET_REQ_MASK))
+				break;
+			usleep_range(5, 20);
+		}
+	}
+
+	/* reset Rx lane: send reset request */
+	if (ln_req | LANE_RX) {
+		io_ops.write32(io_ops.read32(&reg_base->rrstctl) |
+			       RESET_REQ_MASK, &reg_base->rrstctl);
+		udelay(1);
+		timeout = 10;
+		while (timeout--) {
+			val = io_ops.read32(&reg_base->rrstctl);
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
+	return io_ops.read32(&reg_base->tecr0);
+}
+
+static u32 read_tecr1(void __iomem *reg)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+
+	return io_ops.read32(&reg_base->tecr1);
+}
+
+static void read_tecr_params(void __iomem *reg, struct lane_kr_params *params)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	u32 val;
+
+	val = io_ops.read32(&reg_base->tecr0);
+	params->ratio_preq = (val & RATIO_PREQ_MASK) >> RATIO_PREQ_SHIFT;
+	params->ratio_pstq = (val & RATIO_PST1Q_MASK) >> RATIO_PST1Q_SHIFT;
+	params->amp_red = (val & AMP_RED_MASK) >> AMP_RED_SHIFT;
+
+	val = io_ops.read32(&reg_base->tecr1);
+	params->adpt_eq = (val & ADPT_EQ_MASK) >> ADPT_EQ_SHIFT;
+}
+
+static void setup_tecr(void __iomem *reg, struct lane_kr_params *params,
+		       bool reset)
+{
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	u32 val;
+
+	/* reset lanes */
+	if (reset)
+		reset_lane(reg, LANE_RX_TX);
+
+	val = TECR0_INIT |
+		params->ratio_preq << RATIO_PREQ_SHIFT |
+		params->ratio_pstq << RATIO_PST1Q_SHIFT |
+		params->amp_red << AMP_RED_SHIFT;
+	io_ops.write32(val, &reg_base->tecr0);
+
+	val = params->adpt_eq << ADPT_EQ_SHIFT;
+	io_ops.write32(val, &reg_base->tecr1);
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
+	u32 recr3, recr4;
+	struct qoriq_lane_regs __iomem *reg_base = reg;
+	int timeout;
+	int i;
+
+	/* Enable observation of SerDes status on all status registers */
+	io_ops.write32(io_ops.read32(&reg_base->tcsr0) |
+		       TCSR0_SD_STAT_OBS_EN_MASK, &reg_base->tcsr0);
+
+	for (i = 0; i < size; i++) {
+		/* wait RECR3_SNP_DONE_MASK has cleared */
+		timeout = 100;
+		while (io_ops.read32(&reg_base->recr3) & RECR3_SNP_DONE_MASK) {
+			udelay(1);
+			timeout--;
+			if (timeout == 0)
+				break;
+		}
+
+		/* start snapshot */
+		io_ops.write32((io_ops.read32(&reg_base->recr3) |
+				RECR3_SNP_START_MASK), &reg_base->recr3);
+
+		/* wait for SNP done */
+		timeout = 100;
+		while (!(io_ops.read32(&reg_base->recr3) &
+			 RECR3_SNP_DONE_MASK)) {
+			udelay(1);
+			timeout--;
+			if (timeout == 0)
+				break;
+		}
+
+		/* read and save the snapshot */
+		recr3 = io_ops.read32(&reg_base->recr3);
+		recr4 = io_ops.read32(&reg_base->recr4);
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
+		io_ops.write32((io_ops.read32(&reg_base->recr3) &
+				~RECR3_SNP_START_MASK), &reg_base->recr3);
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
+	int bin_snapshot;
+	u32 bin_sel;
+	int i, timeout;
+	struct qoriq_lane_regs __iomem *reg_base = reg;
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
+	io_ops.write32(io_ops.read32(&reg_base->tcsr0) |
+		       TCSR0_SD_STAT_OBS_EN_MASK, &reg_base->tcsr0);
+
+	for (i = 0; i < bin_size; i++) {
+		/* wait RECR3_SNP_DONE_MASK has cleared */
+		timeout = 100;
+		while ((io_ops.read32(&reg_base->recr3) &
+			RECR3_SNP_DONE_MASK)) {
+			udelay(1);
+			timeout--;
+			if (timeout == 0)
+				break;
+		}
+
+		/* set RECR4[EQ_BIN_DATA_SEL] */
+		io_ops.write32((io_ops.read32(&reg_base->recr4) &
+				~CDR_SEL_MASK) | bin_sel, &reg_base->recr4);
+
+		/* start snapshot */
+		io_ops.write32(io_ops.read32(&reg_base->recr3) |
+			       RECR3_SNP_START_MASK, &reg_base->recr3);
+
+		/* wait for SNP done */
+		timeout = 100;
+		while (!(io_ops.read32(&reg_base->recr3) &
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
+		bin_snapshot = (io_ops.read32(&reg_base->recr4) &
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
+		io_ops.write32(io_ops.read32(&reg_base->recr3) &
+			       ~RECR3_SNP_START_MASK, &reg_base->recr3);
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
+	if (io_ops.read32(&reg_base->rrstctl) & RRSTCTL_CDR_LOCK_MASK)
+		return true;
+
+	return false;
+}
+
+static const struct qoriq_lane_ops qoriq_lane = {
+	.read_tecr0 = read_tecr0,
+	.read_tecr1 = read_tecr1,
+};
+
+static const struct lane_io_ops lane_ops = {
+	.priv = &qoriq_lane,
+	.memmap_size = MEMORY_MAP_SIZE,
+	.reset_lane = reset_lane,
+	.tune_lane_kr = setup_tecr,
+	.read_lane_kr = read_tecr_params,
+	.is_cdr_lock = is_cdr_lock_bit,
+};
+
+const struct lane_io_ops *qoriq_get_lane_ops_28g(void)
+{
+	return &lane_ops;
+}
+
+static const struct equalizer_info equalizer = {
+	.name = EQUALIZER_NAME,
+	.version = EQUALIZER_VERSION,
+	.ops = {
+		.collect_counters = collect_bin_snapshots,
+		.collect_multiple_counters = collect_eq_status,
+		.get_counter_range = get_counter_range,
+	},
+};
+
+const struct equalizer_info *qoriq_get_equalizer_info_28g(void)
+{
+	return &equalizer;
+}
+
+void qoriq_setup_mem_io_28g(struct mem_io_ops io)
+{
+	io_ops = io;
+}
+
+void qoriq_setup_mdio_28g(struct backplane_dev_info *bp_dev)
+{
+	/* Auto-Negotiation and Link Training Core Registers:
+	 * IEEE802.3 Clauses 72, 73, 92
+	 */
+
+	/* Link Training Control and Status Registers: page 1: 0x100 */
+	backplane_setup_kr_lt_mmd(bp_dev, MDIO_MMD_AN, KR_PMD_BASE_OFFSET);
+
+	/* Auto-Negotiation Control and Status Registers: page 0 */
+	bp_dev->mdio.an_ad_ability_0 = AN_AD_ABILITY_0;
+	bp_dev->mdio.an_ad_ability_1 = AN_AD_ABILITY_1;
+	bp_dev->mdio.an_bp_eth_status = AN_BP_ETH_STATUS_OFFSET;
+}
-- 
1.9.1

