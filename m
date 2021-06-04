Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A87139BFB3
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 20:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhFDSgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 14:36:21 -0400
Received: from mail-ej1-f45.google.com ([209.85.218.45]:35389 "EHLO
        mail-ej1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbhFDSgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 14:36:17 -0400
Received: by mail-ej1-f45.google.com with SMTP id h24so15964677ejy.2;
        Fri, 04 Jun 2021 11:34:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gE1hCISNh35haYkCX09NyfgUq9+VCgnI6QikE3p2Dzw=;
        b=oYFjHTS/nSvg8H4Bo9KvPajujBLsaSDsq/3pGlLpDVXcYv26IZyPoWHbPDM3Ph2DlH
         EpWc6iec4Sbhs3/0cGunJpxBkfuwwQwqbsVInZ98dToWzllrrgPnRdPn4URzQLQShhlq
         tmus/voXJc5T2jjkaALBAr5aGtF/fG04cR51r0EVB0pC8YhS/t2Rkkj3HPPawsI7TUkQ
         Rgvo/lSL1xRkxPKXpXQiIBSwO2n3iPToVlPAcb7hHxRz1VBPrJkesGxb1z2OUewqCycs
         M6huNzXgpd3YVVMDODAR49ynFGCbahBtdLROZxeqwC8of64dJDNShc8XSbKvusrEsLZ0
         410Q==
X-Gm-Message-State: AOAM5313Rp1gdKlWtueDHFg2lJNQ1iYdpYv6JoQKk3+MRqrox6JajzMI
        Apai6o7GobkONvEfh5+i/+RNfJ5YZRHMeA==
X-Google-Smtp-Source: ABdhPJxunb7uALobRWGFkQnRIzdB63cbNGyvd6w8CqQbQP/l5q+H05Bq8PKfCehy0dvU6Wz/mHbShA==
X-Received: by 2002:a17:906:27d3:: with SMTP id k19mr5400711ejc.368.1622831668864;
        Fri, 04 Jun 2021 11:34:28 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-37-119-128-179.cust.vodafonedsl.it. [37.119.128.179])
        by smtp.gmail.com with ESMTPSA id k12sm3732039edi.87.2021.06.04.11.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 11:34:28 -0700 (PDT)
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
Subject: [PATCH net-next v7 4/5] mvpp2: recycle buffers
Date:   Fri,  4 Jun 2021 20:33:48 +0200
Message-Id: <20210604183349.30040-5-mcroce@linux.microsoft.com>
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
In a drop rate test, the packet rate is almost doubled,
from 1110 Kpps to 2128 Kpps.

perf top on a stock system shows:

Overhead  Shared Object     Symbol
  34.88%  [kernel]          [k] page_pool_release_page
   8.06%  [kernel]          [k] free_unref_page
   6.42%  [mvpp2]           [k] mvpp2_rx
   6.07%  [kernel]          [k] eth_type_trans
   5.18%  [kernel]          [k] __netif_receive_skb_core
   4.95%  [kernel]          [k] build_skb
   4.88%  [kernel]          [k] kmem_cache_free
   3.97%  [kernel]          [k] kmem_cache_alloc
   3.45%  [kernel]          [k] dev_gro_receive
   2.73%  [kernel]          [k] page_frag_free
   2.07%  [kernel]          [k] __alloc_pages_bulk
   1.99%  [kernel]          [k] arch_local_irq_save
   1.84%  [kernel]          [k] skb_release_data
   1.20%  [kernel]          [k] netif_receive_skb_list_internal

With packet rate stable at 1100 Kpps:

tx: 0 bps 0 pps rx: 532.7 Mbps 1110 Kpps
tx: 0 bps 0 pps rx: 532.6 Mbps 1110 Kpps
tx: 0 bps 0 pps rx: 532.4 Mbps 1109 Kpps
tx: 0 bps 0 pps rx: 532.1 Mbps 1109 Kpps
tx: 0 bps 0 pps rx: 531.9 Mbps 1108 Kpps
tx: 0 bps 0 pps rx: 531.9 Mbps 1108 Kpps

And this is the same output with recycling enabled:

Overhead  Shared Object     Symbol
  12.91%  [kernel]          [k] eth_type_trans
  12.54%  [mvpp2]           [k] mvpp2_rx
   9.67%  [kernel]          [k] build_skb
   9.63%  [kernel]          [k] __netif_receive_skb_core
   8.44%  [kernel]          [k] page_pool_put_page
   8.07%  [kernel]          [k] kmem_cache_free
   7.79%  [kernel]          [k] kmem_cache_alloc
   6.86%  [kernel]          [k] dev_gro_receive
   3.19%  [kernel]          [k] skb_release_data
   2.41%  [kernel]          [k] netif_receive_skb_list_internal
   2.18%  [kernel]          [k] page_pool_refill_alloc_cache
   1.76%  [kernel]          [k] napi_gro_receive
   1.61%  [kernel]          [k] kfree_skb
   1.20%  [kernel]          [k] dma_sync_single_for_device
   1.16%  [mvpp2]           [k] mvpp2_poll
   1.12%  [mvpp2]           [k] mvpp2_read

With packet rate above 2100 Kpps:

tx: 0 bps 0 pps rx: 1021 Mbps 2128 Kpps
tx: 0 bps 0 pps rx: 1021 Mbps 2127 Kpps
tx: 0 bps 0 pps rx: 1021 Mbps 2128 Kpps
tx: 0 bps 0 pps rx: 1021 Mbps 2128 Kpps
tx: 0 bps 0 pps rx: 1022 Mbps 2128 Kpps
tx: 0 bps 0 pps rx: 1022 Mbps 2129 Kpps

The major performance increase is explained by the fact that the most CPU
consuming functions (page_pool_release_page, page_frag_free and
free_unref_page) are no longer called on a per packet basis.

The test was done by sending to the macchiatobin 64 byte ethernet frames
with an invalid ethertype, so the packets are dropped early in the RX path.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d4fb620f53f3..b1d186abcc6c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3997,7 +3997,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		}
 
 		if (pp)
-			page_pool_release_page(pp, virt_to_page(data));
+			skb_mark_for_recycle(skb, virt_to_page(data), pp);
 		else
 			dma_unmap_single_attrs(dev->dev.parent, dma_addr,
 					       bm_pool->buf_size, DMA_FROM_DEVICE,
-- 
2.31.1

