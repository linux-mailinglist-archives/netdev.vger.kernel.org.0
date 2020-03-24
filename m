Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91FC2191C9F
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 23:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgCXW0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 18:26:04 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40422 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728094AbgCXW0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 18:26:03 -0400
Received: by mail-qt1-f196.google.com with SMTP id c9so457848qtw.7;
        Tue, 24 Mar 2020 15:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aAtcmDdvPg8fD6htDPUZZ3352zHbDNW/TY0RVmHTIGI=;
        b=NV5OlOr821XR86AtLZkoXR5Xu20NuFFELcWSN8Um9kDGQX2NxkKo1uMwClO61I2EOf
         Dk0MCZhEqUHSnPvLq+fUesWOrkikoFH5qPT7q2iJn64X7lC4AV2s7DfyM12czyeU79wT
         IHWLBeBVLuZy226OC3S9iTuU/Ss5dwT5LOLGVhtS5OgoL+VgCmy5bs1//tEgXU/QUe70
         XgIZ+cqPLzdpKG3NTEh3H3kmdjr/5jzv+UH3diuQcHsrzzsOiM8LdeashUQkvRGXJVAD
         dHeQT5dhs+P6IXxtxaJr6MbvuCLpr6DqhzDQ9U0S7getnD/IrxdVwi4FSODz04RXOCoa
         BMgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aAtcmDdvPg8fD6htDPUZZ3352zHbDNW/TY0RVmHTIGI=;
        b=YQrh9J4aQ/HFhR9IHngN4d8D9cfcQqOmHBMc70uILPeAT0UxSAdm63fCiYHq/T7JZs
         4QcfAfSF8mJ8gsqwm1nS9mCeVFjyMzhJwDkpIG6lxnuY+5ATwOVwckgm2FZZ6Ipz0wSs
         akvFBH3YxNxU3bkafIohfklByUGiHvjf04fftYv7Ni9Jthn6LWPuVqNtLrsVFNZFxn+s
         V0RcFozw/r7F3lo+2JYZIMdct131dNw/+T2edZRpy8UKMTIJUQCWqofMYM9os1M6srUN
         HoGHLZkTnzIbKKsvMzqpl0lEJonDe8qFjNGbcHhy9Yr2ULrinsaneuZi4STBTF7xUT9r
         VsMw==
X-Gm-Message-State: ANhLgQ1feuT+Hc4qjRe0BSzCWeq0vsKkALyqS8MA/VprVFwnYgDQM5xg
        AZDBfj22TJK/nVI41EX+cjBCsKSq8fPnMpJnbRfNX0Vn
X-Google-Smtp-Source: ADFU+vsv3qSMSNa+JlYZTn3lwzzPV0GqYNhCht/NEhDeZbgrEV6mIHvomx3krWDhzeFl8l3kz+T+prhwYHnAqV2QbNY=
X-Received: by 2002:ac8:7cb0:: with SMTP id z16mr112026qtv.59.1585088762440;
 Tue, 24 Mar 2020 15:26:02 -0700 (PDT)
MIME-Version: 1.0
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk> <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
In-Reply-To: <87tv2e10ly.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 24 Mar 2020 15:25:50 -0700
Message-ID: <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 3:57 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Mon, Mar 23, 2020 at 12:23 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Mon, Mar 23, 2020 at 4:24 AM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >> >>
> >> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >> >>
> >> >> > On Fri, Mar 20, 2020 at 11:31 AM John Fastabend
> >> >> > <john.fastabend@gmail.com> wrote:
> >> >> >>
> >> >> >> Jakub Kicinski wrote:
> >> >> >> > On Fri, 20 Mar 2020 09:48:10 +0100 Toke H=C3=B8iland-J=C3=B8rg=
ensen wrote:
> >> >> >> > > Jakub Kicinski <kuba@kernel.org> writes:
> >> >> >> > > > On Thu, 19 Mar 2020 14:13:13 +0100 Toke H=C3=B8iland-J=C3=
=B8rgensen wrote:
> >> >> >> > > >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >> >> > > >>
> >> >> >> > > >> While it is currently possible for userspace to specify t=
hat an existing
> >> >> >> > > >> XDP program should not be replaced when attaching to an i=
nterface, there is
> >> >> >> > > >> no mechanism to safely replace a specific XDP program wit=
h another.
> >> >> >> > > >>
> >> >> >> > > >> This patch adds a new netlink attribute, IFLA_XDP_EXPECTE=
D_FD, which can be
> >> >> >> > > >> set along with IFLA_XDP_FD. If set, the kernel will check=
 that the program
> >> >> >> > > >> currently loaded on the interface matches the expected on=
e, and fail the
> >> >> >> > > >> operation if it does not. This corresponds to a 'cmpxchg'=
 memory operation.
> >> >> >> > > >>
> >> >> >> > > >> A new companion flag, XDP_FLAGS_EXPECT_FD, is also added =
to explicitly
> >> >> >> > > >> request checking of the EXPECTED_FD attribute. This is ne=
eded for userspace
> >> >> >> > > >> to discover whether the kernel supports the new attribute=
.
> >> >> >> > > >>
> >> >> >> > > >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com>
> >> >> >> > > >
> >> >> >> > > > I didn't know we wanted to go ahead with this...
> >> >> >> > >
> >> >> >> > > Well, I'm aware of the bpf_link discussion, obviously. Not s=
ure what's
> >> >> >> > > happening with that, though. So since this is a straight-for=
ward
> >> >> >> > > extension of the existing API, that doesn't carry a high imp=
lementation
> >> >> >> > > cost, I figured I'd just go ahead with this. Doesn't mean we=
 can't have
