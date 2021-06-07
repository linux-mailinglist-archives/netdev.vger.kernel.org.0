Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949AB39E71D
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 21:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhFGTFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 15:05:33 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:33756 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbhFGTFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 15:05:31 -0400
Received: by mail-wr1-f45.google.com with SMTP id a20so18869978wrc.0;
        Mon, 07 Jun 2021 12:03:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d5R/Y787deGXI27/C5ydk9yyfai3EZKj2N6INNdZwRE=;
        b=LCfnhqgRNAcuEdsmPu1A+jFzGuXC26tu7a43k8UNJZmW5OUbEnJ15SlaDutb3kDoV+
         z0Tv/DDlXuZb48YpbMcM3gyRoXsM1r4NJzkgE/neHOmXKJF5VwlIAgFJaN2EjnojWhga
         mFSrWLxKJDbIztyxBNRv4tj646TLLZ9AlMlbvO+grVgX9JpJJVF24TEFF4tvUaRQVi+H
         Qx913EFPhKS+T8T6C5QG1hO0vwhr+UdQSCYKi71cO27wImAaY/BUnc4R1scOzX2FcKZF
         QSEsA8sfinqiE3Vef1aapZVn6cgkjFn/GP6Gw2SiIzAHh0KHMdk/mZuz8Raw9z90E2yO
         Xyvg==
X-Gm-Message-State: AOAM530GgVjsiDnXfK5FNZhtoRXnYAbLDfo83KT/qMVCW6rUoB17skT2
        2SebCa6B/JS8iClgT7RUtD9TQ5z4/qkLBw==
X-Google-Smtp-Source: ABdhPJwXAVeGKb20OchlDcpFARTCfj5wSWcd0sVVqP41F1+y4gqRBRSun2vUXAiBLD8b4gI1xkR7Cg==
X-Received: by 2002:a5d:6082:: with SMTP id w2mr18715401wrt.209.1623092618348;
        Mon, 07 Jun 2021 12:03:38 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-37-119-128-179.cust.vodafonedsl.it. [37.119.128.179])
        by smtp.gmail.com with ESMTPSA id g17sm12185968wrp.61.2021.06.07.12.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 12:03:37 -0700 (PDT)
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
Subject: [PATCH net-next v8 2/5] skbuff: add a parameter to __skb_frag_unref
Date:   Mon,  7 Jun 2021 21:02:37 +0200
Message-Id: <20210607190240.36900-3-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210607190240.36900-1-mcroce@linux.microsoft.com>
References: <20210607190240.36900-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

This is a prerequisite patch, the next one is enabling recycling of
skbs and fragments. Add an extra argument on __skb_frag_unref() to
handle recycling, and update the current users of the function with that.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/marvell/sky2.c        | 2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 2 +-
 include/linux/skbuff.h                     | 8 +++++---
 net/core/skbuff.c                          | 4 ++--
 net/tls/tls_device.c                       | 2 +-
 5 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 324c280cc22c..8b8bff59c8fe 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -2503,7 +2503,7 @@ static void skb_put_frags(struct sk_buff *skb, unsigned int hdr_space,
 
 		if (length == 0) {
 			/* don't need this page */
-			__skb_frag_unref(frag);
+			__skb_frag_unref(frag, false);
 			--skb_shinfo(skb)->nr_frags;
 		} else {
 			size = min(length, (unsigned) PAGE_SIZE);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index e35e4d7ef4d1..cea62b8f554c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -526,7 +526,7 @@ static int mlx4_en_complete_rx_desc(struct mlx4_en_priv *priv,
 fail:
 	while (nr > 0) {
 		nr--;
-		__skb_frag_unref(skb_shinfo(skb)->frags + nr);
+		__skb_frag_unref(skb_shinfo(skb)->frags + nr, false);
 	}
 	return 0;
 }
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index dbf820a50a39..7fcfea7e7b21 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3081,10 +3081,12 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
 /**
  * __skb_frag_unref - release a reference on a paged fragment.
  * @frag: the paged fragment
+ * @recycle: recycle the page if allocated via page_pool
  *
- * Releases a reference on the paged fragment @frag.
+ * Releases a reference on the paged fragment @frag
+ * or recycles the page via the page_pool API.
  */
-static inline void __skb_frag_unref(skb_frag_t *frag)
+static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
 {
 	put_page(skb_frag_page(frag));
 }
@@ -3098,7 +3100,7 @@ static inline void __skb_frag_unref(skb_frag_t *frag)
  */
 static inline void skb_frag_unref(struct sk_buff *skb, int f)
 {
-	__skb_frag_unref(&skb_shinfo(skb)->frags[f]);
+	__skb_frag_unref(&skb_shinfo(skb)->frags[f], false);
 }
 
 /**
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3ad22870298c..12b7e90dd2b5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -664,7 +664,7 @@ static void skb_release_data(struct sk_buff *skb)
 	skb_zcopy_clear(skb, true);
 
 	for (i = 0; i < shinfo->nr_frags; i++)
-		__skb_frag_unref(&shinfo->frags[i]);
+		__skb_frag_unref(&shinfo->frags[i], false);
 
 	if (shinfo->frag_list)
 		kfree_skb_list(shinfo->frag_list);
@@ -3495,7 +3495,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 		fragto = &skb_shinfo(tgt)->frags[merge];
 
 		skb_frag_size_add(fragto, skb_frag_size(fragfrom));
-		__skb_frag_unref(fragfrom);
+		__skb_frag_unref(fragfrom, false);
 	}
 
 	/* Reposition in the original skb */
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 76a6f8c2eec4..ad11db2c4f63 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -127,7 +127,7 @@ static void destroy_record(struct tls_record_info *record)
 	int i;
 
 	for (i = 0; i < record->num_frags; i++)
-		__skb_frag_unref(&record->frags[i]);
+		__skb_frag_unref(&record->frags[i], false);
 	kfree(record);
 }
 
-- 
2.31.1

