Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B941F1E2C
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 19:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387504AbgFHRK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 13:10:28 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:62208 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730696AbgFHRK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 13:10:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1591636226; x=1623172226;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=t5Ht9pQ/L15OhRjsj3oBdWbi3godPK4J8lNDSU8Sric=;
  b=h7W5QzygyIq9kvN2MXSsz8d2kdwog+IbguIPcpOcwHFxk4ZfUhoy3VYU
   v38Ybr+IdaQPH88f0HS1mGGClX6F04gM3GQNi6w95YpSflTOWLj2fefu1
   BrX8Ww8aTcmVeGu1pg5Ca1tqXgKTILyD1UIVTd2PBcOLCx9/tsUcEp/MY
   c=;
IronPort-SDR: S8JB7UWD4QsekyIBB/T3lttKcrT1Ne/0DCTZfl8uIv+BINZ1G4WVygkiGFpts8j2A2qHCjsFIu
 YrHU8J2n5sQQ==
X-IronPort-AV: E=Sophos;i="5.73,487,1583193600"; 
   d="scan'208";a="49364832"
Subject: Re: [PATCH 04/12] x86/xen: add system core suspend and resume callbacks
Received: from sea32-co-svc-lb4-vlan2.sea.corp.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.23.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 08 Jun 2020 17:10:17 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id C791814168C;
        Mon,  8 Jun 2020 17:10:08 +0000 (UTC)
Received: from EX13D05UWC001.ant.amazon.com (10.43.162.82) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 8 Jun 2020 17:09:48 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D05UWC001.ant.amazon.com (10.43.162.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 8 Jun 2020 17:09:48 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Mon, 8 Jun 2020 17:09:47 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id F15BC40832; Mon,  8 Jun 2020 17:09:47 +0000 (UTC)
Date:   Mon, 8 Jun 2020 17:09:47 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Message-ID: <20200608170947.GA4392@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1589926004.git.anchalag@amazon.com>
 <79cf02631dc00e62ebf90410bfbbdb52fe7024cb.1589926004.git.anchalag@amazon.com>
 <4b577564-e4c3-0182-2b9e-5f79004f32a1@oracle.com>
 <B966B3A2-4F08-42FA-AF59-B8AA0783C2BA@amazon.com>
 <e2073aa4-2410-4630-fee6-4e4abc172876@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e2073aa4-2410-4630-fee6-4e4abc172876@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 05, 2020 at 05:24:37PM -0400, Boris Ostrovsky wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 6/3/20 6:40 PM, Agarwal, Anchal wrote:
> >     CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> >
> >
> >
> >     On 5/19/20 7:26 PM, Anchal Agarwal wrote:
> >     > From: Munehisa Kamata <kamatam@amazon.com>
> >     >
> >     > Add Xen PVHVM specific system core callbacks for PM suspend and
> >     > hibernation support. The callbacks suspend and resume Xen
> >     > primitives,like shared_info, pvclock and grant table. Note that
> >     > Xen suspend can handle them in a different manner, but system
> >     > core callbacks are called from the context.
> >
> >
> >     I don't think I understand that last sentence.
> >
> > Looks like it may have cryptic meaning of stating that xen_suspend calls syscore_suspend from xen_suspend
> > So, if these syscore ops gets called  during xen_suspend do not do anything. Check if the mode is in xen suspend
> > and return from there. These syscore_ops are specifically for domU hibernation.
> > I must admit, I may have overlooked lack of explanation of some implicit details in the original commit msg.
> >
> >     >  So if the callbacks
> >     > are called from Xen suspend context, return immediately.
> >     >
> >
> >
> >     > +
> >     > +static int xen_syscore_suspend(void)
> >     > +{
> >     > +     struct xen_remove_from_physmap xrfp;
> >     > +     int ret;
> >     > +
> >     > +     /* Xen suspend does similar stuffs in its own logic */
> >     > +     if (xen_suspend_mode_is_xen_suspend())
> >     > +             return 0;
> 
> 
> With your explanation now making this clearer, is this check really
> necessary? From what I see we are in XEN_SUSPEND mode when
> lock_system_sleep() lock is taken, meaning that we can't initialize
> hibernation.
> 
I see. Sounds plausible. I will fix both the code and commit message
for better readability. Thanks for catching this.
> 
> >     > +
> >     > +     xrfp.domid = DOMID_SELF;
> >     > +     xrfp.gpfn = __pa(HYPERVISOR_shared_info) >> PAGE_SHIFT;
> >     > +
> >     > +     ret = HYPERVISOR_memory_op(XENMEM_remove_from_physmap, &xrfp);
> >     > +     if (!ret)
> >     > +             HYPERVISOR_shared_info = &xen_dummy_shared_info;
> >     > +
> >     > +     return ret;
> >     > +}
> >     > +
> >     > +static void xen_syscore_resume(void)
> >     > +{
> >     > +     /* Xen suspend does similar stuffs in its own logic */
> >     > +     if (xen_suspend_mode_is_xen_suspend())
> >     > +             return;
> >     > +
> >     > +     /* No need to setup vcpu_info as it's already moved off */
> >     > +     xen_hvm_map_shared_info();
> >     > +
> >     > +     pvclock_resume();
> >     > +
> >     > +     gnttab_resume();
> >
> >
> >     Do you call gnttab_suspend() in pm suspend path?
> > No, since it does nothing for HVM guests. The unmap_frames is only applicable for PV guests right?
> 
> 
> You should call it nevertheless. It will decide whether or not anything
> needs to be done.
Will fix it in V2.
> 
> 
> -boris
> 
Thanks,
Anchal
> 
