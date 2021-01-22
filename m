Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3270F300D54
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 21:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730329AbhAVUGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 15:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729522AbhAVUF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 15:05:59 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066FFC06174A;
        Fri, 22 Jan 2021 12:05:12 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id e67so6590717ybc.12;
        Fri, 22 Jan 2021 12:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L8jS0HzNfqD4thkNxIQ6N1AxEPEUC70ooGhoF1TKbcw=;
        b=dOQjb7CJ+l5Zdb7DzQ2FVeJa6kN5ropptNySqsHo2wFS3utiWUMlLHfI65VK7YdYM0
         HwllVkwwytkIptzGyPCUN0sJD+TjHkxBe5ZR6RhnZ04Av0NbppS3rZiHKkuIKRHi3PzH
         dQQ08wNe0A3CMseHhgdfmohjmL3q4Bts+ghNw7K/I2TfO7HBKMXu1hNthCmErvTWVF+k
         6LJZmIvjonOLfHMpK53O38uPj5qKRNgT/aJyby/joGnUr+4tPNUSfCt4vKW4Oj5Uc0Gl
         ukpICjL6HaCUnGqTX6nODBuJYtOikvVEaJOfmuOnjlNBpcTwM5iZEJw7K31D9j2PvlMA
         LZ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L8jS0HzNfqD4thkNxIQ6N1AxEPEUC70ooGhoF1TKbcw=;
        b=FLg1j0IUB1dTZJBSyih0mMe2BerIQc+FyW9C1nspJapNBHHcyo6zhZNNMSOR8uNIA9
         cc7Vc1P7ptEFZDSixgQZUpJ7G3ghh5KN1oud/aLxxjBYFqB24t3qpDFMbCxEAU/dZnw8
         OVA41BNNEnBPfXJ/9LjXSgINkvjlp+oGdpc8I8EEg6H09Mszv5y7OVz73mbih57cgc/F
         hXGvoCESwJAh2ykoT8UQkwodH8xs5arePEnQkGnQz98ASM9BuYNlGaiXQd+aNuYn2kxX
         MEk2U9280xgpvZKkpmOgBDha/LF86xmJdFr69Dx3A6UbYXavJ9GzzHMprwNflqyDqwPy
         NYXw==
X-Gm-Message-State: AOAM5305HPBF9VfOLsWwzbZVxZnPNAfKgKxz3t1ay9HQ18dKGXdIiYKb
        oHRrdp5D5AXJJ+FnDhbv2uJBiIArcc9IUHWseA8=
X-Google-Smtp-Source: ABdhPJxj9qW9L/HDufNevNp2GUA1P6i+/BKcIKeMfaeHlJsEEugWD0I923OU79Dqk/W4OG19gN7PLYaWIT2FyhCUOzU=
X-Received: by 2002:a25:b195:: with SMTP id h21mr8766090ybj.347.1611345911187;
 Fri, 22 Jan 2021 12:05:11 -0800 (PST)
MIME-Version: 1.0
References: <1610921764-7526-1-git-send-email-alan.maguire@oracle.com>
 <1610921764-7526-4-git-send-email-alan.maguire@oracle.com>
 <CAEf4BzZ6bYenSTUmwu7jXqQOyD=AG75oLsLE5B=9ycPjm1jOkw@mail.gmail.com>
 <CAEf4Bzb4z+ZA+taOEo=N9eSGZaCqMALpFxShujm9GahBOFnhvg@mail.gmail.com> <alpine.LRH.2.23.451.2101221612440.12992@localhost>
