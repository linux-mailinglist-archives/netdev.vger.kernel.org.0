Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0179A79D
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 08:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404441AbfHWGbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 02:31:32 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45203 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404394AbfHWGbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 02:31:31 -0400
Received: by mail-qt1-f193.google.com with SMTP id k13so10204542qtm.12;
        Thu, 22 Aug 2019 23:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=waVWO8oL6iFgkf0GxcJpVjndkp+T6N4Q4q65Lfz3+/s=;
        b=dBvSsdWnD+S06jgfGtqE0M+FqfvFo8MyLSsf3/Rl/OiYtsz6MtvZ/iSPvP47YXP4Gu
         9ZLIT0idfCzOZp6RFgxVXJqgsjzjw2bcqWvdgOWb3N9xxIDPWv54He3y1bnzQ6jihGxU
         Od85Z5gJSGb4uD7/Yh4E3WEWyM5BrnBP2UixPWnG+C7ora+GMUisx/kFFPt0WFS+oUbR
         sAhIm5vycfm1/fvFPgnhYJAGs8Z/zZdB29LZHIDFeG9zWLXpeUTosiK65e/1OhGaZT63
         MVN+sR0jZfPxwEiCLRrgEzzPic+F5DaZAuEQtHAJNdZbmnjLHZ/cEfLQttRQYPIwX4R9
         MlNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=waVWO8oL6iFgkf0GxcJpVjndkp+T6N4Q4q65Lfz3+/s=;
        b=uYRoyB7NOj3trawo6tfxsqsUc52zEjcgvwKqwszuHxwIebh2uLTKYmLWKuX3U7XYbb
         ehkaOEpZ2nBj31lEsYFjGqIrOZEO7hXPrrUSWjYHGl8TTtHZKD0ZEFbdFzL54McdTekP
         f7Rn7BwfOpefU8EapBq0mYZJC4o1zc29OAkMIEXuEoFwEXWV31lqUlXC45I8qvcj5jY5
         gKEw2W0VGQ3W4tY7tixYLyPomeS00E8plqtwXpNl5Z4/a7Db6dcqBHoB3rHcfspnOapG
         7L4Ix9OJeLitUeXcm9ndwLcZ4A+rfS5oCFY3es3XZxq4oGUJ45fJtQG2huhDzoSG3nSH
         4e6g==
X-Gm-Message-State: APjAAAVf/QjqV5Faxx+7m0HdNYntLod+qOs3EYWd3IT7vgL0fCObGeQT
        FRSBFTP7rOf6708B7FPI79GP8fnHkdbXScB8P6E=
X-Google-Smtp-Source: APXvYqx+StTs95m+DHgCOXoDdRGzLLhbsJY5bGGN4R9InTcu0eoJNifdJy44VlZvZdbvGiV/rqiGag1J/wlwOIwC2Zc=
X-Received: by 2002:ac8:6688:: with SMTP id d8mr3212003qtp.141.1566541890370;
 Thu, 22 Aug 2019 23:31:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190820114706.18546-1-toke@redhat.com> <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
 <87blwiqlc8.fsf@toke.dk> <CAEf4BzYMKPbfOu4a4UDEfJVcNW1-KvRwJ7PVo+Mf_1YUJgE4Qw@mail.gmail.com>
 <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net>
In-Reply-To: <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Aug 2019 23:31:17 -0700
Message-ID: <CAEf4Bzab_w0AXy5P9mG14mcyJVgUCzuuNda5FpU5wSEwUciGfg@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
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

