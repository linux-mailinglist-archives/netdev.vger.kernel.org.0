Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC625FF189
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 17:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiJNPjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 11:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiJNPjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 11:39:07 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1101C69C9;
        Fri, 14 Oct 2022 08:39:05 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id e18so7372449edj.3;
        Fri, 14 Oct 2022 08:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2BVG9gJoj345KRt3ZUsXFX6sbczWkhyI7YMVXtPtCt8=;
        b=Ox1F/Sv7SzffXL39FoIRtjP12QEJh8RivrYALykY9plL0XzMmHsXsD2vppk6If/P/u
         DGcPpi8SgtlNfVxuYu2eq3ZIN7fUsPqQVqQfM/GCGr4HPM0637gnk/zK/34aSUGSNuF2
         tFGvToqdRFgXOsxRioGoes2glA2bCd8QbS5DuLUoL8CiPuKzYQrsbPhggNyIxBZcQ2iY
         +nrDhofV2EzRd3zX2rnJnvCjZT6yzGeeMQekD+S+fA0wx5emcK3ekqBuA9qcpXN2MFnk
         YnqfUrBalESp7MhJa+w/yUnSBVqzyMBwHRWU3jHMxUQeOyxQm65v32crTo3I/z23vjSB
         QiYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2BVG9gJoj345KRt3ZUsXFX6sbczWkhyI7YMVXtPtCt8=;
        b=YNWav+KbM+tDO8iTwwoFshhfYi+3j3MQXQPAOgShrbyVxcMl6Hiwmy7xg0Jz1WGeFm
         inmLj/iCJ81FVztyJpWy3R/h/3ML01OPsJ7gckRp1LbZOkFFaavzii76QKQI/Yt876Ai
         WEvJJ1CrGPKkRoPg+wc1LMh5V+eRZRnMpFsjBpUA3ok7Ozc9HoRuMrrEII+ix6nQ546d
         kg/HS4elJ4FDGt+r3PswVvbWpSSm+rTuaGHGOxnwC4+b8RvZA+GOQ9cq7rBOkKwk1CiF
         8DIeSfmYSR9ke88Wtu7+W6LHCPfapmQGoSTA1nR33uYRWgmPaTOSiqnuX08nmPq6EEFc
         U+1A==
X-Gm-Message-State: ACrzQf1viBbBXh07yJraHsaNkKaH7PbzL/udVawIB/w1PtTslAcC4L79
        MBKLkuBxbfRWlVOLKYA3vfACWtQE4klJw6wMt5Jfl4D7M2enVg==
X-Google-Smtp-Source: AMsMyM4682Wgds/3C5Bz1L6qapmQQRpOLPxFlN/c9EXAz8Kn29d9pKUrarSrTnUuTPRiT12lI3MYM039agg/KOlqUQY=
X-Received: by 2002:a05:6402:1205:b0:458:c1b2:e428 with SMTP id
 c5-20020a056402120500b00458c1b2e428mr4745455edw.94.1665761943649; Fri, 14 Oct
 2022 08:39:03 -0700 (PDT)
MIME-Version: 1.0
References: <f355eeba-1b46-749f-c102-65074e7eac27@iogearbox.net>
 <CAADnVQ+gEY3FjCR=+DmjDR4gp5bOYZUFJQXj4agKFHT9CQPZBw@mail.gmail.com>
 <14f368eb-9158-68bc-956c-c8371cfcb531@iogearbox.net> <875ygvemau.fsf@toke.dk>
 <Y0BaBUWeTj18V5Xp@google.com> <87tu4fczyv.fsf@toke.dk> <CAADnVQLH9R94iszCmhYeLKnDPy_uiGeyXnEwoADm8_miihwTmQ@mail.gmail.com>
 <8cc9811e-6efe-3aa5-b201-abbd4b10ceb4@iogearbox.net> <CAADnVQLpcLWrL-URhRgqCQa6XRZzib4BorZ2QKpPC+Uw_JNW=Q@mail.gmail.com>
 <87sfjysfxt.fsf@toke.dk> <20221008203832.7syl3rbt6lblzqxk@macbook-pro-4.dhcp.thefacebook.com>
 <CAEf4BzbFawYvHBWZEh2RN+YMv6r2kEiVNXFVZqXRH1eWK+u_UA@mail.gmail.com>
