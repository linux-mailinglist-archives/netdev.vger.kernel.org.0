Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C634F152112
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 20:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbgBDT3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 14:29:37 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35268 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbgBDT3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 14:29:37 -0500
Received: by mail-qk1-f193.google.com with SMTP id q15so19218828qki.2;
        Tue, 04 Feb 2020 11:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tOcsRdIEVJsPfVc56q5aRcXI2fzaKKYcxclrcw+3oeE=;
        b=vg0otN3cZcnUQTTwSGvqjKUMjITfaUhtKEcEnoUpgzzMGFJZjZ4f9x67GwxmA/kg+B
         6h9pHvNNHjc8WwHzZlNZ0Z3a6Zoz4TMZ/Wx1imMIEmU9Yqmv2eaQQuiqn6m8Z5yeZo4U
         l4mk6qodX9tkBsrBeMDQlgwSPEU1/nczNV5JcZOnuIfbbUoj1cDrANkt7TppOIADt6Z4
         Fk0hiZmH3TKVR7cKqc2lM15LDqCLTg4WMxetm3tVI9Y5+0J93/PAEUiaoYlWFNXH82K/
         G9Z+UqXcGsl0b6rR9vIt9eSnSU0vjLFNcowfZdiIsTMIoUrPIdYAaWEFdkwTZJzxPlJh
         tSDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tOcsRdIEVJsPfVc56q5aRcXI2fzaKKYcxclrcw+3oeE=;
        b=PTVfmD63091FClwILH9/Qo2PhtbRucIfXqXcve7KC6c1InD8rgIHTPqQpp1JVkj2Iu
         G8w5TqLKCnLwpF/Ya8VBk0sP6CzY8Ho6iisrgPWLTgyE3tjFcnIp4OEFlgyMtlBDJZqI
         oIb9diK2LA5ik8ubF0ehDkKsiXFqFg3J5BsUtg2QvmGZkRK20cj7FJVwtIbxTCUhZ4ue
         FieSpsZm2thom9pAXikIEQVhnhwsJshsziOIHXhqt67Rc+KEF1wvemVXgagvE3Ucc9ww
         G17+klsKp+if0kvOfhaj94FqynaokEStLqBHHJFxh0j7eAP5ODWEJeSCQ6QiC2klSRTl
         VMzw==
X-Gm-Message-State: APjAAAVfE64IXTvxTjBnBCma+ZL3ub6GL4NI1kSLeaLILfp79R+0b/OX
        Sf5FipW2MPVsjzUiRtuP9TvUuASot9urvcSQDalKkA==
X-Google-Smtp-Source: APXvYqwOcUHhL46at5qd10bWRMIsbEqCYzIHPtn14urSccE0iVQzvY2AA7pxxdzYDhNHGDb0/P+YOYeB4Uxh2FQuwXQ=
X-Received: by 2002:a05:620a:14a2:: with SMTP id x2mr30600959qkj.36.1580844575676;
 Tue, 04 Feb 2020 11:29:35 -0800 (PST)
MIME-Version: 1.0
References: <20190820114706.18546-1-toke@redhat.com> <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
 <87blwiqlc8.fsf@toke.dk> <CAEf4BzYMKPbfOu4a4UDEfJVcNW1-KvRwJ7PVo+Mf_1YUJgE4Qw@mail.gmail.com>
 <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net> <CAEf4Bzab_w0AXy5P9mG14mcyJVgUCzuuNda5FpU5wSEwUciGfg@mail.gmail.com>
 <87tva8m85t.fsf@toke.dk> <CAEf4BzbzQwLn87G046ZbkLtTbY6WF6o8JkygcPLPGUSezgs9Tw@mail.gmail.com>
 <CAEf4BzZOAukJZzo4J5q3F2v4MswQ6nJh6G1_c0H0fOJCdc7t0A@mail.gmail.com>
 <87blqfcvnf.fsf@toke.dk> <CAEf4Bza4bSAzjFp2WDiPAM7hbKcKgAX4A8_TUN8V38gXV9GbTg@mail.gmail.com>
 <0bf50b22-a8e2-e3b3-aa53-7bd5dd5d4399@gmail.com> <CAEf4Bzbzz3s0bSF_CkP56NTDd+WBLAy0QrMvreShubetahuH0g@mail.gmail.com>
 <2cf136a4-7f0e-f4b7-1ecb-6cbf6cb6c8ff@gmail.com> <CAEf4Bzb1fXdGFz7BkrQF7uMhBD1F-K_kudhLR5wC-+kA7PMqnA@mail.gmail.com>
 <87h80669o6.fsf@toke.dk> <CAEf4BzYGp95MKjBxNay2w=9RhFAEUCrZ8_y1pqzdG-fUyY63=w@mail.gmail.com>
 <8736bqf9dw.fsf@toke.dk>
