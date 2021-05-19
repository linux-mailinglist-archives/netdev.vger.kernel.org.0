Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F02388A36
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 11:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237196AbhESJJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 05:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344591AbhESJJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 05:09:34 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71B5C06175F;
        Wed, 19 May 2021 02:08:14 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id lx17-20020a17090b4b11b029015f3b32b8dbso1373876pjb.0;
        Wed, 19 May 2021 02:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OSvbU5c9xYrB8SfU14TKAMhIpCXqf4fihFplWImUmjc=;
        b=EUjVCVx9cJCAB+zbJ6uAX+pKr+Sb7LO0Pvu2Hj00ztNI3H4oMGTQDsWbRXbeNqtWUd
         qlyWekG1fcLbTh1SlRrG6xLGxahRyFyt5TU7lxXgxGJZK0JeqwCnAcFMhGsBVo+3394h
         0ImiCXPVbeGrGcU8W/qYD2Qps+ELfLPG9tHBIeZj5M/YsgCGLDmdaPEXKunRFhb3fWKA
         T8FXJclobQ21ZqmbmiMWHd5C2jA8PBS7WoOCQ/AYcXQ3kyGpXnSVmPNR+VhFhpCzCJS6
         ryu5qxLfVI3R5zCXK8jmi/i6o5hegOvz2KhVpO+2mC5z9fkOzKnY+vkkF2un/Apv96VH
         U+lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OSvbU5c9xYrB8SfU14TKAMhIpCXqf4fihFplWImUmjc=;
        b=rkrT56zjZ/U1xGa1wXTqnfFdGL4xwNcMEYFR3DgPHFOxAHQ22fWUAwJvcPEVJEwli8
         2NO7chYhZnvRAdMiGAXpVaBIxm5jTVq4alGMl16MwPM2ObntzMS2rpCvhStmGcb3FfrJ
         iL/+ucTwlIDUwqoygE3TGiFH0mt+sajfm+T3BJuIM430TNVelMYKNnXkb8YVLByIKolK
         PRnM2J5pNkKn2x+5qLvh+7k+3HLU7M2+DccIwNUXVOHrm93F362YLkuxtrT52PquMxld
         d8Rum/Lq/7RzX9kI33LW1qQdm/TdAwJbEHluOXHEh78JkEKfi6ku3/UlTDE0o/qJdS59
         8VVg==
X-Gm-Message-State: AOAM533aZ5fLz15OgUorSMZbuhF24lJzgQDQ9tIfsIwOe08hb7o0CiZ9
        lWWoWadrEXoRAB4t/HNNFlMg+4uliiClXQ==
X-Google-Smtp-Source: ABdhPJxviqjzT7EmgGR9LPfRIRHJ4AD9jUyg37leCYiM/XA4/EBDVMhncrw89VdprAsNTkOMDhZ5SA==
X-Received: by 2002:a17:90b:4384:: with SMTP id in4mr1151974pjb.159.1621415294010;
        Wed, 19 May 2021 02:08:14 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s6sm14701848pgv.48.2021.05.19.02.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 02:08:13 -0700 (PDT)
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
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH v12 bpf-next 2/4] xdp: extend xdp_redirect_map with broadcast support
Date:   Wed, 19 May 2021 17:07:45 +0800
Message-Id: <20210519090747.1655268-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210519090747.1655268-1-liuhangbin@gmail.com>
References: <20210519090747.1655268-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds two flags BPF_F_BROADCAST and BPF_F_EXCLUDE_INGRESS to
extend xdp_redirect_map for broadcast support.

With BPF_F_BROADCAST the packet will be broadcasted to all the interfaces
in the map. with BPF_F_EXCLUDE_INGRESS the ingress interface will be
excluded when do broadcasting.

When getting the devices in dev hash map via dev_map_hash_get_next_key(),
there is a possibility that we fall back to the first key when a device
was removed. This will duplicate packets on some interfaces. So just walk
the whole buckets to avoid this issue. For dev array map, we also walk the
whole map to find valid interfaces.

