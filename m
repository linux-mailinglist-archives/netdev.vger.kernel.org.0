Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54154FE2EE
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 17:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfKOQhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 11:37:09 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36584 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727507AbfKOQhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 11:37:09 -0500
Received: by mail-qk1-f193.google.com with SMTP id d13so8587265qko.3;
        Fri, 15 Nov 2019 08:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aqI3Yr3+FqQulTLIKutxnKDnXzPBdalcdN9m6Lmd0aE=;
        b=GP7PcIiAHLN2PcNRNtJQbWBc2w+uMUcUz2D5mpudWtpFWva49Xpeft6HsBHEo65bnT
         vsDs/58Pr1PvJJGrswW2d38PQTTM7ZZ/Zm/xtVAcOJPVLpEOxc94UqbPDa/Iey+KWO/z
         XNpOGD6OG/OPyhvFDfzhNRtFchXpz0R6RcyQmDWTflVGdk+gAcbZGek4mplR8RBsbdPr
         KhgpFeJX0n047w6JyWs+lX8fs/I5O05p2Mj+iWbU2GVj5d81neZ6rxK2joLx7ALzSsgu
         8sVmcrHjjHDiF6SDO5dCdPTDw39Y4jp1m4n/4auJiJk3B+LLyvtskXxKlKgGRIGYThlq
         a5JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aqI3Yr3+FqQulTLIKutxnKDnXzPBdalcdN9m6Lmd0aE=;
        b=XhLGga122XbQRY1n3pxs5ZZBdzAYCGiLH2n+VYgziEz12Z7UWjknCLcmsAAjkuedcI
         fJ9q1M7FyN+Jsw2tbq9szcHTf5wq5ScjRxGKxBx1SXIBUMaDeXrwyYBbSJzCG2RLK5AD
         OkAd+pj9FR/0rKlOkXRdAXZNYp8+/mcCnL5rQqPzLClmd3zZvzJySNoXWVCl2k2Q066+
         eOMoPwYOBW/1lNiy3xxH/7K00Autei2L74IPzCrQVqURaaY4TdAzvkE/MVcHOkKXcc2P
         lqjjAAj7+WO8WQLYOB8pWRRhIjqZHdM3K3sCb8D2DgDg1QAxYrKCsvNuRLYKyVPKm83C
         3I4A==
X-Gm-Message-State: APjAAAV6CHUO3N9LuSCn2aU1PlWKYPO2vTozxvW5DhuduGvNeKSc+Mc7
        ImABQch9QxoYnFsZjSTxKRWXeFgEnOdOvoyoz4lzidEz
X-Google-Smtp-Source: APXvYqzCLd+yy0aHvIIAAmi4/QupkISF5LPPS06OlUvmxOeGv4pwKuScVHxJTOa/0oQsOCwrYoHZwAaIMWB1wecx9Ws=
X-Received: by 2002:a37:aa8b:: with SMTP id t133mr481416qke.449.1573835827592;
 Fri, 15 Nov 2019 08:37:07 -0800 (PST)
MIME-Version: 1.0
References: <20191115040225.2147245-1-andriin@fb.com> <20191115040225.2147245-3-andriin@fb.com>
 <20191115044518.sqh3y3bwtjfp5zex@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbE+1s_4=jpWEgNj+T0HyMXt1yjiRncq4sB3vfx6A3Sxw@mail.gmail.com>
 <20191115050824.76gmttbxd32jnnhb@ast-mbp.dhcp.thefacebook.com> <CAEf4BzbsJSEgnW14F7Xt+E911NC_ZqEUeLg0pxrUbaoj1Zzkyg@mail.gmail.com>
