Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59DA561466
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfGGIEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:04:04 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:44307 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfGGIED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:04:03 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 43337110B;
        Sun,  7 Jul 2019 04:04:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:04:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=TW4AWZX12WAGxIz/iNxqULHMuTDClbgL9vZg71Nu2kY=; b=UK4L4yKo
        UtU0RFglIbZEjQvbZXmbiSL35NG9xyrgAe8Il/EJWexto8GAwk7eM1YSCc91SNaL
        mn2c7wzEotXd/eckkNWnShp1pph4Z9SunlC4fhlEAq2NuA2WxxiLU5Xl/QKAVXIP
        uJ5iL13IjwlyzXkNRnHMXpPo90xXEW4njApUUiVtyPuaqUCMDW1QYVFEi1Q40ymL
        g7yUyG+6PSCIX4B17uH0jmc+3wfZ0OV7muEku3XmV8c2/2htX5jEOPv6wbVzdCjK
        FsboRd943mQ0CDjuFk73MqNjlJ6IRVMOoYIQHoahrohCB4okE+YyxAjHURNHf+Ey
        +60XOka3A/xW7Q==
X-ME-Sender: <xms:cqchXX-MjpZOqLVVSvLuKxwM4lZ2vw89dlFZRKnjTbwRT72YT_Zqcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:cqchXZMLnx6KIn5DwFgTnVqr8b2keOaGM94KAm12wvdasI0elUT_AQ>
    <xmx:cqchXdWWvHX1MVoc-VzPu5w9BfoBp17ZrnlyEkYUqpD_7Yqxc3Bo1g>
    <xmx:cqchXRhW4u7wb7J9oFOpkUt2akw5-TjC9AO14zlzT4b6gqFNKEIVAQ>
    <xmx:cqchXWhiO_oxAbISxYNxJTrwM7jxuMoWEy88QCi4_Lkg2tNqHTTiYg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 707FE8005C;
        Sun,  7 Jul 2019 04:03:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 1/5] selftests: devlink_trap: Add test cases for devlink-trap
Date:   Sun,  7 Jul 2019 11:03:32 +0300
Message-Id: <20190707080336.3794-2-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707080336.3794-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
 <20190707080336.3794-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Add test cases for devlink-trap on top of the netdevsim implementation.

The tests focus on the devlink-trap core infrastructure and user space
API. They test both good and bad flows and also dismantle of the netdev
and devlink device used to report trapped packets.

This allows device drivers to focus their tests on device-specific
functionality.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 tools/testing/selftests/net/Makefile        |   2 +-
 tools/testing/selftests/net/config          |   1 +
 tools/testing/selftests/net/devlink_trap.sh | 792 ++++++++++++++++++++
 3 files changed, 794 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/devlink_trap.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 1b24e36b4047..bb9ac949ba0e 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -10,7 +10,7 @@ TEST_PROGS += fib_tests.sh fib-onlink-tests.sh pmtu.sh udpgso.sh ip_defrag.sh
 TEST_PROGS += udpgso_bench.sh fib_rule_tests.sh msg_zerocopy.sh psock_snd.sh
 TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_any.sh
 TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
-TEST_PROGS += tcp_fastopen_backup_key.sh
+TEST_PROGS += tcp_fastopen_backup_key.sh devlink_trap.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index e4b878d95ba0..615857b89ead 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -28,3 +28,4 @@ CONFIG_NFT_CHAIN_NAT_IPV4=m
 CONFIG_NET_SCH_FQ=m
 CONFIG_NET_SCH_ETF=m
 CONFIG_TEST_BLACKHOLE_DEV=m
