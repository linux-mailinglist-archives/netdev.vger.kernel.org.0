Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFA721FEB6
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 22:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgGNUiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 16:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgGNUiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 16:38:08 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C804FC061755;
        Tue, 14 Jul 2020 13:38:08 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id u12so13917745qth.12;
        Tue, 14 Jul 2020 13:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5W4uLh+0JPKR52UY5kWlzhxkly9bCF1VKtzxCeK1Xr0=;
        b=m0td8zdxYplGckJ57KPeOtMrPNPh5MxNEln31JjPRiqSNkvVBPS4HJRaGSHoCTE4OL
         gfaFRmN7Cg/8XHi3uP9F0JSq/ZORW2h3OaFyBeBhq0EPzmFIQWrOS7aApKPfD/bZkVK4
         O2+L7YwFDQwwkYd8VKwltdS9zLb9qTE3QS4klCKGC1vGUsSIoXY3wA8JUqfhS8LT8jIa
         kMRxJqp0KdSwRJofQsU6ko0Np1IvQ7/s38BTRF4vkiv3OHL9hho5MsRliCnnDtm7WfP4
         O9HP4Edx606jDwWekJfZ4vcm6jLzxMmMrxog5YN2KCAFeTexBwbEjDJNP9ZWXHMRsFgH
         55lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5W4uLh+0JPKR52UY5kWlzhxkly9bCF1VKtzxCeK1Xr0=;
        b=RqiXl+k8Pl532QJHIC22zVPaY+jAW66d6HCvwMNxZgGcvTDU8nFIsIv5eVJDmyPjJu
         qo7tK+N/jx2616mhNeAVgwaOwh/tJz7UygAwVvE9PgNQCE24k6cwC3Km6m0aoY3VRFxK
         pCNZc0m/aDYoDqy26sk5Fc6/lWFj/wdM/vQCAPL3MJmFlpHcdzFdBVWrb438L+S0w8oW
         FzyAi7vRkaIAfdqgEqBt1ccoVJISE+n0vn19TPOkSJjQ2C80MTuZFk41sez8S46Vj465
         VtmfwSFf5WezL20nLl62q8hdaJ2KCdGlyoMEOo1ujs5u2sGc5x843uHobCbEFC7MX1Wu
         0JQg==
X-Gm-Message-State: AOAM530u2pVPUm/4AyhPumkt5qCf5NHVvdw3wxDk/tAfVyOHcOaYBNGu
        QUsZmBv0MWs6w8OeFaqCo2nFb/zun47HkwuuXD4=
X-Google-Smtp-Source: ABdhPJylAc9TS9wKA4TTDQ5nyZ0Tf6FTjjVMtjWxmk3cObjhdubZFGvH3qGTz07YShnjbJfWP2RDz4lzFdtdfQQPQlM=
X-Received: by 2002:ac8:19c4:: with SMTP id s4mr6651856qtk.117.1594759087862;
 Tue, 14 Jul 2020 13:38:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200710224924.4087399-1-andriin@fb.com> <20200710224924.4087399-3-andriin@fb.com>
 <877dv6gpxd.fsf@toke.dk> <CAEf4BzY7qRsdcdhzf2--Bfgo-GB=ZoKKizOb+OHO7o2PMiNubA@mail.gmail.com>
 <87v9ipg8jd.fsf@toke.dk>
In-Reply-To: <87v9ipg8jd.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jul 2020 13:37:56 -0700
Message-ID: <CAEf4BzYVEqFUJybw3kjG6E6w12ocr2ncRz7j15GNNGG4BXJMTw@mail.gmail.com>
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

On Tue, Jul 14, 2020 at 1:13 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Tue, Jul 14, 2020 at 6:57 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andriin@fb.com> writes:
> >>
> >> > Add bpf_link-based API (bpf_xdp_link) to attach BPF XDP program thro=
ugh
> >> > BPF_LINK_CREATE command.
> >>
> >> I'm still not convinced this is a good idea. As far as I can tell, at
> >> this point adding this gets you three things:
> >>
> >> 1. The ability to 'lock' an attachment in place.
> >>
> >> 2. Automatic detach on fd close
> >>
> >> 3. API unification with other uses of BPF_LINK_CREATE.
> >>
> >>
> >> Of those, 1. is certainly useful, but can be trivially achieved with t=
he
> >> existing netlink API (add a flag on attach that prevents removal unles=
s
> >> the original prog_fd is supplied as EXPECTED_FD).
> >
> > Given it's trivial to discover attached prog FD on a given ifindex, it
> > doesn't add much of a peace of mind to the application that installs
> > bpf_link. Any other XDP-enabled program (even some trivial test
> > program) can unknowingly break other applications by deciding to
> > "auto-cleanup" it's previous instance on restart ("what's my previous
> > prog FD? let's replace it with my up-to-date program FD! What do you
> > mean it wasn't my prog FD before?). We went over this discussion many
> > times already: relying on the correct behavior of *other*
> > applications, which you don't necessarily control, is not working well
> > in real production use cases.
>
> It's trivial to discover the attached *ID*. But the id-to-fd transition
> requires CAP_SYS_ADMIN, which presumably you're not granting these
> not-necessarily-well-behaved programs. Because if you are, what's
> stopping them from just killing the owner of the bpf_link to clear it
> ("oh, must be a previous instance of myself that's still running, let's
> clear that up")? Or what else am I missing here?

Well, I actually assumed CAP_SYS_ADMIN, given CAP_BPF is very-very
fresh. Without it yes, you can't go ID->FD.

But with CAP_SYS_ADMIN, you can't accidentally: 1) discover link ID,
2) link ID-to-FD 3) query link to discover prog ID 4) prog ID-to-FD 5)
replace with EXPECTED_FD, because that's not expected flow with link.
With link you just have to assume that there is nothing attached to
ifindex, otherwise it's up to admin to "recover".

