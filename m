Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1BB097341
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 09:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbfHUHUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 03:20:40 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49755 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728221AbfHUHUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 03:20:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E3BF52205C;
        Wed, 21 Aug 2019 03:20:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 21 Aug 2019 03:20:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=uKScoXQxM+hSmcMqbaxVpNyFxzAMCxDno2K39GpLhoI=; b=bcy3ddim
        RPNZRuI/g/bnyaEHlb0UGGXy7C8fEd5NwNn3YxFfCpuACKWJ69BzUXPgbkC99VWH
        pmI2YiNOym1r+Fz92bMP+thzaGM+1d6KcMLMheMSZy6cF9qEpkDHLEDKVDYFd665
        BSYG28+CPc+WycTpv3BjCRf3xUlNk4rP36NnWiT6aMm9WseKXAQxmlWRPqWU/Tz8
        A8TV4Afe7fe0Mqqa20T5e8DUC4O6KxY2UNMhrVbBeDUky4fB5ZFdA2GfNka2DwZD
        MPrS6aQpvv/NZmEVJTEycVNcoH24CraSbEDK1XXuHzV8Vl5sQ9iV+cCkJASzQjRf
        5iTltVt+Lo9LJQ==
X-ME-Sender: <xms:xfBcXYe8dUVfySuhMaiIywPugS68kILHfz8EaWKHv6U9LILbxZ6VXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudegvddguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgepie
X-ME-Proxy: <xmx:xfBcXYskV3emqwM6pvaSfaGRTySOODwHhKbkIpRtgRQLho9I2our8g>
    <xmx:xfBcXfupBPGupTmEW891d7zM9TJWCq1Gy1XRK8cBsfG6LA2GjdnsZA>
    <xmx:xfBcXSuOXCoO1R5gUNfFIGqk9lVyg52tkFfOpcx_v_giwQkn00q6HQ>
    <xmx:xfBcXQCjv2RpjQh47MpgBtSxH0L0wvU0huGapRBfufMsIr2FHNCxaw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E3375D60057;
        Wed, 21 Aug 2019 03:20:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 7/7] selftests: mlxsw: Add a test case for devlink-trap
Date:   Wed, 21 Aug 2019 10:19:37 +0300
Message-Id: <20190821071937.13622-8-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190821071937.13622-1-idosch@idosch.org>
References: <20190821071937.13622-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Test generic devlink-trap functionality over mlxsw. These tests are not
specific to a single trap, but do not check the devlink-trap common
infrastructure either.

Currently, the only test case is device deletion (by reloading the
driver) while packets are being trapped.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/mlxsw/devlink_trap.sh         | 129 ++++++++++++++++++
 1 file changed, 129 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap.sh
new file mode 100755
index 000000000000..89b55e946eed
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap.sh
@@ -0,0 +1,129 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test generic devlink-trap functionality over mlxsw. These tests are not
+# specific to a single trap, but do not check the devlink-trap common
+# infrastructure either.
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	dev_del_test
+"
+NUM_NETIFS=4
+source $lib_dir/tc_common.sh
+source $lib_dir/lib.sh
+source $lib_dir/devlink_lib.sh
+
+h1_create()
+{
+	simple_if_init $h1
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1
+}
+
+h2_create()
+{
+	simple_if_init $h2
+}
+
+h2_destroy()
+{
+	simple_if_fini $h2
+}
+
+switch_create()
+{
+	ip link add dev br0 type bridge vlan_filtering 1 mcast_snooping 0
+
+	ip link set dev $swp1 master br0
+	ip link set dev $swp2 master br0
+
+	ip link set dev br0 up
+	ip link set dev $swp1 up
+	ip link set dev $swp2 up
+}
+
+switch_destroy()
+{
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+
+	ip link del dev br0
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	swp2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+dev_del_test()
+{
+	local trap_name="source_mac_is_multicast"
+	local smac=01:02:03:04:05:06
+	local num_iter=5
+	local mz_pid
+	local i
+
+	$MZ $h1 -c 0 -p 100 -a $smac -b bcast -t ip -q &
+	mz_pid=$!
+
+	# The purpose of this test is to make sure we correctly dismantle a
+	# port while packets are trapped from it. This is done by reloading the
+	# the driver while the 'ingress_smac_mc_drop' trap is triggered.
+	RET=0
+
+	for i in $(seq 1 $num_iter); do
+		log_info "Iteration $i / $num_iter"
+
+		devlink_trap_action_set $trap_name "trap"
+		sleep 1
+
+		devlink_reload
+		# Allow netdevices to be re-created following the reload
+		sleep 20
+
+		cleanup
+		setup_prepare
+		setup_wait
+	done
+
+	log_test "Device delete"
+
+	kill $mz_pid && wait $mz_pid &> /dev/null
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.21.0