> >> >> >> > > something similar in bpf_link as well, of course.
> >> >> >> >
> >> >> >> > I'm not really in the loop, but from what I overheard - I thin=
k the
> >> >> >> > bpf_link may be targeting something non-networking first.
> >> >> >>
> >> >> >> My preference is to avoid building two different APIs one for XD=
P and another
> >> >> >> for everything else. If we have userlands that already understan=
d links and
> >> >> >> pinning support is on the way imo lets use these APIs for networ=
king as well.
> >> >> >
> >> >> > I agree here. And yes, I've been working on extending bpf_link in=
to
> >> >> > cgroup and then to XDP. We are still discussing some cgroup-speci=
fic
> >> >> > details, but the patch is ready. I'm going to post it as an RFC t=
o get
> >> >> > the discussion started, before we do this for XDP.
> >> >>
> >> >> Well, my reason for being skeptic about bpf_link and proposing the
> >> >> netlink-based API is actually exactly this, but in reverse: With
> >> >> bpf_link we will be in the situation that everything related to a n=
etdev
> >> >> is configured over netlink *except* XDP.
> >> >
> >> > One can argue that everything related to use of BPF is going to be
> >> > uniform and done through BPF syscall? Given variety of possible BPF
> >> > hooks/targets, using custom ways to attach for all those many cases =
is
> >> > really bad as well, so having a unifying concept and single entry to
> >> > do this is good, no?
> >>
> >> Well, it depends on how you view the BPF subsystem's relation to the
> >> rest of the kernel, I suppose. I tend to view it as a subsystem that
> >> provides a bunch of functionality, which you can setup (using "interna=
l"
> >> BPF APIs), and then attach that object to a different subsystem
> >> (networking) using that subsystem's configuration APIs.
> >>
> >> Seeing as this really boils down to a matter of taste, though, I'm not
> >> sure we'll find agreement on this :)
> >
> > Yeah, seems like so. But then again, your view and reality don't seem
> > to correlate completely. cgroup, a lot of tracing,
> > flow_dissector/lirc_mode2 attachments all are done through BPF
> > syscall.
>
> Well, I wasn't talking about any of those subsystems, I was talking
> about networking :)

So it's not "BPF subsystem's relation to the rest of the kernel" from
your previous email, it's now only "talking about networking"? Since
when the rest of the kernel is networking?

But anyways, I think John addressed modern XDP networking issues in
his email very well already.

>
> In particular, networking already has a consistent and fairly
> well-designed configuration mechanism (i.e., netlink) that we are
> generally trying to move more functionality *towards* not *away from*
> (see, e.g., converting ethtool to use netlink).
>
> > LINK_CREATE provides an opportunity to finally unify all those
> > different ways to achieve the same "attach my BPF program to some
> > target object" semantics.
>
> Well I also happen to think that "attach a BPF program to an object" is
> the wrong way to think about XDP. Rather, in my mind the model is
> "instruct the netdevice to execute this piece of BPF code".

That can't be reconciled, so no point of arguing :) But thinking about
BPF in general, I think it's closer to attach BPF program thinking
(especially all the fexit/fentry, kprobe, etc), where objects that BPF
is attached to is not "active" in the sense of "calling BPF", it's
more of BPF system setting things up (attaching?) in such a way that
BPF program is executed when appropriate.

>
> >> >> Other than that, I don't see any reason why the bpf_link API won't =
work.
> >> >> So I guess that if no one else has any problem with BPF insisting o=
n
> >> >> being a special snowflake, I guess I can live with it as well... *s=
hrugs* :)
> >> >
> >> > Apart from derogatory remark,
> >>
> >> Yeah, should have left out the 'snowflake' bit, sorry about that...
> >>
> >> > BPF is a bit special here, because it requires every potential BPF
> >> > hook (be it cgroups, xdp, perf_event, etc) to be aware of BPF
> >> > program(s) and execute them with special macro. So like it or not, i=
t
> >> > is special and each driver supporting BPF needs to implement this BP=
F
> >> > wiring.
> >>
> >> All that is about internal implementation, though. I'm bothered by the
> >> API discrepancy (i.e., from the user PoV we'll end up with: "netlink i=
s
> >> what you use to configure your netdev except if you want to attach an
> >> XDP program to it").
> >>
> >
> > See my reply to David. Depends on where you define user API. Is it
> > libbpf API, which is what most users are using? Or kernel API?
>
> Well I'm talking about the kernel<->userspace API, obviously :)
>
> > If everyone is using libbpf, does kernel system (bpf syscall vs
> > netlink) matter all that much?
>
> This argument works the other way as well, though: If libbpf can
> abstract the subsystem differences and provide a consistent interface to
> "the BPF world", why does BPF need to impose its own syscall API on the
> networking subsystem?

bpf_link in libbpf started as user-space abstraction only, but we
realized that it's not enough and there is a need to have proper
kernel support and corresponding kernel object, so it's not just
user-space API concerns.

As for having netlink interface for creating link only for XDP. Why
duplicating and maintaining 2 interfaces? All the other subsystems
will go through bpf syscall, only XDP wants to (also) have this
through netlink. This means duplication of UAPI for no added benefit.
It's a LINK_CREATE operations, as well as LINK_UPDATE operations. Do
we need to duplicate LINK_QUERY (once its implemented)? What if we'd
like to support some other generic bpf_link functionality, would it be
ok to add it only to bpf syscall, or we need to duplicate this in
netlink as well?

>
> -Toke
>
