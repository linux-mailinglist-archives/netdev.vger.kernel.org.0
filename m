Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D49711C122
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 01:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfLLALx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 19:11:53 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36779 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfLLALw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 19:11:52 -0500
Received: by mail-qt1-f196.google.com with SMTP id k11so698208qtm.3;
        Wed, 11 Dec 2019 16:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nUC3d9Y90GmBz5YWnUmLGjUf7X12+ybMqQN5OVucLdM=;
        b=BXX+tvB90BSh/K02LhmAR7n7XuRusRdI+5uYLrgqAAswigsgNdBwSvUwuirT+9xAug
         C5tGVyA6rhMOqzjk9fFZU2oHiC7v8i1iDodSFSX0aHTwAfbmjntxid+oIPk+/Pgkidm3
         kAJQTwSolsqbWBbD6SZ/ARrImYczeoUCb84j16gT7NKetrttfzBRtuGIzaFQ3L+/uk76
         MKop6PPvlbOsBowCCxEP4AZr2TNZZgQyp5GlUzBnSY8cBqLyUzO9TakcCb8f1GWTCAXj
         UF7jP4KeiguRetnuz9rg1ndTA3aWkSVRxeJuyj/VZjbon9F2gTCI3TBXk0x4vna7CJMh
         BabA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nUC3d9Y90GmBz5YWnUmLGjUf7X12+ybMqQN5OVucLdM=;
        b=QxMcJoUVx2g7c8B5/58sCissVKOXC9dJJF9UC5t+IbJZK6+Yk9gNc3lNxmysQl+frs
         soHmz8HI0HMy4x0ObfvjU6cfAO4depKziocgbV8h3spK4B11zIZG91R1gpjTAaCsR8LA
         8dhS0bkJjk/pva7MB1NcFNXRINHKbVC9YoNTvlWMjokQisIglTXBlIx3w6jAT6dYNxx6
         BXfUD7NYqlVFCdNHsLL7cSqeLL5tRPlGvarSPGNogjLYFqWG8KzWx+e/e/IaLv1pFio0
         u0JaA56QdoZzL5/8YwAq6egDMxRvRW2FPKrU2UQurR6vGXpTnZgLBKNuLpOX8fX9R7So
         S9vg==
X-Gm-Message-State: APjAAAXJycVQjFRSciLa/gXG/JXxwIIaU400efkmD8j6p5M6ikADi0H8
        91A+71vdoE9VKVAOa/zh1G31RJO2sU8Ep7ar3rw=
X-Google-Smtp-Source: APXvYqyQ2NSCK42mzFo5VVpFs/3AsPFn7k0LhqGreAOfSX9FcgtxATtgN8M+hhqpGAmyYb/sItoUTPiT2lM/Uvm4ouk=
X-Received: by 2002:ac8:1385:: with SMTP id h5mr5132165qtj.59.1576109511301;
 Wed, 11 Dec 2019 16:11:51 -0800 (PST)
MIME-Version: 1.0
References: <20191211192634.402675-1-andriin@fb.com> <20191212000858.mhymtk5f4mhwgh2x@kafai-mbp>
In-Reply-To: <20191212000858.mhymtk5f4mhwgh2x@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Dec 2019 16:11:40 -0800
Message-ID: <CAEf4BzZhe0yJrrz3Q+eZLs_pDqpr7gFuMEvLm=EyJhBaS0W3Eg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix printf compilation warnings on
 ppc64le arch
To:     Martin Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 4:09 PM Martin Lau <kafai@fb.com> wrote:
>
> On Wed, Dec 11, 2019 at 11:26:34AM -0800, Andrii Nakryiko wrote:
> > On ppc64le __u64 and __s64 are defined as long int and unsigned long int,
> > respectively. This causes compiler to emit warning when %lld/%llu are used to
> > printf 64-bit numbers. Fix this by casting directly to unsigned long long
> > (through shorter typedef). In few cases casting error code to int explicitly
> > is cleaner, so that's what's done instead.
> >
> > Fixes: 1f8e2bcb2cd5 ("libbpf: Refactor relocation handling")
> > Fixes: abd29c931459 ("libbpf: allow specifying map definitions using BTF")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 34 ++++++++++++++++++----------------
> >  1 file changed, 18 insertions(+), 16 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 3f09772192f1..5ee54f9355a4 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -128,6 +128,8 @@ void libbpf_print(enum libbpf_print_level level, const char *format, ...)
> >  # define LIBBPF_ELF_C_READ_MMAP ELF_C_READ
> >  #endif
> >
> > +typedef unsigned long long __pu64;
> > +
> >  static inline __u64 ptr_to_u64(const void *ptr)
> >  {
> >       return (__u64) (unsigned long) ptr;
> > @@ -1242,15 +1244,15 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
> >                       }
> >                       sz = btf__resolve_size(obj->btf, t->type);
> >                       if (sz < 0) {
> > -                             pr_warn("map '%s': can't determine key size for type [%u]: %lld.\n",
> > -                                     map_name, t->type, sz);
> > +                             pr_warn("map '%s': can't determine key size for type [%u]: %d.\n",
> > +                                     map_name, t->type, (int)sz);
> >                               return sz;
> >                       }
> > -                     pr_debug("map '%s': found key [%u], sz = %lld.\n",
> > -                              map_name, t->type, sz);
> > +                     pr_debug("map '%s': found key [%u], sz = %d.\n",
> > +                              map_name, t->type, (int)sz);
> >                       if (map->def.key_size && map->def.key_size != sz) {
> > -                             pr_warn("map '%s': conflicting key size %u != %lld.\n",
> > -                                     map_name, map->def.key_size, sz);
> > +                             pr_warn("map '%s': conflicting key size %u != %d.\n",
> > +                                     map_name, map->def.key_size, (int)sz);
> >                               return -EINVAL;
> >                       }
> >                       map->def.key_size = sz;
> > @@ -1285,15 +1287,15 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
> >                       }
> >                       sz = btf__resolve_size(obj->btf, t->type);
> >                       if (sz < 0) {
> > -                             pr_warn("map '%s': can't determine value size for type [%u]: %lld.\n",
> > -                                     map_name, t->type, sz);
> > +                             pr_warn("map '%s': can't determine value size for type [%u]: %d.\n",
> > +                                     map_name, t->type, (int)sz);
> >                               return sz;
> >                       }
> > -                     pr_debug("map '%s': found value [%u], sz = %lld.\n",
> > -                              map_name, t->type, sz);
> > +                     pr_debug("map '%s': found value [%u], sz = %d.\n",
> > +                              map_name, t->type, (int)sz);
> >                       if (map->def.value_size && map->def.value_size != sz) {
> > -                             pr_warn("map '%s': conflicting value size %u != %lld.\n",
> > -                                     map_name, map->def.value_size, sz);
> > +                             pr_warn("map '%s': conflicting value size %u != %d.\n",
> > +                                     map_name, map->def.value_size, (int)sz);
> It is not an error case (i.e. not sz < 0) here.
> Same for the above pr_debug().

You are right, not sure if it matters in practice, though. Highly
unlikely values will be bigger than 2GB, but even if they, they still
fit in 4 bytes, we'll just report them as negative values. I can do
similar __ps64 conversion, as for __pu64, though, it we are afraid
it's going to be a problem.
