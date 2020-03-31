Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6804F199FDA
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 22:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730589AbgCaUP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 16:15:59 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39523 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbgCaUP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 16:15:58 -0400
Received: by mail-qk1-f194.google.com with SMTP id b62so24577754qkf.6;
        Tue, 31 Mar 2020 13:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ul3hhhavR4FQmbxolSeFzISmi9sp4tG1wMRK7A/A1gs=;
        b=WxRfSyoo53XYefNd0el85EC5RIdyWT7UAhHQIRfvDTymB+/sar+vpRRBt1CFnuqxAq
         WG1m5clQzFVlLV7O2WrozSwmn30VxZsTAFe8ReijakktlGKoE0Du2hrwKIGjV5jW+XJG
         Cv3AJ+PyGrwbtOwV9uMRmxn9GGLNfjLWAImAIJepqyeKjZ29hYJLVJ67xF4vhsFoF5ts
         3WrXk6pSTyawfb34ypjUckPMxPDqfCEpnkRLcGiXuN5ocTH8cGentfrOjqH/dKWtROpk
         P9iwx8+QJuxulG+ElcyxiUgx1ylbkmr/LBcdlUpz/dIhktj3NYqLds4ddg2MyPj1oJid
         MXyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ul3hhhavR4FQmbxolSeFzISmi9sp4tG1wMRK7A/A1gs=;
        b=i74P22aRT3vz6qgpHLrHm6DLtaqvtKh2ViTnFR3ZZnirkK8OQhVjwXhPu9SGhNkz/d
         t9lIKev+TFibTgA+jc9zWxJVWtDwlhbfJPqqWkKGPPol1+pDIm/szDdnoGT+ku3H4hVq
         YpbT62Rch3WMOZ5LLf1m4ZvYm3VX9RR8egh7fnZKsG9gKXEYGbszox3/bKVsjyriNxBO
         +U4s4ziRj8YNWy81hJdg+4GdrPLOfRWxvBH3S6Db3P95b4LvifXB+5lPFXwzCPB50e+G
         J+xObOKPRwN4j84ro/zBt3Awh0RLE1zOrW1vP25uZWCprk2yJ9zweoac8VKYbwbilRIf
         OlBg==
X-Gm-Message-State: ANhLgQ2sNxNOCP1gyHKygGPJlrKqmbnEddADcut85Gd9owEwcZNrS8/Z
        NcRS/N2GPOQ2FWzOcf4R+ZA1Fgtecd91R5oGLqI=
X-Google-Smtp-Source: ADFU+vutYyDtGJ/IQU+3gM4PZm45VZrjW6CfdNb9rBU9S6pQtcrY+ZNmRH2jLFXAC3QITQudfneeJoB823PdzF4wqLk=
X-Received: by 2002:a37:6411:: with SMTP id y17mr7042990qkb.437.1585685756328;
 Tue, 31 Mar 2020 13:15:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk> <20200326195859.u6inotgrm3ubw5bx@ast-mbp>
 <87imiqm27d.fsf@toke.dk> <20200327230047.ois5esl35s63qorj@ast-mbp>
 <87lfnll0eh.fsf@toke.dk> <20200328022609.zfupojim7see5cqx@ast-mbp>
 <87eetcl1e3.fsf@toke.dk> <CAEf4Bzb+GSf8cE_rutiaeZOtAuUick1+RnkCBU=Z+oY_36ArSA@mail.gmail.com>
 <87y2rihruq.fsf@toke.dk> <CAEf4Bza4vKbjkj8kBkrVmayFr2j_nvrORF_YkCoVKibB=SmSYQ@mail.gmail.com>
 <87pncsj0hv.fsf@toke.dk> <86f95d7a-1659-a092-91a2-abe5d58ceda8@iogearbox.net>
