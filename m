Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7963D4DB19
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 22:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfFTUYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 16:24:32 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41142 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfFTUYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 16:24:31 -0400
Received: by mail-pg1-f196.google.com with SMTP id y72so2151251pgd.8
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 13:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=hnooHWt7wiAvWBQZMyzD1c3gTLbWUiHRnlQgy1y4Xmg=;
        b=yLcTi5GG65jXr7yZqPbiUDXgEh9no8BAm+VL16Masfw+jta6vnAg10pphmDBILs9AH
         jceaVHpJv/C2N72C+8Zy1NADqmnEUCsI3+fANiR/KicVsITdxQzU4nFdJHK8TMiaEmdE
         fenYmAk8Ku8S0DlwdBuRgOKpPo6k4qOTBh9KDUlABWYlaY51iiZFHOA47Jni6w/AjTX9
         vo2EchY6Specc15ohZjFtyQ1Aj5Ev1qmrqBmCGz4AGksYIFCHZbRweTUljutfhb7WjXg
         wEkO8PzbChdkzDkH/UunvTruZvwStzeELr2cbF/C68NgXUeD+zDetGo1PBtKHtuEOcAe
         GknA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=hnooHWt7wiAvWBQZMyzD1c3gTLbWUiHRnlQgy1y4Xmg=;
        b=MgvwevtzHYYvHcCTJkIJiAbzuakl+QXihfqTuP+ug5caeIU/kQhqAlTFAHvcWxHJB6
         ThdGu1mxY7MnCNF/Bm0BKdHHMZagAxDTbIZXhEXS0NPZQ9uyG17DeohMLltNbGBJH1a6
         SxKSAg0xgmjy0rXMO/TO5luWkIzWisIiNY+7m7/J5xhni5r/+IA1SFLQEvonQ4QqD3w2
         iI+kAAEqhOBLHaree35jutuTYVN+z35cnyvdLoFXijAg/igEjGj5zq+0BBL6+6HAGpSq
         mo+L0CDxQKFqwjtDI8E2F0G2CtSZiFtCMHVM2ItSqnve5t65OJBuUoL3TDpyUA+FU6gZ
         aC1Q==
X-Gm-Message-State: APjAAAW+G4/G9eyOMFrxrCYnX51/wTkOgzK0XMOfFa/tVEZF+imd8mcf
        F8KTz0twLUQOkLMMlE/QGh6GLJy/z+s=
X-Google-Smtp-Source: APXvYqyE5BEdnVxc7Oc/Mc0qYibhBeOSOHyD5UhinWsOyD7Yda1fUd758gzLJ9AR9eXmjP379TRlQw==
X-Received: by 2002:a63:5d54:: with SMTP id o20mr13733338pgm.97.1561062270348;
        Thu, 20 Jun 2019 13:24:30 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id h26sm340537pfq.64.2019.06.20.13.24.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 13:24:29 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH net-next 01/18] ionic: Add basic framework for IONIC Network device driver
Date:   Thu, 20 Jun 2019 13:24:07 -0700
Message-Id: <20190620202424.23215-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620202424.23215-1-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
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
 .../device_drivers/pensando/ionic.rst         | 75 +++++++++++++++++++
 MAINTAINERS                                   |  8 ++
 drivers/net/ethernet/Kconfig                  |  1 +
 drivers/net/ethernet/Makefile                 |  1 +
 drivers/net/ethernet/pensando/Kconfig         | 32 ++++++++
 drivers/net/ethernet/pensando/Makefile        |  6 ++
 drivers/net/ethernet/pensando/ionic/Makefile  |  6 ++
 drivers/net/ethernet/pensando/ionic/ionic.h   | 27 +++++++
 .../net/ethernet/pensando/ionic/ionic_bus.h   | 10 +++
 .../ethernet/pensando/ionic/ionic_bus_pci.c   | 61 +++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_main.c  | 30 ++++++++
 12 files changed, 258 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/pensando/ionic.rst
 create mode 100644 drivers/net/ethernet/pensando/Kconfig
 create mode 100644 drivers/net/ethernet/pensando/Makefile
 create mode 100644 drivers/net/ethernet/pensando/ionic/Makefile
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_bus.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_main.c

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 24598d5f8ffa..fc5bcfd725fa 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -22,6 +22,7 @@ Contents:
    intel/iavf
    intel/ice
    mellanox/mlx5
