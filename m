Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E8421B75C
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgGJN6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:58:19 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:40323 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728102AbgGJN6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:58:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6701558058B;
        Fri, 10 Jul 2020 09:58:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 10 Jul 2020 09:58:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=H87IeOXUfJL39qpvvMRSMd+c1lEzl2hPnMXuwsnQ8fY=; b=gCsAaOdq
        EgYm8BrhosW2R9cUOZBN+FlMl4pFRRcHL6XAUe0b0PvPPM3juayIgDe4ZT98hxR3
        kb7pD9/alf5a9nbPNGbw5lkT7Vm6RtLRUHr76WSS2H8vxnzXAxQwuw2hPIAi7JJW
        NCka2TB2PFWcOMIkfDs9PCui4DpypVN/lIh4SxgSyud5hVFnrTqDBZOlb7vbbloW
        VkePZW+0avdT16S83OS2qdfit+0+nbl/EfCuCjH18Pd34H8rMQXAvXng8MsTgKUU
        NxGVK0KB9UHMCOYsBgLemPc6IJnGYx/sfTp/9R0nVBMmqSCiQFF30AtnYG8QIk9Q
        pV3b2de1h3Fc7A==
X-ME-Sender: <xms:9nMIX2g1DnGDRKVUignOByYm0Q50qY0p0hekTqAyopVLVlr3ko0IMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:9nMIX3BJ3ppCk6Gc_JTd6mezaaZure_mIIyXXXD5KuijmmOkOd1Mxw>
    <xmx:9nMIX-E8QHHCKBpfJWR601AU5Nt0VskeB4XVF9PDuyzkTq9CiOAyGQ>
    <xmx:9nMIX_R9W3Eljj60HdsqY0edwEvz_T1hClngnQoH0Gp1b15X3qn5ZQ>
    <xmx:9nMIXx7985gBFKjbkYnE3KmWPSXsM4Gl_TmFOB3_193thlxc7lcW4g>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id BC76E328005E;
        Fri, 10 Jul 2020 09:58:10 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/13] mlxsw: spectrum_span: Prepare for global mirroring triggers
Date:   Fri, 10 Jul 2020 16:56:58 +0300
Message-Id: <20200710135706.601409-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710135706.601409-1-idosch@idosch.org>
References: <20200710135706.601409-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Currently, a SPAN agent can only be bound to a per-port trigger where
the trigger is either an incoming packet (INGRESS) or an outgoing packet
(EGRESS) to / from the port.

The subsequent patch will introduce the concept of global mirroring
triggers. The binding / unbinding of global triggers is different than
that of per-port triggers. Such triggers also need to be enabled /
disabled on a per-{port, TC} basis and are only supported from
Spectrum-2 onwards.

Add trigger operations that allow us to abstract these differences. Only
implement the operations for per-port triggers. Next patch will
implement the operations for global triggers.

Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 119 +++++++++++++++---
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |   1 +
 2 files changed, 103 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 49e2a417ec0e..b20422dde147 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -21,6 +21,7 @@
 struct mlxsw_sp_span {
 	struct work_struct work;
 	struct mlxsw_sp *mlxsw_sp;
+	const struct mlxsw_sp_span_trigger_ops **span_trigger_ops_arr;
 	struct list_head analyzed_ports_list;
 	struct mutex analyzed_ports_lock; /* Protects analyzed_ports_list */
 	struct list_head trigger_entries_list;
@@ -38,12 +39,26 @@ struct mlxsw_sp_span_analyzed_port {
 
 struct mlxsw_sp_span_trigger_entry {
 	struct list_head list; /* Member of trigger_entries_list */
+	struct mlxsw_sp_span *span;
+	const struct mlxsw_sp_span_trigger_ops *ops;
 	refcount_t ref_count;
 	u8 local_port;
 	enum mlxsw_sp_span_trigger trigger;
 	struct mlxsw_sp_span_trigger_parms parms;
 };
 
+enum mlxsw_sp_span_trigger_type {
+	MLXSW_SP_SPAN_TRIGGER_TYPE_PORT,
+};
+
+struct mlxsw_sp_span_trigger_ops {
+	int (*bind)(struct mlxsw_sp_span_trigger_entry *trigger_entry);
+	void (*unbind)(struct mlxsw_sp_span_trigger_entry *trigger_entry);
+	bool (*matches)(struct mlxsw_sp_span_trigger_entry *trigger_entry,
+			enum mlxsw_sp_span_trigger trigger,
+			struct mlxsw_sp_port *mlxsw_sp_port);
+};
+
 static void mlxsw_sp_span_respin_work(struct work_struct *work);
 
 static u64 mlxsw_sp_span_occ_get(void *priv)
@@ -57,7 +72,7 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	struct mlxsw_sp_span *span;
-	int i, entries_count;
+	int i, entries_count, err;
 
 	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, MAX_SPAN))
 		return -EIO;
