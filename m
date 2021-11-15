Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994EB450A7D
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbhKORJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbhKORJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:09:03 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727AFC061714
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:06:05 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id x131so15582676pfc.12
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=01X9gmLkMKgox/wEyV4guOom3H8aUHN/RQu2r2vtz/Q=;
        b=nQailH0O4yLZNM2DF3soDn68PyiVVFGr5N1yNw2ISFbZUBoVefRX6FZwlaSeZ+mHKI
         6FFG5wXA0qnM3xQIgWethDtJqEHctJrx54hIcwP9OCZRXDkI31sWZejj0Xg+HZzz/HHy
         zPW/1CW7v3IThHgB5R68aKc/lsXs9p8ErDT6XR1mbXa1YxOGe+2oJkbzGwe9+N44pcy/
         4sqf+Ky3jX2g2ZSRaXlLnLLkF/rIJ2VR/GyPxiH0VHvF2HLvmXd2B3H2vvpGV32Zyt3X
         2U+gHMdiyu6zee4bDw9HZPn7K8wb/bRQ+jNliZwyXZY8pkRnJNcCUFei4E09FLrT6sND
         uXRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=01X9gmLkMKgox/wEyV4guOom3H8aUHN/RQu2r2vtz/Q=;
        b=Tqjj7mIX3jWRiLEDUsd1ctJrNgcZKuPluY+3N7bJB7iR5t1Jxjeaqut+rAE3zyMKIq
         W9OGt5sy2u7KO3+IgDFBOo94dzafIh90KRSv5+IjjbO/QQytODz9/uYTVnU8OBYEqB/4
         onw8n07uYcD37ej9hE1C3+TUBt9adHf+8sj3L3wpFFTPOEhVaueZtV2u8N2nF2VZ9vE/
         V3fY1o+BE3B9+jI3EcAcFpxLrOlcXM0VKSmwcvQB8rYUgL7mDYri5k2y1WRs5+Hhh57y
         Pt+1NlzeI+QXt9f5K+Nmwn3jfOb3eWqDj8AcQT45KEtHm3LgMw1e0LXdj3gnIlHIVhP4
         7R0Q==
X-Gm-Message-State: AOAM532mMM6MeqMOb3ONwiShjaMI721skqbYZOv1mW0mpMboo+jut6aT
        9EbhCx3FKhPfqNl6iBcIiw4=
X-Google-Smtp-Source: ABdhPJyVuwvSkT5c7gPGWGs5TAG2mpMIhCN0IakeGROEGFCd6jo1U8gQE6yftA4pf1p/HfeXyJHSOQ==
X-Received: by 2002:a63:e40a:: with SMTP id a10mr202616pgi.299.1636995964395;
        Mon, 15 Nov 2021 09:06:04 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id y28sm15971845pfa.208.2021.11.15.09.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:06:04 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 4/4] net: gro: populate net/core/gro.c
Date:   Mon, 15 Nov 2021 09:05:54 -0800
Message-Id: <20211115170554.3645322-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115170554.3645322-1-eric.dumazet@gmail.com>
References: <20211115170554.3645322-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Move gro code and data from net/core/dev.c to net/core/gro.c
to ease maintenance.

gro_normal_list() and gro_normal_one() are inlined
because they are called from both files.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h |   1 +
 include/net/gro.h         |  22 ++
 net/core/dev.c            | 668 +-------------------------------------
 net/core/gro.c            | 648 ++++++++++++++++++++++++++++++++++++
 4 files changed, 672 insertions(+), 667 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 93d397db9ec417b92192296374ebc672bde557a3..31a7e6b2768123021690a3dc8572c5e8cb0e0027 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3657,6 +3657,7 @@ int netif_rx_ni(struct sk_buff *skb);
 int netif_rx_any_context(struct sk_buff *skb);
 int netif_receive_skb(struct sk_buff *skb);
 int netif_receive_skb_core(struct sk_buff *skb);
+void netif_receive_skb_list_internal(struct list_head *head);
 void netif_receive_skb_list(struct list_head *head);
 gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb);
 void napi_gro_flush(struct napi_struct *napi, bool flush_old);
diff --git a/include/net/gro.h b/include/net/gro.h
index f988bf3440f8972151848d6321713b1a0184df59..d0e7df691a807410049508355230a4523af590a1 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -416,4 +416,26 @@ static inline __wsum ip6_gro_compute_pseudo(struct sk_buff *skb, int proto)
 
 int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb);
 
+/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
+static inline void gro_normal_list(struct napi_struct *napi)
+{
+	if (!napi->rx_count)
+		return;
+	netif_receive_skb_list_internal(&napi->rx_list);
+	INIT_LIST_HEAD(&napi->rx_list);
+	napi->rx_count = 0;
+}
+
+/* Queue one GRO_NORMAL SKB up for list processing. If batch size exceeded,
+ * pass the whole batch up to the stack.
+ */
+static inline void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb, int segs)
+{
+	list_add_tail(&skb->list, &napi->rx_list);
+	napi->rx_count += segs;
+	if (napi->rx_count >= gro_normal_batch)
+		gro_normal_list(napi);
+}
+
+
 #endif /* _NET_IPV6_GRO_H */
diff --git a/net/core/dev.c b/net/core/dev.c
index 15ac064b5562d7b99f885610a3d12733b63aa325..92c9258cbf28556e68f9112343f5ebc98b2c163b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -153,16 +153,10 @@
 
 #include "net-sysfs.h"
 
-#define MAX_GRO_SKBS 8
-
-/* This should be increased if a protocol with a bigger head is added. */
-#define GRO_MAX_HEAD (MAX_HEADER + 128)
 
 static DEFINE_SPINLOCK(ptype_lock);
-static DEFINE_SPINLOCK(offload_lock);
 struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
 struct list_head ptype_all __read_mostly;	/* Taps */
