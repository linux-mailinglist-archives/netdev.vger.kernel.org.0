Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931602C0084
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 08:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgKWHOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 02:14:18 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:37389 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727852AbgKWHOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 02:14:17 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 5CA3AF52;
        Mon, 23 Nov 2020 02:14:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 23 Nov 2020 02:14:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Xotj9EEJEHn3tM8AZRQbmdC7SRow88AUneWfRN1xuA4=; b=EkQFSdz3
        e59cEUV/WUNh4ZrVwIS1rFwwjHFqkWOjaU+qH25F0zbll1NjoT8OLnVrtzZyXEw7
        +k5JO9PLthlOPyyDrsxQXa95JHMQUULqvKydzcFU0ZeZ4k1170OPtmrazCeHX1je
        HWip2rdxJQfWmTOAp34phfO4gquMk22ycnyZcELwnxP5SkcqJ8r+qO+M9bnAWula
        uSuzYIPdjqnxoHBLU2HErr0BoAfMhg4vW622mwzRPXCEUA/WWbJOC0K6Ffvfgm2M
        1q9RwBc7cXKi2g0St+SbtrtNOlthseFZ+hmtxbwnBdsORB5oq/tx3mH7GCD+v3sW
        WebL8m9q8uPnJA==
X-ME-Sender: <xms:R2G7X3rh1rO0h1_jOMoifTeoBMFzc2hPMNb0AcCNOI9T5LZCOVOAmA>
    <xme:R2G7Xxq5f5HfLNlNJ7vLDKdXP2M8Nv7J6RObSuqJrx8j_Bdf5xJ5iMpBftWBZKfjO
    7VlFjsOkmOqRLM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:R2G7X0OEB9sAjet8aPBxMIXQoWcNdc_lDV1oJWGer1LZSuRg3lAzgw>
    <xmx:R2G7X67urk-d9-PCeg79tvMK68pToLPJs_kKOstBqFSRQ4YI_punaQ>
    <xmx:R2G7X264l0BS97S-XEcU8xwkQDSrDhJ-LwxAuAUf-6B6VVpciDYuNQ>
    <xmx:SGG7X8kZ7MMJqc_NdTmT9xDobcfInOzrHCXKwhh46Bv2-qZbavyaNQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 980D9328005E;
        Mon, 23 Nov 2020 02:14:14 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/10] selftests: forwarding: Add blackhole nexthops tests
Date:   Mon, 23 Nov 2020 09:12:27 +0200
Message-Id: <20201123071230.676469-8-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123071230.676469-1-idosch@idosch.org>
References: <20201123071230.676469-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that IPv4 and IPv6 ping fail when the route is using a blackhole
nexthop or a group with a blackhole nexthop. Test that ping passes when
the route starts using a valid nexthop.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/forwarding/router_mpath_nh.sh         | 58 ++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/router_mpath_nh.sh b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
index e8c2573d5232..388e4492b81b 100755
--- a/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
+++ b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
@@ -1,7 +1,13 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-ALL_TESTS="ping_ipv4 ping_ipv6 multipath_test"
+ALL_TESTS="
+	ping_ipv4
+	ping_ipv6
+	multipath_test
+	ping_ipv4_blackhole
+	ping_ipv6_blackhole
+"
 NUM_NETIFS=8
 source lib.sh
 
@@ -302,6 +308,56 @@ multipath_test()
 	multipath6_l4_test "Weighted MP 11:45" 11 45
 }
 
+ping_ipv4_blackhole()
+{
+	RET=0
+
+	ip nexthop add id 1001 blackhole
+	ip nexthop add id 1002 group 1001
+
+	ip route replace 198.51.100.0/24 vrf vrf-r1 nhid 1001
+	ping_do $h1 198.51.100.2
+	check_fail $? "ping did not fail when using a blackhole nexthop"
+
+	ip route replace 198.51.100.0/24 vrf vrf-r1 nhid 1002
+	ping_do $h1 198.51.100.2
+	check_fail $? "ping did not fail when using a blackhole nexthop group"
+
+	ip route replace 198.51.100.0/24 vrf vrf-r1 nhid 103
+	ping_do $h1 198.51.100.2
+	check_err $? "ping failed with a valid nexthop"
+
+	log_test "IPv4 blackhole ping"
+
+	ip nexthop del id 1002
+	ip nexthop del id 1001
+}
+
+ping_ipv6_blackhole()
+{
+	RET=0
+
+	ip -6 nexthop add id 1001 blackhole
+	ip nexthop add id 1002 group 1001
+
+	ip route replace 2001:db8:2::/64 vrf vrf-r1 nhid 1001
+	ping6_do $h1 2001:db8:2::2
+	check_fail $? "ping did not fail when using a blackhole nexthop"
+
+	ip route replace 2001:db8:2::/64 vrf vrf-r1 nhid 1002
+	ping6_do $h1 2001:db8:2::2
+	check_fail $? "ping did not fail when using a blackhole nexthop group"
+
+	ip route replace 2001:db8:2::/64 vrf vrf-r1 nhid 106
+	ping6_do $h1 2001:db8:2::2
+	check_err $? "ping failed with a valid nexthop"
+
+	log_test "IPv6 blackhole ping"
+
+	ip nexthop del id 1002
+	ip -6 nexthop del id 1001
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}
-- 
2.28.0