While with prog FD-based permanent attachment, you assume that you
have to 1) discover prog ID 2) prog ID-to-FD 3) replace with your new
prog FD, setting EXPECTED_FD, because you have to assume that if you
crashed before, your old prog FD is still attached and you have to
detach/replace it on restart. With such assumption, distinguishing
"your old BPF prog" vs "someone else's active BPF prog" isn't simple.
And you might not even think about the latter case.

There is no 100%-fool-proof case, but there are very different flows
and assumptions, which I, hopefully, outlined above.

>
> >> 2. is IMO the wrong model for XDP, as I believe I argued the last time
> >> we discussed this :)
> >> In particular, in a situation with multiple XDP programs attached
> >> through a dispatcher, the 'owner' application of each program don't
> >> 'own' the interface attachment anyway, so if using bpf_link for that i=
t
> >> would have to be pinned somewhere anyway. So the 'automatic detach'
> >> feature is only useful in the "xdpd" deployment scenario, whereas in t=
he
> >> common usage model of command-line attachment ('ip link set xdp...') i=
t
> >> is something that needs to be worked around.
> >
> > Right, nothing changed since we last discussed. There are cases where
> > one or another approach is more convenient. Having bpf_link for XDP
> > finally gives an option to have an auto-detaching (on last FD close)
> > approach, but you still insist there shouldn't be such an option. Why?
>
> Because the last time we discussed this, it was in the context of me
> trying to extend the existing API and being told "no, don't do that, use
> bpf_link instead". So I'm objecting to bpf_link being a *replacement*
> for the exiting API; if that's not what you're intending, and we can
> agree to keep both around and actively supported (including things like
> adding that flag to the netlink API I talked about above), then that's a
> totally different matter :)

Yes, we didn't want to extend what we still perceive as unsafe
error-prone API, given we had a better approach in mind. Thus the
opposition. But you've ultimately got EXPECTED_FD, so hopefully it
works well for your use cases.

There is no removal of APIs from the kernel. Prog FD attachment for
XDP is here to stay forever, did anyone ever indicate otherwise?
bpf_link is an alternative, just like bpf_link for cgroup is an
alternative to persistent BPF prog FD-based attachments, which we
can't remove, even if we want to.

>
> >> 3. would be kinda nice, I guess, if we were designing the API from
> >> scratch. But we already have an existing API, so IMO the cost of
> >> duplication outweighs any benefits of API unification.
> >
> > Not unification of BPF_LINK_CREATE, but unification of bpf_link
> > infrastructure in general, with its introspection and discoverability
> > APIs. bpftool can show which programs are attached where and it can
> > show PIDs of processes that own the BPF link.
>
> Right, sure, I was using BPF_LINK_CREATE as a shorthand for bpf_link in
> general.
>
> > With CAP_BPF you have also more options now how to control who can
> > mess with your bpf_link.
>
> What are those, exactly?

I meant ID->FD conversion restrictions flexibility with CAP_BPF. You
get all of BPF with CAP_BPF, but no ID->FD conversion to mess with
bpf_link (e.g., to update underlying program).

>
> [...]
>
> >> I was under the impression that forcible attachment of bpf_links was
> >> already possible, but looking at the code now it doesn't appear to be?
> >> Wasn't that the whole point of BPF_LINK_GET_FD_BY_ID? I.e., that a
> >> sysadmin with CAP_SYS_ADMIN privs could grab the offending bpf_link FD
> >> and force-remove it? I certainly think this should be added before we
> >> expand bpf_link usage any more...
> >
> > I still maintain that killing processes that installed the bpf_link is
> > the better approach. Instead of letting the process believe and act as
> > if it has an active XDP program, while it doesn't, it's better to
> > altogether kill/restart the process.
>
> Killing the process seems like a very blunt tool, though. Say it's a
> daemon that attaches XDP programs to all available interfaces, but you
> want to bring down an interface for some one-off maintenance task, but
> the daemon authors neglected to provide an interface to tell the daemon
> to detach from specific interfaces. If your only option is to kill the
> daemon, you can't bring down that interface without disrupting whatever
> that daemon is doing with XDP on all the other interfaces.
>

I'd rather avoid addressing made up hypothetical cases, really. Get
better and more flexible daemon? Make it pin links, so you can delete
them, if necessary? Force-detaching is surely a way to address an
issue like this, but not necessarily the best or required one.

Killing process is a blunt tool, of course, but one can argue that a
dead process is better than a misbehaving process. We can keep coming
up with ever more elaborate hypothetical examples, but I don't see
much point. This force-detach functionality isn't hard to add, but so
far we had no real reason to do that. Once we do have such use cases,
we can add it, if we agree it's still a good idea.

> -Toke
>
