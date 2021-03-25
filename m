Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DA1348CD3
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 10:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhCYJ2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 05:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhCYJ2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 05:28:00 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91354C06174A;
        Thu, 25 Mar 2021 02:28:00 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id x126so1391389pfc.13;
        Thu, 25 Mar 2021 02:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jO+UHb9XuNiBhUzgWdRGASRCU/X81Hj4K93BihAOiyM=;
        b=Y6EhbFdLBmv8nN5vppjbQ62/7UyTunMkbJxvdO6CabcqLs57+OfAYLwvXAi1xDHeN7
         Sl2c+kyxb9NWPlSD/Zo+m5naKlbJ+2Ps0thBUiXmGTYnKHJTl4nV7DhIlRscXisLMMhD
         2rwHGJTl2ZnKPBSa5HT0B6tUSDZDm/dMvV69+wZXU9c4e/3bJdKneqLvt13EadgmKWdg
         pZIJgEyIY3d0ii75UC06y+TQ2RZUMd4tA6yyN1Tf2tlGZYrALZ5p3Zi2qHN8zDanRbjX
         Ru8GxObV1QNOMVAB8B1BZGIo7cupKwdb09vHJvT34cxggO0QOamBxUpf8/xpCBWmSpIg
         e43Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jO+UHb9XuNiBhUzgWdRGASRCU/X81Hj4K93BihAOiyM=;
        b=qbZAW7/G7nr1ow4189fwHfessPs3/IWR5E2HBDvO50K5CTP1ggfkK41Q7xUpqRxfrw
         sZz5wD6nZbMEag6SeHO5m0lrfKyULokHvGETcaz5S5KryUpvbruyxDOGGjJqopK+SeCO
         MU0MG2bT6L6Cmo18kG3vvyOuxaalPD5d7ViKFxJUyZdbHvvCFWO7Pe2pvR9aqe+NK5uP
         AmrSPIbfRbMR55/7KvpiHkiXsrkVPAsnZuGtBmuE2DfhYK+StyfLSstS8iWMKEJMHsPU
         YktUFiUQ65vdxURwp+F4VkMUfCwo0STq2VdQj+mzghhELBEh2MqveVKDucBzd9Xu0SnC
         0CUA==
X-Gm-Message-State: AOAM530ZyZ1kddBImL27yUe8w9GOE8nn7JIPl/jWZQLIDlB4xCpKaLcU
        lRav9eMGuSaNe5K11jO3OA/+ClagPfI=
X-Google-Smtp-Source: ABdhPJxUMr5mMMwIVOjvvdH1+Rom5tcevOgIK0v1cICR0fahZt+DgyVtFVQyKFWHLdJya96z9kr85Q==
X-Received: by 2002:a63:374e:: with SMTP id g14mr6702523pgn.56.1616664479728;
        Thu, 25 Mar 2021 02:27:59 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e65sm5191037pfe.9.2021.03.25.02.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 02:27:59 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 bpf-next 2/4] xdp: extend xdp_redirect_map with broadcast support
Date:   Thu, 25 Mar 2021 17:27:31 +0800
Message-Id: <20210325092733.3058653-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325092733.3058653-1-liuhangbin@gmail.com>
References: <20210325092733.3058653-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add two flags BPF_F_BROADCAST and BPF_F_EXCLUDE_INGRESS to extend
xdp_redirect_map for broadcast support.

Keep the general data path in net/core/filter.c and the native data
path in kernel/bpf/devmap.c so we can use direct calls to get better
performace.

Here is the performance result by using xdp_redirect_{map, map_multi} in
sample/bpf and send pkts via pktgen cmd:
./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t 10 -s 64

There are some drop back as we need to loop the map and get each interface.

Version          | Test                                | Generic | Native
5.12 rc2         | redirect_map        i40e->i40e      |    2.0M |  9.8M
5.12 rc2         | redirect_map        i40e->veth      |    1.8M | 12.0M
5.12 rc2 + patch | redirect_map        i40e->i40e      |    2.0M |  9.6M
5.12 rc2 + patch | redirect_map        i40e->veth      |    1.7M | 12.0M
5.12 rc2 + patch | redirect_map multi  i40e->i40e      |    1.6M |  7.8M
5.12 rc2 + patch | redirect_map multi  i40e->veth      |    1.4M |  9.3M
5.12 rc2 + patch | redirect_map multi  i40e->mlx4+veth |    1.0M |  3.4M

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v3:
a) Rebase the code on Björn's "bpf, xdp: Restructure redirect actions".
   - Add struct bpf_map *map back to struct bpf_redirect_info as we need
     it for multicast.
   - Add bpf_clear_redirect_map() back for devmap.c
   - Add devmap_lookup_elem() as we need it in general path.
