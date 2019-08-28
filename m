Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25E71A0BAE
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfH1Ukr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:40:47 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34766 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfH1Ukr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:40:47 -0400
Received: by mail-qt1-f196.google.com with SMTP id a13so1175368qtj.1;
        Wed, 28 Aug 2019 13:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GNi9AI4rkllVI8t+VbMPhpZAgEp8bkUSpdZ2NbwyUOI=;
        b=UCmf9cm6Nca9c9Ypx6/clrzj2/NILZp6xXUowSTAhpFJrNEF9PBbFWLPFCWK1TYMik
         pQav/HXpyo0L643sOVhTUdl/4r1D7wmV/xVLqZqp7zV4gKC6lfV1a6WILfZpOiEk7iXi
         lKcUxQCTunbJTLPHOAUFB9j+FRdw7teGPlvN4XlbQgnh+7aPfOHcDPvbmu6oaUIL+KLp
         +CX8r0C0Vpk8YV13dcuP3DA6Ze7EBm68lVokyDU887NGTUGPLa98eskpK81j/j7yeN31
         YSQ1B0eFY2HLzB2bq7+lDa8smEllPcPYXnWBu5VVfAWqZ9YF5wlcuBbO37IomGfDV/El
         J04Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GNi9AI4rkllVI8t+VbMPhpZAgEp8bkUSpdZ2NbwyUOI=;
        b=WnRJKUFtWMQvWpLEpDb2q3egkU0DX2o7rbb9HGeBFrJu8RyF18IgLTnfS2sBqvKHKI
         r8I26cXUZ3ghwEBGQntxTY2asyxTaiGp8RO464b2unvrbV4oAnc03mgbIhwcleC2CyuP
         vstSsJ3pgXw6G+oDbuj6qf0dQsWdhQ6nMiB87Ho8e3LeySs0rmWByMUVfswuY/AYwHSu
         S06RCmQbaVMfIyEPtEL2n2J2QsspqTqjaOLeL92K0jzIfNq5EidQLcAvRq+JTCPVTwKP
         U2D5zF2GAPuPhdnsvsCPM1htk0ftLf/ubjrYbCSp04oF1L5H41QoPA6nl7+eJKIR5vSY
         21GQ==
X-Gm-Message-State: APjAAAXGkTxiyaGgVijZJ1n2wa7c9x3kBjWUZqxQsgnA9uAgQyaNOTiS
        XMTQ+5399M6zi2OT57RJ49IABv4YJL0A9QUBYTk=
X-Google-Smtp-Source: APXvYqyFqxf3wKHvYomIWWojNaLz+vnkHs91+dVu+k1aJNZBvUI9+AnBydHhDJdr75UDyfDaBMmlyOq1/CA0w+Ce1fE=
X-Received: by 2002:ac8:6688:: with SMTP id d8mr6183683qtp.141.1567024845948;
 Wed, 28 Aug 2019 13:40:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190820114706.18546-1-toke@redhat.com> <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
 <87blwiqlc8.fsf@toke.dk> <CAEf4BzYMKPbfOu4a4UDEfJVcNW1-KvRwJ7PVo+Mf_1YUJgE4Qw@mail.gmail.com>
 <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net> <CAEf4Bzab_w0AXy5P9mG14mcyJVgUCzuuNda5FpU5wSEwUciGfg@mail.gmail.com>
 <87tva8m85t.fsf@toke.dk>
In-Reply-To: <87tva8m85t.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 28 Aug 2019 13:40:35 -0700
Message-ID: <CAEf4BzbzQwLn87G046ZbkLtTbY6WF6o8JkygcPLPGUSezgs9Tw@mail.gmail.com>
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

On Fri, Aug 23, 2019 at 4:29 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> [ ... snip ...]
>
> > E.g., today's API is essentially three steps:
> >
> > 1. open and parse ELF: collect relos, programs, map definitions
> > 2. load: create maps from collected defs, do program/global data/CO-RE
> > relocs, load and verify BPF programs
> > 3. attach programs one by one.
> >
> > Between step 1 and 2 user has flexibility to create more maps, set up
> > map-in-map, etc. Between 2 and 3 you can fill in global data, fill in
> > tail call maps, etc. That's already pretty flexible. But we can tune
> > and break apart those steps even further, if necessary.
>
> Today, steps 1 and 2 can be collapsed into a single call to
> bpf_prog_load_xattr(). As Jesper's mail explains, for XDP we don't
> generally want to do all the fancy rewriting stuff, we just want a
> simple way to load a program and get reusable pinning of maps.

I agree. See my response to Jesper's message. Note also my view of
bpf_prog_load_xattr() existence.

> Preferably in a way that is compatible with the iproute2 loader.
>
> So I really think we need two things:
>
> (1) a flexible API that splits up all the various steps in a way that
>     allows programs to inject their own map definitions before
>     relocations and loading
>
> (2) a simple convenience wrapper that loads an object file, does
>     something sensible with pinning and map-in-map definitions, and loads
>     everything into the kernel.

I agree. I think this wrapper is bpf_object__open + bpf_object__load
(bpf_prog_load_xattr will do as well, if you don't need to do anything
between open and load). I think pinning is simple to add in minimal
form and is pretty non-controversial (there is some ambiguity as to
how to handle merging of prog array maps, or maybe not just prog array
maps, but that can be controlled later through extra flags/attributes,
so I'd start with something sensible as a default behavior).

>
> I'd go so far as to say that (2) should even support system-wide
> configuration, similar to the /etc/iproute2/bpf_pinning file. E.g., an
> /etc/libbpf/pinning.conf file that sets the default pinning directory,
> and makes it possible to set up pin-value-to-subdir mappings like what
> iproute2 does today.

This I'm a bit hesitant about. It feels like it's not library's job to
read some system-wide configs modifying its behavior. We have all
those _xattr methods, which allow to override sensible defaults, I'd
try to go as far as possible with just that before doing
libbpf-specific /etc configs.

>
> Having (2) makes it more likely that all the different custom loaders
> will be compatible with each other, while still allowing people to do
> their own custom thing with (1). And of course, (2) could be implemented
> in terms of (1) internally in libbpf.
>
> In my ideal world, (2) would just use the definition format already in
> iproute2 (this is basically what I implemented already), but if you guys
> don't want to put this into libbpf, I can probably live with the default

I want to avoid having legacy-at-the-time-it-was-added code in libbpf
that we'd need to support for a long time, that solves only iproute2
cases, which is why I'm pushing back. With BTF we can support same
functionality in better form, which is what I want to prioritize and
which will be beneficial to the whole BPF ecosystem.

But I also want to make libbpf useful to iproute2 and other custom
loaders that have to support existing formats, and thus my proposal to
have libbpf provide granular enough APIs to augment default format in
non-intrusive way. Should this be callback-based or not is secondary,
though important to API design, concern.

> format being BTF-based instead. Which would mean that iproute2 I would
> end up with a flow like this:
>
> - When given an elf file, try to run it through the "standard loader"
>   (2). If this works, great, proceed to program attach.
>
> - If using (2) fails because it doesn't understand the map definition,
>   fall back to a compatibility loader that parses the legacy iproute2
>   map definition format and uses (1) to load that.
>
>
> Does the above make sense? :)

It does, yes. Also, with BTF enabled it should be easy to distinguish
between those two (e.g., was bpf_elf_map type used? if yes, then it's
a compatibility format) and not do extra work.

>
> -Toke
