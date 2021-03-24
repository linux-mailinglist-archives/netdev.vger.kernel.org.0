Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D773482AC
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238166AbhCXUPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:15:16 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34039 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238098AbhCXUOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:14:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id DAD4D5C005E;
        Wed, 24 Mar 2021 16:14:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 24 Mar 2021 16:14:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=WgMmKwY8Z0i1MDlab99N/YeT9tpDntainl86O0GXx3c=; b=PFILismf
        LiavXJHcMrTgE7jly1B+/1gdtBkn6BmNBO/0LGlCYsTWNx3tSJRMEbwa58CoEwrS
        hYhco+1DL5gJwVAj3Ne+I9nUM4pMf44lqxex3jsKQizCLqKea/bNOjUFHjnBqpUh
        yZTkf/dWGZyNb+3QFt579aGv/Gli/AOBmGlorj0iNSxSEnzM85814TchfjAoXif9
        Nyd9R09a1SxkwF5Wj9kWYog21Uefo5+sSVKIvCfFKIGerq1P755fECF4J3Bx3/5H
        r4cYEmj8zEHuvSffaYD9Tq014RXxqJ/6nzupnAvpgUzsuTpWNXJF4ufxFFqNiJ9T
        hFeU0L4Cjm4XnA==
X-ME-Sender: <xms:vJ1bYHOcXu4kNZO-jn4a5mHWDZi3yzZiSw0rawJOHp77x0SRoL3MOQ>
    <xme:vJ1bYPz8-0vErhGbH3G7q70jnNuHdZgydJhh4gqY0k8YKy_5hpNBV-_TeRMGEeJid
    72SCJRBztYtSmI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegkedgudeffecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeg
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:vJ1bYAtVJi16FYn_zjOd0XqehpHOyEXQVIHslH2y-_spqU68wJXtbg>
    <xmx:vJ1bYI5ldOjJp72eN1xBQiKsOWHRuQHow-_aSOm4QKmoJfYOltD6qw>
    <xmx:vJ1bYPTkn9fnIbuBxfW-VKuR4CZkTqqD6714VM5n_VnZGLmDDJFxYg>
    <xmx:vJ1bYAG3CXOY3PGvjolsOxrrQvHfmfSPUCU1ZzC6GqKFaLXh37Hvrg>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id A0C79240426;
        Wed, 24 Mar 2021 16:14:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/10] mlxsw: spectrum_router: Add nexthop bucket replacement support
Date:   Wed, 24 Mar 2021 22:14:18 +0200
Message-Id: <20210324201424.157387-5-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324201424.157387-1-idosch@idosch.org>
References: <20210324201424.157387-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Replace a single nexthop bucket upon receiving a
'NEXTHOP_EVENT_BUCKET_REPLACE' notification.

