Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06B6F334FF
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 18:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbfFCQcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 12:32:25 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34465 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728052AbfFCQcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 12:32:25 -0400
Received: by mail-pf1-f196.google.com with SMTP id c85so2128474pfc.1
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 09:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1YuKzD8ZLw7/wNhnFqtLMxrX/fRSTnpz0OrC6aG4Bd4=;
        b=Xdf3UZdqw0j2xZzM0NnXniCalYnD0tDL+ZjkjjBVlWTJHwhdEZvmkeeMDo1hc0Er/u
         +YU10D7lorJ+6IDrdfVLn1ED0ckFutINWhdSjcGuqPSEFO15Qjesdo0VScaatGnIjvjw
         r/kLwXNEtRpWohVzA6Zsl0I9KTNlTRYwRPcImGCamfaLAdl1kNEAMVrUsiYiPyvNaVio
         Htm2nrN2Ff9nJrPrpf6QL/76qSCbXNgxL9Z3pL9GRpp4ZUzskLdz3KYX6e6a4DNiPkF9
         F7SU3GPvVuIJLW7XKb5hI5WGxcr7qvbIVojqrZxQV58H02KppStQVKrMR936nFYxTGJK
         ZcQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1YuKzD8ZLw7/wNhnFqtLMxrX/fRSTnpz0OrC6aG4Bd4=;
        b=dfmYqeLuQKvh1y5jeyRR+XaEuPoG8mEg4ePNxFzGQqtxYqPa/PEwKgqo2US+Gb3NRK
         wepIhUi8z7G7mh6G41jrH90R9YGnTlz0ccgMltgYraPTiQeUVg7ogHzpe3P7Iq7Xzlkj
         XkRPzynBkXtiko3aHuHbaRr2QMmWWjyUwy7od7kBSGptsswE0hSe6LZJ8zW09CcOWrd7
         HbP6zDbjG3XVxtEqDBKGFmkKFsxq7SbTEEcYa3dNnLmp8NzL+jDzVvq0jEM+7uEkDgW9
         MFkk0TT2xHth2T5mxQLWKYlS8W9xISskh86WK9uvoS1n0nH1FUE6qfARWwaPVfxthNxs
         uptA==
X-Gm-Message-State: APjAAAVUPLFwsUbSI/P6XRXbcjqATESjwjuRiCoCFwswSo3jMtS3Bses
        FndCFsKFWcVGGYXNbuZOvet/pA==
X-Google-Smtp-Source: APXvYqxL9UpvngNKZcJwQBrzZZvUNONAtN9MXabCdRAJ4cj1KgKybHhN6xZKsVszlI559VpHYigxhQ==
X-Received: by 2002:a62:7995:: with SMTP id u143mr32545414pfc.61.1559579544430;
        Mon, 03 Jun 2019 09:32:24 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id l21sm15129296pff.40.2019.06.03.09.32.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 09:32:23 -0700 (PDT)
Date:   Mon, 3 Jun 2019 09:32:22 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map
 definitions using BTF
Message-ID: <20190603163222.GA14556@mini-arch>
References: <20190531202132.379386-1-andriin@fb.com>
 <20190531202132.379386-7-andriin@fb.com>
 <20190531212835.GA31612@mini-arch>
 <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/31, Andrii Nakryiko wrote:
