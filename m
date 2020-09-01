Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F3C25A015
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 22:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgIAUfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 16:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbgIAUfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 16:35:31 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D1AC061247
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 13:35:30 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id n13so2746136edo.10
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 13:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/fv4Q0UAT/ZAtqAn51EeCeb1F3QIrxMcdfWrDVrWkTI=;
        b=qlvheLOWupwRUGhcpiy3DSwi9x1+3f0W1j/G0kKSEcQdmdG0+23jvoRyMQ/5itywI8
         ExcEU4skx3fk4uWZ0rMs5M7BuFqJ6B0pbTq/82e/319zzYdABpmOoP2eagNvkCBtLFIO
         j2dfJv8s6J08LvqwWmH8wDdPlnosZpULcoGwUdk52kEM1h7MjkPgnwLv4w8uz6zQbggz
         +S+jn/P0vnqmThm/bwoJSzdqmkr09zNBfodIQbAtyK6IbffiGiJRg5grGCtXbyxaSgLX
         gx0dVsgZTc41bsPpI1rkr3fI2cfhN8Iz+ecq27XG9Gen+KL6cgMlJc/jKNSz6DlLb0wk
         4Vzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/fv4Q0UAT/ZAtqAn51EeCeb1F3QIrxMcdfWrDVrWkTI=;
        b=RUL6l3XWMjkejX46SzlHtTqll4Jcm/iNMvLHPmyDGVa6xvAbPzZuUOG5RkTbdENYWy
         4uVlBeZKq25N8vPP4DnykaZ0Apdb5GoK6FLCU2g/8lieDgE6G7pFZTKKnJsy2FsKfWyN
         j7DBSzS1U+kOxvN0LtPGEqe40LCEukwlwajZrNIvhP4G6NG5pwmedIhLRkDc86lK/XoF
         mq/5WKvBxz+evVIv8jzOPjcCNtrJM1OsWso1YJ8CLErSg0GrDe07mydFq/EuwtX7Vuiu
         GEiV5jgDV5Z41UfbSShI087ErRbcQAU8k26rkGQx9Cj39W86eE9yPfWb7OexQ2PAmNzr
         ZTSQ==
X-Gm-Message-State: AOAM533CQW5LsFbFPR6XZU0JJLHGJ4BzllCB3eZNoRgTU9L9oFHDTJeO
        pzbRFX1dBJ0u1TazoWuByv8Qelo1B/uqGeBXfmAz/A==
X-Google-Smtp-Source: ABdhPJx/frfT0eozCKK2CpjhyTBLCtj/TepAnIQYpXXED7UzpDIHGLVCttHgVWMblcVF0T3SU29cVn/hTjrO/uK2Rs4=
X-Received: by 2002:aa7:dd01:: with SMTP id i1mr3522834edv.121.1598992529151;
 Tue, 01 Sep 2020 13:35:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-5-haoluo@google.com>
 <CAEf4BzYhjUwYH_BBgtHz9-Ha-54AQ_8L3_N=cXsuud=kayk5-A@mail.gmail.com>
 <CA+khW7jDYSvQcVvQ2dLHC9JOLFp9wC7fNtt4rzgBkdWOC=AVjQ@mail.gmail.com> <CAEf4BzaO_P1LiWDvFcZ3u1f2eaUEpqb+KXg0FqLMGYDLdRNBJQ@mail.gmail.com>
