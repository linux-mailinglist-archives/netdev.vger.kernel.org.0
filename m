Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A093645093
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiLGAp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiLGAp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:45:26 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2050.outbound.protection.outlook.com [40.107.102.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A67C4E6B7
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 16:45:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bIdCUQ+zPIhsCUcsJMrZdaZPMpuTJLCuD2LjRttDtXwwXKZ8FBYpWOiGmJ0HY/zWSriFyFiQwKm38QzrIYsp3X6a3WQIzK8N8H2pdboG1JN16hHTq2OJwKJZvb6pP9esw0pHqVKzHTwqQb97tsPi2TUp1VpDYXvZ2wOxSh8gkGg4NXcwBA7z/9LMAe0zBr8rhZV4xxOzjrDPK+lSsRrhUOaY7UI0iObMAwkFPeVbbdDGI0Ow7eHXWmLG1Edqy5AHXkMmxq4dbVdRFJ+QD/Hvs7ieQ8yXod2h86WATEM5wX5EYaPzbsAUa/OPCD6MGrE4KnMxtiZCyczDt3rSo7KMoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mHoSRqEdWpWxyycEQB0jkDSIyCq6qX88t+2U92PHpNE=;
 b=ZZ8O9H8RrSF/tOYUJqBWm4zP7Yv/c2uDNbl3zdgrEpwueMQIs9QLPmuMj7RvQBBDPLYHugcomJP2wa0h/5bJQBI7ULBzDMlsZfvuvIKkgm6tZgeD0vsSWcGUj8hoqfb7qbcF53XOvZKzRk2jWgV6/ucW6vG+PaZ3UN691PrRQ1gHRnkwL+ylNMHQSHkDPIccbgeq4Ajjy4Yx+XlAWQFxB2ZGOCGqPSJKPnvfNFbcpb9Zsf3+fnfptvsTaayG/9wQCC9K6r/KKlkJeKyBKs9iO/FRYZMt7nZl6Wn2fWkyLeTCNTzKnz3pBtTSc8c21zeHv8Qhu3gVr0LGa21afP8rAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHoSRqEdWpWxyycEQB0jkDSIyCq6qX88t+2U92PHpNE=;
 b=VzqwPwy5o9VBA8moHocVITapDSGeHjN7EDi0WLbONSIiijqE3gMOBrBku6+FkZfbU1mOd6t0MZ8lttA2IBUmPRcuIQ+kaVryqSn22GasokZvmCRd9FEGNTyYS1W8cUh6RpK0I16PXB1uEKXEbvPI2FRud6AuCw4xJugk7w8IrRI=
Received: from BN9PR03CA0144.namprd03.prod.outlook.com (2603:10b6:408:fe::29)
 by SJ0PR12MB5454.namprd12.prod.outlook.com (2603:10b6:a03:304::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 00:45:17 +0000
Received: from BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::58) by BN9PR03CA0144.outlook.office365.com
 (2603:10b6:408:fe::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 00:45:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT073.mail.protection.outlook.com (10.13.177.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 00:45:16 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 18:45:15 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net-next 16/16] pds_core: Kconfig and pds_core.rst
Date:   Tue, 6 Dec 2022 16:44:43 -0800
Message-ID: <20221207004443.33779-17-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221207004443.33779-1-shannon.nelson@amd.com>
References: <20221207004443.33779-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT073:EE_|SJ0PR12MB5454:EE_
X-MS-Office365-Filtering-Correlation-Id: 08dbada8-3e72-442d-2a52-08dad7ec4f5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gtaSi6B2AmK4L6eP1VY/og0eXsgyp3a8yAZb22s/fRF5WEwbA+btfKpeOMkB1NonTuwgaVpDjDz2coQIrWjITXQdSES9zf6f2JpsBqONmlPEfYUV7F3AlK8bNYs7GHru50RD88xHmFO22cdO9rwwm+wBf6RzKuN/4mAKin/98W3kyIFX2M1Z4CR0DGX3jVNvAn4VlmVi+04oRwpwnjzKHsQGbUTp/eKlSnPu/54Zo2rOHqronfhpPR3spAmyxgPHRRxpLJDBglAH6tUqRVWvAI55b5Y9N1YqH4zTZymwbqIshLxlSdlNDiaZXqztxrmLCZClKi0fYmPEQPEa6vsQ+46NKpq/QfsQAc6gtyen+UrlFf6/k5Z1QVUCiOs/gcsd6N0vQczT3DkgfSpzSwHF3fjUCrVmnrRCHyW3TrjvhBkrs8lsO+NSicPWNCFDfeW3yMfP6GYP9cGODlnzCqwHFuffSowJ9IgaccdmMGP/L0k1RgEofrMHNlkd+ySzlDhYKJImBCdO1Liof6XjOwUvkSh6eu6eKf1HpV35dG4CFFPXN3k3KWO6M0j83CZoaE6YYpJI+ZA9eN1nYBhkYGDzkbwe8glWrdHTjG8o32qzn7n5i1VY7uchlwze68VtMkKy/1jMfF9ZiGTWaP/VdKI5SxIKGwKTkrILomKcs8iJ+8G/tczyZPdfIutN3M8iTSQPHeMRVjJVe/vJE8nufBM29DwwM/M9fdj1kU+Gyhp8N1jE98xGsUOvI11Aeq0MzFp7/DWOT03K88sBsNIAk2S7jw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199015)(46966006)(36840700001)(40470700004)(36860700001)(83380400001)(86362001)(81166007)(356005)(82740400003)(5660300002)(2906002)(40460700003)(4326008)(41300700001)(8936002)(44832011)(8676002)(82310400005)(6666004)(43170500006)(40480700001)(26005)(47076005)(186003)(426003)(1076003)(336012)(16526019)(54906003)(316002)(110136005)(2616005)(70206006)(70586007)(478600001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 00:45:16.9702
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08dbada8-3e72-442d-2a52-08dad7ec4f5e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5454
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation and Kconfig hook for building the driver.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../ethernet/pensando/pds_core.rst            | 159 ++++++++++++++++++
 MAINTAINERS                                   |   3 +-
 drivers/net/ethernet/pensando/Kconfig         |  12 ++
 3 files changed, 173 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/networking/device_drivers/ethernet/pensando/pds_core.rst

diff --git a/Documentation/networking/device_drivers/ethernet/pensando/pds_core.rst b/Documentation/networking/device_drivers/ethernet/pensando/pds_core.rst
new file mode 100644
index 000000000000..95424e8ba1fb
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/pensando/pds_core.rst
@@ -0,0 +1,159 @@
+.. SPDX-License-Identifier: GPL-2.0+
+
+========================================================
+Linux Driver for the Pensando(R) DSC adapter family
+========================================================
+
+Pensando Linux Core driver
+Copyright(c) 2022 Pensando Systems, Inc
+
+Identifying the Adapter
+=======================
+
+To find if one or more Pensando PCI Core devices are installed on the
+host, check for the PCI devices::
+
+  # lspci -d 1dd8:100c
+  39:00.0 Processing accelerators: Pensando Systems Device 100c
+  3a:00.0 Processing accelerators: Pensando Systems Device 100c
+
+If such devices are listed as above, then the pds_core.ko driver should find
+and configure them for use.  There should be log entries in the kernel
+messages such as these::
+
+  $ dmesg | grep pds_core
+  pds_core 0000:b5:00.0: 126.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
+  pds_core 0000:b5:00.0: FW: 1.51.0-73
+  pds_core 0000:b6:00.0: 126.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
+  pds_core 0000:b5:00.0: FW: 1.51.0-73
+
+Driver and firmware version information can be gathered with devlink::
+
+  $ devlink dev info pci/0000:b5:00.0
+  pci/0000:b5:00.0:
+    driver pds_core
+    serial_number FLM18420073
+    versions:
+        fixed:
+          asic.id 0x0
+          asic.rev 0x0
+        running:
+          fw 1.51.0-73
+        stored:
+          fw.goldfw 1.15.9-C-22
+          fw.mainfwa 1.51.0-73
+          fw.mainfwb 1.51.0-57
+
+
+Info versions
+=============
+
+The ``pds_core`` driver reports the following versions
+
+.. list-table:: devlink info versions implemented
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``fw``
+     - running
+     - Version of firmware running on the device
+   * - ``fw.goldfw``
+     - stored
+     - Version of firmware stored in the goldfw slot
+   * - ``fw.mainfwa``
+     - stored
+     - Version of firmware stored in the mainfwa slot
+   * - ``fw.mainfwb``
+     - stored
+     - Version of firmware stored in the mainfwb slot
+   * - ``asic.id``
+     - fixed
+     - The ASIC type for this device
+   * - ``asic.rev``
+     - fixed
+     - The revision of the ASIC for this device
+
+
+Parameters
+==========
+
+The ``pds_core`` driver implements the following generic
+parameters for controlling the functionality to be made available
+as auxiliary_bus devices.
+
+.. list-table:: Generic parameters implemented
+   :widths: 5 5 8 82
+
+   * - Name
+     - Mode
+     - Type
+     - Description
+   * - ``enable_vnet``
+     - runtime
+     - Boolean
+     - Enables vDPA functionality through an auxiliary_bus device
+
+
+The ``pds_core`` driver also implements the following driver-specific
+parameters for similar uses, as well as for selecting the next boot firmware:
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 8 82
+
+   * - Name
+     - Mode
+     - Type
+     - Description
+   * - ``enable_migration``
+     - runtime
+     - Boolean
+     - Enables Live Migration functionality through an auxiliary_bus device
+   * - ``fw_bank``
+     - runtime
+     - String
+     - Selects the Firmware slot to use for the next DSC boot
+
+
+Firmware Management
+===================
+
+The ``fw_bank`` parameter can inspect and select the firmware image to be
+used in the next DSC boot up.  Banks 1 and 2 are used for normal operations,
+while bank 3 should only be selected for recovery purposes if both the other
+banks have bad or corrupted firmware.
+
+The ``flash`` command can update a the DSC firmware.  The downloaded firmware
+will be saved into either of firmware bank 1 or bank 2, whichever is not
+currrently in use, and that bank will be then selected for the next boot.
+The ``fw_bank`` parameter will be updated to reflect this.
+
+Enabling the driver
+===================
+
+The driver is enabled via the standard kernel configuration system,
+using the make command::
+
+  make oldconfig/menuconfig/etc.
+
+The driver is located in the menu structure at:
+
+  -> Device Drivers
+    -> Network device support (NETDEVICES [=y])
+      -> Ethernet driver support
+        -> Pensando devices
+          -> Pensando Ethernet PDS_CORE Support
+
+Support
+=======
+
+For general Linux networking support, please use the netdev mailing
+list, which is monitored by Pensando personnel::
+
+  netdev@vger.kernel.org
+
+For more specific support needs, please use the Pensando driver support
+email::
+
+  drivers@pensando.io
diff --git a/MAINTAINERS b/MAINTAINERS
index 955c1be1efb2..f77fd6fbdedd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16156,8 +16156,9 @@ M:	Brett Creeley <brett.creeley@amd.com>
 M:	drivers@pensando.io
 L:	netdev@vger.kernel.org
 S:	Supported
-F:	Documentation/networking/device_drivers/ethernet/pensando/ionic.rst
+F:	Documentation/networking/device_drivers/ethernet/pensando/
 F:	drivers/net/ethernet/pensando/
+F:	include/linux/pds/
 
 PER-CPU MEMORY ALLOCATOR
 M:	Dennis Zhou <dennis@kernel.org>
diff --git a/drivers/net/ethernet/pensando/Kconfig b/drivers/net/ethernet/pensando/Kconfig
index 3f7519e435b8..d9e8973d54f6 100644
--- a/drivers/net/ethernet/pensando/Kconfig
+++ b/drivers/net/ethernet/pensando/Kconfig
@@ -17,6 +17,18 @@ config NET_VENDOR_PENSANDO
 
 if NET_VENDOR_PENSANDO
 
+config PDS_CORE
+	tristate "Pensando Data Systems Core Device Support"
+	depends on 64BIT && PCI
+	help
+	  This enables the support for the Pensando Core device family of
+	  adapters.  More specific information on this driver can be
+	  found in
+	  <file:Documentation/networking/device_drivers/ethernet/pensando/pds_core.rst>.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called pds_core.
+
 config IONIC
 	tristate "Pensando Ethernet IONIC Support"
 	depends on 64BIT && PCI
-- 
2.17.1

