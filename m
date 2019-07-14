Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E726809C
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 20:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbfGNSK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 14:10:59 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35720 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbfGNSK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 14:10:59 -0400
Received: by mail-pg1-f194.google.com with SMTP id s1so331191pgr.2
        for <netdev@vger.kernel.org>; Sun, 14 Jul 2019 11:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=h1pAcn8lGSAohpOznQF9NmGy7QqhFhjk1FbBtBnrL3Q=;
        b=EMgyg0ifNFigYL4RNf7iGfiMIUg6jvRXRiys4EXya8l6ZmanKbiXroI/a0Mzi54zNi
         evMfGank18wT1GABV79nf3sIQ9Bsfw1s3LQtXCu1jO0i1RSPO3FHYXnJsopKFdU1iqpl
         lnJyX45ng7dNKagHUCm560W8tKOHrwtrgrnP8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h1pAcn8lGSAohpOznQF9NmGy7QqhFhjk1FbBtBnrL3Q=;
        b=HT5hYUS8P/uytb5Sfr2KbH6UWOCLzf74c/ZpnCPGm1zvhv8wrhkl896kyXH+oYEKn8
         Xye0WkTBSaKl79tG6/y3Mg4fV/Ah1wOg7ouwHJz0reFJR/T9MdUyLOYhrNHjHZCjb3zo
         l0d08wg/TZaG+jJJyZBQhhuDfGQ5BCGskHHv9tWfU2imOn7bdAM+B0EDqcUKT1VcyGm1
         QLGz53SAbihfu8Y+ctRWGSPGg30sZuauTDxsBBugLDm5LKAtywtU5yF1qDSPomXReW9R
         rG7MXgvRIA2qRr+xbOj3xwrh8doDo8XlyPDjSMrq0vbjKqGvbLWcDvS0K8M3S8NdufoF
         3cJw==
X-Gm-Message-State: APjAAAURB+EmJTVLLEFtwo8xipwmmrjXGjR+ongC9lOTLZw/JcPbmN3U
        pHv/hqlvsHcIMsKyFZGKL/4=
X-Google-Smtp-Source: APXvYqxF3hpQsmoT+sPJXSACN4cxJFE3QliM8B8zXx9WoEiv61udpMi6Vi+H9/biYKmUyGPphFBWKQ==
X-Received: by 2002:a17:90b:8cd:: with SMTP id ds13mr23479973pjb.141.1563127857354;
        Sun, 14 Jul 2019 11:10:57 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id h26sm15448605pfq.64.2019.07.14.11.10.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 14 Jul 2019 11:10:55 -0700 (PDT)
Date:   Sun, 14 Jul 2019 14:10:53 -0400
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
Message-ID: <20190714181053.GB34501@google.com>
References: <20190712233206.GZ26519@linux.ibm.com>
 <20190713030150.GA246587@google.com>
 <20190713031008.GA248225@google.com>
 <20190713082114.GA26519@linux.ibm.com>
 <20190713133049.GA133650@google.com>
 <20190713144108.GD26519@linux.ibm.com>
 <20190713153606.GD133650@google.com>
 <20190713155010.GF26519@linux.ibm.com>
 <20190713161316.GA39321@google.com>
 <20190713212812.GH26519@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190713212812.GH26519@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 13, 2019 at 02:28:12PM -0700, Paul E. McKenney wrote:
> On Sat, Jul 13, 2019 at 12:13:16PM -0400, Joel Fernandes wrote:
> > On Sat, Jul 13, 2019 at 08:50:10AM -0700, Paul E. McKenney wrote:
> > > On Sat, Jul 13, 2019 at 11:36:06AM -0400, Joel Fernandes wrote:
> > > > On Sat, Jul 13, 2019 at 07:41:08AM -0700, Paul E. McKenney wrote:
> > > > > On Sat, Jul 13, 2019 at 09:30:49AM -0400, Joel Fernandes wrote:
> > > > > > On Sat, Jul 13, 2019 at 01:21:14AM -0700, Paul E. McKenney wrote:
> > > > > > > On Fri, Jul 12, 2019 at 11:10:08PM -0400, Joel Fernandes wrote:
> > > > > > > > On Fri, Jul 12, 2019 at 11:01:50PM -0400, Joel Fernandes wrote:
> > > > > > > > > On Fri, Jul 12, 2019 at 04:32:06PM -0700, Paul E. McKenney wrote:
> > > > > > > > > > On Fri, Jul 12, 2019 at 05:35:59PM -0400, Joel Fernandes wrote:
> > > > > > > > > > > On Fri, Jul 12, 2019 at 01:00:18PM -0400, Joel Fernandes (Google) wrote:
> > > > > > > > > > > > The rcu/sync code was doing its own check whether we are in a reader
> > > > > > > > > > > > section. With RCU consolidating flavors and the generic helper added in
> > > > > > > > > > > > this series, this is no longer need. We can just use the generic helper
> > > > > > > > > > > > and it results in a nice cleanup.
> > > > > > > > > > > > 
> > > > > > > > > > > > Cc: Oleg Nesterov <oleg@redhat.com>
> > > > > > > > > > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > > > > > > > > > 
> > > > > > > > > > > Hi Oleg,
> > > > > > > > > > > Slightly unrelated to the patch,
> > > > > > > > > > > I tried hard to understand this comment below in percpu_down_read() but no dice.
> > > > > > > > > > > 
> > > > > > > > > > > I do understand how rcu sync and percpu rwsem works, however the comment
> > > > > > > > > > > below didn't make much sense to me. For one, there's no readers_fast anymore
> > > > > > > > > > > so I did not follow what readers_fast means. Could the comment be updated to
> > > > > > > > > > > reflect latest changes?
> > > > > > > > > > > Also could you help understand how is a writer not able to change
> > > > > > > > > > > sem->state and count the per-cpu read counters at the same time as the
> > > > > > > > > > > comment tries to say?
> > > > > > > > > > > 
> > > > > > > > > > > 	/*
> > > > > > > > > > > 	 * We are in an RCU-sched read-side critical section, so the writer
> > > > > > > > > > > 	 * cannot both change sem->state from readers_fast and start checking
> > > > > > > > > > > 	 * counters while we are here. So if we see !sem->state, we know that
> > > > > > > > > > > 	 * the writer won't be checking until we're past the preempt_enable()
> > > > > > > > > > > 	 * and that once the synchronize_rcu() is done, the writer will see
> > > > > > > > > > > 	 * anything we did within this RCU-sched read-size critical section.
> > > > > > > > > > > 	 */
> > > > > > > > > > > 
> > > > > > > > > > > Also,
> > > > > > > > > > > I guess we could get rid of all of the gp_ops struct stuff now that since all
> > > > > > > > > > > the callbacks are the same now. I will post that as a follow-up patch to this
> > > > > > > > > > > series.
> > > > > > > > > > 
> > > > > > > > > > Hello, Joel,
> > > > > > > > > > 
> > > > > > > > > > Oleg has a set of patches updating this code that just hit mainline
> > > > > > > > > > this week.  These patches get rid of the code that previously handled
> > > > > > > > > > RCU's multiple flavors.  Or are you looking at current mainline and
> > > > > > > > > > me just missing your point?
> > > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > Hi Paul,
> > > > > > > > > You are right on point. I have a bad habit of not rebasing my trees. In this
> > > > > > > > > case the feature branch of mine in concern was based on v5.1. Needless to
> > > > > > > > > say, I need to rebase my tree.
> > > > > > > > > 
> > > > > > > > > Yes, this sync clean up patch does conflict when I rebase, but other patches
> > > > > > > > > rebase just fine.
> > > > > > > > > 
> > > > > > > > > The 2 options I see are:
> > > > > > > > > 1. Let us drop this patch for now and I resend it later.
> > > > > > > > > 2. I resend all patches based on Linus's master branch.
> > > > > > > > 
> > > > > > > > Below is the updated patch based on Linus master branch:
> > > > > > > > 
> > > > > > > > ---8<-----------------------
> > > > > > > > 
> > > > > > > > >From 5f40c9a07fcf3d6dafc2189599d0ba9443097d0f Mon Sep 17 00:00:00 2001
> > > > > > > > From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
> > > > > > > > Date: Fri, 12 Jul 2019 12:13:27 -0400
> > > > > > > > Subject: [PATCH v2.1 3/9] rcu/sync: Remove custom check for reader-section
> > > > > > > > 
> > > > > > > > The rcu/sync code was doing its own check whether we are in a reader
> > > > > > > > section. With RCU consolidating flavors and the generic helper added in
> > > > > > > > this series, this is no longer need. We can just use the generic helper
> > > > > > > > and it results in a nice cleanup.
> > > > > > > > 
> > > > > > > > Cc: Oleg Nesterov <oleg@redhat.com>
> > > > > > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > > > > > > ---
> > > > > > > >  include/linux/rcu_sync.h | 4 +---
> > > > > > > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > > > > > > > 
> > > > > > > > diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
> > > > > > > > index 9b83865d24f9..0027d4c8087c 100644
> > > > > > > > --- a/include/linux/rcu_sync.h
> > > > > > > > +++ b/include/linux/rcu_sync.h
> > > > > > > > @@ -31,9 +31,7 @@ struct rcu_sync {
> > > > > > > >   */
> > > > > > > >  static inline bool rcu_sync_is_idle(struct rcu_sync *rsp)
> > > > > > > >  {
> > > > > > > > -	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
> > > > > > > > -			 !rcu_read_lock_bh_held() &&
> > > > > > > > -			 !rcu_read_lock_sched_held(),
> > > > > > > > +	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
> > > > > > > 
> > > > > > > I believe that replacing rcu_read_lock_sched_held() with preemptible()
> > > > > > > in a CONFIG_PREEMPT=n kernel will give you false-positive splats here.
> > > > > > > If you have not already done so, could you please give it a try?
> > > > > > 
> > > > > > Hi Paul,
> > > > > > I don't think it will cause splats for !CONFIG_PREEMPT.
> > > > > > 
> > > > > > Currently, rcu_read_lock_any_held() introduced in this patch returns true if
> > > > > > !preemptible(). This means that:
> > > > > > 
> > > > > > The following expression above:
> > > > > > RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),...)
> > > > > > 
> > > > > > Becomes:
> > > > > > RCU_LOCKDEP_WARN(preemptible(), ...)
> > > > > > 
> > > > > > For, CONFIG_PREEMPT=n kernels, this means:
> > > > > > RCU_LOCKDEP_WARN(0, ...)
> > > > > > 
> > > > > > Which would mean no splats. Or, did I miss the point?
> > > > > 
> > > > > I suggest trying it out on a CONFIG_PREEMPT=n kernel.
> > > > 
> > > > Sure, will do, sorry did not try it out yet because was busy with weekend
> > > > chores but will do soon, thanks!
> > > 
> > > I am not faulting you for taking the weekend off, actually.  ;-)
> > 
> > ;-) 
> > 
> > I tried doing RCU_LOCKDEP_WARN(preemptible(), ...) in this code path and I
> > don't get any splats. I also disassembled the code and it seems to me
> > RCU_LOCKDEP_WARN() becomes a NOOP which also the above reasoning confirms.
> 
> OK, very good.  Could you do the same thing for the RCU_LOCKDEP_WARN()
> in synchronize_rcu()?  Why or why not?
> 

Hi Paul,

Yes synchronize_rcu() can also make use of this technique since it is
strictly illegal to call synchronize_rcu() within a reader section.

I will add this to the set of my patches as well and send them all out next
week, along with the rcu-sync and bh clean ups we discussed.

thanks,

- Joel

