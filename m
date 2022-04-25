Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA3550E1E4
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 15:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242143AbiDYNhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 09:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242195AbiDYNhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 09:37:32 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46761CE3;
        Mon, 25 Apr 2022 06:34:27 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q8so3906941plx.3;
        Mon, 25 Apr 2022 06:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mErEKkzZI10yLuV6u1gA6JMsJPbNJHxahc/oDXQAO84=;
        b=ZwEnmcQJkEhJ9SFEpNK1hzsH4N1Vha6I1oJ+BvBAypFO8kRO0vs+h1n06JP4wX/FCD
         QZr7MC0QOYNzLI7uL3MEYFdF10EREWtTjbd+WY1B0DkDjhEinQ35YxonM/HK/tXsLaOa
         BBt41S/Rk8AcjKMul1we7tPVeafs8SMrjj4xf5hKGonYLln5sy5/q2pvvSNTOmIAXzz6
         hciInrbNUhGORi/mrjeYyHgMTV0SSzDiJIdLWsd7HIjuXfTpjjRlcR2jPtNk8DXLldwD
         w5ohHoABqb8+g+uHGwyt4YN8r755LoUN7z+E9xTO334b7gYlgc4NQfvcDVopmv0iqUPq
         fK9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mErEKkzZI10yLuV6u1gA6JMsJPbNJHxahc/oDXQAO84=;
        b=dGk7Gvb5p3wuMfIfWs3b8F4jkpCPivydWGqXVZZF/ePD6WibYBH3M4walI1B1W3MZ2
         UBvstsgxupzwXkr/mKPTbxBnxvJm8IRKHNbfGlm97j55bf5V98uLpNfF3gX2224jtGB0
         8qXp++ZUcXnotV2YwfbVfqigNPelSpYq3hgVoYboo0yV9MMAWXmiNIXWUHHze43mYSFu
         p+4qDnXw8d7eJ6KXAEE5+Mvw900QWE1vHGL8DDlsPtzu0CcOhwVDOzZhkrl2CKuv3ULY
         MBSEjUHFRjGC1q92CysKdKwF2V6HsgSW7HT1RXaKf90c6OYGTrp1wrD0sZ6IZuNZGBFH
         g+og==
X-Gm-Message-State: AOAM532SbAFO8WEbRvFo01+AmxIUVjriwJQN0ldXJq4nUtv+3E8VdLY/
        688LUCAvDJXohb1N0HB0J3Q=
X-Google-Smtp-Source: ABdhPJwzFl9j/jG+SQCksXDQ7aUz+16A3ccTVp4Mxi8Gz/ySTZO87w2XkRCyY7s+OeSmhvhsO26frQ==
X-Received: by 2002:a17:902:7c13:b0:156:ca91:877f with SMTP id x19-20020a1709027c1300b00156ca91877fmr18021104pll.15.1650893666626;
        Mon, 25 Apr 2022 06:34:26 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id y68-20020a623247000000b0050acc1def3csm11776826pfy.203.2022.04.25.06.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 06:34:25 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     ast@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, benbjiang@tencent.com, flyingpeng@tencent.com,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        mengensun@tencent.com, dongli.zhang@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH bpf-next v2] bpf: compute map_btf_id during build time
Date:   Mon, 25 Apr 2022 21:32:47 +0800
Message-Id: <20220425133247.180893-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

For now, the field 'map_btf_id' in 'struct bpf_map_ops' for all map
types are computed during vmlinux-btf init:

  btf_parse_vmlinux() -> btf_vmlinux_map_ids_init()

It will lookup the btf_type according to the 'map_btf_name' field in
'struct bpf_map_ops'. This process can be done during build time,
thanks to Jiri's resolve_btfids.

selftest of map_ptr has passed:

  $96 map_ptr:OK
  Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reported-by: kernel test robot <lkp@intel.com>
---
v2:
- remove unused btf_vmlinux_map_ops
---
 include/linux/bpf.h            |  3 +--
 kernel/bpf/arraymap.c          | 26 +++++++---------------
 kernel/bpf/bloom_filter.c      |  6 ++---
 kernel/bpf/bpf_inode_storage.c |  6 ++---
 kernel/bpf/bpf_struct_ops.c    |  6 ++---
 kernel/bpf/bpf_task_storage.c  |  5 ++---
 kernel/bpf/btf.c               | 40 ----------------------------------
 kernel/bpf/cpumap.c            |  6 ++---
 kernel/bpf/devmap.c            | 10 ++++-----
 kernel/bpf/hashtab.c           | 22 ++++++-------------
 kernel/bpf/local_storage.c     |  7 +++---
 kernel/bpf/lpm_trie.c          |  6 ++---
 kernel/bpf/queue_stack_maps.c  | 10 ++++-----
 kernel/bpf/reuseport_array.c   |  6 ++---
 kernel/bpf/ringbuf.c           |  6 ++---
 kernel/bpf/stackmap.c          |  5 ++---
 net/core/bpf_sk_storage.c      |  5 ++---
 net/core/sock_map.c            | 10 ++++-----
 net/xdp/xskmap.c               |  6 ++---
 19 files changed, 62 insertions(+), 129 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index bdb5298735ce..8383e756188e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -147,8 +147,7 @@ struct bpf_map_ops {
 				     bpf_callback_t callback_fn,
 				     void *callback_ctx, u64 flags);
 
