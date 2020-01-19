Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6667F141DF1
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgASNBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:01:48 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39511 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727766AbgASNBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:01:42 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 938E821F1E;
        Sun, 19 Jan 2020 08:01:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 19 Jan 2020 08:01:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ucNU3IF6e4wCYSY+cvbSttMgZ2/rtIErxyvrabwJJZ0=; b=bYojDyVe
        Wm0Dn3Ry764eEMH3tJN9Vx7OwvLB0OR9kVkjYc4S+prn9QWnpHK9KfSxJ6Nybo9N
        NnMhcVlwaJo6wxrnjYVi8Z57ti2SI+A4QfA6fiMHKMZbmsYnJDRYcgFNqKDZloZR
        fe+aubTZmD7gGhVaaBFahGe7gQ6Wf+EbaSl/Oe0tt59P2p66+8UAftsRxBx9PyZA
        BXGTiRjVy+Ljf4HtvAzjh+nxo62jmRMhlE/s+tSqQm1viJyKF6WQ4pE4vZDltoDA
        mYLjkF7MN4BQrmVf4/6XY5vBI26wcKNxEhALVT6Xcy00jBAeVtorMGmsoiiOtdqi
        Lm1NaszqXVApSg==
X-ME-Sender: <xms:NVMkXqOp2_1w10OdQ9SbZIN32hVFBYk0Qsd4qmUOs-6ZKbEaNEzmnw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepuddt
X-ME-Proxy: <xmx:NVMkXvA77nFUiAqHxD9weFTb0OheozTNuBQs4giUcmB_muh6kwXeLg>
    <xmx:NVMkXkiGEm59QFZjx8jxvNyHYmqinCIAVuBIUSwHM62xlKJptm4LQw>
    <xmx:NVMkXi10juzwjCQVW6OHdjpb427JGq9rqqZqXXu4ErpO-CYuwqlcEA>
    <xmx:NVMkXmsWzi2Hh1daxC9XBFAT6fS5oLKkDKQnaaVMq9PF3XgRz7kNgQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 46A1F8005A;
        Sun, 19 Jan 2020 08:01:40 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 12/15] selftests: devlink_trap_tunnel_ipip: Add test case for decap_error
Date:   Sun, 19 Jan 2020 15:00:57 +0200
Message-Id: <20200119130100.3179857-13-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200119130100.3179857-1-idosch@idosch.org>
References: <20200119130100.3179857-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Test that the trap is triggered under the right conditions and that
devlink counters increase.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/mlxsw/devlink_trap_tunnel_ipip.sh     | 265 ++++++++++++++++++
 1 file changed, 265 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh
new file mode 100755
index 000000000000..039629bb92a3
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh
@@ -0,0 +1,265 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test devlink-trap tunnel exceptions functionality over mlxsw.
+# Check all exception traps to make sure they are triggered under the right
+# conditions.
+
+# +-------------------------+
+# | H1                      |
+# |               $h1 +     |
+# |      192.0.2.1/28 |     |
+# +-------------------|-----+
+#                     |
+# +-------------------|-----+
+# | SW1               |     |
+# |              $swp1 +    |
+# |      192.0.2.2/28       |
+# |                         |
+# |  + g1a (gre)            |
+# |    loc=192.0.2.65       |
+# |    rem=192.0.2.66       |
+# |    tos=inherit          |
+# |                         |
+# |  + $rp1                 |
+# |  |  198.51.100.1/28     |
+# +--|----------------------+
+#    |
+# +--|----------------------+
+# |  |                 VRF2 |
+# | + $rp2                  |
+# |   198.51.100.2/28       |
+# +-------------------------+
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	decap_error_test
+"
+
+NUM_NETIFS=4
+source $lib_dir/lib.sh
+source $lib_dir/tc_common.sh
+source $lib_dir/devlink_lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/28
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 192.0.2.1/28
+}
+
+vrf2_create()
+{
+	simple_if_init $rp2 198.51.100.2/28
+}
+
+vrf2_destroy()
+{
+	simple_if_fini $rp2 198.51.100.2/28
+}
+
+switch_create()
+{
+	__addr_add_del $swp1 add 192.0.2.2/28
+	tc qdisc add dev $swp1 clsact
+	ip link set dev $swp1 up
+
+	tunnel_create g1 gre 192.0.2.65 192.0.2.66 tos inherit
+	__addr_add_del g1 add 192.0.2.65/32
+	ip link set dev g1 up
+
+	__addr_add_del $rp1 add 198.51.100.1/28
+	ip link set dev $rp1 up
+}
+
+switch_destroy()
+{
+	ip link set dev $rp1 down
+	__addr_add_del $rp1 del 198.51.100.1/28
+
+	ip link set dev g1 down
+	__addr_add_del g1 del 192.0.2.65/32
+	tunnel_destroy g1
+
+	ip link set dev $swp1 down
+	tc qdisc del dev $swp1 clsact
+	__addr_add_del $swp1 del 192.0.2.2/28
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	rp1=${NETIFS[p3]}
+	rp2=${NETIFS[p4]}
+
+	forwarding_enable
+	vrf_prepare
+	h1_create
+	switch_create
+	vrf2_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	vrf2_destroy
+	switch_destroy
+	h1_destroy
+	vrf_cleanup
+	forwarding_restore
+}
+
+ecn_payload_get()
+{
+	p=$(:
+		)"0"$(		              : GRE flags
+	        )"0:00:"$(                    : Reserved + version
+		)"08:00:"$(		      : ETH protocol type
+		)"4"$(	                      : IP version
+		)"5:"$(                       : IHL
+		)"00:"$(                      : IP TOS
+		)"00:14:"$(                   : IP total length
+		)"00:00:"$(                   : IP identification
+		)"20:00:"$(                   : IP flags + frag off
+		)"30:"$(                      : IP TTL
+		)"01:"$(                      : IP proto
+		)"E7:E6:"$(    	              : IP header csum
+		)"C0:00:01:01:"$(             : IP saddr : 192.0.1.1
+		)"C0:00:02:01:"$(             : IP daddr : 192.0.2.1
+		)
+	echo $p
+}
+
+ecn_decap_test()
+{
+	local trap_name="decap_error"
+	local group_name="tunnel_drops"
+	local desc=$1; shift
+	local ecn_desc=$1; shift
+	local outer_tos=$1; shift
+	local mz_pid
+
+	RET=0
+
+	tc filter add dev $swp1 egress protocol ip pref 1 handle 101 \
+		flower src_ip 192.0.1.1 dst_ip 192.0.2.1 action pass
+
+	rp1_mac=$(mac_get $rp1)
+	rp2_mac=$(mac_get $rp2)
+	payload=$(ecn_payload_get)
+
+	ip vrf exec v$rp2 $MZ $rp2 -c 0 -d 1msec -a $rp2_mac -b $rp1_mac \
+		-A 192.0.2.66 -B 192.0.2.65 -t ip \
+			len=48,tos=$outer_tos,proto=47,p=$payload -q &
+
+	mz_pid=$!
+
+	devlink_trap_exception_test $trap_name $group_name
+
+	tc_check_packets "dev $swp1 egress" 101 0
+	check_err $? "Packets were not dropped"
+
+	log_test "$desc: Inner ECN is not ECT and outer is $ecn_desc"
+
+	kill $mz_pid && wait $mz_pid &> /dev/null
+	tc filter del dev $swp1 egress protocol ip pref 1 handle 101 flower
+}
+
+ipip_payload_get()
+{
+	local flags=$1; shift
+	local key=$1; shift
+
+	p=$(:
+		)"$flags"$(		      : GRE flags
+	        )"0:00:"$(                    : Reserved + version
+		)"08:00:"$(		      : ETH protocol type
+		)"$key"$( 		      : Key
+		)"4"$(	                      : IP version
+		)"5:"$(                       : IHL
+		)"00:"$(                      : IP TOS
+		)"00:14:"$(                   : IP total length
+		)"00:00:"$(                   : IP identification
+		)"20:00:"$(                   : IP flags + frag off
+		)"30:"$(                      : IP TTL
+		)"01:"$(                      : IP proto
+		)"E7:E6:"$(    	              : IP header csum
+		)"C0:00:01:01:"$(             : IP saddr : 192.0.1.1
+		)"C0:00:02:01:"$(             : IP daddr : 192.0.2.1
+		)
+	echo $p
+}
+
+no_matching_tunnel_test()
+{
+	local trap_name="decap_error"
+	local group_name="tunnel_drops"
+	local desc=$1; shift
+	local sip=$1; shift
+	local mz_pid
+
+	RET=0
+
+	tc filter add dev $swp1 egress protocol ip pref 1 handle 101 \
+		flower src_ip 192.0.1.1 dst_ip 192.0.2.1 action pass
+
+	rp1_mac=$(mac_get $rp1)
+	rp2_mac=$(mac_get $rp2)
+	payload=$(ipip_payload_get "$@")
+
+	ip vrf exec v$rp2 $MZ $rp2 -c 0 -d 1msec -a $rp2_mac -b $rp1_mac \
+		-A $sip -B 192.0.2.65 -t ip len=48,proto=47,p=$payload -q &
+	mz_pid=$!
+
+	devlink_trap_exception_test $trap_name $group_name
+
+	tc_check_packets "dev $swp1 egress" 101 0
+	check_err $? "Packets were not dropped"
+
+	log_test "$desc"
+
+	kill $mz_pid && wait $mz_pid &> /dev/null
+	tc filter del dev $swp1 egress protocol ip pref 1 handle 101 flower
+}
+
+decap_error_test()
+{
+	# Correct source IP - the remote address
+	local sip=192.0.2.66
+
+	ecn_decap_test "Decap error" "ECT(1)" 01
+	ecn_decap_test "Decap error" "ECT(0)" 02
+	ecn_decap_test "Decap error" "CE" 03
+
+	no_matching_tunnel_test "Decap error: Source IP check failed" \
+		192.0.2.68 "0"
+	no_matching_tunnel_test \
+		"Decap error: Key exists but was not expected" $sip "2" ":E9:"
+
+	# Destroy the tunnel and create new one with key
+	__addr_add_del g1 del 192.0.2.65/32
+	tunnel_destroy g1
+
+	tunnel_create g1 gre 192.0.2.65 192.0.2.66 tos inherit key 233
+	__addr_add_del g1 add 192.0.2.65/32
+
+	no_matching_tunnel_test \
+		"Decap error: Key does not exist but was expected" $sip "0"
+	no_matching_tunnel_test \
+		"Decap error: Packet has a wrong key field" $sip "2" "E8:"
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
2.24.1

