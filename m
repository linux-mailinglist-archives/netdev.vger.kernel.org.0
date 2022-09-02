Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC2E5AA5E4
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbiIBCb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234735AbiIBCbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:31:10 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9010D58B49;
        Thu,  1 Sep 2022 19:30:39 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id h188so738508pgc.12;
        Thu, 01 Sep 2022 19:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=LbURm8rqcOZV+rHHC9kc9kgsqQi9dVlL3oSCkwKpjVM=;
        b=VNb++7b2qt+LPgyZo5BPHw2GfJzb+MvkQEc6QA+/NiK8AE7Hg+ftvUL+ETOuo0W3Ej
         +rD8w4PJwMrJ1OiYNDt6QrnnBmguqiQ6LjLHQKSkYfEGDY06Bz/q4kKkC4ITYlWFYxz6
         +aH5cQv+GhAg3bnpb6Ie3cmiYwXa63zlzrVjBWVgNxAC3DRdCCPWgEhilDYnUuDKbLFc
         TOkhPwnPwuDaD+Szz7l1rZp0VOmBJ6CjdNMaaTCnnLTSpX6zuprBHGbmpJgE/h+u+jbK
         o3zFSUQmag8TcC2baZcmOMFDnXDF6xVr9RDtJSI0ENQYBSGq4LIgIsvC03YrVhiVMn+B
         97ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LbURm8rqcOZV+rHHC9kc9kgsqQi9dVlL3oSCkwKpjVM=;
        b=k569b1bIJwNNXkkKqNBheGe0f7v8nuu/eIkHq0KwRT9DR4PENOwPIOCviM9EYvEgQQ
         Xf47DwSNmckfDIEUJX+H01BLE5i70sI1e9QY1Ur3zM5vG7X8/p45ylEeahVUE1DNMNQC
         7fvknF3m8oUn7Fu5zWJlvp+y0Uhv75HToh14102n1L/5E7NyqJl59HGbf5djxVHcFdHA
         DBqAKyLT2OPOWHUIOpdUAF+TaUBwXHqjfEcVqJT+L/hGi1IPa6ecesXM10MLxkSDE5lZ
         MwlYxGCpsDSzJkdM6BG0CyH1VplxJxLMVpEREewiUek/cAI95PsIVSNp/Ds1Yusuq3XS
         KIaA==
X-Gm-Message-State: ACgBeo0aYMe+QnIgjU8ayVOe/qBzE9s+Q7mLtUCSFOuTvwS9uTMCd1xJ
        Zv1PibOjrl9hX/jjFKP7nWo=
X-Google-Smtp-Source: AA6agR6ktbAX7ONXPPPVIABchY62CUO2VrWR2JdJtRAEEYTq4TduYWLRwi/JwGe+KUXb/FheV0LpXQ==
X-Received: by 2002:a63:d745:0:b0:429:d263:615d with SMTP id w5-20020a63d745000000b00429d263615dmr29199167pgi.579.1662085838232;
        Thu, 01 Sep 2022 19:30:38 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:50ea:5400:4ff:fe1f:fbe2])
        by smtp.gmail.com with ESMTPSA id j4-20020a170902da8400b0017297a6b39dsm269719plx.265.2022.09.01.19.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 19:30:37 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 13/13] bpf: Introduce selectable memcg for bpf map
Date:   Fri,  2 Sep 2022 02:30:03 +0000
Message-Id: <20220902023003.47124-14-laoar.shao@gmail.com>
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

A new member memcg_fd is introduced into bpf attr of BPF_MAP_CREATE
command, which is the fd of an opened cgroup directory. In this cgroup,
the memory subsystem must be enabled. The valid memcg_fd must be a postive
number, that means it can't be zero(a valid return value of open(2)). Once
the kernel get the memory cgroup from this fd, it will set this memcg into
bpf map, then all the subsequent memory allocation of this map will be
charged to the memcg. The map creation paths in libbpf are also changed
consequently.

Currently we only allow to select its ancestors to avoid breaking the
memcg hierarchy further. For example, we can select its parent, other
ancestors, or the root memcg. Possible use cases of the selectable memcg
as follows,
- Select the root memcg as bpf-map's memcg
  Then bpf-map's memory won't be throttled by current memcg limit.
