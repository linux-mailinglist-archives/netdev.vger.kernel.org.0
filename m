Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2346612C25A
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 12:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfL2Ls7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 06:48:59 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54587 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726151AbfL2Ls5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 06:48:57 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8F10621E6A;
        Sun, 29 Dec 2019 06:48:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 29 Dec 2019 06:48:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=1uYHqzP9S2dI8vDs6V+nLVhyHSs5iBtWK3TUkzHi+78=; b=Xh70r1L2
        PLAH7Z2XOAvImFvGiUM6jxHGMw0rBLH6owfYszrZ9uEPAVkWv+WL05eKg7SBrfFG
        woBPow3pkK6B8UQdmljv8S/nxijYLxQrz3BBGNdgAgGXR0tOFhAZKewLwkbxJi8k
        BAMKp4cy7SmY5Xboe1Y8nz71w6FP74CWAIgiXHgAOlRvbk1Bm8UZhBrn/tgrLqda
        5rLMzgUgMV7M55jLuYxY2EwhIfpZ546SoaVPx0AFX2BWmkSH+3rKnOZG10nDLUNK
        YTs8HiipC6wYhWCLyaDMox4uiW40fuj5crv2hMGv3Clam9ocQzUk1igpBnoIMWZo
        74DBuXu0nyPLTQ==
X-ME-Sender: <xms:qJIIXggfMWiFpneox9PbYMkZ8H0f33k_Fc3BF04iNAd4vHu6hGBFpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddriedurdduudejnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepvd
X-ME-Proxy: <xmx:qJIIXv3LS66acOB59KJAtOO-AAdjNd6ZofV0D9VqG3mm_RnGXujZ-A>
    <xmx:qJIIXhC_VKArgkD0bs6ixjbLeJ8AdXHGHjdpwX6AFJhYfvGCBNJHeA>
    <xmx:qJIIXkGFf4KIj4iTRHRtEI8d19rXdQdQJD0hjB0OnUqizAZONrsEgw>
    <xmx:qJIIXhysLCHfzYs0WMxlsuOJ0XTTpz_wNP9OkYGz0O9229qxWWUJmw>
Received: from splinter.mtl.com (bzq-79-181-61-117.red.bezeqint.net [79.181.61.117])
        by mail.messagingengine.com (Postfix) with ESMTPA id EE34F3060A32;
        Sun, 29 Dec 2019 06:48:54 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/3] selftests: mlxsw: Add a self-test for port-default priority
Date:   Sun, 29 Dec 2019 13:48:29 +0200
Message-Id: <20191229114829.61803-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229114829.61803-1-idosch@idosch.org>
References: <20191229114829.61803-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Send non-IP traffic to a port and observe that it gets prioritized
according to the lldptool app=$prio,1,0 rules.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/mlxsw/qos_defprio.sh          | 176 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |  23 +++
 2 files changed, 199 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/qos_defprio.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_defprio.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_defprio.sh
new file mode 100755
index 000000000000..eff6393ce974
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_defprio.sh
@@ -0,0 +1,176 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test for port-default priority. Non-IP packets ingress $swp1 and are
+# prioritized according to the default priority specified at the port.
+# rx_octets_prio_* counters are used to verify the prioritization.
+#
+# +-----------------------+
+# | H1                    |
+# |    + $h1              |
+# |    | 192.0.2.1/28     |
+# +----|------------------+
+#      |
+# +----|------------------+
+# | SW |                  |
+# |    + $swp1            |
+# |      192.0.2.2/28     |
+# |      APP=<prio>,1,0   |
+# +-----------------------+
+
+ALL_TESTS="
+	ping_ipv4
+	test_defprio
+"
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+NUM_NETIFS=2
+: ${HIT_TIMEOUT:=1000} # ms
+source $lib_dir/lib.sh
+
+declare -a APP
+
+defprio_install()
+{
+	local dev=$1; shift
+	local prio=$1; shift
+	local app="app=$prio,1,0"
+
+	lldptool -T -i $dev -V APP $app >/dev/null
+	lldpad_app_wait_set $dev
+	APP[$prio]=$app
+}
+
+defprio_uninstall()
+{
+	local dev=$1; shift
+	local prio=$1; shift
+	local app=${APP[$prio]}
+
+	lldptool -T -i $dev -V APP -d $app >/dev/null
+	lldpad_app_wait_del
+	unset APP[$prio]
+}
+
+defprio_flush()
+{
+	local dev=$1; shift
+	local prio
+
+	if ((${#APP[@]})); then
+		lldptool -T -i $dev -V APP -d ${APP[@]} >/dev/null
+	fi
+	lldpad_app_wait_del
+	APP=()
+}
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
+	ip link set dev $swp1 up
+	ip addr add dev $swp1 192.0.2.2/28
+}
+
+switch_destroy()
+{
+	defprio_flush $swp1
+	ip addr del dev $swp1 192.0.2.2/28
+	ip link set dev $swp1 down
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	vrf_prepare
+
+	h1_create
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+ping_ipv4()
+{
+	ping_test $h1 192.0.2.2
+}
+
+wait_for_packets()
+{
+	local t0=$1; shift
+	local prio_observe=$1; shift
+
+	local t1=$(ethtool_stats_get $swp1 rx_frames_prio_$prio_observe)
+	local delta=$((t1 - t0))
+	echo $delta
+	((delta >= 10))
+}
+
+__test_defprio()
+{
+	local prio_install=$1; shift
+	local prio_observe=$1; shift
+	local delta
+	local key
+	local i
+
+	RET=0
+
+	defprio_install $swp1 $prio_install
+
+	local t0=$(ethtool_stats_get $swp1 rx_frames_prio_$prio_observe)
+	mausezahn -q $h1 -d 100m -c 10 -t arp reply
+	delta=$(busywait "$HIT_TIMEOUT" wait_for_packets $t0 $prio_observe)
+
+	check_err $? "Default priority $prio_install/$prio_observe: Expected to capture 10 packets, got $delta."
+	log_test "Default priority $prio_install/$prio_observe"
+
+	defprio_uninstall $swp1 $prio_install
+}
+
+test_defprio()
+{
+	local prio
+
+	for prio in {0..7}; do
+		__test_defprio $prio $prio
+	done
+
+	defprio_install $swp1 3
+	__test_defprio 0 3
+	__test_defprio 1 3
+	__test_defprio 2 3
+	__test_defprio 4 4
+	__test_defprio 5 5
+	__test_defprio 6 6
+	__test_defprio 7 7
+	defprio_uninstall $swp1 3
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
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index a0b09bb6995e..8dc5fac98cbc 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -225,6 +225,29 @@ log_info()
 	echo "INFO: $msg"
 }
 
+busywait()
+{
+	local timeout=$1; shift
+
+	local start_time="$(date -u +%s%3N)"
+	while true
+	do
+		local out
+		out=$("$@")
+		local ret=$?
+		if ((!ret)); then
+			echo -n "$out"
+			return 0
+		fi
+
+		local current_time="$(date -u +%s%3N)"
+		if ((current_time - start_time > timeout)); then
+			echo -n "$out"
+			return 1
+		fi
+	done
+}
+
 setup_wait_dev()
 {
 	local dev=$1; shift
-- 
2.24.1

