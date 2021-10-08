Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1839E426B89
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 15:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242553AbhJHNPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 09:15:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38415 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241603AbhJHNPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 09:15:09 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 686915C00E0;
        Fri,  8 Oct 2021 09:13:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 08 Oct 2021 09:13:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=soEP5mkE0Em8l/+Ngs1e9t4AcV/HT1ajpHUZweHFgWk=; b=RF1rrelR
        yYkkJkBbs+C2124DF4NOCGg4wXCywoGqMCTp9PFKS95n6A+zOxRdrawc9Br0UYVA
        zzRcsYwRJloWy8fl3nopQFgeVjiYytPb/mF3idfy83FYSeCwCUNoyZKdRGPv82Nu
        DZwGgCTBmygaZsEvd1VJsJH+DVvqr5nsr7Jk5cezDu1QmmLGirQDKJfL/AMMegYz
        SPLkNfD2efvAVN+NjLh/VjxrYAhiql1gXDEvcIIQaRoJpaRxxnbrPMbazYhQN1ch
        lJb2jKE4bQ3FxBxiilrA8nmb+MfZuihSkzV5PGDMuWwpu+6OXDMx1pKXeUd8SxS+
        ca83gwHia2M4vg==
X-ME-Sender: <xms:6kNgYdktt2MSBTNJAm33iPSKoP_1J4_6NPiZxlBCGrPjK0Rp_AEnBg>
    <xme:6kNgYY2XMcK8dCuGZ4MDn05RLu7ql0nPR6xublR7XCfNJEvIeP45cOKuaFK5rS6wR
    BqZN-xPt-u92fc>
X-ME-Received: <xmr:6kNgYTqNojCo0RJZZkww0rSewLpTqHeRzDAa4wNHDqDdCOAhXpVhFI3KmMHJYD08fTbGamXI5IFnRFGunVjFFO7fia2N24vK3f30qNbp0KyCWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddttddgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:6kNgYdmpc4IzpFlFBj6D4NltQdiidZNZeV_LEe_tO18PkB-3crj3gg>
    <xmx:6kNgYb0LKHRvlL6r5b1dYNg6rq1pvejmapbiCWlBysALjtjwNm_SLg>
    <xmx:6kNgYctpu6hXNv4zaWPmPYpTlw0omCI3Z74xYstBr8gVP0qTOZDBEw>
    <xmx:6kNgYWSXjs7abb2CnzPowOf-Ehf0iB2hu4pv4oOEOXu1WSM7_WRTWg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Oct 2021 09:13:12 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/8] selftests: forwarding: Add IPv6 GRE hierarchical tests
Date:   Fri,  8 Oct 2021 16:12:37 +0300
Message-Id: <20211008131241.85038-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008131241.85038-1-idosch@idosch.org>
References: <20211008131241.85038-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add tests that check IPv6-in-IPv6, IPv4-in-IPv6 and MTU change of GRE
tunnel. The tests use hierarchical model - the tunnel is bound to a device
in a different VRF.

These tests can be run with TC_FLAG=skip_sw, so then they will verify
that packets go through hardware as part of enacp and decap phases.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/ip6gre_hier.sh   |  65 +++++++
 .../net/forwarding/ip6gre_hier_key.sh         |  65 +++++++
 .../net/forwarding/ip6gre_hier_keys.sh        |  65 +++++++
 .../selftests/net/forwarding/ip6gre_lib.sh    | 170 +++++++++++++++++-
 4 files changed, 364 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_hier.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_hier_key.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_hier_keys.sh

