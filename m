Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59AB331FD2
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 08:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhCIHan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 02:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhCIHah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 02:30:37 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A8EC06174A;
        Mon,  8 Mar 2021 23:30:37 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id x7so5452020pfi.7;
        Mon, 08 Mar 2021 23:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ucfB0blmLkGEM6tg+Rdo3Vq8KNRGcH6GBoVqyR79Dpc=;
        b=IyXjIjF2HV/k1tkc1OLkSwBzo+mvJMvJu5mis7CT9BfgZ5NwN9upKa7Z41zcQnYg22
         fAtswdiOQAY2LvSVu2QwDR1VrXbphWB1TPB5JYEol00nltkjuP34OL/zFHk4s4opLKzW
         L9iBNXC6oWXIqsqbDP38Cokyjtc1WCoeKkH+lLQRSiEcYNj83JrwsQgDGy9vw5QRqj1I
         BJ7voiPNwyE+rUhb2eXiZt8uu9gBurxJnLPftvlN1UE0VyLc7g1Kp7atDm5EbK3BzxKA
         22UYXRRlPEq7QZfS6FteMuB6gZDHBNRCrOoGnL8GpCmtSL1WKvHkSN7FLJMNKOiQEKbO
         RQ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ucfB0blmLkGEM6tg+Rdo3Vq8KNRGcH6GBoVqyR79Dpc=;
        b=QMV+hUnf0t8vZLFBG0+20y5b/cyh+idjMHZCE/gm/BB9p+yplKoZoilmZQGSg8v2j8
         r7eOY6N+s1mLPXBbcLh49nhbez9yts6U3m8iggStAU9BwzwNi8y7fUssyhpAhgZcGGMQ
         C8FUFy2eehqCUVxi/boB/p9ItAGdGu9lG3ljS9uplArT5V7ewaKKmSpCb/NIS1V/irTm
         2n6FQ8glqarzsf0DyF5aJEVIYB00ySQQvhsOepVjrFAy8XlZsalf5J63RMuFKnnxDmDO
         Z7aUKapzweZbGLGeOQtRBdOny0t6FVKhkGmzddrmYlDTTyxOFOSS7tSd/6wCByOyqDA9
         h9FQ==
X-Gm-Message-State: AOAM533SrWt0o5gaGujKprO3l5rdiiV16wxS5PIf8/OvERRe5epXR/D/
        b43plDohU1OAONJ7RqYgYzH6Mt2XaTw=
X-Google-Smtp-Source: ABdhPJxbmc01HcmpCrJ89gwsO1ib3WmmrfKMAC92M4QpkEkY2tDjbc0il8qzVLXBJdZYjsJsHbST+Q==
X-Received: by 2002:a62:5302:0:b029:1ee:c519:8cdd with SMTP id h2-20020a6253020000b02901eec5198cddmr24874920pfb.79.1615275036103;
        Mon, 08 Mar 2021 23:30:36 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j3sm11521007pgk.24.2021.03.08.23.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 23:30:35 -0800 (PST)
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
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf-next 2/4] xdp: extend xdp_redirect_map with broadcast support
Date:   Tue,  9 Mar 2021 15:29:46 +0800
Message-Id: <20210309072948.2127710-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210309072948.2127710-1-liuhangbin@gmail.com>
References: <20210309072948.2127710-1-liuhangbin@gmail.com>
MIME-Version: 1.0
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

There are some drop back as we need to loop the map and get each
interface.

Version      | Test                                | Generic | Native
5.11         | redirect_map        i40e->i40e      |    1.9M |  9.3M
5.11         | redirect_map        i40e->veth      |    1.5M | 11.2M
5.11 + patch | redirect_map        i40e->i40e      |    1.9M |  9.6M
5.11 + patch | redirect_map        i40e->veth      |    1.5M | 11.9M
5.11 + patch | redirect_map_multi  i40e->i40e      |    1.5M |  7.7M
5.11 + patch | redirect_map_multi  i40e->veth      |    1.2M |  9.1M
5.11 + patch | redirect_map_multi  i40e->mlx4+veth |    0.9M |  3.2M

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/linux/bpf.h            |  16 +++++
 include/net/xdp.h              |   1 +
 include/uapi/linux/bpf.h       |  16 ++++-
 kernel/bpf/devmap.c            | 119 +++++++++++++++++++++++++++++++++
 net/core/filter.c              |  74 ++++++++++++++++++--
 net/core/xdp.c                 |  29 ++++++++
 tools/include/uapi/linux/bpf.h |  16 ++++-
 7 files changed, 260 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c931bc97019d..bb07ccd170f2 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1458,6 +1458,9 @@ int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
 int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
+bool dst_dev_is_ingress(struct bpf_dtab_netdev *obj, int ifindex);
+int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
+			  struct bpf_map *map, bool exclude_ingress);
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog);
 bool dev_map_can_have_prog(struct bpf_map *map);
@@ -1630,6 +1633,19 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
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
index 2d3036e292a9..4cca312f80ca 100644
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
@@ -5004,6 +5008,14 @@ enum {
 	BPF_F_BPRM_SECUREEXEC	= (1ULL << 0),
 };
 
