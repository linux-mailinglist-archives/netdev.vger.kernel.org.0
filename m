Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C213397A
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 22:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfFCUDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 16:03:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36646 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726741AbfFCUDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 16:03:10 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x53JvUKZ107765
        for <netdev@vger.kernel.org>; Mon, 3 Jun 2019 16:03:08 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2swa1w0g2c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 16:03:08 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Mon, 3 Jun 2019 21:03:07 +0100
Received: from b01cxnp23032.gho.pok.ibm.com (9.57.198.27)
        by e12.ny.us.ibm.com (146.89.104.199) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 3 Jun 2019 21:03:03 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x53K32hT35783002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 20:03:02 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C72E1B206A;
        Mon,  3 Jun 2019 20:03:02 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72CF6B2065;
        Mon,  3 Jun 2019 20:03:02 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.210.156])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jun 2019 20:03:02 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id DF1A016C5DA0; Mon,  3 Jun 2019 13:03:01 -0700 (PDT)
Date:   Mon, 3 Jun 2019 13:03:01 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, stern@rowland.harvard.edu
Subject: Re: rcu_read_lock lost its compiler barrier
Reply-To: paulmck@linux.ibm.com
References: <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <CAHk-=whLGKOmM++OQi5GX08_dfh8Xfz9Wq7khPo+MVtPYh_8hw@mail.gmail.com>
 <20190603024640.2soysu4rpkwjuash@gondor.apana.org.au>
 <20190603034707.GG28207@linux.ibm.com>
 <20190603052626.nz2qktwmkswxfnsd@gondor.apana.org.au>
 <20190603064200.GA11024@tardis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603064200.GA11024@tardis>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19060320-0060-0000-0000-0000034B914A
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011209; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01212780; UDB=6.00637369; IPR=6.00993840;
 MB=3.00027168; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-03 20:03:07
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060320-0061-0000-0000-0000499BB539
Message-Id: <20190603200301.GM28207@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030133
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 02:42:00PM +0800, Boqun Feng wrote:
> On Mon, Jun 03, 2019 at 01:26:26PM +0800, Herbert Xu wrote:
> > On Sun, Jun 02, 2019 at 08:47:07PM -0700, Paul E. McKenney wrote:
> > > 
> > > 1.	These guarantees are of full memory barriers, -not- compiler
> > > 	barriers.
> > 
> > What I'm saying is that wherever they are, they must come with
> > compiler barriers.  I'm not aware of any synchronisation mechanism
> > in the kernel that gives a memory barrier without a compiler barrier.
> > 
> > > 2.	These rules don't say exactly where these full memory barriers
> > > 	go.  SRCU is at one extreme, placing those full barriers in
> > > 	srcu_read_lock() and srcu_read_unlock(), and !PREEMPT Tree RCU
> > > 	at the other, placing these barriers entirely within the callback
> > > 	queueing/invocation, grace-period computation, and the scheduler.
> > > 	Preemptible Tree RCU is in the middle, with rcu_read_unlock()
> > > 	sometimes including a full memory barrier, but other times with
> > > 	the full memory barrier being confined as it is with !PREEMPT
> > > 	Tree RCU.
> > 
> > The rules do say that the (full) memory barrier must precede any
> > RCU read-side that occur after the synchronize_rcu and after the
> > end of any RCU read-side that occur before the synchronize_rcu.
> > 
> > All I'm arguing is that wherever that full mb is, as long as it
> > also carries with it a barrier() (which it must do if it's done
> > using an existing kernel mb/locking primitive), then we're fine.
> > 
> > > Interleaving and inserting full memory barriers as per the rules above:
> > > 
> > > 	CPU1: WRITE_ONCE(a, 1)
> > > 	CPU1: synchronize_rcu	
> > > 	/* Could put a full memory barrier here, but it wouldn't help. */
> > 
> > 	CPU1: smp_mb();
> > 	CPU2: smp_mb();
> > 
> > Let's put them in because I think they are critical.  smp_mb() also
> > carries with it a barrier().
> > 
> > > 	CPU2: rcu_read_lock();
> > > 	CPU1: b = 2;	
> > > 	CPU2: if (READ_ONCE(a) == 0)
> > > 	CPU2:         if (b != 1)  /* Weakly ordered CPU moved this up! */
> > > 	CPU2:                 b = 1;
> > > 	CPU2: rcu_read_unlock
> > > 
> > > In fact, CPU2's load from b might be moved up to race with CPU1's store,
> > > which (I believe) is why the model complains in this case.
> > 
> > Let's put aside my doubt over how we're even allowing a compiler
> > to turn
> > 
> > 	b = 1
> > 
> > into
> > 
> > 	if (b != 1)
> > 		b = 1
> > 
> > Since you seem to be assuming that (a == 0) is true in this case
> 
> I think Paul's example assuming (a == 0) is false, and maybe

