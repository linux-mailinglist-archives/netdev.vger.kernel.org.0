Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB4115226A
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 23:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbgBDWgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 17:36:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48628 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727566AbgBDWgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 17:36:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580855762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=91H5L2djq4cY/CxD9PLzpaU/UvTDWosSJU3+3v+fWOc=;
        b=eQ3y4QkvXCYMCXGOjD3IK9u79jZRKl77HZrSXM2emnGVrBbmQnjmrTc7H8hbN+BMdv5L1b
        Af4c8uTbFLahyOKS0QuMIiV3EmrgcVQa+6qiYVVEvtzeTnzHOfW8+Ef964p99tc3yaOhoc
        xMX/KsWH37fqQ5zwijtB3Uxufp+K4IY=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-QMiLlQhzN0eVGh1LAHSvGg-1; Tue, 04 Feb 2020 17:35:59 -0500
X-MC-Unique: QMiLlQhzN0eVGh1LAHSvGg-1
Received: by mail-lf1-f69.google.com with SMTP id k26so2805669lfm.0
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 14:35:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=91H5L2djq4cY/CxD9PLzpaU/UvTDWosSJU3+3v+fWOc=;
        b=WD/4hmsAk5ql+2cYlwxTfAgbbgIAJk2LSmy/vfLXgQnr3c5De7wrwpHmni1kZVEpM6
         toRhN+hL4qWmc+85yD5z/VgmcJd9TNJMaQ6EMOfgbzvENWyzJ/JMClIC0+Vx44MYjVsX
         qqXCgyte2Bbg7Xlajvt5IWftnnwPMTGW8imxUtZqpMXxMCjicUEANOCahnJi1MjXn2R9
         eZGGNHKi1rRPMv6ASC13fjF34mY/e/zNrvMV7sA+M3ejsmj1l7jVyvkaLZ6gPz0B6fqm
         NoL7wQbATKWQLWAxUZM+upYIVDF9UswyJjEJQLpIrU/rX8rhOYGD/XJTyPdMvCiv/6bC
         XoPA==
X-Gm-Message-State: APjAAAWpCgBepT8rNKRShISMXYbbJrNnWcD9FqBfbhkLKK9kgr2YReRr
        qrXPBw4kkaFxrDPmcnNiHB+w2rnJHenpa5aVJ9W2xG6vfi0ZMJCH9qfFR8RuBoaYNc2XOJPT8h7
        ZADOKahuAy3blM6Zp
X-Received: by 2002:ac2:53b3:: with SMTP id j19mr16365708lfh.127.1580855757931;
        Tue, 04 Feb 2020 14:35:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqwWgQ6rz/WgD5IC/CxsvdMfTac7MB9kg8eeaqTJns5OYk7k9dzNIncSVn3x4PWF8HHrkXqIxw==
X-Received: by 2002:ac2:53b3:: with SMTP id j19mr16365696lfh.127.1580855757698;
        Tue, 04 Feb 2020 14:35:57 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v16sm11179032lfp.92.2020.02.04.14.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 14:35:56 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 01DCF1802D4; Tue,  4 Feb 2020 23:35:54 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
In-Reply-To: <2ab65028-c200-f8f8-b57d-904cb8a7c00c@gmail.com>
References: <20190820114706.18546-1-toke@redhat.com>
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
 <87tv46dnj6.fsf@toke.dk> <2ab65028-c200-f8f8-b57d-904cb8a7c00c@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 04 Feb 2020 23:35:54 +0100
Message-ID: <87r1zadlpx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 2/4/20 2:56 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>> I'm confused, honestly. libbpf is either a dependency and thus can be
>>> relied upon to be present in the target system, or it's not and this
>>> whole dance with detecting libbpf presence needs to be performed.
>>=20
>> Yes, and iproute2 is likely to be built in both sorts of environments,
>> so we will have to support both :)
>>=20
>>> If libbpf is optional, then I don't see how iproute2 BPF-related code
>>> and complexity can be reduced at all, given it should still support
>>> loading BPF programs even without libbpf. Furthermore, given libbpf
>>> supports more features already and will probably be outpacing
>>> iproute2's own BPF support in the future, some users will start
>>> relying on BPF features supported only by libbpf "backend", so
>>> iproute2's own BPF backend will just fail to load such programs,
>>> bringing unpleasant surprises, potentially. So I still fail to see how
>>> libbpf can be optional and what benefit does that bring.
>>=20
>> I wasn't saying that libbpf itself should be optional; if we're porting
>> things, we should rip out as much of the old code as we can. I just
>> meant that we should support both modes of building, so distros that
>> *do* build libbpf as a library can link iproute2 against that with as
>> little friction as possible.
>>=20
>> I'm dead set on a specific auto-detection semantic either; I guess it'll
>> be up to the iproute2 maintainers whether they prefer defaulting to one
>> or the other.
>>=20
>
> A few concerns from my perspective:
>
> 1. Right now ip comes in around 650k unstripped; libbpf.a for 0.0.7 is
> around 1.2M with the size of libbpf.o > than ip.

Hmm, I'm getting ~700k for libbpf.a and libbpf.so.0.0.7 is ~480k (for
whichever kernel I currently have checked out). But lib/bpf.o in
iproute2 is only 80k, so fair point :)

> Most likely, making iproute2 use libbpf statically is going to be
> challenging and I am not sure it is the right thing to do (unless the
> user is building a static version of iproute2 commands).

Linking dynamically would imply a new dependency. I'm not necessarily
against that, but would it be acceptable from your PoV? And if so,
should we keep the current internal BPF code for when libbpf is not
available, or would it be acceptable to not be able to load BPF programs
if libbpf is not present (similar to how the libelf dependency works
today)?

> 2. git submodules can be a PITA to deal with (e.g., jumping between
> branches and versions), so there needs to be a good reason for it.

Yes, totally with you on that. Another option could be to just copy the
files into the iproute2 tree, and update them the same way the kernel
headers are? Or maybe doing fancy things like this:
https://github.com/apenwarr/git-subtrac

> 3. iproute2 code needs to build for a wide range of OSes and not lose
> functionality compared to what it has today.

Could you be a bit more specific about "a wide range of OSes"? I guess
we could do the work to make sure libbpf builds on all the same
platforms iproute2 supports, but we'd need something a bit more definite
to go on...

-Toke

