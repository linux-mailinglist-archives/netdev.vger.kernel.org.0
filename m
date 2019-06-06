Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1C838183
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 01:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfFFXDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 19:03:09 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38593 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbfFFXDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 19:03:09 -0400
Received: by mail-qk1-f195.google.com with SMTP id a27so151737qkk.5;
        Thu, 06 Jun 2019 16:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BDPaDoeuXxQwHmjfz8Yws2/Zn5iE00QLeSiTN6Wh4Cg=;
        b=VoxgOEBYxzzRRP5X0ZiIPoi5gdQoNCTkBpbuBYUd+Pyx1GsUfkshdiYoU6g/MxwP7i
         VV3EwAb3QQQ9A1hGcCWFlT5vMOwbmCW8u6qCt8DpLlkwWTa3ld/h3E1oUhvKRE42zfBF
         ySxrs7ebyCzwlCh635OszsNMWcn93ftZogHGDkCoc8AZ7h8KQ3KX/KW/U4vsJSKjgils
         1iygE4+0yXsr+5Muw1p066dnWA/rj+W5NXjcCQ3sQapTkENnlOhphN7o9SzWKN+4CfwL
         Zvja7D02mHroxDEyYZf5k6vGyyXMpzsyTqoXB9Urcga1z2cH11K5/24iApm3w+f5fuGl
         LRWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BDPaDoeuXxQwHmjfz8Yws2/Zn5iE00QLeSiTN6Wh4Cg=;
        b=nmiF95UDqiIaPuCenQZ+PRvSShxQhvdPvoRGUIQq9dYXpEJoXBNySjUyPmsKG6n+zp
         GMml2uMl1O65KW8kRLii3sCgbj5hL28dkiXfvf+f7ESyYNIUF+agnADqbkf0PPILqSSR
         MkxmkOOHP7ZQu1BZY8BcYql6qPM+cJKtlwodbxSBk+cZLMPWm29qA5yQdd34FO+ZTs6K
         8+kkrWuzFrgbDqWzm5BExQ6I2r9UVjDiwdHuXSbznmRjqvdhnH8+7s/nPqrlYXtCjdSy
         3D7ZCn6FhrTzlKSujvO32jRkOW4/w/wVxRdfoc4j/lLKkxsDG0cDJrRg6VC80pUfpN16
         72Xg==
X-Gm-Message-State: APjAAAXQb4vRZBplGioIOIUOrStqb4fy9iFnFt8eeviSSGHM8HlTl7uN
        Zgp3W2RfILN6rK2VJpeIGhpKbq6OblYtTQ5JTnjMLtl1ocQ=
X-Google-Smtp-Source: APXvYqxI93+DC6T6Z1t37ep/0YrXUo8vxjAvHpEQa4299HNRitIXn8cgFkDpYfqTRkmcQEbCB6CqJgVeECu6e9hKjGE=
X-Received: by 2002:ae9:de81:: with SMTP id s123mr37542177qkf.339.1559862187787;
 Thu, 06 Jun 2019 16:03:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190531202132.379386-1-andriin@fb.com> <20190531202132.379386-7-andriin@fb.com>
 <20190531212835.GA31612@mini-arch> <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
 <20190603163222.GA14556@mini-arch> <CAEf4BzbRXAZMXY3kG9HuRC93j5XhyA3EbWxkLrrZsG7K4abdBg@mail.gmail.com>
 <20190604010254.GB14556@mini-arch> <f2b5120c-fae7-bf72-238a-b76257b0c0e4@fb.com>
 <20190604042902.GA2014@mini-arch> <20190604134538.GB2014@mini-arch>
 <CAEf4BzZEqmnwL0MvEkM7iH3qKJ+TF7=yCKJRAAb34m4+B-1Zcg@mail.gmail.com> <3ff873a8-a1a6-133b-fa20-ad8bc1d347ed@iogearbox.net>
