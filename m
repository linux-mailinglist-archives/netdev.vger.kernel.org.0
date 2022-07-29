Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7B6585276
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237528AbiG2PYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237523AbiG2PYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:24:04 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39BA863CC;
        Fri, 29 Jul 2022 08:23:50 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id t2so4912177ply.2;
        Fri, 29 Jul 2022 08:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vYnEy8nKJWMROwA3MmvoCcmRLFYdVgR55TwlItJ2+GU=;
        b=Mkrl04Y5bR3wO1T3rRf4pjfQ6zW0Au+4rSRFHRqhmyLikvX+6Mhx2b47cSG2rgEaCW
         XPCcWAbWgbq/cxdH/xP1L7oWnHwfbF3+SmoqM4Y0/peTnhwEjmCVKDBmISQceZn7IKy9
         4lfLn41fhG7TI/xqGA3YRfVmEJm9MsyqXXoZx5tdaye0L+S/j5TIrnsFXlcDu95kwb41
         TGYhUGnPF1jX3PWn0L6lRgwISXK/D3AJat0IY1I5m3UfRy8hYosZNVkHJnVdWd63sEqv
         /nmRZxOjXyPAdnEfbjEmIkT4HHGTyNMGVyLGhY2EoIaQ7L/HS5meKFFLAGP+s+knjQHL
         iKAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vYnEy8nKJWMROwA3MmvoCcmRLFYdVgR55TwlItJ2+GU=;
        b=SxhEP5P4FcVx4c1QriUE5gx9fCwT/0GklRcq3J29TZxuPviszy3v6fJe+JQIMGIrXJ
         mwMrWhGziyzjxKWZIQf9cbhjHEq9yqZiLcJohWYM6pPXjTokuWPyqzUBQ27PLHan88pT
         Rzozn8EwYNAv4lNzBsLi0GJ0XuZ3M5tcb/6nncYosUV4DWVJMK6sZjMKXithhNRfl2LF
         9IJp0xeCtNpj9xYMkJG27vIP0FcDNTr/WnBF+DN8HQDGIaociSq5h6/dJxif5EnEVDFr
         Z7F4M2MXEpXRnf31nR5GBLwxoyw1XzX+Xhh0DeCAsSW+rBNx/yxDxznY2kGdCcSyyVFi
         yngQ==
X-Gm-Message-State: ACgBeo1Q/9nLMOqQI0tGVSUEoT5z8pQYb0oBqrnkgeKiZUqcj7x8Hg8h
        iQ4DlGYcj0GZZwJZ6O+1QhM=
X-Google-Smtp-Source: AA6agR5/5myi/pHhqOGN+umenk6xWAgqpqvDsItrls1rKZv/ueQaUf6O4B1azHULpfbNK/hwB1PyTg==
X-Received: by 2002:a17:902:d48a:b0:16d:30f4:ca5a with SMTP id c10-20020a170902d48a00b0016d30f4ca5amr4369743plg.50.1659108230655;
        Fri, 29 Jul 2022 08:23:50 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:2912:5400:4ff:fe16:4344])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm3714219plm.89.2022.07.29.08.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:23:49 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 14/15] bpf: Add new map flag BPF_F_SELECTABLE_MEMCG
Date:   Fri, 29 Jul 2022 15:23:15 +0000
Message-Id: <20220729152316.58205-15-laoar.shao@gmail.com>
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

