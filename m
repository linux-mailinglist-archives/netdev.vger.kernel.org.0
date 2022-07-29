Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7EE058526A
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbiG2PYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237118AbiG2PYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:24:00 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B665382F8F;
        Fri, 29 Jul 2022 08:23:42 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id b10so4918166pjq.5;
        Fri, 29 Jul 2022 08:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jAUWseH3fRr8riszGReq2qXDLxnVVqoEg86tgbmI8NE=;
        b=fmrI2QyU7IHbIWzCz94cxxmolN8UgJDWb3QaJ65Tp00KLnhEL9aZ2FVu4/xeQFvkxm
         Vf6GZuOm6d/T0FvqGvBzpq/iwTAPES9t1kDoGxhPm8QpjxLmP/5UJGNNb0u+Sw5CvaJU
         w3rQTlHgYH+YBmFCql1y8JfODcl23WsL8RFZh1+IX1gF88xfPVACbPoI7yeFykfu30rd
         ds2nhZtOma9CpW8KYv3890dSigOkV30IpMYMN9A/3owa6ayTK+XMB4ZF0bjQO7p0A0kv
         6ONIyiiNrA6VEQXauRHRTLAUlWQCeR3w+k0iKKKdb6wLCGF+rBN/rkb2Yv9HkOoqjBOs
         25yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jAUWseH3fRr8riszGReq2qXDLxnVVqoEg86tgbmI8NE=;
        b=uwskmCS1xExgE91sXWuTDI4x1GgKUq5Y0iIZBji89gqqRDoCZJa8aM93DAtBNBR7LQ
         CVdnBhQ2DIY5ozAZHBuJuDscD993eqCVxQPuRrM3eazigTDXPG2BUQUhJ4X45/WPmLKS
         0Z4HnZ4HgZ+od6rDoK035J0c1bAqDRXk2qnM8Wsd2FjAKQvy9j/AEoVu7vOf049vK/nq
         6SiTzcnUQIRoOHHgZn1KoR2x4JXxdy/RA0mnwjQgx+8XSvpdTkTfOZNorUoJrJPFcqTV
         ZF7ct2R7r0rip5g3g3mYKa3PmWG5WVKWhfTKaVT3MXtFjGbxHq947LTZCF0EQJziGdjx
         h+0g==
X-Gm-Message-State: ACgBeo3ZsAr/eIdQ0kNVbPSMn2V0qGNbh7p94AnUEER+Y9fwDqpBDJU6
        MW3ZjmRsj7ayEcLhQ2ARC1Q=
X-Google-Smtp-Source: AA6agR73Gj5Asvp4W0xUgGklQRFVIg49NlQKP3kuhqIKi/rewhM/3O8FzmBipmh7MLHSJUTpYlMo1A==
X-Received: by 2002:a17:903:11c9:b0:16b:8293:c5a1 with SMTP id q9-20020a17090311c900b0016b8293c5a1mr4435414plh.72.1659108222266;
        Fri, 29 Jul 2022 08:23:42 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:2912:5400:4ff:fe16:4344])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm3714219plm.89.2022.07.29.08.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:23:41 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 10/15] bpf: Use bpf_map_pages_alloc in ringbuf
Date:   Fri, 29 Jul 2022 15:23:11 +0000
Message-Id: <20220729152316.58205-11-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220729152316.58205-1-laoar.shao@gmail.com>
References: <20220729152316.58205-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce new helper bpf_map_pages_alloc() for this memory allocation.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h  |  4 ++++
 kernel/bpf/ringbuf.c | 27 +++++++++------------------
 kernel/bpf/syscall.c | 41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 711d9b1829d4..4af72d2b6d73 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1638,8 +1638,12 @@ void *bpf_map_container_alloc(u64 size, int numa_node);
 void *bpf_map_container_mmapable_alloc(u64 size, int numa_node,
 				       u32 align, u32 offset);
 void *bpf_map_area_alloc(struct bpf_map *map, u64 size, int numa_node);
