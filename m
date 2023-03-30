Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692A96D139A
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 01:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbjC3Xry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 19:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbjC3XrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 19:47:23 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAE2CDC0
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 16:47:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PIcDgd+6bBRu9fXtbYNvA788XMUtIeKzHbxjuRcDypdzdwOzuUDDvnG07LhV+84vYRypuNeclC/g0Cl5/iQ3YStMLsuSKagSc4/4bE03JVk50av5GkFkFgGQ76FccnyCKn5rmDm2t0Mm1WSPY6Ot2bhfP9SPEQ8pg2h/xP1LvDxQllM/5tVxmLC30L4kh7nsQxnWb4n2I8yNlDBu+Kd8oWqCeaSTaqrH9aPj9ODwaiBrl9y2rHYtYLgv6QXvMoinPNKUPDdBVUmp4ItnhJXwhTOqCynaVZMA4SH2kFBo8qNhlkhm1HCrnNZYrCxA+nzwtsAEG+wLO0T2Is2u/wyJ3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GdauOXbNxYEr+krtuT0i7yJtOeJ6mi7166LfZ6jUSks=;
 b=S9Dtt85qYemXNd39L3FxKdnkLV/20j43RBwKc9f615lXSyMqCa9Gd8xQI/qmdI/7wqI91pwBBI1NyREgUKJ5Td09JdjvikzY78btTjAeTzRizYq/pJ7lurW7XeYnBxr/pIEd8B70bqXyw2xdWbw2TnC9ut5CwbaHbRP6OIRVe6YWzHgA+hN2T8HN+xvuFeZ8YX7EyGyAMjICFvjX1GmMssPkpxFrG3NtmehKuJ27EpMr7wmbxw4JK2GWPk14Y+rduQN2LNPzb+O6kKLl6Zo/Od0chJvLTdERzJR4D9RZ4UadiqKTnoSp1OmW8HVQcxHqDBAe6E9al84r3Ad8RXOSDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GdauOXbNxYEr+krtuT0i7yJtOeJ6mi7166LfZ6jUSks=;
 b=bPRt+jtay7RA2r+cL+uSPOxBEEwSvE+w06LV28p22jiJsmd3sQCv6YvZZ0XeU7OKhe6b9GXQrjDXcLH1Up0i479GbN7wJhe/UjuRYC6ZLKNl/X7ZNT2Y4H8Fkt13OPzfgWtGPG4WfrG80Kao8EbesGcLOYX1F6hr6XZbvB7kWic=
