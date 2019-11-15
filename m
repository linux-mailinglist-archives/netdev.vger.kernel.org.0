Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F28AFD47F
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 06:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfKOFno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 00:43:44 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45359 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfKOFnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 00:43:43 -0500
Received: by mail-qk1-f195.google.com with SMTP id q70so7183993qke.12;
        Thu, 14 Nov 2019 21:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5kO62DEWrUevVGmGRvxNJbGuiR7eiqhQGCoFZHvJ8bw=;
        b=UezsTkcSsokMIYZ3C3ggGM7LdPFsaxg3RHfV1MgMZNE9ivR3azAAP/l2Gs3kOVhtht
         dY3SCs0Sdm329y+9yO43ddL9BSmFE27/EAQVNo2k66m+Hku2QDgRd0nHmEjRuzKcf6CU
         Ltyz2qJDaMP25/qCqSYXv6WQDLM3TeFE6CDQrJY//DT1L9iPdVUZIg2DI2X+EF9oB6Yj
         s00cNifX8w8gFxkezWjsDzuKEg747l4RhRTPPHl8pKgqwPOKlCRuPybg0Fw2vy5ladDW
         oa6X3ShGxmyVwf41LFnPsgUV5kYvONR6AwFNkvrmhETyIGHuw72qsLK0t50jqW5/O5Qf
         vXrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5kO62DEWrUevVGmGRvxNJbGuiR7eiqhQGCoFZHvJ8bw=;
        b=cNQ6TrcCJ8KhII/mNcYXEgMQzaSau8eySPLwnveVl0OcyClCD9YOWgnniG9GQ8/Mcv
         OrgZF0k2LEXtpOW9EL+7IfQWFB3ZfaU7lkgPmiVAMO5D+yGJwCtTT17Jxx/FZ5SNL3lW
         wjzcrpG3jI2NB1X0tiYmP7rvnSDWoWOSlxk9/Px8XUJFmUzvUHGnBeqqdWpi9VFOU4gA
         nGWVLZE/Gak27dYH8AXIREazjAuSi3lSoq0oDy9wSi4a2wmPdG5N4zuhsTXJKR4LAxnS
         Eg9BpqmEI7H+tNSxaPfMtPR6OsB24xen5bwuO6aHtq/7F+NISjRwbOxtzMNAYNIvwmVm
         vdMg==
X-Gm-Message-State: APjAAAU+M/Vz6yMXQmi3QFAlK/KQ0FjV7muCVvNoWqXcoiViRTiROO4y
        cUUY8Ihq5EbTdfqysB13rI3vKNvlrsh7VoMdwAs=
X-Google-Smtp-Source: APXvYqx9wtRQyQ6YIJYdvV4ld/NfZBoaeiX9U8VCfkFP7l29hlPKDUylfGGh8nC/BYlKVCw9H3d2Z1/7MyDcHKEQkrY=
X-Received: by 2002:a37:b3c4:: with SMTP id c187mr11357017qkf.36.1573796620532;
 Thu, 14 Nov 2019 21:43:40 -0800 (PST)
MIME-Version: 1.0
References: <20191115040225.2147245-1-andriin@fb.com> <20191115040225.2147245-3-andriin@fb.com>
 <20191115044518.sqh3y3bwtjfp5zex@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbE+1s_4=jpWEgNj+T0HyMXt1yjiRncq4sB3vfx6A3Sxw@mail.gmail.com> <20191115050824.76gmttbxd32jnnhb@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191115050824.76gmttbxd32jnnhb@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 Nov 2019 21:43:29 -0800
Message-ID: <CAEf4BzbsJSEgnW14F7Xt+E911NC_ZqEUeLg0pxrUbaoj1Zzkyg@mail.gmail.com>
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

