Return-Path: <netdev+bounces-5511-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBCF5711F55
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 07:47:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29F231C20FA6
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 05:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEC8D23D0;
	Fri, 26 May 2023 05:46:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEC43FDD
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:46:50 +0000 (UTC)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBBF18D;
	Thu, 25 May 2023 22:46:47 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-64d293746e0so673751b3a.2;
        Thu, 25 May 2023 22:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685080007; x=1687672007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHeQMj+xAo0NnseVRzSbOYZ5Sabxsp0MjOVLytYHXK0=;
        b=D0Jq4y9K2BUnlfdg8RDRCGdlvk0sJ57RBG87b3mWA0nwnHUCpwRBBV2PDy3w7jfEbH
         DZlGWnnVs8DrYwvsQPoi+Qf080JLn7+9x/d0EofdWMWWgYfSveYpTcEMLuwoxZ23KPmS
         lk11VgIS8HgRJYGhNUXhYHLOWZ/YPeERFQ0INdZtoWBdrevwJL/r8GqU2fT57TbHipt/
         4xwenzl8f/bk5RANPeQslyC4i7klwZnX/fjzcdkdGt2ILNaz8ww//Q53xZnoCSp8l2dS
         VnQ2vqDxLZkCzFjmIKHjZBvTVnjaJp7a59kmJI421fhW6l6YT5RjNorTprQqoWOo7nGH
         +6/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685080007; x=1687672007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kHeQMj+xAo0NnseVRzSbOYZ5Sabxsp0MjOVLytYHXK0=;
        b=Qf7UWF8urKn0fg+ZQfcGKlKwvtLigTAOoCW5iw/o9VQPK7Pk6e9GdUqehUPfFXIUM/
         NqxdqZEMsTGQTzQnGxoAlTBuUhiMWYjwVP0qOb/PXAHIAm1b4DgmFKXorUH52CxkYszM
         6WntxJNuY2+5q/qSTYXpLRZPcOyvsQbLFnkxJY9FJ+aAG/AkDvlooqgwPhmsdZR13xb9
         UCGjU3n+UqhSDV4rtX9Ofxkffk/AWb2bVJfwzLUKOb0gwIU0509L2QTg3AMu03V9/Ubj
         vg/7AFV0GFXB9ILog8KD948QhlcfBMtUhrvCENAjWPa2dYEP/t5dLX51iBp1BiSrO6G+
         k88A==
X-Gm-Message-State: AC+VfDzoi5ylkDXkTA7z9vHKgtQs7AbvGQFESzV3Pa/PR6EYOgYEBWm4
	5wMInMxkyO7qg7yTFvpA//c=
X-Google-Smtp-Source: ACHHUZ5WsAsc6UJDl0rxMpZPi94VpLYtU3ExmdPffuLi3I9P/O5JAAm6cYMmm6hTWt3XXRMDwicoCA==
X-Received: by 2002:a05:6a20:d90b:b0:103:377e:439e with SMTP id jd11-20020a056a20d90b00b00103377e439emr804949pzb.60.1685080007064;
        Thu, 25 May 2023 22:46:47 -0700 (PDT)
Received: from localhost.localdomain ([104.149.188.130])
        by smtp.gmail.com with ESMTPSA id b23-20020a6567d7000000b0050a0227a4bcsm1836485pgs.57.2023.05.25.22.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 22:46:45 -0700 (PDT)
From: Liang Chen <liangchen.linux@gmail.com>
To: jasowang@redhat.com,
	mst@redhat.com
Cc: virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xuanzhuo@linux.alibaba.com,
	kuba@kernel.org,
	edumazet@google.com,
	davem@davemloft.net,
	pabeni@redhat.com,
	alexander.duyck@gmail.com,
	Liang Chen <liangchen.linux@gmail.com>
