Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA546B2AE
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 02:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388880AbfGQAKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 20:10:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46304 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728597AbfGQAKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 20:10:12 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6H07KiH124292;
        Tue, 16 Jul 2019 20:08:00 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tsnmnejq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jul 2019 20:07:59 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6H07OI6125043;
        Tue, 16 Jul 2019 20:07:59 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tsnmnejpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jul 2019 20:07:59 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6H06MZU032508;
        Wed, 17 Jul 2019 00:07:57 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 2tq6x63b2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jul 2019 00:07:57 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6H07vFM39780686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 00:07:57 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A3E4B2065;
        Wed, 17 Jul 2019 00:07:57 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0D28B206E;
        Wed, 17 Jul 2019 00:07:56 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.80.225.134])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jul 2019 00:07:56 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 30CFA16C8E9B; Tue, 16 Jul 2019 17:07:57 -0700 (PDT)
Date:   Tue, 16 Jul 2019 17:07:57 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
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
        Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        peterz@infradead.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 2/9] rcu: Add support for consolidated-RCU reader
 checking (v3)
Message-ID: <20190717000757.GQ14271@linux.ibm.com>
Reply-To: paulmck@linux.ibm.com
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-3-joel@joelfernandes.org>
 <20190716183833.GD14271@linux.ibm.com>
 <20190716184649.GA130463@google.com>
 <20190716185303.GM14271@linux.ibm.com>
 <20190716220205.GB172157@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716220205.GB172157@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160263
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 06:02:05PM -0400, Joel Fernandes wrote:
> On Tue, Jul 16, 2019 at 11:53:03AM -0700, Paul E. McKenney wrote:
> [snip]
> > > > A few more things below.
> > > > > ---
> > > > >  include/linux/rculist.h  | 28 ++++++++++++++++++++-----
> > > > >  include/linux/rcupdate.h |  7 +++++++
> > > > >  kernel/rcu/Kconfig.debug | 11 ++++++++++
> > > > >  kernel/rcu/update.c      | 44 ++++++++++++++++++++++++----------------
> > > > >  4 files changed, 67 insertions(+), 23 deletions(-)
> > > > > 
> > > > > diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> > > > > index e91ec9ddcd30..1048160625bb 100644
> > > > > --- a/include/linux/rculist.h
> > > > > +++ b/include/linux/rculist.h
> > > > > @@ -40,6 +40,20 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
> > > > >   */
> > > > >  #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
> > > > >  
> > > > > +/*
> > > > > + * Check during list traversal that we are within an RCU reader
> > > > > + */
> > > > > +
> > > > > +#ifdef CONFIG_PROVE_RCU_LIST
> > > > 
> > > > This new Kconfig option is OK temporarily, but unless there is reason to
> > > > fear malfunction that a few weeks of rcutorture, 0day, and -next won't
> > > > find, it would be better to just use CONFIG_PROVE_RCU.  The overall goal
> > > > is to reduce the number of RCU knobs rather than grow them, must though
> > > > history might lead one to believe otherwise.  :-/
> > > 
> > > If you want, we can try to drop this option and just use PROVE_RCU however I
> > > must say there may be several warnings that need to be fixed in a short
> > > period of time (even a few weeks may be too short) considering the 1000+
> > > uses of RCU lists.
> > Do many people other than me build with CONFIG_PROVE_RCU?  If so, then
> > that would be a good reason for a temporary CONFIG_PROVE_RCU_LIST,
> > as in going away in a release or two once the warnings get fixed.
> 
> PROVE_RCU is enabled by default with PROVE_LOCKING, so it is used quite
> heavilty.
> 
> > > But I don't mind dropping it and it may just accelerate the fixing up of all
> > > callers.
> > 
> > I will let you decide based on the above question.  But if you have
> > CONFIG_PROVE_RCU_LIST, as noted below, it needs to depend on RCU_EXPERT.
> 
> Ok, will make it depend. But yes for temporary purpose, I will leave it as a
> config and remove it later.

Very good, thank you!  Plus you got another ack.  ;-)

							Thanx, Paul
