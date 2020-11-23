Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154E62C0085
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 08:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgKWHOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 02:14:18 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:59323 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726051AbgKWHOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 02:14:15 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id C804AF5A;
        Mon, 23 Nov 2020 02:14:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 23 Nov 2020 02:14:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=GCWAXzaP4LVs0iM6tCcAS2BwSUMU+xAqkrcibx6kjlI=; b=C34REzzK
        ZWIQ+LklTh1iYJL2YOxhAtWwTuFPYX6TOZQDS3aNXy2vsuA/0M7a01nqZW5uYjof
        aq4e1KN8teFeGYj0OwGyxZzfbNJPeddT+LqXpUYY1eRiluwo3HxKg7ZlbfdfdrEu
        l9GZPC8FLupmpHEMrMEFfpdVii5I6u62xQFGw13iCyq4ASL/1o/kDM+73jcLyRN8
        dbnFFsHwHa4I9cfp2zxmVIec/aGmfDXfVXTZ+eFXxMTb8a4GP0UsRI6V3qvB0S6H
        bj+NaaF2BFmPSbhJzKyd0zqlbTJigEqf7FbZJV4GKFUnWRHIFIeNS27n0MljSxo3
        VDVskw8Q5QzL2Q==
X-ME-Sender: <xms:RmG7X-9WlEPJO673lfz-lTVFlo65PrJDpcT-CJeO1fTtBan9lPqRtg>
    <xme:RmG7X-vZjbouhR5pjyFhpovLA60Hfd0gEu99bcxQvoW4_WytRLozHX2z5DkMLv8in
    Nzih6pdap0QQDE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:RmG7X0BDM4bGWORRsicffM_Ax60UoOQ_ci3CnREZa6_9KbhWeZxhSQ>
    <xmx:RmG7X2eOIvZMgm8gYUjha0L-iP1AwhBC-LoUKGKXa_jXqu5ATwPwRQ>
    <xmx:RmG7XzPw3q2owRKYVRtjaCDi3huvg924gMQRrTC1sLRL08jNzhmt6Q>
    <xmx:RmG7X8oxAgDns0MlRDf0C8Hnn-cKf-OibRKap73o0RYSu2BCj2nh8A>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 21D333280064;
        Mon, 23 Nov 2020 02:14:13 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/10] selftests: mlxsw: Add blackhole nexthop configuration tests
Date:   Mon, 23 Nov 2020 09:12:26 +0200
Message-Id: <20201123071230.676469-7-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123071230.676469-1-idosch@idosch.org>
References: <20201123071230.676469-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test the mlxsw allows blackhole nexthops to be installed and that the
nexthops are marked as offloaded.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  | 25 ++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh b/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
index 5de47d72f8c9..a2eff5f58209 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
@@ -32,6 +32,7 @@ ALL_TESTS="
 	nexthop_obj_invalid_test
 	nexthop_obj_offload_test
 	nexthop_obj_group_offload_test
+	nexthop_obj_blackhole_offload_test
 	nexthop_obj_route_offload_test
 	devlink_reload_test
 "
@@ -693,9 +694,6 @@ nexthop_obj_invalid_test()
 	ip nexthop add id 1 encap mpls 200/300 via 192.0.2.3 dev $swp1
 	check_fail $? "managed to configure a nexthop with MPLS encap when should not"
 
-	ip nexthop add id 1 blackhole
-	check_fail $? "managed to configure a blackhole nexthop when should not"
-
 	ip nexthop add id 1 dev $swp1
 	ip nexthop add id 2 dev $swp1
 	ip nexthop add id 10 group 1/2
@@ -817,6 +815,27 @@ nexthop_obj_group_offload_test()
 	simple_if_fini $swp1 192.0.2.1/24 2001:db8:1::1/64
 }
 
+nexthop_obj_blackhole_offload_test()
+{
+	# Test offload indication of blackhole nexthop objects
+	RET=0
+
+	ip nexthop add id 1 blackhole
+	busywait "$TIMEOUT" wait_for_offload \
+		ip nexthop show id 1
+	check_err $? "Blackhole nexthop not marked as offloaded when should"
+
+	ip nexthop add id 10 group 1
+	busywait "$TIMEOUT" wait_for_offload \
+		ip nexthop show id 10
+	check_err $? "Nexthop group not marked as offloaded when should"
+
+	log_test "blackhole nexthop objects offload indication"
+
+	ip nexthop del id 10
+	ip nexthop del id 1
+}
+
 nexthop_obj_route_offload_test()
 {
 	# Test offload indication of routes using nexthop objects
-- 
2.28.0

