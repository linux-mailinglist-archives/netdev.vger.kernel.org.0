Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A336A76F4
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfICW2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:28:51 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36771 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfICW2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:28:49 -0400
Received: by mail-pl1-f194.google.com with SMTP id f19so8575264plr.3
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 15:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=pLIYFGoy4p8zPQJKC2Xalx8RGOzgQIbdzMJ16uNACuc=;
        b=Er90KsGT+n8uf+GfNx/S/kpfLdnkScDUUEc1X3rmFyBlpODxvzAsr2Ib52n+qUItmm
         eRsQSTkWJV9OxHuF2MGHVyTiL4pdPE4sIYPC0x76azXxYzetTPQNUchgYp14leR9lRQZ
         JXx59UyE5jw37SCUNx6HDXfLAyCNCIa0n7A0O8Gk7G8XsenTUvogSOECE42AwOiWZpg2
         5beFhqvDfNZpO5/IRYI6ztJLpNJDedxgPIO4x5+veb9Ormnic/rTdhL6KwqcvYHjPsqz
         WuDxGeuXxjT0PFcV8wgqROz4egHyl7fJHN2ecXJiSCG6i9wxbcEgModj+diJNf0W5jtE
         kdvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=pLIYFGoy4p8zPQJKC2Xalx8RGOzgQIbdzMJ16uNACuc=;
        b=MimAdWkhG0Fn4h06sunDtO84wY9TMcnnMOz2X8mkjdNIYoi7wZeaPMicBlDbZ6Skm1
         GThRGHOxrBWq3StFhmJmAqi6FCsoq4HxF5n9e3CFSlJz+ZqKfJmuGgStkHhfT/VY/ehv
         YFybzPgvXMd3idmz/Tn1Bd1dNkX1wbyu800vOBYWvOQfZCXLOe1goYDs6P/WJJ9bqKgU
         PawD658ty1l9DVhIk6dbG7qQ0paNOlKBDdoyNQWU3gndoJ/nX0DLQPd4Plml1pUgssjM
         M1az5nlCLfCx1OQE9or/ybqvepq3F4JGMd7uY73HMBPGsoJO/bSSEypJnRS6CFriAex4
         j1Mg==
X-Gm-Message-State: APjAAAXb1ISbLuXWp8fHbi/msONdaCIyesinQNQd4ESk/4CfqzrAB4i9
        e0JlZh3J1CsVuz7dEXW5LpSXdg==
X-Google-Smtp-Source: APXvYqyVTi10F9GxHiq2CBo2WcYTykm3tUsDYdWEhvGvAAxJ9suk+PSAiyz2++uj4sHSp5+s2tH1sw==
X-Received: by 2002:a17:902:4d45:: with SMTP id o5mr37905803plh.146.1567549728284;
        Tue, 03 Sep 2019 15:28:48 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id e17sm520520pjt.6.2019.09.03.15.28.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 15:28:47 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v7 net-next 02/19] ionic: Add basic framework for IONIC Network device driver
Date:   Tue,  3 Sep 2019 15:28:04 -0700
Message-Id: <20190903222821.46161-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903222821.46161-1-snelson@pensando.io>
References: <20190903222821.46161-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a basic driver framework for the Pensando IONIC
network device.  There is no functionality right now other than
the ability to load and unload.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../networking/device_drivers/index.rst       |  1 +
 .../device_drivers/pensando/ionic.rst         | 43 ++++++++++++++
 MAINTAINERS                                   |  8 +++
 drivers/net/ethernet/Kconfig                  |  1 +
 drivers/net/ethernet/Makefile                 |  1 +
 drivers/net/ethernet/pensando/Kconfig         | 32 ++++++++++
 drivers/net/ethernet/pensando/Makefile        |  6 ++
 drivers/net/ethernet/pensando/ionic/Makefile  |  6 ++
 drivers/net/ethernet/pensando/ionic/ionic.h   | 27 +++++++++
 .../net/ethernet/pensando/ionic/ionic_bus.h   | 10 ++++
 .../ethernet/pensando/ionic/ionic_bus_pci.c   | 58 +++++++++++++++++++
 .../ethernet/pensando/ionic/ionic_devlink.c   | 35 +++++++++++
 .../ethernet/pensando/ionic/ionic_devlink.h   | 12 ++++
 .../net/ethernet/pensando/ionic/ionic_main.c  | 32 ++++++++++
 14 files changed, 272 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/pensando/ionic.rst
 create mode 100644 drivers/net/ethernet/pensando/Kconfig
 create mode 100644 drivers/net/ethernet/pensando/Makefile
 create mode 100644 drivers/net/ethernet/pensando/ionic/Makefile
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_bus.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_devlink.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_devlink.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_main.c

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 2b7fefe72351..57fec66c5419 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -23,6 +23,7 @@ Contents:
    intel/ice
    google/gve
    mellanox/mlx5
+   pensando/ionic
 
 .. only::  subproject
 
