Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 319E0FD3E7
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 06:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfKOFFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 00:05:39 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41322 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfKOFFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 00:05:38 -0500
Received: by mail-qt1-f194.google.com with SMTP id o3so9545639qtj.8;
        Thu, 14 Nov 2019 21:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EqDqma57lYvdyFUqFupKYh3YphOeT91M3cJ458AdZgk=;
        b=U684VuoX8UT5ow5xKyPtDYmMy2Ks7QOcy8WoffMwQMNa3n0omZjgEUJS4e1xNazOva
         AwwqKjjvKy/HYISxDuuRcIWIcLgGt9nzTsKxA/NMUdGNVzwaQijkPxUYtdVpt+g+83BK
         TCvCRdacOf9ihN/9W105uEBLbVUmCkxvb9gUujGR4lF9g9NK9PxlEmVpRnN4jLXXo6KL
         I5SQmnmIRFFnqh0HZpoGrvowB92LRC/VwibuKaRNGuLHPXELEw9IjV9C7dOQ5AZdmIqh
         kr0kTdcgNAdOLNKx5dL+a7uYUgCkAVaeSCkCg9PkqNIvBLIgujhhiGUcq+4ZYmJASbVj
         bSaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EqDqma57lYvdyFUqFupKYh3YphOeT91M3cJ458AdZgk=;
        b=NhFq6YVpPFN7DG/BDpyDqPuLj4C/ToJ0lWqHVcnzN6khK+9v8Mv3WKeMCQergc0BCC
         B5J4md4UNOv8VSbYpssN81YVPjdDKzUoZvRQVvVDIo3bKMXOUuPQy4W+r5fAX8HuaVTk
         EKTiwrhE4Sn2Hi/QPxyQEtAaIUVb8eWdy3YqLr1Xf6DvNnK8DqeILgVeo5QYs4Y3Rccj
         dR7ijs9DtYtpSLB+XriwoBu9mw73v+NCI3mW/EAj/h7RgN9ly/iq2W6qmCmVCn2u9fS9
         R9qOWFLnktITCGzKeYUCfi58FdcCwuu82b/N0Q0K93ZtGmuV9BjBo/wGHY0xlvN4GnVc
         XFSA==
X-Gm-Message-State: APjAAAW6fNEj8jdzZDuQNkuj4JhOBBgXFxuxBqP061DiMnzE4V28oub0
        kVllIgE576m/COs0tmoNQlf267xJT7xCzWSAba8=
X-Google-Smtp-Source: APXvYqyvZ8osBMM5Qj57yS+cG4MJYrIidpej6k0hlDSLbYkdsL/7D3CdzQXsla9TMoyKVnB+AlMctefPbWrtCt4TZIA=
X-Received: by 2002:ac8:199d:: with SMTP id u29mr11570093qtj.93.1573794337018;
 Thu, 14 Nov 2019 21:05:37 -0800 (PST)
MIME-Version: 1.0
References: <20191115040225.2147245-1-andriin@fb.com> <20191115040225.2147245-3-andriin@fb.com>
 <20191115044518.sqh3y3bwtjfp5zex@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191115044518.sqh3y3bwtjfp5zex@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 Nov 2019 21:05:26 -0800
Message-ID: <CAEf4BzbE+1s_4=jpWEgNj+T0HyMXt1yjiRncq4sB3vfx6A3Sxw@mail.gmail.com>
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

