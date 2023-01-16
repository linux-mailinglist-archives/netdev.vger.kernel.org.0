Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A24C66BB8F
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjAPKTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjAPKTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:19:25 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E200B18AAB;
        Mon, 16 Jan 2023 02:19:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQcLsjNwx6/hCv2N5/ENyhX4KmTz+A2E+Enes+6/R2ymOegQC6m6vP4bQQ1O/YlgAj6su2/EnLYLWMpsF7ZL11sqU0E10/ilEj5RHOWmcPsn/h+yKeYW4ra0mxI/1rc1VLkWrbhMqXnvzsgHRw8wffIm6jsGaxLRR2bmCVwuxjh0jiZnh3UdyZLUF3D7AUsJRH1nDxAjfM/q+2RG5uO4iMwDjr0AZpba5xl8MUq7M0tRQNPbv1cBgu/IGreLFPnXAJLAQlrAdybZI8w7GEKNPhZJCbklUXsKlZQy+8xZakgnpzcZruwcYrd3hkN0saxhJP1b6Nwka1LHeZh0sNYAvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+/9pcMkfpajz9Q8TDICXii2eL6jbq34iW7HgssDX2Gk=;
 b=mB+PaN6XNBFAhxrWZEMXyAslSzIGSJ5XrZT4goEnLtF153pt6zQa4wuqDMlevageg/B6t/yffqouuSptizTXV17N04MDGNYeDJ+3tpbAKxGjNuHADdV9VUawL6nGGd/ugs1f/Yhhhyuwbd3bZliRYwouB24E4LgVhh+XhNrThTWrFsnxmJGPiKwhiWZaE/24kV39WDiwG/KV6ybdY5/a8IY7H0RfWiK5ZMv7WKx7R6QCVSmiU6ignOW2QgJ2fyDsOHjdSk1V1JSd9zs8JF8ZKdpV7cFYahi5CFTkAEw1g8agMgLVYStqh6+yTfy9+wb2KNWGwybHrBFxR7XE65w1iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/9pcMkfpajz9Q8TDICXii2eL6jbq34iW7HgssDX2Gk=;
 b=pFYiPvagtfYKfk0+IGgNmwJdtNvX7KT4YCJ0hTFdi1kD34r/bww1YrirsLiZH+zzl0fVLzPrgQ9GwNfhDlzPvuUXGWz0esYgOT0gWR9JgV9r3fUoSbKxjJB24mx9GG/wdzL4uk6Zohk7h3MxF/hvZKXKOrlNfZvyVJYP2cyF+5qr5S5Rl5zJRqxM+pmHVy7eREB65HbO+H3d/6qwAO8VqRKcchZ6xZDlqC1GstI7BWNeQ+wwO/mq/Up/+U/wRSxvaVu4epz99vK1k57gY8B8vyArOW+KFAwrmrDUcWTF8shhl/1DMzAsbGYsq6LgMGlm8u8f+rqkts7u9dnQ1qf5TA==
