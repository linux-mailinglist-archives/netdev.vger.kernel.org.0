Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB5B34CD6F
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 11:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhC2J52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 05:57:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40417 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231985AbhC2J5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 05:57:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617011821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xiWJV3ko1190mDpLoLQdBpnnHOr0EFaCU4Guy+26tGU=;
        b=AdWR3App76xedyVwMaWtX3fRx5lJ4G9gsjlR3g9YaKWFTBh2EzOxEq8PyvFcYsY3wPvjUb
        Ug3HRNK5L8rkBLEo8zyTEqgeto4ZyVw1VvQmHhJaTfyXrp9eUfEJTmG2mZDtmh8Qv9HgFd
        Hjt/RnauqKF5EgT2/WDh8udSPhzKCOo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-HlXr17crOKKtFZQdY4BduA-1; Mon, 29 Mar 2021 05:56:58 -0400
X-MC-Unique: HlXr17crOKKtFZQdY4BduA-1
Received: by mail-ed1-f71.google.com with SMTP id i19so8394820edy.18
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 02:56:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xiWJV3ko1190mDpLoLQdBpnnHOr0EFaCU4Guy+26tGU=;
        b=gmWhUXFh3iFj//5+OKbeJDDd4Bvx8OR9tAOAzPpdnqjNyUJRqAUCiQ+y8luhpKAh56
         t065HVsrXP0LxROZFqfpslpIugsc7UdD0APKs299AIvjVCwmqrE11UKZlGFhbljt1Dxb
         dxq23LenNdWpB0JIZqSYbHfWQPWWQkfUBfyyBMiS80764rCyYqtThoPaumdkX8t9V1QB
         sDpTlkb1DCmrkaSwbIBXAQ7SiF55gOzoIZ38mpwe2kGM9x3g2/XqMyFvMBsdL5bc6Tnk
         6676BYIAoCQg+toBv2wS66gEszJtloqZyvTQSkrfz64VoK4uyIVpMuM6nomcFJtIy3Im
         O4Qw==
X-Gm-Message-State: AOAM532OoGkUrtgfqfRzxGFivgs2afMPF5khRXFmZKg769p2GKi5wRsG
        fxQNOsoo2ABWZYQb19z4VTSdJZ4joVLnAbFVp/6Z9jfdxs4cHKXQcICFOZSeMFX0Gu+56xbcvFk
        5+4INF2VVh8IjH9fm
X-Received: by 2002:a50:ed83:: with SMTP id h3mr28469763edr.140.1617011817508;
        Mon, 29 Mar 2021 02:56:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDlRH4ZFa+9wQzQgxfAWLizNcm57g67QjLhEohcKPFUr4Hm2YCdzaKDDcmOWBKfZRfKGZWFQ==
X-Received: by 2002:a50:ed83:: with SMTP id h3mr28469745edr.140.1617011817342;
        Mon, 29 Mar 2021 02:56:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id de17sm7894616ejc.16.2021.03.29.02.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 02:56:56 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3E766180293; Mon, 29 Mar 2021 11:56:55 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next 5/5] libbpf: add selftests for TC-BPF API
In-Reply-To: <20210329014044.fkmusoeaqs2hjiek@ast-mbp>
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-6-memxor@gmail.com>
 <20210327021534.pjfjctcdczj7facs@ast-mbp>
 <CAEf4Bzba_gdTvak_UHqi96-w6GLF5JQcpQRcG7zxnx=kY8Sd5w@mail.gmail.com>
 <20210329014044.fkmusoeaqs2hjiek@ast-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 29 Mar 2021 11:56:55 +0200
Message-ID: <87r1jyth94.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Sat, Mar 27, 2021 at 09:32:58PM -0700, Andrii Nakryiko wrote:
>> > I think it's better to start with new library for tc/xdp and have
>> > libbpf as a dependency on that new lib.
>> > For example we can add it as subdir in tools/lib/bpf/.
>> >
>> > Similarly I think integerating static linking into libbpf was a mistake.
>> > It should be a sub library as well.
>> >
>> > If we end up with core libbpf and ten sublibs for tc, xdp, af_xdp, linking,
>> > whatever else the users would appreciate that we don't shove single libbpf
>> > to them with a ton of features that they might never use.
>> 
>> What's the concern exactly? The size of the library? Having 10
>> micro-libraries has its own set of downsides, 
>
> specifically?
>
>> I'm not convinced that's
>> a better situation for end users. And would certainly cause more
>> hassle for libbpf developers and packagers.
>
> For developers and packagers.. yes.
> For users.. quite the opposite.
> The skel gen and static linking must be split out before the next libbpf release.
> Not a single application linked with libbpf is going to use those pieces.

I'd tend to agree about the skeleton generation, but I have one use case
in mind where having the linker in library form would be handy:
dynamically building an XDP program at load time from pre-compiled
pieces.

Consider xdp-filter[0]: it's a simplistic packet filter that can filter
on different bits of the packet header, mostly meant as a demonstration
of XDP packet filtering performance. It's also using conditional
compilation so that it can be loaded in a mode that skips parsing L4
headers entirely if port-based filtering is not enabled. Right now we do
that by pre-compiling five different variants of the XDP program and
loading based on the selected feature set, but with linking in libbpf,
we could instead have a single BPF program with granular filtering
functions and just assemble the final program from those bits at load
time.

The actual xdp-filter program may be too simplistic to gain any
performance for this, but I believe the general approach could be a way
to realise the "improved performance through skipping code" promise of
an XDP-based data path. Having linking be part of libbpf will make this
straight-forward to integrate into applications.

[0] https://github.com/xdp-project/xdp-tools/tree/master/xdp-filter

> bpftool is one and only that needs them. Hence forcing libbpf users
> to increase their .text with a dead code is a selfish call of libbpf
> developers and packagers. The user's priorities must come first.
>
>> And what did you include in "core libbpf"?
>
> I would take this opportunity to split libbpf into maintainable pieces:
> - libsysbpf - sys_bpf wrappers (pretty much tools/lib/bpf/bpf.c)
> - libbpfutil - hash, strset
> - libbtf - BTF read/write
> - libbpfelf - ELF parsing, CORE, ksym, kconfig
> - libbpfskel - skeleton gen used by bpftool only
> - libbpflink - linker used by bpftool only
> - libbpfnet - networking attachment via netlink including TC and XDP
> - libbpftrace - perfbuf, ringbuf
> - libxdp - Toke's xdp chaining
> - libxsk - af_xdp logic

Huh? You've got to be joking? How is that going to improve things for
users? Just the cognitive load of figuring out which linker flags to use
is going to be prohibitive. Not to mention the hassle of keeping
multiple library versions in sync etc.

If the concern is .text size, surely there are better ways to fix that?
LTO is the obvious "automagic" solution, but even without that, just
supporting conditional compilation via defines in the existing libbpf
ought to achieve the same thing without exposing the gory details to the
users?

-Toke

