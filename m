Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72B2170B9A
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 23:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730983AbfGVVkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 17:40:31 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46429 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729004AbfGVVka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 17:40:30 -0400
Received: by mail-pg1-f194.google.com with SMTP id i8so18263068pgm.13
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 14:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=wbVAqaWeKTfneFmOMUDNdwe8PCtmCb7+SK++avq+6oQ=;
        b=qEDI1IHCvm1VPXch02aFx9iCMnEn0S7mwhlih1/ycI7FAV8LcLS1+xK37vwbOY+Sml
         EW8B07+ptUCkGcGTAAECtKG9bPNAKHxdu4wqhB/WQS7vW7Km00BlEelGIt/Vmr2eYOeB
         m0OHHsqay6ObmGeHNByHTxHiFYJJLm2ZnCdoMGHgs96a7TAH6RXFIuSKgQ6Nhw9esHKI
         gqFEiPlNHMteeFj9Yu4RzpGDENYMZI1eYWWfR0wfEIY6chhgICjzEOCGsVdZlSu5/iWe
         Ezf4CboCiJyZXP9BVkLZTjGrWz6sKvyNvYsLncaEqhM5mU4Dzb9nZozFhRonSOzACCr5
         CUbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=wbVAqaWeKTfneFmOMUDNdwe8PCtmCb7+SK++avq+6oQ=;
        b=SmO0QPvQ+QkE7b3eN51xeZYyBQCEFIBdojCm0ngucbPCMKke7KLYdR8KZAUORy9vyR
         TndOJIGvpK1uGozdjC/AftaP6+c/+RreO4YuMnN00dddKnOxd2figlu7x1LFfnRPju+n
         rbyEP+V+XBm/Zo6gJpVbAhiCjBZfyMruS2NKoyM5yBnW5FhSV35MxESBjTP30jbpQNPA
         EPYLmL81bJSgcjQrIuJ4GLYoQjr3W9cHGpyUZgJC4OMT/XrvwQginTP0BgaWVMqtBB3j
         DgtWaNJafBcocxRIEtVDxB585w3ic+3GZhDVJaTYPODcHdbE54Zg9Vu0vuBeA627EyT7
         8UjA==
X-Gm-Message-State: APjAAAVgtmgJ84zcdXs9YWApDMWdQwCJuzXsa9EZb1yYYBDtNeP4IX3I
        NWg+2sfz4jfyDaMax+iYG73VAJuyQGo1hA==
X-Google-Smtp-Source: APXvYqyFQ65K+a04iTjEJgvMmxKmEuyXjj36y2VX/Pme6iRlBuMqgcsMbTit5FdXY35ZVRNsb9O6jQ==
X-Received: by 2002:a17:90a:5884:: with SMTP id j4mr81921400pji.142.1563831629653;
        Mon, 22 Jul 2019 14:40:29 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id p65sm40593714pfp.58.2019.07.22.14.40.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 14:40:29 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v4 net-next 01/19] ionic: Add basic framework for IONIC Network device driver
Date:   Mon, 22 Jul 2019 14:40:05 -0700
Message-Id: <20190722214023.9513-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190722214023.9513-1-snelson@pensando.io>
References: <20190722214023.9513-1-snelson@pensando.io>
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
 .../device_drivers/pensando/ionic.rst         | 64 +++++++++++++++++++
 MAINTAINERS                                   |  8 +++
 drivers/net/ethernet/Kconfig                  |  1 +
 drivers/net/ethernet/Makefile                 |  1 +
 drivers/net/ethernet/pensando/Kconfig         | 32 ++++++++++
 drivers/net/ethernet/pensando/Makefile        |  6 ++
 drivers/net/ethernet/pensando/ionic/Makefile  |  6 ++
 drivers/net/ethernet/pensando/ionic/ionic.h   | 25 ++++++++
 .../net/ethernet/pensando/ionic/ionic_bus.h   | 10 +++
 .../ethernet/pensando/ionic/ionic_bus_pci.c   | 58 +++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_main.c  | 29 +++++++++
 12 files changed, 241 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/pensando/ionic.rst
 create mode 100644 drivers/net/ethernet/pensando/Kconfig
 create mode 100644 drivers/net/ethernet/pensando/Makefile
 create mode 100644 drivers/net/ethernet/pensando/ionic/Makefile
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_bus.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
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
index 000000000000..6b05d1dad533
--- /dev/null
+++ b/Documentation/networking/device_drivers/pensando/ionic.rst
@@ -0,0 +1,64 @@
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
+- Special Features
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
+  ionic Pensando Ethernet NIC Driver, ver 0.11.0-k
+  ionic 0000:b5:00.0 enp181s0: renamed from eth0
+  ionic 0000:b5:00.0: NETDEV_CHANGENAME lif0 enp181s0
+  ionic 0000:b6:00.0 enp182s0: renamed from eth0
+  ionic 0000:b6:00.0: NETDEV_CHANGENAME lif0 enp182s0
+
+Special Features
+================
+
+Extended Debug Statistics
+-------------------------
+Basic network driver statistics are available through ethtool's
+statistics request::
+
+  $ ethtool -S enp181s0
+
+Extended debugging statistics can be enabled with the driver private
+flag "sw-dbg-stats"::
+
+  $ ethtool --show-priv-flags enp181s0
+  Private flags for enp181s0:
+  sw-dbg-stats: off
+  $ ethtool --set-priv-flags enp181s0 sw-dbg-stats on
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
index 211ea3a199bd..17634eb4ce72 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12502,6 +12502,14 @@ L:	platform-driver-x86@vger.kernel.org
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
index 000000000000..beb3faeccac1
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2017 - 2019 Pensando Systems, Inc
+
+obj-$(CONFIG_IONIC) := ionic.o
+
+ionic-y := ionic_main.o ionic_bus_pci.o
diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
new file mode 100644
index 000000000000..18c79adef06c
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#ifndef _IONIC_H_
+#define _IONIC_H_
+
+#define DRV_NAME		"ionic"
+#define DRV_DESCRIPTION		"Pensando Ethernet NIC Driver"
+#define DRV_VERSION		"0.11.0-k"
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
index 000000000000..3fc3479c85f1
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
+	ionic = devm_kzalloc(dev, sizeof(*ionic), GFP_KERNEL);
+	if (!ionic)
+		return -ENOMEM;
+
+	ionic->pdev = pdev;
+	pci_set_drvdata(pdev, ionic);
+	ionic->dev = dev;
+
+	return 0;
+}
+
+static void ionic_remove(struct pci_dev *pdev)
+{
+	struct ionic *ionic = pci_get_drvdata(pdev);
+
+	devm_kfree(&pdev->dev, ionic);
+}
+
+static struct pci_driver ionic_driver = {
+	.name = DRV_NAME,
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
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
new file mode 100644
index 000000000000..fb49c0ca5095
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -0,0 +1,29 @@
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
+MODULE_DESCRIPTION(DRV_DESCRIPTION);
+MODULE_AUTHOR("Pensando Systems, Inc");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+
+static int __init ionic_init_module(void)
+{
+	pr_info("%s %s, ver %s\n", DRV_NAME, DRV_DESCRIPTION, DRV_VERSION);
+	return ionic_bus_register_driver();
+}
+
+static void __exit ionic_cleanup_module(void)
+{
+	ionic_bus_unregister_driver();
+}
+
+module_init(ionic_init_module);
+module_exit(ionic_cleanup_module);
-- 
2.17.1

