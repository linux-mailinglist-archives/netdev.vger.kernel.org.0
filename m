Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D9F1CD9D7
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbgEKM3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:29:21 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:42242 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728084AbgEKM3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:29:20 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id ADE346009F;
        Mon, 11 May 2020 12:29:19 +0000 (UTC)
Received: from us4-mdac16-58.ut7.mdlocal (unknown [10.7.66.29])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id ACD3F8009B;
        Mon, 11 May 2020 12:29:19 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.36])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2673628006E;
        Mon, 11 May 2020 12:29:19 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A5A27B40088;
        Mon, 11 May 2020 12:29:18 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 11 May
 2020 13:29:13 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 4/8] sfc: move 'must restore' flags out of
 ef10-specific nic_data
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
Message-ID: <2788420e-eb17-ec74-e734-af050bd108f3@solarflare.com>
Date:   Mon, 11 May 2020 13:29:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25412.003
X-TM-AS-Result: No-8.952000-8.000000-10
X-TMASE-MatchedRID: Uxn1FEKTNW97h43UaXHBh8zSKGx9g8xhOyBTDrxRCtgmeuMNSQOJxsiT
        Wug2C4DNl1M7KT9/aqA0uSYsteWBcgihmwiXCMoGPwKTD1v8YV5MkOX0UoduuYqFeIXGsrr98FS
        rkmy6/FJPncvnf9/rJwI6/EcTRFqOkXoWBThuuCiI8hHRrWLqF6m9/6ObPjnDq4++j0vqJoiBlT
        +jl6FrYeIkog2fXJ1JmD4B2XRg96g2jeY+Udg/IlMsVuL5ry7dGIMg4+U4kbX6eV5+LAaaX1XT6
        v5x8gQLP+hIH7VezSClL/C3qPNuFs1Ku5XXgtDND3uYMxd01bfMBINgV4CMF3T7g/hbrl6OhnOL
        yflyxrM1n9fUOU7FVMoLp7NAW1Bbdm4kbLKk/25JUdgxNDUXWsu99zcLpJbCzFjbcpor5QpwDtY
        JWjotBQIqXBPeS82Coa4GM6KoDS2VK7w4d0IaXHYZxYoZm58F8Ql85K8KnzOHY81LcCWMu+4L5A
        pNcJPz8EG42fasHIpopprqjDetVNfOfGcoM5ITBzS99BLPiYrihJ3Xxt2bAo5JUK9UdYknOsAUR
        sBevgfi8zVgXoAltkWL4rBlm20vjaPj0W1qn0SyO81X3yak833nroCrv/SlRJcWQCwtVfMHkmyR
        82Gytou/nIhqpI1x8vOu2V+5sLV+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.952000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25412.003
X-MDID: 1589200159-NpP3IHLPd62a
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Common code in mcdi_filters.c uses these flags, so by moving them to
 either struct efx_nic (in the case of must_realloc_vis) or struct
 efx_mcdi_filter_table (for must_restore_rss_contexts and
 must_restore_filters), decouple this code from ef10's nic_data.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c         | 14 ++++++--------
 drivers/net/ethernet/sfc/mcdi_filters.c | 24 ++++++++++++++++--------
 drivers/net/ethernet/sfc/mcdi_filters.h |  6 ++++++
 drivers/net/ethernet/sfc/net_driver.h   |  2 ++
 drivers/net/ethernet/sfc/nic.h          |  7 -------
 5 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 7b3c6214dee6..b33bd6b77501 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1281,13 +1281,13 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 		nic_data->must_check_datapath_caps = false;
 	}
 
