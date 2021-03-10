Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A56333C6E
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhCJMQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbhCJMPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:15:49 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2393C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:48 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ci14so38155821ejc.7
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rODL+V/4SeAldzwyjy2MmH79zgxrn9Ck6MnNNZFGyvk=;
        b=e/yySZq9yaYv1za/CghNiDaxiXOxAPcD21jibH33BDuMtRuY98gH5ujYe0EJjwAy2D
         t6Hxe9THoTcTSQNLc/ZXgK+IZcHWVtN7lJtSVMQU1LoCnWU5UmQgCdNc5q/9UWwjm5mv
         Jce4B3wvUwpjv+qYnI5lLK7FfkT1e+di8BPA2kSmMFkSyMxaAPJoe9YtSxyRk39SZRrx
         KrOUTeJCYiN0D2KqWqArNbBPcpj2U/ID0bhGLbcuETVXdRFHD1JSDkmt3nCpsxTO0oCy
         Q3eth6mBNtJd7LlguzVEAw6wkIlo3pSYjsHyDC2Qs3oxY0NavSEACi1GgyfecfdWH/GY
         wE/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rODL+V/4SeAldzwyjy2MmH79zgxrn9Ck6MnNNZFGyvk=;
        b=LbV4BRvMd18LnFxO+nFMcRYTvaExXCmNHANFl6yjHNElbyE0zT9j676TwLXVF9vzb8
         4uxT078AXw4CUAdOE+iKxi01o35zNrEYTNAHHHmOupBwm2xihEjRB/5CwYHv3uMrKyGo
         UpfisLEjjPW4usNiyztxSAL9JzvNLv3YHxJyYAVLel+PskvvGCWuCy2XOmXhT73kbRfA
         qqS15afmW2w2XZmIWOrGvRvHqmWhNPEgGmCxoM2CGmTl4ZylqP12giR4WMn891HWxH8w
         CrDPt7c4vziMxiVvhePijh02Nu9t/YXK/ZH34mRpf2OA0S9VBZVA1dVTMLcoNemNbZN2
         I1HQ==
X-Gm-Message-State: AOAM5328UxWH1q+jAFE9xabM2wIVDkn6Y2xvRqHFdnwSsWbZUA3RRopP
        lRB9H8HcqmbMTV4lFYh/Eck=
X-Google-Smtp-Source: ABdhPJwQAB7wB0Qi/z63g6jZxjm6eJqSekfZq4XgZqGStQendIYadLO+o0I7S9tPYXQf6zT1WCfAAw==
X-Received: by 2002:a17:906:1759:: with SMTP id d25mr3374204eje.524.1615378547562;
        Wed, 10 Mar 2021 04:15:47 -0800 (PST)
Received: from yoga-910.localhost ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm4865527edw.28.2021.03.10.04.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:15:47 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 15/15] staging: dpaa2-switch: move the driver out of staging
Date:   Wed, 10 Mar 2021 14:14:52 +0200
Message-Id: <20210310121452.552070-16-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210310121452.552070-1-ciorneiioana@gmail.com>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Now that the dpaa2-switch driver has basic I/O capabilities on the
switch port net_devices and multiple bridging domains are supported,
move the driver out of staging.

The dpaa2-switch driver is placed right next to the dpaa2-eth driver
since, in the near future, they will be sharing most of the data path.
I didn't implement code reuse in this patch series because I wanted to
keep it as small as possible.

