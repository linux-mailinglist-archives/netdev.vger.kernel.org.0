Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFDA698717
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 22:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjBOVK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 16:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjBOVKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 16:10:41 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CEA7ED7
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 13:10:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NAwS2vA1LG36OcE0qlBkVFzDGIiXw3p/OhT1opkYrYUTiF6D9+cFjifreQDSv3QV/YdfnhyoM26LF/SbGO0hMp8GViLSzm0S3MHA7dDunS2iyofTKwIBkJYR58djAq3IcNcEWxYEiXSGZCEVvXbme0gQmnr0F1nmksdHx8/Z5ByXXUzMi8BJlmaS0vCx+z0mp0q73z8xsl/h5xW2EUKr6C3XpPwNNcpR9Ylmtq4SLjt0POGddfkK2LV3nTmrnZfRKEagadNco+rvvMwpG1rRFo8aG+mdNrgkXX+j/eKFT8UlXr9ne656L6/MNIsSifHQG3QHyOY8SmqFSsPGefZvRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KC8SqXr25B+LBGfgMRTHT0l1aWHQfPKNR9G5T4kFLA8=;
 b=SFtsM/2dE70Heid4lhUHL0lh96lPtDa2qDltjfI1qyAkHr1CX6vMxOrAGuBPjE51BGOHlFBp3dQcRYn41eMR/38VHGMnIFxWjmfrmBlGRsBkjWXG8+Yq4cVaqbVOaG8dFSWoZQkSiz+BYricjnenEKX44B2xVABelSU4U8q7+AdWw6HYO06B1qkYZD4vRBOpEK+CuR8RNdQOIGti7d85wjlvKY2PZJu5FhLghlWA0PRIn0sjTWKNgTfGRqNdeBybRj5Wg5SMGMk3FAFkJP0fOtnB+LJl2+VdZZs9gpmVvHRjW6wnsRBfAo3A4N0ubgD/LB+54Z1cVru/Rk9mjE6d6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KC8SqXr25B+LBGfgMRTHT0l1aWHQfPKNR9G5T4kFLA8=;
 b=akpnwh8AATqPHG+gEiwokbbEI19YzyyelGJU/9BgHWXX6uf8NjDkRffjiCrwhoyxwU72YslxVr8QnUDpdlkzCI5W1FWNRETYwWbj58x7LFO+rC82Laqo1NIk4XsPZAiA737XwF0DgwfiOH+stb1MMlnc7REGVLPn4VgAnQm4Bcq+q+84bUhzRdHFyE3c+FRHaPyD0jjYkov0Ly0GeWUPKtgzEwdG6PulfbcIuYppRKMcBBwJKrlHDzjlL5hbAXVtvDnVqdzDFpG+lSdnHYUJGqKVRShdQKonEMEvoIehU/TyCPaHJ9tZEM6b82KX8uCxhg547f6cdaPGS0oyrgnbRQ==
Received: from MW4PR03CA0213.namprd03.prod.outlook.com (2603:10b6:303:b9::8)
 by BY1PR12MB8447.namprd12.prod.outlook.com (2603:10b6:a03:525::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 21:10:30 +0000
Received: from CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::a2) by MW4PR03CA0213.outlook.office365.com
 (2603:10b6:303:b9::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Wed, 15 Feb 2023 21:10:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT031.mail.protection.outlook.com (10.13.174.118) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.12 via Frontend Transport; Wed, 15 Feb 2023 21:10:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 13:10:21 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 13:10:20 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Wed, 15 Feb 2023 13:10:17 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v12 0/8] net/sched: cls_api: Support hardware miss to tc action
Date:   Wed, 15 Feb 2023 23:10:06 +0200
Message-ID: <20230215211014.6485-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT031:EE_|BY1PR12MB8447:EE_
X-MS-Office365-Filtering-Correlation-Id: d24160d7-d9da-475c-e481-08db0f9911dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cnzrHB4Q9w5V2MFsx+dyUXMKXa0fUgJ/k++a3xqyvRRJ7YOsGBkVEDXRpoJUV+5SPXdKKByrBsIIiQOr4F+LvYxAbJV0ViVRYV7qkIakT1L5uh0clnJ0sTcVcQ5OyxanqpDWDyUH3Qppua+IQlcZcEXTlgcgfILJY0grBQoDF3yHN8X7AAHAkXlhVgqVhV52+wMNQtE/EkugE5XYulzZCDYFGCVPIIO2SMEM26on5Yp40Z5eI33dxOIde0qBf+UKysY81DcirmVQIitEqi0Fyy/8RE4WSqdGoGJhBwAVhQmxEVtm8U1ADjhnNSCENtiJnK2lpw0FzXKnnfty0h1x5nhATyeH88+6i39eo61bmRSeX1hXoSZISy1GDZaJkFCmgVMgYBhWXfgQR2QME/aTHZKKQ7OlIY3/YBoi9lXi64OXznFX5tsyxpeT3ddqe/l6S2C98HiC/ie2GexSP/jXCShCvXHsY0LkuBI1LuDry/084egm4h9cCUZXd8hvQ/rjmvpy40mFdVOhNhnTbjpci/3+GofzZp1Ru05qPwdllGlVud2zc9SjSjx7lbP3PhhpjSNurm5ocUDkUIju8iXa2npGlTsDhRmHMj6uXJ9befPxiIPua4BVjZcLFHXGOCTaTIVP0o5utBVlEGQLEl7oVGhBEkzykG+2HwJ6m2Qgmwjy1eSmUDk2zZcwIZpXQ0/G6628Gfi/Ltu9psDxtYWvo6GzpMaOIxt2Ex1z9VbEjbc=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199018)(36840700001)(40470700004)(46966006)(478600001)(47076005)(40480700001)(426003)(83380400001)(921005)(86362001)(356005)(7636003)(82740400003)(82310400005)(36860700001)(26005)(6666004)(1076003)(107886003)(186003)(336012)(36756003)(2616005)(40460700003)(5660300002)(70206006)(8936002)(70586007)(316002)(8676002)(4326008)(54906003)(110136005)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 21:10:30.6287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d24160d7-d9da-475c-e481-08db0f9911dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR12MB8447
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

