Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4DC33CAB
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 03:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfFDBC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 21:02:57 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:38820 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfFDBC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 21:02:57 -0400
Received: by mail-pl1-f180.google.com with SMTP id f97so7647084plb.5
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 18:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qjiPMBMaV6gsGEGQ3KOsAYxYe2habtJfoeYXTpneiUA=;
        b=Tu8AHEGjCR2N74fWCRI141Znp/84owPCR8YXB/y0ckMliasGXFS+Sr6TmTeCwceUgd
         X49W9ys8V5Enp7iLnFH71dmehtiHVnih3Y7bVEXpSwFO0J+zOEH47z1gCOfeNFSJvNnT
         458zzvf4bnALVfj2y0BdV+S/S8PxHQ4oJtUyWZ/kXoaCj0/Y12dFK2iZJJHa7gZcEgvR
         fPduFuhVcuHs/fnK1YSTX4+IP4v9k60FlTEel2EUtekTQVpQ9/ltMNqvppgt/h+lVWFC
         qRpyBpifZYYCobRRSUemMavgHj9k5VdPwvQB3udNy0D/pFCJfMKwg0ZswbzJc57uEhjL
         NdYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qjiPMBMaV6gsGEGQ3KOsAYxYe2habtJfoeYXTpneiUA=;
        b=Ks4zrwoeIRQ8w8KBlCF088Sm+D1tzWfPmYxyFyTvnsMYLw9JULCdVIACpz8tKCAK7m
         9L1qKi5eEaL4NdfhYzJ2cdR9ER3JrzjPxDeCYdast/T67CDwR1ByaRTOEERPm2Hew4hD
         j7KOxqbQ6x+3n/E8RShFj0ccm579uZgK6h1bOV8HpH3R4yKJxVgWMthFH/WFgrRxjSoe
         +eoq0vRzBfyak2OLyP9+86kF0LgdFfwpCBk9txMrMAb/iRkH6JRng0Rtj71QrC3+QiKR
         jfni71DlW01wYGI0+PbA2oZ1NHrzLJ3NIIIqaB4L3hxdCZkLKNVjQ5vv9gOJnmqSvtM5
         Xpwg==
X-Gm-Message-State: APjAAAWp3loDzTV4VLnYN1lj0o/mXHHB7mVlzduYOPM8ETpx39pIVvn+
        Dg//ERSdU7EExYNBCdK6qGd4TA==
X-Google-Smtp-Source: APXvYqw7UTvDhKkEX9XsZ46m0NloZ92uzJFWUn2tf4y9vcUw7IWNBbPPr3u5AstZctXT6ibYFe3AMw==
X-Received: by 2002:a17:902:24c:: with SMTP id 70mr33402657plc.2.1559610175905;
        Mon, 03 Jun 2019 18:02:55 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id f16sm16559749pja.18.2019.06.03.18.02.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 18:02:55 -0700 (PDT)
Date:   Mon, 3 Jun 2019 18:02:54 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map
 definitions using BTF
Message-ID: <20190604010254.GB14556@mini-arch>
References: <20190531202132.379386-1-andriin@fb.com>
 <20190531202132.379386-7-andriin@fb.com>
 <20190531212835.GA31612@mini-arch>
 <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
 <20190603163222.GA14556@mini-arch>
 <CAEf4BzbRXAZMXY3kG9HuRC93j5XhyA3EbWxkLrrZsG7K4abdBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbRXAZMXY3kG9HuRC93j5XhyA3EbWxkLrrZsG7K4abdBg@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/03, Andrii Nakryiko wrote:
> On Mon, Jun 3, 2019 at 9:32 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 05/31, Andrii Nakryiko wrote:
> > > On Fri, May 31, 2019 at 2:28 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > > >
> > > > On 05/31, Andrii Nakryiko wrote:
> > > > > This patch adds support for a new way to define BPF maps. It relies on
> > > > > BTF to describe mandatory and optional attributes of a map, as well as
> > > > > captures type information of key and value naturally. This eliminates
> > > > > the need for BPF_ANNOTATE_KV_PAIR hack and ensures key/value sizes are
> > > > > always in sync with the key/value type.
> > > > My 2c: this is too magical and relies on me knowing the expected fields.
> > > > (also, the compiler won't be able to help with the misspellings).
> > >
> > > I don't think it's really worse than current bpf_map_def approach. In
> > > typical scenario, there are only two fields you need to remember: type
> > > and max_entries (notice, they are called exactly the same as in
> > > bpf_map_def, so this knowledge is transferrable). Then you'll have
> > > key/value, using which you are describing both type (using field's
> > > type) and size (calculated from the type).
> > >
> > > I can relate a bit to that with bpf_map_def you can find definition
> > > and see all possible fields, but one can also find a lot of examples
> > > for new map definitions as well.
> > >
> > > One big advantage of this scheme, though, is that you get that type
> > > association automagically without using BPF_ANNOTATE_KV_PAIR hack,
> > > with no chance of having a mismatch, etc. This is less duplication (no
> > > need to do sizeof(struct my_struct) and struct my_struct as an arg to
> > > that macro) and there is no need to go and ping people to add those
> > > annotations to improve introspection of BPF maps.
> > Don't get me wrong, it looks good and there are advantages compared to
> > the existing way. But, again, feels to me a bit too magic. We should somehow
> > make it less magic (see below).
> >
> > > > I don't know how others feel about it, but I'd be much more comfortable
> > > > with a simpler TLV-like approach. Have a new section where the format
> > > > is |4-byte size|struct bpf_map_def_extendable|. That would essentially
> > > > allow us to extend it the way we do with a syscall args.
> > >
> > > It would help with extensibility, sure, though even current
> > > bpf_map_def approach sort of can be extended already. But it won't
> > > solve the problem of having BTF types captured for key/value (see
> > > above). Also, you'd need another macro to lay everything out properly.
> > I didn't know that we look into the list of exported symbols to estimate
> > the number of maps and then use it to derive struct bpf_map_def size.
> >
> > In that case, maybe we can keep extending struct bpf_map_def
> > and support BTF mode as a better alternative? bpf_map_def could be
> > used as a reference for which fields there are, people can still use it
> > (with BPF_ANNOTATE_KV_PAIR if needed), but they can also use
> > new BTF mode if they find that works better for them?
> >
> > Because the biggest issue for me with the BTF mode is the question
> > of where to look for the supported fields (and misspellings). People
> > on this mailing list can probably figure it out, but people who don't
> > work full time on bpf might find it hard. Having 'struct bpf_map_def'
> > as a reference (or a good supported piece of documentation) might help
> 
> So yeah, it's more about documentation and examples, it seems, rather
> than having a C struct in code, right? Today, if I need to add new
> map, I copy/paste either from example, existing code or look up
Well, you know where to copy paste from ;-)

> documentation. You'll be able to do the same with new way (just grep
> for \.maps).
Yes, it's mostly about discoverability. Either documentation or
the real underlaying structure could help with that.

> > with that.
> >
> > What do you think? The only issue is that we now have two formats
> > to support :-/
> 
> We'll have to support existing bpf_map_def for backwards compatibility
> (and see my reply to Jakub, you can just plain re-use struct
> bpf_map_def today with BTF approach, just put it into .maps section),
> but I'd love to avoid having to support new features using two
> different way, so if we go with BTF, I'd restrict new features to BTF
> only, moving forward.
But what's wrong with trying to extend bpf_map_def for a while? It looks like
we have everything in place to do that. I understand your desire
to deprecate everything and move on, but when was BTF support added to
LLVM? 8.0.0? 8.0.1? Six months ago? Is there a major distro with the
latest llvm+btf? Do we want to lock everyone out of new libbpf features?
(Consider that a lot of people run on the LTS kernels).

What's wrong with having BTF be just a syntactic sugar on top of
bpf_map_def? One major use-case is supporting iproute2 features,
but some of those features can go into bpf_map_def as well and
be used by non-BTF enabled users.

One other point to consider here might be pure Go libbpf that Lorenz is
maintaining. Having simple underlying bpf_map_def which we can agree
on might be beneficial.

> > > > Also, (un)related: we don't currently use BTF internally, so if
> > > > you convert all tests, we'd be unable to run them :-(
> > >
> > > Not exactly sure what you mean "you'd be unable to run them". Do you
> > > mean that you use old Clang that doesn't emit BTF? If that's what you
> > > are saying, a lot of tests already rely on latest Clang, so those
> > > tests already don't work for you, probably. I'll leave it up to Daniel
> > > and Alexei to decide if we want to convert selftests right now or not.
> > > I did it mostly to prove that we can handle all existing cases (and
> > > found few gotchas and bugs along the way, both in my implementation
> > > and in kernel - fixes coming soon).
> > Yes, I mean that we don't always use the latest features of clang,
> > so having the existing tests in the old form (at least for a while)
> > would be appreciated. Good candidates to showcase new format can
> > be features that explicitly require BTF, stuff like spinlocks.
> 
> I totally understand a concern, but I'll still defer to maintainers to
> make a call as to when to do conversion.
Sure, totally up to you and the maintainers. Just raising my voice,
so you'd at least consider not converting everything.

