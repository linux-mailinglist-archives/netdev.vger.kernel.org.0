Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E954677C2
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 05:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbfGMDKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 23:10:12 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42005 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbfGMDKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 23:10:11 -0400
Received: by mail-pl1-f194.google.com with SMTP id ay6so5666027plb.9
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 20:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Yj0KzWPPj2wTNOobGgks3QqTli1sq+vFUwn/IZyvMdc=;
        b=lOqMuQRexi/hVxa/4p77SbaQvlMGoDh5aaBC9i1MTtOwCN7njvsbB5lQDbBmriZ1WA
         FWWHLnYwSi1u/Badms6e151ITEB+l7THYTAcQrSxD3Gt/lUVga9IZ5YlpJa+tNPnpYnH
         zxZrbWgIwEXHbV94dqGpKtSAH3ynqx9mn/E50=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Yj0KzWPPj2wTNOobGgks3QqTli1sq+vFUwn/IZyvMdc=;
        b=F7Iwk3qyBaI6Ib7Us+odEPHWguJH7Yai7Iu/pfjG5X6x2S+HfGYiKnYqZDnrDTzyW1
         s6WY8XGmuaj1tzZleUg2uDwoujFo3+MQZG6Ts+lVSUq9Uwl4xWbQoLrYOyP10Bc/DFuU
         c3OUqjlrVD+PwvorqERvs0Y9r8N7hURgeBWZVsURzqctEK8pkD1dcTZMnFvQK9fZARRy
         30bp18A4pgJrnYrKx3uuNmq3OBSWxupgE6c9Z437HwSgS7FrBBbegvMoxkEspRsrPQYI
         1DKPy3ULfTYxxWJLOIF8j8+A6cEKZeGacsSaPX+Qdxc230zMCR/6VgmyZXdt4p7IJJHY
         NLWA==
X-Gm-Message-State: APjAAAVX2S3OVaAfZ05DaoWP939GMOGPzRySv+rWKrHktUCovx9Nfchf
        VjFz85kDxSz/wU1d+nbczzk=
X-Google-Smtp-Source: APXvYqzYmXDx79APPhOf6U2U81XcESDp7O9GeiDZBYQYdv6r3PCBBKB8Rg1+OBGlaGf1FYhUnpz+lQ==
X-Received: by 2002:a17:902:704a:: with SMTP id h10mr15163948plt.337.1562987410632;
        Fri, 12 Jul 2019 20:10:10 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id m31sm10466015pjb.6.2019.07.12.20.10.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 20:10:09 -0700 (PDT)
Date:   Fri, 12 Jul 2019 23:10:08 -0400
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
Message-ID: <20190713031008.GA248225@google.com>
References: <20190712170024.111093-1-joel@joelfernandes.org>
 <20190712170024.111093-4-joel@joelfernandes.org>
 <20190712213559.GA175138@google.com>
 <20190712233206.GZ26519@linux.ibm.com>
 <20190713030150.GA246587@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190713030150.GA246587@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 11:01:50PM -0400, Joel Fernandes wrote:
> On Fri, Jul 12, 2019 at 04:32:06PM -0700, Paul E. McKenney wrote:
> > On Fri, Jul 12, 2019 at 05:35:59PM -0400, Joel Fernandes wrote:
> > > On Fri, Jul 12, 2019 at 01:00:18PM -0400, Joel Fernandes (Google) wrote:
> > > > The rcu/sync code was doing its own check whether we are in a reader
> > > > section. With RCU consolidating flavors and the generic helper added in
> > > > this series, this is no longer need. We can just use the generic helper
> > > > and it results in a nice cleanup.
> > > > 
> > > > Cc: Oleg Nesterov <oleg@redhat.com>
> > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > 
> > > Hi Oleg,
> > > Slightly unrelated to the patch,
> > > I tried hard to understand this comment below in percpu_down_read() but no dice.
> > > 
> > > I do understand how rcu sync and percpu rwsem works, however the comment
> > > below didn't make much sense to me. For one, there's no readers_fast anymore
> > > so I did not follow what readers_fast means. Could the comment be updated to
> > > reflect latest changes?
> > > Also could you help understand how is a writer not able to change
> > > sem->state and count the per-cpu read counters at the same time as the
> > > comment tries to say?
> > > 
> > > 	/*
> > > 	 * We are in an RCU-sched read-side critical section, so the writer
> > > 	 * cannot both change sem->state from readers_fast and start checking
> > > 	 * counters while we are here. So if we see !sem->state, we know that
> > > 	 * the writer won't be checking until we're past the preempt_enable()
> > > 	 * and that once the synchronize_rcu() is done, the writer will see
> > > 	 * anything we did within this RCU-sched read-size critical section.
> > > 	 */
> > > 
> > > Also,
> > > I guess we could get rid of all of the gp_ops struct stuff now that since all
> > > the callbacks are the same now. I will post that as a follow-up patch to this
> > > series.
> > 
> > Hello, Joel,
> > 
> > Oleg has a set of patches updating this code that just hit mainline
> > this week.  These patches get rid of the code that previously handled
> > RCU's multiple flavors.  Or are you looking at current mainline and
> > me just missing your point?
> > 
> 
> Hi Paul,
> You are right on point. I have a bad habit of not rebasing my trees. In this
> case the feature branch of mine in concern was based on v5.1. Needless to
> say, I need to rebase my tree.
> 
> Yes, this sync clean up patch does conflict when I rebase, but other patches
> rebase just fine.
> 
> The 2 options I see are:
> 1. Let us drop this patch for now and I resend it later.
> 2. I resend all patches based on Linus's master branch.

Below is the updated patch based on Linus master branch:

---8<-----------------------

From 5f40c9a07fcf3d6dafc2189599d0ba9443097d0f Mon Sep 17 00:00:00 2001
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Date: Fri, 12 Jul 2019 12:13:27 -0400
Subject: [PATCH v2.1 3/9] rcu/sync: Remove custom check for reader-section

The rcu/sync code was doing its own check whether we are in a reader
section. With RCU consolidating flavors and the generic helper added in
this series, this is no longer need. We can just use the generic helper
and it results in a nice cleanup.

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/linux/rcu_sync.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
index 9b83865d24f9..0027d4c8087c 100644
--- a/include/linux/rcu_sync.h
+++ b/include/linux/rcu_sync.h
@@ -31,9 +31,7 @@ struct rcu_sync {
  */
 static inline bool rcu_sync_is_idle(struct rcu_sync *rsp)
 {
-	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
-			 !rcu_read_lock_bh_held() &&
-			 !rcu_read_lock_sched_held(),
+	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
 			 "suspicious rcu_sync_is_idle() usage");
 	return !READ_ONCE(rsp->gp_state); /* GP_IDLE */
 }
-- 
2.22.0.510.g264f2c817a-goog

