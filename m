Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7EC22072F
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 10:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730053AbgGOI2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 04:28:30 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55671 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729995AbgGOI20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 04:28:26 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 985285C010B;
        Wed, 15 Jul 2020 04:28:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 15 Jul 2020 04:28:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=IlR2rqE0RRMjdgP9gVPV6tmpoi2/n54+I3KlW6cIlk8=; b=u6H7yqGV
        qcDvVDHMMsl1x/GVvqFenvXLPagPIvxd4T+z/sCuJM+iQmSb1vA7Hl1vDkO3EuwV
        05UyJQPsbRILxCvyG32TU37VzPaVxK3aNW/DO7NUmPeIZpEASpY8mUUFDXl62pFV
        lbkNmeyiFny/3xwqoI/aGKtG5VXI6lSAeDzZ0jsXRs9uBzLDwl7HJ6euL7Tvld0C
        Mp9hbVrdqGsMWmuJ/RCtLN1yMh4fGkDuUj6kYIAIJx/Vy/e828qGEqG4oXKp0Vj2
        4viawX09+kBTYbH4I0cdCzjCMWedJqtuZjBb+N6u+8yUZYgtLvI5vg74mYClq2Zq
        ny6JZmlgw4AuqA==
X-ME-Sender: <xms:Kb4OX62UhHRUt8V_hCT2PRpMmEZcb-tbhKcy2oM0aYp23gBVYETVXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedvgddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieehrddufeelrddukedt
    necuvehluhhsthgvrhfuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Kb4OX9HXeBdZ-zvX0m1sU0RWaO2iUQ1kVUZu4jTgnG3Sb_z8CiT1Vg>
    <xmx:Kb4OXy4CZrrT55BUgVq10yDqsq2H8NHvDTLvEE2-bKc9zE1uiwzDAA>
    <xmx:Kb4OX72try73anAA-2Qofsne8TfZyMz2fpUNO80YVLiVUjT7jWfI1Q>
    <xmx:Kb4OXyTizKNNhsfsAkWoh9cx9FIIIMjPGHVlY8U9I95_hqKoeUUpgw>
Received: from shredder.mtl.com (bzq-109-65-139-180.red.bezeqint.net [109.65.139.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id A8C583280063;
        Wed, 15 Jul 2020 04:28:23 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 11/11] selftests: mlxsw: Test policers' occupancy
Date:   Wed, 15 Jul 2020 11:27:33 +0300
Message-Id: <20200715082733.429610-12-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715082733.429610-1-idosch@idosch.org>
References: <20200715082733.429610-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Test that policers shared by different tc filters are correctly
reference counted by observing policers' occupancy via devlink-resource.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
---
 .../drivers/net/mlxsw/tc_police_occ.sh        | 108 ++++++++++++++++++
 .../selftests/net/forwarding/devlink_lib.sh   |   5 +
 2 files changed, 113 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/tc_police_occ.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_police_occ.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_police_occ.sh
new file mode 100755
index 000000000000..448b75c1545a
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_police_occ.sh
@@ -0,0 +1,108 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test that policers shared by different tc filters are correctly reference
+# counted by observing policers' occupancy via devlink-resource.
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	tc_police_occ_test
+"
+NUM_NETIFS=2
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
+switch_create()
+{
+	simple_if_init $swp1
+	tc qdisc add dev $swp1 clsact
+}
+
+switch_destroy()
+{
+	tc qdisc del dev $swp1 clsact
+	simple_if_fini $swp1
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
+tc_police_occ_get()
+{
+	devlink_resource_occ_get global_policers single_rate_policers
+}
+
+tc_police_occ_test()
+{
+	RET=0
+
+	local occ=$(tc_police_occ_get)
+
+	tc filter add dev $swp1 ingress pref 1 handle 101 proto ip \
+		flower skip_sw \
+		action police rate 100mbit burst 100k conform-exceed drop/ok
+	(( occ + 1 == $(tc_police_occ_get) ))
+	check_err $? "Got occupancy $(tc_police_occ_get), expected $((occ + 1))"
+
+	tc filter del dev $swp1 ingress pref 1 handle 101 flower
+	(( occ == $(tc_police_occ_get) ))
+	check_err $? "Got occupancy $(tc_police_occ_get), expected $occ"
+
+	tc filter add dev $swp1 ingress pref 1 handle 101 proto ip \
+		flower skip_sw \
+		action police rate 100mbit burst 100k conform-exceed drop/ok \
+		index 10
+	tc filter add dev $swp1 ingress pref 2 handle 102 proto ip \
+		flower skip_sw action police index 10
+
+	(( occ + 1 == $(tc_police_occ_get) ))
+	check_err $? "Got occupancy $(tc_police_occ_get), expected $((occ + 1))"
+
+	tc filter del dev $swp1 ingress pref 2 handle 102 flower
+	(( occ + 1 == $(tc_police_occ_get) ))
+	check_err $? "Got occupancy $(tc_police_occ_get), expected $((occ + 1))"
+
+	tc filter del dev $swp1 ingress pref 1 handle 101 flower
+	(( occ == $(tc_police_occ_get) ))
+	check_err $? "Got occupancy $(tc_police_occ_get), expected $occ"
+
+	log_test "tc police occupancy"
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
diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index f0e6be4c09e9..75fe24bcb9cd 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -98,6 +98,11 @@ devlink_resource_size_set()
 	check_err $? "Failed setting path $path to size $size"
 }
 
+devlink_resource_occ_get()
+{
+	devlink_resource_get "$@" | jq '.["occ"]'
+}
+
 devlink_reload()
 {
 	local still_pending
-- 
2.26.2

