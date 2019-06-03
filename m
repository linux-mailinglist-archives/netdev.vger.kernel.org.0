Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E982532CF6
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 11:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfFCJfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 05:35:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35028 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727334AbfFCJfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 05:35:39 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x539WtVk028296;
        Mon, 3 Jun 2019 05:35:32 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sw0ytg7pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jun 2019 05:35:32 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x539X0tZ029210;
        Mon, 3 Jun 2019 05:35:32 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sw0ytg7nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jun 2019 05:35:32 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x533XSKN001411;
        Mon, 3 Jun 2019 03:40:32 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 2suh08xmts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jun 2019 03:40:32 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x539ZTIa26017906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 09:35:29 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97067B2064;
        Mon,  3 Jun 2019 09:35:29 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 356E5B2071;
        Mon,  3 Jun 2019 09:35:29 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.160.165])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jun 2019 09:35:29 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id A392716C5D9E; Mon,  3 Jun 2019 02:35:28 -0700 (PDT)
Date:   Mon, 3 Jun 2019 02:35:28 -0700
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
Message-ID: <20190603093528.GJ28207@linux.ibm.com>
Reply-To: paulmck@linux.ibm.com
References: <20150910102513.GA1677@fixme-laptop.cn.ibm.com>
 <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <CAHk-=whLGKOmM++OQi5GX08_dfh8Xfz9Wq7khPo+MVtPYh_8hw@mail.gmail.com>
 <20190603024640.2soysu4rpkwjuash@gondor.apana.org.au>
 <20190603034707.GG28207@linux.ibm.com>
 <20190603052626.nz2qktwmkswxfnsd@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603052626.nz2qktwmkswxfnsd@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030070
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 01:26:26PM +0800, Herbert Xu wrote:
> On Sun, Jun 02, 2019 at 08:47:07PM -0700, Paul E. McKenney wrote:
> > 
> > 1.	These guarantees are of full memory barriers, -not- compiler
> > 	barriers.
> 
> What I'm saying is that wherever they are, they must come with
> compiler barriers.  I'm not aware of any synchronisation mechanism
> in the kernel that gives a memory barrier without a compiler barrier.

Yes, if a given synchronization mechanism requires that memory references
need to be ordered, both the compiler and the CPU must maintain that
ordering.

> > 2.	These rules don't say exactly where these full memory barriers
> > 	go.  SRCU is at one extreme, placing those full barriers in
> > 	srcu_read_lock() and srcu_read_unlock(), and !PREEMPT Tree RCU
> > 	at the other, placing these barriers entirely within the callback
> > 	queueing/invocation, grace-period computation, and the scheduler.
> > 	Preemptible Tree RCU is in the middle, with rcu_read_unlock()
> > 	sometimes including a full memory barrier, but other times with
> > 	the full memory barrier being confined as it is with !PREEMPT
> > 	Tree RCU.
> 
> The rules do say that the (full) memory barrier must precede any
> RCU read-side that occur after the synchronize_rcu and after the
> end of any RCU read-side that occur before the synchronize_rcu.
> 
> All I'm arguing is that wherever that full mb is, as long as it
> also carries with it a barrier() (which it must do if it's done
> using an existing kernel mb/locking primitive), then we're fine.

Fair enough, and smp_mb() does provide what is needed.

> > Interleaving and inserting full memory barriers as per the rules above:
> > 
> > 	CPU1: WRITE_ONCE(a, 1)
> > 	CPU1: synchronize_rcu	
> > 	/* Could put a full memory barrier here, but it wouldn't help. */
> 
> 	CPU1: smp_mb();
> 	CPU2: smp_mb();

What is CPU2's smp_mb() ordering?  In other words, what comment would
you put on each of the above smp_mb() calls?

> Let's put them in because I think they are critical.  smp_mb() also
> carries with it a barrier().

Again, agreed, smp_mb() implies barrier().

> > 	CPU2: rcu_read_lock();
> > 	CPU1: b = 2;	
> > 	CPU2: if (READ_ONCE(a) == 0)
> > 	CPU2:         if (b != 1)  /* Weakly ordered CPU moved this up! */
> > 	CPU2:                 b = 1;
> > 	CPU2: rcu_read_unlock
> > 
> > In fact, CPU2's load from b might be moved up to race with CPU1's store,
> > which (I believe) is why the model complains in this case.
> 
> Let's put aside my doubt over how we're even allowing a compiler
> to turn
> 
> 	b = 1
> 
> into
> 
> 	if (b != 1)
> 		b = 1
> 
> Since you seem to be assuming that (a == 0) is true in this case
> (as the assignment b = 1 is carried out), then because of the
> presence of the full memory barrier, the RCU read-side section
> must have started prior to the synchronize_rcu.  This means that
> synchronize_rcu is not allowed to return until at least the end
> of the grace period, or at least until the end of rcu_read_unlock.
> 
> So it actually should be:
> 
> 	CPU1: WRITE_ONCE(a, 1)
> 	CPU1: synchronize_rcu called
> 	/* Could put a full memory barrier here, but it wouldn't help. */
> 
> 	CPU1: smp_mb();
> 	CPU2: smp_mb();
> 
> 	CPU2: grace period starts
> 	...time passes...
> 	CPU2: rcu_read_lock();
> 	CPU2: if (READ_ONCE(a) == 0)
> 	CPU2:         if (b != 1)  /* Weakly ordered CPU moved this up! */
> 	CPU2:                 b = 1;
> 	CPU2: rcu_read_unlock
> 	...time passes...
> 	CPU2: grace period ends
> 
> 	/* This full memory barrier is also guaranteed by RCU. */
> 	CPU2: smp_mb();

But in this case, given that there are no more statements for CPU2,
what is this smp_mb() ordering?

							Thanx, Paul

> 	CPU1 synchronize_rcu returns
> 	CPU1: b = 2;	
> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
