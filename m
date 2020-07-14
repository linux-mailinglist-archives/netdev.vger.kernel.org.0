Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CB8220094
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 00:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgGNW1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 18:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgGNW1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 18:27:02 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208F3C061755;
        Tue, 14 Jul 2020 15:27:02 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id x62so198658qtd.3;
        Tue, 14 Jul 2020 15:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0IzJzqHGwWv7wQ6mENCP14+oAuB2grwAnb2RdHZ7yh4=;
        b=FKn1i4gVczRcmwJTUuOSDbdjmM01Ue2RaIvRsQ2YkQTs+E+xOe2TSWMx6JuOJeA/v5
         74DaqeuIROxAuVhc83B6nhliBZNPx0P1rr+T5cntOCznCYKmPfjoIBckfieYRYF7xMUO
         O2ADB2uVqUi2fhmtL46yCH6lPVIl+A+3QMeVLMqtUhv2BiIyJ3pAgmsVySZ0Gf23cyM2
         aRR54bzMGIAn4JEeotZ8KTzgGed7xUowlU178sH67IwUblKoqOKsTGztlD1HpK5QgwxV
         kqqvt2WugR4a9UFbbMrsU9vYglCHSGs90Bf7MtZ+AP6hdlgIsGSZHPXPSs/gDLur8ZTa
         AqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0IzJzqHGwWv7wQ6mENCP14+oAuB2grwAnb2RdHZ7yh4=;
        b=Ue9Qfx80/TaUlVhzrV9p3bTibjuaLfGaAGUlUMf25ytxwoInoKVZiI+wwOKaucU/jF
         N4FCECVWCjd8AXAsfDN1AmP7hbu6Q8CNZP9Iu1XNfhWZK/mt4WnsmOVtbvWGShCHxu7I
         wIKP8vaQk6pPSL+/XkI4kebZhDfSK3IHClI7a+NXd9JoJV53/q9bxSsRH2yf7Mo8N6I2
         Wr1iSpXnXLrNdWm91wiGedu0jsaUKuNyDMWRJYRZu1z875RdkXFswRTp+6oJ/6/OwrOp
         xRM3pHjNR+cOXXFhLD5AWhG5mJNZTpnDLL2Gc/KoFt+ZqAjLnjkcHPeQzei83HAoRETA
         M5FA==
X-Gm-Message-State: AOAM532cevbvszKpDFSn/hSOwDSRzA3LSH/vhJLLJNPZiu3nhaBRZx/Q
        Z6kX/oElrSchh+I2qF3cVxftvQYBMuhmivQ6ZYg=
X-Google-Smtp-Source: ABdhPJyJE0cpG6sgKLmvLkr0gJ97IMszGz/UX+4kgGUEjyNiTC06HJTWhEFA/xabH4xtbN7oWkOJQ+QxB5bsxdDSHb0=
X-Received: by 2002:ac8:19c4:: with SMTP id s4mr7064572qtk.117.1594765620868;
 Tue, 14 Jul 2020 15:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200710224924.4087399-1-andriin@fb.com> <20200710224924.4087399-3-andriin@fb.com>
 <877dv6gpxd.fsf@toke.dk> <CAEf4BzY7qRsdcdhzf2--Bfgo-GB=ZoKKizOb+OHO7o2PMiNubA@mail.gmail.com>
 <87v9ipg8jd.fsf@toke.dk> <CAEf4BzYVEqFUJybw3kjG6E6w12ocr2ncRz7j15GNNGG4BXJMTw@mail.gmail.com>
 <87lfjlg4fg.fsf@toke.dk>
In-Reply-To: <87lfjlg4fg.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jul 2020 15:26:49 -0700
Message-ID: <CAEf4BzYMaKgJOA3koGkcThXriTGAOKGxjhQXYSNT9sVEFbS7ig@mail.gmail.com>
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