When the 'force' parameter is not set, instruct the device to only
overwrite an adjacency entry if its activity is cleared, so as not to
break existing flows using the adjacency entry. The device does not
provide feedback if the replacement was successful in this case, so the
contents of the adjacency entry after the replacement are compared with
the replacement request.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 134 ++++++++++++++++++
 1 file changed, 134 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 02200b183bf7..d6e91f1f48cc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4337,6 +4337,8 @@ static void mlxsw_sp_nexthop_rif_gone_sync(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
+#define MLXSW_SP_NH_GRP_ACTIVITY_UPDATE_INTERVAL 1000 /* ms */
+
 static int
 mlxsw_sp_nexthop_obj_single_validate(struct mlxsw_sp *mlxsw_sp,
 				     const struct nh_notifier_single_info *nh,
@@ -4806,6 +4808,134 @@ static void mlxsw_sp_nexthop_obj_del(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_nexthop_obj_group_destroy(mlxsw_sp, nh_grp);
 }
 
+static int mlxsw_sp_nexthop_obj_bucket_query(struct mlxsw_sp *mlxsw_sp,
+					     u32 adj_index, char *ratr_pl)
+{
+	MLXSW_REG_ZERO(ratr, ratr_pl);
+	mlxsw_reg_ratr_op_set(ratr_pl, MLXSW_REG_RATR_OP_QUERY_READ);
+	mlxsw_reg_ratr_adjacency_index_low_set(ratr_pl, adj_index);
+	mlxsw_reg_ratr_adjacency_index_high_set(ratr_pl, adj_index >> 16);
+
+	return mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(ratr), ratr_pl);
+}
+
+static int mlxsw_sp_nexthop_obj_bucket_compare(char *ratr_pl, char *ratr_pl_new)
+{
+	/* Clear the opcode and activity on both the old and new payload as
+	 * they are irrelevant for the comparison.
+	 */
+	mlxsw_reg_ratr_op_set(ratr_pl, MLXSW_REG_RATR_OP_QUERY_READ);
+	mlxsw_reg_ratr_a_set(ratr_pl, 0);
+	mlxsw_reg_ratr_op_set(ratr_pl_new, MLXSW_REG_RATR_OP_QUERY_READ);
+	mlxsw_reg_ratr_a_set(ratr_pl_new, 0);
+
+	/* If the contents of the adjacency entry are consistent with the
+	 * replacement request, then replacement was successful.
+	 */
+	if (!memcmp(ratr_pl, ratr_pl_new, MLXSW_REG_RATR_LEN))
+		return 0;
+
+	return -EINVAL;
+}
+
+static int
+mlxsw_sp_nexthop_obj_bucket_adj_update(struct mlxsw_sp *mlxsw_sp,
+				       struct mlxsw_sp_nexthop *nh,
+				       struct nh_notifier_info *info)
+{
+	u16 bucket_index = info->nh_res_bucket->bucket_index;
+	struct netlink_ext_ack *extack = info->extack;
+	bool force = info->nh_res_bucket->force;
+	char ratr_pl_new[MLXSW_REG_RATR_LEN];
+	char ratr_pl[MLXSW_REG_RATR_LEN];
+	u32 adj_index;
+	int err;
+
+	/* No point in trying an atomic replacement if the idle timer interval
+	 * is smaller than the interval in which we query and clear activity.
+	 */
+	force = info->nh_res_bucket->idle_timer_ms <
+		MLXSW_SP_NH_GRP_ACTIVITY_UPDATE_INTERVAL;
+
+	adj_index = nh->nhgi->adj_index + bucket_index;
+	err = mlxsw_sp_nexthop_update(mlxsw_sp, adj_index, nh, force, ratr_pl);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to overwrite nexthop bucket");
+		return err;
+	}
+
+	if (!force) {
+		err = mlxsw_sp_nexthop_obj_bucket_query(mlxsw_sp, adj_index,
+							ratr_pl_new);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to query nexthop bucket state after replacement. State might be inconsistent");
+			return err;
+		}
+
+		err = mlxsw_sp_nexthop_obj_bucket_compare(ratr_pl, ratr_pl_new);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Nexthop bucket was not replaced because it was active during replacement");
+			return err;
+		}
+	}
+
+	nh->update = 0;
+	nh->offloaded = 1;
+
+	return 0;
+}
+
+static int mlxsw_sp_nexthop_obj_bucket_replace(struct mlxsw_sp *mlxsw_sp,
+					       struct nh_notifier_info *info)
+{
+	u16 bucket_index = info->nh_res_bucket->bucket_index;
+	struct netlink_ext_ack *extack = info->extack;
+	struct mlxsw_sp_nexthop_group_info *nhgi;
+	struct nh_notifier_single_info *nh_obj;
+	struct mlxsw_sp_nexthop_group *nh_grp;
+	struct mlxsw_sp_nexthop *nh;
+	int err;
+
+	nh_grp = mlxsw_sp_nexthop_obj_group_lookup(mlxsw_sp, info->id);
+	if (!nh_grp) {
+		NL_SET_ERR_MSG_MOD(extack, "Nexthop group was not found");
+		return -EINVAL;
+	}
+
+	nhgi = nh_grp->nhgi;
+
+	if (bucket_index >= nhgi->count) {
+		NL_SET_ERR_MSG_MOD(extack, "Nexthop bucket index out of range");
+		return -EINVAL;
+	}
+
+	nh = &nhgi->nexthops[bucket_index];
+	mlxsw_sp_nexthop_obj_fini(mlxsw_sp, nh);
+
+	nh_obj = &info->nh_res_bucket->new_nh;
+	err = mlxsw_sp_nexthop_obj_init(mlxsw_sp, nh_grp, nh, nh_obj, 1);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to initialize nexthop object for nexthop bucket replacement");
+		goto err_nexthop_obj_init;
+	}
+
+	err = mlxsw_sp_nexthop_obj_bucket_adj_update(mlxsw_sp, nh, info);
+	if (err)
+		goto err_nexthop_obj_bucket_adj_update;
+
+	return 0;
+
+err_nexthop_obj_bucket_adj_update:
+	mlxsw_sp_nexthop_obj_fini(mlxsw_sp, nh);
+err_nexthop_obj_init:
+	nh_obj = &info->nh_res_bucket->old_nh;
+	mlxsw_sp_nexthop_obj_init(mlxsw_sp, nh_grp, nh, nh_obj, 1);
+	/* The old adjacency entry was not overwritten */
+	nh->update = 0;
+	nh->offloaded = 1;
+	return err;
+}
+
 static int mlxsw_sp_nexthop_obj_event(struct notifier_block *nb,
 				      unsigned long event, void *ptr)
 {
@@ -4827,6 +4957,10 @@ static int mlxsw_sp_nexthop_obj_event(struct notifier_block *nb,
 	case NEXTHOP_EVENT_DEL:
 		mlxsw_sp_nexthop_obj_del(router->mlxsw_sp, info);
 		break;
+	case NEXTHOP_EVENT_BUCKET_REPLACE:
+		err = mlxsw_sp_nexthop_obj_bucket_replace(router->mlxsw_sp,
+							  info);
+		break;
 	default:
 		break;
 	}
-- 
2.30.2

