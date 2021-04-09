Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9D435A8D2
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 00:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbhDIWjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 18:39:18 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:41489 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235136AbhDIWjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 18:39:17 -0400
Received: by mail-ed1-f41.google.com with SMTP id z1so8279428edb.8;
        Fri, 09 Apr 2021 15:39:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Er0JvX9LJJW9NGmHRaC1luhAateCi8wCBUT1RypacVs=;
        b=Zq6UaHcrjA9JuLjufPve5IAivuptlLA6dAdz27FiKZiT53/6EG9sZIiqz+PZh+kt9I
         ag+c7oXGNKEr7ep0rzn74HAG2kE5z0ftNR/Vu75aWfmq0wK2qqrAxXzBnrewfDprQ5Mk
         fszSUcbxT6FCGY8W4Vj4w2qez5ONT+KlcczsXkwhTRXFfcUe0sRlssVSrmXa4XOIo3Xc
         Mz+wj8m/lZPV+0F0BzW7Or9djpfEzDTiFTMu9H+bKPGiTplnrfWkTxuH3BlvCGBp54IY
         6N+UeoBgC7oMVb15oQe5nPWBrLp26lFVNNVGOhjU34Uwiryl/bnSbRqeEuYE/pHyJxR8
         GWBg==
X-Gm-Message-State: AOAM533+79MK5WdPgFBmX0UkeAVW2BLJtqpLtH9PMi9AkUGtfRRznIeS
        RVJuo0T8h9QCTM2rYnRJ1LFPHs7T5Jl6sw==
X-Google-Smtp-Source: ABdhPJx0lYQv0DdUHe0Jz5hRW0kEEFLIUK/JhjuqYezEVGOYBCZ8/iqaXjrdy1Ul5TN1Nx8oZbZygg==
X-Received: by 2002:aa7:d397:: with SMTP id x23mr19978020edq.256.1618007942469;
        Fri, 09 Apr 2021 15:39:02 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-93-66-21-119.cust.vodafonedsl.it. [93.66.21.119])
        by smtp.gmail.com with ESMTPSA id s20sm2108726edu.93.2021.04.09.15.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 15:39:02 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org, linux-mm@kvack.org
Cc:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v3 4/5] mvpp2: recycle buffers
Date:   Sat, 10 Apr 2021 00:38:00 +0200
Message-Id: <20210409223801.104657-5-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210409223801.104657-1-mcroce@linux.microsoft.com>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Use the new recycling API for page_pool.
In a drop rate test, the packet rate is more than doubled,
from 962 Kpps to 2047 Kpps.

perf top on a stock system shows:

Overhead  Shared Object     Symbol
  30.67%  [kernel]          [k] page_pool_release_page
   8.37%  [kernel]          [k] get_page_from_freelist
   7.34%  [kernel]          [k] free_unref_page
   6.47%  [mvpp2]           [k] mvpp2_rx
   4.69%  [kernel]          [k] eth_type_trans
   4.55%  [kernel]          [k] __netif_receive_skb_core
   4.40%  [kernel]          [k] build_skb
   4.29%  [kernel]          [k] kmem_cache_free
   4.00%  [kernel]          [k] kmem_cache_alloc
   3.81%  [kernel]          [k] dev_gro_receive

With packet rate stable at 962 Kpps:

tx: 0 bps 0 pps rx: 477.4 Mbps 962.6 Kpps
tx: 0 bps 0 pps rx: 477.6 Mbps 962.8 Kpps
tx: 0 bps 0 pps rx: 477.6 Mbps 962.9 Kpps
tx: 0 bps 0 pps rx: 477.2 Mbps 962.1 Kpps
tx: 0 bps 0 pps rx: 477.5 Mbps 962.7 Kpps

And this is the same output with recycling enabled:

Overhead  Shared Object     Symbol
  12.75%  [mvpp2]           [k] mvpp2_rx
   9.56%  [kernel]          [k] __netif_receive_skb_core
   9.29%  [kernel]          [k] build_skb
   9.27%  [kernel]          [k] eth_type_trans
   8.39%  [kernel]          [k] kmem_cache_alloc
   7.85%  [kernel]          [k] kmem_cache_free
   7.36%  [kernel]          [k] page_pool_put_page
   6.45%  [kernel]          [k] dev_gro_receive
   4.72%  [kernel]          [k] __xdp_return
   3.06%  [kernel]          [k] page_pool_refill_alloc_cache

With packet rate above 2000 Kpps:

tx: 0 bps 0 pps rx: 1015 Mbps 2046 Kpps
tx: 0 bps 0 pps rx: 1015 Mbps 2047 Kpps
tx: 0 bps 0 pps rx: 1015 Mbps 2047 Kpps
tx: 0 bps 0 pps rx: 1015 Mbps 2047 Kpps
tx: 0 bps 0 pps rx: 1015 Mbps 2047 Kpps

The major performance increase is explained by the fact that the most CPU
consuming functions (page_pool_release_page, get_page_from_freelist
and free_unref_page) are no longer called on a per packet basis.

The test was done by sending to the macchiatobin 64 byte ethernet frames
with an invalid ethertype, so the packets are dropped early in the RX path.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index ec706d614cac..633b39cfef65 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3847,6 +3847,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 	struct mvpp2_pcpu_stats ps = {};
 	enum dma_data_direction dma_dir;
 	struct bpf_prog *xdp_prog;
+	struct xdp_rxq_info *rxqi;
 	struct xdp_buff xdp;
 	int rx_received;
 	int rx_done = 0;
@@ -3912,15 +3913,15 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		else
 			frag_size = bm_pool->frag_size;
 
-		if (xdp_prog) {
-			struct xdp_rxq_info *xdp_rxq;
+		if (bm_pool->pkt_size == MVPP2_BM_SHORT_PKT_SIZE)
+			rxqi = &rxq->xdp_rxq_short;
+		else
+			rxqi = &rxq->xdp_rxq_long;
 
-			if (bm_pool->pkt_size == MVPP2_BM_SHORT_PKT_SIZE)
-				xdp_rxq = &rxq->xdp_rxq_short;
-			else
-				xdp_rxq = &rxq->xdp_rxq_long;
+		if (xdp_prog) {
+			xdp.rxq = rxqi;
 
-			xdp_init_buff(&xdp, PAGE_SIZE, xdp_rxq);
+			xdp_init_buff(&xdp, PAGE_SIZE, rxqi);
 			xdp_prepare_buff(&xdp, data,
 					 MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM,
 					 rx_bytes, false);
@@ -3964,7 +3965,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		}
 
 		if (pp)
-			page_pool_release_page(pp, virt_to_page(data));
+			skb_mark_for_recycle(skb, virt_to_page(data), &rxqi->mem);
 		else
 			dma_unmap_single_attrs(dev->dev.parent, dma_addr,
 					       bm_pool->buf_size, DMA_FROM_DEVICE,
-- 
2.30.2