In-Reply-To: <CAEf4BzbsJSEgnW14F7Xt+E911NC_ZqEUeLg0pxrUbaoj1Zzkyg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 15 Nov 2019 08:36:56 -0800
Message-ID: <CAEf4Bzat=GDcZWWpGkPWYBJvpKA=PvhhP0QZrEcOOkQz3WvnaA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: add mmap() support for BPF_MAP_TYPE_ARRAY
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@surriel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 9:43 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Nov 14, 2019 at 9:08 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Nov 14, 2019 at 09:05:26PM -0800, Andrii Nakryiko wrote:
> > > On Thu, Nov 14, 2019 at 8:45 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Thu, Nov 14, 2019 at 08:02:23PM -0800, Andrii Nakryiko wrote:
> > > > > Add ability to memory-map contents of BPF array map. This is extremely useful
> > > > > for working with BPF global data from userspace programs. It allows to avoid
> > > > > typical bpf_map_{lookup,update}_elem operations, improving both performance
> > > > > and usability.
> > > > >
> > > > > There had to be special considerations for map freezing, to avoid having
> > > > > writable memory view into a frozen map. To solve this issue, map freezing and
> > > > > mmap-ing is happening under mutex now:
> > > > >   - if map is already frozen, no writable mapping is allowed;
> > > > >   - if map has writable memory mappings active (accounted in map->writecnt),
> > > > >     map freezing will keep failing with -EBUSY;
> > > > >   - once number of writable memory mappings drops to zero, map freezing can be
> > > > >     performed again.
> > > > >
> > > > > Only non-per-CPU plain arrays are supported right now. Maps with spinlocks
> > > > > can't be memory mapped either.
> > > > >
> > > > > For BPF_F_MMAPABLE array, memory allocation has to be done through vmalloc()
> > > > > to be mmap()'able. We also need to make sure that array data memory is
> > > > > page-sized and page-aligned, so we over-allocate memory in such a way that
> > > > > struct bpf_array is at the end of a single page of memory with array->value
> > > > > being aligned with the start of the second page. On deallocation we need to
> > > > > accomodate this memory arrangement to free vmalloc()'ed memory correctly.
> > > > >
> > > > > One important consideration regarding how memory-mapping subsystem functions.
> > > > > Memory-mapping subsystem provides few optional callbacks, among them open()
> > > > > and close().  close() is called for each memory region that is unmapped, so
> > > > > that users can decrease their reference counters and free up resources, if
> > > > > necessary. open() is *almost* symmetrical: it's called for each memory region
> > > > > that is being mapped, **except** the very first one. So bpf_map_mmap does
> > > > > initial refcnt bump, while open() will do any extra ones after that. Thus
> > > > > number of close() calls is equal to number of open() calls plus one more.
> > > > >
> > > > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > > > Cc: Rik van Riel <riel@surriel.com>
> > > > > Acked-by: Song Liu <songliubraving@fb.com>
> > > > > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > > ---
> > > > >  include/linux/bpf.h            | 11 ++--
> > > > >  include/linux/vmalloc.h        |  1 +
> > > > >  include/uapi/linux/bpf.h       |  3 ++
> > > > >  kernel/bpf/arraymap.c          | 59 +++++++++++++++++---
> > > > >  kernel/bpf/syscall.c           | 99 ++++++++++++++++++++++++++++++++--
> > > > >  mm/vmalloc.c                   | 20 +++++++
> > > > >  tools/include/uapi/linux/bpf.h |  3 ++
> > > > >  7 files changed, 184 insertions(+), 12 deletions(-)
> > > > >
> > > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > > index 6fbe599fb977..8021fce98868 100644
> > > > > --- a/include/linux/bpf.h
> > > > > +++ b/include/linux/bpf.h
> > > > > @@ -12,6 +12,7 @@
> > > > >  #include <linux/err.h>
> > > > >  #include <linux/rbtree_latch.h>
> > > > >  #include <linux/numa.h>
> > > > > +#include <linux/mm_types.h>
> > > > >  #include <linux/wait.h>
> > > > >  #include <linux/u64_stats_sync.h>
> > > > >
> > > > > @@ -66,6 +67,7 @@ struct bpf_map_ops {
> > > > >                                    u64 *imm, u32 off);
> > > > >       int (*map_direct_value_meta)(const struct bpf_map *map,
> > > > >                                    u64 imm, u32 *off);
> > > > > +     int (*map_mmap)(struct bpf_map *map, struct vm_area_struct *vma);
> > > > >  };
> > > > >
> > > > >  struct bpf_map_memory {
> > > > > @@ -94,9 +96,10 @@ struct bpf_map {
> > > > >       u32 btf_value_type_id;
> > > > >       struct btf *btf;
> > > > >       struct bpf_map_memory memory;
> > > > > +     char name[BPF_OBJ_NAME_LEN];
> > > > >       bool unpriv_array;
> > > > > -     bool frozen; /* write-once */
> > > > > -     /* 48 bytes hole */
> > > > > +     bool frozen; /* write-once; write-protected by freeze_mutex */
> > > > > +     /* 22 bytes hole */
> > > > >
> > > > >       /* The 3rd and 4th cacheline with misc members to avoid false sharing
> > > > >        * particularly with refcounting.
> > > > > @@ -104,7 +107,8 @@ struct bpf_map {
> > > > >       atomic64_t refcnt ____cacheline_aligned;
> > > > >       atomic64_t usercnt;
> > > > >       struct work_struct work;
> > > > > -     char name[BPF_OBJ_NAME_LEN];
> > > > > +     struct mutex freeze_mutex;
> > > > > +     u64 writecnt; /* writable mmap cnt; protected by freeze_mutex */
> > > > >  };
> > > >
> > > > Can the mutex be moved into bpf_array instead of being in bpf_map that is
> > > > shared across all map types?
> > >
> > > No, freezing logic is common to all maps. Same for writecnt and
> > > mmap()-ing overall.
> >
> > How mmap is going to work for hash map ? and for prog_array?
> >
>
> It probably won't. But one day we might have hash map using open
> adressing, which will be more prone to memory-mapping. Or, say, some
> sort of non-per-CPU ring buffer would be a good candidate as well. It
> doesn't seem like a good idea to restrict mmap()-ability to just array
> for no good reason.
>
> But speaking about freeze_mutex specifically. It's to coordinate
> writable memory-mapping and frozen flag. Even if we make
> memory-mapping bpf_array specific, map->frozen is generic flag and
> handled in syscall.c generically, so I just can't protect it only from
> bpf_array side.

Alternatively we can use spinlock. I don't think it's too ugly, tbh. See below.

From 0da495b911adad495857f1c0fc3596f1d06a705f Mon Sep 17 00:00:00 2001
From: Andrii Nakryiko <andriin@fb.com>
Date: Fri, 15 Nov 2019 08:32:43 -0800
Subject: [PATCH bpf-next] bpf: switch freeze locking to use spin_lock and save
 space

Switch to spin_lock in favor of mutex. Due to mmap-ing itself happening not
under spinlock, there needs to be an extra "correction" step for writecnt, if
mapping fails.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf.h  |  6 ++---
 kernel/bpf/syscall.c | 52 ++++++++++++++++++++++++--------------------
 2 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8021fce98868..ceaefd69c6bb 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -98,7 +98,7 @@ struct bpf_map {
     struct bpf_map_memory memory;
     char name[BPF_OBJ_NAME_LEN];
     bool unpriv_array;
-    bool frozen; /* write-once; write-protected by freeze_mutex */
+    bool frozen; /* write-once; write-protected by freeze_lock */
     /* 22 bytes hole */

     /* The 3rd and 4th cacheline with misc members to avoid false sharing
@@ -107,8 +107,8 @@ struct bpf_map {
     atomic64_t refcnt ____cacheline_aligned;
     atomic64_t usercnt;
     struct work_struct work;
-    struct mutex freeze_mutex;
-    u64 writecnt; /* writable mmap cnt; protected by freeze_mutex */
+    u64 writecnt; /* writable mmap cnt; protected by freeze_lock */
+    spinlock_t freeze_lock;
 };

 static inline bool map_value_has_spin_lock(const struct bpf_map *map)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 810e53990641..fc782ab06d57 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -448,9 +448,9 @@ static void bpf_map_mmap_open(struct vm_area_struct *vma)
     bpf_map_inc(map);

     if (vma->vm_flags & VM_WRITE) {
-        mutex_lock(&map->freeze_mutex);
+        spin_lock(&map->freeze_lock);
         map->writecnt++;
-        mutex_unlock(&map->freeze_mutex);
+        spin_unlock(&map->freeze_lock);
     }
 }