On Thu, Nov 14, 2019 at 9:08 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Nov 14, 2019 at 09:05:26PM -0800, Andrii Nakryiko wrote:
> > On Thu, Nov 14, 2019 at 8:45 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Thu, Nov 14, 2019 at 08:02:23PM -0800, Andrii Nakryiko wrote:
> > > > Add ability to memory-map contents of BPF array map. This is extremely useful
> > > > for working with BPF global data from userspace programs. It allows to avoid
> > > > typical bpf_map_{lookup,update}_elem operations, improving both performance
> > > > and usability.
> > > >
> > > > There had to be special considerations for map freezing, to avoid having
> > > > writable memory view into a frozen map. To solve this issue, map freezing and
> > > > mmap-ing is happening under mutex now:
> > > >   - if map is already frozen, no writable mapping is allowed;
> > > >   - if map has writable memory mappings active (accounted in map->writecnt),
> > > >     map freezing will keep failing with -EBUSY;
> > > >   - once number of writable memory mappings drops to zero, map freezing can be
> > > >     performed again.
> > > >
> > > > Only non-per-CPU plain arrays are supported right now. Maps with spinlocks
> > > > can't be memory mapped either.
> > > >
> > > > For BPF_F_MMAPABLE array, memory allocation has to be done through vmalloc()
> > > > to be mmap()'able. We also need to make sure that array data memory is
> > > > page-sized and page-aligned, so we over-allocate memory in such a way that
> > > > struct bpf_array is at the end of a single page of memory with array->value
> > > > being aligned with the start of the second page. On deallocation we need to
> > > > accomodate this memory arrangement to free vmalloc()'ed memory correctly.
> > > >
> > > > One important consideration regarding how memory-mapping subsystem functions.
> > > > Memory-mapping subsystem provides few optional callbacks, among them open()
> > > > and close().  close() is called for each memory region that is unmapped, so
> > > > that users can decrease their reference counters and free up resources, if
> > > > necessary. open() is *almost* symmetrical: it's called for each memory region
> > > > that is being mapped, **except** the very first one. So bpf_map_mmap does
> > > > initial refcnt bump, while open() will do any extra ones after that. Thus
> > > > number of close() calls is equal to number of open() calls plus one more.
> > > >
> > > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > > Cc: Rik van Riel <riel@surriel.com>
> > > > Acked-by: Song Liu <songliubraving@fb.com>
> > > > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---
> > > >  include/linux/bpf.h            | 11 ++--
> > > >  include/linux/vmalloc.h        |  1 +
> > > >  include/uapi/linux/bpf.h       |  3 ++
> > > >  kernel/bpf/arraymap.c          | 59 +++++++++++++++++---
> > > >  kernel/bpf/syscall.c           | 99 ++++++++++++++++++++++++++++++++--
> > > >  mm/vmalloc.c                   | 20 +++++++
> > > >  tools/include/uapi/linux/bpf.h |  3 ++
> > > >  7 files changed, 184 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > index 6fbe599fb977..8021fce98868 100644
> > > > --- a/include/linux/bpf.h
> > > > +++ b/include/linux/bpf.h
> > > > @@ -12,6 +12,7 @@
> > > >  #include <linux/err.h>
> > > >  #include <linux/rbtree_latch.h>
> > > >  #include <linux/numa.h>
> > > > +#include <linux/mm_types.h>
> > > >  #include <linux/wait.h>
> > > >  #include <linux/u64_stats_sync.h>
> > > >
> > > > @@ -66,6 +67,7 @@ struct bpf_map_ops {
> > > >                                    u64 *imm, u32 off);
> > > >       int (*map_direct_value_meta)(const struct bpf_map *map,
> > > >                                    u64 imm, u32 *off);
> > > > +     int (*map_mmap)(struct bpf_map *map, struct vm_area_struct *vma);
> > > >  };
> > > >
> > > >  struct bpf_map_memory {
> > > > @@ -94,9 +96,10 @@ struct bpf_map {
> > > >       u32 btf_value_type_id;
> > > >       struct btf *btf;
> > > >       struct bpf_map_memory memory;
> > > > +     char name[BPF_OBJ_NAME_LEN];
> > > >       bool unpriv_array;
> > > > -     bool frozen; /* write-once */
> > > > -     /* 48 bytes hole */
> > > > +     bool frozen; /* write-once; write-protected by freeze_mutex */
> > > > +     /* 22 bytes hole */
> > > >
> > > >       /* The 3rd and 4th cacheline with misc members to avoid false sharing
> > > >        * particularly with refcounting.
> > > > @@ -104,7 +107,8 @@ struct bpf_map {
> > > >       atomic64_t refcnt ____cacheline_aligned;
> > > >       atomic64_t usercnt;
> > > >       struct work_struct work;
> > > > -     char name[BPF_OBJ_NAME_LEN];
> > > > +     struct mutex freeze_mutex;
> > > > +     u64 writecnt; /* writable mmap cnt; protected by freeze_mutex */
> > > >  };
> > >
> > > Can the mutex be moved into bpf_array instead of being in bpf_map that is
> > > shared across all map types?
> >
> > No, freezing logic is common to all maps. Same for writecnt and
> > mmap()-ing overall.
>
> How mmap is going to work for hash map ? and for prog_array?
>

It probably won't. But one day we might have hash map using open
adressing, which will be more prone to memory-mapping. Or, say, some
sort of non-per-CPU ring buffer would be a good candidate as well. It
doesn't seem like a good idea to restrict mmap()-ability to just array
for no good reason.

But speaking about freeze_mutex specifically. It's to coordinate
writable memory-mapping and frozen flag. Even if we make
memory-mapping bpf_array specific, map->frozen is generic flag and
handled in syscall.c generically, so I just can't protect it only from
bpf_array side.
