Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8683747C1ED
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 15:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238645AbhLUOxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 09:53:05 -0500
Received: from mail-dm6nam10on2042.outbound.protection.outlook.com ([40.107.93.42]:27105
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235023AbhLUOxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 09:53:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BGv3owzRI7PQNtFjN3edZ7aEM2ddo8LS20kSWpojZXj3JuVRhk4i35y8kprTsGcDqeXrNCRG0PtAMORmOUpgXNBNnwZgxfb4MFqDfbDZvx//dr/vAJWzx6Ls3muIXLQbYNdJJax+QY21qP7ZQWU5sa9C6J8wnRTNSduI1w76AhWkpKK/qlBfKuWDm8rYreewJBaXsQQqO6AUbyyeQ7KgtHvVJlxJShxHNyCLXT8FCWEoySUTqbfAJ0CMlj063fjLP8Uy8noGv+Ti2N1g9j3EFfZjMXxTGFWHRSkRORzdkHc6+2Z8UvsTS4FwVFcnye5URBiEqE03p65Di8WkSTgozA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4Ap9J4BseZME51VvkVQxUhUY4YsLw/wzUTdaqJx23A=;
 b=J9zyCyId24F6dIDR5egn5BJw/YZeQVTB2ON/yDh2LbXM84aUxVgHqLEX1rXD45Nt0xlLNoK+qIOEVyKMNicQ4RsCu5E03Ozm/wCZyng8/0vkVuIbLiZ1i/KedW/hpQAMBh0axrnUf01NV2+YGiIPP5Y+lZinI9eRZ/1aA58cK8gt0vaCMaSiQ4IW3HOpvc/ZZ3/Q5y38Zw97WOdt5g9U98T1a4wyLLJsTL3Kxg+cy3TduMDp2qUCpoHaP7VzsPGgKbfNYqfTa1U7qyPBk/dR/eSOk/OJd6+Lg81Tkh02aHziOeGiHdDKWGKXqyw/yq3mLwjPa5R3LmZ6XaHlTvcp4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4Ap9J4BseZME51VvkVQxUhUY4YsLw/wzUTdaqJx23A=;
 b=a94imAvbRgS7avh0MXHdmgA3YrmeksO9z57BZhSXzx5Pr7gqSi7QgXq1vPsYlH6eS08XDF7miq2jUmnLMWR+2JWi+dthu96PCDgxlu7CS98UxVaw4r1lHYy01xJOYdi8Ay1c0NrlYI4EbXmia1moCQu0NyU9VJXgRdX4h9BTrzmdDYIKDM8Aw4TVHA/ZM4be6zp3XYK+EGaz4DWs2N2jjcGwkM9XK/44ZeAgsOzf6q28Og0uuPnFhlsI9pOUwbXpeBpmdcqIaQV8yn2+moyXL8w3rH3kDwycaxrtBwOY44CglolS/6Qofdfj2+jYYlT50aLM2VkmWnO0+E8jCuhn2w==
Received: from MWHPR08CA0043.namprd08.prod.outlook.com (2603:10b6:300:c0::17)
 by CY4PR12MB1400.namprd12.prod.outlook.com (2603:10b6:903:3a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Tue, 21 Dec
 2021 14:53:02 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:c0:cafe::e8) by MWHPR08CA0043.outlook.office365.com
 (2603:10b6:300:c0::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Tue, 21 Dec 2021 14:53:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Tue, 21 Dec 2021 14:53:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Dec
 2021 14:53:00 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 21 Dec 2021 06:52:57 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 8/8] selftests: forwarding: Add Q-in-VNI test for IPv6
Date:   Tue, 21 Dec 2021 16:49:49 +0200
Message-ID: <20211221144949.2527545-9-amcohen@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 93d10317-5ea3-4894-be83-08d9c491958a
X-MS-TrafficTypeDiagnostic: CY4PR12MB1400:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB140072A9CD8F29609948FEF7CB7C9@CY4PR12MB1400.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iq64snOaBOS5UhEKr+jaBr6CTimbdEPrs9eyPs+XtlJKXCDq4sdJ2CdV/85Ax6QZMKlekRGg1DEq5drsCRVxnubfoWVoct6LrVrg9S849IbqUukLXs0vxIl0yRybyE0FCCr3f50P8ZkXHNL42ZoI3Se8gmhqAHogzdaJagx9wEymEs7tGW1J7YYE7iOr/vyMz3Vt8b+bu8lzcQaoejKuBl01uskMRqsN5b2l/yggXDOKolXqlveo2Uvn7pE9RBtkFmVcwVYCqRovTM/WgyCUKMgrZuFtWK2kIecLvnqog8/C64zNFJ7uQqRSA71X2KuzrfVyzQlpFJccysS2Vl8Ku/vBB5FpHxscwfcxiKJa3EDV97zx+1rhmO8bSFw5R58oBTXR2aJvRSiaslhN0AsXqyykFoeYQk4x7d28tC1+WDaF7GLbUpoyVbt0LVFcze4T1YRzArXIkRkkmuo3IKza4vqwuNj/4wlh5epBLIfv76InbF+Kn7p0StpgtH++EHoKh/67vmDxhSePHYw3it8jlIaGz31lVsbsNvKFivcekIz43sbfrc43d8WMrjBlQBFo52p9cVUP+GyKESCqF0WK2J5YzkuhIQA97Lo7mxfQJwCiHeWFHxxsibhyNnbZ2uGPCqy8BBVxWqjsLbjBPJuGRZFVG7xKkOIPXs1laBxIJgOheGE1SyYc1TVR3QDmoYYL0yFVbDT4RiWKJr9BDWEQ7sf5CKrYlAEqxjOxY61xCYBxKZyORXFTnXwchx5yROxSl3sltGEzX+VC7GOnT0+sS4CryBflOdM9jNvwJWakaEaU31FtdoJ40HNAwHHXRuGEnUxKmSrvrCLUUGjVXMbQ5Q==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(6666004)(81166007)(82310400004)(34020700004)(356005)(36756003)(70586007)(6916009)(508600001)(107886003)(26005)(47076005)(1076003)(5660300002)(426003)(2616005)(336012)(4326008)(70206006)(186003)(40460700001)(16526019)(316002)(2906002)(86362001)(54906003)(36860700001)(83380400001)(8936002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 14:53:00.6429
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d10317-5ea3-4894-be83-08d9c491958a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1400
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test to check Q-in-VNI traffic with IPv6 underlay and overlay.
The test is similar to the existing IPv4 test.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../selftests/net/forwarding/q_in_vni_ipv6.sh | 347 ++++++++++++++++++
 1 file changed, 347 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/q_in_vni_ipv6.sh

diff --git a/tools/testing/selftests/net/forwarding/q_in_vni_ipv6.sh b/tools/testing/selftests/net/forwarding/q_in_vni_ipv6.sh
new file mode 100755
index 000000000000..0548b2b0d416
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/q_in_vni_ipv6.sh
@@ -0,0 +1,347 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# +-----------------------+                          +------------------------+
+# | H1 (vrf)              |                          | H2 (vrf)               |
+# |  + $h1.10             |                          |  + $h2.10              |
+# |  | 2001:db8:1::1/64   |                          |  | 2001:db8:1::2/64    |
+# |  |                    |                          |  |                     |
+# |  | + $h1.20           |                          |  | + $h2.20            |
+# |  \ | 2001:db8:2::1/64 |                          |  \ | 2001:db8:2::2/64  |
+# |   \|                  |                          |   \|                   |
+# |    + $h1              |                          |    + $h2               |
+# +----|------------------+                          +----|-------------------+
+#      |                                                  |
+# +----|--------------------------------------------------|-------------------+
+# | SW |                                                  |                   |
+# | +--|--------------------------------------------------|-----------------+ |
+# | |  + $swp1                   BR1 (802.1ad)            + $swp2           | |
+# | |    vid 100 pvid untagged                              vid 100 pvid    | |
+# | |                                                           untagged    | |
+# | |  + vx100 (vxlan)                                                      | |
+# | |    local 2001:db8:3::1                                                | |
+# | |    remote 2001:db8:4::1 2001:db8:5::1                                 | |
+# | |    id 1000 dstport $VXPORT                                            | |
+# | |    vid 100 pvid untagged                                              | |
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
+# |                                                               |   (maybe) HW
+# =============================================================================
+# |                                                               | (likely) SW
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
+# |                                     | |           2001:db8:5::2            |
+# | +-------------------------------+   | | +-------------------------------+  |
+# | |                 BR2 (802.1ad) |   | | |                 BR2 (802.1ad) |  |
+# | |  + vx100 (vxlan)              |   | | |  + vx100 (vxlan)              |  |
+# | |    local 2001:db8:4::1        |   | | |    local 2001:db8:5::1        |  |
+# | |    remote 2001:db8:3::1       |   | | |    remote 2001:db8:3::1       |  |
+# | |    remote 2001:db8:5::1       |   | | |    remote 2001:db8:4::1       |  |
+# | |    id 1000 dstport $VXPORT    |   | | |    id 1000 dstport $VXPORT    |  |
+# | |    vid 100 pvid untagged      |   | | |    vid 100 pvid untagged      |  |
+# | |                               |   | | |                               |  |
+# | |  + w1 (veth)                  |   | | |  + w1 (veth)                  |  |
+# | |  | vid 100 pvid untagged      |   | | |  | vid 100 pvid untagged      |  |
+# | +--|----------------------------+   | | +--|----------------------------+  |
+# |    |                                | |    |                               |
+# | +--|----------------------------+   | | +--|----------------------------+  |
+# | |  |                  VW2 (vrf) |   | | |  |                  VW2 (vrf) |  |
+# | |  + w2 (veth)                  |   | | |  + w2 (veth)                  |  |
+# | |  |\                           |   | | |  |\                           |  |
+# | |  | + w2.10                    |   | | |  | + w2.10                    |  |
+# | |  |   2001:db8:1::3/64         |   | | |  |   2001:db8:1::4/64         |  |
+# | |  |                            |   | | |  |                            |  |
+# | |  + w2.20                      |   | | |  + w2.20                      |  |
+# | |    2001:db8:2::3/64           |   | | |    2001:db8:2::4/64           |  |
+# | +-------------------------------+   | | +-------------------------------+  |
+# +-------------------------------------+ +------------------------------------+
+
+: ${VXPORT:=4789}
+export VXPORT
+
+: ${ALL_TESTS:="
+	ping_ipv6
+    "}
+
+NUM_NETIFS=6
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1
+	tc qdisc add dev $h1 clsact
+	vlan_create $h1 10 v$h1 2001:db8:1::1/64
+	vlan_create $h1 20 v$h1 2001:db8:2::1/64
+}
+
+h1_destroy()
+{
+	vlan_destroy $h1 20
+	vlan_destroy $h1 10
+	tc qdisc del dev $h1 clsact
+	simple_if_fini $h1
+}
+
+h2_create()
+{
+	simple_if_init $h2
+	tc qdisc add dev $h2 clsact
+	vlan_create $h2 10 v$h2 2001:db8:1::2/64
+	vlan_create $h2 20 v$h2 2001:db8:2::2/64
+}
+
+h2_destroy()
+{
+	vlan_destroy $h2 20
+	vlan_destroy $h2 10
+	tc qdisc del dev $h2 clsact
+	simple_if_fini $h2
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
+	ip link add name br1 type bridge vlan_filtering 1 vlan_protocol 802.1ad \
+		vlan_default_pvid 0 mcast_snooping 0
+	# Make sure the bridge uses the MAC address of the local port and not
+	# that of the VxLAN's device.
+	ip link set dev br1 address $(mac_get $swp1)
+	ip link set dev br1 up
+
+	ip link set dev $rp1 up
+	rp1_set_addr
+
+	ip link add name vx100 type vxlan id 1000	\
+		local 2001:db8:3::1 dstport "$VXPORT"	\
+		nolearning udp6zerocsumrx udp6zerocsumtx tos inherit ttl 100
+	ip link set dev vx100 up
+
+	ip link set dev vx100 master br1
+	bridge vlan add vid 100 dev vx100 pvid untagged
+
+	ip link set dev $swp1 master br1
+	ip link set dev $swp1 up
+	bridge vlan add vid 100 dev $swp1 pvid untagged
+
+	ip link set dev $swp2 master br1
+	ip link set dev $swp2 up
+	bridge vlan add vid 100 dev $swp2 pvid untagged
+
+	bridge fdb append dev vx100 00:00:00:00:00:00 dst 2001:db8:4::1 self
+	bridge fdb append dev vx100 00:00:00:00:00:00 dst 2001:db8:5::1 self
+}
+
+switch_destroy()
+{
+	bridge fdb del dev vx100 00:00:00:00:00:00 dst 2001:db8:5::1 self
+	bridge fdb del dev vx100 00:00:00:00:00:00 dst 2001:db8:4::1 self
+
+	bridge vlan del vid 100 dev $swp2
+	ip link set dev $swp2 down
+	ip link set dev $swp2 nomaster
+
+	bridge vlan del vid 100 dev $swp1
+	ip link set dev $swp1 down
+	ip link set dev $swp1 nomaster
+
+	ip link set dev vx100 nomaster
+	ip link set dev vx100 down
+	ip link del dev vx100
+
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
+	local host_addr1=$1; shift
+	local host_addr2=$1; shift
+
+	ip link set dev $in_if up
+	ip address add dev $in_if $in_addr/64
+	tc qdisc add dev $in_if clsact
+
+	ip link add name br2 type bridge vlan_filtering 1 vlan_protocol 802.1ad \
+		vlan_default_pvid 0
+	ip link set dev br2 up
+
+	ip link add name w1 type veth peer name w2
+
+	ip link set dev w1 master br2
+	ip link set dev w1 up
+	bridge vlan add vid 100 dev w1 pvid untagged
+
+	ip link add name vx100 type vxlan id 1000 local $in_addr \
+		dstport "$VXPORT" udp6zerocsumrx
+	ip link set dev vx100 up
+	bridge fdb append dev vx100 00:00:00:00:00:00 dst 2001:db8:3::1 self
+	bridge fdb append dev vx100 00:00:00:00:00:00 dst $other_in_addr self
+
+	ip link set dev vx100 master br2
+	tc qdisc add dev vx100 clsact
+
+	bridge vlan add vid 100 dev vx100 pvid untagged
+
+	simple_if_init w2
+        vlan_create w2 10 vw2 $host_addr1/64
+        vlan_create w2 20 vw2 $host_addr2/64
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
+			    2001:db8:1::3 2001:db8:2::3
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
+			     2001:db8:1::4 2001:db8:2::4
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
+ping_ipv6()
+{
+	ping6_test $h1 2001:db8:1::2 ": local->local"
+	ping6_test $h1 2001:db8:1::3 ": local->remote 1"
+	ping6_test $h1 2001:db8:1::4 ": local->remote 2"
+}
+
+test_all()
+{
+	echo "Running tests with UDP port $VXPORT"
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
-- 
2.31.1

