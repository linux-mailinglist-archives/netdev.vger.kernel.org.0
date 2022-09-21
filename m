Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10465C04FB
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 19:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiIURAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 13:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiIURA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 13:00:29 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EA16170D;
        Wed, 21 Sep 2022 10:00:21 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id v4so6508058pgi.10;
        Wed, 21 Sep 2022 10:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=E8MAYkdVIQP0FJEM6EBF4l8Xg/qgqUjpGYemv3sFZKw=;
        b=Qlgug0EJTn9PhpLyeh5mxZ2/UgDdHf7kf/FXA3gXzZJQImIqnKk1qK72+iKUYP8Jmn
         Kp8KiFpG5E+RRflbtRDIb8lBO48xrjsDhj3VW+NCLDbK5wXD7ehjODlRWXgXzpQfRpKO
         kErn7juPi38n3YWxo8c71AlpBn8KSyYyfB9OhzeFhlfSS94dz4nyUOVPfTzX19ziXUc1
         4hOC1yDAom+aQhvQ+Ka3nL+yQE+JoGYamz/4p+g20oKVz88RehgrKH6TsC5zdKM5ve0O
         JeOSaqmiubTlLv9wDJl4oNpd74MA+/N/cYIxyA3XO9aKRZWfYkpKWoa/nlhO8KLJaxiP
         rU/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=E8MAYkdVIQP0FJEM6EBF4l8Xg/qgqUjpGYemv3sFZKw=;
        b=lBdjl4UppqNVSpLhrv8QCovhHko6e+U0xO8OXo7z9dnAhQwU2CZx3/zYPAKEIMMD17
         ibJos2ZhFlzDLQi/S+oyUlyR+4+pzYTxPDGxIbR4oU12aVC6NOE74wl0ogKbBdqLgpVC
         gKHGF1RbUDR4f+n6ZNdufjiNcrcmHD0yg49VAer6iSiqEMW5J/kIdR1vCHWWghfZ/LT6
         4O4lsVpJXunrVf4j4XhUlOaiU/pqMalO2GLdcMdXf7O5r9q524MPY8OxeI2tFkcD1tC+
         TB+PTMtYgGDPMJvkKTPU1/l9obUcvtNV8xVzD/5sTQzXpJyyIQ8cJAVEZ/RC9qEwhhtP
         1kIA==
X-Gm-Message-State: ACrzQf1Qr/GS8qAzf0XBr4g9Ysz1NXmJqmdykC/SF2wzj7xj+8t6urrH
        qNJW4Stb6+gR+vmMH0z0uV0=
X-Google-Smtp-Source: AMsMyM47Iwz30ngRYs701fJgHSVfpL6lW6gHhsxmWmTedwveJGUmb3HZL9GZo+r5hRLHTT+3qGXjNw==
X-Received: by 2002:a05:6a00:1484:b0:547:89e:272c with SMTP id v4-20020a056a00148400b00547089e272cmr30005190pfu.0.1663779621239;
        Wed, 21 Sep 2022 10:00:21 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:488e:5400:4ff:fe25:7db8])
        by smtp.gmail.com with ESMTPSA id mp4-20020a17090b190400b002006f8e7688sm2102495pjb.32.2022.09.21.10.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 10:00:20 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next 06/10] bpf: Introduce new helpers bpf_ringbuf_pages_{alloc,free}
Date:   Wed, 21 Sep 2022 16:59:58 +0000
Message-Id: <20220921170002.29557-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220921170002.29557-1-laoar.shao@gmail.com>
References: <20220921170002.29557-1-laoar.shao@gmail.com>
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

