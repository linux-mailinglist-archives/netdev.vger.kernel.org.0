Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9566F304076
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 15:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392701AbhAZOZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 09:25:35 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:48739 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391759AbhAZN01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 08:26:27 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 9A8528C2;
        Tue, 26 Jan 2021 08:24:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 26 Jan 2021 08:24:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=9CcFJDlL94q2zOyEglPZAei0FjTRJ6EB+MX9nc4Bfdk=; b=eF5Sjs2i
        qW0ci3V0tBLCHsoY8KhOe8ak1zj4CdsWHBiCpW3mAL6CnY+XgoHPrtfOGU4U6wM3
        MrAObVc1eqE9wTMMcrOHhFDc+7ikPPL+fcj+9Mfk7D0AsSRNBYRDdsCuQ3MCGep9
        LMTZNeGv/z+Bo+YtEYDRjEDM+Y6hn8MyNBfsd9S8ahRzmOGlvzZPbJ0k0CV1Yfvv
        BJVCJ1zJy5wkLp26s89EBJGTMt2obhWxg+OsOG/EL/PRGMySR8wbowGMsT9YU19b
        C+5uD7XmsCPoB80RINeCRl6DUaRVVdlTZE2MeAxaErxRkdLouLCtTUzKBBBfaq6b
        9sLVn2Cy4IrGsQ==
X-ME-Sender: <xms:FhgQYOWualyyfCDLo6Ah65plm-hwvFX9pGUSpj9rvNIcmpwFEXw63g>
    <xme:FhgQYKlRoEsvTag8Qacdo7xf2Or-Azd7ZdmvnalhvUlptUir5RPCcGlbwL2CwOKHH
    75un1XXfcE7yVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:FhgQYCbzzAnfB4snlWaLd1FltfEybfMHFbzrnuMLjhvJav4Vcn3-uw>
    <xmx:FhgQYFUXo66JAiDnuvfunw6Fx64r6SYu6BNcVfu_vdQ4SNI8JS5JMg>
    <xmx:FhgQYIkRB1cwD0Q9TgQM061FW6s3KNU_zCjxp32VFBLcggnP8Q3BAw>
    <xmx:FhgQYGaXpRcOSCZUwfE7GWE7O12Q28jRAAo_IRkMpRh6zO1-jFidmQ>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id D802D1080057;
        Tue, 26 Jan 2021 08:24:35 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        amcohen@nvidia.com, roopa@nvidia.com, sharpd@nvidia.com,
        bpoirier@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/10] selftests: netdevsim: Add fib_notifications test
Date:   Tue, 26 Jan 2021 15:23:11 +0200
Message-Id: <20210126132311.3061388-11-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126132311.3061388-1-idosch@idosch.org>
References: <20210126132311.3061388-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add test to check fib notifications behavior.

The test checks route addition, route deletion and route replacement for
both IPv4 and IPv6.

When fib_notify_on_flag_change=0, expect single notification for route
addition/deletion/replacement.

When fib_notify_on_flag_change=1, expect:
- two notification for route addition/replacement, first without RTM_F_TRAP
  and second with RTM_F_TRAP.
- single notification for route deletion.

$ ./fib_notifications.sh
TEST: IPv4 route addition                                           [ OK ]
TEST: IPv4 route deletion                                           [ OK ]
TEST: IPv4 route replacement                                        [ OK ]
TEST: IPv6 route addition                                           [ OK ]
TEST: IPv6 route deletion                                           [ OK ]
TEST: IPv6 route replacement                                        [ OK ]

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/netdevsim/fib_notifications.sh        | 300 ++++++++++++++++++
 1 file changed, 300 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/fib_notifications.sh