Function bpf_clear_redirect_map() was removed in
commit ee75aef23afe ("bpf, xdp: Restructure redirect actions").
Add it back as we need to use ri->map again.

With test topology:
  +-------------------+             +-------------------+
  | Host A (i40e 10G) |  ---------- | eno1(i40e 10G)    |
  +-------------------+             |                   |
                                    |   Host B          |
  +-------------------+             |                   |
  | Host C (i40e 10G) |  ---------- | eno2(i40e 10G)    |
  +-------------------+             |                   |
                                    |          +------+ |
                                    | veth0 -- | Peer | |
                                    | veth1 -- |      | |
                                    | veth2 -- |  NS  | |
                                    |          +------+ |
                                    +-------------------+

On Host A:
 # pktgen/pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -s 64

On Host B(Intel(R) Xeon(R) CPU E5-2690 v3 @ 2.60GHz, 128G Memory):
Use xdp_redirect_map and xdp_redirect_map_multi in samples/bpf for testing.
All the veth peers in the NS have a XDP_DROP program loaded. The
forward_map max_entries in xdp_redirect_map_multi is modify to 4.

Testing the performance impact on the regular xdp_redirect path with and
without patch (to check impact of additional check for broadcast mode):

5.12 rc4         | redirect_map        i40e->i40e      |    2.0M |  9.7M
5.12 rc4         | redirect_map        i40e->veth      |    1.7M | 11.8M
5.12 rc4 + patch | redirect_map        i40e->i40e      |    2.0M |  9.6M
5.12 rc4 + patch | redirect_map        i40e->veth      |    1.7M | 11.7M

Testing the performance when cloning packets with the redirect_map_multi
test, using a redirect map size of 4, filled with 1-3 devices:

5.12 rc4 + patch | redirect_map multi  i40e->veth (x1) |    1.7M | 11.4M
5.12 rc4 + patch | redirect_map multi  i40e->veth (x2) |    1.1M |  4.3M
5.12 rc4 + patch | redirect_map multi  i40e->veth (x3) |    0.8M |  2.6M

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
v12: As Daniel pointed out:
a) use const u64 for flag_mask in __bpf_xdp_redirect_map()
b) remove BPF_F_ACTION_MASK in uapi header
c) remove EXPORT_SYMBOL_GPL for xdpf_clone()

v11:
a) Use unlikely() when checking if this is for broadcast redirecting.
b) Fix the tracepoint NULL pointer issue Jesper found
c) Remove BPF_F_REDIR_MASK and just use OR flags to make the reader more
   clear about what's going on
d) Add the performace number with multi veth interfaces in commit
   description.

v10:
Remind by Jesper: revert xchg() and use READ/WRITE_ONCE when read/write map
pointer as xchg call can be expensive, since this is an atomic operation.

v9: no update

v8:
use hlist_for_each_entry_rcu() when loop the devmap hash ojbs

v7:
no need to free xdpf in dev_map_enqueue_clone() if xdpf_clone failed.
Also return -EOVERFLOW if xdp_convert_buff_to_frame() failed the same
as other caller did.

v6:
Fix a skb leak in the error path for generic XDP

v5:
a) use xchg() instead of READ/WRITE_ONCE and no need to clear ri->flags
   in xdp_do_redirect()
b) Do not use get_next_key() as we may restart looping from the first key
   when remove/update a dev in hash map. Just walk the map directly to
   get all the devices and ignore the new added/deleted objects.
