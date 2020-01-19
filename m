Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7837141DED
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbgASNBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:01:43 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41131 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727465AbgASNBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:01:41 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3DF2A210ED;
        Sun, 19 Jan 2020 08:01:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 19 Jan 2020 08:01:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=h4Y6ygvYh5Ix4xApFusr6ik8cLcv+7AhjYPvo6Lbn5o=; b=sy0MoSmG
        opfMTVqxpvHLl0DxPziyUmY7FHlVEAs0te4jFQ/wCj3XREleBRKgIvwAYLG/yw5w
        zuNDvHTVb2ZEMbIn14NQ/j5JCnPjMt4VZk6RTex3hvoaF7ag8dMoKT1KAAH5CQGf
        cZDZWpBYcaGqYCQWaJpnY3R3cRy3Gi7MgfYzIsvFOllYIHjNVsaljjaEASb3+Gbx
        KysUNKpsGwSeI+u3kluQH3ceythbzkW5IsP/ji5NJdpHljDxtM//eeqCpPU8gILn
        exKN4CqwvPjoPWoBPtlznvqB+rtQ1M8c395blE0XZDaRCeuz9y/Ccnn85487iNqC
        jJG3xGCwfuwObQ==
X-ME-Sender: <xms:NFMkXszQkpl6_FDbzBv3daoM1efkAmm0TihZIMVsd_3g5W1mlkt6rQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepuddt
X-ME-Proxy: <xmx:NFMkXuwbFO_ZXgxl84-r3cMt15PBjsL1Z3NBZfiTKfOtpbKNq92LOg>
    <xmx:NFMkXmvhK6s52fiGvVPuY7OvAryzvZnRA-_Zkfvp_0NLzlxancnm7w>
    <xmx:NFMkXsUwHEbc-LioqZkNtwFS7zIhd0jAdy5Lf8ZhAPEDuxL_TlbmeA>
    <xmx:NFMkXkVhHY8Go9Ht-TT9x9LgW7Q9FgRtg8nt0q1-0GDTLg2xLkSQ3g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E782B80060;
        Sun, 19 Jan 2020 08:01:38 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 11/15] selftests: devlink_trap_tunnel_vxlan: Add test case for decap_error
Date:   Sun, 19 Jan 2020 15:00:56 +0200
Message-Id: <20200119130100.3179857-12-idosch@idosch.org>
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
 .../net/mlxsw/devlink_trap_tunnel_vxlan.sh    | 276 ++++++++++++++++++
 1 file changed, 276 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh
