Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68CE05774A1
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 07:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbiGQFXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 01:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbiGQFXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 01:23:48 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F55FF8;
        Sat, 16 Jul 2022 22:23:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LjTVe4oVfmczSgWU5LO9GWcrvSN8wj8T6oHmEOZJupq+UCP5cFp9bQJBLAT0CzSdlF5u9UfTKgE9ZDD1kgm6eUy/0hyiifDAc3u18+r4V9gzbnL6hzyMlHwpMmwW9lJLGFap14msUerWg72cB1Iw7kbJ+wCU8yRbIYSlNXyMXdDSceKK3txW963qFhGs6W+sGodeak+l/XMrkCdKBPWV4CiHEXDD7wcneXH3Atq1d9kZcux7y0OEwHvP3pUJxYZAGF6TTCY+g3MrhomhL0BA1pQbWJ1FrazL321mUwhhmyUzniVpKPrPAnKJpc4vcOLd+Frl4jAcHNyiYLd2z+MwAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BgL0DMNZBJFhcAW4/h+VMHZBkUqzxMGYipZLwDCd3zM=;
 b=Vr8o4xpd8pPqwhwdxOc0lNFUCMYfFh8IucqIrKvj89oZpEIFCfazCEeHPt/O7ppJc7xTxK6qNXhMJPz0QZvX0lHqJX6nkf/dOM7GeGA4ZWahX6XoU/YiB5jeJ0yzOdAB/Xya8e4TDgTSfJGEJur/C/j3X+1yRK6dFyLMmuPV0tixSdgUJdjlAbgTBp7JZfi6PWFzsdECF802xHBLy7l9i+U0+PSsQiVqLdxq/tWV7bwHhTRnLwGWSPshkSMQaeW1NANdRUIX06VEGJhZHgKONY9cspMn7XZ+PtkqqN6+WB1Q2Fuse3q0BlSmQodRMUdHenZ6enFrj2f3t2PE46LHGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgL0DMNZBJFhcAW4/h+VMHZBkUqzxMGYipZLwDCd3zM=;
 b=Q3bRZ4AL3HX0zJkJqjrJR+q4iOU1Ry4OQ2+qMHURsPexgRNlBa+qNvTi5wbgUb+zkD7QYjeI16iF3SLMeeyw1wqILeIpgXSGI9EAIFS2YKMOQS4zX7RE4oPxXVf2KensuYDvtA4YYNR+nYPKwqdJ8Y++nnXz0JT+NWKH2+x1YqG+pDJS1jQtCNdk+Z+vOsGER4Emdz2eGF3fktXXZGTrga7lQmaYBZhO8ZmbdCZSMVNz+G30B+Vc1qwZxX+6TuHeH7U0wfIgEzc6QmCL1BP1eE4e7NU37iFV7p+wkZ6niE6gABAZQ27lf2q7X2NDuC5Z8OoOIcZkI501xpGSGbQ2tw==
Received: from MW4PR03CA0024.namprd03.prod.outlook.com (2603:10b6:303:8f::29)
 by SJ1PR12MB6172.namprd12.prod.outlook.com (2603:10b6:a03:459::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.22; Sun, 17 Jul
 2022 05:23:43 +0000
Received: from CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::a3) by MW4PR03CA0024.outlook.office365.com
 (2603:10b6:303:8f::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15 via Frontend
 Transport; Sun, 17 Jul 2022 05:23:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT068.mail.protection.outlook.com (10.13.175.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Sun, 17 Jul 2022 05:23:42 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 17 Jul
 2022 05:23:42 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sat, 16 Jul
 2022 22:23:41 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Sat, 16 Jul
 2022 22:23:38 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>
CC:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        <linux-kernel@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 1/2] sched/topology: Expose sched_numa_find_closest
Date:   Sun, 17 Jul 2022 08:23:00 +0300
Message-ID: <20220717052301.19067-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220717052301.19067-1-tariqt@nvidia.com>
References: <20220717052301.19067-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72d42366-dde2-47aa-32ce-08da67b483da
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6172:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lEHgQx5hZCOuGHU1wYR3KiF/jWiEsaN6uhqb9QUlEibaGEqt+04KGgWiqEfseC9jhrCFaNoCkojvJAKc3BBcHEBtoBbnVY/ratvMBzp8wnA+qdPg/O5AegCMve5SAIt+y51paQqFr3qCRiKEV+NAvm1TeMudke9shk2Qxydg89+3xs/xboZVsZFOh0B41tX6qMrTevzTf8wedwZqTDYE4aEqNhNCWQsDxNDfAYpEoblE/fjdl4erkRTtOFC+g4/W/YmT+AWo8+7ZQ3gU8Y7qRWdZq9OKEUAqZLnbyw4YMVRiqeR0++RgHdvOw9q5CdzejRdpUjF/WhdWyCMV6vEujERzDiacuCLpAX0Jsdp1uzgWzHWNQ6SKny2A2JCDqGUfmOk+G5vKwEu00EpNeuqK3rJ/+aWoIVVYAySBfmir0HFEH+mpfy58U0I+gZo+mTiJe9TSGIeZxjm0Y87J23m6LKM3qkCIpq8zIIYNl8nJ1RJR3yMnvu27UwiAWgn7dOzHwjYZhxnio3m5SBxlFq24KbpxM4EusZFvh+vlvGQ1usPnd3SXKVWnUDYl6lLmW8rQDwfWHlnLI4vXdlTcmJQcq2kdyLOl9b2p82sTJM6RK6vaGCcp9atc+Nb7fS3fYJEOjkixf2NlfV5RBi7Z8whrdB7OUv3jj9igsji/023DutDaN3t4XQ2pKco53QZFUT2kcKuv34aHEpxo1puAjE3PlrFQdLD2FeopZbE4Kvecc+ZPLut8/1nWiblrUxd5uo4qNX6uVuBfwBV9JK8sh6hMnbzenORFsIm83Zpk4uygzB9cnPAcrmqgLSan/vn0TK06qhBW54hXj9vbZwZAWLtwZP5EyKeWsEAJb3wm1B/v/YA=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(136003)(39860400002)(346002)(40470700004)(46966006)(36840700001)(36756003)(186003)(110136005)(316002)(2616005)(7696005)(478600001)(1076003)(54906003)(107886003)(86362001)(82740400003)(426003)(47076005)(336012)(82310400005)(81166007)(2906002)(83380400001)(356005)(41300700001)(6666004)(40480700001)(40460700003)(70586007)(70206006)(36860700001)(8676002)(4326008)(26005)(8936002)(7416002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2022 05:23:42.8985
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72d42366-dde2-47aa-32ce-08da67b483da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6172
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This logic can help device drivers prefer some remote cpus
over others, according to the NUMA distance metrics.

Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/sched/topology.h | 2 ++
 kernel/sched/topology.c        | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
index 56cffe42abbc..d467c30bdbb9 100644
--- a/include/linux/sched/topology.h
+++ b/include/linux/sched/topology.h
@@ -61,6 +61,8 @@ static inline int cpu_numa_flags(void)
 {
 	return SD_NUMA;
 }
+
+int sched_numa_find_closest(const struct cpumask *cpus, int cpu);
 #endif
 
 extern int arch_asym_cpu_priority(int cpu);
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 05b6c2ad90b9..688334ac4980 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2066,6 +2066,7 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
 
 	return found;
 }
+EXPORT_SYMBOL(sched_numa_find_closest);
 
 #endif /* CONFIG_NUMA */
 
-- 
2.21.0

