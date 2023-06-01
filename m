Return-Path: <netdev+bounces-6965-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14AB571910A
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF2C028110B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 03:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162781FDB;
	Thu,  1 Jun 2023 03:10:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0600B1FB2
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 03:10:31 +0000 (UTC)
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4951A132
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 20:10:05 -0700 (PDT)
X-QQ-mid: bizesmtp86t1685588636tp18zgb9
Received: from wxdbg.localdomain.com ( [183.159.96.128])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 01 Jun 2023 11:03:51 +0800 (CST)
X-QQ-SSF: 01400000000000J0Z000000A0000000
X-QQ-FEAT: l1AKOOPZQseDl74Xrtn4rIrnIIm5ieYDwoGZUiczcgY4VpN1J/g/e5903KIXc
	uVcJ45yBlu099MXmukrW3zF2YRV6SxjwK2JoCPJgEBzENXENkAsmAv6Zs4BjDmbxvALc8Co
	/JGz08FcsrVApp9yFXGPM9THUgexihQHiRkaNZDOCLi2a7mGULvV/08pxEh2c0aol/d7/JW
	zTTO3ZhEp9HTEs1mSQ/OqB1ffJoA1mMS64XMYrxQzSxSu53Y0IfMWXZBwXywTIEb9vamDbV
	4bXHdguLcJygsofYG9PrZy4Kj1XBoYBUSi+dLzj9Kuza4gl14iNubWA0CNUvfzpej2kRzE3
	OeVYhNNEIm+U0jCl3HrqrXxR8Vjcd8T95nrSSrn8UBPm4P3/W5Shcof4oUq1TXm3lb3vgo0
	SLWvYMpj8puCXP/q9F6nWda8gu9csLHr
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 5402096642234420979
From: Jiawen Wu <jiawenwu@trustnetic.com>
To: netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com,
	jsd@semihalf.com,
	Jose.Abreu@synopsys.com,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk
Cc: linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	mengyuanlou@net-swift.com,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Piotr Raczynski <piotr.raczynski@intel.com>
Subject: [PATCH net-next v10 1/9] net: txgbe: Add software nodes to support phylink
Date: Thu,  1 Jun 2023 11:01:32 +0800
Message-Id: <20230601030140.687493-2-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230601030140.687493-1-jiawenwu@trustnetic.com>
References: <20230601030140.687493-1-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Register software nodes for GPIO, I2C, SFP and PHYLINK. Define the
device properties.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  1 +
 drivers/net/ethernet/wangxun/txgbe/Makefile   |  1 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 22 ++++-
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 89 +++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_phy.h    | 10 +++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 49 ++++++++++
 6 files changed, 171 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index cbe7f184b50e..f59066d7375c 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -611,6 +611,7 @@ enum wx_isb_idx {
 
 struct wx {
 	u8 __iomem *hw_addr;
+	void *priv;
 	struct pci_dev *pdev;
 	struct net_device *netdev;
 	struct wx_bus_info bus;
diff --git a/drivers/net/ethernet/wangxun/txgbe/Makefile b/drivers/net/ethernet/wangxun/txgbe/Makefile
index 6db14a2cb2d0..7507f762edfe 100644
--- a/drivers/net/ethernet/wangxun/txgbe/Makefile
+++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
@@ -8,4 +8,5 @@ obj-$(CONFIG_TXGBE) += txgbe.o
 
 txgbe-objs := txgbe_main.o \
               txgbe_hw.o \
+              txgbe_phy.o \
               txgbe_ethtool.o
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 5b8a121fb496..e10296abf5b4 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -15,6 +15,7 @@
 #include "../libwx/wx_hw.h"
 #include "txgbe_type.h"
 #include "txgbe_hw.h"
+#include "txgbe_phy.h"
 #include "txgbe_ethtool.h"
 
 char txgbe_driver_name[] = "txgbe";
@@ -513,6 +514,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	struct net_device *netdev;
 	int err, expected_gts;
 	struct wx *wx = NULL;
+	struct txgbe *txgbe;
 
 	u16 eeprom_verh = 0, eeprom_verl = 0, offset = 0;
 	u16 eeprom_cfg_blkh = 0, eeprom_cfg_blkl = 0;
@@ -663,10 +665,23 @@ static int txgbe_probe(struct pci_dev *pdev,
 			 "0x%08x", etrack_id);
 	}
 
-	err = register_netdev(netdev);
+	txgbe = devm_kzalloc(&pdev->dev, sizeof(*txgbe), GFP_KERNEL);
+	if (!txgbe) {
+		err = -ENOMEM;
+		goto err_release_hw;
+	}
+
+	txgbe->wx = wx;
+	wx->priv = txgbe;
+
+	err = txgbe_init_phy(txgbe);
 	if (err)
 		goto err_release_hw;
 
+	err = register_netdev(netdev);
+	if (err)
+		goto err_remove_phy;
+
 	pci_set_drvdata(pdev, wx);
 
 	netif_tx_stop_all_queues(netdev);
@@ -694,6 +709,8 @@ static int txgbe_probe(struct pci_dev *pdev,
 
 	return 0;
 
+err_remove_phy:
+	txgbe_remove_phy(txgbe);
 err_release_hw:
 	wx_clear_interrupt_scheme(wx);
 	wx_control_hw(wx, false);
@@ -719,11 +736,14 @@ static int txgbe_probe(struct pci_dev *pdev,
 static void txgbe_remove(struct pci_dev *pdev)
 {
 	struct wx *wx = pci_get_drvdata(pdev);
+	struct txgbe *txgbe = wx->priv;
 	struct net_device *netdev;
 
 	netdev = wx->netdev;
 	unregister_netdev(netdev);
 
+	txgbe_remove_phy(txgbe);
+
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
new file mode 100644
index 000000000000..be4b5ad74a3c
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
+
+#include <linux/gpio/property.h>
+#include <linux/i2c.h>
+#include <linux/pci.h>
+
+#include "../libwx/wx_type.h"
+#include "txgbe_type.h"
+#include "txgbe_phy.h"
+
+static int txgbe_swnodes_register(struct txgbe *txgbe)
+{
+	struct txgbe_nodes *nodes = &txgbe->nodes;
+	struct pci_dev *pdev = txgbe->wx->pdev;
+	struct software_node *swnodes;
+	u32 id;
+
+	id = (pdev->bus->number << 8) | pdev->devfn;
+
+	snprintf(nodes->gpio_name, sizeof(nodes->gpio_name), "txgbe_gpio-%x", id);
+	snprintf(nodes->i2c_name, sizeof(nodes->i2c_name), "txgbe_i2c-%x", id);
+	snprintf(nodes->sfp_name, sizeof(nodes->sfp_name), "txgbe_sfp-%x", id);
+	snprintf(nodes->phylink_name, sizeof(nodes->phylink_name), "txgbe_phylink-%x", id);
+
+	swnodes = nodes->swnodes;
+
+	/* GPIO 0: tx fault
+	 * GPIO 1: tx disable
+	 * GPIO 2: sfp module absent
+	 * GPIO 3: rx signal lost
+	 * GPIO 4: rate select, 1G(0) 10G(1)
+	 * GPIO 5: rate select, 1G(0) 10G(1)
+	 */
+	nodes->gpio_props[0] = PROPERTY_ENTRY_STRING("pinctrl-names", "default");
+	swnodes[SWNODE_GPIO] = NODE_PROP(nodes->gpio_name, nodes->gpio_props);
+	nodes->gpio0_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 0, GPIO_ACTIVE_HIGH);
+	nodes->gpio1_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 1, GPIO_ACTIVE_HIGH);
+	nodes->gpio2_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 2, GPIO_ACTIVE_LOW);
+	nodes->gpio3_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 3, GPIO_ACTIVE_HIGH);
+	nodes->gpio4_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 4, GPIO_ACTIVE_HIGH);
+	nodes->gpio5_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_GPIO], 5, GPIO_ACTIVE_HIGH);
+
+	nodes->i2c_props[0] = PROPERTY_ENTRY_STRING("compatible", "snps,designware-i2c");
+	nodes->i2c_props[1] = PROPERTY_ENTRY_BOOL("wx,i2c-snps-model");
+	nodes->i2c_props[2] = PROPERTY_ENTRY_U32("clock-frequency", I2C_MAX_STANDARD_MODE_FREQ);
+	swnodes[SWNODE_I2C] = NODE_PROP(nodes->i2c_name, nodes->i2c_props);
+	nodes->i2c_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_I2C]);
+
+	nodes->sfp_props[0] = PROPERTY_ENTRY_STRING("compatible", "sff,sfp");
+	nodes->sfp_props[1] = PROPERTY_ENTRY_REF_ARRAY("i2c-bus", nodes->i2c_ref);
+	nodes->sfp_props[2] = PROPERTY_ENTRY_REF_ARRAY("tx-fault-gpios", nodes->gpio0_ref);
+	nodes->sfp_props[3] = PROPERTY_ENTRY_REF_ARRAY("tx-disable-gpios", nodes->gpio1_ref);
+	nodes->sfp_props[4] = PROPERTY_ENTRY_REF_ARRAY("mod-def0-gpios", nodes->gpio2_ref);
+	nodes->sfp_props[5] = PROPERTY_ENTRY_REF_ARRAY("los-gpios", nodes->gpio3_ref);
+	nodes->sfp_props[6] = PROPERTY_ENTRY_REF_ARRAY("rate-select1-gpios", nodes->gpio4_ref);
+	nodes->sfp_props[7] = PROPERTY_ENTRY_REF_ARRAY("rate-select0-gpios", nodes->gpio5_ref);
+	swnodes[SWNODE_SFP] = NODE_PROP(nodes->sfp_name, nodes->sfp_props);
+	nodes->sfp_ref[0] = SOFTWARE_NODE_REFERENCE(&swnodes[SWNODE_SFP]);
+
+	nodes->phylink_props[0] = PROPERTY_ENTRY_STRING("managed", "in-band-status");
+	nodes->phylink_props[1] = PROPERTY_ENTRY_REF_ARRAY("sfp", nodes->sfp_ref);
+	swnodes[SWNODE_PHYLINK] = NODE_PROP(nodes->phylink_name, nodes->phylink_props);
+
+	nodes->group[SWNODE_GPIO] = &swnodes[SWNODE_GPIO];
+	nodes->group[SWNODE_I2C] = &swnodes[SWNODE_I2C];
+	nodes->group[SWNODE_SFP] = &swnodes[SWNODE_SFP];
+	nodes->group[SWNODE_PHYLINK] = &swnodes[SWNODE_PHYLINK];
+
+	return software_node_register_node_group(nodes->group);
+}
+
+int txgbe_init_phy(struct txgbe *txgbe)
+{
+	int ret;
+
+	ret = txgbe_swnodes_register(txgbe);
+	if (ret) {
+		wx_err(txgbe->wx, "failed to register software nodes\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+void txgbe_remove_phy(struct txgbe *txgbe)
+{
+	software_node_unregister_node_group(txgbe->nodes.group);
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
new file mode 100644
index 000000000000..1ab592124986
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _TXGBE_PHY_H_
+#define _TXGBE_PHY_H_
+
+int txgbe_init_phy(struct txgbe *txgbe);
+void txgbe_remove_phy(struct txgbe *txgbe);
+
+#endif /* _TXGBE_NODE_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 63a1c733718d..5bef0f9df523 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -4,6 +4,8 @@
 #ifndef _TXGBE_TYPE_H_
 #define _TXGBE_TYPE_H_
 
+#include <linux/property.h>
+
 /* Device IDs */
 #define TXGBE_DEV_ID_SP1000                     0x1001
 #define TXGBE_DEV_ID_WX1820                     0x2001
@@ -99,4 +101,51 @@
 
 extern char txgbe_driver_name[];
 
+static inline struct txgbe *netdev_to_txgbe(struct net_device *netdev)
+{
+	struct wx *wx = netdev_priv(netdev);
+
+	return wx->priv;
+}
+
+#define NODE_PROP(_NAME, _PROP)			\
+	(const struct software_node) {		\
+		.name = _NAME,			\
+		.properties = _PROP,		\
+	}
+
+enum txgbe_swnodes {
+	SWNODE_GPIO = 0,
+	SWNODE_I2C,
+	SWNODE_SFP,
+	SWNODE_PHYLINK,
+	SWNODE_MAX
+};
+
+struct txgbe_nodes {
+	char gpio_name[32];
+	char i2c_name[32];
+	char sfp_name[32];
+	char phylink_name[32];
+	struct property_entry gpio_props[1];
+	struct property_entry i2c_props[3];
+	struct property_entry sfp_props[8];
+	struct property_entry phylink_props[2];
+	struct software_node_ref_args i2c_ref[1];
+	struct software_node_ref_args gpio0_ref[1];
+	struct software_node_ref_args gpio1_ref[1];
+	struct software_node_ref_args gpio2_ref[1];
+	struct software_node_ref_args gpio3_ref[1];
+	struct software_node_ref_args gpio4_ref[1];
+	struct software_node_ref_args gpio5_ref[1];
+	struct software_node_ref_args sfp_ref[1];
+	struct software_node swnodes[SWNODE_MAX];
+	const struct software_node *group[SWNODE_MAX + 1];
+};
+
+struct txgbe {
+	struct wx *wx;
+	struct txgbe_nodes nodes;
+};
+
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0


