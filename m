Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0296B352A9D
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 14:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbhDBMUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 08:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbhDBMU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 08:20:26 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3BDC0613E6;
        Fri,  2 Apr 2021 05:20:25 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id y3so712515pgi.0;
        Fri, 02 Apr 2021 05:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VhU4PMXFi3IhgQqMUuD2AArV4T8a5Mz8kKfY2Qc6o6Y=;
        b=cYaeYQEn+V1ven4GvCskA+xgYwcNvFUCcXGOBEnfgghgMStFE7M7HIkQergvkGEUVg
         5mYpFpXZ26klBbd+77GQgdvt3fCt+axBuc2Wx9brK83aLMD4TN7LTQ/seENAOs6g0oKf
         hzZT6JJXr+6UUjVHazfIMzMJ5WvBDGooHBIa+tF8HsMdJqSEvqkiClYmTImd6xX8ArI4
         yxRZJORV9xo0LLcLmB+FuIHqEK/pu0csK9QuqsT0k6XrQxoDSyC7Hg6xtlKdlegEttny
         pS6Dj8bYCOBjrtAqB6o/A4JCtpbcQoxTR2ZDoqXB0RaAwGxUhsa1OrTB4zb58bsJV8fF
         jAcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VhU4PMXFi3IhgQqMUuD2AArV4T8a5Mz8kKfY2Qc6o6Y=;
        b=pgquenwuPgzSZi4nmsVDEDukt2LerQv59sr9hgwdQPJV+uiz4IkLUGRIj7aPxvz/ME
         3t6CML8KQSlUu9HhgCing1vmnklA9gat9WexVh6++pgyT2zaWGCVs9kMLd9BbmniBH+D
         GI7E75Q0smaRKzxMBdjK8PgfZ1H1xXr6BnuQNUPCalh9HpNA4n74S8TZROvnVJLAWN0C
         v9m2h+o4kQTEQD8uL9yTYKt0czyTymxyOulGCsLBYubKtw2ujw+XTIZD3jWtQV7F4eCg
         JTC7sSfe57lpN1mGeISAMTT8YRPQqfLe5I63QiT6EJuJqEpZnZbUKaYjjijtZlIN+K+1
         5ueg==
X-Gm-Message-State: AOAM531YwLSQ4yuJe5+8qE8F7tDTjsY9NsS4nYLfy0N6NShr9L3+Be3U
        5/h2qcrEc7cIm5KuQSHlrZE1MJdN7B5QxQ==
X-Google-Smtp-Source: ABdhPJzKHPgQPioVV/L6D75R5Ja4eTAxxhby+g4RrnoRyIm9O0qV9+IXoyU+t8cXDryqKhVOmQwpng==
X-Received: by 2002:a62:6497:0:b029:220:d96a:8a79 with SMTP id y145-20020a6264970000b0290220d96a8a79mr11904801pfb.23.1617366024783;
        Fri, 02 Apr 2021 05:20:24 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g15sm8760913pfk.36.2021.04.02.05.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 05:20:24 -0700 (PDT)
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
Subject: [PATCHv4 bpf-next 2/4] xdp: extend xdp_redirect_map with broadcast support
Date:   Fri,  2 Apr 2021 20:19:52 +0800
Message-Id: <20210402121954.3568992-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210402121954.3568992-1-liuhangbin@gmail.com>
References: <20210402121954.3568992-1-liuhangbin@gmail.com>
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
v4:
a) add a new argument flag_mask to __bpf_xdp_redirect_map() filter out
invalid map.
b) __bpf_xdp_redirect_map() sets the map pointer if the broadcast flag
is set and clears it if the flag isn't set
c) xdp_do_redirect() does the READ_ONCE/WRITE_ONCE on ri->map to check
if we should enqueue multi

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
 include/linux/filter.h         |  18 ++++-
 include/net/xdp.h              |   1 +
 include/uapi/linux/bpf.h       |  17 ++++-
 kernel/bpf/cpumap.c            |   3 +-
 kernel/bpf/devmap.c            | 133 ++++++++++++++++++++++++++++++++-
 net/core/filter.c              |  97 +++++++++++++++++++++++-
 net/core/xdp.c                 |  29 +++++++
 net/xdp/xskmap.c               |   3 +-
 tools/include/uapi/linux/bpf.h |  17 ++++-
 10 files changed, 326 insertions(+), 14 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9fdd839b418c..d5745c6000bc 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1492,11 +1492,15 @@ struct sk_buff;
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
@@ -1639,6 +1643,11 @@ static inline int bpf_obj_get_user(const char __user *pathname, int flags)
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
@@ -1666,6 +1675,19 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
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
index 9a09547bc7ba..e4885b42d754 100644
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
@@ -1464,17 +1465,18 @@ static inline bool bpf_sk_lookup_run_v6(struct net *net, int protocol,
 }
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 
-static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifindex, u64 flags,
+static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifindex,
+						  u64 flags, u64 flag_mask,
 						  void *lookup_elem(struct bpf_map *map, u32 key))
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 
 	/* Lower bits of the flags are used as return code on lookup failure */
-	if (unlikely(flags > XDP_TX))
+	if (unlikely(flags & ~(BPF_F_ACTION_MASK | flag_mask)))
 		return XDP_ABORTED;
 
 	ri->tgt_value = lookup_elem(map, ifindex);
