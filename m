Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7CC2A3CD4
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 07:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbgKCGbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 01:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgKCGbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 01:31:39 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35C1C0617A6;
        Mon,  2 Nov 2020 22:31:39 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id k138so7372382ybk.6;
        Mon, 02 Nov 2020 22:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9G3bbskV5dEI0sGGdTrMHJ9BeikdeTTRknQvs4eeQaU=;
        b=BTTIKVKhCTiJBt1wnRff7K3PdnzFJEO4KctGxHxEZqCm+gLLC7dWcNEItQfk6GQ3EQ
         AtK3xdd7Km7IKbFfSJ7JYaWVmhKLrJaKbM88h1B0uw0gUce9bpGYTBp4UqpCW60Lod9e
         w4kdQZu2Xc0J3rYGYW0z9siSP/GgT0rwojXELhBzyjLZf5lrhfHsmbL3O+UbX570UhYR
         +Kpdk5e80nokI+reRyrXqgaq4/NYg1y3Rn73PC7SYTq5A6t+HAm5qMcPeHNhLadN5FGc
         7rvX5brnDiA/WqXoumBUUiQRULdmJTz31nnwx7w15DriXnr8oAcPGoUViHeXomCOAbJ2
         lQgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9G3bbskV5dEI0sGGdTrMHJ9BeikdeTTRknQvs4eeQaU=;
        b=rgiD+AUzAzOHw8l/g7Pi13EWp87ZSeiPmVjfEk/KzKI7n5/w8yNz26BEaao5x/iwta
         Vhjli1Cq0XhAvlFZoKIgsba1ROGxfoYXTApd2Ft+PLoVIT0SxGrXT/7Z/n3yS3Jcly/q
         nsj7CrrD//u1sZHy1XaE8ISpEXNnU/fv46K8v1K0jjfKNON8FSjsxNhi3p2i1LTevOSL
         sRVGY6HSAkdF9R6xhAw+dtG4s+3jssmTV81fDXiWsSE8eklNF9U5qsEf7KBt3cTpcd7+
         kWcqw4OCSsYRN5OlY2Xp2FXBpEGMjEiWlmMUT6+3Ib5zZvKr0pZzh//bwye2bIwzvcC6
         Q9DA==
X-Gm-Message-State: AOAM532sysDV6a95KC1vMCefmxUi++P7pgZmHVe8HWj1oLbopjupuqvp
        hgNdf5ftDjggd8stJUOA0XXX7FPr35zOXQl0hew=
X-Google-Smtp-Source: ABdhPJwZDygmjMRaRbqCDdg+VjfGUan/ikslJEkJ6nElHwrOMcYAJOliQheLNXBxcyYedM0HqANaeVgBSmUmVxBeSwo=
X-Received: by 2002:a25:25c2:: with SMTP id l185mr23772698ybl.230.1604385099044;
 Mon, 02 Nov 2020 22:31:39 -0800 (PST)
MIME-Version: 1.0
References: <20201029005902.1706310-1-andrii@kernel.org> <20201029005902.1706310-9-andrii@kernel.org>
 <4D4CB508-5358-40B3-878C-30D97BCA4192@fb.com> <CAEf4BzaxLMH-ZN+FEhg54J3quGTAHZVg143KWSsD0PFEM5E3yg@mail.gmail.com>
 <4EEF76DA-2E9F-4B09-BD31-817148CDC445@fb.com>
