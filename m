Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B35FFA250E
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbfH2S1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:27:54 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40158 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728737AbfH2S1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 14:27:52 -0400
Received: by mail-pf1-f196.google.com with SMTP id w16so2624339pfn.7
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 11:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=SRw90eq8BRxC29v9GYAiN/BFxm/wHMIsIMobLV0Dhs0=;
        b=3tjzlPeqxaxIZL7eLnRikZgDwKbavUDjmAWhBhTCKwNXGZahNj4xaRnlydOnjIJ96q
         AjM2AEMmyV1P4nEZu+83ltEVCyEL0/sn5D/YjyMUPE+VbQAUnu6pMQxkuWkYZ6IjH55L
         DfAUySG8w+4yqNfCWl1fF+z8b6eW7aS26xGzEH4/ZDwzUnR5YITIYBCq7jLTpNFYdulw
         f/fWr6mqi2fXXg4wBP0Uch7Gb/sJAkjTnfmYYKVDcqlA9spUKTSI2nYCTwzId3duinut
         tHmcOoi9i6X7AzZp9rFNketJfXsTmNrzUNNFsbGnJM767AyjxjuxD+8UWLRHt9IpWKWG
         8nYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=SRw90eq8BRxC29v9GYAiN/BFxm/wHMIsIMobLV0Dhs0=;
        b=AXO/f1cOL9LRArmF5tx/T5lzzhW4LTk1AnMHmGLtxnhaw1TQXA8UISk+iLEGbqm186
         QD6c3pc8En5G1VLTLnbHIZZh8QeIyHRjdd0n2eYwdAjh1QUr+XZYivE75YjkFKLqFPg4
         S4uYJN5oEv1Obcrz1uEaD6De/PKW7lPYYVrVG+zvLVJPLTSviks4u+dDzv+aTeTsLWw5
         IMTXQUf2hKzEZam2PsemTGWC1LKOkXuXXEqwh/9mz1B6isK2Bxqv6Hwl30rWp/HkLC5N
         hWE1KcBpIwqjJK9lAfs7k7lOuB/JB7YXCHHJk81bqT/EVzZG8BfLloW4UpL/qz6sEFhe
         6RRw==
X-Gm-Message-State: APjAAAXPGKSWi7Bi4D6Qcuz3ey094SvvyhnBN3rSMYQqI4fvIu8/0p9u
        bfsaZNqvN7l0rb/YrraZVqTGxQ==
X-Google-Smtp-Source: APXvYqyx1xJg02hzDxNgk2X1pA2MOb0YZ+2VIwH1mev2heM0yT+KtxytDUiUaL9SJSNg7dw7ELDeWA==
X-Received: by 2002:a62:5184:: with SMTP id f126mr13260914pfb.19.1567103271504;
        Thu, 29 Aug 2019 11:27:51 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id t70sm3082824pjb.2.2019.08.29.11.27.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 11:27:50 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v6 net-next 02/19] ionic: Add basic framework for IONIC Network device driver
Date:   Thu, 29 Aug 2019 11:27:03 -0700
Message-Id: <20190829182720.68419-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829182720.68419-1-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
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
 .../ethernet/pensando/ionic/ionic_devlink.c   | 44 ++++++++++++++
 .../ethernet/pensando/ionic/ionic_devlink.h   | 12 ++++
 .../net/ethernet/pensando/ionic/ionic_main.c  | 32 ++++++++++
 14 files changed, 281 insertions(+)
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
index 000000000000..6892409cd64b
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -0,0 +1,44 @@
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
+	devlink_info_driver_name_put(req, IONIC_DRV_NAME);
+
+	return 0;
+}
+
+static const struct devlink_ops ionic_dl_ops = {
+	.info_get	= ionic_dl_info_get,
+};
+
+struct ionic *ionic_devlink_alloc(struct device *dev)
+{
+	struct ionic *ionic;
+	struct devlink *dl;
+
+	dl = devlink_alloc(&ionic_dl_ops, sizeof(struct ionic));
+	if (!dl) {
+		dev_warn(dev, "devlink_alloc failed");
+		return NULL;
+	}
+
+	ionic = devlink_priv(dl);
+
+	return ionic;
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

