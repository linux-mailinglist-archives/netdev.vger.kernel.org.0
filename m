Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000CC529868
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 05:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237035AbiEQDpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 23:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235842AbiEQDoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 23:44:54 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5724B2AE19;
        Mon, 16 May 2022 20:44:53 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so1145665pjq.2;
        Mon, 16 May 2022 20:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wcklOhNMgFZYwuThqF5vbidRJDiMHHyRFV3A6M7OaLo=;
        b=eYGruLJtZHXmkIR3YuAejXf4dUv/8l41HnVateF9FRmcR5fAKmHJu9Jrypu8rLKrrL
         piuf9f1aYuH64qsvs3DE2vN73+WGgTFkEZaU7kpJWQfyfjqV+nKPA7NO7QczjYS3+6T8
         RkIWnRok1CQhPznHokAxDxAQDxqsy3BV8dMr1UXtP3JOnp3yqFNpdWUXMZHeJIM+VWVs
         YHbhZjoToOWNxPXGOAyuZhlOr44b8iNNfn0Q3X6V8gB1sgjY97zyNlF4gXQkjTGVlYgx
         xobKQJMTJv5HTU6t2IjP28pyLrK8HF4WJBNVTfeLaVP3QyMe6sUOM/Ls5J8ybJPdq4EZ
         bKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wcklOhNMgFZYwuThqF5vbidRJDiMHHyRFV3A6M7OaLo=;
        b=yQViu2Pz39PFPhVFu4kP1P4EbU2WUzl0GsAMgbYGg3+E4HvRUssyY7poLbLrZBY0tF
         gjnn4VKQiRxyp7HgfeCxE+ys9pHmZfUBANji54c7qD08aWdfLGXZJnjhuEJJDwooExvu
         5ig8BLNu8i4PoQVkBnLrJSttm/IdtacLR/sgB548FfXK4Z5es8GuvTo3xWMxwFV0plWP
         D7vaaWpgcWCyu2RGDtzv8/oqKZshE8hDKil+l/uZHAzG6c2g0KIeDxJXdPyt5/uQyka6
         60muJ14VO7y2OXHwHe8E+d0Qp3iYpkGsr0DQMiDal+aVJFeWux9dena0bfyihsJq8Prb
         +tqw==
X-Gm-Message-State: AOAM532OBRvq2bS3Q4LXNPy0ira+Dw4Z5Ka9Wcygn0KPILZwkn0uhatS
        k3KrrrYDk7KYO0nf8y074M0=
X-Google-Smtp-Source: ABdhPJzPnoGtvQPDSwTK8G3oIamPYP3DR5KyGVKqZoSj8U2GE0TBO4kmQlZ1x6G4ytH22EYv8h/x2A==
X-Received: by 2002:a17:90b:1894:b0:1dc:103a:3ba2 with SMTP id mn20-20020a17090b189400b001dc103a3ba2mr33724390pjb.181.1652759092742;
        Mon, 16 May 2022 20:44:52 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id m13-20020a170902f64d00b0015e8d4eb299sm7782180plg.227.2022.05.16.20.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 20:44:52 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Menglong Dong <imagedong@tencent.com>
Subject: [PATCH] bpf: add access control for map
Date:   Tue, 17 May 2022 11:41:07 +0800
Message-Id: <20220517034107.92194-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
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

From: Menglong Dong <imagedong@tencent.com>

Hello,

I have a idea about the access control of eBPF map, could you help
to see if it works?

For now, only users with the CAP_SYS_ADMIN or CAP_BPF have the right
to access the data in eBPF maps. So I'm thinking, are there any way
to control the access to the maps, just like what we do to files?
Therefore, we can decide who have the right to read the map and who
can write.

I think it is useful in some case. For example, I made a eBPF-based
network statistics program, and the information is stored in an array
map. And I want all users can read the information in the map, without
changing the capacity of them. As the information is iunsensitive,
normal users can read it. This make publish-consume mode possible,
the eBPF program is publisher and the user space program is consumer.

So this aim can be achieve, if we can control the access of maps as a
file. There are many ways I thought, and I choosed one to implement:

While pining the map, add the inode that is created to a list on the
map. root can change the permission of the inode through the pin path.
Therefore, we can try to find the inode corresponding to current user
namespace in the list, and check whether user have permission to read
or write.

The steps can be:

1. create the map with BPF_F_UMODE flags, which imply that enable
   access control in this map.
2. load and pin the map on /sys/fs/bpf/xxx.
3. change the umode of /sys/fs/bpf/xxx with 'chmod 744 /sys/fs/bpf/xxx',
   therefor all user can read the map.

I'm not sure if there is already way to achieve this aim, this is just
a idea and the code is totally not ok (it will panic when unpin the map,
seems the usage of my RCU lock is wrong)

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/bpf.h      |  7 ++++
 include/uapi/linux/bpf.h |  1 +
 kernel/bpf/arraymap.c    |  2 +-
 kernel/bpf/inode.c       | 60 +++++++++++++++++++++++++++++++---
 kernel/bpf/syscall.c     | 69 +++++++++++++++++++++++++++++++++++++---
 5 files changed, 130 insertions(+), 9 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index be94833d390a..34cc4f99df49 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -190,6 +190,11 @@ struct bpf_map_off_arr {
 	u8 field_sz[BPF_MAP_OFF_ARR_MAX];
 };
 
