Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49CC61934EA
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 01:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgCZAQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 20:16:29 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42315 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbgCZAQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 20:16:29 -0400
Received: by mail-qk1-f193.google.com with SMTP id e11so4701833qkg.9;
        Wed, 25 Mar 2020 17:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1U2WJTnCiz84oywo/Ll3GeOK9/sYvtrilbF2wQI2oxQ=;
        b=CJoTh1kz5trw9co5KTzLQzJ/ZMZ0RuPqvXG19MDx+NjcgCl6Jprk5Mvq6i2T4BKOc8
         rA22a9VH4VZyAUdVAdLc4sXpZyT+Q6wc9LuRTxC7Ydz+cDhknXEpSvIS8HOdV258t1A3
         /rIWeLvyLFTxAQaRsKNxcHKORhYuG2jgndTTGvYEMmdYIftVJUEhmtk3ePEFlxi7Kz3a
         zCDyeVFTp97+Ol7kybofVrGnb/IkarhgT0uy6c6/FA1ej+6ywNT0vMTHNcPCs3ZdtXDq
         HZWoviYbCD5lDTJiirnfw1/Kii535yM7HjesMZ/zj31nMRnGdAfkvtORYdrbzTEKrNZb
         Gvfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1U2WJTnCiz84oywo/Ll3GeOK9/sYvtrilbF2wQI2oxQ=;
        b=LdwWKlFJ6a0kpRkhEcQY2F8mUJBBA1FUVI1XREaDGaXks3svK4hfd3ioyaIkUVWo3m
         /CJmHwiCcty1Vb8uE0WaBJ/mkuhNSs+XljUy+9eQ18y16B9Ove8WJchefP7/bgikKg0Q
         KI57h1UN4ZZODntN4gIK+DYexAys64QQtOAM1d78FnT+xG8rg0PUY0Ag+iP7rPtvVLUC
         Lc7Y+61dytr/Sb/xt5aPB/4rbutPhVA91Mroho6BHF9TQnDACNLF1BAx+Jo9a/E7SAcb
         bW71A1ulovSLXYPHELh/PjPp5jJFutSYBEr60cE8B5eW1/suXDCmoRfLMWKV5edaCBr7
         8sbg==
X-Gm-Message-State: ANhLgQ2vpZn70I8aAnAEvbba/be/cMaKcfq2QkISPmDo0X4qrPP3NFQh
        6ZfcKfvShTrJ68QwBGfMVLwKOYPVsmLdvfHpopE=
X-Google-Smtp-Source: ADFU+vtxFcw/m7+IdfzfDbAik6d/Y6ae26Cbz4MXfbEAGpnD9L7g9luzyy8GB01zN79jHiTXwX1IVQXo25pS1vLK1xE=
X-Received: by 2002:a05:620a:88e:: with SMTP id b14mr5829364qka.449.1585181785282;
 Wed, 25 Mar 2020 17:16:25 -0700 (PDT)
MIME-Version: 1.0
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk> <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
In-Reply-To: <87369wrcyv.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 25 Mar 2020 17:16:13 -0700
Message-ID: <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
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

