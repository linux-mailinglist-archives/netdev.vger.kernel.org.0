Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F2C13A858
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 12:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbgANLYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 06:24:02 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45023 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729626AbgANLX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 06:23:59 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9A6D2225A9;
        Tue, 14 Jan 2020 06:23:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 14 Jan 2020 06:23:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=NyA0duGcNOWTx+h8iTE00nuSGhT7Ro2/ce/h4P7i/NE=; b=Cp2uEiPz
        4XC72eWjhRZ7M5LNAEV/Pyg4DqJDHoI9hJ1gNV+3Da+MdrJX0oaTGw8ZVG+6pbo1
        37C1LDWopfe6sag8xYmO/JPSKVhEPWSqe4GtuYOu1ZIjfL/F7eONB+o4FQ9+9J+P
        eO+RGoN9DQ5dDyP2ikqxN6O/io9FBdz1YUSdzHgQfteJm6mER9W7Er28KXBLE7VD
        XLycRwuvXGJ+oR98vg9X6T/wwpOUEvoxpn5E9qiWbNDDp+hM/vEJIhR7w6KohSkm
        ZDUbQQerdeqO4l2AHuXNPQceoq0h7200/9mPBTDX8cMySNS5Xyf5C6HZilbJgh5m
        D+dN60QaVBAKAQ==
X-ME-Sender: <xms:zaQdXhElG4nbGzW3KM8_3AwbQezPbXUBOg5zMKUlaUTSTkR_rSGdsQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtddtgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepje
X-ME-Proxy: <xmx:zaQdXtl0WLKkCSmgKbS4Ezf10o7tdwrdCy-_UAZGB-eIp0JOnSSGpA>
    <xmx:zaQdXrsYPD2ua1hZFtnO1l_xzNo0cO0scgPmfpHBq7BtHX1jlh0lOg>
    <xmx:zaQdXkcppugpOJvUOCHIlpvhn0qfKtabIXYHNGiLMwfOn3F8Z5Jexw>
    <xmx:zaQdXgJs4bhHC8nPY_t0xFWudbbOl-VNgDR2sGyLEoPE77RVRe1YiA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E3AFE8005A;
        Tue, 14 Jan 2020 06:23:55 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 08/10] selftests: forwarding: Add helpers and tests for FIB offload
Date:   Tue, 14 Jan 2020 13:23:16 +0200
Message-Id: <20200114112318.876378-9-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114112318.876378-1-idosch@idosch.org>
References: <20200114112318.876378-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Implement a set of common helpers and tests for FIB offload that can be
used by multiple drivers to check their FIB offload implementations.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/forwarding/fib_offload_lib.sh         | 873 ++++++++++++++++++
 1 file changed, 873 insertions(+)
 create mode 100644 tools/testing/selftests/net/forwarding/fib_offload_lib.sh

