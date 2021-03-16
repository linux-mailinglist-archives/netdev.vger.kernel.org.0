Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD0733D65B
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237675AbhCPPEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:04:10 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38807 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233179AbhCPPEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:04:02 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 391735C0134;
        Tue, 16 Mar 2021 11:04:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 16 Mar 2021 11:04:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=d/JVqrHnA5EfrcKmX+hQtUIqBUAg+orOdhHggmPCa2Q=; b=eJ7J3IuF
        71iXEek7xSIRD+gkx30XpHNFUlTLCGf/16bekbWM0Ze2+3ni0t5HPqR34Q07f0xI
        KXsU1Y4wlaQLQ6HXlPDxURjgTVRHkeMORUjPRTOgkAtk4CMt9r/jv7eBCXZkGOa1
        dZ5tKEdOWm6fJAbWvIf9UcUPyXt/wCs5BbjZ+Z46cnsch1hyrELRBw1p+tcw/bAL
        gCI6CgUPjrJ0r8sEuyaWwcfbffE9gqO1JsIXV6SjdXMNrFoN6mVmnH8D5b3iKGPL
        0E4z5/6SK/KowuGvNCHSOyBsQCw1Vf+jjGGXK4Rs7igQx1fZe9Du3q67N7r71zak
        3UTfgRbDKtaAAA==
X-ME-Sender: <xms:4shQYEWeOALEZnj2wb7M6-mEqmbx-m0AbURb2dslcu1xAJiYArPBVA>
    <xme:4shQYIl939UOkaokPDnDpmh5eCJ81E3waayIeGgGRLongXO65Rpjm6cT5PFcGfZsw
    oKGEPWltf-YYn4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefvddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:4shQYIbhnVraWkw3y8lFgcZw-Qi5V05l3ye9B343VVMThHajuV6NvA>
    <xmx:4shQYDXWQs6ImeZlldc_5uzMZUFkOVdfUFJZnBHuFUL8c4BPHEVFnw>
    <xmx:4shQYOmWCIpSQpl8vObPqbJoyWBNpd-pkT9_nv2bm2hk3eCruMcavQ>
    <xmx:4shQYFuBBTbLeYqMj-fjg1npslPa6R_0DrkjBjJYp13bdcoBsKEa3A>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id C861A1080068;
        Tue, 16 Mar 2021 11:03:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/10] mlxsw: spectrum_matchall: Propagate extack further
Date:   Tue, 16 Mar 2021 17:02:54 +0200
Message-Id: <20210316150303.2868588-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316150303.2868588-1-idosch@idosch.org>
References: <20210316150303.2868588-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Due to the differences between Spectrum-1 and later ASICs, some of the
checks currently performed at the common code (where extack is
available) will need to be pushed to the per-ASIC operations.

As a preparation, propagate extack further to maintain proper error
reporting.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  6 +-
 .../ethernet/mellanox/mlxsw/spectrum_flow.c   |  2 +-
 .../mellanox/mlxsw/spectrum_matchall.c        | 57 ++++++++++++-------
 3 files changed, 43 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 0082f70daff3..650294d64237 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1035,7 +1035,8 @@ extern const struct mlxsw_afk_ops mlxsw_sp2_afk_ops;
 /* spectrum_matchall.c */
 struct mlxsw_sp_mall_ops {
 	int (*sample_add)(struct mlxsw_sp *mlxsw_sp,
-			  struct mlxsw_sp_port *mlxsw_sp_port, u32 rate);
+			  struct mlxsw_sp_port *mlxsw_sp_port, u32 rate,
+			  struct netlink_ext_ack *extack);
 	void (*sample_del)(struct mlxsw_sp *mlxsw_sp,
 			   struct mlxsw_sp_port *mlxsw_sp_port);
 };