On Thu, Aug 22, 2019 at 1:33 AM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 8/22/19 9:49 AM, Andrii Nakryiko wrote:
> > On Wed, Aug 21, 2019 at 2:07 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>> On Tue, Aug 20, 2019 at 4:47 AM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
> >>>>
> >>>> iproute2 uses its own bpf loader to load eBPF programs, which has
> >>>> evolved separately from libbpf. Since we are now standardising on
> >>>> libbpf, this becomes a problem as iproute2 is slowly accumulating
> >>>> feature incompatibilities with libbpf-based loaders. In particular,
> >>>> iproute2 has its own (expanded) version of the map definition struct=
,
> >>>> which makes it difficult to write programs that can be loaded with b=
oth
> >>>> custom loaders and iproute2.
> >>>>
> >>>> This series seeks to address this by converting iproute2 to using li=
bbpf
> >>>> for all its bpf needs. This version is an early proof-of-concept RFC=
, to
> >>>> get some feedback on whether people think this is the right directio=
n.
> >>>>
> >>>> What this series does is the following:
> >>>>
> >>>> - Updates the libbpf map definition struct to match that of iproute2
> >>>>    (patch 1).
> >>>
> >>> Thanks for taking a stab at unifying libbpf and iproute2 loaders. I'm
> >>> totally in support of making iproute2 use libbpf to load/initialize
> >>> BPF programs. But I'm against adding iproute2-specific fields to
> >>> libbpf's bpf_map_def definitions to support this.
> >>>
> >>> I've proposed the plan of extending libbpf's supported features so
> >>> that it can be used to load iproute2-style BPF programs earlier,
> >>> please see discussions in [0] and [1].
> >>
> >> Yeah, I've seen that discussion, and agree that longer term this is
> >> probably a better way to do map-in-map definitions.
> >>
> >> However, I view your proposal as complementary to this series: we'll
> >> probably also want the BTF-based definition to work with iproute2, and
> >> that means iproute2 needs to be ported to libbpf. But iproute2 needs t=
o
> >> be backwards compatible with the format it supports now, and, well, th=
is
> >> series is the simplest way to achieve that IMO :)
> >
> > Ok, I understand that. But I'd still want to avoid adding extra cruft
> > to libbpf just for backwards-compatibility with *exact* iproute2
> > format. Libbpf as a whole is trying to move away from relying on
> > binary bpf_map_def and into using BTF-defined map definitions, and
> > this patch series is a step backwards in that regard, that adds,
> > essentially, already outdated stuff that we'll need to support forever
> > (I mean those extra fields in bpf_map_def, that will stay there
> > forever).
>
> Agree, adding these extensions for libbpf would be a step backwards
> compared to using BTF defined map defs.
>
> > We've discussed one way to deal with it, IMO, in a cleaner way. It can
> > be done in few steps:
> >
> > 1. I originally wanted BTF-defined map definitions to ignore unknown
> > fields. It shouldn't be a default mode, but it should be supported
> > (and of course is very easy to add). So let's add that and let libbpf
> > ignore unknown stuff.
> >
> > 2. Then to let iproute2 loader deal with backwards-compatibility for
> > libbpf-incompatible bpf_elf_map, we need to "pass-through" all those
> > fields so that users of libbpf (iproute2 loader, in this case) can
> > make use of it. The easiest and cleanest way to do this is to expose
> > BTF ID of a type describing each map entry and let iproute2 process
> > that in whichever way it sees fit.
> >
> > Luckily, bpf_elf_map is compatible in `type` field, which will let
> > libbpf recognize bpf_elf_map as map definition. All the rest setup
> > will be done by iproute2, by processing BTF of bpf_elf_map, which will
> > let it set up map sizes, flags and do all of its map-in-map magic.
> >
> > The only additions to libbpf in this case would be a new `__u32
> > bpf_map__btf_id(struct bpf_map* map);` API.
> >
> > I haven't written any code and haven't 100% checked that this will
> > cover everything, but I think we should try. This will allow to let
> > users of libbpf do custom stuff with map definitions without having to
> > put all this extra logic into libbpf itself, which I think is
> > desirable outcome.
>
> Sounds reasonable in general, but all this still has the issue that we're
> assuming that BTF is /always/ present. Existing object files that would l=
oad
> just fine /today/ but do not have BTF attached won't be handled here. Wou=
ldn't
> it be more straight forward to allow passing callbacks to the libbpf load=
er
> such that if the map section is not found to be bpf_map_def compatible, w=
e
> rely on external user aka callback to parse the ELF section, handle any
> non-default libbpf behavior like pinning/retrieving from BPF fs, populate
> related internal libbpf map data structures and pass control back to libb=
pf

Having all those special callbacks feels a bit too narrow-focused. I
do agree that we need to provide enough flexibility to allow
non-standard BPF loaders like iproute2 to adjust and/or extend some of
BPF initialization logic, though. I'm just unsure if adding more and
more callbacks is the right approach.

Let's think slightly beyond iproute2, because iproute2 and libbpf use
the same ELF section name ("maps") for non-BTF-defined map defs, which
makes it easy to fall into the trap of designing too specific
solution. Let's take, say, BCC. BCC uses one section per each map.
And, unlike, iproute2, ELF section names don't coincide. So what if
BCC were to use libbpf as an underlying BPF loader, while preserving
its layout? This callback for "maps" section won't work at all.

