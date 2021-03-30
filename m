Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1B934E327
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 10:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhC3IbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 04:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhC3Ia5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 04:30:57 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD52EC061762
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 01:30:56 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id s2so11299860qtx.10
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 01:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LsWaZUfJ4RjwBcPSKE+qaZf7I62pJkEkWeWZxNa11nU=;
        b=iyCL601Nw4wlzx0ZDvcF9C5X1bn773NwDZsctt7skNNKr3ijpr3y9UCHcxiYSt7/qJ
         YNJ0uBxVHeGQU8X5ex52OLo6dbINGPeYrqe1wZP/wluqYHfeChMr9lwqq+P3um+RcKhg
         72mthqeOaUOVRJu5SODPN3qfulLjwEd+WsyA0orOo3F0w8sEN9XGvDiGM4NCyfTvRDyy
         SRZqiD+VyOmPl1UoGLfV4DAllEnv7+/cK+lVW/a8K2ZIKQKdYwi7UFXsrWGLwidmoHHP
         KZH3A6/eBH2cG2WO54UpTCLkmqSKCPtAhfY5+tTnsXhZmdXnEAD65XHURmrAHRCyZYBo
         yVqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LsWaZUfJ4RjwBcPSKE+qaZf7I62pJkEkWeWZxNa11nU=;
        b=WlJd5UvGs3ru/LdPW26nJU7KTxKgyxuMZ6i1N4MiC+uIeiNMQ5K4YExI33Ui4zWSHe
         60ljCbdGIdZ7hZoLkhUOakas05m0+WFN6JXIMUjr0IWkoInexmZ+/8Fxfd+6C625bjii
         fG83D+vcs5hOv0uSWCd4u6+Fop+1r1F0gTtzf4ynYmnIbdshVqrnMajo9GpG1Jqw2F0y
         gTrygwEmhrpznCC1fHOLetgEvVijHSPKfiE06m32saqmZ8Pcad3I4Kublp7H3PflPhnE
         RPCqZIGPeOsr0NcCMUhxZPtSsUjhAdkY8ydOkJr/xUq7qKoLIDfq315flFnhWZk78/ET
         77xA==
X-Gm-Message-State: AOAM5309vzeVItN+jt4mbq04xO6C8uJ6fmBw3sI6BuWye64aMXX5nOzU
        SIM7tSl5C+WuOIzfi2WiHR/4fg==
X-Google-Smtp-Source: ABdhPJzfKnKz4+34hkKg8pgo8PWVuR6OYKd0UjJoaGhH9no0yNz829A6OjnyT76H/7+ttDK8QOyTsg==
X-Received: by 2002:aed:2943:: with SMTP id s61mr26251159qtd.5.1617093055913;
        Tue, 30 Mar 2021 01:30:55 -0700 (PDT)
Received: from madeliefje.horms.nl.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id s28sm15203750qkj.73.2021.03.30.01.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 01:30:55 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net] nfp: flower: ignore duplicate merge hints from FW
Date:   Tue, 30 Mar 2021 10:30:23 +0200
Message-Id: <20210330083023.32495-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

A merge hint message needs some time to process before the merged
flow actually reaches the firmware, during which we may get duplicate
merge hints if there're more than one packet that hit the pre-merged
flow. And processing duplicate merge hints will cost extra host_ctx's
which are a limited resource.

Avoid the duplicate merge by using hash table to store the sub_flows
to be merged.

