Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7065858EF39
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbiHJPTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbiHJPTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:19:11 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D8578BD8;
        Wed, 10 Aug 2022 08:19:08 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id q19so13993876pfg.8;
        Wed, 10 Aug 2022 08:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=L21h4+LhKzVbOgymwJqIY9/nxSMZ9tbw+WqBvebpAHo=;
        b=KeXYWGzf22r6tp6AGlXKgfkYSLL92qFn/v0xzLOawzsAZ7dKaX1F920h1kIiDeKqy0
         tIHMdiZFS147YlQvLzXvGD77IukqdqITM58J2OHO510EF6687XIPaU1ye2Teqep5Rcmj
         2wR4anFZfqV3I/hi2S8GmdWxvXYkIQKh4Assq6E3oFz8i40BkflACjOeQKb6uw/dppMd
         KicCGJhhWGMlTNJUfj25v8cpn/3/8GdksrHDBln/s9HeC2TLRj7cvg11mtdNrvVrLQtm
         FYJtK1KD+fEhK0mwIqsAjP9QcBv4TY3vPmhmiMxdZ2nooUKbEuseAnZ20wQYspkh1wNG
         YYqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=L21h4+LhKzVbOgymwJqIY9/nxSMZ9tbw+WqBvebpAHo=;
        b=UH8eRhqdIsbukrN6eglLHA1hrbOM2/TkMf6W2cRZWObhYf6H5D5Pev6DSk8A7wfZlS
         Qark2Q82tbSobwQsjX+UZIBrv+SLsNGFOcwxcPdyw8U0sVTUcITkL36ILoAU6jaKZeZ1
         /oAIvwu5ldv7dZnyFijrUCH4cGlraIFDzkyMfTAfXsbtR63XxMaUP1lZukLy+AHIZo2d
         SkhyPcecxxktnIsRzM0WgxcfpaAOwTeNeNBbduVH1pD3tUfrDgXNE8QOOkwNB5h9g/8v
         rOWgQNNs8p/Z/C7LtzGdxRk7jcpfUitutOjOQLSvDGbmdV4B6Y7HcMYoaEo/uS+ph1yG
         0I+g==
X-Gm-Message-State: ACgBeo1EA39kOAi6Q3xBSCXnr/6Hz3yUfPuIxis4Eghzi3JrGbinVuhr
        xnqajP+divNxvqlcd4uQvpw=
X-Google-Smtp-Source: AA6agR4Qm1piYZUT+NZjX322Lv/JWEoiqSZroQJTNfAvHnmXAGUoEZ2XBS2sQ0tRlxEBO/vP2ie4Ag==
X-Received: by 2002:a05:6a00:1706:b0:52f:6f75:991b with SMTP id h6-20020a056a00170600b0052f6f75991bmr12147620pfc.34.1660144747830;
        Wed, 10 Aug 2022 08:19:07 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5c3e:5400:4ff:fe19:c3bc])
        by smtp.gmail.com with ESMTPSA id 85-20020a621558000000b0052b6ed5ca40sm2071935pfv.192.2022.08.10.08.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:19:07 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 12/15] bpf: Use bpf_map_kvcalloc in bpf_local_storage
Date:   Wed, 10 Aug 2022 15:18:37 +0000
Message-Id: <20220810151840.16394-13-laoar.shao@gmail.com>
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

Introduce new helper bpf_map_kvcalloc() for this memory allocation.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h            |  8 ++++++++
 kernel/bpf/bpf_local_storage.c |  4 ++--
 kernel/bpf/syscall.c           | 15 +++++++++++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d7485b7..ebb6ed4 100644
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

