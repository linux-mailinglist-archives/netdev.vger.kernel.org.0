Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869C2152224
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 22:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgBDV4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 16:56:54 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50112 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727445AbgBDV4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 16:56:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580853411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8O/eZZe8PGyK335axtITfTFIfbRMokQautgaGsOmlQ4=;
        b=VXMSD7EvbAwb6V42enqsVseBRG2hKe8vHiXvrdh1i8Q4a0++nKCsOJDg6DsIabK7g/ttfG
        l4SMIKpa7TJCWkJ2J7qdC3EAW1jixKzXgcBQSMHDgz/LIIOh+oX0ixpnGsxiZ0FpghrYUl
        uJJCiVjvmU6bwgYIm94XwWJQTsIZ5y0=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-PJqcWqS2OgOq8M1qi4eNKQ-1; Tue, 04 Feb 2020 16:56:49 -0500
X-MC-Unique: PJqcWqS2OgOq8M1qi4eNKQ-1
Received: by mail-lf1-f71.google.com with SMTP id t8so2773713lfc.21
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 13:56:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=8O/eZZe8PGyK335axtITfTFIfbRMokQautgaGsOmlQ4=;
        b=YY76XHfzZYtQ6HPG9oZ5r49CEGL0KDPK5gle2B327vCqp8iVVfh+gSCIV2IqiIyD1L
         jbiOoY2+rvj7gzYLammAwxSLs2AVEw5DKQ403yQFq6jwkHQDxmniRo1A3MnssvzF0MKR
         10EZkFnzdTjgbwV5iLZrWDMJCxKv6Xc0SR5Gzvg0kBV1sivD0w3AmJad4qVbQ3dkrwiE
         VcMtHVeO1nhfGe6WP7EIrmo9JrRfmTL/k3Z3MjDuw71nzfSsjEdLTXOzwUm6Zg2b737v
         HRhCko61N+O1Db78d7kKy88U+ZGAt/zpY38eorXsDZnmseOO0HwY6CMB9Cik1REwARpQ
         XPIQ==
X-Gm-Message-State: APjAAAWM33R+B4wBO5qeWPEAswCfa0X4TXWBVvcCe1VXie+63nteZhk8
        YsOXdw9uBzP3mt/HWrS5WTAbLjgP2lPl0zUvWZ0GqmzbNPig64MnReFfmUWOLSsBjJY6eNXp1Uz
        egIdgiu3JF3ECyMnm
X-Received: by 2002:a05:6512:284:: with SMTP id j4mr15990120lfp.109.1580853408073;
        Tue, 04 Feb 2020 13:56:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqzrMYzLQXeIV15QXc1SIY9iyrW3beyADgu+MCbnMkvmxYHZemj5TU5f0C0s8oEQ3SpE/LV1fg==
X-Received: by 2002:a05:6512:284:: with SMTP id j4mr15990104lfp.109.1580853407747;
        Tue, 04 Feb 2020 13:56:47 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r20sm11116715lfi.91.2020.02.04.13.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 13:56:46 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A11141802D4; Tue,  4 Feb 2020 22:56:45 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
In-Reply-To: <CAEf4BzbNZQmDD3Ob+m6yJK2CzNb9=3F2bYfxOUyn7uOp0bhXZA@mail.gmail.com>
References: <20190820114706.18546-1-toke@redhat.com>
 <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com>
 <87blwiqlc8.fsf@toke.dk>
 <CAEf4BzYMKPbfOu4a4UDEfJVcNW1-KvRwJ7PVo+Mf_1YUJgE4Qw@mail.gmail.com>
 <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net>
 <CAEf4Bzab_w0AXy5P9mG14mcyJVgUCzuuNda5FpU5wSEwUciGfg@mail.gmail.com>
 <87tva8m85t.fsf@toke.dk>
 <CAEf4BzbzQwLn87G046ZbkLtTbY6WF6o8JkygcPLPGUSezgs9Tw@mail.gmail.com>
 <CAEf4BzZOAukJZzo4J5q3F2v4MswQ6nJh6G1_c0H0fOJCdc7t0A@mail.gmail.com>
 <87blqfcvnf.fsf@toke.dk>
 <CAEf4Bza4bSAzjFp2WDiPAM7hbKcKgAX4A8_TUN8V38gXV9GbTg@mail.gmail.com>
 <0bf50b22-a8e2-e3b3-aa53-7bd5dd5d4399@gmail.com>
 <CAEf4Bzbzz3s0bSF_CkP56NTDd+WBLAy0QrMvreShubetahuH0g@mail.gmail.com>
 <2cf136a4-7f0e-f4b7-1ecb-6cbf6cb6c8ff@gmail.com>
 <CAEf4Bzb1fXdGFz7BkrQF7uMhBD1F-K_kudhLR5wC-+kA7PMqnA@mail.gmail.com>
 <87h80669o6.fsf@toke.dk>
 <CAEf4BzYGp95MKjBxNay2w=9RhFAEUCrZ8_y1pqzdG-fUyY63=w@mail.gmail.com>
 <8736bqf9dw.fsf@toke.dk>
 <CAEf4BzbNZQmDD3Ob+m6yJK2CzNb9=3F2bYfxOUyn7uOp0bhXZA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 04 Feb 2020 22:56:45 +0100