On Wed, Mar 25, 2020 at 2:38 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Tue, Mar 24, 2020 at 3:57 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Mon, Mar 23, 2020 at 12:23 PM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
> >> >>
> >> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >> >>
> >> >> > On Mon, Mar 23, 2020 at 4:24 AM Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@redhat.com> wrote:
> >> >> >>
> >> >> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >> >> >>
> >> >> >> > On Fri, Mar 20, 2020 at 11:31 AM John Fastabend
> >> >> >> > <john.fastabend@gmail.com> wrote:
> >> >> >> >>
> >> >> >> >> Jakub Kicinski wrote:
> >> >> >> >> > On Fri, 20 Mar 2020 09:48:10 +0100 Toke H=C3=B8iland-J=C3=
=B8rgensen wrote:
> >> >> >> >> > > Jakub Kicinski <kuba@kernel.org> writes:
> >> >> >> >> > > > On Thu, 19 Mar 2020 14:13:13 +0100 Toke H=C3=B8iland-J=
=C3=B8rgensen wrote:
> >> >> >> >> > > >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.co=
m>
> >> >> >> >> > > >>
> >> >> >> >> > > >> While it is currently possible for userspace to specif=
y that an existing
> >> >> >> >> > > >> XDP program should not be replaced when attaching to a=
n interface, there is
> >> >> >> >> > > >> no mechanism to safely replace a specific XDP program =
with another.
> >> >> >> >> > > >>
> >> >> >> >> > > >> This patch adds a new netlink attribute, IFLA_XDP_EXPE=
CTED_FD, which can be
> >> >> >> >> > > >> set along with IFLA_XDP_FD. If set, the kernel will ch=
eck that the program
> >> >> >> >> > > >> currently loaded on the interface matches the expected=
 one, and fail the
> >> >> >> >> > > >> operation if it does not. This corresponds to a 'cmpxc=
hg' memory operation.
> >> >> >> >> > > >>
> >> >> >> >> > > >> A new companion flag, XDP_FLAGS_EXPECT_FD, is also add=
ed to explicitly
> >> >> >> >> > > >> request checking of the EXPECTED_FD attribute. This is=
 needed for userspace
> >> >> >> >> > > >> to discover whether the kernel supports the new attrib=
ute.
> >> >> >> >> > > >>
> >> >> >> >> > > >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com>
> >> >> >> >> > > >
> >> >> >> >> > > > I didn't know we wanted to go ahead with this...
> >> >> >> >> > >
> >> >> >> >> > > Well, I'm aware of the bpf_link discussion, obviously. No=
t sure what's
> >> >> >> >> > > happening with that, though. So since this is a straight-=
forward
> >> >> >> >> > > extension of the existing API, that doesn't carry a high =
implementation
> >> >> >> >> > > cost, I figured I'd just go ahead with this. Doesn't mean=
 we can't have
> >> >> >> >> > > something similar in bpf_link as well, of course.
> >> >> >> >> >
> >> >> >> >> > I'm not really in the loop, but from what I overheard - I t=
hink the
> >> >> >> >> > bpf_link may be targeting something non-networking first.
> >> >> >> >>
> >> >> >> >> My preference is to avoid building two different APIs one for=
 XDP and another
> >> >> >> >> for everything else. If we have userlands that already unders=
tand links and
> >> >> >> >> pinning support is on the way imo lets use these APIs for net=
working as well.
> >> >> >> >
> >> >> >> > I agree here. And yes, I've been working on extending bpf_link=
 into
> >> >> >> > cgroup and then to XDP. We are still discussing some cgroup-sp=
ecific
> >> >> >> > details, but the patch is ready. I'm going to post it as an RF=
C to get
> >> >> >> > the discussion started, before we do this for XDP.
> >> >> >>
> >> >> >> Well, my reason for being skeptic about bpf_link and proposing t=
he
> >> >> >> netlink-based API is actually exactly this, but in reverse: With
> >> >> >> bpf_link we will be in the situation that everything related to =
a netdev
> >> >> >> is configured over netlink *except* XDP.
> >> >> >
> >> >> > One can argue that everything related to use of BPF is going to b=
e
> >> >> > uniform and done through BPF syscall? Given variety of possible B=
PF
> >> >> > hooks/targets, using custom ways to attach for all those many cas=
es is
> >> >> > really bad as well, so having a unifying concept and single entry=
 to
