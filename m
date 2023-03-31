Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444986D1435
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCaAhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjCaAgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:36:51 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393EF1287A;
        Thu, 30 Mar 2023 17:36:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxgQeFkCpFJKLwEiScKkgkT95dw0b2rJ3+jO0Tw70NNuU9wNkFp0g5scuuhuYLGBHQVeDA5IRj3nJevg3+Eyv/kHu/16WTSUJxr8WtPvec5fJ5tJITr40zM+mxchugTqzQstpWnURJ2aiEgJjq3ouyNvahlDYgdYIYHYCHfP228xXBcNb2ONKhmZU1PFXdS6S2yTUxoMTO3g77hDacNMAfCNi8wmVXOgNYu4lUPY16S6Cyg/m0XVK0lr4aLMLzP5xCKipIxPQo5TLLB+zp9oXiMrodjJpIWVCuekcPJ/ozKhAHR0WZ3L3wbOaAPceSG4uTa6IQt1L65nrQwgMBP+7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GByx9i4kwDwjKOkoOKIRg5nu2rTe4XCsnHnPADdL1VY=;
 b=c/mc0/X83huvIqHRJQJCdBdVJtLWdxPMKjSL75qHXsIe/Hx+p5gcuzdSdwZpGC5z5SnfrHjLf4EFuRCM4I7h7ziCK3lRD7J6owbBxFE8YBDLJ448S0qcB0X3zYeMc94HfIke3fC1sJXKjQjkM/LDEwd47U93T5OL352hWdsecgz9G42oYnkF7Alq7nh9yvvZmkCr6AHHGjVhJqDy45NsJ3rgQQAIRBFxszCctIjRSCAF5EH2iTo0AEDvVtlAlxV33kqZNoEa5xeM05DTyjtfZMEL4V6ZbK0CFwEsi91ObklbUOahwr7lpV6Xy1A62lGBBNX7haTeiI3ccq3eZlV65Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GByx9i4kwDwjKOkoOKIRg5nu2rTe4XCsnHnPADdL1VY=;
 b=kplc+38RWOpet9BzYpnvDfLnvEoKQxbuVb+dKLQgR+usHbPmgjPLjKGUen3kVrE95x8QXZu26UHAMkyNFhiATlhtLgaakE82TcEMhlo4RmqGEIj+wE3nKqcEUKYjVr/V5nH7g8mDgnzY9WQ98MrGl3jYtfc82KfUjJlKMG6k7qQ=
Received: from DS7PR05CA0047.namprd05.prod.outlook.com (2603:10b6:8:2f::26) by
 BL1PR12MB5128.namprd12.prod.outlook.com (2603:10b6:208:316::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Fri, 31 Mar
 2023 00:36:38 +0000
Received: from DS1PEPF0000E650.namprd02.prod.outlook.com
 (2603:10b6:8:2f:cafe::dd) by DS7PR05CA0047.outlook.office365.com
 (2603:10b6:8:2f::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.13 via Frontend
 Transport; Fri, 31 Mar 2023 00:36:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E650.mail.protection.outlook.com (10.167.18.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Fri, 31 Mar 2023 00:36:38 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 19:36:36 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>, <simon.horman@corigine.com>
Subject: [PATCH v7 vfio 7/7] vfio/pds: Add Kconfig and documentation
Date:   Thu, 30 Mar 2023 17:36:12 -0700
Message-ID: <20230331003612.17569-8-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230331003612.17569-1-brett.creeley@amd.com>
References: <20230331003612.17569-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E650:EE_|BL1PR12MB5128:EE_
X-MS-Office365-Filtering-Correlation-Id: 5db747b3-6648-41df-1fa4-08db317ffd38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YU8EjrVJHSX935YRUJRsBW6ZbtA+hNR2jmVe0YjWGhoYRl0e+O2bPi0Xzk3djSE+WkEnlvVu0tP4D9h4Lmke8WwBzWF4FA1btz8JT834NtsGZ+qDUJ5MvRAgSaniT1RxvNZY+TAejqr9aRktERPMxwzGV2t4MRvDWMIeIELupmsIAm6A0uDoNobRkyqa1axO2URd8Cy6rVUq/GnMJEhzf+Hn3yLLTVCiHLdGA1Eb8KyqkmqM4WU0scGEgeEPf87o/g+WFqgblyi7yo6ftXSIdZF5lFQx1ljDvkMSZbW8GhduPUtTr36U+6ya9Nisue3Ok45HkgyKwIUmppiI7KW1kB8wK8Elhw+ZkWRQWUXHzTEDCywhsHf/LYWY6QODR4sv7EmpM1KtVhnBgSdjMkBOLQgxbiTI1Oq5G5VhCkAtcannrTLA5y8oWO4pj7fgITQR48bnZEnognOdNcmNx3DHvfc8fkFjv+UuYGrS/mdYc4/iXsYzUyVCM2uonYMcVpXgtEsQvfO0DIoPi8g1pFITau+YIq991unfwzEfNbxQ8VBwt9UGyDnL+k2vqOagv2fy4qnXQLSbUAla1qvjFRKFpvu7tgpAh9aS/y5ku74St62YCPD7aSneOsDXhfuW6ve3c6V8OMBwn0120KiSSZhLUMXKVcaItBIzmXzIqOfURkYT9NKM9B7dPFT5e7R3w+hamcXcuPzyhQQUSU0Jw+ad/qG3uokK4Wi+y8w1aBC6iZs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199021)(36840700001)(46966006)(40470700004)(81166007)(82740400003)(86362001)(2906002)(6666004)(186003)(16526019)(356005)(26005)(110136005)(40480700001)(54906003)(1076003)(478600001)(44832011)(36860700001)(5660300002)(47076005)(41300700001)(8936002)(426003)(336012)(2616005)(83380400001)(40460700003)(4326008)(8676002)(82310400005)(70586007)(70206006)(36756003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 00:36:38.1197
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5db747b3-6648-41df-1fa4-08db317ffd38
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E650.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5128
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
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

