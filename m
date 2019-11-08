Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93EE8F57B0
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732137AbfKHTfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:35:12 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:42675 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfKHTfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:35:12 -0500
Received: by mail-qv1-f66.google.com with SMTP id c9so2654416qvz.9;
        Fri, 08 Nov 2019 11:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ITHyFtFHHFPfxKluOYKDyQg82wymRlt7RNbYl5V4C3A=;
        b=HM3voJSX9CsunmC/o93xStm0HSMoKnsyEHfBlDFUgRwbaldioYMs0+uKdZLkMjgNFl
         YSTD9OLDltGlWzB/MB9jAzwakn1t1bvqFua6ZkKAiwqAXQUjT9cDtdGSnQ47NCIxxRUw
         bsHeetlUFSUuSAU/4cyaSIfiXmqxrnHv5FolPlj5JkbycxiW48i9OiadjchfViQzIuZT
         yd8uNPu2MtYUFw4bP6+kiC/VxyQyCFnNB7e51vZ+3fqAVahwRBauMMJQ/r5A0kZp3zEP
         UfQQBIHz7BlbrFWUz/HmAftoxr2eQU2trYHqmfbYbUj60y6YGo2ZHhgSsvZnD0fdodKb
         jnvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ITHyFtFHHFPfxKluOYKDyQg82wymRlt7RNbYl5V4C3A=;
        b=INMvDgDMpF5BaV11exdvp38fKMWAwuMvZsxydtaOX+SKmVc2XKOjaSuHRIkCn5nBGl
         4ylKFUkE8bJ89solxQD60sglwKBitMsDKZs0ySj2CbKZUx+m4aVgmxo7pfRuZywn77rE
         t65o2o/SobdfypaVnUPV79pmL9ILp9Gcye9JTQnwRI6G3AUXbSPy+h+MrQ9hoW5LhAd9
         vd5wm7ZOHS3gWvqdDcr/2K/JHuQVvnOJZ4RkM5BloBDkBGiQqE44RMZy3v6bi5nk+mXQ
         l6tbqrdaFtHZih6KP6IYv+nycL5u/3GAp0ahvbWAKLzoyYlO7wMo0rsKTvI7gKVY/pm4
         0Fuw==
X-Gm-Message-State: APjAAAXUZa/zchK1IevYNPxuYZioHmvHdt5BbQ3kZhGHRSJ1XbQ90WM4
        O4jlbdIjgFEEdccWcZDg89k/to4bvfaA1j2Msys=
X-Google-Smtp-Source: APXvYqxVOmd1n/J1aStd7JbFYRI6e/ntrDYLzaEUifQHCtQCWcsRcFmSYo+Z0u3uKJ9loEjp4RAQclYvdclGL+JrStU=
X-Received: by 2002:ad4:4e4a:: with SMTP id eb10mr10735976qvb.228.1573241710527;
 Fri, 08 Nov 2019 11:35:10 -0800 (PST)
MIME-Version: 1.0
References: <20191108042041.1549144-1-andriin@fb.com> <20191108042041.1549144-3-andriin@fb.com>
 <A5F17C12-EBB2-4588-863E-69EDE650DE43@fb.com>
In-Reply-To: <A5F17C12-EBB2-4588-863E-69EDE650DE43@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Nov 2019 11:34:59 -0800
Message-ID: <CAEf4Bzb6cGC_UcH+-WfZaj1i7nnZApTGp3wb0g11HehcURtm9A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] libbpf: make global data internal arrays
 mmap()-able, if possible
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 10:44 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Nov 7, 2019, at 8:20 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Add detection of BPF_F_MMAPABLE flag support for arrays and add it as an extra
> > flag to internal global data maps, if supported by kernel. This allows users
> > to memory-map global data and use it without BPF map operations, greatly
> > simplifying user experience.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> With nit below.
>
> > ---
> > tools/lib/bpf/libbpf.c | 31 +++++++++++++++++++++++++++++--
> > 1 file changed, 29 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index fde6cb3e5d41..73607a31a068 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -142,6 +142,8 @@ struct bpf_capabilities {
> >       __u32 btf_func:1;
> >       /* BTF_KIND_VAR and BTF_KIND_DATASEC support */
> >       __u32 btf_datasec:1;
> > +     /* BPF_F_MMAPABLE is supported for arrays */
> > +     __u32 array_mmap:1;
> > };
> >
> > /*
> > @@ -855,8 +857,6 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
> >               pr_warn("failed to alloc map name\n");
> >               return -ENOMEM;
> >       }
> > -     pr_debug("map '%s' (global data): at sec_idx %d, offset %zu.\n",
> > -              map_name, map->sec_idx, map->sec_offset);
> >
> >       def = &map->def;
> >       def->type = BPF_MAP_TYPE_ARRAY;
> > @@ -864,6 +864,12 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
> >       def->value_size = data->d_size;
> >       def->max_entries = 1;
> >       def->map_flags = type == LIBBPF_MAP_RODATA ? BPF_F_RDONLY_PROG : 0;
> > +     if (obj->caps.array_mmap)
> > +             def->map_flags |= BPF_F_MMAPABLE;
> > +
> > +     pr_debug("map '%s' (global data): at sec_idx %d, offset %zu, flags %u.\n",
>
> nit: Better print flags as %x.
>
>

sure, will update