Yes, otherwise, P0()'s write to "b" cannot have happened.

> speculative writes (by compilers) needs to added into consideration?

I would instead call it the compiler eliminating needless writes
by inventing reads -- if the variable already has the correct value,
no write happens.  So no compiler speculation.

However, it is difficult to create a solid defensible example.  Yes,
from LKMM's viewpoint, the weakly reordered invented read from "b"
can be concurrent with P0()'s write to "b", but in that case the value
loaded would have to manage to be equal to 1 for anything bad to happen.
This does feel wrong to me, but again, it is difficult to create a solid
defensible example.

> Please consider the following case (I add a few smp_mb()s), the case may
> be a little bit crasy, you have been warned ;-)
> 
>  	CPU1: WRITE_ONCE(a, 1)
>  	CPU1: synchronize_rcu called
> 
>  	CPU1: smp_mb(); /* let assume there is one here */
> 
>  	CPU2: rcu_read_lock();
>  	CPU2: smp_mb(); /* let assume there is one here */
> 
> 	/* "if (b != 1) b = 1" reordered  */
>  	CPU2: r0 = b;       /* if (b != 1) reordered here, r0 == 0 */
>  	CPU2: if (r0 != 1)  /* true */
> 	CPU2:     b = 1;    /* b == 1 now, this is a speculative write
> 	                       by compiler
> 			     */
> 
> 	CPU1: b = 2;        /* b == 2 */
> 
>  	CPU2: if (READ_ONCE(a) == 0) /* false */
> 	CPU2: ...
> 	CPU2  else                   /* undo the speculative write */
> 	CPU2:	  b = r0;   /* b == 0 */
> 
>  	CPU2: smp_mb();
> 	CPU2: read_read_unlock();
> 
> I know this is too crasy for us to think a compiler like this, but this
> might be the reason why the model complain about this.
> 
> Paul, did I get this right? Or you mean something else?

Mostly there, except that I am not yet desperate enough to appeal to
compilers speculating stores.  ;-)

							Thanx, Paul

> Regards,
> Boqun
> 
> 
> 
> > (as the assignment b = 1 is carried out), then because of the
> > presence of the full memory barrier, the RCU read-side section
> > must have started prior to the synchronize_rcu.  This means that
> > synchronize_rcu is not allowed to return until at least the end
> > of the grace period, or at least until the end of rcu_read_unlock.
> > 
> > So it actually should be:
> > 
> > 	CPU1: WRITE_ONCE(a, 1)
> > 	CPU1: synchronize_rcu called
> > 	/* Could put a full memory barrier here, but it wouldn't help. */
> > 
> > 	CPU1: smp_mb();
> > 	CPU2: smp_mb();
> > 
> > 	CPU2: grace period starts
> > 	...time passes...
> > 	CPU2: rcu_read_lock();
> > 	CPU2: if (READ_ONCE(a) == 0)
> > 	CPU2:         if (b != 1)  /* Weakly ordered CPU moved this up! */
> > 	CPU2:                 b = 1;
> > 	CPU2: rcu_read_unlock
> > 	...time passes...
> > 	CPU2: grace period ends
> > 
> > 	/* This full memory barrier is also guaranteed by RCU. */
> > 	CPU2: smp_mb();
> > 
> > 	CPU1 synchronize_rcu returns
> > 	CPU1: b = 2;	
> > 
> > Cheers,
> > -- 
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


