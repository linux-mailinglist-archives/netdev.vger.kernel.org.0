Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B343122BA
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhBGIbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:31:19 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:57027 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230184AbhBGI1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:27:50 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8FE655801E8;
        Sun,  7 Feb 2021 03:23:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Feb 2021 03:23:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=o4kuCeu0ErGnmM0Hixxxa5XVXqiF5yLertayOuU1NsY=; b=W5oZ1icd
        4Azqv4YWtdk8uumaAC71wRKNQLCxm3dbfXC34Vlu9gZ8N7UrhcK2Mgk6u/BYFYLc
        yHiGtYsBzlkdC307KuGTG/R/zwHYWYTkxSa1fTyNZuq8CbKgm39TH81iRUVsQzSD
        U2L/PCFzbSjaMWiQ/W0qqi7r07/MzCkY475D8G71suSVhM91wdV7PPXN2qrHc1hL
        1tkVTlvaD3Km+E/Reo5intYU1/my1fiA+G8suuw0edCGHHwyHFWFKNh1lXktMKM6
        L7LpvneOupZ0ia//sr+9QKwJLdcClaK1UIVVlBOuG7qYfV717NzhehSKpgtI1NXy
        6+EqkOGd1s6sbw==
X-ME-Sender: <xms:naMfYJhX37D3pU0nY-OVg7QOwegFEBoYZb_JUCTlw4jOMDRRFWXSvw>
    <xme:naMfYOD34M-uAgBRHV4e42-wSc31yEOzkULq827jfND2lQ6AZwiTL9QbMbNl_0mqx
    TYxNGDCRmST9rw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedtgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpeelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:naMfYJEiXVuW4IiOC6Cx1AkDJMue_L1dAcW6-7CtxrsYGPOioqUWAQ>
    <xmx:naMfYORpRXRzLFqD-QG1A2oYdiKpagk1xxB5ml-IYv1AX8FRZ175gw>
    <xmx:naMfYGyyJHGvwgGPS5a9oLutqeBkYlIuh1yUXqnkpDEetvNcsTCAmw>
    <xmx:naMfYFnRTS7NV0kRFWcn-W5jtBQT9SETXSJqCucfTQjU7NPEOEvjVg>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 014451080064;
        Sun,  7 Feb 2021 03:23:54 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, yoshfuji@linux-ipv6.org, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/10] selftests: netdevsim: Test route offload failure notifications
Date:   Sun,  7 Feb 2021 10:22:58 +0200
Message-Id: <20210207082258.3872086-11-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210207082258.3872086-1-idosch@idosch.org>
References: <20210207082258.3872086-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add cases to verify that when debugfs variable "fail_route_offload" is
set, notification with "rt_offload_failed" flag is received.

Extend the existing cases to verify that when sysctl
"fib_notify_on_flag_change" is set to 2, the kernel emits notifications
only for failed route installation.

$ ./fib_notifications.sh
TEST: IPv4 route addition				[ OK ]
TEST: IPv4 route deletion				[ OK ]
TEST: IPv4 route replacement				[ OK ]
TEST: IPv4 route offload failed				[ OK ]
TEST: IPv6 route addition				[ OK ]
TEST: IPv6 route deletion				[ OK ]
TEST: IPv6 route replacement				[ OK ]
TEST: IPv6 route offload failed				[ OK ]

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/netdevsim/fib_notifications.sh        | 134 +++++++++++++++++-
 1 file changed, 132 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/fib_notifications.sh b/tools/testing/selftests/drivers/net/netdevsim/fib_notifications.sh
index 16a9dd43aefc..8d91191a098c 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/fib_notifications.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/fib_notifications.sh
@@ -7,9 +7,11 @@ ALL_TESTS="
 	ipv4_route_addition_test
 	ipv4_route_deletion_test
 	ipv4_route_replacement_test
+	ipv4_route_offload_failed_test
 	ipv6_route_addition_test
 	ipv6_route_deletion_test
 	ipv6_route_replacement_test
+	ipv6_route_offload_failed_test
 "
 
 NETDEVSIM_PATH=/sys/bus/netdevsim/
@@ -17,9 +19,26 @@ DEV_ADDR=1337
 DEV=netdevsim${DEV_ADDR}
 DEVLINK_DEV=netdevsim/${DEV}
 SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV/net/