Message-ID: <87tv46dnj6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Feb 4, 2020 at 11:19 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Tue, Feb 4, 2020 at 12:25 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>> >>
>> >> > On Mon, Feb 3, 2020 at 8:53 PM David Ahern <dsahern@gmail.com> wrot=
e:
>> >> >>
>> >> >> On 2/3/20 8:41 PM, Andrii Nakryiko wrote:
>> >> >> > On Mon, Feb 3, 2020 at 5:46 PM David Ahern <dsahern@gmail.com> w=
rote:
>> >> >> >>
>> >> >> >> On 2/3/20 5:56 PM, Andrii Nakryiko wrote:
>> >> >> >>> Great! Just to disambiguate and make sure we are in agreement,=
 my hope
>> >> >> >>> here is that iproute2 can completely delegate to libbpf all th=
e ELF
>> >> >> >>>
>> >> >> >>
>> >> >> >> iproute2 needs to compile and continue working as is when libbp=
f is not
>> >> >> >> available. e.g., add check in configure to define HAVE_LIBBPF a=
nd move
>> >> >> >> the existing code and move under else branch.
>> >> >> >
>> >> >> > Wouldn't it be better to statically compile against libbpf in th=
is
>> >> >> > case and get rid a lot of BPF-related code and simplify the rest=
 of
>> >> >> > it? This can be easily done by using libbpf through submodule, t=
he
>> >> >> > same way as BCC and pahole do it.
>> >> >> >
>> >> >>
>> >> >> iproute2 compiles today and runs on older distributions and older
>> >> >> distributions with newer kernels. That needs to hold true after th=
e move
>> >> >> to libbpf.
>> >> >
>> >> > And by statically compiling against libbpf, checked out as a
>> >> > submodule, that will still hold true, wouldn't it? Or there is some
>> >> > complications I'm missing? Libbpf is designed to handle old kernels
>> >> > with no problems.
>> >>
>> >> My plan was to use the same configure test I'm using for xdp-tools
>> >> (where I in turn copied the structure of the configure script from
>> >> iproute2):
>> >>
>> >> https://github.com/xdp-project/xdp-tools/blob/master/configure#L59
>> >>
>> >> This will look for a system libbpf install and compile against it if =
it
>> >> is compatible, and otherwise fall back to a statically linking agains=
t a
>> >> git submodule.
>> >
>> > How will this work when build host has libbpf installed, but target
>> > host doesn't? You'll get dynamic linker error when trying to run that
>> > tool.
>>
>> That's called dependency tracking; distros have various ways of going
>> about that :)
>
> I'm confused, honestly. libbpf is either a dependency and thus can be
> relied upon to be present in the target system, or it's not and this
> whole dance with detecting libbpf presence needs to be performed.

Yes, and iproute2 is likely to be built in both sorts of environments,
so we will have to support both :)

> If libbpf is optional, then I don't see how iproute2 BPF-related code
> and complexity can be reduced at all, given it should still support
> loading BPF programs even without libbpf. Furthermore, given libbpf
> supports more features already and will probably be outpacing
> iproute2's own BPF support in the future, some users will start
> relying on BPF features supported only by libbpf "backend", so
> iproute2's own BPF backend will just fail to load such programs,
> bringing unpleasant surprises, potentially. So I still fail to see how
> libbpf can be optional and what benefit does that bring.

I wasn't saying that libbpf itself should be optional; if we're porting
things, we should rip out as much of the old code as we can. I just
meant that we should support both modes of building, so distros that
*do* build libbpf as a library can link iproute2 against that with as
little friction as possible.

I'm dead set on a specific auto-detection semantic either; I guess it'll
be up to the iproute2 maintainers whether they prefer defaulting to one
or the other.

> But shared or static - whatever fits iproute2 best, no preferences.

Right, cool, I think we are basically agreed, given the above :)

-Toke

