Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C63832708
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 05:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfFCDsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 23:48:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43844 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726606AbfFCDsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 23:48:30 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x533kkxE107904
        for <netdev@vger.kernel.org>; Sun, 2 Jun 2019 23:48:28 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2svqrhybwp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 23:48:28 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Mon, 3 Jun 2019 04:48:27 +0100
Received: from b01cxnp22036.gho.pok.ibm.com (9.57.198.26)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 3 Jun 2019 04:48:24 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x533l8wm33882592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 03:47:08 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EE95B205F;
        Mon,  3 Jun 2019 03:47:08 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C301B2064;
        Mon,  3 Jun 2019 03:47:08 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.80.207.252])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jun 2019 03:47:07 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 9571A16C3B7A; Sun,  2 Jun 2019 20:47:07 -0700 (PDT)
Date:   Sun, 2 Jun 2019 20:47:07 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: rcu_read_lock lost its compiler barrier
Reply-To: paulmck@linux.ibm.com
References: <20150910005708.GA23369@wfg-t540p.sh.intel.com>
 <20150910102513.GA1677@fixme-laptop.cn.ibm.com>
 <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <CAHk-=whLGKOmM++OQi5GX08_dfh8Xfz9Wq7khPo+MVtPYh_8hw@mail.gmail.com>
 <20190603024640.2soysu4rpkwjuash@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603024640.2soysu4rpkwjuash@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19060303-2213-0000-0000-000003994407
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011206; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01212457; UDB=6.00637174; IPR=6.00993516;
 MB=3.00027159; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-03 03:48:26
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060303-2214-0000-0000-00005EAE1DB9
Message-Id: <20190603034707.GG28207@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030026
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 10:46:40AM +0800, Herbert Xu wrote:
> On Sun, Jun 02, 2019 at 01:54:12PM -0700, Linus Torvalds wrote:
> > On Sat, Jun 1, 2019 at 10:56 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >
> > > You can't then go and decide to remove the compiler barrier!  To do
> > > that you'd need to audit every single use of rcu_read_lock in the
> > > kernel to ensure that they're not depending on the compiler barrier.
> > 
> > What's the possible case where it would matter when there is no preemption?
> 
> The case we were discussing is from net/ipv4/inet_fragment.c from
> the net-next tree:
> 
> void fqdir_exit(struct fqdir *fqdir)
> {
> 	...
> 	fqdir->dead = true;
> 
> 	/* call_rcu is supposed to provide memory barrier semantics,
> 	 * separating the setting of fqdir->dead with the destruction
> 	 * work.  This implicit barrier is paired with inet_frag_kill().
> 	 */
> 
> 	INIT_RCU_WORK(&fqdir->destroy_rwork, fqdir_rwork_fn);
> 	queue_rcu_work(system_wq, &fqdir->destroy_rwork);
> }
> 
> and
> 
> void inet_frag_kill(struct inet_frag_queue *fq)
> {
> 		...
> 		rcu_read_lock();
> 		/* The RCU read lock provides a memory barrier
> 		 * guaranteeing that if fqdir->dead is false then
> 		 * the hash table destruction will not start until
> 		 * after we unlock.  Paired with inet_frags_exit_net().
> 		 */
> 		if (!fqdir->dead) {
> 			rhashtable_remove_fast(&fqdir->rhashtable, &fq->node,
> 					       fqdir->f->rhash_params);
> 			...
> 		}
> 		...
> 		rcu_read_unlock();
> 		...
> }
> 
> I simplified this to
> 
> Initial values:
> 
> a = 0
> b = 0
> 
> CPU1				CPU2
> ----				----
> a = 1				rcu_read_lock
> synchronize_rcu			if (a == 0)
> b = 2					b = 1
> 				rcu_read_unlock
> 
> On exit we want this to be true:
> b == 2
> 
> Now what Paul was telling me is that unless every memory operation
> is done with READ_ONCE/WRITE_ONCE then his memory model shows that
> the exit constraint won't hold.

But please note that the plain-variable portion of the memory model is
very new and likely still has a bug or two.  In fact, see below.

