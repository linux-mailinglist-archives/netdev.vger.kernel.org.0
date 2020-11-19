Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5452B9332
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbgKSNJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:09:34 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:33307 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727343AbgKSNJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 08:09:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 0C74AEB1;
        Thu, 19 Nov 2020 08:09:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 19 Nov 2020 08:09:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=wlp76OecGlNwRAoIglU61sAdgyzmDsKyDyt5OGfxwkY=; b=VjgL/Vs/
        LDTOkisQpntQo04idKFeOiQ40xfffH3nTlVBXKAylNLhU+bqI/z5Eb/YcGTOpeGw
        Tky+Hx2fWf1qTn03jbQNJ5lJKhkFAotbpea6O8Eic2pvZshTczTyUcV0lyGM+P0F
        xw9gDB3dz3FAN2dpaIOPRkcaHxdRGjaocz8xcEbxriRzSeu1Q9IZDV6nVZJj3KnK
        aMytBSPliJiNjEL03nh0hqgAdx/CFx7e8FzTrShhGF/bQAYr5NTAnzX5oW9W+Ijl
        2Cp3/BSp7A39vsDkFpSP4rm22is3W0UjqrttQJn3A7u3ZArtx4crOnC+lYW3eprh
        0VGUS9UUoiiHEQ==
X-ME-Sender: <xms:im62XwXXVPAbD-fArlAWLceCxfZMQf1vw5p1r_WMar4tQ9cq7jw2hg>
    <xme:im62X0kn4GO3kPxBNudvyUTS2EL2v9MfCjDQm2U9-wkvHmLuJKQ2T8QB_zXCpymqV
    EPZptRcIELUxK4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefjedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:im62X0aoaGbBgLHChn3GqYmwF2UXFqMnL9B3nKudK_f2rGeKXguv2Q>
    <xmx:im62X_X1KbskEzV7dnO1r9exG54inFvH5X0CmX7D7EfbNjLp8uJCgg>
    <xmx:im62X6mb99OPjaequqoF_CBuU6NlT5t8INKSQ9L2O75rFo_3tYYl4A>
    <xmx:im62X8hgL8THWJIogHz8w1OGTgFY-n-IsRhew7nHlb0O3HYm2drSNQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id C3C753280066;
        Thu, 19 Nov 2020 08:09:28 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/8] selftests: mlxsw: Add nexthop objects configuration tests
Date:   Thu, 19 Nov 2020 15:08:44 +0200
Message-Id: <20201119130848.407918-5-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201119130848.407918-1-idosch@idosch.org>
References: <20201119130848.407918-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that unsupported nexthop objects are rejected and that offload
indication is correctly set on: nexthop objects, nexthop group objects
and routes associated these objects.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  | 189 ++++++++++++++++++
 1 file changed, 189 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh b/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
index f4031002d5e9..5de47d72f8c9 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
@@ -29,6 +29,10 @@ ALL_TESTS="
 	bridge_extern_learn_test
 	neigh_offload_test
 	nexthop_offload_test
+	nexthop_obj_invalid_test
+	nexthop_obj_offload_test
+	nexthop_obj_group_offload_test
+	nexthop_obj_route_offload_test
 	devlink_reload_test
 "
 NUM_NETIFS=2
@@ -674,6 +678,191 @@ nexthop_offload_test()
 	sysctl_restore net.ipv6.conf.$swp2.keep_addr_on_down
 }
 
