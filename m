Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 489641962EC
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 02:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgC1Bn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 21:43:26 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:41884 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726225AbgC1BnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 21:43:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585359803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lyh+pXYC32MopAVStom0u//t9MIlgqBkcZqGQa9uKbE=;
        b=LphEn616gcjyWgIXIE+v9yDQwc+FsPixyI8Hq2BKjjoeDkHuAgb1h7ga0qVCyrCboGL6ZQ
        ONCzm3eCbo+DJHxjPggf0m5YEy9482LBCNC7LElWwEkwOzhHPv1L9O4xtFpOP4NbA/7ss/
        2vqq+Dr418YqMp+niUSF0vLqXfWHskI=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-oioa1utYNEqOObCpq3xWZw-1; Fri, 27 Mar 2020 21:43:21 -0400
X-MC-Unique: oioa1utYNEqOObCpq3xWZw-1
Received: by mail-lf1-f70.google.com with SMTP id j3so4570701lfe.10
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 18:43:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Lyh+pXYC32MopAVStom0u//t9MIlgqBkcZqGQa9uKbE=;
        b=H9xQGBaJpyYUpHXKz9Q2AFQ5PkNN745lNsd2H1rSUSLk0XAuzFr9loekB6g3Adi2zd
         iSLrYcB5iO27yBQdeVRsb0bZMHaIMPwaxqnfeiSXjC26GfaOP5rk/ZpOP9wDI+TvwwfC
         zDOwn86aaUDOF/HJub9wqqLysbhk/J2bi7KFHNPbLNg8KPjUgFrtZl6Iml6y1YywEg+D
         ym7aQRokM6MkrDsoFzcZvr+n6dcvJU8lzL2Gvk5CU+nDJI/t+ALXKClvHWXGVZDSrf7a
         2KImO2NX5hWG0qCjOapdCtfUXUuV32co7Tiw8u/SeeWxre6Xeo6rv2AlIbjTlkdpnat3
         AAoA==
X-Gm-Message-State: AGi0PuZFsE8nMqfP3J9ZgJyNe1B2MzBcAAAj1bWPV/OUOwBw7ZBFKiXR
        5HCBmuOGi354WxUf5W3ybKaOo/jgP5eqFHv+wF6wEiVgnkXp9iW8wrMZmHyzktBRbqb9dFZc/Tk
        bVftM7acq6m3LKRnS
X-Received: by 2002:a2e:814f:: with SMTP id t15mr972765ljg.96.1585359800093;
        Fri, 27 Mar 2020 18:43:20 -0700 (PDT)
X-Google-Smtp-Source: APiQypLbEXL/FHpTLs4uWSZNi04a+r3JtklVk4GnlFmK/rfVFKIjaIqtKgSd5EWbQpY7ViWrTbbNkQ==
X-Received: by 2002:a2e:814f:: with SMTP id t15mr972752ljg.96.1585359799815;
        Fri, 27 Mar 2020 18:43:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 3sm3763767ljq.18.2020.03.27.18.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 18:43:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3249A18158B; Sat, 28 Mar 2020 02:43:18 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <20200327230047.ois5esl35s63qorj@ast-mbp>
