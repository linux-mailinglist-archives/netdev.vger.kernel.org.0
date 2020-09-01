Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5D9259DDF
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 20:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgIASLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 14:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgIASLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 14:11:19 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFD8C061244;
        Tue,  1 Sep 2020 11:11:18 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id c17so1349639ybe.0;
        Tue, 01 Sep 2020 11:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MSyQm4hBeFyUcS6RfecsGKRclkyWgLleS2YbMFdqO5c=;
        b=mPnqp0wZ+H2I178EEOKPt+nZ8xjZmfTYGPuhQfnyAQ3lCUniYWfI5k7ARYyFFLj2l4
         4idYaOqkr4Cq6ol5geyJdQGsa7UJ4+63D0j2SbdHwo7xZavxYHrEOQfW97rfqlyvRqFz
         mSaCKNo+Fp8XLc9yz0q3OHZSHJB8M2QdeRBXWvJo4HwIXbLw73K/281UQBGY7U7E/QUo
         T25VtbCcK+RPftLHIHu3qHrdFQtzgeltS7Qb6RpiV0HEiJoDjTbiOgZhh3ue63oTAmNy
         3y7bYj0t2xbKMXz5ToqMBV69rOVBt8Tu3GaPQdugYgZ0aCdskt3pzr+hRp+g2ZhWe2VA
         qA6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MSyQm4hBeFyUcS6RfecsGKRclkyWgLleS2YbMFdqO5c=;
        b=GEc5cJBFHzWW7mOaBdOBi07euKGpJkLQswK8SMrdCKRmn6wGaSKRRr8jHJ+a6V2Isp
         tQ7TB/8QzDa4DM3K1T0K59jAdmJ1NEaNrt9Oj7FGomjjuCimt1WlqXOUpc0W7+OD0yNF
         ubYZFUThgLq/zqBkgGN5rBOKI/CnZ+DOB5l/2fkahAUqYziVNtpirAu9JVR4KeOPHo3m
         AnQkUuldcAkEGPqqszJmTUBEnetY1NgxdIRPFSwcOfJ4lHOfH2iW2Rk6oHvJkwMK0uuD
         wT2Mx2PjVqWd50NQwley/Wvo/2Tl3lM80wmCq2M809bsAxLDxOHdpo15Q4bFRrrSHH4Q
         I6pA==
X-Gm-Message-State: AOAM532xUWhK9DG/3G0+/V+FjkneKb93USJrgysV5UqXQYGKpMFnfAxN
        f7Oyf/gfSPsBrtVrPBFa8JSPBIbbDQ4G49qGCtlA9VlTC/s=
X-Google-Smtp-Source: ABdhPJxNqmO6TdDep5xxuTw/rXlnImYA9re8mERs/qqu/YbFGuPdIGkSByPuk8qfJql4GEsaRapFCO/ykmMhc+/E9e0=
X-Received: by 2002:a25:c4c2:: with SMTP id u185mr4826837ybf.347.1598983877702;
 Tue, 01 Sep 2020 11:11:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-5-haoluo@google.com>
 <CAEf4BzYhjUwYH_BBgtHz9-Ha-54AQ_8L3_N=cXsuud=kayk5-A@mail.gmail.com> <CA+khW7jDYSvQcVvQ2dLHC9JOLFp9wC7fNtt4rzgBkdWOC=AVjQ@mail.gmail.com>
