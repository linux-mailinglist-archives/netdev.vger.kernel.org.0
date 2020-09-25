Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF2F278F25
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 18:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbgIYQx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 12:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728069AbgIYQx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 12:53:26 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B642C0613CE;
        Fri, 25 Sep 2020 09:53:26 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id 133so2439246ybg.11;
        Fri, 25 Sep 2020 09:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i3Yv2i5n1BXQRbocuOqybLWjqWXTJ31UTC6V2dabgQs=;
        b=SnqftBHqgStr86m+QFn6a5Gtsh2fZ+xwDGrDb8ZvPkFY8FZ4HPBJHx0MjW33QeNRU0
         JjpCukM1B3L9K8c613LWZ4iDmLsBHgXtbi8uluYqliLpBT6HnjyMU1aZ3Njn6JDukuvF
         wVzDJkfHd1va8MBGZAMFdzqgpir8yuVyx6ZiB9tAyJj0UdYrRbYZ24VAkglz1RxOePhk
         jGj07uO/A0Y946ypXJTjFBZFu2XsOgDz7t8RhXpZ9USkZTGOVDu1KO/69DpYFjiMpGsK
         grnMFmYluqKQ4HlGjT0APcPWofXM2sHqBbw4Ojstw4CTjgZqQmOr7DQdpWGtxJWKL9E7
         TIag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i3Yv2i5n1BXQRbocuOqybLWjqWXTJ31UTC6V2dabgQs=;
        b=onLBS0INDXv4ocaJIgx4TC0o60xJFG7rcgnT6irq1oDtcimRp8N9LjXbzkwDNtYUri
         Junz0pK5pZiU6f0pPrVRHgN8c/g4cqizHxtKrDSy3ZapD1xeaqmQ0I9VUalBdvt3sEy2
         UoFvLVdDdkNeJyDLpxHOwazKyfs0lKOKfnMcho7dzKJmOurtsBRavlL2To8WHmglNLQn
         gGfEWVh4d1R1GqDiTM3C4WUcVRtfQG9isEnrc+rxm9qv+BRDxuFdZ4/IY/SrCUSFOZFr
         45E0EbRXTvA0/6OumpqmRKIQlHqt78njS4AmiZYFlBWb+K0a4P3ATLHz/KT8cQ5rrNLe
         tOTg==
X-Gm-Message-State: AOAM532ZNUyBWVkeYycZHgDQS31osjvvp3FK+IKUuBv0X7CJhtb+p6jc
        2SroN6peI5xKU8/K6/SzHAAMCbP2uAuVcQA9Ed4=
X-Google-Smtp-Source: ABdhPJyb7TVLRUVCDAjVFGEJxUhyXfrV71/p3M40HGQ29w4Xl0iYWq13ZjGExaH3F28okaowtcfEdJxhAdvuFHNuxV8=
X-Received: by 2002:a25:6644:: with SMTP id z4mr90030ybm.347.1601052805098;
 Fri, 25 Sep 2020 09:53:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200923155436.2117661-1-andriin@fb.com> <20200923155436.2117661-8-andriin@fb.com>
 <20200925035541.2hjmie5po4lypbgk@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYFswwhJOq4bSDZU5-bqUo+LwwUQ_NRH_zkBgGcBVYOjw@mail.gmail.com> <731e94e1-b246-4838-9611-66d91d7d2518@fb.com>
