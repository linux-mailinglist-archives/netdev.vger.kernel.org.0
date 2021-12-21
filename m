Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A3A47C1E3
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 15:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238645AbhLUOuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 09:50:19 -0500
Received: from mail-mw2nam12on2050.outbound.protection.outlook.com ([40.107.244.50]:31968
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238648AbhLUOuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 09:50:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yzz1DRcAoh4v08TMUPRggb8i39YYi7t0hdLpNfLJidclxEX+G/2E1IPmBLPYlaq+Az7uCOmDbQRJEQ0eCgKKmIjdsEO5jXRwxsp1vdLvFOjgsbnOXjS67EL7rqfL1ILXt9JO4TNm0ho5RMa2snyWRxPc20dpPIcKWLlfH5/zJF7ztZn5v0QuB8FWz6bCuLkEwQpuLb3x+zy0QFHatWID2i4Ois9CAFO+DsfawmW+NZJrbkfvLZHwXy0uWsW+2X/wBDYMz6cg1faJlE7IKAmhG4Xkqo3iUl0hbUbc5h0ro2kUhXLRt5Q2HV4RGiulydCbIuK+/N8NanBNQH+F567WKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sjz+cwrDK3wiLERIk6/OVQXFmv6shW4WRD3sx9tduQk=;
 b=K8VzVKj3lFp59I9eL8+M7cMlIiFY59jPeu94t/bNpMLwTsL8zfvZOvpX259OJ0uUHxlooBuvscMImqc12jUM/WEpnUfFVX1/wykTh2baHE44LCdDCHVLEMDHzxrcRmopDdvDZlJBOzTvKz1Ii67pWhmYf0J9fBg/bmNyGyTbYT0/J8ZXeSOx6HwUK46JusCw1GDuJmpTEKMrsH8woJdYkPV0WVg/iHVJXREFvFNKj6N3ol79YqgSGkEUFjGA9elE85sKwzXuVDv5pYGZFhF/Gqjsmazxp820hrBxVvansrdK0kZpwqCPE0TOkBSfjGyRBjW0eVKiWHFDtG7CiEBDBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sjz+cwrDK3wiLERIk6/OVQXFmv6shW4WRD3sx9tduQk=;
 b=Bl5q4zdBnEJL+r3AMDAjDXk+tGFJdkjFd462QV1gM2KFFBHwlph/QWUpyqjO+S+wv/SFj0ALY79Kdxy9wkvqlYs/LhmOOer/ye2g3Y/Gg5tEfXcl+XEPe4vl0ye9yulxknWishbERnVYoj+fb3cqWopKTV3l1vFdakLE5+T6IXdDxQUX5UMXxtDxwE37GgUbfXylJzuNIA0vWY3qu8WNE6hhPVHMYee6DoD8/bfk7AcoQqNskjge5MosrMnp8mr8+fsQ4KZPWdZUXPpzF0JK25r5ZTDXJoA/64Dmr7TzPo76VoCogR4cpuNYhY1dPCJLlGIWpXpIQ/HdHBMOakKNMA==
Received: from BN9PR03CA0543.namprd03.prod.outlook.com (2603:10b6:408:138::8)
 by DM6PR12MB3386.namprd12.prod.outlook.com (2603:10b6:5:115::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 14:50:15 +0000
Received: from BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::d5) by BN9PR03CA0543.outlook.office365.com
 (2603:10b6:408:138::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15 via Frontend
 Transport; Tue, 21 Dec 2021 14:50:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT008.mail.protection.outlook.com (10.13.177.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Tue, 21 Dec 2021 14:50:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Dec
 2021 14:50:14 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.6) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 21 Dec 2021 06:50:12 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 3/8] selftests: forwarding: Add VxLAN tests with a VLAN-unaware bridge for IPv6
Date:   Tue, 21 Dec 2021 16:49:44 +0200
Message-ID: <20211221144949.2527545-4-amcohen@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221144949.2527545-1-amcohen@nvidia.com>
References: <20211221144949.2527545-1-amcohen@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4edf9db-25e1-4424-d108-08d9c491332c
X-MS-TrafficTypeDiagnostic: DM6PR12MB3386:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB338675AF96CD558D8A8862BBCB7C9@DM6PR12MB3386.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jm9pVrbG/L7iaVWr2pUzZimEMS0Q6GshT4OInH9tOzC0BN5KgksQIO3ajqgdxwgJ4wCF4cme2jcL3EqpXF9Ja4XoCtvy4vpjoU1SN7kOWPGQ6D0QGYJYBmow9Yyr3uR1LuFQl4guDVpAylARrZINPNCKJn9MTjGzzFJXMyIAv3Jz38BdXdw52sFeFIasrmceXeaiEQzrITtZEfxQbJwYJ3NsMPFilw8COSXJCrgGn979UOVnjZ7HnBLSa7DkcteM1SCYGn4jRhK10ecRmthX6oP88Wao7r+OPl5bJPcywi8vgDzwNNGZCxcAtiM0/yHd812b8c1OHIgxmWRSuoXazy/5p0hlNx68lnTT/PbUgWEjB4xPpGVtVV43S4MYL4qmBCcnCjyVrvhNB86xIdtfS5+dczP82YeNyz1FzUifGIOQSqByj//u6Vye7NIS3vu2jmcEitZzBHlbfcq3u3Yj0Atomyjcfwjd9QIrb8ZVwySseLLR/QVhaGeoLcJz/SNAg+fuZPfX2tGiVf3p52RdnBK7KxvgCGwhEDczrfrZ6KnNiGG8s7hjVlzta+1YXG8kDZRJf+r4Lh667vO7nn2iwzEKza37/2meiIUC+W7jwhJqQ2kJbsUSpApEke77JcHysIR9JsodD3n+2Wwa5RZkMoZZRN2t5jMxrTtL/imd5+ldizCHGktIVNroqVXFlS71c6pNCah1X+NiYr8cl5SIFXWACjbPIVb27ezvSiS7/6Bk+iG7MuKIJaKKmP9La0b18mT417sKVBnhewiYKTokPUU0Gz0uafjHAg+fvEgIn77phg38xw2gSvvnytOoxsPO0nSFU5aVFXqGmRlQqgOQrw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(30864003)(86362001)(82310400004)(36860700001)(47076005)(8676002)(36756003)(2616005)(16526019)(1076003)(2906002)(186003)(26005)(70586007)(66574015)(70206006)(5660300002)(6666004)(107886003)(83380400001)(508600001)(316002)(4326008)(34020700004)(356005)(6916009)(8936002)(81166007)(336012)(426003)(40460700001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 14:50:15.5227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4edf9db-25e1-4424-d108-08d9c491332c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3386
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests similar to vxlan_bridge_1d.sh and vxlan_bridge_1d_port_8472.sh.

The tests set up a topology with three VxLAN endpoints: one
"local", possibly offloaded, and two "remote", formed using veth pairs
and likely purely software bridges. The "local" endpoint is connected to
host systems by a VLAN-unaware bridge.

Since VxLAN tunnels must be unique per namespace, each of the "remote"
endpoints is in its own namespace. H3 forms the bridge between the three
domains.

Send IPv4 packets and IPv6 packets with IPv6 underlay.
Use `TC_FLAG`, which is defined in `forwarding.config` file, for TC
checks. `TC_FLAG` allows testing that on HW datapath, the traffic
actually goes through HW.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../net/forwarding/vxlan_bridge_1d_ipv6.sh    | 804 ++++++++++++++++++
 .../vxlan_bridge_1d_port_8472_ipv6.sh         |  11 +
 2 files changed, 815 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_bridge_1d_ipv6.sh
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_bridge_1d_port_8472_ipv6.sh

diff --git a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d_ipv6.sh b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d_ipv6.sh
new file mode 100755
index 000000000000..ac97f07e5ce8
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d_ipv6.sh
@@ -0,0 +1,804 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# +-----------------------+                          +------------------------+
+# | H1 (vrf)              |                          | H2 (vrf)               |
+# |    + $h1              |                          |    + $h2               |
+# |    | 192.0.2.1/28     |                          |    | 192.0.2.2/28      |
+# |    | 2001:db8:1::1/64 |                          |    | 2001:db8:1::2/64  |
+# +----|------------------+                          +----|-------------------+
+#      |                                                  |
+# +----|--------------------------------------------------|-------------------+
+# | SW |                                                  |                   |
+# | +--|--------------------------------------------------|-----------------+ |
+# | |  + $swp1                   BR1 (802.1d)             + $swp2           | |
+# | |                                                                       | |
+# | |  + vx1 (vxlan)                                                        | |
+# | |    local 2001:db8:3::1                                                | |
+# | |    remote 2001:db8:4::1 2001:db8:5::1                                 | |
+# | |    id 1000 dstport $VXPORT                                            | |
+# | +-----------------------------------------------------------------------+ |
+# |                                                                           |
+# |  2001:db8:4::0/64 via 2001:db8:3::2                                       |
+# |  2001:db8:5::0/64 via 2001:db8:3::2                                       |
+# |                                                                           |
+# |    + $rp1                                                                 |
+# |    | 2001:db8:3::1/64                                                     |
+# +----|----------------------------------------------------------------------+
+#      |
+# +----|----------------------------------------------------------+
+# |    |                                             VRP2 (vrf)   |
+# |    + $rp2                                                     |
+# |      2001:db8:3::2/64                                         |
+# |                                                               |  (maybe) HW
+# =============================================================================
+# |                                                               |  (likely) SW
+# |    + v1 (veth)                             + v3 (veth)        |
+# |    | 2001:db8:4::2/64                      | 2001:db8:5::2/64 |
+# +----|---------------------------------------|------------------+
+#      |                                       |
+# +----|--------------------------------+ +----|-------------------------------+
+# |    + v2 (veth)        NS1 (netns)   | |    + v4 (veth)        NS2 (netns)  |
+# |      2001:db8:4::1/64               | |      2001:db8:5::1/64              |
+# |                                     | |                                    |
+# | 2001:db8:3::0/64 via 2001:db8:4::2  | | 2001:db8:3::0/64 via 2001:db8:5::2 |
+# | 2001:db8:5::1/128 via 2001:db8:4::2 | | 2001:db8:4::1/128 via              |
+# |                                     | |         2001:db8:5::2              |
+# |                                     | |                                    |
+# | +-------------------------------+   | | +-------------------------------+  |
+# | |                  BR2 (802.1d) |   | | |                  BR2 (802.1d) |  |
+# | |  + vx2 (vxlan)                |   | | |  + vx2 (vxlan)                |  |
+# | |    local 2001:db8:4::1        |   | | |    local 2001:db8:5::1        |  |
+# | |    remote 2001:db8:3::1       |   | | |    remote 2001:db8:3::1       |  |
+# | |    remote 2001:db8:5::1       |   | | |    remote 2001:db8:4::1       |  |
+# | |    id 1000 dstport $VXPORT    |   | | |    id 1000 dstport $VXPORT    |  |
+# | |                               |   | | |                               |  |
+# | |  + w1 (veth)                  |   | | |  + w1 (veth)                  |  |
+# | +--|----------------------------+   | | +--|----------------------------+  |
+# |    |                                | |    |                               |
+# | +--|----------------------------+   | | +--|----------------------------+  |
+# | |  + w2 (veth)        VW2 (vrf) |   | | |  + w2 (veth)        VW2 (vrf) |  |
+# | |    192.0.2.3/28               |   | | |    192.0.2.4/28               |  |
+# | |    2001:db8:1::3/64           |   | | |    2001:db8:1::4/64           |  |
+# | +-------------------------------+   | | +-------------------------------+  |
+# +-------------------------------------+ +------------------------------------+
+
+: ${VXPORT:=4789}
+export VXPORT
+
+: ${ALL_TESTS:="
+	ping_ipv4
+	ping_ipv6
+	test_flood
+	test_unicast
+	test_ttl
+	test_tos
+	test_ecn_encap
+	test_ecn_decap
+	reapply_config
+	ping_ipv4
+	ping_ipv6
+	test_flood
+	test_unicast
+"}
+
+NUM_NETIFS=6
+source lib.sh
+source tc_common.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/28 2001:db8:1::1/64
+	tc qdisc add dev $h1 clsact
+}
+
+h1_destroy()
+{
+	tc qdisc del dev $h1 clsact
+	simple_if_fini $h1 192.0.2.1/28 2001:db8:1::1/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.2/28 2001:db8:1::2/64
+	tc qdisc add dev $h2 clsact
+}
+
+h2_destroy()
+{
+	tc qdisc del dev $h2 clsact
+	simple_if_fini $h2 192.0.2.2/28 2001:db8:1::2/64
+}
+
+rp1_set_addr()
+{
+	ip address add dev $rp1 2001:db8:3::1/64
+
+	ip route add 2001:db8:4::0/64 nexthop via 2001:db8:3::2
+	ip route add 2001:db8:5::0/64 nexthop via 2001:db8:3::2
+}
+
+rp1_unset_addr()
+{
+	ip route del 2001:db8:5::0/64 nexthop via 2001:db8:3::2
+	ip route del 2001:db8:4::0/64 nexthop via 2001:db8:3::2
+
+	ip address del dev $rp1 2001:db8:3::1/64
+}
+
+switch_create()
+{
+	ip link add name br1 type bridge vlan_filtering 0 mcast_snooping 0
+	# Make sure the bridge uses the MAC address of the local port and not
+	# that of the VxLAN's device.
+	ip link set dev br1 address $(mac_get $swp1)
+	ip link set dev br1 up
+
+	ip link set dev $rp1 up
+	rp1_set_addr
+	tc qdisc add dev $rp1 clsact
+
+	ip link add name vx1 type vxlan id 1000	local 2001:db8:3::1 \
+		dstport "$VXPORT" nolearning udp6zerocsumrx udp6zerocsumtx \
+		tos inherit ttl 100
+	ip link set dev vx1 up
+
+	ip link set dev vx1 master br1
+	ip link set dev $swp1 master br1
+	ip link set dev $swp1 up
+	tc qdisc add dev $swp1 clsact
+
+	ip link set dev $swp2 master br1
+	ip link set dev $swp2 up
+
+	bridge fdb append dev vx1 00:00:00:00:00:00 dst 2001:db8:4::1 self
+	bridge fdb append dev vx1 00:00:00:00:00:00 dst 2001:db8:5::1 self
+}
+
+switch_destroy()
+{
+	bridge fdb del dev vx1 00:00:00:00:00:00 dst 2001:db8:5::1 self
+	bridge fdb del dev vx1 00:00:00:00:00:00 dst 2001:db8:4::1 self
+
+	ip link set dev $swp2 down
+	ip link set dev $swp2 nomaster
+
+	tc qdisc del dev $swp1 clsact
+	ip link set dev $swp1 down
+	ip link set dev $swp1 nomaster
+
+	ip link set dev vx1 nomaster
+	ip link set dev vx1 down
+	ip link del dev vx1
+
+	tc qdisc del dev $rp1 clsact
+	rp1_unset_addr
+	ip link set dev $rp1 down
+
+	ip link set dev br1 down
+	ip link del dev br1
+}
+
+vrp2_create()
+{
+	simple_if_init $rp2 2001:db8:3::2/64
+	__simple_if_init v1 v$rp2 2001:db8:4::2/64
+	__simple_if_init v3 v$rp2 2001:db8:5::2/64
+	tc qdisc add dev v1 clsact
+}
+
+vrp2_destroy()
+{
+	tc qdisc del dev v1 clsact
+	__simple_if_fini v3 2001:db8:5::2/64
+	__simple_if_fini v1 2001:db8:4::2/64
+	simple_if_fini $rp2 2001:db8:3::2/64
+}
+
+ns_init_common()
+{
+	local in_if=$1; shift
+	local in_addr=$1; shift
+	local other_in_addr=$1; shift
+	local nh_addr=$1; shift
+	local host_addr_ipv4=$1; shift
+	local host_addr_ipv6=$1; shift
+
+	ip link set dev $in_if up
+	ip address add dev $in_if $in_addr/64
+	tc qdisc add dev $in_if clsact
+
+	ip link add name br2 type bridge vlan_filtering 0
+	ip link set dev br2 up
+
+	ip link add name w1 type veth peer name w2
+
+	ip link set dev w1 master br2
+	ip link set dev w1 up
+
+	ip link add name vx2 type vxlan id 1000 local $in_addr \
+		dstport "$VXPORT" udp6zerocsumrx
+	ip link set dev vx2 up
+	bridge fdb append dev vx2 00:00:00:00:00:00 dst 2001:db8:3::1 self
+	bridge fdb append dev vx2 00:00:00:00:00:00 dst $other_in_addr self
+
+	ip link set dev vx2 master br2
+	tc qdisc add dev vx2 clsact
+
+	simple_if_init w2 $host_addr_ipv4/28 $host_addr_ipv6/64
+
+	ip route add 2001:db8:3::0/64 nexthop via $nh_addr
+	ip route add $other_in_addr/128 nexthop via $nh_addr
+}
+export -f ns_init_common
+
+ns1_create()
+{
+	ip netns add ns1
+	ip link set dev v2 netns ns1
+	in_ns ns1 \
+	      ns_init_common v2 2001:db8:4::1 2001:db8:5::1 2001:db8:4::2 \
+	      192.0.2.3 2001:db8:1::3
+}
+
+ns1_destroy()
+{
+	ip netns exec ns1 ip link set dev v2 netns 1
+	ip netns del ns1
+}
+
+ns2_create()
+{
+	ip netns add ns2
+	ip link set dev v4 netns ns2
+	in_ns ns2 \
+	      ns_init_common v4 2001:db8:5::1 2001:db8:4::1 2001:db8:5::2 \
+	      192.0.2.4 2001:db8:1::4
+}
+
+ns2_destroy()
+{
+	ip netns exec ns2 ip link set dev v4 netns 1
+	ip netns del ns2
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
+	ip link add name v3 type veth peer name v4
+	vrp2_create
+	ns1_create
+	ns2_create
+
+	r1_mac=$(in_ns ns1 mac_get w2)
+	r2_mac=$(in_ns ns2 mac_get w2)
+	h2_mac=$(mac_get $h2)
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	ns2_destroy
+	ns1_destroy
+	vrp2_destroy
+	ip link del dev v3
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
+# For the first round of tests, vx1 is the first device to get
+# attached to the bridge, and at that point the local IP is already
+# configured. Try the other scenario of attaching the devices to a an
+# already-offloaded bridge, and only then assign the local IP.
+reapply_config()
+{
+	log_info "Reapplying configuration"
+
+	bridge fdb del dev vx1 00:00:00:00:00:00 dst 2001:db8:5::1 self
+	bridge fdb del dev vx1 00:00:00:00:00:00 dst 2001:db8:4::1 self
+	ip link set dev vx1 nomaster
+	rp1_unset_addr
+	sleep 5
+
+	ip link set dev vx1 master br1
+	bridge fdb append dev vx1 00:00:00:00:00:00 dst 2001:db8:4::1 self
+	bridge fdb append dev vx1 00:00:00:00:00:00 dst 2001:db8:5::1 self
+	sleep 1
+	rp1_set_addr
+	sleep 5
+}
+
+__ping_ipv4()
+{
+	local vxlan_local_ip=$1; shift
+	local vxlan_remote_ip=$1; shift
+	local src_ip=$1; shift
+	local dst_ip=$1; shift
+	local dev=$1; shift
+	local info=$1; shift
+
+	RET=0
+
+	tc filter add dev $rp1 egress protocol ipv6 pref 1 handle 101 \
+		flower ip_proto udp src_ip $vxlan_local_ip \
+		dst_ip $vxlan_remote_ip dst_port $VXPORT $TC_FLAG action pass
+	# Match ICMP-reply packets after decapsulation, so source IP is
+	# destination IP of the ping and destination IP is source IP of the
+	# ping.
+	tc filter add dev $swp1 egress protocol ip pref 1 handle 101 \
+		flower src_ip $dst_ip dst_ip $src_ip \
+		$TC_FLAG action pass
+
+	# Send 100 packets and verify that at least 100 packets hit the rule,
+	# to overcome ARP noise.
+	PING_COUNT=100 PING_TIMEOUT=11 ping_do $dev $dst_ip
+	check_err $? "Ping failed"
+
+	tc_check_at_least_x_packets "dev $rp1 egress" 101 10 100
+	check_err $? "Encapsulated packets did not go through router"
+
+	tc_check_at_least_x_packets "dev $swp1 egress" 101 10 100
+	check_err $? "Decapsulated packets did not go through switch"
+
+	log_test "ping: $info"
+
+	tc filter del dev $swp1 egress
+	tc filter del dev $rp1 egress
+}
+
+ping_ipv4()
+{
+	RET=0
+
+	local local_sw_ip=2001:db8:3::1
+	local remote_ns1_ip=2001:db8:4::1
+	local remote_ns2_ip=2001:db8:5::1
+	local h1_ip=192.0.2.1
+	local w2_ns1_ip=192.0.2.3
+	local w2_ns2_ip=192.0.2.4
+
+	ping_test $h1 192.0.2.2 ": local->local"
+
+	__ping_ipv4 $local_sw_ip $remote_ns1_ip $h1_ip $w2_ns1_ip $h1 \
+		"local->remote 1"
+	__ping_ipv4 $local_sw_ip $remote_ns2_ip $h1_ip $w2_ns2_ip $h1 \
+		"local->remote 2"
+}
+
+__ping_ipv6()
+{
+	local vxlan_local_ip=$1; shift
+	local vxlan_remote_ip=$1; shift
+	local src_ip=$1; shift
+	local dst_ip=$1; shift
+	local dev=$1; shift
+	local info=$1; shift
+
+	RET=0
+
+	tc filter add dev $rp1 egress protocol ipv6 pref 1 handle 101 \
+		flower ip_proto udp src_ip $vxlan_local_ip \
+		dst_ip $vxlan_remote_ip dst_port $VXPORT $TC_FLAG action pass
+	# Match ICMP-reply packets after decapsulation, so source IP is
+	# destination IP of the ping and destination IP is source IP of the
+	# ping.
+	tc filter add dev $swp1 egress protocol ipv6 pref 1 handle 101 \
+		flower src_ip $dst_ip dst_ip $src_ip $TC_FLAG action pass
+
+	# Send 100 packets and verify that at least 100 packets hit the rule,
+	# to overcome neighbor discovery noise.
+	PING_COUNT=100 PING_TIMEOUT=11 ping6_do $dev $dst_ip
+	check_err $? "Ping failed"
+
+	tc_check_at_least_x_packets "dev $rp1 egress" 101 100
+	check_err $? "Encapsulated packets did not go through router"
+
+	tc_check_at_least_x_packets "dev $swp1 egress" 101 100
+	check_err $? "Decapsulated packets did not go through switch"
+
+	log_test "ping6: $info"
+
+	tc filter del dev $swp1 egress
+	tc filter del dev $rp1 egress
+}
+
+ping_ipv6()
+{
+	RET=0
+
+	local local_sw_ip=2001:db8:3::1
+	local remote_ns1_ip=2001:db8:4::1
+	local remote_ns2_ip=2001:db8:5::1
+	local h1_ip=2001:db8:1::1
+	local w2_ns1_ip=2001:db8:1::3
+	local w2_ns2_ip=2001:db8:1::4
+
+	ping6_test $h1 2001:db8:1::2 ": local->local"
+
+	__ping_ipv6 $local_sw_ip $remote_ns1_ip $h1_ip $w2_ns1_ip $h1 \
+		"local->remote 1"
+	__ping_ipv6 $local_sw_ip $remote_ns2_ip $h1_ip $w2_ns2_ip $h1 \
+		"local->remote 2"
+}
+
+maybe_in_ns()
+{
+	echo ${1:+in_ns} $1
+}
+
+__flood_counter_add_del()
+{
+	local add_del=$1; shift
+	local dst_ip=$1; shift
+	local dev=$1; shift
+	local ns=$1; shift
+
+	# Putting the ICMP capture both to HW and to SW will end up
+	# double-counting the packets that are trapped to slow path, such as for
+	# the unicast test. Adding either skip_hw or skip_sw fixes this problem,
+	# but with skip_hw, the flooded packets are not counted at all, because
+	# those are dropped due to MAC address mismatch; and skip_sw is a no-go
+	# for veth-based topologies.
+	#
+	# So try to install with skip_sw and fall back to skip_sw if that fails.
+
+	$(maybe_in_ns $ns) tc filter $add_del dev "$dev" ingress \
+	   proto ipv6 pref 100 flower dst_ip $dst_ip ip_proto \
+	   icmpv6 skip_sw action pass 2>/dev/null || \
+	$(maybe_in_ns $ns) tc filter $add_del dev "$dev" ingress \
+	   proto ipv6 pref 100 flower dst_ip $dst_ip ip_proto \
+	   icmpv6 skip_hw action pass
+}
+
+flood_counter_install()
+{
+	__flood_counter_add_del add "$@"
+}
+
+flood_counter_uninstall()
+{
+	__flood_counter_add_del del "$@"
+}
+
+flood_fetch_stat()
+{
+	local dev=$1; shift
+	local ns=$1; shift
+
+	$(maybe_in_ns $ns) tc_rule_stats_get $dev 100 ingress
+}
+
+flood_fetch_stats()
+{
+	local counters=("${@}")
+	local counter
+
+	for counter in "${counters[@]}"; do
+		flood_fetch_stat $counter
+	done
+}
+
+vxlan_flood_test()
+{
+	local mac=$1; shift
+	local dst=$1; shift
+	local -a expects=("${@}")
+
+	local -a counters=($h2 "vx2 ns1" "vx2 ns2")
+	local counter
+	local key
+
+	for counter in "${counters[@]}"; do
+		flood_counter_install $dst $counter
+	done
+
+	local -a t0s=($(flood_fetch_stats "${counters[@]}"))
+	$MZ -6 $h1 -c 10 -d 100msec -p 64 -b $mac -B $dst -t icmp6 type=128 -q
+	sleep 1
+	local -a t1s=($(flood_fetch_stats "${counters[@]}"))
+
+	for key in ${!t0s[@]}; do
+		local delta=$((t1s[$key] - t0s[$key]))
+		local expect=${expects[$key]}
+
+		((expect == delta))
+		check_err $? "${counters[$key]}: Expected to capture $expect packets, got $delta."
+	done
+
+	for counter in "${counters[@]}"; do
+		flood_counter_uninstall $dst $counter
+	done
+}
+
+__test_flood()
+{
+	local mac=$1; shift
+	local dst=$1; shift
+	local what=$1; shift
+
+	RET=0
+
+	vxlan_flood_test $mac $dst 10 10 10
+
+	log_test "VXLAN: $what"
+}
+
+test_flood()
+{
+	__test_flood de:ad:be:ef:13:37 2001:db8:1::100 "flood"
+}
+
+vxlan_fdb_add_del()
+{
+	local add_del=$1; shift
+	local mac=$1; shift
+	local dev=$1; shift
+	local dst=$1; shift
+
+	bridge fdb $add_del dev $dev $mac self static permanent \
+		${dst:+dst} $dst 2>/dev/null
+	bridge fdb $add_del dev $dev $mac master static 2>/dev/null
+}
+
+__test_unicast()
+{
+	local mac=$1; shift
+	local dst=$1; shift
+	local hit_idx=$1; shift
+	local what=$1; shift
+
+	RET=0
+
+	local -a expects=(0 0 0)
+	expects[$hit_idx]=10
+
+	vxlan_flood_test $mac $dst "${expects[@]}"
+
+	log_test "VXLAN: $what"
+}
+
+test_unicast()
+{
+	local -a targets=("$h2_mac $h2"
+			  "$r1_mac vx1 2001:db8:4::1"
+			  "$r2_mac vx1 2001:db8:5::1")
+	local target
+
+	for target in "${targets[@]}"; do
+		vxlan_fdb_add_del add $target
+	done
+
+	__test_unicast $h2_mac 2001:db8:1::2 0 "local MAC unicast"
+	__test_unicast $r1_mac 2001:db8:1::3 1 "remote MAC 1 unicast"
+	__test_unicast $r2_mac 2001:db8:1::4 2 "remote MAC 2 unicast"
+
+	for target in "${targets[@]}"; do
+		vxlan_fdb_add_del del $target
+	done
+}
+
+vxlan_ping_test()
+{
+	local ping_dev=$1; shift
+	local ping_dip=$1; shift
+	local ping_args=$1; shift
+	local capture_dev=$1; shift
+	local capture_dir=$1; shift
+	local capture_pref=$1; shift
+	local expect=$1; shift
+
+	local t0=$(tc_rule_stats_get $capture_dev $capture_pref $capture_dir)
+	ping6_do $ping_dev $ping_dip "$ping_args"
+	local t1=$(tc_rule_stats_get $capture_dev $capture_pref $capture_dir)
+	local delta=$((t1 - t0))
+
+	# Tolerate a couple stray extra packets.
+	((expect <= delta && delta <= expect + 2))
+	check_err $? "$capture_dev: Expected to capture $expect packets, got $delta."
+}
+
+test_ttl()
+{
+	RET=0
+
+	tc filter add dev v1 egress pref 77 protocol ipv6 \
+		flower ip_ttl 99 action pass
+	vxlan_ping_test $h1 2001:db8:1::3 "" v1 egress 77 10
+	tc filter del dev v1 egress pref 77 protocol ipv6
+
+	log_test "VXLAN: envelope TTL"
+}
+
+test_tos()
+{
+	RET=0
+
+	tc filter add dev v1 egress pref 77 protocol ipv6 \
+		flower ip_tos 0x14 action pass
+	vxlan_ping_test $h1 2001:db8:1::3 "-Q 0x14" v1 egress 77 10
+	vxlan_ping_test $h1 2001:db8:1::3 "-Q 0x18" v1 egress 77 0
+	tc filter del dev v1 egress pref 77 protocol ipv6
+
+	log_test "VXLAN: envelope TOS inheritance"
+}
+
+__test_ecn_encap()
+{
+	local q=$1; shift
+	local tos=$1; shift
+
+	RET=0
+
+	tc filter add dev v1 egress pref 77 protocol ipv6 \
+		flower ip_tos $tos action pass
+	sleep 1
+	vxlan_ping_test $h1 2001:db8:1::3 "-Q $q" v1 egress 77 10
+	tc filter del dev v1 egress pref 77 protocol ipv6
+
+	log_test "VXLAN: ECN encap: $q->$tos"
+}
+
+test_ecn_encap()
+{
+	# In accordance with INET_ECN_encapsulate()
+	__test_ecn_encap 0x00 0x00
+	__test_ecn_encap 0x01 0x01
+	__test_ecn_encap 0x02 0x02
+	__test_ecn_encap 0x03 0x02
+}
+
+vxlan_encapped_ping_do()
+{
+	local count=$1; shift
+	local dev=$1; shift
+	local next_hop_mac=$1; shift
+	local dest_ip=$1; shift
+	local dest_mac=$1; shift
+	local inner_tos=$1; shift
+	local outer_tos=$1; shift
+	local saddr="20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:03"
+	local daddr="20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:01"
+
+	$MZ -6 $dev -c $count -d 100msec -q \
+		-b $next_hop_mac -B $dest_ip \
+		-t udp tos=$outer_tos,sp=23456,dp=$VXPORT,p=$(:
+		    )"08:"$(                      : VXLAN flags
+		    )"00:00:00:"$(                : VXLAN reserved
+		    )"00:03:e8:"$(                : VXLAN VNI
+		    )"00:"$(                      : VXLAN reserved
+		    )"$dest_mac:"$(               : ETH daddr
+		    )"$(mac_get w2):"$(           : ETH saddr
+		    )"86:dd:"$(                   : ETH type
+		    )"6"$(			  : IP version
+		    )"$inner_tos"$(               : Traffic class
+		    )"0:00:00:"$(                 : Flow label
+		    )"00:08:"$(                   : Payload length
+		    )"3a:"$(                      : Next header
+		    )"04:"$(                      : Hop limit
+		    )"$saddr:"$(		  : IP saddr
+		    )"$daddr:"$(		  : IP daddr
+		    )"80:"$(			  : ICMPv6.type
+		    )"00:"$(			  : ICMPv6.code
+		    )"00:"$(			  : ICMPv6.checksum
+		    )
+}
+export -f vxlan_encapped_ping_do
+
+vxlan_encapped_ping_test()
+{
+	local ping_dev=$1; shift
+	local nh_dev=$1; shift
+	local ping_dip=$1; shift
+	local inner_tos=$1; shift
+	local outer_tos=$1; shift
+	local stat_get=$1; shift
+	local expect=$1; shift
+
+	local t0=$($stat_get)
+
+	in_ns ns1 \
+		vxlan_encapped_ping_do 10 $ping_dev $(mac_get $nh_dev) \
+			$ping_dip $(mac_get $h1) \
+			$inner_tos $outer_tos
+	sleep 1
+	local t1=$($stat_get)
+	local delta=$((t1 - t0))
+
+	# Tolerate a couple stray extra packets.
+	((expect <= delta && delta <= expect + 2))
+	check_err $? "Expected to capture $expect packets, got $delta."
+}
+export -f vxlan_encapped_ping_test
+
+__test_ecn_decap()
+{
+	local orig_inner_tos=$1; shift
+	local orig_outer_tos=$1; shift
+	local decapped_tos=$1; shift
+
+	RET=0
+
+	tc filter add dev $h1 ingress pref 77 protocol ipv6 \
+		flower src_ip 2001:db8:1::3 dst_ip 2001:db8:1::1 \
+		ip_tos $decapped_tos action drop
+	sleep 1
+	vxlan_encapped_ping_test v2 v1 2001:db8:3::1 \
+				 $orig_inner_tos $orig_outer_tos \
+				 "tc_rule_stats_get $h1 77 ingress" 10
+	tc filter del dev $h1 ingress pref 77
+
+	log_test "VXLAN: ECN decap: $orig_outer_tos/$orig_inner_tos->$decapped_tos"
+}
+
+test_ecn_decap_error()
+{
+	local orig_inner_tos="0:0"
+	local orig_outer_tos=03
+
+	RET=0
+
+	vxlan_encapped_ping_test v2 v1 2001:db8:3::1 \
+				 $orig_inner_tos $orig_outer_tos \
+				 "link_stats_rx_errors_get vx1" 10
+
+	log_test "VXLAN: ECN decap: $orig_outer_tos/$orig_inner_tos->error"
+}
+
+test_ecn_decap()
+{
+	# In accordance with INET_ECN_decapsulate()
+	__test_ecn_decap "0:0" 00 0x00
+	__test_ecn_decap "0:0" 01 0x00
+	__test_ecn_decap "0:0" 02 0x00
+	# 00 03 is tested in test_ecn_decap_error()
+	__test_ecn_decap "0:1" 00 0x01
+	__test_ecn_decap "0:1" 01 0x01
+	__test_ecn_decap "0:1" 02 0x01
+	__test_ecn_decap "0:1" 03 0x03
+	__test_ecn_decap "0:2" 00 0x02
+	__test_ecn_decap "0:2" 01 0x01
+	__test_ecn_decap "0:2" 02 0x02
+	__test_ecn_decap "0:2" 03 0x03
+	__test_ecn_decap "0:3" 00 0x03
+	__test_ecn_decap "0:3" 01 0x03
+	__test_ecn_decap "0:3" 02 0x03
+	__test_ecn_decap "0:3" 03 0x03
+	test_ecn_decap_error
+}
+
+test_all()
+{
+	log_info "Running tests with UDP port $VXPORT"
+	tests_run
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+test_all
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d_port_8472_ipv6.sh b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d_port_8472_ipv6.sh
new file mode 100755
index 000000000000..00540317737a
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d_port_8472_ipv6.sh
@@ -0,0 +1,11 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# A wrapper to run VXLAN tests with an unusual port number.
+
+VXPORT=8472
+ALL_TESTS="
+	ping_ipv4
+	ping_ipv6
+"
+source vxlan_bridge_1d_ipv6.sh
-- 
2.31.1

