Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8103C21B767
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgGJN6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:58:52 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:48879 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728199AbgGJN6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:58:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6D59058059E;
        Fri, 10 Jul 2020 09:58:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 10 Jul 2020 09:58:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=gdJlc80kkmB28sMn3OWS6YQjXmbSrJ2kpKk7Jl1Wfq8=; b=Pb8oA/Qq
        spfILyXiouSMjUIdY0idollc6IlA5Yfgt70ytb9K1QPYzQx3iTdzOgPnwR5acHd3
        PLrevfUUSfaaVyyMAOvVhGG/HpPbBYbcQxLIwNEujakyhfi0KmMRzydLYSDDBsae
        q4fKj5REdppT5gWHHlLRAsZQnN+PuSe/RjMMkxfNGhcMFiabgNC/9fUXg1JcxlRf
        mwNeVNOrNvIljFfhY80p/YeCDqs8rHI50eqSm/Ux+0U7YN9neY3w9RfLI56XYZD4
        DCMDqM+JyQyLsMkDPuKLIx1Wuk4a3BNcsQWUj8iPQsAuTX7Fqi4oHVi+3phW9gnv
        se0urABRXRac2w==
X-ME-Sender: <xms:GnQIX2RHL_e96p2YNI9lhlc6982XpdyI3RoZxRWqs7PNiB-UMF4cLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeduvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:GnQIX7xZa4mVj8zn3hCGdBizFtlvbQ8D3ESMK16cshBkdu5SN7_CGg>
    <xmx:GnQIXz11BK49ky7M5h8FX2VzvPpXesyQLUoF4qe-iQ_tIN9pbHjpsQ>
    <xmx:GnQIXyAlWliYiHakLv572aHeuKGvQdExXc_9QMo20WC2BG7z9fUgPQ>
    <xmx:GnQIXyqhAtfrMuHZ2bbi9jPmdlVOTFy1C_KgkFKi_klOpaDoWJtQvQ>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 71AEC328005A;
        Fri, 10 Jul 2020 09:58:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 13/13] selftests: mlxsw: RED: Test offload of mirror on RED early_drop qevent
Date:   Fri, 10 Jul 2020 16:57:06 +0300
Message-Id: <20200710135706.601409-14-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710135706.601409-1-idosch@idosch.org>
References: <20200710135706.601409-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Add a selftest for offloading a mirror action attached to the block
associated with RED early_drop qevent.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/mlxsw/sch_red_core.sh         | 106 +++++++++++++++++-
 .../drivers/net/mlxsw/sch_red_ets.sh          |  11 ++
 .../drivers/net/mlxsw/sch_red_root.sh         |   8 ++
 3 files changed, 122 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index 0d347d48c112..45042105ead7 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -121,6 +121,7 @@ h1_destroy()
 h2_create()
 {
 	host_create $h2 2
+	tc qdisc add dev $h2 clsact
 
 	# Some of the tests in this suite use multicast traffic. As this traffic
 	# enters BR2_10 resp. BR2_11, it is flooded to all other ports. Thus
@@ -141,6 +142,7 @@ h2_create()
 h2_destroy()
 {
 	ethtool -s $h2 autoneg on
+	tc qdisc del dev $h2 clsact
 	host_destroy $h2
 }
 
@@ -336,6 +338,17 @@ get_qdisc_npackets()
 		qdisc_stats_get $swp3 $(get_qdisc_handle $vlan) .packets
 }
 
+send_packets()
+{
+	local vlan=$1; shift
+	local proto=$1; shift
+	local pkts=$1; shift
+
+	$MZ $h2.$vlan -p 8000 -a own -b $h3_mac \
+	    -A $(ipaddr 2 $vlan) -B $(ipaddr 3 $vlan) \
+	    -t $proto -q -c $pkts "$@"
+}
+
 # This sends traffic in an attempt to build a backlog of $size. Returns 0 on
 # success. After 10 failed attempts it bails out and returns 1. It dumps the
 # backlog size to stdout.
@@ -364,9 +377,7 @@ build_backlog()
 			return 1
 		fi
 
-		$MZ $h2.$vlan -p 8000 -a own -b $h3_mac \
-		    -A $(ipaddr 2 $vlan) -B $(ipaddr 3 $vlan) \
-		    -t $proto -q -c $pkts "$@"
+		send_packets $vlan $proto $pkts "$@"
 	done
 }
 
