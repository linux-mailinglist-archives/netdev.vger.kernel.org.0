Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E370A216110
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 23:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgGFVxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 17:53:44 -0400
Received: from mga12.intel.com ([192.55.52.136]:40380 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgGFVxo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 17:53:44 -0400
IronPort-SDR: MCU2CqY0yJWREbC4uPZfn6K2k+PMxrjKOwCV984mw3Iz5EhxnIsa0tnSgS1sTqi0ltmseV/lcJ
 mELx6cFhn/UQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="127100599"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="127100599"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 14:53:43 -0700
IronPort-SDR: O8qhlCNex8nBGwIpLjgbTW+UbnpASGhfsoRRs1QNlrlN4C3tpwgM0kBAwPNURyWRx78F0IQz/S
 nHFkABbA+UyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="283173376"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by orsmga006.jf.intel.com with ESMTP; 06 Jul 2020 14:53:43 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next] ice: add documentation for device-caps region
Date:   Mon,  6 Jul 2020 14:53:41 -0700
Message-Id: <20200706215341.1354720-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.27.0.353.gb9a2d1a0207f
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recent change by commit 8d7aab3515fa ("ice: implement snapshot for
device capabilities") to implement the device-caps region for the ice
driver forgot to document it.

Add documentation to the ice devlink documentation file describing the
new region and add some sample output to the shell commands provided as
an example.

Fixes: 8d7aab3515fa ("ice: implement snapshot for device capabilities")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 Documentation/networking/devlink/ice.rst | 55 +++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index 72ea8d295724..237848d56f9b 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -84,8 +84,20 @@ The ``ice`` driver reports the following versions
 Regions
 =======
 
-The ``ice`` driver enables access to the contents of the Non Volatile Memory
-flash chip via the ``nvm-flash`` region.
+The ``ice`` driver implements the following regions for accessing internal
+device data.
+
+.. list-table:: regions implemented
+    :widths: 15 85
+
+    * - Name
+      - Description
+    * - ``nvm-flash``
+      - The contents of the entire flash chip, sometimes referred to as
+        the device's Non Volatile Memory.
+    * - ``device-caps``
+      - The contents of the device firmware's capabilities buffer. Useful to
+        determine the current state and configuration of the device.
 
 Users can request an immediate capture of a snapshot via the
 ``DEVLINK_CMD_REGION_NEW``
@@ -105,3 +117,42 @@ Users can request an immediate capture of a snapshot via the
     0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
 
     $ devlink region delete pci/0000:01:00.0/nvm-flash snapshot 1
+
+    $ devlink region new pci/0000:01:00.0/device-caps snapshot 1
+    $ devlink region dump pci/0000:01:00.0/device-caps snapshot 1
+    0000000000000000 01 00 01 00 00 00 00 00 01 00 00 00 00 00 00 00
+    0000000000000010 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+    0000000000000020 02 00 02 01 32 03 00 00 0a 00 00 00 25 00 00 00
+    0000000000000030 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+    0000000000000040 04 00 01 00 01 00 00 00 00 00 00 00 00 00 00 00
+    0000000000000050 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+    0000000000000060 05 00 01 00 03 00 00 00 00 00 00 00 00 00 00 00
+    0000000000000070 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+    0000000000000080 06 00 01 00 01 00 00 00 00 00 00 00 00 00 00 00
+    0000000000000090 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+    00000000000000a0 08 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
+    00000000000000b0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+    00000000000000c0 12 00 01 00 01 00 00 00 01 00 01 00 00 00 00 00
+    00000000000000d0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+    00000000000000e0 13 00 01 00 00 01 00 00 00 00 00 00 00 00 00 00
+    00000000000000f0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+    0000000000000100 14 00 01 00 01 00 00 00 00 00 00 00 00 00 00 00
+    0000000000000110 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+    0000000000000120 15 00 01 00 01 00 00 00 00 00 00 00 00 00 00 00
+    0000000000000130 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+    0000000000000140 16 00 01 00 01 00 00 00 00 00 00 00 00 00 00 00
+    0000000000000150 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+    0000000000000160 17 00 01 00 06 00 00 00 00 00 00 00 00 00 00 00
+    0000000000000170 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+    0000000000000180 18 00 01 00 01 00 00 00 01 00 00 00 08 00 00 00
+    0000000000000190 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+    00000000000001a0 22 00 01 00 01 00 00 00 00 00 00 00 00 00 00 00
+    00000000000001b0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+    00000000000001c0 40 00 01 00 00 08 00 00 08 00 00 00 00 00 00 00
+    00000000000001d0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+    00000000000001e0 41 00 01 00 00 08 00 00 00 00 00 00 00 00 00 00
+    00000000000001f0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+    0000000000000200 42 00 01 00 00 08 00 00 00 00 00 00 00 00 00 00
+    0000000000000210 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+
+    $ devlink region delete pci/0000:01:00.0/device-caps snapshot 1
-- 
2.27.0.353.gb9a2d1a0207f

