Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8560237A7B8
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 15:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhEKNe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 09:34:56 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:46011 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbhEKNey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 09:34:54 -0400
Received: by mail-ed1-f47.google.com with SMTP id j19so515425edr.12;
        Tue, 11 May 2021 06:33:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aJ11lVMhqfzweOJ3ay4/tPGlK2PxGXGfkKMCyU2xp1w=;
        b=fpmVzw8Hm/pL2N1wRwYyU79y9Xlbg2+S9oBLCjFhTB1Q7+G+6wX9ix1wja1++3TbcJ
         7SyToM4yiBtXJ92OgBzJKNDEet6bwfYAgJED8O5sacv4gALMDH2WNrxKVe1P32BLm43T
         UuJhRgXmpVNNEa1Cs0VuDjiJeiJYiyZYgTg5YPdZayvEDX1ny7cQ0O/f81Tl1xLLue2M
         AMSMuYCducjiW/w1YtmYqKBc3V9cvoqOahx2WBi4aOOX2lgnsTBNssPIgbX+kGRBVJrr
         Oryy7Q3fi/EbDBwWSMPL638m2qRE73h3s7ksGg57zIBLJT1kX2f6Ili8KeeO6lM+D7to
         QgJQ==
X-Gm-Message-State: AOAM530Z4v2hpd1STA3nwrbaWF3sWnb4bYUsToM4xZF5NOoDvXcZBbNh
        37H8hwvr1Vs2EvfzyIpg3fnSgJyE/AUMUwvt
X-Google-Smtp-Source: ABdhPJwvyV9JtTkKkZZkkr3kEuC/p+Lk6tSnIbPL81/blN3nJOnsUgEv7h2OJR1w0dJDW4hDymj4Ew==
X-Received: by 2002:a50:c446:: with SMTP id w6mr32826872edf.62.1620740026389;
        Tue, 11 May 2021 06:33:46 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id b12sm14577136eds.23.2021.05.11.06.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 06:33:45 -0700 (PDT)
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
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
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
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: [PATCH net-next v4 3/4] mvpp2: recycle buffers
Date:   Tue, 11 May 2021 15:31:17 +0200
Message-Id: <20210511133118.15012-4-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210511133118.15012-1-mcroce@linux.microsoft.com>
References: <20210511133118.15012-1-mcroce@linux.microsoft.com>
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
index b2259bf1d299..9dceabece56c 100644
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
+			skb_mark_for_recycle(skb, virt_to_page(data), pp);
 		else
 			dma_unmap_single_attrs(dev->dev.parent, dma_addr,
 					       bm_pool->buf_size, DMA_FROM_DEVICE,
-- 
2.31.1