The following is an example configuration of stateless nat
on mlx5 driver that isn't supported before this patchet:

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

 #dump tc filter stats on enp8s0f0_0 chain 0 rule and see hardware packets:
 $ tc -s filter show dev enp8s0f0_0 ingress chain 0 proto ip | grep "hardware.*pkt"
        Sent hardware 9310116832 bytes 6149672 pkt
        Sent hardware 9310116832 bytes 6149672 pkt
        Sent hardware 9310116832 bytes 6149672 pkt

A new connection executing the first filter in hardware will first rewrite
the dst port to the new port, and then the ct action is executed,
because this is a new connection, hardware will need to be send this back
to software, on chain 0, to execute the first filter again in software.
The dst port needs to be reverted otherwise it won't re-match the old
dst port in the first filter. Because of that, currently mlx5 driver will
reject offloading the above action ct rule.

This series adds support for hardware partially executing a filter's action list,
and letting tc software continue processing in the specific action instance
where hardware left off (in the above case after the "action pedit ex munge tcp
dport... of the first rule") allowing support for scenarios such as the above.

Changelog:
	v1->v2:
	Fixed compilation without CONFIG_NET_CLS
	Cover letter re-write

	v2->v3:
	Unlock spin_lock on error in cls flower filter handle refactor
	Cover letter

	v3->v4:
	Silence warning by clang

	v4->v5:
	Cover letter example
	Removed ifdef as much as possible by using inline stubs

	v5->v6:
	Removed new inlines in cls_api.c (bot complained in patchwork)
	Added reviewed-by/ack - Thanks!

	v6->v7:
	Removed WARN_ON from pkt path (leon)
	Removed unnecessary return in void func

	v7->v8:
	Removed #if IS_ENABLED on skb ext adding Kconfig changes
	Complex variable init in seperate lines
	if,else if, else if ---> switch case

	v8->v9:
	Removed even more IS_ENABLED because of Kconfig

	v9->v10:
	cls_api: reading ext->chain moved to else instead (marcelo)

	v10->v11:
	Cover letter (marcelo)

	v11->v12:
	Added patch to rename current cookies, making room and less
	confusion with new miss_cookie.

Paul Blakey (8):
  net/sched: Rename user cookie and act cookie
  net/sched: cls_api: Support hardware miss to tc action
  net/sched: flower: Move filter handle initialization earlier
  net/sched: flower: Support hardware miss to tc action
  net/mlx5: Kconfig: Make tc offload depend on tc skb extension
  net/mlx5: Refactor tc miss handling to a single function
  net/mlx5e: Rename CHAIN_TO_REG to MAPPED_OBJ_TO_REG
  net/mlx5e: TC, Set CT miss to the specific ct action instance

 .../net/ethernet/mellanox/mlx5/core/Kconfig   |   4 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 225 ++------------
 .../mellanox/mlx5/core/en/tc/sample.c         |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  39 +--
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 282 ++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  23 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   2 +
 .../mellanox/mlx5/core/lib/fs_chains.c        |  14 +-
 include/linux/skbuff.h                        |   6 +-
 include/net/act_api.h                         |   2 +-
 include/net/flow_offload.h                    |   5 +-
 include/net/pkt_cls.h                         |  34 ++-
 include/net/sch_generic.h                     |   2 +
 net/openvswitch/flow.c                        |   3 +-
 net/sched/act_api.c                           |  28 +-
 net/sched/cls_api.c                           | 243 +++++++++++++--
 net/sched/cls_flower.c                        |  73 +++--
 19 files changed, 635 insertions(+), 358 deletions(-)

-- 
2.30.1

