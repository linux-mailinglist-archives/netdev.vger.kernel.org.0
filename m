Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C394F1919D0
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgCXTXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:23:00 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35275 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgCXTXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:23:00 -0400
Received: by mail-pf1-f194.google.com with SMTP id u68so9818190pfb.2;
        Tue, 24 Mar 2020 12:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=374HQphP39sEOi9n0JJRDNDoBsomd8r5qTqd/zixZOw=;
        b=LaKL5pGy8HzHVsTiFLc40x/QeC1TvKGoedseN2AWyrB/DN6W/NXmILhiey0afO4IjL
         AFwkSW+QdF4fvNeJ+gDbbqZwJ2T8Johfcr7O6MY9sH4s2LgYHHMoRQ7JXyz6zV4DS2BO
         wD3f3sMTf7yPXpfNyDGEQP8SV4eDqZhhAXjdNyhS7kxTkvqgUd1igS40oeVTzhXaigxR
         PlYo/MnTyuGjODEgNtBX4qnD/5nrh9z1goA9Jm/iDykZdWnhFrBNXzAKD1+TwdKWaf8D
         ZCO123G8Zj6mhIS5vbXcm6s5wVUEraaVCTnX14bmuuSqBdPg64N3QAGJ3BaxyK/as4LA
         Zv8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=374HQphP39sEOi9n0JJRDNDoBsomd8r5qTqd/zixZOw=;
        b=ps0IA1n5oOkUzkrx2xy6OA1nQuTynzJPqYR225GLpO3LqgBzeDuLpb8YW2VkepFsqA
         AzKo/4/pY3Im+ZGL+MtcFYE+UmkrbXoTUel7HtmpkZeY0VjoJj6dj2EGVzLZ3rliktY1
         9Qo88/CHs+zOx2iZR85YQDLyb0JpvzAJvIHwNDsweR3olttEDyAs/Sjer76Em19YFWla
         qKYhd1jui42V8MxUSxEo99WU/pZ9M8iXlXKmyQxpbOoz+RkW0+1Ody1sGMlyGXyjDLKi
         vxYhnbSHYc0dktetVAevqyLjNXliEOYppGKeDPdAU37W4jGFhzspkIaDafHU+oho7EKr
         ZtYg==
X-Gm-Message-State: ANhLgQ3ke9Wth+1cPSLRgB83rwQJ8DE3DdeqOAj9kbwLqRoSqTBtkoCf
        nlDMcFzTthbXq3r1+oRNO9Y=
X-Google-Smtp-Source: ADFU+vvOphWXZDIKVmK3h71dtNetY/tFFU/QWc9hdOzRl5nTqdsAQerUxhLUKydEPWDquaFf4JpUOQ==
X-Received: by 2002:a63:f962:: with SMTP id q34mr28314426pgk.229.1585077776639;
        Tue, 24 Mar 2020 12:22:56 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x24sm7710716pfn.140.2020.03.24.12.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 12:22:55 -0700 (PDT)
Date:   Tue, 24 Mar 2020 12:22:47 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
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
Message-ID: <5e7a5e07d85e8_74a82ad21f7a65b88d@john-XPS-13-9370.notmuch>
In-Reply-To: <87tv2e10ly.fsf@toke.dk>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk>
 <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk>
 <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk>
 <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> =

> > On Mon, Mar 23, 2020 at 12:23 PM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Mon, Mar 23, 2020 at 4:24 AM Toke H=C3=B8iland-J=C3=B8rgensen <=
toke@redhat.com> wrote:
> >> >>
> >> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >> >>
> >> >> > On Fri, Mar 20, 2020 at 11:31 AM John Fastabend
> >> >> > <john.fastabend@gmail.com> wrote:
> >> >> >>
> >> >> >> Jakub Kicinski wrote:
> >> >> >> > On Fri, 20 Mar 2020 09:48:10 +0100 Toke H=C3=B8iland-J=C3=B8=
rgensen wrote:
> >> >> >> > > Jakub Kicinski <kuba@kernel.org> writes:
> >> >> >> > > > On Thu, 19 Mar 2020 14:13:13 +0100 Toke H=C3=B8iland-J=C3=
=B8rgensen wrote:
> >> >> >> > > >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com=
>
> >> >> >> > > >>
> >> >> >> > > >> While it is currently possible for userspace to specify=
 that an existing
> >> >> >> > > >> XDP program should not be replaced when attaching to an=
 interface, there is
> >> >> >> > > >> no mechanism to safely replace a specific XDP program w=
ith another.
> >> >> >> > > >>
> >> >> >> > > >> This patch adds a new netlink attribute, IFLA_XDP_EXPEC=
TED_FD, which can be
> >> >> >> > > >> set along with IFLA_XDP_FD. If set, the kernel will che=
ck that the program
> >> >> >> > > >> currently loaded on the interface matches the expected =
one, and fail the
> >> >> >> > > >> operation if it does not. This corresponds to a 'cmpxch=
g' memory operation.
> >> >> >> > > >>
> >> >> >> > > >> A new companion flag, XDP_FLAGS_EXPECT_FD, is also adde=
d to explicitly
> >> >> >> > > >> request checking of the EXPECTED_FD attribute. This is =
needed for userspace
> >> >> >> > > >> to discover whether the kernel supports the new attribu=
te.
> >> >> >> > > >>
> >> >> >> > > >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com>
> >> >> >> > > >
> >> >> >> > > > I didn't know we wanted to go ahead with this...
> >> >> >> > >
> >> >> >> > > Well, I'm aware of the bpf_link discussion, obviously. Not=
 sure what's