new file mode 100755
index 000000000000..a699edae8358
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh
@@ -0,0 +1,276 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test devlink-trap tunnel drops and exceptions functionality over mlxsw.
+# Check all traps to make sure they are triggered under the right
+# conditions.
+
+# +--------------------+
+# | H1 (vrf)           |
+# |    + $h1           |
+# |    | 192.0.2.1/28  |
+# +----|---------------+
+#      |
+# +----|----------------------------------------------------------------------+
+# | SW |                                                                      |
+# | +--|--------------------------------------------------------------------+ |
+# | |  + $swp1                   BR1 (802.1d)                               | |
+# | |                                                                       | |
+# | |  + vx1 (vxlan)                                                        | |
+# | |    local 192.0.2.17                                                   | |
+# | |    id 1000 dstport $VXPORT                                            | |
+# | +-----------------------------------------------------------------------+ |
+# |                                                                           |
+# |    + $rp1                                                                 |
+# |    | 192.0.2.17/28                                                        |
+# +----|----------------------------------------------------------------------+
+#      |
+# +----|--------------------------------------------------------+
+# |    |                                             VRF2       |
+# |    + $rp2                                                   |
+# |      192.0.2.18/28                                          |
+# |                                                             |
+# +-------------------------------------------------------------+
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
+: ${VXPORT:=4789}
+export VXPORT
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
+switch_create()
+{
+	ip link add name br1 type bridge vlan_filtering 0 mcast_snooping 0
+	# Make sure the bridge uses the MAC address of the local port and not
+	# that of the VxLAN's device.
+	ip link set dev br1 address $(mac_get $swp1)
+	ip link set dev br1 up
+
+	tc qdisc add dev $swp1 clsact
+	ip link set dev $swp1 master br1
+	ip link set dev $swp1 up
+
+	ip link add name vx1 type vxlan id 1000 local 192.0.2.17 \
+		dstport "$VXPORT" nolearning noudpcsum tos inherit ttl 100
+	ip link set dev vx1 master br1
+	ip link set dev vx1 up
+
+	ip address add dev $rp1 192.0.2.17/28
+	ip link set dev $rp1 up
+}
+
+switch_destroy()
+{
+	ip link set dev $rp1 down
+	ip address del dev $rp1 192.0.2.17/28
+
+	ip link set dev vx1 down
+	ip link set dev vx1 nomaster
+	ip link del dev vx1
+
+	ip link set dev $swp1 down
+	ip link set dev $swp1 nomaster
+	tc qdisc del dev $swp1 clsact
+
+	ip link set dev br1 down
+	ip link del dev br1
+}
+
+vrf2_create()
+{
+	simple_if_init $rp2 192.0.2.18/28
+}
+
+vrf2_destroy()
+{
+	simple_if_fini $rp2 192.0.2.18/28
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
+	vrf_prepare
+	forwarding_enable
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
+	forwarding_restore
+	vrf_cleanup
+}
+
+ecn_payload_get()
+{
+	dest_mac=$(mac_get $h1)
+	p=$(:
+		)"08:"$(                      : VXLAN flags
+		)"00:00:00:"$(                : VXLAN reserved
+		)"00:03:e8:"$(                : VXLAN VNI : 1000
+		)"00:"$(                      : VXLAN reserved
+		)"$dest_mac:"$(               : ETH daddr
+		)"00:00:00:00:00:00:"$(       : ETH saddr
+		)"08:00:"$(                   : ETH type
+		)"45:"$(                      : IP version + IHL
+		)"00:"$(                      : IP TOS
+		)"00:14:"$(                   : IP total length
+		)"00:00:"$(                   : IP identification
+		)"20:00:"$(                   : IP flags + frag off
+		)"40:"$(                      : IP TTL
+		)"00:"$(                      : IP proto
+		)"D6:E5:"$(                   : IP header csum
+		)"c0:00:02:03:"$(             : IP saddr: 192.0.2.3
+		)"c0:00:02:01:"$(             : IP daddr: 192.0.2.1
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
+		flower src_ip 192.0.2.3 dst_ip 192.0.2.1 action pass
+
+	rp1_mac=$(mac_get $rp1)
+	payload=$(ecn_payload_get)
+
+	ip vrf exec v$rp2 $MZ $rp2 -c 0 -d 1msec -b $rp1_mac -B 192.0.2.17 \
+		-t udp sp=12345,dp=$VXPORT,tos=$outer_tos,p=$payload -q &
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
+reserved_bits_payload_get()
+{
+	dest_mac=$(mac_get $h1)
+	p=$(:
+		)"08:"$(                      : VXLAN flags
+		)"01:00:00:"$(                : VXLAN reserved
+		)"00:03:e8:"$(                : VXLAN VNI : 1000
+		)"00:"$(                      : VXLAN reserved
+		)"$dest_mac:"$(               : ETH daddr
+		)"00:00:00:00:00:00:"$(       : ETH saddr
+		)"08:00:"$(                   : ETH type
+		)"45:"$(                      : IP version + IHL
+		)"00:"$(                      : IP TOS
+		)"00:14:"$(                   : IP total length
+		)"00:00:"$(                   : IP identification
+		)"20:00:"$(                   : IP flags + frag off
+		)"40:"$(                      : IP TTL
+		)"00:"$(                      : IP proto
+		)"00:00:"$(                   : IP header csum
+		)"c0:00:02:03:"$(             : IP saddr: 192.0.2.3
+		)"c0:00:02:01:"$(             : IP daddr: 192.0.2.1
+		)
+	echo $p
+}
+
+short_payload_get()
+{
+        dest_mac=$(mac_get $h1)
+        p=$(:
+		)"08:"$(                      : VXLAN flags
+		)"01:00:00:"$(                : VXLAN reserved
+		)"00:03:e8:"$(                : VXLAN VNI : 1000
+		)"00:"$(                      : VXLAN reserved
+		)
+        echo $p
+}
+
+corrupted_packet_test()
+{
+	local trap_name="decap_error"
+	local group_name="tunnel_drops"
+	local desc=$1; shift
+	local payload_get=$1; shift
+	local mz_pid
+
+	RET=0
+
+	# In case of too short packet, there is no any inner packet,
+	# so the matching will always succeed
+	tc filter add dev $swp1 egress protocol ip pref 1 handle 101 \
+		flower skip_hw src_ip 192.0.2.3 dst_ip 192.0.2.1 action pass
+
+	rp1_mac=$(mac_get $rp1)
+	payload=$($payload_get)
+	ip vrf exec v$rp2 $MZ $rp2 -c 0 -d 1msec -b $rp1_mac \
+		-B 192.0.2.17 -t udp sp=12345,dp=$VXPORT,p=$payload -q &
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
+	ecn_decap_test "Decap error" "ECT(1)" 01
+	ecn_decap_test "Decap error" "ECT(0)" 02
+	ecn_decap_test "Decap error" "CE" 03
+
+	corrupted_packet_test "Decap error: Reserved bits in use" \
+		"reserved_bits_payload_get"
+	corrupted_packet_test "Decap error: No L2 header" "short_payload_get"
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

