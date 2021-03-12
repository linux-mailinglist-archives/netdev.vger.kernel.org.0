Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153AD3393EF
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbhCLQwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:52:23 -0500
Received: from mail-mw2nam12on2086.outbound.protection.outlook.com ([40.107.244.86]:10961
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231519AbhCLQvt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 11:51:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndSlVYHc902oWvXRtRouerxs3Bn1SSYUTg6VYTA8WmzuTKu+8zzp4TaFTr+OCCmbRhCw5fXmIC/jA/+QXi8Xm99T90XwuS9jQYwgemT0E1Uy4Go0mM+IY1NVs5b0flZELd3uiSBrAYGQYLubsKlUoFaWqVgNDutT6QdP/J0NLuqz3N5VyWxFRQ+0BWTb17X8ZhHTE1ZDlrfZ7j89H1a+BoZ7XPOvq7t6UvrvdZ27nnxDYLaBNjmG2SY30SNJO3OOVBMV9V8nXoX9azlGz/0FMumpkZFmxosa8eMiwCXi/eVx5A8Fvn542tQX4DrX4gLKu+pRrpsNKPCuqOL6wrteHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NkUcFnf44rGycw34vXvF9ji7xQNYh6/LIC55T22mLm0=;
 b=gje5fz0yTJhjlbIKHl+5G5UZlk44V5oZm9x1hG42XBQxcePfhhFhUfBt1EX/K0w/k5tzQdr08bus7TcHwB3IusICJ4i1BNL7qxx1NYgmWcs+jj90c0MyYrTqYYAD3wdg5mzQNN+68pUjMz3Y8RvXce5jnk+1AvtmFhoXGSc0iC6wFLgBUVdBB3RDtBRBp2kzZXCw0BtrfyQFrFXQBu4rr4BbuXFS7XSf9TiYycoZnVjdldJXusYFyCRJJGNRGom5JXFm3NaVZSCuk4zBWC/wNIKnyjzqlredXVe2/an1cg9Ck6hf7NBU4MPXNXayNC7e00YTvlJQNyUp/apydNVUOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NkUcFnf44rGycw34vXvF9ji7xQNYh6/LIC55T22mLm0=;
 b=c3YmKYtBb1Z0ObEW2khAfq/UbquIQB3/4IU2zaswHplGC1rop1Bumg4EktqWK0Zl6E4B+cXBknoCvx+WRRRghqWR2FRPk6RDle22tdnq9EjDxMSR6XYutOlkqp7cajO2M9s/i684JRwPnwRlGW7qOGiTHW5Vjwn/dQqR89PGph+SZ8mzEaivZnJSLla+8u69VLrDqVofvAeFiM7tEynQw8TMOnCBXbEhnT4VtiGgORX27+SSADTuxxCoNKihGIPPmsD/X6DJRJEtUEe0o4qjrcoWnx+xfMbEepuPyIx2UvpRR6fRTcz9AkZU1OgGqNF7Wdx7HLFh31T8QZ9rfX2k/Q==
Received: from DM3PR12CA0053.namprd12.prod.outlook.com (2603:10b6:0:56::21) by
 BN7PR12MB2675.namprd12.prod.outlook.com (2603:10b6:408:2f::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.27; Fri, 12 Mar 2021 16:51:42 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:56:cafe::a8) by DM3PR12CA0053.outlook.office365.com
 (2603:10b6:0:56::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Fri, 12 Mar 2021 16:51:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 16:51:41 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 16:51:38 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 09/10] selftests: forwarding: Add resilient multipath tunneling nexthop test
Date:   Fri, 12 Mar 2021 17:50:25 +0100
Message-ID: <a9945581de7f3bb7b5d4c4a33e64371a9c8d8f17.1615563035.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 80971995-4ae6-482b-7e2a-08d8e5771cab
X-MS-TrafficTypeDiagnostic: BN7PR12MB2675:
X-Microsoft-Antispam-PRVS: <BN7PR12MB26751AA0011459F88009F447D66F9@BN7PR12MB2675.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:635;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rxsQz0cqfzkzyCKKXXvRyVi/kulun/f2T9bcwTaVLzFSchWnnTAoHxfruSdwXZ/MXciz4c31uZ50oH1QrXuWnCGK/IsvlX68fZ+3En8oMRSlaEl/QZYeAsVY6/IU2glJHz4oI2Nkk52WcjYCtaDYg/IKfP31d8yGLdUbuAJAA0BIY9n7W3nYuN1CPXe2A+XSuZRqu/2Sd4Sb39I2rRbxQNX8b9x+OS9mpVMK8pjLl5WVEnZuo7KB9okhJkixknYqWTp+H1GCBQM24ITtaGrF95EMAn6mrP9g++eHTmpKOLw33WjjXtnXop045C9zcBOq0FPtfteOR4NFYhikjtpc6vtrnn5W7RAbUH8ZdHy6Nl9Kva/jbZZg+f5Tq2im5sC3jQX0mLBAkgsaTJxG3RgGu+7L90jFVMUDx16BmLEvIGlk+UyWF+qd3hjmf7w0aunbT10OAx8BrdGREF/zcoWuuuiP6spAjTEF9JaguT1VEjEv9W0IU6g15y+cJ/H+AAaLc1Ha7cUPOKDdBRMHzb4zdcBy8pJV1wYJO2A/l2++J7Hu5lOZuOwUjHbZRAdBvhYfZmRW8fjV1BZwlH1v0oAqeCD1GWJ4/oGRlPAwDYG0+38ArijiKWji2cPedFdRVrZ/FiN5zIXqGmof0H6EMy/C/W6/iFNu5tnD6nxF5WElPm2FYzPEjw0Mid3RoSATe3gR
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39860400002)(36840700001)(46966006)(356005)(426003)(2616005)(83380400001)(36860700001)(4326008)(8676002)(186003)(107886003)(8936002)(6666004)(34020700004)(82310400003)(82740400003)(47076005)(7636003)(54906003)(16526019)(5660300002)(478600001)(36756003)(336012)(2906002)(86362001)(70586007)(70206006)(6916009)(316002)(26005)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 16:51:41.6295
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80971995-4ae6-482b-7e2a-08d8e5771cab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2675
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add a resilient nexthop objects version of gre_multipath_nh.sh. Test
that both IPv4 and IPv6 overlays work with resilient nexthop groups
where the nexthops are two GRE tunnels.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../net/forwarding/gre_multipath_nh_res.sh    | 361 ++++++++++++++++++
 1 file changed, 361 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/gre_multipath_nh_res.sh