In-Reply-To: <3ff873a8-a1a6-133b-fa20-ad8bc1d347ed@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 6 Jun 2019 16:02:56 -0700
Message-ID: <CAEf4BzYr_3heu2gb8U-rmbgMPu54ojcdjMZu7M_VaqOyCNGR5g@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map definitions
 using BTF
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 6, 2019 at 2:09 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 06/04/2019 07:31 PM, Andrii Nakryiko wrote:
> > On Tue, Jun 4, 2019 at 6:45 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >> On 06/03, Stanislav Fomichev wrote:
> >>>> BTF is mandatory for _any_ new feature.
> >>> If something is easy to support without asking everyone to upgrade to
> >>> a bleeding edge llvm, why not do it?
> >>> So much for backwards compatibility and flexibility.
> >>>
> >>>> It's for introspection and debuggability in the first place.
> >>>> Good debugging is not optional.
> >>> Once llvm 8+ is everywhere, sure, but we are not there yet (I'm talking
> >>> about upstream LTS distros like ubuntu/redhat).
> >> But putting this aside, one thing that I didn't see addressed in the
> >> cover letter is: what is the main motivation for the series?
> >> Is it to support iproute2 map definitions (so cilium can switch to libbpf)?
> >
> > In general, the motivation is to arrive at a way to support
> > declaratively defining maps in such a way, that:
> > - captures type information (for debuggability/introspection) in
> > coherent and hard-to-screw-up way;
> > - allows to support missing useful features w/ good syntax (e.g.,
> > natural map-in-map case vs current completely manual non-declarative
> > way for libbpf);
> > - ultimately allow iproute2 to use libbpf as unified loader (and thus
> > the need to support its existing features, like
> > BPF_MAP_TYPE_PROG_ARRAY initialization, pinning, map-in-map);
>
> Thanks for working on this & sorry for jumping in late! Generally, I like
> the approach of using BTF to make sense out of the individual members and
> to have extensibility, so overall I think it's a step in the right direction.
> Going back to the example where others complained that the k/v NULL
> initialization feels too much magic from a C pov:
>
> struct {
>         int type;
>         int max_entries;
>         int *key;
>         struct my_value *value;
> } my_map SEC(".maps") = {
>         .type = BPF_MAP_TYPE_ARRAY,
>         .max_entries = 16,
> };
>
> Given LLVM is in charge of emitting BTF plus given gcc/clang seem /both/
> to support *target* specific attributes [0], how about something along these
> lines where the type specific info is annotated as a variable BPF target
> attribute, like:
>
> struct {
>         int type;
>         int max_entries;
> } my_map __attribute__((map(int,struct my_value))) = {
>         .type = BPF_MAP_TYPE_ARRAY,
>         .max_entries = 16,
> };
>
> Of course this would need BPF backend support, but at least that approach
> would be more C like. Thus this would define types where we can automatically

I guess it's technically possible (not a compiler guru, but I don't
see why it wouldn't be possible). But it will require at least two
things:
1. Compiler support, obviously, as you mentioned.
2. BTF specification on how to describe attributes and how to describe
what entities (variable in this case) it is attached to.

2. is not straightforward, as attributes in general is a collection of
values of vastly different types: some values could be integers, some
strings, some, like in this case, would be a reference another BTF
type. It seems like a powerful and potentially useful addition to BTF,
of course, but it's very unclear at this point what's the best way to
represent them.

I'm not relating with "non idiomatic C" motive, though, so all that
seems like unnecessarily heavy-weight way to get something that we can
get today w/o compiler support in a clean, succinct and familiar C
syntax, that to me doesn't look like magic at all.

And if anything, attribute feels just as much magic to me. But here's
very similarly looking macro-trick:

#define MAP_KEY_VALUE_META(KEY, VALUE) KEY *key; VALUE *value;

struct {
       MAP_KEY_VALUE_META(int, struct my_value)
       int type;
       int max_entries;
} my_map SEC(".maps") = {
       .type = BPF_MAP_TYPE_ARRAY,
       .max_entries = 16,
};

Or even:

#define MAP_DEF(KEY, VALUE) struct { KEY *key; VALUE *value; int type;
int max_entries; }

MAP_DEF(int, struct my_value) my_map SEC(".maps") = {
       .type = BPF_MAP_TYPE_ARRAY,
       .max_entries = 16,
};

> derive key/val sizes etc. The SEC() could be dropped as well as map attribute

I think we should at least have an ability to override ELF section
name, just in case we add support to have maps in multiple sections
(e.g., shared library with its own set of maps, or whatever).

> would imply it for LLVM to do the right thing underneath. The normal/actual members
> from the struct has a base set of well-known names that are minimally required
> but there could be custom stuff as well where libbpf would query some user
> defined callback that can handle these. Anyway, main point, what do you think

So regarding callback. I find it hard to imagine how that could be
implemented interface-wise. As each field can have very different
value (it could be another embedded custom struct, not just integer;
or it could be char array of fixed size, etc), which is determined by
BTF, I don't know how I would expose that to custom callback in C type
system.

If I absolutely had to do it, though, how about this approach. We
either add BTF type id of a defining struct to bpf_map_def or add
bpf_map__btf_def() API, which returns it, so:

struct bpf_map *map = bpf_object__find_map_by_name(obj, "my_fancy_map");
struct btf *btf = bpf_object__btf(obj);
__u32 def_id = bpf_map__btf_map_def_type_id(map);
const void *def_data = bpf_map__btf_map_def_data(map);
struct btf_type *t = btf__type_by_id(btf, def_id);

Then application can do whatever parsing it wants on BTF map
definition and extract values in whatever manner suits it. This way
it's just a bunch of very straightforward APIs, instead of callbacks
w/ unclear interface (i.e., you'd still need to expose field_name,
field's type_id, raw pointer to data).

Does this make sense?

But having said that, what are the use cases you have in mind that
require application to put custom stuff into a standardized map
definition?

> about the __attribute__ approach instead? I think this feels cleaner to me at
> least iff feasible.
>
> Thanks,
> Daniel
>
>   [0] https://clang.llvm.org/docs/AttributeReference.html
>       https://gcc.gnu.org/onlinedocs/gcc/Variable-Attributes.html
>
> > The only missing feature that can be supported reasonably with
> > bpf_map_def is pinning (as it's just another int field), but all the
> > other use cases requires awkward approach of matching arbitrary IDs,
> > which feels like a bad way forward.
> >
> >> If that's the case, maybe explicitly focus on that? Once we have
> >> proof-of-concept working for iproute2 mode, we can extend it to everything.
>
