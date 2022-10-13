Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A715FE159
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 20:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiJMSfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 14:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbiJMSfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 14:35:18 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB98218F90B;
        Thu, 13 Oct 2022 11:31:49 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id d26so5745292ejc.8;
        Thu, 13 Oct 2022 11:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jyFY2++ZqqhiMZVZj707ssQ7LehJE6VnNQ8oQyuUN+I=;
        b=pNXMqgNGE1kyet/qCg/fOz0o9refZNSLArkO6qdFg7YPxQxJvwJjgwpbNU+IIcw6Z2
         R7fXzvlycq8DxEOhlJ5yxsXkTjW3YqZk4632LUTC6eJQTCq9WRzH2Gomj//8RLKT0QtK
         p8K4IBt9YveK4KPhsnvrm3Ie/X8SSUdJezNEuF0Ijbqw93MRO6RTFvW0+qkgoHA1bZup
         Fybkw3xMXBBpBW/2E8LFSFzG7iqiUM0J8TCTxBt7ckTadlw0UuGxwliJIt9NW/BJdlwP
         OTdSi5IJ23wlNBc2AeIAd23BtS1/XqKqVmjwnF3XJaw7V0oZ3DV93LB2gh81klo6Dnuu
         sS9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jyFY2++ZqqhiMZVZj707ssQ7LehJE6VnNQ8oQyuUN+I=;
        b=ds3fN1tg2kMaqJUIimHUvt1dj4EeSReWA7HWJNBkrI/ydXnU1w8eSTx1eJyG9rQkB5
         pBUpNZh6JpMpMzYbuG8HbHo1lbevZM3XBNcFUm544+56Xu0tJRae9uzfBClHCPLDkF1d
         +W4EHrEiOJ+GB7YmtNUhXuOcbP+W4c0VmDoE6n/EQkb2/Z6rV3Q/9BIReH+ExtekFo/H
         9k1U6TIR5pBG7kHHqTv/0VS31TvQsV48jBKXkC/T99KoqUoTyUJ0cheXFzOy371jDeiL
         Teb1bMeAlZFJ/b6668kDyGZHTaLpK3GofAF0Rui1MsvchEMQYyE3LrwKYnlFb2/fxg/x
         obVA==
X-Gm-Message-State: ACrzQf02C/8A9JTDw1ayiB5K+ul2j+UwWcTpOjkQ79Sd7wUSREK4u8rh
        oCW7BtO6jqHd1QfzfXHVu9byKjdpGLIN0vDVBd/BAezL
X-Google-Smtp-Source: AMsMyM5WgXy5TIPXXjvDut292kl+DLHyOUThmi9qDOSZT/m3ZNUTFpFqqv6WWvjf5Jx+/+gfV6haPUEeNToMDmGrBrQ=
X-Received: by 2002:a17:907:984:b0:77f:4d95:9e2f with SMTP id
 bf4-20020a170907098400b0077f4d959e2fmr835587ejc.176.1665685845770; Thu, 13
 Oct 2022 11:30:45 -0700 (PDT)
MIME-Version: 1.0
References: <f355eeba-1b46-749f-c102-65074e7eac27@iogearbox.net>
 <CAADnVQ+gEY3FjCR=+DmjDR4gp5bOYZUFJQXj4agKFHT9CQPZBw@mail.gmail.com>
 <14f368eb-9158-68bc-956c-c8371cfcb531@iogearbox.net> <875ygvemau.fsf@toke.dk>
 <Y0BaBUWeTj18V5Xp@google.com> <87tu4fczyv.fsf@toke.dk> <CAADnVQLH9R94iszCmhYeLKnDPy_uiGeyXnEwoADm8_miihwTmQ@mail.gmail.com>
 <8cc9811e-6efe-3aa5-b201-abbd4b10ceb4@iogearbox.net> <CAADnVQLpcLWrL-URhRgqCQa6XRZzib4BorZ2QKpPC+Uw_JNW=Q@mail.gmail.com>
 <87sfjysfxt.fsf@toke.dk> <20221008203832.7syl3rbt6lblzqxk@macbook-pro-4.dhcp.thefacebook.com>