-	if (nic_data->must_realloc_vis) {
+	if (efx->must_realloc_vis) {
 		/* We cannot let the number of VIs change now */
 		rc = efx_ef10_alloc_vis(efx, nic_data->n_allocated_vis,
 					nic_data->n_allocated_vis);
 		if (rc)
 			return rc;
-		nic_data->must_realloc_vis = false;
+		efx->must_realloc_vis = false;
 	}
 
 	if (nic_data->must_restore_piobufs && nic_data->n_piobufs) {
@@ -1326,9 +1326,8 @@ static void efx_ef10_table_reset_mc_allocations(struct efx_nic *efx)
 #endif
 
 	/* All our allocations have been reset */
-	nic_data->must_realloc_vis = true;
-	nic_data->must_restore_rss_contexts = true;
-	nic_data->must_restore_filters = true;
+	efx->must_realloc_vis = true;
+	efx_mcdi_filter_table_reset_mc_allocations(efx);
 	nic_data->must_restore_piobufs = true;
 	efx_ef10_forget_old_piobufs(efx);
 	efx->rss_context.context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
@@ -3100,16 +3099,15 @@ void efx_ef10_handle_drain_event(struct efx_nic *efx)
 
 static int efx_ef10_fini_dmaq(struct efx_nic *efx)
 {
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	struct efx_channel *channel;
 	struct efx_tx_queue *tx_queue;
 	struct efx_rx_queue *rx_queue;
+	struct efx_channel *channel;
 	int pending;
 
 	/* If the MC has just rebooted, the TX/RX queues will have already been
 	 * torn down, but efx->active_queues needs to be set to zero.
 	 */
-	if (nic_data->must_realloc_vis) {
+	if (efx->must_realloc_vis) {
 		atomic_set(&efx->active_queues, 0);
 		return 0;
 	}
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 39f8a91c1222..bb29fc0063bf 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -331,7 +331,6 @@ static s32 efx_mcdi_filter_insert_locked(struct efx_nic *efx,
 					 bool replace_equal)
 {
 	DECLARE_BITMAP(mc_rem_map, EFX_EF10_FILTER_SEARCH_LIMIT);
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	struct efx_mcdi_filter_table *table;
 	struct efx_filter_spec *saved_spec;
 	struct efx_rss_context *ctx = NULL;
@@ -460,7 +459,7 @@ static s32 efx_mcdi_filter_insert_locked(struct efx_nic *efx,
 	rc = efx_mcdi_filter_push(efx, spec, &table->entry[ins_index].handle,
 				  ctx, replacing);
 
-	if (rc == -EINVAL && nic_data->must_realloc_vis)
+	if (rc == -EINVAL && efx->must_realloc_vis)
 		/* The MC rebooted under us, causing it to reject our filter
 		 * insertion as pointing to an invalid VI (spec->dmaq_id).
 		 */
@@ -1355,6 +1354,16 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx)
 	return rc;
 }
 
+void efx_mcdi_filter_table_reset_mc_allocations(struct efx_nic *efx)
+{
+	struct efx_mcdi_filter_table *table = efx->filter_state;
+
+	if (table) {
+		table->must_restore_filters = true;
+		table->must_restore_rss_contexts = true;
+	}
+}
+
 /*
  * Caller must hold efx->filter_sem for read if race against
  * efx_mcdi_filter_table_remove() is possible
@@ -1362,7 +1371,6 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx)
 void efx_mcdi_filter_table_restore(struct efx_nic *efx)
 {
 	struct efx_mcdi_filter_table *table = efx->filter_state;
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	unsigned int invalid_filters = 0, failed = 0;
 	struct efx_mcdi_filter_vlan *vlan;
 	struct efx_filter_spec *spec;
@@ -1374,7 +1382,7 @@ void efx_mcdi_filter_table_restore(struct efx_nic *efx)
 
 	WARN_ON(!rwsem_is_locked(&efx->filter_sem));
 
-	if (!nic_data->must_restore_filters)
+	if (!table->must_restore_filters)
 		return;
 
 	if (!table)
@@ -1453,7 +1461,7 @@ void efx_mcdi_filter_table_restore(struct efx_nic *efx)
 		netif_err(efx, hw, efx->net_dev,
 			  "unable to restore %u filters\n", failed);
 	else
-		nic_data->must_restore_filters = false;
+		table->must_restore_filters = false;
 }
 
 void efx_mcdi_filter_table_remove(struct efx_nic *efx)
@@ -2176,13 +2184,13 @@ int efx_mcdi_rx_pull_rss_config(struct efx_nic *efx)
 
 void efx_mcdi_rx_restore_rss_contexts(struct efx_nic *efx)
 {
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
 	struct efx_rss_context *ctx;
 	int rc;
 
 	WARN_ON(!mutex_is_locked(&efx->rss_lock));
 
-	if (!nic_data->must_restore_rss_contexts)
+	if (!table->must_restore_rss_contexts)
 		return;
 
 	list_for_each_entry(ctx, &efx->rss_context.list, list) {
@@ -2198,7 +2206,7 @@ void efx_mcdi_rx_restore_rss_contexts(struct efx_nic *efx)
 				   "; RSS filters may fail to be applied\n",
 				   ctx->user_id, rc);
 	}
-	nic_data->must_restore_rss_contexts = false;
+	table->must_restore_rss_contexts = false;
 }
 
 int efx_mcdi_pf_rx_push_rss_config(struct efx_nic *efx, bool user,
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.h b/drivers/net/ethernet/sfc/mcdi_filters.h
index 1837f4f5d661..884ba9731131 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.h
+++ b/drivers/net/ethernet/sfc/mcdi_filters.h
@@ -75,6 +75,10 @@ struct efx_mcdi_filter_table {
 /* Whether in multicast promiscuous mode when last changed */
 	bool mc_promisc_last;
 	bool mc_overflow; /* Too many MC addrs; should always imply mc_promisc */
+	/* RSS contexts have yet to be restored after MC reboot */
+	bool must_restore_rss_contexts;
+	/* filters have yet to be restored after MC reboot */
+	bool must_restore_filters;
 	bool vlan_filter;
 	struct list_head vlan_list;
 };
@@ -83,6 +87,8 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx);
 void efx_mcdi_filter_table_remove(struct efx_nic *efx);
 void efx_mcdi_filter_table_restore(struct efx_nic *efx);
 
+void efx_mcdi_filter_table_reset_mc_allocations(struct efx_nic *efx);
+
 /*
  * The filter table(s) are managed by firmware and we have write-only
  * access.  When removing filters we must identify them to the
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index bdeea48ff938..ae9756811dfe 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -890,6 +890,7 @@ struct efx_async_filter_insertion {
  * @vport_id: The function's vport ID, only relevant for PFs
  * @int_error_count: Number of internal errors seen recently
  * @int_error_expire: Time at which error count will be expired
+ * @must_realloc_vis: Flag: VIs have yet to be reallocated after MC reboot
  * @irq_soft_enabled: Are IRQs soft-enabled? If not, IRQ handler will
  *	acknowledge but do nothing else.
  * @irq_status: Interrupt status buffer
@@ -1050,6 +1051,7 @@ struct efx_nic {
 	unsigned int_error_count;
 	unsigned long int_error_expire;
 
+	bool must_realloc_vis;
 	bool irq_soft_enabled;
 	struct efx_buffer irq_status;
 	unsigned irq_zero_count;
diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/nic.h
index 9e2e387a4b1c..46583ba8fa24 100644
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -360,10 +360,6 @@ enum {
  * @warm_boot_count: Last seen MC warm boot count
  * @vi_base: Absolute index of first VI in this function
  * @n_allocated_vis: Number of VIs allocated to this function
- * @must_realloc_vis: Flag: VIs have yet to be reallocated after MC reboot
- * @must_restore_rss_contexts: Flag: RSS contexts have yet to be restored after
- *	MC reboot
- * @must_restore_filters: Flag: filters have yet to be restored after MC reboot
  * @n_piobufs: Number of PIO buffers allocated to this function
  * @wc_membase: Base address of write-combining mapping of the memory BAR
  * @pio_write_base: Base address for writing PIO buffers
@@ -403,9 +399,6 @@ struct efx_ef10_nic_data {
 	u16 warm_boot_count;
 	unsigned int vi_base;
 	unsigned int n_allocated_vis;
-	bool must_realloc_vis;
-	bool must_restore_rss_contexts;
-	bool must_restore_filters;
 	unsigned int n_piobufs;
 	void __iomem *wc_membase, *pio_write_base;
 	unsigned int pio_write_vi_base;

