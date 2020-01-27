Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E5314A2E6
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 12:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbgA0LT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 06:19:29 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:57638 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729154AbgA0LT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 06:19:28 -0500
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 059FF2E6C5B
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 11:13:50 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CB3B78005C;
        Mon, 27 Jan 2020 11:13:48 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 27 Jan 2020 11:13:43 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH v3 net-next 2/3] sfc: create header for mcdi filtering code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <62445381-c3f7-1f10-897f-4990da13aa0b@solarflare.com>
Message-ID: <8aba90b4-8ea4-c4e8-240d-13de1c5bcbeb@solarflare.com>
Date:   Mon, 27 Jan 2020 11:13:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <62445381-c3f7-1f10-897f-4990da13aa0b@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25192.003
X-TM-AS-Result: No-14.354000-8.000000-10
X-TMASE-MatchedRID: 2SdFMmtXAB1pt0p5Gy2a+rgTyrrpk8Mc2LlbtF/6zpBjLp8Cm8vwFwoe
        RRhCZWIBnvBWG5GT8JfTUJMI/BDGSVIFgun+1oxxA9lly13c/gEHsX+ArLvcq7KeTtOdjMy6+qd
        Y5YSwCQKk00ZHthM5X7mZ6QtQxt1qWELDcKwGO25tawJSSsDgSc6gBdMBUo41abJxhiIFjJkce6
        ovk6XCiJfRf+zwovPbhg7u0oQFj2ee0eB03Q3Sp0f49ONH0RaSWNbBpQ++I1m9K1jOJyKSa927M
        YTVbUDKE51SW+g7FoqaWSN/uFkfbm1A5vznb2t5Row8EUpfIBQwA8NfeYPFBou6fTXJM2TrEZc2
        cPY2ad25bSUGOBST56IQv0qufcedBXO+h6h7aVjxWp8B+pjaLFo1rFkFFs1awCTIeJgMBBtUtNC
        O/RYrm+33HBFn8NUkr8efc/1Dlu2KhA2hG2DTq3LIMwGhqAZULYdywTHl7nsgVZAf8m502Ep1xf
        re49SB6rB2tJvSXOVx4Q41ErfeKjpYaDg7lhbw5hMYPmU3XmBvV3/OnMClWsM5LQWFwBdKRbtdC
        t59lLg9pF/8DQx7sUNMV5jqTYZlOzpEi4NJ5xMPe5gzF3TVt89jJuEN8CkbCuSPuSVW5+6vyk3f
        NNCVkjNrwHYT5tFbPs0gOGnN55datzJIy4dhkXCO70QAsBdCyeUl7aCTy8gumZeX1WIQ8KoT9j1
        YX9QjAVLlkHamTfuwojg8R+NsFHvxkphDg3ZyPlrzaogdiJwtxMagbN9/PNSVUkz9BPXeKRF2K5
        JKQbw4p1iHssV7hgtxnn69ENR1lFVIONmcEd2eAiCmPx4NwLTrdaH1ZWqC3TrdyO4a2u36C0ePs
        7A07YVH0dq7wY7uICrBdLFKhjOyG1eFrGs7csNQy9JnEdDo+7YBa9AKNbG8xant+Aqs3Q==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--14.354000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25192.003
X-MDID: 1580123629-DV-ZskcHtSB2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Moved structs, enums, and added function prototypes.

The affected functions are no longer static.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c         | 191 +++++++-----------------
 drivers/net/ethernet/sfc/mcdi_filters.h | 159 ++++++++++++++++++++
 2 files changed, 211 insertions(+), 139 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/mcdi_filters.h

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index b6301b328c9b..d41c76230e94 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -13,6 +13,7 @@
 #include "mcdi_port_common.h"
 #include "mcdi_functions.h"
 #include "nic.h"
+#include "mcdi_filters.h"
 #include "workarounds.h"
 #include "selftest.h"
 #include "ef10_sriov.h"
