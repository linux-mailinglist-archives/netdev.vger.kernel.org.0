Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D6768BF21
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjBFOA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjBFOA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:00:27 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28200EFA7
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 06:00:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CFWOFTGdltxkVPS26L+HsGuqGqvUOGPAJRMEvutHJtamAK5d9zzgTV7pno+6ou8k0vykojL2ejbX4asyXdShHwY061F3alylAXDhzbbl4lLvI+6NFy9D+nNm48fpF/1LQt3He19/C62/hNvZ8iyoyGgZp/c/IBy1RrLDPsAAkodITZMnSBR3mus/XMJ54u6IiAsgF6kljeqbC5cR637UgahhW0MkTBvIzOZxZxO6mHjAjcZf9UJ+3NZctxUo3He4RcsFWFsxlaDwI4ubrG2b4WSKnBQFD3EU8HPOVafs/3/n0K2H8C6ySVaUFRcUG1HWscc6j6t+FZbw5xZeZ8GWpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KM5zkIQHrm0MhAHnS3Qvg5GcZN6f/bnG+1BQL68ucvo=;
 b=oCiWMOHp4+pDPw+10faPofg1R2ePgn51/QnZcUVUhYNLoCxc/HOfushIRXWlKNehAuSXgGENtvnrkcwuIus8uueU+HYuvskd4L+oSxYanV4Dy3UJtgbMqC9H2mo7siMyaWIIOWkYAJhE+/dnyMGPnjnLWzLvA0YKIN88j+Ex/qyjGK0QccaUDMih6vWeuz2vxXdA7txw1EVvBcYuCyCqHMotvUqJoRatez+EysUF+n25UgZUOzVDKI6dj/9rXQpTGqRZlykk8f/zgQe8gzA3vqxihyuOBnHPsMrVyNcKrZSHKw61vJ0bNSqOEQJyJ+NqX+SKZ6ARX4Bh8Tr2TeQEdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KM5zkIQHrm0MhAHnS3Qvg5GcZN6f/bnG+1BQL68ucvo=;
 b=YIYdUYtSk0qI6mpp67AanXeKhEmpsh8ASKP//Vh7dhBcHcZgWev8VouR04eJ+AyLEj0fGgLxksIIHVO51snnA5o58n63KtiwitxmbDC0QfEeyFQNriRXhrwjJY3uhjIbrB2TfkmWbu92mM3zr53jUp2SZNnt08uV6d8XkZ9oX+0pvWaaTddXAeZpvERV4zMnnFf5ZOWM0BbVUllgze2CXikmg91L7ZqO7de5qlJQbt0bwIkwRAlMPPUTPYt7EbU2dyhBH+dcRIjCwAOwVC3EuUZDvU3G89ZIJfuVw0E408Xja+ArEuMDPPiNrYEtJdAgNnjePXoqAKAh53wHw6dadw==
Received: from BN9PR03CA0433.namprd03.prod.outlook.com (2603:10b6:408:113::18)
 by DS0PR12MB8018.namprd12.prod.outlook.com (2603:10b6:8:149::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Mon, 6 Feb
 2023 14:00:13 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::fe) by BN9PR03CA0433.outlook.office365.com
 (2603:10b6:408:113::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 14:00:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 14:00:13 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 06:00:05 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 6 Feb 2023 06:00:04 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Mon, 6 Feb 2023 06:00:02 -0800
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
Subject: [PATCH  net-next v3 0/9] add support for per action hw stats
Date:   Mon, 6 Feb 2023 15:54:33 +0200
Message-ID: <20230206135442.15671-1-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT027:EE_|DS0PR12MB8018:EE_
X-MS-Office365-Filtering-Correlation-Id: a4f8978e-438e-41f2-b117-08db084a77c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U9A9nKZegfbLJESw1dSR0B9+jZf9dnM3UV4NuzgPzAXmlkX77/Z9ylqQx+Pe1/jF74v8wow1Vuv2cXd33GqB61t77QJ4r6EzD+FJBMKK7sohfvkGF7cpAA5YnZu4xpeft/V3LP9lVePEdCJD+E4igeW6NFzHMz9b39U/9r/vCe0NMVLH1u2poHnPUnuzfY6jXajWEh+T6v7F7HLdxuHsisf7hipSuoykAy3L/HuLrKHNc+vKQhNk7L2w6BlCSaI5vw85iSHtoE6iJomu5YBbnumy6KJLQKJsI+dIrNsLk8LIJ4vy2XR4K4Q/PKX0/PYmX4YcbbK9uKWwSxAMWzafPn+CLnq6tGxnZaOlyVW8bgx3hzTbuo/9cNlp5gWyXhBiEhzIyGCbTvN3KRy3kBG/KE0ei7/acGHwY0SjK8q4nvRBHcsSoQpQTHY9+cgqw3NS5hbasoULcImD+wRaAESh1zfnptWUL1d+Zcvu7eI0iXrWBU6R/JFQV8pkU6cipSm+0FqwGKEJIeqcmwqhIzGkwYtEDOTL5rHe5pm7ZFy45Ia/4aMjHydCtDuLNXXW5HwfpDToqkFamxs/Ttw/zRyxy4o3LPg5RYFoZSnfK3lqVxkS2JKyWtgVUS2un84zlwOpZWI/d9u9IoGbg30pM4vs49nwna00CmRSG1+X7DCl54sLGUMnhqUmzIAtsqpiWYQPC7PgQ79ZiB4u96JXzirAfQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(82310400005)(336012)(36860700001)(26005)(47076005)(82740400003)(40460700003)(7636003)(36756003)(2906002)(1076003)(6666004)(41300700001)(107886003)(316002)(40480700001)(4326008)(70586007)(2616005)(426003)(186003)(83380400001)(478600001)(8936002)(54906003)(356005)(70206006)(8676002)(5660300002)(86362001)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 14:00:13.1163
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4f8978e-438e-41f2-b117-08db084a77c4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8018
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
 net/sched/act_pedit.c                              |  27 ++-
 net/sched/cls_api.c                                |   1 +
 net/sched/cls_flower.c                             |   7 +-
 net/sched/cls_matchall.c                           |   6 +-
 17 files changed, 379 insertions(+), 48 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.h

-- 
1.8.3.1

