Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F132693787
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 14:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjBLNZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 08:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjBLNZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 08:25:51 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2086.outbound.protection.outlook.com [40.107.102.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F856E079
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 05:25:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9kQhDYiz3afOPp6nHDV0DKcTn6qV6gI6ctkSn1XN62Umi2hHGAamo/afaDl6dIYJjjptZzIc/P2mEm9aui4ofsKkC6/LBpKTpKgJiwaNEK6tC/eTOfPeDrDdd9VL5jDf+2cO3cxrsA31nArng3vkX+i4FCnijLpxTEsMbSQNwAecHzlbMfikMJZMLvfmDod/BKiKIqFGvlJ2omHEokkJF38IfwDX5XlEQzf5/DlrqiaWW+0CbK36GPeTrgNC5V3mf75Ta1GoAg9YI1AFwkKhjza28Wn8qz2aFKDJ+GlWXeskKJYSgcZIzAvAA0b24+uVjijxohgc2UKlyb0UccQBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B+TvAtJV+egVc2Ce1zpglcMQNZnX2qYTps0uS0w7+lQ=;
 b=RZDfzHBrYeHliNxN16mlcXzCUp2bUBrbO9jJ42Ln63hxMXn3rV8nIxDX6I+OytXQy6jEMJsq8CiLoz2P6eJI9MoKKzDxq//hzUKKlvVHxBIq7DhQ/mP18c41kdwwZAMTHUJ9IhW6+aQg57SPnA7raD4fWH0ZEIyeYPyqWbiU0Mhfnh3W3OJT1sJ6bG9fgbgzS6q3vS3UumbIBNofXnDfRW6c8Cpl8d5x1BfbRXyYu3cwrd/M3w+oDT1irxMqzj0oHe6aomQ+Imk1qzuNfW6n7hC1TM5dBw9HPC80NSrFsR3gpeSvMmX95dxaJiel0vqkUkPdkuzmRG2a3hr/4G1Fzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+TvAtJV+egVc2Ce1zpglcMQNZnX2qYTps0uS0w7+lQ=;
 b=aJuqcu6V1U8v5nPjbAxh90gpH5NKpL2bs/jrVtcA0Dg9aTk1/PllC4GLFWMvHISEjoTcL4rpsx+EHOzSa5ItiJu9izSnU5y/ZS9QVTgsdVjHzNk6Ou1p0K2/E9mYoNP27wZg/r76/+DQu5UKNoJTeb4mfnfeiXZA6Yhy+u85KSXiTu20dC3ZsaBTJPXTwEUofwjo8VweXX+vdDKEUwM4KJqYDJtxKlB9ky9ORseyRpsiIZcuZKneP4P28kOiytzqEAwfWZPx8hW7nUOCbc7WKxYrotDgYrQbebNRppBUzh3h0a3B/ayAVEApSA8tk3b8Yvz7Gj3s7rU//XYul5aINg==
Received: from DS7PR03CA0054.namprd03.prod.outlook.com (2603:10b6:5:3b5::29)
 by PH8PR12MB7028.namprd12.prod.outlook.com (2603:10b6:510:1bf::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Sun, 12 Feb
 2023 13:25:45 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::d1) by DS7PR03CA0054.outlook.office365.com
 (2603:10b6:5:3b5::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23 via Frontend
 Transport; Sun, 12 Feb 2023 13:25:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23 via Frontend Transport; Sun, 12 Feb 2023 13:25:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:25:38 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:25:38 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 12 Feb 2023 05:25:35 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Oz Shlomo <ozsh@nvidia.com>
Subject: [PATCH  net-next v4 0/9] add support for per action hw stats
Date:   Sun, 12 Feb 2023 15:25:11 +0200
Message-ID: <20230212132520.12571-1-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT068:EE_|PH8PR12MB7028:EE_
X-MS-Office365-Filtering-Correlation-Id: a5b26f40-0a4b-4c8a-2e18-08db0cfca5d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V9oYyFA1sfgo+2rp8ExF+nS8Aw7/UJHpRkEHAvkAfKDQSYjR/WsHVVcfF24V2Mf7Q6qoJSQU/RE/o96GzdgiwrqPPD39AvUrPb0zeOoxjEiPO0j3K0foUjkjbJBQ3OGlNQ+Q/uExRlQsa4QvyODrj+UOOxKYruh4aV9ZjajKCgMHJ3ZpRD5NJf3MI7BLIyGE9hB3JhEqjRk6g7t9JJLifusoWjPPig4XFWEigqqQsEQ8t1kZJr2bhck27/gBr0RzsynbIjVT38wGdqC3q45bn9o1mn/cVNWeP1vWf7lvoTUvveGtep9H6d6xSFaw406Df95Cf38nyau0EsJjb4fI60lGwIaUn9EVr8M7XDzIEYQb4XRdEVdtimFWEVIL5kPUM3+bglG76b+B01993rNgUYXG9Ugn6OGOU2EKM8HcQ6VtQjfd5DLSQ0GC6k5VxLn9LTYTxMtGgvsH7Jqu1/h71CSVCuo5DOpeCD7ShBORi7+f9YNQGQlDcwYelf1xaPqQcfGYDHOrHRuffGI3FOaetUY7Ba62fw+xEMnjRnQHpYj8z32i8PBOjdBBqrotTuph66oVamsmoWYiWq1gnMi0oXBiH7O9cRTkw6/33xfURBjHgXXCt/k/wxs3WqMZma4MXdXE0gk92zEG082Bj/MpzaLhtQXnrc0CSR84T7jp3mMSPqzRFuZpH74SEDXRJdyv2M0AcaVfbt9RrUfQ6J/Peg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199018)(40470700004)(36840700001)(46966006)(82740400003)(2906002)(83380400001)(36756003)(7636003)(8676002)(40460700003)(36860700001)(41300700001)(478600001)(82310400005)(70586007)(70206006)(316002)(54906003)(4326008)(47076005)(2616005)(336012)(426003)(6916009)(8936002)(6666004)(40480700001)(1076003)(26005)(5660300002)(186003)(107886003)(356005)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2023 13:25:45.4826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5b26f40-0a4b-4c8a-2e18-08db0cfca5d0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7028
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
  net/mlx5e: TC, map tc action cookie to a hw counter
  net/mlx5e: TC, support per action stats

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
 net/sched/act_pedit.c                              |  23 ++-
 net/sched/cls_api.c                                |   1 +
 net/sched/cls_flower.c                             |   7 +-
 net/sched/cls_matchall.c                           |   6 +-
 17 files changed, 375 insertions(+), 48 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.h

-- 
1.8.3.1

