Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE2F6450C4
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 02:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiLGBIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 20:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiLGBHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 20:07:49 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FD11838F;
        Tue,  6 Dec 2022 17:07:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7Ra93wmCOLLZVLR/mCdE66vCZGHqPf/36Bb0skanMkLULqSvkU8wFwkH9Rv15jJg+WUMsbhjXs26o2ovDiUEXX8Z2RSpIKKD7aMciGlGWbSF1w3Yuh1qpwr8laqXtEGmGh6DDIG6NWHn0+1LvQZywuZwjpxcpIyEKGpMa5wAGZSHMO8Gcx/ERhLx6/PkxNdv+hmSkR+oU9y6HyDkVcZmhICYqWu+bb99jcDh73X+knvI3TTZnm0vzwaVodZZqh5/pxRuzznPr7tfZLfnqx6oHcIRKIK7yg3h0Uk+pBk/H+FvuBeejS6Ke5m8OfE4T+9nJnase/+6vcPO2mr+uO6mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8E6mwLfSkx/VD/pGW/SExIxX293CYBIYfkqpfqJCeEE=;
 b=hvVcijFi74TbVzoLstQDYGPFu4df6ZHJkMufs0oRpWRjLOIW+PxYPgEubLVnQ5/3m7U2y6OfnUpTJuwgj8TTlBWuoOLLcjtwfh8QxB471WmoXj+agy/u/eqChZqIsk3OJjzBuihAq/Wy4iBtD9tDPe8/vpDQ7FwjW9ftBW5+zE8pLMHOh1H9HNdZcZNymRQOyaORFL1C/cwlP8RWNS801ffXMvGkDBX0Jxh0blo70bbo42zQK0Touy2dx8li+p9f60LeTdy38bQFjfTQ7VhPX1dy6dZwtQUT8Z20tsJGWhwUM3e3LzKCshlyQr3HkzgKx83swZYuLqyHknnZjZD1CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8E6mwLfSkx/VD/pGW/SExIxX293CYBIYfkqpfqJCeEE=;
 b=QPnpMrFIcfJHF0ZNiqMvL0rSN1QjAJUM4LXEb5PHz6QbL0wpeat3AYHg4ko62yNei256Fhj1z2ONLGarFSJ0gCsScqlddcJ5OStL0ZCXilQD0btR5k0692dS5ARHFVQBdNQeOeVIrtULTF+utfJJEWFzd33DNwOtU9pEmrli+kI=
