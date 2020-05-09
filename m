Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949681CC45D
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 22:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgEIUGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 16:06:44 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40297 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728667AbgEIUGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 16:06:42 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 727C55C00CC;
        Sat,  9 May 2020 16:06:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 09 May 2020 16:06:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=iGx4yrqmPjHzehMQ0VkDup9CZaB6mJpOmc3yt+hrJGk=; b=eyZcx2Q6
        vzyDCekuHHoF5wghjZA/szKXQzLhcPTqdI3h1oLAjNJgcr2JYxzCSWdokyeF4Nc2
        0ErxEZfjBujYCQdihG0eawN4tNZYZ9j9KXoE8LYMIjzg+vFhwxWm00S4a7UVMjBD
        YK93EhVv5XgYR+ArT+QkJs4LGfGJN3SGWfuQ+dfgF0OsaBzuLMHlozlwjsYsNnpL
        z6Hwam5bVvM2Bf+nngiMHksfbqCN+9+pyb4iOka2tc9qQgFOBWZK+yyOoBo96D/M
        z1NwkvDzVap5nYGYSGqZTB5akblrrP92eUiFaPc9R6lwD6hJ0oPzIXzXdUo9BntF
        +0/pUE3xBkXySQ==
X-ME-Sender: <xms:UQ23XkFeRC66m6RDg6LryHwp9wvi7-_mHS78DLCtfuQ5dET49TkATQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkeehgddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:UQ23Xqje7ndo0TDun2D5hjxBTuaYoe03YXlzum8wO2FYSIOXxhHBvg>
    <xmx:UQ23Xio2V5fa3bVzkwIgukwLK--P1PWkDEq4KFZ7y9u42TAR4taXWQ>
    <xmx:UQ23XiTTTDsM_BQ9DEMuH-Z90oyzdr-xs_gg-_M0uh9TWb6Bxik9XA>
    <xmx:UQ23Xk7tpLGU5Kxz0s6ZGPBqp6yMovFZCGOBf8lfdU4Aj0NytIG-qA>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 27F3B306622F;
        Sat,  9 May 2020 16:06:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/9] mlxsw: spectrum_matchall: Put matchall list into substruct of flow struct
Date:   Sat,  9 May 2020 23:06:04 +0300
Message-Id: <20200509200610.375719-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509200610.375719-1-idosch@idosch.org>
References: <20200509200610.375719-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

As there are going to be other matchall specific fields in flow
structure, put the existing list field into matchall substruct.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h         |  4 +++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c    |  2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_matchall.c    | 10 +++++-----
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index d9a963c77401..553693469805 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -636,7 +636,9 @@ struct mlxsw_sp_acl_rule_info {
 /* spectrum_flow.c */
 struct mlxsw_sp_flow_block {
 	struct list_head binding_list;
-	struct list_head mall_list;
+	struct {
+		struct list_head list;
+	} mall;
 	struct mlxsw_sp_acl_ruleset *ruleset_zero;
 	struct mlxsw_sp *mlxsw_sp;
 	unsigned int rule_count;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
index ecab581ff956..76644f6a8121 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
@@ -18,7 +18,7 @@ mlxsw_sp_flow_block_create(struct mlxsw_sp *mlxsw_sp, struct net *net)
 	if (!block)
 		return NULL;
 	INIT_LIST_HEAD(&block->binding_list);
-	INIT_LIST_HEAD(&block->mall_list);
+	INIT_LIST_HEAD(&block->mall.list);
 	block->mlxsw_sp = mlxsw_sp;
 	block->net = net;
 	return block;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index c75661521bbc..d64ee31a611c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -37,7 +37,7 @@ mlxsw_sp_mall_entry_find(struct mlxsw_sp_flow_block *block, unsigned long cookie
 {
 	struct mlxsw_sp_mall_entry *mall_entry;
 
-	list_for_each_entry(mall_entry, &block->mall_list, list)
+	list_for_each_entry(mall_entry, &block->mall.list, list)
 		if (mall_entry->cookie == cookie)
 			return mall_entry;
 
@@ -244,7 +244,7 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp_flow_block *block,
 		block->egress_blocker_rule_count++;
 	else
 		block->ingress_blocker_rule_count++;
-	list_add_tail(&mall_entry->list, &block->mall_list);
+	list_add_tail(&mall_entry->list, &block->mall.list);
 	return 0;
 
 rollback:
@@ -285,7 +285,7 @@ int mlxsw_sp_mall_port_bind(struct mlxsw_sp_flow_block *block,
 	struct mlxsw_sp_mall_entry *mall_entry;
 	int err;
 
-	list_for_each_entry(mall_entry, &block->mall_list, list) {
+	list_for_each_entry(mall_entry, &block->mall.list, list) {
 		err = mlxsw_sp_mall_port_rule_add(mlxsw_sp_port, mall_entry);
 		if (err)
 			goto rollback;
@@ -293,7 +293,7 @@ int mlxsw_sp_mall_port_bind(struct mlxsw_sp_flow_block *block,
 	return 0;
 
 rollback:
-	list_for_each_entry_continue_reverse(mall_entry, &block->mall_list,
+	list_for_each_entry_continue_reverse(mall_entry, &block->mall.list,
 					     list)
 		mlxsw_sp_mall_port_rule_del(mlxsw_sp_port, mall_entry);
 	return err;
@@ -304,6 +304,6 @@ void mlxsw_sp_mall_port_unbind(struct mlxsw_sp_flow_block *block,
 {
 	struct mlxsw_sp_mall_entry *mall_entry;
 
-	list_for_each_entry(mall_entry, &block->mall_list, list)
+	list_for_each_entry(mall_entry, &block->mall.list, list)
 		mlxsw_sp_mall_port_rule_del(mlxsw_sp_port, mall_entry);
 }
-- 
2.26.2