c) Loop all the array map instead stop at the first hole.

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
 include/linux/bpf.h            |  20 ++++
 include/linux/filter.h         |  19 +++-
 include/net/xdp.h              |   1 +
 include/trace/events/xdp.h     |   6 +-
 include/uapi/linux/bpf.h       |  14 ++-
 kernel/bpf/cpumap.c            |   3 +-
 kernel/bpf/devmap.c            | 183 ++++++++++++++++++++++++++++++++-
 net/core/filter.c              |  37 ++++++-
 net/core/xdp.c                 |  28 +++++
 net/xdp/xskmap.c               |   3 +-
 tools/include/uapi/linux/bpf.h |  14 ++-
 11 files changed, 313 insertions(+), 15 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9dc44ba97584..bbd9dbb22e9a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1499,8 +1499,13 @@ int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
 int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 		    struct net_device *dev_rx);
+int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
+			  struct bpf_map *map, bool exclude_ingress);
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog);
+int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
+			   struct bpf_prog *xdp_prog, struct bpf_map *map,
+			   bool exclude_ingress);
 bool dev_map_can_have_prog(struct bpf_map *map);
 
 void __cpu_map_flush(void);
@@ -1668,6 +1673,13 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 	return 0;
 }
 
+static inline
+int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
+			  struct bpf_map *map, bool exclude_ingress)
+{
+	return 0;
+}
+
 struct sk_buff;
 
 static inline int dev_map_generic_redirect(struct bpf_dtab_netdev *dst,
@@ -1677,6 +1689,14 @@ static inline int dev_map_generic_redirect(struct bpf_dtab_netdev *dst,
 	return 0;
 }
 
+static inline
+int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
+			   struct bpf_prog *xdp_prog, struct bpf_map *map,
+			   bool exclude_ingress)
+{
+	return 0;
+}
+
 static inline void __cpu_map_flush(void)
 {
 }
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 9a09547bc7ba..2a1d655b889d 100644
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
@@ -1464,17 +1465,19 @@ static inline bool bpf_sk_lookup_run_v6(struct net *net, int protocol,
 }
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 
-static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifindex, u64 flags,
+static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifindex,
+						  u64 flags, const u64 flag_mask,
 						  void *lookup_elem(struct bpf_map *map, u32 key))
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	const u64 action_mask = XDP_ABORTED | XDP_DROP | XDP_PASS | XDP_TX;
 
 	/* Lower bits of the flags are used as return code on lookup failure */
-	if (unlikely(flags > XDP_TX))
+	if (unlikely(flags & ~(action_mask | flag_mask)))
 		return XDP_ABORTED;
 
 	ri->tgt_value = lookup_elem(map, ifindex);
