Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB8458EF28
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbiHJPSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbiHJPSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:18:51 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185017822B;
        Wed, 10 Aug 2022 08:18:50 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id gj1so15112324pjb.0;
        Wed, 10 Aug 2022 08:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=HeJKAK+ncLW0QpMLm4IDJ4E+/yPQHa8h30kUW/Dj5Mc=;
        b=XtiAQU2TKOS4SFca4YmsB1FpaWpYM2uRBKRRXuKoFk8dmJQVocIHaqj3ViB9MwYNUP
         NBs9Rmgm25dnnSiiqjPij5pMXxWkvby2d/sDHS2LrRilzeYCq1WQrg6ulCSBcaqqH8nI
         ObPSlTLt7qhtGBFV6wm8DFWftcaVT0BgLNWu9ZnchCHKrai7RndnuJwifJfnWPyieeWV
         DX+GuMMHDCxpM1jo7NfqSnIFXUpfqlbCw1Q6dyqzLRwJy+8vVF8+SaPwsrvx52kKG4d9
         uj0X2EiNlDGextq0j9+3TYfBYgoAaVHcJRh3kMVYCui7IgZxR0Jzu/tPF3dY7BsQahJx
         FrXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=HeJKAK+ncLW0QpMLm4IDJ4E+/yPQHa8h30kUW/Dj5Mc=;
        b=ZGDNN+IfIszFe/8a58hV6PHQuENylGAFkodaBQTK9/e5V/dQpuBqwt+YKMDIOtk3yC
         vhkDV7CLHFizjiqbeoCN468kfVZQ4WpRfRMVGr8rbboEFBrIyNznTAUyiwFILfIs4jr8
         PjQn/zEs91GfaSH+r9FJbvOey8fj6hTS8KVWJ6hPX3fda4u04+UacElw18u003AeDNFH
         E8iWvyKIGJGgfTJosu/6bNlnbvoeVfcKkAClUF2fqIxH9ePR5e1pQ2K/izJfbJPZDqFT
         ZQagsF+hwNodWOBUBBTlwH38EZWkjes8PLPMkerKvdsGfjGchQWyNZAqRRxcsGfuYAvB
         Oh2Q==
X-Gm-Message-State: ACgBeo31OCI8oyg+MWnoNjuTL9qEgEo0QS9Yfhvs/jxiFsWQCrRre2Jy
        WwmiXXyhIufZ+1AyWzGFnDk=
X-Google-Smtp-Source: AA6agR7VMBFj+U1/fWThTC6WnTI2GpLS9sPyCIsBQYq/J78+ZCvY7sLBGx8dOi6DBEUy14frCPJ19g==
X-Received: by 2002:a17:902:e5c6:b0:16e:f3b6:ddb5 with SMTP id u6-20020a170902e5c600b0016ef3b6ddb5mr28394737plf.122.1660144729610;
        Wed, 10 Aug 2022 08:18:49 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5c3e:5400:4ff:fe19:c3bc])
        by smtp.gmail.com with ESMTPSA id 85-20020a621558000000b0052b6ed5ca40sm2071935pfv.192.2022.08.10.08.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:18:48 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 03/15] bpf: Make __GFP_NOWARN consistent in bpf map creation
Date:   Wed, 10 Aug 2022 15:18:28 +0000
Message-Id: <20220810151840.16394-4-laoar.shao@gmail.com>
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
index f4860ac..b25ca9d 100644
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
index a0e02b0..88feaa0 100644
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
index da75784..f1e5303 100644
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
index 49ef0ce..a64255e 100644
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
index bd09290..5a629a1 100644
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
index 3fb54fe..df8062c 100644
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
index 028813d..763d771 100644
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
1.8.3.1

