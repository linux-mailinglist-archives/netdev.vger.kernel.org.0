Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CA22B1F87
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgKMQGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:06:35 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50961 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726711AbgKMQGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:06:34 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id ECADF5C0196;
        Fri, 13 Nov 2020 11:06:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 13 Nov 2020 11:06:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=o1XBkDXq9A91M+ZniTnumsXLDRdzaTNc19pQUqS3jhg=; b=JU/2wX1q
        dpKHh/42nSf+F8Th5cu4eUyKmUZDlcLdpanFRqFvbWdV7wdkY6/h8bHwwy1cxjg4
        mO7DtUfjrdQFrNKPZCIoLIWioO7tQYn/TLYova6pfg4Cs1i3np8QEhL2Z09i6EUI
        Q2fvEe+HkijnMsEVVhljHX4zytqUjKjCZ+YgwxXDkYCV5ueuL+ZRQdbPGrttp7SK
        owUDc4CtsEY3UmTvIU9ip7UPYw7qW/06/EDB80BqyljmSJst5enu/YDPniz15Rbm
        Pnzh7MpYtE1SjGiL9UMt5HlZR5oUwxQ+yYHZg+0ZiCGvVNOejoB1wdu7PN7t+Bz9
        llTKpRvHtZo79w==
X-ME-Sender: <xms:CK-uX4LugAuegrYYWtcbOD79aTMxJPZT3HTpmfZsXLN3IBuVMbZCRw>
    <xme:CK-uX4J1_J9tmz3If9Lp_tX2qZ6r9_JXKc24YgyOFAGblGX8hY4nI_AsnAsdnkJRB
    0kppDmTzEf1Khg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvhedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:CK-uX4ssSfdWDhj0F1RGQdN65Zg7lvI-8KFNMF7elFMHA8WSfw8i3A>
    <xmx:CK-uX1ZFNOeqokgAQT71cLqsRkxQfY5_XPAVuHVc6SgRu6Kp078aiQ>
    <xmx:CK-uX_aNGCP7ACml9YTwT0YmigeBr1S08vsZEnGNTF2toqdCLwDmmw>
    <xmx:CK-uX7GpoNlanaZLNjOh1Ipoky-6-lOMpxaZnEFBsOSpfTAhwcy1Iw>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id C7DF13280059;
        Fri, 13 Nov 2020 11:06:30 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/15] mlxsw: spectrum_router: Compare key with correct object type
Date:   Fri, 13 Nov 2020 18:05:45 +0200
Message-Id: <20201113160559.22148-2-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113160559.22148-1-idosch@idosch.org>
References: <20201113160559.22148-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

When comparing a key with a nexthop group in rhastable's obj_cmpfn()
callback, make sure that the key and nexthop group are of the same type
(i.e., IPv4 / IPv6).

The bug is not currently visible because IPv6 nexthop groups do not
populate the FIB info pointer and IPv4 nexthop groups do not set the
ifindex for the individual nexthops.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c    | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index e692e5a39f6c..55ae16b03c44 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3040,6 +3040,12 @@ mlxsw_sp_nexthop6_group_cmp(const struct mlxsw_sp_nexthop_group *nh_grp,
 	return true;
 }
 
+static int
+mlxsw_sp_nexthop_group_type(const struct mlxsw_sp_nexthop_group *nh_grp)
+{
+	return nh_grp->neigh_tbl->family;
+}
+
 static int
 mlxsw_sp_nexthop_group_cmp(struct rhashtable_compare_arg *arg, const void *ptr)
 {
@@ -3048,8 +3054,12 @@ mlxsw_sp_nexthop_group_cmp(struct rhashtable_compare_arg *arg, const void *ptr)
 
 	switch (cmp_arg->proto) {
 	case MLXSW_SP_L3_PROTO_IPV4:
+		if (mlxsw_sp_nexthop_group_type(nh_grp) != AF_INET)
+			return 1;
 		return cmp_arg->fi != mlxsw_sp_nexthop4_group_fi(nh_grp);
 	case MLXSW_SP_L3_PROTO_IPV6:
+		if (mlxsw_sp_nexthop_group_type(nh_grp) != AF_INET6)
+			return 1;
 		return !mlxsw_sp_nexthop6_group_cmp(nh_grp,
 						    cmp_arg->fib6_entry);
 	default:
@@ -3058,12 +3068,6 @@ mlxsw_sp_nexthop_group_cmp(struct rhashtable_compare_arg *arg, const void *ptr)
 	}
 }
 
-static int
-mlxsw_sp_nexthop_group_type(const struct mlxsw_sp_nexthop_group *nh_grp)
-{
-	return nh_grp->neigh_tbl->family;
-}
-
 static u32 mlxsw_sp_nexthop_group_hash_obj(const void *data, u32 len, u32 seed)
 {
 	const struct mlxsw_sp_nexthop_group *nh_grp = data;
-- 
2.28.0

