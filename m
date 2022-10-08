Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8885F875C
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 22:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiJHUij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 16:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJHUii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 16:38:38 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9994356F2;
        Sat,  8 Oct 2022 13:38:36 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso9092300pjq.1;
        Sat, 08 Oct 2022 13:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wdVaHTsa7M/Kcp1N5UxpTvJ1YqQbhZn7xcagJKSyPqs=;
        b=atfHxAdcXcEIN95nphc65XJT+eDTvYs2C6M3dd7eswgwgb4Kh0V6H0fn1RTjbiKdmn
         +wbOh8n9lVz01XPgzBqgQ3R3ddLQzR4eOw0fijMmp5aeQTW3T3G2u2MeyhIzOEM4xGsQ
         HTM6rhs3JGgwneqlUgOyDjbXt26ni1sJgB/g4VvGZ/xxliqi2QkNSvR3a7bcG9f8IoBE
         b0M2V5jfQgAEhZq4S6J5+CABe3olGENy5SFkd10DF7Y+8DYGV0D65iYrUXW6keqWiBwT
         UsngjBSw5QOMwzolITqodHzVQeDGr+ZS/cLPa7ciTQdI2i/Amklu1exxsaQ+r0pZU+nK
         /HMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wdVaHTsa7M/Kcp1N5UxpTvJ1YqQbhZn7xcagJKSyPqs=;
        b=tp7yKFRP4C2lgflJV9kUxItbOd9Uj1NVPILz/TqS8WrIgYrLy3nji/VKp2wSLnTgq0
         xD7cW2w23+IcGKYfWzEcsC0AnwR7tjuc2kUiLBbQsKu68ASpiM2HRWaopu3onK0eoVaL
         2GyXQs9hOo+/jTvxaFeiAI+Lsbf+WRzu8doGdr9djTIYp0Tnj9qpReYT0zcN/3NvsycI
         2oxC49nlsVl8wJ2sr/c/WLBCwSTNMA1NBBzso10Qun5iywqSyjDcqO1WYSE8nMltwKYL
         kWsTsRAj4+jWkFa+Qse9nBDQ32To3yhOQSgbxayC5imsR3WcZQihRZofWvFJkGQFaEnV
         7c+g==
X-Gm-Message-State: ACrzQf3txAFpG4qQ10Ahql4ysfq6fvLOziFTrnPfIA1uDeGjg9sbJvOR
        /R1PHiX5W4pkmVLSQaiH69E=
X-Google-Smtp-Source: AMsMyM4xYsHWQnHLKlbUj3el+9HeBIkKlbywkMZJfaX0b57QCEb+xz48BnNeq2Q1jjPeph4bqUsicw==
X-Received: by 2002:a17:90a:b013:b0:20a:e33d:dfa0 with SMTP id x19-20020a17090ab01300b0020ae33ddfa0mr12546789pjq.82.1665261516252;
        Sat, 08 Oct 2022 13:38:36 -0700 (PDT)
Received: from macbook-pro-4.dhcp.thefacebook.com ([2620:10d:c090:400::5:f4af])
        by smtp.gmail.com with ESMTPSA id a127-20020a621a85000000b0054cd16c9f6bsm3816232pfa.200.2022.10.08.13.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Oct 2022 13:38:35 -0700 (PDT)
Date:   Sat, 8 Oct 2022 13:38:32 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
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
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach
 tc BPF programs
Message-ID: <20221008203832.7syl3rbt6lblzqxk@macbook-pro-4.dhcp.thefacebook.com>
References: <f355eeba-1b46-749f-c102-65074e7eac27@iogearbox.net>
 <CAADnVQ+gEY3FjCR=+DmjDR4gp5bOYZUFJQXj4agKFHT9CQPZBw@mail.gmail.com>
 <14f368eb-9158-68bc-956c-c8371cfcb531@iogearbox.net>
 <875ygvemau.fsf@toke.dk>
 <Y0BaBUWeTj18V5Xp@google.com>
 <87tu4fczyv.fsf@toke.dk>
 <CAADnVQLH9R94iszCmhYeLKnDPy_uiGeyXnEwoADm8_miihwTmQ@mail.gmail.com>
 <8cc9811e-6efe-3aa5-b201-abbd4b10ceb4@iogearbox.net>
 <CAADnVQLpcLWrL-URhRgqCQa6XRZzib4BorZ2QKpPC+Uw_JNW=Q@mail.gmail.com>
 <87sfjysfxt.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sfjysfxt.fsf@toke.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 08, 2022 at 01:38:54PM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Fri, Oct 7, 2022 at 12:37 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>
