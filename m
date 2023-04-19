Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A8B6E801C
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbjDSRGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233581AbjDSRFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:05:38 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E25E83E1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:05:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xh8+eSmRtZ0UBSO2hfgOa0tgkLXMwhDn7BcgaiBfo+4YKVuEC988QJKAnoTQO+5R3AAGPVgsMvuTsz3MD6koH4vLVAjhW+ruJ/MmhbrNnN4oeQZP0BctFRagg1a6IghvHL6+yP5xitVp7jFwsorsPyofrGjRhSFfOYBey3WgiGVgNkif0ZEpn0eb+zbcwCbp5dqFH7T5+MBt8f6XtOzKBKCKxQ+isKJHdYSa48dBnbKkoNVUVuj/dDgpD7j79BesGx2GAeVoxOeFSsLfzIkshREl3yeh4y/Krfqyvw3XhjrSXjxcURS8RokJktBP6KY0DF1z2+qc6wffHQTOTwRwIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B6784rB0wVkn5o1sJEtxuxU1XHv4sVYesaBR8fDkmmU=;
 b=JnnzBWBBpWkGrCwDTShhxkvq6m3BUIpdv4SU5AEJY/P0L6ExlY1qhNs/3TN3AcYU3r8fnYzhlz+uYxCpSrRfhhsmKOZd7IOkphFo0kTmWN5w+Tj17AnTdOG3VduLL/2J83rT8PAleFIr5/WidOArsozEY0Nt+4QmOpjRk0Zgjh1Dd5P0QZQW5kmhOsXkjOZ8WoRQPs6Bkst7w4ne288MgkJWUhPbzTN3GQpivYSY4eNgbakyPXdB3ZAGb4pczLlSojKTQtPra7+J0zSt69VHubDhao4ffE2/Q3q70FKnX7dWdZRhFADNiTRYIQUlDOuP6TicE4qaBytRwYn/zgaBxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6784rB0wVkn5o1sJEtxuxU1XHv4sVYesaBR8fDkmmU=;
 b=3gTxdvyfcH3zzvZ/lhul4Zg7rN0LFbhJenbjY3Laa9uPqPMzBTs8wYs8RwasgvHnZNiSCcb4vyHGFEI+bpKL+F68j1TdfDDaIiw2YByIX8lcTrh1woUze6ru0YwNhbFtLRPnEJgyTUVnycgcX9DSh1XrrCyOS5cmUPpaX41MWeA=
Received: from MW2PR16CA0005.namprd16.prod.outlook.com (2603:10b6:907::18) by
 CY8PR12MB7657.namprd12.prod.outlook.com (2603:10b6:930:9d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.45; Wed, 19 Apr 2023 17:05:34 +0000
Received: from CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::5d) by MW2PR16CA0005.outlook.office365.com
 (2603:10b6:907::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22 via Frontend
 Transport; Wed, 19 Apr 2023 17:05:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT071.mail.protection.outlook.com (10.13.175.56) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.23 via Frontend Transport; Wed, 19 Apr 2023 17:05:34 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 19 Apr
 2023 12:05:25 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v11 net-next 14/14] pds_core: Kconfig and pds_core.rst
Date:   Wed, 19 Apr 2023 10:04:27 -0700
Message-ID: <20230419170427.1108-15-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230419170427.1108-1-shannon.nelson@amd.com>
References: <20230419170427.1108-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT071:EE_|CY8PR12MB7657:EE_
X-MS-Office365-Filtering-Correlation-Id: f3b9458a-7341-4fb2-aa4d-08db40f84a4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bL3kMYZVebg/aknaYQiuzhl50WMm3pZuRAFlJ6PVoUJYzLljhqCieeEB5zZIsVxSwrcUR2yGD97+SjZeAEhJk3gEB0tTMjCMxlQDn0QtPZeWghES+QX4N+zxHh/kmzt5UNFEXLirM+NsE1BRoAdtxZNaUinPKf31FFmJAhx03FpBU67iBDQ6d7G+Sjce2GK3mtJiVfxyl48Lu3Sm/2xaybIDLEmVWXM29/zCkukPIsDUjKhr0R/ECPOoTXBOcQAEjk/FhDJ8N+U2QaeZrWuda8cwIqbdcvcjDFfK6GJQSNXzwEGPEjLfmBYnYOCAX1UEFQkLZIhbTXUE4oFbAn48LoTO01ls5NHRumZG0vCCBd0r52SqSUa5lkgo+aHZYYX9gxtTxrproWBhZFQeI7tYO+i8iSnzXkvLf80h13yLQDITF+ex5v9G7JUawUYTNmI2nGt96+rbD6qKC4WavM0zg/7mHtzgaLVr2HQvavArjCchCqlboY+OUIQYJDwPdp9WtKeyMPfMya0C722hCCZILShNTgx4CNXk8ZUXs2bpET1FQI0GTroRh5zQOjEEluEmxTYHVaSYiqaXklN2Se+/VjNfrVicmjPinlSWlgGoT3PxY8PCQnM4oaOICVvaR0FRamyDwCn0GQodL2S60tOLDEjLRLmmIyeZDLzod7zoiMb7h0uF6eLqycAs3AbJaZ9AfW+g89i6ilKjd2nu3HFYudIf52OC7m6zlNcWzq0TJTo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199021)(40470700004)(46966006)(36840700001)(26005)(47076005)(2616005)(426003)(336012)(36860700001)(1076003)(478600001)(110136005)(54906003)(70206006)(70586007)(4326008)(316002)(44832011)(86362001)(186003)(16526019)(36756003)(41300700001)(8676002)(8936002)(5660300002)(82310400005)(81166007)(2906002)(82740400003)(356005)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 17:05:34.4034
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3b9458a-7341-4fb2-aa4d-08db40f84a4b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7657
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remaining documentation and Kconfig hook for building the driver.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 .../device_drivers/ethernet/amd/pds_core.rst     | 16 ++++++++++++++++
 MAINTAINERS                                      |  9 +++++++++
 drivers/net/ethernet/amd/Kconfig                 | 12 ++++++++++++
 drivers/net/ethernet/amd/Makefile                |  1 +
 4 files changed, 38 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
index b9f310de862e..9e8a16c44102 100644
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
index b8b275e27cdb..2d9a95cffbb3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1041,6 +1041,15 @@ F:	drivers/gpu/drm/amd/include/vi_structs.h
 F:	include/uapi/linux/kfd_ioctl.h
 F:	include/uapi/linux/kfd_sysfs.h
 
+AMD PDS CORE DRIVER
+M:	Shannon Nelson <shannon.nelson@amd.com>
+M:	Brett Creeley <brett.creeley@amd.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
+F:	drivers/net/ethernet/amd/pds_core/
+F:	include/linux/pds/
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

