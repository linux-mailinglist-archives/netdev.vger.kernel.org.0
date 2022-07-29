Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3500E585265
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237397AbiG2PXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237393AbiG2PXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:23:34 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5E282F8F;
        Fri, 29 Jul 2022 08:23:32 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id b22so4885761plz.9;
        Fri, 29 Jul 2022 08:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3d+Vnnj0Wn2TotffdpnitiR4y4GtmpBbmAGTyIaTSkM=;
        b=idobMl1R4oCtQYLGjlYto1s6UlhcTJgFu3NUkjfEi5j6NUZx/r/8NUrkKFKQkM8u9x
         pEjnY9LgsdKpeXwc5YSZDJmaxyDUa9ivpvl188U8XXHGn5XzMAVN3T9OutqAU7BFa1tB
         RHLfjrBhaeV/pigJlqITo6VJ6jwgEuSkMlIKHOx6qfNfvTbBGTisqrwfyhKZjcuvTWj2
         ue3m7bUU2oS9KYQvKvEEgqk+WIWEySkGfnHoWRYj2vtQlFrR4QQDbLc2GnWwuYyrnj2p
         /DU304Bsu8zNJH+SRzWorjTy/+gukbTajj1B+VAk4F9X6tWiejJF+TyNBni7hBaYzHZp
         lgog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3d+Vnnj0Wn2TotffdpnitiR4y4GtmpBbmAGTyIaTSkM=;
        b=5XScZowZR0VXR8EAr2bSJREl2qczwytL6pv0Uut7/hl6+TXjqfvFOzN0kCFZM/iwzB
         8GEh2M+yLJsH2VSyfAURPV7THBinDKzSXGZS/Fg7mb3Em4i4aMQLXXT6RF4paRKkv++H
         vKOJFbpjokV6D4EhdAKUqwLoJguHc0iZNRWK+tFaTkHaHlCU66kbXyiLa7ZTU1lw1p+O
         bRgboeo2+G1Am0iyxnqWkvuvTvtz6MpW4L6CmvbS9AC/9hunPPRM9Y96l0eAFE3STZAt
         tLHnrxEcYfzp/xb+GeucVzDQbFvZobxkAMy3p4KVo7LOiAgewEOra3dwMcaP+mjagukg
         J/iQ==
X-Gm-Message-State: ACgBeo3h1WSVkMeimrquDC28mlowOoMRMeRL7ClE7QUqJ56PK2pQTHnB
        SJVTz4J3CQRs1sa0H7zo4G8=
X-Google-Smtp-Source: AA6agR5ZlXbmQGLf5QjvBmdvX0UV8lkVnYqG2atAs/tSFEhkNBwSchlIEUS8VEdkWcaJra/qvhUN2w==
X-Received: by 2002:a17:902:e8c6:b0:16d:ab3a:1d42 with SMTP id v6-20020a170902e8c600b0016dab3a1d42mr4150046plg.28.1659108211481;
        Fri, 29 Jul 2022 08:23:31 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:2912:5400:4ff:fe16:4344])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm3714219plm.89.2022.07.29.08.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:23:30 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 05/15] bpf: Introduce helpers for container of struct bpf_map
Date:   Fri, 29 Jul 2022 15:23:06 +0000
Message-Id: <20220729152316.58205-6-laoar.shao@gmail.com>
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

Currently bpf_map_area_alloc() is used to allocate a container of struct
bpf_map or members in this container. To distinguish the map creation
and other members, let split it into two different helpers,
  - bpf_map_container_alloc()
    Used to allocate a container of struct bpf_map, the container is as
    follows,
      struct bpf_map_container {
        struct bpf_map map;  // the map must be the first member
        ....
      };
    Pls. note that the struct bpf_map_contianer is a abstract one, which
    can be struct bpf_array, struct bpf_bloom_filter and etc.

    In this helper, it will call bpf_map_save_memcg() to init memcg
    relevant data in the bpf map. And these data will be cleared in
    bpf_map_container_free().

  - bpf_map_area_alloc()
    Now it is used to allocate the members in a contianer only.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h  |  4 ++++
 kernel/bpf/syscall.c | 56 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 20c26aed7896..2d971b0eb24b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1634,9 +1634,13 @@ void bpf_map_inc_with_uref(struct bpf_map *map);
 struct bpf_map * __must_check bpf_map_inc_not_zero(struct bpf_map *map);
 void bpf_map_put_with_uref(struct bpf_map *map);
 void bpf_map_put(struct bpf_map *map);
+void *bpf_map_container_alloc(u64 size, int numa_node);
+void *bpf_map_container_mmapable_alloc(u64 size, int numa_node,
+				       u32 align, u32 offset);
 void *bpf_map_area_alloc(u64 size, int numa_node);
 void *bpf_map_area_mmapable_alloc(u64 size, int numa_node);
 void bpf_map_area_free(void *base);
+void bpf_map_container_free(void *base);
 bool bpf_map_write_active(const struct bpf_map *map);
 void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
 int  generic_map_lookup_batch(struct bpf_map *map,
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 83c7136c5788..1a1a81a11b37 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -495,6 +495,62 @@ static void bpf_map_release_memcg(struct bpf_map *map)
 }
 #endif
 
+/*
+ * The return pointer is a bpf_map container, as follow,
+ *   struct bpf_map_container {
+ *       struct bpf_map map;
+ *       ...
+ *   };
+ *
+ * It is used in map creation path.
+ */
+void *bpf_map_container_alloc(u64 size, int numa_node)
+{
+	struct bpf_map *map;
+	void *container;
+
+	container = __bpf_map_area_alloc(size, numa_node, false);
+	if (!container)
+		return NULL;
+
+	map = (struct bpf_map *)container;
+	bpf_map_save_memcg(map);
+
+	return container;
+}
+
+void *bpf_map_container_mmapable_alloc(u64 size, int numa_node, u32 align,
+				       u32 offset)
+{
+	struct bpf_map *map;
+	void *container;
+	void *ptr;
+
+	/* kmalloc'ed memory can't be mmap'ed, use explicit vmalloc */
+	ptr = __bpf_map_area_alloc(size, numa_node, true);
+	if (!ptr)
+		return NULL;
+
+	container = ptr + align - offset;
+	map = (struct bpf_map *)container;
+	bpf_map_save_memcg(map);
+
+	return ptr;
+}
+
+void bpf_map_container_free(void *container)
+{
+	struct bpf_map *map;
+
+	if (!container)
+		return;
+
+	map = (struct bpf_map *)container;
+	bpf_map_release_memcg(map);
+
+	kvfree(container);
+}
+
 static int bpf_map_kptr_off_cmp(const void *a, const void *b)
 {
 	const struct bpf_map_value_off_desc *off_desc1 = a, *off_desc2 = b;
-- 
2.17.1