References: <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com> <87h7ye3mf3.fsf@toke.dk> <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com> <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com> <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com> <87pncznvjy.fsf@toke.dk> <20200326195859.u6inotgrm3ubw5bx@ast-mbp> <87imiqm27d.fsf@toke.dk> <20200327230047.ois5esl35s63qorj@ast-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 28 Mar 2020 02:43:18 +0100
Message-ID: <87lfnll0eh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Fri, Mar 27, 2020 at 01:06:46PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>=20
>> > On Thu, Mar 26, 2020 at 01:35:13PM +0100, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>> >>=20
>> >> Additionally, in the case where there is *not* a central management
>> >> daemon (i.e., what I'm implementing with libxdp), this would be the f=
low
>> >> implemented by the library without bpf_link:
>> >>=20
>> >> 1. Query kernel for current BPF prog loaded on $IFACE
>> >> 2. Sanity-check that this program is a dispatcher program installed by
>> >>    libxdp
>> >> 3. Create a new dispatcher program with whatever changes we want to do
>> >>    (such as adding another component program).
>> >> 4. Atomically replace the old program with the new one using the netl=
ink
>> >>    API in this patch series.
>> >
>> > in this model what stops another application that is not using libdisp=
atcher to
>> > nuke dispatcher program ?
>>=20
>> Nothing. But nothing is stopping it from issuing 'ip link down' either -
>> an application with CAP_NET_ADMIN is implicitly trusted to be
>> well-behaved. This patch series is just adding the kernel primitive that
>> enables applications to be well-behaved. I consider it an API bug-fix.
>
> I think what you're proposing is not a fix, but a band-aid.

Even if that were the case, I don't see how that is an argument for not
fixing the old API. I mean, it's not going away, so why not improve it,
even though we disagree whether that improvement will make it "not
broken" or "less broken"? I could understand why you wouldn't want to do
that if it was a huge and invasive change; but it really isn't...

> And from what I can read in this thread you remain unconvinced that
> you will hit exactly the same issues we're describing.

Yes, quite right :)

> We hit them already and you will hit them a year from now.
> Simply because fb usage of all parts of bpf are about 3-4 years ahead
> of everyone else.
> I'm trying to convince you that your libxdp will be in much better
> shape a year from now. It will be prepared for a situation when
> other libxdp clones exist and are trying to do the same.
> While you're saying:
> "let me shot myself in the foot. I know what I'm doing. I'll be fine".

I'm not saying "let me shoot myself in the foot", I'm saying that the
protections you are talking about won't make any meaningful difference
for the amount of foot-shooting that will end up happening.

>> >> Whereas with bpf_link, it would be:
>> >>=20
>> >> 1. Find the pinned bpf_link for $IFACE (e.g., load from
>> >>    /sys/fs/bpf/iface-links/$IFNAME).
>> >> 2. Query kernel for current BPF prog linked to $LINK
>> >> 3. Sanity-check that this program is a dispatcher program installed by
>> >>    libxdp
>> >> 4. Create a new dispatcher program with whatever changes we want to do
>> >>    (such as adding another component program).
>> >> 5. Atomically replace the old program with the new one using the
>> >>    LINK_UPDATE bpf() API.
>> >
>> > whereas here dispatcher program is only accessible to libdispatcher.
>> > Instance of bpffs needs to be known to libdispatcher only.
>> > That's the ownership I've been talking about.
>> >
>> > As discussed early we need a way for _human_ to nuke dispatcher progra=
m,
>> > but such api shouldn't be usable out of application/task.
>>=20
>> As long as there is this kind of override in place, I'm not actually
>> fundamentally opposed to the concept of bpf_link for XDP, as an
>> additional mechanism. What I'm opposed to is using bpf_link as a reason
>> to block this series.
>>=20
>> In fact, a way to implement the "human override" you mention, could be
>> to reuse the mechanism implemented in this series: If the EXPECTED_FD
>> passed via netlink is a bpf_link FD, that could be interpreted as an
>> override by the kernel.
>
> That's not "human override". You want to use expected_fd in libxdp.
> That's not human. That's any 'yum install firewall' will be nuking
> the bpf_link and careful orchestration of our libxdp.

No, I was certainly not planning to use that to teach libxdp to just
nuke any bpf_link it finds attached to an interface. Quite the contrary,
the point of this series is to allow libxdp to *avoid* replacing
something on the interface that it didn't put there itself.

> As far as blocking cap_net_admin...
> you mentioned that use case is to do:
> sudo yum install firewall1
> sudo yum install firewall2
>
> when these packages are being installed they will invoke startup scripts
> that will install their dispatcher progs on eth0.
> Imagine firewall2 is not using correct vestion of libxdp. or buggy one.
> all the good work from firewall1 went down the drain.

With a pinned bpf_link, both applications will get the link fd from the
same place, so if firewall2 (or its version of libxdp) is buggy, surely
it can interfere just as much with firewall1 if they are both using the
netlink API, no?

-Toke

