Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950441BA793
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgD0PNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:13:53 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54463 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727878AbgD0PNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:13:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 785DA5C006B;
        Mon, 27 Apr 2020 11:13:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Apr 2020 11:13:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=AX6Lb7Z/abPuoBvFtTeCVowNkY7/rf8f7lyiGRuva7w=; b=cau2+BAy
        ErgWCkeXFhA33JDqI9ACp3wfeK/TlgvT36D+xmR0lU9euXPz47CEiIK8I7ZKq0FF
        6Sf6uWemf2XkPmPVq4sLlYfiT4P3lktijz97imMpNJaDP4kTXds+xmN359iOFLWv
        0kfXmPc5lt/6+AywhueHfDjxslUfvcOtbJRcwru7ENX3gidlgyykr6T246LRJK61
        D0RYyWbRfsXWJ7/8mH9jfXoyMZ//z0D3v0Jpyfq/I6DyDBvcp8l79UECkKP1JGZ4
        a0YgqoTic34CCxmn15dw8voqrdZ2xP9NgtVxMSjLqJwyi6JXpRCg2TdCXSGNKTG3
        o5YBzrHm2Jmrpg==
X-ME-Sender: <xms:q_amXleVKHeaKLnNpijCzxq9xCVnHoVBQ4IJ1xchgWIAspiAkc_qqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpeduudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:q_amXp8Qa9PnYIjt8cDjpuoEOhNVNuiZXYvr2MADN1uNTMxBA4DFJg>
    <xmx:q_amXgTOzJxPYCJ8svC-WMN6Mlimc64vDfS0Ts60UIlrTmJwqMxviw>
    <xmx:q_amXqokGa_Au_U78OEwhbA8Z42JTRI_Tr1Fdn9T4wzodkZ2I_Fgfw>
    <xmx:q_amXgjj5lsX8qk7Xbd5S4Ptam5nXYh2oNcRa4fE0FjkevUlb-bzvQ>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3732C328005D;
        Mon, 27 Apr 2020 11:13:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 12/13] mlxsw: spectrum: Move flow offload binding into spectrum_flow.c
Date:   Mon, 27 Apr 2020 18:13:09 +0300
Message-Id: <20200427151310.3950411-13-idosch@idosch.org>
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

Move the code taking case of setup of flow offload into spectrum_flow.c
Do small renaming of callbacks on the way.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 173 ----------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  11 +-
 .../ethernet/mellanox/mlxsw/spectrum_flow.c   | 188 +++++++++++++++++-
 3 files changed, 181 insertions(+), 191 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index ceaf73ac2008..f78bde8bc16e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1350,178 +1350,6 @@ static int mlxsw_sp_port_kill_vid(struct net_device *dev,
 	return 0;
 }
 
