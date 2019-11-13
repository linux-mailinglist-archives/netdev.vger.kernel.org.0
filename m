Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD1CDFBA7E
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 22:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKMVPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 16:15:00 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:33002 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfKMVPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 16:15:00 -0500
Received: by mail-qv1-f67.google.com with SMTP id x14so1465740qvu.0;
        Wed, 13 Nov 2019 13:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SsEMwJGsbGqrz7odM3I2EURqP+EeRPSX9492mDiegp8=;
        b=K1XsdbLWdsW70pSHtNFny2ohuqYE/+jg6g7vmcjJdy4Kvde5jZ2ixUDRTexLbPCW/A
         Jt2Ex4Qp++wciUsmcg4dscKwBID6fO9mHu2mL1eg2VgueDUbiqjTq6AQ0Gk9cIbPgKqe
         zhpJz2ffsu5bVTDqlXFhbvPRgoLLP6bvoZdE6ssZwGX5/lBhYTBwx8eY04YuFYUVlvcU
         ZbuSpl8IYH97NS6b1lNAXMRt2d3J0nsAfu5ayw9D8xtbHEspafozkYitlDzaIHXfXHjE
         S9nWURbqGOMSIbZWb1dCO1wCeDlSyGcEZpqWmnoCU7fiiuh8YOWHU6AX9m3Y4+xxet4W
         /B0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SsEMwJGsbGqrz7odM3I2EURqP+EeRPSX9492mDiegp8=;
        b=GkjFNpeRkHSuD/z6dMWVzK0XUX8vtaOsYld5FWds6ufQUn8N8BWfKKQO0wuWs97zzd
         3jycSMvsVlJL3m5QoWMbWvgdPmINXqXWMe/R9/RwaGV1TMza0sYHmvFHATe4t5dBceua
         qqe4D1iMFdV64u8Ai/2KiktOD7ftkD2PkT9KyrgtpNRdvCp5UJWCn2cSHJskaNhEfZcq
         i8Yx+LCU5Yj2wLdqAuSbX1w0wNBjwm86sAgUqtiSp1NwlmSmffShx0G5VVEMz6OjAJcQ
         Cw2drzkeiCJ/OtjWEx2zD7wORZC2KequpOuKSdMu93buui/s6x2hA61Hp09Q8UHDZIX2
         Cx2g==
X-Gm-Message-State: APjAAAU9oSbFk3dOjBOh9ap3/hOt6PxzgY8E6PU67swYFXeMeOFPrsSm
        pr9pzRX1a3vEdy1AL/OJJfBzGU/kxPy3ZZkuoJI=
X-Google-Smtp-Source: APXvYqyYl4d2oAeQ3ws9JDcx94OJ5B+Q3x62xNbzbwtaPKo4Z/vrRiK+SFa5sQ9XERnVptZjCOxjWIX2C9W/sZmIBD4=
X-Received: by 2002:a0c:eb47:: with SMTP id c7mr5064446qvq.163.1573679698690;
 Wed, 13 Nov 2019 13:14:58 -0800 (PST)
MIME-Version: 1.0
References: <20191113031518.155618-1-andriin@fb.com> <20191113031518.155618-2-andriin@fb.com>
 <4460626d-93e6-6566-9909-68b15e515f4e@iogearbox.net> <CAEf4BzYEY7akdcVxnziaEKESJjuhV8TPguYEhH_5b960gbO7TQ@mail.gmail.com>
 <20191113211009.GA3066@pc-9.home>
In-Reply-To: <20191113211009.GA3066@pc-9.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Nov 2019 13:14:47 -0800
Message-ID: <CAEf4BzabLrTKEgjMzbRQJZCThcFZx-VBw0J=YKYGgn5Z_fSzOg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: add mmap() support for BPF_MAP_TYPE_ARRAY
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>,
        Rik van Riel <riel@surriel.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 1:10 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Wed, Nov 13, 2019 at 12:50:23PM -0800, Andrii Nakryiko wrote:
