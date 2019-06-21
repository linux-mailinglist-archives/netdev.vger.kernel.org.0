Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F02C4EE3B
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 19:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfFUR5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 13:57:00 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36265 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfFUR5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 13:57:00 -0400
Received: by mail-qt1-f195.google.com with SMTP id p15so7818710qtl.3;
        Fri, 21 Jun 2019 10:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3d5MdwLXM5o89JJ56dlPlHSJV0lorF5vshuKc+Or0TI=;
        b=qhoqVG9xRNkfiCnhNbW+D32U3Tj3wASG3AxiFDkkB/+iGSvjEp7SiJ1ZecAIU6GgJV
         xgM0V7bk3jtRjo3eJaAYRbEsdvyQBmn7qOGgKvW1NXboM6gEq4s/UKlE4l+VQIlpKpb1
         OGjVBQPO4ZSb0+O9XVAtvQE9oWffjRK521exI0zOkDC9Z2criitCq2Cy16J6Rcmrn44j
         HDWi2kIoibmZSAvnHpsgRm/QtuKlqGgPhHo0YC2kbys+53rtkc5oUKNjHMQ6/Oe1SEVM
         wiU/hpYXdj0e5Nrj5jQFx+/MC0/pJjFBD4MyzqzStLQG8VRprMLM5BY8LjaroyuYV5Yz
         4kKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3d5MdwLXM5o89JJ56dlPlHSJV0lorF5vshuKc+Or0TI=;
        b=Ha8gnO/mMB0LijklQUaT1VatdvXgR/HmEvFaL900qG0DPFgk7VLAHVT21Cw3KgomAN
         kD8v9xQi39XtXWbK1PD4H3GbHehgHPhe5dPFUtK0V7wezT1eOz5CNnRYctH6bN0b6Lly
         ofHGdPKxTT2i1NkAbDoE3pSMaUwxzjfZjLCbm1d9Z+hmxVBFZdU9J8HEPB6EGdBoYJLo
         A0VHTRXp8a49bS3xWJaA7145lk2JrgGe3Bh+U+shun/MG+mjkyiS5L3dSYZ32i8tikd1
         pTyOe2dUO9DCIhN5NbuhONxOWLPRO387rZvxt1HCvpb8Lvl3tgOKt/zptyql1zg7r+q8
         zwyg==
X-Gm-Message-State: APjAAAUdsAGNVjNA1knKRhDrzA1BT12vgDHsjYYDfDVLB5jzpiRboq+s
        cjgdJwqT5QHPYqBbDkiRmrftihP686N8anEHH6Q=
X-Google-Smtp-Source: APXvYqxrkQimD+/xbwCKsNiJoAQ9W0UX2ij5bv6dy1nIWlNkzNf9AE3NAE2+NnbSd7snKZKya66QcoiS3WdG6yF2GKU=
X-Received: by 2002:a0c:ae50:: with SMTP id z16mr44511445qvc.60.1561139818944;
 Fri, 21 Jun 2019 10:56:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190617192700.2313445-1-andriin@fb.com> <30a2c470-5057-bd96-1889-e77fd5536960@iogearbox.net>
 <CAEf4Bzae1CPDkhPrESa2ZmiOH8Mqf0KA_4ty9z=xnYn=q7Frhw@mail.gmail.com>
 <CACAyw9-L0qx8d9O66SaYhJGjsyKo_6iozqLAQHEVa1AW-U=2Tg@mail.gmail.com>
 <CAEf4BzYaHG9Z_eFQCtwxA7t5GwQq2wr=AEeFWZpqx9vdQqKv1g@mail.gmail.com> <CACAyw98JqwZbcTdpRNcG_fT6A-ekEqn9D5Zx4myB8oiX73uZkw@mail.gmail.com>
