Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E082C145CDF
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 21:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgAVUHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 15:07:52 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:2928 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAVUHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 15:07:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1579723670; x=1611259670;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ueX0G7wIXquYs+8WYX9TErA6JaqRVAVxKMvnUG5/Yoo=;
  b=v1xYN1bPyC5cz1TbYFPOfCBYM768otq+bT7flChWwEvx1LZjSKOE2OiW
   Q+FhgzlsR41fm98TImfN9yNxiuQ82zybWur+mCfFKleiqM1An58OBEvhM
   VXFxid9Kk4Q5wX9IyD0W3SSgO3D9CoVA2XQh7xuVg6xyGb5dv2rgld4/c
   8=;
IronPort-SDR: Xn8mshXB0Ao/qFRS4wJxFHAsfw6z7a6GBgtyZHvuY4eA8gMw2T1rrcekTeYFCht0KkS6ClcY/i
 qeTvoquzNZiA==
X-IronPort-AV: E=Sophos;i="5.70,350,1574121600"; 
   d="scan'208";a="21818317"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-c5104f52.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 22 Jan 2020 20:07:28 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-c5104f52.us-west-2.amazon.com (Postfix) with ESMTPS id BEDB6A1E0B;
        Wed, 22 Jan 2020 20:07:26 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 22 Jan 2020 20:07:10 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 22 Jan 2020 20:07:10 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Wed, 22 Jan 2020 20:07:10 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 3816740F17; Wed, 22 Jan 2020 20:07:10 +0000 (UTC)
Date:   Wed, 22 Jan 2020 20:07:10 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
CC:     Peter Zijlstra <peterz@infradead.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "x86@kernel.org" <x86@kernel.org>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "konrad.wilk@oracle.co" <konrad.wilk@oracle.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fllinden@amaozn.com" <fllinden@amazon.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        <anchalag@amazon.com>
Subject: Re: [RFC PATCH V2 11/11] x86: tsc: avoid system instability in
 hibernation
Message-ID: <20200122200710.GA3071@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <20200107234526.GA19034@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200108105011.GY2827@hirez.programming.kicks-ass.net>
 <20200110153520.GC8214@u40b0340c692b58f6553c.ant.amazon.com>
 <20200113101609.GT2844@hirez.programming.kicks-ass.net>
 <857b42b2e86b2ae09a23f488daada3b1b2836116.camel@amazon.com>
 <20200113124247.GG2827@hirez.programming.kicks-ass.net>
 <CAJZ5v0jv+5aLY3N4wFSitu61o9S8tJWEWGGn1Xyw-P82_TwFdQ@mail.gmail.com>
 <CAJZ5v0imNbbch=NWAdgVKf_hjwRrEiWAL8SFNwe6rW_SjgYzrw@mail.gmail.com>
 <20200114192952.GA26755@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200114192952.GA26755@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 07:29:52PM +0000, Anchal Agarwal wrote:
> On Tue, Jan 14, 2020 at 12:30:02AM +0100, Rafael J. Wysocki wrote:
> > On Mon, Jan 13, 2020 at 10:50 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > >
> > > On Mon, Jan 13, 2020 at 1:43 PM Peter Zijlstra <peterz@infradead.org> wrote:
> > > >
> > > > On Mon, Jan 13, 2020 at 11:43:18AM +0000, Singh, Balbir wrote:
> > > > > For your original comment, just wanted to clarify the following:
> > > > >
> > > > > 1. After hibernation, the machine can be resumed on a different but compatible
> > > > > host (these are VM images hibernated)
> > > > > 2. This means the clock between host1 and host2 can/will be different
> > > > >
> > > > > In your comments are you making the assumption that the host(s) is/are the
> > > > > same? Just checking the assumptions being made and being on the same page with
> > > > > them.
> > > >
> > > > I would expect this to be the same problem we have as regular suspend,
> > > > after power off the TSC will have been reset, so resume will have to
> > > > somehow bridge that gap. I've no idea if/how it does that.
> > >
> > > In general, this is done by timekeeping_resume() and the only special
> > > thing done for the TSC appears to be the tsc_verify_tsc_adjust(true)
> > > call in tsc_resume().
> > 
> > And I forgot about tsc_restore_sched_clock_state() that gets called
> > via restore_processor_state() on x86, before calling
> > timekeeping_resume().
> >
> In this case tsc_verify_tsc_adjust(true) this does nothing as
> feature bit X86_FEATURE_TSC_ADJUST is not available to guest. 
> I am no expert in this area, but could this be messing things up?
> 
> Thanks,
> Anchal
Gentle nudge on this. I will add more data here in case that helps.

1. Before this patch, tsc is stable but hibernation does not work
100% of the time. I agree if tsc is stable it should not be marked
unstable however, in this case if I run a cpu intensive workload
in the background and trigger reboot-hibernation loop I see a 
workqueue lockup. 

2. The lockup does not hose the system completely,
the reboot-hibernation carries out and system recovers. 
However, as mentioned in the commit message system does 
become unreachable for couple of seconds.