In-Reply-To: <86f95d7a-1659-a092-91a2-abe5d58ceda8@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 31 Mar 2020 13:15:44 -0700
Message-ID: <CAEf4BzYAtvETd+Sh6bBVnrqB=jz00+N1PLgsT6vAkwLhdB2d3w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 6:49 AM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 3/31/20 12:13 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >
> >>>> So you install your libxdp-based firewalls and are happy. Then you
> >>>> decide to install this awesome packet analyzer, which doesn't know
> >>>> about libxdp yet. Suddenly, you get all packets analyzer, but no mor=
e
> >>>> firewall, until users somehow notices that it's gone. Or firewall
> >>>> periodically checks that it's still runinng. Both not great, IMO, bu=
t
> >>>> might be acceptable for some users, I guess. But imagine all the
> >>>> confusion for user, especially if he doesn't give a damn about XDP a=
nd
> >>>> other buzzwords, but only needs a reliable firewall :)
> >>>
> >>> Yes, whereas if the firewall is using bpf_link, then the packet analy=
ser
> >>> will be locked out and can't do its thing. Either way you end up with=
 a
> >>> broken application; it's just moving the breakage. In the case of
> >>
> >> Hm... In one case firewall installation reported success and stopped
> >> working afterwards with no notification and user having no clue. In
> >> another, packet analyzer refused to start and reported error to user.
> >> Let's agree to disagree that those are not at all equivalent. To me
> >> silent failure is so much worse, than application failing to start in
> >> the first place.
>
> I sort of agree with both of you that either case is not great. The silen=
t
> override we currently have is not great since it can be evicted at any ti=
me
> but also bpf_link to lock-out other programs at XDP layer is not great ei=
ther
> since there is also huge potential to break existing programs. It's proba=
bly

I disagree with the premise that in current setup two XDP applications
can work at all. Best case, one will fail if specified the option to
not attach if something is already attached. Worst case, both will
happily assume (and report to user) that they are working, but only
the one attached last will actually work. Or maybe it's not even the
worst scenario, if both of them use netlink notification and keep
re-attaching themselves and detaching "opponent" (a fun bot fight to
watch...)

So what I hope we are discussing here is the world where some
applications are moving into using libxdp or some other co-operative
approach/daemon. In that case, utmost importance (otherwise its
unreliable and half-working solution) is to prevent XDP applications
not aware about this cooperation approach to break cooperating ones.
And that can be done only if libxdp/daemon can guarantee that *if it
successfully* attaches root XDP program, it won't be replaced by
oblivious XDP application that is not aware of it. So yes, in this
case non-cooperating application won't work (as it might not with
current API), but at least it will report that it can't attach, as
opposed to break *all* other nicely behaving and cooperating XDP
appplications **silently**. There are probably few more frustrating
things than silent corruption/breakage, IMO as both a user and
programmer.

