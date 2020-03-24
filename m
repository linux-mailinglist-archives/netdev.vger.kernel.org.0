Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0954C191D25
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 23:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbgCXW4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 18:56:38 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38883 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727250AbgCXW4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 18:56:38 -0400
Received: by mail-qk1-f196.google.com with SMTP id h14so472863qke.5;
        Tue, 24 Mar 2020 15:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nO/TUCfXH5JcNgVw6b7mJqj4Q7gXzucj0OwtiHw4z9U=;
        b=LKjYTYYbd6Jvw89UzteiChaY/tu/aEvKxuXjl1W1/7lBT2ouEA7qvlHbVojT0wY1uf
         EVtLd6bV3KYbzNRznPeQl+auWi972Ql+hx0FJcCS6lJM6nszPe1wht2bL51dvhAmXeWk
         PSL3OeLM1eryztJRk4ymtOLS7svKOe2yF34ufV5MHnR/nq2nIAKU885WrqbFudEjsa9X
         PEd+SOLmo/RkARRwV/WdPs9tg2+pSPHG8WS2ZGHW0cN0xiviPSjvYjfa8MWMCfHi45a7
         idtvHhuuZpXRp6XO5Ik4TJ/xJH0APp++3YkHvYDEC3Vnhjyzh1y7adgGgBIDTkoXSLEA
         gIZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nO/TUCfXH5JcNgVw6b7mJqj4Q7gXzucj0OwtiHw4z9U=;
        b=XaTE6AE1bRwlHibRG1rrX9avh+UADX0D+89ceh8L+cRUcnrWgWxN28ttl+HWfDmWR6
         5gocYIPL0ogNo+608P8ZHuYsxm4qiqR4eDwoGdOitw2Jc8eFZFDeM/n6J9AirWofAhoJ
         w8KPmKb3IYnNJnq0YRCt4MNKZVuuRMWb+Er/b80T9bHGHCwQOAKu518AFz2Yuw5fCidl
         g9WRi+hGAJgfBhk/nhuW4WZkSzKBEs3eM5M6tCQM4l7FL8mv+Z+um3NMAdNr5jjSKQtG
         yr7kzvZwUnu5NbD1ZHJ/u3ncxHSsTEJtwNFiYvkWuvBMI/Kgq+I/9Hg+r7BthwGoisXt
         2hLw==
X-Gm-Message-State: ANhLgQ3fUzX+Qs9e3d4kt2W0mpgkvRPkF2BPkFGho3M/oq1ldXbW6eL8
        3l6eazat4LWZKxdCqo7zYqqXgihhp8ROLnEbkRE=
X-Google-Smtp-Source: ADFU+vuADKlIX96nXnst8T/cc15Jvjirvqzx4w4zE2aSI7Cn3L8Xtn/E0fmrtODUPVQotdOvZo4WIrr0NHKmnjvL1OQ=
X-Received: by 2002:a37:6411:: with SMTP id y17mr214211qkb.437.1585090596506;
 Tue, 24 Mar 2020 15:56:36 -0700 (PDT)
MIME-Version: 1.0
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk> <1dfae7b8-4f80-13b8-c67c-82fe0a34f42a@gmail.com>
 <CAEf4BzbT=vC8OF8cwFX8H5vphn8-dyWRjRSPq50t0Cg8onmYhA@mail.gmail.com> <3b6d6f73-26b2-6ef8-dfac-2bd28e361458@gmail.com>
In-Reply-To: <3b6d6f73-26b2-6ef8-dfac-2bd28e361458@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 24 Mar 2020 15:56:25 -0700
Message-ID: <CAEf4BzZFL6h7auopO+HEaarWb3RNAcAvsMn+aUcskBhamHwWyg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     David Ahern <dsahern@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
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

On Tue, Mar 24, 2020 at 1:55 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 3/23/20 10:53 PM, Andrii Nakryiko wrote:
> > On Mon, Mar 23, 2020 at 6:01 PM David Ahern <dsahern@gmail.com> wrote:
> >>
> >> On 3/23/20 1:23 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >>>>>> I agree here. And yes, I've been working on extending bpf_link int=
o
> >>>>>> cgroup and then to XDP. We are still discussing some cgroup-specif=
ic
> >>>>>> details, but the patch is ready. I'm going to post it as an RFC to=
 get