+struct bpf_map_inode {
+	struct list_head list;
+	struct inode *inode;
+};
+
 struct bpf_map {
 	/* The first two cachelines with read-mostly members of which some
 	 * are also accessed in fast-path (e.g. ops, max_entries).
@@ -205,6 +210,7 @@ struct bpf_map {
 	u32 max_entries;
 	u64 map_extra; /* any per-map-type extra fields */
 	u32 map_flags;
+	struct list_head inode_list;
 	int spin_lock_off; /* >=0 valid offset, <0 error */
 	struct bpf_map_value_off *kptr_off_tab;
 	int timer_off; /* >=0 valid offset, <0 error */
@@ -2345,5 +2351,6 @@ bool btf_id_set_contains(const struct btf_id_set *set, u32 id);
 int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 			u32 **bin_buf, u32 num_args);
 void bpf_bprintf_cleanup(void);
+int bpf_map_permission(struct bpf_map *map, int flags);
 
 #endif /* _LINUX_BPF_H */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 444fe6f1cf35..f5a47ca486d8 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1225,6 +1225,7 @@ enum {
 
 /* Create a map that is suitable to be an inner map with dynamic max entries */
 	BPF_F_INNER_MAP		= (1U << 12),
+	BPF_F_UMODE		= (1U << 13),
 };
 
 /* Flags for BPF_PROG_QUERY. */
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index b3bf31fd9458..9e00634070b0 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -17,7 +17,7 @@
 
 #define ARRAY_CREATE_FLAG_MASK \
 	(BPF_F_NUMA_NODE | BPF_F_MMAPABLE | BPF_F_ACCESS_MASK | \
-	 BPF_F_PRESERVE_ELEMS | BPF_F_INNER_MAP)
+	 BPF_F_PRESERVE_ELEMS | BPF_F_INNER_MAP | BPF_F_UMODE)
 
 static void bpf_array_free_percpu(struct bpf_array *array)
 {
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 4f841e16779e..bfe3507fdefd 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -334,6 +334,8 @@ static int bpf_mkobj_ops(struct dentry *dentry, umode_t mode, void *raw,
 {
 	struct inode *dir = dentry->d_parent->d_inode;
 	struct inode *inode = bpf_get_inode(dir->i_sb, dir, mode);
+	struct bpf_map_inode *map_inode;
+	struct bpf_map *map;
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
@@ -341,6 +343,19 @@ static int bpf_mkobj_ops(struct dentry *dentry, umode_t mode, void *raw,
 	inode->i_fop = fops;
 	inode->i_private = raw;
 
+	if (iops != &bpf_map_iops)
+		goto out;
+
+	map = raw;
+	map_inode = kmalloc(sizeof(*map_inode), GFP_KERNEL);
+	if (!map_inode) {
+		free_inode_nonrcu(inode);
+		return -ENOMEM;
+	}
+	map_inode->inode = inode;
+	list_add_rcu(&map_inode->list, &map->inode_list);
+
+out:
 	bpf_dentry_finalize(dentry, inode, dir);
 	return 0;
 }
@@ -542,14 +557,26 @@ int bpf_obj_get_user(const char __user *pathname, int flags)
 	if (IS_ERR(raw))
 		return PTR_ERR(raw);
 
-	if (type == BPF_TYPE_PROG)
+	if (type != BPF_TYPE_MAP && !bpf_capable())
+		return -EPERM;
+
+	switch (type) {
+	case BPF_TYPE_PROG:
 		ret = bpf_prog_new_fd(raw);
-	else if (type == BPF_TYPE_MAP)
+		break;
+	case BPF_TYPE_MAP:
+		if (bpf_map_permission(raw, f_flags)) {
+			bpf_any_put(raw, type);
+			return -EPERM;
+		}
 		ret = bpf_map_new_fd(raw, f_flags);
-	else if (type == BPF_TYPE_LINK)
+		break;
+	case BPF_TYPE_LINK:
 		ret = (f_flags != O_RDWR) ? -EINVAL : bpf_link_new_fd(raw);
-	else
+		break;
+	default:
 		return -ENOENT;
+	}
 
 	if (ret < 0)
 		bpf_any_put(raw, type);
@@ -610,6 +637,27 @@ static int bpf_show_options(struct seq_file *m, struct dentry *root)
 	return 0;
 }
 
+static void bpf_map_inode_remove(struct bpf_map *map, struct inode *inode)
+{
+	struct bpf_map_inode *map_inode;
+
+	if (!(map->map_flags & BPF_F_UMODE))
+		return;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(map_inode, &map->inode_list, list) {
+		if (map_inode->inode == inode)
+			goto found;
+	}
+	rcu_read_unlock();
+	return;
+found:
+	rcu_read_unlock();
+	list_del_rcu(&map_inode->list);
+	synchronize_rcu();
+	kfree(map_inode);
+}
+
 static void bpf_free_inode(struct inode *inode)
 {
 	enum bpf_type type;
@@ -618,6 +666,10 @@ static void bpf_free_inode(struct inode *inode)
 		kfree(inode->i_link);
 	if (!bpf_inode_type(inode, &type))
 		bpf_any_put(inode->i_private, type);
+
+	if (type == BPF_TYPE_MAP)
+		bpf_map_inode_remove(inode->i_private, inode);
+
 	free_inode_nonrcu(inode);
 }
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e0aead17dff4..1fd9b22e95ff 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -586,6 +586,16 @@ void bpf_map_free_kptrs(struct bpf_map *map, void *map_value)
 	}
 }
 
