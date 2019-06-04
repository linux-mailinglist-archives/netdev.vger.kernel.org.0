Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68767351B3
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfFDVO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:14:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726352AbfFDVO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:14:58 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x54KvRx3061721
        for <netdev@vger.kernel.org>; Tue, 4 Jun 2019 17:14:57 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2swwy2p210-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 17:14:56 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Tue, 4 Jun 2019 22:14:55 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 4 Jun 2019 22:14:51 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x54LEosl34144530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Jun 2019 21:14:50 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 805E5B2064;
        Tue,  4 Jun 2019 21:14:50 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C4ECB2066;
        Tue,  4 Jun 2019 21:14:50 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.80.212.108])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  4 Jun 2019 21:14:50 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id A270016C3783; Tue,  4 Jun 2019 14:14:49 -0700 (PDT)
Date:   Tue, 4 Jun 2019 14:14:49 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: rcu_read_lock lost its compiler barrier
Reply-To: paulmck@linux.ibm.com
References: <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <20190603000617.GD28207@linux.ibm.com>
 <20190603030324.kl3bckqmebzis2vw@gondor.apana.org.au>
 <CAHk-=wj2t+GK+DGQ7Xy6U7zMf72e7Jkxn4_-kGyfH3WFEoH+YQ@mail.gmail.com>
 <CAHk-=wgZcrb_vQi5rwpv+=wwG+68SRDY16HcqcMtgPFL_kdfyQ@mail.gmail.com>
 <20190603195304.GK28207@linux.ibm.com>
 <CAHk-=whXb-QGZqOZ7S9YdjvQf7FNymzceinzJegvRALqXm3=FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whXb-QGZqOZ7S9YdjvQf7FNymzceinzJegvRALqXm3=FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19060421-2213-0000-0000-0000039A1A2E
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011215; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01213277; UDB=6.00637671; IPR=6.00994345;
 MB=3.00027185; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-04 21:14:54
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060421-2214-0000-0000-00005EB5AC43
Message-Id: <20190604211449.GU28207@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-04_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906040133
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 01:24:32PM -0700, Linus Torvalds wrote:
> On Mon, Jun 3, 2019 at 12:53 PM Paul E. McKenney <paulmck@linux.ibm.com> wrote:
> >
> > I agree that !PREEMPT rcu_read_lock() would not affect compiler code
> > generation, but given that get_user() is a volatile asm, isn't the
> > compiler already forbidden from reordering it with the volatile-casted
> > WRITE_ONCE() access, even if there was nothing at all between them?
> > Or are asms an exception to the rule that volatile executions cannot
> > be reordered?
> 
> Paul, you MAKE NO SENSE.
> 
> What is wrong with you?

Mostly that I didn't check all architectures' definitions of get_user().
Had I done so, I would have seen that not all of the corresponding asms
have the "volatile" keyword.  And of course, without that keyword, there
is absolutely nothing preventing the compiler from reordering the asm
with pretty much anything.  The only things that would be absolutely
guaranteed to prevent reordering would be things like memory clobbers
(barrier()) or accesses that overlap the asm's input/output list.

Yeah, I know, even with the "volatile" keyword, it is not entirely clear
how much reordering the compiler is allowed to do.  I was relying on
https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html, which says:

	Qualifiers

	volatile

		The typical use of extended asm statements is to
		manipulate input values to produce output values. However,
		your asm statements may also produce side effects. If so,
		you may need to use the volatile qualifier to disable
		certain optimizations. See Volatile.

But the linked-to "Volatile" section later in that same web page mostly
talks about the compiler's ability to hoist asms out of loops.

> I just showed you an example of where rcu_read_lock() needs to be a
> compiler barrier, and then you make incoherent noises about
> WRITE_ONCE() that do not even exist in that example.

I thought we were discussing this example, but it doesn't matter because
I was missing your point about get_user() and page faults:

     get_user(val, ptr)
     rcu_read_lock();
     WRITE_ONCE(state, 1);

