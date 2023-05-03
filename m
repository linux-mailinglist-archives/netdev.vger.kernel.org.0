Return-Path: <netdev+bounces-205-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C7C6F5DBB
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 20:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4A821C20FCE
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 18:16:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA18DF55;
	Wed,  3 May 2023 18:13:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA57DF53
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 18:13:15 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A9C76B2
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 11:13:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=If4WybWdHTe5VPsufhxN8vk+O4N6gVHy/nAN35pIa+4w3tkj0dcTbyyXDRCAOFTcZwADJ0Xay4OROVDjmAfkqx7wOs1xljv5F45nQic96Yu9eVS2PjS6tLnF398Sk3vDPeQ6bhyVNg7NSqu/Ss4IFR1OdQ4xq0cqZEiaSEwBvPvaOfIsXmTVYuj9FdPkNbPDCi39Zr8vioTqrGoorijw+S/9lLgZQ2+8qdeNyYCXweps+y6bSYvKUlQKF6iHrNOug0sDoEpHWKfL+TARJPlp59+Yt0UPQWzVpolUrKLN0BckbN2B6H8lIF/7DSCLcEaY58H9QcfJtW9/cp7YsdmtfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G4X7BYEh41/agJMATD7dH6YpPYWIFHkmRU6JZ29VbMo=;
 b=UPw7QSSjF8b2cTaf4IdTaf3VlMiMolTy5AvYFYrMuUDoNRNMeCJRTIeYi3+gr/hUSSWW4mJJ0MimQyDUE2OKce9rghEO56ZZq1YvlNV2tWD8QkG2BPFw9/kBD54KJs/Dx7HnortmfsylvhpTHKgsU8U52lSldZYaF1AO+vvH9HC+pzXrIdR/pxBKNFuc927cdZIxP/reERElPyC8/jqO4m29qCHx42oDOIhRrpAS/AjHo4vdR0xRwxXbtpfQWxSpFVVElvA6Kuja4Ton/i8Yc2CxpLcBiLAhOUUgiJiPNd90DevwqHHPRHHBqKQV1ZhL4zxGtkFXwLP+um/brKNtFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G4X7BYEh41/agJMATD7dH6YpPYWIFHkmRU6JZ29VbMo=;
 b=QSZLU1v+WT7TwXdty0yBp+vg3RKjPnd7v86osuBvBLdUs7ymFT16UQyW9Xt315wwVro74IlarAwRAizxjFkwQTaSXciuja8m/cKq1E8qzsPYSX9BUMmc5LEwCeLqZZ+Sl9ri3D4xYs4bb3kPv+Oqfymqa3an9Jo5CsbD+mStzc4=
