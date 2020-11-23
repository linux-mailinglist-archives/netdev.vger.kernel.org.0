Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9423F2C0C64
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388747AbgKWNwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:52:46 -0500
Received: from mga14.intel.com ([192.55.52.115]:1517 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388215AbgKWNwp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 08:52:45 -0500
IronPort-SDR: xZrBQt7b0ASNcfjrHLtpX8uHPR4ya2TWYxfK+EQuWxUHA0khSWyR7ZRmOhE776IijHaxklaQxs
 l8MG6gRrA1YA==
X-IronPort-AV: E=McAfee;i="6000,8403,9813"; a="170981526"
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="170981526"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 05:52:44 -0800
IronPort-SDR: msN81Kew0WmDV9OhiACVMXr84Ac9RfCeAfeWBKF2npy9ueNplzmhmjerAbcQOOq8Z3q68kPXm9
 tG4V4ulhZC9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="370035683"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga007.jf.intel.com with ESMTP; 23 Nov 2020 05:52:42 -0800
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com
Subject: [RFC 18/18] net: iosm: infrastructure
Date:   Mon, 23 Nov 2020 19:21:23 +0530
Message-Id: <20201123135123.48892-19-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20201123135123.48892-1-m.chetan.kumar@intel.com>
References: <20201123135123.48892-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Kconfig & Makefile changes for IOSM Driver compilation.
2) Modified driver/net Kconfig & Makefile for driver inclusion.
3) Modified MAINTAINER file for IOSM Driver addition.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
 MAINTAINERS                    |  7 +++++++
 drivers/net/Kconfig            |  1 +
 drivers/net/Makefile           |  1 +
 drivers/net/wwan/Kconfig       | 13 +++++++++++++
 drivers/net/wwan/Makefile      |  5 +++++
 drivers/net/wwan/iosm/Kconfig  | 10 ++++++++++
 drivers/net/wwan/iosm/Makefile | 27 +++++++++++++++++++++++++++
 7 files changed, 64 insertions(+)
 create mode 100644 drivers/net/wwan/Kconfig
 create mode 100644 drivers/net/wwan/Makefile
 create mode 100644 drivers/net/wwan/iosm/Kconfig
 create mode 100644 drivers/net/wwan/iosm/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index a008b70f3c16..cb1fc8fabffd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9099,6 +9099,13 @@ M:	Mario Limonciello <mario.limonciello@dell.com>
 S:	Maintained
 F:	drivers/platform/x86/intel-wmi-thunderbolt.c
 
+INTEL WWAN IOSM DRIVER
+M:      M Chetan Kumar <m.chetan.kumar@intel.com>
+M:      Intel Corporation <linuxwwan@intel.com>
+L:      netdev@vger.kernel.org
+S:      Maintained
+F:      drivers/net/wwan/iosm/
+
 INTEL(R) TRACE HUB
 M:	Alexander Shishkin <alexander.shishkin@linux.intel.com>
 S:	Supported
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index c3dbe64e628e..e0f869a2c52f 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -593,4 +593,5 @@ config NET_FAILOVER
 	  a VM with direct attached VF by failing over to the paravirtual
 	  datapath when the VF is unplugged.
 
+source "drivers/net/wwan/Kconfig"
 endif # NETDEVICES
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 72e18d505d1a..025fb399d2af 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -84,3 +84,4 @@ thunderbolt-net-y += thunderbolt.o
 obj-$(CONFIG_USB4_NET) += thunderbolt-net.o
 obj-$(CONFIG_NETDEVSIM) += netdevsim/
 obj-$(CONFIG_NET_FAILOVER) += net_failover.o
+obj-$(CONFIG_WWAN)+= wwan/
diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
new file mode 100644
index 000000000000..715dfd0598f9
--- /dev/null
+++ b/drivers/net/wwan/Kconfig
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Wireless WAN device configuration
+#
+
+menuconfig WWAN
+	bool "Wireless WAN"
+	help
+	  This section contains all Wireless WAN driver configurations.
+
+if WWAN
+source "drivers/net/wwan/iosm/Kconfig"
+endif # WWAN
diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
new file mode 100644
index 000000000000..a81ff28e6cd9
--- /dev/null
+++ b/drivers/net/wwan/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for the Linux WWAN Device Drivers.
+#
+obj-$(CONFIG_IOSM)+= iosm/
diff --git a/drivers/net/wwan/iosm/Kconfig b/drivers/net/wwan/iosm/Kconfig
new file mode 100644
index 000000000000..fed382fc9cd7
--- /dev/null
+++ b/drivers/net/wwan/iosm/Kconfig
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: (GPL-2.0-only)
+#
+# IOSM Driver configuration
+#
+
+config IOSM
+	tristate "IOSM Driver"
+	depends on INTEL_IOMMU
+	help
+	  This driver enables Intel M.2 WWAN Device communication.
diff --git a/drivers/net/wwan/iosm/Makefile b/drivers/net/wwan/iosm/Makefile
new file mode 100644
index 000000000000..153ae0360244
--- /dev/null
+++ b/drivers/net/wwan/iosm/Makefile
@@ -0,0 +1,27 @@
+# SPDX-License-Identifier: (GPL-2.0-only)
+#
+# Copyright (C) 2020 Intel Corporation.
+#
+
+iosm-y = \
+	iosm_ipc_task_queue.o	\
+	iosm_ipc_imem.o			\
+	iosm_ipc_imem_ops.o		\
+	iosm_ipc_mmio.o			\
+	iosm_ipc_sio.o			\
+	iosm_ipc_mbim.o			\
+	iosm_ipc_wwan.o			\
+	iosm_ipc_uevent.o		\
+	iosm_ipc_pm.o			\
+	iosm_ipc_pcie.o			\
+	iosm_ipc_irq.o			\
+	iosm_ipc_chnl_cfg.o		\
+	iosm_ipc_protocol.o		\
+	iosm_ipc_protocol_ops.o	\
+	iosm_ipc_mux.o			\
+	iosm_ipc_mux_codec.o
+
+obj-$(CONFIG_IOSM) := iosm.o
+
+# compilation flags
+#ccflags-y += -DDEBUG
-- 
2.12.3

