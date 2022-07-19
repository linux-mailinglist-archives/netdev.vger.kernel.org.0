Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE4357A428
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 18:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238589AbiGSQYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 12:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238701AbiGSQX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 12:23:57 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D58D550EB;
        Tue, 19 Jul 2022 09:23:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=leYOac2qwsuA4ZUnENvnGbGDqY68aoUJ+Wzw/2PpqnoPo41kZuQsxtOUFzQZSehpZoGfQu4b6XtUH9YndfwY95MNb+Ywl6Nr2GIgpGBOot4rEYJ9IR8BABx1CKUpygO1Eszz3+aGBvq9ueowLJW06LmaLgdYMD4pRMgTbTc/tiFgFOYVe6VE613VW2hSWUvRYNqGE4Byodi4nXjwXwF4ztR97AKaX/0Ju4gI6m1hs74GJdCwXWZzOyrFEzBvBot2vKeMoaL4gGZg/hG+zueToc288MiX3Ae8ca7KtNhrGKm76Q8HAlHiJg0UpdXuH099m7Ez7IHAki64hPAYJzqGdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p1FRfHiwzewnh4GN4zcVkhs/ZPDkDd6gYZBmVNX5VVI=;
 b=KRSvKqIvTjGW9lHRbTtV/zdVdFqDLVa1D4g4uvGYabA2i7hmFNul+Uu/a4GrX8HiAj2XrIjFNwimoJ0jcajBoaptRFERGg6BUr7tu9rlCpUvX+OnhJdiiXAKUEwevmG9nII6wuA2EAxA+xdJSKq51zi2jtHy1YcB3AzJEp0C0rw28nZSbgJ5nf2PAhVZUeNUe9Vt2c+ZINvtQjsfoZ4QrCSD4CisGc2DwEImqDDLpBH3AgAXFGNxfIeR7BMvFZ54evxL7phRvOHUixHlMpXQcWuHajkwFP0JPzY3D+RYB0VyHHR1oYk7Uh/M5yKOF9u9suSX/JVhNqC88h8wZPHlNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p1FRfHiwzewnh4GN4zcVkhs/ZPDkDd6gYZBmVNX5VVI=;
 b=ME1Pb5Sfn7nv+/yd+vRSYBBubpOlGWCQNFlmKU/szIy1ouotELEdIqBsKqtF37OzETVQGwFyA09yig/p+d2emPuJ3M9rSmhm2Ss8MpmRAAxqazbTC+Ti+NOfXpOW62Ih3mqirVUPrS4T6hZ89sJCVmXDYxQXDPq87xteNYDL2w8P3qhtwU2p6oI/2Bm0g+vmR66fyTD3ZDYbSqfvG84qK4pQe6rSMewLXwpDVI61MWEO7kP8IlKgC4u4o4T8f7wpxJdX42bZRPgzF6g2uRgz6dO6w4GMv3A3pWsal+EgMqtaJoxHJBnlzqMOMubmc8ELNi+c6soO1EWDOjtVYswvdw==
