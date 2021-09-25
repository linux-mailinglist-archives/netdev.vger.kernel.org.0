Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C853417EA0
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 02:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345765AbhIYAce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 20:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbhIYAcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 20:32:32 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2F2C061571;
        Fri, 24 Sep 2021 17:30:58 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id r4so9395441ybp.4;
        Fri, 24 Sep 2021 17:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XTIT3DcDFj/D+7v/Md+zN3ePNaIce3cNTgFNX/N3AOU=;
        b=iyay8woXD748wpwbDvwdFJ2t8R87psS04WMV6wZ2iB8x+q8XMTYLvVs+z+hEj9TwEt
         WElZaXOh6CU67l86H4nlww/hvcBDmX6i+Q+l1fQiRzkMMCj3EshvwAIItsQz/GshXQgM
         pkA7Hu0+6p9KC5KVYi1OSQogdER5Wvrr38tirC8BsH8JlaIzhpGi8qj+P0Yv9F0NgYzZ
         wYlHlwV8Fp9Bkf2q479gMWSwx4nREiq/jEguV9Z/xMS7EqndSwngPCtcFdXyHf3+R1xF
         CEXtR0JPeEMDZ9IrA37C6xt/EaQKs3RI6QBiAMRAQB2ZXodisaMB1IzW+uRpV2AN29gB
         DduQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XTIT3DcDFj/D+7v/Md+zN3ePNaIce3cNTgFNX/N3AOU=;
        b=bNAFtU8nDqycZE4+yN2Jn1KM2ZwoFV8zUA8HvwLLn5mC68DiYXPZNQgAPO2pdHAi1Z
         N+EEYgN+O7BfyqDmkaqfkdnnu128kbZ6rpVaWz7Lp/K5FtZGlhAhK3NqLVV6Hdj5Mypk
         UUaYLjIzcP7P5HxgPfnV0oxOuUAkSMOQfOBqIQq1Y262Qb35yAiiqJhBPTEH0VhrB2cE
         l/Sv2x+HWsVQEH4VZ6zxpLq/AjYVWfWhPrUEScv7JKkgLR9xynxsXE/gZjXjNbx70YpM
         oDqNamke+aigEvKa7Y8FKxrUukM+r+7OaHN6pVKDsHB8hfnEGBroZgXmxjPQSs2hS7i+
         aS/A==
X-Gm-Message-State: AOAM533lBsHNdfxCNp90vAOkMaZnGxx88cOUb5oCC9ArcWwDi76Mc44k
        sIhfxP56hToGvNvZAK/kGS6N+1HJw52T48zDFoA=
X-Google-Smtp-Source: ABdhPJxCrm3O6ya6Ol31/WqjQ1liykKg7+y+pcBuiAClWEcmzn7Wr3Eb07VWF1u1qzAk2ZGrco96A8PSq5TwFuJdbWU=
X-Received: by 2002:a05:6902:724:: with SMTP id l4mr15247970ybt.433.1632529857216;
 Fri, 24 Sep 2021 17:30:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210920141526.3940002-1-memxor@gmail.com> <20210920141526.3940002-7-memxor@gmail.com>
 <CAEf4BzaZOv5c=-hs4UX3UcqP-fFkv8ABx5FAWXRMCDE8-vZ9Lg@mail.gmail.com> <20210924235417.eqhzbrajwkenk6rd@apollo.localdomain>
In-Reply-To: <20210924235417.eqhzbrajwkenk6rd@apollo.localdomain>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 24 Sep 2021 17:30:46 -0700
Message-ID: <CAEf4BzYXNnCJJ3_xQRxZHnYemTXCw7--BRE+Y5HSVfE5OOJeyw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 06/11] libbpf: Support kernel module function calls
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 4:54 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Wed, Sep 22, 2021 at 04:11:13AM IST, Andrii Nakryiko wrote:
> > On Mon, Sep 20, 2021 at 7:15 AM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > > [...]
> > > +                       return -E2BIG;
> > > +               }
> > > +               ext->ksym.offset = index;
> >
> > > +       } else {
> > > +               ext->ksym.offset = 0;
> > >         }
> >
> > I think it will be cleaner if you move the entire offset determination
> > logic after all the other checks are performed and ext is mostly
> > populated. That will also make the logic shorter and simpler because
> > if ayou find kern_btf_fd match, you can exit early (or probably rather
>
> Ack to everything else (including the other mail), but...
>
> > goto to report the match and exit). Otherwise
> >
>
> This sentence got eaten up.

No idea what I was going to say here, sorry... Sometimes Gmail UI
glitches with undo/redo, maybe that's what happened here. Doesn't
matter, ignore the "Otherwise" part.

>
> > >
> > >         kern_func = btf__type_by_id(kern_btf, kfunc_id);
> >
> > this is actually extremely wasteful for module BTFs. Let's add
> > internal (at least for now) helper that will search only for "own" BTF
> > types in the BTF, skipping types in base BTF. Something like
> > btf_type_by_id_own()?
> >
>
> Just to make sure I am not misunderstanding: I don't see where this is wasteful.
> btf_type_by_id seems to not be searching anything, but just returns pointer in
> base BTF if kfunc_id < btf->start_id, otherwise in module BTF.
>

Hm, sorry... Right sentiment and thought, but wrong piece of code to
quote it on.

I had in mind the btf__find_by_name_kind() use in find_ksym_btf_id().
Once we start going over each module, we shouldn't be re-checking
vmlinux BTF when doing btf__find_by_name_kind. It should only check
the types that each module BTF adds on top of vmlinux BTF. That's what
would be good to optimize, especially as more complicated BPF programs
will start using more ksym vars and funcs.


> What am I missing? I guess the 'kern_btf' name was the source of confusion? If
> so, I'll rename it.
>
> Thanks.
>
> --
> Kartikeya
