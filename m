Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C46027BF51
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgI2I0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:26:11 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:35875 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727746AbgI2I0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:26:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id F1D895807D7;
        Tue, 29 Sep 2020 04:17:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 29 Sep 2020 04:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=l1jrsL/NCa4jTi7QhGYfqgFPquFpgDW0c5HqQGYuh6Y=; b=c1fznVqe
        2Gpc4BvUimYNf7eR2xzqVAjxjK6j4yaB29abyv/y6xlrSJXoSiCZB10hxowrRTq4
        4VpCHM+E4C9eWW6lBKHPYCAkwB2/AIstHNCYitzEtSsCAmi/AdJ3TRZ/sA8igMp6
        RdWwB8CWeq4l/0z3rLd25uSrm/hsKTxSVRmWJ5AvIBQcmyO1SYaRJjduTV/wAqck
        mMygzh3hVHXdBev4rzUEvMoELxaA0Nsui55/yRb+GtzQeQDwUIIpvot8IdUWOjsS
        kk6CKk7rfnMzJrr/Oq+1ubG4ud9IdGfPpAJxooUUitt/Q2l+ypTIgxxt2VDsGFL+
        WvPI6zsU2zerUg==
X-ME-Sender: <xms:hu1yX7fKFClqu0RI3zSMIBVaXE1PNV1cLiZgsOOcE8IdUkjms3ysiA>
    <xme:hu1yXxPWpAZKekrgD9PqdQ6OUmG65RFp-Z35a-Oun83zyLUlaJ4iAi9g3HokXAup8
    khGluNUWULy7Y0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdekgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudegkeen
    ucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:hu1yX0iQaLcX2pymCMtvH8Pt8Sn1vxJjLz1-6OYQwfn_5dORVbEC9w>
    <xmx:hu1yX8-KacBH3GtSCQ7u7BBWLWFaKMmlLXMfuaSoEwxlUKmK_PS4cg>
    <xmx:hu1yX3vYvXTjf-_cDHLmhFg2VOgDyXRHmYQs1SDXPyDfNpPfsq5V7A>
    <xmx:hu1yXw8LjAwaD1lSlEN68_Pd49p9t58YxccNuUtFI2C5HnVj4irdMA>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id BC9EC3280059;
        Tue, 29 Sep 2020 04:17:08 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jiri@nvidia.com, roopa@nvidia.com, aroulin@nvidia.com,
        ayal@nvidia.com, masahiroy@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 7/7] selftests: net: Add drop monitor test
Date:   Tue, 29 Sep 2020 11:15:56 +0300
Message-Id: <20200929081556.1634838-8-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929081556.1634838-1-idosch@idosch.org>
References: <20200929081556.1634838-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Test that drop monitor correctly captures both software and hardware
originated packet drops.

# ./drop_monitor_tests.sh

Software drops test
    TEST: Capturing active software drops                               [ OK ]
    TEST: Capturing inactive software drops                             [ OK ]

Hardware drops test
    TEST: Capturing active hardware drops                               [ OK ]
    TEST: Capturing inactive hardware drops                             [ OK ]

Tests passed:   4
Tests failed:   0

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 tools/testing/selftests/net/Makefile          |   1 +
 tools/testing/selftests/net/config            |   3 +
 .../selftests/net/drop_monitor_tests.sh       | 215 ++++++++++++++++++
 3 files changed, 219 insertions(+)
 create mode 100755 tools/testing/selftests/net/drop_monitor_tests.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 9491bbaa0831..52923eb08934 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -19,6 +19,7 @@ TEST_PROGS += txtimestamp.sh
 TEST_PROGS += vrf-xfrm-tests.sh
 TEST_PROGS += rxtimestamp.sh
 TEST_PROGS += devlink_port_split.py
+TEST_PROGS += drop_monitor_tests.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 5a57ea02802d..43649242adc0 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -30,3 +30,6 @@ CONFIG_NET_SCH_ETF=m
 CONFIG_NET_SCH_NETEM=y
 CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_KALLSYMS=y
