Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBDD32631
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 03:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfFCBhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 21:37:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40522 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726561AbfFCBhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 21:37:32 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x531ahF0120790
        for <netdev@vger.kernel.org>; Sun, 2 Jun 2019 21:37:31 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2svnuaxtd5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 21:37:30 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Mon, 3 Jun 2019 02:37:30 +0100
Received: from b01cxnp22036.gho.pok.ibm.com (9.57.198.26)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 3 Jun 2019 02:37:25 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x531bOTL10617208
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 01:37:24 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CA60B206B;
        Mon,  3 Jun 2019 01:37:24 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38429B2067;
        Mon,  3 Jun 2019 01:37:24 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.136.155])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jun 2019 01:37:24 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 5467E16C37A7; Sun,  2 Jun 2019 17:06:17 -0700 (PDT)
Date:   Sun, 2 Jun 2019 17:06:17 -0700
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19060301-0072-0000-0000-000004369950
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011206; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01212416; UDB=6.00637148; IPR=6.00993472;
 MB=3.00027158; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-03 01:37:28
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060301-0073-0000-0000-00004C762ED8
Message-Id: <20190603000617.GD28207@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-02_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=589 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030009
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 02, 2019 at 01:56:07PM +0800, Herbert Xu wrote:
> Digging up an old email because I was not aware of this previously
> but Paul pointed me to it during another discussion.
> 
> On Mon, Sep 21, 2015 at 01:43:27PM -0700, Paul E. McKenney wrote:
> > On Mon, Sep 21, 2015 at 09:30:49PM +0200, Frederic Weisbecker wrote:
> >
> > > > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > > > index d63bb77..6c3cece 100644
> > > > --- a/include/linux/rcupdate.h
> > > > +++ b/include/linux/rcupdate.h
> > > > @@ -297,12 +297,14 @@ void synchronize_rcu(void);
> > > >  
> > > >  static inline void __rcu_read_lock(void)
> > > >  {
> > > > -	preempt_disable();
> > > > +	if (IS_ENABLED(CONFIG_PREEMPT_COUNT))
> > > > +		preempt_disable();
> > > 
> > > preempt_disable() is a no-op when !CONFIG_PREEMPT_COUNT, right?
> > > Or rather it's a barrier(), which is anyway implied by rcu_read_lock().
> > > 
> > > So perhaps we can get rid of the IS_ENABLED() check?
> > 
> > Actually, barrier() is not intended to be implied by rcu_read_lock().
> > In a non-preemptible RCU implementation, it doesn't help anything
> > to have the compiler flush its temporaries upon rcu_read_lock()
> > and rcu_read_unlock().
> 
> This is seriously broken.  RCU has been around for years and is
> used throughout the kernel while the compiler barrier existed.

Please note that preemptible Tree RCU has lacked the compiler barrier on
all but the outermost rcu_read_unlock() for years before Boqun's patch.

So exactly where in the code that we are currently discussing
are you relying on compiler barriers in either rcu_read_lock() or
rcu_read_unlock()?

The grace-period guarantee allows the compiler ordering to be either in
the readers (SMP&&PREEMPT), in the grace-period mechanism (SMP&&!PREEMPT),
or both (SRCU).

> You can't then go and decide to remove the compiler barrier!  To do
> that you'd need to audit every single use of rcu_read_lock in the
> kernel to ensure that they're not depending on the compiler barrier.
> 
> This is also contrary to the definition of almost every other
> *_lock primitive in the kernel where the compiler barrier is
> included.
> 
> So please revert this patch.

I do not believe that reverting that patch will help you at all.

But who knows?  So please point me at the full code body that was being
debated earlier on this thread.  It will no doubt take me quite a while to
dig through it, given my being on the road for the next couple of weeks,
but so it goes.

							Thanx, Paul