-	/* BTF name and id of struct allocated by map_alloc */
-	const char * const map_btf_name;
+	/* BTF id of struct allocated by map_alloc */
 	int *map_btf_id;
 
 	/* bpf_iter info used to open a seq_file */
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 7f145aefbff8..75f256f3f9ec 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -11,6 +11,7 @@
 #include <linux/perf_event.h>
 #include <uapi/linux/btf.h>
 #include <linux/rcupdate_trace.h>
+#include <linux/btf_ids.h>
 
 #include "map_in_map.h"
 
@@ -680,7 +681,7 @@ static int bpf_for_each_array_elem(struct bpf_map *map, bpf_callback_t callback_
 	return num_elems;
 }
 
-static int array_map_btf_id;
+BTF_ID_LIST_SINGLE(array_map_btf_ids, struct, bpf_array)
 const struct bpf_map_ops array_map_ops = {
 	.map_meta_equal = array_map_meta_equal,
 	.map_alloc_check = array_map_alloc_check,
@@ -701,12 +702,10 @@ const struct bpf_map_ops array_map_ops = {
 	.map_update_batch = generic_map_update_batch,
 	.map_set_for_each_callback_args = map_set_for_each_callback_args,
 	.map_for_each_callback = bpf_for_each_array_elem,
-	.map_btf_name = "bpf_array",
-	.map_btf_id = &array_map_btf_id,
+	.map_btf_id = &array_map_btf_ids[0],
 	.iter_seq_info = &iter_seq_info,
 };
 
-static int percpu_array_map_btf_id;
 const struct bpf_map_ops percpu_array_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc_check = array_map_alloc_check,
@@ -722,8 +721,7 @@ const struct bpf_map_ops percpu_array_map_ops = {
 	.map_update_batch = generic_map_update_batch,
 	.map_set_for_each_callback_args = map_set_for_each_callback_args,
 	.map_for_each_callback = bpf_for_each_array_elem,
-	.map_btf_name = "bpf_array",
-	.map_btf_id = &percpu_array_map_btf_id,
+	.map_btf_id = &array_map_btf_ids[0],
 	.iter_seq_info = &iter_seq_info,
 };
 
@@ -1102,7 +1100,6 @@ static void prog_array_map_free(struct bpf_map *map)
  * Thus, prog_array_map cannot be used as an inner_map
  * and map_meta_equal is not implemented.
  */
-static int prog_array_map_btf_id;
 const struct bpf_map_ops prog_array_map_ops = {
 	.map_alloc_check = fd_array_map_alloc_check,
 	.map_alloc = prog_array_map_alloc,
@@ -1118,8 +1115,7 @@ const struct bpf_map_ops prog_array_map_ops = {
 	.map_fd_sys_lookup_elem = prog_fd_array_sys_lookup_elem,
 	.map_release_uref = prog_array_map_clear,
 	.map_seq_show_elem = prog_array_map_seq_show_elem,
-	.map_btf_name = "bpf_array",
-	.map_btf_id = &prog_array_map_btf_id,
+	.map_btf_id = &array_map_btf_ids[0],
 };
 
 static struct bpf_event_entry *bpf_event_entry_gen(struct file *perf_file,
@@ -1208,7 +1204,6 @@ static void perf_event_fd_array_map_free(struct bpf_map *map)
 	fd_array_map_free(map);
 }
 
-static int perf_event_array_map_btf_id;
 const struct bpf_map_ops perf_event_array_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc_check = fd_array_map_alloc_check,
@@ -1221,8 +1216,7 @@ const struct bpf_map_ops perf_event_array_map_ops = {
 	.map_fd_put_ptr = perf_event_fd_array_put_ptr,
 	.map_release = perf_event_fd_array_release,
 	.map_check_btf = map_check_no_btf,
-	.map_btf_name = "bpf_array",
-	.map_btf_id = &perf_event_array_map_btf_id,
+	.map_btf_id = &array_map_btf_ids[0],
 };
 
 #ifdef CONFIG_CGROUPS
@@ -1245,7 +1239,6 @@ static void cgroup_fd_array_free(struct bpf_map *map)
 	fd_array_map_free(map);
 }
 
-static int cgroup_array_map_btf_id;
 const struct bpf_map_ops cgroup_array_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc_check = fd_array_map_alloc_check,
@@ -1257,8 +1250,7 @@ const struct bpf_map_ops cgroup_array_map_ops = {
 	.map_fd_get_ptr = cgroup_fd_array_get_ptr,
 	.map_fd_put_ptr = cgroup_fd_array_put_ptr,
 	.map_check_btf = map_check_no_btf,
-	.map_btf_name = "bpf_array",
-	.map_btf_id = &cgroup_array_map_btf_id,
+	.map_btf_id = &array_map_btf_ids[0],
 };
 #endif
 
@@ -1332,7 +1324,6 @@ static int array_of_map_gen_lookup(struct bpf_map *map,
 	return insn - insn_buf;
 }
 
-static int array_of_maps_map_btf_id;
 const struct bpf_map_ops array_of_maps_map_ops = {
 	.map_alloc_check = fd_array_map_alloc_check,
 	.map_alloc = array_of_map_alloc,
@@ -1345,6 +1336,5 @@ const struct bpf_map_ops array_of_maps_map_ops = {
 	.map_fd_sys_lookup_elem = bpf_map_fd_sys_lookup_elem,
 	.map_gen_lookup = array_of_map_gen_lookup,
 	.map_check_btf = map_check_no_btf,
-	.map_btf_name = "bpf_array",
-	.map_btf_id = &array_of_maps_map_btf_id,
+	.map_btf_id = &array_map_btf_ids[0],
 };
diff --git a/kernel/bpf/bloom_filter.c b/kernel/bpf/bloom_filter.c
index b141a1346f72..b9ea539a5561 100644
--- a/kernel/bpf/bloom_filter.c
+++ b/kernel/bpf/bloom_filter.c
@@ -7,6 +7,7 @@
 #include <linux/err.h>
 #include <linux/jhash.h>
 #include <linux/random.h>
+#include <linux/btf_ids.h>
 
 #define BLOOM_CREATE_FLAG_MASK \
 	(BPF_F_NUMA_NODE | BPF_F_ZERO_SEED | BPF_F_ACCESS_MASK)
@@ -192,7 +193,7 @@ static int bloom_map_check_btf(const struct bpf_map *map,
 	return btf_type_is_void(key_type) ? 0 : -EINVAL;
 }
 
-static int bpf_bloom_map_btf_id;
+BTF_ID_LIST_SINGLE(bpf_bloom_map_btf_ids, struct, bpf_bloom_filter)
 const struct bpf_map_ops bloom_filter_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc = bloom_map_alloc,
@@ -205,6 +206,5 @@ const struct bpf_map_ops bloom_filter_map_ops = {
 	.map_update_elem = bloom_map_update_elem,
 	.map_delete_elem = bloom_map_delete_elem,
 	.map_check_btf = bloom_map_check_btf,
-	.map_btf_name = "bpf_bloom_filter",
-	.map_btf_id = &bpf_bloom_map_btf_id,
+	.map_btf_id = &bpf_bloom_map_btf_ids[0],
 };
diff --git a/kernel/bpf/bpf_inode_storage.c b/kernel/bpf/bpf_inode_storage.c
index 96be8d518885..703bda2eda3c 100644
--- a/kernel/bpf/bpf_inode_storage.c
+++ b/kernel/bpf/bpf_inode_storage.c
@@ -245,7 +245,8 @@ static void inode_storage_map_free(struct bpf_map *map)
 	bpf_local_storage_map_free(smap, NULL);
 }
 
-static int inode_storage_map_btf_id;
+BTF_ID_LIST_SINGLE(inode_storage_map_btf_ids, struct,
+		   bpf_local_storage_map)
 const struct bpf_map_ops inode_storage_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc_check = bpf_local_storage_map_alloc_check,
@@ -256,8 +257,7 @@ const struct bpf_map_ops inode_storage_map_ops = {
 	.map_update_elem = bpf_fd_inode_storage_update_elem,
 	.map_delete_elem = bpf_fd_inode_storage_delete_elem,
 	.map_check_btf = bpf_local_storage_map_check_btf,
-	.map_btf_name = "bpf_local_storage_map",
-	.map_btf_id = &inode_storage_map_btf_id,
+	.map_btf_id = &inode_storage_map_btf_ids[0],
 	.map_owner_storage_ptr = inode_storage_ptr,
 };
 
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 21069dbe9138..f29619dfa72d 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -10,6 +10,7 @@
 #include <linux/seq_file.h>
 #include <linux/refcount.h>
 #include <linux/mutex.h>
+#include <linux/btf_ids.h>
 
 enum bpf_struct_ops_state {
 	BPF_STRUCT_OPS_STATE_INIT,
@@ -612,7 +613,7 @@ static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
 	return map;
 }
 
-static int bpf_struct_ops_map_btf_id;
+BTF_ID_LIST_SINGLE(bpf_struct_ops_map_btf_ids, struct, bpf_struct_ops_map)
 const struct bpf_map_ops bpf_struct_ops_map_ops = {
 	.map_alloc_check = bpf_struct_ops_map_alloc_check,
 	.map_alloc = bpf_struct_ops_map_alloc,
@@ -622,8 +623,7 @@ const struct bpf_map_ops bpf_struct_ops_map_ops = {
 	.map_delete_elem = bpf_struct_ops_map_delete_elem,
 	.map_update_elem = bpf_struct_ops_map_update_elem,
 	.map_seq_show_elem = bpf_struct_ops_map_seq_show_elem,
-	.map_btf_name = "bpf_struct_ops_map",
-	.map_btf_id = &bpf_struct_ops_map_btf_id,
+	.map_btf_id = &bpf_struct_ops_map_btf_ids[0],
 };
 
 /* "const void *" because some subsystem is
diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.c
index 6638a0ecc3d2..e8106df3a09e 100644
--- a/kernel/bpf/bpf_task_storage.c
+++ b/kernel/bpf/bpf_task_storage.c
@@ -307,7 +307,7 @@ static void task_storage_map_free(struct bpf_map *map)
 	bpf_local_storage_map_free(smap, &bpf_task_storage_busy);
 }
 
-static int task_storage_map_btf_id;
+BTF_ID_LIST_SINGLE(task_storage_map_btf_ids, struct, bpf_local_storage_map)
 const struct bpf_map_ops task_storage_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc_check = bpf_local_storage_map_alloc_check,
@@ -318,8 +318,7 @@ const struct bpf_map_ops task_storage_map_ops = {
 	.map_update_elem = bpf_pid_task_storage_update_elem,
 	.map_delete_elem = bpf_pid_task_storage_delete_elem,
 	.map_check_btf = bpf_local_storage_map_check_btf,
-	.map_btf_name = "bpf_local_storage_map",
-	.map_btf_id = &task_storage_map_btf_id,
+	.map_btf_id = &task_storage_map_btf_ids[0],
 	.map_owner_storage_ptr = task_storage_ptr,
 };
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 0918a39279f6..6bb04e5c1da7 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4716,41 +4716,6 @@ btf_get_prog_ctx_type(struct bpf_verifier_log *log, const struct btf *btf,
 	return ctx_type;
 }
 
-static const struct bpf_map_ops * const btf_vmlinux_map_ops[] = {
-#define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type)
-#define BPF_LINK_TYPE(_id, _name)
-#define BPF_MAP_TYPE(_id, _ops) \
-	[_id] = &_ops,
-#include <linux/bpf_types.h>
-#undef BPF_PROG_TYPE
-#undef BPF_LINK_TYPE
-#undef BPF_MAP_TYPE
-};
-
-static int btf_vmlinux_map_ids_init(const struct btf *btf,
-				    struct bpf_verifier_log *log)
-{
-	const struct bpf_map_ops *ops;
-	int i, btf_id;
-
-	for (i = 0; i < ARRAY_SIZE(btf_vmlinux_map_ops); ++i) {
-		ops = btf_vmlinux_map_ops[i];
-		if (!ops || (!ops->map_btf_name && !ops->map_btf_id))
-			continue;
-		if (!ops->map_btf_name || !ops->map_btf_id) {
-			bpf_log(log, "map type %d is misconfigured\n", i);
-			return -EINVAL;
-		}
-		btf_id = btf_find_by_name_kind(btf, ops->map_btf_name,
-					       BTF_KIND_STRUCT);
-		if (btf_id < 0)
-			return btf_id;
-		*ops->map_btf_id = btf_id;
-	}
-
-	return 0;
-}
-
 static int btf_translate_to_vmlinux(struct bpf_verifier_log *log,
 				     struct btf *btf,
 				     const struct btf_type *t,
@@ -4812,11 +4777,6 @@ struct btf *btf_parse_vmlinux(void)
 	/* btf_parse_vmlinux() runs under bpf_verifier_lock */
 	bpf_ctx_convert.t = btf_type_by_id(btf, bpf_ctx_convert_btf_id[0]);
 
-	/* find bpf map structs for map_ptr access checking */
-	err = btf_vmlinux_map_ids_init(btf, log);
-	if (err < 0)
-		goto errout;
-
 	bpf_struct_ops_init(btf, log);
 
 	refcount_set(&btf->refcnt, 1);
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 650e5d21f90d..f4860ac756cd 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -27,6 +27,7 @@
 #include <linux/kthread.h>
 #include <linux/capability.h>
 #include <trace/events/xdp.h>
+#include <linux/btf_ids.h>
 
 #include <linux/netdevice.h>   /* netif_receive_skb_list */
 #include <linux/etherdevice.h> /* eth_type_trans */
@@ -673,7 +674,7 @@ static int cpu_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
 				      __cpu_map_lookup_elem);
 }
 
