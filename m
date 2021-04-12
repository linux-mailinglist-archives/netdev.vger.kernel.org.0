Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9812435D20A
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 22:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245733AbhDLU3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 16:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243924AbhDLU3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 16:29:41 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03215C061574;
        Mon, 12 Apr 2021 13:29:22 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id r9so22412386ejj.3;
        Mon, 12 Apr 2021 13:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4pJyfdybPMHd89G31o/NzOtl8z5qsgSTEe0nD78YwVE=;
        b=QrMeWScaJ+5+XiQn2F5WEIjP4zleOdiNyXmCwpEqVorsSUvAeAW04gk8si1PYJ+Gcs
         qxkXmkluD45qFB05IIISsoSOPVLqtsMHI5zrQHqCvqlT1usW2Kqxnw6o54SMlC9d14qf
         lx8uYwzHMYJeLqX3E6/tG8rNvJI3n3rBMLEVicHRhtaLCLT2aXWj6van9AdauQzXF+mG
         jVK368cQod9oG676slsFTODtQASyxPX+6q82BwYwfieT0y69a4J5vxOWrLaLEtYuPXgG
         c5ZVytrTlibaA/4bXigjkFFMTPYmPiB4D754w0Ju6NxDp5rruiUsBEG6FmBd5EQoYpRd
         SOsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4pJyfdybPMHd89G31o/NzOtl8z5qsgSTEe0nD78YwVE=;
        b=so1UxRUsE7UGblAxUnRPkTYK7x+iLYh4KlYSTjQ2QZFtjYD6XjwV3swqwXZNmTwh3w
         xh3PW2fwVAXIpAgfUXKi8jx94IYQn6epKLC4GjR0KyLyNAZKCp6Dz6n9a1UjN63PmfNu
         h2SJpFAlWMzbwDtwOIeVHngLtnIJd9FpWvbn6mBccNZnYdyB/XISgEpTZYLz4FpiUVR+
         hlVPaCOnRFRiKeouSyy6vgj99n0Kw2pPmnS9U1I6SvYOkSUcK8uN3VUi/XS7vv3RKDL4
         bO3ZOS3ZWEcvCmHgtBhamcmkWKfSsuaAFwK0LLTl7v0TaLOMosnvX2fLN0vroZbQR+bv
         Eflw==
X-Gm-Message-State: AOAM5309inABMumyHMpA9m7HdrHh1ENNOilM5a1Fx2ssDhIulvPLnnML
        ZdCWi5qsapt+VOGOLVZeu18=
X-Google-Smtp-Source: ABdhPJxC0Rdz4JMM+Q68yWZ3zABKh005ILncpz9wJdnFUD3aoubXlK0h6aiLAqY+xqHHXRjbGwepHw==
X-Received: by 2002:a17:907:2bd7:: with SMTP id gv23mr29227833ejc.351.1618259360324;
        Mon, 12 Apr 2021 13:29:20 -0700 (PDT)
Received: from anparri (host-95-232-15-7.retail.telecomitalia.it. [95.232.15.7])
        by smtp.gmail.com with ESMTPSA id cw11sm6826131ejc.67.2021.04.12.13.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 13:29:19 -0700 (PDT)
Date:   Mon, 12 Apr 2021 22:29:12 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH hyperv-next] scsi: storvsc: Use blk_mq_unique_tag()
 to generate requestIDs
Message-ID: <20210412202912.GA20105@anparri>
References: <20210408161315.341888-1-parri.andrea@gmail.com>
 <MWHPR21MB15934EAD302E27983E891CF2D7739@MWHPR21MB1593.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR21MB15934EAD302E27983E891CF2D7739@MWHPR21MB1593.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 03:38:14PM +0000, Michael Kelley wrote:
> From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Thursday, April 8, 2021 9:13 AM
> > 
> > Use blk_mq_unique_tag() to generate requestIDs for StorVSC, avoiding
> > all issues with allocating enough entries in the VMbus requestor.
> 
> This looks good to me!  I'm glad to see that the idea worked without
> too much complexity.
> 
> See a few comments inline below.

