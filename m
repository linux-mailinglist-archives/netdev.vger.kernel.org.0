Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B02B2192452
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 10:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbgCYJik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 05:38:40 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:52315 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726103AbgCYJik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 05:38:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585129118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d0u7Se1AWHcN3G4Gr8eFFfZ+MuVOQoNkDeGwbCCLK2E=;
        b=eKAH7F7Jx/Rr7+83lqau9jhD8x+o5BQKknAU3TFswaYg2HqN1dr9Ura7ohR0Jbgty4NsZG
        9E2afJsIITEe0tAmXjDbMHYFGAE3MDvY+vrx97nLamOwXSyk1dPblH2j+XEjgjrQFv/flw
        w25Wo4fclFX0wNU3BBEf7n+GJykTFI0=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-TM_91owpMai_fQLbfxT_bg-1; Wed, 25 Mar 2020 05:38:36 -0400
X-MC-Unique: TM_91owpMai_fQLbfxT_bg-1
Received: by mail-lf1-f69.google.com with SMTP id f27so615754lfj.16
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 02:38:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=d0u7Se1AWHcN3G4Gr8eFFfZ+MuVOQoNkDeGwbCCLK2E=;
        b=KXDbTUIYfu2CZjTQE4xG+4an5HPtIt7pUulyzCEVTuk41nXvyP2vFxLvbmB8aSOiGQ
         gMN/uTNVbUrBb2NZjA24jRDmq32NmrCriXYB8usSmR0VBH3YCPG8ix479wwtBHHtJdY8
         agWDPoGO8ttCihEiuNVgmWE/Ff7H1rT5pQ/Yby3yqP/HvEhCr7+MiyLYt88p77TOy8rj
         zCkC4auuJe+s5kaRDV8hy8BFYR+yA3VDcdpqm10E2arslvrM+q2CIPVBOYBgXsejUA1c
         n5/lUSNOr0O0yypILHHEcyQE3E6AbdRtNSHJG/GZ27wcaDLAFH73g2qvu45HwciFLRJm
         V1aw==
X-Gm-Message-State: ANhLgQ2kTW38MTrkh9697U4m3Qj/s9903TrlYuCP1hYSujJXrx/fiaZ3
        jQVSW3KaJpOqGZmxsaOPPHE+Mugh2x7pPQTbqBnqJLRSA6B0Uen1dnPlNyWoEU9ijvVXQtRhJYL
        H31DFqjXxV4TJX4cj
X-Received: by 2002:ac2:4a88:: with SMTP id l8mr1712517lfp.138.1585129114715;
        Wed, 25 Mar 2020 02:38:34 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvdE+0B2Ni60oKvTu0OjLLzlrBU0agYSqxNanwjNCdYxAEpZ+Ff8HWVtxneZ6UTPHlQBX85uA==
X-Received: by 2002:ac2:4a88:: with SMTP id l8mr1712494lfp.138.1585129114288;
        Wed, 25 Mar 2020 02:38:34 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id j5sm11454835lfk.73.2020.03.25.02.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 02:38:33 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7A78D18158B; Wed, 25 Mar 2020 10:38:32 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk> <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN> <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN> <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch> <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com> <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com> <87h7ye3mf3.fsf@toke.dk> <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com> <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 25 Mar 2020 10:38:32 +0100
