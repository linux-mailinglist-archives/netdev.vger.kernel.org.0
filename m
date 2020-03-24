Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA95191A09
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbgCXTeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:34:36 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:60203 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727150AbgCXTeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:34:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 78693580061;
        Tue, 24 Mar 2020 15:34:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 24 Mar 2020 15:34:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=nTFtBbcQtVptmY+D6ZeRXJAqUKdutpXtyM4xj9lY6ro=; b=Y/qtdeCa
        nQEoEYRiMi1iSs0iTDl4bPKe6s5jiNEXP0lKXu6NZr6qbib+zteP2p9rHxS8klBK
        7ue+KScT7Gjbmk5Ypggyh1utY6CyNxlaVJGN2qcRTsCu90tudtv3OXHaKG91mssG
        RDwFdFchdVBFXDjWhS5xC5GZUJCHFA1+6cqYGwFq5OrTznZATa29RLaUjYk760TL
        kBUWqJ0ddpjQ3cUOdRDhRztvGWnzSTeC+5Ef70SYmtEy/yRKyzm1DZVzUaenrmGT
        87wc5cJBZE06HPE63RS0FFOC+wc5zg7TBhlClyZ+38zPfcgKwY9Iep6/qxztUOko
        VFaIrxrPm6bKYA==
X-ME-Sender: <xms:y2B6XohNBMhCDDq-Cm7UcUZ4fHPb_3V3z2mzN_TcAksKO5ILoaWlEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehuddgleehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudektddrleegrddvvdehnecuvehluhhsthgvrh
    fuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:y2B6XlQoAhLledIEmoQKBMBS_YQhYLC57JIA3KWGd5P_gkYu3ac40g>
    <xmx:y2B6XrGQQWKOmuuaV8QCZ6fBURGXsBOVEdtb4ayd2exJf1GllvQ_tw>
    <xmx:y2B6XtmqFK6vZIMZeLWRg6ibanK1HOqkRdYrImg4AuMKCLua-mjXDg>
    <xmx:y2B6XvoOR1XdiviYZtCzOyElgLlaeusIwnnuOgKzHH2F48Z2J__7Pg>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id 946AA3065DD8;
        Tue, 24 Mar 2020 15:34:31 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/15] selftests: netdevsim: Add test cases for devlink-trap policers
Date:   Tue, 24 Mar 2020 21:32:42 +0200
Message-Id: <20200324193250.1322038-8-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324193250.1322038-1-idosch@idosch.org>
References: <20200324193250.1322038-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Add test cases for packet trap policer set / show commands as well as
for the binding of these policers to packet trap groups.

Both good and bad flows are tested for maximum coverage.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/netdevsim/devlink_trap.sh     | 110 ++++++++++++++++++
 .../selftests/net/forwarding/devlink_lib.sh   |  37 ++++++
 2 files changed, 147 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
index 437d32bd4cfd..35ca856ee493 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
@@ -16,6 +16,8 @@ ALL_TESTS="
 	trap_group_action_test
 	bad_trap_group_test
 	trap_group_stats_test
+	trap_policer_test
+	trap_policer_bind_test
 	port_del_test
 	dev_del_test
 "
@@ -23,6 +25,7 @@ NETDEVSIM_PATH=/sys/bus/netdevsim/
 DEV_ADDR=1337
 DEV=netdevsim${DEV_ADDR}
 DEVLINK_DEV=netdevsim/${DEV}
+DEBUGFS_DIR=/sys/kernel/debug/netdevsim/$DEV/
 SLEEP_TIME=1
 NETDEV=""
 NUM_NETIFS=0
@@ -256,6 +259,113 @@ trap_group_stats_test()
 	log_test "Trap group statistics"
 }
 
