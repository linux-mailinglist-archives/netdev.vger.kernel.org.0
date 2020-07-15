Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1201C2216A5
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 22:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGOUyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 16:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGOUyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 16:54:43 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F731C061755;
        Wed, 15 Jul 2020 13:54:43 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id k18so3276279qke.4;
        Wed, 15 Jul 2020 13:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lAjVKcvIk+tDIWEArAlFDV7549bVLGJFEAvtfK0+OSE=;
        b=lRwdnyL+PJDLdJyKeLZIMpxN+TOAENa29U6L0RE/z2CsbF5FajTFsZx0Ozxj1vSbel
         AX/3Bm1feFBwycnnyz6KIUnlXxLkF0LHXCV+fAL21ccjgVXLrXR5DPj7M7hsqzLhR5ew
         +cTm7SmL2w4Ou/TjQYO7lDNzNpqe+MkgiEmTHyomU9sRRzla3MlGMMe4F9bEakiFIKW0
         eUpLUDCos8i6DxlW4OzTOAoyyHsk1rqkqyJeJ9rLbAgcwfLaOshrja+iwlBUn0kp55z4
         JXDRDpyXOlorzA+OUbUXjA6TVfC1BMU8VuBtoosE4GGJ5/Bxzp5lm3vsxz7NUlsnMOnV
         mW7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lAjVKcvIk+tDIWEArAlFDV7549bVLGJFEAvtfK0+OSE=;
        b=rPAQPPlIBrP1jf/2jLoBVU/WWu04PtU92mMOKBiMjQvbYNo8bQEIO6MsVsg2MIgPyr
         O3TgzOmuLYbSilWeD9K/X1maoRPqP6yyzQKub7DfUQgycdD6nIuxz9gUBLh0KnzfL+3h
         XhkzJnXgfClJHXRNwPFMIDEljyf5W6nercdHb+0Uq8ZtKLONPMYoNm4jB2IPKM4s9Ntp
         vhOVFr7Sxpry3C4FG9NBWWtatIBszz21lET/fYXufn9N8NLh/bikDUMtiMRlbutP0sWU
         fcGjEO5cRStFty1rt/jWRZuu6oTJtOBCaosVGkqavPqYITOH/UFEMa5F40srkFldPyrR
         L04w==
X-Gm-Message-State: AOAM530TNe1rsQV0Qtz47fNLoJ4Df6iXpA3lYuz/E7aRrD1QQNeV/SVl
        F5RJtIT4wVStDXXw81T9Mvp3YpZzBB/LxNKuT4mzzFYv
X-Google-Smtp-Source: ABdhPJwwKChtJpIvv1HUyTPOeD1tq7z0pgc7oErUq5MLoeMt3vL6v4MIVPIVJgLygTi22BDrEBCsF9Pv1Uy38lvckwY=
X-Received: by 2002:ae9:f002:: with SMTP id l2mr939290qkg.437.1594846482401;
 Wed, 15 Jul 2020 13:54:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200710224924.4087399-1-andriin@fb.com> <20200710224924.4087399-3-andriin@fb.com>
 <877dv6gpxd.fsf@toke.dk> <CAEf4BzY7qRsdcdhzf2--Bfgo-GB=ZoKKizOb+OHO7o2PMiNubA@mail.gmail.com>
 <87v9ipg8jd.fsf@toke.dk> <CAEf4BzYVEqFUJybw3kjG6E6w12ocr2ncRz7j15GNNGG4BXJMTw@mail.gmail.com>
 <87lfjlg4fg.fsf@toke.dk> <CAEf4BzYMaKgJOA3koGkcThXriTGAOKGxjhQXYSNT9sVEFbS7ig@mail.gmail.com>
 <87y2nkeq4s.fsf@toke.dk>