But regardless, given that some architectures omit volatile from their
asms implementing get_user(), even an optimistic interpretation of that
part of the GCC documentation would still permit reordering the above.
And again, I was missing your point about get_user() causing page faults
and thus context switches.

> Forget about your READ_ONCE/WRITE_ONCE theories. Herbert already
> showed code that doesn't have those accessors, so reality doesn't
> match your fevered imagination.

I get the feeling that you believe that I want LKMM to be some sort of
final judge and absolute arbiter of what code is legal and not from
a memory-ordering perspective.  This is absolutely -not- the case.
The current state of the art, despite the recent impressive progress,
simply cannot reasonably do this.  So all I can claim is that LKMM
dispenses advice, hopefully good advice.  (It is early days for LKMM's
handling of plain accesses, so some work might be required to deliver
on the "good advice" promise, but we have to start somewhere.  Plus it
is progressing nicely.)

The places where long-standing RCU patterns require rcu_dereference()
and rcu_assign_pointer() do require some attention to avoid compiler
optimizations, and {READ,WRITE}_ONCE() is one way of addressing this.
But not the only way, nor always the best way.  For example, some
fastpaths might need the optimizations that {READ,WRITE}_ONCE()
suppresses.  Therefore, Linux kernel hackers have a number of other
ways of paying attention.  For example, accesses might be constrained
via barrier() and friends.  For another example, some developers might
check assembly output (hopefully scripted somehow).

Again, the Linux-kernel memory model dispenses advice, not absolutes.
Furthermore, the way it dispenses advice is currently a bit limited.
It can currently say that it is nervous about lack of {READ,WRITE}_ONCE(),
as in "Flag data-race", but it would be difficult to make it recommend
the other options in an intelligent way.  So we should interpret "Flag
data-race" as LKMM saying "I am nervous about your unmarked accesses"
rather than "You absolutely must call {READ,WRITE}_ONCE() more often!!!"
Again, advice, not absolutes.

So the idea is that you add and remove {READ,WRITE}_ONCE() to/from the
-litmus- -tests- to determine which accesses LKMM is nervous about.
But that doesn't necessarily mean that {READ,WRITE}_ONCE() goes into
the corresponding places in the Linux kernel.

Does that help, or am I still confused?

> And sometimes it's not even possible, since you can't do a bitfield
> access, for example, with READ_ONCE().

Ah, good point.  So the Linux kernel uses bitfields to communicate
between mainline and interrupt handlers.  New one on me.  :-/

