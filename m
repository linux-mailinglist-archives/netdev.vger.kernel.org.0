Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155BC6146A
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfGGIEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:04:14 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:53677 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfGGIEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:04:13 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 562E810C1;
        Sun,  7 Jul 2019 04:04:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:04:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=PV+fn2vemsXVAVxVshNQ7xt7/QHldGk4wNxIbRvMIUo=; b=PWmwT+Ma
        gmafITnwxJGatEKVxkDru0E9bHJzCzxnVZv0IydtEXj1/NdjHkKzw5+qI6jpgxEU
        uqzwr0XXW76wG84jvM9blBrlJR0NVX00HWEbNDzOpiqZ40cv7DwPEVNxv6LPh+mo
        TrRmn4m5+viwKrP5AS7hKsOvCrrqlTofrNP33Qv90GggJdfSV03SrW/5xsczaJRr
        axkiqyDOnIwRao1iPROqCTTLFXU+tECUvvFzaqAfYMKhUmcgHMGEzz0RcCdVvcS3
        9OLWgBEAZQAhLykbbERTJZW450Pn40l3NqALGjDbiPl1yh8IIeWrmgWnedbUOGEW
        X/Rha23FEql9Pg==
X-ME-Sender: <xms:fKchXQ1EZ79UZmdlIOOGC8I-WGMhzVwpHm1G-ENmQcalBV0KOBK0-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:fKchXYqtPKf81KNeJcpZGQncW3UpjRMze0itfqRahhNZVNOf_SDebw>
    <xmx:fKchXaO3lChn6CI1EKeEeosOu37Ob0e5ZnleGIpA3Et_Ky-ScmIdrQ>
    <xmx:fKchXUNHpMBmag90k-AsU1LtZjlfLKSo8acHRgq0AhpqlYpnLySSDw>
    <xmx:fKchXZQ3yEY1acvRXOIRoTUwX98jO7yFd-5GMZo2FVqUWxmFTIq_zQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C2BC18005B;
        Sun,  7 Jul 2019 04:04:09 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 5/5] selftests: mlxsw: Add a test case for devlink-trap
Date:   Sun,  7 Jul 2019 11:03:36 +0300
Message-Id: <20190707080336.3794-6-idosch@idosch.org>
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

Test generic devlink-trap functionality over mlxsw. These tests are not
specific to a single trap, but do not check the devlink-trap common
infrastructure either.

Currently, the only test case is device deletion (by reloading the
driver) while packets are being trapped.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/mlxsw/devlink_trap.sh         | 130 ++++++++++++++++++
 1 file changed, 130 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap.sh
new file mode 100755
index 000000000000..8e1d0dc44256
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap.sh
@@ -0,0 +1,130 @@
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
+		devlink_trap_report_set $trap_name "true"
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
2.20.1

