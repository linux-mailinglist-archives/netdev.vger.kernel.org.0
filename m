Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFDF141DE5
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgASNB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:01:29 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51187 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726867AbgASNB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:01:28 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2BEE521D75;
        Sun, 19 Jan 2020 08:01:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 19 Jan 2020 08:01:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=0D3tdzyD1SGoPdCml0skfejLh094IMzKQT6ACEXUWEM=; b=FmVofdKH
        5+aUZSDn3Uf/YZy65sRE1VSxTRktLG7rXKdayWp/W60jHHdfYmeX8lBPGQBDIfJZ
        yRhHSrsAUeUHFWD5+S6c9KueDVrE/b2tdrqPH1eKaJct5A1RbWAFP+T9/c32kPmY
        IVimI6oNH2PKOtNT2mGTyedKhcwYZt+8LC6njLDECrzbGysc1BiEbiJA70R6oUTN
        PdC0MN4WMbi2LMhk+4H72orM+NKFEAxQHv5ohqnOKgncqeJtSvnaHpp2FQ4WK+GK
        emiHPaLgThsvyoQnvW8u4HlXDlrGleHaXxbuOVLtH7Tv8JphCWNSXH9KlhMjb4Ke
        HkMnZNajXGrHSA==
X-ME-Sender: <xms:KFMkXhfBxXn4TugZuNxGcA-GyuKQhdDxPHOWXSfxa4at5NlENVd5aA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepud
X-ME-Proxy: <xmx:KFMkXsDwj9qm0jRttfop4v3c5Agn50wMta0lFOD1OcVbZ9aetVqQkg>
    <xmx:KFMkXuuGP5sE5ris-e52z1UR7Z-rfjxvzy3VfnBZHOOMKudzXZuhkA>
    <xmx:KFMkXpH9hoSnfl73ye8nswEGUSD7ulphIc1FNHEJBiLiOm0EjDnNHg>
    <xmx:KFMkXmJmdastUbVEiiU_1uxDs2zhfW9SztxCvdUv9CoWwK1S-n5x3g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id CB94980060;
        Sun, 19 Jan 2020 08:01:26 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/15] selftests: devlink_trap_l3_drops: Add test cases of irif and erif disabled
Date:   Sun, 19 Jan 2020 15:00:47 +0200
Message-Id: <20200119130100.3179857-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200119130100.3179857-1-idosch@idosch.org>
References: <20200119130100.3179857-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add test cases to check that packets routed through disabled RIFs and
packets routed from disabled RIFs are dropped and devlink counters
increase when the action is trap.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/mlxsw/devlink_trap_l3_drops.sh        | 112 ++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
index b4efb023ae51..d88d8e47d11b 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
@@ -50,6 +50,8 @@ ALL_TESTS="
 	ipv6_mc_dip_reserved_scope_test
 	ipv6_mc_dip_interface_local_scope_test
 	blackhole_route_test
+	irif_disabled_test
+	erif_disabled_test
 "
 
 NUM_NETIFS=4
@@ -553,6 +555,116 @@ blackhole_route_test()
 	__blackhole_route_test "6" "2001:db8:2::/120" "ipv6" $h2_ipv6 "icmpv6"
 }
 
+irif_disabled_test()
+{
+	local trap_name="irif_disabled"
+	local group_name="l3_drops"
+	local t0_packets t0_bytes
+	local t1_packets t1_bytes
+	local mz_pid
+
+	RET=0
+
+	ping_check $trap_name
+
+	devlink_trap_action_set $trap_name "trap"
+
+	# When RIF of a physical port ("Sub-port RIF") is destroyed, we first
+	# block the STP of the {Port, VLAN} so packets cannot get into the RIF.
+	# Using bridge enables us to see this trap because when bridge is
+	# destroyed, there is a small time window that packets can go into the
+	# RIF, while it is disabled.
+	ip link add dev br0 type bridge
+	ip link set dev $rp1 master br0
+	ip address flush dev $rp1
+	__addr_add_del br0 add 192.0.2.2/24
+	ip li set dev br0 up
+
+	t0_packets=$(devlink_trap_rx_packets_get $trap_name)
+	t0_bytes=$(devlink_trap_rx_bytes_get $trap_name)
+
+	# Generate packets to h2 through br0 RIF that will be removed later
+	$MZ $h1 -t udp "sp=54321,dp=12345" -c 0 -p 100 -a own -b $rp1mac \
+		-B $h2_ipv4 -q &
+	mz_pid=$!
+
+	# Wait before removing br0 RIF to allow packets to go into the bridge.
+	sleep 1
+
+	# Flushing address will dismantle the RIF
+	ip address flush dev br0
+
+	t1_packets=$(devlink_trap_rx_packets_get $trap_name)
+	t1_bytes=$(devlink_trap_rx_bytes_get $trap_name)
+
+	if [[ $t0_packets -eq $t1_packets && $t0_bytes -eq $t1_bytes ]]; then
+		check_err 1 "Trap stats idle when packets should be trapped"
+	fi
+
+	log_test "Ingress RIF disabled"
+
+	kill $mz_pid && wait $mz_pid &> /dev/null
+	ip link set dev $rp1 nomaster
+	__addr_add_del $rp1 add 192.0.2.2/24 2001:db8:1::2/64
+	ip link del dev br0 type bridge
+	devlink_trap_action_set $trap_name "drop"
+}
+
+erif_disabled_test()
+{
+	local trap_name="erif_disabled"
+	local group_name="l3_drops"
+	local t0_packets t0_bytes
+	local t1_packets t1_bytes
+	local mz_pid
+
+	RET=0
+
+	ping_check $trap_name
+
+	devlink_trap_action_set $trap_name "trap"
+	ip link add dev br0 type bridge
+	ip add flush dev $rp1
+	ip link set dev $rp1 master br0
+	__addr_add_del br0 add 192.0.2.2/24
+	ip link set dev br0 up
+
+	t0_packets=$(devlink_trap_rx_packets_get $trap_name)
+	t0_bytes=$(devlink_trap_rx_bytes_get $trap_name)
+
+	rp2mac=$(mac_get $rp2)
+
+	# Generate packets that should go out through br0 RIF that will be
+	# removed later
+	$MZ $h2 -t udp "sp=54321,dp=12345" -c 0 -p 100 -a own -b $rp2mac \
+		-B 192.0.2.1 -q &
+	mz_pid=$!
+
+	sleep 5
+	# In order to see this trap we need a route that points to disabled RIF.
+	# When ipv6 address is flushed, there is a delay and the routes are
+	# deleted before the RIF and we cannot get state that we have route
+	# to disabled RIF.
+	# Delete IPv6 address first and then check this trap with flushing IPv4.
+	ip -6 add flush dev br0
+	ip -4 add flush dev br0
+
+	t1_packets=$(devlink_trap_rx_packets_get $trap_name)
+	t1_bytes=$(devlink_trap_rx_bytes_get $trap_name)
+
+	if [[ $t0_packets -eq $t1_packets && $t0_bytes -eq $t1_bytes ]]; then
+		check_err 1 "Trap stats idle when packets should be trapped"
+	fi
+
+	log_test "Egress RIF disabled"
+
+	kill $mz_pid && wait $mz_pid &> /dev/null
+	ip link set dev $rp1 nomaster
+	__addr_add_del $rp1 add 192.0.2.2/24 2001:db8:1::2/64
+	ip link del dev br0 type bridge
+	devlink_trap_action_set $trap_name "drop"
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.24.1