- Put current memcg under a fixed memcg dir and select the fixed memcg
  as bpf-map's memcg
  The hierarchy as follows,

      Parent-memcg (A fixed dir, i.e. /sys/fs/cgroup/memory/bpf)
         \
        Current-memcg (Container dir, i.e. /sys/fs/cgroup/memory/bpf/foo)

  At the map creation time, the bpf-map's memory will be charged
  into the parent directly without charging into current memcg, and thus
  current memcg's usage will be consistent among different generations.
  To limit bpf-map's memory usage, we can set the limit in the parent
  memcg.

Below is an example on how to use this new API,
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
 kernel/bpf/syscall.c           | 49 +++++++++++++++++++++++++++++++++---------
 tools/include/uapi/linux/bpf.h |  1 +
 tools/lib/bpf/bpf.c            |  3 ++-
 tools/lib/bpf/bpf.h            |  3 ++-
 tools/lib/bpf/gen_loader.c     |  2 +-
 tools/lib/bpf/libbpf.c         |  2 ++
 tools/lib/bpf/skel_internal.h  |  2 +-
 8 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 962960a..9121c4f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1319,6 +1319,7 @@ struct bpf_stack_build_id {
 		 * to using 5 hash functions).
 		 */
 		__u64	map_extra;
+		__u32	memcg_fd;	/* selectable memcg */
 	};
 
 	struct { /* anonymous struct used by BPF_MAP_*_ELEM commands */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f710495..1b1af68 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -294,14 +294,37 @@ static int bpf_map_copy_value(struct bpf_map *map, void *key, void *value,
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
+		cgroup_put(cgrp);
+		if (IS_ERR(objcg))
+			return PTR_ERR(objcg);
+
+		/* Currently we only allow to select its ancestors. */
+		if (objcg && !task_under_memcg_hierarchy(current, objcg->memcg)) {
+			obj_cgroup_put(objcg);
+			return -EINVAL;
+		}
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
@@ -311,8 +334,9 @@ static void bpf_map_release_memcg(struct bpf_map *map)
 }
 
 #else
-static void bpf_map_save_memcg(struct bpf_map *map)
+static int bpf_map_save_memcg(struct bpf_map *map, u32 memcg_fd)
 {
+	return 0;
 }
 
 static void bpf_map_release_memcg(struct bpf_map *map)
@@ -405,7 +429,12 @@ static u32 bpf_map_flags_retain_permanent(u32 flags)
 
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
@@ -1091,7 +1120,7 @@ static int map_check_btf(struct bpf_map *map, const struct btf *btf,
 	return ret;
 }
 
-#define BPF_MAP_CREATE_LAST_FIELD map_extra
+#define BPF_MAP_CREATE_LAST_FIELD memcg_fd
 /* called via syscall */
 static int map_create(union bpf_attr *attr)
 {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f4ba82a..fc19366 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1319,6 +1319,7 @@ struct bpf_stack_build_id {
 		 * to using 5 hash functions).
 		 */
 		__u64	map_extra;
+		__u32	memcg_fd;	/* selectable memcg */
 	};
 
 	struct { /* anonymous struct used by BPF_MAP_*_ELEM commands */
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 1d49a03..b475b28 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -169,7 +169,7 @@ int bpf_map_create(enum bpf_map_type map_type,
 		   __u32 max_entries,
 		   const struct bpf_map_create_opts *opts)
 {
-	const size_t attr_sz = offsetofend(union bpf_attr, map_extra);
+	const size_t attr_sz = offsetofend(union bpf_attr, memcg_fd);
 	union bpf_attr attr;
 	int fd;
 
@@ -197,6 +197,7 @@ int bpf_map_create(enum bpf_map_type map_type,
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
index 3ad1392..ce04d93 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -512,6 +512,7 @@ struct bpf_map {
 	bool reused;
 	bool autocreate;
 	__u64 map_extra;
+	__u32 memcg_fd;
 };
 
 enum extern_type {
@@ -4948,6 +4949,7 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, b
 	create_attr.map_flags = def->map_flags;
 	create_attr.numa_node = map->numa_node;
 	create_attr.map_extra = map->map_extra;
+	create_attr.memcg_fd = map->memcg_fd;
 
 	if (bpf_map__is_struct_ops(map))
 		create_attr.btf_vmlinux_value_type_id = map->btf_vmlinux_value_type_id;
diff --git a/tools/lib/bpf/skel_internal.h b/tools/lib/bpf/skel_internal.h
index 1e82ab0..8760747 100644
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

