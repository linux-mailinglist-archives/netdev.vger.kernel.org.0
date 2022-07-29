Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C227558526E
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237632AbiG2PYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237486AbiG2PYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:24:01 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCABE83F12;
        Fri, 29 Jul 2022 08:23:44 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o14-20020a17090a4b4e00b001f2f2b61be5so5564432pjl.4;
        Fri, 29 Jul 2022 08:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z/tZbl83Zz5RN5ZtLnfBVgtLVcF0QM8whQKykqg7AFs=;
        b=Odn0BIB7DUWvvQYR+O232jYQnTPeV1M0T4uHezkKllPsrtVCWuN6AzQ9mmkzucvR59
         NX5o5yZSdNiIqSyZzPWhgHumWOjIJL+SKOtj8RlgwBtnTHMgLQhYipVDoMc5ijk8yzqj
         8VrpnerKwh4TL5/YY4y9Q3NIOzSrvZoT2ZrhHkofgszttpTtHSgak+49Gyl7kIyMrLo5
         g72j99GhmqgfeRYM72OCw+fhCkgTDLLIEUg36nSIcn58t1eyOlb4mYDULoC8UEz12ewD
         eC5PlwZh3NoqqPlJW8eZedRUR/d9FhBuaStavi861xJUBbKYcZykH8Kgu2gga/dsQNdg
         d2QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z/tZbl83Zz5RN5ZtLnfBVgtLVcF0QM8whQKykqg7AFs=;
        b=mJolBcdjYCKMO9S8+ee94/gUA/sT7Q3emhXiSY8qVQlYxIGXBDjQizGzyWMhsQP8XR
         jCvOcTqnQ/M5VLIKi71xKuSGMfhecNhk9B7MAp9FPR80v9HtEAPpU0+EvhZhPwxPKFEb
         Hh/sa7c4cs8tFdCpF+79GyaqYkjWXNPhk8sp6E5WuGHJgrrVcIZLMV7Z7gYG6FdyaE/Z
         N8TXHhxspQ7ZoOlz9Ki+F2Z2agRwIF9g9xD+BXncafKrZUCSixiV+6CMbTBWpg/Rx96Y
         OHi/g5LRBK/BzbGf0ECBaPpPeSi8j7/1GONZG4x65jc1fxvPF7E6GQ7QISOHdM6VKv0Q
         7Ehg==
X-Gm-Message-State: ACgBeo2xT3ocHtYvUUIEongj2/CILzOP8Y0jiRyCAD8zhFCNyHHK3eQI
        EDii+zJWVrEnsyRO4De41Sk=
X-Google-Smtp-Source: AA6agR7BcQrR/Mgac/I67FnC6AY4rn3lQ3Gnc2LbnKyRmp4ej47lpNm/jWkrdbAsyc1iR3dwwKRDNQ==
X-Received: by 2002:a17:902:8502:b0:16c:c5c5:a198 with SMTP id bj2-20020a170902850200b0016cc5c5a198mr4366289plb.88.1659108224367;
        Fri, 29 Jul 2022 08:23:44 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:2912:5400:4ff:fe16:4344])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm3714219plm.89.2022.07.29.08.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:23:43 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 11/15] bpf: Use bpf_map_kvcalloc in bpf_local_storage
Date:   Fri, 29 Jul 2022 15:23:12 +0000
Message-Id: <20220729152316.58205-12-laoar.shao@gmail.com>
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

Introduce new helper bpf_map_kvcalloc() for this memory allocation.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h            |  8 ++++++++
 kernel/bpf/bpf_local_storage.c |  4 ++--
 kernel/bpf/syscall.c           | 14 ++++++++++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4af72d2b6d73..605214fedd6d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1662,6 +1662,8 @@ struct bpf_prog *bpf_prog_get_curr_or_next(u32 *id);
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node);
 void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags);
+void *bpf_map_kvcalloc(struct bpf_map *map, size_t n, size_t size,
+		       gfp_t flags);
 void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 				    size_t align, gfp_t flags);
 #else
@@ -1678,6 +1680,12 @@ bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags)
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
index 0b50cb2e1d5b..3440135c3612 100644
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
 		bpf_map_container_free(smap);
 		return ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 5c13782839f3..f7210fa8c3be 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -455,6 +455,20 @@ void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags)
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
+
+	return ptr;
+}
+
 void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 				    size_t align, gfp_t flags)
 {
-- 
2.17.1

