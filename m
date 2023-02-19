Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B96E69BF2D
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 09:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjBSIkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 03:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjBSIki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 03:40:38 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20609.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CA710AA3;
        Sun, 19 Feb 2023 00:40:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nJ071Vu7QDoyRFpIDV6UBkOoAdTgmssJKz3NVtk+icdIvjs0RpvFiet/eKl2DnZGb4p+L3lKDnZDPhEhmwqmGUMeSVqHP61NxkmE6C+zTGxFtGW8Hgye5KM5EqW8/vHh8XU+rlQX23rMT3wd9qLR2Y38Mj06iBLjKbekJ/ldY0iQtmRwUOmYXlSm7nopkcOQPsnaZObYZonB0FofST45yrJOo+iXQSylmPJ8L46xzjAytgHf6wbhqwe60e4YAKyvgtML15X7PjtJE/KIdI8vylyTI56zb55glTywqyLIQ+UAVr5WTYBm3fUp1aW+JaWytqkgQ6H+ZT4q88J+N3XVGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/2XftHJaQhgBedb+chQEwyW7ta+q9uXFw4v/KhfvvY=;
 b=hRIJjIgkOE4iTFaN3pZ/1csxM3NPmiW/fuCNcwPT8IPGPnqSZMTKGx0pTdVdcydh8cLOa/bYpedzS5SXQYnKDMZCdnClda5MhQ1eYkZs6PMH1br20r0d36W/CvlwZv3nSSnIMIqCotUkteWUAc/L6+bfblDiXdFPbPJHI1wOvs8mGVEg7UUtT5XVCUt0vlNpHPz00uSLViz2ulWFBxSbTBp6F9dX7oHO3DpV8iwA3Un+Oh1xZYhh0qYuaEhB4E6AGd3PjVIk7VsKyzyymvbrFxqFUpmh1NPRRHw6jx1YePfuXhlJpMIX1gSl9QdEoZ5bAqsCN5N5vZGD/GhQ5UWMpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/2XftHJaQhgBedb+chQEwyW7ta+q9uXFw4v/KhfvvY=;
 b=XZzta+za3s9DpWPv27V18nnFcr6oCZnNLkCh5WSnwiOveH0hEI7RjNa0bTv1py36dQ1YOYR/8b6FhkIW/o9LjyATvJg5+BS6xJ/SmhpufJJh9ktqSyVYGPe2crPIhOmA/zMd77eIAxSlfqVl4fb5jYyiQ8Et9e6uDJeBmYXJjc8=