On Tue, Jul 14, 2020 at 2:41 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Tue, Jul 14, 2020 at 1:13 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Tue, Jul 14, 2020 at 6:57 AM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >> >>
> >> >> Andrii Nakryiko <andriin@fb.com> writes:
> >> >>
> >> >> > Add bpf_link-based API (bpf_xdp_link) to attach BPF XDP program t=
hrough
> >> >> > BPF_LINK_CREATE command.
> >> >>
> >> >> I'm still not convinced this is a good idea. As far as I can tell, =
at
> >> >> this point adding this gets you three things:
> >> >>
> >> >> 1. The ability to 'lock' an attachment in place.
> >> >>
> >> >> 2. Automatic detach on fd close
> >> >>
> >> >> 3. API unification with other uses of BPF_LINK_CREATE.
> >> >>
> >> >>
> >> >> Of those, 1. is certainly useful, but can be trivially achieved wit=
h the
> >> >> existing netlink API (add a flag on attach that prevents removal un=
less
> >> >> the original prog_fd is supplied as EXPECTED_FD).
> >> >
> >> > Given it's trivial to discover attached prog FD on a given ifindex, =
it
> >> > doesn't add much of a peace of mind to the application that installs
> >> > bpf_link. Any other XDP-enabled program (even some trivial test
> >> > program) can unknowingly break other applications by deciding to
> >> > "auto-cleanup" it's previous instance on restart ("what's my previou=
s
> >> > prog FD? let's replace it with my up-to-date program FD! What do you
> >> > mean it wasn't my prog FD before?). We went over this discussion man=
y
> >> > times already: relying on the correct behavior of *other*
> >> > applications, which you don't necessarily control, is not working we=
ll
> >> > in real production use cases.
> >>
> >> It's trivial to discover the attached *ID*. But the id-to-fd transitio=
n
> >> requires CAP_SYS_ADMIN, which presumably you're not granting these
> >> not-necessarily-well-behaved programs. Because if you are, what's
> >> stopping them from just killing the owner of the bpf_link to clear it
> >> ("oh, must be a previous instance of myself that's still running, let'=
s
> >> clear that up")? Or what else am I missing here?
> >
> > Well, I actually assumed CAP_SYS_ADMIN, given CAP_BPF is very-very
> > fresh. Without it yes, you can't go ID->FD.
> >
> > But with CAP_SYS_ADMIN, you can't accidentally: 1) discover link ID,
> > 2) link ID-to-FD 3) query link to discover prog ID 4) prog ID-to-FD 5)
> > replace with EXPECTED_FD, because that's not expected flow with link.
> > With link you just have to assume that there is nothing attached to
> > ifindex, otherwise it's up to admin to "recover".
> >
> > While with prog FD-based permanent attachment, you assume that you
> > have to 1) discover prog ID 2) prog ID-to-FD 3) replace with your new
> > prog FD, setting EXPECTED_FD, because you have to assume that if you
> > crashed before, your old prog FD is still attached and you have to
> > detach/replace it on restart. With such assumption, distinguishing
> > "your old BPF prog" vs "someone else's active BPF prog" isn't simple.
> > And you might not even think about the latter case.
> >
> > There is no 100%-fool-proof case, but there are very different flows
> > and assumptions, which I, hopefully, outlined above.
>
> Yup, that was helpful, thanks! I think our difference of opinion on this
> stems from the same place as our disagreement about point 2.: You are
> assuming that an application that uses XDP sticks around and holds on to
> its bpf_link, while I'm assuming it doesn't (and so has to rely on
> pinning for any persistence). In the latter case you don't really gain
> much from the bpf_link auto-cleanup, and whether it's a prog fd or a
> link fd you go find in your bpffs doesn't make that much difference...

Right. But if I had to pick just one implementation (prog fd-based vs
bpf_link), I'd stick with bpf_link because it is flexible enough to
"emulate" prog fd attachment (through BPF FS), but the same isn't true
about prog fd attachment emulating bpf_link. That's it. I really don't
enjoy harping on that point, but it feels to be silently dismissed all
the time based on one particular arrangement for particular existing
XDP flow.

>
> >> >> 2. is IMO the wrong model for XDP, as I believe I argued the last t=
ime
> >> >> we discussed this :)
> >> >> In particular, in a situation with multiple XDP programs attached
> >> >> through a dispatcher, the 'owner' application of each program don't
> >> >> 'own' the interface attachment anyway, so if using bpf_link for tha=
t it
> >> >> would have to be pinned somewhere anyway. So the 'automatic detach'
> >> >> feature is only useful in the "xdpd" deployment scenario, whereas i=
n the
> >> >> common usage model of command-line attachment ('ip link set xdp...'=
) it
> >> >> is something that needs to be worked around.
> >> >
> >> > Right, nothing changed since we last discussed. There are cases wher=
e
> >> > one or another approach is more convenient. Having bpf_link for XDP
> >> > finally gives an option to have an auto-detaching (on last FD close)
> >> > approach, but you still insist there shouldn't be such an option. Wh=
y?
> >>
> >> Because the last time we discussed this, it was in the context of me
> >> trying to extend the existing API and being told "no, don't do that, u=
se
> >> bpf_link instead". So I'm objecting to bpf_link being a *replacement*
> >> for the exiting API; if that's not what you're intending, and we can
> >> agree to keep both around and actively supported (including things lik=
e
> >> adding that flag to the netlink API I talked about above), then that's=
 a
