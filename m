Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F8F446CC0
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 07:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbhKFGot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 02:44:49 -0400
Received: from mail-dm6nam10on2054.outbound.protection.outlook.com ([40.107.93.54]:44512
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231518AbhKFGos (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Nov 2021 02:44:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fkf6sUaBthfUTLFGgaDIleLEy7ty+3yGYqfaEZhVvOSR7El98p4nSqaGGtfZgTEgWdUPeKPaB4g4j1FzE0Nfxu0A0YJONKO/SXypZMcduG3B8WMl62tCva41b7/uHtttt8QCB4+Hy34crPBMvjh434vuUUb38bYiHp7VHpdu0Azj/AJ0027pqp693oUuAq6aZLPlOluhpRvm761MuBubegiHWriSh4HEzrUZdgp+yjL7+y5ie/f70S2mbshaLpMdUZddZwg/uC/oonZ2a3JS+dcTaJHPrPawSdwtBB8fTDO8g0RU03wd3iH8bw+CbvwU5TtTK/JUlTyLVXTkiJjucg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S8sUDlfWDU7cf+zcUItIDwfLQJpoXtOclKhWxcvBGL4=;
 b=jVoUqP5Aotcyd/uv9wKXeGcYU4WWBgzvftgXmNpsDCgCei1UMsCVdie+37oGl74i2dHs6HOXe2ZE4C0pSMAuccT+rJOviq7oeeooPjIYSsVTNRjhnEU11gr5lZ77R83ySwNJJf3nhJO+zxYsc7Ebni4tqTPKeKlzCuW5pfNNPEwNeVS1Ci+zbuzYXBkf7scOJu94qKLO9WzqxdWFKSzVjCSaxOPQJJXoG+VNMzxVcuBYf5BAGWf0aGoNpvYgFr/Frx+dvdEVoWjSjDM2k4rV7O17BDr2nWTKrtYXeUKnUKXKBbQZVpXEqbG2zl7pk9Tng4zQpV7YbJ2IpmJulyc5FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8sUDlfWDU7cf+zcUItIDwfLQJpoXtOclKhWxcvBGL4=;
 b=VjnvaJVnswTQ/ecDNxM3gjur8GyH8wgbT1XQ+ShJnZh/eupYwNbUA1g6rU6w8moihWRzBNmdP+BtO0fWuIfSufJr2HJl2bMRxUq16EfPhy7ztmvwK7S5MGTuEMQAzDxXktYkcjduV+y9Ra9C+ZpvQMcwN7JN3ng6AKHXdzrijY7OXlrzPqf/elToHVXQga67G6HnKdJwYM5nYM0v8hRyZM6Bm+zuY5d8VwIRAvNadKXIioac4xexTLgq6OkkulRJ7Z1ptk2duhWvsrfWzx9NzWRhsLnpH1UIoOPAnFtU8LxfgJQ3oqYw106WOc9jh05iDWQtvJhvVKR4xpDUknM8qg==
Received: from CO2PR04CA0128.namprd04.prod.outlook.com (2603:10b6:104:7::30)
 by MN2PR12MB3567.namprd12.prod.outlook.com (2603:10b6:208:c9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Sat, 6 Nov
 2021 06:42:06 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:7:cafe::4) by CO2PR04CA0128.outlook.office365.com
 (2603:10b6:104:7::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend
 Transport; Sat, 6 Nov 2021 06:42:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4669.10 via Frontend Transport; Sat, 6 Nov 2021 06:42:05 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sat, 6 Nov
 2021 06:42:04 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next iproute2] vdpa: Remove duplicate vdpa UAPI header file
Date:   Sat, 6 Nov 2021 08:41:52 +0200
Message-ID: <20211106064152.313417-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 345c1afe-4f8e-4abd-7c63-08d9a0f08c70
X-MS-TrafficTypeDiagnostic: MN2PR12MB3567:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3567EA59A58C99C3EB8ECBBADC8F9@MN2PR12MB3567.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m+ngSoXMOPZMDsFgGsixGGtHVzrqbiJSseQdj+efpIzVrL4oAzuTcFvOBBQz2Bd7EZDeik6HCVypuCwesjU9H5J0bNoQ6CJVo8R1HERfuKqRzr1c2lAhDOrSrslE4jYNAoSiukCeskse2Ruo5ZWP+3Z4PtRP05NHhXz1ZWArfnEIWM/uGpZy4zXTBseruExd28ymsnCscHdvRQPZRZ2/SqEn5lT6dY7FlLMbvZoB/MMl/h1Fy0PEE1L8W+xC82aZwLxPEd2AHOxfXH+fT2wdHMwjvDi/xojjRFVUFcDTBHK0n9qSWgxUHfNhMd6m/Q7L0nIAlnmJRD7Dw6IkL80D+1mLz6twZWhNimut54pj2sPXXwRI6M+gP7z/EM9syEc+TN79Bmc+UL8suG9UgnRP1Kh2m313ICaByWki9FX5nz+hLTDKAgHro9idobTpHiWIw5yCywnta1BYeSAP/h/Y34RpNKX9iOo5JAI5SUP90tU8DZ9rUi4SuhUI4UXPfEuyT4dceT1WDN9e8GMY7c8ssRshXwScxHCSqp1AJmKWXBBN0xhJc+M6NZhkjM71LzXmwCDRhB6uYS1flqxS3VzfYNt5d8Wdc6PheR0gjKCcfHd4qzUj2CWAx8buRKb8IxvHDcq+82dpZVWXpCRCOIsGh10rFJIemm5UEof5tj6oeaKAGS4Rp51ICvidE81LDb7vyPfiPlMUgYU4awDsmMrd3gVJBoGNS8bIdozSxC8AwAT8cU7WAD6aGApGV0B9r3fyrqKbnAsou2fc2HGM3DxG8s4IvZUSCm/Fo4O1mfDoakE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(5660300002)(1076003)(966005)(508600001)(4326008)(26005)(86362001)(70586007)(2906002)(316002)(2616005)(70206006)(356005)(336012)(110136005)(426003)(8936002)(186003)(6666004)(82310400003)(8676002)(16526019)(36860700001)(47076005)(83380400001)(36756003)(7636003)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2021 06:42:05.7253
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 345c1afe-4f8e-4abd-7c63-08d9a0f08c70
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3567
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vdpa header file is already present in the tree at
vdpa/include/uapi/linux/vdpa.h and used by vdpa/vdpa.c.

As we discussed in thread [1] vdpa header comes from a different
tree, similar to rdma subsystem. Hence remove the duplicate vdpa
UAPI header file.

[1] https://www.spinics.net/lists/netdev/msg748458.html

Fixes: b5a6ed9cc9fc ("uapi: add missing virtio related headers")
Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 include/uapi/linux/vdpa.h | 40 ---------------------------------------
 1 file changed, 40 deletions(-)
 delete mode 100644 include/uapi/linux/vdpa.h

diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
deleted file mode 100644
index 37ae26b6..00000000
--- a/include/uapi/linux/vdpa.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
-/*
- * vdpa device management interface
- * Copyright (c) 2020 Mellanox Technologies Ltd. All rights reserved.
- */
-
-#ifndef _LINUX_VDPA_H_
-#define _LINUX_VDPA_H_
-
-#define VDPA_GENL_NAME "vdpa"
-#define VDPA_GENL_VERSION 0x1
-
-enum vdpa_command {
-	VDPA_CMD_UNSPEC,
-	VDPA_CMD_MGMTDEV_NEW,
-	VDPA_CMD_MGMTDEV_GET,		/* can dump */
-	VDPA_CMD_DEV_NEW,
-	VDPA_CMD_DEV_DEL,
-	VDPA_CMD_DEV_GET,		/* can dump */
-};
-
-enum vdpa_attr {
-	VDPA_ATTR_UNSPEC,
-
-	/* bus name (optional) + dev name together make the parent device handle */
-	VDPA_ATTR_MGMTDEV_BUS_NAME,		/* string */
-	VDPA_ATTR_MGMTDEV_DEV_NAME,		/* string */
-	VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES,	/* u64 */
-
-	VDPA_ATTR_DEV_NAME,			/* string */
-	VDPA_ATTR_DEV_ID,			/* u32 */
-	VDPA_ATTR_DEV_VENDOR_ID,		/* u32 */
-	VDPA_ATTR_DEV_MAX_VQS,			/* u32 */
-	VDPA_ATTR_DEV_MAX_VQ_SIZE,		/* u16 */
-
-	/* new attributes must be added above here */
-	VDPA_ATTR_MAX,
-};
-
-#endif
-- 
2.26.2