+CONFIG_TRACEPOINTS=y
+CONFIG_NET_DROP_MONITOR=m
+CONFIG_NETDEVSIM=m
diff --git a/tools/testing/selftests/net/drop_monitor_tests.sh b/tools/testing/selftests/net/drop_monitor_tests.sh
new file mode 100755
index 000000000000..b7650e30d18b
--- /dev/null
+++ b/tools/testing/selftests/net/drop_monitor_tests.sh
@@ -0,0 +1,215 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# This test is for checking drop monitor functionality.
+
+ret=0
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+# all tests in this script. Can be overridden with -t option
+TESTS="
+	sw_drops
+	hw_drops
+"
+
+IP="ip -netns ns1"
+TC="tc -netns ns1"
+DEVLINK="devlink -N ns1"
+NS_EXEC="ip netns exec ns1"
+NETDEVSIM_PATH=/sys/bus/netdevsim/
+DEV_ADDR=1337
+DEV=netdevsim${DEV_ADDR}
+DEVLINK_DEV=netdevsim/${DEV}
+
+log_test()
+{
+	local rc=$1
+	local expected=$2
+	local msg="$3"
+
+	if [ ${rc} -eq ${expected} ]; then
+		printf "    TEST: %-60s  [ OK ]\n" "${msg}"
+		nsuccess=$((nsuccess+1))
+	else
+		ret=1
+		nfail=$((nfail+1))
+		printf "    TEST: %-60s  [FAIL]\n" "${msg}"
+	fi
+}
+
+setup()
+{
+	modprobe netdevsim &> /dev/null
+
+	set -e
+	ip netns add ns1
+	$IP link add dummy10 up type dummy
+
+	$NS_EXEC echo "$DEV_ADDR 1" > ${NETDEVSIM_PATH}/new_device
+	udevadm settle
+	local netdev=$($NS_EXEC ls ${NETDEVSIM_PATH}/devices/${DEV}/net/)
+	$IP link set dev $netdev up
+
+	set +e
+}
+
+cleanup()
+{
+	$NS_EXEC echo "$DEV_ADDR" > ${NETDEVSIM_PATH}/del_device
+	ip netns del ns1
+}
+
+sw_drops_test()
+{
+	echo
+	echo "Software drops test"
+
+	setup
+
+	local dir=$(mktemp -d)
+
+	$TC qdisc add dev dummy10 clsact
+	$TC filter add dev dummy10 egress pref 1 handle 101 proto ip \
+		flower dst_ip 192.0.2.10 action drop
+
+	$NS_EXEC mausezahn dummy10 -a 00:11:22:33:44:55 -b 00:aa:bb:cc:dd:ee \
+		-A 192.0.2.1 -B 192.0.2.10 -t udp sp=12345,dp=54321 -c 0 -q \
+		-d 100msec &
+	timeout 5 dwdump -o sw -w ${dir}/packets.pcap
+	(( $(tshark -r ${dir}/packets.pcap \
+		-Y 'ip.dst == 192.0.2.10' 2> /dev/null | wc -l) != 0))
+	log_test $? 0 "Capturing active software drops"
+
+	rm ${dir}/packets.pcap
+
+	{ kill %% && wait %%; } 2>/dev/null
+	timeout 5 dwdump -o sw -w ${dir}/packets.pcap
+	(( $(tshark -r ${dir}/packets.pcap \
+		-Y 'ip.dst == 192.0.2.10' 2> /dev/null | wc -l) == 0))
+	log_test $? 0 "Capturing inactive software drops"
+
+	rm -r $dir
+
+	cleanup
+}
+
+hw_drops_test()
+{
+	echo
+	echo "Hardware drops test"
+
+	setup
+
+	local dir=$(mktemp -d)
+
+	$DEVLINK trap set $DEVLINK_DEV trap blackhole_route action trap
+	timeout 5 dwdump -o hw -w ${dir}/packets.pcap
+	(( $(tshark -r ${dir}/packets.pcap \
+		-Y 'net_dm.hw_trap_name== blackhole_route' 2> /dev/null \
+		| wc -l) != 0))
+	log_test $? 0 "Capturing active hardware drops"
+
+	rm ${dir}/packets.pcap
+
+	$DEVLINK trap set $DEVLINK_DEV trap blackhole_route action drop
+	timeout 5 dwdump -o hw -w ${dir}/packets.pcap
+	(( $(tshark -r ${dir}/packets.pcap \
+		-Y 'net_dm.hw_trap_name== blackhole_route' 2> /dev/null \
+		| wc -l) == 0))
+	log_test $? 0 "Capturing inactive hardware drops"
+
+	rm -r $dir
+
+	cleanup
+}
+
+################################################################################
+# usage
+
+usage()
+{
+	cat <<EOF
+usage: ${0##*/} OPTS
+
+        -t <test>   Test(s) to run (default: all)
+                    (options: $TESTS)
+EOF
+}
+
+################################################################################
+# main
+
+while getopts ":t:h" opt; do
+	case $opt in
+		t) TESTS=$OPTARG;;
+		h) usage; exit 0;;
+		*) usage; exit 1;;
+	esac
+done
+
+if [ "$(id -u)" -ne 0 ];then
+	echo "SKIP: Need root privileges"
+	exit $ksft_skip;
+fi
+
+if [ ! -x "$(command -v ip)" ]; then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v devlink)" ]; then
+	echo "SKIP: Could not run test without devlink tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v tshark)" ]; then
+	echo "SKIP: Could not run test without tshark tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v dwdump)" ]; then
+	echo "SKIP: Could not run test without dwdump tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v udevadm)" ]; then
+	echo "SKIP: Could not run test without udevadm tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v timeout)" ]; then
+	echo "SKIP: Could not run test without timeout tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v mausezahn)" ]; then
+	echo "SKIP: Could not run test without mausezahn tool"
+	exit $ksft_skip
+fi
+
+tshark -G fields 2> /dev/null | grep -q net_dm
+if [ $? -ne 0 ]; then
+	echo "SKIP: tshark too old, missing net_dm dissector"
+	exit $ksft_skip
+fi
+
+# start clean
+cleanup &> /dev/null
+
+for t in $TESTS
+do
+	case $t in
+	sw_drops|sw)			sw_drops_test;;
+	hw_drops|hw)			hw_drops_test;;
+
+	help) echo "Test names: $TESTS"; exit 0;;
+	esac
+done
+
+if [ "$TESTS" != "none" ]; then
+	printf "\nTests passed: %3d\n" ${nsuccess}
+	printf "Tests failed: %3d\n"   ${nfail}
+fi
+
+exit $ret
-- 
2.26.2

