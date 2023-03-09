Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9806B18C5
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 02:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjCIBbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 20:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjCIBbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 20:31:38 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6041D9CBD9
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 17:31:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOOGl40TN3abJ2AOtF55ZryjU9e7wcCSkj3ySVx1i0N4eFPVTyftV2NYkDUD+h1eA+1Uexf0p66zFaWyXKnzFfblx5Ug6fvZyFGC1xusc5SP64SVQYoZTUY9ioF+p7lusmoK9W/GsLRdcSLktmvNT32KBLMoKEfiY/VOtwhrGAJln3aBNLNSm93rxDngKA8yw3DBaVZZ7tBwHoAT3KM2xuCVHhSqiVxQE0YdXsGXBOpHPOSGWlYWIfnMEosLzUprgq2ZHjJgFUN2ioViT9z9kwAe8w+4eyTjIVDraa4BqoEIdievf++dWmq6HXfctMKdr6dqQ6/QfmOA3UKNs53Gww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l2JQeWYNtO+U9gBSZZTevJ6ONbU1sP/zWCwDLoiOwk4=;
 b=i9GwRSWK/e7zx3S/cYh5r+sEg8R/C4Fzg05pGlBKVOaZq5nIZYB+Q29RTQsQWvhDXbiFn5Hv3BxG1c1kmyCMQj93o4KdUjKXaa+MiwYCqSfRRTpTR7LrL68Y5mCED1WcsONNKaKrbKEsVRc0OiVY8UO9ryFua5AvRmKPyDT3FApWdKGdE9tTV2N9OCE+54RnJK9a7xvDx1jIPfvoA8IkqCfQ4i6aShUqWkvg0nDyEKYX3tBJa4s2/whHUX3VxIjm3iOTWQFPf4usks11Ls+1otihk0eBPAIbVO76lmtjJd+57r9HhuxXjL/dZswN2csL56u00sXXv8YM4X1Ib6p9Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2JQeWYNtO+U9gBSZZTevJ6ONbU1sP/zWCwDLoiOwk4=;
 b=EvdEumesYJ7RzPwNBwJp1iUWpXzVC4m8RK1Cbf8sp/qoefLS9mYK7J315KIiXT5azSnrQOT4zge95+B92BuuQbRDlQGeBzTji65Mj6dIUaUyqE7IXGiDGhq1XBl1jvUswg3pQGjTvysQbBt2Pkwqu0MAh+7Mmz4E1sEsEqBVjAE=
Received: from MW3PR05CA0008.namprd05.prod.outlook.com (2603:10b6:303:2b::13)
 by DS0PR12MB7584.namprd12.prod.outlook.com (2603:10b6:8:13b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Thu, 9 Mar
 2023 01:31:32 +0000
Received: from CO1NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::44) by MW3PR05CA0008.outlook.office365.com
 (2603:10b6:303:2b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17 via Frontend
 Transport; Thu, 9 Mar 2023 01:31:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT111.mail.protection.outlook.com (10.13.174.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.18 via Frontend Transport; Thu, 9 Mar 2023 01:31:31 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Mar
 2023 19:31:29 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH RFC v2 virtio 7/7] pds_vdpa: pds_vdps.rst and Kconfig
Date:   Wed, 8 Mar 2023 17:30:46 -0800
Message-ID: <20230309013046.23523-8-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230309013046.23523-1-shannon.nelson@amd.com>
References: <20230309013046.23523-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT111:EE_|DS0PR12MB7584:EE_
X-MS-Office365-Filtering-Correlation-Id: b1f20e77-367c-4f9e-23de-08db203e0371
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xFZYGLFa7EgaFB5bIFcFCOACTplDckalDvfYGI0kd+wU6zIeL3XXa13IEo5z5WaarUC3zLiW5mb1hEAgPSa06N57rjzRD9GjCNzR5cEWZIzobnTShMwf6CTNB8QvdxdteT0W3JnB60CEw+MLyn9tWeFBTVv0lEtr+lqWu5sVQ4tjpcRT3Dm6dvzFWATAEb92LFh9vKZ6LdzNfN9ceEPSeJu4s5CdZpt1XDrRjZ4rKzoEhs7WI9KRDBLqrom3O+qT6NHo5EdLdBv2bSRyJQzWOW/ISwt2Er54wi9UAX8cnGUZPW/9LYheJgMDhklrWexG2J12Y6Eh6s3xXpvm6yDcD1565jhlRXAmLYlVrCT/AjcVIeJ9AEKalR+9P8RiYXTK4gGPp8BjAy0p8JA7+yuEZcFJZlxdw47P/za4SHkL0dDWIyLesj2K+Uc4lGmetTlbN3MWELJAUurTmYs3OkkAbogK7jxDanGDRfpP1EfINi7BefBN46zvLjmIVkzknvmyJ5U/RDTS00NA3MHwxsPGNeR31MOLtFPKzDHjeVdcbhBe4EL7N2UhipDT5fYk91K3/3Df+8wpzXtm5uRXU5AyhTs02nPBXKTPAKtBagWfWyTuDQVvlYFOH94V3VlvRFNwW31pkRHNiTuCieDFH4j4SlCPZETOwWLLKlloBhpAN2KQ/Xkz0It4BX4wCLhi9NqQdqlHdoNETFspqlTPXfIcJ0ZC5p+lFn7HfYnArLDcHAM5VWjB+UKtO4FIjcHiUPb62gPtxSPlgm58ndqOWMk90Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199018)(40470700004)(36840700001)(46966006)(2906002)(82740400003)(16526019)(186003)(81166007)(40480700001)(336012)(66899018)(44832011)(1076003)(26005)(356005)(6666004)(2616005)(36860700001)(40460700003)(70206006)(4326008)(5660300002)(8936002)(70586007)(478600001)(8676002)(43170500006)(47076005)(41300700001)(82310400005)(426003)(36756003)(316002)(83380400001)(86362001)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 01:31:31.9146
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f20e77-367c-4f9e-23de-08db203e0371
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7584
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the documentation and Kconfig entry for pds_vdpa driver.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../ethernet/pensando/pds_vdpa.rst            | 84 +++++++++++++++++++
 MAINTAINERS                                   |  4 +
 drivers/vdpa/Kconfig                          |  8 ++
 3 files changed, 96 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst

diff --git a/Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst b/Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst
new file mode 100644
index 000000000000..d41f6dd66e3e
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst
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
diff --git a/MAINTAINERS b/MAINTAINERS
index cb21dcd3a02a..da981c5bc830 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22120,6 +22120,10 @@ SNET DPU VIRTIO DATA PATH ACCELERATOR
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

