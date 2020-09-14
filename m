Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5971826983F
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbgINVsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:48:16 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:64557 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgINVsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 17:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600120094; x=1631656094;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=f9VAxAP7zK34FSX3/c14VueaGaLkkGHOC7c1EvretSw=;
  b=tKjC64bw5PB7MwuE1xTEeDJdwaCbZEATeOnIo2htz0pMIHOXQwUz2WX+
   wdMZnidUjrcBHK4+USGxmhinWv2i9een8owACWMp2BtoMzi3wxHeJ3gDl
   Fph6QkAH9K0wimixHN+bMgESWuuzoSvJeFDOzWAYBIMobPdxK+AfewR2J
   s=;
X-IronPort-AV: E=Sophos;i="5.76,427,1592870400"; 
   d="scan'208";a="67949685"
Subject: Re: [PATCH v3 01/11] xen/manage: keep track of the on-going suspend mode
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 14 Sep 2020 21:48:10 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id 0DED1A200C;
        Mon, 14 Sep 2020 21:48:07 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 14 Sep 2020 21:47:55 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 14 Sep 2020 21:47:54 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Mon, 14 Sep 2020 21:47:54 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 8F43540A16; Mon, 14 Sep 2020 21:47:54 +0000 (UTC)
Date:   Mon, 14 Sep 2020 21:47:54 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     <boris.ostrovsky@oracle.com>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <jgross@suse.com>,
        <linux-pm@vger.kernel.org>, <linux-mm@kvack.org>,
        <kamatam@amazon.com>, <sstabellini@kernel.org>,
        <konrad.wilk@oracle.com>, <roger.pau@citrix.com>,
        <axboe@kernel.dk>, <davem@davemloft.net>, <rjw@rjwysocki.net>,
        <len.brown@intel.com>, <pavel@ucw.cz>, <peterz@infradead.org>,
        <eduval@amazon.com>, <sblbir@amazon.com>,
        <xen-devel@lists.xenproject.org>, <vkuznets@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dwmw@amazon.co.uk>, <benh@kernel.crashing.org>
Message-ID: <20200914214754.GA19975@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1598042152.git.anchalag@amazon.com>
 <9b970e12491107afda0c1d4a6f154b52d90346ac.1598042152.git.anchalag@amazon.com>
 <4b2bbc8b-7817-271a-4ff0-5ee5df956049@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4b2bbc8b-7817-271a-4ff0-5ee5df956049@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 13, 2020 at 11:43:30AM -0400, boris.ostrovsky@oracle.com wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 8/21/20 6:25 PM, Anchal Agarwal wrote:
> > From: Munehisa Kamata <kamatam@amazon.com>
> >
> > Guest hibernation is different from xen suspend/resume/live migration.
> > Xen save/restore does not use pm_ops as is needed by guest hibernation.
> > Hibernation in guest follows ACPI path and is guest inititated , the
> > hibernation image is saved within guest as compared to later modes
> > which are xen toolstack assisted and image creation/storage is in
> > control of hypervisor/host machine.
> > To differentiate between Xen suspend and PM hibernation, keep track
> > of the on-going suspend mode by mainly using a new API to keep track of
> > SHUTDOWN_SUSPEND state.
> > Introduce a simple function that keeps track of on-going suspend mode
> > so that PM hibernation code can behave differently according to the
> > current suspend mode.
> > Since Xen suspend doesn't have corresponding PM event, its main logic
> > is modfied to acquire pm_mutex.
> 
> 
> lock_system_sleep() is not taking this mutex.
>
Yes, I just realized that the commit 55f2503c ("PM / reboot: Eliminate race
between reboot and suspend") changed its name to system_transition_mutex.
I think I missed that change somehow and assumed its still pm_mutex.
Will fix the description.
> 
> >
> > Though, accquirng pm_mutex is still right thing to do, we may
> > see deadlock if PM hibernation is interrupted by Xen suspend.
> > PM hibernation depends on xenwatch thread to process xenbus state
> > transactions, but the thread will sleep to wait pm_mutex which is
> > already held by PM hibernation context in the scenario. Xen shutdown
> > code may need some changes to avoid the issue.
> 
> 
> 
> Is it Xen's shutdown or suspend code that needs to address this? (Or I
> may not understand what the problem is that you are describing)
> 
Its Xen suspend code I think. If we do not take the system_transition_mutex
in do_suspend then if hibernation is triggered in parallel to xen suspend there
could be issues. Now this is still theoretical in my case and I havent been able
to reproduce such a race. So the approach the original author took was to take
this lock which to me seems right.
And its Xen suspend and not Xen Shutdown. So basically if this scenario
happens I am of the view one of other will fail to occur then how do we recover
or avoid this at all.

