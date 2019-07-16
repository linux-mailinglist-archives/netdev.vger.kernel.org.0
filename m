Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1DE26AF44
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 20:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388607AbfGPSxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 14:53:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22174 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388373AbfGPSxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 14:53:17 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6GIpnVO117969
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 14:53:16 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tsjhm4d0j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 14:53:16 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Tue, 16 Jul 2019 19:53:15 +0100
Received: from b01cxnp22036.gho.pok.ibm.com (9.57.198.26)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 16 Jul 2019 19:53:05 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6GIr4HN37159330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 18:53:04 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A27FB2067;
        Tue, 16 Jul 2019 18:53:04 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E778DB2064;
        Tue, 16 Jul 2019 18:53:03 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.80.225.134])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 16 Jul 2019 18:53:03 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 011B016C8E9B; Tue, 16 Jul 2019 11:53:03 -0700 (PDT)
Date:   Tue, 16 Jul 2019 11:53:03 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
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
        Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        peterz@infradead.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 2/9] rcu: Add support for consolidated-RCU reader
 checking (v3)
Reply-To: paulmck@linux.ibm.com
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-3-joel@joelfernandes.org>
 <20190716183833.GD14271@linux.ibm.com>
 <20190716184649.GA130463@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716184649.GA130463@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19071618-0072-0000-0000-00000449B137
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011440; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01233111; UDB=6.00649721; IPR=6.01014423;
 MB=3.00027748; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-16 18:53:14
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071618-0073-0000-0000-00004CB9FCC3
Message-Id: <20190716185303.GM14271@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160231
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 02:46:49PM -0400, Joel Fernandes wrote:
> On Tue, Jul 16, 2019 at 11:38:33AM -0700, Paul E. McKenney wrote:
> > On Mon, Jul 15, 2019 at 10:36:58AM -0400, Joel Fernandes (Google) wrote:
> > > This patch adds support for checking RCU reader sections in list
> > > traversal macros. Optionally, if the list macro is called under SRCU or
> > > other lock/mutex protection, then appropriate lockdep expressions can be
> > > passed to make the checks pass.
> > > 
> > > Existing list_for_each_entry_rcu() invocations don't need to pass the
> > > optional fourth argument (cond) unless they are under some non-RCU
> > > protection and needs to make lockdep check pass.
> > > 
> > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > 
> > Now that I am on the correct version, again please fold in the checks
> > for the extra argument.  The ability to have an optional argument looks
> > quite helpful, especially when compared to growing the RCU API!
> 
> I did fold this and replied with a pull request URL based on /dev branch. But
> we can hold off on the pull requests until we decide on the below comments:
> 
> > A few more things below.
> > > ---
> > >  include/linux/rculist.h  | 28 ++++++++++++++++++++-----
> > >  include/linux/rcupdate.h |  7 +++++++
> > >  kernel/rcu/Kconfig.debug | 11 ++++++++++
> > >  kernel/rcu/update.c      | 44 ++++++++++++++++++++++++----------------
> > >  4 files changed, 67 insertions(+), 23 deletions(-)
> > > 
> > > diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> > > index e91ec9ddcd30..1048160625bb 100644
> > > --- a/include/linux/rculist.h
> > > +++ b/include/linux/rculist.h
> > > @@ -40,6 +40,20 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
> > >   */
> > >  #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
> > >  
> > > +/*
> > > + * Check during list traversal that we are within an RCU reader
> > > + */
> > > +
> > > +#ifdef CONFIG_PROVE_RCU_LIST
> > 
> > This new Kconfig option is OK temporarily, but unless there is reason to
> > fear malfunction that a few weeks of rcutorture, 0day, and -next won't
> > find, it would be better to just use CONFIG_PROVE_RCU.  The overall goal
> > is to reduce the number of RCU knobs rather than grow them, must though
> > history might lead one to believe otherwise.  :-/
> 
> If you want, we can try to drop this option and just use PROVE_RCU however I
> must say there may be several warnings that need to be fixed in a short
> period of time (even a few weeks may be too short) considering the 1000+
> uses of RCU lists.

Do many people other than me build with CONFIG_PROVE_RCU?  If so, then
that would be a good reason for a temporary CONFIG_PROVE_RCU_LIST,
as in going away in a release or two once the warnings get fixed.

> But I don't mind dropping it and it may just accelerate the fixing up of all
> callers.

I will let you decide based on the above question.  But if you have
CONFIG_PROVE_RCU_LIST, as noted below, it needs to depend on RCU_EXPERT.

							Thanx, Paul

