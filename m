Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38049491D6
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 23:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfFQVAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 17:00:04 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39238 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfFQVAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 17:00:04 -0400
Received: by mail-qt1-f196.google.com with SMTP id i34so7299289qta.6;
        Mon, 17 Jun 2019 14:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kWcGslTYruZ42RS+RD5fIevVpWPrNaNC/VLMsHNMyk4=;
        b=rKms9+ONyjQEgOOXwmXeWLMjANMcUmqILIixwvSVnzXbLKzq4LNlEzLAK7Wm5y9egm
         NARjvhygI9eSM/EAdtYnTFIE+tMjTkar18A8crhHRbIH12cHcvCQpKd5RAZNOdqj4SZw
         Fzx3FvOdE5LZ8Xa3vxocRDEYjQ474GA/rvFTLl7iKmdwseQJqLLZWKC4JeiSmFFh/gp1
         BPRVkSaLvwJNSj71WLrMiau6C/rGkjITJ35hcQTRSgF5CtaM3jbyV06DL8xKXwshUQUg
         IOEZfft5jhNgs6ACxC4tnAy+Wu18W+Ar5VuMVkYRa5xlUzUrcuiYUBaQ9dKcVdgyNXfd
         ZjkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kWcGslTYruZ42RS+RD5fIevVpWPrNaNC/VLMsHNMyk4=;
        b=eft8kvrOy/Djgs7WqwGycfPNv6LB6ntzFdYKzMK/RRRIRPRUKoj+j1livcmY/uWqiQ
         RlyJlRKjDJ6YGCZvywdqN9aSu/Vm7Zfq6ATIcJz/et7crw4YpT8B4WgK0Ig5bGiEHkqj
         rT/eMeuIaMLMf8RXAylS9VaexTc19Ug0sFTBOXNROxTnIC81rCwM1nczpExpTFRl6tT3
         vyfoIWtbi5Q3s4uZzNmkx6FifI7qi+30OZQxkVRf+W2MZwbxz30czxSqrRnciTB+vk2+
         zAZhjk+hvwzLdwwYW7ByIWp6ovyCg3+MzHSjLDb0tpildJZdcbAFibDmNm+sdFNFjIlp
         vPrg==
X-Gm-Message-State: APjAAAUIIqJtHTOOOxzW7xlLNdj3REXJuXEqHo0f+afwhEJE1+2+REAA
        4CMpBBFcfQ15ojjc53peSda0yuRio/p5e/DbBPo=
X-Google-Smtp-Source: APXvYqxL3qntRlo4/xOWYgbIufKdr8TTBYLl0NtyyexpHlTPFilF9Sx7lXoFNuLYCxpYjGdbitM5USRYT1S611OoL/c=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr7648393qty.141.1560805203067;
 Mon, 17 Jun 2019 14:00:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190531202132.379386-1-andriin@fb.com> <20190531202132.379386-7-andriin@fb.com>
 <CACAyw99wD+7mXXeger6WoBTTu3aYHDW8EJV9_tP7MfXOnT0ODg@mail.gmail.com>
 <CAEf4BzamSjSa-7ddzyVsqygbtT6WSwsWpCFGX-4Rav4Aev8UsA@mail.gmail.com> <CACAyw9_Yr=pmvCRYsVHoQBrH7qBwmcaXZezmqafwJTxaCmDf6A@mail.gmail.com>
In-Reply-To: <CACAyw9_Yr=pmvCRYsVHoQBrH7qBwmcaXZezmqafwJTxaCmDf6A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 17 Jun 2019 13:59:51 -0700
Message-ID: <CAEf4Bzbpm0pSvXU8gfSTL2xECTDb+Z9HKKO2Y-Ap=L6VTWL9MQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map definitions
 using BTF
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 2:07 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Thu, 6 Jun 2019 at 23:35, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Jun 6, 2019 at 9:43 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > >
> > > Thanks for sending this RFC! For me, the biggest draw is that map-in-map
> > > would be so much nicer to use, plus automatic dumping of map values.
> > >
> > > Others on the thread have raised this point already: not everybody lives
> > > on the bleeding edge or can control all of their dependencies. To me this means
> > > that having a good compatibility story is paramount. I'd like to have very clear
> > > rules how the presence / absence of fields is handled.
> >
> > I think that discussion was more about selftests being switched to
> > BTF-defined maps rather than BPF users having to switch to latest
> > compiler. struct bpf_map_def is still supported for those who can't
> > use clang that supports BTF_KIND_VAR/BTF_KIND_DATASEC.
> > So I don't think this enforces anyone to switch compiler, but
> > certainly incentivizes them :)
> >
> > >
> > > For example:
> > > - Fields that are present but not understood are an error. This makes
> > > sense because
> > >   the user can simply omit the field in their definition if they do
> > > not use it. It's also necessary
> > >   to preserve the freedom to add new fields in the future without
> > > risking user breakage.
> >
> > So you are arguing for strict-by-default behavior. It's fine by me,
> > but exactly that strict-by-default behavior is the problem with BTF
> > extensivility, that you care a lot about. You are advocating for
> > skipping unknown BTF types (if it was possible), which is directly
> > opposite to strict-by-default behavior. I have no strong preference
> > here, but given amount of problem (and how many times we missed this
> > problem in the past) w/ introducing new BTF feature and then
> > forgetting about doing something for older kernels, kind of makes me
> > lean towards skip-and-log behavior. But I'm happy to support both
> > (through flags) w/ strict by default.
>
> In my mind, BPF loaders should be able to pass through BTF to the kernel
> as a binary blob as much as possible. That's why I want the format to
> be "self describing". Compatibility then becomes a question of: what
> feature are you using on which kernel. The kernel itself can then still be
> strict-by-default or what have you.

