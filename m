Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D036680DC
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 20:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbfGNSxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 14:53:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6002 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728125AbfGNSxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 14:53:02 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6EIlCEJ106075;
        Sun, 14 Jul 2019 14:50:30 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tqvuf5gts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Jul 2019 14:50:30 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6EIoUZH135521;
        Sun, 14 Jul 2019 14:50:30 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tqvuf5gta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Jul 2019 14:50:29 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6EInRHA026321;
        Sun, 14 Jul 2019 18:50:28 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 2tq6x6tdsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 14 Jul 2019 18:50:28 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6EIoSV749414412
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 14 Jul 2019 18:50:28 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3E19B205F;
        Sun, 14 Jul 2019 18:50:27 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88499B2065;
        Sun, 14 Jul 2019 18:50:27 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.85.203.247])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 14 Jul 2019 18:50:27 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 7A5C116C8FBA; Sun, 14 Jul 2019 11:50:27 -0700 (PDT)
Date:   Sun, 14 Jul 2019 11:50:27 -0700
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
Message-ID: <20190714185027.GL26519@linux.ibm.com>
Reply-To: paulmck@linux.ibm.com
References: <20190713031008.GA248225@google.com>
 <20190713082114.GA26519@linux.ibm.com>
 <20190713133049.GA133650@google.com>
 <20190713144108.GD26519@linux.ibm.com>
 <20190713153606.GD133650@google.com>
 <20190713155010.GF26519@linux.ibm.com>
 <20190713161316.GA39321@google.com>
 <20190713212812.GH26519@linux.ibm.com>
 <20190714181053.GB34501@google.com>
 <20190714183820.GD34501@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190714183820.GD34501@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-14_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907140234
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 14, 2019 at 02:38:20PM -0400, Joel Fernandes wrote:
> On Sun, Jul 14, 2019 at 02:10:53PM -0400, Joel Fernandes wrote:
> > On Sat, Jul 13, 2019 at 02:28:12PM -0700, Paul E. McKenney wrote:
> [snip]
> > > > > > > > > > 
> > > > > > > > > > Cc: Oleg Nesterov <oleg@redhat.com>
> > > > > > > > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > > > > > > > > ---
> > > > > > > > > >  include/linux/rcu_sync.h | 4 +---
> > > > > > > > > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > > > > > > > > > 
> > > > > > > > > > diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
> > > > > > > > > > index 9b83865d24f9..0027d4c8087c 100644
> > > > > > > > > > --- a/include/linux/rcu_sync.h
> > > > > > > > > > +++ b/include/linux/rcu_sync.h
> > > > > > > > > > @@ -31,9 +31,7 @@ struct rcu_sync {
> > > > > > > > > >   */
> > > > > > > > > >  static inline bool rcu_sync_is_idle(struct rcu_sync *rsp)
> > > > > > > > > >  {
> > > > > > > > > > -	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
> > > > > > > > > > -			 !rcu_read_lock_bh_held() &&
> > > > > > > > > > -			 !rcu_read_lock_sched_held(),
> > > > > > > > > > +	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
> > > > > > > > > 
> > > > > > > > > I believe that replacing rcu_read_lock_sched_held() with preemptible()
> > > > > > > > > in a CONFIG_PREEMPT=n kernel will give you false-positive splats here.
> > > > > > > > > If you have not already done so, could you please give it a try?
> > > > > > > > 
> > > > > > > > Hi Paul,
> > > > > > > > I don't think it will cause splats for !CONFIG_PREEMPT.
> > > > > > > > 
> > > > > > > > Currently, rcu_read_lock_any_held() introduced in this patch returns true if
> > > > > > > > !preemptible(). This means that:
> > > > > > > > 
> > > > > > > > The following expression above:
> > > > > > > > RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),...)
> > > > > > > > 
> > > > > > > > Becomes:
> > > > > > > > RCU_LOCKDEP_WARN(preemptible(), ...)
> > > > > > > > 
> > > > > > > > For, CONFIG_PREEMPT=n kernels, this means:
> > > > > > > > RCU_LOCKDEP_WARN(0, ...)
> > > > > > > > 
> > > > > > > > Which would mean no splats. Or, did I miss the point?
> > > > > > > 
> > > > > > > I suggest trying it out on a CONFIG_PREEMPT=n kernel.
> > > > > > 
> > > > > > Sure, will do, sorry did not try it out yet because was busy with weekend
> > > > > > chores but will do soon, thanks!
> > > > > 
> > > > > I am not faulting you for taking the weekend off, actually.  ;-)
> > > > 
> > > > ;-) 
> > > > 
> > > > I tried doing RCU_LOCKDEP_WARN(preemptible(), ...) in this code path and I
> > > > don't get any splats. I also disassembled the code and it seems to me
> > > > RCU_LOCKDEP_WARN() becomes a NOOP which also the above reasoning confirms.
> > > 
> > > OK, very good.  Could you do the same thing for the RCU_LOCKDEP_WARN()
> > > in synchronize_rcu()?  Why or why not?
> > > 
> > 
> > Hi Paul,
> > 
> > Yes synchronize_rcu() can also make use of this technique since it is
> > strictly illegal to call synchronize_rcu() within a reader section.
> > 
> > I will add this to the set of my patches as well and send them all out next
> > week, along with the rcu-sync and bh clean ups we discussed.
> 
> After sending this email, it occurs to me it wont work in synchronize_rcu()
> for !CONFIG_PREEMPT kernels. This is because in a !CONFIG_PREEMPT kernel,
> executing in kernel mode itself looks like being in an RCU reader. So we
> should leave that as is. However it will work fine for rcu_sync_is_idle (for
> CONFIG_PREEMPT=n kernels) as I mentioned earlier.
> 
> Were trying to throw me a Quick-Quiz ? ;-) In that case, hope I passed!

You did pass.  This time.  ;-)

							Thanx, Paul
