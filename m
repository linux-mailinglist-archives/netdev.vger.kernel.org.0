Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F71E220036
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 23:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgGNVlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 17:41:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55141 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726688AbgGNVlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 17:41:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594762904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m6CcsK9lQ0T7peyw2EoH6pxuK8zgNBdouqGLMs3Y5y4=;
        b=VeqfJ8VUi3wYq6dLTPWoXdcgQnLvFdHD/kb36lgsWnKwfNHoZRANBQ/U+xW3LcRy2tv1X+
        UmMNha7DgyqoC/CjAf4TpUBSLMIaiC7WJMb5+sP9t0nySgpm2bzVNXHddSUghebiWNi8sf
        HgL1PItNEWiQH5LyXT75dfSkg78x8do=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-lWbs2l_YOlaSZZrH5aMtDQ-1; Tue, 14 Jul 2020 17:41:43 -0400
X-MC-Unique: lWbs2l_YOlaSZZrH5aMtDQ-1
Received: by mail-wr1-f72.google.com with SMTP id v3so1309wrq.10
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 14:41:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=m6CcsK9lQ0T7peyw2EoH6pxuK8zgNBdouqGLMs3Y5y4=;
        b=DV6RMS/BcB4YQHKpo24YPpWzEvelu0XReTNozCzQTITO7wPwQc/sF+nlPpP3+lN//t
         ybe+8pscd8nMqztBY3DlgLfBkK8PWcBHzhEfxuBqjKtgwIzAs9Eyfg07uf4NVURbamDE
         6xk4Oue6ShIisJuunbXTXA8M3Sd+EzD25LrslxkjooCotNtGdtjfSbq5ahACFVL0wczg
         fLahN/U34EjuYGnka1/8/ghcuV0DF0iPGdj33i62t/tBDyOA8Rb+aTl0NqugmmyVUwf7
         GXzxs4+MVi7tTRM7aLHGKd1+Itu/SPt56kUp8DVWdw74eYeG1hG6NgMQ9nMpcPRX7ySI
         JWFQ==
X-Gm-Message-State: AOAM5303bzwQObfHXi4yPPUvozFyecb/bkXZn0JOCdNZSpwCnrlJVExc
        /9n1F5VvaGad6wHcSQOrjZKr6d4SW/EZF+e3gXHoCWjNPu5W0OO/0pwAmcACo46BahxCXH7+XF7
        qFTIAQW/7XiCneiSo
X-Received: by 2002:adf:c185:: with SMTP id x5mr8601309wre.403.1594762901719;
        Tue, 14 Jul 2020 14:41:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPMawOntNMiufNo0APmWs17VTt00BelCJy/sK6UoE4WZVG3Ae2p8WXzqpo3xUanGzdgnPRzA==
X-Received: by 2002:adf:c185:: with SMTP id x5mr8601286wre.403.1594762901286;
        Tue, 14 Jul 2020 14:41:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y16sm15833wro.71.2020.07.14.14.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 14:41:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EB8281804F0; Tue, 14 Jul 2020 23:41:39 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kicinski@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Takshak Chahande <ctakshak@fb.com>
