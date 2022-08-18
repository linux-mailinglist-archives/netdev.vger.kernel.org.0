Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66EE25985D4
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245451AbiHROcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245512AbiHROcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:32:22 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E62BA9E8;
        Thu, 18 Aug 2022 07:32:16 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id jl18so1671166plb.1;
        Thu, 18 Aug 2022 07:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=64R3bxHMvv5+V0T/PDUTVz1Uk0VIs+H8eHbhqMNvmEQ=;
        b=EX8ou0RTkSODLqaqCgCGl9TJKOPxlpSZvuMeBQIXCinFHIrXw9t+gJjdaOl1mdSXVT
         FIAy96Vr2dV3mTuOnnHpKPLUiP9iI2Of1ABEgqlQg49YBMVR4yPV9qLCh5X0Fcn9hc+9
         cl543oOVxhHqJyYddxl+ATvDR2FjVNUBymnWUayB/yeDtZtpbqdoWXZWgoZnRR5/ceUg
         l6ajY8CycQHl70bSisAS55nOgS1iLAsM/DWjfN8EiJj9GAYQvLcJsjEZooxZ0KR84cQc
         iu8CpiidQdVIJI3fOVPgpk6h2wy/3yjI4rkfhJA0KVBw+Y93nYe/m5zCOQRx7Ahtz1Xs
         jhVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=64R3bxHMvv5+V0T/PDUTVz1Uk0VIs+H8eHbhqMNvmEQ=;
        b=boFheNCpA6tHASPH1f9vXi4sp2ooxfBoA+BD3KSdvtNpr4vEmVZCgBc8HLK/TYimUD
         RcLsjDur+DZjViaw5FARH+PXfi/L0WegbJ0MQW5mjdFam7Cg25Y/tOKaurjWkHvdW/UP
         iofYJjaxE7FKkTL6erv3MF+ySnm5th0RUsoiAKEP4WjvLF3Mg7H7XKRPUeL8IxShQzw5
         8l8dEQ155ds6BT1IDgm4efXOLLNxxkBdoKhOPasKHvEsja8oullbAt6h9gAdxJa6jJ2f
         OGe/U4ludgnpdg118sdY/TUYTv0TQYzEEFRWwJqh0V6UPi3QI+4jEzeh5XZVjDg4vExy
         eiLg==
X-Gm-Message-State: ACgBeo0uXhOa9rDDOTxyyMKXhoKQOfyJgq5gVhEczc3tPraTDBZ9+Mxq
        3G11PcgZpHRCLymXq/ut13M=
X-Google-Smtp-Source: AA6agR6BXiviu/fMhtQYEidUfIBaxKQz8CADJ9PvR9/TZPkp8KxyBxMr5H555oupXKEWVyIiR5O4fg==
X-Received: by 2002:a17:90a:7f89:b0:1fa:ad33:7289 with SMTP id m9-20020a17090a7f8900b001faad337289mr8838077pjl.173.1660833136171;
        Thu, 18 Aug 2022 07:32:16 -0700 (PDT)
Received: from vultr.guest ([45.32.72.237])
        by smtp.gmail.com with ESMTPSA id h5-20020a63f905000000b003fdc16f5de2sm1379124pgi.15.2022.08.18.07.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 07:32:15 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 12/12] bpf: Introduce selectable memcg for bpf map
Date:   Thu, 18 Aug 2022 14:31:18 +0000
Message-Id: <20220818143118.17733-13-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220818143118.17733-1-laoar.shao@gmail.com>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
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

A new bpf attr memcg_fd is introduced for map creation. The map creation
path in libbpf is changed consequently to set this attr.

A new member memcg_fd is introduced into bpf attr of BPF_MAP_CREATE
command, which is the fd of an opened cgroup directory. In this cgroup,
the memory subsystem must be enabled. The valid memcg_fd must be a postive
number, that means it can't be zero(a valid return value of open(2)). Once
the kernel get the memory cgroup from this fd, it will set this memcg into
bpf map, then all the subsequent memory allocation of this map will be
charged to the memcg. The map creation paths in libbpf are also changed
consequently.

