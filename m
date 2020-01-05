Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF48130906
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 17:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgAEQWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 11:22:13 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58223 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726504AbgAEQWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 11:22:05 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1294421111;
        Sun,  5 Jan 2020 11:22:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 05 Jan 2020 11:22:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=1Ige5fePV/tEBlSktpmmzjOwOjHAmUmNdaMcvJVMGL8=; b=Ol7cwUdk
        boV5dssVe2vH4bXtsQamIVklcjnUgB0arfn5ytDbz4l4FQKKWK32OQXjOS1mUJJF
        /3vMGge82h/fvMB7Kh0mM9Oy+q8UVCbdRLpqP8C5qq+LZ6/e8N+cKR/LRfAKILIe
        G8gW55fULKeoq8FtkQEnB2Z/BfLlcd3Y8UoWcOwa0omf7zDzHIlwI1zxFS3u06mF
        Oxn6AASIbsxwJrqYK7i8raBUBBMa0ZTBKLJpDkNvlSDiy/oK0kDfd6ni3jQJZuTJ
        9RUeoqV3iAWm69d5f0ZFzcVxqS+5dQRxppmRJ+TdV/dkK3NS2K8oul9PNuGntjiB
        6CiX9qDjN33IHw==
X-ME-Sender: <xms:LA0SXtCLpPxfKgputxsXBkCaRv00VnhPlpIyPA-2Bwb5GxeX_E67yg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdegkedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:LA0SXnCxO-ArU7dlJ0vDi0kMfprtIDWQRZQOwxywfJrUhMwZ_zkcEw>
    <xmx:LA0SXvlv6R1_y_VydD-UGR78SQQhOmsdLJBUj5sZ0TbEHmiyRJcjoQ>
    <xmx:LA0SXgtpXxerUjcS8NUs-ClpCkUXbQG6mPrla2nO17CdzRxfZJfVfQ>
    <xmx:LQ0SXjQn3QdTzFOT7FQkxD4qFZnH4BXnO25GoDB6BtS1qoDXOHwGOg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B947F8005C;
        Sun,  5 Jan 2020 11:22:03 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/8] selftests: forwarding: router: Add test case for source IP equals destination IP
Date:   Sun,  5 Jan 2020 18:20:55 +0200
Message-Id: <20200105162057.182547-7-idosch@idosch.org>
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
routed and their source IP equals to their destination IP.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/net/forwarding/router.sh        | 44 +++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/router.sh b/tools/testing/selftests/net/forwarding/router.sh
index e1f4d6145326..c894f7240417 100755
--- a/tools/testing/selftests/net/forwarding/router.sh
+++ b/tools/testing/selftests/net/forwarding/router.sh
@@ -6,6 +6,8 @@ ALL_TESTS="
 	ping_ipv6
 	sip_in_class_e
 	mc_mac_mismatch
+	ipv4_sip_equal_dip
+	ipv6_sip_equal_dip
 "
 
 NUM_NETIFS=4
@@ -243,6 +245,48 @@ mc_mac_mismatch()
 	__mc_mac_mismatch "IPv6" "ipv6" 2001:db8:1::2 ff0e::3 "-6"
 }
 
+ipv4_sip_equal_dip()
+{
+	RET=0
+
+	# Disable rpfilter to prevent packets to be dropped because of it.
+	sysctl_set net.ipv4.conf.all.rp_filter 0
+	sysctl_set net.ipv4.conf.$rp1.rp_filter 0
+
+	tc filter add dev $rp2 egress protocol ip pref 1 handle 101 \
+		flower src_ip 198.51.100.2  action pass
+
+	$MZ $h1 -t udp "sp=54321,dp=12345" -c 5 -d 1msec \
+		-A 198.51.100.2 -b $rp1mac -B 198.51.100.2 -q
+
+	tc_check_packets "dev $rp2 egress" 101 5
+	check_err $? "Packets were dropped"
+
+	log_test "Source IP is equal to destination IP: IPv4"
+
+	tc filter del dev $rp2 egress protocol ip pref 1 handle 101 flower
+	sysctl_restore net.ipv4.conf.$rp1.rp_filter
+	sysctl_restore net.ipv4.conf.all.rp_filter
+}
+
+ipv6_sip_equal_dip()
+{
+	RET=0
+
+	tc filter add dev $rp2 egress protocol ipv6 pref 1 handle 101 \
+		flower src_ip 2001:db8:2::2 action pass
+
+	$MZ -6 $h1 -t udp "sp=54321,dp=12345" -c 5 -d 1msec \
+		-A 2001:db8:2::2 -b $rp1mac -B 2001:db8:2::2 -q
+
+	tc_check_packets "dev $rp2 egress" 101 5
+	check_err $? "Packets were dropped"
+
+	log_test "Source IP is equal to destination IP: IPv6"
+
+	tc filter del dev $rp2 egress protocol ipv6 pref 1 handle 101 flower
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.24.1