+DEBUGFS_DIR=/sys/kernel/debug/netdevsim/$DEV/
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 
+check_rt_offload_failed()
+{
+	local outfile=$1; shift
+	local line
+
+	# Make sure that the first notification was emitted without
+	# RTM_F_OFFLOAD_FAILED flag and the second with RTM_F_OFFLOAD_FAILED
+	# flag
+	head -n 1 $outfile | grep -q "rt_offload_failed"
+	if [[ $? -eq 0 ]]; then
+		return 1
+	fi
+
+	head -n 2 $outfile | tail -n 1 | grep -q "rt_offload_failed"
+}
+
 check_rt_trap()
 {
 	local outfile=$1; shift
@@ -39,15 +58,23 @@ route_notify_check()
 {
 	local outfile=$1; shift
 	local expected_num_lines=$1; shift
+	local offload_failed=${1:-0}; shift
 
 	# check the monitor results
 	lines=`wc -l $outfile | cut "-d " -f1`
 	test $lines -eq $expected_num_lines
 	check_err $? "$expected_num_lines notifications were expected but $lines were received"
 
-	if [[ $expected_num_lines -eq 2 ]]; then
+	if [[ $expected_num_lines -eq 1 ]]; then
+		return
+	fi
+
+	if [[ $offload_failed -eq 0 ]]; then
 		check_rt_trap $outfile
 		check_err $? "Wrong RTM_F_TRAP flags in notifications"
+	else
+		check_rt_offload_failed $outfile
+		check_err $? "Wrong RTM_F_OFFLOAD_FAILED flags in notifications"
 	fi
 }
 
@@ -57,6 +84,7 @@ route_addition_check()
 	local notify=$1; shift
 	local route=$1; shift
 	local expected_num_notifications=$1; shift
+	local offload_failed=${1:-0}; shift
 
 	ip netns exec testns1 sysctl -qw net.$ip.fib_notify_on_flag_change=$notify
 
@@ -68,7 +96,7 @@ route_addition_check()
 	sleep 1
 	kill %% && wait %% &> /dev/null
 
-	route_notify_check $outfile $expected_num_notifications
+	route_notify_check $outfile $expected_num_notifications $offload_failed
 	rm -f $outfile
 
 	$IP route del $route dev dummy1
@@ -93,6 +121,13 @@ ipv4_route_addition_test()
 	expected_num_notifications=2
 	route_addition_check $ip $notify $route $expected_num_notifications
 
+	# notify=2 means emit notifications only for failed route installation,
+	# make sure a single notification will be emitted for the programmed
+	# route.
+	notify=2
+	expected_num_notifications=1
+	route_addition_check $ip $notify $route $expected_num_notifications
+
 	log_test "IPv4 route addition"
 }
 
@@ -185,11 +220,55 @@ ipv4_route_replacement_test()
 	expected_num_notifications=2
 	route_replacement_check $ip $notify $route $expected_num_notifications
 
+	# notify=2 means emit notifications only for failed route installation,
+	# make sure a single notification will be emitted for the new route.
+	notify=2
+	expected_num_notifications=1
+	route_replacement_check $ip $notify $route $expected_num_notifications
+
 	$IP link del name dummy2
 
 	log_test "IPv4 route replacement"
 }
 
+ipv4_route_offload_failed_test()
+{
+
+	RET=0
+
+	local ip="ipv4"
+	local route=192.0.2.0/24
+	local offload_failed=1
+
+	echo "y"> $DEBUGFS_DIR/fib/fail_route_offload
+	check_err $? "Failed to setup route offload to fail"
+
+	# Make sure a single notification will be emitted for the programmed
+	# route.
+	local notify=0
+	local expected_num_notifications=1
+	route_addition_check $ip $notify $route $expected_num_notifications \
+		$offload_failed
+
+	# Make sure two notifications will be emitted for the new route.
+	notify=1
+	expected_num_notifications=2
+	route_addition_check $ip $notify $route $expected_num_notifications \
+		$offload_failed
+
+	# notify=2 means emit notifications only for failed route installation,
+	# make sure two notifications will be emitted for the new route.
+	notify=2
+	expected_num_notifications=2
+	route_addition_check $ip $notify $route $expected_num_notifications \
+		$offload_failed
+
+	echo "n"> $DEBUGFS_DIR/fib/fail_route_offload
+	check_err $? "Failed to setup route offload not to fail"
+
+	log_test "IPv4 route offload failed"
+}
+
 ipv6_route_addition_test()
 {
 	RET=0
@@ -208,6 +287,13 @@ ipv6_route_addition_test()
 	expected_num_notifications=2
 	route_addition_check $ip $notify $route $expected_num_notifications
 
+	# notify=2 means emit notifications only for failed route installation,
+	# make sure a single notification will be emitted for the programmed
+	# route.
+	notify=2
+	expected_num_notifications=1
+	route_addition_check $ip $notify $route $expected_num_notifications
+
 	log_test "IPv6 route addition"
 }
 
@@ -250,11 +336,55 @@ ipv6_route_replacement_test()
 	expected_num_notifications=2
 	route_replacement_check $ip $notify $route $expected_num_notifications
 
+	# notify=2 means emit notifications only for failed route installation,
+	# make sure a single notification will be emitted for the new route.
+	notify=2
+	expected_num_notifications=1
+	route_replacement_check $ip $notify $route $expected_num_notifications
+
 	$IP link del name dummy2
 
 	log_test "IPv6 route replacement"
 }
 
+ipv6_route_offload_failed_test()
+{
+
+	RET=0
+
+	local ip="ipv6"
+	local route=2001:db8:1::/64
+	local offload_failed=1
+
+	echo "y"> $DEBUGFS_DIR/fib/fail_route_offload
+	check_err $? "Failed to setup route offload to fail"
+
+	# Make sure a single notification will be emitted for the programmed
+	# route.
+	local notify=0
+	local expected_num_notifications=1
+	route_addition_check $ip $notify $route $expected_num_notifications \
+		$offload_failed
+
+	# Make sure two notifications will be emitted for the new route.
+	notify=1
+	expected_num_notifications=2
+	route_addition_check $ip $notify $route $expected_num_notifications \
+		$offload_failed
+
+	# notify=2 means emit notifications only for failed route installation,
+	# make sure two notifications will be emitted for the new route.
+	notify=2
+	expected_num_notifications=2
+	route_addition_check $ip $notify $route $expected_num_notifications \
+		$offload_failed
+
+	echo "n"> $DEBUGFS_DIR/fib/fail_route_offload
+	check_err $? "Failed to setup route offload not to fail"
+
+	log_test "IPv6 route offload failed"
+}
+
 setup_prepare()
 {
 	modprobe netdevsim &> /dev/null
-- 
2.29.2

