Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83FB68B012
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjBENzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjBENzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:55:41 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907E31C5A9
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 05:55:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izXXeULuNaGk3tH8W9iHNZGCzvtFIGZ8AeUgJK1j0vFrJivVos64Hap0SrlrlTsZDr5vX7lTy5aQAuK9AqzkDqgfryejyMBQla4pBSbg8qnGkLVg73a6W0Iyxv+yZ5O3Z6QC1cbO5r+OUtqDmARtRlGpjTjyQi/br7iQ330ZMW+Lspjkgr3oe6BtQ49sDvbgmH9fnseXRhDU6qZZB6TWigkBebJNCNoshXvXrf5cB0iPsVs5qARUBFxz+udiHkTVrSL13Zv+g6m9hucVnkqzL/fBrkqDQkhDNr+B/SWbEl1jS0AzbBPzpJjrnEMiYBm7gWXiTunhnYVEZ/rkIXD6Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uXhGIBrDJlDCZGcpocQ0M507HSwEaWmFP7R1uXunWsQ=;
 b=IaVgUYUT0+uP0T9eEOD4CCFXWVGWo3yUe/T2hT1oAlbOes7GB+IjtH6tcjgaSJjGIoIHkxO9g+zUbOq5ldexJhUA0zaCc5vPbyumMiC6WWr6N3q+2UUOn/Fv4B4gI+RtfsdCaUg/kV3gdUN1JUZUKCJIdpfx/kIQSLJPaOE3qezEqSUjlb12iK6UsOrHUvRruxQfa/EJ+BK5p+J0Bq2jOpmpCE5rhuqt0P4NiMtzHUxcx6K5aRpBSTwRPmD8l82rolZyXtjReDVg57duIT9vP90s4EPZVAVa6Yjyb9sQvsQZvt4Na6zpDAFfTbdhJ+qM3LglsKM2WQBk9XSEZsdmfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXhGIBrDJlDCZGcpocQ0M507HSwEaWmFP7R1uXunWsQ=;
 b=knH/xZQD6oxtNAWbceBGReY9meb1VSp7EsVJSeolZgx0CcNuPY+SBM6QYeEekpGSiTjhLTMkNOus/WvzC6k5QLTXkJSsW2LbAV5pUUorD81BOhLdH2dViLmwlLR5NGVftFBAkec9w15aw/S1J3fw44pLP7VhySmVUvENKU62ByZN0RKWt7JMbO3jnPQ+DTpGgONHvc8LNqu7dUDVjIfGcPTIYtghg8W7LXfGVt8rSzQ2GWGLSFRQGH6OtgL6mHYh8Fm2jvy281eQhd6Cco6WwASyqfepCWCGEge8x3cZiCJKbMwYpxaQDSVbV8l+jZkhn6z9DhpBxKjO1YNQBidlYg==
Received: from DS7PR03CA0262.namprd03.prod.outlook.com (2603:10b6:5:3b3::27)
 by DS0PR12MB6536.namprd12.prod.outlook.com (2603:10b6:8:d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Sun, 5 Feb
 2023 13:55:37 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::78) by DS7PR03CA0262.outlook.office365.com
 (2603:10b6:5:3b3::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32 via Frontend
 Transport; Sun, 5 Feb 2023 13:55:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.32 via Frontend Transport; Sun, 5 Feb 2023 13:55:37 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:31 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:31 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 5 Feb 2023 05:55:29 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "Oz Shlomo" <ozsh@nvidia.com>
Subject: [PATCH  net-next v2 0/9] add support for per action hw stats
Date:   Sun, 5 Feb 2023 15:55:16 +0200
Message-ID: <20230205135525.27760-1-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT038:EE_|DS0PR12MB6536:EE_
X-MS-Office365-Filtering-Correlation-Id: d6d09763-2433-40a9-1127-08db0780a8c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8zwIlzyuaxl3F2jvXkYeglQvQlvGQGec6xNTIh95lSh+gNfGsCpA6PrXHJDxv/6jUHry9aoTrl/V3Utq3yWDyi2lcgGHVxK+0HtnBk/SCuHbruu6S9dnyylc7+87gt4lIYF9YAhzuvrd/lhBAUIr+fy2wIkfg4QFbmTroWTolwyORG0HEjs1Qp9y23loPe0uaYw+KzdjXYQudzwqLmfKo1AZaRmPvFQ6LE46dtbulmYjViT7THfh3ovPvomb03T+hHzAMufnAT40yidqVcwWTbnETPtaxBQDEefeSmWF7/NFbsePyrmff83ZLtyRi0MCEb0HMMGYDBtx3eLzekh61f5hzEkKXx04oWeWArmiuV/OcrsOQbEluq5tyjlxMEWTvVUTwbZfsmkp9YfoSTEr5d7zsRknGDkyEFetAwpSlle0FEi4f0rrNcEm4XwThVRaXVjFmsTeeloIGRk9tpvJXog/f8soKFYMieSl3jhBGexCRMh3g3UIFz4JWVrDwe5QpyWIXgvYHkNUW7IQnuhGk45QB/mnHDTkv+3W2tIdHLsbnxIgb5inyw/AAlIvPpVdK5HQr+v42sMnUnPO5eRJqEM0Krv9o9l+4xJCl9UtuaZQPvIMK1MUXakv0CErjE5rMAKND5hr6p6ior2L9Xl8YWjXoHgonty9FtAoZ/Duu4eMlwjCW7NsZoy5gM1n0KLUxXntfZA58h+q59NhydEJrA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199018)(46966006)(36840700001)(40470700004)(40480700001)(86362001)(36756003)(7636003)(82740400003)(356005)(82310400005)(40460700003)(316002)(2906002)(54906003)(478600001)(8936002)(41300700001)(5660300002)(70206006)(70586007)(4326008)(6666004)(107886003)(8676002)(6916009)(83380400001)(36860700001)(186003)(26005)(1076003)(336012)(47076005)(426003)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:55:37.0412
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d09763-2433-40a9-1127-08db0780a8c6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6536
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are currently two mechanisms for populating hardware stats:
1. Using flow_offload api to query the flow's statistics.
   The api assumes that the same stats values apply to all
   the flow's actions.
   This assumption breaks when action drops or jumps over following
   actions.
