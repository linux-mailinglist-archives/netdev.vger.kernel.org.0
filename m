Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1BFC6E55F0
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 02:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjDRAdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 20:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjDRAdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 20:33:32 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92DB4690
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 17:33:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVuCbpy4+ZiLEMWa2a9SBcGc+biDyzKX172xQ3GJixPezO4dVTkNhG3FdPrx2zseZfVtR0k6zXl9h0OWEsFvyJYiAxLzqnL9ilaIq4obiY9cAa6rEfI9pgV45pBf7A1E5/fXv4Je7ytP+OcNuUnd9T7ru29x0mzWffTvnG3X8oNULQzSseubBsjF+qfExOciKmlXkbonsxppKkS/T5LQU1auJ9DUM6PvnmX5bsDBLLirXm3+zC8iOXorsTsbisJuk7scYCE+A5EKYlCYGqh0bshILco4/4LGItrGhjKg2+5JX4opvFP7P0JWY6cYei/+BaW0QriwMTYbV4PZ7XxxYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B6784rB0wVkn5o1sJEtxuxU1XHv4sVYesaBR8fDkmmU=;
 b=aRfNWDZcoexDugIjonnMXpgv0ReBG+k6HC6lyvS6Y6g/a5jUoFEq+iZeofMUKv9x/qKlxbaD1Eh4LuifPp22fy6t4zeod0tWaUYycEQCBn2lmouOpRp9d9Fc52EmkpQ2+QxaSh6A6/ItcC+9+gl7FjKYUJgY2XRh55Ud7KyDqgp7XQLrBzFz5NrtCTDw/fwcxe4RkITx1FTmjp4y70PxKpGAHCP5JkWqj0DOWBRCCPgugaoiX5+ZsYO73hubOrD0VrwCLlWVQDu1qzgGUH35V+zsXPl2IFMOzdkQwze2gzB16PF7Ykfu2oWhBFZTaFJ0urTB5kVwHYFLhgfl/E3J/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6784rB0wVkn5o1sJEtxuxU1XHv4sVYesaBR8fDkmmU=;
 b=x68qyzQTCldzpmXBgLoqupZ/LZtWQ9Nl2anIiHwCStMcjkKuNuJOkxZONSGqSH+Ql+Twz+CzLZYdRxRuk5sJLqj7ZKD2FQ3WNJPLbBuiwOGecROBzU3QBBfpFeuov9pQPvK+kSaT4oUwhHn1D4SdisgqfIanWZZ//OfL2PtGjS4=
Received: from BN9PR03CA0205.namprd03.prod.outlook.com (2603:10b6:408:f9::30)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 00:33:11 +0000
Received: from BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::fd) by BN9PR03CA0205.outlook.office365.com
 (2603:10b6:408:f9::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Tue, 18 Apr 2023 00:33:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT042.mail.protection.outlook.com (10.13.177.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 00:33:10 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 17 Apr
 2023 19:33:06 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v10 net-next 14/14] pds_core: Kconfig and pds_core.rst
Date:   Mon, 17 Apr 2023 17:32:28 -0700
Message-ID: <20230418003228.28234-15-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230418003228.28234-1-shannon.nelson@amd.com>
References: <20230418003228.28234-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT042:EE_|SA0PR12MB4431:EE_
X-MS-Office365-Filtering-Correlation-Id: edb9cfc5-af42-445f-d452-08db3fa47cda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ldrSxp4B9c8Exijvuz9IhwKmQE4amDlyTdX49OGe+ht78/3wvGN8JL5H4HlioRH9vuqSgkbkaRvnnypPCf7UwVkB5faaHQNzYyUCiKfdHBemViLygPTttbi2OHEbgaT8lqZN5O7fQFAi52fQYllpp0Rj6jWndXxjqIgtTkya4WsDxa8LLCncobt2JftNcIiMlEieIYyFLcXNLK1yx7GzfNdwpVPeQlbyR2iEatVW+cghuNpaVPRphGT4wh9lLoLtdiOZpxo8wJhDItAAvANhcyVd4D/fgbj3aQdF0wG5FFb8XnS4ub3h40zQfM+MZNCCAdLvQIurnMTiFDOU3ohcOC4Vw9n8zEBzJ8kxV05jrUbkLqxwvI9xj0IFvmzpCxs0IuBXMPc4/8b0cAMwtg0Mbbk9ZhWiIuH5bV6WWp9201TjeJdZKQXrZ8M1ug3orNKDF1Zpb4jcB88DgVThfUjYWWYm8HMD+5AAuVUU0Xz+ANTjJ59bnutXAA5Py0xAOMFc6vxkjb0R0YVFgUEeMM1GMODpDPZ9eKisB95zY+UsM/ty1+kkkSdxBE9qKBZKjVj/IeFy0IFG99ONgKCIK2ZbyBPaceI8p/X0fmwatkKpD69Pc35acHNfjZgceesXZIm26Lu39hprIdIPMf+N43RfU4faAmlahMcODrjDNrMlVcOmD/omnkZ/zeL1wNbTJ3ZgXsOB+JREG9GGH0CzHVa7+xTclfDZLzbTSzhwsBczHSs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199021)(46966006)(36840700001)(40470700004)(478600001)(6666004)(8936002)(8676002)(316002)(41300700001)(82740400003)(4326008)(70586007)(70206006)(40480700001)(81166007)(54906003)(110136005)(356005)(40460700003)(16526019)(186003)(2906002)(1076003)(336012)(426003)(26005)(86362001)(36756003)(47076005)(82310400005)(2616005)(36860700001)(5660300002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 00:33:10.4490
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: edb9cfc5-af42-445f-d452-08db3fa47cda
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
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