3. Xen suspend/resume seems to save/restore time_memory area in its
xen_arch_pre_suspend and xen_arch_post_suspend. The xen clock value
is saved. xen_sched_clock_offset is set at resume time to ensure a
monotonic clock value

4. Also, the instances do not have InvariantTSC exposed. Feature bit
X86_FEATURE_TSC_ADJUST is not available to guest and xen clocksource
is used by guests.

I am not sure if something needs to be fixed on hibernate path itself
or its very much ties to time handling on xen guest hibernation

Here is a part of log from last hibernation exit to next hibernation
entry. The loop was running for a while so boot to lockup log will be
huge. I am specifically including the timestamps.

...
01h 57m 15.627s(  16ms): [    5.822701] OOM killer enabled.
01h 57m 15.627s(   0ms): [    5.824981] Restarting tasks ... done.
01h 57m 15.627s(   0ms): [    5.836397] PM: hibernation exit
01h 57m 17.636s(2009ms): [    7.844471] PM: hibernation entry
01h 57m 52.725s(35089ms): [   42.934542] BUG: workqueue lockup - pool cpus=0
node=0 flags=0x0 nice=0 stuck for 37s!
01h 57m 52.730s(   5ms): [   42.941468] Showing busy workqueues and worker
pools:
01h 57m 52.734s(   4ms): [   42.945088] workqueue events: flags=0x0
01h 57m 52.737s(   3ms): [   42.948385]   pwq 0: cpus=0 node=0 flags=0x0 nice=0
active=2/256
01h 57m 52.742s(   5ms): [   42.952838]     pending: vmstat_shepherd,
check_corruption
01h 57m 52.746s(   4ms): [   42.956927] workqueue events_power_efficient:
flags=0x80
01h 57m 52.749s(   3ms): [   42.960731]   pwq 0: cpus=0 node=0 flags=0x0 nice=0
active=4/256
01h 57m 52.754s(   5ms): [   42.964835]     pending: neigh_periodic_work,
do_cache_clean [sunrpc], neigh_periodic_work, check_lifetime
01h 57m 52.781s(  27ms): [   42.971419] workqueue mm_percpu_wq: flags=0x8
01h 57m 52.781s(   0ms): [   42.974628]   pwq 0: cpus=0 node=0 flags=0x0 nice=0
active=1/256
01h 57m 52.781s(   0ms): [   42.978901]     pending: vmstat_update
01h 57m 52.781s(   0ms): [   42.981822] workqueue ipv6_addrconf: flags=0x40008
01h 57m 52.781s(   0ms): [   42.985524]   pwq 0: cpus=0 node=0 flags=0x0 nice=0
active=1/1
01h 57m 52.781s(   0ms): [   42.989670]     pending: addrconf_verify_work [ipv6]
01h 57m 52.782s(   1ms): [   42.993282] workqueue xfs-conv/xvda1: flags=0xc
01h 57m 52.786s(   4ms): [   42.996708]   pwq 0: cpus=0 node=0 flags=0x0 nice=0
active=3/256
01h 57m 52.790s(   4ms): [   43.000954]     pending: xfs_end_io [xfs],
xfs_end_io [xfs], xfs_end_io [xfs]
01h 57m 52.795s(   5ms): [   43.005610] workqueue xfs-reclaim/xvda1: flags=0xc
01h 57m 52.798s(   3ms): [   43.008945]   pwq 0: cpus=0 node=0 flags=0x0 nice=0
active=1/256
01h 57m 52.802s(   4ms): [   43.012675]     pending: xfs_reclaim_worker [xfs]
01h 57m 52.805s(   3ms): [   43.015741] workqueue xfs-sync/xvda1: flags=0x4
01h 57m 52.808s(   3ms): [   43.018723]   pwq 0: cpus=0 node=0 flags=0x0 nice=0
active=1/256
01h 57m 52.811s(   3ms): [   43.022436]     pending: xfs_log_worker [xfs]
01h 57m 52.814s(   3ms): [   43.043519] Filesystems sync: 35.234 seconds
01h 57m 52.837s(  23ms): [   43.048133] Freezing user space processes ...
(elapsed 0.001 seconds) done.
01h 57m 52.844s(   7ms): [   43.055996] OOM killer disabled.
01h 57m 53.838s( 994ms): [   43.061512] PM: Preallocating image memory... done
(allocated 385859 pages)
01h 57m 53.843s(   5ms): [   44.054720] PM: Allocated 1543436 kbytes in 1.06
seconds (1456.07 MB/s)
01h 57m 53.861s(  18ms): [   44.060885] Freezing remaining freezable tasks ...
(elapsed 0.001 seconds) done.
01h 57m 53.861s(   0ms): [   44.069715] printk: Suspending console(s) (use
no_console_suspend to debug)
01h 57m 56.278s(2417ms): [   44.116601] Disabling non-boot CPUs ...
.....
hibernate-resume loop continues after this. As mentioned above, I loose
connectivity for a while.


Thanks,
Anchal