+   pensando/ionic
 
 .. only::  subproject
 
diff --git a/Documentation/networking/device_drivers/pensando/ionic.rst b/Documentation/networking/device_drivers/pensando/ionic.rst
new file mode 100644
index 000000000000..84bdf682052b
--- /dev/null
+++ b/Documentation/networking/device_drivers/pensando/ionic.rst
@@ -0,0 +1,75 @@
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
+  b7:00.0 Ethernet controller: Device 1dd8:1004
+
+If such devices are listed as above, then the ionic.ko driver should find
+and configure them for use.  There should be log entries in the kernel
+messages such as these::
+
+  $ dmesg | grep ionic
+  ionic Pensando Ethernet NIC Driver, ver 0.11.0-k
+  ionic 0000:b5:00.0: attached
+  ionic 0000:b5:00.0 enp181s0: renamed from eth0
+  ionic 0000:b5:00.0: NETDEV_CHANGENAME lif0 enp181s0
+  ionic 0000:b6:00.0: attached
+  ionic 0000:b6:00.0 enp182s0: renamed from eth0
+  ionic 0000:b6:00.0: NETDEV_CHANGENAME lif0 enp182s0
+  ionic 0000:b7:00.0: attached
+  ionic 0000:b7:00.0 enp183s0: renamed from eth0
+  ionic 0000:b7:00.0: NETDEV_CHANGENAME lif0 enp183s0
+
+
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
+
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
index 0cfe98a6761a..8921b4ec7894 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12344,6 +12344,14 @@ L:	platform-driver-x86@vger.kernel.org
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
index fe115b7caba0..36472952fd95 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -167,6 +167,7 @@ config ETHOC
 
 source "drivers/net/ethernet/packetengines/Kconfig"
 source "drivers/net/ethernet/pasemi/Kconfig"
+source "drivers/net/ethernet/pensando/Kconfig"
 source "drivers/net/ethernet/qlogic/Kconfig"
 source "drivers/net/ethernet/qualcomm/Kconfig"
 source "drivers/net/ethernet/rdc/Kconfig"
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index 7b5bf9682066..08473bb94d42 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -96,3 +96,4 @@ obj-$(CONFIG_NET_VENDOR_WIZNET) += wiznet/
 obj-$(CONFIG_NET_VENDOR_XILINX) += xilinx/
 obj-$(CONFIG_NET_VENDOR_XIRCOM) += xircom/
 obj-$(CONFIG_NET_VENDOR_SYNOPSYS) += synopsys/
+obj-$(CONFIG_NET_VENDOR_PENSANDO) += pensando/
diff --git a/drivers/net/ethernet/pensando/Kconfig b/drivers/net/ethernet/pensando/Kconfig
new file mode 100644
index 000000000000..6b94bc5981db
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
+	---help---
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
+	depends on PCI
+	---help---
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
index 000000000000..cb067392cc29
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -0,0 +1,27 @@
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
+// TODO: register these with the official include/linux/pci_ids.h
+#define PCI_VENDOR_ID_PENSANDO			0x1dd8
+
+#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF	0x1002
+#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF	0x1003
+#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT	0x1004
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
index 000000000000..ab6206c162d4
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -0,0 +1,61 @@
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
+	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT) },
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
+	dev_info(ionic->dev, "attached\n");
+
+	return 0;
+}
+
+static void ionic_remove(struct pci_dev *pdev)
+{
+	struct ionic *ionic = pci_get_drvdata(pdev);
+
+	pci_set_drvdata(pdev, NULL);
+	dev_info(ionic->dev, "removed\n");
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
index 000000000000..6c030fc7935f
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -0,0 +1,30 @@
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
+	pr_info("%s removed\n", DRV_NAME);
+}
+
+module_init(ionic_init_module);
+module_exit(ionic_cleanup_module);
-- 
2.17.1