b) remove tmp_key in devmap_get_next_obj()

v2: Fix flag renaming issue in v1
---
 include/linux/bpf.h            |  22 ++++++
 include/linux/filter.h         |  14 +++-
 include/net/xdp.h              |   1 +
 include/uapi/linux/bpf.h       |  17 ++++-
 kernel/bpf/devmap.c            | 127 +++++++++++++++++++++++++++++++++
 net/core/filter.c              |  92 +++++++++++++++++++++++-
 net/core/xdp.c                 |  29 ++++++++
 tools/include/uapi/linux/bpf.h |  17 ++++-
 8 files changed, 310 insertions(+), 9 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a25730eaa148..5dacb1a45a03 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1456,11 +1456,15 @@ struct sk_buff;
 struct bpf_dtab_netdev;
 struct bpf_cpu_map_entry;
 
+struct bpf_dtab_netdev *devmap_lookup_elem(struct bpf_map *map, u32 key);
 void __dev_flush(void);
 int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
 int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
+bool dst_dev_is_ingress(struct bpf_dtab_netdev *obj, int ifindex);
+int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
+			  struct bpf_map *map, bool exclude_ingress);
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog);
 bool dev_map_can_have_prog(struct bpf_map *map);
@@ -1595,6 +1599,11 @@ static inline int bpf_obj_get_user(const char __user *pathname, int flags)
 	return -EOPNOTSUPP;
 }
 
+static inline struct net_device *devmap_lookup_elem(struct bpf_map *map, u32 key)
+{
+	return NULL;
+}
+
 static inline bool dev_map_can_have_prog(struct bpf_map *map)
 {
 	return false;
@@ -1622,6 +1631,19 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 	return 0;
 }
 
+static inline
+bool dst_dev_is_ingress(struct bpf_dtab_netdev *obj, int ifindex)
+{
+	return false;
+}
+
+static inline
+int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
+			  struct bpf_map *map, bool exclude_ingress)
+{
+	return 0;
+}
+
 struct sk_buff;
 
 static inline int dev_map_generic_redirect(struct bpf_dtab_netdev *dst,
diff --git a/include/linux/filter.h b/include/linux/filter.h
index b2b85b2cad8e..434170aafd0d 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -646,6 +646,7 @@ struct bpf_redirect_info {
 	u32 flags;
 	u32 tgt_index;
 	void *tgt_value;
+	struct bpf_map *map;
 	u32 map_id;
 	enum bpf_map_type map_type;
 	u32 kern_flags;
@@ -1479,11 +1480,11 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 
 	/* Lower bits of the flags are used as return code on lookup failure */
-	if (unlikely(flags > XDP_TX))
+	if (unlikely(flags & ~(BPF_F_ACTION_MASK | BPF_F_REDIR_MASK)))
 		return XDP_ABORTED;
 
 	ri->tgt_value = lookup_elem(map, ifindex);
-	if (unlikely(!ri->tgt_value)) {
+	if (unlikely(!ri->tgt_value) && !(flags & BPF_F_BROADCAST)) {
 		/* If the lookup fails we want to clear out the state in the
 		 * redirect_info struct completely, so that if an eBPF program
 		 * performs multiple lookups, the last one always takes
@@ -1491,13 +1492,20 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
 		 */
 		ri->map_id = INT_MAX; /* Valid map id idr range: [1,INT_MAX[ */
 		ri->map_type = BPF_MAP_TYPE_UNSPEC;
-		return flags;
+		return flags & BPF_F_ACTION_MASK;
 	}
 
 	ri->tgt_index = ifindex;
 	ri->map_id = map->id;
 	ri->map_type = map->map_type;
 
+	if ((map->map_type == BPF_MAP_TYPE_DEVMAP ||
+	     map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) &&
+	    (flags & BPF_F_BROADCAST)) {
+		ri->flags = flags;
+		WRITE_ONCE(ri->map, map);
+	}
+
 	return XDP_REDIRECT;
 }
 
diff --git a/include/net/xdp.h b/include/net/xdp.h
index a5bc214a49d9..5533f0ab2afc 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -170,6 +170,7 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 struct sk_buff *xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 					 struct net_device *dev);
 int xdp_alloc_skb_bulk(void **skbs, int n_skb, gfp_t gfp);
+struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf);
 
 static inline
 void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2d3036e292a9..5982ceb217dc 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2508,8 +2508,12 @@ union bpf_attr {
  * 		The lower two bits of *flags* are used as the return code if
  * 		the map lookup fails. This is so that the return value can be
  * 		one of the XDP program return codes up to **XDP_TX**, as chosen
- * 		by the caller. Any higher bits in the *flags* argument must be
- * 		unset.
+ * 		by the caller. The higher bits of *flags* can be set to
+ * 		BPF_F_BROADCAST or BPF_F_EXCLUDE_INGRESS as defined below.
+ *
+ * 		With BPF_F_BROADCAST the packet will be broadcasted to all the
+ * 		interfaces in the map. with BPF_F_EXCLUDE_INGRESS the ingress
+ * 		interface will be excluded when do broadcasting.
  *
  * 		See also **bpf_redirect**\ (), which only supports redirecting
  * 		to an ifindex, but doesn't require a map to do so.
@@ -5004,6 +5008,15 @@ enum {
 	BPF_F_BPRM_SECUREEXEC	= (1ULL << 0),
 };
 
+/* Flags for bpf_redirect_map helper */
+enum {
+	BPF_F_BROADCAST		= (1ULL << 3),
+	BPF_F_EXCLUDE_INGRESS	= (1ULL << 4),
+};
+
+#define BPF_F_ACTION_MASK (XDP_ABORTED | XDP_DROP | XDP_PASS | XDP_TX)
+#define BPF_F_REDIR_MASK (BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS)
+
 #define __bpf_md_ptr(type, name)	\
 union {					\
 	type name;			\
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 2add12a289c3..3e999d6c9283 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -198,6 +198,7 @@ static void dev_map_free(struct bpf_map *map)
 	list_del_rcu(&dtab->list);
 	spin_unlock(&dev_map_lock);
 
+	bpf_clear_redirect_map(map);
 	synchronize_rcu();
 
 	/* Make sure prior __dev_map_entry_free() have completed. */
@@ -451,6 +452,24 @@ static void *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
 	return obj;
 }
 
+struct bpf_dtab_netdev *devmap_lookup_elem(struct bpf_map *map, u32 key)
+{
+	struct bpf_dtab_netdev *obj = NULL;
+
+	switch (map->map_type) {
+	case BPF_MAP_TYPE_DEVMAP:
+		obj = __dev_map_lookup_elem(map, key);
+		break;
+	case BPF_MAP_TYPE_DEVMAP_HASH:
+		obj = __dev_map_hash_lookup_elem(map, key);
+		break;
+	default:
+		break;
+	}
+
+	return obj;
+}
+
 /* Runs under RCU-read-side, plus in softirq under NAPI protection.
  * Thus, safe percpu variable access.
  */
@@ -515,6 +534,114 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 	return __xdp_enqueue(dev, xdp, dev_rx, dst->xdp_prog);
 }
 
