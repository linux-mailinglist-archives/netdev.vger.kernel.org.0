Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9B135A8C6
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 00:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbhDIWih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 18:38:37 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:33571 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234602AbhDIWih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 18:38:37 -0400
Received: by mail-ed1-f54.google.com with SMTP id w18so8341047edc.0;
        Fri, 09 Apr 2021 15:38:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NBKBwFnLR6KheF+0+jTnrdx81GBF+PEZpOcMgLUdP0I=;
        b=QNcDKWg3i3l0fzCFlmYy+3oSUs7xyv3i8GSFrsXg7YaGpUxHqKgh2ztO/FJHSpxRld
         RWmXl0qgtyDjAhfHLJCSdzUnQXyPp5tjw5ufJ7NFKiO3KKFwdH8C1NdZznZYPBcGINz6
         FU1cYQpWY0nBLXjJb79rgLXYFr1KQQKCBxNFE5GyMuupfLmupENS2gZNyRqOZPLVhLi2
         J4LCwIV5o/StbIfRRLs+WKWJEJffn5daUScMsyZI+s46oG3ZJ+xRtJIzzfrqmViEAD4c
         un5ae6IA3tp8a+TWGI5SH1Y1qa+Zw9vNHkm4eofpP4SqFU//7A9HsFYqZ8Uz52w8+63v
         yNaw==
X-Gm-Message-State: AOAM530gq5sgiBYsek14KDwLVWXfg7F77YCi8kN8DRnWdwPrxjfNx2f2
        gQBFJmj88iNAdUvxWiDeNG3f7wH5ermszQ==
X-Google-Smtp-Source: ABdhPJwtnHH8zpJEzm27S9Tc0XAdPpGrPGHLvRaejF34zvtOUNDL6mxmVFoz2jOa3QSgVZRWgp5IlQ==
X-Received: by 2002:a05:6402:51cd:: with SMTP id r13mr19553933edd.116.1618007902253;
        Fri, 09 Apr 2021 15:38:22 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-93-66-21-119.cust.vodafonedsl.it. [93.66.21.119])
        by smtp.gmail.com with ESMTPSA id s20sm2108726edu.93.2021.04.09.15.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 15:38:21 -0700 (PDT)
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
Subject: [PATCH net-next v3 1/5] xdp: reduce size of struct xdp_mem_info
Date:   Sat, 10 Apr 2021 00:37:57 +0200
Message-Id: <20210409223801.104657-2-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210409223801.104657-1-mcroce@linux.microsoft.com>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

It is possible to compress/reduce the size of struct xdp_mem_info.
This change reduce struct xdp_mem_info from 8 bytes to 4 bytes.

The member xdp_mem_info.id can be reduced to u16, as the mem_id_ht
rhashtable in net/core/xdp.c is already limited by MEM_ID_MAX=0xFFFE
which can safely fit in u16.

The member xdp_mem_info.type could be reduced more than u16, as it stores
the enum xdp_mem_type, but due to alignment it is only reduced to u16.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/xdp.h | 4 ++--
 net/core/xdp.c    | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index a5bc214a49d9..c35864d59113 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -48,8 +48,8 @@ enum xdp_mem_type {
 #define XDP_XMIT_FLAGS_MASK	XDP_XMIT_FLUSH
 
 struct xdp_mem_info {
-	u32 type; /* enum xdp_mem_type, but known size type */
-	u32 id;
+	u16 type; /* enum xdp_mem_type, but known size type */
+	u16 id;
 };
 
 struct page_pool;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 05354976c1fc..3dd47ed83778 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -35,11 +35,11 @@ static struct rhashtable *mem_id_ht;
 
 static u32 xdp_mem_id_hashfn(const void *data, u32 len, u32 seed)
 {
-	const u32 *k = data;
-	const u32 key = *k;
+	const u16 *k = data;
+	const u16 key = *k;
 
 	BUILD_BUG_ON(sizeof_field(struct xdp_mem_allocator, mem.id)
-		     != sizeof(u32));
+		     != sizeof(u16));
 
 	/* Use cyclic increasing ID as direct hash key */
 	return key;
@@ -49,7 +49,7 @@ static int xdp_mem_id_cmp(struct rhashtable_compare_arg *arg,
 			  const void *ptr)
 {
 	const struct xdp_mem_allocator *xa = ptr;
-	u32 mem_id = *(u32 *)arg->key;
+	u16 mem_id = *(u16 *)arg->key;
 
 	return xa->mem.id != mem_id;
 }
-- 
2.30.2

