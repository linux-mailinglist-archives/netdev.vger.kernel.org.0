Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043E433A57
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfFCVzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:55:06 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39523 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFCVzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:55:06 -0400
Received: by mail-qt1-f193.google.com with SMTP id i34so11379862qta.6;
        Mon, 03 Jun 2019 14:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g62VoFh1TWt0BaxB4CVTV/laUlpe2RcekLLgFMDtDuU=;
        b=aO/GsOEQrHp+Wg7huqZUjr8yY9wGXvoD0XGdXlHf2taoXMGORlwPHa1UMcLBfDBYNK
         C49S8w9aN5kyzTP2v6MYsELhnDoCuRlky5zzFN0G5+ULoAPvnnsHd8McYjshCybiHbUR
         fzRCAU0dZUn0axS40akc6FAexlmzg2Q6kmudw8s3p5xZ25zkU0LawnIVvsFGIM5z+8T6
         oCj6MYQQR0ve/iaRHiu4at5ACpey+GNUSLjNIjgECn8dmydbvlxf0JIIh5l4UHG3/94N
         JgjXALQdLoKC+C0jsz/oLNzNTu/HPLvNDM06QdAyv5KKPbs41LUaGx7a4nU4OJ+/R0RV
         jqNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g62VoFh1TWt0BaxB4CVTV/laUlpe2RcekLLgFMDtDuU=;
        b=gusSTpmdhPjV/qlsSlSyrVemyKIhHri2ZFvVZcEHFWMpMFFcykBnvloUN/xi6c66H2
         77eOQl8NeFFhl4j+0X0DRHU/MTJyA1vTHk6kQRulaLh6j8/YRPqQtjp69UwXGqoZcZom
         ugdu1THSKfUfd5JpcNQS6wOyy8PqKnN/dHPH85AqCMMADdovFyHUDD+cqb4WsEuEkfEA
         QDfrC2iBZWbFH47jjPUMwNgF+5dewyPtuawfJVNwS/hvF9byIvwttpXETnTAuJLqIZ+r
         I7XaXc5Q47EnZVetPj/hohYGY6Rnpswi5KWvo1jg1rd0T9XxZoZFcJj8L+N3YfYxvDwb
         1iWg==
X-Gm-Message-State: APjAAAXX8/mQ7danjP1CubYpv68xJnjYjh3vTZdJpvzX/DPkI1KHqDXc
        8v1x5+fm8Z4hXTirMRqfjLZU7AhDIx9JP9JcbcY=
X-Google-Smtp-Source: APXvYqyCuhHQOpDQKWdingGhf+mak19FKuBjYFTSl/OSd7LY7KJ4rlrgS3mjU3zDZlny1vPxv7nr1CvkrUrTbKeruEw=
X-Received: by 2002:ac8:1087:: with SMTP id a7mr13753282qtj.141.1559598904733;
 Mon, 03 Jun 2019 14:55:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190531202132.379386-1-andriin@fb.com> <20190531202132.379386-7-andriin@fb.com>
 <20190531212835.GA31612@mini-arch> <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
 <20190602173334.18e68d66@cakuba.netronome.com>
