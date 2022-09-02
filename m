Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB345AA5D4
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbiIBCac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235049AbiIBCaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:30:21 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A073342A;
        Thu,  1 Sep 2022 19:30:18 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c2so571538plo.3;
        Thu, 01 Sep 2022 19:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=4M2wIpbTEjtveSWIAJbVEhxb96NjEAIn1cqGJw9nWyA=;
        b=jzt0LFNt/yVYD/3NUXzIBoEoI9rvRu241Gab6qFW2E6IBiyGaWJo2ZbTstkJc00kFU
         9pZPZRV9AJV3QOLgrCv3w0o+0Zz6uTS264NCkTYPkC1JfBWOvOR9S/q6z3QfpqL91hZc
         Gw3YnTYgM5ch+cMtv6X6YSKgZFeHqM5lAc0gvuZUP6goEJJhbrHBcgfQHPcp/Hsa0J64
         +mB9/MkbcbHohZh88cJ3YPci73xopvwgOehe+rNkUxm4HG3wIVKo9q/fsO4eN9/sJLWH
         7EiEn2lzWBAUsRbZFv3jPcIH8tsIo6MVCShqoy1P8lviU8jjl7rXfdx2Su2uGv7ACgRC
         t22g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=4M2wIpbTEjtveSWIAJbVEhxb96NjEAIn1cqGJw9nWyA=;
        b=OCyxvjtg8o8czYCgoCPq2GJHwNVMzPPxsJsodoS9DqbpJBd4rJVE9e505aVudoDE54
         nRe31cOitg+ilkKWbGtNeltBOKyw3d/Zv/EoYwPq0Kz3sCtVsko9UjZJLd8axTMkj1vi
         Rj7ffBkETXv5AYtHnfYdEpaI4/zvjInfyy6JsjdhYjrDZTTiibSCIWi8S6Pyay9to4rR
         DpDyyvoO3MZeE9Facc6NtYnSTIOrwKkoLjkHBziU4aGvfYI9eeE1VKgSL0SV6btB3lxN
         yiYNkSDdQfui+RoJFn/w3B4IV3ZdX2qJYHMl86aIXL9lbUCQbNQukJdXPhFymekdC3zh
         KbOg==
X-Gm-Message-State: ACgBeo2q9eDj6gtym4l+G/41+fsqFUqOanknZbou19+ZUqJN2hPOmrRY
        dcRmduSYwkBw8dFwKudzZ4E=
X-Google-Smtp-Source: AA6agR7FG/Tgj/X3jzFMLSjqn8xywcVs0S+evyTTodrZ7Ljz0USgvqGYM2KFO6GT0BcGn+RNK9ts3A==
X-Received: by 2002:a17:902:db12:b0:16e:eaf9:e98d with SMTP id m18-20020a170902db1200b0016eeaf9e98dmr33174440plx.172.1662085817212;
        Thu, 01 Sep 2022 19:30:17 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:50ea:5400:4ff:fe1f:fbe2])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902da8400b0017297a6b39dsm269719plx.265.2022.09.01.19.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 19:30:16 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 03/13] bpf: Define bpf_map_{get,put}_memcg for !CONFIG_MEMCG_KMEM
Date:   Fri,  2 Sep 2022 02:29:53 +0000
Message-Id: <20220902023003.47124-4-laoar.shao@gmail.com>
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

We can use this helper when CONFIG_MEMCG_KMEM or CONFIG_MEMCG is not set.
It also moves bpf_map_{get,put}_memcg into include/linux/bpf.h, so
these two helpers can be used in other source files.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h        | 26 ++++++++++++++++++++++++++
 include/linux/memcontrol.h | 10 ++++++++++
 kernel/bpf/syscall.c       | 13 -------------
 3 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9c16749..a50d29c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -27,6 +27,7 @@
 #include <linux/bpfptr.h>
 #include <linux/btf.h>
 #include <linux/rcupdate_trace.h>
+#include <linux/memcontrol.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -2594,4 +2595,29 @@ static inline void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype) {}
 static inline void bpf_cgroup_atype_put(int cgroup_atype) {}
 #endif /* CONFIG_BPF_LSM */
 
+#ifdef CONFIG_MEMCG_KMEM
+static inline struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
+{
+	if (map->objcg)
+		return get_mem_cgroup_from_objcg(map->objcg);
+
+	return root_mem_cgroup;
+}
+
+static inline void bpf_map_put_memcg(struct mem_cgroup *memcg)
+{
+	mem_cgroup_put(memcg);
+}
+
+#else
+static inline struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
+{
+	return root_memcg();
+}
+
+static inline void bpf_map_put_memcg(struct mem_cgroup *memcg)
+{
+}
+#endif
+
 #endif /* _LINUX_BPF_H */
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4d31ce5..6040b5c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -361,6 +361,11 @@ struct mem_cgroup {
 
 extern struct mem_cgroup *root_mem_cgroup;
 
+static inline struct mem_cgroup *root_memcg(void)
+{
+	return root_mem_cgroup;
+}
+
 enum page_memcg_data_flags {
 	/* page->memcg_data is a pointer to an objcgs vector */
 	MEMCG_DATA_OBJCGS = (1UL << 0),
@@ -1147,6 +1152,11 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 #define MEM_CGROUP_ID_SHIFT	0
 #define MEM_CGROUP_ID_MAX	0
 
+static inline struct mem_cgroup *root_memcg(void)
+{
+	return NULL;
+}
+
 static inline struct mem_cgroup *folio_memcg(struct folio *folio)
 {
 	return NULL;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 7ce024c..eaf1906 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -433,19 +433,6 @@ static void bpf_map_release_memcg(struct bpf_map *map)
 		obj_cgroup_put(map->objcg);
 }
 
-static struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
-{
-	if (map->objcg)
-		return get_mem_cgroup_from_objcg(map->objcg);
-
-	return root_mem_cgroup;
-}
-
-static void bpf_map_put_memcg(struct mem_cgroup *memcg)
-{
-	mem_cgroup_put(memcg);
-}
-
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node)
 {
-- 
1.8.3.1

