Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBD793C026
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 01:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390687AbfFJXtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 19:49:10 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39648 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390524AbfFJXtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 19:49:10 -0400
Received: by mail-qk1-f194.google.com with SMTP id i125so6534798qkd.6;
        Mon, 10 Jun 2019 16:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jozXrqFphFU3vlMDyhbHjG2RsqRJsZmkKUiyJq3WnkU=;
        b=LMyU70vXzsDEPlCW64H81+tj/TbcQVyMwNMUO1EpwQhk2EczBO99rhx2BQ9QcU65Fi
         /JgiFW/xfbYAGM4e0UzsAut8o2Th5Mz6xp4HbtBaQ1W0U+Mk1BKK2l0X5ZUUGmw7Pq0i
         ECD9CPuuaW6ZLvvbIx7j5tdlUPWDUJWasTjTONkcH+m5gCj3UOdwEwpjJg8JXxJpQkvg
         O9jwRBm+Xgmui22CL7zzNXa599JjW60ybOmDuED9pEAKGYTk9dyGh1KJABRzSZFl5Ezt
         e1tZXBc377LYB0cT6sOdsSHHvI7H2JJjJm1jKM06pxP72ZGJXGGL8QHOd2lHo4YlTtOO
         F67g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jozXrqFphFU3vlMDyhbHjG2RsqRJsZmkKUiyJq3WnkU=;
        b=sLXAVk+6lAxEr6B1op1Pv6s1tzX0rB+e49ALFDhps03pdxoz5qCY5Cf4OijwMY0GZU
         1TSwvw7j5M9mmsN+b7TjjYsT3syO3T7WgBQl2VybQts6t8vbGRS/dDZDTMC2NEJh9g+e
         hlJjE1J8gjnNpaKGU/JrJX8dbo0Z63J+cIk6p+UMFzY5fi9OvqOsrKb8Pa9ezx0Cj3ex
         Xupw5dkeTGcmwr35sENfrhtnX9GocMeQ0gCJnmbRD7xThcZi7afzSOT6QvnRJQNYOODA
         3DmgbSA7IKfS7b2o2xqd6LGIwE+LGtMhKWk+jfswIwv17FOspjTKLIxEVgR73bGFGleA
         AY5g==
X-Gm-Message-State: APjAAAWUxiOZrs2lnGWQlLlknjoe74c/iWvFer7ja1tC0CIgsJQ2S/L+
        A0QOC7nNt2qmtX0XOuetVV3Psc24JSriTH/CbcAGsaYP
X-Google-Smtp-Source: APXvYqxFbJihatw/rosGsK6jqnEnOWU7hg8gvwhFIM57z5ifKEihnbQCiILzN7esjRT3OnWnnGctKNo5qMH07u9Mu6I=
X-Received: by 2002:a05:620a:147:: with SMTP id e7mr57263734qkn.247.1560210548951;
 Mon, 10 Jun 2019 16:49:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190531202132.379386-1-andriin@fb.com> <20190531202132.379386-7-andriin@fb.com>
 <20190531212835.GA31612@mini-arch> <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
 <20190603163222.GA14556@mini-arch> <CAEf4BzbRXAZMXY3kG9HuRC93j5XhyA3EbWxkLrrZsG7K4abdBg@mail.gmail.com>
 <20190604010254.GB14556@mini-arch> <f2b5120c-fae7-bf72-238a-b76257b0c0e4@fb.com>
 <20190604042902.GA2014@mini-arch> <20190604134538.GB2014@mini-arch>
 <CAEf4BzZEqmnwL0MvEkM7iH3qKJ+TF7=yCKJRAAb34m4+B-1Zcg@mail.gmail.com>
 <3ff873a8-a1a6-133b-fa20-ad8bc1d347ed@iogearbox.net> <CAEf4BzYr_3heu2gb8U-rmbgMPu54ojcdjMZu7M_VaqOyCNGR5g@mail.gmail.com>
 <9d0bff7f-3b9f-9d2c-36df-64569061edd6@fb.com> <20190606171007.1e1eb808@cakuba.netronome.com>
 <4553f579-c7bb-2d4c-a1ef-3e4fbed64427@fb.com> <20190606180253.36f6d2ae@cakuba.netronome.com>
 <b9798871-3b0e-66ce-903d-c9a587651abc@fb.com>
In-Reply-To: <b9798871-3b0e-66ce-903d-c9a587651abc@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 10 Jun 2019 16:48:57 -0700
Message-ID: <CAEf4Bzbc0VAMjxt=K6nguLz0aP+YEt9Au+KWh-WxvZR19KCD4A@mail.gmail.com>
Subject: Re: explicit maps. Was: [RFC PATCH bpf-next 6/8] libbpf: allow
 specifying map definitions using BTF
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 9, 2019 at 6:17 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 6/6/19 6:02 PM, Jakub Kicinski wrote:
> > On Fri, 7 Jun 2019 00:27:52 +0000, Alexei Starovoitov wrote:
> >> the solution we're discussing should solve BPF_ANNOTATE_KV_PAIR too.
> >> That hack must go.
> >
> > I see.
> >
> >> If I understood your objections to Andrii's format is that
> >> you don't like pointer part of key/value while Andrii explained
> >> why we picked the pointer, right?
> >>
> >> So how about:
> >>
> >> struct {
> >>     int type;
> >>     int max_entries;
> >>     struct {
> >>       __u32 key;
> >>       struct my_value value;
> >>     } types[];
> >> } ...
> >
> > My objection is that k/v fields are never initialized, so they're
> > "metafields", mixed with real fields which hold parameters - like
> > type, max_entries etc.
>
> I don't share this meta fields vs real fields distinction.

