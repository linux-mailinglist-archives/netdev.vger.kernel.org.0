Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B3B1BA788
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgD0PNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:13:34 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41669 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727006AbgD0PNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:13:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5A1495C00BF;
        Mon, 27 Apr 2020 11:13:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Apr 2020 11:13:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=UMUZSONTyJpT8SB0GxyWwv3l/0jc2M5zoa4XSgzHxqk=; b=GuawUsUW
        AWEg2JerGqy1dueCkcUwun7254RIGtA/sBhD1pW8regGS2FH/oQeSlsVrX8GVTyj
        JDvt8ScxOze05DwHvsxxXjX0JLuh3Ay2pP4gCuNusKs/SfwaI4yz31kAPRi1Wahg
        8BjJasfNudNiQxfNDphbXigenMCiSYvLss8drephm85/NVFnnhCgFfweISlVi6qg
        EbLWzL36xPYdQtYvI56aUxTy5fvOPomzGqFsC57JBZCkCk56+jWyj5LC7tuLmu7v
        sTfa04eqs5XASys49LBxqW+rQThu1xY69yuuGSOBBfP6YeoWFgEC6FexTaSuApS2
        UyUE7nDhoVK6GA==
X-ME-Sender: <xms:nPamXl9j_epw5-gLsw1nQGE6ITG4QtUFIXAJOJ9Dg-kApX6EDGqbYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:nPamXt-e41MRsPFl9DyZ-nzCJrVf3tubIRpnSYsjdz0eJsTyC-RDUA>
    <xmx:nPamXuDr5dGeYEZMCY5QdXdWi1rBHq9uR3xuv6ZTPbEyjYOw4YQuHA>
    <xmx:nPamXty3T7Iu7gYu8vPuuAlI7XELhTQCmFnzOyzpBDwoQ8zv1mUCSA>
    <xmx:nPamXpu5K5uvXizsPDrt8q5dtodfufOCOZD-PxEI3oCsi7aEpKZjOQ>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 182583280064;
        Mon, 27 Apr 2020 11:13:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/13] mlxsw: spectrum_acl: Move block helpers into inline header functions
Date:   Mon, 27 Apr 2020 18:12:58 +0300
Message-Id: <20200427151310.3950411-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427151310.3950411-1-idosch@idosch.org>
References: <20200427151310.3950411-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The struct is defined in the header, no need to have the helpers
in the c file. Move the helpers to the header.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 60 ++++++++++++++++---
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 43 -------------
 2 files changed, 51 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index ca56e72cb4b7..f158cd98f8d8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -677,12 +677,57 @@ struct mlxsw_sp_acl_block {
 };
 
 struct mlxsw_afk *mlxsw_sp_acl_afk(struct mlxsw_sp_acl *acl);
-struct mlxsw_sp *mlxsw_sp_acl_block_mlxsw_sp(struct mlxsw_sp_acl_block *block);
-unsigned int
-mlxsw_sp_acl_block_rule_count(const struct mlxsw_sp_acl_block *block);
-void mlxsw_sp_acl_block_disable_inc(struct mlxsw_sp_acl_block *block);
-void mlxsw_sp_acl_block_disable_dec(struct mlxsw_sp_acl_block *block);
-bool mlxsw_sp_acl_block_disabled(const struct mlxsw_sp_acl_block *block);
+
+static inline struct mlxsw_sp *
+mlxsw_sp_acl_block_mlxsw_sp(struct mlxsw_sp_acl_block *block)
+{
+	return block->mlxsw_sp;
+}
+
+static inline unsigned int
+mlxsw_sp_acl_block_rule_count(const struct mlxsw_sp_acl_block *block)
+{
+	return block ? block->rule_count : 0;
+}
+
+static inline void
+mlxsw_sp_acl_block_disable_inc(struct mlxsw_sp_acl_block *block)
+{
+	if (block)
+		block->disable_count++;
+}
+
+static inline void
+mlxsw_sp_acl_block_disable_dec(struct mlxsw_sp_acl_block *block)
+{
+	if (block)
+		block->disable_count--;
+}
+
+static inline bool
+mlxsw_sp_acl_block_disabled(const struct mlxsw_sp_acl_block *block)
+{
+	return block->disable_count;
+}
+
+static inline bool
+mlxsw_sp_acl_block_is_egress_bound(const struct mlxsw_sp_acl_block *block)
+{
+	return block->egress_binding_count;
+}
+
+static inline bool
+mlxsw_sp_acl_block_is_ingress_bound(const struct mlxsw_sp_acl_block *block)
+{
+	return block->ingress_binding_count;
+}
+
+static inline bool
+mlxsw_sp_acl_block_is_mixed_bound(const struct mlxsw_sp_acl_block *block)
+{
+	return block->ingress_binding_count && block->egress_binding_count;
+}
+
 struct mlxsw_sp_acl_block *mlxsw_sp_acl_block_create(struct mlxsw_sp *mlxsw_sp,
 						     struct net *net);
 void mlxsw_sp_acl_block_destroy(struct mlxsw_sp_acl_block *block);
@@ -695,9 +740,6 @@ int mlxsw_sp_acl_block_unbind(struct mlxsw_sp *mlxsw_sp,
 			      struct mlxsw_sp_acl_block *block,
 			      struct mlxsw_sp_port *mlxsw_sp_port,
 			      bool ingress);
-bool mlxsw_sp_acl_block_is_egress_bound(const struct mlxsw_sp_acl_block *block);
-bool mlxsw_sp_acl_block_is_ingress_bound(const struct mlxsw_sp_acl_block *block);
-bool mlxsw_sp_acl_block_is_mixed_bound(const struct mlxsw_sp_acl_block *block);
 struct mlxsw_sp_acl_ruleset *
 mlxsw_sp_acl_ruleset_lookup(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_acl_block *block, u32 chain_index,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 01cff711bbd2..bb06c007b3f2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -94,49 +94,6 @@ struct mlxsw_sp_fid *mlxsw_sp_acl_dummy_fid(struct mlxsw_sp *mlxsw_sp)
 	return mlxsw_sp->acl->dummy_fid;
 }
 
-struct mlxsw_sp *mlxsw_sp_acl_block_mlxsw_sp(struct mlxsw_sp_acl_block *block)
-{
-	return block->mlxsw_sp;
-}
-
-unsigned int
-mlxsw_sp_acl_block_rule_count(const struct mlxsw_sp_acl_block *block)
-{
-	return block ? block->rule_count : 0;
-}
-
-void mlxsw_sp_acl_block_disable_inc(struct mlxsw_sp_acl_block *block)
-{
-	if (block)
-		block->disable_count++;
-}
-
-void mlxsw_sp_acl_block_disable_dec(struct mlxsw_sp_acl_block *block)
-{
-	if (block)
-		block->disable_count--;
-}
-
-bool mlxsw_sp_acl_block_disabled(const struct mlxsw_sp_acl_block *block)
-{
-	return block->disable_count;
-}
-
-bool mlxsw_sp_acl_block_is_egress_bound(const struct mlxsw_sp_acl_block *block)
-{
-	return block->egress_binding_count;
-}
-
-bool mlxsw_sp_acl_block_is_ingress_bound(const struct mlxsw_sp_acl_block *block)
-{
-	return block->ingress_binding_count;
-}
-
-bool mlxsw_sp_acl_block_is_mixed_bound(const struct mlxsw_sp_acl_block *block)
-{
-	return block->ingress_binding_count && block->egress_binding_count;
-}
-
 static bool
 mlxsw_sp_acl_ruleset_is_singular(const struct mlxsw_sp_acl_ruleset *ruleset)
 {
-- 
2.24.1

