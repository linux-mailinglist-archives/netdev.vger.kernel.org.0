Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC130C49CF
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbfJBIl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:41:58 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44349 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726002AbfJBIly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:41:54 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 76DB62071B;
        Wed,  2 Oct 2019 04:41:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Oct 2019 04:41:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=7qTmf4CpCa4jeOw0bwEtYeIdf7GpAeyuBH+pS+mL8qY=; b=VDI6fkdw
        YSg1xtn6EIqwPZC3jzQbnpjqfPPcAzQa2EfXwxJnW/HG4bi5/mcgO/ffrlY/+nkL
        dCqTmGdSHfjgq7goOlCK/IjEyOcOqwRU70VhZdYpVLjbE6LTJ45L/2MdENDq5RVd
        VWUjiiuhEx1KWUUVzy7hY8vzkMg9Q9GtoJCol6g0L3iL/ehd5V//UltT5srHzLRj
        3oBFY3ZclQmBG4pocSf91Wjv9eevjEwoQQQ9q85imLsVChMW7KjpRDR29qR/KRZY
        o4BTkFKVlEEVGbIu+rQn9Pxt8NfhL0F4T6+1Wqs6CHYqztt/Mo2mIDZGdyXwOCiu
        hM3TkOIhdiiHzw==
X-ME-Sender: <xms:0WKUXRM2DM7QIsdlMQ3kfuD_dndyV4wzc739k88oTDkTDVODDJdF8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepudeg
X-ME-Proxy: <xmx:0WKUXa51LxyQbzW02JcrY8-SNA6B6nh2bzWdx1W-C_m8dKd2TwRs9A>
    <xmx:0WKUXVXBRrbVzf3ypTjvC9qt6xr91GpoMpVsBFddxWCVr-QXENdwSQ>
    <xmx:0WKUXU3n5ELHKslH8HpMN41kkL2KyvcRU2gsOq0bsFQTlZOhg4ayvQ>
    <xmx:0WKUXX0HZoyPCN4chno8s8KH5_FFDt4SLukfNcjJ5_LFdLqqzQV8kQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE356D60057;
        Wed,  2 Oct 2019 04:41:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 15/15] selftests: netdevsim: Add test for route offload API
Date:   Wed,  2 Oct 2019 11:41:03 +0300
Message-Id: <20191002084103.12138-16-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002084103.12138-1-idosch@idosch.org>
References: <20191002084103.12138-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Test various aspects of the route offload API on top of the netdevsim
implementation. Both good and error flows are tested.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/netdevsim/fib_notifier.sh     | 411 ++++++++++++++++++
 1 file changed, 411 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/fib_notifier.sh

