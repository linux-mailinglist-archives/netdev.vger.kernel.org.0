Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F146B47C1E8
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 15:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238658AbhLUOvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 09:51:40 -0500
Received: from mail-bn8nam12on2082.outbound.protection.outlook.com ([40.107.237.82]:28384
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238664AbhLUOvi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 09:51:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTfr541cTzE0zwxxvgtFxECa1O6x/J8XMZmepDj5zWuEQB5A1gwkqYarUK80FDsH8ebCdrq49DozolYwSJG629kqP/bRu70cuA1690dg/Y5qobYMXHMW9T2Ye4dh/1uUN2txPJuD5Gphr3rejLc2l3JyGcG/6tDjOOHv6gt77wY9SDwgDWLKJ3OhA0Rx9M/nQTZ7dlHRK8D7TJQHpE6D9h/6720RGs0/EalqnQMAbhqAsb2s4jWV5E04YZD9UkvOlPJa7g0y3TW62K3XhVo5YXLfCwEC1daiCew4JdqMppl0+ehZC0CXVjb5MCG9kefIpRtGK7zKxLMNi/un5WrdDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6llKrhwnTubR5tHMxHEOyghh1YSiHUIN/1w9saRGKBg=;
 b=WMT0EC4k9UMiF4bwE1K05TZCyo4NC/IWpi0ZeB+3r/0u6T1TxkDc1DlJ6ikz4YuwUs3gye69abUsjpxPqKiH1GoD7wPJ1ET1sBdpD38YCS/B8dc9pzuey2p99iV3tvabRxX9Oiz/OuGdTfgV+Kdgab35qhAJ22wkh7PvpKNQrXJwJJ2L0YD7fyeH3xrLc8mzDr1KVBEocsHb55kZUs3K4LQtBZM1lwTglTmLJV+yHUwZnUbfLv5AYV80wMDpR0DBoDpggYcN4AyLssRBDYwQKf+gDmJYnbx98ckHqvtNwgCdERwWALFpXg0j0TiusAhlu9GKqHMk3I0HCMFSBbvm6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6llKrhwnTubR5tHMxHEOyghh1YSiHUIN/1w9saRGKBg=;
 b=ocErkq5WQ7iJJVGCWvfjGplVhopw+6uy10QofnsaOXYdX3+k7bCkFgQ/LcTzX5rpv6asvQ/TgwYU6dTGAfxESq7qxYEr6i0i5u1uqHlKnlVXGLan5kwoZYKDSNxUJAf7kTgtlVGZAxQEDsA8jRXHOuszdVpuo+oj1eVyV5HUw9W+rOjrMOvhmroL5r6JY5Zmvcm7geR2FIQrGrTGJQi63xeMTQxmFAPlhmSu1PKnF4s+LGnw49z3sWL4S8l4Jj99j/9Xr4gLVKLlU3zxsFu2nXA8rBS9EHYjGUnXSPjLfGQlJULYjVBq947QVjzg3z+zihQSo4ZdOeioGbzasEw/Cg==
Received: from MW4PR03CA0224.namprd03.prod.outlook.com (2603:10b6:303:b9::19)
 by BYAPR12MB4776.namprd12.prod.outlook.com (2603:10b6:a03:10d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Tue, 21 Dec
 2021 14:51:35 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::19) by MW4PR03CA0224.outlook.office365.com
 (2603:10b6:303:b9::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17 via Frontend
 Transport; Tue, 21 Dec 2021 14:51:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Tue, 21 Dec 2021 14:51:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Dec
 2021 14:51:34 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 21 Dec 2021 06:51:32 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 6/8] selftests: forwarding: Add a test for VxLAN asymmetric routing with IPv6
Date:   Tue, 21 Dec 2021 16:49:47 +0200
Message-ID: <20211221144949.2527545-7-amcohen@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221144949.2527545-1-amcohen@nvidia.com>
References: <20211221144949.2527545-1-amcohen@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 773fa818-7299-4543-f9b5-08d9c49162b5
X-MS-TrafficTypeDiagnostic: BYAPR12MB4776:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB47763D859CF2223E33824C99CB7C9@BYAPR12MB4776.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9mHEIjXqWoXxBTgnbd2X+L7gcz+qpIalvStBsfrg7scbiDkNflEBYUyBl9goGuC3/0GIrlcZs06eKEksLr9jFlYZkn38xJ48ZJ/qYaOVgp8XBEBnIXhNKIAwWEPI7JcZ6umvwAiIVDgo+9I6oD3dhRKyIoJmWjNkV9w3u2G4vT/b5Nc/qa0NlFWC3OL7b5mQRTuLdLaCBcxqkTjsYOT81Fhwe0z8OfomsLxhu4e+GTiyCmprhr71YQV1HHwSFeAclrBGS9whOhDgYi7OuvueQX/NvbSyktrUg4yGY2qssbrjVylDy0eeDA5wNU9Pa7YfhUyN50iBEUt7jV/z4me/O8bsSSmA5KZpNmxUaANFQU1EfYhEFyOcgCL0dtoWfdOY623yX1DFBsb4veQbzqtlMqrxitboe9txoP6h3P7YLvYk1Be4XiIZxtj97/dPzXFUEMi6VTQ9B7ruX+LhfAeKI5PvxbWsVBR+k0p1fiONLJ5FYirk9vvv8v5KHvuX6ikswNrw/p+iPa24bD975VHuslHjal40+FGNFOkh8i8hayzUKA5cwYYMHOyLOXbgFLcIO7kmaQjZlamk03Bo+ewTpTuQMjZbskOauKygG6nOdq+SpggxlDl4c1Kjn3lFpV/kwUAKfQVbmMbTzQiu7nPYPTk2TfKZlNX5Y+35qR9eRvTaITWqEFSPuMgVMVsizmrQW+Cfxto68DzAlEG2fXC3nY927K61Tic8MmCTWo1n4IWjpFXUI5Ib5I2Ulp4FV6OkqXNUGhNPyNNoRjxeGUairje+DD8Nfscxx2fdHGGNkie9DvRIo2xrEeU7tjPenieS+SrLl1mHbk/WbvYkuOgCTw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(34020700004)(26005)(83380400001)(40460700001)(81166007)(70586007)(70206006)(356005)(6916009)(8676002)(5660300002)(1076003)(36756003)(8936002)(508600001)(86362001)(82310400004)(2906002)(16526019)(426003)(6666004)(47076005)(107886003)(316002)(2616005)(54906003)(4326008)(36860700001)(186003)(30864003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 14:51:35.3468
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 773fa818-7299-4543-f9b5-08d9c49162b5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4776
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In asymmetric routing the ingress VTEP routes the packet into the
correct VxLAN tunnel, whereas the egress VTEP only bridges the packet to
the correct host. Therefore, packets in different directions use
different VNIs - the target VNI.

Add a test which is similar to the existing IPv4 test to check IPv6.

The test uses a simple topology with two VTEPs and two VNIs and verifies
that ping passes between hosts (local / remote) in the same VLAN (VNI)
and in different VLANs belonging to the same tenant (VRF).

While the test does not check VM mobility, it does configure an anycast
gateway using a macvlan device on both VTEPs.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../net/forwarding/vxlan_asymmetric_ipv6.sh   | 504 ++++++++++++++++++
 1 file changed, 504 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_asymmetric_ipv6.sh

diff --git a/tools/testing/selftests/net/forwarding/vxlan_asymmetric_ipv6.sh b/tools/testing/selftests/net/forwarding/vxlan_asymmetric_ipv6.sh
new file mode 100755
index 000000000000..f4930098974f
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/vxlan_asymmetric_ipv6.sh
@@ -0,0 +1,504 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# +--------------------------------+            +-----------------------------+
+# |                         vrf-h1 |            |                      vrf-h2 |
+# |    + $h1                       |            | + $h2                       |
+# |    | 2001:db8:1::1/64          |            | | 2001:db8:2::1/64          |
+# |    | default via 2001:db8:1::3 |            | | default via 2001:db8:2::3 |
+# +----|---------------------------+            +-|---------------------------+
+#      |                                          |
+# +----|------------------------------------------|---------------------------+
+# | SW |                                          |                           |
+# | +--|------------------------------------------|-------------------------+ |
+# | |  + $swp1                         br1        + $swp2                   | |
+# | |     vid 10 pvid untagged                       vid 20 pvid untagged   | |
+# | |                                                                       | |
+# | |  + vx10                                     + vx20                    | |
+# | |    local 2001:db8:3::1                        local 2001:db8:3::1     | |
+# | |    remote 2001:db8:3::2                       remote 2001:db8:3::2    | |
+# | |    id 1000                                    id 2000                 | |
+# | |    dstport 4789                               dstport 4789            | |
+# | |    vid 10 pvid untagged                       vid 20 pvid untagged    | |
+# | |                                                                       | |
+# | +-----------------------------------+-----------------------------------+ |
+# |                                     |                                     |
+# | +-----------------------------------|-----------------------------------+ |
+# | |                                   |                                   | |
+# | |  +--------------------------------+--------------------------------+  | |
+# | |  |                                                                 |  | |
+# | |  + vlan10                                                   vlan20 +  | |
+# | |  | 2001:db8:1::2/64                               2001:db8:2::2/64 |  | |
+# | |  |                                                                 |  | |
+# | |  + vlan10-v (macvlan)                           vlan20-v (macvlan) +  | |
+# | |    2001:db8:1::3/64                               2001:db8:2::3/64    | |
+# | |    00:00:5e:00:01:01                             00:00:5e:00:01:01    | |
+# | |                               vrf-green                               | |
+# | +-----------------------------------------------------------------------+ |
+# |                                                                           |
+# |    + $rp1                                       +lo                       |
+# |    | 2001:db8:4::1/64                            2001:db8:3::1/128        |
+# +----|----------------------------------------------------------------------+
+#      |
+# +----|--------------------------------------------------------+
+# |    |                            vrf-spine                   |
+# |    + $rp2                                                   |
+# |      2001:db8:4::2/64                                       |
+# |                                                             |   (maybe) HW
+# =============================================================================
+# |                                                             |  (likely) SW
+# |                                                             |
+# |    + v1 (veth)                                              |
+# |    | 2001:db8:5::2/64                                       |
+# +----|--------------------------------------------------------+
+#      |
+# +----|----------------------------------------------------------------------+
+# |    + v2 (veth)                                  +lo           NS1 (netns) |
+# |      2001:db8:5::1/64                            2001:db8:3::2/128        |
+# |                                                                           |
+# | +-----------------------------------------------------------------------+ |
+# | |                               vrf-green                               | |
+# | |  + vlan10-v (macvlan)                           vlan20-v (macvlan) +  | |
+# | |  | 2001:db8:1::3/64                               2001:db8:2::3/64 |  | |
+# | |  | 00:00:5e:00:01:01                             00:00:5e:00:01:01 |  | |
+# | |  |                                                                 |  | |
+# | |  + vlan10                                                   vlan20 +  | |
+# | |  | 2001:db8:1::3/64                               2001:db8:2::3/64 |  | |
+# | |  |                                                                 |  | |
+# | |  +--------------------------------+--------------------------------+  | |
+# | |                                   |                                   | |
+# | +-----------------------------------|-----------------------------------+ |
+# |                                     |                                     |
+# | +-----------------------------------+-----------------------------------+ |
+# | |                                                                       | |
+# | |  + vx10                                     + vx20                    | |
+# | |    local 2001:db8:3::2                        local 2001:db8:3::2     | |
+# | |    remote 2001:db8:3::1                       remote 2001:db8:3::1    | |
+# | |    id 1000                                    id 2000                 | |
+# | |    dstport 4789                               dstport 4789            | |
+# | |    vid 10 pvid untagged                       vid 20 pvid untagged    | |
+# | |                                                                       | |
+# | |  + w1 (veth)                                + w3 (veth)               | |
+# | |  | vid 10 pvid untagged          br1        | vid 20 pvid untagged    | |
+# | +--|------------------------------------------|-------------------------+ |
+# |    |                                          |                           |
+# |    |                                          |                           |
+# | +--|----------------------+                +--|-------------------------+ |
+# | |  |               vrf-h1 |                |  |                  vrf-h2 | |
+# | |  + w2 (veth)            |                |  + w4 (veth)               | |
+# | |    2001:db8:1::4/64     |                |    2001:db8:2::4/64        | |
+# | |    default via          |                |    default via             | |
+# | |    2001:db8:1::3/64     |                |    2001:db8:2::3/64        | |
+# | +-------------------------+                +----------------------------+ |
+# +---------------------------------------------------------------------------+
+
+ALL_TESTS="
+	ping_ipv6
+	arp_decap
+"
+NUM_NETIFS=6
+source lib.sh
+
+require_command $ARPING
+
+hx_create()
+{
+	local vrf_name=$1; shift
+	local if_name=$1; shift
+	local ip_addr=$1; shift
+	local gw_ip=$1; shift
+
+	vrf_create $vrf_name
+	ip link set dev $if_name master $vrf_name
+	ip link set dev $vrf_name up
+	ip link set dev $if_name up
+
+	ip address add $ip_addr/64 dev $if_name
+	ip neigh replace $gw_ip lladdr 00:00:5e:00:01:01 nud permanent \
+		dev $if_name
+	ip route add default vrf $vrf_name nexthop via $gw_ip
+}
+export -f hx_create
+
+hx_destroy()
+{
+	local vrf_name=$1; shift
+	local if_name=$1; shift
+	local ip_addr=$1; shift
+	local gw_ip=$1; shift
+
+	ip route del default vrf $vrf_name nexthop via $gw_ip
+	ip neigh del $gw_ip dev $if_name
+	ip address del $ip_addr/64 dev $if_name
+
+	ip link set dev $if_name down
+	vrf_destroy $vrf_name
+}
+
+h1_create()
+{
+	hx_create "vrf-h1" $h1 2001:db8:1::1 2001:db8:1::3
+}
+
+h1_destroy()
+{
+	hx_destroy "vrf-h1" $h1 2001:db8:1::1 2001:db8:1::3
+}
+
+h2_create()
+{
+	hx_create "vrf-h2" $h2 2001:db8:2::1 2001:db8:2::3
+}
+
+h2_destroy()
+{
+	hx_destroy "vrf-h2" $h2 2001:db8:2::1 2001:db8:2::3
+}
+
+switch_create()
+{
+	ip link add name br1 type bridge vlan_filtering 1 vlan_default_pvid 0 \
+		mcast_snooping 0
+	# Make sure the bridge uses the MAC address of the local port and not
+	# that of the VxLAN's device.
+	ip link set dev br1 address $(mac_get $swp1)
+	ip link set dev br1 up
+
+	ip link set dev $rp1 up
+	ip address add dev $rp1 2001:db8:4::1/64
+	ip route add 2001:db8:3::2/128 nexthop via 2001:db8:4::2
+
+	ip link add name vx10 type vxlan id 1000		\
+		local 2001:db8:3::1 remote 2001:db8:3::2 dstport 4789	\
+		nolearning udp6zerocsumrx udp6zerocsumtx tos inherit ttl 100
+	ip link set dev vx10 up
+
+	ip link set dev vx10 master br1
+	bridge vlan add vid 10 dev vx10 pvid untagged
+
+	ip link add name vx20 type vxlan id 2000		\
+		local 2001:db8:3::1 remote 2001:db8:3::2 dstport 4789	\
+		nolearning udp6zerocsumrx udp6zerocsumtx tos inherit ttl 100
+	ip link set dev vx20 up
+
+	ip link set dev vx20 master br1
+	bridge vlan add vid 20 dev vx20 pvid untagged
+
+	ip link set dev $swp1 master br1
+	ip link set dev $swp1 up
+	bridge vlan add vid 10 dev $swp1 pvid untagged
+
+	ip link set dev $swp2 master br1
+	ip link set dev $swp2 up
+	bridge vlan add vid 20 dev $swp2 pvid untagged
+
+	ip address add 2001:db8:3::1/128 dev lo
+
+	# Create SVIs
+	vrf_create "vrf-green"
+	ip link set dev vrf-green up
+
+	ip link add link br1 name vlan10 up master vrf-green type vlan id 10
+	ip address add 2001:db8:1::2/64 dev vlan10
+	ip link add link vlan10 name vlan10-v up master vrf-green \
+		address 00:00:5e:00:01:01 type macvlan mode private
+	ip address add 2001:db8:1::3/64 dev vlan10-v
+
+	ip link add link br1 name vlan20 up master vrf-green type vlan id 20
+	ip address add 2001:db8:2::2/64 dev vlan20
+	ip link add link vlan20 name vlan20-v up master vrf-green \
+		address 00:00:5e:00:01:01 type macvlan mode private
+	ip address add 2001:db8:2::3/64 dev vlan20-v
+
+	bridge vlan add vid 10 dev br1 self
+	bridge vlan add vid 20 dev br1 self
+
+	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 10
+	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 20
+
+}
+
+switch_destroy()
+{
+	bridge fdb del 00:00:5e:00:01:01 dev br1 self local vlan 20
+	bridge fdb del 00:00:5e:00:01:01 dev br1 self local vlan 10
+
+	bridge vlan del vid 20 dev br1 self
+	bridge vlan del vid 10 dev br1 self
+
+	ip link del dev vlan20
+
+	ip link del dev vlan10
+
+	vrf_destroy "vrf-green"
+
+	ip address del 2001:db8:3::1/128 dev lo
+
+	bridge vlan del vid 20 dev $swp2
+	ip link set dev $swp2 down
+	ip link set dev $swp2 nomaster
+
+	bridge vlan del vid 10 dev $swp1
+	ip link set dev $swp1 down
+	ip link set dev $swp1 nomaster
+
+	bridge vlan del vid 20 dev vx20
+	ip link set dev vx20 nomaster
+
+	ip link set dev vx20 down
+	ip link del dev vx20
+
+	bridge vlan del vid 10 dev vx10
+	ip link set dev vx10 nomaster
+
+	ip link set dev vx10 down
+	ip link del dev vx10
+
+	ip route del 2001:db8:3::2 nexthop via 2001:db8:4::2
+	ip address del dev $rp1 2001:db8:4::1/64
+	ip link set dev $rp1 down
+
+	ip link set dev br1 down
+	ip link del dev br1
+}
+
+spine_create()
+{
+	vrf_create "vrf-spine"
+	ip link set dev $rp2 master vrf-spine
+	ip link set dev v1 master vrf-spine
+	ip link set dev vrf-spine up
+	ip link set dev $rp2 up
+	ip link set dev v1 up
+
+	ip address add 2001:db8:4::2/64 dev $rp2
+	ip address add 2001:db8:5::2/64 dev v1
+
+	ip route add 2001:db8:3::1/128 vrf vrf-spine nexthop via \
+		2001:db8:4::1
+	ip route add 2001:db8:3::2/128 vrf vrf-spine nexthop via \
+		2001:db8:5::1
+}
+
+spine_destroy()
+{
+	ip route del 2001:db8:3::2/128 vrf vrf-spine nexthop via \
+		2001:db8:5::1
+	ip route del 2001:db8:3::1/128 vrf vrf-spine nexthop via \
+		2001:db8:4::1
+
+	ip address del 2001:db8:5::2/64 dev v1
+	ip address del 2001:db8:4::2/64 dev $rp2
+
+	ip link set dev v1 down
+	ip link set dev $rp2 down
+	vrf_destroy "vrf-spine"
+}
+
+ns_h1_create()
+{
+	hx_create "vrf-h1" w2 2001:db8:1::4 2001:db8:1::3
+}
+export -f ns_h1_create
+
+ns_h2_create()
+{
+	hx_create "vrf-h2" w4 2001:db8:2::4 2001:db8:2::3
+}
+export -f ns_h2_create
+
+ns_switch_create()
+{
+	ip link add name br1 type bridge vlan_filtering 1 vlan_default_pvid 0 \
+		mcast_snooping 0
+	ip link set dev br1 up
+
+	ip link set dev v2 up
+	ip address add dev v2 2001:db8:5::1/64
+	ip route add 2001:db8:3::1 nexthop via 2001:db8:5::2
+
+	ip link add name vx10 type vxlan id 1000		\
+		local 2001:db8:3::2 remote 2001:db8:3::1 dstport 4789	\
+		nolearning udp6zerocsumrx udp6zerocsumtx tos inherit ttl 100
+	ip link set dev vx10 up
+
+	ip link set dev vx10 master br1
+	bridge vlan add vid 10 dev vx10 pvid untagged
+
+	ip link add name vx20 type vxlan id 2000		\
+		local 2001:db8:3::2 remote 2001:db8:3::1 dstport 4789	\
+		nolearning udp6zerocsumrx udp6zerocsumtx tos inherit ttl 100
+	ip link set dev vx20 up
+
+	ip link set dev vx20 master br1
+	bridge vlan add vid 20 dev vx20 pvid untagged
+
+	ip link set dev w1 master br1
+	ip link set dev w1 up
+	bridge vlan add vid 10 dev w1 pvid untagged
+
+	ip link set dev w3 master br1
+	ip link set dev w3 up
+	bridge vlan add vid 20 dev w3 pvid untagged
+
+	ip address add 2001:db8:3::2/128 dev lo
+
+	# Create SVIs
+	vrf_create "vrf-green"
+	ip link set dev vrf-green up
+
+	ip link add link br1 name vlan10 up master vrf-green type vlan id 10
+	ip address add 2001:db8:1::3/64 dev vlan10
+	ip link add link vlan10 name vlan10-v up master vrf-green \
+		address 00:00:5e:00:01:01 type macvlan mode private
+	ip address add 2001:db8:1::3/64 dev vlan10-v
+
+	ip link add link br1 name vlan20 up master vrf-green type vlan id 20
+	ip address add 2001:db8:2::3/64 dev vlan20
+	ip link add link vlan20 name vlan20-v up master vrf-green \
+		address 00:00:5e:00:01:01 type macvlan mode private
+	ip address add 2001:db8:2::3/64 dev vlan20-v
+
+	bridge vlan add vid 10 dev br1 self
+	bridge vlan add vid 20 dev br1 self
+
+	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 10
+	bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 20
+}
+export -f ns_switch_create
+
+ns_init()
+{
+	ip link add name w1 type veth peer name w2
+	ip link add name w3 type veth peer name w4
+
+	ip link set dev lo up
+
+	ns_h1_create
+	ns_h2_create
+	ns_switch_create
+}
+export -f ns_init
+
+ns1_create()
+{
+	ip netns add ns1
+	ip link set dev v2 netns ns1
+	in_ns ns1 ns_init
+}
+
+ns1_destroy()
+{
+	ip netns exec ns1 ip link set dev v2 netns 1
+	ip netns del ns1
+}
+
+macs_populate()
+{
+	local mac1=$1; shift
+	local mac2=$1; shift
+	local ip1=$1; shift
+	local ip2=$1; shift
+	local dst=$1; shift
+
+	bridge fdb add $mac1 dev vx10 self master extern_learn static \
+		dst $dst vlan 10
+	bridge fdb add $mac2 dev vx20 self master extern_learn static \
+		dst $dst vlan 20
+
+	ip neigh add $ip1 lladdr $mac1 nud noarp dev vlan10 \
+		extern_learn
+	ip neigh add $ip2 lladdr $mac2 nud noarp dev vlan20 \
+		extern_learn
+}
+export -f macs_populate
+
+macs_initialize()
+{
+	local h1_ns_mac=$(in_ns ns1 mac_get w2)
+	local h2_ns_mac=$(in_ns ns1 mac_get w4)
+	local h1_mac=$(mac_get $h1)
+	local h2_mac=$(mac_get $h2)
+
+	macs_populate $h1_ns_mac $h2_ns_mac 2001:db8:1::4 2001:db8:2::4 \
+		2001:db8:3::2
+	in_ns ns1 macs_populate $h1_mac $h2_mac 2001:db8:1::1 2001:db8:2::1 \
+		2001:db8:3::1
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	swp2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	rp1=${NETIFS[p5]}
+	rp2=${NETIFS[p6]}
+
+	vrf_prepare
+	forwarding_enable
+
+	h1_create
+	h2_create
+	switch_create
+
+	ip link add name v1 type veth peer name v2
+	spine_create
+	ns1_create
+	in_ns ns1 forwarding_enable
+
+	macs_initialize
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	ns1_destroy
+	spine_destroy
+	ip link del dev v1
+
+	switch_destroy
+	h2_destroy
+	h1_destroy
+
+	forwarding_restore
+	vrf_cleanup
+}
+
+ping_ipv6()
+{
+	ping6_test $h1 2001:db8:2::1 ": local->local vid 10->vid 20"
+	ping6_test $h1 2001:db8:1::4 ": local->remote vid 10->vid 10"
+	ping6_test $h2 2001:db8:2::4 ": local->remote vid 20->vid 20"
+	ping6_test $h1 2001:db8:2::4 ": local->remote vid 10->vid 20"
+	ping6_test $h2 2001:db8:1::4 ": local->remote vid 20->vid 10"
+}
+
+arp_decap()
+{
+	# Repeat the ping tests, but without populating the neighbours. This
+	# makes sure we correctly decapsulate ARP packets
+	log_info "deleting neighbours from vlan interfaces"
+
+	ip neigh del 2001:db8:1::4 dev vlan10
+	ip neigh del 2001:db8:2::4 dev vlan20
+
+	ping_ipv6
+
+	ip neigh replace 2001:db8:1::4 lladdr $(in_ns ns1 mac_get w2) \
+		nud noarp dev vlan10 extern_learn
+	ip neigh replace 2001:db8:2::4 lladdr $(in_ns ns1 mac_get w4) \
+		nud noarp dev vlan20 extern_learn
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.31.1

