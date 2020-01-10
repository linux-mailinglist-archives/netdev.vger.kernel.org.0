Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0FBF136E0A
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 14:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgAJN3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 08:29:02 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:60762 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727617AbgAJN3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 08:29:01 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7823068005C;
        Fri, 10 Jan 2020 13:28:59 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 10 Jan 2020 13:28:53 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 9/9] sfc: move RPS code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
Message-ID: <a7c29214-b266-c82e-5dc8-ac2647e8506c@solarflare.com>
Date:   Fri, 10 Jan 2020 13:28:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25158.003
X-TM-AS-Result: No-7.982900-8.000000-10
X-TMASE-MatchedRID: u0RVq3QqnJHoV3o5SLrUYvGSfx66m+aMeouvej40T4gd0WOKRkwsh1ym
        Rv3NQjsEYFYC7YeDc1LJFlXh4IcOcCHhSBQfglfsA9lly13c/gHYuVu0X/rOkBpX1zEL4nq3Ilw
        23V5SV9AM0M82sr4D86kjnHggKY0zKmnavDN/J07VsW2YGqoUtDsgUw68UQrYPbKiy7YT2QqyyQ
        InvLPk/I9E5ZwUA9a8mfvVzOUpZSw+DMYP1Y4Xz1PCjtWo3QQ8Z/rAPfrtWC0K5I+5JVbn7mMny
        G1Y77jSnxtmsJVK9Uk+zSA4ac3nl8k5DoLS5FXGMIxbvM3AVoicBOdAujM8iCS30GKAkBxW4QkF
        AfqbgGaFgcHbu6fL/y7HZT6izGSfjNCnuZyJlEhtawJSSsDgSQqiBO2qhCIGbDD7i2QfyEe4RAM
        g3uN+8lnOqEIBSVVeF2fSo3wa4Lz1dTJ58IKKECZm6wdY+F8KjssjUHG3YcReziy/2vLIY3uosI
        nzuhSMLPtrQd14tHslVEVWnldEYBL/12vY1jd3SHCU59h5KrFLew0dUDGibETqq9Xa45y5de5uO
        kkKYE9B/OPnryYt6vl2OneIaa+3UkACTuP1b5ejGOtqnkAZCwg+QxyOopZzwrQeQFxkWNtpcrNT
        w4Vi6NMf+HpC8wiBThFZzq2DQkrwB8MaTaI0lpcSOzDC4nqrKmiyrJHNh3IUFDkgqWz8Dtj1awh
        yfC4WrpOdiLYbSyBFAKvvwIHg6P23St9LPiqzsJribvbshQ/17lqbebntfS2JvEZxkQHs6HXhKi
        rJYBicNLyl5XGGv0tp6Plw4IcJ07HCUMKHxrGeAiCmPx4NwLTrdaH1ZWqC3TrdyO4a2u36C0ePs
        7A07V9vMTaVNFNz8QVeBG47w5TN0GsfvEXoE/7OPv18juSq7hWjLBE0KXA=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.982900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25158.003
X-MDID: 1578662940-OnjuHrO6W4wG
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Includes a couple of filtering functions and also renames a constant.

Style fixes included.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c       |  28 +--
 drivers/net/ethernet/sfc/efx.c        | 200 ----------------------
 drivers/net/ethernet/sfc/efx.h        |  24 +--
 drivers/net/ethernet/sfc/ethtool.c    |   2 +-
 drivers/net/ethernet/sfc/net_driver.h |   6 +-
 drivers/net/ethernet/sfc/rx.c         |  34 ----
 drivers/net/ethernet/sfc/rx_common.c  | 235 +++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/rx_common.h  |  20 +++
 8 files changed, 273 insertions(+), 276 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 06045e181c8f..82063212cac4 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -660,7 +660,7 @@ static int efx_ef10_probe(struct efx_nic *efx)
 	}
 	nic_data->warm_boot_count = rc;
 
-	efx->rss_context.context_id = EFX_EF10_RSS_CONTEXT_INVALID;
+	efx->rss_context.context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
 
 	nic_data->vport_id = EVB_PORT_ID_ASSIGNED;
 
@@ -1440,7 +1440,7 @@ static void efx_ef10_reset_mc_allocations(struct efx_nic *efx)
 	nic_data->must_restore_filters = true;
 	nic_data->must_restore_piobufs = true;
 	efx_ef10_forget_old_piobufs(efx);
