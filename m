Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC7719259A
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 11:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbgCYKaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 06:30:23 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:43882 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726073AbgCYKaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 06:30:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585132220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p6d6VXICummP69GWy3QH+MQ4ld6VD34B8srB1Dx6j88=;
        b=CJHBbFDwOYWhfyAVLZtGPGr92JkL0UR03p6Y+l15Z2/YShtXvQm3oJNkAABzqjHXLdYvia
        6JrCP+G8NLvaZ37krnGgS4exWNTacc2dvEwhq0Rl+E1XBtyA1xYv7dNMUsq6s2t+ZL9Qc3
        +aLFMzVd950Xdl31CW3mX+qvzWG8kto=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-nuq6sJOyNa2aRgkmFEeMpA-1; Wed, 25 Mar 2020 06:30:19 -0400
X-MC-Unique: nuq6sJOyNa2aRgkmFEeMpA-1
Received: by mail-lf1-f70.google.com with SMTP id q22so660022lfj.23
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 03:30:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=p6d6VXICummP69GWy3QH+MQ4ld6VD34B8srB1Dx6j88=;
        b=T3e2FRDxxA7XxltxuspSyTPaa+ypPoMh453DWHlQjq2Asgqwz4Yfuxx/8BUaDZQvnR
         q4s8SuunpdrIH6VLrnOkQ4qlGK5Ki5GwZIanNRCY36aO11XRk3biCCxYVG6A/toQumt5
         3wPYD52knxa4AbdPvqMWuwmk0deI8vzbo3vQFCGk6J9UrrElo3RbxXgwWhjJXswwZ5pI
         bkaE3baqF0Aj9WQRIbc9O9yXr7+InwIB4ra0ArwROrKAqGQWSiDjE1R3OHj8Xv/tg3EF
         spAqP8qDjgXTLNcugJn6X33DA895fI0iWmbUwAVFfB79EDvYt5A4AqTXSA7YCk8evFgE
         OOcw==
X-Gm-Message-State: ANhLgQ34xpC+j2kmRhCkKEp4UgWLJmdwCDlbFXz7LZiFx1HtlfdsMlwf
        BNuy5KLapDmmqjqYRdYVjnzQORlHlU3cxHEdGtDJkn5OLwt+Iw3kmer9it7phDAw2nYayN9DV8c
        lJBSQ8u8SJuYmuOZw
X-Received: by 2002:ac2:50c7:: with SMTP id h7mr1894141lfm.101.1585132217604;
        Wed, 25 Mar 2020 03:30:17 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsN2pvIjZQXDvxakshrQMB7alOQle7Geo5wCD2h5BpFqU7/IMDqxpXVHtN34mMVmUsrrwUO7A==
X-Received: by 2002:ac2:50c7:: with SMTP id h7mr1894122lfm.101.1585132217284;
        Wed, 25 Mar 2020 03:30:17 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id w29sm5853592lfq.27.2020.03.25.03.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 03:30:16 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 80EF418158B; Wed, 25 Mar 2020 11:30:15 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
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
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <5e7a5e07d85e8_74a82ad21f7a65b88d@john-XPS-13-9370.notmuch>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk> <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN> <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN> <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch> <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com> <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com> <87h7ye3mf3.fsf@toke.dk> <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com> <87tv2e10ly.fsf@toke.dk> <5e7a5e07d85e8_74a82ad21f7a65b88d@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 25 Mar 2020 11:30:15 +0100
Message-ID: <87zhc4pw08.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>=20
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
>>=20
>> Well, I wasn't talking about any of those subsystems, I was talking
>> about networking :)
>
> My experience has been that networking in the strict sense of XDP no
> longer exists on its own without cgroups, flow dissector, sockops,
> sockmap, tracing, etc. All of these pieces are built, patched, loaded,
> pinned and otherwise managed and manipulated as BPF objects via libbpf.
>
> Because I have all this infra in place for other items its a bit odd
> imo to drop out of BPF apis to then swap a program differently in the
> XDP case from how I would swap a program in any other place. I'm
> assuming ability to swap links will be enabled at some point.
>
> Granted it just means I have some extra functions on the side to manage
> the swap similar to how 'qdisc' would be handled today but still not as
> nice an experience in my case as if it was handled natively.

From a BPF application developer PoV I can totally understand the desire
for unified APIs. But that unification can still be achieved at the
libbpf level, while keeping network interface configuration done through
netlink.

> Anyways the netlink API is going to have to call into the BPF infra
> on the kernel side for verification, etc so its already not pure
> networking.

Yes, obviously there are *interactions* between the networking stack and
BPF. But the program attach is still interface configuration. The
netlink operation says "please configure this netdev to hook into the
BPF subsystem with this program".

>> In particular, networking already has a consistent and fairly
>> well-designed configuration mechanism (i.e., netlink) that we are
>> generally trying to move more functionality *towards* not *away from*
>> (see, e.g., converting ethtool to use netlink).
>
> True. But BPF programs are going to exist and interop with other
> programs not exactly in the networking space. Actually library calls
> might be used in tracing, cgroups, and XDP side. It gets a bit more
> interesting if the "same" object file (with some patching) runs in both
> XDP and sockops land for example.

Not really sure why that makes a difference, actually? There will still
be a point at which the network interface configuration is updated to
point to a (new) BPF program.

>> > LINK_CREATE provides an opportunity to finally unify all those
>> > different ways to achieve the same "attach my BPF program to some
>> > target object" semantics.
>>=20
>> Well I also happen to think that "attach a BPF program to an object" is
>> the wrong way to think about XDP. Rather, in my mind the model is
>> "instruct the netdevice to execute this piece of BPF code".
>>=20
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
>>=20
>> Well I'm talking about the kernel<->userspace API, obviously :)
>>=20
>> > If everyone is using libbpf, does kernel system (bpf syscall vs
>> > netlink) matter all that much?
>>=20
>> This argument works the other way as well, though: If libbpf can
>> abstract the subsystem differences and provide a consistent interface to
>> "the BPF world", why does BPF need to impose its own syscall API on the
>> networking subsystem?
>
> I can make it work either way as a netlink or syscall its not going
> to be a blocker. If we go netlink route then the next question is
> does libbpf pull in the ability to swap XDP progs via netlink or
> is that some other lib?

Not sure what you mean by this? This series does update libbpf with the
new API?

-Toke