The usage of this new member as follows,
	struct bpf_map_create_opts map_opts = {
		.sz = sizeof(map_opts),
	};
	int memcg_fd, map_fd, old_fd;
	int key, value;

	memcg_fd = open("/sys/fs/cgroup/memory/bpf", O_DIRECTORY);
	if (memcg_fd < 0) {
		perror("memcg dir open");
		return -1;
	}

	/* 0 is a invalid fd */
	if (memcg_fd == 0) {
		old_fd = memcg_fd;
		memcg_fd = fcntl(memcg_fd, F_DUPFD_CLOEXEC, 3);
		close(old_fd);
		if (memcg_fd < 0) {
			perror("fcntl");
			return -1;
		}
	}

	map_opts.memcg_fd = memcg_fd;
	map_fd = bpf_map_create(BPF_MAP_TYPE_HASH, "map_for_memcg",
				sizeof(key), sizeof(value),
				1024, &map_opts);
	if (map_fd <= 0) {
		close(memcg_fd);
		perror("map create");
		return -1;
	}

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/syscall.c           | 45 ++++++++++++++++++++++++++++++++----------
 tools/include/uapi/linux/bpf.h |  1 +
 tools/lib/bpf/bpf.c            |  3 ++-
 tools/lib/bpf/bpf.h            |  3 ++-
 tools/lib/bpf/gen_loader.c     |  2 +-
 tools/lib/bpf/libbpf.c         |  2 ++
 tools/lib/bpf/skel_internal.h  |  2 +-
 8 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 7d1e279..048b692 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1300,6 +1300,7 @@ struct bpf_stack_build_id {
 		 * to using 5 hash functions).
 		 */
 		__u64	map_extra;