> >>>>>> the discussion started, before we do this for XDP.
> >>>>>
> >>>>> Well, my reason for being skeptic about bpf_link and proposing the
> >>>>> netlink-based API is actually exactly this, but in reverse: With
> >>>>> bpf_link we will be in the situation that everything related to a n=
etdev
> >>>>> is configured over netlink *except* XDP.
> >>
> >> +1
> >
> > Hm... so using **libbpf**'s bpf_set_link_xdp_fd() API (notice "bpf" in
> > the name of the library and function, and notice no "netlink"), which
> > exposes absolutely nothing about netlink (it's just an internal
> > implementation detail and can easily change), is ok. But actually
> > switching to libbpf's bpf_link would be out of ordinary? Especially
> > considering that to use freplace programs (for libxdp and chaining)
> > with libbpf you will use bpf_program and bpf_link abstractions
> > anyways.
>
> It seems to me you are conflating libbpf api with the kernel uapi.

I'm not, as you can see in other email where I explicitly asked about
which ones we care in this discussion the most.

> Making libbpf user friendly certainly encourages standardization on its
> use, but there is no requirement that use of bpf means use of libbpf.

Agree, we can't force anyone to use libbpf. But it seems a pretty
popular choice in practice.

>
> >
> >>
> >>>>
> >>>> One can argue that everything related to use of BPF is going to be
> >>>> uniform and done through BPF syscall? Given variety of possible BPF
> >>>> hooks/targets, using custom ways to attach for all those many cases =
is
> >>>> really bad as well, so having a unifying concept and single entry to
> >>>> do this is good, no?
> >>>
> >>> Well, it depends on how you view the BPF subsystem's relation to the
> >>> rest of the kernel, I suppose. I tend to view it as a subsystem that
> >>> provides a bunch of functionality, which you can setup (using "intern=
al"
> >>> BPF APIs), and then attach that object to a different subsystem
> >>> (networking) using that subsystem's configuration APIs.
> >>>
> >>
> >> again, +1.
> >>
> >> bpf syscall is used for program related manipulations like load and
> >
> > bpf syscall is used for way more than that, actually...
> >
> >> unload. Attaching that program to an object has a type unique solution=
 -
> >> e.g., netlink for XDP and ioctl for perf_events.
> >
> > That's not true and hasn't been true for at least a while now. cgroup
> > programs, flow_dissector, lirc_mode2 (whatever that is, I have no
> > idea) are attached with BPF_PROG_ATTACH. raw_tracepoint and all the
> > fentry/fexit/fmod_ret/freplace attachments are done also through bpf
> > syscall. For perf_event related stuff it's done through ioctls right
> > now, but with bpf_link unification I wouldn't be surprised if it will
>
> and it always will be able to. Kernel uapi will not be revoked because a
> new way to do something comes along.

Good that we are in agreement that BPF attachment is not really a type
unique solution.

Also, I didn't say any of the existing APIs will go away. But to
support pinnable/queryable bpf_link, we'll need a new API for
perf_event. And I believe it should be done through bpf syscall, not
through more ioctls. Which is what we are discussing here w.r.t. XDP
as well. Existing way of attaching BPF program directly (with no
bpf_link created, no way to pin and query that bpf_link, etc) won't go
away anywhere, of course. But there is no need to duplicate
bpf_link-related APIs in netlink, if we are going to do it as part of
bpf syscall.

>
> > be done through the same LINK_CREATE command soon, as is done for
> > cgroup and *other* tracing bpf_links. Because consistent API and
> > semantics is good, rather than having to do it N different ways for N
> > different subsystems.
> >
>
> That's a bpf / libbpf centric perspective. What Toke and I are saying is
> the networking centric perspective matters to and networking uses
> netlink for configuration.

It's BPF-centric because BPF is much wider than networking which
allows to keep things in perspective beyond networking world. It's
about cost of maintaining UAPIs and consistency across whole range of
BPF program types. I don't see a good reason to maintain duplicate
APIs. We are going to have bpf_link API through bpf syscall (because
cgroups, tracing, etc) and it is going to be generic. So what's the
upside to duplicating it in netlink as well?

Can one work with XDP without bpf syscall? No, one cannot. So we are
not adding a new "syscall dependency" or anything like that.

On the other hand, as a developer, can I develop XDP application
without using netlink API at all? Funnily enough, I could if BPF
syscall allowed attaching to ifindex, couldn't I? If I develop some
monitoring application using XDP and not intending to configure any
network interface, just attach my BPF program and let it run for a
bit. Why would I bother with implementing entire netlink protocol just
to attach BPF program? But I also don't subscribe to a notion of
"attaching BPF program is configuration", so...
