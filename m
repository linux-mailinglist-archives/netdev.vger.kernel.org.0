Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72EA04B24B
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 08:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731172AbfFSGmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 02:42:09 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45463 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725881AbfFSGmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 02:42:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B69B022355;
        Wed, 19 Jun 2019 02:42:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 19 Jun 2019 02:42:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=T7vO6D57dhNqM+RHHAfox1VHCb2MVflY8yi6U5c7I3g=; b=JXcb43Zm
        Ho4RiF0TV2A8mRyqOC69tBRJ3BFrXCDqNLUPfDww5kOjJXGGKMBBTyVWVgM8eR2S
        YPWMilw46WWYE83MPbvFaguASWpNppAnc3qe7F+cabwAOufqyJ4LbR47NqvsQpHm
        uVkBScFDBYZ9ExIcsutfdNpw5PN3n+/B2Gh1g3s07h2fFt7P8HQWg/Ekki0JyWRk
        q4pCNkCRt7Fw8WGgTFAgmYpjzyDuD/piehmrM9gbTWKJDgq4prlD8v+YC+eNNeaO
        JlKDGW+9XZ8z+2pEcEeNsdywssX7p98fTOiyWPVGfGsmgqq+BshEt7R6ZVrocImt
        XgGGZh6viSDMiA==
X-ME-Sender: <xms:P9kJXQ33-hLUc3SCcYHsqpUJ29UucA3laQiy_deE8fHw-kGAx-t9VA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddugdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeei
X-ME-Proxy: <xmx:P9kJXVrstgIgsp_x9x6tr2ZQo8YXVXObVtEc1zL6AOvcYGB-ZRJCKA>
    <xmx:P9kJXVeMU0gXOJkEJNmcgpR6eP1q8c04K-Lf5WWrCGW24ULxiYMEJw>
    <xmx:P9kJXcogHltUNIYieK8TwMIYoBWYR9Cjjm8Z0y2GaFUwBlabANnTPw>
    <xmx:P9kJXUwLQlRXafmEGguNYOxC9V8MOjE_1UnH7pi9UFmoHfzBGJc9Rg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id EA3738005B;
        Wed, 19 Jun 2019 02:42:04 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, jakub.kicinski@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 8/8] selftests: tc: add ingress device matching support
Date:   Wed, 19 Jun 2019 09:41:09 +0300
Message-Id: <20190619064109.849-9-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190619064109.849-1-idosch@idosch.org>
References: <20190619064109.849-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Extend tc_flower to test plain ingress device matching and also
tc_shblock to test ingress device matching on shared block.
Add new tc_flower_router.sh where ingress device matching on egress
(after routing) is done.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/net/forwarding/tc_flower.sh     |  26 ++-
 .../net/forwarding/tc_flower_router.sh        | 172 ++++++++++++++++++
 .../selftests/net/forwarding/tc_shblocks.sh   |  29 ++-
 3 files changed, 225 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_router.sh

diff --git a/tools/testing/selftests/net/forwarding/tc_flower.sh b/tools/testing/selftests/net/forwarding/tc_flower.sh
index 124803eea4a9..058c746ee300 100755
--- a/tools/testing/selftests/net/forwarding/tc_flower.sh
+++ b/tools/testing/selftests/net/forwarding/tc_flower.sh
@@ -3,7 +3,7 @@
 
 ALL_TESTS="match_dst_mac_test match_src_mac_test match_dst_ip_test \
 	match_src_ip_test match_ip_flags_test match_pcp_test match_vlan_test \
-	match_ip_tos_test"
+	match_ip_tos_test match_indev_test"
 NUM_NETIFS=2
 source tc_common.sh
 source lib.sh
@@ -310,6 +310,30 @@ match_ip_tos_test()
 	log_test "ip_tos match ($tcflags)"
 }
 