-static int cpu_map_btf_id;
+BTF_ID_LIST_SINGLE(cpu_map_btf_ids, struct, bpf_cpu_map)
 const struct bpf_map_ops cpu_map_ops = {
 	.map_meta_equal		= bpf_map_meta_equal,
 	.map_alloc		= cpu_map_alloc,
@@ -683,8 +684,7 @@ const struct bpf_map_ops cpu_map_ops = {
 	.map_lookup_elem	= cpu_map_lookup_elem,
 	.map_get_next_key	= cpu_map_get_next_key,
 	.map_check_btf		= map_check_no_btf,
-	.map_btf_name		= "bpf_cpu_map",
-	.map_btf_id		= &cpu_map_btf_id,
+	.map_btf_id		= &cpu_map_btf_ids[0],
 	.map_redirect		= cpu_map_redirect,
 };
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 038f6d7a83e4..c2867068e5bd 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -48,6 +48,7 @@
 #include <net/xdp.h>
 #include <linux/filter.h>
 #include <trace/events/xdp.h>
+#include <linux/btf_ids.h>
 
 #define DEV_CREATE_FLAG_MASK \
 	(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY)
@@ -1005,7 +1006,7 @@ static int dev_hash_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
 				      __dev_map_hash_lookup_elem);
 }
 
