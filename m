Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAB71904BC
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 06:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgCXFAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 01:00:20 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44555 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgCXFAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 01:00:19 -0400
Received: by mail-qt1-f196.google.com with SMTP id x16so4853726qts.11;
        Mon, 23 Mar 2020 22:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=50zVRkDcQtwi0/oGv9tJ2FCn7Xsuo9zQEn3t+RZmww8=;
        b=pFJcPcXRnBOjtI/K1x5vh+g36oeGleUjexTuEURmIAIgOyCdB8TiViP288/hGaVBPZ
         O2dgP1x8JXG9RghSjMM7TFJ5ZYtp21JxwIckUhOSaNfcy8age9+dHCO4mEnV1FbeqBTP
         z4w4wV9dyuCNEF53H5S4ytlm/NX9BP/Idp1Fv23KlTycVoZ5dsMC2WVQjvhyT9Z7+5tX
         KFFF6JQvdtekuoOikxwcVXDX+P8WR8lyThAqT1I1SC3R40Y4ZkZ8w7xF6IKsfD4psa5W
         cKiakb2gppq9SNgXvHklpa2TP8bnplcWsTNV9VAEZCA9NZhH6TsUvGqR91sboJ1nkhDi
         gBNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=50zVRkDcQtwi0/oGv9tJ2FCn7Xsuo9zQEn3t+RZmww8=;
        b=TOsCrv4a6h5hpVkoQWui7HDmvp63aOs2YChxw8EePzJf/E1pwcKDMRrk7IgTV3LbYB
         vNFyXhJ47+7W9g2CnZGWpQvGJCGQdfjtn6RJUSOnL9cz/A7kvz5ggkcwXbdUswI5L5nR
         QMAT2V3cfCSLt5RVgSNL2OLuHkPtm5EL9VALsI9ITklqQqlNs/qZPopxkkWaPv0nyWG9
         klN8isLtBeGB3/Am9c/En0y+6o6dSRqhDTQSYcYVn9fcJiESQ3ruzWouYDMbSFyglUpf
         9L5AsXFfdERp6fKutPi6R6wvF7vEn1Is30PbKZfftk7Pzskujqx/FTQEgMpgcB8nsHws
         0WSQ==
X-Gm-Message-State: ANhLgQ2iGV03xue4fmjnsbjozKz06qY4dUXZos1LBv0c2yCn/q6if+R5
        QWmrk2w76S2GD8TkexMPdIvFegSwULg1SzCjVbU=
X-Google-Smtp-Source: ADFU+vtfaBcjg/vNBlGeOUsvL13jNmwIOxAi63+2FjerNutdjNLPu1DUHS+oNydUr6D/RubWwYZlNxzbk1Td8cjPgr0=
X-Received: by 2002:ac8:1865:: with SMTP id n34mr23661598qtk.93.1585026017993;
 Mon, 23 Mar 2020 22:00:17 -0700 (PDT)
MIME-Version: 1.0
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
In-Reply-To: <87h7ye3mf3.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Mar 2020 22:00:06 -0700
Message-ID: <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
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

On Mon, Mar 23, 2020 at 12:23 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Mon, Mar 23, 2020 at 4:24 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Fri, Mar 20, 2020 at 11:31 AM John Fastabend
> >> > <john.fastabend@gmail.com> wrote:
> >> >>
> >> >> Jakub Kicinski wrote:
> >> >> > On Fri, 20 Mar 2020 09:48:10 +0100 Toke H=C3=B8iland-J=C3=B8rgens=
en wrote:
> >> >> > > Jakub Kicinski <kuba@kernel.org> writes:
> >> >> > > > On Thu, 19 Mar 2020 14:13:13 +0100 Toke H=C3=B8iland-J=C3=B8r=
gensen wrote:
> >> >> > > >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >> > > >>
> >> >> > > >> While it is currently possible for userspace to specify that=
 an existing
