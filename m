Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCA514E5CE
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 00:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbgA3W7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:59:42 -0500
Received: from mga12.intel.com ([192.55.52.136]:51511 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727657AbgA3W70 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 17:59:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 14:59:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="430187832"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2020 14:59:24 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 15/15] ice: add ice.rst devlink documentation file
Date:   Thu, 30 Jan 2020 14:59:10 -0800
Message-Id: <20200130225913.1671982-16-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200130225913.1671982-1-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the ice driver has gained some devlink support, add
a driver-specific documentation file for it.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 Documentation/networking/devlink/ice.rst   | 76 ++++++++++++++++++++++
 Documentation/networking/devlink/index.rst |  1 +
 2 files changed, 77 insertions(+)
 create mode 100644 Documentation/networking/devlink/ice.rst

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
new file mode 100644
index 000000000000..c27b49311afe
--- /dev/null
+++ b/Documentation/networking/devlink/ice.rst
@@ -0,0 +1,76 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================
+ice devlink support
+===================
+
+This document describes the devlink features implemented by the ``ice``
+device driver.
+
+Info versions
+=============
+
+The ``ice`` driver reports the following versions
+
+.. list-table:: devlink info versions implemented
+    :widths: 5 5 90
+
+    * - Name
+      - Type
+      - Description
+    * - ``driver.version``
+      - fixed
+      - Device driver version as reported by ``ETHTOOL_GDRVINFO``
+    * - ``board.id``
+      - fixed
+      - The Product Board Assembly (PBA) identifier of the board
+    * - ``fw``
+      - running
+      - Combined flash version string as reported by ``ETHTOOL_GDRVINFO``
+    * - ``fw.mgmt``
+      - running
+      - 3-digit overall firmware version
+    * - ``fw.api``
+      - running
+      - 2-digit firmware API version
+    * - ``fw.build``
+      - running
+      - firmware build identifier
+    * - ``nvm.version``
+      - running
+      - NVM format version
+    * - ``nvm.oem``
+      - running
+      - Original Equipment Manufacturer (OEM) version information
+    * - ``nvm.eetrack``
+      - running
+      - Unique NVM EETRACK identifier
+
+
+Regions
+=======
+
+The ``ice`` driver enables access to the contents of the Shadow RAM portion
+of the flash chip via the ``shadow-ram`` region.
+
+Users can request an immediate capture of a snapshot via the
+``DEVLINK_CMD_REGION_TAKE_SNAPSHOT``
+
+.. code:: shell
+
+    $ devlink region snapshot pci/0000:01:00.0/shadow-ram
+    $ devlink region dump pci/0000:01:00.0/shadow-ram snapshot 1
+
+Directly reading a portion of the Shadow RAM without a snapshot is also
+supported
+
+.. code:: shell
+
+    $ devlink region dump pci/0000:01:00.0/shadow-ram
+    0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
+    0000000000000010 0000 0000 ffff ff04 0029 8c00 0028 8cc8
+    0000000000000020 0016 0bb8 0016 1720 0000 0000 c00f 3ffc
+    0000000000000030 bada cce5 bada cce5 bada cce5 bada cce5
+
+    $ devlink region read pci/0000:01:00.0/shadow-ram address 0 length 16
+    0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 087ff54d53fc..272509cd9215 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -32,6 +32,7 @@ parameters, info versions, and other features it supports.
 
    bnxt
    ionic
+   ice
    mlx4
    mlx5
    mlxsw
-- 
2.25.0.rc1

