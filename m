Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6BB2B1F8F
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgKMQGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:06:53 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45749 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726900AbgKMQGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:06:52 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 12EDA5C018D;
        Fri, 13 Nov 2020 11:06:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 13 Nov 2020 11:06:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=oWUbOW8lM2kWDefnL6OcrIMGUMjvphT1w8ZPtN/LEvQ=; b=g1R4SytD
        Bxt2tMpEEmuwQ8yBeD2pD8VkndtaKO1Zm/0Edxy9iMPKwHltIOrHEa7iTDn2LFmb
        ujIrtYkITXoFKtdY1isZ1QhFvjl/UEfGQBx9XywGukeQh6AUFh6paRnsHXuPymoQ
        Hp+ZgXynI81PC2JAHDTvAdRorUnJGooq9cfm4RRQircA7rmm4ucQuIqdnxmvfP7I
        xlw8wEDD6YvU1aEUoblqfS80ymT15JBAVrjdWHQcYOQRLFVUF9dL2DZp7n4AFJGR
        /mLh68wGo3f32AbFgElJqnoUIrTA1fLBYvp9pp7Vif2rC4MooRPDou8KoLhA6X8P
        NX6GIzg57l8ZJA==
X-ME-Sender: <xms:Gq-uX5yZ-1jnR1q9sxchm0mImLvPn5W8-2vSnWX3-CiMn4jeji-WZQ>
    <xme:Gq-uX5Sr6BrBE6rbGhFM-yxpX-DQovEeuoyn27z7qQdSK6fUsxTwXJpAewBwhY5gd
    IEZsTgSn6pEI7I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvhedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Gq-uXzVeCPsWSoQSznSzzAs88dQCrbMrEY9DT82KGYGg0PzKzpks1g>
    <xmx:Gq-uX7gm83p8uJVYApNGWeSwBgJ73ZLlC2P2CoqgCJYwK089hd2hPA>
    <xmx:Gq-uX7CQNEwKEDzv9jnBjyxBlStWUICf_5txsfaVQgOd6Gn2Eli2SA>
    <xmx:G6-uXyOjtRBSPfezAAxDhyp3q8Cl3Qol1qHgVlHDpwUrgTVdnbQwTA>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B7353280066;
        Fri, 13 Nov 2020 11:06:48 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/15] mlxsw: spectrum_ipip: Remove overlay protocol from can_offload() callback
Date:   Fri, 13 Nov 2020 18:05:53 +0200
Message-Id: <20201113160559.22148-10-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113160559.22148-1-idosch@idosch.org>
References: <20201113160559.22148-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The overlay protocol (i.e., IPv4/IPv6) that is being encapsulated has
no impact on whether a certain IP tunnel can be offloaded or not. Only
the underlay protocol matters.

Therefore, remove the unused overlay protocol parameter from the
callback.

This will later allow us to consolidate code paths between IPv4 and IPv6
code.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c  |  3 +--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h  |  3 +--
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c    | 12 +++---------
 3 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index ab2e0eb26c1a..089d99535f9e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -233,8 +233,7 @@ static bool mlxsw_sp_ipip_tunnel_complete(enum mlxsw_sp_l3proto proto,
 }
 
 static bool mlxsw_sp_ipip_can_offload_gre4(const struct mlxsw_sp *mlxsw_sp,
-					   const struct net_device *ol_dev,
-					   enum mlxsw_sp_l3proto ol_proto)
+					   const struct net_device *ol_dev)
 {
 	struct ip_tunnel *tunnel = netdev_priv(ol_dev);
 	__be16 okflags = TUNNEL_KEY; /* We can't offload any other features. */
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
index 00448cbac639..d32702cb6ab4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
@@ -43,8 +43,7 @@ struct mlxsw_sp_ipip_ops {
 			      struct mlxsw_sp_ipip_entry *ipip_entry);
 
 	bool (*can_offload)(const struct mlxsw_sp *mlxsw_sp,
-			    const struct net_device *ol_dev,
-			    enum mlxsw_sp_l3proto ol_proto);
+			    const struct net_device *ol_dev);
 
 	/* Return a configuration for creating an overlay loopback RIF. */
 	struct mlxsw_sp_rif_ipip_lb_config
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 3079be4bc5ec..7c7caea59d57 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1453,11 +1453,7 @@ static bool mlxsw_sp_netdevice_ipip_can_offload(struct mlxsw_sp *mlxsw_sp,
 	const struct mlxsw_sp_ipip_ops *ops
 		= mlxsw_sp->router->ipip_ops_arr[ipipt];
 
-	/* For deciding whether decap should be offloaded, we don't care about
-	 * overlay protocol, so ask whether either one is supported.
-	 */
-	return ops->can_offload(mlxsw_sp, ol_dev, MLXSW_SP_L3_PROTO_IPV4) ||
-	       ops->can_offload(mlxsw_sp, ol_dev, MLXSW_SP_L3_PROTO_IPV6);
+	return ops->can_offload(mlxsw_sp, ol_dev);
 }
 
 static int mlxsw_sp_netdevice_ipip_ol_reg_event(struct mlxsw_sp *mlxsw_sp,
@@ -3925,8 +3921,7 @@ static int mlxsw_sp_nexthop4_type_init(struct mlxsw_sp *mlxsw_sp,
 	ipip_entry = mlxsw_sp_ipip_entry_find_by_ol_dev(mlxsw_sp, dev);
 	if (ipip_entry) {
 		ipip_ops = mlxsw_sp->router->ipip_ops_arr[ipip_entry->ipipt];
-		if (ipip_ops->can_offload(mlxsw_sp, dev,
-					  MLXSW_SP_L3_PROTO_IPV4)) {
+		if (ipip_ops->can_offload(mlxsw_sp, dev)) {
 			nh->type = MLXSW_SP_NEXTHOP_TYPE_IPIP;
 			mlxsw_sp_nexthop_ipip_init(mlxsw_sp, nh, ipip_entry);
 			return 0;
@@ -5371,8 +5366,7 @@ static int mlxsw_sp_nexthop6_type_init(struct mlxsw_sp *mlxsw_sp,
 	ipip_entry = mlxsw_sp_ipip_entry_find_by_ol_dev(mlxsw_sp, dev);
 	if (ipip_entry) {
 		ipip_ops = mlxsw_sp->router->ipip_ops_arr[ipip_entry->ipipt];
-		if (ipip_ops->can_offload(mlxsw_sp, dev,
-					  MLXSW_SP_L3_PROTO_IPV6)) {
+		if (ipip_ops->can_offload(mlxsw_sp, dev)) {
 			nh->type = MLXSW_SP_NEXTHOP_TYPE_IPIP;
 			mlxsw_sp_nexthop_ipip_init(mlxsw_sp, nh, ipip_entry);
 			return 0;
-- 
2.28.0

