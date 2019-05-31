Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 595593175F
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 01:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfEaW6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 18:58:54 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33766 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbfEaW6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 18:58:53 -0400
Received: by mail-qt1-f196.google.com with SMTP id 14so2957066qtf.0;
        Fri, 31 May 2019 15:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hXo/NUkkt5nfAJu1D+/vqXTpXKSSAE8fC+tUkqH9kYo=;
        b=FVOktVdwQrjLAspeRivD5vJbEC3/5NCig7VRLrMEdbP0eEhc0SNi9IywWgJfJD6awI
         o5aPDld3MVfrnO8Q5DTgXqZ1NAxa3I8PGZS+/2tIAJikjyi0nhiNxAbVWRya7gnDeyRJ
         Pn0HnbJ+DgnEeYu4ksGmWSdqWyXC0Y7WcM+1GpyTazpY46+UK9r7wN7CsWV+FuymNzPa
         2z/bEqS7oHXCMMWhhxxzBtgQRKA3c8Nd5Wj7ebryBFhrlEWlgYiZdhHwJZKcSQhYUW28
         +bEWeruO8yFWCe2jMrZXizHN8OCxTOh2AI+48eW9l2clnrqDBsWQmInPVNZHpEy7mtmY
         ILXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hXo/NUkkt5nfAJu1D+/vqXTpXKSSAE8fC+tUkqH9kYo=;
        b=T4j906gc9mgcmesRIwkH/s6By7rWHb5U70xPMzhy4RhAKrmABHJ9FEQAjHJ+t4zTHd
         olKF/MNHslPSNTs4mwcgl6kxrotq0MRz5LNE4pqcYBG7egdGnft/QA3vc//vkSFSR3xK
         kgFvY4hx9jxycYledYQJmqLCVADx6pN5XDjbOuoF0jALu4NgTO4rCJo+IzToIQFbHGM9
         uYCJYjGGTLF20u+/svjKlr9ulessaQjlrEEUc5EjqSUQe9qIKLzmAJva/2j5QMMnhNhV
         2XVEmdTir6RnDfwNSQIPqGC89U7CUG4Fj/rS9E1fctP9w06gMETQLkfQx/ztbOI+6Zio
         qj8g==
X-Gm-Message-State: APjAAAV2FlmTcKp5tAuqBI0jNyeP+m0fgdRvcZzMvLJQuobOB4o3OgnA
        V0boJ+A42brav5/WWnyoS5OuS+7yFxotsxn6xxnLZL2RGjA=
X-Google-Smtp-Source: APXvYqxzEQfR0agDFmKUELL6wC7MtrYRtgfnYkcgiVMYAIFoaKJ6WFUO2J0+j/pWb6DLBdDBqpLm3+VGKc/axEOuS7Y=
X-Received: by 2002:ac8:2a63:: with SMTP id l32mr11740650qtl.117.1559343532185;
 Fri, 31 May 2019 15:58:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190531202132.379386-1-andriin@fb.com> <20190531202132.379386-7-andriin@fb.com>
 <20190531212835.GA31612@mini-arch>
In-Reply-To: <20190531212835.GA31612@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 31 May 2019 15:58:41 -0700
Message-ID: <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map definitions
 using BTF
To:     Stanislav Fomichev <sdf@fomichev.me>
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