> On Fri, May 31, 2019 at 2:28 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 05/31, Andrii Nakryiko wrote:
> > > This patch adds support for a new way to define BPF maps. It relies on
> > > BTF to describe mandatory and optional attributes of a map, as well as
> > > captures type information of key and value naturally. This eliminates
> > > the need for BPF_ANNOTATE_KV_PAIR hack and ensures key/value sizes are
> > > always in sync with the key/value type.
> > My 2c: this is too magical and relies on me knowing the expected fields.
> > (also, the compiler won't be able to help with the misspellings).
> 
> I don't think it's really worse than current bpf_map_def approach. In
> typical scenario, there are only two fields you need to remember: type
> and max_entries (notice, they are called exactly the same as in
> bpf_map_def, so this knowledge is transferrable). Then you'll have
> key/value, using which you are describing both type (using field's
> type) and size (calculated from the type).
> 
> I can relate a bit to that with bpf_map_def you can find definition
> and see all possible fields, but one can also find a lot of examples
> for new map definitions as well.
> 
> One big advantage of this scheme, though, is that you get that type
> association automagically without using BPF_ANNOTATE_KV_PAIR hack,
> with no chance of having a mismatch, etc. This is less duplication (no
> need to do sizeof(struct my_struct) and struct my_struct as an arg to
> that macro) and there is no need to go and ping people to add those
> annotations to improve introspection of BPF maps.
Don't get me wrong, it looks good and there are advantages compared to
the existing way. But, again, feels to me a bit too magic. We should somehow
make it less magic (see below).

> > I don't know how others feel about it, but I'd be much more comfortable
> > with a simpler TLV-like approach. Have a new section where the format
> > is |4-byte size|struct bpf_map_def_extendable|. That would essentially
> > allow us to extend it the way we do with a syscall args.
> 
> It would help with extensibility, sure, though even current
> bpf_map_def approach sort of can be extended already. But it won't
> solve the problem of having BTF types captured for key/value (see
> above). Also, you'd need another macro to lay everything out properly.
I didn't know that we look into the list of exported symbols to estimate
the number of maps and then use it to derive struct bpf_map_def size.

In that case, maybe we can keep extending struct bpf_map_def
and support BTF mode as a better alternative? bpf_map_def could be
used as a reference for which fields there are, people can still use it
(with BPF_ANNOTATE_KV_PAIR if needed), but they can also use
new BTF mode if they find that works better for them?

Because the biggest issue for me with the BTF mode is the question
of where to look for the supported fields (and misspellings). People
on this mailing list can probably figure it out, but people who don't
work full time on bpf might find it hard. Having 'struct bpf_map_def'
as a reference (or a good supported piece of documentation) might help
with that.

What do you think? The only issue is that we now have two formats
to support :-/

> > Also, (un)related: we don't currently use BTF internally, so if
> > you convert all tests, we'd be unable to run them :-(
> 
> Not exactly sure what you mean "you'd be unable to run them". Do you
> mean that you use old Clang that doesn't emit BTF? If that's what you
> are saying, a lot of tests already rely on latest Clang, so those
> tests already don't work for you, probably. I'll leave it up to Daniel
> and Alexei to decide if we want to convert selftests right now or not.
> I did it mostly to prove that we can handle all existing cases (and
> found few gotchas and bugs along the way, both in my implementation
> and in kernel - fixes coming soon).
Yes, I mean that we don't always use the latest features of clang,
so having the existing tests in the old form (at least for a while)
would be appreciated. Good candidates to showcase new format can
be features that explicitly require BTF, stuff like spinlocks.

> > > Relying on BTF, this approach allows for both forward and backward
> > > compatibility w.r.t. extending supported map definition features. Old
> > > libbpf implementation will ignore fields it doesn't recognize, while new
> > > implementations will parse and recognize new optional attributes.
> > I also don't know how to feel about old libbpf ignoring some attributes.
> > In the kernel we require that the unknown fields are zeroed.
> > We probably need to do something like that here? What do you think
> > would be a good example of an optional attribute?
> 
> Ignoring is required for forward-compatibility, where old libbpf will
> be used to load newer user BPF programs. We can decided not to do it,
> in that case it's just a question of erroring out on first unknown
> field. This RFC was posted exactly to discuss all these issues with
> more general community, as there is no single true way to do this.
> 
> As for examples of when it can be used. It's any feature that can be
> considered optional or a hint, so if old libbpf doesn't do that, it's
> still not the end of the world (and we can live with that, or can
> correct using direct libbpf API calls).
In general, doing what we do right now with bpf_map_def (returning an error
for non-zero unknown options) seems like the safest option. We should
probably do the same with the unknown BTF fields (return an error
for non-zero value).

For a general BTF case, we can have some predefined policy: if, for example,
the field name starts with an underscore, it's optional and doesn't require
non-zero check. (or the name ends with '_opt' or some other clear policy).

> > > The outline of the new map definition (short, BTF-defined maps) is as follows:
> > > 1. All the maps should be defined in .maps ELF section. It's possible to
> > >    have both "legacy" map definitions in `maps` sections and BTF-defined
> > >    maps in .maps sections. Everything will still work transparently.
> > > 2. The map declaration and initialization is done through
> > >    a global/static variable of a struct type with few mandatory and
> > >    extra optional fields:
> > >    - type field is mandatory and specified type of BPF map;
> > >    - key/value fields are mandatory and capture key/value type/size information;
> > >    - max_entries attribute is optional; if max_entries is not specified or
> > >      initialized, it has to be provided in runtime through libbpf API
> > >      before loading bpf_object;
> > >    - map_flags is optional and if not defined, will be assumed to be 0.
> > > 3. Key/value fields should be **a pointer** to a type describing
> > >    key/value. The pointee type is assumed (and will be recorded as such
> > >    and used for size determination) to be a type describing key/value of
> > >    the map. This is done to save excessive amounts of space allocated in
> > >    corresponding ELF sections for key/value of big size.
> > > 4. As some maps disallow having BTF type ID associated with key/value,
> > >    it's possible to specify key/value size explicitly without
> > >    associating BTF type ID with it. Use key_size and value_size fields
> > >    to do that (see example below).
> > >
> > > Here's an example of simple ARRAY map defintion:
> > >
> > > struct my_value { int x, y, z; };
> > >
> > > struct {
> > >       int type;
> > >       int max_entries;
> > >       int *key;
> > >       struct my_value *value;
> > > } btf_map SEC(".maps") = {
> > >       .type = BPF_MAP_TYPE_ARRAY,
> > >       .max_entries = 16,
> > > };
> > >
> > > This will define BPF ARRAY map 'btf_map' with 16 elements. The key will
> > > be of type int and thus key size will be 4 bytes. The value is struct
> > > my_value of size 12 bytes. This map can be used from C code exactly the
> > > same as with existing maps defined through struct bpf_map_def.
> > >
> > > Here's an example of STACKMAP definition (which currently disallows BTF type
> > > IDs for key/value):
> > >
> > > struct {
> > >       __u32 type;
> > >       __u32 max_entries;
> > >       __u32 map_flags;
> > >       __u32 key_size;
> > >       __u32 value_size;
> > > } stackmap SEC(".maps") = {
> > >       .type = BPF_MAP_TYPE_STACK_TRACE,
> > >       .max_entries = 128,
> > >       .map_flags = BPF_F_STACK_BUILD_ID,
> > >       .key_size = sizeof(__u32),
> > >       .value_size = PERF_MAX_STACK_DEPTH * sizeof(struct bpf_stack_build_id),
> > > };
> > >
> > > This approach is naturally extended to support map-in-map, by making a value
> > > field to be another struct that describes inner map. This feature is not
> > > implemented yet. It's also possible to incrementally add features like pinning
> > > with full backwards and forward compatibility.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  tools/lib/bpf/btf.h    |   1 +
> > >  tools/lib/bpf/libbpf.c | 333 +++++++++++++++++++++++++++++++++++++++--
> > >  2 files changed, 325 insertions(+), 9 deletions(-)
