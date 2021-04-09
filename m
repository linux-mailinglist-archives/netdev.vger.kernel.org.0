Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1561235A8CA
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 00:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbhDIWiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 18:38:52 -0400
Received: from mail-ej1-f54.google.com ([209.85.218.54]:41907 "EHLO
        mail-ej1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234602AbhDIWiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 18:38:50 -0400
Received: by mail-ej1-f54.google.com with SMTP id g17so8223581ejp.8;
        Fri, 09 Apr 2021 15:38:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vTaN//8xhOW6+dxdPY1I1bInoY8eqI/bBr1slqBlUSQ=;
        b=MDJPl/myf2AZgAwuJjMBhWk6pfLHyNCg5mhMjK7qfm2mLiXx/A9XoQhXloOOf4LGkn
         53vW/FmHMwWPCBwPI3wheZ5VDKq2BFNWEdh5rSaSv9gtJdxPZRg8W5r5B/4zuSVash/A
         PJRBHjkQRG/XjQn2X3x45djtx++ZYgObD0W6X+Pop7E2M/jDmkq1pvzMcgcfqnQ43jh+
         Ttg2wFetjLyIWIpm3ZONTyLR4V0X6mQL7T7BV0R0wNBZ5rVcNrgEedl553XuaUDQVuC+
         kvkmtUkvWO/90MTteiSdOn6sju+C5f+viLBtzl2USOaS+Z2qDjiPkuvi852X2Kp8d+6f
         s0jA==
X-Gm-Message-State: AOAM532Bu3ACDFh50oZWReuhk5OfYcyiOMFAft6X60gR0OVvA+taK4UF
        G0M6wDdxoT/hnwfwnhJEZFTSLo24GX8PiA==
X-Google-Smtp-Source: ABdhPJxw/xKPMPcoWnc0Xwnb5N/pYOuckTTq0yj9tph5v/fPkzmO94ANO8HgYyDIdQekYGgL1qsvbA==
X-Received: by 2002:a17:907:3c08:: with SMTP id gh8mr4361500ejc.439.1618007916135;
        Fri, 09 Apr 2021 15:38:36 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-93-66-21-119.cust.vodafonedsl.it. [93.66.21.119])
        by smtp.gmail.com with ESMTPSA id s20sm2108726edu.93.2021.04.09.15.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 15:38:35 -0700 (PDT)
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
Subject: [PATCH net-next v3 2/5] mm: add a signature in struct page
Date:   Sat, 10 Apr 2021 00:37:58 +0200
Message-Id: <20210409223801.104657-3-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210409223801.104657-1-mcroce@linux.microsoft.com>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

This is needed by the page_pool to avoid recycling a page not allocated
via page_pool.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 include/linux/mm_types.h | 1 +
 include/net/page_pool.h  | 2 ++
 net/core/page_pool.c     | 4 ++++
 3 files changed, 7 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6613b26a8894..ef2d0d5f62e4 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -101,6 +101,7 @@ struct page {
 			 * 32-bit architectures.
 			 */
 			dma_addr_t dma_addr;
+			unsigned long signature;
 		};
 		struct {	/* slab, slob and slub */
 			union {
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index b5b195305346..b30405e84b5e 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -63,6 +63,8 @@
  */
 #define PP_ALLOC_CACHE_SIZE	128
 #define PP_ALLOC_CACHE_REFILL	64
+#define PP_SIGNATURE		0x20210303
+
 struct pp_alloc_cache {
 	u32 count;
 	void *cache[PP_ALLOC_CACHE_SIZE];
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index ad8b0707af04..2ae9b554ef98 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -232,6 +232,8 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
 
 skip_dma_map:
+	page->signature = PP_SIGNATURE;
+
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
 
@@ -302,6 +304,8 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
 			     DMA_ATTR_SKIP_CPU_SYNC);
 	page->dma_addr = 0;
 skip_dma_unmap:
+	page->signature = 0;
+
 	/* This may be the last page returned, releasing the pool, so
 	 * it is not safe to reference pool afterwards.
 	 */
-- 
2.30.2