+static void bpf_map_inode_release(struct bpf_map *map)
+{
+	struct bpf_map_inode *cur, *prev;
+
+	list_for_each_entry_safe(cur, prev, &map->inode_list, list) {
+		list_del(&cur->list);
+		kfree(cur);
+	}
+}
+
 /* called from workqueue */
 static void bpf_map_free_deferred(struct work_struct *work)
 {
@@ -594,6 +604,8 @@ static void bpf_map_free_deferred(struct work_struct *work)
 	security_bpf_map_free(map);
 	kfree(map->off_arr);
 	bpf_map_release_memcg(map);
+	bpf_map_inode_release(map);
+
 	/* implementation dependent freeing, map_free callback also does
 	 * bpf_map_free_kptr_off_tab, if needed.
 	 */
@@ -1092,6 +1104,7 @@ static int map_create(union bpf_attr *attr)
 	atomic64_set(&map->usercnt, 1);
 	mutex_init(&map->freeze_mutex);
 	spin_lock_init(&map->owner.lock);
+	INIT_LIST_HEAD(&map->inode_list);
 
 	map->spin_lock_off = -EINVAL;
 	map->timer_off = -EINVAL;
@@ -3707,6 +3720,30 @@ static int bpf_prog_get_fd_by_id(const union bpf_attr *attr)
 	return fd;
 }
 
+int bpf_map_permission(struct bpf_map *map, int flags)
+{
+	struct bpf_map_inode *map_inode;
+	struct user_namespace *ns;
+
+	if (capable(CAP_SYS_ADMIN))
+		return 0;
+
+	if (!(map->map_flags & BPF_F_UMODE))
+		return -1;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(map_inode, &map->inode_list, list) {
+		ns = map_inode->inode->i_sb->s_user_ns;
+		if (ns == current_user_ns())
+			goto found;
+	}
+	rcu_read_unlock();
+	return -1;
+found:
+	rcu_read_unlock();
+	return inode_permission(ns, map_inode->inode, ACC_MODE(flags));
+}
+
 #define BPF_MAP_GET_FD_BY_ID_LAST_FIELD open_flags
 
 static int bpf_map_get_fd_by_id(const union bpf_attr *attr)
@@ -3720,9 +3757,6 @@ static int bpf_map_get_fd_by_id(const union bpf_attr *attr)
 	    attr->open_flags & ~BPF_OBJ_FLAG_MASK)
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	f_flags = bpf_get_file_flag(attr->open_flags);
 	if (f_flags < 0)
 		return f_flags;
@@ -3738,6 +3772,11 @@ static int bpf_map_get_fd_by_id(const union bpf_attr *attr)
 	if (IS_ERR(map))
 		return PTR_ERR(map);
 
+	if (bpf_map_permission(map, f_flags)) {
+		bpf_map_put_with_uref(map);
+		return -EPERM;
+	}
+
 	fd = bpf_map_new_fd(map, f_flags);
 	if (fd < 0)
 		bpf_map_put_with_uref(map);
@@ -4844,12 +4883,34 @@ static int bpf_prog_bind_map(union bpf_attr *attr)
 	return ret;
 }
 
+static inline bool is_map_ops_cmd(int cmd)
+{
+	switch (cmd) {
+	case BPF_MAP_LOOKUP_ELEM:
+	case BPF_MAP_UPDATE_ELEM:
+	case BPF_MAP_DELETE_ELEM:
+	case BPF_MAP_GET_NEXT_KEY:
+	case BPF_MAP_FREEZE:
+	case BPF_OBJ_GET:
+	case BPF_MAP_LOOKUP_AND_DELETE_ELEM:
+	case BPF_MAP_LOOKUP_BATCH:
+	case BPF_MAP_LOOKUP_AND_DELETE_BATCH:
+	case BPF_MAP_UPDATE_BATCH:
+	case BPF_MAP_DELETE_BATCH:
+	case BPF_OBJ_GET_INFO_BY_FD:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int __sys_bpf(int cmd, bpfptr_t uattr, unsigned int size)
 {
 	union bpf_attr attr;
 	int err;
 
-	if (sysctl_unprivileged_bpf_disabled && !bpf_capable())
+	if (sysctl_unprivileged_bpf_disabled && !bpf_capable() &&
+	    !is_map_ops_cmd(cmd))
 		return -EPERM;
 
 	err = bpf_check_uarg_tail_zero(uattr, sizeof(attr), size);
-- 
2.36.1