@@ -531,3 +542,92 @@ do_mc_backlog_test()
 
 	log_test "TC $((vlan - 10)): Qdisc reports MC backlog"
 }
+
+do_drop_test()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+	local trigger=$1; shift
+	local subtest=$1; shift
+	local fetch_counter=$1; shift
+	local backlog
+	local base
+	local now
+	local pct
+
+	RET=0
+
+	start_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) $h3_mac
+
+	# Create a bit of a backlog and observe no mirroring due to drops.
+	qevent_rule_install_$subtest
+	base=$($fetch_counter)
+
+	build_backlog $vlan $((2 * limit / 3)) udp >/dev/null
+
+	busywait 1100 until_counter_is ">= $((base + 1))" $fetch_counter >/dev/null
+	check_fail $? "Spurious packets observed without buffer pressure"
+
+	qevent_rule_uninstall_$subtest
+
+	# Push to the queue until it's at the limit. The configured limit is
+	# rounded by the qdisc and then by the driver, so this is the best we
+	# can do to get to the real limit of the system. Do this with the rules
+	# uninstalled so that the inevitable drops don't get counted.
+	build_backlog $vlan $((3 * limit / 2)) udp >/dev/null
+
+	qevent_rule_install_$subtest
+	base=$($fetch_counter)
+
+	send_packets $vlan udp 11
+
+	now=$(busywait 1100 until_counter_is ">= $((base + 10))" $fetch_counter)
+	check_err $? "Dropped packets not observed: 11 expected, $((now - base)) seen"
+
+	# When no extra traffic is injected, there should be no mirroring.
+	busywait 1100 until_counter_is ">= $((base + 20))" $fetch_counter >/dev/null
+	check_fail $? "Spurious packets observed"
+
+	# When the rule is uninstalled, there should be no mirroring.
+	qevent_rule_uninstall_$subtest
+	send_packets $vlan udp 11
+	busywait 1100 until_counter_is ">= $((base + 20))" $fetch_counter >/dev/null
+	check_fail $? "Spurious packets observed after uninstall"
+
+	log_test "TC $((vlan - 10)): ${trigger}ped packets $subtest'd"
+
+	stop_traffic
+	sleep 1
+}
+
+qevent_rule_install_mirror()
+{
+	tc filter add block 10 pref 1234 handle 102 matchall skip_sw \
+	   action mirred egress mirror dev $swp2 hw_stats disabled
+}
+
+qevent_rule_uninstall_mirror()
+{
+	tc filter del block 10 pref 1234 handle 102 matchall
+}
+
+qevent_counter_fetch_mirror()
+{
+	tc_rule_handle_stats_get "dev $h2 ingress" 101
+}
+
+do_drop_mirror_test()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+	local qevent_name=$1; shift
+
+	tc filter add dev $h2 ingress pref 1 handle 101 prot ip \
+	   flower skip_sw ip_proto udp \
+	   action drop
+
+	do_drop_test "$vlan" "$limit" "$qevent_name" mirror \
+		     qevent_counter_fetch_mirror
+
+	tc filter del dev $h2 ingress pref 1 handle 101 flower
+}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
index 1c36c576613b..c8968b041bea 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
@@ -7,6 +7,7 @@ ALL_TESTS="
 	ecn_nodrop_test
 	red_test
 	mc_backlog_test
+	red_mirror_test
 "
 : ${QDISC:=ets}
 source sch_red_core.sh
@@ -83,6 +84,16 @@ mc_backlog_test()
 	uninstall_qdisc
 }
 
+red_mirror_test()
+{
+	install_qdisc qevent early_drop block 10
+
+	do_drop_mirror_test 10 $BACKLOG1 early_drop
+	do_drop_mirror_test 11 $BACKLOG2 early_drop
+
+	uninstall_qdisc
+}
+
 trap cleanup EXIT
 
 setup_prepare
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
index 558667ea11ec..ede9c38d3eff 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
@@ -7,6 +7,7 @@ ALL_TESTS="
 	ecn_nodrop_test
 	red_test
 	mc_backlog_test
+	red_mirror_test
 "
 source sch_red_core.sh
 
@@ -57,6 +58,13 @@ mc_backlog_test()
 	uninstall_qdisc
 }
 
+red_mirror_test()
+{
+	install_qdisc qevent early_drop block 10
+	do_drop_mirror_test 10 $BACKLOG
+	uninstall_qdisc
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.26.2

