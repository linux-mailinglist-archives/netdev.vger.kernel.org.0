Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80796161DB1
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 00:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgBQXGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 18:06:16 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:38951 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgBQXGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 18:06:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581980775; x=1613516775;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=i2HFd1yZvomBJYmaIlswXjk/acyKcvnHu1DS56/tQa4=;
  b=Gknsqlqw8/iPSJvijAbZK/mG/d/yH0hIqTM6Lh5Z73WejTg57qhcKzqH
   ekhP61Nm1gvFObKxalKOHrC7VZxbrAKZpjfyHbnx4sEULNdERhSLwpNFC
   vyfWTMyAC7k0Ip7KKqUhG0kEM+uH2SES1umaUVHn8vkbN47AwRSh0lg5Y
   I=;
IronPort-SDR: j7qMV2pLyqN3pGNWHxsVIYOQNWVF0Jsyb78CKdoIhZPT4IjRF1w0i5bCUpZX27JvuVwg9jBmIa
 eUNUi3dXBEsQ==
X-IronPort-AV: E=Sophos;i="5.70,454,1574121600"; 
   d="scan'208";a="17406450"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 17 Feb 2020 23:06:01 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id 517B3A23D3;
        Mon, 17 Feb 2020 23:05:59 +0000 (UTC)
Received: from EX13D01UWB001.ant.amazon.com (10.43.161.75) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 17 Feb 2020 23:05:53 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13d01UWB001.ant.amazon.com (10.43.161.75) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 17 Feb 2020 23:05:53 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Mon, 17 Feb 2020 23:05:53 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 8382E401B0; Mon, 17 Feb 2020 23:05:53 +0000 (UTC)
Date:   Mon, 17 Feb 2020 23:05:53 +0000
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
Message-ID: <20200217230553.GA8100@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1581721799.git.anchalag@amazon.com>
 <890c404c585d7790514527f0c021056a7be6e748.1581721799.git.anchalag@amazon.com>
 <20200217100509.GE4679@Air-de-Roger>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200217100509.GE4679@Air-de-Roger>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 11:05:09AM +0100, Roger Pau Monné wrote:
> On Fri, Feb 14, 2020 at 11:25:34PM +0000, Anchal Agarwal wrote:
> > From: Munehisa Kamata <kamatam@amazon.com
> > 
> > Add freeze, thaw and restore callbacks for PM suspend and hibernation
> > support. All frontend drivers that needs to use PM_HIBERNATION/PM_SUSPEND
> > events, need to implement these xenbus_driver callbacks.
> > The freeze handler stops a block-layer queue and disconnect the
> > frontend from the backend while freeing ring_info and associated resources.
> > The restore handler re-allocates ring_info and re-connect to the
> > backend, so the rest of the kernel can continue to use the block device
> > transparently. Also, the handlers are used for both PM suspend and
> > hibernation so that we can keep the existing suspend/resume callbacks for
> > Xen suspend without modification. Before disconnecting from backend,
> > we need to prevent any new IO from being queued and wait for existing
> > IO to complete.
> 
> This is different from Xen (xenstore) initiated suspension, as in that
> case Linux doesn't flush the rings or disconnects from the backend.
Yes, AFAIK in xen initiated suspension backend takes care of it. 
> 
> This is done so that in case suspensions fails the recovery doesn't
> need to reconnect the PV devices, and in order to speed up suspension
> time (ie: waiting for all queues to be flushed can take time as Linux
> supports multiqueue, multipage rings and indirect descriptors), and
> the backend could be contended if there's a lot of IO pressure from
> guests.
> 
> Linux already keeps a shadow of the ring contents, so in-flight
> requests can be re-issued after the frontend has reconnected during
> resume.
> 
> > Freeze/unfreeze of the queues will guarantee that there
> > are no requests in use on the shared ring.
> > 
> > Note:For older backends,if a backend doesn't have commit'12ea729645ace'
> > xen/blkback: unmap all persistent grants when frontend gets disconnected,
> > the frontend may see massive amount of grant table warning when freeing
> > resources.
> > [   36.852659] deferring g.e. 0xf9 (pfn 0xffffffffffffffff)
> > [   36.855089] xen:grant_table: WARNING:e.g. 0x112 still in use!
> > 
> > In this case, persistent grants would need to be disabled.
> > 
> > [Anchal Changelog: Removed timeout/request during blkfront freeze.
> > Fixed major part of the code to work with blk-mq]
> > Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
> > Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
> > ---
> >  drivers/block/xen-blkfront.c | 119 ++++++++++++++++++++++++++++++++---
> >  1 file changed, 112 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> > index 478120233750..d715ed3cb69a 100644
> > --- a/drivers/block/xen-blkfront.c
> > +++ b/drivers/block/xen-blkfront.c
> > @@ -47,6 +47,8 @@
> >  #include <linux/bitmap.h>
> >  #include <linux/list.h>
> >  #include <linux/workqueue.h>
> > +#include <linux/completion.h>
> > +#include <linux/delay.h>
> >  
> >  #include <xen/xen.h>
> >  #include <xen/xenbus.h>
> > @@ -79,6 +81,8 @@ enum blkif_state {
> >  	BLKIF_STATE_DISCONNECTED,
> >  	BLKIF_STATE_CONNECTED,
> >  	BLKIF_STATE_SUSPENDED,
> > +	BLKIF_STATE_FREEZING,
> > +	BLKIF_STATE_FROZEN
> >  };
> >  
> >  struct grant {
> > @@ -220,6 +224,7 @@ struct blkfront_info
> >  	struct list_head requests;
> >  	struct bio_list bio_list;
> >  	struct list_head info_list;
> > +	struct completion wait_backend_disconnected;
> >  };
> >  
> >  static unsigned int nr_minors;
> > @@ -261,6 +266,7 @@ static DEFINE_SPINLOCK(minor_lock);
> >  static int blkfront_setup_indirect(struct blkfront_ring_info *rinfo);
> >  static void blkfront_gather_backend_features(struct blkfront_info *info);
> >  static int negotiate_mq(struct blkfront_info *info);
> > +static void __blkif_free(struct blkfront_info *info);
> >  
> >  static int get_id_from_freelist(struct blkfront_ring_info *rinfo)
> >  {
> > @@ -995,6 +1001,7 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
> >  	info->sector_size = sector_size;
> >  	info->physical_sector_size = physical_sector_size;
> >  	blkif_set_queue_limits(info);
> > +	init_completion(&info->wait_backend_disconnected);
> >  
> >  	return 0;
> >  }
> > @@ -1218,6 +1225,8 @@ static void xlvbd_release_gendisk(struct blkfront_info *info)
> >  /* Already hold rinfo->ring_lock. */
> >  static inline void kick_pending_request_queues_locked(struct blkfront_ring_info *rinfo)
> >  {
> > +	if (unlikely(rinfo->dev_info->connected == BLKIF_STATE_FREEZING))
> > +		return;
> >  	if (!RING_FULL(&rinfo->ring))
> >  		blk_mq_start_stopped_hw_queues(rinfo->dev_info->rq, true);
> >  }
> > @@ -1341,8 +1350,6 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
> >  
> >  static void blkif_free(struct blkfront_info *info, int suspend)
> >  {
> > -	unsigned int i;
> > -
> >  	/* Prevent new requests being issued until we fix things up. */
> >  	info->connected = suspend ?
> >  		BLKIF_STATE_SUSPENDED : BLKIF_STATE_DISCONNECTED;
> > @@ -1350,6 +1357,13 @@ static void blkif_free(struct blkfront_info *info, int suspend)
> >  	if (info->rq)
> >  		blk_mq_stop_hw_queues(info->rq);
> >  
> > +	__blkif_free(info);
> > +}
> > +
> > +static void __blkif_free(struct blkfront_info *info)
> > +{
> > +	unsigned int i;
> > +
> >  	for (i = 0; i < info->nr_rings; i++)
> >  		blkif_free_ring(&info->rinfo[i]);
> >  
> > @@ -1553,8 +1567,10 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
> >  	struct blkfront_ring_info *rinfo = (struct blkfront_ring_info *)dev_id;
> >  	struct blkfront_info *info = rinfo->dev_info;
> >  
> > -	if (unlikely(info->connected != BLKIF_STATE_CONNECTED))
> > -		return IRQ_HANDLED;
> > +	if (unlikely(info->connected != BLKIF_STATE_CONNECTED)) {
> > +		if (info->connected != BLKIF_STATE_FREEZING)
> > +			return IRQ_HANDLED;
> > +	}
> >  
> >  	spin_lock_irqsave(&rinfo->ring_lock, flags);
> >   again:
> > @@ -2020,6 +2036,7 @@ static int blkif_recover(struct blkfront_info *info)
> >  	struct bio *bio;
> >  	unsigned int segs;
> >  
> > +	bool frozen = info->connected == BLKIF_STATE_FROZEN;
> >  	blkfront_gather_backend_features(info);
> >  	/* Reset limits changed by blk_mq_update_nr_hw_queues(). */
> >  	blkif_set_queue_limits(info);
> > @@ -2046,6 +2063,9 @@ static int blkif_recover(struct blkfront_info *info)
> >  		kick_pending_request_queues(rinfo);
> >  	}
> >  
> > +	if (frozen)
> > +		return 0;
> > +
> >  	list_for_each_entry_safe(req, n, &info->requests, queuelist) {
> >  		/* Requeue pending requests (flush or discard) */
> >  		list_del_init(&req->queuelist);
> > @@ -2359,6 +2379,7 @@ static void blkfront_connect(struct blkfront_info *info)
> >  
> >  		return;
> >  	case BLKIF_STATE_SUSPENDED:
> > +	case BLKIF_STATE_FROZEN:
> >  		/*
> >  		 * If we are recovering from suspension, we need to wait
> >  		 * for the backend to announce it's features before
> > @@ -2476,12 +2497,37 @@ static void blkback_changed(struct xenbus_device *dev,
> >  		break;
> >  
> >  	case XenbusStateClosed:
> > -		if (dev->state == XenbusStateClosed)
> > +		if (dev->state == XenbusStateClosed) {
> > +			if (info->connected == BLKIF_STATE_FREEZING) {
> > +				__blkif_free(info);
> > +				info->connected = BLKIF_STATE_FROZEN;
> > +				complete(&info->wait_backend_disconnected);
> > +				break;
> > +			}
> > +
> >  			break;
> > +		}
> > +
> > +		/*
> > +		 * We may somehow receive backend's Closed again while thawing
> > +		 * or restoring and it causes thawing or restoring to fail.
> > +		 * Ignore such unexpected state anyway.
> > +		 */
> > +		if (info->connected == BLKIF_STATE_FROZEN &&
> > +				dev->state == XenbusStateInitialised) {
> > +			dev_dbg(&dev->dev,
> > +					"ignore the backend's Closed state: %s",
> > +					dev->nodename);
> > +			break;
> > +		}
> >  		/* fall through */
> >  	case XenbusStateClosing:
> > -		if (info)
> > -			blkfront_closing(info);
> > +		if (info) {
> > +			if (info->connected == BLKIF_STATE_FREEZING)
> > +				xenbus_frontend_closed(dev);
> > +			else
> > +				blkfront_closing(info);
> > +		}
> >  		break;
> >  	}
> >  }
> > @@ -2625,6 +2671,62 @@ static void blkif_release(struct gendisk *disk, fmode_t mode)
> >  	mutex_unlock(&blkfront_mutex);
> >  }
> >  
> > +static int blkfront_freeze(struct xenbus_device *dev)
> > +{
> > +	unsigned int i;
> > +	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
> > +	struct blkfront_ring_info *rinfo;
> > +	/* This would be reasonable timeout as used in xenbus_dev_shutdown() */
> > +	unsigned int timeout = 5 * HZ;
> > +	int err = 0;
> > +
> > +	info->connected = BLKIF_STATE_FREEZING;
> > +
> > +	blk_mq_freeze_queue(info->rq);
> > +	blk_mq_quiesce_queue(info->rq);
> > +
> > +	for (i = 0; i < info->nr_rings; i++) {
> > +		rinfo = &info->rinfo[i];
> > +
> > +		gnttab_cancel_free_callback(&rinfo->callback);
> > +		flush_work(&rinfo->work);
> > +	}
> > +
> > +	/* Kick the backend to disconnect */
> > +	xenbus_switch_state(dev, XenbusStateClosing);
> 
> Are you sure this is safe?
> 
In my testing running multiple fio jobs, other test scenarios running
a memory loader works fine. I did not came across a scenario that would
have failed resume due to blkfront issues unless you can sugest some?
> I don't think you wait for all requests pending on the ring to be
> finished by the backend, and hence you might loose requests as the
> ones on the ring would not be re-issued by blkfront_restore AFAICT.
> 
AFAIU, blk_mq_freeze_queue/blk_mq_quiesce_queue should take care of no used
request on the shared ring. Also, we I want to pause the queue and flush all
the pending requests in the shared ring before disconnecting from backend.
Quiescing the queue seemed a better option here as we want to make sure ongoing
requests dispatches are totally drained.
I should accept that some of these notion is borrowed from how nvme freeze/unfreeze 
is done although its not apple to apple comparison.

Do you have any particular scenario in mind which may cause resume to fail?
> Thanks, Roger.
