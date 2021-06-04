Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C4D39B1A9
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 06:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhFDEx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 00:53:59 -0400
Received: from mail-ed1-f46.google.com ([209.85.208.46]:41496 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhFDEx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 00:53:58 -0400
Received: by mail-ed1-f46.google.com with SMTP id g18so7622370edq.8
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 21:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x90Q7KLzxGnQdvlJBnm7rr4DDCt1grcPV3Uowt83bVg=;
        b=xFkKJy1g/Dq99+LDthlyeOkxVL0vc3sgm7407xja7T/KunaG3jM6iEPHGGEd/seTuT
         hk5+z84vISRo0CRUrakYh6Eqm8bub7dGlU1MbMHJ/9JpVMF+7TiPvML8pXyUWtwXF7+G
         6XVruZ0XWO1KBzlMWAOH3F6vu+ZYyEOUIDvJny9CD1tSyHNiTGH3b/srW66LpZWAiv9l
         AXA5AZPFKznr+B/8A0lLT1wraOWm3b4psmw7tSK+CZQGElAFURuG0V+x6RR4UqKzP0dp
         ZlOSu05H3mFpWi8uuwiea2soWtThhHqWy/mWoaks8qSxbQRQo+bn+sKsL/QBymZEh2hz
         JI3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x90Q7KLzxGnQdvlJBnm7rr4DDCt1grcPV3Uowt83bVg=;
        b=PwTA0EirEz9T/FArymkY5dWVqCO/dQ0zW8pQxMOAATYA9cXmFMpNOD7nCpQ2qbVt73
         POa7eSqV5ZNZOdKo3N7EuSZE5C0SqJPPaA1KFBbXDk7+pald56xLMySsYnL8hBCi2Nns
         6LoUAAJkYQIdiz7e49P8wzpQglCwEyAUfjlxG/UuAj/OUc/uB/r9tdEz8wBqONrlPVI+
         mYL1Lwj+LbCdJWKKBfyv/XAs9lXLOyz+vd+uyqYKqybro5/Mj+1TDThyHDgvCHTkCAZn
         +Iz1NGEcAzObw4e2cf25Eaw8KW252s0QhkF8lJSjIecqisMaDo+DHQjN5ryZs7iqzyPB
         QnmA==
X-Gm-Message-State: AOAM531IMDYJv0SwBIoEDOLWqN5q4WffIuGpbBe0QPUJSY3tPA+vgx2T
        YFS1tVsAQlOBkYalcPW23nuJgFtUJAwt/y5skW7P
X-Google-Smtp-Source: ABdhPJxwUDF114o2gy5sFNpwgCfnJzhmnQ0CQLzlaPBqPhlrHJJdrTOWrANK8cv+0mYFczDmrkFW0Ydud/Lrf7jJCok=
X-Received: by 2002:a05:6402:158e:: with SMTP id c14mr2758605edv.128.1622782259021;
 Thu, 03 Jun 2021 21:50:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210517092006.803332-1-omosnace@redhat.com> <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
 <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net> <CAHC9VhR-kYmMA8gsqkiL5=poN9FoL-uCyx1YOLCoG2hRiUBYug@mail.gmail.com>
 <c7c2d7e1-e253-dce0-d35c-392192e4926e@iogearbox.net> <CAHC9VhS1XRZjKcTFgH1+n5uA-CeT+9BeSP5jvT2+RE5ougLpUg@mail.gmail.com>
 <2e541bdc-ae21-9a07-7ac7-6c6a4dda09e8@iogearbox.net> <CAHC9VhT464vr9sWxqY3PRB4DAccz=LvRMLgWBsSViWMR0JJvOQ@mail.gmail.com>
 <3ca181e3-df32-9ae0-12c6-efb899b7ce7a@iogearbox.net> <CAHC9VhTuPnPs1wMTmoGUZ4fvyy-es9QJpE7O_yTs2JKos4fgbw@mail.gmail.com>
 <f4373013-88fb-b839-aaaa-3826548ebd0c@iogearbox.net>
In-Reply-To: <f4373013-88fb-b839-aaaa-3826548ebd0c@iogearbox.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 4 Jun 2021 00:50:47 -0400
Message-ID: <CAHC9VhS=BeGdaAi8Ae5Fx42Fzy_ybkcXwMNcPwK=uuA6=+SRcg@mail.gmail.com>
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

On Thu, Jun 3, 2021 at 2:53 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 6/2/21 5:13 PM, Paul Moore wrote:
> [...]
> > Help me out here, is your answer that the access check can only be
> > done at BPF program load time?  That isn't really a solution from a
> > SELinux perspective as far as I'm concerned.
>
> That is the current answer. The unfortunate irony is that 59438b46471a
> ("security,lockdown,selinux: implement SELinux lockdown") broke this in
> the first place. W/o the SELinux hook implementation it would have been
> working just fine at runtime, but given it's UAPI since quite a while
> now, that ship has sailed.

Explaining the other side of the "unfortunate irony ..." comment is
going to take us in a direction that isn't very constructive so I'm
going to skip past that now and simply say that if there was better
cooperation across subsystems, especially with the LSM folks, a lot of
this pain could be mitigated.

... and yes I said "mitigated", I'm not foolish to think the pain
could be avoided entirely ;)