BTW, I realize BCC might not be the best example here, given
on-the-fly complication nature of its programs and extensive usage of
macro, which provide quite a lot of flexibility in changing ELF
layout, if necessary, without changing user programs, but bear with
me, let's pretend we can't change some of those aspects easily. The
point I'm trying to make is that iproute2 and libbpf cases are
examples of almost compatible ELF layouts, and if we try to solve just
such case, we might end up inventing too specific solution.

What seems like a bit more flexible and generic solution is to make
libbpf API granular enough to allow users to adjust/add extra maps,
programs, relocations, whatever is necessary, before libbpf does final
loading or some other checks that would fail for normal libbpf
programs, but are ok for custom BPF programs. So instead of having
callbacks, we have API for each step, where custom loader can skip
and/or adjust behavior of each of them, while also implement their own
steps.

E.g., today's API is essentially three steps:

1. open and parse ELF: collect relos, programs, map definitions
2. load: create maps from collected defs, do program/global data/CO-RE
relocs, load and verify BPF programs
3. attach programs one by one.

Between step 1 and 2 user has flexibility to create more maps, set up
map-in-map, etc. Between 2 and 3 you can fill in global data, fill in
tail call maps, etc. That's already pretty flexible. But we can tune
and break apart those steps even further, if necessary.

E.g., for iproute2 maps, I think the biggest problem is that we can't
create a custom map dynamically, but still allow BPF instructions
relocations against that map. Plus, of course, a name clash of "maps"
ELF section with incompatible map definitions. So how about:

1. for open call, tell it to not parse "maps" section at all. We can
model that as an extra option to override map definitions ELF section
name. E.g., so that some applications can put their map defs into
"my_fancy_map_def_section" ELF section, for instance. If that section
is empty, though, libbpf will just skip step of collecting
bpf_map_defs (it can still do BTF-defined maps, btw), allowing gradual
migration.

2. provide API to add dynamically created (e.g., by iproute2 loader)
maps that are "relocatable to", before program relocations happen.
We'll need to figure out best interface here. Internally relocations
refer to maps as section index + offset and translate that to map
index. If we keep relos (internally) just as section index + offset,
it will be simple and consistent interface to add external maps that
can be relocated against, IMO. Map index is inconvenient in this case.

BTW, we'd need to answer some of those questions regardless, even for
callback-based solution. There are a bunch of details to be worked
out, of course, and I don't have exact answer to all of them right
now, but I think it's a worthwhile exercise to try to answer them and
see how API would look like.

As an aside, taking a step back and thinking about this whole API
design thing, it occurred to me that ELF is just one way to specify
programs, maps, relocations, global data, etc. But it doesn't have to
be just ELF, right? What if we have a use case where we have
"on-the-fly" creation of BPF program, with dynamically added maps,
dynamically generated BPF programs, etc. E.g., think about bpftrace
generating BPF object/program on-the-fly from their DSL language. Or
some pcap to BPF translator for firewall rules, etc, etc. It might be
inconvenient and unnecessary to generate ELF and then pass it to
libbpf to load it. Instead it could be more convenient to create an
empty bpf_object (bpf_object__new) and then use programmatic APIs to
add a bunch of maps (some sort of bpf_object__add_map) and progs
(bpf_object__add_program) with relocations against those maps, and let
libbpf do all the low-level stuff (relos, CO-RE, etc). And provide
high-level API for bpf_map, bpf_program, etc.

How API would look like to support this? Today's bpf_object__open +
bpf__object__load could be just a higher-level wrappers on top of
those APIs, constructing all the entities from standardized ELF
layout. But there still is low-level API to construct same bpf_object
construct dynamically. That seems flexible and powerful and not tied
to any particular use case, but of course requires a bit of thought
about best API.

Sorry for the wall of text :) Callback-based solutions always seem
convoluted to me, as well as hard to follow and quite often too
limited. This topic is not the easiest one to discuss over email, as
well, maybe we should chat about this while at LPC?

> loader afterwards. (Similar callback with prog section name handling for =
the
> case where tail call maps get automatically populated.)

I'm not sure I completely understand why we need this prog section
name callback. Can you elaborate what problem does it solve that can't
be solved with existing API?

>
> Thanks,
> Daniel
