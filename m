Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367846C858A
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbjCXTEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbjCXTDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:03:52 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2069.outbound.protection.outlook.com [40.107.101.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B989321295
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:03:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiaRSut72uvxN//MUIGzJAVBhThN1CrDfk1tHvnYbN2tTAWGq3U7n9rMCitjvVB/hLQ3rKYWsIq7Kxhs5PCaWd0dQB8bWZUiARgAii6EVHGyhiyjFPgCDq+bFoYCi89Q8NxYxu7ue8KmhevpNAcMauJnfejcMkDfvSxuDvTTTxXiyOlwMRcVIL+s/RD/dmO37M8p8r8AnoU84Lxg3WJEDxeAWB00yCfZvQDijuJfihWG3UimcD7KzLgw2gm/esHQXPOYtoZ9kvs2moXTpFSouh5G5EQyNDHK5LXX4ji1eeeB/CP28IQ+zP+ei4Z0WAMrl04LLEycdJYer13LNyzXaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GdauOXbNxYEr+krtuT0i7yJtOeJ6mi7166LfZ6jUSks=;
 b=n3xsRbv+WB1/LbJye+wa6sWGBuPDoNPOdjZzmi0zh5W+Rz0S9C82jNHkKa1+qaCqdVgfQBPJtqC2qvYwxcSDnJodz9PbFX4JwcSKfl+QQCidElu6PvwBc0sP3s12PjyXkDR2RprTbRJlOUHl1hiejZaBjA6fUYy7jC4yU1a47/lY85OUN/E+SDgCNJRj9nq7Iczh+mSZR7OCEkxEeA+h5MWu85sZKw5MqKzSlN1gdHizAcTGhNd6qKKAlyZKxMaGHpWekCA7SxeqXBs19l3eOLezx9hCWebKhawFnxB66jDuVcgsCfFkhXbr3g6OpGItwgFuQOvoJ8lzuRraUBE1Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GdauOXbNxYEr+krtuT0i7yJtOeJ6mi7166LfZ6jUSks=;
 b=qSuMGGpBeF+25CA+vFqrp9fh4/uQiOS8+dw3gRmNNpVjrMfS6Rqu0zflIXUPqHk9UDCEwrmg4gR/85M66Z3X9PN78nzfJQ17nnjZPd3XtTV2X+C4urCJC7M4YtkYewaD8ynSvZbbD+bqwoct8WwnA0jMHEhDzWeksy7lsaqxpLo=
Received: from DM6PR17CA0002.namprd17.prod.outlook.com (2603:10b6:5:1b3::15)
 by PH0PR12MB8008.namprd12.prod.outlook.com (2603:10b6:510:26f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 19:03:18 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::62) by DM6PR17CA0002.outlook.office365.com
 (2603:10b6:5:1b3::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.40 via Frontend
 Transport; Fri, 24 Mar 2023 19:03:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.9 via Frontend Transport; Fri, 24 Mar 2023 19:03:18 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 24 Mar
 2023 14:03:17 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v6 net-next 14/14] pds_core: Kconfig and pds_core.rst
Date:   Fri, 24 Mar 2023 12:02:43 -0700
Message-ID: <20230324190243.27722-15-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230324190243.27722-1-shannon.nelson@amd.com>
References: <20230324190243.27722-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT035:EE_|PH0PR12MB8008:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e669228-3a51-4166-05fa-08db2c9a6e06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IUmCRBUj2TsSATxxh6R82T3ri/ZMlPop6BIHV5/NtNOsZw+Xx0xZdFLkK89w+3Gd87pjh+uNNO/mSmCxIPcfMFpq1jMLEKQI0690jtgYFVFGdGa5oPRyT2yJfWmtEOPrsm8fvL1vBOY5faXRCVJ9IICWbWuQxA2yBaI7aYPsJ+3vUlW7dv2EJ/JAmnYHRNRLALvHE3XgcMYLA5NHE0zvpqbw+5/SJH55/n1JlYwhoSyIQ+aRCrEbd0WbUE6vFjNQ4hUn6kCNhPe5XG+QIPDZMPDdsvbXt2YxBWMeFqrXvQ8DIl+J0MEtR4uZSlEx6vRW+xa6B0/cggwyhHi4DK6J8DDoc6JRO7FPysmeQ0i6qVQYcb0Dz1+4A53bQdRJMbHapXI0vuVHx6+eL73WcNoCbnMMLgYvrslFr/Q0vnbt8Q1M+KItOy6+MqH5C/2njOVFPzVlDw/yx/AGsulM3t8FwtmIAh1+9ZugTXx7AbQpHZTlgOqN0UinL/vR0DpwfyQ3kBCu+qPmkrMQ1YCdD03T7aF0wHk8vHD2i/+Z1Gk55bk1kNrAptVFT0RR4ExofBGRB5Q7ISJ0zqnP4xKHRQL3h2/h/KgFtDrk8JFFK+aCuoCDJLEdWqSapfGLsUPbSwY+qdZI5A8lpHhtot+Bqly/9gCxRC1aw/5AX64l0oyMQwGdil7hOEfr/Bx2pq3kyKrjL3jQeMasAQ++UYjSb181cS9IjE96CQx1tZPFq8nADAHUw4FZnGJhhs8+3G87ExEyCtzFkf1sAHVo8kuIeqFNbw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199021)(40470700004)(36840700001)(46966006)(8676002)(4326008)(86362001)(83380400001)(41300700001)(40460700003)(110136005)(336012)(1076003)(26005)(43170500006)(40480700001)(16526019)(81166007)(426003)(82310400005)(36860700001)(2616005)(47076005)(36756003)(6666004)(2906002)(54906003)(356005)(8936002)(70586007)(316002)(186003)(70206006)(82740400003)(478600001)(5660300002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 19:03:18.4750
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e669228-3a51-4166-05fa-08db2c9a6e06
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8008
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

