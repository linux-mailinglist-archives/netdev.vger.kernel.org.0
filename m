Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A656585260
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbiG2PXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237297AbiG2PX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:23:29 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FB82AC4E;
        Fri, 29 Jul 2022 08:23:27 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id q22so1141338pfn.9;
        Fri, 29 Jul 2022 08:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fdHrruL4Gllw7kdBxmFxiRaESQjhqPF3nWXhKnbwkBA=;
        b=nqKMNPeCDL3zIJ0KAnu7Ubyg6aZdOBBTo2XarSeCo3GTOtWCGPCMrx+WurkaeOe+7j
         YJD4WZQjhd0Bgig+Sgyho5LrKggMOpX7oqYbSWjUVyGcBBIT0qHCrz32lfHWOfR3mwoe
         GbypGSPpwb6zZC6O7o5mFNhH9lZPQdl9kEGQ8w1IM76mHpvCZ/JKYqijeizlGjJFmOQt
         g7mbl1hbonIelI3QG/G2fsrz0d1+Ctwk5e6ld9CgJNzkGmzSGbyaoSqZyDBytdMt8Bbf
         gxB/4CQI0zb4pcE+RwIe03oyz+9i1OMmxBw9BmClkm8pZAz/xAulvKY1Jv+czNYtQ2vH
         20kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fdHrruL4Gllw7kdBxmFxiRaESQjhqPF3nWXhKnbwkBA=;
        b=70bImog9R82mNm1czSnq2gVa4O0c0acbiCzJc4gabfDGNcNaKBpTsskSt888FmjeMT
         CGeNlmrjzR5Zlip+nx+bzsTBPQ+kdTJYSevQx9dh5SHOkuLUfWUf/8q2gs2zp8bS2gm2
         IIWpRba5aCuPmTSzWrf5YoZTFtQUOtYMwkzNcoKUC/3kUfF+CBJuHRxMte9cWQ64Z/OW
         UZa09VrvzM8yEz/kRXYYxcC7MWDExgAbhZyy5lWu0D7QUjuQ02oenG2RKZ5+y/SabYIB
         H9fi3kligNMC4hAyPgyThXbsMae86X7n5H9QKymssKgxmJQtGbeRGte3q3UHL9Q3tEYt
         77fg==
X-Gm-Message-State: AJIora+FeM3SBbHuBTI5AITzlZ6eZto5R/iM/dxMEOYUjNlHeEWCannb
        nHpABf7QWCwXX8LyxOzZUH8=
X-Google-Smtp-Source: AGRyM1sA1x/xZBftR6UikLqMA4lb9NV10asAIBmoGRkZNnjIzlJO7tGpgNuEezQlbu9chOjyiKy4XQ==
X-Received: by 2002:a63:8bc8:0:b0:413:9952:6059 with SMTP id j191-20020a638bc8000000b0041399526059mr3293683pge.61.1659108207244;
        Fri, 29 Jul 2022 08:23:27 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:2912:5400:4ff:fe16:4344])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm3714219plm.89.2022.07.29.08.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:23:26 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 03/15] bpf: Make __GFP_NOWARN consistent in bpf map creation
Date:   Fri, 29 Jul 2022 15:23:04 +0000
Message-Id: <20220729152316.58205-4-laoar.shao@gmail.com>
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

Some of the bpf maps are created with __GFP_NOWARN, i.e. arraymap,
bloom_filter, bpf_local_storage, bpf_struct_ops, lpm_trie,
queue_stack_maps, reuseport_array, stackmap and xskmap, while others are
created without __GFP_NOWARN, i.e. cpumap, devmap, hashtab,
local_storage, offload, ringbuf and sock_map. But there are not key
differences between the creation of these maps. So let make this
allocation flag consistent in all bpf maps creation. Then we can use a
generic helper to alloc all bpf maps.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/cpumap.c        | 2 +-
 kernel/bpf/devmap.c        | 2 +-
 kernel/bpf/hashtab.c       | 2 +-
 kernel/bpf/local_storage.c | 4 ++--
 kernel/bpf/offload.c       | 2 +-
 kernel/bpf/ringbuf.c       | 2 +-
 net/core/sock_map.c        | 4 ++--
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index f4860ac756cd..b25ca9d603a6 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -97,7 +97,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 	    attr->map_flags & ~BPF_F_NUMA_NODE)
 		return ERR_PTR(-EINVAL);
 
-	cmap = kzalloc(sizeof(*cmap), GFP_USER | __GFP_ACCOUNT);
+	cmap = kzalloc(sizeof(*cmap), GFP_USER | __GFP_NOWARN |  __GFP_ACCOUNT);
 	if (!cmap)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index a0e02b009487..88feaa094de8 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -163,7 +163,7 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
 
-	dtab = kzalloc(sizeof(*dtab), GFP_USER | __GFP_ACCOUNT);
+	dtab = kzalloc(sizeof(*dtab), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!dtab)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index da7578426a46..f1e5303fe26e 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -495,7 +495,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	struct bpf_htab *htab;
 	int err, i;
 
-	htab = kzalloc(sizeof(*htab), GFP_USER | __GFP_ACCOUNT);
+	htab = kzalloc(sizeof(*htab), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!htab)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 49ef0ce040c7..a64255e20f87 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -313,8 +313,8 @@ static struct bpf_map *cgroup_storage_map_alloc(union bpf_attr *attr)
 		/* max_entries is not used and enforced to be 0 */
 		return ERR_PTR(-EINVAL);
 
-	map = kmalloc_node(sizeof(struct bpf_cgroup_storage_map),
-			   __GFP_ZERO | GFP_USER | __GFP_ACCOUNT, numa_node);
+	map = kzalloc_node(sizeof(struct bpf_cgroup_storage_map),
+			   GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT, numa_node);
 	if (!map)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index bd09290e3648..5a629a1b971c 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -372,7 +372,7 @@ struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
 	    attr->map_type != BPF_MAP_TYPE_HASH)
 		return ERR_PTR(-EINVAL);
 
-	offmap = kzalloc(sizeof(*offmap), GFP_USER);
+	offmap = kzalloc(sizeof(*offmap), GFP_USER | __GFP_NOWARN);
 	if (!offmap)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 3fb54feb39d4..df8062cb258c 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -164,7 +164,7 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-E2BIG);
 #endif
 
-	rb_map = kzalloc(sizeof(*rb_map), GFP_USER | __GFP_ACCOUNT);
+	rb_map = kzalloc(sizeof(*rb_map), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!rb_map)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 028813dfecb0..763d77162d0c 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -41,7 +41,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 	    attr->map_flags & ~SOCK_CREATE_FLAG_MASK)
 		return ERR_PTR(-EINVAL);
 
-	stab = kzalloc(sizeof(*stab), GFP_USER | __GFP_ACCOUNT);
+	stab = kzalloc(sizeof(*stab), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!stab)
 		return ERR_PTR(-ENOMEM);
 
@@ -1076,7 +1076,7 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
 	if (attr->key_size > MAX_BPF_STACK)
 		return ERR_PTR(-E2BIG);
 
-	htab = kzalloc(sizeof(*htab), GFP_USER | __GFP_ACCOUNT);
+	htab = kzalloc(sizeof(*htab), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!htab)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.17.1