@@ -460,9 +460,9 @@ static void bpf_map_mmap_close(struct vm_area_struct *vma)
     struct bpf_map *map = vma->vm_file->private_data;

     if (vma->vm_flags & VM_WRITE) {
-        mutex_lock(&map->freeze_mutex);
+        spin_lock(&map->freeze_lock);
         map->writecnt--;
-        mutex_unlock(&map->freeze_mutex);
+        spin_unlock(&map->freeze_lock);
     }

     bpf_map_put(map);
@@ -484,28 +484,34 @@ static int bpf_map_mmap(struct file *filp,
struct vm_area_struct *vma)
     if (!(vma->vm_flags & VM_SHARED))
         return -EINVAL;

-    mutex_lock(&map->freeze_mutex);
-
+    spin_lock(&map->freeze_lock);
     if ((vma->vm_flags & VM_WRITE) && map->frozen) {
-        err = -EPERM;
-        goto out;
+        spin_unlock(&map->freeze_lock);
+        return -EPERM;
     }
-
+    /* speculatively increase writecnt assuming mmap will succeed */
+    if (vma->vm_flags & VM_WRITE)
+        map->writecnt++;
+    spin_unlock(&map->freeze_lock);
+
     /* set default open/close callbacks */
     vma->vm_ops = &bpf_map_default_vmops;
     vma->vm_private_data = map;

     err = map->ops->map_mmap(map, vma);
