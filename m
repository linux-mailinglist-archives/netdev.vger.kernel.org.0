Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608852A3BEC
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgKCFZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCFZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:25:29 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B48FC0617A6;
        Mon,  2 Nov 2020 21:25:29 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id a12so13753419ybg.9;
        Mon, 02 Nov 2020 21:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T/RhqJW6mwbPi64TheokA4x5TJXa1KGC918pyhkNBF8=;
        b=mX6qVNzD+BywesEl8D83XQj3TAHPkTCpnm1t0vq71fHHxLto44ywqQ4LevDMynXIjN
         ZXuCb0gzukvUrcGyXR9sG/6qV8tFp09PhVTdD1LLnQSwDqVQUd61jhYZf0KChkycb0mS
         FMJUxJlVbm2+gp5wOfzrF3lI4v5nq8pbWV1FXIARpQqA3/1nrV3EQpoNERlXEjQlcbAY
         8edF+crP51YXspb26oRL02dEq/xyqoGPR7vRCOdpTyK79bdjIYLgJDZOTQGH5IwJhydj
         4yKURutWZ/JjCmV/LtF/5r+MPdF0pGLbIPo0PKjvhaeaZlMKehjeMuFu/NeY7XWN6Ihx
         8GSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T/RhqJW6mwbPi64TheokA4x5TJXa1KGC918pyhkNBF8=;
        b=QpxGWQnOSy+8PhcjPvlpXKOJoqNhCOt2ippxmqmkveS2YIkdFzSphPSF8w+4+t9zwQ
         GkT3Z5FDUqp7DRk5nMA1d2ElTMNdsRw89w2bQsTtSACbvmSNR8LQJm/2zZa8l7PWy0il
         m9Vzf0xYqnDA8hRfbUPB5gkMUfcs1twmNfzdZEWur/oSWFCiywHt/YenFQNhk8a4UP5+
         P+Km4mCLP7QmVCXe8UyXB51cn/uaaAN9nhNGKOV0u+y6u6qosz7BrKTID6gktfN4vTBp
         7sBdFqoIfnSzDOAx1j80Voi3ITavhj2+Vu0l/4Ii8K1mOPvktoV4PziUZGsxzGMuRlfl
         JjAA==
X-Gm-Message-State: AOAM532x+WoaMslpERwjFaAyad9mZ2ecGMBLXIcIsY04l5JfIAe/PEEd
        SOPIx/tU0JrNiy9qMxlzmLcsWakNMOSMqlxkhE6em6oV+CE=
X-Google-Smtp-Source: ABdhPJx0oPRpZvgig4IX1mLKCst8ishisLCeFBzODeJKkC56QXyeO1qAGjl569pk4d7KwvdSyPEXyJQenAIHq+OVLUQ=
X-Received: by 2002:a25:3443:: with SMTP id b64mr25142736yba.510.1604381128521;
 Mon, 02 Nov 2020 21:25:28 -0800 (PST)
MIME-Version: 1.0
References: <20201029005902.1706310-1-andrii@kernel.org> <20201029005902.1706310-9-andrii@kernel.org>
 <4D4CB508-5358-40B3-878C-30D97BCA4192@fb.com>
In-Reply-To: <4D4CB508-5358-40B3-878C-30D97BCA4192@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Nov 2020 21:25:17 -0800
Message-ID: <CAEf4BzaxLMH-ZN+FEhg54J3quGTAHZVg143KWSsD0PFEM5E3yg@mail.gmail.com>
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

