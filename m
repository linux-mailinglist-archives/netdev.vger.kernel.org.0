Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2305E83C8
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbiIWUdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbiIWUcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:32:32 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206DD149D29
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:29 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso1236129pjd.4
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=WvdKcFRqdjuCQfT0JD0gE0+SmtwNOrU+Pg1jOBHe3u4=;
        b=HrEaRqblEiynLI80qIODRxODwTegHwanOC+vBRaT+N4CuyIyDnT1Ka3u4nfVp9IIHd
         diT0lWeZvMtZhxZoszDpodW+IF3HNONiVLb+u/CcrtF0chbqY7ZgfyXXY3bccBOo8VEU
         9aWzIy88EGpAGDtPIK6TJqjioaB1k1Ced9PHo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=WvdKcFRqdjuCQfT0JD0gE0+SmtwNOrU+Pg1jOBHe3u4=;
        b=3e8Il5gzmtFAXVKbBxi+ejD02uM6ucEKN5mbnEJK6v89iKysh32YWJ7F47WQtulMXi
         UZKGBtomBMD51+scZY2Qvutu1Da9Lzs5jbQNjsyfrCrKPdoZlWYo6+mmyXvRCmFIDWXT
         7sfodPq+YkMYK5OG8eWEKy8R7GnyCVA1xZ86SzYj3jLXVFnqw9hEVqusNsMgNnXEv0Ws
         oFASuwCstI3WqhSl03xqZqwwDqZwhhoSQPE+f/urO92g8VSYJr27Iy6fDy3sKGgI2f45
         tUC7PRQ0FH5o6Gc3FTQiQAoyyFpO9Ru9yK/T9ugwylcKN4IHztN6UljkYBMkP4d9HB0F
         /CpA==
X-Gm-Message-State: ACrzQf3qNUKROgNkL0N2P1ydOsmGdrTUsuWUEdgWucCVM7foDWKcBXZy
        hAgoXFJxwnm9idr09ARHzf3p+g==
X-Google-Smtp-Source: AMsMyM4ngI9FRR1eL+yZ6uwD2KKL58Y//80JdSNI55TW3osObzJLJuYdaOAbceb8ExT348oeslycRw==
X-Received: by 2002:a17:90b:1d12:b0:200:461c:fa7d with SMTP id on18-20020a17090b1d1200b00200461cfa7dmr11526582pjb.38.1663964907877;
        Fri, 23 Sep 2022 13:28:27 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l11-20020a170902f68b00b0017832c8cc85sm6427549plg.292.2022.09.23.13.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:28:25 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        David Rientjes <rientjes@google.com>,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 03/16] skbuff: Proactively round up to kmalloc bucket size
Date:   Fri, 23 Sep 2022 13:28:09 -0700
Message-Id: <20220923202822.2667581-4-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923202822.2667581-1-keescook@chromium.org>
References: <20220923202822.2667581-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8786; h=from:subject; bh=/55In49mcQKg/1B/2W03m4b/pZThn3d5JbnnA49Rm6I=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjLhbkHxh06F0h70CVmnqi/5BazOvRlOHWM3KgI6U5 EH+6FCyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYy4W5AAKCRCJcvTf3G3AJhURD/ 9I6XEF+He0Ww+60DOgfxrHQg5rlWLQ0kqhBM44ODly9CeGSh3lhyoVQ/h9WpsVZNuLWimeIaArOgsM IAW1lVoADGZnBF9ATBVtZo64La+i6ahcPdQ7LBs/s6pDjZeopNi7al0Bt1YzlRe0VOSUjYGy82cVtY WOaobW8pTWoyLTjo3iTpHKyFaKQN1MKp1Y3EqG0/B05W8mFeqsmuQ0qy6EIiP8Zs4iEfvR/7UrSGb0 BVshxfoJapBmV7hlF/1qXAMi4Nva19VNb6+8aYgQRWD6SHG43lz++GxcOt3rERzf1S1B61G/WpKdPE OmQF4aoA0KyjqK6KPG9b+IKbK9H4qTgxuIMqrcyFVniVxLQqm8OZeZ7G8Sc/RmyqeiIp4dcT2wfHlo 9rn+/pIzx3dZkhHIt1dBi6oGIYcft5FhSjoTBRNpDCbB3q6t7Z6v+2tx9BprHS7rO3CCsH36HQEZ7B UKU1zH31UqO/iWiGbvto4ioPgRV91yQV1fmC9MAvO70ri2/E2LfLPOhO5Ie/MQ1W6dyCRLrTbXBryi qvuZGLPA690eYRPxm2oVZ54qQE6SU2XdbPMDsuG9ONR6QSv2mTERQ9OgeKQnOPu3Yznrzyd99lObTv OIpbLfaEVj2GDT+fQjDKwgYif/bE416Ch2kM90zcPNidPn2ZZH/+EY2ye6/A==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of discovering the kmalloc bucket size _after_ allocation, round
up proactively so the allocation is explicitly made for the full size,
allowing the compiler to correctly reason about the resulting size of
the buffer through the existing __alloc_size() hint.