Message-ID: <87369wrcyv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Mar 24, 2020 at 3:57 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Mon, Mar 23, 2020 at 12:23 PM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
>> >>
>> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>> >>
>> >> > On Mon, Mar 23, 2020 at 4:24 AM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
>> >> >>
>> >> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>> >> >>
>> >> >> > On Fri, Mar 20, 2020 at 11:31 AM John Fastabend
>> >> >> > <john.fastabend@gmail.com> wrote:
>> >> >> >>
>> >> >> >> Jakub Kicinski wrote:
>> >> >> >> > On Fri, 20 Mar 2020 09:48:10 +0100 Toke H=C3=B8iland-J=C3=B8r=
gensen wrote:
>> >> >> >> > > Jakub Kicinski <kuba@kernel.org> writes:
>> >> >> >> > > > On Thu, 19 Mar 2020 14:13:13 +0100 Toke H=C3=B8iland-J=C3=
=B8rgensen wrote:
>> >> >> >> > > >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >> >> >> > > >>
>> >> >> >> > > >> While it is currently possible for userspace to specify =
that an existing
>> >> >> >> > > >> XDP program should not be replaced when attaching to an =
interface, there is
>> >> >> >> > > >> no mechanism to safely replace a specific XDP program wi=
th another.
>> >> >> >> > > >>
>> >> >> >> > > >> This patch adds a new netlink attribute, IFLA_XDP_EXPECT=
ED_FD, which can be
>> >> >> >> > > >> set along with IFLA_XDP_FD. If set, the kernel will chec=
k that the program
>> >> >> >> > > >> currently loaded on the interface matches the expected o=
ne, and fail the
>> >> >> >> > > >> operation if it does not. This corresponds to a 'cmpxchg=
' memory operation.
>> >> >> >> > > >>
>> >> >> >> > > >> A new companion flag, XDP_FLAGS_EXPECT_FD, is also added=
 to explicitly
>> >> >> >> > > >> request checking of the EXPECTED_FD attribute. This is n=
eeded for userspace
>> >> >> >> > > >> to discover whether the kernel supports the new attribut=
e.
>> >> >> >> > > >>
>> >> >> >> > > >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com>
>> >> >> >> > > >
>> >> >> >> > > > I didn't know we wanted to go ahead with this...
>> >> >> >> > >
>> >> >> >> > > Well, I'm aware of the bpf_link discussion, obviously. Not =
sure what's
>> >> >> >> > > happening with that, though. So since this is a straight-fo=
rward
>> >> >> >> > > extension of the existing API, that doesn't carry a high im=
plementation
>> >> >> >> > > cost, I figured I'd just go ahead with this. Doesn't mean w=
e can't have
>> >> >> >> > > something similar in bpf_link as well, of course.
>> >> >> >> >
>> >> >> >> > I'm not really in the loop, but from what I overheard - I thi=
nk the
>> >> >> >> > bpf_link may be targeting something non-networking first.
>> >> >> >>
>> >> >> >> My preference is to avoid building two different APIs one for X=
DP and another
>> >> >> >> for everything else. If we have userlands that already understa=
nd links and
>> >> >> >> pinning support is on the way imo lets use these APIs for netwo=
rking as well.
>> >> >> >
>> >> >> > I agree here. And yes, I've been working on extending bpf_link i=
nto
>> >> >> > cgroup and then to XDP. We are still discussing some cgroup-spec=
ific
>> >> >> > details, but the patch is ready. I'm going to post it as an RFC =
to get
>> >> >> > the discussion started, before we do this for XDP.
>> >> >>
>> >> >> Well, my reason for being skeptic about bpf_link and proposing the
>> >> >> netlink-based API is actually exactly this, but in reverse: With
>> >> >> bpf_link we will be in the situation that everything related to a =
netdev
>> >> >> is configured over netlink *except* XDP.
>> >> >
>> >> > One can argue that everything related to use of BPF is going to be
>> >> > uniform and done through BPF syscall? Given variety of possible BPF
>> >> > hooks/targets, using custom ways to attach for all those many cases=
 is
>> >> > really bad as well, so having a unifying concept and single entry to
>> >> > do this is good, no?
>> >>
>> >> Well, it depends on how you view the BPF subsystem's relation to the
>> >> rest of the kernel, I suppose. I tend to view it as a subsystem that
>> >> provides a bunch of functionality, which you can setup (using "intern=
al"
>> >> BPF APIs), and then attach that object to a different subsystem
>> >> (networking) using that subsystem's configuration APIs.
>> >>
>> >> Seeing as this really boils down to a matter of taste, though, I'm not
>> >> sure we'll find agreement on this :)
>> >
>> > Yeah, seems like so. But then again, your view and reality don't seem
>> > to correlate completely. cgroup, a lot of tracing,
>> > flow_dissector/lirc_mode2 attachments all are done through BPF
>> > syscall.
>>
>> Well, I wasn't talking about any of those subsystems, I was talking
>> about networking :)
>
> So it's not "BPF subsystem's relation to the rest of the kernel" from
> your previous email, it's now only "talking about networking"? Since
> when the rest of the kernel is networking?

