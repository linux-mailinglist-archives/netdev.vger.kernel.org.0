Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF4198C9A
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 09:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbfHVHtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 03:49:25 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42661 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbfHVHtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 03:49:25 -0400
Received: by mail-qt1-f196.google.com with SMTP id t12so6511020qtp.9;
        Thu, 22 Aug 2019 00:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XEYb4gQ2sesd2E9ru9HUrR2gaowtmInxlS2I12otpDA=;
        b=NI1sxOlnetlbLsbY58l/L1RhrUgcXGvOSqB8uNH0xNLeJK13t/pHZzYIYcOyrMwDjT
         MwHXVT/GJjWgpLfZyAml4qIdtqsBfEF/NxJCOugq3OTd6CYpnOZpUt2QKzhgld3cibC2
         /QqRIv1dObYilASbsGOm1sat0BN7pilmhE6C5q/phGEMD0B6oXmXwbo98HhFc79rDpsq
         Z6dPot8jyR5obWxPkQ5GfIzBp25bB9LwKkITW69D4BQtg/NJd+J65RkKobubjFpRwcbP
         2cDLrz3mzpMctYbGzCOjK9i7ESr1cjpHXrKK+Zsg/+vvPatd/qnN2Dws5cxjTxqHWdl2
         bydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XEYb4gQ2sesd2E9ru9HUrR2gaowtmInxlS2I12otpDA=;
        b=VoFmRhg3KkJqFyeuN0GfgpsL7/PfKcWJ7DaL2V4t/MIwC/evJYblUUY/uHGOsQaEPz
         bH5uctBSOrNrbNrLGUISn/7PF7QXB6Mfo9UIMVJ6eTC8nop3RjcdSWeobUlHEvQPUvrC
         lHQ4Hes6N4VCuy8LSPaGRg6wsfPBhGwwJXqkrKcd/TNEkkaf93vjWFGRAJ7BuND9PXYd
         fPS5WIXapZjJLyiuw8Qj+AyppShEmHX8zxkaugCf8WrZA2FW0/vtWfQNRUnoE6cWi1oN
         BiDZLo771leVTLGNxE6DsQDdlvKOe1OQvfQvWW3zinnj3mmXR89y/ZyQNxPmQWMqrMAx
         ZM4Q==
X-Gm-Message-State: APjAAAUoa8zbmVhRf2Iq0VHcw6BjYsRmwemLlLCYfZCqR/wN2Ri9IOIo
        3tAIDgcKclOr9+g+LSqZK2UNJUrBQcBC43TQjCo=
X-Google-Smtp-Source: APXvYqyZvEhu9KmTu982XXqSPOWfCWgxIKik+8WxnJYLEJfGVdRafiUSSrPJ2JhhgOOh7tLvAb2nlv6GNpgtOq5bUqU=
X-Received: by 2002:aed:26c2:: with SMTP id q60mr34274927qtd.59.1566460164130;
 Thu, 22 Aug 2019 00:49:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190820114706.18546-1-toke@redhat.com> <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
 <87blwiqlc8.fsf@toke.dk>
In-Reply-To: <87blwiqlc8.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Aug 2019 00:49:12 -0700
Message-ID: <CAEf4BzYMKPbfOu4a4UDEfJVcNW1-KvRwJ7PVo+Mf_1YUJgE4Qw@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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

On Wed, Aug 21, 2019 at 2:07 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Tue, Aug 20, 2019 at 4:47 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> iproute2 uses its own bpf loader to load eBPF programs, which has
> >> evolved separately from libbpf. Since we are now standardising on
> >> libbpf, this becomes a problem as iproute2 is slowly accumulating
> >> feature incompatibilities with libbpf-based loaders. In particular,
> >> iproute2 has its own (expanded) version of the map definition struct,
> >> which makes it difficult to write programs that can be loaded with bot=
h
> >> custom loaders and iproute2.
> >>
> >> This series seeks to address this by converting iproute2 to using libb=
pf
> >> for all its bpf needs. This version is an early proof-of-concept RFC, =
to
> >> get some feedback on whether people think this is the right direction.
> >>
> >> What this series does is the following:
> >>
> >> - Updates the libbpf map definition struct to match that of iproute2
> >>   (patch 1).
> >
> >
> > Hi Toke,
> >
> > Thanks for taking a stab at unifying libbpf and iproute2 loaders. I'm
> > totally in support of making iproute2 use libbpf to load/initialize
> > BPF programs. But I'm against adding iproute2-specific fields to
> > libbpf's bpf_map_def definitions to support this.
> >
> > I've proposed the plan of extending libbpf's supported features so
> > that it can be used to load iproute2-style BPF programs earlier,
> > please see discussions in [0] and [1].
>
> Yeah, I've seen that discussion, and agree that longer term this is
> probably a better way to do map-in-map definitions.
>
> However, I view your proposal as complementary to this series: we'll
> probably also want the BTF-based definition to work with iproute2, and
> that means iproute2 needs to be ported to libbpf. But iproute2 needs to
> be backwards compatible with the format it supports now, and, well, this
> series is the simplest way to achieve that IMO :)

Ok, I understand that. But I'd still want to avoid adding extra cruft
to libbpf just for backwards-compatibility with *exact* iproute2
format. Libbpf as a whole is trying to move away from relying on
binary bpf_map_def and into using BTF-defined map definitions, and
this patch series is a step backwards in that regard, that adds,
essentially, already outdated stuff that we'll need to support forever
(I mean those extra fields in bpf_map_def, that will stay there
forever).

We've discussed one way to deal with it, IMO, in a cleaner way. It can
be done in few steps:

1. I originally wanted BTF-defined map definitions to ignore unknown
fields. It shouldn't be a default mode, but it should be supported
(and of course is very easy to add). So let's add that and let libbpf
ignore unknown stuff.

2. Then to let iproute2 loader deal with backwards-compatibility for
libbpf-incompatible bpf_elf_map, we need to "pass-through" all those
fields so that users of libbpf (iproute2 loader, in this case) can
make use of it. The easiest and cleanest way to do this is to expose
BTF ID of a type describing each map entry and let iproute2 process
that in whichever way it sees fit.

Luckily, bpf_elf_map is compatible in `type` field, which will let
libbpf recognize bpf_elf_map as map definition. All the rest setup
will be done by iproute2, by processing BTF of bpf_elf_map, which will
let it set up map sizes, flags and do all of its map-in-map magic.

The only additions to libbpf in this case would be a new `__u32
bpf_map__btf_id(struct bpf_map* map);` API.

I haven't written any code and haven't 100% checked that this will
cover everything, but I think we should try. This will allow to let
users of libbpf do custom stuff with map definitions without having to
put all this extra logic into libbpf itself, which I think is
desirable outcome.


>
> > I think instead of emulating iproute2 way of matching everything based
> > on user-specified internal IDs, which doesn't provide good user
> > experience and is quite easy to get wrong, we should support same
> > scenarios with better declarative syntax and in a less error-prone
> > way. I believe we can do that by relying on BTF more heavily (again,
> > please check some of my proposals in [0], [1], and discussion with
> > Daniel in those threads). It will feel more natural and be more
> > straightforward to follow. It would be great if you can lend a hand in
> > implementing pieces of that plan!
> >
> > I'm currently on vacation, so my availability is very sparse, but I'd
> > be happy to discuss this further, if need be.
>
> Happy to collaborate on your proposal when you're back from vacation;
> but as I said above, I believe this is a complementary longer-term
> thing...
>
> -Toke