Fixes: 8af56f40e53b ("nfp: flower: offload merge flows")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 .../net/ethernet/netronome/nfp/flower/main.h  |  8 ++++
 .../ethernet/netronome/nfp/flower/metadata.c  | 16 ++++++-
 .../ethernet/netronome/nfp/flower/offload.c   | 48 ++++++++++++++++++-
 3 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index caf12eec9945..56833a41f3d2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -190,6 +190,7 @@ struct nfp_fl_internal_ports {
  * @qos_rate_limiters:	Current active qos rate limiters
  * @qos_stats_lock:	Lock on qos stats updates
  * @pre_tun_rule_cnt:	Number of pre-tunnel rules offloaded
+ * @merge_table:	Hash table to store merged flows
  */
 struct nfp_flower_priv {
 	struct nfp_app *app;
@@ -223,6 +224,7 @@ struct nfp_flower_priv {
 	unsigned int qos_rate_limiters;
 	spinlock_t qos_stats_lock; /* Protect the qos stats */
 	int pre_tun_rule_cnt;
+	struct rhashtable merge_table;
 };
 
 /**
@@ -350,6 +352,12 @@ struct nfp_fl_payload_link {
 };
 
 extern const struct rhashtable_params nfp_flower_table_params;
+extern const struct rhashtable_params merge_table_params;
+
+struct nfp_merge_info {
+	u64 parent_ctx;
+	struct rhash_head ht_node;
+};
 
 struct nfp_fl_stats_frame {
 	__be32 stats_con_id;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index aa06fcb38f8b..327bb56b3ef5 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -490,6 +490,12 @@ const struct rhashtable_params nfp_flower_table_params = {
 	.automatic_shrinking	= true,
 };
 
+const struct rhashtable_params merge_table_params = {
+	.key_offset	= offsetof(struct nfp_merge_info, parent_ctx),
+	.head_offset	= offsetof(struct nfp_merge_info, ht_node),
+	.key_len	= sizeof(u64),
+};
+
 int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 			     unsigned int host_num_mems)
 {
@@ -506,6 +512,10 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 	if (err)
 		goto err_free_flow_table;
 
+	err = rhashtable_init(&priv->merge_table, &merge_table_params);
+	if (err)
+		goto err_free_stats_ctx_table;
+
 	get_random_bytes(&priv->mask_id_seed, sizeof(priv->mask_id_seed));
 
 	/* Init ring buffer and unallocated mask_ids. */
@@ -513,7 +523,7 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 		kmalloc_array(NFP_FLOWER_MASK_ENTRY_RS,
 			      NFP_FLOWER_MASK_ELEMENT_RS, GFP_KERNEL);
 	if (!priv->mask_ids.mask_id_free_list.buf)
-		goto err_free_stats_ctx_table;
+		goto err_free_merge_table;
 
 	priv->mask_ids.init_unallocated = NFP_FLOWER_MASK_ENTRY_RS - 1;
 
@@ -550,6 +560,8 @@ int nfp_flower_metadata_init(struct nfp_app *app, u64 host_ctx_count,
 	kfree(priv->mask_ids.last_used);
 err_free_mask_id:
 	kfree(priv->mask_ids.mask_id_free_list.buf);
+err_free_merge_table:
+	rhashtable_destroy(&priv->merge_table);
 err_free_stats_ctx_table:
 	rhashtable_destroy(&priv->stats_ctx_table);
 err_free_flow_table:
@@ -568,6 +580,8 @@ void nfp_flower_metadata_cleanup(struct nfp_app *app)
 				    nfp_check_rhashtable_empty, NULL);
 	rhashtable_free_and_destroy(&priv->stats_ctx_table,
 				    nfp_check_rhashtable_empty, NULL);
+	rhashtable_free_and_destroy(&priv->merge_table,
+				    nfp_check_rhashtable_empty, NULL);
 	kvfree(priv->stats);
 	kfree(priv->mask_ids.mask_id_free_list.buf);
 	kfree(priv->mask_ids.last_used);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index d72225d64a75..e95969c462e4 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1009,6 +1009,8 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 	struct netlink_ext_ack *extack = NULL;
 	struct nfp_fl_payload *merge_flow;
 	struct nfp_fl_key_ls merge_key_ls;
+	struct nfp_merge_info *merge_info;
+	u64 parent_ctx = 0;
 	int err;
 
 	ASSERT_RTNL();
@@ -1019,6 +1021,15 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 	    nfp_flower_is_merge_flow(sub_flow2))
 		return -EINVAL;
 
+	/* check if the two flows are already merged */
+	parent_ctx = (u64)(be32_to_cpu(sub_flow1->meta.host_ctx_id)) << 32;
+	parent_ctx |= (u64)(be32_to_cpu(sub_flow2->meta.host_ctx_id));
+	if (rhashtable_lookup_fast(&priv->merge_table,
+				   &parent_ctx, merge_table_params)) {
+		nfp_flower_cmsg_warn(app, "The two flows are already merged.\n");
+		return 0;
+	}
+
 	err = nfp_flower_can_merge(sub_flow1, sub_flow2);
 	if (err)
 		return err;
@@ -1060,16 +1071,33 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 	if (err)
 		goto err_release_metadata;
 
+	merge_info = kmalloc(sizeof(*merge_info), GFP_KERNEL);
+	if (!merge_info) {
+		err = -ENOMEM;
+		goto err_remove_rhash;
+	}
+	merge_info->parent_ctx = parent_ctx;
+	err = rhashtable_insert_fast(&priv->merge_table, &merge_info->ht_node,
+				     merge_table_params);
+	if (err)
+		goto err_destroy_merge_info;
+
 	err = nfp_flower_xmit_flow(app, merge_flow,
 				   NFP_FLOWER_CMSG_TYPE_FLOW_MOD);
 	if (err)
-		goto err_remove_rhash;
+		goto err_remove_merge_info;
 
 	merge_flow->in_hw = true;
 	sub_flow1->in_hw = false;
 
 	return 0;
 
+err_remove_merge_info:
+	WARN_ON_ONCE(rhashtable_remove_fast(&priv->merge_table,
+					    &merge_info->ht_node,
+					    merge_table_params));
+err_destroy_merge_info:
+	kfree(merge_info);
 err_remove_rhash:
 	WARN_ON_ONCE(rhashtable_remove_fast(&priv->flow_table,
 					    &merge_flow->fl_node,
@@ -1359,7 +1387,9 @@ nfp_flower_remove_merge_flow(struct nfp_app *app,
 {
 	struct nfp_flower_priv *priv = app->priv;
 	struct nfp_fl_payload_link *link, *temp;
+	struct nfp_merge_info *merge_info;
 	struct nfp_fl_payload *origin;
+	u64 parent_ctx = 0;
 	bool mod = false;
 	int err;
 
@@ -1396,8 +1426,22 @@ nfp_flower_remove_merge_flow(struct nfp_app *app,
 err_free_links:
 	/* Clean any links connected with the merged flow. */
 	list_for_each_entry_safe(link, temp, &merge_flow->linked_flows,
-				 merge_flow.list)
+				 merge_flow.list) {
+		u32 ctx_id = be32_to_cpu(link->sub_flow.flow->meta.host_ctx_id);
+
+		parent_ctx = (parent_ctx << 32) | (u64)(ctx_id);
 		nfp_flower_unlink_flow(link);
+	}
+
+	merge_info = rhashtable_lookup_fast(&priv->merge_table,
+					    &parent_ctx,
+					    merge_table_params);
+	if (merge_info) {
+		WARN_ON_ONCE(rhashtable_remove_fast(&priv->merge_table,
+						    &merge_info->ht_node,
+						    merge_table_params));
+		kfree(merge_info);
+	}
 
 	kfree(merge_flow->action_data);
 	kfree(merge_flow->mask_data);
-- 
2.20.1

