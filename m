Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3501C39C3F4
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 01:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbhFDXg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 19:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbhFDXg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 19:36:56 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E31C061768
        for <netdev@vger.kernel.org>; Fri,  4 Jun 2021 16:34:59 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id my49so207260ejc.7
        for <netdev@vger.kernel.org>; Fri, 04 Jun 2021 16:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MQzzcOcvbnGFvPAi734T5k4MKLwQn8Y8iXFH95VGnis=;
        b=uU0g54LYxDHXzcvQR/hKpB0cyEwvbGqHbvnsnvbFmdk6UcLs6+2bXPWQZkDlcUfBVD
         UFk71RYzrALfiS42BByrCUTYdPxFexW0D09M+WYbQgXyv+uMIy7SQI1d/WzIRxR2fLb2
         2204MdeGaCsBDk/1JobkofP5pnm0AtrLFCVaY7+Q0RHk4dnltJ9fDiessE4hp7yutmZK
         JcUkoVd6rnJjb6FyLfbrxwBG09JxaAYd7kOM5FYVDvxXB1HqxqXkhJN5pzAwp65rFQdu
         Wk8otV6CADkEr8L0bXL2m9vrZqGGGpKnW/oy9Su6/GDzIeHvhtjmOglu1Romi3YJ4DKo
         W/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MQzzcOcvbnGFvPAi734T5k4MKLwQn8Y8iXFH95VGnis=;
        b=tAKbf3UvXJ5RO3RYyob5Nigx6+EkSQFFSoWlFn1OwfzLN5vdxiB1MMGSHGEFVk3U8o
         9/+piEXKk1MicAyTx+x4C+QJ5nXKo5tJ5pNXe/ezZCf4Dis33QLecdL7nNrRqbpgJb3v
         12M+GjTjKgJ1YVOe+Y5LtiynxvVzfllWVwkpeu3ERo37nEaAQp91dXxDKkM+xfwNIViQ
         4sk1v7gesJfcRtuPmGlfjMtjx3yjIaL4ejAMxAEEbDfIgugJPKWVZUtY3SIaEsob6xzn
         xyvONDCJ7jV8jz7Ue9+dy85Bc/ijlS0aCcj0tDYNCM034l+9Rtj1jqo9hj6dAHNNrKj2
         yJsA==
X-Gm-Message-State: AOAM533j0WddO9HjbN9IBFH+jMIOfeWoV813dXqRZMmK7dO3r6m8ThXc
        Q3jc0ufQxN5+1jCQUKVoNNvYOJACXVEtyPy+OIRR
X-Google-Smtp-Source: ABdhPJxEmIr2UYYN95KehbZ0RcN+JZ7OwjQVEWBb8NNdGaReTrXwS7dCctewrILMSqNYBZDBAOG8pYS6taESK/z81ng=
X-Received: by 2002:a17:906:4111:: with SMTP id j17mr6526000ejk.488.1622849694355;
 Fri, 04 Jun 2021 16:34:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210517092006.803332-1-omosnace@redhat.com> <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
 <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net> <CAHC9VhR-kYmMA8gsqkiL5=poN9FoL-uCyx1YOLCoG2hRiUBYug@mail.gmail.com>
 <c7c2d7e1-e253-dce0-d35c-392192e4926e@iogearbox.net> <CAHC9VhS1XRZjKcTFgH1+n5uA-CeT+9BeSP5jvT2+RE5ougLpUg@mail.gmail.com>
 <2e541bdc-ae21-9a07-7ac7-6c6a4dda09e8@iogearbox.net> <CAHC9VhT464vr9sWxqY3PRB4DAccz=LvRMLgWBsSViWMR0JJvOQ@mail.gmail.com>
 <3ca181e3-df32-9ae0-12c6-efb899b7ce7a@iogearbox.net> <CAHC9VhTuPnPs1wMTmoGUZ4fvyy-es9QJpE7O_yTs2JKos4fgbw@mail.gmail.com>
 <f4373013-88fb-b839-aaaa-3826548ebd0c@iogearbox.net> <CAHC9VhS=BeGdaAi8Ae5Fx42Fzy_ybkcXwMNcPwK=uuA6=+SRcg@mail.gmail.com>
 <c59743f6-0000-1b15-bc16-ff761b443aef@iogearbox.net>
In-Reply-To: <c59743f6-0000-1b15-bc16-ff761b443aef@iogearbox.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 4 Jun 2021 19:34:43 -0400
Message-ID: <CAHC9VhT1JhdRw9P_m3niY-U-vukxTWKTE9q6AMyQ=r_ohpPxMw@mail.gmail.com>
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>, jolsa@redhat.com,
        ast@kernel.org, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 4, 2021 at 2:02 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 6/4/21 6:50 AM, Paul Moore wrote:
> > On Thu, Jun 3, 2021 at 2:53 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> [...]
> >> I did run this entire discussion by both of the other BPF co-maintainers
> >> (Alexei, Andrii, CC'ed) and together we did further brainstorming on the
> >> matter on how we could solve this, but couldn't find a sensible & clean
> >> solution so far.
> >
> > Before I jump into the patch below I just want to say that I
> > appreciate you looking into solutions on the BPF side of things.
> > However, I voted "no" on this patch previously and since you haven't
> > really changed it, my "no"/NACK vote remains, at least until we
> > exhaust a few more options.
>
> Just to set the record straight, you previously did neither ACK nor NACK it.

I think I said it wasn't a great solution.  Perhaps I should have been
more clear, but I don't like NACK'ing things while we are still
hashing out possible solutions on the lists.

From my perspective NACK'ing is pretty harsh and I try to leave that
as a last resort.

> And
> again, as summarized earlier, this patch is _fixing_ the majority of the damage
> caused by 59438b46471a for at least the BPF side of things where users run into this,
> Ondrej the rest. Everything else can be discussed on top, and so far it seems there
> is no clean solution in front of us either, not even speaking of one that is small
> and suitable for _stable_ trees. Let me reiterate where we are: it's not that the
> original implementation in 9d1f8be5cf42 ("bpf: Restrict bpf when kernel lockdown is
> in confidentiality mode") was broken, it's that the later added _SELinux_ locked_down
> hook implementation that is broken, and not other LSMs.

I think there are still options for how to solve this moving forward,
more on that at the end of the email, and I would like to see if we
can chase down some of those ideas first.  Maybe the ideas aren't
practical, or maybe they are practical but not from a -stable
perspective; we/I don't know until we talk about it.  Based on
previous experience I'm afraid to ACK a quick-fix without some
discussion about the proper long-term fix.  If the long-term fix isn't
suitable for -stable, then we can take a smaller fix just for the
stable trees.

> Now you're trying to retrofittingly
> ask us for hacks at all costs just because of /a/ broken LSM implementation.

This is starting to get a little off the rails now isn't it?  Daniel
you've always come across as a reasonable person to me, but phrasing
things like that is inflammatory at best.

Could the SELinux lockdown hooks have been done better, of course, I
don't think we are debating that anymore.  New functionality, checks,
etc. are added to the kernel all the time, and because we're all human
we screw that up on occasion.  The important part is that we come
together to fix it, which is what I think we're trying to do here
(it's what I'm trying to do here).

> Maybe
> another avenue is to just swallow the pill and revert 59438b46471a since it made
> assumptions that don't work /generally/. And the use case for an application runtime
> policy change in particular in case of lockdown where users only have 3 choices is
> extremely tiny/rare, if it's not then something is very wrong in your deployment.
> Let me ask you this ... are you also planning to address *all* the other cases inside
> the kernel? If your answer is no, then this entire discussion is pointless.

Um, yes?  We were talking about that earlier in the thread before the
BPF portions of the fix started to dominate the discussion.  Just
because the BPF portion of the fix has dominated the discussion
recently doesn't mean the other issues aren't going to be addressed.

When stuff is busted, I work to fix it.  I think everyone here does.

> >> [PATCH] bpf, lockdown, audit: Fix buggy SELinux lockdown permission checks
> >>
> >> Commit 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
> >> added an implementation of the locked_down LSM hook to SELinux, with the aim
> >> to restrict which domains are allowed to perform operations that would breach
> >> lockdown. This is indirectly also getting audit subsystem involved to report
> >> events. The latter is problematic, as reported by Ondrej and Serhei, since it
> >> can bring down the whole system via audit:
> >>
> >>     1) The audit events that are triggered due to calls to security_locked_down()
> >>        can OOM kill a machine, see below details [0].
> >>
> >>     2) It also seems to be causing a deadlock via avc_has_perm()/slow_avc_audit()
> >>        when trying to wake up kauditd, for example, when using trace_sched_switch()
> >>        tracepoint, see details in [1]. Triggering this was not via some hypothetical
> >>        corner case, but with existing tools like runqlat & runqslower from bcc, for
> >>        example, which make use of this tracepoint. Rough call sequence goes like:
> >>
> >>        rq_lock(rq) -> -------------------------+
> >>          trace_sched_switch() ->               |
> >>            bpf_prog_xyz() ->                   +-> deadlock
> >>              selinux_lockdown() ->             |
> >>                audit_log_end() ->              |
> >>                  wake_up_interruptible() ->    |
> >>                    try_to_wake_up() ->         |
> >>                      rq_lock(rq) --------------+
> >
> > Since BPF is a bit of chaotic nightmare in the sense that it basically
> > out-of-tree kernel code that can be called from anywhere and do pretty
> > much anything; it presents quite the challenge for those of us worried
> > about LSM access controls.
>
> There is no need to generalize ... for those worried, BPF subsystem has LSM access
> controls for the syscall since 2017 via afdb09c720b6 ("security: bpf: Add LSM hooks
> for bpf object related syscall").

We weren't really talking about those hooks in this thread, we're
talking about the security_locked_down() hooks in the BPF helper
functions.  The BPF/LSM hooks you mention above have nothing to do
with that at present, but yes we do have lots of cool LSM hooks that
allow admins to do lots of cool things with access controls.

Anyway, that was a distraction I started in my last email when I
shouldn't have.  If I'm going to call you out for inflammatory
language I should do the same to myself - you have my apology.

> > So let's look at this from a different angle.  Let's look at the two
> > problems you mention above.
> >
> > If we start with the runqueue deadlock we see the main problem is that
> > audit_log_end() pokes the kauditd_wait waitqueue to ensure the
> > kauditd_thread thread wakes up and processes the audit queue.  The
> > audit_log_start() function does something similar, but it is
> > conditional on a number of factors and isn't as likely to be hit.  If
> > we relocate these kauditd wakeup calls we can remove the deadlock in
> > trace_sched_switch().  In the case of CONFIG_AUDITSYSCALL=y we can
> > probably just move the wakeup to __audit_syscall_exit() and in the
> > case of CONFIG_AUDITSYSCALL=n we can likely just change the
> > wait_event_freezable() call in kauditd_thread to a
> > wait_event_freezable_timeout() call with a HZ timeout (the audit
> > stream will be much less on these systems anyway so a queue overflow
> > is much less likely).  I'm building a kernel with these changes now, I
> > should have something to test when I wake up tomorrow morning.  It
> > might even provide a bit of a performance boost as we would only be
> > calling a wakeup function once for each syscall.
>
> As other SELinux developers like Ondrej already pointed out to you in
> this thread:
>
>    Actually, I wasn't aware of the deadlock... But calling an LSM hook
>    [that is backed by a SELinux access check] from within a BPF helper
>    is calling for all kinds of trouble, so I'm not surprised

Skipping past the phrasing of your comment, like any two people Ondrej
and I disagree on some things, and this is one of those things.
Surely the BPF folks never disagree on anything :)

