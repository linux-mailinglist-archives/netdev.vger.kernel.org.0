Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E143393EE
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhCLQvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:51:55 -0500
Received: from mail-mw2nam12on2067.outbound.protection.outlook.com ([40.107.244.67]:19489
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232283AbhCLQvl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 11:51:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cAYKvNmJdpaAxl5TC1SvNwlCUCysYS+MxGugYASZh0UYQkwMnKVJ8h/SKa8eSrrpRqmAH8KMX+HMJ1iXMOjYVkmvFmzJSBLKpJtqNhFC5iu6EQFXA2OdHZnnaN6WfrUmLtph4cuVQWimUetW31TQuH0Z519h2GSN765DCqK8jBlt6/whEq5OCffOrPhN/b1q1Qj3cxlrugwRGxth+fVvk4mWcn2ZJfY35Tpb1FsQrmUihsp8lc8uLziaT9sQ9fYOZWJgYC9tjagjPOSZDB/LBz2VPupet+yf05+/7wfupk6eejWMA85v58cwCBVGcdZ4YjGKnVnVP5A548Z0NKVOig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpUxL+BmQPkC1Hgy7QT4is8cTkk7xyI3RjEpFkOT0Cg=;
 b=Btz4KlJTN2DywJHyiYMPgysVZ02UtV0h7xqxNyadNIqVdTA9RWiUgEetf7RmD0OFRMUqJ1r42ujM9cG6U+17aaF3zzbRZvNidfM5bTSZxiAQNqPWV2BOso+EjZTU/VQWHsaxNNU+CsBwd6iawzB8CN/zB2T2/gbu8DfJqqZ/Lhw6RRAxRusWREcNuyvN4R9naDnhuk/a8bMt4uYpo1nrLjU+GG0NVVXY7oexbdfnQidflUzpLlA2NUq0qtLugIhtL/Ko2iA2FWdHLQlh8pJy4uY5C2w3nLHijevuF1dQ1UzEq1N8S20xk5FvbbsImPfm5cv3tEb+1j7uNj6tV/zcXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpUxL+BmQPkC1Hgy7QT4is8cTkk7xyI3RjEpFkOT0Cg=;
 b=rT/uxgylZK6LY1aMyb68ETe/67O5xtV/hyiLex3mF7mx+q/JXIvH7+7tmRngF3WGrCFJvV5jbr87oMPfXwQ779/+oV0/F0f8BzWvU9Ma2UrgxUcCkuF3fI2FbsRwg8ahKhM2scttf5ZWVUo6orTNsVS3PDBw74tZozeCq214zpObw8mkMdAmhWvdsbXytstX78GLYySyGrKf2dTWZB3ARfDDvC+Qw3Ag1fGZKJUD66998EBIHbYmyxCQZNIrKQkePztiXJFBJ50D6JKxKZuN51fP+VSZxUqC3vvb5E4zO+pUCjuq4rtFeJvs4/27GF2JTtKcY18bFVGHgBKFazL1ew==
Received: from DM6PR06CA0031.namprd06.prod.outlook.com (2603:10b6:5:120::44)
 by CH0PR12MB5170.namprd12.prod.outlook.com (2603:10b6:610:b9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 16:51:39 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::a6) by DM6PR06CA0031.outlook.office365.com
 (2603:10b6:5:120::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.18 via Frontend
 Transport; Fri, 12 Mar 2021 16:51:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 16:51:38 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 16:51:35 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 08/10] selftests: forwarding: Add resilient hashing test
Date:   Fri, 12 Mar 2021 17:50:24 +0100
Message-ID: <f265f2e11610e2fddf37b09c5d9c450f0c4c82b7.1615563035.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615563035.git.petrm@nvidia.com>
References: <cover.1615563035.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f588de7-376f-482e-f684-08d8e5771af9
X-MS-TrafficTypeDiagnostic: CH0PR12MB5170:
X-Microsoft-Antispam-PRVS: <CH0PR12MB51704B4E6A580ABA562BBCF7D66F9@CH0PR12MB5170.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uKn9g2KWNxolfgNdNWCrLeqtvIBpas+VXWzPI41mJdW6qwvbHWoPiMBj8BAFug+bnZGCPUG/rR9/UBDXyvZxGPS+WIrbrLTS1SQEA5Juk5bZ5KqQhLvWLj5xXjXzSk3v5yemCuMbtoDUA6Bu8zED3qptKISraNlx0AJ1dvHrCvq6MtmPMw8zqRM7ETFDaNq1wPPrQ95sBa905lfrkyjEJnPCSdeY6Nb7gojDCsEP1WKOn6tkx+MFQMmKvcyxNsU5ryId/9tUUqBTfJ1ltlWyC/7/4XB2TPJOXTsR+MOGccEYuFetc8EiuXDx7vxopF2kPnziw9XwVTUBv+J7jieZCDeVB1C3zXOy7qkgECG4EZaay1CA1ekCWiFb2/TfKtrvAuxRhfS54Badkvj5c9uNiD9TPnPmfezvl1GNBkfZjfn0D1+LpV+1ofgka+Eb/nUmxull34uaCJPhULQOBIDQ9cD7aAJdGTwS5Nx5saB7x29Lq2qXyvjGopq2QohBvvLwzLUDpg+BSNH5e+2L+HU1AvqYMDSUJodP0/OE022fXNkxTPxOwm6srnH6/yXmr9a0pselIr/5165URo7RWH92M/8Lf+Kk7n1m/9r+aUeilMkrsgmXybQHA2mJHfOMzqfoHJsJ+T3KR4jRUKx01LXVib0kZD9bWobAW5Mgt6KG8rQ8hENaEGgPzIeZYr/Y3N72
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(136003)(36840700001)(46966006)(83380400001)(66574015)(82310400003)(26005)(34020700004)(356005)(70206006)(186003)(336012)(36860700001)(7636003)(82740400003)(86362001)(47076005)(36756003)(5660300002)(8936002)(6916009)(107886003)(478600001)(8676002)(36906005)(54906003)(6666004)(426003)(316002)(2906002)(2616005)(16526019)(4326008)(30864003)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 16:51:38.7784
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f588de7-376f-482e-f684-08d8e5771af9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5170
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Verify that IPv4 and IPv6 multipath forwarding works correctly with
resilient nexthop groups and with different weights.

Test that when the idle timer is not zero, the resilient groups are not
rebalanced - because the nexthop buckets are considered active - and the
initial weights (1:1) are used.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../net/forwarding/router_mpath_nh_res.sh     | 400 ++++++++++++++++++
 1 file changed, 400 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/router_mpath_nh_res.sh

diff --git a/tools/testing/selftests/net/forwarding/router_mpath_nh_res.sh b/tools/testing/selftests/net/forwarding/router_mpath_nh_res.sh
new file mode 100755
index 000000000000..4898dd4118f1
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/router_mpath_nh_res.sh
@@ -0,0 +1,400 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="
+	ping_ipv4
+	ping_ipv6
+	multipath_test
+"
+NUM_NETIFS=8
+source lib.sh
+
+h1_create()
+{
+	vrf_create "vrf-h1"
+	ip link set dev $h1 master vrf-h1
+
+	ip link set dev vrf-h1 up
+	ip link set dev $h1 up
+
+	ip address add 192.0.2.2/24 dev $h1
+	ip address add 2001:db8:1::2/64 dev $h1
+
+	ip route add 198.51.100.0/24 vrf vrf-h1 nexthop via 192.0.2.1
+	ip route add 2001:db8:2::/64 vrf vrf-h1 nexthop via 2001:db8:1::1
+}
+
+h1_destroy()
+{
+	ip route del 2001:db8:2::/64 vrf vrf-h1
+	ip route del 198.51.100.0/24 vrf vrf-h1
+
+	ip address del 2001:db8:1::2/64 dev $h1
+	ip address del 192.0.2.2/24 dev $h1
+
+	ip link set dev $h1 down
+	vrf_destroy "vrf-h1"
+}
+
+h2_create()
+{
+	vrf_create "vrf-h2"
+	ip link set dev $h2 master vrf-h2
+
+	ip link set dev vrf-h2 up
+	ip link set dev $h2 up
+
+	ip address add 198.51.100.2/24 dev $h2
+	ip address add 2001:db8:2::2/64 dev $h2
+
+	ip route add 192.0.2.0/24 vrf vrf-h2 nexthop via 198.51.100.1
+	ip route add 2001:db8:1::/64 vrf vrf-h2 nexthop via 2001:db8:2::1
+}
+
+h2_destroy()
+{
+	ip route del 2001:db8:1::/64 vrf vrf-h2
+	ip route del 192.0.2.0/24 vrf vrf-h2
+
+	ip address del 2001:db8:2::2/64 dev $h2
+	ip address del 198.51.100.2/24 dev $h2
+
+	ip link set dev $h2 down
+	vrf_destroy "vrf-h2"
+}
+
+router1_create()
+{
+	vrf_create "vrf-r1"
+	ip link set dev $rp11 master vrf-r1
+	ip link set dev $rp12 master vrf-r1
+	ip link set dev $rp13 master vrf-r1
+
+	ip link set dev vrf-r1 up
+	ip link set dev $rp11 up
+	ip link set dev $rp12 up
+	ip link set dev $rp13 up
+
+	ip address add 192.0.2.1/24 dev $rp11
+	ip address add 2001:db8:1::1/64 dev $rp11
+
+	ip address add 169.254.2.12/24 dev $rp12
+	ip address add fe80:2::12/64 dev $rp12
+
+	ip address add 169.254.3.13/24 dev $rp13
+	ip address add fe80:3::13/64 dev $rp13
+}
+
+router1_destroy()
+{
+	ip route del 2001:db8:2::/64 vrf vrf-r1
+	ip route del 198.51.100.0/24 vrf vrf-r1
+
+	ip address del fe80:3::13/64 dev $rp13
+	ip address del 169.254.3.13/24 dev $rp13
+
+	ip address del fe80:2::12/64 dev $rp12
+	ip address del 169.254.2.12/24 dev $rp12
+
+	ip address del 2001:db8:1::1/64 dev $rp11
+	ip address del 192.0.2.1/24 dev $rp11
+
+	ip nexthop del id 103
+	ip nexthop del id 101
+	ip nexthop del id 102
+	ip nexthop del id 106
+	ip nexthop del id 104
+	ip nexthop del id 105
+
+	ip link set dev $rp13 down
+	ip link set dev $rp12 down
+	ip link set dev $rp11 down
+
+	vrf_destroy "vrf-r1"
+}
+
+router2_create()
+{
+	vrf_create "vrf-r2"
+	ip link set dev $rp21 master vrf-r2
+	ip link set dev $rp22 master vrf-r2
+	ip link set dev $rp23 master vrf-r2
+
+	ip link set dev vrf-r2 up
+	ip link set dev $rp21 up
+	ip link set dev $rp22 up
+	ip link set dev $rp23 up
+
+	ip address add 198.51.100.1/24 dev $rp21
+	ip address add 2001:db8:2::1/64 dev $rp21
+
+	ip address add 169.254.2.22/24 dev $rp22
+	ip address add fe80:2::22/64 dev $rp22
+
+	ip address add 169.254.3.23/24 dev $rp23
+	ip address add fe80:3::23/64 dev $rp23
+}
+
+router2_destroy()
+{
+	ip route del 2001:db8:1::/64 vrf vrf-r2
+	ip route del 192.0.2.0/24 vrf vrf-r2
+
+	ip address del fe80:3::23/64 dev $rp23
+	ip address del 169.254.3.23/24 dev $rp23
+
+	ip address del fe80:2::22/64 dev $rp22
+	ip address del 169.254.2.22/24 dev $rp22
+
+	ip address del 2001:db8:2::1/64 dev $rp21
+	ip address del 198.51.100.1/24 dev $rp21
+
+	ip nexthop del id 201
+	ip nexthop del id 202
+	ip nexthop del id 204
+	ip nexthop del id 205
+
+	ip link set dev $rp23 down
+	ip link set dev $rp22 down
+	ip link set dev $rp21 down
+
+	vrf_destroy "vrf-r2"
+}
+
+routing_nh_obj()
+{
+	ip nexthop add id 101 via 169.254.2.22 dev $rp12
+	ip nexthop add id 102 via 169.254.3.23 dev $rp13
+	ip nexthop add id 103 group 101/102 type resilient buckets 512 \
+		idle_timer 0
+	ip route add 198.51.100.0/24 vrf vrf-r1 nhid 103
+
+	ip nexthop add id 104 via fe80:2::22 dev $rp12
+	ip nexthop add id 105 via fe80:3::23 dev $rp13
+	ip nexthop add id 106 group 104/105 type resilient buckets 512 \
+		idle_timer 0
+	ip route add 2001:db8:2::/64 vrf vrf-r1 nhid 106
+
+	ip nexthop add id 201 via 169.254.2.12 dev $rp22
+	ip nexthop add id 202 via 169.254.3.13 dev $rp23
+	ip nexthop add id 203 group 201/202 type resilient buckets 512 \
+		idle_timer 0
+	ip route add 192.0.2.0/24 vrf vrf-r2 nhid 203
+
+	ip nexthop add id 204 via fe80:2::12 dev $rp22
+	ip nexthop add id 205 via fe80:3::13 dev $rp23
+	ip nexthop add id 206 group 204/205 type resilient buckets 512 \
+		idle_timer 0
+	ip route add 2001:db8:1::/64 vrf vrf-r2 nhid 206
+}
+
+multipath4_test()
+{
+	local desc="$1"
+	local weight_rp12=$2
+	local weight_rp13=$3
+	local t0_rp12 t0_rp13 t1_rp12 t1_rp13
+	local packets_rp12 packets_rp13
+
+	# Transmit multiple flows from h1 to h2 and make sure they are
+	# distributed between both multipath links (rp12 and rp13)
+	# according to the provided weights.
+	sysctl_set net.ipv4.fib_multipath_hash_policy 1
+
+	t0_rp12=$(link_stats_tx_packets_get $rp12)
+	t0_rp13=$(link_stats_tx_packets_get $rp13)
+
+	ip vrf exec vrf-h1 $MZ $h1 -q -p 64 -A 192.0.2.2 -B 198.51.100.2 \
+		-d 1msec -t udp "sp=1024,dp=0-32768"
+
+	t1_rp12=$(link_stats_tx_packets_get $rp12)
+	t1_rp13=$(link_stats_tx_packets_get $rp13)
+
+	let "packets_rp12 = $t1_rp12 - $t0_rp12"
+	let "packets_rp13 = $t1_rp13 - $t0_rp13"
+	multipath_eval "$desc" $weight_rp12 $weight_rp13 $packets_rp12 $packets_rp13
+
+	# Restore settings.
+	sysctl_restore net.ipv4.fib_multipath_hash_policy
+}
+
+multipath6_l4_test()
+{
+	local desc="$1"
+	local weight_rp12=$2
+	local weight_rp13=$3
+	local t0_rp12 t0_rp13 t1_rp12 t1_rp13
+	local packets_rp12 packets_rp13
+
+	# Transmit multiple flows from h1 to h2 and make sure they are
+	# distributed between both multipath links (rp12 and rp13)
+	# according to the provided weights.
+	sysctl_set net.ipv6.fib_multipath_hash_policy 1
+
+	t0_rp12=$(link_stats_tx_packets_get $rp12)
+	t0_rp13=$(link_stats_tx_packets_get $rp13)
+
+	$MZ $h1 -6 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+		-d 1msec -t udp "sp=1024,dp=0-32768"
+
+	t1_rp12=$(link_stats_tx_packets_get $rp12)
+	t1_rp13=$(link_stats_tx_packets_get $rp13)
+
+	let "packets_rp12 = $t1_rp12 - $t0_rp12"
+	let "packets_rp13 = $t1_rp13 - $t0_rp13"
+	multipath_eval "$desc" $weight_rp12 $weight_rp13 $packets_rp12 $packets_rp13
+
+	sysctl_restore net.ipv6.fib_multipath_hash_policy
+}
+
+multipath_test()
+{
+	# Without an idle timer, weight replacement should happen immediately.
+	log_info "Running multipath tests without an idle timer"
+	ip nexthop replace id 103 group 101/102 type resilient idle_timer 0
+	ip nexthop replace id 106 group 104/105 type resilient idle_timer 0
+
+	log_info "Running IPv4 multipath tests"
+	ip nexthop replace id 103 group 101,1/102,1 type resilient
+	multipath4_test "ECMP" 1 1
+	ip nexthop replace id 103 group 101,2/102,1 type resilient
+	multipath4_test "Weighted MP 2:1" 2 1
+	ip nexthop replace id 103 group 101,11/102,45 type resilient
+	multipath4_test "Weighted MP 11:45" 11 45
+
+	ip nexthop replace id 103 group 101,1/102,1 type resilient
+
+	log_info "Running IPv6 L4 hash multipath tests"
+	ip nexthop replace id 106 group 104,1/105,1 type resilient
+	multipath6_l4_test "ECMP" 1 1
+	ip nexthop replace id 106 group 104,2/105,1 type resilient
+	multipath6_l4_test "Weighted MP 2:1" 2 1
+	ip nexthop replace id 106 group 104,11/105,45 type resilient
+	multipath6_l4_test "Weighted MP 11:45" 11 45
+
+	ip nexthop replace id 106 group 104,1/105,1 type resilient
+
+	# With an idle timer, weight replacement should not happen, so the
+	# expected ratio should always be the initial one (1:1).
+	log_info "Running multipath tests with an idle timer of 120 seconds"
+	ip nexthop replace id 103 group 101/102 type resilient idle_timer 120
+	ip nexthop replace id 106 group 104/105 type resilient idle_timer 120
+
+	log_info "Running IPv4 multipath tests"
+	ip nexthop replace id 103 group 101,1/102,1 type resilient
+	multipath4_test "ECMP" 1 1
+	ip nexthop replace id 103 group 101,2/102,1 type resilient
+	multipath4_test "Weighted MP 2:1" 1 1
+	ip nexthop replace id 103 group 101,11/102,45 type resilient
+	multipath4_test "Weighted MP 11:45" 1 1
+
+	ip nexthop replace id 103 group 101,1/102,1 type resilient
+
+	log_info "Running IPv6 L4 hash multipath tests"
+	ip nexthop replace id 106 group 104,1/105,1 type resilient
+	multipath6_l4_test "ECMP" 1 1
+	ip nexthop replace id 106 group 104,2/105,1 type resilient
+	multipath6_l4_test "Weighted MP 2:1" 1 1
+	ip nexthop replace id 106 group 104,11/105,45 type resilient
+	multipath6_l4_test "Weighted MP 11:45" 1 1
+
+	ip nexthop replace id 106 group 104,1/105,1 type resilient
+
+	# With a short idle timer and enough idle time, weight replacement
+	# should happen.
+	log_info "Running multipath tests with an idle timer of 5 seconds"
+	ip nexthop replace id 103 group 101/102 type resilient idle_timer 5
+	ip nexthop replace id 106 group 104/105 type resilient idle_timer 5
+
+	log_info "Running IPv4 multipath tests"
+	sleep 10
+	ip nexthop replace id 103 group 101,1/102,1 type resilient
+	multipath4_test "ECMP" 1 1
+	sleep 10
+	ip nexthop replace id 103 group 101,2/102,1 type resilient
+	multipath4_test "Weighted MP 2:1" 2 1
+	sleep 10
+	ip nexthop replace id 103 group 101,11/102,45 type resilient
+	multipath4_test "Weighted MP 11:45" 11 45
+
+	ip nexthop replace id 103 group 101,1/102,1 type resilient
+
+	log_info "Running IPv6 L4 hash multipath tests"
+	sleep 10
+	ip nexthop replace id 106 group 104,1/105,1 type resilient
+	multipath6_l4_test "ECMP" 1 1
+	sleep 10
+	ip nexthop replace id 106 group 104,2/105,1 type resilient
+	multipath6_l4_test "Weighted MP 2:1" 2 1
+	sleep 10
+	ip nexthop replace id 106 group 104,11/105,45 type resilient
+	multipath6_l4_test "Weighted MP 11:45" 11 45
+
+	ip nexthop replace id 106 group 104,1/105,1 type resilient
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	rp11=${NETIFS[p2]}
+
+	rp12=${NETIFS[p3]}
+	rp22=${NETIFS[p4]}
+
+	rp13=${NETIFS[p5]}
+	rp23=${NETIFS[p6]}
+
+	rp21=${NETIFS[p7]}
+	h2=${NETIFS[p8]}
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+
+	router1_create
+	router2_create
+
+	forwarding_enable
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	forwarding_restore
+
+	router2_destroy
+	router1_destroy
+
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+ping_ipv4()
+{
+	ping_test $h1 198.51.100.2
+}
+
+ping_ipv6()
+{
+	ping6_test $h1 2001:db8:2::2
+}
+
+ip nexthop ls >/dev/null 2>&1
+if [ $? -ne 0 ]; then
+	echo "Nexthop objects not supported; skipping tests"
+	exit 0
+fi
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+routing_nh_obj
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.26.2

