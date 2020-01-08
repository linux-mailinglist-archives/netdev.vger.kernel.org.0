Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0066134ECF
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbgAHVYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:24:39 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:37467 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgAHVYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:24:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1578518679; x=1610054679;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OYjFFo0DrFCWzOOz/gny+i2vR66GYQHB2pkG1xclaIo=;
  b=OJVRLUnMY4FBNgKCTu4ANWl63mxgUTWlPxTcoT8D+rnGkNhiTfNzUrtO
   T2mhu9CkXSd5lIRlUpOdSqKpC5Cul6w7MGnG0pL0zPjAeqML3OzsfKEGW
   C6Q6NY9QVkLBoU1nekIVIVzw+v4o7qifaJzq6eqAfV9Faq1pXesRy1kau
   I=;
IronPort-SDR: pEvaeQmguSuyTaI/dz/YeUORvZXYn05WOkURz0oliguYx//z58wUrptZSkzkMPSfNKtLeXWNlj
 Vptfrbuz+gvw==
X-IronPort-AV: E=Sophos;i="5.69,411,1571702400"; 
   d="scan'208";a="11513237"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 08 Jan 2020 21:24:35 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 95D21C5B6F;
        Wed,  8 Jan 2020 21:24:33 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 8 Jan 2020 21:24:18 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 8 Jan 2020 21:24:17 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Wed, 8 Jan 2020 21:24:17 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id DE4FD40E78; Wed,  8 Jan 2020 21:24:17 +0000 (UTC)
Date:   Wed, 8 Jan 2020 21:24:17 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <boris.ostrovsky@oracle.com>, <jgross@suse.com>,
        <linux-pm@vger.kernel.org>, <linux-mm@kvack.org>,
        <kamatam@amazon.com>, <sstabellini@kernel.org>,
        <konrad.wilk@oracle.co>, <roger.pau@citrix.com>, <axboe@kernel.dk>,
        <davem@davemloft.net>, <rjw@rjwysocki.net>, <len.brown@intel.com>,
        <pavel@ucw.cz>, <peterz@infradead.org>, <eduval@amazon.com>,
        <sblbir@amazon.com>, <xen-devel@lists.xenproject.org>,
        <vkuznets@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dwmw@amazon.co.uk>,
        <fllinden@amazon.com>, <anchalag@amazon.com>
Subject: Re: [RFC PATCH V2 09/11] xen: Clear IRQD_IRQ_STARTED flag during
 shutdown PIRQs
Message-ID: <20200108212417.GA22381@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <20200107234420.GA18738@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <877e22ezv6.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <877e22ezv6.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 04:23:25PM +0100, Thomas Gleixner wrote:
> Anchal Agarwal <anchalag@amazon.com> writes:
> 
> > shutdown_pirq is invoked during hibernation path and hence
> > PIRQs should be restarted during resume.
> > Before this commit'020db9d3c1dc0a' xen/events: Fix interrupt lost
> > during irq_disable and irq_enable startup_pirq was automatically
> > called during irq_enable however, after this commit pirq's did not
> > get explicitly started once resumed from hibernation.
> >
> > chip->irq_startup is called only if IRQD_IRQ_STARTED is unset during
> > irq_startup on resume. This flag gets cleared by free_irq->irq_shutdown
> > during suspend. free_irq() never gets explicitly called for ioapic-edge
> > and ioapic-level interrupts as respective drivers do nothing during
> > suspend/resume. So we shut them down explicitly in the first place in
> > syscore_suspend path to clear IRQ<>event channel mapping. shutdown_pirq
> > being called explicitly during suspend does not clear this flags, hence
> > .irq_enable is called in irq_startup during resume instead and pirq's
> > never start up.
> 
> What? 
> 
> > +void irq_state_clr_started(struct irq_desc *desc)
> >  {
> >  	irqd_clear(&desc->irq_data, IRQD_IRQ_STARTED);
> >  }
> > +EXPORT_SYMBOL_GPL(irq_state_clr_started);
> 
> This is core internal state and not supposed to be fiddled with by
> drivers.
> 
> irq_chip has irq_suspend/resume/pm_shutdown callbacks for a reason.
>
I agree, as its mentioned in the previous patch {[RFC PATCH V2 08/11]} this is 
one way of explicitly shutting down legacy devices without introducing too much 
code for each of the legacy devices. . for eg. in case of floppy there 
is no suspend/freeze handler which should have done the needful.
.
Either we implement them for all the legacy devices that have them missing or
explicitly shutdown pirqs. I have choosen later for simplicity. I understand
that ideally we should enable/disable devices interrupts in suspend/resume 
devices but that requires adding code for doing that to few drivers[and I may
not know all of them either]

Now I discovered during the flow in hibernation_platform_enter under resume 
devices that for such devices irq_startup is called which checks for 
IRQD_IRQ_STARTED flag and based on that it calls irq_enable or irq_startup.
They are only restarted if the flag is not set which is cleared during shutdown. 
shutdown_pirq does not do that. Only masking/unmasking of evtchn does not work 
as pirq needs to be restarted.
xen-pirq.enable_irq is called rather than stratup_pirq. On resume if these pirqs
are not restarted in this case ACPI SCI interrupts, I do not see receiving 
any interrupts under cat /proc/interrupts even though host keeps generating 
S4 ACPI events. 
Does that makes sense?

Thanks,
Anchal
> Thanks,
> 
>        tglx