-static int dev_map_btf_id;
+BTF_ID_LIST_SINGLE(dev_map_btf_ids, struct, bpf_dtab)
 const struct bpf_map_ops dev_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc = dev_map_alloc,
@@ -1015,12 +1016,10 @@ const struct bpf_map_ops dev_map_ops = {
 	.map_update_elem = dev_map_update_elem,
 	.map_delete_elem = dev_map_delete_elem,
 	.map_check_btf = map_check_no_btf,
-	.map_btf_name = "bpf_dtab",
-	.map_btf_id = &dev_map_btf_id,
+	.map_btf_id = &dev_map_btf_ids[0],
 	.map_redirect = dev_map_redirect,
 };
 
-static int dev_map_hash_map_btf_id;
 const struct bpf_map_ops dev_map_hash_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc = dev_map_alloc,
@@ -1030,8 +1029,7 @@ const struct bpf_map_ops dev_map_hash_ops = {
 	.map_update_elem = dev_map_hash_update_elem,
 	.map_delete_elem = dev_map_hash_delete_elem,
 	.map_check_btf = map_check_no_btf,
-	.map_btf_name = "bpf_dtab",
-	.map_btf_id = &dev_map_hash_map_btf_id,
+	.map_btf_id = &dev_map_btf_ids[0],
 	.map_redirect = dev_hash_map_redirect,
 };
 
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 65877967f414..874e261b114d 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -10,6 +10,7 @@
 #include <linux/random.h>
 #include <uapi/linux/btf.h>
 #include <linux/rcupdate_trace.h>