Also, the README is removed from staging with the intention to add
proper rst documentation afterwards to actually match was is supported
by the driver.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 MAINTAINERS                                   |   6 +-
 drivers/net/ethernet/freescale/dpaa2/Kconfig  |   8 ++
 drivers/net/ethernet/freescale/dpaa2/Makefile |   2 +
 .../freescale/dpaa2/dpaa2-switch-ethtool.c}   |   2 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c}  |   2 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.h}  |   0
 .../ethernet/freescale/dpaa2}/dpsw-cmd.h      |   0
 .../ethernet/freescale/dpaa2}/dpsw.c          |   0
 .../ethernet/freescale/dpaa2}/dpsw.h          |   0
 drivers/staging/Kconfig                       |   2 -
 drivers/staging/Makefile                      |   1 -
 drivers/staging/fsl-dpaa2/Kconfig             |  20 ----
 drivers/staging/fsl-dpaa2/Makefile            |   6 -
 drivers/staging/fsl-dpaa2/ethsw/Makefile      |  10 --
 drivers/staging/fsl-dpaa2/ethsw/README        | 106 ------------------
 drivers/staging/fsl-dpaa2/ethsw/TODO          |  13 ---
 16 files changed, 15 insertions(+), 163 deletions(-)
 rename drivers/{staging/fsl-dpaa2/ethsw/ethsw-ethtool.c => net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c} (99%)
 rename drivers/{staging/fsl-dpaa2/ethsw/ethsw.c => net/ethernet/freescale/dpaa2/dpaa2-switch.c} (99%)
 rename drivers/{staging/fsl-dpaa2/ethsw/ethsw.h => net/ethernet/freescale/dpaa2/dpaa2-switch.h} (100%)
 rename drivers/{staging/fsl-dpaa2/ethsw => net/ethernet/freescale/dpaa2}/dpsw-cmd.h (100%)
 rename drivers/{staging/fsl-dpaa2/ethsw => net/ethernet/freescale/dpaa2}/dpsw.c (100%)
 rename drivers/{staging/fsl-dpaa2/ethsw => net/ethernet/freescale/dpaa2}/dpsw.h (100%)
 delete mode 100644 drivers/staging/fsl-dpaa2/Kconfig
 delete mode 100644 drivers/staging/fsl-dpaa2/Makefile
 delete mode 100644 drivers/staging/fsl-dpaa2/ethsw/Makefile
 delete mode 100644 drivers/staging/fsl-dpaa2/ethsw/README
 delete mode 100644 drivers/staging/fsl-dpaa2/ethsw/TODO

diff --git a/MAINTAINERS b/MAINTAINERS
index 973a937386fa..5716e2eba8de 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5471,11 +5471,11 @@ F:	drivers/net/ethernet/freescale/dpaa2/dpmac*
 F:	drivers/net/ethernet/freescale/dpaa2/dpni*
 
 DPAA2 ETHERNET SWITCH DRIVER
-M:	Ioana Radulescu <ruxandra.radulescu@nxp.com>
 M:	Ioana Ciornei <ioana.ciornei@nxp.com>
-L:	linux-kernel@vger.kernel.org
+L:	netdev@vger.kernel.org
 S:	Maintained
-F:	drivers/staging/fsl-dpaa2/ethsw
+F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-switch*
+F:	drivers/net/ethernet/freescale/dpaa2/dpsw*
 
 DPT_I2O SCSI RAID DRIVER
 M:	Adaptec OEM Raid Solutions <aacraid@microsemi.com>
diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/ethernet/freescale/dpaa2/Kconfig
index ee7a906e30b3..d029b69c3f18 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
@@ -29,3 +29,11 @@ config FSL_DPAA2_PTP_CLOCK
 	help
 	  This driver adds support for using the DPAA2 1588 timer module
 	  as a PTP clock.
+
+config FSL_DPAA2_SWITCH
+	tristate "Freescale DPAA2 Ethernet Switch"
+	depends on BRIDGE || BRIDGE=n
+	depends on NET_SWITCHDEV
+	help
+	  Driver for Freescale DPAA2 Ethernet Switch. This driver manages
+	  switch objects discovered on the Freeescale MC bus.
diff --git a/drivers/net/ethernet/freescale/dpaa2/Makefile b/drivers/net/ethernet/freescale/dpaa2/Makefile
index 146cb3540e61..644ef9ae02a3 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Makefile
+++ b/drivers/net/ethernet/freescale/dpaa2/Makefile
@@ -5,11 +5,13 @@
 
 obj-$(CONFIG_FSL_DPAA2_ETH)		+= fsl-dpaa2-eth.o
 obj-$(CONFIG_FSL_DPAA2_PTP_CLOCK)	+= fsl-dpaa2-ptp.o
+obj-$(CONFIG_FSL_DPAA2_SWITCH)		+= fsl-dpaa2-switch.o
 
 fsl-dpaa2-eth-objs	:= dpaa2-eth.o dpaa2-ethtool.o dpni.o dpaa2-mac.o dpmac.o dpaa2-eth-devlink.o
 fsl-dpaa2-eth-${CONFIG_FSL_DPAA2_ETH_DCB} += dpaa2-eth-dcb.o
 fsl-dpaa2-eth-${CONFIG_DEBUG_FS} += dpaa2-eth-debugfs.o
 fsl-dpaa2-ptp-objs	:= dpaa2-ptp.o dprtc.o
+fsl-dpaa2-switch-objs	:= dpaa2-switch.o dpaa2-switch-ethtool.o dpsw.o
 
 # Needed by the tracing framework
 CFLAGS_dpaa2-eth.o := -I$(src)
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
similarity index 99%
rename from drivers/staging/fsl-dpaa2/ethsw/ethsw-ethtool.c
rename to drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
index 0af2e9914ec4..70e04321c420 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
@@ -9,7 +9,7 @@
 
 #include <linux/ethtool.h>
 
