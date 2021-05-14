Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D06380E7E
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 18:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbhENQ57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 12:57:59 -0400
Received: from smtp-35.italiaonline.it ([213.209.10.35]:41471 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234132AbhENQ55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 12:57:57 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([95.244.94.151])
        by smtp-35.iol.local with ESMTPA
        id hb71lnNVxpK9whb7ClGVus; Fri, 14 May 2021 18:56:43 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1621011403; bh=AAxdpDAGIheU42+js5PRE6fngpSAcqK3CS9FObKPdH4=;
        h=From;
        b=o/IAbiMKmEBCibPtxcnFHvatWqvyUt7aQa1xnH+FBQ0d3rF1c4+9PduiYBUZfIZpI
         pG634ZrXc5GD0VnFKQKwqA/BfQWCpZlc4UVI/pHyqdTHvhZm0vV5My0fNxLS+1Uh1e
         NKhzli1eEa2G4ZKdg25GVPn9h4JCGWr7agcvYCv5EBx7NUBVX6wOCJfhgFRwfehglJ
         KoXyo5rXvR5EZnsdhgqw5ROJICw0dnKODVLXm3e1Zhj7fsiIwWw3PqzjAJ0OApGOn9
         NP90PyLpVxrB8eH+8diFwJjifLY1tL3bXbYYctLhh6GHFhA8wtn8uAKQbukI04FDp7
         XfoyMwX5v2lRg==
X-CNFS-Analysis: v=2.4 cv=A9ipg4aG c=1 sm=1 tr=0 ts=609eabcb cx=a_exe
 a=ugxisoNCKEotYwafST++Mw==:117 a=ugxisoNCKEotYwafST++Mw==:17
 a=yyVY4NiJcYN5In7vbeEA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Dario Binacchi <dariobin@libero.it>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 1/2] can: c_can: add ethtool support
Date:   Fri, 14 May 2021 18:55:47 +0200
Message-Id: <20210514165549.14365-2-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
X-CMAE-Envelope: MS4xfM7E/gWTEIfUfv3PDC31pTXWqckLxjTRdWPavjCgjf398zWb8xbUC9+GETLaqKDOqKY0m6gmO83mER6kocP/uRsBcUwTACe1g64ZRiKZNug3Nqb+KL/F
 ucfBaN5xbHb/M75/cu7n6RyaD+u/1jQ6zsvhA4bfifH2nU0b5blt5waH5iPJYv2w/rU9puYVPTjD3M+XPAdnXq1MD+YcV37R860QP9nMuhFMybMgq0DJNFET
 u3xwHISVgGNbfpuyxpJBBrtGdSKUvpy9ZAQGv/8tCvlLKjAk2sfyOEf//0l+8pShw9uGhjGQ3nbPBxNOj0iKVXGBRCMx65VpPNeL1vz8c0mAF3dwk4XZAJa+
 Di3tGPfD70cie92bLzcvb3vJ2hcVFF6kjMvgb0+xXOvmtK1B02FE72DTFjnSMGPIq/6gbnmeP7z9LuNRzcomxOp1ABTJVS9ledCn66gySmz1AcbCJXdSfF+I
 eYnHvlaW4AchfZ46qfZpp2N2P2vJ6HtvKIpgiuenFSjnUgmXYLQh94IAYk+UVqB2zB6CIRc3PQgRD0Y4soGcHYQS972dFnoFwUFotqHQG5XHQ+H7LTTYp+rp
 vTjKDKDLcJWGV+FYEi975QaqBeVuhLqkTB3g6sDrBWMARQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With commit 132f2d45fb23 ("can: c_can: add support to 64 message objects")
the number of message objects used for reception / transmission depends
on FIFO size.
The ethtools API support allows you to retrieve this info. Driver info
has been added too.

Signed-off-by: Dario Binacchi <dariobin@libero.it>

---

Changes in v3:
- Remove the version info so that ethtool will return the version of the
  kernel the driver is actually being used in.

Changes in v2:
- Use get_ringparam instead of get_channels.

 drivers/net/can/c_can/Makefile                |  3 ++
 drivers/net/can/c_can/c_can.h                 |  2 +
 drivers/net/can/c_can/c_can_ethtool.c         | 43 +++++++++++++++++++
 .../net/can/c_can/{c_can.c => c_can_main.c}   |  1 +
 4 files changed, 49 insertions(+)
 create mode 100644 drivers/net/can/c_can/c_can_ethtool.c
 rename drivers/net/can/c_can/{c_can.c => c_can_main.c} (99%)

diff --git a/drivers/net/can/c_can/Makefile b/drivers/net/can/c_can/Makefile
index e6a94c948531..ac2bca39d6ff 100644
--- a/drivers/net/can/c_can/Makefile
+++ b/drivers/net/can/c_can/Makefile
@@ -4,5 +4,8 @@
 #
 
 obj-$(CONFIG_CAN_C_CAN) += c_can.o
+
+c_can-objs := c_can_main.o c_can_ethtool.o
+
 obj-$(CONFIG_CAN_C_CAN_PLATFORM) += c_can_platform.o
 obj-$(CONFIG_CAN_C_CAN_PCI) += c_can_pci.o
diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 06045f610f0e..f9001072514a 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -219,4 +219,6 @@ int c_can_power_up(struct net_device *dev);
 int c_can_power_down(struct net_device *dev);
 #endif
 
+void c_can_set_ethtool_ops(struct net_device *dev);
+
 #endif /* C_CAN_H */
diff --git a/drivers/net/can/c_can/c_can_ethtool.c b/drivers/net/can/c_can/c_can_ethtool.c
new file mode 100644
index 000000000000..6e50308c3aac
--- /dev/null
+++ b/drivers/net/can/c_can/c_can_ethtool.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2021, Dario Binacchi <dariobin@libero.it>
+ */
+
+#include <linux/ethtool.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/netdevice.h>
+#include <linux/can/dev.h>
+
+#include "c_can.h"
+
+static void c_can_get_drvinfo(struct net_device *netdev,
+			      struct ethtool_drvinfo *info)
+{
+	struct c_can_priv *priv = netdev_priv(netdev);
+	struct platform_device	*pdev = to_platform_device(priv->device);
+
+	strscpy(info->driver, "c_can", sizeof(info->driver));
+	strscpy(info->bus_info, pdev->name, sizeof(info->bus_info));
+}
+
+static void c_can_get_ringparam(struct net_device *netdev,
+				struct ethtool_ringparam *ring)
+{
+	struct c_can_priv *priv = netdev_priv(netdev);
+
+	ring->rx_max_pending = priv->msg_obj_num;
+	ring->tx_max_pending = priv->msg_obj_num;
+	ring->rx_pending = priv->msg_obj_rx_num;
+	ring->tx_pending = priv->msg_obj_tx_num;
+}
+
+static const struct ethtool_ops c_can_ethtool_ops = {
+	.get_drvinfo = c_can_get_drvinfo,
+	.get_ringparam = c_can_get_ringparam,
+};
+
+void c_can_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &c_can_ethtool_ops;
+}
diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can_main.c
similarity index 99%
rename from drivers/net/can/c_can/c_can.c
rename to drivers/net/can/c_can/c_can_main.c
index 313793f6922d..1903b87d5384 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -1335,6 +1335,7 @@ int register_c_can_dev(struct net_device *dev)
 
 	dev->flags |= IFF_ECHO;	/* we support local echo */
 	dev->netdev_ops = &c_can_netdev_ops;
+	c_can_set_ethtool_ops(dev);
 
 	err = register_candev(dev);
 	if (!err)
-- 
2.17.1

