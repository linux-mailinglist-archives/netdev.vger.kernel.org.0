Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4181513E1
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 01:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgBDA42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 19:56:28 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43090 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgBDA42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 19:56:28 -0500
Received: by mail-qk1-f194.google.com with SMTP id j20so16276401qka.10;
        Mon, 03 Feb 2020 16:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2ds0016LvDs7sdlA+s+cJzxooJqTsOmWccg+pkYbj3I=;
        b=pYYhxjpjclkzcSGVlZMhFDpKQyoKiikRy+L/OcRqBsJat/E8PdqLh2TTwvVIZm4xiJ
         gG5AHTeRG7amPkFzLd1fzWuonxtu6zmo7evxX9Punnf+wiEHeVDZmxzOTzi1fHyWzGjd
         SkZE4WZvwwK8AS0HlzL1hV2bmuHMCGAZiwcKeFKS/c9Dqx+P9FAlYa7NPUwIUgwHeyKB
         4J21WKhy2X5i+fqdrxEhMBuKgl8CNLpSP79j/5lwup/GsUHNoHRHTTwUMJcEADqUWCXO
         2mcR7NK41+cuKvZDnWKRa5EbjDyp8N2urXBy111shwIEV+yv+rSwkE1oYtJAWFC8PtTm
         NoNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2ds0016LvDs7sdlA+s+cJzxooJqTsOmWccg+pkYbj3I=;
        b=mHr5OvMW/cSpHtZdXsTBwAfaS6nxfB/CGQe2y/kvZOG/W9YEeONLRXLiGJMM01LlYn
         aHfVtR4oh1NS8lvNMNkhXxmorAl0OfspAQ3zalbulWIcc3pwBbmsXnHbwMbbExu4f5vL
         jvdRfX5yRLNynrte0SruTbkPooWCRmTkNfRHA8F83WZ0G2kFgWUPzpM6wLJTpSxBTbj0
         xzmSXOcf2q7DNPPRYZnYfWbF3jUJEACZsE4XU2nUSKASOXvQkRsUbroPJ/JN/NVq7coO
         keTlHBueXdZVVHaRI6Rl2rUHCAdELxO8OhHcqzDhcYS41pl+tEqGl7EN3y4QwqaZovEo
         h1wg==
X-Gm-Message-State: APjAAAXyPvbWwEgF6FXTnyr/1Kw0CI+rl0gk1IUpzKWqU9JybU/ryEF5
        1spQ/NhLEL86qM6xlxcUxJjLQdZclRbA4Jq/Oyc=
X-Google-Smtp-Source: APXvYqxZ0POwjh5uUL4ujlLSC5c1UwOAl2oNtyl6ZATOlnIenHNijrlDd00Lw3YhulLiJmeFhTMmlv+5ao2q2I5IjhA=
X-Received: by 2002:a37:a685:: with SMTP id p127mr27710225qke.449.1580777785899;
 Mon, 03 Feb 2020 16:56:25 -0800 (PST)
MIME-Version: 1.0
References: <20190820114706.18546-1-toke@redhat.com> <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
 <87blwiqlc8.fsf@toke.dk> <CAEf4BzYMKPbfOu4a4UDEfJVcNW1-KvRwJ7PVo+Mf_1YUJgE4Qw@mail.gmail.com>
 <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net> <CAEf4Bzab_w0AXy5P9mG14mcyJVgUCzuuNda5FpU5wSEwUciGfg@mail.gmail.com>
 <87tva8m85t.fsf@toke.dk> <CAEf4BzbzQwLn87G046ZbkLtTbY6WF6o8JkygcPLPGUSezgs9Tw@mail.gmail.com>
 <CAEf4BzZOAukJZzo4J5q3F2v4MswQ6nJh6G1_c0H0fOJCdc7t0A@mail.gmail.com> <87blqfcvnf.fsf@toke.dk>
In-Reply-To: <87blqfcvnf.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 3 Feb 2020 16:56:14 -0800
Message-ID: <CAEf4Bza4bSAzjFp2WDiPAM7hbKcKgAX4A8_TUN8V38gXV9GbTg@mail.gmail.com>
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

On Mon, Feb 3, 2020 at 11:34 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Wed, Aug 28, 2019 at 1:40 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> >>
> >> On Fri, Aug 23, 2019 at 4:29 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
> >> >
> >> > [ ... snip ...]
> >> >
> >> > > E.g., today's API is essentially three steps:
> >> > >
> >> > > 1. open and parse ELF: collect relos, programs, map definitions
> >> > > 2. load: create maps from collected defs, do program/global data/C=
O-RE
> >> > > relocs, load and verify BPF programs
> >> > > 3. attach programs one by one.
> >> > >
> >> > > Between step 1 and 2 user has flexibility to create more maps, set=
 up
