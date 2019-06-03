Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 197443394E
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 21:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfFCTxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 15:53:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41808 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725876AbfFCTxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 15:53:15 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x53JXWK4130208;
        Mon, 3 Jun 2019 15:53:07 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sw7b0qj17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jun 2019 15:53:07 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x53JZYgX136731;
        Mon, 3 Jun 2019 15:53:07 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sw7b0qj0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jun 2019 15:53:06 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x53DslET009499;
        Mon, 3 Jun 2019 13:58:08 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 2suh092g59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jun 2019 13:58:07 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x53Jr5cc43057474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 19:53:05 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12A62B2064;
        Mon,  3 Jun 2019 19:53:05 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B353AB205F;
        Mon,  3 Jun 2019 19:53:04 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.210.156])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jun 2019 19:53:04 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 2653716C5DA0; Mon,  3 Jun 2019 12:53:04 -0700 (PDT)
Date:   Mon, 3 Jun 2019 12:53:04 -0700
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
Message-ID: <20190603195304.GK28207@linux.ibm.com>
Reply-To: paulmck@linux.ibm.com
References: <20150910102513.GA1677@fixme-laptop.cn.ibm.com>
 <20150910171649.GE4029@linux.vnet.ibm.com>
 <20150911021933.GA1521@fixme-laptop.cn.ibm.com>
 <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <20190603000617.GD28207@linux.ibm.com>
 <20190603030324.kl3bckqmebzis2vw@gondor.apana.org.au>
 <CAHk-=wj2t+GK+DGQ7Xy6U7zMf72e7Jkxn4_-kGyfH3WFEoH+YQ@mail.gmail.com>
 <CAHk-=wgZcrb_vQi5rwpv+=wwG+68SRDY16HcqcMtgPFL_kdfyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgZcrb_vQi5rwpv+=wwG+68SRDY16HcqcMtgPFL_kdfyQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030132
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 09:07:29AM -0700, Linus Torvalds wrote:
> On Mon, Jun 3, 2019 at 8:55 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I don't believe that it would necessarily help to turn a
> > rcu_read_lock() into a compiler barrier, because for the non-preempt
> > case rcu_read_lock() doesn't need to actually _do_ anything, and
> > anything that matters for the RCU read lock will already be a compiler
> > barrier for other reasons (ie a function call that can schedule).
> 
> Actually, thinking a bit more about this, and trying to come up with
> special cases, I'm not at all convinced.
> 
> Even if we don't have preemption enabled, it turns out that we *do*
> have things that can cause scheduling without being compiler barriers.
> 
> In particular, user accesses are not necessarily full compiler
> barriers. One common pattern (x86) is
> 
>         asm volatile("call __get_user_%P4"
> 
> which explicitly has a "asm volaile" so that it doesn't re-order wrt
> other asms (and thus other user accesses), but it does *not* have a
> "memory" clobber, because the user access doesn't actually change
> kernel memory. Not even if it's a "put_user()".
> 
> So we've made those fairly relaxed on purpose. And they might be
> relaxed enough that they'd allow re-ordering wrt something that does a
> rcu read lock, unless the rcu read lock has some compiler barrier in
> it.
> 
> IOW, imagine completely made up code like
> 
>      get_user(val, ptr)
>      rcu_read_lock();
>      WRITE_ONCE(state, 1);
> 
> and unless the rcu lock has a barrier in it, I actually think that
> write to 'state' could migrate to *before* the get_user().
> 
> I'm not convinced we have anything that remotely looks like the above,
> but I'm actually starting to think that yes, all RCU barriers had
> better be compiler barriers.
> 
> Because this is very much an example of something where you don't
> necessarily need a memory barrier, but there's a code generation
> barrier needed because of local ordering requirements. The possible
> faulting behavior of "get_user()" must not migrate into the RCU
> critical region.
> 
> Paul?

I agree that !PREEMPT rcu_read_lock() would not affect compiler code
generation, but given that get_user() is a volatile asm, isn't the
compiler already forbidden from reordering it with the volatile-casted
WRITE_ONCE() access, even if there was nothing at all between them?
Or are asms an exception to the rule that volatile executions cannot
be reordered?

> So I think the rule really should be: every single form of locking
> that has any semantic meaning at all, absolutely needs to be at least
> a compiler barrier.
> 
> (That "any semantic meaning" weaselwording is because I suspect that
> we have locking that truly and intentionally becomes no-ops because
> it's based on things that aren't relevant in some configurations. But
> generally compiler barriers are really pretty damn cheap, even from a
> code generation standpoint, and can help make the resulting code more
> legible, so I think we should not try to aggressively remove them
> without _very_ good reasons)

We can of course put them back in, but this won't help in the typical
rcu_assign_pointer(), rcu_dereference(), and synchronize_rcu() situation
(nor do I see how it helps in Hubert's example).  And in other RCU
use cases, the accesses analogous to the rcu_assign_pointer() and
rcu_dereference() (in Hubert's example, the accesses to variable "a")
really need to be READ_ONCE()/WRITE_ONCE() or stronger, correct?

							Thanx, Paul