In-Reply-To: <CAEf4BzaO_P1LiWDvFcZ3u1f2eaUEpqb+KXg0FqLMGYDLdRNBJQ@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Tue, 1 Sep 2020 13:35:17 -0700
Message-ID: <CA+khW7jnzZim6h9O+JH2AnXmvtU19-FxJDZBXfHZH9Xniq8zeg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 4/8] bpf/libbpf: BTF support for typed ksyms
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Tue, Sep 1, 2020 at 11:11 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Aug 27, 2020 at 3:29 PM Hao Luo <haoluo@google.com> wrote:
> >
> > On Fri, Aug 21, 2020 at 3:37 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Wed, Aug 19, 2020 at 3:42 PM Hao Luo <haoluo@google.com> wrote:
> > > >
> > > > If a ksym is defined with a type, libbpf will try to find the ksym's btf
> > > > information from kernel btf. If a valid btf entry for the ksym is found,
> > > > libbpf can pass in the found btf id to the verifier, which validates the
> > > > ksym's type and value.
> > > >
> > > > Typeless ksyms (i.e. those defined as 'void') will not have such btf_id,
> > > > but it has the symbol's address (read from kallsyms) and its value is
> > > > treated as a raw pointer.
> > > >
> > > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > > ---
> > > >  tools/lib/bpf/libbpf.c | 130 ++++++++++++++++++++++++++++++++++++-----
> > > >  1 file changed, 114 insertions(+), 16 deletions(-)
> > > >
> > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > index 4a81c6b2d21b..94eff612c7c2 100644
> > > > --- a/tools/lib/bpf/libbpf.c
> > > > +++ b/tools/lib/bpf/libbpf.c
> > > > @@ -357,7 +357,16 @@ struct extern_desc {
> > > >                         bool is_signed;
> > > >                 } kcfg;
> > > >                 struct {
> > > > -                       unsigned long long addr;
> > > > +                       /*
> > > > +                        *  1. If ksym is typeless, the field 'addr' is valid.
> > > > +                        *  2. If ksym is typed, the field 'vmlinux_btf_id' is
> > > > +                        *     valid.
> > > > +                        */
> > > > +                       bool is_typeless;
> > > > +                       union {
> > > > +                               unsigned long long addr;
> > > > +                               int vmlinux_btf_id;
> > > > +                       };
> > >
> > > ksym is 16 bytes anyways, union doesn't help to save space. I propose
> > > to encode all this with just two fields: vmlinux_btf_id and addr. If
> > > btf_id == 0, then extern is typeless.
> >
> > Ack on expanding the union. But I slightly preferred keeping
> > is_typeless. IIUC, btf_id points a VAR_KIND, we need the following
> > pointer chasing every time
> >
> > t = btf__type_by_id(obj->btf, ext->btf_id);
> > t->type;
> >
> > which I felt is worse than keeping a is_typeless flag.
>
> Sorry, I'm not following. In all places where you would check
> sym->is_typeless, you'd now just do:
>
> if (ext->ksym.vmlinux_btf_id) {
>   /* typed, use ext->ksym.vmlinux_btf_id */
> } else {
>   /* typeless */
> }
>

My apologies, I should be more specific.

'vmlinux_btf_id' gets its value in bpf_object__resolve_ksyms_btf_id().
Before we call this function, there are three places that need to tell
whether a ksym is typed, currently in v1. Specifically,

 - in bpf_object__collect_externs(), typeless ksyms are rewritten as
'int', in contrast, typed ones are left untouched (though this may
change in v2).
 - bpf_object__load_vmlinux_btf() now is called before
bpf_object__resolve_ksyms_btf_id(). In v1's design, if there is no
typed ksym, we could skip loading vmlinux_btf potentially.
 - even bpf_object__resolve_ksyms_btf_id() itself is conditionally
called, depending on whether there is any typed ksym.

At the time when these places are called, vmlinux_btf_id is
unavailable and we can't use it for the purpose of telling whether a
ksym is typed.

However, rather than vmlinux_btf_id, there may be an alternative. We
can record the ksym extern's type's btf_id and use that as
'is_typeless' flag. This also solves the problem below.

[...]

> > > >                 } else {
> > > >                         pr_warn("unrecognized extern section '%s'\n", sec_name);
> > > >                         return -ENOTSUP;
> > > > @@ -2992,9 +3006,9 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
> > > >         /* sort externs by type, for kcfg ones also by (align, size, name) */
> > > >         qsort(obj->externs, obj->nr_extern, sizeof(*ext), cmp_externs);
> > > >
> > > > -       /* for .ksyms section, we need to turn all externs into allocated
> > > > -        * variables in BTF to pass kernel verification; we do this by
> > > > -        * pretending that each extern is a 8-byte variable
> > > > +       /* for .ksyms section, we need to turn all typeless externs into
> > > > +        * allocated variables in BTF to pass kernel verification; we do
> > > > +        * this by pretending that each typeless extern is a 8-byte variable
> > > >          */
> > > >         if (ksym_sec) {
> > > >                 /* find existing 4-byte integer type in BTF to use for fake
> > > > @@ -3012,7 +3026,7 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
> > > >
> > > >                 sec = ksym_sec;
> > > >                 n = btf_vlen(sec);
> > > > -               for (i = 0, off = 0; i < n; i++, off += sizeof(int)) {
> > > > +               for (i = 0, off = 0; i < n; i++) {
> > > >                         struct btf_var_secinfo *vs = btf_var_secinfos(sec) + i;
> > > >                         struct btf_type *vt;
> > > >
> > > > @@ -3025,9 +3039,14 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
> > > >                                 return -ESRCH;
> > > >                         }
> > > >                         btf_var(vt)->linkage = BTF_VAR_GLOBAL_ALLOCATED;
> > > > -                       vt->type = int_btf_id;
> > > > +                       if (ext->ksym.is_typeless) {
> > > > +                               vt->type = int_btf_id;
> > > > +                               vs->size = sizeof(int);
> > > > +                       }
> > > >                         vs->offset = off;
> > > > -                       vs->size = sizeof(int);
> > > > +                       off += vs->size;
> > > > +                       pr_debug("ksym var_secinfo: var '%s', type #%d, size %d, offset %d\n",
> > > > +                                ext->name, vt->type, vs->size, vs->offset);
> > >
> > > It's a bit of a waste that we still allocate memory for those typed
> > > ksym externs, as they don't really need space. But modifying BTF is a
> > > pain right now, so I think we'll have to do it, until we have a better
> > > BTF API. But let's make them integers for now to take a fixed and
> > > small amount of space.
> > >
> >
> > Do you mean making typed ksym externs of type integer? If so, we can't
> > do that, I think. After collect_externs, we later need to compare the
> > declared extern's type against the type defined in kernel. Better not
> > rewrite their types in BTf.
>
> Then maybe we need to make btf_id to point to the actual type of the
> variable, not BTF_KIND_VAR? Or just additionally record type's btf_id,
> not sure which one makes more sense at the moment.
>
> >
> > I am generally against modifying BTF. I initially didn't notice that
> > all the ksym externs' types are modified to 'int' and the type
> > comparison I mentioned above always failed. I dumped the btf in
> > vmlinux and the btf in object file, checked the kernel variable's
> > source code, printed out everything I could. The experience was very
> > bad.
> >
>
> It might be confusing, I agree, but the alternative is just a waste of
> memory just to match the BTF definition of a DATASEC, which describes
> externs. It seems sloppy to allocate a bunch of unused memory just to
> match the kernel's variable size, while in reality we either use 8
> bytes used (for typeless externs, storing ksym address) or none (for
> typed externs).
>
> Another alternative is to not specify BTF ID for .ksyms map, but it's
> not great for typeless externs case, as we are losing all type info
> completely. Trade-offs...
>

I see. It looks like rewriting all ksym externs' type to integers is
the most straightforward solution here, though I felt a bit hacky.

I can record the btf_id of the var's type before rewriting, so
bpf_core_type_are_compat() can find the true type for comparison. One
good thing about recording the type's btf_id is that it can be used to
tell whether the ksym extern is typed or not, before vmlinux_btf_id
gets its value. I will think about this and try the alternatives a bit
more and follow up if I come up with a better solution.

Thanks!

[...]
