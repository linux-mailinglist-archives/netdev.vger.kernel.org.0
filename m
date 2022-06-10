Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 671E6546C15
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 20:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350338AbiFJSAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 14:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350347AbiFJR7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:59:48 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3756156793;
        Fri, 10 Jun 2022 10:59:04 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id w20so22333723lfa.11;
        Fri, 10 Jun 2022 10:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N1T+yUBth93sXU6FHB21DJn6xoCS/3B19D9Mgl+8By0=;
        b=JLQa9L+aJa5h/AUqShjS5cNCV4VVAQceXuyioSWAW+LK/hqNswHFRUwjlXP8R6chWw
         LOeOLol889seDUXxKotiqYOM7lIvgEomLiz0tOiQ4GKSGyd3CUpKZzShQfcn6hXWPCAv
         tFBeg4Q+4//yg8FkmNPZzA8TKbMdKdUMUNyxPsMzKVHrA8K2fvivAidbQiXK47zpHyqy
         NR7dPn2/ZEfHXxpz5FwK9QEXP8ylNEepj8uT5GJsJBNa/7+5+94wGAnqjcj6DFGtJw1V
         4QGWzJVN/cHVf0QqNX49R0fiLuhWSqQMNJilLE1xn2zHzQhNxps/f4LyxPr6jPfwJblq
         3T4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N1T+yUBth93sXU6FHB21DJn6xoCS/3B19D9Mgl+8By0=;
        b=IvMFujYGao2MiS0wjv/nUZoDfFpOtR9YbOeLlEpXnzPhcoMe66dTpsN7MAQ82FVNJA
         EKfYQXorl9okj/daDtAok+yB6Zchmmh1j/wWav2yl86gWd4S/WUgIZuowHH678XeekLP
         2MA4aroX8FYkEFQ3/cHf3ikzbn1+8JDKGl6fRDyCyOp3ljRmFK0jLxc1Jan9W2wmUUXU
         Yp6ag6bLAelkBvBl7r65uCfpOOYghObeQgkVxy5bGvx5e4pcYGdvD5VjPLMQAzz1TdHv
         BgLuw+NlAnzMHe2v58GafesV9ajzyFihuCxmqvYqaKM2bEJ2XkEPsqHyTDVEBZhvx0ig
         RCtg==
X-Gm-Message-State: AOAM5333yRwKX8b1PXW1KRMuGgDR8U+ZARqJsQg7LrcXPGH6DqMByQvj
        V+kuuHKnuORew4kYpRakFeUWg2RympndF+hfZII=
X-Google-Smtp-Source: ABdhPJwM1w74Mg05c4TjUAa2KFccwXunjb/E3bmAQecOZTm6MJ9rNa/PUlUb1QZQvh+TyfCaI6xbUvH+dELbpSqcTj0=
X-Received: by 2002:a05:6512:1593:b0:479:56e4:98c1 with SMTP id
 bp19-20020a056512159300b0047956e498c1mr13771954lfb.663.1654883942757; Fri, 10
 Jun 2022 10:59:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220525114003.61890-1-jolsa@kernel.org> <CAEf4BzZ-xe-zSjbBpKLHfQKPnTRTBMA2Eg382+_4kQoTLnj4eQ@mail.gmail.com>
 <CAADnVQJcDKVAOeJ8LX9j-cUKdkptuFWFDnB3o9C_o0bSScGnsQ@mail.gmail.com>
 <CAEf4Bzay1-pRLw+zHG1TjHRTRpqQdtmpmDvNdq=ef-0OUQD0QQ@mail.gmail.com> <CAADnVQJtJEzsr4a+brn4n65Pt1dP-3WTSHZe23_AetxWRTm0Tg@mail.gmail.com>