2. Using hw_action api to query specific action stats via a driver
   callback method. This api assures the correct action stats for
   the offloaded action, however, it does not apply to the rest of the
   actions in the flow's actions array, as elaborated below.

The current hw_action api does not apply to the following use cases:
1. Actions that are implicitly created by filters (aka bind actions).
   In the following example only one counter will apply to the rule:
   tc filter add dev $DEV prio 2 protocol ip parent ffff: \
        flower ip_proto tcp dst_ip $IP2 \
        action police rate 1mbit burst 100k conform-exceed drop/pipe \
        action mirred egress redirect dev $DEV2

2. Action preceding a hw action.
   In the following example the same flow stats will apply to the sample and
   mirred actions:
    tc action add police rate 1mbit burst 100k conform-exceed drop / pipe
    tc filter add dev $DEV prio 2 protocol ip parent ffff: \
        flower ip_proto tcp dst_ip $IP2 \
        action sample rate 1 group 10 trunc 60 pipe \
        action police index 1 \
        action mirred egress redirect dev $DEV2

3. Meter action using jump control.
   In the following example the same flow stats will apply to both
   mirred actions:
    tc action add police rate 1mbit burst 100k conform-exceed jump 2 / pipe
    tc filter add dev $DEV prio 2 protocol ip parent ffff: \
        flower ip_proto tcp dst_ip $IP2 \
        action police index 1 \
        action mirred egress redirect dev $DEV2
        action mirred egress redirect dev $DEV3

This series provides the platform to query per action stats for in_hw flows.

The first four patches are preparation patches with no functionality change.
The fifth patch re-uses the existing flow action stats api to query action
stats for both classifier and action dumps.
The rest of the patches add per action stats support to the Mellanox driver.

Oz Shlomo (9):
  net/sched: optimize action stats api calls
  net/sched: act_pedit, setup offload action for action stats query
  net/sched: pass flow_stats instead of multiple stats args
  net/sched: introduce flow_offload action cookie
  net/sched: support per action hw stats
  net/mlx5e: TC, add hw counter to branching actions
  net/mlx5e: TC, store tc action cookies per attr
  net/sched: TC, map tc action cookie to a hw counter
  net/sched: TC, support per action stats

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act_stats.c  | 197 +++++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc/act_stats.h  |  27 +++
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  91 ++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   4 +
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |  10 ++
 include/linux/mlx5/fs.h                            |   2 +
 include/net/flow_offload.h                         |   3 +
 include/net/pkt_cls.h                              |  30 ++--
 net/sched/act_api.c                                |  14 +-
 net/sched/act_pedit.c                              |  28 ++-
 net/sched/cls_api.c                                |   1 +
 net/sched/cls_flower.c                             |   7 +-
 net/sched/cls_matchall.c                           |   6 +-
 17 files changed, 380 insertions(+), 48 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.h

-- 
1.8.3.1

