Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80515164D4C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 19:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgBSSEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 13:04:45 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:6594 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbgBSSEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 13:04:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1582135485; x=1613671485;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=3Zqh9Z5ArCKT5eh3kytqNR+atJTyGLoFKV/QsPjClkg=;
  b=oqMj2W+qDZkw2Dp39HVx5C4B1C7VumFPWUfHdx8b4Q7df7y3V3tVG+2u
   DBLkOj4GXqIoKyZ0UDXhKSCjnW+xcjN7H/yH1EKmd0dg2I19n+IFGRLqw
   +eRKjGRs5QUIx/W75ME+xiICZNYLdp0ESbhdmZWprHlMA9Kph9vfqJc+8
   8=;
IronPort-SDR: SWoQO1RFkW7rgd2CL4S62O3VarDPqWQrz58ohCj8J+VHKH9cgFWDywhjXDZn2lMphuLg99bCok
 LxZKOSkF49jw==
X-IronPort-AV: E=Sophos;i="5.70,461,1574121600"; 
   d="scan'208";a="27530192"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 19 Feb 2020 18:04:42 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 170F4A268C;
        Wed, 19 Feb 2020 18:04:40 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 19 Feb 2020 18:04:25 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 19 Feb 2020 18:04:25 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Wed, 19 Feb 2020 18:04:24 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id DFEB5403C0; Wed, 19 Feb 2020 18:04:24 +0000 (UTC)
Date:   Wed, 19 Feb 2020 18:04:24 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <boris.ostrovsky@oracle.com>,
        <jgross@suse.com>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamatam@amazon.com>,
        <sstabellini@kernel.org>, <konrad.wilk@oracle.com>,
        <axboe@kernel.dk>, <davem@davemloft.net>, <rjw@rjwysocki.net>,
        <len.brown@intel.com>, <pavel@ucw.cz>, <peterz@infradead.org>,
        <eduval@amazon.com>, <sblbir@amazon.com>, <anchalag@amazon.com>,
        <xen-devel@lists.xenproject.org>, <vkuznets@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dwmw@amazon.co.uk>, <fllinden@amaozn.com>,
        <benh@kernel.crashing.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <boris.ostrovsky@oracle.com>,
        <jgross@suse.com>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamatam@amazon.com>,
        <sstabellini@kernel.org>, <konrad.wilk@oracle.com>,
        <axboe@kernel.dk>, <davem@davemloft.net>, <rjw@rjwysocki.net>,
        <len.brown@intel.com>, <pavel@ucw.cz>, <peterz@infradead.org>,
        <eduval@amazon.com>, <sblbir@amazon.com>,
        <xen-devel@lists.xenproject.org>, <vkuznets@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dwmw@amazon.co.uk>, <fllinden@amaozn.com>,
        <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH v3 06/12] xen-blkfront: add callbacks for PM suspend
 and hibernation
Message-ID: <20200219180424.GA17584@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1581721799.git.anchalag@amazon.com>
 <890c404c585d7790514527f0c021056a7be6e748.1581721799.git.anchalag@amazon.com>
 <20200217100509.GE4679@Air-de-Roger>
 <20200217230553.GA8100@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200218091611.GN4679@Air-de-Roger>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200218091611.GN4679@Air-de-Roger>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 10:16:11AM +0100, Roger Pau Monné wrote:
> On Mon, Feb 17, 2020 at 11:05:53PM +0000, Anchal Agarwal wrote:
> > On Mon, Feb 17, 2020 at 11:05:09AM +0100, Roger Pau Monné wrote:
> > > On Fri, Feb 14, 2020 at 11:25:34PM +0000, Anchal Agarwal wrote:
> > > > From: Munehisa Kamata <kamatam@amazon.com
> > > > 
> > > > Add freeze, thaw and restore callbacks for PM suspend and hibernation
> > > > support. All frontend drivers that needs to use PM_HIBERNATION/PM_SUSPEND
> > > > events, need to implement these xenbus_driver callbacks.
> > > > The freeze handler stops a block-layer queue and disconnect the
> > > > frontend from the backend while freeing ring_info and associated resources.
> > > > The restore handler re-allocates ring_info and re-connect to the
> > > > backend, so the rest of the kernel can continue to use the block device
> > > > transparently. Also, the handlers are used for both PM suspend and
> > > > hibernation so that we can keep the existing suspend/resume callbacks for
> > > > Xen suspend without modification. Before disconnecting from backend,
> > > > we need to prevent any new IO from being queued and wait for existing
> > > > IO to complete.
> > > 
> > > This is different from Xen (xenstore) initiated suspension, as in that
> > > case Linux doesn't flush the rings or disconnects from the backend.
> > Yes, AFAIK in xen initiated suspension backend takes care of it. 
> 
> No, in Xen initiated suspension backend doesn't take care of flushing
> the rings, the frontend has a shadow copy of the ring contents and it
> re-issues the requests on resume.
> 
Yes, I meant suspension in general where both xenstore and backend knows
system is going under suspension and not flushing of rings. That happens
in frontend when backend indicates that state is closing and so on.
I may have written it in wrong context.
> > > > +static int blkfront_freeze(struct xenbus_device *dev)
> > > > +{
> > > > +	unsigned int i;
> > > > +	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
> > > > +	struct blkfront_ring_info *rinfo;
> > > > +	/* This would be reasonable timeout as used in xenbus_dev_shutdown() */
> > > > +	unsigned int timeout = 5 * HZ;
> > > > +	int err = 0;
> > > > +
> > > > +	info->connected = BLKIF_STATE_FREEZING;
> > > > +
> > > > +	blk_mq_freeze_queue(info->rq);
> > > > +	blk_mq_quiesce_queue(info->rq);
> > > > +
> > > > +	for (i = 0; i < info->nr_rings; i++) {
> > > > +		rinfo = &info->rinfo[i];
> > > > +
> > > > +		gnttab_cancel_free_callback(&rinfo->callback);
> > > > +		flush_work(&rinfo->work);
> > > > +	}
> > > > +
> > > > +	/* Kick the backend to disconnect */
> > > > +	xenbus_switch_state(dev, XenbusStateClosing);
> > > 
> > > Are you sure this is safe?
> > > 
> > In my testing running multiple fio jobs, other test scenarios running
> > a memory loader works fine. I did not came across a scenario that would
> > have failed resume due to blkfront issues unless you can sugest some?
> 
> AFAICT you don't wait for the in-flight requests to be finished, and
> just rely on blkback to finish processing those. I'm not sure all
> blkback implementations out there can guarantee that.
> 
> The approach used by Xen initiated suspension is to re-issue the
> in-flight requests when resuming. I have to admit I don't think this
> is the best approach, but I would like to keep both the Xen and the PM
> initiated suspension using the same logic, and hence I would request
> that you try to re-use the existing resume logic (blkfront_resume).
> 
> > > I don't think you wait for all requests pending on the ring to be
> > > finished by the backend, and hence you might loose requests as the
> > > ones on the ring would not be re-issued by blkfront_restore AFAICT.
> > > 
> > AFAIU, blk_mq_freeze_queue/blk_mq_quiesce_queue should take care of no used
> > request on the shared ring. Also, we I want to pause the queue and flush all
> > the pending requests in the shared ring before disconnecting from backend.
> 
> Oh, so blk_mq_freeze_queue does wait for in-flight requests to be
> finished. I guess it's fine then.
> 
Ok.
> > Quiescing the queue seemed a better option here as we want to make sure ongoing
> > requests dispatches are totally drained.
> > I should accept that some of these notion is borrowed from how nvme freeze/unfreeze 
> > is done although its not apple to apple comparison.
> 
> That's fine, but I would still like to requests that you use the same
> logic (as much as possible) for both the Xen and the PM initiated
> suspension.
> 
> So you either apply this freeze/unfreeze to the Xen suspension (and
> drop the re-issuing of requests on resume) or adapt the same approach
> as the Xen initiated suspension. Keeping two completely different
> approaches to suspension / resume on blkfront is not suitable long
> term.
> 
I agree with you on overhaul of xen suspend/resume wrt blkfront is a good
idea however, IMO that is a work for future and this patch series should 
not be blocked for it. What do you think?
> Thanks, Roger.
> 
Thanks,
Anchal
