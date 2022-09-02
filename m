Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8745AA5DA
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbiIBCah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235202AbiIBCab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:30:31 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C873FA28;
        Thu,  1 Sep 2022 19:30:26 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 202so751898pgc.8;
        Thu, 01 Sep 2022 19:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=E8MAYkdVIQP0FJEM6EBF4l8Xg/qgqUjpGYemv3sFZKw=;
        b=WS87BarBUJUmdJvwHVOUJY8VhLnc3qqplexcN9euuSS2P7/7zhZnOc+Mdfx1nLfPp4
         9WwWX1Zu+Wrt6tRcQXJGP+9X5wVNcqCKy7Ytx+0yvkRORBzJMZPRSfGfU5GKm/YFHg22
         CbIxqWhkwiFvp6k3naiQouLi/puXIuV6j5aVe07KNixUP6a85g9RtfkPff9rzfmEO4Td
         iGUdUahKFP8/Nv+/ndoJhg+QwuPa20S42nMTGRzV3onP3zPd8NxcsLe87WY1UXyZtYHB
         03hF7uKZlzxujTSM4oSCEJFzU7k8OW1wQlzMsrpPnHhpeL0IifVBg2WuiV3EgidomGr0
         D6bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=E8MAYkdVIQP0FJEM6EBF4l8Xg/qgqUjpGYemv3sFZKw=;
        b=s3Je3q+BAk2Skp0OaWbl+hYdFOn0DnLHrOJr5jdeKIyal+BaDoXLsepHnfZA+72m6E
         d+3fxp/Jnf96eIOBTtzEBUC6TmqIWKCtahBoG17273A/AOw/mX6r63rICHjQGsVf8xQP
         lJ2Ilzh+vSJ1XOWcX2VGnLRYodRc+UqVtkZNw88Oi6FIqyz1ETgPF26veky3GopFJtXU
         UbMm3o8Yh0783BXbOk0cjl+hcFaRYkCfLbFB6QvGebBB1NQcC71iDZe1SJAGIiSjzmX6
         K/3lHjNd0AMihtndbS6h9LazGPNkDVhRZQfExOTtzsqvNDLiQ1W9HZQ4QQYaWk2j4VE3
         rOag==
X-Gm-Message-State: ACgBeo0+UIalwlbX2ME9Lx3ZSNa066b5w0TF+zMoAPLJkFWfVjc4KqDn
        UuExSm74fDQ0G2R93koSN5RQQi1wLAALBH46Tos=
X-Google-Smtp-Source: AA6agR7LqQuyAM3qmmIWpEDGymm/gkFBBR7fNB6mvH0YDlAlzs+wsP1hmzMC4vbU/wwv1JDDBSFZJA==
X-Received: by 2002:a63:e25:0:b0:41c:30f7:c39c with SMTP id d37-20020a630e25000000b0041c30f7c39cmr28488997pgl.147.1662085825466;
        Thu, 01 Sep 2022 19:30:25 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:50ea:5400:4ff:fe1f:fbe2])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902da8400b0017297a6b39dsm269719plx.265.2022.09.01.19.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 19:30:24 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org, tj@kernel.org,
        lizefan.x@bytedance.com
Cc:     cgroups@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 07/13] bpf: Introduce new helpers bpf_ringbuf_pages_{alloc,free}
Date:   Fri,  2 Sep 2022 02:29:57 +0000
Message-Id: <20220902023003.47124-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220902023003.47124-1-laoar.shao@gmail.com>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allocate pages related memory into the new helper
bpf_ringbuf_pages_alloc(), then it can be handled as a single unit.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 kernel/bpf/ringbuf.c | 80 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 56 insertions(+), 24 deletions(-)

diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 5eb7820..1e7284c 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -59,6 +59,57 @@ struct bpf_ringbuf_hdr {
 	u32 pg_off;
 };
 
