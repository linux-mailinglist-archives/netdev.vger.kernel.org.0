Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4CD968B0BC
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 16:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjBEPue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 10:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjBEPud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 10:50:33 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8C81B572
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 07:50:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fKHcNKzYz1S3RStdamIwwKi33sRQOrYPShnN+L0iKJ3p7N+5B6HglUut4ezJz9C8iKlCYvA5KF5xDsXgFlg0fGqzbRo7YAv44jWYM+YI9dr6Xk8gucttQL1TjiCLjIWX9khjcpDFVDy8BM9YBxlrRg5RZ7fZFpS/Td6TCN5L8euDKcywIoLD7Q9WlWNEm15/BK09mgz09ppNhilz5Q4q1qJoT/3KNW+59cnmJCZ2VxZ9gfTvM3V6q8uDkFIZLhuFQ1fVJ1ZYhuYw/wXUgEi0s/uMd1hwOSThsP8FWbFUga9GaXfvVEIQabYMxbyJctHRYnE8QvfwSpRbxsN09heqog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7h0vGlVMU7sg60fvCJrbtFbDji11mY/Yg2Ds0LOgT0=;
 b=KZ4FrngYV1MSccnDft6pBRrYAwj29EXd15oEFy/p9V3ZhNQfnVIRAr8rr0gr1QYhf6Frn4pkIe740FyFXDSo8ZsVHsMtArL7Vlwt9ah21CVWaNxEDmDTb3+11zT0xn1wHOPU7PNZ6fzZKBfcVrLa5ljFBMnvB3Whm7xXX5kmmT0i+EK1VKAFFVomN+rIinL6o1lEON/VLNnRH5pHDtYB18Tc24eNi53WPltP4Dn64Gkduz9AJylm3s4MFwoXo8qYsQThVp2yDFP31DEisFTSPaS8OffPk0C/iARxwBau2kYBz+JjUIF988cvDVmzi5oTeEZbufRXmGOYlVheHTis5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7h0vGlVMU7sg60fvCJrbtFbDji11mY/Yg2Ds0LOgT0=;
 b=tGJWagqMvPZ0QjxhK0P/wvTxYAkbZrpUfVJe4ULZAPVGTQmZ+BWEHk2sjo3ib7WTObmTYsOSAQEkqNIRy+ciO5XD7HJOis34sevXunVyiLmmiDI8LZm2pFo+BN9TyXgnbZj3N59Qpywg92bWoVALRw+OcBVEmv5Az2ESJ4jSfc2/nyrw9i0ercVAEOg3RQhLCgbCSUnqK6NfgplxytFhr0Nn9XneQ0lfPc9OeqtsJRdc6Vqh9CMiIZ34SI+si5/Q7kaLnrk1zoyWRQwe6rRVlA9M2LAjeca3MXonHdPG69rvI1sPLahzHlqp2GXWu76ijdpc3Ld67dd3L/NY8cPLeQ==
