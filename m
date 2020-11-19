Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2AF72B9345
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbgKSNJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:09:56 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:42899 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgKSNJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 08:09:38 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 33C9DEB1;
        Thu, 19 Nov 2020 08:09:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 19 Nov 2020 08:09:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=WNX4igScFEa6maVjRjg4+tq/OrFlglC+Ou0Xx72LDWg=; b=BYMDu+/b
        XnJgYX92WMdR2fI6M51TmqUFVmNcim4EVOOmsue4G4MJ76DT2egE6p9GKuQx2p6b
        DI1RQpc+iluXkN60teX5Qp+QVYb6KoMqYCCyp29yc2iW5BdjI/LFTS9UtMtA8DdL
        JeodhA99apdKQvJQyy1n7csTW2mtXLaDyJPSCDPHAZAUa84R7OKebduxgeg83xqQ
        EUNgMuIlVX5cpOJNiyMHOQ7bYs/k7k0fAzR9TUJ+LQquJ6FVvk6ZTovN2NztDv6k
        LdJpvKgM/sfcpsjX0XTuikdsSAx9j5InvbEZ6esJYbuDCjQEOz2l5qjPtSakb6Cb
        PGf1u8nUTTV57g==
X-ME-Sender: <xms:kG62X6DYfukKCw35Vq0UYrIPlChiqOq3xwva2LCY8aQ79SuL6-vsTA>
    <xme:kG62X0gYGB3Bv4Zb1kL8OgpqMdWlWHdogGJtgHnrvv0OcUZE__AHGeGHvg-edVQlF
    mUnNjAxJQO4l_s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefjedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:kG62X9le09Itf3JuevC5vmzEVaQUuRRvT_-T-zfZx_jgt5gNaA9LNg>
    <xmx:kG62X4zEJY7HHd1pm6D0lvdNEhxH8TrHt5-_WbCzZaWcB_i0z5p7mg>
    <xmx:kG62X_Q7_klG-Vb23497bOPK9kQCzr56zbFQ04QiwqemOwBk0duz0g>
    <xmx:kG62X5exeyv6VDhN-jhgc_-BF9l7vz2MWO-ncAnVBfYCqGDtByv1vA>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id CDE7E3280067;
        Thu, 19 Nov 2020 08:09:34 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/8] selftests: forwarding: Add device-only nexthop test
Date:   Thu, 19 Nov 2020 15:08:47 +0200
Message-Id: <20201119130848.407918-8-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201119130848.407918-1-idosch@idosch.org>
References: <20201119130848.407918-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

In a similar fashion to router_multipath.sh and its nexthop objects
version router_mpath_nh.sh, create a nexthop objects version of
router.sh.

It reuses the same topology, but uses device-only nexthop objects
instead of legacy ones.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/router_nh.sh     | 160 ++++++++++++++++++
 1 file changed, 160 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/router_nh.sh

diff --git a/tools/testing/selftests/net/forwarding/router_nh.sh b/tools/testing/selftests/net/forwarding/router_nh.sh
new file mode 100755
index 000000000000..f3a53738bdcc
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/router_nh.sh
@@ -0,0 +1,160 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="
+	ping_ipv4
+	ping_ipv6
+"
+
+NUM_NETIFS=4
+source lib.sh
+source tc_common.sh
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
+router_create()
+{
+	ip link set dev $rp1 up
+	ip link set dev $rp2 up
+
+	tc qdisc add dev $rp2 clsact
+
+	ip address add 192.0.2.1/24 dev $rp1
+	ip address add 2001:db8:1::1/64 dev $rp1
+
+	ip address add 198.51.100.1/24 dev $rp2
+	ip address add 2001:db8:2::1/64 dev $rp2
+}
+
+router_destroy()
+{
+	ip address del 2001:db8:2::1/64 dev $rp2
+	ip address del 198.51.100.1/24 dev $rp2
+
+	ip address del 2001:db8:1::1/64 dev $rp1
+	ip address del 192.0.2.1/24 dev $rp1
+
+	tc qdisc del dev $rp2 clsact
+
+	ip link set dev $rp2 down
+	ip link set dev $rp1 down
+}
+
+routing_nh_obj()
+{
+	# Create the nexthops as AF_INET6, so that IPv4 and IPv6 routes could
+	# use them.
+	ip -6 nexthop add id 101 dev $rp1
+	ip -6 nexthop add id 102 dev $rp2
+
+	ip route replace 192.0.2.0/24 nhid 101
+	ip route replace 2001:db8:1::/64 nhid 101
+	ip route replace 198.51.100.0/24 nhid 102
+	ip route replace 2001:db8:2::/64 nhid 102
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	rp1=${NETIFS[p2]}
+
+	rp2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	rp1mac=$(mac_get $rp1)
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+
+	router_create
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
+	router_destroy
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
2.28.0

