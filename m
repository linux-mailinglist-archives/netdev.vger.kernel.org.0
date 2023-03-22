Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7371C6C57F0
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjCVUnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjCVUmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:42:42 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2067.outbound.protection.outlook.com [40.107.212.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A578C5BF;
        Wed, 22 Mar 2023 13:35:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkIG1IT8DJKrfcvcP6boDdfZupPrY7fUdT8jLWoBVcT9WvNy66qfnOPdwAYcMujUxWNF8DIZarU71Zw7YFWxk2zISwJf0OOCk0Zfsd1vGujvNbRqD/45kvRAaYxBWCUcr3aRQYxsvaV+9w/bWe8UTxx5VvrZUP1mDnx72BAPGm+AfC7KWZNfzNpz81gGMOogy4USCBXFOu8+pkOYiB9GLow0480k+eCELidnZL0cH5B/JrY4wIpYcibwj8Xze60bX4CcBjKPgDKGjSFTF/23c4/ufHz/yTb2V6R8M37qzXhA0h4CBIgGVrhXIntAUksdYdxOjYL8opaagNiPr/vCeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WYyM8J9JUmVQAsShVV66OiQNJSiVhScYEjYjYCNv58=;
 b=Mb7S9Gz+cZqvIfYd4UWpg/EFbmXgi0WGUqm4NEZNz1OQxTaIjfrIp+7tItZYq4iuvfS+JXRvDSgFThuHNyuO0piOgwXUoIqlDro9wqHz6UihA8LUAH+6EtXziGNaOn3CQMO7/gLMZp5tyCYhERypIp5EwKL5dp24Xccz+qQLNXXCxzA2oQ3IUbbsVx18wNekEp54PyZaoYCZA+CJBRU/UW0LvHUmQEJSAsh/+KzIuUPcfAUt8HWnQo0oUjPcvmxg84kFImXGjmzV+uTLfQBJSKBpbQkaygwdITDPgNn7NNb/JkJIB+i16mG9DguaT3+8mxW/VD5EVN3+Lg4xNHaXLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WYyM8J9JUmVQAsShVV66OiQNJSiVhScYEjYjYCNv58=;
 b=hvSh6t5kQuv3Sxylrhbem0ogJ0G7HZC7WUtdCeO5XmqiDWKZt52LOAzb6syTdmn+oFf+s5QenoNvXxjGgsecYWpjdSlY7TY9suMbCd12kFPSyndmLnxOqJq308gon0f5rZKREYLth9FSrmJ055GqzvOwcTg9DUHvBa8V8DBG8CQ=
Received: from BN9PR03CA0067.namprd03.prod.outlook.com (2603:10b6:408:fc::12)
 by SJ0PR12MB5408.namprd12.prod.outlook.com (2603:10b6:a03:305::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 20:35:12 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::3e) by BN9PR03CA0067.outlook.office365.com
 (2603:10b6:408:fc::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 20:35:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 20:35:11 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 15:35:10 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drviers@pensando.io>
Subject: [PATCH v5 vfio 7/7] vfio/pds: Add Kconfig and documentation
Date:   Wed, 22 Mar 2023 13:34:42 -0700
Message-ID: <20230322203442.56169-8-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230322203442.56169-1-brett.creeley@amd.com>
References: <20230322203442.56169-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT034:EE_|SJ0PR12MB5408:EE_
X-MS-Office365-Filtering-Correlation-Id: 002d9722-4151-4ac5-333f-08db2b14ef42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fiOQaE1AiPKGMypeO3Xo8hnlfewIFQqL4To7at7Q709Q9cqHfC+jiKtKX/JJ/ukSiunKYuj0W1vatnWU7tvw15i+QAvqnMha/dJp11kk4zR1fVRqYUJt/At3AGDL/QWyXyG9eYniaUlJea35LJ/HPsCYIIsc+2aQB1fax7A3wGt7QIpIHOy7ZtCO3KK91XAaDa84+BXZYOfpCcwcA4Q17TDTc5iFGjHljXy0qggOYx/HBXoZUli8zKVje4adIcOQynpZIScvU6V4Jffb0wVfW7KiIZQMOGS5E6oZ9ELeAMLw7wPw/kLh/6d1vZH6EvX/TPjcsgtNEtu+h/uZtamIMJjfOLFX2rJotglQR6yOeRSltYFcyiTc6+safWpTqCjNe3yKS8Y4LkvJzv+b5bMG9nSyS7qHMqpqPDJUES0IsyQRX5STXOcZRX3pxUuYMyBLGn6xBXzpT/jIIiblymaIvxwD1+pNHVAGFQiGgk9K10ngZxoTin+gOkE7UOhLBkOxMW8LXK0J+5i5uvNQZKeDv7equaQYew/6psCHKlUuhFYKvcrWtlVTFxysjv3PV946ZlnJLgUQeh57IUbnWZa53cMDJbLUq2yhgNtXxplYmIXGNwQNYP2cAzxOydK5qzF1AXDAEhEu3pShfL9nYLWhWA3rkTw441miWVE3FFah2iZ2Gj5vX1l0xNCN/8/fKGZ3QgCx8FCaAVEHMBIxbjITFFFhxings9LEGAY1bCZ28SY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199018)(36840700001)(46966006)(40470700004)(2616005)(1076003)(83380400001)(26005)(16526019)(336012)(47076005)(426003)(316002)(8676002)(478600001)(70206006)(6666004)(4326008)(54906003)(70586007)(110136005)(2906002)(36860700001)(44832011)(8936002)(81166007)(82740400003)(5660300002)(41300700001)(356005)(186003)(86362001)(82310400005)(40480700001)(36756003)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 20:35:11.6021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 002d9722-4151-4ac5-333f-08db2b14ef42
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5408
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 3621ea7f47f5..dea3398ff2c8 100644
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

