Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3D66136365
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgAIWqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:46:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:46855 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728962AbgAIWql (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 17:46:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 14:46:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="421926831"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2020 14:46:41 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 05/17] devlink: convert devlink-params.txt to reStructuredText
Date:   Thu,  9 Jan 2020 14:46:13 -0800
Message-Id: <20200109224625.1470433-6-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109224625.1470433-1-jacob.e.keller@intel.com>
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the generic parameters descriptions into the reStructuredText
format.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../networking/devlink/devlink-params.rst     | 90 +++++++++++++++++++
 .../networking/devlink/devlink-params.txt     | 71 ---------------
 Documentation/networking/devlink/index.rst    |  1 +
 3 files changed, 91 insertions(+), 71 deletions(-)
 create mode 100644 Documentation/networking/devlink/devlink-params.rst
 delete mode 100644 Documentation/networking/devlink/devlink-params.txt

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
new file mode 100644
index 000000000000..b51b91f807f7
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -0,0 +1,90 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+Devlink Params
+==============
+
+``devlink`` provides capability for a driver to expose device parameters for low
+level device functionality. Since devlink can operate at the device-wide
+level, it can be used to provide configuration that may affect multiple
+ports on a single device.
+
+This document describes a number of generic parameters that are supported
+across multiple drivers. Each driver is also free to add their own
+parameters. Each driver must document the specific parameters they support,
+whether generic or not.
+
+Configuration modes
+===================
+
+Parameters may be set in different configuration modes.
+
+.. list-table:: Possible configuration modes
+   :widths: 5 90
+
+   * - Name
+     - Description
+   * - ``runtime``
+     - set while the driver is running, and takes effect immediately. No
+       reset is required.
+   * - ``driverinit``
+     - applied while the driver initializes. Requires the user to restart
+       the driver using the ``devlink`` reload command.
+   * - ``permanent``
+     - written to the device's non-volatile memory. A hard reset is required
+       for it to take effect.
+
+Generic configuration parameters
+================================
+The following is a list of generic configuration parameters that drivers may
+add. Use of generic parameters is preferred over each driver creating their
+own name.
+
+.. list-table:: List of generic parameters
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``enable_sriov``
+     - Boolean
+     - Enable Single Root I/O Virtualization (SRIOV) in the device.
+   * - ``ignore_ari``
+     - Boolean
+     - Ignore Alternative Routing-ID Interpretation (ARI) capability. If
+       enabled, the adapter will ignore ARI capability even when the
+       platform has support enabled. The device will create the same number
+       of partitions as when the platform does not support ARI.
+   * - ``msix_vec_per_pf_max``
+     - u32
+     - Provides the maximum number of MSI-X interrupts that a device can
+       create. Value is the same across all physical functions (PFs) in the
+       device.
+   * - ``msix_vec_per_pf_min``
+     - u32
+     - Provides the minimum number of MSI-X interrupts required for the
+       device to initialize. Value is the same across all physical functions
+       (PFs) in the device.
+   * - ``fw_load_policy``
+     - u8
+     - Control the device's firmware loading policy.
+        - ``DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DRIVER`` (0)
+          Load firmware version preferred by the driver.
+        - ``DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_FLASH`` (1)
+          Load firmware currently stored in flash.
+        - ``DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK`` (2)
+          Load firmware currently available on host's disk.
+   * - ``reset_dev_on_drv_probe``
+     - u8
+     - Controls the device's reset policy on driver probe.
+        - ``DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_UNKNOWN`` (0)
+          Unknown or invalid value.
+        - ``DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_ALWAYS`` (1)
+          Always reset device on driver probe.
+        - ``DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_NEVER`` (2)
+          Never reset device on driver probe.
+        - ``DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_DISK`` (3)
+          Reset the device only if firmware can be found in the filesystem.
+   * - ``enable_roce``
+     - Boolean
+     - Enable handling of RoCE traffic in the device.
diff --git a/Documentation/networking/devlink/devlink-params.txt b/Documentation/networking/devlink/devlink-params.txt
deleted file mode 100644
index 04e234e9acc9..000000000000
--- a/Documentation/networking/devlink/devlink-params.txt
+++ /dev/null
@@ -1,71 +0,0 @@
-Devlink configuration parameters
-================================
-Following is the list of configuration parameters via devlink interface.
-Each parameter can be generic or driver specific and are device level
-parameters.
-
-Note that the driver-specific files should contain the generic params
-they support to, with supported config modes.
-
-Each parameter can be set in different configuration modes:
-	runtime		- set while driver is running, no reset required.
-	driverinit	- applied while driver initializes, requires restart
-			driver by devlink reload command.
-	permanent	- written to device's non-volatile memory, hard reset
-			required.
-
-Following is the list of parameters:
-====================================
-enable_sriov		[DEVICE, GENERIC]
-			Enable Single Root I/O Virtualisation (SRIOV) in
-			the device.
-			Type: Boolean
-
-ignore_ari		[DEVICE, GENERIC]
-			Ignore Alternative Routing-ID Interpretation (ARI)
-			capability. If enabled, adapter will ignore ARI
-			capability even when platforms has the support
-			enabled and creates same number of partitions when
-			platform does not support ARI.
-			Type: Boolean
-
-msix_vec_per_pf_max	[DEVICE, GENERIC]
-			Provides the maximum number of MSIX interrupts that
-			a device can create. Value is same across all
-			physical functions (PFs) in the device.
-			Type: u32
-
-msix_vec_per_pf_min	[DEVICE, GENERIC]
-			Provides the minimum number of MSIX interrupts required
-			for the device initialization. Value is same across all
-			physical functions (PFs) in the device.
-			Type: u32
-
-fw_load_policy		[DEVICE, GENERIC]
-			Controls the device's firmware loading policy.
-			Valid values:
-			* DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DRIVER (0)
-			  Load firmware version preferred by the driver.
-			* DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_FLASH (1)
-			  Load firmware currently stored in flash.
-			* DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK (2)
-			  Load firmware currently available on host's disk.
-			Type: u8
-
-reset_dev_on_drv_probe	[DEVICE, GENERIC]
-			Controls the device's reset policy on driver probe.
-			Valid values:
-			* DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_UNKNOWN (0)
-			  Unknown or invalid value.
-			* DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_ALWAYS (1)
-			  Always reset device on driver probe.
-			* DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_NEVER (2)
-			  Never reset device on driver probe.
-			* DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_DISK (3)
-			  Reset only if device firmware can be found in the
-			  filesystem.
-			Type: u8
-
-enable_roce		[DEVICE, GENERIC]
-			Enable handling of RoCE traffic in the device.
-			Type: Boolean
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 687bb6e51fca..ae3f20919d22 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -11,5 +11,6 @@ Contents:
 
    devlink-health
    devlink-info
+   devlink-params
    devlink-trap
    devlink-trap-netdevsim
-- 
2.25.0.rc1