-	if (unlikely(!ri->tgt_value)) {
+	if (unlikely(!ri->tgt_value) && !(flags & BPF_F_BROADCAST)) {
 		/* If the lookup fails we want to clear out the state in the
 		 * redirect_info struct completely, so that if an eBPF program
 		 * performs multiple lookups, the last one always takes
@@ -1482,13 +1484,21 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
 		 */
 		ri->map_id = INT_MAX; /* Valid map id idr range: [1,INT_MAX[ */
 		ri->map_type = BPF_MAP_TYPE_UNSPEC;
-		return flags;
+		return flags & BPF_F_ACTION_MASK;
 	}
 
 	ri->tgt_index = ifindex;
 	ri->map_id = map->id;
 	ri->map_type = map->map_type;
 
+	if (flags & BPF_F_BROADCAST) {
+		WRITE_ONCE(ri->map, map);
+		ri->flags = flags;
+	} else {
+		WRITE_ONCE(ri->map, NULL);
+		ri->flags = 0;
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
index 49371eba98ba..fe2c35bcc880 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2513,8 +2513,12 @@ union bpf_attr {
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
@@ -5015,6 +5019,15 @@ enum {
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
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 0cf2791d5099..2c33a7a09783 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -601,7 +601,8 @@ static int cpu_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 
 static int cpu_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
 {
-	return __bpf_xdp_redirect_map(map, ifindex, flags, __cpu_map_lookup_elem);
+	return __bpf_xdp_redirect_map(map, ifindex, flags, 0,
+				      __cpu_map_lookup_elem);
 }
 
 static int cpu_map_btf_id;
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 3980fb3bfb09..c8452c5f40f8 100644
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
@@ -755,12 +882,14 @@ static int dev_map_hash_update_elem(struct bpf_map *map, void *key, void *value,
 
 static int dev_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
 {
-	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_lookup_elem);
+	return __bpf_xdp_redirect_map(map, ifindex, flags, BPF_F_REDIR_MASK,
+				      __dev_map_lookup_elem);
 }
 
 static int dev_hash_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
 {
-	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_hash_lookup_elem);
+	return __bpf_xdp_redirect_map(map, ifindex, flags, BPF_F_REDIR_MASK,
+				      __dev_map_hash_lookup_elem);
 }
 
 static int dev_map_btf_id;
diff --git a/net/core/filter.c b/net/core/filter.c
index cae56d08a670..08a4d3869056 100644
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
@@ -3933,16 +3950,28 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	enum bpf_map_type map_type = ri->map_type;
 	void *fwd = ri->tgt_value;
 	u32 map_id = ri->map_id;
+	bool exclude_ingress;
+	struct bpf_map *map;
 	int err;
 
 	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
 	ri->map_type = BPF_MAP_TYPE_UNSPEC;
 
+	map = READ_ONCE(ri->map);
+	if (map) {
+		WRITE_ONCE(ri->map, NULL);
+		exclude_ingress = ri->flags & BPF_F_EXCLUDE_INGRESS;
+		ri->flags = 0;
+	}
+
 	switch (map_type) {
 	case BPF_MAP_TYPE_DEVMAP:
 		fallthrough;
 	case BPF_MAP_TYPE_DEVMAP_HASH:
-		err = dev_map_enqueue(fwd, xdp, dev);
+		if (map)
+			err = dev_map_enqueue_multi(xdp, dev, map, exclude_ingress);
+		else
+			err = dev_map_enqueue(fwd, xdp, dev);
 		break;
 	case BPF_MAP_TYPE_CPUMAP:
 		err = cpu_map_enqueue(fwd, xdp, dev);
@@ -3976,6 +4005,57 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
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
@@ -3984,13 +4064,26 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
 				       enum bpf_map_type map_type, u32 map_id)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	bool exclude_ingress;
+	struct bpf_map *map;
 	int err;
 
+	map = READ_ONCE(ri->map);
+	if (map) {
+		WRITE_ONCE(ri->map, NULL);
+		exclude_ingress = ri->flags & BPF_F_EXCLUDE_INGRESS;
+		ri->flags = 0;
+	}
+
 	switch (map_type) {
 	case BPF_MAP_TYPE_DEVMAP:
 		fallthrough;
 	case BPF_MAP_TYPE_DEVMAP_HASH:
-		err = dev_map_generic_redirect(fwd, skb, xdp_prog);
+		if (map)
+			err = dev_map_redirect_multi(dev, skb, xdp_prog, map,
+						     exclude_ingress);
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
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 67b4ce504852..9df75ea4a567 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -226,7 +226,8 @@ static int xsk_map_delete_elem(struct bpf_map *map, void *key)
 
 static int xsk_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
 {
-	return __bpf_xdp_redirect_map(map, ifindex, flags, __xsk_map_lookup_elem);
+	return __bpf_xdp_redirect_map(map, ifindex, flags, 0,
+				      __xsk_map_lookup_elem);
 }
 
 void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 69902603012c..46e42a783f4e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2513,8 +2513,12 @@ union bpf_attr {
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
@@ -5009,6 +5013,15 @@ enum {
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
2.26.3