Subject: [PATCH net-next 2/5] virtio_net: Add page_pool support to improve performance
Date: Fri, 26 May 2023 13:46:18 +0800
Message-Id: <20230526054621.18371-2-liangchen.linux@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230526054621.18371-1-liangchen.linux@gmail.com>
References: <20230526054621.18371-1-liangchen.linux@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The implementation at the moment uses one page per packet in both the
normal and XDP path. In addition, introducing a module parameter to enable
or disable the usage of page pool (disabled by default).

In single-core vm testing environments, it gives a modest performance gain
in the normal path.
  Upstream codebase: 47.5 Gbits/sec
  Upstream codebase + page_pool support: 50.2 Gbits/sec

In multi-core vm testing environments, The most significant performance
gain is observed in XDP cpumap:
  Upstream codebase: 1.38 Gbits/sec
  Upstream codebase + page_pool support: 9.74 Gbits/sec

With this foundation, we can further integrate page pool fragmentation and
DMA map/unmap support.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 drivers/net/virtio_net.c | 188 ++++++++++++++++++++++++++++++---------
 1 file changed, 146 insertions(+), 42 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c5dca0d92e64..99c0ca0c1781 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -31,6 +31,9 @@ module_param(csum, bool, 0444);
 module_param(gso, bool, 0444);
 module_param(napi_tx, bool, 0644);
 
+static bool page_pool_enabled;
+module_param(page_pool_enabled, bool, 0400);
+
 /* FIXME: MTU in config. */
 #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
 #define GOOD_COPY_LEN	128
@@ -159,6 +162,9 @@ struct receive_queue {
 	/* Chain pages by the private ptr. */
 	struct page *pages;
 
+	/* Page pool */
+	struct page_pool *page_pool;
+
 	/* Average packet length for mergeable receive buffers. */
 	struct ewma_pkt_len mrg_avg_pkt_len;
 
@@ -459,6 +465,14 @@ static struct sk_buff *virtnet_build_skb(void *buf, unsigned int buflen,
 	return skb;
 }
 
+static void virtnet_put_page(struct receive_queue *rq, struct page *page)
+{
+	if (rq->page_pool)
+		page_pool_put_full_page(rq->page_pool, page, true);
+	else
+		put_page(page);
+}
+
 /* Called from bottom half context */
 static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 				   struct receive_queue *rq,
@@ -555,7 +569,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	hdr = skb_vnet_hdr(skb);
 	memcpy(hdr, hdr_p, hdr_len);
 	if (page_to_free)
-		put_page(page_to_free);
+		virtnet_put_page(rq, page_to_free);
 
 	return skb;
 }
@@ -802,7 +816,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	return ret;
 }
 
-static void put_xdp_frags(struct xdp_buff *xdp)
+static void put_xdp_frags(struct xdp_buff *xdp, struct receive_queue *rq)
 {
 	struct skb_shared_info *shinfo;
 	struct page *xdp_page;
@@ -812,7 +826,7 @@ static void put_xdp_frags(struct xdp_buff *xdp)
 		shinfo = xdp_get_shared_info_from_buff(xdp);
 		for (i = 0; i < shinfo->nr_frags; i++) {
 			xdp_page = skb_frag_page(&shinfo->frags[i]);
-			put_page(xdp_page);
+			virtnet_put_page(rq, xdp_page);
 		}
 	}
 }
@@ -903,7 +917,11 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 	if (page_off + *len + tailroom > PAGE_SIZE)
 		return NULL;
 
-	page = alloc_page(GFP_ATOMIC);
+	if (rq->page_pool)
+		page = page_pool_dev_alloc_pages(rq->page_pool);
+	else
+		page = alloc_page(GFP_ATOMIC);
+
 	if (!page)
 		return NULL;
 
@@ -926,21 +944,24 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 		 * is sending packet larger than the MTU.
 		 */
 		if ((page_off + buflen + tailroom) > PAGE_SIZE) {
-			put_page(p);
+			virtnet_put_page(rq, p);
 			goto err_buf;
 		}
 
 		memcpy(page_address(page) + page_off,
 		       page_address(p) + off, buflen);
 		page_off += buflen;
