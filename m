Return-Path: <netdev+bounces-5512-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7ECA711F59
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 07:47:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95F491C20F87
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 05:47:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B2B43D86;
	Fri, 26 May 2023 05:47:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A260259B
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:47:03 +0000 (UTC)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4CC1BD;
	Thu, 25 May 2023 22:46:56 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-64d2e8a842cso437375b3a.3;
        Thu, 25 May 2023 22:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685080015; x=1687672015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YUm4XTY1R5intHK/z7Qt51RzFiHrwW4UzPPzDIR9dWc=;
        b=W2WZBjnFu/DmSheuSCHpddXJmBn91/NX+XyIZRzKzflA0Qdt8HgmMcojkeZ0QKic9P
         qBULToT0Mv91XfOS4elBpp6u9+8zQFc/GzoyALA3F45wbZshsmEypIWpfGA+VlZtAUoh
         C7231+suBIicBxxHxG7SHXg3qrRjvR50QS+BmlyhJGn/+1rTCdbotPAWQTmax8JrWAOv
         VRgtfl2BRrBRx5NpZ03HdptgGDhzuv5IarzrjZXltD9p6bkSNgoo30i+1VPXEWFtDia8
         5Hemqc1pl/N6WgT+ZOt5EOANxyAPBVQUOgsICOexQSxt7OyJr95iWC+FIP82JmnGZPBr
         a4HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685080015; x=1687672015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YUm4XTY1R5intHK/z7Qt51RzFiHrwW4UzPPzDIR9dWc=;
        b=d+w+0uNI/28Wnif+LPo3j2+fG6MNI7q81MxSRGBMT+GC4zvi7ZRc89egLPGFlK3Jss
         P5pn/rO4LFbn5oESG9NCi4cv0fN+ZIg56crFC7ZuGjbxph2aMQ8ZBkd+qZYa2d6bq1/L
         IypsTVOWQ91cZ8adX+KBNTr9ZXwwNXk9Uf1kHRPaaGZ0VSRUcYfB10wdAfzmyJcvf+9a
         SEHlzdfbrVJqBPDXa8siN3w3E1AexIkAbdeTs5/kW0YW3TvYcXR3y8E1I3UBla48Gxts
         pNwM9YmFoy2I1PjOGja1ZK7nJjH1bHOoQthMMUtaTZ88mWY2doiPWSSWZj8iJtaeuP0W
         gEpA==
X-Gm-Message-State: AC+VfDz8LMoaWpGbGDTt6o3iLryB85nupCbyHaVTCRqCE8075xpG/WNh
	ZQ+NyWuB/C9/xNs4nrIlLAY=
X-Google-Smtp-Source: ACHHUZ75/K6Gd8T0ocegQfYYN1IkvC0PYIWUuwtlmuRZobOHOmLIv3BIhMmobaZEo30IboM6yiBJ3w==
X-Received: by 2002:a05:6a21:3703:b0:10f:3fa0:fd8e with SMTP id yl3-20020a056a21370300b0010f3fa0fd8emr763627pzb.27.1685080015524;
        Thu, 25 May 2023 22:46:55 -0700 (PDT)
Received: from localhost.localdomain ([104.149.188.130])
        by smtp.gmail.com with ESMTPSA id b23-20020a6567d7000000b0050a0227a4bcsm1836485pgs.57.2023.05.25.22.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 22:46:54 -0700 (PDT)
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
Subject: [PATCH net-next 3/5] virtio_net: Add page pool fragmentation support
Date: Fri, 26 May 2023 13:46:19 +0800
Message-Id: <20230526054621.18371-3-liangchen.linux@gmail.com>
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

To further enhance performance, implement page pool fragmentation
support and introduce a module parameter to enable or disable it.

In single-core vm testing environments, there is an additional performance
gain observed in the normal path compared to the one packet per page
approach.
  Upstream codebase: 47.5 Gbits/sec
  Upstream codebase with page pool: 50.2 Gbits/sec
  Upstream codebase with page pool fragmentation support: 52.3 Gbits/sec

There is also some performance gain for XDP cpumap.
  Upstream codebase: 1.38 Gbits/sec
  Upstream codebase with page pool: 9.74 Gbits/sec
  Upstream codebase with page pool fragmentation: 10.3 Gbits/sec

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 drivers/net/virtio_net.c | 72 ++++++++++++++++++++++++++++++----------
 1 file changed, 55 insertions(+), 17 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 99c0ca0c1781..ac40b8c66c59 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -32,7 +32,9 @@ module_param(gso, bool, 0444);
 module_param(napi_tx, bool, 0644);
 
 static bool page_pool_enabled;
+static bool page_pool_frag;
 module_param(page_pool_enabled, bool, 0400);
+module_param(page_pool_frag, bool, 0400);
 
 /* FIXME: MTU in config. */
 #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
@@ -909,23 +911,32 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 				       struct page *p,
 				       int offset,
 				       int page_off,