> > > > > Relying on BTF, this approach allows for both forward and backward
> > > > > compatibility w.r.t. extending supported map definition features. Old
> > > > > libbpf implementation will ignore fields it doesn't recognize, while new
> > > > > implementations will parse and recognize new optional attributes.
> > > > I also don't know how to feel about old libbpf ignoring some attributes.
> > > > In the kernel we require that the unknown fields are zeroed.
> > > > We probably need to do something like that here? What do you think
> > > > would be a good example of an optional attribute?
> > >
> > > Ignoring is required for forward-compatibility, where old libbpf will
> > > be used to load newer user BPF programs. We can decided not to do it,
> > > in that case it's just a question of erroring out on first unknown
> > > field. This RFC was posted exactly to discuss all these issues with
> > > more general community, as there is no single true way to do this.
> > >
> > > As for examples of when it can be used. It's any feature that can be
> > > considered optional or a hint, so if old libbpf doesn't do that, it's
> > > still not the end of the world (and we can live with that, or can
> > > correct using direct libbpf API calls).
> > In general, doing what we do right now with bpf_map_def (returning an error
> > for non-zero unknown options) seems like the safest option. We should
> > probably do the same with the unknown BTF fields (return an error
> > for non-zero value).
> 
> Yeah, as I replied to Jakub, libbpf already has strict/non-strict
> mode, we should probably do the same. The only potential difference is
> that there is no need to check for zeros and stuff: just don't define
> a field. And using an extra flag, we can allow more relaxed semantics
> (just debug/info/warn message on unknown fields). This is what
> __bpf_object__open_xattr does today with MAPS_RELAX_COMPAT flag.
> 
> >
> > For a general BTF case, we can have some predefined policy: if, for example,
> > the field name starts with an underscore, it's optional and doesn't require
> > non-zero check. (or the name ends with '_opt' or some other clear policy).
> >
> > > > > The outline of the new map definition (short, BTF-defined maps) is as follows:
> > > > > 1. All the maps should be defined in .maps ELF section. It's possible to
> > > > >    have both "legacy" map definitions in `maps` sections and BTF-defined
> > > > >    maps in .maps sections. Everything will still work transparently.
> > > > > 2. The map declaration and initialization is done through
> > > > >    a global/static variable of a struct type with few mandatory and
> > > > >    extra optional fields:
> > > > >    - type field is mandatory and specified type of BPF map;
> > > > >    - key/value fields are mandatory and capture key/value type/size information;
> > > > >    - max_entries attribute is optional; if max_entries is not specified or
> > > > >      initialized, it has to be provided in runtime through libbpf API
> > > > >      before loading bpf_object;
> > > > >    - map_flags is optional and if not defined, will be assumed to be 0.
> > > > > 3. Key/value fields should be **a pointer** to a type describing
> > > > >    key/value. The pointee type is assumed (and will be recorded as such
> > > > >    and used for size determination) to be a type describing key/value of
> > > > >    the map. This is done to save excessive amounts of space allocated in
> > > > >    corresponding ELF sections for key/value of big size.
> > > > > 4. As some maps disallow having BTF type ID associated with key/value,
> > > > >    it's possible to specify key/value size explicitly without
> > > > >    associating BTF type ID with it. Use key_size and value_size fields
> > > > >    to do that (see example below).
> > > > >
> > > > > Here's an example of simple ARRAY map defintion:
> > > > >
> > > > > struct my_value { int x, y, z; };
> > > > >
> > > > > struct {
> > > > >       int type;
> > > > >       int max_entries;
> > > > >       int *key;
> > > > >       struct my_value *value;
> > > > > } btf_map SEC(".maps") = {
> > > > >       .type = BPF_MAP_TYPE_ARRAY,
> > > > >       .max_entries = 16,
> > > > > };
> > > > >
> > > > > This will define BPF ARRAY map 'btf_map' with 16 elements. The key will
> > > > > be of type int and thus key size will be 4 bytes. The value is struct
> > > > > my_value of size 12 bytes. This map can be used from C code exactly the
> > > > > same as with existing maps defined through struct bpf_map_def.
> > > > >
> > > > > Here's an example of STACKMAP definition (which currently disallows BTF type
> > > > > IDs for key/value):
> > > > >
> > > > > struct {
> > > > >       __u32 type;
> > > > >       __u32 max_entries;
> > > > >       __u32 map_flags;
> > > > >       __u32 key_size;
> > > > >       __u32 value_size;
> > > > > } stackmap SEC(".maps") = {
> > > > >       .type = BPF_MAP_TYPE_STACK_TRACE,
> > > > >       .max_entries = 128,
> > > > >       .map_flags = BPF_F_STACK_BUILD_ID,
> > > > >       .key_size = sizeof(__u32),
> > > > >       .value_size = PERF_MAX_STACK_DEPTH * sizeof(struct bpf_stack_build_id),
> > > > > };
> > > > >
> > > > > This approach is naturally extended to support map-in-map, by making a value
> > > > > field to be another struct that describes inner map. This feature is not
> > > > > implemented yet. It's also possible to incrementally add features like pinning
> > > > > with full backwards and forward compatibility.
> > > > >
> > > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > > ---
> > > > >  tools/lib/bpf/btf.h    |   1 +
> > > > >  tools/lib/bpf/libbpf.c | 333 +++++++++++++++++++++++++++++++++++++++--
> > > > >  2 files changed, 325 insertions(+), 9 deletions(-)