-		put_page(p);
+		virtnet_put_page(rq, p);
 	}
 
 	/* Headroom does not contribute to packet length */
 	*len = page_off - VIRTIO_XDP_HEADROOM;
 	return page;
 err_buf:
-	__free_pages(page, 0);
+	if (rq->page_pool)
+		page_pool_put_full_page(rq->page_pool, page, true);
+	else
+		__free_pages(page, 0);
 	return NULL;
 }
 
@@ -1144,7 +1165,7 @@ static void mergeable_buf_free(struct receive_queue *rq, int num_buf,
 		}
 		stats->bytes += len;
 		page = virt_to_head_page(buf);
-		put_page(page);
+		virtnet_put_page(rq, page);
 	}
 }
 
@@ -1264,7 +1285,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
 		cur_frag_size = truesize;
 		xdp_frags_truesz += cur_frag_size;
 		if (unlikely(len > truesize - room || cur_frag_size > PAGE_SIZE)) {
-			put_page(page);
+			virtnet_put_page(rq, page);
 			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
 				 dev->name, len, (unsigned long)(truesize - room));
 			dev->stats.rx_length_errors++;
@@ -1283,7 +1304,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
 	return 0;
 
 err:
-	put_xdp_frags(xdp);
+	put_xdp_frags(xdp, rq);
 	return -EINVAL;
 }
 
@@ -1344,7 +1365,10 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
 		if (*len + xdp_room > PAGE_SIZE)
 			return NULL;
 
-		xdp_page = alloc_page(GFP_ATOMIC);
+		if (rq->page_pool)
+			xdp_page = page_pool_dev_alloc_pages(rq->page_pool);
+		else
+			xdp_page = alloc_page(GFP_ATOMIC);
 		if (!xdp_page)
 			return NULL;
 
@@ -1354,7 +1378,7 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
 
 	*frame_sz = PAGE_SIZE;
 
-	put_page(*page);
+	virtnet_put_page(rq, *page);
 
 	*page = xdp_page;
 
@@ -1400,6 +1424,8 @@ static struct sk_buff *receive_mergeable_xdp(struct net_device *dev,
 		head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
 		if (unlikely(!head_skb))
 			break;
+		if (rq->page_pool)
+			skb_mark_for_recycle(head_skb);
 		return head_skb;
 
 	case XDP_TX:
@@ -1410,10 +1436,10 @@ static struct sk_buff *receive_mergeable_xdp(struct net_device *dev,
 		break;
 	}
 
-	put_xdp_frags(&xdp);
+	put_xdp_frags(&xdp, rq);
 
 err_xdp:
-	put_page(page);
+	virtnet_put_page(rq, page);
 	mergeable_buf_free(rq, num_buf, dev, stats);
 
 	stats->xdp_drops++;
@@ -1467,6 +1493,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, headroom);
 	curr_skb = head_skb;
 
