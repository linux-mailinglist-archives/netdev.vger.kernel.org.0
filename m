Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A571F7218
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 04:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgFLCNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 22:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgFLCNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 22:13:05 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878BCC03E96F;
        Thu, 11 Jun 2020 19:13:05 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s10so3420374pgm.0;
        Thu, 11 Jun 2020 19:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UQ8rQVE1mrRi7P5Vbyl92IPl7nN2rHQUP0qk2KtkISI=;
        b=lsUxt89N+EWW5Z6oMTi1tzQQ8ddi+6wzXed0WBW2fFdPfz9fVxl2f1hZS3wZ+1v2w9
         jX4ouN+Lp+RtP4sb6nFi4NzgWILd0YBzgpJDe1RXCanVfkeHFaTv4Z/L6Hnj1nvLtaMQ
         D9KM0BKb9/WWXUZdVfVZ2BhkaG1uq4fiHsD102Z38wVQG61ZR28z/3j1r646JGv0ovT9
         AEatQSWO8wgJz02q35UVmwmY/OdNa0rl7MA9BMqSAV3tG7ZJiwR69s+gnS5mQwYgGLbf
         XaI6WLfyXX9ELKjn+KgpSxkBDGDJpqSWLjBY73y4cntNRdI0gVpNXHMr/2AgYjxF9quA
         dEhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UQ8rQVE1mrRi7P5Vbyl92IPl7nN2rHQUP0qk2KtkISI=;
        b=ThnYf/EgWmCxdTun8MZgI6jSLM6EJUCO4wiNKe2R1oKYB4qcWubPhNOMoQGnQlRdT6
         5TrkeNzAXzxcErpZucctp4o4Teef85l0VOUdwrU5sgRT2qB+qMDOXvyA1OLoARivpu7G
         wwR5/KdxGzMx+sbD5ekP1gs2AG0X1PL4/NpAIdnqlz202R1lVty0CG9Vra/2PvTK3I8U
         a4ev4mfkTZVjIkkLusEgiudByC6nMfaFRBnFDseows7GrxQYE9GnL1f6yIqszyRBbeTd
         HSEijfrJGCX8ffWmJc0w298bmMaPXq+7tXPe6NZv4InpvgMg5RH4bxS/X61XOHhWK/T9
         nZhA==
X-Gm-Message-State: AOAM532cNqdtDKZ94cBrPf/7finWdJuYk0b9rncVrY9rSORWtC6fERSq
        RGOZrk0YKYz5eiZQSQJ2wwI=
X-Google-Smtp-Source: ABdhPJxkLa0v0PXKtKt7nf/g8sS2WsLW4BBjW/wuBQRHQb7Qvoyokqvp+YI3mExfAS6VlBAKIMWrxg==
X-Received: by 2002:a63:5b04:: with SMTP id p4mr9526624pgb.315.1591927984627;
        Thu, 11 Jun 2020 19:13:04 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:73f9])
        by smtp.gmail.com with ESMTPSA id d4sm3917361pjm.55.2020.06.11.19.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 19:13:03 -0700 (PDT)
Date:   Thu, 11 Jun 2020 19:13:01 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH RFC v3 bpf-next 1/4] bpf: Introduce sleepable BPF programs
Message-ID: <20200612021301.7esez3plqpmjf5wu@ast-mbp.dhcp.thefacebook.com>
References: <20200611222340.24081-1-alexei.starovoitov@gmail.com>
 <20200611222340.24081-2-alexei.starovoitov@gmail.com>
 <CAADnVQ+Ed86oOZPA1rOn_COKPpH1917Q6QUtETkciC8L8+u22A@mail.gmail.com>
 <20200612000447.GF4455@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612000447.GF4455@paulmck-ThinkPad-P72>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 05:04:47PM -0700, Paul E. McKenney wrote:
> On Thu, Jun 11, 2020 at 03:29:09PM -0700, Alexei Starovoitov wrote:
> > On Thu, Jun 11, 2020 at 3:23 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > >  /* dummy _ops. The verifier will operate on target program's ops. */
> > >  const struct bpf_verifier_ops bpf_extension_verifier_ops = {
> > > @@ -205,14 +206,12 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
> > >             tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs)
> > >                 flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
> > >
> > > -       /* Though the second half of trampoline page is unused a task could be
> > > -        * preempted in the middle of the first half of trampoline and two
> > > -        * updates to trampoline would change the code from underneath the
> > > -        * preempted task. Hence wait for tasks to voluntarily schedule or go
> > > -        * to userspace.
> > > +       /* the same trampoline can hold both sleepable and non-sleepable progs.
> > > +        * synchronize_rcu_tasks_trace() is needed to make sure all sleepable
> > > +        * programs finish executing. It also ensures that the rest of
> > > +        * generated tramopline assembly finishes before updating trampoline.
> > >          */
> > > -
> > > -       synchronize_rcu_tasks();
> > > +       synchronize_rcu_tasks_trace();
> > 
> > Hi Paul,
> > 
> > I've been looking at rcu_trace implementation and I think above change
> > is correct.
> > Could you please double check my understanding?
> 
> From an RCU Tasks Trace perspective, it looks good to me!
> 
> You have rcu_read_lock_trace() and rcu_read_unlock_trace() protecting
> the readers and synchronize_rcu_trace() waiting for them.
> 
> One question given my lack of understanding of BPF:  Are there still
> tramoplines for non-sleepable BPF programs?  If so, they might still
> need to use synchronize_rcu_tasks() or some such.

The same trampoline can hold both sleepable and non-sleepable progs.
The following is possible:
. trampoline asm starts
  . rcu_read_lock + migrate_disable
    . non-sleepable prog_A
  . rcu_read_unlock + migrate_enable
. trampoline asm
  . rcu_read_lock_trace
    . sleepable prog_B
  . rcu_read_unlock_trace
. trampoline asm
  . rcu_read_lock + migrate_disable
    . non-sleepable prog_C
  . rcu_read_unlock + migrate_enable
. trampoline asm ends

> 
> The general principle is "never mix one type of RCU reader with another
> type of RCU updater".
> 
> But in this case, one approach is to use synchronize_rcu_mult():
> 
> 	synchronize_rcu_mult(call_rcu_tasks, call_rcu_tasks_trace);

That was my first approach, but I've started looking deeper and looks
like rcu_tasks_trace is stronger than rcu_tasks.
'never mix' is a valid concern, so for future proofing the rcu_mult()
is cleaner, but from safety pov just sync*rcu_tasks_trace() is enough
even when trampoline doesn't hold sleepable progs, right ?

Also timing wise rcu_mult() is obviously faster than doing
one at a time, but how do you sort their speeds:
A: synchronize_rcu_mult(call_rcu_tasks, call_rcu_tasks_trace);
B: synchronize_rcu_tasks();
C: synchronize_rcu_tasks_trace();

> That would wait for both types of readers, and do so concurrently.
> And if there is also a need to wait on rcu_read_lock() and friends,
> you could do this:
> 
> 	synchronize_rcu_mult(call_rcu, call_rcu_tasks, call_rcu_tasks_trace);

I was about to reply that trampoline doesn't need it and there is no such
case yet, but then realized that I can use it in hashtab freeing with:
synchronize_rcu_mult(call_rcu, call_rcu_tasks_trace);
That would be nice optimization.
