Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6101162330
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 10:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgBRJQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 04:16:24 -0500
Received: from esa4.hc3370-68.iphmx.com ([216.71.155.144]:6247 "EHLO
        esa4.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgBRJQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 04:16:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1582017382;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=lcDVb9zXtKxtRtcOkp+nnORggRYgX9o2VvFOkpOp/P8=;
  b=Wcv8Oo1vNyFtzekkkXrdLKefd1xRdv460LmxJby949OKvkMac/Er3JG3
   lTs+CjdkJIO8oOYPmh+FPXH7iqdmUBrTnS/bbAt0WbgBDFgygU9H3toEN
   TRs29hb+u+6WHreqTy9IrLpRoQxg82Gw2ENKMOT5qL5D4R5ZNUZ/izLsb
   w=;
Authentication-Results: esa4.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=roger.pau@citrix.com; spf=Pass smtp.mailfrom=roger.pau@citrix.com; spf=None smtp.helo=postmaster@mail.citrix.com
Received-SPF: None (esa4.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  roger.pau@citrix.com) identity=pra; client-ip=162.221.158.21;
  receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="roger.pau@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa4.hc3370-68.iphmx.com: domain of
  roger.pau@citrix.com designates 162.221.158.21 as permitted
  sender) identity=mailfrom; client-ip=162.221.158.21;
  receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="roger.pau@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:162.221.158.21 ip4:162.221.156.83
  ip4:168.245.78.127 ~all"
Received-SPF: None (esa4.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@mail.citrix.com) identity=helo;
  client-ip=162.221.158.21; receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="postmaster@mail.citrix.com";
  x-conformance=sidf_compatible
IronPort-SDR: +NEaIej/3FoAmfEcfZRKSsrlG2EvLazi8i5c8rEat0w9DZFheqa79Nk6lGtTXdWahQxWJl2DCh
 tlH9OIp4sxxYTLOa3B/zsETTAUK8TdmCfj5QS1nbH7zQdOb38cbTB0gh9TwQ83rCNVxkZpFmoq
 j1LtHDChEp7jQ9ejWC3CN7k9hxaDnckSFEXLd4lOIy3xb5OQT9MQ0pZkm803x4ik86Fj0f3jA3
 liTdQc2+rRln3CHugnKLQ5/73TashOzsfWqyviP0SOWxvTvxXsU6PhJjMAiJRq9l7kT8QkhDY2
 q1o=
X-SBRS: 2.7
X-MesageID: 13228854
X-Ironport-Server: esa4.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.70,456,1574139600"; 
   d="scan'208";a="13228854"
Date:   Tue, 18 Feb 2020 10:16:11 +0100
From:   Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To:     Anchal Agarwal <anchalag@amazon.com>
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
Message-ID: <20200218091611.GN4679@Air-de-Roger>
References: <cover.1581721799.git.anchalag@amazon.com>
 <890c404c585d7790514527f0c021056a7be6e748.1581721799.git.anchalag@amazon.com>
 <20200217100509.GE4679@Air-de-Roger>
 <20200217230553.GA8100@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200217230553.GA8100@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
X-ClientProxiedBy: AMSPEX02CAS01.citrite.net (10.69.22.112) To
 AMSPEX02CL01.citrite.net (10.69.22.125)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 11:05:53PM +0000, Anchal Agarwal wrote:
> On Mon, Feb 17, 2020 at 11:05:09AM +0100, Roger Pau Monné wrote:
> > On Fri, Feb 14, 2020 at 11:25:34PM +0000, Anchal Agarwal wrote:
> > > From: Munehisa Kamata <kamatam@amazon.com
> > > 
> > > Add freeze, thaw and restore callbacks for PM suspend and hibernation
> > > support. All frontend drivers that needs to use PM_HIBERNATION/PM_SUSPEND
> > > events, need to implement these xenbus_driver callbacks.
> > > The freeze handler stops a block-layer queue and disconnect the
> > > frontend from the backend while freeing ring_info and associated resources.
> > > The restore handler re-allocates ring_info and re-connect to the
> > > backend, so the rest of the kernel can continue to use the block device
> > > transparently. Also, the handlers are used for both PM suspend and
> > > hibernation so that we can keep the existing suspend/resume callbacks for
> > > Xen suspend without modification. Before disconnecting from backend,
> > > we need to prevent any new IO from being queued and wait for existing
> > > IO to complete.
> > 
> > This is different from Xen (xenstore) initiated suspension, as in that
> > case Linux doesn't flush the rings or disconnects from the backend.
> Yes, AFAIK in xen initiated suspension backend takes care of it. 

No, in Xen initiated suspension backend doesn't take care of flushing
the rings, the frontend has a shadow copy of the ring contents and it
re-issues the requests on resume.

> > > +static int blkfront_freeze(struct xenbus_device *dev)
> > > +{
> > > +	unsigned int i;
> > > +	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
> > > +	struct blkfront_ring_info *rinfo;
> > > +	/* This would be reasonable timeout as used in xenbus_dev_shutdown() */
> > > +	unsigned int timeout = 5 * HZ;
> > > +	int err = 0;
> > > +
> > > +	info->connected = BLKIF_STATE_FREEZING;
> > > +
> > > +	blk_mq_freeze_queue(info->rq);
> > > +	blk_mq_quiesce_queue(info->rq);
> > > +
> > > +	for (i = 0; i < info->nr_rings; i++) {
> > > +		rinfo = &info->rinfo[i];
> > > +
> > > +		gnttab_cancel_free_callback(&rinfo->callback);
> > > +		flush_work(&rinfo->work);
> > > +	}
> > > +
> > > +	/* Kick the backend to disconnect */
> > > +	xenbus_switch_state(dev, XenbusStateClosing);
> > 
> > Are you sure this is safe?
> > 
> In my testing running multiple fio jobs, other test scenarios running
> a memory loader works fine. I did not came across a scenario that would
> have failed resume due to blkfront issues unless you can sugest some?

AFAICT you don't wait for the in-flight requests to be finished, and
just rely on blkback to finish processing those. I'm not sure all
blkback implementations out there can guarantee that.

The approach used by Xen initiated suspension is to re-issue the
in-flight requests when resuming. I have to admit I don't think this
is the best approach, but I would like to keep both the Xen and the PM
initiated suspension using the same logic, and hence I would request
that you try to re-use the existing resume logic (blkfront_resume).

> > I don't think you wait for all requests pending on the ring to be
> > finished by the backend, and hence you might loose requests as the
> > ones on the ring would not be re-issued by blkfront_restore AFAICT.
> > 
> AFAIU, blk_mq_freeze_queue/blk_mq_quiesce_queue should take care of no used
> request on the shared ring. Also, we I want to pause the queue and flush all
> the pending requests in the shared ring before disconnecting from backend.

Oh, so blk_mq_freeze_queue does wait for in-flight requests to be
finished. I guess it's fine then.

> Quiescing the queue seemed a better option here as we want to make sure ongoing
> requests dispatches are totally drained.
> I should accept that some of these notion is borrowed from how nvme freeze/unfreeze 
> is done although its not apple to apple comparison.

That's fine, but I would still like to requests that you use the same
logic (as much as possible) for both the Xen and the PM initiated
suspension.

So you either apply this freeze/unfreeze to the Xen suspension (and
drop the re-issuing of requests on resume) or adapt the same approach
as the Xen initiated suspension. Keeping two completely different
approaches to suspension / resume on blkfront is not suitable long
term.

Thanks, Roger.