In-Reply-To: <20190602173334.18e68d66@cakuba.netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 3 Jun 2019 14:54:53 -0700
Message-ID: <CAEf4BzZ9vYDbdeZyhj_CQpqRUE_BLO9dbXRvnBNaikoO9OpVsw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map definitions
 using BTF
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 2, 2019 at 5:33 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Fri, 31 May 2019 15:58:41 -0700, Andrii Nakryiko wrote:
> > On Fri, May 31, 2019 at 2:28 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > > On 05/31, Andrii Nakryiko wrote:
> > > > This patch adds support for a new way to define BPF maps. It relies on
> > > > BTF to describe mandatory and optional attributes of a map, as well as
> > > > captures type information of key and value naturally. This eliminates
> > > > the need for BPF_ANNOTATE_KV_PAIR hack and ensures key/value sizes are
> > > > always in sync with the key/value type.
> > > My 2c: this is too magical and relies on me knowing the expected fields.
> > > (also, the compiler won't be able to help with the misspellings).
>
> I have mixed feelings, too.  Especially the key and value fields are
> very non-idiomatic for C :(  They never hold any value or data, while
> the other fields do.  That feels so awkward.  I'm no compiler expert,
> but even something like:
>
> struct map_def {
>         void *key_type_ref;
> } mamap = {
>         .key_type_ref = &(struct key_xyz){},
> };
>
> Would feel like less of a hack to me, and then map_def doesn't have to
> be different for every map.  But yea, IDK if it's easy to (a) resolve
> the type of what key_type points to, or (b) how to do this for scalar
> types.

The syntax for scalar would be &(int){0}, that compiles.

But there are a bunch of things that make it infeasible. So let's take
an example and see what's happening:

/* huge struct */
struct custom {int a; int b; int c; int d[1000000];};

struct {
        void *key;
        void *value;
} new_map = {
        .key = &(int){0},
        .value = &(struct custom){},
};

If we dump BTF, here's what we get:

$ bpftool btf dump file tail_call_test.o
[1] FUNC_PROTO '(anon)' ret_type_id=2 vlen=0
[2] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
[3] FUNC 'main' type_id=1
[4] VAR '.compoundliteral' type_id=0, linkage=static
[5] VAR '.compoundliteral.1' type_id=0, linkage=static
[6] STRUCT '(anon)' size=24 vlen=3
        'type' type_id=2 bits_offset=0
        'key' type_id=7 bits_offset=64
        'value' type_id=7 bits_offset=128
[7] PTR '(anon)' type_id=0
[8] VAR 'new_map' type_id=6, linkage=global-alloc
[9] DATASEC '.bss' size=0 vlen=2
        type_id=4 offset=0 size=4
        type_id=5 offset=4 size=4000012
[10] DATASEC '.maps' size=0 vlen=1
        type_id=8 offset=0 size=24

So notice how we get two .bss entries, one for 4 bytes (for key, var
'compoundliteral') and another for 4MB (for huge struct, var
'.compoundliteral.1'). So while this won't increase the size of ELF,
it will force a huge .bss (and corresponding global data map) to be
created, which is no good.

Also, notice how there is no type information associated with [4] and
[5] vars, they are just of type void. There is no type information
about struct custom at all, though it might be (?) possible to fix it
by modifying compiler to preserve more type information.

So while the second one is a technical hurdle, which we might overcome
(not sure, actually), the issue with big .BSS is a showstopper for
some applications.

To eliminate .BSS issue, we'd need something like this to capture type
information:

struct {
        void *key;
        void *value;
} new_map = {
        .key = (int)0,
        .value = (struct custom *)0,
};

But that doesn't capture any type information for those type casts at
all, so more compiler work (if at all possible).

Which is why I think capturing type information using a standard
non-convoluted C way/syntax using a field declaration is the most
reliable, simple, and clean way. You do intialize key/value, it's just
a NULL pointer to corresponding type:

struct {
        int type;
        int *key;
        struct custom *value;
} new_map __attribute__((section(".maps"), used)) = {
        .type = 2,
        .key = (int)0,
        .value = (struct custom *)NULL,
};


Notice, btw, that this approach doesn't prevent you to re-use struct
definitions for multiple maps, if they have identical key/value types
or if you are not capturing type information at all.

struct my_typical_map {
        int type;
        int max_entries;
        u64 *key;
        struct custom *value;
};

struct my_typical_map map1 SEC(".maps") = {
        .type = BPF_MAP_TYPE_ARRAY,
        .max_entries = 10,
};

struct my_typical_map map2 SEC(".maps") = {
        .type = BPF_MAP_TYPE_ARRAY,
        .max_entries = 20,
};

Or, you can just re-use struct bpf_map_def today like this (but you
won't have type info for key/value, of course):

struct bpf_map_def my_map_without_type_info SEC(".maps") = {
        .type = BPF_MAP_TYPE_ARRAY,
        .max_entries = 100,
        .key_size = sizeof(u64),
        .value_size = sizeof(struct custom),
};

This approach gives you as much flexibility as possible, you only will
have to have different definition struct, if you have different
key/value type (in C++ that would be solved by templates, but alas we
are in C land).


>
> > I don't think it's really worse than current bpf_map_def approach. In
> > typical scenario, there are only two fields you need to remember: type
> > and max_entries (notice, they are called exactly the same as in
> > bpf_map_def, so this knowledge is transferrable). Then you'll have
> > key/value, using which you are describing both type (using field's
> > type) and size (calculated from the type).
> >
> > I can relate a bit to that with bpf_map_def you can find definition
> > and see all possible fields, but one can also find a lot of examples
> > for new map definitions as well.
> >
> > One big advantage of this scheme, though, is that you get that type
> > association automagically without using BPF_ANNOTATE_KV_PAIR hack,
> > with no chance of having a mismatch, etc. This is less duplication (no
> > need to do sizeof(struct my_struct) and struct my_struct as an arg to
> > that macro) and there is no need to go and ping people to add those
> > annotations to improve introspection of BPF maps.
>
> > > > Relying on BTF, this approach allows for both forward and backward
> > > > compatibility w.r.t. extending supported map definition features. Old
> > > > libbpf implementation will ignore fields it doesn't recognize, while new
> > > > implementations will parse and recognize new optional attributes.
> > > I also don't know how to feel about old libbpf ignoring some attributes.
> > > In the kernel we require that the unknown fields are zeroed.
> > > We probably need to do something like that here? What do you think
> > > would be a good example of an optional attribute?
> >
> > Ignoring is required for forward-compatibility, where old libbpf will
> > be used to load newer user BPF programs. We can decided not to do it,
> > in that case it's just a question of erroring out on first unknown
> > field. This RFC was posted exactly to discuss all these issues with
> > more general community, as there is no single true way to do this.
> >
> > As for examples of when it can be used. It's any feature that can be
> > considered optional or a hint, so if old libbpf doesn't do that, it's
> > still not the end of the world (and we can live with that, or can
> > correct using direct libbpf API calls).
>
> On forward compatibility my 0.02c would be - if we want to go there
> and silently ignore fields it'd be good to have some form of "hard
> required" bit.  For TLVs ABIs it can be a "you have to understand
> this one" bit, for libbpf perhaps we could add a "min libbpf version
> required" section?  That kind of ties us ELF formats to libbpf
> specifics (the libbpf version presumably would imply support for
> features), but I think we want to go there, anyway.

I think we can go with strict/non-strict mode, which we already
support in libbpf with MAPS_RELAX_COMPAT flag (see
__bpf_object__open_xattr), would that work?