Does that answer your question?
> 
> >
> > +
> > +static int xen_pm_notifier(struct notifier_block *notifier,
> > +     unsigned long pm_event, void *unused)
> > +{
> > +     int ret;
> > +
> > +     switch (pm_event) {
> > +     case PM_SUSPEND_PREPARE:
> > +     case PM_HIBERNATION_PREPARE:
> > +     /* Guest hibernation is not supported for aarch64 currently*/
> > +     if (IS_ENABLED(CONFIG_ARM64)) {
> > +             ret = NOTIFY_BAD;
> > +             break;
> > +     }
> 
> Indentation.
> 
> > +     case PM_RESTORE_PREPARE:
> > +     case PM_POST_SUSPEND:
> > +     case PM_POST_HIBERNATION:
> > +     case PM_POST_RESTORE:
> > +     default:
> > +             ret = NOTIFY_OK;
> > +     }
> > +     return ret;
> > +};
> 
> 
> This whole routine now is
> 
>         if (IS_ENABLED(CONFIG_ARM64))
>                 return NOTIFY_BAD;
> 
>         return NOTIFY_OK;
> 
> isn't it?
> 
Yes.
> 
> > +
> > +static struct notifier_block xen_pm_notifier_block = {
> > +     .notifier_call = xen_pm_notifier
> > +};
> > +
> > +static int xen_setup_pm_notifier(void)
> > +{
> > +     if (!xen_hvm_domain() || xen_initial_domain())
> > +             return -ENODEV;
> 
> 
> I don't think this works anymore.
What do you mean?
The first check is for xen domain types and other is for architecture support. 
The reason I put this check here is because I wanted to segregate the two.
I do not want to register this notifier at all for !hmv guest and also if its
an initial control domain.
The arm check only lands in notifier because once hibernate() api is called ->
calls pm_notifier_call_chain for PM_HIBERNATION_PREPARE this will fail for
aarch64. 
Once we have support for aarch64 this notifier can go away altogether. 

Is there any other reason I may be missing why we should move this check to
notifier?
> 
> In the past your notifier would set suspend_mode (or something) but now
> it really doesn't do anything except reports an error in some (ARM) cases.
> 
> So I think you should move this check into the notifier.

> 
> (And BTW I still think PM_SUSPEND_PREPARE should return an error too.
> The fact that we are using "suspend" in xen routine names is irrelevant)
> 
I may have send "not-updated" version of the notifier's function change.

+    switch (pm_event) {
+       case PM_HIBERNATION_PREPARE:
+        /* Guest hibernation is not supported for aarch64 currently*/
+        if (IS_ENABLED(CONFIG_ARM64)) {
+             ret = NOTIFY_BAD;                                                                                                                                                                                                                                                    
+             break;                                                                                                                                                                                                                                                               
+     }               
+       case PM_RESTORE_PREPARE:
+       case PM_POST_RESTORE:
+       case PM_POST_HIBERNATION:
+       default:
+           ret = NOTIFY_OK;
+    }

With the above path PM_SUSPEND_PREPARE will go all together. Does that
resolves this issue? I wanted to get rid of all SUSPEND_* as they are not needed
here clearly.
The only reason I kept it there is if someone tries to trigger hibernation on
ARM instances they should get an error. As I am not sure about the current
behavior. There may be a better way to not invoke hibernation on ARM DomU's and
get rid of this block all together.

Again, sorry for sending in the half baked fix. My workspace switch may have
caused the error.
>
> 
> 
> -boris
> 
Anchal
> 
> 
> > +     return register_pm_notifier(&xen_pm_notifier_block);
> > +}
> > +
