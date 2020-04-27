Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3176A1BA789
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgD0PNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:13:37 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47343 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727006AbgD0PNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:13:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2B6225C00BC;
        Mon, 27 Apr 2020 11:13:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Apr 2020 11:13:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=9N00gk6WAvBk6h2tdRyPCPKbv2B8MgbvTJcgU7XSXZ8=; b=JpZuBeTY
        UArgKMvB3ujJPzLfsp5LBxdCgnLuB7NUAYw3l1AsGHSsB25mgvJo/yYqqVyxYe0X
        8evzTIaT+y9IZFPiNGUL/g96LNPLAT6FakGGnEwOT38g56rUbCgCVruFcK+K9vl1
        FzeNLNNSkYFCVQ+dkBw0EPzWzG/r7/GeF/q1uBIcTEJXpdgkk35n3ul3TVHCNI0t
        DA4Pn5AUp3yRGvtHeukmQwomFg1aLy6BazVWFcXnyaaINabQC8H/m/cO7biKbRYR
        0rWJN7QhgfFUNZZukezgER4dRlKLwYYMsnwV+RRy9CSjtZTtllptrqkMHBKLo3zx
        feAXuNo3GuoggQ==
X-ME-Sender: <xms:n_amXvh-oe_1o9pHhf3j0fjPEFXU0xFx_tLESMdPW5MH-m5qgQ5K3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:n_amXnZ2_lQ5I9W710Ggorn8brHVzNGB_9bG6f5RKJVDV-sJvQ7sbg>
    <xmx:n_amXs_4o69Ff9EyR6rqR_9IZ2FgBRD3TiwO8o5IFYmKy25ujJtcQA>
    <xmx:n_amXnZzS6JJPcIqO06QwKB-R-NKcBkqQTi9uBY35TO_-W-ayEK4Qw>
    <xmx:n_amXi4Ae_VcfYTliD5JxA4aJGcv0zxAfih_M9TvO3PRyzyk6l8AsA>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id EEEFB3280059;
        Mon, 27 Apr 2020 11:13:33 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/13] mlxsw: spectrum: Push flow_block related functions into a separate file
Date:   Mon, 27 Apr 2020 18:13:00 +0300
Message-Id: <20200427151310.3950411-4-idosch@idosch.org>
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

The code around flow_block is currently mixed in spectrum_acl.c.
However, as it really does not directly relate to ACL part only,
push the bits into a separate file.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   1 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  34 +++--
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 131 +-----------------
 .../ethernet/mellanox/mlxsw/spectrum_flow.c   | 120 ++++++++++++++++
 4 files changed, 151 insertions(+), 135 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c

diff --git a/drivers/net/ethernet/mellanox/mlxsw/Makefile b/drivers/net/ethernet/mellanox/mlxsw/Makefile
index 0e86a581d45b..59cbf02d6731 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Makefile
+++ b/drivers/net/ethernet/mellanox/mlxsw/Makefile
@@ -21,6 +21,7 @@ mlxsw_spectrum-objs		:= spectrum.o spectrum_buffers.o \
 				   spectrum_acl_atcam.o spectrum_acl_erp.o \
 				   spectrum1_acl_tcam.o spectrum2_acl_tcam.o \
 				   spectrum_acl_bloom_filter.o spectrum_acl.o \
+				   spectrum_flow.o \
 				   spectrum_flower.o spectrum_cnt.o \
 				   spectrum_fid.o spectrum_ipip.o \
 				   spectrum_acl_flex_actions.o \
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 65b1a2d87c2d..d4ef079aab4b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -654,15 +654,7 @@ struct mlxsw_sp_acl_rule_info {
 	unsigned int counter_index;
 };
 
