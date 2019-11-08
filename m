Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B83BF57AD
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388368AbfKHTeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:34:44 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:32915 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387798AbfKHTen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:34:43 -0500
Received: by mail-qk1-f196.google.com with SMTP id 71so6351496qkl.0;
        Fri, 08 Nov 2019 11:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z6RHi+GPBXIkgHwfeIMhb6lJP0WXm9EYjHAxNtIieV4=;
        b=R6Xz8U68TrE4OuYWkBhBougQx/6S9v6gq/vsWsv1mJxa0KQdRPkBXwjqICO0W+0yYg
         o+EyqLVgs1MSWa7xINxs7/8DTqMUxXPTAgKDYYdK5ZsqM58uPOX2QAn4a4zkdQ/1zpdL
         ALYwSPXYkTzxtmqISU26ErPL9gfFyemU19FilBhU+IF8Q/MaxoOUDnINQLiGBTCCgzCH
         EcK62pzC9ZPrvyjJbSmSNRnnIzZhShRkfHgn3rvYhl/rDan8Gocnj4DbQM4/5J2Nj8+z
         +Oi1liRRPiswpndWgb9xORYOyDpr46XfSTR2Mb3zgB805yp7bXR0gHGsdpzMMH5Z4KG9
         Bslw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z6RHi+GPBXIkgHwfeIMhb6lJP0WXm9EYjHAxNtIieV4=;
        b=gnXXHQE2Fy68s1EjvFuQDTdq+2jSpo3nkda/coS24UNXal1Eta+cB4TlwFD7L0TBAa
         zCtPRfjnzG4pbFFs5QUJqXlfU5ksc8lyVFYC+xYH5mzdR2cg+F6pnpTwu557Kac/42Hl
         xhR7dkdvZk3OLUKo3JTXH2plEIs6MfmOyXyWqWtX/3F3touYgrpmdtyCiVpOVPStiGlk
         NFuSDKd3ELPGZyR+5PdIHAxvuZkcAupQ3ST31/DSKm6hBRWM2pqmObrUP/5qT+VIJuOP
         cQn0EIgSf1oCUTUNSn64eBX49KZ/ooXMBhUOm+SLLDkrXaOCExCsdyYKDeKDGIuMCXjg
         2n4w==
X-Gm-Message-State: APjAAAV74N57XLVG3bnGLwS1G3wDv2fZyGRVXktxVbdA+e/kZ0uvaV0W
        MkPc6hQ26dqmaXLu5JPikItVXCdKejl5zN2j1PN5ug==
X-Google-Smtp-Source: APXvYqwkzRKHMdjUzn6fjnfGAkW+XBAk6uzVxRdO4MKwqREPWscev95ygoYd3I2yFXVqPI8n+N4Qjl0k8GEBLWfRbkI=
X-Received: by 2002:a05:620a:12b2:: with SMTP id x18mr10976764qki.437.1573241682667;
 Fri, 08 Nov 2019 11:34:42 -0800 (PST)
MIME-Version: 1.0
References: <20191108042041.1549144-1-andriin@fb.com> <20191108042041.1549144-2-andriin@fb.com>
 <94BD3FAC-CA98-4448-B467-3FC7307174F9@fb.com>
In-Reply-To: <94BD3FAC-CA98-4448-B467-3FC7307174F9@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Nov 2019 11:34:31 -0800
Message-ID: <CAEf4BzY2gp9DR+cdcr4DFhOYc8xkHOOSSf9MiJ6P+54USa8zog@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: add mmap() support for BPF_MAP_TYPE_ARRAY
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Rik van Riel <riel@surriel.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 10:39 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Nov 7, 2019, at 8:20 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Add ability to memory-map contents of BPF array map. This is extremely useful
> > for working with BPF global data from userspace programs. It allows to avoid
> > typical bpf_map_{lookup,update}_elem operations, improving both performance
> > and usability.
> >
> > There had to be special considerations for map freezing, to avoid having
> > writable memory view into a frozen map. To solve this issue, map freezing and
> > mmap-ing is happening under mutex now:
> >  - if map is already frozen, no writable mapping is allowed;
> >  - if map has writable memory mappings active (accounted in map->writecnt),
> >    map freezing will keep failing with -EBUSY;
> >  - once number of writable memory mappings drops to zero, map freezing can be
> >    performed again.
> >
> > Only non-per-CPU arrays are supported right now. Maps with spinlocks can't be
> > memory mapped either.
> >
> > Cc: Rik van Riel <riel@surriel.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> With one nit below.
>
>
> [...]
>
> > -     if (percpu)
> > +     data_size = 0;
> > +     if (percpu) {
> >               array_size += (u64) max_entries * sizeof(void *);
> > -     else
> > -             array_size += (u64) max_entries * elem_size;
>
> > +     } else {
> > +             if (attr->map_flags & BPF_F_MMAPABLE) {
> > +                     data_size = (u64) max_entries * elem_size;
> > +                     data_size = round_up(data_size, PAGE_SIZE);
> > +             } else {
> > +                     array_size += (u64) max_entries * elem_size;
> > +             }
> > +     }
> >
> >       /* make sure there is no u32 overflow later in round_up() */
> > -     cost = array_size;
> > +     cost = array_size + data_size;
>
>
>
> This is a little confusing. Maybe we can do
>

I don't think I can do that without even bigger code churn. In
non-mmap()-able case, array_size specifies the size of one chunk of
memory, which consists of sizeof(struct bpf_array) bytes, followed by
actual data. This is accomplished in one allocation. That's current
case for arrays.

For BPF_F_MMAPABLE case, though, we have to do 2 separate allocations,
to make sure that mmap()-able part is allocated with vmalloc() and is
page-aligned. So array_size keeps track of number of bytes allocated
for struct bpf_array plus, optionally, per-cpu or non-mmapable array
data, while data_size is explicitly for vmalloc()-ed mmap()-able chunk
of data. If not for this, I'd just keep adjusting array_size.

So the invariant for per-cpu and non-mmapable case is that data_size =
0, array_size = sizeof(struct bpf_array) + whatever amount of data we
need. For mmapable case: array_size = sizeof(struct bpf_array),
data_size = actual amount of array data.


>         data_size = (u64) max_entries * (per_cpu ? sizeof(void *) : elem_size;
>         if (attr->map_flags & BPF_F_MMAPABLE)
>                 data_size = round_up(data_size, PAGE_SIZE);
>
>         cost = array_size + data_size;
>
> So we use data_size in all cases.
>
> Maybe also rename array_size.
>
>
> >       if (percpu)
> >               cost += (u64)attr->max_entries * elem_size * num_possible_cpus();
>
> And maybe we can also include this in data_size.

see above.

>
> [...]
>