On Mon, Nov 2, 2020 at 6:49 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
> >
> > Add support for deduplication split BTFs. When deduplicating split BTF, base
> > BTF is considered to be immutable and can't be modified or adjusted. 99% of
> > BTF deduplication logic is left intact (module some type numbering adjustments).
> > There are only two differences.
> >
> > First, each type in base BTF gets hashed (expect VAR and DATASEC, of course,
> > those are always considered to be self-canonical instances) and added into
> > a table of canonical table candidates. Hashing is a shallow, fast operation,
> > so mostly eliminates the overhead of having entire base BTF to be a part of
> > BTF dedup.
> >
> > Second difference is very critical and subtle. While deduplicating split BTF
> > types, it is possible to discover that one of immutable base BTF BTF_KIND_FWD
> > types can and should be resolved to a full STRUCT/UNION type from the split
> > BTF part.  This is, obviously, can't happen because we can't modify the base
> > BTF types anymore. So because of that, any type in split BTF that directly or
> > indirectly references that newly-to-be-resolved FWD type can't be considered
> > to be equivalent to the corresponding canonical types in base BTF, because
> > that would result in a loss of type resolution information. So in such case,
> > split BTF types will be deduplicated separately and will cause some
> > duplication of type information, which is unavoidable.
> >
> > With those two changes, the rest of the algorithm manages to deduplicate split
> > BTF correctly, pointing all the duplicates to their canonical counter-parts in
> > base BTF, but also is deduplicating whatever unique types are present in split
> > BTF on their own.
> >
> > Also, theoretically, split BTF after deduplication could end up with either
> > empty type section or empty string section. This is handled by libbpf
> > correctly in one of previous patches in the series.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> With some nits:
>
> > ---
>
> [...]
>
> >
> >       /* remap string offsets */
> >       err = btf_for_each_str_off(d, strs_dedup_remap_str_off, d);
> > @@ -3553,6 +3582,63 @@ static bool btf_compat_fnproto(struct btf_type *t1, struct btf_type *t2)
> >       return true;
> > }
> >
>
> An overview comment about bpf_deup_prep() will be great.

ok

>
> > +static int btf_dedup_prep(struct btf_dedup *d)
> > +{
> > +     struct btf_type *t;
> > +     int type_id;
> > +     long h;
> > +
> > +     if (!d->btf->base_btf)
> > +             return 0;
> > +
> > +     for (type_id = 1; type_id < d->btf->start_id; type_id++)
> > +     {
>
> Move "{" to previous line?

yep, my bad

>
> > +             t = btf_type_by_id(d->btf, type_id);
> > +
> > +             /* all base BTF types are self-canonical by definition */
> > +             d->map[type_id] = type_id;
> > +
> > +             switch (btf_kind(t)) {
> > +             case BTF_KIND_VAR:
> > +             case BTF_KIND_DATASEC:
> > +                     /* VAR and DATASEC are never hash/deduplicated */
> > +                     continue;
>
> [...]
>
> >       /* we are going to reuse hypot_map to store compaction remapping */
> >       d->hypot_map[0] = 0;
> > -     for (i = 1; i <= d->btf->nr_types; i++)
> > -             d->hypot_map[i] = BTF_UNPROCESSED_ID;
> > +     /* base BTF types are not renumbered */
> > +     for (id = 1; id < d->btf->start_id; id++)
> > +             d->hypot_map[id] = id;
> > +     for (i = 0, id = d->btf->start_id; i < d->btf->nr_types; i++, id++)
> > +             d->hypot_map[id] = BTF_UNPROCESSED_ID;
>
> We don't really need i in the loop, shall we just do
>         for (id = d->btf->start_id; id < d->btf->start_id + d->btf->nr_types; id++)
> ?
>

I prefer the loop with i iterating over the count of types, it seems
more "obviously correct". For simple loop like this I could do

for (i = 0; i < d->btf->nr_types; i++)
    d->hypot_map[d->start_id + i] = ...;

But for the more complicated one below I found that maintaining id as
part of the for loop control block is a bit cleaner. So I just stuck
to the consistent pattern across all of them.

> >
> >       p = d->btf->types_data;
> >
> > -     for (i = 1; i <= d->btf->nr_types; i++) {
> > -             if (d->map[i] != i)
> > +     for (i = 0, id = d->btf->start_id; i < d->btf->nr_types; i++, id++) {
>
> ditto
>
> > +             if (d->map[id] != id)
> >                       continue;
> >
> [...]
>