In-Reply-To: <alpine.LRH.2.23.451.2101221612440.12992@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 Jan 2021 12:05:00 -0800
Message-ID: <CAEf4BzZBVjUQnPxG1hyxkoM5HLWyEm2VJjOg0MoogrBdm6QdEQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/4] libbpf: BTF dumper support for typed data
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 8:31 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Thu, 21 Jan 2021, Andrii Nakryiko wrote:
>
> > On Wed, Jan 20, 2021 at 10:56 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Sun, Jan 17, 2021 at 2:22 PM Alan Maguire <alan.maguire@oracle.com> wrote:
> > > >
> > > > Add a BTF dumper for typed data, so that the user can dump a typed
> > > > version of the data provided.
> > > >
> > > > The API is
> > > >
> > > > int btf_dump__emit_type_data(struct btf_dump *d, __u32 id,
> > > >                              const struct btf_dump_emit_type_data_opts *opts,
> > > >                              void *data);
> > > >
> >
> > Two more things I realized about this API overnight:
> >
> > 1. It's error-prone to specify only the pointer to data without
> > specifying the size. If user screws up and scecifies wrong type ID or
> > if BTF data is corrupted, then this API would start reading and
> > printing memory outside the bounds. I think it's much better to also
> > require user to specify the size and bail out with error if we reach
> > the end of the allowed memory area.
>
> Yep, good point, especially given in the tracing context we will likely
> only have a subset of the data (e.g. part of the 16k representing a
> task_struct).  The way I was approaching this was to return -E2BIG
> and append a "..." to the dumped data denoting the data provided
> didn't cover the size needed to fully represent the type. The idea is
> the structure is too big for the data provided, hence E2BIG, but maybe
> there's a more intuitive way to do this? See below for more...
>

Hm... that's an interesting use case for sure, but seems reasonable to
support. "..." seems a bit misleading because it can be interpreted as
"we omitted some output for brevity", no? "<truncated>" or something
like that might be more obvious, but I'm just bikeshedding :)

> >
> > 2. This API would be more useful if it also returns the amount of
> > "consumed" bytes. That way users can do more flexible and powerful
> > pretty-printing of raw data. So on success we'll have >= 0 number of
> > bytes used for dumping given BTF type, or <0 on error. WDYT?
> >
>
> I like it! So
>
> 1. if a user provides a too-big data object, we return the amount we used; and
> 2. if a user provides a too-small data object, we append "..." to the dump
>   and return -E2BIG (or whatever error code).
>
> However I wonder for case 2 if it'd be better to use a snprintf()-like
> semantic rather than an error code, returning the amount we would have
> used. That way we easily detect case 1 (size passed in > return value),
> case 2 (size passed in < return value), and errors can be treated separately.
> Feels to me that dealing with truncated data is going to be sufficiently
> frequent it might be good not to classify it as an error. Let me know if
> you think that makes sense.

Hm... Yeah, that would work, I think, and would feel pretty natural.
On the other hand, it's easy to know the total input size needed by
calling btf__resolve_size(btf, type_id), so if user expects to provide
truncated input data and wants to know how much they should have
provided, they can easily do that.

Basically, I don't have strong preference here, though providing
truncated input data still feels more like an error, than a normal
situation... Maybe someone else want to weigh in? And -E2BIG is
distinctive enough in this case. So both would work fine, but not
clear which one is less surprising API.

>
> I'm working on v3, and hope to have something early next week, but a quick
> reply to a question below...
>
> > > > ...where the id is the BTF id of the data pointed to by the "void *"
> > > > argument; for example the BTF id of "struct sk_buff" for a
> > > > "struct skb *" data pointer.  Options supported are
> > > >
> > > >  - a starting indent level (indent_lvl)
> > > >  - a set of boolean options to control dump display, similar to those
> > > >    used for BPF helper bpf_snprintf_btf().  Options are
> > > >         - compact : omit newlines and other indentation
> > > >         - noname: omit member names
> > > >         - zero: show zero-value members
> > > >
> > > > Default output format is identical to that dumped by bpf_snprintf_btf(),
> > > > for example a "struct sk_buff" representation would look like this:
> > > >
> > > > struct sk_buff){
> > > >  (union){
> > > >   (struct){
> > >
> > > Curious, these explicit anonymous (union) and (struct), is that
> > > preferred way for explicitness, or is it just because it makes
> > > implementation simpler and thus was chosen? I.e., if the goal was to
> > > mimic C-style data initialization, you'd just have plain .next = ...,
> > > .prev = ..., .dev = ..., .dev_scratch = ..., all on the same level. So
> > > just checking for myself.
>
> The idea here is that we want to clarify if we're dealing with
> an anonymous struct or union.  I wanted to have things work
> like a C-style initializer as closely as possible, but I
> realized it's not legit to initialize multiple values in a
> union, and more importantly when we're trying to visually interpret
> data, we really want to know if an anonymous container of data is
> a structure (where all values represent different elements in the
> structure) or a union (where we're seeing multiple interpretations of
> the same value).

Yeah, fair enough.

>
> Thanks again for the detailed review!

Of course. But it's not clear if you agree with me on everything, so I
still hope to get replies later.

>
> Alan