Received: from MN2PR15CA0017.namprd15.prod.outlook.com (2603:10b6:208:1b4::30)
 by MW3PR12MB4570.namprd12.prod.outlook.com (2603:10b6:303:5f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 23:46:58 +0000
Received: from BL02EPF000100D2.namprd05.prod.outlook.com
 (2603:10b6:208:1b4:cafe::c0) by MN2PR15CA0017.outlook.office365.com
 (2603:10b6:208:1b4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Thu, 30 Mar 2023 23:46:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000100D2.mail.protection.outlook.com (10.167.241.206) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Thu, 30 Mar 2023 23:46:57 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 18:46:56 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v8 net-next 14/14] pds_core: Kconfig and pds_core.rst
Date:   Thu, 30 Mar 2023 16:46:28 -0700
Message-ID: <20230330234628.14627-15-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230330234628.14627-1-shannon.nelson@amd.com>
References: <20230330234628.14627-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000100D2:EE_|MW3PR12MB4570:EE_
X-MS-Office365-Filtering-Correlation-Id: ce51b413-57b1-416c-c31c-08db31790cc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E3tJg2OfHCe38xxAgaHMu+p4udGZ/Ui09yCrJeytA+4V3hkNWUqfafNigLdXohkxCXILYM86t8oHgYlKxFxQtZ8eRLlgYmR9vYa2g/S0F/BINzUzz5qUb5ZEw2SWEKW/goPuLii9o6DuK3F2vzWRqr4CKCG0kPYkP+XN/4k5IjeoNo43aLZ5eibCp28KatFKZjueLbOS0vR8E1dxzMelOTXTmHLRj4ggOfboQailRKpg1izlCSWMxS/wmckTv/SKXsvtgTT8LmyiYIbxE7GB2M8ea/3MQC9uusGVCcPrRVYtxTAPKXDVlr7yptx9074LTm01xsngBikt+E1z5vMc36BZdDE0Mkp1AnuRy5rtTMbbMsvePovcSdWW4JzdWeqI5lqr+52J5IB8O1xcR2tMUOEqUtNBm+g16tWNo/L7HI05bwFzrNjIgnEgtVWuf6UwGqi8OO34iyw6LcZ/7wqwSfqwie7N1OMkC9t6VMW8O8rJpiizrA44kbdaCXGhzqqqqe1ys7IKkIIdwvjLGgvZYQqmR7sdZ6QvZ1/fboOoSE+9uteHl+kchlvC8S08+5mKIgjvXsTKuEJz/Oxcb9bIssnxHRTBwS1bKeR6lLgRBTGISjwtrNrVAzHvpMwcysaoFhEdgbzmm2jKaGfeI2nke1cePRi6QyxemY1ck3Fo1v9+AAWY7cFhrYnySKZIPdDlSOYDi1klw5i3cIVB45dGWAB5SAPQyss+dJXb/9a9QPeM02KSlTvBDj+TwdK5eJLwWRFXk0aiNvjRHPZEAUxTjQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(336012)(47076005)(44832011)(8936002)(40460700003)(36756003)(356005)(86362001)(4326008)(82740400003)(5660300002)(70586007)(8676002)(41300700001)(40480700001)(70206006)(81166007)(82310400005)(36860700001)(2616005)(426003)(83380400001)(43170500006)(26005)(6666004)(2906002)(1076003)(316002)(478600001)(54906003)(186003)(16526019)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:46:57.7941
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce51b413-57b1-416c-c31c-08db31790cc9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000100D2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4570
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation and Kconfig hook for building the driver.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../device_drivers/ethernet/amd/pds_core.rst  | 143 ++++++++++++++++++
 .../device_drivers/ethernet/index.rst         |   1 +
 MAINTAINERS                                   |   9 ++
 drivers/net/ethernet/amd/Kconfig              |  12 ++
 drivers/net/ethernet/amd/Makefile             |   1 +
 5 files changed, 166 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_core.rst

diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
new file mode 100644
index 000000000000..16ed45baa81b
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
@@ -0,0 +1,143 @@
+.. SPDX-License-Identifier: GPL-2.0+
+
+========================================================
+Linux Driver for the AMD/Pensando(R) DSC adapter family
+========================================================
+
+Copyright(c) 2023 Advanced Micro Devices, Inc
+
+Identifying the Adapter
+=======================
+
+To find if one or more AMD/Pensando PCI Core devices are installed on the
+host, check for the PCI devices::
+
+  # lspci -d 1dd8:100c
+  b5:00.0 Processing accelerators: Pensando Systems Device 100c
+  b6:00.0 Processing accelerators: Pensando Systems Device 100c
+
+If such devices are listed as above, then the pds_core.ko driver should find
+and configure them for use.  There should be log entries in the kernel
+messages such as these::
+
+  $ dmesg | grep pds_core
+  pds_core 0000:b5:00.0: 252.048 Gb/s available PCIe bandwidth (16.0 GT/s PCIe x16 link)
+  pds_core 0000:b5:00.0: FW: 1.60.0-73
+  pds_core 0000:b6:00.0: 252.048 Gb/s available PCIe bandwidth (16.0 GT/s PCIe x16 link)
+  pds_core 0000:b6:00.0: FW: 1.60.0-73
+
+Driver and firmware version information can be gathered with devlink::
+
+  $ devlink dev info pci/0000:b5:00.0
+  pci/0000:b5:00.0:
+    driver pds_core
+    serial_number FLM18420073
+    versions:
+        fixed:
+          asic.id 0x0
+          asic.rev 0x0
+        running:
+          fw 1.51.0-73
+        stored:
+          fw.goldfw 1.15.9-C-22
+          fw.mainfwa 1.60.0-73
+          fw.mainfwb 1.60.0-57
+
+
+Info versions
+=============
+
+The ``pds_core`` driver reports the following versions
+
+.. list-table:: devlink info versions implemented
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``fw``
+     - running
+     - Version of firmware running on the device
+   * - ``fw.goldfw``
+     - stored
+     - Version of firmware stored in the goldfw slot
+   * - ``fw.mainfwa``
+     - stored
+     - Version of firmware stored in the mainfwa slot
+   * - ``fw.mainfwb``
+     - stored
+     - Version of firmware stored in the mainfwb slot
+   * - ``asic.id``
+     - fixed
+     - The ASIC type for this device
+   * - ``asic.rev``
+     - fixed
+     - The revision of the ASIC for this device
+
+
+Parameters
+==========
+
+The ``pds_core`` driver implements the following generic
+parameters for controlling the functionality to be made available
+as auxiliary_bus devices.
+
+.. list-table:: Generic parameters implemented
+   :widths: 5 5 8 82
+
+   * - Name
+     - Mode
+     - Type
+     - Description
+   * - ``enable_vnet``
+     - runtime
+     - Boolean
+     - Enables vDPA functionality through an auxiliary_bus device
+
+
+Firmware Management
+===================
+
+The ``flash`` command can update a the DSC firmware.  The downloaded firmware
+will be saved into either of firmware bank 1 or bank 2, whichever is not
+currrently in use, and that bank will be then selected for the next boot.
+
+Health Reporters
+================
+
+The driver supports a devlink health reporter for FW status::
+
+  # devlink health show pci/0000:2b:00.0 reporter fw
+  pci/0000:2b:00.0:
+    reporter fw
+      state healthy error 0 recover 0
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
+        -> AMD devices
+          -> AMD/Pensando Ethernet PDS_CORE Support
+
+Support
+=======
+
+For general Linux networking support, please use the netdev mailing
+list, which is monitored by AMD/Pensando personnel::
+
+  netdev@vger.kernel.org
+
+For more specific support needs, please use the AMD/Pensando driver support
+email::
+
+  drivers@pensando.io
diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
index 6e9e7012d000..eaaf284e69e6 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -13,6 +13,7 @@ Contents:
    3com/3c509
    3com/vortex
    amazon/ena
+   amd/pds_core
    altera/altera_tse
    aquantia/atlantic
    chelsio/cxgb
diff --git a/MAINTAINERS b/MAINTAINERS
index 30ca644d704f..95b5f25a2c06 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1041,6 +1041,15 @@ F:	drivers/gpu/drm/amd/include/vi_structs.h
 F:	include/uapi/linux/kfd_ioctl.h
 F:	include/uapi/linux/kfd_sysfs.h
 
+AMD PDS CORE DRIVER
+M:	Shannon Nelson <shannon.nelson@amd.com>
+M:	Brett Creeley <brett.creeley@amd.com>
+M:	drivers@pensando.io
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
+F:	drivers/net/ethernet/amd/pds_core/
+
 AMD SPI DRIVER
 M:	Sanjay R Mehta <sanju.mehta@amd.com>
 S:	Maintained
diff --git a/drivers/net/ethernet/amd/Kconfig b/drivers/net/ethernet/amd/Kconfig
index ab42f75b9413..235fcacef5c5 100644
--- a/drivers/net/ethernet/amd/Kconfig
+++ b/drivers/net/ethernet/amd/Kconfig
@@ -186,4 +186,16 @@ config AMD_XGBE_HAVE_ECC
 	bool
 	default n
 
+config PDS_CORE
+	tristate "AMD/Pensando Data Systems Core Device Support"
+	depends on 64BIT && PCI
+	help
+	  This enables the support for the AMD/Pensando Core device family of
+	  adapters.  More specific information on this driver can be
+	  found in
+	  <file:Documentation/networking/device_drivers/ethernet/amd/pds_core.rst>.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called pds_core.
+
 endif # NET_VENDOR_AMD
diff --git a/drivers/net/ethernet/amd/Makefile b/drivers/net/ethernet/amd/Makefile
index 42742afe9115..2dcfb84731e1 100644
--- a/drivers/net/ethernet/amd/Makefile
+++ b/drivers/net/ethernet/amd/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_PCNET32) += pcnet32.o
 obj-$(CONFIG_SUN3LANCE) += sun3lance.o
 obj-$(CONFIG_SUNLANCE) += sunlance.o
 obj-$(CONFIG_AMD_XGBE) += xgbe/
+obj-$(CONFIG_PDS_CORE) += pds_core/
-- 
2.17.1