@@ -77,11 +92,20 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 	for (i = 0; i < mlxsw_sp->span->entries_count; i++)
 		mlxsw_sp->span->entries[i].id = i;
 
+	err = mlxsw_sp->span_ops->init(mlxsw_sp);
+	if (err)
+		goto err_init;
+
 	devlink_resource_occ_get_register(devlink, MLXSW_SP_RESOURCE_SPAN,
 					  mlxsw_sp_span_occ_get, mlxsw_sp);
 	INIT_WORK(&span->work, mlxsw_sp_span_respin_work);
 
 	return 0;
+
+err_init:
+	mutex_destroy(&mlxsw_sp->span->analyzed_ports_lock);
+	kfree(mlxsw_sp->span);
+	return err;
 }
 
 void mlxsw_sp_span_fini(struct mlxsw_sp *mlxsw_sp)
@@ -1059,9 +1083,9 @@ void mlxsw_sp_span_analyzed_port_put(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int
-__mlxsw_sp_span_trigger_entry_bind(struct mlxsw_sp_span *span,
-				   struct mlxsw_sp_span_trigger_entry *
-				   trigger_entry, bool enable)
+__mlxsw_sp_span_trigger_port_bind(struct mlxsw_sp_span *span,
+				  struct mlxsw_sp_span_trigger_entry *
+				  trigger_entry, bool enable)
 {
 	char mpar_pl[MLXSW_REG_MPAR_LEN];
 	enum mlxsw_reg_mpar_i_e i_e;
@@ -1084,19 +1108,60 @@ __mlxsw_sp_span_trigger_entry_bind(struct mlxsw_sp_span *span,
 }
 
 static int
-mlxsw_sp_span_trigger_entry_bind(struct mlxsw_sp_span *span,
-				 struct mlxsw_sp_span_trigger_entry *
-				 trigger_entry)
+mlxsw_sp_span_trigger_port_bind(struct mlxsw_sp_span_trigger_entry *
+				trigger_entry)
 {
-	return __mlxsw_sp_span_trigger_entry_bind(span, trigger_entry, true);
+	return __mlxsw_sp_span_trigger_port_bind(trigger_entry->span,
+						 trigger_entry, true);
 }
 
 static void
-mlxsw_sp_span_trigger_entry_unbind(struct mlxsw_sp_span *span,
-				   struct mlxsw_sp_span_trigger_entry *
-				   trigger_entry)
+mlxsw_sp_span_trigger_port_unbind(struct mlxsw_sp_span_trigger_entry *
+				  trigger_entry)
 {
-	__mlxsw_sp_span_trigger_entry_bind(span, trigger_entry, false);
+	__mlxsw_sp_span_trigger_port_bind(trigger_entry->span, trigger_entry,
+					  false);
+}
+
+static bool
+mlxsw_sp_span_trigger_port_matches(struct mlxsw_sp_span_trigger_entry *
+				   trigger_entry,
+				   enum mlxsw_sp_span_trigger trigger,
+				   struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	return trigger_entry->trigger == trigger &&
+	       trigger_entry->local_port == mlxsw_sp_port->local_port;
+}
+
+static const struct mlxsw_sp_span_trigger_ops
+mlxsw_sp_span_trigger_port_ops = {
+	.bind = mlxsw_sp_span_trigger_port_bind,
+	.unbind = mlxsw_sp_span_trigger_port_unbind,
+	.matches = mlxsw_sp_span_trigger_port_matches,
+};
+
+static const struct mlxsw_sp_span_trigger_ops *
+mlxsw_sp_span_trigger_ops_arr[] = {
+	[MLXSW_SP_SPAN_TRIGGER_TYPE_PORT] = &mlxsw_sp_span_trigger_port_ops,
+};
+
+static void
+mlxsw_sp_span_trigger_ops_set(struct mlxsw_sp_span_trigger_entry *trigger_entry)
+{
+	struct mlxsw_sp_span *span = trigger_entry->span;
+	enum mlxsw_sp_span_trigger_type type;
+
+	switch (trigger_entry->trigger) {
+	case MLXSW_SP_SPAN_TRIGGER_INGRESS: /* fall-through */
+	case MLXSW_SP_SPAN_TRIGGER_EGRESS:
+		type = MLXSW_SP_SPAN_TRIGGER_TYPE_PORT;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return;
+	}
+
+	trigger_entry->ops = span->span_trigger_ops_arr[type];
 }
 
 static struct mlxsw_sp_span_trigger_entry *
@@ -1114,12 +1179,15 @@ mlxsw_sp_span_trigger_entry_create(struct mlxsw_sp_span *span,
 		return ERR_PTR(-ENOMEM);
 
 	refcount_set(&trigger_entry->ref_count, 1);
-	trigger_entry->local_port = mlxsw_sp_port->local_port;
+	trigger_entry->local_port = mlxsw_sp_port ? mlxsw_sp_port->local_port :
+						    0;
 	trigger_entry->trigger = trigger;
 	memcpy(&trigger_entry->parms, parms, sizeof(trigger_entry->parms));
+	trigger_entry->span = span;
+	mlxsw_sp_span_trigger_ops_set(trigger_entry);
 	list_add_tail(&trigger_entry->list, &span->trigger_entries_list);
 
-	err = mlxsw_sp_span_trigger_entry_bind(span, trigger_entry);
+	err = trigger_entry->ops->bind(trigger_entry);
 	if (err)
 		goto err_trigger_entry_bind;
 
@@ -1136,7 +1204,7 @@ mlxsw_sp_span_trigger_entry_destroy(struct mlxsw_sp_span *span,
 				    struct mlxsw_sp_span_trigger_entry *
 				    trigger_entry)
 {
-	mlxsw_sp_span_trigger_entry_unbind(span, trigger_entry);
+	trigger_entry->ops->unbind(trigger_entry);
 	list_del(&trigger_entry->list);
 	kfree(trigger_entry);
 }
@@ -1149,8 +1217,8 @@ mlxsw_sp_span_trigger_entry_find(struct mlxsw_sp_span *span,
 	struct mlxsw_sp_span_trigger_entry *trigger_entry;
 
 	list_for_each_entry(trigger_entry, &span->trigger_entries_list, list) {
-		if (trigger_entry->trigger == trigger &&
-		    trigger_entry->local_port == mlxsw_sp_port->local_port)
+		if (trigger_entry->ops->matches(trigger_entry, trigger,
+						mlxsw_sp_port))
 			return trigger_entry;
 	}
 
@@ -1216,15 +1284,30 @@ void mlxsw_sp_span_agent_unbind(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_span_trigger_entry_destroy(mlxsw_sp->span, trigger_entry);
 }
 
+static int mlxsw_sp1_span_init(struct mlxsw_sp *mlxsw_sp)
+{
+	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp_span_trigger_ops_arr;
+
+	return 0;
+}
+
 static u32 mlxsw_sp1_span_buffsize_get(int mtu, u32 speed)
 {
 	return mtu * 5 / 2;
 }
 
 const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops = {
+	.init = mlxsw_sp1_span_init,
 	.buffsize_get = mlxsw_sp1_span_buffsize_get,
 };
 
+static int mlxsw_sp2_span_init(struct mlxsw_sp *mlxsw_sp)
+{
+	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp_span_trigger_ops_arr;
+
+	return 0;
+}
+
 #define MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR 38
 #define MLXSW_SP3_SPAN_EG_MIRROR_BUFFER_FACTOR 50
 
@@ -1241,6 +1324,7 @@ static u32 mlxsw_sp2_span_buffsize_get(int mtu, u32 speed)
 }
 
 const struct mlxsw_sp_span_ops mlxsw_sp2_span_ops = {
+	.init = mlxsw_sp2_span_init,
 	.buffsize_get = mlxsw_sp2_span_buffsize_get,
 };
 
@@ -1252,5 +1336,6 @@ static u32 mlxsw_sp3_span_buffsize_get(int mtu, u32 speed)
 }
 
 const struct mlxsw_sp_span_ops mlxsw_sp3_span_ops = {
+	.init = mlxsw_sp2_span_init,
 	.buffsize_get = mlxsw_sp3_span_buffsize_get,
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index 440551ec0dba..b9acecaf6ee2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -35,6 +35,7 @@ struct mlxsw_sp_span_trigger_parms {
 struct mlxsw_sp_span_entry_ops;
 
 struct mlxsw_sp_span_ops {
+	int (*init)(struct mlxsw_sp *mlxsw_sp);
 	u32 (*buffsize_get)(int mtu, u32 speed);
 };
 
-- 
2.26.2

