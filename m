Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC3734A072
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 05:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhCZERm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 00:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhCZERN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 00:17:13 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862B1C06174A;
        Thu, 25 Mar 2021 21:17:13 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id l15so4644900ybm.0;
        Thu, 25 Mar 2021 21:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yx5Zvveu4LIX+5VbXrbKgdOCYF4RCquqCo9+ZTmAEYM=;
        b=rwFcAbVQexhTq9gcKqOW7RncMuDcf0CMvEsCbDB1Cigt4Sh6Rap+5IFCpeHaeqhDUI
         9kLCUZHcKxyM16mWUfIEmKbT9zaAnGy5zjlsdhLCGq+QaFQA8H27WhohuRN/VKdZi+M3
         vtfV8LHjpiZXvHVY6NP98asgn9H4cEOer9oZkv02elxwe7oNCjeGMZwuDhMkyOvyVK4A
         UVrNOAoQ0Pwu/Y2eamI4tn0kKEvwR9DhH1NzR8vIRI2Csyr0a6pMrofVWj3Awxlql/zV
         lTRRIu6gkR6Es0PbNCSVxDG9aUxUFegI9MRvkz3Cvcsc2K2f1cGF9hJ074WoBdeFjKhs
         Zr1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yx5Zvveu4LIX+5VbXrbKgdOCYF4RCquqCo9+ZTmAEYM=;
        b=Ed7FxHTNfOPd2CsQES9XTZC6uraCum8Nwgd0ygjzMQJc9GCoOqvHkv+yCN8nlKU3zV
         VpoNViqwVRu+soHSinfLWourD5TEM0e2/T4xURO6ZwKUiG+teG2RMmqja/8VRCV5f9zt
         bv4vlDtsEKWLdzpvd+YY+1e/m1Hbd3mS/DovembgqJDIWszpe9BCp0Vgmi4FDKp++C0E
         LGIiV2pur8nHJHUJC8yERWoCSrZ6eDKoMDUh97XC5KNQ3QinVKe8QcqNQ0J5LXg5Mfrx
         lgT4ckO0GoGwTfPTACnoinBt/ln8KDKNfJb5gz+HxVzNwwtWiCmB9ExnH95JoZlqyaVN
         2tog==
X-Gm-Message-State: AOAM532INrJ1wEuL/VifuhAkrkmN3FRbcsSvKqrB9sVCQWLrLhFN+om8
        Mk13vJ+GxIEnnDAraLfbe/rOlK/kgeXRf/inf9A=
X-Google-Smtp-Source: ABdhPJx75SmuOW6chJQ3Zx76OW6mDoxx8knNy2dElXzxWBu5rD8t1fAvFMWLx09PGZcK2vOWc+P4dpvnHTeW9a+CtHU=
X-Received: by 2002:a25:874c:: with SMTP id e12mr15994958ybn.403.1616732232858;
 Thu, 25 Mar 2021 21:17:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210325051131.984322-1-andrii@kernel.org> <c2e9328c-1998-d921-c875-c1d53c5a5d9a@fb.com>
In-Reply-To: <c2e9328c-1998-d921-c875-c1d53c5a5d9a@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 25 Mar 2021 21:17:02 -0700
Message-ID: <CAEf4BzZSnQyiE+y=5eK3110hxtug_YUSnH0BPjEjzEtg19zYpQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: preserve empty DATASEC BTFs during
 static linking
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 8:31 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 3/24/21 10:11 PM, Andrii Nakryiko wrote:
> > Ensure that BPF static linker preserves all DATASEC BTF types, even if some of
> > them might not have any variable information at all. It's not completely clear
> > in which cases Clang chooses to not emit variable information, so adding
> > reliable repro is hard. But manual testing showed that this work correctly.
>
> This may happen if the compiler promotes local initialized variable
> contents into .rodata section and there are no global or static
> functions in the program.
>
> For example,
> $ cat t.c
> struct t { char a; char b; char c; };
> void bar(struct t*);
> void find() {
>    struct t tmp = {1, 2, 3};
>    bar(&tmp);
> }
>
> $ clang -target bpf -O2 -g -S t.c
> you will find:
>
>          .long   104                             # BTF_KIND_DATASEC(id = 8)
>          .long   251658240                       # 0xf000000
>          .long   0
>
>          .ascii  ".rodata"                       # string offset=104
>
> $ clang -target bpf -O2 -g -c t.c
> $ readelf -S t.o | grep data
>    [ 4] .rodata           PROGBITS         0000000000000000  00000090
>
> >
> > Reported-by: Alexei Starovoitov <ast@kernel.org>
> > Fixes: 8fd27bf69b86 ("libbpf: Add BPF static linker BTF and BTF.ext support")
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Ack with a nit below.
>
> Acked-by: Yonghong Song <yhs@fb.com>
>
> > ---
> >   tools/lib/bpf/linker.c | 12 +++++++++++-
> >   1 file changed, 11 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
> > index 5e0aa2f2c0ca..2c43943da30c 100644
> > --- a/tools/lib/bpf/linker.c
> > +++ b/tools/lib/bpf/linker.c
> > @@ -94,6 +94,7 @@ struct dst_sec {
> >       int sec_sym_idx;
> >
> >       /* section's DATASEC variable info, emitted on BTF finalization */
> > +     bool has_btf;
> >       int sec_var_cnt;
> >       struct btf_var_secinfo *sec_vars;
> >
> > @@ -1436,6 +1437,15 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
> >                       continue;
> >               dst_sec = &linker->secs[src_sec->dst_id];
> >
> > +             /* Mark section as having BTF regardless of the presence of
> > +              * variables. It seems to happen sometimes when BPF object
> > +              * file has only static variables inside functions, not
> > +              * globally, that DATASEC BTF with zero variables will be
> > +              * emitted by Clang. We need to preserve such empty BTF and
>
> Maybe give a more specific example here, e.g.,
> For example, these static variables may be generated by the compiler
> by promoting local array/structure variable initial values.

Yep, thanks for explanations, I'll update the comment and commit message.

>
> > +              * just set correct section size.
> > +              */
> > +             dst_sec->has_btf = true;
> > +
> >               t = btf__type_by_id(obj->btf, src_sec->sec_type_id);
> >               src_var = btf_var_secinfos(t);
> >               n = btf_vlen(t);
> > @@ -1717,7 +1727,7 @@ static int finalize_btf(struct bpf_linker *linker)
> >       for (i = 1; i < linker->sec_cnt; i++) {
> >               struct dst_sec *sec = &linker->secs[i];
> >
> > -             if (!sec->sec_var_cnt)
> > +             if (!sec->has_btf)
> >                       continue;
> >
> >               id = btf__add_datasec(btf, sec->sec_name, sec->sec_sz);
> >
