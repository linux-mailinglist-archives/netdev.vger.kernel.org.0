Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65ED335A8D6
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 00:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbhDIWjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 18:39:32 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:46799 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235120AbhDIWjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 18:39:31 -0400
Received: by mail-ed1-f47.google.com with SMTP id h10so8244989edt.13;
        Fri, 09 Apr 2021 15:39:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hfpx7yH1JMhtuw/p34rqv49BJ0OaG3mtjrffrkk1xkI=;
        b=U8bmuEQER8Mm1nx479pjhE3j02V0vqFZAE6NFIoBID/xb05O3ESl9NfYZIH9+Q4ire
         sG+76lM1fGvXRFhfbqEIwbn0t0gj9VGJIoGmXbn6SOXd806B2zkkbOOcGyhWC8VCuNTj
         MhSMPdjsQOQQDcpsbqUs9CiKJZnV8sBb38DK+BzaLKsNZX9d9hlmHymOmbvE9PO7gJqh
         ADu3HN+GPE80AzU4BrUIlEIq3PhTB0/AoeIxjIlDIn2HkqmE1X3N/OWNIwomxU1g2evO
         icAsMJiD5j6Vlz9qAXfpq838mqKby3CGHiP0dX9gWCXHz+0Hq3bmzaDgCw0QfUHGl1gE
         WgCA==
X-Gm-Message-State: AOAM530i6NcMxGxDvWZ9tMw/Ns7PwzWVvN5GhQ2ss8TYqC5r6SqX7pHA
        F39D+TPFyaaEJ5taoKnNTCNhILHS05M6dw==
X-Google-Smtp-Source: ABdhPJz5JORSKeWDpQgyWZS0/602VxwB/8eehkCneeNRCOvKRKPhoJLWpkp3+nG3FTnrzj9BVIHxxg==
X-Received: by 2002:a05:6402:3495:: with SMTP id v21mr19447203edc.117.1618007956846;
        Fri, 09 Apr 2021 15:39:16 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-93-66-21-119.cust.vodafonedsl.it. [93.66.21.119])
        by smtp.gmail.com with ESMTPSA id s20sm2108726edu.93.2021.04.09.15.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 15:39:16 -0700 (PDT)
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
Subject: [PATCH net-next v3 5/5] mvneta: recycle buffers
Date:   Sat, 10 Apr 2021 00:38:01 +0200
Message-Id: <20210409223801.104657-6-mcroce@linux.microsoft.com>
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
In a drop rate test, the packet rate increased di 10%,
from 269 Kpps to 296 Kpps.

perf top on a stock system shows:

Overhead  Shared Object     Symbol
  21.78%  [kernel]          [k] __pi___inval_dcache_area
  21.66%  [mvneta]          [k] mvneta_rx_swbm
   7.00%  [kernel]          [k] kmem_cache_alloc
   6.05%  [kernel]          [k] eth_type_trans
   4.44%  [kernel]          [k] kmem_cache_free.part.0
   3.80%  [kernel]          [k] __netif_receive_skb_core
   3.68%  [kernel]          [k] dev_gro_receive
   3.65%  [kernel]          [k] get_page_from_freelist
   3.43%  [kernel]          [k] page_pool_release_page
   3.35%  [kernel]          [k] free_unref_page

And this is the same output with recycling enabled:

Overhead  Shared Object     Symbol
  24.10%  [kernel]          [k] __pi___inval_dcache_area
  23.02%  [mvneta]          [k] mvneta_rx_swbm
   7.19%  [kernel]          [k] kmem_cache_alloc
   6.50%  [kernel]          [k] eth_type_trans
   4.93%  [kernel]          [k] __netif_receive_skb_core
   4.77%  [kernel]          [k] kmem_cache_free.part.0
   3.93%  [kernel]          [k] dev_gro_receive
   3.03%  [kernel]          [k] build_skb
   2.91%  [kernel]          [k] page_pool_put_page
   2.85%  [kernel]          [k] __xdp_return

The test was done with mausezahn on the TX side with 64 byte raw
ethernet frames.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index f20dfd1d7a6b..f88c189b60a4 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2331,7 +2331,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
-	page_pool_release_page(rxq->page_pool, virt_to_page(xdp->data));
+	skb_mark_for_recycle(skb, virt_to_page(xdp->data), &xdp->rxq->mem);
 
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
+		page_pool_store_mem_info(skb_frag_page(frag), &xdp->rxq->mem);
 	}
 
 	return skb;
-- 
2.30.2

