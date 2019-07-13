Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A818C67946
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 10:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfGMIXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 04:23:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32096 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726334AbfGMIXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 04:23:45 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6D8GuqC140611;
        Sat, 13 Jul 2019 04:21:16 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tqbcpghfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 13 Jul 2019 04:21:16 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6D8Imex011412;
        Sat, 13 Jul 2019 04:21:15 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tqbcpghfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 13 Jul 2019 04:21:15 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6D8JSWE020328;
        Sat, 13 Jul 2019 08:21:14 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 2tq6x6hea4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 13 Jul 2019 08:21:14 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6D8LDlZ41746710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Jul 2019 08:21:13 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DA5DB205F;
        Sat, 13 Jul 2019 08:21:13 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11EA3B2064;
        Sat, 13 Jul 2019 08:21:13 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.195.235])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat, 13 Jul 2019 08:21:13 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 1013216C6BA7; Sat, 13 Jul 2019 01:21:14 -0700 (PDT)
Date:   Sat, 13 Jul 2019 01:21:14 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Joel Fernandes <joel@joelfernandes.org>
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
Message-ID: <20190713082114.GA26519@linux.ibm.com>
Reply-To: paulmck@linux.ibm.com
References: <20190712170024.111093-1-joel@joelfernandes.org>
 <20190712170024.111093-4-joel@joelfernandes.org>
 <20190712213559.GA175138@google.com>
 <20190712233206.GZ26519@linux.ibm.com>
 <20190713030150.GA246587@google.com>
 <20190713031008.GA248225@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190713031008.GA248225@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-13_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907130098
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 11:10:08PM -0400, Joel Fernandes wrote:
> On Fri, Jul 12, 2019 at 11:01:50PM -0400, Joel Fernandes wrote:
> > On Fri, Jul 12, 2019 at 04:32:06PM -0700, Paul E. McKenney wrote:
> > > On Fri, Jul 12, 2019 at 05:35:59PM -0400, Joel Fernandes wrote:
> > > > On Fri, Jul 12, 2019 at 01:00:18PM -0400, Joel Fernandes (Google) wrote:
> > > > > The rcu/sync code was doing its own check whether we are in a reader
> > > > > section. With RCU consolidating flavors and the generic helper added in
> > > > > this series, this is no longer need. We can just use the generic helper
> > > > > and it results in a nice cleanup.
> > > > > 
> > > > > Cc: Oleg Nesterov <oleg@redhat.com>
> > > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > > 
> > > > Hi Oleg,
> > > > Slightly unrelated to the patch,
> > > > I tried hard to understand this comment below in percpu_down_read() but no dice.
> > > > 
> > > > I do understand how rcu sync and percpu rwsem works, however the comment
> > > > below didn't make much sense to me. For one, there's no readers_fast anymore
> > > > so I did not follow what readers_fast means. Could the comment be updated to
> > > > reflect latest changes?
> > > > Also could you help understand how is a writer not able to change
> > > > sem->state and count the per-cpu read counters at the same time as the
> > > > comment tries to say?
> > > > 
> > > > 	/*
> > > > 	 * We are in an RCU-sched read-side critical section, so the writer
> > > > 	 * cannot both change sem->state from readers_fast and start checking
> > > > 	 * counters while we are here. So if we see !sem->state, we know that
> > > > 	 * the writer won't be checking until we're past the preempt_enable()
> > > > 	 * and that once the synchronize_rcu() is done, the writer will see
> > > > 	 * anything we did within this RCU-sched read-size critical section.
> > > > 	 */
> > > > 
> > > > Also,
> > > > I guess we could get rid of all of the gp_ops struct stuff now that since all
> > > > the callbacks are the same now. I will post that as a follow-up patch to this
> > > > series.
> > > 
> > > Hello, Joel,
> > > 
> > > Oleg has a set of patches updating this code that just hit mainline
> > > this week.  These patches get rid of the code that previously handled
> > > RCU's multiple flavors.  Or are you looking at current mainline and
> > > me just missing your point?
> > > 
> > 
> > Hi Paul,
> > You are right on point. I have a bad habit of not rebasing my trees. In this
> > case the feature branch of mine in concern was based on v5.1. Needless to
> > say, I need to rebase my tree.
> > 
> > Yes, this sync clean up patch does conflict when I rebase, but other patches
> > rebase just fine.
> > 
> > The 2 options I see are:
> > 1. Let us drop this patch for now and I resend it later.
> > 2. I resend all patches based on Linus's master branch.
> 
> Below is the updated patch based on Linus master branch:
> 
> ---8<-----------------------
> 
> >From 5f40c9a07fcf3d6dafc2189599d0ba9443097d0f Mon Sep 17 00:00:00 2001
> From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
> Date: Fri, 12 Jul 2019 12:13:27 -0400
> Subject: [PATCH v2.1 3/9] rcu/sync: Remove custom check for reader-section
> 
> The rcu/sync code was doing its own check whether we are in a reader
> section. With RCU consolidating flavors and the generic helper added in
> this series, this is no longer need. We can just use the generic helper
> and it results in a nice cleanup.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  include/linux/rcu_sync.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
> index 9b83865d24f9..0027d4c8087c 100644
> --- a/include/linux/rcu_sync.h
> +++ b/include/linux/rcu_sync.h
> @@ -31,9 +31,7 @@ struct rcu_sync {
>   */
>  static inline bool rcu_sync_is_idle(struct rcu_sync *rsp)
>  {
> -	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
> -			 !rcu_read_lock_bh_held() &&
> -			 !rcu_read_lock_sched_held(),
> +	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),

I believe that replacing rcu_read_lock_sched_held() with preemptible()
in a CONFIG_PREEMPT=n kernel will give you false-positive splats here.
If you have not already done so, could you please give it a try?

							Thanx, Paul

>  			 "suspicious rcu_sync_is_idle() usage");
>  	return !READ_ONCE(rsp->gp_state); /* GP_IDLE */
>  }
> -- 
> 2.22.0.510.g264f2c817a-goog
> 
