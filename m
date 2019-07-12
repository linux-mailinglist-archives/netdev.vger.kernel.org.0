Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E5E67499
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 19:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfGLRrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 13:47:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727072AbfGLRrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 13:47:06 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6CHl2c1043906
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 13:47:05 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tpw8y3x5h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 13:47:04 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Fri, 12 Jul 2019 18:46:41 +0100
Received: from b01cxnp23032.gho.pok.ibm.com (9.57.198.27)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 12 Jul 2019 18:46:32 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6CHkV9l45744612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 17:46:31 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15274B2068;
        Fri, 12 Jul 2019 17:46:31 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDE0AB2065;
        Fri, 12 Jul 2019 17:46:30 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.195.235])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 12 Jul 2019 17:46:30 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id D5A7B16C0E5D; Fri, 12 Jul 2019 10:46:30 -0700 (PDT)
Date:   Fri, 12 Jul 2019 10:46:30 -0700
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
Reply-To: paulmck@linux.ibm.com
References: <20190711234401.220336-1-joel@joelfernandes.org>
 <20190711234401.220336-2-joel@joelfernandes.org>
 <20190712111125.GT3402@hirez.programming.kicks-ass.net>
 <20190712151051.GB235410@google.com>
 <20190712164531.GW26519@linux.ibm.com>
 <20190712170631.GA111598@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712170631.GA111598@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19071217-0064-0000-0000-000003FB1044
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011416; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01231197; UDB=6.00648560; IPR=6.01012481;
 MB=3.00027693; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-12 17:46:39
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071217-0065-0000-0000-00003E3CAF14
Message-Id: <20190712174630.GX26519@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 01:06:31PM -0400, Joel Fernandes wrote:
> On Fri, Jul 12, 2019 at 09:45:31AM -0700, Paul E. McKenney wrote:
> > On Fri, Jul 12, 2019 at 11:10:51AM -0400, Joel Fernandes wrote:
> > > On Fri, Jul 12, 2019 at 01:11:25PM +0200, Peter Zijlstra wrote:
> > > > On Thu, Jul 11, 2019 at 07:43:56PM -0400, Joel Fernandes (Google) wrote:
> > > > > +int rcu_read_lock_any_held(void)
> > > > > +{
> > > > > +	int lockdep_opinion = 0;
> > > > > +
> > > > > +	if (!debug_lockdep_rcu_enabled())
> > > > > +		return 1;
> > > > > +	if (!rcu_is_watching())
> > > > > +		return 0;
> > > > > +	if (!rcu_lockdep_current_cpu_online())
> > > > > +		return 0;
> > > > > +
> > > > > +	/* Preemptible RCU flavor */
> > > > > +	if (lock_is_held(&rcu_lock_map))
> > > > 
> > > > you forgot debug_locks here.
> > > 
> > > Actually, it turns out debug_locks checking is not even needed. If
> > > debug_locks == 0, then debug_lockdep_rcu_enabled() returns 0 and we would not
> > > get to this point.
> > > 
> > > > > +		return 1;
> > > > > +
> > > > > +	/* BH flavor */
> > > > > +	if (in_softirq() || irqs_disabled())
> > > > 
> > > > I'm not sure I'd put irqs_disabled() under BH, also this entire
> > > > condition is superfluous, see below.
> > > > 
> > > > > +		return 1;
> > > > > +
> > > > > +	/* Sched flavor */
> > > > > +	if (debug_locks)
> > > > > +		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
> > > > > +	return lockdep_opinion || !preemptible();
> > > > 
> > > > that !preemptible() turns into:
> > > > 
> > > >   !(preempt_count()==0 && !irqs_disabled())
> > > > 
> > > > which is:
> > > > 
> > > >   preempt_count() != 0 || irqs_disabled()
> > > > 
> > > > and already includes irqs_disabled() and in_softirq().
> > > > 
> > > > > +}
> > > > 
> > > > So maybe something lke:
> > > > 
> > > > 	if (debug_locks && (lock_is_held(&rcu_lock_map) ||
> > > > 			    lock_is_held(&rcu_sched_lock_map)))
> > > > 		return true;
> > > 
> > > Agreed, I will do it this way (without the debug_locks) like:
> > > 
> > > ---8<-----------------------
> > > 
> > > diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> > > index ba861d1716d3..339aebc330db 100644
> > > --- a/kernel/rcu/update.c
> > > +++ b/kernel/rcu/update.c
> > > @@ -296,27 +296,15 @@ EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
> > >  
> > >  int rcu_read_lock_any_held(void)
> > >  {
> > > -	int lockdep_opinion = 0;
> > > -
> > >  	if (!debug_lockdep_rcu_enabled())
> > >  		return 1;
> > >  	if (!rcu_is_watching())
> > >  		return 0;
> > >  	if (!rcu_lockdep_current_cpu_online())
> > >  		return 0;
> > > -
> > > -	/* Preemptible RCU flavor */
> > > -	if (lock_is_held(&rcu_lock_map))
> > > -		return 1;
> > > -
> > > -	/* BH flavor */
> > > -	if (in_softirq() || irqs_disabled())
> > > -		return 1;
> > > -
> > > -	/* Sched flavor */
> > > -	if (debug_locks)
> > > -		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
> > > -	return lockdep_opinion || !preemptible();
> > > +	if (lock_is_held(&rcu_lock_map) || lock_is_held(&rcu_sched_lock_map))
> > 
> > OK, I will bite...  Why not also lock_is_held(&rcu_bh_lock_map)?
> 
> Hmm, I was borrowing the strategy from rcu_read_lock_bh_held() which does not
> check for a lock held in this map.
> 
> Honestly, even  lock_is_held(&rcu_sched_lock_map) seems unnecessary per-se
> since !preemptible() will catch that? rcu_read_lock_sched() disables
> preemption already, so lockdep's opinion of the matter seems redundant there.

Good point!  At least as long as the lockdep splats list RCU-bh among
the locks held, which they did last I checked.

Of course, you could make the same argument for getting rid of
rcu_sched_lock_map.  Does it make sense to have the one without
the other?

> Sorry I already sent out patches again before seeing your comment but I can
> rework and resend them based on any other suggestions.

Not a problem!

							Thax, Paul

