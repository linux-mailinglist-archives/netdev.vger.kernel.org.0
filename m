Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23475695EB9
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbjBNJRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbjBNJRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:17:17 -0500
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D55DBD9
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 01:15:46 -0800 (PST)
X-QQ-mid: bizesmtp67t1676366140trk2v574
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 14 Feb 2023 17:15:29 +0800 (CST)
X-QQ-SSF: 01400000000000N0P000000A0000000
X-QQ-FEAT: kN2ypXZVqgwpxf2VLpZd6uKzZdRKwoYWWTdgglXD5xRz+IxPBJl+4RTHe+dDf
        CwuBKRcPOGvDPvIJBTT7lproxlkZR+CM8/fCeLuaTkebS64ui34F8Se5fY02Pk3D5PczQ3l
        yOgF8AeU5AqfxIH7qfuyYG6auAYbtVB1/0IbNIjDh/vCf2uzCzMoME4SDNE0eXUUOYAqfbk
        R1Gq6qkAA11fwalX7DETu6E2vslCNKy75/G29b7Pn/BkaqWCfxpjd6nlIiDqv2TAHtiNEFq
        zXvegT3ZRZ5emvrZ7ksyiJervvvLkOoFt17iuvqDOU4fyV+vTTQ8lK4gKV3VnI+JFFIBlTu
        RciBT7ReyVsqPjZ3l+TDyHZeQz4H6FwUzQuDHDfUb3h/wWo5zQ/xSG48rZH+GDmeFFiN6so
        UttTgwBlkMOqIiYqpWjsUD0V6RI6DxK0
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v3] net: wangxun: Add the basic ethtool interfaces
Date:   Tue, 14 Feb 2023 17:15:27 +0800
Message-Id: <20230214091527.69943-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the basic ethtool ops get_drvinfo and get_link for ngbe and txgbe.
Ngbe implements get_link_ksettings, nway_reset and set_link_ksettings
for free using phylib code.
The code related to the physical interface is not yet fully implemented
in txgbe using phylink code. So do not implement get_link_ksettings,
nway_reset and set_link_ksettings in txgbe.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
Change log:
v3:
- Andrew Lunn: https://lore.kernel.org/netdev/Y+o%2FtViZOC6htfqS@lunn.ch/
v2:
- Remove dot in the patch subject.
- Remove MODULE_LICENSE() in wx_ethtool.c

 drivers/net/ethernet/wangxun/libwx/Makefile   |  2 +-
 .../net/ethernet/wangxun/libwx/wx_ethtool.c   | 18 +++++++++++++++
 .../net/ethernet/wangxun/libwx/wx_ethtool.h   |  8 +++++++
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  1 +
 drivers/net/ethernet/wangxun/ngbe/Makefile    |  2 +-
 .../net/ethernet/wangxun/ngbe/ngbe_ethtool.c  | 22 +++++++++++++++++++
 .../net/ethernet/wangxun/ngbe/ngbe_ethtool.h  |  9 ++++++++
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  5 +++++
 drivers/net/ethernet/wangxun/txgbe/Makefile   |  3 ++-
 .../ethernet/wangxun/txgbe/txgbe_ethtool.c    | 19 ++++++++++++++++
 .../ethernet/wangxun/txgbe/txgbe_ethtool.h    |  9 ++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  3 +++
 12 files changed, 98 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_ethtool.c
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_ethtool.h
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.h
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.h

diff --git a/drivers/net/ethernet/wangxun/libwx/Makefile b/drivers/net/ethernet/wangxun/libwx/Makefile
index 850d1615cd18..42ccd6e4052e 100644
--- a/drivers/net/ethernet/wangxun/libwx/Makefile
+++ b/drivers/net/ethernet/wangxun/libwx/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_LIBWX) += libwx.o
 