Received: from MW4PR04CA0115.namprd04.prod.outlook.com (2603:10b6:303:83::30)
 by MN0PR12MB5860.namprd12.prod.outlook.com (2603:10b6:208:37b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 16 Jan
 2023 10:19:22 +0000
Received: from CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::c) by MW4PR04CA0115.outlook.office365.com
 (2603:10b6:303:83::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Mon, 16 Jan 2023 10:19:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT103.mail.protection.outlook.com (10.13.174.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Mon, 16 Jan 2023 10:19:21 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 16 Jan
 2023 02:19:18 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 16 Jan 2023 02:19:17 -0800
Received: from ubu1604-desktop.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Mon, 16 Jan 2023 02:19:15 -0800
From:   Sushil Singh <sushilkumars@nvidia.com>
To:     <thierry.reding@gmail.com>
CC:     <jonathanh@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <netdev@vger.kernel.org>, <vbhadram@nvidia.com>,
        Sushil Singh <sushilkumars@nvidia.com>
Subject: [PATCH] soc:tegra:pmc: Add wake source interrupt for mgbe.
Date:   Mon, 16 Jan 2023 15:49:12 +0530
Message-ID: <1673864352-17212-1-git-send-email-sushilkumars@nvidia.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT103:EE_|MN0PR12MB5860:EE_
X-MS-Office365-Filtering-Correlation-Id: 95390b1e-d596-42c4-22d5-08daf7ab22a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /4FEqVOD4Ncc9XJ0dO6zl1vV2dyOzOCPCC6aIiwbXXEK6W6+oeKvP5f9yhrxzJ1wmGW6AqQ+6+3rehSq1wVM58aNBjTPtTEQaBwvr/IZ56wW4lclhuU30LhRbG0B3xHIhVwTJeKgvnRWRZLSYW8TdjSc39geJHaR4Pmr3E17JAZE2jpXlq26OoSGWwmpH47Gbm9ZvSDFm4N9mIZetflSE8CTTdZmyG2fCHnuws2Vg8J6+12wAj1jXa+wJl+/2A1vgSHqXC2kx7ZE9e7FHL1SG6xkdXbe3UCvQ4J8ke24gMY+l1xPpjD2+5OVPUBJ5pUIYTYmquSAZ9frXVXVjYM+ZbZsQPFyzmKt2nn9fQCnsrSovNwL2Hx5y1zaP5SvF8Mqu4n02VvlU/88zpwjtlA1PaYYAYZGgDhs9tfl7ePTpB+W9o2FBaJwJIfr1DJLVRbHK7WjAGU03uL0g/vzYOk4kefK0hs5YJ7RTLFCBDg7SqbbqgFNCchDcWmV4jgN6ofyyC6iG8cjpbU45k10YV3vhXvt/6587k4eJ5e94mxHIStjg5ba76UcaSVv+Ho7DBWkWBH+QIeI7vyXX2m3In4LxGkDCDpVGjpcnkklNJBcgtpc4NyyO4DVEwH9umz2OwbFJbHzYZP5rJzsVr93R6mKZJWzcrQqeb+2RKZQkQlqX/QrpQi2hDn30i9hio7gKkbOPaMNzD+bTNW9Do1kc+T7mg==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199015)(46966006)(36840700001)(40470700004)(82740400003)(107886003)(36860700001)(7636003)(2906002)(6666004)(356005)(2616005)(40480700001)(4744005)(7696005)(26005)(478600001)(316002)(5660300002)(186003)(82310400005)(83380400001)(86362001)(36756003)(8936002)(426003)(41300700001)(47076005)(70586007)(336012)(8676002)(40460700003)(70206006)(54906003)(4326008)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 10:19:21.8346
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95390b1e-d596-42c4-22d5-08daf7ab22a6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5860
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mgbe ethernet GPIO wake interrupt

Signed-off-by: Sushil Singh <sushilkumars@nvidia.com>
---
 drivers/soc/tegra/pmc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
index cf4cfbf..f4abc7f 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -3,7 +3,7 @@
  * drivers/soc/tegra/pmc.c
  *
  * Copyright (c) 2010 Google, Inc
- * Copyright (c) 2018-2022, NVIDIA CORPORATION. All rights reserved.
+ * Copyright (c) 2018-2023, NVIDIA CORPORATION. All rights reserved.
  *
  * Author:
  *	Colin Cross <ccross@google.com>
@@ -4227,6 +4227,7 @@ static const char * const tegra234_reset_sources[] = {
 static const struct tegra_wake_event tegra234_wake_events[] = {
 	TEGRA_WAKE_GPIO("power", 29, 1, TEGRA234_AON_GPIO(EE, 4)),
 	TEGRA_WAKE_IRQ("rtc", 73, 10),
+	TEGRA_WAKE_GPIO("mgbe_wake", 56, 0, TEGRA234_MAIN_GPIO(Y, 3)),
 };
 
 static const struct tegra_pmc_soc tegra234_pmc_soc = {
-- 
2.7.4

