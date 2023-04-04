Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F2D6D6CE3
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 21:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236202AbjDDTDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 15:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbjDDTCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 15:02:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A2C59C8;
        Tue,  4 Apr 2023 12:02:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBrHuFiO50p2a+p6pb4Q7edbyJP8XrqORJxmLEy9n4lHJeWhnsehmWIELwUB38cyIwi+maTvhGA1aG0JEBzRoTquN3E0xcDjgoYuxyN4vKHf6K5R65bBHUtNiwyNCp0NgypcSZaQYYoqZka9UqSvG3+vpe3BES7zqsHQHtTxOaIiEypUD+D/cauZ0wtR7nehKv9HlZYg08PpnjHC+esdy0dSDw5MJFBuk8JvTnF5u2c9GpeGKG8dRuz5KNpuUPN+/qNRC4xuc5niICb66XbZb66kJNe/wCau9BzYRWhebNrkw7FFvmVRVOFSJdFuTc1YMbm/67N2LgPqSn0n8HYT/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GByx9i4kwDwjKOkoOKIRg5nu2rTe4XCsnHnPADdL1VY=;
 b=PSS1bgOdgHXiTmYMn6AYtAL2HI8XVBLc1nLVH0gaHLPV8a35TNsDh288tMtnf6aQj6Qj9epvEbMttWrK/x2iYgaIQUkUGOk6+uXh7HGuDkv2Eo7k3KFv4Y42ASOeqLw/riT30qLOCJxxhvrc6ww+6OMpUddaNo57ZyWw5ECQek8/+fSwMI2oKOeALvW0EGPPZmJmhabso8iQGQfCuGRja8FxEttpBplINN63rotCFPBEgvebNMwkEOyvYoNj2ZDjEmop6eK+h5beTIPcohtvwedkErfAgcBXD6rJVBlD/xiDq0BCwuUq9PYNDk8aOppIESdh57ncFcg+Q2KdYWBVNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GByx9i4kwDwjKOkoOKIRg5nu2rTe4XCsnHnPADdL1VY=;
 b=FcOp7Hv5lm+Dqnroki4ZmZW9WOL1cJVUznEu3Vr2Wf6jA0ebNd8xdqVLhPCrzeLj46uJdGhls59MyOfCp52hziVyYCWFFgowSDwa05/mQExCMrU32k3Y/+a9uwplgAlDpYMtWBHFLQTR/Aoj3B7l+0C03okTGfW+SuPtRWAwe5s=
Received: from MW4PR03CA0077.namprd03.prod.outlook.com (2603:10b6:303:b6::22)
 by DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 4 Apr
 2023 19:02:14 +0000
Received: from CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::25) by MW4PR03CA0077.outlook.office365.com
 (2603:10b6:303:b6::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Tue, 4 Apr 2023 19:02:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT048.mail.protection.outlook.com (10.13.175.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.22 via Frontend Transport; Tue, 4 Apr 2023 19:02:13 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 4 Apr
 2023 14:02:11 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>, <simon.horman@corigine.com>
Subject: [PATCH v8 vfio 7/7] vfio/pds: Add Kconfig and documentation
Date:   Tue, 4 Apr 2023 12:01:41 -0700
Message-ID: <20230404190141.57762-8-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230404190141.57762-1-brett.creeley@amd.com>
References: <20230404190141.57762-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT048:EE_|DM6PR12MB5520:EE_
X-MS-Office365-Filtering-Correlation-Id: 99bc578b-02df-4114-813b-08db353f1a17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WHcztX5Yp/iDdpg7cWxB5UFtCeMuKqEMkhogDMvfewPxA8Ud/OunKIdnPLwGx//+yhvsHDud0RJhqywjO0NVxElvkp59Sv1ANKVy2Lk6TZO/izuqwLY3u7SVB/2CrZorNlDxe6RDAiZh+xVMuJ4IJ8NZJPO0YkxQqbHdWjhZRTpdFFSBxn/l28PNY94fSAP7YaXO3Wc6Hd0v90gdkIk50BynPIgUknZXrSSKxl2dOc5pq/HRY7fKoltW/81UES3zJx8NgmeW/BIuEnTgpjKJl3tANhC94T1iXiS4sIU0XQXDg3fzYugh8mihmu3QwMMj5HTHNRBEZJzFyviu/ZyVAsf7wVf4vtSMXM9R1htiNY1G47Hit+rDyWohfzMGc14XxA0WaLSR/x8SiK+xUr43MXv9pDfi+O1FLg18viPizuA/zNus6vIpCJ8P2PzOsOB8NxSB1u/OWVObjJ9wDZ1K/Vdfn5o05gqylqpvn8EBW9kglIIzS2Vtu5teFE6VjDVdhVVme05ip7/cC3vbbqE17S1J+UF9jhMzjr3OxCDMONUIyU0zCZdOeY43NLIZ6buBx4exkp6TfCKQIEem3b1RcPIr4jasszbdltNHk+NTqlZNWnwdZfpBHJ/zMtJFnIs6svYSqDSqZt6RgNKvNObLd0Iq3zj6jqN6pl1hyLKVBlBrI1nHH+KLdU4HzNUOQTaDtCIe+gnJfsD8ajaH8TwxpAgZrmOYwrB6U8tXXR1ld1o=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199021)(36840700001)(40470700004)(46966006)(40480700001)(186003)(82310400005)(26005)(6666004)(16526019)(2906002)(86362001)(36860700001)(8936002)(5660300002)(44832011)(70206006)(316002)(70586007)(54906003)(1076003)(110136005)(478600001)(2616005)(41300700001)(4326008)(83380400001)(426003)(336012)(40460700003)(47076005)(82740400003)(356005)(36756003)(81166007)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 19:02:13.8454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99bc578b-02df-4114-813b-08db353f1a17
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5520
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 .../device_drivers/ethernet/amd/pds_vfio.rst  | 79 +++++++++++++++++++
 .../device_drivers/ethernet/index.rst         |  1 +
 MAINTAINERS                                   |  7 ++
 drivers/vfio/pci/Kconfig                      |  2 +
 drivers/vfio/pci/pds/Kconfig                  | 20 +++++
 5 files changed, 109 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_vfio.rst
 create mode 100644 drivers/vfio/pci/pds/Kconfig

diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_vfio.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_vfio.rst
new file mode 100644
index 000000000000..7bddde0c7c9d
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/amd/pds_vfio.rst
@@ -0,0 +1,79 @@
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
+The ``pds_vfio`` module is a PCI driver that supports Live Migration
+capable Virtual Function (VF) devices in the DSC hardware.
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
+After performing the steps above, a file in /dev/vfio/<iommu_group>
+should have been created.
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
index eaaf284e69e6..3b456406ff85 100644
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
index 97e2919baf4b..73b2b8225acc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21959,6 +21959,13 @@ S:	Maintained
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
diff --git a/drivers/vfio/pci/pds/Kconfig b/drivers/vfio/pci/pds/Kconfig
new file mode 100644
index 000000000000..149d4986bf43
--- /dev/null
+++ b/drivers/vfio/pci/pds/Kconfig
@@ -0,0 +1,20 @@
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
+
-- 
2.17.1

