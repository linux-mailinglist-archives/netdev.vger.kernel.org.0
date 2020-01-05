Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A83E9130904
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 17:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgAEQWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 11:22:15 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42537 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbgAEQWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 11:22:08 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id ADD6821385;
        Sun,  5 Jan 2020 11:22:07 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 05 Jan 2020 11:22:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=UDOoNlR5h8NAYuvXMe3graBfi3eSNflnK9VO5WHxWF0=; b=xDCeoO4n
        UzmP+2EB+CkHMvho/pYCfLovZLCWfINHBOak4KAuroTBLiZYri7j6qkAllWYIWyW
        4TRyYDbmmAY7ght3ezwbTs98PrVBC/PTMRji3gTp0O30ZrQrWwTQWxxpPudgOA6t
        B5j5BchNF0bD3u9l2BJUb6BkHHH8e1F5nFg57Z1vCgngmRtetjV+aXOnjjcKfFRK
        e4A4V2nuRUD7fJ0ulBhHXXp4YBlsjhOC+tSe6XpgKw14zNq5x0Nqp1HA3DgPI9ML
        NqoAxyHTHAePpPl7A3zIIPgc+TNE/r0Sepr/mDJ5Nfc9cbdrAYYUj6bEnSKHTH2Q
        Mv1fEG8dLJ+lMw==
X-ME-Sender: <xms:Lw0SXpXEHs5WSPT4h1-X5zhFY94jMlrhUU83ek70Dojd4Jz5X-FFcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdegkedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:Lw0SXrf5ATrrtgArlLq15BEkX3RgWx23CNEaBGidemzF28lBUc9Fmg>
    <xmx:Lw0SXqD5pWoZCIpfBGZ0QP35E1o8frNUaPQqcZWKuY95dJvx8ncp9g>
    <xmx:Lw0SXq1R2vkf28N2TC_63pVgxyza16TgxCJCneQd0nhvR3vZavfOeg>
    <xmx:Lw0SXllOscGTH5ZPrgOg-UlVCDxu7NrYOBwGRHQSh1DrMaHVW74ctQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 65DC38005A;
        Sun,  5 Jan 2020 11:22:06 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 8/8] selftests: forwarding: router: Add test case for destination IP link-local
Date:   Sun,  5 Jan 2020 18:20:57 +0200
Message-Id: <20200105162057.182547-9-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200105162057.182547-1-idosch@idosch.org>
References: <20200105162057.182547-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add test case to check that packets are not dropped when they need to be
routed and their destination is link-local, i.e., 169.254.0.0/16.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/net/forwarding/router.sh        | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/router.sh b/tools/testing/selftests/net/forwarding/router.sh
index c894f7240417..057f91b05098 100755
--- a/tools/testing/selftests/net/forwarding/router.sh
+++ b/tools/testing/selftests/net/forwarding/router.sh
@@ -8,6 +8,7 @@ ALL_TESTS="
 	mc_mac_mismatch
 	ipv4_sip_equal_dip
 	ipv6_sip_equal_dip
+	ipv4_dip_link_local
 "
 
 NUM_NETIFS=4
@@ -287,6 +288,30 @@ ipv6_sip_equal_dip()
 	tc filter del dev $rp2 egress protocol ipv6 pref 1 handle 101 flower
 }
 
+ipv4_dip_link_local()
+{
+	local dip=169.254.1.1
+
+	RET=0
+
+	tc filter add dev $rp2 egress protocol ip pref 1 handle 101 \
+		flower dst_ip $dip action pass
+
+	ip neigh add 169.254.1.1 lladdr 00:11:22:33:44:55 dev $rp2
+	ip route add 169.254.1.0/24 dev $rp2
+
+	$MZ $h1 -t udp "sp=54321,dp=12345" -c 5 -d 1msec -b $rp1mac -B $dip -q
+
+	tc_check_packets "dev $rp2 egress" 101 5
+	check_err $? "Packets were dropped"
+
+	log_test "IPv4 destination IP is link-local"
+
+	ip route del 169.254.1.0/24 dev $rp2
+	ip neigh del 169.254.1.1 lladdr 00:11:22:33:44:55 dev $rp2
+	tc filter del dev $rp2 egress protocol ip pref 1 handle 101 flower
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.24.1