In-Reply-To: <CA+khW7jDYSvQcVvQ2dLHC9JOLFp9wC7fNtt4rzgBkdWOC=AVjQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Sep 2020 11:11:06 -0700
Message-ID: <CAEf4BzaO_P1LiWDvFcZ3u1f2eaUEpqb+KXg0FqLMGYDLdRNBJQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 4/8] bpf/libbpf: BTF support for typed ksyms
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 3:29 PM Hao Luo <haoluo@google.com> wrote:
>
> On Fri, Aug 21, 2020 at 3:37 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Aug 19, 2020 at 3:42 PM Hao Luo <haoluo@google.com> wrote:
> > >
> > > If a ksym is defined with a type, libbpf will try to find the ksym's btf
> > > information from kernel btf. If a valid btf entry for the ksym is found,
> > > libbpf can pass in the found btf id to the verifier, which validates the
> > > ksym's type and value.
> > >
> > > Typeless ksyms (i.e. those defined as 'void') will not have such btf_id,
> > > but it has the symbol's address (read from kallsyms) and its value is
> > > treated as a raw pointer.
> > >
> > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > ---
> > >  tools/lib/bpf/libbpf.c | 130 ++++++++++++++++++++++++++++++++++++-----
> > >  1 file changed, 114 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index 4a81c6b2d21b..94eff612c7c2 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -357,7 +357,16 @@ struct extern_desc {
> > >                         bool is_signed;
> > >                 } kcfg;
> > >                 struct {
> > > -                       unsigned long long addr;
> > > +                       /*
> > > +                        *  1. If ksym is typeless, the field 'addr' is valid.
> > > +                        *  2. If ksym is typed, the field 'vmlinux_btf_id' is
> > > +                        *     valid.
> > > +                        */
> > > +                       bool is_typeless;
> > > +                       union {
> > > +                               unsigned long long addr;
> > > +                               int vmlinux_btf_id;
> > > +                       };
> >
> > ksym is 16 bytes anyways, union doesn't help to save space. I propose
> > to encode all this with just two fields: vmlinux_btf_id and addr. If
> > btf_id == 0, then extern is typeless.
>
> Ack on expanding the union. But I slightly preferred keeping
> is_typeless. IIUC, btf_id points a VAR_KIND, we need the following
> pointer chasing every time
>
> t = btf__type_by_id(obj->btf, ext->btf_id);
> t->type;
>
> which I felt is worse than keeping a is_typeless flag.

Sorry, I'm not following. In all places where you would check
sym->is_typeless, you'd now just do:

if (ext->ksym.vmlinux_btf_id) {
  /* typed, use ext->ksym.vmlinux_btf_id */
} else {
  /* typeless */
}

>
> >
> > >                 } ksym;
> > >         };
> > >  };
> > > @@ -382,6 +391,7 @@ struct bpf_object {
> > >
> > >         bool loaded;
> > >         bool has_pseudo_calls;
> > > +       bool has_typed_ksyms;
> > >
> > >         /*
> > >          * Information when doing elf related work. Only valid if fd
> > > @@ -2521,6 +2531,10 @@ static int bpf_object__load_vmlinux_btf(struct bpf_object *obj)
> > >         if (obj->btf_ext && obj->btf_ext->core_relo_info.len)
> > >                 need_vmlinux_btf = true;
> > >
> > > +       /* Support for typed ksyms needs kernel BTF */
> > > +       if (obj->has_typed_ksyms)
> > > +               need_vmlinux_btf = true;
> >
> > On the second read, I don't think you really need `has_typed_ksyms` at
> > all. Just iterate over ksym externs and see if you have a typed one.
> > It's the only place that cares.
> >
>
> Ack. Will iterate over ksym externs here.
>
> > > +
> > >         bpf_object__for_each_program(prog, obj) {
> > >                 if (!prog->load)
> > >                         continue;
> > > @@ -2975,10 +2989,10 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
> > >                         ext->type = EXT_KSYM;
> > >
> > >                         vt = skip_mods_and_typedefs(obj->btf, t->type, NULL);
> > > -                       if (!btf_is_void(vt)) {
> > > -                               pr_warn("extern (ksym) '%s' is not typeless (void)\n", ext_name);
> > > -                               return -ENOTSUP;
> > > -                       }
> > > +                       ext->ksym.is_typeless = btf_is_void(vt);
> > > +
> > > +                       if (!obj->has_typed_ksyms && !ext->ksym.is_typeless)
> > > +                               obj->has_typed_ksyms = true;
> >
> > nit: keep it simple:
> >
> > if (ext->ksym.is_typeless)
> >   obj->has_typed_ksyms = true;
> >
>
> Ack.
>
> > >                 } else {
> > >                         pr_warn("unrecognized extern section '%s'\n", sec_name);
> > >                         return -ENOTSUP;
> > > @@ -2992,9 +3006,9 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
> > >         /* sort externs by type, for kcfg ones also by (align, size, name) */
> > >         qsort(obj->externs, obj->nr_extern, sizeof(*ext), cmp_externs);
> > >
> > > -       /* for .ksyms section, we need to turn all externs into allocated
> > > -        * variables in BTF to pass kernel verification; we do this by
> > > -        * pretending that each extern is a 8-byte variable
> > > +       /* for .ksyms section, we need to turn all typeless externs into
> > > +        * allocated variables in BTF to pass kernel verification; we do
> > > +        * this by pretending that each typeless extern is a 8-byte variable
> > >          */
> > >         if (ksym_sec) {
> > >                 /* find existing 4-byte integer type in BTF to use for fake
> > > @@ -3012,7 +3026,7 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
> > >
> > >                 sec = ksym_sec;
> > >                 n = btf_vlen(sec);
> > > -               for (i = 0, off = 0; i < n; i++, off += sizeof(int)) {
> > > +               for (i = 0, off = 0; i < n; i++) {
> > >                         struct btf_var_secinfo *vs = btf_var_secinfos(sec) + i;
> > >                         struct btf_type *vt;
> > >
> > > @@ -3025,9 +3039,14 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
> > >                                 return -ESRCH;
> > >                         }
> > >                         btf_var(vt)->linkage = BTF_VAR_GLOBAL_ALLOCATED;
> > > -                       vt->type = int_btf_id;
> > > +                       if (ext->ksym.is_typeless) {
> > > +                               vt->type = int_btf_id;
> > > +                               vs->size = sizeof(int);
> > > +                       }
> > >                         vs->offset = off;
> > > -                       vs->size = sizeof(int);
> > > +                       off += vs->size;
> > > +                       pr_debug("ksym var_secinfo: var '%s', type #%d, size %d, offset %d\n",
> > > +                                ext->name, vt->type, vs->size, vs->offset);
> >
> > It's a bit of a waste that we still allocate memory for those typed
> > ksym externs, as they don't really need space. But modifying BTF is a
> > pain right now, so I think we'll have to do it, until we have a better
> > BTF API. But let's make them integers for now to take a fixed and
> > small amount of space.
> >
>
> Do you mean making typed ksym externs of type integer? If so, we can't
> do that, I think. After collect_externs, we later need to compare the
> declared extern's type against the type defined in kernel. Better not
> rewrite their types in BTf.

Then maybe we need to make btf_id to point to the actual type of the
variable, not BTF_KIND_VAR? Or just additionally record type's btf_id,
not sure which one makes more sense at the moment.

>
> I am generally against modifying BTF. I initially didn't notice that
> all the ksym externs' types are modified to 'int' and the type
> comparison I mentioned above always failed. I dumped the btf in
> vmlinux and the btf in object file, checked the kernel variable's
> source code, printed out everything I could. The experience was very
> bad.
>

It might be confusing, I agree, but the alternative is just a waste of
memory just to match the BTF definition of a DATASEC, which describes
externs. It seems sloppy to allocate a bunch of unused memory just to
match the kernel's variable size, while in reality we either use 8
bytes used (for typeless externs, storing ksym address) or none (for
typed externs).

Another alternative is to not specify BTF ID for .ksyms map, but it's
not great for typeless externs case, as we are losing all type info
completely. Trade-offs...

[...]

> > > +               }
> > > +
> > > +               id = btf__find_by_name_kind(obj->btf_vmlinux, ext->name,
> > > +                                           BTF_KIND_VAR);
> > > +               if (id <= 0) {
> > > +                       pr_warn("no btf entry for ksym '%s' in vmlinux.\n",
> > > +                               ext->name);
> > > +                       return -ESRCH;
> > > +               }
> > > +
> > > +               vx = btf__type_by_id(obj->btf_vmlinux, id);
> > > +               tx = skip_mods_and_typedefs(obj->btf_vmlinux, vx->type, &vtx);
> > > +
> > > +               v = btf__type_by_id(obj->btf, ext->btf_id);
> > > +               t = skip_mods_and_typedefs(obj->btf, v->type, &vt);
> > > +
> > > +               if (!btf_ksym_type_match(obj->btf_vmlinux, vtx, obj->btf, vt)) {
> > > +                       const char *tname, *txname; /* names of TYPEs */
> > > +
> > > +                       txname = btf__name_by_offset(obj->btf_vmlinux, tx->name_off);
> > > +                       tname = btf__name_by_offset(obj->btf, t->name_off);
> > > +
> > > +                       pr_warn("ksym '%s' expects type '%s' (vmlinux_btf_id: #%d), "
> > > +                               "but got '%s' (btf_id: #%d)\n", ext->name,
> > > +                               txname, vtx, tname, vt);
> > > +                       return -EINVAL;
> > > +               }
> >
> > yeah, definitely just use bpf_core_types_are_compat() here. You'll
> > want to skip_mods_and_typedefs first, but everything else should work
> > for your use case.
> >
>
> Ack. bpf_core_types_are_compat() is indeed a perfect fit here.
>

ok, great

> [...]