In-Reply-To: <87y2nkeq4s.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jul 2020 13:54:31 -0700
Message-ID: <CAEf4BzbgPqN8xKX5xpHBRMJSZkhz_BBzBg7r_FPRo=j3ZmLNUQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/7] bpf, xdp: add bpf_link-based XDP attachment API
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kicinski@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Takshak Chahande <ctakshak@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 8:48 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> >> Yup, that was helpful, thanks! I think our difference of opinion on th=
is
> >> stems from the same place as our disagreement about point 2.: You are
> >> assuming that an application that uses XDP sticks around and holds on =
to
> >> its bpf_link, while I'm assuming it doesn't (and so has to rely on
> >> pinning for any persistence). In the latter case you don't really gain
> >> much from the bpf_link auto-cleanup, and whether it's a prog fd or a
> >> link fd you go find in your bpffs doesn't make that much difference...
> >
> > Right. But if I had to pick just one implementation (prog fd-based vs
> > bpf_link), I'd stick with bpf_link because it is flexible enough to
> > "emulate" prog fd attachment (through BPF FS), but the same isn't true
> > about prog fd attachment emulating bpf_link. That's it. I really don't
> > enjoy harping on that point, but it feels to be silently dismissed all
> > the time based on one particular arrangement for particular existing
> > XDP flow.
>
> It can; kinda. But you introduce a dependency on bpffs that wasn't there
> before, and you end up with resources that are kept around in the kernel
> if the interface disappears (because they are still pinned). So I
> consider it a poor emulation.

Yes, it's not exactly 100% the same semantics.
It is possible with slight additions to API to support essentially
exactly the same semantics you want with prog attachment. E.g., we can
either have a flag at LINK_CREATE time, or a separate command (e.g.,
LINK_PIN or something), that would mark bpf_link as "sticky", bump
it's refcnt. What happens then is that even if last FD is closed,
there is still refcnt 1 there, and then there are two ways to detach
that link:

1) interface/cgroup/whatever is destroyed and bpf_link is
auto-detached. At that point auto-detach handler will see that it's a
"sticky" bpf_link, will decrement refcnt and subsequently free
bpf_link kernel object (unless some application still has FD open, of
course).

2) a new LINK_DESTROY BPF command will be introduced, which will only
work with "sticky" bpf_links. It will decrement refcnt and do the same
stuff as the auto-detach handler does today (so bpf_link->dev =3D NULL,
for XDP link).

I don't mind this, as long as this is not a default semantics and
require conscious opt-in from whoever creates the link.

>
> >> >> >> I was under the impression that forcible attachment of bpf_links=
 was
> >> >> >> already possible, but looking at the code now it doesn't appear =
to be?
> >> >> >> Wasn't that the whole point of BPF_LINK_GET_FD_BY_ID? I.e., that=
 a