-				       unsigned int *len)
+				       unsigned int *len,
+					   unsigned int *pp_frag_offset)
 {
 	int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	struct page *page;
+	unsigned int pp_frag_offset_val;
 
 	if (page_off + *len + tailroom > PAGE_SIZE)
 		return NULL;
 
 	if (rq->page_pool)
-		page = page_pool_dev_alloc_pages(rq->page_pool);
+		if (rq->page_pool->p.flags & PP_FLAG_PAGE_FRAG)
+			page = page_pool_dev_alloc_frag(rq->page_pool, pp_frag_offset,
+							PAGE_SIZE);
+		else
+			page = page_pool_dev_alloc_pages(rq->page_pool);
 	else
 		page = alloc_page(GFP_ATOMIC);
 
 	if (!page)
 		return NULL;
 
-	memcpy(page_address(page) + page_off, page_address(p) + offset, *len);
+	pp_frag_offset_val = pp_frag_offset ? *pp_frag_offset : 0;
+
+	memcpy(page_address(page) + page_off + pp_frag_offset_val,
+	       page_address(p) + offset, *len);
 	page_off += *len;
 
 	while (--*num_buf) {
@@ -948,7 +959,7 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 			goto err_buf;
 		}
 
-		memcpy(page_address(page) + page_off,
+		memcpy(page_address(page) + page_off + pp_frag_offset_val,
 		       page_address(p) + off, buflen);
 		page_off += buflen;
 		virtnet_put_page(rq, p);
@@ -1029,7 +1040,7 @@ static struct sk_buff *receive_small_xdp(struct net_device *dev,
 			SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 		xdp_page = xdp_linearize_page(rq, &num_buf, page,
 					      offset, header_offset,
-					      &tlen);
+					      &tlen, NULL);
 		if (!xdp_page)
 			goto err_xdp;
 
@@ -1323,6 +1334,7 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
 	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
 	struct page *xdp_page;
 	unsigned int xdp_room;
+	unsigned int page_frag_offset = 0;
 
 	/* Transient failure which in theory could occur if
 	 * in-flight packets from before XDP was enabled reach
@@ -1356,7 +1368,8 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
 		xdp_page = xdp_linearize_page(rq, num_buf,
 					      *page, offset,
 					      VIRTIO_XDP_HEADROOM,
-					      len);
+					      len,
+						  &page_frag_offset);
 		if (!xdp_page)
 			return NULL;
 	} else {
@@ -1366,14 +1379,19 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
 			return NULL;
 
 		if (rq->page_pool)
-			xdp_page = page_pool_dev_alloc_pages(rq->page_pool);
+			if (rq->page_pool->p.flags & PP_FLAG_PAGE_FRAG)
+				xdp_page = page_pool_dev_alloc_frag(rq->page_pool,
+								    &page_frag_offset, PAGE_SIZE);
+			else
+				xdp_page = page_pool_dev_alloc_pages(rq->page_pool);
 		else
 			xdp_page = alloc_page(GFP_ATOMIC);
+
 		if (!xdp_page)
 			return NULL;
 
-		memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM,
-		       page_address(*page) + offset, *len);
+		memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM +
+				page_frag_offset, page_address(*page) + offset, *len);
 	}
 
 	*frame_sz = PAGE_SIZE;
@@ -1382,7 +1400,7 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
 
 	*page = xdp_page;
 
-	return page_address(*page) + VIRTIO_XDP_HEADROOM;
+	return page_address(*page) + VIRTIO_XDP_HEADROOM + page_frag_offset;
 }
 
 static struct sk_buff *receive_mergeable_xdp(struct net_device *dev,
@@ -1762,6 +1780,7 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
 	void *ctx;
 	int err;
 	unsigned int len, hole;
+	unsigned int pp_frag_offset;
 
 	/* Extra tailroom is needed to satisfy XDP's assumption. This
 	 * means rx frags coalescing won't work, but consider we've
@@ -1769,13 +1788,29 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
 	 */
 	len = get_mergeable_buf_len(rq, &rq->mrg_avg_pkt_len, room);
 	if (rq->page_pool) {
-		struct page *page;
+		if (rq->page_pool->p.flags & PP_FLAG_PAGE_FRAG) {
+			if (unlikely(!page_pool_dev_alloc_frag(rq->page_pool,
+							       &pp_frag_offset, len + room)))
+				return -ENOMEM;
+			buf = (char *)page_address(rq->page_pool->frag_page) +
+				pp_frag_offset;
+			buf += headroom; /* advance address leaving hole at front of pkt */
+			hole = (PAGE_SIZE << rq->page_pool->p.order)
+				- rq->page_pool->frag_offset;
+			if (hole < len + room) {
+				if (!headroom)
+					len += hole;
+				rq->page_pool->frag_offset += hole;
+			}
+		} else {
+			struct page *page;
 
-		page = page_pool_dev_alloc_pages(rq->page_pool);
-		if (unlikely(!page))
-			return -ENOMEM;
-		buf = (char *)page_address(page);
-		buf += headroom; /* advance address leaving hole at front of pkt */
+			page = page_pool_dev_alloc_pages(rq->page_pool);
+			if (unlikely(!page))
+				return -ENOMEM;
+			buf = (char *)page_address(page);
+			buf += headroom; /* advance address leaving hole at front of pkt */
+		}
 	} else {
 		if (unlikely(!skb_page_frag_refill(len + room, alloc_frag, gfp)))
 			return -ENOMEM;
@@ -3800,13 +3835,16 @@ static void virtnet_alloc_page_pool(struct receive_queue *rq)
 	struct virtio_device *vdev = rq->vq->vdev;
 
 	struct page_pool_params pp_params = {
-		.order = 0,
+		.order = page_pool_frag ? SKB_FRAG_PAGE_ORDER : 0,
 		.pool_size = rq->vq->num_max,
 		.nid = dev_to_node(vdev->dev.parent),
 		.dev = vdev->dev.parent,
 		.offset = 0,
 	};
 
+	if (page_pool_frag)
+		pp_params.flags |= PP_FLAG_PAGE_FRAG;
+
 	rq->page_pool = page_pool_create(&pp_params);
 	if (IS_ERR(rq->page_pool)) {
 		dev_warn(&vdev->dev, "page pool creation failed: %ld\n",
-- 
2.31.1