> >> On 10/7/22 8:59 PM, Alexei Starovoitov wrote:
> >> > On Fri, Oct 7, 2022 at 10:20 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >> [...]
> >> >>>> I was thinking a little about how this might work; i.e., how can the
> >> >>>> kernel expose the required knobs to allow a system policy to be
> >> >>>> implemented without program loading having to talk to anything other
> >> >>>> than the syscall API?
> >> >>>
> >> >>>> How about we only expose prepend/append in the prog attach UAPI, and
> >> >>>> then have a kernel function that does the sorting like:
> >> >>>
> >> >>>> int bpf_add_new_tcx_prog(struct bpf_prog *progs, size_t num_progs, struct
> >> >>>> bpf_prog *new_prog, bool append)
> >> >>>
> >> >>>> where the default implementation just appends/prepends to the array in
> >> >>>> progs depending on the value of 'appen'.
> >> >>>
> >> >>>> And then use the __weak linking trick (or maybe struct_ops with a member
> >> >>>> for TXC, another for XDP, etc?) to allow BPF to override the function
> >> >>>> wholesale and implement whatever ordering it wants? I.e., allow it can
> >> >>>> to just shift around the order of progs in the 'progs' array whenever a
> >> >>>> program is loaded/unloaded?
> >> >>>
> >> >>>> This way, a userspace daemon can implement any policy it wants by just
> >> >>>> attaching to that hook, and keeping things like how to express
> >> >>>> dependencies as a userspace concern?
> >> >>>
> >> >>> What if we do the above, but instead of simple global 'attach first/last',
> >> >>> the default api would be:
> >> >>>
> >> >>> - attach before <target_fd>
> >> >>> - attach after <target_fd>
> >> >>> - attach before target_fd=-1 == first
> >> >>> - attach after target_fd=-1 == last
> >> >>>
> >> >>> ?
> >> >>
> >> >> Hmm, the problem with that is that applications don't generally have an
> >> >> fd to another application's BPF programs; and obtaining them from an ID
> >> >> is a privileged operation (CAP_SYS_ADMIN). We could have it be "attach
> >> >> before target *ID*" instead, which could work I guess? But then the
> >> >> problem becomes that it's racy: the ID you're targeting could get
> >> >> detached before you attach, so you'll need to be prepared to check that
> >> >> and retry; and I'm almost certain that applications won't test for this,
> >> >> so it'll just lead to hard-to-debug heisenbugs. Or am I being too
> >> >> pessimistic here?
> >> >
> >> > I like Stan's proposal and don't see any issue with FD.
> >> > It's good to gate specific sequencing with cap_sys_admin.
> >> > Also for consistency the FD is better than ID.
> >> >
> >> > I also like systemd analogy with Before=, After=.
> >> > systemd has a ton more ways to specify deps between Units,
> >> > but none of them have absolute numbers (which is what priority is).
> >> > The only bit I'd tweak in Stan's proposal is:
> >> > - attach before <target_fd>
> >> > - attach after <target_fd>
> >> > - attach before target_fd=0 == first
> >> > - attach after target_fd=0 == last
> >>
> >> I think the before(), after() could work, but the target_fd I have my doubts
> >> that it will be practical. Maybe lets walk through a concrete real example. app_a
> >> and app_b shipped via container_a resp container_b. Both want to install tc BPF
> >> and we (operator/user) want to say that prog from app_b should only be inserted
> >> after the one from app_a, never run before; if no prog_a is installed, we ofc just
> >> run prog_b, but if prog_a is inserted, it must be before prog_b given the latter
> >> can only run after the former. How would we get to one anothers target fd? One
> >> could use the 0, but not if more programs sit before/after.
> >
> > I read your desired use case several times and probably still didn't get it.
> > Sounds like prog_b can just do after(fd=0) to become last.
> > And prog_a can do before(fd=0).
> > Whichever the order of attaching (a or b) these two will always
> > be in a->b order.
> 
> I agree that it's probably not feasible to have programs themselves
> coordinate between themselves except for "install me last/first" type
> semantics.
> 
> I.e., the "before/after target_fd" is useful for a single application
> that wants to install two programs in a certain order. Or for bpftool
> for manual/debugging work.

yep

> System-wide policy (which includes "two containers both using BPF") is
> going to need some kind of policy agent/daemon anyway. And the in-kernel
> function override is the only feasible way to do that.

yep

> > Since the first and any prog returning !TC_NEXT will abort
> > the chain we'd need __weak nop orchestrator prog to interpret
> > retval for anything to be useful.
> 
> If we also want the orchestrator to interpret return codes, that
> probably implies generating a BPF program that does the dispatching,
> right? (since the attachment is per-interface we can't reuse the same
> one). So maybe we do need to go the route of the (overridable) usermode
> helper that gets all the program FDs and generates a BPF dispatcher
> program? Or can we do this with a __weak function that emits bytecode
> inside the kernel without being unsafe?

hid-bpf, cgroup-rstat, netfilter-bpf are facing similar issue.
The __weak override with one prog is certainly limiting.
And every case needs different demux.
I think we need to generalize xdp dispatcher to address this.
For example, for the case:
__weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
                                     struct cgroup *parent, int cpu)
{
}

we can say that 1st argument to nop function will be used as
'demuxing entity'.
Sort of like if we had added a 'prog' pointer to 'struct cgroup',
but instead of burning 8 byte in every struct cgroup we can generate
'dispatcher asm' only for specific pointers.
In case of fuse-bpf that pointer will be a pointer to hid device and
demux will be done based on device. It can be an integer too.
The subsystem that defines __weak func can pick whatever int or pointer
as a first argument and dispatcher routine will generate code:
if (arg1 == constA) progA(arg1, arg2, ...);
else if (arg1 == constB) progB(arg1, arg2, ...);
...
else nop();

This way the 'nop' property of __weak is preserved until user space
passes (constA, progA) tuple to the kernel to generate dispatcher
for that __weak hook.

> Anyway, I'm OK with deferring the orchestrator mechanism and going with
> Stanislav's proposal as an initial API.

Great. Looks like we're converging :) Hope Daniel is ok with this direction.