Subject: Re: [PATCH bpf-next 2/7] bpf, xdp: add bpf_link-based XDP attachment API
In-Reply-To: <CAEf4BzYVEqFUJybw3kjG6E6w12ocr2ncRz7j15GNNGG4BXJMTw@mail.gmail.com>
References: <20200710224924.4087399-1-andriin@fb.com> <20200710224924.4087399-3-andriin@fb.com> <877dv6gpxd.fsf@toke.dk> <CAEf4BzY7qRsdcdhzf2--Bfgo-GB=ZoKKizOb+OHO7o2PMiNubA@mail.gmail.com> <87v9ipg8jd.fsf@toke.dk> <CAEf4BzYVEqFUJybw3kjG6E6w12ocr2ncRz7j15GNNGG4BXJMTw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 14 Jul 2020 23:41:39 +0200
Message-ID: <87lfjlg4fg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Jul 14, 2020 at 1:13 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Tue, Jul 14, 2020 at 6:57 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> Andrii Nakryiko <andriin@fb.com> writes:
>> >>
>> >> > Add bpf_link-based API (bpf_xdp_link) to attach BPF XDP program thr=
ough
>> >> > BPF_LINK_CREATE command.
>> >>
>> >> I'm still not convinced this is a good idea. As far as I can tell, at
>> >> this point adding this gets you three things:
>> >>
>> >> 1. The ability to 'lock' an attachment in place.
>> >>
>> >> 2. Automatic detach on fd close
>> >>
>> >> 3. API unification with other uses of BPF_LINK_CREATE.
>> >>
>> >>
>> >> Of those, 1. is certainly useful, but can be trivially achieved with =
the
>> >> existing netlink API (add a flag on attach that prevents removal unle=
ss
>> >> the original prog_fd is supplied as EXPECTED_FD).
>> >
>> > Given it's trivial to discover attached prog FD on a given ifindex, it
>> > doesn't add much of a peace of mind to the application that installs
>> > bpf_link. Any other XDP-enabled program (even some trivial test
>> > program) can unknowingly break other applications by deciding to
>> > "auto-cleanup" it's previous instance on restart ("what's my previous
>> > prog FD? let's replace it with my up-to-date program FD! What do you
>> > mean it wasn't my prog FD before?). We went over this discussion many
>> > times already: relying on the correct behavior of *other*
>> > applications, which you don't necessarily control, is not working well
>> > in real production use cases.
>>
>> It's trivial to discover the attached *ID*. But the id-to-fd transition
>> requires CAP_SYS_ADMIN, which presumably you're not granting these
>> not-necessarily-well-behaved programs. Because if you are, what's
>> stopping them from just killing the owner of the bpf_link to clear it
>> ("oh, must be a previous instance of myself that's still running, let's
>> clear that up")? Or what else am I missing here?
>
> Well, I actually assumed CAP_SYS_ADMIN, given CAP_BPF is very-very
> fresh. Without it yes, you can't go ID->FD.
>
> But with CAP_SYS_ADMIN, you can't accidentally: 1) discover link ID,
> 2) link ID-to-FD 3) query link to discover prog ID 4) prog ID-to-FD 5)
> replace with EXPECTED_FD, because that's not expected flow with link.
> With link you just have to assume that there is nothing attached to
> ifindex, otherwise it's up to admin to "recover".
>
> While with prog FD-based permanent attachment, you assume that you
> have to 1) discover prog ID 2) prog ID-to-FD 3) replace with your new
> prog FD, setting EXPECTED_FD, because you have to assume that if you
> crashed before, your old prog FD is still attached and you have to
> detach/replace it on restart. With such assumption, distinguishing
> "your old BPF prog" vs "someone else's active BPF prog" isn't simple.
> And you might not even think about the latter case.
>
> There is no 100%-fool-proof case, but there are very different flows
> and assumptions, which I, hopefully, outlined above.

Yup, that was helpful, thanks! I think our difference of opinion on this
stems from the same place as our disagreement about point 2.: You are
assuming that an application that uses XDP sticks around and holds on to
its bpf_link, while I'm assuming it doesn't (and so has to rely on
pinning for any persistence). In the latter case you don't really gain
much from the bpf_link auto-cleanup, and whether it's a prog fd or a
link fd you go find in your bpffs doesn't make that much difference...

