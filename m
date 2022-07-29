Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF1D58527B
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237346AbiG2PYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237530AbiG2PYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:24:04 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13479863D5;
        Fri, 29 Jul 2022 08:23:53 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a7-20020a17090a008700b001f325db8b90so4154927pja.0;
        Fri, 29 Jul 2022 08:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7YsE4RcubCx0MNNfTDgzCPEblKVY7zNgxkQBDs4eXwk=;
        b=O5fg25+RPCgr8YZ1DZBPRlYRypSoSLhhZ+s3atPcrFK25aDQy6CL5rwsw3m5+llAGw
         wxrSeU2pkwin6ICTg/I3esczDOPduHDhcISG8YjXkEl7nhA+/yeiVyiBanmd9vhcuN1y
         E/hSC/t7jj5rA1Meyi7gYlgtiHotJd1DdRmBBK0p2WnPK0R9+EwD+M2bpgHZ6x0q5OWX
         gAoKVgnTZLygdyqobNOJdDpPJffXYepcW9t/NfVuXa2B2frGIHDd/tdQ9M5E3HJK8EFL
         Tr3Rt7EnK4zC3dObgNYBgZgpxW/coISdKL/i9f6FAYcMOrnO+oDj7WvlZZBTzgVAy+YH
         QTxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7YsE4RcubCx0MNNfTDgzCPEblKVY7zNgxkQBDs4eXwk=;
        b=bZZiIENqLGfBHuJiOagMcMBSGELPsPqIYyFGEfC8l/714zm2hwUwXpjLd9Y5X/9y8X
         cGNSxhy4Ybz9C3LISOSq5+xVp5GSK05iQema5YU9UO9vMlX/oA9X7Y+gBZWr6KoNg2dM
         x3hWZghE9DVpZJyqKX0/Kf0Es3N8r9MI4PJ45Cz7zovBWDC700LWL0Jdsw3ie9KkduCK
         RwzwUqxkkz7VX61K03jKYPQ0UvOaWIA77oz+lWMdcoRCSe34YHKfPk5BhuT+fJL9J3lx
         7JoWLNMeTkF7rl8C3nkdLZzgyMkM+thu7BY3ls0FWGa1iAXuxAWJY9kbxLD3igdQbVam
         6cVw==
X-Gm-Message-State: ACgBeo3sOYHCsG6dLD6iiu6Kcybb9GbekSm7UzF3O+fU98TAQdo6HNYb
        syv4vnsmLuz2LVcEgXqNuxk=
X-Google-Smtp-Source: AA6agR7ytKHuTcGgGPxk083gm4DArTadtq9szQO+g7w3QFR6tTBNSGjLIDUSkmlzzv7MzA+JPSsXSg==
X-Received: by 2002:a17:902:a502:b0:15e:c251:b769 with SMTP id s2-20020a170902a50200b0015ec251b769mr4526184plq.115.1659108232767;
        Fri, 29 Jul 2022 08:23:52 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:2912:5400:4ff:fe16:4344])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm3714219plm.89.2022.07.29.08.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:23:51 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 15/15] bpf: Introduce selectable memcg for bpf map
Date:   Fri, 29 Jul 2022 15:23:16 +0000
Message-Id: <20220729152316.58205-16-laoar.shao@gmail.com>
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

A new member memcg_fd is introduced into bpf attr of BPF_MAP_CREATE
command, which is the fd of an opened cgroup directory. In this cgroup,
the memory subsystem must be enabled. This value is valid only when
BPF_F_SELECTABLE_MEMCG is set in map_flags. Once the kernel get the
memory cgroup from this fd, it will set this memcg into bpf map, then
all the subsequent memory allocation of this map will be charge to the
memcg.

The map creation paths in libbpf are also changed consequently.

Currently it is only supported for cgroup2 directory.

