Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4208420BBBF
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgFZVkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFZVkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 17:40:45 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB95C03E979;
        Fri, 26 Jun 2020 14:40:45 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id c139so10134236qkg.12;
        Fri, 26 Jun 2020 14:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U9GEuLAqPzHusxfPaQ3dub4UAeTQRz3EPFD11datFeE=;
        b=tD9MalpSDHOnx3RCAGjsaRLpUiE7ipsU2Ta4JFhf4/iI3NEtmUw8vz2fWVNPWgrFah
         Z/4zb6Oc+24QAhcrYYPNnv+RAR/jH1Ul++4F2idjPvpDkQ4i5Wxf6w0xQiIQsjvaUxCN
         iKvVTchw5ucYzzWtrbbHZqr5d185C4jXwSaNZoKZwf81KGoZG1NDGXnlS1FTi7k/Zw43
         8bu+py07aF1dUi0iLFLHvXs68n6Fyfcp70F00mLMn9Eg5QpMjWJFgpWrVYKx9eTwL1Rm
         7j4AijV4wPgkWtaefRzc205kmpQebwIUflZ98woOBpw8WPZG7TuzZqEyW8gfOhmrtVic
         xaxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U9GEuLAqPzHusxfPaQ3dub4UAeTQRz3EPFD11datFeE=;
        b=NptDrRHkDwsAA32RI4zrW/3EuIyj2WJc8bpBmS9Hq4msKrOd3z5omvedOuhTszh2NN
         G0ipAk6XJrAjVOmbYQgXPQ2cx3au/BGlT+1HZG6DfstyLDAuFapDRlg2u9BjfleUTon7
         eFbMihrgK2SXkoUPhQgBfSd6zOOea4PKsR/Gw9gU8bspjzAtCvw9vIXUy8jH13IxRqEu
         b8mpNk7zceBYt7/nAErXgQYDU1VDv/iZSuxOAl7u3DponMpm304ZMPHNXlS9CK30QatK
         z4vU8LmoAHhyuRzDr0PuXL5ktHa13IgxVwpJsYNPQrtbHrdHtnoceVGETN3alxHIq1JH
         v/zg==
X-Gm-Message-State: AOAM531M0P9HcL+XMUi/wt6n6xR+QDA9S2lXmFv7S7MMXE7l8F772tWa
        RL7mIqD+19QAa/dph1EGRQN4BzFwNSX0MMLA2ak=
X-Google-Smtp-Source: ABdhPJz+xpjr4Njfjic0gumZoviO1tDennuR5fXCiPYYGs4QiUTChBlL2g5yYXV+p/hTo3aHYvZwrTsssM4QukqpZxs=
X-Received: by 2002:a05:620a:12d2:: with SMTP id e18mr4935345qkl.437.1593207644643;
 Fri, 26 Jun 2020 14:40:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200625221304.2817194-1-jolsa@kernel.org> <20200625221304.2817194-6-jolsa@kernel.org>
 <7480f7b2-01f0-f575-7e4f-cf3bde851c3f@fb.com>