In-Reply-To: <CAEf4BzbFawYvHBWZEh2RN+YMv6r2kEiVNXFVZqXRH1eWK+u_UA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Oct 2022 08:38:52 -0700
Message-ID: <CAADnVQLyff07uCCj6SaA0=DQ1FsKsgpP01+sptWiTYSVoam=ag@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>, bpf <bpf@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Joe Stringer <joe@cilium.io>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 11:30 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Oct 8, 2022 at 1:38 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Sat, Oct 08, 2022 at 01:38:54PM +0200, Toke H=C3=B8iland-J=C3=B8rgen=
sen wrote:
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > >
> > > > On Fri, Oct 7, 2022 at 12:37 PM Daniel Borkmann <daniel@iogearbox.n=
et> wrote:
> > > >>
> > > >> On 10/7/22 8:59 PM, Alexei Starovoitov wrote:
> > > >> > On Fri, Oct 7, 2022 at 10:20 AM Toke H=C3=B8iland-J=C3=B8rgensen=
 <toke@redhat.com> wrote:
> > > >> [...]
> > > >> >>>> I was thinking a little about how this might work; i.e., how =
can the
> > > >> >>>> kernel expose the required knobs to allow a system policy to =
be
> > > >> >>>> implemented without program loading having to talk to anythin=
g other
> > > >> >>>> than the syscall API?
> > > >> >>>
> > > >> >>>> How about we only expose prepend/append in the prog attach UA=
PI, and
> > > >> >>>> then have a kernel function that does the sorting like:
> > > >> >>>
> > > >> >>>> int bpf_add_new_tcx_prog(struct bpf_prog *progs, size_t num_p=
rogs, struct
> > > >> >>>> bpf_prog *new_prog, bool append)
> > > >> >>>
> > > >> >>>> where the default implementation just appends/prepends to the=
 array in
> > > >> >>>> progs depending on the value of 'appen'.
> > > >> >>>
> > > >> >>>> And then use the __weak linking trick (or maybe struct_ops wi=
th a member
> > > >> >>>> for TXC, another for XDP, etc?) to allow BPF to override the =
function
> > > >> >>>> wholesale and implement whatever ordering it wants? I.e., all=
ow it can
> > > >> >>>> to just shift around the order of progs in the 'progs' array =
whenever a
> > > >> >>>> program is loaded/unloaded?
> > > >> >>>
> > > >> >>>> This way, a userspace daemon can implement any policy it want=
s by just
> > > >> >>>> attaching to that hook, and keeping things like how to expres=
s
> > > >> >>>> dependencies as a userspace concern?
> > > >> >>>
> > > >> >>> What if we do the above, but instead of simple global 'attach =
first/last',
> > > >> >>> the default api would be:
> > > >> >>>
> > > >> >>> - attach before <target_fd>
> > > >> >>> - attach after <target_fd>
> > > >> >>> - attach before target_fd=3D-1 =3D=3D first
> > > >> >>> - attach after target_fd=3D-1 =3D=3D last
> > > >> >>>
> > > >> >>> ?
> > > >> >>
> > > >> >> Hmm, the problem with that is that applications don't generally=
 have an
> > > >> >> fd to another application's BPF programs; and obtaining them fr=
om an ID
> > > >> >> is a privileged operation (CAP_SYS_ADMIN). We could have it be =
"attach
> > > >> >> before target *ID*" instead, which could work I guess? But then=
 the
> > > >> >> problem becomes that it's racy: the ID you're targeting could g=
et
> > > >> >> detached before you attach, so you'll need to be prepared to ch=
eck that
> > > >> >> and retry; and I'm almost certain that applications won't test =
for this,
> > > >> >> so it'll just lead to hard-to-debug heisenbugs. Or am I being t=
oo
> > > >> >> pessimistic here?
> > > >> >
> > > >> > I like Stan's proposal and don't see any issue with FD.
> > > >> > It's good to gate specific sequencing with cap_sys_admin.
> > > >> > Also for consistency the FD is better than ID.
> > > >> >
> > > >> > I also like systemd analogy with Before=3D, After=3D.
> > > >> > systemd has a ton more ways to specify deps between Units,
> > > >> > but none of them have absolute numbers (which is what priority i=
s).
> > > >> > The only bit I'd tweak in Stan's proposal is:
> > > >> > - attach before <target_fd>
> > > >> > - attach after <target_fd>
> > > >> > - attach before target_fd=3D0 =3D=3D first
> > > >> > - attach after target_fd=3D0 =3D=3D last
> > > >>
> > > >> I think the before(), after() could work, but the target_fd I have=
 my doubts
> > > >> that it will be practical. Maybe lets walk through a concrete real=
 example. app_a
