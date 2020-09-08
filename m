Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05035260E74
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbgIHJNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:13:12 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:45637 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729052AbgIHJLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:39 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 0238D3C6;
        Tue,  8 Sep 2020 05:11:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=NkaXZepXzpaomR4hXyyn0XleJZwI74iwndY/nQLwW3A=; b=g7jjH+2B
        atD/GphWPAwoUZaU/CPomcsP/d78M/3pAElxK8k/SVjGldKelvt5f/iDmRxRu+++
        xXeUqCuGOO4Lz2yqZZvdmk/EEfNu2/KuFAtarhosGkpOu7J2jXMbYe8CX6wP4IkV
        ezs1mjWhRrQCG/nGQRV4Ny2ze8DMsIlYtARYYyMTgoVfLrVV0um63XptaM5QRDIv
        UwU2MoGr68JG3lUytqweh6WI2G0BkdbPDkAJs529toxQ/vUVOTzzi7d5nokmhdLv
        S3cx7DNGLZHjQ8TXMys2XJ+cCHeeimvdwowM/6fpVnL1SuHnWlyhExadodE8/w5y
        WP8leUHSvLbXUA==
X-ME-Sender: <xms:yUpXX4pGhBQhaL7bV7Ez3mNeMYrQMyydplx82Bm2rhDKQH2O5uK1YA>
    <xme:yUpXX-og4I6O3ALvX26XCX3IWzvt0KI6omYK1LlJcfki5V49y63WnQLreDfo3Okxd
    pL1DLy7hJ51YLI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:yUpXX9OXGG6fDP0-N8fuY3ED_C_ZdtuNgEkLGqcGsetDItAb83Hmlg>
    <xmx:yUpXX_6iRy6HLQwJ0R1BCl172CO4FWnQuw9CCQufZY072dzgFkpzmw>
    <xmx:yUpXX35eXNNbEg6ol52auO2ZiMKL8IgnaS79Qwekkj15EHuSDc_xOw>
    <xmx:yUpXX5n4OM3b6nt_Afo5oIfGnBDSPNuLMmR-wsP2QHeOYpztxUdoFg>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3A609306467E;
        Tue,  8 Sep 2020 05:11:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 08/22] nexthop: vxlan: Convert to new notification info
Date:   Tue,  8 Sep 2020 12:10:23 +0300
Message-Id: <20200908091037.2709823-9-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908091037.2709823-1-idosch@idosch.org>
References: <20200908091037.2709823-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Convert the sole listener of the nexthop notification chain (the VXLAN
driver) to the new notification info.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/vxlan.c | 9 +++++++--
 net/ipv4/nexthop.c  | 2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index b9fefe27e3e8..29deedee6ef4 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -4687,9 +4687,14 @@ static void vxlan_fdb_nh_flush(struct nexthop *nh)
 static int vxlan_nexthop_event(struct notifier_block *nb,
 			       unsigned long event, void *ptr)
 {
-	struct nexthop *nh = ptr;
+	struct nh_notifier_info *info = ptr;
+	struct nexthop *nh;
+
+	if (event != NEXTHOP_EVENT_DEL)
+		return NOTIFY_DONE;
 
-	if (!nh || event != NEXTHOP_EVENT_DEL)
+	nh = nexthop_find_by_id(info->net, info->id);
+	if (!nh)
 		return NOTIFY_DONE;
 
 	vxlan_fdb_nh_flush(nh);
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 68fd25c6eec7..70c8ab6906ec 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -150,7 +150,7 @@ static int call_nexthop_notifiers(struct net *net,
 	}
 
 	err = blocking_notifier_call_chain(&net->nexthop.notifier_chain,
-					   event_type, nh);
+					   event_type, &info);
 	nh_notifier_info_fini(&info);
 
 	return notifier_to_errno(err);
-- 
2.26.2