+trap_policer_test()
+{
+	local packets_t0
+	local packets_t1
+
+	if [ $(devlink_trap_policers_num_get) -eq 0 ]; then
+		check_err 1 "Failed to dump policers"
+	fi
+
+	devlink trap policer set $DEVLINK_DEV policer 1337 &> /dev/null
+	check_fail $? "Did not get an error for setting a non-existing policer"
+	devlink trap policer show $DEVLINK_DEV policer 1337 &> /dev/null
+	check_fail $? "Did not get an error for getting a non-existing policer"
+
+	devlink trap policer set $DEVLINK_DEV policer 1 rate 2000 burst 16
+	check_err $? "Failed to set valid parameters for a valid policer"
+	if [ $(devlink_trap_policer_rate_get 1) -ne 2000 ]; then
+		check_err 1 "Policer rate was not changed"
+	fi
+	if [ $(devlink_trap_policer_burst_get 1) -ne 16 ]; then
+		check_err 1 "Policer burst size was not changed"
+	fi
+
+	devlink trap policer set $DEVLINK_DEV policer 1 rate 0 &> /dev/null
+	check_fail $? "Policer rate was changed to rate lower than limit"
+	devlink trap policer set $DEVLINK_DEV policer 1 rate 9000 &> /dev/null
+	check_fail $? "Policer rate was changed to rate higher than limit"
+	devlink trap policer set $DEVLINK_DEV policer 1 burst 2 &> /dev/null
+	check_fail $? "Policer burst size was changed to burst size lower than limit"
+	devlink trap policer set $DEVLINK_DEV policer 1 rate 65537 &> /dev/null
+	check_fail $? "Policer burst size was changed to burst size higher than limit"
+	devlink trap policer set $DEVLINK_DEV policer 1 burst 15 &> /dev/null
+	check_fail $? "Policer burst size was changed to burst size that is not power of 2"
+	if [ $(devlink_trap_policer_rate_get 1) -ne 2000 ]; then
+		check_err 1 "Policer rate was changed to an invalid value"
+	fi
+	if [ $(devlink_trap_policer_burst_get 1) -ne 16 ]; then
+		check_err 1 "Policer burst size was changed to an invalid value"
+	fi
+
+	packets_t0=$(devlink_trap_policer_rx_dropped_get 1)
+	sleep .1
+	packets_t1=$(devlink_trap_policer_rx_dropped_get 1)
+	if [ ! $packets_t1 -gt $packets_t0 ]; then
+		check_err 1 "Policer drop counter was not incremented"
+	fi
+
+	echo "y"> $DEBUGFS_DIR/fail_trap_policer_counter_get
+	devlink -s trap policer show $DEVLINK_DEV policer 1 &> /dev/null
+	check_fail $? "Managed to read policer drop counter when should not"
+	echo "n"> $DEBUGFS_DIR/fail_trap_policer_counter_get
+	devlink -s trap policer show $DEVLINK_DEV policer 1 &> /dev/null
+	check_err $? "Did not manage to read policer drop counter when should"
+
+	log_test "Trap policer"
+}
+
+trap_group_check_policer()
+{
+	local group_name=$1; shift
+
+	devlink -j -p trap group show $DEVLINK_DEV group $group_name \
+		| jq -e '.[][][]["policer"]' &> /dev/null
+}
+
+trap_policer_bind_test()
+{
+	devlink trap group set $DEVLINK_DEV group l2_drops policer 1
+	check_err $? "Failed to bind a valid policer"
+	if [ $(devlink_trap_group_policer_get "l2_drops") -ne 1 ]; then
+		check_err 1 "Bound policer was not changed"
+	fi
+
+	devlink trap group set $DEVLINK_DEV group l2_drops policer 1337 \
+		&> /dev/null
+	check_fail $? "Did not get an error for binding a non-existing policer"
+	if [ $(devlink_trap_group_policer_get "l2_drops") -ne 1 ]; then
+		check_err 1 "Bound policer was changed when should not"
+	fi
+
+	devlink trap group set $DEVLINK_DEV group l2_drops policer 0
+	check_err $? "Failed to unbind a policer when using ID 0"
+	trap_group_check_policer "l2_drops"
+	check_fail $? "Trap group has a policer after unbinding with ID 0"
+
+	devlink trap group set $DEVLINK_DEV group l2_drops policer 1
+	check_err $? "Failed to bind a valid policer"
+
+	devlink trap group set $DEVLINK_DEV group l2_drops nopolicer
+	check_err $? "Failed to unbind a policer when using 'nopolicer' keyword"
+	trap_group_check_policer "l2_drops"
+	check_fail $? "Trap group has a policer after unbinding with 'nopolicer' keyword"
+
+	devlink trap group set $DEVLINK_DEV group l2_drops policer 1
+	check_err $? "Failed to bind a valid policer"
+
+	echo "y"> $DEBUGFS_DIR/fail_trap_group_set
+	devlink trap group set $DEVLINK_DEV group l2_drops policer 2 \
+		&> /dev/null
+	check_fail $? "Managed to bind a policer when should not"
+	echo "n"> $DEBUGFS_DIR/fail_trap_group_set
+	devlink trap group set $DEVLINK_DEV group l2_drops policer 2
+	check_err $? "Did not manage to bind a policer when should"
+
+	log_test "Trap policer binding"
+}
+
 port_del_test()
 {
 	local group_name
diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 0df6d8942721..c48645a344e2 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -420,6 +420,43 @@ devlink_trap_drop_cleanup()
 	tc filter del dev $dev egress protocol $proto pref $pref handle $handle flower
 }
 
+devlink_trap_policers_num_get()
+{
+	devlink -j -p trap policer show | jq '.[]["'$DEVLINK_DEV'"] | length'
+}
+
+devlink_trap_policer_rate_get()
+{
+	local policer_id=$1; shift
+
+	devlink -j -p trap policer show $DEVLINK_DEV policer $policer_id \
+		| jq '.[][][]["rate"]'
+}
+
+devlink_trap_policer_burst_get()
+{
+	local policer_id=$1; shift
+
+	devlink -j -p trap policer show $DEVLINK_DEV policer $policer_id \
+		| jq '.[][][]["burst"]'
+}
+
+devlink_trap_policer_rx_dropped_get()
+{
+	local policer_id=$1; shift
+
+	devlink -j -p -s trap policer show $DEVLINK_DEV policer $policer_id \
+		| jq '.[][][]["stats"]["rx"]["dropped"]'
+}
+
+devlink_trap_group_policer_get()
+{
+	local group_name=$1; shift
+
+	devlink -j -p trap group show $DEVLINK_DEV group $group_name \
+		| jq '.[][][]["policer"]'
+}
+
 devlink_port_by_netdev()
 {
 	local if_name=$1
-- 
2.24.1