>                                  IOW, we need
> 
> CPU1				CPU2
> ----				----
> WRITE_ONCE(a, 1)		rcu_read_lock
> synchronize_rcu			if (READ_ONCE(a) == 0)
> WRITE_ONCE(b, 2)			WRITE_ONCE(b, 1)
> 				rcu_read_unlock
> 
> Now I think this bullshit because if we really needed these compiler
> barriers then we surely would need real memory barriers to go with
> them.

On the one hand, you have no code before your rcu_read_lock() and also
1no code after your rcu_read_unlock().  So in this particular example,
adding compiler barriers to these guys won't help you.

On the other hand, on CPU 1's write to "b", I agree with you and disagree
with the model, though perhaps my partners in LKMM crime will show me the
error of my ways on this point.  On CPU 2's write to "b", I can see the
memory model's point, but getting there requires some gymnastics on the
part of both the compiler and the CPU.  The WRITE_ONCE() and READ_ONCE()
for "a" is the normal requirement for variables that are concurrently
loaded and stored.

Please note that garden-variety uses of RCU have similar requirements,
namely the rcu_assign_pointer() on the one side and the rcu_dereference()
on the other.  Your use case allows rcu_assign_pointer() to be weakened
to WRITE_ONCE() and rcu_dereference() to be weakened to READ_ONCE()
(not that this last is all that much of a weakening these days).

> In fact, the sole purpose of the RCU mechanism is to provide those
> memory barriers.  Quoting from
> Documentation/RCU/Design/Requirements/Requirements.html:
> 
> <li>	Each CPU that has an RCU read-side critical section that
> 	begins before <tt>synchronize_rcu()</tt> starts is
> 	guaranteed to execute a full memory barrier between the time
> 	that the RCU read-side critical section ends and the time that
> 	<tt>synchronize_rcu()</tt> returns.
> 	Without this guarantee, a pre-existing RCU read-side critical section
> 	might hold a reference to the newly removed <tt>struct foo</tt>
> 	after the <tt>kfree()</tt> on line&nbsp;14 of
> 	<tt>remove_gp_synchronous()</tt>.
> <li>	Each CPU that has an RCU read-side critical section that ends
> 	after <tt>synchronize_rcu()</tt> returns is guaranteed
> 	to execute a full memory barrier between the time that
> 	<tt>synchronize_rcu()</tt> begins and the time that the RCU
> 	read-side critical section begins.
> 	Without this guarantee, a later RCU read-side critical section
> 	running after the <tt>kfree()</tt> on line&nbsp;14 of
> 	<tt>remove_gp_synchronous()</tt> might
> 	later run <tt>do_something_gp()</tt> and find the
> 	newly deleted <tt>struct foo</tt>.

Ahem.

1.	These guarantees are of full memory barriers, -not- compiler
	barriers.

2.	These rules don't say exactly where these full memory barriers
	go.  SRCU is at one extreme, placing those full barriers in
	srcu_read_lock() and srcu_read_unlock(), and !PREEMPT Tree RCU
	at the other, placing these barriers entirely within the callback
	queueing/invocation, grace-period computation, and the scheduler.
	Preemptible Tree RCU is in the middle, with rcu_read_unlock()
	sometimes including a full memory barrier, but other times with
	the full memory barrier being confined as it is with !PREEMPT
	Tree RCU.

So let's place those memory barriers in your example, interleaving:

	CPU2: rcu_read_lock();
	CPU1: WRITE_ONCE(a, 1) | CPU2: if (READ_ONCE(a) == 0)
	                         CPU2:         WRITE_ONCE(b, 1)
	CPU2: rcu_read_unlock
	/* Could put a full memory barrier here, but it wouldn't help. */
	CPU1: synchronize_rcu	
	CPU1: b = 2;	

Here the accesses to "a" are concurrent, and there are legal placements
for the required full memory barrier that don't change that.  In fact,
I cannot see how any memory-barrier placement can help here.  So the
WRITE_ONCE() and READ_ONCE() should be used for "a".  And again, in
garden-variety RCU use cases, these would be rcu_assign_pointer() and
rcu_dereference(), respectively.  So again, I advise using READ_ONCE()
and WRITE_ONCE() for the accesses to "a", for documentation purposes,
even ignoring the future proofing.

