Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71DFA6738E
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 18:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfGLQrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 12:47:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35344 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726907AbfGLQrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 12:47:37 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6CGbNjc009064;
        Fri, 12 Jul 2019 12:45:34 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tpwg69bjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jul 2019 12:45:34 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6CGc9J3011494;
        Fri, 12 Jul 2019 12:45:33 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tpwg69bj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jul 2019 12:45:33 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6CGZk3u012632;
        Fri, 12 Jul 2019 16:45:32 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01wdc.us.ibm.com with ESMTP id 2tjk974y8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jul 2019 16:45:32 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6CGjWjN49938828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 16:45:32 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 023ACB2064;
        Fri, 12 Jul 2019 16:45:32 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A010DB2067;
        Fri, 12 Jul 2019 16:45:31 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.195.235])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 12 Jul 2019 16:45:31 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 9973216C99E6; Fri, 12 Jul 2019 09:45:31 -0700 (PDT)
Date:   Fri, 12 Jul 2019 09:45:31 -0700
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
Message-ID: <20190712164531.GW26519@linux.ibm.com>
Reply-To: paulmck@linux.ibm.com
References: <20190711234401.220336-1-joel@joelfernandes.org>
 <20190711234401.220336-2-joel@joelfernandes.org>
 <20190712111125.GT3402@hirez.programming.kicks-ass.net>
 <20190712151051.GB235410@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712151051.GB235410@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120171
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 11:10:51AM -0400, Joel Fernandes wrote:
> On Fri, Jul 12, 2019 at 01:11:25PM +0200, Peter Zijlstra wrote:
> > On Thu, Jul 11, 2019 at 07:43:56PM -0400, Joel Fernandes (Google) wrote:
> > > +int rcu_read_lock_any_held(void)
> > > +{
> > > +	int lockdep_opinion = 0;
> > > +
> > > +	if (!debug_lockdep_rcu_enabled())
> > > +		return 1;
> > > +	if (!rcu_is_watching())
> > > +		return 0;
> > > +	if (!rcu_lockdep_current_cpu_online())
> > > +		return 0;
> > > +
> > > +	/* Preemptible RCU flavor */
> > > +	if (lock_is_held(&rcu_lock_map))
> > 
> > you forgot debug_locks here.
> 
> Actually, it turns out debug_locks checking is not even needed. If
> debug_locks == 0, then debug_lockdep_rcu_enabled() returns 0 and we would not
> get to this point.
> 
> > > +		return 1;
> > > +
> > > +	/* BH flavor */
> > > +	if (in_softirq() || irqs_disabled())
> > 
> > I'm not sure I'd put irqs_disabled() under BH, also this entire
> > condition is superfluous, see below.
> > 
> > > +		return 1;
> > > +
> > > +	/* Sched flavor */
> > > +	if (debug_locks)
> > > +		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
> > > +	return lockdep_opinion || !preemptible();
> > 
> > that !preemptible() turns into:
> > 
> >   !(preempt_count()==0 && !irqs_disabled())
> > 
> > which is:
> > 
> >   preempt_count() != 0 || irqs_disabled()
> > 
> > and already includes irqs_disabled() and in_softirq().
> > 
> > > +}
> > 
> > So maybe something lke:
> > 
> > 	if (debug_locks && (lock_is_held(&rcu_lock_map) ||
> > 			    lock_is_held(&rcu_sched_lock_map)))
> > 		return true;
> 
> Agreed, I will do it this way (without the debug_locks) like:
> 
> ---8<-----------------------
> 
> diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> index ba861d1716d3..339aebc330db 100644
> --- a/kernel/rcu/update.c
> +++ b/kernel/rcu/update.c
> @@ -296,27 +296,15 @@ EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
>  
>  int rcu_read_lock_any_held(void)
>  {
> -	int lockdep_opinion = 0;
> -
>  	if (!debug_lockdep_rcu_enabled())
>  		return 1;
>  	if (!rcu_is_watching())
>  		return 0;
>  	if (!rcu_lockdep_current_cpu_online())
>  		return 0;
> -
> -	/* Preemptible RCU flavor */
> -	if (lock_is_held(&rcu_lock_map))
> -		return 1;
> -
> -	/* BH flavor */
> -	if (in_softirq() || irqs_disabled())
> -		return 1;
> -
> -	/* Sched flavor */
> -	if (debug_locks)
> -		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
> -	return lockdep_opinion || !preemptible();
> +	if (lock_is_held(&rcu_lock_map) || lock_is_held(&rcu_sched_lock_map))

OK, I will bite...  Why not also lock_is_held(&rcu_bh_lock_map)?

							Thanx, Paul

> +		return 1;
> +	return !preemptible();
>  }
>  EXPORT_SYMBOL_GPL(rcu_read_lock_any_held);
>  
> 