-static struct list_head offload_base __read_mostly;
 
 static int netif_rx_internal(struct sk_buff *skb);
 static int call_netdevice_notifiers_info(unsigned long val,
@@ -604,84 +598,6 @@ void dev_remove_pack(struct packet_type *pt)
 EXPORT_SYMBOL(dev_remove_pack);
 
 
-/**
- *	dev_add_offload - register offload handlers
- *	@po: protocol offload declaration
- *
- *	Add protocol offload handlers to the networking stack. The passed
- *	&proto_offload is linked into kernel lists and may not be freed until
- *	it has been removed from the kernel lists.
- *
- *	This call does not sleep therefore it can not
- *	guarantee all CPU's that are in middle of receiving packets
- *	will see the new offload handlers (until the next received packet).
- */
-void dev_add_offload(struct packet_offload *po)
-{
-	struct packet_offload *elem;
-
-	spin_lock(&offload_lock);
-	list_for_each_entry(elem, &offload_base, list) {
-		if (po->priority < elem->priority)
-			break;
-	}
-	list_add_rcu(&po->list, elem->list.prev);
-	spin_unlock(&offload_lock);
-}
-EXPORT_SYMBOL(dev_add_offload);
-
-/**
- *	__dev_remove_offload	 - remove offload handler
- *	@po: packet offload declaration
- *
- *	Remove a protocol offload handler that was previously added to the
- *	kernel offload handlers by dev_add_offload(). The passed &offload_type
- *	is removed from the kernel lists and can be freed or reused once this
- *	function returns.
- *
- *      The packet type might still be in use by receivers
- *	and must not be freed until after all the CPU's have gone
- *	through a quiescent state.
- */
-static void __dev_remove_offload(struct packet_offload *po)
-{
-	struct list_head *head = &offload_base;
-	struct packet_offload *po1;
-
-	spin_lock(&offload_lock);
-
-	list_for_each_entry(po1, head, list) {
-		if (po == po1) {
-			list_del_rcu(&po->list);
-			goto out;
-		}
-	}
-
-	pr_warn("dev_remove_offload: %p not found\n", po);
-out:
-	spin_unlock(&offload_lock);
-}
-
-/**
- *	dev_remove_offload	 - remove packet offload handler
- *	@po: packet offload declaration
- *
- *	Remove a packet offload handler that was previously added to the kernel
- *	offload handlers by dev_add_offload(). The passed &offload_type is
- *	removed from the kernel lists and can be freed or reused once this
- *	function returns.
- *
- *	This call sleeps to guarantee that no CPU is looking at the packet
- *	type after return.
- */
-void dev_remove_offload(struct packet_offload *po)
-{
-	__dev_remove_offload(po);
-
-	synchronize_net();
-}
-EXPORT_SYMBOL(dev_remove_offload);
-
 /*******************************************************************************
  *
  *			    Device Interface Subroutines
@@ -3315,40 +3231,6 @@ __be16 skb_network_protocol(struct sk_buff *skb, int *depth)
 	return __vlan_get_protocol(skb, type, depth);
 }
 
-/**
- *	skb_mac_gso_segment - mac layer segmentation handler.
- *	@skb: buffer to segment
- *	@features: features for the output path (see dev->features)
- */
-struct sk_buff *skb_mac_gso_segment(struct sk_buff *skb,
-				    netdev_features_t features)
-{
-	struct sk_buff *segs = ERR_PTR(-EPROTONOSUPPORT);
-	struct packet_offload *ptype;
-	int vlan_depth = skb->mac_len;
-	__be16 type = skb_network_protocol(skb, &vlan_depth);
-
-	if (unlikely(!type))
-		return ERR_PTR(-EINVAL);
-
-	__skb_pull(skb, vlan_depth);
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(ptype, &offload_base, list) {
-		if (ptype->type == type && ptype->callbacks.gso_segment) {
-			segs = ptype->callbacks.gso_segment(skb, features);
-			break;
-		}
-	}
-	rcu_read_unlock();
-
-	__skb_push(skb, skb->data - skb_mac_header(skb));
-
-	return segs;
-}
-EXPORT_SYMBOL(skb_mac_gso_segment);
-
-
 /* openvswitch calls this on rx path, so we need a different check.
  */
 static inline bool skb_needs_check(struct sk_buff *skb, bool tx_path)
@@ -4320,8 +4202,6 @@ int dev_weight_rx_bias __read_mostly = 1;  /* bias for backlog weight */
 int dev_weight_tx_bias __read_mostly = 1;  /* bias for output_queue quota */
 int dev_rx_weight __read_mostly = 64;
 int dev_tx_weight __read_mostly = 64;
-/* Maximum number of GRO_NORMAL skbs to batch up for list-RX */
-int gro_normal_batch __read_mostly = 8;
 
 /* Called with irq disabled */
 static inline void ____napi_schedule(struct softnet_data *sd,
@@ -5664,7 +5544,7 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 	return ret;
 }
 
-static void netif_receive_skb_list_internal(struct list_head *head)
+void netif_receive_skb_list_internal(struct list_head *head)
 {
 	struct sk_buff *skb, *next;
 	struct list_head sublist;
@@ -5842,550 +5722,6 @@ static void flush_all_backlogs(void)
 	cpus_read_unlock();
 }
 
-/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
-static void gro_normal_list(struct napi_struct *napi)
-{
-	if (!napi->rx_count)
-		return;
-	netif_receive_skb_list_internal(&napi->rx_list);
-	INIT_LIST_HEAD(&napi->rx_list);
-	napi->rx_count = 0;
-}
-
-/* Queue one GRO_NORMAL SKB up for list processing. If batch size exceeded,
- * pass the whole batch up to the stack.
- */
-static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb, int segs)
-{
-	list_add_tail(&skb->list, &napi->rx_list);
-	napi->rx_count += segs;
-	if (napi->rx_count >= gro_normal_batch)
-		gro_normal_list(napi);
-}
-
-static void napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
-{
-	struct packet_offload *ptype;
-	__be16 type = skb->protocol;
-	struct list_head *head = &offload_base;
-	int err = -ENOENT;
-
-	BUILD_BUG_ON(sizeof(struct napi_gro_cb) > sizeof(skb->cb));
-
-	if (NAPI_GRO_CB(skb)->count == 1) {
-		skb_shinfo(skb)->gso_size = 0;
-		goto out;
-	}
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(ptype, head, list) {
-		if (ptype->type != type || !ptype->callbacks.gro_complete)
-			continue;
-
-		err = INDIRECT_CALL_INET(ptype->callbacks.gro_complete,
-					 ipv6_gro_complete, inet_gro_complete,
-					 skb, 0);
-		break;
-	}
-	rcu_read_unlock();
-
-	if (err) {
-		WARN_ON(&ptype->list == head);
-		kfree_skb(skb);
-		return;
-	}
-
-out:
-	gro_normal_one(napi, skb, NAPI_GRO_CB(skb)->count);
-}
-
-static void __napi_gro_flush_chain(struct napi_struct *napi, u32 index,
-				   bool flush_old)
-{
-	struct list_head *head = &napi->gro_hash[index].list;
-	struct sk_buff *skb, *p;
-
-	list_for_each_entry_safe_reverse(skb, p, head, list) {
-		if (flush_old && NAPI_GRO_CB(skb)->age == jiffies)
-			return;
-		skb_list_del_init(skb);
-		napi_gro_complete(napi, skb);
-		napi->gro_hash[index].count--;
-	}
-
-	if (!napi->gro_hash[index].count)
-		__clear_bit(index, &napi->gro_bitmask);
-}
-
-/* napi->gro_hash[].list contains packets ordered by age.
- * youngest packets at the head of it.
- * Complete skbs in reverse order to reduce latencies.
- */
-void napi_gro_flush(struct napi_struct *napi, bool flush_old)
-{
-	unsigned long bitmask = napi->gro_bitmask;
-	unsigned int i, base = ~0U;
-
-	while ((i = ffs(bitmask)) != 0) {
-		bitmask >>= i;
-		base += i;
-		__napi_gro_flush_chain(napi, base, flush_old);
-	}
-}
-EXPORT_SYMBOL(napi_gro_flush);
-
-static void gro_list_prepare(const struct list_head *head,
-			     const struct sk_buff *skb)
-{
-	unsigned int maclen = skb->dev->hard_header_len;
-	u32 hash = skb_get_hash_raw(skb);
-	struct sk_buff *p;
-
-	list_for_each_entry(p, head, list) {
-		unsigned long diffs;
-
-		NAPI_GRO_CB(p)->flush = 0;
-
-		if (hash != skb_get_hash_raw(p)) {
-			NAPI_GRO_CB(p)->same_flow = 0;
-			continue;
-		}
-
-		diffs = (unsigned long)p->dev ^ (unsigned long)skb->dev;
-		diffs |= skb_vlan_tag_present(p) ^ skb_vlan_tag_present(skb);
-		if (skb_vlan_tag_present(p))
-			diffs |= skb_vlan_tag_get(p) ^ skb_vlan_tag_get(skb);
-		diffs |= skb_metadata_differs(p, skb);
-		if (maclen == ETH_HLEN)
-			diffs |= compare_ether_header(skb_mac_header(p),
-						      skb_mac_header(skb));
-		else if (!diffs)
-			diffs = memcmp(skb_mac_header(p),
-				       skb_mac_header(skb),
-				       maclen);
-
-		/* in most common scenarions 'slow_gro' is 0
-		 * otherwise we are already on some slower paths
-		 * either skip all the infrequent tests altogether or
-		 * avoid trying too hard to skip each of them individually
-		 */
-		if (!diffs && unlikely(skb->slow_gro | p->slow_gro)) {
-#if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-			struct tc_skb_ext *skb_ext;
-			struct tc_skb_ext *p_ext;
-#endif
-
-			diffs |= p->sk != skb->sk;
-			diffs |= skb_metadata_dst_cmp(p, skb);
-			diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
-
-#if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-			skb_ext = skb_ext_find(skb, TC_SKB_EXT);
-			p_ext = skb_ext_find(p, TC_SKB_EXT);
-
-			diffs |= (!!p_ext) ^ (!!skb_ext);
-			if (!diffs && unlikely(skb_ext))
-				diffs |= p_ext->chain ^ skb_ext->chain;
-#endif
-		}
-
-		NAPI_GRO_CB(p)->same_flow = !diffs;
-	}
-}
-
-static inline void skb_gro_reset_offset(struct sk_buff *skb, u32 nhoff)
-{
-	const struct skb_shared_info *pinfo = skb_shinfo(skb);
-	const skb_frag_t *frag0 = &pinfo->frags[0];
-
-	NAPI_GRO_CB(skb)->data_offset = 0;
-	NAPI_GRO_CB(skb)->frag0 = NULL;
-	NAPI_GRO_CB(skb)->frag0_len = 0;
-
-	if (!skb_headlen(skb) && pinfo->nr_frags &&
-	    !PageHighMem(skb_frag_page(frag0)) &&
-	    (!NET_IP_ALIGN || !((skb_frag_off(frag0) + nhoff) & 3))) {
-		NAPI_GRO_CB(skb)->frag0 = skb_frag_address(frag0);
-		NAPI_GRO_CB(skb)->frag0_len = min_t(unsigned int,
-						    skb_frag_size(frag0),
-						    skb->end - skb->tail);
-	}
-}
-
-static void gro_pull_from_frag0(struct sk_buff *skb, int grow)
-{
-	struct skb_shared_info *pinfo = skb_shinfo(skb);
-
-	BUG_ON(skb->end - skb->tail < grow);
-
-	memcpy(skb_tail_pointer(skb), NAPI_GRO_CB(skb)->frag0, grow);
-
-	skb->data_len -= grow;
-	skb->tail += grow;
-
-	skb_frag_off_add(&pinfo->frags[0], grow);
-	skb_frag_size_sub(&pinfo->frags[0], grow);
-
-	if (unlikely(!skb_frag_size(&pinfo->frags[0]))) {
-		skb_frag_unref(skb, 0);
-		memmove(pinfo->frags, pinfo->frags + 1,
-			--pinfo->nr_frags * sizeof(pinfo->frags[0]));
-	}
-}
-
-static void gro_flush_oldest(struct napi_struct *napi, struct list_head *head)
-{
-	struct sk_buff *oldest;
-
-	oldest = list_last_entry(head, struct sk_buff, list);
-
-	/* We are called with head length >= MAX_GRO_SKBS, so this is
-	 * impossible.
-	 */
-	if (WARN_ON_ONCE(!oldest))
-		return;
-
-	/* Do not adjust napi->gro_hash[].count, caller is adding a new
-	 * SKB to the chain.
-	 */
-	skb_list_del_init(oldest);
-	napi_gro_complete(napi, oldest);
-}
-
-static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
-{
-	u32 bucket = skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
-	struct gro_list *gro_list = &napi->gro_hash[bucket];
-	struct list_head *head = &offload_base;
-	struct packet_offload *ptype;
-	__be16 type = skb->protocol;
-	struct sk_buff *pp = NULL;
-	enum gro_result ret;
-	int same_flow;
-	int grow;
-
-	if (netif_elide_gro(skb->dev))
-		goto normal;
-
-	gro_list_prepare(&gro_list->list, skb);
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(ptype, head, list) {
-		if (ptype->type != type || !ptype->callbacks.gro_receive)
-			continue;
-
-		skb_set_network_header(skb, skb_gro_offset(skb));
-		skb_reset_mac_len(skb);
-		NAPI_GRO_CB(skb)->same_flow = 0;
-		NAPI_GRO_CB(skb)->flush = skb_is_gso(skb) || skb_has_frag_list(skb);
-		NAPI_GRO_CB(skb)->free = 0;
-		NAPI_GRO_CB(skb)->encap_mark = 0;
-		NAPI_GRO_CB(skb)->recursion_counter = 0;
-		NAPI_GRO_CB(skb)->is_fou = 0;
-		NAPI_GRO_CB(skb)->is_atomic = 1;
-		NAPI_GRO_CB(skb)->gro_remcsum_start = 0;
-
-		/* Setup for GRO checksum validation */
-		switch (skb->ip_summed) {
-		case CHECKSUM_COMPLETE:
-			NAPI_GRO_CB(skb)->csum = skb->csum;
-			NAPI_GRO_CB(skb)->csum_valid = 1;
-			NAPI_GRO_CB(skb)->csum_cnt = 0;
-			break;
-		case CHECKSUM_UNNECESSARY:
-			NAPI_GRO_CB(skb)->csum_cnt = skb->csum_level + 1;
-			NAPI_GRO_CB(skb)->csum_valid = 0;
-			break;
-		default:
-			NAPI_GRO_CB(skb)->csum_cnt = 0;
-			NAPI_GRO_CB(skb)->csum_valid = 0;
-		}
-
-		pp = INDIRECT_CALL_INET(ptype->callbacks.gro_receive,
-					ipv6_gro_receive, inet_gro_receive,
-					&gro_list->list, skb);
-		break;
-	}
-	rcu_read_unlock();
-
-	if (&ptype->list == head)
-		goto normal;
-
-	if (PTR_ERR(pp) == -EINPROGRESS) {
-		ret = GRO_CONSUMED;
-		goto ok;
-	}
-
-	same_flow = NAPI_GRO_CB(skb)->same_flow;
-	ret = NAPI_GRO_CB(skb)->free ? GRO_MERGED_FREE : GRO_MERGED;
-
-	if (pp) {
-		skb_list_del_init(pp);
-		napi_gro_complete(napi, pp);
-		gro_list->count--;
-	}
-
-	if (same_flow)
-		goto ok;
-
-	if (NAPI_GRO_CB(skb)->flush)
-		goto normal;
-
-	if (unlikely(gro_list->count >= MAX_GRO_SKBS))
-		gro_flush_oldest(napi, &gro_list->list);
-	else
-		gro_list->count++;
-
-	NAPI_GRO_CB(skb)->count = 1;
-	NAPI_GRO_CB(skb)->age = jiffies;
-	NAPI_GRO_CB(skb)->last = skb;
-	skb_shinfo(skb)->gso_size = skb_gro_len(skb);
-	list_add(&skb->list, &gro_list->list);
-	ret = GRO_HELD;
-
-pull:
-	grow = skb_gro_offset(skb) - skb_headlen(skb);
-	if (grow > 0)
-		gro_pull_from_frag0(skb, grow);
-ok:
-	if (gro_list->count) {
-		if (!test_bit(bucket, &napi->gro_bitmask))
-			__set_bit(bucket, &napi->gro_bitmask);
-	} else if (test_bit(bucket, &napi->gro_bitmask)) {
-		__clear_bit(bucket, &napi->gro_bitmask);
-	}
-
-	return ret;
-
-normal:
-	ret = GRO_NORMAL;
-	goto pull;
-}
-
-struct packet_offload *gro_find_receive_by_type(__be16 type)
-{
-	struct list_head *offload_head = &offload_base;
-	struct packet_offload *ptype;
-
-	list_for_each_entry_rcu(ptype, offload_head, list) {
-		if (ptype->type != type || !ptype->callbacks.gro_receive)
-			continue;
-		return ptype;
-	}
-	return NULL;
-}
-EXPORT_SYMBOL(gro_find_receive_by_type);
-
-struct packet_offload *gro_find_complete_by_type(__be16 type)
-{
-	struct list_head *offload_head = &offload_base;
-	struct packet_offload *ptype;
-
-	list_for_each_entry_rcu(ptype, offload_head, list) {
-		if (ptype->type != type || !ptype->callbacks.gro_complete)
-			continue;
-		return ptype;
-	}
-	return NULL;
-}
-EXPORT_SYMBOL(gro_find_complete_by_type);
-
-static gro_result_t napi_skb_finish(struct napi_struct *napi,
-				    struct sk_buff *skb,
-				    gro_result_t ret)
-{
-	switch (ret) {
-	case GRO_NORMAL:
-		gro_normal_one(napi, skb, 1);
-		break;
-
-	case GRO_MERGED_FREE:
-		if (NAPI_GRO_CB(skb)->free == NAPI_GRO_FREE_STOLEN_HEAD)
-			napi_skb_free_stolen_head(skb);
-		else if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
-			__kfree_skb(skb);
-		else
-			__kfree_skb_defer(skb);
-		break;
-
-	case GRO_HELD:
-	case GRO_MERGED:
-	case GRO_CONSUMED:
-		break;
-	}
-
-	return ret;
-}
-
-gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
-{
-	gro_result_t ret;
-
-	skb_mark_napi_id(skb, napi);
-	trace_napi_gro_receive_entry(skb);
-
-	skb_gro_reset_offset(skb, 0);
-
-	ret = napi_skb_finish(napi, skb, dev_gro_receive(napi, skb));
-	trace_napi_gro_receive_exit(ret);
-
-	return ret;
-}
-EXPORT_SYMBOL(napi_gro_receive);
-
-static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
-{
-	if (unlikely(skb->pfmemalloc)) {
-		consume_skb(skb);
-		return;
-	}
-	__skb_pull(skb, skb_headlen(skb));
-	/* restore the reserve we had after netdev_alloc_skb_ip_align() */
-	skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN - skb_headroom(skb));
-	__vlan_hwaccel_clear_tag(skb);
-	skb->dev = napi->dev;
-	skb->skb_iif = 0;
-
-	/* eth_type_trans() assumes pkt_type is PACKET_HOST */
-	skb->pkt_type = PACKET_HOST;
-
-	skb->encapsulation = 0;
-	skb_shinfo(skb)->gso_type = 0;
-	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
-	if (unlikely(skb->slow_gro)) {
-		skb_orphan(skb);
-		skb_ext_reset(skb);
-		nf_reset_ct(skb);
-		skb->slow_gro = 0;
-	}
-
-	napi->skb = skb;
-}
-
-struct sk_buff *napi_get_frags(struct napi_struct *napi)
-{
-	struct sk_buff *skb = napi->skb;
-
-	if (!skb) {
-		skb = napi_alloc_skb(napi, GRO_MAX_HEAD);
-		if (skb) {
-			napi->skb = skb;
-			skb_mark_napi_id(skb, napi);
-		}
-	}
-	return skb;
-}
-EXPORT_SYMBOL(napi_get_frags);
-
-static gro_result_t napi_frags_finish(struct napi_struct *napi,
-				      struct sk_buff *skb,
-				      gro_result_t ret)
-{
-	switch (ret) {
-	case GRO_NORMAL:
-	case GRO_HELD:
-		__skb_push(skb, ETH_HLEN);
-		skb->protocol = eth_type_trans(skb, skb->dev);
-		if (ret == GRO_NORMAL)
-			gro_normal_one(napi, skb, 1);
-		break;
-
-	case GRO_MERGED_FREE:
-		if (NAPI_GRO_CB(skb)->free == NAPI_GRO_FREE_STOLEN_HEAD)
-			napi_skb_free_stolen_head(skb);
-		else
-			napi_reuse_skb(napi, skb);
-		break;
-
-	case GRO_MERGED:
-	case GRO_CONSUMED:
-		break;
-	}
-
-	return ret;
-}
-
-/* Upper GRO stack assumes network header starts at gro_offset=0
- * Drivers could call both napi_gro_frags() and napi_gro_receive()
- * We copy ethernet header into skb->data to have a common layout.
- */
-static struct sk_buff *napi_frags_skb(struct napi_struct *napi)
-{
-	struct sk_buff *skb = napi->skb;
-	const struct ethhdr *eth;
-	unsigned int hlen = sizeof(*eth);
-
-	napi->skb = NULL;
-
-	skb_reset_mac_header(skb);
-	skb_gro_reset_offset(skb, hlen);
-
-	if (unlikely(skb_gro_header_hard(skb, hlen))) {
-		eth = skb_gro_header_slow(skb, hlen, 0);
-		if (unlikely(!eth)) {
-			net_warn_ratelimited("%s: dropping impossible skb from %s\n",
-					     __func__, napi->dev->name);
-			napi_reuse_skb(napi, skb);
-			return NULL;
-		}
-	} else {
-		eth = (const struct ethhdr *)skb->data;
-		gro_pull_from_frag0(skb, hlen);
-		NAPI_GRO_CB(skb)->frag0 += hlen;
-		NAPI_GRO_CB(skb)->frag0_len -= hlen;
-	}
-	__skb_pull(skb, hlen);
-
-	/*
-	 * This works because the only protocols we care about don't require
-	 * special handling.
-	 * We'll fix it up properly in napi_frags_finish()
-	 */
-	skb->protocol = eth->h_proto;
-
-	return skb;
-}
-
-gro_result_t napi_gro_frags(struct napi_struct *napi)
-{
-	gro_result_t ret;
-	struct sk_buff *skb = napi_frags_skb(napi);
-
-	trace_napi_gro_frags_entry(skb);
-
-	ret = napi_frags_finish(napi, skb, dev_gro_receive(napi, skb));
-	trace_napi_gro_frags_exit(ret);
-
-	return ret;
-}
-EXPORT_SYMBOL(napi_gro_frags);
-
-/* Compute the checksum from gro_offset and return the folded value
- * after adding in any pseudo checksum.
- */
-__sum16 __skb_gro_checksum_complete(struct sk_buff *skb)
-{
-	__wsum wsum;
-	__sum16 sum;
-
-	wsum = skb_checksum(skb, skb_gro_offset(skb), skb_gro_len(skb), 0);
-
-	/* NAPI_GRO_CB(skb)->csum holds pseudo checksum */
-	sum = csum_fold(csum_add(NAPI_GRO_CB(skb)->csum, wsum));
-	/* See comments in __skb_checksum_complete(). */
-	if (likely(!sum)) {
-		if (unlikely(skb->ip_summed == CHECKSUM_COMPLETE) &&
-		    !skb->csum_complete_sw)
-			netdev_rx_csum_fault(skb->dev, skb);
-	}
-
-	NAPI_GRO_CB(skb)->csum = wsum;
-	NAPI_GRO_CB(skb)->csum_valid = 1;
-
-	return sum;
-}
-EXPORT_SYMBOL(__skb_gro_checksum_complete);
-
 static void net_rps_send_ipi(struct softnet_data *remsd)
 {
 #ifdef CONFIG_RPS
@@ -11640,8 +10976,6 @@ static int __init net_dev_init(void)
 	for (i = 0; i < PTYPE_HASH_SIZE; i++)
 		INIT_LIST_HEAD(&ptype_base[i]);
 
-	INIT_LIST_HEAD(&offload_base);
-
 	if (register_pernet_subsys(&netdev_net_ops))
 		goto out;
 
diff --git a/net/core/gro.c b/net/core/gro.c
index 91a74c4da9ff5b6ba50382a593ef12b43b16d20b..8ec8b44596da9c12adf7b4875e3e1a119ff8e72f 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -1,5 +1,129 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 #include <net/gro.h>
+#include <net/dst_metadata.h>
+#include <net/busy_poll.h>
+#include <trace/events/net.h>
+
+#define MAX_GRO_SKBS 8
+
+/* This should be increased if a protocol with a bigger head is added. */
+#define GRO_MAX_HEAD (MAX_HEADER + 128)
+
+static DEFINE_SPINLOCK(offload_lock);
+static struct list_head offload_base __read_mostly = LIST_HEAD_INIT(offload_base);
+/* Maximum number of GRO_NORMAL skbs to batch up for list-RX */
+int gro_normal_batch __read_mostly = 8;
+
+/**
+ *	dev_add_offload - register offload handlers
+ *	@po: protocol offload declaration
+ *
+ *	Add protocol offload handlers to the networking stack. The passed
+ *	&proto_offload is linked into kernel lists and may not be freed until
+ *	it has been removed from the kernel lists.
+ *
+ *	This call does not sleep therefore it can not
+ *	guarantee all CPU's that are in middle of receiving packets
+ *	will see the new offload handlers (until the next received packet).
+ */
+void dev_add_offload(struct packet_offload *po)
+{
+	struct packet_offload *elem;
+
+	spin_lock(&offload_lock);
+	list_for_each_entry(elem, &offload_base, list) {
+		if (po->priority < elem->priority)
+			break;
+	}
+	list_add_rcu(&po->list, elem->list.prev);
+	spin_unlock(&offload_lock);
+}
+EXPORT_SYMBOL(dev_add_offload);
+
+/**
+ *	__dev_remove_offload	 - remove offload handler
+ *	@po: packet offload declaration
+ *
+ *	Remove a protocol offload handler that was previously added to the
+ *	kernel offload handlers by dev_add_offload(). The passed &offload_type
+ *	is removed from the kernel lists and can be freed or reused once this
+ *	function returns.
+ *
+ *      The packet type might still be in use by receivers
+ *	and must not be freed until after all the CPU's have gone
+ *	through a quiescent state.
+ */
+static void __dev_remove_offload(struct packet_offload *po)
+{
+	struct list_head *head = &offload_base;
+	struct packet_offload *po1;
+
+	spin_lock(&offload_lock);
+
+	list_for_each_entry(po1, head, list) {
+		if (po == po1) {
+			list_del_rcu(&po->list);
+			goto out;
+		}
+	}
+
+	pr_warn("dev_remove_offload: %p not found\n", po);
+out:
+	spin_unlock(&offload_lock);
+}
+
+/**
+ *	dev_remove_offload	 - remove packet offload handler
+ *	@po: packet offload declaration
+ *
+ *	Remove a packet offload handler that was previously added to the kernel
+ *	offload handlers by dev_add_offload(). The passed &offload_type is
+ *	removed from the kernel lists and can be freed or reused once this
+ *	function returns.
+ *
+ *	This call sleeps to guarantee that no CPU is looking at the packet
+ *	type after return.
+ */
+void dev_remove_offload(struct packet_offload *po)
+{
+	__dev_remove_offload(po);
+
+	synchronize_net();
+}
+EXPORT_SYMBOL(dev_remove_offload);
+
+/**
+ *	skb_mac_gso_segment - mac layer segmentation handler.
+ *	@skb: buffer to segment
+ *	@features: features for the output path (see dev->features)
+ */
+struct sk_buff *skb_mac_gso_segment(struct sk_buff *skb,
+				    netdev_features_t features)
+{
+	struct sk_buff *segs = ERR_PTR(-EPROTONOSUPPORT);
+	struct packet_offload *ptype;
+	int vlan_depth = skb->mac_len;
+	__be16 type = skb_network_protocol(skb, &vlan_depth);
+
+	if (unlikely(!type))
+		return ERR_PTR(-EINVAL);
+
+	__skb_pull(skb, vlan_depth);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ptype, &offload_base, list) {
+		if (ptype->type == type && ptype->callbacks.gso_segment) {
+			segs = ptype->callbacks.gso_segment(skb, features);
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	__skb_push(skb, skb->data - skb_mac_header(skb));
+
+	return segs;
+}
+EXPORT_SYMBOL(skb_mac_gso_segment);
 
 int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 {
@@ -116,3 +240,527 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	NAPI_GRO_CB(skb)->same_flow = 1;
 	return 0;
 }
+
+
+static void napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
+{
+	struct packet_offload *ptype;
+	__be16 type = skb->protocol;
+	struct list_head *head = &offload_base;
+	int err = -ENOENT;
+
+	BUILD_BUG_ON(sizeof(struct napi_gro_cb) > sizeof(skb->cb));
+
+	if (NAPI_GRO_CB(skb)->count == 1) {
+		skb_shinfo(skb)->gso_size = 0;
+		goto out;
+	}
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ptype, head, list) {
+		if (ptype->type != type || !ptype->callbacks.gro_complete)
+			continue;
+
+		err = INDIRECT_CALL_INET(ptype->callbacks.gro_complete,
+					 ipv6_gro_complete, inet_gro_complete,
+					 skb, 0);
+		break;
+	}
+	rcu_read_unlock();
+
+	if (err) {
+		WARN_ON(&ptype->list == head);
+		kfree_skb(skb);
+		return;
+	}
+
+out:
+	gro_normal_one(napi, skb, NAPI_GRO_CB(skb)->count);
+}
+
+static void __napi_gro_flush_chain(struct napi_struct *napi, u32 index,
+				   bool flush_old)
+{
+	struct list_head *head = &napi->gro_hash[index].list;
+	struct sk_buff *skb, *p;
+
+	list_for_each_entry_safe_reverse(skb, p, head, list) {
+		if (flush_old && NAPI_GRO_CB(skb)->age == jiffies)
+			return;
+		skb_list_del_init(skb);
+		napi_gro_complete(napi, skb);
+		napi->gro_hash[index].count--;
+	}
+
+	if (!napi->gro_hash[index].count)
+		__clear_bit(index, &napi->gro_bitmask);
+}
+
+/* napi->gro_hash[].list contains packets ordered by age.
+ * youngest packets at the head of it.
+ * Complete skbs in reverse order to reduce latencies.
+ */
+void napi_gro_flush(struct napi_struct *napi, bool flush_old)
+{
+	unsigned long bitmask = napi->gro_bitmask;
+	unsigned int i, base = ~0U;
+
+	while ((i = ffs(bitmask)) != 0) {
+		bitmask >>= i;
+		base += i;
+		__napi_gro_flush_chain(napi, base, flush_old);
+	}
+}
+EXPORT_SYMBOL(napi_gro_flush);
+
+static void gro_list_prepare(const struct list_head *head,
+			     const struct sk_buff *skb)
+{
+	unsigned int maclen = skb->dev->hard_header_len;
+	u32 hash = skb_get_hash_raw(skb);
+	struct sk_buff *p;
+
+	list_for_each_entry(p, head, list) {
+		unsigned long diffs;
+
+		NAPI_GRO_CB(p)->flush = 0;
+
+		if (hash != skb_get_hash_raw(p)) {
+			NAPI_GRO_CB(p)->same_flow = 0;
+			continue;
+		}
+
+		diffs = (unsigned long)p->dev ^ (unsigned long)skb->dev;
+		diffs |= skb_vlan_tag_present(p) ^ skb_vlan_tag_present(skb);
+		if (skb_vlan_tag_present(p))
+			diffs |= skb_vlan_tag_get(p) ^ skb_vlan_tag_get(skb);
+		diffs |= skb_metadata_differs(p, skb);
+		if (maclen == ETH_HLEN)
+			diffs |= compare_ether_header(skb_mac_header(p),
+						      skb_mac_header(skb));
+		else if (!diffs)
+			diffs = memcmp(skb_mac_header(p),
+				       skb_mac_header(skb),
+				       maclen);
+
+		/* in most common scenarions 'slow_gro' is 0
+		 * otherwise we are already on some slower paths
+		 * either skip all the infrequent tests altogether or
+		 * avoid trying too hard to skip each of them individually
+		 */
+		if (!diffs && unlikely(skb->slow_gro | p->slow_gro)) {
+#if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+			struct tc_skb_ext *skb_ext;
+			struct tc_skb_ext *p_ext;
+#endif
+
+			diffs |= p->sk != skb->sk;
+			diffs |= skb_metadata_dst_cmp(p, skb);
+			diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
+
+#if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+			skb_ext = skb_ext_find(skb, TC_SKB_EXT);
+			p_ext = skb_ext_find(p, TC_SKB_EXT);
+
+			diffs |= (!!p_ext) ^ (!!skb_ext);
+			if (!diffs && unlikely(skb_ext))
+				diffs |= p_ext->chain ^ skb_ext->chain;
+#endif
+		}
+
+		NAPI_GRO_CB(p)->same_flow = !diffs;
+	}
+}
+
+static inline void skb_gro_reset_offset(struct sk_buff *skb, u32 nhoff)
+{
+	const struct skb_shared_info *pinfo = skb_shinfo(skb);
+	const skb_frag_t *frag0 = &pinfo->frags[0];
+
+	NAPI_GRO_CB(skb)->data_offset = 0;
+	NAPI_GRO_CB(skb)->frag0 = NULL;
+	NAPI_GRO_CB(skb)->frag0_len = 0;
+
+	if (!skb_headlen(skb) && pinfo->nr_frags &&
+	    !PageHighMem(skb_frag_page(frag0)) &&
+	    (!NET_IP_ALIGN || !((skb_frag_off(frag0) + nhoff) & 3))) {
+		NAPI_GRO_CB(skb)->frag0 = skb_frag_address(frag0);
+		NAPI_GRO_CB(skb)->frag0_len = min_t(unsigned int,
+						    skb_frag_size(frag0),
+						    skb->end - skb->tail);
+	}
+}
+
+static void gro_pull_from_frag0(struct sk_buff *skb, int grow)
+{
+	struct skb_shared_info *pinfo = skb_shinfo(skb);
+
+	BUG_ON(skb->end - skb->tail < grow);
+
+	memcpy(skb_tail_pointer(skb), NAPI_GRO_CB(skb)->frag0, grow);
+
+	skb->data_len -= grow;
+	skb->tail += grow;
+
+	skb_frag_off_add(&pinfo->frags[0], grow);
+	skb_frag_size_sub(&pinfo->frags[0], grow);
+
+	if (unlikely(!skb_frag_size(&pinfo->frags[0]))) {
+		skb_frag_unref(skb, 0);
+		memmove(pinfo->frags, pinfo->frags + 1,
+			--pinfo->nr_frags * sizeof(pinfo->frags[0]));
+	}
+}
+
+static void gro_flush_oldest(struct napi_struct *napi, struct list_head *head)
+{
+	struct sk_buff *oldest;
+
+	oldest = list_last_entry(head, struct sk_buff, list);
+
+	/* We are called with head length >= MAX_GRO_SKBS, so this is
+	 * impossible.
+	 */
+	if (WARN_ON_ONCE(!oldest))
+		return;
+
+	/* Do not adjust napi->gro_hash[].count, caller is adding a new
+	 * SKB to the chain.
+	 */
+	skb_list_del_init(oldest);
+	napi_gro_complete(napi, oldest);
+}
+
+static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
+{
+	u32 bucket = skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
+	struct gro_list *gro_list = &napi->gro_hash[bucket];
+	struct list_head *head = &offload_base;
+	struct packet_offload *ptype;
+	__be16 type = skb->protocol;
+	struct sk_buff *pp = NULL;
+	enum gro_result ret;
+	int same_flow;
+	int grow;
+
+	if (netif_elide_gro(skb->dev))
+		goto normal;
+
+	gro_list_prepare(&gro_list->list, skb);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ptype, head, list) {
+		if (ptype->type != type || !ptype->callbacks.gro_receive)
+			continue;
+
+		skb_set_network_header(skb, skb_gro_offset(skb));
+		skb_reset_mac_len(skb);
+		NAPI_GRO_CB(skb)->same_flow = 0;
+		NAPI_GRO_CB(skb)->flush = skb_is_gso(skb) || skb_has_frag_list(skb);
+		NAPI_GRO_CB(skb)->free = 0;
+		NAPI_GRO_CB(skb)->encap_mark = 0;
+		NAPI_GRO_CB(skb)->recursion_counter = 0;
+		NAPI_GRO_CB(skb)->is_fou = 0;
+		NAPI_GRO_CB(skb)->is_atomic = 1;
+		NAPI_GRO_CB(skb)->gro_remcsum_start = 0;
+
+		/* Setup for GRO checksum validation */
+		switch (skb->ip_summed) {
+		case CHECKSUM_COMPLETE:
+			NAPI_GRO_CB(skb)->csum = skb->csum;
+			NAPI_GRO_CB(skb)->csum_valid = 1;
+			NAPI_GRO_CB(skb)->csum_cnt = 0;
+			break;
+		case CHECKSUM_UNNECESSARY:
+			NAPI_GRO_CB(skb)->csum_cnt = skb->csum_level + 1;
+			NAPI_GRO_CB(skb)->csum_valid = 0;
+			break;
+		default:
+			NAPI_GRO_CB(skb)->csum_cnt = 0;
+			NAPI_GRO_CB(skb)->csum_valid = 0;
+		}
+
+		pp = INDIRECT_CALL_INET(ptype->callbacks.gro_receive,
+					ipv6_gro_receive, inet_gro_receive,
+					&gro_list->list, skb);
+		break;
+	}
+	rcu_read_unlock();
+
+	if (&ptype->list == head)
+		goto normal;
+
+	if (PTR_ERR(pp) == -EINPROGRESS) {
+		ret = GRO_CONSUMED;
+		goto ok;
+	}
+
+	same_flow = NAPI_GRO_CB(skb)->same_flow;
+	ret = NAPI_GRO_CB(skb)->free ? GRO_MERGED_FREE : GRO_MERGED;
+
+	if (pp) {
+		skb_list_del_init(pp);
+		napi_gro_complete(napi, pp);
+		gro_list->count--;
+	}
+
+	if (same_flow)
+		goto ok;
+
+	if (NAPI_GRO_CB(skb)->flush)
+		goto normal;
+
+	if (unlikely(gro_list->count >= MAX_GRO_SKBS))
+		gro_flush_oldest(napi, &gro_list->list);
+	else
+		gro_list->count++;
+
+	NAPI_GRO_CB(skb)->count = 1;
+	NAPI_GRO_CB(skb)->age = jiffies;
+	NAPI_GRO_CB(skb)->last = skb;
+	skb_shinfo(skb)->gso_size = skb_gro_len(skb);
+	list_add(&skb->list, &gro_list->list);
+	ret = GRO_HELD;
+
+pull:
+	grow = skb_gro_offset(skb) - skb_headlen(skb);
+	if (grow > 0)
+		gro_pull_from_frag0(skb, grow);
+ok:
+	if (gro_list->count) {
+		if (!test_bit(bucket, &napi->gro_bitmask))
+			__set_bit(bucket, &napi->gro_bitmask);
+	} else if (test_bit(bucket, &napi->gro_bitmask)) {
+		__clear_bit(bucket, &napi->gro_bitmask);
+	}
+
+	return ret;
+
+normal:
+	ret = GRO_NORMAL;
+	goto pull;
+}
+
+struct packet_offload *gro_find_receive_by_type(__be16 type)
+{
+	struct list_head *offload_head = &offload_base;
+	struct packet_offload *ptype;
+
+	list_for_each_entry_rcu(ptype, offload_head, list) {
+		if (ptype->type != type || !ptype->callbacks.gro_receive)
+			continue;
+		return ptype;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(gro_find_receive_by_type);
+
+struct packet_offload *gro_find_complete_by_type(__be16 type)
+{
+	struct list_head *offload_head = &offload_base;
+	struct packet_offload *ptype;
+
+	list_for_each_entry_rcu(ptype, offload_head, list) {
+		if (ptype->type != type || !ptype->callbacks.gro_complete)
+			continue;
+		return ptype;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(gro_find_complete_by_type);
+
+static gro_result_t napi_skb_finish(struct napi_struct *napi,
+				    struct sk_buff *skb,
+				    gro_result_t ret)
+{
+	switch (ret) {
+	case GRO_NORMAL:
+		gro_normal_one(napi, skb, 1);
+		break;
+
+	case GRO_MERGED_FREE:
+		if (NAPI_GRO_CB(skb)->free == NAPI_GRO_FREE_STOLEN_HEAD)
+			napi_skb_free_stolen_head(skb);
+		else if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
+			__kfree_skb(skb);
+		else
+			__kfree_skb_defer(skb);
+		break;
+
+	case GRO_HELD:
+	case GRO_MERGED:
+	case GRO_CONSUMED:
+		break;
+	}
+
+	return ret;
+}
+
+gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
+{
+	gro_result_t ret;
+
+	skb_mark_napi_id(skb, napi);
+	trace_napi_gro_receive_entry(skb);
+
+	skb_gro_reset_offset(skb, 0);
+
+	ret = napi_skb_finish(napi, skb, dev_gro_receive(napi, skb));
+	trace_napi_gro_receive_exit(ret);
+
+	return ret;
+}
+EXPORT_SYMBOL(napi_gro_receive);
+
+static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
+{
+	if (unlikely(skb->pfmemalloc)) {
+		consume_skb(skb);
+		return;
+	}
+	__skb_pull(skb, skb_headlen(skb));
+	/* restore the reserve we had after netdev_alloc_skb_ip_align() */
+	skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN - skb_headroom(skb));
+	__vlan_hwaccel_clear_tag(skb);
+	skb->dev = napi->dev;
+	skb->skb_iif = 0;
+
+	/* eth_type_trans() assumes pkt_type is PACKET_HOST */
+	skb->pkt_type = PACKET_HOST;
+
+	skb->encapsulation = 0;
+	skb_shinfo(skb)->gso_type = 0;
+	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
+	if (unlikely(skb->slow_gro)) {
+		skb_orphan(skb);
+		skb_ext_reset(skb);
+		nf_reset_ct(skb);
+		skb->slow_gro = 0;
+	}
+
+	napi->skb = skb;
+}
+
+struct sk_buff *napi_get_frags(struct napi_struct *napi)
+{
+	struct sk_buff *skb = napi->skb;
+
+	if (!skb) {
+		skb = napi_alloc_skb(napi, GRO_MAX_HEAD);
+		if (skb) {
+			napi->skb = skb;
+			skb_mark_napi_id(skb, napi);
+		}
+	}
+	return skb;
+}
+EXPORT_SYMBOL(napi_get_frags);
+
+static gro_result_t napi_frags_finish(struct napi_struct *napi,
+				      struct sk_buff *skb,
+				      gro_result_t ret)
+{
+	switch (ret) {
+	case GRO_NORMAL:
+	case GRO_HELD:
+		__skb_push(skb, ETH_HLEN);
+		skb->protocol = eth_type_trans(skb, skb->dev);
+		if (ret == GRO_NORMAL)
+			gro_normal_one(napi, skb, 1);
+		break;
+
+	case GRO_MERGED_FREE:
+		if (NAPI_GRO_CB(skb)->free == NAPI_GRO_FREE_STOLEN_HEAD)
+			napi_skb_free_stolen_head(skb);
+		else
+			napi_reuse_skb(napi, skb);
+		break;
+
+	case GRO_MERGED:
+	case GRO_CONSUMED:
+		break;
+	}
+
+	return ret;
+}
+
+/* Upper GRO stack assumes network header starts at gro_offset=0
+ * Drivers could call both napi_gro_frags() and napi_gro_receive()
+ * We copy ethernet header into skb->data to have a common layout.
+ */
+static struct sk_buff *napi_frags_skb(struct napi_struct *napi)
+{
+	struct sk_buff *skb = napi->skb;
+	const struct ethhdr *eth;
+	unsigned int hlen = sizeof(*eth);
+
+	napi->skb = NULL;
+
+	skb_reset_mac_header(skb);
+	skb_gro_reset_offset(skb, hlen);
+
+	if (unlikely(skb_gro_header_hard(skb, hlen))) {
+		eth = skb_gro_header_slow(skb, hlen, 0);
+		if (unlikely(!eth)) {
+			net_warn_ratelimited("%s: dropping impossible skb from %s\n",
+					     __func__, napi->dev->name);
+			napi_reuse_skb(napi, skb);
+			return NULL;
+		}
+	} else {
+		eth = (const struct ethhdr *)skb->data;
+		gro_pull_from_frag0(skb, hlen);
+		NAPI_GRO_CB(skb)->frag0 += hlen;
+		NAPI_GRO_CB(skb)->frag0_len -= hlen;
+	}
+	__skb_pull(skb, hlen);
+
+	/*
+	 * This works because the only protocols we care about don't require
+	 * special handling.
+	 * We'll fix it up properly in napi_frags_finish()
+	 */
+	skb->protocol = eth->h_proto;
+
+	return skb;
+}
+
+gro_result_t napi_gro_frags(struct napi_struct *napi)
+{
+	gro_result_t ret;
+	struct sk_buff *skb = napi_frags_skb(napi);
+
+	trace_napi_gro_frags_entry(skb);
+
+	ret = napi_frags_finish(napi, skb, dev_gro_receive(napi, skb));
+	trace_napi_gro_frags_exit(ret);
+
+	return ret;
+}
+EXPORT_SYMBOL(napi_gro_frags);
+
+/* Compute the checksum from gro_offset and return the folded value
+ * after adding in any pseudo checksum.
+ */
+__sum16 __skb_gro_checksum_complete(struct sk_buff *skb)
+{
+	__wsum wsum;
+	__sum16 sum;
+
+	wsum = skb_checksum(skb, skb_gro_offset(skb), skb_gro_len(skb), 0);
+
+	/* NAPI_GRO_CB(skb)->csum holds pseudo checksum */
+	sum = csum_fold(csum_add(NAPI_GRO_CB(skb)->csum, wsum));
+	/* See comments in __skb_checksum_complete(). */
+	if (likely(!sum)) {
+		if (unlikely(skb->ip_summed == CHECKSUM_COMPLETE) &&
+		    !skb->csum_complete_sw)
+			netdev_rx_csum_fault(skb->dev, skb);
+	}
+
+	NAPI_GRO_CB(skb)->csum = wsum;
+	NAPI_GRO_CB(skb)->csum_valid = 1;
+
+	return sum;
+}
+EXPORT_SYMBOL(__skb_gro_checksum_complete);
-- 
2.34.0.rc1.387.gb447b232ab-goog

