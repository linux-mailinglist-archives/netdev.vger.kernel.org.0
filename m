Return-Path: <netdev+bounces-3586-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43ECB707F6D
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:35:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF0C72814A1
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 11:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BADE319900;
	Thu, 18 May 2023 11:35:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A520619902
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 11:35:00 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E12A199F
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:34:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJONzYtMz5wRjb7+aWYH/nLr2dGmIakv3MdRWruB41AIE5t1lVgEVu9nygZJOS2M0ChsbT5UFDaUTiAYvqmBXIqRNgTX2zxFdKcKylxmOJgYV7TY4whvxs89HTtBzh6Urixc5awyDSi/rshDJFzXSiQE28E2pM5gQblsc+1wU0Ufhl/+9rPojtmtkhPHN73OHXVimsWP38JAhiiUgVXhC6I+lfHsXzIGowC+zuxK7/MflAtKlQln5wLODvcGepw6XXgws9Fzuu+4xi/+ggxyXej0hnkKLISkd0v5Fb7YY2rS8W8TPjE1ImKGKKK+ID/2oV9gwodFGLaoaS8GJZRP6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UHMleX3m93FznwDBF2y4gCuE6x/7s2Xg1JpdqLhsNtY=;
 b=G3TskeAL0yeoyNzCk3HXvgql44dBeS9d6EKcuGyvKBvKDNvhwEtmXSRuAFQ+Dt85YUoHYGfALysXO9AdRUlDFbEuEy6JCYsR5voU5F19c2Upv7CJCUCMirL4sNNZ7vABBqb45c6kvc54/YIE+8u6i36sVCc7ud4B1Xk4zKU4nk6K++zkEOjSyrmwgtxWiZgRgCWdmwpLQW70cjQwotSUKUJrXox3VHw6TYsv/5DJYorgTZ5MDtKQCJS1ntNaW5iofPhTlkak+XqWithm4Au0+n9SCxIT2Ezr1n6YIbK7rKP8cwcM2BVD0m0tBam+e8rBkEyMxbqHixY98c1/N6OtAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UHMleX3m93FznwDBF2y4gCuE6x/7s2Xg1JpdqLhsNtY=;
 b=naST7rBPOuudt4ldSfoKx9yH36EQqP0FKhkd2JrOqxduIlDxJP7NC6NliiWmwqAw2h5fSw2W9cp/4jcR9epySXP9/iv4fic964V/E4VkmmLz/z85gKOPw1UtubuzIbmg/JvefXNI3LC3SN228kCDZCezcPmBsBIzgTz/S3F9ZCT8P1ReeWD1KGvxh5YEpRn0ZGqgdcHKRziS6je0mqZ6qWoyDOVd9rJmsBcKFr/WW2MYEqrkpQ9CeH/BNCP/sBxstRKV6JqFYlFmm8u8ExgqBOJXB/4Zed58OY1x7sWixxPgba3fR36sqSF7UDFsoNuRnCtUvpuiyHWwTQtHtZZpew==
Received: from MW4PR04CA0058.namprd04.prod.outlook.com (2603:10b6:303:6a::33)
 by PH7PR12MB6859.namprd12.prod.outlook.com (2603:10b6:510:1b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Thu, 18 May
 2023 11:34:50 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::c3) by MW4PR04CA0058.outlook.office365.com
 (2603:10b6:303:6a::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19 via Frontend
 Transport; Thu, 18 May 2023 11:34:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.19 via Frontend Transport; Thu, 18 May 2023 11:34:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 18 May 2023
 04:34:39 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Thu, 18 May 2023 04:34:34 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <razor@blackwall.org>, <roopa@nvidia.com>,
	<taras.chornyi@plvision.eu>, <saeedm@nvidia.com>, <leon@kernel.org>,
	<petrm@nvidia.com>, <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
	<alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
	<jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<taspelund@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/5] Add layer 2 miss indication and filtering
