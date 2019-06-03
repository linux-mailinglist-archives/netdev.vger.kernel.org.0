Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37DCF32CDB
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 11:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbfFCJ1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 05:27:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47644 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727615AbfFCJ1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 05:27:52 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x539NGJl070509
        for <netdev@vger.kernel.org>; Mon, 3 Jun 2019 05:27:51 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sw0ejs9q3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 05:27:51 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Mon, 3 Jun 2019 10:27:50 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e12.ny.us.ibm.com (146.89.104.199) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 3 Jun 2019 10:27:46 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x539Rim636962760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 09:27:45 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1CEFB205F;
        Mon,  3 Jun 2019 09:27:44 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 811A8B2065;
        Mon,  3 Jun 2019 09:27:44 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.160.165])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jun 2019 09:27:44 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id BCA5916C5D8E; Mon,  3 Jun 2019 02:27:43 -0700 (PDT)
Date:   Mon, 3 Jun 2019 02:27:43 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Frederic Weisbecker <fweisbec@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: rcu_read_lock lost its compiler barrier
Reply-To: paulmck@linux.ibm.com
References: <20150910005708.GA23369@wfg-t540p.sh.intel.com>
 <20150910102513.GA1677@fixme-laptop.cn.ibm.com>
 <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <20190603000617.GD28207@linux.ibm.com>
 <20190603030324.kl3bckqmebzis2vw@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603030324.kl3bckqmebzis2vw@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19060309-0060-0000-0000-0000034B5C36
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011207; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01212568; UDB=6.00637242; IPR=6.00993628;
 MB=3.00027161; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-03 09:27:48
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060309-0061-0000-0000-00004999EF8C
Message-Id: <20190603092743.GI28207@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030069
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 11:03:24AM +0800, Herbert Xu wrote:
> On Sun, Jun 02, 2019 at 05:06:17PM -0700, Paul E. McKenney wrote:
> >
> > Please note that preemptible Tree RCU has lacked the compiler barrier on
> > all but the outermost rcu_read_unlock() for years before Boqun's patch.
> 
> Actually this is not true.  Boqun's patch (commit bb73c52bad36) does
> not add a barrier() to __rcu_read_lock.  In fact I dug into the git
> history and this compiler barrier() has existed in preemptible tree
> RCU since the very start in 2009:

I said rcu_read_unlock() and you said __rcu_read_lock().

> : commit f41d911f8c49a5d65c86504c19e8204bb605c4fd
> : Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> : Date:   Sat Aug 22 13:56:52 2009 -0700
> :
> :     rcu: Merge preemptable-RCU functionality into hierarchical RCU
> :
> : +/*
> : + * Tree-preemptable RCU implementation for rcu_read_lock().
> : + * Just increment ->rcu_read_lock_nesting, shared state will be updated
> : + * if we block.
> : + */
> : +void __rcu_read_lock(void)
> : +{
> : +       ACCESS_ONCE(current->rcu_read_lock_nesting)++;
> : +       barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
> : +}
> : +EXPORT_SYMBOL_GPL(__rcu_read_lock);

Thank you for finding this!  This particular version does have an
unconditional barrier() in __rcu_read_unlock(), for whatever that
is worth:

