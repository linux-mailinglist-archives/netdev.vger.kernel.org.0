Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F783078AE
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhA1OwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:52:08 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:40831 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232435AbhA1OuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 09:50:06 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id B9172F83;
        Thu, 28 Jan 2021 09:48:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 28 Jan 2021 09:48:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=1geX2nn+ATg9s4e65A/Rp/VbioppHjxwyUAqG2mKGV8=; b=MH858Cgd
        4Yabd9f5191l+Yxq6zDEycbv7UZcRasLMM2sLmEdkq0crEXpZw7ohaWdVsvFsmXI
        MeVLN88TNwGqJgdugKiekCGnVzJk7as+X7KhXnLWd4kXhbA1mxxrqVwyQxZQ1hoU
        UWImYVN5QtOiyI2xdKWBAZ3MEzXfXK/c5gbZQRmb8SYHzDJCgIbFmr2RNT7G0Gca
        fIOGxSkAyXF1mI9NTqti1o4Dfuw8AYy6JsWvm+M8NNXD6Y4YuDcOoWQKCqA6cPZ7
        0DhIS7f8z4qvGgrfQ56RD/8GIbCFRJuqO6r3blZpIEFQVvfPwlDNinrIb9sVKaRY
        boVylEnOior7LQ==
X-ME-Sender: <xms:2c4SYNim5d0Vz5mQSI4H_8AGlOLpvw1bl7Du8panTdUBuAtGrWgknA>
    <xme:2c4SYCA2xDVXrpN5OJ82LeWri1lnmxruVAGRr85Ht2PHAJracL3vyBmY0jc6G9tMC
    bTke6vaMynTyFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:2c4SYNEjDMpJV_PHyxr3n2BydjldgSalCAonp5l4NiyVJruEkmAH9Q>
    <xmx:2c4SYCRy6HYIoEcELP5WPGyRFW42VSmI57m-FeLKe55uWCFI6e9XRg>
    <xmx:2c4SYKy1-CQFqHefBr5qovcPoHyQrCULOs4TL2Qtwy2YaVGU055CCg>
    <xmx:2c4SYO_n7IPDWB3-wfzhsjFJDvFv0IcL2MnDkj7iOFUvoAlWEXGPnQ>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8FC7E240067;
        Thu, 28 Jan 2021 09:48:55 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 1/2] selftests: forwarding: Specify interface when invoking mausezahn
Date:   Thu, 28 Jan 2021 16:48:19 +0200
Message-Id: <20210128144820.3280295-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128144820.3280295-1-idosch@idosch.org>
References: <20210128144820.3280295-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Specify the interface through which packets should be transmitted so
that the test will pass regardless of the libnet version against which
mausezahn is linked.

Fixes: cab14d1087d9 ("selftests: Add version of router_multipath.sh using nexthop objects")
Fixes: 3d578d879517 ("selftests: forwarding: Test IPv4 weighted nexthops")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/forwarding/router_mpath_nh.sh  | 2 +-
 tools/testing/selftests/net/forwarding/router_multipath.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/router_mpath_nh.sh b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
index 388e4492b81b..76efb1f8375e 100755
--- a/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
+++ b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
@@ -203,7 +203,7 @@ multipath4_test()
 	t0_rp12=$(link_stats_tx_packets_get $rp12)
 	t0_rp13=$(link_stats_tx_packets_get $rp13)
 
-	ip vrf exec vrf-h1 $MZ -q -p 64 -A 192.0.2.2 -B 198.51.100.2 \
+	ip vrf exec vrf-h1 $MZ $h1 -q -p 64 -A 192.0.2.2 -B 198.51.100.2 \
 		-d 1msec -t udp "sp=1024,dp=0-32768"
 
 	t1_rp12=$(link_stats_tx_packets_get $rp12)
diff --git a/tools/testing/selftests/net/forwarding/router_multipath.sh b/tools/testing/selftests/net/forwarding/router_multipath.sh
index 79a209927962..464821c587a5 100755
--- a/tools/testing/selftests/net/forwarding/router_multipath.sh
+++ b/tools/testing/selftests/net/forwarding/router_multipath.sh
@@ -178,7 +178,7 @@ multipath4_test()
        t0_rp12=$(link_stats_tx_packets_get $rp12)
        t0_rp13=$(link_stats_tx_packets_get $rp13)
 
-       ip vrf exec vrf-h1 $MZ -q -p 64 -A 192.0.2.2 -B 198.51.100.2 \
+       ip vrf exec vrf-h1 $MZ $h1 -q -p 64 -A 192.0.2.2 -B 198.51.100.2 \
 	       -d 1msec -t udp "sp=1024,dp=0-32768"
 
        t1_rp12=$(link_stats_tx_packets_get $rp12)
-- 
2.29.2

