Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CB037FC07
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 19:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhEMRCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 13:02:12 -0400
Received: from mail-ej1-f51.google.com ([209.85.218.51]:41581 "EHLO
        mail-ej1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbhEMRBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 13:01:44 -0400
Received: by mail-ej1-f51.google.com with SMTP id k10so9606994ejj.8;
        Thu, 13 May 2021 10:00:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=opbCv80kZO0WR00E8CvyXu7JXQ2Kf6zwvEyZ//vM1Tw=;
        b=VAhfWFA8nFT24eDiZTRNa5rnd8SHDkpJBG8BTofyDiXvoPQPYgU8lvYF+WICxw5TOx
         cv0NBNEZj2PQ4C2hGb7aD6B5b9k/R0pInqszK1N2d8ddvaXw8OGcZ6ArYMgTtIdxySP4
         SdktQEF4ZnL1DhnoDlVfRzQDuaPQSzRwjwZStT1ohhEaChVG0QGRKa1MxdHaj8IEzxhH
         JId9Qo3vRsSZ9YGeup2Y22ibbJXndMQHXPvkzMQBk4I3ghhv9jlGpu6FFC0RuAmmWueQ
         7uf+Lppgm3OJxgdRwczm+BJZLHcxViheM5uOYy/KB1aucF4MhK9swtwv888Lg9no8oQf
         1KeA==
X-Gm-Message-State: AOAM530NWIdzo6EeMu6qlrDHN7T6SteVMJt67BW/bHk6l+/cKymjdCrg
        y5/RAz5YE043KV3SDQIGHz/oVg+eMp2G5uTY
X-Google-Smtp-Source: ABdhPJxImITrQc7A7BC8YrzU/gQf+8smgk/vcbRtFyyFBWomH5/JFH9j16xBhSt71cMxnuAzH2+gFA==
X-Received: by 2002:a17:906:3bca:: with SMTP id v10mr12852999ejf.121.1620925232961;
        Thu, 13 May 2021 10:00:32 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id w11sm2959431ede.54.2021.05.13.10.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 10:00:32 -0700 (PDT)
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
Subject: [PATCH net-next v5 5/5] mvneta: recycle buffers
Date:   Thu, 13 May 2021 18:58:46 +0200
Message-Id: <20210513165846.23722-6-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210513165846.23722-1-mcroce@linux.microsoft.com>
References: <20210513165846.23722-1-mcroce@linux.microsoft.com>
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
 drivers/net/ethernet/marvell/mvneta.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 7d5cd9bc6c99..6d2f8dce4900 100644
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
+		skb = mvneta_swbm_build_skb(pp, pp, &xdp_buf, desc_status);
 		if (IS_ERR(skb)) {
 			struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 
-- 
2.31.1

