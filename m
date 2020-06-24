Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06163206EE6
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390427AbgFXIU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:20:57 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:51411 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390404AbgFXIU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:20:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9085B58051F;
        Wed, 24 Jun 2020 04:20:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 24 Jun 2020 04:20:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=NB+ABuOl0twKuiU7shx1Gy/kXSWBO73lJCJT3QZLlrk=; b=Mw1jcCJq
        bDXgPthGPvxxvJRs6P1UBNig0BAdrqNVTv5IX9DYg+xIFOP7EPlFF/b+xgdbytce
        sQN2bLPJ+fYE9ljNb6t+pad/fG0Q/3/iueueZIRmJeyOp1lO/5gvNQFU6nQUIdIv
        2q6aza3IGaqCX72Xj20GT8UJuAkVQEo47v5xbda6gVXjc+qnZ5lP+MxXggu/F8qR
        rDFaR5SWiuAs7TyWCyjN6yFCzmlz5VmIyghdcdASGtRGzxLTySIwTfR0lMkjXS5f
        GeD10+5NCJQ1coDAX3P5vsE/+nknhtLOo3GoGK6PiLFRySHqAconxPabYqPmye/9
        G59Y3IHAH7F+5Q==
X-ME-Sender: <xms:4AzzXiZLC9ZGtnMXu5gfrOzNNXNsKdkPljF_jMejfOhM5Hd5R-UaVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekjedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:4AzzXlY_UcvfDGhVLk1ApvjqbpmbNXVXIu-TamBaldhUi2FqjPetbA>
    <xmx:4AzzXs-TJ3-vAOyr0RNS05benpMsj7V6p0aYd4nmyW0pE53AxF78bg>
    <xmx:4AzzXkpVXbyuowAHdlXR2IS-2fv9YLouNCc-vYqDBh5SAeE1D4BHFA>
    <xmx:4AzzXhcOr2kJrHUYL1nSZ3da17P8szOSioK8OWUE1wwTqI47n5zyfw>
Received: from shredder.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E35830675F9;
        Wed, 24 Jun 2020 04:20:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/10] selftests: forwarding: Add tests for ethtool extended state
Date:   Wed, 24 Jun 2020 11:19:23 +0300
Message-Id: <20200624081923.89483-11-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624081923.89483-1-idosch@idosch.org>
References: <20200624081923.89483-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add tests to check ethtool report about extended state.
The tests configure several states and verify that the correct extended
state is reported by ethtool.

Check extended state with substate (Autoneg) and extended state without
substate (No cable).

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/forwarding/ethtool_extended_state.sh  | 102 ++++++++++++++++++
 1 file changed, 102 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_extended_state.sh

diff --git a/tools/testing/selftests/net/forwarding/ethtool_extended_state.sh b/tools/testing/selftests/net/forwarding/ethtool_extended_state.sh
new file mode 100755
index 000000000000..4b42dfd4efd1
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ethtool_extended_state.sh
@@ -0,0 +1,102 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="
+	autoneg
+	autoneg_force_mode
+	no_cable
+"
+
+NUM_NETIFS=2
+source lib.sh
+source ethtool_lib.sh
+
+setup_prepare()
+{
+	swp1=${NETIFS[p1]}
+	swp2=${NETIFS[p2]}
+	swp3=$NETIF_NO_CABLE
+}
+
+ethtool_extended_state_check()
+{
+	local dev=$1; shift
+	local expected_ext_state=$1; shift
+	local expected_ext_substate=${1:-""}; shift
+
+	local ext_state=$(ethtool $dev | grep "Link detected" \
+		| cut -d "(" -f2 | cut -d ")" -f1)
+	local ext_substate=$(echo $ext_state | cut -sd "," -f2 \
+		| sed -e 's/^[[:space:]]*//')
+	ext_state=$(echo $ext_state | cut -d "," -f1)
+
+	[[ $ext_state == $expected_ext_state ]]
+	check_err $? "Expected \"$expected_ext_state\", got \"$ext_state\""
+
+	[[ $ext_substate == $expected_ext_substate ]]
+	check_err $? "Expected \"$expected_ext_substate\", got \"$ext_substate\""
+}
+
+autoneg()
+{
+	RET=0
+
+	ip link set dev $swp1 up
+
+	sleep 4
+	ethtool_extended_state_check $swp1 "Autoneg" "No partner detected"
+
+	log_test "Autoneg, No partner detected"
+
+	ip link set dev $swp1 down
+}
+
+autoneg_force_mode()
+{
+	RET=0
+
+	ip link set dev $swp1 up
+	ip link set dev $swp2 up
+
+	local -a speeds_arr=($(different_speeds_get $swp1 $swp2 0 0))
+	local speed1=${speeds_arr[0]}
+	local speed2=${speeds_arr[1]}
+
+	ethtool_set $swp1 speed $speed1 autoneg off
+	ethtool_set $swp2 speed $speed2 autoneg off
+
+	sleep 4
+	ethtool_extended_state_check $swp1 "Autoneg" \
+		"No partner detected during force mode"
+
+	ethtool_extended_state_check $swp2 "Autoneg" \
+		"No partner detected during force mode"
+
+	log_test "Autoneg, No partner detected during force mode"
+
+	ethtool -s $swp2 autoneg on
+	ethtool -s $swp1 autoneg on
+
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+}
+
+no_cable()
+{
+	RET=0
+
+	ip link set dev $swp3 up
+
+	sleep 1
+	ethtool_extended_state_check $swp3 "No cable"
+
+	log_test "No cable"
+
+	ip link set dev $swp3 down
+}
+
+setup_prepare
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.26.2

