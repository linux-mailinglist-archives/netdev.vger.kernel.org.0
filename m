Return-Path: <netdev+bounces-7585-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB24E720BB3
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:05:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FCE11C2122C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 22:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A32EBE7E;
	Fri,  2 Jun 2023 22:03:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C03C2C0
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 22:03:55 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on20626.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::626])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471471BC;
	Fri,  2 Jun 2023 15:03:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Um4mR5/gnqZ34qd4pqMCI/l5MbaU/4j4K8G9cQdvMVRUoXuBSc8LOD6vsT4nY2IP95HyAVNOJoFJGPJXcRfBBwtc/cFvA2zxqkguojY+GB79jSuXtSM1/L/mxqOhasZ6H2I81/2KLraZZPvaeV0wQ2zYpfOf5b8BNkCZwSFjMPv1sMHueMJQSYGVtp8hkmfHwkQk8NPPmqd6Z6ctmPueg8YgQsiPKLzy50Tu4k3dfI6JQe4m1nM/Yq1ZbicAh5DoanutiCadUIb9xcA/pJPs48j8jOS5xw2rlhGXOC3kQizHfJ/x8D5GTmFzSibRA0waSrSvLevLI5RRHmIC+NT17A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KszT3GDhgxoPr1at544hY0fKyxxEcv3LGyb+uHWPySs=;
 b=M7ANLDLkPuwOsj5oEdF+/w6ZgVT6MwzL3uJdoc6PDR59oqFTlpmTGapFXPSPq+QTaSfucZ3DfqsmKOvTDLps448P6B+el47iXA4G69psI3ows61UP1LL3t3AvJN0qcg6FqWqHPuIESQxKTiv0f0ON7W6mst0jd+Khhv9tbAZPMIrpS2lHVYR6pc7pjJSKH7ViVEQkRtyz6pNT/hYR8t46EE43pNyrjPBu9C/+JQ5SezxQLyGZXbzOOAec0pl66ZiF4BoxuWNspYo4aluoGfJnXsCQ2k+Ighdc3hMLx7Z3uSIrdrye0aReYSNT/KzD/cwzeNvfNxd9SFxEZSrhF6tOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KszT3GDhgxoPr1at544hY0fKyxxEcv3LGyb+uHWPySs=;
 b=TnZ+P4b3DuoABJ7BWf1MsPHtBihzfKBMGh3ywjX+ynEFOJuh/9j+QTG5wKy71qe+Dduodjiujg6SeIfa7bzsPxaLQjVULcQeZVL9i12Dy1afJtpsWdzLrbtswWWNJ7RAkTt5rW+PEbPC2mw+dKW16gadopMGSu/RFCXdx7LL62o=
Received: from SJ0PR05CA0165.namprd05.prod.outlook.com (2603:10b6:a03:339::20)
 by MN6PR12MB8471.namprd12.prod.outlook.com (2603:10b6:208:473::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.26; Fri, 2 Jun
 2023 22:03:49 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:339:cafe::4c) by SJ0PR05CA0165.outlook.office365.com
 (2603:10b6:a03:339::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.10 via Frontend
 Transport; Fri, 2 Jun 2023 22:03:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.24 via Frontend Transport; Fri, 2 Jun 2023 22:03:49 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Jun
 2023 17:03:47 -0500
From: Brett Creeley <brett.creeley@amd.com>
To: <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
	<alex.williamson@redhat.com>, <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC: <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v10 vfio 7/7] vfio/pds: Add Kconfig and documentation
Date: Fri, 2 Jun 2023 15:03:18 -0700
Message-ID: <20230602220318.15323-8-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230602220318.15323-1-brett.creeley@amd.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT055:EE_|MN6PR12MB8471:EE_
X-MS-Office365-Filtering-Correlation-Id: dcabce69-1c5d-46ff-65c3-08db63b53eb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Rfq981Le6DCNuhJf9crzv2PHNZe+2Lts1OFPxQ2UilZc8F2rSMqSkHg3qbV1ElGDJjwEJ7+Yf4Czvm9BQPxacer8UOdlQDrpXBeVacWM+mJAq5W25xfbUspJmwuIzTLJVWCb6gfwg4/Iqioe2EExnnWVFMO+fW75j5VDWIjcDFngJ0bMSiDS0JnwCZKA75UXWt+t91K9JfcSCYKGDx8GJej/vO27ArFmiHUri9Es0hNrUKqMQ0QqtXGCV5puklgBOHP4LXDZTp7h9HEKZL+tVETXlnLI4NqhjjXkIoEvgPrWfMotX1qkRSgjkrNgQFVjort9dwruk690h0JV0IMp1h4yl6GjSmRrSOq/GmbihnPAh8au20kZX//lwGBK3084nQNp9Pu1hUo0HdPT/PwTuLQWZpfRSdGjkwjXwwM806ygGtUxN3Y0P71VmBu4LbskTlXydmllHLymNWmgcJAC3mWlV+2RoMRg2z6gIyZKMXWHZr9ZYt5lY661hi4TxAi86dpWBvlfpl+pw0Akqh4Kr8mA80UxH75SUit2L4d2eOnRAfqTSJ0a7SJIMYvI4uyqaaNLTgyr4mL8rw2hpRnqo7wq65iZtYfD6RsvpyeJNgFFmXGHj7NY2Psn1iLx7ZRUY9gKwHZQaCStMo/fl3yntbx2ddHOdw0fghWwzrpoe7wYeZhMmr9B0LT+tQ+jl3EPdL9oVYFK6aQXrIcs3Qvfsu5YkFSGGUvSJBLjkuh26rnY9MatfK5t2bxqp+Er6npokuOgpFbDOISai6etZ/Axeg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199021)(36840700001)(40470700004)(46966006)(2616005)(336012)(426003)(83380400001)(47076005)(40460700003)(2906002)(81166007)(356005)(82740400003)(36860700001)(36756003)(40480700001)(41300700001)(6666004)(316002)(4326008)(86362001)(5660300002)(8676002)(8936002)(110136005)(478600001)(54906003)(70586007)(70206006)(26005)(44832011)(1076003)(16526019)(82310400005)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 22:03:49.4869
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dcabce69-1c5d-46ff-65c3-08db63b53eb7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8471
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
index 417ca514a4d0..0dd88e6f4e7c 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -15,6 +15,7 @@ Contents:
    amazon/ena
    altera/altera_tse
    amd/pds_core
+   amd/pds_vfio
    aquantia/atlantic
    chelsio/cxgb
    cirrus/cs89x0
diff --git a/MAINTAINERS b/MAINTAINERS
index c904dba1733b..cb3e4d40ca76 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22140,6 +22140,13 @@ S:	Maintained
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


