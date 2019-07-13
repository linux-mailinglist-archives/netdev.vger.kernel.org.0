Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 701CB67AF7
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 17:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbfGMPgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 11:36:11 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38255 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728080AbfGMPgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 11:36:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id y15so5588861pfn.5
        for <netdev@vger.kernel.org>; Sat, 13 Jul 2019 08:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1mR9KqHQkfadULkPmW2DdFvx6NiptUgiQfwUWgjwbIA=;
        b=W0uNi8QdxTASdd9660rR+kFCWbeOkHRZtqxS0iAqzMHvNNYI45Lz56SY/s9JIMLNbO
         BffaOYo4eY5969T+IL3pmlqbTGdJIIAVXHbA6UiqflXH342HgpQZKzsNCKL5q2SDfdCX
         Iap6VcH8M1xixe44eFITmfspdM7K5cadCI8NQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1mR9KqHQkfadULkPmW2DdFvx6NiptUgiQfwUWgjwbIA=;
        b=SMZBPURh82F5m75kDJPrhKA88Bw0SUfyJl8oCoRdgePqPejhomcCouQ88nt/+SmHOj
         JuvpdaY98/gDHjNSS3Hf6se/qDqSJicShmn5HzAX3sIzbKgU+Q2OYMi4igGxnm12G7TW
         lAWryLHZn2rwSrWy7WyuPopP0BL3h70SnGnQA2+qqZe53tOdb6Va9SV4+YAlBeMJMpT9
         WxfUERPvDKuZRnJTqKbBVWeZS4dANZiHqsuCU2fpQSIgOcepHowxny8Qs62qfrXbOxWM
         /cTbEBDqCmBqbvmrYESPxNw11e+p7FvzKYK3NT1fAFQlbxciPMpDeDDzf08KypQJYADE
         wwPw==
X-Gm-Message-State: APjAAAXVvIq3/g8wapFdPUhh3yceheYnv89i+K5XIIcj55TVhTQcuOeP
        2qwQRB1Wvd+QVJ+r3WlkyIs=
X-Google-Smtp-Source: APXvYqy8CDIaYdNVy7aE5eKg8LXfl4H9nar2Fnr25mG8KxVexuLqne7oUlvmnFgMAwo2U5LYFBfDrw==
X-Received: by 2002:a63:bf01:: with SMTP id v1mr17053571pgf.278.1563032169100;
        Sat, 13 Jul 2019 08:36:09 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id cx22sm10160134pjb.25.2019.07.13.08.36.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 13 Jul 2019 08:36:08 -0700 (PDT)
Date:   Sat, 13 Jul 2019 11:36:06 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, kernel-team@android.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v2 3/9] rcu/sync: Remove custom check for reader-section
Message-ID: <20190713153606.GD133650@google.com>
References: <20190712170024.111093-1-joel@joelfernandes.org>
 <20190712170024.111093-4-joel@joelfernandes.org>
 <20190712213559.GA175138@google.com>
 <20190712233206.GZ26519@linux.ibm.com>
 <20190713030150.GA246587@google.com>
 <20190713031008.GA248225@google.com>
 <20190713082114.GA26519@linux.ibm.com>
 <20190713133049.GA133650@google.com>
 <20190713144108.GD26519@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190713144108.GD26519@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 13, 2019 at 07:41:08AM -0700, Paul E. McKenney wrote:
> On Sat, Jul 13, 2019 at 09:30:49AM -0400, Joel Fernandes wrote:
> > On Sat, Jul 13, 2019 at 01:21:14AM -0700, Paul E. McKenney wrote:
> > > On Fri, Jul 12, 2019 at 11:10:08PM -0400, Joel Fernandes wrote:
> > > > On Fri, Jul 12, 2019 at 11:01:50PM -0400, Joel Fernandes wrote:
> > > > > On Fri, Jul 12, 2019 at 04:32:06PM -0700, Paul E. McKenney wrote:
> > > > > > On Fri, Jul 12, 2019 at 05:35:59PM -0400, Joel Fernandes wrote:
> > > > > > > On Fri, Jul 12, 2019 at 01:00:18PM -0400, Joel Fernandes (Google) wrote:
> > > > > > > > The rcu/sync code was doing its own check whether we are in a reader
> > > > > > > > section. With RCU consolidating flavors and the generic helper added in
> > > > > > > > this series, this is no longer need. We can just use the generic helper
> > > > > > > > and it results in a nice cleanup.
> > > > > > > > 
> > > > > > > > Cc: Oleg Nesterov <oleg@redhat.com>
> > > > > > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > > > > > 
> > > > > > > Hi Oleg,
> > > > > > > Slightly unrelated to the patch,
> > > > > > > I tried hard to understand this comment below in percpu_down_read() but no dice.
> > > > > > > 
> > > > > > > I do understand how rcu sync and percpu rwsem works, however the comment
> > > > > > > below didn't make much sense to me. For one, there's no readers_fast anymore
> > > > > > > so I did not follow what readers_fast means. Could the comment be updated to
> > > > > > > reflect latest changes?
> > > > > > > Also could you help understand how is a writer not able to change
> > > > > > > sem->state and count the per-cpu read counters at the same time as the
> > > > > > > comment tries to say?
> > > > > > > 
> > > > > > > 	/*
> > > > > > > 	 * We are in an RCU-sched read-side critical section, so the writer
> > > > > > > 	 * cannot both change sem->state from readers_fast and start checking
> > > > > > > 	 * counters while we are here. So if we see !sem->state, we know that
> > > > > > > 	 * the writer won't be checking until we're past the preempt_enable()
> > > > > > > 	 * and that once the synchronize_rcu() is done, the writer will see
> > > > > > > 	 * anything we did within this RCU-sched read-size critical section.
> > > > > > > 	 */
> > > > > > > 
> > > > > > > Also,
> > > > > > > I guess we could get rid of all of the gp_ops struct stuff now that since all
> > > > > > > the callbacks are the same now. I will post that as a follow-up patch to this
> > > > > > > series.
> > > > > > 
> > > > > > Hello, Joel,
> > > > > > 
> > > > > > Oleg has a set of patches updating this code that just hit mainline
> > > > > > this week.  These patches get rid of the code that previously handled
> > > > > > RCU's multiple flavors.  Or are you looking at current mainline and
> > > > > > me just missing your point?
> > > > > > 
> > > > > 
> > > > > Hi Paul,
> > > > > You are right on point. I have a bad habit of not rebasing my trees. In this
> > > > > case the feature branch of mine in concern was based on v5.1. Needless to
> > > > > say, I need to rebase my tree.
> > > > > 
> > > > > Yes, this sync clean up patch does conflict when I rebase, but other patches
> > > > > rebase just fine.
> > > > > 
> > > > > The 2 options I see are:
> > > > > 1. Let us drop this patch for now and I resend it later.
> > > > > 2. I resend all patches based on Linus's master branch.
> > > > 
> > > > Below is the updated patch based on Linus master branch:
> > > > 
> > > > ---8<-----------------------
> > > > 
> > > > >From 5f40c9a07fcf3d6dafc2189599d0ba9443097d0f Mon Sep 17 00:00:00 2001
> > > > From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
> > > > Date: Fri, 12 Jul 2019 12:13:27 -0400
> > > > Subject: [PATCH v2.1 3/9] rcu/sync: Remove custom check for reader-section
> > > > 
> > > > The rcu/sync code was doing its own check whether we are in a reader
> > > > section. With RCU consolidating flavors and the generic helper added in
> > > > this series, this is no longer need. We can just use the generic helper
> > > > and it results in a nice cleanup.
> > > > 
> > > > Cc: Oleg Nesterov <oleg@redhat.com>
> > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > > ---
> > > >  include/linux/rcu_sync.h | 4 +---
> > > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > > > 
> > > > diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
> > > > index 9b83865d24f9..0027d4c8087c 100644
> > > > --- a/include/linux/rcu_sync.h
> > > > +++ b/include/linux/rcu_sync.h
> > > > @@ -31,9 +31,7 @@ struct rcu_sync {
> > > >   */
> > > >  static inline bool rcu_sync_is_idle(struct rcu_sync *rsp)
> > > >  {
> > > > -	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
> > > > -			 !rcu_read_lock_bh_held() &&
> > > > -			 !rcu_read_lock_sched_held(),
> > > > +	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
> > > 
> > > I believe that replacing rcu_read_lock_sched_held() with preemptible()
> > > in a CONFIG_PREEMPT=n kernel will give you false-positive splats here.
> > > If you have not already done so, could you please give it a try?
> > 
> > Hi Paul,
> > I don't think it will cause splats for !CONFIG_PREEMPT.
> > 
> > Currently, rcu_read_lock_any_held() introduced in this patch returns true if
> > !preemptible(). This means that:
> > 
> > The following expression above:
> > RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),...)
> > 
> > Becomes:
> > RCU_LOCKDEP_WARN(preemptible(), ...)
> > 
> > For, CONFIG_PREEMPT=n kernels, this means:
> > RCU_LOCKDEP_WARN(0, ...)
> > 
> > Which would mean no splats. Or, did I miss the point?
> 
> I suggest trying it out on a CONFIG_PREEMPT=n kernel.

Sure, will do, sorry did not try it out yet because was busy with weekend
chores but will do soon, thanks!

