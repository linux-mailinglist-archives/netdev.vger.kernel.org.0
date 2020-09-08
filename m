Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA45B260E63
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgIHJMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:12:08 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:45391 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729053AbgIHJLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 7CB85874;
        Tue,  8 Sep 2020 05:11:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=XKb0zbAbIxWK3KH/ZPc6UgKfOwvCBii/5AO1KSny4OQ=; b=rIGmKS4/
        y0xAtCtLHBLob44AGnnoTZAgDg1WlfDqRmPXMDBDWVUyNVPH79i+yfAUD2NwBhkq
        V0zDIMMuxgGAQHXZX35W/lHosyv75298xjCmoCQ4fRVvLgUEM6Co55NXzU1i4B23
        rldRDmmWpcd4WWnJsHHaF40JIFrJAdE6ohsp2OvcyvH2uUu5u0V9pRnbdFE//I8a
        CZ4Kq3w5xrqAr3qsHdTY6myPt2tIFSOphdrcxs1xXJy8IhVNuMG2Tl/Pbc/u2of9
        SoXH+nQHgrybl6ORHcZrZlR4LzOC35k9O/Cto+FoZmP8kf+mMvqNfS054kRp/uRH
        IrtH33cpeIBAJA==
X-ME-Sender: <xms:y0pXX5iuRldVAMMhuRGNcbMg57SeEkIwTHqEJBNhy1ukKSEy2Kburw>
    <xme:y0pXX-ACC7aV_YN8TG_auRhWUcwVNBP1XlaeJQa_LtOrFDXROiDXo8bh9jcHeDQ-x
    Nw--idYEIYtB4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:y0pXX5HRJUXSBjjT3PME7owwJg7pBq86iYM5rxUwMUSe2MXwvi87sw>
    <xmx:y0pXX-Ts8Z_gp8GsWYYoFKZ7sznHesAFPW9eiHNce9HT0Pf76LdYgw>
    <xmx:y0pXX2x5SssQgVXAYmEy4glRfHWHN3vUINSDcI9PnkI7YIw3y21FyQ>
    <xmx:y0pXX68Y1mFeYXkMynyc_CMFXZWZ_mRnEphPKFvOOkmAAXQOubdVNg>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id B5F71306467D;
        Tue,  8 Sep 2020 05:11:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 09/22] rtnetlink: Add RTNH_F_TRAP flag
Date:   Tue,  8 Sep 2020 12:10:24 +0300
Message-Id: <20200908091037.2709823-10-idosch@idosch.org>
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

The flag indicates to user space that the nexthop is not programmed to
forward packets in hardware, but rather to trap them.

The flag will be used in subsequent patches by netdevsim to test nexthop
objects programming to device drivers and in the future by mlxsw as
well.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/uapi/linux/rtnetlink.h | 6 ++++--
 net/ipv4/fib_semantics.c       | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 9b814c92de12..0ca2057d3269 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -396,11 +396,13 @@ struct rtnexthop {
 #define RTNH_F_DEAD		1	/* Nexthop is dead (used by multipath)	*/
 #define RTNH_F_PERVASIVE	2	/* Do recursive gateway lookup	*/
 #define RTNH_F_ONLINK		4	/* Gateway is forced on link	*/
-#define RTNH_F_OFFLOAD		8	/* offloaded route */
+#define RTNH_F_OFFLOAD		8	/* Nexthop is offloaded */
 #define RTNH_F_LINKDOWN		16	/* carrier-down on nexthop */
 #define RTNH_F_UNRESOLVED	32	/* The entry is unresolved (ipmr) */
+#define RTNH_F_TRAP		64	/* Nexthop is trapping packets */
 
-#define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | RTNH_F_OFFLOAD)
+#define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | \
+				 RTNH_F_OFFLOAD | RTNH_F_TRAP)
 
 /* Macros to handle hexthops */
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 1f75dc686b6b..f70b9a0c4957 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1644,6 +1644,8 @@ int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nhc,
 	*flags |= (nhc->nhc_flags & RTNH_F_ONLINK);
 	if (nhc->nhc_flags & RTNH_F_OFFLOAD)
 		*flags |= RTNH_F_OFFLOAD;
+	if (nhc->nhc_flags & RTNH_F_TRAP)
+		*flags |= RTNH_F_TRAP;
 
 	if (!skip_oif && nhc->nhc_dev &&
 	    nla_put_u32(skb, RTA_OIF, nhc->nhc_dev->ifindex))
-- 
2.26.2

