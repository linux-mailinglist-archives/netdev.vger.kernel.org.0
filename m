Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C433629707D
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 15:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464834AbgJWN3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 09:29:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S374233AbgJWN3x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 09:29:53 -0400
Received: from localhost (unknown [176.167.163.208])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2474208E4;
        Fri, 23 Oct 2020 13:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603459793;
        bh=PIj6gL/WL9dtdsJ1vZSsuwhKFFiZ2/p2I3g1d0riLbg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rw60FdcUJe+qyTPBmrOTcj5E3NoXurL8oWAxHIHPprbeTYuMCT+7Gs3n5RBd2Jy5W
         WRf+9+yliV+0OQ5yC5iaBH4gFNMCFFUYp3ljQpakpeC0v3npDWlVhd5N6nD37RbpdM
         ZmYSewtFRn5JthS5ZvXUueon8401r4+/gaYy2aI0=
Date:   Fri, 23 Oct 2020 15:29:50 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, lgoncalv@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4 2/4] sched/isolation: Extend nohz_full to isolate
 managed IRQs
Message-ID: <20201023132950.GA47962@lothringen>
References: <20200928183529.471328-1-nitesh@redhat.com>
 <20200928183529.471328-3-nitesh@redhat.com>
 <20201023132505.GZ2628@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023132505.GZ2628@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 03:25:05PM +0200, Peter Zijlstra wrote:
> On Mon, Sep 28, 2020 at 02:35:27PM -0400, Nitesh Narayan Lal wrote:
> > Extend nohz_full feature set to include isolation from managed IRQS. This
> 
> So you say it's for managed-irqs, the feature is actually called
> MANAGED_IRQ, but, AFAICT, it does *NOT* in fact affect managed IRQs.
> 
> Also, as per Thomas' earlier points, managed-irqs are in fact perfectly
> fine and don't need help at at...
> 
> > is required specifically for setups that only uses nohz_full and still
> > requires isolation for maintaining lower latency for the listed CPUs.
> > 
> > Suggested-by: Frederic Weisbecker <frederic@kernel.org>

Ah and yes there is this tag :-p

So that's my bad, I really thought this thing was about managed IRQ.
The problem is that I can't find a single documentation about them so I'm
too clueless on that matter.

Thanks.

> > Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> > ---
> >  kernel/sched/isolation.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> > index 5a6ea03f9882..9df9598a9e39 100644
> > --- a/kernel/sched/isolation.c
> > +++ b/kernel/sched/isolation.c
> > @@ -141,7 +141,7 @@ static int __init housekeeping_nohz_full_setup(char *str)
> >  	unsigned int flags;
> >  
> >  	flags = HK_FLAG_TICK | HK_FLAG_WQ | HK_FLAG_TIMER | HK_FLAG_RCU |
> > -		HK_FLAG_MISC | HK_FLAG_KTHREAD;
> > +		HK_FLAG_MISC | HK_FLAG_KTHREAD | HK_FLAG_MANAGED_IRQ;
> >  
> >  	return housekeeping_setup(str, flags);
> >  }
> > -- 
> > 2.18.2
> > 
