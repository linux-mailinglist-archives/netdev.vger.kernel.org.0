Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F2B1520F0
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 20:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbgBDTTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 14:19:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21623 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727369AbgBDTTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 14:19:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580843972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k0pjhqQ38lLEsOHy4AcSgtj8v6zTX3VHqcHQyJnlSjY=;
        b=EDbHNmG9ar1hS4xlFZ9ugxBuZ1PKELpVMEXSiz56JJrSjC8fJibtge0Sf1PWQ3n3X67YL4
        e8u39MapBVUU08rvWiTpXfMlWseTZBe5eIQOSXMMiLqhaVp94XAhalqjCCREtZEEd1aNn3
        8CHIe44AoHxIqw38l2o2alpcfilnPHY=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-AMVEi87CM-e90IbWEC24pg-1; Tue, 04 Feb 2020 14:19:28 -0500
X-MC-Unique: AMVEi87CM-e90IbWEC24pg-1
Received: by mail-lf1-f71.google.com with SMTP id z3so2642790lfq.22
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 11:19:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=k0pjhqQ38lLEsOHy4AcSgtj8v6zTX3VHqcHQyJnlSjY=;
        b=X8jTm72ZdRbeMmQtz8fr100v2j2Je0Nr846tm+/CInlWwyZZ9+sSTVbPC+63PB96DB
         /lQHX3v74wp/e786TxeFK6GmNiP1dyE7w5CfPpB389So3gqH6ouugnZ40EHp1SRrQwTy
         Ksyhr5Ldkg3P1cJrC2eDPKG/ATNH5x+juHI6iT0NWWrc+UQLKJ26A4cLJL3loVePLDIX
         rOtPmpdP6/fJmwvvbVaJ+SHhwoz8i9C/B+xz+rLi1/f6oF1tdi80Lxli7XG1kzCQOJ5V
         vhmtHjSEuR8vx+Z+PW45AHO1bNgjjB3J0rAoZBOeaj4++ySMYvJOK0NarCbiwxWUEDpK
         Dvmw==
X-Gm-Message-State: APjAAAXd5rKD1U6hi7FbE/KqdnTTijQDOhZSNABjpW/BpxBjPz2MZgX4
        Y5ZFGhHFNyEfSVICZuaO9m2AuWUm3Ynju2gB7U0BuQSeux1PkGcsIsw0thhHNdsvEBFiLGqpHeU
        ufrTdGr1xtqgyAce9
X-Received: by 2002:a2e:a404:: with SMTP id p4mr18722649ljn.234.1580843967224;
        Tue, 04 Feb 2020 11:19:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqzjvtMf2bfhzg268ZEIuVd0j8Vz7vTbbgj1be3aFsRivKNgBMLzW1BZjWry/ZTV+Ze1XTav7A==
