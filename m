Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA14E30B0E5
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbhBATzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:55:20 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:47619 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232842AbhBATwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:52:03 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 081B858050F;
        Mon,  1 Feb 2021 14:49:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 01 Feb 2021 14:49:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=DTAro0Iq7h1cN1i5oc1r8aEXcJoMDGIT1BJIVT2juF8=; b=gRr6slEc
        IKmNsM5+YmCKN64RktILg9imRpFzvhiTpqk9epjttwZ/Vy3nZ0lUD2pPRJ8Voznx
        uxPYVmMTvDxuhqAMkMjz3pk+Kv+U1E4oQcIb7RfqGtB4gkKYXgE6iVRvh7r86OGZ
        HBoIUChRgjHLfCNWuiHzX1gAaUrBjMvs0sYJjTS6bYODBrUqMa97qvL52S7oXplU
        uugvXTqNRFslfWUQg26Kf2erh1L8j5JuA068my/BJ6ZZmFv5pgfjeXpODI3SyXiv
        jFldl+rBCQvhPwRJoP8x9BVxb3ic6GKTSQfkE+adp/NwSUyGTRc0m1SFtk0ThPOA
        hgwBg58mdecWpw==
X-ME-Sender: <xms:MFsYYIVsjfSzH3R1Jc7uB3w6V_DLHsdCxpHCrW7OHztpnA6g6ZXCxQ>
    <xme:MFsYYMyom8TSkfLHeu_L5kKkxGqhYP7CJZ4h1pcnQh9Bi6ourg6ZQVRCc-VPV3npZ
    S2fUngJBHbFFm4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:MFsYYONv2Dv7AnJsqsyHlGEYVNmblUuvzlsz9EosXWzzNMUxMrypxw>
    <xmx:MFsYYF4TuNhiWwNxdfAA0nUh6GSsOnDwLRMQmxGQMAWLKqXbD27LRA>
    <xmx:MFsYYHOeBqSm6ajxCdEbqjalOocMsjKWPX5RDZveZMK0VvuYRiOY_g>
    <xmx:MVsYYGIRoJ5fwIlUeb2-pZEw17qQxyzmaqSlMBv0ylRhS9SDjjX53Q>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8FD2624005B;
        Mon,  1 Feb 2021 14:49:02 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        yoshfuji@linux-ipv6.org, jiri@nvidia.com, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 10/10] selftests: netdevsim: Add fib_notifications test
Date:   Mon,  1 Feb 2021 21:47:57 +0200
Message-Id: <20210201194757.3463461-11-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201194757.3463461-1-idosch@idosch.org>
References: <20210201194757.3463461-1-idosch@idosch.org>
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
Reviewed-by: David Ahern <dsahern@kernel.org>
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