-static int
-mlxsw_sp_setup_tc_cls_matchall(struct mlxsw_sp_flow_block *flow_block,
-			       struct tc_cls_matchall_offload *f)
-{
-	switch (f->command) {
-	case TC_CLSMATCHALL_REPLACE:
-		return mlxsw_sp_mall_replace(flow_block, f);
-	case TC_CLSMATCHALL_DESTROY:
-		mlxsw_sp_mall_destroy(flow_block, f);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static int
-mlxsw_sp_setup_tc_cls_flower(struct mlxsw_sp_flow_block *flow_block,
-			     struct flow_cls_offload *f)
-{
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_flow_block_mlxsw_sp(flow_block);
-
-	switch (f->command) {
-	case FLOW_CLS_REPLACE:
-		return mlxsw_sp_flower_replace(mlxsw_sp, flow_block, f);
-	case FLOW_CLS_DESTROY:
-		mlxsw_sp_flower_destroy(mlxsw_sp, flow_block, f);
-		return 0;
-	case FLOW_CLS_STATS:
-		return mlxsw_sp_flower_stats(mlxsw_sp, flow_block, f);
-	case FLOW_CLS_TMPLT_CREATE:
-		return mlxsw_sp_flower_tmplt_create(mlxsw_sp, flow_block, f);
-	case FLOW_CLS_TMPLT_DESTROY:
-		mlxsw_sp_flower_tmplt_destroy(mlxsw_sp, flow_block, f);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static int mlxsw_sp_setup_tc_block_cb(enum tc_setup_type type,
-				      void *type_data, void *cb_priv)
-{
-	struct mlxsw_sp_flow_block *flow_block = cb_priv;
-
-	if (mlxsw_sp_flow_block_disabled(flow_block))
-		return -EOPNOTSUPP;
-
-	switch (type) {
-	case TC_SETUP_CLSMATCHALL:
-		return mlxsw_sp_setup_tc_cls_matchall(flow_block, type_data);
-	case TC_SETUP_CLSFLOWER:
-		return mlxsw_sp_setup_tc_cls_flower(flow_block, type_data);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static void mlxsw_sp_tc_block_release(void *cb_priv)
-{
-	struct mlxsw_sp_flow_block *flow_block = cb_priv;
-
-	mlxsw_sp_flow_block_destroy(flow_block);
-}
-
-static LIST_HEAD(mlxsw_sp_block_cb_list);
-
-static int mlxsw_sp_setup_tc_block_bind(struct mlxsw_sp_port *mlxsw_sp_port,
-					struct flow_block_offload *f,
-					bool ingress)
-{
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	struct mlxsw_sp_flow_block *flow_block;
-	struct flow_block_cb *block_cb;
-	bool register_block = false;
-	int err;
-
-	block_cb = flow_block_cb_lookup(f->block, mlxsw_sp_setup_tc_block_cb,
-					mlxsw_sp);
-	if (!block_cb) {
-		flow_block = mlxsw_sp_flow_block_create(mlxsw_sp, f->net);
-		if (!flow_block)
-			return -ENOMEM;
-		block_cb = flow_block_cb_alloc(mlxsw_sp_setup_tc_block_cb,
-					       mlxsw_sp, flow_block,
-					       mlxsw_sp_tc_block_release);
-		if (IS_ERR(block_cb)) {
-			mlxsw_sp_flow_block_destroy(flow_block);
-			err = PTR_ERR(block_cb);
-			goto err_cb_register;
-		}
-		register_block = true;
-	} else {
-		flow_block = flow_block_cb_priv(block_cb);
-	}
-	flow_block_cb_incref(block_cb);
-	err = mlxsw_sp_flow_block_bind(mlxsw_sp, flow_block,
-				       mlxsw_sp_port, ingress, f->extack);
-	if (err)
-		goto err_block_bind;
-
-	if (ingress)
-		mlxsw_sp_port->ing_flow_block = flow_block;
-	else
-		mlxsw_sp_port->eg_flow_block = flow_block;
-
-	if (register_block) {
-		flow_block_cb_add(block_cb, f);
-		list_add_tail(&block_cb->driver_list, &mlxsw_sp_block_cb_list);
-	}
-
-	return 0;
-
-err_block_bind:
-	if (!flow_block_cb_decref(block_cb))
-		flow_block_cb_free(block_cb);
-err_cb_register:
-	return err;
-}
-
-static void mlxsw_sp_setup_tc_block_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
-					   struct flow_block_offload *f,
-					   bool ingress)
-{
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	struct mlxsw_sp_flow_block *flow_block;
-	struct flow_block_cb *block_cb;
-	int err;
-
-	block_cb = flow_block_cb_lookup(f->block, mlxsw_sp_setup_tc_block_cb,
-					mlxsw_sp);
-	if (!block_cb)
-		return;
-
-	if (ingress)
-		mlxsw_sp_port->ing_flow_block = NULL;
-	else
-		mlxsw_sp_port->eg_flow_block = NULL;
-
-	flow_block = flow_block_cb_priv(block_cb);
-	err = mlxsw_sp_flow_block_unbind(mlxsw_sp, flow_block,
-					 mlxsw_sp_port, ingress);
-	if (!err && !flow_block_cb_decref(block_cb)) {
-		flow_block_cb_remove(block_cb, f);
-		list_del(&block_cb->driver_list);
-	}
-}
-
-static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
-				   struct flow_block_offload *f)
-{
-	bool ingress;
-
-	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		ingress = true;
-	else if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
-		ingress = false;
-	else
-		return -EOPNOTSUPP;
-
-	f->driver_block_list = &mlxsw_sp_block_cb_list;
-
-	switch (f->command) {
-	case FLOW_BLOCK_BIND:
-		return mlxsw_sp_setup_tc_block_bind(mlxsw_sp_port, f, ingress);
-	case FLOW_BLOCK_UNBIND:
-		mlxsw_sp_setup_tc_block_unbind(mlxsw_sp_port, f, ingress);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int mlxsw_sp_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			     void *type_data)
 {
@@ -1545,7 +1373,6 @@ static int mlxsw_sp_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	}
 }
 
-
 static int mlxsw_sp_feature_hw_tc(struct net_device *dev, bool enable)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 57d320728914..a12ca673c224 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -708,15 +708,8 @@ mlxsw_sp_flow_block_is_mixed_bound(const struct mlxsw_sp_flow_block *block)
 struct mlxsw_sp_flow_block *mlxsw_sp_flow_block_create(struct mlxsw_sp *mlxsw_sp,
 						       struct net *net);
 void mlxsw_sp_flow_block_destroy(struct mlxsw_sp_flow_block *block);
-int mlxsw_sp_flow_block_bind(struct mlxsw_sp *mlxsw_sp,
-			     struct mlxsw_sp_flow_block *block,
-			     struct mlxsw_sp_port *mlxsw_sp_port,
-			     bool ingress,
-			     struct netlink_ext_ack *extack);
-int mlxsw_sp_flow_block_unbind(struct mlxsw_sp *mlxsw_sp,
-			       struct mlxsw_sp_flow_block *block,
-			       struct mlxsw_sp_port *mlxsw_sp_port,
-			       bool ingress);
+int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
+			    struct flow_block_offload *f);
 
 /* spectrum_acl.c */
 struct mlxsw_sp_acl_ruleset;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
index 51de6aca1930..ecab581ff956 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
@@ -49,11 +49,11 @@ mlxsw_sp_flow_block_ruleset_bound(const struct mlxsw_sp_flow_block *block)
 	return block->ruleset_zero;
 }
 
-int mlxsw_sp_flow_block_bind(struct mlxsw_sp *mlxsw_sp,
-			     struct mlxsw_sp_flow_block *block,
-			     struct mlxsw_sp_port *mlxsw_sp_port,
-			     bool ingress,
-			     struct netlink_ext_ack *extack)
+static int mlxsw_sp_flow_block_bind(struct mlxsw_sp *mlxsw_sp,
+				    struct mlxsw_sp_flow_block *block,
+				    struct mlxsw_sp_port *mlxsw_sp_port,
+				    bool ingress,
+				    struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_flow_block_binding *binding;
 	int err;
@@ -104,10 +104,10 @@ int mlxsw_sp_flow_block_bind(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-int mlxsw_sp_flow_block_unbind(struct mlxsw_sp *mlxsw_sp,
-			       struct mlxsw_sp_flow_block *block,
-			       struct mlxsw_sp_port *mlxsw_sp_port,
-			       bool ingress)
+static int mlxsw_sp_flow_block_unbind(struct mlxsw_sp *mlxsw_sp,
+				      struct mlxsw_sp_flow_block *block,
+				      struct mlxsw_sp_port *mlxsw_sp_port,
+				      bool ingress)
 {
 	struct mlxsw_sp_flow_block_binding *binding;
 
@@ -131,3 +131,173 @@ int mlxsw_sp_flow_block_unbind(struct mlxsw_sp *mlxsw_sp,
 
 	return 0;
 }
+
+static int mlxsw_sp_flow_block_mall_cb(struct mlxsw_sp_flow_block *flow_block,
+				       struct tc_cls_matchall_offload *f)
+{
+	switch (f->command) {
+	case TC_CLSMATCHALL_REPLACE:
+		return mlxsw_sp_mall_replace(flow_block, f);
+	case TC_CLSMATCHALL_DESTROY:
+		mlxsw_sp_mall_destroy(flow_block, f);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int mlxsw_sp_flow_block_flower_cb(struct mlxsw_sp_flow_block *flow_block,
+					 struct flow_cls_offload *f)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_flow_block_mlxsw_sp(flow_block);
+
+	switch (f->command) {
+	case FLOW_CLS_REPLACE:
+		return mlxsw_sp_flower_replace(mlxsw_sp, flow_block, f);
+	case FLOW_CLS_DESTROY:
+		mlxsw_sp_flower_destroy(mlxsw_sp, flow_block, f);
+		return 0;
+	case FLOW_CLS_STATS:
+		return mlxsw_sp_flower_stats(mlxsw_sp, flow_block, f);
+	case FLOW_CLS_TMPLT_CREATE:
+		return mlxsw_sp_flower_tmplt_create(mlxsw_sp, flow_block, f);
+	case FLOW_CLS_TMPLT_DESTROY:
+		mlxsw_sp_flower_tmplt_destroy(mlxsw_sp, flow_block, f);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int mlxsw_sp_flow_block_cb(enum tc_setup_type type,
+				  void *type_data, void *cb_priv)
+{
+	struct mlxsw_sp_flow_block *flow_block = cb_priv;
+
+	if (mlxsw_sp_flow_block_disabled(flow_block))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_CLSMATCHALL:
+		return mlxsw_sp_flow_block_mall_cb(flow_block, type_data);
+	case TC_SETUP_CLSFLOWER:
+		return mlxsw_sp_flow_block_flower_cb(flow_block, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void mlxsw_sp_tc_block_release(void *cb_priv)
+{
+	struct mlxsw_sp_flow_block *flow_block = cb_priv;
+
+	mlxsw_sp_flow_block_destroy(flow_block);
+}
+
+static LIST_HEAD(mlxsw_sp_block_cb_list);
+
+static int mlxsw_sp_setup_tc_block_bind(struct mlxsw_sp_port *mlxsw_sp_port,
+					struct flow_block_offload *f,
+					bool ingress)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_flow_block *flow_block;
+	struct flow_block_cb *block_cb;
+	bool register_block = false;
+	int err;
+
+	block_cb = flow_block_cb_lookup(f->block, mlxsw_sp_flow_block_cb,
+					mlxsw_sp);
+	if (!block_cb) {
+		flow_block = mlxsw_sp_flow_block_create(mlxsw_sp, f->net);
+		if (!flow_block)
+			return -ENOMEM;
+		block_cb = flow_block_cb_alloc(mlxsw_sp_flow_block_cb,
+					       mlxsw_sp, flow_block,
+					       mlxsw_sp_tc_block_release);
+		if (IS_ERR(block_cb)) {
+			mlxsw_sp_flow_block_destroy(flow_block);
+			err = PTR_ERR(block_cb);
+			goto err_cb_register;
+		}
+		register_block = true;
+	} else {
+		flow_block = flow_block_cb_priv(block_cb);
+	}
+	flow_block_cb_incref(block_cb);
+	err = mlxsw_sp_flow_block_bind(mlxsw_sp, flow_block,
+				       mlxsw_sp_port, ingress, f->extack);
+	if (err)
+		goto err_block_bind;
+
+	if (ingress)
+		mlxsw_sp_port->ing_flow_block = flow_block;
+	else
+		mlxsw_sp_port->eg_flow_block = flow_block;
+
+	if (register_block) {
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, &mlxsw_sp_block_cb_list);
+	}
+
+	return 0;
+
+err_block_bind:
+	if (!flow_block_cb_decref(block_cb))
+		flow_block_cb_free(block_cb);
+err_cb_register:
+	return err;
+}
+
+static void mlxsw_sp_setup_tc_block_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
+					   struct flow_block_offload *f,
+					   bool ingress)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_flow_block *flow_block;
+	struct flow_block_cb *block_cb;
+	int err;
+
+	block_cb = flow_block_cb_lookup(f->block, mlxsw_sp_flow_block_cb,
+					mlxsw_sp);
+	if (!block_cb)
+		return;
+
+	if (ingress)
+		mlxsw_sp_port->ing_flow_block = NULL;
+	else
+		mlxsw_sp_port->eg_flow_block = NULL;
+
+	flow_block = flow_block_cb_priv(block_cb);
+	err = mlxsw_sp_flow_block_unbind(mlxsw_sp, flow_block,
+					 mlxsw_sp_port, ingress);
+	if (!err && !flow_block_cb_decref(block_cb)) {
+		flow_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
+	}
+}
+
+int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
+			    struct flow_block_offload *f)
+{
+	bool ingress;
+
+	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		ingress = true;
+	else if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
+		ingress = false;
+	else
+		return -EOPNOTSUPP;
+
+	f->driver_block_list = &mlxsw_sp_block_cb_list;
+
+	switch (f->command) {
+	case FLOW_BLOCK_BIND:
+		return mlxsw_sp_setup_tc_block_bind(mlxsw_sp_port, f, ingress);
+	case FLOW_BLOCK_UNBIND:
+		mlxsw_sp_setup_tc_block_unbind(mlxsw_sp_port, f, ingress);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
-- 
2.24.1