Thank you for these suggestions; I've tried to implement them, cf. the
diff at the bottom of this email (on top of this RFC, plus 'change the
storvsc callbacks to 'static'').  I like the result, however this does
not work well yet: I am getting 'Incorrect transaction id' messages at
boot time with this diff; I'll dig more tomorrow... hints are welcome!

  Andrea

> 
> > 
> > Suggested-by: Michael Kelley <mikelley@microsoft.com>
> > Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> > ---
> >  drivers/hv/channel.c              | 14 +++---
> >  drivers/hv/ring_buffer.c          | 12 ++---
> >  drivers/net/hyperv/netvsc.c       |  8 ++--
> >  drivers/net/hyperv/rndis_filter.c |  2 +
> >  drivers/scsi/storvsc_drv.c        | 73 ++++++++++++++++++++++++++-----
> >  include/linux/hyperv.h            | 13 +++++-
> >  6 files changed, 92 insertions(+), 30 deletions(-)
> > 
> > diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> > index db30be8f9ccea..f78e02ace51e8 100644
> > --- a/drivers/hv/channel.c
> > +++ b/drivers/hv/channel.c
> > @@ -1121,15 +1121,14 @@ EXPORT_SYMBOL_GPL(vmbus_recvpacket_raw);
> >   * vmbus_next_request_id - Returns a new request id. It is also
> >   * the index at which the guest memory address is stored.
> >   * Uses a spin lock to avoid race conditions.
> > - * @rqstor: Pointer to the requestor struct
> > + * @channel: Pointer to the VMbus channel struct
> >   * @rqst_add: Guest memory address to be stored in the array
> >   */
> > -u64 vmbus_next_request_id(struct vmbus_requestor *rqstor, u64 rqst_addr)
> > +u64 vmbus_next_request_id(struct vmbus_channel *channel, u64 rqst_addr)
> >  {
> > +	struct vmbus_requestor *rqstor = &channel->requestor;
> >  	unsigned long flags;
> >  	u64 current_id;
> > -	const struct vmbus_channel *channel =
> > -		container_of(rqstor, const struct vmbus_channel, requestor);
> > 
> >  	/* Check rqstor has been initialized */
> >  	if (!channel->rqstor_size)
> > @@ -1163,16 +1162,15 @@ EXPORT_SYMBOL_GPL(vmbus_next_request_id);
> >  /*
> >   * vmbus_request_addr - Returns the memory address stored at @trans_id
> >   * in @rqstor. Uses a spin lock to avoid race conditions.
> > - * @rqstor: Pointer to the requestor struct
> > + * @channel: Pointer to the VMbus channel struct
> >   * @trans_id: Request id sent back from Hyper-V. Becomes the requestor's
> >   * next request id.
> >   */
> > -u64 vmbus_request_addr(struct vmbus_requestor *rqstor, u64 trans_id)
> > +u64 vmbus_request_addr(struct vmbus_channel *channel, u64 trans_id)
> >  {
> > +	struct vmbus_requestor *rqstor = &channel->requestor;
> >  	unsigned long flags;
> >  	u64 req_addr;
> > -	const struct vmbus_channel *channel =
> > -		container_of(rqstor, const struct vmbus_channel, requestor);
> > 
> >  	/* Check rqstor has been initialized */
> >  	if (!channel->rqstor_size)
> > diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
> > index ecd82ebfd5bc4..46d8e038e4ee1 100644
> > --- a/drivers/hv/ring_buffer.c
> > +++ b/drivers/hv/ring_buffer.c
> > @@ -310,10 +310,12 @@ int hv_ringbuffer_write(struct vmbus_channel *channel,
> >  	 */
> > 
> >  	if (desc->flags == VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED) {
> > -		rqst_id = vmbus_next_request_id(&channel->requestor, requestid);
> > -		if (rqst_id == VMBUS_RQST_ERROR) {
> > -			spin_unlock_irqrestore(&outring_info->ring_lock, flags);
> > -			return -EAGAIN;
> > +		if (channel->next_request_id_callback != NULL) {
> > +			rqst_id = channel->next_request_id_callback(channel, requestid);
> > +			if (rqst_id == VMBUS_RQST_ERROR) {
> > +				spin_unlock_irqrestore(&outring_info->ring_lock, flags);
> > +				return -EAGAIN;
> > +			}
> >  		}
> >  	}
> >  	desc = hv_get_ring_buffer(outring_info) + old_write;
> > @@ -341,7 +343,7 @@ int hv_ringbuffer_write(struct vmbus_channel *channel,
> >  	if (channel->rescind) {
> >  		if (rqst_id != VMBUS_NO_RQSTOR) {
> >  			/* Reclaim request ID to avoid leak of IDs */
> > -			vmbus_request_addr(&channel->requestor, rqst_id);
> > +			channel->request_addr_callback(channel, rqst_id);
> >  		}
> >  		return -ENODEV;
> >  	}
> > diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> > index c64cc7639c39c..1a221ce2d6fdc 100644
> > --- a/drivers/net/hyperv/netvsc.c
> > +++ b/drivers/net/hyperv/netvsc.c
> > @@ -730,7 +730,7 @@ static void netvsc_send_tx_complete(struct net_device *ndev,
> >  	int queue_sends;
> >  	u64 cmd_rqst;
> > 
> > -	cmd_rqst = vmbus_request_addr(&channel->requestor, (u64)desc->trans_id);
> > +	cmd_rqst = channel->request_addr_callback(channel, (u64)desc->trans_id);
> >  	if (cmd_rqst == VMBUS_RQST_ERROR) {
> >  		netdev_err(ndev, "Incorrect transaction id\n");
> >  		return;
> > @@ -790,8 +790,8 @@ static void netvsc_send_completion(struct net_device *ndev,
> > 
> >  	/* First check if this is a VMBUS completion without data payload */
> >  	if (!msglen) {
> > -		cmd_rqst = vmbus_request_addr(&incoming_channel->requestor,
> > -					      (u64)desc->trans_id);
> > +		cmd_rqst = incoming_channel->request_addr_callback(incoming_channel,
> > +								   (u64)desc->trans_id);
> >  		if (cmd_rqst == VMBUS_RQST_ERROR) {
> >  			netdev_err(ndev, "Invalid transaction id\n");
> >  			return;
> > @@ -1602,6 +1602,8 @@ struct netvsc_device *netvsc_device_add(struct hv_device
> > *device,
> >  		       netvsc_poll, NAPI_POLL_WEIGHT);
> > 
> >  	/* Open the channel */
> > +	device->channel->next_request_id_callback = vmbus_next_request_id;
> > +	device->channel->request_addr_callback = vmbus_request_addr;
> >  	device->channel->rqstor_size = netvsc_rqstor_size(netvsc_ring_bytes);
> >  	ret = vmbus_open(device->channel, netvsc_ring_bytes,
> >  			 netvsc_ring_bytes,  NULL, 0,
> > diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
> > index 123cc9d25f5ed..ebf34bf3f9075 100644
> > --- a/drivers/net/hyperv/rndis_filter.c
> > +++ b/drivers/net/hyperv/rndis_filter.c
> > @@ -1259,6 +1259,8 @@ static void netvsc_sc_open(struct vmbus_channel *new_sc)
> >  	/* Set the channel before opening.*/
> >  	nvchan->channel = new_sc;
> > 
> > +	new_sc->next_request_id_callback = vmbus_next_request_id;
> > +	new_sc->request_addr_callback = vmbus_request_addr;
> >  	new_sc->rqstor_size = netvsc_rqstor_size(netvsc_ring_bytes);
> >  	ret = vmbus_open(new_sc, netvsc_ring_bytes,
> >  			 netvsc_ring_bytes, NULL, 0,
> > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > index 6bc5453cea8a7..1c05fabc06b04 100644
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -684,6 +684,62 @@ static void storvsc_change_target_cpu(struct vmbus_channel
> > *channel, u32 old,
> >  	spin_unlock_irqrestore(&stor_device->lock, flags);
> >  }
> > 
> > +u64 storvsc_next_request_id(struct vmbus_channel *channel, u64 rqst_addr)
> > +{
> > +	struct storvsc_cmd_request *request =
> > +		(struct storvsc_cmd_request *)(unsigned long)rqst_addr;
> > +	struct storvsc_device *stor_device;
> > +	struct hv_device *device;
> > +
> > +	device = (channel->primary_channel != NULL) ?
> > +		channel->primary_channel->device_obj : channel->device_obj;
> > +	if (device == NULL)
> > +		return VMBUS_RQST_ERROR;
> > +
> > +	stor_device = get_out_stor_device(device);
> > +	if (stor_device == NULL)
> > +		return VMBUS_RQST_ERROR;
> > +
> > +	if (request == &stor_device->init_request)
> > +		return VMBUS_RQST_INIT;
> > +	if (request == &stor_device->reset_request)
> > +		return VMBUS_RQST_RESET;
> 
> Having to get the device and then the stor_device in order to detect the
> init_request and reset_request special cases is unfortunate.  So here's
> an idea:  The init_request and reset_request are used in a limited number
> of specific places in the storvsc driver, and there are unique invocations
> of vmbus_sendpacket() in those places.  So rather than pass the address
> of the request as the requestID parameter to vmbus_sendpacket(), pass
> the sentinel value VMBUS_RQST_INIT or VMBUS_RQST_RESET.  Then this
> code can just detect those sentinel values as the rqst_addr input
> parameter, and return them.
> 
> > +
> > +	return blk_mq_unique_tag(request->cmd->request);
> > +}
> > +
> > +u64 storvsc_request_addr(struct vmbus_channel *channel, u64 rqst_id)
> > +{
> > +	struct storvsc_cmd_request *request;
> > +	struct storvsc_device *stor_device;
> > +	struct hv_device *device;
> > +	struct Scsi_Host *shost;
> > +	struct scsi_cmnd *scmnd;
> > +
> > +	device = (channel->primary_channel != NULL) ?
> > +		channel->primary_channel->device_obj : channel->device_obj;
> > +	if (device == NULL)
> > +		return VMBUS_RQST_ERROR;
> > +
> > +	stor_device = get_out_stor_device(device);
> > +	if (stor_device == NULL)
> > +		return VMBUS_RQST_ERROR;
> > +
> > +	if (rqst_id == VMBUS_RQST_INIT)
> > +		return (unsigned long)&stor_device->init_request;
> > +	if (rqst_id == VMBUS_RQST_RESET)
> > +		return (unsigned long)&stor_device->reset_request;
> 
> Unfortunately, the same simplification doesn't work here.  And you need
> stor_device anyway to get the scsi_host.
> 
> > +
> > +	shost = stor_device->host;
> > +
> > +	scmnd = scsi_host_find_tag(shost, rqst_id);
> > +	if (scmnd == NULL)
> > +		return VMBUS_RQST_ERROR;
> > +
> > +	request = (struct storvsc_cmd_request *)(unsigned long)scsi_cmd_priv(scmnd);
> > +	return (unsigned long)request;
> 
> The casts in the above two lines seem unnecessarily complex.  'request' is never
> used as a pointer.  So couldn't the last two lines just be:
> 
> 	return (unsigned long)scsi_cmd_priv(scmnd);
> 
> > +}
> > +
> >  static void handle_sc_creation(struct vmbus_channel *new_sc)
> >  {
> >  	struct hv_device *device = new_sc->primary_channel->device_obj;
> > @@ -698,11 +754,8 @@ static void handle_sc_creation(struct vmbus_channel *new_sc)
> > 
> >  	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
> > 
> > -	/*
> > -	 * The size of vmbus_requestor is an upper bound on the number of requests
> > -	 * that can be in-progress at any one time across all channels.
> > -	 */
> > -	new_sc->rqstor_size = scsi_driver.can_queue;
> > +	new_sc->next_request_id_callback = storvsc_next_request_id;
> > +	new_sc->request_addr_callback = storvsc_request_addr;
> > 
> >  	ret = vmbus_open(new_sc,
> >  			 storvsc_ringbuffer_size,
> > @@ -1255,8 +1308,7 @@ static void storvsc_on_channel_callback(void *context)
> >  		struct storvsc_cmd_request *request;
> >  		u64 cmd_rqst;
> > 
> > -		cmd_rqst = vmbus_request_addr(&channel->requestor,
> > -					      desc->trans_id);
> > +		cmd_rqst = channel->request_addr_callback(channel, desc->trans_id);
> 
> Here's another thought:  You don't really need to set the channel request_addr_callback
> function and then indirect through it here.  You know the specific function that storvsc
> is using, so could call it directly.  The other reason to set request_addr_callback is so
> that at the end of hv_ringbuffer_write() you can reclaim an allocated requestID if the
> rescind flag is set.  But there's nothing allocated that needs to be reclaimed in the storvsc
> case, so leaving request_addr_callback as NULL is OK (but hv_ringbuffer_write would
> have to check for the NULL).
> 
> Then if you do that, the logic in storvsc_request_addr() can effectively go inline in
> here.  And that logic can take advantage of the fact that stor_device is already determined
> outside the foreach_vmbus_pkt() loop.  The scsi_host could be calculated outside the loop
> as well, leaving the detection of init_request and reset_request, and the call to
> scsi_host_find_tag() as the only things to do.
> 
> This approach is a bit asymmetrical, but it would save some processing in this interrupt
> handling code.   So something to consider.
> 
> >  		if (cmd_rqst == VMBUS_RQST_ERROR) {
> >  			dev_err(&device->device,
> >  				"Incorrect transaction id\n");
> > @@ -1290,11 +1342,8 @@ static int storvsc_connect_to_vsp(struct hv_device *device, u32
> > ring_size,
> > 
> >  	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
> > 
> > -	/*
> > -	 * The size of vmbus_requestor is an upper bound on the number of requests
> > -	 * that can be in-progress at any one time across all channels.
> > -	 */
> > -	device->channel->rqstor_size = scsi_driver.can_queue;
> > +	device->channel->next_request_id_callback = storvsc_next_request_id;
> > +	device->channel->request_addr_callback = storvsc_request_addr;
> > 
> >  	ret = vmbus_open(device->channel,
> >  			 ring_size,
> > diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> > index 2c18c8e768efe..5692ffa60e022 100644
> > --- a/include/linux/hyperv.h
> > +++ b/include/linux/hyperv.h
> > @@ -779,7 +779,11 @@ struct vmbus_requestor {
> > 
> >  #define VMBUS_NO_RQSTOR U64_MAX
> >  #define VMBUS_RQST_ERROR (U64_MAX - 1)
> > +/* NetVSC-specific */
> 
> It is netvsc specific at the moment.  But if we harden other
> drivers, they are likely to use the same generic requestID
> allocator, and hence need the same sentinel value.
> 
> >  #define VMBUS_RQST_ID_NO_RESPONSE (U64_MAX - 2)
> > +/* StorVSC-specific */
> > +#define VMBUS_RQST_INIT (U64_MAX - 2)
> > +#define VMBUS_RQST_RESET (U64_MAX - 3)
> > 
> >  struct vmbus_device {
> >  	u16  dev_type;
> > @@ -1007,13 +1011,18 @@ struct vmbus_channel {
> >  	u32 fuzz_testing_interrupt_delay;
> >  	u32 fuzz_testing_message_delay;
> > 
> > +	/* callback to generate a request ID from a request address */
> > +	u64 (*next_request_id_callback)(struct vmbus_channel *channel, u64 rqst_addr);
> > +	/* callback to retrieve a request address from a request ID */
> > +	u64 (*request_addr_callback)(struct vmbus_channel *channel, u64 rqst_id);
> > +
> >  	/* request/transaction ids for VMBus */
> >  	struct vmbus_requestor requestor;
> >  	u32 rqstor_size;
> >  };
> > 
> > -u64 vmbus_next_request_id(struct vmbus_requestor *rqstor, u64 rqst_addr);
> > -u64 vmbus_request_addr(struct vmbus_requestor *rqstor, u64 trans_id);
> > +u64 vmbus_next_request_id(struct vmbus_channel *channel, u64 rqst_addr);
> > +u64 vmbus_request_addr(struct vmbus_channel *channel, u64 trans_id);
> > 
> >  static inline bool is_hvsock_channel(const struct vmbus_channel *c)
> >  {
> > --
> > 2.25.1
> 

diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 46d8e038e4ee1..2bf57677272b5 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -343,7 +343,8 @@ int hv_ringbuffer_write(struct vmbus_channel *channel,
 	if (channel->rescind) {
 		if (rqst_id != VMBUS_NO_RQSTOR) {
 			/* Reclaim request ID to avoid leak of IDs */
-			channel->request_addr_callback(channel, rqst_id);
+			if (channel->request_addr_callback != NULL)
+				channel->request_addr_callback(channel, rqst_id);
 		}
 		return -ENODEV;
 	}
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 1aa94229b6558..8548834e48624 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -688,58 +688,15 @@ static u64 storvsc_next_request_id(struct vmbus_channel *channel, u64 rqst_addr)
 {
 	struct storvsc_cmd_request *request =
 		(struct storvsc_cmd_request *)(unsigned long)rqst_addr;
-	struct storvsc_device *stor_device;
-	struct hv_device *device;
-
-	device = (channel->primary_channel != NULL) ?
-		channel->primary_channel->device_obj : channel->device_obj;
-	if (device == NULL)
-		return VMBUS_RQST_ERROR;
-
-	stor_device = get_out_stor_device(device);
-	if (stor_device == NULL)
-		return VMBUS_RQST_ERROR;
 
-	if (request == &stor_device->init_request)
+	if (rqst_addr == VMBUS_RQST_INIT)
 		return VMBUS_RQST_INIT;
-	if (request == &stor_device->reset_request)
+	if (rqst_addr == VMBUS_RQST_RESET)
 		return VMBUS_RQST_RESET;
 
 	return blk_mq_unique_tag(request->cmd->request);
 }
 
-static u64 storvsc_request_addr(struct vmbus_channel *channel, u64 rqst_id)
-{
-	struct storvsc_cmd_request *request;
-	struct storvsc_device *stor_device;
-	struct hv_device *device;
-	struct Scsi_Host *shost;
-	struct scsi_cmnd *scmnd;
-
-	device = (channel->primary_channel != NULL) ?
-		channel->primary_channel->device_obj : channel->device_obj;
-	if (device == NULL)
-		return VMBUS_RQST_ERROR;
-
-	stor_device = get_out_stor_device(device);
-	if (stor_device == NULL)
-		return VMBUS_RQST_ERROR;
-
-	if (rqst_id == VMBUS_RQST_INIT)
-		return (unsigned long)&stor_device->init_request;
-	if (rqst_id == VMBUS_RQST_RESET)
-		return (unsigned long)&stor_device->reset_request;
-
-	shost = stor_device->host;
-
-	scmnd = scsi_host_find_tag(shost, rqst_id);
-	if (scmnd == NULL)
-		return VMBUS_RQST_ERROR;
-
-	request = (struct storvsc_cmd_request *)(unsigned long)scsi_cmd_priv(scmnd);
-	return (unsigned long)request;
-}
-
 static void handle_sc_creation(struct vmbus_channel *new_sc)
 {
 	struct hv_device *device = new_sc->primary_channel->device_obj;
@@ -755,7 +712,6 @@ static void handle_sc_creation(struct vmbus_channel *new_sc)
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 
 	new_sc->next_request_id_callback = storvsc_next_request_id;
-	new_sc->request_addr_callback = storvsc_request_addr;
 
 	ret = vmbus_open(new_sc,
 			 storvsc_ringbuffer_size,
@@ -822,7 +778,7 @@ static void  handle_multichannel_storage(struct hv_device *device, int max_chns)
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       (sizeof(struct vstor_packet) -
 			       stor_device->vmscsi_size_delta),
-			       (unsigned long)request,
+			       VMBUS_RQST_INIT,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 
@@ -891,7 +847,7 @@ static int storvsc_execute_vstor_op(struct hv_device *device,
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       (sizeof(struct vstor_packet) -
 			       stor_device->vmscsi_size_delta),
-			       (unsigned long)request,
+			       VMBUS_RQST_INIT,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0)
@@ -1293,6 +1249,7 @@ static void storvsc_on_channel_callback(void *context)
 	const struct vmpacket_descriptor *desc;
 	struct hv_device *device;
 	struct storvsc_device *stor_device;
+	struct Scsi_Host *shost;
 
 	if (channel->primary_channel != NULL)
 		device = channel->primary_channel->device_obj;
@@ -1303,19 +1260,12 @@ static void storvsc_on_channel_callback(void *context)
 	if (!stor_device)
 		return;
 
+	shost = stor_device->host;
+
 	foreach_vmbus_pkt(desc, channel) {
 		void *packet = hv_pkt_data(desc);
 		struct storvsc_cmd_request *request;
-		u64 cmd_rqst;
-
-		cmd_rqst = channel->request_addr_callback(channel, desc->trans_id);
-		if (cmd_rqst == VMBUS_RQST_ERROR) {
-			dev_err(&device->device,
-				"Incorrect transaction id\n");
-			continue;
-		}
-
-		request = (struct storvsc_cmd_request *)(unsigned long)cmd_rqst;
+		u64 rqst_id = desc->trans_id;
 
 		if (hv_pkt_datalen(desc) < sizeof(struct vstor_packet) -
 				stor_device->vmscsi_size_delta) {
@@ -1323,14 +1273,26 @@ static void storvsc_on_channel_callback(void *context)
 			continue;
 		}
 
-		if (request == &stor_device->init_request ||
-		    request == &stor_device->reset_request) {
-			memcpy(&request->vstor_packet, packet,
-			       (sizeof(struct vstor_packet) - stor_device->vmscsi_size_delta));
-			complete(&request->wait_event);
+		if (rqst_id == VMBUS_RQST_INIT) {
+			request = &stor_device->init_request;
+		} else if (rqst_id == VMBUS_RQST_RESET) {
+			request = &stor_device->reset_request;
 		} else {
+			struct scsi_cmnd *scmnd = scsi_host_find_tag(shost, rqst_id);
+
+			if (scmnd == NULL) {
+				dev_err(&device->device, "Incorrect transaction id\n");
+				continue;
+			}
+
+			request = (struct storvsc_cmd_request *)scsi_cmd_priv(scmnd);
 			storvsc_on_receive(stor_device, packet, request);
+			return;
 		}
+
+		memcpy(&request->vstor_packet, packet,
+		       (sizeof(struct vstor_packet) - stor_device->vmscsi_size_delta));
+		complete(&request->wait_event);
 	}
 }
 
@@ -1343,7 +1305,6 @@ static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size,
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 
 	device->channel->next_request_id_callback = storvsc_next_request_id;
-	device->channel->request_addr_callback = storvsc_request_addr;
 
 	ret = vmbus_open(device->channel,
 			 ring_size,
@@ -1669,7 +1630,7 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       (sizeof(struct vstor_packet) -
 				stor_device->vmscsi_size_delta),
-			       (unsigned long)&stor_device->reset_request,
+			       VMBUS_RQST_RESET,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0)