-	if (unlikely(!ri->tgt_value)) {
+	if (unlikely(!ri->tgt_value) && !(flags & BPF_F_BROADCAST)) {
 		/* If the lookup fails we want to clear out the state in the
 		 * redirect_info struct completely, so that if an eBPF program
 		 * performs multiple lookups, the last one always takes
@@ -1482,13 +1485,21 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
 		 */
 		ri->map_id = INT_MAX; /* Valid map id idr range: [1,INT_MAX[ */
 		ri->map_type = BPF_MAP_TYPE_UNSPEC;
-		return flags;
+		return flags & action_mask;
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
diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index fcad3645a70b..c40fc97f9417 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -110,7 +110,11 @@ DECLARE_EVENT_CLASS(xdp_redirect_template,
 		u32 ifindex = 0, map_index = index;
 
 		if (map_type == BPF_MAP_TYPE_DEVMAP || map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
-			ifindex = ((struct _bpf_dtab_netdev *)tgt)->dev->ifindex;
+			/* Just leave to_ifindex to 0 if do broadcast redirect,
+			 * as tgt will be NULL.
+			 */
+			if (tgt)
+				ifindex = ((struct _bpf_dtab_netdev *)tgt)->dev->ifindex;
 		} else if (map_type == BPF_MAP_TYPE_UNSPEC && map_id == INT_MAX) {
 			ifindex = index;
 			map_index = 0;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4cd9a0181f27..c7f7967d9a5d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2541,8 +2541,12 @@ union bpf_attr {
  * 		The lower two bits of *flags* are used as the return code if
  * 		the map lookup fails. This is so that the return value can be
  * 		one of the XDP program return codes up to **XDP_TX**, as chosen
- * 		by the caller. Any higher bits in the *flags* argument must be
- * 		unset.
+ * 		by the caller. The higher bits of *flags* can be set to
+ * 		BPF_F_BROADCAST or BPF_F_EXCLUDE_INGRESS as defined below.
+ *
+ * 		With BPF_F_BROADCAST the packet will be broadcasted to all the
+ * 		interfaces in the map, with BPF_F_EXCLUDE_INGRESS the ingress
+ * 		interface will be excluded when do broadcasting.
  *
  * 		See also **bpf_redirect**\ (), which only supports redirecting
  * 		to an ifindex, but doesn't require a map to do so.
@@ -5108,6 +5112,12 @@ enum {
 	BPF_F_BPRM_SECUREEXEC	= (1ULL << 0),
 };
 
+/* Flags for bpf_redirect_map helper */
+enum {
+	BPF_F_BROADCAST		= (1ULL << 3),
+	BPF_F_EXCLUDE_INGRESS	= (1ULL << 4),
+};
+
 #define __bpf_md_ptr(type, name)	\
 union {					\
 	type name;			\
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 5dd3e866599a..a1a0c4e791c6 100644
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
index 3980fb3bfb09..5262a62355a1 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -198,6 +198,7 @@ static void dev_map_free(struct bpf_map *map)
 	list_del_rcu(&dtab->list);
 	spin_unlock(&dev_map_lock);
 
+	bpf_clear_redirect_map(map);
 	synchronize_rcu();
 
 	/* Make sure prior __dev_map_entry_free() have completed. */
@@ -515,6 +516,99 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 	return __xdp_enqueue(dev, xdp, dev_rx, dst->xdp_prog);
 }
 
+static bool is_valid_dst(struct bpf_dtab_netdev *obj, struct xdp_buff *xdp,
+			 int exclude_ifindex)
+{
+	if (!obj || obj->dev->ifindex == exclude_ifindex ||
+	    !obj->dev->netdev_ops->ndo_xdp_xmit)
+		return false;
+
+	if (xdp_ok_fwd_dev(obj->dev, xdp->data_end - xdp->data))
+		return false;
+
+	return true;
+}
+
+static int dev_map_enqueue_clone(struct bpf_dtab_netdev *obj,
+				 struct net_device *dev_rx,
+				 struct xdp_frame *xdpf)
+{
+	struct xdp_frame *nxdpf;
+
+	nxdpf = xdpf_clone(xdpf);
+	if (!nxdpf)
+		return -ENOMEM;
+
+	bq_enqueue(obj->dev, nxdpf, dev_rx, obj->xdp_prog);
+
+	return 0;
+}
+
+int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
+			  struct bpf_map *map, bool exclude_ingress)
+{
+	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
+	int exclude_ifindex = exclude_ingress ? dev_rx->ifindex : 0;
+	struct bpf_dtab_netdev *dst, *last_dst = NULL;
+	struct hlist_head *head;
+	struct xdp_frame *xdpf;
+	unsigned int i;
+	int err;
+
+	xdpf = xdp_convert_buff_to_frame(xdp);
+	if (unlikely(!xdpf))
+		return -EOVERFLOW;
+
+	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
+		for (i = 0; i < map->max_entries; i++) {
+			dst = READ_ONCE(dtab->netdev_map[i]);
+			if (!is_valid_dst(dst, xdp, exclude_ifindex))
+				continue;
+
+			/* we only need n-1 clones; last_dst enqueued below */
+			if (!last_dst) {
+				last_dst = dst;
+				continue;
+			}
+
+			err = dev_map_enqueue_clone(last_dst, dev_rx, xdpf);
+			if (err)
+				return err;
+
+			last_dst = dst;
+		}
+	} else { /* BPF_MAP_TYPE_DEVMAP_HASH */
+		for (i = 0; i < dtab->n_buckets; i++) {
+			head = dev_map_index_hash(dtab, i);
+			hlist_for_each_entry_rcu(dst, head, index_hlist,
+						 lockdep_is_held(&dtab->index_lock)) {
+				if (!is_valid_dst(dst, xdp, exclude_ifindex))
+					continue;
+
+				/* we only need n-1 clones; last_dst enqueued below */
+				if (!last_dst) {
+					last_dst = dst;
+					continue;
+				}
+
+				err = dev_map_enqueue_clone(last_dst, dev_rx, xdpf);
+				if (err)
+					return err;
+
+				last_dst = dst;
+			}
+		}
+	}
+
+	/* consume the last copy of the frame */
+	if (last_dst)
+		bq_enqueue(last_dst->dev, xdpf, dev_rx, last_dst->xdp_prog);
+	else
+		xdp_return_frame_rx_napi(xdpf); /* dtab is empty */
+
+	return 0;
+}
+
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog)
 {
@@ -529,6 +623,87 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 	return 0;
 }
 
+static int dev_map_redirect_clone(struct bpf_dtab_netdev *dst,
+				  struct sk_buff *skb,
+				  struct bpf_prog *xdp_prog)
+{
+	struct sk_buff *nskb;
+	int err;
+
+	nskb = skb_clone(skb, GFP_ATOMIC);
+	if (!nskb)
+		return -ENOMEM;
+
+	err = dev_map_generic_redirect(dst, nskb, xdp_prog);
+	if (unlikely(err)) {
+		consume_skb(nskb);
+		return err;
+	}
+
+	return 0;
+}
+
+int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
+			   struct bpf_prog *xdp_prog, struct bpf_map *map,
+			   bool exclude_ingress)
+{
+	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
+	int exclude_ifindex = exclude_ingress ? dev->ifindex : 0;
+	struct bpf_dtab_netdev *dst, *last_dst = NULL;
+	struct hlist_head *head;
+	struct hlist_node *next;
+	unsigned int i;
+	int err;
+
+	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
+		for (i = 0; i < map->max_entries; i++) {
+			dst = READ_ONCE(dtab->netdev_map[i]);
+			if (!dst || dst->dev->ifindex == exclude_ifindex)
+				continue;
+
+			/* we only need n-1 clones; last_dst enqueued below */
+			if (!last_dst) {
+				last_dst = dst;
+				continue;
+			}
+
+			err = dev_map_redirect_clone(last_dst, skb, xdp_prog);
+			if (err)
+				return err;
+
+			last_dst = dst;
+		}
+	} else { /* BPF_MAP_TYPE_DEVMAP_HASH */
+		for (i = 0; i < dtab->n_buckets; i++) {
+			head = dev_map_index_hash(dtab, i);
+			hlist_for_each_entry_safe(dst, next, head, index_hlist) {
+				if (!dst || dst->dev->ifindex == exclude_ifindex)
+					continue;
+
+				/* we only need n-1 clones; last_dst enqueued below */
+				if (!last_dst) {
+					last_dst = dst;
+					continue;
+				}
+
+				err = dev_map_redirect_clone(last_dst, skb, xdp_prog);
+				if (err)
+					return err;
+
+				last_dst = dst;
+			}
+		}
+	}
+
+	/* consume the first skb and return */
+	if (last_dst)
+		return dev_map_generic_redirect(last_dst, skb, xdp_prog);
+
+	/* dtab is empty */
+	consume_skb(skb);
+	return 0;
+}
+
 static void *dev_map_lookup_elem(struct bpf_map *map, void *key)
 {
 	struct bpf_dtab_netdev *obj = __dev_map_lookup_elem(map, *(u32 *)key);
@@ -755,12 +930,16 @@ static int dev_map_hash_update_elem(struct bpf_map *map, void *key, void *value,
 
 static int dev_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
 {
-	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_lookup_elem);
+	return __bpf_xdp_redirect_map(map, ifindex, flags,
+				      BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS,
+				      __dev_map_lookup_elem);
 }
 
 static int dev_hash_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
 {
-	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_hash_lookup_elem);
+	return __bpf_xdp_redirect_map(map, ifindex, flags,
+				      BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS,
+				      __dev_map_hash_lookup_elem);
 }
 
 static int dev_map_btf_id;
