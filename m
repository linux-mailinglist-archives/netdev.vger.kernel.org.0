Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34CE44F9E01
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 22:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239388AbiDHUKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 16:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239385AbiDHUKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 16:10:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA9703F8BF
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 13:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649448524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z16KGp6dL1DI6ZFbSWh81i95g5hnk/Vbhv6HN69iwfs=;
        b=LoH706GcszXoIWVhUCbYxaBSJFghD3KvH3nR7FWMMpgezRtb1qAkdrFRBXjJyn+KjfEuzj
        DFF3LxlOxmbHPpt/AV3TLemaDQ9CVPBFWnETv7+n0Bs807u//0eLotx+eMBPTn0TPVdKou
        q4cZrVo9OuKY21Y3pdPC1FlWippcBGM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-128-M2jocJZUO8y8Zm-_qKFqwQ-1; Fri, 08 Apr 2022 16:08:43 -0400
X-MC-Unique: M2jocJZUO8y8Zm-_qKFqwQ-1
Received: by mail-wm1-f70.google.com with SMTP id bg8-20020a05600c3c8800b0038e6a989925so2646013wmb.3
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 13:08:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z16KGp6dL1DI6ZFbSWh81i95g5hnk/Vbhv6HN69iwfs=;
        b=8QO9lOrK78/AuIsRkezaAy7fuspLyIjpW8AcFpc53CRIk5EOYkVv4lF//B19fxJdPn
         BiEY33zpadMWhvhiyqvp/wjsjtYdfStWNc7bEJu+pLVHzsUl9MHcbKefF5W+/iU+l/FD
         11hCTZ1vev2xRJlU1xiaJyfvsCsczKzjwU9jFvuvt/rT10q8Gw+KCvFz+h4aARHYaN9m
         D8aVZqrz5TF1+xry2owLpulKwEiyE95dB1UlOqLbELc4/nZMqFQtRMDxaqzAdne7f86r
         PIxPoXY7ODLRRPOyYNKHfIfAoIh9rV98auKcM5fUkLrRbZn9ODP0e5rB+H+n/7mc7qF0
         Xa4A==
X-Gm-Message-State: AOAM5317Aw77nhbHMxwXFXQ13VVcK9dQyDu6VN2qelPYvZnhEvQ7urV7
        5lwesm6+l472p7op5LlYgort1lZ0q03hugVbXV0yQsw7c+PJeZvzkMU2JdhgNc0XybQAG2QrDN8
        FFHrYR5rT/YJI67Gk
X-Received: by 2002:adf:d081:0:b0:203:e209:7def with SMTP id y1-20020adfd081000000b00203e2097defmr15683072wrh.388.1649448522550;
        Fri, 08 Apr 2022 13:08:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwTKx+xAB226Xwbx3Uww2ZbFsKJbIGkO2b4Q0D4JJUoWPjxg4FJTcM1btE8XzXqtAcYELHQQ==
X-Received: by 2002:adf:d081:0:b0:203:e209:7def with SMTP id y1-20020adfd081000000b00203e2097defmr15683058wrh.388.1649448522383;
        Fri, 08 Apr 2022 13:08:42 -0700 (PDT)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id 3-20020a5d47a3000000b0020412ba45f6sm24373148wrb.8.2022.04.08.13.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 13:08:41 -0700 (PDT)
Date:   Fri, 8 Apr 2022 22:08:40 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next 2/5] ipv4: Use dscp_t in struct
 fib_entry_notifier_info
Message-ID: <f69f4e262e502ff97ace5e13842cf7e53cbd7952.1649445279.git.gnault@redhat.com>
References: <cover.1649445279.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1649445279.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new dscp_t type to replace the tos field of struct
fib_entry_notifier_info. This ensures ECN bits are ignored and makes it
compatible with the dscp field of struct fib_rt_info.

