Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 802346AE95
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 20:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388385AbfGPS2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 14:28:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46834 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388354AbfGPS2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 14:28:31 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6GIRMwY070019
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 14:28:30 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tshdrpp7x-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 14:28:29 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Tue, 16 Jul 2019 19:28:28 +0100
Received: from b01cxnp22035.gho.pok.ibm.com (9.57.198.25)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 16 Jul 2019 19:28:18 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6GISHpS53281224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 18:28:17 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32C51B2064;
        Tue, 16 Jul 2019 18:28:17 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC2A1B205F;
        Tue, 16 Jul 2019 18:28:16 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.80.225.134])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 16 Jul 2019 18:28:16 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id D4CF316C905B; Tue, 16 Jul 2019 11:28:16 -0700 (PDT)
Date:   Tue, 16 Jul 2019 11:28:16 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
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
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v2 3/9] rcu/sync: Remove custom check for reader-section
Reply-To: paulmck@linux.ibm.com
References: <20190712170024.111093-1-joel@joelfernandes.org>
 <20190712170024.111093-4-joel@joelfernandes.org>
 <20190716182642.GB22819@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716182642.GB22819@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19071618-0072-0000-0000-00000449AC27
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011440; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01233103; UDB=6.00649716; IPR=6.01014415;
 MB=3.00027748; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-16 18:28:26
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071618-0073-0000-0000-00004CB9F7A1
Message-Id: <20190716182816.GA23249@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160226
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 11:26:42AM -0700, Paul E. McKenney wrote:
> On Fri, Jul 12, 2019 at 01:00:18PM -0400, Joel Fernandes (Google) wrote:
> > The rcu/sync code was doing its own check whether we are in a reader
> > section. With RCU consolidating flavors and the generic helper added in
> > this series, this is no longer need. We can just use the generic helper
> > and it results in a nice cleanup.
> > 
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> This needs to be forward-ported to current mainline.  (Or, I believe
> equivalently for this file, to branch "dev" of -rcu.)
> 
> Especially given that you have Oleg's Ack, I would be happy to
> take the forward-ported version.

Never mind, I am one version behind.  Apologies for the noise!

							Thanx, Paul

> > ---
> > Please note: Only build and boot tested this particular patch so far.
> > 
> >  include/linux/rcu_sync.h |  5 ++---
> >  kernel/rcu/sync.c        | 22 ----------------------
> >  2 files changed, 2 insertions(+), 25 deletions(-)
> > 
> > diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
> > index 6fc53a1345b3..c954f1efc919 100644
> > --- a/include/linux/rcu_sync.h
> > +++ b/include/linux/rcu_sync.h
> > @@ -39,9 +39,8 @@ extern void rcu_sync_lockdep_assert(struct rcu_sync *);
> >   */
> >  static inline bool rcu_sync_is_idle(struct rcu_sync *rsp)
> >  {
> > -#ifdef CONFIG_PROVE_RCU
> > -	rcu_sync_lockdep_assert(rsp);
> > -#endif
> > +	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
> > +			 "suspicious rcu_sync_is_idle() usage");
> >  	return !rsp->gp_state; /* GP_IDLE */
> >  }
> >  
> > diff --git a/kernel/rcu/sync.c b/kernel/rcu/sync.c
> > index a8304d90573f..535e02601f56 100644
> > --- a/kernel/rcu/sync.c
> > +++ b/kernel/rcu/sync.c
> > @@ -10,37 +10,25 @@
> >  #include <linux/rcu_sync.h>
> >  #include <linux/sched.h>
> >  
> > -#ifdef CONFIG_PROVE_RCU
> > -#define __INIT_HELD(func)	.held = func,
> > -#else
> > -#define __INIT_HELD(func)
> > -#endif
> > -
> >  static const struct {
> >  	void (*sync)(void);
> >  	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
> >  	void (*wait)(void);
> > -#ifdef CONFIG_PROVE_RCU
> > -	int  (*held)(void);
> > -#endif
> >  } gp_ops[] = {
> >  	[RCU_SYNC] = {
> >  		.sync = synchronize_rcu,
> >  		.call = call_rcu,
> >  		.wait = rcu_barrier,
> > -		__INIT_HELD(rcu_read_lock_held)
> >  	},
> >  	[RCU_SCHED_SYNC] = {
> >  		.sync = synchronize_rcu,
> >  		.call = call_rcu,
> >  		.wait = rcu_barrier,
> > -		__INIT_HELD(rcu_read_lock_sched_held)
> >  	},
> >  	[RCU_BH_SYNC] = {
> >  		.sync = synchronize_rcu,
> >  		.call = call_rcu,
> >  		.wait = rcu_barrier,
> > -		__INIT_HELD(rcu_read_lock_bh_held)
> >  	},
> >  };
> >  
> > @@ -49,16 +37,6 @@ enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
> >  
> >  #define	rss_lock	gp_wait.lock
> >  
> > -#ifdef CONFIG_PROVE_RCU
> > -void rcu_sync_lockdep_assert(struct rcu_sync *rsp)
> > -{
> > -	RCU_LOCKDEP_WARN(!gp_ops[rsp->gp_type].held(),
> > -			 "suspicious rcu_sync_is_idle() usage");
> > -}
> > -
> > -EXPORT_SYMBOL_GPL(rcu_sync_lockdep_assert);
> > -#endif
> > -
> >  /**
> >   * rcu_sync_init() - Initialize an rcu_sync structure
> >   * @rsp: Pointer to rcu_sync structure to be initialized
> > -- 
> > 2.22.0.510.g264f2c817a-goog
> > 