+#include <linux/btf_ids.h>
 #include "percpu_freelist.h"
 #include "bpf_lru_list.h"
 #include "map_in_map.h"
@@ -2105,7 +2106,7 @@ static int bpf_for_each_hash_elem(struct bpf_map *map, bpf_callback_t callback_f
 	return num_elems;
 }
 
-static int htab_map_btf_id;
+BTF_ID_LIST_SINGLE(htab_map_btf_ids, struct, bpf_htab)
 const struct bpf_map_ops htab_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc_check = htab_map_alloc_check,
@@ -2122,12 +2123,10 @@ const struct bpf_map_ops htab_map_ops = {
 	.map_set_for_each_callback_args = map_set_for_each_callback_args,
 	.map_for_each_callback = bpf_for_each_hash_elem,
 	BATCH_OPS(htab),
-	.map_btf_name = "bpf_htab",
-	.map_btf_id = &htab_map_btf_id,
+	.map_btf_id = &htab_map_btf_ids[0],
 	.iter_seq_info = &iter_seq_info,
 };
 
-static int htab_lru_map_btf_id;
 const struct bpf_map_ops htab_lru_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc_check = htab_map_alloc_check,
@@ -2145,8 +2144,7 @@ const struct bpf_map_ops htab_lru_map_ops = {
 	.map_set_for_each_callback_args = map_set_for_each_callback_args,
 	.map_for_each_callback = bpf_for_each_hash_elem,
 	BATCH_OPS(htab_lru),
-	.map_btf_name = "bpf_htab",
-	.map_btf_id = &htab_lru_map_btf_id,
+	.map_btf_id = &htab_map_btf_ids[0],
 	.iter_seq_info = &iter_seq_info,
 };
 
@@ -2252,7 +2250,6 @@ static void htab_percpu_map_seq_show_elem(struct bpf_map *map, void *key,
 	rcu_read_unlock();
 }
 