+/* Use direct call in fast path instead of map->ops->map_get_next_key() */
+static int devmap_get_next_key(struct bpf_map *map, void *key, void *next_key)
+{
+	switch (map->map_type) {
+	case BPF_MAP_TYPE_DEVMAP:
+		return dev_map_get_next_key(map, key, next_key);
+	case BPF_MAP_TYPE_DEVMAP_HASH:
+		return dev_map_hash_get_next_key(map, key, next_key);
+	default:
+		break;
+	}
+
+	return -ENOENT;
+}
+
+bool dst_dev_is_ingress(struct bpf_dtab_netdev *dst, int ifindex)
+{
+	return dst->dev->ifindex == ifindex;
+}
+
+static struct bpf_dtab_netdev *devmap_get_next_obj(struct xdp_buff *xdp,
+						   struct bpf_map *map,
+						   u32 *key, u32 *next_key,
+						   int ex_ifindex)
+{
+	struct bpf_dtab_netdev *obj;
+	struct net_device *dev;
+	u32 index;
+	int err;
+
+	err = devmap_get_next_key(map, key, next_key);
+	if (err)
+		return NULL;
+
+	/* When using dev map hash, we could restart the hashtab traversal
+	 * in case the key has been updated/removed in the mean time.
+	 * So we may end up potentially looping due to traversal restarts
+	 * from first elem.
+	 *
+	 * Let's use map's max_entries to limit the loop number.
+	 */
+	for (index = 0; index < map->max_entries; index++) {
+		obj = devmap_lookup_elem(map, *next_key);
+		if (!obj || dst_dev_is_ingress(obj, ex_ifindex))
+			goto find_next;
+
+		dev = obj->dev;
+
+		if (!dev->netdev_ops->ndo_xdp_xmit)
+			goto find_next;
+
+		err = xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
+		if (unlikely(err))
+			goto find_next;
+
+		return obj;
+
+find_next:
+		key = next_key;
+		err = devmap_get_next_key(map, key, next_key);
+		if (err)
+			break;
+	}
+
+	return NULL;
+}
+
+int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
+			  struct bpf_map *map, bool exclude_ingress)
+{
+	struct bpf_dtab_netdev *obj = NULL, *next_obj = NULL;
+	struct xdp_frame *xdpf, *nxdpf;
+	u32 key, next_key;
+	int ex_ifindex;
+
+	ex_ifindex = exclude_ingress ? dev_rx->ifindex : 0;
+
+	/* Find first available obj */
+	obj = devmap_get_next_obj(xdp, map, NULL, &key, ex_ifindex);
+	if (!obj)
+		return -ENOENT;
+
+	xdpf = xdp_convert_buff_to_frame(xdp);
+	if (unlikely(!xdpf))
+		return -EOVERFLOW;
+
+	for (;;) {
+		/* Check if we still have one more available obj */
+		next_obj = devmap_get_next_obj(xdp, map, &key, &next_key, ex_ifindex);
+		if (!next_obj) {
+			bq_enqueue(obj->dev, xdpf, dev_rx, obj->xdp_prog);
+			return 0;
+		}
+
+		nxdpf = xdpf_clone(xdpf);
+		if (unlikely(!nxdpf)) {
+			xdp_return_frame_rx_napi(xdpf);
+			return -ENOMEM;
+		}
+
+		bq_enqueue(obj->dev, nxdpf, dev_rx, obj->xdp_prog);
+
+		/* Deal with next obj */
+		obj = next_obj;
+		key = next_key;
+	}
+}
+
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog)
 {
diff --git a/net/core/filter.c b/net/core/filter.c
index 10dac9dd5086..6d4d037d70ac 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3926,6 +3926,23 @@ void xdp_do_flush(void)
 }
 EXPORT_SYMBOL_GPL(xdp_do_flush);
 
