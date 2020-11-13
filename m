Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A832B1F89
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgKMQGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:06:40 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38425 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726820AbgKMQGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:06:38 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5ED9D5C018D;
        Fri, 13 Nov 2020 11:06:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 13 Nov 2020 11:06:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=IBrzSspowBd/z6CVV19Iiia/ZOlUHXEC0u5ZszLv5WQ=; b=i9NZ+20B
        a9CpxuMu416hjKLpbeySKgGvfPXE3VrFLmjM3HPUu+MIzUyBISkzac0eHwLkv6+P
        tYP3B1ucrD4PGXrSdap25RlVaZLTY9pEcrnGQHRrzqN4KBNwdxFeLK0gpLjHfTon
        J2tE8hgiG/DcEwJqMGNPD+jtZiUm/TNotpldpl0wlvgGUjspIVFr7WMQQKeOxCl6
        x+D3TMaW0cbdR5qdCo/HfA29XaaddtW6lFKhYDz7Mr6SdKoRICYAfzFX7obXX9Lv
        Q62RuEZB+ZoZMN98FT9+pXFlA8sh5qlPseUaAhlrolh7//S0ivYuSQT12DHnvvFz
        ccrsvYBF3cj82A==
X-ME-Sender: <xms:Da-uX1OOUos6rq27tLZVExG6_i56yrxGNxl32WUdrYHfW5Tg_hqN7w>
    <xme:Da-uX39Hf_RbgaM_EYoMlqnsBpatfAIf8URH8ovWoE3eNW8alBLOM9sS7dVvamhJZ
    SqzNQfFyMSVnVo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvhedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Da-uX0Tj4XZh8OiXHVdlKfGmrIW2uG2wkIY8N2_WABO-JUAY7zwvfA>
    <xmx:Da-uXxtI8E8T58Dmy443ZZozcbjshiwyapX9_7EvCV60hkJSD5ZfZw>
    <xmx:Da-uX9e5PgmcMSqfC7ulxpg2SnLNxmk2cR5wSeuNEF5-knxGqjc37A>
    <xmx:Da-uXx5roJix8yzomN0FA0p7I2mkqYtV_k_MJoqLo5JfSRtWNGHoxQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4F4F6328005D;
        Fri, 13 Nov 2020 11:06:35 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/15] mlxsw: spectrum_router: Use nexthop group type in hash table key
Date:   Fri, 13 Nov 2020 18:05:47 +0200
Message-Id: <20201113160559.22148-4-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113160559.22148-1-idosch@idosch.org>
References: <20201113160559.22148-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Both IPv4 and IPv6 nexthop groups are hashed in the same table. The
protocol field is used to indicate how the hash should be computed for
each group.

When nexthop group objects are supported, the hash will be computed for
them based on the nexthop identifier.

To differentiate between all the nexthop group types, encode the type of
the group in the key instead of the protocol.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 25 +++++++++----------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 5b8363206325..5affe7f79a9a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2995,7 +2995,7 @@ mlxsw_sp_nexthop4_group_fi(const struct mlxsw_sp_nexthop_group *nh_grp)
 }
 
 struct mlxsw_sp_nexthop_group_cmp_arg {
-	enum mlxsw_sp_l3proto proto;
+	enum mlxsw_sp_nexthop_group_type type;
 	union {
 		struct fib_info *fi;
 		struct mlxsw_sp_fib6_entry *fib6_entry;
@@ -3052,14 +3052,13 @@ mlxsw_sp_nexthop_group_cmp(struct rhashtable_compare_arg *arg, const void *ptr)
 	const struct mlxsw_sp_nexthop_group_cmp_arg *cmp_arg = arg->key;
 	const struct mlxsw_sp_nexthop_group *nh_grp = ptr;
 
-	switch (cmp_arg->proto) {
-	case MLXSW_SP_L3_PROTO_IPV4:
-		if (nh_grp->type != MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV4)
-			return 1;
+	if (nh_grp->type != cmp_arg->type)
+		return 1;
+
+	switch (cmp_arg->type) {
+	case MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV4:
 		return cmp_arg->fi != mlxsw_sp_nexthop4_group_fi(nh_grp);
-	case MLXSW_SP_L3_PROTO_IPV6:
-		if (nh_grp->type != MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6)
-			return 1;
+	case MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6:
 		return !mlxsw_sp_nexthop6_group_cmp(nh_grp,
 						    cmp_arg->fib6_entry);
 	default:
@@ -3117,10 +3116,10 @@ mlxsw_sp_nexthop_group_hash(const void *data, u32 len, u32 seed)
 {
 	const struct mlxsw_sp_nexthop_group_cmp_arg *cmp_arg = data;
 
-	switch (cmp_arg->proto) {
-	case MLXSW_SP_L3_PROTO_IPV4:
+	switch (cmp_arg->type) {
+	case MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV4:
 		return jhash(&cmp_arg->fi, sizeof(cmp_arg->fi), seed);
-	case MLXSW_SP_L3_PROTO_IPV6:
+	case MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6:
 		return mlxsw_sp_nexthop6_group_hash(cmp_arg->fib6_entry, seed);
 	default:
 		WARN_ON(1);
@@ -3165,7 +3164,7 @@ mlxsw_sp_nexthop4_group_lookup(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_nexthop_group_cmp_arg cmp_arg;
 
-	cmp_arg.proto = MLXSW_SP_L3_PROTO_IPV4;
+	cmp_arg.type = MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV4;
 	cmp_arg.fi = fi;
 	return rhashtable_lookup_fast(&mlxsw_sp->router->nexthop_group_ht,
 				      &cmp_arg,
@@ -3178,7 +3177,7 @@ mlxsw_sp_nexthop6_group_lookup(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_nexthop_group_cmp_arg cmp_arg;
 
-	cmp_arg.proto = MLXSW_SP_L3_PROTO_IPV6;
+	cmp_arg.type = MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6;
 	cmp_arg.fib6_entry = fib6_entry;
 	return rhashtable_lookup_fast(&mlxsw_sp->router->nexthop_group_ht,
 				      &cmp_arg,
-- 
2.28.0