-static int htab_percpu_map_btf_id;
 const struct bpf_map_ops htab_percpu_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc_check = htab_map_alloc_check,
@@ -2267,12 +2264,10 @@ const struct bpf_map_ops htab_percpu_map_ops = {
 	.map_set_for_each_callback_args = map_set_for_each_callback_args,
 	.map_for_each_callback = bpf_for_each_hash_elem,
 	BATCH_OPS(htab_percpu),
-	.map_btf_name = "bpf_htab",
-	.map_btf_id = &htab_percpu_map_btf_id,
+	.map_btf_id = &htab_map_btf_ids[0],
 	.iter_seq_info = &iter_seq_info,
 };
 
-static int htab_lru_percpu_map_btf_id;
 const struct bpf_map_ops htab_lru_percpu_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc_check = htab_map_alloc_check,
@@ -2287,8 +2282,7 @@ const struct bpf_map_ops htab_lru_percpu_map_ops = {
 	.map_set_for_each_callback_args = map_set_for_each_callback_args,
 	.map_for_each_callback = bpf_for_each_hash_elem,
 	BATCH_OPS(htab_lru_percpu),
-	.map_btf_name = "bpf_htab",
-	.map_btf_id = &htab_lru_percpu_map_btf_id,
+	.map_btf_id = &htab_map_btf_ids[0],
 	.iter_seq_info = &iter_seq_info,
 };
 
@@ -2412,7 +2406,6 @@ static void htab_of_map_free(struct bpf_map *map)
 	fd_htab_map_free(map);
 }
 
