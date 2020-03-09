Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9917C17DCBA
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 10:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgCIJyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 05:54:21 -0400
Received: from esa1.hc3370-68.iphmx.com ([216.71.145.142]:26457 "EHLO
        esa1.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgCIJyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 05:54:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1583747657;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=zNNy4OU4z799DFnGrpM43KDZz+dFPqGX2kfMxUq+JC4=;
  b=a2U6IkVKlgzZQeI6bAG58NAgwPUmz/xvCmc2INJPLS9UORxO3QzZDiBG
   KLP7WfyJgOmS66F3vi6G/gqoMZnZKlwHodzzE+yPIIOEdv8D72JoewyEo
   8i6ZnSn/POJvtcsdu5/lpLwucrzK/k9tdP1RtDxpcXKQybT7df0qLASaT
   U=;
Authentication-Results: esa1.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=roger.pau@citrix.com; spf=Pass smtp.mailfrom=roger.pau@citrix.com; spf=None smtp.helo=postmaster@mail.citrix.com
Received-SPF: None (esa1.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  roger.pau@citrix.com) identity=pra; client-ip=162.221.158.21;
  receiver=esa1.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="roger.pau@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa1.hc3370-68.iphmx.com: domain of
  roger.pau@citrix.com designates 162.221.158.21 as permitted
  sender) identity=mailfrom; client-ip=162.221.158.21;
  receiver=esa1.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="roger.pau@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:162.221.158.21 ip4:162.221.156.83
  ip4:168.245.78.127 ~all"
Received-SPF: None (esa1.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@mail.citrix.com) identity=helo;
  client-ip=162.221.158.21; receiver=esa1.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="postmaster@mail.citrix.com";
  x-conformance=sidf_compatible
IronPort-SDR: do3ZdpTCHyvaP5/SysNyQ6OvX1Aj0Ge4f7a/KYeItfaoREnOoclQ+3UyK3UmAERmfHfgoT/FiQ
 LR9MObLUIfhV2BPRhBPXshsMWzuwO3v4tN81Aoi937geQXN+15Jjn0MKQSjxZacs9yopW4nPAZ
 uDUMrTz2AwTvII9JUzZilZZKcERwlF4UumWQAdnHNAvCe+/bSVdDDablLPGbDI7n3on4l9R4+J
 +es1+SHgHi13FosRMxuLOY1+8VoFhR3maY5sz1tdbvfoZ26Su//Y7lr5QmSGj1zs92DuWGF43J
 BJY=
X-SBRS: 2.7
X-MesageID: 13805261
X-Ironport-Server: esa1.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.70,532,1574139600"; 
   d="scan'208";a="13805261"
Date:   Mon, 9 Mar 2020 10:54:07 +0100
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
Message-ID: <20200309095245.GY24458@Air-de-Roger.citrite.net>
References: <cover.1581721799.git.anchalag@amazon.com>
 <890c404c585d7790514527f0c021056a7be6e748.1581721799.git.anchalag@amazon.com>
 <20200221142445.GZ4679@Air-de-Roger>
 <20200306184033.GA25358@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200306184033.GA25358@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
X-ClientProxiedBy: AMSPEX02CAS02.citrite.net (10.69.22.113) To
 AMSPEX02CL01.citrite.net (10.69.22.125)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 06, 2020 at 06:40:33PM +0000, Anchal Agarwal wrote:
> On Fri, Feb 21, 2020 at 03:24:45PM +0100, Roger Pau Monné wrote:
> > On Fri, Feb 14, 2020 at 11:25:34PM +0000, Anchal Agarwal wrote:
> > >  	blkfront_gather_backend_features(info);
> > >  	/* Reset limits changed by blk_mq_update_nr_hw_queues(). */
> > >  	blkif_set_queue_limits(info);
> > > @@ -2046,6 +2063,9 @@ static int blkif_recover(struct blkfront_info *info)
> > >  		kick_pending_request_queues(rinfo);
> > >  	}
> > >  
> > > +	if (frozen)
> > > +		return 0;
> > 
> > I have to admit my memory is fuzzy here, but don't you need to
> > re-queue requests in case the backend has different limits of indirect
> > descriptors per request for example?
> > 
> > Or do we expect that the frontend is always going to be resumed on the
> > same backend, and thus features won't change?
> > 
> So to understand your question better here, AFAIU the  maximum number of indirect 
> grefs is fixed by the backend, but the frontend can issue requests with any 
> number of indirect segments as long as it's less than the number provided by 
> the backend. So by your question you mean this max number of MAX_INDIRECT_SEGMENTS 
> 256 on backend can change ?

Yes, number of indirect descriptors supported by the backend can
change, because you moved to a different backend, or because the
maximum supported by the backend has changed. It's also possible to
resume on a backend that has no indirect descriptors support at all.

> > > @@ -2625,6 +2671,62 @@ static void blkif_release(struct gendisk *disk, fmode_t mode)
> > >  	mutex_unlock(&blkfront_mutex);
> > >  }
> > >  
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
> > 
> > Don't you need to also drain the queue and make sure it's empty?
> > 
> blk_mq_freeze_queue and blk_mq_quiesce_queue should take care of running HW queues synchronously
> and making sure all the ongoing dispatches have finished. Did I understand your question right?

Can you please add some check to that end? (ie: that there are no
pending requests on any queue?)

Thanks, Roger.
