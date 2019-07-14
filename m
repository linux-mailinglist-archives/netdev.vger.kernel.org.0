Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78828680BB
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 20:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbfGNSiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 14:38:25 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42871 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbfGNSiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 14:38:24 -0400
Received: by mail-pg1-f193.google.com with SMTP id t132so6646959pgb.9
        for <netdev@vger.kernel.org>; Sun, 14 Jul 2019 11:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sox1qbAuMnPUwD0CgD0KdMKVv1SxdSpzlx78UgprX+8=;
        b=uvIXjc6RpIBKGJKLMswZL0zKOIbGCOqwZVMZfzv8f0e56iW5Xw+d175Iewh7O0m4QG
         PTQTK9CSolsfpH5eZHkNSyajv9VLH/1qzdWEVarVoP4ce8ZjKCT1LdIuWT1W9Ypl4naJ
         p98jtynPImVVZsE4/RPF3Jp7vxXCaWrM0dr5E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sox1qbAuMnPUwD0CgD0KdMKVv1SxdSpzlx78UgprX+8=;
        b=moSpoghJUuTuVxkl+VTkrlt2FuWp5uE+0UnTvev2ssXcnUYuAaBSJRVEFhATmNY+mf
         Wk9zOj+LWmhUWGhKlsuM2pGvQ4q8CFK5xaPLVwDlkMU2fdkQJApxRhqzEp3i2f4RvMl4
         q7ljFsTXTPJ1FSS6ip84wfes/LBbI9UmfRsMz/MK4BnQ8WaThqIy/L61gPVC4oOpafXS
         DqFkVvG5L7IIdU4dXzAxJquXfOgw7WbRgt8xOkR5I3c9rlD5S//lgImFn4yvGgWSf7xe
         ZOC//LIUPbtqZlFqYHKhzTYa3yy3wkcKJCZYXkR6olgDUuh+bNPvm0JXwuo3eBop9rYc
         iPHw==
X-Gm-Message-State: APjAAAV38wAOMDYW4b8ugPjgyRyKcYbuYbHg7W3aw7GQ3xDgO/7+cCO6
        nZJKP3Lmwbay9P76eq2VrPU=
X-Google-Smtp-Source: APXvYqzbkYP46GwBSD0mDA1ULApcyNEVrg5o30ItZY+eSVKxrnZ68GFxhMKl90asFkD9mHvD6qzZOw==
X-Received: by 2002:a65:4507:: with SMTP id n7mr21968240pgq.86.1563129503349;
        Sun, 14 Jul 2019 11:38:23 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id g2sm22630976pfq.88.2019.07.14.11.38.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 14 Jul 2019 11:38:22 -0700 (PDT)
Date:   Sun, 14 Jul 2019 14:38:20 -0400
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
Message-ID: <20190714183820.GD34501@google.com>
References: <20190713030150.GA246587@google.com>
 <20190713031008.GA248225@google.com>
 <20190713082114.GA26519@linux.ibm.com>
 <20190713133049.GA133650@google.com>
 <20190713144108.GD26519@linux.ibm.com>
 <20190713153606.GD133650@google.com>
 <20190713155010.GF26519@linux.ibm.com>
 <20190713161316.GA39321@google.com>
 <20190713212812.GH26519@linux.ibm.com>
 <20190714181053.GB34501@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190714181053.GB34501@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 14, 2019 at 02:10:53PM -0400, Joel Fernandes wrote:
> On Sat, Jul 13, 2019 at 02:28:12PM -0700, Paul E. McKenney wrote:
[snip]
> > > > > > > > > 
> > > > > > > > > Cc: Oleg Nesterov <oleg@redhat.com>
> > > > > > > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > > > > > > > ---
> > > > > > > > >  include/linux/rcu_sync.h | 4 +---
> > > > > > > > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > > > > > > > > 
> > > > > > > > > diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
> > > > > > > > > index 9b83865d24f9..0027d4c8087c 100644
> > > > > > > > > --- a/include/linux/rcu_sync.h
> > > > > > > > > +++ b/include/linux/rcu_sync.h
> > > > > > > > > @@ -31,9 +31,7 @@ struct rcu_sync {
> > > > > > > > >   */
> > > > > > > > >  static inline bool rcu_sync_is_idle(struct rcu_sync *rsp)
> > > > > > > > >  {
> > > > > > > > > -	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
> > > > > > > > > -			 !rcu_read_lock_bh_held() &&
> > > > > > > > > -			 !rcu_read_lock_sched_held(),
> > > > > > > > > +	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
> > > > > > > > 
> > > > > > > > I believe that replacing rcu_read_lock_sched_held() with preemptible()
> > > > > > > > in a CONFIG_PREEMPT=n kernel will give you false-positive splats here.
> > > > > > > > If you have not already done so, could you please give it a try?
> > > > > > > 
> > > > > > > Hi Paul,
> > > > > > > I don't think it will cause splats for !CONFIG_PREEMPT.
> > > > > > > 
> > > > > > > Currently, rcu_read_lock_any_held() introduced in this patch returns true if
> > > > > > > !preemptible(). This means that:
> > > > > > > 
> > > > > > > The following expression above:
> > > > > > > RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),...)
> > > > > > > 
> > > > > > > Becomes:
> > > > > > > RCU_LOCKDEP_WARN(preemptible(), ...)
> > > > > > > 
> > > > > > > For, CONFIG_PREEMPT=n kernels, this means:
> > > > > > > RCU_LOCKDEP_WARN(0, ...)
> > > > > > > 
> > > > > > > Which would mean no splats. Or, did I miss the point?
> > > > > > 
> > > > > > I suggest trying it out on a CONFIG_PREEMPT=n kernel.
> > > > > 
> > > > > Sure, will do, sorry did not try it out yet because was busy with weekend
> > > > > chores but will do soon, thanks!
> > > > 
> > > > I am not faulting you for taking the weekend off, actually.  ;-)
> > > 
> > > ;-) 
> > > 
> > > I tried doing RCU_LOCKDEP_WARN(preemptible(), ...) in this code path and I
> > > don't get any splats. I also disassembled the code and it seems to me
> > > RCU_LOCKDEP_WARN() becomes a NOOP which also the above reasoning confirms.
> > 
> > OK, very good.  Could you do the same thing for the RCU_LOCKDEP_WARN()
> > in synchronize_rcu()?  Why or why not?
> > 
> 
> Hi Paul,
> 
> Yes synchronize_rcu() can also make use of this technique since it is
> strictly illegal to call synchronize_rcu() within a reader section.
> 
> I will add this to the set of my patches as well and send them all out next
> week, along with the rcu-sync and bh clean ups we discussed.

After sending this email, it occurs to me it wont work in synchronize_rcu()
for !CONFIG_PREEMPT kernels. This is because in a !CONFIG_PREEMPT kernel,
executing in kernel mode itself looks like being in an RCU reader. So we
should leave that as is. However it will work fine for rcu_sync_is_idle (for
CONFIG_PREEMPT=n kernels) as I mentioned earlier.

Were trying to throw me a Quick-Quiz ? ;-) In that case, hope I passed!

thanks,

 - Joel