On Fri, May 31, 2019 at 2:28 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 05/31, Andrii Nakryiko wrote:
> > This patch adds support for a new way to define BPF maps. It relies on
> > BTF to describe mandatory and optional attributes of a map, as well as
> > captures type information of key and value naturally. This eliminates
> > the need for BPF_ANNOTATE_KV_PAIR hack and ensures key/value sizes are
> > always in sync with the key/value type.
> My 2c: this is too magical and relies on me knowing the expected fields.
> (also, the compiler won't be able to help with the misspellings).

I don't think it's really worse than current bpf_map_def approach. In
typical scenario, there are only two fields you need to remember: type
and max_entries (notice, they are called exactly the same as in
bpf_map_def, so this knowledge is transferrable). Then you'll have
key/value, using which you are describing both type (using field's
type) and size (calculated from the type).

I can relate a bit to that with bpf_map_def you can find definition
and see all possible fields, but one can also find a lot of examples
for new map definitions as well.

One big advantage of this scheme, though, is that you get that type
association automagically without using BPF_ANNOTATE_KV_PAIR hack,
with no chance of having a mismatch, etc. This is less duplication (no
need to do sizeof(struct my_struct) and struct my_struct as an arg to
that macro) and there is no need to go and ping people to add those
annotations to improve introspection of BPF maps.

>
> I don't know how others feel about it, but I'd be much more comfortable
> with a simpler TLV-like approach. Have a new section where the format
> is |4-byte size|struct bpf_map_def_extendable|. That would essentially
> allow us to extend it the way we do with a syscall args.

It would help with extensibility, sure, though even current
bpf_map_def approach sort of can be extended already. But it won't
solve the problem of having BTF types captured for key/value (see
above). Also, you'd need another macro to lay everything out properly.

>
> Also, (un)related: we don't currently use BTF internally, so if
> you convert all tests, we'd be unable to run them :-(

Not exactly sure what you mean "you'd be unable to run them". Do you
mean that you use old Clang that doesn't emit BTF? If that's what you
are saying, a lot of tests already rely on latest Clang, so those
tests already don't work for you, probably. I'll leave it up to Daniel
and Alexei to decide if we want to convert selftests right now or not.
I did it mostly to prove that we can handle all existing cases (and
found few gotchas and bugs along the way, both in my implementation
and in kernel - fixes coming soon).

>
> > Relying on BTF, this approach allows for both forward and backward
> > compatibility w.r.t. extending supported map definition features. Old
> > libbpf implementation will ignore fields it doesn't recognize, while new
> > implementations will parse and recognize new optional attributes.
> I also don't know how to feel about old libbpf ignoring some attributes.
> In the kernel we require that the unknown fields are zeroed.
> We probably need to do something like that here? What do you think
> would be a good example of an optional attribute?

Ignoring is required for forward-compatibility, where old libbpf will
be used to load newer user BPF programs. We can decided not to do it,
in that case it's just a question of erroring out on first unknown
field. This RFC was posted exactly to discuss all these issues with
more general community, as there is no single true way to do this.

As for examples of when it can be used. It's any feature that can be
considered optional or a hint, so if old libbpf doesn't do that, it's
still not the end of the world (and we can live with that, or can
correct using direct libbpf API calls).

>
> > The outline of the new map definition (short, BTF-defined maps) is as follows:
> > 1. All the maps should be defined in .maps ELF section. It's possible to
> >    have both "legacy" map definitions in `maps` sections and BTF-defined
> >    maps in .maps sections. Everything will still work transparently.
> > 2. The map declaration and initialization is done through
> >    a global/static variable of a struct type with few mandatory and
> >    extra optional fields:
> >    - type field is mandatory and specified type of BPF map;
> >    - key/value fields are mandatory and capture key/value type/size information;
> >    - max_entries attribute is optional; if max_entries is not specified or
> >      initialized, it has to be provided in runtime through libbpf API
> >      before loading bpf_object;
> >    - map_flags is optional and if not defined, will be assumed to be 0.
> > 3. Key/value fields should be **a pointer** to a type describing
> >    key/value. The pointee type is assumed (and will be recorded as such
> >    and used for size determination) to be a type describing key/value of
> >    the map. This is done to save excessive amounts of space allocated in
> >    corresponding ELF sections for key/value of big size.
> > 4. As some maps disallow having BTF type ID associated with key/value,
> >    it's possible to specify key/value size explicitly without
> >    associating BTF type ID with it. Use key_size and value_size fields
> >    to do that (see example below).
> >
> > Here's an example of simple ARRAY map defintion:
> >
> > struct my_value { int x, y, z; };
> >
> > struct {
> >       int type;
> >       int max_entries;
> >       int *key;
> >       struct my_value *value;
> > } btf_map SEC(".maps") = {
> >       .type = BPF_MAP_TYPE_ARRAY,
> >       .max_entries = 16,
> > };
> >
> > This will define BPF ARRAY map 'btf_map' with 16 elements. The key will
> > be of type int and thus key size will be 4 bytes. The value is struct
> > my_value of size 12 bytes. This map can be used from C code exactly the
> > same as with existing maps defined through struct bpf_map_def.
> >
> > Here's an example of STACKMAP definition (which currently disallows BTF type
> > IDs for key/value):
> >
> > struct {
> >       __u32 type;
> >       __u32 max_entries;
> >       __u32 map_flags;
> >       __u32 key_size;
> >       __u32 value_size;
> > } stackmap SEC(".maps") = {
> >       .type = BPF_MAP_TYPE_STACK_TRACE,
> >       .max_entries = 128,
> >       .map_flags = BPF_F_STACK_BUILD_ID,
> >       .key_size = sizeof(__u32),
> >       .value_size = PERF_MAX_STACK_DEPTH * sizeof(struct bpf_stack_build_id),
> > };
> >
> > This approach is naturally extended to support map-in-map, by making a value
> > field to be another struct that describes inner map. This feature is not
> > implemented yet. It's also possible to incrementally add features like pinning
> > with full backwards and forward compatibility.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/btf.h    |   1 +
> >  tools/lib/bpf/libbpf.c | 333 +++++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 325 insertions(+), 9 deletions(-)
