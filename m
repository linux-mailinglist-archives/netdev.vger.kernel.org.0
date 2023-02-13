Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61020694F03
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjBMSQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBMSQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:16:08 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on20621.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::621])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71DC18B
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:16:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izyiWCv5VJ/gyZWrPedPXhEOFPEElMINKCV3KJZ8g7BHHY4yX/+n/o5/Pgq0SQ1gcIxI4zCrZRfqMxDPkvK2XTEafGUTeDw2XE3BllsCEv/yucs8qdPwflRLPSjP41/fMQhlerIlqZ6kXR/UUyUa6qQZOrAFrXDjqQXdyXqKQZUAX9EJ32z39dM/rM7U0oPSbCoh7Ws8+awLzyAidVJVLQcm2o1nvk+MOdFnygd7XW91uRdfoRgJnE3cAPheSYS3pQ13fIqUAvYdMt8eDobX+hl9JaBczoN1pbPRHRmaA/ixpRu1sq9ua/5ehsExI40G8vcPdnMzPNTo65gFor1hAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vGTnVt89K+X1GglL7MVoEYqr129J5uszbSAdb6O6HTY=;
 b=T2oQURzS200JI4FmFDMyMOrGZXFoN+05ppf1jugSsIqGY8z4kb5SiR07VkwY42k0oavFLmHPzjOGCOtvSzR0fz36IxFj9zCxMVMS0EX8S+MCC+xSf97ckEhFElrb/S7IHXTgTeIVoblJagL2rRQTeM0Yj1tMLjNp4VGmiDnDN+jh0FbE7TGeOFD3kBQ3/w6+F0VocEDPOWkHfn1PK39lFUh1xjp8/IbiYG6zaFE4gNkT8ZfcJ3MesESeE8fquKs0XB0U/NfVfULpGHyXR7bzjvFF+sunR+R1JvGjhaQ0VlyoOmFuqs0e80b7/vYkBYyHCmYyP3USEQQ1vPtff7ujRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGTnVt89K+X1GglL7MVoEYqr129J5uszbSAdb6O6HTY=;
 b=aKLMbIw0tvrLyQkDhpAXqb0UR5l95YNq4eR5Ls2TW6CW1sCIDNTPgVEdr2RyxOnewQlhz27uYA6e4of7/9wPiJVpFw5W+0Pzzt8feYGXVtU2jU/qe+LvYCLSusCwBUDQtdDxstOxqCfHShiKoy2eX/tNnlLPyCdEQCX4D7O7lZbR0GVdc8sqEShEXhGgSPZp1fGU/vGtX7X5owaZ5kzc5wijYC9uJyx7VT7kVa+g76cWHEcOztPbad5RLUWhBG+EWagZ4dOxm2tiRfwTxLtid9PO/r/Ef5FELJCH7mcIHkUq1Vmd60aufXoY9J1q4jr7vQCcOe2jcRy1gmDy42mr/g==
Received: from DM6PR03CA0031.namprd03.prod.outlook.com (2603:10b6:5:40::44) by
 MW4PR12MB6778.namprd12.prod.outlook.com (2603:10b6:303:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 18:16:01 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::e1) by DM6PR03CA0031.outlook.office365.com
 (2603:10b6:5:40::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 18:16:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.22 via Frontend Transport; Mon, 13 Feb 2023 18:16:01 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 10:15:52 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 10:15:52 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Mon, 13 Feb 2023 10:15:48 -0800
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
Subject: [PATCH net-next v10 0/7] net/sched: cls_api: Support hardware miss to tc action
Date:   Mon, 13 Feb 2023 20:15:34 +0200
Message-ID: <20230213181541.26114-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT047:EE_|MW4PR12MB6778:EE_
X-MS-Office365-Filtering-Correlation-Id: ea7986a1-d1f0-426a-9802-08db0dee5cea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nXXf34Fg5Q5m1584B41sl4x+MSyccfT8P7YrsVxDJU2NINHoMxWDDqCxb1gFLHYgP6luzoUlWTS8SjvdEMZq04glS+x6JynMClz7hk4v2/wXW/8fETAilKmtl5oJJVRPns8crQ780n7fG51s0IH+MIrHiPLWDb4wNniXQfzea+gfI60EsoWYtDG+hb+MI0fmlJACX4tJ3XwKaMuQli9Pv+B0HyR3Leot1BDo0ybaMcUKWw/kkV9awyHHWDkAwcLIg7SbMJ8Xbj7ufAGjigs6b3m+CS7C+F9W3uNvdUuCcaI9rVSyhlYhuE/Djh7ysupGuj3O54rb3DwW7p8FaPpB5CXscaFl6Ls9/yJFscKmYl+sFQymOMc8150/5mnW1a5VmPWYipyTE1WiHNULxVAVnnUj/XyUPTjaUS32lnCTsWXlefA7gBOafDpTdsOAWUa0bmCLGy9r9bfGceT/8KM3Q3vssOmCeCL2Vms4uDAjyieK9Ig9QHPjm6OVU+a1GT9EBjBdmXHNicryKZA4puEp+xS2lZhM1V8pw6bx5exxsofC+kmiANW6Cynd8w/wSPr22EzvU+ceksWMLEzHB0L1P4fp1mj85XBNlsxGxaThB/aL7uIR3ARohpj3bXbk2tI1aBMcGkwiZ4te8RWtAwMkc/T/9PXZ1/VooMN6lGV8PJnwWOQUAr++6jBr5643QxmCc/EcuNP1LTqkhJcSrYuBkDy/qs5+nrEz6rnPlwmi99o=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39860400002)(396003)(346002)(451199018)(36840700001)(40470700004)(46966006)(107886003)(86362001)(70586007)(8676002)(4326008)(1076003)(54906003)(316002)(110136005)(36756003)(83380400001)(40460700003)(26005)(336012)(2616005)(186003)(40480700001)(921005)(7636003)(6666004)(47076005)(426003)(41300700001)(478600001)(82310400005)(2906002)(70206006)(356005)(82740400003)(36860700001)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 18:16:01.3750
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea7986a1-d1f0-426a-9802-08db0dee5cea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6778
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

	v9->v10:
	cls_api: reading ext->chain moved to else instead (marcelo)


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
 net/sched/cls_api.c                           | 215 +++++++++++++-
 net/sched/cls_flower.c                        |  73 +++--
 18 files changed, 604 insertions(+), 327 deletions(-)

-- 
2.30.1