> >> > > map-in-map, etc. Between 2 and 3 you can fill in global data, fill=
 in
> >> > > tail call maps, etc. That's already pretty flexible. But we can tu=
ne
> >> > > and break apart those steps even further, if necessary.
> >> >
> >> > Today, steps 1 and 2 can be collapsed into a single call to
> >> > bpf_prog_load_xattr(). As Jesper's mail explains, for XDP we don't
> >> > generally want to do all the fancy rewriting stuff, we just want a
> >> > simple way to load a program and get reusable pinning of maps.
> >>
> >> I agree. See my response to Jesper's message. Note also my view of
> >> bpf_prog_load_xattr() existence.
> >>
> >> > Preferably in a way that is compatible with the iproute2 loader.
> >> >
> >
> > Hi Toke,
> >
> > I was wondering what's the state of converting iproute2 to use libbpf?
> > Is this still something you (or someone else) interested to do?
>
> Yeah, it's still on my list; planning to circle back to it once I have
> finished an RFC implementation for XDP multiprog loading based on the
> new function-replacing in the kernel.
>
> (Not that this should keep anyone else from giving the conversion a go
> and beating me to it :)).
>
> > Briefly re-reading the thread, I think libbpf already has almost
> > everything to be used by iproute2. You've added map pinning, so with
> > bpf_map__set_pin_path() iproute2 should be able to specify pinning
> > path, according to its own logic. The only thing missing that I can
> > see is ability to specify numa_node, which we should add both to
> > BTF-defined map definitions (trivial change), as well as probably
> > expose a method like bpf_map__set_numa_node(struct bpf_map *map, int
> > numa_node) for non-declarative and non-BTF legacy cases.
>
> Yes, adding this to libbpf would be good.
>
> > There was concern about supporting "extended" bpf_map_def format of
> > iproute2 (bpf_elf_map, actually) with extra fields. I think it's
> > actually easy to handle as is without any extra new APIs.
> > bpf_object__open() w/ .relaxed_maps =3D true option will process
> > compatible 5 fields of bpf_map_def (type, key/value sizes,
> > max_entries, and map_flags) and will set up corresponding struct
> > bpf_map entries (but won't create BPF maps in kernel yet). Then
> > iproute2 can iterate over "maps" ELF section on its own, and see which
> > maps need to get some more adjustments before load phase: map-in-map
> > set up, numa node, pinning, etc. All those adjustments can be done
> > (except for numa yet) through existing libbpf APIs, as far as I can
> > tell. Once that is taken care of, proceed to bpf_object__load() and
> > other standard steps. No callbacks, no extra cruft.
> >
> > Is there anything else that can block iproute2 conversion to libbpf?
>
> I haven't looked into the details since my last RFC conversion series,
> but from what I recall from that, and what we've been changing in libbpf
> since, I was basically planning to do what you explained. So while there
> are some details to work out, I believe it's basically straight forward,
> and I can't think of anything that should block it.
>

Great! Just to disambiguate and make sure we are in agreement, my hope
here is that iproute2 can completely delegate to libbpf all the ELF
parsing, map creation, program loading, etc (including all the new
stuff like global variables, etc). And only for legacy maps in
SEC("maps"), it would have to parse that *single* ELF section (again,
on its own) and see if there are any extra features of struct
bpf_elf_map requested (i.e., numa, map-in-map, pinning), and if yes,
it would use programmatic libbpf APIs to set this up. It might need to
do additional BPF_PROG_ARRAY set up after BPF programs are loaded
(because iproute2 has its custom naming-based convention). But
hopefully we'll encourage people to gradually migrate to BTF-defined
maps with declarative ways of doing all that.

> > BTW, I have a draft patches for declarative (BTF-based) map-in-map set
> > up and initialization the way I described it at Plumbers last year. So
> > while I'm finalizing that, thought I'll resurrect iproute2 thread and
> > see if we can get iproute2 migration to libbpf started.
>
> Great! FWIW, as long as we have the legacy compatibility code in
> iproute2, I don't think it'll be a problem (or a blocker for the
> conversion) if BTF-defined maps can't express all the same things as the
> legacy maps. The missing bits will come automatically as libbpf is
> updated. But great to hear that you're working on this :)
>
> -Toke
>