+static void bpf_ringbuf_pages_free(struct page **pages, int nr_pages)
+{
+	int i;
+
+	for (i = 0; i < nr_pages; i++)
+		__free_page(pages[i]);
+	bpf_map_area_free(pages, NULL);
+}
+
+static struct page **bpf_ringbuf_pages_alloc(struct bpf_map *map,
+					     int nr_meta_pages,
+					     int nr_data_pages,
+					     int numa_node,
+					     const gfp_t flags)
+{
+	int nr_pages = nr_meta_pages + nr_data_pages;
+	struct mem_cgroup *memcg, *old_memcg;
+	struct page **pages, *page;
+	int array_size;
+	int i;
+
+	memcg = bpf_map_get_memcg(map);
+	old_memcg = set_active_memcg(memcg);
+	array_size = (nr_meta_pages + 2 * nr_data_pages) * sizeof(*pages);
+	pages = bpf_map_area_alloc(array_size, numa_node, NULL);
+	if (!pages)
+		goto err;
+
+	for (i = 0; i < nr_pages; i++) {
+		page = alloc_pages_node(numa_node, flags, 0);
+		if (!page) {
+			nr_pages = i;
+			goto err_free_pages;
+		}
+		pages[i] = page;
+		if (i >= nr_meta_pages)
+			pages[nr_data_pages + i] = page;
+	}
+	set_active_memcg(old_memcg);
+	bpf_map_put_memcg(memcg);
+
+	return pages;
+
+err_free_pages:
+	bpf_ringbuf_pages_free(pages, nr_pages);
+err:
+	set_active_memcg(old_memcg);
+	bpf_map_put_memcg(memcg);
+	return NULL;
+}
+
 static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node,
 						  struct bpf_map *map)
 {
@@ -67,10 +118,8 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node,
 	int nr_meta_pages = RINGBUF_PGOFF + RINGBUF_POS_PAGES;
 	int nr_data_pages = data_sz >> PAGE_SHIFT;
 	int nr_pages = nr_meta_pages + nr_data_pages;
-	struct page **pages, *page;
 	struct bpf_ringbuf *rb;
-	size_t array_size;
-	int i;
+	struct page **pages;
 
 	/* Each data page is mapped twice to allow "virtual"
 	 * continuous read of samples wrapping around the end of ring
@@ -89,22 +138,11 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node,
 	 * when mmap()'ed in user-space, simplifying both kernel and
 	 * user-space implementations significantly.
 	 */
-	array_size = (nr_meta_pages + 2 * nr_data_pages) * sizeof(*pages);
-	pages = bpf_map_area_alloc(array_size, numa_node, map);
+	pages = bpf_ringbuf_pages_alloc(map, nr_meta_pages, nr_data_pages,
+					numa_node, flags);
 	if (!pages)
 		return NULL;
 
-	for (i = 0; i < nr_pages; i++) {
-		page = alloc_pages_node(numa_node, flags, 0);
-		if (!page) {
-			nr_pages = i;
-			goto err_free_pages;
-		}
-		pages[i] = page;
-		if (i >= nr_meta_pages)
-			pages[nr_data_pages + i] = page;
-	}
-
 	rb = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
 		  VM_MAP | VM_USERMAP, PAGE_KERNEL);
 	if (rb) {
@@ -114,10 +152,6 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node,
 		return rb;
 	}
 
-err_free_pages:
-	for (i = 0; i < nr_pages; i++)
-		__free_page(pages[i]);
-	bpf_map_area_free(pages, NULL);
 	return NULL;
 }
 
@@ -188,12 +222,10 @@ static void bpf_ringbuf_free(struct bpf_ringbuf *rb)
 	 * to unmap rb itself with vunmap() below
 	 */
 	struct page **pages = rb->pages;
-	int i, nr_pages = rb->nr_pages;
+	int nr_pages = rb->nr_pages;
 
 	vunmap(rb);
-	for (i = 0; i < nr_pages; i++)
-		__free_page(pages[i]);
-	bpf_map_area_free(pages, NULL);
+	bpf_ringbuf_pages_free(pages, nr_pages);
 }
 
 static void ringbuf_map_free(struct bpf_map *map)
-- 
1.8.3.1

