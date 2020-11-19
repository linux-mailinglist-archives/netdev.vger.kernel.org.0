Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661302B9333
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgKSNJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:09:37 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:37789 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgKSNJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 08:09:37 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 0228EF11;
        Thu, 19 Nov 2020 08:09:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 19 Nov 2020 08:09:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=m7NAHsVT8i3NCCHJx3EAdIRH4sbLSsRK6Oiniuw4+JE=; b=GpRT1Qf3
        HW0GwZC7vxzquqNECU914JfdoVFygNhCFBqTuix1DJASdAS0wXRjT97PwjcIfw5l
        pbcI8xV/64GUanzq2JwGLEGpnwSqP+z/heZIGkL6jhgFg2kX7FkSKrGpWyJm4ZqI
        b1iZ6Ty/kjfgpMJrUYnWfwOGwZ6Ck59zE1m1vFrCzI8ewJ9fZVxBvMDpC/afZth1
        EfUeZQGXDqPm+n0A6GaaRnVII3MmPrpro5pjcbo2IWe/HbvAthdNqh3m1WvoZohy
        76hFbAoTCaC2IEgk557leuvIpFBJAp1YMxnhRlVwUSSyVxWRbAq5Ter039oMfAoX
        mVj6T41T4uRGbg==
X-ME-Sender: <xms:jm62Xyx8rWkOOShBVFQLu5uYNj9VDyVlMbnG3n_KceM4Qj2emMs_FA>
    <xme:jm62X-SC88QUsVzhG13c8W14xzwOHXPuCFM7D4HFZUWA5qfw9GjuAwNCZLIDvT54m
    Xz0MDzuKWn7pzY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefjedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:jm62X0Xr1_w2wwpmGGCW_iVsB08wS8xZLrxELzCwVxLnyu4_Gr93KA>
    <xmx:jm62X4iWzqO3mwBw_RNLs0ME08E6dnKyiLG67-COK96IWsGqpPu4cQ>
    <xmx:jm62X0AM2EvkK_IbLG7g-aW-OH9cFBcERYjlsMDM0c1z7K_wNEwxyA>
    <xmx:jm62X3PZOQWBlQ8NGg2GVq1aoTcf2Xgvr5LXAedXcoMXP7R75CHzIg>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 00140328005A;
        Thu, 19 Nov 2020 08:09:32 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/8] selftests: forwarding: Test IPv4 routes with IPv6 link-local nexthops
Date:   Thu, 19 Nov 2020 15:08:46 +0200
Message-Id: <20201119130848.407918-7-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201119130848.407918-1-idosch@idosch.org>
References: <20201119130848.407918-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

In addition to IPv4 multipath tests with IPv4 nexthops, also test IPv4
multipath with nexthops that use IPv6 link-local addresses.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/router_mpath_nh.sh       | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/router_mpath_nh.sh b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
index 6067477ff326..e8c2573d5232 100755
--- a/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
+++ b/tools/testing/selftests/net/forwarding/router_mpath_nh.sh
@@ -280,6 +280,17 @@ multipath_test()
 	multipath4_test "Weighted MP 2:1" 2 1
 	multipath4_test "Weighted MP 11:45" 11 45
 
+	log_info "Running IPv4 multipath tests with IPv6 link-local nexthops"
+	ip nexthop replace id 101 via fe80:2::22 dev $rp12
+	ip nexthop replace id 102 via fe80:3::23 dev $rp13
+
+	multipath4_test "ECMP" 1 1
+	multipath4_test "Weighted MP 2:1" 2 1
+	multipath4_test "Weighted MP 11:45" 11 45
+
+	ip nexthop replace id 102 via 169.254.3.23 dev $rp13
+	ip nexthop replace id 101 via 169.254.2.22 dev $rp12
+
 	log_info "Running IPv6 multipath tests"
 	multipath6_test "ECMP" 1 1
 	multipath6_test "Weighted MP 2:1" 2 1
-- 
2.28.0

