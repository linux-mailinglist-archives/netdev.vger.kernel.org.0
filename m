Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D82442585
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 03:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhKBCR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 22:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhKBCRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 22:17:23 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBFBC061714;
        Mon,  1 Nov 2021 19:14:49 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id y1so13600269plk.10;
        Mon, 01 Nov 2021 19:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n3iM6toE0BIl0nwK2d7kUxN8Y6KLsF/QyO7hct74M6U=;
        b=atU253/wEHO8xkOZY24KbBAIQULd9LCYfAK+qerzfNh2DsRAuFrZxs/O0M5PHwpX2K
         yITcx1Eyt/NfvG5RG/u1Ww+cwBrD614DrZfpjLymTpdXRdeL+Y6qAwk4gQAxXcv+fH8f
         p7e28TH0hmWouRzPgheXj7zsprcuzH+1JH7AOEBlPDNBCGnq3ZTWwmVawxaxkM0SgLDE
         fJhswN1lNV/7LY6tXEw/7hWw55ejGKLHCkr5hRa9F7S4BErJhb90Yv4s9EtrDOTE7ftv
         nfsmJcvezWmLFgkmijBE7Az76Wn9CHKjPLr46pM3Vc0EgMHV16aGrLO5NO77sS/7+yCI
         9Lrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n3iM6toE0BIl0nwK2d7kUxN8Y6KLsF/QyO7hct74M6U=;
        b=YyB0ugnuLvoUw/g8ISDHu+8JTeAY4htMWL+qqYpGzmy0OIejgjXKm1CdEEarzv8CyG
         Tb/pCoGxU5kWuD9KLye7kJus0C7e+xO39s1G6Bp1oz0pHV2X84Oc6cAgjkugsIinwpC+
         soQDD5G1ySNS2RWS0UGrAfJ3cZ3Y+N+XlnrYYI9ACdiGOlwkun3W3VH7ftZEOQkTdorW
         JUBRDYL7E6iovfZ7qq+gFNP+qinQHl86xsRnMo6b4u3V0U7bMAXSEjO1iaQTDhV+i7cq
         vYHd9+QLSiy2JcRyMEAxwGHl2SXhYZS1nJ6wVWahZVFTdbFS4hQdr7ggFHKAAwKTvTzv
         Nffw==
X-Gm-Message-State: AOAM530tVjq6FAX1EkAmkDmsLwnURBDvXHG4FFbxmgUH4czqSTI9Cq/8
        4EacGr8kE/USDlPYakly9Q==
X-Google-Smtp-Source: ABdhPJwlveRQxGPLKnmoR1IUUGZL85BZnzJHKEFW5pczjqb+o9aQm5H6GT4lyicqIdjgRVHw/7mooA==
X-Received: by 2002:a17:903:30cd:b0:141:c6dd:4d03 with SMTP id s13-20020a17090330cd00b00141c6dd4d03mr16385969plc.16.1635819289206;
        Mon, 01 Nov 2021 19:14:49 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j6sm14051446pgf.60.2021.11.01.19.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 19:14:48 -0700 (PDT)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Joe Burton <jevburton@google.com>
Subject: [RFC PATCH v3 1/3] bpf: Add map tracing functions and call sites
Date:   Tue,  2 Nov 2021 02:14:30 +0000
Message-Id: <20211102021432.2807760-2-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
In-Reply-To: <20211102021432.2807760-1-jevburton.kernel@gmail.com>
References: <20211102021432.2807760-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

Add two functions that fentry/fexit/fmod_ret programs can attach to:
	bpf_map_trace_update_elem
	bpf_map_trace_delete_elem
These functions have the same arguments as
bpf_map_{update,delete}_elem.

Invoke these functions from the following map types:
	BPF_MAP_TYPE_ARRAY
	BPF_MAP_TYPE_PERCPU_ARRAY
	BPF_MAP_TYPE_HASH
	BPF_MAP_TYPE_PERCPU_HASH
	BPF_MAP_TYPE_LRU_HASH
	BPF_MAP_TYPE_LRU_PERCPU_HASH

The only guarantee about these functions is that they are invoked
before the corresponding action occurs. Other conditions may prevent
the corresponding action from occurring after the function is invoked.

Signed-off-by: Joe Burton <jevburton@google.com>
---
 kernel/bpf/Makefile    |  2 +-
 kernel/bpf/arraymap.c  |  6 ++++++
 kernel/bpf/hashtab.c   | 25 +++++++++++++++++++++++++
 kernel/bpf/map_trace.c | 25 +++++++++++++++++++++++++
 kernel/bpf/map_trace.h | 18 ++++++++++++++++++
 5 files changed, 75 insertions(+), 1 deletion(-)
 create mode 100644 kernel/bpf/map_trace.c
 create mode 100644 kernel/bpf/map_trace.h

diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index cf6ca339f3cd..03ab5c058e73 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -9,7 +9,7 @@ CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
 obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o bloom_filter.o
 obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
-obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
+obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o map_trace.o
 obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
 obj-$(CONFIG_BPF_SYSCALL) += disasm.o
 obj-$(CONFIG_BPF_JIT) += trampoline.o
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 5e1ccfae916b..a0b4f1769e17 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -13,6 +13,7 @@
 #include <linux/rcupdate_trace.h>
 
 #include "map_in_map.h"
