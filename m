Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 902A8184D7C
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 18:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgCMRVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 13:21:54 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:44690 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgCMRVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 13:21:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1584120112; x=1615656112;
  h=date:from:to:cc:message-id:references:mime-version:
   content-transfer-encoding:in-reply-to:subject;
  bh=bTuPsH7AF4MczqLCOh4ZEWM4t7cj+3gohQ8SR0U6ZXw=;
  b=jmMDqFmzm+9YbQBvvRNiBZyu7RwggOAuhrmoh+aZWV0rXlndnI5aMUfl
   +n/csb4gO+gAR45HAG9h836XaPznUFmUwRTcqOcH4jrWweGQPsSqu8c2/
   ryrA45btubCNtL2ALgh7MzoBYkme4oULhm8eTDwqGPikxenntFIS9jhvN
   U=;
IronPort-SDR: JW0cZ6rA9C70JpjTu+PtridNwuuUyQx4+YAlmckpbYjwnpZvKgcj3PB0wM5zdrP6sQS5NG8AAW
 DPJzO9ciY+lw==
X-IronPort-AV: E=Sophos;i="5.70,549,1574121600"; 
   d="scan'208";a="31080865"
Subject: Re: [RFC PATCH v3 06/12] xen-blkfront: add callbacks for PM suspend and
 hibernation
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 13 Mar 2020 17:21:48 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 6BED5A24C5;
        Fri, 13 Mar 2020 17:21:41 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 13 Mar 2020 17:21:25 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 13 Mar 2020 17:21:25 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Fri, 13 Mar 2020 17:21:24 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 9ECD140348; Fri, 13 Mar 2020 17:21:24 +0000 (UTC)
Date:   Fri, 13 Mar 2020 17:21:24 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <boris.ostrovsky@oracle.com>,
        <jgross@suse.com>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamatam@amazon.com>,
        <sstabellini@kernel.org>, <konrad.wilk@oracle.com>,
        <roger.pau@citrix.com>, <axboe@kernel.dk>, <davem@davemloft.net>,
        <rjw@rjwysocki.net>, <len.brown@intel.com>, <pavel@ucw.cz>,
        <peterz@infradead.org>, <eduval@amazon.com>, <sblbir@amazon.com>,
        <anchalag@amazon.com>, <xen-devel@lists.xenproject.org>,
        <vkuznets@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dwmw@amazon.co.uk>,
        <fllinden@amaozn.com>, <benh@kernel.crashing.org>
Message-ID: <20200313172124.GB8513@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1581721799.git.anchalag@amazon.com>
 <890c404c585d7790514527f0c021056a7be6e748.1581721799.git.anchalag@amazon.com>
 <20200221142445.GZ4679@Air-de-Roger>
 <20200306184033.GA25358@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200309095245.GY24458@Air-de-Roger.citrite.net>
 <FA688A68-5372-4757-B075-A69A45671CB9@amazon.com>
 <20200312090435.GK24449@Air-de-Roger.citrite.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200312090435.GK24449@Air-de-Roger.citrite.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 10:04:35AM +0100, Roger Pau Monné wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On Wed, Mar 11, 2020 at 10:25:15PM +0000, Agarwal, Anchal wrote:
> > Hi Roger,
> > I am trying to understand your comments on indirect descriptors specially without polluting the mailing list hence emailing you personally.
> 
> IMO it's better to send to the mailing list. The issues or questions
> you have about indirect descriptors can be helpful to others in the
> future. If there's no confidential information please send to the
> list next time.
> 
> Feel free to forward this reply to the list also.
>
Sure no problem at all.
> > Hope that's ok by you.  Please see my response inline.
> >
> >     On Fri, Mar 06, 2020 at 06:40:33PM +0000, Anchal Agarwal wrote:
> >     > On Fri, Feb 21, 2020 at 03:24:45PM +0100, Roger Pau Monné wrote:
> >     > > On Fri, Feb 14, 2020 at 11:25:34PM +0000, Anchal Agarwal wrote:
> >     > > >   blkfront_gather_backend_features(info);
> >     > > >   /* Reset limits changed by blk_mq_update_nr_hw_queues(). */
> >     > > >   blkif_set_queue_limits(info);
> >     > > > @@ -2046,6 +2063,9 @@ static int blkif_recover(struct blkfront_info *info)
> >     > > >           kick_pending_request_queues(rinfo);
> >     > > >   }
> >     > > >
> >     > > > + if (frozen)
> >     > > > +         return 0;
> >     > >
> >     > > I have to admit my memory is fuzzy here, but don't you need to
> >     > > re-queue requests in case the backend has different limits of indirect
> >     > > descriptors per request for example?
> >     > >
> >     > > Or do we expect that the frontend is always going to be resumed on the
> >     > > same backend, and thus features won't change?
> >     > >
> >     > So to understand your question better here, AFAIU the  maximum number of indirect
> >     > grefs is fixed by the backend, but the frontend can issue requests with any
> >     > number of indirect segments as long as it's less than the number provided by
> >     > the backend. So by your question you mean this max number of MAX_INDIRECT_SEGMENTS
> >     > 256 on backend can change ?
> >
> >     Yes, number of indirect descriptors supported by the backend can
> >     change, because you moved to a different backend, or because the
> >     maximum supported by the backend has changed. It's also possible to
> >     resume on a backend that has no indirect descriptors support at all.
> >
> > AFAIU, the code for requeuing the requests is only for xen suspend/resume. These request in the queue are
> > same that gets added to queuelist in blkfront_resume. Also, even if indirect descriptors change on resume,
> > they just need to be broadcasted to frontend and which means we could just mean that a request can process
> > more data.
> 
> Or less data. You could legitimately migrate from a host that has
> indirect descriptors to one without, in which case requests would need
> to be smaller to fit the ring slots.
> 
> > We do setup indirect descriptors on front end on blkif_recover before returning and queue limits are
> > setup accordingly.
> > Am I missing anything here?
> 
> Calling blkif_recover should take care of it AFAICT. As it resets the
> queue limits according to the data announced on xenstore.
> 
> I think I got confused, using blkif_recover should be fine, sorry.
> 
Ok. Thanks for confirming. I will fixup other suggestions in the patch and send
out a v4.
> >
> >     > > > @@ -2625,6 +2671,62 @@ static void blkif_release(struct gendisk *disk, fmode_t mode)
> >     > > >   mutex_unlock(&blkfront_mutex);
> >     > > >  }
> >     > > >
> >     > > > +static int blkfront_freeze(struct xenbus_device *dev)
> >     > > > +{
> >     > > > + unsigned int i;
> >     > > > + struct blkfront_info *info = dev_get_drvdata(&dev->dev);
> >     > > > + struct blkfront_ring_info *rinfo;
> >     > > > + /* This would be reasonable timeout as used in xenbus_dev_shutdown() */
> >     > > > + unsigned int timeout = 5 * HZ;
> >     > > > + int err = 0;
> >     > > > +
> >     > > > + info->connected = BLKIF_STATE_FREEZING;
> >     > > > +
> >     > > > + blk_mq_freeze_queue(info->rq);
> >     > > > + blk_mq_quiesce_queue(info->rq);
> >     > >
> >     > > Don't you need to also drain the queue and make sure it's empty?
> >     > >
> >     > blk_mq_freeze_queue and blk_mq_quiesce_queue should take care of running HW queues synchronously
> >     > and making sure all the ongoing dispatches have finished. Did I understand your question right?
> >
> >     Can you please add some check to that end? (ie: that there are no
> >     pending requests on any queue?)
> >
> > Well a check to see if there are any unconsumed responses could be done.
> > I haven't come across use case in my testing where this failed but maybe there are other
> > setups that may cause issue here.
> 
> Thanks! It's mostly to be on the safe side if we expect the queues and
> rings to be fully drained.
> 
ACK.
> Roger.
Thanks,
Anchal
