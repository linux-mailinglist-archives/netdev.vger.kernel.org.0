Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFFD160F83
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 11:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgBQKF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 05:05:28 -0500
Received: from esa4.hc3370-68.iphmx.com ([216.71.155.144]:10663 "EHLO
        esa4.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728833AbgBQKF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 05:05:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1581933927;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2gB/QZ7u4q45t/yp2TSnLERU6K4lxysDb+964WivSl4=;
  b=gaJjrAWOl9gH9G9o5vGnVq9seJSv+TnRNG4cNcC0DrwISClwnru+p0eh
   AubGmzsaBfIqsxYdvZo2IB+/Q1fzZS5ZqezLt1HbUPPquz+wzfTlhl8j1
   nkoV4gzr3+TSwo/VkgHiKfqrKBHv5Jha2XJ4FW09gEIzJBJWbvdPjN7R0
   0=;
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
IronPort-SDR: 2b092rFWJXgE74OPGqqRjNgmQSjSJodO8MuU0fMmusZ8vT5zX3uBpug0UoVBfJdPO1oATdAEU9
 O+F05nELxG/as+2DHKBP5vJA7MCOMOBce127FfljLI+GeJi3m5rRwbLiBqpYrAMWfXB9bFzcfd
 quKX7bT7fDofLxaD1cSTHh7deVSnfwxDHDE4ozjmEk6bDse/8GdboK8xdvkMRazujeDUsJegpm
 G0fuzH/E2uDSb/INDIVGdSENM1uNKmBlyq+53vyYhflSU9u1FNGTYSoFUdg5dDdJ6SLslq/bI8
 wsI=
X-SBRS: 2.7
X-MesageID: 13179199
X-Ironport-Server: esa4.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.70,452,1574139600"; 
   d="scan'208";a="13179199"
Date:   Mon, 17 Feb 2020 11:05:09 +0100
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
Message-ID: <20200217100509.GE4679@Air-de-Roger>
References: <cover.1581721799.git.anchalag@amazon.com>
 <890c404c585d7790514527f0c021056a7be6e748.1581721799.git.anchalag@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <890c404c585d7790514527f0c021056a7be6e748.1581721799.git.anchalag@amazon.com>
X-ClientProxiedBy: AMSPEX02CAS02.citrite.net (10.69.22.113) To
 AMSPEX02CL01.citrite.net (10.69.22.125)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 11:25:34PM +0000, Anchal Agarwal wrote:
> From: Munehisa Kamata <kamatam@amazon.com
> 
> Add freeze, thaw and restore callbacks for PM suspend and hibernation
> support. All frontend drivers that needs to use PM_HIBERNATION/PM_SUSPEND
> events, need to implement these xenbus_driver callbacks.
> The freeze handler stops a block-layer queue and disconnect the
> frontend from the backend while freeing ring_info and associated resources.
> The restore handler re-allocates ring_info and re-connect to the
> backend, so the rest of the kernel can continue to use the block device
> transparently. Also, the handlers are used for both PM suspend and
> hibernation so that we can keep the existing suspend/resume callbacks for
> Xen suspend without modification. Before disconnecting from backend,
> we need to prevent any new IO from being queued and wait for existing
> IO to complete.

This is different from Xen (xenstore) initiated suspension, as in that
case Linux doesn't flush the rings or disconnects from the backend.

This is done so that in case suspensions fails the recovery doesn't
need to reconnect the PV devices, and in order to speed up suspension
time (ie: waiting for all queues to be flushed can take time as Linux
supports multiqueue, multipage rings and indirect descriptors), and
the backend could be contended if there's a lot of IO pressure from
guests.

Linux already keeps a shadow of the ring contents, so in-flight
requests can be re-issued after the frontend has reconnected during
resume.

> Freeze/unfreeze of the queues will guarantee that there
> are no requests in use on the shared ring.
> 
> Note:For older backends,if a backend doesn't have commit'12ea729645ace'
> xen/blkback: unmap all persistent grants when frontend gets disconnected,
> the frontend may see massive amount of grant table warning when freeing
> resources.
> [   36.852659] deferring g.e. 0xf9 (pfn 0xffffffffffffffff)
> [   36.855089] xen:grant_table: WARNING:e.g. 0x112 still in use!
> 
> In this case, persistent grants would need to be disabled.
> 
> [Anchal Changelog: Removed timeout/request during blkfront freeze.
> Fixed major part of the code to work with blk-mq]
> Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
> Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
> ---
>  drivers/block/xen-blkfront.c | 119 ++++++++++++++++++++++++++++++++---
>  1 file changed, 112 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 478120233750..d715ed3cb69a 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -47,6 +47,8 @@
>  #include <linux/bitmap.h>
>  #include <linux/list.h>
>  #include <linux/workqueue.h>
> +#include <linux/completion.h>
> +#include <linux/delay.h>
>  
>  #include <xen/xen.h>
>  #include <xen/xenbus.h>
> @@ -79,6 +81,8 @@ enum blkif_state {
>  	BLKIF_STATE_DISCONNECTED,
>  	BLKIF_STATE_CONNECTED,
>  	BLKIF_STATE_SUSPENDED,
> +	BLKIF_STATE_FREEZING,
> +	BLKIF_STATE_FROZEN
>  };
>  
>  struct grant {
> @@ -220,6 +224,7 @@ struct blkfront_info
>  	struct list_head requests;
>  	struct bio_list bio_list;
>  	struct list_head info_list;
> +	struct completion wait_backend_disconnected;
>  };
>  
>  static unsigned int nr_minors;
> @@ -261,6 +266,7 @@ static DEFINE_SPINLOCK(minor_lock);
>  static int blkfront_setup_indirect(struct blkfront_ring_info *rinfo);
>  static void blkfront_gather_backend_features(struct blkfront_info *info);
>  static int negotiate_mq(struct blkfront_info *info);
> +static void __blkif_free(struct blkfront_info *info);
>  
>  static int get_id_from_freelist(struct blkfront_ring_info *rinfo)
>  {
> @@ -995,6 +1001,7 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
>  	info->sector_size = sector_size;
>  	info->physical_sector_size = physical_sector_size;
>  	blkif_set_queue_limits(info);
> +	init_completion(&info->wait_backend_disconnected);
>  
>  	return 0;
>  }
> @@ -1218,6 +1225,8 @@ static void xlvbd_release_gendisk(struct blkfront_info *info)
>  /* Already hold rinfo->ring_lock. */
>  static inline void kick_pending_request_queues_locked(struct blkfront_ring_info *rinfo)
>  {
> +	if (unlikely(rinfo->dev_info->connected == BLKIF_STATE_FREEZING))
> +		return;
>  	if (!RING_FULL(&rinfo->ring))
>  		blk_mq_start_stopped_hw_queues(rinfo->dev_info->rq, true);
>  }
> @@ -1341,8 +1350,6 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
>  
>  static void blkif_free(struct blkfront_info *info, int suspend)
>  {
> -	unsigned int i;
> -
>  	/* Prevent new requests being issued until we fix things up. */
>  	info->connected = suspend ?
>  		BLKIF_STATE_SUSPENDED : BLKIF_STATE_DISCONNECTED;
> @@ -1350,6 +1357,13 @@ static void blkif_free(struct blkfront_info *info, int suspend)
>  	if (info->rq)
>  		blk_mq_stop_hw_queues(info->rq);
>  
> +	__blkif_free(info);
> +}
> +
> +static void __blkif_free(struct blkfront_info *info)
> +{
> +	unsigned int i;
> +
>  	for (i = 0; i < info->nr_rings; i++)
>  		blkif_free_ring(&info->rinfo[i]);
>  
> @@ -1553,8 +1567,10 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
>  	struct blkfront_ring_info *rinfo = (struct blkfront_ring_info *)dev_id;
>  	struct blkfront_info *info = rinfo->dev_info;
>  
> -	if (unlikely(info->connected != BLKIF_STATE_CONNECTED))
> -		return IRQ_HANDLED;
> +	if (unlikely(info->connected != BLKIF_STATE_CONNECTED)) {
> +		if (info->connected != BLKIF_STATE_FREEZING)
> +			return IRQ_HANDLED;
> +	}
>  
>  	spin_lock_irqsave(&rinfo->ring_lock, flags);
>   again:
> @@ -2020,6 +2036,7 @@ static int blkif_recover(struct blkfront_info *info)
>  	struct bio *bio;
>  	unsigned int segs;
>  
> +	bool frozen = info->connected == BLKIF_STATE_FROZEN;
>  	blkfront_gather_backend_features(info);
>  	/* Reset limits changed by blk_mq_update_nr_hw_queues(). */
>  	blkif_set_queue_limits(info);
> @@ -2046,6 +2063,9 @@ static int blkif_recover(struct blkfront_info *info)
>  		kick_pending_request_queues(rinfo);
>  	}
>  
> +	if (frozen)
> +		return 0;
> +
>  	list_for_each_entry_safe(req, n, &info->requests, queuelist) {
>  		/* Requeue pending requests (flush or discard) */
>  		list_del_init(&req->queuelist);
> @@ -2359,6 +2379,7 @@ static void blkfront_connect(struct blkfront_info *info)
>  
>  		return;
>  	case BLKIF_STATE_SUSPENDED:
> +	case BLKIF_STATE_FROZEN:
>  		/*
>  		 * If we are recovering from suspension, we need to wait
>  		 * for the backend to announce it's features before
> @@ -2476,12 +2497,37 @@ static void blkback_changed(struct xenbus_device *dev,
>  		break;
>  
>  	case XenbusStateClosed:
> -		if (dev->state == XenbusStateClosed)
> +		if (dev->state == XenbusStateClosed) {
> +			if (info->connected == BLKIF_STATE_FREEZING) {
> +				__blkif_free(info);
> +				info->connected = BLKIF_STATE_FROZEN;
> +				complete(&info->wait_backend_disconnected);
> +				break;
> +			}
> +
>  			break;
> +		}
> +
> +		/*
> +		 * We may somehow receive backend's Closed again while thawing
> +		 * or restoring and it causes thawing or restoring to fail.
> +		 * Ignore such unexpected state anyway.
> +		 */
> +		if (info->connected == BLKIF_STATE_FROZEN &&
> +				dev->state == XenbusStateInitialised) {
> +			dev_dbg(&dev->dev,
> +					"ignore the backend's Closed state: %s",
> +					dev->nodename);
> +			break;
> +		}
>  		/* fall through */
>  	case XenbusStateClosing:
> -		if (info)
> -			blkfront_closing(info);
> +		if (info) {
> +			if (info->connected == BLKIF_STATE_FREEZING)
> +				xenbus_frontend_closed(dev);
> +			else
> +				blkfront_closing(info);
> +		}
>  		break;
>  	}
>  }
> @@ -2625,6 +2671,62 @@ static void blkif_release(struct gendisk *disk, fmode_t mode)
>  	mutex_unlock(&blkfront_mutex);
>  }
>  
> +static int blkfront_freeze(struct xenbus_device *dev)
> +{
> +	unsigned int i;
> +	struct blkfront_info *info = dev_get_drvdata(&dev->dev);
> +	struct blkfront_ring_info *rinfo;
> +	/* This would be reasonable timeout as used in xenbus_dev_shutdown() */
> +	unsigned int timeout = 5 * HZ;
> +	int err = 0;
> +
> +	info->connected = BLKIF_STATE_FREEZING;
> +
> +	blk_mq_freeze_queue(info->rq);
> +	blk_mq_quiesce_queue(info->rq);
> +
> +	for (i = 0; i < info->nr_rings; i++) {
> +		rinfo = &info->rinfo[i];
> +
> +		gnttab_cancel_free_callback(&rinfo->callback);
> +		flush_work(&rinfo->work);
> +	}
> +
> +	/* Kick the backend to disconnect */
> +	xenbus_switch_state(dev, XenbusStateClosing);

Are you sure this is safe?

I don't think you wait for all requests pending on the ring to be
finished by the backend, and hence you might loose requests as the
ones on the ring would not be re-issued by blkfront_restore AFAICT.

Thanks, Roger.