> > > >> and app_b shipped via container_a resp container_b. Both want to i=
nstall tc BPF
> > > >> and we (operator/user) want to say that prog from app_b should onl=
y be inserted
> > > >> after the one from app_a, never run before; if no prog_a is instal=
led, we ofc just
> > > >> run prog_b, but if prog_a is inserted, it must be before prog_b gi=
ven the latter
> > > >> can only run after the former. How would we get to one anothers ta=
rget fd? One
> > > >> could use the 0, but not if more programs sit before/after.
> > > >
> > > > I read your desired use case several times and probably still didn'=
t get it.
> > > > Sounds like prog_b can just do after(fd=3D0) to become last.
> > > > And prog_a can do before(fd=3D0).
> > > > Whichever the order of attaching (a or b) these two will always
> > > > be in a->b order.
> > >
> > > I agree that it's probably not feasible to have programs themselves
> > > coordinate between themselves except for "install me last/first" type
> > > semantics.
> > >
> > > I.e., the "before/after target_fd" is useful for a single application
> > > that wants to install two programs in a certain order. Or for bpftool
> > > for manual/debugging work.
> >
> > yep
> >
> > > System-wide policy (which includes "two containers both using BPF") i=
s
> > > going to need some kind of policy agent/daemon anyway. And the in-ker=
nel
> > > function override is the only feasible way to do that.
> >
> > yep
> >
> > > > Since the first and any prog returning !TC_NEXT will abort
> > > > the chain we'd need __weak nop orchestrator prog to interpret
> > > > retval for anything to be useful.
> > >
> > > If we also want the orchestrator to interpret return codes, that
> > > probably implies generating a BPF program that does the dispatching,
> > > right? (since the attachment is per-interface we can't reuse the same
> > > one). So maybe we do need to go the route of the (overridable) usermo=
de
> > > helper that gets all the program FDs and generates a BPF dispatcher
> > > program? Or can we do this with a __weak function that emits bytecode
> > > inside the kernel without being unsafe?
> >
> > hid-bpf, cgroup-rstat, netfilter-bpf are facing similar issue.
> > The __weak override with one prog is certainly limiting.
> > And every case needs different demux.
> > I think we need to generalize xdp dispatcher to address this.
> > For example, for the case:
> > __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
> >                                      struct cgroup *parent, int cpu)
> > {
> > }
> >
> > we can say that 1st argument to nop function will be used as
> > 'demuxing entity'.
> > Sort of like if we had added a 'prog' pointer to 'struct cgroup',
> > but instead of burning 8 byte in every struct cgroup we can generate
> > 'dispatcher asm' only for specific pointers.
> > In case of fuse-bpf that pointer will be a pointer to hid device and
> > demux will be done based on device. It can be an integer too.
> > The subsystem that defines __weak func can pick whatever int or pointer
> > as a first argument and dispatcher routine will generate code:
> > if (arg1 =3D=3D constA) progA(arg1, arg2, ...);
> > else if (arg1 =3D=3D constB) progB(arg1, arg2, ...);
> > ...
> > else nop();
> >
> > This way the 'nop' property of __weak is preserved until user space
> > passes (constA, progA) tuple to the kernel to generate dispatcher
> > for that __weak hook.
> >
> > > Anyway, I'm OK with deferring the orchestrator mechanism and going wi=
th
> > > Stanislav's proposal as an initial API.
> >
> > Great. Looks like we're converging :) Hope Daniel is ok with this direc=
tion.
>
> No one proposed a slight variation on what Daniel was proposing with
> prios that might work just as well. So for completeness, what if
> instead of specifying 0 or explicit prio, we allow specifying either:
>   - explicit prio, and if that prio is taken -- fail
>   - min_prio, and kernel will find smallest untaken prio >=3D min_prio;
> we can also define that min_prio=3D-1 means append as the very last one.
>
> So if someone needs to be the very first -- explicitly request prio=3D1.
> If wants to be last: prio=3D0, min_prio=3D-1. If we want to observe, we
> can do something like min_prio=3D50 to leave a bunch of slots free for
> some other programs for which exact order matters.

Daniel, was suggesting more or less the same thing.
My point is that prio is an unnecessary concept and uapi
will be stuck with it. Including query interface
and bpftool printing it.

> This whole before/after FD interface seems a bit hypothetical as well,
> tbh.

The fd approach is not better. It's not more flexible.
That was not the point.
The point is that fd does not add stuff to uapi that
bpftool has to print and later the user has to somehow interpret.
prio is that magic number that users would have to understand,
but for them it's meaningless. The users want to see the order
of progs on query and select the order on attach.

> If it's multiple programs of the same application, then just
> taking a few slots (either explicitly with prio or just best-effort
> min_prio) is just fine, no need to deal with FDs. If there is no
> coordination betweens apps, I'm not sure how you'd know that you want
> to be before or after some other program's FD? How do you identify
> what program it is, by it's name?
>
> It seems more pragmatic that Cilium takes the very first slot (or a
> bunch of slots) at startup to control exact location. And if that
> fails, then fail startup or (given enough permissions) force-detach
> existing link and install your own.
>
> Just an idea for completeness, don't have much of a horse in this race.
