Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BCE691F7A
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 14:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbjBJNEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 08:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbjBJNEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 08:04:06 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3392673973
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 05:04:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=InrfF1mPI44bA7hQYvSA9Q/JXdCvSsZvmYxcqtlC+gFULJjj0NXXjpUj7Jq+o/oQwXPY0KDu0nnmEE8O+lLcyv7ZA4iREOx+SmebmFH535xgwW0JR3ajW9qDe58cfLBb88r+yod+ghZ7YCfEzkhzQn1BzWQ96YGYh97sFVQOw3nqHkH/reStnKoMsQiOP4WV8BM1kLdoh8J6EVOB/GL7KbnSguXAQIoZkyZT/OgiojM5KeNOcow9hVLOIrIFvKh0qMI7AujFiyyWzVJp5dsshTghBW2Y3X4F5VNBGqPjtUpuDb7fzyw9r14cuAxJ7yDTg7HYf1X3rq20+j9n1n/khA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iei2t9tT3w7i5nP1zGg7y6EXHIx6RAbE2qSptJiwkLc=;
 b=jlUcFn3NbXoSVooy1DXl1Ii0w5qlsi6leidiTs08vjfxXeBX4JAmzIpWxS2PsKufngbAUb/Wi4MsH3bKQgFaoyCdTmF8YGQff+p35A6gKyi2H+HD0pGPVnbm+9QBE59so8vY1N3vfJM1yBaP3tNLM/i/ImjVZyowePzTSygbNtO6oLj3B1IGAYWoOpdnN4mpOj7K/wwQ3Myk2lXwm4tgUJ13FuAkscmcJLwlXgotVzaMJYIOkuR+BiObRoH6eTg5Sy8q5ENXbrrrvASqF8APPk84bxGCKwWgAXDQKyN0COtVeHPDjWCyTcvrngxhqN84XRhSnfckLoZqZnuYRO766A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iei2t9tT3w7i5nP1zGg7y6EXHIx6RAbE2qSptJiwkLc=;
 b=XumokDgiKjjefEFxkYhAHfxKe/S+axrqWDPIW1kdxvWliR+hERfiEopTLi2kzGQJ2XzJqIqXtUgKmAu5UZU7JX/f+yxPnWUsLLeZKtl2dM9eLOzFekV+XPbuskPIaW4ub8IJuV9Z89gTXqcN1YzHT17dfJftq7yjN39oFus/nXM=
