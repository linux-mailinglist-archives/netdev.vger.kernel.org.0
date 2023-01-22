Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2158676DCF
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 15:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjAVOze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 09:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAVOzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 09:55:33 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34C61A4A4
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 06:55:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzFHy01gtIUWeFt08aH44mnLFWdTlBXh6rljRjIQk4HiazqViicL4aNO5EvIT8JC96OvQp+EZsiPe6bgW1oxrzzbC1h0qR3N77T4wQlnFiYIAP1cGZLLFc57/a3bi+Px+50P1My8GXYo4EY8xTURudlOuYFzS6igYUTeIT1P414FHhLqrP6OoHvhOS0592UUBAxJP6JET7Y0BzetMo5ONN9jE9W6yaJb4lJ5lhczb1O5tbbzqag5/Vg+O2Gb08/CYO4AAm0WnkqBsbDFZckR8EG9Xgq+I7FEI+lFWAgW2g5+irXigzRExBVC0O7AW5CjngUyfsjhsfECJ7bb5RrSlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OfgJw3YcgxGLOKr8oj+MoKXl6E1FJS37nri+TbFVXVw=;
 b=hqXcQrumf0bJ9MXOpSw6beFbNLTYos+rQLUQHsFPKTTUNf9IbPquq7I64WoU0wEM3C1RY7tthjL8bfTRvyCZERVK9hcq/AtUSMnTbOy5z/bLWsPUgfuGps1a87feGqy2O5xDO2gVJBCbJ0Q+q+7nremLX5bhwUHnzUjgXsIMLFCXymCSbFK9kuFQa6g/WAXfmrZm90z6y92I3VDGnJZILPqu4tH7h7WsILSOn8TTmEnEa1snyyZfEMWNuxqkp0fXIEkNODVPYWDMHylanFLVw/jCfMCrgJ8NPff1JJL9Mpwf7YLhNKOLRMXDitQTd6QbxnIxboEUBdBzIjnYCe4rew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OfgJw3YcgxGLOKr8oj+MoKXl6E1FJS37nri+TbFVXVw=;
 b=XSYLfnGHnIklgTFhhMwm+BlEB4S485wvDmceytTUqu/U5v+vcHfpjGScWOg8ruc/7PbHkOHrUCC6vnnIaGu+uHG7lfFTOTcmX8bFV7w9imj0/JKz83QTER0OzLgmZnM/JHgI4zH63BOl25Vt4LwATWDblLVM6Cz89qj4WaLnZ99ira74scXHfsqDnx861/ZhYsH7T31gg/sefyFYDJ9c9VN+nJseBeV9MBpPbQdIBS/4ihXJ/P1I/iRbS4C0OYC/jeUPCf4CQAjDfDiyRtwQ26uq438R66LU74f+lanlZ2KVswZE4gyw/MbCJWe01aT9Aw4wfDKLw1YX6MI4zgCn2w==
