Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3C12196F37
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 20:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgC2SWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 14:22:17 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:46627 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727719AbgC2SWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 14:22:17 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8496558090B;
        Sun, 29 Mar 2020 14:22:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 29 Mar 2020 14:22:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=0quSQ6uKluRdKUbAvYxeXK9alrIIFw77qHZ7HDrZIJk=; b=doEhm6Qo
        USo1Icnxtn0rpjwKSpPA0CnHW8ygpzo5/mMHaIBB0X4GS1u6OoePygaAsSURgTly
        Mhy2SRQ3RaRna3mjv2m7d7ZJULiUXGry2Hc8ANAN4RcllYoSXJGVGETHKUBv9erD
        QXyxp00YrFMFkx8vOQvoVMJOYsi69BDx4T+JETGtu0LgvmSFJzr/2pOe0xD4W3iz
        gOJEwQj7ObUBOyL5aMnEVEX30zwmhVTByyIHz5pU7pFNSgpAXY3F63kqTyD2J4d7
        /a0iwahWIFbpFLbjlXfdQS8TrXuxJ91ee1EWu8wqk94kH4JGGjCiuIA1qzhmQ6Rm
        bVMUtnNj7Q+7Mw==
X-ME-Sender: <xms:WOeAXki1uXcLALNjtoaJo6lfFQwWJ3mKVzVfgsfRVvwt31W2DBwKeQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeifedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:WOeAXuhIIqvhppfGQQrsAJuCyiovEFWLdELJfl2BBhcUHeP8JYB6tA>
    <xmx:WOeAXgraCFWQp4_2_UIylIYfmPSvlqYxrgEcUmgunDtYt64XElSLag>
    <xmx:WOeAXkx803mP__FMGxbM7uaKNrZRaZ3mJFBgQLOezS5sKKzQyECYjg>
    <xmx:WOeAXtxjA39_lZL1RPmBgi1eWdmTLywlVanHQC6O0YvvFy_6gOq_bA>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1F0283280059;
        Sun, 29 Mar 2020 14:22:13 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 07/15] selftests: netdevsim: Add test cases for devlink-trap policers
Date:   Sun, 29 Mar 2020 21:21:11 +0300
Message-Id: <20200329182119.2207630-8-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200329182119.2207630-1-idosch@idosch.org>
References: <20200329182119.2207630-1-idosch@idosch.org>
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

v2:
* Add test case with new 'fail_trap_policer_set' knob
* Add test case for partially modified trap group

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/netdevsim/devlink_trap.sh     | 116 ++++++++++++++++++
 .../selftests/net/forwarding/devlink_lib.sh   |  37 ++++++
 2 files changed, 153 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
index 437d32bd4cfd..dbd1e014ba17 100755
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
@@ -256,6 +259,119 @@ trap_group_stats_test()
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
+	echo "y" > $DEBUGFS_DIR/fail_trap_policer_set
+	devlink trap policer set $DEVLINK_DEV policer 1 rate 3000 &> /dev/null
+	check_fail $? "Managed to set policer rate when should not"
+	echo "n" > $DEBUGFS_DIR/fail_trap_policer_set
+	if [ $(devlink_trap_policer_rate_get 1) -ne 2000 ]; then
+		check_err 1 "Policer rate was changed to an invalid value"
+	fi
+	if [ $(devlink_trap_policer_burst_get 1) -ne 16 ]; then
+		check_err 1 "Policer burst size was changed to an invalid value"
+	fi
+
+	packets_t0=$(devlink_trap_policer_rx_dropped_get 1)
+	sleep .5
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
+	devlink trap group set $DEVLINK_DEV group l2_drops action drop \
+		policer 1337 &> /dev/null
+	check_fail $? "Did not get an error for partially modified trap group"
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

