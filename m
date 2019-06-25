Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 873E1556D7
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbfFYSOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:14:47 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37393 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbfFYSOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:14:47 -0400
Received: by mail-qt1-f196.google.com with SMTP id y57so19501394qtk.4;
        Tue, 25 Jun 2019 11:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ttqneRism6nSsj2/bmPKPIiR+rUmQ1IgFbVIvgbIjkE=;
        b=Y7YwhJquOx1jxlvYay0BOG2vPRlySN5jssi1lSp4v/xc3m8bz1SU4RFNkLsBTAXACu
         r1RH1u7otoUdXiTP9ixPfWZv0KodZ6NFC52hHR9Hy85uqF19wzSwbk1gQTHQg+il5FW9
         SlgWpuWXM0k4KASUTNtRW7YNX2Tdi7SRyB0DlyiMcg8TyOUeIKWurxDTyLg7i15b9pWL
         8CiVSyMpnSXarlO3jrUCZvoWYNyJY9M8XvXVysQshNh1yESkM1MSW7kWvh+A55AQJRK4
         LYD8L54qd20NE/oJo6Wc88cfoohrdiN/7aRO8v0oga0eQPbbb3z0uw7sfckNemuomMQw
         jH3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ttqneRism6nSsj2/bmPKPIiR+rUmQ1IgFbVIvgbIjkE=;
        b=qWPW1oNqX9IrxGTPk7XtDZCg+PGm0Y5C1YtRwuYof88Rav8kCdiitr0quU/SsJJkLt
         48DabwwJQODaueuTJ05IcOSMe+2tJcOYOQlYU6QIBIfL2RDmSGVwMLQvgiDMWS+2qcGW
         +LhVo1Gs0fKtMsdVS+j0juiOBlJHT+hSrzP5LYlSEu+5IooQW43srsRjazSM073TN25r
         g2FD7GcxF96FN9ayWrfBydDH4TfAYnPcHq5NMhjWiyMqbL35Aavg7cd1cNEIOZFKY7NR
         9ohQDbJLQtQbqUc/XAzbBiv3oTJ7e4xMQabDwDuQDH5m8//pXe4v7AL7bCgIQ95/G1Pt
         6/qg==
X-Gm-Message-State: APjAAAUwDNdkU1AB/UTdtcGpziYU6TWOxfg44H5Nmmho/UidFnVlkoRB
        1Psf2fTPk412Iqylh+hnocZa+pk4qb7kDGTDfJk=
X-Google-Smtp-Source: APXvYqxqKYEDr8WS6l2pxezv/R4XnvZeLJB15s+rEt33TNsKEFtXrRVIX13+mtrzr2hco/lUTgsEp4I2R8bVPjETYVo=
X-Received: by 2002:ac8:2fb7:: with SMTP id l52mr108862324qta.93.1561486485632;
 Tue, 25 Jun 2019 11:14:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190617192700.2313445-1-andriin@fb.com> <30a2c470-5057-bd96-1889-e77fd5536960@iogearbox.net>
 <CAEf4Bzae1CPDkhPrESa2ZmiOH8Mqf0KA_4ty9z=xnYn=q7Frhw@mail.gmail.com>
 <CACAyw9-L0qx8d9O66SaYhJGjsyKo_6iozqLAQHEVa1AW-U=2Tg@mail.gmail.com>
 <CAEf4BzYaHG9Z_eFQCtwxA7t5GwQq2wr=AEeFWZpqx9vdQqKv1g@mail.gmail.com>
 <CACAyw98JqwZbcTdpRNcG_fT6A-ekEqn9D5Zx4myB8oiX73uZkw@mail.gmail.com> <CAEf4BzYtM-41Y5w0-6kWhaeQUh7it5Zd_OZBj4kvMYou3TwQ+A@mail.gmail.com>
In-Reply-To: <CAEf4BzYtM-41Y5w0-6kWhaeQUh7it5Zd_OZBj4kvMYou3TwQ+A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 25 Jun 2019 11:14:34 -0700
Message-ID: <CAEf4BzZVZTCA9TRTf0soLWZp8ZmOaUEHK9Ue6WtE43PbkdriWw@mail.gmail.com>
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