+match_indev_test()
+{
+	RET=0
+
+	tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
+		$tcflags indev $h1 dst_mac $h2mac action drop
+	tc filter add dev $h2 ingress protocol ip pref 2 handle 102 flower \
+		$tcflags indev $h2 dst_mac $h2mac action drop
+
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
+		-t ip -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_fail $? "Matched on a wrong filter"
+
+	tc_check_packets "dev $h2 ingress" 102 1
+	check_err $? "Did not match on correct filter"
+
+	tc filter del dev $h2 ingress protocol ip pref 2 handle 102 flower
+	tc filter del dev $h2 ingress protocol ip pref 1 handle 101 flower
+
+	log_test "indev match ($tcflags)"
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}
diff --git a/tools/testing/selftests/net/forwarding/tc_flower_router.sh b/tools/testing/selftests/net/forwarding/tc_flower_router.sh
new file mode 100755
index 000000000000..4aee9c9e69f6
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/tc_flower_router.sh
@@ -0,0 +1,172 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="match_indev_egress_test"
+NUM_NETIFS=6
+source tc_common.sh
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.1.1/24
+
+	ip route add 192.0.2.0/24 vrf v$h1 nexthop via 192.0.1.2
+	ip route add 192.0.3.0/24 vrf v$h1 nexthop via 192.0.1.2
+}
+
+h1_destroy()
+{
+	ip route del 192.0.3.0/24 vrf v$h1
+	ip route del 192.0.2.0/24 vrf v$h1
+
+	simple_if_fini $h1 192.0.1.1/24
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.1/24
+
+	ip route add 192.0.1.0/24 vrf v$h2 nexthop via 192.0.2.2
+	ip route add 192.0.3.0/24 vrf v$h2 nexthop via 192.0.2.2
+}
+
+h2_destroy()
+{
+	ip route del 192.0.3.0/24 vrf v$h2
+	ip route del 192.0.1.0/24 vrf v$h2
+
+	simple_if_fini $h2 192.0.2.1/24
+}
+
+h3_create()
+{
+	simple_if_init $h3 192.0.3.1/24
+
+	ip route add 192.0.1.0/24 vrf v$h3 nexthop via 192.0.3.2
+	ip route add 192.0.2.0/24 vrf v$h3 nexthop via 192.0.3.2
+}
+
+h3_destroy()
+{
+	ip route del 192.0.2.0/24 vrf v$h3
+	ip route del 192.0.1.0/24 vrf v$h3
+
+	simple_if_fini $h3 192.0.3.1/24
+}
+
+
+router_create()
+{
+	ip link set dev $rp1 up
+	ip link set dev $rp2 up
+	ip link set dev $rp3 up
+
+	tc qdisc add dev $rp3 clsact
+
+	ip address add 192.0.1.2/24 dev $rp1
+	ip address add 192.0.2.2/24 dev $rp2
+	ip address add 192.0.3.2/24 dev $rp3
+}
+
+router_destroy()
+{
+	ip address del 192.0.3.2/24 dev $rp3
+	ip address del 192.0.2.2/24 dev $rp2
+	ip address del 192.0.1.2/24 dev $rp1
+
+	tc qdisc del dev $rp3 clsact
+
+	ip link set dev $rp3 down
+	ip link set dev $rp2 down
+	ip link set dev $rp1 down
+}
+
+match_indev_egress_test()
+{
+	RET=0
+
+	tc filter add dev $rp3 egress protocol ip pref 1 handle 101 flower \
+		$tcflags indev $rp1 dst_ip 192.0.3.1 action drop
+	tc filter add dev $rp3 egress protocol ip pref 2 handle 102 flower \
+		$tcflags indev $rp2 dst_ip 192.0.3.1 action drop
+
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $rp1mac -A 192.0.1.1 -B 192.0.3.1 \
+		-t ip -q
+
+	tc_check_packets "dev $rp3 egress" 102 1
+	check_fail $? "Matched on a wrong filter"
+
+	tc_check_packets "dev $rp3 egress" 101 1
+	check_err $? "Did not match on correct filter"
+
+	$MZ $h2 -c 1 -p 64 -a $h2mac -b $rp2mac -A 192.0.2.1 -B 192.0.3.1 \
+		-t ip -q
+
+	tc_check_packets "dev $rp3 egress" 101 2
+	check_fail $? "Matched on a wrong filter"
+
+	tc_check_packets "dev $rp3 egress" 102 1
+	check_err $? "Did not match on correct filter"
+
+	tc filter del dev $rp3 egress protocol ip pref 2 handle 102 flower
+	tc filter del dev $rp3 egress protocol ip pref 1 handle 101 flower
+
+	log_test "indev egress match ($tcflags)"
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	rp1=${NETIFS[p2]}
+
+	h2=${NETIFS[p3]}
+	rp2=${NETIFS[p4]}
+
+	h3=${NETIFS[p5]}
+	rp3=${NETIFS[p6]}
+
+	h1mac=$(mac_get $h1)
+	rp1mac=$(mac_get $rp1)
+	h2mac=$(mac_get $h2)
+	rp2mac=$(mac_get $rp2)
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+	h3_create
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
+	h3_destroy
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tc_offload_check
+if [[ $? -ne 0 ]]; then
+	log_info "Could not test offloaded functionality"
+else
+	tcflags="skip_sw"
+	tests_run
+fi
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/tc_shblocks.sh b/tools/testing/selftests/net/forwarding/tc_shblocks.sh
index 9826a446e2c0..772e00ac3230 100755
--- a/tools/testing/selftests/net/forwarding/tc_shblocks.sh
+++ b/tools/testing/selftests/net/forwarding/tc_shblocks.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-ALL_TESTS="shared_block_test"
+ALL_TESTS="shared_block_test match_indev_test"
 NUM_NETIFS=4
 source tc_common.sh
 source lib.sh
@@ -70,6 +70,33 @@ shared_block_test()
 	log_test "shared block ($tcflags)"
 }
 
+match_indev_test()
+{
+	RET=0
+
+	tc filter add block 22 protocol ip pref 1 handle 101 flower \
+		$tcflags indev $swp1 dst_mac $swmac action drop
+	tc filter add block 22 protocol ip pref 2 handle 102 flower \
+		$tcflags indev $swp2 dst_mac $swmac action drop
+
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $swmac -A 192.0.2.1 -B 192.0.2.2 \
+		-t ip -q
+
+	tc_check_packets "block 22" 101 1
+	check_err $? "Did not match first incoming packet on a block"
+
+	$MZ $h2 -c 1 -p 64 -a $h2mac -b $swmac -A 192.0.2.1 -B 192.0.2.2 \
+		-t ip -q
+
+	tc_check_packets "block 22" 102 1
+	check_err $? "Did not match second incoming packet on a block"
+
+	tc filter del block 22 protocol ip pref 1 handle 101 flower
+	tc filter del block 22 protocol ip pref 2 handle 102 flower
+
+	log_test "indev match ($tcflags)"
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}
-- 
2.20.1