diff --git a/Documentation/networking/device_drivers/pensando/ionic.rst b/Documentation/networking/device_drivers/pensando/ionic.rst
new file mode 100644
index 000000000000..67b6839d516b
--- /dev/null
+++ b/Documentation/networking/device_drivers/pensando/ionic.rst
@@ -0,0 +1,43 @@
+.. SPDX-License-Identifier: GPL-2.0+
+
+==========================================================
+Linux* Driver for the Pensando(R) Ethernet adapter family
+==========================================================
+
+Pensando Linux Ethernet driver.
+Copyright(c) 2019 Pensando Systems, Inc
+
+Contents
+========
+
+- Identifying the Adapter
+- Support
+
+Identifying the Adapter
+=======================
+
+To find if one or more Pensando PCI Ethernet devices are installed on the
+host, check for the PCI devices::
+
+  $ lspci -d 1dd8:
+  b5:00.0 Ethernet controller: Device 1dd8:1002
+  b6:00.0 Ethernet controller: Device 1dd8:1002
+
+If such devices are listed as above, then the ionic.ko driver should find
+and configure them for use.  There should be log entries in the kernel
+messages such as these::
+
+  $ dmesg | grep ionic
+  ionic Pensando Ethernet NIC Driver, ver 0.15.0-k
+  ionic 0000:b5:00.0 enp181s0: renamed from eth0
+  ionic 0000:b6:00.0 enp182s0: renamed from eth0
+
+Support
+=======
+For general Linux networking support, please use the netdev mailing
+list, which is monitored by Pensando personnel::
+  netdev@vger.kernel.org
+
+For more specific support needs, please use the Pensando driver support
+email::
+	drivers@pensando.io
diff --git a/MAINTAINERS b/MAINTAINERS
index 818f2a17699a..457b3e12638c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12595,6 +12595,14 @@ L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/peaq-wmi.c
 
+PENSANDO ETHERNET DRIVERS
+M:	Shannon Nelson <snelson@pensando.io>
+M:	Pensando Drivers <drivers@pensando.io>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	Documentation/networking/device_drivers/pensando/ionic.rst
+F:	drivers/net/ethernet/pensando/
+
 PER-CPU MEMORY ALLOCATOR
 M:	Dennis Zhou <dennis@kernel.org>
 M:	Tejun Heo <tj@kernel.org>
diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index 93a2d4deb27c..2830dc283ce6 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -168,6 +168,7 @@ config ETHOC
 
 source "drivers/net/ethernet/packetengines/Kconfig"
 source "drivers/net/ethernet/pasemi/Kconfig"
+source "drivers/net/ethernet/pensando/Kconfig"
 source "drivers/net/ethernet/qlogic/Kconfig"
 source "drivers/net/ethernet/qualcomm/Kconfig"
 source "drivers/net/ethernet/rdc/Kconfig"
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index fb9155cffcff..061edd22f507 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -97,3 +97,4 @@ obj-$(CONFIG_NET_VENDOR_WIZNET) += wiznet/
 obj-$(CONFIG_NET_VENDOR_XILINX) += xilinx/
 obj-$(CONFIG_NET_VENDOR_XIRCOM) += xircom/
 obj-$(CONFIG_NET_VENDOR_SYNOPSYS) += synopsys/