In-Reply-To: <4EEF76DA-2E9F-4B09-BD31-817148CDC445@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Nov 2020 22:31:28 -0800
Message-ID: <CAEf4BzaL51nf_rKF7-pUWHeCiWm37fuFGfku4Z0kmXxmdHRAVA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 08/11] libbpf: support BTF dedup of split BTFs
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 9:59 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Nov 2, 2020, at 9:25 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Nov 2, 2020 at 6:49 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
> >>>
> >>> Add support for deduplication split BTFs. When deduplicating split BTF, base
> >>> BTF is considered to be immutable and can't be modified or adjusted. 99% of
> >>> BTF deduplication logic is left intact (module some type numbering adjustments).
> >>> There are only two differences.
> >>>
> >>> First, each type in base BTF gets hashed (expect VAR and DATASEC, of course,
> >>> those are always considered to be self-canonical instances) and added into
> >>> a table of canonical table candidates. Hashing is a shallow, fast operation,
> >>> so mostly eliminates the overhead of having entire base BTF to be a part of
> >>> BTF dedup.
> >>>
> >>> Second difference is very critical and subtle. While deduplicating split BTF
> >>> types, it is possible to discover that one of immutable base BTF BTF_KIND_FWD
> >>> types can and should be resolved to a full STRUCT/UNION type from the split
> >>> BTF part.  This is, obviously, can't happen because we can't modify the base
> >>> BTF types anymore. So because of that, any type in split BTF that directly or
> >>> indirectly references that newly-to-be-resolved FWD type can't be considered
> >>> to be equivalent to the corresponding canonical types in base BTF, because
> >>> that would result in a loss of type resolution information. So in such case,
> >>> split BTF types will be deduplicated separately and will cause some
> >>> duplication of type information, which is unavoidable.
> >>>
> >>> With those two changes, the rest of the algorithm manages to deduplicate split
> >>> BTF correctly, pointing all the duplicates to their canonical counter-parts in
> >>> base BTF, but also is deduplicating whatever unique types are present in split
> >>> BTF on their own.
> >>>
> >>> Also, theoretically, split BTF after deduplication could end up with either
> >>> empty type section or empty string section. This is handled by libbpf
> >>> correctly in one of previous patches in the series.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> >>
> >> Acked-by: Song Liu <songliubraving@fb.com>
> >>
> >> With some nits:
> >>
> >>> ---
> >>
> >> [...]
> >>
> >>>
> >>>      /* remap string offsets */
> >>>      err = btf_for_each_str_off(d, strs_dedup_remap_str_off, d);
> >>> @@ -3553,6 +3582,63 @@ static bool btf_compat_fnproto(struct btf_type *t1, struct btf_type *t2)
> >>>      return true;
> >>> }
> >>>
> >>
> >> An overview comment about bpf_deup_prep() will be great.
> >
> > ok
> >
> >>
> >>> +static int btf_dedup_prep(struct btf_dedup *d)
> >>> +{
> >>> +     struct btf_type *t;
> >>> +     int type_id;
> >>> +     long h;
> >>> +
> >>> +     if (!d->btf->base_btf)
> >>> +             return 0;
> >>> +
> >>> +     for (type_id = 1; type_id < d->btf->start_id; type_id++)
> >>> +     {
> >>
> >> Move "{" to previous line?
> >
> > yep, my bad
> >
> >>
> >>> +             t = btf_type_by_id(d->btf, type_id);
> >>> +
> >>> +             /* all base BTF types are self-canonical by definition */
> >>> +             d->map[type_id] = type_id;
> >>> +
> >>> +             switch (btf_kind(t)) {
> >>> +             case BTF_KIND_VAR:
> >>> +             case BTF_KIND_DATASEC:
> >>> +                     /* VAR and DATASEC are never hash/deduplicated */
> >>> +                     continue;
> >>
> >> [...]
> >>
> >>>      /* we are going to reuse hypot_map to store compaction remapping */
> >>>      d->hypot_map[0] = 0;
> >>> -     for (i = 1; i <= d->btf->nr_types; i++)
> >>> -             d->hypot_map[i] = BTF_UNPROCESSED_ID;
> >>> +     /* base BTF types are not renumbered */
> >>> +     for (id = 1; id < d->btf->start_id; id++)
> >>> +             d->hypot_map[id] = id;
> >>> +     for (i = 0, id = d->btf->start_id; i < d->btf->nr_types; i++, id++)
> >>> +             d->hypot_map[id] = BTF_UNPROCESSED_ID;
> >>
> >> We don't really need i in the loop, shall we just do
> >>        for (id = d->btf->start_id; id < d->btf->start_id + d->btf->nr_types; id++)
> >> ?
> >>
> >
> > I prefer the loop with i iterating over the count of types, it seems
> > more "obviously correct". For simple loop like this I could do
> >
> > for (i = 0; i < d->btf->nr_types; i++)
> >    d->hypot_map[d->start_id + i] = ...;
> >
> > But for the more complicated one below I found that maintaining id as
> > part of the for loop control block is a bit cleaner. So I just stuck
> > to the consistent pattern across all of them.
>
> How about
>
>         for (i = 0; i < d->btf->nr_types; i++) {
>                 id = d->start_id + i;
>                 ...
> ?

this would be excessive for that single-line for loop. I'd really like
to keep it consistent and confined within the for () block.

>
> I would expect for loop with two loop variable to do some tricks, like two
> termination conditions, or another conditional id++ somewhere in the loop.

Libbpf already uses such two variable loops for things like iterating
over btf_type's members, enums, func args, etc. So it's not an
entirely alien construct. I really appreciate you trying to keep the
code as simple and clean as possible, but I think it's pretty
straightforward in this case and there's no need to simplify it
further.

>
> Thanks,
> Song
>
