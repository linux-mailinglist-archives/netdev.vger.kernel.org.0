Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9614A1FC96B
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 11:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgFQJD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 05:03:59 -0400
Received: from correo.us.es ([193.147.175.20]:42074 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgFQJD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 05:03:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A4B671F0CE5
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:03:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8DF20DA84D
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:03:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 77082DA85D; Wed, 17 Jun 2020 11:03:55 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2661DA791;
        Wed, 17 Jun 2020 11:03:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 17 Jun 2020 11:03:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B114642EE395;
        Wed, 17 Jun 2020 11:03:52 +0200 (CEST)
Date:   Wed, 17 Jun 2020 11:03:52 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, vladbu@mellanox.com
Subject: Re: [PATCH net v3 2/4] flow_offload: fix incorrect cb_priv check for
 flow_block_cb
Message-ID: <20200617090352.GA3113@salvia>
References: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
 <1592277580-5524-3-git-send-email-wenxu@ucloud.cn>
 <20200616201348.GB26932@salvia>
 <7d21a0b5-9f90-7f66-ae7a-80b0d9bbf2a1@ucloud.cn>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7d21a0b5-9f90-7f66-ae7a-80b0d9bbf2a1@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jun 17, 2020 at 10:42:19AM +0800, wenxu wrote:
[...]
> >> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> >> index ef7f6bc..042c285 100644
> >> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> >> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> >> @@ -1918,6 +1918,7 @@ static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
> >>  
> >>  		flow_block_cb_add(block_cb, f);
> >>  		list_add_tail(&block_cb->driver_list, &bnxt_block_cb_list);
> >> +		block_cb->indr.cb_priv = bp;
> > cb_indent ?
> >
> > Why are you splitting the fix in multiple patches? This makes it
> > harder to review.
> >
> > I think patch 1/4, 2/4 and 4/4 belong to the same logical change?
> > Collapse them.
> 
> I think patch 1/4, 2/4, 4/4 are different bugs， Although they are all in the new indirect
> flow_block infrastructure.
> 
> patch1 fix the miss cleanup for flow_block_cb of flowtable
> 
> patch2 fix the incorrect check the cb_priv of flow_block_cb
> 
> patch4 fix the miss driver_list del in the cleanup callback
> 
> So maybe make them alone is better?

Maybe.

I'm attaching the collapsed patch for preview.

        10 files changed, 21 insertions(+), 15 deletions(-)

This one single collapsed patch is small.

And it looks like it is part of the same logic fix for the .cleanup
path? You had to update three aspects to make the cleanup path work.

3/4 is a different code path, leaving it standalone makes sense to me,
on top of this one probably.

This is just a proposal.

Thank you.

--k+w/mQv8wyuph6w0
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-net-flow_offload-fix-flow_indr_dev_unregister-path.patch"

From 8a17ca6fa7852e359aa5fad01ecdda4f5ae33eeb Mon Sep 17 00:00:00 2001
From: wenxu <wenxu@ucloud.cn>
Date: Sat, 13 Jun 2020 17:25:59 +0800
Subject: [PATCH RFC] net: flow_offload: fix flow_indr_dev_unregister path

If the representor is removed, then identify the indirect flow_blocks
that need to be removed by the release callback and the port representor
structure. To identify the port representor structure, a new
indr.cb_priv field needs to be introduced. The flow_block also needs to
be removed from the driver list from the cleanup path.

Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c        |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c |  4 ++--
 drivers/net/ethernet/netronome/nfp/flower/main.c    |  2 +-
 drivers/net/ethernet/netronome/nfp/flower/main.h    |  3 +--
 drivers/net/ethernet/netronome/nfp/flower/offload.c |  7 ++++---
 include/net/flow_offload.h                          |  3 ++-
 net/core/flow_offload.c                             | 11 ++++++-----
 net/netfilter/nf_flow_table_offload.c               |  1 +
 net/netfilter/nf_tables_offload.c                   |  1 +
 net/sched/cls_api.c                                 |  1 +
 10 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 0eef4f5e4a46..042c2850fcff 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1918,6 +1918,7 @@ static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
 
 		flow_block_cb_add(block_cb, f);
 		list_add_tail(&block_cb->driver_list, &bnxt_block_cb_list);
+		block_cb->indr.cb_priv = bp;
 		break;
 	case FLOW_BLOCK_UNBIND:
 		cb_priv = bnxt_tc_indr_block_cb_lookup(bp, netdev);
@@ -2074,7 +2075,7 @@ void bnxt_shutdown_tc(struct bnxt *bp)
 		return;
 
 	flow_indr_dev_unregister(bnxt_tc_setup_indr_cb, bp,
-				 bnxt_tc_setup_indr_block_cb);
+				 bnxt_tc_setup_indr_rel);
 	rhashtable_destroy(&tc_info->flow_table);
 	rhashtable_destroy(&tc_info->l2_table);
 	rhashtable_destroy(&tc_info->decap_l2_table);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 80713123de5c..187f84c2ec23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -447,7 +447,7 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev,
 		}
 		flow_block_cb_add(block_cb, f);
 		list_add_tail(&block_cb->driver_list, &mlx5e_block_cb_list);
