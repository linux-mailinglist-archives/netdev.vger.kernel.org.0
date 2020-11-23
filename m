Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665E52C0088
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 08:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgKWHOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 02:14:22 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:46875 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727852AbgKWHOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 02:14:21 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id CFF84F54;
        Mon, 23 Nov 2020 02:14:20 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 23 Nov 2020 02:14:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Drz89nHW4ScRTelAJm1jPlhtGFCKChpLujslPj+4QWk=; b=jNxlmTw1
        rSYTXHb48MnjHaiTbKmhJqbdNN4X8ZfIXxY38uGsTlS7P7rP29OxoFlmPhu5q40v
        rbXY5IAWVK7YgDd8dGGQafSNWSkg2mk4Xlpoga46gcurxcTDl1eQxJagqaJlNrhS
        6KeZJaYHdoI6r1LThbOtLn0x40mudKBgtFkRBXOqSj6/l0jJGhQ+DncFIbq+BfPm
        HRP6BcvrzRXmFLj8uMhv0kOHLOF4kfKH70lWVNRW74bh+ZmvUsie7tBfnVbVVa5M
        ctnZ4Up65UnmF9h7RqDfNGKAy+ZfsREFvgzE3iLUZWsICXSMhMZMRAZ9ukFAHRS6
        J1vBGMY1Jd5NXQ==
X-ME-Sender: <xms:TGG7X_F9X3CDxuEMYOSHMybF65AmezuFA-qTapBQYoO6-seZujIUQw>
    <xme:TGG7X8VB8QNEYU4IwwyMlZRvHx8TFLVjiG61gXAh6rNEJTl8It9PPJxQ5Y4PlPiQW
    zM9OAC3isuvK0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:TGG7XxJXzN1URHz2QQ5BRtFJ-m8l7tKuHEph2kiXK5jtJ6J8F0rTSg>
    <xmx:TGG7X9GqtitSd7T9bmPA6Q5G2SMixTBNa99vWwU3MFKGomkqQr-SJA>
    <xmx:TGG7X1VFLq1ANkPPnFY_cb5dsJLeoS_n1IgJ6ankQKlilq3ai__-fA>
    <xmx:TGG7X4QyGjhYHA_g87r0AdHm1_R66x0UQNQi8dTsT_4Khe1W5h0wxw>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 141FC3280065;
        Mon, 23 Nov 2020 02:14:18 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/10] selftests: mlxsw: Add blackhole_nexthop trap test
Date:   Mon, 23 Nov 2020 09:12:30 +0200
Message-Id: <20201123071230.676469-11-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123071230.676469-1-idosch@idosch.org>
References: <20201123071230.676469-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that packets hitting a blackhole nexthop are trapped to the CPU
when the trap is enabled. Test that packets are not reported when the
trap is disabled.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/mlxsw/devlink_trap_l3_drops.sh        | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
index f5abb1ebd392..4029833f7e27 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
@@ -52,6 +52,7 @@ ALL_TESTS="
 	blackhole_route_test
 	irif_disabled_test
 	erif_disabled_test
+	blackhole_nexthop_test
 "
 
 NUM_NETIFS=4
@@ -647,6 +648,41 @@ erif_disabled_test()
 	devlink_trap_action_set $trap_name "drop"
 }
 
+__blackhole_nexthop_test()
+{
+	local flags=$1; shift
+	local subnet=$1; shift
+	local proto=$1; shift
+	local dip=$1; shift
+	local trap_name="blackhole_nexthop"
+	local mz_pid
+
+	RET=0
+
+	ip -$flags nexthop add id 1 blackhole
+	ip -$flags route add $subnet nhid 1
+	tc filter add dev $rp2 egress protocol $proto pref 1 handle 101 \
+		flower skip_hw dst_ip $dip ip_proto udp action drop
+
+	# Generate packets to the blackhole nexthop
+	$MZ $h1 -$flags -t udp "sp=54321,dp=12345" -c 0 -p 100 -b $rp1mac \
+		-B $dip -d 1msec -q &
+	mz_pid=$!
+
+	devlink_trap_drop_test $trap_name $rp2 101
+	log_test "Blackhole nexthop: IPv$flags"
+
+	devlink_trap_drop_cleanup $mz_pid $rp2 $proto 1 101
+	ip -$flags route del $subnet
+	ip -$flags nexthop del id 1
+}
+
+blackhole_nexthop_test()
+{
+	__blackhole_nexthop_test "4" "198.51.100.0/30" "ip" $h2_ipv4
+	__blackhole_nexthop_test "6" "2001:db8:2::/120" "ipv6" $h2_ipv6
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.28.0

