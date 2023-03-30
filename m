Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE656D0EB1
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 21:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbjC3TYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 15:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjC3TXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 15:23:47 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2050.outbound.protection.outlook.com [40.107.102.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B88ACA21
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 12:23:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TEcFiAyWllKEA8gBUVsg0jTZD2PzPX/KulS9xzS9Z6wek23FHajvEbiVoMWrXPBm2wJDaE2vBrsmIVCwSGBJk/HMcKeEyGbDWQV2YFb028ikSGjf3YX7Ix6PzWYLdGassZekpKz8B+/e280687LGAPLjtS8DrGPqYOYoX/E1MCHkFUWoZNhakO6OBPsOifG0z2qyJDB73EujFkeQZeyKe++cd06HMHEcphv5wHGdiXhSd4VVcu/EjMPsX8Qs30vHfSObjSCKL0+hRqZ6VhMzFRKhWFib8SzA33FWVqt+/0IbZtUhksawAyqUUH92RRwyF21fln+49gNDQ7/a4sCmcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GdauOXbNxYEr+krtuT0i7yJtOeJ6mi7166LfZ6jUSks=;
 b=VPXTfO0vkssJpGhweJggOycOe2oDg5F46zWM/x8WojB/cMuaTtOHvhpzLLgl3h70jVMo6EjvvmeW7Sb1BAa+jzZq4uuQc5ZHHj6fkpC3+MvpyZUgs7/yKtTJZRGjh8aSexkENc4yFTlrlqoRmQ4ploJ9VI2WIEuq5lggkDHld3XQgEGqdW94ZbcuxAqpy5qpAnHdoRqNemaHjFT6VXxoeYHiq5obMQ5CTak9igcyo9bInbMZvYllYmXmO2n6TRyFjRvtIVQMdUmcxIpLgWhcfiRdqMCKEelGxp9+llgD5gxdSqywFrESrFcjtjpXQ5DcZEWHH6Pv804CBgB4eZUqaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GdauOXbNxYEr+krtuT0i7yJtOeJ6mi7166LfZ6jUSks=;
 b=F0V+Er7rZ+jSDPeFKkw/GjTnGgMCFC0JVg0gjpwyqy1iaedQ+DwykKVUIoBDZYvQNzc9rjeaCCx/7RqoQeNl8/c8tdkJcC+z1ADkQPpIOYEx4J7equFNRMoHZ8jiXC9LIT6gcjCxFtBd2Cc/HX2hkrpqQjd5bF9cuAhSqgZb7DQ=
Received: from MW4PR03CA0041.namprd03.prod.outlook.com (2603:10b6:303:8e::16)
 by DS0PR12MB7653.namprd12.prod.outlook.com (2603:10b6:8:13e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 19:23:43 +0000
Received: from CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::10) by MW4PR03CA0041.outlook.office365.com
 (2603:10b6:303:8e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Thu, 30 Mar 2023 19:23:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT114.mail.protection.outlook.com (10.13.174.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.22 via Frontend Transport; Thu, 30 Mar 2023 19:23:43 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 14:23:41 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v7 net-next 14/14] pds_core: Kconfig and pds_core.rst
Date:   Thu, 30 Mar 2023 12:23:12 -0700
Message-ID: <20230330192313.62018-15-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230330192313.62018-1-shannon.nelson@amd.com>
References: <20230330192313.62018-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT114:EE_|DS0PR12MB7653:EE_
X-MS-Office365-Filtering-Correlation-Id: b95702c3-8d16-4f85-c64a-08db31544685
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mviYyTLJnLhmP8q8JHcJ6ES3h6qDJdFibpYgNKcgqSqZDhERtGSDG6DJ/4k0+LHx/06FECL7EO0kjI0/BqdimGDFp96FLifqz+C/gin17QOmqjyJIJrIzqb87xbrRYhSufTnpbyA0GI2eH+DbOLTNvdh0dFgm+GEkSn6qGHPoM1p4/sWU1xbMQqgri7VkPhAXFuZG8A6T0uHd8PvQRTaKsDmhRPUGoRxfqClIeBJIzpd/94z9qegjiguiBu0iXmvP+gnG3dYf1ADCcVbPTg9jFK+U6ESaURy1IszSmd88jYKzyY6nUJrBeJbMvUVii2AJLiEfsNTjtSEIbMQ4MXBEb6OL2LcUhU0MBSHQsCJ/ONz4xrcr7xvktrhrCaThKTzpMpV96kijnvTrXIOwKhvhs4wk4vCsoVpRGfMt9a69tVeggRckpCJA/5lE1rrz+wSPY6pvJxCzSgs42bLEgKCeHbk4ZK41Z2G9vo/TnKe8Zks+jSHmH7hCWomHU7zHAT7J4pc0A+O/pcPHMBs/NgeoMN/30X09sUAvcbQsox6plETQR0Rwv55dQlxSgGRS+Gyp6Nxth+OdmOJn5qbaXMA2Q8pE4m0Pd1ycYDRyATU5JsCCcr8I2qqSDUYQOwoyYAvaFsx1hE8Ta42bxPvA4577dAFfuxWcA7gylSKCzP0WO8qvJ1sZo1J88kvDe/3VY/cOQx9GE4SKPZ7tr5y4wYIVkdcZzZtkRBSakwosjf+9WWFAd2js/0YEeTDK7/BSbYI6d7oQ0zlWx08EypygcBcQw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199021)(36840700001)(40470700004)(46966006)(47076005)(83380400001)(336012)(43170500006)(426003)(36860700001)(2616005)(44832011)(26005)(16526019)(110136005)(54906003)(316002)(6666004)(1076003)(186003)(478600001)(2906002)(36756003)(70206006)(41300700001)(81166007)(5660300002)(40460700003)(82310400005)(8936002)(356005)(86362001)(40480700001)(70586007)(82740400003)(4326008)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 19:23:43.1524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b95702c3-8d16-4f85-c64a-08db31544685
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7653
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