Introduce new map flag BPF_F_SELECTABLE_MEMCG for map creation. This
flag is supported for all bpf maps. This is a preparation for followup
patch.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/uapi/linux/bpf.h       | 3 +++
 kernel/bpf/arraymap.c          | 2 +-
 kernel/bpf/bloom_filter.c      | 4 ++--
 kernel/bpf/bpf_local_storage.c | 3 ++-
 kernel/bpf/bpf_struct_ops.c    | 5 ++++-
 kernel/bpf/devmap.c            | 4 ++--
 kernel/bpf/hashtab.c           | 2 +-
 kernel/bpf/local_storage.c     | 2 +-
 kernel/bpf/queue_stack_maps.c  | 2 +-
 kernel/bpf/ringbuf.c           | 2 +-
 kernel/bpf/stackmap.c          | 2 +-
 net/core/sock_map.c            | 4 ++--
 tools/include/uapi/linux/bpf.h | 3 +++
 13 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 59a217ca2dfd..d5fc1ea70b59 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1227,6 +1227,9 @@ enum {
 
 /* Create a map that is suitable to be an inner map with dynamic max entries */
 	BPF_F_INNER_MAP		= (1U << 12),
+
+/* Selectable memcg */
+	BPF_F_SELECTABLE_MEMCG	= (1U << 13),
 };
 
 /* Flags for BPF_PROG_QUERY. */
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 883905c6c845..eb8deac529ac 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -17,7 +17,7 @@
 
 #define ARRAY_CREATE_FLAG_MASK \
 	(BPF_F_NUMA_NODE | BPF_F_MMAPABLE | BPF_F_ACCESS_MASK | \
-	 BPF_F_PRESERVE_ELEMS | BPF_F_INNER_MAP)
+	 BPF_F_PRESERVE_ELEMS | BPF_F_INNER_MAP | BPF_F_SELECTABLE_MEMCG)
 
 static void bpf_array_free_percpu(struct bpf_array *array)
 {
diff --git a/kernel/bpf/bloom_filter.c b/kernel/bpf/bloom_filter.c
index 9fe3c6774c40..3714aebc9ed6 100644
--- a/kernel/bpf/bloom_filter.c
+++ b/kernel/bpf/bloom_filter.c
@@ -9,8 +9,8 @@
 #include <linux/random.h>
 #include <linux/btf_ids.h>
 
-#define BLOOM_CREATE_FLAG_MASK \
-	(BPF_F_NUMA_NODE | BPF_F_ZERO_SEED | BPF_F_ACCESS_MASK)
+#define BLOOM_CREATE_FLAG_MASK	(BPF_F_NUMA_NODE |	\
+	BPF_F_ZERO_SEED | BPF_F_ACCESS_MASK | BPF_F_SELECTABLE_MEMCG)
 
 struct bpf_bloom_filter {
 	struct bpf_map map;
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index e12891dcf2a9..7798235f311e 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -15,7 +15,8 @@
 #include <linux/rcupdate_trace.h>
 #include <linux/rcupdate_wait.h>
 
-#define BPF_LOCAL_STORAGE_CREATE_FLAG_MASK (BPF_F_NO_PREALLOC | BPF_F_CLONE)
+#define BPF_LOCAL_STORAGE_CREATE_FLAG_MASK	\
+	(BPF_F_NO_PREALLOC | BPF_F_CLONE | BPF_F_SELECTABLE_MEMCG)
 
 static struct bpf_local_storage_map_bucket *
 select_bucket(struct bpf_local_storage_map *smap,
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 51b7ce9902a8..208d593e6a44 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -12,6 +12,8 @@
 #include <linux/mutex.h>
 #include <linux/btf_ids.h>
 
+#define STRUCT_OPS_CREATE_FLAG_MASK (BPF_F_SELECTABLE_MEMCG)
+
 enum bpf_struct_ops_state {
 	BPF_STRUCT_OPS_STATE_INIT,
 	BPF_STRUCT_OPS_STATE_INUSE,
@@ -586,7 +588,8 @@ static void bpf_struct_ops_map_free(struct bpf_map *map)
 static int bpf_struct_ops_map_alloc_check(union bpf_attr *attr)
 {
 	if (attr->key_size != sizeof(unsigned int) || attr->max_entries != 1 ||
-	    attr->map_flags || !attr->btf_vmlinux_value_type_id)
+	    (attr->map_flags & ~STRUCT_OPS_CREATE_FLAG_MASK) ||
+	    !attr->btf_vmlinux_value_type_id)
 		return -EINVAL;
 	return 0;
 }
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 11c7b8411b03..52858963373c 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -50,8 +50,8 @@
 #include <trace/events/xdp.h>
 #include <linux/btf_ids.h>
 
-#define DEV_CREATE_FLAG_MASK \
-	(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY)
+#define DEV_CREATE_FLAG_MASK (BPF_F_NUMA_NODE |		\
+	BPF_F_RDONLY | BPF_F_WRONLY | BPF_F_SELECTABLE_MEMCG)
 
 struct xdp_dev_bulk_queue {
 	struct xdp_frame *q[DEV_MAP_BULK_SIZE];
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 3cb9486eb313..532c8ee89d58 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -17,7 +17,7 @@
 
 #define HTAB_CREATE_FLAG_MASK						\
 	(BPF_F_NO_PREALLOC | BPF_F_NO_COMMON_LRU | BPF_F_NUMA_NODE |	\
-	 BPF_F_ACCESS_MASK | BPF_F_ZERO_SEED)
+	 BPF_F_ACCESS_MASK | BPF_F_ZERO_SEED | BPF_F_SELECTABLE_MEMCG)
 
 #define BATCH_OPS(_name)			\
 	.map_lookup_batch =			\
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index b2bd031aba79..009d6f43a099 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -16,7 +16,7 @@
 #include "../cgroup/cgroup-internal.h"
 
 #define LOCAL_STORAGE_CREATE_FLAG_MASK					\
-	(BPF_F_NUMA_NODE | BPF_F_ACCESS_MASK)
+	(BPF_F_NUMA_NODE | BPF_F_ACCESS_MASK | BPF_F_SELECTABLE_MEMCG)
 
 struct bpf_cgroup_storage_map {
 	struct bpf_map map;
diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index 9425df0695ac..c4aab43198ad 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -12,7 +12,7 @@
 #include "percpu_freelist.h"
 
 #define QUEUE_STACK_CREATE_FLAG_MASK \
-	(BPF_F_NUMA_NODE | BPF_F_ACCESS_MASK)
+	(BPF_F_NUMA_NODE | BPF_F_ACCESS_MASK | BPF_F_SELECTABLE_MEMCG)
 
 struct bpf_queue_stack {
 	struct bpf_map map;
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 3be472fd55da..53a7eb8db257 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -12,7 +12,7 @@
 #include <uapi/linux/btf.h>
 #include <linux/btf_ids.h>
 
-#define RINGBUF_CREATE_FLAG_MASK (BPF_F_NUMA_NODE)
+#define RINGBUF_CREATE_FLAG_MASK (BPF_F_NUMA_NODE | BPF_F_SELECTABLE_MEMCG)
 
 /* non-mmap()'able part of bpf_ringbuf (everything up to consumer page) */
 #define RINGBUF_PGOFF \
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index c952c7547279..007b10d2da7d 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -14,7 +14,7 @@
 
 #define STACK_CREATE_FLAG_MASK					\
 	(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY |	\
-	 BPF_F_STACK_BUILD_ID)
+	 BPF_F_STACK_BUILD_ID | BPF_F_SELECTABLE_MEMCG)
 
 struct stack_map_bucket {
 	struct pcpu_freelist_node fnode;
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 4d9b730aa27f..0310b00e19b8 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -21,8 +21,8 @@ struct bpf_stab {
 	raw_spinlock_t lock;
 };
 
-#define SOCK_CREATE_FLAG_MASK				\
-	(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY)
+#define SOCK_CREATE_FLAG_MASK (BPF_F_NUMA_NODE |	\
+	BPF_F_RDONLY | BPF_F_WRONLY | BPF_F_SELECTABLE_MEMCG)
 
 static int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
 				struct bpf_prog *old, u32 which);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 59a217ca2dfd..d5fc1ea70b59 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1227,6 +1227,9 @@ enum {
 
 /* Create a map that is suitable to be an inner map with dynamic max entries */
 	BPF_F_INNER_MAP		= (1U << 12),
+
+/* Selectable memcg */
+	BPF_F_SELECTABLE_MEMCG	= (1U << 13),
 };
 
 /* Flags for BPF_PROG_QUERY. */
-- 
2.17.1