> >> totally different matter :)
> >
> > Yes, we didn't want to extend what we still perceive as unsafe
> > error-prone API, given we had a better approach in mind. Thus the
> > opposition. But you've ultimately got EXPECTED_FD, so hopefully it
> > works well for your use cases.
> >
> > There is no removal of APIs from the kernel. Prog FD attachment for
> > XDP is here to stay forever, did anyone ever indicate otherwise?
> > bpf_link is an alternative, just like bpf_link for cgroup is an
> > alternative to persistent BPF prog FD-based attachments, which we
> > can't remove, even if we want to.
> >
> >> >> 3. would be kinda nice, I guess, if we were designing the API from
> >> >> scratch. But we already have an existing API, so IMO the cost of
> >> >> duplication outweighs any benefits of API unification.
> >> >
> >> > Not unification of BPF_LINK_CREATE, but unification of bpf_link
> >> > infrastructure in general, with its introspection and discoverabilit=
y
> >> > APIs. bpftool can show which programs are attached where and it can
> >> > show PIDs of processes that own the BPF link.
> >>
> >> Right, sure, I was using BPF_LINK_CREATE as a shorthand for bpf_link i=
n
> >> general.
> >>
> >> > With CAP_BPF you have also more options now how to control who can
> >> > mess with your bpf_link.
> >>
> >> What are those, exactly?
> >
> > I meant ID->FD conversion restrictions flexibility with CAP_BPF. You
> > get all of BPF with CAP_BPF, but no ID->FD conversion to mess with
> > bpf_link (e.g., to update underlying program).
>
> Right, sure. I just don't consider that specific to bpf_link; that goes
> for any type of fd...

Fair enough. Unified introspection/discoverability are specific to
bpf_link, I'll stick to just that then.


>
> >> [...]
> >>
> >> >> I was under the impression that forcible attachment of bpf_links wa=
s
> >> >> already possible, but looking at the code now it doesn't appear to =
be?
> >> >> Wasn't that the whole point of BPF_LINK_GET_FD_BY_ID? I.e., that a
> >> >> sysadmin with CAP_SYS_ADMIN privs could grab the offending bpf_link=
 FD
> >> >> and force-remove it? I certainly think this should be added before =
we
> >> >> expand bpf_link usage any more...
> >> >
> >> > I still maintain that killing processes that installed the bpf_link =
is
> >> > the better approach. Instead of letting the process believe and act =
as
> >> > if it has an active XDP program, while it doesn't, it's better to
> >> > altogether kill/restart the process.
> >>
> >> Killing the process seems like a very blunt tool, though. Say it's a
> >> daemon that attaches XDP programs to all available interfaces, but you
> >> want to bring down an interface for some one-off maintenance task, but
> >> the daemon authors neglected to provide an interface to tell the daemo=
n
> >> to detach from specific interfaces. If your only option is to kill the
> >> daemon, you can't bring down that interface without disrupting whateve=
r
> >> that daemon is doing with XDP on all the other interfaces.
> >>
> >
> > I'd rather avoid addressing made up hypothetical cases, really. Get
> > better and more flexible daemon?
>
> I know you guys don't consider an issue to be real until it has already
> crashed something in production. But some of us don't have the luxury of
> your fast issue-discovered-to-fix-shipped turnaround times; so instead
> we have to go with the old-fashioned way of thinking about how things
> can go wrong ahead of time, and making sure we're prepared to handle
> issues if (or, all too often, when) they occur. And it's frankly
> tiresome to have all such efforts be dismissed as "made up
> hypotheticals". Please consider that the whole world does not operate
> like your org, and that there may be legitimate reasons to do things
> differently.
>

Having something that breaks production is a very hard evidence of a
problem and makes it easier to better understand a **real** issue well
and argue why something has to be solved or prevented. But it's not a
necessary condition, of course. It's just that made up hypotheticals
aren't necessarily good ways to motivate a feature, because all too
often it turns out to be just that, hypothetical issue, while the real
issue is different enough to warrant a different and better solution.
By being conservative with adding features, we are trying to not make
unnecessary design and API mistakes, because in the kernel they are
here to stay forever.

In your example, I'd argue that the design of that daemon is bad if it
doesn't allow you to control what's attached where, and how to detach
it without breaking completely independent network interfaces. That
should be the problem that has to be solved first, IMO. And just
because in some scenarios it might be **convenient** to force-detach
bpf_link, is in no way a good justification (in my book) to add that
feature, especially if there are other (and arguably safer) ways to
achieve the same **troubleshooting** effect.

> That being said...
>
> > This force-detach functionality isn't hard to add, but so far we had
> > no real reason to do that. Once we do have such use cases, we can add
> > it, if we agree it's still a good idea.
>
> ...this is fair enough, and I guess I should just put this on my list of
> things to add. I was just somehow under the impression that this had
> already been added.
>

So, overall, do I understand correctly that you are in principle not
opposed to adding BPF XDP link, or you still have some concerns that
were not addressed?

> -Toke
>
