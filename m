Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B356E13636B
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgAIWqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:46:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:46889 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729299AbgAIWqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 17:46:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 14:46:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="421926877"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2020 14:46:50 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 14/17] devlink: rename and expand devlink-trap-netdevsim.rst
Date:   Thu,  9 Jan 2020 14:46:22 -0800
Message-Id: <20200109224625.1470433-15-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109224625.1470433-1-jacob.e.keller@intel.com>
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the trap-specific netdevimsim.rst file, and expand it to include
documentation of all the devlink features currently implemented by the
netdevsim driver code.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../devlink/devlink-trap-netdevsim.rst        | 20 ------
 .../networking/devlink/devlink-trap.rst       |  2 +-
 Documentation/networking/devlink/index.rst    |  2 +-
 .../networking/devlink/netdevsim.rst          | 72 +++++++++++++++++++
 drivers/net/netdevsim/dev.c                   |  2 +-
 5 files changed, 75 insertions(+), 23 deletions(-)
 delete mode 100644 Documentation/networking/devlink/devlink-trap-netdevsim.rst
 create mode 100644 Documentation/networking/devlink/netdevsim.rst

diff --git a/Documentation/networking/devlink/devlink-trap-netdevsim.rst b/Documentation/networking/devlink/devlink-trap-netdevsim.rst
deleted file mode 100644
index b721c9415473..000000000000
--- a/Documentation/networking/devlink/devlink-trap-netdevsim.rst
+++ /dev/null
@@ -1,20 +0,0 @@
-.. SPDX-License-Identifier: GPL-2.0
-
-======================
-Devlink Trap netdevsim
-======================
-
-Driver-specific Traps
-=====================
-
-.. list-table:: List of Driver-specific Traps Registered by ``netdevsim``
-   :widths: 5 5 90
-
-   * - Name
-     - Type
-     - Description
-   * - ``fid_miss``
-     - ``exception``
-     - When a packet enters the device it is classified to a filtering
-       indentifier (FID) based on the ingress port and VLAN. This trap is used
-       to trap packets for which a FID could not be found
diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index 03311849bfb1..cbaa750de37d 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -233,7 +233,7 @@ help debug packet drops caused by these exceptions. The following list includes
 links to the description of driver-specific traps registered by various device
 drivers:
 
-  * :doc:`devlink-trap-netdevsim`
+  * :doc:`netdevsim`
 
 Generic Packet Trap Groups
 ==========================
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index ce0ee563d83a..2417d56e27cc 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -18,7 +18,6 @@ general.
    devlink-params
    devlink-region
    devlink-trap
-   devlink-trap-netdevsim
 
 Driver-specific documentation
 -----------------------------
@@ -35,6 +34,7 @@ parameters, info versions, and other features it supports.
    mlx5
    mlxsw
    mv88e6xxx
+   netdevsim
    nfp
    qed
    ti-cpsw-switch
diff --git a/Documentation/networking/devlink/netdevsim.rst b/Documentation/networking/devlink/netdevsim.rst
new file mode 100644
index 000000000000..2a266b7e7b38
--- /dev/null
+++ b/Documentation/networking/devlink/netdevsim.rst
@@ -0,0 +1,72 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+netdevsim devlink support
+=========================
+
+This document describes the ``devlink`` features supported by the
+``netdevsim`` device driver.
+
+Parameters
+==========
+
+.. list-table:: Generic parameters implemented
+
+   * - Name
+     - Mode
+   * - ``max_macs``
+     - driverinit
+
+The ``netdevsim`` driver also implements the following driver-specific
+parameters.
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``test1``
+     - Boolean
+     - driverinit
+     - Test parameter used to show how a driver-specific devlink parameter
+       can be implemented.
+
+The ``netdevsim`` driver supports reloading via ``DEVLINK_CMD_RELOAD``
+
+Regions
+=======
+
+The ``netdevsim`` driver exposes a ``dummy`` region as an example of how the
+devlink-region interfaces work. A snapshot is taken whenever the
+``take_snapshot`` debugfs file is written to.
+
+Resources
+=========
+
+The ``netdevsim`` driver exposes resources to control the number of FIB
+entries and FIB rule entries that the driver will allow.
+
+.. code:: shell
+
+    $ devlink resource set netdevsim/netdevsim0 path /IPv4/fib size 96
+    $ devlink resource set netdevsim/netdevsim0 path /IPv4/fib-rules size 16
+    $ devlink resource set netdevsim/netdevsim0 path /IPv6/fib size 64
+    $ devlink resource set netdevsim/netdevsim0 path /IPv6/fib-rules size 16
+    $ devlink dev reload netdevsim/netdevsim0
+
+Driver-specific Traps
+=====================
+
+.. list-table:: List of Driver-specific Traps Registered by ``netdevsim``
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``fid_miss``
+     - ``exception``
+     - When a packet enters the device it is classified to a filtering
+       indentifier (FID) based on the ingress port and VLAN. This trap is used
+       to trap packets for which a FID could not be found
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 2eb4ca564745..97922f9834a7 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -287,7 +287,7 @@ struct nsim_trap_data {
 };
 
 /* All driver-specific traps must be documented in
- * Documentation/networking/devlink/devlink-trap-netdevsim.rst
+ * Documentation/networking/devlink/netdevsim.rst
  */
 enum {
 	NSIM_TRAP_ID_BASE = DEVLINK_TRAP_GENERIC_ID_MAX,
-- 
2.25.0.rc1

