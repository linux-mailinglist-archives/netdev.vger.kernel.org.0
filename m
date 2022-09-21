Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A185C04FD
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 19:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiIURAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 13:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiIURAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 13:00:30 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668165E559;
        Wed, 21 Sep 2022 10:00:25 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id b21so6273089plz.7;
        Wed, 21 Sep 2022 10:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=86Fvvo7OHCl7WcRNmebHsC+UjHYkXcsdLASZGPmT+6Y=;
        b=Oq03LOMMFgsLNPoDix5xEX0x1FdtZZSvbxGuAYQ4ywUrDpKo4H2L8SHRgi01pOHZI8
         vLbrDrut8/Szy52XWOK7vDIIy3EtGQdHA9FBQF6IoiRRpX8JeE1QjlLCYNVvi6lw8Ykn
         HjT9HSRJkSulSHbK4VhpWAJX8JBZHYvYWRo6w656Tnag7jwqL4C95a5GOJtRqq2+wM/u
         DmXP37nSBNVxJ9+qKBqGAYksqrkHOPYy/iYLPse5wd3DfoXkxKfraUH5agPIJ3iXwvPX
         SO065VFBaLWKhXyu20BZbWN6OcjgtdsyQVLmCwBy8e3IlypTydv7n8tKF+YY2CWAU8iM
         FsAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=86Fvvo7OHCl7WcRNmebHsC+UjHYkXcsdLASZGPmT+6Y=;
        b=FzXBR0HT/iDHIx2t62ow5hz0THig8dfB5WRlaMsqqMFW4vSFXo2T0qdnGACYzfXUDW
         eg5b/VWmmxNfYhTnJMorKDzGIwMbSWpg/UZyWDQKTiR8B5OJ7XqzuRzbQNqnjkVT7+KD
         iRw3rwYw4GI/S6it67Qfujvl5h727Wz9E+ti8D+3PR25u1EQQaunlrKZNZ8OiBjh4Ntz
         59ZKBwV5ojesJ9fPOcPm0fKvI9flEkwYvJdK9J9C3LzqKmAOfxeUvRA41M6K6b0Iwkr5
         /DZGxnlzTQEP/Mkbj3Wdlh71RGT5RHBaBZqGK1Kgaz+2R1vQRzlhyAE1zwarM8vrPELF
         7w2A==
X-Gm-Message-State: ACrzQf0Yzr8TUWbEL1ExqDGPfchdNmAZJuDHYAU5wjfdVNWkqNdh4uuo
        G82F2p29hbrifsXCRGRMpB4=
X-Google-Smtp-Source: AMsMyM71OEz6FCG+w0oFSQ37gXstmmjQLulm8CE9fLNx0xAKUpv8TdHR3SpgktqUbz5zKADwFjdWDw==
X-Received: by 2002:a17:90b:1e49:b0:200:6d41:9662 with SMTP id pi9-20020a17090b1e4900b002006d419662mr10364539pjb.221.1663779625342;
        Wed, 21 Sep 2022 10:00:25 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:488e:5400:4ff:fe25:7db8])
        by smtp.gmail.com with ESMTPSA id mp4-20020a17090b190400b002006f8e7688sm2102495pjb.32.2022.09.21.10.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 10:00:24 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next 08/10] bpf: Use bpf_map_kvcalloc in bpf_local_storage
Date:   Wed, 21 Sep 2022 17:00:00 +0000
Message-Id: <20220921170002.29557-9-laoar.shao@gmail.com>
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

Introduce new helper bpf_map_kvcalloc() for this memory allocation.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h            |  8 ++++++++
 kernel/bpf/bpf_local_storage.c |  4 ++--
 kernel/bpf/syscall.c           | 15 +++++++++++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index eca1502..e1e5ada 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1717,6 +1717,8 @@ int  generic_map_delete_batch(struct bpf_map *map,
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node);
 void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags);
+void *bpf_map_kvcalloc(struct bpf_map *map, size_t n, size_t size,
+		       gfp_t flags);
 void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 				    size_t align, gfp_t flags);
 #else
@@ -1733,6 +1735,12 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
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
index 44498d7d..8a24828 100644
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
index 727c04c..6123c71 100644
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

