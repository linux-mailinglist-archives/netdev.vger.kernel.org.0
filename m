Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B77FB676D0
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 01:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbfGLX3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 19:29:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33952 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727708AbfGLX3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 19:29:38 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6CNQTvq126655;
        Fri, 12 Jul 2019 19:27:52 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tq1edmrsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jul 2019 19:27:51 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6CNRp20129119;
        Fri, 12 Jul 2019 19:27:51 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tq1edmrs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jul 2019 19:27:51 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6CNOt68016432;
        Fri, 12 Jul 2019 23:27:50 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01wdc.us.ibm.com with ESMTP id 2tjk9770y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jul 2019 23:27:50 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6CNRoPJ46596522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 23:27:50 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7DEFB205F;
        Fri, 12 Jul 2019 23:27:49 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91A01B2065;
        Fri, 12 Jul 2019 23:27:49 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.195.235])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 12 Jul 2019 23:27:49 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 01C5C16C39C0; Fri, 12 Jul 2019 16:27:49 -0700 (PDT)
Date:   Fri, 12 Jul 2019 16:27:49 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org, oleg@redhat.com,
        Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v1 1/6] rcu: Add support for consolidated-RCU reader
 checking
Message-ID: <20190712232749.GY26519@linux.ibm.com>
Reply-To: paulmck@linux.ibm.com
References: <20190711234401.220336-1-joel@joelfernandes.org>
 <20190711234401.220336-2-joel@joelfernandes.org>
 <20190712111125.GT3402@hirez.programming.kicks-ass.net>
 <20190712151051.GB235410@google.com>
 <20190712164531.GW26519@linux.ibm.com>
 <20190712170631.GA111598@google.com>
 <20190712174630.GX26519@linux.ibm.com>
 <20190712194040.GA150253@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712194040.GA150253@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120241
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 03:40:40PM -0400, Joel Fernandes wrote:
> On Fri, Jul 12, 2019 at 10:46:30AM -0700, Paul E. McKenney wrote:
> > On Fri, Jul 12, 2019 at 01:06:31PM -0400, Joel Fernandes wrote:
> > > On Fri, Jul 12, 2019 at 09:45:31AM -0700, Paul E. McKenney wrote:
> > > > On Fri, Jul 12, 2019 at 11:10:51AM -0400, Joel Fernandes wrote:
> > > > > On Fri, Jul 12, 2019 at 01:11:25PM +0200, Peter Zijlstra wrote:
> > > > > > On Thu, Jul 11, 2019 at 07:43:56PM -0400, Joel Fernandes (Google) wrote:
> > > > > > > +int rcu_read_lock_any_held(void)
> > > > > > > +{
> > > > > > > +	int lockdep_opinion = 0;
> > > > > > > +
> > > > > > > +	if (!debug_lockdep_rcu_enabled())
> > > > > > > +		return 1;
> > > > > > > +	if (!rcu_is_watching())
> > > > > > > +		return 0;
> > > > > > > +	if (!rcu_lockdep_current_cpu_online())
> > > > > > > +		return 0;
> > > > > > > +
> > > > > > > +	/* Preemptible RCU flavor */
> > > > > > > +	if (lock_is_held(&rcu_lock_map))
> > > > > > 
> > > > > > you forgot debug_locks here.
> > > > > 
> > > > > Actually, it turns out debug_locks checking is not even needed. If
> > > > > debug_locks == 0, then debug_lockdep_rcu_enabled() returns 0 and we would not
> > > > > get to this point.
> > > > > 
> > > > > > > +		return 1;
> > > > > > > +
> > > > > > > +	/* BH flavor */
> > > > > > > +	if (in_softirq() || irqs_disabled())
> > > > > > 
> > > > > > I'm not sure I'd put irqs_disabled() under BH, also this entire
> > > > > > condition is superfluous, see below.
> > > > > > 
> > > > > > > +		return 1;
> > > > > > > +
> > > > > > > +	/* Sched flavor */
> > > > > > > +	if (debug_locks)
> > > > > > > +		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
> > > > > > > +	return lockdep_opinion || !preemptible();
> > > > > > 
> > > > > > that !preemptible() turns into:
> > > > > > 
> > > > > >   !(preempt_count()==0 && !irqs_disabled())
> > > > > > 
> > > > > > which is:
> > > > > > 
> > > > > >   preempt_count() != 0 || irqs_disabled()
> > > > > > 
> > > > > > and already includes irqs_disabled() and in_softirq().
> > > > > > 
> > > > > > > +}
> > > > > > 
> > > > > > So maybe something lke:
> > > > > > 
> > > > > > 	if (debug_locks && (lock_is_held(&rcu_lock_map) ||
> > > > > > 			    lock_is_held(&rcu_sched_lock_map)))
> > > > > > 		return true;
> > > > > 
> > > > > Agreed, I will do it this way (without the debug_locks) like:
> > > > > 
> > > > > ---8<-----------------------
> > > > > 
> > > > > diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> > > > > index ba861d1716d3..339aebc330db 100644
> > > > > --- a/kernel/rcu/update.c
> > > > > +++ b/kernel/rcu/update.c
> > > > > @@ -296,27 +296,15 @@ EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
> > > > >  
> > > > >  int rcu_read_lock_any_held(void)
> > > > >  {
> > > > > -	int lockdep_opinion = 0;
> > > > > -
> > > > >  	if (!debug_lockdep_rcu_enabled())
> > > > >  		return 1;
> > > > >  	if (!rcu_is_watching())
> > > > >  		return 0;
> > > > >  	if (!rcu_lockdep_current_cpu_online())
> > > > >  		return 0;
> > > > > -
> > > > > -	/* Preemptible RCU flavor */
> > > > > -	if (lock_is_held(&rcu_lock_map))
> > > > > -		return 1;
> > > > > -
> > > > > -	/* BH flavor */
> > > > > -	if (in_softirq() || irqs_disabled())
> > > > > -		return 1;
> > > > > -
> > > > > -	/* Sched flavor */
> > > > > -	if (debug_locks)
> > > > > -		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
> > > > > -	return lockdep_opinion || !preemptible();
> > > > > +	if (lock_is_held(&rcu_lock_map) || lock_is_held(&rcu_sched_lock_map))
> > > > 
> > > > OK, I will bite...  Why not also lock_is_held(&rcu_bh_lock_map)?
> > > 
> > > Hmm, I was borrowing the strategy from rcu_read_lock_bh_held() which does not
> > > check for a lock held in this map.
> > > 
> > > Honestly, even  lock_is_held(&rcu_sched_lock_map) seems unnecessary per-se
> > > since !preemptible() will catch that? rcu_read_lock_sched() disables
> > > preemption already, so lockdep's opinion of the matter seems redundant there.
> > 
> > Good point!  At least as long as the lockdep splats list RCU-bh among
> > the locks held, which they did last I checked.
> > 
> > Of course, you could make the same argument for getting rid of
> > rcu_sched_lock_map.  Does it make sense to have the one without
> > the other?
> 
> It probably makes it inconsistent in the least. I will add the check for
> the rcu_bh_lock_map in a separate patch, if that's Ok with you - since I also
> want to update the rcu_read_lock_bh_held() logic in the same patch.
> 
> That rcu_read_lock_bh_held() could also just return !preemptible as Peter
> suggested for the bh case.

Although that seems reasonable, please check the call sites.

> > > Sorry I already sent out patches again before seeing your comment but I can
> > > rework and resend them based on any other suggestions.
> > 
> > Not a problem!
> 
> Thanks. Depending on whether there is any other feedback, I will work on the
> bh_ stuff as a separate patch on top of this series, or work it into the next
> series revision if I'm reposting. Hopefully that sounds Ok to you.

Agreed -- let's separate concerns.  And promote bisectability.

							Thanx, Paul