100% agree.

> All of the fields are meta.
> Kernel implementation of the map doesn't need to hold type and
> max_entries as actual configuration fields.
> The map definition in c++ would have looked like:
> bpf::hash_map<int, struct my_value, 1000, NO_PREALLOC> foo;
> bpf::array_map<struct my_value, 2000> bar;
>
> Sometime key is not necessary. Sometimes flags have to be zero.
> bpf syscall api is a superset of all fiels for all maps.
> All of them are configuration and meta fields at the same time.
> In c++ example there is really no difference between
> 'struct my_value' and '1000' attributes.
>
> I'm pretty sure bpf will have C++ front-end in the future,
> but until then we have to deal with C and, I think, the map
> definition should be the most natural C syntax.
> In that sense what you're proposing with extern:
> > extern struct my_key my_key;
> > extern int type_int;
> >
> > struct map_def {
> >      int type;
> >      int max_entries;
> >      void *btf_key_ref;
> >      void *btf_val_ref;
> > } = {
> >      ...
> >      .btf_key_ref = &my_key,
> >      .btf_val_ref = &type_int,
> > };
>
> is worse than
>
> struct map_def {
>        int type;
>        int max_entries;
>        int btf_key;
>        struct my_key btf_value;
> };
>
> imo explicit key and value would be ideal,

also agree 100%, that's how I started, but then was quickly pointed to
a real cases where value is just way too big.

> but they take too much space. Hence pointers
> or zero sized array:
> struct {
>       int type;
>       int max_entries;
>       struct {
>         __u32 key;
>         struct my_value value;
>       } types[];
> };

This works, but I still prefer simpler

__u32 *key;
struct my_value *value;

It has less visual clutter and doesn't rely on somewhat obscure
flexible array feature (and it will have to be last in the struct,
unless you do zero-sized array w/ [0]).

>
> I think we should also consider explicit map creation.
>
> Something like:
>
> struct my_map {
>    __u32 key;
>    struct my_value value;
> } *my_hash_map, *my_pinned_hash_map;
>
> struct {
>     __u64 key;
>    struct my_map *value;
> } *my_hash_of_maps;
>
> struct {
>    struct my_map *value;
> } *my_array_of_maps;
>
> __init void create_my_maps(void)
> {
>    bpf_create_hash_map(&my_hash_map, 1000/*max_entries*/);
>    bpf_obj_get(&my_pinned_hash_map, "/sys/fs/bpf/my_map");
>    bpf_create_hash_of_maps(&my_hash_of_maps, 1000/*max_entries*/);
>    bpf_create_array_of_maps(&my_array_of_maps, 20);
> }
>
> SEC("cgroup/skb")
> int bpf_prog(struct __sk_buff *skb)
> {
>    struct my_value *val;
>    __u32 key;
>    __u64 key64;
>    struct my_map *map;
>
>    val = bpf_map_lookup(my_hash_map, &key);
>    map = bpf_map_lookup(my_hash_of_maps, &key64);
> }
>
> '__init' section will be compiled by llvm into bpf instructions
> that will be executed in users space by libbpf.
> The __init prog has to succeed otherwise prog load fails.
>
> May be all map pointers should be in a special section to avoid
> putting them into datasec, but libbpf should be able to figure that
> out without requiring user to specify the .map section.
> The rest of global vars would go into special datasec map.
>
> No llvm changes necessary and BTF is available for keys and values.
>
> libbpf can start with simple __init and eventually grow into
> complex init procedure where maps are initialized,
> prog_array is populated, etc.
>
> Thoughts?

I have few. :)

I think it would be great to have this feature as a sort of "escape
hatch" for really complicated initialization of maps, which can't be
done w/ declarative syntax (and doing it from user-land driving app is
not possible/desirable). But there is a lot of added complexity and
work to be done to make this happen:

1. We'll need to build BPF interpreter into libbpf (so partial
duplication of in-kernel BPF machinery);
2. We'll need to define some sort of user-space BPF API, so that these
init functions can call into libbpf API (at least). So now in addition
to in-kernel BPF helpers, we'll have another and different set of
helpers/APIs exposed to user-land BPF code. This will certainly add
confusion and raise learning curve.
3. Next we'll be adding not-just-libbpf APIs, for cases where the size
of map depends on some system parameter (e.g., number of CPUs, or
amount of free RAM, or something else). This probably can be done
through exposed libbpf APIs again, but now we'll need to decide what
gets exposed, in what format, etc.

It's all doable, but looks like a very large effort, while we yet
don't have a realistic use case for this. Today cases like that are
handled by driving user-land app. It seems like having prog_array and
map-in-map declarative initialization covers a lot of advanced use
cases (plus, of course, pinning), so for starters I'd concentrate
effort there to get declarative approach powerful enough to address a
lot of real-world needs.

The good thing, though, is that nothing prevents us from specifying
and adding this later, once we have good use cases and most needs
already covered w/ declarative syntax.

But, assuming we do explicit map creation, I'd also vote for per-map
"factory" functions, like this:

typedef int (*map_factory_fn)(struct bpf_map); /* can be provided by libbpf */

int init_my_map(struct bpf_map *map)
{
    /* something fancy here */
}

struct {
    __u64 *key;
    struct my_value *value;
    map_factory_fn factory;
} my_map SEC(".maps") = {
    .factory = &init_my_map,
};

/* we can still have per-BPF object init function: */
int init_my_app(struct bpf_object *obj) {
    /* some more initialization of BPF object */
}