> > On Wed, Nov 13, 2019 at 12:38 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > On 11/13/19 4:15 AM, Andrii Nakryiko wrote:
> > > > Add ability to memory-map contents of BPF array map. This is extremely useful
> > > > for working with BPF global data from userspace programs. It allows to avoid
> > > > typical bpf_map_{lookup,update}_elem operations, improving both performance
> > > > and usability.
> > > >
> > > > There had to be special considerations for map freezing, to avoid having
> > > > writable memory view into a frozen map. To solve this issue, map freezing and
> > > > mmap-ing is happening under mutex now:
> > > >    - if map is already frozen, no writable mapping is allowed;
> > > >    - if map has writable memory mappings active (accounted in map->writecnt),
> > > >      map freezing will keep failing with -EBUSY;
> > > >    - once number of writable memory mappings drops to zero, map freezing can be
> > > >      performed again.
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
> > > > Cc: Rik van Riel <riel@surriel.com>
> > > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > > Acked-by: Song Liu <songliubraving@fb.com>
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > >
> > > Overall set looks good to me! One comment below:
> > >
> > > [...]
> > > > @@ -117,7 +131,20 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
> > > >               return ERR_PTR(ret);
> > > >
> > > >       /* allocate all map elements and zero-initialize them */
> > > > -     array = bpf_map_area_alloc(array_size, numa_node);
> > > > +     if (attr->map_flags & BPF_F_MMAPABLE) {
> > > > +             void *data;
> > > > +
> > > > +             /* kmalloc'ed memory can't be mmap'ed, use explicit vmalloc */
> > > > +             data = vzalloc_node(array_size, numa_node);
> > > > +             if (!data) {
> > > > +                     bpf_map_charge_finish(&mem);
> > > > +                     return ERR_PTR(-ENOMEM);
> > > > +             }
> > > > +             array = data + round_up(sizeof(struct bpf_array), PAGE_SIZE)
> > > > +                     - offsetof(struct bpf_array, value);
> > > > +     } else {
> > > > +             array = bpf_map_area_alloc(array_size, numa_node);
> > > > +     }
> > >
> > > Can't we place/extend all this logic inside bpf_map_area_alloc() and
> > > bpf_map_area_free() API instead of hard-coding it here?
> > >
> > > Given this is a generic feature of which global data is just one consumer,
> > > my concern is that this reintroduces similar issues that mentioned API was
> > > trying to solve already meaning failing early instead of trying hard and
> > > triggering OOM if the array is large.
> > >
> > > Consolidating this into bpf_map_area_alloc()/bpf_map_area_free() would
> > > make sure all the rest has same semantics.
> >
> > So a bunch of this (e.g, array pointer adjustment in mmapable case)
> > depends on specific layout of bpf_array, while bpf_map_area_alloc() is
> > called for multitude of different maps. What we can generalize,
> > though, is this enforcement of vmalloc() for mmapable case: enforce
> > size is multiple of PAGE_SIZE, bypass kmalloc, etc. I can do that part
> > easily, I refrained because it would require extra bool mmapable flag
> > to bpf_map_area_alloc() and (trivial) update to 13 call sites passing
> > false, I wasn't sure people would like code churn.
> >
> > As for bpf_map_areas_free(), again, adjustment is specific to
> > bpf_array and its memory layout w.r.t. data placement, so I don't
> > think we can generalize it that much.
> >
> > After talking with Johannes, I'm also adding new
> > vmalloc_user_node_flags() API and will specify same RETRY_MAYFAIL and
> > NOWARN flags, so behavior will stay the same.
> >
> > Let me know if you want `bool mmapable` added to bpf_map_area_alloc().
> > And also if I'm missing how you wanted to generalize other parts,
> > please explain in more details.
>
> Why changing all call-sites? You could have two pair of API helpers,
> e.g. bpf_map_area_{,mmapable}_alloc() and bpf_map_area_{,mmapable}_free()
> and they both call into __bpf_map_area_alloc() and __bpf_map_area_free()
> which are private and common to both, so whenever we need to go and change
> internals, they are fixed for all users. Call-sites would remain as-is
> just for array map you'd select between the two.

ok, can do bpf_map_area_alloc() and bpf_map_area_mmapable_alloc().
Still don't see how I can do bpf_map_area_mmapable_free() (normal
bpf_map_area_free() will be able to free mmapable allocated memory, if
caller adjusts the pointer correctly; adjustment though is specific to
each use case, so can't be generalized).

>
> > > >       if (!array) {
> > > >               bpf_map_charge_finish(&mem);
> > > >               return ERR_PTR(-ENOMEM);
> > > > @@ -365,7 +392,10 @@ static void array_map_free(struct bpf_map *map)
> > > >       if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
> > > >               bpf_array_free_percpu(array);
> > > >
> > > > -     bpf_map_area_free(array);
> > > > +     if (array->map.map_flags & BPF_F_MMAPABLE)
> > > > +             bpf_map_area_free((void *)round_down((long)array, PAGE_SIZE));
> > > > +     else
> > > > +             bpf_map_area_free(array);
> > > >   }
> > > >
> > > >   static void array_map_seq_show_elem(struct bpf_map *map, void *key,
> > > [...]
