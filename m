Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6168FD3ED
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 06:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfKOFIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 00:08:30 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34236 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfKOFIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 00:08:30 -0500
Received: by mail-pf1-f193.google.com with SMTP id n13so5847187pff.1;
        Thu, 14 Nov 2019 21:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iWh/ycisXZpDOE9YA0LcfueobsifB2AMsxsAmJGfOdk=;
        b=ofk2APMvgmkUZ0SGLBq1AqTLWJx0jtL61HyUjyiBvaVQz5Gvjm9iBOwrtcmaB315Ak
         E+tjjWPNgZ/ftB5Sbpd/QlcLsoYiIFaDdr59BsUeaAAqL42MPzlb34Zj24+jTBYtXA6y
         uvVWxWBFMisO1nxO7ZEqqGaZ8oxd+Zw2PoEE6Q55rTAjJZZRSlKW4CVpxUy90gnoP2Av
         sK7kiqXteet1Qi6fcBuyMWxhNLRoGHQ6B2rEdtugoWRzJ9nDyf3UFNd+4dLTckgaLpA8
         mU1esbWfCFa2RjYdDShUANLRKJlHzhTYTDTha/X4XW87eIXLjY9ys5HjNILRxQxUStky
         DGPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iWh/ycisXZpDOE9YA0LcfueobsifB2AMsxsAmJGfOdk=;
        b=MZZN+74+MHVQBYJR62R13xA3fWN6Kqqdxm915Xy6Z2QhUOreuehVb6jL41cGYf67l0
         PfDtqjpSvf2jQPp2OYR0eu0nYnwORSvvfgYdCxHJJtNibFqZEoxcTS+6gh+gz1jtEwEn
         rL2xVxH4GOW4gxCaYVwBahSL5QSczNRclAzbHS9uWEI38DhKz/vkljV55WvNLIOgRwub
         HBCcHD434Qa1MIjsYnbzcq1ZUW5Jhq6pub7Pbx38pdjJpVdFLu1DMPifRgE78HJHT7FI
         OaYDQr0GOrIMiJeIS42MyUD9RCt52nf0rLpHFd7IiNAtDk22JKtjAxUm4I2THpyUpn0F
         ML1Q==
X-Gm-Message-State: APjAAAWIFkCkevzn3ske5hivvUKDCT4pE0KaOp9lGdGxMSehQojLT9V3
        rJWeqUiR7tSu5fDyegTEnHw=
X-Google-Smtp-Source: APXvYqyfUuf0+/1gWy88gaqxIqW//qzrmExpI0T8lsdNDeDBeSgO2yA4TZsAX2hhlgTeCXJb7UgTcQ==
X-Received: by 2002:a63:7c03:: with SMTP id x3mr14590175pgc.382.1573794509013;
        Thu, 14 Nov 2019 21:08:29 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::a328])
        by smtp.gmail.com with ESMTPSA id 125sm8510348pfu.136.2019.11.14.21.08.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 21:08:28 -0800 (PST)
Date:   Thu, 14 Nov 2019 21:08:25 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Message-ID: <20191115050824.76gmttbxd32jnnhb@ast-mbp.dhcp.thefacebook.com>
References: <20191115040225.2147245-1-andriin@fb.com>
 <20191115040225.2147245-3-andriin@fb.com>
 <20191115044518.sqh3y3bwtjfp5zex@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbE+1s_4=jpWEgNj+T0HyMXt1yjiRncq4sB3vfx6A3Sxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbE+1s_4=jpWEgNj+T0HyMXt1yjiRncq4sB3vfx6A3Sxw@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 09:05:26PM -0800, Andrii Nakryiko wrote:
> On Thu, Nov 14, 2019 at 8:45 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Nov 14, 2019 at 08:02:23PM -0800, Andrii Nakryiko wrote:
> > > Add ability to memory-map contents of BPF array map. This is extremely useful
> > > for working with BPF global data from userspace programs. It allows to avoid
> > > typical bpf_map_{lookup,update}_elem operations, improving both performance
> > > and usability.
> > >
> > > There had to be special considerations for map freezing, to avoid having
> > > writable memory view into a frozen map. To solve this issue, map freezing and
> > > mmap-ing is happening under mutex now:
> > >   - if map is already frozen, no writable mapping is allowed;
> > >   - if map has writable memory mappings active (accounted in map->writecnt),
> > >     map freezing will keep failing with -EBUSY;
> > >   - once number of writable memory mappings drops to zero, map freezing can be
> > >     performed again.
> > >
> > > Only non-per-CPU plain arrays are supported right now. Maps with spinlocks
> > > can't be memory mapped either.
> > >
> > > For BPF_F_MMAPABLE array, memory allocation has to be done through vmalloc()
> > > to be mmap()'able. We also need to make sure that array data memory is
> > > page-sized and page-aligned, so we over-allocate memory in such a way that
> > > struct bpf_array is at the end of a single page of memory with array->value
> > > being aligned with the start of the second page. On deallocation we need to
> > > accomodate this memory arrangement to free vmalloc()'ed memory correctly.
> > >
> > > One important consideration regarding how memory-mapping subsystem functions.
> > > Memory-mapping subsystem provides few optional callbacks, among them open()
> > > and close().  close() is called for each memory region that is unmapped, so
> > > that users can decrease their reference counters and free up resources, if
> > > necessary. open() is *almost* symmetrical: it's called for each memory region
> > > that is being mapped, **except** the very first one. So bpf_map_mmap does
> > > initial refcnt bump, while open() will do any extra ones after that. Thus
> > > number of close() calls is equal to number of open() calls plus one more.
> > >
> > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > Cc: Rik van Riel <riel@surriel.com>
> > > Acked-by: Song Liu <songliubraving@fb.com>
> > > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  include/linux/bpf.h            | 11 ++--
> > >  include/linux/vmalloc.h        |  1 +
> > >  include/uapi/linux/bpf.h       |  3 ++
> > >  kernel/bpf/arraymap.c          | 59 +++++++++++++++++---
> > >  kernel/bpf/syscall.c           | 99 ++++++++++++++++++++++++++++++++--
> > >  mm/vmalloc.c                   | 20 +++++++
> > >  tools/include/uapi/linux/bpf.h |  3 ++
> > >  7 files changed, 184 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index 6fbe599fb977..8021fce98868 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -12,6 +12,7 @@
> > >  #include <linux/err.h>
> > >  #include <linux/rbtree_latch.h>
> > >  #include <linux/numa.h>
> > > +#include <linux/mm_types.h>
> > >  #include <linux/wait.h>
> > >  #include <linux/u64_stats_sync.h>
> > >
> > > @@ -66,6 +67,7 @@ struct bpf_map_ops {
> > >                                    u64 *imm, u32 off);
> > >       int (*map_direct_value_meta)(const struct bpf_map *map,
> > >                                    u64 imm, u32 *off);
> > > +     int (*map_mmap)(struct bpf_map *map, struct vm_area_struct *vma);
> > >  };
> > >
> > >  struct bpf_map_memory {
> > > @@ -94,9 +96,10 @@ struct bpf_map {
> > >       u32 btf_value_type_id;
> > >       struct btf *btf;
> > >       struct bpf_map_memory memory;
> > > +     char name[BPF_OBJ_NAME_LEN];
> > >       bool unpriv_array;
> > > -     bool frozen; /* write-once */
> > > -     /* 48 bytes hole */
> > > +     bool frozen; /* write-once; write-protected by freeze_mutex */
> > > +     /* 22 bytes hole */
> > >
> > >       /* The 3rd and 4th cacheline with misc members to avoid false sharing
> > >        * particularly with refcounting.
> > > @@ -104,7 +107,8 @@ struct bpf_map {
> > >       atomic64_t refcnt ____cacheline_aligned;
> > >       atomic64_t usercnt;
> > >       struct work_struct work;
> > > -     char name[BPF_OBJ_NAME_LEN];
> > > +     struct mutex freeze_mutex;
> > > +     u64 writecnt; /* writable mmap cnt; protected by freeze_mutex */
> > >  };
> >
> > Can the mutex be moved into bpf_array instead of being in bpf_map that is
> > shared across all map types?
> 
> No, freezing logic is common to all maps. Same for writecnt and
> mmap()-ing overall.

How mmap is going to work for hash map ? and for prog_array?