> >> >> > > >> XDP program should not be replaced when attaching to an inte=
rface, there is
> >> >> > > >> no mechanism to safely replace a specific XDP program with a=
nother.
> >> >> > > >>
> >> >> > > >> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_F=
D, which can be
> >> >> > > >> set along with IFLA_XDP_FD. If set, the kernel will check th=
at the program
> >> >> > > >> currently loaded on the interface matches the expected one, =
and fail the
> >> >> > > >> operation if it does not. This corresponds to a 'cmpxchg' me=
mory operation.
> >> >> > > >>
> >> >> > > >> A new companion flag, XDP_FLAGS_EXPECT_FD, is also added to =
explicitly
> >> >> > > >> request checking of the EXPECTED_FD attribute. This is neede=
d for userspace
> >> >> > > >> to discover whether the kernel supports the new attribute.
> >> >> > > >>
> >> >> > > >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com>
> >> >> > > >
> >> >> > > > I didn't know we wanted to go ahead with this...
> >> >> > >
> >> >> > > Well, I'm aware of the bpf_link discussion, obviously. Not sure=
 what's
> >> >> > > happening with that, though. So since this is a straight-forwar=
d
> >> >> > > extension of the existing API, that doesn't carry a high implem=
entation
> >> >> > > cost, I figured I'd just go ahead with this. Doesn't mean we ca=
n't have
> >> >> > > something similar in bpf_link as well, of course.
> >> >> >
> >> >> > I'm not really in the loop, but from what I overheard - I think t=
he
> >> >> > bpf_link may be targeting something non-networking first.
> >> >>
> >> >> My preference is to avoid building two different APIs one for XDP a=
nd another
> >> >> for everything else. If we have userlands that already understand l=
inks and
> >> >> pinning support is on the way imo lets use these APIs for networkin=
g as well.
> >> >
> >> > I agree here. And yes, I've been working on extending bpf_link into
> >> > cgroup and then to XDP. We are still discussing some cgroup-specific
> >> > details, but the patch is ready. I'm going to post it as an RFC to g=
et
> >> > the discussion started, before we do this for XDP.
> >>
> >> Well, my reason for being skeptic about bpf_link and proposing the
> >> netlink-based API is actually exactly this, but in reverse: With
> >> bpf_link we will be in the situation that everything related to a netd=
ev
> >> is configured over netlink *except* XDP.
> >
> > One can argue that everything related to use of BPF is going to be
> > uniform and done through BPF syscall? Given variety of possible BPF
> > hooks/targets, using custom ways to attach for all those many cases is
> > really bad as well, so having a unifying concept and single entry to
> > do this is good, no?
>
> Well, it depends on how you view the BPF subsystem's relation to the
> rest of the kernel, I suppose. I tend to view it as a subsystem that
> provides a bunch of functionality, which you can setup (using "internal"
> BPF APIs), and then attach that object to a different subsystem
> (networking) using that subsystem's configuration APIs.
>
> Seeing as this really boils down to a matter of taste, though, I'm not
> sure we'll find agreement on this :)

Yeah, seems like so. But then again, your view and reality don't seem
to correlate completely. cgroup, a lot of tracing,
flow_dissector/lirc_mode2 attachments all are done through BPF
syscall. LINK_CREATE provides an opportunity to finally unify all
those different ways to achieve the same "attach my BPF program to
some target object" semantics.

>
> >> Other than that, I don't see any reason why the bpf_link API won't wor=
k.
> >> So I guess that if no one else has any problem with BPF insisting on
> >> being a special snowflake, I guess I can live with it as well... *shru=
gs* :)
> >
> > Apart from derogatory remark,
>
> Yeah, should have left out the 'snowflake' bit, sorry about that...
>
> > BPF is a bit special here, because it requires every potential BPF
> > hook (be it cgroups, xdp, perf_event, etc) to be aware of BPF
> > program(s) and execute them with special macro. So like it or not, it
> > is special and each driver supporting BPF needs to implement this BPF
> > wiring.
>
> All that is about internal implementation, though. I'm bothered by the
> API discrepancy (i.e., from the user PoV we'll end up with: "netlink is
> what you use to configure your netdev except if you want to attach an
> XDP program to it").
>

See my reply to David. Depends on where you define user API. Is it
libbpf API, which is what most users are using? Or kernel API? If
everyone is using libbpf, does kernel system (bpf syscall vs netlink)
matter all that much?

Also, isn't this "netlink for configuring, except attaching XDP" rule
the case for XDP today anyway? You set up your netdev with netlink,
then go use libbpf's bpf_set_link_xdp_fd()? Where's netlink in the
latter? :)

> -Toke
>