@@ -1078,7 +1079,8 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp *mlxsw_sp,
 void mlxsw_sp_mall_destroy(struct mlxsw_sp_flow_block *block,
 			   struct tc_cls_matchall_offload *f);
 int mlxsw_sp_mall_port_bind(struct mlxsw_sp_flow_block *block,
-			    struct mlxsw_sp_port *mlxsw_sp_port);
+			    struct mlxsw_sp_port *mlxsw_sp_port,
+			    struct netlink_ext_ack *extack);
 void mlxsw_sp_mall_port_unbind(struct mlxsw_sp_flow_block *block,
 			       struct mlxsw_sp_port *mlxsw_sp_port);
 int mlxsw_sp_mall_prio_get(struct mlxsw_sp_flow_block *block, u32 chain_index,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
index 0456cda33808..9e50c823a354 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
@@ -71,7 +71,7 @@ static int mlxsw_sp_flow_block_bind(struct mlxsw_sp *mlxsw_sp,
 		return -EOPNOTSUPP;
 	}
 
-	err = mlxsw_sp_mall_port_bind(block, mlxsw_sp_port);
+	err = mlxsw_sp_mall_port_bind(block, mlxsw_sp_port, extack);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index 841a2de37f36..d44a4c4b57f8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -24,7 +24,8 @@ mlxsw_sp_mall_entry_find(struct mlxsw_sp_flow_block *block, unsigned long cookie
 
 static int
 mlxsw_sp_mall_port_mirror_add(struct mlxsw_sp_port *mlxsw_sp_port,
-			      struct mlxsw_sp_mall_entry *mall_entry)
+			      struct mlxsw_sp_mall_entry *mall_entry,
+			      struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_span_agent_parms agent_parms = {};
@@ -33,20 +34,24 @@ mlxsw_sp_mall_port_mirror_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	int err;
 
 	if (!mall_entry->mirror.to_dev) {
-		netdev_err(mlxsw_sp_port->dev, "Could not find requested device\n");
+		NL_SET_ERR_MSG(extack, "Could not find requested device");
 		return -EINVAL;
 	}
 
 	agent_parms.to_dev = mall_entry->mirror.to_dev;
 	err = mlxsw_sp_span_agent_get(mlxsw_sp, &mall_entry->mirror.span_id,
 				      &agent_parms);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG(extack, "Failed to get SPAN agent");
 		return err;
+	}
 
 	err = mlxsw_sp_span_analyzed_port_get(mlxsw_sp_port,
 					      mall_entry->ingress);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG(extack, "Failed to get analyzed port");
 		goto err_analyzed_port_get;
+	}
 
 	trigger = mall_entry->ingress ? MLXSW_SP_SPAN_TRIGGER_INGRESS :
 					MLXSW_SP_SPAN_TRIGGER_EGRESS;
@@ -54,8 +59,10 @@ mlxsw_sp_mall_port_mirror_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	parms.probability_rate = 1;
 	err = mlxsw_sp_span_agent_bind(mlxsw_sp, trigger, mlxsw_sp_port,
 				       &parms);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG(extack, "Failed to bind SPAN agent");
 		goto err_agent_bind;
+	}
 
 	return 0;
 
@@ -94,19 +101,20 @@ static int mlxsw_sp_mall_port_sample_set(struct mlxsw_sp_port *mlxsw_sp_port,
 
 static int
 mlxsw_sp_mall_port_sample_add(struct mlxsw_sp_port *mlxsw_sp_port,
-			      struct mlxsw_sp_mall_entry *mall_entry)
+			      struct mlxsw_sp_mall_entry *mall_entry,
+			      struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	int err;
 
 	if (rtnl_dereference(mlxsw_sp_port->sample)) {
-		netdev_err(mlxsw_sp_port->dev, "sample already active\n");
+		NL_SET_ERR_MSG(extack, "Sampling already active on port");
 		return -EEXIST;
 	}
 	rcu_assign_pointer(mlxsw_sp_port->sample, &mall_entry->sample);
 
 	err = mlxsw_sp->mall_ops->sample_add(mlxsw_sp, mlxsw_sp_port,
-					     mall_entry->sample.rate);
+					     mall_entry->sample.rate, extack);
 	if (err)
 		goto err_port_sample_set;
 	return 0;
