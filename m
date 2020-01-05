Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEAD1308FD
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 17:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgAEQWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 11:22:01 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55445 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726422AbgAEQWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 11:22:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B05072129D;
        Sun,  5 Jan 2020 11:21:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 05 Jan 2020 11:21:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=q/NpUy729zuLQXFx963mdCU2DCdSNtS5szFbahapI
        Us=; b=OLGanfaG2qSfLghR12WRixQS/qsyQYLHR0FgY7uu/0qMWVaQj63X+eKhs
        QsDwJH382ZuPbNehV1fT4VGMZfTBLWZ0xy2yqFvP72+26iyF2dpbNLP1k9THTJ1D
        HtIminhuglrnsZPDtUGZ8b+OICC5uWek4rXSzAiQIrrXc+q1L04REGJWi6e4PVw2
        8mZy0j4bgZ1WUMnbZndKAO6p6El8bYXnzWq39vdh0gJf22p/ad8UUAmiDqxl92Mk
        tQk1xy7Vl4hZ7z338/w/g6PeYdacloxijS64/3oNfrDAd4FxO5CDZ05bxscikSsT
        KB0NFyE0iaywIJAd+Y0U1QHntM0XA==
X-ME-Sender: <xms:Jw0SXtv-PxcIBBCdg_sqsdZiTwf8Fvuhb_IQH-xn-n_SLgPMHwNQdg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdegkedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhggtgfgsehtke
    ertdertdejnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:Jw0SXhNWSJkuamS5_VLjoVIGGfUIuh5NR7QgSrXjSnb-vX78X860pQ>
    <xmx:Jw0SXvqHSCFq00cOV-srgTEiWscIdPihMCZ8TJVuJpE8beSZ9QwKKA>
    <xmx:Jw0SXq_azBgIurGpbLat8sy1OvAlREoGe0XeyqdsRyCz_ZvEN4IoTw>
    <xmx:Jw0SXtWeOBlqVjF3db-HXPE_y109q6xe130FiQD3WmnelYXcbWdJhw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 62E158005A;
        Sun,  5 Jan 2020 11:21:58 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/8] selftests: forwarding: router: Add test case for source IP in class E
Date:   Sun,  5 Jan 2020 18:20:51 +0200
Message-Id: <20200105162057.182547-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200105162057.182547-1-idosch@idosch.org>
References: <20200105162057.182547-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add test case to check that packets are not dropped when they need to be
routed and their source IP in class E, (i.e., 240.0.0.0 –
255.255.255.254).

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/net/forwarding/router.sh        | 38 ++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/router.sh b/tools/testing/selftests/net/forwarding/router.sh
index a75cb51cc5bd..6ad652ad7e73 100755
--- a/tools/testing/selftests/net/forwarding/router.sh
+++ b/tools/testing/selftests/net/forwarding/router.sh
@@ -1,9 +1,15 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-ALL_TESTS="ping_ipv4 ping_ipv6"
+ALL_TESTS="
+	ping_ipv4
+	ping_ipv6
+	sip_in_class_e
+"
+
 NUM_NETIFS=4
 source lib.sh
+source tc_common.sh
 
 h1_create()
 {
@@ -64,6 +70,8 @@ router_create()
 	ip link set dev $rp1 up
 	ip link set dev $rp2 up
 
+	tc qdisc add dev $rp2 clsact
+
 	ip address add 192.0.2.1/24 dev $rp1
 	ip address add 2001:db8:1::1/64 dev $rp1
 
@@ -79,6 +87,8 @@ router_destroy()
 	ip address del 2001:db8:1::1/64 dev $rp1
 	ip address del 192.0.2.1/24 dev $rp1
 
+	tc qdisc del dev $rp2 clsact
+
 	ip link set dev $rp2 down
 	ip link set dev $rp1 down
 }
@@ -91,6 +101,8 @@ setup_prepare()
 	rp2=${NETIFS[p3]}
 	h2=${NETIFS[p4]}
 
+	rp1mac=$(mac_get $rp1)
+
 	vrf_prepare
 
 	h1_create
@@ -125,6 +137,30 @@ ping_ipv6()
 	ping6_test $h1 2001:db8:2::2
 }
 
+sip_in_class_e()
+{
+	RET=0
+
+	# Disable rpfilter to prevent packets to be dropped because of it.
+	sysctl_set net.ipv4.conf.all.rp_filter 0
+	sysctl_set net.ipv4.conf.$rp1.rp_filter 0
+
+	tc filter add dev $rp2 egress protocol ip pref 1 handle 101 \
+		flower src_ip 240.0.0.1 ip_proto udp action pass
+
+	$MZ $h1 -t udp "sp=54321,dp=12345" -c 5 -d 1msec \
+		-A 240.0.0.1 -b $rp1mac -B 198.51.100.2 -q
+
+	tc_check_packets "dev $rp2 egress" 101 5
+	check_err $? "Packets were dropped"
+
+	log_test "Source IP in class E"
+
+	tc filter del dev $rp2 egress protocol ip pref 1 handle 101 flower
+	sysctl_restore net.ipv4.conf.$rp1.rp_filter
+	sysctl_restore net.ipv4.conf.all.rp_filter
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.24.1