In-Reply-To: <731e94e1-b246-4838-9611-66d91d7d2518@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Sep 2020 09:53:14 -0700
Message-ID: <CAEf4BzYAxK8Cphd4OVBBizjHXbowkYaYmjvQ2vvvv4c_p+81cw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 7/9] libbpf: add BTF writing APIs
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 8:37 AM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 9/24/20 11:21 PM, Andrii Nakryiko wrote:
> > On Thu, Sep 24, 2020 at 8:55 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> >>
> >> On Wed, Sep 23, 2020 at 08:54:34AM -0700, Andrii Nakryiko wrote:
> >>> Add APIs for appending new BTF types at the end of BTF object.
> >>>
> >>> Each BTF kind has either one API of the form btf__append_<kind>(). For types
> >>> that have variable amount of additional items (struct/union, enum, func_proto,
> >>> datasec), additional API is provided to emit each such item. E.g., for
> >>> emitting a struct, one would use the following sequence of API calls:
> >>>
> >>> btf__append_struct(...);
> >>> btf__append_field(...);
> >>> ...
> >>> btf__append_field(...);
> >>
> >> I've just started looking through the diffs. The first thing that struck me
> >> is the name :) Why 'append' instead of 'add' ? The latter is shorter.
> >
> > Append is very precise about those types being added at the end. Add
> > is more ambiguous in that sense and doesn't imply any specific order.
> > E.g., for btf__add_str() that's suitable, because the order in which
> > strings are inserted might be different (e.g., if the string is
> > duplicated). But it's not an "insert" either, so I'm fine with
> > renaming to "add", if you prefer it.
>
> The reason I prefer shorter is to be able to write:
> btf__add_var(btf, "my_var", global,
>               btf__add_const(btf,
>               btf__add_volatile(btf,
>               btf__add_ptr(btf,
>               btf__add_int(btf, "int", 4, signed))));

That's an interesting way of using it, I'll give you that :)

Ok, I'll switch to "add" name.

>
> In other words the shorter the type the more suitable the api
> will be for manual construction of types.
> Looks like the api already checks for invalid type_id,
> so no need to check validity at every build stage.
> Hence it's nice to combine multiple btf__add_*() into single line.
>
> I think C language isn't great for 'constructor' style api.
> May be on top of the above api we can add c++-like api?
> For example we can define
> struct btf_builder {
>     struct btf_builder * (*_volatile) (void);
>     struct btf_builder * (*_const) (void);
>     struct btf_builder * (*_int) (char *name, int sz, int encoding);
>     struct btf_builder * (_ptr) (void);
> };
>
> and the use it as:
>      struct btf_builder *b = btf__create_global_builer(...);
>
>      b->_int("int", 4, singed)
>       ->_const()
>       ->_volatile()
>       ->_ptr()
>       ->_var("my_var", global);
>
> Every method will be return its own object (only one such object)
> while the actual building will be happening in some 'invisible',
> global, and mutex protected place.
>
> >>
> >> Also how would you add anon struct that is within another struct ?
> >> The anon one would have to be added first and then added as a field?
> >> Feels a bit odd that struct/union building doesn't have 'finish' method,
> >> but I guess it can work.
> >
> > That embedded anon struct will be a separate type, then the field
> > (anonymous or not, that's orthogonal to anonymity of a struct (!))
> > will refer to that anon struct type by its ID. Anon struct can be
> > added right before, right after, or in between completely unrelated
> > types, it doesn't matter to BTF itself as long as all the type IDs
> > match in the end.
> >
> > As for the finish method... There wasn't a need so far to have it, as
> > BTF constantly maintains correct vlen for the "current"
> > struct/union/func_proto/datasec/enum (anything with extra members).
> > I've been writing a few more tests than what I posted here (they will
> > come in the second wave of patches) and converted pahole to this new
> > API completely. And it does feel pretty nice and natural so far. In
> > the future we might add something like that, I suppose, that would
> > allow to do some more validations at the end. But that would be a
> > non-breaking extension, so I don't want to do it right now.
>
> sure. that's fine.
> Also I suspect sooner or later would be good to do at least partial
> dedup of types while they're being built.
> Instead of passing exact btf_id of 'int' everywhere it would be
> human friendlier to say:
>    b->_int("int", 4, singed)->_var("my_var")
> instead of having extra variable that holds btf_id of 'int' and
> use as it:
>    u32 btf_id_of_int; /* that is used everywhere where 'int' field of
> var needs to be added */
>    b->__var("my_var", btf_id_of_int);
>
> I mean since types are being built the real dedup cannot happen,
> but dedup of simple types can happen on the fly.
> That will justify 'add' vs 'append' as well.
> Just a thought.
>

That's doable, though certainly added complexity. Unless you need to
generate millions of those variables, just appending "int"s many times
and then doing dedup once would be faster and simpler, using just a
touch more memory. But certainly something to keep in mind.