+nexthop_obj_invalid_test()
+{
+	# Test that invalid nexthop object configurations are rejected
+	RET=0
+
+	simple_if_init $swp1 192.0.2.1/24 2001:db8:1::1/64
+	simple_if_init $swp2 192.0.2.2/24 2001:db8:1::2/64
+	setup_wait
+
+	ip nexthop add id 1 via 192.0.2.3 fdb
+	check_fail $? "managed to configure an FDB nexthop when should not"
+
+	ip nexthop add id 1 encap mpls 200/300 via 192.0.2.3 dev $swp1
+	check_fail $? "managed to configure a nexthop with MPLS encap when should not"
+
+	ip nexthop add id 1 blackhole
+	check_fail $? "managed to configure a blackhole nexthop when should not"
+
+	ip nexthop add id 1 dev $swp1
+	ip nexthop add id 2 dev $swp1
+	ip nexthop add id 10 group 1/2
+	check_fail $? "managed to configure a nexthop group with device-only nexthops when should not"
+
+	log_test "nexthop objects - invalid configurations"
+
+	ip nexthop del id 2
+	ip nexthop del id 1
+
+	simple_if_fini $swp2 192.0.2.2/24 2001:db8:1::2/64
+	simple_if_fini $swp1 192.0.2.1/24 2001:db8:1::1/64
+}
+
+nexthop_obj_offload_test()
+{
+	# Test offload indication of nexthop objects
+	RET=0
+
+	simple_if_init $swp1 192.0.2.1/24 2001:db8:1::1/64
+	simple_if_init $swp2
+	setup_wait
+
+	ip nexthop add id 1 via 192.0.2.2 dev $swp1
+	ip neigh replace 192.0.2.2 lladdr 00:11:22:33:44:55 nud reachable \
+		dev $swp1
+
+	busywait "$TIMEOUT" wait_for_offload \
+		ip nexthop show id 1
+	check_err $? "nexthop not marked as offloaded when should"
+
+	ip neigh replace 192.0.2.2 nud failed dev $swp1
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip nexthop show id 1
+	check_err $? "nexthop marked as offloaded after setting neigh to failed state"
+
+	ip neigh replace 192.0.2.2 lladdr 00:11:22:33:44:55 nud reachable \
+		dev $swp1
+	busywait "$TIMEOUT" wait_for_offload \
+		ip nexthop show id 1
+	check_err $? "nexthop not marked as offloaded after neigh replace"
+
+	ip nexthop replace id 1 via 192.0.2.3 dev $swp1
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip nexthop show id 1
+	check_err $? "nexthop marked as offloaded after replacing to use an invalid address"
+
+	ip nexthop replace id 1 via 192.0.2.2 dev $swp1
+	busywait "$TIMEOUT" wait_for_offload \
+		ip nexthop show id 1
+	check_err $? "nexthop not marked as offloaded after replacing to use a valid address"
+
+	log_test "nexthop objects offload indication"
+
+	ip neigh del 192.0.2.2 dev $swp1
+	ip nexthop del id 1
+
+	simple_if_fini $swp2
+	simple_if_fini $swp1 192.0.2.1/24 2001:db8:1::1/64
+}
+
+nexthop_obj_group_offload_test()
+{
+	# Test offload indication of nexthop group objects
+	RET=0
+
+	simple_if_init $swp1 192.0.2.1/24 2001:db8:1::1/64
+	simple_if_init $swp2
+	setup_wait
+
+	ip nexthop add id 1 via 192.0.2.2 dev $swp1
+	ip nexthop add id 2 via 2001:db8:1::2 dev $swp1
+	ip nexthop add id 10 group 1/2
+	ip neigh replace 192.0.2.2 lladdr 00:11:22:33:44:55 nud reachable \
+		dev $swp1
+	ip neigh replace 192.0.2.3 lladdr 00:11:22:33:44:55 nud reachable \
+		dev $swp1
+	ip neigh replace 2001:db8:1::2 lladdr 00:11:22:33:44:55 nud reachable \
+		dev $swp1
+
+	busywait "$TIMEOUT" wait_for_offload \
+		ip nexthop show id 1
+	check_err $? "IPv4 nexthop not marked as offloaded when should"
+	busywait "$TIMEOUT" wait_for_offload \
+		ip nexthop show id 2
+	check_err $? "IPv6 nexthop not marked as offloaded when should"
+	busywait "$TIMEOUT" wait_for_offload \
+		ip nexthop show id 10
+	check_err $? "nexthop group not marked as offloaded when should"
+
+	# Invalidate nexthop id 1
+	ip neigh replace 192.0.2.2 nud failed dev $swp1
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip nexthop show id 10
+	check_fail $? "nexthop group not marked as offloaded with one valid nexthop"
+
+	# Invalidate nexthop id 2
+	ip neigh replace 2001:db8:1::2 nud failed dev $swp1
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip nexthop show id 10
+	check_err $? "nexthop group marked as offloaded when should not"
+
+	# Revalidate nexthop id 1
+	ip nexthop replace id 1 via 192.0.2.3 dev $swp1
+	busywait "$TIMEOUT" wait_for_offload \
+		ip nexthop show id 10
+	check_err $? "nexthop group not marked as offloaded after revalidating nexthop"
+
+	log_test "nexthop group objects offload indication"
+
+	ip neigh del 2001:db8:1::2 dev $swp1
+	ip neigh del 192.0.2.3 dev $swp1
+	ip neigh del 192.0.2.2 dev $swp1
+	ip nexthop del id 10
+	ip nexthop del id 2
+	ip nexthop del id 1
+
+	simple_if_fini $swp2
+	simple_if_fini $swp1 192.0.2.1/24 2001:db8:1::1/64
+}
+
+nexthop_obj_route_offload_test()
+{
+	# Test offload indication of routes using nexthop objects
+	RET=0
+
+	simple_if_init $swp1 192.0.2.1/24 2001:db8:1::1/64
+	simple_if_init $swp2
+	setup_wait
+
+	ip nexthop add id 1 via 192.0.2.2 dev $swp1
+	ip neigh replace 192.0.2.2 lladdr 00:11:22:33:44:55 nud reachable \
+		dev $swp1
+	ip neigh replace 192.0.2.3 lladdr 00:11:22:33:44:55 nud reachable \
+		dev $swp1
+
+	ip route replace 198.51.100.0/24 nhid 1
+	busywait "$TIMEOUT" wait_for_offload \
+		ip route show 198.51.100.0/24
+	check_err $? "route not marked as offloaded when using valid nexthop"
+
+	ip nexthop replace id 1 via 192.0.2.3 dev $swp1
+	busywait "$TIMEOUT" wait_for_offload \
+		ip route show 198.51.100.0/24
+	check_err $? "route not marked as offloaded after replacing valid nexthop with a valid one"
+
+	ip nexthop replace id 1 via 192.0.2.4 dev $swp1
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip route show 198.51.100.0/24
+	check_err $? "route marked as offloaded after replacing valid nexthop with an invalid one"
+
+	ip nexthop replace id 1 via 192.0.2.2 dev $swp1
+	busywait "$TIMEOUT" wait_for_offload \
+		ip route show 198.51.100.0/24
+	check_err $? "route not marked as offloaded after replacing invalid nexthop with a valid one"
+
+	log_test "routes using nexthop objects offload indication"
+
+	ip route del 198.51.100.0/24
+	ip neigh del 192.0.2.3 dev $swp1
+	ip neigh del 192.0.2.2 dev $swp1
+	ip nexthop del id 1
+
+	simple_if_fini $swp2
+	simple_if_fini $swp1 192.0.2.1/24 2001:db8:1::1/64
+}
+
 devlink_reload_test()
 {
 	# Test that after executing all the above configuration tests, a
-- 
2.28.0

