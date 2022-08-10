Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7677358EF40
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbiHJPTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbiHJPT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:19:28 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9129792E8;
        Wed, 10 Aug 2022 08:19:14 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id x10so14532185plb.3;
        Wed, 10 Aug 2022 08:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=j0vArd5kCmiXrID4XqlmDliohUWxtZHgIa+7cLj7rn4=;
        b=MMqCZhZzn3sPBSjB7ZDkJJIzBlptDVnfvWBJBi7wzuaf50HQkzpq0n1tWWQQphwNyJ
         ZklkxnQA8koYN0EJXc+3L66T4Z7Q4/utfybyMzW/726CwjF6qxJRRhjGxZLL/UFOCJpy
         TbLLn8wPu5HHYALnaIL6Zr1cVcQhfLODb3U5fKDoct69VMSPVdkMR02c4MZ4pbaOGL88
         bsrNxcSN9J2IbjjHDyneHYAO1vR1Fk8CzPkrwABFfjOsMeoee/lSNk1rOo7iZrmr9mwX
         neOuRzkK/8bEk/+EYUnY/xmdqOrtEX7z889sH2Ud4PBHNpxb5htGNjQTuNIdLiCtBobn
         EDYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=j0vArd5kCmiXrID4XqlmDliohUWxtZHgIa+7cLj7rn4=;
        b=uRYI51YWAnXN+9qN8w1plEYGq4UX72HHiG9IpoIoFio61hRO8ipjtIZ/5oG45VuFOe
         vbAttwVMiDoCJB3bmtEWNlHAzd/hIFTTzosrM7CG7WQyVz4qCaPDtkzMWE2iqBNgWjjI
         upcBQjzTjjm1u61Fn3SfTBicDbk4T7SA6kCxD0V2VqP2AMcvwhBvqr5G+nuirezK+uI7
         wAmu9tPvMmf4qSRKa3J7dhfcWuQGNnfLMhQAr9/M4KnlWOG0bUtNp08ZGJybF2WInFHd
         qGPhQKEw+ntb6QSMdtPXAhu5TnAcSPUVmC4MWfXrayHJybX8H7A29LV09M5fOgW6jD/x
         vJqQ==
X-Gm-Message-State: ACgBeo31WPvqrfY2E0uslSRDhXYSsvll19fuYqqeLgMWyaFYZein0e6K
        r0B0IMlBwqbay6tzR73BLB8=
X-Google-Smtp-Source: AA6agR7KJ1PJ7r6sNN9BQifYoxntxi66pFLvj/s4h7cp7gKDAa5B4ZqS0oSQrdeDzsOIO2LhhJwkrA==
X-Received: by 2002:a17:90b:33c6:b0:1f4:f595:b0f1 with SMTP id lk6-20020a17090b33c600b001f4f595b0f1mr4349009pjb.230.1660144753765;
        Wed, 10 Aug 2022 08:19:13 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5c3e:5400:4ff:fe19:c3bc])
        by smtp.gmail.com with ESMTPSA id 85-20020a621558000000b0052b6ed5ca40sm2071935pfv.192.2022.08.10.08.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:19:12 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 15/15] bpf: Introduce selectable memcg for bpf map
Date:   Wed, 10 Aug 2022 15:18:40 +0000
Message-Id: <20220810151840.16394-16-laoar.shao@gmail.com>
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

Currently it is only supported for cgroup2 directory.

The usage of this new member as follows,
	struct bpf_map_create_opts map_opts = {
		.sz = sizeof(map_opts),
	};
	int memcg_fd, map_fd, old_fd;
	int key, value;

	memcg_fd = open("/cgroup2", O_DIRECTORY);
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
 kernel/bpf/syscall.c           | 42 ++++++++++++++++++++++++++++++++----------
 tools/include/uapi/linux/bpf.h |  1 +
 tools/lib/bpf/bpf.c            |  3 ++-
 tools/lib/bpf/bpf.h            |  3 ++-
 tools/lib/bpf/gen_loader.c     |  2 +-
 tools/lib/bpf/libbpf.c         |  2 ++
 tools/lib/bpf/skel_internal.h  |  2 +-
 8 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 534e33f..d46acbb 100644
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
index 5f5cade4..91a6e15 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -294,14 +294,30 @@ static int bpf_map_copy_value(struct bpf_map *map, void *key, void *value,
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
+		if (IS_ERR(objcg))
+			return PTR_ERR(objcg);
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
@@ -311,8 +327,9 @@ static void bpf_map_release_memcg(struct bpf_map *map)
 }
 
 #else
-static void bpf_map_save_memcg(struct bpf_map *map)
+static int bpf_map_save_memcg(struct bpf_map *map, u32 memcg_fd)
 {
+	return 0;
 }
 
 static void bpf_map_release_memcg(struct bpf_map *map)
@@ -405,7 +422,12 @@ static u32 bpf_map_flags_retain_permanent(u32 flags)
 
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
@@ -1091,7 +1113,7 @@ static int map_check_btf(struct bpf_map *map, const struct btf *btf,
 	return ret;
 }
 
-#define BPF_MAP_CREATE_LAST_FIELD map_extra
+#define BPF_MAP_CREATE_LAST_FIELD memcg_fd
 /* called via syscall */
 static int map_create(union bpf_attr *attr)
 {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f58d58e..12203406 100644
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
index efcc06d..9c613b2 100644
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
index f7364ea..88c65e5 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -506,6 +506,7 @@ struct bpf_map {
 	bool reused;
 	bool autocreate;
 	__u64 map_extra;
+	__u32 memcg_fd;
 };
 
 enum extern_type {
@@ -4931,6 +4932,7 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, b
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