+void bpf_clear_redirect_map(struct bpf_map *map)
+{
+	struct bpf_redirect_info *ri;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		ri = per_cpu_ptr(&bpf_redirect_info, cpu);
+		/* Avoid polluting remote cacheline due to writes if
+		 * not needed. Once we pass this test, we need the
+		 * cmpxchg() to make sure it hasn't been changed in
+		 * the meantime by remote CPU.
+		 */
+		if (unlikely(READ_ONCE(ri->map) == map))
+			cmpxchg(&ri->map, map, NULL);
+	}
+}
+
 int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 		    struct bpf_prog *xdp_prog)
 {
@@ -3933,16 +3950,26 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	enum bpf_map_type map_type = ri->map_type;
 	void *fwd = ri->tgt_value;
 	u32 map_id = ri->map_id;
+	struct bpf_map *map;
 	int err;
 
 	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
 	ri->map_type = BPF_MAP_TYPE_UNSPEC;
 
+	if (ri->flags & BPF_F_BROADCAST) {
+		map = READ_ONCE(ri->map);
+		WRITE_ONCE(ri->map, NULL);
+	}
+
 	switch (map_type) {
 	case BPF_MAP_TYPE_DEVMAP:
 		fallthrough;
 	case BPF_MAP_TYPE_DEVMAP_HASH:
-		err = dev_map_enqueue(fwd, xdp, dev);
+		if (ri->flags & BPF_F_BROADCAST)
+			err = dev_map_enqueue_multi(xdp, dev, map,
+						    ri->flags & BPF_F_EXCLUDE_INGRESS);
+		else
+			err = dev_map_enqueue(fwd, xdp, dev);
 		break;
 	case BPF_MAP_TYPE_CPUMAP:
 		err = cpu_map_enqueue(fwd, xdp, dev);
@@ -3976,6 +4003,57 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 }
 EXPORT_SYMBOL_GPL(xdp_do_redirect);
 
+static int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
+				  struct bpf_prog *xdp_prog, struct bpf_map *map,
+				  bool exclude_ingress)
+{
+	struct bpf_dtab_netdev *dst;
+	u32 key, next_key, index;
+	struct sk_buff *nskb;
+	void *fwd;
+	int err;
+
+	err = map->ops->map_get_next_key(map, NULL, &key);
+	if (err)
+		return err;
+
+	/* When using dev map hash, we could restart the hashtab traversal
+	 * in case the key has been updated/removed in the mean time.
+	 * So we may end up potentially looping due to traversal restarts
+	 * from first elem.
+	 *
+	 * Let's use map's max_entries to limit the loop number.
+	 */
+
+	for (index = 0; index < map->max_entries; index++) {
+		fwd = devmap_lookup_elem(map, key);
+		if (fwd) {
+			dst = (struct bpf_dtab_netdev *)fwd;
+			if (dst_dev_is_ingress(dst, exclude_ingress ? dev->ifindex : 0))
+				goto find_next;
+
+			nskb = skb_clone(skb, GFP_ATOMIC);
+			if (!nskb)
+				return -ENOMEM;
+
+			/* Try forword next one no mater the current forward
+			 * succeed or not.
+			 */
+			dev_map_generic_redirect(dst, nskb, xdp_prog);
+		}
+
+find_next:
+		err = map->ops->map_get_next_key(map, &key, &next_key);
+		if (err)
+			break;
+
+		key = next_key;
+	}
+
+	consume_skb(skb);
+	return 0;
+}
+
 static int xdp_do_generic_redirect_map(struct net_device *dev,
 				       struct sk_buff *skb,
 				       struct xdp_buff *xdp,
@@ -3984,13 +4062,23 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
 				       enum bpf_map_type map_type, u32 map_id)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	struct bpf_map *map;
 	int err;
 
