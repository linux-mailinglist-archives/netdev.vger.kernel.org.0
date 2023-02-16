Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E72698F27
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjBPI6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBPI6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:58:20 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20613.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::613])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C3F3E0BD
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:58:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gbq9uRFx9elJIbdIaxq0XOxCCzyfLRFvGg3SHUaAW1MZWByWaeLjSDP7S8iLWG0JX+JonPAO4NjhDxQRVXISiWVCAaNiRzCS+0QTNXHklgYBZWdGpCaLB0UK/HGPbsbr1wo5w/u+UsTbIztTq+rW19suBXwTJ0heGCsPvu2vEMzu1eWuwUCQimpfgYzCNTc4nhWOE4a7N90ay4O4zgMuToyigng6v+bp3ZaZM+b87Q0mKjO+Vfh5h0WEOMbjrbcJAY7ttTs4E9ualiASrvMV/Eynf1UFCJ6WGK0CU65XZJEa6SDTv+7a0031bxb7gTQGmefu/B7z+LlNzIO36BPYgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KC8SqXr25B+LBGfgMRTHT0l1aWHQfPKNR9G5T4kFLA8=;
 b=YZahwsbvrvV+mKvlfxsbpg9NV8LEyYwMg9QHZ11uaEUvdFC+BEIJNbUI73qOr4+nFnn40FEMM6bHJOx0orWftkVGdJapCV/zV9GF4kkUitRVdbITlQTX80Z2YiMBiJ3asBDBvAMrIRven5VBlw6GIUFZ8nd6lkFNYyj+GULOLvv9Ixooh+8XBksJcStja3ukj7EOVVNT2bb7Kg6nsOc7XiwJrls541VwFjzHnzDBBEuh1z8J/CEe5Ri4yhqhq1XesxN/cikvUPda5jwy3nabXDH4AFq7sOitVTB3MQJN882VycIYy9cw/+i5nkROmNkG+SQq87curE+auqTvtwRgdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KC8SqXr25B+LBGfgMRTHT0l1aWHQfPKNR9G5T4kFLA8=;
 b=MTE/zRUbVM+fLh1fLfDJrQO3ABxFZX5z/VBpsdgjW1Cz8UyvkMipg+SQZhP1d24X/TGRVfbIK0Q4LVPyzIAS44EOMNhonl4a1GPO/MGKMhMbUenUAJC3WmZBUqN+UE3HeA16womcgjtKptkp23WplIPM9zS/Dxz/0QyyYv/mlLNgIpIFl7G61O2Xp/0tO/JZ9lWR6UUr0/mXBRvv6OOinb8UME5tWpskKdXdtGgBVcgOEaOXsnnVI0Dis+wbsRfx8XnsqD67OyksxdjtRqYtzIdwKRdKwA+tKRuYn5tJnsprIhrxrHpb5s6wn5wRnlrSBjdLl22B8XUoFFyRjc0vXg==
Received: from BN8PR12CA0026.namprd12.prod.outlook.com (2603:10b6:408:60::39)
 by SA0PR12MB4351.namprd12.prod.outlook.com (2603:10b6:806:71::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 08:58:13 +0000
Received: from BN8NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::fe) by BN8PR12CA0026.outlook.office365.com
 (2603:10b6:408:60::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13 via Frontend
 Transport; Thu, 16 Feb 2023 08:58:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT088.mail.protection.outlook.com (10.13.177.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13 via Frontend Transport; Thu, 16 Feb 2023 08:58:12 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 00:58:00 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 00:58:00 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Thu, 16 Feb 2023 00:57:56 -0800
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
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v12 0/8] net/sched: cls_api: Support hardware miss to tc action
Date:   Thu, 16 Feb 2023 10:57:45 +0200
Message-ID: <20230216085753.2177-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT088:EE_|SA0PR12MB4351:EE_
X-MS-Office365-Filtering-Correlation-Id: 528e9384-ea68-4359-5177-08db0ffbef4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ULbWhASMBteQqP9L0T5D5S52G9p3UNPevPDmsJ6pzjaMIu6PyjFzmW6sCSIr6BS46vvEyV1YQaEYus3OhG5/gEsn67Ht3iMSwHS0rBS22bVJotdcimzbfrZdmAg5z5Ghjf9unwUvuaSmMkQfxZ2yaxHyZQncoaGTunaWMruyHXoxShbZuRtnRssUS26w0ozks5EMst4UnnU26YGx+S4pS5EwcFHfNW+Kscs4OyuvmrjydfnsYnvfK9DJivurRTbQI6YwlI2Mv18FI7yMMPJoUbzfqycE4H/Hcx7gFW9FySomsTwvohbsdzKNv2EMM/jUXl2KpJi+BqwWmc8+0Q+WSWfyHYrMMPcnMThFNHJN18Z1n2Jbnuz+WfZKpzjCpHZRpXNn6/W3EECJiF5Bhm3jLZj9QBaPMbJDLJSfjyjlZZEBOZzduhXX4ggWtdwOvFOUqZ2A2ep85Ag5XRvzfNQIyzXdOgaJKRD/W/ODzcQdn2S6wUl5lyVqxpXpKLR/CR93zpetxCanNcVNYfWOHplQ75nKLKYAHzE8FMcXkevoXacN39TGiLD1Wzj0Mmts3YEBsKg987jKog6oOyYQYUP4Mrs3g+y+ZdONS1vEATZAmC/nVRTW2ZvTpZpNn9iGBGHfh+mF6TD3qwRd8ZWih0xfhWobFv67w5u3BbyShlDm8d5lpdzpFY1NNSYMVSwrA2TTmHm/7CMT48e0imDiqVKW26XCtPEA3NdfrEQnJH3TtsM=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199018)(46966006)(40470700004)(36840700001)(2906002)(5660300002)(41300700001)(8936002)(4326008)(70586007)(70206006)(8676002)(921005)(356005)(478600001)(110136005)(54906003)(316002)(36756003)(40460700003)(40480700001)(82740400003)(1076003)(2616005)(336012)(186003)(26005)(6666004)(7636003)(36860700001)(86362001)(82310400005)(83380400001)(426003)(107886003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 08:58:12.7121
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 528e9384-ea68-4359-5177-08db0ffbef4e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4351
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