-#include "ethsw.h"
+#include "dpaa2-switch.h"
 
 static struct {
 	enum dpsw_counter id;
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
similarity index 99%
rename from drivers/staging/fsl-dpaa2/ethsw/ethsw.c
rename to drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 97292cf570c1..2fd05dd18d46 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -17,7 +17,7 @@
 
 #include <linux/fsl/mc.h>
 
-#include "ethsw.h"
+#include "dpaa2-switch.h"
 
 /* Minimal supported DPSW version */
 #define DPSW_MIN_VER_MAJOR		8
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
similarity index 100%
rename from drivers/staging/fsl-dpaa2/ethsw/ethsw.h
rename to drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
similarity index 100%
rename from drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
rename to drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
similarity index 100%
rename from drivers/staging/fsl-dpaa2/ethsw/dpsw.c
rename to drivers/net/ethernet/freescale/dpaa2/dpsw.c
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
similarity index 100%
rename from drivers/staging/fsl-dpaa2/ethsw/dpsw.h
rename to drivers/net/ethernet/freescale/dpaa2/dpsw.h
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index b22f73d7bfc4..6e798229fe25 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -78,8 +78,6 @@ source "drivers/staging/clocking-wizard/Kconfig"
 
 source "drivers/staging/fbtft/Kconfig"
 
-source "drivers/staging/fsl-dpaa2/Kconfig"
-
 source "drivers/staging/most/Kconfig"
 
 source "drivers/staging/ks7010/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 2245059e69c7..8d4d9812ecdf 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -29,7 +29,6 @@ obj-$(CONFIG_GS_FPGABOOT)	+= gs_fpgaboot/
 obj-$(CONFIG_UNISYSSPAR)	+= unisys/
 obj-$(CONFIG_COMMON_CLK_XLNX_CLKWZRD)	+= clocking-wizard/
 obj-$(CONFIG_FB_TFT)		+= fbtft/
-obj-$(CONFIG_FSL_DPAA2)		+= fsl-dpaa2/
 obj-$(CONFIG_MOST)		+= most/
 obj-$(CONFIG_KS7010)		+= ks7010/
 obj-$(CONFIG_GREYBUS)		+= greybus/
diff --git a/drivers/staging/fsl-dpaa2/Kconfig b/drivers/staging/fsl-dpaa2/Kconfig
deleted file mode 100644
index 7cb005b6e7ab..000000000000
--- a/drivers/staging/fsl-dpaa2/Kconfig
+++ /dev/null
@@ -1,20 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-#
-# Freescale DataPath Acceleration Architecture Gen2 (DPAA2) drivers
-#
-
-config FSL_DPAA2
-	bool "Freescale DPAA2 devices"
-	depends on FSL_MC_BUS
-	help
-	  Build drivers for Freescale DataPath Acceleration
-	  Architecture (DPAA2) family of SoCs.
-
-config FSL_DPAA2_ETHSW
-	tristate "Freescale DPAA2 Ethernet Switch"
-	depends on BRIDGE || BRIDGE=n
-	depends on FSL_DPAA2
-	depends on NET_SWITCHDEV
-	help
-	  Driver for Freescale DPAA2 Ethernet Switch. Select
-	  BRIDGE to have support for bridge tools.
diff --git a/drivers/staging/fsl-dpaa2/Makefile b/drivers/staging/fsl-dpaa2/Makefile
deleted file mode 100644
index 9645db7689c9..000000000000
--- a/drivers/staging/fsl-dpaa2/Makefile
+++ /dev/null
@@ -1,6 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-#
-# Freescale DataPath Acceleration Architecture Gen2 (DPAA2) drivers
-#
-
-obj-$(CONFIG_FSL_DPAA2_ETHSW)		+= ethsw/
diff --git a/drivers/staging/fsl-dpaa2/ethsw/Makefile b/drivers/staging/fsl-dpaa2/ethsw/Makefile
deleted file mode 100644
index f6f2cf798faf..000000000000
--- a/drivers/staging/fsl-dpaa2/ethsw/Makefile
+++ /dev/null
@@ -1,10 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-#
-# Makefile for the Freescale DPAA2 Ethernet Switch
-#
-# Copyright 2014-2017 Freescale Semiconductor Inc.
-# Copyright 2017-2018 NXP
-
-obj-$(CONFIG_FSL_DPAA2_ETHSW) += dpaa2-ethsw.o
-
-dpaa2-ethsw-objs := ethsw.o ethsw-ethtool.o dpsw.o
diff --git a/drivers/staging/fsl-dpaa2/ethsw/README b/drivers/staging/fsl-dpaa2/ethsw/README
deleted file mode 100644
index b48dcbf7c5fb..000000000000
--- a/drivers/staging/fsl-dpaa2/ethsw/README
+++ /dev/null
@@ -1,106 +0,0 @@
-DPAA2 Ethernet Switch driver
-============================
-
-This file provides documentation for the DPAA2 Ethernet Switch driver
-
-
-Contents
-========
-	Supported Platforms
-	Architecture Overview
-	Creating an Ethernet Switch
-	Features
-
-
-	Supported Platforms
-===================
-This driver provides networking support for Freescale LS2085A, LS2088A
-DPAA2 SoCs.
-
-
-Architecture Overview
-=====================
-The Ethernet Switch in the DPAA2 architecture consists of several hardware
-resources that provide the functionality. These are allocated and
-configured via the Management Complex (MC) portals. MC abstracts most of
-these resources as DPAA2 objects and exposes ABIs through which they can
-be configured and controlled.
-
-For a more detailed description of the DPAA2 architecture and its object
-abstractions see:
-	drivers/staging/fsl-mc/README.txt
-
-The Ethernet Switch is built on top of a Datapath Switch (DPSW) object.
-
-Configuration interface:
-
-          ---------------------
-         | DPAA2 Switch driver |
-          ---------------------
-                   .
-                   .
-              ----------
-             | DPSW API |
-              ----------
-                   .           software
- ================= . ==============
-                   .           hardware
-          ---------------------
-         | MC hardware portals |
-          ---------------------
-                   .
-                   .
-                 ------
-                | DPSW |
-                 ------
-
-Driver uses the switch device driver model and exposes each switch port as
-a network interface, which can be included in a bridge. Traffic switched
-between ports is offloaded into the hardware. Exposed network interfaces
-are not used for I/O, they are used just for configuration. This
-limitation is going to be addressed in the future.
-
-The DPSW can have ports connected to DPNIs or to PHYs via DPMACs.
-
-
- [ethA]     [ethB]     [ethC]     [ethD]     [ethE]     [ethF]
-    :          :          :          :          :          :
-    :          :          :          :          :          :
-[eth drv]  [eth drv]  [                ethsw drv              ]
-    :          :          :          :          :          :        kernel
-========================================================================
-    :          :          :          :          :          :        hardware
- [DPNI]      [DPNI]     [============= DPSW =================]
-    |          |          |          |          |          |
-    |           ----------           |       [DPMAC]    [DPMAC]
-     -------------------------------            |          |
-                                                |          |
-                                              [PHY]      [PHY]
-
-For a more detailed description of the Ethernet switch device driver model
-see:
-	Documentation/networking/switchdev.rst
-
-Creating an Ethernet Switch
-===========================
-A device is created for the switch objects probed on the MC bus. Each DPSW
-has a number of properties which determine the configuration options and
-associated hardware resources.
-
-A DPSW object (and the other DPAA2 objects needed for a DPAA2 switch) can
-be added to a container on the MC bus in one of two ways: statically,
-through a Datapath Layout Binary file (DPL) that is parsed by MC at boot
-time; or created dynamically at runtime, via the DPAA2 objects APIs.
-
-Features
-========
-Driver configures DPSW to perform hardware switching offload of
-unicast/multicast/broadcast (VLAN tagged or untagged) traffic between its
-ports.
-
-It allows configuration of hardware learning, flooding, multicast groups,
-port VLAN configuration and STP state.
-
-Static entries can be added/removed from the FDB.
-
-Hardware statistics for each port are provided through ethtool -S option.
diff --git a/drivers/staging/fsl-dpaa2/ethsw/TODO b/drivers/staging/fsl-dpaa2/ethsw/TODO
deleted file mode 100644
index 4d46857b0b2b..000000000000
--- a/drivers/staging/fsl-dpaa2/ethsw/TODO
+++ /dev/null
@@ -1,13 +0,0 @@
-* Add I/O capabilities on switch port netdevices. This will allow control
-traffic to reach the CPU.
-* Add ACL to redirect control traffic to CPU.
-* Add support for multiple FDBs and switch port partitioning
-* MC firmware uprev; the DPAA2 objects used by the Ethernet Switch driver
-need to be kept in sync with binary interface changes in MC
-* refine README file
-* cleanup
-
-NOTE: At least first three of the above are required before getting the
-DPAA2 Ethernet Switch driver out of staging. Another requirement is that
-dpio driver is moved to drivers/soc (this is required for I/O).
-
-- 
2.30.0

