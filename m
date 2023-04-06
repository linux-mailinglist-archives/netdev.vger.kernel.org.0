Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B49E6DA637
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 01:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbjDFXn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 19:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjDFXme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 19:42:34 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57339A26B
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 16:42:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NIhRKy/wA3Zbvv0VbAX2omqJgUYeZQmZax3r5dxUA7d8+3B4sUXhAr0BfDITR9Tey/EF6QecpF4cuLLUGFUgyXz9MhYw+ijl9+/0r2h77Ok8kYZXCtt2Nnldw3kDMuiBeqfBeuMQEtrcOfCgn1a3BfoMmSBsE1fenDoqkZCHE/D0Fq4OVcVk5kSlrirScQW2k91fGsK79X7Gob2lcieDGih+vLqA6D/LefIuCYgt7mwUSpyC1Cgnd8qM5pCO3MCENGr/kIrHmx07X4qCf6FklX9Q3zv+IX9YW1bBHEhlaIa5E77FkiKBh2aYqQRQY8xd++OQ6+RdLgAe/DvG4B1/mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iy/QEEllxrDkwYFD1/vakDdm1Ocjn9C1zCqH8QbFlEA=;
 b=G+v34+Dli/HPV5ziIP7kp58dCS8PT6ge4zw/+47qGcqSmNacCISwhQhzhok6hpP6jUpaTpY3wxHZDNVTrblpOAufOHELET3+KZ8kGmOteH+SbX/iNMHtPXGbncGdk10wdb6dEYCyYl34ytq6mTh1dHFMbHgfaeC+kfSnX+DZc/A2hxS9gA8hYOcTOB62v42lB/F9WqUmg8ZKVmmwomLLI+uZUaet9fSvv3n5/5pi7i8vxiSNuex/wpX9N10Co6GeT3R2/ftUW8WBO/dFsrA7wTksY9TON/oy9YqooDg7ztA18HKuOZ19kdfJEKdO+3TAc2c5lFn0QuqJV19yIJfVZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iy/QEEllxrDkwYFD1/vakDdm1Ocjn9C1zCqH8QbFlEA=;
 b=stb7hsyt3+IxgrfPHG/hOTqyT8qtz9CCxtSz8KODKTDrg3i8BzbZ4H4jAtn2HCoFFwn/894YTkfuy5H8RM/B94iscI8O/1bIXGhH2VvQjDRIiqJH1A6TM4brFGoT7OvFkDlsR7fO7F+7RapMZfg7hhWkPFpOGz5JCj/FBIft+Aw=
Received: from DS7PR03CA0240.namprd03.prod.outlook.com (2603:10b6:5:3ba::35)
 by CY5PR12MB6599.namprd12.prod.outlook.com (2603:10b6:930:41::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 23:42:30 +0000
Received: from DM6NAM11FT079.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::da) by DS7PR03CA0240.outlook.office365.com
 (2603:10b6:5:3ba::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28 via Frontend
 Transport; Thu, 6 Apr 2023 23:42:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT079.mail.protection.outlook.com (10.13.173.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.19 via Frontend Transport; Thu, 6 Apr 2023 23:42:29 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 18:42:28 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v9 net-next 14/14] pds_core: Kconfig and pds_core.rst
Date:   Thu, 6 Apr 2023 16:41:43 -0700
Message-ID: <20230406234143.11318-15-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230406234143.11318-1-shannon.nelson@amd.com>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT079:EE_|CY5PR12MB6599:EE_
X-MS-Office365-Filtering-Correlation-Id: 75641cc7-5f7a-4495-3925-08db36f895f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iVWve5FEEfN5/jTAQOB1gJJbbuy2S7Z/aoGwZr/akCzubHoOsMmEWc6HEw4OLDBOBlIBVXnZrIP0b/m/0/5wEq7qHC6wwBObEz8aoQQpzuVYyUcVTYl1h3P5e/BO3AeyKVIEDM+f0ZB3PK/NRxEm5NzEBmruLJdBmxGUwJTx2HnZgU5rKUAA2lftmYrC4MdpEp/SQkAdg2Rsr1/S3VMdB05i0/seJsde5iUifdtRht6JxARou8NEpWAxtJkebDM7cc9Wk6hb/zwFfB1YPcomtAVTc0GYoCDnPl3dNsiXWUvIahcSUmYka/MmQoQgXWLGVkgkiry8j3jW099trlr3ShJLUstcqKwks5sOTV89n4stqM5kZUJu2ZuO7JAGD1s6T0hN0myJj2pC1lrW3T1izkrNBF9+u6ni/fuPVRFTIsy8vM52sEdeGCTeldX87BQZ+ENEy+i4fCOn3X88xHw2laOTL4EIa3LalgrOhzizz+pcnXR4KFBC0UliehR6oJGIRpCJOV/H5na2J2TtIZAMJJwaP0YtlhW1EueXqAIj4Ozb6gFj4384i896KAofmJd7daVwqgeK7hgimwpSg3mR2nhWJxfVuyfU2kIls8ldxHAjDFVPlk9+2V+JDx0HeTJqtCVvdjSH5jZOeqUR+fWU15Q9fruazeIGUjT0X2jPcZSaAWNPmQwM+z6coyTpU9CSRkHwWvejSSSlmhF0Xg45icDo0y/em6QTumLSq8Dz/AU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(1076003)(5660300002)(356005)(81166007)(2616005)(82740400003)(47076005)(26005)(16526019)(336012)(36860700001)(36756003)(186003)(2906002)(426003)(6666004)(40460700003)(44832011)(54906003)(86362001)(316002)(110136005)(82310400005)(8676002)(40480700001)(41300700001)(8936002)(70206006)(4326008)(478600001)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 23:42:29.8138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75641cc7-5f7a-4495-3925-08db36f895f8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT079.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6599
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation and Kconfig hook for building the driver.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../device_drivers/ethernet/amd/pds_core.rst     | 16 ++++++++++++++++
 MAINTAINERS                                      |  9 +++++++++
 drivers/net/ethernet/amd/Kconfig                 | 12 ++++++++++++
 drivers/net/ethernet/amd/Makefile                |  1 +
 4 files changed, 38 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
index 9449451b538f..c5ef20f361da 100644
--- a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
+++ b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
@@ -114,6 +114,22 @@ The driver supports a devlink health reporter for FW status::
   # devlink health diagnose pci/0000:2b:00.0 reporter fw
    Status: healthy State: 1 Generation: 0 Recoveries: 0
 
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
 Support
 =======
 
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