diff --git a/tools/testing/selftests/net/forwarding/fib_offload_lib.sh b/tools/testing/selftests/net/forwarding/fib_offload_lib.sh
new file mode 100644
index 000000000000..66496659bea7
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/fib_offload_lib.sh
@@ -0,0 +1,873 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Various helpers and tests to verify FIB offload.
+
+__fib_trap_check()
+{
+	local ns=$1; shift
+	local family=$1; shift
+	local route=$1; shift
+	local should_fail=$1; shift
+	local ret
+
+	ip -n $ns -j -p -$family route show $route \
+		| jq -e '.[]["flags"] | contains(["trap"])' &> /dev/null
+	ret=$?
+	if [[ $should_fail == "true" ]]; then
+		if [[ $ret -ne 0 ]]; then
+			return 0
+		else
+			return 1
+		fi
+	fi
+
+	return $ret
+}
+
+fib_trap_check()
+{
+	local ns=$1; shift
+	local family=$1; shift
+	local route=$1; shift
+	local should_fail=$1; shift
+
+	busywait 5000 __fib_trap_check $ns $family "$route" $should_fail
+}
+
+fib4_trap_check()
+{
+	local ns=$1; shift
+	local route=$1; shift
+	local should_fail=$1; shift
+
+	fib_trap_check $ns 4 "$route" $should_fail
+}
+
+fib6_trap_check()
+{
+	local ns=$1; shift
+	local route=$1; shift
+	local should_fail=$1; shift
+
+	fib_trap_check $ns 6 "$route" $should_fail
+}
+
+fib_ipv4_identical_routes_test()
+{
+	local ns=$1; shift
+	local i
+
+	RET=0
+
+	for i in $(seq 1 3); do
+		ip -n $ns link add name dummy$i type dummy
+		ip -n $ns link set dev dummy$i up
+	done
+
+	ip -n $ns route add 192.0.2.0/24 dev dummy1 tos 0 metric 1024
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 tos 0 metric 1024" false
+	check_err $? "Route not in hardware when should"
+
+	ip -n $ns route append 192.0.2.0/24 dev dummy2 tos 0 metric 1024
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy2 tos 0 metric 1024" true
+	check_err $? "Appended route in hardware when should not"
+
+	ip -n $ns route prepend 192.0.2.0/24 dev dummy3 tos 0 metric 1024
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy3 tos 0 metric 1024" false
+	check_err $? "Prepended route not in hardware when should"
+
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 tos 0 metric 1024" true
+	check_err $? "Route was not replaced in hardware by prepended one"
+
+	log_test "IPv4 identical routes"
+
+	for i in $(seq 1 3); do
+		ip -n $ns link del dev dummy$i
+	done
+}
+
+fib_ipv4_tos_test()
+{
+	local ns=$1; shift
+
+	RET=0
+
+	ip -n $ns link add name dummy1 type dummy
+	ip -n $ns link set dev dummy1 up
+
+	ip -n $ns route add 192.0.2.0/24 dev dummy1 tos 0 metric 1024
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 tos 0 metric 1024" false
+	check_err $? "Route not in hardware when should"
+
+	ip -n $ns route add 192.0.2.0/24 dev dummy1 tos 2 metric 1024
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 tos 2 metric 1024" false
+	check_err $? "Highest TOS route not in hardware when should"
+
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 tos 0 metric 1024" true
+	check_err $? "Lowest TOS route still in hardware when should not"
+
+	ip -n $ns route add 192.0.2.0/24 dev dummy1 tos 1 metric 1024
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 tos 1 metric 1024" true
+	check_err $? "Middle TOS route in hardware when should not"
+
+	log_test "IPv4 routes with TOS"
+
+	ip -n $ns link del dev dummy1
+}
+
+fib_ipv4_metric_test()
+{
+	local ns=$1; shift
+
+	RET=0
+
+	ip -n $ns link add name dummy1 type dummy
+	ip -n $ns link set dev dummy1 up
+
+	ip -n $ns route add 192.0.2.0/24 dev dummy1 metric 1024
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 metric 1024" false
+	check_err $? "Route not in hardware when should"
+
+	ip -n $ns route add 192.0.2.0/24 dev dummy1 metric 1022
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 metric 1022" false
+	check_err $? "Lowest metric route not in hardware when should"
+
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 metric 1024" true
+	check_err $? "Highest metric route still in hardware when should not"
+
+	ip -n $ns route add 192.0.2.0/24 dev dummy1 metric 1023
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 metric 1023" true
+	check_err $? "Middle metric route in hardware when should not"
+
+	log_test "IPv4 routes with metric"
+
+	ip -n $ns link del dev dummy1
+}
+
+fib_ipv4_replace_test()
+{
+	local ns=$1; shift
+	local i
+
+	RET=0
+
+	for i in $(seq 1 2); do
+		ip -n $ns link add name dummy$i type dummy
+		ip -n $ns link set dev dummy$i up
+	done
+
+	ip -n $ns route add 192.0.2.0/24 dev dummy1 metric 1024
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 metric 1024" false
+	check_err $? "Route not in hardware when should"
+
+	ip -n $ns route replace 192.0.2.0/24 dev dummy2 metric 1024
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy2 metric 1024" false
+	check_err $? "Replacement route not in hardware when should"
+
+	# Add a route with an higher metric and make sure that replacing it
+	# does not affect the lower metric one.
+	ip -n $ns route add 192.0.2.0/24 dev dummy1 metric 1025
+	ip -n $ns route replace 192.0.2.0/24 dev dummy2 metric 1025
+
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy2 metric 1024" false
+	check_err $? "Lowest metric route not in hardware when should"
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy2 metric 1025" true
+	check_err $? "Highest metric route in hardware when should not"
+
+	log_test "IPv4 route replace"
+
+	for i in $(seq 1 2); do
+		ip -n $ns link del dev dummy$i
+	done
+}
+
+fib_ipv4_delete_test()
+{
+	local ns=$1; shift
+	local metric
+
+	RET=0
+
+	ip -n $ns link add name dummy1 type dummy
+	ip -n $ns link set dev dummy1 up
+
+	# Insert multiple routes with the same prefix and length and varying
+	# metrics. Make sure that throughout delete operations the lowest
+	# metric route is the one in hardware.
+	for metric in $(seq 1024 1026); do
+		ip -n $ns route add 192.0.2.0/24 dev dummy1 metric $metric
+	done
+
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 metric 1024" false
+	check_err $? "Route not in hardware when should"
+
+	ip -n $ns route del 192.0.2.0/24 dev dummy1 metric 1024
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 metric 1025" false
+	check_err $? "Lowest metric route not in hardware when should"
+
+	ip -n $ns route del 192.0.2.0/24 dev dummy1 metric 1026
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 metric 1025" false
+	check_err $? "Sole route not in hardware when should"
+
+	log_test "IPv4 route delete"
+
+	ip -n $ns link del dev dummy1
+}
+
+fib_ipv4_plen_test()
+{
+	local ns=$1; shift
+
+	RET=0
+
+	ip -n $ns link add name dummy1 type dummy
+	ip -n $ns link set dev dummy1 up
+
+	# Add two routes with the same key and different prefix length and
+	# make sure both are in hardware. It can be verfied that both are
+	# sharing the same leaf by checking the /proc/net/fib_trie
+	ip -n $ns route add 192.0.2.0/24 dev dummy1
+	ip -n $ns route add 192.0.2.0/25 dev dummy1
+
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1" false
+	check_err $? "/24 not in hardware when should"
+
+	fib4_trap_check $ns "192.0.2.0/25 dev dummy1" false
+	check_err $? "/25 not in hardware when should"
+
+	log_test "IPv4 routes with different prefix length"
+
+	ip -n $ns link del dev dummy1
+}
+
+fib_ipv4_replay_metric_test()
+{
+	local ns=$1; shift
+	local devlink_dev=$1; shift
+
+	RET=0
+
+	ip -n $ns link add name dummy1 type dummy
+	ip -n $ns link set dev dummy1 up
+
+	ip -n $ns route add 192.0.2.0/24 dev dummy1 metric 1024
+	ip -n $ns route add 192.0.2.0/24 dev dummy1 metric 1025
+
+	devlink -N $ns dev reload $devlink_dev
+
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 metric 1024" false
+	check_err $? "Lowest metric route not in hardware when should"
+
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 metric 1025" true
+	check_err $? "Highest metric route in hardware when should not"
+
+	log_test "IPv4 routes replay - metric"
+
+	ip -n $ns link del dev dummy1
+}
+
+fib_ipv4_replay_tos_test()
+{
+	local ns=$1; shift
+	local devlink_dev=$1; shift
+
+	RET=0
+
+	ip -n $ns link add name dummy1 type dummy
+	ip -n $ns link set dev dummy1 up
+
+	ip -n $ns route add 192.0.2.0/24 dev dummy1 tos 0
+	ip -n $ns route add 192.0.2.0/24 dev dummy1 tos 1
+
+	devlink -N $ns dev reload $devlink_dev
+
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 tos 1" false
+	check_err $? "Highest TOS route not in hardware when should"
+
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1 tos 0" true
+	check_err $? "Lowest TOS route in hardware when should not"
+
+	log_test "IPv4 routes replay - TOS"
+
+	ip -n $ns link del dev dummy1
+}
+
+fib_ipv4_replay_plen_test()
+{
+	local ns=$1; shift
+	local devlink_dev=$1; shift
+
+	RET=0
+
+	ip -n $ns link add name dummy1 type dummy
+	ip -n $ns link set dev dummy1 up
+
+	ip -n $ns route add 192.0.2.0/24 dev dummy1
+	ip -n $ns route add 192.0.2.0/25 dev dummy1
+
+	devlink -N $ns dev reload $devlink_dev
+
+	fib4_trap_check $ns "192.0.2.0/24 dev dummy1" false
+	check_err $? "/24 not in hardware when should"
+
+	fib4_trap_check $ns "192.0.2.0/25 dev dummy1" false
+	check_err $? "/25 not in hardware when should"
+
+	log_test "IPv4 routes replay - prefix length"
+
+	ip -n $ns link del dev dummy1
+}
+
+fib_ipv4_flush_test()
+{
+	local ns=$1; shift
+	local metric
+
+	RET=0
+
+	ip -n $ns link add name dummy1 type dummy
+	ip -n $ns link set dev dummy1 up
+
+	# Exercise the routes flushing code paths by inserting various
+	# prefix routes on a netdev and then deleting it.
+	for metric in $(seq 1 20); do
+		ip -n $ns route add 192.0.2.0/24 dev dummy1 metric $metric
+	done
+
+	ip -n $ns link del dev dummy1
+
+	log_test "IPv4 routes flushing"
+}
+
+fib_ipv6_add_test()
+{
+	local ns=$1; shift
+
+	RET=0
+
+	for i in $(seq 1 2); do
+		ip -n $ns link add name dummy$i type dummy
+		ip -n $ns link set dev dummy$i up
+	done
+
+	ip -n $ns route add 2001:db8:1::/64 dev dummy1 metric 1024
+	fib6_trap_check $ns "2001:db8:1::/64 dev dummy1 metric 1024" false
+	check_err $? "Route not in hardware when should"
+
+	ip -n $ns route append 2001:db8:1::/64 dev dummy2 metric 1024
+	fib6_trap_check $ns "2001:db8:1::/64 dev dummy2 metric 1024" true
+	check_err $? "Route in hardware when should not"
+
+	fib6_trap_check $ns "2001:db8:1::/64 dev dummy1 metric 1024" false
+	check_err $? "Route not in hardware after appending route"
+
+	log_test "IPv6 single route add"
+
+	for i in $(seq 1 2); do
+		ip -n $ns link del dev dummy$i
+	done
+}
+
+fib_ipv6_metric_test()
+{
+	local ns=$1; shift
+
+	RET=0
+
+	ip -n $ns link add name dummy1 type dummy
+	ip -n $ns link set dev dummy1 up
+
+	ip -n $ns route add 2001:db8:1::/64 dev dummy1 metric 1024
+	fib6_trap_check $ns "2001:db8:1::/64 dev dummy1 metric 1024" false
+	check_err $? "Route not in hardware when should"
+
+	ip -n $ns route add 2001:db8:1::/64 dev dummy1 metric 1022
+	fib6_trap_check $ns "2001:db8:1::/64 dev dummy1 metric 1022" false
+	check_err $? "Lowest metric route not in hardware when should"
+
+	fib6_trap_check $ns "2001:db8:1::/64 dev dummy1 metric 1024" true
+	check_err $? "Highest metric route still in hardware when should not"
+
+	ip -n $ns route add 2001:db8:1::/64 dev dummy1 metric 1023
+	fib6_trap_check $ns "2001:db8:1::/64 dev dummy1 metric 1023" true
+	check_err $? "Middle metric route in hardware when should not"
+
+	log_test "IPv6 routes with metric"
+
+	ip -n $ns link del dev dummy1
+}
+
+fib_ipv6_append_single_test()
+{
+	local ns=$1; shift
+
+	# When an IPv6 multipath route is added without the 'nexthop' keyword,
+	# different code paths are taken compared to when the keyword is used.
+	# This test tries to verify the former.
+	RET=0
+
+	for i in $(seq 1 2); do
+		ip -n $ns link add name dummy$i type dummy
+		ip -n $ns link set dev dummy$i up
+		ip -n $ns address add 2001:db8:$i::1/64 dev dummy$i
+	done
+
+	ip -n $ns route add 2001:db8:10::/64 via 2001:db8:1::2 metric 1024
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1024" false
+	check_err $? "Route not in hardware when should"
+
+	ip -n $ns route append 2001:db8:10::/64 via 2001:db8:2::2 metric 1024
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1024" false
+	check_err $? "Route not in hardware after appending"
+
+	ip -n $ns route add 2001:db8:10::/64 via 2001:db8:1::2 metric 1025
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1025" true
+	check_err $? "Route in hardware when should not"
+
+	ip -n $ns route append 2001:db8:10::/64 via 2001:db8:2::2 metric 1025
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1025" true
+	check_err $? "Route in hardware when should not after appending"
+
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1024" false
+	check_err $? "Lowest metric route not in hardware when should"
+
+	log_test "IPv6 append single route without 'nexthop' keyword"
+
+	for i in $(seq 1 2); do
+		ip -n $ns link del dev dummy$i
+	done
+}
+
+fib_ipv6_replace_single_test()
+{
+	local ns=$1; shift
+	local i
+
+	RET=0
+
+	for i in $(seq 1 2); do
+		ip -n $ns link add name dummy$i type dummy
+		ip -n $ns link set dev dummy$i up
+	done
+
+	ip -n $ns route add 2001:db8:1::/64 dev dummy1 metric 1024
+	fib6_trap_check $ns "2001:db8:1::/64 dev dummy1 metric 1024" false
+	check_err $? "Route not in hardware when should"
+
+	ip -n $ns route replace 2001:db8:1::/64 dev dummy2 metric 1024
+	fib6_trap_check $ns "2001:db8:1::/64 dev dummy2 metric 1024" false
+	check_err $? "Replacement route not in hardware when should"
+
+	# Add a route with an higher metric and make sure that replacing it
+	# does not affect the lower metric one.
+	ip -n $ns route add 2001:db8:1::/64 dev dummy1 metric 1025
+	ip -n $ns route replace 2001:db8:1::/64 dev dummy2 metric 1025
+
+	fib6_trap_check $ns "2001:db8:1::/64 dev dummy2 metric 1024" false
+	check_err $? "Lowest metric route not in hardware when should"
+	fib6_trap_check $ns "2001:db8:1::/64 dev dummy2 metric 1025" true
+	check_err $? "Highest metric route in hardware when should not"
+
+	log_test "IPv6 single route replace"
+
+	for i in $(seq 1 2); do
+		ip -n $ns link del dev dummy$i
+	done
+}
+
+fib_ipv6_metric_multipath_test()
+{
+	local ns=$1; shift
+
+	RET=0
+
+	for i in $(seq 1 2); do
+		ip -n $ns link add name dummy$i type dummy
+		ip -n $ns link set dev dummy$i up
+		ip -n $ns address add 2001:db8:$i::1/64 dev dummy$i
+	done
+
+	ip -n $ns route add 2001:db8:10::/64 metric 1024 \
+		nexthop via 2001:db8:1::2 dev dummy1 \
+		nexthop via 2001:db8:2::2 dev dummy2
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1024" false
+	check_err $? "Route not in hardware when should"
+
+	ip -n $ns route add 2001:db8:10::/64 metric 1022 \
+		nexthop via 2001:db8:1::2 dev dummy1 \
+		nexthop via 2001:db8:2::2 dev dummy2
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1022" false
+	check_err $? "Lowest metric route not in hardware when should"
+
+	ip -n $ns route add 2001:db8:10::/64 metric 1023 \
+		nexthop via 2001:db8:1::2 dev dummy1 \
+		nexthop via 2001:db8:2::2 dev dummy2
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1024" true
+	check_err $? "Highest metric route still in hardware when should not"
+
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1023" true
+	check_err $? "Middle metric route in hardware when should not"
+
+	log_test "IPv6 multipath routes with metric"
+
+	for i in $(seq 1 2); do
+		ip -n $ns link del dev dummy$i
+	done
+}
+
+fib_ipv6_append_multipath_test()
+{
+	local ns=$1; shift
+
+	RET=0
+
+	for i in $(seq 1 3); do
+		ip -n $ns link add name dummy$i type dummy
+		ip -n $ns link set dev dummy$i up
+		ip -n $ns address add 2001:db8:$i::1/64 dev dummy$i
+	done
+
+	ip -n $ns route add 2001:db8:10::/64 metric 1024 \
+		nexthop via 2001:db8:1::2 dev dummy1
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1024" false
+	check_err $? "Route not in hardware when should"
+
+	ip -n $ns route append 2001:db8:10::/64 metric 1024 \
+		nexthop via 2001:db8:2::2 dev dummy2 \
+		nexthop via 2001:db8:3::2 dev dummy3
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1024" false
+	check_err $? "Route not in hardware after appending"
+
+	ip -n $ns route add 2001:db8:10::/64 metric 1025 \
+		nexthop via 2001:db8:1::2 dev dummy1
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1025" true
+	check_err $? "Route in hardware when should not"
+
+	ip -n $ns route append 2001:db8:10::/64 metric 1025 \
+		nexthop via 2001:db8:2::2 dev dummy2 \
+		nexthop via 2001:db8:3::2 dev dummy3
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1025" true
+	check_err $? "Route in hardware when should not after appending"
+
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1024" false
+	check_err $? "Lowest metric route not in hardware when should"
+
+	log_test "IPv6 append multipath route with 'nexthop' keyword"
+
+	for i in $(seq 1 3); do
+		ip -n $ns link del dev dummy$i
+	done
+}
+
+fib_ipv6_replace_multipath_test()
+{
+	local ns=$1; shift
+	local i
+
+	RET=0
+
+	for i in $(seq 1 3); do
+		ip -n $ns link add name dummy$i type dummy
+		ip -n $ns link set dev dummy$i up
+		ip -n $ns address add 2001:db8:$i::1/64 dev dummy$i
+	done
+
+	ip -n $ns route add 2001:db8:10::/64 metric 1024 \
+		nexthop via 2001:db8:1::2 dev dummy1 \
+		nexthop via 2001:db8:2::2 dev dummy2
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1024" false
+	check_err $? "Route not in hardware when should"
+
+	ip -n $ns route replace 2001:db8:10::/64 metric 1024 \
+		nexthop via 2001:db8:1::2 dev dummy1 \
+		nexthop via 2001:db8:3::2 dev dummy3
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1024" false
+	check_err $? "Replacement route not in hardware when should"
+
+	# Add a route with an higher metric and make sure that replacing it
+	# does not affect the lower metric one.
+	ip -n $ns route add 2001:db8:10::/64 metric 1025 \
+		nexthop via 2001:db8:1::2 dev dummy1 \
+		nexthop via 2001:db8:2::2 dev dummy2
+	ip -n $ns route replace 2001:db8:10::/64 metric 1025 \
+		nexthop via 2001:db8:1::2 dev dummy1 \
+		nexthop via 2001:db8:3::2 dev dummy3
+
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1024" false
+	check_err $? "Lowest metric route not in hardware when should"
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1025" true
+	check_err $? "Highest metric route in hardware when should not"
+
+	log_test "IPv6 multipath route replace"
+
+	for i in $(seq 1 3); do
+		ip -n $ns link del dev dummy$i
+	done
+}
+
+fib_ipv6_append_multipath_to_single_test()
+{
+	local ns=$1; shift
+
+	# Test that when the first route in the leaf is not a multipath route
+	# and we try to append a multipath route with the same metric to it, it
+	# is not notified.
+	RET=0
+
+	for i in $(seq 1 2); do
+		ip -n $ns link add name dummy$i type dummy
+		ip -n $ns link set dev dummy$i up
+		ip -n $ns address add 2001:db8:$i::1/64 dev dummy$i
+	done
+
+	ip -n $ns route add 2001:db8:10::/64 dev dummy1 metric 1024
+	fib6_trap_check $ns "2001:db8:10::/64 dev dummy1 metric 1024" false
+	check_err $? "Route not in hardware when should"
+
+	ip -n $ns route append 2001:db8:10::/64 metric 1024 \
+		nexthop via 2001:db8:2::2 dev dummy2
+	fib6_trap_check $ns "2001:db8:10::/64 dev dummy2 metric 1024" true
+	check_err $? "Route in hardware when should not"
+
+	fib6_trap_check $ns "2001:db8:10::/64 dev dummy1 metric 1024" false
+	check_err $? "Route not in hardware after append"
+
+	log_test "IPv6 append multipath route to non-multipath route"
+
+	for i in $(seq 1 2); do
+		ip -n $ns link del dev dummy$i
+	done
+}
+
+fib_ipv6_delete_single_test()
+{
+	local ns=$1; shift
+
+	# Test various deletion scenarios, where only a single route is
+	# deleted from the FIB node.
+	for i in $(seq 1 2); do
+		ip -n $ns link add name dummy$i type dummy
+		ip -n $ns link set dev dummy$i up
+		ip -n $ns address add 2001:db8:$i::1/64 dev dummy$i
+	done
+
+	# Test deletion of a single route when it is the only route in the FIB
+	# node.
+	RET=0
+
+	ip -n $ns route add 2001:db8:10::/64 dev dummy1 metric 1024
+	ip -n $ns route del 2001:db8:10::/64 dev dummy1 metric 1024
+
+	log_test "IPv6 delete sole single route"
+
+	# Test that deletion of last route does not affect the first one.
+	RET=0
+
+	ip -n $ns route add 2001:db8:10::/64 dev dummy1 metric 1024
+	ip -n $ns route add 2001:db8:10::/64 dev dummy1 metric 1025
+	ip -n $ns route del 2001:db8:10::/64 dev dummy1 metric 1025
+
+	fib6_trap_check $ns "2001:db8:10::/64 dev dummy1 metric 1024" false
+	check_err $? "Route not in hardware after deleting higher metric route"
+
+	log_test "IPv6 delete single route not in hardware"
+
+	ip -n $ns route del 2001:db8:10::/64 dev dummy1 metric 1024
+
+	# Test that first route is replaced by next single route in the FIB
+	# node.
+	RET=0
+
+	ip -n $ns route add 2001:db8:10::/64 dev dummy1 metric 1024
+	ip -n $ns route add 2001:db8:10::/64 dev dummy1 metric 1025
+	ip -n $ns route del 2001:db8:10::/64 dev dummy1 metric 1024
+
+	fib6_trap_check $ns "2001:db8:10::/64 dev dummy1 metric 1025" false
+	check_err $? "Route not in hardware after deleting lowest metric route"
+
+	log_test "IPv6 delete single route - replaced by single"
+
+	ip -n $ns route del 2001:db8:10::/64 dev dummy1 metric 1025
+
+	# Test that first route is replaced by next multipath route in the FIB
+	# node.
+	RET=0
+
+	ip -n $ns route add 2001:db8:10::/64 dev dummy1 metric 1024
+	ip -n $ns route add 2001:db8:10::/64 metric 1025 \
+		nexthop via 2001:db8:1::2 dev dummy1 \
+		nexthop via 2001:db8:2::2 dev dummy2
+	ip -n $ns route del 2001:db8:10::/64 dev dummy1 metric 1024
+
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1025" false
+	check_err $? "Route not in hardware after deleting lowest metric route"
+
+	log_test "IPv6 delete single route - replaced by multipath"
+
+	ip -n $ns route del 2001:db8:10::/64 metric 1025
+
+	# Test deletion of a single nexthop from a multipath route.
+	ip -n $ns route add 2001:db8:10::/64 metric 1024 \
+		nexthop via 2001:db8:1::2 dev dummy1 \
+		nexthop via 2001:db8:2::2 dev dummy2
+	ip -n $ns route del 2001:db8:10::/64 metric 1024 \
+		nexthop via 2001:db8:1::2 dev dummy1
+
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1024" false
+	check_err $? "Route not in hardware after deleting a single nexthop"
+
+	log_test "IPv6 delete single nexthop"
+
+	ip -n $ns route del 2001:db8:10::/64 metric 1024
+
+	for i in $(seq 1 2); do
+		ip -n $ns link del dev dummy$i
+	done
+}
+
+fib_ipv6_delete_multipath_test()
+{
+	local ns=$1; shift
+
+	# Test various deletion scenarios, where an entire multipath route is
+	# deleted from the FIB node.
+	for i in $(seq 1 2); do
+		ip -n $ns link add name dummy$i type dummy
+		ip -n $ns link set dev dummy$i up
+		ip -n $ns address add 2001:db8:$i::1/64 dev dummy$i
+	done
+
+	# Test deletion of a multipath route when it is the only route in the
+	# FIB node.
+	RET=0
+
+	ip -n $ns route add 2001:db8:10::/64 metric 1024 \
+		nexthop via 2001:db8:1::2 dev dummy1 \
+		nexthop via 2001:db8:2::2 dev dummy2
+	ip -n $ns route del 2001:db8:10::/64 metric 1024
+
+	log_test "IPv6 delete sole multipath route"
+
+	# Test that deletion of last route does not affect the first one.
+	RET=0
+
+	ip -n $ns route add 2001:db8:10::/64 metric 1024 \
+		nexthop via 2001:db8:1::2 dev dummy1 \
+		nexthop via 2001:db8:2::2 dev dummy2
+	ip -n $ns route add 2001:db8:10::/64 metric 1025 \
+		nexthop via 2001:db8:1::2 dev dummy1 \
+		nexthop via 2001:db8:2::2 dev dummy2
+	ip -n $ns route del 2001:db8:10::/64 metric 1025
+
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1024" false
+	check_err $? "Route not in hardware after deleting higher metric route"
+
+	log_test "IPv6 delete multipath route not in hardware"
+
+	ip -n $ns route del 2001:db8:10::/64 metric 1024
+
+	# Test that first route is replaced by next single route in the FIB
+	# node.
+	RET=0
+
+	ip -n $ns route add 2001:db8:10::/64 metric 1024 \
+		nexthop via 2001:db8:1::2 dev dummy1 \
+		nexthop via 2001:db8:2::2 dev dummy2
+	ip -n $ns route add 2001:db8:10::/64 dev dummy1 metric 1025
+	ip -n $ns route del 2001:db8:10::/64 metric 1024
+
+	fib6_trap_check $ns "2001:db8:10::/64 dev dummy1 metric 1025" false
+	check_err $? "Route not in hardware after deleting lowest metric route"
+
+	log_test "IPv6 delete multipath route - replaced by single"
+
+	ip -n $ns route del 2001:db8:10::/64 dev dummy1 metric 1025
+
+	# Test that first route is replaced by next multipath route in the FIB
+	# node.
+	RET=0
+
+	ip -n $ns route add 2001:db8:10::/64 metric 1024 \
+		nexthop via 2001:db8:1::2 dev dummy1 \
+		nexthop via 2001:db8:2::2 dev dummy2
+	ip -n $ns route add 2001:db8:10::/64 metric 1025 \
+		nexthop via 2001:db8:1::2 dev dummy1 \
+		nexthop via 2001:db8:2::2 dev dummy2
+	ip -n $ns route del 2001:db8:10::/64 metric 1024
+
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1025" false
+	check_err $? "Route not in hardware after deleting lowest metric route"
+
+	log_test "IPv6 delete multipath route - replaced by multipath"
+
+	ip -n $ns route del 2001:db8:10::/64 metric 1025
+
+	for i in $(seq 1 2); do
+		ip -n $ns link del dev dummy$i
+	done
+}
+
+fib_ipv6_replay_single_test()
+{
+	local ns=$1; shift
+	local devlink_dev=$1; shift
+
+	RET=0
+
+	for i in $(seq 1 2); do
+		ip -n $ns link add name dummy$i type dummy
+		ip -n $ns link set dev dummy$i up
+	done
+
+	ip -n $ns route add 2001:db8:1::/64 dev dummy1
+	ip -n $ns route append 2001:db8:1::/64 dev dummy2
+
+	devlink -N $ns dev reload $devlink_dev
+
+	fib6_trap_check $ns "2001:db8:1::/64 dev dummy1" false
+	check_err $? "First route not in hardware when should"
+
+	fib6_trap_check $ns "2001:db8:1::/64 dev dummy2" true
+	check_err $? "Second route in hardware when should not"
+
+	log_test "IPv6 routes replay - single route"
+
+	for i in $(seq 1 2); do
+		ip -n $ns link del dev dummy$i
+	done
+}
+
+fib_ipv6_replay_multipath_test()
+{
+	local ns=$1; shift
+	local devlink_dev=$1; shift
+
+	RET=0
+
+	for i in $(seq 1 2); do
+		ip -n $ns link add name dummy$i type dummy
+		ip -n $ns link set dev dummy$i up
+		ip -n $ns address add 2001:db8:$i::1/64 dev dummy$i
+	done
+
+	ip -n $ns route add 2001:db8:10::/64 metric 1024 \
+		nexthop via 2001:db8:1::2 dev dummy1 \
+		nexthop via 2001:db8:2::2 dev dummy2
+	ip -n $ns route add 2001:db8:10::/64 metric 1025 \
+		nexthop via 2001:db8:1::2 dev dummy1 \
+		nexthop via 2001:db8:2::2 dev dummy2
+
+	devlink -N $ns dev reload $devlink_dev
+
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1024" false
+	check_err $? "First route not in hardware when should"
+
+	fib6_trap_check $ns "2001:db8:10::/64 metric 1025" true
+	check_err $? "Second route in hardware when should not"
+
+	log_test "IPv6 routes replay - multipath route"
+
+	for i in $(seq 1 2); do
+		ip -n $ns link del dev dummy$i
+	done
+}
-- 
2.24.1