diff --git a/tools/testing/selftests/net/forwarding/gre_multipath_nh_res.sh b/tools/testing/selftests/net/forwarding/gre_multipath_nh_res.sh
new file mode 100755
index 000000000000..088b65e64d66
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/gre_multipath_nh_res.sh
@@ -0,0 +1,361 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test traffic distribution when a wECMP route forwards traffic to two GRE
+# tunnels.
+#
+# +-------------------------+
+# | H1                      |
+# |               $h1 +     |
+# |      192.0.2.1/28 |     |
+# |  2001:db8:1::1/64 |     |
+# +-------------------|-----+
+#                     |
+# +-------------------|------------------------+
+# | SW1               |                        |
+# |              $ol1 +                        |
+# |      192.0.2.2/28                          |
+# |  2001:db8:1::2/64                          |
+# |                                            |
+# |  + g1a (gre)          + g1b (gre)          |
+# |    loc=192.0.2.65       loc=192.0.2.81     |
+# |    rem=192.0.2.66 --.   rem=192.0.2.82 --. |
+# |    tos=inherit      |   tos=inherit      | |
+# |  .------------------'                    | |
+# |  |                    .------------------' |
+# |  v                    v                    |
+# |  + $ul1.111 (vlan)    + $ul1.222 (vlan)    |
+# |  | 192.0.2.129/28     | 192.0.2.145/28     |
+# |   \                  /                     |
+# |    \________________/                      |
+# |            |                               |
+# |            + $ul1                          |
+# +------------|-------------------------------+
+#              |
+# +------------|-------------------------------+
+# | SW2        + $ul2                          |
+# |     _______|________                       |
+# |    /                \                      |
+# |   /                  \                     |
+# |  + $ul2.111 (vlan)    + $ul2.222 (vlan)    |
+# |  ^ 192.0.2.130/28     ^ 192.0.2.146/28     |
+# |  |                    |                    |
+# |  |                    '------------------. |
+# |  '------------------.                    | |
+# |  + g2a (gre)        | + g2b (gre)        | |
+# |    loc=192.0.2.66   |   loc=192.0.2.82   | |
+# |    rem=192.0.2.65 --'   rem=192.0.2.81 --' |
+# |    tos=inherit          tos=inherit        |
+# |                                            |
+# |              $ol2 +                        |
+# |     192.0.2.17/28 |                        |
+# |  2001:db8:2::1/64 |                        |
+# +-------------------|------------------------+
+#                     |
+# +-------------------|-----+
+# | H2                |     |
+# |               $h2 +     |
+# |     192.0.2.18/28       |
+# |  2001:db8:2::2/64       |
+# +-------------------------+
+
+ALL_TESTS="
+	ping_ipv4
+	ping_ipv6
+	multipath_ipv4
+	multipath_ipv6
+	multipath_ipv6_l4
+"
+
+NUM_NETIFS=6
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/28 2001:db8:1::1/64
+	ip route add vrf v$h1 192.0.2.16/28 via 192.0.2.2
+	ip route add vrf v$h1 2001:db8:2::/64 via 2001:db8:1::2
+}
+
+h1_destroy()
+{
+	ip route del vrf v$h1 2001:db8:2::/64 via 2001:db8:1::2
+	ip route del vrf v$h1 192.0.2.16/28 via 192.0.2.2
+	simple_if_fini $h1 192.0.2.1/28
+}
+
+sw1_create()
+{
+	simple_if_init $ol1 192.0.2.2/28 2001:db8:1::2/64
+	__simple_if_init $ul1 v$ol1
+	vlan_create $ul1 111 v$ol1 192.0.2.129/28
+	vlan_create $ul1 222 v$ol1 192.0.2.145/28
+
+	tunnel_create g1a gre 192.0.2.65 192.0.2.66 tos inherit dev v$ol1
+	__simple_if_init g1a v$ol1 192.0.2.65/32
+	ip route add vrf v$ol1 192.0.2.66/32 via 192.0.2.130
+
+	tunnel_create g1b gre 192.0.2.81 192.0.2.82 tos inherit dev v$ol1
+	__simple_if_init g1b v$ol1 192.0.2.81/32
+	ip route add vrf v$ol1 192.0.2.82/32 via 192.0.2.146
+
+	ip -6 nexthop add id 101 dev g1a
+	ip -6 nexthop add id 102 dev g1b
+	ip nexthop add id 103 group 101/102 type resilient buckets 512 \
+		idle_timer 0
+
+	ip route add vrf v$ol1 192.0.2.16/28 nhid 103
+	ip route add vrf v$ol1 2001:db8:2::/64 nhid 103
+}
+
+sw1_destroy()
+{
+	ip route del vrf v$ol1 2001:db8:2::/64
+	ip route del vrf v$ol1 192.0.2.16/28
+
+	ip nexthop del id 103
+	ip -6 nexthop del id 102
+	ip -6 nexthop del id 101
+
+	ip route del vrf v$ol1 192.0.2.82/32 via 192.0.2.146
+	__simple_if_fini g1b 192.0.2.81/32
+	tunnel_destroy g1b
+
+	ip route del vrf v$ol1 192.0.2.66/32 via 192.0.2.130
+	__simple_if_fini g1a 192.0.2.65/32
+	tunnel_destroy g1a
+
+	vlan_destroy $ul1 222
+	vlan_destroy $ul1 111
+	__simple_if_fini $ul1
+	simple_if_fini $ol1 192.0.2.2/28 2001:db8:1::2/64
+}
+
+sw2_create()
+{
+	simple_if_init $ol2 192.0.2.17/28 2001:db8:2::1/64
+	__simple_if_init $ul2 v$ol2
+	vlan_create $ul2 111 v$ol2 192.0.2.130/28
+	vlan_create $ul2 222 v$ol2 192.0.2.146/28
+
+	tunnel_create g2a gre 192.0.2.66 192.0.2.65 tos inherit dev v$ol2
+	__simple_if_init g2a v$ol2 192.0.2.66/32
+	ip route add vrf v$ol2 192.0.2.65/32 via 192.0.2.129
+
+	tunnel_create g2b gre 192.0.2.82 192.0.2.81 tos inherit dev v$ol2
+	__simple_if_init g2b v$ol2 192.0.2.82/32
+	ip route add vrf v$ol2 192.0.2.81/32 via 192.0.2.145
+
+	ip -6 nexthop add id 201 dev g2a
+	ip -6 nexthop add id 202 dev g2b
+	ip nexthop add id 203 group 201/202 type resilient buckets 512 \
+		idle_timer 0
+
+	ip route add vrf v$ol2 192.0.2.0/28 nhid 203
+	ip route add vrf v$ol2 2001:db8:1::/64 nhid 203
+
+	tc qdisc add dev $ul2 clsact
+	tc filter add dev $ul2 ingress pref 111 prot 802.1Q \
+	   flower vlan_id 111 action pass
+	tc filter add dev $ul2 ingress pref 222 prot 802.1Q \
+	   flower vlan_id 222 action pass
+}
+
+sw2_destroy()
+{
+	tc qdisc del dev $ul2 clsact
+
+	ip route del vrf v$ol2 2001:db8:1::/64
+	ip route del vrf v$ol2 192.0.2.0/28
+
+	ip nexthop del id 203
+	ip -6 nexthop del id 202
+	ip -6 nexthop del id 201
+
+	ip route del vrf v$ol2 192.0.2.81/32 via 192.0.2.145
+	__simple_if_fini g2b 192.0.2.82/32
+	tunnel_destroy g2b
+
+	ip route del vrf v$ol2 192.0.2.65/32 via 192.0.2.129
+	__simple_if_fini g2a 192.0.2.66/32
+	tunnel_destroy g2a
+
+	vlan_destroy $ul2 222
+	vlan_destroy $ul2 111
+	__simple_if_fini $ul2
+	simple_if_fini $ol2 192.0.2.17/28 2001:db8:2::1/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.18/28 2001:db8:2::2/64
+	ip route add vrf v$h2 192.0.2.0/28 via 192.0.2.17
+	ip route add vrf v$h2 2001:db8:1::/64 via 2001:db8:2::1
+}
+
+h2_destroy()
+{
+	ip route del vrf v$h2 2001:db8:1::/64 via 2001:db8:2::1
+	ip route del vrf v$h2 192.0.2.0/28 via 192.0.2.17
+	simple_if_fini $h2 192.0.2.18/28 2001:db8:2::2/64
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	ol1=${NETIFS[p2]}
+
+	ul1=${NETIFS[p3]}
+	ul2=${NETIFS[p4]}
+
+	ol2=${NETIFS[p5]}
+	h2=${NETIFS[p6]}
+
+	vrf_prepare
+	h1_create
+	sw1_create
+	sw2_create
+	h2_create
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
+	h2_destroy
+	sw2_destroy
+	sw1_destroy
+	h1_destroy
+	vrf_cleanup
+}
+
+multipath4_test()
+{
+	local what=$1; shift
+	local weight1=$1; shift
+	local weight2=$1; shift
+
+	sysctl_set net.ipv4.fib_multipath_hash_policy 1
+	ip nexthop replace id 103 group 101,$weight1/102,$weight2 \
+		type resilient
+
+	local t0_111=$(tc_rule_stats_get $ul2 111 ingress)
+	local t0_222=$(tc_rule_stats_get $ul2 222 ingress)
+
+	ip vrf exec v$h1 \
+	   $MZ $h1 -q -p 64 -A 192.0.2.1 -B 192.0.2.18 \
+	       -d 1msec -t udp "sp=1024,dp=0-32768"
+
+	local t1_111=$(tc_rule_stats_get $ul2 111 ingress)
+	local t1_222=$(tc_rule_stats_get $ul2 222 ingress)
+
+	local d111=$((t1_111 - t0_111))
+	local d222=$((t1_222 - t0_222))
+	multipath_eval "$what" $weight1 $weight2 $d111 $d222
+
+	ip nexthop replace id 103 group 101/102 type resilient
+	sysctl_restore net.ipv4.fib_multipath_hash_policy
+}
+
+multipath6_test()
+{
+	local what=$1; shift
+	local weight1=$1; shift
+	local weight2=$1; shift
+
+	sysctl_set net.ipv6.fib_multipath_hash_policy 0
+	ip nexthop replace id 103 group 101,$weight1/102,$weight2 \
+		type resilient
+
+	local t0_111=$(tc_rule_stats_get $ul2 111 ingress)
+	local t0_222=$(tc_rule_stats_get $ul2 222 ingress)
+
+	# Generate 16384 echo requests, each with a random flow label.
+	for ((i=0; i < 16384; ++i)); do
+		ip vrf exec v$h1 $PING6 2001:db8:2::2 -F 0 -c 1 -q &> /dev/null
+	done
+
+	local t1_111=$(tc_rule_stats_get $ul2 111 ingress)
+	local t1_222=$(tc_rule_stats_get $ul2 222 ingress)
+
+	local d111=$((t1_111 - t0_111))
+	local d222=$((t1_222 - t0_222))
+	multipath_eval "$what" $weight1 $weight2 $d111 $d222
+
+	ip nexthop replace id 103 group 101/102 type resilient
+	sysctl_restore net.ipv6.fib_multipath_hash_policy
+}
+
+multipath6_l4_test()
+{
+	local what=$1; shift
+	local weight1=$1; shift
+	local weight2=$1; shift
+
+	sysctl_set net.ipv6.fib_multipath_hash_policy 1
+	ip nexthop replace id 103 group 101,$weight1/102,$weight2 \
+		type resilient
+
+	local t0_111=$(tc_rule_stats_get $ul2 111 ingress)
+	local t0_222=$(tc_rule_stats_get $ul2 222 ingress)
+
+	ip vrf exec v$h1 \
+		$MZ $h1 -6 -q -p 64 -A 2001:db8:1::1 -B 2001:db8:2::2 \
+		-d 1msec -t udp "sp=1024,dp=0-32768"
+
+	local t1_111=$(tc_rule_stats_get $ul2 111 ingress)
+	local t1_222=$(tc_rule_stats_get $ul2 222 ingress)
+
+	local d111=$((t1_111 - t0_111))
+	local d222=$((t1_222 - t0_222))
+	multipath_eval "$what" $weight1 $weight2 $d111 $d222
+
+	ip nexthop replace id 103 group 101/102 type resilient
+	sysctl_restore net.ipv6.fib_multipath_hash_policy
+}
+
+ping_ipv4()
+{
+	ping_test $h1 192.0.2.18
+}
+
+ping_ipv6()
+{
+	ping6_test $h1 2001:db8:2::2
+}
+
+multipath_ipv4()
+{
+	log_info "Running IPv4 multipath tests"
+	multipath4_test "ECMP" 1 1
+	multipath4_test "Weighted MP 2:1" 2 1
+	multipath4_test "Weighted MP 11:45" 11 45
+}
+
+multipath_ipv6()
+{
+	log_info "Running IPv6 multipath tests"
+	multipath6_test "ECMP" 1 1
+	multipath6_test "Weighted MP 2:1" 2 1
+	multipath6_test "Weighted MP 11:45" 11 45
+}
+
+multipath_ipv6_l4()
+{
+	log_info "Running IPv6 L4 hash multipath tests"
+	multipath6_l4_test "ECMP" 1 1
+	multipath6_l4_test "Weighted MP 2:1" 2 1
+	multipath6_l4_test "Weighted MP 11:45" 11 45
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
-- 
2.26.2