In-Reply-To: <CAADnVQJtJEzsr4a+brn4n65Pt1dP-3WTSHZe23_AetxWRTm0Tg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Jun 2022 10:58:50 -0700
Message-ID: <CAEf4BzafJ8wThrsaYgn_WtmCau_VFDXB9enp-FiYhnzb==tsMQ@mail.gmail.com>
Subject: Re: [RFC bpf-next] bpf: Use prog->active instead of bpf_prog_active
 for kprobe_multi
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 9, 2022 at 3:03 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jun 9, 2022 at 11:27 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Jun 7, 2022 at 9:29 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, May 31, 2022 at 4:24 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Wed, May 25, 2022 at 4:40 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > > >
> > > > > hi,
> > > > > Alexei suggested to use prog->active instead global bpf_prog_active
> > > > > for programs attached with kprobe multi [1].
> > > > >
> > > > > AFAICS this will bypass bpf_disable_instrumentation, which seems to be
> > > > > ok for some places like hash map update, but I'm not sure about other
> > > > > places, hence this is RFC post.
> > > > >
> > > > > I'm not sure how are kprobes different to trampolines in this regard,
> > > > > because trampolines use prog->active and it's not a problem.
> > > > >
> > > > > thoughts?
> > > > >
> > > >
> > > > Let's say we have two kernel functions A and B? B can be called from
> > > > BPF program though some BPF helper, ok? Now let's say I have two BPF
> > > > programs kprobeX and kretprobeX, both are attached to A and B. With
> > > > using prog->active instead of per-cpu bpf_prog_active, what would be
> > > > the behavior when A is called somewhere in the kernel.
> > > >
> > > > 1. A is called
> > > > 2. kprobeX is activated for A, calls some helper which eventually calls B
> > > >   3. kprobeX is attempted to be called for B, but is skipped due to prog->active
> > > >   4. B runs
> > > >   5. kretprobeX is activated for B, calls some helper which eventually calls B
> > > >     6. kprobeX is ignored (prog->active > 0)
> > > >     7. B runs
> > > >     8. kretprobeX is ignored (prog->active > 0)
> > > > 9. kretprobeX is activated for A, calls helper which calls B
> > > >   10. kprobeX is activated for B
> > > >     11. kprobeX is ignored (prog->active > 0)
> > >
> > > not correct. kprobeX actually runs.
> > > but the end result is correct.
> > >
> >
> > Right, it was a long sequence, but you got the idea :)
> >
> > > >     12. B runs
> > > >     13. kretprobeX is ignored (prog->active > 0)
> > > >   14. B runs
> > > >   15. kretprobeX is ignored (prog->active > 0)
> > > >
> > > >
> > > > If that's correct, we get:
> > > >
> > > > 1. kprobeX for A
> > > > 2. kretprobeX for B
> > > > 3. kretprobeX for A
> > > > 4. kprobeX for B
> > >
> > > Here it's correct.
> > >
> > > > It's quite mind-boggling and annoying in practice. I'd very much
> > > > prefer just kprobeX for A followed by kretprobeX for A. That's it.
> > > >
> > > > I'm trying to protect against this in retsnoop with custom per-cpu
> > > > logic in each program, but I so much more prefer bpf_prog_active,
> > > > which basically says "no nested kprobe calls while kprobe program is
> > > > running", which makes a lot of sense in practice.
> > >
> > > It makes sense for retsnoop, but does not make sense in general.
> > >
> > > > Given kprobe already used global bpf_prog_active I'd say multi-kprobe
> > > > should stick to bpf_prog_active as well.
> > >
> > > I strongly disagree.
> > > Both multi kprobe and kprobe should move to per prog counter
> > > plus some other protection
> > > (we cannot just move to per-prog due to syscalls).
> > > It's true that the above order is mind-boggling,
> > > but it's much better than
> > > missing kprobe invocation completely just because
> > > another kprobe is running on the same cpu.
> > > People complained numerous times about this kprobe behavior.
> > > kprobeX attached to A
> > > kprobeY attached to B.
> > > If kprobeX calls B kprobeY is not going to be called.
> > > Means that anything that bpf is using is lost.
> > > spin locks, lists, rcu, etc.
> > > Sleepable uprobes are coming.
> > > iirc Delyan's patch correctly.
> > > We will do migrate_disable and inc bpf_prog_active.
> >
> > This might be a different issue, I'm not sure why uprobes should be
> > protected by the same global bpf_prog_active, you can't trigger uprobe
> > from uprobe program. And especially for sleepable programs it makes no
> > sense to use per-CPU protection (we have bpf_run_ctx for such
> > protections, if needed).
>
> you're forgetting about tracepoints and perf_events.
> 'perf record' will capture everything.
> Whereas bpf powered 'perf record' will not see bpf progs
> attached to [ku]probe, tp, events.

I agree that using *the same bundled together* bpf_prog_active for
kprobes, uprobes, tracepoints and perf_events doesn't make sense. Can
we think about a bit more nuanced approach here? E.g., for perf_events
it seems unlikely to go into reentrancy and they have quite different
"mode of operation" than kprobes, so per-program protection makes more
sense to me there. Similarly for uprobes, as I mentioned.

But for kprobes its very common to use pairs of kprobe and kretprobe
together. And the sequence I mentioned above is already very
confusing, and if you think about two independent application that
attach pairs of kprobe+kretprobe independently to the same subset of
functions, their interaction will be just plain weird and bug-like.
Specifically for kprobes, pretending like kprobe BPF program doesn't
call any internals of the kernel and doesn't trigger any nested
kprobes seems like a sane thing to me. Surely from kernel POV just
doing per-program (and per-CPU!) check is simple and "elegant" in
terms of implementation, but it's just shifting burden to all kprobe
users. I'm not sure that's the right trade off in this case.

I'm less clear about whether tracepoint should share protection with
kprobe, tbh. On one hand they have same reentrancy problems (though
much less so), but they are also not used in coupled pairs as
kprobe+kretprobe is typically used, so per-program protection for TP
might be ok.

>
> > > Now random kprobes on that cpu will be lost.
> >
> > It's not random. The rule is you can't kernel functions and
> > tracepoints triggered from BPF kprobes/tracepoints. This prevents
> > nasty reentrance problems and makes sense.
>
> From the user point of view it makes no sense whatsoever.
> bperf is losing info.
> Try explaining that to users.
>

See above, I agree that perf_event should not be ignored if it happens
to NMI-interrupt some kprobe BPF program, but I think it's a bit of a
different problem (just like uprobe).

> > Isn't kernel tracing infra
> > is protecting itself similarly, preventing reentrancy and recursion?
>
> Yes and that's what it should be doing.
> It's not the job of the kernel to implement the policy.
> "run one bpf prog per cpu at a time" is a policy
> and very much a broken one.

Plain "one bpf prog per cpu" is bad policy, yes, but all-or-nothing
policy for kprobes/kretprobes attached to the same kernel function
seems to make a lot of sense to me

>
> > > It's awful. We have to fix it.
> >
> > You can call it "a fix" if you'd like, but it's changing a very
> > user-visible behavior and guarantees on which users relied for a
> > while. So even if we switch to per-prog protection it will have to be
> > some sort of opt-in (flag, new program type, whatever).
>
> No opt-in allowed for fixes and it's a bug fix.
> No one should rely on broken kernel behavior.
> If retsnoop rely on that it's really retsnoop's fault.

No point in arguing if we can't even agree on whether this is a bug or
not, sorry.

Getting kretprobe invocation out of the blue without getting
corresponding kprobe invocation first (both of which were successfully
attached) seems like more of a bug to me. But perhaps that's a matter
of subjective opinion.
