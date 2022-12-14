Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE0A64D358
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiLNXZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiLNXYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:24:08 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2075.outbound.protection.outlook.com [40.107.100.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2716E511EF;
        Wed, 14 Dec 2022 15:22:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5P7+t2wkw1eqgUFFfnMRg2m1phsgcy+OD4jnHHZxBnzQT5ybwggvZbVf2qT4uVs07GGXi4ZbHJwk5nh2CunyjWfEtlRGWvAPJX6G89tfRANj3dArAes2pMvJcDFUpIS7+oTWia9476bJXZQCIRDicTt5uvZdHsDzgyvJ4VioAEQ+hwvIJDt7jTnp27JZWOezPfJsjs1wPw8DIzwyc/FkhdnQWrfRBJcjbbD/YGtZOpYXRQcYlqudgqD5cnZE4tl+VrwQdhMF6dzJesSnImQjecZ8Ji9G/w/xvOAyVhaSERmD/9xAn64RicGFupXRlhj3yhbiAc3f5I6iQRmD1/gyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jS8AGT7nj3C8vddPq8FhFB/w6oWPk406bxAGs8sI9CM=;
 b=hu8aU4NPlBpnKo9Ad1wKsgye1gbnc3IMR3BSOqmysrw7v7rgGD2TLHCLUcbmvwbXeamQgydJxMP0mm6wkks+FpDJQf/WRk3EpOg2fvoqQ0QlpVLRt7rmn0RgOV/0/cTBmAy67vzE5eheg0mblyKm4VGupcpH8TDmVJeY74fhFOOFJJPlA0Gx+kcD3g2/eV41K8RtWNpXvP+7dQkpHZgni3zFM6YccrnOPj7GP5w3iRAjogMnGY5MscgGPf4lgrPhh1RgqKgamFNuRb+gFo1tDup5Zylq+mEX8G8xOvFwEfyD4xnBJUBKh2wAZAQ5e5FxN5zEqfvAMd0w3or8KMpZ4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jS8AGT7nj3C8vddPq8FhFB/w6oWPk406bxAGs8sI9CM=;
 b=SCs8ujTRAlzCBu+7Hf7HQUMInJImeas22RCRHRYxHtpqavos7kLzrthiSF3CPcci4qcC7wSLx9Oqspw5vC4klN3P9GcydkTaAuA7GuhHLqhkjmJD9Pk9f6hj+IHjlGqeQDSd4ck/UQpae6s0TlUrQvDvxGFo27tmgINHdj/vyzY=
Received: from BN9PR03CA0652.namprd03.prod.outlook.com (2603:10b6:408:13b::27)
 by MW4PR12MB5666.namprd12.prod.outlook.com (2603:10b6:303:188::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 23:22:07 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::1b) by BN9PR03CA0652.outlook.office365.com
 (2603:10b6:408:13b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 23:22:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.12 via Frontend Transport; Wed, 14 Dec 2022 23:22:07 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 17:22:06 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <shannon.nelson@amd.com>, <drivers@pensando.io>,
        Brett Creeley <brett.creeley@amd.com>
Subject: [RFC PATCH v2 vfio 7/7] vfio/pds: Add Kconfig and documentation
Date:   Wed, 14 Dec 2022 15:21:36 -0800
Message-ID: <20221214232136.64220-8-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221214232136.64220-1-brett.creeley@amd.com>
References: <20221214232136.64220-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT009:EE_|MW4PR12MB5666:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c3c6f87-4426-464f-e517-08dade2a04d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vksV5E8rR/8TD991ugWrjF/nxNCsB4DpoHRMaCfXa1/PwDwT9Vre9bit/K5PSOGoyhf7R1iwhOtyvHcziQbn51u87M5+by2GINrVwerM9W0/Js6OhDxugyhTKAYe+1DYA7jwy8R0Rp6j/pyw4wrw9bVM0fIrkSZ4O3RGnqISHnS6Zwy+vsDy1ntVppS2139CRHwH8NCWtbMdKeTEE4M0C83w0c4c4iqXXSvnT3XzfeRd3FL3wJiI7NsL6Q1Dr5pCqcG0Ngv6fUeTCIqPcsuR+FgMDal3AwIGKSrWb/2tIeRcPB7SBD7tCfNyfccUG6S9NJ/7872Dsw4w6acUS0cbymlVxUsLJG67p2QxNS4Hm/MzFRT8Z+4Ocb/VF9dqinGy4lP0OzERW0KUw7hrdMkRoadAAChAx+vBPiUTRWIZIUreFAMtoBP2FPGW9/RQCDpHfE1oWTFoCpR3qbOsJ4voVVj1GHj9SUzus+5sBAFtKf4+GfRGjA7NYNkwHGjhkQRF+fe43iS2NcfAgTBYmdVsNPkAShIfqgODzo36RjWm7Bldc6syo9ejHSdqz3P5xKmk5lDClQ0sVx9i1iPh5pt3y7LaqYx6yE47ctOwvFCTOqlu+ixbJrkzrsjFFF/ohtOQ3M13LJl7YrafCeuEeSNdXRbetOvwx1SMRg45EZze+GadSk0eFnDoZXE2JckPTShB/gHgO9F4F46TXqS/P1CoeK7UwJe1XoGIeHXX1HYltCA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199015)(40470700004)(36840700001)(46966006)(70586007)(70206006)(4326008)(1076003)(8676002)(40460700003)(16526019)(36860700001)(41300700001)(5660300002)(83380400001)(2616005)(47076005)(6666004)(54906003)(8936002)(186003)(478600001)(26005)(110136005)(316002)(82310400005)(336012)(36756003)(426003)(86362001)(82740400003)(2906002)(356005)(81166007)(40480700001)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:22:07.7128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c3c6f87-4426-464f-e517-08dade2a04d7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5666
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

It's not clear where documentation for vendor specific VFIO
drivers should live, so just re-use the current Pensando
ethernet location.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../device_drivers/ethernet/index.rst         |  1 +
 .../ethernet/pensando/pds_vfio.rst            | 88 +++++++++++++++++++
 MAINTAINERS                                   |  7 ++
 drivers/vfio/pci/Kconfig                      |  2 +
 drivers/vfio/pci/pds/Kconfig                  | 17 ++++
 5 files changed, 115 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/pensando/pds_vfio.rst
 create mode 100644 drivers/vfio/pci/pds/Kconfig

diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
index 5196905582c5..0242bbc3bb2a 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -44,6 +44,7 @@ Contents:
    neterion/s2io
    netronome/nfp
    pensando/ionic
+   pensando/pds_vfio
    smsc/smc9
    stmicro/stmmac
    ti/cpsw
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
index 50d7442e7f43..ba2d139ccee9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21623,6 +21623,13 @@ S:	Maintained
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