diff --git a/tools/testing/selftests/drivers/net/netdevsim/fib_notifications.sh b/tools/testing/selftests/drivers/net/netdevsim/fib_notifications.sh
new file mode 100755
index 000000000000..16a9dd43aefc
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/fib_notifications.sh
@@ -0,0 +1,300 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	ipv4_route_addition_test
+	ipv4_route_deletion_test
+	ipv4_route_replacement_test
+	ipv6_route_addition_test
+	ipv6_route_deletion_test
+	ipv6_route_replacement_test
+"
+
+NETDEVSIM_PATH=/sys/bus/netdevsim/
+DEV_ADDR=1337
+DEV=netdevsim${DEV_ADDR}
+DEVLINK_DEV=netdevsim/${DEV}
+SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV/net/
+NUM_NETIFS=0
+source $lib_dir/lib.sh
+
+check_rt_trap()
+{
+	local outfile=$1; shift
+	local line
+
+	# Make sure that the first notification was emitted without RTM_F_TRAP
+	# flag and the second with RTM_F_TRAP flag
+	head -n 1 $outfile | grep -q "rt_trap"
+	if [[ $? -eq 0 ]]; then
+		return 1
+	fi
+
+	head -n 2 $outfile | tail -n 1 | grep -q "rt_trap"
+}
+
+route_notify_check()
+{
+	local outfile=$1; shift
+	local expected_num_lines=$1; shift
+
+	# check the monitor results
+	lines=`wc -l $outfile | cut "-d " -f1`
+	test $lines -eq $expected_num_lines
+	check_err $? "$expected_num_lines notifications were expected but $lines were received"
+
+	if [[ $expected_num_lines -eq 2 ]]; then
+		check_rt_trap $outfile
+		check_err $? "Wrong RTM_F_TRAP flags in notifications"
+	fi
+}
+
+route_addition_check()
+{
+	local ip=$1; shift
+	local notify=$1; shift
+	local route=$1; shift
+	local expected_num_notifications=$1; shift
+
+	ip netns exec testns1 sysctl -qw net.$ip.fib_notify_on_flag_change=$notify
+
+	local outfile=$(mktemp)
+
+	$IP monitor route &> $outfile &
+	sleep 1
+	$IP route add $route dev dummy1
+	sleep 1
+	kill %% && wait %% &> /dev/null
+
+	route_notify_check $outfile $expected_num_notifications
+	rm -f $outfile
+
+	$IP route del $route dev dummy1
+}
+
+ipv4_route_addition_test()
+{
+	RET=0
+
+	local ip="ipv4"
+	local route=192.0.2.0/24
+
+	# Make sure a single notification will be emitted for the programmed
+	# route.
+	local notify=0
+	local expected_num_notifications=1
+	# route_addition_check will assign value to RET.
+	route_addition_check $ip $notify $route $expected_num_notifications
+
+	# Make sure two notifications will be emitted for the programmed route.
+	notify=1
+	expected_num_notifications=2
+	route_addition_check $ip $notify $route $expected_num_notifications
+
+	log_test "IPv4 route addition"
+}
+
+route_deletion_check()
+{
+	local ip=$1; shift
+	local notify=$1; shift
+	local route=$1; shift
+	local expected_num_notifications=$1; shift
+
+	ip netns exec testns1 sysctl -qw net.$ip.fib_notify_on_flag_change=$notify
+	$IP route add $route dev dummy1
+	sleep 1
+
+	local outfile=$(mktemp)
+
+	$IP monitor route &> $outfile &
+	sleep 1
+	$IP route del $route dev dummy1
+	sleep 1
+	kill %% && wait %% &> /dev/null
+
+	route_notify_check $outfile $expected_num_notifications
+	rm -f $outfile
+}
+
+ipv4_route_deletion_test()
+{
+	RET=0
+
+	local ip="ipv4"
+	local route=192.0.2.0/24
+	local expected_num_notifications=1
+
+	# Make sure a single notification will be emitted for the deleted route,
+	# regardless of fib_notify_on_flag_change value.
+	local notify=0
+	# route_deletion_check will assign value to RET.
+	route_deletion_check $ip $notify $route $expected_num_notifications
+
+	notify=1
+	route_deletion_check $ip $notify $route $expected_num_notifications
+
+	log_test "IPv4 route deletion"
+}
+
+route_replacement_check()
+{
+	local ip=$1; shift
+	local notify=$1; shift
+	local route=$1; shift
+	local expected_num_notifications=$1; shift
+
+	ip netns exec testns1 sysctl -qw net.$ip.fib_notify_on_flag_change=$notify
+	$IP route add $route dev dummy1
+	sleep 1
+
+	local outfile=$(mktemp)
+
+	$IP monitor route &> $outfile &
+	sleep 1
+	$IP route replace $route dev dummy2
+	sleep 1
+	kill %% && wait %% &> /dev/null
+
+	route_notify_check $outfile $expected_num_notifications
+	rm -f $outfile
+
+	$IP route del $route dev dummy2
+}
+
+ipv4_route_replacement_test()
+{
+	RET=0
+
+	local ip="ipv4"
+	local route=192.0.2.0/24
+
+	$IP link add name dummy2 type dummy
+	$IP link set dev dummy2 up
+
+	# Make sure a single notification will be emitted for the new route.
+	local notify=0
+	local expected_num_notifications=1
+	# route_replacement_check will assign value to RET.
+	route_replacement_check $ip $notify $route $expected_num_notifications
+
+	# Make sure two notifications will be emitted for the new route.
+	notify=1
+	expected_num_notifications=2
+	route_replacement_check $ip $notify $route $expected_num_notifications
+
+	$IP link del name dummy2
+
+	log_test "IPv4 route replacement"
+}
+
+ipv6_route_addition_test()
+{
+	RET=0
+
+	local ip="ipv6"
+	local route=2001:db8:1::/64
+
+	# Make sure a single notification will be emitted for the programmed
+	# route.
+	local notify=0
+	local expected_num_notifications=1
+	route_addition_check $ip $notify $route $expected_num_notifications
+
+	# Make sure two notifications will be emitted for the programmed route.
+	notify=1
+	expected_num_notifications=2
+	route_addition_check $ip $notify $route $expected_num_notifications
+
+	log_test "IPv6 route addition"
+}
+
+ipv6_route_deletion_test()
+{
+	RET=0
+
+	local ip="ipv6"
+	local route=2001:db8:1::/64
+	local expected_num_notifications=1
+
+	# Make sure a single notification will be emitted for the deleted route,
+	# regardless of fib_notify_on_flag_change value.
+	local notify=0
+	route_deletion_check $ip $notify $route $expected_num_notifications
+
+	notify=1
+	route_deletion_check $ip $notify $route $expected_num_notifications
+
+	log_test "IPv6 route deletion"
+}
+
+ipv6_route_replacement_test()
+{
+	RET=0
+
+	local ip="ipv6"
+	local route=2001:db8:1::/64
+
+	$IP link add name dummy2 type dummy
+	$IP link set dev dummy2 up
+
+	# Make sure a single notification will be emitted for the new route.
+	local notify=0
+	local expected_num_notifications=1
+	route_replacement_check $ip $notify $route $expected_num_notifications
+
+	# Make sure two notifications will be emitted for the new route.
+	notify=1
+	expected_num_notifications=2
+	route_replacement_check $ip $notify $route $expected_num_notifications
+
+	$IP link del name dummy2
+
+	log_test "IPv6 route replacement"
+}
+
+setup_prepare()
+{
+	modprobe netdevsim &> /dev/null
+	echo "$DEV_ADDR 1" > ${NETDEVSIM_PATH}/new_device
+	while [ ! -d $SYSFS_NET_DIR ] ; do :; done
+
+	ip netns add testns1
+
+	if [ $? -ne 0 ]; then
+		echo "Failed to add netns \"testns1\""
+		exit 1
+	fi
+
+	devlink dev reload $DEVLINK_DEV netns testns1
+
+	if [ $? -ne 0 ]; then
+		echo "Failed to reload into netns \"testns1\""
+		exit 1
+	fi
+
+	IP="ip -n testns1"
+
+	$IP link add name dummy1 type dummy
+	$IP link set dev dummy1 up
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	$IP link del name dummy1
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
2.29.2