> best to discuss on an actual proposal to see the concrete semantics, but =
my
> concerns, assuming I didn't misunderstand or got confused on something al=
ong
> the way (if so, please let me know), currently are:
>
>   - System service XYZ starts to use XDP with bpf_link one day. Somehow t=
his
>     application gets shipped by default on mainstream distros and starts =
up
>     during init, then effectively locking out everyone else that used to =
use
>     the hook today "just fine" given they owned / orchestrated the underl=
ying
>     networking on the host namespace for the nodes they manage (and for t=
hat

If XYZ didn't use bpf_link and just used existing API, it would break
everything as well, because see above, they can't co-exist. The
difference is in amount of undeterminism (who starts first and who's
second) and awareness (whether app even knows that it's broken).
Neither are in favor of existing API.

>     it worked before). Now such latter app somehow needs to work around t=
his
>     breakage by undoing the damage that XYZ did in order to be able to op=
erate
>     again. There was mentioned 'human override'. I presume whatever it wi=
ll be,
>     it will also be done by applications when they don't have another cho=
ice.

No, it's opposite. That's why it's **human override**. It's not
intended to be used by application to "unblock" itself.

>     Otherwise we need to go and tell users that XDP is now only _entirely=
_
>     reserved for system service XYZ if you run distro ABC, but not for ev=
eryone
>     else anymore; what answer is there to this? From a PoV where one owns=
 the

That's exactly what Toke's libxdp is intending to be. An XDP
coordination solution/library that other applications that want to
co-exist on the same network interface **have** to use. It intends to
allow all XDP applications to co-exist. That would be the answer - go
use that library.

>     entire distro and ecosystem, this is fine, but where this is not the =
case
>     as in the rest of the world having to rely on mainstream distros, wha=
t is
>     the answer to users (and especially "those that don't give a damn abo=
ut XDP,
>     but just want to get stuff to work" that used to work before, even if=
 we
>     think silent override is broken)? If the answer is to just 'shrug' an=
d tell
>     'sorry that's the new way it is right now', then apps will try to use=
 whatever
>     'human override' there is, and we're back to square one. To provide a
>     concrete example: if Cilium was configured to load some of its progra=
ms on
>     XDP hook, it currently replaces whatever it was there before. The ass=
umption
>     is, that in the scenario we're in, we can orchestrate the hostns netw=
orking
>     just fine on K8s nodes since there is just one CNI plugin taking care=
 of that
>     (and that generally also holds true for the other hooks we're using t=
oday).
>     Now, while we could switch to bpf_link as well and implement it in ip=
route2
>     for this specific case, what if someone else starting up earlier and =
locks
>     our stuff out? How would we work around it?

For one, you can use some tool/script (like the one I posted
yesterday: [0]) to find "offending" application that's not expected to
be using XDP and kill it (and/or investigate why on earth it got
installed/started in your infrastructure without you being aware). I
think this solution is better than nuke ("human override") option,
because it gives you clues on what's misbehaving and needs fixing in
the first place.

  [0] https://gist.github.com/anakryiko/562dff8e39c619a5ee247bb55aa057c7

>
>   - Assuming we have XDP with bpf_link in place with the above, now appli=
cations
>     are forced to start using bpf_link in order to not be locked out by o=
thers
>     using bpf_link as otherwise their application would break. So they ne=
ed to
>     support the "old" way of attaching programs as we have today for olde=
r
>     kernels and need to support the bpf_link attachment for newer kernels=
 since
>     they cannot rely on the old / existing API anymore. There is also a w=
orld
>     outside of C/C++ and thus libbpf / lib{xdp,dispatcher} or whatever, s=
o the
>     whole rest of the ecosystem is forced to implement it as well due to =
breakage
>     concerns, understandable, but quite a burden.

Multi-XDP (on the same netdev, of course) doesn't exist and is not
possible today with existing API and semantics. The world outside of
C/C++ will either need to use compatible mechanisms (linking and using
libxdp with whatever means their language/runtime provides or at least
re-implementing the same set of protocols and behaviors).

>
>   - Equally, in case of Toke's implementation for the cmpxchg-like mechan=
ism in
>     XDP itself, what happens if an application uses this API and assuming=
 the
>     library would return the error to the application using it if the exp=
ected
>     program is not attached? Then the application would go for a forceful=
 override
>     with the existing API today or would it voluntarily bail out and refu=
sing to
>     work if some other non-cooperating application was loaded in the mean=
time?
>     What is the cmpxchg-like mechanism then solving realistically? (And a=
gain,
>     please keep all in mind we cannot force the entire world to use one s=
ingle
>     library to rule 'em all, there are plenty of other language runtimes =
out in
>     the wild that cannot just import C/C++.)

It's not about using one specific library, but it is about following
the same protocol. I think that's what Toke, Alexei, Andrey and others
are assuming - that yes, if people want to write reliable XDP
applications co-existing with each other, they will have to use the
same library (easier, if possible) or at least follow the same
protocol.


>
> Thoughts?
>
> Thanks,
> Daniel