In-Reply-To: <7480f7b2-01f0-f575-7e4f-cf3bde851c3f@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 14:40:33 -0700
Message-ID: <CAEf4BzYPvNbYNBuqFDY8xCqSGTZ2G8HM=waq9b=qO9UYOUK7+A@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 05/14] bpf: Remove btf_id helpers resolving
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 2:37 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/25/20 3:12 PM, Jiri Olsa wrote:
> > Now when we moved the helpers btf_id arrays into .BTF_ids section,
> > we can remove the code that resolve those IDs in runtime.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   kernel/bpf/btf.c | 90 +++++-------------------------------------------
> >   1 file changed, 8 insertions(+), 82 deletions(-)
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 4c3007f428b1..4da6b0770ff9 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -4079,96 +4079,22 @@ int btf_struct_access(struct bpf_verifier_log *log,
> >       return -EINVAL;
> >   }
> >
> > -static int __btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn,
> > -                                int arg)
> > +int btf_resolve_helper_id(struct bpf_verifier_log *log,
> > +                       const struct bpf_func_proto *fn, int arg)
> >   {
> > -     char fnname[KSYM_SYMBOL_LEN + 4] = "btf_";
> > -     const struct btf_param *args;
> > -     const struct btf_type *t;
> > -     const char *tname, *sym;
> > -     u32 btf_id, i;
> > +     int id;
> >
> > -     if (IS_ERR(btf_vmlinux)) {
> > -             bpf_log(log, "btf_vmlinux is malformed\n");
> > +     if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID)
> >               return -EINVAL;
> > -     }
> > -
> > -     sym = kallsyms_lookup((long)fn, NULL, NULL, NULL, fnname + 4);
> > -     if (!sym) {
> > -             bpf_log(log, "kernel doesn't have kallsyms\n");
> > -             return -EFAULT;
> > -     }
> >
> > -     for (i = 1; i <= btf_vmlinux->nr_types; i++) {
> > -             t = btf_type_by_id(btf_vmlinux, i);
> > -             if (BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF)
> > -                     continue;
> > -             tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
> > -             if (!strcmp(tname, fnname))
> > -                     break;
> > -     }
> > -     if (i > btf_vmlinux->nr_types) {
> > -             bpf_log(log, "helper %s type is not found\n", fnname);
> > -             return -ENOENT;
> > -     }
> > -
> > -     t = btf_type_by_id(btf_vmlinux, t->type);
> > -     if (!btf_type_is_ptr(t))
> > -             return -EFAULT;
> > -     t = btf_type_by_id(btf_vmlinux, t->type);
> > -     if (!btf_type_is_func_proto(t))
> > -             return -EFAULT;
> > -
> > -     args = (const struct btf_param *)(t + 1);
> > -     if (arg >= btf_type_vlen(t)) {
> > -             bpf_log(log, "bpf helper %s doesn't have %d-th argument\n",
> > -                     fnname, arg);
> > +     if (WARN_ON_ONCE(!fn->btf_id))
>
> The original code does not have this warning. It directly did
> "ret = READ_ONCE(*btf_id);" after testing reg arg type ARG_PTR_TO_BTF_ID.
>
> >               return -EINVAL;
> > -     }
> >
> > -     t = btf_type_by_id(btf_vmlinux, args[arg].type);
> > -     if (!btf_type_is_ptr(t) || !t->type) {
> > -             /* anything but the pointer to struct is a helper config bug */
> > -             bpf_log(log, "ARG_PTR_TO_BTF is misconfigured\n");
> > -             return -EFAULT;
> > -     }
> > -     btf_id = t->type;
> > -     t = btf_type_by_id(btf_vmlinux, t->type);
> > -     /* skip modifiers */
> > -     while (btf_type_is_modifier(t)) {
> > -             btf_id = t->type;
> > -             t = btf_type_by_id(btf_vmlinux, t->type);
> > -     }
> > -     if (!btf_type_is_struct(t)) {
> > -             bpf_log(log, "ARG_PTR_TO_BTF is not a struct\n");
> > -             return -EFAULT;
> > -     }
> > -     bpf_log(log, "helper %s arg%d has btf_id %d struct %s\n", fnname + 4,
> > -             arg, btf_id, __btf_name_by_offset(btf_vmlinux, t->name_off));
> > -     return btf_id;
> > -}
> > +     id = fn->btf_id[arg];
>
> The corresponding BTF_ID definition here is:
>    BTF_ID_LIST(bpf_skb_output_btf_ids)
>    BTF_ID(struct, sk_buff)
>
> The bpf helper writer needs to ensure proper declarations
> of BTF_IDs like the above matching helpers definition.
> Support we have arg1 and arg3 as BTF_ID. then the list
> definition may be
>
>    BTF_ID_LIST(bpf_skb_output_btf_ids)
>    BTF_ID(struct, sk_buff)
>    BTF_ID(struct, __unused)
>    BTF_ID(struct, task_struct)
>
> This probably okay, I guess.
>
> >
> > -int btf_resolve_helper_id(struct bpf_verifier_log *log,
> > -                       const struct bpf_func_proto *fn, int arg)
> > -{
> > -     int *btf_id = &fn->btf_id[arg];
> > -     int ret;
> > -
> > -     if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID)
> > +     if (!id || id > btf_vmlinux->nr_types)
> >               return -EINVAL;
>
> id == 0 if btf_id cannot be resolved by resolve_btfids, right?
> when id may be greater than btf_vmlinux->nr_types? If resolve_btfids
> application did incorrect transformation?
>
> Anyway, this is to resolve helper meta btf_id. Even if you
> return a btf_id > btf_vmlinux->nr_types, verifier will reject
> since it will never be the same as the real parameter btf_id.
> I would drop id > btf_vmlinux->nr_types here. This should never
> happen for a correct tool. Even if it does, verifier will take
> care of it.
>

I'd love to hear Alexei's thoughts about this change as well. Jiri
removed not just BTF ID resolution, but also all the sanity checks.
This now means more trust in helper definitions to not screw up
anything. It's probably OK, but still something to consciously think
about.

> > -
> > -     ret = READ_ONCE(*btf_id);
> > -     if (ret)
> > -             return ret;
> > -     /* ok to race the search. The result is the same */
> > -     ret = __btf_resolve_helper_id(log, fn->func, arg);
> > -     if (!ret) {
> > -             /* Function argument cannot be type 'void' */
> > -             bpf_log(log, "BTF resolution bug\n");
> > -             return -EFAULT;
> > -     }
> > -     WRITE_ONCE(*btf_id, ret);
> > -     return ret;
> > +     return id;
> >   }
> >
> >   static int __get_type_size(struct btf *btf, u32 btf_id,
> >
