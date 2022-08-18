Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6730E5985D9
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245591AbiHROcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245337AbiHROcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:32:07 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A222B9FBC;
        Thu, 18 Aug 2022 07:32:00 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id d71so1411465pgc.13;
        Thu, 18 Aug 2022 07:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=wfVdiCm3ki6hY+6umh5GbzZ8nNKi0kDY1+Bd1ej/jM8=;
        b=RUKuxfm9E43E5qFQxMfS7R7LCmH7AoY/Gxkx5z0NnN217RoW+idxLKZwqN214SOPzH
         R7piyA5YeKysCY6mM/eUv7rthB/rLsOzSkIiO6t4LEipXfMIXU3WwDO0ARd+SR3DQWU1
         tkAyiSTiSkiobEoeVQCt/ZI9GvL1pe3bJtnh8JJxazxASGrh8rnB1apZ+QqSExE7b2kC
         qD5Wc/SjTr44YPyHd3iQ7qvxVOILbekjFOJ7t7XHJTssYPcUuTdvujBMfI6eyq6W+J+q
         KvIEc61DmQwriVen4GenWzpC5f0TiuwN6owAG2711o9IGRTeXtqEAn03bgqrgWggFrhR
         pVPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=wfVdiCm3ki6hY+6umh5GbzZ8nNKi0kDY1+Bd1ej/jM8=;
        b=2FcygxQC1os5fkluJpb6fyYE/o/t8whdOXMXIrZtcWrZJlHPXq/aViKOZYIAwXKCvp
         E5TyiYRRpv6Vt+AUkQxCIDUPKStcNtOjytXo4Y6+RR/jTg6z8rojflyOtodZ4xgFgtEV
         HNo8O/P/TsUnV3hzrIic9mVgVoOpVhAw8lkLYosk6p36EA2aPxwpqUtmhER5toYPEIMw
         7RsfJ9vIZUE1XJS4GDQ0DsYVi5xvYn+JqIVMA8+3p6Nxgt2QbAKyKqt7aJkkxGjYnw/S
         6r0bxtr04vr1f6KfAzOWX9zIoJtuAiJtZJDxQ0uHZ3LrHGykINrDf53oM+X0vUmcHtaz
         zKzg==
X-Gm-Message-State: ACgBeo2OOyFiRWo5K8tvL34fuRKrJL8RV6i+O8MwSHy4KOJNSbl8SzLx
        G3541bkmsqkxAXUIz9kX49g0InMLwszPApuv
X-Google-Smtp-Source: AA6agR7BKXRJhkd3R6jnBGYeXTOD46Z2q1NB8JbJ2YahjboeHT+Ec+2dxbjICtwclbkbfExrPr+dDw==
X-Received: by 2002:a05:6a00:1709:b0:52e:677b:702b with SMTP id h9-20020a056a00170900b0052e677b702bmr3231480pfc.19.1660833119614;
        Thu, 18 Aug 2022 07:31:59 -0700 (PDT)
Received: from vultr.guest ([45.32.72.237])
        by smtp.gmail.com with ESMTPSA id h5-20020a63f905000000b003fdc16f5de2sm1379124pgi.15.2022.08.18.07.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 07:31:58 -0700 (PDT)
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
        Yafang Shao <laoar.shao@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: [PATCH bpf-next v2 07/12] bpf: Introduce new helpers bpf_ringbuf_pages_{alloc,free}
Date:   Thu, 18 Aug 2022 14:31:13 +0000
Message-Id: <20220818143118.17733-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220818143118.17733-1-laoar.shao@gmail.com>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
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

Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
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

