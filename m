Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C57F598602
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245159AbiHROcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245482AbiHROcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:32:09 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A91AB9FBD;
        Thu, 18 Aug 2022 07:32:05 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id bh13so1436978pgb.4;
        Thu, 18 Aug 2022 07:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=JWj3ghaLi18D37Utgpu0sbreSBl9gVi+HG8XRXJ1k4E=;
        b=J/vjjRSdspqfz5QQqVSBxlG3cZRAEs5vE1YwK2jl25Xu07tjrYiNRrxlucPklmoR9x
         fBJUXAQ/LT3QR42GeO3UqrnqRp1RSdz+Swira1oRSwzSExCLMH+CuRCFEcRhvHrFW78v
         tng9ceDAB9ew2ydHzWZnZxvNtW2T8poiW5TUemW/mvFECm1CyXNstuUVpnJyVVd0JQ42
         YAHYbedJSYa9NAsf76auiydFa3uO2+AC0S3Uw0DnpnJXy7daYP7XQjFs//HOX0+9aAIU
         MXoS+DnB6GhRcPCFe5Xzh+tzSuYHsA0ibH1Y2orQGs1+05k1JUR/i+F72OtwdTOj61Wn
         9JGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=JWj3ghaLi18D37Utgpu0sbreSBl9gVi+HG8XRXJ1k4E=;
        b=5DDaom8KAe+7+ibm0ijLnlBdUuoOuD2VgJsB8JX27zLul91xb42RwkFCMeY2r1ht7g
         mRo/0GX9V5hyN0Rdeg/Z/wN+VXt+s642Xay+rFJhuU1BUBHBryY3gEGR81dYSyH4aytc
         j4THHWNzHWK1NVg+WGRlDzeHntT+FzlJaXF/EdgRi7f8GY6JJAuMQ28oULLLcHfGdQQP
         wH8sWwh6EpzoOG6cMOtvSysPoAXA3stN6W4Mdc863brLL+NFLOFKCiGi+P/MTmNcKsvX
         Y2en72ugmHvJ2vkFlJ0FOd7kj0OWSbCK5KJ/do8mx+H1ZRxJLJnVSkLhg54/oJ6Jmo2V
         JHzw==
X-Gm-Message-State: ACgBeo0duy+lhGOOty9033MBBVCWVUEMP2XYOMbZwTWEqQ7piqfptJ5S
        6ROtZ0/mfJnKxANl2yA+JBw=
X-Google-Smtp-Source: AA6agR6tlBl2i+jwjIYUJY+noBYDNAFEC5gq9HwJ1ZBb4KG+9KIyTOYDLgt8RG6tQbIPRV4tNA0M8g==
X-Received: by 2002:a63:e90c:0:b0:422:5ab9:99d6 with SMTP id i12-20020a63e90c000000b004225ab999d6mr2697130pgh.394.1660833125123;
        Thu, 18 Aug 2022 07:32:05 -0700 (PDT)
Received: from vultr.guest ([45.32.72.237])
        by smtp.gmail.com with ESMTPSA id h5-20020a63f905000000b003fdc16f5de2sm1379124pgi.15.2022.08.18.07.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 07:32:04 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 09/12] bpf: Use bpf_map_kvcalloc in bpf_local_storage
Date:   Thu, 18 Aug 2022 14:31:15 +0000
Message-Id: <20220818143118.17733-10-laoar.shao@gmail.com>
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

Introduce new helper bpf_map_kvcalloc() for this memory allocation.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h            |  8 ++++++++
 kernel/bpf/bpf_local_storage.c |  4 ++--
 kernel/bpf/syscall.c           | 15 +++++++++++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 066f351d..f95a2df 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1656,6 +1656,8 @@ int  generic_map_delete_batch(struct bpf_map *map,
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node);
 void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags);
+void *bpf_map_kvcalloc(struct bpf_map *map, size_t n, size_t size,
+		       gfp_t flags);
 void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 				    size_t align, gfp_t flags);
 #else
@@ -1672,6 +1674,12 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 	return kzalloc(size, flags);
 }
 
+static inline void *
+bpf_map_kvcalloc(struct bpf_map *map, size_t n, size_t size, gfp_t flags)
+{
+	return kvcalloc(n, size, flags);
+}
+
 static inline void __percpu *
 bpf_map_alloc_percpu(const struct bpf_map *map, size_t size, size_t align,
 		     gfp_t flags)
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 67ab249..71d5bf1 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -620,8 +620,8 @@ struct bpf_local_storage_map *bpf_local_storage_map_alloc(union bpf_attr *attr)
 	nbuckets = max_t(u32, 2, nbuckets);
 	smap->bucket_log = ilog2(nbuckets);
 
-	smap->buckets = kvcalloc(sizeof(*smap->buckets), nbuckets,
-				 GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
+	smap->buckets = bpf_map_kvcalloc(&smap->map, sizeof(*smap->buckets),
+					 nbuckets, GFP_USER | __GFP_NOWARN);
 	if (!smap->buckets) {
 		bpf_map_area_free(smap, &smap->map);
 		return ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 02ce7e9..2bd3bcf 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -489,6 +489,21 @@ void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags)
 	return ptr;
 }
 
+void *bpf_map_kvcalloc(struct bpf_map *map, size_t n, size_t size,
+		       gfp_t flags)
+{
+	struct mem_cgroup *memcg, *old_memcg;
+	void *ptr;
+
+	memcg = bpf_map_get_memcg(map);
+	old_memcg = set_active_memcg(memcg);
+	ptr = kvcalloc(n, size, flags | __GFP_ACCOUNT);
+	set_active_memcg(old_memcg);
+	bpf_map_put_memcg(memcg);
+
+	return ptr;
+}
+
 void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 				    size_t align, gfp_t flags)
 {
-- 
1.8.3.1

