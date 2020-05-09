Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3591CC45C
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 22:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgEIUGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 16:06:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49507 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728651AbgEIUGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 16:06:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 128EA5C00B6;
        Sat,  9 May 2020 16:06:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 09 May 2020 16:06:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=mhuHPfq6t62cBK0iIjHww1f60h3AG/EHv+toQCsV5Po=; b=zIsDKY/9
        Qj0jnG7rZA3gGtA37w2ZEe4jCN20XbocOHctAVIXsAOgwKqy4dShLTuYr639uJ6v
        U+TYXZoIbQpc4UamZWyqBn6DTH6XfG2rJ4Rk6h8N5YAMOMMPp1A3YxSsDhwXCVcQ
        y6o9g110sDivE9/1gduqjGGeJc3JtHCXgvubPtXTmEQdHFXhF17D6vsQG/qPmTJ1
        SjeqxEUfTDsDz4lA8oAMLOXSACIeUZ43tGdmafYvHedlXSZKsTillOfn4DmhQIOu
        LqiKCYIhsfFg7LDkUSqc8MqmGUCG6Ty2QA4aa6AHRgOcIVuebgXoRAlLMoIHvFOm
        e+KxGQrZJ8QvtQ==
X-ME-Sender: <xms:Tw23XgbQihiIKXKQZuGE8uRzcC4iJkX7zNsMIVfed8DxMhuhw37-RA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkeehgddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Tw23XnN-2Te3JPmPI2yErabxclCrWjOxHrEkWGV8eRAni0Vt6NbRHw>
    <xmx:Tw23XgdnwFr8fh1rx_GtPKpIvj77KThIT5X8RvfGrgaaT-uheO7Srg>
    <xmx:Tw23XtFD7ALt2J7EsyolkmfNl9NX-5jPlK_AhjxP3BeG6SzUI-ScRg>
    <xmx:UA23Xm5Ex3wO3nK-9e3i207WXdJLzWjUQyWOr2oulRdEelYZuNSPCA>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8EFAC3066245;
        Sat,  9 May 2020 16:06:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/9] mlxsw: spectrum_flower: Expose a function to get min and max rule priority
Date:   Sat,  9 May 2020 23:06:03 +0300
Message-Id: <20200509200610.375719-3-idosch@idosch.org>
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