+void *bpf_map_pages_alloc(struct bpf_map *map, struct page **pages,
+			  int nr_meta_pages, int nr_data_pages, int nid,
+			  gfp_t flags, unsigned int order);
 void bpf_map_area_free(void *base);
 void bpf_map_container_free(void *base);
+void bpf_map_pages_free(struct page **pages, int nr_pages);
 bool bpf_map_write_active(const struct bpf_map *map);
 void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
 int  generic_map_lookup_batch(struct bpf_map *map,
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 7c875d4d5b2f..25973cab251d 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -63,15 +63,15 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(struct bpf_map *map,
 						  size_t data_sz,
 						  int numa_node)
 {
-	const gfp_t flags = GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL |
+	const gfp_t flags = GFP_KERNEL | __GFP_RETRY_MAYFAIL |
 			    __GFP_NOWARN | __GFP_ZERO;
 	int nr_meta_pages = RINGBUF_PGOFF + RINGBUF_POS_PAGES;
 	int nr_data_pages = data_sz >> PAGE_SHIFT;
 	int nr_pages = nr_meta_pages + nr_data_pages;
-	struct page **pages, *page;
 	struct bpf_ringbuf *rb;
+	struct page **pages;
 	size_t array_size;
-	int i;
+	void *ptr;
 
 	/* Each data page is mapped twice to allow "virtual"
 	 * continuous read of samples wrapping around the end of ring
@@ -95,16 +95,10 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(struct bpf_map *map,
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
+	ptr = bpf_map_pages_alloc(map, pages, nr_meta_pages, nr_data_pages,
+				  numa_node, flags, 0);
+	if (!ptr)
+		goto err_free_pages;
 
 	rb = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
 		  VM_MAP | VM_USERMAP, PAGE_KERNEL);
@@ -116,8 +110,6 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(struct bpf_map *map,
 	}
 
 err_free_pages:
-	for (i = 0; i < nr_pages; i++)
-		__free_page(pages[i]);
 	bpf_map_area_free(pages);
 	return NULL;
 }
@@ -189,11 +181,10 @@ static void bpf_ringbuf_free(struct bpf_ringbuf *rb)
 	 * to unmap rb itself with vunmap() below
 	 */
 	struct page **pages = rb->pages;
-	int i, nr_pages = rb->nr_pages;
+	int nr_pages = rb->nr_pages;
 
 	vunmap(rb);
-	for (i = 0; i < nr_pages; i++)
-		__free_page(pages[i]);
+	bpf_map_pages_free(pages, nr_pages);
 	bpf_map_area_free(pages);
 }
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4f893d2ac4fd..5c13782839f3 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -559,6 +559,47 @@ void bpf_map_container_free(void *container)
 	kvfree(container);
 }
 
+void *bpf_map_pages_alloc(struct bpf_map *map, struct page **pages,
+			  int nr_meta_pages, int nr_data_pages, int nid,
+			  gfp_t flags, unsigned int order)
+{
+	int nr_pages = nr_meta_pages + nr_data_pages;
+	struct mem_cgroup *memcg, *old_memcg;
+	struct page *page;
+	int i;
+
+	memcg = bpf_map_get_memcg(map);
+	old_memcg = set_active_memcg(memcg);
+	for (i = 0; i < nr_pages; i++) {
+		page = alloc_pages_node(nid, flags | __GFP_ACCOUNT, order);
+		if (!page) {
+			nr_pages = i;
+			set_active_memcg(old_memcg);
+			goto err_free_pages;
+		}
+		pages[i] = page;
+		if (i >= nr_meta_pages)
+			pages[nr_data_pages + i] = page;
+	}
+	set_active_memcg(old_memcg);
+
+	return pages;
+
+err_free_pages:
+	for (i = 0; i < nr_pages; i++)
+		__free_page(pages[i]);
+
+	return NULL;
+}
+
+void bpf_map_pages_free(struct page **pages, int nr_pages)
+{
+	int i;
+
+	for (i = 0; i < nr_pages; i++)
+		__free_page(pages[i]);
+}
+
 static int bpf_map_kptr_off_cmp(const void *a, const void *b)
 {
 	const struct bpf_map_value_off_desc *off_desc1 = a, *off_desc2 = b;
-- 
2.17.1