-libwx-objs := wx_hw.o wx_lib.o
+libwx-objs := wx_hw.o wx_lib.o wx_ethtool.o
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_ethtool.c b/drivers/net/ethernet/wangxun/libwx/wx_ethtool.c
new file mode 100644
index 000000000000..93cb6f2294e7
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/libwx/wx_ethtool.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
+
+#include <linux/pci.h>
+#include <linux/phy.h>
+
+#include "wx_type.h"
+#include "wx_ethtool.h"
+
+void wx_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *info)
+{
+	struct wx *wx = netdev_priv(netdev);
+
+	strscpy(info->driver, wx->driver_name, sizeof(info->driver));
+	strscpy(info->fw_version, wx->eeprom_id, sizeof(info->fw_version));
+	strscpy(info->bus_info, pci_name(wx->pdev), sizeof(info->bus_info));
+}
+EXPORT_SYMBOL(wx_get_drvinfo);
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_ethtool.h b/drivers/net/ethernet/wangxun/libwx/wx_ethtool.h
new file mode 100644
index 000000000000..e85538c69454
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/libwx/wx_ethtool.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _WX_ETHTOOL_H_
+#define _WX_ETHTOOL_H_
+
+void wx_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *info);
+#endif /* _WX_ETHTOOL_H_ */
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index eede93d4120d..77d8d7f1707e 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -633,6 +633,7 @@ struct wx {
 	bool adapter_stopped;
 	u16 tpid[8];
 	char eeprom_id[32];
+	char *driver_name;
 	enum wx_reset_type reset_type;
 
 	/* PHY stuff */
diff --git a/drivers/net/ethernet/wangxun/ngbe/Makefile b/drivers/net/ethernet/wangxun/ngbe/Makefile
index 50fdca87d2a5..61a13d98abe7 100644
--- a/drivers/net/ethernet/wangxun/ngbe/Makefile
+++ b/drivers/net/ethernet/wangxun/ngbe/Makefile
@@ -6,4 +6,4 @@
 
 obj-$(CONFIG_NGBE) += ngbe.o
 
-ngbe-objs := ngbe_main.o ngbe_hw.o ngbe_mdio.o
+ngbe-objs := ngbe_main.o ngbe_hw.o ngbe_mdio.o ngbe_ethtool.o
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c
new file mode 100644
index 000000000000..5b25834baf38
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
+
+#include <linux/pci.h>
+#include <linux/phy.h>
+#include <linux/netdevice.h>
+
+#include "../libwx/wx_ethtool.h"
+#include "ngbe_ethtool.h"
+
+static const struct ethtool_ops ngbe_ethtool_ops = {
+	.get_drvinfo		= wx_get_drvinfo,
+	.get_link		= ethtool_op_get_link,
+	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
+	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
+	.nway_reset		= phy_ethtool_nway_reset,
+};
+
+void ngbe_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &ngbe_ethtool_ops;
+}
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.h
new file mode 100644
index 000000000000..487074e0eeec
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _NGBE_ETHTOOL_H_
+#define _NGBE_ETHTOOL_H_
+
+void ngbe_set_ethtool_ops(struct net_device *netdev);
+
+#endif /* _NGBE_ETHTOOL_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index f94d415daf3c..5b564d348c09 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -17,6 +17,7 @@
 #include "ngbe_type.h"
 #include "ngbe_mdio.h"
 #include "ngbe_hw.h"
+#include "ngbe_ethtool.h"
 
 char ngbe_driver_name[] = "ngbe";
 
@@ -546,6 +547,8 @@ static int ngbe_probe(struct pci_dev *pdev,
 		goto err_pci_release_regions;
 	}
 
+	wx->driver_name = ngbe_driver_name;
+	ngbe_set_ethtool_ops(netdev);
 	netdev->netdev_ops = &ngbe_netdev_ops;
 
 	netdev->features |= NETIF_F_HIGHDMA;
@@ -631,6 +634,8 @@ static int ngbe_probe(struct pci_dev *pdev,
 		etrack_id |= e2rom_ver;
 		wr32(wx, NGBE_EEPROM_VERSION_STORE_REG, etrack_id);
 	}
+	snprintf(wx->eeprom_id, sizeof(wx->eeprom_id),
+		 "0x%08x", etrack_id);
 
 	eth_hw_addr_set(netdev, wx->mac.perm_addr);
 	wx_mac_set_default_filter(wx, wx->mac.perm_addr);
diff --git a/drivers/net/ethernet/wangxun/txgbe/Makefile b/drivers/net/ethernet/wangxun/txgbe/Makefile
index 78484c58b78b..6db14a2cb2d0 100644
--- a/drivers/net/ethernet/wangxun/txgbe/Makefile
+++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
@@ -7,4 +7,5 @@
 obj-$(CONFIG_TXGBE) += txgbe.o
 
 txgbe-objs := txgbe_main.o \
-              txgbe_hw.o
+              txgbe_hw.o \
+              txgbe_ethtool.o
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
new file mode 100644
index 000000000000..d914e9a05404
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
+
+#include <linux/pci.h>
+#include <linux/phylink.h>
+#include <linux/netdevice.h>
+
+#include "../libwx/wx_ethtool.h"
+#include "txgbe_ethtool.h"
+
+static const struct ethtool_ops txgbe_ethtool_ops = {
+	.get_drvinfo		= wx_get_drvinfo,
+	.get_link		= ethtool_op_get_link,
+};
+
+void txgbe_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &txgbe_ethtool_ops;
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.h
new file mode 100644
index 000000000000..ace1b3571012
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _TXGBE_ETHTOOL_H_
+#define _TXGBE_ETHTOOL_H_
+
+void txgbe_set_ethtool_ops(struct net_device *netdev);
+
+#endif /* _TXGBE_ETHTOOL_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 094df377726b..6c0a98230557 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -15,6 +15,7 @@
 #include "../libwx/wx_hw.h"
 #include "txgbe_type.h"
 #include "txgbe_hw.h"
+#include "txgbe_ethtool.h"
 
 char txgbe_driver_name[] = "txgbe";
 
@@ -565,6 +566,8 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_pci_release_regions;
 	}
 
+	wx->driver_name = txgbe_driver_name;
+	txgbe_set_ethtool_ops(netdev);
 	netdev->netdev_ops = &txgbe_netdev_ops;
 
 	/* setup the private structure */
-- 
2.39.1

