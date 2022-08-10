Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2024C58EF2E
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbiHJPTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbiHJPS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:18:57 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC8C785A7;
        Wed, 10 Aug 2022 08:18:56 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id f28so14007183pfk.1;
        Wed, 10 Aug 2022 08:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=ZnOgYzkZxt9WSL7A8CyXVeY/jkqQttbvdChy+LL/htY=;
        b=RdpQ34Fx0/VGaTzpvtFOmvGQm29Ipm2n0EBOGETRHgm3A09EU/Tb8O7IXin+zzvmEY
         PO6QZnDySzHolaWexsbO1IBZsdUkmtWLOTzpu3gJ3yJCFgYjuMfkBHsY7LQ6Q320Ja9o
         kXdGZ17ElSsWPXl9XcLt+P87a7rEonVkYIttScWZ5tVpGLSgw4r3Q3B1IaydFzkvDmSy
         XHE8q5rZGfq60l/BXlweZ54O5esZbCdWdiB7dCUd2e2Ut+usySL9vix+BUwtqNnrxUGS
         RtsdZeWMXd91o9UeL3YQURQ+byH41xnKdPyiwplFrghjMbdaROGzdiU7YelzziDYMQcG
         N2Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=ZnOgYzkZxt9WSL7A8CyXVeY/jkqQttbvdChy+LL/htY=;
        b=wjRqb6adff9i/29ygRVt/7N2rUEjEZUnVjSfjfAD6stj7rSM3QGU78aEVd0yvYgPKD
         h8H1aFxncchyQEG4fe75jz8AFaqfSgFludJXLdwV+WdjAHx36CeRAPy5jqu8wIVxtJiJ
         MaL5DCQbWSZ4DZikBAr3DBZrRge3zd9knL4kkSMCJIUGBko1MKAoM6J+RBkgosVm2Aub
         j0qD46YeVyEAC2881Cq7PCaoHF/PJVVpJrnAvsc0Q/hMvrqPc/xUDPjIMpPbIr7fvpFQ
         ewPa1WQMz1BDccyQCCXVq8eBDLUgtt1r1Htgq11AIZqorfa0c2wC+MpaZLMJDaFiQy8K
         frCw==
X-Gm-Message-State: ACgBeo1cAJ+nihfGevomQpNOOqj9fcQnLEfGHuOCZ9ewPyttY6NpBp8a
        Tzkm+HGYWA3WHJdaL8tJwKo=
X-Google-Smtp-Source: AA6agR7T+mXtw1Yp9VTWXrsQVNEQkxkQW0ET8/XsMOMA6C0eOOdQPQx2ixg3OaV1FWIqCJc3hFW1fw==
X-Received: by 2002:a63:4c0d:0:b0:41a:77fe:2bc8 with SMTP id z13-20020a634c0d000000b0041a77fe2bc8mr23165203pga.82.1660144735958;
        Wed, 10 Aug 2022 08:18:55 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5c3e:5400:4ff:fe19:c3bc])
        by smtp.gmail.com with ESMTPSA id 85-20020a621558000000b0052b6ed5ca40sm2071935pfv.192.2022.08.10.08.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:18:55 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 06/15] bpf: Define bpf_map_{get,put}_memcg for !CONFIG_MEMCG_KMEM
Date:   Wed, 10 Aug 2022 15:18:31 +0000
Message-Id: <20220810151840.16394-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220810151840.16394-1-laoar.shao@gmail.com>
References: <20220810151840.16394-1-laoar.shao@gmail.com>
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
 include/linux/bpf.h        | 29 +++++++++++++++++++++++++++++
 include/linux/memcontrol.h | 10 ++++++++++
 kernel/bpf/syscall.c       | 16 ----------------
 3 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 20c26ae..fe3b565 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -27,6 +27,7 @@
 #include <linux/bpfptr.h>
 #include <linux/btf.h>
 #include <linux/rcupdate_trace.h>
+#include <linux/memcontrol.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -2571,4 +2572,32 @@ static inline void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype) {}
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
+	if (mem_cgroup_is_root(memcg))
+		return;
+
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
index 9ecead1..2f0a611 100644
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
@@ -1138,6 +1143,11 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
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
index 51ab8b1..19c3a81 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -433,22 +433,6 @@ static void bpf_map_release_memcg(struct bpf_map *map)
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
-	if (mem_cgroup_is_root(memcg))
-		return;
-
-	mem_cgroup_put(memcg);
-}
-
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node)
 {
-- 
1.8.3.1

