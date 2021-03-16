Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3E433D66E
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237750AbhCPPE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:04:56 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54497 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237684AbhCPPER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:04:17 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 858A15C0134;
        Tue, 16 Mar 2021 11:04:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 16 Mar 2021 11:04:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=S2FhAmYE9wYsJ4+nEUxnkEo+U7MxMnZXs2MInxEqs+k=; b=tzbFRMiX
        DruXnMguMpcwCLW4nAIjNtT5RtegzsvGlgb8qPnILg8O+ka0dyJNsbvItYw45Pj3
        IJziJQrVmntlNaEp63b6rxJ/UIMnIuUtKFHhWI1ibMV5Q9SS+dLrhYBHprSI6BTM
        vXW/1HIqnF+5lYoUlk43Qg2IZXznAHO8xfds3Td9S+NJFjd5xqClzEQJ/jVjlbZm
        /9Tyfj+1WL1+VyXPeeyxm+3TlHIjmNIJXDrDGwi4rcTUbSJaeIb0HAOekS+7G0xH
        2HVdG6p0k3auos44ohzQSINh476u5mJOZPxiQKnRNwYYfxGGXq8Qxeh4DJbRqi+Z
        8bFhuI+qwDIx+w==
X-ME-Sender: <xms:8MhQYBFfxaQG8TNH9gm5gBLnnlQsHsL1Va5bai6U_WUcDmEfnkURew>
    <xme:8MhQYGXcFCVQYu7yhG26qe3kNkHfuV0Mh2PCZxLvvQfV6ajxfZc8FJtyPvCALIOv9
    FVoiYaTOmTTbD8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefvddgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:8MhQYDLtYELlCksVl1FmNHSuezFk5vD3VKYP4rEwXRne98NxNxM_tA>
    <xmx:8MhQYHFWW6NnN_kmze0RQOSyLnMGcmKlwT0ITOXsUJ_pBI8cHhrVug>
    <xmx:8MhQYHUY_YcCTB81joJqndHC0x6T1qVRpoeqyfN0Xiuoi0Zm9DFy-g>
    <xmx:8MhQYNfMBhUai87UambQLcxySvlbeyaCPIFpP8n_azqENDPEWHQoRw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 584DF1080057;
        Tue, 16 Mar 2021 11:04:14 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/10] mlxsw: core_acl_flex_actions: Add mirror sampler action
Date:   Tue, 16 Mar 2021 17:03:00 +0200
Message-Id: <20210316150303.2868588-8-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316150303.2868588-1-idosch@idosch.org>
References: <20210316150303.2868588-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add core functionality required to support mirror sampler action in the
policy engine. The switch driver (e.g., 'mlxsw_spectrum') is required to
implement the sampler_add() / sampler_del() callbacks that perform the
necessary configuration before the sampler action can be installed. The
next patch will implement it for Spectrum-{2,3}, while Spectrum-1 will
return an error, given it is not supported.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 131 ++++++++++++++++++
 .../mellanox/mlxsw/core_acl_flex_actions.h    |  11 ++
 2 files changed, 142 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index 4d699fe98cb6..78d9c0196f2b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -2007,3 +2007,134 @@ int mlxsw_afa_block_append_l4port(struct mlxsw_afa_block *block, bool is_dport,
 	return 0;
 }
 EXPORT_SYMBOL(mlxsw_afa_block_append_l4port);