> >> >> > do this is good, no?
> >> >>
> >> >> Well, it depends on how you view the BPF subsystem's relation to th=
e
> >> >> rest of the kernel, I suppose. I tend to view it as a subsystem tha=
t
> >> >> provides a bunch of functionality, which you can setup (using "inte=
rnal"
> >> >> BPF APIs), and then attach that object to a different subsystem
> >> >> (networking) using that subsystem's configuration APIs.
> >> >>
> >> >> Seeing as this really boils down to a matter of taste, though, I'm =
not
> >> >> sure we'll find agreement on this :)
> >> >
> >> > Yeah, seems like so. But then again, your view and reality don't see=
m
> >> > to correlate completely. cgroup, a lot of tracing,
> >> > flow_dissector/lirc_mode2 attachments all are done through BPF
> >> > syscall.
> >>
> >> Well, I wasn't talking about any of those subsystems, I was talking
> >> about networking :)
> >
> > So it's not "BPF subsystem's relation to the rest of the kernel" from
> > your previous email, it's now only "talking about networking"? Since
> > when the rest of the kernel is networking?
>
> Not really, I would likely argue the same for any other subsystem, I

And you would like lose that argument :) You already agreed that for
tracing this is not the case. BPF is not attached by writing text into
ftrace's debugfs entries. Same for cgroups, we don't
create/update/write special files in cgroupfs, we have an explicit
attachment API in BPF.

BTW, kprobes started out with the same model as XDP has right now. You
had to do a bunch of magic writes into various debugfs files to attach
BPF program. If user-space application crashed, kprobe stayed
attached. This was horrible and led to many problems in real world
production uses. So a completely different interface was created,
allowing to do it through perf_event_open() and created anonymous
inode for BPF program attachment. That allowed crashing program to
auto-detach kprobe and not harm production use case.

Now we are coming after cgroup BPF programs, which have similar issues
and similar pains in production. cgroup BPF progs actually have extra
problems: programs can user-space applications can accidentally
replace a critical cgroup program and ruin the day for many folks that
have to deal with production breakage after that. Which is why I'm
implementing bpf_link with all its properties: to solve real pain and
real problem.

Now for XDP. It has same flawed model. And even if it seems to you
that it's not a big issue, and even if Jakub thinks we are trying to
solve non-existing problem, it is a real problem and a real concern
from people that have to support XDP in production with many
well-meaning developers developing BPF applications independently.
Copying what you wrote in another thread:

> Setting aside the question of which is the best abstraction to represent
> an attachment, it seems to me that the actual behavioural problem (XDP
> programs being overridden by mistake) would be solvable by this patch,
> assuming well-behaved userspace applications.

... this is a horrible and unrealistic assumption that we just cannot
make and accept. However well-behaved userspace applications are, they
are written by people that make mistakes. And rather than blissfully
expect that everything will be fine, we want to have enforcements in
place that will prevent some buggy application to wreck havoc in
production.

> just prefer to limit myself to talking about things I actually know
> something about. Hence, networking :)
>
> > But anyways, I think John addressed modern XDP networking issues in
> > his email very well already.
>
> Going to reply to that email next...
>
> >> In particular, networking already has a consistent and fairly
> >> well-designed configuration mechanism (i.e., netlink) that we are
> >> generally trying to move more functionality *towards* not *away from*
> >> (see, e.g., converting ethtool to use netlink).
> >>
> >> > LINK_CREATE provides an opportunity to finally unify all those
> >> > different ways to achieve the same "attach my BPF program to some
> >> > target object" semantics.
> >>
> >> Well I also happen to think that "attach a BPF program to an object" i=
s
> >> the wrong way to think about XDP. Rather, in my mind the model is
> >> "instruct the netdevice to execute this piece of BPF code".
> >
> > That can't be reconciled, so no point of arguing :) But thinking about
> > BPF in general, I think it's closer to attach BPF program thinking
> > (especially all the fexit/fentry, kprobe, etc), where objects that BPF
> > is attached to is not "active" in the sense of "calling BPF", it's
> > more of BPF system setting things up (attaching?) in such a way that
> > BPF program is executed when appropriate.
>
> I'd tend to agree with you on most of the tracing stuff, but not on
> this. But let's just agree to disagree here :)
>
> >> >> >> Other than that, I don't see any reason why the bpf_link API won=
't work.
> >> >> >> So I guess that if no one else has any problem with BPF insistin=
g on
> >> >> >> being a special snowflake, I guess I can live with it as well...=
 *shrugs* :)