@@ -33,102 +34,19 @@ enum {
 /* TODO: this should really be from the mcdi protocol export */
 #define EFX_EF10_MAX_SHARED_RSS_CONTEXT_SIZE 64UL
 
-/* The filter table(s) are managed by firmware and we have write-only
- * access.  When removing filters we must identify them to the
- * firmware by a 64-bit handle, but this is too wide for Linux kernel
- * interfaces (32-bit for RX NFC, 16-bit for RFS).  Also, we need to
- * be able to tell in advance whether a requested insertion will
- * replace an existing filter.  Therefore we maintain a software hash
- * table, which should be at least as large as the hardware hash
- * table.
- *
- * Huntington has a single 8K filter table shared between all filter
- * types and both ports.
- */
-#define EFX_MCDI_FILTER_TBL_ROWS 8192
-
 #define EFX_EF10_FILTER_ID_INVALID 0xffff
 
-#define EFX_EF10_FILTER_DEV_UC_MAX	32
-#define EFX_EF10_FILTER_DEV_MC_MAX	256
-
 /* VLAN list entry */
 struct efx_ef10_vlan {
 	struct list_head list;
 	u16 vid;
 };
 
-enum efx_mcdi_filter_default_filters {
-	EFX_EF10_BCAST,
-	EFX_EF10_UCDEF,
-	EFX_EF10_MCDEF,
-	EFX_EF10_VXLAN4_UCDEF,
-	EFX_EF10_VXLAN4_MCDEF,
-	EFX_EF10_VXLAN6_UCDEF,
-	EFX_EF10_VXLAN6_MCDEF,
-	EFX_EF10_NVGRE4_UCDEF,
-	EFX_EF10_NVGRE4_MCDEF,
-	EFX_EF10_NVGRE6_UCDEF,
-	EFX_EF10_NVGRE6_MCDEF,
-	EFX_EF10_GENEVE4_UCDEF,
-	EFX_EF10_GENEVE4_MCDEF,
-	EFX_EF10_GENEVE6_UCDEF,
-	EFX_EF10_GENEVE6_MCDEF,
-
-	EFX_EF10_NUM_DEFAULT_FILTERS
-};
-
-/* Per-VLAN filters information */
-struct efx_mcdi_filter_vlan {
-	struct list_head list;
-	u16 vid;
-	u16 uc[EFX_EF10_FILTER_DEV_UC_MAX];
-	u16 mc[EFX_EF10_FILTER_DEV_MC_MAX];
-	u16 default_filters[EFX_EF10_NUM_DEFAULT_FILTERS];
-};
-
-struct efx_mcdi_dev_addr {
-	u8 addr[ETH_ALEN];
-};
-
-struct efx_mcdi_filter_table {
-/* The MCDI match masks supported by this fw & hw, in order of priority */
-	u32 rx_match_mcdi_flags[
-		MC_CMD_GET_PARSER_DISP_INFO_OUT_SUPPORTED_MATCHES_MAXNUM * 2];
-	unsigned int rx_match_count;
-
-	struct rw_semaphore lock; /* Protects entries */
-	struct {
-		unsigned long spec;	/* pointer to spec plus flag bits */
-/* AUTO_OLD is used to mark and sweep MAC filters for the device address lists. */
-/* unused flag	1UL */
-#define EFX_EF10_FILTER_FLAG_AUTO_OLD	2UL
-#define EFX_EF10_FILTER_FLAGS		3UL
-		u64 handle;		/* firmware handle */
-	} *entry;
-/* Shadow of net_device address lists, guarded by mac_lock */
-	struct efx_mcdi_dev_addr dev_uc_list[EFX_EF10_FILTER_DEV_UC_MAX];
-	struct efx_mcdi_dev_addr dev_mc_list[EFX_EF10_FILTER_DEV_MC_MAX];
-	int dev_uc_count;
-	int dev_mc_count;
-	bool uc_promisc;
-	bool mc_promisc;
-/* Whether in multicast promiscuous mode when last changed */
-	bool mc_promisc_last;
-	bool mc_overflow; /* Too many MC addrs; should always imply mc_promisc */
-	bool vlan_filter;
-	struct list_head vlan_list;
-};
-
 /* An arbitrary search limit for the software hash table */
 #define EFX_EF10_FILTER_SEARCH_LIMIT 200
 
-static void efx_mcdi_rx_free_indir_table(struct efx_nic *efx);
-static void efx_mcdi_filter_table_remove(struct efx_nic *efx);
-static int efx_mcdi_filter_add_vlan(struct efx_nic *efx, u16 vid);
 static void efx_mcdi_filter_del_vlan_internal(struct efx_nic *efx,
 					      struct efx_mcdi_filter_vlan *vlan);
-static void efx_mcdi_filter_del_vlan(struct efx_nic *efx, u16 vid);
 static int efx_ef10_set_udp_tnl_ports(struct efx_nic *efx, bool unloading);
 
 static u32 efx_ef10_filter_get_unsafe_id(u32 filter_id)
@@ -2513,8 +2431,7 @@ static void efx_ef10_tx_write(struct efx_tx_queue *tx_queue)
 					 RSS_MODE_HASH_ADDRS << MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_UDP_IPV6_RSS_MODE_LBN |\
 					 RSS_MODE_HASH_ADDRS << MC_CMD_RSS_CONTEXT_GET_FLAGS_OUT_OTHER_IPV6_RSS_MODE_LBN)
 