> > I understand the ideas I've tossed out aren't practical from a BPF
> > perspective, but it would be nice if we could find something that does
> > work.  Surely you BPF folks can think of some way to provide a
> > runtime, not load time, check?
>
> I did run this entire discussion by both of the other BPF co-maintainers
> (Alexei, Andrii, CC'ed) and together we did further brainstorming on the
> matter on how we could solve this, but couldn't find a sensible & clean
> solution so far.

Before I jump into the patch below I just want to say that I
appreciate you looking into solutions on the BPF side of things.
However, I voted "no" on this patch previously and since you haven't
really changed it, my "no"/NACK vote remains, at least until we
exhaust a few more options.

> [PATCH] bpf, lockdown, audit: Fix buggy SELinux lockdown permission checks
>
> Commit 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
> added an implementation of the locked_down LSM hook to SELinux, with the aim
> to restrict which domains are allowed to perform operations that would breach
> lockdown. This is indirectly also getting audit subsystem involved to report
> events. The latter is problematic, as reported by Ondrej and Serhei, since it
> can bring down the whole system via audit:
>
>    1) The audit events that are triggered due to calls to security_locked_down()
>       can OOM kill a machine, see below details [0].
>
>    2) It also seems to be causing a deadlock via avc_has_perm()/slow_avc_audit()
>       when trying to wake up kauditd, for example, when using trace_sched_switch()
>       tracepoint, see details in [1]. Triggering this was not via some hypothetical
>       corner case, but with existing tools like runqlat & runqslower from bcc, for
>       example, which make use of this tracepoint. Rough call sequence goes like:
>
>       rq_lock(rq) -> -------------------------+
>         trace_sched_switch() ->               |
>           bpf_prog_xyz() ->                   +-> deadlock
>             selinux_lockdown() ->             |
>               audit_log_end() ->              |
>                 wake_up_interruptible() ->    |
>                   try_to_wake_up() ->         |
>                     rq_lock(rq) --------------+

Since BPF is a bit of chaotic nightmare in the sense that it basically
out-of-tree kernel code that can be called from anywhere and do pretty
much anything; it presents quite the challenge for those of us worried
about LSM access controls.

You and the other BPF folks have investigated ways in which BPF might
be able to disable helper functions allowing us to do proper runtime
access checks but haven't been able to make it work, which brings this
patch up yet again.  I'm not a fan of this patch as it basically
allows BPF programs to side-step any changes to the security policy
once the BPF programs have been loaded; this is Not Good.

So let's look at this from a different angle.  Let's look at the two
problems you mention above.

If we start with the runqueue deadlock we see the main problem is that
audit_log_end() pokes the kauditd_wait waitqueue to ensure the
kauditd_thread thread wakes up and processes the audit queue.  The
audit_log_start() function does something similar, but it is
conditional on a number of factors and isn't as likely to be hit.  If
we relocate these kauditd wakeup calls we can remove the deadlock in
trace_sched_switch().  In the case of CONFIG_AUDITSYSCALL=y we can
probably just move the wakeup to __audit_syscall_exit() and in the
case of CONFIG_AUDITSYSCALL=n we can likely just change the
wait_event_freezable() call in kauditd_thread to a
wait_event_freezable_timeout() call with a HZ timeout (the audit
stream will be much less on these systems anyway so a queue overflow
is much less likely).  I'm building a kernel with these changes now, I
should have something to test when I wake up tomorrow morning.  It
might even provide a bit of a performance boost as we would only be
calling a wakeup function once for each syscall.

The other issue is related to security_locked_down() and using the
right subject for the access control check.  As has been pointed out
several times in this thread, the current code uses the current() task
as the subject, which is arguably incorrect for many of the BPF helper
functions.  In the case of BPF, we have talked about using the
credentials of the task which loaded the BPF program instead of
current(), and that does make a certain amount of sense.  Such an
approach should make the security policy easier to develop and
rationalize, leading to a significant decrease in audit records coming
from LSM access denials.  The question is how to implement such a
change.  The current SELinux security_bpf_prog_alloc() hook causes the
newly loaded BPF program to inherit the subject context from the task
which loads the BPF program; if it is possible to reference the
bpf_prog struct, or really just the associated bpf_prog_aux->security
blob, from inside a security_bpf_locked_down() function we use that
subject information to perform the access check.  BPF folks, is there
a way to get that information from within a BPF kernel helper
function?  If it isn't currently possible, could it be made possible
(or something similar)?

If it turns out we can do both of these things (relocated audit
wakeup, bpf_prog reference inside kernel helpers) I think we can
arrive at a fix which both groups can accept.

-- 
paul moore
www.paul-moore.com