Not really, I would likely argue the same for any other subsystem, I
just prefer to limit myself to talking about things I actually know
something about. Hence, networking :)

> But anyways, I think John addressed modern XDP networking issues in
> his email very well already.

Going to reply to that email next...

>> In particular, networking already has a consistent and fairly
>> well-designed configuration mechanism (i.e., netlink) that we are
>> generally trying to move more functionality *towards* not *away from*
>> (see, e.g., converting ethtool to use netlink).
>>
>> > LINK_CREATE provides an opportunity to finally unify all those
>> > different ways to achieve the same "attach my BPF program to some
>> > target object" semantics.
>>
>> Well I also happen to think that "attach a BPF program to an object" is
>> the wrong way to think about XDP. Rather, in my mind the model is
>> "instruct the netdevice to execute this piece of BPF code".
>
> That can't be reconciled, so no point of arguing :) But thinking about
> BPF in general, I think it's closer to attach BPF program thinking
> (especially all the fexit/fentry, kprobe, etc), where objects that BPF
> is attached to is not "active" in the sense of "calling BPF", it's
> more of BPF system setting things up (attaching?) in such a way that
> BPF program is executed when appropriate.

I'd tend to agree with you on most of the tracing stuff, but not on
this. But let's just agree to disagree here :)

>> >> >> Other than that, I don't see any reason why the bpf_link API won't=
 work.
>> >> >> So I guess that if no one else has any problem with BPF insisting =
on
>> >> >> being a special snowflake, I guess I can live with it as well... *=
shrugs* :)
>> >> >
>> >> > Apart from derogatory remark,
>> >>
>> >> Yeah, should have left out the 'snowflake' bit, sorry about that...
>> >>
>> >> > BPF is a bit special here, because it requires every potential BPF
>> >> > hook (be it cgroups, xdp, perf_event, etc) to be aware of BPF
>> >> > program(s) and execute them with special macro. So like it or not, =
it
>> >> > is special and each driver supporting BPF needs to implement this B=
PF
>> >> > wiring.
>> >>
>> >> All that is about internal implementation, though. I'm bothered by the
>> >> API discrepancy (i.e., from the user PoV we'll end up with: "netlink =
is
>> >> what you use to configure your netdev except if you want to attach an
>> >> XDP program to it").
>> >>
>> >
>> > See my reply to David. Depends on where you define user API. Is it
>> > libbpf API, which is what most users are using? Or kernel API?
>>
>> Well I'm talking about the kernel<->userspace API, obviously :)
>>
>> > If everyone is using libbpf, does kernel system (bpf syscall vs
>> > netlink) matter all that much?
>>
>> This argument works the other way as well, though: If libbpf can
>> abstract the subsystem differences and provide a consistent interface to
>> "the BPF world", why does BPF need to impose its own syscall API on the
>> networking subsystem?
>
> bpf_link in libbpf started as user-space abstraction only, but we
> realized that it's not enough and there is a need to have proper
> kernel support and corresponding kernel object, so it's not just
> user-space API concerns.
>
> As for having netlink interface for creating link only for XDP. Why
> duplicating and maintaining 2 interfaces?

Totally agree; why do we need two interfaces? Let's keep the one we
already have - the netlink interface! :)

> All the other subsystems will go through bpf syscall, only XDP wants
> to (also) have this through netlink. This means duplication of UAPI
> for no added benefit. It's a LINK_CREATE operations, as well as
> LINK_UPDATE operations. Do we need to duplicate LINK_QUERY (once its
> implemented)? What if we'd like to support some other generic bpf_link
> functionality, would it be ok to add it only to bpf syscall, or we
> need to duplicate this in netlink as well?

You're saying that like we didn't already have the netlink API. We
essentially already have (the equivalent of) LINK_CREATE and LINK_QUERY,
this is just adding LINK_UPDATE. It's a straight-forward fix of an
existing API; essentially you're saying we should keep the old API in a
crippled state in order to promote your (proposed) new API.

-Toke