+void __rcu_read_unlock(void)
+{
+       struct task_struct *t = current;
+
+       barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
+       if (--ACCESS_ONCE(t->rcu_read_lock_nesting) == 0 &&
+           unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
+               rcu_read_unlock_special(t);
+}

I would not have seen the point of a compiler barrier in the non-outermost
__rcu_read_unlock(), since the completion of an inner __rcu_read_unlock()
does not permit the grace period to complete.

> However, you are correct that in the non-preempt tree RCU case,
> the compiler barrier in __rcu_read_lock was not always present.
> In fact it was added by:
> 
> : commit 386afc91144b36b42117b0092893f15bc8798a80
> : Author: Linus Torvalds <torvalds@linux-foundation.org>
> : Date:   Tue Apr 9 10:48:33 2013 -0700
> :
> :     spinlocks and preemption points need to be at least compiler barriers
> 
> I suspect this is what prompted you to remove it in 2015.

If I remember correctly, it was pointed out to me that in !PREEMPT kernels,
the compiler barrier in the preempt_disable() invoked in rcu_read_lock()
(and similar on the rcu_read_unlock() side) wasn't helping anything,

> > I do not believe that reverting that patch will help you at all.
> > 
> > But who knows?  So please point me at the full code body that was being
> > debated earlier on this thread.  It will no doubt take me quite a while to
> > dig through it, given my being on the road for the next couple of weeks,
> > but so it goes.
> 
> Please refer to my response to Linus for the code in question.
> 
> In any case, I am now even more certain that compiler barriers are
> not needed in the code in question.  The reasoning is quite simple.
> If you need those compiler barriers then you surely need real memory
> barriers.

OK, we are in agreement on that point, then!

> Vice versa, if real memory barriers are already present thanks to
> RCU, then you don't need those compiler barriers.

For users of RCU, this seems reasonable.

On the other hand, the compiler barriers in PREEMPT Tree RCU's outermost
__rcu_read_lock() and __rcu_read_unlock() invocations really are needed
by RCU internals.  This is because RCU uses of interrupt handlers that
access per-task and per-CPU variables, and these need to be able to
sense the edges of the nested set of RCU read-side critical sections.
It is OK for these interrupt handlers to think that the critical section
is larger than it really is, but fatal for them to think that the critical
sections are smaller than they really are.

> In fact this calls into question the use of READ_ONCE/WRITE_ONCE in
> RCU primitives such as rcu_dereference and rcu_assign_pointer.

No, these are -not- called into question, or if they are, the question
gets quickly answered it a way that supports current Linux-kernel code.
As mentioned in earlier emails, the traditional uses of RCU that involve
rcu_dereference(), rcu_assign_pointer(), and synchronize_rcu() all work
just fine.

In fact, from what I can see, the issue stems from having developed
intuitions from working with the traditional rcu_dereference(),
rcu_assign_pointer(), and synchronize_rcu() linked-structure use cases,
and then attempting to apply these intuition to use cases that have
neither rcu_dereference() nor rcu_assign_pointer().  Don't get me wrong,
it is only natural to try to extend your intuitions to something that
admittedly looks pretty similar to the traditional use cases.  But this
is one of those cases where "pretty similar" might not be good enough.

>                                                                 IIRC
> when RCU was first added to the Linux kernel we did not have compiler
> barriers in rcu_dereference and rcu_assign_pointer.  They were added
> later on.

From what I can see, rcu_dereference() still does not have a compiler
barrier.  Please note that the pair of barrier() calls in READ_ONCE()
only apply when READ_ONCE()ing something larger than the machine can load.
And if your platform cannot load and store pointers with a single access,
the Linux kernel isn't going to do very well regardless.  Ditto for
WRITE_ONCE().

> As compiler barriers per se are useless, these are surely meant to
> be coupled with the memory barriers provided by RCU grace periods
> and synchronize_rcu.  But then those real memory barriers would have
> compiler barriers too.  So why do we need the compiler barriers in
> rcu_dereference and rcu_assign_pointer?

In rcu_dereference(), RCU does not need them.  They are instead
inherited from READ_ONCE() for when it is used on a data structure too
big for any single load instruction available on the system in question.
These barrier() calls are in a case that rcu_dereference() had better
not be using -- after all, using them would mean that the hardware didn't
have a load instruction big enough to handle a pointer.

In rcu_assign_pointer(), RCU just needs this to act like a release
store, that is, the store itself must not be reordered with any earlier
memory accesses.  The Linux kernel's smp_store_release() currently
over-approximates this using a barrier() or equivalent inline-assembly
directive, which enforces compiler ordering for not only the release
store, but also far all memory accesses following the release store.
Obviously, barrier is not enough for weakly ordered systems, which
must also emit an appropriate memory-barrier instruction (or a special
load instruction for architectures like ARMv8 providing such a thing).

The compiler barriers in __rcu_read_lock() and __rcu_read_unlock() are
there so that preemptible Tree RCU can use its various tricks to make
readers perform and scale well.  Read-side state is confined to the CPU
and/or task in the common case, thus avoiding heavy synchronization
overhead in the common case (or, in the case of !PREEMPT RCU, thus
avoiding -any- synchronization overhead in the common case).  For example,
the compiler barriers ensure that RCU's scheduler-clock code and softirq
code can trust per-CPU/task state indicating whether or not there is an
RCU read-side critical section in effect.

Does that help?  Or am I missing your point?

							Thanx, Paul