+
+/* Mirror Sampler Action
+ * ---------------------
+ * The SAMPLER_ACTION is used to mirror packets with a probability (sampling).
+ */
+
+#define MLXSW_AFA_SAMPLER_CODE 0x13
+#define MLXSW_AFA_SAMPLER_SIZE 1
+
+/* afa_sampler_mirror_agent
+ * Mirror (SPAN) agent.
+ */
+MLXSW_ITEM32(afa, sampler, mirror_agent, 0x04, 0, 3);
+
+#define MLXSW_AFA_SAMPLER_RATE_MAX (BIT(24) - 1)
+
+/* afa_sampler_mirror_probability_rate
+ * Mirroring probability.
+ * Valid values are 1 to 2^24 - 1
+ */
+MLXSW_ITEM32(afa, sampler, mirror_probability_rate, 0x08, 0, 24);
+
+static void mlxsw_afa_sampler_pack(char *payload, u8 mirror_agent, u32 rate)
+{
+	mlxsw_afa_sampler_mirror_agent_set(payload, mirror_agent);
+	mlxsw_afa_sampler_mirror_probability_rate_set(payload, rate);
+}
+
+struct mlxsw_afa_sampler {
+	struct mlxsw_afa_resource resource;
+	int span_id;
+	u8 local_port;
+	bool ingress;
+};
+
+static void mlxsw_afa_sampler_destroy(struct mlxsw_afa_block *block,
+				      struct mlxsw_afa_sampler *sampler)
+{
+	mlxsw_afa_resource_del(&sampler->resource);
+	block->afa->ops->sampler_del(block->afa->ops_priv, sampler->local_port,
+				     sampler->span_id, sampler->ingress);
+	kfree(sampler);
+}
+
+static void mlxsw_afa_sampler_destructor(struct mlxsw_afa_block *block,
+					 struct mlxsw_afa_resource *resource)
+{
+	struct mlxsw_afa_sampler *sampler;
+
+	sampler = container_of(resource, struct mlxsw_afa_sampler, resource);
+	mlxsw_afa_sampler_destroy(block, sampler);
+}
+
+static struct mlxsw_afa_sampler *
+mlxsw_afa_sampler_create(struct mlxsw_afa_block *block, u8 local_port,
+			 struct psample_group *psample_group, u32 rate,
+			 u32 trunc_size, bool truncate, bool ingress,
+			 struct netlink_ext_ack *extack)
+{
+	struct mlxsw_afa_sampler *sampler;
+	int err;
+
+	sampler = kzalloc(sizeof(*sampler), GFP_KERNEL);
+	if (!sampler)
+		return ERR_PTR(-ENOMEM);
+
+	err = block->afa->ops->sampler_add(block->afa->ops_priv, local_port,
+					   psample_group, rate, trunc_size,
+					   truncate, ingress, &sampler->span_id,
+					   extack);
+	if (err)
+		goto err_sampler_add;
+
+	sampler->ingress = ingress;
+	sampler->local_port = local_port;
+	sampler->resource.destructor = mlxsw_afa_sampler_destructor;
+	mlxsw_afa_resource_add(block, &sampler->resource);
+	return sampler;
+
+err_sampler_add:
+	kfree(sampler);
+	return ERR_PTR(err);
+}
+
+static int
+mlxsw_afa_block_append_allocated_sampler(struct mlxsw_afa_block *block,
+					 u8 mirror_agent, u32 rate)
+{
+	char *act = mlxsw_afa_block_append_action(block, MLXSW_AFA_SAMPLER_CODE,
+						  MLXSW_AFA_SAMPLER_SIZE);
+
+	if (IS_ERR(act))
+		return PTR_ERR(act);
+	mlxsw_afa_sampler_pack(act, mirror_agent, rate);
+	return 0;
+}
+
+int mlxsw_afa_block_append_sampler(struct mlxsw_afa_block *block, u8 local_port,
+				   struct psample_group *psample_group,
+				   u32 rate, u32 trunc_size, bool truncate,
+				   bool ingress,
+				   struct netlink_ext_ack *extack)
+{
+	struct mlxsw_afa_sampler *sampler;
+	int err;
+
+	if (rate > MLXSW_AFA_SAMPLER_RATE_MAX) {
+		NL_SET_ERR_MSG_MOD(extack, "Sampling rate is too high");
+		return -EINVAL;
+	}
+
+	sampler = mlxsw_afa_sampler_create(block, local_port, psample_group,
+					   rate, trunc_size, truncate, ingress,
+					   extack);
+	if (IS_ERR(sampler))
+		return PTR_ERR(sampler);
+
+	err = mlxsw_afa_block_append_allocated_sampler(block, sampler->span_id,
+						       rate);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot append sampler action");
+		goto err_append_allocated_sampler;
+	}
+
+	return 0;
+
+err_append_allocated_sampler:
+	mlxsw_afa_sampler_destroy(block, sampler);
+	return err;
+}
+EXPORT_SYMBOL(mlxsw_afa_block_append_sampler);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
index b652497b1002..b65bf98eb5ab 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
@@ -30,6 +30,12 @@ struct mlxsw_afa_ops {
 			   u16 *p_policer_index,
 			   struct netlink_ext_ack *extack);
 	void (*policer_del)(void *priv, u16 policer_index);
+	int (*sampler_add)(void *priv, u8 local_port,
+			   struct psample_group *psample_group, u32 rate,
+			   u32 trunc_size, bool truncate, bool ingress,
+			   int *p_span_id, struct netlink_ext_ack *extack);
+	void (*sampler_del)(void *priv, u8 local_port, int span_id,
+			    bool ingress);
 	bool dummy_first_set;
 };
 
@@ -92,5 +98,10 @@ int mlxsw_afa_block_append_police(struct mlxsw_afa_block *block,
 				  u32 fa_index, u64 rate_bytes_ps, u32 burst,
 				  u16 *p_policer_index,
 				  struct netlink_ext_ack *extack);
+int mlxsw_afa_block_append_sampler(struct mlxsw_afa_block *block, u8 local_port,
+				   struct psample_group *psample_group,
+				   u32 rate, u32 trunc_size, bool truncate,
+				   bool ingress,
+				   struct netlink_ext_ack *extack);
 
 #endif
-- 
2.29.2