That would work in ideal world, where kernel is updated frequently
(and BTF is self-describing, which it is not). In practice, though,
libbpf is far more up-to-date and lends its hand on "sanitizing" .BTF
from kernel-unsupported features (so far we manage to pull this off
very reasonably). If you have a good proposal how to make .BTF
self-describing, that would be great!

>
> >
> > > - If libbpf adds support for a new field, it must be optional. Seems
> > > like this is what current
> > >   map extensions already do, so maybe a no-brainer.
> >
> > Yeah, of course.
> >
> > >
> > > Somewhat related to this: I really wish that BTF was self-describing,
> > > e.g. possible
> > > to parse without understanding all types. I mentioned this in another
> > > thread of yours,
> > > but the more we add features where BTF is required the more important it becomes
> > > IMO.
> >
> > I relate, but have no new and better solution than previously
> > discussed :) We should try to add new stuff to .BTF.ext as much as
> > possible, which is self-describing.
> >
> > >
> > > Finally, some nits inline:
> > >
> > > On Fri, 31 May 2019 at 21:22, Andrii Nakryiko <andriin@fb.com> wrote:
> > > >
> > > > The outline of the new map definition (short, BTF-defined maps) is as follows:
> > > > 1. All the maps should be defined in .maps ELF section. It's possible to
> > > >    have both "legacy" map definitions in `maps` sections and BTF-defined
> > > >    maps in .maps sections. Everything will still work transparently.
> > >
> > > I'd prefer using a new map section "btf_maps" or whatever. No need to
> > > worry about code that deals with either type.
> >
> > We do use new map section. Its ".maps" vs "maps". Difference is
> > subtle, but ".maps" looks a bit more "standardized" than "btf_maps" to
> > me (and hopefully, eventually no one will use "maps" anymore :) ).
>
> Phew, spotting that difference is night impossible IMO.

Eventually "maps" should die off, as people switch from bpf_map_def to
to BTF-defined maps in .maps. Libbpf itself can just provide a macro
hiding all that, something like:

#define BPF_MAP __attribute__((section(".maps"), used))

>
> >
> > >
> > > > 3. Key/value fields should be **a pointer** to a type describing
> > > >    key/value. The pointee type is assumed (and will be recorded as such
> > > >    and used for size determination) to be a type describing key/value of
> > > >    the map. This is done to save excessive amounts of space allocated in
> > > >    corresponding ELF sections for key/value of big size.
> > >
> > > My biggest concern with the pointer is that there are cases when we want
> > > to _not_ use a pointer, e.g. your proposal for map in map and tail calling.
> > > There we need value to be a struct, an array, etc. The burden on the user
> > > for this is very high.
> >
> > Well, map-in-map is still a special case and whichever syntax we go
> > with, it will need to be of slightly different syntax to distinguish
> > between those cases. Initialized maps fall into similar category,
> > IMHO.
>
> I agree with you, the syntax probably has to be different. I'd just like it to
> differ by more than a "*" in the struct definition, because that is too small
> to notice.

So let's lay out how it will be done in practice:

1. Simple map w/ custom key/value

struct my_key { ... };
struct my_value { ... };

struct {
    __u32 type;
    __u32 max_entries;
    struct my_key *key;
    struct my_value *value;
} my_simple_map BPF_MAP = {
    .type = BPF_MAP_TYPE_ARRAY,
    .max_entries = 16,
};

2. Now map-in-map:

struct {
    __u32 type;
    __u32 max_entries;
    struct my_key *key;
    struct {
        __u32 type;
        __u32 max_entries;
        __u64 *key;
        struct my_value *value;
    } value;
} my_map_in_map BPF_MAP = {
    .type = BPF_MAP_TYPE_HASH_OF_MAPS,
    .max_entries = 16,
    .value = {
        .type = BPF_MAP_TYPE_ARRAY,
        .max_entries = 100,
    },
};

It's clearly hard to misinterpret inner map definition for a custom
anonymous struct type, right?


>
> >
> > Embedding full value just to capture type info/size is unacceptable,
> > as we have use cases that cause too big ELF size increase, which will
> > prevent users from switching to this.
> >
> > >
> > > > 4. As some maps disallow having BTF type ID associated with key/value,
> > > >    it's possible to specify key/value size explicitly without
> > > >    associating BTF type ID with it. Use key_size and value_size fields
> > > >    to do that (see example below).
> > >
> > > Why not just make them use the legacy map?
> >
> > For completeness' sake at the least. E.g., what if you want to use
> > map-in-map, where inner map is stackmap or something like that, which
> > requires key_size/value_size? I think we all agree that it's better if
> > application uses just one style, instead of a mix of both, right?
>
> I kind of assumed that BTF support for those maps would at some point
> appear, maybe I should have checked that.

It will. Current situation with maps not supporting specifying BTF for
key and/or value looks more like a bug, than feature and we should fix
that. But even if we fix it today, kernels are updated much slower
than libbpf, so by not supporting key_size/value_size, we force people
to get stuck with legacy bpf_map_def for a really long time.

>
> > Btw, for map cases where map key can be arbitrary, but value is FD or
> > some other opaque value, libbpf can automatically "derive" value size
> > and still capture key type. I haven't done that, but it's very easy to
> > do (and also we can keep adding per-map-type checks/niceties, to help
> > users understand what's wrong with their map definition, instead of
> > getting EINVAL from kernel on map creation).
> >
> > >
> > > --
> > > Lorenz Bauer  |  Systems Engineer
> > > 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
> > >
> > > www.cloudflare.com
>
>
>
> --
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
>
> www.cloudflare.com