-    if (err)
-        goto out;
+    if (err) {
+        /* mmap failed, undo speculative writecnt increment */
+        if (vma->vm_flags & VM_WRITE) {
+            spin_lock(&map->freeze_lock);
+            map->writecnt--;
+            spin_unlock(&map->freeze_lock);
+        }
+        return err;
+    }

     bpf_map_inc(map);

-    if (vma->vm_flags & VM_WRITE)
-        map->writecnt++;
-out:
-    mutex_unlock(&map->freeze_mutex);
-    return err;
+    return 0;
 }

 const struct file_operations bpf_map_fops = {
@@ -661,7 +667,7 @@ static int map_create(union bpf_attr *attr)

     atomic64_set(&map->refcnt, 1);
     atomic64_set(&map->usercnt, 1);
-    mutex_init(&map->freeze_mutex);
+    spin_lock_init(&map->freeze_lock);

     if (attr->btf_key_type_id || attr->btf_value_type_id) {
         struct btf *btf;
@@ -1244,12 +1250,15 @@ static int map_freeze(const union bpf_attr *attr)
     if (CHECK_ATTR(BPF_MAP_FREEZE))
         return -EINVAL;

+    if (!capable(CAP_SYS_ADMIN))
+        return -EPERM;
+
     f = fdget(ufd);
     map = __bpf_map_get(f);
     if (IS_ERR(map))
         return PTR_ERR(map);

-    mutex_lock(&map->freeze_mutex);
+    spin_lock(&map->freeze_lock);

     if (map->writecnt) {
         err = -EBUSY;
@@ -1259,14 +1268,9 @@ static int map_freeze(const union bpf_attr *attr)
         err = -EBUSY;
         goto err_put;
     }
-    if (!capable(CAP_SYS_ADMIN)) {
-        err = -EPERM;
-        goto err_put;
-    }
-
     WRITE_ONCE(map->frozen, true);
 err_put:
-    mutex_unlock(&map->freeze_mutex);
+    spin_unlock(&map->freeze_lock);
     fdput(f);
     return err;
 }
-- 
2.17.1
