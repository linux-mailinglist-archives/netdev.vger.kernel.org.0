Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8B96C5496
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjCVTL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbjCVTLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:11:13 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE975D881
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 12:11:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMBP1Z/HCSpBOdCooZtOk9HxfzSbB/h7T4aqwMrZIKd6xbnGSvlVTSqfAl0nmPdmoGiRHtKo+BzK54JSs676X1yeoChoe2deTL3jyNhsX7y1xVemF3Nyj8J4eZ7WFZTT1vnvB/UlFZr7XH3tqkqfhB4pAE2WvBl+5HS5WeeJrWliD3Vw9SZ4PwJHxZ3lc1J0Bw9K7jsEH0hl+ef+krb4AJeB8syTKOZUoRQ6ZGzfrnAu/pjB25ZppjcYw/WJbiBzAaXt4TnQ6oXp6Eh2YR9qjwNtV1LtQsv1MrQwwNeyMgoyrcepd4Bn9xWMapSSKA7ybV+eJ1uDKDl+CUjuQMnPYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8TqqbkopQsY8FCmwxla/MjlCA0GntRPA2Fhs6+Z/DtQ=;
 b=GoQtZ61gCubGT1TGEzZwPz7xQWqHMbX6nQEExDVc2WzLuLsyLdO0zZyfPMLj4BHVHjwj/S6j9KdLt36mjBSfvlKf1xO7P2IupDk5FEDddqj5au02+kJmpnt9zTYDl3GgpNOZyhXxeDryp0+Y+9FyT9JRPIjIf3c33jF48bWSvU3SVERc83jgqQnK/WR6Tfa5bNKhRSfPAVmPYEJkgHVnXxxqiTOsFjVl/mLuPvsJ2y5FbikyrXhHGcihwju9F4u/41+jgc/KeS/Byu9dI1FiqTYE1dA/hBIGg5xx2kTYzI5sMilYJW/bZW3PlqCXlkj1BADtQsHjxUTik5hQryPPlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TqqbkopQsY8FCmwxla/MjlCA0GntRPA2Fhs6+Z/DtQ=;
 b=epFDSaa034UikDbk9mmrllW5J0M7DKpPwRCGad9DbT1KU1e3tpmp4QxjVaL77TA7G4EQJZgZQV7cbTgQ0kfMdjLL1VvOT1kdpAuhKrbmoQtjtvPNEF5etAMyEUY6fTyiVETvPOQFwEw4DOJ9wJJMPOJEyK1ZJQTnMPSo10mFPUw=
Received: from DS7PR03CA0278.namprd03.prod.outlook.com (2603:10b6:5:3ad::13)
 by CY5PR12MB6345.namprd12.prod.outlook.com (2603:10b6:930:22::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 19:11:04 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::c9) by DS7PR03CA0278.outlook.office365.com
 (2603:10b6:5:3ad::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 19:11:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 19:11:03 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 14:11:01 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH v3 virtio 8/8] pds_vdpa: pds_vdps.rst and Kconfig
Date:   Wed, 22 Mar 2023 12:10:38 -0700
Message-ID: <20230322191038.44037-9-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230322191038.44037-1-shannon.nelson@amd.com>
References: <20230322191038.44037-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT004:EE_|CY5PR12MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: da089c73-c6c7-467b-d8cc-08db2b092e8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7DbbNENGlrCp8ALYvvLFkudWdIbC8KrFTz+E+K4UmOze1wvnvettPWLBCYvFge/Adnsy9ccCO4kDtIIcIuqdykShWC/NfXFOPsOmifpXEb4Oy599R0UBUJI8AOESevqclPmbC6o/Fexr/Pty4v/rJMCrZuKfl8+vUCNtp438K4I5IGguzLAgV1TX2OyQfhOrIo+7FUNMthoByCt/nPA2hrzLnSYuhafAuyE4fq+RmD3+6QLWLdfJzv4G7Uc52Q5D2CaUwNUc+CC/q13Kdyjrb6okE9Ss/uaaz2yEBulFwfq3YvxilSRAjoHmEIHU5zHyL3lAZE5jfDEiuBgPXvOGBjDfVaaRzJ1oeXgasIBnNCeD+zU1vBET24zYolExAbBbqZYwuC6HPqVXe5CH6RbrEXswlRSjI9QmqqSdkdbT9oVI6cTPY/taJvABXCD3AkbLGiecQIIAPpCFVeEcHMhkLoYONXu6Erhbb1M58rk9/Di74vQTLBlVj3wFBT7mIbQ67ohPp9Phv73gTPI+cQEjy7lStSKxQBJLWOqv7QbxUVaul0WYuo6he1kET/9qSCDV4qnziCXVh2cZxUNoCYNOeRSiXrgKxKbVgUkq344ZQwc4Wl2CUNbVlXdSYzOWBmBG22tv663iSXvjLs84W1SAfe41Oux0Y7I/u+omU3aY5blndc+H3rMufccaaMBaMj60839lXVNSE165rKH3QoLqaUJFSoSKrhYFOfJMaOp5Udax1ZyG6BAWWhXE0hTqph2Ahf59bXFD7pivbh08NnQ82w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199018)(46966006)(36840700001)(40470700004)(86362001)(356005)(2906002)(82740400003)(36756003)(81166007)(36860700001)(41300700001)(44832011)(5660300002)(8676002)(26005)(40480700001)(4326008)(43170500006)(83380400001)(2616005)(110136005)(1076003)(47076005)(316002)(186003)(336012)(16526019)(70206006)(82310400005)(6666004)(478600001)(70586007)(426003)(8936002)(66899018)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 19:11:03.6018
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da089c73-c6c7-467b-d8cc-08db2b092e8b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6345
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the documentation and Kconfig entry for pds_vdpa driver.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../device_drivers/ethernet/amd/pds_vdpa.rst  | 84 +++++++++++++++++++
 .../device_drivers/ethernet/index.rst         |  1 +
 MAINTAINERS                                   |  4 +
 drivers/vdpa/Kconfig                          |  8 ++
 4 files changed, 97 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst

diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst
new file mode 100644
index 000000000000..d41f6dd66e3e
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst
@@ -0,0 +1,84 @@
+.. SPDX-License-Identifier: GPL-2.0+
+.. note: can be edited and viewed with /usr/bin/formiko-vim
+
+==========================================================
+PCI vDPA driver for the AMD/Pensando(R) DSC adapter family
+==========================================================
+
+AMD/Pensando vDPA VF Device Driver
+Copyright(c) 2023 Advanced Micro Devices, Inc
+
+Overview
+========
+
+The ``pds_vdpa`` driver is an auxiliary bus driver that supplies
+a vDPA device for use by the virtio network stack.  It is used with
+the Pensando Virtual Function devices that offer vDPA and virtio queue
+services.  It depends on the ``pds_core`` driver and hardware for the PF
+and VF PCI handling as well as for device configuration services.
+
+Using the device
+================
+
+The ``pds_vdpa`` device is enabled via multiple configuration steps and
+depends on the ``pds_core`` driver to create and enable SR-IOV Virtual
+Function devices.
+
+Shown below are the steps to bind the driver to a VF and also to the
+associated auxiliary device created by the ``pds_core`` driver.
+
+.. code-block:: bash
+
+  #!/bin/bash
+
+  modprobe pds_core
+  modprobe vdpa
+  modprobe pds_vdpa
+
+  PF_BDF=`grep -H "vDPA.*1" /sys/kernel/debug/pds_core/*/viftypes | head -1 | awk -F / '{print $6}'`
+
+  # Enable vDPA VF auxiliary device(s) in the PF
+  devlink dev param set pci/$PF_BDF name enable_vnet value true cmode runtime
+
+  # Create a VF for vDPA use
+  echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
+
+  # Find the vDPA services/devices available
+  PDS_VDPA_MGMT=`vdpa mgmtdev show | grep vDPA | head -1 | cut -d: -f1`
+
+  # Create a vDPA device for use in virtio network configurations
+  vdpa dev add name vdpa1 mgmtdev $PDS_VDPA_MGMT mac 00:11:22:33:44:55
+
+  # Set up an ethernet interface on the vdpa device
+  modprobe virtio_vdpa
+
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
+    -> Network device support (NETDEVICES [=y])
+      -> Ethernet driver support
+        -> Pensando devices
+          -> Pensando Ethernet PDS_VDPA Support
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
index eaaf284e69e6..88dd38c7eb6d 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -14,6 +14,7 @@ Contents:
    3com/vortex
    amazon/ena
    amd/pds_core
+   amd/pds_vdpa
    altera/altera_tse
    aquantia/atlantic
    chelsio/cxgb
diff --git a/MAINTAINERS b/MAINTAINERS
index 95b5f25a2c06..2af133861068 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22108,6 +22108,10 @@ SNET DPU VIRTIO DATA PATH ACCELERATOR
 R:	Alvaro Karsz <alvaro.karsz@solid-run.com>
 F:	drivers/vdpa/solidrun/
 
+PDS DSC VIRTIO DATA PATH ACCELERATOR
+R:	Shannon Nelson <shannon.nelson@amd.com>
+F:	drivers/vdpa/pds/
+
 VIRTIO BALLOON
 M:	"Michael S. Tsirkin" <mst@redhat.com>
 M:	David Hildenbrand <david@redhat.com>
diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
index cd6ad92f3f05..c910cb119c1b 100644
--- a/drivers/vdpa/Kconfig
+++ b/drivers/vdpa/Kconfig
@@ -116,4 +116,12 @@ config ALIBABA_ENI_VDPA
 	  This driver includes a HW monitor device that
 	  reads health values from the DPU.
 
+config PDS_VDPA
+	tristate "vDPA driver for AMD/Pensando DSC devices"
+	depends on PDS_CORE
+	help
+	  VDPA network driver for AMD/Pensando's PDS Core devices.
+	  With this driver, the VirtIO dataplane can be
+	  offloaded to an AMD/Pensando DSC device.
+
 endif # VDPA
-- 
2.17.1