+#include "map_trace.h"
 
 #define ARRAY_CREATE_FLAG_MASK \
 	(BPF_F_NUMA_NODE | BPF_F_MMAPABLE | BPF_F_ACCESS_MASK | \
@@ -300,6 +301,7 @@ static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
 	u32 index = *(u32 *)key;
 	char *val;
+	int err;
 
 	if (unlikely((map_flags & ~BPF_F_LOCK) > BPF_EXIST))
 		/* unknown flags */
@@ -317,6 +319,10 @@ static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
 		     !map_value_has_spin_lock(map)))
 		return -EINVAL;
 
+	err = bpf_map_trace_update_elem(map, key, value, map_flags);
+	if (unlikely(err))
+		return err;
+
 	if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY) {
 		memcpy(this_cpu_ptr(array->pptrs[index & array->index_mask]),
 		       value, map->value_size);
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index d29af9988f37..c1816a615d82 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -13,6 +13,7 @@
 #include "percpu_freelist.h"
 #include "bpf_lru_list.h"
 #include "map_in_map.h"
+#include "map_trace.h"
 
 #define HTAB_CREATE_FLAG_MASK						\
 	(BPF_F_NO_PREALLOC | BPF_F_NO_COMMON_LRU | BPF_F_NUMA_NODE |	\
@@ -1041,6 +1042,10 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 	b = __select_bucket(htab, hash);
 	head = &b->head;
 
+	ret = bpf_map_trace_update_elem(map, key, value, map_flags);
+	if (unlikely(ret))
+		return ret;
+
 	if (unlikely(map_flags & BPF_F_LOCK)) {
 		if (unlikely(!map_value_has_spin_lock(map)))
 			return -EINVAL;
@@ -1133,6 +1138,10 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 		/* unknown flags */
 		return -EINVAL;
 
+	ret = bpf_map_trace_update_elem(map, key, value, map_flags);
+	if (unlikely(ret))
+		return ret;
+
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
@@ -1201,6 +1210,10 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 		/* unknown flags */
 		return -EINVAL;
 
+	ret = bpf_map_trace_update_elem(map, key, value, map_flags);
+	if (unlikely(ret))
+		return ret;
+
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
@@ -1256,6 +1269,10 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 		/* unknown flags */
 		return -EINVAL;
 
+	ret = bpf_map_trace_update_elem(map, key, value, map_flags);
+	if (unlikely(ret))
+		return ret;
+
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
@@ -1334,6 +1351,10 @@ static int htab_map_delete_elem(struct bpf_map *map, void *key)
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
+	ret = bpf_map_trace_delete_elem(map, key);
+	if (unlikely(ret))
+		return ret;
+
 	key_size = map->key_size;
 
 	hash = htab_map_hash(key, key_size, htab->hashrnd);
@@ -1370,6 +1391,10 @@ static int htab_lru_map_delete_elem(struct bpf_map *map, void *key)
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
+	ret = bpf_map_trace_delete_elem(map, key);
+	if (unlikely(ret))
+		return ret;
+
 	key_size = map->key_size;
 
 	hash = htab_map_hash(key, key_size, htab->hashrnd);
diff --git a/kernel/bpf/map_trace.c b/kernel/bpf/map_trace.c
new file mode 100644
index 000000000000..661b433f1451
--- /dev/null
+++ b/kernel/bpf/map_trace.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021 Google */
+#include "map_trace.h"
+
+noinline int bpf_map_trace_update_elem(struct bpf_map *map, void *key,
+				       void *value, u64 map_flags)
+{
+	/*
+	 * Noop side effect prevents call site from being optimized out.
+	 */
+	asm("");
+	return 0;
+}
+ALLOW_ERROR_INJECTION(bpf_map_trace_update_elem, ERRNO);
+
+noinline int bpf_map_trace_delete_elem(struct bpf_map *map, void *key)
+{
+	/*
+	 * Noop side effect prevents call site from being optimized out.
+	 */
+	asm("");
+	return 0;
+}
+ALLOW_ERROR_INJECTION(bpf_map_trace_delete_elem, ERRNO);
+
diff --git a/kernel/bpf/map_trace.h b/kernel/bpf/map_trace.h
new file mode 100644
index 000000000000..12356a2e1f9f
--- /dev/null
+++ b/kernel/bpf/map_trace.h
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021 Google */
+#pragma once
+
+#include <linux/bpf.h>
+
+/*
+ * Map tracing hooks. They are called from some, but not all, bpf map types.
+ * For those map types which call them, the only guarantee is that they are
+ * called before the corresponding action (bpf_map_update_elem, etc.) takes
+ * effect. Thus an fmod_ret program may use these hooks to prevent a map from
+ * being mutated via the corresponding helpers.
+ */
+noinline int bpf_map_trace_update_elem(struct bpf_map *map, void *key,
+				       void *value, u64 map_flags);
+
+noinline int bpf_map_trace_delete_elem(struct bpf_map *map, void *key);
+
-- 
2.33.1.1089.g2158813163f-goog