X-Received: by 2002:a2e:a404:: with SMTP id p4mr18722636ljn.234.1580843966957;
        Tue, 04 Feb 2020 11:19:26 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t1sm12167127lji.98.2020.02.04.11.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 11:19:26 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 60B0D1802D4; Tue,  4 Feb 2020 20:19:23 +0100 (CET)
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
In-Reply-To: <CAEf4BzYGp95MKjBxNay2w=9RhFAEUCrZ8_y1pqzdG-fUyY63=w@mail.gmail.com>
References: <20190820114706.18546-1-toke@redhat.com> <CAEf4BzZxb7qZabw6aDVaTqnhr3AGtwEo+DbuBR9U9tJr+qVuyg@mail.gmail.com> <87blwiqlc8.fsf@toke.dk> <CAEf4BzYMKPbfOu4a4UDEfJVcNW1-KvRwJ7PVo+Mf_1YUJgE4Qw@mail.gmail.com> <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net> <CAEf4Bzab_w0AXy5P9mG14mcyJVgUCzuuNda5FpU5wSEwUciGfg@mail.gmail.com> <87tva8m85t.fsf@toke.dk> <CAEf4BzbzQwLn87G046ZbkLtTbY6WF6o8JkygcPLPGUSezgs9Tw@mail.gmail.com> <CAEf4BzZOAukJZzo4J5q3F2v4MswQ6nJh6G1_c0H0fOJCdc7t0A@mail.gmail.com> <87blqfcvnf.fsf@toke.dk> <CAEf4Bza4bSAzjFp2WDiPAM7hbKcKgAX4A8_TUN8V38gXV9GbTg@mail.gmail.com> <0bf50b22-a8e2-e3b3-aa53-7bd5dd5d4399@gmail.com> <CAEf4Bzbzz3s0bSF_CkP56NTDd+WBLAy0QrMvreShubetahuH0g@mail.gmail.com> <2cf136a4-7f0e-f4b7-1ecb-6cbf6cb6c8ff@gmail.com> <CAEf4Bzb1fXdGFz7BkrQF7uMhBD1F-K_kudhLR5wC-+kA7PMqnA@mail.gmail.com> <87h80669o6.fsf@toke.dk> <CAEf4BzYGp95MKjBxNay2w=9RhFAEUCrZ8_y1pqzdG-fUyY63=w@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 04 Feb 2020 20:19:23 +0100
Message-ID: <8736bqf9dw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Feb 4, 2020 at 12:25 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Mon, Feb 3, 2020 at 8:53 PM David Ahern <dsahern@gmail.com> wrote:
>> >>
>> >> On 2/3/20 8:41 PM, Andrii Nakryiko wrote:
>> >> > On Mon, Feb 3, 2020 at 5:46 PM David Ahern <dsahern@gmail.com> wrot=
e:
>> >> >>
>> >> >> On 2/3/20 5:56 PM, Andrii Nakryiko wrote:
>> >> >>> Great! Just to disambiguate and make sure we are in agreement, my=
 hope
>> >> >>> here is that iproute2 can completely delegate to libbpf all the E=
LF
>> >> >>>
>> >> >>
>> >> >> iproute2 needs to compile and continue working as is when libbpf i=
s not
>> >> >> available. e.g., add check in configure to define HAVE_LIBBPF and =
move
>> >> >> the existing code and move under else branch.
>> >> >
>> >> > Wouldn't it be better to statically compile against libbpf in this
>> >> > case and get rid a lot of BPF-related code and simplify the rest of
>> >> > it? This can be easily done by using libbpf through submodule, the
>> >> > same way as BCC and pahole do it.
>> >> >
>> >>
>> >> iproute2 compiles today and runs on older distributions and older
>> >> distributions with newer kernels. That needs to hold true after the m=
ove
>> >> to libbpf.
>> >
>> > And by statically compiling against libbpf, checked out as a
>> > submodule, that will still hold true, wouldn't it? Or there is some
>> > complications I'm missing? Libbpf is designed to handle old kernels
>> > with no problems.
>>
>> My plan was to use the same configure test I'm using for xdp-tools
>> (where I in turn copied the structure of the configure script from
>> iproute2):
>>
>> https://github.com/xdp-project/xdp-tools/blob/master/configure#L59
>>
>> This will look for a system libbpf install and compile against it if it
>> is compatible, and otherwise fall back to a statically linking against a
>> git submodule.
>
> How will this work when build host has libbpf installed, but target
> host doesn't? You'll get dynamic linker error when trying to run that
> tool.

That's called dependency tracking; distros have various ways of going
about that :)

But yeah, if you're going to do you own cross-compilation, you'd
probably want to just force using the static library.

> If the goal is to have a reliable tool working everywhere, and you
> already support having libbpf as a submodule, why not always use
> submodule's libbpf? What's the concern? Libbpf is a small library, I
> don't think a binary size argument is enough reason to not do this. On
> the other hand, by using libbpf from submodule, your tool is built
> *and tested* with a well-known libbpf version that tool-producer
> controls.

I thought we already had this discussion? :)

libbpf is a library like any other. Distros that package the library
want the tools that use it to be dynamically linked against it so
library upgrades (especially of the CVE-fixing kind) get picked up by
all users. Other distros have memory and space constraints (iproute2 is
shipped on OpenWrt, for instance, which is *extremely*
space-constrained). And yeah, other deployments don't care and will just
statically compile in the vendored version. So we'll need to support all
of those use cases.

-Toke