In-Reply-To: <20221008203832.7syl3rbt6lblzqxk@macbook-pro-4.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Oct 2022 11:30:33 -0700
Message-ID: <CAEf4BzbFawYvHBWZEh2RN+YMv6r2kEiVNXFVZqXRH1eWK+u_UA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Sat, Oct 8, 2022 at 1:38 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Oct 08, 2022 at 01:38:54PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >
> > > On Fri, Oct 7, 2022 at 12:37 PM Daniel Borkmann <daniel@iogearbox.net=
> wrote:
> > >>
> > >> On 10/7/22 8:59 PM, Alexei Starovoitov wrote:
> > >> > On Fri, Oct 7, 2022 at 10:20 AM Toke H=C3=B8iland-J=C3=B8rgensen <=
toke@redhat.com> wrote:
> > >> [...]
> > >> >>>> I was thinking a little about how this might work; i.e., how ca=
n the
> > >> >>>> kernel expose the required knobs to allow a system policy to be
> > >> >>>> implemented without program loading having to talk to anything =
other
> > >> >>>> than the syscall API?
> > >> >>>
> > >> >>>> How about we only expose prepend/append in the prog attach UAPI=
, and
> > >> >>>> then have a kernel function that does the sorting like:
> > >> >>>
> > >> >>>> int bpf_add_new_tcx_prog(struct bpf_prog *progs, size_t num_pro=
gs, struct
> > >> >>>> bpf_prog *new_prog, bool append)
> > >> >>>
> > >> >>>> where the default implementation just appends/prepends to the a=
rray in
> > >> >>>> progs depending on the value of 'appen'.
> > >> >>>
> > >> >>>> And then use the __weak linking trick (or maybe struct_ops with=
 a member
> > >> >>>> for TXC, another for XDP, etc?) to allow BPF to override the fu=
nction
> > >> >>>> wholesale and implement whatever ordering it wants? I.e., allow=
 it can
> > >> >>>> to just shift around the order of progs in the 'progs' array wh=
enever a
> > >> >>>> program is loaded/unloaded?
> > >> >>>
> > >> >>>> This way, a userspace daemon can implement any policy it wants =
by just
> > >> >>>> attaching to that hook, and keeping things like how to express
> > >> >>>> dependencies as a userspace concern?
> > >> >>>
> > >> >>> What if we do the above, but instead of simple global 'attach fi=
rst/last',
> > >> >>> the default api would be:
> > >> >>>
> > >> >>> - attach before <target_fd>
> > >> >>> - attach after <target_fd>
> > >> >>> - attach before target_fd=3D-1 =3D=3D first
> > >> >>> - attach after target_fd=3D-1 =3D=3D last
> > >> >>>
> > >> >>> ?
> > >> >>
> > >> >> Hmm, the problem with that is that applications don't generally h=
ave an
> > >> >> fd to another application's BPF programs; and obtaining them from=
 an ID