+	if (ri->flags & BPF_F_BROADCAST) {
+		map = READ_ONCE(ri->map);
+		WRITE_ONCE(ri->map, NULL);
+	}
+
 	switch (map_type) {
 	case BPF_MAP_TYPE_DEVMAP:
 		fallthrough;
 	case BPF_MAP_TYPE_DEVMAP_HASH:
-		err = dev_map_generic_redirect(fwd, skb, xdp_prog);
+		if (ri->flags & BPF_F_BROADCAST)
+			err = dev_map_redirect_multi(dev, skb, xdp_prog, map,
+						     ri->flags & BPF_F_EXCLUDE_INGRESS);
+		else
+			err = dev_map_generic_redirect(fwd, skb, xdp_prog);
 		if (unlikely(err))
 			goto err;
 		break;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 05354976c1fc..aba84d04642b 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -583,3 +583,32 @@ struct sk_buff *xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 	return __xdp_build_skb_from_frame(xdpf, skb, dev);
 }
 EXPORT_SYMBOL_GPL(xdp_build_skb_from_frame);
+
+struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
+{
+	unsigned int headroom, totalsize;
+	struct xdp_frame *nxdpf;
+	struct page *page;
+	void *addr;
+
+	headroom = xdpf->headroom + sizeof(*xdpf);
+	totalsize = headroom + xdpf->len;
+
+	if (unlikely(totalsize > PAGE_SIZE))
+		return NULL;
+	page = dev_alloc_page();
+	if (!page)
+		return NULL;
+	addr = page_to_virt(page);
+
+	memcpy(addr, xdpf, totalsize);
+
+	nxdpf = addr;
+	nxdpf->data = addr + headroom;
+	nxdpf->frame_sz = PAGE_SIZE;
+	nxdpf->mem.type = MEM_TYPE_PAGE_ORDER0;
+	nxdpf->mem.id = 0;
+
+	return nxdpf;
+}
+EXPORT_SYMBOL_GPL(xdpf_clone);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 2d3036e292a9..5982ceb217dc 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2508,8 +2508,12 @@ union bpf_attr {
  * 		The lower two bits of *flags* are used as the return code if
  * 		the map lookup fails. This is so that the return value can be
  * 		one of the XDP program return codes up to **XDP_TX**, as chosen
- * 		by the caller. Any higher bits in the *flags* argument must be
- * 		unset.
+ * 		by the caller. The higher bits of *flags* can be set to
+ * 		BPF_F_BROADCAST or BPF_F_EXCLUDE_INGRESS as defined below.
+ *
+ * 		With BPF_F_BROADCAST the packet will be broadcasted to all the
+ * 		interfaces in the map. with BPF_F_EXCLUDE_INGRESS the ingress
+ * 		interface will be excluded when do broadcasting.
  *
  * 		See also **bpf_redirect**\ (), which only supports redirecting
  * 		to an ifindex, but doesn't require a map to do so.
@@ -5004,6 +5008,15 @@ enum {
 	BPF_F_BPRM_SECUREEXEC	= (1ULL << 0),
 };
 
+/* Flags for bpf_redirect_map helper */
+enum {
+	BPF_F_BROADCAST		= (1ULL << 3),
+	BPF_F_EXCLUDE_INGRESS	= (1ULL << 4),
+};
+
+#define BPF_F_ACTION_MASK (XDP_ABORTED | XDP_DROP | XDP_PASS | XDP_TX)
+#define BPF_F_REDIR_MASK (BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS)
+
 #define __bpf_md_ptr(type, name)	\
 union {					\
 	type name;			\
-- 
2.26.2