> >> >> >
> >> >> > Apart from derogatory remark,
> >> >>
> >> >> Yeah, should have left out the 'snowflake' bit, sorry about that...
> >> >>
> >> >> > BPF is a bit special here, because it requires every potential BP=
F
> >> >> > hook (be it cgroups, xdp, perf_event, etc) to be aware of BPF
> >> >> > program(s) and execute them with special macro. So like it or not=
, it
> >> >> > is special and each driver supporting BPF needs to implement this=
 BPF
> >> >> > wiring.
> >> >>
> >> >> All that is about internal implementation, though. I'm bothered by =
the
> >> >> API discrepancy (i.e., from the user PoV we'll end up with: "netlin=
k is
> >> >> what you use to configure your netdev except if you want to attach =
an
> >> >> XDP program to it").
> >> >>
> >> >
> >> > See my reply to David. Depends on where you define user API. Is it
> >> > libbpf API, which is what most users are using? Or kernel API?
> >>
> >> Well I'm talking about the kernel<->userspace API, obviously :)
> >>
> >> > If everyone is using libbpf, does kernel system (bpf syscall vs
> >> > netlink) matter all that much?
> >>
> >> This argument works the other way as well, though: If libbpf can
> >> abstract the subsystem differences and provide a consistent interface =
to
> >> "the BPF world", why does BPF need to impose its own syscall API on th=
e
> >> networking subsystem?
> >
> > bpf_link in libbpf started as user-space abstraction only, but we
> > realized that it's not enough and there is a need to have proper
> > kernel support and corresponding kernel object, so it's not just
> > user-space API concerns.
> >
> > As for having netlink interface for creating link only for XDP. Why
> > duplicating and maintaining 2 interfaces?
>
> Totally agree; why do we need two interfaces? Let's keep the one we
> already have - the netlink interface! :)
>
> > All the other subsystems will go through bpf syscall, only XDP wants
> > to (also) have this through netlink. This means duplication of UAPI
> > for no added benefit. It's a LINK_CREATE operations, as well as
> > LINK_UPDATE operations. Do we need to duplicate LINK_QUERY (once its
> > implemented)? What if we'd like to support some other generic bpf_link
> > functionality, would it be ok to add it only to bpf syscall, or we
> > need to duplicate this in netlink as well?
>
> You're saying that like we didn't already have the netlink API. We
> essentially already have (the equivalent of) LINK_CREATE and LINK_QUERY,
> this is just adding LINK_UPDATE. It's a straight-forward fix of an
> existing API; essentially you're saying we should keep the old API in a
> crippled state in order to promote your (proposed) new API.

This is the fundamental disagreement that we seem to have. XDP's BPF
program attachment is not in any way equivalent to bpf_link. So no,
netlink API currently doesn't have anything that's close to bpf_link.
Let me try to summarize what bpf_link is and what are its fundamental
properties regardless of type of BPF programs.

1. bpf_link represents a connection (pairing?) of BPF program and some
BPF hook it is attached to. BPF hook could be perf event, cgroup,
netdev, etc. It's a completely independent object in itself, along the
bpf_map and bpf_prog, which has its own lifetime and kernel
representation. To user-space application it is returned as an
installed FD, similar to loaded BPF program and BPF map. It is
important that it's not just a BPF program, because BPF program can be
attached to multiple BPF hooks (e.g., same XDP program can be attached
to multiple interface; same kprobe handler can be installed multiple
times), which means that having BPF program FD isn't enough to
uniquely represent that one specific BPF program attachment and detach
it or query it. Having kernel object for this allows to encapsulate
all these various details of what is attached were and present to
user-space a single handle (FD) to work with.

