Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6ABC2A6F19
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 21:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732392AbgKDUnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 15:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730347AbgKDUnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 15:43:51 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24B8C0613D3;
        Wed,  4 Nov 2020 12:43:50 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id a4so19153335ybq.13;
        Wed, 04 Nov 2020 12:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z9FsPl9XwWWDle2sDOAqau1iV5ogrbFs3+ZP5mOrWFY=;
        b=uwZ5a1TY0NPVuqzoDb0ocaQWLn7VTbeyOpMT7yjl6hvmQV8Ii5edDUUTprYHslfr8T
         KTudjYB0eZN4Hfg1EsiuEmOp5Ripa2dC9DjsSraPsH60LZAbXri0qxD6yP+4Betl/bpI
         KSmZvGuN5gJ+FNtcUz/N+m7l/19Z1QvfCp5jZwBTldTxqQws/3H1jRpiL+QlFs1tXLp4
         DfE9WG5He6/jOsJZUff+ohDQGPC6I3LH5UgNrz9U32lPnDTRlkWbDsIqWoSPuHQSq7a1
         +rpY++tObdbjQIRmMG5aFMq5Lf5dyKt7xnJS/Vpdp0bt83yKIX+43d8+8DXJk4u+UWoY
         8juQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z9FsPl9XwWWDle2sDOAqau1iV5ogrbFs3+ZP5mOrWFY=;
        b=F+EgsKaoEZIpQCIZFslqNe7zy8C+kUMTTRyQ04EZS3eD+4WmnjpgqNMUz05xpQOZiP
         utna1yOd1rWnNAUDEpi0OjHdR3ZyPC2bLN0GA3mL4yboE/hg6NKUCDPQ8rthUtbDatxq
         1gladb3yCuC+MCdt+vw++M39bXV723XIchNI7jYtld/8IJ0kY66MZlQ7w3WhuayuWpPY
         KrydpiwDXK2bu4dA1TZniXC07DzcF+q/zuaGKhfYl6nXdqb8dLQAzmpJpYKdWlUkG9um
         UYzzlF9rntyK3FXH6plgAbrSmGTD4KVHBwPzwJeE3E76xRbrK6XGd8IyGl34/xx6IxnI
         Dnzg==
X-Gm-Message-State: AOAM530zhtV3ZIAlMCJxTZqSuVmuHFgEqmDwe1OMuI6mcCMxDPleejn8
        3p163AJWYO/LM/S16+PocpomIgRSk+cDSyIcCOE=
X-Google-Smtp-Source: ABdhPJyehVk7UFqHqpdA8YNoovYzEtewaQaLiOBgcuzBEJpSMm9USGBCQwBSmbomdfp0egZQoRwL8eByNVfH1NYSfCI=
X-Received: by 2002:a05:6902:72e:: with SMTP id l14mr8596682ybt.230.1604522630029;
 Wed, 04 Nov 2020 12:43:50 -0800 (PST)
MIME-Version: 1.0
References: <20201028132529.3763875-1-haliu@redhat.com> <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com> <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net> <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com> <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com> <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net> <87zh3xv04o.fsf@toke.dk>
 <5de7eb11-010b-e66e-c72d-07ece638c25e@iogearbox.net> <20201104111708.0595e2a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201104111708.0595e2a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 4 Nov 2020 12:43:38 -0800
Message-ID: <CAEf4BzY2pAaEmv_x_nGQC83373ZWUuNv-wcYRye+vfZ3Fa2qbw@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 11:17 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 4 Nov 2020 14:12:47 +0100 Daniel Borkmann wrote:
> > If we would have done lib/bpf.c as a dynamic library back then, we wouldn't be
> > where we are today since users might be able to start consuming BPF functionality
> > just now, don't you agree? This was an explicit design choice back then for exactly
> > this reason. If we extend lib/bpf.c or import libbpf one way or another then there
> > is consistency across distros and users would be able to consume it in a predictable
> > way starting from next major releases. And you could start making this assumption
> > on all major distros in say, 3 months from now. The discussion is somehow focused
> > on the PoV of /a/ distro which is all nice and good, but the ones consuming the
> > loader shipping software /across/ distros are users writing BPF progs, all I'm
> > trying to say is that the _user experience_ should be the focus of this discussion
> > and right now we're trying hard making it rather painful for them to consume it.

This! Thanks, Daniel, for stating it very explicitly. Earlier I
mentioned iproute2 code simplification if using submodules, but that's
just a nice by-product, not the goal, so I'll just ignore that. I'll
try to emphasize the end user experience though.

What users writing BPF programs can expect from iproute2 in terms of
available BPF features is what matters. And by not enforcing a
specific minimal libbpf version, iproute2 version doesn't matter all
that much, because libbpf version that iproute2 ends up linking
against might be very old.

There was a lot of talk about API stability and backwards
compatibility. Libbpf has had a stable API and ABI for at least 1.5
years now and is very conscious about that when adding or extending
new APIs. That's not even a factor in me arguing for submodules. I'll
give a few specific examples of libbpf API not changing at all, but
how end user experience gets tremendously better.