Date: Thu, 18 May 2023 14:33:23 +0300
Message-ID: <20230518113328.1952135-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT010:EE_|PH7PR12MB6859:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f4bac7d-5690-4e1d-0fc3-08db5793e43d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	t5R0h4q7wFfZaYvL5iaZb5E/2TbV89PFhxGFtcRNZgbpKeYwg1kTv9SArA9zvQAl8cLotaKQFRjX1A7b7lWlFpDUrEBwn20MbwADwGQfDgEIsr1TjnjGcL5ULKIhpiaiMtwLmtz3Lp+LE0URNF7Xld39wnxVDSQjKqE8xBsy1CnZNtEZrCGennXuGDnoRKUFMlsP4B3EUYJuUug9QNT0HJ7nsk4jY8aqFrFjpQ0Bwy5WrABHi9+RT4655+ZXxe1h+yl1phJ1L0sgnBFZwMUmU23TlTJKPXgAnQQHfKdxSfwYB1HMdfe2MmwVeYYysj6rvEwVEaNx9/2J2E1VPGt9enbb/cEebMl3vlmVOJQAIbPiSCskXG5/0GFmHA4GZdw//ctQmIFwYufySlYw4O7/bbYULEH2RtTXO7VDQqFsXjINeVvdSB94v2zVviDOD+iVFi/R8eIeQHipyn3Y8soRrgycEh9c6lQnTG+1iLeVAX3rpd7i6QehGmhXnZz7yfIqGIcBW4QmrpF84F1Z2juKluC2LWZdXb6n+keYlCqieT07OYGX9pzk5TPVSdF428NXp/qLmQLcMpp4Y/6u9jwwmVvvvAof1z88qFST5RVAohpBvQY5fcdPt/l8NDFIet0Xh1CUpi0242szzeAvJG6l+cukSjuLab8M0LQlQzaetQhnDTxEbHtNOEguGgCQmBuTczk5gOmtjVSKqtpt0q6JveqHT/nf7blklXB0klJrdSV/kOyC+AFxj0ELjIW3fBW1q3Mm6Ss9G400kaY5yYLDEMItMlz6dKnK/9Fmo1Q43zP1+p/peFVvmt9DX2P9E5Kx
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199021)(40470700004)(36840700001)(46966006)(5660300002)(8936002)(7416002)(426003)(336012)(107886003)(36860700001)(966005)(83380400001)(47076005)(82310400005)(26005)(1076003)(7636003)(356005)(2616005)(186003)(8676002)(40460700003)(70586007)(41300700001)(478600001)(110136005)(82740400003)(16526019)(6666004)(54906003)(86362001)(4326008)(316002)(40480700001)(70206006)(36756003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 11:34:50.2666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f4bac7d-5690-4e1d-0fc3-08db5793e43d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6859
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

tl;dr
=====

This patchset adds a single bit to the skb to indicate that a packet
encountered a layer 2 miss in the bridge and extends flower to match on
this metadata. This is required for non-DF (Designated Forwarder)
filtering in EVPN multi-homing which prevents decapsulated BUM packets
from being forwarded multiple times to the same multi-homed host.

Background
==========

In a typical EVPN multi-homing setup each host is multi-homed using a
set of links called ES (Ethernet Segment, i.e., LAG) to multiple leaf
switches in a rack. These switches act as VTEPs and are not directly
connected (as opposed to MLAG), but can communicate with each other (as
well as with VTEPs in remote racks) via spine switches over L3.

When a host sends a BUM packet over ES1 to VTEP1, the VTEP will flood it
to other VTEPs in the network, including those connected to the host
over ES1. The receiving VTEPs must drop the packet and not forward it
back to the host. This is called "split-horizon filtering" (SPH) [1].

FRR configures SPH filtering using two tc filters. The first, an ingress
filter that matches on packets received from VTEP1 and marks them using
a fwmark (firewall mark). The second, an egress filter configured on the
LAG interface connected to the host that matches on the fwmark and drops
the packets. Example:

 # tc filter add dev vxlan0 ingress pref 1 proto all flower enc_src_ip $VTEP1_IP action skbedit mark 101
 # tc filter add dev bond0 egress pref 1 handle 101 fw action drop

Motivation
==========

For each ES, only one VTEP is elected by the control plane as the DF.
The DF is responsible for forwarding decapsulated BUM traffic to the
host over the ES. The non-DF VTEPs must drop such traffic as otherwise
the host will receive multiple copies of BUM traffic. This is called
"non-DF filtering" [2].

Filtering of multicast and broadcast traffic can be achieved using the
following flower filter:

 # tc filter add dev bond0 egress pref 1 proto all flower indev vxlan0 dst_mac 01:00:00:00:00:00/01:00:00:00:00:00 action drop

Unlike broadcast and multicast traffic, it is not currently possible to
filter unknown unicast traffic. The classification into unknown unicast
is performed by the bridge driver, but is not visible to other layers.

Implementation
==============

The proposed solution is to add a single bit to the skb that is set by
the bridge for packets that encountered an FDB/MDB miss. The flower
classifier is extended to be able to match on this new metadata bit in a
similar fashion to existing metadata options such as 'indev'.

A bit that is set for every flooded packet would also work, but it does
not allow us to differentiate between registered and unregistered
multicast traffic which might be useful in the future.

A relatively generic name is chosen for this bit - 'l2_miss' - to allow
its use to be extended to other layer 2 devices such as VXLAN, should a
use case arise.

With the above, the control plane can implement a non-DF filter using
the following tc filters:

 # tc filter add dev bond0 egress pref 1 proto all flower indev vxlan0 dst_mac 01:00:00:00:00:00/01:00:00:00:00:00 action drop
 # tc filter add dev bond0 egress pref 2 proto all flower indev vxlan0 l2_miss true action drop

The first drops broadcast and multicast traffic and the second drops
unknown unicast traffic.

Testing
=======

A test exercising the different permutations of the 'l2_miss' bit is
added in patch #5.

Patchset overview
=================

Patch #1 adds the new bit to the skb and sets it in the bridge driver
for packets that encountered a miss. The new bit is added in an existing
hole in the skb in order not to inflate this data structure.

Patch #2 extends the flower classifier to be able to match on the new
layer 2 miss metadata.

Patch #3 rejects matching on the new metadata in drivers that already
support the 'FLOW_DISSECTOR_KEY_META' key.

Patch #4 extends mlxsw to be able to match on layer 2 miss.

Patch #5 adds a selftest.

iproute2 patches can be found here [3].

Changelog
=========

Since RFC [4]:

No changes.

[1] https://datatracker.ietf.org/doc/html/rfc7432#section-8.3
[2] https://datatracker.ietf.org/doc/html/rfc7432#section-8.5
[3] https://github.com/idosch/iproute2/tree/submit/non_df_filter_v1
[4] https://lore.kernel.org/netdev/20230509070446.246088-1-idosch@nvidia.com/

Ido Schimmel (5):
  skbuff: bridge: Add layer 2 miss indication
  net/sched: flower: Allow matching on layer 2 miss
  flow_offload: Reject matching on layer 2 miss
  mlxsw: spectrum_flower: Add ability to match on layer 2 miss
  selftests: forwarding: Add layer 2 miss test cases

 .../marvell/prestera/prestera_flower.c        |   6 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   6 +
 .../mellanox/mlxsw/core_acl_flex_keys.c       |   1 +
 .../mellanox/mlxsw/core_acl_flex_keys.h       |   3 +-
 .../mellanox/mlxsw/spectrum_acl_flex_keys.c   |   5 +
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  16 +
 drivers/net/ethernet/mscc/ocelot_flower.c     |  10 +
 include/linux/skbuff.h                        |   4 +
 include/net/flow_dissector.h                  |   2 +
 include/uapi/linux/pkt_cls.h                  |   2 +
 net/bridge/br_device.c                        |   1 +
 net/bridge/br_forward.c                       |   3 +
 net/bridge/br_input.c                         |   1 +
 net/core/flow_dissector.c                     |   3 +
 net/sched/cls_flower.c                        |  14 +-
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../net/forwarding/tc_flower_l2_miss.sh       | 343 ++++++++++++++++++
 17 files changed, 418 insertions(+), 3 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_l2_miss.sh

-- 
2.40.1