Received: from DS7PR06CA0018.namprd06.prod.outlook.com (2603:10b6:8:2a::9) by
 PH0PR12MB7079.namprd12.prod.outlook.com (2603:10b6:510:21d::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.31; Wed, 3 May 2023 18:13:09 +0000
Received: from DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::51) by DS7PR06CA0018.outlook.office365.com
 (2603:10b6:8:2a::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22 via Frontend
 Transport; Wed, 3 May 2023 18:13:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT030.mail.protection.outlook.com (10.13.172.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.22 via Frontend Transport; Wed, 3 May 2023 18:13:09 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 3 May
 2023 13:13:08 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v5 virtio 11/11] pds_vdpa: pds_vdps.rst and Kconfig
Date: Wed, 3 May 2023 11:12:40 -0700
Message-ID: <20230503181240.14009-12-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230503181240.14009-1-shannon.nelson@amd.com>
References: <20230503181240.14009-1-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT030:EE_|PH0PR12MB7079:EE_
X-MS-Office365-Filtering-Correlation-Id: dea3c13a-1d55-4f33-73d4-08db4c020cfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NP2E5hiZLf1QJqaWFv0WQnv0rljs01KKXOeeK8SEeLsV6tWe1CQIUVvOemdFC6PFBkH1DSqTLnVIG85PAh+3SrdBOI6mPRB8OAxDRIg+kdvxOD4Exq24laY85JJ0pbg8PXKIDDukmvFSbh3iZ5srLCRBMJ83ASucC/lnVAroMvgVyg6ovqhPikoiP7581ggl4k2cvC9ip8rqUWEwlK5VoCjZ3Dw/0ryN3GpvyAcmA/QsMEF8FRzOYHTH3KNYolnp2unhgfkckCukDlkOOXqv1/lIap4FH2H29uftc80/ioqbtq/hqQuAnSdHmyBl0c0lTSidYQg0H09n8Q+h/CMofYV0Z8OtrRXzF5/9KA7+ZOx1DmoLJqWnh6wNFXUsUwWSagdFzJrS+izODECBlaZtZOaKEwEmKG9qFTogKtq600qL9VaJb/8gLI7CRWePK7wWRBUzegB+sM3vm+DqVYJsf8FAYngGcXyBSJ2KD+IASzDrnJwIEGsk4YpGxEYz+mSo6tiotxNGOR8c9OQhLnZu2PstdLes6CIMrmBgMwta6ZLJ3bmHm4Az4rl7viX02nvwUfSvp55mGfS+Nz2XPhs4OitUErO7b1msQi+g7BG9y+cUR5QujnPqQlazD/7rMV7zS4Yff3tOdZpFPGCp296jJYWLfAzgRVMACmg4YOWwYXnn92oq/In0wtz2MXv+91nFo6DfcpOkT5VluIQEDFxM9LLxMF+sqqpkF4Kv6yjvCMl4XloTmBVc/5EISTsPO34Ub5TTED5ZJMXDoxB2GWLicg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(70206006)(70586007)(4326008)(6666004)(316002)(16526019)(186003)(110136005)(26005)(1076003)(40480700001)(82740400003)(36756003)(40460700003)(478600001)(54906003)(86362001)(5660300002)(83380400001)(43170500006)(36860700001)(356005)(81166007)(41300700001)(44832011)(8936002)(8676002)(2906002)(82310400005)(2616005)(47076005)(66899021)(426003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 18:13:09.3923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dea3c13a-1d55-4f33-73d4-08db4c020cfe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7079
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add the documentation and Kconfig entry for pds_vdpa driver.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../device_drivers/ethernet/amd/pds_vdpa.rst  | 85 +++++++++++++++++++
 .../device_drivers/ethernet/index.rst         |  1 +
 MAINTAINERS                                   |  4 +
 drivers/vdpa/Kconfig                          |  8 ++
 4 files changed, 98 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst

diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst
new file mode 100644
index 000000000000..587927d3de92
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst
@@ -0,0 +1,85 @@
+.. SPDX-License-Identifier: GPL-2.0+
+.. note: can be edited and viewed with /usr/bin/formiko-vim
+
+==========================================================
+PCI vDPA driver for the AMD/Pensando(R) DSC adapter family
+==========================================================
+
+AMD/Pensando vDPA VF Device Driver
+
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
+Function devices.  After the VFs are enabled, we enable the vDPA service
+in the ``pds_core`` device to create the auxiliary devices used by pds_vdpa.
+
+Example steps:
+
+.. code-block:: bash
+
+  #!/bin/bash
+
+  modprobe pds_core
+  modprobe vdpa
+  modprobe pds_vdpa
+
+  PF_BDF=`ls /sys/module/pds_core/drivers/pci\:pds_core/*/sriov_numvfs | awk -F / '{print $7}'`
+
+  # Enable vDPA VF auxiliary device(s) in the PF
+  devlink dev param set pci/$PF_BDF name enable_vnet cmode runtime value true
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
index 417ca514a4d0..94ecb67c0885 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -15,6 +15,7 @@ Contents:
    amazon/ena
    altera/altera_tse
    amd/pds_core
+   amd/pds_vdpa
    aquantia/atlantic
    chelsio/cxgb
    cirrus/cs89x0
diff --git a/MAINTAINERS b/MAINTAINERS
index ebd26b3ca90e..c565b71ce56f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22200,6 +22200,10 @@ SNET DPU VIRTIO DATA PATH ACCELERATOR
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
index cd6ad92f3f05..2ee1b288691d 100644
--- a/drivers/vdpa/Kconfig
+++ b/drivers/vdpa/Kconfig
@@ -116,4 +116,12 @@ config ALIBABA_ENI_VDPA
 	  This driver includes a HW monitor device that
 	  reads health values from the DPU.
 
+config PDS_VDPA
+	tristate "vDPA driver for AMD/Pensando DSC devices"
+	depends on PDS_CORE
+	help
+	  vDPA network driver for AMD/Pensando's PDS Core devices.
+	  With this driver, the VirtIO dataplane can be
+	  offloaded to an AMD/Pensando DSC device.
+
 endif # VDPA
-- 
2.17.1


