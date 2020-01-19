Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED58141DF2
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgASNBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:01:51 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33229 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728655AbgASNBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:01:46 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B009A21B1B;
        Sun, 19 Jan 2020 08:01:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 19 Jan 2020 08:01:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=/FaQ+W0jL1SKg58dfuSYu1CSeKXy5jkFLQm9nfUY7JA=; b=olm2DkaX
        ZXFDEBKuyMF0qKIH21yGQFuoQQStWMeqMy4PlfTbykFUdW9RfVQLWtUzPVJYpZkB
        RZjhTCw+LfJzeW25BYsHL5Z62uONi6NOfI5oP/Ehy67OjNoySczs2DfxSMXdRJel
        REwVnxlcLyTBPo+IkOiod6lsrbFzh5fqkKx4NYKB8ltGS2clXA5tCZ2onYvwtuN7
        dHQapDo/7uZ9Q3mNHjRvv3vOE4gQd0Z4myvgWsQxvcV+n1taVBYAQN6DFvMqnzj/
        lQdtw3OeCUPtAthxxDzdIl7R16xTkOsGhTJoRZJLzM/1opZj/M/cRkXdzHoqIIUg
        lIxXpw6xNio3fA==
X-ME-Sender: <xms:OVMkXgJsddL5nt6Ga5E6TI-m-h-N5tAiaHtNrQQ9ICn9XfdiFVJhjg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepudeg
X-ME-Proxy: <xmx:OVMkXmQ4prL_mSQEV_tKm4iNN3oWGk5dUE-zOxd8ZQrPH676zTcpYg>
    <xmx:OVMkXnr_wYMOH5q1vaExg6dFa0QCmDX93Rxj2knINjZah7R61LUCvg>
    <xmx:OVMkXkjgv4QS8ZkLpQhccyd0OdsKa_tJvV1qWW2mTQnnoYbMIZ0pSA>
    <xmx:OVMkXlI_tV8w5vCiILJ2guqR8mKX-AhZsFXpItqM9V34TZeGaMvwQA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 539F880060;
        Sun, 19 Jan 2020 08:01:44 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 15/15] selftests: devlink_trap_tunnel_vxlan: Add test case for overlay_smac_is_mc
Date:   Sun, 19 Jan 2020 15:01:00 +0200
Message-Id: <20200119130100.3179857-16-idosch@idosch.org>
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

Test that the trap is triggered under the right conditions and that
devlink counters increase when action is trap.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/mlxsw/devlink_trap_tunnel_vxlan.sh    | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh
index a699edae8358..fd19161dd4ec 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh
@@ -36,6 +36,7 @@ lib_dir=$(dirname $0)/../../../net/forwarding
 
 ALL_TESTS="
 	decap_error_test
+	overlay_smac_is_mc_test
 "
 
 NUM_NETIFS=4
@@ -267,6 +268,59 @@ decap_error_test()
 	corrupted_packet_test "Decap error: No L2 header" "short_payload_get"
 }
 
+mc_smac_payload_get()
+{
+	dest_mac=$(mac_get $h1)
+	source_mac=01:02:03:04:05:06
+	p=$(:
+		)"08:"$(                      : VXLAN flags
+		)"00:00:00:"$(                : VXLAN reserved
+		)"00:03:e8:"$(                : VXLAN VNI : 1000
+		)"00:"$(                      : VXLAN reserved
+		)"$dest_mac:"$(               : ETH daddr
+		)"$source_mac:"$(             : ETH saddr
+		)"08:00:"$(                   : ETH type
+		)"45:"$(                      : IP version + IHL
+		)"00:"$(                      : IP TOS
+		)"00:14:"$(                   : IP total length
+		)"00:00:"$(                   : IP identification
+		)"20:00:"$(                   : IP flags + frag off
+		)"40:"$(                      : IP TTL
+		)"00:"$(                      : IP proto
+		)"00:00:"$(                   : IP header csum
+		)"c0:00:02:03:"$(             : IP saddr: 192.0.2.3
+		)"c0:00:02:01:"$(             : IP daddr: 192.0.2.1
+		)
+	echo $p
+}
+
+overlay_smac_is_mc_test()
+{
+	local trap_name="overlay_smac_is_mc"
+	local group_name="tunnel_drops"
+	local mz_pid
+
+	RET=0
+
+	# The matching will be checked on devlink_trap_drop_test()
+	# and the filter will be removed on devlink_trap_drop_cleanup()
+	tc filter add dev $swp1 egress protocol ip pref 1 handle 101 \
+		flower src_mac 01:02:03:04:05:06 action pass
+
+	rp1_mac=$(mac_get $rp1)
+	payload=$(mc_smac_payload_get)
+
+	ip vrf exec v$rp2 $MZ $rp2 -c 0 -d 1msec -b $rp1_mac \
+		-B 192.0.2.17 -t udp sp=12345,dp=$VXPORT,p=$payload -q &
+	mz_pid=$!
+
+	devlink_trap_drop_test $trap_name $group_name $swp1
+
+	log_test "Overlay source MAC is multicast"
+
+	devlink_trap_drop_cleanup $mz_pid $swp1 "ip"
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.24.1

