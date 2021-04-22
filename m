Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDEF367AC5
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 09:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhDVHQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 03:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235070AbhDVHP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 03:15:58 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24869C06138B;
        Thu, 22 Apr 2021 00:15:24 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f29so32176325pgm.8;
        Thu, 22 Apr 2021 00:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oxs2nAt0B33rUDRDo4LAe54RxpmuA/6mQv8s0NyFiEo=;
        b=p3taUMPe07EP9VQfxleejK2lziOVVVJbwZwMK1UUjyX8krt0wA6iX2J5vcC1YxeMVk
         Y84E2loZSUfEs1EH9DyYqWhu9gQkhtMJ1YHfih+2LfmjMgBU12Men1cWztoPRraPB2w8
         rs661HB550x1xV9Jddncfd/LypI+UGoYpo7GRFGTqbgWYH9sI3q//3QvxOGAvoqc+T8v
         Ly8P5S+3O0YnDNOHp9Dh1zDAmQ7RZPj9BYAuLse5bpN4XyS+tvJyfX6XvHsvxm4HkYxn
         C9bmcG3mX5WJOWHI6NSg9OXaJByqe4nleR07OWW0sxUqbG2Fllu/3jqN3464iz7lN2Xc
         M5vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oxs2nAt0B33rUDRDo4LAe54RxpmuA/6mQv8s0NyFiEo=;
        b=VnWlDxnZ7AOS28qXPsNm5Lp4BthOtZzp2CFyx3qnBGKKweE6Pg/S5ceeBxqY3m3hT3
         xpMjpZbqElb7X0sN82DFemklnbcX7jrQfmtJiuqYLFUuwhgo0pCO0ovxFcv+wqZhTQea
         6H7PJ9CInNwUACKm8BDR/Je/splG0UpbLQ+Eb6eacZH1Xp/dIcE1Qs2bmSOtuVK5z3xY
         74Y5U/3uzA9vIfk3Gv2/+o0X69GSwJp/1CHw+w7kFZ9bw7FIvgXhKKtY0M0FRTeJmRZa
         NTNxvFvHc1btpURpSEYSQgfIZVCcCt3+QVaBsgiPKChTYN/KY42kkEXBU7ookEE7gwyG
         /KaA==
X-Gm-Message-State: AOAM530kbBPVkyicrV4dWtt9VfHzXv1A/RN29t6pX77c72Qn/BH/wZxC
        p5hjC6/qCX0i77lUK+u0Db6+HGL8WkOrGQ==
X-Google-Smtp-Source: ABdhPJxCIXQCvMisml5Bag9HlNinS5HbBhDMSvi8IggQE0jVbPbW/tVQS8/TWi+GqpHd+KYs50vbng==
X-Received: by 2002:a63:1f4d:: with SMTP id q13mr2120089pgm.453.1619075723277;
        Thu, 22 Apr 2021 00:15:23 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u21sm1181816pfm.89.2021.04.22.00.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:15:22 -0700 (PDT)
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
Subject: [PATCHv9 bpf-next 2/4] xdp: extend xdp_redirect_map with broadcast support
Date:   Thu, 22 Apr 2021 15:14:52 +0800
Message-Id: <20210422071454.2023282-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210422071454.2023282-1-liuhangbin@gmail.com>
References: <20210422071454.2023282-1-liuhangbin@gmail.com>
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

Here is the performance result by using 10Gb i40e NIC, do XDP_DROP on
veth peer, run xdp_redirect_{map, map_multi} in sample/bpf and send pkts
via pktgen cmd:
./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t 10 -s 64

There are some drop back as we need to loop the map and get each interface.

Version          | Test                                | Generic | Native
5.12 rc4         | redirect_map        i40e->i40e      |    1.9M |  9.6M
5.12 rc4         | redirect_map        i40e->veth      |    1.7M | 11.7M
5.12 rc4 + patch | redirect_map        i40e->i40e      |    1.9M |  9.3M
5.12 rc4 + patch | redirect_map        i40e->veth      |    1.7M | 11.4M
5.12 rc4 + patch | redirect_map multi  i40e->i40e      |    1.9M |  8.9M
5.12 rc4 + patch | redirect_map multi  i40e->veth      |    1.7M | 10.9M
5.12 rc4 + patch | redirect_map multi  i40e->mlx4+veth |    1.2M |  3.8M

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

---
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
 include/linux/filter.h         |  18 +++-
 include/net/xdp.h              |   1 +
 include/uapi/linux/bpf.h       |  17 +++-
 kernel/bpf/cpumap.c            |   3 +-
 kernel/bpf/devmap.c            | 181 ++++++++++++++++++++++++++++++++-
 net/core/filter.c              |  33 +++++-
 net/core/xdp.c                 |  29 ++++++
 net/xdp/xskmap.c               |   3 +-
 tools/include/uapi/linux/bpf.h |  17 +++-
 10 files changed, 308 insertions(+), 14 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f8a45f109e96..4243284fff8b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1497,8 +1497,13 @@ int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
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
@@ -1666,6 +1671,13 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
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
@@ -1675,6 +1687,14 @@ static inline int dev_map_generic_redirect(struct bpf_dtab_netdev *dst,
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
index ec6d85a81744..c6fe0526811b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2534,8 +2534,12 @@ union bpf_attr {
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
@@ -5080,6 +5084,15 @@ enum {
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
index 3980fb3bfb09..2eebb9a4b093 100644
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
@@ -755,12 +930,14 @@ static int dev_map_hash_update_elem(struct bpf_map *map, void *key, void *value,
 
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
index cae56d08a670..afec192c3b21 100644
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
@@ -3933,6 +3950,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	enum bpf_map_type map_type = ri->map_type;
 	void *fwd = ri->tgt_value;
 	u32 map_id = ri->map_id;
+	struct bpf_map *map;
 	int err;
 
 	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
@@ -3942,7 +3960,12 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	case BPF_MAP_TYPE_DEVMAP:
 		fallthrough;
 	case BPF_MAP_TYPE_DEVMAP_HASH:
-		err = dev_map_enqueue(fwd, xdp, dev);
+		map = xchg(&ri->map, NULL);
+		if (map)
+			err = dev_map_enqueue_multi(xdp, dev, map,
+						    ri->flags & BPF_F_EXCLUDE_INGRESS);
+		else
+			err = dev_map_enqueue(fwd, xdp, dev);
 		break;
 	case BPF_MAP_TYPE_CPUMAP:
 		err = cpu_map_enqueue(fwd, xdp, dev);
@@ -3984,13 +4007,19 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
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
+		map = xchg(&ri->map, NULL);
+		if (map)
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
index ec6d85a81744..c6fe0526811b 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2534,8 +2534,12 @@ union bpf_attr {
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
@@ -5080,6 +5084,15 @@ enum {
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