Received: from DS7PR03CA0293.namprd03.prod.outlook.com (2603:10b6:5:3ad::28)
 by BL1PR12MB5779.namprd12.prod.outlook.com (2603:10b6:208:392::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 13:04:00 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::44) by DS7PR03CA0293.outlook.office365.com
 (2603:10b6:5:3ad::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19 via Frontend
 Transport; Fri, 10 Feb 2023 13:04:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.19 via Frontend Transport; Fri, 10 Feb 2023 13:03:59 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 07:03:59 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 07:03:58 -0600
Received: from xhdipdslab59.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 10 Feb 2023 07:03:55 -0600
From:   Harsh Jain <h.jain@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <thomas.lendacky@amd.com>,
        <Raju.Rangoju@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <harshjain.prof@gmail.com>, <abhijit.gangurde@amd.com>,
        <puneet.gupta@amd.com>, <nikhil.agarwal@amd.com>,
        <tarak.reddy@amd.com>, <netdev@vger.kernel.org>
CC:     Harsh Jain <h.jain@amd.com>
Subject: [PATCH  6/6]  net: ethernet: efct: Add maintainer, kconfig, makefile
Date:   Fri, 10 Feb 2023 18:33:21 +0530
Message-ID: <20230210130321.2898-7-h.jain@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230210130321.2898-1-h.jain@amd.com>
References: <20230210130321.2898-1-h.jain@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT022:EE_|BL1PR12MB5779:EE_
X-MS-Office365-Filtering-Correlation-Id: 93f15b96-673d-4cf0-0a88-08db0b6746ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qrs2uNoNmObEo0VyAez9YpaJ2dYabfDTERHF1/orT/SYC68QLMfoxMw9FcRpXfFURwDDmACFsBt7H95uXE1pWN3IAjjGIQEg9xI65eJt7dEGdn1pxiYKKXvu6wye7kBaCRSSlFLkWPn6caUlL2L0x6myW7ajpSm/hbiJU++ke0jvj2aQARjYn46YWn/cLDdbP8TYhR/WLsJrP9cqI+RASp54Q/9LbeMriavXjWMpF+08brGIkznW8/YjQOCjxrArtHAY4A1GlB+1HQ1gltFLTgaPYdM6zHMauK1AybuwvNGQxTnqjHo6rk54OL1yXV0XzbzJ0TWlmC+hEHkvN6bCxT58Cvc0YHPhOWDqlg2BYT2DU4S34Myef/1Yn9aHCWM8oHa3JPqK1xPeBZh6FyOERSGukbrxhmS52GIZ4aILQTbxX92+nKsAABc0i0ZS/joGxpMcvP3MvQ6hgcchXyRIKVwsz4W+K9jDXyRqKEJx/QkLg0kOG3DGrhnauTmQf+jE5ikRrt7sBimsVUs9hRDRy81+bmlT+BW4dqPoghwBhtZurlAKf7XrB4YfoPeyu69IEq9Ekqir/a7lBlaYT+TJn/D6EvrkcKu2WLQv196ldxTeCQiZ5l9N2ZNM/2GWwXiTp+O/Gmv4J1RsFaQ3F/Xr7dMFyCIWmMfAzqLiYVvUSwO346Em23jm04Fkxy7xYnHh2FO7yoRVXPR6RNUrVP00J9CVAC6XmbC0dTsBRtqswzLB8H09Kd09wWqpgw9ezxrn
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(36756003)(82310400005)(2906002)(40480700001)(26005)(478600001)(2616005)(186003)(1076003)(336012)(83380400001)(41300700001)(47076005)(4326008)(426003)(40460700003)(70586007)(70206006)(6666004)(8676002)(5660300002)(8936002)(81166007)(921005)(36860700001)(82740400003)(316002)(356005)(110136005)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 13:03:59.8410
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93f15b96-673d-4cf0-0a88-08db0b6746ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5779
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include driver in kernel build system.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 MAINTAINERS                            |  7 +++++
 drivers/net/ethernet/amd/Kconfig       |  2 ++
 drivers/net/ethernet/amd/Makefile      |  2 ++
 drivers/net/ethernet/amd/efct/Kconfig  | 40 ++++++++++++++++++++++++++
 drivers/net/ethernet/amd/efct/Makefile | 13 +++++++++
 5 files changed, 64 insertions(+)
 create mode 100644 drivers/net/ethernet/amd/efct/Kconfig
 create mode 100644 drivers/net/ethernet/amd/efct/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index f2bd469ffae5..de7c36ed04de 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7611,6 +7611,13 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git
 F:	sound/usb/misc/ua101.c
 
+EFCT NETWORK DRIVER
+M:	Harsh Jain<h.jain@amd.com>
+M:	Nikhil Agarwal <nikhil.agarwal@amd.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/net/ethernet/amd/efct/
+
 EFI TEST DRIVER
 M:	Ivan Hu <ivan.hu@canonical.com>
 M:	Ard Biesheuvel <ardb@kernel.org>
diff --git a/drivers/net/ethernet/amd/Kconfig b/drivers/net/ethernet/amd/Kconfig
index ab42f75b9413..2da60a88ea4a 100644
--- a/drivers/net/ethernet/amd/Kconfig
+++ b/drivers/net/ethernet/amd/Kconfig
@@ -186,4 +186,6 @@ config AMD_XGBE_HAVE_ECC
 	bool
 	default n
 
+source "drivers/net/ethernet/amd/efct/Kconfig"
+
 endif # NET_VENDOR_AMD
diff --git a/drivers/net/ethernet/amd/Makefile b/drivers/net/ethernet/amd/Makefile
index 42742afe9115..1f21751a6eb9 100644
--- a/drivers/net/ethernet/amd/Makefile
+++ b/drivers/net/ethernet/amd/Makefile
@@ -17,3 +17,5 @@ obj-$(CONFIG_PCNET32) += pcnet32.o
 obj-$(CONFIG_SUN3LANCE) += sun3lance.o
 obj-$(CONFIG_SUNLANCE) += sunlance.o
 obj-$(CONFIG_AMD_XGBE) += xgbe/
+obj-$(CONFIG_EFCT) += efct/
+
diff --git a/drivers/net/ethernet/amd/efct/Kconfig b/drivers/net/ethernet/amd/efct/Kconfig
new file mode 100644
index 000000000000..ee1a162dd045
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/Kconfig
@@ -0,0 +1,40 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+################################################################################
+#
+# Driver for AMD/Xilinx network controllers and boards
+# Copyright (C) 2021, Xilinx, Inc.
+# Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+#################################################################################
+#
+#
+
+
+config EFCT
+	tristate "AMD X3 support"
+	depends on PCI && (X86 || ARCH_DMA_ADDR_T_64BIT)
+	default m
+	select NET_DEVLINK
+	select MDIO
+	select CRC32
+	help
+	  Supports Ethernet cards based on the Xilinx X3 networking IP in AMD/Xilinx FPGAs
+	  To compile this driver as a module, choose M here.  The module
+	  will be called efct.
+
+config EFCT_MCDI_LOGGING
+	bool "MCDI logging support"
+	depends on EFCT
+	default n
+	help
+	  This enables support for tracing of MCDI (Management-Controller-to-
+	  Driver-Interface) commands and responses, allowing debugging of
+	  driver/firmware interaction.
+
+config EFCT_PTP
+	bool "PTP support"
+	depends on EFCT
+	default y
+	select PTP_1588_CLOCK
+	help
+	  This enables support for the Precision Time Protocol.
diff --git a/drivers/net/ethernet/amd/efct/Makefile b/drivers/net/ethernet/amd/efct/Makefile
new file mode 100644
index 000000000000..d366a061a031
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/Makefile
@@ -0,0 +1,13 @@
+################################################################################
+# Driver for AMD/Xilinx network controllers and boards
+# Copyright (C) 2021, Xilinx, Inc.
+# Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+################################################################################
+
+
+efct-y := mcdi.o mcdi_port_common.o mcdi_functions.o efct_netdev.o efct_common.o \
+			efct_nic.o efct_pci.o efct_evq.o efct_tx.o efct_rx.o efct_ethtool.o \
+			efct_reflash.o efct_devlink.o
+
+efct-$(CONFIG_EFCT_PTP) += efct_ptp.o
+obj-$(CONFIG_EFCT)	+= efct.o
-- 
2.25.1