In-Reply-To: <CACAyw98JqwZbcTdpRNcG_fT6A-ekEqn9D5Zx4myB8oiX73uZkw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Jun 2019 10:56:47 -0700
Message-ID: <CAEf4BzYtM-41Y5w0-6kWhaeQUh7it5Zd_OZBj4kvMYou3TwQ+A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/11] BTF-defined BPF map definitions
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Joe Stringer <joe@wand.net.nz>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 3:29 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Fri, 21 Jun 2019 at 05:20, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Jun 20, 2019 at 7:49 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > >
> > > On Tue, 18 Jun 2019 at 22:37, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > >
> > > > > I would just drop the object-scope pinning. We avoided using it and I'm not
> > > > > aware if anyone else make use. It also has the ugly side-effect that this
> > > > > relies on AF_ALG which e.g. on some cloud provider shipped kernels is disabled.
> > > > > The pinning attribute should be part of the standard set of map attributes for
> > > > > libbpf though as it's generally useful for networking applications.
> > > >
> > > > Sounds good. I'll do some more surveying of use cases inside FB to see
> > > > if anyone needs object-scope pinning, just to be sure we are not
> > > > short-cutting anyone.
> > >
> > > I'm also curious what the use cases for declarative pinning are. From my
> > > limited POV it doesn't seem that useful? There are a couple of factors:
> >
> > Cilium is using it pretty extensively, so there are clearly use cases.
> > The most straigtforward use case is using a map created and shared by
> > another BPF program (to communicate, read stats, what have you).
>
> I think Cilium is in the quirky position that it has a persistent daemon, but
> shells out to tc for loading programs. They are probably also the most
> advanced (open-source) users of BPF out there. If I understood their comments
> correctly they want to move to using a library for loading their ELF. At that
> point whether something is possible in a declarative way is less important,
> because you have the much more powerful APIs at your disposal.
>
> Maybe Daniel or someone else from the Cilium team can chime in here?

Yep, curious about their perspective on that.

>
> > > * Systemd mounts the default location only accessible to root, so I have to
> > >   used my own bpffs mount.
> > > * Since I don't want to hard code that, I put it in a config file.
> > > * After loading the ELF we pin maps from the daemon managing the XDP.
> >
> > So mounting root would be specified per bpf_object, before maps are
> > created, so user-land driving application will have an opportunity to
> > tune everything. Declarative is only the per-map decision of whether
> > that map should be exposed to outer world (for sharing) or not.
>
> So `tc filter add bpf obj foo.elf pin-root /gobbledygook`?

I meant something like:

bpf_object_open_attr attr;
attr.file = "path/to/my/object.o";
attr.pin_root_path = "/my/fancy/bpffs/root";
bpf_object__open_xattr(&attr);

Then tools can adopt they when necessary.

>
> > Then check tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
> > for more crazy syntax ;)
> >
> > typedef char * (* const (* const fn_ptr_arr2_t[5])())(char * (*)(int));
>
> Not on a Friday ;P
>
> > > What if this did
> > >
> > >   __type(value, struct my_value)[1000];
> > >   struct my_value __member(value)[1000]; // alternative
> > >
> > > instead, and skipped max_entries?
> >
> > I considered that, but decided for now to keep all those attributes
> > orthogonal for more flexibility and uniformity. This syntax might be
> > considered a nice "syntax sugar" and can be added in the future, if
> > necessary.
>
> Ack.
>
> > > At that point you have to understand that value is a pointer so all of
> > > our efforts
> > > are for naught. I suspect there is other weirdness like this, but I need to play
> > > with it a little bit more.
> >
> > Yes, C can let you do crazy stuff, if you wish, but I think that
> > shouldn't be a blocker for this proposal. I haven't seen any BPF
> > program doing that, usually you duplicate the type of inner value
> > inside your function anyway, so there is no point in taking
> > sizeof(map.value) from BPF program side. From outside, though, all the
> > types will make sense, as expected.
>
> Right, but in my mind that is a bit of a cop out. I like BTF map definitions,
> and I want them to be as unsurprising as possible, so that they are
> easy to use and adopt.


Right, but there are limit on what you can do with C syntax and it's
type system. Having fancy extra features like you described (e.g,
sizeof(map.value), etc) is pretty low on a priority list.

>
> If a type encodes all the information we need via the array dimension hack,
> couldn't we make the map variable itself a pointer, and drop the inner pointers?
>
> struct my_map_def {
>   int type[BPF_MAP_TYPE_HASH];
>   int value;
>   struct foo key;

This is bad because it potentially uses lots of space. If `struct foo`
is big, if max_entries is big, even for type, it's still a bunch of
extra space wasted. That's why we have pointers everywhere, as they
allow to encode everything with fixed space overhead of 8 bytes for a
pointer.


>   ...
> }
>
> struct my_map_def *my_map;
>
> --
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
>
> www.cloudflare.com