Received: from MW4PR04CA0372.namprd04.prod.outlook.com (2603:10b6:303:81::17)
 by SJ1PR12MB6073.namprd12.prod.outlook.com (2603:10b6:a03:488::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 01:07:38 +0000
Received: from CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::68) by MW4PR04CA0372.outlook.office365.com
 (2603:10b6:303:81::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 01:07:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT113.mail.protection.outlook.com (10.13.174.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 01:07:37 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 19:07:35 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <shannon.nelson@amd.com>, <drivers@pensando.io>,
        Brett Creeley <brett.creeley@amd.com>
Subject: [RFC PATCH vfio 7/7] vfio/pds: Add Kconfig and documentation
Date:   Tue, 6 Dec 2022 17:07:05 -0800
Message-ID: <20221207010705.35128-8-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221207010705.35128-1-brett.creeley@amd.com>
References: <20221207010705.35128-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT113:EE_|SJ1PR12MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: c3cb3030-6cae-4fd3-1964-08dad7ef6e80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4ut4ik81dWhdaBvDojPyvtrYpmzAfa2kw3uPFUXd12xsLGUZZvrcA4YlisbRhdmGOUrHeAlbSdrQXYXltqhYXqBp8Eh6a/l/+99fwVr1nsaFoM9LWtL41nQ3dEvdjHYg/TAmk+XgDyWdOpcgW7PwzhdjBk0Q/hbTGMVu7PGSxhd6C+Un1STPQdxYNwv0nMW6/ksnphgcvlYIhwbAq8/jidjzs8fRmCUIGWWahwxyvGtKGOhLpNsJiyewaUVdHB6BrscXB+wDCyKIVfodr1taTMpyO8nPDAdc3osWKjPvyzwnOIEoyY+sgXmSABrwz6CY7oSgWpCk4o0veSDnYEqDuNHVa+N04ibXz31Fyc+qjhHoRKSJVKfo/Vt3Esk5ndewd0s8+jqc8qwN+T/EsJVU1tH09zRQEjQGsSe/S2iHm2/DeMs1zp7LH08PtdvWxo/LULilIZQ3bvIDHzxoBuFOSTxccpRM9ccDbUIf0fvN/rQemWExPJCUILMI/8xx8NRgRUUMOg/ugLnBg4i47qqLdGZRdv25W1T08SCjRinL+fL7UrSxj0Z2Phq4eWckJP6fp+pgZJvpNl7NEOrEMZuimwFIo61k/sMoDLZqJbnTRyOZ0dK8iRtqO4gn/HvFZR35Q4kjkBOh6BNhyocDtKBtq+u6hGC3P1vTbpf3rlqCtf3f4oaHyIxmeLaNOaAuyxavnAwaHGVOxLXORmDidMmX+WRQxr/ZZRDY42NnH+KjQok=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(82740400003)(36756003)(86362001)(356005)(81166007)(70586007)(2906002)(8676002)(8936002)(44832011)(41300700001)(36860700001)(70206006)(83380400001)(40460700003)(47076005)(54906003)(478600001)(2616005)(336012)(16526019)(1076003)(110136005)(426003)(4326008)(82310400005)(40480700001)(5660300002)(186003)(6666004)(26005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 01:07:37.5828
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3cb3030-6cae-4fd3-1964-08dad7ef6e80
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Kconfig entries and pds_vfio.rst. Also, add an entry in the
MAINTAINERS file for this new driver.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../ethernet/pensando/pds_vfio.rst            | 88 +++++++++++++++++++
 MAINTAINERS                                   |  7 ++
 drivers/vfio/pci/Kconfig                      |  2 +
 drivers/vfio/pci/pds/Kconfig                  | 17 ++++
 4 files changed, 114 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/pensando/pds_vfio.rst
 create mode 100644 drivers/vfio/pci/pds/Kconfig

diff --git a/Documentation/networking/device_drivers/ethernet/pensando/pds_vfio.rst b/Documentation/networking/device_drivers/ethernet/pensando/pds_vfio.rst
new file mode 100644
index 000000000000..adc144a4a7b8
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/pensando/pds_vfio.rst
@@ -0,0 +1,88 @@
+.. SPDX-License-Identifier: GPL-2.0+
+.. note: can be edited and viewed with /usr/bin/formiko-vim
+
+==========================================================
+PCI VFIO driver for the Pensando(R) DSC adapter family
+==========================================================
+
+Pensando Linux VFIO PCI Device Driver
+Copyright(c) 2022 Pensando Systems, Inc
+
+Overview
+========
+
+The ``pds_vfio`` driver is both a PCI and auxiliary bus driver. The
+PCI driver supports Live Migration capable NVMe Virtual Function (VF)
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
+  # Prevent nvme driver from probing the NVMe VF device
+  echo 0 > /sys/class/pci_bus/$PF_BUS/device/$PF_BDF/sriov_drivers_autoprobe
+
+  # Create single VF for NVMe Live Migration via VFIO
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
diff --git a/MAINTAINERS b/MAINTAINERS
index 2723cbdf8fd7..202f93dfce34 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21617,6 +21617,13 @@ S:	Maintained
 P:	Documentation/driver-api/vfio-pci-device-specific-driver-acceptance.rst
 F:	drivers/vfio/pci/*/
 
+VFIO PDS PCI DRIVER
+M:	Brett Creeley <brett.creeley@amd.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	Documentation/networking/device_drivers/ethernet/pensando/pds_vfio.rst
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
index 000000000000..d9bc9734c3cf
--- /dev/null
+++ b/drivers/vfio/pci/pds/Kconfig
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0
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
+	  <file:Documentation/networking/device_drivers/ethernet/pensando/pds_vfio.rst>.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called pds_vfio.
+
+	  If you don't know what to do here, say N.
-- 
2.17.1

