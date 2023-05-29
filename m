Return-Path: <netdev+bounces-6047-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 517F57148D0
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:49:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EA281C209E9
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 11:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0214C6AB6;
	Mon, 29 May 2023 11:49:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C163D9E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 11:49:43 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52539B
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 04:49:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XPNBfk3HrfhJLjX/SEWJebgn6iLxGKNx+45OPa3zhh1WoHMFYBJen+xJKWJ1eLN91cpQNEsTMGYfnoJ5/+CjMYMA3xdVPpsUNW60+FCCcWkR2wVHLa084uKLnCVxc1XKEiSfIEfWLc1ypfyvmuzRZkzI9R0Y6vaCatvjn0YFPL+qmVaiSNcVyhhTLfAnhr9xavPv7hfU0vm10k4iWkv0nmkwwBk9jb5VcYAYR2w7/JwZ+rfhcjgt+JuKK5BoR68zO9u7oMsfbDf5BWKTdsKGkI42/ZJeHxfBCbS9hNkhvJmrM5zXjfa/YRWsPmNkuTRwMc9UEiRqZ3lP+M1/2lOzNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VsH9Fql3+aFCOAK3ry7SSk9NvxGxNwdm36kEQWltJ1I=;
 b=OaW3pUp4j0t11T2YJvA3HUC6ZQaCdU5qTgZubW9ldI6AIdepR9o5cSavUMzGwOh9zPaDLgWvO0eroAj/YKT+qrfn1doaSbnB3L6yRQ0ww/CUhcicrdTuTndCcLUnq92AlSFG83Zkq2s68XSljdxltuo/CWQwZ49kA1DkrVKBLcakHAQF3b+p5hxU8fzkyrGtpt/qNXVVKK8D04O/f09gFQnv81Kt4iMcxQQ6FPGhBA0JNau3JjQVSU8lwAdkFXsh59OqXJd+VCdexZUguxpvAB99AL2Aa8xfzcVGhtLqf2A6bbMu8Bo614TjBCI03B4a7Vt9QP8BT2Bv7C8m2bpQHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VsH9Fql3+aFCOAK3ry7SSk9NvxGxNwdm36kEQWltJ1I=;
 b=M35m+4rQaLu4U6kvllmzG3OpacqyxU3ZfrVAqeq5JWRjP0Ad1NPr9Vgzd7Xf4q6ivXZKV4beTLF5bE7qF3olF1VNnwwVS5V9tbonndavXZV0H3UqZb3F5LxLMHGCPo2BlbkrLqS7LNujTSGpq+LzJVIUkIkuTJiROQGR3CaKoYaUSv4yXpZJuWGcrnwXX2Ep8aYqHrNJAS4zoMPxnWs2bQ8sYUUjq4YdID5k6TXxwv97qlTAlGeDtmF0blRsHPGO8NA20D0vDi9ZSLh3Oc49wwPsS7N+itkJZ2G1QNP54HWmNSLYrAwnIZw/V2SBWm/EZWPOpJ2BY0HsDpd4kXjnlw==
