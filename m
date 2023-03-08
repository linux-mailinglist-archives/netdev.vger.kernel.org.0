Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4AC6AFE57
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCHFZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjCHFZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:25:29 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2081.outbound.protection.outlook.com [40.107.102.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A93EA1015;
        Tue,  7 Mar 2023 21:25:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTj/Im85wAzPFxUaMD76/Jj/3qa4EKCB+z5snSQl5foUc+lkdaxMuPkxEkyScbTztg7VMcVoLVTOctFSive+sH+vy/fIXblj6+Mmy+hhNY71NGk7D6/tRifJvkVnHukO4bd3tzbfkCadAKiSodAZcnifcCSgiyL59LkOg1EW0zTT22qHlkmRKsBUrsvT6yfPNudx+Bc9iEsYJtHptXsfHIT7UxAq2UpEPD7mbLARaguNjKuDZzE7KXXWsv6OFzLm554fLW14EOn6NgXLEdTzoWm5ZZcvaj5MwCYqQjRNlhOCssEcHd9XsPThE0T9rmQazJxZ2odn9DKGwPBsOQqErw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7SSq27ecIS1HmE7iwShe5NAiUkVQFdyDGPe1bJ1Mz8s=;
 b=FWLMEUZlwgs8xqypax83S3X+kWjXdHiQGOk/YEWSRQ2U6hBFaqgnui3oaBb57gF+ydS3swXvFfo1c9S5pdMUcV9NZk1RgyqkPRf/Hc2djItKGDQW4GBXhlRbhfoFqJj/KPtk2pmQz/8ro4pdvrFRPU65wEUIftG4p0wvI3ZKeK0MWr9mU7/wL3lsRdGsrVzTHkWKy23vPIXmBgDsoWqmHFOKr0/3yLi9FhO2EPh9Li5mADunOGIzpLx/XDbilxSRCH1pizXkRZ2geHVIBbIhv9Hn3zue0h268u+lUwiMsYVtAjeOclqo8bZ/YRDoKwmWtPYO53QXl0e7OSex7dZAgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SSq27ecIS1HmE7iwShe5NAiUkVQFdyDGPe1bJ1Mz8s=;
 b=zpuL9qhaDKFEd8DzSQo7N2L+tMrQK2DCJ3CoHulO2Y9dJvmW3M3wBzXA5MfPS+RNbW7sNsX/6exE+8Ewwkfs//ugyestT7dkAf6CSGlxqfbpA/FFt/5KkiyXN/LfqWmnv63Q1yGFnpjAPhfCVkDgxUHlM4P5Y1Jyxm6BgQYqsjs=
Received: from BN9PR03CA0269.namprd03.prod.outlook.com (2603:10b6:408:ff::34)
 by IA1PR12MB8495.namprd12.prod.outlook.com (2603:10b6:208:44d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Wed, 8 Mar
 2023 05:25:18 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::ff) by BN9PR03CA0269.outlook.office365.com
 (2603:10b6:408:ff::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Wed, 8 Mar 2023 05:25:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.16 via Frontend Transport; Wed, 8 Mar 2023 05:25:18 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 23:25:16 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>
Subject: [RFC PATCH v4 7/7] vfio/pds: Add Kconfig and documentation
Date:   Tue, 7 Mar 2023 21:24:50 -0800
Message-ID: <20230308052450.13421-8-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230308052450.13421-1-brett.creeley@amd.com>
References: <20230308052450.13421-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT052:EE_|IA1PR12MB8495:EE_
X-MS-Office365-Filtering-Correlation-Id: c0fe47a6-1b6f-456f-6845-08db1f958129
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: af6hKpFruq0pI/y7xQMGLRA2EVxNMnvrJUoee2h+cAhA9CKGzy13P3zrzeXIY/53N7SL0euRewI74+VcjGENpY6VJq/uoXvgEA9SxnD4mRhO37gNWnh15Tw/+qff3fdiFdd1ZnUoFwbVr5De/dmYMhqtpNRQbFhfptBk0HVM81Ju1AuLGxJRVURnzydntT39h4EZ31cJ3p4tvmG74udv+jftfLPD8vrE+w3mmjGtbEKwEmFVgSmX59i27r9xFsEOAAmxXeBFcp9JipIjaLPoB1qRczmKgABQvZ0fpj1zG675Lb9s/HfZjWfUm7gqoMCcgs3WiDyXP357VsjBIQ+SEKeODVItVjk9n+Fcv4y6cm+Ade/vxVkQuigzV+5tRZFNIpoQBPbdCYBXsX4rr2GTdOzhOq9nZMa0Gw1UAPzt4pfW9Q5VVzp+xans1fJeW2aZGsRYGJA1xBi/RU+SH+9klmVQayHGs/jSgPT5b1Ve+4ZvPkhI8xnwFvZWDsrJZ3aSshk5sndA4l09SI1btnv0IMTZ/rtLQyKHVu1Ft8JuueF0BsRdg9B9lWHPzgHvzYshEog1ikR0kSG53GD0+GOetn/1W+r4cJYs0vMg8VQc6ViGS1L5R3Dk6pJW3gY3zB9ORgJMtGyoRh/eId7kKT5x6vp97PIWstMHWBYwGy3R+vxZiKTaJWw+CouTHO1M+prhSUePnwn70iyOAMqRdKRHqsQ+1BW2kClEXGf+bIwS1qk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(346002)(376002)(396003)(451199018)(36840700001)(46966006)(40470700004)(36756003)(316002)(110136005)(336012)(54906003)(40480700001)(82310400005)(83380400001)(86362001)(2906002)(70206006)(16526019)(40460700003)(186003)(41300700001)(70586007)(5660300002)(82740400003)(26005)(44832011)(36860700001)(8676002)(4326008)(478600001)(6666004)(1076003)(426003)(2616005)(8936002)(47076005)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 05:25:18.0151
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0fe47a6-1b6f-456f-6845-08db1f958129
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8495
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
index edd3d562beee..19dc26552a04 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21954,6 +21954,13 @@ S:	Maintained
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

