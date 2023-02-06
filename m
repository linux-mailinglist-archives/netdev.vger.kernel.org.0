Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8275368C503
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjBFRoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjBFRoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:44:15 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::60b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BE023326
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:44:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJs+STdkVpaHuKAMUw499jUkc6/YGW2t/6ypPrHqd8V0fM2ahEeOQx+Zhq6qsuKlg4QAp8uTWpqEnWohYeNvebQCFyrkUAYFom3X/UIjHaDOqSKZ1d5uwsgAOI+C5XCdunJedYkkVoLKkbVAQWw2/fzA7E/rTp+VSEmDXAposodP8NwwAUv1J2WD5Eq8yXwpIm2k2EyjqKTuPf1L0v2tev7UoNadjpoUoUEynuxSRR7uJg6mYRZ7Nlssn7FP/ZVZiQw+83+j4/JlCIopwFKOTKV2tdFZgAr3ddCB5b2XbhBuETn3VBFhxHm6CG9/nGCOAkVF5azse5hLS9d5FFX87w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=idHBYXluWP/70cXcN3dt3BzQn2T8u9jVVVVMQfMg4LY=;
 b=lLgmL8M5smm4UE3Ami1XgznTgGZQaWvg2NZ0sL4KF2fHAl0z4Pe4rl701kV83dLvq1HAdPUfT2+b24CM8muC5OkWLKaLsvgNqZOOgNloI2WldxY7MDkIKx3YHB+vL6u0bj4So3F0Wrmry0amg9XA6y2J/XbJJxoTt/9o8jqE53iSiw45VqQx5JO9I4G3t+afh9Y+qyMGieWACPpnaiN8XZiTBSrw6epcjWEsNUn64p3GJCJfX6oIiwJQQZgMFlYeeYO/hSHaouuuUkKpY+U18FUKmQLndKHoa/CfOH9XFjHED2svfUt9KR1SLpOIu/zaN8qMli1hKXTT5I8t8JRWsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idHBYXluWP/70cXcN3dt3BzQn2T8u9jVVVVMQfMg4LY=;
 b=PNuHyhRHjlJR9heeaGT2CM4XtmXfOcb0eFg7dOn91Tq/3eKe+mGs9TP+6V6Bi/OxsaPF59H3NNQoVyuUWgATn+xbJa2u3sf+GUIBfNWTuKtalC0t0LddbWuSfVAo/8UcIEcgHrGbdiIFlZSXqjtBo6pAcYfYkgCGtabdq8KaRi9AmsEtIMWt+mJzkmkBkCMrdz7s0OZ9D8dqh0rMhEkEKOO9W8ffts5DyJ/4/WjhWw8O0TWvfxNs+KlU2uCSW/XCLMvEMHgbVYsaZf07c4ZFUgMrfsfHYwSTYgXsHU7mA20HSzNXQoE56LvyypH4/fS75k8PbAgFQwxEO0argL7o5g==
Received: from DM6PR06CA0039.namprd06.prod.outlook.com (2603:10b6:5:54::16) by
 CY8PR12MB7241.namprd12.prod.outlook.com (2603:10b6:930:5a::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34; Mon, 6 Feb 2023 17:44:11 +0000
Received: from DM6NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::8a) by DM6PR06CA0039.outlook.office365.com
 (2603:10b6:5:54::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35 via Frontend
 Transport; Mon, 6 Feb 2023 17:44:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT084.mail.protection.outlook.com (10.13.172.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 17:44:11 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 09:44:09 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 6 Feb 2023 09:44:08 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Mon, 6 Feb 2023 09:44:05 -0800
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
Subject: [PATCH net-next v9 0/7] net/sched: cls_api: Support hardware miss to tc action
Date:   Mon, 6 Feb 2023 19:43:56 +0200
Message-ID: <20230206174403.32733-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT084:EE_|CY8PR12MB7241:EE_
X-MS-Office365-Filtering-Correlation-Id: 62ec6cc5-1f67-4a80-02ec-08db0869c18d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lp5ar8DYYDBIPf9+oAnBnHWufAP0RV5QH+/bh8EjyXoh34iDxaTJnIvqw7mTm2G6ocd+5zXoMWf0zMY7OT9TXNbMbly9mFPPQV2f5UQg4tavUoZHKs6+Yv0V9zILEiuh0iV0azqaeh4aSMPnWnkiee2C3a4Szj7ij12yQkenyLGt9jDZSByqRyFchFkN5I9lHvxfH3L8TddkWy9eExe/yNvB5a70h4gFmo+NeBqsiudmSnxUKcguaHkgTOqmGj5R/vO+9G1/FA/8tCDIb/XKUmVpsYnJ6nV6ShDSX1WdFfu3G04LpOG2Q4ZAyW7f2NO3iolR6ODU4Mx5OyfibQNISZM2hvcxvtsaVX/+xrocObJs1UPECUw9PhQyPAHQ3u+FqlaYc5VpvZJJjpd4taY596nvqLJhozGtEXOWVC0PcqA3SeLAnuC39FCV6g7rlS7fFujuz7EWTn19rJdAufGPHI6fAw8xOJ4HHN0oNQsKCpRl7tMB+mTDjVH5lDb6pXAD7u8vOz11Ul/NtGQgvm4ZJed83luQJIpINPDCYfzc2BQiuVZ+iMy+ser8zG0n53ImxH758Vu3nAdsC5tdBQ3/2MQ9Gn4zDjfFHHp6W2FhH8d3gurlqkbldJImWaoScQS6/aG7OFEG48yKGu6IpRadRKGJIPlisr6pXexIaRn9aiDBrD8lvMp25kw1s8uodJ0zAF7nZWBYdC6FW0CrTXuEKQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199018)(46966006)(40470700004)(36840700001)(70586007)(110136005)(54906003)(82310400005)(316002)(4326008)(41300700001)(5660300002)(8936002)(8676002)(70206006)(7636003)(356005)(36860700001)(36756003)(82740400003)(86362001)(40460700003)(1076003)(186003)(26005)(6666004)(107886003)(426003)(40480700001)(2906002)(47076005)(478600001)(2616005)(336012)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:44:11.3327
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ec6cc5-1f67-4a80-02ec-08db0869c18d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7241
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

	v8->v9:
	Removed even more IS_ENABLED because of Kconfig

Paul Blakey (7):
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
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 280 ++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  23 +-
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
 18 files changed, 602 insertions(+), 327 deletions(-)

-- 
2.30.1

