Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A505C04EB
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 19:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiIURAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 13:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiIURAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 13:00:14 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AF9326F8;
        Wed, 21 Sep 2022 10:00:13 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id l65so6525947pfl.8;
        Wed, 21 Sep 2022 10:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=752ad/zAEG/6KeMcUBzMu9pWUcBuWGq8SqU7i/8Af4Q=;
        b=ctY4BKSR3+VtoeXZ+S4ZKkux+Q1OUenAzPs/7AL6PkxO8AdoE7qdlVVPfLccV3VoGA
         fHZflnl0sZwFqyysd0UZKhCzmt+/wYS0t05ggRvRDts2/dpIZJ6mHc3BJPK19l3Sj0Cw
         tMFIEPhAqCiYrNkv64e/hgvhLQHWezrMwPgTZgVuCeoTEzGPVWz+SdQDnju2+M4WKCwS
         p+p+vZOws/G2p3htlBoylLCkCVtvAVg15Hiyb5Kyl9sAPK7LrOoZFDbLgFuVc6IZG3aO
         GrezZHi0jb2uFI9OukNkeBf+0cQZflwvg3/Hb8uQniMWG7uHOX6Mvo+YDFxc3zZChLuL
         U8hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=752ad/zAEG/6KeMcUBzMu9pWUcBuWGq8SqU7i/8Af4Q=;
        b=U4hFR0oFd8frLZLkWRLPuljglNhdjPxNhYRTdNQRe7DevM+AYFSmfSRHfTNoaw901m
         +n79bgKOaePLtHipJ2knPAR/DSOvlu+spg9b9vzx/uA5112ZPbnmeVlkY9e37KJEVjMk
         XnnyZRYRshOPWXS+Xekz3xhhXOlwzlz5287MmQEARFuTvLSPd+KUdOFke3RqhHVhw6kF
         S3asG3q0umxltx0tWGaVHrxzIHcdurPR2kDvpQLXd6ThBcJBRn24exn2colwUt9QAcUO
         kyK9GYL/CpfnpOVWs8BqWbI2Qq6NFqLYTn8dArwizvX9Q98rdlw6tr0NKB8ZLPqOWUGK
         RJzQ==
X-Gm-Message-State: ACrzQf1Bc7odtKQpfyQ/1fSpu4zvsA1WA6VRuoi2P5Y7EFc6e12k1/rw
        jtBP1ST516BbRtPRvK+gFFM=
X-Google-Smtp-Source: AMsMyM76JQfNBEF0sdLp/8BhosBc7gQ/WRu0QQ4V812cMs1t+f3WWQaZdX9CGbTaNKYcAeTfOgJTig==
X-Received: by 2002:a63:6a09:0:b0:43a:20d4:85fe with SMTP id f9-20020a636a09000000b0043a20d485femr14037704pgc.625.1663779612667;
        Wed, 21 Sep 2022 10:00:12 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:488e:5400:4ff:fe25:7db8])
        by smtp.gmail.com with ESMTPSA id mp4-20020a17090b190400b002006f8e7688sm2102495pjb.32.2022.09.21.10.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 10:00:11 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next 02/10] bpf: Define bpf_map_{get,put}_memcg for !CONFIG_MEMCG_KMEM
Date:   Wed, 21 Sep 2022 16:59:54 +0000
Message-Id: <20220921170002.29557-3-laoar.shao@gmail.com>
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
index e0dbe0c..9ae1504 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -27,6 +27,7 @@
 #include <linux/bpfptr.h>
 #include <linux/btf.h>
 #include <linux/rcupdate_trace.h>
+#include <linux/memcontrol.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -2656,4 +2657,29 @@ static inline void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype) {}
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
index 6257867..d4a0ad3 100644
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
@@ -1158,6 +1163,11 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
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
index 70d5f70..574ddc3 100644
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