+CONFIG_NETDEVSIM=y
diff --git a/tools/testing/selftests/net/devlink_trap.sh b/tools/testing/selftests/net/devlink_trap.sh
new file mode 100755
index 000000000000..504d9dbe9d69
--- /dev/null
+++ b/tools/testing/selftests/net/devlink_trap.sh
@@ -0,0 +1,792 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# This test is for checking devlink-trap functionality. It makes use of
+# netdevsim which implements the required callbacks.
+
+##############################################################################
+# Global variables
+
+# Kselftest framework requirement - SKIP code is 4.
+KSFT_SKIP=4
+# Exit status to return at the end. Set in case one of the tests fails.
+EXIT_STATUS=0
+# Per-test return value. Clear at the beginning of each test.
+RET=0
+
+# netdevsim-specific variables.
+NETDEVSIM_PATH=/sys/bus/netdevsim/
+DEV_ADDR=1337
+SLEEP_TIME=.3
+DEVLINK_DEV=""
+NETDEV=""
+DEV=""
+
+##############################################################################
+# Dependencies
+
+if [ "$(id -u)" -ne 0 ]; then
+	echo "SKIP: Need root privileges"
+	exit $KSFT_SKIP
+fi
+
+if [ ! -d "$NETDEVSIM_PATH" ]; then
+	echo "SKIP: No netdevsim support"
+	exit $KSFT_SKIP
+fi
+
+if [ -d "${NETDEVSIM_PATH}/devices/netdevsim${DEV_ADDR}" ]; then
+	echo "SKIP: Device netdevsim${DEV_ADDR} already exists"
+	exit $KSFT_SKIP
+fi
+
+if [ ! -x "$(command -v jq)" ]; then
+	echo "SKIP: Could not run test without jq tool"
+	exit $KSFT_SKIP
+fi
+
+if [ ! -x "$(command -v udevadm)" ]; then
+	echo "SKIP: Could not run test without udevadm tool"
+	exit $KSFT_SKIP
+fi
+
+if [ ! -x "$(command -v ip)" ]; then
+	echo "SKIP: Could not run test without ip tool"
+	exit $KSFT_SKIP
+fi
+
+if [ ! -x "$(command -v devlink)" ]; then
+	echo "SKIP: Could not run test without devlink tool"
+	exit $KSFT_SKIP
+fi
+
+devlink help 2>&1 | grep -q "trap"
+if [ $? -ne 0 ]; then
+	echo "SKIP: iproute2 too old, missing devlink-trap"
+	exit $KSFT_SKIP
+fi
+
+##############################################################################
+# Helpers
+
+check_err()
+{
+	local err=$1; shift
+	local msg=$1; shift
+
+	if [[ $RET -eq 0 && $err -ne 0 ]]; then
+		RET=$err
+		RETMSG=$msg
+	fi
+}
+
+check_fail()
+{
+	local err=$1; shift
+	local msg=$1; shift
+
+	if [[ $RET -eq 0 && $err -eq 0 ]]; then
+		RET=1
+		RETMSG=$msg
+	fi
+}
+
+log_test()
+{
+	local test_name=$1
+	local opt_str=$2
+
+	if [[ $# -eq 2 ]]; then
+		opt_str="($opt_str)"
+	fi
+
+	if [[ $RET -ne 0 ]]; then
+		EXIT_STATUS=1
+		printf "TEST: %-60s  [FAIL]\n" "$test_name $opt_str"
+		if [[ ! -z "$RETMSG" ]]; then
+			printf "\t%s\n" "$RETMSG"
+		fi
+		return 1
+	fi
+
+	printf "TEST: %-60s  [ OK ]\n" "$test_name $opt_str"
+	return 0
+}
+
+netdevsim_dev_create()
+{
+	echo "$DEV_ADDR 0" > ${NETDEVSIM_PATH}/new_device
+}
+
+netdevsim_dev_destroy()
+{
+	echo "$DEV_ADDR" > ${NETDEVSIM_PATH}/del_device
+}
+
+netdevsim_port_create()
+{
+	echo 1 > ${NETDEVSIM_PATH}/devices/${DEV}/new_port
+}
+
+netdevsim_port_destroy()
+{
+	echo 1 > ${NETDEVSIM_PATH}/devices/${DEV}/del_port
+}
+
+##############################################################################
+# Trap helpers
+
+devlink_traps_num_get()
+{
+	devlink -j trap | jq '.[]["'$DEVLINK_DEV'"] | length'
+}
+
+devlink_traps_get()
+{
+	devlink -j trap | jq -r '.[]["'$DEVLINK_DEV'"][].name'
+}
+
+devlink_trap_report_set()
+{
+	local trap_name=$1; shift
+	local report=$1; shift
+
+	# Pipe output to /dev/null to avoid expected warnings.
+	devlink trap set $DEVLINK_DEV trap $trap_name report $report \
+		&> /dev/null
+}
+
+devlink_trap_report_get()
+{
+	local trap_name=$1; shift
+
+	devlink -j trap show $DEVLINK_DEV trap $trap_name \
+		| jq '.[][][].report'
+}
+
+devlink_trap_type_get()
+{
+	local trap_name=$1; shift
+
+	devlink -j trap show $DEVLINK_DEV trap $trap_name \
+		| jq -r '.[][][].type'
+}
+
+devlink_trap_action_set()
+{
+	local trap_name=$1; shift
+	local action=$1; shift
+
+	# Pipe output to /dev/null to avoid expected warnings.
+	devlink trap set $DEVLINK_DEV trap $trap_name \
+		action $action &> /dev/null
+}
+
+devlink_trap_action_get()
+{
+	local trap_name=$1; shift
+
+	devlink -j trap show $DEVLINK_DEV trap $trap_name \
+		| jq -r '.[][][].action'
+}
+
+devlink_trap_group_get()
+{
+	devlink -j trap show $DEVLINK_DEV trap $trap_name \
+		| jq -r '.[][][].group'
+}
+
+devlink_trap_metadata_test()
+{
+	local trap_name=$1; shift
+	local metadata=$1; shift
+
+	devlink -jv trap show $DEVLINK_DEV trap $trap_name \
+		| jq -e '.[][][].metadata | contains(["'$metadata'"])' \
+		&> /dev/null
+}
+
+devlink_trap_rx_packets_get()
+{
+	local trap_name=$1; shift
+
+	devlink -js trap show $DEVLINK_DEV trap $trap_name \
+		| jq '.[][][]["stats"]["rx"]["packets"]'
+}
+
+devlink_trap_rx_bytes_get()
+{
+	local trap_name=$1; shift
+
+	devlink -js trap show $DEVLINK_DEV trap $trap_name \
+		| jq '.[][][]["stats"]["rx"]["bytes"]'
+}
+
+devlink_trap_stats_idle_test()
+{
+	local trap_name=$1; shift
+	local t0_packets t0_bytes
+	local t1_packets t1_bytes
+
+	t0_packets=$(devlink_trap_rx_packets_get $trap_name)
+	t0_bytes=$(devlink_trap_rx_bytes_get $trap_name)
+
+	sleep $SLEEP_TIME
+
+	t1_packets=$(devlink_trap_rx_packets_get $trap_name)
+	t1_bytes=$(devlink_trap_rx_bytes_get $trap_name)
+
+	if [[ $t0_packets -eq $t1_packets && $t0_bytes -eq $t1_bytes ]]; then
+		return 0
+	else
+		return 1
+	fi
+}
+
+devlink_trap_mon_idle_test()
+{
+	local trap_name=$1; shift
+	local devlink_pid
+	local tmp_dir
+	local rc
+
+	tmp_dir="$(mktemp -d)"
+
+	timeout $SLEEP_TIME devlink mon trap-report &> ${tmp_dir}/reports.txt
+
+	grep -e "$DEVLINK_DEV" ${tmp_dir}/reports.txt | grep -q -e "$trap_name"
+
+	# Return true if no reports were found.
+	if [ $? -ne 0 ]; then
+		rc=0
+	else
+		rc=1
+	fi
+
+	rm -rf $tmp_dir
+
+	return $rc
+}
+
+devlink_traps_enable_all()
+{
+	local trap_name
+
+	for trap_name in $(devlink_traps_get); do
+		devlink_trap_report_set $trap_name "true"
+		devlink_trap_action_set $trap_name "trap"
+	done
+}
+
+devlink_traps_disable_all()
+{
+	for trap_name in $(devlink_traps_get); do
+		devlink_trap_report_set $trap_name "false"
+		devlink_trap_action_set $trap_name "drop"
+	done
+}
+
+##############################################################################
+# Trap group helpers
+
+devlink_trap_groups_get()
+{
+	devlink -j trap group | jq -r '.[]["'$DEVLINK_DEV'"][].name'
+}
+
+devlink_trap_group_report_set()
+{
+	local group_name=$1; shift
+	local report=$1; shift
+
+	# Pipe output to /dev/null to avoid expected warnings.
+	devlink trap group set $DEVLINK_DEV group $group_name report $report \
+		&> /dev/null
+}
+
+devlink_trap_group_action_set()
+{
+	local group_name=$1; shift
+	local action=$1; shift
+
+	# Pipe output to /dev/null to avoid expected warnings.
+	devlink trap group set $DEVLINK_DEV group $group_name action $action \
+		&> /dev/null
+}
+
+devlink_trap_group_rx_packets_get()
+{
+	local group_name=$1; shift
+
+	devlink -js trap group show $DEVLINK_DEV group $group_name \
+		| jq '.[][][]["stats"]["rx"]["packets"]'
+}
+
+devlink_trap_group_rx_bytes_get()
+{
+	local group_name=$1; shift
+
+	devlink -js trap group show $DEVLINK_DEV group $group_name \
+		| jq '.[][][]["stats"]["rx"]["bytes"]'
+}
+
+devlink_trap_group_stats_idle_test()
+{
+	local group_name=$1; shift
+	local t0_packets t0_bytes
+	local t1_packets t1_bytes
+
+	t0_packets=$(devlink_trap_group_rx_packets_get $group_name)
+	t0_bytes=$(devlink_trap_group_rx_bytes_get $group_name)
+
+	sleep $SLEEP_TIME
+
+	t1_packets=$(devlink_trap_group_rx_packets_get $group_name)
+	t1_bytes=$(devlink_trap_group_rx_bytes_get $group_name)
+
+	if [[ $t0_packets -eq $t1_packets && $t0_bytes -eq $t1_bytes ]]; then
+		return 0
+	else
+		return 1
+	fi
+}
+
+##############################################################################
+# Initialization
+
+setup_prepare()
+{
+	local netdev
+
+	DEV=netdevsim${DEV_ADDR}
+	DEVLINK_DEV=netdevsim/${DEV}
+
+	netdevsim_dev_create
+
+	if [ ! -d "${NETDEVSIM_PATH}/devices/${DEV}" ]; then
+		echo "Failed to create netdevsim device"
+		exit 1
+	fi
+
+	netdevsim_port_create
+
+	if [ ! -d "${NETDEVSIM_PATH}/devices/${DEV}/net/" ]; then
+		echo "Failed to create netdevsim port"
+		exit 1
+	fi
+
+	# Wait for udev to rename newly created netdev.
+	udevadm settle
+
+	NETDEV=$(ls ${NETDEVSIM_PATH}/devices/${DEV}/net/)
+}
+
+cleanup()
+{
+	netdevsim_port_destroy
+	netdevsim_dev_destroy
+}
+
+##############################################################################
+# Tests
+
+init_test()
+{
+	RET=0
+
+	test $(devlink_traps_num_get) -ne 0
+	check_err $? "No traps were registered"
+
+	devlink -j trap \
+		| jq -e '.[]["'$DEVLINK_DEV'"][] | select (.report == true)'
+	check_fail $? "Traps were not registered with report set to 'false'"
+
+	log_test "Initialization"
+}
+
+trap_report_test()
+{
+	local trap_name
+
+	RET=0
+
+	for trap_name in $(devlink_traps_get); do
+		devlink_trap_report_set $trap_name "true"
+		if [ $(devlink_trap_report_get $trap_name) != "true" ]; then
+			check_err 1 "Trap $trap_name did not enable reporting"
+		fi
+
+		devlink_trap_report_set $trap_name "false"
+		if [ $(devlink_trap_report_get $trap_name) != "false" ]; then
+			check_err 1 "Trap $trap_name did not disable reporting"
+		fi
+	done
+
+	log_test "Trap report"
+}
+
+trap_action_test()
+{
+	local orig_action
+	local trap_name
+	local action
+
+	RET=0
+
+	for trap_name in $(devlink_traps_get); do
+		# The action of non-drop traps cannot be changed.
+		if [ $(devlink_trap_type_get $trap_name) = "drop" ]; then
+			devlink_trap_action_set $trap_name "trap"
+			action=$(devlink_trap_action_get $trap_name)
+			if [ $action != "trap" ]; then
+				check_err 1 "Trap $trap_name did not change action to trap"
+			fi
+
+			devlink_trap_action_set $trap_name "drop"
+			action=$(devlink_trap_action_get $trap_name)
+			if [ $action != "drop" ]; then
+				check_err 1 "Trap $trap_name did not change action to drop"
+			fi
+		else
+			orig_action=$(devlink_trap_action_get $trap_name)
+
+			devlink_trap_action_set $trap_name "trap"
+			action=$(devlink_trap_action_get $trap_name)
+			if [ $action != $orig_action ]; then
+				check_err 1 "Trap $trap_name changed action when should not"
+			fi
+
+			devlink_trap_action_set $trap_name "drop"
+			action=$(devlink_trap_action_get $trap_name)
+			if [ $action != $orig_action ]; then
+				check_err 1 "Trap $trap_name changed action when should not"
+			fi
+		fi
+	done
+
+	log_test "Trap action"
+}
+
+trap_metadata_test()
+{
+	local trap_name
+
+	RET=0
+
+	for trap_name in $(devlink_traps_get); do
+		devlink_trap_metadata_test $trap_name "input_port"
+		check_err $? "Input port not reported as metadata of trap $trap_name"
+	done
+
+	log_test "Trap metadata"
+}
+
+bad_trap_test()
+{
+	RET=0
+
+	devlink_trap_action_set "made_up_trap" "drop"
+	check_fail $? "Did not get an error for non-existing trap"
+
+	log_test "Non-existing trap"
+}
+
+bad_trap_action_test()
+{
+	local traps_arr
+	local trap_name
+
+	RET=0
+
+	# Pick first trap.
+	traps_arr=($(devlink_traps_get))
+	trap_name=${traps_arr[0]}
+
+	devlink_trap_action_set $trap_name "made_up_action"
+	check_fail $? "Did not get an error for non-existing trap action"
+
+	log_test "Non-existing trap action"
+}
+
+bad_trap_report_test()
+{
+	local traps_arr
+	local trap_name
+
+	RET=0
+
+	# Pick first trap.
+	traps_arr=($(devlink_traps_get))
+	trap_name=${traps_arr[0]}
+
+	devlink_trap_report_set $trap_name "made_up_report"
+	check_fail $? "Did not get an error for invalid trap report value"
+
+	log_test "Non-existing trap report value"
+}
+
+trap_stats_test()
+{
+	local trap_name
+
+	RET=0
+
+	for trap_name in $(devlink_traps_get); do
+		devlink_trap_stats_idle_test $trap_name
+		check_err $? "Stats of trap $trap_name not idle when netdev down"
+
+		ip link set dev $NETDEV up
+
+		if [ $(devlink_trap_type_get $trap_name) = "drop" ]; then
+			devlink_trap_action_set $trap_name "trap"
+			devlink_trap_stats_idle_test $trap_name
+			check_fail $? "Stats of trap $trap_name idle when action is trap"
+
+			devlink_trap_action_set $trap_name "drop"
+			devlink_trap_stats_idle_test $trap_name
+			check_err $? "Stats of trap $trap_name not idle when action is drop"
+		else
+			devlink_trap_stats_idle_test $trap_name
+			check_fail $? "Stats of non-drop trap $trap_name idle when should not"
+		fi
+
+		ip link set dev $NETDEV down
+	done
+
+	log_test "Trap statistics"
+}
+
+trap_mon_test()
+{
+	local trap_name
+
+	RET=0
+
+	ip link set dev $NETDEV up
+
+	for trap_name in $(devlink_traps_get); do
+		devlink_trap_mon_idle_test $trap_name
+		check_err $? "Received trap reports for trap $trap_name when reporting disabled"
+
+		devlink_trap_action_set $trap_name "trap"
+		devlink_trap_mon_idle_test $trap_name
+		check_err $? "Received trap reports for trap $trap_name when reporting disabled and action set to trap"
+
+		devlink_trap_report_set $trap_name "true"
+		devlink_trap_mon_idle_test $trap_name
+		check_fail $? "Did not receive trap reports for trap $trap_name when reporting enabled"
+
+		devlink_trap_report_set $trap_name "false"
+		devlink_trap_mon_idle_test $trap_name
+		check_err $? "Received trap reports for trap $trap_name after disabling reporting"
+
+		devlink_trap_action_set $trap_name "drop"
+	done
+
+	ip link set dev $NETDEV down
+
+	log_test "Trap monitor"
+}
+
+trap_group_report_test()
+{
+	local curr_group group_name
+	local trap_name
+	local report
+
+	RET=0
+
+	for group_name in $(devlink_trap_groups_get); do
+		devlink_trap_group_report_set $group_name "true"
+
+		for trap_name in $(devlink_traps_get); do
+			curr_group=$(devlink_trap_group_get $trap_name)
+			if [ $curr_group != $group_name ]; then
+				continue
+			fi
+
+			report=$(devlink_trap_report_get $trap_name)
+			if [ $report != "true" ]; then
+				check_err 1 "Trap $trap_name did not enable reporting"
+			fi
+		done
+
+		devlink_trap_group_report_set $group_name "false"
+
+		for trap_name in $(devlink_traps_get); do
+			curr_group=$(devlink_trap_group_get $trap_name)
+			if [ $curr_group != $group_name ]; then
+				continue
+			fi
+
+			report=$(devlink_trap_report_get $trap_name)
+			if [ $report != "false" ]; then
+				check_err 1 "Trap $trap_name did not disable reporting"
+			fi
+		done
+	done
+
+	log_test "Trap group report"
+}
+
+trap_group_action_test()
+{
+	local curr_group group_name
+	local trap_name
+	local trap_type
+	local action
+
+	RET=0
+
+	for group_name in $(devlink_trap_groups_get); do
+		devlink_trap_group_action_set $group_name "trap"
+
+		for trap_name in $(devlink_traps_get); do
+			curr_group=$(devlink_trap_group_get $trap_name)
+			if [ $curr_group != $group_name ]; then
+				continue
+			fi
+
+			trap_type=$(devlink_trap_type_get $trap_name)
+			if [ $trap_type != "drop" ]; then
+				continue
+			fi
+
+			action=$(devlink_trap_action_get $trap_name)
+			if [ $action != "trap" ]; then
+				check_err 1 "Trap $trap_name did not change action to trap"
+			fi
+		done
+
+		devlink_trap_group_action_set $group_name "drop"
+
+		for trap_name in $(devlink_traps_get); do
+			curr_group=$(devlink_trap_group_get $trap_name)
+			if [ $curr_group != $group_name ]; then
+				continue
+			fi
+
+			trap_type=$(devlink_trap_type_get $trap_name)
+			if [ $trap_type != "drop" ]; then
+				continue
+			fi
+
+			action=$(devlink_trap_action_get $trap_name)
+			if [ $action != "drop" ]; then
+				check_err 1 "Trap $trap_name did not change action to drop"
+			fi
+		done
+	done
+
+	log_test "Trap group action"
+}
+
+bad_trap_group_test()
+{
+	RET=0
+
+	devlink_trap_group_action_set "made_up_trap_group" "drop"
+	check_fail $? "Did not get an error for non-existing trap group"
+
+	log_test "Non-existing trap group"
+}
+
+trap_group_stats_test()
+{
+	local group_name
+
+	RET=0
+
+	for group_name in $(devlink_trap_groups_get); do
+		devlink_trap_group_stats_idle_test $group_name
+		check_err $? "Stats of trap group $group_name not idle when netdev down"
+
+		ip link set dev $NETDEV up
+
+		devlink_trap_group_action_set $group_name "trap"
+		devlink_trap_group_stats_idle_test $group_name
+		check_fail $? "Stats of trap group $group_name idle when action is trap"
+
+		devlink_trap_group_action_set $group_name "drop"
+		ip link set dev $NETDEV down
+	done
+
+	log_test "Trap group statistics"
+}
+
+port_del_test()
+{
+	local group_name
+	local i
+
+	# The test never fails. It is meant to exercise different code paths
+	# and make sure we properly dismantle a port while packets are
+	# in-flight.
+	RET=0
+
+	# Make sure we have packets reported to user space.
+	devlink_traps_enable_all
+
+	for i in $(seq 1 10); do
+		ip link set dev $NETDEV up
+
+		sleep $SLEEP_TIME
+
+		netdevsim_port_destroy
+		netdevsim_port_create
+		udevadm settle
+	done
+
+	devlink_traps_disable_all
+
+	log_test "Port delete"
+}
+
+dev_del_test()
+{
+	local group_name
+	local i
+
+	# The test never fails. It is meant to exercise different code paths
+	# and make sure we properly unregister traps while packets are
+	# in-flight.
+	RET=0
+
+	# Make sure we have packets reported to user space.
+	devlink_traps_enable_all
+
+	for i in $(seq 1 10); do
+		ip link set dev $NETDEV up
+
+		sleep $SLEEP_TIME
+
+		cleanup
+		setup_prepare
+	done
+
+	devlink_traps_disable_all
+
+	log_test "Device delete"
+}
+
+trap cleanup EXIT
+
+# Each test should make sure that initial state is resumed at the end.
+setup_prepare
+init_test
+trap_report_test
+trap_action_test
+trap_metadata_test
+bad_trap_test
+bad_trap_action_test
+bad_trap_report_test
+trap_stats_test
+trap_mon_test
+trap_group_report_test
+trap_group_action_test
+bad_trap_group_test
+trap_group_stats_test
+port_del_test
+dev_del_test
+
+exit $EXIT_STATUS
-- 
2.20.1