Now let's do the (admittedly quite crazy, at least here in 2019)
profiling-directed transformation of the "b = 1" on a weakly ordered
system:

	CPU1: WRITE_ONCE(a, 1)
	CPU1: synchronize_rcu	
	CPU1: b = 2;	

	CPU2: rcu_read_lock();
	CPU2: if (READ_ONCE(a) == 0)
	CPU2:         if (b != 1)
	CPU2:                 b = 1;
	CPU2: rcu_read_unlock

Interleaving and inserting full memory barriers as per the rules above:

	CPU1: WRITE_ONCE(a, 1)
	CPU1: synchronize_rcu	
	/* Could put a full memory barrier here, but it wouldn't help. */

	CPU2: rcu_read_lock();
	CPU1: b = 2;	
	CPU2: if (READ_ONCE(a) == 0)
	CPU2:         if (b != 1)  /* Weakly ordered CPU moved this up! */
	CPU2:                 b = 1;
	CPU2: rcu_read_unlock

In fact, CPU2's load from b might be moved up to race with CPU1's store,
which (I believe) is why the model complains in this case.

I still cannot imagine why CPU1's "b = 2" needs to be WRITE_ONCE(),
perhaps due to a failure of imagination on my part.

> My review of the RCU code shows that these memory barriers are
> indeed present (at least when we're not in tiny mode where all
> this discussion would be moot anyway).  For example, in call_rcu
> we eventually get down to rcu_segcblist_enqueue which has an smp_mb.
> On the reader side (correct me if I'm wrong Paul) the memory
> barrier is implicitly coming from the scheduler.
> 
> My point is that within our kernel whenever we have a CPU memory
> barrier we always have a compiler barrier too.  Therefore my code
> example above does not need any extra compiler barriers such as
> the ones provided by READ_ONCE/WRITE_ONCE.

For the garden-variety RCU use cases, this is true.  Instead, they
require things that are as strong or stronger than READ_ONCE/WRITE_ONCE.

For example:

	CPU 0:
	p = kzalloc(sizeof(*p), GFP_KERNEL);
	BUG_ON(!p);
	p->a = 42;
	r1 = p->b;
	rcu_assign_pointer(gp, p);

	CPU 1:
	rcu_read_lock()
	q = rcu_dereference(gp);
	r2 = p->a;
	p->b = 202;
	rcu_read_unlock()

In this case, the plain C-language loads and stores cannot possibly
execute concurrently, and the model agrees with this.  Again, we didn't
use WRITE_ONCE() and READ_ONCE() -- we instead used rcu_assign_pointer()
and rcu_dereference().

Similar examples involving (say) list_del_rcu() and synchronize_rcu()
are also safe for plain C-language loads and stores.  Plain C-language
accesses by readers to the item being deleted cannot race with plain
C-language accesses after the synchronize_rcu() returns.  But here we
are using list_del_rcu() in the update-side code along with the
synchronize_rcu() and the readers are again using rcu_dereference().

> I think perhaps Paul was perhaps thinking that I'm expecting
> rcu_read_lock/rcu_read_unlock themselves to provide the memory
> or compiler barriers.  That would indeed be wrong but this is
> not what I need.  All I need is the RCU semantics as documented
> for there to be memory and compiler barriers around the whole
> grace period.

Whew!!!  That was -exactly- what I was thinking, and I am glad that
you are not advocating rcu_read_lock() and rcu_read_unlock() supplying
those barriers.  ;-)

And again, it is early days for plain accesses for the Linux-kernel
memory model.  I am confident that READ_ONCE() and WRITE_ONCE for
"a" is a very good thing to do, but less confident for "b", most
especially for CPU1's store to "b".

Either way, your example is an excellent test case for the plain
C-language access capability of the Linux-kernel memory model, so thank
you for that!

							Thanx, Paul