-
+		block_cb->indr.cb_priv = rpriv;
 		return 0;
 	case FLOW_BLOCK_UNBIND:
 		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev);
@@ -496,7 +496,7 @@ int mlx5e_rep_tc_netdevice_event_register(struct mlx5e_rep_priv *rpriv)
 void mlx5e_rep_tc_netdevice_event_unregister(struct mlx5e_rep_priv *rpriv)
 {
 	flow_indr_dev_unregister(mlx5e_rep_indr_setup_cb, rpriv,
-				 mlx5e_rep_indr_setup_tc_cb);
+				 mlx5e_rep_indr_block_unbind);
 }
 
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index c39327677a7d..bb448c82cdc2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -861,7 +861,7 @@ static void nfp_flower_clean(struct nfp_app *app)
 	flush_work(&app_priv->cmsg_work);
 
 	flow_indr_dev_unregister(nfp_flower_indr_setup_tc_cb, app,
-				 nfp_flower_setup_indr_block_cb);
+				 nfp_flower_setup_indr_tc_release);
 
 	if (app_priv->flower_ext_feats & NFP_FL_FEATS_VF_RLIM)
 		nfp_flower_qos_cleanup(app);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 6c3dc3baf387..c98333799f89 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -460,8 +460,7 @@ int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
 void nfp_flower_stats_rlim_reply(struct nfp_app *app, struct sk_buff *skb);
 int nfp_flower_indr_setup_tc_cb(struct net_device *netdev, void *cb_priv,
 				enum tc_setup_type type, void *type_data);
-int nfp_flower_setup_indr_block_cb(enum tc_setup_type type, void *type_data,
-				   void *cb_priv);
+void nfp_flower_setup_indr_tc_release(void *cb_priv);
 
 void
 __nfp_flower_non_repr_priv_get(struct nfp_flower_non_repr_priv *non_repr_priv);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 695d24b9dd92..ca2f01a3418d 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1619,8 +1619,8 @@ nfp_flower_indr_block_cb_priv_lookup(struct nfp_app *app,
 	return NULL;
 }
 
-int nfp_flower_setup_indr_block_cb(enum tc_setup_type type,
-				   void *type_data, void *cb_priv)
+static int nfp_flower_setup_indr_block_cb(enum tc_setup_type type,
+					  void *type_data, void *cb_priv)
 {
 	struct nfp_flower_indr_block_cb_priv *priv = cb_priv;
 	struct flow_cls_offload *flower = type_data;
@@ -1637,7 +1637,7 @@ int nfp_flower_setup_indr_block_cb(enum tc_setup_type type,
 	}
 }
 