> >> >> >> sysadmin with CAP_SYS_ADMIN privs could grab the offending bpf_l=
ink FD
> >> >> >> and force-remove it? I certainly think this should be added befo=
re we
> >> >> >> expand bpf_link usage any more...
> >> >> >
> >> >> > I still maintain that killing processes that installed the bpf_li=
nk is
> >> >> > the better approach. Instead of letting the process believe and a=
ct as
> >> >> > if it has an active XDP program, while it doesn't, it's better to
> >> >> > altogether kill/restart the process.
> >> >>
> >> >> Killing the process seems like a very blunt tool, though. Say it's =
a
> >> >> daemon that attaches XDP programs to all available interfaces, but =
you
> >> >> want to bring down an interface for some one-off maintenance task, =
but
> >> >> the daemon authors neglected to provide an interface to tell the da=
emon
> >> >> to detach from specific interfaces. If your only option is to kill =
the
> >> >> daemon, you can't bring down that interface without disrupting what=
ever
> >> >> that daemon is doing with XDP on all the other interfaces.
> >> >>
> >> >
> >> > I'd rather avoid addressing made up hypothetical cases, really. Get
> >> > better and more flexible daemon?
> >>
> >> I know you guys don't consider an issue to be real until it has alread=
y
> >> crashed something in production. But some of us don't have the luxury =
of
> >> your fast issue-discovered-to-fix-shipped turnaround times; so instead
> >> we have to go with the old-fashioned way of thinking about how things
> >> can go wrong ahead of time, and making sure we're prepared to handle
> >> issues if (or, all too often, when) they occur. And it's frankly
> >> tiresome to have all such efforts be dismissed as "made up
> >> hypotheticals". Please consider that the whole world does not operate
> >> like your org, and that there may be legitimate reasons to do things
> >> differently.
> >>
> >
> > Having something that breaks production is a very hard evidence of a
> > problem and makes it easier to better understand a **real** issue well
> > and argue why something has to be solved or prevented. But it's not a
> > necessary condition, of course. It's just that made up hypotheticals
> > aren't necessarily good ways to motivate a feature, because all too
> > often it turns out to be just that, hypothetical issue, while the real
> > issue is different enough to warrant a different and better solution.
> > By being conservative with adding features, we are trying to not make
> > unnecessary design and API mistakes, because in the kernel they are
> > here to stay forever.
>
> I do appreciate the need to be conservative with the interfaces we add,
> and I am aware of the maintenance burden. And it's not like I want
> contingencies for any hypothetical I can think of put into the kernel
> ahead of time (talk about a never-ending process :)). What I'm asking
> for is just that something be argued on its merits, instead of
> *automatically* being dismissed as "hypothetical". I.e., the difference
> between "that can be handled by..." or "that is not likely to occur
> because...", as opposed to "that has not happened yet, so come back when
> it does".
>
> > In your example, I'd argue that the design of that daemon is bad if it
> > doesn't allow you to control what's attached where, and how to detach
> > it without breaking completely independent network interfaces. That
> > should be the problem that has to be solved first, IMO. And just
> > because in some scenarios it might be **convenient** to force-detach
> > bpf_link, is in no way a good justification (in my book) to add that
> > feature, especially if there are other (and arguably safer) ways to
> > achieve the same **troubleshooting** effect.
>
> See this is actually what was I asking for - considering a question on
> its merits; so thank you!

Honestly, I was hoping this is more or less obvious, which is why I
didn't go into a lengthy explanation originally. There is only so much
time in a day, unfortunately. So "hypothetical" example was more of
"it doesn't happen today, but when it happens, it should be solved
differently", in my opinion, of course. But anyways, as you say, we
can leave this aside, no need to waste more time on this.

> And yeah, it would be a poorly designed
> daemon, but I'm not quite convinced that such daemons won't show up and
> be put into production by, say, someone running an enterprise operating
> system :)
>
> Anyway, let's leave that particular issue aside for now, and I'll circle
> back to adding the force-remove if needed once I've thought this over a
> bit more.
>
> >> That being said...
> >>
> >> > This force-detach functionality isn't hard to add, but so far we had
> >> > no real reason to do that. Once we do have such use cases, we can ad=
d
> >> > it, if we agree it's still a good idea.
> >>
> >> ...this is fair enough, and I guess I should just put this on my list =
of
> >> things to add. I was just somehow under the impression that this had
> >> already been added.
> >>
> >
> > So, overall, do I understand correctly that you are in principle not
> > opposed to adding BPF XDP link, or you still have some concerns that
> > were not addressed?
>
> Broadly speaking yeah, I am OK with adding this as a second interface. I
> am still concerned about the "locking in place" issued we discussed
> above, but that can be addressed later. I am also a little concerned

Right, see above the "extensions" I outlined to make those bpf_links
have auto-cleanup semantics, similar to prog attachment today.

> about adding a second interface for configuring an interface that has to
> take the RTNL lock etc; but those are mostly details, I suppose.
>
> Unfortunately I won't have to review the latest version of your patch
> set to look at those details before I go on vacation (sorry about that :/=
).
> I guess I'll just have to leave that to you guys to take care of...
>

Sure, thanks, enjoy your vacation! I'll post v3 then with build fixes
I have so far.

> -Toke
>
