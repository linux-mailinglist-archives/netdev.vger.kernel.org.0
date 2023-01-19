Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8504A673397
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 09:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjASIYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 03:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjASIYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 03:24:18 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2055.outbound.protection.outlook.com [40.107.212.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFC6270F
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 00:24:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CmVZpKY/rSRpUdGuujOKwFxr65pYogkJTwaj+YcSwLZQB0l+P/LtOD48vgOFa9ueoJ7EFVtGjKLL3j4zTGed+nt4w98Xf2M/5uMUISXk0j/ir2afs840RiRb6IsWv+mNZj/dLiAcow0IogutgU7ely3bUFCVZgSxKxxCYMZh2L325JjPKP8tH1+UAme4oD5YUqcIfisA4pyR3aZx/Cv202nipA7TumEsDAbDVhHMDsJFQ4rOiIbIFzOPJ23ltTqRhjlCoIQ+wirUfsl2m8XrwEBdijTbEMKCfNidyvzR93QJn+BnNTOb5hbd1YGaAHmFZHbvXi42pvG3fpuCA4XcMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pDHtkkri4V/UwOJzQd4y1QqGgKrjBqfJJ+wzY4sOoJQ=;
 b=AfWLUxEjHtaPvdt2+rKk3QTvDqfML49Ed27NaA6FaqseJDB4Zk09dKCA1U/awcCDTHrVSagQfCsfc7QZ8OyGnc331kIdhEPTcj3efiqa9YPhW4I+wFEA7gCYI2kAVEGpOuxb7tcZEc8winWmonuodjyA0IvV3wjUswRfnm76U4qPdIbx70gyct0RnixLkR2ClCzhLksvCyPGN/VNCLRYcpvkJaGoucPoDu/mgMzNJWCaCJUi91zOL2FsmUE2wqIXIGRK2jAKJWenYPqHaAd+5TwXpaCOyx4R0319eg5peAsvRRuJdm4gVo4Ue0kx0bBQ2/K0cbpTixj2MUN0jam7oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pDHtkkri4V/UwOJzQd4y1QqGgKrjBqfJJ+wzY4sOoJQ=;
 b=A8fLVe0NhaWxL8Q853Ze3gqkPqEpLkGbCdyZKUImCloW5EigXnKj1gomTzg8FNcrpXutogGTPm0sso/YxtzLSq2fTl6N+RFCvhQPVsA9tmtAcqTHYOvqyA6VWO4hhS0AG6+Mhduntv2Koj0Bw/fc3oVD+klMGkQVGl7r7zcTB8H6uMb2itZ2+2BAUX55Y66DZamhFHMVtKKwN8tgRIKDycgMh+R5+U8YwWlMt6PLCHKhihdBmfuHiMWaFL70WGgJ5TbpDrV5NiLrJf9dBIt0ycLbCL+ihZ02MdIrXbcnaK2ZIjOWkXhygMHpisyrUUwBPJQv9AUmzePyqFtFGD9LAw==
Received: from DS7PR03CA0096.namprd03.prod.outlook.com (2603:10b6:5:3b7::11)
 by CH2PR12MB4071.namprd12.prod.outlook.com (2603:10b6:610:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 08:24:14 +0000
Received: from DS1PEPF0000E65A.namprd02.prod.outlook.com
 (2603:10b6:5:3b7:cafe::17) by DS7PR03CA0096.outlook.office365.com
 (2603:10b6:5:3b7::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25 via Frontend
 Transport; Thu, 19 Jan 2023 08:24:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E65A.mail.protection.outlook.com (10.167.18.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.11 via Frontend Transport; Thu, 19 Jan 2023 08:24:14 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 00:24:07 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 19 Jan 2023 00:24:07 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Thu, 19 Jan 2023 00:24:04 -0800
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
Subject: [PATCH net-next v3 0/6] net/sched: cls_api: Support hardware miss to tc action
Date:   Thu, 19 Jan 2023 10:23:51 +0200
Message-ID: <20230119082357.21744-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E65A:EE_|CH2PR12MB4071:EE_
X-MS-Office365-Filtering-Correlation-Id: ac8fe38a-38b7-4f74-df84-08daf9f68c8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wzXMZU/Cjo5nXQXia4IWElGYg3la007AYAL7aeDgbRrEs5Api9GrVU3B0+traDOvu9i2OCU2o+8v7p6H8faO4j/JbgZeyF5D1qiSxppFbUwwaTjr0fMvql1Rmgx3Wff+H9hj/BkNLRo5ZdEBlY8/S5suRZQND7R5/9E9TI05sgt6rUV+iOofBYmnlmKZhdH81l1AaHLzeSPPUPUytsjKMyfjxbdGNhsKB5D0yR15D2GrgOIz88jgFY/P7r6tgj3V/IaDjUDA8qie2xV0L7D1TtWq4JX6IQSrIxl3IbmaJEMIRKLqdLFeIN2PFa24haCONVec9q+J8D6Zx3BSsgGEbaKXpzr4hBmyTZnNbw5U/Jmzj3WFY+IoaRlwfpyAXZNNHA0t0mtiXZqEGU+YJ5QTHKHPd/4EUW5P96A/G/WGUG1sVUsPiJzyn2JU8FyY7wO9koRwCRFVotK+xUneBRYA6OwTNLSBFK8cIyjy2F6HLpSfdbpx2cYEo84wLbF6fySU3RTo0yocR2Ouut2uHoTrNEMoDPTgkJiWT2RICg1olIdPt6yTiAXGLjTitEyTgEbe++EiCM27Wa1n8Q9opVSwl/0F9NIM4sz+z8rbR/NP3tmG/iBgz0TfcpVdPYaOWJZyVewIijaDV7orZiVZoZNfJlnp0J7NL2jZr7kFfi6jyGPNKNiVy7SvvHR5DXByqYdzOFWhaR1YNpw1lPq2b+dJeA==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199015)(36840700001)(46966006)(40470700004)(26005)(82310400005)(186003)(47076005)(70586007)(8676002)(41300700001)(2616005)(70206006)(4326008)(426003)(86362001)(36756003)(5660300002)(83380400001)(36860700001)(336012)(82740400003)(8936002)(40480700001)(110136005)(54906003)(316002)(2906002)(6666004)(107886003)(1076003)(7636003)(478600001)(356005)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 08:24:14.0163
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac8fe38a-38b7-4f74-df84-08daf9f68c8d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E65A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4071
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
	unlock spin_lock on error in cls flower filter handle refactor
	Cover letter

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
 net/sched/cls_flower.c                        |  73 +++--
 17 files changed, 581 insertions(+), 313 deletions(-)

-- 
2.30.1