This also allows sparse to flag potential incorrect uses of DSCP and
ECN bits.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_router.c | 6 +++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c   | 6 +++---
 drivers/net/netdevsim/fib.c                             | 4 ++--
 include/net/ip_fib.h                                    | 2 +-
 net/ipv4/fib_trie.c                                     | 4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 99d60c9ae54d..a6b608ade2b9 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -89,7 +89,7 @@ prestera_kern_fib_cache_destroy(struct prestera_switch *sw,
 static struct prestera_kern_fib_cache *
 prestera_kern_fib_cache_create(struct prestera_switch *sw,
 			       struct prestera_kern_fib_cache_key *key,
-			       struct fib_info *fi, u8 tos, u8 type)
+			       struct fib_info *fi, dscp_t dscp, u8 type)
 {
 	struct prestera_kern_fib_cache *fib_cache;
 	int err;
@@ -101,7 +101,7 @@ prestera_kern_fib_cache_create(struct prestera_switch *sw,
 	memcpy(&fib_cache->key, key, sizeof(*key));
 	fib_info_hold(fi);
 	fib_cache->fi = fi;
-	fib_cache->kern_tos = tos;
+	fib_cache->kern_tos = inet_dscp_to_dsfield(dscp);
 	fib_cache->kern_type = type;
 
 	err = rhashtable_insert_fast(&sw->router->kern_fib_cache_ht,
@@ -306,7 +306,7 @@ prestera_k_arb_fib_evt(struct prestera_switch *sw,
 	if (replace) {
 		fib_cache = prestera_kern_fib_cache_create(sw, &fc_key,
 							   fen_info->fi,
-							   fen_info->tos,
+							   fen_info->dscp,
 							   fen_info->type);
 		if (!fib_cache) {
 			dev_err(sw->dev->dev, "fib_cache == NULL");
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 596516ba73c1..1c451d648302 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5621,7 +5621,7 @@ mlxsw_sp_fib4_offload_failed_flag_set(struct mlxsw_sp *mlxsw_sp,
 	fri.tb_id = fen_info->tb_id;
 	fri.dst = cpu_to_be32(*p_dst);
 	fri.dst_len = fen_info->dst_len;
-	fri.dscp = inet_dsfield_to_dscp(fen_info->tos);
+	fri.dscp = fen_info->dscp;
 	fri.type = fen_info->type;
 	fri.offload = false;
 	fri.trap = false;
@@ -6251,7 +6251,7 @@ mlxsw_sp_fib4_entry_create(struct mlxsw_sp *mlxsw_sp,
 	fib_info_hold(fib4_entry->fi);
 	fib4_entry->tb_id = fen_info->tb_id;
 	fib4_entry->type = fen_info->type;
-	fib4_entry->tos = fen_info->tos;
+	fib4_entry->tos = inet_dscp_to_dsfield(fen_info->dscp);
 
 	fib_entry->fib_node = fib_node;
 
@@ -6305,7 +6305,7 @@ mlxsw_sp_fib4_entry_lookup(struct mlxsw_sp *mlxsw_sp,
 	fib4_entry = container_of(fib_node->fib_entry,
 				  struct mlxsw_sp_fib4_entry, common);
 	if (fib4_entry->tb_id == fen_info->tb_id &&
-	    fib4_entry->tos == fen_info->tos &&
+	    fib4_entry->tos == inet_dscp_to_dsfield(fen_info->dscp) &&
 	    fib4_entry->type == fen_info->type &&
 	    fib4_entry->fi == fen_info->fi)
 		return fib4_entry;
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 31e73709aac5..fb9af26122ac 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -284,7 +284,7 @@ nsim_fib4_rt_create(struct nsim_fib_data *data,
 
 	fib4_rt->fi = fen_info->fi;
 	fib_info_hold(fib4_rt->fi);
-	fib4_rt->tos = fen_info->tos;
+	fib4_rt->tos = inet_dscp_to_dsfield(fen_info->dscp);
 	fib4_rt->type = fen_info->type;
 
 	return fib4_rt;
@@ -323,7 +323,7 @@ nsim_fib4_rt_offload_failed_flag_set(struct net *net,
 	fri.tb_id = fen_info->tb_id;
 	fri.dst = cpu_to_be32(*p_dst);
 	fri.dst_len = fen_info->dst_len;
-	fri.dscp = inet_dsfield_to_dscp(fen_info->tos);
+	fri.dscp = fen_info->dscp;
 	fri.type = fen_info->type;
 	fri.offload = false;
 	fri.trap = false;
diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index f08ba531ac08..a378eff827c7 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -225,7 +225,7 @@ struct fib_entry_notifier_info {
 	u32 dst;
 	int dst_len;
 	struct fib_info *fi;
-	u8 tos;
+	dscp_t dscp;
 	u8 type;
 	u32 tb_id;
 };
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index e96f02f0ab93..1f7f25532fa1 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -82,7 +82,7 @@ static int call_fib_entry_notifier(struct notifier_block *nb,
 		.dst = dst,
 		.dst_len = dst_len,
 		.fi = fa->fa_info,
-		.tos = inet_dscp_to_dsfield(fa->fa_dscp),
+		.dscp = fa->fa_dscp,
 		.type = fa->fa_type,
 		.tb_id = fa->tb_id,
 	};
@@ -99,7 +99,7 @@ static int call_fib_entry_notifiers(struct net *net,
 		.dst = dst,
 		.dst_len = dst_len,
 		.fi = fa->fa_info,
-		.tos = inet_dscp_to_dsfield(fa->fa_dscp),
+		.dscp = fa->fa_dscp,
 		.type = fa->fa_type,
 		.tb_id = fa->tb_id,
 	};
-- 
2.21.3