diff --git a/tools/testing/selftests/drivers/net/netdevsim/fib_notifier.sh b/tools/testing/selftests/drivers/net/netdevsim/fib_notifier.sh
new file mode 100755
index 000000000000..27b0752df67f
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/fib_notifier.sh
@@ -0,0 +1,411 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# This test is for checking the FIB notification API. It makes use of netdevsim
+# which registers a listener to the FIB notification chain.
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	ipv4_identical_routes
+	ipv4_tos
+	ipv4_metric
+	ipv4_replace
+	ipv4_delete
+	ipv4_plen
+	ipv4_replay
+	ipv4_error_path
+	ipv4_flush
+"
+NETDEVSIM_PATH=/sys/bus/netdevsim/
+DEV_ADDR=1337
+DEV=netdevsim${DEV_ADDR}
+DEVLINK_DEV=netdevsim/${DEV}
+NUM_NETIFS=0
+source $lib_dir/lib.sh
+source $lib_dir/devlink_lib.sh
+
+route_in_hw_check()
+{
+	local route=$1; shift
+
+	ip -n testns1 route show $route | grep -q "in_hw"
+}
+
+ipv4_identical_routes()
+{
+	local i
+
+	RET=0
+
+	for i in $(seq 1 3); do
+		ip -n testns1 link add name dummy$i type dummy
+		ip -n testns1 link set dev dummy$i up
+	done
+
+	ip -n testns1 route add 192.0.2.0/24 dev dummy1 tos 0 metric 1024
+	route_in_hw_check "192.0.2.0/24 dev dummy1 tos 0 metric 1024"
+	check_err $? "Route not in hardware when should"
+
+	ip -n testns1 route append 192.0.2.0/24 dev dummy2 tos 0 metric 1024
+	route_in_hw_check "192.0.2.0/24 dev dummy2 tos 0 metric 1024"
+	check_fail $? "Appended route in hardware when should not"
+
+	ip -n testns1 route prepend 192.0.2.0/24 dev dummy3 tos 0 metric 1024
+	route_in_hw_check "192.0.2.0/24 dev dummy3 tos 0 metric 1024"
+	check_err $? "Prepended route not in hardware when should"
+
+	route_in_hw_check "192.0.2.0/24 dev dummy1 tos 0 metric 1024"
+	check_fail $? "Route was not replaced in hardware by prepended one"
+
+	log_test "IPv4 identical routes"
+
+	for i in $(seq 1 3); do
+		ip -n testns1 link del dev dummy$i
+	done
+}
+
+ipv4_tos()
+{
+	RET=0
+
+	ip -n testns1 link add name dummy1 type dummy
+	ip -n testns1 link set dev dummy1 up
+
+	ip -n testns1 route add 192.0.2.0/24 dev dummy1 tos 0 metric 1024
+	route_in_hw_check "192.0.2.0/24 dev dummy1 tos 0 metric 1024"
+	check_err $? "Route not in hardware when should"
+
+	ip -n testns1 route add 192.0.2.0/24 dev dummy1 tos 2 metric 1024
+	route_in_hw_check "192.0.2.0/24 dev dummy1 tos 2 metric 1024"
+	check_err $? "Highest TOS route not in hardware when should"
+
+	route_in_hw_check "192.0.2.0/24 dev dummy1 tos 0 metric 1024"
+	check_fail $? "Lowest TOS route still in hardware when should not"
+
+	ip -n testns1 route add 192.0.2.0/24 dev dummy1 tos 1 metric 1024
+	route_in_hw_check "192.0.2.0/24 dev dummy1 tos 1 metric 1024"
+	check_fail $? "Middle TOS route in hardware when should not"
+
+	log_test "IPv4 routes with TOS"
+
+	ip -n testns1 link del dev dummy1
+}
+
+ipv4_metric()
+{
+	RET=0
+
+	ip -n testns1 link add name dummy1 type dummy
+	ip -n testns1 link set dev dummy1 up
+
+	ip -n testns1 route add 192.0.2.0/24 dev dummy1 metric 1024
+	route_in_hw_check "192.0.2.0/24 dev dummy1 metric 1024"
+	check_err $? "Route not in hardware when should"
+
+	ip -n testns1 route add 192.0.2.0/24 dev dummy1 metric 1022
+	route_in_hw_check "192.0.2.0/24 dev dummy1 metric 1022"
+	check_err $? "Lowest metric route not in hardware when should"
+
+	route_in_hw_check "192.0.2.0/24 dev dummy1 metric 1024"
+	check_fail $? "Highest metric route still in hardware when should not"
+
+	ip -n testns1 route add 192.0.2.0/24 dev dummy1 metric 1023
+	route_in_hw_check "192.0.2.0/24 dev dummy1 tos 1 metric 1023"
+	check_fail $? "Middle metric route in hardware when should not"
+
+	log_test "IPv4 routes with metric"
+
+	ip -n testns1 link del dev dummy1
+}
+
+ipv4_replace()
+{
+	local i
+
+	RET=0
+
+	for i in $(seq 1 2); do
+		ip -n testns1 link add name dummy$i type dummy
+		ip -n testns1 link set dev dummy$i up
+	done
+
+	ip -n testns1 route add 192.0.2.0/24 dev dummy1 metric 1024
+	route_in_hw_check "192.0.2.0/24 dev dummy1 metric 1024"
+	check_err $? "Route not in hardware when should"
+
+	ip -n testns1 route replace 192.0.2.0/24 dev dummy2 metric 1024
+	route_in_hw_check "192.0.2.0/24 dev dummy2 metric 1024"
+	check_err $? "Replacement route not in hardware when should"
+
+	# Add a route with an higher metric and make sure that replacing it
+	# does not affect the lower metric one.
+	ip -n testns1 route add 192.0.2.0/24 dev dummy1 metric 1025
+	ip -n testns1 route replace 192.0.2.0/24 dev dummy2 metric 1025
+
+	route_in_hw_check "192.0.2.0/24 dev dummy2 metric 1024"
+	check_err $? "Lowest metric route not in hardware when should"
+	route_in_hw_check "192.0.2.0/24 dev dummy2 metric 1025"
+	check_fail $? "Highest metric route in hardware when should not"
+
+	log_test "IPv4 route replace"
+
+	for i in $(seq 1 2); do
+		ip -n testns1 link del dev dummy$i
+	done
+}
+
+ipv4_delete()
+{
+	local metric
+
+	RET=0
+
+	ip -n testns1 link add name dummy1 type dummy
+	ip -n testns1 link set dev dummy1 up
+
+	# Insert multiple routes with the same prefix and length and varying
+	# metrics. Make sure that throughout delete operations the lowest
+	# metric route is the one in hardware.
+	for metric in $(seq 1024 1026); do
+		ip -n testns1 route add 192.0.2.0/24 dev dummy1 metric $metric
+	done
+
+	route_in_hw_check "192.0.2.0/24 dev dummy1 metric 1024"
+	check_err $? "Route not in hardware when should"
+
+	ip -n testns1 route del 192.0.2.0/24 dev dummy1 metric 1024
+	route_in_hw_check "192.0.2.0/24 dev dummy1 metric 1025"
+	check_err $? "Lowest metric route not in hardware when should"
+
+	ip -n testns1 route del 192.0.2.0/24 dev dummy1 metric 1026
+	route_in_hw_check "192.0.2.0/24 dev dummy1 metric 1025"
+	check_err $? "Sole route not in hardware when should"
+
+	log_test "IPv4 route delete"
+
+	ip -n testns1 link del dev dummy1
+}
+
+ipv4_plen()
+{
+	RET=0
+
+	ip -n testns1 link add name dummy1 type dummy
+	ip -n testns1 link set dev dummy1 up
+
+	# Add two routes with the same key and different prefix length and
+	# make sure both are in hardware. It can be verfied that both are
+	# sharing the same leaf by checking the /proc/net/fib_trie
+	ip -n testns1 route add 192.0.2.0/24 dev dummy1
+	ip -n testns1 route add 192.0.2.0/25 dev dummy1
+
+	route_in_hw_check "192.0.2.0/24 dev dummy1"
+	check_err $? "/24 not in hardware when should"
+
+	route_in_hw_check "192.0.2.0/25 dev dummy1"
+	check_err $? "/25 not in hardware when should"
+
+	log_test "IPv4 routes with different prefix length"
+
+	ip -n testns1 link del dev dummy1
+}
+
+ipv4_replay_metric()
+{
+	RET=0
+
+	ip -n testns1 link add name dummy1 type dummy
+	ip -n testns1 link set dev dummy1 up
+
+	ip -n testns1 route add 192.0.2.0/24 dev dummy1 metric 1024
+	ip -n testns1 route add 192.0.2.0/24 dev dummy1 metric 1025
+
+	devlink -N testns1 dev reload $DEVLINK_DEV
+
+	route_in_hw_check "192.0.2.0/24 dev dummy1 metric 1024"
+	check_err $? "Lowest metric route not in hardware when should"
+
+	route_in_hw_check "192.0.2.0/24 dev dummy1 metric 1025"
+	check_fail $? "Highest metric route in hardware when should not"
+
+	log_test "IPv4 routes replay - metric"
+
+	ip -n testns1 link del dev dummy1
+}
+
+ipv4_replay_tos()
+{
+	RET=0
+
+	ip -n testns1 link add name dummy1 type dummy
+	ip -n testns1 link set dev dummy1 up
+
+	ip -n testns1 route add 192.0.2.0/24 dev dummy1 tos 0
+	ip -n testns1 route add 192.0.2.0/24 dev dummy1 tos 1
+
+	devlink -N testns1 dev reload $DEVLINK_DEV
+
+	route_in_hw_check "192.0.2.0/24 dev dummy1 tos 1"
+	check_err $? "Highest TOS route not in hardware when should"
+
+	route_in_hw_check "192.0.2.0/24 dev dummy1 tos 0"
+	check_fail $? "Lowest TOS route in hardware when should not"
+
+	log_test "IPv4 routes replay - TOS"
+
+	ip -n testns1 link del dev dummy1
+}
+
+ipv4_replay_plen()
+{
+	RET=0
+
+	ip -n testns1 link add name dummy1 type dummy
+	ip -n testns1 link set dev dummy1 up
+
+	ip -n testns1 route add 192.0.2.0/24 dev dummy1
+	ip -n testns1 route add 192.0.2.0/25 dev dummy1
+
+	devlink -N testns1 dev reload $DEVLINK_DEV
+
+	route_in_hw_check "192.0.2.0/24 dev dummy1"
+	check_err $? "/24 not in hardware when should"
+
+	route_in_hw_check "192.0.2.0/25 dev dummy1"
+	check_err $? "/25 not in hardware when should"
+
+	log_test "IPv4 routes replay - prefix length"
+
+	ip -n testns1 link del dev dummy1
+}
+
+ipv4_replay()
+{
+	# Install multiple routes with the same prefix and length and make sure
+	# that after reload only the routes that should be in hardware are
+	# replayed.
+	ipv4_replay_metric
+	ipv4_replay_tos
+	ipv4_replay_plen
+}
+
+ipv4_error_path_add()
+{
+	local lsb
+
+	RET=0
+
+	ip -n testns1 link add name dummy1 type dummy
+	ip -n testns1 link set dev dummy1 up
+
+	devlink -N testns1 resource set $DEVLINK_DEV path IPv4/fib size 10
+	devlink -N testns1 dev reload $DEVLINK_DEV
+
+	for lsb in $(seq 1 20); do
+		ip -n testns1 route add 192.0.2.${lsb}/32 dev dummy1 \
+			&> /dev/null
+	done
+
+	log_test "IPv4 error path - add"
+
+	ip -n testns1 link del dev dummy1
+}
+
+ipv4_error_path_replay()
+{
+	local lsb
+
+	RET=0
+
+	ip -n testns1 link add name dummy1 type dummy
+	ip -n testns1 link set dev dummy1 up
+
+	devlink -N testns1 resource set $DEVLINK_DEV path IPv4/fib size 100
+	devlink -N testns1 dev reload $DEVLINK_DEV
+
+	for lsb in $(seq 1 20); do
+		ip -n testns1 route add 192.0.2.${lsb}/32 dev dummy1
+	done
+
+	devlink -N testns1 resource set $DEVLINK_DEV path IPv4/fib size 10
+	devlink -N testns1 dev reload $DEVLINK_DEV &> /dev/null
+
+	log_test "IPv4 error path - replay"
+
+	ip -n testns1 link del dev dummy1
+
+	# Successfully reload after deleting all the routes.
+	devlink -N testns1 resource set $DEVLINK_DEV path IPv4/fib size 100
+	devlink -N testns1 dev reload $DEVLINK_DEV
+}
+
+ipv4_error_path()
+{
+	# Test the different error paths of the notifiers by limiting the size
+	# of the "IPv4/fib" resource.
+	ipv4_error_path_add
+	ipv4_error_path_replay
+}
+
+ipv4_flush()
+{
+	local metric
+
+	RET=0
+
+	ip -n testns1 link add name dummy1 type dummy
+	ip -n testns1 link set dev dummy1 up
+
+	# Exercise the routes flushing code paths by inserting various
+	# prefix routes on a netdev and then deleting it.
+	for metric in $(seq 1 20); do
+		ip -n testns1 route add 192.0.2.0/24 dev dummy1 metric $metric
+	done
+
+	ip -n testns1 link del dev dummy1
+
+	log_test "IPv4 routes flushing"
+}
+
+setup_prepare()
+{
+	local netdev
+
+	modprobe netdevsim &> /dev/null
+
+	echo "$DEV_ADDR 0" > ${NETDEVSIM_PATH}/new_device
+
+	if [ ! -d "${NETDEVSIM_PATH}/devices/${DEV}" ]; then
+		echo "Failed to create netdevsim device"
+		exit 1
+	fi
+
+	ip netns add testns1
+	if [ $? -ne 0 ]; then
+		echo "Failed to add netns \"testns1\""
+		exit 1
+	fi
+
+	devlink dev reload $DEVLINK_DEV netns testns1
+	if [ $? -ne 0 ]; then
+		echo "Failed to reload into netns \"testns1\""
+		exit 1
+	fi
+}
+
+cleanup()
+{
+	pre_cleanup
+	ip netns del testns1
+	echo "$DEV_ADDR" > ${NETDEVSIM_PATH}/del_device
+	modprobe -r netdevsim &> /dev/null
+}
+
+trap cleanup EXIT
+
+setup_prepare
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.21.0