Some of the most important APIs of libbpf are, arguably,
bpf_object__open() and bpf_object__load(). They accept a BPF ELF file,
do some preprocessing and in the end load BPF instructions into the
kernel for verification. But while API doesn't change across libbpf
versions, BPF-side code features supported changes quite a lot.

1. BTF sanitization. Newer versions of clang would emit a richer set
of BTF type information. Old kernels might not support BTF at all (but
otherwise would work just fine), or might not support some specific
newer additions to BTF. If someone was to use the latest Clang, but
outdated libbpf and old kernel, they would have a bad time, because
their BPF program would fail due to the kernel being strict about BTF.
But new libbpf would "sanitize" BTF, according to supported features
of the kernel, or just drop BTF altogether, if the kernel is that old.

If iproute2's latest version doesn't imply the latest libbpf version,
there is a high chance that the user's BPF program will fail to load.
Which requires users to be **aware** of all these complications, and
care about specific Clang versions and subsets of BTF that get
generated. With the latest libbpf all that goes away.

2. bpf_probe_read_user() falling back to bpf_probe_read(). Newer
kernels warn if a BPF application isn't using a proper _kernel() or
_user() variant of bpf_probe_read(), and eventually will just stop
supporting generic bpf_probe_read(). So what this means is that end
users would need to compile to variants of their BPF application, one
for older kernels with bpf_probe_read(), another with
bpf_probe_read_kernel()/bpf_probe_read_user(). That's a massive pain
in the butt. But newer libbpf versions provide a completely
transparent fallback from _user()/_kernel() variants to generic one,
if the kernel doesn't support new variants. So the instruction to
users becomes simple: always use
bpf_probe_read_user()/bpf_probe_read_kernel().

But with iproute2 not enforcing new enough versions of libbpf, all
that goes out of the window and puts the burden back on end users.

3. Another feature (and far from being the last of this kind in
libbpf) is a full support for individual *non-always-inlined*
functions in BPF code, which was added recently. This allows to
structure BPF code better, get better instruction cache use and for
newer kernels even get significant speed ups of BPF code verification.
This is purely a libbpf feature, no API was changed. Further, the
kernel understands the difference between global and static functions
in BPF code and optimizes verification, if possible. Libbpf takes care
of falling back to static functions for old kernels that are not yet
aware of global functions. All that is completely transparent and
works reliably without users having to deal with three variants of
doing helper functions in their BPF code.

And again, if, when using iproute2, the user doesn't know which
version of libbpf will be used, they have to assume the worst
(__always_inline) or maintain 2 or 3 different copies of their code.

And there are more conveniences like that significantly simplifying
BPF end users by hiding differences of kernel versions, clang
versions, etc.

Submodule is a way that I know of to make this better for end users.
If there are other ways to pull this off with shared library use, I'm
all for it, it will save the security angle that distros are arguing
for. E.g., if distributions will always have the latest libbpf
available almost as soon as it's cut upstream *and* new iproute2
versions enforce the latest libbpf when they are packaged/released,
then this might work equivalently for end users. If Linux distros
would be willing to do this faithfully and promptly, I have no
objections whatsoever. Because all that matters is BPF end user
experience, as Daniel explained above.

>
> IIUC you're saying that we cannot depend on libbpf updates from distro.

As I tried to explain above, a big part of libbpf is BPF loader,
which, while not changing the library API, does get more and advanced
features with newer versions. So yeah, you can totally use older
versions of libbpf, but you need to be aware of all the kernel + clang
+ BPF code features interactions, which newer libbpfs often
transparently alleviate for the user.

So if someone has some old BPF code not using anything fancy, they
might not care all that much, probably.


> Isn't that a pretty bad experience for all users who would like to link
> against it? There are 4 components (kernel, lib, tools, compiler) all
> need to be kept up to date for optimal user experience. Cutting corners
> with one of them leads nowhere medium term IMHO.
>
> Unless what you guys are saying is that libbpf is _not_ supposed to be
> backward compatible from the user side, and must be used a submodule.
> But then why bother defining ABI versions, or build it as an .so at all.

That's not what anyone is saying, I hope we established that in this
thread that libbpf does provide a stable API and ABI, with backwards
and forward compatibility. And takes it very seriously. User BPF
programs just tend to grow in complexity and features used and newer
libbpf versions are sometimes a requirement to utilize all that
effectively.

>
> I'm also confused by the testing argument. Surely the solution is to
> add unit / system tests for iproute2. Distros will rebuild packages
> when dependencies change and retest. If we have 0 tests doesn't matter
> what update strategy there is.

Tests are good, but I'm a bit sceptical about the surface area that
could be tested. Compiled BPF program (ELF file) is an input to BPF
loader APIs, and that compiled BPF program can be arbitrarily complex,
using a variety of different kernel/libbpf features. So a single
non-changing APIs accepts an infinite variety of inputs. selftests/bpf
mandate that each new kernel and libbpf feature gets a test, I'm
wondering if iproute2 test suite would be able to keep up with this.
And then again, some features are not supposed to work on older libbpf
versions, so not clear how iproute2 would test that. But regardless,
more testing is always better, so I hope this won't discourage testing
per se.