Received: from BN0PR07CA0014.namprd07.prod.outlook.com (2603:10b6:408:141::7)
 by MN0PR12MB5740.namprd12.prod.outlook.com (2603:10b6:208:373::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 16:23:55 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::1a) by BN0PR07CA0014.outlook.office365.com
 (2603:10b6:408:141::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20 via Frontend
 Transport; Tue, 19 Jul 2022 16:23:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Tue, 19 Jul 2022 16:23:55 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 19 Jul 2022 16:23:50 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 19 Jul 2022 09:23:49 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 19 Jul 2022 09:23:46 -0700
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
Subject: [PATCH net-next V3 0/3] Introduce and use NUMA distance metrics
Date:   Tue, 19 Jul 2022 19:23:36 +0300
Message-ID: <20220719162339.23865-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: add543d2-097d-423d-f2a8-08da69a31388
X-MS-TrafficTypeDiagnostic: MN0PR12MB5740:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NrnuFt2SpFFNcez+vpPdZh6ZEfrHnSQFl5Klz0cckBCXeX1yIaQsQ+CNCwIPsxjW83BGVojtWRYCrGLmHt74z7pxJRwb1vUE9+onedaklIy0RObqC8aRy4T5v7oKmAPG89iXspv5AcWPmV9l+yNpDxC9dPJvGgWrUCL5uXAJtlzyJ6LZ0seQinRbKiI0yO1hsMsCnBNgIUOI9qUzogtitx9+IFBeCYXQrbVxenE4dOOfmUkNcVE6DSw3CmGYv+A8i/RtK8EsgA2Sg9C0fDjqwLRWKh1QFhWU3hbZKW9lWEFBvyFnc6IP8oOi60fIs0hxHdPpWeLoOBM2ISj0ZhuFK+wYaItOAfA2F1gUMq4psBHggp/y60UTInTC+OE7LGVf27mlKNK/qYH+i+ppgBdX635Y+Y1pznzK0Fm03hPS8TTRGGp5RdfJxahome50uAdapFfkBuriNDM89ZJVlTdcND9YDNclCPyg+PS/ygv/mqAT0AMzaUguVrOsqo762jqYrXHQYxcn9W/p8HB8XAbPKZc2ad8MzOD+I9Xz4dBvL8bF12c0Ik2SroWayXvWFERavLxKR3mQPvU7q/XSnkJ0SRqRotBvaFbmLr20q8VRZbGLSfylGk5Qxt/1eQ6OyvYkd+yDuskcEtT02ta5DQcrVqwjlzCfZGvLP7iCahVGb6Z6nUarBVgyEBFekeCRC1knbkwrddPdqyN8uEibwkT7hDRBxjVcwaaE3dm/Rlp/gi1FQBlHwnpogPhJ/K7cHJmODNiq+XQGdJ99q1EnXSNLYddVLT60efgtcvxVzFB9y7ywPrVv3Jxbo792/qbE4/QfIWDbo432J92ydo8/7E7LTA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39860400002)(376002)(36840700001)(46966006)(40470700004)(5660300002)(2616005)(86362001)(107886003)(2906002)(1076003)(83380400001)(8936002)(7696005)(7416002)(26005)(41300700001)(82310400005)(478600001)(82740400003)(4326008)(6666004)(40460700003)(336012)(186003)(47076005)(36860700001)(40480700001)(426003)(36756003)(110136005)(356005)(316002)(8676002)(70206006)(70586007)(54906003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 16:23:55.2799
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: add543d2-097d-423d-f2a8-08da69a31388
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5740
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Implement and expose CPU spread API based on the scheduler's
sched_numa_find_closest().  Use it in mlx5 and enic device drivers.  This
replaces the binary NUMA preference (local / remote) with an improved one
that minds the actual distances, so that remote NUMAs with short distance
are preferred over farther ones.

This has significant performance implications when using NUMA-aware
memory allocations, improving the throughput and CPU utilization.

Regards,
Tariq

v3:
- Introduce the logic as a common API instead of being mlx5 specific.
- Add implementation to enic device driver.
- Use non-atomic version of __cpumask_clear_cpu.

v2:
- Replace EXPORT_SYMBOL with EXPORT_SYMBOL_GPL, per Peter's comment.
- Separate the set_cpu operation into two functions, per Saeed's suggestion.
- Add Saeed's Acked-by signature.


Tariq Toukan (3):
  sched/topology: Add NUMA-based CPUs spread API
  net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity
    hints
  enic: Use NUMA distances logic when setting affinity hints

 drivers/net/ethernet/cisco/enic/enic_main.c  | 10 +++-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c |  5 +-
 include/linux/sched/topology.h               |  4 ++
 kernel/sched/topology.c                      | 49 ++++++++++++++++++++
 4 files changed, 64 insertions(+), 4 deletions(-)

-- 
2.21.0

