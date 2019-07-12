Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 241C0676D7
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 01:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbfGLXdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 19:33:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56926 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727708AbfGLXdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 19:33:53 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6CNVOI1122769;
        Fri, 12 Jul 2019 19:32:10 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tpyhv03fs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jul 2019 19:32:09 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6CNVQbt122880;
        Fri, 12 Jul 2019 19:32:09 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tpyhv03f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jul 2019 19:32:09 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6CNTuof009911;
        Fri, 12 Jul 2019 23:32:07 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 2tjk97y3mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jul 2019 23:32:07 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6CNW6a351839248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 23:32:06 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC6ECB2064;
        Fri, 12 Jul 2019 23:32:06 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65EA2B2066;
        Fri, 12 Jul 2019 23:32:06 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.195.235])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 12 Jul 2019 23:32:06 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id CAE8816C3FC8; Fri, 12 Jul 2019 16:32:06 -0700 (PDT)
Date:   Fri, 12 Jul 2019 16:32:06 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Joel Fernandes <joel@joelfernandes.org>
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
Message-ID: <20190712233206.GZ26519@linux.ibm.com>
Reply-To: paulmck@linux.ibm.com
References: <20190712170024.111093-1-joel@joelfernandes.org>
 <20190712170024.111093-4-joel@joelfernandes.org>
 <20190712213559.GA175138@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712213559.GA175138@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120242
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 05:35:59PM -0400, Joel Fernandes wrote:
> On Fri, Jul 12, 2019 at 01:00:18PM -0400, Joel Fernandes (Google) wrote:
> > The rcu/sync code was doing its own check whether we are in a reader
> > section. With RCU consolidating flavors and the generic helper added in
> > this series, this is no longer need. We can just use the generic helper
> > and it results in a nice cleanup.
> > 
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> Hi Oleg,
> Slightly unrelated to the patch,
> I tried hard to understand this comment below in percpu_down_read() but no dice.
> 
> I do understand how rcu sync and percpu rwsem works, however the comment
> below didn't make much sense to me. For one, there's no readers_fast anymore
> so I did not follow what readers_fast means. Could the comment be updated to
> reflect latest changes?
> Also could you help understand how is a writer not able to change
> sem->state and count the per-cpu read counters at the same time as the
> comment tries to say?
> 
> 	/*
> 	 * We are in an RCU-sched read-side critical section, so the writer
> 	 * cannot both change sem->state from readers_fast and start checking
> 	 * counters while we are here. So if we see !sem->state, we know that
> 	 * the writer won't be checking until we're past the preempt_enable()
> 	 * and that once the synchronize_rcu() is done, the writer will see
> 	 * anything we did within this RCU-sched read-size critical section.
> 	 */
> 
> Also,
> I guess we could get rid of all of the gp_ops struct stuff now that since all
> the callbacks are the same now. I will post that as a follow-up patch to this
> series.

Hello, Joel,

Oleg has a set of patches updating this code that just hit mainline
this week.  These patches get rid of the code that previously handled
RCU's multiple flavors.  Or are you looking at current mainline and
me just missing your point?

							Thanx, Paul

> thanks!
> 
>  - Joel
> 
> 
> > ---
> > Please note: Only build and boot tested this particular patch so far.
> > 
> >  include/linux/rcu_sync.h |  5 ++---
> >  kernel/rcu/sync.c        | 22 ----------------------
> >  2 files changed, 2 insertions(+), 25 deletions(-)
> > 
> > diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
> > index 6fc53a1345b3..c954f1efc919 100644
> > --- a/include/linux/rcu_sync.h
> > +++ b/include/linux/rcu_sync.h
> > @@ -39,9 +39,8 @@ extern void rcu_sync_lockdep_assert(struct rcu_sync *);
> >   */
> >  static inline bool rcu_sync_is_idle(struct rcu_sync *rsp)
> >  {
> > -#ifdef CONFIG_PROVE_RCU
> > -	rcu_sync_lockdep_assert(rsp);
> > -#endif
> > +	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
> > +			 "suspicious rcu_sync_is_idle() usage");
> >  	return !rsp->gp_state; /* GP_IDLE */
> >  }
> >  
> > diff --git a/kernel/rcu/sync.c b/kernel/rcu/sync.c
> > index a8304d90573f..535e02601f56 100644
> > --- a/kernel/rcu/sync.c
> > +++ b/kernel/rcu/sync.c
> > @@ -10,37 +10,25 @@
> >  #include <linux/rcu_sync.h>
> >  #include <linux/sched.h>
> >  
> > -#ifdef CONFIG_PROVE_RCU
> > -#define __INIT_HELD(func)	.held = func,
> > -#else
> > -#define __INIT_HELD(func)
> > -#endif
> > -
> >  static const struct {
> >  	void (*sync)(void);
> >  	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
> >  	void (*wait)(void);
> > -#ifdef CONFIG_PROVE_RCU
> > -	int  (*held)(void);
> > -#endif
> >  } gp_ops[] = {
> >  	[RCU_SYNC] = {
> >  		.sync = synchronize_rcu,
> >  		.call = call_rcu,
> >  		.wait = rcu_barrier,
> > -		__INIT_HELD(rcu_read_lock_held)
> >  	},
> >  	[RCU_SCHED_SYNC] = {
> >  		.sync = synchronize_rcu,
> >  		.call = call_rcu,
> >  		.wait = rcu_barrier,
> > -		__INIT_HELD(rcu_read_lock_sched_held)
> >  	},
> >  	[RCU_BH_SYNC] = {
> >  		.sync = synchronize_rcu,
> >  		.call = call_rcu,
> >  		.wait = rcu_barrier,
> > -		__INIT_HELD(rcu_read_lock_bh_held)
> >  	},
> >  };
> >  
> > @@ -49,16 +37,6 @@ enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
> >  
> >  #define	rss_lock	gp_wait.lock
> >  
> > -#ifdef CONFIG_PROVE_RCU
> > -void rcu_sync_lockdep_assert(struct rcu_sync *rsp)
> > -{
> > -	RCU_LOCKDEP_WARN(!gp_ops[rsp->gp_type].held(),
> > -			 "suspicious rcu_sync_is_idle() usage");
> > -}
> > -
> > -EXPORT_SYMBOL_GPL(rcu_sync_lockdep_assert);
> > -#endif
> > -
> >  /**
> >   * rcu_sync_init() - Initialize an rcu_sync structure
> >   * @rsp: Pointer to rcu_sync structure to be initialized
> > -- 
> > 2.22.0.510.g264f2c817a-goog
> > 
> 
