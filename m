Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C20A198544
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 22:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgC3URp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 16:17:45 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39366 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbgC3URp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 16:17:45 -0400
Received: by mail-qk1-f194.google.com with SMTP id b62so20621349qkf.6;
        Mon, 30 Mar 2020 13:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gLzLoaK7mPB5gBiua0KRWOJfo9jYZM39oLvTRyNs1qQ=;
        b=qnGyLqQB7hh/6/V6huryQaWiv6XLoYLgoSs0slOcpnK8rElnNb6bP1H+2gul+s9sNQ
         s29oRvf4FViJkoRLGf51DUzv8r333Sd8GiS4skaWCtC90I4usmcu/7bjQWhlASsTAiah
         1MbP/K2a6ddX/Zqxawk2e8gCYhB3Ojj9cXMRHfyAwXJQ0q94IWGwnAMBsusrQ6IJirCT
         NQYPfjtDpwg5s3miMbw7cpSTGqgS9YD6DqabRilPKAYI9IYftvooq+BCLS5JWE8pifFL
         79Bv5jQgtMf5gTRNOboYmoiafLs2P2CN4Hpxf0YDZDbsQ7iMxdM08676LiJdNTbuIdWA
         oVtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gLzLoaK7mPB5gBiua0KRWOJfo9jYZM39oLvTRyNs1qQ=;
        b=C4xCD8vhtRCdYP8DBzrTBoy4WmGx3+Vvqi1LeNavshOFggCw8VFVtS4MiqLRnuUw9s
         e94cw9ZUzZn1WgUqs/fwUSwT6lbOVrcEtRDZceuV2QQreaDMr9ooOMZRZP88KxSTxez8
         zgptRCwjZW9ADMb0MUlFUpQCBdU0ca7cOvnbpejxcpM3T2KggqwdJXJojqqfw4gEAayC
         PzCj7/yWTQ+6p3L72ab4MgDD1Iw0bb4xB1wsh48uOVHAeEgbGmhfQwdWffl0Nee81cQC
         cdEzmvJEtdysL86MCGvDRe/RdNcLKgAbrl1a4HI5OY+5ibKStIooG/nWJviJhtq03mAn
         YnKw==
X-Gm-Message-State: ANhLgQ2i2mIMUepnkvTv29ybgPzfgOoHiELchDGbjMaGGu2vWsfV42G9
        LJPjAByX+tB05fctByP6OgKfbgT9i2zKsGHNCq0=
X-Google-Smtp-Source: ADFU+vvdVfPV6ArxdBTw7o15k9Es+3qJwwYryiqcSQRcaAna/3ios9jiNcX9rbsavVIlyCDB2rnl921D5OXjaqFUMfU=
X-Received: by 2002:a05:620a:88e:: with SMTP id b14mr1871309qka.449.1585599463913;
 Mon, 30 Mar 2020 13:17:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk> <20200326195859.u6inotgrm3ubw5bx@ast-mbp>
 <87imiqm27d.fsf@toke.dk> <20200327230047.ois5esl35s63qorj@ast-mbp>
 <87lfnll0eh.fsf@toke.dk> <20200328022609.zfupojim7see5cqx@ast-mbp>
 <87eetcl1e3.fsf@toke.dk> <CAEf4Bzb+GSf8cE_rutiaeZOtAuUick1+RnkCBU=Z+oY_36ArSA@mail.gmail.com>
 <87y2rihruq.fsf@toke.dk>
In-Reply-To: <87y2rihruq.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Mar 2020 13:17:32 -0700
Message-ID: <CAEf4Bza4vKbjkj8kBkrVmayFr2j_nvrORF_YkCoVKibB=SmSYQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 6:53 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Sat, Mar 28, 2020 at 12:34 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
> >>
> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >>
> >> > On Sat, Mar 28, 2020 at 02:43:18AM +0100, Toke H=C3=B8iland-J=C3=B8r=
gensen wrote:
> >> >>
> >> >> No, I was certainly not planning to use that to teach libxdp to jus=
t
> >> >> nuke any bpf_link it finds attached to an interface. Quite the cont=
rary,
> >> >> the point of this series is to allow libxdp to *avoid* replacing
> >> >> something on the interface that it didn't put there itself.
> >> >
> >> > Exactly! "that it didn't put there itself".
> >> > How are you going to do that?
> >> > I really hope you thought it through and came up with magic.
> >> > Because I tried and couldn't figure out how to do that with IFLA_XDP=
*
> >> > Please walk me step by step how do you think it's possible.
> >>
> >> I'm inspecting the BPF program itself to make sure it's compatible.
> >> Specifically, I'm embedding a piece of metadata into the program BTF,
> >> using Andrii's encoding trick that we also use for defining maps. So
> >> xdp-dispatcher.c contains this[0]:
> >>
> >> __uint(dispatcher_version, XDP_DISPATCHER_VERSION) SEC(XDP_METADATA_SE=
CTION);
> >>
> >> and libxdp will refuse to touch any program that it finds loaded on an
> >
> > But you can't say the same about other XDP applications that do not
> > use libxdp. So will your library come with a huge warning, e.g.:
> >
> > WARNING! ANY XDP APPLICATION YOU INSTALL ON YOUR MACHINE THAT DOESN'T
> > USE LIBXDP WILL BREAK YOUR FIREWALLS/ROUTERS/OTHER LIBXDP
> > APPLICATIONS. USE AT YOUR OWN RISK.
> >
> > So you install your libxdp-based firewalls and are happy. Then you
> > decide to install this awesome packet analyzer, which doesn't know
> > about libxdp yet. Suddenly, you get all packets analyzer, but no more
> > firewall, until users somehow notices that it's gone. Or firewall
> > periodically checks that it's still runinng. Both not great, IMO, but
> > might be acceptable for some users, I guess. But imagine all the
> > confusion for user, especially if he doesn't give a damn about XDP and
> > other buzzwords, but only needs a reliable firewall :)
>
> Yes, whereas if the firewall is using bpf_link, then the packet analyser
> will be locked out and can't do its thing. Either way you end up with a
> broken application; it's just moving the breakage. In the case of

Hm... In one case firewall installation reported success and stopped
working afterwards with no notification and user having no clue. In
another, packet analyzer refused to start and reported error to user.
Let's agree to disagree that those are not at all equivalent. To me
silent failure is so much worse, than application failing to start in
the first place.

> firewall vs packet analyser it's probably clear what the right
> precedence is, but what if it's firewall vs IDS? Or two different
> firewall-type applications?
>
> This is the reason I don't believe the problem bpf_link solves is such a
> big deal: Since multi-prog is implemented in userspace it *fundamentally
> requires* applications to coordinate. So all the kernel needs to provide,
> is a way to help well-behaved applications do this coordination, for
> which REPLACE_FD is sufficient.
>
> Now, this picture changes a bit if you have a more-privileged
> application managing things - such as the "xdp daemon" I believe you're
> using, right? In that case it becomes obvious which application should
> have precedence, and the "lock-out" feature makes sense (assuming you
> can't just use capabilities to enforce the access restriction). This is
> why I keep saying that I understand why you want bpf_link for you use
> case, I just don't think it'll help mine much... :)
>
> -Toke
>