> > We can of course put them back in,
> 
> Stop the craziness. It's not "we can". It is a "we will".
> 
> So I will add that barrier, and you need to stop arguing against it
> based on specious theoretical arguments that do not match reality. And
> we will not ever remove that barrier again. Herbert already pointed to
> me having to do this once before in commit 386afc91144b ("spinlocks
> and preemption points need to be at least compiler barriers"), and
> rcu_read_lock() clearly has at a minimum that same preemption point
> issue.

And the lack of "volatile" allows get_user() to migrate page faults
(and thus context switches) into RCU read-side critical sections
in CONFIG_PREEMPT=n.  Yes, this would be very bad.

OK, I finally got it, so please accept my apologies for my earlier
confusion.

I don't yet see a commit from you, so I queued the one below locally
and started testing.

							Thanx, Paul

------------------------------------------------------------------------

commit 9b4766c5523efb8d3d52b2ba2a29fd69cdfc65bb
Author: Paul E. McKenney <paulmck@linux.ibm.com>
Date:   Tue Jun 4 14:05:52 2019 -0700

    rcu: Restore barrier() to rcu_read_lock() and rcu_read_unlock()
    
    Commit bb73c52bad36 ("rcu: Don't disable preemption for Tiny and Tree
    RCU readers") removed the barrier() calls from rcu_read_lock() and
    rcu_write_lock() in CONFIG_PREEMPT=n&&CONFIG_PREEMPT_COUNT=n kernels.
    Within RCU, this commit was OK, but it failed to account for things like
    get_user() that can pagefault and that can be reordered by the compiler.
    Lack of the barrier() calls in rcu_read_lock() and rcu_read_unlock()
    can cause these page faults to migrate into RCU read-side critical
    sections, which in CONFIG_PREEMPT=n kernels could result in too-short
    grace periods and arbitrary misbehavior.  Please see commit 386afc91144b
    ("spinlocks and preemption points need to be at least compiler barriers")
    for more details.
    
    This commit therefore restores the barrier() call to both rcu_read_lock()
    and rcu_read_unlock().  It also removes them from places in the RCU update
    machinery that used to need compensatory barrier() calls, effectively
    reverting commit bb73c52bad36 ("rcu: Don't disable preemption for Tiny
    and Tree RCU readers").
    
    Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
    Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 0c9b92799abc..8f7167478c1d 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -56,14 +56,12 @@ void __rcu_read_unlock(void);
 
 static inline void __rcu_read_lock(void)
 {
-	if (IS_ENABLED(CONFIG_PREEMPT_COUNT))
-		preempt_disable();
+	preempt_disable();
 }
 
 static inline void __rcu_read_unlock(void)
 {
-	if (IS_ENABLED(CONFIG_PREEMPT_COUNT))
-		preempt_enable();
+	preempt_enable();
 }
 
 static inline int rcu_preempt_depth(void)
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 3f52d8438e0f..841060fce33c 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -288,7 +288,6 @@ void rcu_note_context_switch(bool preempt)
 	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
 	struct rcu_node *rnp;
 
-	barrier(); /* Avoid RCU read-side critical sections leaking down. */
 	trace_rcu_utilization(TPS("Start context switch"));
 	lockdep_assert_irqs_disabled();
 	WARN_ON_ONCE(!preempt && t->rcu_read_lock_nesting > 0);
@@ -340,7 +339,6 @@ void rcu_note_context_switch(bool preempt)
 	if (rdp->exp_deferred_qs)
 		rcu_report_exp_rdp(rdp);
 	trace_rcu_utilization(TPS("End context switch"));
-	barrier(); /* Avoid RCU read-side critical sections leaking up. */
 }
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
@@ -828,11 +826,6 @@ static void rcu_qs(void)
  * dyntick-idle quiescent state visible to other CPUs, which will in
  * some cases serve for expedited as well as normal grace periods.
  * Either way, register a lightweight quiescent state.
- *
- * The barrier() calls are redundant in the common case when this is
- * called externally, but just in case this is called from within this
- * file.
- *
  */
 void rcu_all_qs(void)
 {
@@ -847,14 +840,12 @@ void rcu_all_qs(void)
 		return;
 	}
 	this_cpu_write(rcu_data.rcu_urgent_qs, false);
-	barrier(); /* Avoid RCU read-side critical sections leaking down. */
 	if (unlikely(raw_cpu_read(rcu_data.rcu_need_heavy_qs))) {
 		local_irq_save(flags);
 		rcu_momentary_dyntick_idle();
 		local_irq_restore(flags);
 	}
 	rcu_qs();
-	barrier(); /* Avoid RCU read-side critical sections leaking up. */
 	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(rcu_all_qs);
@@ -864,7 +855,6 @@ EXPORT_SYMBOL_GPL(rcu_all_qs);
  */
 void rcu_note_context_switch(bool preempt)
 {
-	barrier(); /* Avoid RCU read-side critical sections leaking down. */
 	trace_rcu_utilization(TPS("Start context switch"));
 	rcu_qs();
 	/* Load rcu_urgent_qs before other flags. */
@@ -877,7 +867,6 @@ void rcu_note_context_switch(bool preempt)
 		rcu_tasks_qs(current);
 out:
 	trace_rcu_utilization(TPS("End context switch"));
-	barrier(); /* Avoid RCU read-side critical sections leaking up. */
 }
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 

