Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E19366D843
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236150AbjAQIeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235889AbjAQIeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:34:00 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5953468B
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 00:33:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYCbB0KxXyHD6eYJNmfFT2jdOrFuspjj9hPWmJLycjS6luPfXZ++7bh55zFYcKmfh5lQncY/DRiGwNVuQYCv1I1YH3my0ZjSs8WjESi9z+byOU4gmzxmczBPpSAYUMvqbg6Vbg0gcGRKbcjfK8a052UceYrdIXwvnKexk3liiV/LqHEEe5hyaj6/djwtQz9gxpkOp6TASBtAyGfJ2b1BaeyvEQi5p3TL5uBzzTw5zN8PTPYKJ8aTzcs/oLRalhCmSpl1sZAARYagLoXwyk4YRJydtrhiPa06joukrtWViAHP66Z/vCvJKwbjH4STWPYGM9+dea3ETZWEDij7YAYQPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4snhps/B4/gbb8moHWZOoGBeDlVs6KdVEzAvSOe2jI0=;
 b=OW8bKpcAlmYQ7HZstIwLqntEsXksU+ROtsOPrOsJefplY4OFg6oDuwT0vyMHJX5PXIWpTqe6Y4IMd5PQD9umCUbysK9lFFkX4XLEdKhVAkOK0RkwXNg/wIyNoogVctaIhfBjVEFK2zlDxYmjmBLz4EeOz6DhyIe9yR1yEJCRrrG6VvEZZsdtunjyFkcIWDCglOv6TspjEI1f+19KTRvJlcgBCUkwbUL+zfqw1KvxGOlD1xHXmBznIxLalGYoLsR/8r0yo8o26Ln5gqNZ060SV6gIF7cQQoHNXzx5ZQzmE/6aQE+xQEGgPR6sXeIUs4keMPzFSW8FTqCypzQ7i8cpKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4snhps/B4/gbb8moHWZOoGBeDlVs6KdVEzAvSOe2jI0=;
 b=J8/U4eF0rkcZu2rYM+qt++yYFI0SLaenbpfkgDR0cBAadnd86OScMx78tr7yQKxlQsnQkHA3ALZbBcGwA8ln84Lhh+rQokRBKndbAyKty3aL540dNu3mC7Wn6hmhmoJpoTPj9/+lh4fdkYur2TcbkwYHfEy9H55sR7KVrXZBXImG5lIIs8XpmiAm67zj7gcWwl/CTf/BBRZiQZAGrEfwiRb+fhOLVJJohO0KVrWb8yYAy72nehurDp5thgphb7fMJ/pcms3hY7HfNpWfx0O68k216zkk2+ANj/wjDnfIB6WKu46jvenTuPkfh/FqumTH4rFdliIILmwY5O3CdHE+Xg==
Received: from DS7PR03CA0248.namprd03.prod.outlook.com (2603:10b6:5:3b3::13)
 by DM6PR12MB4329.namprd12.prod.outlook.com (2603:10b6:5:211::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 08:33:57 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::e4) by DS7PR03CA0248.outlook.office365.com
 (2603:10b6:5:3b3::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Tue, 17 Jan 2023 08:33:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Tue, 17 Jan 2023 08:33:57 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 00:33:50 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 17 Jan 2023 00:33:50 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Tue, 17 Jan 2023 00:33:47 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v2 0/4] net/sched: cls_api: Support hardware miss to tc action
