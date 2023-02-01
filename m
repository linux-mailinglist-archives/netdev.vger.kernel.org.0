Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E80D686B3D
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbjBAQMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjBAQMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:12:00 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DBF40FD
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 08:11:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOjTfUp/OEpe2a6D3NbgU3r8EEXVp9xRHJGEF1Y0TvAKaXbqWBhUHl/DxEI/e44E0r77/qxX/+BeuXEZVZOwHuN9kYW5P0D/ZQsdhAt3Qk61xwYvzAZoWDINN2neUhzdPWsyckfFVgWSSGYnMRqzbcmJwqUe4jpFYoMUiR56iw77sVelK9AyiPGG91Y01CGw3N6NkppLKnOW4qkBufn8cwx53Vgc7qyyz5ekQzwz2LFFGqMsNfATGhZU5bMdlzv3GYQAk+VTh5GTbPuKBYGjFbcWAItqu4STR6T1lV4etzfqmUhoQXzgkH5FrgUr+ma/F1Ef+OTx+UaEjg6KFWCOsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RlMjSSoErStaiGmWefwTOCmFqndX887a4kvoNbjNj3g=;
 b=BGleJLaOUrsWUdARr2MQ7NUStHqzMZxwmyipd8gEsdTlpNh0Z06ZsZ/peVFDR6Nb9g60SyESVNBwAVF9tIjXPzn4OtmIiiRboSd5XHR0FGXxdelbp0V5McDhT/xsqeyual76tgt/J7UxQdiLQsYsLU8Rltp1Z49Tttjobe3C1ygbCFkfbLGkrYamD/MslfnXphnVUdNYUDsze+NmWWYCED7z5k0UxLFe3cAaHBY/8CYqZ03drEAAe+vhAdzCKIRUmg5DqAZahYw6lJa5wTPcowvlBQ0mmzfShysEeb8PicGpv4Vdbjn7woonAtw7Lpd060LNnXPTNk7zEGR3Ep2xQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RlMjSSoErStaiGmWefwTOCmFqndX887a4kvoNbjNj3g=;
 b=BeoqzThvCXbQmMiNJHsNQdWbF2VPYxwGbKMDj08dIChH2EtKt9UnswtVDfLyOoAIcdLXbkMvqp9A2oR3YI0LHrAZ0oQMiV+SWymmLB8Y1/RX6UlfsPK28kIIx8AmjVVfu5n2jPT0nw7+FkSscGeV3eHhxrrVQ5irwSTaJpDHl7nMApl+fEKaNCfTugUTmZ92Gzc0brzstbn5zWgIfQW6jhHxaUM7tcBplF7QDva+tQOQzO2jgEwAaEXY70FJjakfHbSz+oRtydgg7VGWfj7rgEMPuaKARxFn/tGAn52acAs7Xqe3U1unnmG2D3hU2omnrniomPaXdsnwCawZrCFaLg==
Received: from BN9PR03CA0315.namprd03.prod.outlook.com (2603:10b6:408:112::20)
 by MW4PR12MB6707.namprd12.prod.outlook.com (2603:10b6:303:1ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Wed, 1 Feb
 2023 16:11:55 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::4c) by BN9PR03CA0315.outlook.office365.com
 (2603:10b6:408:112::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Wed, 1 Feb 2023 16:11:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.22 via Frontend Transport; Wed, 1 Feb 2023 16:11:54 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:11:43 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:11:42 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Wed, 1 Feb 2023 08:11:40 -0800
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
Subject: [PATCH  net-next 0/9] net: flow_offload: add support for per action hw stats
Date:   Wed, 1 Feb 2023 18:10:29 +0200
Message-ID: <20230201161039.20714-1-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT020:EE_|MW4PR12MB6707:EE_
X-MS-Office365-Filtering-Correlation-Id: a15f3ebe-e45b-4955-3ee4-08db046f097c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MuhSFm4cJjBM8WywmYBwb/f029241LoDots/DQ4FCXqLyfg7NZXnW/s1mXeu8vb6GE1Y3rt+wtr36R2XK4LZvpzSo3Nf+xmKlyT9zo1OoJOilPK+BRhHCGg+KPf55nJTog1jfoZk8kABU9H/phQxEnNfMPyktM6+A1Bhk0YecGHdYMz8uM8SgpRh3kMrW33q+K4+ExrJa+eaHm/CXHxaaeDzQyoW3buRwhegV83nJ3U1Mq4nYXxDm/QB+XE06sMzFVMpczGTbuw4EDELdVm0mSKcKYyStwRFDr7vIqP/+Rk79Rfy4IAuBqnd1rBhRT2XJ8tzCwt0s9yLVmW3eaphv5sr3rX0tDu38Ep2SY1mJ/gEv0eo1kX+kt3ziSvfJuOSWi6I21+iEsKCj5bnHYNwnfneLrDOke0Oh1F7pYLl3wVbMhviUPgTa+FUtcBiM4IPGx+9vmOMfoUoa8zZyf3mw0Wd2apYghv+hoAKYyG7j4OQ/7VQheXPjP0HIls3dPgWM6lHSKWYJUgvDFOjeeiGId0/c/6KnG/+ofSnJZzoB/qiY48EuHCU7zpTzM/z+0CjIfm7pXZ6xF+Li0nB34yOLR8uUapE5kpFP2xk8wWXDQwyAkA6Rtfvb9vR8nuWF7y17KmhzXmz6vvRRUxDu9Kj++yFs6/oHWkNYLDIfFGzU/cc7BMluQ/2JwnuCte/9ycwmjtfkPcNoeeDayvHiox2Ug==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199018)(36840700001)(46966006)(40470700004)(47076005)(356005)(82310400005)(86362001)(36756003)(40460700003)(40480700001)(82740400003)(36860700001)(7636003)(4326008)(2906002)(8676002)(8936002)(41300700001)(54906003)(5660300002)(316002)(2616005)(426003)(83380400001)(336012)(6666004)(107886003)(70206006)(478600001)(70586007)(26005)(6916009)(186003)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:11:54.8044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a15f3ebe-e45b-4955-3ee4-08db046f097c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6707
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 net/sched/act_pedit.c                              |  24 ++-
 net/sched/cls_api.c                                |   1 +
 net/sched/cls_flower.c                             |   7 +-
 net/sched/cls_matchall.c                           |   6 +-
 17 files changed, 376 insertions(+), 48 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.h

-- 
1.8.3.1

