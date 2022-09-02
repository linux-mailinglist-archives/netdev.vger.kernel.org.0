Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784305AA5E9
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbiIBCbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbiIBCae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:30:34 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079D246DAE;
        Thu,  1 Sep 2022 19:30:30 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q9so762147pgq.6;
        Thu, 01 Sep 2022 19:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Y3yvFjkfqipQf2Go42LgC412HcIZU4AC9eg6yB/qVpc=;
        b=CypXU69T4bEXY+gyJWc7edwtpEaxlWD1Ugkcbwbvka6ieQ5OsoQOHYfhs+YODiohDf
         pNAR5QbYm6Zshluujo9IVXCkqVCjbXi44Xe0kptUT2lh7dy4LacuWeHyDLh9IvlhSymK
         taagPSh3KOQuxrfcWbeZNborlIBHsmdJBlsL2r0gmjjig0PrP0KsOpnrKnG/RcqbgF57
         kVlCz2rIVCZ5qsHx5yTbDgRpZa4+y45I6Adih3Pyju1d2Cj+o9e1zA1y324ULU+zZpRt
         4LrQju+8fICS/me/SAomVEpSeA7fGxqZ/gSEB+v/Y4U0cWI3zfWxEtAdiLZ5RKbbhEEr
         8Jhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Y3yvFjkfqipQf2Go42LgC412HcIZU4AC9eg6yB/qVpc=;
        b=sFLUTArnCcOqbjD9LynH7HXpIvvB0Xu+Mb87k6PDMlYBiibsfGh9OR3LriE7SUzzR7
         gCz9ERF1XgI8XyMm5lI3+/WCPuKNf+DjxTXmfCrbF1iWhkAHTU4waoz0Dlf4zTWXEXTC
         1oIMeoTU5Fymj+K3NZfUZc0w0HVnD4gnp75+ekqU9cG3hoySnsK1arIswf42rzBBAD28
         5/s/Fc1dXH04xGydvd7PbMCy2of66Vf86LSJS0IIkc2y03WovxfbkyuGBcYAKzbi0m1X
         DWuBC+GjEV/5thGc0AiPHd0+zjpzzYCuALQCtlwiF+wN3fa+F7EZP63n3kph1pEhkujk
         ZaTA==
X-Gm-Message-State: ACgBeo1cURP8I1SVoRq4VOII3/1jwlg4dZKzacRQeSH43eY2USVaHfIi
        fH1d1aNJyGaYgm/nXd2IPkU=
X-Google-Smtp-Source: AA6agR4wYf+PukhsNAMGFdVQd31/KYbkBHPDW2ZE/BYHzB0NpNVJUfvxe0otbZctReSshoToCfvzmA==
X-Received: by 2002:a63:485a:0:b0:41d:ed37:d937 with SMTP id x26-20020a63485a000000b0041ded37d937mr29497744pgk.336.1662085829772;
        Thu, 01 Sep 2022 19:30:29 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:50ea:5400:4ff:fe1f:fbe2])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902da8400b0017297a6b39dsm269719plx.265.2022.09.01.19.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 19:30:28 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 09/13] bpf: Use bpf_map_kvcalloc in bpf_local_storage
Date:   Fri,  2 Sep 2022 02:29:59 +0000
Message-Id: <20220902023003.47124-10-laoar.shao@gmail.com>
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

Introduce new helper bpf_map_kvcalloc() for this memory allocation.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h            |  8 ++++++++
 kernel/bpf/bpf_local_storage.c |  4 ++--
 kernel/bpf/syscall.c           | 15 +++++++++++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e8ac29f..52d8df0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1657,6 +1657,8 @@ int  generic_map_delete_batch(struct bpf_map *map,
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node);
 void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags);
+void *bpf_map_kvcalloc(struct bpf_map *map, size_t n, size_t size,
+		       gfp_t flags);
 void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 				    size_t align, gfp_t flags);
 #else
@@ -1673,6 +1675,12 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
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
index eefe590..034accd 100644
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