>> >> 2. is IMO the wrong model for XDP, as I believe I argued the last time
>> >> we discussed this :)
>> >> In particular, in a situation with multiple XDP programs attached
>> >> through a dispatcher, the 'owner' application of each program don't
>> >> 'own' the interface attachment anyway, so if using bpf_link for that =
it
>> >> would have to be pinned somewhere anyway. So the 'automatic detach'
>> >> feature is only useful in the "xdpd" deployment scenario, whereas in =
the
>> >> common usage model of command-line attachment ('ip link set xdp...') =
it
>> >> is something that needs to be worked around.
>> >
>> > Right, nothing changed since we last discussed. There are cases where
>> > one or another approach is more convenient. Having bpf_link for XDP
>> > finally gives an option to have an auto-detaching (on last FD close)
>> > approach, but you still insist there shouldn't be such an option. Why?
>>
>> Because the last time we discussed this, it was in the context of me
>> trying to extend the existing API and being told "no, don't do that, use
>> bpf_link instead". So I'm objecting to bpf_link being a *replacement*
>> for the exiting API; if that's not what you're intending, and we can
>> agree to keep both around and actively supported (including things like
>> adding that flag to the netlink API I talked about above), then that's a
>> totally different matter :)
>
> Yes, we didn't want to extend what we still perceive as unsafe
> error-prone API, given we had a better approach in mind. Thus the
> opposition. But you've ultimately got EXPECTED_FD, so hopefully it
> works well for your use cases.
>
> There is no removal of APIs from the kernel. Prog FD attachment for
> XDP is here to stay forever, did anyone ever indicate otherwise?
> bpf_link is an alternative, just like bpf_link for cgroup is an
> alternative to persistent BPF prog FD-based attachments, which we
> can't remove, even if we want to.
>
>> >> 3. would be kinda nice, I guess, if we were designing the API from
>> >> scratch. But we already have an existing API, so IMO the cost of
>> >> duplication outweighs any benefits of API unification.
>> >
>> > Not unification of BPF_LINK_CREATE, but unification of bpf_link
>> > infrastructure in general, with its introspection and discoverability
>> > APIs. bpftool can show which programs are attached where and it can
>> > show PIDs of processes that own the BPF link.
>>
>> Right, sure, I was using BPF_LINK_CREATE as a shorthand for bpf_link in
>> general.
>>
>> > With CAP_BPF you have also more options now how to control who can
>> > mess with your bpf_link.
>>
>> What are those, exactly?
>
> I meant ID->FD conversion restrictions flexibility with CAP_BPF. You
> get all of BPF with CAP_BPF, but no ID->FD conversion to mess with
> bpf_link (e.g., to update underlying program).

Right, sure. I just don't consider that specific to bpf_link; that goes
for any type of fd...

>> [...]
>>
>> >> I was under the impression that forcible attachment of bpf_links was
>> >> already possible, but looking at the code now it doesn't appear to be?
>> >> Wasn't that the whole point of BPF_LINK_GET_FD_BY_ID? I.e., that a
>> >> sysadmin with CAP_SYS_ADMIN privs could grab the offending bpf_link FD
>> >> and force-remove it? I certainly think this should be added before we
>> >> expand bpf_link usage any more...
>> >
>> > I still maintain that killing processes that installed the bpf_link is
>> > the better approach. Instead of letting the process believe and act as
>> > if it has an active XDP program, while it doesn't, it's better to
>> > altogether kill/restart the process.
>>
>> Killing the process seems like a very blunt tool, though. Say it's a
>> daemon that attaches XDP programs to all available interfaces, but you
>> want to bring down an interface for some one-off maintenance task, but
>> the daemon authors neglected to provide an interface to tell the daemon
>> to detach from specific interfaces. If your only option is to kill the
>> daemon, you can't bring down that interface without disrupting whatever
>> that daemon is doing with XDP on all the other interfaces.
>>
>
> I'd rather avoid addressing made up hypothetical cases, really. Get
> better and more flexible daemon?

I know you guys don't consider an issue to be real until it has already
crashed something in production. But some of us don't have the luxury of
your fast issue-discovered-to-fix-shipped turnaround times; so instead
we have to go with the old-fashioned way of thinking about how things
can go wrong ahead of time, and making sure we're prepared to handle
issues if (or, all too often, when) they occur. And it's frankly
tiresome to have all such efforts be dismissed as "made up
hypotheticals". Please consider that the whole world does not operate
like your org, and that there may be legitimate reasons to do things
differently.

That being said...

> This force-detach functionality isn't hard to add, but so far we had
> no real reason to do that. Once we do have such use cases, we can add
> it, if we agree it's still a good idea.

...this is fair enough, and I guess I should just put this on my list of
things to add. I was just somehow under the impression that this had
already been added.

-Toke