+		__u32	memcg_fd;	/* selectable memcg */
 	};
 
 	struct { /* anonymous struct used by BPF_MAP_*_ELEM commands */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 5f5cade4..fd1f67c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -294,14 +294,33 @@ static int bpf_map_copy_value(struct bpf_map *map, void *key, void *value,
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-static void bpf_map_save_memcg(struct bpf_map *map)
+static int bpf_map_save_memcg(struct bpf_map *map, u32 memcg_fd)
 {
-	/* Currently if a map is created by a process belonging to the root
-	 * memory cgroup, get_obj_cgroup_from_current() will return NULL.
-	 * So we have to check map->objcg for being NULL each time it's
-	 * being used.
-	 */
-	map->objcg = get_obj_cgroup_from_current();
+	struct obj_cgroup *objcg;
+	struct cgroup *cgrp;
+
+	if (memcg_fd) {
+		cgrp = cgroup_get_from_fd(memcg_fd);
+		if (IS_ERR(cgrp))
+			return -EINVAL;
+
+		objcg = get_obj_cgroup_from_cgroup(cgrp);
+		if (IS_ERR(objcg)) {
+			cgroup_put(cgrp);
+			return PTR_ERR(objcg);
+		}
+		cgroup_put(cgrp);
+	} else {
+		/* Currently if a map is created by a process belonging to the root
+		 * memory cgroup, get_obj_cgroup_from_current() will return NULL.
+		 * So we have to check map->objcg for being NULL each time it's
+		 * being used.
+		 */
+		objcg = get_obj_cgroup_from_current();
+	}
+
+	map->objcg = objcg;
+	return 0;
 }
 
 static void bpf_map_release_memcg(struct bpf_map *map)
@@ -311,8 +330,9 @@ static void bpf_map_release_memcg(struct bpf_map *map)
 }
 
 #else
-static void bpf_map_save_memcg(struct bpf_map *map)
+static int bpf_map_save_memcg(struct bpf_map *map, u32 memcg_fd)
 {
+	return 0;
 }
 
 static void bpf_map_release_memcg(struct bpf_map *map)
@@ -405,7 +425,12 @@ static u32 bpf_map_flags_retain_permanent(u32 flags)
 
 int bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr)
 {
-	bpf_map_save_memcg(map);
+	int err;
+
+	err = bpf_map_save_memcg(map, attr->memcg_fd);
+	if (err)
+		return err;
+
 	map->map_type = attr->map_type;
 	map->key_size = attr->key_size;
 	map->value_size = attr->value_size;
@@ -1091,7 +1116,7 @@ static int map_check_btf(struct bpf_map *map, const struct btf *btf,
 	return ret;
 }
 
-#define BPF_MAP_CREATE_LAST_FIELD map_extra
+#define BPF_MAP_CREATE_LAST_FIELD memcg_fd
 /* called via syscall */
 static int map_create(union bpf_attr *attr)
 {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index e174ad2..1e9efe7 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1300,6 +1300,7 @@ struct bpf_stack_build_id {
 		 * to using 5 hash functions).
 		 */
 		__u64	map_extra;
+		__u32	memcg_fd;	/* selectable memcg */
 	};
 
 	struct { /* anonymous struct used by BPF_MAP_*_ELEM commands */
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 6a96e66..6517553 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -171,7 +171,7 @@ int bpf_map_create(enum bpf_map_type map_type,
 		   __u32 max_entries,
 		   const struct bpf_map_create_opts *opts)
 {
-	const size_t attr_sz = offsetofend(union bpf_attr, map_extra);
+	const size_t attr_sz = offsetofend(union bpf_attr, memcg_fd);
 	union bpf_attr attr;
 	int fd;
 
@@ -199,6 +199,7 @@ int bpf_map_create(enum bpf_map_type map_type,
 	attr.map_extra = OPTS_GET(opts, map_extra, 0);
 	attr.numa_node = OPTS_GET(opts, numa_node, 0);
 	attr.map_ifindex = OPTS_GET(opts, map_ifindex, 0);
+	attr.memcg_fd = OPTS_GET(opts, memcg_fd, 0);
 
 	fd = sys_bpf_fd(BPF_MAP_CREATE, &attr, attr_sz);
 	return libbpf_err_errno(fd);
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 9c50bea..dd0d929 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -51,8 +51,9 @@ struct bpf_map_create_opts {
 
 	__u32 numa_node;
 	__u32 map_ifindex;
+	__u32 memcg_fd;
 };
-#define bpf_map_create_opts__last_field map_ifindex
+#define bpf_map_create_opts__last_field memcg_fd
 
 LIBBPF_API int bpf_map_create(enum bpf_map_type map_type,
 			      const char *map_name,
diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 23f5c46..f35b014 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -451,7 +451,7 @@ void bpf_gen__map_create(struct bpf_gen *gen,
 			 __u32 key_size, __u32 value_size, __u32 max_entries,
 			 struct bpf_map_create_opts *map_attr, int map_idx)
 {
-	int attr_size = offsetofend(union bpf_attr, map_extra);
+	int attr_size = offsetofend(union bpf_attr, memcg_fd);
 	bool close_inner_map_fd = false;
 	int map_create_attr, idx;
 	union bpf_attr attr;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3f01f5c..ad7aa39 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -511,6 +511,7 @@ struct bpf_map {
 	bool reused;
 	bool autocreate;
 	__u64 map_extra;
+	__u32 memcg_fd;
 };
 
 enum extern_type {
@@ -4936,6 +4937,7 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, b
 	create_attr.map_flags = def->map_flags;
 	create_attr.numa_node = map->numa_node;
 	create_attr.map_extra = map->map_extra;
+	create_attr.memcg_fd = map->memcg_fd;
 
 	if (bpf_map__is_struct_ops(map))
 		create_attr.btf_vmlinux_value_type_id = map->btf_vmlinux_value_type_id;
diff --git a/tools/lib/bpf/skel_internal.h b/tools/lib/bpf/skel_internal.h
index bd6f450..83403cc 100644
--- a/tools/lib/bpf/skel_internal.h
+++ b/tools/lib/bpf/skel_internal.h
@@ -222,7 +222,7 @@ static inline int skel_map_create(enum bpf_map_type map_type,
 				  __u32 value_size,
 				  __u32 max_entries)
 {
-	const size_t attr_sz = offsetofend(union bpf_attr, map_extra);
+	const size_t attr_sz = offsetofend(union bpf_attr, memcg_fd);
 	union bpf_attr attr;
 
 	memset(&attr, 0, attr_sz);
-- 
1.8.3.1