+/* Flags for bpf_redirect_map helper */
+enum {
+	BPF_F_BROADCAST		= (1ULL << 3),
+	BPF_F_EXCLUDE_INGRESS	= (1ULL << 4),
+};
+#define BPF_F_ACTION_MASK (XDP_ABORTED | XDP_DROP | XDP_PASS | XDP_TX)
+#define BPF_F_REDIR_MASK (BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS)
+
 #define __bpf_md_ptr(type, name)	\
 union {					\
 	type name;			\
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f80cf5036d39..ad616a043d2a 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -519,6 +519,125 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
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
+	u32 *tmp_key = key;
+	u32 index;
+	int err;
+
+	err = devmap_get_next_key(map, tmp_key, next_key);
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
+		switch (map->map_type) {
+		case BPF_MAP_TYPE_DEVMAP:
+			obj = __dev_map_lookup_elem(map, *next_key);
+			break;
+		case BPF_MAP_TYPE_DEVMAP_HASH:
+			obj = __dev_map_hash_lookup_elem(map, *next_key);
+			break;
+		default:
+			break;
+		}
+
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
+		tmp_key = next_key;
+		err = devmap_get_next_key(map, tmp_key, next_key);
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
+	int ex_ifindex;
+	u32 key, next_key;
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
index 588b19ba0da8..b191718186ef 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3919,12 +3919,17 @@ static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
 };
 
 static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
-			    struct bpf_map *map, struct xdp_buff *xdp)
+			    struct bpf_map *map, struct xdp_buff *xdp,
+			    u32 flags)
 {
 	switch (map->map_type) {
 	case BPF_MAP_TYPE_DEVMAP:
 	case BPF_MAP_TYPE_DEVMAP_HASH:
-		return dev_map_enqueue(fwd, xdp, dev_rx);
+		if (flags & BPF_F_REDIR_BROADCAST)
+			return dev_map_enqueue_multi(xdp, dev_rx, map,
+						     flags & BPF_F_REDIR_EXCLUDE_INGRESS);
+		else
+			return dev_map_enqueue(fwd, xdp, dev_rx);
 	case BPF_MAP_TYPE_CPUMAP:
 		return cpu_map_enqueue(fwd, xdp, dev_rx);
 	case BPF_MAP_TYPE_XSKMAP:
@@ -3998,7 +4003,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 
 		err = dev_xdp_enqueue(fwd, xdp, dev);
 	} else {
-		err = __bpf_tx_xdp_map(dev, fwd, map, xdp);
+		err = __bpf_tx_xdp_map(dev, fwd, map, xdp, ri->flags);
 	}
 
 	if (unlikely(err))
@@ -4012,6 +4017,57 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
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
+		fwd = __xdp_map_lookup_elem(map, key);
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
@@ -4031,7 +4087,11 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
 	    map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
 		struct bpf_dtab_netdev *dst = fwd;
 
-		err = dev_map_generic_redirect(dst, skb, xdp_prog);
+		if (ri->flags & BPF_F_REDIR_BROADCAST)
+			err = dev_map_redirect_multi(dev, skb, xdp_prog, map,
+						     ri->flags & BPF_F_REDIR_EXCLUDE_INGRESS);
+		else
+			err = dev_map_generic_redirect(dst, skb, xdp_prog);
 		if (unlikely(err))
 			goto err;
 	} else if (map->map_type == BPF_MAP_TYPE_XSKMAP) {
@@ -4115,18 +4175,18 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 
 	/* Lower bits of the flags are used as return code on lookup failure */
-	if (unlikely(flags > XDP_TX))
+	if (unlikely(flags & ~(BPF_F_ACTION_MASK | BPF_F_REDIR_MASK)))
 		return XDP_ABORTED;
 
 	ri->tgt_value = __xdp_map_lookup_elem(map, ifindex);
-	if (unlikely(!ri->tgt_value)) {
+	if (unlikely(!ri->tgt_value) && !(flags & BPF_F_REDIR_BROADCAST)) {
 		/* If the lookup fails we want to clear out the state in the
 		 * redirect_info struct completely, so that if an eBPF program
 		 * performs multiple lookups, the last one always takes
 		 * precedence.
 		 */
 		WRITE_ONCE(ri->map, NULL);
-		return flags;
+		return flags & BPF_F_ACTION_MASK;
 	}
 
 	ri->flags = flags;
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
index 2d3036e292a9..4cca312f80ca 100644
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
@@ -5004,6 +5008,14 @@ enum {
 	BPF_F_BPRM_SECUREEXEC	= (1ULL << 0),
 };
 
+/* Flags for bpf_redirect_map helper */
+enum {
+	BPF_F_BROADCAST		= (1ULL << 3),
+	BPF_F_EXCLUDE_INGRESS	= (1ULL << 4),
+};
+#define BPF_F_ACTION_MASK (XDP_ABORTED | XDP_DROP | XDP_PASS | XDP_TX)
+#define BPF_F_REDIR_MASK (BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS)
+
 #define __bpf_md_ptr(type, name)	\
 union {					\
 	type name;			\
-- 
2.26.2