+	if (rq->page_pool)
+		skb_mark_for_recycle(curr_skb);
+
 	if (unlikely(!curr_skb))
 		goto err_skb;
 	while (--num_buf) {
@@ -1509,6 +1538,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 			curr_skb = nskb;
 			head_skb->truesize += nskb->truesize;
 			num_skb_frags = 0;
+			if (rq->page_pool)
+				skb_mark_for_recycle(curr_skb);
 		}
 		if (curr_skb != head_skb) {
 			head_skb->data_len += len;
@@ -1517,7 +1548,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		}
 		offset = buf - page_address(page);
 		if (skb_can_coalesce(curr_skb, num_skb_frags, page, offset)) {
-			put_page(page);
+			virtnet_put_page(rq, page);
 			skb_coalesce_rx_frag(curr_skb, num_skb_frags - 1,
 					     len, truesize);
 		} else {
@@ -1530,7 +1561,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	return head_skb;
 
 err_skb:
-	put_page(page);
+	virtnet_put_page(rq, page);
 	mergeable_buf_free(rq, num_buf, dev, stats);
 
 err_buf:
@@ -1737,31 +1768,40 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
 	 * disabled GSO for XDP, it won't be a big issue.
 	 */
 	len = get_mergeable_buf_len(rq, &rq->mrg_avg_pkt_len, room);
-	if (unlikely(!skb_page_frag_refill(len + room, alloc_frag, gfp)))
-		return -ENOMEM;
+	if (rq->page_pool) {
+		struct page *page;
 
-	buf = (char *)page_address(alloc_frag->page) + alloc_frag->offset;
-	buf += headroom; /* advance address leaving hole at front of pkt */
-	get_page(alloc_frag->page);
-	alloc_frag->offset += len + room;
-	hole = alloc_frag->size - alloc_frag->offset;
-	if (hole < len + room) {
-		/* To avoid internal fragmentation, if there is very likely not
-		 * enough space for another buffer, add the remaining space to
-		 * the current buffer.
-		 * XDP core assumes that frame_size of xdp_buff and the length
-		 * of the frag are PAGE_SIZE, so we disable the hole mechanism.
-		 */
-		if (!headroom)
-			len += hole;
-		alloc_frag->offset += hole;
-	}
+		page = page_pool_dev_alloc_pages(rq->page_pool);
+		if (unlikely(!page))
+			return -ENOMEM;
+		buf = (char *)page_address(page);
+		buf += headroom; /* advance address leaving hole at front of pkt */
+	} else {
+		if (unlikely(!skb_page_frag_refill(len + room, alloc_frag, gfp)))
+			return -ENOMEM;
 
+		buf = (char *)page_address(alloc_frag->page) + alloc_frag->offset;
+		buf += headroom; /* advance address leaving hole at front of pkt */
+		get_page(alloc_frag->page);
+		alloc_frag->offset += len + room;
+		hole = alloc_frag->size - alloc_frag->offset;
+		if (hole < len + room) {
+			/* To avoid internal fragmentation, if there is very likely not
+			 * enough space for another buffer, add the remaining space to
+			 * the current buffer.
+			 * XDP core assumes that frame_size of xdp_buff and the length
+			 * of the frag are PAGE_SIZE, so we disable the hole mechanism.
+			 */
+			if (!headroom)
+				len += hole;
+			alloc_frag->offset += hole;
+		}
+	}
 	sg_init_one(rq->sg, buf, len);
 	ctx = mergeable_len_to_ctx(len + room, headroom);
 	err = virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp);
 	if (err < 0)
-		put_page(virt_to_head_page(buf));
+		virtnet_put_page(rq, virt_to_head_page(buf));
 
 	return err;
 }
@@ -1994,8 +2034,15 @@ static int virtnet_enable_queue_pair(struct virtnet_info *vi, int qp_index)
 	if (err < 0)
 		return err;
 
-	err = xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].xdp_rxq,
-					 MEM_TYPE_PAGE_SHARED, NULL);
+	if (vi->rq[qp_index].page_pool)
+		err = xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].xdp_rxq,
+						 MEM_TYPE_PAGE_POOL,
+						 vi->rq[qp_index].page_pool);
+	else
+		err = xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].xdp_rxq,
+						 MEM_TYPE_PAGE_SHARED,
+						 NULL);
+
 	if (err < 0)
 		goto err_xdp_reg_mem_model;
 
@@ -2951,6 +2998,7 @@ static void virtnet_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 				ethtool_sprintf(&p, "tx_queue_%u_%s", i,
 						virtnet_sq_stats_desc[j].desc);
 		}
+		page_pool_ethtool_stats_get_strings(p);
 		break;
 	}
 }
@@ -2962,12 +3010,30 @@ static int virtnet_get_sset_count(struct net_device *dev, int sset)
 	switch (sset) {
 	case ETH_SS_STATS:
 		return vi->curr_queue_pairs * (VIRTNET_RQ_STATS_LEN +
-					       VIRTNET_SQ_STATS_LEN);
+					       VIRTNET_SQ_STATS_LEN +
+						(page_pool_enabled && vi->mergeable_rx_bufs ?
+						 page_pool_ethtool_stats_get_count() : 0));
 	default:
 		return -EOPNOTSUPP;
 	}
 }
 