-struct mlxsw_sp_flow_block;
-struct mlxsw_sp_acl_ruleset;
-
-/* spectrum_acl.c */
-enum mlxsw_sp_acl_profile {
-	MLXSW_SP_ACL_PROFILE_FLOWER,
-	MLXSW_SP_ACL_PROFILE_MR,
-};
-
+/* spectrum_flow.c */
 struct mlxsw_sp_flow_block {
 	struct list_head binding_list;
 	struct mlxsw_sp_acl_ruleset *ruleset_zero;
@@ -676,7 +668,12 @@ struct mlxsw_sp_flow_block {
 	struct net *net;
 };
 
-struct mlxsw_afk *mlxsw_sp_acl_afk(struct mlxsw_sp_acl *acl);
+struct mlxsw_sp_flow_block_binding {
+	struct list_head list;
+	struct net_device *dev;
+	struct mlxsw_sp_port *mlxsw_sp_port;
+	bool ingress;
+};
 
 static inline struct mlxsw_sp *
 mlxsw_sp_flow_block_mlxsw_sp(struct mlxsw_sp_flow_block *block)
@@ -740,6 +737,23 @@ int mlxsw_sp_flow_block_unbind(struct mlxsw_sp *mlxsw_sp,
 			       struct mlxsw_sp_flow_block *block,
 			       struct mlxsw_sp_port *mlxsw_sp_port,
 			       bool ingress);
+
+/* spectrum_acl.c */
+struct mlxsw_sp_acl_ruleset;
+
+enum mlxsw_sp_acl_profile {
+	MLXSW_SP_ACL_PROFILE_FLOWER,
+	MLXSW_SP_ACL_PROFILE_MR,
+};
+
+struct mlxsw_afk *mlxsw_sp_acl_afk(struct mlxsw_sp_acl *acl);
+
+int mlxsw_sp_acl_ruleset_bind(struct mlxsw_sp *mlxsw_sp,
+			      struct mlxsw_sp_flow_block *block,
+			      struct mlxsw_sp_flow_block_binding *binding);
+void mlxsw_sp_acl_ruleset_unbind(struct mlxsw_sp *mlxsw_sp,
+				 struct mlxsw_sp_flow_block *block,
+				 struct mlxsw_sp_flow_block_binding *binding);
 struct mlxsw_sp_acl_ruleset *
 mlxsw_sp_acl_ruleset_lookup(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_flow_block *block, u32 chain_index,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index f9524cb95e9f..800eaa6be3c0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -40,13 +40,6 @@ struct mlxsw_afk *mlxsw_sp_acl_afk(struct mlxsw_sp_acl *acl)
 	return acl->afk;
 }
 
-struct mlxsw_sp_flow_block_binding {
-	struct list_head list;
-	struct net_device *dev;
-	struct mlxsw_sp_port *mlxsw_sp_port;
-	bool ingress;
-};
-
 struct mlxsw_sp_acl_ruleset_ht_key {
 	struct mlxsw_sp_flow_block *block;
 	u32 chain_index;
@@ -101,10 +94,9 @@ mlxsw_sp_acl_ruleset_is_singular(const struct mlxsw_sp_acl_ruleset *ruleset)
 	return ruleset->ref_count == 2;
 }
 
-static int
-mlxsw_sp_acl_ruleset_bind(struct mlxsw_sp *mlxsw_sp,
-			  struct mlxsw_sp_flow_block *block,
-			  struct mlxsw_sp_flow_block_binding *binding)
+int mlxsw_sp_acl_ruleset_bind(struct mlxsw_sp *mlxsw_sp,
+			      struct mlxsw_sp_flow_block *block,
+			      struct mlxsw_sp_flow_block_binding *binding)
 {
 	struct mlxsw_sp_acl_ruleset *ruleset = block->ruleset_zero;
 	const struct mlxsw_sp_acl_profile_ops *ops = ruleset->ht_key.ops;
@@ -113,10 +105,9 @@ mlxsw_sp_acl_ruleset_bind(struct mlxsw_sp *mlxsw_sp,
 				 binding->mlxsw_sp_port, binding->ingress);
 }
 
-static void
-mlxsw_sp_acl_ruleset_unbind(struct mlxsw_sp *mlxsw_sp,
-			    struct mlxsw_sp_flow_block *block,
-			    struct mlxsw_sp_flow_block_binding *binding)
+void mlxsw_sp_acl_ruleset_unbind(struct mlxsw_sp *mlxsw_sp,
+				 struct mlxsw_sp_flow_block *block,
+				 struct mlxsw_sp_flow_block_binding *binding)
 {
 	struct mlxsw_sp_acl_ruleset *ruleset = block->ruleset_zero;
 	const struct mlxsw_sp_acl_profile_ops *ops = ruleset->ht_key.ops;
@@ -125,12 +116,6 @@ mlxsw_sp_acl_ruleset_unbind(struct mlxsw_sp *mlxsw_sp,
 			    binding->mlxsw_sp_port, binding->ingress);
 }
 
-static bool
-mlxsw_sp_acl_ruleset_block_bound(const struct mlxsw_sp_flow_block *block)
-{
-	return block->ruleset_zero;
-}
-
 static int
 mlxsw_sp_acl_ruleset_block_bind(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_acl_ruleset *ruleset,
@@ -168,110 +153,6 @@ mlxsw_sp_acl_ruleset_block_unbind(struct mlxsw_sp *mlxsw_sp,
 	block->ruleset_zero = NULL;
 }
 
-struct mlxsw_sp_flow_block *
-mlxsw_sp_flow_block_create(struct mlxsw_sp *mlxsw_sp, struct net *net)
-{
-	struct mlxsw_sp_flow_block *block;
-
-	block = kzalloc(sizeof(*block), GFP_KERNEL);
-	if (!block)
-		return NULL;
-	INIT_LIST_HEAD(&block->binding_list);
-	block->mlxsw_sp = mlxsw_sp;
-	block->net = net;
-	return block;
-}
-
-void mlxsw_sp_flow_block_destroy(struct mlxsw_sp_flow_block *block)
-{
-	WARN_ON(!list_empty(&block->binding_list));
-	kfree(block);
-}
-
-static struct mlxsw_sp_flow_block_binding *
-mlxsw_sp_flow_block_lookup(struct mlxsw_sp_flow_block *block,
-			   struct mlxsw_sp_port *mlxsw_sp_port, bool ingress)
-{
-	struct mlxsw_sp_flow_block_binding *binding;
-
-	list_for_each_entry(binding, &block->binding_list, list)
-		if (binding->mlxsw_sp_port == mlxsw_sp_port &&
-		    binding->ingress == ingress)
-			return binding;
-	return NULL;
-}
-
-int mlxsw_sp_flow_block_bind(struct mlxsw_sp *mlxsw_sp,
-			     struct mlxsw_sp_flow_block *block,
-			     struct mlxsw_sp_port *mlxsw_sp_port,
-			     bool ingress,
-			     struct netlink_ext_ack *extack)
-{
-	struct mlxsw_sp_flow_block_binding *binding;
-	int err;
-
-	if (WARN_ON(mlxsw_sp_flow_block_lookup(block, mlxsw_sp_port, ingress)))
-		return -EEXIST;
-
-	if (ingress && block->ingress_blocker_rule_count) {
-		NL_SET_ERR_MSG_MOD(extack, "Block cannot be bound to ingress because it contains unsupported rules");
-		return -EOPNOTSUPP;
-	}
-
-	if (!ingress && block->egress_blocker_rule_count) {
-		NL_SET_ERR_MSG_MOD(extack, "Block cannot be bound to egress because it contains unsupported rules");
-		return -EOPNOTSUPP;
-	}
-
-	binding = kzalloc(sizeof(*binding), GFP_KERNEL);
-	if (!binding)
-		return -ENOMEM;
-	binding->mlxsw_sp_port = mlxsw_sp_port;
-	binding->ingress = ingress;
-
-	if (mlxsw_sp_acl_ruleset_block_bound(block)) {
-		err = mlxsw_sp_acl_ruleset_bind(mlxsw_sp, block, binding);
-		if (err)
-			goto err_ruleset_bind;
-	}
-
-	if (ingress)
-		block->ingress_binding_count++;
-	else
-		block->egress_binding_count++;
-	list_add(&binding->list, &block->binding_list);
-	return 0;
-
-err_ruleset_bind:
-	kfree(binding);
-	return err;
-}
-
-int mlxsw_sp_flow_block_unbind(struct mlxsw_sp *mlxsw_sp,
-			       struct mlxsw_sp_flow_block *block,
-			       struct mlxsw_sp_port *mlxsw_sp_port,
-			       bool ingress)
-{
-	struct mlxsw_sp_flow_block_binding *binding;
-
-	binding = mlxsw_sp_flow_block_lookup(block, mlxsw_sp_port, ingress);
-	if (!binding)
-		return -ENOENT;
-
-	list_del(&binding->list);
-
-	if (ingress)
-		block->ingress_binding_count--;
-	else
-		block->egress_binding_count--;
-
-	if (mlxsw_sp_acl_ruleset_block_bound(block))
-		mlxsw_sp_acl_ruleset_unbind(mlxsw_sp, block, binding);
-
-	kfree(binding);
-	return 0;
-}
-
 static struct mlxsw_sp_acl_ruleset *
 mlxsw_sp_acl_ruleset_create(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_flow_block *block, u32 chain_index,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
new file mode 100644
index 000000000000..655e1df5c95a
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2017-2020 Mellanox Technologies. All rights reserved */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/list.h>
+#include <net/net_namespace.h>
+
+#include "spectrum.h"
+
+struct mlxsw_sp_flow_block *
+mlxsw_sp_flow_block_create(struct mlxsw_sp *mlxsw_sp, struct net *net)
+{
+	struct mlxsw_sp_flow_block *block;
+
+	block = kzalloc(sizeof(*block), GFP_KERNEL);
+	if (!block)
+		return NULL;
+	INIT_LIST_HEAD(&block->binding_list);
+	block->mlxsw_sp = mlxsw_sp;
+	block->net = net;
+	return block;
+}
+
+void mlxsw_sp_flow_block_destroy(struct mlxsw_sp_flow_block *block)
+{
+	WARN_ON(!list_empty(&block->binding_list));
+	kfree(block);
+}
+
+static struct mlxsw_sp_flow_block_binding *
+mlxsw_sp_flow_block_lookup(struct mlxsw_sp_flow_block *block,
+			   struct mlxsw_sp_port *mlxsw_sp_port, bool ingress)
+{
+	struct mlxsw_sp_flow_block_binding *binding;
+
+	list_for_each_entry(binding, &block->binding_list, list)
+		if (binding->mlxsw_sp_port == mlxsw_sp_port &&
+		    binding->ingress == ingress)
+			return binding;
+	return NULL;
+}
+
+static bool
+mlxsw_sp_flow_block_ruleset_bound(const struct mlxsw_sp_flow_block *block)
+{
+	return block->ruleset_zero;
+}
+
+int mlxsw_sp_flow_block_bind(struct mlxsw_sp *mlxsw_sp,
+			     struct mlxsw_sp_flow_block *block,
+			     struct mlxsw_sp_port *mlxsw_sp_port,
+			     bool ingress,
+			     struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_flow_block_binding *binding;
+	int err;
+
+	if (WARN_ON(mlxsw_sp_flow_block_lookup(block, mlxsw_sp_port, ingress)))
+		return -EEXIST;
+
+	if (ingress && block->ingress_blocker_rule_count) {
+		NL_SET_ERR_MSG_MOD(extack, "Block cannot be bound to ingress because it contains unsupported rules");
+		return -EOPNOTSUPP;
+	}
+
+	if (!ingress && block->egress_blocker_rule_count) {
+		NL_SET_ERR_MSG_MOD(extack, "Block cannot be bound to egress because it contains unsupported rules");
+		return -EOPNOTSUPP;
+	}
+
+	binding = kzalloc(sizeof(*binding), GFP_KERNEL);
+	if (!binding)
+		return -ENOMEM;
+	binding->mlxsw_sp_port = mlxsw_sp_port;
+	binding->ingress = ingress;
+
+	if (mlxsw_sp_flow_block_ruleset_bound(block)) {
+		err = mlxsw_sp_acl_ruleset_bind(mlxsw_sp, block, binding);
+		if (err)
+			goto err_ruleset_bind;
+	}
+
+	if (ingress)
+		block->ingress_binding_count++;
+	else
+		block->egress_binding_count++;
+	list_add(&binding->list, &block->binding_list);
+	return 0;
+
+err_ruleset_bind:
+	kfree(binding);
+	return err;
+}
+
+int mlxsw_sp_flow_block_unbind(struct mlxsw_sp *mlxsw_sp,
+			       struct mlxsw_sp_flow_block *block,
+			       struct mlxsw_sp_port *mlxsw_sp_port,
+			       bool ingress)
+{
+	struct mlxsw_sp_flow_block_binding *binding;
+
+	binding = mlxsw_sp_flow_block_lookup(block, mlxsw_sp_port, ingress);
+	if (!binding)
+		return -ENOENT;
+
+	list_del(&binding->list);
+
+	if (ingress)
+		block->ingress_binding_count--;
+	else
+		block->egress_binding_count--;
+
+	if (mlxsw_sp_flow_block_ruleset_bound(block))
+		mlxsw_sp_acl_ruleset_unbind(mlxsw_sp, block, binding);
+
+	kfree(binding);
+	return 0;
+}
-- 
2.24.1