In-Reply-To: <8736bqf9dw.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Feb 2020 11:29:24 -0800
Message-ID: <CAEf4BzbNZQmDD3Ob+m6yJK2CzNb9=3F2bYfxOUyn7uOp0bhXZA@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 4, 2020 at 11:19 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Tue, Feb 4, 2020 at 12:25 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Mon, Feb 3, 2020 at 8:53 PM David Ahern <dsahern@gmail.com> wrote=
:
> >> >>
> >> >> On 2/3/20 8:41 PM, Andrii Nakryiko wrote:
> >> >> > On Mon, Feb 3, 2020 at 5:46 PM David Ahern <dsahern@gmail.com> wr=
ote:
> >> >> >>
> >> >> >> On 2/3/20 5:56 PM, Andrii Nakryiko wrote:
> >> >> >>> Great! Just to disambiguate and make sure we are in agreement, =
my hope
> >> >> >>> here is that iproute2 can completely delegate to libbpf all the=
 ELF
> >> >> >>>
> >> >> >>
> >> >> >> iproute2 needs to compile and continue working as is when libbpf=
 is not
> >> >> >> available. e.g., add check in configure to define HAVE_LIBBPF an=
d move
> >> >> >> the existing code and move under else branch.
> >> >> >
> >> >> > Wouldn't it be better to statically compile against libbpf in thi=
s
> >> >> > case and get rid a lot of BPF-related code and simplify the rest =
of
> >> >> > it? This can be easily done by using libbpf through submodule, th=
e
> >> >> > same way as BCC and pahole do it.
> >> >> >
> >> >>
> >> >> iproute2 compiles today and runs on older distributions and older
> >> >> distributions with newer kernels. That needs to hold true after the=
 move
> >> >> to libbpf.
> >> >
> >> > And by statically compiling against libbpf, checked out as a
> >> > submodule, that will still hold true, wouldn't it? Or there is some
> >> > complications I'm missing? Libbpf is designed to handle old kernels
> >> > with no problems.
> >>
> >> My plan was to use the same configure test I'm using for xdp-tools
> >> (where I in turn copied the structure of the configure script from
> >> iproute2):
> >>
> >> https://github.com/xdp-project/xdp-tools/blob/master/configure#L59
> >>
> >> This will look for a system libbpf install and compile against it if i=
t
> >> is compatible, and otherwise fall back to a statically linking against=
 a
> >> git submodule.
> >
> > How will this work when build host has libbpf installed, but target
> > host doesn't? You'll get dynamic linker error when trying to run that
> > tool.
>
> That's called dependency tracking; distros have various ways of going
> about that :)

I'm confused, honestly. libbpf is either a dependency and thus can be
relied upon to be present in the target system, or it's not and this
whole dance with detecting libbpf presence needs to be performed.

If libbpf is optional, then I don't see how iproute2 BPF-related code
and complexity can be reduced at all, given it should still support
loading BPF programs even without libbpf. Furthermore, given libbpf
supports more features already and will probably be outpacing
iproute2's own BPF support in the future, some users will start
relying on BPF features supported only by libbpf "backend", so
iproute2's own BPF backend will just fail to load such programs,
bringing unpleasant surprises, potentially. So I still fail to see how
libbpf can be optional and what benefit does that bring. But shared or
static - whatever fits iproute2 best, no preferences.

>
> But yeah, if you're going to do you own cross-compilation, you'd
> probably want to just force using the static library.
>
> > If the goal is to have a reliable tool working everywhere, and you
> > already support having libbpf as a submodule, why not always use
> > submodule's libbpf? What's the concern? Libbpf is a small library, I
> > don't think a binary size argument is enough reason to not do this. On
> > the other hand, by using libbpf from submodule, your tool is built
> > *and tested* with a well-known libbpf version that tool-producer
> > controls.
>
> I thought we already had this discussion? :)

Yeah, I guess we did for bpftool :) No worries, I don't care that
much, just see my notes above about optional libbpf and consequences.

>
> libbpf is a library like any other. Distros that package the library
> want the tools that use it to be dynamically linked against it so
> library upgrades (especially of the CVE-fixing kind) get picked up by
> all users. Other distros have memory and space constraints (iproute2 is
> shipped on OpenWrt, for instance, which is *extremely*
> space-constrained). And yeah, other deployments don't care and will just
> statically compile in the vendored version. So we'll need to support all
> of those use cases.
>
> -Toke
>
