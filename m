Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DAA6CAF68
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 22:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbjC0UGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 16:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbjC0UGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 16:06:33 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA9719B4;
        Mon, 27 Mar 2023 13:06:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i40M3eegm1R4/MemAdXabnPvSOj8UX++epSOzn4sM5yHCO/fStpTQbvKf7kan4Osi4LiR5AbYu0+gM693JKQ5JL7vzYRgVI7R2Kbocf2uTyDSzswbz10oGQT07Ue5qMr7sqEgR20PSI8aj25Wz13/qVmg4Dgw6qwvCvDFkHZUn9nKnraFMVrZ9bzY0IkiiV5F4X0Ndi8cTSOgvIu69jOn2/v4n1axmh/n/SFa8032h+X+HDxMXzGY/YBCmCUaDalTGYV1FRlcUi5HHCZghjiea9HDtvLXchMV+kpnRXeezhDC9UL4M4qSNOFOb6b4J+hTAqxjQ7/F0jkHihCaR4uCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9IrVtTp7sgTZOYF4Kr1goClwoFYQD016LgtjSNfn1uM=;
 b=e5G5hcUkx1hI2ecQyfFpmtraxJ0jnVyEbsIfK3L/ey3mPyWs6DRQ4GG5twNrOHJ7t3ZxIUO2nBRXz59RfqHOspQtPeNyDsOCa1jLnLZVxkgP3nD2sCTV76V5kc9WzPAvhKQw4ZVYk75kYSBSMAfKmcqWNwTnko47iOdBErujIqYb+SOgiovAY1XCIpp8ogf70ixDsMX0a8adrq89AA70JvLXopsRy7/Cgo4Ca1Ryx4lwMKwTRV044IfNfyXBRk47vmLumuC4ZmNGEd+GvEshu0qMMdqs03D/vrbJEYuhv9MKIZDuy0FNCgg2bEMJA+H3VfNG12m0nWWGqx+qCeSaTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9IrVtTp7sgTZOYF4Kr1goClwoFYQD016LgtjSNfn1uM=;
 b=wQKvf4uWgN1WTl4e/fj4j+2QZ2XS9qMmoA8PCc2haW3y+7hkPqva55ImDGe4q2yrN4kh1WY5uFvocNl3Lw2kYEaaqUMRgrXR9ppb9FbdWsxqVQJwDf10PeK8oVBu5KDTJ8IvMPKfvoD8ENaimycXxFmvtumweulXr8B9KgdbUIo=
Received: from MW4PR04CA0045.namprd04.prod.outlook.com (2603:10b6:303:6a::20)
 by MW4PR12MB7357.namprd12.prod.outlook.com (2603:10b6:303:219::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 20:06:22 +0000
Received: from CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::c3) by MW4PR04CA0045.outlook.office365.com
 (2603:10b6:303:6a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41 via Frontend
 Transport; Mon, 27 Mar 2023 20:06:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT103.mail.protection.outlook.com (10.13.174.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Mon, 27 Mar 2023 20:06:21 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 15:06:20 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>
Subject: [PATCH v6 vfio 7/7] vfio/pds: Add Kconfig and documentation
Date:   Mon, 27 Mar 2023 13:05:53 -0700
Message-ID: <20230327200553.13951-8-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327200553.13951-1-brett.creeley@amd.com>
References: <20230327200553.13951-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT103:EE_|MW4PR12MB7357:EE_
X-MS-Office365-Filtering-Correlation-Id: 119ae2f4-034b-4003-e236-08db2efebc5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fmoOtnwmP+/N89UMeqGE8sQT0GeMGN5/QfKttmKcXdZq4sqYu+VbcEAezyy+/gTvDnw15JzzX9kzPBl9DQGHyLeCvfDaKQiv7o0gYjSmnJUEAbfjQpq8Wlju38CxjKBJr0Ma0L/pvh0nk41GzpxRb4FXRhLZTjhZ1vGMYhGj9GXhM2MOozNB82LNnzo/N8Phh5bsP7oTOBQ//n/wJxMGGebXiQhTUePYFwSKFblMD1VzTmKYIHBP95gduRwxLPbmch2wsqbtER6kj/ywB/iaLya/oR/W4T+QX5OJUi47/Cu+GX5asZGLYX57stx7MJJL7deI5oJHEBvJtEtRtbawcCiI9tRMnpFXtMIKxQFKFL79XFG6QwjLPhq57i0OBkwUg3Rk3HgBd7H8HV1kGE08aVvoW+G+jHqYHV6bUUTKI5P66ylWXV2I2rBeVeK0b6fE958h0ztenoCRx+giKYgSSvvpTKM66nF7zM5gql+Hoz23D1pYd8CIwBlSpnlTRmq8uxuU6dnGtGK13a1rEqWeNs8YYvk2BNC2LJ1IpidjRnG/pKKFXzE9Gz9bJhKPfygfx/ZcsZXsVv/vvrEPI1e7yofnJ8R2ATvZcLPZD128S8AbD9LFY39S1670NIACWhg7bqVsflM8zIvDN5Kt2YRqExo0xUVS4HiaIowpJIFpMnw/z98SDzG4n7CkkvJhwE01x9gKjmesVlhatIshaL/fIhKZMpOGCQjjKoGa1WihzJo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199021)(40470700004)(36840700001)(46966006)(5660300002)(54906003)(70206006)(81166007)(70586007)(8936002)(41300700001)(40480700001)(110136005)(316002)(8676002)(426003)(2616005)(4326008)(82740400003)(44832011)(36860700001)(336012)(2906002)(478600001)(40460700003)(356005)(47076005)(36756003)(16526019)(82310400005)(86362001)(26005)(186003)(6666004)(83380400001)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 20:06:21.8203
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 119ae2f4-034b-4003-e236-08db2efebc5b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7357
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
index 61902f99e0ec..e525af4b3f24 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21957,6 +21957,13 @@ S:	Maintained
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