-static int efx_mcdi_get_rss_context_flags(struct efx_nic *efx, u32 context,
-					  u32 *flags)
+int efx_mcdi_get_rss_context_flags(struct efx_nic *efx, u32 context, u32 *flags)
 {
 	/* Firmware had a bug (sfc bug 61952) where it would not actually
 	 * fill in the flags field in the response to MC_CMD_RSS_CONTEXT_GET_FLAGS.
@@ -2560,8 +2477,8 @@ static int efx_mcdi_get_rss_context_flags(struct efx_nic *efx, u32 context,
  * Defaults are 4-tuple for TCP and 2-tuple for UDP and other-IP, so we
  * just need to set the UDP ports flags (for both IP versions).
  */
-static void efx_mcdi_set_rss_context_flags(struct efx_nic *efx,
-					   struct efx_rss_context *ctx)
+void efx_mcdi_set_rss_context_flags(struct efx_nic *efx,
+				    struct efx_rss_context *ctx)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_RSS_CONTEXT_SET_FLAGS_IN_LEN);
 	u32 flags;
@@ -2682,7 +2599,7 @@ static int efx_mcdi_filter_populate_rss_table(struct efx_nic *efx, u32 context,
 			    sizeof(keybuf), NULL, 0, NULL);
 }
 
-static void efx_mcdi_rx_free_indir_table(struct efx_nic *efx)
+void efx_mcdi_rx_free_indir_table(struct efx_nic *efx)
 {
 	int rc;
 
@@ -2758,10 +2675,10 @@ static int efx_mcdi_filter_rx_push_exclusive_rss_config(struct efx_nic *efx,
 	return rc;
 }
 
-static int efx_mcdi_rx_push_rss_context_config(struct efx_nic *efx,
-					       struct efx_rss_context *ctx,
-					       const u32 *rx_indir_table,
-					       const u8 *key)
+int efx_mcdi_rx_push_rss_context_config(struct efx_nic *efx,
+					struct efx_rss_context *ctx,
+					const u32 *rx_indir_table,
+					const u8 *key)
 {
 	int rc;
 
@@ -2788,8 +2705,8 @@ static int efx_mcdi_rx_push_rss_context_config(struct efx_nic *efx,
 	return 0;
 }
 
-static int efx_mcdi_rx_pull_rss_context_config(struct efx_nic *efx,
-					       struct efx_rss_context *ctx)
+int efx_mcdi_rx_pull_rss_context_config(struct efx_nic *efx,
+					struct efx_rss_context *ctx)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_RSS_CONTEXT_GET_TABLE_IN_LEN);
 	MCDI_DECLARE_BUF(tablebuf, MC_CMD_RSS_CONTEXT_GET_TABLE_OUT_LEN);
@@ -2840,7 +2757,7 @@ static int efx_mcdi_rx_pull_rss_context_config(struct efx_nic *efx,
 	return 0;
 }
 
-static int efx_mcdi_rx_pull_rss_config(struct efx_nic *efx)
+int efx_mcdi_rx_pull_rss_config(struct efx_nic *efx)
 {
 	int rc;
 
@@ -2850,7 +2767,7 @@ static int efx_mcdi_rx_pull_rss_config(struct efx_nic *efx)
 	return rc;
 }
 
-static void efx_mcdi_rx_restore_rss_contexts(struct efx_nic *efx)
+void efx_mcdi_rx_restore_rss_contexts(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	struct efx_rss_context *ctx;
@@ -2877,9 +2794,9 @@ static void efx_mcdi_rx_restore_rss_contexts(struct efx_nic *efx)
 	nic_data->must_restore_rss_contexts = false;
 }
 
-static int efx_mcdi_pf_rx_push_rss_config(struct efx_nic *efx, bool user,
-					  const u32 *rx_indir_table,
-					  const u8 *key)
+int efx_mcdi_pf_rx_push_rss_config(struct efx_nic *efx, bool user,
+				   const u32 *rx_indir_table,
+				   const u8 *key)
 {
 	int rc;
 
@@ -2927,11 +2844,11 @@ static int efx_mcdi_pf_rx_push_rss_config(struct efx_nic *efx, bool user,
 	return rc;
 }
 
-static int efx_mcdi_vf_rx_push_rss_config(struct efx_nic *efx, bool user,
-					  const u32 *rx_indir_table
-					  __attribute__ ((unused)),
-					  const u8 *key
-					  __attribute__ ((unused)))
+int efx_mcdi_vf_rx_push_rss_config(struct efx_nic *efx, bool user,
+				   const u32 *rx_indir_table
+				   __attribute__ ((unused)),
+				   const u8 *key
+				   __attribute__ ((unused)))
 {
 	if (user)
 		return -EOPNOTSUPP;
@@ -4197,9 +4114,9 @@ static s32 efx_mcdi_filter_insert_locked(struct efx_nic *efx,
 	return rc;
 }
 
-static s32 efx_mcdi_filter_insert(struct efx_nic *efx,
-				  struct efx_filter_spec *spec,
-				  bool replace_equal)
+s32 efx_mcdi_filter_insert(struct efx_nic *efx,
+			   struct efx_filter_spec *spec,
+			   bool replace_equal)
 {
 	s32 ret;
 
@@ -4210,11 +4127,6 @@ static s32 efx_mcdi_filter_insert(struct efx_nic *efx,
 	return ret;
 }
 
-static void efx_mcdi_update_rx_scatter(struct efx_nic *efx)
-{
-	/* no need to do anything here on EF10 */
-}
-
 /* Remove a filter.
  * If !by_index, remove by ID
  * If by_index, remove by index
@@ -4297,9 +4209,9 @@ static int efx_mcdi_filter_remove_internal(struct efx_nic *efx,
 	return rc;
 }
 
-static int efx_mcdi_filter_remove_safe(struct efx_nic *efx,
-				       enum efx_filter_priority priority,
-				       u32 filter_id)
+int efx_mcdi_filter_remove_safe(struct efx_nic *efx,
+				enum efx_filter_priority priority,
+				u32 filter_id)
 {
 	struct efx_mcdi_filter_table *table;
 	int rc;
@@ -4330,9 +4242,9 @@ static void efx_mcdi_filter_remove_unsafe(struct efx_nic *efx,
 	up_write(&table->lock);
 }
 
-static int efx_mcdi_filter_get_safe(struct efx_nic *efx,
-				    enum efx_filter_priority priority,
-				    u32 filter_id, struct efx_filter_spec *spec)
+int efx_mcdi_filter_get_safe(struct efx_nic *efx,
+			     enum efx_filter_priority priority,
+			     u32 filter_id, struct efx_filter_spec *spec)
 {
 	unsigned int filter_idx = efx_ef10_filter_get_unsafe_id(filter_id);
 	const struct efx_filter_spec *saved_spec;
@@ -4356,8 +4268,8 @@ static int efx_mcdi_filter_get_safe(struct efx_nic *efx,
 	return rc;
 }
 
-static int efx_mcdi_filter_clear_rx(struct efx_nic *efx,
-				    enum efx_filter_priority priority)
+int efx_mcdi_filter_clear_rx(struct efx_nic *efx,
+			     enum efx_filter_priority priority)
 {
 	struct efx_mcdi_filter_table *table;
 	unsigned int priority_mask;
@@ -4383,8 +4295,8 @@ static int efx_mcdi_filter_clear_rx(struct efx_nic *efx,
 	return rc;
 }
 
-static u32 efx_mcdi_filter_count_rx_used(struct efx_nic *efx,
-					 enum efx_filter_priority priority)
+u32 efx_mcdi_filter_count_rx_used(struct efx_nic *efx,
+				  enum efx_filter_priority priority)
 {
 	struct efx_mcdi_filter_table *table;
 	unsigned int filter_idx;
@@ -4404,16 +4316,16 @@ static u32 efx_mcdi_filter_count_rx_used(struct efx_nic *efx,
 	return count;
 }
 
-static u32 efx_mcdi_filter_get_rx_id_limit(struct efx_nic *efx)
+u32 efx_mcdi_filter_get_rx_id_limit(struct efx_nic *efx)
 {
 	struct efx_mcdi_filter_table *table = efx->filter_state;
 
 	return table->rx_match_count * EFX_MCDI_FILTER_TBL_ROWS * 2;
 }
 
-static s32 efx_mcdi_filter_get_rx_ids(struct efx_nic *efx,
-				      enum efx_filter_priority priority,
-				      u32 *buf, u32 size)
+s32 efx_mcdi_filter_get_rx_ids(struct efx_nic *efx,
+			       enum efx_filter_priority priority,
+			       u32 *buf, u32 size)
 {
 	struct efx_mcdi_filter_table *table;
 	struct efx_filter_spec *spec;
@@ -4444,8 +4356,8 @@ static s32 efx_mcdi_filter_get_rx_ids(struct efx_nic *efx,
 
 #ifdef CONFIG_RFS_ACCEL
 
-static bool efx_mcdi_filter_rfs_expire_one(struct efx_nic *efx, u32 flow_id,
-					   unsigned int filter_idx)
+bool efx_mcdi_filter_rfs_expire_one(struct efx_nic *efx, u32 flow_id,
+				    unsigned int filter_idx)
 {
 	struct efx_filter_spec *spec, saved_spec;
 	struct efx_mcdi_filter_table *table;
@@ -4569,7 +4481,7 @@ static int efx_mcdi_filter_match_flags_from_mcdi(bool encap, u32 mcdi_flags)
 	return match_flags;
 }
 
-static void efx_mcdi_filter_cleanup_vlans(struct efx_nic *efx)
+void efx_mcdi_filter_cleanup_vlans(struct efx_nic *efx)
 {
 	struct efx_mcdi_filter_table *table = efx->filter_state;
 	struct efx_mcdi_filter_vlan *vlan, *next_vlan;
@@ -4585,9 +4497,9 @@ static void efx_mcdi_filter_cleanup_vlans(struct efx_nic *efx)
 		efx_mcdi_filter_del_vlan_internal(efx, vlan);
 }
 
-static bool efx_mcdi_filter_match_supported(struct efx_mcdi_filter_table *table,
-					    bool encap,
-					    enum efx_filter_match_flags match_flags)
+bool efx_mcdi_filter_match_supported(struct efx_mcdi_filter_table *table,
+				     bool encap,
+				     enum efx_filter_match_flags match_flags)
 {
 	unsigned int match_pri;
 	int mf;
@@ -4653,7 +4565,7 @@ efx_mcdi_filter_table_probe_matches(struct efx_nic *efx,
 	return 0;
 }
 
-static int efx_mcdi_filter_table_probe(struct efx_nic *efx)
+int efx_mcdi_filter_table_probe(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	struct net_device *net_dev = efx->net_dev;
@@ -4726,7 +4638,7 @@ static int efx_mcdi_filter_table_probe(struct efx_nic *efx)
 /* Caller must hold efx->filter_sem for read if race against
  * efx_mcdi_filter_table_remove() is possible
  */
-static void efx_mcdi_filter_table_restore(struct efx_nic *efx)
+void efx_mcdi_filter_table_restore(struct efx_nic *efx)
 {
 	struct efx_mcdi_filter_table *table = efx->filter_state;
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
@@ -4822,7 +4734,7 @@ static void efx_mcdi_filter_table_restore(struct efx_nic *efx)
 		nic_data->must_restore_filters = false;
 }
 
-static void efx_mcdi_filter_table_remove(struct efx_nic *efx)
+void efx_mcdi_filter_table_remove(struct efx_nic *efx)
 {
 	struct efx_mcdi_filter_table *table = efx->filter_state;
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_FILTER_OP_EXT_IN_LEN);
@@ -5404,7 +5316,7 @@ static void efx_mcdi_filter_vlan_sync_rx_mode(struct efx_nic *efx,
 /* Caller must hold efx->filter_sem for read if race against
  * efx_mcdi_filter_table_remove() is possible
  */
-static void efx_mcdi_filter_sync_rx_mode(struct efx_nic *efx)
+void efx_mcdi_filter_sync_rx_mode(struct efx_nic *efx)
 {
 	struct efx_mcdi_filter_table *table = efx->filter_state;
 	struct net_device *net_dev = efx->net_dev;
@@ -5444,7 +5356,8 @@ static void efx_mcdi_filter_sync_rx_mode(struct efx_nic *efx)
 	table->mc_promisc_last = table->mc_promisc;
 }
 
-static struct efx_mcdi_filter_vlan *efx_mcdi_filter_find_vlan(struct efx_nic *efx, u16 vid)
+struct efx_mcdi_filter_vlan *efx_mcdi_filter_find_vlan(struct efx_nic *efx,
+						       u16 vid)
 {
 	struct efx_mcdi_filter_table *table = efx->filter_state;
 	struct efx_mcdi_filter_vlan *vlan;
@@ -5459,7 +5372,7 @@ static struct efx_mcdi_filter_vlan *efx_mcdi_filter_find_vlan(struct efx_nic *ef
 	return NULL;
 }
 
-static int efx_mcdi_filter_add_vlan(struct efx_nic *efx, u16 vid)
+int efx_mcdi_filter_add_vlan(struct efx_nic *efx, u16 vid)
 {
 	struct efx_mcdi_filter_table *table = efx->filter_state;
 	struct efx_mcdi_filter_vlan *vlan;
@@ -5521,7 +5434,7 @@ static void efx_mcdi_filter_del_vlan_internal(struct efx_nic *efx,
 	kfree(vlan);
 }
 
-static void efx_mcdi_filter_del_vlan(struct efx_nic *efx, u16 vid)
+void efx_mcdi_filter_del_vlan(struct efx_nic *efx, u16 vid)
 {
 	struct efx_mcdi_filter_vlan *vlan;
 
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.h b/drivers/net/ethernet/sfc/mcdi_filters.h
new file mode 100644
index 000000000000..1837f4f5d661
--- /dev/null
+++ b/drivers/net/ethernet/sfc/mcdi_filters.h
@@ -0,0 +1,159 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2019 Solarflare Communications Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+#ifndef EFX_MCDI_FILTERS_H
+#define EFX_MCDI_FILTERS_H
+
+#include "net_driver.h"
+#include "filter.h"
+#include "mcdi_pcol.h"
+
+#define EFX_EF10_FILTER_DEV_UC_MAX	32
+#define EFX_EF10_FILTER_DEV_MC_MAX	256
+
+enum efx_mcdi_filter_default_filters {
+	EFX_EF10_BCAST,
+	EFX_EF10_UCDEF,
+	EFX_EF10_MCDEF,
+	EFX_EF10_VXLAN4_UCDEF,
+	EFX_EF10_VXLAN4_MCDEF,
+	EFX_EF10_VXLAN6_UCDEF,
+	EFX_EF10_VXLAN6_MCDEF,
+	EFX_EF10_NVGRE4_UCDEF,
+	EFX_EF10_NVGRE4_MCDEF,
+	EFX_EF10_NVGRE6_UCDEF,
+	EFX_EF10_NVGRE6_MCDEF,
+	EFX_EF10_GENEVE4_UCDEF,
+	EFX_EF10_GENEVE4_MCDEF,
+	EFX_EF10_GENEVE6_UCDEF,
+	EFX_EF10_GENEVE6_MCDEF,
+
+	EFX_EF10_NUM_DEFAULT_FILTERS
+};
+
+/* Per-VLAN filters information */
+struct efx_mcdi_filter_vlan {
+	struct list_head list;
+	u16 vid;
+	u16 uc[EFX_EF10_FILTER_DEV_UC_MAX];
+	u16 mc[EFX_EF10_FILTER_DEV_MC_MAX];
+	u16 default_filters[EFX_EF10_NUM_DEFAULT_FILTERS];
+};
+
+struct efx_mcdi_dev_addr {
+	u8 addr[ETH_ALEN];
+};
+
+struct efx_mcdi_filter_table {
+/* The MCDI match masks supported by this fw & hw, in order of priority */
+	u32 rx_match_mcdi_flags[
+		MC_CMD_GET_PARSER_DISP_INFO_OUT_SUPPORTED_MATCHES_MAXNUM * 2];
+	unsigned int rx_match_count;
+
+	struct rw_semaphore lock; /* Protects entries */
+	struct {
+		unsigned long spec;	/* pointer to spec plus flag bits */
+/* AUTO_OLD is used to mark and sweep MAC filters for the device address lists. */
+/* unused flag	1UL */
+#define EFX_EF10_FILTER_FLAG_AUTO_OLD	2UL
+#define EFX_EF10_FILTER_FLAGS		3UL
+		u64 handle;		/* firmware handle */
+	} *entry;
+/* Shadow of net_device address lists, guarded by mac_lock */
+	struct efx_mcdi_dev_addr dev_uc_list[EFX_EF10_FILTER_DEV_UC_MAX];
+	struct efx_mcdi_dev_addr dev_mc_list[EFX_EF10_FILTER_DEV_MC_MAX];
+	int dev_uc_count;
+	int dev_mc_count;
+	bool uc_promisc;
+	bool mc_promisc;
+/* Whether in multicast promiscuous mode when last changed */
+	bool mc_promisc_last;
+	bool mc_overflow; /* Too many MC addrs; should always imply mc_promisc */
+	bool vlan_filter;
+	struct list_head vlan_list;
+};
+
+int efx_mcdi_filter_table_probe(struct efx_nic *efx);
+void efx_mcdi_filter_table_remove(struct efx_nic *efx);
+void efx_mcdi_filter_table_restore(struct efx_nic *efx);
+
+/*
+ * The filter table(s) are managed by firmware and we have write-only
+ * access.  When removing filters we must identify them to the
+ * firmware by a 64-bit handle, but this is too wide for Linux kernel
+ * interfaces (32-bit for RX NFC, 16-bit for RFS).  Also, we need to
+ * be able to tell in advance whether a requested insertion will
+ * replace an existing filter.  Therefore we maintain a software hash
+ * table, which should be at least as large as the hardware hash
+ * table.
+ *
+ * Huntington has a single 8K filter table shared between all filter
+ * types and both ports.
+ */
+#define EFX_MCDI_FILTER_TBL_ROWS 8192
+
+bool efx_mcdi_filter_match_supported(struct efx_mcdi_filter_table *table,
+				     bool encap,
+				     enum efx_filter_match_flags match_flags);
+
+void efx_mcdi_filter_sync_rx_mode(struct efx_nic *efx);
+s32 efx_mcdi_filter_insert(struct efx_nic *efx, struct efx_filter_spec *spec,
+			   bool replace_equal);
+int efx_mcdi_filter_remove_safe(struct efx_nic *efx,
+				enum efx_filter_priority priority,
+				u32 filter_id);
+int efx_mcdi_filter_get_safe(struct efx_nic *efx,
+			     enum efx_filter_priority priority,
+			     u32 filter_id, struct efx_filter_spec *spec);
+
+u32 efx_mcdi_filter_count_rx_used(struct efx_nic *efx,
+				  enum efx_filter_priority priority);
+int efx_mcdi_filter_clear_rx(struct efx_nic *efx,
+			     enum efx_filter_priority priority);
+u32 efx_mcdi_filter_get_rx_id_limit(struct efx_nic *efx);
+s32 efx_mcdi_filter_get_rx_ids(struct efx_nic *efx,
+			       enum efx_filter_priority priority,
+			       u32 *buf, u32 size);
+
+void efx_mcdi_filter_cleanup_vlans(struct efx_nic *efx);
+int efx_mcdi_filter_add_vlan(struct efx_nic *efx, u16 vid);
+struct efx_mcdi_filter_vlan *efx_mcdi_filter_find_vlan(struct efx_nic *efx, u16 vid);
+void efx_mcdi_filter_del_vlan(struct efx_nic *efx, u16 vid);
+
+void efx_mcdi_rx_free_indir_table(struct efx_nic *efx);
+int efx_mcdi_rx_push_rss_context_config(struct efx_nic *efx,
+					struct efx_rss_context *ctx,
+					const u32 *rx_indir_table,
+					const u8 *key);
+int efx_mcdi_pf_rx_push_rss_config(struct efx_nic *efx, bool user,
+				   const u32 *rx_indir_table,
+				   const u8 *key);
+int efx_mcdi_vf_rx_push_rss_config(struct efx_nic *efx, bool user,
+				   const u32 *rx_indir_table
+				   __attribute__ ((unused)),
+				   const u8 *key
+				   __attribute__ ((unused)));
+int efx_mcdi_rx_pull_rss_config(struct efx_nic *efx);
+int efx_mcdi_rx_pull_rss_context_config(struct efx_nic *efx,
+					struct efx_rss_context *ctx);
+int efx_mcdi_get_rss_context_flags(struct efx_nic *efx, u32 context,
+				   u32 *flags);
+void efx_mcdi_set_rss_context_flags(struct efx_nic *efx,
+				    struct efx_rss_context *ctx);
+void efx_mcdi_rx_restore_rss_contexts(struct efx_nic *efx);
+
+static inline void efx_mcdi_update_rx_scatter(struct efx_nic *efx)
+{
+	/* no need to do anything here */
+}
+
+bool efx_mcdi_filter_rfs_expire_one(struct efx_nic *efx, u32 flow_id,
+				    unsigned int filter_idx);
+
+#endif
-- 
2.20.1