+obj-$(CONFIG_NET_VENDOR_PENSANDO) += pensando/
diff --git a/drivers/net/ethernet/pensando/Kconfig b/drivers/net/ethernet/pensando/Kconfig
new file mode 100644
index 000000000000..5ea570be8379
--- /dev/null
+++ b/drivers/net/ethernet/pensando/Kconfig
@@ -0,0 +1,32 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Pensando Systems, Inc
+#
+# Pensando device configuration
+#
+
+config NET_VENDOR_PENSANDO
+	bool "Pensando devices"
+	default y
+	help
+	  If you have a network (Ethernet) card belonging to this class, say Y.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about Pensando cards. If you say Y, you will be asked
+	  for your specific card in the following questions.
+
+if NET_VENDOR_PENSANDO
+
+config IONIC
+	tristate "Pensando Ethernet IONIC Support"
+	depends on 64BIT && PCI
+	help
+	  This enables the support for the Pensando family of Ethernet
+	  adapters.  More specific information on this driver can be
+	  found in
+	  <file:Documentation/networking/device_drivers/pensando/ionic.rst>.
+
+          To compile this driver as a module, choose M here. The module
+          will be called ionic.
+
+endif # NET_VENDOR_PENSANDO
diff --git a/drivers/net/ethernet/pensando/Makefile b/drivers/net/ethernet/pensando/Makefile
new file mode 100644
index 000000000000..21ce7499c122
--- /dev/null
+++ b/drivers/net/ethernet/pensando/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the Pensando network device drivers.
+#
+
+obj-$(CONFIG_IONIC) += ionic/
diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
new file mode 100644
index 000000000000..f174e8f7bce1
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2017 - 2019 Pensando Systems, Inc
+
+obj-$(CONFIG_IONIC) := ionic.o
+
+ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o
diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
new file mode 100644
index 000000000000..56ccf27b7571
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#ifndef _IONIC_H_
+#define _IONIC_H_
+
+#include "ionic_devlink.h"
+
+#define IONIC_DRV_NAME		"ionic"
+#define IONIC_DRV_DESCRIPTION	"Pensando Ethernet NIC Driver"
+#define IONIC_DRV_VERSION	"0.15.0-k"
+
+#define PCI_VENDOR_ID_PENSANDO			0x1dd8
+
+#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF	0x1002
+#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF	0x1003
+
+#define IONIC_SUBDEV_ID_NAPLES_25	0x4000
+#define IONIC_SUBDEV_ID_NAPLES_100_4	0x4001
+#define IONIC_SUBDEV_ID_NAPLES_100_8	0x4002
+
+struct ionic {
+	struct pci_dev *pdev;
+	struct device *dev;
+};
+
+#endif /* _IONIC_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus.h b/drivers/net/ethernet/pensando/ionic/ionic_bus.h
new file mode 100644
index 000000000000..94ba0afc6f38
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#ifndef _IONIC_BUS_H_
+#define _IONIC_BUS_H_
+
+int ionic_bus_register_driver(void);
+void ionic_bus_unregister_driver(void);
+
+#endif /* _IONIC_BUS_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
new file mode 100644
index 000000000000..2946ce37b06c
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/pci.h>
+
+#include "ionic.h"
+#include "ionic_bus.h"
+
+/* Supported devices */
+static const struct pci_device_id ionic_id_table[] = {
+	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF) },
+	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF) },
+	{ 0, }	/* end of table */
+};
+MODULE_DEVICE_TABLE(pci, ionic_id_table);
+
+static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct device *dev = &pdev->dev;
+	struct ionic *ionic;
+
+	ionic = ionic_devlink_alloc(dev);
+	if (!ionic)
+		return -ENOMEM;
+
+	ionic->pdev = pdev;
+	ionic->dev = dev;
+	pci_set_drvdata(pdev, ionic);
+
+	return 0;
+}
+
+static void ionic_remove(struct pci_dev *pdev)
+{
+	struct ionic *ionic = pci_get_drvdata(pdev);
+
+	ionic_devlink_free(ionic);
+}
+
+static struct pci_driver ionic_driver = {
+	.name = IONIC_DRV_NAME,
+	.id_table = ionic_id_table,
+	.probe = ionic_probe,
+	.remove = ionic_remove,
+};
+
+int ionic_bus_register_driver(void)
+{
+	return pci_register_driver(&ionic_driver);
+}
+
+void ionic_bus_unregister_driver(void)
+{
+	pci_unregister_driver(&ionic_driver);
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
new file mode 100644
index 000000000000..d2665cee517a
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#include <linux/module.h>
+#include <linux/netdevice.h>
+
+#include "ionic.h"
+#include "ionic_bus.h"
+#include "ionic_devlink.h"
+
+static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
+			     struct netlink_ext_ack *extack)
+{
+	return devlink_info_driver_name_put(req, IONIC_DRV_NAME);
+}
+
+static const struct devlink_ops ionic_dl_ops = {
+	.info_get	= ionic_dl_info_get,
+};
+
+struct ionic *ionic_devlink_alloc(struct device *dev)
+{
+	struct devlink *dl;
+
+	dl = devlink_alloc(&ionic_dl_ops, sizeof(struct ionic));
+
+	return devlink_priv(dl);
+}
+
+void ionic_devlink_free(struct ionic *ionic)
+{
+	struct devlink *dl = priv_to_devlink(ionic);
+
+	devlink_free(dl);
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.h b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
new file mode 100644
index 000000000000..1df50874260a
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#ifndef _IONIC_DEVLINK_H_
+#define _IONIC_DEVLINK_H_
+
+#include <net/devlink.h>
+
+struct ionic *ionic_devlink_alloc(struct device *dev);
+void ionic_devlink_free(struct ionic *ionic);
+
+#endif /* _IONIC_DEVLINK_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
new file mode 100644
index 000000000000..332b528ce921
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/netdevice.h>
+#include <linux/utsname.h>
+
+#include "ionic.h"
+#include "ionic_bus.h"
+
+MODULE_DESCRIPTION(IONIC_DRV_DESCRIPTION);
+MODULE_AUTHOR("Pensando Systems, Inc");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(IONIC_DRV_VERSION);
+
+static int __init ionic_init_module(void)
+{
+	pr_info("%s %s, ver %s\n",
+		IONIC_DRV_NAME, IONIC_DRV_DESCRIPTION, IONIC_DRV_VERSION);
+	return ionic_bus_register_driver();
+}
+
+static void __exit ionic_cleanup_module(void)
+{
+	ionic_bus_unregister_driver();
+
+	pr_info("%s removed\n", IONIC_DRV_NAME);
+}
+
+module_init(ionic_init_module);
+module_exit(ionic_cleanup_module);
-- 
2.17.1

