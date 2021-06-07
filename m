Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1078439E729
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 21:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhFGTF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 15:05:57 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:44557 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbhFGTFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 15:05:52 -0400
Received: by mail-wr1-f42.google.com with SMTP id f2so18770578wri.11;
        Mon, 07 Jun 2021 12:03:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KVXA2B0j0E76Hw4rKgteG9BP+cY/0VQ2EiVfHUNMg/4=;
        b=L/I6KHhV8nWwyacvEtPNzdmBXfUH5ZEsJ4J3th5BcP1l8pDnNmk13+0zJztQKhpGUM
         gUF6ef9BXpbjnTROVIjQpJyxc56/YboXAH7+OKJLwR8UAR0pnyUqAjL1iSFVsYm4z/DZ
         opnL8u8J796ZTLQfy37dMVKmMG77Q78HbH/hfh6+BAmHZWJgw+w+cVV+cnnQguH4X3X+
         NCi1LBy738cvWEHIKGkv0Ut/DCzdasLNbUTv00VqX+tDj5lS2pJIMqvXw6sPNMKPznGF
         fWKBZhAut8pI3MOmJ8R7bZSWVU/5p9GuX8Gi/Y6BRICnR7o7vzx/4I+uGkfG9x9p8W3n
         pw6Q==
X-Gm-Message-State: AOAM532uc+6IyeF6e723v6jsE6a3ox0Z+Lny+B3+FJ1SVdAQCmwpke/q
        xAMm3+GVKrqYcdrkjNyukHn7uNQ7Z1U22w==
X-Google-Smtp-Source: ABdhPJzNZJiNdyZFFUxhc150qts/zF4QA/HLJcifyxEuiMByRZ69cr9rwdxpgcIZFH/A7yaeZ1ZcTA==
X-Received: by 2002:a5d:698e:: with SMTP id g14mr18619051wru.212.1623092624709;
        Mon, 07 Jun 2021 12:03:44 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-37-119-128-179.cust.vodafonedsl.it. [37.119.128.179])
        by smtp.gmail.com with ESMTPSA id g17sm12185968wrp.61.2021.06.07.12.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 12:03:44 -0700 (PDT)
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
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Yonghong Song <yhs@fb.com>,
        Michel Lespinasse <walken@google.com>,
        KP Singh <kpsingh@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        David Hildenbrand <david@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH net-next v8 5/5] mvneta: recycle buffers
Date:   Mon,  7 Jun 2021 21:02:40 +0200
Message-Id: <20210607190240.36900-6-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210607190240.36900-1-mcroce@linux.microsoft.com>
References: <20210607190240.36900-1-mcroce@linux.microsoft.com>
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