-static void nfp_flower_setup_indr_tc_release(void *cb_priv)
+void nfp_flower_setup_indr_tc_release(void *cb_priv)
 {
 	struct nfp_flower_indr_block_cb_priv *priv = cb_priv;
 
@@ -1687,6 +1687,7 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 
 		flow_block_cb_add(block_cb, f);
 		list_add_tail(&block_cb->driver_list, &nfp_block_cb_list);
+		block_cb->indr.cb_priv = app;
 		return 0;
 	case FLOW_BLOCK_UNBIND:
 		cb_priv = nfp_flower_indr_block_cb_priv_lookup(app, netdev);
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index f2c8311a0433..ef4d8b0e304c 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -450,6 +450,7 @@ struct flow_block_indr {
 	struct net_device		*dev;
 	enum flow_block_binder_type	binder_type;
 	void				*data;
+	void				*cb_priv;
 	void				(*cleanup)(struct flow_block_cb *block_cb);
 };
 
@@ -536,7 +537,7 @@ typedef int flow_indr_block_bind_cb_t(struct net_device *dev, void *cb_priv,
 
 int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv);
 void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
-			      flow_setup_cb_t *setup_cb);
+			      void (*release)(void *cb_priv));
 int flow_indr_dev_setup_offload(struct net_device *dev,
 				enum tc_setup_type type, void *data,
 				struct flow_block_offload *bo,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 0cfc35e6be28..66143518f1d4 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -372,14 +372,15 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 }
 EXPORT_SYMBOL(flow_indr_dev_register);
 
-static void __flow_block_indr_cleanup(flow_setup_cb_t *setup_cb, void *cb_priv,
+static void __flow_block_indr_cleanup(void (*release)(void *cb_priv),
+				      void *cb_priv,
 				      struct list_head *cleanup_list)
 {
 	struct flow_block_cb *this, *next;
 
 	list_for_each_entry_safe(this, next, &flow_block_indr_list, indr.list) {
-		if (this->cb == setup_cb &&
-		    this->cb_priv == cb_priv) {
+		if (this->release == release &&
+		    this->indr.cb_priv == cb_priv) {
 			list_move(&this->indr.list, cleanup_list);
 			return;
 		}
@@ -397,7 +398,7 @@ static void flow_block_indr_notify(struct list_head *cleanup_list)
 }
 
 void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
-			      flow_setup_cb_t *setup_cb)
+			      void (*release)(void *cb_priv))
 {
 	struct flow_indr_dev *this, *next, *indr_dev = NULL;
 	LIST_HEAD(cleanup_list);
@@ -418,7 +419,7 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
 		return;
 	}
 
-	__flow_block_indr_cleanup(setup_cb, cb_priv, &cleanup_list);
+	__flow_block_indr_cleanup(release, cb_priv, &cleanup_list);
 	mutex_unlock(&flow_indr_block_lock);
 
 	flow_block_indr_notify(&cleanup_list);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 62651e6683f6..5fff1e040168 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -950,6 +950,7 @@ static void nf_flow_table_indr_cleanup(struct flow_block_cb *block_cb)
 	nf_flow_table_gc_cleanup(flowtable, dev);
 	down_write(&flowtable->flow_block_lock);
 	list_del(&block_cb->list);
+	list_del(&block_cb->driver_list);
 	flow_block_cb_free(block_cb);
 	up_write(&flowtable->flow_block_lock);
 }
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 185fc82c99aa..c7cf1cde46de 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -296,6 +296,7 @@ static void nft_indr_block_cleanup(struct flow_block_cb *block_cb)
 	nft_flow_block_offload_init(&bo, dev_net(dev), FLOW_BLOCK_UNBIND,
 				    basechain, &extack);
 	mutex_lock(&net->nft.commit_mutex);
+	list_del(&block_cb->driver_list);
 	list_move(&block_cb->list, &bo.cb_list);
 	nft_flow_offload_unbind(&bo, basechain);
 	mutex_unlock(&net->nft.commit_mutex);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index a00a203b2ef5..f8028d73edf1 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -652,6 +652,7 @@ static void tc_block_indr_cleanup(struct flow_block_cb *block_cb)
 			       &block->flow_block, tcf_block_shared(block),
 			       &extack);
 	down_write(&block->cb_lock);
+	list_del(&block_cb->driver_list);
 	list_move(&block_cb->list, &bo.cb_list);
 	up_write(&block->cb_lock);
 	rtnl_lock();
-- 
2.20.1


--k+w/mQv8wyuph6w0--
