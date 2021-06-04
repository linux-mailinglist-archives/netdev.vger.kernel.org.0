Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6DB39BFBC
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 20:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhFDSgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 14:36:33 -0400
Received: from mail-ej1-f48.google.com ([209.85.218.48]:37563 "EHLO
        mail-ej1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhFDSgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 14:36:32 -0400
Received: by mail-ej1-f48.google.com with SMTP id ce15so15930001ejb.4;
        Fri, 04 Jun 2021 11:34:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KVXA2B0j0E76Hw4rKgteG9BP+cY/0VQ2EiVfHUNMg/4=;
        b=nlkGuBMd+Vty6+XLHkc2LbiSbwqfINiZ/ReNk8htptoFZbKJd4j2KgwYSoht5E5Wqe
         c6Za3C57g7wbv7IzS8m5R2Nry1bmPbbzNpLd4jYp2QY9jMXLxhS2A9DE2wDfHGeOB+aK
         3SgbN6soIrUNvwHNmClCEoU8fW4uDLkaHySq5QeBe4T9t4Mfrncw8G4PxHN3sWJqQi+3
         74+ByQ6lqGbWdZ9lTOi0ikr8wEmE5/SmExv8tGHXwzh/6EqJzCqanW/ZOwJ8y8uRHe8B
         jlzxaRhMnV7g7eQOrj0K+aAbn/0jHHTSEUc2Il9M4yHndUQmc+Evu1c0wVXx3tYp+auR
         uf3Q==
X-Gm-Message-State: AOAM532Xqv9vvQNeR7kEp2xOlQIMPig8BED5NzFcu5nyXyT7BW4uZFiL
        SzjvsZY4Jxsvm4vJbhxPX8F4z8bKZIecfA==
X-Google-Smtp-Source: ABdhPJwzWy/UpSiAT2oGFWyX5XJHteunpsaqe2BdTWj7r5QsxGM1CjDsIVuG2Daau4lDB2+8+7DnXg==
X-Received: by 2002:a17:907:7808:: with SMTP id la8mr3285635ejc.13.1622831671378;
        Fri, 04 Jun 2021 11:34:31 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-37-119-128-179.cust.vodafonedsl.it. [37.119.128.179])
        by smtp.gmail.com with ESMTPSA id k12sm3732039edi.87.2021.06.04.11.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 11:34:30 -0700 (PDT)
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
Subject: [PATCH net-next v7 5/5] mvneta: recycle buffers
Date:   Fri,  4 Jun 2021 20:33:49 +0200
Message-Id: <20210604183349.30040-6-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604183349.30040-1-mcroce@linux.microsoft.com>
References: <20210604183349.30040-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Use the new recycling API for page_pool.
In a drop rate test, the packet rate increased by 10%,
from 296 Kpps to 326 Kpps.

perf top on a stock system shows:

Overhead  Shared Object     Symbol
  23.66%  [kernel]          [k] __pi___inval_dcache_area
  22.85%  [mvneta]          [k] mvneta_rx_swbm
   7.54%  [kernel]          [k] kmem_cache_alloc
   6.49%  [kernel]          [k] eth_type_trans
   3.94%  [kernel]          [k] dev_gro_receive
   3.91%  [kernel]          [k] __netif_receive_skb_core
   3.91%  [kernel]          [k] kmem_cache_free
   3.76%  [kernel]          [k] page_pool_release_page
   3.56%  [kernel]          [k] free_unref_page
   2.40%  [kernel]          [k] build_skb
   1.49%  [kernel]          [k] skb_release_data
   1.45%  [kernel]          [k] __alloc_pages_bulk
   1.30%  [kernel]          [k] page_frag_free

And this is the same output with recycling enabled:

Overhead  Shared Object     Symbol
  26.41%  [kernel]          [k] __pi___inval_dcache_area
  25.00%  [mvneta]          [k] mvneta_rx_swbm
   8.14%  [kernel]          [k] kmem_cache_alloc
   6.84%  [kernel]          [k] eth_type_trans
   4.44%  [kernel]          [k] __netif_receive_skb_core
   4.38%  [kernel]          [k] kmem_cache_free
   4.16%  [kernel]          [k] dev_gro_receive
   3.21%  [kernel]          [k] page_pool_put_page
   2.41%  [kernel]          [k] build_skb
   1.82%  [kernel]          [k] skb_release_data
   1.61%  [kernel]          [k] napi_gro_receive
   1.25%  [kernel]          [k] page_pool_refill_alloc_cache
   1.16%  [kernel]          [k] __netif_receive_skb_list_core

We can see that page_pool_release_page(), free_unref_page() and
__alloc_pages_bulk() are no longer on top of the list when receiving
traffic.

The test was done with mausezahn on the TX side with 64 byte raw
ethernet frames.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 7d5cd9bc6c99..c15ce06427d0 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2320,7 +2320,7 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 }
 
 static struct sk_buff *
-mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
+mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 		      struct xdp_buff *xdp, u32 desc_status)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
@@ -2331,7 +2331,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
-	page_pool_release_page(rxq->page_pool, virt_to_page(xdp->data));
+	skb_mark_for_recycle(skb, virt_to_page(xdp->data), pool);
 
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	skb_put(skb, xdp->data_end - xdp->data);
@@ -2343,7 +2343,10 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 				skb_frag_page(frag), skb_frag_off(frag),
 				skb_frag_size(frag), PAGE_SIZE);
-		page_pool_release_page(rxq->page_pool, skb_frag_page(frag));
+		/* We don't need to reset pp_recycle here. It's already set, so
+		 * just mark fragments for recycling.
+		 */
+		page_pool_store_mem_info(skb_frag_page(frag), pool);
 	}
 
 	return skb;
@@ -2425,7 +2428,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		    mvneta_run_xdp(pp, rxq, xdp_prog, &xdp_buf, frame_sz, &ps))
 			goto next;
 
-		skb = mvneta_swbm_build_skb(pp, rxq, &xdp_buf, desc_status);
+		skb = mvneta_swbm_build_skb(pp, rxq->page_pool, &xdp_buf, desc_status);
 		if (IS_ERR(skb)) {
 			struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 
-- 
2.31.1