Received: from MWH0EPF00056D04.namprd21.prod.outlook.com
 (2603:10b6:30f:fff2:0:1:0:c) by CH3PR12MB8583.namprd12.prod.outlook.com
 (2603:10b6:610:15f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Sun, 19 Feb
 2023 08:40:10 +0000
Received: from CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
 (2a01:111:f400:7eab::206) by MWH0EPF00056D04.outlook.office365.com
 (2603:1036:d20::b) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.5 via Frontend
 Transport; Sun, 19 Feb 2023 08:40:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT089.mail.protection.outlook.com (10.13.175.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.18 via Frontend Transport; Sun, 19 Feb 2023 08:40:09 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 19 Feb
 2023 02:40:07 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <shannon.nelson@amd.com>, <drivers@pensando.io>,
        <brett.creeley@amd.com>
Subject: [PATCH v3 7/7] vfio/pds: Add Kconfig and documentation
Date:   Sun, 19 Feb 2023 00:39:08 -0800
Message-ID: <20230219083908.40013-8-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230219083908.40013-1-brett.creeley@amd.com>
References: <20230219083908.40013-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT089:EE_|CH3PR12MB8583:EE_
X-MS-Office365-Filtering-Correlation-Id: 6638fbf0-dd89-42ec-fc7c-08db1254e8ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V9C12e2i91NZP7PgIdMsLNi4lt8sv8He7HyO/KOSk4ZYuwMcBy7leDem1HWWXEm83V/wixow8z5qyrfupUhWO3UQ+qaG944fhdxMNTjACv8SyUoQwX2Jzd0ZE5uQUzYm3+SW/ZN38tPpKiJ8lJ0ng875BA2ihCPLvFn0TUQOOYiDHLyQTaJIpeOfQeir1S9Rz2rE0mLOgzrhm0Dc6GBFrpBa28vSb0Z/M2QT6JLs+gBl4aoSuj+y0/a41jT8MYFhJ2IJ7l0Rg3gXc6IG2OhXsmzK2YmHE8UcOxH5bMNLI9g6sCKUh/bpW+BNGACoa/RUFqw3o0LGC3PG9vAxn+gb580hFlDz5U0Tj4sCditB4wo3ZMM8EV8QyRTbmVk1XPduNW2p2HEjXrSvHAC6ptyKrwuhhhgASw6m+KD80z8D981qEqDzgMpQxc89YYg/4Ql6bz9g0n49e43BiEeMc/yMg7tIZxun3zU+5+2r5bKKLC8ZGl4uyo7L9mYWLlsZ2sSpuEOIH7p49/A8DkpglyWPoLso1hO3xAQy3aBnu6iATJ14OFFn0EIS/OSif3wNLH5+/ZprmhJlc7Spc+JcRbq7q0LZzlzakLu7WOQeJvK8WHjtiKqXG1A/fOKANJnsB88qRmeq0NJ8RG1a7i7tVwaW639Yn0X7zMnZ95/M6r7iUy5I15Geaa19y65mMyhLbMPK/scutAu6swdtuDKAeXnBx0y3pabr39/wr4oHVDJv9kE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199018)(40470700004)(36840700001)(46966006)(70586007)(2906002)(8676002)(8936002)(4326008)(44832011)(70206006)(5660300002)(1076003)(81166007)(356005)(36860700001)(82740400003)(86362001)(36756003)(478600001)(40480700001)(54906003)(110136005)(316002)(41300700001)(26005)(2616005)(82310400005)(47076005)(83380400001)(426003)(40460700003)(336012)(16526019)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 08:40:09.1829
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6638fbf0-dd89-42ec-fc7c-08db1254e8ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8583
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Kconfig entries and pds_vfio.rst. Also, add an entry in the
MAINTAINERS file for this new driver.

It's not clear where documentation for vendor specific VFIO
drivers should live, so just re-use the current amd
ethernet location.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../device_drivers/ethernet/amd/pds_vfio.rst  | 88 +++++++++++++++++++
 .../device_drivers/ethernet/index.rst         |  1 +
 MAINTAINERS                                   |  7 ++
 drivers/vfio/pci/Kconfig                      |  2 +
 drivers/vfio/pci/Makefile                     |  2 +
 drivers/vfio/pci/pds/Kconfig                  | 19 ++++
 6 files changed, 119 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_vfio.rst
 create mode 100644 drivers/vfio/pci/pds/Kconfig

diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_vfio.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_vfio.rst
new file mode 100644
index 000000000000..fe95c53098e0
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/amd/pds_vfio.rst
@@ -0,0 +1,88 @@
+.. SPDX-License-Identifier: GPL-2.0+
+.. note: can be edited and viewed with /usr/bin/formiko-vim
+
+==========================================================
+PCI VFIO driver for the AMD/Pensando(R) DSC adapter family
+==========================================================
+
+AMD/Pensando Linux VFIO PCI Device Driver
+Copyright(c) 2023 Advanced Micro Devices, Inc.
+
+Overview
+========
+
+The ``pds_vfio`` driver is both a PCI and auxiliary bus driver. The
+PCI driver supports Live Migration capable Virtual Function (VF)
+devices and the auxiliary driver is used to communicate with the
+``pds_core`` driver and hardware.
+
+Using the device
+================
+
+The pds_vfio device is enabled via multiple configuration steps and
+depends on the ``pds_core`` driver to create and enable SR-IOV Virtual
+Function devices.
+
+Shown below are the steps to bind the driver to a VF and also to the
+associated auxiliary device created by the ``pds_core`` driver. This
+example assumes the pds_core and pds_vfio modules are already
+loaded.
+
+.. code-block:: bash
+  :name: example-setup-script
+
+  #!/bin/bash
+
+  PF_BUS="0000:60"
+  PF_BDF="0000:60:00.0"
+  VF_BDF="0000:60:00.1"
+
+  # Enable live migration VF auxiliary device(s)
+  devlink dev param set pci/$PF_BDF name enable_migration value true cmode runtime
+
+  # Prevent non-vfio VF driver from probing the VF device
+  echo 0 > /sys/class/pci_bus/$PF_BUS/device/$PF_BDF/sriov_drivers_autoprobe
+
+  # Create single VF for Live Migration via VFIO
+  echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
+
+  # Allow the VF to be bound to the pds_vfio driver
+  echo "pds_vfio" > /sys/class/pci_bus/$PF_BUS/device/$VF_BDF/driver_override
+
+  # Bind the VF to the pds_vfio driver
+  echo "$VF_BDF" > /sys/bus/pci/drivers/pds_vfio/bind
+
+After performing the steps above the pds_vfio driver's PCI probe should
+have been called, the pds_vfio driver's auxiliary probe should have
+been called, and a file in /dev/vfio/<iommu_group> should have been created.
+There will also be an entry in /sys/bus/auxiliary/device/pds_core.LM.<nn>
+for the VF's auxiliary device and the associated driver registered by the
+pds_vfio module will be at /sys/bus/auxiliary/drivers/pds_vfio.LM.
+
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
+    -> VFIO Non-Privileged userspace driver framework
+      -> VFIO support for PDS PCI devices
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
diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
index aae0955eb26b..0011fde1a36a 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -14,6 +14,7 @@ Contents:
    3com/vortex
    amazon/ena
    amd/pds_core
+   amd/pds_vfio
    altera/altera_tse
    aquantia/atlantic
    chelsio/cxgb
diff --git a/MAINTAINERS b/MAINTAINERS
index f2bd469ffae5..b94bcd011531 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21929,6 +21929,13 @@ S:	Maintained
 P:	Documentation/driver-api/vfio-pci-device-specific-driver-acceptance.rst
 F:	drivers/vfio/pci/*/
 
+VFIO PDS PCI DRIVER
+M:	Brett Creeley <brett.creeley@amd.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	Documentation/networking/device_drivers/ethernet/amd/pds_vfio.rst
+F:	drivers/vfio/pci/pds/
+
 VFIO PLATFORM DRIVER
 M:	Eric Auger <eric.auger@redhat.com>
 L:	kvm@vger.kernel.org
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index f9d0c908e738..2c3831dd60ef 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -59,4 +59,6 @@ source "drivers/vfio/pci/mlx5/Kconfig"
 
 source "drivers/vfio/pci/hisilicon/Kconfig"
 
+source "drivers/vfio/pci/pds/Kconfig"
+
 endif
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 24c524224da5..45167be462d8 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -11,3 +11,5 @@ obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
 obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
 
 obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
+
+obj-$(CONFIG_PDS_VFIO_PCI) += pds/
diff --git a/drivers/vfio/pci/pds/Kconfig b/drivers/vfio/pci/pds/Kconfig
new file mode 100644
index 000000000000..88422c5f36ec
--- /dev/null
+++ b/drivers/vfio/pci/pds/Kconfig
@@ -0,0 +1,19 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Advanced Micro Devices, Inc.
+
+config PDS_VFIO_PCI
+	tristate "VFIO support for PDS PCI devices"
+	depends on PDS_CORE
+	depends on VFIO_PCI_CORE
+	help
+	  This provides generic PCI support for PDS devices using the VFIO
+	  framework.
+
+	  More specific information on this driver can be
+	  found in
+	  <file:Documentation/networking/device_drivers/ethernet/amd/pds_vfio.rst>.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called pds_vfio.
+
+	  If you don't know what to do here, say N.
-- 
2.17.1