On Thu, Nov 14, 2019 at 8:45 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Nov 14, 2019 at 08:02:23PM -0800, Andrii Nakryiko wrote:
> > Add ability to memory-map contents of BPF array map. This is extremely useful
> > for working with BPF global data from userspace programs. It allows to avoid
> > typical bpf_map_{lookup,update}_elem operations, improving both performance
> > and usability.
> >
> > There had to be special considerations for map freezing, to avoid having
> > writable memory view into a frozen map. To solve this issue, map freezing and
> > mmap-ing is happening under mutex now:
> >   - if map is already frozen, no writable mapping is allowed;
> >   - if map has writable memory mappings active (accounted in map->writecnt),
> >     map freezing will keep failing with -EBUSY;
> >   - once number of writable memory mappings drops to zero, map freezing can be
> >     performed again.
> >
> > Only non-per-CPU plain arrays are supported right now. Maps with spinlocks
> > can't be memory mapped either.
> >
> > For BPF_F_MMAPABLE array, memory allocation has to be done through vmalloc()
> > to be mmap()'able. We also need to make sure that array data memory is
> > page-sized and page-aligned, so we over-allocate memory in such a way that
> > struct bpf_array is at the end of a single page of memory with array->value
> > being aligned with the start of the second page. On deallocation we need to
> > accomodate this memory arrangement to free vmalloc()'ed memory correctly.
> >
> > One important consideration regarding how memory-mapping subsystem functions.
> > Memory-mapping subsystem provides few optional callbacks, among them open()
> > and close().  close() is called for each memory region that is unmapped, so
> > that users can decrease their reference counters and free up resources, if
> > necessary. open() is *almost* symmetrical: it's called for each memory region
> > that is being mapped, **except** the very first one. So bpf_map_mmap does
> > initial refcnt bump, while open() will do any extra ones after that. Thus
> > number of close() calls is equal to number of open() calls plus one more.
> >
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Rik van Riel <riel@surriel.com>
> > Acked-by: Song Liu <songliubraving@fb.com>
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  include/linux/bpf.h            | 11 ++--
> >  include/linux/vmalloc.h        |  1 +
> >  include/uapi/linux/bpf.h       |  3 ++
> >  kernel/bpf/arraymap.c          | 59 +++++++++++++++++---
> >  kernel/bpf/syscall.c           | 99 ++++++++++++++++++++++++++++++++--
> >  mm/vmalloc.c                   | 20 +++++++
> >  tools/include/uapi/linux/bpf.h |  3 ++
> >  7 files changed, 184 insertions(+), 12 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 6fbe599fb977..8021fce98868 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -12,6 +12,7 @@
> >  #include <linux/err.h>
> >  #include <linux/rbtree_latch.h>
> >  #include <linux/numa.h>
> > +#include <linux/mm_types.h>
> >  #include <linux/wait.h>
> >  #include <linux/u64_stats_sync.h>
> >
> > @@ -66,6 +67,7 @@ struct bpf_map_ops {
> >                                    u64 *imm, u32 off);
> >       int (*map_direct_value_meta)(const struct bpf_map *map,
> >                                    u64 imm, u32 *off);
> > +     int (*map_mmap)(struct bpf_map *map, struct vm_area_struct *vma);
> >  };
> >
> >  struct bpf_map_memory {
> > @@ -94,9 +96,10 @@ struct bpf_map {
> >       u32 btf_value_type_id;
> >       struct btf *btf;
> >       struct bpf_map_memory memory;
> > +     char name[BPF_OBJ_NAME_LEN];
> >       bool unpriv_array;
> > -     bool frozen; /* write-once */
> > -     /* 48 bytes hole */
> > +     bool frozen; /* write-once; write-protected by freeze_mutex */
> > +     /* 22 bytes hole */
> >
> >       /* The 3rd and 4th cacheline with misc members to avoid false sharing
> >        * particularly with refcounting.
> > @@ -104,7 +107,8 @@ struct bpf_map {
> >       atomic64_t refcnt ____cacheline_aligned;
> >       atomic64_t usercnt;
> >       struct work_struct work;
> > -     char name[BPF_OBJ_NAME_LEN];
> > +     struct mutex freeze_mutex;
> > +     u64 writecnt; /* writable mmap cnt; protected by freeze_mutex */
> >  };
>
> Can the mutex be moved into bpf_array instead of being in bpf_map that is
> shared across all map types?

No, freezing logic is common to all maps. Same for writecnt and
mmap()-ing overall.

> If so then can you reuse the mutex that Daniel is adding in his patch 6/8
> of tail_call series? Not sure what would the right name for such mutex.
> It will be used for your map_freeze logic and for Daniel's text_poke.
>
