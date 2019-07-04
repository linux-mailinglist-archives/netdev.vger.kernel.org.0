Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4D995F132
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 04:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfGDCMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 22:12:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:33416 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727282AbfGDCM0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 22:12:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jul 2019 19:12:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,449,1557212400"; 
   d="scan'208";a="169319082"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 03 Jul 2019 19:12:24 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     dledford@redhat.com, jgg@mellanox.com, davem@davemloft.net
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, poswald@suse.com,
        david.m.ertman@intel.com, mustafa.ismail@intel.com
Subject: [rdma 1/1] RDMA/irdma: Add Kconfig and Makefile
Date:   Wed,  3 Jul 2019 19:12:43 -0700
Message-Id: <20190704021259.15489-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704021259.15489-1-jeffrey.t.kirsher@intel.com>
References: <20190704021259.15489-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

Add Kconfig and Makefile to build irdma driver and mark i40iw
deprecated/obsolete, since the irdma driver is replacing it and supports
x722 devices.

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/Kconfig           |  1 +
 drivers/infiniband/hw/Makefile       |  1 +
 drivers/infiniband/hw/i40iw/Kconfig  |  4 +++-
 drivers/infiniband/hw/irdma/Kconfig  | 11 ++++++++++
 drivers/infiniband/hw/irdma/Makefile | 31 ++++++++++++++++++++++++++++
 5 files changed, 47 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/hw/irdma/Kconfig
 create mode 100644 drivers/infiniband/hw/irdma/Makefile

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 0fe6f76e8fdc..40b032a764f5 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -84,6 +84,7 @@ source "drivers/infiniband/hw/cxgb3/Kconfig"
 source "drivers/infiniband/hw/cxgb4/Kconfig"
 source "drivers/infiniband/hw/efa/Kconfig"
 source "drivers/infiniband/hw/i40iw/Kconfig"
+source "drivers/infiniband/hw/irdma/Kconfig"
 source "drivers/infiniband/hw/mlx4/Kconfig"
 source "drivers/infiniband/hw/mlx5/Kconfig"
 source "drivers/infiniband/hw/ocrdma/Kconfig"
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index 433fca59febd..d61d690ec0d4 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_INFINIBAND_CXGB3)		+= cxgb3/
 obj-$(CONFIG_INFINIBAND_CXGB4)		+= cxgb4/
 obj-$(CONFIG_INFINIBAND_EFA)		+= efa/
 obj-$(CONFIG_INFINIBAND_I40IW)		+= i40iw/
+obj-$(CONFIG_INFINIBAND_IRDMA)		+= irdma/
 obj-$(CONFIG_MLX4_INFINIBAND)		+= mlx4/
 obj-$(CONFIG_MLX5_INFINIBAND)		+= mlx5/
 obj-$(CONFIG_INFINIBAND_OCRDMA)		+= ocrdma/
diff --git a/drivers/infiniband/hw/i40iw/Kconfig b/drivers/infiniband/hw/i40iw/Kconfig
index d867ef1ac72a..7454b84b74be 100644
--- a/drivers/infiniband/hw/i40iw/Kconfig
+++ b/drivers/infiniband/hw/i40iw/Kconfig
@@ -1,8 +1,10 @@
 config INFINIBAND_I40IW
-	tristate "Intel(R) Ethernet X722 iWARP Driver"
+	tristate "Intel(R) Ethernet X722 iWARP Driver (DEPRECATED)"
 	depends on INET && I40E
 	depends on IPV6 || !IPV6
 	depends on PCI
+	depends on !(INFINBAND_IRDMA=y || INFINIBAND_IRDMA=m)
 	select GENERIC_ALLOCATOR
 	---help---
 	Intel(R) Ethernet X722 iWARP Driver
+	This driver is being replaced by irdma.
diff --git a/drivers/infiniband/hw/irdma/Kconfig b/drivers/infiniband/hw/irdma/Kconfig
new file mode 100644
index 000000000000..652f5f978ce2
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/Kconfig
@@ -0,0 +1,11 @@
+config INFINIBAND_IRDMA
+       tristate "Intel(R) Ethernet Connection RDMA Driver"
+       depends on INET && (I40E || ICE)
+       depends on IPV6 || !IPV6
+       depends on PCI
+       select GENERIC_ALLOCATOR
+       ---help---
+       This is an Ethernet RDMA driver that supports E810 (iWARP/RoCE)
+       and X722 (iWARP) network devices.
+       To compile this driver as a module, choose M here. The module
+       will be called irdma.
diff --git a/drivers/infiniband/hw/irdma/Makefile b/drivers/infiniband/hw/irdma/Makefile
new file mode 100644
index 000000000000..455940d7cc69
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/Makefile
@@ -0,0 +1,31 @@
+# SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+# Copyright (c) 2019, Intel Corporation.
+
+#
+# Makefile for the Intel(R) Ethernet Connection RDMA Linux Driver
+#
+
+ccflags-y := -I $(srctree)/drivers/net/ethernet/intel/i40e
+ccflags-y += -I $(srctree)/drivers/net/ethernet/intel/ice
+
+obj-$(CONFIG_INFINIBAND_IRDMA) += irdma.o
+
+irdma-objs := cm.o        \
+              ctrl.o      \
+              hmc.o       \
+              hw.o        \
+              i40iw_hw.o  \
+              i40iw_if.o  \
+              icrdma_hw.o \
+              irdma_if.o  \
+              main.o      \
+              pble.o      \
+              puda.o      \
+              trace.o     \
+              uda.o       \
+              uk.o        \
+              utils.o     \
+              verbs.o     \
+              ws.o        \
+
+CFLAGS_trace.o = -I$(src)
-- 
2.21.0