I agree that the current security_locked_down() SELinux hook
implementation has problems, mostly due to the audit code path, but I
think it is something we can fix.  Simply throwing our hands up in the
air in defeat and ripping out the LSM checks in the BPF helpers is
something I see as a last resort and I think we still have one more
potential solution to discuss.

The SELinux hook implementation was only a problem because of the
wakeup call in audit_log_end().  The fact that the hook progressed all
the way to audit_log_end() for the AVC record shows that the bulk of
the hook is fine, we just need to remove the wakeup from
audit_log_end().  To that end, I've been playing with a patch that
does just that, it removes all of the wakeup calls from the
audit_log_start() and audit_log_end() functions, I made some small
tweaks to the patch before I started responding to your email (the
kernel is compiling as I type this) but I expect to post it to the
audit list as a RFC tonight or this weekend for review.

> > The other issue is related to security_locked_down() and using the
> > right subject for the access control check.  As has been pointed out
> > several times in this thread, the current code uses the current() task
> > as the subject, which is arguably incorrect for many of the BPF helper
> > functions.  In the case of BPF, we have talked about using the
> > credentials of the task which loaded the BPF program instead of
> > current(), and that does make a certain amount of sense.  Such an
> > approach should make the security policy easier to develop and
> > rationalize, leading to a significant decrease in audit records coming
> > from LSM access denials.  The question is how to implement such a
> > change.  The current SELinux security_bpf_prog_alloc() hook causes the
> > newly loaded BPF program to inherit the subject context from the task
> > which loads the BPF program; if it is possible to reference the
> > bpf_prog struct, or really just the associated bpf_prog_aux->security
> > blob, from inside a security_bpf_locked_down() function we use that
> > subject information to perform the access check.  BPF folks, is there
> > a way to get that information from within a BPF kernel helper
> > function?  If it isn't currently possible, could it be made possible
> > (or something similar)?
>
> While this could be a potential avenue, the problem here is that BPF
> helpers have neither access to the prog struct nor to bpf_prog_aux. As
> I mentioned earlier, potentially you could go and fix up JITed images
> for those progs where the credentials of the loading task require this
> when policy suddenly changes to a more stricter level. I'm not a fan
> of this though because of the fragility involved here.

FWIW, the JIT hacks sounded awful to me too, I'm not advocating for
that as a solution.  What I'm thinking of is a sort of "bpf_current"
that functions similar to current() but could be used from within the
BPF helpers, and/or the LSMs hooks they call, to reference the
bpf_prog struct of the currently executing BPF program.  Once again,
I'm not a kernel BPF expert, but it seems like we could create a
per-CPU pointer for the bpf_prog struct and assign it as part of the
__BPF_PROG_RUN macro.  The macro already has the bpf_prog pointer so I
wouldn't expect that doing a per-CPU pointer assignment wouldn't be
too costly considering the other things that take place.  Or am I
missing something important?

> Again, the problem is not limited to BPF at all. kprobes is doing register-
> time hooks which are equivalent to the one of BPF. Anything in run-time
> trying to prevent probe_read_kernel by kprobes or BPF is broken by design.

Not being an expert on kprobes I can't really comment on that, but
right now I'm focused on trying to make things work for the BPF
helpers.  I suspect that if we can get the SELinux lockdown
implementation working properly for BPF the solution for kprobes won't
be far off.

-- 
paul moore
www.paul-moore.com