> > > +#define __list_check_rcu(dummy, cond, ...)				\
> > > +	({								\
> > > +	RCU_LOCKDEP_WARN(!cond && !rcu_read_lock_any_held(),		\
> > > +			 "RCU-list traversed in non-reader section!");	\
> > > +	 })
> > > +#else
> > > +#define __list_check_rcu(dummy, cond, ...) ({})
> > > +#endif
> > > +
> > >  /*
> > >   * Insert a new entry between two known consecutive entries.
> > >   *
> > > @@ -343,14 +357,16 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
> > >   * @pos:	the type * to use as a loop cursor.
> > >   * @head:	the head for your list.
> > >   * @member:	the name of the list_head within the struct.
> > > + * @cond:	optional lockdep expression if called from non-RCU protection.
> > >   *
> > >   * This list-traversal primitive may safely run concurrently with
> > >   * the _rcu list-mutation primitives such as list_add_rcu()
> > >   * as long as the traversal is guarded by rcu_read_lock().
> > >   */
> > > -#define list_for_each_entry_rcu(pos, head, member) \
> > > -	for (pos = list_entry_rcu((head)->next, typeof(*pos), member); \
> > > -		&pos->member != (head); \
> > > +#define list_for_each_entry_rcu(pos, head, member, cond...)		\
> > > +	for (__list_check_rcu(dummy, ## cond, 0),			\
> > > +	     pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
> > > +		&pos->member != (head);					\
> > >  		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
> > >  
> > >  /**
> > > @@ -616,13 +632,15 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
> > >   * @pos:	the type * to use as a loop cursor.
> > >   * @head:	the head for your list.
> > >   * @member:	the name of the hlist_node within the struct.
> > > + * @cond:	optional lockdep expression if called from non-RCU protection.
> > >   *
> > >   * This list-traversal primitive may safely run concurrently with
> > >   * the _rcu list-mutation primitives such as hlist_add_head_rcu()
> > >   * as long as the traversal is guarded by rcu_read_lock().
> > >   */
> > > -#define hlist_for_each_entry_rcu(pos, head, member)			\
> > > -	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
> > > +#define hlist_for_each_entry_rcu(pos, head, member, cond...)		\
> > > +	for (__list_check_rcu(dummy, ## cond, 0),			\
> > > +	     pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
> > >  			typeof(*(pos)), member);			\
> > >  		pos;							\
> > >  		pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(\
> > > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > > index 8f7167478c1d..f3c29efdf19a 100644
> > > --- a/include/linux/rcupdate.h
> > > +++ b/include/linux/rcupdate.h
> > > @@ -221,6 +221,7 @@ int debug_lockdep_rcu_enabled(void);
> > >  int rcu_read_lock_held(void);
> > >  int rcu_read_lock_bh_held(void);
> > >  int rcu_read_lock_sched_held(void);
> > > +int rcu_read_lock_any_held(void);
> > >  
> > >  #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
> > >  
> > > @@ -241,6 +242,12 @@ static inline int rcu_read_lock_sched_held(void)
> > >  {
> > >  	return !preemptible();
> > >  }
> > > +
> > > +static inline int rcu_read_lock_any_held(void)
> > > +{
> > > +	return !preemptible();
> > > +}
> > > +
> > >  #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
> > >  
> > >  #ifdef CONFIG_PROVE_RCU
> > > diff --git a/kernel/rcu/Kconfig.debug b/kernel/rcu/Kconfig.debug
> > > index 5ec3ea4028e2..7fbd21dbfcd0 100644
> > > --- a/kernel/rcu/Kconfig.debug
> > > +++ b/kernel/rcu/Kconfig.debug
> > > @@ -8,6 +8,17 @@ menu "RCU Debugging"
> > >  config PROVE_RCU
> > >  	def_bool PROVE_LOCKING
> > >  
> > > +config PROVE_RCU_LIST
> > > +	bool "RCU list lockdep debugging"
> > > +	depends on PROVE_RCU
> > 
> > This must also depend on RCU_EXPERT.  
> 
> Sure.
> 
> > > +	default n
> > > +	help
> > > +	  Enable RCU lockdep checking for list usages. By default it is
> > > +	  turned off since there are several list RCU users that still
> > > +	  need to be converted to pass a lockdep expression. To prevent
> > > +	  false-positive splats, we keep it default disabled but once all
> > > +	  users are converted, we can remove this config option.
> > > +
> > >  config TORTURE_TEST
> > >  	tristate
> > >  	default n
> > > diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> > > index 9dd5aeef6e70..b7a4e3b5fa98 100644
> > > --- a/kernel/rcu/update.c
> > > +++ b/kernel/rcu/update.c
> > > @@ -91,14 +91,18 @@ module_param(rcu_normal_after_boot, int, 0);
> > >   * Similarly, we avoid claiming an SRCU read lock held if the current
> > >   * CPU is offline.
> > >   */
> > > +#define rcu_read_lock_held_common()		\
> > > +	if (!debug_lockdep_rcu_enabled())	\
> > > +		return 1;			\
> > > +	if (!rcu_is_watching())			\
> > > +		return 0;			\
> > > +	if (!rcu_lockdep_current_cpu_online())	\
> > > +		return 0;
> > 
> > Nice abstraction of common code!
> 
> Thanks!
> 