+static void virtnet_get_page_pool_stats(struct net_device *dev, u64 *data)
+{
+#ifdef CONFIG_PAGE_POOL_STATS
+	struct virtnet_info *vi = netdev_priv(dev);
+	struct page_pool_stats pp_stats = {};
+	int i;
+
+	for (i = 0; i < vi->curr_queue_pairs; i++) {
+		if (!vi->rq[i].page_pool)
+			continue;
+		page_pool_get_stats(vi->rq[i].page_pool, &pp_stats);
+	}
+	page_pool_ethtool_stats_get(data, &pp_stats);
+#endif /* CONFIG_PAGE_POOL_STATS */
+}
+
 static void virtnet_get_ethtool_stats(struct net_device *dev,
 				      struct ethtool_stats *stats, u64 *data)
 {
@@ -3003,6 +3069,8 @@ static void virtnet_get_ethtool_stats(struct net_device *dev,
 		} while (u64_stats_fetch_retry(&sq->stats.syncp, start));
 		idx += VIRTNET_SQ_STATS_LEN;
 	}
+
+	virtnet_get_page_pool_stats(dev, &data[idx]);
 }
 
 static void virtnet_get_channels(struct net_device *dev,
@@ -3623,6 +3691,8 @@ static void virtnet_free_queues(struct virtnet_info *vi)
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		__netif_napi_del(&vi->rq[i].napi);
 		__netif_napi_del(&vi->sq[i].napi);
+		if (vi->rq[i].page_pool)
+			page_pool_destroy(vi->rq[i].page_pool);
 	}
 
 	/* We called __netif_napi_del(),
@@ -3679,12 +3749,19 @@ static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *buf)
 	struct virtnet_info *vi = vq->vdev->priv;
 	int i = vq2rxq(vq);
 
-	if (vi->mergeable_rx_bufs)
-		put_page(virt_to_head_page(buf));
-	else if (vi->big_packets)
+	if (vi->mergeable_rx_bufs) {
+		if (vi->rq[i].page_pool) {
+			page_pool_put_full_page(vi->rq[i].page_pool,
+						virt_to_head_page(buf),
+						true);
+		} else {
+			put_page(virt_to_head_page(buf));
+		}
+	} else if (vi->big_packets) {
 		give_pages(&vi->rq[i], buf);
-	else
+	} else {
 		put_page(virt_to_head_page(buf));
+	}
 }
 
 static void free_unused_bufs(struct virtnet_info *vi)
@@ -3718,6 +3795,26 @@ static void virtnet_del_vqs(struct virtnet_info *vi)
 	virtnet_free_queues(vi);
 }
 
+static void virtnet_alloc_page_pool(struct receive_queue *rq)
+{
+	struct virtio_device *vdev = rq->vq->vdev;
+
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.pool_size = rq->vq->num_max,
+		.nid = dev_to_node(vdev->dev.parent),
+		.dev = vdev->dev.parent,
+		.offset = 0,
+	};
+
+	rq->page_pool = page_pool_create(&pp_params);
+	if (IS_ERR(rq->page_pool)) {
+		dev_warn(&vdev->dev, "page pool creation failed: %ld\n",
+			 PTR_ERR(rq->page_pool));
+		rq->page_pool = NULL;
+	}
+}
+
 /* How large should a single buffer be so a queue full of these can fit at
  * least one full packet?
  * Logic below assumes the mergeable buffer header is used.
@@ -3801,6 +3898,13 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 		vi->rq[i].vq = vqs[rxq2vq(i)];
 		vi->rq[i].min_buf_len = mergeable_min_buf_len(vi, vi->rq[i].vq);
 		vi->sq[i].vq = vqs[txq2vq(i)];
+
+		if (page_pool_enabled && vi->mergeable_rx_bufs)
+			virtnet_alloc_page_pool(&vi->rq[i]);
+		else
+			dev_warn(&vi->vdev->dev,
+				 "page pool only support mergeable mode\n");
+
 	}
 
 	/* run here: ret == 0. */
-- 
2.31.1