On Fri, Jun 21, 2019 at 10:56 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Jun 21, 2019 at 3:29 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > On Fri, 21 Jun 2019 at 05:20, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Thu, Jun 20, 2019 at 7:49 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > >
> > > > On Tue, 18 Jun 2019 at 22:37, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > > > I would just drop the object-scope pinning. We avoided using it and I'm not
> > > > > > aware if anyone else make use. It also has the ugly side-effect that this
> > > > > > relies on AF_ALG which e.g. on some cloud provider shipped kernels is disabled.
> > > > > > The pinning attribute should be part of the standard set of map attributes for
> > > > > > libbpf though as it's generally useful for networking applications.
> > > > >
> > > > > Sounds good. I'll do some more surveying of use cases inside FB to see
> > > > > if anyone needs object-scope pinning, just to be sure we are not
> > > > > short-cutting anyone.
> > > >
> > > > I'm also curious what the use cases for declarative pinning are. From my
> > > > limited POV it doesn't seem that useful? There are a couple of factors:
> > >
> > > Cilium is using it pretty extensively, so there are clearly use cases.
> > > The most straigtforward use case is using a map created and shared by
> > > another BPF program (to communicate, read stats, what have you).
> >
> > I think Cilium is in the quirky position that it has a persistent daemon, but
> > shells out to tc for loading programs. They are probably also the most
> > advanced (open-source) users of BPF out there. If I understood their comments
> > correctly they want to move to using a library for loading their ELF. At that
> > point whether something is possible in a declarative way is less important,
> > because you have the much more powerful APIs at your disposal.
> >
> > Maybe Daniel or someone else from the Cilium team can chime in here?
>
> Yep, curious about their perspective on that.
>
> >
> > > > * Systemd mounts the default location only accessible to root, so I have to
> > > >   used my own bpffs mount.
> > > > * Since I don't want to hard code that, I put it in a config file.
> > > > * After loading the ELF we pin maps from the daemon managing the XDP.
> > >
> > > So mounting root would be specified per bpf_object, before maps are
> > > created, so user-land driving application will have an opportunity to
> > > tune everything. Declarative is only the per-map decision of whether
> > > that map should be exposed to outer world (for sharing) or not.
> >
> > So `tc filter add bpf obj foo.elf pin-root /gobbledygook`?
>
> I meant something like:
>
> bpf_object_open_attr attr;
> attr.file = "path/to/my/object.o";
> attr.pin_root_path = "/my/fancy/bpffs/root";
> bpf_object__open_xattr(&attr);
>
> Then tools can adopt they when necessary.
>
> >
> > > Then check tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
> > > for more crazy syntax ;)
> > >
> > > typedef char * (* const (* const fn_ptr_arr2_t[5])())(char * (*)(int));
> >
> > Not on a Friday ;P
> >
> > > > What if this did
> > > >
> > > >   __type(value, struct my_value)[1000];
> > > >   struct my_value __member(value)[1000]; // alternative
> > > >
> > > > instead, and skipped max_entries?
> > >
> > > I considered that, but decided for now to keep all those attributes
> > > orthogonal for more flexibility and uniformity. This syntax might be
> > > considered a nice "syntax sugar" and can be added in the future, if
> > > necessary.
> >
> > Ack.
> >
> > > > At that point you have to understand that value is a pointer so all of
> > > > our efforts
> > > > are for naught. I suspect there is other weirdness like this, but I need to play
> > > > with it a little bit more.
> > >
> > > Yes, C can let you do crazy stuff, if you wish, but I think that
> > > shouldn't be a blocker for this proposal. I haven't seen any BPF
> > > program doing that, usually you duplicate the type of inner value
> > > inside your function anyway, so there is no point in taking
> > > sizeof(map.value) from BPF program side. From outside, though, all the
> > > types will make sense, as expected.
> >
> > Right, but in my mind that is a bit of a cop out. I like BTF map definitions,
> > and I want them to be as unsurprising as possible, so that they are
> > easy to use and adopt.
>
>
> Right, but there are limit on what you can do with C syntax and it's
> type system. Having fancy extra features like you described (e.g,
> sizeof(map.value), etc) is pretty low on a priority list.
>
> >
> > If a type encodes all the information we need via the array dimension hack,
> > couldn't we make the map variable itself a pointer, and drop the inner pointers?
> >
> > struct my_map_def {
> >   int type[BPF_MAP_TYPE_HASH];
> >   int value;
> >   struct foo key;
>
> This is bad because it potentially uses lots of space. If `struct foo`
> is big, if max_entries is big, even for type, it's still a bunch of
> extra space wasted. That's why we have pointers everywhere, as they
> allow to encode everything with fixed space overhead of 8 bytes for a
> pointer.
>
>
> >   ...
> > }
> >
> > struct my_map_def *my_map;

Oh, I missed this point completely, sorry about that.

This has very little advantage over my proposal, in that number
encoding is still cumbersome with array dimensions, so you'd want to
hide it anyway behind macro, probably.

But the main problem with that is when we are going to do prog_array
or map-in-map initialization. This will create potentially huge
anonymous variable to initialize this pointer. See example below:

$ cat test.c
typedef int(*func)(void);

int f1(void) {
        return 0;
}

int f2(void) {
        return 1;
}

struct my_map_def {
        int size[1000];
        func arr[1000];
} *map = &(struct my_map_def){
        .arr = {
                [500] = &f1,
                [999] = &f2,
        },
};
$ ~/local/llvm/build/bin/clang -g -target bpf -c test.c -o test.o
$ bpftool btf dump file test.o

<snip>

[6] VAR '.compoundliteral' type_id=0, linkage=static

<snip>

[15] DATASEC '.data' size=0 vlen=1
        type_id=6 offset=0 size=12000

Note how variable ".compoundliteral" of size 12000 bytes is added
here. Plus the syntax of initialization is cumbersome, and it requires
naming map definition struct just for that &(struct my_map_def) cast.

So I think this doesn't get as much, but makes more advanced use cases
much more cumbersome and prohibitively expensive in terms of storage
size.

> >
> > --
> > Lorenz Bauer  |  Systems Engineer
> > 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
> >
> > www.cloudflare.com