Date:   Tue, 17 Jan 2023 10:33:38 +0200
Message-ID: <20230117083344.4056-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT008:EE_|DM6PR12MB4329:EE_
X-MS-Office365-Filtering-Correlation-Id: c28f6c68-d2fc-49c3-f6f9-08daf865937d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hpc1PSSfXNLk6OjMdvG5Wfb4sWOkb4chChw+H1R8fxBxrKYGkfZuiBpxDdV+Pxo71shTEa+u05Z8KP/mqtbJ5nAZZfOL4kdc2+iaq0fAjA/CD+mcVktYp6ex49/VZLJbDna17royoyMaWeiCBsigkrjlIpIYAfBus389zA7RwNlwfvoDii/ntfk6LPqjvVQp0gqrAAN+z8MyFY+LT7XxTZVtn3sVRRLGagtAMuB+CnVga3GD2xgBTj+BrnvOYSOSw4r2DRjYHVxf+MPn6WCXE9uLI7H9sMU+TIQQ8GPMHl+dbqlPcV+n8tjJ/+PPkMZadl0D/fg/A5QOPMjUcW5zeb3BowKfrR5BlI9dPYyCVvV0HHwtTiRGgH4zUromU1ZHgZE53h7uN5XrTMIDTnE9TteolEGroF3uWihFTeKfX5HUO+tSlzCb5yJb7Iasg5yDbaomvK/0x1C0kqOIAL5DgrGhyshOeKP4DRsIqO3df3rk6u6LuKzM8dRBfIn/VYsVEIRDK/FLtWscQZ3+bYYnOAFRkdnqEPIHvyjeNAfrkc4hGntCEARKVSzVO6rAmmxu2/InN2x6WjTqmtGBU/jyyt8IuDIiPHODgmJRVjwsyRzfhuZ6kjHol5B6zli9I6w5c/vnzQPEbNkooc9Xusi2iNuH4i6cU67KE3e/5T5odH/H5GHdD1R8kHVD5lvJE49TLnuxU7VpCVoJFONHsYIl0A==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199015)(40470700004)(36840700001)(46966006)(82740400003)(36860700001)(2906002)(7636003)(36756003)(426003)(47076005)(40460700003)(40480700001)(54906003)(110136005)(1076003)(316002)(2616005)(86362001)(82310400005)(356005)(70206006)(336012)(70586007)(83380400001)(8676002)(41300700001)(6666004)(5660300002)(4326008)(107886003)(8936002)(26005)(186003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 08:33:57.4831
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c28f6c68-d2fc-49c3-f6f9-08daf865937d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4329
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series adds support for hardware miss to instruct tc to continue execution
in a specific tc action instance on a filter's action list. The mlx5 driver patch
(besides the refactors) shows its usage instead of using just chain restore.

Currently a filter's action list must be executed all together or
not at all as driver are only able to tell tc to continue executing from a
specific tc chain, and not a specific filter/action.

This is troublesome with regards to action CT, where new connections should
be sent to software (via tc chain restore), and established connections can
be handled in hardware.

Checking for new connections is done when executing the ct action in hardware
(by checking the packet's tuple against known established tuples).
But if there is a packet modification (pedit) action before action CT and the
checked tuple is a new connection, hardware will need to revert the previous
packet modifications before sending it back to software so it can
re-match the same tc filter in software and re-execute its CT action.

The above can happen if the following scenario is offloaded:

$ tc filter add dev dev1 ingress chain 0 proto ip flower \
  ct_state -trk dst_ip 1.1.1.1 \
  action pedit ex munge ip dst 2.2.2.2 \
  action ct \
  action goto chain 1
$ tc filter add dev dev1 ingress chain 1 proto ip flower \
  ct_state +trk+est \
  action mirred egress redirect dev ...
$ tc filter add dev dev1 ingress chain 1 proto ip flower \
  ct_state +trk+new \
  action ct commit \
  action mirred egress redirect dev dev2

$ tc filter add dev dev2 ingress chain 0 proto ip flower \
  action ct \
  action mirred egress redirect dev dev1


A new connection executing the first filter in hardware will first rewrite
the dst ip address to the new ip, then when the ct action is executed,
because this is a new connection, hardware will need to be send this back
to software, on chain 0, to execute the first filter again in software.
The dst ip address needs to be reverted otherwise it won't re-match the old
dst ip address in the first filter.

Because of that, mlx5 driver will reject offloading the above action ct rule.

This series - miss to action, supports partial offload of a filter's action list,
and mainly lets tc software continue processing in the specific action instance
where hardware left off, allowing support for scenarios such as the above.

Changelog:
	Fixed compilation without CONFIG_NET_CLS
	Cover letter re-write

Paul Blakey (6):
  net/sched: cls_api: Support hardware miss to tc action
  net/sched: flower: Move filter handle initialization earlier
  net/sched: flower: Support hardware miss to tc action
  net/mlx5: Refactor tc miss handling to a single function
  net/mlx5e: Rename CHAIN_TO_REG to MAPPED_OBJ_TO_REG
  net/mlx5: TC, Set CT miss to the specific ct action instance

 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 225 ++------------
 .../mellanox/mlx5/core/en/tc/sample.c         |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  32 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 276 ++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  21 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   2 +
 .../mellanox/mlx5/core/lib/fs_chains.c        |  14 +-
 include/linux/skbuff.h                        |   6 +-
 include/net/flow_offload.h                    |   1 +
 include/net/pkt_cls.h                         |  22 +-
 include/net/sch_generic.h                     |   2 +
 net/openvswitch/flow.c                        |   2 +-
 net/sched/act_api.c                           |   2 +-
 net/sched/cls_api.c                           | 208 ++++++++++++-
 net/sched/cls_flower.c                        |  75 +++--
 17 files changed, 583 insertions(+), 313 deletions(-)

-- 
2.30.1