-	efx->rss_context.context_id = EFX_EF10_RSS_CONTEXT_INVALID;
+	efx->rss_context.context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
 
 	/* Driver-created vswitches and vports must be re-created */
 	nic_data->must_probe_vswitching = true;
@@ -2598,7 +2598,7 @@ static int efx_ef10_alloc_rss_context(struct efx_nic *efx, bool exclusive,
 				    EFX_EF10_MAX_SHARED_RSS_CONTEXT_SIZE);
 
 	if (!exclusive && rss_spread == 1) {
-		ctx->context_id = EFX_EF10_RSS_CONTEXT_INVALID;
+		ctx->context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
 		if (context_size)
 			*context_size = 1;
 		return 0;
@@ -2685,11 +2685,11 @@ static void efx_ef10_rx_free_indir_table(struct efx_nic *efx)
 {
 	int rc;
 
-	if (efx->rss_context.context_id != EFX_EF10_RSS_CONTEXT_INVALID) {
+	if (efx->rss_context.context_id != EFX_MCDI_RSS_CONTEXT_INVALID) {
 		rc = efx_ef10_free_rss_context(efx, efx->rss_context.context_id);
 		WARN_ON(rc != 0);
 	}
-	efx->rss_context.context_id = EFX_EF10_RSS_CONTEXT_INVALID;
+	efx->rss_context.context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
 }
 
 static int efx_ef10_rx_push_shared_rss_config(struct efx_nic *efx,
@@ -2715,7 +2715,7 @@ static int efx_ef10_rx_push_exclusive_rss_config(struct efx_nic *efx,
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	int rc;
 
-	if (efx->rss_context.context_id == EFX_EF10_RSS_CONTEXT_INVALID ||
+	if (efx->rss_context.context_id == EFX_MCDI_RSS_CONTEXT_INVALID ||
 	    !nic_data->rx_rss_context_exclusive) {
 		rc = efx_ef10_alloc_rss_context(efx, true, &efx->rss_context,
 						NULL);
@@ -2731,7 +2731,7 @@ static int efx_ef10_rx_push_exclusive_rss_config(struct efx_nic *efx,
 		goto fail2;
 
 	if (efx->rss_context.context_id != old_rx_rss_context &&
-	    old_rx_rss_context != EFX_EF10_RSS_CONTEXT_INVALID)
+	    old_rx_rss_context != EFX_MCDI_RSS_CONTEXT_INVALID)
 		WARN_ON(efx_ef10_free_rss_context(efx, old_rx_rss_context) != 0);
 	nic_data->rx_rss_context_exclusive = true;
 	if (rx_indir_table != efx->rss_context.rx_indir_table)
@@ -2762,7 +2762,7 @@ static int efx_ef10_rx_push_rss_context_config(struct efx_nic *efx,
 
 	WARN_ON(!mutex_is_locked(&efx->rss_lock));
 
-	if (ctx->context_id == EFX_EF10_RSS_CONTEXT_INVALID) {
+	if (ctx->context_id == EFX_MCDI_RSS_CONTEXT_INVALID) {
 		rc = efx_ef10_alloc_rss_context(efx, true, ctx, NULL);
 		if (rc)
 			return rc;
@@ -2797,7 +2797,7 @@ static int efx_ef10_rx_pull_rss_context_config(struct efx_nic *efx,
 	BUILD_BUG_ON(MC_CMD_RSS_CONTEXT_GET_TABLE_IN_LEN !=
 		     MC_CMD_RSS_CONTEXT_GET_KEY_IN_LEN);
 
-	if (ctx->context_id == EFX_EF10_RSS_CONTEXT_INVALID)
+	if (ctx->context_id == EFX_MCDI_RSS_CONTEXT_INVALID)
 		return -ENOENT;
 
 	MCDI_SET_DWORD(inbuf, RSS_CONTEXT_GET_TABLE_IN_RSS_CONTEXT_ID,
@@ -2858,7 +2858,7 @@ static void efx_ef10_rx_restore_rss_contexts(struct efx_nic *efx)
 
 	list_for_each_entry(ctx, &efx->rss_context.list, list) {
 		/* previous NIC RSS context is gone */
-		ctx->context_id = EFX_EF10_RSS_CONTEXT_INVALID;
+		ctx->context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
 		/* so try to allocate a new one */
 		rc = efx_ef10_rx_push_rss_context_config(efx, ctx,
 							 ctx->rx_indir_table,
@@ -2929,7 +2929,7 @@ static int efx_ef10_vf_rx_push_rss_config(struct efx_nic *efx, bool user,
 {
 	if (user)
 		return -EOPNOTSUPP;
-	if (efx->rss_context.context_id != EFX_EF10_RSS_CONTEXT_INVALID)
+	if (efx->rss_context.context_id != EFX_MCDI_RSS_CONTEXT_INVALID)
 		return 0;
 	return efx_ef10_rx_push_shared_rss_config(efx, NULL);
 }
@@ -3850,7 +3850,7 @@ static void efx_ef10_filter_push_prep(struct efx_nic *efx,
 		 */
 		if (WARN_ON_ONCE(!ctx))
 			flags &= ~EFX_FILTER_FLAG_RX_RSS;
-		else if (WARN_ON_ONCE(ctx->context_id == EFX_EF10_RSS_CONTEXT_INVALID))
+		else if (WARN_ON_ONCE(ctx->context_id == EFX_MCDI_RSS_CONTEXT_INVALID))
 			flags &= ~EFX_FILTER_FLAG_RX_RSS;
 	}
 
@@ -4029,7 +4029,7 @@ static s32 efx_ef10_filter_insert_locked(struct efx_nic *efx,
 			rc = -ENOENT;
 			goto out_unlock;
 		}
-		if (ctx->context_id == EFX_EF10_RSS_CONTEXT_INVALID) {
+		if (ctx->context_id == EFX_MCDI_RSS_CONTEXT_INVALID) {
 			rc = -EOPNOTSUPP;
 			goto out_unlock;
 		}
@@ -4770,7 +4770,7 @@ static void efx_ef10_filter_table_restore(struct efx_nic *efx)
 				invalid_filters++;
 				goto not_restored;
 			}
-			if (ctx->context_id == EFX_EF10_RSS_CONTEXT_INVALID) {
+			if (ctx->context_id == EFX_MCDI_RSS_CONTEXT_INVALID) {
 				netif_warn(efx, drv, efx->net_dev,
 					   "Warning: unable to restore a filter with RSS context %u as it was not created.\n",
 					   spec->rss_context);
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 87b784c207bd..110e485e6624 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -384,70 +384,6 @@ static void efx_remove_nic(struct efx_nic *efx)
 	efx->type->remove(efx);
 }
 
-static int efx_probe_filters(struct efx_nic *efx)
-{
-	int rc;
-
-	init_rwsem(&efx->filter_sem);
-	mutex_lock(&efx->mac_lock);
-	down_write(&efx->filter_sem);
-	rc = efx->type->filter_table_probe(efx);
-	if (rc)
-		goto out_unlock;
-
-#ifdef CONFIG_RFS_ACCEL
-	if (efx->type->offload_features & NETIF_F_NTUPLE) {
-		struct efx_channel *channel;
-		int i, success = 1;
-
-		efx_for_each_channel(channel, efx) {
-			channel->rps_flow_id =
-				kcalloc(efx->type->max_rx_ip_filters,
-					sizeof(*channel->rps_flow_id),
-					GFP_KERNEL);
-			if (!channel->rps_flow_id)
-				success = 0;
-			else
-				for (i = 0;
-				     i < efx->type->max_rx_ip_filters;
-				     ++i)
-					channel->rps_flow_id[i] =
-						RPS_FLOW_ID_INVALID;
-			channel->rfs_expire_index = 0;
-			channel->rfs_filter_count = 0;
-		}
-
-		if (!success) {
-			efx_for_each_channel(channel, efx)
-				kfree(channel->rps_flow_id);
-			efx->type->filter_table_remove(efx);
-			rc = -ENOMEM;
-			goto out_unlock;
-		}
-	}
-#endif
-out_unlock:
-	up_write(&efx->filter_sem);
-	mutex_unlock(&efx->mac_lock);
-	return rc;
-}
-
-static void efx_remove_filters(struct efx_nic *efx)
-{
-#ifdef CONFIG_RFS_ACCEL
-	struct efx_channel *channel;
-
-	efx_for_each_channel(channel, efx) {
-		cancel_delayed_work_sync(&channel->filter_work);
-		kfree(channel->rps_flow_id);
-	}
-#endif
-	down_write(&efx->filter_sem);
-	efx->type->filter_table_remove(efx);
-	up_write(&efx->filter_sem);
-}
-
-
 /**************************************************************************
  *
  * NIC startup/shutdown
@@ -1109,142 +1045,6 @@ void efx_update_sw_stats(struct efx_nic *efx, u64 *stats)
 	stats[GENERIC_STAT_rx_noskb_drops] = atomic_read(&efx->n_rx_noskb_drops);
 }
 
-bool efx_filter_spec_equal(const struct efx_filter_spec *left,
-			   const struct efx_filter_spec *right)
-{
-	if ((left->match_flags ^ right->match_flags) |
-	    ((left->flags ^ right->flags) &
-	     (EFX_FILTER_FLAG_RX | EFX_FILTER_FLAG_TX)))
-		return false;
-
-	return memcmp(&left->outer_vid, &right->outer_vid,
-		      sizeof(struct efx_filter_spec) -
-		      offsetof(struct efx_filter_spec, outer_vid)) == 0;
-}
-
-u32 efx_filter_spec_hash(const struct efx_filter_spec *spec)
-{
-	BUILD_BUG_ON(offsetof(struct efx_filter_spec, outer_vid) & 3);
-	return jhash2((const u32 *)&spec->outer_vid,
-		      (sizeof(struct efx_filter_spec) -
-		       offsetof(struct efx_filter_spec, outer_vid)) / 4,
-		      0);
-}
-
-#ifdef CONFIG_RFS_ACCEL
-bool efx_rps_check_rule(struct efx_arfs_rule *rule, unsigned int filter_idx,
-			bool *force)
-{
-	if (rule->filter_id == EFX_ARFS_FILTER_ID_PENDING) {
-		/* ARFS is currently updating this entry, leave it */
-		return false;
-	}
-	if (rule->filter_id == EFX_ARFS_FILTER_ID_ERROR) {
-		/* ARFS tried and failed to update this, so it's probably out
-		 * of date.  Remove the filter and the ARFS rule entry.
-		 */
-		rule->filter_id = EFX_ARFS_FILTER_ID_REMOVING;
-		*force = true;
-		return true;
-	} else if (WARN_ON(rule->filter_id != filter_idx)) { /* can't happen */
-		/* ARFS has moved on, so old filter is not needed.  Since we did
-		 * not mark the rule with EFX_ARFS_FILTER_ID_REMOVING, it will
-		 * not be removed by efx_rps_hash_del() subsequently.
-		 */
-		*force = true;
-		return true;
-	}
-	/* Remove it iff ARFS wants to. */
-	return true;
-}
-
-static
-struct hlist_head *efx_rps_hash_bucket(struct efx_nic *efx,
-				       const struct efx_filter_spec *spec)
-{
-	u32 hash = efx_filter_spec_hash(spec);
-
-	lockdep_assert_held(&efx->rps_hash_lock);
-	if (!efx->rps_hash_table)
-		return NULL;
-	return &efx->rps_hash_table[hash % EFX_ARFS_HASH_TABLE_SIZE];
-}
-
-struct efx_arfs_rule *efx_rps_hash_find(struct efx_nic *efx,
-					const struct efx_filter_spec *spec)
-{
-	struct efx_arfs_rule *rule;
-	struct hlist_head *head;
-	struct hlist_node *node;
-
-	head = efx_rps_hash_bucket(efx, spec);
-	if (!head)
-		return NULL;
-	hlist_for_each(node, head) {
-		rule = container_of(node, struct efx_arfs_rule, node);
-		if (efx_filter_spec_equal(spec, &rule->spec))
-			return rule;
-	}
-	return NULL;
-}
-
-struct efx_arfs_rule *efx_rps_hash_add(struct efx_nic *efx,
-				       const struct efx_filter_spec *spec,
-				       bool *new)
-{
-	struct efx_arfs_rule *rule;
-	struct hlist_head *head;
-	struct hlist_node *node;
-
-	head = efx_rps_hash_bucket(efx, spec);
-	if (!head)
-		return NULL;
-	hlist_for_each(node, head) {
-		rule = container_of(node, struct efx_arfs_rule, node);
-		if (efx_filter_spec_equal(spec, &rule->spec)) {
-			*new = false;
-			return rule;
-		}
-	}
-	rule = kmalloc(sizeof(*rule), GFP_ATOMIC);
-	*new = true;
-	if (rule) {
-		memcpy(&rule->spec, spec, sizeof(rule->spec));
-		hlist_add_head(&rule->node, head);
-	}
-	return rule;
-}
-
-void efx_rps_hash_del(struct efx_nic *efx, const struct efx_filter_spec *spec)
-{
-	struct efx_arfs_rule *rule;
-	struct hlist_head *head;
-	struct hlist_node *node;
-
-	head = efx_rps_hash_bucket(efx, spec);
-	if (WARN_ON(!head))
-		return;
-	hlist_for_each(node, head) {
-		rule = container_of(node, struct efx_arfs_rule, node);
-		if (efx_filter_spec_equal(spec, &rule->spec)) {
-			/* Someone already reused the entry.  We know that if
-			 * this check doesn't fire (i.e. filter_id == REMOVING)
-			 * then the REMOVING mark was put there by our caller,
-			 * because caller is holding a lock on filter table and
-			 * only holders of that lock set REMOVING.
-			 */
-			if (rule->filter_id != EFX_ARFS_FILTER_ID_REMOVING)
-				return;
-			hlist_del(node);
-			kfree(rule);
-			return;
-		}
-	}
-	/* We didn't find it. */
-	WARN_ON(1);
-}
-#endif
-
 /**************************************************************************
  *
  * PCI interface
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 4db56b356f11..f1bdb04efbe4 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -169,33 +169,11 @@ static inline void efx_filter_rfs_expire(struct work_struct *data)
 static inline void efx_filter_rfs_expire(struct work_struct *data) {}
 #define efx_filter_rfs_enabled() 0
 #endif
-bool efx_filter_is_mc_recipient(const struct efx_filter_spec *spec);
-
-bool efx_filter_spec_equal(const struct efx_filter_spec *left,
-			   const struct efx_filter_spec *right);
-u32 efx_filter_spec_hash(const struct efx_filter_spec *spec);
-
-#ifdef CONFIG_RFS_ACCEL
-bool efx_rps_check_rule(struct efx_arfs_rule *rule, unsigned int filter_idx,
-			bool *force);
-
-struct efx_arfs_rule *efx_rps_hash_find(struct efx_nic *efx,
-					const struct efx_filter_spec *spec);
-
-/* @new is written to indicate if entry was newly added (true) or if an old
- * entry was found and returned (false).
- */
-struct efx_arfs_rule *efx_rps_hash_add(struct efx_nic *efx,
-				       const struct efx_filter_spec *spec,
-				       bool *new);
-
-void efx_rps_hash_del(struct efx_nic *efx, const struct efx_filter_spec *spec);
-#endif
 
 /* RSS contexts */
 static inline bool efx_rss_active(struct efx_rss_context *ctx)
 {
-	return ctx->context_id != EFX_EF10_RSS_CONTEXT_INVALID;
+	return ctx->context_id != EFX_MCDI_RSS_CONTEXT_INVALID;
 }
 
 /* Ethtool support */
diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index e50901e4b2ac..993b5769525b 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -1020,7 +1020,7 @@ static int efx_ethtool_set_rxfh_context(struct net_device *net_dev,
 			rc = -ENOMEM;
 			goto out_unlock;
 		}
-		ctx->context_id = EFX_EF10_RSS_CONTEXT_INVALID;
+		ctx->context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
 		/* Initialise indir table and key to defaults */
 		efx_set_default_rx_indir_table(efx, ctx);
 		netdev_rss_key_fill(ctx->rx_hash_key, sizeof(ctx->rx_hash_key));
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 52e6f11d8818..9f9886f222c8 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -744,13 +744,13 @@ union efx_multicast_hash {
 struct vfdi_status;
 
 /* The reserved RSS context value */
-#define EFX_EF10_RSS_CONTEXT_INVALID	0xffffffff
+#define EFX_MCDI_RSS_CONTEXT_INVALID	0xffffffff
 /**
  * struct efx_rss_context - A user-defined RSS context for filtering
  * @list: node of linked list on which this struct is stored
  * @context_id: the RSS_CONTEXT_ID returned by MC firmware, or
- *	%EFX_EF10_RSS_CONTEXT_INVALID if this context is not present on the NIC.
- *	For Siena, 0 if RSS is active, else %EFX_EF10_RSS_CONTEXT_INVALID.
+ *	%EFX_MCDI_RSS_CONTEXT_INVALID if this context is not present on the NIC.
+ *	For Siena, 0 if RSS is active, else %EFX_MCDI_RSS_CONTEXT_INVALID.
  * @user_id: the rss_context ID exposed to userspace over ethtool.
  * @rx_hash_udp_4tuple: UDP 4-tuple hashing enabled
  * @rx_hash_key: Toeplitz hash key for this RSS context
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 18001195410f..a2042f16babc 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -650,37 +650,3 @@ bool __efx_filter_rfs_expire(struct efx_channel *channel, unsigned int quota)
 }
 
 #endif /* CONFIG_RFS_ACCEL */
-
-/**
- * efx_filter_is_mc_recipient - test whether spec is a multicast recipient
- * @spec: Specification to test
- *
- * Return: %true if the specification is a non-drop RX filter that
- * matches a local MAC address I/G bit value of 1 or matches a local
- * IPv4 or IPv6 address value in the respective multicast address
- * range.  Otherwise %false.
- */
-bool efx_filter_is_mc_recipient(const struct efx_filter_spec *spec)
-{
-	if (!(spec->flags & EFX_FILTER_FLAG_RX) ||
-	    spec->dmaq_id == EFX_FILTER_RX_DMAQ_ID_DROP)
-		return false;
-
-	if (spec->match_flags &
-	    (EFX_FILTER_MATCH_LOC_MAC | EFX_FILTER_MATCH_LOC_MAC_IG) &&
-	    is_multicast_ether_addr(spec->loc_mac))
-		return true;
-
-	if ((spec->match_flags &
-	     (EFX_FILTER_MATCH_ETHER_TYPE | EFX_FILTER_MATCH_LOC_HOST)) ==
-	    (EFX_FILTER_MATCH_ETHER_TYPE | EFX_FILTER_MATCH_LOC_HOST)) {
-		if (spec->ether_type == htons(ETH_P_IP) &&
-		    ipv4_is_multicast(spec->loc_host[0]))
-			return true;
-		if (spec->ether_type == htons(ETH_P_IPV6) &&
-		    ((const u8 *)spec->loc_host)[0] == 0xff)
-			return true;
-	}
-
-	return false;
-}
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index cdf21e2d5610..ee8beb87bdc1 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -579,7 +579,7 @@ struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
 	new = kmalloc(sizeof(*new), GFP_KERNEL);
 	if (!new)
 		return NULL;
-	new->context_id = EFX_EF10_RSS_CONTEXT_INVALID;
+	new->context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
 	new->rx_hash_udp_4tuple = false;
 
 	/* Insert the new entry into the gap */
@@ -616,3 +616,236 @@ void efx_set_default_rx_indir_table(struct efx_nic *efx,
 		ctx->rx_indir_table[i] =
 			ethtool_rxfh_indir_default(i, efx->rss_spread);
 }
+
+/**
+ * efx_filter_is_mc_recipient - test whether spec is a multicast recipient
+ * @spec: Specification to test
+ *
+ * Return: %true if the specification is a non-drop RX filter that
+ * matches a local MAC address I/G bit value of 1 or matches a local
+ * IPv4 or IPv6 address value in the respective multicast address
+ * range.  Otherwise %false.
+ */
+bool efx_filter_is_mc_recipient(const struct efx_filter_spec *spec)
+{
+	if (!(spec->flags & EFX_FILTER_FLAG_RX) ||
+	    spec->dmaq_id == EFX_FILTER_RX_DMAQ_ID_DROP)
+		return false;
+
+	if (spec->match_flags &
+	    (EFX_FILTER_MATCH_LOC_MAC | EFX_FILTER_MATCH_LOC_MAC_IG) &&
+	    is_multicast_ether_addr(spec->loc_mac))
+		return true;
+
+	if ((spec->match_flags &
+	     (EFX_FILTER_MATCH_ETHER_TYPE | EFX_FILTER_MATCH_LOC_HOST)) ==
+	    (EFX_FILTER_MATCH_ETHER_TYPE | EFX_FILTER_MATCH_LOC_HOST)) {
+		if (spec->ether_type == htons(ETH_P_IP) &&
+		    ipv4_is_multicast(spec->loc_host[0]))
+			return true;
+		if (spec->ether_type == htons(ETH_P_IPV6) &&
+		    ((const u8 *)spec->loc_host)[0] == 0xff)
+			return true;
+	}
+
+	return false;
+}
+
+bool efx_filter_spec_equal(const struct efx_filter_spec *left,
+			   const struct efx_filter_spec *right)
+{
+	if ((left->match_flags ^ right->match_flags) |
+	    ((left->flags ^ right->flags) &
+	     (EFX_FILTER_FLAG_RX | EFX_FILTER_FLAG_TX)))
+		return false;
+
+	return memcmp(&left->outer_vid, &right->outer_vid,
+		      sizeof(struct efx_filter_spec) -
+		      offsetof(struct efx_filter_spec, outer_vid)) == 0;
+}
+
+u32 efx_filter_spec_hash(const struct efx_filter_spec *spec)
+{
+	BUILD_BUG_ON(offsetof(struct efx_filter_spec, outer_vid) & 3);
+	return jhash2((const u32 *)&spec->outer_vid,
+		      (sizeof(struct efx_filter_spec) -
+		       offsetof(struct efx_filter_spec, outer_vid)) / 4,
+		      0);
+}
+
+#ifdef CONFIG_RFS_ACCEL
+bool efx_rps_check_rule(struct efx_arfs_rule *rule, unsigned int filter_idx,
+			bool *force)
+{
+	if (rule->filter_id == EFX_ARFS_FILTER_ID_PENDING) {
+		/* ARFS is currently updating this entry, leave it */
+		return false;
+	}
+	if (rule->filter_id == EFX_ARFS_FILTER_ID_ERROR) {
+		/* ARFS tried and failed to update this, so it's probably out
+		 * of date.  Remove the filter and the ARFS rule entry.
+		 */
+		rule->filter_id = EFX_ARFS_FILTER_ID_REMOVING;
+		*force = true;
+		return true;
+	} else if (WARN_ON(rule->filter_id != filter_idx)) { /* can't happen */
+		/* ARFS has moved on, so old filter is not needed.  Since we did
+		 * not mark the rule with EFX_ARFS_FILTER_ID_REMOVING, it will
+		 * not be removed by efx_rps_hash_del() subsequently.
+		 */
+		*force = true;
+		return true;
+	}
+	/* Remove it iff ARFS wants to. */
+	return true;
+}
+
+static
+struct hlist_head *efx_rps_hash_bucket(struct efx_nic *efx,
+				       const struct efx_filter_spec *spec)
+{
+	u32 hash = efx_filter_spec_hash(spec);
+
+	lockdep_assert_held(&efx->rps_hash_lock);
+	if (!efx->rps_hash_table)
+		return NULL;
+	return &efx->rps_hash_table[hash % EFX_ARFS_HASH_TABLE_SIZE];
+}
+
+struct efx_arfs_rule *efx_rps_hash_find(struct efx_nic *efx,
+					const struct efx_filter_spec *spec)
+{
+	struct efx_arfs_rule *rule;
+	struct hlist_head *head;
+	struct hlist_node *node;
+
+	head = efx_rps_hash_bucket(efx, spec);
+	if (!head)
+		return NULL;
+	hlist_for_each(node, head) {
+		rule = container_of(node, struct efx_arfs_rule, node);
+		if (efx_filter_spec_equal(spec, &rule->spec))
+			return rule;
+	}
+	return NULL;
+}
+
+struct efx_arfs_rule *efx_rps_hash_add(struct efx_nic *efx,
+				       const struct efx_filter_spec *spec,
+				       bool *new)
+{
+	struct efx_arfs_rule *rule;
+	struct hlist_head *head;
+	struct hlist_node *node;
+
+	head = efx_rps_hash_bucket(efx, spec);
+	if (!head)
+		return NULL;
+	hlist_for_each(node, head) {
+		rule = container_of(node, struct efx_arfs_rule, node);
+		if (efx_filter_spec_equal(spec, &rule->spec)) {
+			*new = false;
+			return rule;
+		}
+	}
+	rule = kmalloc(sizeof(*rule), GFP_ATOMIC);
+	*new = true;
+	if (rule) {
+		memcpy(&rule->spec, spec, sizeof(rule->spec));
+		hlist_add_head(&rule->node, head);
+	}
+	return rule;
+}
+
+void efx_rps_hash_del(struct efx_nic *efx, const struct efx_filter_spec *spec)
+{
+	struct efx_arfs_rule *rule;
+	struct hlist_head *head;
+	struct hlist_node *node;
+
+	head = efx_rps_hash_bucket(efx, spec);
+	if (WARN_ON(!head))
+		return;
+	hlist_for_each(node, head) {
+		rule = container_of(node, struct efx_arfs_rule, node);
+		if (efx_filter_spec_equal(spec, &rule->spec)) {
+			/* Someone already reused the entry.  We know that if
+			 * this check doesn't fire (i.e. filter_id == REMOVING)
+			 * then the REMOVING mark was put there by our caller,
+			 * because caller is holding a lock on filter table and
+			 * only holders of that lock set REMOVING.
+			 */
+			if (rule->filter_id != EFX_ARFS_FILTER_ID_REMOVING)
+				return;
+			hlist_del(node);
+			kfree(rule);
+			return;
+		}
+	}
+	/* We didn't find it. */
+	WARN_ON(1);
+}
+#endif
+
+int efx_probe_filters(struct efx_nic *efx)
+{
+	int rc;
+
+	init_rwsem(&efx->filter_sem);
+	mutex_lock(&efx->mac_lock);
+	down_write(&efx->filter_sem);
+	rc = efx->type->filter_table_probe(efx);
+	if (rc)
+		goto out_unlock;
+
+#ifdef CONFIG_RFS_ACCEL
+	if (efx->type->offload_features & NETIF_F_NTUPLE) {
+		struct efx_channel *channel;
+		int i, success = 1;
+
+		efx_for_each_channel(channel, efx) {
+			channel->rps_flow_id =
+				kcalloc(efx->type->max_rx_ip_filters,
+					sizeof(*channel->rps_flow_id),
+					GFP_KERNEL);
+			if (!channel->rps_flow_id)
+				success = 0;
+			else
+				for (i = 0;
+				     i < efx->type->max_rx_ip_filters;
+				     ++i)
+					channel->rps_flow_id[i] =
+						RPS_FLOW_ID_INVALID;
+			channel->rfs_expire_index = 0;
+			channel->rfs_filter_count = 0;
+		}
+
+		if (!success) {
+			efx_for_each_channel(channel, efx)
+				kfree(channel->rps_flow_id);
+			efx->type->filter_table_remove(efx);
+			rc = -ENOMEM;
+			goto out_unlock;
+		}
+	}
+#endif
+out_unlock:
+	up_write(&efx->filter_sem);
+	mutex_unlock(&efx->mac_lock);
+	return rc;
+}
+
+void efx_remove_filters(struct efx_nic *efx)
+{
+#ifdef CONFIG_RFS_ACCEL
+	struct efx_channel *channel;
+
+	efx_for_each_channel(channel, efx) {
+		cancel_delayed_work_sync(&channel->filter_work);
+		kfree(channel->rps_flow_id);
+	}
+#endif
+	down_write(&efx->filter_sem);
+	efx->type->filter_table_remove(efx);
+	up_write(&efx->filter_sem);
+}
diff --git a/drivers/net/ethernet/sfc/rx_common.h b/drivers/net/ethernet/sfc/rx_common.h
index 4d2e7d38e260..c41f12a89477 100644
--- a/drivers/net/ethernet/sfc/rx_common.h
+++ b/drivers/net/ethernet/sfc/rx_common.h
@@ -74,4 +74,24 @@ struct efx_rss_context *efx_find_rss_context_entry(struct efx_nic *efx, u32 id);
 void efx_free_rss_context_entry(struct efx_rss_context *ctx);
 void efx_set_default_rx_indir_table(struct efx_nic *efx,
 				    struct efx_rss_context *ctx);
+
+bool efx_filter_is_mc_recipient(const struct efx_filter_spec *spec);
+bool efx_filter_spec_equal(const struct efx_filter_spec *left,
+			   const struct efx_filter_spec *right);
+u32 efx_filter_spec_hash(const struct efx_filter_spec *spec);
+
+#ifdef CONFIG_RFS_ACCEL
+bool efx_rps_check_rule(struct efx_arfs_rule *rule, unsigned int filter_idx,
+			bool *force);
+struct efx_arfs_rule *efx_rps_hash_find(struct efx_nic *efx,
+					const struct efx_filter_spec *spec);
+struct efx_arfs_rule *efx_rps_hash_add(struct efx_nic *efx,
+				       const struct efx_filter_spec *spec,
+				       bool *new);
+void efx_rps_hash_del(struct efx_nic *efx, const struct efx_filter_spec *spec);
+#endif
+
+int efx_probe_filters(struct efx_nic *efx);
+void efx_remove_filters(struct efx_nic *efx);
+
 #endif
-- 
2.20.1

