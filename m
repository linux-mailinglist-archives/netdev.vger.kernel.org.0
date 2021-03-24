Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EE23482B1
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238189AbhCXUPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:15:25 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37511 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238131AbhCXUPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:15:05 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A50695C0160;
        Wed, 24 Mar 2021 16:15:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 24 Mar 2021 16:15:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=0Tl2GMF349hTpePxeT+S1zouGcdEDp0GPU9O31BX4wI=; b=uPQ/8ZWC
        XLJH7NhuKy/yjDYiR7dqlkXzTjZ7aPh8sRQRi7I/49csCYiqQGZv96Da8+zQUGUh
        fToTw51R8AZy0oDWoK9Hp9Bun4jef/rRwRB3mIqcxG/FxtJg28OrFAvRM4J0hCZm
        QKqeMhiTMc19ZyhomoJZFt7XO8Ywi76PU+1+HOvnmx1A+XJlxTSBqo5Nvd75VTKM
        Gyo12S6aYnozSI+lwySInSZZhthE/I714FRjgmPUJEwVCzrYsp7gICtOyODCibNt
        IaltwKYtTAGIIDgPMoRJXwmu0XDcha9JdG0i7sVw5dQNWxoN+EkGLREm3gh+LTmu
        i/Uzg/dsWdlrMA==
X-ME-Sender: <xms:yJ1bYBORjeBrgW-aBGAuT0WYgjQfGxx3QeSCehz6dO8Ie8sfeJH4SA>
    <xme:yJ1bYEFYsw5H6tAusppeVQDvOgpvvD7w_Y4dBS2krFc2UXQAqFkA2o0el7yCup1PR
    ahjjDWkncB1uPg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegkedgudeffecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeg
    geenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:yJ1bYIMDZovT6FsxVwPjnr8mm-ExILkg7HEFF6vVnO789OdtY7-0qA>
    <xmx:yJ1bYF_xiTsOdDw1AIkhiU2F-vIfAF9f7IwctN8pO2AJzxYRitSWSQ>
    <xmx:yJ1bYEQtFZyJBZkntkJtcFyMJj667p_kIBWYz1qA2rxIlgSAl4i9Hg>
    <xmx:yJ1bYIeoKf1mwQ7QAt0xWJGysLjZIlqgJP6vgNl7SpESE9VPNpdCuQ>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1FDA5240428;
        Wed, 24 Mar 2021 16:15:01 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/10] selftests: mlxsw: Test unresolved neigh trap with resilient nexthop groups
Date:   Wed, 24 Mar 2021 22:14:23 +0200
Message-Id: <20210324201424.157387-10-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324201424.157387-1-idosch@idosch.org>
References: <20210324201424.157387-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The number of nexthop buckets in a resilient nexthop group never
changes, so when the gateway address of a nexthop cannot be resolved,
the nexthop buckets are programmed to trap packets to the CPU in order
to trigger resolution. For example:

 # ip nexthop add id 1 via 198.51.100.1 dev swp3
 # ip nexthop add id 10 group 1 type resilient buckets 32
 # ip nexthop bucket get id 10 index 0
 id 10 index 0 idle_time 1.44 nhid 1 trap

Where 198.51.100.1 is a made-up IP.

Test that in this case packets are indeed trapped to the CPU via the
unresolved neigh trap.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../net/mlxsw/devlink_trap_l3_exceptions.sh   | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh
index 1fedfc9da434..42d44e27802c 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh
@@ -446,6 +446,35 @@ __invalid_nexthop_test()
 	log_test "Unresolved neigh: nexthop does not exist: $desc"
 }
 
+__invalid_nexthop_bucket_test()
+{
+	local desc=$1; shift
+	local dip=$1; shift
+	local via_add=$1; shift
+	local trap_name="unresolved_neigh"
+
+	RET=0
+
+	# Check that route to nexthop that does not exist triggers
+	# unresolved_neigh
+	ip nexthop add id 1 via $via_add dev $rp2
+	ip nexthop add id 10 group 1 type resilient buckets 32
+	ip route add $dip nhid 10
+
+	t0_packets=$(devlink_trap_rx_packets_get $trap_name)
+	ping_do $h1 $dip
+	t1_packets=$(devlink_trap_rx_packets_get $trap_name)
+
+	if [[ $t0_packets -eq $t1_packets ]]; then
+		check_err 1 "Trap counter did not increase"
+	fi
+
+	ip route del $dip nhid 10
+	ip nexthop del id 10
+	ip nexthop del id 1
+	log_test "Unresolved neigh: nexthop bucket does not exist: $desc"
+}
+
 unresolved_neigh_test()
 {
 	__host_miss_test "IPv4" 198.51.100.1
@@ -453,6 +482,8 @@ unresolved_neigh_test()
 	__invalid_nexthop_test "IPv4" 198.51.100.1 198.51.100.3 24 198.51.100.4
 	__invalid_nexthop_test "IPv6" 2001:db8:2::1 2001:db8:2::3 64 \
 		2001:db8:2::4
+	__invalid_nexthop_bucket_test "IPv4" 198.51.100.1 198.51.100.4
+	__invalid_nexthop_bucket_test "IPv6" 2001:db8:2::1 2001:db8:2::4
 }
 
 vrf_without_routes_create()
-- 
2.30.2