diff --git a/tools/testing/selftests/net/forwarding/ip6gre_hier.sh b/tools/testing/selftests/net/forwarding/ip6gre_hier.sh
new file mode 100755
index 000000000000..83b55c30a5c3
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ip6gre_hier.sh
@@ -0,0 +1,65 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test IP-in-IP GRE tunnels without key.
+# This test uses hierarchical topology for IP tunneling tests. See
+# ip6gre_lib.sh for more details.
+
+ALL_TESTS="
+	gre_hier
+	gre_mtu_change
+"
+
+NUM_NETIFS=6
+source lib.sh
+source ip6gre_lib.sh
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
+	forwarding_enable
+	vrf_prepare
+	h1_create
+	h2_create
+	sw1_hierarchical_create $ol1 $ul1
+	sw2_hierarchical_create $ol2 $ul2
+}
+
+gre_hier()
+{
+	test_traffic_ip4ip6 "GRE hierarchical IPv4-in-IPv6"
+	test_traffic_ip6ip6 "GRE hierarchical IPv6-in-IPv6"
+}
+
+gre_mtu_change()
+{
+	test_mtu_change gre
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	sw2_hierarchical_destroy $ol2 $ul2
+	sw1_hierarchical_destroy $ol1 $ul1
+	h2_destroy
+	h1_destroy
+	vrf_cleanup
+	forwarding_restore
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/ip6gre_hier_key.sh b/tools/testing/selftests/net/forwarding/ip6gre_hier_key.sh
new file mode 100755
index 000000000000..256607916d92
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ip6gre_hier_key.sh
@@ -0,0 +1,65 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test IP-in-IP GRE tunnels without key.
+# This test uses hierarchical topology for IP tunneling tests. See
+# ip6gre_lib.sh for more details.
+
+ALL_TESTS="
+	gre_hier
+	gre_mtu_change
+"
+
+NUM_NETIFS=6
+source lib.sh
+source ip6gre_lib.sh
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
+	forwarding_enable
+	vrf_prepare
+	h1_create
+	h2_create
+	sw1_hierarchical_create $ol1 $ul1 key 22
+	sw2_hierarchical_create $ol2 $ul2 key 22
+}
+
+gre_hier()
+{
+	test_traffic_ip4ip6 "GRE hierarchical IPv4-in-IPv6 with key"
+	test_traffic_ip6ip6 "GRE hierarchical IPv6-in-IPv6 with key"
+}
+
+gre_mtu_change()
+{
+	test_mtu_change gre
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	sw2_hierarchical_destroy $ol2 $ul2
+	sw1_hierarchical_destroy $ol1 $ul1
+	h2_destroy
+	h1_destroy
+	vrf_cleanup
+	forwarding_restore
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/ip6gre_hier_keys.sh b/tools/testing/selftests/net/forwarding/ip6gre_hier_keys.sh
new file mode 100755
index 000000000000..ad1bcd6334a8
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ip6gre_hier_keys.sh
@@ -0,0 +1,65 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test IP-in-IP GRE tunnels without key.
+# This test uses hierarchical topology for IP tunneling tests. See
+# ip6gre_lib.sh for more details.
+
+ALL_TESTS="
+	gre_hier
+	gre_mtu_change
+"
+
+NUM_NETIFS=6
+source lib.sh
+source ip6gre_lib.sh
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
+	forwarding_enable
+	vrf_prepare
+	h1_create
+	h2_create
+	sw1_hierarchical_create $ol1 $ul1 ikey 111 okey 222
+	sw2_hierarchical_create $ol2 $ul2 ikey 222 okey 111
+}
+
+gre_hier()
+{
+	test_traffic_ip4ip6 "GRE hierarchical IPv4-in-IPv6 with ikey/okey"
+	test_traffic_ip6ip6 "GRE hierarchical IPv6-in-IPv6 with ikey/okey"
+}
+
+gre_mtu_change()
+{
+	test_mtu_change gre
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	sw2_hierarchical_destroy $ol2 $ul2
+	sw1_hierarchical_destroy $ol1 $ul1
+	h2_destroy
+	h1_destroy
+	vrf_cleanup
+	forwarding_restore
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/ip6gre_lib.sh b/tools/testing/selftests/net/forwarding/ip6gre_lib.sh
index 2a5b2126b674..58a3597037b1 100644
--- a/tools/testing/selftests/net/forwarding/ip6gre_lib.sh
+++ b/tools/testing/selftests/net/forwarding/ip6gre_lib.sh
@@ -2,7 +2,7 @@
 #!/bin/bash
 
 # Handles creation and destruction of IP-in-IP or GRE tunnels over the given
-# topology.
+# topology. Supports both flat and hierarchical models.
 #
 # Flat Model:
 # Overlay and underlay share the same VRF.
@@ -63,6 +63,91 @@
 # |    203.0.113.1/24              |
 # |    2001:db8:2::1/64            |
 # +--------------------------------+
+#
+# Hierarchical model:
+# The tunnel is bound to a device in a different VRF
+#
+# +--------------------------------+
+# | H1                             |
+# |                     $h1 +      |
+# |        198.51.100.1/24  |      |
+# |        2001:db8:1::1/64 |      |
+# +-------------------------|------+
+#                           |
+# +-------------------------|-------------------+
+# | SW1                     |                   |
+# | +-----------------------|-----------------+ |
+# | |                  $ol1 +                 | |
+# | |      198.51.100.2/24                    | |
+# | |      2001:db8:1::2/64                   | |
+# | |                                         | |
+# | |              + g1a (ip6gre)             | |
+# | |                loc=2001:db8:3::1        | |
+# | |                rem=2001:db8:3::2        | |
+# | |                tos=inherit              | |
+# | |                    ^                    | |
+# | |   VRF v$ol1        |                    | |
+# | +--------------------|--------------------+ |
+# |                      |                      |
+# | +--------------------|--------------------+ |
+# | |   VRF v$ul1        |                    | |
+# | |                    |                    | |
+# | |                    v                    | |
+# | |             dummy1 +                    | |
+# | |       2001:db8:3::1/64                  | |
+# | |         .-----------'                   | |
+# | |         |                               | |
+# | |         v                               | |
+# | |         + $ul1.111 (vlan)               | |
+# | |         | 2001:db8:10::1/64             | |
+# | |         \                               | |
+# | |          \__________                    | |
+# | |                     |                   | |
+# | |                     + $ul1              | |
+# | +---------------------|-------------------+ |
+# +-----------------------|---------------------+
+#                         |
+# +-----------------------|---------------------+
+# | SW2                   |                     |
+# | +---------------------|-------------------+ |
+# | |                     + $ul2              | |
+# | |                _____|                   | |
+# | |               /                         | |
+# | |              /                          | |
+# | |              | $ul2.111 (vlan)          | |
+# | |              + 2001:db8:10::2/64        | |
+# | |              ^                          | |
+# | |              |                          | |
+# | |              '------.                   | |
+# | |              dummy2 +                   | |
+# | |              2001:db8:3::2/64           | |
+# | |                     ^                   | |
+# | |                     |                   | |
+# | |                     |                   | |
+# | | VRF v$ul2           |                   | |
+# | +---------------------|-------------------+ |
+# |                       |                     |
+# | +---------------------|-------------------+ |
+# | | VRF v$ol2           |                   | |
+# | |                     |                   | |
+# | |                     v                   | |
+# | |        g2a (ip6gre) +                   | |
+# | |        loc=2001:db8:3::2                | |
+# | |        rem=2001:db8:3::1                | |
+# | |        tos=inherit                      | |
+# | |                                         | |
+# | |                $ol2 +                   | |
+# | |    203.0.113.2/24   |                   | |
+# | |    2001:db8:2::2/64 |                   | |
+# | +---------------------|-------------------+ |
+# +-----------------------|---------------------+
+#                         |
+# +-----------------------|--------+
+# | H2                    |        |
+# |                   $h2 +        |
+# |      203.0.113.1/24            |
+# |      2001:db8:2::1/64          |
+# +--------------------------------+
 
 source lib.sh
 source tc_common.sh
@@ -172,6 +257,89 @@ sw2_flat_destroy()
 	simple_if_fini $ol2 203.0.113.2/24 2001:db8:2::2/64
 }
 