-static int htab_of_maps_map_btf_id;
 const struct bpf_map_ops htab_of_maps_map_ops = {
 	.map_alloc_check = fd_htab_map_alloc_check,
 	.map_alloc = htab_of_map_alloc,
@@ -2425,6 +2418,5 @@ const struct bpf_map_ops htab_of_maps_map_ops = {
 	.map_fd_sys_lookup_elem = bpf_map_fd_sys_lookup_elem,
 	.map_gen_lookup = htab_of_map_gen_lookup,
 	.map_check_btf = map_check_no_btf,
-	.map_btf_name = "bpf_htab",
-	.map_btf_id = &htab_of_maps_map_btf_id,
+	.map_btf_id = &htab_map_btf_ids[0],
 };
diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 497916060ac7..8654fc97f5fe 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -9,6 +9,7 @@
 #include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <uapi/linux/btf.h>
+#include <linux/btf_ids.h>
 
 #ifdef CONFIG_CGROUP_BPF
 
@@ -446,7 +447,8 @@ static void cgroup_storage_seq_show_elem(struct bpf_map *map, void *key,
 	rcu_read_unlock();
 }
 
-static int cgroup_storage_map_btf_id;
+BTF_ID_LIST_SINGLE(cgroup_storage_map_btf_ids, struct,
+		   bpf_cgroup_storage_map)
 const struct bpf_map_ops cgroup_storage_map_ops = {
 	.map_alloc = cgroup_storage_map_alloc,
 	.map_free = cgroup_storage_map_free,
@@ -456,8 +458,7 @@ const struct bpf_map_ops cgroup_storage_map_ops = {
 	.map_delete_elem = cgroup_storage_delete_elem,
 	.map_check_btf = cgroup_storage_check_btf,
 	.map_seq_show_elem = cgroup_storage_seq_show_elem,
-	.map_btf_name = "bpf_cgroup_storage_map",
-	.map_btf_id = &cgroup_storage_map_btf_id,
+	.map_btf_id = &cgroup_storage_map_btf_ids[0],
 };
 
 int bpf_cgroup_storage_assign(struct bpf_prog_aux *aux, struct bpf_map *_map)
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 5763cc7ac4f1..f0d05a3cc4b9 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -14,6 +14,7 @@
 #include <linux/vmalloc.h>
 #include <net/ipv6.h>
 #include <uapi/linux/btf.h>
+#include <linux/btf_ids.h>
 
 /* Intermediate node */
 #define LPM_TREE_NODE_FLAG_IM BIT(0)
@@ -719,7 +720,7 @@ static int trie_check_btf(const struct bpf_map *map,
 	       -EINVAL : 0;
 }
 
-static int trie_map_btf_id;
+BTF_ID_LIST_SINGLE(trie_map_btf_ids, struct, lpm_trie)
 const struct bpf_map_ops trie_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc = trie_alloc,
@@ -732,6 +733,5 @@ const struct bpf_map_ops trie_map_ops = {
 	.map_update_batch = generic_map_update_batch,
 	.map_delete_batch = generic_map_delete_batch,
 	.map_check_btf = trie_check_btf,
-	.map_btf_name = "lpm_trie",
-	.map_btf_id = &trie_map_btf_id,
+	.map_btf_id = &trie_map_btf_ids[0],
 };
diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index f9c734aaa990..a1c0794ae49d 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -8,6 +8,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/capability.h>
+#include <linux/btf_ids.h>
 #include "percpu_freelist.h"
 
 #define QUEUE_STACK_CREATE_FLAG_MASK \
@@ -247,7 +248,7 @@ static int queue_stack_map_get_next_key(struct bpf_map *map, void *key,
 	return -EINVAL;
 }
 
-static int queue_map_btf_id;
+BTF_ID_LIST_SINGLE(queue_map_btf_ids, struct, bpf_queue_stack)
 const struct bpf_map_ops queue_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc_check = queue_stack_map_alloc_check,
@@ -260,11 +261,9 @@ const struct bpf_map_ops queue_map_ops = {
 	.map_pop_elem = queue_map_pop_elem,
 	.map_peek_elem = queue_map_peek_elem,
 	.map_get_next_key = queue_stack_map_get_next_key,
-	.map_btf_name = "bpf_queue_stack",
-	.map_btf_id = &queue_map_btf_id,
+	.map_btf_id = &queue_map_btf_ids[0],
 };
 
-static int stack_map_btf_id;
 const struct bpf_map_ops stack_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc_check = queue_stack_map_alloc_check,
@@ -277,6 +276,5 @@ const struct bpf_map_ops stack_map_ops = {
 	.map_pop_elem = stack_map_pop_elem,
 	.map_peek_elem = stack_map_peek_elem,
 	.map_get_next_key = queue_stack_map_get_next_key,
-	.map_btf_name = "bpf_queue_stack",
-	.map_btf_id = &stack_map_btf_id,
+	.map_btf_id = &queue_map_btf_ids[0],
 };
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 8251243022a2..e2618fb5870e 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -6,6 +6,7 @@
 #include <linux/err.h>
 #include <linux/sock_diag.h>
 #include <net/sock_reuseport.h>
+#include <linux/btf_ids.h>
 
 struct reuseport_array {
 	struct bpf_map map;
@@ -337,7 +338,7 @@ static int reuseport_array_get_next_key(struct bpf_map *map, void *key,
 	return 0;
 }
 
-static int reuseport_array_map_btf_id;
+BTF_ID_LIST_SINGLE(reuseport_array_map_btf_ids, struct, reuseport_array)
 const struct bpf_map_ops reuseport_array_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc_check = reuseport_array_alloc_check,
@@ -346,6 +347,5 @@ const struct bpf_map_ops reuseport_array_ops = {
 	.map_lookup_elem = reuseport_array_lookup_elem,
 	.map_get_next_key = reuseport_array_get_next_key,
 	.map_delete_elem = reuseport_array_delete_elem,
-	.map_btf_name = "reuseport_array",
-	.map_btf_id = &reuseport_array_map_btf_id,
+	.map_btf_id = &reuseport_array_map_btf_ids[0],
 };
diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 710ba9de12ce..b651e45228d2 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -10,6 +10,7 @@
 #include <linux/poll.h>
 #include <linux/kmemleak.h>
 #include <uapi/linux/btf.h>
+#include <linux/btf_ids.h>
 
 #define RINGBUF_CREATE_FLAG_MASK (BPF_F_NUMA_NODE)
 
@@ -263,7 +264,7 @@ static __poll_t ringbuf_map_poll(struct bpf_map *map, struct file *filp,
 	return 0;
 }
 
-static int ringbuf_map_btf_id;
+BTF_ID_LIST_SINGLE(ringbuf_map_btf_ids, struct, bpf_ringbuf_map)
 const struct bpf_map_ops ringbuf_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc = ringbuf_map_alloc,
@@ -274,8 +275,7 @@ const struct bpf_map_ops ringbuf_map_ops = {
 	.map_update_elem = ringbuf_map_update_elem,
 	.map_delete_elem = ringbuf_map_delete_elem,
 	.map_get_next_key = ringbuf_map_get_next_key,
-	.map_btf_name = "bpf_ringbuf_map",
-	.map_btf_id = &ringbuf_map_btf_id,
+	.map_btf_id = &ringbuf_map_btf_ids[0],
 };
 
 /* Given pointer to ring buffer record metadata and struct bpf_ringbuf itself,
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 1dd5266fbebb..1adbe67cdb95 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -654,7 +654,7 @@ static void stack_map_free(struct bpf_map *map)
 	put_callchain_buffers();
 }
 
-static int stack_trace_map_btf_id;
+BTF_ID_LIST_SINGLE(stack_trace_map_btf_ids, struct, bpf_stack_map)
 const struct bpf_map_ops stack_trace_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc = stack_map_alloc,
@@ -664,6 +664,5 @@ const struct bpf_map_ops stack_trace_map_ops = {
 	.map_update_elem = stack_map_update_elem,
 	.map_delete_elem = stack_map_delete_elem,
 	.map_check_btf = map_check_no_btf,
-	.map_btf_name = "bpf_stack_map",
-	.map_btf_id = &stack_trace_map_btf_id,
+	.map_btf_id = &stack_trace_map_btf_ids[0],
 };
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index e3ac36380520..4008dd7c1b90 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -338,7 +338,7 @@ bpf_sk_storage_ptr(void *owner)
 	return &sk->sk_bpf_storage;
 }
 
-static int sk_storage_map_btf_id;
+BTF_ID_LIST_SINGLE(sk_storage_map_btf_ids, struct, bpf_local_storage_map)
 const struct bpf_map_ops sk_storage_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
 	.map_alloc_check = bpf_local_storage_map_alloc_check,
@@ -349,8 +349,7 @@ const struct bpf_map_ops sk_storage_map_ops = {
 	.map_update_elem = bpf_fd_sk_storage_update_elem,
 	.map_delete_elem = bpf_fd_sk_storage_delete_elem,
 	.map_check_btf = bpf_local_storage_map_check_btf,
-	.map_btf_name = "bpf_local_storage_map",
-	.map_btf_id = &sk_storage_map_btf_id,
+	.map_btf_id = &sk_storage_map_btf_ids[0],
 	.map_local_storage_charge = bpf_sk_storage_charge,
 	.map_local_storage_uncharge = bpf_sk_storage_uncharge,
 	.map_owner_storage_ptr = bpf_sk_storage_ptr,
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 2d213c4011db..81d4b4756a02 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -793,7 +793,7 @@ static const struct bpf_iter_seq_info sock_map_iter_seq_info = {
 	.seq_priv_size		= sizeof(struct sock_map_seq_info),
 };
 
-static int sock_map_btf_id;
+BTF_ID_LIST_SINGLE(sock_map_btf_ids, struct, bpf_stab)
 const struct bpf_map_ops sock_map_ops = {
 	.map_meta_equal		= bpf_map_meta_equal,
 	.map_alloc		= sock_map_alloc,
@@ -805,8 +805,7 @@ const struct bpf_map_ops sock_map_ops = {
 	.map_lookup_elem	= sock_map_lookup,
 	.map_release_uref	= sock_map_release_progs,
 	.map_check_btf		= map_check_no_btf,
-	.map_btf_name		= "bpf_stab",
-	.map_btf_id		= &sock_map_btf_id,
+	.map_btf_id		= &sock_map_btf_ids[0],
 	.iter_seq_info		= &sock_map_iter_seq_info,
 };
 
@@ -1385,7 +1384,7 @@ static const struct bpf_iter_seq_info sock_hash_iter_seq_info = {
 	.seq_priv_size		= sizeof(struct sock_hash_seq_info),
 };
 
-static int sock_hash_map_btf_id;
+BTF_ID_LIST_SINGLE(sock_hash_map_btf_ids, struct, bpf_shtab)
 const struct bpf_map_ops sock_hash_ops = {
 	.map_meta_equal		= bpf_map_meta_equal,
 	.map_alloc		= sock_hash_alloc,
@@ -1397,8 +1396,7 @@ const struct bpf_map_ops sock_hash_ops = {
 	.map_lookup_elem_sys_only = sock_hash_lookup_sys,
 	.map_release_uref	= sock_hash_release_progs,
 	.map_check_btf		= map_check_no_btf,
-	.map_btf_name		= "bpf_shtab",
-	.map_btf_id		= &sock_hash_map_btf_id,
+	.map_btf_id		= &sock_hash_map_btf_ids[0],
 	.iter_seq_info		= &sock_hash_iter_seq_info,
 };
 
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 65b53fb3de13..acc8e52a4f5f 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -9,6 +9,7 @@
 #include <net/xdp_sock.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/btf_ids.h>
 
 #include "xsk.h"
 
@@ -254,7 +255,7 @@ static bool xsk_map_meta_equal(const struct bpf_map *meta0,
 		bpf_map_meta_equal(meta0, meta1);
 }
 
-static int xsk_map_btf_id;
+BTF_ID_LIST_SINGLE(xsk_map_btf_ids, struct, xsk_map)
 const struct bpf_map_ops xsk_map_ops = {
 	.map_meta_equal = xsk_map_meta_equal,
 	.map_alloc = xsk_map_alloc,
@@ -266,7 +267,6 @@ const struct bpf_map_ops xsk_map_ops = {
 	.map_update_elem = xsk_map_update_elem,
 	.map_delete_elem = xsk_map_delete_elem,
 	.map_check_btf = map_check_no_btf,
-	.map_btf_name = "xsk_map",
-	.map_btf_id = &xsk_map_btf_id,
+	.map_btf_id = &xsk_map_btf_ids[0],
 	.map_redirect = xsk_map_redirect,
 };
-- 
2.36.0