Received: from MW2PR2101CA0006.namprd21.prod.outlook.com (2603:10b6:302:1::19)
 by MN0PR12MB5785.namprd12.prod.outlook.com (2603:10b6:208:374::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Sun, 22 Jan
 2023 14:55:28 +0000
Received: from CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::28) by MW2PR2101CA0006.outlook.office365.com
 (2603:10b6:302:1::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.2 via Frontend
 Transport; Sun, 22 Jan 2023 14:55:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT105.mail.protection.outlook.com (10.13.175.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Sun, 22 Jan 2023 14:55:28 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 22 Jan
 2023 06:55:26 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 22 Jan 2023 06:55:26 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Sun, 22 Jan 2023 06:55:23 -0800
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
Subject: [PATCH net-next v4 0/6] net/sched: cls_api: Support hardware miss to tc action
Date:   Sun, 22 Jan 2023 16:55:06 +0200
Message-ID: <20230122145512.8920-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT105:EE_|MN0PR12MB5785:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e858130-b6d1-410e-1c6b-08dafc88b37a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: keY0zPh/4crk5twYhJc0ceCF8tL+trk8jXZoIMoC+kX1lKfWbpoT3n+IjMmMfs3v/5qfTjj3VFid8r5+tVtHmd5o2H03UXjMK51AVKfca0437cC8QfuN/MfmH2/H4KEYUbPuVaD6SflExIoh9PbAzfdu14lR27/tfEPS1fX254xhJQvelgEUJjg+LlMLXPpvhyc/rmKRTFYqkcsw0ZgjlIgCVtZw7hwbZlSuTlV2qyjiVGYXhmdUyJLCCXoU7K8JIxGbAHa+zID1HazH/WVaj4qQxVRwWcSAWFIeu0nEigcW7+BdMKWqomjxZsLAzbCzcoF1yattPZHyozdV1OLr0Ei4aCDeqxeAQ+8QiQpwhukBIOyxWS12EHXF9lvYB3vWxWmDHl5xSGjlwTJIFbaq6LwyjzrC15Na3umnfdlz3Q/V1/cg5e7pYIK8Xh8KHEoDaASw2TkjcH7vxMiAJSEHOELAMqbRjaQOp1RwKkOvoTkC833MUgXDuk25EqoNbgg23yCVw7R8TagZaBqH71jcbPmf1W4S8qPYttoUsX0407PMzTtes1mrraZNeWg/4gnh9esArH3pXHBxc7yF7prZh8I/FlLlediJ5xIBH5fyTZiSnAxCDVXtfnc1GYhQByRjDFVsMCFyoxtwrQg07ABAmwbu2aKzXA9wrsYPqi9wQaqgScDoRmuHC4Hhi88ijPNfGcNI8yF2KQ+8hN8V7YX2QA==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199015)(36840700001)(40470700004)(46966006)(36756003)(356005)(86362001)(70206006)(4326008)(40480700001)(70586007)(8676002)(5660300002)(2906002)(8936002)(7636003)(82740400003)(36860700001)(316002)(478600001)(107886003)(6666004)(426003)(47076005)(54906003)(110136005)(40460700003)(82310400005)(41300700001)(83380400001)(186003)(336012)(1076003)(26005)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2023 14:55:28.2128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e858130-b6d1-410e-1c6b-08dafc88b37a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5785
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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

The following is an example configuration on mlx5 driver that isn't
supported before this patchet:

 #Setup corrosponding mlx5 VFs in namespaces
 $ ip netns add ns0
 $ ip netns add ns1
 $ ip link set dev enp8s0f0v0 netns ns0
 $ ip netns exec ns0 ifconfig enp8s0f0v0 1.1.1.1/24 up
 $ ip link set dev enp8s0f0v1 netns ns1
 $ ip netns exec ns1 ifconfig enp8s0f0v1 1.1.1.2/24 up

 #Setup tc arp and ct rules on mxl5 VF representors
 $ tc qdisc add dev enp8s0f0_0 ingress
 $ tc qdisc add dev enp8s0f0_1 ingress
 $ ifconfig enp8s0f0_0 up
 $ ifconfig enp8s0f0_1 up

 #Original side
 $ tc filter add dev enp8s0f0_0 ingress chain 0 proto ip flower \
    ct_state -trk ip_proto tcp dst_port 8888 \
      action pedit ex munge tcp dport set 5001 pipe \
      action csum ip tcp pipe \
      action ct pipe \
      action goto chain 1
 $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
    ct_state +trk+est \
      action mirred egress redirect dev enp8s0f0_1
 $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
    ct_state +trk+new \
      action ct commit pipe \
      action mirred egress redirect dev enp8s0f0_1
 $ tc filter add dev enp8s0f0_0 ingress chain 0 proto arp flower \
      action mirred egress redirect dev enp8s0f0_1

 #Reply side
 $ tc filter add dev enp8s0f0_1 ingress chain 0 proto arp flower \
      action mirred egress redirect dev enp8s0f0_0
 $ tc filter add dev enp8s0f0_1 ingress chain 0 proto ip flower \
    ct_state -trk ip_proto tcp \ 
      action ct pipe \
      action pedit ex munge tcp sport set 8888 pipe \
      action csum ip tcp pipe \
      action mirred egress redirect dev enp8s0f0_0

 #Run traffic
 $ ip netns exec ns1 iperf -s -p 5001&
 $ sleep 2 #wait for iperf to fully open
 $ ip netns exec ns0 iperf -c 1.1.1.2 -p 8888

A new connection executing the first filter in hardware will first rewrite
the dst port to the new port, and then the ct action is executed,
because this is a new connection, hardware will need to be send this back
to software, on chain 0, to execute the first filter again in software.
The dst port needs to be reverted otherwise it won't re-match the old
dst port in the first filter. Because of that, currently mlx5 driver will
reject offloading the above action ct rule.

This series adds supports partial offload of a filter's action list,
and letting tc software continue processing in the specific action instance
where hardware left off (in the above case after the "action pedit ex munge tcp
dport.. of the first rule") allowing support for scenarios such as the above.

Changelog:
	v1->v2:
	Fixed compilation without CONFIG_NET_CLS
	Cover letter re-write

	v2->v3:
	Unlock spin_lock on error in cls flower filter handle refactor
	Cover letter

	v3->v4:
	Silence warning by clang

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
 net/sched/cls_api.c                           | 210 ++++++++++++-
 net/sched/cls_flower.c                        |  73 +++--
 17 files changed, 582 insertions(+), 314 deletions(-)

-- 
2.30.1

