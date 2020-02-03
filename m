Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7FC1501FF
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 08:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgBCH3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 02:29:13 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35072 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727312AbgBCH3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 02:29:12 -0500
Received: by mail-qt1-f193.google.com with SMTP id n17so9538482qtv.2;
        Sun, 02 Feb 2020 23:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s0gCUwJEUxpdaZHCvvLKXwd/easrsvYbjTgjrxKfnjE=;
        b=HgNn3H3Mv7SLPnYzDuLv43TVnDklSEit1ZBQ7fEOtwucBhIsU9d+fir1S1+ARux94d
         i9PQOQTnXo74hjbbGWTVgKEVB+NcNajXoQgYZL8Dxt8Otcn6S+9ZQFFG+BFL8/w8YWfm
         69O/mF7mtUUO6l5QJp2rReVocFKzvhY8bMCTauJoZ5pSsfH95O1pbuIsqe5nr5OhIOfE
         smD5RkE3FxbHNHVSY1p7vzDmPmub/NvokK9ML16mnoehZwsdZdBa3wfjlUeU1iwatgVL
         uKMKEfOlzqAo5uAVVq1vicTI9zbTBWY+xYWVBP2/VOv5zjh3YIhxQK0kanEgXnDWPPuM
         +6nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s0gCUwJEUxpdaZHCvvLKXwd/easrsvYbjTgjrxKfnjE=;
        b=GebEgBPRms9TY5/r1dbm07PlDKEZVML1HJOyrMjh88yBrfbmloelmUp9EYCIfUlFVq
         V8sWtYOjROu/P31ITJ3rPxbcB3kHOJZyOWu0EyJhEC9gzPRty3PS16Ts4Q1Xoh1i9bIU
         fcepewj2XKk9Wly+Q7yThCKaMdHJkXDk9FcD4IE+iOBZ1xWV3RyY1aFzeMbWCcDR1e/x
         jE1LLfGYjZR1FxcIl0rshQBSZBfoKpkjvIGMKym4XfVkb+W0KAacBb0GXGD5P1iSwIbn
         Vmm4iMlQ+qaFYgaDEaCDzO93QxUTkciK7iDezAshdw0YBQclsa6/Fl61HqPk4Y1fkbhp
         MR9g==
X-Gm-Message-State: APjAAAX/t4eRypm7fBi7TE2KcSrda9lTtpscG55cZiljrdN2FzM4oe1W
        IdA1e2xx8lKwC/8KKtCChMHOyW1aYH7zGQ3EIKvGNHAM
X-Google-Smtp-Source: APXvYqy3ZzZxvdhH7ymnf+cT60JeAoZogjcc0Tn6iPoTTfRvGT2fG4KSqWGDlURTbU6MMWWn84/3hiX/T3c7HJ+5xCE=
X-Received: by 2002:ac8:140c:: with SMTP id k12mr22355714qtj.117.1580714951571;
 Sun, 02 Feb 2020 23:29:11 -0800 (PST)
MIME-Version: 1.0
References: <20190820114706.18546-1-toke@redhat.com> <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
 <87blwiqlc8.fsf@toke.dk> <CAEf4BzYMKPbfOu4a4UDEfJVcNW1-KvRwJ7PVo+Mf_1YUJgE4Qw@mail.gmail.com>
 <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net> <CAEf4Bzab_w0AXy5P9mG14mcyJVgUCzuuNda5FpU5wSEwUciGfg@mail.gmail.com>
 <87tva8m85t.fsf@toke.dk> <CAEf4BzbzQwLn87G046ZbkLtTbY6WF6o8JkygcPLPGUSezgs9Tw@mail.gmail.com>
In-Reply-To: <CAEf4BzbzQwLn87G046ZbkLtTbY6WF6o8JkygcPLPGUSezgs9Tw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 2 Feb 2020 23:29:00 -0800
Message-ID: <CAEf4BzZOAukJZzo4J5q3F2v4MswQ6nJh6G1_c0H0fOJCdc7t0A@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 1:40 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Aug 23, 2019 at 4:29 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > [ ... snip ...]
> >
> > > E.g., today's API is essentially three steps:
> > >
> > > 1. open and parse ELF: collect relos, programs, map definitions
> > > 2. load: create maps from collected defs, do program/global data/CO-R=
E
> > > relocs, load and verify BPF programs
> > > 3. attach programs one by one.
> > >
> > > Between step 1 and 2 user has flexibility to create more maps, set up
> > > map-in-map, etc. Between 2 and 3 you can fill in global data, fill in
> > > tail call maps, etc. That's already pretty flexible. But we can tune
> > > and break apart those steps even further, if necessary.
> >
> > Today, steps 1 and 2 can be collapsed into a single call to
> > bpf_prog_load_xattr(). As Jesper's mail explains, for XDP we don't
> > generally want to do all the fancy rewriting stuff, we just want a
> > simple way to load a program and get reusable pinning of maps.
>
> I agree. See my response to Jesper's message. Note also my view of
> bpf_prog_load_xattr() existence.
>
> > Preferably in a way that is compatible with the iproute2 loader.
> >

Hi Toke,

I was wondering what's the state of converting iproute2 to use libbpf?
Is this still something you (or someone else) interested to do?

Briefly re-reading the thread, I think libbpf already has almost
everything to be used by iproute2. You've added map pinning, so with
bpf_map__set_pin_path() iproute2 should be able to specify pinning
path, according to its own logic. The only thing missing that I can
see is ability to specify numa_node, which we should add both to
BTF-defined map definitions (trivial change), as well as probably
expose a method like bpf_map__set_numa_node(struct bpf_map *map, int
numa_node) for non-declarative and non-BTF legacy cases.

There was concern about supporting "extended" bpf_map_def format of
iproute2 (bpf_elf_map, actually) with extra fields. I think it's
actually easy to handle as is without any extra new APIs.
bpf_object__open() w/ .relaxed_maps =3D true option will process
compatible 5 fields of bpf_map_def (type, key/value sizes,
max_entries, and map_flags) and will set up corresponding struct
bpf_map entries (but won't create BPF maps in kernel yet). Then
iproute2 can iterate over "maps" ELF section on its own, and see which
maps need to get some more adjustments before load phase: map-in-map
set up, numa node, pinning, etc. All those adjustments can be done
(except for numa yet) through existing libbpf APIs, as far as I can
tell. Once that is taken care of, proceed to bpf_object__load() and
other standard steps. No callbacks, no extra cruft.

Is there anything else that can block iproute2 conversion to libbpf?

BTW, I have a draft patches for declarative (BTF-based) map-in-map set
up and initialization the way I described it at Plumbers last year. So
while I'm finalizing that, thought I'll resurrect iproute2 thread and
see if we can get iproute2 migration to libbpf started.
