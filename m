Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14BB917EC31
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 23:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgCIWhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 18:37:23 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:15790 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgCIWhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 18:37:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1583793442; x=1615329442;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nm/K+hs17EKcRVzHSvMbu0ne+AtNnO2mJL12xgMBEqU=;
  b=M1BvI8m/KpYo1UUyoqj2zpbeLR31a2EWnp8puAlgmUTUwsPyi3R+LQmq
   l/4dGTVquB+ed3eWGPWyUFPld5UxroxCobwDiOzRucs4v7Ki2f1iioOeo
   T42/FP9oG1CtqKWwH2a7auLc9n2MQ8KMBsObXIwsAo3IRX1bildxeyFnL
   E=;
IronPort-SDR: NHag6RFlU2mvRcJeDLBg74Cs4Z7ht0ObfH2JR56T3a1uxhtCZDsJ8DmJX73OAE6jYthefr21k9
 1hhjxqoVWmpQ==
X-IronPort-AV: E=Sophos;i="5.70,534,1574121600"; 
   d="scan'208";a="31596269"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 09 Mar 2020 22:37:20 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 72D19A2582;
        Mon,  9 Mar 2020 22:37:18 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 9 Mar 2020 22:37:03 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 9 Mar 2020 22:37:03 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Mon, 9 Mar 2020 22:37:02 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id CBD26408BA; Mon,  9 Mar 2020 22:37:02 +0000 (UTC)
Date:   Mon, 9 Mar 2020 22:37:02 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <boris.ostrovsky@oracle.com>, <jgross@suse.com>,
        <linux-pm@vger.kernel.org>, <linux-mm@kvack.org>,
        <kamatam@amazon.com>, <sstabellini@kernel.org>,
        <konrad.wilk@oracle.com>, <roger.pau@citrix.com>,
        <axboe@kernel.dk>, <davem@davemloft.net>, <rjw@rjwysocki.net>,
        <len.brown@intel.com>, <pavel@ucw.cz>, <peterz@infradead.org>,
        <eduval@amazon.com>, <sblbir@amazon.com>,
        <xen-devel@lists.xenproject.org>, <vkuznets@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dwmw@amazon.co.uk>, <fllinden@amaozn.com>,
        <benh@kernel.crashing.org>
Subject: Re: [EXTERNAL][RFC PATCH v3 07/12] genirq: Shutdown irq chips in
 suspend/resume during hibernation
Message-ID: <20200309223702.GA8513@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <e782c510916c8c05dc95ace151aba4eced207b31.1581721799.git.anchalag@amazon.com>
 <87ftelaxwn.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87ftelaxwn.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 07, 2020 at 12:03:52AM +0100, Thomas Gleixner wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> Anchal Agarwal <anchalag@amazon.com> writes:
> 
> > There are no pm handlers for the legacy devices, so during tear down
> > stale event channel <> IRQ mapping may still remain in the image and
> > resume may fail. To avoid adding much code by implementing handlers for
> > legacy devices, add a new irq_chip flag IRQCHIP_SHUTDOWN_ON_SUSPEND which
> > when enabled on an irq-chip e.g xen-pirq, it will let core suspend/resume
> > irq code to shutdown and restart the active irqs. PM suspend/hibernation
> > code will rely on this.
> > Without this, in PM hibernation, information about the event channel
> > remains in hibernation image, but there is no guarantee that the same
> > event channel numbers are assigned to the devices when restoring the
> > system. This may cause conflict like the following and prevent some
> > devices from being restored correctly.
> 
> The above is just an agglomeration of words and acronyms and some of
> these sentences do not even make sense. Anyone who is not aware of event
> channels and whatever XENisms you talk about will be entirely
> confused. Changelogs really need to be understandable for mere mortals
> and there is no space restriction so acronyms can be written out.
> 
I don't understand what does not makes sense here. Of course the one you
described is more elaborate and explanatory and I agree I just wrote a short 
one from perspective of PM hibernation related to Xen domU. 
All I explained was why teardown is needed, what is the solution and 
what will happen if we do not clear those mappings. 
> Something like this:
> 
>   Many legacy device drivers do not implement power management (PM)
>   functions which means that interrupts requested by these drivers stay
>   in active state when the kernel is hibernated.
> 
>   This does not matter on bare metal and on most hypervisors because the
>   interrupt is restored on resume without any noticable side effects as
>   it stays connected to the same physical or virtual interrupt line.
> 
>   The XEN interrupt mechanism is different as it maintains a mapping
>   between the Linux interrupt number and a XEN event channel. If the
>   interrupt stays active on hibernation this mapping is preserved but
>   there is unfortunately no guarantee that on resume the same event
>   channels are reassigned to these devices. This can result in event
>   channel conflicts which prevent the affected devices from being
>   restored correctly.
> 
>   One way to solve this would be to add the necessary power management
>   functions to all affected legacy device drivers, but that's a
>   questionable effort which does not provide any benefits on non-XEN
>   environments.
> 
>   The least intrusive and most efficient solution is to provide a
>   mechanism which allows the core interrupt code to tear down these
>   interrupts on hibernation and bring them back up again on resume. This
>   allows the XEN event channel mechanism to assign an arbitrary event
>   channel on resume without affecting the functionality of these
>   devices.
> 
>   Fortunately all these device interrupts are handled by a dedicated XEN
>   interrupt chip so the chip can be marked that all interrupts connected
>   to it are handled this way. This is pretty much in line with the other
>   interrupt chip specific quirks, e.g. IRQCHIP_MASK_ON_SUSPEND.
> 
>   Add a new quirk flag IRQCHIP_SHUTDOWN_ON_SUSPEND and add support for
>   it the core interrupt suspend/resume paths.
> 
> Hmm?
> 
Sure.
> > Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
> > Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Not that I care much, but now that I've written both the patch and the
> changelog you might change that attribution slightly. For completeness
> sake:
> 
Why not. That's mandated now :)
>  Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Thanks,
> 
>         tglx
Thanks,
Anchal
