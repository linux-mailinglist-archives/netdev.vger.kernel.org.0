Return-Path: <netdev+bounces-1046-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4470E6FC017
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:06:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D548628124E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5562B611C;
	Tue,  9 May 2023 07:06:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CC95672
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:06:18 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB2FD052
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 00:06:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfI5Ju9N+0cgNbsGSPo40zv1mZwkA4+YPBbbnUeD7yHFgTnS7YiHzpMaVB7UK0N6c8ymb8Ft/JL23Cv88/9vSnkBZ0XNgEp3CIn1uNV/Usy1A+1hjhB5LIdTGjOgrACQrbD9BkYf4AqjisfeCjiK+tkknB+t8E5aYGpkm/ggW/N/IDBfYFZbiYX2RRp1tjopqZ1fwuBtYTZu6tPGqZJKfl/0b/YQTzKq62pBPEuSHC5EH83j7O9dGMYnWcEnc9rPxlRNp27K53g3kIqCCctGDtC4EV+/3A2KtYdtdJp3k0a/uu/K5MxJp5Ykyn8JK/XYC0QXd/dTzwZutdn4iMcvbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X/1kGQBm5yXcyy2NUlXsvpQI4tCXCFKQDYvnTMrpduk=;
 b=HfQ+04+qUvuANhBZFsdLFGp4zMO/GiMpbpBsukyfIWPO1GJdVOETddc/wh2F9ZKJw7hv0RtHOSngkNt96GenNWOhe7DyfZW9PEssMlIQk9Z0yCIomIzqChwWck9iWylcOafQTJU38G9b54GwYxDKoSXzFMtbvMmfYQoXi1g3Cg0OIf9vfKvOQgdNvnPlVzSrwqdvwabXGwqUrqphLpUo/vaSistib0fE5KX3yDMX8E3gF09HXi82dolc6EbF2SxWAFYyz+JaP5dbNY8FIe04C3ubi7DHgzuuxSIdyjsYxfbLvk5nkzdwJAF7lZFmkgZZpu7EZnX7szdREItLalKe0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/1kGQBm5yXcyy2NUlXsvpQI4tCXCFKQDYvnTMrpduk=;
 b=oMxcjW/x7a3IicoCSw7yeHnErOxqw7pDU/q6ss3AeVmlv/q6eHpC1zjhaw46k91c2iO2HEreTbomdW/9UTxqiu9o3GI6TzDIB/WXWYFR78toTi3/d3wEjEo3cHDpmO5vrdfhGB6WC2XQaFj/+uIWlYXZ6Qng/1k/x6cNMQCN0g9FRzC9RWXZhIALqOPsUE6EUK3bYuRFGjhSB/Gl/Bj93qh1wfmUMWvZ6XRfbJ5Z//MbTjeW4XkcAQyd0bZWFvHdYBvBRwjJBWJzAPeb0UPPABlMy1GpUKUMFad7DEx/bV2WRbV8tA94rgzNioJ3hdD5fn2oUfYH8BMfVQQ5n0+w9Q==
Received: from DM5PR07CA0088.namprd07.prod.outlook.com (2603:10b6:4:ae::17) by
 MW3PR12MB4474.namprd12.prod.outlook.com (2603:10b6:303:2e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.33; Tue, 9 May 2023 07:06:06 +0000
Received: from DM6NAM11FT115.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::d1) by DM5PR07CA0088.outlook.office365.com
 (2603:10b6:4:ae::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33 via Frontend
 Transport; Tue, 9 May 2023 07:06:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT115.mail.protection.outlook.com (10.13.173.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.33 via Frontend Transport; Tue, 9 May 2023 07:06:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 00:05:45 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 9 May 2023 00:05:41 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <razor@blackwall.org>, <roopa@nvidia.com>,
	<jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<petrm@nvidia.com>, <taspelund@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 0/5] Add layer 2 miss indication and filtering
Date: Tue, 9 May 2023 10:04:41 +0300
Message-ID: <20230509070446.246088-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT115:EE_|MW3PR12MB4474:EE_
X-MS-Office365-Filtering-Correlation-Id: 169bea9e-bcf8-418f-26bd-08db505bdb88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9h7oD9izI2cRPb6XTHgB0B/Y6uOv1NBnEgx4Ieg57CPtqAiT8bqCXpC5m4vgDd974vt6r/aCBI9+76KUXNDHnndcGtKphWCbS1b79lS39Vcgeeh77G+++Y5qc0+GRoL3faVIrSgSe5ByLRjz0NeV0BdRQpwishQBR+MtYhfEQ4k8HhU7/5cAjDnirsfLpNqy+kdy3bhoDKNzfIDzCuaciH+c5EvM9A9KClIXQrZ46cnfvkkefGAddTNdx+dBQnIykV02UVUyL+08eWr7xtc2/QxUcyy3iHblJnimNp7qa72zG+XFCHVQ9tCZ/ujUcLcNUGGuVNKuVe/tgcnYoehu6AAnOthALjN6ojSUY8fLrBtqJZc9KAOd3SAORRLST11EU0CWFYcHhd0bqtQfnVLdGS8LEUyF5ougOkWFU6/g7d6i0rkyO7tf6QeZeFZMDimF6yFSKHittQ+aRguPRnMVk2EbRtfIa3BIPPLWPOUyEwQEGxPfIGExAxaaMEhO7iyqkpgDUN+y4wXgZHgluJVju3STy73ZLv3HJOfqu524MTJ+Eg/eaXudJsnL2EG16gdqX0FshdfLDNdXxdRZBNysH61p706yGHCCflXcWIya83CxLRXLFY6kg1bgJqPaeeOQdlwzckyGl4ekFQ3qJU/PK3pJG29xsVHrEzrzopflVFbpV9R17/FfiQnZRuZ3lM2Pg7mHWW3cu4pYNFE+3gnCjuEnVWV2yjQcSt6ZC8BQiWYNSwICUfpuz3ckGkXaqG15
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(5660300002)(4326008)(26005)(7416002)(316002)(41300700001)(82310400005)(7636003)(356005)(107886003)(82740400003)(86362001)(54906003)(110136005)(70206006)(70586007)(1076003)(2906002)(8936002)(8676002)(16526019)(186003)(36756003)(478600001)(36860700001)(966005)(47076005)(40460700003)(83380400001)(2616005)(336012)(426003)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 07:06:05.7030
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 169bea9e-bcf8-418f-26bd-08db505bdb88
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT115.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4474
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
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

[1] https://datatracker.ietf.org/doc/html/rfc7432#section-8.3
[2] https://datatracker.ietf.org/doc/html/rfc7432#section-8.5
[3] https://github.com/idosch/iproute2/tree/submit/non_df_filter_v1

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