diff --git a/net/core/filter.c b/net/core/filter.c
index 582ac196fd94..caa88955562e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3930,6 +3930,23 @@ void xdp_do_flush(void)
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
@@ -3937,6 +3954,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	enum bpf_map_type map_type = ri->map_type;
 	void *fwd = ri->tgt_value;
 	u32 map_id = ri->map_id;
+	struct bpf_map *map;
 	int err;
 
 	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
@@ -3946,7 +3964,14 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	case BPF_MAP_TYPE_DEVMAP:
 		fallthrough;
 	case BPF_MAP_TYPE_DEVMAP_HASH:
-		err = dev_map_enqueue(fwd, xdp, dev);
+		map = READ_ONCE(ri->map);
+		if (unlikely(map)) {
+			WRITE_ONCE(ri->map, NULL);
+			err = dev_map_enqueue_multi(xdp, dev, map,
+						    ri->flags & BPF_F_EXCLUDE_INGRESS);
+		} else {
+			err = dev_map_enqueue(fwd, xdp, dev);
+		}
 		break;
 	case BPF_MAP_TYPE_CPUMAP:
 		err = cpu_map_enqueue(fwd, xdp, dev);
@@ -3988,13 +4013,21 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
 				       enum bpf_map_type map_type, u32 map_id)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+	struct bpf_map *map;
 	int err;
 
 	switch (map_type) {
 	case BPF_MAP_TYPE_DEVMAP:
 		fallthrough;
 	case BPF_MAP_TYPE_DEVMAP_HASH:
-		err = dev_map_generic_redirect(fwd, skb, xdp_prog);
+		map = READ_ONCE(ri->map);
+		if (unlikely(map)) {
+			WRITE_ONCE(ri->map, NULL);
+			err = dev_map_redirect_multi(dev, skb, xdp_prog, map,
+						     ri->flags & BPF_F_EXCLUDE_INGRESS);
+		} else {
+			err = dev_map_generic_redirect(fwd, skb, xdp_prog);
+		}
 		if (unlikely(err))
 			goto err;
 		break;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 858276e72c68..725d20f1b100 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -584,3 +584,31 @@ struct sk_buff *xdp_build_skb_from_frame(struct xdp_frame *xdpf,
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
index 4cd9a0181f27..c7f7967d9a5d 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2541,8 +2541,12 @@ union bpf_attr {
  * 		The lower two bits of *flags* are used as the return code if
  * 		the map lookup fails. This is so that the return value can be
  * 		one of the XDP program return codes up to **XDP_TX**, as chosen
- * 		by the caller. Any higher bits in the *flags* argument must be
- * 		unset.
+ * 		by the caller. The higher bits of *flags* can be set to
+ * 		BPF_F_BROADCAST or BPF_F_EXCLUDE_INGRESS as defined below.
+ *
+ * 		With BPF_F_BROADCAST the packet will be broadcasted to all the
+ * 		interfaces in the map, with BPF_F_EXCLUDE_INGRESS the ingress
+ * 		interface will be excluded when do broadcasting.
  *
  * 		See also **bpf_redirect**\ (), which only supports redirecting
  * 		to an ifindex, but doesn't require a map to do so.
@@ -5108,6 +5112,12 @@ enum {
 	BPF_F_BPRM_SECUREEXEC	= (1ULL << 0),
 };
 
+/* Flags for bpf_redirect_map helper */
+enum {
+	BPF_F_BROADCAST		= (1ULL << 3),
+	BPF_F_EXCLUDE_INGRESS	= (1ULL << 4),
+};
+
 #define __bpf_md_ptr(type, name)	\
 union {					\
 	type name;			\
-- 
2.26.3