2. Due to having FD associated with bpf_link, it's not possible to
talk about "owning" bpf_link. If application created link and never
shared its FD with any other application, it is the sole owner of it.
But it also means that you can share it, if you need it. Now, once
application closes FD or app crashes and kernel automatically closes
that FD, bpf_link refcount is decremented. If it was the last or only
FD, it will trigger automatica detachment and clean up of that
particular BPF program attachment. Note, not a clean up of BPF
program, which can still be attached somewhere else: only that
particular attachment.

3. This derives from the concept of ownership of bpf_link. Once
bpf_link is attached, no other application that doesn't own that
bpf_link can replace, detach or modify the link. For some cases it
doesn't matter. E.g., for tracing, all attachment to the same fentry
trampoline are completely independent. But for other cases this is
crucial property. E.g., when you attach BPF program in an exclusive
(single) mode, it means that particular cgroup and any of its children
cgroups can have any more BPF programs attached. This is important for
container management systems to enforce invariants and correct
functioning of the system. Right now it's very easy to violate that -
you just go and attach your own BPF program, and previous BPF program
gets automatically detached without original application that put it
there knowing about this. Chaos ensues after that and real people have
to deal with this. Which is why existing
BPF_PROG_ATTACH/BPF_PROG_DETACH API is inadequate and we are adding
bpf_link support.

Those same folks have similar concern with XDP. In the world where
container management installs "root" XDP program which other user
applications can plug into (libxdp use case, right?), it's crucial to
ensure that this root XDP program is not accidentally overwritten by
some well-meaning, but not overly cautious developer experimenting in
his own container with XDP programs. This is where bpf_link ownership
plays a huge role. Tupperware agent (FB's container management agent)
would install root XDP program and will hold onto this bpf_link
without sharing it with other applications. That will guarantee that
the system will be stable and can't be compromised.

Now, those were fundamental things, but I'd like to touch on a "nice
things we get with that". Having a proper kernel object representing
single instance of attached BPF program to some other kernel object
allows to build an uniform and consistent API around bpf_link with
same semantics. We can do LINK_UPDATE and allow to atomically replace
BPF program inside the established bpf_link. It's applicable to all
types of BPF program attachment and can be done in a way that ensures
no BPF program invocation is skipped while BPF programs are swapped
(because at the lowest level it boils down to an atomic pointer swap).
Of course not all bpf_links might have this support initially, but
we'll establish a lot of common infrastructure which will make it
simpler, faster and more reliable to add this functionality.

Similarly, we can have LINK_QUERY, which will return essential
information about attachment, particular to a specific kind of BPF
program attachment: BPF program ID itself, attach type, cgroup
ID/ifindex/perf event/whatever else we decide is good to report. If we
start allocating IDs for bpf_link, as Alexei mentioned, now you'll be
able to consistently iterate over all attached BPF programs,
regardless of their types, without a need to first iterate all
possible cgroups/netdevs, etc.

And to wrap up. I agree, consistent API is not a goal in itself, as
Jakub mentioned. But it is a worthy goal nevertheless, especially if
it doesn't cost anything extra. It makes kernel developers lives
easier, it makes library developers' lives easier, it makes it easier
to understand and learn BPF overall easier. If we have 10 different
bpf_link types, and 9 out of 10 are going to go through bpf syscall,
but 1 (guess which one?) will be done through netlink, it's not the
end of the world, of course, but that does sound weird. And people
making it sound like developing and attaching BPF program is as
trivial as using one netlink command are just trying to mislead.
Whoever does XDP development will have to learn quite a bit more about
BPF, so making BPF story more consistent and simpler is important for
networking people (who care about XDP, of course) as much as for any
tracing BPF developer.


>
> -Toke
>