+sw1_hierarchical_create()
+{
+	local ol1=$1; shift
+	local ul1=$1; shift
+
+	simple_if_init $ol1 198.51.100.2/24 2001:db8:1::2/64
+	simple_if_init $ul1
+	ip link add name dummy1 type dummy
+	__simple_if_init dummy1 v$ul1 2001:db8:3::1/64
+
+	vlan_create $ul1 111 v$ul1 2001:db8:10::1/64
+	tunnel_create g1a ip6gre 2001:db8:3::1 2001:db8:3::2 tos inherit \
+		ttl inherit dev dummy1 "$@"
+	ip link set dev g1a master v$ol1
+
+	ip -6 route add vrf v$ul1 2001:db8:3::2/128 via 2001:db8:10::2
+	ip route add vrf v$ol1 203.0.113.0/24 dev g1a
+	ip -6 route add vrf v$ol1 2001:db8:2::/64 dev g1a
+}
+
+sw1_hierarchical_destroy()
+{
+	local ol1=$1; shift
+	local ul1=$1; shift
+
+	ip -6 route del vrf v$ol1 2001:db8:2::/64
+	ip route del vrf v$ol1 203.0.113.0/24
+	ip -6 route del vrf v$ul1 2001:db8:3::2/128
+
+	tunnel_destroy g1a
+	vlan_destroy $ul1 111
+
+	__simple_if_fini dummy1 2001:db8:3::1/64
+	ip link del dev dummy1
+
+	simple_if_fini $ul1
+	simple_if_fini $ol1 198.51.100.2/24 2001:db8:1::2/64
+}
+
+sw2_hierarchical_create()
+{
+	local ol2=$1; shift
+	local ul2=$1; shift
+
+	simple_if_init $ol2 203.0.113.2/24 2001:db8:2::2/64
+	simple_if_init $ul2
+
+	ip link add name dummy2 type dummy
+	__simple_if_init dummy2 v$ul2 2001:db8:3::2/64
+
+	vlan_create $ul2 111 v$ul2 2001:db8:10::2/64
+	tunnel_create g2a ip6gre 2001:db8:3::2 2001:db8:3::1 tos inherit \
+		ttl inherit dev dummy2 "$@"
+	ip link set dev g2a master v$ol2
+
+	# Replace neighbor to avoid 1 dropped packet due to "unresolved neigh"
+	ip neigh replace dev $ol2 203.0.113.1 lladdr $(mac_get $h2)
+	ip -6 neigh replace dev $ol2 2001:db8:2::1 lladdr $(mac_get $h2)
+
+	ip -6 route add vrf v$ul2 2001:db8:3::1/128 via 2001:db8:10::1
+	ip route add vrf v$ol2 198.51.100.0/24 dev g2a
+	ip -6 route add vrf v$ol2 2001:db8:1::/64 dev g2a
+}
+
+sw2_hierarchical_destroy()
+{
+	local ol2=$1; shift
+	local ul2=$1; shift
+
+	ip -6 route del vrf v$ol2 2001:db8:2::/64
+	ip route del vrf v$ol2 198.51.100.0/24
+	ip -6 route del vrf v$ul2 2001:db8:3::1/128
+
+	tunnel_destroy g2a
+	vlan_destroy $ul2 111
+
+	__simple_if_fini dummy2 2001:db8:3::2/64
+	ip link del dev dummy2
+
+	simple_if_fini $ul2
+	simple_if_fini $ol2 203.0.113.2/24 2001:db8:2::2/64
+}
+
 test_traffic_ip4ip6()
 {
 	RET=0
-- 
2.31.1