@@ -130,13 +138,16 @@ mlxsw_sp_mall_port_sample_del(struct mlxsw_sp_port *mlxsw_sp_port)
 
 static int
 mlxsw_sp_mall_port_rule_add(struct mlxsw_sp_port *mlxsw_sp_port,
-			    struct mlxsw_sp_mall_entry *mall_entry)
+			    struct mlxsw_sp_mall_entry *mall_entry,
+			    struct netlink_ext_ack *extack)
 {
 	switch (mall_entry->type) {
 	case MLXSW_SP_MALL_ACTION_TYPE_MIRROR:
-		return mlxsw_sp_mall_port_mirror_add(mlxsw_sp_port, mall_entry);
+		return mlxsw_sp_mall_port_mirror_add(mlxsw_sp_port, mall_entry,
+						     extack);
 	case MLXSW_SP_MALL_ACTION_TYPE_SAMPLE:
-		return mlxsw_sp_mall_port_sample_add(mlxsw_sp_port, mall_entry);
+		return mlxsw_sp_mall_port_sample_add(mlxsw_sp_port, mall_entry,
+						     extack);
 	default:
 		WARN_ON(1);
 		return -EINVAL;
@@ -270,7 +281,7 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp *mlxsw_sp,
 
 	list_for_each_entry(binding, &block->binding_list, list) {
 		err = mlxsw_sp_mall_port_rule_add(binding->mlxsw_sp_port,
-						  mall_entry);
+						  mall_entry, f->common.extack);
 		if (err)
 			goto rollback;
 	}
@@ -318,13 +329,15 @@ void mlxsw_sp_mall_destroy(struct mlxsw_sp_flow_block *block,
 }
 
 int mlxsw_sp_mall_port_bind(struct mlxsw_sp_flow_block *block,
-			    struct mlxsw_sp_port *mlxsw_sp_port)
+			    struct mlxsw_sp_port *mlxsw_sp_port,
+			    struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_mall_entry *mall_entry;
 	int err;
 
 	list_for_each_entry(mall_entry, &block->mall.list, list) {
-		err = mlxsw_sp_mall_port_rule_add(mlxsw_sp_port, mall_entry);
+		err = mlxsw_sp_mall_port_rule_add(mlxsw_sp_port, mall_entry,
+						  extack);
 		if (err)
 			goto rollback;
 	}
@@ -362,7 +375,7 @@ int mlxsw_sp_mall_prio_get(struct mlxsw_sp_flow_block *block, u32 chain_index,
 
 static int mlxsw_sp1_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_port *mlxsw_sp_port,
-				     u32 rate)
+				     u32 rate, struct netlink_ext_ack *extack)
 {
 	return mlxsw_sp_mall_port_sample_set(mlxsw_sp_port, true, rate);
 }
@@ -380,7 +393,7 @@ const struct mlxsw_sp_mall_ops mlxsw_sp1_mall_ops = {
 
 static int mlxsw_sp2_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_port *mlxsw_sp_port,
-				     u32 rate)
+				     u32 rate, struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_span_trigger_parms trigger_parms = {};
 	struct mlxsw_sp_span_agent_parms agent_parms = {
@@ -393,19 +406,25 @@ static int mlxsw_sp2_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 	sample = rtnl_dereference(mlxsw_sp_port->sample);
 
 	err = mlxsw_sp_span_agent_get(mlxsw_sp, &sample->span_id, &agent_parms);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG(extack, "Failed to get SPAN agent");
 		return err;
+	}
 
 	err = mlxsw_sp_span_analyzed_port_get(mlxsw_sp_port, true);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG(extack, "Failed to get analyzed port");
 		goto err_analyzed_port_get;
+	}
 
 	trigger_parms.span_id = sample->span_id;
 	trigger_parms.probability_rate = rate;
 	err = mlxsw_sp_span_agent_bind(mlxsw_sp, MLXSW_SP_SPAN_TRIGGER_INGRESS,
 				       mlxsw_sp_port, &trigger_parms);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG(extack, "Failed to bind SPAN agent");
 		goto err_agent_bind;
+	}
 
 	return 0;
 
-- 
2.29.2