Received: from SJ0PR05CA0191.namprd05.prod.outlook.com (2603:10b6:a03:330::16)
 by SN7PR12MB6671.namprd12.prod.outlook.com (2603:10b6:806:26d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 11:49:39 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:330:cafe::c1) by SJ0PR05CA0191.outlook.office365.com
 (2603:10b6:a03:330::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.19 via Frontend
 Transport; Mon, 29 May 2023 11:49:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.18 via Frontend Transport; Mon, 29 May 2023 11:49:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 29 May 2023
 04:49:25 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 29 May 2023 04:49:19 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <taras.chornyi@plvision.eu>, <saeedm@nvidia.com>,
	<leon@kernel.org>, <petrm@nvidia.com>, <vladimir.oltean@nxp.com>,
	<claudiu.manoil@nxp.com>, <alexandre.belloni@bootlin.com>,
	<UNGLinuxDriver@microchip.com>, <jhs@mojatatu.com>,
	<xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <roopa@nvidia.com>,
	<razor@blackwall.org>, <simon.horman@corigine.com>, Ido Schimmel
	<idosch@nvidia.com>
Subject: [PATCH net-next v2 0/8] Add layer 2 miss indication and filtering
Date: Mon, 29 May 2023 14:48:27 +0300
Message-ID: <20230529114835.372140-1-idosch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT048:EE_|SN7PR12MB6671:EE_
X-MS-Office365-Filtering-Correlation-Id: c0626534-40e5-414d-869e-08db603ac84a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Kbb4vJCS8v6VXVxmN27+IBtE1Nqsi6r3Qeb3IbVkcRZTSZ2yR/29IGW2xX1g1d44ubrhJwjQvpfNiPMj7cGQO6u4nU7P/akZG3j2CvIoT5KY77S3DMIpm/FGcR4lql4deEGMZkO6Yqg8QYw3yowqbaWf1QVtMXv9xNm4PuUStQM2wTJhNxnCb0iIzZuQm9F/JjN3UkaqXAohU2gXnlxgUmlormkdMlQOFdZ0rwaaxm6yb2PTXm3Z3xHHyUPLYxYlfngp0BYNQPJMLi0mm8JGbmwNRYt6bPY/+1FkQruMWwmlkNV0W1JddeN4vsW0TXdBeIx1oDfd5y15nm9QivHGSZDwksL0dxvwa5WicwE18qU+PghG19mNeWu+qK9xTitnBj/wK/svIiiylfteBriD5iSrENw6eAA0F6rZn83iib1dLvOSx50N+0M8cLLUMeepyCBubVjTsK2T+bGiiSRk/CxYIe4ta42len/og7hHNOEIxvpUlxN+TMe91fM+e5lXRVBb3zeb0/hPxGUXRrUHjJ7SrxpGFZjvdqOjoYhkvU9rDBozDspIH5X8xbcQydFm2QVQwHhb4IDjgMZSUt6GMY014zuJ1VVtP2Ucmya9lnq0ydiP9oS4RRdtI6fkORqHnzWUVX5hSuLz6cFgLaXl3jGoq64xcdZeXDhypqn3ubKcyGTeo8Yi1Rppcf7dJxCPLw2IR7oBRRyGT0wnbbkHC4Csqj0XAT8PmDZxv1ZrdlXCW/7Hkfbn5/niE2LH6lYQW5eTcNIBD9biIQTk9geMuaZoSpdMbkx0dF9ECrxgY0YRwOIRxtITd0MfbPnMKhiE
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199021)(46966006)(40470700004)(36840700001)(36860700001)(40460700003)(83380400001)(47076005)(5660300002)(6666004)(316002)(70586007)(70206006)(107886003)(7416002)(4326008)(82310400005)(36756003)(966005)(82740400003)(7636003)(8676002)(8936002)(356005)(41300700001)(86362001)(40480700001)(110136005)(54906003)(2906002)(2616005)(186003)(16526019)(336012)(426003)(478600001)(1076003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 11:49:38.6191
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0626534-40e5-414d-869e-08db603ac84a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6671
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

tl;dr
=====

This patchset adds a single bit to the tc skb extension to indicate that
a packet encountered a layer 2 miss in the bridge and extends flower to
match on this metadata. This is required for non-DF (Designated
Forwarder) filtering in EVPN multi-homing which prevents decapsulated
BUM packets from being forwarded multiple times to the same multi-homed
host.

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

The proposed solution is to add a single bit to the tc skb extension
that is set by the bridge for packets that encountered an FDB or MDB
miss. The flower classifier is extended to be able to match on this new
metadata bit in a similar fashion to existing metadata options such as
'indev'.

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
added in patch #8.

Patchset overview
=================

Patch #1 adds the new bit to the tc skb extension and sets it in the
bridge driver for packets that encountered a miss. The marking of the
packets and the use of this extension is protected by the
'tc_skb_ext_tc' static key in order to keep performance impact to a
minimum when the feature is not in use.

Patch #2 extends the flow dissector to dissect this information from the
tc skb extension into the 'FLOW_DISSECTOR_KEY_META' key.

Patch #3 extends the flower classifier to be able to match on the new
layer 2 miss metadata. The classifier enables the 'tc_skb_ext_tc' static
key upon the installation of the first filter that matches on 'l2_miss'
and disables the key upon the removal of the last filter that matches on
it.

Patch #4 rejects matching on the new metadata in drivers that already
support the 'FLOW_DISSECTOR_KEY_META' key.

Patches #5-#6 are small preparations in mlxsw.

Patch #7 extends mlxsw to be able to match on layer 2 miss.

Patch #8 adds a selftest.

iproute2 patches can be found here [3].

Changelog
=========

Since v1 [4]:

* Patch #1: Use tc skb extension instead of adding a bit to the skb. Do
  not mark broadcast packets as they never perform a lookup
  and therefore never incur a miss.

* Patch #2: Split from flower patch. Use tc skb extension instead of
  'skb->l2_miss'.

* Patch #3: Split flow_dissector changes to a previous patch. Use tc skb
  extension instead of 'skb->l2_miss'.

* Patch #4: Expand commit message to explain why some users were not
  patched.

* Patch #5: New patch.

* Patch #6: New patch.

* Patch #7: Use 'fdb_miss' key element instead of 'dmac_type'.

* Patch #8: Test that broadcast does not hit miss filter.

Since RFC [5]:

No changes.

[1] https://datatracker.ietf.org/doc/html/rfc7432#section-8.3
[2] https://datatracker.ietf.org/doc/html/rfc7432#section-8.5
[3] https://github.com/idosch/iproute2/tree/submit/non_df_filter_v1
[4] https://lore.kernel.org/netdev/20230518113328.1952135-1-idosch@nvidia.com/
[5] https://lore.kernel.org/netdev/20230509070446.246088-1-idosch@nvidia.com/

Ido Schimmel (8):
  skbuff: bridge: Add layer 2 miss indication
  flow_dissector: Dissect layer 2 miss from tc skb extension
  net/sched: flower: Allow matching on layer 2 miss
  flow_offload: Reject matching on layer 2 miss
  mlxsw: spectrum_flower: Split iif parsing to a separate function
  mlxsw: spectrum_flower: Do not force matching on iif
  mlxsw: spectrum_flower: Add ability to match on layer 2 miss
  selftests: forwarding: Add layer 2 miss test cases

 .../marvell/prestera/prestera_flower.c        |   6 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   6 +
 .../mellanox/mlxsw/core_acl_flex_keys.c       |   1 +
 .../mellanox/mlxsw/core_acl_flex_keys.h       |   3 +-
 .../mellanox/mlxsw/spectrum_acl_flex_keys.c   |   2 +
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  45 ++-
 drivers/net/ethernet/mscc/ocelot_flower.c     |  10 +
 include/linux/skbuff.h                        |   1 +
 include/net/flow_dissector.h                  |   2 +
 include/uapi/linux/pkt_cls.h                  |   2 +
 net/bridge/br_device.c                        |   1 +
 net/bridge/br_forward.c                       |   3 +
 net/bridge/br_input.c                         |   1 +
 net/bridge/br_private.h                       |  27 ++
 net/core/flow_dissector.c                     |  10 +
 net/sched/cls_flower.c                        |  30 +-
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../net/forwarding/tc_flower_l2_miss.sh       | 350 ++++++++++++++++++
 18 files changed, 485 insertions(+), 16 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_l2_miss.sh

-- 
2.40.1