> >> >> >> > > happening with that, though. So since this is a straight-f=
orward
> >> >> >> > > extension of the existing API, that doesn't carry a high i=
mplementation
> >> >> >> > > cost, I figured I'd just go ahead with this. Doesn't mean =
we can't have
> >> >> >> > > something similar in bpf_link as well, of course.
> >> >> >> >
> >> >> >> > I'm not really in the loop, but from what I overheard - I th=
ink the
> >> >> >> > bpf_link may be targeting something non-networking first.
> >> >> >>
> >> >> >> My preference is to avoid building two different APIs one for =
XDP and another
> >> >> >> for everything else. If we have userlands that already underst=
and links and
> >> >> >> pinning support is on the way imo lets use these APIs for netw=
orking as well.
> >> >> >
> >> >> > I agree here. And yes, I've been working on extending bpf_link =
into
> >> >> > cgroup and then to XDP. We are still discussing some cgroup-spe=
cific
> >> >> > details, but the patch is ready. I'm going to post it as an RFC=
 to get
> >> >> > the discussion started, before we do this for XDP.
> >> >>
> >> >> Well, my reason for being skeptic about bpf_link and proposing th=
e
> >> >> netlink-based API is actually exactly this, but in reverse: With
> >> >> bpf_link we will be in the situation that everything related to a=
 netdev
> >> >> is configured over netlink *except* XDP.
> >> >
> >> > One can argue that everything related to use of BPF is going to be=

> >> > uniform and done through BPF syscall? Given variety of possible BP=
F
> >> > hooks/targets, using custom ways to attach for all those many case=
s is
> >> > really bad as well, so having a unifying concept and single entry =
to
> >> > do this is good, no?
> >>
> >> Well, it depends on how you view the BPF subsystem's relation to the=

> >> rest of the kernel, I suppose. I tend to view it as a subsystem that=

> >> provides a bunch of functionality, which you can setup (using "inter=
nal"
> >> BPF APIs), and then attach that object to a different subsystem
> >> (networking) using that subsystem's configuration APIs.
> >>
> >> Seeing as this really boils down to a matter of taste, though, I'm n=
ot
> >> sure we'll find agreement on this :)
> >
> > Yeah, seems like so. But then again, your view and reality don't seem=

> > to correlate completely. cgroup, a lot of tracing,
> > flow_dissector/lirc_mode2 attachments all are done through BPF
> > syscall.
> =

> Well, I wasn't talking about any of those subsystems, I was talking
> about networking :)

My experience has been that networking in the strict sense of XDP no
longer exists on its own without cgroups, flow dissector, sockops,
sockmap, tracing, etc. All of these pieces are built, patched, loaded,
pinned and otherwise managed and manipulated as BPF objects via libbpf.

Because I have all this infra in place for other items its a bit odd
imo to drop out of BPF apis to then swap a program differently in the
XDP case from how I would swap a program in any other place. I'm
assuming ability to swap links will be enabled at some point.

Granted it just means I have some extra functions on the side to manage
the swap similar to how 'qdisc' would be handled today but still not as
nice an experience in my case as if it was handled natively.

Anyways the netlink API is going to have to call into the BPF infra
on the kernel side for verification, etc so its already not pure
networking.

> =

> In particular, networking already has a consistent and fairly
> well-designed configuration mechanism (i.e., netlink) that we are
> generally trying to move more functionality *towards* not *away from*
> (see, e.g., converting ethtool to use netlink).

True. But BPF programs are going to exist and interop with other
programs not exactly in the networking space. Actually library calls
might be used in tracing, cgroups, and XDP side. It gets a bit more
interesting if the "same" object file (with some patching) runs in both
XDP and sockops land for example.

> =

> > LINK_CREATE provides an opportunity to finally unify all those
> > different ways to achieve the same "attach my BPF program to some
> > target object" semantics.
> =

> Well I also happen to think that "attach a BPF program to an object" is=

> the wrong way to think about XDP. Rather, in my mind the model is
> "instruct the netdevice to execute this piece of BPF code".
> =

> >> >> Other than that, I don't see any reason why the bpf_link API won'=
t work.
> >> >> So I guess that if no one else has any problem with BPF insisting=
 on
> >> >> being a special snowflake, I guess I can live with it as well... =
*shrugs* :)
> >> >
> >> > Apart from derogatory remark,
> >>
> >> Yeah, should have left out the 'snowflake' bit, sorry about that...
> >>
> >> > BPF is a bit special here, because it requires every potential BPF=

> >> > hook (be it cgroups, xdp, perf_event, etc) to be aware of BPF
> >> > program(s) and execute them with special macro. So like it or not,=
 it
> >> > is special and each driver supporting BPF needs to implement this =
BPF
> >> > wiring.
> >>
> >> All that is about internal implementation, though. I'm bothered by t=
he
> >> API discrepancy (i.e., from the user PoV we'll end up with: "netlink=
 is
> >> what you use to configure your netdev except if you want to attach a=
n
> >> XDP program to it").
> >>
> >
> > See my reply to David. Depends on where you define user API. Is it
> > libbpf API, which is what most users are using? Or kernel API?
> =

> Well I'm talking about the kernel<->userspace API, obviously :)
> =

> > If everyone is using libbpf, does kernel system (bpf syscall vs
> > netlink) matter all that much?
> =

> This argument works the other way as well, though: If libbpf can
> abstract the subsystem differences and provide a consistent interface t=
o
> "the BPF world", why does BPF need to impose its own syscall API on the=

> networking subsystem?

I can make it work either way as a netlink or syscall its not going
to be a blocker. If we go netlink route then the next question is
does libbpf pull in the ability to swap XDP progs via netlink or
is that some other lib?

> =

> -Toke
> =



