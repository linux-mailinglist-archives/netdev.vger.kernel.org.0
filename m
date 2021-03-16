Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1DC33D426
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 13:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbhCPMqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 08:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbhCPMpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 08:45:45 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E17C06174A;
        Tue, 16 Mar 2021 05:45:44 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y13so8761541pfr.0;
        Tue, 16 Mar 2021 05:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/1dePxwRH2hOn2EF8iUQj0lL2VQoYamARjUoHzxTA8Q=;
        b=DvebWdOxfnSIzLhOOebL9LEicBVtsFU5xGx8+LfHnGzvdT1bFbjyj3Isws7AP/rN4b
         6uxaW2AebWBStRDWHqIBENrDcRmywSwTPMlqocDwilVCQ6bTlrZnGJjiobfqt4n2kmuD
         zhoXivJLt0bXopNO5DUgh6i0RnoCaR3mzgOW38gKU73K6vjHrtg8E+JG67XyD+bEKdXz
         va1At4TOJZ+vd/9fk69tbh6Xhm2iNAaL37Kx3/4aTX2HaNVvBcS6tYd/M7395caMrlfG
         cspxuJ9S9tyQsOVKoLUbS0KkOlMfwHuvJFaHHgTln0j8eXSmS10JM/Baq7HBqHfS+XHT
         YsZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/1dePxwRH2hOn2EF8iUQj0lL2VQoYamARjUoHzxTA8Q=;
        b=Ij0sRMzQ7ZJR2uUhxM2akdel74Pe8JDrXy0bviiZ3iE0cDZjNYYfo1aXhtIH2rZinS
         j0rGed5cLtJ5464GAqEVVYE6HKcIcLox+Oc/Sp1jletZYMtYeN7EnQoR34ZDJF5trRfh
         6PMIC7leJe1vmCKfJn5frbQ4j/3kxxsN+MJQL9f4SbqQjSwsMj1XLU6yfzlY3ZOJHHXR
         MJXZfKicMTOuZtfBjLJUOi9ONIarRKKJ9Ry+hlnHLnwW08wtkJAMKN0nBZviBYQoRRcJ
         EHyxmh9jgg24GnoxiI5PUvSbxCuW1ZPwErGVzTWit2erQq7VJrseMO3To1M9c5sEM2Nj
         3FPg==
X-Gm-Message-State: AOAM5324KKp6NVEu9zmYzaPzKq2t1QZegm1FSqZu+lEvx9+OqvWfNjeC
        0zKyGdeOxoh/35bteOruLAA=
X-Google-Smtp-Source: ABdhPJzf7yq+4GY6omF3kOuzZI65UYM9aF0xjIBdxBdMWCJ2OQLBE9/cMOiCXvwlAErG0TTpSxf92Q==
X-Received: by 2002:a62:cfc4:0:b029:200:49d8:6f29 with SMTP id b187-20020a62cfc40000b029020049d86f29mr14566003pfg.45.1615898743208;
        Tue, 16 Mar 2021 05:45:43 -0700 (PDT)
Received: from ubuntu.localdomain ([2.58.242.54])
        by smtp.gmail.com with ESMTPSA id i10sm27104990pjm.1.2021.03.16.05.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 05:45:42 -0700 (PDT)
From:   Jarvis Jiang <jarvis.w.jiang@gmail.com>
To:     davem@davemloft.net, rppt@linux.ibm.com, akpm@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, cchen50@lenovo.com, mpearson@lenovo.com,
        Jarvis Jiang <jarvis.w.jiang@gmail.com>
Subject: [PATCH] Add MHI bus support and driver for T99W175 5G modem
Date:   Tue, 16 Mar 2021 05:42:37 -0700
Message-Id: <20210316124237.3469-1-jarvis.w.jiang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T99W175 using MBIM or RmNet over PCIe interface with
MHI protocol support.
Ported from IPQ8072 platform, including MHI, MBIM, RmNet

Supporting below PCI devices:

  PCI_DEVICE(0x17cb, 0x0300)
  PCI_DEVICE(0x17cb, 0x0301)
  PCI_DEVICE(0x17cb, 0x0302)
  PCI_DEVICE(0x17cb, 0x0303)
  PCI_DEVICE(0x17cb, 0x0304)
  PCI_DEVICE(0x17cb, 0x0305)
  PCI_DEVICE(0x17cb, 0x0306)
  PCI_DEVICE(0x105b, 0xe0ab)
  PCI_DEVICE(0x105b, 0xe0b0)
  PCI_DEVICE(0x105b, 0xe0b1)
  PCI_DEVICE(0x105b, 0xe0b3)
  PCI_DEVICE(0x1269, 0x00b3)
  PCI_DEVICE(0x03f0, 0x0a6c)

Signed-off-by: Jarvis Jiang <jarvis.w.jiang@gmail.com>
---
 MAINTAINERS                                   |   16 +
 drivers/bus/Kconfig                           |    1 +
 drivers/bus/Makefile                          |    3 +
 drivers/bus/mhi/Kconfig                       |   27 +
 drivers/bus/mhi/Makefile                      |    9 +
 drivers/bus/mhi/controllers/Kconfig           |   13 +
 drivers/bus/mhi/controllers/Makefile          |    2 +
 drivers/bus/mhi/controllers/mhi_arch_qti.c    |  275 ++
 drivers/bus/mhi/controllers/mhi_qti.c         |  970 +++++++
 drivers/bus/mhi/controllers/mhi_qti.h         |   44 +
 drivers/bus/mhi/core/Makefile                 |    2 +
 drivers/bus/mhi/core/mhi_boot.c               |  590 +++++
 drivers/bus/mhi/core/mhi_dtr.c                |  223 ++
 drivers/bus/mhi/core/mhi_init.c               | 1901 ++++++++++++++
 drivers/bus/mhi/core/mhi_internal.h           |  826 ++++++
 drivers/bus/mhi/core/mhi_main.c               | 2261 +++++++++++++++++
 drivers/bus/mhi/core/mhi_pm.c                 | 1158 +++++++++
 drivers/bus/mhi/devices/Kconfig               |   43 +
 drivers/bus/mhi/devices/Makefile              |    3 +
 drivers/bus/mhi/devices/mhi_netdev.c          | 1830 +++++++++++++
 drivers/bus/mhi/devices/mhi_satellite.c       | 1155 +++++++++
 drivers/bus/mhi/devices/mhi_uci.c             |  802 ++++++
 drivers/net/ethernet/qualcomm/rmnet/Makefile  |    2 +-
 .../ethernet/qualcomm/rmnet/rmnet_config.c    |  131 +-
 .../ethernet/qualcomm/rmnet/rmnet_config.h    |  110 +-
 .../qualcomm/rmnet/rmnet_descriptor.c         | 1225 +++++++++
 .../qualcomm/rmnet/rmnet_descriptor.h         |  152 ++
 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  321 ++-
 .../ethernet/qualcomm/rmnet/rmnet_handlers.h  |   27 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map.h   |  238 +-
 .../qualcomm/rmnet/rmnet_map_command.c        |  304 ++-
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 1029 +++++++-
 .../ethernet/qualcomm/rmnet/rmnet_private.h   |   19 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_trace.h |  250 ++
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  101 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |   16 +-
 include/linux/ipc_logging.h                   |  291 +++
 include/linux/mhi.h                           |  743 ++++++
 include/linux/mod_devicetable.h               |   22 +-
 include/linux/msm-bus.h                       |  214 ++
 include/linux/msm_pcie.h                      |  173 ++
 include/linux/netdevice.h                     |   18 +-
 include/uapi/linux/if_link.h                  |    4 +
 include/uapi/linux/msm_rmnet.h                |  170 ++
 mm/memblock.c                                 |    2 +
 net/core/dev.c                                |  192 +-
 46 files changed, 17700 insertions(+), 208 deletions(-)
 create mode 100644 drivers/bus/mhi/Kconfig
 create mode 100644 drivers/bus/mhi/Makefile
 create mode 100644 drivers/bus/mhi/controllers/Kconfig
 create mode 100644 drivers/bus/mhi/controllers/Makefile
 create mode 100644 drivers/bus/mhi/controllers/mhi_arch_qti.c
 create mode 100644 drivers/bus/mhi/controllers/mhi_qti.c
 create mode 100644 drivers/bus/mhi/controllers/mhi_qti.h
 create mode 100644 drivers/bus/mhi/core/Makefile
 create mode 100644 drivers/bus/mhi/core/mhi_boot.c
 create mode 100644 drivers/bus/mhi/core/mhi_dtr.c
 create mode 100644 drivers/bus/mhi/core/mhi_init.c
 create mode 100644 drivers/bus/mhi/core/mhi_internal.h
 create mode 100644 drivers/bus/mhi/core/mhi_main.c
 create mode 100644 drivers/bus/mhi/core/mhi_pm.c
 create mode 100644 drivers/bus/mhi/devices/Kconfig
 create mode 100644 drivers/bus/mhi/devices/Makefile
 create mode 100644 drivers/bus/mhi/devices/mhi_netdev.c
 create mode 100644 drivers/bus/mhi/devices/mhi_satellite.c
 create mode 100644 drivers/bus/mhi/devices/mhi_uci.c
 create mode 100644 drivers/net/ethernet/qualcomm/rmnet/rmnet_descriptor.c
 create mode 100644 drivers/net/ethernet/qualcomm/rmnet/rmnet_descriptor.h
 create mode 100644 drivers/net/ethernet/qualcomm/rmnet/rmnet_trace.h
 create mode 100644 include/linux/ipc_logging.h
 create mode 100644 include/linux/mhi.h
 create mode 100644 include/linux/msm-bus.h
 create mode 100644 include/linux/msm_pcie.h
 create mode 100644 include/uapi/linux/msm_rmnet.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 9d3a5c54a41d..79f61526a4c0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6413,6 +6413,22 @@ S:	Odd Fixes
 L:	linux-block@vger.kernel.org
 F:	drivers/block/floppy.c
 
+FOXCONN 5G MODEM DRIVER
+M:	Jarvis Jiang <jarvis.w.jiang@gmail.com>
+S:	Orphan
+F:	drivers/bus/mhi/
+F:	drivers/net/ethernet/qualcomm/rmnet/
+F:	include/linux/ipc_logging.h
+F:	include/linux/mhi.h
+F:	include/linux/mod_devicetable.h
+F:	include/linux/msm-bus.h
+F:	include/linux/msm_pcie.h
+F:	include/linux/netdevice.h
+F:	include/uapi/linux/if_link.h
+F:	include/uapi/linux/msm_rmnet.h
+F:	mm/memblock.c
+F:	net/core/dev.c
+
 FPGA MANAGER FRAMEWORK
 M:	Moritz Fischer <mdf@kernel.org>
 L:	linux-fpga@vger.kernel.org
diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index 6b331061d34b..53a5ae6fd284 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -192,5 +192,6 @@ config DA8XX_MSTPRI
 	  peripherals.
 
 source "drivers/bus/fsl-mc/Kconfig"
+source "drivers/bus/mhi/Kconfig"
 
 endmenu
diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
index 16b43d3468c6..b5b3e219ba8a 100644
--- a/drivers/bus/Makefile
+++ b/drivers/bus/Makefile
@@ -33,3 +33,6 @@ obj-$(CONFIG_UNIPHIER_SYSTEM_BUS)	+= uniphier-system-bus.o
 obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o
 
 obj-$(CONFIG_DA8XX_MSTPRI)	+= da8xx-mstpri.o
+
+# MHI
+obj-$(CONFIG_MHI_BUS)		+= mhi/
diff --git a/drivers/bus/mhi/Kconfig b/drivers/bus/mhi/Kconfig
new file mode 100644
index 000000000000..0beaa862e054
--- /dev/null
+++ b/drivers/bus/mhi/Kconfig
@@ -0,0 +1,27 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# MHI bus
+#
+# Copyright (c) 2018-2020, The Linux Foundation. All rights reserved.
+#
+
+config MHI_BUS
+	tristate "Modem Host Interface (MHI) bus"
+	help
+	  Bus driver for MHI protocol. Modem Host Interface (MHI) is a
+	  communication protocol used by the host processors to control
+	  and communicate with modem devices over a high speed peripheral
+	  bus or shared memory.
+
+config MHI_DEBUG
+	 bool "MHI debug support"
+	 depends on MHI_BUS
+	 help
+	   Say yes here to enable debugging support in the MHI transport
+	   and individual MHI client drivers. This option will impact
+	   throughput as individual MHI packets and state transitions
+	   will be logged.
+
+source "drivers/bus/mhi/controllers/Kconfig"
+source "drivers/bus/mhi/devices/Kconfig"
+
diff --git a/drivers/bus/mhi/Makefile b/drivers/bus/mhi/Makefile
new file mode 100644
index 000000000000..eb9a6f62a65e
--- /dev/null
+++ b/drivers/bus/mhi/Makefile
@@ -0,0 +1,9 @@
+# Makefile for the MHI stack
+#
+
+# core layer
+obj-y += core/
+
+obj-y += controllers/
+obj-y += devices/
+
diff --git a/drivers/bus/mhi/controllers/Kconfig b/drivers/bus/mhi/controllers/Kconfig
new file mode 100644
index 000000000000..e18b38b25e8e
--- /dev/null
+++ b/drivers/bus/mhi/controllers/Kconfig
@@ -0,0 +1,13 @@
+menu "MHI controllers"
+
+config MHI_QTI
+       tristate "MHI QTI"
+       depends on MHI_BUS
+       help
+	  If you say yes to this option, MHI bus support for QTI modem chipsets
+	  will be enabled. QTI PCIe based modems uses MHI as the communication
+	  protocol. MHI control driver is the bus master for such modems. As the
+	  bus master driver, it oversees power management operations such as
+	  suspend, resume, powering on and off the device.
+
+endmenu
diff --git a/drivers/bus/mhi/controllers/Makefile b/drivers/bus/mhi/controllers/Makefile
new file mode 100644
index 000000000000..7a4954861c6a
--- /dev/null
+++ b/drivers/bus/mhi/controllers/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_MHI_QTI) += mhi_qti_m.o
+mhi_qti_m-y += mhi_qti.o mhi_arch_qti.o
diff --git a/drivers/bus/mhi/controllers/mhi_arch_qti.c b/drivers/bus/mhi/controllers/mhi_arch_qti.c
new file mode 100644
index 000000000000..d27f8b3abbcf
--- /dev/null
+++ b/drivers/bus/mhi/controllers/mhi_arch_qti.c
@@ -0,0 +1,275 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.*/
+
+#include <linux/async.h>
+#include <linux/debugfs.h>
+#include <linux/device.h>
+#include <linux/dma-direction.h>
+#include <linux/list.h>
+#include <linux/of.h>
+#include <linux/memblock.h>
+#include <linux/module.h>
+#include <linux/msm-bus.h>
+#include <linux/msm_pcie.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/mhi.h>
+#include <linux/ipc_logging.h>
+#include "mhi_qti.h"
+
+struct arch_info {
+	struct mhi_dev *mhi_dev;
+	struct msm_bus_scale_pdata *msm_bus_pdata;
+	u32 bus_client;
+	struct pci_saved_state *pcie_state;
+	struct pci_saved_state *ref_pcie_state;
+	struct dma_iommu_mapping *mapping;
+};
+
+struct mhi_bl_info {
+	struct mhi_device *mhi_device;
+	async_cookie_t cookie;
+	void *ipc_log;
+};
+
+/* ipc log markings */
+#define DLOG "Dev->Host: "
+#define HLOG "Host: "
+
+#ifdef CONFIG_MHI_DEBUG
+
+#define MHI_IPC_LOG_PAGES (100)
+enum MHI_DEBUG_LEVEL mhi_ipc_log_lvl = MHI_MSG_LVL_VERBOSE;
+
+#else
+
+#define MHI_IPC_LOG_PAGES (10)
+enum MHI_DEBUG_LEVEL mhi_ipc_log_lvl = MHI_MSG_LVL_ERROR;
+
+#endif
+
+static int mhi_arch_set_bus_request(struct mhi_controller *mhi_cntrl, int index)
+{
+	struct mhi_dev *mhi_dev = mhi_controller_get_devdata(mhi_cntrl);
+	struct arch_info *arch_info = mhi_dev->arch_info;
+
+	MHI_LOG("Setting bus request to index %d\n", index);
+
+	if (arch_info->bus_client)
+		return msm_bus_scale_client_update_request(
+				arch_info->bus_client, index);
+
+	/* default return success */
+	return 0;
+}
+
+static void mhi_bl_dl_cb(struct mhi_device *mhi_dev,
+			 struct mhi_result *mhi_result)
+{
+	struct mhi_bl_info *mhi_bl_info = mhi_device_get_devdata(mhi_dev);
+	char *buf = mhi_result->buf_addr;
+
+	/* force a null at last character */
+	buf[mhi_result->bytes_xferd - 1] = 0;
+
+	ipc_log_string(mhi_bl_info->ipc_log, "%s %s", DLOG, buf);
+}
+
+static void mhi_bl_dummy_cb(struct mhi_device *mhi_dev,
+			    struct mhi_result *mhi_result)
+{
+}
+
+static void mhi_bl_remove(struct mhi_device *mhi_dev)
+{
+	struct mhi_bl_info *mhi_bl_info = mhi_device_get_devdata(mhi_dev);
+
+	ipc_log_string(mhi_bl_info->ipc_log, HLOG "Received Remove notif.\n");
+
+	/* wait for boot monitor to exit */
+	async_synchronize_cookie(mhi_bl_info->cookie + 1);
+}
+
+static void mhi_bl_boot_monitor(void *data, async_cookie_t cookie)
+{
+	struct mhi_bl_info *mhi_bl_info = data;
+	struct mhi_device *mhi_device = mhi_bl_info->mhi_device;
+	struct mhi_controller *mhi_cntrl = mhi_device->mhi_cntrl;
+	/* 15 sec timeout for booting device */
+	const u32 timeout = msecs_to_jiffies(15000);
+
+	/* wait for device to enter boot stage */
+	wait_event_timeout(mhi_cntrl->state_event, mhi_cntrl->ee == MHI_EE_AMSS
+			   || mhi_cntrl->ee == MHI_EE_DISABLE_TRANSITION,
+			   timeout);
+
+	if (mhi_cntrl->ee == MHI_EE_AMSS) {
+		ipc_log_string(mhi_bl_info->ipc_log, HLOG
+			       "Device successfully booted to mission mode\n");
+
+		mhi_unprepare_from_transfer(mhi_device);
+	} else {
+		ipc_log_string(mhi_bl_info->ipc_log, HLOG
+			       "Device failed to boot to mission mode, ee = %s\n",
+			       TO_MHI_EXEC_STR(mhi_cntrl->ee));
+	}
+}
+
+static int mhi_bl_probe(struct mhi_device *mhi_dev,
+			const struct mhi_device_id *id)
+{
+	char node_name[32];
+	struct mhi_bl_info *mhi_bl_info;
+
+	mhi_bl_info = devm_kzalloc(&mhi_dev->dev, sizeof(*mhi_bl_info),
+				   GFP_KERNEL);
+	if (!mhi_bl_info)
+		return -ENOMEM;
+
+	snprintf(node_name, sizeof(node_name), "mhi_bl_%04x_%02u.%02u.%02u",
+		 mhi_dev->dev_id, mhi_dev->domain, mhi_dev->bus, mhi_dev->slot);
+
+	mhi_bl_info->ipc_log = ipc_log_context_create(MHI_IPC_LOG_PAGES,
+						      node_name, 0);
+	if (!mhi_bl_info->ipc_log)
+		return -EINVAL;
+
+	mhi_bl_info->mhi_device = mhi_dev;
+	mhi_device_set_devdata(mhi_dev, mhi_bl_info);
+
+	ipc_log_string(mhi_bl_info->ipc_log, HLOG
+		       "Entered SBL, Session ID:0x%x\n",
+		       mhi_dev->mhi_cntrl->session_id);
+
+	/* start a thread to monitor entering mission mode */
+	mhi_bl_info->cookie = async_schedule(mhi_bl_boot_monitor, mhi_bl_info);
+
+	return 0;
+}
+
+static const struct mhi_device_id mhi_bl_match_table[] = {
+	{ .chan = "BL" },
+	{ },
+};
+
+static struct mhi_driver mhi_bl_driver = {
+	.id_table = mhi_bl_match_table,
+	.remove = mhi_bl_remove,
+	.probe = mhi_bl_probe,
+	.ul_xfer_cb = mhi_bl_dummy_cb,
+	.dl_xfer_cb = mhi_bl_dl_cb,
+	.driver = {
+		.name = "MHI_BL",
+		.owner = THIS_MODULE,
+	},
+};
+
+int mhi_arch_pcie_init(struct mhi_controller *mhi_cntrl)
+{
+	struct mhi_dev *mhi_dev = mhi_controller_get_devdata(mhi_cntrl);
+	struct arch_info *arch_info = mhi_dev->arch_info;
+	char node[32];
+
+	if (!arch_info) {
+		arch_info = devm_kzalloc(&mhi_dev->pci_dev->dev,
+					 sizeof(*arch_info), GFP_KERNEL);
+		if (!arch_info)
+			return -ENOMEM;
+
+		mhi_dev->arch_info = arch_info;
+
+		snprintf(node, sizeof(node), "mhi_%04x_%02u.%02u.%02u",
+			 mhi_cntrl->dev_id, mhi_cntrl->domain, mhi_cntrl->bus,
+			 mhi_cntrl->slot);
+		mhi_cntrl->log_buf = ipc_log_context_create(MHI_IPC_LOG_PAGES,
+							    node, 0);
+		mhi_cntrl->log_lvl = mhi_ipc_log_lvl;
+
+		/* save reference state for pcie config space */
+		arch_info->ref_pcie_state =
+		    pci_store_saved_state(mhi_dev->pci_dev);
+
+		mhi_driver_register(&mhi_bl_driver);
+	}
+
+	return mhi_arch_set_bus_request(mhi_cntrl, 1);
+}
+
+void mhi_arch_pcie_deinit(struct mhi_controller *mhi_cntrl)
+{
+	mhi_arch_set_bus_request(mhi_cntrl, 0);
+}
+
+int mhi_arch_link_off(struct mhi_controller *mhi_cntrl, bool graceful)
+{
+	struct mhi_dev *mhi_dev = mhi_controller_get_devdata(mhi_cntrl);
+	struct arch_info *arch_info = mhi_dev->arch_info;
+	struct pci_dev *pci_dev = mhi_dev->pci_dev;
+	int ret;
+
+	MHI_LOG("Entered\n");
+
+	if (graceful) {
+		pci_clear_master(pci_dev);
+		ret = pci_save_state(mhi_dev->pci_dev);
+		if (ret) {
+			MHI_ERR("Failed with pci_save_state, ret:%d\n", ret);
+			return ret;
+		}
+
+		arch_info->pcie_state = pci_store_saved_state(pci_dev);
+		pci_disable_device(pci_dev);
+	}
+
+	/*
+	 * We will always attempt to put link into D3hot, however
+	 * link down may have happened due to error fatal, so
+	 * ignoring the return code
+	 */
+	pci_set_power_state(pci_dev, PCI_D3hot);
+
+	/* release the resources */
+	mhi_arch_set_bus_request(mhi_cntrl, 0);
+
+	MHI_LOG("Exited\n");
+
+	return 0;
+}
+
+int mhi_arch_link_on(struct mhi_controller *mhi_cntrl)
+{
+	struct mhi_dev *mhi_dev = mhi_controller_get_devdata(mhi_cntrl);
+	struct arch_info *arch_info = mhi_dev->arch_info;
+	struct pci_dev *pci_dev = mhi_dev->pci_dev;
+	int ret;
+
+	MHI_LOG("Entered\n");
+
+	/* request resources and establish link trainning */
+	ret = mhi_arch_set_bus_request(mhi_cntrl, 1);
+	if (ret)
+		MHI_LOG("Could not set bus frequency, ret:%d\n", ret);
+
+	ret = pci_set_power_state(pci_dev, PCI_D0);
+	if (ret) {
+		MHI_ERR("Failed to set PCI_D0 state, ret:%d\n", ret);
+		return ret;
+	}
+
+	ret = pci_enable_device(pci_dev);
+	if (ret) {
+		MHI_ERR("Failed to enable device, ret:%d\n", ret);
+		return ret;
+	}
+
+	ret = pci_load_and_free_saved_state(pci_dev, &arch_info->pcie_state);
+	if (ret)
+		MHI_LOG("Failed to load saved cfg state\n");
+
+	pci_restore_state(pci_dev);
+	pci_set_master(pci_dev);
+
+	MHI_LOG("Exited\n");
+
+	return 0;
+}
diff --git a/drivers/bus/mhi/controllers/mhi_qti.c b/drivers/bus/mhi/controllers/mhi_qti.c
new file mode 100644
index 000000000000..8333f64ea7c6
--- /dev/null
+++ b/drivers/bus/mhi/controllers/mhi_qti.c
@@ -0,0 +1,970 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.*/
+
+#ifdef CONFIG_ARM
+#include <asm/arch_timer.h>
+#endif
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dma-direction.h>
+#include <linux/list.h>
+#include <linux/of.h>
+#include <linux/memblock.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/mhi.h>
+#include <linux/msi.h>
+#include <linux/interrupt.h>
+#include <linux/notifier.h>
+#include <linux/io.h>
+#include <linux/gpio/consumer.h>
+#include "mhi_qti.h"
+#include "../core/mhi_internal.h"
+
+/* #define MHI_KMOD_BUILD */
+
+#define WDOG_TIMEOUT	30
+#define MHI_PANIC_TIMER_STEP	1000
+
+static int mhi_panic_timeout;   /* volatile? */
+static int mhi_pci_probe_result;
+
+void __iomem *wdt;
+
+static struct kobject *mhi_kobj;
+
+struct notifier_block *global_mhi_panic_notifier;
+
+static ssize_t sysfs_show(struct kobject *kobj, struct kobj_attribute *attr,
+			  char *buf);
+static ssize_t sysfs_store(struct kobject *kobj, struct kobj_attribute *attr,
+			   const char *buf, size_t count);
+
+static struct kobj_attribute mhi_attr =
+	__ATTR(mhi_panic_timeout, 0660, sysfs_show, sysfs_store);
+
+static ssize_t sysfs_show(struct kobject *kobj, struct kobj_attribute *attr,
+			  char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", mhi_panic_timeout);
+}
+
+static ssize_t sysfs_store(struct kobject *kobj, struct kobj_attribute *attr,
+			   const char *buf, size_t count)
+{
+	if (sscanf(buf, "%du", &mhi_panic_timeout) != 1) {
+		pr_err("failed to read timeout value from string\n");
+		return -EINVAL;
+	}
+	return count;
+}
+
+struct firmware_info {
+	unsigned int dev_id;
+	const char *fw_image;
+	const char *edl_image;
+};
+
+static const struct firmware_info firmware_table[] = {
+	{ .dev_id = 0x306, .fw_image = "sdx55m/sbl1.mbn" },
+	{ .dev_id = 0x305, .fw_image = "sdx50m/sbl1.mbn" },
+	{ .dev_id = 0x304, .fw_image = "sbl.mbn", .edl_image = "edl.mbn" },
+	/* default, set to debug.mbn */
+	{ .fw_image = "debug.mbn" },
+};
+
+static int debug_mode;
+module_param_named(debug_mode, debug_mode, int, 0644);
+
+int mhi_debugfs_trigger_m0(void *data, u64 val)
+{
+	struct mhi_controller *mhi_cntrl = data;
+	struct mhi_dev *mhi_dev = mhi_controller_get_devdata(mhi_cntrl);
+
+	MHI_LOG("Trigger M3 Exit\n");
+	pm_runtime_get(&mhi_dev->pci_dev->dev);
+	pm_runtime_put(&mhi_dev->pci_dev->dev);
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(debugfs_trigger_m0_fops, NULL,
+			mhi_debugfs_trigger_m0, "%llu\n");
+
+int mhi_debugfs_trigger_m3(void *data, u64 val)
+{
+	struct mhi_controller *mhi_cntrl = data;
+	struct mhi_dev *mhi_dev = mhi_controller_get_devdata(mhi_cntrl);
+
+	MHI_LOG("Trigger M3 Entry\n");
+	pm_runtime_mark_last_busy(&mhi_dev->pci_dev->dev);
+	pm_request_autosuspend(&mhi_dev->pci_dev->dev);
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(debugfs_trigger_m3_fops, NULL,
+			mhi_debugfs_trigger_m3, "%llu\n");
+
+void mhi_deinit_pci_dev(struct mhi_controller *mhi_cntrl)
+{
+	struct mhi_dev *mhi_dev = mhi_controller_get_devdata(mhi_cntrl);
+	struct pci_dev *pci_dev = mhi_dev->pci_dev;
+
+	pm_runtime_mark_last_busy(&pci_dev->dev);
+	pm_runtime_dont_use_autosuspend(&pci_dev->dev);
+	pm_runtime_disable(&pci_dev->dev);
+	pci_free_irq_vectors(pci_dev);
+	kfree(mhi_cntrl->irq);
+	mhi_cntrl->irq = NULL;
+	iounmap(mhi_cntrl->regs);
+	iounmap(wdt);
+	mhi_cntrl->regs = NULL;
+	pci_clear_master(pci_dev);
+	pci_release_region(pci_dev, mhi_dev->resn);
+	pci_disable_device(pci_dev);
+}
+
+static int mhi_init_pci_dev(struct mhi_controller *mhi_cntrl)
+{
+	struct mhi_dev *mhi_dev = mhi_controller_get_devdata(mhi_cntrl);
+	struct pci_dev *pci_dev = mhi_dev->pci_dev;
+	int ret;
+	resource_size_t len;
+	int i;
+
+	mhi_dev->resn = MHI_PCI_BAR_NUM;
+	ret = pci_assign_resource(pci_dev, mhi_dev->resn);
+	if (ret) {
+		MHI_ERR("Error assign pci resources, ret:%d\n", ret);
+		return ret;
+	}
+
+	ret = pci_enable_device(pci_dev);
+	if (ret) {
+		MHI_ERR("Error enabling device, ret:%d\n", ret);
+		goto error_enable_device;
+	}
+
+	ret = pci_request_region(pci_dev, mhi_dev->resn, "mhi");
+	if (ret) {
+		MHI_ERR("Error pci_request_region, ret:%d\n", ret);
+		goto error_request_region;
+	}
+
+	pci_set_master(pci_dev);
+
+	mhi_cntrl->base_addr = pci_resource_start(pci_dev, mhi_dev->resn);
+	len = pci_resource_len(pci_dev, mhi_dev->resn);
+	mhi_cntrl->regs = ioremap_nocache(mhi_cntrl->base_addr, len);
+	if (!mhi_cntrl->regs) {
+		MHI_ERR("Error ioremap region\n");
+		goto error_ioremap;
+	}
+#ifdef CONFIG_X86
+	ret = pci_alloc_irq_vectors(pci_dev, 1,
+				    mhi_cntrl->msi_required, PCI_IRQ_ALL_TYPES);
+#else
+	ret = pci_alloc_irq_vectors(pci_dev, mhi_cntrl->msi_required,
+				    mhi_cntrl->msi_required, PCI_IRQ_NOMSIX);
+#endif
+	if (IS_ERR_VALUE((ulong)ret)) {
+		MHI_ERR("Failed to enable MSI, ret:%d\n", ret);
+		goto error_req_msi;
+	}
+
+	mhi_cntrl->msi_allocated = (ret < mhi_cntrl->msi_required) ? 1 : ret;
+	mhi_cntrl->irq = kmalloc_array(mhi_cntrl->msi_allocated,
+				       sizeof(*mhi_cntrl->irq), GFP_KERNEL);
+	if (!mhi_cntrl->irq) {
+		ret = -ENOMEM;
+		goto error_alloc_msi_vec;
+	}
+
+	for (i = 0; i < mhi_cntrl->msi_allocated; i++) {
+		mhi_cntrl->irq[i] = pci_irq_vector(pci_dev, i);
+		if (mhi_cntrl->irq[i] < 0) {
+			ret = mhi_cntrl->irq[i];
+			goto error_get_irq_vec;
+		}
+	}
+
+	dev_set_drvdata(&pci_dev->dev, mhi_cntrl);
+
+	/* configure runtime pm */
+	pm_runtime_set_autosuspend_delay(&pci_dev->dev, MHI_RPM_SUSPEND_TMR_MS);
+	pm_runtime_use_autosuspend(&pci_dev->dev);
+	pm_suspend_ignore_children(&pci_dev->dev, true);
+
+	/*
+	 * pci framework will increment usage count (twice) before
+	 * calling local device driver probe function.
+	 * 1st pci.c pci_pm_init() calls pm_runtime_forbid
+	 * 2nd pci-driver.c local_pci_probe calls pm_runtime_get_sync
+	 * Framework expect pci device driver to call
+	 * pm_runtime_put_noidle to decrement usage count after
+	 * successful probe and call pm_runtime_allow to enable
+	 * runtime suspend.
+	 */
+	pm_runtime_mark_last_busy(&pci_dev->dev);
+	pm_runtime_put_noidle(&pci_dev->dev);
+
+	return 0;
+
+error_get_irq_vec:
+	kfree(mhi_cntrl->irq);
+	mhi_cntrl->irq = NULL;
+
+error_alloc_msi_vec:
+	pci_free_irq_vectors(pci_dev);
+
+error_req_msi:
+	iounmap(mhi_cntrl->regs);
+
+error_ioremap:
+	pci_clear_master(pci_dev);
+
+error_request_region:
+	pci_disable_device(pci_dev);
+
+error_enable_device:
+	pci_release_region(pci_dev, mhi_dev->resn);
+
+	return ret;
+}
+
+static int mhi_runtime_suspend(struct device *dev)
+{
+	int ret = 0;
+	struct mhi_controller *mhi_cntrl = dev_get_drvdata(dev);
+	struct mhi_dev *mhi_dev = mhi_controller_get_devdata(mhi_cntrl);
+
+	MHI_LOG("Enter\n");
+
+	mutex_lock(&mhi_cntrl->pm_mutex);
+
+	if (!mhi_dev->powered_on) {
+		MHI_LOG("Not fully powered, return success\n");
+		mutex_unlock(&mhi_cntrl->pm_mutex);
+		return 0;
+	}
+
+	ret = mhi_pm_suspend(mhi_cntrl);
+	if (ret) {
+		MHI_LOG("Abort due to ret:%d\n", ret);
+		goto exit_runtime_suspend;
+	}
+
+	ret = mhi_arch_link_off(mhi_cntrl, true);
+	if (ret)
+		MHI_ERR("Failed to Turn off link ret:%d\n", ret);
+
+exit_runtime_suspend:
+	mutex_unlock(&mhi_cntrl->pm_mutex);
+	MHI_LOG("Exited with ret:%d\n", ret);
+
+	return ret;
+}
+
+static int mhi_runtime_idle(struct device *dev)
+{
+	struct mhi_controller *mhi_cntrl = dev_get_drvdata(dev);
+
+	MHI_LOG("Entered returning -EBUSY\n");
+
+	/*
+	 * RPM framework during runtime resume always calls
+	 * rpm_idle to see if device ready to suspend.
+	 * If dev.power usage_count count is 0, rpm fw will call
+	 * rpm_idle cb to see if device is ready to suspend.
+	 * if cb return 0, or cb not defined the framework will
+	 * assume device driver is ready to suspend;
+	 * therefore, fw will schedule runtime suspend.
+	 * In MHI power management, MHI host shall go to
+	 * runtime suspend only after entering MHI State M2, even if
+	 * usage count is 0.  Return -EBUSY to disable automatic suspend.
+	 */
+	return -EBUSY;
+}
+
+static int mhi_runtime_resume(struct device *dev)
+{
+	int ret = 0;
+	struct mhi_controller *mhi_cntrl = dev_get_drvdata(dev);
+	struct mhi_dev *mhi_dev = mhi_controller_get_devdata(mhi_cntrl);
+
+	MHI_LOG("Enter\n");
+
+	mutex_lock(&mhi_cntrl->pm_mutex);
+
+	if (!mhi_dev->powered_on) {
+		MHI_LOG("Not fully powered, return success\n");
+		mutex_unlock(&mhi_cntrl->pm_mutex);
+		return 0;
+	}
+
+	/* turn on link */
+	ret = mhi_arch_link_on(mhi_cntrl);
+	if (ret)
+		goto rpm_resume_exit;
+
+	/* enter M0 state */
+	ret = mhi_pm_resume(mhi_cntrl);
+
+rpm_resume_exit:
+	mutex_unlock(&mhi_cntrl->pm_mutex);
+	MHI_LOG("Exited with :%d\n", ret);
+
+	return ret;
+}
+
+static int mhi_system_resume(struct device *dev)
+{
+	int ret = 0;
+	struct mhi_controller *mhi_cntrl = dev_get_drvdata(dev);
+
+	ret = mhi_runtime_resume(dev);
+	if (ret) {
+		MHI_ERR("Failed to resume link\n");
+	} else {
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
+	}
+
+	return ret;
+}
+
+int mhi_system_suspend(struct device *dev)
+{
+	struct mhi_controller *mhi_cntrl = dev_get_drvdata(dev);
+	int ret;
+
+	MHI_LOG("Entered\n");
+
+	/* if rpm status still active then force suspend */
+	if (!pm_runtime_status_suspended(dev)) {
+		ret = mhi_runtime_suspend(dev);
+		if (ret) {
+			MHI_LOG("suspend failed ret:%d\n", ret);
+			return ret;
+		}
+	}
+
+	pm_runtime_set_suspended(dev);
+	pm_runtime_disable(dev);
+
+	MHI_LOG("Exit\n");
+	return 0;
+}
+
+/* checks if link is down */
+static int mhi_link_status(struct mhi_controller *mhi_cntrl, void *priv)
+{
+	struct mhi_dev *mhi_dev = priv;
+	u16 dev_id;
+	int ret;
+
+	/* try reading device id, if dev id don't match, link is down */
+	ret = pci_read_config_word(mhi_dev->pci_dev, PCI_DEVICE_ID, &dev_id);
+
+	return (ret || dev_id != mhi_cntrl->dev_id) ? -EIO : 0;
+}
+
+/* disable PCIe L1 */
+static int mhi_lpm_disable(struct mhi_controller *mhi_cntrl, void *priv)
+{
+	struct mhi_dev *mhi_dev = priv;
+	struct pci_dev *pci_dev = mhi_dev->pci_dev;
+	int lnkctl = pci_dev->pcie_cap + PCI_EXP_LNKCTL;
+	u8 val;
+	int ret;
+
+	ret = pci_read_config_byte(pci_dev, lnkctl, &val);
+	if (ret) {
+		MHI_ERR("Error reading LNKCTL, ret:%d\n", ret);
+		return ret;
+	}
+
+	/* L1 is not supported or already disabled */
+	if (!(val & PCI_EXP_LNKCTL_ASPM_L1))
+		return 0;
+
+	val &= ~PCI_EXP_LNKCTL_ASPM_L1;
+	ret = pci_write_config_byte(pci_dev, lnkctl, val);
+	if (ret) {
+		MHI_ERR("Error writing LNKCTL to disable LPM, ret:%d\n", ret);
+		return ret;
+	}
+
+	mhi_dev->lpm_disabled = true;
+
+	return ret;
+}
+
+/* enable PCIe L1 */
+static int mhi_lpm_enable(struct mhi_controller *mhi_cntrl, void *priv)
+{
+	struct mhi_dev *mhi_dev = priv;
+	struct pci_dev *pci_dev = mhi_dev->pci_dev;
+	int lnkctl = pci_dev->pcie_cap + PCI_EXP_LNKCTL;
+	u8 val;
+	int ret;
+
+	/* L1 is not supported or already disabled */
+	if (!mhi_dev->lpm_disabled)
+		return 0;
+
+	ret = pci_read_config_byte(pci_dev, lnkctl, &val);
+	if (ret) {
+		MHI_ERR("Error reading LNKCTL, ret:%d\n", ret);
+		return ret;
+	}
+
+	val |= PCI_EXP_LNKCTL_ASPM_L1;
+	ret = pci_write_config_byte(pci_dev, lnkctl, val);
+	if (ret) {
+		MHI_ERR("Error writing LNKCTL to enable LPM, ret:%d\n", ret);
+		return ret;
+	}
+
+	mhi_dev->lpm_disabled = false;
+
+	return ret;
+}
+
+static int mhi_power_up(struct mhi_controller *mhi_cntrl)
+{
+	enum mhi_dev_state dev_state = mhi_get_mhi_state(mhi_cntrl);
+	const u32 delayus = 10;
+	int itr = DIV_ROUND_UP(mhi_cntrl->timeout_ms * 1000, delayus);
+	int ret;
+
+	/*
+	 * It's possible device did not go thru a cold reset before
+	 * power up and still in error state. If device in error state,
+	 * we need to trigger a soft reset before continue with power
+	 * up
+	 */
+	if (dev_state == MHI_STATE_SYS_ERR) {
+		mhi_set_mhi_state(mhi_cntrl, MHI_STATE_RESET);
+		while (itr--) {
+			dev_state = mhi_get_mhi_state(mhi_cntrl);
+			if (dev_state != MHI_STATE_SYS_ERR)
+				break;
+			usleep_range(delayus, delayus << 1);
+		}
+		/* device still in error state, abort power up */
+		if (dev_state == MHI_STATE_SYS_ERR)
+			return -EIO;
+	}
+
+	ret = mhi_async_power_up(mhi_cntrl);
+
+	/* power up create the dentry */
+	if (mhi_cntrl->dentry) {
+		debugfs_create_file("m0", 0444, mhi_cntrl->dentry, mhi_cntrl,
+				    &debugfs_trigger_m0_fops);
+		debugfs_create_file("m3", 0444, mhi_cntrl->dentry, mhi_cntrl,
+				    &debugfs_trigger_m3_fops);
+	}
+
+	return ret;
+}
+
+static int mhi_runtime_get(struct mhi_controller *mhi_cntrl, void *priv)
+{
+	struct mhi_dev *mhi_dev = priv;
+	struct device *dev = &mhi_dev->pci_dev->dev;
+
+	return pm_runtime_get(dev);
+}
+
+static void mhi_runtime_put(struct mhi_controller *mhi_cntrl, void *priv)
+{
+	struct mhi_dev *mhi_dev = priv;
+	struct device *dev = &mhi_dev->pci_dev->dev;
+
+	pm_runtime_put_noidle(dev);
+}
+
+static void mhi_status_cb(struct mhi_controller *mhi_cntrl,
+			  void *priv, enum MHI_CB reason)
+{
+	struct mhi_dev *mhi_dev = priv;
+	struct device *dev = &mhi_dev->pci_dev->dev;
+
+	if (reason == MHI_CB_IDLE) {
+		MHI_LOG("Schedule runtime suspend 1\n");
+		pm_runtime_mark_last_busy(dev);
+		pm_request_autosuspend(dev);
+	}
+}
+
+/* capture host SoC XO time in ticks */
+static u64 mhi_time_get(struct mhi_controller *mhi_cntrl, void *priv)
+{
+#ifdef CONFIG_X86
+	u64 now;
+
+	now = rdtsc_ordered();
+
+	return now;
+#else
+	return arch_counter_get_cntvct();
+#endif
+}
+
+static ssize_t timeout_ms_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct mhi_device *mhi_dev = to_mhi_device(dev);
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+
+	/* buffer provided by sysfs has a minimum size of PAGE_SIZE */
+	return snprintf(buf, PAGE_SIZE, "%u\n", mhi_cntrl->timeout_ms);
+}
+
+static ssize_t timeout_ms_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct mhi_device *mhi_dev = to_mhi_device(dev);
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	u32 timeout_ms;
+
+	if (kstrtou32(buf, 0, &timeout_ms) < 0)
+		return -EINVAL;
+
+	mhi_cntrl->timeout_ms = timeout_ms;
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(timeout_ms);
+
+static ssize_t power_up_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	int ret;
+	struct mhi_device *mhi_dev = to_mhi_device(dev);
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+
+	ret = mhi_power_up(mhi_cntrl);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static DEVICE_ATTR_WO(power_up);
+
+static struct attribute *mhi_attrs[] = {
+	&dev_attr_timeout_ms.attr,
+	&dev_attr_power_up.attr,
+	NULL
+};
+
+static const struct attribute_group mhi_group = {
+	.attrs = mhi_attrs,
+};
+
+static struct mhi_controller *mhi_register_controller(struct pci_dev *pci_dev)
+{
+	struct mhi_controller *mhi_cntrl;
+	struct mhi_dev *mhi_dev;
+	struct device_node *of_node = pci_dev->dev.of_node;
+	const struct firmware_info *firmware_info;
+	bool use_bb;
+	u64 addr_win[2];
+	int ret, i;
+
+#ifdef CONFIG_OF
+	if (!of_node)
+		return ERR_PTR(-ENODEV);
+#endif
+
+	mhi_cntrl = mhi_alloc_controller(sizeof(*mhi_dev));
+	if (!mhi_cntrl)
+		return ERR_PTR(-ENOMEM);
+
+	mhi_dev = mhi_controller_get_devdata(mhi_cntrl);
+
+	mhi_cntrl->domain = pci_domain_nr(pci_dev->bus);
+	mhi_cntrl->dev_id = pci_dev->device;
+	mhi_cntrl->bus = pci_dev->bus->number;
+	mhi_cntrl->slot = PCI_SLOT(pci_dev->devfn);
+
+#ifdef CONFIG_OF
+	use_bb = of_property_read_bool(of_node, "mhi,use-bb");
+#else
+	use_bb = false;
+#endif
+
+	/*
+	 * if s1 translation enabled or using bounce buffer pull iova addr
+	 * from dt
+	 */
+	if (use_bb || (mhi_dev->smmu_cfg & MHI_SMMU_ATTACH &&
+		       !(mhi_dev->smmu_cfg & MHI_SMMU_S1_BYPASS))) {
+#ifdef CONFIG_OF
+		ret = of_property_count_elems_of_size(of_node, "qti,addr-win",
+						      sizeof(addr_win));
+		if (ret != 1)
+			goto error_register;
+		ret = of_property_read_u64_array(of_node, "qti,addr-win",
+						 addr_win, 2);
+		if (ret)
+			goto error_register;
+#else
+		goto error_register;
+#endif
+	} else {
+#ifdef MHI_KMOD_BUILD
+		/* FIXME: Modify values for different platform */
+		addr_win[0] = 0x1000;
+		addr_win[1] = 0x17c800000;
+#else
+		addr_win[0] = memblock_start_of_DRAM();
+		addr_win[1] = memblock_end_of_DRAM();
+#endif
+	}
+
+	mhi_dev->iova_start = addr_win[0];
+	mhi_dev->iova_stop = addr_win[1];
+
+	/*
+	 * If S1 is enabled, set MHI_CTRL start address to 0 so we can use low
+	 * level mapping api to map buffers outside of smmu domain
+	 */
+	if (mhi_dev->smmu_cfg & MHI_SMMU_ATTACH &&
+	    !(mhi_dev->smmu_cfg & MHI_SMMU_S1_BYPASS))
+		mhi_cntrl->iova_start = 0;
+	else
+		mhi_cntrl->iova_start = addr_win[0];
+
+	mhi_cntrl->iova_stop = mhi_dev->iova_stop;
+	mhi_cntrl->of_node = of_node;
+
+	mhi_dev->pci_dev = pci_dev;
+
+	/* setup power management apis */
+	mhi_cntrl->status_cb = mhi_status_cb;
+	mhi_cntrl->runtime_get = mhi_runtime_get;
+	mhi_cntrl->runtime_put = mhi_runtime_put;
+	mhi_cntrl->link_status = mhi_link_status;
+
+	mhi_cntrl->lpm_disable = mhi_lpm_disable;
+	mhi_cntrl->lpm_enable = mhi_lpm_enable;
+	mhi_cntrl->time_get = mhi_time_get;
+
+	ret = of_register_mhi_controller(mhi_cntrl);
+	if (ret)
+		goto error_register;
+
+	for (i = 0; i < ARRAY_SIZE(firmware_table); i++) {
+		firmware_info = firmware_table + i;
+
+		/* debug mode always use default */
+		if (!debug_mode && mhi_cntrl->dev_id == firmware_info->dev_id)
+			break;
+	}
+
+	mhi_cntrl->fw_image = firmware_info->fw_image;
+	mhi_cntrl->edl_image = firmware_info->edl_image;
+
+	if (sysfs_create_group(&mhi_cntrl->mhi_dev->dev.kobj, &mhi_group))
+		MHI_ERR("Error while creating the sysfs group\n");
+
+	return mhi_cntrl;
+
+error_register:
+	mhi_free_controller(mhi_cntrl);
+
+	return ERR_PTR(-EINVAL);
+}
+
+static int mhi_panic_handler(struct notifier_block *this,
+			     unsigned long event, void *ptr)
+{
+	int mdmreboot = 0, i;
+	struct gpio_desc *ap2mdm, *mdm2ap;
+	struct mhi_controller *mhi_cntrl = container_of(this,
+							struct mhi_controller,
+							mhi_panic_notifier);
+
+	ap2mdm = devm_gpiod_get_optional(mhi_cntrl->dev, "ap2mdm",
+					 GPIOD_OUT_LOW);
+	if (IS_ERR(ap2mdm))
+		return PTR_ERR(ap2mdm);
+
+	mdm2ap = devm_gpiod_get_optional(mhi_cntrl->dev, "mdm2ap", GPIOD_IN);
+	if (IS_ERR(mdm2ap))
+		return PTR_ERR(mdm2ap);
+
+	/*
+	 * ap2mdm_status is set to 0 to indicate the SDX
+	 * that IPQ has crashed. Now the SDX has to take
+	 * dump.
+	 */
+	gpiod_set_value(ap2mdm, 0);
+
+	if (!mhi_panic_timeout)
+		return NOTIFY_DONE;
+
+	if (mhi_panic_timeout > WDOG_TIMEOUT)
+		writel(0, wdt);
+
+	for (i = 0; i < mhi_panic_timeout; i++) {
+		/*
+		 * Waiting for the mdm2ap status to be 0
+		 * which indicates that SDX is rebooting and entering
+		 * the crashdump path.
+		 */
+		if (!mdmreboot && gpiod_get_value(mdm2ap)) {
+			MHI_LOG("MDM is rebooting to the crashdump path\n");
+			mdmreboot = 1;
+		}
+
+		/*
+		 * Waiting for the mdm2ap status to be 1
+		 * which indicates that SDX has completed crashdump
+		 * collection and booted successfully.
+		 */
+		if (mdmreboot && !(gpiod_get_value(mdm2ap))) {
+			MHI_LOG("MDM booted successfully after crashdump\n");
+			break;
+		}
+
+		mdelay(MHI_PANIC_TIMER_STEP);
+	}
+
+	if (mhi_panic_timeout > WDOG_TIMEOUT)
+		writel(1, wdt);
+
+	return NOTIFY_DONE;
+}
+
+void mhi_wdt_panic_handler(void)
+{
+	mhi_panic_handler(global_mhi_panic_notifier, 0, NULL);
+}
+EXPORT_SYMBOL(mhi_wdt_panic_handler);
+
+int __meminit mhi_pci_probe(struct pci_dev *pci_dev,
+			    const struct pci_device_id *device_id)
+{
+	struct mhi_controller *mhi_cntrl;
+	u32 domain = pci_domain_nr(pci_dev->bus);
+	u32 bus = pci_dev->bus->number;
+	u32 dev_id = pci_dev->device;
+	u32 slot = PCI_SLOT(pci_dev->devfn);
+	struct mhi_dev *mhi_dev;
+	int ret;
+	bool use_panic_notifier;
+
+	/* see if we already registered */
+	mhi_cntrl = mhi_bdf_to_controller(domain, bus, slot, dev_id);
+	if (!mhi_cntrl)
+		mhi_cntrl = mhi_register_controller(pci_dev);
+
+	if (IS_ERR(mhi_cntrl))
+		return PTR_ERR(mhi_cntrl);
+
+	mhi_dev = mhi_controller_get_devdata(mhi_cntrl);
+	mhi_dev->powered_on = true;
+
+	ret = mhi_arch_pcie_init(mhi_cntrl);
+	if (ret)
+		return ret;
+
+	mhi_cntrl->dev = &pci_dev->dev;
+	ret = mhi_init_pci_dev(mhi_cntrl);
+	if (ret)
+		goto error_init_pci;
+
+	/* start power up sequence */
+	if (!debug_mode) {
+		ret = mhi_power_up(mhi_cntrl);
+		if (ret)
+			goto error_power_up;
+	}
+
+	pm_runtime_mark_last_busy(&pci_dev->dev);
+	pm_runtime_allow(&pci_dev->dev);
+
+#ifdef CONFIG_OF
+	use_panic_notifier =
+	    of_property_read_bool(mhi_cntrl->of_node, "mhi,use-panic-notifer");
+#else
+	use_panic_notifier = true;
+#endif
+
+	if (!use_panic_notifier)
+		goto good_out;
+
+	mhi_cntrl->mhi_panic_notifier.notifier_call = mhi_panic_handler;
+	global_mhi_panic_notifier = &(mhi_cntrl->mhi_panic_notifier);
+
+	ret = atomic_notifier_chain_register(&panic_notifier_list,
+				&mhi_cntrl->mhi_panic_notifier);
+	MHI_LOG("MHI panic notifier registered\n");
+
+	wdt = ioremap(0x0B017008, 4);
+
+	/* Creating a directory in /sys/kernel/ */
+	mhi_kobj = kobject_create_and_add("mhi", kernel_kobj);
+
+	if (mhi_kobj) {
+		/* Creating sysfs file for mhi_panic_timeout */
+		if (sysfs_create_file(mhi_kobj, &mhi_attr.attr)) {
+			MHI_ERR
+			    ("Cannot create sysfs file mhi_panic_timeout\n");
+			kobject_put(mhi_kobj);
+		}
+	} else {
+		MHI_ERR("Unable to create mhi sysfs entry\n");
+	}
+
+good_out:
+	MHI_LOG("Return successful\n");
+
+	return 0;
+
+error_power_up:
+	mhi_deinit_pci_dev(mhi_cntrl);
+
+error_init_pci:
+	mhi_arch_pcie_deinit(mhi_cntrl);
+	mhi_unregister_mhi_controller(mhi_cntrl);
+	mhi_pci_probe_result = ret;
+
+	return ret;
+}
+
+void mhi_pci_device_removed(struct pci_dev *pci_dev)
+{
+	struct mhi_controller *mhi_cntrl;
+	u32 domain = pci_domain_nr(pci_dev->bus);
+	u32 bus = pci_dev->bus->number;
+	u32 dev_id = pci_dev->device;
+	u32 slot = PCI_SLOT(pci_dev->devfn);
+
+	if (mhi_kobj) {
+		sysfs_remove_file(mhi_kobj, &mhi_attr.attr);
+		kobject_del(mhi_kobj);
+	}
+
+	mhi_cntrl = mhi_bdf_to_controller(domain, bus, slot, dev_id);
+
+	if (mhi_cntrl) {
+
+		struct mhi_dev *mhi_dev = mhi_controller_get_devdata(mhi_cntrl);
+
+		pm_stay_awake(&mhi_cntrl->mhi_dev->dev);
+
+		/* if link is in drv suspend, wake it up */
+		pm_runtime_get_sync(&pci_dev->dev);
+
+		mutex_lock(&mhi_cntrl->pm_mutex);
+		if (!mhi_dev->powered_on) {
+			MHI_LOG("Not in active state\n");
+			mutex_unlock(&mhi_cntrl->pm_mutex);
+			pm_runtime_put_noidle(&pci_dev->dev);
+			return;
+		}
+		mhi_dev->powered_on = false;
+		mutex_unlock(&mhi_cntrl->pm_mutex);
+
+		pm_runtime_put_noidle(&pci_dev->dev);
+
+		MHI_LOG("Triggering shutdown process\n");
+		mhi_power_down(mhi_cntrl, false);
+
+		/* turn the link off */
+		mhi_deinit_pci_dev(mhi_cntrl);
+		mhi_arch_link_off(mhi_cntrl, false);
+
+		mhi_arch_pcie_deinit(mhi_cntrl);
+
+		pm_relax(&mhi_cntrl->mhi_dev->dev);
+
+		mhi_unregister_mhi_controller(mhi_cntrl);
+
+		mhi_free_controller(mhi_cntrl);
+	}
+}
+
+int get_mhi_pci_status(void)
+{
+	return mhi_pci_probe_result;
+}
+EXPORT_SYMBOL(get_mhi_pci_status);
+
+static const struct dev_pm_ops pm_ops = {
+	SET_RUNTIME_PM_OPS(mhi_runtime_suspend,
+			   mhi_runtime_resume,
+			   mhi_runtime_idle)
+	SET_SYSTEM_SLEEP_PM_OPS(mhi_system_suspend, mhi_system_resume)
+};
+
+static struct pci_device_id mhi_pcie_device_id[] = {
+	{ PCI_DEVICE(MHI_PCIE_VENDOR_ID, 0x0300) },
+	{ PCI_DEVICE(MHI_PCIE_VENDOR_ID, 0x0301) },
+	{ PCI_DEVICE(MHI_PCIE_VENDOR_ID, 0x0302) },
+	{ PCI_DEVICE(MHI_PCIE_VENDOR_ID, 0x0303) },
+	{ PCI_DEVICE(MHI_PCIE_VENDOR_ID, 0x0304) },
+	{ PCI_DEVICE(MHI_PCIE_VENDOR_ID, 0x0305) },
+	{ PCI_DEVICE(MHI_PCIE_VENDOR_ID, 0x0306) },
+	/* SDX55 module */
+	{ PCI_DEVICE(0x105b, 0xe0ab) },
+	{ PCI_DEVICE(0x105b, 0xe0b0) },
+	{ PCI_DEVICE(0x105b, 0xe0b1) },
+	{ PCI_DEVICE(0x105b, 0xe0b3) },
+	{ PCI_DEVICE(0x1269, 0x00b3) },  /* Thales */
+	{ PCI_DEVICE(0x03f0, 0x0a6c) },
+	{ PCI_DEVICE(MHI_PCIE_VENDOR_ID, MHI_PCIE_DEBUG_ID) },
+	{ 0 },
+};
+
+static struct pci_driver mhi_pcie_driver = {
+	.name = "mhi",
+	.id_table = mhi_pcie_device_id,
+	.probe = mhi_pci_probe,
+	.remove = mhi_pci_device_removed,
+	.driver = {
+		.pm = &pm_ops
+	}
+};
+
+static int __init mhi_pcie_init(void)
+{
+	int ret;
+
+	ret = pci_register_driver(&mhi_pcie_driver);
+	ret |= mhi_pci_probe_result;
+	if (ret) {
+		pr_err("failed to register mhi pcie driver: %d\n",
+		       ret);
+		pci_unregister_driver(&mhi_pcie_driver);
+	}
+
+	return ret;
+}
+
+module_init(mhi_pcie_init);
+
+static void __exit mhi_pcie_exit(void)
+{
+	pci_unregister_driver(&mhi_pcie_driver);
+}
+
+module_exit(mhi_pcie_exit);
+
+MODULE_AUTHOR("Qualcomm Corporation");
+MODULE_DESCRIPTION("Qualcomm Modem Host Interface Bus Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/bus/mhi/controllers/mhi_qti.h b/drivers/bus/mhi/controllers/mhi_qti.h
new file mode 100644
index 000000000000..34e6e4ad9f31
--- /dev/null
+++ b/drivers/bus/mhi/controllers/mhi_qti.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.*/
+
+#ifndef _MHI_QTI_
+#define _MHI_QTI_
+
+/* iova cfg bitmask */
+#define MHI_SMMU_ATTACH BIT(0)
+#define MHI_SMMU_S1_BYPASS BIT(1)
+#define MHI_SMMU_FAST BIT(2)
+#define MHI_SMMU_ATOMIC BIT(3)
+#define MHI_SMMU_FORCE_COHERENT BIT(4)
+
+#define MHI_PCIE_VENDOR_ID (0x17cb)
+#define MHI_PCIE_DEBUG_ID (0xffff)
+
+/* runtime suspend timer */
+#define MHI_RPM_SUSPEND_TMR_MS (250)
+#define MHI_PCI_BAR_NUM (0)
+
+struct mhi_dev {
+	struct pci_dev *pci_dev;
+	u32 smmu_cfg;
+	int resn;
+	void *arch_info;
+	bool powered_on;
+	dma_addr_t iova_start;
+	dma_addr_t iova_stop;
+	bool lpm_disabled;
+};
+
+void mhi_deinit_pci_dev(struct mhi_controller *mhi_cntrl);
+int mhi_pci_probe(struct pci_dev *pci_dev,
+		  const struct pci_device_id *device_id);
+
+void mhi_pci_device_removed(struct pci_dev *pci_dev);
+int mhi_arch_pcie_init(struct mhi_controller *mhi_cntrl);
+void mhi_arch_pcie_deinit(struct mhi_controller *mhi_cntrl);
+int mhi_arch_iommu_init(struct mhi_controller *mhi_cntrl);
+void mhi_arch_iommu_deinit(struct mhi_controller *mhi_cntrl);
+int mhi_arch_link_off(struct mhi_controller *mhi_cntrl, bool graceful);
+int mhi_arch_link_on(struct mhi_controller *mhi_cntrl);
+
+#endif /* _MHI_QTI_ */
diff --git a/drivers/bus/mhi/core/Makefile b/drivers/bus/mhi/core/Makefile
new file mode 100644
index 000000000000..b1c81f2c9ac0
--- /dev/null
+++ b/drivers/bus/mhi/core/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_MHI_BUS) += mhi.o
+mhi-y := mhi_init.o mhi_main.o mhi_pm.o mhi_boot.o mhi_dtr.o
diff --git a/drivers/bus/mhi/core/mhi_boot.c b/drivers/bus/mhi/core/mhi_boot.c
new file mode 100644
index 000000000000..c669e9ce73c1
--- /dev/null
+++ b/drivers/bus/mhi/core/mhi_boot.c
@@ -0,0 +1,590 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2018-2019, The Linux Foundation. All rights reserved. */
+
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dma-direction.h>
+#include <linux/dma-mapping.h>
+#include <linux/firmware.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/of.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/slab.h>
+#include <linux/wait.h>
+#include <linux/mhi.h>
+#include "mhi_internal.h"
+
+/* setup rddm vector table for rddm transfer */
+static void mhi_rddm_prepare(struct mhi_controller *mhi_cntrl,
+			     struct image_info *img_info)
+{
+	struct mhi_buf *mhi_buf = img_info->mhi_buf;
+	struct bhi_vec_entry *bhi_vec = img_info->bhi_vec;
+	int i = 0;
+
+	for (i = 0; i < img_info->entries - 1; i++, mhi_buf++, bhi_vec++) {
+		MHI_VERB("Setting vector:%pad size:%zu\n",
+			 &mhi_buf->dma_addr, mhi_buf->len);
+		bhi_vec->dma_addr = mhi_buf->dma_addr;
+		bhi_vec->size = mhi_buf->len;
+	}
+}
+
+/* collect rddm during kernel panic */
+static int __mhi_download_rddm_in_panic(struct mhi_controller *mhi_cntrl)
+{
+	int ret;
+	struct mhi_buf *mhi_buf;
+	u32 sequence_id;
+	u32 rx_status;
+	enum mhi_ee ee;
+	struct image_info *rddm_image = mhi_cntrl->rddm_image;
+	const u32 delayus = 2000;
+	u32 retry = (mhi_cntrl->timeout_ms * 1000) / delayus;
+	const u32 rddm_timeout_us = 200000;
+	int rddm_retry = rddm_timeout_us / delayus;	/* time to enter rddm */
+	void __iomem *base = mhi_cntrl->bhie;
+
+	MHI_LOG("Entered with pm_state:%s dev_state:%s ee:%s\n",
+		to_mhi_pm_state_str(mhi_cntrl->pm_state),
+		TO_MHI_STATE_STR(mhi_cntrl->dev_state),
+		TO_MHI_EXEC_STR(mhi_cntrl->ee));
+
+	/*
+	 * This should only be executing during a kernel panic, we expect all
+	 * other cores to shutdown while we're collecting rddm buffer. After
+	 * returning from this function, we expect device to reset.
+	 *
+	 * Normaly, we would read/write pm_state only after grabbing
+	 * pm_lock, since we're in a panic, skipping it. Also there is no
+	 * gurantee this state change would take effect since
+	 * we're setting it w/o grabbing pmlock, it's best effort
+	 */
+	mhi_cntrl->pm_state = MHI_PM_LD_ERR_FATAL_DETECT;
+	/* update should take the effect immediately */
+	smp_wmb();
+
+	/* setup the RX vector table */
+	mhi_rddm_prepare(mhi_cntrl, rddm_image);
+	mhi_buf = &rddm_image->mhi_buf[rddm_image->entries - 1];
+
+	MHI_LOG("Starting BHIe programming for RDDM\n");
+
+	mhi_write_reg(mhi_cntrl, base, BHIE_RXVECADDR_HIGH_OFFS,
+		      upper_32_bits(mhi_buf->dma_addr));
+
+	mhi_write_reg(mhi_cntrl, base, BHIE_RXVECADDR_LOW_OFFS,
+		      lower_32_bits(mhi_buf->dma_addr));
+
+	mhi_write_reg(mhi_cntrl, base, BHIE_RXVECSIZE_OFFS, mhi_buf->len);
+	sequence_id = prandom_u32() & BHIE_RXVECSTATUS_SEQNUM_BMSK;
+
+	if (unlikely(!sequence_id))
+		sequence_id = 1;
+
+	mhi_write_reg_field(mhi_cntrl, base, BHIE_RXVECDB_OFFS,
+			    BHIE_RXVECDB_SEQNUM_BMSK, BHIE_RXVECDB_SEQNUM_SHFT,
+			    sequence_id);
+
+	MHI_LOG("Trigger device into RDDM mode\n");
+	mhi_set_mhi_state(mhi_cntrl, MHI_STATE_SYS_ERR);
+
+	MHI_LOG("Waiting for device to enter RDDM\n");
+	while (rddm_retry--) {
+		ee = mhi_get_exec_env(mhi_cntrl);
+		if (ee == MHI_EE_RDDM)
+			break;
+
+		udelay(delayus);
+	}
+
+	if (rddm_retry <= 0) {
+		/* This is a hardware reset, will force device to enter rddm */
+		MHI_LOG("Did not enter RDDM, req. reset to force RDDM\n");
+		mhi_write_reg(mhi_cntrl, mhi_cntrl->regs,
+			      MHI_SOC_RESET_REQ_OFFSET, MHI_SOC_RESET_REQ);
+		udelay(delayus);
+	}
+
+	ee = mhi_get_exec_env(mhi_cntrl);
+	MHI_LOG("Waiting for image download completion, current EE:%s\n",
+		TO_MHI_EXEC_STR(ee));
+	while (retry--) {
+		ret = mhi_read_reg_field(mhi_cntrl, base, BHIE_RXVECSTATUS_OFFS,
+					 BHIE_RXVECSTATUS_STATUS_BMSK,
+					 BHIE_RXVECSTATUS_STATUS_SHFT,
+					 &rx_status);
+		if (ret)
+			return -EIO;
+
+		if (rx_status == BHIE_RXVECSTATUS_STATUS_XFER_COMPL) {
+			MHI_LOG("RDDM successfully collected\n");
+			return 0;
+		}
+
+		udelay(delayus);
+	}
+
+	ee = mhi_get_exec_env(mhi_cntrl);
+	ret = mhi_read_reg(mhi_cntrl, base, BHIE_RXVECSTATUS_OFFS, &rx_status);
+
+	MHI_ERR("Did not complete RDDM transfer\n");
+	MHI_ERR("Current EE:%s\n", TO_MHI_EXEC_STR(ee));
+	MHI_ERR("RXVEC_STATUS:0x%x, ret:%d\n", rx_status, ret);
+
+	return -EIO;
+}
+
+/* download ramdump image from device */
+int mhi_download_rddm_img(struct mhi_controller *mhi_cntrl, bool in_panic)
+{
+	void __iomem *base = mhi_cntrl->bhie;
+	rwlock_t *pm_lock = &mhi_cntrl->pm_lock;
+	struct image_info *rddm_image = mhi_cntrl->rddm_image;
+	struct mhi_buf *mhi_buf;
+	int ret;
+	u32 rx_status;
+	u32 sequence_id;
+
+	if (!rddm_image)
+		return -ENOMEM;
+
+	if (in_panic)
+		return __mhi_download_rddm_in_panic(mhi_cntrl);
+
+	MHI_LOG("Waiting for device to enter RDDM state from EE:%s\n",
+		TO_MHI_EXEC_STR(mhi_cntrl->ee));
+
+	ret = wait_event_timeout(mhi_cntrl->state_event,
+				 mhi_cntrl->ee == MHI_EE_RDDM ||
+				 MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state),
+				 msecs_to_jiffies(mhi_cntrl->timeout_ms));
+
+	if (!ret || MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state)) {
+		MHI_ERR("MHI is not in valid state, pm_state:%s ee:%s\n",
+			to_mhi_pm_state_str(mhi_cntrl->pm_state),
+			TO_MHI_EXEC_STR(mhi_cntrl->ee));
+		return -EIO;
+	}
+
+	mhi_rddm_prepare(mhi_cntrl, mhi_cntrl->rddm_image);
+
+	/* vector table is the last entry */
+	mhi_buf = &rddm_image->mhi_buf[rddm_image->entries - 1];
+
+	read_lock_bh(pm_lock);
+	if (!MHI_REG_ACCESS_VALID(mhi_cntrl->pm_state)) {
+		read_unlock_bh(pm_lock);
+		return -EIO;
+	}
+
+	MHI_LOG("Starting BHIe Programming for RDDM\n");
+
+	mhi_write_reg(mhi_cntrl, base, BHIE_RXVECADDR_HIGH_OFFS,
+		      upper_32_bits(mhi_buf->dma_addr));
+
+	mhi_write_reg(mhi_cntrl, base, BHIE_RXVECADDR_LOW_OFFS,
+		      lower_32_bits(mhi_buf->dma_addr));
+
+	mhi_write_reg(mhi_cntrl, base, BHIE_RXVECSIZE_OFFS, mhi_buf->len);
+
+	sequence_id = prandom_u32() & BHIE_RXVECSTATUS_SEQNUM_BMSK;
+	mhi_write_reg_field(mhi_cntrl, base, BHIE_RXVECDB_OFFS,
+			    BHIE_RXVECDB_SEQNUM_BMSK, BHIE_RXVECDB_SEQNUM_SHFT,
+			    sequence_id);
+	read_unlock_bh(pm_lock);
+
+	MHI_LOG("Upper:0x%x Lower:0x%x len:0x%zx sequence:%u\n",
+		upper_32_bits(mhi_buf->dma_addr),
+		lower_32_bits(mhi_buf->dma_addr), mhi_buf->len, sequence_id);
+	MHI_LOG("Waiting for image download completion\n");
+
+	/* waiting for image download completion */
+	wait_event_timeout(mhi_cntrl->state_event,
+			   MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state) ||
+			   mhi_read_reg_field(mhi_cntrl, base,
+					      BHIE_RXVECSTATUS_OFFS,
+					      BHIE_RXVECSTATUS_STATUS_BMSK,
+					      BHIE_RXVECSTATUS_STATUS_SHFT,
+					      &rx_status) || rx_status,
+			   msecs_to_jiffies(mhi_cntrl->timeout_ms));
+
+	if (MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state))
+		return -EIO;
+
+	return (rx_status == BHIE_RXVECSTATUS_STATUS_XFER_COMPL) ? 0 : -EIO;
+}
+EXPORT_SYMBOL(mhi_download_rddm_img);
+
+static int mhi_fw_load_amss(struct mhi_controller *mhi_cntrl,
+			    const struct mhi_buf *mhi_buf)
+{
+	void __iomem *base = mhi_cntrl->bhie;
+	rwlock_t *pm_lock = &mhi_cntrl->pm_lock;
+	u32 tx_status;
+
+	read_lock_bh(pm_lock);
+	if (!MHI_REG_ACCESS_VALID(mhi_cntrl->pm_state)) {
+		read_unlock_bh(pm_lock);
+		return -EIO;
+	}
+
+	MHI_LOG("Starting BHIe Programming\n");
+
+	mhi_write_reg(mhi_cntrl, base, BHIE_TXVECADDR_HIGH_OFFS,
+		      upper_32_bits(mhi_buf->dma_addr));
+
+	mhi_write_reg(mhi_cntrl, base, BHIE_TXVECADDR_LOW_OFFS,
+		      lower_32_bits(mhi_buf->dma_addr));
+
+	mhi_write_reg(mhi_cntrl, base, BHIE_TXVECSIZE_OFFS, mhi_buf->len);
+
+	mhi_cntrl->sequence_id = prandom_u32() & BHIE_TXVECSTATUS_SEQNUM_BMSK;
+	mhi_write_reg_field(mhi_cntrl, base, BHIE_TXVECDB_OFFS,
+			    BHIE_TXVECDB_SEQNUM_BMSK, BHIE_TXVECDB_SEQNUM_SHFT,
+			    mhi_cntrl->sequence_id);
+	read_unlock_bh(pm_lock);
+
+	MHI_LOG("Upper:0x%x Lower:0x%x len:0x%zx sequence:%u\n",
+		upper_32_bits(mhi_buf->dma_addr),
+		lower_32_bits(mhi_buf->dma_addr),
+		mhi_buf->len, mhi_cntrl->sequence_id);
+	MHI_LOG("Waiting for image transfer completion\n");
+
+	/* waiting for image download completion */
+	wait_event_timeout(mhi_cntrl->state_event,
+			   MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state) ||
+			   mhi_read_reg_field(mhi_cntrl, base,
+					      BHIE_TXVECSTATUS_OFFS,
+					      BHIE_TXVECSTATUS_STATUS_BMSK,
+					      BHIE_TXVECSTATUS_STATUS_SHFT,
+					      &tx_status) || tx_status,
+			   msecs_to_jiffies(mhi_cntrl->timeout_ms));
+
+	if (MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state))
+		return -EIO;
+
+	return (tx_status == BHIE_TXVECSTATUS_STATUS_XFER_COMPL) ? 0 : -EIO;
+}
+
+static int mhi_fw_load_sbl(struct mhi_controller *mhi_cntrl,
+			   dma_addr_t dma_addr, size_t size)
+{
+	u32 tx_status, val;
+	int i, ret;
+	void __iomem *base = mhi_cntrl->bhi;
+	rwlock_t *pm_lock = &mhi_cntrl->pm_lock;
+	struct {
+		char *name;
+		u32 offset;
+	} error_reg[] = {
+		{ "ERROR_CODE", BHI_ERRCODE },
+		{ "ERROR_DBG1", BHI_ERRDBG1 },
+		{ "ERROR_DBG2", BHI_ERRDBG2 },
+		{ "ERROR_DBG3", BHI_ERRDBG3 },
+		{ NULL },
+	};
+
+	MHI_LOG("Starting BHI programming\n");
+
+	/* program start sbl download via  bhi protocol */
+	read_lock_bh(pm_lock);
+	if (!MHI_REG_ACCESS_VALID(mhi_cntrl->pm_state)) {
+		read_unlock_bh(pm_lock);
+		goto invalid_pm_state;
+	}
+
+	mhi_write_reg(mhi_cntrl, base, BHI_STATUS, 0);
+	mhi_write_reg(mhi_cntrl, base, BHI_IMGADDR_HIGH,
+		      upper_32_bits(dma_addr));
+	mhi_write_reg(mhi_cntrl, base, BHI_IMGADDR_LOW,
+		      lower_32_bits(dma_addr));
+	mhi_write_reg(mhi_cntrl, base, BHI_IMGSIZE, size);
+	mhi_cntrl->session_id = prandom_u32() & BHI_TXDB_SEQNUM_BMSK;
+	mhi_write_reg(mhi_cntrl, base, BHI_IMGTXDB, mhi_cntrl->session_id);
+	read_unlock_bh(pm_lock);
+
+	MHI_LOG("Waiting for image transfer completion\n");
+
+	/* waiting for image download completion */
+	wait_event_timeout(mhi_cntrl->state_event,
+			   MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state) ||
+			   mhi_read_reg_field(mhi_cntrl, base, BHI_STATUS,
+					      BHI_STATUS_MASK, BHI_STATUS_SHIFT,
+					      &tx_status) || tx_status,
+			   msecs_to_jiffies(mhi_cntrl->timeout_ms));
+	if (MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state))
+		goto invalid_pm_state;
+
+	if (tx_status == BHI_STATUS_ERROR) {
+		MHI_ERR("Image transfer failed\n");
+		read_lock_bh(pm_lock);
+		if (MHI_REG_ACCESS_VALID(mhi_cntrl->pm_state)) {
+			for (i = 0; error_reg[i].name; i++) {
+				ret = mhi_read_reg(mhi_cntrl, base,
+						   error_reg[i].offset, &val);
+				if (ret)
+					break;
+				MHI_ERR("reg:%s value:0x%x\n",
+					error_reg[i].name, val);
+			}
+		}
+		read_unlock_bh(pm_lock);
+		goto invalid_pm_state;
+	}
+
+	return (tx_status == BHI_STATUS_SUCCESS) ? 0 : -ETIMEDOUT;
+
+invalid_pm_state:
+
+	return -EIO;
+}
+
+void mhi_free_bhie_table(struct mhi_controller *mhi_cntrl,
+			 struct image_info *image_info)
+{
+	int i;
+	struct mhi_buf *mhi_buf = image_info->mhi_buf;
+
+	for (i = 0; i < image_info->entries; i++, mhi_buf++)
+		mhi_free_coherent(mhi_cntrl, mhi_buf->len, mhi_buf->buf,
+				  mhi_buf->dma_addr);
+
+	kfree(image_info->mhi_buf);
+	kfree(image_info);
+}
+
+int mhi_alloc_bhie_table(struct mhi_controller *mhi_cntrl,
+			 struct image_info **image_info, size_t alloc_size)
+{
+	size_t seg_size = mhi_cntrl->seg_len;
+	/* requier additional entry for vec table */
+	int segments = DIV_ROUND_UP(alloc_size, seg_size) + 1;
+	int i;
+	struct image_info *img_info;
+	struct mhi_buf *mhi_buf;
+
+	MHI_LOG("Allocating bytes:%zu seg_size:%zu total_seg:%u\n",
+		alloc_size, seg_size, segments);
+
+	img_info = kzalloc(sizeof(*img_info), GFP_KERNEL);
+	if (!img_info)
+		return -ENOMEM;
+
+	/* allocate memory for entries */
+	img_info->mhi_buf = kcalloc(segments, sizeof(*img_info->mhi_buf),
+				    GFP_KERNEL);
+	if (!img_info->mhi_buf)
+		goto error_alloc_mhi_buf;
+
+	/* allocate and populate vector table */
+	mhi_buf = img_info->mhi_buf;
+	for (i = 0; i < segments; i++, mhi_buf++) {
+		size_t vec_size = seg_size;
+
+		/* last entry is for vector table */
+		if (i == segments - 1)
+			vec_size = sizeof(struct bhi_vec_entry) * i;
+
+		mhi_buf->len = vec_size;
+		mhi_buf->buf = mhi_alloc_coherent(mhi_cntrl, vec_size,
+						  &mhi_buf->dma_addr,
+						  GFP_KERNEL);
+		if (!mhi_buf->buf)
+			goto error_alloc_segment;
+
+		MHI_LOG("Entry:%d Address:0x%llx size:%zu\n", i,
+			(unsigned long long)mhi_buf->dma_addr, mhi_buf->len);
+	}
+
+	img_info->bhi_vec = img_info->mhi_buf[segments - 1].buf;
+	img_info->entries = segments;
+	*image_info = img_info;
+
+	MHI_LOG("Successfully allocated bhi vec table\n");
+
+	return 0;
+
+error_alloc_segment:
+	for (--i, --mhi_buf; i >= 0; i--, mhi_buf--)
+		mhi_free_coherent(mhi_cntrl, mhi_buf->len, mhi_buf->buf,
+				  mhi_buf->dma_addr);
+
+error_alloc_mhi_buf:
+	kfree(img_info);
+
+	return -ENOMEM;
+}
+
+static void mhi_firmware_copy(struct mhi_controller *mhi_cntrl,
+			      const struct firmware *firmware,
+			      struct image_info *img_info)
+{
+	size_t remainder = firmware->size;
+	size_t to_cpy;
+	const u8 *buf = firmware->data;
+	int i = 0;
+	struct mhi_buf *mhi_buf = img_info->mhi_buf;
+	struct bhi_vec_entry *bhi_vec = img_info->bhi_vec;
+
+	while (remainder) {
+		MHI_ASSERT(i >= img_info->entries, "malformed vector table");
+
+		to_cpy = min(remainder, mhi_buf->len);
+		memcpy(mhi_buf->buf, buf, to_cpy);
+		bhi_vec->dma_addr = mhi_buf->dma_addr;
+		bhi_vec->size = to_cpy;
+
+		MHI_VERB("Setting Vector:0x%llx size: %llu\n",
+			 bhi_vec->dma_addr, bhi_vec->size);
+		buf += to_cpy;
+		remainder -= to_cpy;
+		i++;
+		bhi_vec++;
+		mhi_buf++;
+	}
+}
+
+void mhi_fw_load_worker(struct work_struct *work)
+{
+	int ret;
+	struct mhi_controller *mhi_cntrl;
+	const char *fw_name;
+	const struct firmware *firmware;
+	struct image_info *image_info;
+	void *buf;
+	dma_addr_t dma_addr;
+	size_t size;
+
+	mhi_cntrl = container_of(work, struct mhi_controller, fw_worker);
+
+	MHI_LOG("Waiting for device to enter PBL from EE:%s\n",
+		TO_MHI_EXEC_STR(mhi_cntrl->ee));
+
+	ret = wait_event_timeout(mhi_cntrl->state_event,
+				 MHI_IN_PBL(mhi_cntrl->ee) ||
+				 MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state),
+				 msecs_to_jiffies(mhi_cntrl->timeout_ms));
+
+	if (!ret || MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state)) {
+		MHI_ERR("MHI is not in valid state\n");
+		return;
+	}
+
+	MHI_LOG("Device current EE:%s\n", TO_MHI_EXEC_STR(mhi_cntrl->ee));
+
+	/* if device in pthru, we do not have to load firmware */
+	if (mhi_cntrl->ee == MHI_EE_PTHRU)
+		return;
+
+	fw_name = (mhi_cntrl->ee == MHI_EE_EDL) ?
+		mhi_cntrl->edl_image : mhi_cntrl->fw_image;
+
+	if (!fw_name || (mhi_cntrl->fbc_download && (!mhi_cntrl->sbl_size ||
+						     !mhi_cntrl->seg_len))) {
+		MHI_ERR("No firmware image defined or !sbl_size || !seg_len\n");
+		return;
+	}
+
+	ret = request_firmware(&firmware, fw_name, mhi_cntrl->dev);
+	if (ret) {
+		MHI_ERR("Error loading firmware, ret:%d\n", ret);
+		return;
+	}
+
+	size = (mhi_cntrl->fbc_download) ? mhi_cntrl->sbl_size : firmware->size;
+
+	/* the sbl size provided is maximum size, not necessarily image size */
+	if (size > firmware->size)
+		size = firmware->size;
+
+	buf = mhi_alloc_coherent(mhi_cntrl, size, &dma_addr, GFP_KERNEL);
+	if (!buf) {
+		MHI_ERR("Could not allocate memory for image\n");
+		release_firmware(firmware);
+		return;
+	}
+
+	/* load sbl image */
+	memcpy(buf, firmware->data, size);
+	ret = mhi_fw_load_sbl(mhi_cntrl, dma_addr, size);
+	mhi_free_coherent(mhi_cntrl, size, buf, dma_addr);
+
+	if (!mhi_cntrl->fbc_download || ret || mhi_cntrl->ee == MHI_EE_EDL)
+		release_firmware(firmware);
+
+	/* error or in edl, we're done */
+	if (ret || mhi_cntrl->ee == MHI_EE_EDL)
+		return;
+
+	write_lock_irq(&mhi_cntrl->pm_lock);
+	mhi_cntrl->dev_state = MHI_STATE_RESET;
+	write_unlock_irq(&mhi_cntrl->pm_lock);
+
+	/*
+	 * if we're doing fbc, populate vector tables while
+	 * device transitioning into MHI READY state
+	 */
+	if (mhi_cntrl->fbc_download) {
+		ret = mhi_alloc_bhie_table(mhi_cntrl, &mhi_cntrl->fbc_image,
+					   firmware->size);
+		if (ret) {
+			MHI_ERR("Error alloc size of %zu\n", firmware->size);
+			goto error_alloc_fw_table;
+		}
+
+		MHI_LOG("Copying firmware image into vector table\n");
+
+		/* load the firmware into BHIE vec table */
+		mhi_firmware_copy(mhi_cntrl, firmware, mhi_cntrl->fbc_image);
+	}
+
+	/* transitioning into MHI RESET->READY state */
+	ret = mhi_ready_state_transition(mhi_cntrl);
+
+	MHI_LOG("To Reset->Ready PM_STATE:%s MHI_STATE:%s EE:%s, ret:%d\n",
+		to_mhi_pm_state_str(mhi_cntrl->pm_state),
+		TO_MHI_STATE_STR(mhi_cntrl->dev_state),
+		TO_MHI_EXEC_STR(mhi_cntrl->ee), ret);
+
+	if (!mhi_cntrl->fbc_download)
+		return;
+
+	if (ret) {
+		MHI_ERR("Did not transition to READY state\n");
+		goto error_read;
+	}
+
+	/* wait for SBL event */
+	ret = wait_event_timeout(mhi_cntrl->state_event,
+				 mhi_cntrl->ee == MHI_EE_SBL ||
+				 MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state),
+				 msecs_to_jiffies(mhi_cntrl->timeout_ms));
+
+	if (!ret || MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state)) {
+		MHI_ERR("MHI did not enter BHIE\n");
+		goto error_read;
+	}
+
+	/* start full firmware image download */
+	image_info = mhi_cntrl->fbc_image;
+	ret = mhi_fw_load_amss(mhi_cntrl,
+			       /* last entry is vec table */
+			       &image_info->mhi_buf[image_info->entries - 1]);
+
+	MHI_LOG("amss fw_load, ret:%d\n", ret);
+
+	release_firmware(firmware);
+
+	return;
+
+error_read:
+	mhi_free_bhie_table(mhi_cntrl, mhi_cntrl->fbc_image);
+	mhi_cntrl->fbc_image = NULL;
+
+error_alloc_fw_table:
+	release_firmware(firmware);
+}
diff --git a/drivers/bus/mhi/core/mhi_dtr.c b/drivers/bus/mhi/core/mhi_dtr.c
new file mode 100644
index 000000000000..e6f07d4cc329
--- /dev/null
+++ b/drivers/bus/mhi/core/mhi_dtr.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.*/
+
+#include <linux/debugfs.h>
+#include <linux/device.h>
+#include <linux/dma-direction.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/of.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/termios.h>
+#include <linux/wait.h>
+#include <linux/mhi.h>
+#include "mhi_internal.h"
+
+struct __packed dtr_ctrl_msg {
+	u32 preamble;
+	u32 msg_id;
+	u32 dest_id;
+	u32 size;
+	u32 msg;
+};
+
+#define CTRL_MAGIC (0x4C525443)
+#define CTRL_MSG_DTR BIT(0)
+#define CTRL_MSG_RTS BIT(1)
+#define CTRL_MSG_DCD BIT(0)
+#define CTRL_MSG_DSR BIT(1)
+#define CTRL_MSG_RI BIT(3)
+#define CTRL_HOST_STATE (0x10)
+#define CTRL_DEVICE_STATE (0x11)
+#define CTRL_GET_CHID(dtr) (dtr->dest_id & 0xFF)
+
+static int mhi_dtr_tiocmset(struct mhi_controller *mhi_cntrl,
+			    struct mhi_device *mhi_dev, u32 tiocm)
+{
+	struct dtr_ctrl_msg *dtr_msg = NULL;
+	struct mhi_chan *dtr_chan = mhi_cntrl->dtr_dev->ul_chan;
+	spinlock_t *res_lock = &mhi_dev->dev.devres_lock;
+	u32 cur_tiocm;
+	int ret = 0;
+
+	cur_tiocm = mhi_dev->tiocm & ~(TIOCM_CD | TIOCM_DSR | TIOCM_RI);
+
+	tiocm &= (TIOCM_DTR | TIOCM_RTS);
+
+	/* state did not changed */
+	if (cur_tiocm == tiocm)
+		return 0;
+
+	mutex_lock(&dtr_chan->mutex);
+
+	dtr_msg = kzalloc(sizeof(*dtr_msg), GFP_KERNEL);
+	if (!dtr_msg) {
+		ret = -ENOMEM;
+		goto tiocm_exit;
+	}
+
+	dtr_msg->preamble = CTRL_MAGIC;
+	dtr_msg->msg_id = CTRL_HOST_STATE;
+	dtr_msg->dest_id = mhi_dev->ul_chan_id;
+	dtr_msg->size = sizeof(u32);
+	if (tiocm & TIOCM_DTR)
+		dtr_msg->msg |= CTRL_MSG_DTR;
+	if (tiocm & TIOCM_RTS)
+		dtr_msg->msg |= CTRL_MSG_RTS;
+
+	reinit_completion(&dtr_chan->completion);
+	ret = mhi_queue_transfer(mhi_cntrl->dtr_dev, DMA_TO_DEVICE, dtr_msg,
+				 sizeof(*dtr_msg), MHI_EOT);
+	if (ret)
+		goto tiocm_exit;
+
+	ret = wait_for_completion_timeout(&dtr_chan->completion,
+				msecs_to_jiffies(mhi_cntrl->timeout_ms));
+	if (!ret) {
+		MHI_ERR("Failed to receive transfer callback\n");
+		ret = -EIO;
+		goto tiocm_exit;
+	}
+
+	ret = 0;
+	spin_lock_irq(res_lock);
+	mhi_dev->tiocm &= ~(TIOCM_DTR | TIOCM_RTS);
+	mhi_dev->tiocm |= tiocm;
+	spin_unlock_irq(res_lock);
+
+tiocm_exit:
+	kfree(dtr_msg);
+	mutex_unlock(&dtr_chan->mutex);
+
+	return ret;
+}
+
+long mhi_ioctl(struct mhi_device *mhi_dev, unsigned int cmd, unsigned long arg)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	int ret;
+
+	/* ioctl not supported by this controller */
+	if (!mhi_cntrl->dtr_dev)
+		return -EIO;
+
+	switch (cmd) {
+	case TIOCMGET:
+		return mhi_dev->tiocm;
+	case TIOCMSET:
+		{
+			u32 tiocm;
+
+			ret = get_user(tiocm, (u32 *) arg);
+			if (ret)
+				return ret;
+
+			return mhi_dtr_tiocmset(mhi_cntrl, mhi_dev, tiocm);
+		}
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(mhi_ioctl);
+
+static void mhi_dtr_dl_xfer_cb(struct mhi_device *mhi_dev,
+			       struct mhi_result *mhi_result)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct dtr_ctrl_msg *dtr_msg = mhi_result->buf_addr;
+	u32 chan;
+	spinlock_t *res_lock;
+
+	if (mhi_result->bytes_xferd != sizeof(*dtr_msg)) {
+		MHI_ERR("Unexpected length %zu received\n",
+			mhi_result->bytes_xferd);
+		return;
+	}
+
+	MHI_VERB("preamble:0x%x msg_id:%u dest_id:%u msg:0x%x\n",
+		 dtr_msg->preamble, dtr_msg->msg_id, dtr_msg->dest_id,
+		 dtr_msg->msg);
+
+	chan = CTRL_GET_CHID(dtr_msg);
+	if (chan >= mhi_cntrl->max_chan)
+		return;
+
+	mhi_dev = mhi_cntrl->mhi_chan[chan].mhi_dev;
+	if (!mhi_dev)
+		return;
+
+	res_lock = &mhi_dev->dev.devres_lock;
+	spin_lock_irq(res_lock);
+	mhi_dev->tiocm &= ~(TIOCM_CD | TIOCM_DSR | TIOCM_RI);
+
+	if (dtr_msg->msg & CTRL_MSG_DCD)
+		mhi_dev->tiocm |= TIOCM_CD;
+
+	if (dtr_msg->msg & CTRL_MSG_DSR)
+		mhi_dev->tiocm |= TIOCM_DSR;
+
+	if (dtr_msg->msg & CTRL_MSG_RI)
+		mhi_dev->tiocm |= TIOCM_RI;
+	spin_unlock_irq(res_lock);
+}
+
+static void mhi_dtr_ul_xfer_cb(struct mhi_device *mhi_dev,
+			       struct mhi_result *mhi_result)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_chan *dtr_chan = mhi_cntrl->dtr_dev->ul_chan;
+
+	MHI_VERB("Received with status:%d\n", mhi_result->transaction_status);
+	if (!mhi_result->transaction_status)
+		complete(&dtr_chan->completion);
+}
+
+static void mhi_dtr_remove(struct mhi_device *mhi_dev)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+
+	mhi_cntrl->dtr_dev = NULL;
+}
+
+static int mhi_dtr_probe(struct mhi_device *mhi_dev,
+			 const struct mhi_device_id *id)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	int ret;
+
+	MHI_LOG("Enter for DTR control channel\n");
+
+	ret = mhi_prepare_for_transfer(mhi_dev);
+	if (!ret)
+		mhi_cntrl->dtr_dev = mhi_dev;
+
+	MHI_LOG("Exit with ret:%d\n", ret);
+
+	return ret;
+}
+
+static const struct mhi_device_id mhi_dtr_table[] = {
+	{ .chan = "IP_CTRL" },
+	{ },
+};
+
+static struct mhi_driver mhi_dtr_driver = {
+	.id_table = mhi_dtr_table,
+	.remove = mhi_dtr_remove,
+	.probe = mhi_dtr_probe,
+	.ul_xfer_cb = mhi_dtr_ul_xfer_cb,
+	.dl_xfer_cb = mhi_dtr_dl_xfer_cb,
+	.driver = {
+		.name = "MHI_DTR",
+		.owner = THIS_MODULE,
+	}
+};
+
+int __init mhi_dtr_init(void)
+{
+	return mhi_driver_register(&mhi_dtr_driver);
+}
diff --git a/drivers/bus/mhi/core/mhi_init.c b/drivers/bus/mhi/core/mhi_init.c
new file mode 100644
index 000000000000..ec6103eb66ed
--- /dev/null
+++ b/drivers/bus/mhi/core/mhi_init.c
@@ -0,0 +1,1901 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2018-2019, The Linux Foundation. All rights reserved. */
+
+#include <linux/debugfs.h>
+#include <linux/device.h>
+#include <linux/dma-direction.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/of.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/wait.h>
+#include <linux/mhi.h>
+#include "mhi_internal.h"
+
+const char *const mhi_ee_str[MHI_EE_MAX] = {
+	[MHI_EE_PBL]   = "PBL",
+	[MHI_EE_SBL]   = "SBL",
+	[MHI_EE_AMSS]  = "AMSS",
+	[MHI_EE_RDDM]  = "RDDM",
+	[MHI_EE_WFW]   = "WFW",
+	[MHI_EE_PTHRU] = "PASS THRU",
+	[MHI_EE_EDL]   = "EDL",
+	[MHI_EE_DISABLE_TRANSITION] = "DISABLE",
+};
+
+const char *const mhi_state_tran_str[MHI_ST_TRANSITION_MAX] = {
+	[MHI_ST_TRANSITION_PBL]   = "PBL",
+	[MHI_ST_TRANSITION_READY] = "READY",
+	[MHI_ST_TRANSITION_SBL]   = "SBL",
+	[MHI_ST_TRANSITION_MISSION_MODE] = "MISSION MODE",
+};
+
+const char *const mhi_state_str[MHI_STATE_MAX] = {
+	[MHI_STATE_RESET]   = "RESET",
+	[MHI_STATE_READY]   = "READY",
+	[MHI_STATE_M0]      = "M0",
+	[MHI_STATE_M1]      = "M1",
+	[MHI_STATE_M2]      = "M2",
+	[MHI_STATE_M3]      = "M3",
+	[MHI_STATE_BHI]     = "BHI",
+	[MHI_STATE_SYS_ERR] = "SYS_ERR",
+};
+
+static const char *const mhi_pm_state_str[] = {
+	[MHI_PM_BIT_DISABLE]   = "DISABLE",
+	[MHI_PM_BIT_POR]       = "POR",
+	[MHI_PM_BIT_M0]        = "M0",
+	[MHI_PM_BIT_M2]        = "M2",
+	[MHI_PM_BIT_M3_ENTER]  = "M?->M3",
+	[MHI_PM_BIT_M3]        = "M3",
+	[MHI_PM_BIT_M3_EXIT]   = "M3->M0",
+	[MHI_PM_BIT_FW_DL_ERR] = "FW DL Error",
+	[MHI_PM_BIT_SYS_ERR_DETECT]      = "SYS_ERR Detect",
+	[MHI_PM_BIT_SYS_ERR_PROCESS]     = "SYS_ERR Process",
+	[MHI_PM_BIT_SHUTDOWN_PROCESS]    = "SHUTDOWN Process",
+	[MHI_PM_BIT_LD_ERR_FATAL_DETECT] = "LD or Error Fatal Detect",
+};
+
+#ifndef CONFIG_OF
+struct mhi_chan_init {
+	u32 chan;
+	const char *name;
+	size_t tre_ring_elements;
+	size_t buf_ring_elements;
+	u32 er_index;
+	enum dma_data_direction dir;
+	u32 ee_mask;
+	u32 pollcfg;
+	enum MHI_XFER_TYPE xfer_type;
+	bool lpm_notify;
+	bool offload_ch;
+	bool reset_req;
+	bool pre_alloc;
+	bool auto_start;
+	bool wake_capable;
+	enum MHI_BRSTMODE brstmode;
+};
+
+struct mhi_chan_init mhi_chan_init_array[] = {
+	{ 0,   "LOOPBACK",    64, 0, 2, 1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 2 },
+	{ 1,   "LOOPBACK",    64, 0, 2, 2, 4, 0, 0, 0, 0, 0, 0, 0, 0, 2 },
+	{ 4,   "DIAG",        64, 0, 1, 1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 2 },
+	{ 5,   "DIAG",        64, 0, 3, 2, 4, 0, 0, 0, 0, 0, 0, 0, 0, 2 },
+#ifdef CONFIG_MHI_MBIM
+	{ 12,  "MBIM",        64, 0, 3, 1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 2 },
+	{ 13,  "MBIM",        64, 0, 3, 2, 4, 0, 0, 0, 0, 0, 0, 0, 0, 2 },
+#endif
+	{ 14,  "QMI0",        64, 0, 1, 1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 2 },
+	{ 15,  "QMI0",        64, 0, 2, 2, 4, 0, 0, 0, 0, 0, 0, 0, 0, 2 },
+	{ 16,  "QMI1",        64, 0, 3, 1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 2 },
+	{ 17,  "QMI1",        64, 0, 3, 2, 4, 0, 0, 0, 0, 0, 0, 0, 0, 2 },
+	{ 18,  "IP_CTRL",     64, 0, 1, 1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 2 },
+	{ 19,  "IP_CTRL",     64, 0, 1, 2, 4, 0, 0, 0, 0, 0, 1, 0, 0, 2 },
+	{ 20,  "IPCR",        64, 0, 2, 1, 4, 0, 1, 0, 0, 0, 0, 1, 0, 2 },
+	{ 21,  "IPCR",        64, 0, 2, 2, 4, 0, 0, 0, 0, 0, 1, 1, 0, 2 },
+	{ 32,  "AT",          64, 0, 3, 1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 2 },
+	{ 33,  "AT",          64, 0, 3, 2, 4, 0, 0, 0, 0, 0, 0, 0, 0, 2 },
+	{ 46,  "IP_SW0",     512, 0, 4, 1, 4, 0, 1, 0, 0, 0, 0, 0, 0, 2 },
+	{ 47,  "IP_SW0",     512, 0, 5, 2, 4, 0, 4, 0, 0, 0, 0, 0, 0, 2 },
+	{ 100, "IP_HW0",     512, 0, 6, 1, 4, 0, 1, 0, 0, 1, 0, 0, 0, 3 },
+	{ 101, "IP_HW0",     512, 0, 7, 2, 4, 0, 4, 0, 0, 0, 0, 0, 0, 3 },
+	{ 102, "IP_HW_ADPL",   0, 0, 8, 2, 4, 0, 3, 1, 1, 0, 0, 0, 0, 0 },
+};
+
+struct mhi_event_init {
+	size_t elements;
+	u32 intmod;
+	u32 msi;
+	int chan;
+	u32 priority;
+	enum MHI_BRSTMODE brstmode;
+	enum mhi_er_data_type data_type;
+	bool hw_ring;
+	bool cl_manage;
+	bool offload_ev;
+};
+
+struct mhi_event_init mhi_event_init_array[] = {
+	{   32, 1, 1,   0, 1, 2, 1, 0, 0, 0 },
+	{  256, 1, 2,   0, 1, 2, 0, 0, 0, 0 },
+	{  256, 1, 3,   0, 1, 2, 0, 0, 0, 0 },
+	{  256, 1, 4,   0, 1, 2, 0, 0, 0, 0 },
+	{ 1024, 5, 5,  46, 1, 2, 0, 0, 0, 0 },
+	{ 1024, 5, 6,  47, 1, 2, 0, 0, 1, 0 },
+	{ 1024, 5, 5, 100, 1, 3, 0, 1, 0, 0 },
+	{ 1024, 5, 6, 101, 1, 3, 0, 1, 1, 0 },
+	{    0, 0, 0, 102, 1, 3, 0, 1, 1, 1 },
+	{ 1024, 5, 7, 103, 1, 2, 0, 1, 0, 0 },
+	{    0, 0, 0, 105, 1, 3, 0, 1, 1, 1 },
+	{    0, 0, 0, 106, 1, 3, 0, 1, 1, 1 },
+	{    0, 0, 0, 107, 1, 3, 0, 1, 1, 1 },
+	{    0, 0, 0, 108, 1, 3, 0, 1, 1, 1 },
+};
+#endif
+
+struct mhi_bus mhi_bus;
+
+const char *to_mhi_pm_state_str(enum MHI_PM_STATE state)
+{
+	int index = find_last_bit((unsigned long *)&state, 32);
+
+	if (index >= ARRAY_SIZE(mhi_pm_state_str))
+		return "Invalid State";
+
+	return mhi_pm_state_str[index];
+}
+
+/* MHI protocol require transfer ring to be aligned to ring length */
+static int mhi_alloc_aligned_ring(struct mhi_controller *mhi_cntrl,
+				  struct mhi_ring *ring, u64 len)
+{
+	ring->alloc_size = len + (len - 1);
+	ring->pre_aligned = mhi_alloc_coherent(mhi_cntrl, ring->alloc_size,
+					       &ring->dma_handle, GFP_KERNEL);
+	if (!ring->pre_aligned)
+		return -ENOMEM;
+
+	ring->iommu_base = (ring->dma_handle + (len - 1)) & ~(len - 1);
+	ring->base = ring->pre_aligned + (ring->iommu_base - ring->dma_handle);
+	return 0;
+}
+
+void mhi_deinit_free_irq(struct mhi_controller *mhi_cntrl)
+{
+	int i;
+	struct mhi_event *mhi_event = mhi_cntrl->mhi_event;
+
+	for (i = 0; i < mhi_cntrl->total_ev_rings; i++, mhi_event++) {
+		if (mhi_event->offload_ev)
+			continue;
+
+		free_irq(mhi_cntrl->irq[mhi_event->msi], mhi_event);
+	}
+
+	free_irq(mhi_cntrl->irq[0], mhi_cntrl);
+}
+
+int mhi_init_irq_setup(struct mhi_controller *mhi_cntrl)
+{
+	int i;
+	int ret;
+	struct mhi_event *mhi_event = mhi_cntrl->mhi_event;
+	unsigned long irqflags =
+	    (mhi_cntrl->msi_allocated > 1) ? IRQF_ONESHOT : IRQF_SHARED;
+
+	/* for BHI INTVEC msi */
+	ret = request_threaded_irq(mhi_cntrl->irq[0], mhi_intvec_handlr,
+				   mhi_intvec_threaded_handlr, irqflags,
+				   "mhi", mhi_cntrl);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < mhi_cntrl->total_ev_rings; i++, mhi_event++) {
+		if (mhi_event->offload_ev)
+			continue;
+
+		if (mhi_cntrl->msi_allocated == 1)
+			mhi_event->msi = 0;
+
+		ret = request_irq(mhi_cntrl->irq[mhi_event->msi],
+				  mhi_msi_handlr, IRQF_SHARED, "mhi",
+				  mhi_event);
+		if (ret) {
+			MHI_ERR("Error requesting irq:%d for ev:%d\n",
+				mhi_cntrl->irq[mhi_event->msi], i);
+			goto error_request;
+		}
+	}
+
+	return 0;
+
+error_request:
+	for (--i, --mhi_event; i >= 0; i--, mhi_event--) {
+		if (mhi_event->offload_ev)
+			continue;
+
+		free_irq(mhi_cntrl->irq[mhi_event->msi], mhi_event);
+	}
+	free_irq(mhi_cntrl->irq[0], mhi_cntrl);
+
+	return ret;
+}
+
+void mhi_deinit_dev_ctxt(struct mhi_controller *mhi_cntrl)
+{
+	int i;
+	struct mhi_ctxt *mhi_ctxt = mhi_cntrl->mhi_ctxt;
+	struct mhi_cmd *mhi_cmd;
+	struct mhi_event *mhi_event;
+	struct mhi_ring *ring;
+
+	mhi_cmd = mhi_cntrl->mhi_cmd;
+	for (i = 0; i < NR_OF_CMD_RINGS; i++, mhi_cmd++) {
+		ring = &mhi_cmd->ring;
+		mhi_free_coherent(mhi_cntrl, ring->alloc_size,
+				  ring->pre_aligned, ring->dma_handle);
+		ring->base = NULL;
+		ring->iommu_base = 0;
+	}
+
+	mhi_free_coherent(mhi_cntrl,
+			  sizeof(*mhi_ctxt->cmd_ctxt) * NR_OF_CMD_RINGS,
+			  mhi_ctxt->cmd_ctxt, mhi_ctxt->cmd_ctxt_addr);
+
+	mhi_event = mhi_cntrl->mhi_event;
+	for (i = 0; i < mhi_cntrl->total_ev_rings; i++, mhi_event++) {
+		if (mhi_event->offload_ev)
+			continue;
+
+		ring = &mhi_event->ring;
+		mhi_free_coherent(mhi_cntrl, ring->alloc_size,
+				  ring->pre_aligned, ring->dma_handle);
+		ring->base = NULL;
+		ring->iommu_base = 0;
+	}
+
+	mhi_free_coherent(mhi_cntrl, sizeof(*mhi_ctxt->er_ctxt) *
+			  mhi_cntrl->total_ev_rings, mhi_ctxt->er_ctxt,
+			  mhi_ctxt->er_ctxt_addr);
+
+	mhi_free_coherent(mhi_cntrl, sizeof(*mhi_ctxt->chan_ctxt) *
+			  mhi_cntrl->max_chan, mhi_ctxt->chan_ctxt,
+			  mhi_ctxt->chan_ctxt_addr);
+
+	kfree(mhi_ctxt);
+	mhi_cntrl->mhi_ctxt = NULL;
+}
+
+static int mhi_init_debugfs_mhi_states_open(struct inode *inode,
+					    struct file *fp)
+{
+	return single_open(fp, mhi_debugfs_mhi_states_show, inode->i_private);
+}
+
+static int mhi_init_debugfs_mhi_event_open(struct inode *inode, struct file *fp)
+{
+	return single_open(fp, mhi_debugfs_mhi_event_show, inode->i_private);
+}
+
+static int mhi_init_debugfs_mhi_chan_open(struct inode *inode, struct file *fp)
+{
+	return single_open(fp, mhi_debugfs_mhi_chan_show, inode->i_private);
+}
+
+static const struct file_operations debugfs_state_ops = {
+	.open = mhi_init_debugfs_mhi_states_open,
+	.release = single_release,
+	.read = seq_read,
+};
+
+static const struct file_operations debugfs_ev_ops = {
+	.open = mhi_init_debugfs_mhi_event_open,
+	.release = single_release,
+	.read = seq_read,
+};
+
+static const struct file_operations debugfs_chan_ops = {
+	.open = mhi_init_debugfs_mhi_chan_open,
+	.release = single_release,
+	.read = seq_read,
+};
+
+DEFINE_SIMPLE_ATTRIBUTE(debugfs_trigger_reset_fops, NULL,
+			mhi_debugfs_trigger_reset, "%llu\n");
+
+void mhi_init_debugfs(struct mhi_controller *mhi_cntrl)
+{
+	struct dentry *dentry;
+	char node[32];
+
+	if (!mhi_cntrl->parent)
+		return;
+
+	snprintf(node, sizeof(node), "%04x_%02u:%02u.%02u",
+		 mhi_cntrl->dev_id, mhi_cntrl->domain, mhi_cntrl->bus,
+		 mhi_cntrl->slot);
+
+	dentry = debugfs_create_dir(node, mhi_cntrl->parent);
+	if (IS_ERR_OR_NULL(dentry))
+		return;
+
+	debugfs_create_file("states", 0444, dentry, mhi_cntrl,
+			    &debugfs_state_ops);
+	debugfs_create_file("events", 0444, dentry, mhi_cntrl, &debugfs_ev_ops);
+	debugfs_create_file("chan", 0444, dentry, mhi_cntrl, &debugfs_chan_ops);
+	debugfs_create_file("reset", 0444, dentry, mhi_cntrl,
+			    &debugfs_trigger_reset_fops);
+	mhi_cntrl->dentry = dentry;
+}
+
+void mhi_deinit_debugfs(struct mhi_controller *mhi_cntrl)
+{
+	debugfs_remove_recursive(mhi_cntrl->dentry);
+	mhi_cntrl->dentry = NULL;
+}
+
+int mhi_init_dev_ctxt(struct mhi_controller *mhi_cntrl)
+{
+	struct mhi_ctxt *mhi_ctxt;
+	struct mhi_chan_ctxt *chan_ctxt;
+	struct mhi_event_ctxt *er_ctxt;
+	struct mhi_cmd_ctxt *cmd_ctxt;
+	struct mhi_chan *mhi_chan;
+	struct mhi_event *mhi_event;
+	struct mhi_cmd *mhi_cmd;
+	int ret = -ENOMEM, i;
+
+	atomic_set(&mhi_cntrl->dev_wake, 0);
+	atomic_set(&mhi_cntrl->alloc_size, 0);
+
+	mhi_ctxt = kzalloc(sizeof(*mhi_ctxt), GFP_KERNEL);
+	if (!mhi_ctxt)
+		return -ENOMEM;
+
+	/* setup channel ctxt */
+	mhi_ctxt->chan_ctxt = mhi_alloc_coherent(mhi_cntrl,
+			sizeof(*mhi_ctxt->chan_ctxt) * mhi_cntrl->max_chan,
+			&mhi_ctxt->chan_ctxt_addr, GFP_KERNEL);
+	if (!mhi_ctxt->chan_ctxt)
+		goto error_alloc_chan_ctxt;
+
+	mhi_chan = mhi_cntrl->mhi_chan;
+	chan_ctxt = mhi_ctxt->chan_ctxt;
+	for (i = 0; i < mhi_cntrl->max_chan; i++, chan_ctxt++, mhi_chan++) {
+		/* If it's offload channel skip this step */
+		if (mhi_chan->offload_ch)
+			continue;
+
+		chan_ctxt->chstate = MHI_CH_STATE_DISABLED;
+		chan_ctxt->brstmode = mhi_chan->db_cfg.brstmode;
+		chan_ctxt->pollcfg = mhi_chan->db_cfg.pollcfg;
+		chan_ctxt->chtype = mhi_chan->type;
+		chan_ctxt->erindex = mhi_chan->er_index;
+
+		mhi_chan->ch_state = MHI_CH_STATE_DISABLED;
+		mhi_chan->tre_ring.db_addr = &chan_ctxt->wp;
+	}
+
+	/* setup event context */
+	mhi_ctxt->er_ctxt = mhi_alloc_coherent(mhi_cntrl,
+			sizeof(*mhi_ctxt->er_ctxt) * mhi_cntrl->total_ev_rings,
+			&mhi_ctxt->er_ctxt_addr, GFP_KERNEL);
+	if (!mhi_ctxt->er_ctxt)
+		goto error_alloc_er_ctxt;
+
+	er_ctxt = mhi_ctxt->er_ctxt;
+	mhi_event = mhi_cntrl->mhi_event;
+	for (i = 0; i < mhi_cntrl->total_ev_rings; i++,
+				er_ctxt++, mhi_event++) {
+		struct mhi_ring *ring = &mhi_event->ring;
+
+		/* it's a satellite ev, we do not touch it */
+		if (mhi_event->offload_ev)
+			continue;
+
+		if (mhi_cntrl->msi_allocated == 1)
+			mhi_event->msi = 0;
+
+		er_ctxt->intmodc = 0;
+		er_ctxt->intmodt = mhi_event->intmod;
+		er_ctxt->ertype = MHI_ER_TYPE_VALID;
+		er_ctxt->msivec = mhi_event->msi;
+		mhi_event->db_cfg.db_mode = true;
+
+		ring->el_size = sizeof(struct mhi_tre);
+		ring->len = ring->el_size * ring->elements;
+		ret = mhi_alloc_aligned_ring(mhi_cntrl, ring, ring->len);
+		if (ret)
+			goto error_alloc_er;
+
+		ring->rptr = ring->wptr = ring->base;
+		er_ctxt->rbase = ring->iommu_base;
+		er_ctxt->rp = er_ctxt->wp = er_ctxt->rbase;
+		er_ctxt->rlen = ring->len;
+		ring->ctxt_wp = &er_ctxt->wp;
+	}
+
+	/* setup cmd context */
+	mhi_ctxt->cmd_ctxt = mhi_alloc_coherent(mhi_cntrl,
+			sizeof(*mhi_ctxt->cmd_ctxt) * NR_OF_CMD_RINGS,
+			&mhi_ctxt->cmd_ctxt_addr, GFP_KERNEL);
+	if (!mhi_ctxt->cmd_ctxt)
+		goto error_alloc_er;
+
+	mhi_cmd = mhi_cntrl->mhi_cmd;
+	cmd_ctxt = mhi_ctxt->cmd_ctxt;
+	for (i = 0; i < NR_OF_CMD_RINGS; i++, mhi_cmd++, cmd_ctxt++) {
+		struct mhi_ring *ring = &mhi_cmd->ring;
+
+		ring->el_size = sizeof(struct mhi_tre);
+		ring->elements = CMD_EL_PER_RING;
+		ring->len = ring->el_size * ring->elements;
+		ret = mhi_alloc_aligned_ring(mhi_cntrl, ring, ring->len);
+		if (ret)
+			goto error_alloc_cmd;
+
+		ring->rptr = ring->wptr = ring->base;
+		cmd_ctxt->rbase = ring->iommu_base;
+		cmd_ctxt->rp = cmd_ctxt->wp = cmd_ctxt->rbase;
+		cmd_ctxt->rlen = ring->len;
+		ring->ctxt_wp = &cmd_ctxt->wp;
+	}
+
+	mhi_cntrl->mhi_ctxt = mhi_ctxt;
+
+	return 0;
+
+error_alloc_cmd:
+	for (--i, --mhi_cmd; i >= 0; i--, mhi_cmd--) {
+		struct mhi_ring *ring = &mhi_cmd->ring;
+
+		mhi_free_coherent(mhi_cntrl, ring->alloc_size,
+				  ring->pre_aligned, ring->dma_handle);
+	}
+	mhi_free_coherent(mhi_cntrl,
+			  sizeof(*mhi_ctxt->cmd_ctxt) * NR_OF_CMD_RINGS,
+			  mhi_ctxt->cmd_ctxt, mhi_ctxt->cmd_ctxt_addr);
+	i = mhi_cntrl->total_ev_rings;
+	mhi_event = mhi_cntrl->mhi_event + i;
+
+error_alloc_er:
+	for (--i, --mhi_event; i >= 0; i--, mhi_event--) {
+		struct mhi_ring *ring = &mhi_event->ring;
+
+		if (mhi_event->offload_ev)
+			continue;
+
+		mhi_free_coherent(mhi_cntrl, ring->alloc_size,
+				  ring->pre_aligned, ring->dma_handle);
+	}
+	mhi_free_coherent(mhi_cntrl,
+			sizeof(*mhi_ctxt->er_ctxt) * mhi_cntrl->total_ev_rings,
+			mhi_ctxt->er_ctxt, mhi_ctxt->er_ctxt_addr);
+
+error_alloc_er_ctxt:
+	mhi_free_coherent(mhi_cntrl,
+			sizeof(*mhi_ctxt->chan_ctxt) * mhi_cntrl->max_chan,
+			mhi_ctxt->chan_ctxt, mhi_ctxt->chan_ctxt_addr);
+
+error_alloc_chan_ctxt:
+	kfree(mhi_ctxt);
+
+	return ret;
+}
+
+static int mhi_get_tsync_er_cfg(struct mhi_controller *mhi_cntrl)
+{
+	int i;
+	struct mhi_event *mhi_event = mhi_cntrl->mhi_event;
+
+	/* find event ring with timesync support */
+	for (i = 0; i < mhi_cntrl->total_ev_rings; i++, mhi_event++)
+		if (mhi_event->data_type == MHI_ER_TSYNC_ELEMENT_TYPE)
+			return mhi_event->er_index;
+
+	return -ENOENT;
+}
+
+int mhi_init_timesync(struct mhi_controller *mhi_cntrl)
+{
+	struct mhi_timesync *mhi_tsync;
+	u32 time_offset, db_offset;
+	int ret;
+
+	read_lock_bh(&mhi_cntrl->pm_lock);
+
+	if (!MHI_REG_ACCESS_VALID(mhi_cntrl->pm_state)) {
+		ret = -EIO;
+		goto exit_timesync;
+	}
+
+	ret = mhi_get_capability_offset(mhi_cntrl, TIMESYNC_CAP_ID,
+					&time_offset);
+	if (ret) {
+		MHI_LOG("No timesync capability found\n");
+		goto exit_timesync;
+	}
+
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	if (!mhi_cntrl->time_get || !mhi_cntrl->lpm_disable ||
+	    !mhi_cntrl->lpm_enable)
+		return -EINVAL;
+
+	/* register method supported */
+	mhi_tsync = kzalloc(sizeof(*mhi_tsync), GFP_KERNEL);
+	if (!mhi_tsync)
+		return -ENOMEM;
+
+	spin_lock_init(&mhi_tsync->lock);
+	INIT_LIST_HEAD(&mhi_tsync->head);
+	init_completion(&mhi_tsync->completion);
+
+	/* save time_offset for obtaining time */
+	MHI_LOG("TIME OFFS:0x%x\n", time_offset);
+	mhi_tsync->time_reg = mhi_cntrl->regs + time_offset
+				+ TIMESYNC_TIME_LOW_OFFSET;
+
+	mhi_cntrl->mhi_tsync = mhi_tsync;
+
+	ret = mhi_create_timesync_sysfs(mhi_cntrl);
+	if (unlikely(ret)) {
+		/* kernel method still work */
+		MHI_ERR("Failed to create timesync sysfs nodes\n");
+	}
+
+	read_lock_bh(&mhi_cntrl->pm_lock);
+
+	if (!MHI_REG_ACCESS_VALID(mhi_cntrl->pm_state)) {
+		ret = -EIO;
+		goto exit_timesync;
+	}
+
+	/* get DB offset if supported, else return */
+	ret = mhi_read_reg(mhi_cntrl, mhi_cntrl->regs,
+			   time_offset + TIMESYNC_DB_OFFSET, &db_offset);
+	if (ret || !db_offset) {
+		ret = 0;
+		goto exit_timesync;
+	}
+
+	MHI_LOG("TIMESYNC_DB OFFS:0x%x\n", db_offset);
+	mhi_tsync->db = mhi_cntrl->regs + db_offset;
+
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	/* get time-sync event ring configuration */
+	ret = mhi_get_tsync_er_cfg(mhi_cntrl);
+	if (ret < 0) {
+		MHI_LOG("Could not find timesync event ring\n");
+		return ret;
+	}
+
+	mhi_tsync->er_index = ret;
+
+	ret = mhi_send_cmd(mhi_cntrl, NULL, MHI_CMD_TIMSYNC_CFG);
+	if (ret) {
+		MHI_ERR("Failed to send time sync cfg cmd\n");
+		return ret;
+	}
+
+	ret = wait_for_completion_timeout(&mhi_tsync->completion,
+				msecs_to_jiffies(mhi_cntrl->timeout_ms));
+
+	if (!ret || mhi_tsync->ccs != MHI_EV_CC_SUCCESS) {
+		MHI_ERR("Failed to get time cfg cmd completion\n");
+		return -EIO;
+	}
+
+	return 0;
+
+exit_timesync:
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	return ret;
+}
+
+int mhi_init_mmio(struct mhi_controller *mhi_cntrl)
+{
+	u32 val;
+	int i, ret;
+	struct mhi_chan *mhi_chan;
+	struct mhi_event *mhi_event;
+	void __iomem *base = mhi_cntrl->regs;
+	struct {
+		u32 offset;
+		u32 mask;
+		u32 shift;
+		u32 val;
+	} reg_info[] = {
+		{
+			CCABAP_HIGHER, U32_MAX, 0,
+			upper_32_bits(mhi_cntrl->mhi_ctxt->chan_ctxt_addr),
+		},
+		{
+			CCABAP_LOWER, U32_MAX, 0,
+			lower_32_bits(mhi_cntrl->mhi_ctxt->chan_ctxt_addr),
+		},
+		{
+			ECABAP_HIGHER, U32_MAX, 0,
+			upper_32_bits(mhi_cntrl->mhi_ctxt->er_ctxt_addr),
+		},
+		{
+			ECABAP_LOWER, U32_MAX, 0,
+			lower_32_bits(mhi_cntrl->mhi_ctxt->er_ctxt_addr),
+		},
+		{
+			CRCBAP_HIGHER, U32_MAX, 0,
+			upper_32_bits(mhi_cntrl->mhi_ctxt->cmd_ctxt_addr),
+		},
+		{
+			CRCBAP_LOWER, U32_MAX, 0,
+			lower_32_bits(mhi_cntrl->mhi_ctxt->cmd_ctxt_addr),
+		},
+		{
+			MHICFG, MHICFG_NER_MASK, MHICFG_NER_SHIFT,
+			mhi_cntrl->total_ev_rings,
+		},
+		{
+			MHICFG, MHICFG_NHWER_MASK, MHICFG_NHWER_SHIFT,
+			mhi_cntrl->hw_ev_rings,
+		},
+		{
+			MHICTRLBASE_HIGHER, U32_MAX, 0,
+			upper_32_bits(mhi_cntrl->iova_start),
+		},
+		{
+			MHICTRLBASE_LOWER, U32_MAX, 0,
+			lower_32_bits(mhi_cntrl->iova_start),
+		},
+		{
+			MHIDATABASE_HIGHER, U32_MAX, 0,
+			upper_32_bits(mhi_cntrl->iova_start),
+		},
+		{
+			MHIDATABASE_LOWER, U32_MAX, 0,
+			lower_32_bits(mhi_cntrl->iova_start),
+		},
+		{
+			MHICTRLLIMIT_HIGHER, U32_MAX, 0,
+			upper_32_bits(mhi_cntrl->iova_stop),
+		},
+		{
+			MHICTRLLIMIT_LOWER, U32_MAX, 0,
+			lower_32_bits(mhi_cntrl->iova_stop),
+		},
+		{
+			MHIDATALIMIT_HIGHER, U32_MAX, 0,
+			upper_32_bits(mhi_cntrl->iova_stop),
+		},
+		{
+			MHIDATALIMIT_LOWER, U32_MAX, 0,
+			lower_32_bits(mhi_cntrl->iova_stop),
+		},
+		{ 0, 0, 0 }
+	};
+
+	MHI_LOG("Initializing MMIO\n");
+
+	/* set up DB register for all the chan rings */
+	ret = mhi_read_reg_field(mhi_cntrl, base, CHDBOFF, CHDBOFF_CHDBOFF_MASK,
+				 CHDBOFF_CHDBOFF_SHIFT, &val);
+	if (ret)
+		return -EIO;
+
+	MHI_LOG("CHDBOFF:0x%x\n", val);
+
+	/* setup wake db */
+	mhi_cntrl->wake_db = base + val + (8 * MHI_DEV_WAKE_DB);
+	mhi_write_reg(mhi_cntrl, mhi_cntrl->wake_db, 4, 0);
+	mhi_write_reg(mhi_cntrl, mhi_cntrl->wake_db, 0, 0);
+	mhi_cntrl->wake_set = false;
+
+	/* setup channel db addresses */
+	mhi_chan = mhi_cntrl->mhi_chan;
+	for (i = 0; i < mhi_cntrl->max_chan; i++, val += 8, mhi_chan++)
+		mhi_chan->tre_ring.db_addr = base + val;
+
+	/* setup event ring db addresses */
+	ret = mhi_read_reg_field(mhi_cntrl, base, ERDBOFF, ERDBOFF_ERDBOFF_MASK,
+				 ERDBOFF_ERDBOFF_SHIFT, &val);
+	if (ret)
+		return -EIO;
+
+	MHI_LOG("ERDBOFF:0x%x\n", val);
+
+	mhi_event = mhi_cntrl->mhi_event;
+	for (i = 0; i < mhi_cntrl->total_ev_rings; i++, val += 8, mhi_event++) {
+		if (mhi_event->offload_ev)
+			continue;
+
+		mhi_event->ring.db_addr = base + val;
+	}
+
+	/* set up DB register for primary CMD rings */
+	mhi_cntrl->mhi_cmd[PRIMARY_CMD_RING].ring.db_addr = base + CRDB_LOWER;
+
+	MHI_LOG("Programming all MMIO values.\n");
+	for (i = 0; reg_info[i].offset; i++)
+		mhi_write_reg_field(mhi_cntrl, base, reg_info[i].offset,
+				    reg_info[i].mask, reg_info[i].shift,
+				    reg_info[i].val);
+
+	return 0;
+}
+
+void mhi_deinit_chan_ctxt(struct mhi_controller *mhi_cntrl,
+			  struct mhi_chan *mhi_chan)
+{
+	struct mhi_ring *buf_ring;
+	struct mhi_ring *tre_ring;
+	struct mhi_chan_ctxt *chan_ctxt;
+
+	buf_ring = &mhi_chan->buf_ring;
+	tre_ring = &mhi_chan->tre_ring;
+	chan_ctxt = &mhi_cntrl->mhi_ctxt->chan_ctxt[mhi_chan->chan];
+
+	mhi_free_coherent(mhi_cntrl, tre_ring->alloc_size,
+			  tre_ring->pre_aligned, tre_ring->dma_handle);
+	kfree(buf_ring->base);
+
+	buf_ring->base = tre_ring->base = NULL;
+	chan_ctxt->rbase = 0;
+}
+
+int mhi_init_chan_ctxt(struct mhi_controller *mhi_cntrl,
+		       struct mhi_chan *mhi_chan)
+{
+	struct mhi_ring *buf_ring;
+	struct mhi_ring *tre_ring;
+	struct mhi_chan_ctxt *chan_ctxt;
+	int ret;
+
+	buf_ring = &mhi_chan->buf_ring;
+	tre_ring = &mhi_chan->tre_ring;
+	tre_ring->el_size = sizeof(struct mhi_tre);
+	tre_ring->len = tre_ring->el_size * tre_ring->elements;
+	chan_ctxt = &mhi_cntrl->mhi_ctxt->chan_ctxt[mhi_chan->chan];
+	ret = mhi_alloc_aligned_ring(mhi_cntrl, tre_ring, tre_ring->len);
+	if (ret)
+		return -ENOMEM;
+
+	buf_ring->el_size = sizeof(struct mhi_buf_info);
+	buf_ring->len = buf_ring->el_size * buf_ring->elements;
+	buf_ring->base = kzalloc(buf_ring->len, GFP_KERNEL);
+
+	if (!buf_ring->base) {
+		mhi_free_coherent(mhi_cntrl, tre_ring->alloc_size,
+				  tre_ring->pre_aligned, tre_ring->dma_handle);
+		return -ENOMEM;
+	}
+
+	chan_ctxt->chstate = MHI_CH_STATE_ENABLED;
+	chan_ctxt->rbase = tre_ring->iommu_base;
+	chan_ctxt->rp = chan_ctxt->wp = chan_ctxt->rbase;
+	chan_ctxt->rlen = tre_ring->len;
+	tre_ring->ctxt_wp = &chan_ctxt->wp;
+
+	tre_ring->rptr = tre_ring->wptr = tre_ring->base;
+	buf_ring->rptr = buf_ring->wptr = buf_ring->base;
+	mhi_chan->db_cfg.db_mode = true;
+
+	/* update to all cores */
+	smp_wmb();
+
+	return 0;
+}
+
+int mhi_device_configure(struct mhi_device *mhi_dev,
+			 enum dma_data_direction dir,
+			 struct mhi_buf *cfg_tbl, int elements)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_chan *mhi_chan;
+	struct mhi_event_ctxt *er_ctxt;
+	struct mhi_chan_ctxt *ch_ctxt;
+	int er_index, chan;
+
+	switch (dir) {
+	case DMA_TO_DEVICE:
+		mhi_chan = mhi_dev->ul_chan;
+		break;
+	case DMA_BIDIRECTIONAL:
+	case DMA_FROM_DEVICE:
+	case DMA_NONE:
+		mhi_chan = mhi_dev->dl_chan;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	er_index = mhi_chan->er_index;
+	chan = mhi_chan->chan;
+
+	for (; elements > 0; elements--, cfg_tbl++) {
+		/* update event context array */
+		if (!strcmp(cfg_tbl->name, "ECA")) {
+			er_ctxt = &mhi_cntrl->mhi_ctxt->er_ctxt[er_index];
+			if (sizeof(*er_ctxt) != cfg_tbl->len) {
+				MHI_ERR
+				    ("Invalid ECA size: %zu, expected: %zu\n",
+				     cfg_tbl->len, sizeof(*er_ctxt));
+				return -EINVAL;
+			}
+			memcpy((void *)er_ctxt, cfg_tbl->buf, sizeof(*er_ctxt));
+			continue;
+		}
+
+		/* update channel context array */
+		if (!strcmp(cfg_tbl->name, "CCA")) {
+			ch_ctxt = &mhi_cntrl->mhi_ctxt->chan_ctxt[chan];
+			if (cfg_tbl->len != sizeof(*ch_ctxt)) {
+				MHI_ERR
+				    ("Invalid CCA size: %zu, expected: %zu\n",
+				     cfg_tbl->len, sizeof(*ch_ctxt));
+				return -EINVAL;
+			}
+			memcpy((void *)ch_ctxt, cfg_tbl->buf, sizeof(*ch_ctxt));
+			continue;
+		}
+
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int of_parse_ev_cfg(struct mhi_controller *mhi_cntrl,
+			   struct device_node *of_node)
+{
+	int i, num = 0;
+	struct mhi_event *mhi_event;
+#ifdef CONFIG_OF
+	int ret;
+	struct device_node *child;
+#else
+	int index;
+#endif
+
+#ifdef CONFIG_OF
+	of_node = of_find_node_by_name(of_node, "mhi_events");
+	if (!of_node)
+		return -EINVAL;
+
+	for_each_available_child_of_node(of_node, child) {
+		if (!strcmp(child->name, "mhi_event"))
+			num++;
+	}
+#else
+	num = ARRAY_SIZE(mhi_event_init_array);
+#endif
+
+	if (!num)
+		return -EINVAL;
+
+	mhi_cntrl->total_ev_rings = num;
+	mhi_cntrl->mhi_event = kcalloc(num, sizeof(*mhi_cntrl->mhi_event),
+				       GFP_KERNEL);
+	if (!mhi_cntrl->mhi_event)
+		return -ENOMEM;
+
+	/* populate ev ring */
+	mhi_event = mhi_cntrl->mhi_event;
+	i = 0;
+#ifdef CONFIG_OF
+	for_each_available_child_of_node(of_node, child) {
+		if (strcmp(child->name, "mhi_event"))
+			continue;
+
+		mhi_event->er_index = i++;
+		ret = of_property_read_u32(child, "mhi,num-elements",
+					   (u32 *)&mhi_event->ring.elements);
+		if (ret)
+			goto error_ev_cfg;
+
+		ret = of_property_read_u32(child, "mhi,intmod",
+					   &mhi_event->intmod);
+		if (ret)
+			goto error_ev_cfg;
+
+		ret = of_property_read_u32(child, "mhi,msi", &mhi_event->msi);
+		if (ret)
+			goto error_ev_cfg;
+
+		ret = of_property_read_u32(child, "mhi,chan", &mhi_event->chan);
+		if (!ret) {
+			if (mhi_event->chan >= mhi_cntrl->max_chan)
+				goto error_ev_cfg;
+			/* this event ring has a dedicated channel */
+			mhi_event->mhi_chan =
+			    &mhi_cntrl->mhi_chan[mhi_event->chan];
+		}
+
+		ret = of_property_read_u32(child, "mhi,priority",
+					   &mhi_event->priority);
+		if (ret)
+			goto error_ev_cfg;
+
+		ret = of_property_read_u32(child, "mhi,brstmode",
+					   &mhi_event->db_cfg.brstmode);
+		if (ret || MHI_INVALID_BRSTMODE(mhi_event->db_cfg.brstmode))
+			goto error_ev_cfg;
+
+		mhi_event->db_cfg.process_db =
+		    (mhi_event->db_cfg.brstmode == MHI_BRSTMODE_ENABLE) ?
+		    mhi_db_brstmode : mhi_db_brstmode_disable;
+
+		ret = of_property_read_u32(child, "mhi,data-type",
+					   &mhi_event->data_type);
+		if (ret)
+			mhi_event->data_type = MHI_ER_DATA_ELEMENT_TYPE;
+
+		if (mhi_event->data_type > MHI_ER_DATA_TYPE_MAX)
+			goto error_ev_cfg;
+
+		switch (mhi_event->data_type) {
+		case MHI_ER_DATA_ELEMENT_TYPE:
+			mhi_event->process_event = mhi_process_data_event_ring;
+			break;
+		case MHI_ER_CTRL_ELEMENT_TYPE:
+			mhi_event->process_event = mhi_process_ctrl_ev_ring;
+			break;
+		case MHI_ER_TSYNC_ELEMENT_TYPE:
+			mhi_event->process_event = mhi_process_tsync_event_ring;
+			break;
+		}
+
+		mhi_event->hw_ring = of_property_read_bool(child, "mhi,hw-ev");
+		if (mhi_event->hw_ring)
+			mhi_cntrl->hw_ev_rings++;
+		else
+			mhi_cntrl->sw_ev_rings++;
+		mhi_event->cl_manage = of_property_read_bool(child,
+							     "mhi,client-manage");
+		mhi_event->offload_ev = of_property_read_bool(child,
+							      "mhi,offload");
+		mhi_event++;
+	}
+#else
+	/* for_each_available_child_of_node(of_node, child) { */
+	for (index = 0; index < ARRAY_SIZE(mhi_event_init_array); index++) {
+
+		mhi_event->er_index = i++;
+		mhi_event->ring.elements = mhi_event_init_array[index].elements;
+
+		mhi_event->intmod = mhi_event_init_array[index].intmod;
+
+		mhi_event->msi = mhi_event_init_array[index].msi;
+
+		mhi_event->chan = mhi_event_init_array[index].chan;
+
+		if (mhi_event->chan) {
+			if (mhi_event->chan >= mhi_cntrl->max_chan)
+				goto error_ev_cfg;
+			/* this event ring has a dedicated channel */
+			mhi_event->mhi_chan =
+			    &mhi_cntrl->mhi_chan[mhi_event->chan];
+		}
+
+		mhi_event->priority = mhi_event_init_array[index].priority;
+
+		mhi_event->db_cfg.brstmode =
+		    mhi_event_init_array[index].brstmode;
+
+		if (MHI_INVALID_BRSTMODE(mhi_event->db_cfg.brstmode))
+			goto error_ev_cfg;
+
+		mhi_event->db_cfg.process_db =
+		    (mhi_event->db_cfg.brstmode == MHI_BRSTMODE_ENABLE) ?
+		    mhi_db_brstmode : mhi_db_brstmode_disable;
+
+		mhi_event->data_type = mhi_event_init_array[index].data_type;
+
+		if (!mhi_event->data_type)
+			mhi_event->data_type = MHI_ER_DATA_ELEMENT_TYPE;
+
+		if (mhi_event->data_type > MHI_ER_DATA_TYPE_MAX)
+			goto error_ev_cfg;
+
+		switch (mhi_event->data_type) {
+		case MHI_ER_DATA_ELEMENT_TYPE:
+			mhi_event->process_event = mhi_process_data_event_ring;
+			break;
+		case MHI_ER_CTRL_ELEMENT_TYPE:
+			mhi_event->process_event = mhi_process_ctrl_ev_ring;
+			break;
+		case MHI_ER_TSYNC_ELEMENT_TYPE:
+			mhi_event->process_event = mhi_process_tsync_event_ring;
+			break;
+		}
+
+		mhi_event->hw_ring = mhi_event_init_array[index].hw_ring;
+
+		if (mhi_event->hw_ring)
+			mhi_cntrl->hw_ev_rings++;
+		else
+			mhi_cntrl->sw_ev_rings++;
+		mhi_event->cl_manage = mhi_event_init_array[index].cl_manage;
+		mhi_event->offload_ev = mhi_event_init_array[index].offload_ev;
+		mhi_event++;
+	}
+#endif
+
+	/* we need msi for each event ring + additional one for BHI */
+	mhi_cntrl->msi_required = mhi_cntrl->total_ev_rings + 1;
+
+	return 0;
+
+error_ev_cfg:
+
+	kfree(mhi_cntrl->mhi_event);
+	return -EINVAL;
+}
+
+#ifdef CONFIG_OF
+static int of_parse_ch_cfg(struct mhi_controller *mhi_cntrl,
+			   struct device_node *of_node)
+{
+	int ret;
+	struct device_node *child;
+	u32 chan;
+
+	ret = of_property_read_u32(of_node, "mhi,max-channels",
+				   &mhi_cntrl->max_chan);
+	if (ret)
+		return ret;
+
+	of_node = of_find_node_by_name(of_node, "mhi_channels");
+	if (!of_node)
+		return -EINVAL;
+
+	mhi_cntrl->mhi_chan = kcalloc(mhi_cntrl->max_chan,
+				      sizeof(*mhi_cntrl->mhi_chan), GFP_KERNEL);
+	if (!mhi_cntrl->mhi_chan)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&mhi_cntrl->lpm_chans);
+
+	/* populate channel configurations */
+	for_each_available_child_of_node(of_node, child) {
+		struct mhi_chan *mhi_chan;
+
+		if (strcmp(child->name, "mhi_chan"))
+			continue;
+
+		ret = of_property_read_u32(child, "reg", &chan);
+		if (ret || chan >= mhi_cntrl->max_chan)
+			goto error_chan_cfg;
+
+		mhi_chan = &mhi_cntrl->mhi_chan[chan];
+
+		ret = of_property_read_string(child, "label", &mhi_chan->name);
+		if (ret)
+			goto error_chan_cfg;
+
+		mhi_chan->chan = chan;
+
+		ret = of_property_read_u32(child, "mhi,num-elements",
+				(u32 *)&mhi_chan->tre_ring.elements);
+		if (!ret && !mhi_chan->tre_ring.elements)
+			goto error_chan_cfg;
+
+		/*
+		 * For some channels, local ring len should be bigger than
+		 * transfer ring len due to internal logical channels in device.
+		 * So host can queue much more buffers than transfer ring len.
+		 * Example, RSC channels should have a larger local channel
+		 * than transfer ring length.
+		 */
+		ret = of_property_read_u32(child, "mhi,local-elements",
+				(u32 *)&mhi_chan->buf_ring.elements);
+		if (ret)
+			mhi_chan->buf_ring.elements =
+			    mhi_chan->tre_ring.elements;
+
+		ret = of_property_read_u32(child, "mhi,event-ring",
+					   &mhi_chan->er_index);
+		if (ret)
+			goto error_chan_cfg;
+
+		ret = of_property_read_u32(child, "mhi,chan-dir",
+					   &mhi_chan->dir);
+		if (ret)
+			goto error_chan_cfg;
+
+		/*
+		 * For most channels, chtype is identical to channel directions,
+		 * if not defined, assign ch direction to chtype
+		 */
+		ret = of_property_read_u32(child, "mhi,chan-type",
+					   &mhi_chan->type);
+		if (ret)
+			mhi_chan->type = (enum mhi_ch_type)mhi_chan->dir;
+
+		ret = of_property_read_u32(child, "mhi,ee", &mhi_chan->ee_mask);
+		if (ret)
+			goto error_chan_cfg;
+
+		of_property_read_u32(child, "mhi,pollcfg",
+				     &mhi_chan->db_cfg.pollcfg);
+
+		ret = of_property_read_u32(child, "mhi,data-type",
+					   &mhi_chan->xfer_type);
+		if (ret)
+			goto error_chan_cfg;
+
+		switch (mhi_chan->xfer_type) {
+		case MHI_XFER_BUFFER:
+			mhi_chan->gen_tre = mhi_gen_tre;
+			mhi_chan->queue_xfer = mhi_queue_buf;
+			break;
+		case MHI_XFER_SKB:
+			mhi_chan->queue_xfer = mhi_queue_skb;
+			break;
+		case MHI_XFER_SCLIST:
+			mhi_chan->gen_tre = mhi_gen_tre;
+			mhi_chan->queue_xfer = mhi_queue_sclist;
+			break;
+		case MHI_XFER_NOP:
+			mhi_chan->queue_xfer = mhi_queue_nop;
+			break;
+		case MHI_XFER_DMA:
+		case MHI_XFER_RSC_DMA:
+			mhi_chan->queue_xfer = mhi_queue_dma;
+			break;
+		default:
+			goto error_chan_cfg;
+		}
+
+		mhi_chan->lpm_notify = of_property_read_bool(child,
+							     "mhi,lpm-notify");
+		mhi_chan->offload_ch = of_property_read_bool(child,
+							     "mhi,offload-chan");
+		mhi_chan->db_cfg.reset_req = of_property_read_bool(child,
+								   "mhi,db-mode-switch");
+		mhi_chan->pre_alloc = of_property_read_bool(child,
+							    "mhi,auto-queue");
+		mhi_chan->auto_start = of_property_read_bool(child,
+							     "mhi,auto-start");
+		mhi_chan->wake_capable = of_property_read_bool(child,
+							       "mhi,wake-capable");
+
+		if (mhi_chan->pre_alloc &&
+		    (mhi_chan->dir != DMA_FROM_DEVICE ||
+		     mhi_chan->xfer_type != MHI_XFER_BUFFER))
+			goto error_chan_cfg;
+
+		/* bi-dir and dirctionless channels must be a offload chan */
+		if ((mhi_chan->dir == DMA_BIDIRECTIONAL ||
+		     mhi_chan->dir == DMA_NONE) && !mhi_chan->offload_ch)
+			goto error_chan_cfg;
+
+		/* if mhi host allocate the buffers then client cannot queue */
+		if (mhi_chan->pre_alloc)
+			mhi_chan->queue_xfer = mhi_queue_nop;
+
+		if (!mhi_chan->offload_ch) {
+			ret = of_property_read_u32(child, "mhi,doorbell-mode",
+						   &mhi_chan->db_cfg.brstmode);
+			if (ret ||
+			    MHI_INVALID_BRSTMODE(mhi_chan->db_cfg.brstmode))
+				goto error_chan_cfg;
+
+			mhi_chan->db_cfg.process_db =
+			    (mhi_chan->db_cfg.brstmode ==
+			     MHI_BRSTMODE_ENABLE) ?
+			    mhi_db_brstmode : mhi_db_brstmode_disable;
+		}
+
+		mhi_chan->configured = true;
+
+		if (mhi_chan->lpm_notify)
+			list_add_tail(&mhi_chan->node, &mhi_cntrl->lpm_chans);
+	}
+
+	return 0;
+
+error_chan_cfg:
+	kfree(mhi_cntrl->mhi_chan);
+
+	return -EINVAL;
+}
+
+static int of_parse_dt(struct mhi_controller *mhi_cntrl,
+		       struct device_node *of_node)
+{
+	int ret;
+
+	/* parse MHI channel configuration */
+	ret = of_parse_ch_cfg(mhi_cntrl, of_node);
+	if (ret)
+		return ret;
+
+	/* parse MHI event configuration */
+	ret = of_parse_ev_cfg(mhi_cntrl, of_node);
+	if (ret)
+		goto error_ev_cfg;
+
+	ret = of_property_read_u32(of_node, "mhi,timeout",
+				   &mhi_cntrl->timeout_ms);
+	if (ret)
+		mhi_cntrl->timeout_ms = MHI_TIMEOUT_MS;
+
+	mhi_cntrl->bounce_buf = of_property_read_bool(of_node, "mhi,use-bb");
+	ret = of_property_read_u32(of_node, "mhi,buffer-len",
+				   (u32 *)&mhi_cntrl->buffer_len);
+	if (ret)
+		mhi_cntrl->buffer_len = MHI_MAX_MTU;
+
+	return 0;
+
+error_ev_cfg:
+	kfree(mhi_cntrl->mhi_chan);
+
+	return ret;
+}
+#else
+static int of_parse_ch_cfg(struct mhi_controller *mhi_cntrl,
+			   struct device_node *of_node)
+{
+	u32 chan;
+	int i;
+
+	mhi_cntrl->max_chan = 110;
+	mhi_cntrl->mhi_chan = kcalloc(mhi_cntrl->max_chan,
+				      sizeof(*mhi_cntrl->mhi_chan), GFP_KERNEL);
+	if (!mhi_cntrl->mhi_chan)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&mhi_cntrl->lpm_chans);
+
+	/* populate channel configurations */
+	for (i = 0; i < ARRAY_SIZE(mhi_chan_init_array); i++) {
+
+		struct mhi_chan *mhi_chan;
+
+		chan = mhi_chan_init_array[i].chan;
+
+		if (chan >= mhi_cntrl->max_chan)
+			goto error_chan_cfg;
+
+		mhi_chan = &mhi_cntrl->mhi_chan[chan];
+
+		mhi_chan->name = mhi_chan_init_array[i].name;
+
+		mhi_chan->chan = chan;
+
+		mhi_chan->tre_ring.elements =
+		    mhi_chan_init_array[i].tre_ring_elements;
+
+		/*
+		 * For some channels, local ring len should be bigger than
+		 * transfer ring len due to internal logical channels in device.
+		 * So host can queue much more buffers than transfer ring len.
+		 * Example, RSC channels should have a larger local channel
+		 * than transfer ring length.
+		 */
+		mhi_chan->buf_ring.elements = mhi_chan->tre_ring.elements;
+
+		mhi_chan->er_index = mhi_chan_init_array[i].er_index;
+
+		mhi_chan->dir = mhi_chan_init_array[i].dir;
+
+		/*
+		 * For most channels, chtype is identical to channel directions,
+		 * if not defined, assign ch direction to chtype
+		 */
+		mhi_chan->type = (enum mhi_ch_type)mhi_chan->dir;
+
+		mhi_chan->ee_mask = mhi_chan_init_array[i].ee_mask;
+
+		mhi_chan->db_cfg.pollcfg = mhi_chan_init_array[i].pollcfg;
+
+		mhi_chan->xfer_type = mhi_chan_init_array[i].xfer_type;
+
+		switch (mhi_chan->xfer_type) {
+		case MHI_XFER_BUFFER:
+			mhi_chan->gen_tre = mhi_gen_tre;
+			mhi_chan->queue_xfer = mhi_queue_buf;
+			break;
+		case MHI_XFER_SKB:
+			mhi_chan->queue_xfer = mhi_queue_skb;
+			break;
+		case MHI_XFER_SCLIST:
+			mhi_chan->gen_tre = mhi_gen_tre;
+			mhi_chan->queue_xfer = mhi_queue_sclist;
+			break;
+		case MHI_XFER_NOP:
+			mhi_chan->queue_xfer = mhi_queue_nop;
+			break;
+		case MHI_XFER_DMA:
+		case MHI_XFER_RSC_DMA:
+			mhi_chan->queue_xfer = mhi_queue_dma;
+			break;
+		default:
+			goto error_chan_cfg;
+		}
+
+		mhi_chan->lpm_notify = mhi_chan_init_array[i].lpm_notify;
+
+		mhi_chan->offload_ch = mhi_chan_init_array[i].offload_ch;
+
+		mhi_chan->db_cfg.reset_req = mhi_chan_init_array[i].reset_req;
+
+		mhi_chan->pre_alloc = mhi_chan_init_array[i].pre_alloc;
+
+		mhi_chan->auto_start = mhi_chan_init_array[i].auto_start;
+
+		mhi_chan->wake_capable = mhi_chan_init_array[i].wake_capable;
+
+		if (mhi_chan->pre_alloc &&
+		    (mhi_chan->dir != DMA_FROM_DEVICE ||
+		     mhi_chan->xfer_type != MHI_XFER_BUFFER))
+			goto error_chan_cfg;
+
+		/* bi-dir and dirctionless channels must be a offload chan */
+		if ((mhi_chan->dir == DMA_BIDIRECTIONAL ||
+		     mhi_chan->dir == DMA_NONE) && !mhi_chan->offload_ch)
+			goto error_chan_cfg;
+
+		/* if mhi host allocate the buffers then client cannot queue */
+		if (mhi_chan->pre_alloc)
+			mhi_chan->queue_xfer = mhi_queue_nop;
+
+		if (!mhi_chan->offload_ch) {
+			mhi_chan->db_cfg.brstmode =
+			    mhi_chan_init_array[i].brstmode;
+
+			if (MHI_INVALID_BRSTMODE(mhi_chan->db_cfg.brstmode))
+				goto error_chan_cfg;
+
+			mhi_chan->db_cfg.process_db =
+			    (mhi_chan->db_cfg.brstmode ==
+			     MHI_BRSTMODE_ENABLE) ?
+			    mhi_db_brstmode : mhi_db_brstmode_disable;
+		}
+
+		mhi_chan->configured = true;
+
+		if (mhi_chan->lpm_notify)
+			list_add_tail(&mhi_chan->node, &mhi_cntrl->lpm_chans);
+	}
+
+	return 0;
+
+error_chan_cfg:
+	kfree(mhi_cntrl->mhi_chan);
+
+	return -EINVAL;
+}
+
+static int of_parse_dt(struct mhi_controller *mhi_cntrl,
+		       struct device_node *of_node)
+{
+	int ret;
+
+	/* parse MHI channel configuration */
+	ret = of_parse_ch_cfg(mhi_cntrl, of_node);
+	if (ret)
+		return ret;
+
+	/* parse MHI event configuration */
+	ret = of_parse_ev_cfg(mhi_cntrl, of_node);
+	if (ret)
+		goto error_ev_cfg;
+
+	mhi_cntrl->timeout_ms = 600;
+
+	mhi_cntrl->bounce_buf = 0;
+
+	mhi_cntrl->buffer_len = MHI_MAX_MTU;
+
+	return 0;
+
+error_ev_cfg:
+	kfree(mhi_cntrl->mhi_chan);
+
+	return ret;
+}
+#endif
+
+int of_register_mhi_controller(struct mhi_controller *mhi_cntrl)
+{
+	int ret;
+	int i;
+	struct mhi_event *mhi_event;
+	struct mhi_chan *mhi_chan;
+	struct mhi_cmd *mhi_cmd;
+	struct mhi_device *mhi_dev;
+
+#ifdef CONFIG_OF
+	if (!mhi_cntrl->of_node)
+		return -EINVAL;
+#endif
+
+	if (!mhi_cntrl->runtime_get || !mhi_cntrl->runtime_put)
+		return -EINVAL;
+
+	if (!mhi_cntrl->status_cb || !mhi_cntrl->link_status)
+		return -EINVAL;
+
+	ret = of_parse_dt(mhi_cntrl, mhi_cntrl->of_node);
+	if (ret)
+		return -EINVAL;
+
+	mhi_cntrl->mhi_cmd = kcalloc(NR_OF_CMD_RINGS,
+				     sizeof(*mhi_cntrl->mhi_cmd), GFP_KERNEL);
+	if (!mhi_cntrl->mhi_cmd) {
+		ret = -ENOMEM;
+		goto error_alloc_cmd;
+	}
+
+	INIT_LIST_HEAD(&mhi_cntrl->transition_list);
+	mutex_init(&mhi_cntrl->pm_mutex);
+	rwlock_init(&mhi_cntrl->pm_lock);
+	spin_lock_init(&mhi_cntrl->transition_lock);
+	spin_lock_init(&mhi_cntrl->wlock);
+	INIT_WORK(&mhi_cntrl->st_worker, mhi_pm_st_worker);
+	INIT_WORK(&mhi_cntrl->fw_worker, mhi_fw_load_worker);
+	INIT_WORK(&mhi_cntrl->syserr_worker, mhi_pm_sys_err_worker);
+	init_waitqueue_head(&mhi_cntrl->state_event);
+
+	mhi_cmd = mhi_cntrl->mhi_cmd;
+	for (i = 0; i < NR_OF_CMD_RINGS; i++, mhi_cmd++)
+		spin_lock_init(&mhi_cmd->lock);
+
+	mhi_event = mhi_cntrl->mhi_event;
+	for (i = 0; i < mhi_cntrl->total_ev_rings; i++, mhi_event++) {
+		if (mhi_event->offload_ev)
+			continue;
+
+		mhi_event->mhi_cntrl = mhi_cntrl;
+		spin_lock_init(&mhi_event->lock);
+		if (mhi_event->data_type == MHI_ER_CTRL_ELEMENT_TYPE)
+			tasklet_init(&mhi_event->task, mhi_ctrl_ev_task,
+				     (ulong)mhi_event);
+		else
+			tasklet_init(&mhi_event->task, mhi_ev_task,
+				     (ulong)mhi_event);
+	}
+
+	mhi_chan = mhi_cntrl->mhi_chan;
+	for (i = 0; i < mhi_cntrl->max_chan; i++, mhi_chan++) {
+		mutex_init(&mhi_chan->mutex);
+		init_completion(&mhi_chan->completion);
+		rwlock_init(&mhi_chan->lock);
+	}
+
+	if (mhi_cntrl->bounce_buf) {
+		mhi_cntrl->map_single = mhi_map_single_use_bb;
+		mhi_cntrl->unmap_single = mhi_unmap_single_use_bb;
+	} else {
+		mhi_cntrl->map_single = mhi_map_single_no_bb;
+		mhi_cntrl->unmap_single = mhi_unmap_single_no_bb;
+	}
+
+	/* register controller with mhi_bus */
+	mhi_dev = mhi_alloc_device(mhi_cntrl);
+	if (!mhi_dev) {
+		ret = -ENOMEM;
+		goto error_alloc_dev;
+	}
+
+	mhi_dev->dev_type = MHI_CONTROLLER_TYPE;
+	mhi_dev->mhi_cntrl = mhi_cntrl;
+	dev_set_name(&mhi_dev->dev, "%04x_%02u.%02u.%02u", mhi_dev->dev_id,
+		     mhi_dev->domain, mhi_dev->bus, mhi_dev->slot);
+	ret = device_add(&mhi_dev->dev);
+	if (ret)
+		goto error_add_dev;
+
+	mhi_cntrl->mhi_dev = mhi_dev;
+
+	mhi_cntrl->parent = debugfs_lookup(mhi_bus_type.name, NULL);
+	mhi_cntrl->klog_lvl = MHI_MSG_LVL_ERROR;
+
+	/* adding it to this list only for debug purpose */
+	mutex_lock(&mhi_bus.lock);
+	list_add_tail(&mhi_cntrl->node, &mhi_bus.controller_list);
+	mutex_unlock(&mhi_bus.lock);
+
+	return 0;
+
+error_add_dev:
+	mhi_dealloc_device(mhi_cntrl, mhi_dev);
+
+error_alloc_dev:
+	kfree(mhi_cntrl->mhi_cmd);
+
+error_alloc_cmd:
+	kfree(mhi_cntrl->mhi_chan);
+	kfree(mhi_cntrl->mhi_event);
+
+	return ret;
+};
+EXPORT_SYMBOL(of_register_mhi_controller);
+
+void mhi_unregister_mhi_controller(struct mhi_controller *mhi_cntrl)
+{
+	struct mhi_device *mhi_dev = mhi_cntrl->mhi_dev;
+
+	kfree(mhi_cntrl->mhi_cmd);
+	kfree(mhi_cntrl->mhi_event);
+	kfree(mhi_cntrl->mhi_chan);
+	kfree(mhi_cntrl->mhi_tsync);
+
+	device_del(&mhi_dev->dev);
+	put_device(&mhi_dev->dev);
+
+	mutex_lock(&mhi_bus.lock);
+	list_del(&mhi_cntrl->node);
+	mutex_unlock(&mhi_bus.lock);
+}
+EXPORT_SYMBOL(mhi_unregister_mhi_controller);
+
+/* set ptr to control private data */
+static inline void mhi_controller_set_devdata(struct mhi_controller *mhi_cntrl,
+					      void *priv)
+{
+	mhi_cntrl->priv_data = priv;
+}
+
+/* allocate mhi controller to register */
+struct mhi_controller *mhi_alloc_controller(size_t size)
+{
+	struct mhi_controller *mhi_cntrl;
+
+	mhi_cntrl = kzalloc(size + sizeof(*mhi_cntrl), GFP_KERNEL);
+
+	if (mhi_cntrl && size)
+		mhi_controller_set_devdata(mhi_cntrl, mhi_cntrl + 1);
+
+	return mhi_cntrl;
+}
+EXPORT_SYMBOL(mhi_alloc_controller);
+
+int mhi_prepare_for_power_up(struct mhi_controller *mhi_cntrl)
+{
+	int ret;
+	u32 bhie_off;
+
+	mutex_lock(&mhi_cntrl->pm_mutex);
+
+	ret = mhi_init_dev_ctxt(mhi_cntrl);
+	if (ret) {
+		MHI_ERR("Error with init dev_ctxt\n");
+		goto error_dev_ctxt;
+	}
+
+	ret = mhi_init_irq_setup(mhi_cntrl);
+	if (ret) {
+		MHI_ERR("Error setting up irq\n");
+		goto error_setup_irq;
+	}
+
+	/*
+	 * allocate rddm table if specified, this table is for debug purpose
+	 * so we'll ignore erros
+	 */
+	if (mhi_cntrl->rddm_size) {
+		mhi_alloc_bhie_table(mhi_cntrl, &mhi_cntrl->rddm_image,
+				     mhi_cntrl->rddm_size);
+
+		/*
+		 * This controller supports rddm, we need to manually clear
+		 * BHIE RX registers since por values are undefined.
+		 */
+		ret = mhi_read_reg(mhi_cntrl, mhi_cntrl->regs, BHIEOFF,
+				   &bhie_off);
+		if (ret) {
+			MHI_ERR("Error getting bhie offset\n");
+			goto bhie_error;
+		}
+
+		memset_io(mhi_cntrl->regs + bhie_off + BHIE_RXVECADDR_LOW_OFFS,
+			  0, BHIE_RXVECSTATUS_OFFS - BHIE_RXVECADDR_LOW_OFFS +
+			  4);
+	}
+
+	mhi_cntrl->pre_init = true;
+
+	mutex_unlock(&mhi_cntrl->pm_mutex);
+
+	return 0;
+
+bhie_error:
+	if (mhi_cntrl->rddm_image) {
+		mhi_free_bhie_table(mhi_cntrl, mhi_cntrl->rddm_image);
+		mhi_cntrl->rddm_image = NULL;
+	}
+	mhi_deinit_free_irq(mhi_cntrl);
+
+error_setup_irq:
+	mhi_deinit_dev_ctxt(mhi_cntrl);
+
+error_dev_ctxt:
+	mutex_unlock(&mhi_cntrl->pm_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(mhi_prepare_for_power_up);
+
+void mhi_unprepare_after_power_down(struct mhi_controller *mhi_cntrl)
+{
+	if (mhi_cntrl->fbc_image) {
+		mhi_free_bhie_table(mhi_cntrl, mhi_cntrl->fbc_image);
+		mhi_cntrl->fbc_image = NULL;
+	}
+
+	if (mhi_cntrl->rddm_image) {
+		mhi_free_bhie_table(mhi_cntrl, mhi_cntrl->rddm_image);
+		mhi_cntrl->rddm_image = NULL;
+	}
+
+	mhi_deinit_free_irq(mhi_cntrl);
+	mhi_deinit_dev_ctxt(mhi_cntrl);
+	mhi_cntrl->pre_init = false;
+}
+
+/* match dev to drv */
+static int mhi_match(struct device *dev, struct device_driver *drv)
+{
+	struct mhi_device *mhi_dev = to_mhi_device(dev);
+	struct mhi_driver *mhi_drv = to_mhi_driver(drv);
+	const struct mhi_device_id *id;
+
+	/* if controller type there is no client driver associated with it */
+	if (mhi_dev->dev_type == MHI_CONTROLLER_TYPE)
+		return 0;
+
+	for (id = mhi_drv->id_table; id->chan[0]; id++)
+		if (!strcmp(mhi_dev->chan_name, id->chan)) {
+			mhi_dev->id = id;
+			return 1;
+		}
+
+	return 0;
+};
+
+static void mhi_release_device(struct device *dev)
+{
+	struct mhi_device *mhi_dev = to_mhi_device(dev);
+
+	if (mhi_dev->ul_chan)
+		mhi_dev->ul_chan->mhi_dev = NULL;
+
+	if (mhi_dev->dl_chan)
+		mhi_dev->dl_chan->mhi_dev = NULL;
+
+	kfree(mhi_dev);
+}
+
+struct bus_type mhi_bus_type = {
+	.name = "mhi",
+	.dev_name = "mhi",
+	.match = mhi_match,
+};
+
+static int mhi_driver_probe(struct device *dev)
+{
+	struct mhi_device *mhi_dev = to_mhi_device(dev);
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct device_driver *drv = dev->driver;
+	struct mhi_driver *mhi_drv = to_mhi_driver(drv);
+	struct mhi_event *mhi_event;
+	struct mhi_chan *ul_chan = mhi_dev->ul_chan;
+	struct mhi_chan *dl_chan = mhi_dev->dl_chan;
+	bool auto_start = false;
+	int ret;
+
+	/* bring device out of lpm */
+	ret = mhi_device_get_sync(mhi_dev);
+	if (ret)
+		return ret;
+
+	ret = -EINVAL;
+	if (ul_chan) {
+		/* lpm notification require status_cb */
+		if (ul_chan->lpm_notify && !mhi_drv->status_cb)
+			goto exit_probe;
+
+		if (!ul_chan->offload_ch && !mhi_drv->ul_xfer_cb)
+			goto exit_probe;
+
+		ul_chan->xfer_cb = mhi_drv->ul_xfer_cb;
+		mhi_dev->status_cb = mhi_drv->status_cb;
+		auto_start = ul_chan->auto_start;
+	}
+
+	if (dl_chan) {
+		if (dl_chan->lpm_notify && !mhi_drv->status_cb)
+			goto exit_probe;
+
+		if (!dl_chan->offload_ch && !mhi_drv->dl_xfer_cb)
+			goto exit_probe;
+
+		mhi_event = &mhi_cntrl->mhi_event[dl_chan->er_index];
+
+		/*
+		 * if this channal event ring manage by client, then
+		 * status_cb must be defined so we can send the async
+		 * cb whenever there are pending data
+		 */
+		if (mhi_event->cl_manage && !mhi_drv->status_cb)
+			goto exit_probe;
+
+		dl_chan->xfer_cb = mhi_drv->dl_xfer_cb;
+
+		/* ul & dl uses same status cb */
+		mhi_dev->status_cb = mhi_drv->status_cb;
+		auto_start = (auto_start || dl_chan->auto_start);
+	}
+
+	ret = mhi_drv->probe(mhi_dev, mhi_dev->id);
+
+	if (!ret && auto_start)
+		mhi_prepare_for_transfer(mhi_dev);
+
+exit_probe:
+	mhi_device_put(mhi_dev);
+
+	return ret;
+}
+
+static int mhi_driver_remove(struct device *dev)
+{
+	struct mhi_device *mhi_dev = to_mhi_device(dev);
+	struct mhi_driver *mhi_drv = to_mhi_driver(dev->driver);
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_chan *mhi_chan;
+	enum MHI_CH_STATE ch_state[] = {
+		MHI_CH_STATE_DISABLED,
+		MHI_CH_STATE_DISABLED
+	};
+	int dir;
+
+	/* control device has no work to do */
+	if (mhi_dev->dev_type == MHI_CONTROLLER_TYPE)
+		return 0;
+
+	MHI_LOG("Removing device for chan:%s\n", mhi_dev->chan_name);
+
+	/* reset both channels */
+	for (dir = 0; dir < 2; dir++) {
+		mhi_chan = dir ? mhi_dev->ul_chan : mhi_dev->dl_chan;
+
+		if (!mhi_chan)
+			continue;
+
+		/* wake all threads waiting for completion */
+		write_lock_irq(&mhi_chan->lock);
+		mhi_chan->ccs = MHI_EV_CC_INVALID;
+		complete_all(&mhi_chan->completion);
+		write_unlock_irq(&mhi_chan->lock);
+
+		/* move channel state to disable, no more processing */
+		mutex_lock(&mhi_chan->mutex);
+		write_lock_irq(&mhi_chan->lock);
+		ch_state[dir] = mhi_chan->ch_state;
+		mhi_chan->ch_state = MHI_CH_STATE_SUSPENDED;
+		write_unlock_irq(&mhi_chan->lock);
+
+		/* reset the channel */
+		if (!mhi_chan->offload_ch)
+			mhi_reset_chan(mhi_cntrl, mhi_chan);
+
+		mutex_unlock(&mhi_chan->mutex);
+	}
+
+	/* destroy the device */
+	mhi_drv->remove(mhi_dev);
+
+	/* de_init channel if it was enabled */
+	for (dir = 0; dir < 2; dir++) {
+		mhi_chan = dir ? mhi_dev->ul_chan : mhi_dev->dl_chan;
+
+		if (!mhi_chan)
+			continue;
+
+		mutex_lock(&mhi_chan->mutex);
+
+		if (ch_state[dir] == MHI_CH_STATE_ENABLED &&
+		    !mhi_chan->offload_ch)
+			mhi_deinit_chan_ctxt(mhi_cntrl, mhi_chan);
+
+		mhi_chan->ch_state = MHI_CH_STATE_DISABLED;
+
+		mutex_unlock(&mhi_chan->mutex);
+	}
+
+	if (mhi_cntrl->tsync_dev == mhi_dev)
+		mhi_cntrl->tsync_dev = NULL;
+
+	/* relinquish any pending votes */
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	while (atomic_read(&mhi_dev->dev_wake))
+		mhi_device_put(mhi_dev);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	return 0;
+}
+
+int mhi_driver_register(struct mhi_driver *mhi_drv)
+{
+	struct device_driver *driver = &mhi_drv->driver;
+
+	if (!mhi_drv->probe || !mhi_drv->remove)
+		return -EINVAL;
+
+	driver->bus = &mhi_bus_type;
+	driver->probe = mhi_driver_probe;
+	driver->remove = mhi_driver_remove;
+	return driver_register(driver);
+}
+EXPORT_SYMBOL(mhi_driver_register);
+
+void mhi_driver_unregister(struct mhi_driver *mhi_drv)
+{
+	driver_unregister(&mhi_drv->driver);
+}
+EXPORT_SYMBOL(mhi_driver_unregister);
+
+struct mhi_device *mhi_alloc_device(struct mhi_controller *mhi_cntrl)
+{
+	struct mhi_device *mhi_dev = kzalloc(sizeof(*mhi_dev), GFP_KERNEL);
+	struct device *dev;
+
+	if (!mhi_dev)
+		return NULL;
+
+	dev = &mhi_dev->dev;
+	device_initialize(dev);
+	dev->bus = &mhi_bus_type;
+	dev->release = mhi_release_device;
+	dev->parent = mhi_cntrl->dev;
+	mhi_dev->mhi_cntrl = mhi_cntrl;
+	mhi_dev->dev_id = mhi_cntrl->dev_id;
+	mhi_dev->domain = mhi_cntrl->domain;
+	mhi_dev->bus = mhi_cntrl->bus;
+	mhi_dev->slot = mhi_cntrl->slot;
+	mhi_dev->mtu = MHI_MAX_MTU;
+	atomic_set(&mhi_dev->dev_wake, 0);
+
+	return mhi_dev;
+}
+
+static int __init mhi_init(void)
+{
+	int ret;
+
+	mutex_init(&mhi_bus.lock);
+	INIT_LIST_HEAD(&mhi_bus.controller_list);
+
+	/* parent directory */
+	debugfs_create_dir(mhi_bus_type.name, NULL);
+
+	ret = bus_register(&mhi_bus_type);
+
+	if (!ret)
+		mhi_dtr_init();
+	return ret;
+}
+
+module_init(mhi_init);
+
+static void __exit mhi_exit(void)
+{
+	struct dentry *dentry;
+
+	bus_unregister(&mhi_bus_type);
+	dentry = debugfs_lookup(mhi_bus_type.name, NULL);
+	debugfs_remove(dentry);
+}
+
+module_exit(mhi_exit);
+
+MODULE_AUTHOR("Qualcomm Corporation");
+MODULE_DESCRIPTION("Qualcomm Modem Host Interface Bus Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/bus/mhi/core/mhi_internal.h b/drivers/bus/mhi/core/mhi_internal.h
new file mode 100644
index 000000000000..380712ba451e
--- /dev/null
+++ b/drivers/bus/mhi/core/mhi_internal.h
@@ -0,0 +1,826 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2018-2019, The Linux Foundation. All rights reserved. */
+
+#ifndef _MHI_INT_H
+#define _MHI_INT_H
+
+extern struct bus_type mhi_bus_type;
+
+/* MHI mmio register mapping */
+#define PCI_INVALID_READ(val) (val == U32_MAX)
+
+#define MHIREGLEN (0x0)
+#define MHIREGLEN_MHIREGLEN_MASK (0xFFFFFFFF)
+#define MHIREGLEN_MHIREGLEN_SHIFT (0)
+
+#define MHIVER (0x8)
+#define MHIVER_MHIVER_MASK (0xFFFFFFFF)
+#define MHIVER_MHIVER_SHIFT (0)
+
+#define MHICFG (0x10)
+#define MHICFG_NHWER_MASK (0xFF000000)
+#define MHICFG_NHWER_SHIFT (24)
+#define MHICFG_NER_MASK (0xFF0000)
+#define MHICFG_NER_SHIFT (16)
+#define MHICFG_NHWCH_MASK (0xFF00)
+#define MHICFG_NHWCH_SHIFT (8)
+#define MHICFG_NCH_MASK (0xFF)
+#define MHICFG_NCH_SHIFT (0)
+
+#define CHDBOFF (0x18)
+#define CHDBOFF_CHDBOFF_MASK (0xFFFFFFFF)
+#define CHDBOFF_CHDBOFF_SHIFT (0)
+
+#define ERDBOFF (0x20)
+#define ERDBOFF_ERDBOFF_MASK (0xFFFFFFFF)
+#define ERDBOFF_ERDBOFF_SHIFT (0)
+
+#define BHIOFF (0x28)
+#define BHIOFF_BHIOFF_MASK (0xFFFFFFFF)
+#define BHIOFF_BHIOFF_SHIFT (0)
+
+#define BHIEOFF (0x2C)
+#define BHIEOFF_BHIEOFF_MASK (0xFFFFFFFF)
+#define BHIEOFF_BHIEOFF_SHIFT (0)
+
+#define DEBUGOFF (0x30)
+#define DEBUGOFF_DEBUGOFF_MASK (0xFFFFFFFF)
+#define DEBUGOFF_DEBUGOFF_SHIFT (0)
+
+#define MHICTRL (0x38)
+#define MHICTRL_MHISTATE_MASK (0x0000FF00)
+#define MHICTRL_MHISTATE_SHIFT (8)
+#define MHICTRL_RESET_MASK (0x2)
+#define MHICTRL_RESET_SHIFT (1)
+
+#define MHISTATUS (0x48)
+#define MHISTATUS_MHISTATE_MASK (0x0000FF00)
+#define MHISTATUS_MHISTATE_SHIFT (8)
+#define MHISTATUS_SYSERR_MASK (0x4)
+#define MHISTATUS_SYSERR_SHIFT (2)
+#define MHISTATUS_READY_MASK (0x1)
+#define MHISTATUS_READY_SHIFT (0)
+
+#define CCABAP_LOWER (0x58)
+#define CCABAP_LOWER_CCABAP_LOWER_MASK (0xFFFFFFFF)
+#define CCABAP_LOWER_CCABAP_LOWER_SHIFT (0)
+
+#define CCABAP_HIGHER (0x5C)
+#define CCABAP_HIGHER_CCABAP_HIGHER_MASK (0xFFFFFFFF)
+#define CCABAP_HIGHER_CCABAP_HIGHER_SHIFT (0)
+
+#define ECABAP_LOWER (0x60)
+#define ECABAP_LOWER_ECABAP_LOWER_MASK (0xFFFFFFFF)
+#define ECABAP_LOWER_ECABAP_LOWER_SHIFT (0)
+
+#define ECABAP_HIGHER (0x64)
+#define ECABAP_HIGHER_ECABAP_HIGHER_MASK (0xFFFFFFFF)
+#define ECABAP_HIGHER_ECABAP_HIGHER_SHIFT (0)
+
+#define CRCBAP_LOWER (0x68)
+#define CRCBAP_LOWER_CRCBAP_LOWER_MASK (0xFFFFFFFF)
+#define CRCBAP_LOWER_CRCBAP_LOWER_SHIFT (0)
+
+#define CRCBAP_HIGHER (0x6C)
+#define CRCBAP_HIGHER_CRCBAP_HIGHER_MASK (0xFFFFFFFF)
+#define CRCBAP_HIGHER_CRCBAP_HIGHER_SHIFT (0)
+
+#define CRDB_LOWER (0x70)
+#define CRDB_LOWER_CRDB_LOWER_MASK (0xFFFFFFFF)
+#define CRDB_LOWER_CRDB_LOWER_SHIFT (0)
+
+#define CRDB_HIGHER (0x74)
+#define CRDB_HIGHER_CRDB_HIGHER_MASK (0xFFFFFFFF)
+#define CRDB_HIGHER_CRDB_HIGHER_SHIFT (0)
+
+#define MHICTRLBASE_LOWER (0x80)
+#define MHICTRLBASE_LOWER_MHICTRLBASE_LOWER_MASK (0xFFFFFFFF)
+#define MHICTRLBASE_LOWER_MHICTRLBASE_LOWER_SHIFT (0)
+
+#define MHICTRLBASE_HIGHER (0x84)
+#define MHICTRLBASE_HIGHER_MHICTRLBASE_HIGHER_MASK (0xFFFFFFFF)
+#define MHICTRLBASE_HIGHER_MHICTRLBASE_HIGHER_SHIFT (0)
+
+#define MHICTRLLIMIT_LOWER (0x88)
+#define MHICTRLLIMIT_LOWER_MHICTRLLIMIT_LOWER_MASK (0xFFFFFFFF)
+#define MHICTRLLIMIT_LOWER_MHICTRLLIMIT_LOWER_SHIFT (0)
+
+#define MHICTRLLIMIT_HIGHER (0x8C)
+#define MHICTRLLIMIT_HIGHER_MHICTRLLIMIT_HIGHER_MASK (0xFFFFFFFF)
+#define MHICTRLLIMIT_HIGHER_MHICTRLLIMIT_HIGHER_SHIFT (0)
+
+#define MHIDATABASE_LOWER (0x98)
+#define MHIDATABASE_LOWER_MHIDATABASE_LOWER_MASK (0xFFFFFFFF)
+#define MHIDATABASE_LOWER_MHIDATABASE_LOWER_SHIFT (0)
+
+#define MHIDATABASE_HIGHER (0x9C)
+#define MHIDATABASE_HIGHER_MHIDATABASE_HIGHER_MASK (0xFFFFFFFF)
+#define MHIDATABASE_HIGHER_MHIDATABASE_HIGHER_SHIFT (0)
+
+#define MHIDATALIMIT_LOWER (0xA0)
+#define MHIDATALIMIT_LOWER_MHIDATALIMIT_LOWER_MASK (0xFFFFFFFF)
+#define MHIDATALIMIT_LOWER_MHIDATALIMIT_LOWER_SHIFT (0)
+
+#define MHIDATALIMIT_HIGHER (0xA4)
+#define MHIDATALIMIT_HIGHER_MHIDATALIMIT_HIGHER_MASK (0xFFFFFFFF)
+#define MHIDATALIMIT_HIGHER_MHIDATALIMIT_HIGHER_SHIFT (0)
+
+/* Host request register */
+#define MHI_SOC_RESET_REQ_OFFSET (0xB0)
+#define MHI_SOC_RESET_REQ BIT(0)
+
+/* MHI misc capability registers */
+#define MISC_OFFSET (0x24)
+#define MISC_CAP_MASK (0xFFFFFFFF)
+#define MISC_CAP_SHIFT (0)
+
+#define CAP_CAPID_MASK (0xFF000000)
+#define CAP_CAPID_SHIFT (24)
+#define CAP_NEXT_CAP_MASK (0x00FFF000)
+#define CAP_NEXT_CAP_SHIFT (12)
+
+/* MHI Timesync offsets */
+#define TIMESYNC_CFG_OFFSET (0x00)
+#define TIMESYNC_CFG_CAPID_MASK (CAP_CAPID_MASK)
+#define TIMESYNC_CFG_CAPID_SHIFT (CAP_CAPID_SHIFT)
+#define TIMESYNC_CFG_NEXT_OFF_MASK (CAP_NEXT_CAP_MASK)
+#define TIMESYNC_CFG_NEXT_OFF_SHIFT (CAP_NEXT_CAP_SHIFT)
+#define TIMESYNC_CFG_NUMCMD_MASK (0xFF)
+#define TIMESYNC_CFG_NUMCMD_SHIFT (0)
+#define TIMESYNC_DB_OFFSET (0x4)
+#define TIMESYNC_TIME_LOW_OFFSET (0x8)
+#define TIMESYNC_TIME_HIGH_OFFSET (0xC)
+
+#define TIMESYNC_CAP_ID (2)
+
+/* MHI BHI offfsets */
+#define BHI_BHIVERSION_MINOR (0x00)
+#define BHI_BHIVERSION_MAJOR (0x04)
+#define BHI_IMGADDR_LOW (0x08)
+#define BHI_IMGADDR_HIGH (0x0C)
+#define BHI_IMGSIZE (0x10)
+#define BHI_RSVD1 (0x14)
+#define BHI_IMGTXDB (0x18)
+#define BHI_TXDB_SEQNUM_BMSK (0x3FFFFFFF)
+#define BHI_TXDB_SEQNUM_SHFT (0)
+#define BHI_RSVD2 (0x1C)
+#define BHI_INTVEC (0x20)
+#define BHI_RSVD3 (0x24)
+#define BHI_EXECENV (0x28)
+#define BHI_STATUS (0x2C)
+#define BHI_ERRCODE (0x30)
+#define BHI_ERRDBG1 (0x34)
+#define BHI_ERRDBG2 (0x38)
+#define BHI_ERRDBG3 (0x3C)
+#define BHI_SERIALNU (0x40)
+#define BHI_SBLANTIROLLVER (0x44)
+#define BHI_NUMSEG (0x48)
+#define BHI_MSMHWID(n) (0x4C + (0x4 * n))
+#define BHI_OEMPKHASH(n) (0x64 + (0x4 * n))
+#define BHI_RSVD5 (0xC4)
+#define BHI_STATUS_MASK (0xC0000000)
+#define BHI_STATUS_SHIFT (30)
+#define BHI_STATUS_ERROR (3)
+#define BHI_STATUS_SUCCESS (2)
+#define BHI_STATUS_RESET (0)
+
+/* MHI BHIE offsets */
+#define BHIE_MSMSOCID_OFFS (0x0000)
+#define BHIE_TXVECADDR_LOW_OFFS (0x002C)
+#define BHIE_TXVECADDR_HIGH_OFFS (0x0030)
+#define BHIE_TXVECSIZE_OFFS (0x0034)
+#define BHIE_TXVECDB_OFFS (0x003C)
+#define BHIE_TXVECDB_SEQNUM_BMSK (0x3FFFFFFF)
+#define BHIE_TXVECDB_SEQNUM_SHFT (0)
+#define BHIE_TXVECSTATUS_OFFS (0x0044)
+#define BHIE_TXVECSTATUS_SEQNUM_BMSK (0x3FFFFFFF)
+#define BHIE_TXVECSTATUS_SEQNUM_SHFT (0)
+#define BHIE_TXVECSTATUS_STATUS_BMSK (0xC0000000)
+#define BHIE_TXVECSTATUS_STATUS_SHFT (30)
+#define BHIE_TXVECSTATUS_STATUS_RESET (0x00)
+#define BHIE_TXVECSTATUS_STATUS_XFER_COMPL (0x02)
+#define BHIE_TXVECSTATUS_STATUS_ERROR (0x03)
+#define BHIE_RXVECADDR_LOW_OFFS (0x0060)
+#define BHIE_RXVECADDR_HIGH_OFFS (0x0064)
+#define BHIE_RXVECSIZE_OFFS (0x0068)
+#define BHIE_RXVECDB_OFFS (0x0070)
+#define BHIE_RXVECDB_SEQNUM_BMSK (0x3FFFFFFF)
+#define BHIE_RXVECDB_SEQNUM_SHFT (0)
+#define BHIE_RXVECSTATUS_OFFS (0x0078)
+#define BHIE_RXVECSTATUS_SEQNUM_BMSK (0x3FFFFFFF)
+#define BHIE_RXVECSTATUS_SEQNUM_SHFT (0)
+#define BHIE_RXVECSTATUS_STATUS_BMSK (0xC0000000)
+#define BHIE_RXVECSTATUS_STATUS_SHFT (30)
+#define BHIE_RXVECSTATUS_STATUS_RESET (0x00)
+#define BHIE_RXVECSTATUS_STATUS_XFER_COMPL (0x02)
+#define BHIE_RXVECSTATUS_STATUS_ERROR (0x03)
+
+/* convert ticks to micro seconds by dividing by 19.2 */
+#define TIME_TICKS_TO_US(x) (div_u64((x) * 10, 192))
+
+struct mhi_event_ctxt {
+	u32 reserved:8;
+	u32 intmodc:8;
+	u32 intmodt:16;
+	u32 ertype;
+	u32 msivec;
+
+	u64 rbase __packed __aligned(4);
+	u64 rlen __packed __aligned(4);
+	u64 rp __packed __aligned(4);
+	u64 wp __packed __aligned(4);
+};
+
+struct mhi_chan_ctxt {
+	u32 chstate:8;
+	u32 brstmode:2;
+	u32 pollcfg:6;
+	u32 reserved:16;
+	u32 chtype;
+	u32 erindex;
+
+	u64 rbase __packed __aligned(4);
+	u64 rlen __packed __aligned(4);
+	u64 rp __packed __aligned(4);
+	u64 wp __packed __aligned(4);
+};
+
+struct mhi_cmd_ctxt {
+	u32 reserved0;
+	u32 reserved1;
+	u32 reserved2;
+
+	u64 rbase __packed __aligned(4);
+	u64 rlen __packed __aligned(4);
+	u64 rp __packed __aligned(4);
+	u64 wp __packed __aligned(4);
+};
+
+struct mhi_tre {
+	u64 ptr;
+	u32 dword[2];
+};
+
+struct bhi_vec_entry {
+	u64 dma_addr;
+	u64 size;
+};
+
+enum mhi_cmd_type {
+	MHI_CMD_TYPE_NOP = 1,
+	MHI_CMD_TYPE_RESET = 16,
+	MHI_CMD_TYPE_STOP = 17,
+	MHI_CMD_TYPE_START = 18,
+	MHI_CMD_TYPE_TSYNC = 24,
+};
+
+/* no operation command */
+#define MHI_TRE_CMD_NOOP_PTR (0)
+#define MHI_TRE_CMD_NOOP_DWORD0 (0)
+#define MHI_TRE_CMD_NOOP_DWORD1 (MHI_CMD_TYPE_NOP << 16)
+
+/* channel reset command */
+#define MHI_TRE_CMD_RESET_PTR (0)
+#define MHI_TRE_CMD_RESET_DWORD0 (0)
+#define MHI_TRE_CMD_RESET_DWORD1(chid) ((chid << 24) | \
+					(MHI_CMD_TYPE_RESET << 16))
+
+/* channel stop command */
+#define MHI_TRE_CMD_STOP_PTR (0)
+#define MHI_TRE_CMD_STOP_DWORD0 (0)
+#define MHI_TRE_CMD_STOP_DWORD1(chid) ((chid << 24) | (MHI_CMD_TYPE_STOP << 16))
+
+/* channel start command */
+#define MHI_TRE_CMD_START_PTR (0)
+#define MHI_TRE_CMD_START_DWORD0 (0)
+#define MHI_TRE_CMD_START_DWORD1(chid) ((chid << 24) | \
+					(MHI_CMD_TYPE_START << 16))
+
+/* time sync cfg command */
+#define MHI_TRE_CMD_TSYNC_CFG_PTR (0)
+#define MHI_TRE_CMD_TSYNC_CFG_DWORD0 (0)
+#define MHI_TRE_CMD_TSYNC_CFG_DWORD1(er) ((MHI_CMD_TYPE_TSYNC << 16) | \
+					  (er << 24))
+
+#define MHI_TRE_GET_CMD_CHID(tre) (((tre)->dword[1] >> 24) & 0xFF)
+#define MHI_TRE_GET_CMD_TYPE(tre) (((tre)->dword[1] >> 16) & 0xFF)
+
+/* event descriptor macros */
+#define MHI_TRE_EV_PTR(ptr) (ptr)
+#define MHI_TRE_EV_DWORD0(code, len) ((code << 24) | len)
+#define MHI_TRE_EV_DWORD1(chid, type) ((chid << 24) | (type << 16))
+#define MHI_TRE_GET_EV_PTR(tre) ((tre)->ptr)
+#define MHI_TRE_GET_EV_CODE(tre) (((tre)->dword[0] >> 24) & 0xFF)
+#define MHI_TRE_GET_EV_LEN(tre) ((tre)->dword[0] & 0xFFFF)
+#define MHI_TRE_GET_EV_CHID(tre) (((tre)->dword[1] >> 24) & 0xFF)
+#define MHI_TRE_GET_EV_TYPE(tre) (((tre)->dword[1] >> 16) & 0xFF)
+#define MHI_TRE_GET_EV_STATE(tre) (((tre)->dword[0] >> 24) & 0xFF)
+#define MHI_TRE_GET_EV_EXECENV(tre) (((tre)->dword[0] >> 24) & 0xFF)
+#define MHI_TRE_GET_EV_SEQ(tre) ((tre)->dword[0])
+#define MHI_TRE_GET_EV_TIME(tre) ((tre)->ptr)
+#define MHI_TRE_GET_EV_COOKIE(tre) lower_32_bits((tre)->ptr)
+#define MHI_TRE_GET_EV_VEID(tre) (((tre)->dword[0] >> 16) & 0xFF)
+
+/* transfer descriptor macros */
+#define MHI_TRE_DATA_PTR(ptr) (ptr)
+#define MHI_TRE_DATA_DWORD0(len) (len & MHI_MAX_MTU)
+#define MHI_TRE_DATA_DWORD1(bei, ieot, ieob, chain) ((2 << 16) | (bei << 10) \
+	| (ieot << 9) | (ieob << 8) | chain)
+
+/* rsc transfer descriptor macros */
+#define MHI_RSCTRE_DATA_PTR(ptr, len) (((u64)len << 48) | ptr)
+#define MHI_RSCTRE_DATA_DWORD0(cookie) (cookie)
+#define MHI_RSCTRE_DATA_DWORD1 (MHI_PKT_TYPE_COALESCING << 16)
+
+enum MHI_CMD {
+	MHI_CMD_RESET_CHAN,
+	MHI_CMD_START_CHAN,
+	MHI_CMD_TIMSYNC_CFG,
+};
+
+enum MHI_PKT_TYPE {
+	MHI_PKT_TYPE_INVALID = 0x0,
+	MHI_PKT_TYPE_NOOP_CMD = 0x1,
+	MHI_PKT_TYPE_TRANSFER = 0x2,
+	MHI_PKT_TYPE_COALESCING = 0x8,
+	MHI_PKT_TYPE_RESET_CHAN_CMD = 0x10,
+	MHI_PKT_TYPE_STOP_CHAN_CMD = 0x11,
+	MHI_PKT_TYPE_START_CHAN_CMD = 0x12,
+	MHI_PKT_TYPE_STATE_CHANGE_EVENT = 0x20,
+	MHI_PKT_TYPE_CMD_COMPLETION_EVENT = 0x21,
+	MHI_PKT_TYPE_TX_EVENT = 0x22,
+	MHI_PKT_TYPE_RSC_TX_EVENT = 0x28,
+	MHI_PKT_TYPE_EE_EVENT = 0x40,
+	MHI_PKT_TYPE_TSYNC_EVENT = 0x48,
+	MHI_PKT_TYPE_STALE_EVENT,	/* internal event */
+};
+
+/* MHI transfer completion events */
+enum MHI_EV_CCS {
+	MHI_EV_CC_INVALID = 0x0,
+	MHI_EV_CC_SUCCESS = 0x1,
+	MHI_EV_CC_EOT = 0x2,
+	MHI_EV_CC_OVERFLOW = 0x3,
+	MHI_EV_CC_EOB = 0x4,
+	MHI_EV_CC_OOB = 0x5,
+	MHI_EV_CC_DB_MODE = 0x6,
+	MHI_EV_CC_UNDEFINED_ERR = 0x10,
+	MHI_EV_CC_BAD_TRE = 0x11,
+};
+
+enum MHI_CH_STATE {
+	MHI_CH_STATE_DISABLED = 0x0,
+	MHI_CH_STATE_ENABLED = 0x1,
+	MHI_CH_STATE_RUNNING = 0x2,
+	MHI_CH_STATE_SUSPENDED = 0x3,
+	MHI_CH_STATE_STOP = 0x4,
+	MHI_CH_STATE_ERROR = 0x5,
+};
+
+enum MHI_BRSTMODE {
+	MHI_BRSTMODE_DISABLE = 0x2,
+	MHI_BRSTMODE_ENABLE = 0x3,
+};
+
+#define MHI_INVALID_BRSTMODE(mode) (mode != MHI_BRSTMODE_DISABLE && \
+				    mode != MHI_BRSTMODE_ENABLE)
+
+#define MHI_IN_PBL(ee) (ee == MHI_EE_PBL || ee == MHI_EE_PTHRU || \
+			ee == MHI_EE_EDL)
+
+#define MHI_IN_MISSION_MODE(ee) (ee == MHI_EE_AMSS || ee == MHI_EE_WFW)
+
+enum MHI_ST_TRANSITION {
+	MHI_ST_TRANSITION_PBL,
+	MHI_ST_TRANSITION_READY,
+	MHI_ST_TRANSITION_SBL,
+	MHI_ST_TRANSITION_MISSION_MODE,
+	MHI_ST_TRANSITION_MAX,
+};
+
+extern const char *const mhi_state_tran_str[MHI_ST_TRANSITION_MAX];
+#define TO_MHI_STATE_TRANS_STR(state) (((state) >= MHI_ST_TRANSITION_MAX) ? \
+				"INVALID_STATE" : mhi_state_tran_str[state])
+
+extern const char *const mhi_state_str[MHI_STATE_MAX];
+#define TO_MHI_STATE_STR(state) ((state >= MHI_STATE_MAX || \
+				  !mhi_state_str[state]) ? \
+				"INVALID_STATE" : mhi_state_str[state])
+
+enum {
+	MHI_PM_BIT_DISABLE,
+	MHI_PM_BIT_POR,
+	MHI_PM_BIT_M0,
+	MHI_PM_BIT_M2,
+	MHI_PM_BIT_M3_ENTER,
+	MHI_PM_BIT_M3,
+	MHI_PM_BIT_M3_EXIT,
+	MHI_PM_BIT_FW_DL_ERR,
+	MHI_PM_BIT_SYS_ERR_DETECT,
+	MHI_PM_BIT_SYS_ERR_PROCESS,
+	MHI_PM_BIT_SHUTDOWN_PROCESS,
+	MHI_PM_BIT_LD_ERR_FATAL_DETECT,
+	MHI_PM_BIT_MAX
+};
+
+/* internal power states */
+enum MHI_PM_STATE {
+	MHI_PM_DISABLE = BIT(MHI_PM_BIT_DISABLE),    /* MHI is not enabled */
+	MHI_PM_POR = BIT(MHI_PM_BIT_POR),            /* reset state */
+	MHI_PM_M0 = BIT(MHI_PM_BIT_M0),
+	MHI_PM_M2 = BIT(MHI_PM_BIT_M2),
+	MHI_PM_M3_ENTER = BIT(MHI_PM_BIT_M3_ENTER),
+	MHI_PM_M3 = BIT(MHI_PM_BIT_M3),
+	MHI_PM_M3_EXIT = BIT(MHI_PM_BIT_M3_EXIT),
+	/* firmware download failure state */
+	MHI_PM_FW_DL_ERR = BIT(MHI_PM_BIT_FW_DL_ERR),
+	MHI_PM_SYS_ERR_DETECT = BIT(MHI_PM_BIT_SYS_ERR_DETECT),
+	MHI_PM_SYS_ERR_PROCESS = BIT(MHI_PM_BIT_SYS_ERR_PROCESS),
+	MHI_PM_SHUTDOWN_PROCESS = BIT(MHI_PM_BIT_SHUTDOWN_PROCESS),
+	/* link not accessible */
+	MHI_PM_LD_ERR_FATAL_DETECT = BIT(MHI_PM_BIT_LD_ERR_FATAL_DETECT),
+};
+
+#define MHI_REG_ACCESS_VALID(pm_state) ((pm_state & (MHI_PM_POR | MHI_PM_M0 | \
+		MHI_PM_M2 | MHI_PM_M3_ENTER | MHI_PM_M3_EXIT | \
+		MHI_PM_SYS_ERR_DETECT | MHI_PM_SYS_ERR_PROCESS | \
+		MHI_PM_SHUTDOWN_PROCESS | MHI_PM_FW_DL_ERR)))
+#define MHI_PM_IN_ERROR_STATE(pm_state) (pm_state >= MHI_PM_FW_DL_ERR)
+#define MHI_PM_IN_FATAL_STATE(pm_state) (pm_state == MHI_PM_LD_ERR_FATAL_DETECT)
+#define MHI_DB_ACCESS_VALID(pm_state) (pm_state & MHI_PM_M0)
+#define MHI_WAKE_DB_CLEAR_VALID(pm_state) (pm_state & (MHI_PM_M0 | \
+						MHI_PM_M2 | MHI_PM_M3_EXIT))
+#define MHI_WAKE_DB_SET_VALID(pm_state) (pm_state & MHI_PM_M2)
+#define MHI_WAKE_DB_FORCE_SET_VALID(pm_state) MHI_WAKE_DB_CLEAR_VALID(pm_state)
+#define MHI_EVENT_ACCESS_INVALID(pm_state) (pm_state == MHI_PM_DISABLE || \
+					    MHI_PM_IN_ERROR_STATE(pm_state))
+#define MHI_PM_IN_SUSPEND_STATE(pm_state) (pm_state & \
+					   (MHI_PM_M3_ENTER | MHI_PM_M3))
+
+/* accepted buffer type for the channel */
+enum MHI_XFER_TYPE {
+	MHI_XFER_BUFFER,
+	MHI_XFER_SKB,
+	MHI_XFER_SCLIST,
+	MHI_XFER_NOP,  /* CPU offload channel, host does not accept transfer */
+	MHI_XFER_DMA,  /* receive dma address, already mapped by client */
+	MHI_XFER_RSC_DMA, /* RSC type, accept premapped buffer */
+};
+
+#define NR_OF_CMD_RINGS (1)
+#define CMD_EL_PER_RING (128)
+#define PRIMARY_CMD_RING (0)
+#define MHI_DEV_WAKE_DB (127)
+#define MHI_MAX_MTU (0xffff)
+
+enum MHI_ER_TYPE {
+	MHI_ER_TYPE_INVALID = 0x0,
+	MHI_ER_TYPE_VALID = 0x1,
+};
+
+enum mhi_er_data_type {
+	MHI_ER_DATA_ELEMENT_TYPE,
+	MHI_ER_CTRL_ELEMENT_TYPE,
+	MHI_ER_TSYNC_ELEMENT_TYPE,
+	MHI_ER_DATA_TYPE_MAX = MHI_ER_TSYNC_ELEMENT_TYPE,
+};
+
+enum mhi_ch_ee_mask {
+	MHI_CH_EE_PBL = BIT(MHI_EE_PBL),
+	MHI_CH_EE_SBL = BIT(MHI_EE_SBL),
+	MHI_CH_EE_AMSS = BIT(MHI_EE_AMSS),
+	MHI_CH_EE_RDDM = BIT(MHI_EE_RDDM),
+	MHI_CH_EE_PTHRU = BIT(MHI_EE_PTHRU),
+	MHI_CH_EE_WFW = BIT(MHI_EE_WFW),
+	MHI_CH_EE_EDL = BIT(MHI_EE_EDL),
+};
+
+enum mhi_ch_type {
+	MHI_CH_TYPE_INVALID = 0,
+	MHI_CH_TYPE_OUTBOUND = DMA_TO_DEVICE,
+	MHI_CH_TYPE_INBOUND = DMA_FROM_DEVICE,
+	MHI_CH_TYPE_INBOUND_COALESCED = 3,
+};
+
+struct db_cfg {
+	bool reset_req;
+	bool db_mode;
+	u32 pollcfg;
+	enum MHI_BRSTMODE brstmode;
+	dma_addr_t db_val;
+	void (*process_db)(struct mhi_controller *mhi_cntrl,
+			   struct db_cfg *db_cfg, void __iomem *io_addr,
+			   dma_addr_t db_val);
+};
+
+struct mhi_pm_transitions {
+	enum MHI_PM_STATE from_state;
+	u32 to_states;
+};
+
+struct state_transition {
+	struct list_head node;
+	enum MHI_ST_TRANSITION state;
+};
+
+struct mhi_ctxt {
+	struct mhi_event_ctxt *er_ctxt;
+	struct mhi_chan_ctxt *chan_ctxt;
+	struct mhi_cmd_ctxt *cmd_ctxt;
+	dma_addr_t er_ctxt_addr;
+	dma_addr_t chan_ctxt_addr;
+	dma_addr_t cmd_ctxt_addr;
+};
+
+struct mhi_ring {
+	dma_addr_t dma_handle;
+	dma_addr_t iommu_base;
+	u64 *ctxt_wp;		/* point to ctxt wp */
+	void *pre_aligned;
+	void *base;
+	void *rptr;
+	void *wptr;
+	size_t el_size;
+	size_t len;
+	size_t elements;
+	size_t alloc_size;
+	void __iomem *db_addr;
+};
+
+struct mhi_cmd {
+	struct mhi_ring ring;
+	spinlock_t lock;
+};
+
+struct mhi_buf_info {
+	dma_addr_t p_addr;
+	void *v_addr;
+	void *bb_addr;
+	void *wp;
+	size_t len;
+	void *cb_buf;
+	bool used;		/* indicate element is free to use */
+	bool pre_mapped;	/* already pre-mapped by client */
+	enum dma_data_direction dir;
+};
+
+struct mhi_event {
+	u32 er_index;
+	u32 intmod;
+	u32 msi;
+	int chan;		/* this event ring is dedicated to a channel */
+	u32 priority;
+	enum mhi_er_data_type data_type;
+	struct mhi_ring ring;
+	struct db_cfg db_cfg;
+	bool hw_ring;
+	bool cl_manage;
+	bool offload_ev;	/* managed by a device driver */
+	spinlock_t lock;
+	struct mhi_chan *mhi_chan;	/* dedicated to channel */
+	struct tasklet_struct task;
+	int (*process_event)(struct mhi_controller *mhi_cntrl,
+			     struct mhi_event *mhi_event, u32 event_quota);
+	struct mhi_controller *mhi_cntrl;
+};
+
+struct mhi_chan {
+	u32 chan;
+	const char *name;
+	/*
+	 * important, when consuming increment tre_ring first, when releasing
+	 * decrement buf_ring first. If tre_ring has space, buf_ring
+	 * guranteed to have space so we do not need to check both rings.
+	 */
+	struct mhi_ring buf_ring;
+	struct mhi_ring tre_ring;
+	u32 er_index;
+	u32 intmod;
+	enum mhi_ch_type type;
+	enum dma_data_direction dir;
+	struct db_cfg db_cfg;
+	u32 ee_mask;
+	enum MHI_XFER_TYPE xfer_type;
+	enum MHI_CH_STATE ch_state;
+	enum MHI_EV_CCS ccs;
+	bool lpm_notify;
+	bool configured;
+	bool offload_ch;
+	bool pre_alloc;
+	bool auto_start;
+	bool wake_capable;	/* channel should wake up system */
+	/* functions that generate the transfer ring elements */
+	int (*gen_tre)(struct mhi_controller *mhi_cntrl,
+		       struct mhi_chan *mhi_chan, void *buf, void *cb,
+		       size_t len, enum MHI_FLAGS flags);
+	int (*queue_xfer)(struct mhi_device *mhi_dev,
+			  struct mhi_chan *mhi_chan, void *buf,
+			  size_t len, enum MHI_FLAGS flags);
+	/* xfer call back */
+	struct mhi_device *mhi_dev;
+	void (*xfer_cb)(struct mhi_device *mhi_dev,
+			struct mhi_result *result);
+	struct mutex mutex;
+	struct completion completion;
+	rwlock_t lock;
+	struct list_head node;
+};
+
+struct tsync_node {
+	struct list_head node;
+	u32 sequence;
+	u64 local_time;
+	u64 remote_time;
+	struct mhi_device *mhi_dev;
+	void (*cb_func)(struct mhi_device *mhi_dev, u32 sequence,
+			u64 local_time, u64 remote_time);
+};
+
+struct mhi_timesync {
+	u32 er_index;
+	void __iomem *db;
+	void __iomem *time_reg;
+	enum MHI_EV_CCS ccs;
+	struct completion completion;
+	spinlock_t lock;	/* list protection */
+	struct mutex lpm_mutex;	/* lpm protection */
+	struct list_head head;
+};
+
+struct mhi_bus {
+	struct list_head controller_list;
+	struct mutex lock;
+};
+
+/* default MHI timeout */
+#define MHI_TIMEOUT_MS (1000)
+extern struct mhi_bus mhi_bus;
+
+/* debug fs related functions */
+int mhi_debugfs_mhi_chan_show(struct seq_file *m, void *d);
+int mhi_debugfs_mhi_event_show(struct seq_file *m, void *d);
+int mhi_debugfs_mhi_states_show(struct seq_file *m, void *d);
+int mhi_debugfs_trigger_reset(void *data, u64 val);
+
+void mhi_deinit_debugfs(struct mhi_controller *mhi_cntrl);
+void mhi_init_debugfs(struct mhi_controller *mhi_cntrl);
+
+/* power management apis */
+enum MHI_PM_STATE __must_check mhi_tryset_pm_state(struct mhi_controller
+						   *mhi_cntrl,
+						   enum MHI_PM_STATE state);
+const char *to_mhi_pm_state_str(enum MHI_PM_STATE state);
+void mhi_reset_chan(struct mhi_controller *mhi_cntrl,
+		    struct mhi_chan *mhi_chan);
+enum mhi_ee mhi_get_exec_env(struct mhi_controller *mhi_cntrl);
+int mhi_queue_state_transition(struct mhi_controller *mhi_cntrl,
+			       enum MHI_ST_TRANSITION state);
+void mhi_pm_st_worker(struct work_struct *work);
+void mhi_fw_load_worker(struct work_struct *work);
+void mhi_pm_sys_err_worker(struct work_struct *work);
+int mhi_ready_state_transition(struct mhi_controller *mhi_cntrl);
+void mhi_ctrl_ev_task(unsigned long data);
+int mhi_pm_m0_transition(struct mhi_controller *mhi_cntrl);
+void mhi_pm_m1_transition(struct mhi_controller *mhi_cntrl);
+int mhi_pm_m3_transition(struct mhi_controller *mhi_cntrl);
+void mhi_notify(struct mhi_device *mhi_dev, enum MHI_CB cb_reason);
+int mhi_process_data_event_ring(struct mhi_controller *mhi_cntrl,
+				struct mhi_event *mhi_event, u32 event_quota);
+int mhi_process_ctrl_ev_ring(struct mhi_controller *mhi_cntrl,
+			     struct mhi_event *mhi_event, u32 event_quota);
+int mhi_process_tsync_event_ring(struct mhi_controller *mhi_cntrl,
+				 struct mhi_event *mhi_event, u32 event_quota);
+int mhi_send_cmd(struct mhi_controller *mhi_cntrl, struct mhi_chan *mhi_chan,
+		 enum MHI_CMD cmd);
+int __mhi_device_get_sync(struct mhi_controller *mhi_cntrl);
+
+/* queue transfer buffer */
+int mhi_gen_tre(struct mhi_controller *mhi_cntrl, struct mhi_chan *mhi_chan,
+		void *buf, void *cb, size_t buf_len, enum MHI_FLAGS flags);
+int mhi_queue_buf(struct mhi_device *mhi_dev, struct mhi_chan *mhi_chan,
+		  void *buf, size_t len, enum MHI_FLAGS mflags);
+int mhi_queue_skb(struct mhi_device *mhi_dev, struct mhi_chan *mhi_chan,
+		  void *buf, size_t len, enum MHI_FLAGS mflags);
+int mhi_queue_sclist(struct mhi_device *mhi_dev, struct mhi_chan *mhi_chan,
+		     void *buf, size_t len, enum MHI_FLAGS mflags);
+int mhi_queue_nop(struct mhi_device *mhi_dev, struct mhi_chan *mhi_chan,
+		  void *buf, size_t len, enum MHI_FLAGS mflags);
+int mhi_queue_dma(struct mhi_device *mhi_dev, struct mhi_chan *mhi_chan,
+		  void *buf, size_t len, enum MHI_FLAGS mflags);
+
+/* register access methods */
+void mhi_db_brstmode(struct mhi_controller *mhi_cntrl, struct db_cfg *db_cfg,
+		     void __iomem *db_addr, dma_addr_t db_wp);
+void mhi_db_brstmode_disable(struct mhi_controller *mhi_cntrl,
+			     struct db_cfg *db_mode, void __iomem *db_addr,
+			     dma_addr_t db_wp);
+int __must_check mhi_read_reg(struct mhi_controller *mhi_cntrl,
+			      void __iomem *base, u32 offset, u32 *out);
+int __must_check mhi_read_reg_field(struct mhi_controller *mhi_cntrl,
+				    void __iomem *base, u32 offset, u32 mask,
+				    u32 shift, u32 *out);
+void mhi_write_reg(struct mhi_controller *mhi_cntrl, void __iomem *base,
+		   u32 offset, u32 val);
+void mhi_write_reg_field(struct mhi_controller *mhi_cntrl, void __iomem *base,
+			 u32 offset, u32 mask, u32 shift, u32 val);
+void mhi_ring_er_db(struct mhi_event *mhi_event);
+void mhi_write_db(struct mhi_controller *mhi_cntrl, void __iomem *db_addr,
+		  dma_addr_t db_wp);
+void mhi_ring_cmd_db(struct mhi_controller *mhi_cntrl, struct mhi_cmd *mhi_cmd);
+void mhi_ring_chan_db(struct mhi_controller *mhi_cntrl,
+		      struct mhi_chan *mhi_chan);
+int mhi_get_capability_offset(struct mhi_controller *mhi_cntrl, u32 capability,
+			      u32 *offset);
+int mhi_init_timesync(struct mhi_controller *mhi_cntrl);
+int mhi_create_timesync_sysfs(struct mhi_controller *mhi_cntrl);
+void mhi_destroy_timesync(struct mhi_controller *mhi_cntrl);
+
+static inline void *dma_zalloc_coherent(struct device *dev, size_t size,
+					dma_addr_t *dma_handle, gfp_t flag)
+{
+	void *ret = dma_alloc_coherent(dev, size, dma_handle,
+				       flag | __GFP_ZERO);
+	return ret;
+}
+
+/* memory allocation methods */
+static inline void *mhi_alloc_coherent(struct mhi_controller *mhi_cntrl,
+				       size_t size,
+				       dma_addr_t *dma_handle, gfp_t gfp)
+{
+	void *buf = dma_zalloc_coherent(mhi_cntrl->dev, size, dma_handle, gfp);
+
+	if (buf)
+		atomic_add(size, &mhi_cntrl->alloc_size);
+
+	return buf;
+}
+
+static inline void mhi_free_coherent(struct mhi_controller *mhi_cntrl,
+				     size_t size,
+				     void *vaddr, dma_addr_t dma_handle)
+{
+	atomic_sub(size, &mhi_cntrl->alloc_size);
+	dma_free_coherent(mhi_cntrl->dev, size, vaddr, dma_handle);
+}
+
+struct mhi_device *mhi_alloc_device(struct mhi_controller *mhi_cntrl);
+static inline void mhi_dealloc_device(struct mhi_controller *mhi_cntrl,
+				      struct mhi_device *mhi_dev)
+{
+	kfree(mhi_dev);
+}
+
+int mhi_destroy_device(struct device *dev, void *data);
+void mhi_create_devices(struct mhi_controller *mhi_cntrl);
+int mhi_alloc_bhie_table(struct mhi_controller *mhi_cntrl,
+			 struct image_info **image_info, size_t alloc_size);
+void mhi_free_bhie_table(struct mhi_controller *mhi_cntrl,
+			 struct image_info *image_info);
+
+int mhi_map_single_no_bb(struct mhi_controller *mhi_cntrl,
+			 struct mhi_buf_info *buf_info);
+int mhi_map_single_use_bb(struct mhi_controller *mhi_cntrl,
+			  struct mhi_buf_info *buf_info);
+void mhi_unmap_single_no_bb(struct mhi_controller *mhi_cntrl,
+			    struct mhi_buf_info *buf_info);
+void mhi_unmap_single_use_bb(struct mhi_controller *mhi_cntrl,
+			     struct mhi_buf_info *buf_info);
+
+/* initialization methods */
+int mhi_init_chan_ctxt(struct mhi_controller *mhi_cntrl,
+		       struct mhi_chan *mhi_chan);
+void mhi_deinit_chan_ctxt(struct mhi_controller *mhi_cntrl,
+			  struct mhi_chan *mhi_chan);
+int mhi_init_mmio(struct mhi_controller *mhi_cntrl);
+int mhi_init_dev_ctxt(struct mhi_controller *mhi_cntrl);
+void mhi_deinit_dev_ctxt(struct mhi_controller *mhi_cntrl);
+int mhi_init_irq_setup(struct mhi_controller *mhi_cntrl);
+void mhi_deinit_free_irq(struct mhi_controller *mhi_cntrl);
+int mhi_dtr_init(void);
+
+/* isr handlers */
+irqreturn_t mhi_msi_handlr(int irq_number, void *dev);
+irqreturn_t mhi_intvec_threaded_handlr(int irq_number, void *dev);
+irqreturn_t mhi_intvec_handlr(int irq_number, void *dev);
+void mhi_ev_task(unsigned long data);
+
+#ifdef CONFIG_MHI_DEBUG
+
+#define MHI_ASSERT(cond, msg) do { \
+	if (cond) \
+		panic(msg); \
+} while (0)
+
+#else
+
+#define MHI_ASSERT(cond, msg) do { \
+	if (cond) { \
+		MHI_ERR(msg); \
+		WARN_ON(cond); \
+	} \
+} while (0)
+
+#endif
+
+#endif /* _MHI_INT_H */
diff --git a/drivers/bus/mhi/core/mhi_main.c b/drivers/bus/mhi/core/mhi_main.c
new file mode 100644
index 000000000000..de362b9272c2
--- /dev/null
+++ b/drivers/bus/mhi/core/mhi_main.c
@@ -0,0 +1,2261 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2018-2019, The Linux Foundation. All rights reserved. */
+
+#include <linux/debugfs.h>
+#include <linux/device.h>
+#include <linux/dma-direction.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/of.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <linux/mhi.h>
+#include "mhi_internal.h"
+
+static void __mhi_unprepare_channel(struct mhi_controller *mhi_cntrl,
+				    struct mhi_chan *mhi_chan);
+
+int __must_check mhi_read_reg(struct mhi_controller *mhi_cntrl,
+			      void __iomem *base, u32 offset, u32 *out)
+{
+	u32 tmp = readl_relaxed(base + offset);
+
+	/* unexpected value, query the link status */
+	if (PCI_INVALID_READ(tmp) &&
+	    mhi_cntrl->link_status(mhi_cntrl, mhi_cntrl->priv_data))
+		return -EIO;
+
+	*out = tmp;
+
+	return 0;
+}
+
+int __must_check mhi_read_reg_field(struct mhi_controller *mhi_cntrl,
+				    void __iomem *base,
+				    u32 offset, u32 mask, u32 shift, u32 *out)
+{
+	u32 tmp;
+	int ret;
+
+	ret = mhi_read_reg(mhi_cntrl, base, offset, &tmp);
+	if (ret)
+		return ret;
+
+	*out = (tmp & mask) >> shift;
+
+	return 0;
+}
+
+int mhi_get_capability_offset(struct mhi_controller *mhi_cntrl,
+			      u32 capability, u32 *offset)
+{
+	u32 cur_cap, next_offset;
+	int ret;
+
+	/* get the 1st supported capability offset */
+	ret = mhi_read_reg_field(mhi_cntrl, mhi_cntrl->regs, MISC_OFFSET,
+				 MISC_CAP_MASK, MISC_CAP_SHIFT, offset);
+	if (ret)
+		return ret;
+	do {
+		ret = mhi_read_reg_field(mhi_cntrl, mhi_cntrl->regs, *offset,
+					 CAP_CAPID_MASK, CAP_CAPID_SHIFT,
+					 &cur_cap);
+		if (ret)
+			return ret;
+
+		if (cur_cap == capability)
+			return 0;
+
+		ret = mhi_read_reg_field(mhi_cntrl, mhi_cntrl->regs, *offset,
+					 CAP_NEXT_CAP_MASK, CAP_NEXT_CAP_SHIFT,
+					 &next_offset);
+		if (ret)
+			return ret;
+
+		*offset += next_offset;
+	} while (next_offset);
+
+	return -ENXIO;
+}
+
+void mhi_write_reg(struct mhi_controller *mhi_cntrl,
+		   void __iomem *base, u32 offset, u32 val)
+{
+	writel_relaxed(val, base + offset);
+}
+
+void mhi_write_reg_field(struct mhi_controller *mhi_cntrl,
+			 void __iomem *base,
+			 u32 offset, u32 mask, u32 shift, u32 val)
+{
+	int ret;
+	u32 tmp;
+
+	ret = mhi_read_reg(mhi_cntrl, base, offset, &tmp);
+	if (ret)
+		return;
+
+	tmp &= ~mask;
+	tmp |= (val << shift);
+	mhi_write_reg(mhi_cntrl, base, offset, tmp);
+}
+
+void mhi_write_db(struct mhi_controller *mhi_cntrl,
+		  void __iomem *db_addr, dma_addr_t wp)
+{
+	mhi_write_reg(mhi_cntrl, db_addr, 4, upper_32_bits(wp));
+	mhi_write_reg(mhi_cntrl, db_addr, 0, lower_32_bits(wp));
+}
+
+void mhi_db_brstmode(struct mhi_controller *mhi_cntrl,
+		     struct db_cfg *db_cfg,
+		     void __iomem *db_addr, dma_addr_t wp)
+{
+	if (db_cfg->db_mode) {
+		db_cfg->db_val = wp;
+		mhi_write_db(mhi_cntrl, db_addr, wp);
+		db_cfg->db_mode = false;
+	}
+}
+
+void mhi_db_brstmode_disable(struct mhi_controller *mhi_cntrl,
+			     struct db_cfg *db_cfg,
+			     void __iomem *db_addr, dma_addr_t wp)
+{
+	db_cfg->db_val = wp;
+	mhi_write_db(mhi_cntrl, db_addr, wp);
+}
+
+void mhi_ring_er_db(struct mhi_event *mhi_event)
+{
+	struct mhi_ring *ring = &mhi_event->ring;
+
+	mhi_event->db_cfg.process_db(mhi_event->mhi_cntrl, &mhi_event->db_cfg,
+				     ring->db_addr, *ring->ctxt_wp);
+}
+
+void mhi_ring_cmd_db(struct mhi_controller *mhi_cntrl, struct mhi_cmd *mhi_cmd)
+{
+	dma_addr_t db;
+	struct mhi_ring *ring = &mhi_cmd->ring;
+
+	db = ring->iommu_base + (ring->wptr - ring->base);
+	*ring->ctxt_wp = db;
+	mhi_write_db(mhi_cntrl, ring->db_addr, db);
+}
+
+void mhi_ring_chan_db(struct mhi_controller *mhi_cntrl,
+		      struct mhi_chan *mhi_chan)
+{
+	struct mhi_ring *ring = &mhi_chan->tre_ring;
+	dma_addr_t db;
+
+	db = ring->iommu_base + (ring->wptr - ring->base);
+	*ring->ctxt_wp = db;
+	mhi_chan->db_cfg.process_db(mhi_cntrl, &mhi_chan->db_cfg, ring->db_addr,
+				    db);
+}
+
+enum mhi_ee mhi_get_exec_env(struct mhi_controller *mhi_cntrl)
+{
+	u32 exec;
+	int ret = mhi_read_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_EXECENV, &exec);
+
+	return (ret) ? MHI_EE_MAX : exec;
+}
+
+enum mhi_dev_state mhi_get_mhi_state(struct mhi_controller *mhi_cntrl)
+{
+	u32 state;
+	int ret = mhi_read_reg_field(mhi_cntrl, mhi_cntrl->regs, MHISTATUS,
+				     MHISTATUS_MHISTATE_MASK,
+				     MHISTATUS_MHISTATE_SHIFT, &state);
+	return ret ? MHI_STATE_MAX : state;
+}
+EXPORT_SYMBOL(mhi_get_mhi_state);
+
+int mhi_queue_sclist(struct mhi_device *mhi_dev,
+		     struct mhi_chan *mhi_chan,
+		     void *buf, size_t len, enum MHI_FLAGS mflags)
+{
+	return -EINVAL;
+}
+
+int mhi_queue_nop(struct mhi_device *mhi_dev,
+		  struct mhi_chan *mhi_chan,
+		  void *buf, size_t len, enum MHI_FLAGS mflags)
+{
+	return -EINVAL;
+}
+
+static void mhi_add_ring_element(struct mhi_controller *mhi_cntrl,
+				 struct mhi_ring *ring)
+{
+	ring->wptr += ring->el_size;
+	if (ring->wptr >= (ring->base + ring->len))
+		ring->wptr = ring->base;
+	/* smp update */
+	smp_wmb();
+}
+
+static void mhi_del_ring_element(struct mhi_controller *mhi_cntrl,
+				 struct mhi_ring *ring)
+{
+	ring->rptr += ring->el_size;
+	if (ring->rptr >= (ring->base + ring->len))
+		ring->rptr = ring->base;
+	/* smp update */
+	smp_wmb();
+}
+
+static int get_nr_avail_ring_elements(struct mhi_controller *mhi_cntrl,
+				      struct mhi_ring *ring)
+{
+	int nr_el;
+
+	if (ring->wptr < ring->rptr)
+		nr_el = ((ring->rptr - ring->wptr) / ring->el_size) - 1;
+	else {
+		nr_el = (ring->rptr - ring->base) / ring->el_size;
+		nr_el += ((ring->base + ring->len - ring->wptr) /
+			  ring->el_size) - 1;
+	}
+	return nr_el;
+}
+
+static void *mhi_to_virtual(struct mhi_ring *ring, dma_addr_t addr)
+{
+	return (addr - ring->iommu_base) + ring->base;
+}
+
+dma_addr_t mhi_to_physical(struct mhi_ring *ring, void *addr)
+{
+	return (addr - ring->base) + ring->iommu_base;
+}
+
+static void mhi_recycle_ev_ring_element(struct mhi_controller *mhi_cntrl,
+					struct mhi_ring *ring)
+{
+	dma_addr_t ctxt_wp;
+
+	/* update the WP */
+	ring->wptr += ring->el_size;
+	ctxt_wp = *ring->ctxt_wp + ring->el_size;
+
+	if (ring->wptr >= (ring->base + ring->len)) {
+		ring->wptr = ring->base;
+		ctxt_wp = ring->iommu_base;
+	}
+
+	*ring->ctxt_wp = ctxt_wp;
+
+	/* update the RP */
+	ring->rptr += ring->el_size;
+	if (ring->rptr >= (ring->base + ring->len))
+		ring->rptr = ring->base;
+
+	/* visible to other cores */
+	smp_wmb();
+}
+
+static bool mhi_is_ring_full(struct mhi_controller *mhi_cntrl,
+			     struct mhi_ring *ring)
+{
+	void *tmp = ring->wptr + ring->el_size;
+
+	if (tmp >= (ring->base + ring->len))
+		tmp = ring->base;
+
+	return (tmp == ring->rptr);
+}
+
+int mhi_map_single_no_bb(struct mhi_controller *mhi_cntrl,
+			 struct mhi_buf_info *buf_info)
+{
+	buf_info->p_addr = dma_map_single(mhi_cntrl->dev, buf_info->v_addr,
+					  buf_info->len, buf_info->dir);
+	if (dma_mapping_error(mhi_cntrl->dev, buf_info->p_addr))
+		return -ENOMEM;
+
+	return 0;
+}
+
+int mhi_map_single_use_bb(struct mhi_controller *mhi_cntrl,
+			  struct mhi_buf_info *buf_info)
+{
+	void *buf = mhi_alloc_coherent(mhi_cntrl, buf_info->len,
+				       &buf_info->p_addr, GFP_ATOMIC);
+
+	if (!buf)
+		return -ENOMEM;
+
+	if (buf_info->dir == DMA_TO_DEVICE)
+		memcpy(buf, buf_info->v_addr, buf_info->len);
+
+	buf_info->bb_addr = buf;
+
+	return 0;
+}
+
+void mhi_unmap_single_no_bb(struct mhi_controller *mhi_cntrl,
+			    struct mhi_buf_info *buf_info)
+{
+	dma_unmap_single(mhi_cntrl->dev, buf_info->p_addr, buf_info->len,
+			 buf_info->dir);
+}
+
+void mhi_unmap_single_use_bb(struct mhi_controller *mhi_cntrl,
+			     struct mhi_buf_info *buf_info)
+{
+	if (buf_info->dir == DMA_FROM_DEVICE)
+		memcpy(buf_info->v_addr, buf_info->bb_addr, buf_info->len);
+
+	mhi_free_coherent(mhi_cntrl, buf_info->len, buf_info->bb_addr,
+			  buf_info->p_addr);
+}
+
+int mhi_queue_skb(struct mhi_device *mhi_dev,
+		  struct mhi_chan *mhi_chan,
+		  void *buf, size_t len, enum MHI_FLAGS mflags)
+{
+	struct sk_buff *skb = buf;
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_ring *tre_ring = &mhi_chan->tre_ring;
+	struct mhi_ring *buf_ring = &mhi_chan->buf_ring;
+	struct mhi_buf_info *buf_info;
+	struct mhi_tre *mhi_tre;
+	bool assert_wake = false;
+	int ret;
+
+	if (mhi_is_ring_full(mhi_cntrl, tre_ring))
+		return -ENOMEM;
+
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	if (unlikely(MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state))) {
+		MHI_VERB("MHI is not in activate state, pm_state:%s\n",
+			 to_mhi_pm_state_str(mhi_cntrl->pm_state));
+		read_unlock_bh(&mhi_cntrl->pm_lock);
+
+		return -EIO;
+	}
+
+	/* we're in M3 or transitioning to M3 */
+	if (MHI_PM_IN_SUSPEND_STATE(mhi_cntrl->pm_state)) {
+		mhi_cntrl->runtime_get(mhi_cntrl, mhi_cntrl->priv_data);
+		mhi_cntrl->runtime_put(mhi_cntrl, mhi_cntrl->priv_data);
+	}
+
+	/*
+	 * For UL channels always assert WAKE until work is done,
+	 * For DL channels only assert if MHI is in a LPM
+	 */
+	if (mhi_chan->dir == DMA_TO_DEVICE ||
+	    (mhi_chan->dir == DMA_FROM_DEVICE &&
+	     mhi_cntrl->pm_state != MHI_PM_M0)) {
+		assert_wake = true;
+		mhi_cntrl->wake_get(mhi_cntrl, false);
+	}
+
+	/* generate the tre */
+	buf_info = buf_ring->wptr;
+	buf_info->v_addr = skb->data;
+	buf_info->cb_buf = skb;
+	buf_info->wp = tre_ring->wptr;
+	buf_info->dir = mhi_chan->dir;
+	buf_info->len = len;
+	ret = mhi_cntrl->map_single(mhi_cntrl, buf_info);
+	if (ret)
+		goto map_error;
+
+	mhi_tre = tre_ring->wptr;
+
+	mhi_tre->ptr = MHI_TRE_DATA_PTR(buf_info->p_addr);
+	mhi_tre->dword[0] = MHI_TRE_DATA_DWORD0(buf_info->len);
+	mhi_tre->dword[1] = MHI_TRE_DATA_DWORD1(1, 1, 0, 0);
+
+	MHI_VERB("chan:%d WP:0x%llx TRE:0x%llx 0x%08x 0x%08x\n", mhi_chan->chan,
+		 (u64)mhi_to_physical(tre_ring, mhi_tre), mhi_tre->ptr,
+		 mhi_tre->dword[0], mhi_tre->dword[1]);
+
+	/* increment WP */
+	mhi_add_ring_element(mhi_cntrl, tre_ring);
+	mhi_add_ring_element(mhi_cntrl, buf_ring);
+
+	if (likely(MHI_DB_ACCESS_VALID(mhi_cntrl->pm_state))) {
+		read_lock_bh(&mhi_chan->lock);
+		mhi_ring_chan_db(mhi_cntrl, mhi_chan);
+		read_unlock_bh(&mhi_chan->lock);
+	}
+
+	if (mhi_chan->dir == DMA_FROM_DEVICE && assert_wake)
+		mhi_cntrl->wake_put(mhi_cntrl, true);
+
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	return 0;
+
+map_error:
+	if (assert_wake)
+		mhi_cntrl->wake_put(mhi_cntrl, false);
+
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	return ret;
+}
+
+int mhi_queue_dma(struct mhi_device *mhi_dev,
+		  struct mhi_chan *mhi_chan,
+		  void *buf, size_t len, enum MHI_FLAGS mflags)
+{
+	struct mhi_buf *mhi_buf = buf;
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_ring *tre_ring = &mhi_chan->tre_ring;
+	struct mhi_ring *buf_ring = &mhi_chan->buf_ring;
+	struct mhi_buf_info *buf_info;
+	struct mhi_tre *mhi_tre;
+	bool assert_wake = false;
+
+	if (mhi_is_ring_full(mhi_cntrl, tre_ring))
+		return -ENOMEM;
+
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	if (unlikely(MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state))) {
+		MHI_VERB("MHI is not in activate state, pm_state:%s\n",
+			 to_mhi_pm_state_str(mhi_cntrl->pm_state));
+		read_unlock_bh(&mhi_cntrl->pm_lock);
+
+		return -EIO;
+	}
+
+	/* we're in M3 or transitioning to M3 */
+	if (MHI_PM_IN_SUSPEND_STATE(mhi_cntrl->pm_state)) {
+		mhi_cntrl->runtime_get(mhi_cntrl, mhi_cntrl->priv_data);
+		mhi_cntrl->runtime_put(mhi_cntrl, mhi_cntrl->priv_data);
+	}
+
+	/*
+	 * For UL channels always assert WAKE until work is done,
+	 * For DL channels only assert if MHI is in a LPM
+	 */
+	if (mhi_chan->dir == DMA_TO_DEVICE ||
+	    (mhi_chan->dir == DMA_FROM_DEVICE &&
+	     mhi_cntrl->pm_state != MHI_PM_M0)) {
+		assert_wake = true;
+		mhi_cntrl->wake_get(mhi_cntrl, false);
+	}
+
+	/* generate the tre */
+	buf_info = buf_ring->wptr;
+	MHI_ASSERT(buf_info->used, "TRE Not Freed\n");
+	buf_info->p_addr = mhi_buf->dma_addr;
+	buf_info->pre_mapped = true;
+	buf_info->cb_buf = mhi_buf;
+	buf_info->wp = tre_ring->wptr;
+	buf_info->dir = mhi_chan->dir;
+	buf_info->len = len;
+
+	mhi_tre = tre_ring->wptr;
+
+	if (mhi_chan->xfer_type == MHI_XFER_RSC_DMA) {
+		buf_info->used = true;
+		mhi_tre->ptr =
+		    MHI_RSCTRE_DATA_PTR(buf_info->p_addr, buf_info->len);
+		mhi_tre->dword[0] =
+		    MHI_RSCTRE_DATA_DWORD0(buf_ring->wptr - buf_ring->base);
+		mhi_tre->dword[1] = MHI_RSCTRE_DATA_DWORD1;
+	} else {
+		mhi_tre->ptr = MHI_TRE_DATA_PTR(buf_info->p_addr);
+		mhi_tre->dword[0] = MHI_TRE_DATA_DWORD0(buf_info->len);
+		mhi_tre->dword[1] = MHI_TRE_DATA_DWORD1(1, 1, 0, 0);
+	}
+
+	MHI_VERB("chan:%d WP:0x%llx TRE:0x%llx 0x%08x 0x%08x\n", mhi_chan->chan,
+		 (u64)mhi_to_physical(tre_ring, mhi_tre), mhi_tre->ptr,
+		 mhi_tre->dword[0], mhi_tre->dword[1]);
+
+	/* increment WP */
+	mhi_add_ring_element(mhi_cntrl, tre_ring);
+	mhi_add_ring_element(mhi_cntrl, buf_ring);
+
+	if (likely(MHI_DB_ACCESS_VALID(mhi_cntrl->pm_state))) {
+		read_lock_bh(&mhi_chan->lock);
+		mhi_ring_chan_db(mhi_cntrl, mhi_chan);
+		read_unlock_bh(&mhi_chan->lock);
+	}
+
+	if (mhi_chan->dir == DMA_FROM_DEVICE && assert_wake)
+		mhi_cntrl->wake_put(mhi_cntrl, true);
+
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	return 0;
+}
+
+int mhi_gen_tre(struct mhi_controller *mhi_cntrl,
+		struct mhi_chan *mhi_chan,
+		void *buf, void *cb, size_t buf_len, enum MHI_FLAGS flags)
+{
+	struct mhi_ring *buf_ring, *tre_ring;
+	struct mhi_tre *mhi_tre;
+	struct mhi_buf_info *buf_info;
+	int eot, eob, chain, bei;
+	int ret;
+
+	buf_ring = &mhi_chan->buf_ring;
+	tre_ring = &mhi_chan->tre_ring;
+
+	buf_info = buf_ring->wptr;
+	buf_info->v_addr = buf;
+	buf_info->cb_buf = cb;
+	buf_info->wp = tre_ring->wptr;
+	buf_info->dir = mhi_chan->dir;
+	buf_info->len = buf_len;
+
+	ret = mhi_cntrl->map_single(mhi_cntrl, buf_info);
+	if (ret)
+		return ret;
+
+	eob = !!(flags & MHI_EOB);
+	eot = !!(flags & MHI_EOT);
+	chain = !!(flags & MHI_CHAIN);
+	bei = !!(mhi_chan->intmod);
+
+	mhi_tre = tre_ring->wptr;
+	mhi_tre->ptr = MHI_TRE_DATA_PTR(buf_info->p_addr);
+	mhi_tre->dword[0] = MHI_TRE_DATA_DWORD0(buf_len);
+	mhi_tre->dword[1] = MHI_TRE_DATA_DWORD1(bei, eot, eob, chain);
+
+	MHI_VERB("chan:%d WP:0x%llx TRE:0x%llx 0x%08x 0x%08x\n", mhi_chan->chan,
+		 (u64)mhi_to_physical(tre_ring, mhi_tre), mhi_tre->ptr,
+		 mhi_tre->dword[0], mhi_tre->dword[1]);
+
+	/* increment WP */
+	mhi_add_ring_element(mhi_cntrl, tre_ring);
+	mhi_add_ring_element(mhi_cntrl, buf_ring);
+
+	return 0;
+}
+
+int mhi_queue_buf(struct mhi_device *mhi_dev,
+		  struct mhi_chan *mhi_chan,
+		  void *buf, size_t len, enum MHI_FLAGS mflags)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_ring *tre_ring;
+	unsigned long flags;
+	bool assert_wake = false;
+	int ret;
+
+	/*
+	 * this check here only as a guard, it's always
+	 * possible mhi can enter error while executing rest of function,
+	 * which is not fatal so we do not need to hold pm_lock
+	 */
+	if (unlikely(MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state))) {
+		MHI_VERB("MHI is not in active state, pm_state:%s\n",
+			 to_mhi_pm_state_str(mhi_cntrl->pm_state));
+
+		return -EIO;
+	}
+
+	tre_ring = &mhi_chan->tre_ring;
+	if (mhi_is_ring_full(mhi_cntrl, tre_ring))
+		return -ENOMEM;
+
+	ret = mhi_chan->gen_tre(mhi_cntrl, mhi_chan, buf, buf, len, mflags);
+	if (unlikely(ret))
+		return ret;
+
+	read_lock_irqsave(&mhi_cntrl->pm_lock, flags);
+
+	/* we're in M3 or transitioning to M3 */
+	if (MHI_PM_IN_SUSPEND_STATE(mhi_cntrl->pm_state)) {
+		mhi_cntrl->runtime_get(mhi_cntrl, mhi_cntrl->priv_data);
+		mhi_cntrl->runtime_put(mhi_cntrl, mhi_cntrl->priv_data);
+	}
+
+	/*
+	 * For UL channels always assert WAKE until work is done,
+	 * For DL channels only assert if MHI is in a LPM
+	 */
+	if (mhi_chan->dir == DMA_TO_DEVICE ||
+	    (mhi_chan->dir == DMA_FROM_DEVICE &&
+	     mhi_cntrl->pm_state != MHI_PM_M0)) {
+		assert_wake = true;
+		mhi_cntrl->wake_get(mhi_cntrl, false);
+	}
+
+	if (likely(MHI_DB_ACCESS_VALID(mhi_cntrl->pm_state))) {
+		unsigned long flags;
+
+		read_lock_irqsave(&mhi_chan->lock, flags);
+		mhi_ring_chan_db(mhi_cntrl, mhi_chan);
+		read_unlock_irqrestore(&mhi_chan->lock, flags);
+	}
+
+	if (mhi_chan->dir == DMA_FROM_DEVICE && assert_wake)
+		mhi_cntrl->wake_put(mhi_cntrl, true);
+
+	read_unlock_irqrestore(&mhi_cntrl->pm_lock, flags);
+
+	return 0;
+}
+
+/* destroy specific device */
+int mhi_destroy_device(struct device *dev, void *data)
+{
+	struct mhi_device *mhi_dev;
+	struct mhi_controller *mhi_cntrl;
+
+	if (dev->bus != &mhi_bus_type)
+		return 0;
+
+	mhi_dev = to_mhi_device(dev);
+	mhi_cntrl = mhi_dev->mhi_cntrl;
+
+	/* only destroying virtual devices thats attached to bus */
+	if (mhi_dev->dev_type == MHI_CONTROLLER_TYPE)
+		return 0;
+
+	MHI_LOG("destroy device for chan:%s\n", mhi_dev->chan_name);
+
+	/* notify the client and remove the device from mhi bus */
+	device_del(dev);
+	put_device(dev);
+
+	return 0;
+}
+
+void mhi_notify(struct mhi_device *mhi_dev, enum MHI_CB cb_reason)
+{
+	struct mhi_driver *mhi_drv;
+
+	if (!mhi_dev->dev.driver)
+		return;
+
+	mhi_drv = to_mhi_driver(mhi_dev->dev.driver);
+
+	if (mhi_drv->status_cb)
+		mhi_drv->status_cb(mhi_dev, cb_reason);
+}
+
+static void mhi_assign_of_node(struct mhi_controller *mhi_cntrl,
+			       struct mhi_device *mhi_dev)
+{
+	struct device_node *controller, *node;
+	const char *dt_name;
+	int ret;
+
+	controller = of_find_node_by_name(mhi_cntrl->of_node, "mhi_devices");
+	if (!controller)
+		return;
+
+	for_each_available_child_of_node(controller, node) {
+		ret = of_property_read_string(node, "mhi,chan", &dt_name);
+		if (ret)
+			continue;
+		if (!strcmp(mhi_dev->chan_name, dt_name)) {
+			mhi_dev->dev.of_node = node;
+			break;
+		}
+	}
+}
+
+static ssize_t time_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	struct mhi_device *mhi_dev = to_mhi_device(dev);
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	u64 t_host, t_device;
+	int ret;
+
+	ret = mhi_get_remote_time_sync(mhi_dev, &t_host, &t_device);
+	if (ret) {
+		MHI_ERR("Failed to obtain time, ret:%d\n", ret);
+		return ret;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "local: %llu remote: %llu (ticks)\n",
+			 t_host, t_device);
+}
+
+static DEVICE_ATTR_RO(time);
+
+static ssize_t time_us_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct mhi_device *mhi_dev = to_mhi_device(dev);
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	u64 t_host, t_device;
+	int ret;
+
+	ret = mhi_get_remote_time_sync(mhi_dev, &t_host, &t_device);
+	if (ret) {
+		MHI_ERR("Failed to obtain time, ret:%d\n", ret);
+		return ret;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "local: %llu remote: %llu (us)\n",
+			 TIME_TICKS_TO_US(t_host), TIME_TICKS_TO_US(t_device));
+}
+
+static DEVICE_ATTR_RO(time_us);
+
+static struct attribute *mhi_tsync_attrs[] = {
+	&dev_attr_time.attr,
+	&dev_attr_time_us.attr,
+	NULL,
+};
+
+static const struct attribute_group mhi_tsync_group = {
+	.attrs = mhi_tsync_attrs,
+};
+
+void mhi_destroy_timesync(struct mhi_controller *mhi_cntrl)
+{
+	if (mhi_cntrl->mhi_tsync) {
+		sysfs_remove_group(&mhi_cntrl->mhi_dev->dev.kobj,
+				   &mhi_tsync_group);
+		kfree(mhi_cntrl->mhi_tsync);
+		mhi_cntrl->mhi_tsync = NULL;
+	}
+}
+
+int mhi_create_timesync_sysfs(struct mhi_controller *mhi_cntrl)
+{
+	return sysfs_create_group(&mhi_cntrl->mhi_dev->dev.kobj,
+				  &mhi_tsync_group);
+}
+
+static void mhi_create_time_sync_dev(struct mhi_controller *mhi_cntrl)
+{
+	struct mhi_device *mhi_dev;
+	int ret;
+
+	if (!MHI_IN_MISSION_MODE(mhi_cntrl->ee))
+		return;
+
+	mhi_dev = mhi_alloc_device(mhi_cntrl);
+	if (!mhi_dev)
+		return;
+
+	mhi_dev->dev_type = MHI_TIMESYNC_TYPE;
+	mhi_dev->chan_name = "TIME_SYNC";
+	dev_set_name(&mhi_dev->dev, "%04x_%02u.%02u.%02u_%s", mhi_dev->dev_id,
+		     mhi_dev->domain, mhi_dev->bus, mhi_dev->slot,
+		     mhi_dev->chan_name);
+
+	/* add if there is a matching DT node */
+	mhi_assign_of_node(mhi_cntrl, mhi_dev);
+
+	ret = device_add(&mhi_dev->dev);
+	if (ret) {
+		MHI_ERR("Failed to register dev for  chan:%s\n",
+			mhi_dev->chan_name);
+		mhi_dealloc_device(mhi_cntrl, mhi_dev);
+		return;
+	}
+
+	mhi_cntrl->tsync_dev = mhi_dev;
+}
+
+/* bind mhi channels into mhi devices */
+void mhi_create_devices(struct mhi_controller *mhi_cntrl)
+{
+	int i;
+	struct mhi_chan *mhi_chan;
+	struct mhi_device *mhi_dev;
+	int ret;
+
+	/*
+	 * we need to create time sync device before creating other
+	 * devices, because client may try to capture time during
+	 * clint probe.
+	 */
+	mhi_create_time_sync_dev(mhi_cntrl);
+
+	mhi_chan = mhi_cntrl->mhi_chan;
+	for (i = 0; i < mhi_cntrl->max_chan; i++, mhi_chan++) {
+		if (!mhi_chan->configured || mhi_chan->mhi_dev ||
+		    !(mhi_chan->ee_mask & BIT(mhi_cntrl->ee)))
+			continue;
+		mhi_dev = mhi_alloc_device(mhi_cntrl);
+		if (!mhi_dev)
+			return;
+
+		mhi_dev->dev_type = MHI_XFER_TYPE;
+		switch (mhi_chan->dir) {
+		case DMA_TO_DEVICE:
+			mhi_dev->ul_chan = mhi_chan;
+			mhi_dev->ul_chan_id = mhi_chan->chan;
+			mhi_dev->ul_xfer = mhi_chan->queue_xfer;
+			mhi_dev->ul_event_id = mhi_chan->er_index;
+			break;
+		case DMA_NONE:
+		case DMA_BIDIRECTIONAL:
+			mhi_dev->ul_chan_id = mhi_chan->chan;
+			mhi_dev->ul_event_id = mhi_chan->er_index;
+			fallthrough;
+		case DMA_FROM_DEVICE:
+			/* we use dl_chan for offload channels */
+			mhi_dev->dl_chan = mhi_chan;
+			mhi_dev->dl_chan_id = mhi_chan->chan;
+			mhi_dev->dl_xfer = mhi_chan->queue_xfer;
+			mhi_dev->dl_event_id = mhi_chan->er_index;
+		}
+
+		mhi_chan->mhi_dev = mhi_dev;
+
+		/* check next channel if it matches */
+		if ((i + 1) < mhi_cntrl->max_chan && mhi_chan[1].configured) {
+			if (!strcmp(mhi_chan[1].name, mhi_chan->name)) {
+				i++;
+				mhi_chan++;
+				if (mhi_chan->dir == DMA_TO_DEVICE) {
+					mhi_dev->ul_chan = mhi_chan;
+					mhi_dev->ul_chan_id = mhi_chan->chan;
+					mhi_dev->ul_xfer = mhi_chan->queue_xfer;
+					mhi_dev->ul_event_id =
+					    mhi_chan->er_index;
+				} else {
+					mhi_dev->dl_chan = mhi_chan;
+					mhi_dev->dl_chan_id = mhi_chan->chan;
+					mhi_dev->dl_xfer = mhi_chan->queue_xfer;
+					mhi_dev->dl_event_id =
+					    mhi_chan->er_index;
+				}
+				mhi_chan->mhi_dev = mhi_dev;
+			}
+		}
+
+		mhi_dev->chan_name = mhi_chan->name;
+		dev_set_name(&mhi_dev->dev, "%04x_%02u.%02u.%02u_%s",
+			     mhi_dev->dev_id, mhi_dev->domain, mhi_dev->bus,
+			     mhi_dev->slot, mhi_dev->chan_name);
+
+		/* add if there is a matching DT node */
+		mhi_assign_of_node(mhi_cntrl, mhi_dev);
+
+		/* init wake source */
+		if (mhi_dev->dl_chan && mhi_dev->dl_chan->wake_capable)
+			device_init_wakeup(&mhi_dev->dev, true);
+
+		ret = device_add(&mhi_dev->dev);
+		if (ret) {
+			MHI_ERR("Failed to register dev for  chan:%s\n",
+				mhi_dev->chan_name);
+			mhi_dealloc_device(mhi_cntrl, mhi_dev);
+		}
+	}
+}
+
+static int parse_xfer_event(struct mhi_controller *mhi_cntrl,
+			    struct mhi_tre *event, struct mhi_chan *mhi_chan)
+{
+	struct mhi_ring *buf_ring, *tre_ring;
+	u32 ev_code;
+	struct mhi_result result;
+	unsigned long flags = 0;
+
+	ev_code = MHI_TRE_GET_EV_CODE(event);
+	buf_ring = &mhi_chan->buf_ring;
+	tre_ring = &mhi_chan->tre_ring;
+
+	result.transaction_status = (ev_code == MHI_EV_CC_OVERFLOW) ?
+	    -EOVERFLOW : 0;
+
+	/*
+	 * if it's a DB Event then we need to grab the lock
+	 * with preemption disable and as a write because we
+	 * have to update db register and another thread could
+	 * be doing same.
+	 */
+	if (ev_code >= MHI_EV_CC_OOB)
+		write_lock_irqsave(&mhi_chan->lock, flags);
+	else
+		read_lock_bh(&mhi_chan->lock);
+
+	if (mhi_chan->ch_state != MHI_CH_STATE_ENABLED)
+		goto end_process_tx_event;
+
+	switch (ev_code) {
+	case MHI_EV_CC_OVERFLOW:
+	case MHI_EV_CC_EOB:
+	case MHI_EV_CC_EOT:
+	{
+		dma_addr_t ptr = MHI_TRE_GET_EV_PTR(event);
+		struct mhi_tre *local_rp, *ev_tre;
+		void *dev_rp;
+		struct mhi_buf_info *buf_info;
+		u16 xfer_len;
+
+		/* Get the TRB this event points to */
+		ev_tre = mhi_to_virtual(tre_ring, ptr);
+
+		/* device rp after servicing the TREs */
+		dev_rp = ev_tre + 1;
+		if (dev_rp >= (tre_ring->base + tre_ring->len))
+			dev_rp = tre_ring->base;
+
+		result.dir = mhi_chan->dir;
+
+		/* local rp */
+		local_rp = tre_ring->rptr;
+		while (local_rp != dev_rp) {
+			buf_info = buf_ring->rptr;
+			/* Always get the get len from the event */
+			xfer_len = MHI_TRE_GET_EV_LEN(event);
+
+			/* unmap if it's not premapped by client */
+			if (likely(!buf_info->pre_mapped))
+				mhi_cntrl->unmap_single(mhi_cntrl, buf_info);
+
+			result.buf_addr = buf_info->cb_buf;
+			result.bytes_xferd = xfer_len;
+			mhi_del_ring_element(mhi_cntrl, buf_ring);
+			mhi_del_ring_element(mhi_cntrl, tre_ring);
+			local_rp = tre_ring->rptr;
+
+			/* notify client */
+			mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
+
+			if (mhi_chan->dir == DMA_TO_DEVICE) {
+				read_lock_bh(&mhi_cntrl->pm_lock);
+				mhi_cntrl->wake_put(mhi_cntrl, false);
+				read_unlock_bh(&mhi_cntrl->pm_lock);
+			}
+
+			/*
+			 * recycle the buffer if buffer is pre-allocated,
+			 * if there is error, not much we can do apart from
+			 * dropping the packet
+			 */
+			if (mhi_chan->pre_alloc) {
+				if (mhi_queue_buf(mhi_chan->mhi_dev, mhi_chan,
+						buf_info->cb_buf,
+						buf_info->len, MHI_EOT)) {
+					MHI_ERR
+					    ("Error recycling buf, chan: %d\n",
+					     mhi_chan->chan);
+					kfree(buf_info->cb_buf);
+				}
+			}
+		}
+		break;
+	}		/* CC_EOT */
+	case MHI_EV_CC_OOB:
+	case MHI_EV_CC_DB_MODE:
+	{
+		unsigned long flags;
+
+		MHI_VERB("DB_MODE/OOB Detected chan %d.\n", mhi_chan->chan);
+		mhi_chan->db_cfg.db_mode = true;
+		read_lock_irqsave(&mhi_cntrl->pm_lock, flags);
+		if (tre_ring->wptr != tre_ring->rptr &&
+			MHI_DB_ACCESS_VALID(mhi_cntrl->pm_state)) {
+			mhi_ring_chan_db(mhi_cntrl, mhi_chan);
+		}
+		read_unlock_irqrestore(&mhi_cntrl->pm_lock, flags);
+		break;
+	}
+	case MHI_EV_CC_BAD_TRE:
+		MHI_ASSERT(1, "Received BAD TRE event for ring");
+		break;
+	default:
+		MHI_CRITICAL("Unknown TX completion.\n");
+
+		break;
+	} /* switch(MHI_EV_READ_CODE(event)) */
+
+end_process_tx_event:
+	if (ev_code >= MHI_EV_CC_OOB)
+		write_unlock_irqrestore(&mhi_chan->lock, flags);
+	else
+		read_unlock_bh(&mhi_chan->lock);
+
+	return 0;
+}
+
+static int parse_rsc_event(struct mhi_controller *mhi_cntrl,
+			   struct mhi_tre *event, struct mhi_chan *mhi_chan)
+{
+	struct mhi_ring *buf_ring, *tre_ring;
+	struct mhi_buf_info *buf_info;
+	struct mhi_result result;
+	int ev_code;
+	u32 cookie;		/* offset to local descriptor */
+	u16 xfer_len;
+
+	buf_ring = &mhi_chan->buf_ring;
+	tre_ring = &mhi_chan->tre_ring;
+
+	ev_code = MHI_TRE_GET_EV_CODE(event);
+	cookie = MHI_TRE_GET_EV_COOKIE(event);
+	xfer_len = MHI_TRE_GET_EV_LEN(event);
+
+	/* received out of bound cookie */
+	MHI_ASSERT(cookie >= buf_ring->len, "Invalid Cookie\n");
+
+	buf_info = buf_ring->base + cookie;
+
+	result.transaction_status = (ev_code == MHI_EV_CC_OVERFLOW) ?
+	    -EOVERFLOW : 0;
+	result.bytes_xferd = xfer_len;
+	result.buf_addr = buf_info->cb_buf;
+	result.dir = mhi_chan->dir;
+
+	read_lock_bh(&mhi_chan->lock);
+
+	if (mhi_chan->ch_state != MHI_CH_STATE_ENABLED)
+		goto end_process_rsc_event;
+
+	MHI_ASSERT(!buf_info->used, "TRE already Freed\n");
+
+	/* notify the client */
+	mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
+
+	/*
+	 * Note: We're arbitrarily incrementing RP even though, completion
+	 * packet we processed might not be the same one, reason we can do this
+	 * is because device guaranteed to cache descriptors in order it
+	 * receive, so even though completion event is different we can re-use
+	 * all descriptors in between.
+	 * Example:
+	 * Transfer Ring has descriptors: A, B, C, D
+	 * Last descriptor host queue is D (WP) and first descriptor
+	 * host queue is A (RP).
+	 * The completion event we just serviced is descriptor C.
+	 * Then we can safely queue descriptors to replace A, B, and C
+	 * even though host did not receive any completions.
+	 */
+	mhi_del_ring_element(mhi_cntrl, tre_ring);
+	buf_info->used = false;
+
+end_process_rsc_event:
+	read_unlock_bh(&mhi_chan->lock);
+
+	return 0;
+}
+
+static void mhi_process_cmd_completion(struct mhi_controller *mhi_cntrl,
+				       struct mhi_tre *tre)
+{
+	dma_addr_t ptr = MHI_TRE_GET_EV_PTR(tre);
+	struct mhi_cmd *cmd_ring = &mhi_cntrl->mhi_cmd[PRIMARY_CMD_RING];
+	struct mhi_ring *mhi_ring = &cmd_ring->ring;
+	struct mhi_tre *cmd_pkt;
+	struct mhi_chan *mhi_chan;
+	struct mhi_timesync *mhi_tsync;
+	enum mhi_cmd_type type;
+	u32 chan;
+
+	cmd_pkt = mhi_to_virtual(mhi_ring, ptr);
+
+	/* out of order completion received */
+	MHI_ASSERT(cmd_pkt != mhi_ring->rptr, "Out of order cmd completion");
+
+	type = MHI_TRE_GET_CMD_TYPE(cmd_pkt);
+
+	if (type == MHI_CMD_TYPE_TSYNC) {
+		mhi_tsync = mhi_cntrl->mhi_tsync;
+		mhi_tsync->ccs = MHI_TRE_GET_EV_CODE(tre);
+		complete(&mhi_tsync->completion);
+	} else {
+		chan = MHI_TRE_GET_CMD_CHID(cmd_pkt);
+		mhi_chan = &mhi_cntrl->mhi_chan[chan];
+		write_lock_bh(&mhi_chan->lock);
+		mhi_chan->ccs = MHI_TRE_GET_EV_CODE(tre);
+		complete(&mhi_chan->completion);
+		write_unlock_bh(&mhi_chan->lock);
+	}
+
+	mhi_del_ring_element(mhi_cntrl, mhi_ring);
+}
+
+static void __mhi_process_ctrl_ev_type(struct mhi_controller *mhi_cntrl,
+				struct mhi_tre *local_rp,
+				enum MHI_PKT_TYPE type)
+{
+	MHI_VERB("Processing Event:0x%llx 0x%08x 0x%08x\n",
+		 local_rp->ptr, local_rp->dword[0], local_rp->dword[1]);
+
+	switch (type) {
+	case MHI_PKT_TYPE_STATE_CHANGE_EVENT:
+	{
+		enum mhi_dev_state new_state;
+
+		new_state = MHI_TRE_GET_EV_STATE(local_rp);
+
+		MHI_LOG("MHI state change event to state:%s\n",
+			TO_MHI_STATE_STR(new_state));
+
+		switch (new_state) {
+		case MHI_STATE_M0:
+			mhi_pm_m0_transition(mhi_cntrl);
+			break;
+		case MHI_STATE_M1:
+			mhi_pm_m1_transition(mhi_cntrl);
+			break;
+		case MHI_STATE_M3:
+			mhi_pm_m3_transition(mhi_cntrl);
+			break;
+		case MHI_STATE_SYS_ERR:
+		{
+			enum MHI_PM_STATE new_state;
+
+			MHI_ERR("MHI system error detected\n");
+			write_lock_irq(&mhi_cntrl->pm_lock);
+			new_state = mhi_tryset_pm_state(mhi_cntrl,
+					MHI_PM_SYS_ERR_DETECT);
+			write_unlock_irq(&mhi_cntrl->pm_lock);
+			if (new_state == MHI_PM_SYS_ERR_DETECT)
+				schedule_work(&mhi_cntrl->syserr_worker);
+			break;
+		}
+		default:
+			MHI_ERR("Unsupported STE:%s\n",
+				TO_MHI_STATE_STR(new_state));
+		}
+
+		break;
+	}
+	case MHI_PKT_TYPE_CMD_COMPLETION_EVENT:
+		mhi_process_cmd_completion(mhi_cntrl, local_rp);
+		break;
+	case MHI_PKT_TYPE_EE_EVENT:
+	{
+		enum MHI_ST_TRANSITION st = MHI_ST_TRANSITION_MAX;
+		enum mhi_ee event = MHI_TRE_GET_EV_EXECENV(local_rp);
+
+		MHI_LOG("MHI EE received event:%s\n",
+			TO_MHI_EXEC_STR(event));
+		switch (event) {
+		case MHI_EE_SBL:
+			st = MHI_ST_TRANSITION_SBL;
+			break;
+		case MHI_EE_WFW:
+		case MHI_EE_AMSS:
+			st = MHI_ST_TRANSITION_MISSION_MODE;
+			break;
+		case MHI_EE_RDDM:
+			mhi_cntrl->status_cb(mhi_cntrl, mhi_cntrl->priv_data,
+					     MHI_CB_EE_RDDM);
+			write_lock_irq(&mhi_cntrl->pm_lock);
+			mhi_cntrl->ee = event;
+			write_unlock_irq(&mhi_cntrl->pm_lock);
+			wake_up_all(&mhi_cntrl->state_event);
+			break;
+		default:
+			MHI_ERR("Unhandled EE event:%s\n",
+				TO_MHI_EXEC_STR(event));
+		}
+		if (st != MHI_ST_TRANSITION_MAX)
+			mhi_queue_state_transition(mhi_cntrl, st);
+
+		break;
+	}
+	default:
+		MHI_ASSERT(1, "Unsupported ev type");
+		break;
+	}
+}
+
+int mhi_process_ctrl_ev_ring(struct mhi_controller *mhi_cntrl,
+			     struct mhi_event *mhi_event, u32 event_quota)
+{
+	struct mhi_tre *dev_rp, *local_rp;
+	struct mhi_ring *ev_ring = &mhi_event->ring;
+	struct mhi_event_ctxt *er_ctxt =
+	    &mhi_cntrl->mhi_ctxt->er_ctxt[mhi_event->er_index];
+	int count = 0;
+
+	/*
+	 * this is a quick check to avoid unnecessary event processing
+	 * in case we already in error state, but it's still possible
+	 * to transition to error state while processing events
+	 */
+	if (unlikely(MHI_EVENT_ACCESS_INVALID(mhi_cntrl->pm_state))) {
+		MHI_ERR("No EV access, PM_STATE:%s\n",
+			to_mhi_pm_state_str(mhi_cntrl->pm_state));
+		return -EIO;
+	}
+
+	dev_rp = mhi_to_virtual(ev_ring, er_ctxt->rp);
+	local_rp = ev_ring->rptr;
+
+	while (dev_rp != local_rp) {
+		enum MHI_PKT_TYPE type = MHI_TRE_GET_EV_TYPE(local_rp);
+
+		__mhi_process_ctrl_ev_type(mhi_cntrl, local_rp, type);
+
+		mhi_recycle_ev_ring_element(mhi_cntrl, ev_ring);
+		local_rp = ev_ring->rptr;
+		dev_rp = mhi_to_virtual(ev_ring, er_ctxt->rp);
+		count++;
+	}
+
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	if (likely(MHI_DB_ACCESS_VALID(mhi_cntrl->pm_state)))
+		mhi_ring_er_db(mhi_event);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	MHI_VERB("exit er_index:%u\n", mhi_event->er_index);
+
+	return count;
+}
+
+int mhi_process_data_event_ring(struct mhi_controller *mhi_cntrl,
+				struct mhi_event *mhi_event, u32 event_quota)
+{
+	struct mhi_tre *dev_rp, *local_rp;
+	struct mhi_ring *ev_ring = &mhi_event->ring;
+	struct mhi_event_ctxt *er_ctxt =
+	    &mhi_cntrl->mhi_ctxt->er_ctxt[mhi_event->er_index];
+	int count = 0;
+	u32 chan;
+	struct mhi_chan *mhi_chan;
+
+	if (unlikely(MHI_EVENT_ACCESS_INVALID(mhi_cntrl->pm_state))) {
+		MHI_ERR("No EV access, PM_STATE:%s\n",
+			to_mhi_pm_state_str(mhi_cntrl->pm_state));
+		return -EIO;
+	}
+
+	dev_rp = mhi_to_virtual(ev_ring, er_ctxt->rp);
+	local_rp = ev_ring->rptr;
+
+	while (dev_rp != local_rp && event_quota > 0) {
+		enum MHI_PKT_TYPE type = MHI_TRE_GET_EV_TYPE(local_rp);
+
+		MHI_VERB("Processing Event:0x%llx 0x%08x 0x%08x\n",
+			 local_rp->ptr, local_rp->dword[0], local_rp->dword[1]);
+
+		chan = MHI_TRE_GET_EV_CHID(local_rp);
+		mhi_chan = &mhi_cntrl->mhi_chan[chan];
+
+		if (likely(type == MHI_PKT_TYPE_TX_EVENT)) {
+			parse_xfer_event(mhi_cntrl, local_rp, mhi_chan);
+			event_quota--;
+		} else if (type == MHI_PKT_TYPE_RSC_TX_EVENT) {
+			parse_rsc_event(mhi_cntrl, local_rp, mhi_chan);
+			event_quota--;
+		}
+
+		mhi_recycle_ev_ring_element(mhi_cntrl, ev_ring);
+		local_rp = ev_ring->rptr;
+		dev_rp = mhi_to_virtual(ev_ring, er_ctxt->rp);
+		count++;
+	}
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	if (likely(MHI_DB_ACCESS_VALID(mhi_cntrl->pm_state)))
+		mhi_ring_er_db(mhi_event);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	MHI_VERB("exit er_index:%u\n", mhi_event->er_index);
+
+	return count;
+}
+
+int mhi_process_tsync_event_ring(struct mhi_controller *mhi_cntrl,
+				 struct mhi_event *mhi_event, u32 event_quota)
+{
+	struct mhi_tre *dev_rp, *local_rp;
+	struct mhi_ring *ev_ring = &mhi_event->ring;
+	struct mhi_event_ctxt *er_ctxt =
+	    &mhi_cntrl->mhi_ctxt->er_ctxt[mhi_event->er_index];
+	struct mhi_timesync *mhi_tsync = mhi_cntrl->mhi_tsync;
+	int count = 0;
+	u32 sequence;
+	u64 remote_time;
+
+	if (unlikely(MHI_EVENT_ACCESS_INVALID(mhi_cntrl->pm_state))) {
+		MHI_ERR("No EV access, PM_STATE:%s\n",
+			to_mhi_pm_state_str(mhi_cntrl->pm_state));
+		read_unlock_bh(&mhi_cntrl->pm_lock);
+		return -EIO;
+	}
+
+	dev_rp = mhi_to_virtual(ev_ring, er_ctxt->rp);
+	local_rp = ev_ring->rptr;
+
+	while (dev_rp != local_rp) {
+		enum MHI_PKT_TYPE type = MHI_TRE_GET_EV_TYPE(local_rp);
+		struct tsync_node *tsync_node;
+
+		MHI_VERB("Processing Event:0x%llx 0x%08x 0x%08x\n",
+			 local_rp->ptr, local_rp->dword[0], local_rp->dword[1]);
+
+		MHI_ASSERT(type != MHI_PKT_TYPE_TSYNC_EVENT, "!TSYNC event");
+
+		sequence = MHI_TRE_GET_EV_SEQ(local_rp);
+		remote_time = MHI_TRE_GET_EV_TIME(local_rp);
+
+		do {
+			spin_lock_irq(&mhi_tsync->lock);
+			tsync_node = list_first_entry_or_null(&mhi_tsync->head,
+							      struct tsync_node,
+							      node);
+			MHI_ASSERT(!tsync_node, "Unexpected Event");
+
+			if (unlikely(!tsync_node))
+				break;
+
+			list_del(&tsync_node->node);
+			spin_unlock_irq(&mhi_tsync->lock);
+
+			/*
+			 * device may not able to process all time sync commands
+			 * host issue and only process last command it receive
+			 */
+			if (tsync_node->sequence == sequence) {
+				tsync_node->cb_func(tsync_node->mhi_dev,
+						    sequence,
+						    tsync_node->local_time,
+						    remote_time);
+				kfree(tsync_node);
+			} else {
+				kfree(tsync_node);
+			}
+		} while (true);
+
+		mhi_recycle_ev_ring_element(mhi_cntrl, ev_ring);
+		local_rp = ev_ring->rptr;
+		dev_rp = mhi_to_virtual(ev_ring, er_ctxt->rp);
+		count++;
+	}
+
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	if (likely(MHI_DB_ACCESS_VALID(mhi_cntrl->pm_state)))
+		mhi_ring_er_db(mhi_event);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	MHI_VERB("exit er_index:%u\n", mhi_event->er_index);
+
+	return count;
+}
+
+void mhi_ev_task(unsigned long data)
+{
+	struct mhi_event *mhi_event = (struct mhi_event *)data;
+	struct mhi_controller *mhi_cntrl = mhi_event->mhi_cntrl;
+
+	MHI_VERB("Enter for ev_index:%d\n", mhi_event->er_index);
+
+	/* process all pending events */
+	spin_lock_bh(&mhi_event->lock);
+	mhi_event->process_event(mhi_cntrl, mhi_event, U32_MAX);
+	spin_unlock_bh(&mhi_event->lock);
+}
+
+void mhi_ctrl_ev_task(unsigned long data)
+{
+	struct mhi_event *mhi_event = (struct mhi_event *)data;
+	struct mhi_controller *mhi_cntrl = mhi_event->mhi_cntrl;
+	enum mhi_dev_state state;
+	enum MHI_PM_STATE pm_state = 0;
+	int ret;
+
+	MHI_VERB("Enter for ev_index:%d\n", mhi_event->er_index);
+
+	/*
+	 * we can check pm_state w/o a lock here because there is no way
+	 * pm_state can change from reg access valid to no access while this
+	 * therad being executed.
+	 */
+	if (!MHI_REG_ACCESS_VALID(mhi_cntrl->pm_state))
+		return;
+
+	/* process ctrl events */
+	ret = mhi_event->process_event(mhi_cntrl, mhi_event, U32_MAX);
+
+	/*
+	 * we received a MSI but no events to process maybe device went to
+	 * SYS_ERR state, check the state
+	 */
+	if (!ret) {
+		write_lock_irq(&mhi_cntrl->pm_lock);
+		state = mhi_get_mhi_state(mhi_cntrl);
+		if (state == MHI_STATE_SYS_ERR) {
+			MHI_ERR("MHI system error detected\n");
+			pm_state = mhi_tryset_pm_state(mhi_cntrl,
+						       MHI_PM_SYS_ERR_DETECT);
+		}
+		write_unlock_irq(&mhi_cntrl->pm_lock);
+		if (pm_state == MHI_PM_SYS_ERR_DETECT)
+			schedule_work(&mhi_cntrl->syserr_worker);
+	}
+}
+
+irqreturn_t mhi_msi_handlr(int irq_number, void *dev)
+{
+	struct mhi_event *mhi_event = dev;
+	struct mhi_controller *mhi_cntrl = mhi_event->mhi_cntrl;
+	struct mhi_event_ctxt *er_ctxt =
+	    &mhi_cntrl->mhi_ctxt->er_ctxt[mhi_event->er_index];
+	struct mhi_ring *ev_ring = &mhi_event->ring;
+	void *dev_rp = mhi_to_virtual(ev_ring, er_ctxt->rp);
+
+	/* confirm ER has pending events to process before scheduling work */
+	if (ev_ring->rptr == dev_rp)
+		return IRQ_HANDLED;
+
+	/* client managed event ring, notify pending data */
+	if (mhi_event->cl_manage) {
+		struct mhi_chan *mhi_chan = mhi_event->mhi_chan;
+		struct mhi_device *mhi_dev = mhi_chan->mhi_dev;
+
+		if (mhi_dev)
+			mhi_dev->status_cb(mhi_dev, MHI_CB_PENDING_DATA);
+	} else
+		tasklet_schedule(&mhi_event->task);
+
+	return IRQ_HANDLED;
+}
+
+/* this is the threaded fn */
+irqreturn_t mhi_intvec_threaded_handlr(int irq_number, void *dev)
+{
+	struct mhi_controller *mhi_cntrl = dev;
+	enum mhi_dev_state state = MHI_STATE_MAX;
+	enum MHI_PM_STATE pm_state = 0;
+	enum mhi_ee ee;
+
+	MHI_VERB("Enter\n");
+
+	write_lock_irq(&mhi_cntrl->pm_lock);
+	if (MHI_REG_ACCESS_VALID(mhi_cntrl->pm_state)) {
+		state = mhi_get_mhi_state(mhi_cntrl);
+		ee = mhi_get_exec_env(mhi_cntrl);
+		MHI_LOG("device ee:%s dev_state:%s\n", TO_MHI_EXEC_STR(ee),
+			TO_MHI_STATE_STR(state));
+	}
+
+	/* tim.hc.lin, testing */
+	if (ee == MHI_EE_AMSS && state == MHI_STATE_READY)
+		mhi_queue_state_transition(mhi_cntrl, MHI_ST_TRANSITION_READY);
+
+	if (state == MHI_STATE_SYS_ERR) {
+		MHI_ERR("MHI system error detected\n");
+		pm_state = mhi_tryset_pm_state(mhi_cntrl,
+					       MHI_PM_SYS_ERR_DETECT);
+	}
+	write_unlock_irq(&mhi_cntrl->pm_lock);
+	if (pm_state == MHI_PM_SYS_ERR_DETECT) {
+		wake_up_all(&mhi_cntrl->state_event);
+
+		/* for fatal errors, we let controller decide next step */
+		if (MHI_IN_PBL(ee))
+			mhi_cntrl->status_cb(mhi_cntrl, mhi_cntrl->priv_data,
+					     MHI_CB_FATAL_ERROR);
+		else
+			schedule_work(&mhi_cntrl->syserr_worker);
+	}
+
+	MHI_VERB("Exit\n");
+
+	return IRQ_HANDLED;
+}
+
+irqreturn_t mhi_intvec_handlr(int irq_number, void *dev)
+{
+
+	struct mhi_controller *mhi_cntrl = dev;
+
+	/* wake up any events waiting for state change */
+	MHI_VERB("Enter\n");
+	wake_up_all(&mhi_cntrl->state_event);
+	MHI_VERB("Exit\n");
+
+	return IRQ_WAKE_THREAD;
+}
+
+int mhi_send_cmd(struct mhi_controller *mhi_cntrl,
+		 struct mhi_chan *mhi_chan, enum MHI_CMD cmd)
+{
+	struct mhi_tre *cmd_tre = NULL;
+	struct mhi_cmd *mhi_cmd = &mhi_cntrl->mhi_cmd[PRIMARY_CMD_RING];
+	struct mhi_ring *ring = &mhi_cmd->ring;
+	int chan = 0;
+
+	MHI_VERB("Entered, MHI pm_state:%s dev_state:%s ee:%s\n",
+		 to_mhi_pm_state_str(mhi_cntrl->pm_state),
+		 TO_MHI_STATE_STR(mhi_cntrl->dev_state),
+		 TO_MHI_EXEC_STR(mhi_cntrl->ee));
+
+	if (mhi_chan)
+		chan = mhi_chan->chan;
+
+	spin_lock_bh(&mhi_cmd->lock);
+	if (!get_nr_avail_ring_elements(mhi_cntrl, ring)) {
+		spin_unlock_bh(&mhi_cmd->lock);
+		return -ENOMEM;
+	}
+
+	/* prepare the cmd tre */
+	cmd_tre = ring->wptr;
+	switch (cmd) {
+	case MHI_CMD_RESET_CHAN:
+		cmd_tre->ptr = MHI_TRE_CMD_RESET_PTR;
+		cmd_tre->dword[0] = MHI_TRE_CMD_RESET_DWORD0;
+		cmd_tre->dword[1] = MHI_TRE_CMD_RESET_DWORD1(chan);
+		break;
+	case MHI_CMD_START_CHAN:
+		cmd_tre->ptr = MHI_TRE_CMD_START_PTR;
+		cmd_tre->dword[0] = MHI_TRE_CMD_START_DWORD0;
+		cmd_tre->dword[1] = MHI_TRE_CMD_START_DWORD1(chan);
+		break;
+	case MHI_CMD_TIMSYNC_CFG:
+		cmd_tre->ptr = MHI_TRE_CMD_TSYNC_CFG_PTR;
+		cmd_tre->dword[0] = MHI_TRE_CMD_TSYNC_CFG_DWORD0;
+		cmd_tre->dword[1] = MHI_TRE_CMD_TSYNC_CFG_DWORD1
+		    (mhi_cntrl->mhi_tsync->er_index);
+		break;
+	}
+
+	MHI_VERB("WP:0x%llx TRE: 0x%llx 0x%08x 0x%08x\n",
+		 (u64)mhi_to_physical(ring, cmd_tre), cmd_tre->ptr,
+		 cmd_tre->dword[0], cmd_tre->dword[1]);
+
+	/* queue to hardware */
+	mhi_add_ring_element(mhi_cntrl, ring);
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	if (likely(MHI_DB_ACCESS_VALID(mhi_cntrl->pm_state)))
+		mhi_ring_cmd_db(mhi_cntrl, mhi_cmd);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+	spin_unlock_bh(&mhi_cmd->lock);
+
+	return 0;
+}
+
+static int __mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
+				 struct mhi_chan *mhi_chan)
+{
+	int ret = 0;
+
+	MHI_LOG("Entered: preparing channel:%d\n", mhi_chan->chan);
+
+	if (!(BIT(mhi_cntrl->ee) & mhi_chan->ee_mask)) {
+		MHI_ERR("Current EE:%s Required EE Mask:0x%x for chan:%s\n",
+			TO_MHI_EXEC_STR(mhi_cntrl->ee), mhi_chan->ee_mask,
+			mhi_chan->name);
+		return -ENOTCONN;
+	}
+
+	mutex_lock(&mhi_chan->mutex);
+
+	/* if channel is not disable state do not allow to start */
+	if (mhi_chan->ch_state != MHI_CH_STATE_DISABLED) {
+		ret = -EIO;
+		MHI_LOG("channel:%d is not in disabled state, ch_state%d\n",
+			mhi_chan->chan, mhi_chan->ch_state);
+		goto error_init_chan;
+	}
+
+	/* client manages channel context for offload channels */
+	if (!mhi_chan->offload_ch) {
+		ret = mhi_init_chan_ctxt(mhi_cntrl, mhi_chan);
+		if (ret) {
+			MHI_ERR("Error with init chan\n");
+			goto error_init_chan;
+		}
+	}
+
+	reinit_completion(&mhi_chan->completion);
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	if (MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state)) {
+		MHI_ERR("MHI host is not in active state\n");
+		read_unlock_bh(&mhi_cntrl->pm_lock);
+		ret = -EIO;
+		goto error_pm_state;
+	}
+
+	mhi_cntrl->wake_get(mhi_cntrl, false);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+	mhi_cntrl->runtime_get(mhi_cntrl, mhi_cntrl->priv_data);
+	mhi_cntrl->runtime_put(mhi_cntrl, mhi_cntrl->priv_data);
+
+	ret = mhi_send_cmd(mhi_cntrl, mhi_chan, MHI_CMD_START_CHAN);
+	if (ret) {
+		MHI_ERR("Failed to send start chan cmd\n");
+		goto error_send_cmd;
+	}
+
+	ret = wait_for_completion_timeout(&mhi_chan->completion,
+				msecs_to_jiffies(mhi_cntrl->timeout_ms));
+	if (!ret || mhi_chan->ccs != MHI_EV_CC_SUCCESS) {
+		MHI_ERR("Failed to receive cmd completion for chan:%d\n",
+			mhi_chan->chan);
+		ret = -EIO;
+		goto error_send_cmd;
+	}
+
+	write_lock_irq(&mhi_chan->lock);
+	mhi_chan->ch_state = MHI_CH_STATE_ENABLED;
+	write_unlock_irq(&mhi_chan->lock);
+
+	/* pre allocate buffer for xfer ring */
+	if (mhi_chan->pre_alloc) {
+		int nr_el = get_nr_avail_ring_elements(mhi_cntrl,
+						       &mhi_chan->tre_ring);
+		size_t len = mhi_cntrl->buffer_len;
+
+		while (nr_el--) {
+			void *buf;
+
+			buf = kmalloc(len, GFP_KERNEL);
+			if (!buf) {
+				ret = -ENOMEM;
+				goto error_pre_alloc;
+			}
+
+			/* prepare transfer descriptors */
+			ret = mhi_chan->gen_tre(mhi_cntrl, mhi_chan, buf, buf,
+						len, MHI_EOT);
+			if (ret) {
+				MHI_ERR("Chan:%d error prepare buffer\n",
+					mhi_chan->chan);
+				kfree(buf);
+				goto error_pre_alloc;
+			}
+		}
+
+		read_lock_bh(&mhi_cntrl->pm_lock);
+		if (MHI_DB_ACCESS_VALID(mhi_cntrl->pm_state)) {
+			read_lock_irq(&mhi_chan->lock);
+			mhi_ring_chan_db(mhi_cntrl, mhi_chan);
+			read_unlock_irq(&mhi_chan->lock);
+		}
+		read_unlock_bh(&mhi_cntrl->pm_lock);
+	}
+
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	mhi_cntrl->wake_put(mhi_cntrl, false);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	mutex_unlock(&mhi_chan->mutex);
+
+	MHI_LOG("Chan:%d successfully moved to start state\n", mhi_chan->chan);
+
+	return 0;
+
+error_send_cmd:
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	mhi_cntrl->wake_put(mhi_cntrl, false);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+error_pm_state:
+	if (!mhi_chan->offload_ch)
+		mhi_deinit_chan_ctxt(mhi_cntrl, mhi_chan);
+
+error_init_chan:
+	mutex_unlock(&mhi_chan->mutex);
+
+	return ret;
+
+error_pre_alloc:
+
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	mhi_cntrl->wake_put(mhi_cntrl, false);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	mutex_unlock(&mhi_chan->mutex);
+	__mhi_unprepare_channel(mhi_cntrl, mhi_chan);
+
+	return ret;
+}
+
+static void mhi_mark_stale_events(struct mhi_controller *mhi_cntrl,
+				  struct mhi_event *mhi_event,
+				  struct mhi_event_ctxt *er_ctxt, int chan)
+{
+	struct mhi_tre *dev_rp, *local_rp;
+	struct mhi_ring *ev_ring;
+	unsigned long flags;
+
+	MHI_LOG("Marking all events for chan:%d as stale\n", chan);
+
+	ev_ring = &mhi_event->ring;
+
+	/* mark all stale events related to channel as STALE event */
+	spin_lock_irqsave(&mhi_event->lock, flags);
+	dev_rp = mhi_to_virtual(ev_ring, er_ctxt->rp);
+
+	local_rp = ev_ring->rptr;
+	while (dev_rp != local_rp) {
+		if (MHI_TRE_GET_EV_TYPE(local_rp) ==
+		    MHI_PKT_TYPE_TX_EVENT &&
+		    chan == MHI_TRE_GET_EV_CHID(local_rp))
+			local_rp->dword[1] = MHI_TRE_EV_DWORD1(chan,
+						MHI_PKT_TYPE_STALE_EVENT);
+		local_rp++;
+		if (local_rp == (ev_ring->base + ev_ring->len))
+			local_rp = ev_ring->base;
+	}
+
+	MHI_LOG("Finished marking events as stale events\n");
+	spin_unlock_irqrestore(&mhi_event->lock, flags);
+}
+
+static void mhi_reset_data_chan(struct mhi_controller *mhi_cntrl,
+				struct mhi_chan *mhi_chan)
+{
+	struct mhi_ring *buf_ring, *tre_ring;
+	struct mhi_result result;
+
+	/* reset any pending buffers */
+	buf_ring = &mhi_chan->buf_ring;
+	tre_ring = &mhi_chan->tre_ring;
+	result.transaction_status = -ENOTCONN;
+	result.bytes_xferd = 0;
+	while (tre_ring->rptr != tre_ring->wptr) {
+		struct mhi_buf_info *buf_info = buf_ring->rptr;
+
+		if (mhi_chan->dir == DMA_TO_DEVICE)
+			mhi_cntrl->wake_put(mhi_cntrl, false);
+		if (!buf_info->pre_mapped)
+			mhi_cntrl->unmap_single(mhi_cntrl, buf_info);
+		mhi_del_ring_element(mhi_cntrl, buf_ring);
+		mhi_del_ring_element(mhi_cntrl, tre_ring);
+
+		if (mhi_chan->pre_alloc) {
+			kfree(buf_info->cb_buf);
+		} else {
+			result.buf_addr = buf_info->cb_buf;
+			mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
+		}
+	}
+}
+
+static void mhi_reset_rsc_chan(struct mhi_controller *mhi_cntrl,
+			       struct mhi_chan *mhi_chan)
+{
+	struct mhi_ring *buf_ring, *tre_ring;
+	struct mhi_result result;
+	struct mhi_buf_info *buf_info;
+
+	/* reset any pending buffers */
+	buf_ring = &mhi_chan->buf_ring;
+	tre_ring = &mhi_chan->tre_ring;
+	result.transaction_status = -ENOTCONN;
+	result.bytes_xferd = 0;
+
+	buf_info = buf_ring->base;
+	for (; (void *)buf_info < buf_ring->base + buf_ring->len; buf_info++) {
+		if (!buf_info->used)
+			continue;
+
+		result.buf_addr = buf_info->cb_buf;
+		mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
+		buf_info->used = false;
+	}
+}
+
+void mhi_reset_chan(struct mhi_controller *mhi_cntrl, struct mhi_chan *mhi_chan)
+{
+
+	struct mhi_event *mhi_event;
+	struct mhi_event_ctxt *er_ctxt;
+	int chan = mhi_chan->chan;
+
+	/* nothing to reset, client don't queue buffers */
+	if (mhi_chan->offload_ch)
+		return;
+
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	mhi_event = &mhi_cntrl->mhi_event[mhi_chan->er_index];
+	er_ctxt = &mhi_cntrl->mhi_ctxt->er_ctxt[mhi_chan->er_index];
+
+	mhi_mark_stale_events(mhi_cntrl, mhi_event, er_ctxt, chan);
+
+	if (mhi_chan->xfer_type == MHI_XFER_RSC_DMA)
+		mhi_reset_rsc_chan(mhi_cntrl, mhi_chan);
+	else
+		mhi_reset_data_chan(mhi_cntrl, mhi_chan);
+
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+	MHI_LOG("Reset complete.\n");
+}
+
+static void __mhi_unprepare_channel(struct mhi_controller *mhi_cntrl,
+				    struct mhi_chan *mhi_chan)
+{
+	int ret;
+
+	MHI_LOG("Entered: unprepare channel:%d\n", mhi_chan->chan);
+
+	/* no more processing events for this channel */
+	mutex_lock(&mhi_chan->mutex);
+	write_lock_irq(&mhi_chan->lock);
+	if (mhi_chan->ch_state != MHI_CH_STATE_ENABLED) {
+		MHI_LOG("chan:%d is already disabled\n", mhi_chan->chan);
+		write_unlock_irq(&mhi_chan->lock);
+		mutex_unlock(&mhi_chan->mutex);
+		return;
+	}
+
+	mhi_chan->ch_state = MHI_CH_STATE_DISABLED;
+	write_unlock_irq(&mhi_chan->lock);
+
+	reinit_completion(&mhi_chan->completion);
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	if (MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state)) {
+		read_unlock_bh(&mhi_cntrl->pm_lock);
+		goto error_invalid_state;
+	}
+
+	mhi_cntrl->wake_get(mhi_cntrl, false);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	mhi_cntrl->runtime_get(mhi_cntrl, mhi_cntrl->priv_data);
+	mhi_cntrl->runtime_put(mhi_cntrl, mhi_cntrl->priv_data);
+	ret = mhi_send_cmd(mhi_cntrl, mhi_chan, MHI_CMD_RESET_CHAN);
+	if (ret) {
+		MHI_ERR("Failed to send reset chan cmd\n");
+		goto error_completion;
+	}
+
+	/* even if it fails we will still reset */
+	ret = wait_for_completion_timeout(&mhi_chan->completion,
+				msecs_to_jiffies(mhi_cntrl->timeout_ms));
+	if (!ret || mhi_chan->ccs != MHI_EV_CC_SUCCESS)
+		MHI_ERR("Failed to receive cmd completion, still resetting\n");
+
+error_completion:
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	mhi_cntrl->wake_put(mhi_cntrl, false);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+error_invalid_state:
+	if (!mhi_chan->offload_ch) {
+		mhi_reset_chan(mhi_cntrl, mhi_chan);
+		mhi_deinit_chan_ctxt(mhi_cntrl, mhi_chan);
+	}
+	MHI_LOG("chan:%d successfully resetted\n", mhi_chan->chan);
+	mutex_unlock(&mhi_chan->mutex);
+}
+
+int mhi_debugfs_mhi_states_show(struct seq_file *m, void *d)
+{
+	struct mhi_controller *mhi_cntrl = m->private;
+
+	seq_printf(m, "pm_state:%s dev_state:%s EE:%s M0:%u M2:%u M3:%u ",
+		   to_mhi_pm_state_str(mhi_cntrl->pm_state),
+		   TO_MHI_STATE_STR(mhi_cntrl->dev_state),
+		   TO_MHI_EXEC_STR(mhi_cntrl->ee),
+		   mhi_cntrl->M0, mhi_cntrl->M2, mhi_cntrl->M3);
+	seq_printf(m, "wake:%d dev_wake:%u alloc_size:%u\n",
+		   mhi_cntrl->wake_set,
+		   atomic_read(&mhi_cntrl->dev_wake),
+		   atomic_read(&mhi_cntrl->alloc_size));
+
+	return 0;
+}
+
+static int __mhi_debugfs_mhi_event_show_ring(struct seq_file *m, int index,
+				struct mhi_event_ctxt *er_ctxt,
+				struct mhi_event *mhi_event)
+{
+	struct mhi_ring *ring = &mhi_event->ring;
+
+	if (mhi_event->offload_ev) {
+		seq_printf(m, "Index:%d offload event ring\n", index);
+		return 0;
+	}
+
+	seq_printf(m, "Index:%d modc:%d modt:%d base:0x%0llx len:0x%llx",
+		   index, er_ctxt->intmodc, er_ctxt->intmodt,
+		   er_ctxt->rbase, er_ctxt->rlen);
+	seq_printf(m, " rp:0x%llx wp:0x%llx local_rp:0x%llx db:0x%llx\n",
+		   er_ctxt->rp, er_ctxt->wp,
+		   (unsigned long long)mhi_to_physical(ring, ring->rptr),
+		   (unsigned long long)mhi_event->db_cfg.db_val);
+
+	return 0;
+}
+
+int mhi_debugfs_mhi_event_show(struct seq_file *m, void *d)
+{
+	struct mhi_controller *mhi_cntrl = m->private;
+	struct mhi_event *mhi_event;
+	struct mhi_event_ctxt *er_ctxt;
+
+	int i;
+
+	er_ctxt = mhi_cntrl->mhi_ctxt->er_ctxt;
+	mhi_event = mhi_cntrl->mhi_event;
+	for (i = 0; i < mhi_cntrl->total_ev_rings;
+				i++, er_ctxt++, mhi_event++)
+		__mhi_debugfs_mhi_event_show_ring(m, i, er_ctxt, mhi_event);
+
+	return 0;
+}
+
+static int __mhi_debugfs_mhi_chan_show_ring(struct seq_file *m, int index,
+				struct mhi_chan_ctxt *chan_ctxt,
+				struct mhi_chan *mhi_chan)
+{
+	struct mhi_ring *ring = &mhi_chan->tre_ring;
+
+	if (mhi_chan->offload_ch) {
+		seq_printf(m, "%s(%u) offload channel\n",
+			mhi_chan->name, mhi_chan->chan);
+	} else if (mhi_chan->mhi_dev) {
+		seq_printf(m, "%s(%u) state:0x%x brstmode:0x%x pllcfg:0x%x ",
+			mhi_chan->name, mhi_chan->chan,
+			chan_ctxt->chstate, chan_ctxt->brstmode,
+			chan_ctxt->pollcfg);
+		seq_printf(m, "type:0x%x erindex:%u ",
+			chan_ctxt->chtype, chan_ctxt->erindex);
+		seq_printf(m, "base:0x%llx len:0x%llx wp:0x%llx ",
+			chan_ctxt->rbase, chan_ctxt->rlen,
+			chan_ctxt->wp);
+		seq_printf(m, "local_rp:0x%llx local_wp:0x%llx db:0x%llx\n",
+			(unsigned long long)mhi_to_physical(ring, ring->rptr),
+			(unsigned long long)mhi_to_physical(ring, ring->wptr),
+			(unsigned long long)mhi_chan->db_cfg.db_val);
+	}
+
+	return 0;
+}
+
+int mhi_debugfs_mhi_chan_show(struct seq_file *m, void *d)
+{
+	struct mhi_controller *mhi_cntrl = m->private;
+	struct mhi_chan *mhi_chan;
+	struct mhi_chan_ctxt *chan_ctxt;
+	int i;
+
+	mhi_chan = mhi_cntrl->mhi_chan;
+	chan_ctxt = mhi_cntrl->mhi_ctxt->chan_ctxt;
+	for (i = 0; i < mhi_cntrl->max_chan; i++, chan_ctxt++, mhi_chan++)
+		__mhi_debugfs_mhi_chan_show_ring(m, i, chan_ctxt, mhi_chan);
+
+	return 0;
+}
+
+/* move channel to start state */
+int mhi_prepare_for_transfer(struct mhi_device *mhi_dev)
+{
+	int ret, dir;
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_chan *mhi_chan;
+
+	for (dir = 0; dir < 2; dir++) {
+		mhi_chan = dir ? mhi_dev->dl_chan : mhi_dev->ul_chan;
+
+		if (!mhi_chan)
+			continue;
+
+		ret = __mhi_prepare_channel(mhi_cntrl, mhi_chan);
+		if (ret) {
+			MHI_ERR("Error moving chan %s,%d to START state\n",
+				mhi_chan->name, mhi_chan->chan);
+			goto error_open_chan;
+		}
+	}
+
+	return 0;
+
+error_open_chan:
+	for (--dir; dir >= 0; dir--) {
+		mhi_chan = dir ? mhi_dev->dl_chan : mhi_dev->ul_chan;
+
+		if (!mhi_chan)
+			continue;
+
+		__mhi_unprepare_channel(mhi_cntrl, mhi_chan);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(mhi_prepare_for_transfer);
+
+void mhi_unprepare_from_transfer(struct mhi_device *mhi_dev)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_chan *mhi_chan;
+	int dir;
+
+	for (dir = 0; dir < 2; dir++) {
+		mhi_chan = dir ? mhi_dev->ul_chan : mhi_dev->dl_chan;
+
+		if (!mhi_chan)
+			continue;
+
+		__mhi_unprepare_channel(mhi_cntrl, mhi_chan);
+	}
+}
+EXPORT_SYMBOL(mhi_unprepare_from_transfer);
+
+int mhi_get_no_free_descriptors(struct mhi_device *mhi_dev,
+				enum dma_data_direction dir)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_chan *mhi_chan = (dir == DMA_TO_DEVICE) ?
+	    mhi_dev->ul_chan : mhi_dev->dl_chan;
+	struct mhi_ring *tre_ring = &mhi_chan->tre_ring;
+
+	return get_nr_avail_ring_elements(mhi_cntrl, tre_ring);
+}
+EXPORT_SYMBOL(mhi_get_no_free_descriptors);
+
+static int __mhi_bdf_to_controller(struct device *dev, const void *tmp)
+{
+	struct mhi_device *mhi_dev = to_mhi_device(dev);
+	const struct mhi_device *match = tmp;
+
+	/* return any none-zero value if match */
+	if (mhi_dev->dev_type == MHI_CONTROLLER_TYPE &&
+	    mhi_dev->domain == match->domain && mhi_dev->bus == match->bus &&
+	    mhi_dev->slot == match->slot && mhi_dev->dev_id == match->dev_id)
+		return 1;
+
+	return 0;
+}
+
+struct mhi_controller *mhi_bdf_to_controller(u32 domain,
+					     u32 bus, u32 slot, u32 dev_id)
+{
+	struct mhi_device tmp, *mhi_dev;
+	struct device *dev;
+
+	tmp.domain = domain;
+	tmp.bus = bus;
+	tmp.slot = slot;
+	tmp.dev_id = dev_id;
+
+	dev = bus_find_device(&mhi_bus_type, NULL, &tmp,
+			      __mhi_bdf_to_controller);
+	if (!dev)
+		return NULL;
+
+	mhi_dev = to_mhi_device(dev);
+
+	return mhi_dev->mhi_cntrl;
+}
+EXPORT_SYMBOL(mhi_bdf_to_controller);
+
+int mhi_poll(struct mhi_device *mhi_dev, u32 budget)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_chan *mhi_chan = mhi_dev->dl_chan;
+	struct mhi_event *mhi_event = &mhi_cntrl->mhi_event[mhi_chan->er_index];
+	int ret;
+
+	spin_lock_bh(&mhi_event->lock);
+	ret = mhi_event->process_event(mhi_cntrl, mhi_event, budget);
+	spin_unlock_bh(&mhi_event->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(mhi_poll);
+
+int mhi_get_remote_time_sync(struct mhi_device *mhi_dev,
+			     u64 *t_host, u64 *t_dev)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_timesync *mhi_tsync = mhi_cntrl->mhi_tsync;
+	int ret;
+
+	/* not all devices support time feature */
+	if (!mhi_tsync)
+		return -EIO;
+
+	/* bring to M0 state */
+	ret = __mhi_device_get_sync(mhi_cntrl);
+	if (ret)
+		return ret;
+
+	mutex_lock(&mhi_tsync->lpm_mutex);
+
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	if (unlikely(MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state))) {
+		MHI_ERR("MHI is not in active state, pm_state:%s\n",
+			to_mhi_pm_state_str(mhi_cntrl->pm_state));
+		ret = -EIO;
+		goto error_invalid_state;
+	}
+
+	/* disable link level low power modes */
+	ret = mhi_cntrl->lpm_disable(mhi_cntrl, mhi_cntrl->priv_data);
+	if (ret)
+		goto error_invalid_state;
+
+	/*
+	 * time critical code to fetch device times,
+	 * delay between these two steps should be
+	 * deterministic as possible.
+	 */
+	preempt_disable();
+	local_irq_disable();
+
+	*t_host = mhi_cntrl->time_get(mhi_cntrl, mhi_cntrl->priv_data);
+#ifdef CONFIG_ARM
+	*t_dev = readq_relaxed_no_log(mhi_tsync->time_reg);
+#else
+	*t_dev = readq_relaxed(mhi_tsync->time_reg);
+#endif
+
+	local_irq_enable();
+	preempt_enable();
+
+	mhi_cntrl->lpm_enable(mhi_cntrl, mhi_cntrl->priv_data);
+
+error_invalid_state:
+	mhi_cntrl->wake_put(mhi_cntrl, false);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+	mutex_unlock(&mhi_tsync->lpm_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(mhi_get_remote_time_sync);
+
+/**
+ * mhi_get_remote_time - Get external modem time relative to host time
+ * Trigger event to capture modem time, also capture host time so client
+ * can do a relative drift comparision.
+ * Recommended only tsync device calls this method and do not call this
+ * from atomic context
+ * @mhi_dev: Device associated with the channels
+ * @sequence:unique sequence id track event
+ * @cb_func: callback function to call back
+ */
+int mhi_get_remote_time(struct mhi_device *mhi_dev,
+			u32 sequence,
+			void (*cb_func)(struct mhi_device *mhi_dev,
+					u32 sequence,
+					u64 local_time, u64 remote_time))
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	struct mhi_timesync *mhi_tsync = mhi_cntrl->mhi_tsync;
+	struct tsync_node *tsync_node;
+	int ret;
+
+	/* not all devices support time feature */
+	if (!mhi_tsync)
+		return -EIO;
+
+	/* tsync db can only be rung in M0 state */
+	ret = __mhi_device_get_sync(mhi_cntrl);
+	if (ret)
+		return ret;
+
+	/*
+	 * technically we can use GFP_KERNEL, but wants to avoid
+	 * # of times scheduling out
+	 */
+	tsync_node = kzalloc(sizeof(*tsync_node), GFP_ATOMIC);
+	if (!tsync_node) {
+		ret = -ENOMEM;
+		goto error_no_mem;
+	}
+
+	tsync_node->sequence = sequence;
+	tsync_node->cb_func = cb_func;
+	tsync_node->mhi_dev = mhi_dev;
+
+	/* disable link level low power modes */
+	mhi_cntrl->lpm_disable(mhi_cntrl, mhi_cntrl->priv_data);
+
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	if (unlikely(MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state))) {
+		MHI_ERR("MHI is not in active state, pm_state:%s\n",
+			to_mhi_pm_state_str(mhi_cntrl->pm_state));
+		ret = -EIO;
+		goto error_invalid_state;
+	}
+
+	spin_lock_irq(&mhi_tsync->lock);
+	list_add_tail(&tsync_node->node, &mhi_tsync->head);
+	spin_unlock_irq(&mhi_tsync->lock);
+
+	/*
+	 * time critical code, delay between these two steps should be
+	 * deterministic as possible.
+	 */
+	preempt_disable();
+	local_irq_disable();
+
+	tsync_node->local_time =
+	    mhi_cntrl->time_get(mhi_cntrl, mhi_cntrl->priv_data);
+#ifdef CONFIG_ARM
+	writel_relaxed_no_log(tsync_node->sequence, mhi_tsync->db);
+#else
+	writel_relaxed(tsync_node->sequence, mhi_tsync->db);
+#endif
+	/* write must go thru immediately */
+	wmb();
+
+	local_irq_enable();
+	preempt_enable();
+
+	ret = 0;
+
+error_invalid_state:
+	if (ret)
+		kfree(tsync_node);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+	mhi_cntrl->lpm_enable(mhi_cntrl, mhi_cntrl->priv_data);
+
+error_no_mem:
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	mhi_cntrl->wake_put(mhi_cntrl, false);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(mhi_get_remote_time);
+
+void mhi_debug_reg_dump(struct mhi_controller *mhi_cntrl)
+{
+	enum mhi_dev_state state;
+	enum mhi_ee ee;
+	int i, ret;
+	u32 val = 0;
+	void __iomem *mhi_base = mhi_cntrl->regs;
+	void __iomem *bhi_base = mhi_cntrl->bhi;
+	void __iomem *bhie_base = mhi_cntrl->bhie;
+	void __iomem *wake_db = mhi_cntrl->wake_db;
+	struct {
+		const char *name;
+		int offset;
+		void *base;
+	} debug_reg[] = {
+		{ "MHI_CNTRL", MHICTRL, mhi_base },
+		{ "MHI_STATUS", MHISTATUS, mhi_base },
+		{ "MHI_WAKE_DB", 0, wake_db },
+		{ "BHI_EXECENV", BHI_EXECENV, bhi_base },
+		{ "BHI_STATUS", BHI_STATUS, bhi_base },
+		{ "BHI_ERRCODE", BHI_ERRCODE, bhi_base },
+		{ "BHI_ERRDBG1", BHI_ERRDBG1, bhi_base },
+		{ "BHI_ERRDBG2", BHI_ERRDBG2, bhi_base },
+		{ "BHI_ERRDBG3", BHI_ERRDBG3, bhi_base },
+		{ "BHIE_TXVEC_DB", BHIE_TXVECDB_OFFS, bhie_base },
+		{ "BHIE_TXVEC_STATUS", BHIE_TXVECSTATUS_OFFS, bhie_base },
+		{ "BHIE_RXVEC_DB", BHIE_RXVECDB_OFFS, bhie_base },
+		{ "BHIE_RXVEC_STATUS", BHIE_RXVECSTATUS_OFFS, bhie_base },
+		{ NULL },
+	};
+
+	MHI_LOG("host pm_state:%s dev_state:%s ee:%s\n",
+		to_mhi_pm_state_str(mhi_cntrl->pm_state),
+		TO_MHI_STATE_STR(mhi_cntrl->dev_state),
+		TO_MHI_EXEC_STR(mhi_cntrl->ee));
+
+	state = mhi_get_mhi_state(mhi_cntrl);
+	ee = mhi_get_exec_env(mhi_cntrl);
+
+	MHI_LOG("device ee:%s dev_state:%s\n", TO_MHI_EXEC_STR(ee),
+		TO_MHI_STATE_STR(state));
+
+	for (i = 0; debug_reg[i].name; i++) {
+		ret = mhi_read_reg(mhi_cntrl, debug_reg[i].base,
+				   debug_reg[i].offset, &val);
+		MHI_LOG("reg:%s val:0x%x, ret:%d\n", debug_reg[i].name, val,
+			ret);
+	}
+}
+EXPORT_SYMBOL(mhi_debug_reg_dump);
diff --git a/drivers/bus/mhi/core/mhi_pm.c b/drivers/bus/mhi/core/mhi_pm.c
new file mode 100644
index 000000000000..1c9b5cca2459
--- /dev/null
+++ b/drivers/bus/mhi/core/mhi_pm.c
@@ -0,0 +1,1158 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2018-2019, The Linux Foundation. All rights reserved. */
+
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dma-direction.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/of.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/wait.h>
+#include <linux/mhi.h>
+#include "mhi_internal.h"
+
+/*
+ * Not all MHI states transitions are sync transitions. Linkdown, SSR, and
+ * shutdown can happen anytime asynchronously. This function will transition to
+ * new state only if we're allowed to transitions.
+ *
+ * Priority increase as we go down, example while in any states from L0, start
+ * state from L1, L2, or L3 can be set.  Notable exception to this rule is state
+ * DISABLE.  From DISABLE state we can transition to only POR or state.  Also
+ * for example while in L2 state, user cannot jump back to L1 or L0 states.
+ * Valid transitions:
+ * L0: DISABLE <--> POR
+ *     POR <--> POR
+ *     POR -> M0 -> M2 --> M0
+ *     POR -> FW_DL_ERR
+ *     FW_DL_ERR <--> FW_DL_ERR
+ *     M0 -> FW_DL_ERR
+ *     M0 -> M3_ENTER -> M3 -> M3_EXIT --> M0
+ * L1: SYS_ERR_DETECT -> SYS_ERR_PROCESS --> POR
+ * L2: SHUTDOWN_PROCESS -> DISABLE
+ * L3: LD_ERR_FATAL_DETECT <--> LD_ERR_FATAL_DETECT
+ *     LD_ERR_FATAL_DETECT -> SHUTDOWN_PROCESS
+ */
+static const struct mhi_pm_transitions mhi_state_transitions[] = {
+	/* L0 States */
+	{
+		MHI_PM_DISABLE,
+		MHI_PM_POR
+	},
+	{
+		MHI_PM_POR,
+		MHI_PM_POR | MHI_PM_DISABLE | MHI_PM_M0 |
+		MHI_PM_SYS_ERR_DETECT | MHI_PM_SHUTDOWN_PROCESS |
+		MHI_PM_LD_ERR_FATAL_DETECT | MHI_PM_FW_DL_ERR
+	},
+	{
+		MHI_PM_M0,
+		MHI_PM_M2 | MHI_PM_M3_ENTER | MHI_PM_SYS_ERR_DETECT |
+		MHI_PM_SHUTDOWN_PROCESS | MHI_PM_LD_ERR_FATAL_DETECT |
+		MHI_PM_FW_DL_ERR
+	},
+	{
+		MHI_PM_M2,
+		MHI_PM_M0 | MHI_PM_SYS_ERR_DETECT | MHI_PM_SHUTDOWN_PROCESS |
+		MHI_PM_LD_ERR_FATAL_DETECT
+	},
+	{
+		MHI_PM_M3_ENTER,
+		MHI_PM_M3 | MHI_PM_SYS_ERR_DETECT | MHI_PM_SHUTDOWN_PROCESS |
+		MHI_PM_LD_ERR_FATAL_DETECT
+	},
+	{
+		MHI_PM_M3,
+		MHI_PM_M3_EXIT | MHI_PM_SYS_ERR_DETECT |
+		MHI_PM_SHUTDOWN_PROCESS | MHI_PM_LD_ERR_FATAL_DETECT
+	},
+	{
+		MHI_PM_M3_EXIT,
+		MHI_PM_M0 | MHI_PM_SYS_ERR_DETECT | MHI_PM_SHUTDOWN_PROCESS |
+		MHI_PM_LD_ERR_FATAL_DETECT
+	},
+	{
+		MHI_PM_FW_DL_ERR,
+		MHI_PM_FW_DL_ERR | MHI_PM_SYS_ERR_DETECT |
+		MHI_PM_SHUTDOWN_PROCESS | MHI_PM_LD_ERR_FATAL_DETECT
+	},
+	/* L1 States */
+	{
+		MHI_PM_SYS_ERR_DETECT,
+		MHI_PM_SYS_ERR_PROCESS | MHI_PM_SHUTDOWN_PROCESS |
+		MHI_PM_LD_ERR_FATAL_DETECT
+	},
+	{
+		MHI_PM_SYS_ERR_PROCESS,
+		MHI_PM_POR | MHI_PM_SHUTDOWN_PROCESS |
+		MHI_PM_LD_ERR_FATAL_DETECT
+	},
+	/* L2 States */
+	{
+		MHI_PM_SHUTDOWN_PROCESS,
+		MHI_PM_DISABLE | MHI_PM_LD_ERR_FATAL_DETECT
+	},
+	/* L3 States */
+	{
+		MHI_PM_LD_ERR_FATAL_DETECT,
+		MHI_PM_LD_ERR_FATAL_DETECT | MHI_PM_SHUTDOWN_PROCESS
+	},
+};
+
+enum MHI_PM_STATE __must_check mhi_tryset_pm_state(struct mhi_controller
+						   *mhi_cntrl,
+						   enum MHI_PM_STATE state)
+{
+	unsigned long cur_state = mhi_cntrl->pm_state;
+	int index = find_last_bit(&cur_state, 32);
+
+	if (unlikely(index >= ARRAY_SIZE(mhi_state_transitions))) {
+		MHI_CRITICAL("cur_state:%s is not a valid pm_state\n",
+			     to_mhi_pm_state_str(cur_state));
+		return cur_state;
+	}
+
+	if (unlikely(mhi_state_transitions[index].from_state != cur_state)) {
+		MHI_ERR("index:%u cur_state:%s != actual_state: %s\n",
+			index, to_mhi_pm_state_str(cur_state),
+			to_mhi_pm_state_str
+			(mhi_state_transitions[index].from_state));
+		return cur_state;
+	}
+
+	if (unlikely(!(mhi_state_transitions[index].to_states & state))) {
+		MHI_LOG
+		    ("Not allowing pm state transition from:%s to:%s state\n",
+		     to_mhi_pm_state_str(cur_state),
+		     to_mhi_pm_state_str(state));
+		return cur_state;
+	}
+
+	MHI_VERB("Transition to pm state from:%s to:%s\n",
+		 to_mhi_pm_state_str(cur_state), to_mhi_pm_state_str(state));
+
+	mhi_cntrl->pm_state = state;
+	return mhi_cntrl->pm_state;
+}
+
+void mhi_set_mhi_state(struct mhi_controller *mhi_cntrl,
+		       enum mhi_dev_state state)
+{
+	if (state == MHI_STATE_RESET) {
+		mhi_write_reg_field(mhi_cntrl, mhi_cntrl->regs, MHICTRL,
+				    MHICTRL_RESET_MASK, MHICTRL_RESET_SHIFT, 1);
+	} else {
+		mhi_write_reg_field(mhi_cntrl, mhi_cntrl->regs, MHICTRL,
+				    MHICTRL_MHISTATE_MASK,
+				    MHICTRL_MHISTATE_SHIFT, state);
+	}
+}
+EXPORT_SYMBOL(mhi_set_mhi_state);
+
+/* set device wake */
+void mhi_assert_dev_wake(struct mhi_controller *mhi_cntrl, bool force)
+{
+	unsigned long flags;
+
+	/* if set, regardless of count set the bit if not set */
+	if (unlikely(force)) {
+		spin_lock_irqsave(&mhi_cntrl->wlock, flags);
+		atomic_inc(&mhi_cntrl->dev_wake);
+		if (MHI_WAKE_DB_FORCE_SET_VALID(mhi_cntrl->pm_state) &&
+		    !mhi_cntrl->wake_set) {
+			mhi_write_db(mhi_cntrl, mhi_cntrl->wake_db, 1);
+			mhi_cntrl->wake_set = true;
+		}
+		spin_unlock_irqrestore(&mhi_cntrl->wlock, flags);
+	} else {
+		/* if resources requested already, then increment and exit */
+		if (likely(atomic_add_unless(&mhi_cntrl->dev_wake, 1, 0)))
+			return;
+
+		spin_lock_irqsave(&mhi_cntrl->wlock, flags);
+		if ((atomic_inc_return(&mhi_cntrl->dev_wake) == 1) &&
+		    MHI_WAKE_DB_SET_VALID(mhi_cntrl->pm_state) &&
+		    !mhi_cntrl->wake_set) {
+			mhi_write_db(mhi_cntrl, mhi_cntrl->wake_db, 1);
+			mhi_cntrl->wake_set = true;
+		}
+		spin_unlock_irqrestore(&mhi_cntrl->wlock, flags);
+	}
+}
+
+/* clear device wake */
+void mhi_deassert_dev_wake(struct mhi_controller *mhi_cntrl, bool override)
+{
+	unsigned long flags;
+
+	MHI_ASSERT(atomic_read(&mhi_cntrl->dev_wake) == 0, "dev_wake == 0");
+
+	/* resources not dropping to 0, decrement and exit */
+	if (likely(atomic_add_unless(&mhi_cntrl->dev_wake, -1, 1)))
+		return;
+
+	spin_lock_irqsave(&mhi_cntrl->wlock, flags);
+	if ((atomic_dec_return(&mhi_cntrl->dev_wake) == 0) &&
+	    MHI_WAKE_DB_CLEAR_VALID(mhi_cntrl->pm_state) && !override &&
+	    mhi_cntrl->wake_set) {
+		mhi_write_db(mhi_cntrl, mhi_cntrl->wake_db, 0);
+		mhi_cntrl->wake_set = false;
+	}
+	spin_unlock_irqrestore(&mhi_cntrl->wlock, flags);
+}
+
+int mhi_ready_state_transition(struct mhi_controller *mhi_cntrl)
+{
+	void __iomem *base = mhi_cntrl->regs;
+	u32 reset = 1, ready = 0;
+	struct mhi_event *mhi_event;
+	enum MHI_PM_STATE cur_state;
+	int ret, i;
+
+	MHI_LOG("Waiting to enter READY state\n");
+
+	/* wait for RESET to be cleared and READY bit to be set */
+	wait_event_timeout(mhi_cntrl->state_event,
+			   MHI_PM_IN_FATAL_STATE(mhi_cntrl->pm_state) ||
+			   mhi_read_reg_field(mhi_cntrl, base, MHICTRL,
+					      MHICTRL_RESET_MASK,
+					      MHICTRL_RESET_SHIFT, &reset) ||
+			   mhi_read_reg_field(mhi_cntrl, base, MHISTATUS,
+					      MHISTATUS_READY_MASK,
+					      MHISTATUS_READY_SHIFT, &ready) ||
+			   (!reset && ready),
+			   msecs_to_jiffies(mhi_cntrl->timeout_ms));
+
+	/* device enter into error state */
+	if (MHI_PM_IN_FATAL_STATE(mhi_cntrl->pm_state))
+		return -EIO;
+
+	/* device did not transition to ready state */
+	if (reset || !ready)
+		return -ETIMEDOUT;
+
+	MHI_LOG("Device in READY State\n");
+	write_lock_irq(&mhi_cntrl->pm_lock);
+	cur_state = mhi_tryset_pm_state(mhi_cntrl, MHI_PM_POR);
+	mhi_cntrl->dev_state = MHI_STATE_READY;
+	write_unlock_irq(&mhi_cntrl->pm_lock);
+
+	if (cur_state != MHI_PM_POR) {
+		MHI_ERR("Error moving to state %s from %s\n",
+			to_mhi_pm_state_str(MHI_PM_POR),
+			to_mhi_pm_state_str(cur_state));
+		return -EIO;
+	}
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	if (!MHI_REG_ACCESS_VALID(mhi_cntrl->pm_state))
+		goto error_mmio;
+
+	ret = mhi_init_mmio(mhi_cntrl);
+	if (ret) {
+		MHI_ERR("Error programming mmio registers\n");
+		goto error_mmio;
+	}
+
+	/* add elements to all sw event rings */
+	mhi_event = mhi_cntrl->mhi_event;
+	for (i = 0; i < mhi_cntrl->total_ev_rings; i++, mhi_event++) {
+		struct mhi_ring *ring = &mhi_event->ring;
+
+		if (mhi_event->offload_ev || mhi_event->hw_ring)
+			continue;
+
+		ring->wptr = ring->base + ring->len - ring->el_size;
+		*ring->ctxt_wp = ring->iommu_base + ring->len - ring->el_size;
+		/* needs to update to all cores */
+		smp_wmb();
+
+		/* ring the db for event rings */
+		spin_lock_irq(&mhi_event->lock);
+		mhi_ring_er_db(mhi_event);
+		spin_unlock_irq(&mhi_event->lock);
+	}
+
+	/* set device into M0 state */
+	mhi_set_mhi_state(mhi_cntrl, MHI_STATE_M0);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	return 0;
+
+error_mmio:
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	return -EIO;
+}
+
+int mhi_pm_m0_transition(struct mhi_controller *mhi_cntrl)
+{
+	enum MHI_PM_STATE cur_state;
+	struct mhi_chan *mhi_chan;
+	int i;
+
+	MHI_LOG("Entered With State:%s PM_STATE:%s\n",
+		TO_MHI_STATE_STR(mhi_cntrl->dev_state),
+		to_mhi_pm_state_str(mhi_cntrl->pm_state));
+
+	write_lock_irq(&mhi_cntrl->pm_lock);
+	mhi_cntrl->dev_state = MHI_STATE_M0;
+	cur_state = mhi_tryset_pm_state(mhi_cntrl, MHI_PM_M0);
+	write_unlock_irq(&mhi_cntrl->pm_lock);
+	if (unlikely(cur_state != MHI_PM_M0)) {
+		MHI_ERR("Failed to transition to state %s from %s\n",
+			to_mhi_pm_state_str(MHI_PM_M0),
+			to_mhi_pm_state_str(cur_state));
+		return -EIO;
+	}
+	mhi_cntrl->M0++;
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	mhi_cntrl->wake_get(mhi_cntrl, false);
+
+	/* ring all event rings and CMD ring only if we're in mission mode */
+	if (MHI_IN_MISSION_MODE(mhi_cntrl->ee)) {
+		struct mhi_event *mhi_event = mhi_cntrl->mhi_event;
+		struct mhi_cmd *mhi_cmd = &mhi_cntrl->mhi_cmd[PRIMARY_CMD_RING];
+
+		for (i = 0; i < mhi_cntrl->total_ev_rings; i++, mhi_event++) {
+			if (mhi_event->offload_ev)
+				continue;
+
+			spin_lock_irq(&mhi_event->lock);
+			mhi_ring_er_db(mhi_event);
+			spin_unlock_irq(&mhi_event->lock);
+		}
+
+		/* only ring primary cmd ring */
+		spin_lock_irq(&mhi_cmd->lock);
+		if (mhi_cmd->ring.rptr != mhi_cmd->ring.wptr)
+			mhi_ring_cmd_db(mhi_cntrl, mhi_cmd);
+		spin_unlock_irq(&mhi_cmd->lock);
+	}
+
+	/* ring channel db registers */
+	mhi_chan = mhi_cntrl->mhi_chan;
+	for (i = 0; i < mhi_cntrl->max_chan; i++, mhi_chan++) {
+		struct mhi_ring *tre_ring = &mhi_chan->tre_ring;
+
+		write_lock_irq(&mhi_chan->lock);
+		if (mhi_chan->db_cfg.reset_req)
+			mhi_chan->db_cfg.db_mode = true;
+
+		/* only ring DB if ring is not empty */
+		if (tre_ring->base && tre_ring->wptr != tre_ring->rptr)
+			mhi_ring_chan_db(mhi_cntrl, mhi_chan);
+		write_unlock_irq(&mhi_chan->lock);
+	}
+
+	mhi_cntrl->wake_put(mhi_cntrl, false);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+	wake_up_all(&mhi_cntrl->state_event);
+	MHI_VERB("Exited\n");
+
+	return 0;
+}
+
+void mhi_pm_m1_transition(struct mhi_controller *mhi_cntrl)
+{
+	enum MHI_PM_STATE state;
+
+	write_lock_irq(&mhi_cntrl->pm_lock);
+	/* if it fails, means we transition to M3 */
+	state = mhi_tryset_pm_state(mhi_cntrl, MHI_PM_M2);
+	if (state == MHI_PM_M2) {
+		MHI_VERB("Entered M2 State\n");
+		mhi_set_mhi_state(mhi_cntrl, MHI_STATE_M2);
+		mhi_cntrl->dev_state = MHI_STATE_M2;
+		mhi_cntrl->M2++;
+
+		write_unlock_irq(&mhi_cntrl->pm_lock);
+		wake_up_all(&mhi_cntrl->state_event);
+
+		/* transfer pending, exit M2 immediately */
+		if (unlikely(atomic_read(&mhi_cntrl->dev_wake))) {
+			MHI_VERB("Exiting M2 Immediately, count:%d\n",
+				 atomic_read(&mhi_cntrl->dev_wake));
+			read_lock_bh(&mhi_cntrl->pm_lock);
+			mhi_cntrl->wake_get(mhi_cntrl, true);
+			mhi_cntrl->wake_put(mhi_cntrl, false);
+			read_unlock_bh(&mhi_cntrl->pm_lock);
+		} else {
+			mhi_cntrl->status_cb(mhi_cntrl, mhi_cntrl->priv_data,
+					     MHI_CB_IDLE);
+		}
+	} else {
+		write_unlock_irq(&mhi_cntrl->pm_lock);
+	}
+}
+
+int mhi_pm_m3_transition(struct mhi_controller *mhi_cntrl)
+{
+	enum MHI_PM_STATE state;
+
+	write_lock_irq(&mhi_cntrl->pm_lock);
+	mhi_cntrl->dev_state = MHI_STATE_M3;
+	state = mhi_tryset_pm_state(mhi_cntrl, MHI_PM_M3);
+	write_unlock_irq(&mhi_cntrl->pm_lock);
+	if (state != MHI_PM_M3) {
+		MHI_ERR("Failed to transition to state %s from %s\n",
+			to_mhi_pm_state_str(MHI_PM_M3),
+			to_mhi_pm_state_str(mhi_cntrl->pm_state));
+		return -EIO;
+	}
+	wake_up_all(&mhi_cntrl->state_event);
+	mhi_cntrl->M3++;
+
+	MHI_LOG("Entered mhi_state:%s pm_state:%s\n",
+		TO_MHI_STATE_STR(mhi_cntrl->dev_state),
+		to_mhi_pm_state_str(mhi_cntrl->pm_state));
+	return 0;
+}
+
+static int mhi_pm_mission_mode_transition(struct mhi_controller *mhi_cntrl)
+{
+	int i, ret;
+	struct mhi_event *mhi_event;
+
+	MHI_LOG("Processing Mission Mode Transition\n");
+
+	/* force MHI to be in M0 state before continuing */
+	ret = __mhi_device_get_sync(mhi_cntrl);
+	if (ret)
+		return ret;
+
+	ret = -EIO;
+
+	write_lock_irq(&mhi_cntrl->pm_lock);
+	if (MHI_REG_ACCESS_VALID(mhi_cntrl->pm_state))
+		mhi_cntrl->ee = mhi_get_exec_env(mhi_cntrl);
+	write_unlock_irq(&mhi_cntrl->pm_lock);
+
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	if (!MHI_IN_MISSION_MODE(mhi_cntrl->ee))
+		goto error_mission_mode;
+
+	wake_up_all(&mhi_cntrl->state_event);
+
+	/* add elements to all HW event rings */
+	if (MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state))
+		goto error_mission_mode;
+
+	mhi_event = mhi_cntrl->mhi_event;
+	for (i = 0; i < mhi_cntrl->total_ev_rings; i++, mhi_event++) {
+		struct mhi_ring *ring = &mhi_event->ring;
+
+		if (mhi_event->offload_ev || !mhi_event->hw_ring)
+			continue;
+
+		ring->wptr = ring->base + ring->len - ring->el_size;
+		*ring->ctxt_wp = ring->iommu_base + ring->len - ring->el_size;
+		/* all ring updates must get updated immediately */
+		smp_wmb();
+
+		spin_lock_irq(&mhi_event->lock);
+		if (MHI_DB_ACCESS_VALID(mhi_cntrl->pm_state))
+			mhi_ring_er_db(mhi_event);
+		spin_unlock_irq(&mhi_event->lock);
+
+	}
+
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	/* setup support for time sync */
+	mhi_init_timesync(mhi_cntrl);
+
+	MHI_LOG("Adding new devices\n");
+
+	/* add supported devices */
+	mhi_create_devices(mhi_cntrl);
+
+	ret = 0;
+
+	/* Free BHI INTVEC msi */
+	if (mhi_cntrl->msi_allocated == 1)
+		free_irq(mhi_cntrl->irq[0], mhi_cntrl);
+
+	read_lock_bh(&mhi_cntrl->pm_lock);
+
+error_mission_mode:
+	mhi_cntrl->wake_put(mhi_cntrl, false);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	MHI_LOG("Exit with ret:%d\n", ret);
+
+	return ret;
+}
+
+/* handles both sys_err and shutdown transitions */
+static void mhi_pm_disable_transition(struct mhi_controller *mhi_cntrl,
+				      enum MHI_PM_STATE transition_state)
+{
+	enum MHI_PM_STATE cur_state, prev_state;
+	struct mhi_event *mhi_event;
+	struct mhi_cmd_ctxt *cmd_ctxt;
+	struct mhi_cmd *mhi_cmd;
+	struct mhi_event_ctxt *er_ctxt;
+	int ret, i;
+
+	MHI_LOG("Enter with from pm_state:%s MHI_STATE:%s to pm_state:%s\n",
+		to_mhi_pm_state_str(mhi_cntrl->pm_state),
+		TO_MHI_STATE_STR(mhi_cntrl->dev_state),
+		to_mhi_pm_state_str(transition_state));
+
+	/* We must notify MHI control driver so it can clean up first */
+	if (transition_state == MHI_PM_SYS_ERR_PROCESS)
+		mhi_cntrl->status_cb(mhi_cntrl, mhi_cntrl->priv_data,
+				     MHI_CB_SYS_ERROR);
+
+	mutex_lock(&mhi_cntrl->pm_mutex);
+	write_lock_irq(&mhi_cntrl->pm_lock);
+	prev_state = mhi_cntrl->pm_state;
+	cur_state = mhi_tryset_pm_state(mhi_cntrl, transition_state);
+	if (cur_state == transition_state) {
+		mhi_cntrl->ee = MHI_EE_DISABLE_TRANSITION;
+		mhi_cntrl->dev_state = MHI_STATE_RESET;
+	}
+	write_unlock_irq(&mhi_cntrl->pm_lock);
+
+	/* wake up any threads waiting for state transitions */
+	wake_up_all(&mhi_cntrl->state_event);
+
+	/* not handling sys_err, could be middle of shut down */
+	if (cur_state != transition_state) {
+		MHI_LOG("Failed to transition to state:0x%x from:0x%x\n",
+			transition_state, cur_state);
+		mutex_unlock(&mhi_cntrl->pm_mutex);
+		return;
+	}
+
+	/* trigger MHI RESET so device will not access host ddr */
+	if (MHI_REG_ACCESS_VALID(prev_state)) {
+		u32 in_reset = -1;
+		unsigned long timeout = msecs_to_jiffies(mhi_cntrl->timeout_ms);
+
+		MHI_LOG("Trigger device into MHI_RESET\n");
+		mhi_set_mhi_state(mhi_cntrl, MHI_STATE_RESET);
+
+		/* wait for reset to be cleared */
+		ret = wait_event_timeout(mhi_cntrl->state_event,
+					 mhi_read_reg_field(mhi_cntrl,
+							    mhi_cntrl->regs,
+							    MHICTRL,
+							    MHICTRL_RESET_MASK,
+							    MHICTRL_RESET_SHIFT,
+							    &in_reset)
+					 || !in_reset, timeout);
+		if ((!ret || in_reset) && cur_state == MHI_PM_SYS_ERR_PROCESS) {
+			MHI_CRITICAL("Device failed to exit RESET state\n");
+			mutex_unlock(&mhi_cntrl->pm_mutex);
+			return;
+		}
+
+		/*
+		 * device cleares INTVEC as part of RESET processing,
+		 * re-program it
+		 */
+		mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
+	}
+
+	MHI_LOG("Waiting for all pending event ring processing to complete\n");
+	mhi_event = mhi_cntrl->mhi_event;
+	for (i = 0; i < mhi_cntrl->total_ev_rings; i++, mhi_event++) {
+		if (mhi_event->offload_ev)
+			continue;
+		tasklet_kill(&mhi_event->task);
+	}
+
+	mutex_unlock(&mhi_cntrl->pm_mutex);
+
+	MHI_LOG("Reset all active channels and remove mhi devices\n");
+	device_for_each_child(mhi_cntrl->dev, NULL, mhi_destroy_device);
+
+	MHI_LOG("Finish resetting channels\n");
+
+	MHI_LOG("Waiting for all pending threads to complete\n");
+	wake_up_all(&mhi_cntrl->state_event);
+	flush_work(&mhi_cntrl->st_worker);
+	flush_work(&mhi_cntrl->fw_worker);
+
+	mutex_lock(&mhi_cntrl->pm_mutex);
+
+	MHI_ASSERT(atomic_read(&mhi_cntrl->dev_wake), "dev_wake != 0");
+
+	/* reset the ev rings and cmd rings */
+	MHI_LOG("Resetting EV CTXT and CMD CTXT\n");
+	mhi_cmd = mhi_cntrl->mhi_cmd;
+	cmd_ctxt = mhi_cntrl->mhi_ctxt->cmd_ctxt;
+	for (i = 0; i < NR_OF_CMD_RINGS; i++, mhi_cmd++, cmd_ctxt++) {
+		struct mhi_ring *ring = &mhi_cmd->ring;
+
+		ring->rptr = ring->base;
+		ring->wptr = ring->base;
+		cmd_ctxt->rp = cmd_ctxt->rbase;
+		cmd_ctxt->wp = cmd_ctxt->rbase;
+	}
+
+	mhi_event = mhi_cntrl->mhi_event;
+	er_ctxt = mhi_cntrl->mhi_ctxt->er_ctxt;
+	for (i = 0; i < mhi_cntrl->total_ev_rings; i++,
+				er_ctxt++, mhi_event++) {
+		struct mhi_ring *ring = &mhi_event->ring;
+
+		/* do not touch offload er */
+		if (mhi_event->offload_ev)
+			continue;
+
+		ring->rptr = ring->base;
+		ring->wptr = ring->base;
+		er_ctxt->rp = er_ctxt->rbase;
+		er_ctxt->wp = er_ctxt->rbase;
+	}
+
+	/* remove support for time sync */
+	mhi_destroy_timesync(mhi_cntrl);
+
+	if (cur_state == MHI_PM_SYS_ERR_PROCESS) {
+		mhi_ready_state_transition(mhi_cntrl);
+	} else {
+		/* move to disable state */
+		write_lock_irq(&mhi_cntrl->pm_lock);
+		cur_state = mhi_tryset_pm_state(mhi_cntrl, MHI_PM_DISABLE);
+		write_unlock_irq(&mhi_cntrl->pm_lock);
+		if (unlikely(cur_state != MHI_PM_DISABLE))
+			MHI_ERR("Error moving from pm state:%s to state:%s\n",
+				to_mhi_pm_state_str(cur_state),
+				to_mhi_pm_state_str(MHI_PM_DISABLE));
+	}
+
+	MHI_LOG("Exit with pm_state:%s mhi_state:%s\n",
+		to_mhi_pm_state_str(mhi_cntrl->pm_state),
+		TO_MHI_STATE_STR(mhi_cntrl->dev_state));
+
+	mutex_unlock(&mhi_cntrl->pm_mutex);
+}
+
+int mhi_debugfs_trigger_reset(void *data, u64 val)
+{
+	struct mhi_controller *mhi_cntrl = data;
+	enum MHI_PM_STATE cur_state;
+	int ret;
+
+	MHI_LOG("Trigger MHI Reset\n");
+
+	/* exit lpm first */
+	mhi_cntrl->runtime_get(mhi_cntrl, mhi_cntrl->priv_data);
+	mhi_cntrl->runtime_put(mhi_cntrl, mhi_cntrl->priv_data);
+
+	ret = wait_event_timeout(mhi_cntrl->state_event,
+				 mhi_cntrl->dev_state == MHI_STATE_M0 ||
+				 MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state),
+				 msecs_to_jiffies(mhi_cntrl->timeout_ms));
+
+	if (!ret || MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state)) {
+		MHI_ERR("Did not enter M0 state, cur_state:%s pm_state:%s\n",
+			TO_MHI_STATE_STR(mhi_cntrl->dev_state),
+			to_mhi_pm_state_str(mhi_cntrl->pm_state));
+		return -EIO;
+	}
+
+	write_lock_irq(&mhi_cntrl->pm_lock);
+	cur_state = mhi_tryset_pm_state(mhi_cntrl, MHI_PM_SYS_ERR_DETECT);
+	write_unlock_irq(&mhi_cntrl->pm_lock);
+
+	if (cur_state == MHI_PM_SYS_ERR_DETECT)
+		schedule_work(&mhi_cntrl->syserr_worker);
+
+	return 0;
+}
+
+/* queue a new work item and scheduler work */
+int mhi_queue_state_transition(struct mhi_controller *mhi_cntrl,
+			       enum MHI_ST_TRANSITION state)
+{
+	struct state_transition *item = kmalloc(sizeof(*item), GFP_ATOMIC);
+	unsigned long flags;
+
+	if (!item)
+		return -ENOMEM;
+
+	item->state = state;
+	spin_lock_irqsave(&mhi_cntrl->transition_lock, flags);
+	list_add_tail(&item->node, &mhi_cntrl->transition_list);
+	spin_unlock_irqrestore(&mhi_cntrl->transition_lock, flags);
+
+	schedule_work(&mhi_cntrl->st_worker);
+
+	return 0;
+}
+
+void mhi_pm_sys_err_worker(struct work_struct *work)
+{
+	struct mhi_controller *mhi_cntrl = container_of(work,
+							struct mhi_controller,
+							syserr_worker);
+
+	MHI_LOG("Enter with pm_state:%s MHI_STATE:%s\n",
+		to_mhi_pm_state_str(mhi_cntrl->pm_state),
+		TO_MHI_STATE_STR(mhi_cntrl->dev_state));
+
+	mhi_pm_disable_transition(mhi_cntrl, MHI_PM_SYS_ERR_PROCESS);
+}
+
+void mhi_pm_st_worker(struct work_struct *work)
+{
+	struct state_transition *itr, *tmp;
+	LIST_HEAD(head);
+	struct mhi_controller *mhi_cntrl = container_of(work,
+							struct mhi_controller,
+							st_worker);
+	spin_lock_irq(&mhi_cntrl->transition_lock);
+	list_splice_tail_init(&mhi_cntrl->transition_list, &head);
+	spin_unlock_irq(&mhi_cntrl->transition_lock);
+
+	list_for_each_entry_safe(itr, tmp, &head, node) {
+		list_del(&itr->node);
+		MHI_LOG("Transition to state:%s\n",
+			TO_MHI_STATE_TRANS_STR(itr->state));
+
+		switch (itr->state) {
+		case MHI_ST_TRANSITION_PBL:
+			write_lock_irq(&mhi_cntrl->pm_lock);
+			if (MHI_REG_ACCESS_VALID(mhi_cntrl->pm_state))
+				mhi_cntrl->ee = mhi_get_exec_env(mhi_cntrl);
+			write_unlock_irq(&mhi_cntrl->pm_lock);
+			if (MHI_IN_PBL(mhi_cntrl->ee))
+				wake_up_all(&mhi_cntrl->state_event);
+			break;
+		case MHI_ST_TRANSITION_SBL:
+			write_lock_irq(&mhi_cntrl->pm_lock);
+			mhi_cntrl->ee = MHI_EE_SBL;
+			write_unlock_irq(&mhi_cntrl->pm_lock);
+			wake_up_all(&mhi_cntrl->state_event);
+			mhi_create_devices(mhi_cntrl);
+			break;
+		case MHI_ST_TRANSITION_MISSION_MODE:
+			mhi_pm_mission_mode_transition(mhi_cntrl);
+			break;
+		case MHI_ST_TRANSITION_READY:
+			mhi_ready_state_transition(mhi_cntrl);
+			break;
+		default:
+			break;
+		}
+		kfree(itr);
+	}
+}
+
+int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
+{
+	int ret;
+	u32 val;
+	enum mhi_ee current_ee;
+	enum MHI_ST_TRANSITION next_state;
+
+	MHI_LOG("Requested to power on\n");
+
+	/* if (mhi_cntrl->msi_allocated < mhi_cntrl->total_ev_rings)
+	 *	return -EINVAL;
+	 */
+
+	/* set to default wake if not set */
+	if (!mhi_cntrl->wake_get || !mhi_cntrl->wake_put) {
+		mhi_cntrl->wake_get = mhi_assert_dev_wake;
+		mhi_cntrl->wake_put = mhi_deassert_dev_wake;
+	}
+
+	mutex_lock(&mhi_cntrl->pm_mutex);
+	mhi_cntrl->pm_state = MHI_PM_DISABLE;
+
+	if (!mhi_cntrl->pre_init) {
+		/* setup device context */
+		ret = mhi_init_dev_ctxt(mhi_cntrl);
+		if (ret) {
+			MHI_ERR("Error setting dev_context\n");
+			goto error_dev_ctxt;
+		}
+
+		ret = mhi_init_irq_setup(mhi_cntrl);
+		if (ret) {
+			MHI_ERR("Error setting up irq\n");
+			goto error_setup_irq;
+		}
+	}
+
+	/* setup bhi offset & intvec */
+	write_lock_irq(&mhi_cntrl->pm_lock);
+	ret = mhi_read_reg(mhi_cntrl, mhi_cntrl->regs, BHIOFF, &val);
+	if (ret) {
+		write_unlock_irq(&mhi_cntrl->pm_lock);
+		MHI_ERR("Error getting bhi offset\n");
+		goto error_bhi_offset;
+	}
+
+	mhi_cntrl->bhi = mhi_cntrl->regs + val;
+
+	/* setup bhie offset */
+	if (mhi_cntrl->fbc_download) {
+		ret = mhi_read_reg(mhi_cntrl, mhi_cntrl->regs, BHIEOFF, &val);
+		if (ret) {
+			write_unlock_irq(&mhi_cntrl->pm_lock);
+			MHI_ERR("Error getting bhie offset\n");
+			goto error_bhi_offset;
+		}
+
+		mhi_cntrl->bhie = mhi_cntrl->regs + val;
+	}
+
+	mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
+	mhi_cntrl->pm_state = MHI_PM_POR;
+	mhi_cntrl->ee = MHI_EE_MAX;
+	current_ee = mhi_get_exec_env(mhi_cntrl);
+	write_unlock_irq(&mhi_cntrl->pm_lock);
+
+	/* confirm device is in valid exec env */
+	if (!MHI_IN_PBL(current_ee) && current_ee != MHI_EE_AMSS) {
+		MHI_ERR("Not a valid ee for power on\n");
+		ret = -EIO;
+		goto error_bhi_offset;
+	}
+
+	/* transition to next state */
+	next_state = MHI_IN_PBL(current_ee) ?
+	    MHI_ST_TRANSITION_PBL : MHI_ST_TRANSITION_READY;
+
+	if (next_state == MHI_ST_TRANSITION_PBL)
+		schedule_work(&mhi_cntrl->fw_worker);
+
+	mhi_queue_state_transition(mhi_cntrl, next_state);
+
+	mhi_init_debugfs(mhi_cntrl);
+
+	mutex_unlock(&mhi_cntrl->pm_mutex);
+
+	MHI_LOG("Power on setup success\n");
+
+	return 0;
+
+error_bhi_offset:
+	if (!mhi_cntrl->pre_init)
+		mhi_deinit_free_irq(mhi_cntrl);
+
+error_setup_irq:
+	if (!mhi_cntrl->pre_init)
+		mhi_deinit_dev_ctxt(mhi_cntrl);
+
+error_dev_ctxt:
+	mutex_unlock(&mhi_cntrl->pm_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(mhi_async_power_up);
+
+void mhi_power_down(struct mhi_controller *mhi_cntrl, bool graceful)
+{
+	enum MHI_PM_STATE cur_state;
+
+	/* if it's not graceful shutdown, force MHI to a linkdown state */
+	if (!graceful) {
+		mutex_lock(&mhi_cntrl->pm_mutex);
+		write_lock_irq(&mhi_cntrl->pm_lock);
+		cur_state = mhi_tryset_pm_state(mhi_cntrl,
+						MHI_PM_LD_ERR_FATAL_DETECT);
+		write_unlock_irq(&mhi_cntrl->pm_lock);
+		mutex_unlock(&mhi_cntrl->pm_mutex);
+		if (cur_state != MHI_PM_LD_ERR_FATAL_DETECT)
+			MHI_ERR("Failed to move to state:%s from:%s\n",
+				to_mhi_pm_state_str(MHI_PM_LD_ERR_FATAL_DETECT),
+				to_mhi_pm_state_str(mhi_cntrl->pm_state));
+	}
+	mhi_pm_disable_transition(mhi_cntrl, MHI_PM_SHUTDOWN_PROCESS);
+
+	mhi_deinit_debugfs(mhi_cntrl);
+
+	if (!mhi_cntrl->pre_init) {
+		/* free all allocated resources */
+		if (mhi_cntrl->fbc_image) {
+			mhi_free_bhie_table(mhi_cntrl, mhi_cntrl->fbc_image);
+			mhi_cntrl->fbc_image = NULL;
+		}
+		mhi_deinit_free_irq(mhi_cntrl);
+		mhi_deinit_dev_ctxt(mhi_cntrl);
+	}
+}
+EXPORT_SYMBOL(mhi_power_down);
+
+int mhi_sync_power_up(struct mhi_controller *mhi_cntrl)
+{
+	int ret = mhi_async_power_up(mhi_cntrl);
+
+	if (ret)
+		return ret;
+
+	wait_event_timeout(mhi_cntrl->state_event,
+			   MHI_IN_MISSION_MODE(mhi_cntrl->ee) ||
+			   MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state),
+			   msecs_to_jiffies(mhi_cntrl->timeout_ms));
+
+	return (MHI_IN_MISSION_MODE(mhi_cntrl->ee)) ? 0 : -EIO;
+}
+EXPORT_SYMBOL(mhi_sync_power_up);
+
+int mhi_pm_suspend(struct mhi_controller *mhi_cntrl)
+{
+	int ret;
+	enum MHI_PM_STATE new_state;
+	struct mhi_chan *itr, *tmp;
+
+	if (mhi_cntrl->pm_state == MHI_PM_DISABLE)
+		return -EINVAL;
+
+	if (MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state))
+		return -EIO;
+
+	/* do a quick check to see if any pending data, then exit */
+	if (atomic_read(&mhi_cntrl->dev_wake)) {
+		MHI_VERB("Busy, aborting M3\n");
+		return -EBUSY;
+	}
+
+	/* exit MHI out of M2 state */
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	mhi_cntrl->wake_get(mhi_cntrl, false);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	ret = wait_event_timeout(mhi_cntrl->state_event,
+				 mhi_cntrl->dev_state == MHI_STATE_M0 ||
+				 mhi_cntrl->dev_state == MHI_STATE_M1 ||
+				 MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state),
+				 msecs_to_jiffies(mhi_cntrl->timeout_ms));
+
+	if (!ret || MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state)) {
+		MHI_ERR
+		    ("Did not enter M0||M1 state, cur_state:%s pm_state:%s\n",
+		     TO_MHI_STATE_STR(mhi_cntrl->dev_state),
+		     to_mhi_pm_state_str(mhi_cntrl->pm_state));
+		ret = -EIO;
+		goto error_m0_entry;
+	}
+
+	write_lock_irq(&mhi_cntrl->pm_lock);
+
+	/* we're asserting wake so count would be @ least 1 */
+	if (atomic_read(&mhi_cntrl->dev_wake) > 1) {
+		MHI_VERB("Busy, aborting M3\n");
+		write_unlock_irq(&mhi_cntrl->pm_lock);
+		ret = -EBUSY;
+		goto error_m0_entry;
+	}
+
+	/* anytime after this, we will resume thru runtime pm framework */
+	MHI_LOG("Allowing M3 transition\n");
+	new_state = mhi_tryset_pm_state(mhi_cntrl, MHI_PM_M3_ENTER);
+	if (new_state != MHI_PM_M3_ENTER) {
+		write_unlock_irq(&mhi_cntrl->pm_lock);
+		MHI_ERR("Error setting to pm_state:%s from pm_state:%s\n",
+			to_mhi_pm_state_str(MHI_PM_M3_ENTER),
+			to_mhi_pm_state_str(mhi_cntrl->pm_state));
+
+		ret = -EIO;
+		goto error_m0_entry;
+	}
+
+	/* set dev to M3 and wait for completion */
+	mhi_set_mhi_state(mhi_cntrl, MHI_STATE_M3);
+	mhi_cntrl->wake_put(mhi_cntrl, false);
+	write_unlock_irq(&mhi_cntrl->pm_lock);
+	MHI_LOG("Wait for M3 completion\n");
+
+	ret = wait_event_timeout(mhi_cntrl->state_event,
+				 mhi_cntrl->dev_state == MHI_STATE_M3 ||
+				 MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state),
+				 msecs_to_jiffies(mhi_cntrl->timeout_ms));
+
+	if (!ret || MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state)) {
+		MHI_ERR("Did not enter M3 state, cur_state:%s pm_state:%s\n",
+			TO_MHI_STATE_STR(mhi_cntrl->dev_state),
+			to_mhi_pm_state_str(mhi_cntrl->pm_state));
+		return -EIO;
+	}
+
+	/* notify any clients we enter lpm */
+	list_for_each_entry_safe(itr, tmp, &mhi_cntrl->lpm_chans, node) {
+		mutex_lock(&itr->mutex);
+		if (itr->mhi_dev)
+			mhi_notify(itr->mhi_dev, MHI_CB_LPM_ENTER);
+		mutex_unlock(&itr->mutex);
+	}
+
+	return 0;
+
+error_m0_entry:
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	mhi_cntrl->wake_put(mhi_cntrl, false);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(mhi_pm_suspend);
+
+int mhi_pm_resume(struct mhi_controller *mhi_cntrl)
+{
+	enum MHI_PM_STATE cur_state;
+	int ret;
+	struct mhi_chan *itr, *tmp;
+
+	MHI_LOG("Entered with pm_state:%s dev_state:%s\n",
+		to_mhi_pm_state_str(mhi_cntrl->pm_state),
+		TO_MHI_STATE_STR(mhi_cntrl->dev_state));
+
+	if (mhi_cntrl->pm_state == MHI_PM_DISABLE)
+		return 0;
+
+	if (MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state))
+		return -EIO;
+
+	MHI_ASSERT(mhi_cntrl->pm_state != MHI_PM_M3, "mhi_pm_state != M3");
+
+	/* notify any clients we enter lpm */
+	list_for_each_entry_safe(itr, tmp, &mhi_cntrl->lpm_chans, node) {
+		mutex_lock(&itr->mutex);
+		if (itr->mhi_dev)
+			mhi_notify(itr->mhi_dev, MHI_CB_LPM_EXIT);
+		mutex_unlock(&itr->mutex);
+	}
+
+	write_lock_irq(&mhi_cntrl->pm_lock);
+	cur_state = mhi_tryset_pm_state(mhi_cntrl, MHI_PM_M3_EXIT);
+	if (cur_state != MHI_PM_M3_EXIT) {
+		write_unlock_irq(&mhi_cntrl->pm_lock);
+		MHI_ERR("Error setting to pm_state:%s from pm_state:%s\n",
+			to_mhi_pm_state_str(MHI_PM_M3_EXIT),
+			to_mhi_pm_state_str(mhi_cntrl->pm_state));
+		return -EIO;
+	}
+
+	/* set dev to M0 and wait for completion */
+	mhi_cntrl->wake_get(mhi_cntrl, true);
+	mhi_set_mhi_state(mhi_cntrl, MHI_STATE_M0);
+	write_unlock_irq(&mhi_cntrl->pm_lock);
+
+	ret = wait_event_timeout(mhi_cntrl->state_event,
+				 mhi_cntrl->dev_state == MHI_STATE_M0 ||
+				 MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state),
+				 msecs_to_jiffies(mhi_cntrl->timeout_ms));
+
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	mhi_cntrl->wake_put(mhi_cntrl, false);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	if (!ret || MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state)) {
+		MHI_ERR("Did not enter M0 state, cur_state:%s pm_state:%s\n",
+			TO_MHI_STATE_STR(mhi_cntrl->dev_state),
+			to_mhi_pm_state_str(mhi_cntrl->pm_state));
+
+		/*
+		 * It's possible device already in error state and we didn't
+		 * process it due to low power mode, force a check
+		 */
+		mhi_intvec_threaded_handlr(0, mhi_cntrl);
+		return -EIO;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(mhi_pm_resume);
+
+int __mhi_device_get_sync(struct mhi_controller *mhi_cntrl)
+{
+	int ret;
+
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	mhi_cntrl->wake_get(mhi_cntrl, true);
+	if (MHI_PM_IN_SUSPEND_STATE(mhi_cntrl->pm_state)) {
+		mhi_cntrl->runtime_get(mhi_cntrl, mhi_cntrl->priv_data);
+		mhi_cntrl->runtime_put(mhi_cntrl, mhi_cntrl->priv_data);
+	}
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+
+	ret = wait_event_timeout(mhi_cntrl->state_event,
+				 mhi_cntrl->pm_state == MHI_PM_M0 ||
+				 MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state),
+				 msecs_to_jiffies(mhi_cntrl->timeout_ms));
+
+	if (!ret || MHI_PM_IN_ERROR_STATE(mhi_cntrl->pm_state)) {
+		MHI_ERR("Did not enter M0 state, cur_state:%s pm_state:%s\n",
+			TO_MHI_STATE_STR(mhi_cntrl->dev_state),
+			to_mhi_pm_state_str(mhi_cntrl->pm_state));
+		read_lock_bh(&mhi_cntrl->pm_lock);
+		mhi_cntrl->wake_put(mhi_cntrl, false);
+		read_unlock_bh(&mhi_cntrl->pm_lock);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+void mhi_device_get(struct mhi_device *mhi_dev)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+
+	atomic_inc(&mhi_dev->dev_wake);
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	mhi_cntrl->wake_get(mhi_cntrl, true);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+}
+EXPORT_SYMBOL(mhi_device_get);
+
+int mhi_device_get_sync(struct mhi_device *mhi_dev)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+	int ret;
+
+	ret = __mhi_device_get_sync(mhi_cntrl);
+	if (!ret)
+		atomic_inc(&mhi_dev->dev_wake);
+
+	return ret;
+}
+EXPORT_SYMBOL(mhi_device_get_sync);
+
+void mhi_device_put(struct mhi_device *mhi_dev)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+
+	atomic_dec(&mhi_dev->dev_wake);
+	read_lock_bh(&mhi_cntrl->pm_lock);
+	mhi_cntrl->wake_put(mhi_cntrl, false);
+	read_unlock_bh(&mhi_cntrl->pm_lock);
+}
+EXPORT_SYMBOL(mhi_device_put);
+
+int mhi_force_rddm_mode(struct mhi_controller *mhi_cntrl)
+{
+	int ret;
+
+	MHI_LOG("Enter with pm_state:%s ee:%s\n",
+		to_mhi_pm_state_str(mhi_cntrl->pm_state),
+		TO_MHI_EXEC_STR(mhi_cntrl->ee));
+
+	MHI_LOG("Triggering SYS_ERR to force rddm state\n");
+	mhi_set_mhi_state(mhi_cntrl, MHI_STATE_SYS_ERR);
+
+	/* wait for rddm event */
+	MHI_LOG("Waiting for device to enter RDDM state\n");
+	ret = wait_event_timeout(mhi_cntrl->state_event,
+				 mhi_cntrl->ee == MHI_EE_RDDM,
+				 msecs_to_jiffies(mhi_cntrl->timeout_ms));
+	ret = ret ? 0 : -EIO;
+
+	MHI_LOG("Exiting with pm_state:%s ee:%s ret:%d\n",
+		to_mhi_pm_state_str(mhi_cntrl->pm_state),
+		TO_MHI_EXEC_STR(mhi_cntrl->ee), ret);
+
+	return ret;
+}
+EXPORT_SYMBOL(mhi_force_rddm_mode);
diff --git a/drivers/bus/mhi/devices/Kconfig b/drivers/bus/mhi/devices/Kconfig
new file mode 100644
index 000000000000..c95d950a6a15
--- /dev/null
+++ b/drivers/bus/mhi/devices/Kconfig
@@ -0,0 +1,43 @@
+menu "MHI device support"
+
+config MHI_NETDEV
+	tristate "MHI NETDEV"
+	depends on MHI_BUS
+	help
+	  MHI based net device driver for transferring IP traffic
+	  between host and modem. By enabling this driver, clients
+	  can transfer data using standard network interface. Over
+	  the air traffic goes thru mhi netdev interface.
+
+config MHI_UCI
+	tristate "MHI UCI"
+	depends on MHI_BUS
+	help
+	  MHI based uci driver is for transferring data between host and
+	  modem using standard file operations from user space. Open, read,
+	  write, ioctl, and close operations are supported by this driver.
+	  Please check mhi_uci_match_table for all supported channels that
+	  are exposed to userspace.
+
+config MHI_MBIM
+	bool "MHI MBIM"
+	default y
+	depends on MHI_UCI && MHI_NETDEV
+	help
+	  This driver provides support for MHI MBIM (Mobile Broadband
+	  Interface Model) devices.
+	  T99W175 can not support MBIM/RmNet on the same time, choose Y
+	  here for MBIM, N for RmNet.
+
+config MHI_SATELLITE
+	tristate "MHI SATELLITE"
+	depends on MHI_BUS
+	help
+	  MHI proxy satellite device driver enables NON-HLOS MHI satellite
+	  drivers to communicate with device over PCIe link without host
+	  involvement. Host facilitates propagation of events from device
+	  to NON-HLOS MHI satellite drivers, channel states, and power
+	  management over IPC communication. It helps in HLOS power
+	  savings.
+
+endmenu
diff --git a/drivers/bus/mhi/devices/Makefile b/drivers/bus/mhi/devices/Makefile
new file mode 100644
index 000000000000..e720069fd033
--- /dev/null
+++ b/drivers/bus/mhi/devices/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_MHI_NETDEV) +=mhi_netdev.o
+obj-$(CONFIG_MHI_UCI) +=mhi_uci.o
+obj-$(CONFIG_MHI_SATELLITE) +=mhi_satellite.o
diff --git a/drivers/bus/mhi/devices/mhi_netdev.c b/drivers/bus/mhi/devices/mhi_netdev.c
new file mode 100644
index 000000000000..b61b73bb6fe0
--- /dev/null
+++ b/drivers/bus/mhi/devices/mhi_netdev.c
@@ -0,0 +1,1830 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.*/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/if_arp.h>
+#include <linux/dma-mapping.h>
+#include <linux/debugfs.h>
+#include <linux/ipc_logging.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/of_device.h>
+#include <linux/rtnetlink.h>
+#include <linux/mhi.h>
+#include <linux/atomic.h>
+#include <linux/mii.h>
+#include <linux/usb.h>
+#include <linux/usb/cdc.h>
+#include <linux/usb/usbnet.h>
+#include <linux/usb/cdc_ncm.h>
+#include <linux/if_vlan.h>
+#include <linux/spinlock.h>
+#include <linux/rculist.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#ifndef CONFIG_MHI_MBIM
+#include <linux/msm_rmnet.h>
+#endif
+
+#define MHI_NETDEV_DRIVER_NAME "mhi_netdev"
+#define WATCHDOG_TIMEOUT (30 * HZ)
+#define IPC_LOG_PAGES (100)
+#define MAX_NETBUF_SIZE (128)
+
+#define CDC_NCM_LOW_MEM_MAX_CNT 10
+
+#ifdef CONFIG_MHI_DEBUG
+
+#define IPC_LOG_LVL (MHI_MSG_LVL_VERBOSE)
+
+#define MHI_ASSERT(cond, msg) do { \
+	if (cond) \
+		panic(msg); \
+} while (0)
+
+#define MSG_VERB(fmt, ...) do { \
+	if (mhi_netdev->msg_lvl <= MHI_MSG_LVL_VERBOSE) \
+		pr_err("[D][%s] " fmt, __func__, ##__VA_ARGS__);\
+	if (mhi_netdev->ipc_log && (mhi_netdev->ipc_log_lvl <= \
+				    MHI_MSG_LVL_VERBOSE)) \
+		ipc_log_string(mhi_netdev->ipc_log, "[D][%s] " fmt, \
+			       __func__, ##__VA_ARGS__); \
+} while (0)
+
+#else
+
+#define IPC_LOG_LVL (MHI_MSG_LVL_ERROR)
+
+#define MHI_ASSERT(cond, msg) do { \
+	if (cond) { \
+		MSG_ERR(msg); \
+		WARN_ON(cond); \
+	} \
+} while (0)
+
+#define MSG_VERB(fmt, ...)
+
+#endif
+
+#define MSG_LOG(fmt, ...) do { \
+	if (mhi_netdev->msg_lvl <= MHI_MSG_LVL_INFO) \
+		pr_err("[I][%s] " fmt, __func__, ##__VA_ARGS__);\
+	if (mhi_netdev->ipc_log && (mhi_netdev->ipc_log_lvl <= \
+				    MHI_MSG_LVL_INFO)) \
+		ipc_log_string(mhi_netdev->ipc_log, "[I][%s] " fmt, \
+			       __func__, ##__VA_ARGS__); \
+} while (0)
+
+#define MSG_ERR(fmt, ...) do { \
+	if (mhi_netdev->msg_lvl <= MHI_MSG_LVL_ERROR) \
+		pr_err("[E][%s] " fmt, __func__, ##__VA_ARGS__); \
+	if (mhi_netdev->ipc_log && (mhi_netdev->ipc_log_lvl <= \
+				    MHI_MSG_LVL_ERROR)) \
+		ipc_log_string(mhi_netdev->ipc_log, "[E][%s] " fmt, \
+			       __func__, ##__VA_ARGS__); \
+} while (0)
+
+struct mhi_net_chain {
+	struct sk_buff *head, *tail;	/* chained skb */
+};
+
+struct mhi_netdev {
+	int alias;
+	struct mhi_device *mhi_dev;
+	struct mhi_netdev *rsc_dev;	/* rsc linked node */
+	bool is_rsc_dev;
+	int wake;
+
+	u32 mru;
+	u32 order;
+	const char *interface_name;
+	struct napi_struct *napi;
+	struct net_device *ndev;
+	bool ethernet_interface;
+
+	struct mhi_netbuf **netbuf_pool;
+	int pool_size;		/* must be power of 2 */
+	int current_index;
+	bool chain_skb;
+	struct mhi_net_chain *chain;
+
+	struct dentry *dentry;
+	enum MHI_DEBUG_LEVEL msg_lvl;
+	enum MHI_DEBUG_LEVEL ipc_log_lvl;
+	void *ipc_log;
+	unsigned long data[5];
+};
+
+struct mhi_netdev_priv {
+	struct mhi_netdev *mhi_netdev;
+};
+
+/* Try not to make this structure bigger than 128 bytes, since this take space
+ * in payload packet.
+ * Example: If MRU = 16K, effective MRU = 16K - sizeof(mhi_netbuf)
+ */
+struct mhi_netbuf {
+	struct mhi_buf mhi_buf; /* this must be first element */
+	void (*unmap)(struct device *dev, dma_addr_t addr, size_t size,
+		      enum dma_data_direction dir);
+};
+
+#ifndef CONFIG_OF
+struct mhi_netdev_init {
+	const char chan[MHI_NAME_SIZE];
+	u32 mru;
+	bool no_chain;
+	int alias;
+	const char *interface_name;
+	bool ethernet_interface;
+};
+
+struct mhi_netdev_init mhi_netdev_init_array[] = {
+#ifdef CONFIG_MHI_MBIM
+	{ "IP_HW0", 0x8000, 0, 0, "mbim_mhi", 0 },
+#else
+	{ "IP_SW0", 0x4000, 1, 0, "rmnet_mhi_sw", 0 },
+	{ "IP_HW0", 0x4000, 0, 0, "rmnet_mhi", 0 },
+#endif
+};
+#endif
+
+#define MBIM_SKB_HEADROOM 64
+
+/* alternative VLAN for IP session 0 if not untagged */
+#define MBIM_IPS0_VID	4094
+
+static struct mhi_driver mhi_netdev_driver;
+static void mhi_netdev_create_debugfs(struct mhi_netdev *mhi_netdev);
+
+static int mhi_netdev_xmit(struct sk_buff *skb, struct net_device *dev);
+
+#ifndef CONFIG_MHI_MBIM
+static __be16 mhi_netdev_ip_type_trans(u8 data)
+{
+	__be16 protocol = 0;
+
+	/* determine L3 protocol */
+	switch (data & 0xf0) {
+	case 0x40:
+		protocol = htons(ETH_P_IP);
+		break;
+	case 0x60:
+		protocol = htons(ETH_P_IPV6);
+		break;
+	default:
+		/* default is QMAP */
+		protocol = htons(ETH_P_MAP);
+		break;
+	}
+	return protocol;
+}
+#endif
+
+static struct mhi_netbuf *mhi_netdev_alloc(struct device *dev,
+					   gfp_t gfp, unsigned int order)
+{
+	struct page *page;
+	struct mhi_netbuf *netbuf;
+	struct mhi_buf *mhi_buf;
+	void *vaddr;
+
+	page = __dev_alloc_pages(gfp, order);
+	if (!page)
+		return NULL;
+
+	vaddr = page_address(page);
+
+	/* we going to use the end of page to store cached data */
+	netbuf = vaddr + (PAGE_SIZE << order) - sizeof(*netbuf);
+
+	mhi_buf = (struct mhi_buf *)netbuf;
+	mhi_buf->page = page;
+	mhi_buf->buf = vaddr;
+	mhi_buf->len = (void *)netbuf - vaddr;
+	mhi_buf->dma_addr = dma_map_page(dev, page, 0, mhi_buf->len,
+					 DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, mhi_buf->dma_addr)) {
+		__free_pages(mhi_buf->page, order);
+		return NULL;
+	}
+
+	return netbuf;
+}
+
+static void mhi_netdev_unmap_page(struct device *dev,
+				  dma_addr_t dma_addr,
+				  size_t len, enum dma_data_direction dir)
+{
+	dma_unmap_page(dev, dma_addr, len, dir);
+}
+
+static int mhi_netdev_tmp_alloc(struct mhi_netdev *mhi_netdev, int nr_tre)
+{
+	struct mhi_device *mhi_dev = mhi_netdev->mhi_dev;
+	struct device *dev = mhi_dev->dev.parent;
+	const u32 order = mhi_netdev->order;
+	int i, ret;
+
+	for (i = 0; i < nr_tre; i++) {
+		struct mhi_buf *mhi_buf;
+		struct mhi_netbuf *netbuf = mhi_netdev_alloc(dev, GFP_ATOMIC,
+							     order);
+		if (!netbuf)
+			return -ENOMEM;
+
+		mhi_buf = (struct mhi_buf *)netbuf;
+		netbuf->unmap = mhi_netdev_unmap_page;
+
+		ret = mhi_queue_transfer(mhi_dev, DMA_FROM_DEVICE, mhi_buf,
+					 mhi_buf->len, MHI_EOT);
+		if (unlikely(ret)) {
+			MSG_ERR("Failed to queue transfer, ret:%d\n", ret);
+			mhi_netdev_unmap_page(dev, mhi_buf->dma_addr,
+					      mhi_buf->len, DMA_FROM_DEVICE);
+			__free_pages(mhi_buf->page, order);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void mhi_netdev_queue(struct mhi_netdev *mhi_netdev)
+{
+	struct mhi_device *mhi_dev = mhi_netdev->mhi_dev;
+	struct device *dev = mhi_dev->dev.parent;
+	struct mhi_netbuf *netbuf;
+	struct mhi_buf *mhi_buf;
+	struct mhi_netbuf **netbuf_pool = mhi_netdev->netbuf_pool;
+	int nr_tre = mhi_get_no_free_descriptors(mhi_dev, DMA_FROM_DEVICE);
+	int i, peak, cur_index, ret;
+	const int pool_size = mhi_netdev->pool_size - 1, max_peak = 4;
+
+	MSG_VERB("Enter free_desc:%d\n", nr_tre);
+
+	if (!nr_tre)
+		return;
+
+	/* try going thru reclaim pool first */
+	for (i = 0; i < nr_tre; i++) {
+		/* peak for the next buffer, we going to peak several times,
+		 * and we going to give up if buffers are not yet free
+		 */
+		cur_index = mhi_netdev->current_index;
+		netbuf = NULL;
+		for (peak = 0; peak < max_peak; peak++) {
+			struct mhi_netbuf *tmp = netbuf_pool[cur_index];
+
+			mhi_buf = &tmp->mhi_buf;
+
+			cur_index = (cur_index + 1)&pool_size;
+
+			/* page == 1 idle, buffer is free to reclaim */
+			if (atomic_read(&mhi_buf->page->_refcount) == 1) {
+				netbuf = tmp;
+				break;
+			}
+		}
+
+		/* could not find a free buffer */
+		if (!netbuf)
+			break;
+
+		/* increment reference count so when network stack is done
+		 * with buffer, the buffer won't be freed
+		 */
+		atomic_inc(&mhi_buf->page->_refcount);
+		dma_sync_single_for_device(dev, mhi_buf->dma_addr, mhi_buf->len,
+					   DMA_FROM_DEVICE);
+		ret = mhi_queue_transfer(mhi_dev, DMA_FROM_DEVICE, mhi_buf,
+					 mhi_buf->len, MHI_EOT);
+		if (unlikely(ret)) {
+			MSG_ERR("Failed to queue buffer, ret:%d\n", ret);
+			netbuf->unmap(dev, mhi_buf->dma_addr, mhi_buf->len,
+				      DMA_FROM_DEVICE);
+			atomic_dec(&mhi_buf->page->_refcount);
+			return;
+		}
+		mhi_netdev->current_index = cur_index;
+	}
+
+	/* recyling did not work, buffers are still busy allocate temp pkts */
+	if (i < nr_tre)
+		mhi_netdev_tmp_alloc(mhi_netdev, nr_tre - i);
+}
+
+/* allocating pool of memory */
+static int mhi_netdev_alloc_pool(struct mhi_netdev *mhi_netdev)
+{
+	int i;
+	struct mhi_netbuf *netbuf, **netbuf_pool;
+	struct mhi_buf *mhi_buf;
+	const u32 order = mhi_netdev->order;
+	struct device *dev = mhi_netdev->mhi_dev->dev.parent;
+
+	netbuf_pool = kmalloc_array(mhi_netdev->pool_size, sizeof(*netbuf_pool),
+				    GFP_KERNEL);
+	if (!netbuf_pool)
+		return -ENOMEM;
+
+	for (i = 0; i < mhi_netdev->pool_size; i++) {
+		/* allocate paged data */
+		netbuf = mhi_netdev_alloc(dev, GFP_KERNEL, order);
+		if (!netbuf)
+			goto error_alloc_page;
+
+		netbuf->unmap = dma_sync_single_for_cpu;
+		netbuf_pool[i] = netbuf;
+	}
+
+	mhi_netdev->netbuf_pool = netbuf_pool;
+
+	return 0;
+
+error_alloc_page:
+	for (--i; i >= 0; i--) {
+		netbuf = netbuf_pool[i];
+		mhi_buf = &netbuf->mhi_buf;
+		dma_unmap_page(dev, mhi_buf->dma_addr, mhi_buf->len,
+			       DMA_FROM_DEVICE);
+		__free_pages(mhi_buf->page, order);
+	}
+
+	kfree(netbuf_pool);
+
+	return -ENOMEM;
+}
+
+static void mhi_netdev_free_pool(struct mhi_netdev *mhi_netdev)
+{
+	int i;
+	struct mhi_netbuf *netbuf, **netbuf_pool = mhi_netdev->netbuf_pool;
+	struct device *dev = mhi_netdev->mhi_dev->dev.parent;
+	struct mhi_buf *mhi_buf;
+
+	for (i = 0; i < mhi_netdev->pool_size; i++) {
+		netbuf = netbuf_pool[i];
+		mhi_buf = &netbuf->mhi_buf;
+		dma_unmap_page(dev, mhi_buf->dma_addr, mhi_buf->len,
+			       DMA_FROM_DEVICE);
+		__free_pages(mhi_buf->page, mhi_netdev->order);
+	}
+
+	kfree(mhi_netdev->netbuf_pool);
+	mhi_netdev->netbuf_pool = NULL;
+}
+
+#ifdef CONFIG_MHI_MBIM
+/* verify NTB header and return offset of first NDP, or negative error */
+static int cdc_ncm_mhi_rx_verify_nth16(struct cdc_ncm_ctx *ctx,
+				       struct sk_buff *skb_in)
+{
+	struct usb_cdc_ncm_nth16 *nth16;
+	int len;
+	int ret = -EINVAL;
+
+	if (ctx == NULL)
+		goto error;
+
+	if (skb_in->len < (sizeof(struct usb_cdc_ncm_nth16) +
+			   sizeof(struct usb_cdc_ncm_ndp16))) {
+		pr_err("frame too short\n");
+		goto error;
+	}
+
+	nth16 = (struct usb_cdc_ncm_nth16 *)skb_in->data;
+
+	if (nth16->dwSignature != cpu_to_le32(USB_CDC_NCM_NTH16_SIGN)) {
+		pr_err("invalid NTH16 signature <%#010x>\n",
+		       le32_to_cpu(nth16->dwSignature));
+		goto error;
+	}
+
+	len = le16_to_cpu(nth16->wBlockLength);
+	if (len > ctx->rx_max) {
+		pr_err("unsupported NTB block length %u/%u\n", len,
+		       ctx->rx_max);
+		goto error;
+	}
+
+	if ((ctx->rx_seq + 1) != le16_to_cpu(nth16->wSequence) &&
+	    (ctx->rx_seq || le16_to_cpu(nth16->wSequence)) &&
+	    !((ctx->rx_seq == 0xffff) && !le16_to_cpu(nth16->wSequence))) {
+		pr_err("sequence number glitch prev=%d curr=%d\n",
+		       ctx->rx_seq, le16_to_cpu(nth16->wSequence));
+	}
+	ctx->rx_seq = le16_to_cpu(nth16->wSequence);
+
+	ret = le16_to_cpu(nth16->wNdpIndex);
+error:
+	return ret;
+}
+
+/* verify NDP header and return number of datagrams, or negative error */
+static int cdc_ncm_mhi_rx_verify_ndp16(struct sk_buff *skb_in, int ndpoffset)
+{
+	struct usb_cdc_ncm_ndp16 *ndp16;
+	int ret = -EINVAL;
+
+	if ((ndpoffset + sizeof(struct usb_cdc_ncm_ndp16)) > skb_in->len) {
+		pr_err("invalid NDP offset  <%u>\n", ndpoffset);
+		goto error;
+	}
+	ndp16 = (struct usb_cdc_ncm_ndp16 *)(skb_in->data + ndpoffset);
+
+	if (le16_to_cpu(ndp16->wLength) < USB_CDC_NCM_NDP16_LENGTH_MIN) {
+		pr_err("invalid DPT16 length <%u>\n",
+		       le16_to_cpu(ndp16->wLength));
+		goto error;
+	}
+
+	ret = ((le16_to_cpu(ndp16->wLength) -
+		sizeof(struct usb_cdc_ncm_ndp16)) /
+	       sizeof(struct usb_cdc_ncm_dpe16));
+	ret--;  /* we process NDP entries except for the last one */
+
+	if ((sizeof(struct usb_cdc_ncm_ndp16) +
+	     ret * (sizeof(struct usb_cdc_ncm_dpe16))) > skb_in->len) {
+		pr_err("Invalid nframes = %d\n", ret);
+		ret = -EINVAL;
+	}
+
+error:
+	return ret;
+}
+
+static struct sk_buff *cdc_mbim_mhi_process_dgram(struct mhi_netdev *dev,
+					u8 *buf, size_t len, u16 tci)
+{
+	__be16 proto = htons(ETH_P_802_3);
+	struct sk_buff *skb = NULL;
+
+	if (tci < 256 || tci == MBIM_IPS0_VID) {	/* IPS session? */
+		if (len < sizeof(struct iphdr))
+			goto err;
+
+		switch (*buf & 0xf0) {
+		case 0x40:
+			proto = htons(ETH_P_IP);
+			break;
+		case 0x60:
+			/*
+			 * if (is_neigh_solicit(buf, len))
+			 *      do_neigh_solicit(dev, buf, tci);
+			 */
+			proto = htons(ETH_P_IPV6);
+			break;
+		default:
+			goto err;
+		}
+	}
+
+	skb = netdev_alloc_skb_ip_align(dev->ndev, len + ETH_HLEN);
+	if (!skb)
+		goto err;
+
+	/* add an ethernet header */
+	skb_put(skb, ETH_HLEN);
+	skb_reset_mac_header(skb);
+	eth_hdr(skb)->h_proto = proto;
+	eth_zero_addr(eth_hdr(skb)->h_source);
+	memcpy(eth_hdr(skb)->h_dest, dev->ndev->dev_addr, ETH_ALEN);
+
+	/* add datagram */
+	skb_put_data(skb, buf, len);
+
+	/* map MBIM session to VLAN */
+	if (tci)
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), tci);
+err:
+	return skb;
+}
+
+static int cdc_ncm_mhi_rx_fixup(struct mhi_netdev *dev, struct sk_buff *skb_in)
+{
+	struct sk_buff *skb;
+	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
+	int len;
+	int nframes;
+	int x;
+	int offset;
+	struct usb_cdc_ncm_ndp16 *ndp16;
+	struct usb_cdc_ncm_dpe16 *dpe16;
+	int ndpoffset;
+	int loopcount = 50;	/* arbitrary max preventing infinite loop */
+	u32 payload = 0;
+	u8 *c;
+	u16 tci;
+
+	ndpoffset = cdc_ncm_mhi_rx_verify_nth16(ctx, skb_in);
+	if (ndpoffset < 0)
+		goto error;
+
+next_ndp:
+	nframes = cdc_ncm_mhi_rx_verify_ndp16(skb_in, ndpoffset);
+	if (nframes < 0)
+		goto error;
+
+	ndp16 = (struct usb_cdc_ncm_ndp16 *)(skb_in->data + ndpoffset);
+
+	switch (ndp16->dwSignature & cpu_to_le32(0x00ffffff)) {
+	case cpu_to_le32(USB_CDC_MBIM_NDP16_IPS_SIGN):
+		c = (u8 *)&ndp16->dwSignature;
+		tci = c[3];
+		/* tag IPS<0> packets too if MBIM_IPS0_VID exists */
+		/*
+		 * if (!tci && info->flags & FLAG_IPS0_VLAN)
+		 *      tci = MBIM_IPS0_VID;
+		 */
+		break;
+	case cpu_to_le32(USB_CDC_MBIM_NDP16_DSS_SIGN):
+		c = (u8 *)&ndp16->dwSignature;
+		tci = c[3] + 256;
+		break;
+	default:
+		pr_err("unsupported NDP signature <0x%08x>\n",
+		       le32_to_cpu(ndp16->dwSignature));
+		goto err_ndp;
+
+	}
+
+	dpe16 = ndp16->dpe16;
+	for (x = 0; x < nframes; x++, dpe16++) {
+		offset = le16_to_cpu(dpe16->wDatagramIndex);
+		len = le16_to_cpu(dpe16->wDatagramLength);
+		/*
+		 * CDC NCM ch. 3.7
+		 * All entries after first NULL entry are to be ignored
+		 */
+		if ((offset == 0) || (len == 0)) {
+			if (!x)
+				goto err_ndp;	/* empty NTB */
+			break;
+		}
+
+		/* sanity checking */
+		if (((offset + len) > skb_in->len) || (len > ctx->rx_max)) {
+			pr_err("Invalid frame detected(ignored)\n");
+			pr_err("  Offset[%u]=%u, length=%u, skb=%p\n",
+					x, offset, len, skb_in);
+			if (!x)
+				goto err_ndp;
+			break;
+		}
+
+		skb = cdc_mbim_mhi_process_dgram(dev, skb_in->data + offset,
+					       len, tci);
+		if (!skb)
+			goto error;
+
+		if (skb->protocol == 0)
+			skb->protocol = eth_type_trans(skb, dev->ndev);
+
+		memset(skb->cb, 0, sizeof(struct skb_data));
+
+		netif_rx(skb);
+
+		payload += len; /* count payload bytes in this NTB */
+	}
+
+err_ndp:
+	/* are there more NDPs to process? */
+	ndpoffset = le16_to_cpu(ndp16->wNextNdpIndex);
+	if (ndpoffset && loopcount--)
+		goto next_ndp;
+
+	/* update stats */
+	ctx->rx_overhead += skb_in->len - payload;
+	ctx->rx_ntbs++;
+	return 1;
+error:
+	return 0;
+}
+#endif /* CONFIG_MHI_MBIM */
+
+static int mhi_netdev_poll(struct napi_struct *napi, int budget)
+{
+	struct net_device *dev = napi->dev;
+	struct mhi_netdev_priv *mhi_netdev_priv = netdev_priv(dev);
+	struct mhi_netdev *mhi_netdev = mhi_netdev_priv->mhi_netdev;
+	struct mhi_device *mhi_dev = mhi_netdev->mhi_dev;
+	struct mhi_netdev *rsc_dev = mhi_netdev->rsc_dev;
+#ifndef CONFIG_MHI_MBIM
+	struct mhi_net_chain *chain = mhi_netdev->chain;
+#endif
+	int rx_work = 0;
+
+	MSG_VERB("Entered\n");
+
+	rx_work = mhi_poll(mhi_dev, budget);
+
+#ifndef CONFIG_MHI_MBIM
+	/* chained skb, push it to stack */
+	if (chain && chain->head) {
+		netif_receive_skb(chain->head);
+		chain->head = NULL;
+	}
+#endif
+
+	if (rx_work < 0) {
+		MSG_ERR("Error polling ret:%d\n", rx_work);
+		napi_complete(napi);
+		return 0;
+	}
+
+	/* queue new buffers */
+	mhi_netdev_queue(mhi_netdev);
+
+	if (rsc_dev)
+		mhi_netdev_queue(rsc_dev);
+
+	/* complete work if # of packet processed less than allocated budget */
+	if (rx_work < budget)
+		napi_complete(napi);
+
+	MSG_VERB("polled %d pkts\n", rx_work);
+
+	return rx_work;
+}
+
+static int mhi_netdev_open(struct net_device *dev)
+{
+	struct mhi_netdev_priv *mhi_netdev_priv = netdev_priv(dev);
+	struct mhi_netdev *mhi_netdev = mhi_netdev_priv->mhi_netdev;
+	struct mhi_device *mhi_dev = mhi_netdev->mhi_dev;
+
+	MSG_LOG("Opened net dev interface\n");
+
+	/* tx queue may not necessarily be stopped already
+	 * so stop the queue if tx path is not enabled
+	 */
+	if (!mhi_dev->ul_chan)
+		netif_stop_queue(dev);
+	else
+		netif_start_queue(dev);
+
+	return 0;
+
+}
+
+static int mhi_netdev_change_mtu(struct net_device *dev, int new_mtu)
+{
+	struct mhi_netdev_priv *mhi_netdev_priv = netdev_priv(dev);
+	struct mhi_netdev *mhi_netdev = mhi_netdev_priv->mhi_netdev;
+	struct mhi_device *mhi_dev = mhi_netdev->mhi_dev;
+
+	if (new_mtu < 0 || mhi_dev->mtu < new_mtu)
+		return -EINVAL;
+
+	dev->mtu = new_mtu;
+	return 0;
+}
+
+#ifdef CONFIG_MHI_MBIM
+static void cdc_ncm_align_tail(struct sk_buff *skb, size_t modulus,
+			       size_t remainder, size_t max)
+{
+	size_t align = ALIGN(skb->len, modulus) - skb->len + remainder;
+
+	if (skb->len + align > max)
+		align = max - skb->len;
+	if (align && skb_tailroom(skb) >= align)
+		skb_put_zero(skb, align);
+}
+
+/* return a pointer to a valid struct usb_cdc_ncm_ndp16 of type sign,
+ * possibly allocating a new one within skb
+ */
+static struct usb_cdc_ncm_ndp16 *cdc_ncm_ndp(struct cdc_ncm_ctx *ctx,
+					     struct sk_buff *skb, __le32 sign,
+					     size_t reserve)
+{
+	struct usb_cdc_ncm_ndp16 *ndp16 = NULL;
+	struct usb_cdc_ncm_nth16 *nth16 = (void *)skb->data;
+	size_t ndpoffset = le16_to_cpu(nth16->wNdpIndex);
+
+	/* If NDP should be moved to the end of the NCM package,
+	 * we can't follow the NTH16 header as we would normally do.
+	 * NDP isn't written to the SKB yet, and the wNdpIndex field
+	 * in the header is actually not consistent with reality.
+	 * It will be later.
+	 */
+	if (ctx->drvflags & CDC_NCM_FLAG_NDP_TO_END) {
+		if (ctx->delayed_ndp16->dwSignature == sign)
+			return ctx->delayed_ndp16;
+
+		/* We can only push a single NDP to the end. Return
+		 * NULL to send what we've already got and queue this
+		 * skb for later.
+		 */
+		else if (ctx->delayed_ndp16->dwSignature)
+			return NULL;
+	}
+
+	/* follow the chain of NDPs, looking for a match */
+	while (ndpoffset) {
+		ndp16 = (struct usb_cdc_ncm_ndp16 *)(skb->data + ndpoffset);
+		if (ndp16->dwSignature == sign)
+			return ndp16;
+		ndpoffset = le16_to_cpu(ndp16->wNextNdpIndex);
+	}
+
+	/* align new NDP */
+	if (!(ctx->drvflags & CDC_NCM_FLAG_NDP_TO_END))
+		cdc_ncm_align_tail(skb, ctx->tx_ndp_modulus, 0,
+				   ctx->tx_curr_size);
+
+	/* verify that there is room for the NDP and the datagram (reserve) */
+	if ((ctx->tx_curr_size - skb->len - reserve) < ctx->max_ndp_size)
+		return NULL;
+
+	/* link to it */
+	if (ndp16)
+		ndp16->wNextNdpIndex = cpu_to_le16(skb->len);
+	else
+		nth16->wNdpIndex = cpu_to_le16(skb->len);
+
+	/* push a new empty NDP */
+	if (!(ctx->drvflags & CDC_NCM_FLAG_NDP_TO_END))
+		ndp16 = skb_put_zero(skb, ctx->max_ndp_size);
+	else
+		ndp16 = ctx->delayed_ndp16;
+
+	ndp16->dwSignature = sign;
+	ndp16->wLength = cpu_to_le16(sizeof(struct usb_cdc_ncm_ndp16) +
+				sizeof(struct usb_cdc_ncm_dpe16));
+	return ndp16;
+}
+
+static void cdc_ncm_mhi_txpath_bh(unsigned long param)
+{
+	struct mhi_netdev *dev = (struct mhi_netdev *)param;
+	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
+
+	spin_lock_bh(&ctx->mtx);
+	if (dev->ndev != NULL) {
+		spin_unlock_bh(&ctx->mtx);
+		netif_tx_lock_bh(dev->ndev);
+		mhi_netdev_xmit(NULL, dev->ndev);
+		netif_tx_unlock_bh(dev->ndev);
+	} else {
+		spin_unlock_bh(&ctx->mtx);
+	}
+}
+
+struct sk_buff *cdc_ncm_mhi_fill_tx_frame(struct mhi_netdev *dev,
+					  struct sk_buff *skb, __le32 sign)
+{
+	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
+	struct usb_cdc_ncm_nth16 *nth16;
+	struct usb_cdc_ncm_ndp16 *ndp16;
+	struct sk_buff *skb_out;
+	u16 n = 0, index, ndplen;
+	u8 ready2send = 0;
+	u32 delayed_ndp_size;
+	size_t padding_count;
+
+	/* When our NDP gets written in cdc_ncm_ndp(), then skb_out->len
+	 * gets updated accordingly. Otherwise, we should check here.
+	 */
+	delayed_ndp_size = 0;
+
+	/* if there is a remaining skb, it gets priority */
+	if (skb != NULL) {
+		swap(skb, ctx->tx_rem_skb);
+		swap(sign, ctx->tx_rem_sign);
+	} else {
+		ready2send = 1;
+	}
+
+	/* check if we are resuming an OUT skb */
+	skb_out = ctx->tx_curr_skb;
+
+	/* allocate a new OUT skb */
+	if (!skb_out) {
+		if (ctx->tx_low_mem_val == 0) {
+			ctx->tx_curr_size = ctx->tx_max;
+			skb_out = alloc_skb(ctx->tx_curr_size, GFP_ATOMIC);
+			/* If the memory allocation fails we will wait longer
+			 * each time before attempting another full size
+			 * allocation again to not overload the system
+			 * further.
+			 */
+			if (skb_out == NULL) {
+				ctx->tx_low_mem_max_cnt =
+				    min(ctx->tx_low_mem_max_cnt + 1,
+					(unsigned int)CDC_NCM_LOW_MEM_MAX_CNT);
+				ctx->tx_low_mem_val = ctx->tx_low_mem_max_cnt;
+			}
+		}
+		if (skb_out == NULL) {
+			/* See if a very small allocation is possible.
+			 * We will send this packet immediately and hope
+			 * that there is more memory available later.
+			 */
+			if (skb) {
+				ctx->tx_curr_size = max_t(u32, skb->len,
+					USB_CDC_NCM_NTB_MIN_OUT_SIZE);
+			} else {
+				ctx->tx_curr_size =
+				    USB_CDC_NCM_NTB_MIN_OUT_SIZE;
+			}
+			skb_out = alloc_skb(ctx->tx_curr_size, GFP_ATOMIC);
+
+			/* No allocation possible so we will abort */
+			if (skb_out == NULL) {
+				if (skb != NULL) {
+					dev_kfree_skb_any(skb);
+					skb = NULL;
+				}
+				dev->ndev->stats.tx_dropped++;
+				goto exit_no_skb;
+			}
+			ctx->tx_low_mem_val--;
+		}
+		/* fill out the initial 16-bit NTB header */
+		nth16 = skb_put_zero(skb_out,
+				sizeof(struct usb_cdc_ncm_nth16));
+		nth16->dwSignature = cpu_to_le32(USB_CDC_NCM_NTH16_SIGN);
+		nth16->wHeaderLength =
+		    cpu_to_le16(sizeof(struct usb_cdc_ncm_nth16));
+		nth16->wSequence = cpu_to_le16(ctx->tx_seq++);
+
+		/* count total number of frames in this NTB */
+		ctx->tx_curr_frame_num = 0;
+
+		/* recent payload counter for this skb_out */
+		ctx->tx_curr_frame_payload = 0;
+	}
+
+	for (n = ctx->tx_curr_frame_num; n < ctx->tx_max_datagrams; n++) {
+		/* send any remaining skb first */
+		if (skb == NULL) {
+			skb = ctx->tx_rem_skb;
+			sign = ctx->tx_rem_sign;
+			ctx->tx_rem_skb = NULL;
+
+			/* check for end of skb */
+			if (skb == NULL)
+				break;
+		}
+
+		/* get the appropriate NDP for this skb */
+		ndp16 = cdc_ncm_ndp(ctx, skb_out, sign,
+			    skb->len + ctx->tx_modulus + ctx->tx_remainder);
+
+		/* align beginning of next frame */
+		cdc_ncm_align_tail(skb_out, ctx->tx_modulus, ctx->tx_remainder,
+			    ctx->tx_curr_size);
+
+		/* check if we had enough room left for both NDP and frame */
+		if (!ndp16 ||
+		    skb_out->len + skb->len + delayed_ndp_size >
+			ctx->tx_curr_size) {
+			if (n == 0) {
+				/* won't fit, MTU problem? */
+				dev_kfree_skb_any(skb);
+				skb = NULL;
+				dev->ndev->stats.tx_dropped++;
+			} else {
+				/* no room for skb - store for later */
+				if (ctx->tx_rem_skb != NULL) {
+					dev_kfree_skb_any(ctx->tx_rem_skb);
+					ctx->tx_rem_skb = NULL;
+					dev->ndev->stats.tx_dropped++;
+				}
+				ctx->tx_rem_skb = skb;
+				ctx->tx_rem_sign = sign;
+				skb = NULL;
+				ready2send = 1;
+				ctx->tx_reason_ntb_full++; /* count reason */
+			}
+			break;
+		}
+
+		/* calculate frame number within this NDP */
+		ndplen = le16_to_cpu(ndp16->wLength);
+		index = (ndplen - sizeof(struct usb_cdc_ncm_ndp16)) /
+				sizeof(struct usb_cdc_ncm_dpe16) - 1;
+
+		/* OK, add this skb */
+		ndp16->dpe16[index].wDatagramLength = cpu_to_le16(skb->len);
+		ndp16->dpe16[index].wDatagramIndex = cpu_to_le16(skb_out->len);
+		ndp16->wLength =
+		    cpu_to_le16(ndplen + sizeof(struct usb_cdc_ncm_dpe16));
+		skb_put_data(skb_out, skb->data, skb->len);
+		/* count real tx payload data */
+		ctx->tx_curr_frame_payload += skb->len;
+		dev_kfree_skb_any(skb);
+		skb = NULL;
+
+		/* send now if this NDP is full */
+		if (index >= CDC_NCM_DPT_DATAGRAMS_MAX) {
+			ready2send = 1;
+			break;
+		}
+	}
+
+	/* free up any dangling skb */
+	if (skb != NULL) {
+		dev_kfree_skb_any(skb);
+		skb = NULL;
+		dev->ndev->stats.tx_dropped++;
+	}
+
+	ctx->tx_curr_frame_num = n;
+
+	if ((n == 0) || ((n < ctx->tx_max_datagrams) && (ready2send == 0))) {
+		/* push variables */
+		ctx->tx_curr_skb = skb_out;
+		goto exit_no_skb;
+	}
+
+	/* If requested, put NDP at end of frame. */
+	if (ctx->drvflags & CDC_NCM_FLAG_NDP_TO_END) {
+		nth16 = (struct usb_cdc_ncm_nth16 *)skb_out->data;
+		cdc_ncm_align_tail(skb_out, ctx->tx_ndp_modulus, 0,
+				   ctx->tx_curr_size - ctx->max_ndp_size);
+		nth16->wNdpIndex = cpu_to_le16(skb_out->len);
+		skb_put_data(skb_out, ctx->delayed_ndp16, ctx->max_ndp_size);
+
+		/* Zero out delayed NDP -
+		 * signature checking will naturally fail.
+		 */
+		ndp16 = memset(ctx->delayed_ndp16, 0, ctx->max_ndp_size);
+	}
+
+	/* If collected data size is less or equal ctx->min_tx_pkt
+	 * bytes, we send buffers as it is. If we get more data, it
+	 * would be more efficient for USB HS mobile device with DMA
+	 * engine to receive a full size NTB, than canceling DMA
+	 * transfer and receiving a short packet.
+	 *
+	 * This optimization support is pointless if we end up sending
+	 * a ZLP after full sized NTBs.
+	 */
+	if (skb_out->len > ctx->min_tx_pkt) {
+		padding_count = ctx->tx_curr_size - skb_out->len;
+		skb_put_zero(skb_out, padding_count);
+	} else if (skb_out->len < ctx->tx_curr_size) {
+		skb_put_u8(skb_out, 0);	/* force short packet */
+	}
+
+	/* set final frame length */
+	nth16 = (struct usb_cdc_ncm_nth16 *)skb_out->data;
+	nth16->wBlockLength = cpu_to_le16(skb_out->len);
+
+	/* return skb */
+	ctx->tx_curr_skb = NULL;
+
+	dev->ndev->stats.tx_packets++;
+	dev->ndev->stats.tx_bytes += ctx->tx_curr_frame_payload;
+
+	return skb_out;
+
+exit_no_skb:
+	/*
+	 * if (ctx->tx_curr_skb != NULL && n > 0) {
+	 *      tasklet_schedule(&ctx->bh);
+	 * }
+	 */
+	return NULL;
+}
+
+static struct sk_buff *cdc_mbim_mhi_tx_fixup(struct mhi_netdev *dev,
+					     struct sk_buff *skb, gfp_t flags)
+{
+	struct sk_buff *skb_out;
+	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
+
+	__le32 sign = cpu_to_le32(USB_CDC_MBIM_NDP16_IPS_SIGN);
+	u16 tci = 0;
+	u8 *c;
+
+	if (!ctx)
+		goto error;
+
+	if (skb) {
+
+		if (skb->len <= ETH_HLEN)
+			goto error;
+
+		/* Some applications using e.g. packet sockets will
+		 * bypass the VLAN acceleration and create tagged
+		 * ethernet frames directly.  We primarily look for
+		 * the accelerated out-of-band tag, but fall back if
+		 * required
+		 */
+		skb_reset_mac_header(skb);
+		if (vlan_get_tag(skb, &tci) < 0 && skb->len > VLAN_ETH_HLEN &&
+		    __vlan_get_tag(skb, &tci) == 0) {
+			skb_pull(skb, VLAN_ETH_HLEN);
+		}
+
+		/* mapping VLANs to MBIM sessions:
+		 *   no tag     => IPS session <0> if !FLAG_IPS0_VLAN
+		 *   1 - 255    => IPS session <vlanid>
+		 *   256 - 511  => DSS session <vlanid - 256>
+		 *   512 - 4093 => unsupported, drop
+		 *   4094       => IPS session <0> if FLAG_IPS0_VLAN
+		 */
+
+		switch (tci & 0x0f00) {
+		case 0x0000:	/* VLAN ID 0 - 255 */
+			c = (u8 *)&sign;
+			c[3] = tci;
+			break;
+		case 0x0100:	/* VLAN ID 256 - 511 */
+			sign = cpu_to_le32(USB_CDC_MBIM_NDP16_DSS_SIGN);
+			c = (u8 *)&sign;
+			c[3] = tci;
+			break;
+		default:
+			pr_err("unsupported tci=0x%04x\n", tci);
+			goto error;
+		}
+	}
+
+	spin_lock_bh(&ctx->mtx);
+	skb_out = cdc_ncm_mhi_fill_tx_frame(dev, skb, sign);
+	spin_unlock_bh(&ctx->mtx);
+
+	return skb_out;
+
+error:
+	if (skb) {
+		dev_kfree_skb_any(skb);
+		skb = NULL;
+	}
+	dev->ndev->stats.tx_dropped++;
+	return NULL;
+}
+
+static void cdc_ncm_mhi_free(struct cdc_ncm_ctx *ctx)
+{
+	if (ctx == NULL)
+		return;
+
+	if (ctx->tx_rem_skb != NULL) {
+		dev_kfree_skb_any(ctx->tx_rem_skb);
+		ctx->tx_rem_skb = NULL;
+	}
+
+	if (ctx->tx_curr_skb != NULL) {
+		dev_kfree_skb_any(ctx->tx_curr_skb);
+		ctx->tx_curr_skb = NULL;
+	}
+	if (ctx->delayed_ndp16 != NULL)
+		kfree(ctx->delayed_ndp16);
+
+	kfree(ctx);
+}
+#endif
+
+static int mhi_netdev_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct mhi_netdev_priv *mhi_netdev_priv = netdev_priv(dev);
+	struct mhi_netdev *mhi_netdev = mhi_netdev_priv->mhi_netdev;
+	struct mhi_device *mhi_dev = mhi_netdev->mhi_dev;
+	int res = 0;
+	int drop_num = mhi_netdev->ndev->stats.tx_dropped;
+	struct sk_buff *skb_in;
+	struct sk_buff *skb_out;
+
+	MSG_VERB("Entered\n");
+
+#ifdef CONFIG_MHI_MBIM
+	skb_in = skb_copy(skb, GFP_ATOMIC);
+	skb_in = cdc_mbim_mhi_tx_fixup(mhi_netdev, skb_in, GFP_ATOMIC);
+	if (mhi_netdev->ndev->stats.tx_dropped > drop_num)
+		goto exit_error;
+
+	if (!skb_in) {
+		skb_out = cdc_mbim_mhi_tx_fixup(mhi_netdev, NULL, GFP_ATOMIC);
+		if (!skb_out)
+			goto exit_error;
+		res = mhi_queue_transfer(mhi_dev, DMA_TO_DEVICE, skb_out,
+				       skb_out->len, MHI_EOT);
+
+		if (!res) {
+			kfree_skb(skb);
+		} else {
+exit_error:
+			MSG_VERB("Failed to queue with reason:%d\n", res);
+			netif_stop_queue(dev);
+			kfree_skb(skb_out);
+			res = NETDEV_TX_BUSY;
+		}
+	}
+
+#else
+
+	res = mhi_queue_transfer(mhi_dev, DMA_TO_DEVICE, skb, skb->len,
+				 MHI_EOT);
+	if (res) {
+		MSG_VERB("Failed to queue with reason:%d\n", res);
+		netif_stop_queue(dev);
+		res = NETDEV_TX_BUSY;
+	}
+#endif
+
+	MSG_VERB("Exited\n");
+
+	return res;
+}
+
+#ifndef CONFIG_MHI_MBIM
+static int mhi_netdev_ioctl_extended(struct net_device *dev, struct ifreq *ifr)
+{
+	struct rmnet_ioctl_extended_s ext_cmd;
+	int rc = 0;
+	struct mhi_netdev_priv *mhi_netdev_priv = netdev_priv(dev);
+	struct mhi_netdev *mhi_netdev = mhi_netdev_priv->mhi_netdev;
+	struct mhi_device *mhi_dev = mhi_netdev->mhi_dev;
+
+	rc = copy_from_user(&ext_cmd, ifr->ifr_ifru.ifru_data,
+			    sizeof(struct rmnet_ioctl_extended_s));
+	if (rc)
+		return rc;
+
+	switch (ext_cmd.extended_ioctl) {
+	case RMNET_IOCTL_GET_SUPPORTED_FEATURES:
+		ext_cmd.u.data = 0;
+		break;
+	case RMNET_IOCTL_GET_DRIVER_NAME:
+		memset(ext_cmd.u.if_name, 0, sizeof(ext_cmd.u.if_name));
+		strncpy(ext_cmd.u.if_name, mhi_netdev->interface_name,
+			sizeof(ext_cmd.u.if_name) - 1);
+		break;
+	case RMNET_IOCTL_SET_SLEEP_STATE:
+		if (ext_cmd.u.data && mhi_netdev->wake) {
+			/* Request to enable LPM */
+			MSG_VERB("Enable MHI LPM");
+			mhi_netdev->wake--;
+			mhi_device_put(mhi_dev);
+		} else if (!ext_cmd.u.data && !mhi_netdev->wake) {
+			/* Request to disable LPM */
+			MSG_VERB("Disable MHI LPM");
+			mhi_netdev->wake++;
+			mhi_device_get(mhi_dev);
+		}
+		break;
+	default:
+		rc = -EINVAL;
+		break;
+	}
+
+	rc = copy_to_user(ifr->ifr_ifru.ifru_data, &ext_cmd,
+			  sizeof(struct rmnet_ioctl_extended_s));
+	return rc;
+}
+
+static int mhi_netdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	int rc = 0;
+	struct rmnet_ioctl_data_s ioctl_data;
+
+	switch (cmd) {
+	case RMNET_IOCTL_SET_LLP_IP:	/* set RAWIP protocol */
+		break;
+	case RMNET_IOCTL_GET_LLP:	/* get link protocol state */
+		ioctl_data.u.operation_mode = RMNET_MODE_LLP_IP;
+		if (copy_to_user(ifr->ifr_ifru.ifru_data, &ioctl_data,
+				 sizeof(struct rmnet_ioctl_data_s)))
+			rc = -EFAULT;
+		break;
+	case RMNET_IOCTL_GET_OPMODE:	/* get operation mode */
+		ioctl_data.u.operation_mode = RMNET_MODE_LLP_IP;
+		if (copy_to_user(ifr->ifr_ifru.ifru_data, &ioctl_data,
+				 sizeof(struct rmnet_ioctl_data_s)))
+			rc = -EFAULT;
+		break;
+	case RMNET_IOCTL_SET_QOS_ENABLE:
+		rc = -EINVAL;
+		break;
+	case RMNET_IOCTL_SET_QOS_DISABLE:
+		rc = 0;
+		break;
+	case RMNET_IOCTL_OPEN:
+	case RMNET_IOCTL_CLOSE:
+		/* we just ignore them and return success */
+		rc = 0;
+		break;
+	case RMNET_IOCTL_EXTENDED:
+		rc = mhi_netdev_ioctl_extended(dev, ifr);
+		break;
+	default:
+		/* don't fail any IOCTL right now */
+		rc = 0;
+		break;
+	}
+
+	return rc;
+}
+#endif
+
+static const struct net_device_ops mhi_netdev_ops_ip = {
+	.ndo_open = mhi_netdev_open,
+	.ndo_start_xmit = mhi_netdev_xmit,
+#ifndef CONFIG_MHI_MBIM
+	.ndo_do_ioctl = mhi_netdev_ioctl,
+#endif
+	.ndo_change_mtu = mhi_netdev_change_mtu,
+	.ndo_set_mac_address = 0,
+	.ndo_validate_addr = 0,
+};
+
+static void mhi_netdev_setup(struct net_device *dev)
+{
+	dev->netdev_ops = &mhi_netdev_ops_ip;
+	ether_setup(dev);
+
+	/* set this after calling ether_setup */
+	dev->header_ops = 0;	/* No header */
+	dev->type = ARPHRD_RAWIP;
+	dev->hard_header_len = 0;
+	dev->addr_len = 0;
+	dev->flags &= ~(IFF_BROADCAST | IFF_MULTICAST);
+	dev->watchdog_timeo = WATCHDOG_TIMEOUT;
+}
+
+/* enable mhi_netdev netdev, call only after grabbing mhi_netdev.mutex */
+#ifdef CONFIG_OF
+static int mhi_netdev_enable_iface(struct mhi_netdev *mhi_netdev)
+#else
+static int mhi_netdev_enable_iface(struct mhi_netdev *mhi_netdev, int index)
+#endif
+{
+	int ret = 0;
+	char ifalias[IFALIASZ];
+	char ifname[IFNAMSIZ];
+	struct mhi_device *mhi_dev = mhi_netdev->mhi_dev;
+	struct mhi_netdev_priv *mhi_netdev_priv;
+#ifdef CONFIG_OF
+	struct device_node *of_node = mhi_dev->dev.of_node;
+
+	mhi_netdev->alias = of_alias_get_id(of_node, "mhi-netdev");
+	if (mhi_netdev->alias < 0)
+		mhi_netdev->alias = 0;
+
+	ret = of_property_read_string(of_node, "mhi,interface-name",
+				      &mhi_netdev->interface_name);
+	if (ret)
+		mhi_netdev->interface_name = mhi_netdev_driver.driver.name;
+
+	snprintf(ifalias, sizeof(ifalias), "%s_%04x_%02u.%02u.%02u_%u",
+		 mhi_netdev->interface_name, mhi_dev->dev_id, mhi_dev->domain,
+		 mhi_dev->bus, mhi_dev->slot, mhi_netdev->alias);
+
+	snprintf(ifname, sizeof(ifname), "%s%%d", mhi_netdev->interface_name);
+
+	mhi_netdev->ethernet_interface = of_property_read_bool(of_node,
+							       "mhi,ethernet-interface");
+#else
+	mhi_netdev->alias = mhi_netdev_init_array[index].alias;
+
+	mhi_netdev->interface_name =
+	    mhi_netdev_init_array[index].interface_name;
+
+	snprintf(ifalias, sizeof(ifalias), "%s_%04x_%02u.%02u.%02u_%u",
+		 mhi_netdev->interface_name, mhi_dev->dev_id, mhi_dev->domain,
+		 mhi_dev->bus, mhi_dev->slot, mhi_netdev->alias);
+
+	snprintf(ifname, sizeof(ifname), "%s%%d", mhi_netdev->interface_name);
+
+	mhi_netdev->ethernet_interface =
+	    mhi_netdev_init_array[index].ethernet_interface;
+#endif
+	rtnl_lock();
+	mhi_netdev->ndev = alloc_netdev(sizeof(*mhi_netdev_priv),
+					ifname, NET_NAME_PREDICTABLE,
+					mhi_netdev_setup);
+	if (!mhi_netdev->ndev) {
+		rtnl_unlock();
+		return -ENOMEM;
+	}
+
+	mhi_netdev->ndev->mtu = mhi_dev->mtu;
+	SET_NETDEV_DEV(mhi_netdev->ndev, &mhi_dev->dev);
+	dev_set_alias(mhi_netdev->ndev, ifalias, strlen(ifalias));
+	mhi_netdev_priv = netdev_priv(mhi_netdev->ndev);
+	mhi_netdev_priv->mhi_netdev = mhi_netdev;
+	rtnl_unlock();
+
+	mhi_netdev->napi = devm_kzalloc(&mhi_dev->dev,
+					sizeof(*mhi_netdev->napi), GFP_KERNEL);
+	if (!mhi_netdev->napi) {
+		ret = -ENOMEM;
+		goto napi_alloc_fail;
+	}
+
+	netif_napi_add(mhi_netdev->ndev, mhi_netdev->napi,
+		       mhi_netdev_poll, NAPI_POLL_WEIGHT);
+	ret = register_netdev(mhi_netdev->ndev);
+	if (ret) {
+		MSG_ERR("Network device registration failed\n");
+		goto net_dev_reg_fail;
+	}
+
+	napi_enable(mhi_netdev->napi);
+
+	MSG_LOG("Exited.\n");
+
+	return 0;
+
+net_dev_reg_fail:
+	netif_napi_del(mhi_netdev->napi);
+
+napi_alloc_fail:
+	free_netdev(mhi_netdev->ndev);
+	mhi_netdev->ndev = NULL;
+
+	return ret;
+}
+
+static void mhi_netdev_xfer_ul_cb(struct mhi_device *mhi_dev,
+				  struct mhi_result *mhi_result)
+{
+	struct mhi_netdev *mhi_netdev = mhi_device_get_devdata(mhi_dev);
+	struct sk_buff *skb = mhi_result->buf_addr;
+	struct net_device *ndev = mhi_netdev->ndev;
+
+#ifndef CONFIG_MHI_MBIM
+	ndev->stats.tx_packets++;
+	ndev->stats.tx_bytes += skb->len;
+#endif
+
+	dev_kfree_skb(skb);
+
+	if (netif_queue_stopped(ndev))
+		netif_wake_queue(ndev);
+}
+
+#ifndef CONFIG_MHI_MBIM
+static void mhi_netdev_push_skb(struct mhi_netdev *mhi_netdev,
+				struct mhi_buf *mhi_buf,
+				struct mhi_result *mhi_result)
+{
+	struct sk_buff *skb;
+
+	skb = alloc_skb(0, GFP_ATOMIC);
+	if (!skb) {
+		__free_pages(mhi_buf->page, mhi_netdev->order);
+		return;
+	}
+
+	if (!mhi_netdev->ethernet_interface) {
+		skb_add_rx_frag(skb, 0, mhi_buf->page, 0,
+				mhi_result->bytes_xferd, mhi_netdev->mru);
+		skb->dev = mhi_netdev->ndev;
+		skb->protocol = mhi_netdev_ip_type_trans(*(u8 *)mhi_buf->buf);
+	} else {
+		skb_add_rx_frag(skb, 0, mhi_buf->page, ETH_HLEN,
+				mhi_result->bytes_xferd - ETH_HLEN,
+				mhi_netdev->mru);
+		skb->dev = mhi_netdev->ndev;
+		skb->protocol =
+		    mhi_netdev_ip_type_trans(((u8 *)mhi_buf->buf)[ETH_HLEN]);
+	}
+	netif_receive_skb(skb);
+}
+#endif
+
+static void mhi_netdev_xfer_dl_cb(struct mhi_device *mhi_dev,
+				  struct mhi_result *mhi_result)
+{
+	struct mhi_netdev *mhi_netdev = mhi_device_get_devdata(mhi_dev);
+	struct mhi_netbuf *netbuf = mhi_result->buf_addr;
+	struct mhi_buf *mhi_buf = &netbuf->mhi_buf;
+	struct sk_buff *skb;
+	struct net_device *ndev = mhi_netdev->ndev;
+	struct device *dev = mhi_dev->dev.parent;
+#ifndef CONFIG_MHI_MBIM
+	struct mhi_net_chain *chain = mhi_netdev->chain;
+#endif
+
+	netbuf->unmap(dev, mhi_buf->dma_addr, mhi_buf->len, DMA_FROM_DEVICE);
+
+	/* modem is down, drop the buffer */
+	if (mhi_result->transaction_status == -ENOTCONN) {
+		__free_pages(mhi_buf->page, mhi_netdev->order);
+		return;
+	}
+
+	ndev->stats.rx_packets++;
+	ndev->stats.rx_bytes += mhi_result->bytes_xferd;
+
+#ifdef CONFIG_MHI_MBIM
+
+	skb =
+	    alloc_skb(MBIM_SKB_HEADROOM + mhi_result->bytes_xferd, GFP_ATOMIC);
+	if (!skb) {
+		__free_pages(mhi_buf->page, mhi_netdev->order);
+		return;
+	}
+
+	skb_reserve(skb, MBIM_SKB_HEADROOM);
+	skb_put_data(skb, mhi_buf->buf, mhi_result->bytes_xferd);
+	skb->dev = ndev;
+	cdc_ncm_mhi_rx_fixup(mhi_netdev, skb);
+	dev_kfree_skb_any(skb);
+	skb = NULL;
+	__free_pages(mhi_buf->page, mhi_netdev->order);
+
+#else
+
+	if (unlikely(!chain)) {
+		mhi_netdev_push_skb(mhi_netdev, mhi_buf, mhi_result);
+		return;
+	}
+
+	/* we support chaining */
+	skb = alloc_skb(0, GFP_ATOMIC);
+	if (likely(skb)) {
+		if (!mhi_netdev->ethernet_interface) {
+			skb_add_rx_frag(skb, 0, mhi_buf->page, 0,
+					mhi_result->bytes_xferd,
+					mhi_netdev->mru);
+		} else {
+			skb_add_rx_frag(skb, 0, mhi_buf->page, ETH_HLEN,
+					mhi_result->bytes_xferd - ETH_HLEN,
+					mhi_netdev->mru);
+		}
+
+		/* this is first on list */
+		if (!chain->head) {
+			skb->dev = ndev;
+			if (!mhi_netdev->ethernet_interface) {
+				skb->protocol =
+				    mhi_netdev_ip_type_trans(
+					*(u8 *)mhi_buf->buf);
+			} else {
+				skb->protocol =
+				    mhi_netdev_ip_type_trans(
+					((u8 *)mhi_buf->buf)[ETH_HLEN]);
+			}
+			chain->head = skb;
+		} else {
+			skb_shinfo(chain->tail)->frag_list = skb;
+		}
+
+		chain->tail = skb;
+	} else {
+		__free_pages(mhi_buf->page, mhi_netdev->order);
+	}
+#endif
+
+}
+
+static void mhi_netdev_status_cb(struct mhi_device *mhi_dev, enum MHI_CB mhi_cb)
+{
+	struct mhi_netdev *mhi_netdev = mhi_device_get_devdata(mhi_dev);
+
+	if (mhi_cb != MHI_CB_PENDING_DATA)
+		return;
+
+	napi_schedule(mhi_netdev->napi);
+}
+
+#ifdef CONFIG_DEBUG_FS
+
+struct dentry *dentry;
+
+static void mhi_netdev_create_debugfs(struct mhi_netdev *mhi_netdev)
+{
+	char node_name[32];
+	struct mhi_device *mhi_dev = mhi_netdev->mhi_dev;
+
+	/* Both tx & rx client handle contain same device info */
+	snprintf(node_name, sizeof(node_name), "%s_%04x_%02u.%02u.%02u_%u",
+		 mhi_netdev->interface_name, mhi_dev->dev_id, mhi_dev->domain,
+		 mhi_dev->bus, mhi_dev->slot, mhi_netdev->alias);
+
+	if (IS_ERR_OR_NULL(dentry))
+		return;
+
+	mhi_netdev->dentry = debugfs_create_dir(node_name, dentry);
+	if (IS_ERR_OR_NULL(mhi_netdev->dentry))
+		return;
+}
+
+static void mhi_netdev_create_debugfs_dir(void)
+{
+	dentry = debugfs_create_dir(MHI_NETDEV_DRIVER_NAME, 0);
+}
+
+#else
+
+static void mhi_netdev_create_debugfs(struct mhi_netdev_private *mhi_netdev)
+{
+}
+
+static void mhi_netdev_create_debugfs_dir(void)
+{
+}
+
+#endif
+
+static void mhi_netdev_remove(struct mhi_device *mhi_dev)
+{
+	struct mhi_netdev *mhi_netdev = mhi_device_get_devdata(mhi_dev);
+#ifdef CONFIG_MHI_MBIM
+	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)mhi_netdev->data[0];
+#endif
+
+	MSG_LOG("Remove notification received\n");
+
+	/* rsc parent takes cares of the cleanup */
+	if (mhi_netdev->is_rsc_dev) {
+		mhi_netdev_free_pool(mhi_netdev);
+		return;
+	}
+
+	netif_stop_queue(mhi_netdev->ndev);
+	napi_disable(mhi_netdev->napi);
+	unregister_netdev(mhi_netdev->ndev);
+	netif_napi_del(mhi_netdev->napi);
+	free_netdev(mhi_netdev->ndev);
+	mhi_netdev_free_pool(mhi_netdev);
+
+#ifdef CONFIG_MHI_MBIM
+	/* tasklet_kill(&ctx->bh); */
+	cdc_ncm_mhi_free(ctx);
+#endif
+
+	if (!IS_ERR_OR_NULL(mhi_netdev->dentry))
+		debugfs_remove_recursive(mhi_netdev->dentry);
+}
+
+#ifdef CONFIG_OF
+static int mhi_netdev_match(struct device *dev, void *data)
+{
+	/* if phandle dt == device dt, we found a match */
+	return (dev->of_node == data);
+}
+
+static void mhi_netdev_clone_dev(struct mhi_netdev *mhi_netdev,
+				 struct mhi_netdev *parent)
+{
+	mhi_netdev->ndev = parent->ndev;
+	mhi_netdev->napi = parent->napi;
+	mhi_netdev->ipc_log = parent->ipc_log;
+	mhi_netdev->msg_lvl = parent->msg_lvl;
+	mhi_netdev->ipc_log_lvl = parent->ipc_log_lvl;
+	mhi_netdev->is_rsc_dev = true;
+	mhi_netdev->chain = parent->chain;
+}
+#endif
+
+static int mhi_netdev_probe(struct mhi_device *mhi_dev,
+			    const struct mhi_device_id *id)
+{
+	int ret;
+	struct mhi_netdev *mhi_netdev, *p_netdev = NULL;
+	int nr_tre;
+	char node_name[32];
+	bool no_chain;
+#ifdef CONFIG_MHI_MBIM
+	struct cdc_ncm_ctx *ctx;
+#endif
+#ifdef CONFIG_OF
+	struct device_node *of_node = mhi_dev->dev.of_node;
+	struct device_node *phandle;
+
+	if (!of_node)
+		return -ENODEV;
+#else
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mhi_netdev_init_array); i++) {
+		if (!strcmp(mhi_netdev_init_array[i].chan, id->chan))
+			break;
+	}
+
+	if (i == ARRAY_SIZE(mhi_netdev_init_array))
+		return -ENODEV;
+#endif
+
+	mhi_netdev = devm_kzalloc(&mhi_dev->dev, sizeof(*mhi_netdev),
+				  GFP_KERNEL);
+	if (!mhi_netdev)
+		return -ENOMEM;
+
+	mhi_netdev->mhi_dev = mhi_dev;
+	mhi_device_set_devdata(mhi_dev, mhi_netdev);
+
+#ifdef CONFIG_OF
+	ret = of_property_read_u32(of_node, "mhi,mru", &mhi_netdev->mru);
+	if (ret)
+		return -ENODEV;
+
+	/* MRU must be multiplication of page size */
+	mhi_netdev->order = __ilog2_u32(mhi_netdev->mru / PAGE_SIZE);
+	if ((PAGE_SIZE << mhi_netdev->order) < mhi_netdev->mru)
+		return -EINVAL;
+
+	/* check if this device shared by a parent device */
+	phandle = of_parse_phandle(of_node, "mhi,rsc-parent", 0);
+	if (phandle) {
+		struct device *dev;
+		struct mhi_device *pdev;
+		/* find the parent device */
+		dev = driver_find_device(mhi_dev->dev.driver, NULL, phandle,
+					 mhi_netdev_match);
+		if (!dev)
+			return -ENODEV;
+
+		/* this device is shared with parent device. so we won't be
+		 * creating a new network interface. Clone parent
+		 * information to child node
+		 */
+		pdev = to_mhi_device(dev);
+		p_netdev = mhi_device_get_devdata(pdev);
+		mhi_netdev_clone_dev(mhi_netdev, p_netdev);
+		put_device(dev);
+	} else {
+		mhi_netdev->msg_lvl = MHI_MSG_LVL_ERROR;
+		no_chain = of_property_read_bool(of_node,
+						 "mhi,disable-chain-skb");
+		if (!no_chain) {
+			mhi_netdev->chain = devm_kzalloc(&mhi_dev->dev,
+						sizeof(*mhi_netdev->chain),
+						GFP_KERNEL);
+			if (!mhi_netdev->chain)
+				return -ENOMEM;
+		}
+
+		ret = mhi_netdev_enable_iface(mhi_netdev);
+		if (ret)
+			return ret;
+
+		/* create ipc log buffer */
+		snprintf(node_name, sizeof(node_name),
+			 "%s_%04x_%02u.%02u.%02u_%u",
+			 mhi_netdev->interface_name, mhi_dev->dev_id,
+			 mhi_dev->domain, mhi_dev->bus, mhi_dev->slot,
+			 mhi_netdev->alias);
+		mhi_netdev->ipc_log = ipc_log_context_create(IPC_LOG_PAGES,
+							     node_name, 0);
+		mhi_netdev->ipc_log_lvl = IPC_LOG_LVL;
+
+		mhi_netdev_create_debugfs(mhi_netdev);
+	}
+#else
+	mhi_netdev->mru = mhi_netdev_init_array[i].mru;
+
+	/* MRU must be multiplication of page size */
+	mhi_netdev->order = __ilog2_u32(mhi_netdev->mru / PAGE_SIZE);
+	if ((PAGE_SIZE << mhi_netdev->order) < mhi_netdev->mru)
+		return -EINVAL;
+
+	mhi_netdev->msg_lvl = MHI_MSG_LVL_ERROR;
+	no_chain = mhi_netdev_init_array[i].no_chain;
+	if (!no_chain) {
+		mhi_netdev->chain = devm_kzalloc(&mhi_dev->dev,
+						 sizeof(*mhi_netdev->chain),
+						 GFP_KERNEL);
+		if (!mhi_netdev->chain)
+			return -ENOMEM;
+	}
+
+	ret = mhi_netdev_enable_iface(mhi_netdev, i);
+	if (ret)
+		return ret;
+
+	/* create ipc log buffer */
+	snprintf(node_name, sizeof(node_name),
+		 "%s_%04x_%02u.%02u.%02u_%u",
+		 mhi_netdev->interface_name, mhi_dev->dev_id,
+		 mhi_dev->domain, mhi_dev->bus, mhi_dev->slot,
+		 mhi_netdev->alias);
+	mhi_netdev->ipc_log = ipc_log_context_create(IPC_LOG_PAGES,
+						     node_name, 0);
+	mhi_netdev->ipc_log_lvl = IPC_LOG_LVL;
+
+	mhi_netdev_create_debugfs(mhi_netdev);
+#endif
+
+#ifdef CONFIG_MHI_MBIM
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->bh.data = (unsigned long)mhi_netdev;
+	ctx->bh.func = cdc_ncm_mhi_txpath_bh;
+
+	spin_lock_init(&ctx->mtx);
+
+	/* store ctx pointer in device data field */
+	mhi_netdev->data[0] = (unsigned long)ctx;
+
+	ctx->rx_max = 31744;
+	ctx->tx_max = 16384;
+	ctx->tx_remainder = 0;
+	ctx->tx_modulus = 4;
+	ctx->tx_ndp_modulus = 4;
+	/* devices prior to NCM Errata shall set this field to zero */
+	ctx->tx_max_datagrams = 16;
+
+	/* set up maximum NDP size */
+	ctx->max_ndp_size = sizeof(struct usb_cdc_ncm_ndp16) +
+	    (ctx->tx_max_datagrams + 1) * sizeof(struct usb_cdc_ncm_dpe16);
+#endif
+
+	/* move mhi channels to start state */
+	ret = mhi_prepare_for_transfer(mhi_dev);
+	if (ret) {
+		MSG_ERR("Failed to start channels ret %d\n", ret);
+		goto error_start;
+	}
+
+	/* setup pool size ~2x ring length */
+	nr_tre = mhi_get_no_free_descriptors(mhi_dev, DMA_FROM_DEVICE);
+	mhi_netdev->pool_size = 1 << __ilog2_u32(nr_tre);
+	if (nr_tre > mhi_netdev->pool_size)
+		mhi_netdev->pool_size <<= 1;
+	mhi_netdev->pool_size <<= 1;
+
+	/* allocate memory pool */
+	ret = mhi_netdev_alloc_pool(mhi_netdev);
+	if (ret)
+		goto error_start;
+
+	/* link child node with parent node if it's children dev */
+	if (p_netdev)
+		p_netdev->rsc_dev = mhi_netdev;
+
+	/* now we have a pool of buffers allocated, queue to hardware
+	 * by triggering a napi_poll
+	 */
+	napi_schedule(mhi_netdev->napi);
+
+	return 0;
+
+error_start:
+#ifdef CONFIG_OF
+	if (phandle)
+		return ret;
+#endif
+
+	netif_stop_queue(mhi_netdev->ndev);
+	napi_disable(mhi_netdev->napi);
+	unregister_netdev(mhi_netdev->ndev);
+	netif_napi_del(mhi_netdev->napi);
+	free_netdev(mhi_netdev->ndev);
+#ifdef CONFIG_MHI_MBIM
+	cdc_ncm_mhi_free(ctx);
+#endif
+
+	return ret;
+}
+
+static const struct mhi_device_id mhi_netdev_match_table[] = {
+	{ .chan = "IP_HW0" },
+	{ .chan = "IP_HW_ADPL" },
+	{ .chan = "IP_HW0_RSC" },
+	{ .chan = "IP_SW0" },
+	{ },
+};
+
+static struct mhi_driver mhi_netdev_driver = {
+	.id_table = mhi_netdev_match_table,
+	.probe = mhi_netdev_probe,
+	.remove = mhi_netdev_remove,
+	.ul_xfer_cb = mhi_netdev_xfer_ul_cb,
+	.dl_xfer_cb = mhi_netdev_xfer_dl_cb,
+	.status_cb = mhi_netdev_status_cb,
+	.driver = {
+		.name = "mhi_netdev",
+		.owner = THIS_MODULE,
+	}
+};
+
+static int __init mhi_netdev_init(void)
+{
+	if (get_mhi_pci_status())
+		return -ENODEV;
+
+	BUILD_BUG_ON(sizeof(struct mhi_netbuf) > MAX_NETBUF_SIZE);
+	mhi_netdev_create_debugfs_dir();
+
+	return mhi_driver_register(&mhi_netdev_driver);
+}
+
+module_init(mhi_netdev_init);
+
+static void __exit mhi_netdev_exit(void)
+{
+	mhi_driver_unregister(&mhi_netdev_driver);
+	debugfs_remove(dentry);
+}
+
+module_exit(mhi_netdev_exit);
+
+MODULE_AUTHOR("Qualcomm Corporation");
+MODULE_DESCRIPTION("Qualcomm Modem Host Interface Bus Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/bus/mhi/devices/mhi_satellite.c b/drivers/bus/mhi/devices/mhi_satellite.c
new file mode 100644
index 000000000000..a42608c0708a
--- /dev/null
+++ b/drivers/bus/mhi/devices/mhi_satellite.c
@@ -0,0 +1,1155 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2019, The Linux Foundation. All rights reserved.*/
+
+#include <linux/debugfs.h>
+#include <linux/device.h>
+#include <linux/dma-direction.h>
+#include <linux/dma-mapping.h>
+#include <linux/errno.h>
+#include <linux/ipc_logging.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/rpmsg.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/wait.h>
+#include <linux/mhi.h>
+
+#define MHI_SAT_DRIVER_NAME "mhi_satellite"
+
+static bool mhi_sat_defer_init = true;	/* set by default */
+
+/* logging macros */
+#define IPC_LOG_PAGES (10)
+#define IPC_LOG_LVL (MHI_MSG_LVL_INFO)
+#define KLOG_LVL (MHI_MSG_LVL_ERROR)
+
+#define MHI_SUBSYS_LOG(fmt, ...) do { \
+	if (!subsys) \
+		break; \
+	if (mhi_sat_driver.klog_lvl <= MHI_MSG_LVL_INFO) \
+		pr_info("[I][%s][%s] " fmt, __func__, subsys->name, \
+			##__VA_ARGS__);\
+	if (subsys->ipc_log && mhi_sat_driver.ipc_log_lvl <= \
+	    MHI_MSG_LVL_INFO) \
+		ipc_log_string(subsys->ipc_log, "[I][%s] " fmt, __func__, \
+			       ##__VA_ARGS__); \
+} while (0)
+
+#define MHI_SAT_LOG(fmt, ...) do { \
+	if (!subsys || !sat_cntrl) \
+		break; \
+	if (mhi_sat_driver.klog_lvl <= MHI_MSG_LVL_INFO) \
+		pr_info("[I][%s][%s][%x] " fmt, __func__, subsys->name, \
+			sat_cntrl->dev_id, ##__VA_ARGS__);\
+	if (subsys->ipc_log && mhi_sat_driver.ipc_log_lvl <= \
+	    MHI_MSG_LVL_INFO) \
+		ipc_log_string(subsys->ipc_log, "[I][%s][%x] " fmt, __func__, \
+			       sat_cntrl->dev_id, ##__VA_ARGS__); \
+} while (0)
+
+#define MHI_SAT_ERR(fmt, ...) do { \
+	if (!subsys || !sat_cntrl) \
+		break; \
+	if (mhi_sat_driver.klog_lvl <= MHI_MSG_LVL_ERROR) \
+		pr_err("[E][%s][%s][%x] " fmt, __func__, subsys->name, \
+		       sat_cntrl->dev_id, ##__VA_ARGS__); \
+	if (subsys->ipc_log && mhi_sat_driver.ipc_log_lvl <= \
+	    MHI_MSG_LVL_ERROR) \
+		ipc_log_string(subsys->ipc_log, "[E][%s][%x] " fmt, __func__, \
+			       sat_cntrl->dev_id, ##__VA_ARGS__); \
+} while (0)
+
+#define MHI_SAT_ASSERT(cond, msg) do { \
+	if (cond) \
+		panic(msg); \
+} while (0)
+
+/* mhi sys error command */
+#define MHI_TRE_CMD_SYS_ERR_PTR (0)
+#define MHI_TRE_CMD_SYS_ERR_D0 (0)
+#define MHI_TRE_CMD_SYS_ERR_D1 (MHI_PKT_TYPE_SYS_ERR_CMD << 16)
+
+/* mhi state change event */
+#define MHI_TRE_EVT_MHI_STATE_PTR (0)
+#define MHI_TRE_EVT_MHI_STATE_D0(state) (state << 24)
+#define MHI_TRE_EVT_MHI_STATE_D1 (MHI_PKT_TYPE_STATE_CHANGE_EVENT << 16)
+
+/* mhi exec env change event */
+#define MHI_TRE_EVT_EE_PTR (0)
+#define MHI_TRE_EVT_EE_D0(ee) (ee << 24)
+#define MHI_TRE_EVT_EE_D1 (MHI_PKT_TYPE_EE_EVENT << 16)
+
+/* mhi config event */
+#define MHI_TRE_EVT_CFG_PTR(base_addr) (base_addr)
+#define MHI_TRE_EVT_CFG_D0(er_base, num) ((er_base << 16) | (num & 0xFFFF))
+#define MHI_TRE_EVT_CFG_D1 (MHI_PKT_TYPE_CFG_EVENT << 16)
+
+/* command completion event */
+#define MHI_TRE_EVT_CMD_COMPLETION_PTR(ptr) (ptr)
+#define MHI_TRE_EVT_CMD_COMPLETION_D0(code) (code << 24)
+#define MHI_TRE_EVT_CMD_COMPLETION_D1 (MHI_PKT_TYPE_CMD_COMPLETION_EVENT << 16)
+
+/* packet parser macros */
+#define MHI_TRE_GET_PTR(tre) ((tre)->ptr)
+#define MHI_TRE_GET_SIZE(tre) ((tre)->dword[0])
+#define MHI_TRE_GET_CCS(tre) (((tre)->dword[0] >> 24) & 0xFF)
+#define MHI_TRE_GET_ID(tre) (((tre)->dword[1] >> 24) & 0xFF)
+#define MHI_TRE_GET_TYPE(tre) (((tre)->dword[1] >> 16) & 0xFF)
+#define MHI_TRE_IS_ER_CTXT_TYPE(tre) (((tre)->dword[1]) & 0x1)
+
+/* creates unique device ID based on connection topology */
+#define MHI_SAT_CREATE_DEVICE_ID(dev, domain, bus, slot) \
+	((dev & 0xFFFF) << 16 | (domain & 0xF) << 12 | (bus & 0xFF) << 4 | \
+	(slot & 0xF))
+
+/* mhi core definitions */
+#define MHI_CTXT_TYPE_GENERIC (0xA)
+
+struct __packed mhi_generic_ctxt {
+	u32 reserved0;
+	u32 type;
+	u32 reserved1;
+	u64 ctxt_base;
+	u64 ctxt_size;
+	u64 reserved[2];
+};
+
+enum mhi_pkt_type {
+	MHI_PKT_TYPE_INVALID = 0x0,
+	MHI_PKT_TYPE_RESET_CHAN_CMD = 0x10,
+	MHI_PKT_TYPE_STOP_CHAN_CMD = 0x11,
+	MHI_PKT_TYPE_START_CHAN_CMD = 0x12,
+	MHI_PKT_TYPE_STATE_CHANGE_EVENT = 0x20,
+	MHI_PKT_TYPE_CMD_COMPLETION_EVENT = 0x21,
+	MHI_PKT_TYPE_EE_EVENT = 0x40,
+	MHI_PKT_TYPE_CTXT_UPDATE_CMD = 0x64,
+	MHI_PKT_TYPE_IOMMU_MAP_CMD = 0x65,
+	MHI_PKT_TYPE_CFG_EVENT = 0x6E,
+	MHI_PKT_TYPE_SYS_ERR_CMD = 0xFF,
+};
+
+enum mhi_cmd_type {
+	MHI_CMD_TYPE_RESET = 0x10,
+	MHI_CMD_TYPE_STOP = 0x11,
+	MHI_CMD_TYPE_START = 0x12,
+};
+
+/* mhi event completion codes */
+enum mhi_ev_ccs {
+	MHI_EV_CC_INVALID = 0x0,
+	MHI_EV_CC_SUCCESS = 0x1,
+	MHI_EV_CC_BAD_TRE = 0x11,
+};
+
+/* satellite subsystem definitions */
+enum subsys_id {
+	SUBSYS_ADSP,
+	SUBSYS_CDSP,
+	SUBSYS_SLPI,
+	SUBSYS_MODEM,
+	SUBSYS_MAX,
+};
+
+static const char *const subsys_names[SUBSYS_MAX] = {
+	[SUBSYS_ADSP] = "adsp",
+	[SUBSYS_CDSP] = "cdsp",
+	[SUBSYS_SLPI] = "slpi",
+	[SUBSYS_MODEM] = "modem",
+};
+
+struct mhi_sat_subsys {
+	const char *name;
+
+	struct rpmsg_device *rpdev;  /* rpmsg device */
+
+	/*
+	 * acquire either mutex or spinlock to walk controller list
+	 * acquire both when modifying list
+	 */
+	struct list_head cntrl_list; /* controllers list */
+	struct mutex cntrl_mutex;    /* mutex for controllers list */
+	spinlock_t cntrl_lock;       /* lock for controllers list */
+
+	void *ipc_log;
+};
+
+/* satellite IPC definitions */
+#define SAT_MAJOR_VERSION (1)
+#define SAT_MINOR_VERSION (0)
+#define SAT_RESERVED_SEQ_NUM (0xFFFF)
+#define SAT_MSG_SIZE(n) (sizeof(struct sat_header) + \
+			     (n * sizeof(struct sat_tre)))
+#define SAT_TRE_SIZE(msg_size) (msg_size  - sizeof(struct sat_header))
+#define SAT_TRE_OFFSET(msg) (msg + sizeof(struct sat_header))
+#define SAT_TRE_NUM_PKTS(payload_size) ((payload_size) / sizeof(struct sat_tre))
+
+/* satellite IPC msg type */
+enum sat_msg_id {
+	SAT_MSG_ID_ACK = 0xA,
+	SAT_MSG_ID_CMD = 0xC,
+	SAT_MSG_ID_EVT = 0xE,
+};
+
+/* satellite IPC context type */
+enum sat_ctxt_type {
+	SAT_CTXT_TYPE_CHAN = 0x0,
+	SAT_CTXT_TYPE_EVENT = 0x1,
+	SAT_CTXT_TYPE_MAX,
+};
+
+/* satellite IPC context string */
+#define TO_SAT_CTXT_TYPE_STR(type) (type >= SAT_CTXT_TYPE_MAX ? "INVALID" : \
+					sat_ctxt_str[type])
+
+const char *const sat_ctxt_str[SAT_CTXT_TYPE_MAX] = {
+	[SAT_CTXT_TYPE_CHAN] = "CCA",
+	[SAT_CTXT_TYPE_EVENT] = "ECA",
+};
+
+/* satellite IPC transfer ring element */
+struct __packed sat_tre {
+	u64 ptr;
+	u32 dword[2];
+};
+
+/* satellite IPC header */
+struct __packed sat_header {
+	u16 major_ver;
+	u16 minor_ver;
+	u16 msg_id;
+	u16 seq;
+	u16 reply_seq;
+	u16 payload_size;
+	u32 dev_id;
+	u8 reserved[8];
+};
+
+/* satellite driver definitions */
+struct mhi_sat_packet {
+	struct list_head node;
+
+	struct mhi_sat_cntrl *cntrl;	/* satellite controller reference */
+	void *msg;		/* incoming message */
+};
+
+struct mhi_sat_cntrl {
+	struct list_head node;
+
+	struct mhi_controller *mhi_cntrl; /* device MHI controller */
+	struct mhi_sat_subsys *subsys;
+
+	struct list_head dev_list;
+	struct list_head addr_map_list; /* IOMMU mapped addresses list */
+	struct mutex list_mutex;  /* mutex for devices and address map lists */
+
+	struct list_head packet_list;
+	spinlock_t pkt_lock; /* lock to walk/modify received packets list */
+
+	struct work_struct connect_work; /* subsystem connection worker */
+	struct work_struct process_work; /* incoming packets processor */
+
+	/* mhi core/controller configurations */
+	u32 dev_id;   /* unique ID with BDF as per connection topology */
+	int er_base;  /* event rings base index */
+	int er_max;   /* event rings max index */
+	int num_er;   /* total number of event rings */
+
+	/* satellite controller function counts */
+	int num_devices; /* mhi devices current count */
+	int max_devices; /* count of maximum devices for subsys/controller */
+	u16 seq;         /* internal s/n number for all outgoing packets */
+	bool active;     /* flag set if hello packet/MHI_CFG event was sent */
+
+	/* command completion variables */
+	u16 last_cmd_seq;   /* s/n number of last sent command packet */
+	enum mhi_ev_ccs last_cmd_ccs; /* last command completion event */
+	struct completion completion; /* command completion event wait */
+	struct mutex cmd_wait_mutex;  /* command completion wait mutex */
+};
+
+struct mhi_sat_device {
+	struct list_head node;
+
+	struct mhi_device *mhi_dev;   /* mhi device pointer */
+	struct mhi_sat_cntrl *cntrl;  /* parent controller */
+
+	bool chan_started;
+};
+
+struct mhi_sat_driver {
+	enum MHI_DEBUG_LEVEL ipc_log_lvl;  /* IPC log level */
+	enum MHI_DEBUG_LEVEL klog_lvl;     /* klog/dmesg levels */
+
+	struct mhi_sat_subsys *subsys;     /* pointer to subsystem array */
+	unsigned int num_subsys;
+
+	struct dentry *dentry;    /* debugfs directory */
+	bool deferred_init_done;  /* flag for deferred init protection */
+};
+
+static struct mhi_sat_driver mhi_sat_driver;
+
+static struct mhi_sat_subsys *find_subsys_by_name(const char *name)
+{
+	int i;
+	struct mhi_sat_subsys *subsys = mhi_sat_driver.subsys;
+
+	for (i = 0; i < mhi_sat_driver.num_subsys; i++, subsys++) {
+		if (!strcmp(name, subsys->name))
+			return subsys;
+	}
+
+	return NULL;
+}
+
+static struct mhi_sat_cntrl *find_sat_cntrl_by_id(struct mhi_sat_subsys *subsys,
+						  u32 dev_id)
+{
+	struct mhi_sat_cntrl *sat_cntrl;
+	unsigned long flags;
+
+	spin_lock_irqsave(&subsys->cntrl_lock, flags);
+	list_for_each_entry(sat_cntrl, &subsys->cntrl_list, node) {
+		if (sat_cntrl->dev_id == dev_id) {
+			spin_unlock_irqrestore(&subsys->cntrl_lock, flags);
+			return sat_cntrl;
+		}
+	}
+	spin_unlock_irqrestore(&subsys->cntrl_lock, flags);
+
+	return NULL;
+}
+
+static struct mhi_sat_device *find_sat_dev_by_id(
+			struct mhi_sat_cntrl *sat_cntrl, int id,
+			enum sat_ctxt_type evt)
+{
+	struct mhi_sat_device *sat_dev;
+	int compare_id;
+
+	mutex_lock(&sat_cntrl->list_mutex);
+	list_for_each_entry(sat_dev, &sat_cntrl->dev_list, node) {
+		compare_id = (evt == SAT_CTXT_TYPE_EVENT) ?
+		    sat_dev->mhi_dev->dl_event_id :
+		    sat_dev->mhi_dev->dl_chan_id;
+
+		if (compare_id == id) {
+			mutex_unlock(&sat_cntrl->list_mutex);
+			return sat_dev;
+		}
+	}
+	mutex_unlock(&sat_cntrl->list_mutex);
+
+	return NULL;
+}
+
+static bool mhi_sat_isvalid_header(struct sat_header *hdr, int len)
+{
+	/* validate payload size */
+	if (len >= sizeof(*hdr) && (len != hdr->payload_size + sizeof(*hdr)))
+		return false;
+
+	/* validate SAT IPC version */
+	if (hdr->major_ver != SAT_MAJOR_VERSION &&
+	    hdr->minor_ver != SAT_MINOR_VERSION)
+		return false;
+
+	/* validate msg ID */
+	if (hdr->msg_id != SAT_MSG_ID_CMD && hdr->msg_id != SAT_MSG_ID_EVT)
+		return false;
+
+	return true;
+}
+
+static int mhi_sat_wait_cmd_completion(struct mhi_sat_cntrl *sat_cntrl)
+{
+	struct mhi_sat_subsys *subsys = sat_cntrl->subsys;
+	int ret;
+
+	reinit_completion(&sat_cntrl->completion);
+
+	MHI_SAT_LOG("Wait for command completion\n");
+	ret = wait_for_completion_timeout(&sat_cntrl->completion,
+			msecs_to_jiffies(sat_cntrl->mhi_cntrl->timeout_ms));
+	if (!ret || sat_cntrl->last_cmd_ccs != MHI_EV_CC_SUCCESS) {
+		MHI_SAT_ERR("Command completion failure:seq:%u:ret:%d:ccs:%d\n",
+			    sat_cntrl->last_cmd_seq, ret,
+			    sat_cntrl->last_cmd_ccs);
+		return -EIO;
+	}
+
+	MHI_SAT_LOG("Command completion successful for seq:%u\n",
+		    sat_cntrl->last_cmd_seq);
+
+	return 0;
+}
+
+static int mhi_sat_send_msg(struct mhi_sat_cntrl *sat_cntrl,
+			    enum sat_msg_id type, u16 reply_seq,
+			    void *msg, u16 msg_size)
+{
+	struct mhi_sat_subsys *subsys = sat_cntrl->subsys;
+	struct sat_header *hdr = msg;
+
+	/* create sequence number for controller */
+	sat_cntrl->seq++;
+	if (sat_cntrl->seq == SAT_RESERVED_SEQ_NUM)
+		sat_cntrl->seq = 0;
+
+	/* populate header */
+	hdr->major_ver = SAT_MAJOR_VERSION;
+	hdr->minor_ver = SAT_MINOR_VERSION;
+	hdr->msg_id = type;
+	hdr->seq = sat_cntrl->seq;
+	hdr->reply_seq = reply_seq;
+	hdr->payload_size = SAT_TRE_SIZE(msg_size);
+	hdr->dev_id = sat_cntrl->dev_id;
+
+	/* save last sent command sequence number for completion event */
+	if (type == SAT_MSG_ID_CMD)
+		sat_cntrl->last_cmd_seq = sat_cntrl->seq;
+
+	return rpmsg_send(subsys->rpdev->ept, msg, msg_size);
+}
+
+static void mhi_sat_process_cmds(struct mhi_sat_cntrl *sat_cntrl,
+				 struct sat_header *hdr, struct sat_tre *pkt)
+{
+	struct mhi_sat_subsys *subsys = sat_cntrl->subsys;
+	int num_pkts = SAT_TRE_NUM_PKTS(hdr->payload_size), i;
+
+	for (i = 0; i < num_pkts; i++, pkt++) {
+		enum mhi_ev_ccs code = MHI_EV_CC_INVALID;
+
+		switch (MHI_TRE_GET_TYPE(pkt)) {
+		case MHI_PKT_TYPE_IOMMU_MAP_CMD:
+		{
+			struct mhi_buf *buf;
+			struct mhi_controller *mhi_cntrl = sat_cntrl->mhi_cntrl;
+			dma_addr_t iova = DMA_ERROR_CODE;
+
+			buf = kmalloc(sizeof(*buf), GFP_ATOMIC);
+			if (!buf)
+				goto iommu_map_cmd_completion;
+
+			buf->phys_addr = MHI_TRE_GET_PTR(pkt);
+			buf->len = MHI_TRE_GET_SIZE(pkt);
+
+			iova = dma_map_resource(mhi_cntrl->dev,
+					     buf->phys_addr, buf->len,
+					     DMA_BIDIRECTIONAL, 0);
+			if (dma_mapping_error(mhi_cntrl->dev, iova)) {
+				kfree(buf);
+				goto iommu_map_cmd_completion;
+			}
+
+			buf->dma_addr = iova;
+
+			mutex_lock(&sat_cntrl->list_mutex);
+			list_add_tail(&buf->node, &sat_cntrl->addr_map_list);
+			mutex_unlock(&sat_cntrl->list_mutex);
+
+			code = MHI_EV_CC_SUCCESS;
+
+iommu_map_cmd_completion:
+			MHI_SAT_LOG("IOMMU MAP 0x%llx CMD processing %s\n",
+				MHI_TRE_GET_PTR(pkt),
+				(code == MHI_EV_CC_SUCCESS) ?
+					"successful" : "failed");
+
+			pkt->ptr = MHI_TRE_EVT_CMD_COMPLETION_PTR(iova);
+			pkt->dword[0] = MHI_TRE_EVT_CMD_COMPLETION_D0(code);
+			pkt->dword[1] = MHI_TRE_EVT_CMD_COMPLETION_D1;
+			break;
+		}
+		case MHI_PKT_TYPE_CTXT_UPDATE_CMD:
+		{
+			u64 ctxt_ptr = MHI_TRE_GET_PTR(pkt);
+			u64 ctxt_size = MHI_TRE_GET_SIZE(pkt);
+			int id = MHI_TRE_GET_ID(pkt);
+			enum sat_ctxt_type evt = MHI_TRE_IS_ER_CTXT_TYPE(pkt);
+			struct mhi_generic_ctxt gen_ctxt;
+			struct mhi_buf buf;
+			struct mhi_sat_device *sat_dev =
+				find_sat_dev_by_id(sat_cntrl, id, evt);
+			int ret;
+
+			MHI_SAT_ASSERT(!sat_dev,
+				       "No device with given chan/evt ID");
+
+			memset(&gen_ctxt, 0, sizeof(gen_ctxt));
+			memset(&buf, 0, sizeof(buf));
+
+			gen_ctxt.type = MHI_CTXT_TYPE_GENERIC;
+			gen_ctxt.ctxt_base = ctxt_ptr;
+			gen_ctxt.ctxt_size = ctxt_size;
+
+			buf.buf = &gen_ctxt;
+			buf.len = sizeof(gen_ctxt);
+			buf.name = TO_SAT_CTXT_TYPE_STR(evt);
+
+			ret = mhi_device_configure(sat_dev->mhi_dev,
+						   DMA_BIDIRECTIONAL, &buf, 1);
+			if (!ret)
+				code = MHI_EV_CC_SUCCESS;
+
+			MHI_SAT_LOG("CTXT UPDATE CMD %s:%d processing %s\n",
+				buf.name, id,
+				(code == MHI_EV_CC_SUCCESS)
+					? "successful" : "failed");
+
+			pkt->ptr = MHI_TRE_EVT_CMD_COMPLETION_PTR(0);
+			pkt->dword[0] = MHI_TRE_EVT_CMD_COMPLETION_D0(code);
+			pkt->dword[1] = MHI_TRE_EVT_CMD_COMPLETION_D1;
+			break;
+		}
+		case MHI_PKT_TYPE_START_CHAN_CMD:
+		{
+			int id = MHI_TRE_GET_ID(pkt);
+			struct mhi_sat_device *sat_dev =
+				find_sat_dev_by_id(sat_cntrl, id,
+					       SAT_CTXT_TYPE_CHAN);
+			int ret;
+
+			MHI_SAT_ASSERT(!sat_dev,
+				       "No device with given channel ID\n");
+
+			MHI_SAT_ASSERT(sat_dev->chan_started,
+				       "Channel already started!");
+
+			ret = mhi_prepare_for_transfer(sat_dev->mhi_dev);
+			if (!ret) {
+				sat_dev->chan_started = true;
+				code = MHI_EV_CC_SUCCESS;
+			}
+
+			MHI_SAT_LOG("START CHANNEL %d CMD processing %s\n", id,
+				(code == MHI_EV_CC_SUCCESS)
+					? "successful" : "failure");
+
+			pkt->ptr = MHI_TRE_EVT_CMD_COMPLETION_PTR(0);
+			pkt->dword[0] = MHI_TRE_EVT_CMD_COMPLETION_D0(code);
+			pkt->dword[1] = MHI_TRE_EVT_CMD_COMPLETION_D1;
+			break;
+		}
+		case MHI_PKT_TYPE_RESET_CHAN_CMD:
+		{
+			int id = MHI_TRE_GET_ID(pkt);
+			struct mhi_sat_device *sat_dev =
+				find_sat_dev_by_id(sat_cntrl, id,
+						SAT_CTXT_TYPE_CHAN);
+
+			MHI_SAT_ASSERT(!sat_dev,
+				       "No device with given channel ID\n");
+
+			MHI_SAT_ASSERT(!sat_dev->chan_started,
+				       "Resetting unstarted channel!");
+
+			mhi_unprepare_from_transfer(sat_dev->mhi_dev);
+			sat_dev->chan_started = false;
+
+			MHI_SAT_LOG
+			    ("RESET CHANNEL %d CMD processing successful\n",
+			     id);
+
+			pkt->ptr = MHI_TRE_EVT_CMD_COMPLETION_PTR(0);
+			pkt->dword[0] =
+			    MHI_TRE_EVT_CMD_COMPLETION_D0(MHI_EV_CC_SUCCESS);
+			pkt->dword[1] = MHI_TRE_EVT_CMD_COMPLETION_D1;
+			break;
+		}
+		default:
+			MHI_SAT_ASSERT(1, "Unhandled command!");
+			break;
+		}
+	}
+}
+
+static void mhi_sat_process_worker(struct work_struct *work)
+{
+	struct mhi_sat_cntrl *sat_cntrl =
+			container_of(work, struct mhi_sat_cntrl, process_work);
+	struct mhi_sat_subsys *subsys = sat_cntrl->subsys;
+	struct mhi_sat_packet *packet, *tmp;
+	struct sat_header *hdr;
+	struct sat_tre *pkt;
+	LIST_HEAD(head);
+
+	MHI_SAT_LOG("Entered\n");
+
+	spin_lock_irq(&sat_cntrl->pkt_lock);
+	list_splice_tail_init(&sat_cntrl->packet_list, &head);
+	spin_unlock_irq(&sat_cntrl->pkt_lock);
+
+	list_for_each_entry_safe(packet, tmp, &head, node) {
+		hdr = packet->msg;
+		pkt = SAT_TRE_OFFSET(packet->msg);
+
+		list_del(&packet->node);
+
+		mhi_sat_process_cmds(sat_cntrl, hdr, pkt);
+
+		/* send response event(s) */
+		mhi_sat_send_msg(sat_cntrl, SAT_MSG_ID_EVT, hdr->seq,
+				 packet->msg,
+				 SAT_MSG_SIZE(SAT_TRE_NUM_PKTS
+					      (hdr->payload_size)));
+
+		kfree(packet);
+	}
+
+	MHI_SAT_LOG("Exited\n");
+}
+
+static void mhi_sat_connect_worker(struct work_struct *work)
+{
+	struct mhi_sat_cntrl *sat_cntrl = container_of(work,
+						       struct mhi_sat_cntrl,
+						       connect_work);
+	struct mhi_sat_subsys *subsys = sat_cntrl->subsys;
+	struct sat_tre *pkt;
+	void *msg;
+	int ret;
+
+	if (!subsys->rpdev || sat_cntrl->max_devices != sat_cntrl->num_devices
+	    || sat_cntrl->active)
+		return;
+
+	MHI_SAT_LOG("Entered\n");
+
+	msg = kmalloc(SAT_MSG_SIZE(3), GFP_ATOMIC);
+	if (!msg)
+		return;
+
+	sat_cntrl->active = true;
+
+	pkt = SAT_TRE_OFFSET(msg);
+
+	/* prepare #1 MHI_CFG HELLO event */
+	pkt->ptr = MHI_TRE_EVT_CFG_PTR(sat_cntrl->mhi_cntrl->base_addr);
+	pkt->dword[0] = MHI_TRE_EVT_CFG_D0(sat_cntrl->er_base,
+					   sat_cntrl->num_er);
+	pkt->dword[1] = MHI_TRE_EVT_CFG_D1;
+	pkt++;
+
+	/* prepare M0 event */
+	pkt->ptr = MHI_TRE_EVT_MHI_STATE_PTR;
+	pkt->dword[0] = MHI_TRE_EVT_MHI_STATE_D0(MHI_STATE_M0);
+	pkt->dword[1] = MHI_TRE_EVT_MHI_STATE_D1;
+	pkt++;
+
+	/* prepare AMSS event */
+	pkt->ptr = MHI_TRE_EVT_EE_PTR;
+	pkt->dword[0] = MHI_TRE_EVT_EE_D0(MHI_EE_AMSS);
+	pkt->dword[1] = MHI_TRE_EVT_EE_D1;
+
+	ret = mhi_sat_send_msg(sat_cntrl, SAT_MSG_ID_EVT, SAT_RESERVED_SEQ_NUM,
+			       msg, SAT_MSG_SIZE(3));
+	kfree(msg);
+	if (ret) {
+		MHI_SAT_ERR("Failed to send hello packet:%d\n", ret);
+		sat_cntrl->active = false;
+		return;
+	}
+
+	MHI_SAT_LOG("Device 0x%x sent hello packet\n", sat_cntrl->dev_id);
+}
+
+static void mhi_sat_process_events(struct mhi_sat_cntrl *sat_cntrl,
+				   struct sat_header *hdr, struct sat_tre *pkt)
+{
+	int num_pkts = SAT_TRE_NUM_PKTS(hdr->payload_size);
+	int i;
+
+	for (i = 0; i < num_pkts; i++, pkt++) {
+		if (MHI_TRE_GET_TYPE(pkt) ==
+				MHI_PKT_TYPE_CMD_COMPLETION_EVENT) {
+			if (hdr->reply_seq != sat_cntrl->last_cmd_seq)
+				continue;
+
+			sat_cntrl->last_cmd_ccs = MHI_TRE_GET_CCS(pkt);
+			complete(&sat_cntrl->completion);
+		}
+	}
+}
+
+static int mhi_sat_rpmsg_cb(struct rpmsg_device *rpdev, void *data, int len,
+			    void *priv, u32 src)
+{
+	struct mhi_sat_subsys *subsys = dev_get_drvdata(&rpdev->dev);
+	struct sat_header *hdr = data;
+	struct sat_tre *pkt = SAT_TRE_OFFSET(data);
+	struct mhi_sat_cntrl *sat_cntrl;
+	struct mhi_sat_packet *packet;
+
+	MHI_SAT_ASSERT(!mhi_sat_isvalid_header(hdr, len), "Invalid header!\n");
+
+	/* find controller packet was sent for */
+	sat_cntrl = find_sat_cntrl_by_id(subsys, hdr->dev_id);
+
+	MHI_SAT_ASSERT(!sat_cntrl, "Packet for unknown device!\n");
+
+	/* handle events directly regardless of controller active state */
+	if (hdr->msg_id == SAT_MSG_ID_EVT) {
+		mhi_sat_process_events(sat_cntrl, hdr, pkt);
+		return 0;
+	}
+
+	/* Inactive controller cannot process incoming commands */
+	if (unlikely(!sat_cntrl->active)) {
+		MHI_SAT_ERR("Message for inactive controller!\n");
+		return 0;
+	}
+
+	/* offload commands to process worker */
+	packet = kmalloc(sizeof(*packet) + len, GFP_ATOMIC);
+	if (!packet)
+		return 0;
+
+	packet->cntrl = sat_cntrl;
+	packet->msg = packet + 1;
+	memcpy(packet->msg, data, len);
+
+	spin_lock_irq(&sat_cntrl->pkt_lock);
+	list_add_tail(&packet->node, &sat_cntrl->packet_list);
+	spin_unlock_irq(&sat_cntrl->pkt_lock);
+
+	schedule_work(&sat_cntrl->process_work);
+
+	return 0;
+}
+
+static void mhi_sat_rpmsg_remove(struct rpmsg_device *rpdev)
+{
+	struct mhi_sat_subsys *subsys = dev_get_drvdata(&rpdev->dev);
+	struct mhi_sat_cntrl *sat_cntrl;
+	struct mhi_sat_device *sat_dev;
+	struct mhi_buf *buf, *tmp;
+
+	MHI_SUBSYS_LOG("Enter\n");
+
+	/* unprepare each controller/device from transfer */
+	mutex_lock(&subsys->cntrl_mutex);
+	list_for_each_entry(sat_cntrl, &subsys->cntrl_list, node) {
+		sat_cntrl->active = false;
+
+		flush_work(&sat_cntrl->connect_work);
+		flush_work(&sat_cntrl->process_work);
+
+		mutex_lock(&sat_cntrl->list_mutex);
+		list_for_each_entry(sat_dev, &sat_cntrl->dev_list, node) {
+			if (sat_dev->chan_started) {
+				mhi_unprepare_from_transfer(sat_dev->mhi_dev);
+				sat_dev->chan_started = false;
+			}
+		}
+
+		list_for_each_entry_safe(buf, tmp, &sat_cntrl->addr_map_list,
+					 node) {
+			dma_unmap_resource(sat_cntrl->mhi_cntrl->dev,
+					   buf->dma_addr, buf->len,
+					   DMA_BIDIRECTIONAL, 0);
+			list_del(&buf->node);
+			kfree(buf);
+		}
+		mutex_unlock(&sat_cntrl->list_mutex);
+
+		MHI_SAT_LOG("Removed RPMSG link\n");
+	}
+	mutex_unlock(&subsys->cntrl_mutex);
+
+	subsys->rpdev = NULL;
+}
+
+static int mhi_sat_rpmsg_probe(struct rpmsg_device *rpdev)
+{
+	struct mhi_sat_subsys *subsys;
+	struct mhi_sat_cntrl *sat_cntrl;
+	const char *subsys_name;
+	int ret;
+
+	ret = of_property_read_string(rpdev->dev.parent->of_node, "label",
+				      &subsys_name);
+	if (ret)
+		return ret;
+
+	/* find which subsystem has probed */
+	subsys = find_subsys_by_name(subsys_name);
+	if (!subsys)
+		return -EINVAL;
+
+	MHI_SUBSYS_LOG("Received RPMSG probe\n");
+
+	dev_set_drvdata(&rpdev->dev, subsys);
+
+	subsys->rpdev = rpdev;
+
+	/* schedule work for each controller as GLINK has connected */
+	spin_lock_irq(&subsys->cntrl_lock);
+	list_for_each_entry(sat_cntrl, &subsys->cntrl_list, node)
+		schedule_work(&sat_cntrl->connect_work);
+	spin_unlock_irq(&subsys->cntrl_lock);
+
+	return 0;
+}
+
+static struct rpmsg_device_id mhi_sat_rpmsg_match_table[] = {
+	{ .name = "mhi_sat" },
+	{ },
+};
+
+static struct rpmsg_driver mhi_sat_rpmsg_driver = {
+	.id_table = mhi_sat_rpmsg_match_table,
+	.probe = mhi_sat_rpmsg_probe,
+	.remove = mhi_sat_rpmsg_remove,
+	.callback = mhi_sat_rpmsg_cb,
+	.drv = {
+		.name = "mhi,sat_rpmsg",
+	},
+};
+
+static void mhi_sat_dev_status_cb(struct mhi_device *mhi_dev,
+				  enum MHI_CB mhi_cb)
+{
+}
+
+static void mhi_sat_dev_remove(struct mhi_device *mhi_dev)
+{
+	struct mhi_sat_device *sat_dev = mhi_device_get_devdata(mhi_dev);
+	struct mhi_sat_cntrl *sat_cntrl = sat_dev->cntrl;
+	struct mhi_sat_subsys *subsys = sat_cntrl->subsys;
+	struct mhi_buf *buf, *tmp;
+	struct sat_tre *pkt;
+	void *msg;
+	int ret;
+
+	/* remove device node from probed list */
+	mutex_lock(&sat_cntrl->list_mutex);
+	list_del(&sat_dev->node);
+	mutex_unlock(&sat_cntrl->list_mutex);
+
+	sat_cntrl->num_devices--;
+
+	/* prepare SYS_ERR command if first device is being removed */
+	if (sat_cntrl->active) {
+		sat_cntrl->active = false;
+
+		/* flush all pending work */
+		flush_work(&sat_cntrl->connect_work);
+		flush_work(&sat_cntrl->process_work);
+
+		msg = kmalloc(SAT_MSG_SIZE(1), GFP_KERNEL);
+
+		MHI_SAT_ASSERT(!msg, "Unable to malloc for SYS_ERR message!\n");
+
+		pkt = SAT_TRE_OFFSET(msg);
+		pkt->ptr = MHI_TRE_CMD_SYS_ERR_PTR;
+		pkt->dword[0] = MHI_TRE_CMD_SYS_ERR_D0;
+		pkt->dword[1] = MHI_TRE_CMD_SYS_ERR_D1;
+
+		/* acquire cmd_wait_mutex before sending command */
+		mutex_lock(&sat_cntrl->cmd_wait_mutex);
+
+		ret = mhi_sat_send_msg(sat_cntrl, SAT_MSG_ID_CMD,
+				       SAT_RESERVED_SEQ_NUM, msg,
+				       SAT_MSG_SIZE(1));
+		kfree(msg);
+		if (ret) {
+			MHI_SAT_ERR("Failed to notify SYS_ERR\n");
+			mutex_unlock(&sat_cntrl->cmd_wait_mutex);
+			goto exit_sys_err_send;
+		}
+
+		MHI_SAT_LOG("SYS_ERR command sent\n");
+
+		/* blocking call to wait for command completion event */
+		mhi_sat_wait_cmd_completion(sat_cntrl);
+
+		mutex_unlock(&sat_cntrl->cmd_wait_mutex);
+	}
+
+exit_sys_err_send:
+	/* exit if some devices are still present */
+	if (sat_cntrl->num_devices)
+		return;
+
+	/* remove address mappings */
+	mutex_lock(&sat_cntrl->list_mutex);
+	list_for_each_entry_safe(buf, tmp, &sat_cntrl->addr_map_list, node) {
+		dma_unmap_resource(sat_cntrl->mhi_cntrl->dev, buf->dma_addr,
+				   buf->len, DMA_BIDIRECTIONAL, 0);
+		list_del(&buf->node);
+		kfree(buf);
+	}
+	mutex_unlock(&sat_cntrl->list_mutex);
+
+	/* remove controller */
+	mutex_lock(&subsys->cntrl_mutex);
+	spin_lock_irq(&subsys->cntrl_lock);
+	list_del(&sat_cntrl->node);
+	spin_unlock_irq(&subsys->cntrl_lock);
+	mutex_unlock(&subsys->cntrl_mutex);
+
+	mutex_destroy(&sat_cntrl->cmd_wait_mutex);
+	mutex_destroy(&sat_cntrl->list_mutex);
+	MHI_SAT_LOG("Satellite controller node removed\n");
+	kfree(sat_cntrl);
+}
+
+static int mhi_sat_dev_probe(struct mhi_device *mhi_dev,
+			     const struct mhi_device_id *id)
+{
+	struct mhi_sat_device *sat_dev;
+	struct mhi_sat_cntrl *sat_cntrl;
+	struct device_node *of_node = mhi_dev->dev.of_node;
+	struct mhi_sat_subsys *subsys = &mhi_sat_driver.subsys[id->driver_data];
+	u32 dev_id = MHI_SAT_CREATE_DEVICE_ID(mhi_dev->dev_id, mhi_dev->domain,
+					      mhi_dev->bus, mhi_dev->slot);
+	int ret;
+
+	/* find controller with unique device ID based on topology */
+	sat_cntrl = find_sat_cntrl_by_id(subsys, dev_id);
+	if (!sat_cntrl) {
+		sat_cntrl = kzalloc(sizeof(*sat_cntrl), GFP_KERNEL);
+		if (!sat_cntrl)
+			return -ENOMEM;
+
+		/*
+		 * max_devices will be read from device tree node. Set it to
+		 * -1 before it is populated to avoid false positive when
+		 * RPMSG probe schedules connect worker but no device has
+		 * probed in which case num_devices and max_devices are both
+		 * zero.
+		 */
+		sat_cntrl->max_devices = -1;
+		sat_cntrl->dev_id = dev_id;
+		sat_cntrl->er_base = mhi_dev->dl_event_id;
+		sat_cntrl->mhi_cntrl = mhi_dev->mhi_cntrl;
+		sat_cntrl->last_cmd_seq = SAT_RESERVED_SEQ_NUM;
+		sat_cntrl->subsys = subsys;
+		init_completion(&sat_cntrl->completion);
+		mutex_init(&sat_cntrl->list_mutex);
+		mutex_init(&sat_cntrl->cmd_wait_mutex);
+		spin_lock_init(&sat_cntrl->pkt_lock);
+		INIT_WORK(&sat_cntrl->connect_work, mhi_sat_connect_worker);
+		INIT_WORK(&sat_cntrl->process_work, mhi_sat_process_worker);
+		INIT_LIST_HEAD(&sat_cntrl->dev_list);
+		INIT_LIST_HEAD(&sat_cntrl->addr_map_list);
+		INIT_LIST_HEAD(&sat_cntrl->packet_list);
+
+		mutex_lock(&subsys->cntrl_mutex);
+		spin_lock_irq(&subsys->cntrl_lock);
+		list_add(&sat_cntrl->node, &subsys->cntrl_list);
+		spin_unlock_irq(&subsys->cntrl_lock);
+		mutex_unlock(&subsys->cntrl_mutex);
+
+		MHI_SAT_LOG("Controller allocated for 0x%x\n", dev_id);
+	}
+
+	/* set maximum devices for subsystem from device tree */
+	if (of_node) {
+		ret = of_property_read_u32(of_node, "mhi,max-devices",
+					   &sat_cntrl->max_devices);
+		if (ret) {
+			MHI_SAT_ERR("Could not find max-devices in DT node\n");
+			return -EINVAL;
+		}
+	}
+
+	/* get event ring base and max indexes */
+	sat_cntrl->er_base = min(sat_cntrl->er_base, mhi_dev->dl_event_id);
+	sat_cntrl->er_max = max(sat_cntrl->er_base, mhi_dev->dl_event_id);
+
+	sat_dev = devm_kzalloc(&mhi_dev->dev, sizeof(*sat_dev), GFP_KERNEL);
+	if (!sat_dev)
+		return -ENOMEM;
+
+	sat_dev->mhi_dev = mhi_dev;
+	sat_dev->cntrl = sat_cntrl;
+
+	mutex_lock(&sat_cntrl->list_mutex);
+	list_add(&sat_dev->node, &sat_cntrl->dev_list);
+	mutex_unlock(&sat_cntrl->list_mutex);
+
+	mhi_device_set_devdata(mhi_dev, sat_dev);
+
+	sat_cntrl->num_devices++;
+
+	/* schedule connect worker if all devices for controller have probed */
+	if (sat_cntrl->num_devices == sat_cntrl->max_devices) {
+		/* number of event rings is 1 more than difference in IDs */
+		sat_cntrl->num_er =
+			(sat_cntrl->er_max - sat_cntrl->er_base) + 1;
+		MHI_SAT_LOG("All satellite channels probed!\n");
+		schedule_work(&sat_cntrl->connect_work);
+	}
+
+	return 0;
+}
+
+/* .driver_data stores subsys id */
+static const struct mhi_device_id mhi_sat_dev_match_table[] = {
+	/* ADSP */
+	{ .chan = "ADSP_0", .driver_data = SUBSYS_ADSP },
+	{ .chan = "ADSP_1", .driver_data = SUBSYS_ADSP },
+	{ .chan = "ADSP_2", .driver_data = SUBSYS_ADSP },
+	{ .chan = "ADSP_3", .driver_data = SUBSYS_ADSP },
+	{ .chan = "ADSP_4", .driver_data = SUBSYS_ADSP },
+	{ .chan = "ADSP_5", .driver_data = SUBSYS_ADSP },
+	{ .chan = "ADSP_6", .driver_data = SUBSYS_ADSP },
+	{ .chan = "ADSP_7", .driver_data = SUBSYS_ADSP },
+	{ .chan = "ADSP_8", .driver_data = SUBSYS_ADSP },
+	{ .chan = "ADSP_9", .driver_data = SUBSYS_ADSP },
+	/* CDSP */
+	{ .chan = "CDSP_0", .driver_data = SUBSYS_CDSP },
+	{ .chan = "CDSP_1", .driver_data = SUBSYS_CDSP },
+	{ .chan = "CDSP_2", .driver_data = SUBSYS_CDSP },
+	{ .chan = "CDSP_3", .driver_data = SUBSYS_CDSP },
+	{ .chan = "CDSP_4", .driver_data = SUBSYS_CDSP },
+	{ .chan = "CDSP_5", .driver_data = SUBSYS_CDSP },
+	{ .chan = "CDSP_6", .driver_data = SUBSYS_CDSP },
+	{ .chan = "CDSP_7", .driver_data = SUBSYS_CDSP },
+	{ .chan = "CDSP_8", .driver_data = SUBSYS_CDSP },
+	{ .chan = "CDSP_9", .driver_data = SUBSYS_CDSP },
+	/* SLPI */
+	{ .chan = "SLPI_0", .driver_data = SUBSYS_SLPI },
+	{ .chan = "SLPI_1", .driver_data = SUBSYS_SLPI },
+	{ .chan = "SLPI_2", .driver_data = SUBSYS_SLPI },
+	{ .chan = "SLPI_3", .driver_data = SUBSYS_SLPI },
+	{ .chan = "SLPI_4", .driver_data = SUBSYS_SLPI },
+	{ .chan = "SLPI_5", .driver_data = SUBSYS_SLPI },
+	{ .chan = "SLPI_6", .driver_data = SUBSYS_SLPI },
+	{ .chan = "SLPI_7", .driver_data = SUBSYS_SLPI },
+	{ .chan = "SLPI_8", .driver_data = SUBSYS_SLPI },
+	{ .chan = "SLPI_9", .driver_data = SUBSYS_SLPI },
+	/* MODEM */
+	{ .chan = "MODEM_0", .driver_data = SUBSYS_MODEM },
+	{ .chan = "MODEM_1", .driver_data = SUBSYS_MODEM },
+	{ .chan = "MODEM_2", .driver_data = SUBSYS_MODEM },
+	{ .chan = "MODEM_3", .driver_data = SUBSYS_MODEM },
+	{ .chan = "MODEM_4", .driver_data = SUBSYS_MODEM },
+	{ .chan = "MODEM_5", .driver_data = SUBSYS_MODEM },
+	{ .chan = "MODEM_6", .driver_data = SUBSYS_MODEM },
+	{ .chan = "MODEM_7", .driver_data = SUBSYS_MODEM },
+	{ .chan = "MODEM_8", .driver_data = SUBSYS_MODEM },
+	{ .chan = "MODEM_9", .driver_data = SUBSYS_MODEM },
+	{ },
+};
+
+static struct mhi_driver mhi_sat_dev_driver = {
+	.id_table = mhi_sat_dev_match_table,
+	.probe = mhi_sat_dev_probe,
+	.remove = mhi_sat_dev_remove,
+	.status_cb = mhi_sat_dev_status_cb,
+	.driver = {
+		.name = MHI_SAT_DRIVER_NAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+int mhi_sat_trigger_init(void *data, u64 val)
+{
+	struct mhi_sat_subsys *subsys;
+	int i, ret;
+
+	if (mhi_sat_driver.deferred_init_done)
+		return -EIO;
+
+	ret = register_rpmsg_driver(&mhi_sat_rpmsg_driver);
+	if (ret)
+		goto error_sat_trigger_init;
+
+	ret = mhi_driver_register(&mhi_sat_dev_driver);
+	if (ret)
+		goto error_sat_trigger_register;
+
+	mhi_sat_driver.deferred_init_done = true;
+
+	return 0;
+
+error_sat_trigger_register:
+	unregister_rpmsg_driver(&mhi_sat_rpmsg_driver);
+
+error_sat_trigger_init:
+	subsys = mhi_sat_driver.subsys;
+	for (i = 0; i < mhi_sat_driver.num_subsys; i++, subsys++) {
+		ipc_log_context_destroy(subsys->ipc_log);
+		mutex_destroy(&subsys->cntrl_mutex);
+	}
+	kfree(mhi_sat_driver.subsys);
+	mhi_sat_driver.subsys = NULL;
+
+	return ret;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(mhi_sat_debugfs_fops, NULL,
+			mhi_sat_trigger_init, "%llu\n");
+
+static int mhi_sat_init(void)
+{
+	struct mhi_sat_subsys *subsys;
+	int i, ret;
+
+	subsys = kcalloc(SUBSYS_MAX, sizeof(*subsys), GFP_KERNEL);
+	if (!subsys)
+		return -ENOMEM;
+
+	mhi_sat_driver.subsys = subsys;
+	mhi_sat_driver.num_subsys = SUBSYS_MAX;
+	mhi_sat_driver.klog_lvl = KLOG_LVL;
+	mhi_sat_driver.ipc_log_lvl = IPC_LOG_LVL;
+
+	for (i = 0; i < mhi_sat_driver.num_subsys; i++, subsys++) {
+		char log[32];
+
+		subsys->name = subsys_names[i];
+		mutex_init(&subsys->cntrl_mutex);
+		spin_lock_init(&subsys->cntrl_lock);
+		INIT_LIST_HEAD(&subsys->cntrl_list);
+		scnprintf(log, sizeof(log), "mhi_sat_%s", subsys->name);
+		subsys->ipc_log = ipc_log_context_create(IPC_LOG_PAGES, log, 0);
+	}
+
+	/* create debugfs entry if defer_init is enabled */
+	if (mhi_sat_defer_init) {
+		mhi_sat_driver.dentry = debugfs_create_dir("mhi_sat", NULL);
+		if (IS_ERR_OR_NULL(mhi_sat_driver.dentry)) {
+			ret = -ENODEV;
+			goto error_sat_init;
+		}
+
+		debugfs_create_file("debug", 0444, mhi_sat_driver.dentry, NULL,
+				    &mhi_sat_debugfs_fops);
+
+		return 0;
+	}
+
+	ret = register_rpmsg_driver(&mhi_sat_rpmsg_driver);
+	if (ret)
+		goto error_sat_init;
+
+	ret = mhi_driver_register(&mhi_sat_dev_driver);
+	if (ret)
+		goto error_sat_register;
+
+	return 0;
+
+error_sat_register:
+	unregister_rpmsg_driver(&mhi_sat_rpmsg_driver);
+
+error_sat_init:
+	subsys = mhi_sat_driver.subsys;
+	for (i = 0; i < mhi_sat_driver.num_subsys; i++, subsys++) {
+		ipc_log_context_destroy(subsys->ipc_log);
+		mutex_destroy(&subsys->cntrl_mutex);
+	}
+	kfree(mhi_sat_driver.subsys);
+	mhi_sat_driver.subsys = NULL;
+
+	return ret;
+}
+
+module_init(mhi_sat_init);
diff --git a/drivers/bus/mhi/devices/mhi_uci.c b/drivers/bus/mhi/devices/mhi_uci.c
new file mode 100644
index 000000000000..66bd96839837
--- /dev/null
+++ b/drivers/bus/mhi/devices/mhi_uci.c
@@ -0,0 +1,802 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.*/
+
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/dma-direction.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/ipc_logging.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+#include <linux/uaccess.h>
+#include <linux/mhi.h>
+#include <linux/kthread.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <asm/segment.h>
+#include <linux/buffer_head.h>
+
+#define DEVICE_NAME "mhi"
+#define MHI_UCI_DRIVER_NAME "mhi_uci"
+
+struct uci_chan {
+	wait_queue_head_t wq;
+	spinlock_t lock;
+	struct list_head pending;	/* user space waiting to read */
+	struct uci_buf *cur_buf;	/* current buffer user space reading */
+	size_t rx_size;
+};
+
+struct uci_buf {
+	void *data;
+	size_t len;
+	struct list_head node;
+};
+
+struct uci_dev {
+	struct list_head node;
+	dev_t devt;
+	struct device *dev;
+	struct mhi_device *mhi_dev;
+	const char *chan;
+	struct mutex mutex;	/* sync open and close */
+	struct uci_chan ul_chan;
+	struct uci_chan dl_chan;
+	size_t mtu;
+	int ref_count;
+	bool enabled;
+	void *ipc_log;
+};
+
+struct mhi_uci_drv {
+	struct list_head head;
+	struct mutex lock;
+	struct class *class;
+	int major;
+	dev_t dev_t;
+};
+
+static struct task_struct *tsk[110];
+
+enum MHI_DEBUG_LEVEL msg_lvl = MHI_MSG_LVL_ERROR;
+
+#ifdef CONFIG_MHI_DEBUG
+
+#define IPC_LOG_LVL (MHI_MSG_LVL_VERBOSE)
+#define MHI_UCI_IPC_LOG_PAGES (25)
+
+#else
+
+#define IPC_LOG_LVL (MHI_MSG_LVL_ERROR)
+#define MHI_UCI_IPC_LOG_PAGES (1)
+
+#endif
+
+#ifdef CONFIG_MHI_DEBUG
+
+#define MSG_VERB(fmt, ...) do { \
+		if (msg_lvl <= MHI_MSG_LVL_VERBOSE) \
+			pr_err("[D][%s] " fmt, __func__, ##__VA_ARGS__); \
+		if (uci_dev->ipc_log && (IPC_LOG_LVL <= MHI_MSG_LVL_VERBOSE)) \
+			ipc_log_string(uci_dev->ipc_log, "[D][%s] " fmt, \
+				       __func__, ##__VA_ARGS__); \
+	} while (0)
+
+#else
+
+#define MSG_VERB(fmt, ...)
+
+#endif
+
+#define MSG_LOG(fmt, ...) do { \
+		if (msg_lvl <= MHI_MSG_LVL_INFO) \
+			pr_err("[I][%s] " fmt, __func__, ##__VA_ARGS__); \
+		if (uci_dev->ipc_log && (IPC_LOG_LVL <= MHI_MSG_LVL_INFO)) \
+			ipc_log_string(uci_dev->ipc_log, "[I][%s] " fmt, \
+				       __func__, ##__VA_ARGS__); \
+	} while (0)
+
+#define MSG_ERR(fmt, ...) do { \
+		if (msg_lvl <= MHI_MSG_LVL_ERROR) \
+			pr_err("[E][%s] " fmt, __func__, ##__VA_ARGS__); \
+		if (uci_dev->ipc_log && (IPC_LOG_LVL <= MHI_MSG_LVL_ERROR)) \
+			ipc_log_string(uci_dev->ipc_log, "[E][%s] " fmt, \
+				       __func__, ##__VA_ARGS__); \
+	} while (0)
+
+#define MAX_UCI_DEVICES (64)
+
+static DECLARE_BITMAP(uci_minors, MAX_UCI_DEVICES);
+static struct mhi_uci_drv mhi_uci_drv;
+
+struct file *file_open(const char *path, int flags, int rights)
+{
+	struct file *filp = NULL;
+	mm_segment_t oldfs;
+	int err = 0;
+
+	oldfs = get_fs();
+	set_fs(KERNEL_DS);
+	filp = filp_open(path, flags, rights);
+	set_fs(oldfs);
+	if (IS_ERR(filp)) {
+		err = PTR_ERR(filp);
+		return NULL;
+	}
+	return filp;
+}
+
+void file_close(struct file *file)
+{
+	filp_close(file, NULL);
+}
+
+static int mhi_queue_inbound(struct uci_dev *uci_dev)
+{
+	struct mhi_device *mhi_dev = uci_dev->mhi_dev;
+	int nr_trbs = mhi_get_no_free_descriptors(mhi_dev, DMA_FROM_DEVICE);
+	size_t mtu = uci_dev->mtu;
+	void *buf;
+	struct uci_buf *uci_buf;
+	int ret = -EIO, i;
+
+	for (i = 0; i < nr_trbs; i++) {
+		buf = kmalloc(mtu + sizeof(*uci_buf), GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+
+		uci_buf = buf + mtu;
+		uci_buf->data = buf;
+
+		MSG_VERB("Allocated buf %d of %d size %zu\n", i, nr_trbs, mtu);
+
+		ret = mhi_queue_transfer(mhi_dev, DMA_FROM_DEVICE, buf, mtu,
+					 MHI_EOT);
+		if (ret) {
+			kfree(buf);
+			MSG_ERR("Failed to queue buffer %d\n", i);
+			return ret;
+		}
+	}
+
+	return ret;
+}
+
+static long mhi_uci_ioctl(struct file *file,
+			  unsigned int cmd, unsigned long arg)
+{
+	struct uci_dev *uci_dev = file->private_data;
+	struct mhi_device *mhi_dev = uci_dev->mhi_dev;
+	long ret = -ERESTARTSYS;
+
+	mutex_lock(&uci_dev->mutex);
+	if (uci_dev->enabled)
+		ret = mhi_ioctl(mhi_dev, cmd, arg);
+	mutex_unlock(&uci_dev->mutex);
+
+	return ret;
+}
+
+static int mhi_uci_release(struct inode *inode, struct file *file)
+{
+	struct uci_dev *uci_dev = file->private_data;
+
+	mutex_lock(&uci_dev->mutex);
+	uci_dev->ref_count--;
+	if (!uci_dev->ref_count) {
+		struct uci_buf *itr, *tmp;
+		struct uci_chan *uci_chan;
+
+		MSG_LOG("Last client left, closing node\n");
+
+		if (uci_dev->enabled)
+			mhi_unprepare_from_transfer(uci_dev->mhi_dev);
+
+		/* clean inbound channel */
+		uci_chan = &uci_dev->dl_chan;
+		list_for_each_entry_safe(itr, tmp, &uci_chan->pending, node) {
+			list_del(&itr->node);
+			kfree(itr->data);
+		}
+		if (uci_chan->cur_buf)
+			kfree(uci_chan->cur_buf->data);
+
+		uci_chan->cur_buf = NULL;
+
+		if (!uci_dev->enabled) {
+			MSG_LOG("Node is deleted, freeing dev node\n");
+			mutex_unlock(&uci_dev->mutex);
+			mutex_destroy(&uci_dev->mutex);
+			clear_bit(MINOR(uci_dev->devt), uci_minors);
+			kfree(uci_dev);
+			return 0;
+		}
+	}
+
+	MSG_LOG("exit: ref_count:%d\n", uci_dev->ref_count);
+
+	mutex_unlock(&uci_dev->mutex);
+
+	return 0;
+}
+
+static unsigned int mhi_uci_poll(struct file *file, poll_table *wait)
+{
+	struct uci_dev *uci_dev = file->private_data;
+	struct mhi_device *mhi_dev = uci_dev->mhi_dev;
+	struct uci_chan *uci_chan;
+	unsigned int mask = 0;
+
+	poll_wait(file, &uci_dev->dl_chan.wq, wait);
+	poll_wait(file, &uci_dev->ul_chan.wq, wait);
+
+	uci_chan = &uci_dev->dl_chan;
+	spin_lock_bh(&uci_chan->lock);
+	if (!uci_dev->enabled) {
+		mask = POLLERR;
+	} else if (!list_empty(&uci_chan->pending) || uci_chan->cur_buf) {
+		MSG_VERB("Client can read from node\n");
+		mask |= POLLIN | POLLRDNORM;
+	}
+	spin_unlock_bh(&uci_chan->lock);
+
+	uci_chan = &uci_dev->ul_chan;
+	spin_lock_bh(&uci_chan->lock);
+	if (!uci_dev->enabled) {
+		mask |= POLLERR;
+	} else if (mhi_get_no_free_descriptors(mhi_dev, DMA_TO_DEVICE) > 0) {
+		MSG_VERB("Client can write to node\n");
+		mask |= POLLOUT | POLLWRNORM;
+	}
+	spin_unlock_bh(&uci_chan->lock);
+
+	MSG_LOG("Client attempted to poll, returning mask 0x%x\n", mask);
+
+	return mask;
+}
+
+static ssize_t mhi_uci_write(struct file *file, const char __user *buf,
+			     size_t count, loff_t *offp)
+{
+	struct uci_dev *uci_dev = file->private_data;
+	struct mhi_device *mhi_dev = uci_dev->mhi_dev;
+	struct uci_chan *uci_chan = &uci_dev->ul_chan;
+	size_t bytes_xfered = 0;
+	int ret, nr_avail;
+
+	if (!buf || !count)
+		return -EINVAL;
+
+	/* confirm channel is active */
+	spin_lock_bh(&uci_chan->lock);
+	if (!uci_dev->enabled) {
+		spin_unlock_bh(&uci_chan->lock);
+		return -ERESTARTSYS;
+	}
+
+	MSG_VERB("Enter: to xfer:%zu bytes\n", count);
+
+	while (count) {
+		size_t xfer_size;
+		void *kbuf;
+		enum MHI_FLAGS flags;
+
+		spin_unlock_bh(&uci_chan->lock);
+
+		/* wait for free descriptors */
+		ret = wait_event_interruptible(uci_chan->wq,
+				(!uci_dev->enabled) ||
+				(nr_avail = mhi_get_no_free_descriptors(mhi_dev,
+							DMA_TO_DEVICE)) > 0);
+
+		if (ret == -ERESTARTSYS || !uci_dev->enabled) {
+			MSG_LOG("Exit signal caught for node or not enabled\n");
+			return -ERESTARTSYS;
+		}
+
+		xfer_size = min_t(size_t, count, uci_dev->mtu);
+		kbuf = kmalloc(xfer_size, GFP_KERNEL);
+		if (!kbuf) {
+			MSG_ERR("Failed to allocate memory %zu\n", xfer_size);
+			return -ENOMEM;
+		}
+
+		ret = copy_from_user(kbuf, buf, xfer_size);
+		if (unlikely(ret)) {
+			kfree(kbuf);
+			return ret;
+		}
+
+		spin_lock_bh(&uci_chan->lock);
+
+		/* if ring is full after this force EOT */
+		if (nr_avail > 1 && (count - xfer_size))
+			flags = MHI_CHAIN;
+		else
+			flags = MHI_EOT;
+
+		if (uci_dev->enabled)
+			ret = mhi_queue_transfer(mhi_dev, DMA_TO_DEVICE, kbuf,
+						 xfer_size, flags);
+		else
+			ret = -ERESTARTSYS;
+
+		if (ret) {
+			kfree(kbuf);
+			goto sys_interrupt;
+		}
+
+		bytes_xfered += xfer_size;
+		count -= xfer_size;
+		buf += xfer_size;
+	}
+
+	spin_unlock_bh(&uci_chan->lock);
+	MSG_VERB("Exit: Number of bytes xferred:%zu\n", bytes_xfered);
+
+	return bytes_xfered;
+
+sys_interrupt:
+	spin_unlock_bh(&uci_chan->lock);
+
+	return ret;
+}
+
+static ssize_t mhi_uci_read(struct file *file,
+			    char __user *buf, size_t count, loff_t *ppos)
+{
+	struct uci_dev *uci_dev = file->private_data;
+	struct mhi_device *mhi_dev = uci_dev->mhi_dev;
+	struct uci_chan *uci_chan = &uci_dev->dl_chan;
+	struct uci_buf *uci_buf;
+	char *ptr;
+	size_t to_copy;
+	int ret = 0;
+
+	if (!buf)
+		return -EINVAL;
+
+	MSG_VERB("Client provided buf len:%zu\n", count);
+
+	/* confirm channel is active */
+	spin_lock_bh(&uci_chan->lock);
+	if (!uci_dev->enabled) {
+		spin_unlock_bh(&uci_chan->lock);
+		return -ERESTARTSYS;
+	}
+
+	/* No data available to read, wait */
+	if (!uci_chan->cur_buf && list_empty(&uci_chan->pending)) {
+		MSG_VERB("No data available to read waiting\n");
+
+		spin_unlock_bh(&uci_chan->lock);
+		ret = wait_event_interruptible(uci_chan->wq,
+				(!uci_dev->enabled ||
+				 !list_empty(&uci_chan->pending)));
+		if (ret == -ERESTARTSYS) {
+			MSG_LOG("Exit signal caught for node\n");
+			return -ERESTARTSYS;
+		}
+
+		spin_lock_bh(&uci_chan->lock);
+		if (!uci_dev->enabled) {
+			MSG_LOG("node is disabled\n");
+			ret = -ERESTARTSYS;
+			goto read_error;
+		}
+	}
+
+	/* new read, get the next descriptor from the list */
+	if (!uci_chan->cur_buf) {
+		uci_buf = list_first_entry_or_null(&uci_chan->pending,
+						   struct uci_buf, node);
+		if (unlikely(!uci_buf)) {
+			ret = -EIO;
+			goto read_error;
+		}
+
+		list_del(&uci_buf->node);
+		uci_chan->cur_buf = uci_buf;
+		uci_chan->rx_size = uci_buf->len;
+		MSG_VERB("Got pkt of size:%zu\n", uci_chan->rx_size);
+	}
+
+	uci_buf = uci_chan->cur_buf;
+	spin_unlock_bh(&uci_chan->lock);
+
+	/* Copy the buffer to user space */
+	to_copy = min_t(size_t, count, uci_chan->rx_size);
+	ptr = uci_buf->data + (uci_buf->len - uci_chan->rx_size);
+	ret = copy_to_user(buf, ptr, to_copy);
+	if (ret)
+		return ret;
+
+	MSG_VERB("Copied %zu of %zu bytes\n", to_copy, uci_chan->rx_size);
+	uci_chan->rx_size -= to_copy;
+
+	/* we finished with this buffer, queue it back to hardware */
+	if (!uci_chan->rx_size) {
+		spin_lock_bh(&uci_chan->lock);
+		uci_chan->cur_buf = NULL;
+
+		if (uci_dev->enabled)
+			ret = mhi_queue_transfer(mhi_dev, DMA_FROM_DEVICE,
+						 uci_buf->data, uci_dev->mtu,
+						 MHI_EOT);
+		else
+			ret = -ERESTARTSYS;
+
+		if (ret) {
+			MSG_ERR("Failed to recycle element\n");
+			kfree(uci_buf->data);
+			goto read_error;
+		}
+
+		spin_unlock_bh(&uci_chan->lock);
+	}
+
+	MSG_VERB("Returning %zu bytes\n", to_copy);
+
+	return to_copy;
+
+read_error:
+	spin_unlock_bh(&uci_chan->lock);
+
+	return ret;
+}
+
+static int mhi_uci_open(struct inode *inode, struct file *filp)
+{
+	struct uci_dev *uci_dev = NULL, *tmp_dev;
+	int ret = -EIO;
+	struct uci_buf *buf_itr, *tmp;
+	struct uci_chan *dl_chan;
+
+	mutex_lock(&mhi_uci_drv.lock);
+	list_for_each_entry(tmp_dev, &mhi_uci_drv.head, node) {
+		if (tmp_dev->devt == inode->i_rdev) {
+			uci_dev = tmp_dev;
+			break;
+		}
+	}
+
+	/* could not find a minor node */
+	if (!uci_dev)
+		goto error_exit;
+
+	mutex_lock(&uci_dev->mutex);
+	if (!uci_dev->enabled) {
+		MSG_ERR("Node exist, but not in active state!\n");
+		goto error_open_chan;
+	}
+
+	uci_dev->ref_count++;
+
+	MSG_LOG("Node open, ref counts %u\n", uci_dev->ref_count);
+
+	if (uci_dev->ref_count == 1) {
+		MSG_LOG("Starting channel\n");
+		ret = mhi_prepare_for_transfer(uci_dev->mhi_dev);
+		if (ret) {
+			MSG_ERR("Error starting transfer channels\n");
+			uci_dev->ref_count--;
+			goto error_open_chan;
+		}
+
+		ret = mhi_queue_inbound(uci_dev);
+		if (ret)
+			goto error_rx_queue;
+	}
+
+	filp->private_data = uci_dev;
+	mutex_unlock(&uci_dev->mutex);
+	mutex_unlock(&mhi_uci_drv.lock);
+
+	return 0;
+
+error_rx_queue:
+	dl_chan = &uci_dev->dl_chan;
+	mhi_unprepare_from_transfer(uci_dev->mhi_dev);
+	list_for_each_entry_safe(buf_itr, tmp, &dl_chan->pending, node) {
+		list_del(&buf_itr->node);
+		kfree(buf_itr->data);
+	}
+
+error_open_chan:
+	mutex_unlock(&uci_dev->mutex);
+
+error_exit:
+	mutex_unlock(&mhi_uci_drv.lock);
+
+	return ret;
+}
+
+static const struct file_operations mhidev_fops = {
+	.open = mhi_uci_open,
+	.release = mhi_uci_release,
+	.read = mhi_uci_read,
+	.write = mhi_uci_write,
+	.poll = mhi_uci_poll,
+	.unlocked_ioctl = mhi_uci_ioctl,
+};
+
+static void mhi_uci_remove(struct mhi_device *mhi_dev)
+{
+	struct uci_dev *uci_dev = mhi_device_get_devdata(mhi_dev);
+
+	MSG_LOG("Enter\n");
+
+#ifdef CONFIG_MHI_MBIM
+	if (strcmp(uci_dev->mhi_dev->chan_name, "MBIM")
+	    && (!IS_ERR(tsk[uci_dev->mhi_dev->ul_chan_id])))
+		kthread_stop(tsk[uci_dev->mhi_dev->ul_chan_id]);
+#else
+	if (!IS_ERR(tsk[uci_dev->mhi_dev->ul_chan_id]))
+		kthread_stop(tsk[uci_dev->mhi_dev->ul_chan_id]);
+#endif
+
+	mutex_lock(&mhi_uci_drv.lock);
+	mutex_lock(&uci_dev->mutex);
+
+	/* disable the node */
+	spin_lock_irq(&uci_dev->dl_chan.lock);
+	spin_lock_irq(&uci_dev->ul_chan.lock);
+	uci_dev->enabled = false;
+	spin_unlock_irq(&uci_dev->ul_chan.lock);
+	spin_unlock_irq(&uci_dev->dl_chan.lock);
+	wake_up(&uci_dev->dl_chan.wq);
+	wake_up(&uci_dev->ul_chan.wq);
+
+	/* delete the node to prevent new opens */
+	device_destroy(mhi_uci_drv.class, uci_dev->devt);
+	uci_dev->dev = NULL;
+	list_del(&uci_dev->node);
+
+	/* safe to free memory only if all file nodes are closed */
+	if (!uci_dev->ref_count) {
+		mutex_unlock(&uci_dev->mutex);
+		mutex_destroy(&uci_dev->mutex);
+		clear_bit(MINOR(uci_dev->devt), uci_minors);
+		kfree(uci_dev);
+		mutex_unlock(&mhi_uci_drv.lock);
+		return;
+	}
+
+	MSG_LOG("Exit\n");
+	mutex_unlock(&uci_dev->mutex);
+	mutex_unlock(&mhi_uci_drv.lock);
+
+}
+
+static int open_uci_thread(void *data)
+{
+	struct mhi_device *mhi_dev = (struct mhi_device *)data;
+	struct file *uci_filp;
+	char mhi_uci_dev_name[40];
+
+	if (!strcmp(mhi_dev->chan_name, "AT"))
+		snprintf(mhi_uci_dev_name, sizeof(mhi_uci_dev_name),
+			 "/dev/at_pcie");
+	else
+		snprintf(mhi_uci_dev_name, sizeof(mhi_uci_dev_name),
+			 "/dev/" DEVICE_NAME "_%04x_%02u.%02u.%02u%s%d",
+			 mhi_dev->dev_id, mhi_dev->domain, mhi_dev->bus,
+			 mhi_dev->slot, "_pipe_", mhi_dev->ul_chan_id);
+
+	do {
+		msleep(300);
+		uci_filp = file_open(mhi_uci_dev_name, O_RDONLY, 0);
+	} while (!uci_filp);
+
+	do {
+		msleep(1000);
+	} while (!kthread_should_stop());
+
+	file_close(uci_filp);
+
+	return 0;
+}
+
+static int mhi_uci_probe(struct mhi_device *mhi_dev,
+			 const struct mhi_device_id *id)
+{
+	struct uci_dev *uci_dev;
+	int minor;
+	char node_name[32];
+	int dir;
+
+	uci_dev = kzalloc(sizeof(*uci_dev), GFP_KERNEL);
+	if (!uci_dev)
+		return -ENOMEM;
+
+	mutex_init(&uci_dev->mutex);
+	uci_dev->mhi_dev = mhi_dev;
+
+	minor = find_first_zero_bit(uci_minors, MAX_UCI_DEVICES);
+	if (minor >= MAX_UCI_DEVICES) {
+		kfree(uci_dev);
+		return -ENOSPC;
+	}
+
+	mutex_lock(&uci_dev->mutex);
+	mutex_lock(&mhi_uci_drv.lock);
+
+	uci_dev->devt = MKDEV(mhi_uci_drv.major, minor);
+
+	if (!strcmp(mhi_dev->chan_name, "AT"))
+		uci_dev->dev = device_create(mhi_uci_drv.class, &mhi_dev->dev,
+					     uci_dev->devt, uci_dev, "at_pcie");
+#ifdef CONFIG_MHI_MBIM
+	else if (!strcmp(mhi_dev->chan_name, "MBIM"))
+		uci_dev->dev = device_create(mhi_uci_drv.class, &mhi_dev->dev,
+					     uci_dev->devt, uci_dev,
+					     "cdc-wdm_pcie");
+#endif
+	else
+		uci_dev->dev = device_create(mhi_uci_drv.class, &mhi_dev->dev,
+					     uci_dev->devt, uci_dev,
+					     DEVICE_NAME
+					     "_%04x_%02u.%02u.%02u%s%d",
+					     mhi_dev->dev_id, mhi_dev->domain,
+					     mhi_dev->bus, mhi_dev->slot,
+					     "_pipe_", mhi_dev->ul_chan_id);
+	set_bit(minor, uci_minors);
+
+	/* create debugging buffer */
+	snprintf(node_name, sizeof(node_name), "mhi_uci_%04x_%02u.%02u.%02u_%d",
+		 mhi_dev->dev_id, mhi_dev->domain, mhi_dev->bus, mhi_dev->slot,
+		 mhi_dev->ul_chan_id);
+	uci_dev->ipc_log = ipc_log_context_create(MHI_UCI_IPC_LOG_PAGES,
+						  node_name, 0);
+
+	for (dir = 0; dir < 2; dir++) {
+		struct uci_chan *uci_chan =
+				(dir) ? &uci_dev->ul_chan : &uci_dev->dl_chan;
+		spin_lock_init(&uci_chan->lock);
+		init_waitqueue_head(&uci_chan->wq);
+		INIT_LIST_HEAD(&uci_chan->pending);
+	}
+
+	uci_dev->mtu = min_t(size_t, id->driver_data, mhi_dev->mtu);
+	mhi_device_set_devdata(mhi_dev, uci_dev);
+	uci_dev->enabled = true;
+
+	list_add(&uci_dev->node, &mhi_uci_drv.head);
+	mutex_unlock(&mhi_uci_drv.lock);
+	mutex_unlock(&uci_dev->mutex);
+
+	MSG_LOG("channel:%s successfully probed\n", mhi_dev->chan_name);
+
+#ifdef CONFIG_MHI_MBIM
+	/* No need to open MBIM device */
+	if (!strcmp(mhi_dev->chan_name, "MBIM"))
+		return 0;
+#endif
+
+	tsk[mhi_dev->ul_chan_id] =
+	    kthread_run(open_uci_thread, mhi_dev, "MHI_UCI_%s",
+			mhi_dev->chan_name);
+	if (IS_ERR(tsk[mhi_dev->ul_chan_id]))
+		pr_err("create kthread failed!\n");
+
+	return 0;
+};
+
+static void mhi_ul_xfer_cb(struct mhi_device *mhi_dev,
+			   struct mhi_result *mhi_result)
+{
+	struct uci_dev *uci_dev = mhi_device_get_devdata(mhi_dev);
+	struct uci_chan *uci_chan = &uci_dev->ul_chan;
+
+	MSG_VERB("status:%d xfer_len:%zu\n", mhi_result->transaction_status,
+		 mhi_result->bytes_xferd);
+
+	kfree(mhi_result->buf_addr);
+	if (!mhi_result->transaction_status)
+		wake_up(&uci_chan->wq);
+}
+
+static void mhi_dl_xfer_cb(struct mhi_device *mhi_dev,
+			   struct mhi_result *mhi_result)
+{
+	struct uci_dev *uci_dev = mhi_device_get_devdata(mhi_dev);
+	struct uci_chan *uci_chan = &uci_dev->dl_chan;
+	unsigned long flags;
+	struct uci_buf *buf;
+
+	MSG_VERB("status:%d receive_len:%zu\n", mhi_result->transaction_status,
+		 mhi_result->bytes_xferd);
+
+	if (mhi_result->transaction_status == -ENOTCONN) {
+		kfree(mhi_result->buf_addr);
+		return;
+	}
+
+	spin_lock_irqsave(&uci_chan->lock, flags);
+	buf = mhi_result->buf_addr + uci_dev->mtu;
+	buf->data = mhi_result->buf_addr;
+	buf->len = mhi_result->bytes_xferd;
+	list_add_tail(&buf->node, &uci_chan->pending);
+	spin_unlock_irqrestore(&uci_chan->lock, flags);
+
+	if (mhi_dev->dev.power.wakeup)
+		__pm_wakeup_event(mhi_dev->dev.power.wakeup, 0);
+
+	wake_up(&uci_chan->wq);
+}
+
+/* .driver_data stores max mtu */
+static const struct mhi_device_id mhi_uci_match_table[] = {
+	{ .chan = "LOOPBACK", .driver_data = 0x1000 },
+	{ .chan = "SAHARA", .driver_data = 0x8000 },
+	{ .chan = "EFS", .driver_data = 0x1000 },
+	{ .chan = "QMI0", .driver_data = 0x1000 },
+	{ .chan = "QMI1", .driver_data = 0x1000 },
+	{ .chan = "TF", .driver_data = 0x1000 },
+	{ .chan = "DUN", .driver_data = 0x1000 },
+	{ .chan = "AT", .driver_data = 0x1000 },
+#ifdef CONFIG_MHI_MBIM
+	{ .chan = "MBIM", .driver_data = 0x1000 },
+#endif
+	{ },
+};
+
+static struct mhi_driver mhi_uci_driver = {
+	.id_table = mhi_uci_match_table,
+	.remove = mhi_uci_remove,
+	.probe = mhi_uci_probe,
+	.ul_xfer_cb = mhi_ul_xfer_cb,
+	.dl_xfer_cb = mhi_dl_xfer_cb,
+	.driver = {
+		.name = MHI_UCI_DRIVER_NAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int mhi_uci_init(void)
+{
+	int ret;
+
+	ret = get_mhi_pci_status();
+	if (ret < 0)
+		return ret;
+
+	ret = register_chrdev(0, MHI_UCI_DRIVER_NAME, &mhidev_fops);
+	if (ret < 0)
+		return ret;
+
+	mhi_uci_drv.major = ret;
+	mhi_uci_drv.class = class_create(THIS_MODULE, MHI_UCI_DRIVER_NAME);
+	if (IS_ERR(mhi_uci_drv.class))
+		return -ENODEV;
+
+	mutex_init(&mhi_uci_drv.lock);
+	INIT_LIST_HEAD(&mhi_uci_drv.head);
+
+	ret = mhi_driver_register(&mhi_uci_driver);
+	if (ret)
+		class_destroy(mhi_uci_drv.class);
+
+	return ret;
+}
+
+module_init(mhi_uci_init);
+
+static void __exit mhi_uci_exit(void)
+{
+	unregister_chrdev(0, MHI_UCI_DRIVER_NAME);
+	mhi_driver_unregister(&mhi_uci_driver);
+	class_destroy(mhi_uci_drv.class);
+}
+
+module_exit(mhi_uci_exit);
+
+MODULE_AUTHOR("Qualcomm Corporation");
+MODULE_DESCRIPTION("Qualcomm Modem Host Interface Bus Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/qualcomm/rmnet/Makefile b/drivers/net/ethernet/qualcomm/rmnet/Makefile
index 8252e40bf570..64aec483046a 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/Makefile
+++ b/drivers/net/ethernet/qualcomm/rmnet/Makefile
@@ -1,11 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0-only
 #
 # Makefile for the RMNET module
-#
 
 rmnet-y		 := rmnet_config.o
 rmnet-y		 += rmnet_vnd.o
 rmnet-y		 += rmnet_handlers.o
 rmnet-y		 += rmnet_map_data.o
 rmnet-y		 += rmnet_map_command.o
+rmnet-y		 += rmnet_descriptor.o
 obj-$(CONFIG_RMNET) += rmnet.o
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 06de59521fc4..4eb45f5757c0 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -1,17 +1,30 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2019, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
  * RMNET configuration engine
+ *
  */
 
 #include <net/sock.h>
 #include <linux/module.h>
 #include <linux/netlink.h>
 #include <linux/netdevice.h>
+#include <linux/hashtable.h>
 #include "rmnet_config.h"
 #include "rmnet_handlers.h"
 #include "rmnet_vnd.h"
 #include "rmnet_private.h"
+#include "rmnet_map.h"
+#include "rmnet_descriptor.h"
 
 /* Locking scheme -
  * The shared resource which needs to be protected is realdev->rx_handler_data.
@@ -34,15 +47,28 @@
 
 /* Local Definitions and Declarations */
 
-static const struct nla_policy rmnet_policy[IFLA_RMNET_MAX + 1] = {
-	[IFLA_RMNET_MUX_ID]	= { .type = NLA_U16 },
-	[IFLA_RMNET_FLAGS]	= { .len = sizeof(struct ifla_rmnet_flags) },
+enum {
+	IFLA_RMNET_UL_AGG_PARAMS = __IFLA_RMNET_MAX,
+	__IFLA_RMNET_EXT_MAX,
+};
+
+static const struct nla_policy rmnet_policy[__IFLA_RMNET_EXT_MAX] = {
+	[IFLA_RMNET_MUX_ID] = {
+		.type = NLA_U16
+	},
+	[IFLA_RMNET_FLAGS] = {
+		.len = sizeof(struct ifla_rmnet_flags)
+	},
+	[IFLA_RMNET_UL_AGG_PARAMS] = {
+		.len = sizeof(struct rmnet_egress_agg_params)
+	},
 };
 
-static int rmnet_is_real_dev_registered(const struct net_device *real_dev)
+int rmnet_is_real_dev_registered(const struct net_device *real_dev)
 {
 	return rcu_access_pointer(real_dev->rx_handler) == rmnet_rx_handler;
 }
+EXPORT_SYMBOL(rmnet_is_real_dev_registered);
 
 /* Needs rtnl lock */
 static struct rmnet_port*
@@ -57,10 +83,15 @@ static int rmnet_unregister_real_device(struct net_device *real_dev,
 	if (port->nr_rmnet_devs)
 		return -EINVAL;
 
-	netdev_rx_handler_unregister(real_dev);
+	rmnet_map_cmd_exit(port);
+	rmnet_map_tx_aggregate_exit(port);
+
+	rmnet_descriptor_deinit(port);
 
 	kfree(port);
 
+	netdev_rx_handler_unregister(real_dev);
+
 	/* release reference on real_dev */
 	dev_put(real_dev);
 
@@ -88,13 +119,21 @@ static int rmnet_register_real_device(struct net_device *real_dev)
 		kfree(port);
 		return -EBUSY;
 	}
-
 	/* hold on to real dev for MAP data */
 	dev_hold(real_dev);
 
 	for (entry = 0; entry < RMNET_MAX_LOGICAL_EP; entry++)
 		INIT_HLIST_HEAD(&port->muxed_ep[entry]);
 
+	rc = rmnet_descriptor_init(port);
+	if (rc) {
+		rmnet_descriptor_deinit(port);
+		return rc;
+	}
+
+	rmnet_map_tx_aggregate_init(port);
+	rmnet_map_cmd_init(port);
+
 	netdev_dbg(real_dev, "registered with rmnet\n");
 	return 0;
 }
@@ -171,6 +210,17 @@ static int rmnet_newlink(struct net *src_net, struct net_device *dev,
 	netdev_dbg(dev, "data format [0x%08X]\n", data_format);
 	port->data_format = data_format;
 
+	if (data[IFLA_RMNET_UL_AGG_PARAMS]) {
+		void *agg_params;
+		unsigned long irq_flags;
+
+		agg_params = nla_data(data[IFLA_RMNET_UL_AGG_PARAMS]);
+		spin_lock_irqsave(&port->agg_lock, irq_flags);
+		memcpy(&port->egress_agg_params, agg_params,
+		       sizeof(port->egress_agg_params));
+		spin_unlock_irqrestore(&port->agg_lock, irq_flags);
+	}
+
 	return 0;
 
 err1:
@@ -202,8 +252,10 @@ static void rmnet_dellink(struct net_device *dev, struct list_head *head)
 		hlist_del_init_rcu(&ep->hlnode);
 		rmnet_unregister_bridge(dev, port);
 		rmnet_vnd_dellink(mux_id, port, ep);
+		synchronize_rcu();
 		kfree(ep);
 	}
+
 	rmnet_unregister_real_device(real_dev, port);
 
 	unregister_netdevice_queue(dev, head);
@@ -225,7 +277,6 @@ static void rmnet_force_unassociate_device(struct net_device *dev)
 
 	port = rmnet_get_port_rtnl(dev);
 
-	rcu_read_lock();
 	rmnet_unregister_bridge(dev, port);
 
 	hash_for_each_safe(port->muxed_ep, bkt_ep, tmp_ep, ep, hlnode) {
@@ -233,10 +284,10 @@ static void rmnet_force_unassociate_device(struct net_device *dev)
 		rmnet_vnd_dellink(ep->mux_id, port, ep);
 
 		hlist_del_init_rcu(&ep->hlnode);
+		synchronize_rcu();
 		kfree(ep);
 	}
 
-	rcu_read_unlock();
 	unregister_netdevice_many(&list);
 
 	rmnet_unregister_real_device(real_dev, port);
@@ -252,6 +303,11 @@ static int rmnet_config_notify_cb(struct notifier_block *nb,
 
 	switch (event) {
 	case NETDEV_UNREGISTER:
+		if (dev->rtnl_link_ops == &rmnet_link_ops) {
+			netdev_rx_handler_unregister(dev);
+			break;
+		}
+
 		netdev_dbg(dev, "Kernel unregister\n");
 		rmnet_force_unassociate_device(dev);
 		break;
@@ -270,14 +326,24 @@ static struct notifier_block rmnet_dev_notifier __read_mostly = {
 static int rmnet_rtnl_validate(struct nlattr *tb[], struct nlattr *data[],
 			       struct netlink_ext_ack *extack)
 {
+	struct rmnet_egress_agg_params *agg_params;
 	u16 mux_id;
 
-	if (!data || !data[IFLA_RMNET_MUX_ID])
+	if (!data) {
 		return -EINVAL;
-
-	mux_id = nla_get_u16(data[IFLA_RMNET_MUX_ID]);
-	if (mux_id > (RMNET_MAX_LOGICAL_EP - 1))
-		return -ERANGE;
+	} else {
+		if (data[IFLA_RMNET_MUX_ID]) {
+			mux_id = nla_get_u16(data[IFLA_RMNET_MUX_ID]);
+			if (mux_id > (RMNET_MAX_LOGICAL_EP - 1))
+				return -ERANGE;
+		}
+
+		if (data[IFLA_RMNET_UL_AGG_PARAMS]) {
+			agg_params = nla_data(data[IFLA_RMNET_UL_AGG_PARAMS]);
+			if (agg_params->agg_time < 3000000)
+				return -EINVAL;
+		}
+	}
 
 	return 0;
 }
@@ -292,13 +358,10 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
 	struct rmnet_port *port;
 	u16 mux_id;
 
-	if (!dev)
-		return -ENODEV;
-
 	real_dev = __dev_get_by_index(dev_net(dev),
 				      nla_get_u32(tb[IFLA_LINK]));
 
-	if (!real_dev || !rmnet_is_real_dev_registered(real_dev))
+	if (!real_dev || !dev || !rmnet_is_real_dev_registered(real_dev))
 		return -ENODEV;
 
 	port = rmnet_get_port_rtnl(real_dev);
@@ -323,6 +386,17 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
 		port->data_format = flags->flags & flags->mask;
 	}
 
+	if (data[IFLA_RMNET_UL_AGG_PARAMS]) {
+		void *agg_params;
+		unsigned long irq_flags;
+
+		agg_params = nla_data(data[IFLA_RMNET_UL_AGG_PARAMS]);
+		spin_lock_irqsave(&port->agg_lock, irq_flags);
+		memcpy(&port->egress_agg_params, agg_params,
+		       sizeof(port->egress_agg_params));
+		spin_unlock_irqrestore(&port->agg_lock, irq_flags);
+	}
+
 	return 0;
 }
 
@@ -332,7 +406,9 @@ static size_t rmnet_get_size(const struct net_device *dev)
 		/* IFLA_RMNET_MUX_ID */
 		nla_total_size(2) +
 		/* IFLA_RMNET_FLAGS */
-		nla_total_size(sizeof(struct ifla_rmnet_flags));
+		nla_total_size(sizeof(struct ifla_rmnet_flags)) +
+		/* IFLA_RMNET_UL_AGG_PARAMS */
+		nla_total_size(sizeof(struct rmnet_egress_agg_params));
 }
 
 static int rmnet_fill_info(struct sk_buff *skb, const struct net_device *dev)
@@ -340,7 +416,7 @@ static int rmnet_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	struct rmnet_priv *priv = netdev_priv(dev);
 	struct net_device *real_dev;
 	struct ifla_rmnet_flags f;
-	struct rmnet_port *port;
+	struct rmnet_port *port = NULL;
 
 	real_dev = priv->real_dev;
 
@@ -359,6 +435,13 @@ static int rmnet_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	if (nla_put(skb, IFLA_RMNET_FLAGS, sizeof(f), &f))
 		goto nla_put_failure;
 
+	if (port) {
+		if (nla_put(skb, IFLA_RMNET_UL_AGG_PARAMS,
+			    sizeof(port->egress_agg_params),
+			    &port->egress_agg_params))
+			goto nla_put_failure;
+	}
+
 	return 0;
 
 nla_put_failure:
@@ -367,14 +450,14 @@ static int rmnet_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 struct rtnl_link_ops rmnet_link_ops __read_mostly = {
 	.kind		= "rmnet",
-	.maxtype	= __IFLA_RMNET_MAX,
+	.maxtype	= __IFLA_RMNET_EXT_MAX,
 	.priv_size	= sizeof(struct rmnet_priv),
 	.setup		= rmnet_vnd_setup,
 	.validate	= rmnet_rtnl_validate,
 	.newlink	= rmnet_newlink,
 	.dellink	= rmnet_dellink,
 	.get_size	= rmnet_get_size,
-	.changelink     = rmnet_changelink,
+	.changelink	= rmnet_changelink,
 	.policy		= rmnet_policy,
 	.fill_info	= rmnet_fill_info,
 };
@@ -387,6 +470,7 @@ struct rmnet_port *rmnet_get_port(struct net_device *real_dev)
 	else
 		return NULL;
 }
+EXPORT_SYMBOL(rmnet_get_port);
 
 struct rmnet_endpoint *rmnet_get_endpoint(struct rmnet_port *port, u8 mux_id)
 {
@@ -399,10 +483,11 @@ struct rmnet_endpoint *rmnet_get_endpoint(struct rmnet_port *port, u8 mux_id)
 
 	return NULL;
 }
+EXPORT_SYMBOL(rmnet_get_endpoint);
 
 int rmnet_add_bridge(struct net_device *rmnet_dev,
 		     struct net_device *slave_dev,
-		     struct netlink_ext_ack *extack)
+			 struct netlink_ext_ack *extack)
 {
 	struct rmnet_priv *priv = netdev_priv(rmnet_dev);
 	struct net_device *real_dev = priv->real_dev;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
index cd0a6bcbe74a..03caf3399552 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
@@ -1,16 +1,28 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright (c) 2013-2014, 2016-2018 The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2017, 2019 The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
  * RMNET Data configuration engine
+ *
  */
 
 #include <linux/skbuff.h>
 #include <net/gro_cells.h>
+#include "rmnet_descriptor.h"
 
 #ifndef _RMNET_CONFIG_H_
 #define _RMNET_CONFIG_H_
 
 #define RMNET_MAX_LOGICAL_EP 255
+#define RMNET_MAX_VEID 4
 
 struct rmnet_endpoint {
 	u8 mux_id;
@@ -18,6 +30,27 @@ struct rmnet_endpoint {
 	struct hlist_node hlnode;
 };
 
+struct rmnet_port_priv_stats {
+	u64 dl_hdr_last_qmap_vers;
+	u64 dl_hdr_last_ep_id;
+	u64 dl_hdr_last_trans_id;
+	u64 dl_hdr_last_seq;
+	u64 dl_hdr_last_bytes;
+	u64 dl_hdr_last_pkts;
+	u64 dl_hdr_last_flows;
+	u64 dl_hdr_count;
+	u64 dl_hdr_total_bytes;
+	u64 dl_hdr_total_pkts;
+	u64 dl_trl_last_seq;
+	u64 dl_trl_count;
+};
+
+struct rmnet_egress_agg_params {
+	u16 agg_size;
+	u16 agg_count;
+	u32 agg_time;
+};
+
 /* One instance of this structure is instantiated for each real_dev associated
  * with rmnet.
  */
@@ -28,6 +61,31 @@ struct rmnet_port {
 	u8 rmnet_mode;
 	struct hlist_head muxed_ep[RMNET_MAX_LOGICAL_EP];
 	struct net_device *bridge_ep;
+	void *rmnet_perf;
+
+	struct rmnet_egress_agg_params egress_agg_params;
+
+	/* Protect aggregation related elements */
+	spinlock_t agg_lock;
+
+	struct sk_buff *agg_skb;
+	int agg_state;
+	u8 agg_count;
+	struct timespec64 agg_time;
+	struct timespec64 agg_last;
+	struct hrtimer hrtimer;
+	struct work_struct agg_wq;
+
+	/* dl marker elements */
+	struct list_head dl_list;
+	struct rmnet_port_priv_stats stats;
+	int dl_marker_flush;
+
+	/* Descriptor pool */
+	spinlock_t desc_pool_lock;
+	struct rmnet_frag_descriptor_pool *frag_desc_pool;
+	struct sk_buff *chain_head;
+	struct sk_buff *chain_tail;
 };
 
 extern struct rtnl_link_ops rmnet_link_ops;
@@ -45,6 +103,31 @@ struct rmnet_pcpu_stats {
 	struct u64_stats_sync syncp;
 };
 
+struct rmnet_coal_close_stats {
+	u64 non_coal;
+	u64 ip_miss;
+	u64 trans_miss;
+	u64 hw_nl;
+	u64 hw_pkt;
+	u64 hw_byte;
+	u64 hw_time;
+	u64 hw_evict;
+	u64 coal;
+};
+
+struct rmnet_coal_stats {
+	u64 coal_rx;
+	u64 coal_pkts;
+	u64 coal_hdr_nlo_err;
+	u64 coal_hdr_pkt_err;
+	u64 coal_csum_err;
+	u64 coal_reconstruct;
+	u64 coal_ip_invalid;
+	u64 coal_trans_invalid;
+	struct rmnet_coal_close_stats close;
+	u64 coal_veid[RMNET_MAX_VEID];
+};
+
 struct rmnet_priv_stats {
 	u64 csum_ok;
 	u64 csum_valid_unset;
@@ -55,6 +138,8 @@ struct rmnet_priv_stats {
 	u64 csum_fragmented_pkt;
 	u64 csum_skipped;
 	u64 csum_sw;
+	u64 csum_hw;
+	struct rmnet_coal_stats coal;
 };
 
 struct rmnet_priv {
@@ -65,11 +150,32 @@ struct rmnet_priv {
 	struct rmnet_priv_stats stats;
 };
 
+enum rmnet_dl_marker_prio {
+	RMNET_PERF,
+	RMNET_SHS,
+};
+
+enum rmnet_trace_func {
+	RMNET_MODULE,
+	NW_STACK_MODULE,
+};
+
+enum rmnet_trace_evt {
+	RMNET_DLVR_SKB,
+	RMNET_RCV_FROM_PND,
+	RMNET_TX_UL_PKT,
+	NW_STACK_DEV_Q_XMIT,
+	NW_STACK_NAPI_GRO_FLUSH,
+	NW_STACK_RX,
+	NW_STACK_TX,
+};
+
+int rmnet_is_real_dev_registered(const struct net_device *real_dev);
 struct rmnet_port *rmnet_get_port(struct net_device *real_dev);
 struct rmnet_endpoint *rmnet_get_endpoint(struct rmnet_port *port, u8 mux_id);
 int rmnet_add_bridge(struct net_device *rmnet_dev,
 		     struct net_device *slave_dev,
-		     struct netlink_ext_ack *extack);
+			 struct netlink_ext_ack *extack);
 int rmnet_del_bridge(struct net_device *rmnet_dev,
 		     struct net_device *slave_dev);
 #endif /* _RMNET_CONFIG_H_ */
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_descriptor.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_descriptor.c
new file mode 100644
index 000000000000..fd1ae63b0605
--- /dev/null
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_descriptor.c
@@ -0,0 +1,1225 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2013-2019, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * RMNET Packet Descriptor Framework
+ *
+ */
+
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <net/ipv6.h>
+#include <net/ip6_checksum.h>
+#include "rmnet_config.h"
+#include "rmnet_descriptor.h"
+#include "rmnet_handlers.h"
+#include "rmnet_private.h"
+#include "rmnet_vnd.h"
+
+#define RMNET_FRAG_DESCRIPTOR_POOL_SIZE 64
+#define RMNET_DL_IND_HDR_SIZE (sizeof(struct rmnet_map_dl_ind_hdr) + \
+			       sizeof(struct rmnet_map_header) + \
+			       sizeof(struct rmnet_map_control_command_header))
+#define RMNET_DL_IND_TRL_SIZE (sizeof(struct rmnet_map_dl_ind_trl) + \
+			       sizeof(struct rmnet_map_header) + \
+			       sizeof(struct rmnet_map_control_command_header))
+
+typedef void (*rmnet_perf_desc_hook_t)(struct rmnet_frag_descriptor *frag_desc,
+				       struct rmnet_port *port);
+typedef void (*rmnet_perf_chain_hook_t)(void);
+
+struct rmnet_frag_descriptor *
+rmnet_get_frag_descriptor(struct rmnet_port *port)
+{
+	struct rmnet_frag_descriptor_pool *pool = port->frag_desc_pool;
+	struct rmnet_frag_descriptor *frag_desc;
+
+	spin_lock(&port->desc_pool_lock);
+	if (!list_empty(&pool->free_list)) {
+		frag_desc = list_first_entry(&pool->free_list,
+					     struct rmnet_frag_descriptor,
+					     list);
+		list_del_init(&frag_desc->list);
+	} else {
+		frag_desc = kzalloc(sizeof(*frag_desc), GFP_ATOMIC);
+		if (!frag_desc)
+			goto out;
+
+		INIT_LIST_HEAD(&frag_desc->list);
+		INIT_LIST_HEAD(&frag_desc->sub_frags);
+		pool->pool_size++;
+	}
+
+out:
+	spin_unlock(&port->desc_pool_lock);
+	return frag_desc;
+}
+EXPORT_SYMBOL(rmnet_get_frag_descriptor);
+
+void rmnet_recycle_frag_descriptor(struct rmnet_frag_descriptor *frag_desc,
+				   struct rmnet_port *port)
+{
+	struct rmnet_frag_descriptor_pool *pool = port->frag_desc_pool;
+	struct page *page = skb_frag_page(&frag_desc->frag);
+
+	list_del(&frag_desc->list);
+	if (page)
+		put_page(page);
+
+	memset(frag_desc, 0, sizeof(*frag_desc));
+	INIT_LIST_HEAD(&frag_desc->list);
+	INIT_LIST_HEAD(&frag_desc->sub_frags);
+	spin_lock(&port->desc_pool_lock);
+	list_add_tail(&frag_desc->list, &pool->free_list);
+	spin_unlock(&port->desc_pool_lock);
+}
+EXPORT_SYMBOL(rmnet_recycle_frag_descriptor);
+
+void rmnet_descriptor_add_frag(struct rmnet_port *port, struct list_head *list,
+			       struct page *p, u32 bv_page, u32 len)
+{
+	struct rmnet_frag_descriptor *frag_desc;
+
+	frag_desc = rmnet_get_frag_descriptor(port);
+	if (!frag_desc)
+		return;
+
+	rmnet_frag_fill(frag_desc, p, bv_page, len);
+	list_add_tail(&frag_desc->list, list);
+}
+EXPORT_SYMBOL(rmnet_descriptor_add_frag);
+
+int rmnet_frag_ipv6_skip_exthdr(struct rmnet_frag_descriptor *frag_desc,
+				int start, u8 *nexthdrp, __be16 *fragp)
+{
+	u8 nexthdr = *nexthdrp;
+
+	*fragp = 0;
+
+	while (ipv6_ext_hdr(nexthdr)) {
+		struct ipv6_opt_hdr *hp;
+		int hdrlen;
+
+		if (nexthdr == NEXTHDR_NONE)
+			return -EINVAL;
+
+		hp = rmnet_frag_data_ptr(frag_desc) + start;
+
+		if (nexthdr == NEXTHDR_FRAGMENT) {
+			__be16 *fp;
+
+			fp = rmnet_frag_data_ptr(frag_desc) + start +
+			     offsetof(struct frag_hdr, frag_off);
+			*fragp = *fp;
+			if (ntohs(*fragp) & ~0x7)
+				break;
+			hdrlen = 8;
+		} else if (nexthdr == NEXTHDR_AUTH) {
+			hdrlen = (hp->hdrlen + 2) << 2;
+		} else {
+			hdrlen = ipv6_optlen(hp);
+		}
+
+		nexthdr = hp->nexthdr;
+		start += hdrlen;
+	}
+
+	*nexthdrp = nexthdr;
+	return start;
+}
+EXPORT_SYMBOL(rmnet_frag_ipv6_skip_exthdr);
+
+static u8 rmnet_frag_do_flow_control(struct rmnet_map_header *qmap,
+				     struct rmnet_port *port,
+				     int enable)
+{
+	struct rmnet_map_control_command *cmd;
+	struct rmnet_endpoint *ep;
+	struct net_device *vnd;
+	u16 ip_family;
+	u16 fc_seq;
+	u32 qos_id;
+	u8 mux_id;
+	int r;
+
+	mux_id = qmap->mux_id;
+	cmd = (struct rmnet_map_control_command *)
+	      ((char *)qmap + sizeof(*qmap));
+
+	if (mux_id >= RMNET_MAX_LOGICAL_EP)
+		return RX_HANDLER_CONSUMED;
+
+	ep = rmnet_get_endpoint(port, mux_id);
+	if (!ep)
+		return RX_HANDLER_CONSUMED;
+
+	vnd = ep->egress_dev;
+
+	ip_family = cmd->flow_control.ip_family;
+	fc_seq = ntohs(cmd->flow_control.flow_control_seq_num);
+	qos_id = ntohl(cmd->flow_control.qos_id);
+
+	/* Ignore the ip family and pass the sequence number for both v4 and v6
+	 * sequence. User space does not support creating dedicated flows for
+	 * the 2 protocols
+	 */
+	r = rmnet_vnd_do_flow_control(vnd, enable);
+	if (r)
+		return RMNET_MAP_COMMAND_UNSUPPORTED;
+	else
+		return RMNET_MAP_COMMAND_ACK;
+}
+
+static void rmnet_frag_send_ack(struct rmnet_map_header *qmap,
+				unsigned char type,
+				struct rmnet_port *port)
+{
+	struct rmnet_map_control_command *cmd;
+	struct net_device *dev = port->dev;
+	struct sk_buff *skb;
+	u16 alloc_len = ntohs(qmap->pkt_len) + sizeof(*qmap);
+
+	skb = alloc_skb(alloc_len, GFP_ATOMIC);
+	if (!skb)
+		return;
+
+	skb->protocol = htons(ETH_P_MAP);
+	skb->dev = dev;
+
+	cmd = rmnet_map_get_cmd_start(skb);
+	cmd->cmd_type = type & 0x03;
+
+	netif_tx_lock(dev);
+	dev->netdev_ops->ndo_start_xmit(skb, dev);
+	netif_tx_unlock(dev);
+}
+
+static void
+rmnet_frag_process_flow_start(struct rmnet_map_control_command_header *cmd,
+			      struct rmnet_port *port,
+			      u16 cmd_len)
+{
+	struct rmnet_map_dl_ind_hdr *dlhdr;
+	u32 data_format;
+	bool is_dl_mark_v2;
+
+	if (cmd_len + sizeof(struct rmnet_map_header) < RMNET_DL_IND_HDR_SIZE)
+		return;
+
+	data_format = port->data_format;
+	is_dl_mark_v2 = data_format & RMNET_INGRESS_FORMAT_DL_MARKER_V2;
+	dlhdr = (struct rmnet_map_dl_ind_hdr *)((char *)cmd + sizeof(*cmd));
+
+	port->stats.dl_hdr_last_ep_id = cmd->source_id;
+	port->stats.dl_hdr_last_qmap_vers = cmd->reserved;
+	port->stats.dl_hdr_last_trans_id = cmd->transaction_id;
+	port->stats.dl_hdr_last_seq = dlhdr->le.seq;
+	port->stats.dl_hdr_last_bytes = dlhdr->le.bytes;
+	port->stats.dl_hdr_last_pkts = dlhdr->le.pkts;
+	port->stats.dl_hdr_last_flows = dlhdr->le.flows;
+	port->stats.dl_hdr_total_bytes += port->stats.dl_hdr_last_bytes;
+	port->stats.dl_hdr_total_pkts += port->stats.dl_hdr_last_pkts;
+	port->stats.dl_hdr_count++;
+
+	/* If a target is taking frag path, we can assume DL marker v2 is in
+	 * play
+	 */
+	if (is_dl_mark_v2)
+		rmnet_map_dl_hdr_notify_v2(port, dlhdr, cmd);
+	else
+		rmnet_map_dl_hdr_notify(port, dlhdr);
+}
+
+static void
+rmnet_frag_process_flow_end(struct rmnet_map_control_command_header *cmd,
+			    struct rmnet_port *port, u16 cmd_len)
+{
+	struct rmnet_map_dl_ind_trl *dltrl;
+	u32 data_format;
+	bool is_dl_mark_v2;
+
+	if (cmd_len + sizeof(struct rmnet_map_header) < RMNET_DL_IND_TRL_SIZE)
+		return;
+
+	data_format = port->data_format;
+	is_dl_mark_v2 = data_format & RMNET_INGRESS_FORMAT_DL_MARKER_V2;
+	dltrl = (struct rmnet_map_dl_ind_trl *)((char *)cmd + sizeof(*cmd));
+
+	port->stats.dl_trl_last_seq = dltrl->seq_le;
+	port->stats.dl_trl_count++;
+
+	/* If a target is taking frag path, we can assume DL marker v2 is in
+	 * play
+	 */
+	if (is_dl_mark_v2)
+		rmnet_map_dl_trl_notify_v2(port, dltrl, cmd);
+	else
+		rmnet_map_dl_trl_notify(port, dltrl);
+}
+
+/* Process MAP command frame and send N/ACK message as appropriate. Message cmd
+ * name is decoded here and appropriate handler is called.
+ */
+void rmnet_frag_command(struct rmnet_map_header *qmap, struct rmnet_port *port)
+{
+	struct rmnet_map_control_command *cmd;
+	unsigned char command_name;
+	unsigned char rc = 0;
+
+	cmd = (struct rmnet_map_control_command *)
+	      ((char *)qmap + sizeof(*qmap));
+	command_name = cmd->command_name;
+
+	switch (command_name) {
+	case RMNET_MAP_COMMAND_FLOW_ENABLE:
+		rc = rmnet_frag_do_flow_control(qmap, port, 1);
+		break;
+
+	case RMNET_MAP_COMMAND_FLOW_DISABLE:
+		rc = rmnet_frag_do_flow_control(qmap, port, 0);
+		break;
+
+	default:
+		rc = RMNET_MAP_COMMAND_UNSUPPORTED;
+		break;
+	}
+	if (rc == RMNET_MAP_COMMAND_ACK)
+		rmnet_frag_send_ack(qmap, rc, port);
+}
+
+int rmnet_frag_flow_command(struct rmnet_map_header *qmap,
+			    struct rmnet_port *port, u16 pkt_len)
+{
+	struct rmnet_map_control_command_header *cmd;
+	unsigned char command_name;
+
+	cmd = (struct rmnet_map_control_command_header *)
+	      ((char *)qmap + sizeof(*qmap));
+	command_name = cmd->command_name;
+
+	switch (command_name) {
+	case RMNET_MAP_COMMAND_FLOW_START:
+		rmnet_frag_process_flow_start(cmd, port, pkt_len);
+		break;
+
+	case RMNET_MAP_COMMAND_FLOW_END:
+		rmnet_frag_process_flow_end(cmd, port, pkt_len);
+		break;
+
+	default:
+		return 1;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(rmnet_frag_flow_command);
+
+void rmnet_frag_deaggregate(skb_frag_t *frag, struct rmnet_port *port,
+			    struct list_head *list)
+{
+	struct rmnet_map_header *maph;
+	u8 *data = skb_frag_address(frag);
+	u32 offset = 0;
+	u32 packet_len;
+
+	while (offset < skb_frag_size(frag)) {
+		maph = (struct rmnet_map_header *)data;
+		packet_len = ntohs(maph->pkt_len);
+
+		/* Some hardware can send us empty frames. Catch them */
+		if (packet_len == 0)
+			return;
+
+		packet_len += sizeof(*maph);
+
+		if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
+			packet_len += sizeof(struct rmnet_map_dl_csum_trailer);
+		} else if (port->data_format &
+			   (RMNET_FLAGS_INGRESS_MAP_CKSUMV5 |
+			    RMNET_FLAGS_INGRESS_COALESCE) && !maph->cd_bit) {
+			u32 hsize = 0;
+			u8 type;
+
+			type = ((struct rmnet_map_v5_coal_header *)
+				(data + sizeof(*maph)))->header_type;
+			switch (type) {
+			case RMNET_MAP_HEADER_TYPE_COALESCING:
+				hsize = sizeof(struct rmnet_map_v5_coal_header);
+				break;
+			case RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD:
+				hsize = sizeof(struct rmnet_map_v5_csum_header);
+				break;
+			}
+
+			packet_len += hsize;
+		}
+
+		if ((int)skb_frag_size(frag) - (int)packet_len < 0)
+			return;
+
+		rmnet_descriptor_add_frag(port, list, skb_frag_page(frag),
+					  frag->bv_offset + offset,
+					  packet_len);
+
+		offset += packet_len;
+		data += packet_len;
+	}
+}
+
+/* Fill in GSO metadata to allow the SKB to be segmented by the NW stack
+ * if needed (i.e. forwarding, UDP GRO)
+ */
+static void rmnet_frag_gso_stamp(struct sk_buff *skb,
+				 struct rmnet_frag_descriptor *frag_desc)
+{
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+
+	if (frag_desc->trans_proto == IPPROTO_TCP)
+		shinfo->gso_type = (frag_desc->ip_proto == 4) ?
+				   SKB_GSO_TCPV4 : SKB_GSO_TCPV6;
+	else
+		shinfo->gso_type = SKB_GSO_UDP_L4;
+
+	shinfo->gso_size = frag_desc->gso_size;
+	shinfo->gso_segs = frag_desc->gso_segs;
+}
+
+/* Set the partial checksum information. Sets the transport checksum tot he
+ * pseudoheader checksum and sets the offload metadata.
+ */
+static void rmnet_frag_partial_csum(struct sk_buff *skb,
+				    struct rmnet_frag_descriptor *frag_desc)
+{
+	struct iphdr *iph = (struct iphdr *)skb->data;
+	__sum16 pseudo;
+	u16 pkt_len = skb->len - frag_desc->ip_len;
+
+	if (frag_desc->ip_proto == 4) {
+		iph->tot_len = htons(skb->len);
+		iph->check = 0;
+		iph->check = ip_fast_csum(iph, iph->ihl);
+		pseudo = ~csum_tcpudp_magic(iph->saddr, iph->daddr,
+					    pkt_len, frag_desc->trans_proto,
+					    0);
+	} else {
+		struct ipv6hdr *ip6h = (struct ipv6hdr *)iph;
+
+		/* Payload length includes any extension headers */
+		ip6h->payload_len = htons(skb->len - sizeof(*ip6h));
+		pseudo = ~csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
+					  pkt_len, frag_desc->trans_proto, 0);
+	}
+
+	if (frag_desc->trans_proto == IPPROTO_TCP) {
+		struct tcphdr *tp = (struct tcphdr *)
+				    ((u8 *)iph + frag_desc->ip_len);
+
+		tp->check = pseudo;
+		skb->csum_offset = offsetof(struct tcphdr, check);
+	} else {
+		struct udphdr *up = (struct udphdr *)
+				    ((u8 *)iph + frag_desc->ip_len);
+
+		up->len = htons(pkt_len);
+		up->check = pseudo;
+		skb->csum_offset = offsetof(struct udphdr, check);
+	}
+
+	skb->ip_summed = CHECKSUM_PARTIAL;
+	skb->csum_start = (u8 *)iph + frag_desc->ip_len - skb->head;
+}
+
+/* Allocate and populate an skb to contain the packet represented by the
+ * frag descriptor.
+ */
+static struct sk_buff *rmnet_alloc_skb(struct rmnet_frag_descriptor *frag_desc,
+				       struct rmnet_port *port)
+{
+	struct sk_buff *head_skb, *current_skb, *skb;
+	struct skb_shared_info *shinfo;
+	struct rmnet_frag_descriptor *sub_frag, *tmp;
+
+	/* Use the exact sizes if we know them (i.e. RSB/RSC, rmnet_perf) */
+	if (frag_desc->hdrs_valid) {
+		u16 hdr_len = frag_desc->ip_len + frag_desc->trans_len;
+
+		head_skb = alloc_skb(hdr_len + RMNET_MAP_DESC_HEADROOM,
+				     GFP_ATOMIC);
+		if (!head_skb)
+			return NULL;
+
+		skb_reserve(head_skb, RMNET_MAP_DESC_HEADROOM);
+		skb_put_data(head_skb, frag_desc->hdr_ptr, hdr_len);
+		skb_reset_network_header(head_skb);
+
+		if (frag_desc->trans_len)
+			skb_set_transport_header(head_skb, frag_desc->ip_len);
+
+		/* Packets that have no data portion don't need any frags */
+		if (hdr_len == skb_frag_size(&frag_desc->frag))
+			goto skip_frags;
+
+		/* If the headers we added are the start of the page,
+		 * we don't want to add them twice
+		 */
+		if (frag_desc->hdr_ptr == rmnet_frag_data_ptr(frag_desc)) {
+			if (!rmnet_frag_pull(frag_desc, port, hdr_len)) {
+				kfree_skb(head_skb);
+				return NULL;
+			}
+		}
+	} else {
+		/* Allocate enough space to avoid penalties in the stack
+		 * from __pskb_pull_tail()
+		 */
+		head_skb = alloc_skb(256 + RMNET_MAP_DESC_HEADROOM,
+				     GFP_ATOMIC);
+		if (!head_skb)
+			return NULL;
+
+		skb_reserve(head_skb, RMNET_MAP_DESC_HEADROOM);
+	}
+
+	/* Add main fragment */
+	get_page(skb_frag_page(&frag_desc->frag));
+	skb_add_rx_frag(head_skb, 0, skb_frag_page(&frag_desc->frag),
+			frag_desc->frag.bv_offset,
+			skb_frag_size(&frag_desc->frag),
+			skb_frag_size(&frag_desc->frag));
+
+	shinfo = skb_shinfo(head_skb);
+	current_skb = head_skb;
+
+	/* Add in any frags from rmnet_perf */
+	list_for_each_entry_safe(sub_frag, tmp, &frag_desc->sub_frags, list) {
+		skb_frag_t *frag;
+		u32 frag_size;
+
+		frag = &sub_frag->frag;
+		frag_size = skb_frag_size(frag);
+
+add_frag:
+		if (shinfo->nr_frags < MAX_SKB_FRAGS) {
+			get_page(skb_frag_page(frag));
+			skb_add_rx_frag(current_skb, shinfo->nr_frags,
+					skb_frag_page(frag), frag->bv_offset,
+					frag_size, frag_size);
+			if (current_skb != head_skb) {
+				head_skb->len += frag_size;
+				head_skb->data_len += frag_size;
+			}
+		} else {
+			/* Alloc a new skb and try again */
+			skb = alloc_skb(0, GFP_ATOMIC);
+			if (!skb)
+				break;
+
+			if (current_skb == head_skb)
+				shinfo->frag_list = skb;
+			else
+				current_skb->next = skb;
+
+			current_skb = skb;
+			shinfo = skb_shinfo(current_skb);
+			goto add_frag;
+		}
+
+		rmnet_recycle_frag_descriptor(sub_frag, port);
+	}
+
+skip_frags:
+	head_skb->dev = frag_desc->dev;
+	rmnet_set_skb_proto(head_skb);
+
+	/* Handle any header metadata that needs to be updated after RSB/RSC
+	 * segmentation
+	 */
+	if (frag_desc->ip_id_set) {
+		struct iphdr *iph;
+
+		iph = (struct iphdr *)rmnet_map_data_ptr(head_skb);
+		csum_replace2(&iph->check, iph->id, frag_desc->ip_id);
+		iph->id = frag_desc->ip_id;
+	}
+
+	if (frag_desc->tcp_seq_set) {
+		struct tcphdr *th;
+
+		th = (struct tcphdr *)
+		     (rmnet_map_data_ptr(head_skb) + frag_desc->ip_len);
+		th->seq = frag_desc->tcp_seq;
+	}
+
+	/* Handle csum offloading */
+	if (frag_desc->csum_valid && frag_desc->hdrs_valid) {
+		/* Set the partial checksum information */
+		rmnet_frag_partial_csum(head_skb, frag_desc);
+	} else if (frag_desc->csum_valid) {
+		/* Non-RSB/RSC/perf packet. The current checksum is fine */
+		head_skb->ip_summed = CHECKSUM_UNNECESSARY;
+	} else if (frag_desc->hdrs_valid &&
+		   (frag_desc->trans_proto == IPPROTO_TCP ||
+		    frag_desc->trans_proto == IPPROTO_UDP)) {
+		/* Unfortunately, we have to fake a bad checksum here, since
+		 * the original bad value is lost by the hardware. The only
+		 * reliable way to do it is to calculate the actual checksum
+		 * and corrupt it.
+		 */
+		__sum16 *check;
+		__wsum csum;
+		unsigned int offset = skb_transport_offset(head_skb);
+		__sum16 pseudo;
+
+		/* Calculate pseudo header and update header fields */
+		if (frag_desc->ip_proto == 4) {
+			struct iphdr *iph = ip_hdr(head_skb);
+			__be16 tot_len = htons(head_skb->len);
+
+			csum_replace2(&iph->check, iph->tot_len, tot_len);
+			iph->tot_len = tot_len;
+			pseudo = ~csum_tcpudp_magic(iph->saddr, iph->daddr,
+						    head_skb->len -
+						    frag_desc->ip_len,
+						    frag_desc->trans_proto, 0);
+		} else {
+			struct ipv6hdr *ip6h = ipv6_hdr(head_skb);
+
+			ip6h->payload_len = htons(head_skb->len -
+						  sizeof(*ip6h));
+			pseudo = ~csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
+						  head_skb->len -
+						  frag_desc->ip_len,
+						  frag_desc->trans_proto, 0);
+		}
+
+		if (frag_desc->trans_proto == IPPROTO_TCP) {
+			check = &tcp_hdr(head_skb)->check;
+		} else {
+			udp_hdr(head_skb)->len = htons(head_skb->len -
+						       frag_desc->ip_len);
+			check = &udp_hdr(head_skb)->check;
+		}
+
+		*check = pseudo;
+		csum = skb_checksum(head_skb, offset, head_skb->len - offset,
+				    0);
+		/* Add 1 to corrupt. This cannot produce a final value of 0
+		 * since csum_fold() can't return a value of 0xFFFF
+		 */
+		*check = csum16_add(csum_fold(csum), htons(1));
+		head_skb->ip_summed = CHECKSUM_NONE;
+	}
+
+	/* Handle any rmnet_perf metadata */
+	if (frag_desc->hash) {
+		head_skb->hash = frag_desc->hash;
+		head_skb->sw_hash = 1;
+	}
+
+	if (frag_desc->flush_shs)
+		head_skb->cb[0] = 1;
+
+	/* Handle coalesced packets */
+	if (frag_desc->gso_segs > 1)
+		rmnet_frag_gso_stamp(head_skb, frag_desc);
+
+	return head_skb;
+}
+
+/* Deliver the packets contained within a frag descriptor */
+void rmnet_frag_deliver(struct rmnet_frag_descriptor *frag_desc,
+			struct rmnet_port *port)
+{
+	struct sk_buff *skb;
+
+	skb = rmnet_alloc_skb(frag_desc, port);
+	if (skb)
+		rmnet_deliver_skb(skb, port);
+	rmnet_recycle_frag_descriptor(frag_desc, port);
+}
+EXPORT_SYMBOL(rmnet_frag_deliver);
+
+static void __rmnet_frag_segment_data(struct rmnet_frag_descriptor *coal_desc,
+				      struct rmnet_port *port,
+				      struct list_head *list, u8 pkt_id,
+				      bool csum_valid)
+{
+	struct rmnet_priv *priv = netdev_priv(coal_desc->dev);
+	struct rmnet_frag_descriptor *new_frag;
+	u8 *hdr_start = rmnet_frag_data_ptr(coal_desc);
+	u32 offset;
+
+	new_frag = rmnet_get_frag_descriptor(port);
+	if (!new_frag)
+		return;
+
+	/* Account for header lengths to access the data start */
+	offset = coal_desc->frag.bv_offset + coal_desc->ip_len +
+		 coal_desc->trans_len + coal_desc->data_offset;
+
+	/* Header information and most metadata is the same as the original */
+	memcpy(new_frag, coal_desc, sizeof(*coal_desc));
+	INIT_LIST_HEAD(&new_frag->list);
+	INIT_LIST_HEAD(&new_frag->sub_frags);
+	rmnet_frag_fill(new_frag, skb_frag_page(&coal_desc->frag), offset,
+			coal_desc->gso_size * coal_desc->gso_segs);
+
+	if (coal_desc->trans_proto == IPPROTO_TCP) {
+		struct tcphdr *th;
+
+		th = (struct tcphdr *)(hdr_start + coal_desc->ip_len);
+		new_frag->tcp_seq_set = 1;
+		new_frag->tcp_seq = htonl(ntohl(th->seq) +
+					  coal_desc->data_offset);
+	}
+
+	if (coal_desc->ip_proto == 4) {
+		struct iphdr *iph;
+
+		iph = (struct iphdr *)hdr_start;
+		new_frag->ip_id_set = 1;
+		new_frag->ip_id = htons(ntohs(iph->id) + coal_desc->pkt_id);
+	}
+
+	new_frag->hdr_ptr = hdr_start;
+	new_frag->csum_valid = csum_valid;
+	priv->stats.coal.coal_reconstruct++;
+
+	/* Update meta information to move past the data we just segmented */
+	coal_desc->data_offset += coal_desc->gso_size * coal_desc->gso_segs;
+	coal_desc->pkt_id = pkt_id + 1;
+	coal_desc->gso_segs = 0;
+
+	list_add_tail(&new_frag->list, list);
+}
+
+static bool rmnet_frag_validate_csum(struct rmnet_frag_descriptor *frag_desc)
+{
+	u8 *data = rmnet_frag_data_ptr(frag_desc);
+	unsigned int datagram_len;
+	__wsum csum;
+	__sum16 pseudo;
+
+	datagram_len = skb_frag_size(&frag_desc->frag) - frag_desc->ip_len;
+	if (frag_desc->ip_proto == 4) {
+		struct iphdr *iph = (struct iphdr *)data;
+
+		pseudo = ~csum_tcpudp_magic(iph->saddr, iph->daddr,
+					    datagram_len,
+					    frag_desc->trans_proto, 0);
+	} else {
+		struct ipv6hdr *ip6h = (struct ipv6hdr *)data;
+
+		pseudo = ~csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
+					  datagram_len, frag_desc->trans_proto,
+					  0);
+	}
+
+	csum = csum_partial(data + frag_desc->ip_len, datagram_len,
+			    csum_unfold(pseudo));
+	return !csum_fold(csum);
+}
+
+/* Converts the coalesced frame into a list of descriptors.
+ * NLOs containing csum erros will not be included.
+ */
+static void
+rmnet_frag_segment_coal_data(struct rmnet_frag_descriptor *coal_desc,
+			     u64 nlo_err_mask, struct rmnet_port *port,
+			     struct list_head *list)
+{
+	struct iphdr *iph;
+	struct rmnet_priv *priv = netdev_priv(coal_desc->dev);
+	struct rmnet_map_v5_coal_header *coal_hdr;
+	u16 pkt_len;
+	u8 pkt, total_pkt = 0;
+	u8 nlo;
+	bool gro = coal_desc->dev->features & NETIF_F_GRO_HW;
+
+	/* Pull off the headers we no longer need */
+	if (!rmnet_frag_pull(coal_desc, port, sizeof(struct rmnet_map_header)))
+		return;
+
+	coal_hdr = (struct rmnet_map_v5_coal_header *)
+		   rmnet_frag_data_ptr(coal_desc);
+	if (!rmnet_frag_pull(coal_desc, port, sizeof(*coal_hdr)))
+		return;
+
+	iph = (struct iphdr *)rmnet_frag_data_ptr(coal_desc);
+
+	if (iph->version == 4) {
+		coal_desc->ip_proto = 4;
+		coal_desc->ip_len = iph->ihl * 4;
+		coal_desc->trans_proto = iph->protocol;
+
+		/* Don't allow coalescing of any packets with IP options */
+		if (iph->ihl != 5)
+			gro = false;
+	} else if (iph->version == 6) {
+		struct ipv6hdr *ip6h = (struct ipv6hdr *)iph;
+		__be16 frag_off;
+		u8 protocol = ip6h->nexthdr;
+
+		coal_desc->ip_proto = 6;
+		coal_desc->ip_len = rmnet_frag_ipv6_skip_exthdr(coal_desc,
+								sizeof(*ip6h),
+								&protocol,
+								&frag_off);
+		coal_desc->trans_proto = protocol;
+
+		/* If we run into a problem, or this has a fragment header
+		 * (which should technically not be possible, if the HW
+		 * works as intended...), bail.
+		 */
+		if (coal_desc->ip_len < 0 || frag_off) {
+			priv->stats.coal.coal_ip_invalid++;
+			return;
+		} else if (coal_desc->ip_len > sizeof(*ip6h)) {
+			/* Don't allow coalescing of any packets with IPv6
+			 * extension headers.
+			 */
+			gro = false;
+		}
+	} else {
+		priv->stats.coal.coal_ip_invalid++;
+		return;
+	}
+
+	if (coal_desc->trans_proto == IPPROTO_TCP) {
+		struct tcphdr *th;
+
+		th = (struct tcphdr *)((u8 *)iph + coal_desc->ip_len);
+		coal_desc->trans_len = th->doff * 4;
+	} else if (coal_desc->trans_proto == IPPROTO_UDP) {
+		coal_desc->trans_len = sizeof(struct udphdr);
+	} else {
+		priv->stats.coal.coal_trans_invalid++;
+		return;
+	}
+
+	coal_desc->hdrs_valid = 1;
+
+	if (rmnet_map_v5_csum_buggy(coal_hdr)) {
+		/* Mark the checksum as valid if it checks out */
+		if (rmnet_frag_validate_csum(coal_desc))
+			coal_desc->csum_valid = true;
+
+		coal_desc->hdr_ptr = rmnet_frag_data_ptr(coal_desc);
+		coal_desc->gso_size = ntohs(coal_hdr->nl_pairs[0].pkt_len);
+		coal_desc->gso_size -= coal_desc->ip_len + coal_desc->trans_len;
+		coal_desc->gso_segs = coal_hdr->nl_pairs[0].num_packets;
+		list_add_tail(&coal_desc->list, list);
+		return;
+	}
+
+	/* Fast-forward the case where we have 1 NLO (i.e. 1 packet length),
+	 * no checksum errors, and are allowing GRO. We can just reuse this
+	 * descriptor unchanged.
+	 */
+	if (gro && coal_hdr->num_nlos == 1 && coal_hdr->csum_valid) {
+		coal_desc->csum_valid = true;
+		coal_desc->hdr_ptr = rmnet_frag_data_ptr(coal_desc);
+		coal_desc->gso_size = ntohs(coal_hdr->nl_pairs[0].pkt_len);
+		coal_desc->gso_size -= coal_desc->ip_len + coal_desc->trans_len;
+		coal_desc->gso_segs = coal_hdr->nl_pairs[0].num_packets;
+		list_add_tail(&coal_desc->list, list);
+		return;
+	}
+
+	/* Segment the coalesced descriptor into new packets */
+	for (nlo = 0; nlo < coal_hdr->num_nlos; nlo++) {
+		pkt_len = ntohs(coal_hdr->nl_pairs[nlo].pkt_len);
+		pkt_len -= coal_desc->ip_len + coal_desc->trans_len;
+		coal_desc->gso_size = pkt_len;
+		for (pkt = 0; pkt < coal_hdr->nl_pairs[nlo].num_packets;
+		     pkt++, total_pkt++, nlo_err_mask >>= 1) {
+			bool csum_err = nlo_err_mask & 1;
+
+			/* Segment the packet if we're not sending the larger
+			 * packet up the stack.
+			 */
+			if (!gro) {
+				coal_desc->gso_segs = 1;
+				if (csum_err)
+					priv->stats.coal.coal_csum_err++;
+
+				__rmnet_frag_segment_data(coal_desc, port,
+							  list, total_pkt,
+							  !csum_err);
+				continue;
+			}
+
+			if (csum_err) {
+				priv->stats.coal.coal_csum_err++;
+
+				/* Segment out the good data */
+				if (coal_desc->gso_segs)
+					__rmnet_frag_segment_data(coal_desc,
+								  port,
+								  list,
+								  total_pkt,
+								  true);
+
+				/* Segment out the bad checksum */
+				coal_desc->gso_segs = 1;
+				__rmnet_frag_segment_data(coal_desc, port,
+							  list, total_pkt,
+							  false);
+			} else {
+				coal_desc->gso_segs++;
+			}
+		}
+
+		/* If we're switching NLOs, we need to send out everything from
+		 * the previous one, if we haven't done so. NLOs only switch
+		 * when the packet length changes.
+		 */
+		if (coal_desc->gso_segs)
+			__rmnet_frag_segment_data(coal_desc, port, list,
+						  total_pkt, true);
+	}
+}
+
+/* Record reason for coalescing pipe closure */
+static void rmnet_frag_data_log_close_stats(struct rmnet_priv *priv, u8 type,
+					    u8 code)
+{
+	struct rmnet_coal_close_stats *stats = &priv->stats.coal.close;
+
+	switch (type) {
+	case RMNET_MAP_COAL_CLOSE_NON_COAL:
+		stats->non_coal++;
+		break;
+	case RMNET_MAP_COAL_CLOSE_IP_MISS:
+		stats->ip_miss++;
+		break;
+	case RMNET_MAP_COAL_CLOSE_TRANS_MISS:
+		stats->trans_miss++;
+		break;
+	case RMNET_MAP_COAL_CLOSE_HW:
+		switch (code) {
+		case RMNET_MAP_COAL_CLOSE_HW_NL:
+			stats->hw_nl++;
+			break;
+		case RMNET_MAP_COAL_CLOSE_HW_PKT:
+			stats->hw_pkt++;
+			break;
+		case RMNET_MAP_COAL_CLOSE_HW_BYTE:
+			stats->hw_byte++;
+			break;
+		case RMNET_MAP_COAL_CLOSE_HW_TIME:
+			stats->hw_time++;
+			break;
+		case RMNET_MAP_COAL_CLOSE_HW_EVICT:
+			stats->hw_evict++;
+			break;
+		default:
+			break;
+		}
+		break;
+	case RMNET_MAP_COAL_CLOSE_COAL:
+		stats->coal++;
+		break;
+	default:
+		break;
+	}
+}
+
+/* Check if the coalesced header has any incorrect values, in which case, the
+ * entire coalesced frame must be dropped. Then check if there are any
+ * checksum issues
+ */
+static int
+rmnet_frag_data_check_coal_header(struct rmnet_frag_descriptor *frag_desc,
+				  u64 *nlo_err_mask)
+{
+	struct rmnet_map_v5_coal_header *coal_hdr;
+	unsigned char *data = rmnet_frag_data_ptr(frag_desc);
+	struct rmnet_priv *priv = netdev_priv(frag_desc->dev);
+	u64 mask = 0;
+	int i;
+	u8 veid, pkts = 0;
+
+	coal_hdr = (struct rmnet_map_v5_coal_header *)
+		   (data + sizeof(struct rmnet_map_header));
+	veid = coal_hdr->virtual_channel_id;
+
+	if (coal_hdr->num_nlos == 0 ||
+	    coal_hdr->num_nlos > RMNET_MAP_V5_MAX_NLOS) {
+		priv->stats.coal.coal_hdr_nlo_err++;
+		return -EINVAL;
+	}
+
+	for (i = 0; i < RMNET_MAP_V5_MAX_NLOS; i++) {
+		/* If there is a checksum issue, we need to split
+		 * up the skb. Rebuild the full csum error field
+		 */
+		u8 err = coal_hdr->nl_pairs[i].csum_error_bitmap;
+		u8 pkt = coal_hdr->nl_pairs[i].num_packets;
+
+		mask |= ((u64)err) << (8 * i);
+
+		/* Track total packets in frame */
+		pkts += pkt;
+		if (pkts > RMNET_MAP_V5_MAX_PACKETS) {
+			priv->stats.coal.coal_hdr_pkt_err++;
+			return -EINVAL;
+		}
+	}
+
+	/* Track number of packets we get inside of coalesced frames */
+	priv->stats.coal.coal_pkts += pkts;
+
+	/* Update ethtool stats */
+	rmnet_frag_data_log_close_stats(priv,
+					coal_hdr->close_type,
+					coal_hdr->close_value);
+	if (veid < RMNET_MAX_VEID)
+		priv->stats.coal.coal_veid[veid]++;
+
+	*nlo_err_mask = mask;
+
+	return 0;
+}
+
+/* Process a QMAPv5 packet header */
+int rmnet_frag_process_next_hdr_packet(struct rmnet_frag_descriptor *frag_desc,
+				       struct rmnet_port *port,
+				       struct list_head *list,
+				       u16 len)
+{
+	struct rmnet_priv *priv = netdev_priv(frag_desc->dev);
+	u64 nlo_err_mask;
+	int rc = 0;
+
+	switch (rmnet_frag_get_next_hdr_type(frag_desc)) {
+	case RMNET_MAP_HEADER_TYPE_COALESCING:
+		priv->stats.coal.coal_rx++;
+		rc = rmnet_frag_data_check_coal_header(frag_desc,
+						       &nlo_err_mask);
+		if (rc)
+			return rc;
+
+		rmnet_frag_segment_coal_data(frag_desc, nlo_err_mask, port,
+					     list);
+		if (list_first_entry(list, struct rmnet_frag_descriptor,
+				     list) != frag_desc)
+			rmnet_recycle_frag_descriptor(frag_desc, port);
+		break;
+	case RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD:
+		if (rmnet_frag_get_csum_valid(frag_desc)) {
+			priv->stats.csum_ok++;
+			frag_desc->csum_valid = true;
+		} else {
+			priv->stats.csum_valid_unset++;
+		}
+
+		if (!rmnet_frag_pull(frag_desc, port,
+				     sizeof(struct rmnet_map_header) +
+				     sizeof(struct rmnet_map_v5_csum_header))) {
+			rc = -EINVAL;
+			break;
+		}
+
+		frag_desc->hdr_ptr = rmnet_frag_data_ptr(frag_desc);
+
+		/* Remove padding only for csum offload packets.
+		 * Coalesced packets should never have padding.
+		 */
+		if (!rmnet_frag_trim(frag_desc, port, len)) {
+			rc = -EINVAL;
+			break;
+		}
+
+		list_del_init(&frag_desc->list);
+		list_add_tail(&frag_desc->list, list);
+		break;
+	default:
+		rc = -EINVAL;
+		break;
+	}
+
+	return rc;
+}
+
+/* Perf hook handler */
+rmnet_perf_desc_hook_t rmnet_perf_desc_entry __rcu __read_mostly;
+
+static void
+__rmnet_frag_ingress_handler(struct rmnet_frag_descriptor *frag_desc,
+			     struct rmnet_port *port)
+{
+	rmnet_perf_desc_hook_t rmnet_perf_ingress;
+	struct rmnet_map_header *qmap;
+	struct rmnet_endpoint *ep;
+	struct rmnet_frag_descriptor *frag, *tmp;
+	LIST_HEAD(segs);
+	u16 len, pad;
+	u8 mux_id;
+
+	qmap = (struct rmnet_map_header *)skb_frag_address(&frag_desc->frag);
+	mux_id = qmap->mux_id;
+	pad = qmap->pad_len;
+	len = ntohs(qmap->pkt_len) - pad;
+
+	if (qmap->cd_bit) {
+		if (port->data_format & RMNET_INGRESS_FORMAT_DL_MARKER) {
+			rmnet_frag_flow_command(qmap, port, len);
+			goto recycle;
+		}
+
+		if (port->data_format & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
+			rmnet_frag_command(qmap, port);
+
+		goto recycle;
+	}
+
+	if (mux_id >= RMNET_MAX_LOGICAL_EP)
+		goto recycle;
+
+	ep = rmnet_get_endpoint(port, mux_id);
+	if (!ep)
+		goto recycle;
+
+	frag_desc->dev = ep->egress_dev;
+
+	/* Handle QMAPv5 packet */
+	if (qmap->next_hdr &&
+	    (port->data_format & (RMNET_FLAGS_INGRESS_COALESCE |
+				  RMNET_FLAGS_INGRESS_MAP_CKSUMV5))) {
+		if (rmnet_frag_process_next_hdr_packet(frag_desc, port, &segs,
+						       len))
+			goto recycle;
+	} else {
+		/* We only have the main QMAP header to worry about */
+		if (!rmnet_frag_pull(frag_desc, port, sizeof(*qmap)))
+			return;
+
+		frag_desc->hdr_ptr = rmnet_frag_data_ptr(frag_desc);
+
+		if (!rmnet_frag_trim(frag_desc, port, len))
+			return;
+
+		list_add_tail(&frag_desc->list, &segs);
+	}
+
+	rcu_read_lock();
+	rmnet_perf_ingress = rcu_dereference(rmnet_perf_desc_entry);
+	if (rmnet_perf_ingress) {
+		list_for_each_entry_safe(frag, tmp, &segs, list) {
+			list_del_init(&frag->list);
+			rmnet_perf_ingress(frag, port);
+		}
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	list_for_each_entry_safe(frag, tmp, &segs, list) {
+		list_del_init(&frag->list);
+		rmnet_frag_deliver(frag, port);
+	}
+	return;
+
+recycle:
+	rmnet_recycle_frag_descriptor(frag_desc, port);
+}
+
+/* Notify perf at the end of SKB chain */
+rmnet_perf_chain_hook_t rmnet_perf_chain_end __rcu __read_mostly;
+
+void rmnet_frag_ingress_handler(struct sk_buff *skb,
+				struct rmnet_port *port)
+{
+	rmnet_perf_chain_hook_t rmnet_perf_opt_chain_end;
+	LIST_HEAD(desc_list);
+	int i = 0;
+
+	/* Deaggregation and freeing of HW originating
+	 * buffers is done within here
+	 */
+	while (skb) {
+		struct sk_buff *skb_frag;
+
+		port->chain_head = NULL;
+		port->chain_tail = NULL;
+
+		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+			rmnet_frag_deaggregate(&skb_shinfo(skb)->frags[i], port,
+					       &desc_list);
+			if (!list_empty(&desc_list)) {
+				struct rmnet_frag_descriptor *frag_desc, *tmp;
+
+				list_for_each_entry_safe(frag_desc, tmp,
+							 &desc_list, list) {
+					list_del_init(&frag_desc->list);
+					__rmnet_frag_ingress_handler(frag_desc,
+								     port);
+				}
+			}
+		}
+
+		skb_frag = skb_shinfo(skb)->frag_list;
+		skb_shinfo(skb)->frag_list = NULL;
+		consume_skb(skb);
+		skb = skb_frag;
+	}
+
+	rcu_read_lock();
+	rmnet_perf_opt_chain_end = rcu_dereference(rmnet_perf_chain_end);
+	if (rmnet_perf_opt_chain_end)
+		rmnet_perf_opt_chain_end();
+	rcu_read_unlock();
+}
+
+void rmnet_descriptor_deinit(struct rmnet_port *port)
+{
+	struct rmnet_frag_descriptor_pool *pool;
+	struct rmnet_frag_descriptor *frag_desc, *tmp;
+
+	pool = port->frag_desc_pool;
+
+	list_for_each_entry_safe(frag_desc, tmp, &pool->free_list, list) {
+		kfree(frag_desc);
+		pool->pool_size--;
+	}
+
+	kfree(pool);
+}
+
+int rmnet_descriptor_init(struct rmnet_port *port)
+{
+	struct rmnet_frag_descriptor_pool *pool;
+	int i;
+
+	spin_lock_init(&port->desc_pool_lock);
+	pool = kzalloc(sizeof(*pool), GFP_ATOMIC);
+	if (!pool)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&pool->free_list);
+	port->frag_desc_pool = pool;
+
+	for (i = 0; i < RMNET_FRAG_DESCRIPTOR_POOL_SIZE; i++) {
+		struct rmnet_frag_descriptor *frag_desc;
+
+		frag_desc = kzalloc(sizeof(*frag_desc), GFP_ATOMIC);
+		if (!frag_desc)
+			return -ENOMEM;
+
+		INIT_LIST_HEAD(&frag_desc->list);
+		INIT_LIST_HEAD(&frag_desc->sub_frags);
+		list_add_tail(&frag_desc->list, &pool->free_list);
+		pool->pool_size++;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_descriptor.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_descriptor.h
new file mode 100644
index 000000000000..0f170aaef3d6
--- /dev/null
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_descriptor.h
@@ -0,0 +1,152 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2013-2019, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * RMNET Packet Descriptor Framework
+ *
+ */
+
+#ifndef _RMNET_DESCRIPTOR_H_
+#define _RMNET_DESCRIPTOR_H_
+
+#include <linux/netdevice.h>
+#include <linux/list.h>
+#include <linux/skbuff.h>
+#include "rmnet_config.h"
+#include "rmnet_map.h"
+
+struct rmnet_frag_descriptor_pool {
+	struct list_head free_list;
+	u32 pool_size;
+};
+
+struct rmnet_frag_descriptor {
+	struct list_head list;
+	struct list_head sub_frags;
+	skb_frag_t frag;
+	u8 *hdr_ptr;
+	struct net_device *dev;
+	u32 hash;
+	__be32 tcp_seq;
+	__be16 ip_id;
+	u16 data_offset;
+	u16 gso_size;
+	u16 gso_segs;
+	u16 ip_len;
+	u16 trans_len;
+	u8 ip_proto;
+	u8 trans_proto;
+	u8 pkt_id;
+	u8 csum_valid:1,
+	   hdrs_valid:1,
+	   ip_id_set:1,
+	   tcp_seq_set:1,
+	   flush_shs:1,
+	   reserved:3;
+};
+
+/* Descriptor management */
+struct rmnet_frag_descriptor *
+rmnet_get_frag_descriptor(struct rmnet_port *port);
+void rmnet_recycle_frag_descriptor(struct rmnet_frag_descriptor *frag_desc,
+				   struct rmnet_port *port);
+void rmnet_descriptor_add_frag(struct rmnet_port *port, struct list_head *list,
+			       struct page *p, u32 bv_offset, u32 len);
+int rmnet_frag_ipv6_skip_exthdr(struct rmnet_frag_descriptor *frag_desc,
+				int start, u8 *nexthdrp, __be16 *fragp);
+
+/* QMAP command packets */
+void rmnet_frag_command(struct rmnet_map_header *qmap, struct rmnet_port *port);
+int rmnet_frag_flow_command(struct rmnet_map_header *qmap,
+			    struct rmnet_port *port, u16 pkt_len);
+
+/* Ingress data handlers */
+void rmnet_frag_deaggregate(skb_frag_t *frag, struct rmnet_port *port,
+			    struct list_head *list);
+void rmnet_frag_deliver(struct rmnet_frag_descriptor *frag_desc,
+			struct rmnet_port *port);
+int rmnet_frag_process_next_hdr_packet(struct rmnet_frag_descriptor *frag_desc,
+				       struct rmnet_port *port,
+				       struct list_head *list,
+				       u16 len);
+void rmnet_frag_ingress_handler(struct sk_buff *skb,
+				struct rmnet_port *port);
+
+int rmnet_descriptor_init(struct rmnet_port *port);
+void rmnet_descriptor_deinit(struct rmnet_port *port);
+
+static inline void *rmnet_frag_data_ptr(struct rmnet_frag_descriptor *frag_desc)
+{
+	return skb_frag_address(&frag_desc->frag);
+}
+
+static inline void *rmnet_frag_pull(struct rmnet_frag_descriptor *frag_desc,
+				    struct rmnet_port *port,
+				    unsigned int size)
+{
+	if (size >= skb_frag_size(&frag_desc->frag)) {
+		pr_info("%s(): Pulling %u bytes from %u byte pkt. Dropping\n",
+			__func__, size, skb_frag_size(&frag_desc->frag));
+		rmnet_recycle_frag_descriptor(frag_desc, port);
+		return NULL;
+	}
+
+	frag_desc->frag.bv_offset += size;
+	skb_frag_size_sub(&frag_desc->frag, size);
+
+	return rmnet_frag_data_ptr(frag_desc);
+}
+
+static inline void *rmnet_frag_trim(struct rmnet_frag_descriptor *frag_desc,
+				    struct rmnet_port *port,
+				    unsigned int size)
+{
+	if (!size) {
+		pr_info("%s(): Trimming %u byte pkt to 0. Dropping\n",
+			__func__, skb_frag_size(&frag_desc->frag));
+		rmnet_recycle_frag_descriptor(frag_desc, port);
+		return NULL;
+	}
+
+	if (size < skb_frag_size(&frag_desc->frag))
+		skb_frag_size_set(&frag_desc->frag, size);
+
+	return rmnet_frag_data_ptr(frag_desc);
+}
+
+static inline void rmnet_frag_fill(struct rmnet_frag_descriptor *frag_desc,
+				   struct page *p, u32 bv_offset, u32 len)
+{
+	get_page(p);
+	__skb_frag_set_page(&frag_desc->frag, p);
+	skb_frag_size_set(&frag_desc->frag, len);
+	frag_desc->frag.bv_offset = bv_offset;
+}
+
+static inline u8
+rmnet_frag_get_next_hdr_type(struct rmnet_frag_descriptor *frag_desc)
+{
+	unsigned char *data = rmnet_frag_data_ptr(frag_desc);
+
+	data += sizeof(struct rmnet_map_header);
+	return ((struct rmnet_map_v5_coal_header *)data)->header_type;
+}
+
+static inline bool
+rmnet_frag_get_csum_valid(struct rmnet_frag_descriptor *frag_desc)
+{
+	unsigned char *data = rmnet_frag_data_ptr(frag_desc);
+
+	data += sizeof(struct rmnet_map_header);
+	return ((struct rmnet_map_v5_csum_header *)data)->csum_valid_required;
+}
+
+#endif /* _RMNET_DESCRIPTOR_H_ */
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 1b74bc160402..5249a6913cf9 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -1,27 +1,77 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2019, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
  * RMNET Data ingress/egress handler
+ *
  */
 
 #include <linux/netdevice.h>
 #include <linux/netdev_features.h>
 #include <linux/if_arp.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
 #include <net/sock.h>
+#include <linux/tracepoint.h>
 #include "rmnet_private.h"
 #include "rmnet_config.h"
 #include "rmnet_vnd.h"
 #include "rmnet_map.h"
 #include "rmnet_handlers.h"
+#include "rmnet_descriptor.h"
 
 #define RMNET_IP_VERSION_4 0x40
 #define RMNET_IP_VERSION_6 0x60
+#define CREATE_TRACE_POINTS
+#include "rmnet_trace.h"
+
+EXPORT_TRACEPOINT_SYMBOL(rmnet_shs_low);
+EXPORT_TRACEPOINT_SYMBOL(rmnet_shs_high);
+EXPORT_TRACEPOINT_SYMBOL(rmnet_shs_err);
+EXPORT_TRACEPOINT_SYMBOL(rmnet_shs_wq_low);
+EXPORT_TRACEPOINT_SYMBOL(rmnet_shs_wq_high);
+EXPORT_TRACEPOINT_SYMBOL(rmnet_shs_wq_err);
+EXPORT_TRACEPOINT_SYMBOL(rmnet_perf_low);
+EXPORT_TRACEPOINT_SYMBOL(rmnet_perf_high);
+EXPORT_TRACEPOINT_SYMBOL(rmnet_perf_err);
+EXPORT_TRACEPOINT_SYMBOL(rmnet_low);
+EXPORT_TRACEPOINT_SYMBOL(rmnet_high);
+EXPORT_TRACEPOINT_SYMBOL(rmnet_err);
+EXPORT_TRACEPOINT_SYMBOL(rmnet_freq_update);
+EXPORT_TRACEPOINT_SYMBOL(rmnet_freq_reset);
+EXPORT_TRACEPOINT_SYMBOL(rmnet_freq_boost);
 
 /* Helper Functions */
 
-static void rmnet_set_skb_proto(struct sk_buff *skb)
+static int rmnet_check_skb_can_gro(struct sk_buff *skb)
+{
+	unsigned char *data = rmnet_map_data_ptr(skb);
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		if (((struct iphdr *)data)->protocol == IPPROTO_TCP)
+			return 0;
+		break;
+	case htons(ETH_P_IPV6):
+		if (((struct ipv6hdr *)data)->nexthdr == IPPROTO_TCP)
+			return 0;
+		fallthrough;
+	}
+
+	return -EPROTONOSUPPORT;
+}
+
+void rmnet_set_skb_proto(struct sk_buff *skb)
 {
-	switch (skb->data[0] & 0xF0) {
+	switch (rmnet_map_data_ptr(skb)[0] & 0xF0) {
 	case RMNET_IP_VERSION_4:
 		skb->protocol = htons(ETH_P_IP);
 		break;
@@ -33,21 +83,130 @@ static void rmnet_set_skb_proto(struct sk_buff *skb)
 		break;
 	}
 }
+EXPORT_SYMBOL(rmnet_set_skb_proto);
+
+/* Shs hook handler */
+int (*rmnet_shs_skb_entry)(struct sk_buff *skb,
+			   struct rmnet_port *port) __rcu __read_mostly;
+EXPORT_SYMBOL(rmnet_shs_skb_entry);
+
+/* Shs hook handler for work queue*/
+int (*rmnet_shs_skb_entry_wq)(struct sk_buff *skb,
+			      struct rmnet_port *port) __rcu __read_mostly;
+EXPORT_SYMBOL(rmnet_shs_skb_entry_wq);
 
 /* Generic handler */
 
-static void
-rmnet_deliver_skb(struct sk_buff *skb)
+void
+rmnet_deliver_skb(struct sk_buff *skb, struct rmnet_port *port)
 {
+	int (*rmnet_shs_stamp)(struct sk_buff *skb, struct rmnet_port *port);
 	struct rmnet_priv *priv = netdev_priv(skb->dev);
 
+	trace_rmnet_low(RMNET_MODULE, RMNET_DLVR_SKB, 0xDEF, 0xDEF,
+			0xDEF, 0xDEF, (void *)skb, NULL);
+
 	skb_reset_transport_header(skb);
 	skb_reset_network_header(skb);
-	rmnet_vnd_rx_fixup(skb, skb->dev);
+	rmnet_vnd_rx_fixup(skb->dev, skb->len);
 
 	skb->pkt_type = PACKET_HOST;
 	skb_set_mac_header(skb, 0);
-	gro_cells_receive(&priv->gro_cells, skb);
+
+	rcu_read_lock();
+	rmnet_shs_stamp = rcu_dereference(rmnet_shs_skb_entry);
+	if (rmnet_shs_stamp) {
+		rmnet_shs_stamp(skb, port);
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	if (port->data_format & RMNET_INGRESS_FORMAT_DL_MARKER) {
+		if (!rmnet_check_skb_can_gro(skb) &&
+		    port->dl_marker_flush >= 0) {
+			struct napi_struct *napi = get_current_napi_context();
+
+			napi_gro_receive(napi, skb);
+			port->dl_marker_flush++;
+		} else {
+			netif_receive_skb(skb);
+		}
+	} else {
+		if (!rmnet_check_skb_can_gro(skb))
+			gro_cells_receive(&priv->gro_cells, skb);
+		else
+			netif_receive_skb(skb);
+	}
+}
+EXPORT_SYMBOL(rmnet_deliver_skb);
+
+/* Important to note, port cannot be used here if it has gone stale */
+void
+rmnet_deliver_skb_wq(struct sk_buff *skb, struct rmnet_port *port,
+		     enum rmnet_packet_context ctx)
+{
+	int (*rmnet_shs_stamp)(struct sk_buff *skb, struct rmnet_port *port);
+	struct rmnet_priv *priv = netdev_priv(skb->dev);
+
+	trace_rmnet_low(RMNET_MODULE, RMNET_DLVR_SKB, 0xDEF, 0xDEF,
+			0xDEF, 0xDEF, (void *)skb, NULL);
+	skb_reset_transport_header(skb);
+	skb_reset_network_header(skb);
+	rmnet_vnd_rx_fixup(skb->dev, skb->len);
+
+	skb->pkt_type = PACKET_HOST;
+	skb_set_mac_header(skb, 0);
+
+	/* packets coming from work queue context due to packet flush timer
+	 * must go through the special workqueue path in SHS driver
+	 */
+	rcu_read_lock();
+	rmnet_shs_stamp = (!ctx) ? rcu_dereference(rmnet_shs_skb_entry) :
+				   rcu_dereference(rmnet_shs_skb_entry_wq);
+	if (rmnet_shs_stamp) {
+		rmnet_shs_stamp(skb, port);
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	if (ctx == RMNET_NET_RX_CTX) {
+		if (port->data_format & RMNET_INGRESS_FORMAT_DL_MARKER) {
+			if (!rmnet_check_skb_can_gro(skb) &&
+			    port->dl_marker_flush >= 0) {
+				struct napi_struct *napi =
+					get_current_napi_context();
+				napi_gro_receive(napi, skb);
+				port->dl_marker_flush++;
+			} else {
+				netif_receive_skb(skb);
+			}
+		} else {
+			if (!rmnet_check_skb_can_gro(skb))
+				gro_cells_receive(&priv->gro_cells, skb);
+			else
+				netif_receive_skb(skb);
+		}
+	} else {
+		if ((port->data_format & RMNET_INGRESS_FORMAT_DL_MARKER) &&
+		    port->dl_marker_flush >= 0)
+			port->dl_marker_flush++;
+		gro_cells_receive(&priv->gro_cells, skb);
+	}
+}
+EXPORT_SYMBOL(rmnet_deliver_skb_wq);
+
+/* Deliver a list of skbs after undoing coalescing */
+static void rmnet_deliver_skb_list(struct sk_buff_head *head,
+				   struct rmnet_port *port)
+{
+	struct sk_buff *skb;
+
+	while ((skb = __skb_dequeue(head))) {
+		rmnet_set_skb_proto(skb);
+		rmnet_deliver_skb(skb, port);
+	}
 }
 
 /* MAP handler */
@@ -56,20 +215,31 @@ static void
 __rmnet_map_ingress_handler(struct sk_buff *skb,
 			    struct rmnet_port *port)
 {
+	struct rmnet_map_header *qmap;
 	struct rmnet_endpoint *ep;
+	struct sk_buff_head list;
 	u16 len, pad;
 	u8 mux_id;
 
-	if (RMNET_MAP_GET_CD_BIT(skb)) {
+	/* We don't need the spinlock since only we touch this */
+	__skb_queue_head_init(&list);
+
+	qmap = (struct rmnet_map_header *)rmnet_map_data_ptr(skb);
+	if (qmap->cd_bit) {
+		if (port->data_format & RMNET_INGRESS_FORMAT_DL_MARKER) {
+			if (!rmnet_map_flow_command(skb, port, false))
+				return;
+		}
+
 		if (port->data_format & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
 			return rmnet_map_command(skb, port);
 
 		goto free_skb;
 	}
 
-	mux_id = RMNET_MAP_GET_MUX_ID(skb);
-	pad = RMNET_MAP_GET_PAD(skb);
-	len = RMNET_MAP_GET_LENGTH(skb) - pad;
+	mux_id = qmap->mux_id;
+	pad = qmap->pad_len;
+	len = ntohs(qmap->pkt_len) - pad;
 
 	if (mux_id >= RMNET_MAX_LOGICAL_EP)
 		goto free_skb;
@@ -80,31 +250,50 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
 
 	skb->dev = ep->egress_dev;
 
-	/* Subtract MAP header */
-	skb_pull(skb, sizeof(struct rmnet_map_header));
-	rmnet_set_skb_proto(skb);
+	/* Handle QMAPv5 packet */
+	if (qmap->next_hdr &&
+	    (port->data_format & (RMNET_FLAGS_INGRESS_COALESCE |
+				  RMNET_FLAGS_INGRESS_MAP_CKSUMV5))) {
+		if (rmnet_map_process_next_hdr_packet(skb, &list, len))
+			goto free_skb;
+	} else {
+		/* We only have the main QMAP header to worry about */
+		pskb_pull(skb, sizeof(*qmap));
+
+		rmnet_set_skb_proto(skb);
 
-	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
-		if (!rmnet_map_checksum_downlink_packet(skb, len + pad))
-			skb->ip_summed = CHECKSUM_UNNECESSARY;
+		if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
+			if (!rmnet_map_checksum_downlink_packet(skb, len + pad))
+				skb->ip_summed = CHECKSUM_UNNECESSARY;
+		}
+
+		pskb_trim(skb, len);
+
+		/* Push the single packet onto the list */
+		__skb_queue_tail(&list, skb);
 	}
 
-	skb_trim(skb, len);
-	rmnet_deliver_skb(skb);
+	rmnet_deliver_skb_list(&list, port);
 	return;
 
 free_skb:
 	kfree_skb(skb);
 }
 
+int (*rmnet_perf_deag_entry)(struct sk_buff *skb,
+			     struct rmnet_port *port) __rcu __read_mostly;
+EXPORT_SYMBOL(rmnet_perf_deag_entry);
+
 static void
 rmnet_map_ingress_handler(struct sk_buff *skb,
 			  struct rmnet_port *port)
 {
 	struct sk_buff *skbn;
+	int (*rmnet_perf_core_deaggregate)(struct sk_buff *skb,
+					   struct rmnet_port *port);
 
 	if (skb->dev->type == ARPHRD_ETHER) {
-		if (pskb_expand_head(skb, ETH_HLEN, 0, GFP_ATOMIC)) {
+		if (pskb_expand_head(skb, ETH_HLEN, 0, GFP_KERNEL)) {
 			kfree_skb(skb);
 			return;
 		}
@@ -112,13 +301,47 @@ rmnet_map_ingress_handler(struct sk_buff *skb,
 		skb_push(skb, ETH_HLEN);
 	}
 
-	if (port->data_format & RMNET_FLAGS_INGRESS_DEAGGREGATION) {
-		while ((skbn = rmnet_map_deaggregate(skb, port)) != NULL)
+	if (port->data_format & (RMNET_FLAGS_INGRESS_COALESCE |
+				 RMNET_FLAGS_INGRESS_MAP_CKSUMV5)) {
+		if (skb_is_nonlinear(skb)) {
+			rmnet_frag_ingress_handler(skb, port);
+			return;
+		}
+	}
+
+	/* No aggregation. Pass the frame on as is */
+	if (!(port->data_format & RMNET_FLAGS_INGRESS_DEAGGREGATION)) {
+		__rmnet_map_ingress_handler(skb, port);
+		return;
+	}
+
+	/* Pass off handling to rmnet_perf module, if present */
+	rcu_read_lock();
+	rmnet_perf_core_deaggregate = rcu_dereference(rmnet_perf_deag_entry);
+	if (rmnet_perf_core_deaggregate) {
+		rmnet_perf_core_deaggregate(skb, port);
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	/* Deaggregation and freeing of HW originating
+	 * buffers is done within here
+	 */
+	while (skb) {
+		struct sk_buff *skb_frag = skb_shinfo(skb)->frag_list;
+
+		skb_shinfo(skb)->frag_list = NULL;
+		while ((skbn = rmnet_map_deaggregate(skb, port)) != NULL) {
 			__rmnet_map_ingress_handler(skbn, port);
 
+			if (skbn == skb)
+				goto next_skb;
+		}
+
 		consume_skb(skb);
-	} else {
-		__rmnet_map_ingress_handler(skb, port);
+next_skb:
+		skb = skb_frag;
 	}
 }
 
@@ -126,33 +349,48 @@ static int rmnet_map_egress_handler(struct sk_buff *skb,
 				    struct rmnet_port *port, u8 mux_id,
 				    struct net_device *orig_dev)
 {
-	int required_headroom, additional_header_len;
+	int required_headroom, additional_header_len, csum_type;
 	struct rmnet_map_header *map_header;
 
 	additional_header_len = 0;
 	required_headroom = sizeof(struct rmnet_map_header);
+	csum_type = 0;
 
 	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV4) {
 		additional_header_len = sizeof(struct rmnet_map_ul_csum_header);
-		required_headroom += additional_header_len;
+		csum_type = RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
+	} else if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV5) {
+		additional_header_len = sizeof(struct rmnet_map_v5_csum_header);
+		csum_type = RMNET_FLAGS_EGRESS_MAP_CKSUMV5;
 	}
 
+	required_headroom += additional_header_len;
+
 	if (skb_headroom(skb) < required_headroom) {
 		if (pskb_expand_head(skb, required_headroom, 0, GFP_ATOMIC))
 			return -ENOMEM;
 	}
 
-	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV4)
-		rmnet_map_checksum_uplink_packet(skb, orig_dev);
+	if (csum_type)
+		rmnet_map_checksum_uplink_packet(skb, orig_dev, csum_type);
 
-	map_header = rmnet_map_add_map_header(skb, additional_header_len, 0);
+	map_header = rmnet_map_add_map_header(skb, additional_header_len, 0,
+					      port);
 	if (!map_header)
 		return -ENOMEM;
 
 	map_header->mux_id = mux_id;
 
-	skb->protocol = htons(ETH_P_MAP);
+	if (port->data_format & RMNET_EGRESS_FORMAT_AGGREGATION) {
+		if (rmnet_map_tx_agg_skip(skb, required_headroom))
+			goto done;
 
+		rmnet_map_tx_aggregate(skb, port);
+		return -EINPROGRESS;
+	}
+
+done:
+	skb->protocol = htons(ETH_P_MAP);
 	return 0;
 }
 
@@ -183,9 +421,14 @@ rx_handler_result_t rmnet_rx_handler(struct sk_buff **pskb)
 	if (skb->pkt_type == PACKET_LOOPBACK)
 		return RX_HANDLER_PASS;
 
+	trace_rmnet_low(RMNET_MODULE, RMNET_RCV_FROM_PND, 0xDEF,
+			0xDEF, 0xDEF, 0xDEF, NULL, NULL);
 	dev = skb->dev;
 	port = rmnet_get_port(dev);
 
+	port->chain_head = NULL;
+	port->chain_tail = NULL;
+
 	switch (port->rmnet_mode) {
 	case RMNET_EPMODE_VND:
 		rmnet_map_ingress_handler(skb, port);
@@ -198,6 +441,7 @@ rx_handler_result_t rmnet_rx_handler(struct sk_buff **pskb)
 done:
 	return RX_HANDLER_CONSUMED;
 }
+EXPORT_SYMBOL(rmnet_rx_handler);
 
 /* Modifies packet as per logical endpoint configuration and egress data format
  * for egress device configured in logical endpoint. Packet is then transmitted
@@ -209,8 +453,13 @@ void rmnet_egress_handler(struct sk_buff *skb)
 	struct rmnet_port *port;
 	struct rmnet_priv *priv;
 	u8 mux_id;
+	int err;
+	u32 skb_len;
 
-	sk_pacing_shift_update(skb->sk, 8);
+	trace_rmnet_low(RMNET_MODULE, RMNET_TX_UL_PKT, 0xDEF, 0xDEF, 0xDEF,
+			0xDEF, (void *)skb, NULL);
+
+	skb_orphan(skb);
 
 	orig_dev = skb->dev;
 	priv = netdev_priv(orig_dev);
@@ -221,10 +470,16 @@ void rmnet_egress_handler(struct sk_buff *skb)
 	if (!port)
 		goto drop;
 
-	if (rmnet_map_egress_handler(skb, port, mux_id, orig_dev))
+	skb_len = skb->len;
+	err = rmnet_map_egress_handler(skb, port, mux_id, orig_dev);
+	if (err == -ENOMEM) {
 		goto drop;
+	} else if (err == -EINPROGRESS) {
+		rmnet_vnd_tx_fixup(orig_dev, skb_len);
+		return;
+	}
 
-	rmnet_vnd_tx_fixup(skb, orig_dev);
+	rmnet_vnd_tx_fixup(orig_dev, skb_len);
 
 	dev_queue_xmit(skb);
 	return;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.h
index c4571dc3239d..c61bbe1543de 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.h
@@ -1,16 +1,37 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright (c) 2013, 2016-2017 The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013, 2016-2017, 2019
+ * The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
  * RMNET Data ingress/egress handler
+ *
  */
 
 #ifndef _RMNET_HANDLERS_H_
 #define _RMNET_HANDLERS_H_
 
 #include "rmnet_config.h"
+#include "rmnet_descriptor.h"
 
-void rmnet_egress_handler(struct sk_buff *skb);
+enum rmnet_packet_context {
+	RMNET_NET_RX_CTX,
+	RMNET_WQ_CTX,
+};
 
+void rmnet_egress_handler(struct sk_buff *skb);
+void rmnet_deliver_skb(struct sk_buff *skb, struct rmnet_port *port);
+void rmnet_deliver_skb_wq(struct sk_buff *skb, struct rmnet_port *port,
+			  enum rmnet_packet_context ctx);
+void rmnet_set_skb_proto(struct sk_buff *skb);
+rx_handler_result_t _rmnet_map_ingress_handler(struct sk_buff *skb,
+					       struct rmnet_port *port);
 rx_handler_result_t rmnet_rx_handler(struct sk_buff **pskb);
-
 #endif /* _RMNET_HANDLERS_H_ */
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index 576501db2a0b..946a8b245e68 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -1,10 +1,21 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2019, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  */
 
 #ifndef _RMNET_MAP_H_
 #define _RMNET_MAP_H_
-#include <linux/if_rmnet.h>
+
+#include <linux/skbuff.h>
+#include "rmnet_config.h"
 
 struct rmnet_map_control_command {
 	u8  command_name;
@@ -27,11 +38,162 @@ enum rmnet_map_commands {
 	RMNET_MAP_COMMAND_NONE,
 	RMNET_MAP_COMMAND_FLOW_DISABLE,
 	RMNET_MAP_COMMAND_FLOW_ENABLE,
+	RMNET_MAP_COMMAND_FLOW_START = 7,
+	RMNET_MAP_COMMAND_FLOW_END = 8,
 	/* These should always be the last 2 elements */
 	RMNET_MAP_COMMAND_UNKNOWN,
 	RMNET_MAP_COMMAND_ENUM_LENGTH
 };
 
+enum rmnet_map_v5_header_type {
+	RMNET_MAP_HEADER_TYPE_UNKNOWN,
+	RMNET_MAP_HEADER_TYPE_COALESCING = 0x1,
+	RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD = 0x2,
+	RMNET_MAP_HEADER_TYPE_ENUM_LENGTH
+};
+
+enum rmnet_map_v5_close_type {
+	RMNET_MAP_COAL_CLOSE_NON_COAL,
+	RMNET_MAP_COAL_CLOSE_IP_MISS,
+	RMNET_MAP_COAL_CLOSE_TRANS_MISS,
+	RMNET_MAP_COAL_CLOSE_HW,
+	RMNET_MAP_COAL_CLOSE_COAL,
+};
+
+enum rmnet_map_v5_close_value {
+	RMNET_MAP_COAL_CLOSE_HW_NL,
+	RMNET_MAP_COAL_CLOSE_HW_PKT,
+	RMNET_MAP_COAL_CLOSE_HW_BYTE,
+	RMNET_MAP_COAL_CLOSE_HW_TIME,
+	RMNET_MAP_COAL_CLOSE_HW_EVICT,
+};
+
+/* Main QMAP header */
+struct rmnet_map_header {
+	u8  pad_len:6;
+	u8  next_hdr:1;
+	u8  cd_bit:1;
+	u8  mux_id;
+	__be16 pkt_len;
+}  __aligned(1);
+
+/* QMAP v5 headers */
+struct rmnet_map_v5_csum_header {
+	u8  next_hdr:1;
+	u8  header_type:7;
+	u8  hw_reserved:7;
+	u8  csum_valid_required:1;
+	__be16 reserved;
+} __aligned(1);
+
+struct rmnet_map_v5_nl_pair {
+	__be16 pkt_len;
+	u8  csum_error_bitmap;
+	u8  num_packets;
+} __aligned(1);
+
+/* NLO: Number-length object */
+#define RMNET_MAP_V5_MAX_NLOS         (6)
+#define RMNET_MAP_V5_MAX_PACKETS      (48)
+
+struct rmnet_map_v5_coal_header {
+	u8  next_hdr:1;
+	u8  header_type:7;
+	u8  reserved1:4;
+	u8  num_nlos:3;
+	u8  csum_valid:1;
+	u8  close_type:4;
+	u8  close_value:4;
+	u8  reserved2:4;
+	u8  virtual_channel_id:4;
+
+	struct rmnet_map_v5_nl_pair nl_pairs[RMNET_MAP_V5_MAX_NLOS];
+} __aligned(1);
+
+/* QMAP v4 headers */
+struct rmnet_map_dl_csum_trailer {
+	u8  reserved1;
+	u8  valid:1;
+	u8  reserved2:7;
+	u16 csum_start_offset;
+	u16 csum_length;
+	__be16 csum_value;
+} __aligned(1);
+
+struct rmnet_map_ul_csum_header {
+	__be16 csum_start_offset;
+	u16 csum_insert_offset:14;
+	u16 udp_ind:1;
+	u16 csum_enabled:1;
+} __aligned(1);
+
+struct rmnet_map_control_command_header {
+	u8 command_name;
+	u8 cmd_type:2;
+	u8 reserved:5;
+	u8 e:1;
+	u16 source_id:15;
+	u16 ext:1;
+	u32 transaction_id;
+}  __aligned(1);
+
+struct rmnet_map_flow_info_le {
+	__be32 mux_id;
+	__be32 flow_id;
+	__be32 bytes;
+	__be32 pkts;
+} __aligned(1);
+
+struct rmnet_map_flow_info_be {
+	u32 mux_id;
+	u32 flow_id;
+	u32 bytes;
+	u32 pkts;
+} __aligned(1);
+
+struct rmnet_map_dl_ind_hdr {
+	union {
+		struct {
+			u32 seq;
+			u32 bytes;
+			u32 pkts;
+			u32 flows;
+			struct rmnet_map_flow_info_le flow[0];
+		} le __aligned(1);
+		struct {
+			__be32 seq;
+			__be32 bytes;
+			__be32 pkts;
+			__be32 flows;
+			struct rmnet_map_flow_info_be flow[0];
+		} be __aligned(1);
+	} __aligned(1);
+} __aligned(1);
+
+struct rmnet_map_dl_ind_trl {
+	union {
+		__be32 seq_be;
+		u32 seq_le;
+	} __aligned(1);
+} __aligned(1);
+
+typedef void (*dl_hdr_hdl_v2_t)(struct rmnet_map_dl_ind_hdr *hdr,
+				struct rmnet_map_control_command_header *h);
+typedef void (*dl_trl_hdl_v2_t)(struct rmnet_map_dl_ind_trl *hdr,
+				struct rmnet_map_control_command_header *h);
+struct rmnet_map_dl_ind {
+	u8 priority;
+	union {
+		void (*dl_hdr_handler)(struct rmnet_map_dl_ind_hdr *hdr);
+		dl_hdr_hdl_v2_t dl_hdr_handler_v2;
+	} __aligned(1);
+	union {
+		void (*dl_trl_handler)(struct rmnet_map_dl_ind_trl *hdr);
+		dl_trl_hdl_v2_t dl_trl_handler_v2;
+	} __aligned(1);
+	struct list_head list;
+};
+
 #define RMNET_MAP_GET_MUX_ID(Y) (((struct rmnet_map_header *) \
 				 (Y)->data)->mux_id)
 #define RMNET_MAP_GET_CD_BIT(Y) (((struct rmnet_map_header *) \
@@ -44,6 +206,10 @@ enum rmnet_map_commands {
 #define RMNET_MAP_GET_LENGTH(Y) (ntohs(((struct rmnet_map_header *) \
 					(Y)->data)->pkt_len))
 
+#define RMNET_MAP_DEAGGR_SPACING  64
+#define RMNET_MAP_DEAGGR_HEADROOM (RMNET_MAP_DEAGGR_SPACING / 2)
+#define RMNET_MAP_DESC_HEADROOM   128
+
 #define RMNET_MAP_COMMAND_REQUEST     0
 #define RMNET_MAP_COMMAND_ACK         1
 #define RMNET_MAP_COMMAND_UNSUPPORTED 2
@@ -52,13 +218,75 @@ enum rmnet_map_commands {
 #define RMNET_MAP_NO_PAD_BYTES        0
 #define RMNET_MAP_ADD_PAD_BYTES       1
 
+static inline unsigned char *rmnet_map_data_ptr(struct sk_buff *skb)
+{
+	/* Nonlinear packets we receive are entirely within frag 0 */
+	if (skb_is_nonlinear(skb) && skb->len == skb->data_len)
+		return skb_frag_address(skb_shinfo(skb)->frags);
+
+	return skb->data;
+}
+
+static inline struct rmnet_map_control_command *
+rmnet_map_get_cmd_start(struct sk_buff *skb)
+{
+	unsigned char *data = rmnet_map_data_ptr(skb);
+
+	data += sizeof(struct rmnet_map_header);
+	return (struct rmnet_map_control_command *)data;
+}
+
+static inline u8 rmnet_map_get_next_hdr_type(struct sk_buff *skb)
+{
+	unsigned char *data = rmnet_map_data_ptr(skb);
+
+	data += sizeof(struct rmnet_map_header);
+	return ((struct rmnet_map_v5_coal_header *)data)->header_type;
+}
+
+static inline bool rmnet_map_get_csum_valid(struct sk_buff *skb)
+{
+	unsigned char *data = rmnet_map_data_ptr(skb);
+
+	data += sizeof(struct rmnet_map_header);
+	return ((struct rmnet_map_v5_csum_header *)data)->csum_valid_required;
+}
+
 struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 				      struct rmnet_port *port);
 struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
-						  int hdrlen, int pad);
+						  int hdrlen, int pad,
+						  struct rmnet_port *port);
 void rmnet_map_command(struct sk_buff *skb, struct rmnet_port *port);
 int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len);
 void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
-				      struct net_device *orig_dev);
-
+				      struct net_device *orig_dev,
+				      int csum_type);
+bool rmnet_map_v5_csum_buggy(struct rmnet_map_v5_coal_header *coal_hdr);
+int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
+				      struct sk_buff_head *list,
+				      u16 len);
+int rmnet_map_tx_agg_skip(struct sk_buff *skb, int offset);
+void rmnet_map_tx_aggregate(struct sk_buff *skb, struct rmnet_port *port);
+void rmnet_map_tx_aggregate_init(struct rmnet_port *port);
+void rmnet_map_tx_aggregate_exit(struct rmnet_port *port);
+void rmnet_map_dl_hdr_notify(struct rmnet_port *port,
+			     struct rmnet_map_dl_ind_hdr *dl_hdr);
+void rmnet_map_dl_hdr_notify_v2(struct rmnet_port *port,
+				struct rmnet_map_dl_ind_hdr *dl_hdr,
+				struct rmnet_map_control_command_header *qcmd);
+void rmnet_map_dl_trl_notify(struct rmnet_port *port,
+			     struct rmnet_map_dl_ind_trl *dltrl);
+void rmnet_map_dl_trl_notify_v2(struct rmnet_port *port,
+				struct rmnet_map_dl_ind_trl *dltrl,
+				struct rmnet_map_control_command_header *qcmd);
+int rmnet_map_flow_command(struct sk_buff *skb,
+			   struct rmnet_port *port,
+			   bool rmnet_perf);
+void rmnet_map_cmd_init(struct rmnet_port *port);
+int rmnet_map_dl_ind_register(struct rmnet_port *port,
+			      struct rmnet_map_dl_ind *dl_ind);
+int rmnet_map_dl_ind_deregister(struct rmnet_port *port,
+				struct rmnet_map_dl_ind *dl_ind);
+void rmnet_map_cmd_exit(struct rmnet_port *port);
 #endif /* _RMNET_MAP_H_ */
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c
index beaee4962128..645469a29850 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c
@@ -1,5 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2019, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  */
 
 #include <linux/netdevice.h>
@@ -8,16 +17,34 @@
 #include "rmnet_private.h"
 #include "rmnet_vnd.h"
 
+#define RMNET_DL_IND_HDR_SIZE (sizeof(struct rmnet_map_dl_ind_hdr) + \
+			       sizeof(struct rmnet_map_header) + \
+			       sizeof(struct rmnet_map_control_command_header))
+
+#define RMNET_MAP_CMD_SIZE (sizeof(struct rmnet_map_header) + \
+			    sizeof(struct rmnet_map_control_command_header))
+
+#define RMNET_DL_IND_TRL_SIZE (sizeof(struct rmnet_map_dl_ind_trl) + \
+			       sizeof(struct rmnet_map_header) + \
+			       sizeof(struct rmnet_map_control_command_header))
+
 static u8 rmnet_map_do_flow_control(struct sk_buff *skb,
 				    struct rmnet_port *port,
 				    int enable)
 {
+	struct rmnet_map_header *qmap;
+	struct rmnet_map_control_command *cmd;
 	struct rmnet_endpoint *ep;
 	struct net_device *vnd;
+	u16 ip_family;
+	u16 fc_seq;
+	u32 qos_id;
 	u8 mux_id;
 	int r;
 
-	mux_id = RMNET_MAP_GET_MUX_ID(skb);
+	qmap = (struct rmnet_map_header *)rmnet_map_data_ptr(skb);
+	mux_id = qmap->mux_id;
+	cmd = rmnet_map_get_cmd_start(skb);
 
 	if (mux_id >= RMNET_MAX_LOGICAL_EP) {
 		kfree_skb(skb);
@@ -32,6 +59,10 @@ static u8 rmnet_map_do_flow_control(struct sk_buff *skb,
 
 	vnd = ep->egress_dev;
 
+	ip_family = cmd->flow_control.ip_family;
+	fc_seq = ntohs(cmd->flow_control.flow_control_seq_num);
+	qos_id = ntohl(cmd->flow_control.qos_id);
+
 	/* Ignore the ip family and pass the sequence number for both v4 and v6
 	 * sequence. User space does not support creating dedicated flows for
 	 * the 2 protocols
@@ -53,12 +84,12 @@ static void rmnet_map_send_ack(struct sk_buff *skb,
 	struct net_device *dev = skb->dev;
 
 	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
-		skb_trim(skb,
-			 skb->len - sizeof(struct rmnet_map_dl_csum_trailer));
+		pskb_trim(skb,
+			  skb->len - sizeof(struct rmnet_map_dl_csum_trailer));
 
 	skb->protocol = htons(ETH_P_MAP);
 
-	cmd = RMNET_MAP_GET_CMD_START(skb);
+	cmd = rmnet_map_get_cmd_start(skb);
 	cmd->cmd_type = type & 0x03;
 
 	netif_tx_lock(dev);
@@ -66,6 +97,162 @@ static void rmnet_map_send_ack(struct sk_buff *skb,
 	netif_tx_unlock(dev);
 }
 
+void
+rmnet_map_dl_hdr_notify_v2(struct rmnet_port *port,
+			   struct rmnet_map_dl_ind_hdr *dlhdr,
+			   struct rmnet_map_control_command_header *qcmd)
+{
+	struct rmnet_map_dl_ind *tmp;
+
+	port->dl_marker_flush = 0;
+
+	list_for_each_entry(tmp, &port->dl_list, list)
+		tmp->dl_hdr_handler_v2(dlhdr, qcmd);
+}
+
+void
+rmnet_map_dl_hdr_notify(struct rmnet_port *port,
+			struct rmnet_map_dl_ind_hdr *dlhdr)
+{
+	struct rmnet_map_dl_ind *tmp;
+
+	port->dl_marker_flush = 0;
+
+	list_for_each_entry(tmp, &port->dl_list, list)
+		tmp->dl_hdr_handler(dlhdr);
+}
+
+void
+rmnet_map_dl_trl_notify_v2(struct rmnet_port *port,
+			   struct rmnet_map_dl_ind_trl *dltrl,
+			   struct rmnet_map_control_command_header *qcmd)
+{
+	struct rmnet_map_dl_ind *tmp;
+	struct napi_struct *napi;
+
+	list_for_each_entry(tmp, &port->dl_list, list)
+		tmp->dl_trl_handler_v2(dltrl, qcmd);
+
+	if (port->dl_marker_flush) {
+		napi = get_current_napi_context();
+		napi_gro_flush(napi, false);
+	}
+
+	port->dl_marker_flush = -1;
+}
+
+void
+rmnet_map_dl_trl_notify(struct rmnet_port *port,
+			struct rmnet_map_dl_ind_trl *dltrl)
+{
+	struct rmnet_map_dl_ind *tmp;
+	struct napi_struct *napi;
+
+	list_for_each_entry(tmp, &port->dl_list, list)
+		tmp->dl_trl_handler(dltrl);
+
+	if (port->dl_marker_flush) {
+		napi = get_current_napi_context();
+		napi_gro_flush(napi, false);
+	}
+
+	port->dl_marker_flush = -1;
+}
+
+static void rmnet_map_process_flow_start(struct sk_buff *skb,
+					 struct rmnet_port *port,
+					 bool rmnet_perf)
+{
+	struct rmnet_map_dl_ind_hdr *dlhdr;
+	struct rmnet_map_control_command_header *qcmd;
+	u32 data_format;
+	bool is_dl_mark_v2;
+
+	if (skb->len < RMNET_DL_IND_HDR_SIZE)
+		return;
+
+	data_format = port->data_format;
+	is_dl_mark_v2 = data_format & RMNET_INGRESS_FORMAT_DL_MARKER_V2;
+	if (is_dl_mark_v2) {
+		pskb_pull(skb, sizeof(struct rmnet_map_header));
+		qcmd = (struct rmnet_map_control_command_header *)
+			rmnet_map_data_ptr(skb);
+		port->stats.dl_hdr_last_ep_id = qcmd->source_id;
+		port->stats.dl_hdr_last_qmap_vers = qcmd->reserved;
+		port->stats.dl_hdr_last_trans_id = qcmd->transaction_id;
+		pskb_pull(skb, sizeof(struct rmnet_map_control_command_header));
+	} else {
+		pskb_pull(skb, RMNET_MAP_CMD_SIZE);
+	}
+
+	dlhdr = (struct rmnet_map_dl_ind_hdr *)rmnet_map_data_ptr(skb);
+
+	port->stats.dl_hdr_last_seq = dlhdr->le.seq;
+	port->stats.dl_hdr_last_bytes = dlhdr->le.bytes;
+	port->stats.dl_hdr_last_pkts = dlhdr->le.pkts;
+	port->stats.dl_hdr_last_flows = dlhdr->le.flows;
+	port->stats.dl_hdr_total_bytes += port->stats.dl_hdr_last_bytes;
+	port->stats.dl_hdr_total_pkts += port->stats.dl_hdr_last_pkts;
+	port->stats.dl_hdr_count++;
+
+	if (is_dl_mark_v2)
+		rmnet_map_dl_hdr_notify_v2(port, dlhdr, qcmd);
+	else
+		rmnet_map_dl_hdr_notify(port, dlhdr);
+
+	if (rmnet_perf) {
+		unsigned int pull_size;
+
+		pull_size = sizeof(struct rmnet_map_dl_ind_hdr);
+		if (data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
+			pull_size += sizeof(struct rmnet_map_dl_csum_trailer);
+		pskb_pull(skb, pull_size);
+	}
+}
+
+static void rmnet_map_process_flow_end(struct sk_buff *skb,
+				       struct rmnet_port *port,
+				       bool rmnet_perf)
+{
+	struct rmnet_map_dl_ind_trl *dltrl;
+	struct rmnet_map_control_command_header *qcmd;
+	u32 data_format;
+	bool is_dl_mark_v2;
+
+	if (skb->len < RMNET_DL_IND_TRL_SIZE)
+		return;
+
+	data_format = port->data_format;
+	is_dl_mark_v2 = data_format & RMNET_INGRESS_FORMAT_DL_MARKER_V2;
+	if (is_dl_mark_v2) {
+		pskb_pull(skb, sizeof(struct rmnet_map_header));
+		qcmd = (struct rmnet_map_control_command_header *)
+			rmnet_map_data_ptr(skb);
+		pskb_pull(skb, sizeof(struct rmnet_map_control_command_header));
+	} else {
+		pskb_pull(skb, RMNET_MAP_CMD_SIZE);
+	}
+
+	dltrl = (struct rmnet_map_dl_ind_trl *)rmnet_map_data_ptr(skb);
+
+	port->stats.dl_trl_last_seq = dltrl->seq_le;
+	port->stats.dl_trl_count++;
+
+	if (is_dl_mark_v2)
+		rmnet_map_dl_trl_notify_v2(port, dltrl, qcmd);
+	else
+		rmnet_map_dl_trl_notify(port, dltrl);
+
+	if (rmnet_perf) {
+		unsigned int pull_size;
+
+		pull_size = sizeof(struct rmnet_map_dl_ind_trl);
+		if (data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
+			pull_size += sizeof(struct rmnet_map_dl_csum_trailer);
+		pskb_pull(skb, pull_size);
+	}
+}
+
 /* Process MAP command frame and send N/ACK message as appropriate. Message cmd
  * name is decoded here and appropriate handler is called.
  */
@@ -75,7 +262,7 @@ void rmnet_map_command(struct sk_buff *skb, struct rmnet_port *port)
 	unsigned char command_name;
 	unsigned char rc = 0;
 
-	cmd = RMNET_MAP_GET_CMD_START(skb);
+	cmd = rmnet_map_get_cmd_start(skb);
 	command_name = cmd->command_name;
 
 	switch (command_name) {
@@ -95,3 +282,108 @@ void rmnet_map_command(struct sk_buff *skb, struct rmnet_port *port)
 	if (rc == RMNET_MAP_COMMAND_ACK)
 		rmnet_map_send_ack(skb, rc, port);
 }
+
+int rmnet_map_flow_command(struct sk_buff *skb, struct rmnet_port *port,
+			   bool rmnet_perf)
+{
+	struct rmnet_map_control_command *cmd;
+	unsigned char command_name;
+
+	cmd = rmnet_map_get_cmd_start(skb);
+	command_name = cmd->command_name;
+
+	switch (command_name) {
+	case RMNET_MAP_COMMAND_FLOW_START:
+		rmnet_map_process_flow_start(skb, port, rmnet_perf);
+		break;
+
+	case RMNET_MAP_COMMAND_FLOW_END:
+		rmnet_map_process_flow_end(skb, port, rmnet_perf);
+		break;
+
+	default:
+		return 1;
+	}
+
+	/* rmnet_perf module will handle the consuming */
+	if (!rmnet_perf)
+		consume_skb(skb);
+
+	return 0;
+}
+EXPORT_SYMBOL(rmnet_map_flow_command);
+
+void rmnet_map_cmd_exit(struct rmnet_port *port)
+{
+	struct rmnet_map_dl_ind *tmp, *idx;
+
+	list_for_each_entry_safe(tmp, idx, &port->dl_list, list)
+		list_del_rcu(&tmp->list);
+}
+
+void rmnet_map_cmd_init(struct rmnet_port *port)
+{
+	INIT_LIST_HEAD(&port->dl_list);
+
+	port->dl_marker_flush = -1;
+}
+
+int rmnet_map_dl_ind_register(struct rmnet_port *port,
+			      struct rmnet_map_dl_ind *dl_ind)
+{
+	struct rmnet_map_dl_ind *dl_ind_iterator;
+	bool empty_ind_list = true;
+
+	if (!port || !dl_ind || !dl_ind->dl_hdr_handler ||
+	    !dl_ind->dl_trl_handler)
+		return -EINVAL;
+
+	list_for_each_entry_rcu(dl_ind_iterator, &port->dl_list, list) {
+		empty_ind_list = false;
+		if (dl_ind_iterator->priority < dl_ind->priority) {
+			if (dl_ind_iterator->list.next) {
+				if (dl_ind->priority
+				    < list_entry_rcu(dl_ind_iterator->list.next,
+				    typeof(*dl_ind_iterator), list)->priority) {
+					list_add_rcu(&dl_ind->list,
+						     &dl_ind_iterator->list);
+					break;
+				}
+			} else {
+				list_add_rcu(&dl_ind->list,
+					     &dl_ind_iterator->list);
+				break;
+			}
+		} else {
+			list_add_tail_rcu(&dl_ind->list,
+					  &dl_ind_iterator->list);
+			break;
+		}
+	}
+
+	if (empty_ind_list)
+		list_add_rcu(&dl_ind->list, &port->dl_list);
+
+	return 0;
+}
+EXPORT_SYMBOL(rmnet_map_dl_ind_register);
+
+int rmnet_map_dl_ind_deregister(struct rmnet_port *port,
+				struct rmnet_map_dl_ind *dl_ind)
+{
+	struct rmnet_map_dl_ind *tmp;
+
+	if (!port || !dl_ind)
+		return -EINVAL;
+
+	list_for_each_entry(tmp, &port->dl_list, list) {
+		if (tmp == dl_ind) {
+			list_del_rcu(&dl_ind->list);
+			goto done;
+		}
+	}
+
+done:
+	return 0;
+}
+EXPORT_SYMBOL(rmnet_map_dl_ind_deregister);
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 21d38167f961..f6d566392e62 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -1,7 +1,17 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2019, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
  * RMNET Data MAP protocol
+ *
  */
 
 #include <linux/netdevice.h>
@@ -11,10 +21,25 @@
 #include "rmnet_config.h"
 #include "rmnet_map.h"
 #include "rmnet_private.h"
+#include "rmnet_handlers.h"
 
+#define RMNET_MAP_PKT_COPY_THRESHOLD 64
 #define RMNET_MAP_DEAGGR_SPACING  64
 #define RMNET_MAP_DEAGGR_HEADROOM (RMNET_MAP_DEAGGR_SPACING / 2)
 
+struct rmnet_map_coal_metadata {
+	void *ip_header;
+	void *trans_header;
+	u16 ip_len;
+	u16 trans_len;
+	u16 data_offset;
+	u16 data_len;
+	u8 ip_proto;
+	u8 trans_proto;
+	u8 pkt_id;
+	u8 pkt_count;
+};
+
 static __sum16 *rmnet_map_get_csum_field(unsigned char protocol,
 					 const void *txporthdr)
 {
@@ -48,14 +73,14 @@ rmnet_map_ipv4_dl_csum_trailer(struct sk_buff *skb,
 	void *txporthdr;
 	__be16 addend;
 
-	ip4h = (struct iphdr *)(skb->data);
+	ip4h = (struct iphdr *)rmnet_map_data_ptr(skb);
 	if ((ntohs(ip4h->frag_off) & IP_MF) ||
 	    ((ntohs(ip4h->frag_off) & IP_OFFSET) > 0)) {
 		priv->stats.csum_fragmented_pkt++;
 		return -EOPNOTSUPP;
 	}
 
-	txporthdr = skb->data + ip4h->ihl * 4;
+	txporthdr = rmnet_map_data_ptr(skb) + ip4h->ihl * 4;
 
 	csum_field = rmnet_map_get_csum_field(ip4h->protocol, txporthdr);
 
@@ -119,12 +144,12 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 	u16 csum_value, csum_value_final;
 	__be16 ip6_hdr_csum, addend;
 	struct ipv6hdr *ip6h;
-	void *txporthdr;
+	void *txporthdr, *data = rmnet_map_data_ptr(skb);
 	u32 length;
 
-	ip6h = (struct ipv6hdr *)(skb->data);
+	ip6h = data;
 
-	txporthdr = skb->data + sizeof(struct ipv6hdr);
+	txporthdr = data + sizeof(struct ipv6hdr);
 	csum_field = rmnet_map_get_csum_field(ip6h->nexthdr, txporthdr);
 
 	if (!csum_field) {
@@ -135,7 +160,7 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 	csum_value = ~ntohs(csum_trailer->csum_value);
 	ip6_hdr_csum = (__force __be16)
 			~ntohs((__force __be16)ip_compute_csum(ip6h,
-			       (int)(txporthdr - (void *)(skb->data))));
+			       (int)(txporthdr - data)));
 	ip6_payload_csum = csum16_sub((__force __sum16)csum_value,
 				      ip6_hdr_csum);
 
@@ -268,7 +293,8 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
  * initialized to 0.
  */
 struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
-						  int hdrlen, int pad)
+						  int hdrlen, int pad,
+						  struct rmnet_port *port)
 {
 	struct rmnet_map_header *map_header;
 	u32 padding, map_datalen;
@@ -279,6 +305,10 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
 			skb_push(skb, sizeof(struct rmnet_map_header));
 	memset(map_header, 0, sizeof(struct rmnet_map_header));
 
+	/* Set next_hdr bit for csum offload packets */
+	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV5)
+		map_header->next_hdr = 1;
+
 	if (pad == RMNET_MAP_NO_PAD_BYTES) {
 		map_header->pkt_len = htons(map_datalen);
 		return map_header;
@@ -313,16 +343,25 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 {
 	struct rmnet_map_header *maph;
 	struct sk_buff *skbn;
+	unsigned char *data = rmnet_map_data_ptr(skb), *next_hdr = NULL;
 	u32 packet_len;
 
 	if (skb->len == 0)
 		return NULL;
 
-	maph = (struct rmnet_map_header *)skb->data;
+	maph = (struct rmnet_map_header *)data;
 	packet_len = ntohs(maph->pkt_len) + sizeof(struct rmnet_map_header);
 
 	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
 		packet_len += sizeof(struct rmnet_map_dl_csum_trailer);
+	else if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV5) {
+		if (!maph->cd_bit) {
+			packet_len += sizeof(struct rmnet_map_v5_csum_header);
+
+			/* Coalescing headers require MAPv5 */
+			next_hdr = data + sizeof(*maph);
+		}
+	}
 
 	if (((int)skb->len - (int)packet_len) < 0)
 		return NULL;
@@ -331,14 +370,35 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 	if (ntohs(maph->pkt_len) == 0)
 		return NULL;
 
-	skbn = alloc_skb(packet_len + RMNET_MAP_DEAGGR_SPACING, GFP_ATOMIC);
-	if (!skbn)
-		return NULL;
+	if (next_hdr &&
+	    ((struct rmnet_map_v5_coal_header *)next_hdr)->header_type ==
+	     RMNET_MAP_HEADER_TYPE_COALESCING)
+		return skb;
+
+	if (skb_is_nonlinear(skb)) {
+		skb_frag_t *frag0 = skb_shinfo(skb)->frags;
+		struct page *page = skb_frag_page(frag0);
 
-	skb_reserve(skbn, RMNET_MAP_DEAGGR_HEADROOM);
-	skb_put(skbn, packet_len);
-	memcpy(skbn->data, skb->data, packet_len);
-	skb_pull(skb, packet_len);
+		skbn = alloc_skb(RMNET_MAP_DEAGGR_HEADROOM, GFP_ATOMIC);
+		if (!skbn)
+			return NULL;
+
+		skb_append_pagefrags(skbn, page, frag0->bv_offset,
+				     packet_len);
+		skbn->data_len += packet_len;
+		skbn->len += packet_len;
+	} else {
+		skbn = alloc_skb(packet_len + RMNET_MAP_DEAGGR_SPACING,
+				 GFP_ATOMIC);
+		if (!skbn)
+			return NULL;
+
+		skb_reserve(skbn, RMNET_MAP_DEAGGR_HEADROOM);
+		skb_put(skbn, packet_len);
+		memcpy(skbn->data, data, packet_len);
+	}
+
+	pskb_pull(skb, packet_len);
 
 	return skbn;
 }
@@ -359,7 +419,8 @@ int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len)
 		return -EOPNOTSUPP;
 	}
 
-	csum_trailer = (struct rmnet_map_dl_csum_trailer *)(skb->data + len);
+	csum_trailer = (struct rmnet_map_dl_csum_trailer *)
+		       (rmnet_map_data_ptr(skb) + len);
 
 	if (!csum_trailer->valid) {
 		priv->stats.csum_valid_unset++;
@@ -382,12 +443,10 @@ int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len)
 
 	return 0;
 }
+EXPORT_SYMBOL(rmnet_map_checksum_downlink_packet);
 
-/* Generates UL checksum meta info header for IPv4 and IPv6 over TCP and UDP
- * packets that are supported for UL checksum offload.
- */
-void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
-				      struct net_device *orig_dev)
+void rmnet_map_v4_checksum_uplink_packet(struct sk_buff *skb,
+					 struct net_device *orig_dev)
 {
 	struct rmnet_priv *priv = netdev_priv(orig_dev);
 	struct rmnet_map_ul_csum_header *ul_header;
@@ -406,10 +465,12 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 
 		if (skb->protocol == htons(ETH_P_IP)) {
 			rmnet_map_ipv4_ul_csum_header(iphdr, ul_header, skb);
+			priv->stats.csum_hw++;
 			return;
 		} else if (skb->protocol == htons(ETH_P_IPV6)) {
 #if IS_ENABLED(CONFIG_IPV6)
 			rmnet_map_ipv6_ul_csum_header(iphdr, ul_header, skb);
+			priv->stats.csum_hw++;
 			return;
 #else
 			priv->stats.csum_err_invalid_ip_version++;
@@ -428,3 +489,927 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 
 	priv->stats.csum_sw++;
 }
+
+void rmnet_map_v5_checksum_uplink_packet(struct sk_buff *skb,
+					 struct net_device *orig_dev)
+{
+	struct rmnet_priv *priv = netdev_priv(orig_dev);
+	struct rmnet_map_v5_csum_header *ul_header;
+
+	ul_header = (struct rmnet_map_v5_csum_header *)
+		    skb_push(skb, sizeof(*ul_header));
+	memset(ul_header, 0, sizeof(*ul_header));
+	ul_header->header_type = RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD;
+
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		void *iph = (char *)ul_header + sizeof(*ul_header);
+		void *trans;
+		__sum16 *check;
+		u8 proto;
+
+		if (skb->protocol == htons(ETH_P_IP)) {
+			u16 ip_len = ((struct iphdr *)iph)->ihl * 4;
+
+			proto = ((struct iphdr *)iph)->protocol;
+			trans = iph + ip_len;
+		} else if (skb->protocol == htons(ETH_P_IPV6)) {
+			u16 ip_len = sizeof(struct ipv6hdr);
+
+			proto = ((struct ipv6hdr *)iph)->nexthdr;
+			trans = iph + ip_len;
+		} else {
+			priv->stats.csum_err_invalid_ip_version++;
+			goto sw_csum;
+		}
+
+		check = rmnet_map_get_csum_field(proto, trans);
+		if (check) {
+			*check = 0;
+			skb->ip_summed = CHECKSUM_NONE;
+			/* Ask for checksum offloading */
+			ul_header->csum_valid_required = 1;
+			priv->stats.csum_hw++;
+			return;
+		}
+	}
+
+sw_csum:
+	priv->stats.csum_sw++;
+}
+
+/* Generates UL checksum meta info header for IPv4 and IPv6 over TCP and UDP
+ * packets that are supported for UL checksum offload.
+ */
+void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
+				      struct net_device *orig_dev,
+				      int csum_type)
+{
+	switch (csum_type) {
+	case RMNET_FLAGS_EGRESS_MAP_CKSUMV4:
+		rmnet_map_v4_checksum_uplink_packet(skb, orig_dev);
+		break;
+	case RMNET_FLAGS_EGRESS_MAP_CKSUMV5:
+		rmnet_map_v5_checksum_uplink_packet(skb, orig_dev);
+		break;
+	default:
+		break;
+	}
+}
+
+bool rmnet_map_v5_csum_buggy(struct rmnet_map_v5_coal_header *coal_hdr)
+{
+	/* Only applies to frames with a single packet */
+	if (coal_hdr->num_nlos != 1 || coal_hdr->nl_pairs[0].num_packets != 1)
+		return false;
+
+	/* TCP header has FIN or PUSH set */
+	if (coal_hdr->close_type == RMNET_MAP_COAL_CLOSE_COAL)
+		return true;
+
+	/* Hit packet limit, byte limit, or time limit/EOF on DMA */
+	if (coal_hdr->close_type == RMNET_MAP_COAL_CLOSE_HW) {
+		switch (coal_hdr->close_value) {
+		case RMNET_MAP_COAL_CLOSE_HW_PKT:
+		case RMNET_MAP_COAL_CLOSE_HW_BYTE:
+		case RMNET_MAP_COAL_CLOSE_HW_TIME:
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static void rmnet_map_move_headers(struct sk_buff *skb)
+{
+	struct iphdr *iph;
+	u16 ip_len;
+	u16 trans_len = 0;
+	u8 proto;
+
+	/* This only applies to non-linear SKBs */
+	if (!skb_is_nonlinear(skb))
+		return;
+
+	iph = (struct iphdr *)rmnet_map_data_ptr(skb);
+	if (iph->version == 4) {
+		ip_len = iph->ihl * 4;
+		proto = iph->protocol;
+		if (iph->frag_off & htons(IP_OFFSET))
+			/* No transport header information */
+			goto pull;
+	} else if (iph->version == 6) {
+		struct ipv6hdr *ip6h = (struct ipv6hdr *)iph;
+		__be16 frag_off;
+		u8 nexthdr = ip6h->nexthdr;
+
+		ip_len = ipv6_skip_exthdr(skb, sizeof(*ip6h), &nexthdr,
+					  &frag_off);
+		if (ip_len < 0)
+			return;
+
+		proto = nexthdr;
+	} else {
+		return;
+	}
+
+	if (proto == IPPROTO_TCP) {
+		struct tcphdr *tp = (struct tcphdr *)((u8 *)iph + ip_len);
+
+		trans_len = tp->doff * 4;
+	} else if (proto == IPPROTO_UDP) {
+		trans_len = sizeof(struct udphdr);
+	} else if (proto == NEXTHDR_FRAGMENT) {
+		/* Non-first fragments don't have the fragment length added by
+		 * ipv6_skip_exthdr() and sho up as proto NEXTHDR_FRAGMENT, so
+		 * we account for the length here.
+		 */
+		ip_len += sizeof(struct frag_hdr);
+	}
+
+pull:
+	__pskb_pull_tail(skb, ip_len + trans_len);
+	skb_reset_network_header(skb);
+	if (trans_len)
+		skb_set_transport_header(skb, ip_len);
+}
+
+static void rmnet_map_nonlinear_copy(struct sk_buff *coal_skb,
+				     struct rmnet_map_coal_metadata *coal_meta,
+				     struct sk_buff *dest)
+{
+	unsigned char *data_start = rmnet_map_data_ptr(coal_skb) +
+				    coal_meta->ip_len + coal_meta->trans_len;
+	u32 copy_len = coal_meta->data_len * coal_meta->pkt_count;
+
+	if (skb_is_nonlinear(coal_skb)) {
+		skb_frag_t *frag0 = skb_shinfo(coal_skb)->frags;
+		struct page *page = skb_frag_page(frag0);
+
+		skb_append_pagefrags(dest, page,
+				     frag0->bv_offset + coal_meta->ip_len +
+				     coal_meta->trans_len +
+				     coal_meta->data_offset,
+				     copy_len);
+		dest->data_len += copy_len;
+		dest->len += copy_len;
+	} else {
+		skb_put_data(dest, data_start + coal_meta->data_offset,
+			     copy_len);
+	}
+}
+
+/* Fill in GSO metadata to allow the SKB to be segmented by the NW stack
+ * if needed (i.e. forwarding, UDP GRO)
+ */
+static void rmnet_map_gso_stamp(struct sk_buff *skb,
+				struct rmnet_map_coal_metadata *coal_meta)
+{
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+
+	if (coal_meta->trans_proto == IPPROTO_TCP)
+		shinfo->gso_type = (coal_meta->ip_proto == 4) ?
+				   SKB_GSO_TCPV4 : SKB_GSO_TCPV6;
+	else
+		shinfo->gso_type = SKB_GSO_UDP_L4;
+
+	shinfo->gso_size = coal_meta->data_len;
+	shinfo->gso_segs = coal_meta->pkt_count;
+}
+
+/* Handles setting up the partial checksum in the skb. Sets the transport
+ * checksum to the pseudoheader checksum and sets the csum offload metadata
+ */
+static void rmnet_map_partial_csum(struct sk_buff *skb,
+				   struct rmnet_map_coal_metadata *coal_meta)
+{
+	unsigned char *data = skb->data;
+	__sum16 pseudo;
+	u16 pkt_len = skb->len - coal_meta->ip_len;
+
+	if (coal_meta->ip_proto == 4) {
+		struct iphdr *iph = (struct iphdr *)data;
+
+		pseudo = ~csum_tcpudp_magic(iph->saddr, iph->daddr,
+					    pkt_len, coal_meta->trans_proto,
+					    0);
+	} else {
+		struct ipv6hdr *ip6h = (struct ipv6hdr *)data;
+
+		pseudo = ~csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
+					  pkt_len, coal_meta->trans_proto, 0);
+	}
+
+	if (coal_meta->trans_proto == IPPROTO_TCP) {
+		struct tcphdr *tp = (struct tcphdr *)(data + coal_meta->ip_len);
+
+		tp->check = pseudo;
+		skb->csum_offset = offsetof(struct tcphdr, check);
+	} else {
+		struct udphdr *up = (struct udphdr *)(data + coal_meta->ip_len);
+
+		up->check = pseudo;
+		skb->csum_offset = offsetof(struct udphdr, check);
+	}
+
+	skb->ip_summed = CHECKSUM_PARTIAL;
+	skb->csum_start = skb->data + coal_meta->ip_len - skb->head;
+}
+
+static void
+__rmnet_map_segment_coal_skb(struct sk_buff *coal_skb,
+			     struct rmnet_map_coal_metadata *coal_meta,
+			     struct sk_buff_head *list, u8 pkt_id,
+			     bool csum_valid)
+{
+	struct sk_buff *skbn;
+	struct rmnet_priv *priv = netdev_priv(coal_skb->dev);
+	__sum16 *check = NULL;
+	u32 alloc_len;
+
+	/* We can avoid copying the data if the SKB we got from the lower-level
+	 * drivers was nonlinear.
+	 */
+	if (skb_is_nonlinear(coal_skb))
+		alloc_len = coal_meta->ip_len + coal_meta->trans_len;
+	else
+		alloc_len = coal_meta->ip_len + coal_meta->trans_len +
+			    (coal_meta->data_len * coal_meta->pkt_count);
+
+	skbn = alloc_skb(alloc_len, GFP_ATOMIC);
+	if (!skbn)
+		return;
+
+	skb_reserve(skbn, coal_meta->ip_len + coal_meta->trans_len);
+	rmnet_map_nonlinear_copy(coal_skb, coal_meta, skbn);
+
+	/* Push transport header and update necessary fields */
+	skb_push(skbn, coal_meta->trans_len);
+	memcpy(skbn->data, coal_meta->trans_header, coal_meta->trans_len);
+	skb_reset_transport_header(skbn);
+	if (coal_meta->trans_proto == IPPROTO_TCP) {
+		struct tcphdr *th = tcp_hdr(skbn);
+
+		th->seq = htonl(ntohl(th->seq) + coal_meta->data_offset);
+		check = &th->check;
+	} else if (coal_meta->trans_proto == IPPROTO_UDP) {
+		struct udphdr *uh = udp_hdr(skbn);
+
+		uh->len = htons(skbn->len);
+		check = &uh->check;
+	}
+
+	/* Push IP header and update necessary fields */
+	skb_push(skbn, coal_meta->ip_len);
+	memcpy(skbn->data, coal_meta->ip_header, coal_meta->ip_len);
+	skb_reset_network_header(skbn);
+	if (coal_meta->ip_proto == 4) {
+		struct iphdr *iph = ip_hdr(skbn);
+
+		iph->id = htons(ntohs(iph->id) + coal_meta->pkt_id);
+		iph->tot_len = htons(skbn->len);
+		iph->check = 0;
+		iph->check = ip_fast_csum(iph, iph->ihl);
+	} else {
+		/* Payload length includes any extension headers */
+		ipv6_hdr(skbn)->payload_len = htons(skbn->len -
+						    sizeof(struct ipv6hdr));
+	}
+
+	/* Handle checksum status */
+	if (likely(csum_valid)) {
+		/* Set the partial checksum information */
+		rmnet_map_partial_csum(skbn, coal_meta);
+	} else if (check) {
+		/* Unfortunately, we have to fake a bad checksum here, since
+		 * the original bad value is lost by the hardware. The only
+		 * reliable way to do it is to calculate the actual checksum
+		 * and corrupt it.
+		 */
+		__wsum csum;
+		unsigned int offset = skb_transport_offset(skbn);
+		__sum16 pseudo;
+
+		/* Calculate pseudo header */
+		if (coal_meta->ip_proto == 4) {
+			struct iphdr *iph = ip_hdr(skbn);
+
+			pseudo = ~csum_tcpudp_magic(iph->saddr, iph->daddr,
+						    skbn->len -
+						    coal_meta->ip_len,
+						    coal_meta->trans_proto, 0);
+		} else {
+			struct ipv6hdr *ip6h = ipv6_hdr(skbn);
+
+			pseudo = ~csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
+						  skbn->len - coal_meta->ip_len,
+						  coal_meta->trans_proto, 0);
+		}
+
+		*check = pseudo;
+		csum = skb_checksum(skbn, offset, skbn->len - offset, 0);
+		/* Add 1 to corrupt. This cannot produce a final value of 0
+		 * since csum_fold() can't return a value of 0xFFFF.
+		 */
+		*check = csum16_add(csum_fold(csum), htons(1));
+		skbn->ip_summed = CHECKSUM_NONE;
+	}
+
+	skbn->dev = coal_skb->dev;
+	priv->stats.coal.coal_reconstruct++;
+
+	/* Stamp GSO information if necessary */
+	if (coal_meta->pkt_count > 1)
+		rmnet_map_gso_stamp(skbn, coal_meta);
+
+	__skb_queue_tail(list, skbn);
+
+	/* Update meta information to move past the data we just segmented */
+	coal_meta->data_offset += coal_meta->data_len * coal_meta->pkt_count;
+	coal_meta->pkt_id = pkt_id + 1;
+	coal_meta->pkt_count = 0;
+}
+
+static bool rmnet_map_validate_csum(struct sk_buff *skb,
+				    struct rmnet_map_coal_metadata *meta)
+{
+	u8 *data = rmnet_map_data_ptr(skb);
+	unsigned int datagram_len;
+	__wsum csum;
+	__sum16 pseudo;
+
+	datagram_len = skb->len - meta->ip_len;
+	if (meta->ip_proto == 4) {
+		struct iphdr *iph = (struct iphdr *)data;
+
+		pseudo = ~csum_tcpudp_magic(iph->saddr, iph->daddr,
+					    datagram_len,
+					    meta->trans_proto, 0);
+	} else {
+		struct ipv6hdr *ip6h = (struct ipv6hdr *)data;
+
+		pseudo = ~csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
+					  datagram_len, meta->trans_proto,
+					  0);
+	}
+
+	csum = skb_checksum(skb, meta->ip_len, datagram_len,
+			    csum_unfold(pseudo));
+	return !csum_fold(csum);
+}
+
+/* Converts the coalesced SKB into a list of SKBs.
+ * NLOs containing csum erros will not be included.
+ * The original coalesced SKB should be treated as invalid and
+ * must be freed by the caller
+ */
+static void rmnet_map_segment_coal_skb(struct sk_buff *coal_skb,
+				       u64 nlo_err_mask,
+				       struct sk_buff_head *list)
+{
+	struct iphdr *iph;
+	struct rmnet_priv *priv = netdev_priv(coal_skb->dev);
+	struct rmnet_map_v5_coal_header *coal_hdr;
+	struct rmnet_map_coal_metadata coal_meta;
+	u16 pkt_len;
+	u8 pkt, total_pkt = 0;
+	u8 nlo;
+	bool gro = coal_skb->dev->features & NETIF_F_GRO_HW;
+
+	memset(&coal_meta, 0, sizeof(coal_meta));
+
+	/* Pull off the headers we no longer need */
+	pskb_pull(coal_skb, sizeof(struct rmnet_map_header));
+	coal_hdr = (struct rmnet_map_v5_coal_header *)
+		   rmnet_map_data_ptr(coal_skb);
+	pskb_pull(coal_skb, sizeof(*coal_hdr));
+
+	iph = (struct iphdr *)rmnet_map_data_ptr(coal_skb);
+
+	if (iph->version == 4) {
+		coal_meta.ip_proto = 4;
+		coal_meta.ip_len = iph->ihl * 4;
+		coal_meta.trans_proto = iph->protocol;
+		coal_meta.ip_header = iph;
+
+		/* Don't allow coalescing of any packets with IP options */
+		if (iph->ihl != 5)
+			gro = false;
+	} else if (iph->version == 6) {
+		struct ipv6hdr *ip6h = (struct ipv6hdr *)iph;
+		__be16 frag_off;
+		u8 protocol = ip6h->nexthdr;
+
+		coal_meta.ip_proto = 6;
+		coal_meta.ip_len = ipv6_skip_exthdr(coal_skb, sizeof(*ip6h),
+						    &protocol, &frag_off);
+		coal_meta.trans_proto = protocol;
+		coal_meta.ip_header = ip6h;
+
+		/* If we run into a problem, or this has a fragment header
+		 * (which should technically not be possible, if the HW
+		 * works as intended...), bail.
+		 */
+		if (coal_meta.ip_len < 0 || frag_off) {
+			priv->stats.coal.coal_ip_invalid++;
+			return;
+		} else if (coal_meta.ip_len > sizeof(*ip6h)) {
+			/* Don't allow coalescing of any packets with IPv6
+			 * extension headers.
+			 */
+			gro = false;
+		}
+	} else {
+		priv->stats.coal.coal_ip_invalid++;
+		return;
+	}
+
+	if (coal_meta.trans_proto == IPPROTO_TCP) {
+		struct tcphdr *th;
+
+		th = (struct tcphdr *)((u8 *)iph + coal_meta.ip_len);
+		coal_meta.trans_len = th->doff * 4;
+		coal_meta.trans_header = th;
+	} else if (coal_meta.trans_proto == IPPROTO_UDP) {
+		struct udphdr *uh;
+
+		uh = (struct udphdr *)((u8 *)iph + coal_meta.ip_len);
+		coal_meta.trans_len = sizeof(*uh);
+		coal_meta.trans_header = uh;
+	} else {
+		priv->stats.coal.coal_trans_invalid++;
+		return;
+	}
+
+	if (rmnet_map_v5_csum_buggy(coal_hdr)) {
+		rmnet_map_move_headers(coal_skb);
+		/* Mark as valid if it checks out */
+		if (rmnet_map_validate_csum(coal_skb, &coal_meta))
+			coal_skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+		__skb_queue_tail(list, coal_skb);
+		return;
+	}
+
+	/* Fast-forward the case where we have 1 NLO (i.e. 1 packet length),
+	 * no checksum errors, and are allowing GRO. We can just reuse this
+	 * SKB unchanged.
+	 */
+	if (gro && coal_hdr->num_nlos == 1 && coal_hdr->csum_valid) {
+		rmnet_map_move_headers(coal_skb);
+		coal_skb->ip_summed = CHECKSUM_UNNECESSARY;
+		coal_meta.data_len = ntohs(coal_hdr->nl_pairs[0].pkt_len);
+		coal_meta.data_len -= coal_meta.ip_len + coal_meta.trans_len;
+		coal_meta.pkt_count = coal_hdr->nl_pairs[0].num_packets;
+		if (coal_meta.pkt_count > 1) {
+			rmnet_map_partial_csum(coal_skb, &coal_meta);
+			rmnet_map_gso_stamp(coal_skb, &coal_meta);
+		}
+
+		__skb_queue_tail(list, coal_skb);
+		return;
+	}
+
+	/* Segment the coalesced SKB into new packets */
+	for (nlo = 0; nlo < coal_hdr->num_nlos; nlo++) {
+		pkt_len = ntohs(coal_hdr->nl_pairs[nlo].pkt_len);
+		pkt_len -= coal_meta.ip_len + coal_meta.trans_len;
+		coal_meta.data_len = pkt_len;
+		for (pkt = 0; pkt < coal_hdr->nl_pairs[nlo].num_packets;
+		     pkt++, total_pkt++, nlo_err_mask >>= 1) {
+			bool csum_err = nlo_err_mask & 1;
+
+			/* Segment the packet if we're not sending the larger
+			 * packet up the stack.
+			 */
+			if (!gro) {
+				coal_meta.pkt_count = 1;
+				if (csum_err)
+					priv->stats.coal.coal_csum_err++;
+
+				__rmnet_map_segment_coal_skb(coal_skb,
+							     &coal_meta, list,
+							     total_pkt,
+							     !csum_err);
+				continue;
+			}
+
+			if (csum_err) {
+				priv->stats.coal.coal_csum_err++;
+
+				/* Segment out the good data */
+				if (gro && coal_meta.pkt_count)
+					__rmnet_map_segment_coal_skb(coal_skb,
+								     &coal_meta,
+								     list,
+								     total_pkt,
+								     true);
+
+				/* Segment out the bad checksum */
+				coal_meta.pkt_count = 1;
+				__rmnet_map_segment_coal_skb(coal_skb,
+							     &coal_meta, list,
+							     total_pkt, false);
+			} else {
+				coal_meta.pkt_count++;
+			}
+		}
+
+		/* If we're switching NLOs, we need to send out everything from
+		 * the previous one, if we haven't done so. NLOs only switch
+		 * when the packet length changes.
+		 */
+		if (coal_meta.pkt_count)
+			__rmnet_map_segment_coal_skb(coal_skb, &coal_meta, list,
+						     total_pkt, true);
+	}
+}
+
+/* Record reason for coalescing pipe closure */
+static void rmnet_map_data_log_close_stats(struct rmnet_priv *priv, u8 type,
+					   u8 code)
+{
+	struct rmnet_coal_close_stats *stats = &priv->stats.coal.close;
+
+	switch (type) {
+	case RMNET_MAP_COAL_CLOSE_NON_COAL:
+		stats->non_coal++;
+		break;
+	case RMNET_MAP_COAL_CLOSE_IP_MISS:
+		stats->ip_miss++;
+		break;
+	case RMNET_MAP_COAL_CLOSE_TRANS_MISS:
+		stats->trans_miss++;
+		break;
+	case RMNET_MAP_COAL_CLOSE_HW:
+		switch (code) {
+		case RMNET_MAP_COAL_CLOSE_HW_NL:
+			stats->hw_nl++;
+			break;
+		case RMNET_MAP_COAL_CLOSE_HW_PKT:
+			stats->hw_pkt++;
+			break;
+		case RMNET_MAP_COAL_CLOSE_HW_BYTE:
+			stats->hw_byte++;
+			break;
+		case RMNET_MAP_COAL_CLOSE_HW_TIME:
+			stats->hw_time++;
+			break;
+		case RMNET_MAP_COAL_CLOSE_HW_EVICT:
+			stats->hw_evict++;
+			break;
+		default:
+			break;
+		}
+		break;
+	case RMNET_MAP_COAL_CLOSE_COAL:
+		stats->coal++;
+		break;
+	default:
+		break;
+	}
+}
+
+/* Check if the coalesced header has any incorrect values, in which case, the
+ * entire coalesced skb must be dropped. Then check if there are any
+ * checksum issues
+ */
+static int rmnet_map_data_check_coal_header(struct sk_buff *skb,
+					    u64 *nlo_err_mask)
+{
+	struct rmnet_map_v5_coal_header *coal_hdr;
+	unsigned char *data = rmnet_map_data_ptr(skb);
+	struct rmnet_priv *priv = netdev_priv(skb->dev);
+	u64 mask = 0;
+	int i;
+	u8 veid, pkts = 0;
+
+	coal_hdr = ((struct rmnet_map_v5_coal_header *)
+		    (data + sizeof(struct rmnet_map_header)));
+	veid = coal_hdr->virtual_channel_id;
+
+	if (coal_hdr->num_nlos == 0 ||
+	    coal_hdr->num_nlos > RMNET_MAP_V5_MAX_NLOS) {
+		priv->stats.coal.coal_hdr_nlo_err++;
+		return -EINVAL;
+	}
+
+	for (i = 0; i < RMNET_MAP_V5_MAX_NLOS; i++) {
+		/* If there is a checksum issue, we need to split
+		 * up the skb. Rebuild the full csum error field
+		 */
+		u8 err = coal_hdr->nl_pairs[i].csum_error_bitmap;
+		u8 pkt = coal_hdr->nl_pairs[i].num_packets;
+
+		mask |= ((u64)err) << (8 * i);
+
+		/* Track total packets in frame */
+		pkts += pkt;
+		if (pkts > RMNET_MAP_V5_MAX_PACKETS) {
+			priv->stats.coal.coal_hdr_pkt_err++;
+			return -EINVAL;
+		}
+	}
+
+	/* Track number of packets we get inside of coalesced frames */
+	priv->stats.coal.coal_pkts += pkts;
+
+	/* Update ethtool stats */
+	rmnet_map_data_log_close_stats(priv,
+				       coal_hdr->close_type,
+				       coal_hdr->close_value);
+	if (veid < RMNET_MAX_VEID)
+		priv->stats.coal.coal_veid[veid]++;
+
+	*nlo_err_mask = mask;
+
+	return 0;
+}
+
+/* Process a QMAPv5 packet header */
+int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
+				      struct sk_buff_head *list,
+				      u16 len)
+{
+	struct rmnet_priv *priv = netdev_priv(skb->dev);
+	u64 nlo_err_mask;
+	int rc = 0;
+
+	switch (rmnet_map_get_next_hdr_type(skb)) {
+	case RMNET_MAP_HEADER_TYPE_COALESCING:
+		priv->stats.coal.coal_rx++;
+		rc = rmnet_map_data_check_coal_header(skb, &nlo_err_mask);
+		if (rc)
+			return rc;
+
+		rmnet_map_segment_coal_skb(skb, nlo_err_mask, list);
+		if (skb_peek(list) != skb)
+			consume_skb(skb);
+		break;
+	case RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD:
+		if (rmnet_map_get_csum_valid(skb)) {
+			priv->stats.csum_ok++;
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+		} else {
+			priv->stats.csum_valid_unset++;
+		}
+
+		/* Pull unnecessary headers and move the rest to the linear
+		 * section of the skb.
+		 */
+		pskb_pull(skb,
+			  (sizeof(struct rmnet_map_header) +
+			   sizeof(struct rmnet_map_v5_csum_header)));
+		rmnet_map_move_headers(skb);
+
+		/* Remove padding only for csum offload packets.
+		 * Coalesced packets should never have padding.
+		 */
+		pskb_trim(skb, len);
+		__skb_queue_tail(list, skb);
+		break;
+	default:
+		rc = -EINVAL;
+		break;
+	}
+
+	return rc;
+}
+
+long rmnet_agg_time_limit __read_mostly = 1000000L;
+long rmnet_agg_bypass_time __read_mostly = 10000000L;
+
+int rmnet_map_tx_agg_skip(struct sk_buff *skb, int offset)
+{
+	u8 *packet_start = skb->data + offset;
+	int is_icmp = 0;
+
+	if (skb->protocol == htons(ETH_P_IP)) {
+		struct iphdr *ip4h = (struct iphdr *)(packet_start);
+
+		if (ip4h->protocol == IPPROTO_ICMP)
+			is_icmp = 1;
+	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		struct ipv6hdr *ip6h = (struct ipv6hdr *)(packet_start);
+
+		if (ip6h->nexthdr == IPPROTO_ICMPV6) {
+			is_icmp = 1;
+		} else if (ip6h->nexthdr == NEXTHDR_FRAGMENT) {
+			struct frag_hdr *frag;
+
+			frag = (struct frag_hdr *)(packet_start
+						   + sizeof(struct ipv6hdr));
+			if (frag->nexthdr == IPPROTO_ICMPV6)
+				is_icmp = 1;
+		}
+	}
+
+	return is_icmp;
+}
+
+static void rmnet_map_flush_tx_packet_work(struct work_struct *work)
+{
+	struct sk_buff *skb = NULL;
+	struct rmnet_port *port;
+	unsigned long flags;
+
+	port = container_of(work, struct rmnet_port, agg_wq);
+
+	spin_lock_irqsave(&port->agg_lock, flags);
+	if (likely(port->agg_state == -EINPROGRESS)) {
+		/* Buffer may have already been shipped out */
+		if (likely(port->agg_skb)) {
+			skb = port->agg_skb;
+			port->agg_skb = NULL;
+			port->agg_count = 0;
+			memset(&port->agg_time, 0, sizeof(struct timespec));
+		}
+		port->agg_state = 0;
+	}
+
+	spin_unlock_irqrestore(&port->agg_lock, flags);
+	if (skb)
+		dev_queue_xmit(skb);
+}
+
+enum hrtimer_restart rmnet_map_flush_tx_packet_queue(struct hrtimer *t)
+{
+	struct rmnet_port *port;
+
+	port = container_of(t, struct rmnet_port, hrtimer);
+
+	schedule_work(&port->agg_wq);
+	return HRTIMER_NORESTART;
+}
+
+static void rmnet_map_linearize_copy(struct sk_buff *dst, struct sk_buff *src)
+{
+	unsigned int linear = src->len - src->data_len, target = src->len;
+	unsigned char *src_buf;
+	struct sk_buff *skb;
+
+	src_buf = src->data;
+	skb_put_data(dst, src_buf, linear);
+	target -= linear;
+
+	skb = src;
+
+	while (target) {
+		unsigned int i = 0, non_linear = 0;
+
+		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+			non_linear = skb_frag_size(&skb_shinfo(skb)->frags[i]);
+			src_buf = skb_frag_address(&skb_shinfo(skb)->frags[i]);
+
+			skb_put_data(dst, src_buf, non_linear);
+			target -= non_linear;
+		}
+
+		if (skb_shinfo(skb)->frag_list) {
+			skb = skb_shinfo(skb)->frag_list;
+			continue;
+		}
+
+		if (skb->next)
+			skb = skb->next;
+	}
+}
+
+void rmnet_map_tx_aggregate(struct sk_buff *skb, struct rmnet_port *port)
+{
+	struct timespec64 diff, last;
+	int size, agg_count = 0;
+	struct sk_buff *agg_skb;
+	unsigned long flags;
+
+new_packet:
+	spin_lock_irqsave(&port->agg_lock, flags);
+	memcpy(&last, &port->agg_last, sizeof(struct timespec));
+	ktime_get_real_ts64(&port->agg_last);
+
+	if (!port->agg_skb) {
+		/* Check to see if we should agg first. If the traffic is very
+		 * sparse, don't aggregate. We will need to tune this later
+		 */
+		diff = timespec64_sub(port->agg_last, last);
+		size = port->egress_agg_params.agg_size - skb->len;
+
+		if (diff.tv_sec > 0 || diff.tv_nsec > rmnet_agg_bypass_time ||
+		    size <= 0) {
+			spin_unlock_irqrestore(&port->agg_lock, flags);
+			skb->protocol = htons(ETH_P_MAP);
+			dev_queue_xmit(skb);
+			return;
+		}
+
+		port->agg_skb = alloc_skb(port->egress_agg_params.agg_size,
+					  GFP_ATOMIC);
+		if (!port->agg_skb) {
+			port->agg_skb = 0;
+			port->agg_count = 0;
+			memset(&port->agg_time, 0, sizeof(struct timespec));
+			spin_unlock_irqrestore(&port->agg_lock, flags);
+			skb->protocol = htons(ETH_P_MAP);
+			dev_queue_xmit(skb);
+			return;
+		}
+		rmnet_map_linearize_copy(port->agg_skb, skb);
+		port->agg_skb->dev = skb->dev;
+		port->agg_skb->protocol = htons(ETH_P_MAP);
+		port->agg_count = 1;
+		ktime_get_real_ts64(&port->agg_time);
+		dev_kfree_skb_any(skb);
+		goto schedule;
+	}
+	diff = timespec64_sub(port->agg_last, port->agg_time);
+	size = port->egress_agg_params.agg_size - port->agg_skb->len;
+
+	if (skb->len > size ||
+	    port->agg_count >= port->egress_agg_params.agg_count ||
+	    diff.tv_sec > 0 || diff.tv_nsec > rmnet_agg_time_limit) {
+		agg_skb = port->agg_skb;
+		agg_count = port->agg_count;
+		port->agg_skb = 0;
+		port->agg_count = 0;
+		memset(&port->agg_time, 0, sizeof(struct timespec));
+		port->agg_state = 0;
+		spin_unlock_irqrestore(&port->agg_lock, flags);
+		hrtimer_cancel(&port->hrtimer);
+		dev_queue_xmit(agg_skb);
+		goto new_packet;
+	}
+
+	rmnet_map_linearize_copy(port->agg_skb, skb);
+	port->agg_count++;
+	dev_kfree_skb_any(skb);
+
+schedule:
+	if (port->agg_state != -EINPROGRESS) {
+		port->agg_state = -EINPROGRESS;
+		hrtimer_start(&port->hrtimer,
+			      ns_to_ktime(port->egress_agg_params.agg_time),
+			      HRTIMER_MODE_REL);
+	}
+	spin_unlock_irqrestore(&port->agg_lock, flags);
+}
+
+void rmnet_map_tx_aggregate_init(struct rmnet_port *port)
+{
+	hrtimer_init(&port->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	port->hrtimer.function = rmnet_map_flush_tx_packet_queue;
+	port->egress_agg_params.agg_size = 8192;
+	port->egress_agg_params.agg_count = 20;
+	port->egress_agg_params.agg_time = 3000000;
+	spin_lock_init(&port->agg_lock);
+
+	INIT_WORK(&port->agg_wq, rmnet_map_flush_tx_packet_work);
+}
+
+void rmnet_map_tx_aggregate_exit(struct rmnet_port *port)
+{
+	unsigned long flags;
+
+	hrtimer_cancel(&port->hrtimer);
+	cancel_work_sync(&port->agg_wq);
+
+	spin_lock_irqsave(&port->agg_lock, flags);
+	if (port->agg_state == -EINPROGRESS) {
+		if (port->agg_skb) {
+			kfree_skb(port->agg_skb);
+			port->agg_skb = NULL;
+			port->agg_count = 0;
+			memset(&port->agg_time, 0, sizeof(struct timespec));
+		}
+
+		port->agg_state = 0;
+	}
+
+	spin_unlock_irqrestore(&port->agg_lock, flags);
+}
+
+void rmnet_map_tx_qmap_cmd(struct sk_buff *qmap_skb)
+{
+	struct rmnet_port *port;
+	struct sk_buff *agg_skb;
+	unsigned long flags;
+
+	port = rmnet_get_port(qmap_skb->dev);
+
+	if (port->data_format & RMNET_EGRESS_FORMAT_AGGREGATION) {
+		spin_lock_irqsave(&port->agg_lock, flags);
+		if (port->agg_skb) {
+			agg_skb = port->agg_skb;
+			port->agg_skb = 0;
+			port->agg_count = 0;
+			memset(&port->agg_time, 0, sizeof(struct timespec));
+			port->agg_state = 0;
+			spin_unlock_irqrestore(&port->agg_lock, flags);
+			hrtimer_cancel(&port->hrtimer);
+			dev_queue_xmit(agg_skb);
+		} else {
+			spin_unlock_irqrestore(&port->agg_lock, flags);
+		}
+	}
+
+	dev_queue_xmit(qmap_skb);
+}
+EXPORT_SYMBOL(rmnet_map_tx_qmap_cmd);
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_private.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_private.h
index e1337f164faa..b31d3a889720 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_private.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_private.h
@@ -1,5 +1,14 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright (c) 2013-2014, 2016-2018 The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2014, 2016-2019 The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  */
 
 #ifndef _RMNET_PRIVATE_H_
@@ -10,6 +19,14 @@
 #define RMNET_NEEDED_HEADROOM      16
 #define RMNET_TX_QUEUE_LEN         1000
 
+/* Constants */
+#define RMNET_EGRESS_FORMAT_AGGREGATION         BIT(31)
+#define RMNET_INGRESS_FORMAT_DL_MARKER_V1       BIT(30)
+#define RMNET_INGRESS_FORMAT_DL_MARKER_V2       BIT(29)
+
+#define RMNET_INGRESS_FORMAT_DL_MARKER  (RMNET_INGRESS_FORMAT_DL_MARKER_V1 |\
+RMNET_INGRESS_FORMAT_DL_MARKER_V2)
+
 /* Replace skb->dev to a virtual rmnet device and pass up the stack */
 #define RMNET_EPMODE_VND (1)
 /* Pass the frame directly to another device with dev_queue_xmit() */
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_trace.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_trace.h
new file mode 100644
index 000000000000..8ef2bbfc0d9c
--- /dev/null
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_trace.h
@@ -0,0 +1,250 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rmnet
+#define TRACE_INCLUDE_FILE rmnet_trace
+
+#if !defined(_RMNET_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
+#define _RMNET_TRACE_H_
+
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/tracepoint.h>
+
+/*****************************************************************************/
+/* Trace events for rmnet module */
+/*****************************************************************************/
+DECLARE_EVENT_CLASS
+	(rmnet_mod_template,
+
+	TP_PROTO(u8 func, u8 evt, u32 uint1, u32 uint2,
+		 u64 ulong1, u64 ulong2, void *ptr1, void *ptr2),
+
+	TP_ARGS(func, evt, uint1, uint2, ulong1, ulong2, ptr1, ptr2),
+
+	TP_STRUCT__entry(__field(u8, func)
+		__field(u8, evt)
+		__field(u32, uint1)
+		__field(u32, uint2)
+		__field(u64, ulong1)
+		__field(u64, ulong2)
+		__field(void *, ptr1)
+		__field(void *, ptr2)),
+
+	TP_fast_assign(__entry->func = func;
+		__entry->evt = evt;
+		__entry->uint1 = uint1;
+		__entry->uint2 = uint2;
+		__entry->ulong1 = ulong1;
+		__entry->ulong2 = ulong2;
+		__entry->ptr1 = ptr1;
+		__entry->ptr2 = ptr2;),
+
+TP_printk("fun:%u ev:%u u1:%u u2:%u ul1:%llu ul2:%llu p1:0x%pK p2:0x%pK",
+	  __entry->func, __entry->evt,
+	  __entry->uint1, __entry->uint2,
+	  __entry->ulong1, __entry->ulong2,
+	  __entry->ptr1, __entry->ptr2)
+
+)
+
+DEFINE_EVENT
+	(rmnet_mod_template, rmnet_low,
+
+	 TP_PROTO(u8 func, u8 evt, u32 uint1, u32 uint2,
+		  u64 ulong1, u64 ulong2, void *ptr1, void *ptr2),
+
+	 TP_ARGS(func, evt, uint1, uint2, ulong1, ulong2, ptr1, ptr2)
+
+);
+
+DEFINE_EVENT
+	(rmnet_mod_template, rmnet_high,
+
+	 TP_PROTO(u8 func, u8 evt, u32 uint1, u32 uint2,
+		  u64 ulong1, u64 ulong2, void *ptr1, void *ptr2),
+
+	 TP_ARGS(func, evt, uint1, uint2, ulong1, ulong2, ptr1, ptr2)
+
+);
+
+DEFINE_EVENT
+	(rmnet_mod_template, rmnet_err,
+
+	 TP_PROTO(u8 func, u8 evt, u32 uint1, u32 uint2,
+		  u64 ulong1, u64 ulong2, void *ptr1, void *ptr2),
+
+	 TP_ARGS(func, evt, uint1, uint2, ulong1, ulong2, ptr1, ptr2)
+
+);
+
+/*****************************************************************************/
+/* Trace events for rmnet_perf module */
+/*****************************************************************************/
+DEFINE_EVENT
+	(rmnet_mod_template, rmnet_perf_low,
+
+	 TP_PROTO(u8 func, u8 evt, u32 uint1, u32 uint2,
+		  u64 ulong1, u64 ulong2, void *ptr1, void *ptr2),
+
+	 TP_ARGS(func, evt, uint1, uint2, ulong1, ulong2, ptr1, ptr2)
+
+);
+
+DEFINE_EVENT
+	(rmnet_mod_template, rmnet_perf_high,
+
+	 TP_PROTO(u8 func, u8 evt, u32 uint1, u32 uint2,
+		  u64 ulong1, u64 ulong2, void *ptr1, void *ptr2),
+
+	 TP_ARGS(func, evt, uint1, uint2, ulong1, ulong2, ptr1, ptr2)
+
+);
+
+DEFINE_EVENT
+	(rmnet_mod_template, rmnet_perf_err,
+
+	 TP_PROTO(u8 func, u8 evt, u32 uint1, u32 uint2,
+		  u64 ulong1, u64 ulong2, void *ptr1, void *ptr2),
+
+	 TP_ARGS(func, evt, uint1, uint2, ulong1, ulong2, ptr1, ptr2)
+
+);
+
+/*****************************************************************************/
+/* Trace events for rmnet_shs module */
+/*****************************************************************************/
+DEFINE_EVENT
+	(rmnet_mod_template, rmnet_shs_low,
+
+	 TP_PROTO(u8 func, u8 evt, u32 uint1, u32 uint2,
+		  u64 ulong1, u64 ulong2, void *ptr1, void *ptr2),
+
+	 TP_ARGS(func, evt, uint1, uint2, ulong1, ulong2, ptr1, ptr2)
+
+);
+
+DEFINE_EVENT
+	(rmnet_mod_template, rmnet_shs_high,
+
+	 TP_PROTO(u8 func, u8 evt, u32 uint1, u32 uint2,
+		  u64 ulong1, u64 ulong2, void *ptr1, void *ptr2),
+
+	 TP_ARGS(func, evt, uint1, uint2, ulong1, ulong2, ptr1, ptr2)
+
+);
+
+DEFINE_EVENT
+	(rmnet_mod_template, rmnet_shs_err,
+
+	 TP_PROTO(u8 func, u8 evt, u32 uint1, u32 uint2,
+		  u64 ulong1, u64 ulong2, void *ptr1, void *ptr2),
+
+	 TP_ARGS(func, evt, uint1, uint2, ulong1, ulong2, ptr1, ptr2)
+
+);
+
+DEFINE_EVENT
+	(rmnet_mod_template, rmnet_shs_wq_low,
+
+	 TP_PROTO(u8 func, u8 evt, u32 uint1, u32 uint2,
+		  u64 ulong1, u64 ulong2, void *ptr1, void *ptr2),
+
+	 TP_ARGS(func, evt, uint1, uint2, ulong1, ulong2, ptr1, ptr2)
+
+);
+
+DEFINE_EVENT
+	(rmnet_mod_template, rmnet_shs_wq_high,
+
+	 TP_PROTO(u8 func, u8 evt, u32 uint1, u32 uint2,
+		  u64 ulong1, u64 ulong2, void *ptr1, void *ptr2),
+
+	 TP_ARGS(func, evt, uint1, uint2, ulong1, ulong2, ptr1, ptr2)
+
+);
+
+DEFINE_EVENT
+	(rmnet_mod_template, rmnet_shs_wq_err,
+
+	 TP_PROTO(u8 func, u8 evt, u32 uint1, u32 uint2,
+		  u64 ulong1, u64 ulong2, void *ptr1, void *ptr2),
+
+	 TP_ARGS(func, evt, uint1, uint2, ulong1, ulong2, ptr1, ptr2)
+
+);
+
+DECLARE_EVENT_CLASS
+	(rmnet_freq_template,
+
+	 TP_PROTO(u8 core, u32 newfreq),
+
+	 TP_ARGS(core, newfreq),
+
+	 TP_STRUCT__entry(__field(u8, core)
+		__field(u32, newfreq)
+	 ),
+
+	 TP_fast_assign(__entry->core = core;
+		__entry->newfreq = newfreq;
+
+	 ),
+
+TP_printk("freq policy core:%u freq floor :%u",
+	  __entry->core, __entry->newfreq)
+
+);
+
+DEFINE_EVENT
+	(rmnet_freq_template, rmnet_freq_boost,
+
+	 TP_PROTO(u8 core, u32 newfreq),
+
+	 TP_ARGS(core, newfreq)
+);
+
+DEFINE_EVENT
+	(rmnet_freq_template, rmnet_freq_reset,
+
+	 TP_PROTO(u8 core, u32 newfreq),
+
+	 TP_ARGS(core, newfreq)
+);
+
+TRACE_EVENT
+	(rmnet_freq_update,
+
+	 TP_PROTO(u8 core, u32 lowfreq, u32 highfreq),
+
+	 TP_ARGS(core, lowfreq, highfreq),
+
+	 TP_STRUCT__entry(__field(u8, core)
+		__field(u32, lowfreq)
+		__field(u32, highfreq)
+	 ),
+
+	 TP_fast_assign(__entry->core = core;
+		__entry->lowfreq = lowfreq;
+		__entry->highfreq = highfreq;
+	 ),
+
+TP_printk("freq policy update core:%u policy freq floor :%u freq ceil :%u",
+	  __entry->core, __entry->lowfreq, __entry->highfreq)
+);
+#endif /* _RMNET_TRACE_H_ */
+
+/* This part must be outside protection */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../drivers/net/ethernet/qualcomm/rmnet
+#include <trace/define_trace.h>
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 509dfc895a33..5deb1c1657ba 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -1,11 +1,23 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2019, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
  *
  * RMNET Data virtual network driver
+ *
  */
 
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
+#include <linux/ip.h>
 #include <net/pkt_sched.h>
 #include "rmnet_config.h"
 #include "rmnet_handlers.h"
@@ -15,7 +27,7 @@
 
 /* RX/TX Fixup */
 
-void rmnet_vnd_rx_fixup(struct sk_buff *skb, struct net_device *dev)
+void rmnet_vnd_rx_fixup(struct net_device *dev, u32 skb_len)
 {
 	struct rmnet_priv *priv = netdev_priv(dev);
 	struct rmnet_pcpu_stats *pcpu_ptr;
@@ -24,11 +36,11 @@ void rmnet_vnd_rx_fixup(struct sk_buff *skb, struct net_device *dev)
 
 	u64_stats_update_begin(&pcpu_ptr->syncp);
 	pcpu_ptr->stats.rx_pkts++;
-	pcpu_ptr->stats.rx_bytes += skb->len;
+	pcpu_ptr->stats.rx_bytes += skb_len;
 	u64_stats_update_end(&pcpu_ptr->syncp);
 }
 
-void rmnet_vnd_tx_fixup(struct sk_buff *skb, struct net_device *dev)
+void rmnet_vnd_tx_fixup(struct net_device *dev, u32 skb_len)
 {
 	struct rmnet_priv *priv = netdev_priv(dev);
 	struct rmnet_pcpu_stats *pcpu_ptr;
@@ -37,7 +49,7 @@ void rmnet_vnd_tx_fixup(struct sk_buff *skb, struct net_device *dev)
 
 	u64_stats_update_begin(&pcpu_ptr->syncp);
 	pcpu_ptr->stats.tx_pkts++;
-	pcpu_ptr->stats.tx_bytes += skb->len;
+	pcpu_ptr->stats.tx_bytes += skb_len;
 	u64_stats_update_end(&pcpu_ptr->syncp);
 }
 
@@ -152,6 +164,43 @@ static const char rmnet_gstrings_stats[][ETH_GSTRING_LEN] = {
 	"Checksum skipped on ip fragment",
 	"Checksum skipped",
 	"Checksum computed in software",
+	"Checksum computed in hardware",
+	"Coalescing packets received",
+	"Coalesced packets",
+	"Coalescing header NLO errors",
+	"Coalescing header pcount errors",
+	"Coalescing checksum errors",
+	"Coalescing packet reconstructs",
+	"Coalescing IP version invalid",
+	"Coalescing L4 header invalid",
+	"Coalescing close Non-coalescable",
+	"Coalescing close L3 mismatch",
+	"Coalescing close L4 mismatch",
+	"Coalescing close HW NLO limit",
+	"Coalescing close HW packet limit",
+	"Coalescing close HW byte limit",
+	"Coalescing close HW time limit",
+	"Coalescing close HW eviction",
+	"Coalescing close Coalescable",
+	"Coalescing packets over VEID0",
+	"Coalescing packets over VEID1",
+	"Coalescing packets over VEID2",
+	"Coalescing packets over VEID3",
+};
+
+static const char rmnet_port_gstrings_stats[][ETH_GSTRING_LEN] = {
+	"MAP Cmd last version",
+	"MAP Cmd last ep id",
+	"MAP Cmd last transaction id",
+	"DL header last seen sequence",
+	"DL header last seen bytes",
+	"DL header last seen packets",
+	"DL header last seen flows",
+	"DL header pkts received",
+	"DL header total bytes received",
+	"DL header total pkts received",
+	"DL trailer last seen sequence",
+	"DL trailer pkts received",
 };
 
 static void rmnet_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
@@ -160,6 +209,9 @@ static void rmnet_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 	case ETH_SS_STATS:
 		memcpy(buf, &rmnet_gstrings_stats,
 		       sizeof(rmnet_gstrings_stats));
+		memcpy(buf + sizeof(rmnet_gstrings_stats),
+		       &rmnet_port_gstrings_stats,
+		       sizeof(rmnet_port_gstrings_stats));
 		break;
 	}
 }
@@ -168,7 +220,8 @@ static int rmnet_get_sset_count(struct net_device *dev, int sset)
 {
 	switch (sset) {
 	case ETH_SS_STATS:
-		return ARRAY_SIZE(rmnet_gstrings_stats);
+		return ARRAY_SIZE(rmnet_gstrings_stats) +
+		       ARRAY_SIZE(rmnet_port_gstrings_stats);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -179,17 +232,42 @@ static void rmnet_get_ethtool_stats(struct net_device *dev,
 {
 	struct rmnet_priv *priv = netdev_priv(dev);
 	struct rmnet_priv_stats *st = &priv->stats;
+	struct rmnet_port_priv_stats *stp;
+	struct rmnet_port *port;
+
+	port = rmnet_get_port(priv->real_dev);
 
-	if (!data)
+	if (!data || !port)
 		return;
 
+	stp = &port->stats;
+
 	memcpy(data, st, ARRAY_SIZE(rmnet_gstrings_stats) * sizeof(u64));
+	memcpy(data + ARRAY_SIZE(rmnet_gstrings_stats), stp,
+	       ARRAY_SIZE(rmnet_port_gstrings_stats) * sizeof(u64));
+}
+
+static int rmnet_stats_reset(struct net_device *dev)
+{
+	struct rmnet_priv *priv = netdev_priv(dev);
+	struct rmnet_port_priv_stats *stp;
+	struct rmnet_port *port;
+
+	port = rmnet_get_port(priv->real_dev);
+	if (!port)
+		return -EINVAL;
+
+	stp = &port->stats;
+
+	memset(stp, 0, sizeof(*stp));
+	return 0;
 }
 
 static const struct ethtool_ops rmnet_ethtool_ops = {
 	.get_ethtool_stats = rmnet_get_ethtool_stats,
 	.get_strings = rmnet_get_strings,
 	.get_sset_count = rmnet_get_sset_count,
+	.nway_reset = rmnet_stats_reset,
 };
 
 /* Called by kernel whenever a new rmnet<n> device is created. Sets MTU,
@@ -200,7 +278,7 @@ void rmnet_vnd_setup(struct net_device *rmnet_dev)
 	rmnet_dev->netdev_ops = &rmnet_vnd_ops;
 	rmnet_dev->mtu = RMNET_DFLT_PACKET_SIZE;
 	rmnet_dev->needed_headroom = RMNET_NEEDED_HEADROOM;
-	eth_random_addr(rmnet_dev->dev_addr);
+	random_ether_addr(rmnet_dev->dev_addr);
 	rmnet_dev->tx_queue_len = RMNET_TX_QUEUE_LEN;
 
 	/* Raw IP mode */
@@ -209,12 +287,7 @@ void rmnet_vnd_setup(struct net_device *rmnet_dev)
 	rmnet_dev->hard_header_len = 0;
 	rmnet_dev->flags &= ~(IFF_BROADCAST | IFF_MULTICAST);
 
-	rmnet_dev->needs_free_netdev = true;
 	rmnet_dev->ethtool_ops = &rmnet_ethtool_ops;
-
-	/* This perm addr will be used as interface identifier by IPv6 */
-	rmnet_dev->addr_assign_type = NET_ADDR_RANDOM;
-	eth_random_addr(rmnet_dev->perm_addr);
 }
 
 /* Exposed API */
@@ -236,6 +309,7 @@ int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 	rmnet_dev->hw_features = NETIF_F_RXCSUM;
 	rmnet_dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 	rmnet_dev->hw_features |= NETIF_F_SG;
+	rmnet_dev->hw_features |= NETIF_F_GRO_HW;
 
 	priv->real_dev = real_dev;
 
@@ -263,6 +337,7 @@ int rmnet_vnd_dellink(u8 id, struct rmnet_port *port,
 
 	ep->egress_dev = NULL;
 	port->nr_rmnet_devs--;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
index 54cbaf3c3bc4..5d78d3512ead 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h
@@ -1,7 +1,17 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright (c) 2013-2017, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2019, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
  * RMNET Data Virtual Network Device APIs
+ *
  */
 
 #ifndef _RMNET_VND_H_
@@ -14,8 +24,8 @@ int rmnet_vnd_newlink(u8 id, struct net_device *rmnet_dev,
 		      struct rmnet_endpoint *ep);
 int rmnet_vnd_dellink(u8 id, struct rmnet_port *port,
 		      struct rmnet_endpoint *ep);
-void rmnet_vnd_rx_fixup(struct sk_buff *skb, struct net_device *dev);
-void rmnet_vnd_tx_fixup(struct sk_buff *skb, struct net_device *dev);
+void rmnet_vnd_rx_fixup(struct net_device *dev, u32 skb_len);
+void rmnet_vnd_tx_fixup(struct net_device *dev, u32 skb_len);
 u8 rmnet_vnd_get_mux(struct net_device *rmnet_dev);
 void rmnet_vnd_setup(struct net_device *dev);
 #endif /* _RMNET_VND_H_ */
diff --git a/include/linux/ipc_logging.h b/include/linux/ipc_logging.h
new file mode 100644
index 000000000000..d2c41efa1347
--- /dev/null
+++ b/include/linux/ipc_logging.h
@@ -0,0 +1,291 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2012-2015, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef _IPC_LOGGING_H
+#define _IPC_LOGGING_H
+
+#include <linux/types.h>
+
+#define MAX_MSG_SIZE 255
+
+enum {
+	TSV_TYPE_MSG_START = 1,
+	TSV_TYPE_SKB = TSV_TYPE_MSG_START,
+	TSV_TYPE_STRING,
+	TSV_TYPE_MSG_END = TSV_TYPE_STRING,
+};
+
+struct tsv_header {
+	unsigned char type;
+	unsigned char size; /* size of data field */
+};
+
+struct encode_context {
+	struct tsv_header hdr;
+	char buff[MAX_MSG_SIZE];
+	int offset;
+};
+
+struct decode_context {
+	int output_format;      /* 0 = debugfs */
+	char *buff;             /* output buffer */
+	int size;               /* size of output buffer */
+};
+
+#if defined(CONFIG_IPC_LOGGING)
+/*
+ * ipc_log_context_create: Create a debug log context
+ *                         Should not be called from atomic context
+ *
+ * @max_num_pages: Number of pages of logging space required (max. 10)
+ * @mod_name     : Name of the directory entry under DEBUGFS
+ * @user_version : Version number of user-defined message formats
+ *
+ * returns context id on success, NULL on failure
+ */
+void *ipc_log_context_create(int max_num_pages, const char *modname,
+		uint16_t user_version);
+
+/*
+ * msg_encode_start: Start encoding a log message
+ *
+ * @ectxt: Temporary storage to hold the encoded message
+ * @type:  Root event type defined by the module which is logging
+ */
+void msg_encode_start(struct encode_context *ectxt, uint32_t type);
+
+/*
+ * tsv_timestamp_write: Writes the current timestamp count
+ *
+ * @ectxt: Context initialized by calling msg_encode_start()
+ */
+int tsv_timestamp_write(struct encode_context *ectxt);
+
+/*
+ * tsv_qtimer_write: Writes the current QTimer timestamp count
+ *
+ * @ectxt: Context initialized by calling msg_encode_start()
+ */
+int tsv_qtimer_write(struct encode_context *ectxt);
+
+/*
+ * tsv_pointer_write: Writes a data pointer
+ *
+ * @ectxt:   Context initialized by calling msg_encode_start()
+ * @pointer: Pointer value to write
+ */
+int tsv_pointer_write(struct encode_context *ectxt, void *pointer);
+
+/*
+ * tsv_int32_write: Writes a 32-bit integer value
+ *
+ * @ectxt: Context initialized by calling msg_encode_start()
+ * @n:     Integer to write
+ */
+int tsv_int32_write(struct encode_context *ectxt, int32_t n);
+
+/*
+ * tsv_int32_write: Writes a 32-bit integer value
+ *
+ * @ectxt: Context initialized by calling msg_encode_start()
+ * @n:     Integer to write
+ */
+int tsv_byte_array_write(struct encode_context *ectxt,
+			 void *data, int data_size);
+
+/*
+ * msg_encode_end: Complete the message encode process
+ *
+ * @ectxt: Temporary storage which holds the encoded message
+ */
+void msg_encode_end(struct encode_context *ectxt);
+
+/*
+ * msg_encode_end: Complete the message encode process
+ *
+ * @ectxt: Temporary storage which holds the encoded message
+ */
+void ipc_log_write(void *ctxt, struct encode_context *ectxt);
+
+/*
+ * ipc_log_string: Helper function to log a string
+ *
+ * @ilctxt: Debug Log Context created using ipc_log_context_create()
+ * @fmt:    Data specified using format specifiers
+ */
+int ipc_log_string(void *ilctxt, const char *fmt, ...) __printf(2, 3);
+
+/**
+ * ipc_log_extract - Reads and deserializes log
+ *
+ * @ilctxt:  logging context
+ * @buff:    buffer to receive the data
+ * @size:    size of the buffer
+ * @returns: 0 if no data read; >0 number of bytes read; < 0 error
+ *
+ * If no data is available to be read, then the ilctxt::read_avail
+ * completion is reinitialized.  This allows clients to block
+ * until new log data is save.
+ */
+int ipc_log_extract(void *ilctxt, char *buff, int size);
+
+/*
+ * Print a string to decode context.
+ * @dctxt   Decode context
+ * @args   printf args
+ */
+#define IPC_SPRINTF_DECODE(dctxt, args...) \
+do { \
+	int i; \
+	i = scnprintf(dctxt->buff, dctxt->size, args); \
+	dctxt->buff += i; \
+	dctxt->size -= i; \
+} while (0)
+
+/*
+ * tsv_timestamp_read: Reads a timestamp
+ *
+ * @ectxt:  Context retrieved by reading from log space
+ * @dctxt:  Temporary storage to hold the decoded message
+ * @format: Output format while dumping through DEBUGFS
+ */
+void tsv_timestamp_read(struct encode_context *ectxt,
+			struct decode_context *dctxt, const char *format);
+
+/*
+ * tsv_qtimer_read: Reads a QTimer timestamp
+ *
+ * @ectxt:  Context retrieved by reading from log space
+ * @dctxt:  Temporary storage to hold the decoded message
+ * @format: Output format while dumping through DEBUGFS
+ */
+void tsv_qtimer_read(struct encode_context *ectxt,
+		     struct decode_context *dctxt, const char *format);
+
+/*
+ * tsv_pointer_read: Reads a data pointer
+ *
+ * @ectxt:  Context retrieved by reading from log space
+ * @dctxt:  Temporary storage to hold the decoded message
+ * @format: Output format while dumping through DEBUGFS
+ */
+void tsv_pointer_read(struct encode_context *ectxt,
+		      struct decode_context *dctxt, const char *format);
+
+/*
+ * tsv_int32_read: Reads a 32-bit integer value
+ *
+ * @ectxt:  Context retrieved by reading from log space
+ * @dctxt:  Temporary storage to hold the decoded message
+ * @format: Output format while dumping through DEBUGFS
+ */
+int32_t tsv_int32_read(struct encode_context *ectxt,
+		       struct decode_context *dctxt, const char *format);
+
+/*
+ * tsv_int32_read: Reads a 32-bit integer value
+ *
+ * @ectxt:  Context retrieved by reading from log space
+ * @dctxt:  Temporary storage to hold the decoded message
+ * @format: Output format while dumping through DEBUGFS
+ */
+void tsv_byte_array_read(struct encode_context *ectxt,
+			 struct decode_context *dctxt, const char *format);
+
+/*
+ * add_deserialization_func: Register a deserialization function to
+ *                           unpack the subevents of a main event
+ *
+ * @ctxt: Debug log context to which the deserialization function has
+ *        to be registered
+ * @type: Main/Root event, defined by the module which is logging, to
+ *        which this deserialization function has to be registered.
+ * @dfune: Deserialization function to be registered
+ *
+ * return 0 on success, -ve value on FAILURE
+ */
+int add_deserialization_func(void *ctxt, int type,
+			void (*dfunc)(struct encode_context *,
+				      struct decode_context *));
+
+/*
+ * ipc_log_context_destroy: Destroy debug log context
+ *
+ * @ctxt: debug log context created by calling ipc_log_context_create API.
+ */
+int ipc_log_context_destroy(void *ctxt);
+
+#else
+
+static inline void *ipc_log_context_create(int max_num_pages,
+	const char *modname, uint16_t user_version)
+{ return NULL; }
+
+static inline void msg_encode_start(struct encode_context *ectxt,
+	uint32_t type) { }
+
+static inline int tsv_timestamp_write(struct encode_context *ectxt)
+{ return -EINVAL; }
+
+static inline int tsv_qtimer_write(struct encode_context *ectxt)
+{ return -EINVAL; }
+
+static inline int tsv_pointer_write(struct encode_context *ectxt, void *pointer)
+{ return -EINVAL; }
+
+static inline int tsv_int32_write(struct encode_context *ectxt, int32_t n)
+{ return -EINVAL; }
+
+static inline int tsv_byte_array_write(struct encode_context *ectxt,
+			 void *data, int data_size)
+{ return -EINVAL; }
+
+static inline void msg_encode_end(struct encode_context *ectxt) { }
+
+static inline void ipc_log_write(void *ctxt, struct encode_context *ectxt) { }
+
+static inline int ipc_log_string(void *ilctxt, const char *fmt, ...)
+{ return -EINVAL; }
+
+static inline int ipc_log_extract(void *ilctxt, char *buff, int size)
+{ return -EINVAL; }
+
+#define IPC_SPRINTF_DECODE(dctxt, args...) do { } while (0)
+
+static inline void tsv_timestamp_read(struct encode_context *ectxt,
+			struct decode_context *dctxt, const char *format) { }
+
+static inline void tsv_qtimer_read(struct encode_context *ectxt,
+			struct decode_context *dctxt, const char *format) { }
+
+static inline void tsv_pointer_read(struct encode_context *ectxt,
+		      struct decode_context *dctxt, const char *format) { }
+
+static inline int32_t tsv_int32_read(struct encode_context *ectxt,
+		       struct decode_context *dctxt, const char *format)
+{ return 0; }
+
+static inline void tsv_byte_array_read(struct encode_context *ectxt,
+			 struct decode_context *dctxt, const char *format) { }
+
+static inline int add_deserialization_func(void *ctxt, int type,
+			void (*dfunc)(struct encode_context *,
+				      struct decode_context *))
+{ return 0; }
+
+static inline int ipc_log_context_destroy(void *ctxt)
+{ return 0; }
+
+#endif
+
+#endif
diff --git a/include/linux/mhi.h b/include/linux/mhi.h
new file mode 100644
index 000000000000..36373b2d56f4
--- /dev/null
+++ b/include/linux/mhi.h
@@ -0,0 +1,743 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2018-2019, The Linux Foundation. All rights reserved. */
+
+
+#ifndef _MHI_H_
+#define _MHI_H_
+
+#include <linux/dma-direction.h>
+
+struct mhi_chan;
+struct mhi_event;
+struct mhi_ctxt;
+struct mhi_cmd;
+struct image_info;
+struct bhi_vec_entry;
+struct mhi_timesync;
+struct mhi_buf_info;
+
+/**
+ * enum MHI_CB - MHI callback
+ * @MHI_CB_IDLE: MHI entered idle state
+ * @MHI_CB_PENDING_DATA: New data available for client to process
+ * @MHI_CB_LPM_ENTER: MHI host entered low power mode
+ * @MHI_CB_LPM_EXIT: MHI host about to exit low power mode
+ * @MHI_CB_EE_RDDM: MHI device entered RDDM execution enviornment
+ * @MHI_CB_SYS_ERROR: MHI device enter error state (may recover)
+ * @MHI_CB_FATAL_ERROR: MHI device entered fatal error
+ */
+enum MHI_CB {
+	MHI_CB_IDLE,
+	MHI_CB_PENDING_DATA,
+	MHI_CB_LPM_ENTER,
+	MHI_CB_LPM_EXIT,
+	MHI_CB_EE_RDDM,
+	MHI_CB_SYS_ERROR,
+	MHI_CB_FATAL_ERROR,
+};
+
+/**
+ * enum MHI_DEBUG_LEVL - various debugging level
+ */
+enum MHI_DEBUG_LEVEL {
+	MHI_MSG_LVL_VERBOSE,
+	MHI_MSG_LVL_INFO,
+	MHI_MSG_LVL_ERROR,
+	MHI_MSG_LVL_CRITICAL,
+	MHI_MSG_LVL_MASK_ALL,
+};
+
+/**
+ * enum MHI_FLAGS - Transfer flags
+ * @MHI_EOB: End of buffer for bulk transfer
+ * @MHI_EOT: End of transfer
+ * @MHI_CHAIN: Linked transfer
+ */
+enum MHI_FLAGS {
+	MHI_EOB,
+	MHI_EOT,
+	MHI_CHAIN,
+};
+
+/**
+ * enum mhi_device_type - Device types
+ * @MHI_XFER_TYPE: Handles data transfer
+ * @MHI_TIMESYNC_TYPE: Use for timesync feature
+ * @MHI_CONTROLLER_TYPE: Control device
+ */
+enum mhi_device_type {
+	MHI_XFER_TYPE,
+	MHI_TIMESYNC_TYPE,
+	MHI_CONTROLLER_TYPE,
+};
+
+/**
+ * enum mhi_ee - device current execution enviornment
+ * @MHI_EE_PBL - device in PBL
+ * @MHI_EE_SBL - device in SBL
+ * @MHI_EE_AMSS - device in mission mode (firmware fully loaded)
+ * @MHI_EE_RDDM - device in ram dump collection mode
+ * @MHI_EE_WFW - device in WLAN firmware mode
+ * @MHI_EE_PTHRU - device in PBL but configured in pass thru mode
+ * @MHI_EE_EDL - device in emergency download mode
+ */
+enum mhi_ee {
+	MHI_EE_PBL = 0x0,
+	MHI_EE_SBL = 0x1,
+	MHI_EE_AMSS = 0x2,
+	MHI_EE_RDDM = 0x3,
+	MHI_EE_WFW = 0x4,
+	MHI_EE_PTHRU = 0x5,
+	MHI_EE_EDL = 0x6,
+	MHI_EE_MAX_SUPPORTED = MHI_EE_EDL,
+	MHI_EE_DISABLE_TRANSITION, /* local EE, not related to mhi spec */
+	MHI_EE_MAX,
+};
+
+/**
+ * enum mhi_dev_state - device current MHI state
+ */
+enum mhi_dev_state {
+	MHI_STATE_RESET = 0x0,
+	MHI_STATE_READY = 0x1,
+	MHI_STATE_M0 = 0x2,
+	MHI_STATE_M1 = 0x3,
+	MHI_STATE_M2 = 0x4,
+	MHI_STATE_M3 = 0x5,
+	MHI_STATE_BHI  = 0x7,
+	MHI_STATE_SYS_ERR  = 0xFF,
+	MHI_STATE_MAX,
+};
+
+extern const char * const mhi_ee_str[MHI_EE_MAX];
+#define TO_MHI_EXEC_STR(ee) (((ee) >= MHI_EE_MAX) ? \
+			     "INVALID_EE" : mhi_ee_str[ee])
+
+/**
+ * struct image_info - firmware and rddm table
+ * @mhi_buf - Contain device firmware and rddm table
+ * @entries - # of entries in table
+ */
+struct image_info {
+	struct mhi_buf *mhi_buf;
+	struct bhi_vec_entry *bhi_vec;
+	u32 entries;
+};
+
+/**
+ * struct mhi_controller - Master controller structure for external modem
+ * @dev: Device associated with this controller
+ * @of_node: DT that has MHI configuration information
+ * @regs: Points to base of MHI MMIO register space
+ * @bhi: Points to base of MHI BHI register space
+ * @bhie: Points to base of MHI BHIe register space
+ * @wake_db: MHI WAKE doorbell register address
+ * @dev_id: PCIe device id of the external device
+ * @domain: PCIe domain the device connected to
+ * @bus: PCIe bus the device assigned to
+ * @slot: PCIe slot for the modem
+ * @iova_start: IOMMU starting address for data
+ * @iova_stop: IOMMU stop address for data
+ * @fw_image: Firmware image name for normal booting
+ * @edl_image: Firmware image name for emergency download mode
+ * @fbc_download: MHI host needs to do complete image transfer
+ * @rddm_size: RAM dump size that host should allocate for debugging purpose
+ * @sbl_size: SBL image size
+ * @seg_len: BHIe vector size
+ * @fbc_image: Points to firmware image buffer
+ * @rddm_image: Points to RAM dump buffer
+ * @max_chan: Maximum number of channels controller support
+ * @mhi_chan: Points to channel configuration table
+ * @lpm_chans: List of channels that require LPM notifications
+ * @total_ev_rings: Total # of event rings allocated
+ * @hw_ev_rings: Number of hardware event rings
+ * @sw_ev_rings: Number of software event rings
+ * @msi_required: Number of msi required to operate
+ * @msi_allocated: Number of msi allocated by bus master
+ * @irq: base irq # to request
+ * @mhi_event: MHI event ring configurations table
+ * @mhi_cmd: MHI command ring configurations table
+ * @mhi_ctxt: MHI device context, shared memory between host and device
+ * @timeout_ms: Timeout in ms for state transitions
+ * @pm_state: Power management state
+ * @ee: MHI device execution environment
+ * @dev_state: MHI STATE
+ * @status_cb: CB function to notify various power states to but master
+ * @link_status: Query link status in case of abnormal value read from device
+ * @runtime_get: Async runtime resume function
+ * @runtimet_put: Release votes
+ * @time_get: Return host time in us
+ * @lpm_disable: Request controller to disable link level low power modes
+ * @lpm_enable: Controller may enable link level low power modes again
+ * @priv_data: Points to bus master's private data
+ */
+struct mhi_controller {
+	struct list_head node;
+	struct mhi_device *mhi_dev;
+
+	/* device node for iommu ops */
+	struct device *dev;
+	struct device_node *of_node;
+
+	/* mmio base */
+	phys_addr_t base_addr;
+	void __iomem *regs;
+	void __iomem *bhi;
+	void __iomem *bhie;
+	void __iomem *wake_db;
+
+	/* device topology */
+	u32 dev_id;
+	u32 domain;
+	u32 bus;
+	u32 slot;
+
+	/* addressing window */
+	dma_addr_t iova_start;
+	dma_addr_t iova_stop;
+
+	/* fw images */
+	const char *fw_image;
+	const char *edl_image;
+
+	/* mhi host manages downloading entire fbc images */
+	bool fbc_download;
+	size_t rddm_size;
+	size_t sbl_size;
+	size_t seg_len;
+	u32 session_id;
+	u32 sequence_id;
+	struct image_info *fbc_image;
+	struct image_info *rddm_image;
+
+	/* physical channel config data */
+	u32 max_chan;
+	struct mhi_chan *mhi_chan;
+	struct list_head lpm_chans; /* these chan require lpm notification */
+
+	/* physical event config data */
+	u32 total_ev_rings;
+	u32 hw_ev_rings;
+	u32 sw_ev_rings;
+	u32 msi_required;
+	u32 msi_allocated;
+	int *irq; /* interrupt table */
+	struct mhi_event *mhi_event;
+
+	/* cmd rings */
+	struct mhi_cmd *mhi_cmd;
+
+	/* mhi context (shared with device) */
+	struct mhi_ctxt *mhi_ctxt;
+
+	u32 timeout_ms;
+
+	/* caller should grab pm_mutex for suspend/resume operations */
+	struct mutex pm_mutex;
+	bool pre_init;
+	rwlock_t pm_lock;
+	u32 pm_state;
+	enum mhi_ee ee;
+	enum mhi_dev_state dev_state;
+	bool wake_set;
+	atomic_t dev_wake;
+	atomic_t alloc_size;
+	struct list_head transition_list;
+	spinlock_t transition_lock;
+	spinlock_t wlock;
+
+	/* debug counters */
+	u32 M0, M2, M3;
+
+	/* worker for different state transitions */
+	struct work_struct st_worker;
+	struct work_struct fw_worker;
+	struct work_struct syserr_worker;
+	wait_queue_head_t state_event;
+
+	/* shadow functions */
+	void (*status_cb)(struct mhi_controller *mhi_cntrl, void *priv,
+			  enum MHI_CB reason);
+	int (*link_status)(struct mhi_controller *mhi_cntrl, void *priv);
+	void (*wake_get)(struct mhi_controller *mhi_cntrl, bool override);
+	void (*wake_put)(struct mhi_controller *mhi_cntrl, bool override);
+	int (*runtime_get)(struct mhi_controller *mhi_cntrl, void *priv);
+	void (*runtime_put)(struct mhi_controller *mhi_cntrl, void *priv);
+	u64 (*time_get)(struct mhi_controller *mhi_cntrl, void *priv);
+	int (*lpm_disable)(struct mhi_controller *mhi_cntrl, void *priv);
+	int (*lpm_enable)(struct mhi_controller *mhi_cntrl, void *priv);
+	int (*map_single)(struct mhi_controller *mhi_cntrl,
+			  struct mhi_buf_info *buf);
+	void (*unmap_single)(struct mhi_controller *mhi_cntrl,
+			     struct mhi_buf_info *buf);
+
+	/* channel to control DTR messaging */
+	struct mhi_device *dtr_dev;
+
+	/* bounce buffer settings */
+	bool bounce_buf;
+	size_t buffer_len;
+
+	/* supports time sync feature */
+	struct mhi_timesync *mhi_tsync;
+	struct mhi_device *tsync_dev;
+
+	/* kernel log level */
+	enum MHI_DEBUG_LEVEL klog_lvl;
+
+	/* private log level controller driver to set */
+	enum MHI_DEBUG_LEVEL log_lvl;
+
+	/* controller specific data */
+	void *priv_data;
+	void *log_buf;
+	struct dentry *dentry;
+	struct dentry *parent;
+	struct notifier_block mhi_panic_notifier;
+};
+
+/**
+ * struct mhi_device - mhi device structure associated bind to channel
+ * @dev: Device associated with the channels
+ * @mtu: Maximum # of bytes controller support
+ * @ul_chan_id: MHI channel id for UL transfer
+ * @dl_chan_id: MHI channel id for DL transfer
+ * @tiocm: Device current terminal settings
+ * @priv: Driver private data
+ */
+struct mhi_device {
+	struct device dev;
+	u32 dev_id;
+	u32 domain;
+	u32 bus;
+	u32 slot;
+	size_t mtu;
+	int ul_chan_id;
+	int dl_chan_id;
+	int ul_event_id;
+	int dl_event_id;
+	u32 tiocm;
+	const struct mhi_device_id *id;
+	const char *chan_name;
+	struct mhi_controller *mhi_cntrl;
+	struct mhi_chan *ul_chan;
+	struct mhi_chan *dl_chan;
+	atomic_t dev_wake;
+	enum mhi_device_type dev_type;
+	void *priv_data;
+	int (*ul_xfer)(struct mhi_device *mhi_dev, struct mhi_chan *mhi_chan,
+		       void *buf, size_t len, enum MHI_FLAGS flags);
+	int (*dl_xfer)(struct mhi_device *mhi_dev, struct mhi_chan *mhi_chan,
+		       void *buf, size_t size, enum MHI_FLAGS flags);
+	void (*status_cb)(struct mhi_device *mhi_dev, enum MHI_CB reason);
+};
+
+/**
+ * struct mhi_result - Completed buffer information
+ * @buf_addr: Address of data buffer
+ * @dir: Channel direction
+ * @bytes_xfer: # of bytes transferred
+ * @transaction_status: Status of last trasnferred
+ */
+struct mhi_result {
+	void *buf_addr;
+	enum dma_data_direction dir;
+	size_t bytes_xferd;
+	int transaction_status;
+};
+
+/**
+ * struct mhi_buf - Describes the buffer
+ * @page: buffer as a page
+ * @buf: cpu address for the buffer
+ * @phys_addr: physical address of the buffer
+ * @dma_addr: iommu address for the buffer
+ * @skb: skb of ip packet
+ * @len: # of bytes
+ * @name: Buffer label, for offload channel configurations name must be:
+ * ECA - Event context array data
+ * CCA - Channel context array data
+ */
+struct mhi_buf {
+	struct list_head node;
+	struct page *page;
+	void *buf;
+	phys_addr_t phys_addr;
+	dma_addr_t dma_addr;
+	struct sk_buff *skb;
+	size_t len;
+	const char *name; /* ECA, CCA */
+};
+
+/**
+ * struct mhi_driver - mhi driver information
+ * @id_table: NULL terminated channel ID names
+ * @ul_xfer_cb: UL data transfer callback
+ * @dl_xfer_cb: DL data transfer callback
+ * @status_cb: Asynchronous status callback
+ */
+struct mhi_driver {
+	const struct mhi_device_id *id_table;
+	int (*probe)(struct mhi_device *mhi_dev,
+		     const struct mhi_device_id *id);
+	void (*remove)(struct mhi_device *mhi_dev);
+	void (*ul_xfer_cb)(struct mhi_device *mhi_dev, struct mhi_result *res);
+	void (*dl_xfer_cb)(struct mhi_device *mhi_dev, struct mhi_result *res);
+	void (*status_cb)(struct mhi_device *mhi_dev, enum MHI_CB mhi_cb);
+	struct device_driver driver;
+};
+
+#define to_mhi_driver(drv) container_of(drv, struct mhi_driver, driver)
+#define to_mhi_device(dev) container_of(dev, struct mhi_device, dev)
+
+static inline void mhi_device_set_devdata(struct mhi_device *mhi_dev,
+					  void *priv)
+{
+	mhi_dev->priv_data = priv;
+}
+
+static inline void *mhi_device_get_devdata(struct mhi_device *mhi_dev)
+{
+	return mhi_dev->priv_data;
+}
+
+/**
+ * mhi_queue_transfer - Queue a buffer to hardware
+ * All transfers are asyncronous transfers
+ * @mhi_dev: Device associated with the channels
+ * @dir: Data direction
+ * @buf: Data buffer (skb for hardware channels)
+ * @len: Size in bytes
+ * @mflags: Interrupt flags for the device
+ */
+static inline int mhi_queue_transfer(struct mhi_device *mhi_dev,
+				     enum dma_data_direction dir,
+				     void *buf,
+				     size_t len,
+				     enum MHI_FLAGS mflags)
+{
+	if (dir == DMA_TO_DEVICE)
+		return mhi_dev->ul_xfer(mhi_dev, mhi_dev->ul_chan, buf, len,
+					mflags);
+	else
+		return mhi_dev->dl_xfer(mhi_dev, mhi_dev->dl_chan, buf, len,
+					mflags);
+}
+
+static inline void *mhi_controller_get_devdata(struct mhi_controller *mhi_cntrl)
+{
+	return mhi_cntrl->priv_data;
+}
+
+static inline void mhi_free_controller(struct mhi_controller *mhi_cntrl)
+{
+	kfree(mhi_cntrl);
+}
+
+/**
+ * mhi_driver_register - Register driver with MHI framework
+ * @mhi_drv: mhi_driver structure
+ */
+int mhi_driver_register(struct mhi_driver *mhi_drv);
+
+/**
+ * mhi_driver_unregister - Unregister a driver for mhi_devices
+ * @mhi_drv: mhi_driver structure
+ */
+void mhi_driver_unregister(struct mhi_driver *mhi_drv);
+
+/**
+ * mhi_device_configure - configure ECA or CCA context
+ * For offload channels that client manage, call this
+ * function to configure channel context or event context
+ * array associated with the channel
+ * @mhi_div: Device associated with the channels
+ * @dir: Direction of the channel
+ * @mhi_buf: Configuration data
+ * @elements: # of configuration elements
+ */
+int mhi_device_configure(struct mhi_device *mhi_div,
+			 enum dma_data_direction dir,
+			 struct mhi_buf *mhi_buf,
+			 int elements);
+
+/**
+ * mhi_device_get - disable all low power modes
+ * Only disables lpm, does not immediately exit low power mode
+ * if controller already in a low power mode
+ * @mhi_dev: Device associated with the channels
+ */
+void mhi_device_get(struct mhi_device *mhi_dev);
+
+/**
+ * mhi_device_get_sync - disable all low power modes
+ * Synchronously disable all low power, exit low power mode if
+ * controller already in a low power state
+ * @mhi_dev: Device associated with the channels
+ */
+int mhi_device_get_sync(struct mhi_device *mhi_dev);
+
+/**
+ * mhi_device_put - re-enable low power modes
+ * @mhi_dev: Device associated with the channels
+ */
+void mhi_device_put(struct mhi_device *mhi_dev);
+
+/**
+ * mhi_prepare_for_transfer - setup channel for data transfer
+ * Moves both UL and DL channel from RESET to START state
+ * @mhi_dev: Device associated with the channels
+ */
+int mhi_prepare_for_transfer(struct mhi_device *mhi_dev);
+
+/**
+ * mhi_unprepare_from_transfer -unprepare the channels
+ * Moves both UL and DL channels to RESET state
+ * @mhi_dev: Device associated with the channels
+ */
+void mhi_unprepare_from_transfer(struct mhi_device *mhi_dev);
+
+/**
+ * mhi_get_no_free_descriptors - Get transfer ring length
+ * Get # of TD available to queue buffers
+ * @mhi_dev: Device associated with the channels
+ * @dir: Direction of the channel
+ */
+int mhi_get_no_free_descriptors(struct mhi_device *mhi_dev,
+				enum dma_data_direction dir);
+
+/**
+ * mhi_poll - poll for any available data to consume
+ * This is only applicable for DL direction
+ * @mhi_dev: Device associated with the channels
+ * @budget: In descriptors to service before returning
+ */
+int mhi_poll(struct mhi_device *mhi_dev, u32 budget);
+
+/**
+ * mhi_ioctl - user space IOCTL support for MHI channels
+ * Native support for setting  TIOCM
+ * @mhi_dev: Device associated with the channels
+ * @cmd: IOCTL cmd
+ * @arg: Optional parameter, iotcl cmd specific
+ */
+long mhi_ioctl(struct mhi_device *mhi_dev, unsigned int cmd, unsigned long arg);
+
+/**
+ * mhi_alloc_controller - Allocate mhi_controller structure
+ * Allocate controller structure and additional data for controller
+ * private data. You may get the private data pointer by calling
+ * mhi_controller_get_devdata
+ * @size: # of additional bytes to allocate
+ */
+struct mhi_controller *mhi_alloc_controller(size_t size);
+
+/**
+ * of_register_mhi_controller - Register MHI controller
+ * Registers MHI controller with MHI bus framework. DT must be supported
+ * @mhi_cntrl: MHI controller to register
+ */
+int of_register_mhi_controller(struct mhi_controller *mhi_cntrl);
+
+void mhi_unregister_mhi_controller(struct mhi_controller *mhi_cntrl);
+
+/**
+ * mhi_bdf_to_controller - Look up a registered controller
+ * Search for controller based on device identification
+ * @domain: RC domain of the device
+ * @bus: Bus device connected to
+ * @slot: Slot device assigned to
+ * @dev_id: Device Identification
+ */
+struct mhi_controller *mhi_bdf_to_controller(u32 domain, u32 bus, u32 slot,
+					     u32 dev_id);
+
+/**
+ * mhi_prepare_for_power_up - Do pre-initialization before power up
+ * This is optional, call this before power up if controller do not
+ * want bus framework to automatically free any allocated memory during shutdown
+ * process.
+ * @mhi_cntrl: MHI controller
+ */
+int mhi_prepare_for_power_up(struct mhi_controller *mhi_cntrl);
+
+/**
+ * mhi_async_power_up - Starts MHI power up sequence
+ * @mhi_cntrl: MHI controller
+ */
+int mhi_async_power_up(struct mhi_controller *mhi_cntrl);
+int mhi_sync_power_up(struct mhi_controller *mhi_cntrl);
+
+/**
+ * mhi_power_down - Start MHI power down sequence
+ * @mhi_cntrl: MHI controller
+ * @graceful: link is still accessible, do a graceful shutdown process otherwise
+ * we will shutdown host w/o putting device into RESET state
+ */
+void mhi_power_down(struct mhi_controller *mhi_cntrl, bool graceful);
+
+/**
+ * mhi_unprepare_after_powre_down - free any allocated memory for power up
+ * @mhi_cntrl: MHI controller
+ */
+void mhi_unprepare_after_power_down(struct mhi_controller *mhi_cntrl);
+
+/**
+ * mhi_pm_suspend - Move MHI into a suspended state
+ * Transition to MHI state M3 state from M0||M1||M2 state
+ * @mhi_cntrl: MHI controller
+ */
+int mhi_pm_suspend(struct mhi_controller *mhi_cntrl);
+
+/**
+ * mhi_pm_resume - Resume MHI from suspended state
+ * Transition to MHI state M0 state from M3 state
+ * @mhi_cntrl: MHI controller
+ */
+int mhi_pm_resume(struct mhi_controller *mhi_cntrl);
+
+/**
+ * mhi_download_rddm_img - Download ramdump image from device for
+ * debugging purpose.
+ * @mhi_cntrl: MHI controller
+ * @in_panic: If we trying to capture image while in kernel panic
+ */
+int mhi_download_rddm_img(struct mhi_controller *mhi_cntrl, bool in_panic);
+
+/**
+ * mhi_force_rddm_mode - Force external device into rddm mode
+ * to collect device ramdump. This is useful if host driver assert
+ * and we need to see device state as well.
+ * @mhi_cntrl: MHI controller
+ */
+int mhi_force_rddm_mode(struct mhi_controller *mhi_cntrl);
+
+/**
+ * mhi_get_remote_time_sync - Get external soc time relative to local soc time
+ * using MMIO method.
+ * @mhi_dev: Device associated with the channels
+ * @t_host: Pointer to output local soc time
+ * @t_dev: Pointer to output remote soc time
+ */
+int mhi_get_remote_time_sync(struct mhi_device *mhi_dev,
+			     u64 *t_host,
+			     u64 *t_dev);
+
+/**
+ * mhi_get_mhi_state - Return MHI state of device
+ * @mhi_cntrl: MHI controller
+ */
+enum mhi_dev_state mhi_get_mhi_state(struct mhi_controller *mhi_cntrl);
+
+/**
+ * mhi_set_mhi_state - Set device state
+ * @mhi_cntrl: MHI controller
+ * @state: state to set
+ */
+void mhi_set_mhi_state(struct mhi_controller *mhi_cntrl,
+		       enum mhi_dev_state state);
+
+
+/**
+ * mhi_is_active - helper function to determine if MHI in active state
+ * @mhi_dev: client device
+ */
+static inline bool mhi_is_active(struct mhi_device *mhi_dev)
+{
+	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
+
+	return (mhi_cntrl->dev_state >= MHI_STATE_M0 &&
+		mhi_cntrl->dev_state <= MHI_STATE_M3);
+}
+
+/**
+ * mhi_debug_reg_dump - dump MHI registers for debug purpose
+ * @mhi_cntrl: MHI controller
+ */
+void mhi_debug_reg_dump(struct mhi_controller *mhi_cntrl);
+
+void mhi_wdt_panic_handler(void);
+
+int get_mhi_pci_status(void);
+
+#ifndef CONFIG_ARCH_QCOM
+
+#ifdef CONFIG_MHI_DEBUG
+
+#define MHI_VERB(fmt, ...) do { \
+		if (mhi_cntrl->klog_lvl <= MHI_MSG_LVL_VERBOSE) \
+			pr_debug("[D][%s] " fmt, __func__, ##__VA_ARGS__);\
+} while (0)
+
+#else
+
+#define MHI_VERB(fmt, ...)
+
+#endif
+
+#define MHI_LOG(fmt, ...) do {	\
+		if (mhi_cntrl->klog_lvl <= MHI_MSG_LVL_INFO) \
+			pr_info("[I][%s] " fmt, __func__, ##__VA_ARGS__);\
+} while (0)
+
+#define MHI_ERR(fmt, ...) do {	\
+		if (mhi_cntrl->klog_lvl <= MHI_MSG_LVL_ERROR) \
+			pr_err("[E][%s] " fmt, __func__, ##__VA_ARGS__); \
+} while (0)
+
+#define MHI_CRITICAL(fmt, ...) do { \
+		if (mhi_cntrl->klog_lvl <= MHI_MSG_LVL_CRITICAL) \
+			pr_alert("[C][%s] " fmt, __func__, ##__VA_ARGS__); \
+} while (0)
+
+#else /* ARCH QCOM */
+
+#include <linux/ipc_logging.h>
+
+#ifdef CONFIG_MHI_DEBUG
+
+#define MHI_VERB(fmt, ...) do { \
+		if (mhi_cntrl->klog_lvl <= MHI_MSG_LVL_VERBOSE) \
+			pr_err("[D][%s] " fmt, __func__, ##__VA_ARGS__);\
+		if (mhi_cntrl->log_buf && \
+		    (mhi_cntrl->log_lvl <= MHI_MSG_LVL_VERBOSE)) \
+			ipc_log_string(mhi_cntrl->log_buf, "[D][%s] " fmt, \
+				       __func__, ##__VA_ARGS__); \
+} while (0)
+
+#else
+
+#define MHI_VERB(fmt, ...)
+
+#endif
+
+#define MHI_LOG(fmt, ...) do {	\
+		if (mhi_cntrl->klog_lvl <= MHI_MSG_LVL_INFO) \
+			pr_err("[I][%s] " fmt, __func__, ##__VA_ARGS__);\
+		if (mhi_cntrl->log_buf && \
+		    (mhi_cntrl->log_lvl <= MHI_MSG_LVL_INFO)) \
+			ipc_log_string(mhi_cntrl->log_buf, "[I][%s] " fmt, \
+				       __func__, ##__VA_ARGS__); \
+} while (0)
+
+#define MHI_ERR(fmt, ...) do {	\
+		if (mhi_cntrl->klog_lvl <= MHI_MSG_LVL_ERROR) \
+			pr_err("[E][%s] " fmt, __func__, ##__VA_ARGS__); \
+		if (mhi_cntrl->log_buf && \
+		    (mhi_cntrl->log_lvl <= MHI_MSG_LVL_ERROR)) \
+			ipc_log_string(mhi_cntrl->log_buf, "[E][%s] " fmt, \
+				       __func__, ##__VA_ARGS__); \
+} while (0)
+
+#define MHI_CRITICAL(fmt, ...) do { \
+		if (mhi_cntrl->klog_lvl <= MHI_MSG_LVL_CRITICAL) \
+			pr_err("[C][%s] " fmt, __func__, ##__VA_ARGS__); \
+		if (mhi_cntrl->log_buf && \
+		    (mhi_cntrl->log_lvl <= MHI_MSG_LVL_CRITICAL)) \
+			ipc_log_string(mhi_cntrl->log_buf, "[C][%s] " fmt, \
+				       __func__, ##__VA_ARGS__); \
+} while (0)
+
+#endif
+
+#endif /* _MHI_H_ */
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 5714fd35a83c..eda8e11fabf6 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -587,9 +587,9 @@ struct platform_device_id {
 #define MDIO_NAME_SIZE		32
 #define MDIO_MODULE_PREFIX	"mdio:"
 
-#define MDIO_ID_FMT "%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d"
+#define MDIO_ID_FMT "%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u%u"
 #define MDIO_ID_ARGS(_id) \
-	(_id)>>31, ((_id)>>30) & 1, ((_id)>>29) & 1, ((_id)>>28) & 1,	\
+	((_id)>>31) & 1, ((_id)>>30) & 1, ((_id)>>29) & 1, ((_id)>>28) & 1, \
 	((_id)>>27) & 1, ((_id)>>26) & 1, ((_id)>>25) & 1, ((_id)>>24) & 1, \
 	((_id)>>23) & 1, ((_id)>>22) & 1, ((_id)>>21) & 1, ((_id)>>20) & 1, \
 	((_id)>>19) & 1, ((_id)>>18) & 1, ((_id)>>17) & 1, ((_id)>>16) & 1, \
@@ -657,6 +657,10 @@ struct mips_cdmm_device_id {
 /*
  * MODULE_DEVICE_TABLE expects this struct to be called x86cpu_device_id.
  * Although gcc seems to ignore this error, clang fails without this define.
+ *
+ * Note: The ordering of the struct is different from upstream because the
+ * static initializers in kernels < 5.7 still use C89 style while upstream
+ * has been converted to proper C99 initializers.
  */
 #define x86cpu_device_id x86_cpu_id
 struct x86_cpu_id {
@@ -665,6 +669,7 @@ struct x86_cpu_id {
 	__u16 model;
 	__u16 feature;	/* bit index */
 	kernel_ulong_t driver_data;
+	__u16 steppings;
 };
 
 #define X86_FEATURE_MATCH(x) \
@@ -673,6 +678,7 @@ struct x86_cpu_id {
 #define X86_VENDOR_ANY 0xffff
 #define X86_FAMILY_ANY 0
 #define X86_MODEL_ANY  0
+#define X86_STEPPING_ANY 0
 #define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
 
 /*
@@ -821,4 +827,16 @@ struct wmi_device_id {
 	const void *context;
 };
 
+#define MHI_NAME_SIZE 32
+
+/**
+ * struct mhi_device_id - MHI device identification
+ * @chan: MHI channel name
+ * @driver_data: driver data;
+ */
+
+struct mhi_device_id {
+	const char chan[MHI_NAME_SIZE];
+	kernel_ulong_t driver_data;
+};
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/include/linux/msm-bus.h b/include/linux/msm-bus.h
new file mode 100644
index 000000000000..2d346f698a68
--- /dev/null
+++ b/include/linux/msm-bus.h
@@ -0,0 +1,214 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2010-2015, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef _ARCH_ARM_MACH_MSM_BUS_H
+#define _ARCH_ARM_MACH_MSM_BUS_H
+
+#include <linux/types.h>
+#include <linux/input.h>
+#include <linux/platform_device.h>
+
+/*
+ * Macros for clients to convert their data to ib and ab
+ * Ws : Time window over which to transfer the data in SECONDS
+ * Bs : Size of the data block in bytes
+ * Per : Recurrence period
+ * Tb : Throughput bandwidth to prevent stalling
+ * R  : Ratio of actual bandwidth used to Tb
+ * Ib : Instantaneous bandwidth
+ * Ab : Arbitrated bandwidth
+ *
+ * IB_RECURRBLOCK and AB_RECURRBLOCK:
+ * These are used if the requirement is to transfer a
+ * recurring block of data over a known time window.
+ *
+ * IB_THROUGHPUTBW and AB_THROUGHPUTBW:
+ * These are used for CPU style masters. Here the requirement
+ * is to have minimum throughput bandwidth available to avoid
+ * stalling.
+ */
+#define IB_RECURRBLOCK(Ws, Bs) ((Ws) == 0 ? 0 : ((Bs)/(Ws)))
+#define AB_RECURRBLOCK(Ws, Per) ((Ws) == 0 ? 0 : ((Bs)/(Per)))
+#define IB_THROUGHPUTBW(Tb) (Tb)
+#define AB_THROUGHPUTBW(Tb, R) ((Tb) * (R))
+
+struct msm_bus_vectors {
+	int src; /* Master */
+	int dst; /* Slave */
+	uint64_t ab; /* Arbitrated bandwidth */
+	uint64_t ib; /* Instantaneous bandwidth */
+};
+
+struct msm_bus_paths {
+	int num_paths;
+	struct msm_bus_vectors *vectors;
+};
+
+struct msm_bus_scale_pdata {
+	struct msm_bus_paths *usecase;
+	int num_usecases;
+	const char *name;
+	/*
+	 * If the active_only flag is set to 1, the BW request is applied
+	 * only when at least one CPU is active (powered on). If the flag
+	 * is set to 0, then the BW request is always applied irrespective
+	 * of the CPU state.
+	 */
+	unsigned int active_only;
+};
+
+struct msm_bus_client_handle {
+	char *name;
+	int mas;
+	int slv;
+	int first_hop;
+	struct device *mas_dev;
+	u64 cur_act_ib;
+	u64 cur_act_ab;
+	u64 cur_slp_ib;
+	u64 cur_slp_ab;
+	bool active_only;
+};
+
+/* Scaling APIs */
+
+/*
+ * This function returns a handle to the client. This should be used to
+ * call msm_bus_scale_client_update_request.
+ * The function returns 0 if bus driver is unable to register a client
+ */
+
+#if (defined(CONFIG_MSM_BUS_SCALING) || defined(CONFIG_BUS_TOPOLOGY_ADHOC))
+int __init msm_bus_fabric_init_driver(void);
+uint32_t msm_bus_scale_register_client(struct msm_bus_scale_pdata *pdata);
+int msm_bus_scale_client_update_request(uint32_t cl, unsigned int index);
+void msm_bus_scale_unregister_client(uint32_t cl);
+int msm_bus_scale_client_update_context(uint32_t cl, bool active_only,
+							unsigned int ctx_idx);
+
+struct msm_bus_client_handle*
+msm_bus_scale_register(uint32_t mas, uint32_t slv, char *name,
+							bool active_only);
+void msm_bus_scale_unregister(struct msm_bus_client_handle *cl);
+int msm_bus_scale_update_bw(struct msm_bus_client_handle *cl, u64 ab, u64 ib);
+int msm_bus_scale_update_bw_context(struct msm_bus_client_handle *cl,
+		u64 act_ab, u64 act_ib, u64 slp_ib, u64 slp_ab);
+/* AXI Port configuration APIs */
+int msm_bus_axi_porthalt(int master_port);
+int msm_bus_axi_portunhalt(int master_port);
+
+#else
+static inline int __init msm_bus_fabric_init_driver(void) { return 0; }
+static struct msm_bus_client_handle dummy_cl;
+
+static inline uint32_t
+msm_bus_scale_register_client(struct msm_bus_scale_pdata *pdata)
+{
+	return 1;
+}
+
+static inline int
+msm_bus_scale_client_update_request(uint32_t cl, unsigned int index)
+{
+	return 0;
+}
+
+static inline int
+msm_bus_scale_client_update_context(uint32_t cl, bool active_only,
+							unsigned int ctx_idx)
+{
+	return 0;
+}
+
+static inline void
+msm_bus_scale_unregister_client(uint32_t cl)
+{
+}
+
+static inline int msm_bus_axi_porthalt(int master_port)
+{
+	return 0;
+}
+
+static inline int msm_bus_axi_portunhalt(int master_port)
+{
+	return 0;
+}
+
+static inline struct msm_bus_client_handle*
+msm_bus_scale_register(uint32_t mas, uint32_t slv, char *name,
+							bool active_only)
+{
+	return &dummy_cl;
+}
+
+static inline void msm_bus_scale_unregister(struct msm_bus_client_handle *cl)
+{
+}
+
+static inline int
+msm_bus_scale_update_bw(struct msm_bus_client_handle *cl, u64 ab, u64 ib)
+{
+	return 0;
+}
+
+static inline int
+msm_bus_scale_update_bw_context(struct msm_bus_client_handle *cl, u64 act_ab,
+				u64 act_ib, u64 slp_ib, u64 slp_ab)
+
+{
+	return 0;
+}
+
+#endif
+
+#if defined(CONFIG_OF) && defined(CONFIG_MSM_BUS_SCALING)
+struct msm_bus_scale_pdata *msm_bus_pdata_from_node(
+		struct platform_device *pdev, struct device_node *of_node);
+struct msm_bus_scale_pdata *msm_bus_cl_get_pdata(struct platform_device *pdev);
+void msm_bus_cl_clear_pdata(struct msm_bus_scale_pdata *pdata);
+#else
+static inline struct msm_bus_scale_pdata
+*msm_bus_cl_get_pdata(struct platform_device *pdev)
+{
+	return NULL;
+}
+
+static inline struct msm_bus_scale_pdata *msm_bus_pdata_from_node(
+		struct platform_device *pdev, struct device_node *of_node)
+{
+	return NULL;
+}
+
+static inline void msm_bus_cl_clear_pdata(struct msm_bus_scale_pdata *pdata)
+{
+}
+#endif
+
+#ifdef CONFIG_DEBUG_BUS_VOTER
+int msm_bus_floor_vote_context(const char *name, u64 floor_hz,
+						bool active_only);
+int msm_bus_floor_vote(const char *name, u64 floor_hz);
+#else
+static inline int msm_bus_floor_vote(const char *name, u64 floor_hz)
+{
+	return -EINVAL;
+}
+
+static inline int msm_bus_floor_vote_context(const char *name, u64 floor_hz,
+						bool active_only)
+{
+	return -EINVAL;
+}
+#endif /*defined(CONFIG_DEBUG_BUS_VOTER) && defined(CONFIG_BUS_TOPOLOGY_ADHOC)*/
+#endif /*_ARCH_ARM_MACH_MSM_BUS_H*/
diff --git a/include/linux/msm_pcie.h b/include/linux/msm_pcie.h
new file mode 100644
index 000000000000..1f89cea940ea
--- /dev/null
+++ b/include/linux/msm_pcie.h
@@ -0,0 +1,173 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2014-2015, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MSM_PCIE_H
+#define __MSM_PCIE_H
+
+#include <linux/types.h>
+#include <linux/pci.h>
+
+enum msm_pcie_config {
+	MSM_PCIE_CONFIG_INVALID = 0,
+	MSM_PCIE_CONFIG_NO_CFG_RESTORE = 0x1,
+	MSM_PCIE_CONFIG_LINKDOWN = 0x2,
+	MSM_PCIE_CONFIG_NO_RECOVERY = 0x4,
+};
+
+enum msm_pcie_pm_opt {
+	MSM_PCIE_SUSPEND,
+	MSM_PCIE_RESUME,
+	MSM_PCIE_DISABLE_PC,
+	MSM_PCIE_ENABLE_PC,
+};
+
+enum msm_pcie_event {
+	MSM_PCIE_EVENT_INVALID = 0,
+	MSM_PCIE_EVENT_LINKDOWN = 0x1,
+	MSM_PCIE_EVENT_LINKUP = 0x2,
+	MSM_PCIE_EVENT_WAKEUP = 0x4,
+};
+
+enum msm_pcie_trigger {
+	MSM_PCIE_TRIGGER_CALLBACK,
+	MSM_PCIE_TRIGGER_COMPLETION,
+};
+
+struct msm_pcie_notify {
+	enum msm_pcie_event event;
+	void *user;
+	void *data;
+	u32 options;
+};
+
+struct msm_pcie_register_event {
+	u32 events;
+	void *user;
+	enum msm_pcie_trigger mode;
+	void (*callback)(struct msm_pcie_notify *notify);
+	struct msm_pcie_notify notify;
+	struct completion *completion;
+	u32 options;
+};
+
+/**
+ * msm_pcie_pm_control - control the power state of a PCIe link.
+ * @pm_opt:	power management operation
+ * @busnr:	bus number of PCIe endpoint
+ * @user:	handle of the caller
+ * @data:	private data from the caller
+ * @options:	options for pm control
+ *
+ * This function gives PCIe endpoint device drivers the control to change
+ * the power state of a PCIe link for their device.
+ *
+ * Return: 0 on success, negative value on error
+ */
+int msm_pcie_pm_control(enum msm_pcie_pm_opt pm_opt, u32 busnr, void *user,
+			void *data, u32 options);
+
+/**
+ * msm_pcie_register_event - register an event with PCIe bus driver.
+ * @reg:	event structure
+ *
+ * This function gives PCIe endpoint device drivers an option to register
+ * events with PCIe bus driver.
+ *
+ * Return: 0 on success, negative value on error
+ */
+int msm_pcie_register_event(struct msm_pcie_register_event *reg);
+
+/**
+ * msm_pcie_deregister_event - deregister an event with PCIe bus driver.
+ * @reg:	event structure
+ *
+ * This function gives PCIe endpoint device drivers an option to deregister
+ * events with PCIe bus driver.
+ *
+ * Return: 0 on success, negative value on error
+ */
+int msm_pcie_deregister_event(struct msm_pcie_register_event *reg);
+
+/**
+ * msm_pcie_recover_config - recover config space.
+ * @dev:	pci device structure
+ *
+ * This function recovers the config space of both RC and Endpoint.
+ *
+ * Return: 0 on success, negative value on error
+ */
+int msm_pcie_recover_config(struct pci_dev *dev);
+
+/**
+ * msm_pcie_enumerate - enumerate Endpoints.
+ * @rc_idx:	RC that Endpoints connect to.
+ *
+ * This function enumerates Endpoints connected to RC.
+ *
+ * Return: 0 on success, negative value on error
+ */
+int msm_pcie_enumerate(u32 rc_idx);
+
+/**
+ * msm_pcie_recover_config - recover config space.
+ * @dev:	pci device structure
+ *
+ * This function recovers the config space of both RC and Endpoint.
+ *
+ * Return: 0 on success, negative value on error
+ */
+int msm_pcie_recover_config(struct pci_dev *dev);
+
+/**
+ * msm_pcie_shadow_control - control the shadowing of PCIe config space.
+ * @dev:	pci device structure
+ * @enable:	shadowing should be enabled or disabled
+ *
+ * This function gives PCIe endpoint device drivers the control to enable
+ * or disable the shadowing of PCIe config space.
+ *
+ * Return: 0 on success, negative value on error
+ */
+int msm_pcie_shadow_control(struct pci_dev *dev, bool enable);
+
+/*
+ * msm_pcie_debug_info - run a PCIe specific debug testcase.
+ * @dev:	pci device structure
+ * @option:	specifies which PCIe debug testcase to execute
+ * @base:	PCIe specific range
+ * @offset:	offset of destination register
+ * @mask:	mask the bit(s) of destination register
+ * @value:	value to be written to destination register
+ *
+ * This function gives PCIe endpoint device drivers the control to
+ * run a debug testcase.
+ *
+ * Return: 0 on success, negative value on error
+ */
+int msm_pcie_debug_info(struct pci_dev *dev, u32 option, u32 base,
+			u32 offset, u32 mask, u32 value);
+
+/*
+ * msm_pcie_configure_sid - calculates the SID for a PCIe endpoint.
+ * @dev:	device structure
+ * @sid:	the calculated SID
+ * @domain:	the domain number of the Root Complex
+ *
+ * This function calculates the SID for a PCIe endpoint device.
+ *
+ * Return: 0 on success, negative value on error
+ */
+int msm_pcie_configure_sid(struct device *dev, u32 *sid,
+			int *domain);
+#endif
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c20f190b4c18..3602ee3c8039 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -72,6 +72,8 @@ void netdev_set_default_ethtool_ops(struct net_device *dev,
 #define NET_RX_SUCCESS		0	/* keep 'em coming, baby */
 #define NET_RX_DROP		1	/* packet dropped */
 
+#define MAX_NEST_DEV 8
+
 /*
  * Transmit return codes: transmit return codes originate from three different
  * namespaces:
@@ -1761,7 +1763,7 @@ enum netdev_priv_flags {
  *			for hardware timestamping
  *	@sfp_bus:	attached &struct sfp_bus structure.
  *	@qdisc_tx_busylock_key: lockdep class annotating Qdisc->busylock
-				spinlock
+ *				spinlock
  *	@qdisc_running_key:	lockdep class annotating Qdisc->running seqcount
  *	@qdisc_xmit_lock_key:	lockdep class annotating
  *				netdev_queue->_xmit_lock spinlock
@@ -1867,6 +1869,11 @@ struct net_device {
 	unsigned char		if_port;
 	unsigned char		dma;
 
+	/* Note : dev->mtu is often read without holding a lock.
+	 * Writers usually hold RTNL.
+	 * It is recommended to use READ_ONCE() to annotate the reads,
+	 * and to use WRITE_ONCE() to annotate the writes.
+	 */
 	unsigned int		mtu;
 	unsigned int		min_mtu;
 	unsigned int		max_mtu;
@@ -2973,6 +2980,7 @@ extern int netdev_flow_limit_table_len;
  */
 struct softnet_data {
 	struct list_head	poll_list;
+	struct napi_struct	*current_napi;
 	struct sk_buff_head	process_queue;
 
 	/* stats */
@@ -3631,6 +3639,7 @@ struct sk_buff *napi_get_frags(struct napi_struct *napi);
 gro_result_t napi_gro_frags(struct napi_struct *napi);
 struct packet_offload *gro_find_receive_by_type(__be16 type);
 struct packet_offload *gro_find_complete_by_type(__be16 type);
+extern struct napi_struct *get_current_napi_context(void);
 
 static inline void napi_free_frags(struct napi_struct *napi)
 {
@@ -3661,6 +3670,8 @@ int dev_set_alias(struct net_device *, const char *, size_t);
 int dev_get_alias(const struct net_device *, char *, size_t);
 int dev_change_net_namespace(struct net_device *, struct net *, const char *);
 int __dev_set_mtu(struct net_device *, int);
+int dev_validate_mtu(struct net_device *dev, int mtu,
+		     struct netlink_ext_ack *extack);
 int dev_set_mtu_ext(struct net_device *dev, int mtu,
 		    struct netlink_ext_ack *extack);
 int dev_set_mtu(struct net_device *, int);
@@ -4287,11 +4298,8 @@ void *netdev_lower_get_next(struct net_device *dev,
 	     ldev; \
 	     ldev = netdev_lower_get_next(dev, &(iter)))
 
-struct net_device *netdev_all_lower_get_next(struct net_device *dev,
+struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
 					     struct list_head **iter);
-struct net_device *netdev_all_lower_get_next_rcu(struct net_device *dev,
-						 struct list_head **iter);
-
 int netdev_walk_all_lower_dev(struct net_device *dev,
 			      int (*fn)(struct net_device *lower_dev,
 					void *data),
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 4a8c02cafa9a..6fa81e2db70f 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -535,6 +535,7 @@ enum {
 	IFLA_VXLAN_GPE,
 	IFLA_VXLAN_TTL_INHERIT,
 	IFLA_VXLAN_DF,
+	IFLA_VXLAN_FAN_MAP = 33,
 	__IFLA_VXLAN_MAX
 };
 #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
@@ -1013,6 +1014,9 @@ enum {
 #define RMNET_FLAGS_INGRESS_MAP_COMMANDS          (1U << 1)
 #define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
 #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
+#define RMNET_FLAGS_INGRESS_COALESCE              (1U << 4)
+#define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 5)
+#define RMNET_FLAGS_EGRESS_MAP_CKSUMV5            (1U << 6)
 
 enum {
 	IFLA_RMNET_UNSPEC,
diff --git a/include/uapi/linux/msm_rmnet.h b/include/uapi/linux/msm_rmnet.h
new file mode 100644
index 000000000000..5bad7bf02235
--- /dev/null
+++ b/include/uapi/linux/msm_rmnet.h
@@ -0,0 +1,170 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2012-2015, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef _UAPI_MSM_RMNET_H_
+#define _UAPI_MSM_RMNET_H_
+/* Bitmap macros for RmNET driver operation mode. */
+#define RMNET_MODE_NONE     (0x00)
+#define RMNET_MODE_LLP_ETH  (0x01)
+#define RMNET_MODE_LLP_IP   (0x02)
+#define RMNET_MODE_QOS      (0x04)
+#define RMNET_MODE_MASK     (RMNET_MODE_LLP_ETH | \
+			     RMNET_MODE_LLP_IP  | \
+			     RMNET_MODE_QOS)
+
+#define RMNET_IS_MODE_QOS(mode)  \
+	((mode & RMNET_MODE_QOS) == RMNET_MODE_QOS)
+#define RMNET_IS_MODE_IP(mode)   \
+	((mode & RMNET_MODE_LLP_IP) == RMNET_MODE_LLP_IP)
+
+/* IOCTL command enum
+ * Values chosen to not conflict with other drivers in the ecosystem
+ */
+enum rmnet_ioctl_cmds_e {
+	RMNET_IOCTL_SET_LLP_ETHERNET = 0x000089F1, /* Set Ethernet protocol  */
+	RMNET_IOCTL_SET_LLP_IP       = 0x000089F2, /* Set RAWIP protocol     */
+	RMNET_IOCTL_GET_LLP          = 0x000089F3, /* Get link protocol      */
+	RMNET_IOCTL_SET_QOS_ENABLE   = 0x000089F4, /* Set QoS header enabled */
+	RMNET_IOCTL_SET_QOS_DISABLE  = 0x000089F5, /* Set QoS header disabled*/
+	RMNET_IOCTL_GET_QOS          = 0x000089F6, /* Get QoS header state   */
+	RMNET_IOCTL_GET_OPMODE       = 0x000089F7, /* Get operation mode     */
+	RMNET_IOCTL_OPEN             = 0x000089F8, /* Open transport port    */
+	RMNET_IOCTL_CLOSE            = 0x000089F9, /* Close transport port   */
+	RMNET_IOCTL_FLOW_ENABLE      = 0x000089FA, /* Flow enable            */
+	RMNET_IOCTL_FLOW_DISABLE     = 0x000089FB, /* Flow disable           */
+	RMNET_IOCTL_FLOW_SET_HNDL    = 0x000089FC, /* Set flow handle        */
+	RMNET_IOCTL_EXTENDED         = 0x000089FD, /* Extended IOCTLs        */
+	RMNET_IOCTL_MAX
+};
+
+enum rmnet_ioctl_extended_cmds_e {
+/* RmNet Data Required IOCTLs */
+	RMNET_IOCTL_GET_SUPPORTED_FEATURES     = 0x0000,   /* Get features    */
+	RMNET_IOCTL_SET_MRU                    = 0x0001,   /* Set MRU         */
+	RMNET_IOCTL_GET_MRU                    = 0x0002,   /* Get MRU         */
+	RMNET_IOCTL_GET_EPID                   = 0x0003,   /* Get endpoint ID */
+	RMNET_IOCTL_GET_DRIVER_NAME            = 0x0004,   /* Get driver name */
+	RMNET_IOCTL_ADD_MUX_CHANNEL            = 0x0005,   /* Add MUX ID      */
+	RMNET_IOCTL_SET_EGRESS_DATA_FORMAT     = 0x0006,   /* Set EDF         */
+	RMNET_IOCTL_SET_INGRESS_DATA_FORMAT    = 0x0007,   /* Set IDF         */
+	RMNET_IOCTL_SET_AGGREGATION_COUNT      = 0x0008,   /* Set agg count   */
+	RMNET_IOCTL_GET_AGGREGATION_COUNT      = 0x0009,   /* Get agg count   */
+	RMNET_IOCTL_SET_AGGREGATION_SIZE       = 0x000A,   /* Set agg size    */
+	RMNET_IOCTL_GET_AGGREGATION_SIZE       = 0x000B,   /* Get agg size    */
+	RMNET_IOCTL_FLOW_CONTROL               = 0x000C,   /* Do flow control */
+	RMNET_IOCTL_GET_DFLT_CONTROL_CHANNEL   = 0x000D,   /* For legacy use  */
+	RMNET_IOCTL_GET_HWSW_MAP               = 0x000E,   /* Get HW/SW map   */
+	RMNET_IOCTL_SET_RX_HEADROOM            = 0x000F,   /* RX Headroom     */
+	RMNET_IOCTL_GET_EP_PAIR                = 0x0010,   /* Endpoint pair   */
+	RMNET_IOCTL_SET_QOS_VERSION            = 0x0011,   /* 8/6 byte QoS hdr*/
+	RMNET_IOCTL_GET_QOS_VERSION            = 0x0012,   /* 8/6 byte QoS hdr*/
+	RMNET_IOCTL_GET_SUPPORTED_QOS_MODES    = 0x0013,   /* Get QoS modes   */
+	RMNET_IOCTL_SET_SLEEP_STATE            = 0x0014,   /* Set sleep state */
+	RMNET_IOCTL_SET_XLAT_DEV_INFO          = 0x0015,   /* xlat dev name   */
+	RMNET_IOCTL_DEREGISTER_DEV             = 0x0016,   /* Dereg a net dev */
+	RMNET_IOCTL_GET_SG_SUPPORT             = 0x0017,   /* Query sg support*/
+	RMNET_IOCTL_EXTENDED_MAX               = 0x0018
+};
+
+/* Return values for the RMNET_IOCTL_GET_SUPPORTED_FEATURES IOCTL */
+#define RMNET_IOCTL_FEAT_NOTIFY_MUX_CHANNEL              (1<<0)
+#define RMNET_IOCTL_FEAT_SET_EGRESS_DATA_FORMAT          (1<<1)
+#define RMNET_IOCTL_FEAT_SET_INGRESS_DATA_FORMAT         (1<<2)
+#define RMNET_IOCTL_FEAT_SET_AGGREGATION_COUNT           (1<<3)
+#define RMNET_IOCTL_FEAT_GET_AGGREGATION_COUNT           (1<<4)
+#define RMNET_IOCTL_FEAT_SET_AGGREGATION_SIZE            (1<<5)
+#define RMNET_IOCTL_FEAT_GET_AGGREGATION_SIZE            (1<<6)
+#define RMNET_IOCTL_FEAT_FLOW_CONTROL                    (1<<7)
+#define RMNET_IOCTL_FEAT_GET_DFLT_CONTROL_CHANNEL        (1<<8)
+#define RMNET_IOCTL_FEAT_GET_HWSW_MAP                    (1<<9)
+
+/* Input values for the RMNET_IOCTL_SET_EGRESS_DATA_FORMAT IOCTL  */
+#define RMNET_IOCTL_EGRESS_FORMAT_MAP                  (1<<1)
+#define RMNET_IOCTL_EGRESS_FORMAT_AGGREGATION          (1<<2)
+#define RMNET_IOCTL_EGRESS_FORMAT_MUXING               (1<<3)
+#define RMNET_IOCTL_EGRESS_FORMAT_CHECKSUM             (1<<4)
+
+/* Input values for the RMNET_IOCTL_SET_INGRESS_DATA_FORMAT IOCTL */
+#define RMNET_IOCTL_INGRESS_FORMAT_MAP                 (1<<1)
+#define RMNET_IOCTL_INGRESS_FORMAT_DEAGGREGATION       (1<<2)
+#define RMNET_IOCTL_INGRESS_FORMAT_DEMUXING            (1<<3)
+#define RMNET_IOCTL_INGRESS_FORMAT_CHECKSUM            (1<<4)
+#define RMNET_IOCTL_INGRESS_FORMAT_AGG_DATA            (1<<5)
+
+/* User space may not have this defined. */
+#ifndef IFNAMSIZ
+#define IFNAMSIZ 16
+#endif
+
+struct rmnet_ioctl_extended_s {
+	uint32_t   extended_ioctl;
+	union {
+		uint32_t data; /* Generic data field for most extended IOCTLs */
+
+		/* Return values for
+		 *    RMNET_IOCTL_GET_DRIVER_NAME
+		 *    RMNET_IOCTL_GET_DFLT_CONTROL_CHANNEL
+		 */
+		int8_t if_name[IFNAMSIZ];
+
+		/* Input values for the RMNET_IOCTL_ADD_MUX_CHANNEL IOCTL */
+		struct {
+			uint32_t  mux_id;
+			int8_t    vchannel_name[IFNAMSIZ];
+		} rmnet_mux_val;
+
+		/* Input values for the RMNET_IOCTL_FLOW_CONTROL IOCTL */
+		struct {
+			uint8_t   flow_mode;
+			uint8_t   mux_id;
+		} flow_control_prop;
+
+		/* Return values for RMNET_IOCTL_GET_EP_PAIR */
+		struct {
+			uint32_t   consumer_pipe_num;
+			uint32_t   producer_pipe_num;
+		} ipa_ep_pair;
+
+		struct {
+			uint32_t __data; /* Placeholder for legacy data*/
+			uint32_t agg_size;
+			uint32_t agg_count;
+		} ingress_format;
+	} u;
+};
+
+struct rmnet_ioctl_data_s {
+	union {
+		uint32_t	operation_mode;
+		uint32_t	tcm_handle;
+	} u;
+};
+
+#define RMNET_IOCTL_QOS_MODE_6   (1<<0)
+#define RMNET_IOCTL_QOS_MODE_8   (1<<1)
+
+/* QMI QoS header definition */
+#define QMI_QOS_HDR_S  qmi_qos_hdr_s
+struct QMI_QOS_HDR_S {
+	unsigned char    version;
+	unsigned char    flags;
+	uint32_t         flow_id;
+} __attribute((__packed__));
+
+/* QMI QoS 8-byte header. */
+struct qmi_qos_hdr8_s {
+	struct QMI_QOS_HDR_S   hdr;
+	uint8_t                reserved[2];
+} __attribute((__packed__));
+
+#endif /* _UAPI_MSM_RMNET_H_ */
diff --git a/mm/memblock.c b/mm/memblock.c
index c4b16cae2bc9..ad0312d7fe8e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1616,6 +1616,7 @@ phys_addr_t __init_memblock memblock_start_of_DRAM(void)
 {
 	return memblock.memory.regions[0].base;
 }
+EXPORT_SYMBOL(memblock_start_of_DRAM);
 
 phys_addr_t __init_memblock memblock_end_of_DRAM(void)
 {
@@ -1623,6 +1624,7 @@ phys_addr_t __init_memblock memblock_end_of_DRAM(void)
 
 	return (memblock.memory.regions[idx].base + memblock.memory.regions[idx].size);
 }
+EXPORT_SYMBOL(memblock_end_of_DRAM);
 
 static phys_addr_t __init_memblock __find_max_addr(phys_addr_t limit)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index 99ac84ff398f..c00251780581 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -146,7 +146,6 @@
 #include "net-sysfs.h"
 
 #define MAX_GRO_SKBS 8
-#define MAX_NEST_DEV 8
 
 /* This should be increased if a protocol with a bigger head is added. */
 #define GRO_MAX_HEAD (MAX_HEADER + 128)
@@ -2796,6 +2795,8 @@ static u16 skb_tx_hash(const struct net_device *dev,
 
 	if (skb_rx_queue_recorded(skb)) {
 		hash = skb_get_rx_queue(skb);
+		if (hash >= qoffset)
+			hash -= qoffset;
 		while (unlikely(hash >= qcount))
 			hash -= qcount;
 		return hash + qoffset;
@@ -3386,26 +3387,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 	qdisc_calculate_pkt_len(skb, q);
 
 	if (q->flags & TCQ_F_NOLOCK) {
-		if ((q->flags & TCQ_F_CAN_BYPASS) && q->empty &&
-		    qdisc_run_begin(q)) {
-			if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED,
-					      &q->state))) {
-				__qdisc_drop(skb, &to_free);
-				rc = NET_XMIT_DROP;
-				goto end_run;
-			}
-			qdisc_bstats_cpu_update(q, skb);
-
-			rc = NET_XMIT_SUCCESS;
-			if (sch_direct_xmit(skb, q, dev, txq, NULL, true))
-				__qdisc_run(q);
-
-end_run:
-			qdisc_run_end(q);
-		} else {
-			rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
-			qdisc_run(q);
-		}
+		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+		qdisc_run(q);
 
 		if (unlikely(to_free))
 			kfree_skb_list(to_free);
@@ -3880,7 +3863,8 @@ EXPORT_SYMBOL(netdev_max_backlog);
 
 int netdev_tstamp_prequeue __read_mostly = 1;
 int netdev_budget __read_mostly = 300;
-unsigned int __read_mostly netdev_budget_usecs = 2000;
+/* Must be at least 2 jiffes to guarantee 1 jiffy timeout */
+unsigned int __read_mostly netdev_budget_usecs = 2 * USEC_PER_SEC / HZ;
 int weight_p __read_mostly = 64;           /* old backlog weight */
 int dev_weight_rx_bias __read_mostly = 1;  /* bias for backlog weight */
 int dev_weight_tx_bias __read_mostly = 1;  /* bias for output_queue quota */
@@ -4256,14 +4240,14 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	/* Reinjected packets coming from act_mirred or similar should
 	 * not get XDP generic processing.
 	 */
-	if (skb_cloned(skb) || skb_is_tc_redirected(skb))
+	if (skb_is_redirected(skb))
 		return XDP_PASS;
 
 	/* XDP packets must be linear and must have sufficient headroom
 	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
 	 * native XDP provides, thus we need to do it here as well.
 	 */
-	if (skb_is_nonlinear(skb) ||
+	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
 	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
 		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
 		int troom = skb->tail + skb->data_len - skb->end;
@@ -4729,11 +4713,12 @@ static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
 	return 0;
 }
 
-static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
+static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 				    struct packet_type **ppt_prev)
 {
 	struct packet_type *ptype, *pt_prev;
 	rx_handler_func_t *rx_handler;
+	struct sk_buff *skb = *pskb;
 	struct net_device *orig_dev;
 	bool deliver_exact = false;
 	int ret = NET_RX_DROP;
@@ -4764,8 +4749,10 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
 		preempt_enable();
 
-		if (ret2 != XDP_PASS)
-			return NET_RX_DROP;
+		if (ret2 != XDP_PASS) {
+			ret = NET_RX_DROP;
+			goto out;
+		}
 		skb_reset_mac_len(skb);
 	}
 
@@ -4805,7 +4792,7 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 			goto out;
 	}
 #endif
-	skb_reset_tc(skb);
+	skb_reset_redirect(skb);
 skip_classify:
 	if (pfmemalloc && !skb_pfmemalloc_protocol(skb))
 		goto drop;
@@ -4915,6 +4902,13 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 	}
 
 out:
+	/* The invariant here is that if *ppt_prev is not NULL
+	 * then skb should also be non-NULL.
+	 *
+	 * Apparently *ppt_prev assignment above holds this invariant due to
+	 * skb dereferencing near it.
+	 */
+	*pskb = skb;
 	return ret;
 }
 
@@ -4924,7 +4918,7 @@ static int __netif_receive_skb_one_core(struct sk_buff *skb, bool pfmemalloc)
 	struct packet_type *pt_prev = NULL;
 	int ret;
 
-	ret = __netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
+	ret = __netif_receive_skb_core(&skb, pfmemalloc, &pt_prev);
 	if (pt_prev)
 		ret = INDIRECT_CALL_INET(pt_prev->func, ipv6_rcv, ip_rcv, skb,
 					 skb->dev, pt_prev, orig_dev);
@@ -5002,7 +4996,7 @@ static void __netif_receive_skb_list_core(struct list_head *head, bool pfmemallo
 		struct packet_type *pt_prev = NULL;
 
 		skb_list_del_init(skb);
-		__netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
+		__netif_receive_skb_core(&skb, pfmemalloc, &pt_prev);
 		if (!pt_prev)
 			continue;
 		if (pt_curr != pt_prev || od_curr != orig_dev) {
@@ -5270,9 +5264,29 @@ static void flush_all_backlogs(void)
 	put_online_cpus();
 }
 
+/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
+static void gro_normal_list(struct napi_struct *napi)
+{
+	if (!napi->rx_count)
+		return;
+	netif_receive_skb_list_internal(&napi->rx_list);
+	INIT_LIST_HEAD(&napi->rx_list);
+	napi->rx_count = 0;
+}
+
+/* Queue one GRO_NORMAL SKB up for list processing. If batch size exceeded,
+ * pass the whole batch up to the stack.
+ */
+static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb)
+{
+	list_add_tail(&skb->list, &napi->rx_list);
+	if (++napi->rx_count >= gro_normal_batch)
+		gro_normal_list(napi);
+}
+
 INDIRECT_CALLABLE_DECLARE(int inet_gro_complete(struct sk_buff *, int));
 INDIRECT_CALLABLE_DECLARE(int ipv6_gro_complete(struct sk_buff *, int));
-static int napi_gro_complete(struct sk_buff *skb)
+static int napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
 {
 	struct packet_offload *ptype;
 	__be16 type = skb->protocol;
@@ -5305,7 +5319,8 @@ static int napi_gro_complete(struct sk_buff *skb)
 	}
 
 out:
-	return netif_receive_skb_internal(skb);
+	gro_normal_one(napi, skb);
+	return NET_RX_SUCCESS;
 }
 
 static void __napi_gro_flush_chain(struct napi_struct *napi, u32 index,
@@ -5318,7 +5333,7 @@ static void __napi_gro_flush_chain(struct napi_struct *napi, u32 index,
 		if (flush_old && NAPI_GRO_CB(skb)->age == jiffies)
 			return;
 		skb_list_del_init(skb);
-		napi_gro_complete(skb);
+		napi_gro_complete(napi, skb);
 		napi->gro_hash[index].count--;
 	}
 
@@ -5421,7 +5436,7 @@ static void gro_pull_from_frag0(struct sk_buff *skb, int grow)
 	}
 }
 
-static void gro_flush_oldest(struct list_head *head)
+static void gro_flush_oldest(struct napi_struct *napi, struct list_head *head)
 {
 	struct sk_buff *oldest;
 
@@ -5437,7 +5452,7 @@ static void gro_flush_oldest(struct list_head *head)
 	 * SKB to the chain.
 	 */
 	skb_list_del_init(oldest);
-	napi_gro_complete(oldest);
+	napi_gro_complete(napi, oldest);
 }
 
 INDIRECT_CALLABLE_DECLARE(struct sk_buff *inet_gro_receive(struct list_head *,
@@ -5513,7 +5528,7 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 
 	if (pp) {
 		skb_list_del_init(pp);
-		napi_gro_complete(pp);
+		napi_gro_complete(napi, pp);
 		napi->gro_hash[hash].count--;
 	}
 
@@ -5524,7 +5539,7 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 		goto normal;
 
 	if (unlikely(napi->gro_hash[hash].count >= MAX_GRO_SKBS)) {
-		gro_flush_oldest(gro_head);
+		gro_flush_oldest(napi, gro_head);
 	} else {
 		napi->gro_hash[hash].count++;
 	}
@@ -5672,26 +5687,6 @@ struct sk_buff *napi_get_frags(struct napi_struct *napi)
 }
 EXPORT_SYMBOL(napi_get_frags);
 
-/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
-static void gro_normal_list(struct napi_struct *napi)
-{
-	if (!napi->rx_count)
-		return;
-	netif_receive_skb_list_internal(&napi->rx_list);
-	INIT_LIST_HEAD(&napi->rx_list);
-	napi->rx_count = 0;
-}
-
-/* Queue one GRO_NORMAL SKB up for list processing.  If batch size exceeded,
- * pass the whole batch up to the stack.
- */
-static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb)
-{
-	list_add_tail(&skb->list, &napi->rx_list);
-	if (++napi->rx_count >= gro_normal_batch)
-		gro_normal_list(napi);
-}
-
 static gro_result_t napi_frags_finish(struct napi_struct *napi,
 				      struct sk_buff *skb,
 				      gro_result_t ret)
@@ -5979,8 +5974,6 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 				 NAPIF_STATE_IN_BUSY_POLL)))
 		return false;
 
-	gro_normal_list(n);
-
 	if (n->gro_bitmask) {
 		unsigned long timeout = 0;
 
@@ -5996,6 +5989,9 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 			hrtimer_start(&n->timer, ns_to_ktime(timeout),
 				      HRTIMER_MODE_REL_PINNED);
 	}
+
+	gro_normal_list(n);
+
 	if (unlikely(!list_empty(&n->poll_list))) {
 		/* If n->poll_list is not empty, we need to mask irqs */
 		local_irq_save(flags);
@@ -6289,6 +6285,14 @@ void netif_napi_del(struct napi_struct *napi)
 }
 EXPORT_SYMBOL(netif_napi_del);
 
+struct napi_struct *get_current_napi_context(void)
+{
+	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
+
+	return sd->current_napi;
+}
+EXPORT_SYMBOL(get_current_napi_context);
+
 static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 {
 	void *have;
@@ -6327,8 +6331,6 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 		goto out_unlock;
 	}
 
-	gro_normal_list(n);
-
 	if (n->gro_bitmask) {
 		/* flush too old packets
 		 * If HZ < 1000, flush all packets.
@@ -6336,6 +6338,8 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 		napi_gro_flush(n, HZ >= 1000);
 	}
 
+	gro_normal_list(n);
+
 	/* Some drivers may have called napi_schedule
 	 * prior to exhausting their budget.
 	 */
@@ -6930,8 +6934,8 @@ static int __netdev_walk_all_lower_dev(struct net_device *dev,
 	return 0;
 }
 
-static struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
-						    struct list_head **iter)
+struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
+					     struct list_head **iter)
 {
 	struct netdev_adjacent *lower;
 
@@ -6943,6 +6947,7 @@ static struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
 
 	return lower->dev;
 }
+EXPORT_SYMBOL(netdev_next_lower_dev_rcu);
 
 static u8 __netdev_upper_depth(struct net_device *dev)
 {
@@ -7967,11 +7972,28 @@ int __dev_set_mtu(struct net_device *dev, int new_mtu)
 	if (ops->ndo_change_mtu)
 		return ops->ndo_change_mtu(dev, new_mtu);
 
-	dev->mtu = new_mtu;
+	/* Pairs with all the lockless reads of dev->mtu in the stack */
+	WRITE_ONCE(dev->mtu, new_mtu);
 	return 0;
 }
 EXPORT_SYMBOL(__dev_set_mtu);
 
+int dev_validate_mtu(struct net_device *dev, int new_mtu,
+		     struct netlink_ext_ack *extack)
+{
+	/* MTU must be positive, and in range */
+	if (new_mtu < 0 || new_mtu < dev->min_mtu) {
+		NL_SET_ERR_MSG(extack, "mtu less than device minimum");
+		return -EINVAL;
+	}
+
+	if (dev->max_mtu > 0 && new_mtu > dev->max_mtu) {
+		NL_SET_ERR_MSG(extack, "mtu greater than device maximum");
+		return -EINVAL;
+	}
+	return 0;
+}
+
 /**
  *	dev_set_mtu_ext - Change maximum transfer unit
  *	@dev: device
@@ -7988,16 +8010,9 @@ int dev_set_mtu_ext(struct net_device *dev, int new_mtu,
 	if (new_mtu == dev->mtu)
 		return 0;
 
-	/* MTU must be positive, and in range */
-	if (new_mtu < 0 || new_mtu < dev->min_mtu) {
-		NL_SET_ERR_MSG(extack, "mtu less than device minimum");
-		return -EINVAL;
-	}
-
-	if (dev->max_mtu > 0 && new_mtu > dev->max_mtu) {
-		NL_SET_ERR_MSG(extack, "mtu greater than device maximum");
-		return -EINVAL;
-	}
+	err = dev_validate_mtu(dev, new_mtu, extack);
+	if (err)
+		return err;
 
 	if (!netif_device_present(dev))
 		return -ENODEV;
@@ -8598,11 +8613,13 @@ static void netdev_sync_lower_features(struct net_device *upper,
 			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
 				   &feature, lower->name);
 			lower->wanted_features &= ~feature;
-			netdev_update_features(lower);
+			__netdev_update_features(lower);
 
 			if (unlikely(lower->features & feature))
 				netdev_WARN(upper, "failed to disable %pNF on %s!\n",
 					    &feature, lower->name);
+			else
+				netdev_features_change(lower);
 		}
 	}
 }
@@ -8952,22 +8969,10 @@ static void netdev_unregister_lockdep_key(struct net_device *dev)
 
 void netdev_update_lockdep_key(struct net_device *dev)
 {
-	struct netdev_queue *queue;
-	int i;
-
-	lockdep_unregister_key(&dev->qdisc_xmit_lock_key);
 	lockdep_unregister_key(&dev->addr_list_lock_key);
-
-	lockdep_register_key(&dev->qdisc_xmit_lock_key);
 	lockdep_register_key(&dev->addr_list_lock_key);
 
 	lockdep_set_class(&dev->addr_list_lock, &dev->addr_list_lock_key);
-	for (i = 0; i < dev->num_tx_queues; i++) {
-		queue = netdev_get_tx_queue(dev, i);
-
-		lockdep_set_class(&queue->_xmit_lock,
-				  &dev->qdisc_xmit_lock_key);
-	}
 }
 EXPORT_SYMBOL(netdev_update_lockdep_key);
 
@@ -9084,8 +9089,10 @@ int register_netdevice(struct net_device *dev)
 		goto err_uninit;
 
 	ret = netdev_register_kobject(dev);
-	if (ret)
+	if (ret) {
+		dev->reg_state = NETREG_UNREGISTERED;
 		goto err_uninit;
+	}
 	dev->reg_state = NETREG_REGISTERED;
 
 	__netdev_update_features(dev);
@@ -9715,6 +9722,7 @@ EXPORT_SYMBOL(unregister_netdev);
 
 int dev_change_net_namespace(struct net_device *dev, struct net *net, const char *pat)
 {
+	struct net *net_old = dev_net(dev);
 	int err, new_nsid, new_ifindex;
 
 	ASSERT_RTNL();
@@ -9730,7 +9738,7 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 
 	/* Get out if there is nothing todo */
 	err = 0;
-	if (net_eq(dev_net(dev), net))
+	if (net_eq(net_old, net))
 		goto out;
 
 	/* Pick the destination device name, and ensure
@@ -9803,6 +9811,12 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 	err = device_rename(&dev->dev, dev->name);
 	WARN_ON(err);
 
+	/* Adapt owner in case owning user namespace of target network
+	 * namespace is different from the original one.
+	 */
+	err = netdev_change_owner(dev, net_old, net);
+	WARN_ON(err);
+
 	/* Add the device back in the hashes */
 	list_netdevice(dev);
 
-- 
2.25.1