> > >> >> is a privileged operation (CAP_SYS_ADMIN). We could have it be "a=
ttach
> > >> >> before target *ID*" instead, which could work I guess? But then t=
he
> > >> >> problem becomes that it's racy: the ID you're targeting could get
> > >> >> detached before you attach, so you'll need to be prepared to chec=
k that
> > >> >> and retry; and I'm almost certain that applications won't test fo=
r this,
> > >> >> so it'll just lead to hard-to-debug heisenbugs. Or am I being too
> > >> >> pessimistic here?
> > >> >
> > >> > I like Stan's proposal and don't see any issue with FD.
> > >> > It's good to gate specific sequencing with cap_sys_admin.
> > >> > Also for consistency the FD is better than ID.
> > >> >
> > >> > I also like systemd analogy with Before=3D, After=3D.
> > >> > systemd has a ton more ways to specify deps between Units,
> > >> > but none of them have absolute numbers (which is what priority is)=
.
> > >> > The only bit I'd tweak in Stan's proposal is:
> > >> > - attach before <target_fd>
> > >> > - attach after <target_fd>
> > >> > - attach before target_fd=3D0 =3D=3D first
> > >> > - attach after target_fd=3D0 =3D=3D last
> > >>
> > >> I think the before(), after() could work, but the target_fd I have m=
y doubts
> > >> that it will be practical. Maybe lets walk through a concrete real e=
xample. app_a
> > >> and app_b shipped via container_a resp container_b. Both want to ins=
tall tc BPF
> > >> and we (operator/user) want to say that prog from app_b should only =
be inserted
> > >> after the one from app_a, never run before; if no prog_a is installe=
d, we ofc just
> > >> run prog_b, but if prog_a is inserted, it must be before prog_b give=
n the latter
> > >> can only run after the former. How would we get to one anothers targ=
et fd? One
> > >> could use the 0, but not if more programs sit before/after.
> > >
> > > I read your desired use case several times and probably still didn't =
get it.
> > > Sounds like prog_b can just do after(fd=3D0) to become last.
> > > And prog_a can do before(fd=3D0).
> > > Whichever the order of attaching (a or b) these two will always
> > > be in a->b order.
> >
> > I agree that it's probably not feasible to have programs themselves
> > coordinate between themselves except for "install me last/first" type
> > semantics.
> >
> > I.e., the "before/after target_fd" is useful for a single application
> > that wants to install two programs in a certain order. Or for bpftool
> > for manual/debugging work.
>
> yep
>
> > System-wide policy (which includes "two containers both using BPF") is
> > going to need some kind of policy agent/daemon anyway. And the in-kerne=
l
> > function override is the only feasible way to do that.
>
> yep
>
> > > Since the first and any prog returning !TC_NEXT will abort
> > > the chain we'd need __weak nop orchestrator prog to interpret
> > > retval for anything to be useful.
> >
> > If we also want the orchestrator to interpret return codes, that
> > probably implies generating a BPF program that does the dispatching,
> > right? (since the attachment is per-interface we can't reuse the same
> > one). So maybe we do need to go the route of the (overridable) usermode
> > helper that gets all the program FDs and generates a BPF dispatcher
> > program? Or can we do this with a __weak function that emits bytecode
> > inside the kernel without being unsafe?
>
> hid-bpf, cgroup-rstat, netfilter-bpf are facing similar issue.
> The __weak override with one prog is certainly limiting.
> And every case needs different demux.
> I think we need to generalize xdp dispatcher to address this.
> For example, for the case:
> __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
>                                      struct cgroup *parent, int cpu)
> {
> }
>
> we can say that 1st argument to nop function will be used as
> 'demuxing entity'.
> Sort of like if we had added a 'prog' pointer to 'struct cgroup',
> but instead of burning 8 byte in every struct cgroup we can generate
> 'dispatcher asm' only for specific pointers.
> In case of fuse-bpf that pointer will be a pointer to hid device and
> demux will be done based on device. It can be an integer too.
> The subsystem that defines __weak func can pick whatever int or pointer
> as a first argument and dispatcher routine will generate code:
> if (arg1 =3D=3D constA) progA(arg1, arg2, ...);
> else if (arg1 =3D=3D constB) progB(arg1, arg2, ...);
> ...
> else nop();
>
> This way the 'nop' property of __weak is preserved until user space
> passes (constA, progA) tuple to the kernel to generate dispatcher
> for that __weak hook.
>
> > Anyway, I'm OK with deferring the orchestrator mechanism and going with
> > Stanislav's proposal as an initial API.
>
> Great. Looks like we're converging :) Hope Daniel is ok with this directi=
on.

No one proposed a slight variation on what Daniel was proposing with
prios that might work just as well. So for completeness, what if
instead of specifying 0 or explicit prio, we allow specifying either:
  - explicit prio, and if that prio is taken -- fail
  - min_prio, and kernel will find smallest untaken prio >=3D min_prio;
we can also define that min_prio=3D-1 means append as the very last one.

So if someone needs to be the very first -- explicitly request prio=3D1.
If wants to be last: prio=3D0, min_prio=3D-1. If we want to observe, we
can do something like min_prio=3D50 to leave a bunch of slots free for
some other programs for which exact order matters.

This whole before/after FD interface seems a bit hypothetical as well,
tbh. If it's multiple programs of the same application, then just
taking a few slots (either explicitly with prio or just best-effort
min_prio) is just fine, no need to deal with FDs. If there is no
coordination betweens apps, I'm not sure how you'd know that you want
to be before or after some other program's FD? How do you identify
what program it is, by it's name?

It seems more pragmatic that Cilium takes the very first slot (or a
bunch of slots) at startup to control exact location. And if that
fails, then fail startup or (given enough permissions) force-detach
existing link and install your own.

Just an idea for completeness, don't have much of a horse in this race.
