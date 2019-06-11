Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 853EC3C4DB
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 09:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404277AbfFKHUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 03:20:17 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36231 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404224AbfFKHUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 03:20:16 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 991C822405;
        Tue, 11 Jun 2019 03:20:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 03:20:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=pAaI/fIx0m24bCeotViRRYs2RuLkc1x6WdyfKqQVN+U=; b=QiZU9Fqi
        mt3tD4C6nV7IeIosQqiPxutx6mJLhMC4KnvIljLD8moKskmfcVRrkYQckDyWBmmf
        eag4EoOVljoTrsq58ZS3do0cq5AsdrwYcDhLWMBFySjaM09j5+AtvpZzjdcggeRK
        zno+tW5dlw0GsxWt2ZomgiKZ32u4dr/rTllb+9ard7GsmicZSCYpPxXZMJbL6Z2A
        CVN589XpF1XXUoWsYDuR/77BXOR+8Kwpd0D0Sj5JyZDceUEVm35soHQ7PDq4PfBn
        kElgQ2QoyFchDAtN9350tc/1gjTc4mFAEy6kp0VrK3xjA8pCxOwpjKRJXg9s8E8S
        tawvc0FlCylDVQ==
X-ME-Sender: <xms:L1b_XNRudqk9iJmtbXbmsdOF_x8wau6XIlTWLK0tKl2LJ_zroS2H3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehfedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:L1b_XMIFgi3cHaWRDTXuQgwI6fNGQnPAl2xwbMAewzDoW2DetY987g>
    <xmx:L1b_XPTBhI_po3YYDwPn2YTmNbG27_mDv3UbO3ZCh4i2OW4e5VqKjw>
    <xmx:L1b_XKJe-OrG6x60dR--hFTQrNKiYGV452SlKf2m57dMFrJ8QaF6kQ>
    <xmx:L1b_XCENTJVwseYSBRY5H2PfVpTkGSTDHOvw0LeUta5zFKtBNm_hEA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 20E00380084;
        Tue, 11 Jun 2019 03:20:13 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 3/7] selftests: mlxsw: Test nexthop offload indication
Date:   Tue, 11 Jun 2019 10:19:42 +0300
Message-Id: <20190611071946.11089-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611071946.11089-1-idosch@idosch.org>
References: <20190611071946.11089-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Test that IPv4 and IPv6 nexthops are correctly marked with offload
indication in response to neighbour events.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh b/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
index 1c30f302a1e7..5c39e5f6a480 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
@@ -28,6 +28,7 @@ ALL_TESTS="
 	vlan_interface_uppers_test
 	bridge_extern_learn_test
 	neigh_offload_test
+	nexthop_offload_test
 	devlink_reload_test
 "
 NUM_NETIFS=2
@@ -607,6 +608,52 @@ neigh_offload_test()
 	ip -4 address del 192.0.2.1/24 dev $swp1
 }
 
+nexthop_offload_test()
+{
+	# Test that IPv4 and IPv6 nexthops are marked as offloaded
+	RET=0
+
+	sysctl_set net.ipv6.conf.$swp2.keep_addr_on_down 1
+	simple_if_init $swp1 192.0.2.1/24 2001:db8:1::1/64
+	simple_if_init $swp2 192.0.2.2/24 2001:db8:1::2/64
+	setup_wait
+
+	ip -4 route add 198.51.100.0/24 vrf v$swp1 \
+		nexthop via 192.0.2.2 dev $swp1
+	ip -6 route add 2001:db8:2::/64 vrf v$swp1 \
+		nexthop via 2001:db8:1::2 dev $swp1
+
+	ip -4 route show 198.51.100.0/24 vrf v$swp1 | grep -q offload
+	check_err $? "ipv4 nexthop not marked as offloaded when should"
+	ip -6 route show 2001:db8:2::/64 vrf v$swp1 | grep -q offload
+	check_err $? "ipv6 nexthop not marked as offloaded when should"
+
+	ip link set dev $swp2 down
+	sleep 1
+
+	ip -4 route show 198.51.100.0/24 vrf v$swp1 | grep -q offload
+	check_fail $? "ipv4 nexthop marked as offloaded when should not"
+	ip -6 route show 2001:db8:2::/64 vrf v$swp1 | grep -q offload
+	check_fail $? "ipv6 nexthop marked as offloaded when should not"
+
+	ip link set dev $swp2 up
+	setup_wait
+
+	ip -4 route show 198.51.100.0/24 vrf v$swp1 | grep -q offload
+	check_err $? "ipv4 nexthop not marked as offloaded after neigh add"
+	ip -6 route show 2001:db8:2::/64 vrf v$swp1 | grep -q offload
+	check_err $? "ipv6 nexthop not marked as offloaded after neigh add"
+
+	log_test "nexthop offload indication"
+
+	ip -6 route del 2001:db8:2::/64 vrf v$swp1
+	ip -4 route del 198.51.100.0/24 vrf v$swp1
+
+	simple_if_fini $swp2 192.0.2.2/24 2001:db8:1::2/64
+	simple_if_fini $swp1 192.0.2.1/24 2001:db8:1::1/64
+	sysctl_restore net.ipv6.conf.$swp2.keep_addr_on_down
+}
+
 devlink_reload_test()
 {
 	# Test that after executing all the above configuration tests, a
-- 
2.20.1