Introduce an infrastructure that allows to get minimum and maximum
rule priority for specified chain. This is going to be used by
a subsequent patch to enforce ordering between flower and
matchall filters.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  7 ++++
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 13 ++++++-
 .../mellanox/mlxsw/spectrum_acl_tcam.c        | 39 ++++++++++++++++---
 .../mellanox/mlxsw/spectrum_acl_tcam.h        |  3 +-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 20 ++++++++++
 5 files changed, 75 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index a12ca673c224..d9a963c77401 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -739,6 +739,9 @@ mlxsw_sp_acl_ruleset_get(struct mlxsw_sp *mlxsw_sp,
 void mlxsw_sp_acl_ruleset_put(struct mlxsw_sp *mlxsw_sp,
 			      struct mlxsw_sp_acl_ruleset *ruleset);
 u16 mlxsw_sp_acl_ruleset_group_id(struct mlxsw_sp_acl_ruleset *ruleset);
+void mlxsw_sp_acl_ruleset_prio_get(struct mlxsw_sp_acl_ruleset *ruleset,
+				   unsigned int *p_min_prio,
+				   unsigned int *p_max_prio);
 
 struct mlxsw_sp_acl_rule_info *
 mlxsw_sp_acl_rulei_create(struct mlxsw_sp_acl *acl,
@@ -912,6 +915,10 @@ int mlxsw_sp_flower_tmplt_create(struct mlxsw_sp *mlxsw_sp,
 void mlxsw_sp_flower_tmplt_destroy(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_flow_block *block,
 				   struct flow_cls_offload *f);
+int mlxsw_sp_flower_prio_get(struct mlxsw_sp *mlxsw_sp,
+			     struct mlxsw_sp_flow_block *block,
+			     u32 chain_index, unsigned int *p_min_prio,
+			     unsigned int *p_max_prio);
 
 /* spectrum_qdisc.c */
 int mlxsw_sp_tc_qdisc_init(struct mlxsw_sp_port *mlxsw_sp_port);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index c61f78e30397..47da9ee0045d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -51,6 +51,8 @@ struct mlxsw_sp_acl_ruleset {
 	struct mlxsw_sp_acl_ruleset_ht_key ht_key;
 	struct rhashtable rule_ht;
 	unsigned int ref_count;
+	unsigned int min_prio;
+	unsigned int max_prio;
 	unsigned long priv[];
 	/* priv has to be always the last item */
 };
@@ -178,7 +180,8 @@ mlxsw_sp_acl_ruleset_create(struct mlxsw_sp *mlxsw_sp,
 		goto err_rhashtable_init;
 
 	err = ops->ruleset_add(mlxsw_sp, &acl->tcam, ruleset->priv,
-			       tmplt_elusage);
+			       tmplt_elusage, &ruleset->min_prio,
+			       &ruleset->max_prio);
 	if (err)
 		goto err_ops_ruleset_add;
 
@@ -293,6 +296,14 @@ u16 mlxsw_sp_acl_ruleset_group_id(struct mlxsw_sp_acl_ruleset *ruleset)
 	return ops->ruleset_group_id(ruleset->priv);
 }
 
+void mlxsw_sp_acl_ruleset_prio_get(struct mlxsw_sp_acl_ruleset *ruleset,
+				   unsigned int *p_min_prio,
+				   unsigned int *p_max_prio)
+{
+	*p_min_prio = ruleset->min_prio;
+	*p_max_prio = ruleset->max_prio;
+}
+
 struct mlxsw_sp_acl_rule_info *
 mlxsw_sp_acl_rulei_create(struct mlxsw_sp_acl *acl,
 			  struct mlxsw_afa_block *afa_block)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index a6e30e020b5c..5c020403342f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -179,6 +179,8 @@ struct mlxsw_sp_acl_tcam_vgroup {
 	bool tmplt_elusage_set;
 	struct mlxsw_afk_element_usage tmplt_elusage;
 	bool vregion_rehash_enabled;
+	unsigned int *p_min_prio;
+	unsigned int *p_max_prio;
 };
 
 struct mlxsw_sp_acl_tcam_rehash_ctx {
@@ -316,13 +318,17 @@ mlxsw_sp_acl_tcam_vgroup_add(struct mlxsw_sp *mlxsw_sp,
 			     const struct mlxsw_sp_acl_tcam_pattern *patterns,
 			     unsigned int patterns_count,
 			     struct mlxsw_afk_element_usage *tmplt_elusage,
-			     bool vregion_rehash_enabled)
+			     bool vregion_rehash_enabled,
+			     unsigned int *p_min_prio,
+			     unsigned int *p_max_prio)
 {
 	int err;
 
 	vgroup->patterns = patterns;
 	vgroup->patterns_count = patterns_count;
 	vgroup->vregion_rehash_enabled = vregion_rehash_enabled;
+	vgroup->p_min_prio = p_min_prio;
+	vgroup->p_max_prio = p_max_prio;
 
 	if (tmplt_elusage) {
 		vgroup->tmplt_elusage_set = true;
@@ -416,6 +422,21 @@ mlxsw_sp_acl_tcam_vregion_max_prio(struct mlxsw_sp_acl_tcam_vregion *vregion)
 	return vchunk->priority;
 }
 
+static void
+mlxsw_sp_acl_tcam_vgroup_prio_update(struct mlxsw_sp_acl_tcam_vgroup *vgroup)
+{
+	struct mlxsw_sp_acl_tcam_vregion *vregion;
+
+	if (list_empty(&vgroup->vregion_list))
+		return;
+	vregion = list_first_entry(&vgroup->vregion_list,
+				   typeof(*vregion), list);
+	*vgroup->p_min_prio = mlxsw_sp_acl_tcam_vregion_prio(vregion);
+	vregion = list_last_entry(&vgroup->vregion_list,
+				  typeof(*vregion), list);
+	*vgroup->p_max_prio = mlxsw_sp_acl_tcam_vregion_max_prio(vregion);
+}
+
 static int
 mlxsw_sp_acl_tcam_group_region_attach(struct mlxsw_sp *mlxsw_sp,
 				      struct mlxsw_sp_acl_tcam_group *group,
@@ -1035,6 +1056,7 @@ mlxsw_sp_acl_tcam_vchunk_create(struct mlxsw_sp *mlxsw_sp,
 	}
 	list_add_tail(&vchunk->list, pos);
 	mutex_unlock(&vregion->lock);
+	mlxsw_sp_acl_tcam_vgroup_prio_update(vgroup);
 
 	return vchunk;
 
@@ -1066,6 +1088,7 @@ mlxsw_sp_acl_tcam_vchunk_destroy(struct mlxsw_sp *mlxsw_sp,
 			       mlxsw_sp_acl_tcam_vchunk_ht_params);
 	mlxsw_sp_acl_tcam_vregion_put(mlxsw_sp, vchunk->vregion);
 	kfree(vchunk);
+	mlxsw_sp_acl_tcam_vgroup_prio_update(vgroup);
 }
 
 static struct mlxsw_sp_acl_tcam_vchunk *
@@ -1582,14 +1605,17 @@ static int
 mlxsw_sp_acl_tcam_flower_ruleset_add(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_acl_tcam *tcam,
 				     void *ruleset_priv,
-				     struct mlxsw_afk_element_usage *tmplt_elusage)
+				     struct mlxsw_afk_element_usage *tmplt_elusage,
+				     unsigned int *p_min_prio,
+				     unsigned int *p_max_prio)
 {
 	struct mlxsw_sp_acl_tcam_flower_ruleset *ruleset = ruleset_priv;
 
 	return mlxsw_sp_acl_tcam_vgroup_add(mlxsw_sp, tcam, &ruleset->vgroup,
 					    mlxsw_sp_acl_tcam_patterns,
 					    MLXSW_SP_ACL_TCAM_PATTERNS_COUNT,
-					    tmplt_elusage, true);
+					    tmplt_elusage, true,
+					    p_min_prio, p_max_prio);
 }
 
 static void
@@ -1698,7 +1724,9 @@ static int
 mlxsw_sp_acl_tcam_mr_ruleset_add(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_acl_tcam *tcam,
 				 void *ruleset_priv,
-				 struct mlxsw_afk_element_usage *tmplt_elusage)
+				 struct mlxsw_afk_element_usage *tmplt_elusage,
+				 unsigned int *p_min_prio,
+				 unsigned int *p_max_prio)
 {
 	struct mlxsw_sp_acl_tcam_mr_ruleset *ruleset = ruleset_priv;
 	int err;
@@ -1706,7 +1734,8 @@ mlxsw_sp_acl_tcam_mr_ruleset_add(struct mlxsw_sp *mlxsw_sp,
 	err = mlxsw_sp_acl_tcam_vgroup_add(mlxsw_sp, tcam, &ruleset->vgroup,
 					   mlxsw_sp_acl_tcam_patterns,
 					   MLXSW_SP_ACL_TCAM_PATTERNS_COUNT,
-					   tmplt_elusage, false);
+					   tmplt_elusage, false,
+					   p_min_prio, p_max_prio);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h
index 96437992b102..a41df10ade9b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h
@@ -42,7 +42,8 @@ struct mlxsw_sp_acl_profile_ops {
 	size_t ruleset_priv_size;
 	int (*ruleset_add)(struct mlxsw_sp *mlxsw_sp,
 			   struct mlxsw_sp_acl_tcam *tcam, void *ruleset_priv,
-			   struct mlxsw_afk_element_usage *tmplt_elusage);
+			   struct mlxsw_afk_element_usage *tmplt_elusage,
+			   unsigned int *p_min_prio, unsigned int *p_max_prio);
 	void (*ruleset_del)(struct mlxsw_sp *mlxsw_sp, void *ruleset_priv);
 	int (*ruleset_bind)(struct mlxsw_sp *mlxsw_sp, void *ruleset_priv,
 			    struct mlxsw_sp_port *mlxsw_sp_port,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 0897ca1967ab..18d22217e435 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -647,3 +647,23 @@ void mlxsw_sp_flower_tmplt_destroy(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_acl_ruleset_put(mlxsw_sp, ruleset);
 	mlxsw_sp_acl_ruleset_put(mlxsw_sp, ruleset);
 }
+
+int mlxsw_sp_flower_prio_get(struct mlxsw_sp *mlxsw_sp,
+			     struct mlxsw_sp_flow_block *block,
+			     u32 chain_index, unsigned int *p_min_prio,
+			     unsigned int *p_max_prio)
+{
+	struct mlxsw_sp_acl_ruleset *ruleset;
+
+	ruleset = mlxsw_sp_acl_ruleset_lookup(mlxsw_sp, block,
+					      chain_index,
+					      MLXSW_SP_ACL_PROFILE_FLOWER);
+	if (IS_ERR(ruleset))
+		/* In case there are no flower rules, the caller
+		 * receives -ENOENT to indicate there is no need
+		 * to check the priorities.
+		 */
+		return PTR_ERR(ruleset);
+	mlxsw_sp_acl_ruleset_prio_get(ruleset, p_min_prio, p_max_prio);
+	return 0;
+}
-- 
2.26.2