Received: from BN9PR03CA0692.namprd03.prod.outlook.com (2603:10b6:408:ef::7)
 by DM4PR12MB6182.namprd12.prod.outlook.com (2603:10b6:8:a8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sun, 5 Feb
 2023 15:49:49 +0000
Received: from BN8NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ef:cafe::e6) by BN9PR03CA0692.outlook.office365.com
 (2603:10b6:408:ef::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32 via Frontend
 Transport; Sun, 5 Feb 2023 15:49:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT078.mail.protection.outlook.com (10.13.176.251) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.32 via Frontend Transport; Sun, 5 Feb 2023 15:49:49 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 07:49:40 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 5 Feb 2023 07:49:40 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Sun, 5 Feb 2023 07:49:37 -0800
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
Subject: [PATCH net-next v8 0/7] net/sched: cls_api: Support hardware miss to tc action
Date:   Sun, 5 Feb 2023 17:49:27 +0200
Message-ID: <20230205154934.22040-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT078:EE_|DM4PR12MB6182:EE_
X-MS-Office365-Filtering-Correlation-Id: f999386d-1f9b-4f32-f4c4-08db07909d21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N2GZM9KO8ZPIQUuksWAOmAuMouqOhZuVH0lg9/ED0C0rez2iQvG3pGiOe/Iq1SG201Z4pm6vq5AULQbuioVNB4edH++UtUzezF9cYvB27cgx2n6CB33oW0OObS/FHn11U0vIKX/U3L1R3M9KCYl3RIKOSMxLhIOgr+MlN0i87rt/OYR+W2UK6alejeQmC9QN0HAU5OZFKxkl8TVV0c5XseX4rAKXBhglUebFHmYw3VwpVCgKVHyrn+yaa7DxUrIE53Ut17TMsd2WdT2iBSiaTKj7qewPS6LFR6cyqMDH3r+jpUSNGFJevdFR6GUX7V10moO303s5tRLBL29t/O25ZhkOSHlewypi0/5k/kwTDFQW3zmek6NlvXtSRxk7nZc/a+s1q0KahImWwLQL45x4k3y+ybBRs/YIOuGSCGPxZheLNx13Wdy5Up2/6+dU/LSy7Gqvm6Y5Zo3mNjS7WtSro8rF7by0JunQ7wIYe/ANB9r96NWPJLA2aAdKftHfpWm1xcEVFMAa0R/R+BNj/qkP89vgjDve7mH2nSkYUws2nSyymenVpdZo+xb7IBXBCFQqmNTUvETC7/ZqhU72N4XA/MPEKJMjm1PcnCPMrgQH72yjsYsQGOVwq3Io3FTwuQBGew4yoArIiPMIRQTvEpFoBI5V5dYv9WgfpLgb40WGkzVxOcR0qNS1ij2OIZKLwBhViihonm325h4g2LB65x2t0Q==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(346002)(376002)(396003)(451199018)(40470700004)(36840700001)(46966006)(1076003)(5660300002)(36756003)(2906002)(186003)(8936002)(83380400001)(82740400003)(478600001)(36860700001)(7636003)(26005)(6666004)(107886003)(82310400005)(336012)(2616005)(41300700001)(47076005)(316002)(8676002)(70206006)(4326008)(40460700003)(70586007)(356005)(426003)(40480700001)(86362001)(110136005)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 15:49:49.3959
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f999386d-1f9b-4f32-f4c4-08db07909d21
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6182
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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

This series adds supports partial offload of a filter's action list,
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

Paul Blakey (7):
  net/sched: cls_api: Support hardware miss to tc action
  net/sched: flower: Move filter handle initialization earlier
  net/sched: flower: Support hardware miss to tc action
  net/mlx5: Kconfig: Make tc offload depend on tc skb extension
  net/mlx5: Refactor tc miss handling to a single function
  net/mlx5e: Rename CHAIN_TO_REG to MAPPED_OBJ_TO_REG
  net/mlx5e: TC, Set CT miss to the specific ct action instance

 .../net/ethernet/mellanox/mlx5/core/Kconfig   |   2 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 225 ++------------
 .../mellanox/mlx5/core/en/tc/sample.c         |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  32 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 280 ++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  21 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   2 +
 .../mellanox/mlx5/core/lib/fs_chains.c        |  14 +-
 include/linux/skbuff.h                        |   6 +-
 include/net/flow_offload.h                    |   1 +
 include/net/pkt_cls.h                         |  34 ++-
 include/net/sch_generic.h                     |   2 +
 net/openvswitch/flow.c                        |   3 +-
 net/sched/act_api.c                           |   2 +-
 net/sched/cls_api.c                           | 213 ++++++++++++-
 net/sched/cls_flower.c                        |  73 +++--
 18 files changed, 601 insertions(+), 317 deletions(-)

-- 
2.30.1