The usage of this new member as follows,
	struct bpf_map_create_opts map_opts = {
		.sz = sizeof(map_opts),
		.map_flags = BPF_F_SELECTABLE_MEMCG,
	};
	int memcg_fd, int map_fd;
	int key, value;

	memcg_fd = open("/cgroup2", O_DIRECTORY);
	if (memcg_fd < 0) {
		perror("memcg dir open");
		return -1;
	}

	map_opts.memcg_fd = memcg_fd;
	map_fd = bpf_map_create(BPF_MAP_TYPE_HASH, "map_for_memcg",
				sizeof(key), sizeof(value),
				1024, &map_opts);
	if (map_fd <= 0) {
		perror("map create");
		return -1;
	}

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/uapi/linux/bpf.h       |  2 ++
 kernel/bpf/syscall.c           | 47 ++++++++++++++++++++++++++--------
 tools/include/uapi/linux/bpf.h |  2 ++
 tools/lib/bpf/bpf.c            |  1 +
 tools/lib/bpf/bpf.h            |  3 ++-
 tools/lib/bpf/libbpf.c         |  2 ++
 6 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d5fc1ea70b59..a6e02c8be924 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1296,6 +1296,8 @@ union bpf_attr {
 						   * struct stored as the
 						   * map value
 						   */
+		__s32	memcg_fd;	/* selectable memcg */
+		__s32	:32;		/* hole */
 		/* Any per-map-type extra fields
 		 *
 		 * BPF_MAP_TYPE_BLOOM_FILTER - the lowest 4 bits indicate the
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6401cc417fa9..9900e2b87315 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -402,14 +402,30 @@ void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock)
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-static void bpf_map_save_memcg(struct bpf_map *map)
+static int bpf_map_save_memcg(struct bpf_map *map, union bpf_attr *attr)
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
+	if (attr->map_flags & BPF_F_SELECTABLE_MEMCG) {
+		cgrp = cgroup_get_from_fd(attr->memcg_fd);
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
@@ -485,8 +501,9 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
 }
 
 #else
-static void bpf_map_save_memcg(struct bpf_map *map)
+static int bpf_map_save_memcg(struct bpf_map *map, union bpf_attr *attr)
 {
+	return 0;
 }
 
 static void bpf_map_release_memcg(struct bpf_map *map)
@@ -530,13 +547,18 @@ void *bpf_map_container_alloc(union bpf_attr *attr, u64 size, int numa_node)
 {
 	struct bpf_map *map;
 	void *container;
+	int ret;
 
 	container = __bpf_map_area_alloc(size, numa_node, false);
 	if (!container)
 		return ERR_PTR(-ENOMEM);
 
 	map = (struct bpf_map *)container;
-	bpf_map_save_memcg(map);
+	ret = bpf_map_save_memcg(map, attr);
+	if (ret) {
+		bpf_map_area_free(container);
+		return ERR_PTR(ret);
+	}
 
 	return container;
 }
@@ -547,6 +569,7 @@ void *bpf_map_container_mmapable_alloc(union bpf_attr *attr, u64 size,
 	struct bpf_map *map;
 	void *container;
 	void *ptr;
+	int ret;
 
 	/* kmalloc'ed memory can't be mmap'ed, use explicit vmalloc */
 	ptr = __bpf_map_area_alloc(size, numa_node, true);
@@ -555,7 +578,11 @@ void *bpf_map_container_mmapable_alloc(union bpf_attr *attr, u64 size,
 
 	container = ptr + align - offset;
 	map = (struct bpf_map *)container;
-	bpf_map_save_memcg(map);
+	ret = bpf_map_save_memcg(map, attr);
+	if (ret) {
+		bpf_map_area_free(ptr);
+		return ERR_PTR(ret);
+	}
 
 	return ptr;
 }
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index d5fc1ea70b59..a6e02c8be924 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1296,6 +1296,8 @@ union bpf_attr {
 						   * struct stored as the
 						   * map value
 						   */
+		__s32	memcg_fd;	/* selectable memcg */
+		__s32	:32;		/* hole */
 		/* Any per-map-type extra fields
 		 *
 		 * BPF_MAP_TYPE_BLOOM_FILTER - the lowest 4 bits indicate the
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 5eb0df90eb2b..662ce5808386 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -199,6 +199,7 @@ int bpf_map_create(enum bpf_map_type map_type,
 	attr.map_extra = OPTS_GET(opts, map_extra, 0);
 	attr.numa_node = OPTS_GET(opts, numa_node, 0);
 	attr.map_ifindex = OPTS_GET(opts, map_ifindex, 0);
+	attr.memcg_fd = OPTS_GET(opts, memcg_fd, 0);
 
 	fd = sys_bpf_fd(BPF_MAP_CREATE, &attr, attr_sz);
 	return libbpf_err_errno(fd);
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 88a7cc4bd76f..481aad49422b 100644
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
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 50d41815f431..86916d550031 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -505,6 +505,7 @@ struct bpf_map {
 	bool pinned;
 	bool reused;
 	bool autocreate;
+	__s32 memcg_fd;
 	__u64 map_extra;
 };
 
@@ -4928,6 +4929,7 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map, b
 	create_attr.map_ifindex = map->map_ifindex;
 	create_attr.map_flags = def->map_flags;
 	create_attr.numa_node = map->numa_node;
+	create_attr.memcg_fd = map->memcg_fd;
 	create_attr.map_extra = map->map_extra;
 
 	if (bpf_map__is_struct_ops(map))
-- 
2.17.1