This will allow for kernels built with CONFIG_UBSAN_BOUNDS or the
coming dynamic bounds checking under CONFIG_FORTIFY_SOURCE to gain
back the __alloc_size() hints that were temporarily reverted in commit
93dd04ab0b2b ("slab: remove __alloc_size attribute from __kmalloc_track_caller")

Additionally tries to normalize size variables to u32 from int. Most
interfaces are using "int", but notably __alloc_skb uses unsigned int.

Also fix some reverse Christmas tree and comments while touching nearby
code.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/skbuff.h |  5 +---
 net/core/skbuff.c      | 64 +++++++++++++++++++++---------------------
 2 files changed, 33 insertions(+), 36 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ca8afa382bf2..5a16177f38b5 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1234,7 +1234,7 @@ void kfree_skb_partial(struct sk_buff *skb, bool head_stolen);
 bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 		      bool *fragstolen, int *delta_truesize);
 
-struct sk_buff *__alloc_skb(unsigned int size, gfp_t priority, int flags,
+struct sk_buff *__alloc_skb(unsigned int bytes, gfp_t priority, int flags,
 			    int node);
 struct sk_buff *__build_skb(void *data, unsigned int frag_size);
 struct sk_buff *build_skb(void *data, unsigned int frag_size);
@@ -1870,9 +1870,6 @@ static inline int skb_unclone(struct sk_buff *skb, gfp_t pri)
 
 /* This variant of skb_unclone() makes sure skb->truesize
  * and skb_end_offset() are not changed, whenever a new skb->head is needed.
- *
- * Indeed there is no guarantee that ksize(kmalloc(X)) == ksize(kmalloc(X))
- * when various debugging features are in place.
  */
 int __skb_unclone_keeptruesize(struct sk_buff *skb, gfp_t pri);
 static inline int skb_unclone_keeptruesize(struct sk_buff *skb, gfp_t pri)
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 974bbbbe7138..0b30fbdbd0d0 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -343,19 +343,23 @@ EXPORT_SYMBOL(napi_build_skb);
  * the caller if emergency pfmemalloc reserves are being used. If it is and
  * the socket is later found to be SOCK_MEMALLOC then PFMEMALLOC reserves
  * may be used. Otherwise, the packet data may be discarded until enough
- * memory is free
+ * memory is free.
  */
-static void *kmalloc_reserve(size_t size, gfp_t flags, int node,
+static void *kmalloc_reserve(u32 *size, gfp_t flags, int node,
 			     bool *pfmemalloc)
 {
 	void *obj;
 	bool ret_pfmemalloc = false;
 
+	/* kmalloc(size) might give us more room than requested, so
+	 * allocate the true bucket size up front.
+	 */
+	*size = kmalloc_size_roundup(*size);
 	/*
 	 * Try a regular allocation, when that fails and we're not entitled
 	 * to the reserves, fail.
 	 */
-	obj = kmalloc_node_track_caller(size,
+	obj = kmalloc_node_track_caller(*size,
 					flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
 					node);
 	if (obj || !(gfp_pfmemalloc_allowed(flags)))
@@ -363,7 +367,7 @@ static void *kmalloc_reserve(size_t size, gfp_t flags, int node,
 
 	/* Try again but now we are using pfmemalloc reserves */
 	ret_pfmemalloc = true;
-	obj = kmalloc_node_track_caller(size, flags, node);
+	obj = kmalloc_node_track_caller(*size, flags, node);
 
 out:
 	if (pfmemalloc)
@@ -380,7 +384,7 @@ static void *kmalloc_reserve(size_t size, gfp_t flags, int node,
 
 /**
  *	__alloc_skb	-	allocate a network buffer
- *	@size: size to allocate
+ *	@bytes: minimum bytes to allocate
  *	@gfp_mask: allocation mask
  *	@flags: If SKB_ALLOC_FCLONE is set, allocate from fclone cache
  *		instead of head cache and allocate a cloned (child) skb.
@@ -395,12 +399,12 @@ static void *kmalloc_reserve(size_t size, gfp_t flags, int node,
  *	Buffers may only be allocated from interrupts using a @gfp_mask of
  *	%GFP_ATOMIC.
  */
-struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
+struct sk_buff *__alloc_skb(unsigned int bytes, gfp_t gfp_mask,
 			    int flags, int node)
 {
 	struct kmem_cache *cache;
 	struct sk_buff *skb;
-	unsigned int osize;
+	u32 size = bytes;
 	bool pfmemalloc;
 	u8 *data;
 
@@ -427,15 +431,13 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	 */
 	size = SKB_DATA_ALIGN(size);
 	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
-	if (unlikely(!data))
-		goto nodata;
-	/* kmalloc(size) might give us more room than requested.
-	 * Put skb_shared_info exactly at the end of allocated zone,
+	/* Put skb_shared_info exactly at the end of allocated zone,
 	 * to allow max possible filling before reallocation.
 	 */
-	osize = ksize(data);
-	size = SKB_WITH_OVERHEAD(osize);
+	data = kmalloc_reserve(&size, gfp_mask, node, &pfmemalloc);
+	if (unlikely(!data))
+		goto nodata;
+	size = SKB_WITH_OVERHEAD(size);
 	prefetchw(data + size);
 
 	/*
@@ -444,7 +446,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	 * the tail pointer in struct sk_buff!
 	 */
 	memset(skb, 0, offsetof(struct sk_buff, tail));
-	__build_skb_around(skb, data, osize);
+	__build_skb_around(skb, data, size);
 	skb->pfmemalloc = pfmemalloc;
 
 	if (flags & SKB_ALLOC_FCLONE) {
@@ -1708,7 +1710,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 		     gfp_t gfp_mask)
 {
 	int i, osize = skb_end_offset(skb);
-	int size = osize + nhead + ntail;
+	u32 size = osize + nhead + ntail;
 	long off;
 	u8 *data;
 
@@ -1722,11 +1724,11 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
-	data = kmalloc_reserve(size + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
-			       gfp_mask, NUMA_NO_NODE, NULL);
+	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		goto nodata;
-	size = SKB_WITH_OVERHEAD(ksize(data));
+	size = SKB_WITH_OVERHEAD(size);
 
 	/* Copy only real data... and, alas, header. This should be
 	 * optimized for the cases when header is void.
@@ -6060,22 +6062,21 @@ EXPORT_SYMBOL(alloc_skb_with_frags);
 static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 				    const int headlen, gfp_t gfp_mask)
 {
-	int i;
-	int size = skb_end_offset(skb);
+	u32 size = skb_end_offset(skb);
 	int new_hlen = headlen - off;
 	u8 *data;
+	int i;
 
 	size = SKB_DATA_ALIGN(size);
 
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
-	data = kmalloc_reserve(size +
-			       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
-			       gfp_mask, NUMA_NO_NODE, NULL);
+	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		return -ENOMEM;
 
-	size = SKB_WITH_OVERHEAD(ksize(data));
+	size = SKB_WITH_OVERHEAD(size);
 
 	/* Copy real data, and all frags */
 	skb_copy_from_linear_data_offset(skb, off, data, new_hlen);
@@ -6179,23 +6180,22 @@ static int pskb_carve_frag_list(struct sk_buff *skb,
 static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 				       int pos, gfp_t gfp_mask)
 {
-	int i, k = 0;
-	int size = skb_end_offset(skb);
-	u8 *data;
 	const int nfrags = skb_shinfo(skb)->nr_frags;
 	struct skb_shared_info *shinfo;
+	u32 size = skb_end_offset(skb);
+	int i, k = 0;
+	u8 *data;
 
 	size = SKB_DATA_ALIGN(size);
 
 	if (skb_pfmemalloc(skb))
 		gfp_mask |= __GFP_MEMALLOC;
-	data = kmalloc_reserve(size +
-			       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
-			       gfp_mask, NUMA_NO_NODE, NULL);
+	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	data = kmalloc_reserve(&size, gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		return -ENOMEM;
 
-	size = SKB_WITH_OVERHEAD(ksize(data));
+	size = SKB_WITH_OVERHEAD(size);
 
 	memcpy((struct skb_shared_info *)(data + size),
 	       skb_shinfo(skb), offsetof(struct skb_shared_info, frags[0]));
-- 
2.34.1

