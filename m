Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D77C517ECB
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 09:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbiECH0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 03:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbiECH0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 03:26:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C38F6393D8
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 00:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651562583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q8KaKGiEboaa46WqliPoS0Bn6xozlQun9n0DuD3/sbc=;
        b=T0CoIIb89d1KRwhXmuWiH+lx1s77rIj/vvbBYPLzVxW2NWJXTu0ZBVtfs+AQFWDvugpWuS
        WHj6AzTjIa8Ouw2FHNXmkqY8auh+3RpiuUNdAN1M8t9TwNrn+11T/y3ugL8aXRJqgyFCvz
        Bl8nEKtaIGaRQm1cWaEiZqlE+CPQhIo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-3BmdipyFOdOPqS9VHEwiyw-1; Tue, 03 May 2022 03:23:00 -0400
X-MC-Unique: 3BmdipyFOdOPqS9VHEwiyw-1
Received: by mail-wm1-f70.google.com with SMTP id q6-20020a1cf306000000b0038c5726365aso400787wmq.3
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 00:23:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Q8KaKGiEboaa46WqliPoS0Bn6xozlQun9n0DuD3/sbc=;
        b=myVPCb6iZLuOYXE+cckPKlMaYdMp9XrhY3FyLNoKT4TMyCBFCerc6JjIl7Bn6Z5sJr
         XQeUzJo95v38Qugv4rDBU33pVNBzh7Vgtgksvj5ah/7qzVZzdK5bJnIYtlxvtdREfNTh
         yF3qK15/aTXH7rkYokoYjRQlgnwXorrdXgiz6IUfojiBBeOEwkoqQEJ9/ye5zl2KI9Br
         PEtNIxolAxICr+LsHyGQfo5ekdli8xIGFOBLFKecvA1pcnU8Mn46O+dp6b4aBQ/DpvBc
         CDybIkztbE4jEPOAtJKT8pwleWL/bpPgNWqDsfZZRb7f8y1lYHZ2tbT6dKonWTgkrHwi
         JFzw==
X-Gm-Message-State: AOAM530fIpjh09Z/6rNDDExFK2NL5WshnslqDDz9vBvaIrtaacNVaV5W
        WouTJpHLizVypub6a2L1lmSUuioKHTPXgPZJToJZVBhnDbbjpAF1jSzmJFuWTA4TU5efu8KiqE8
        ASidPwQPYyOs/1rC1
X-Received: by 2002:a1c:19c3:0:b0:392:9cef:e32b with SMTP id 186-20020a1c19c3000000b003929cefe32bmr2128415wmz.116.1651562579723;
        Tue, 03 May 2022 00:22:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrOLHpM/Yh1TjiW8k5HZNF0/XDRI8jEZZE7apZOv7rNh03JFnWtc+EZNgpSuMITn7g7/ycRg==
X-Received: by 2002:a1c:19c3:0:b0:392:9cef:e32b with SMTP id 186-20020a1c19c3000000b003929cefe32bmr2128400wmz.116.1651562579441;
        Tue, 03 May 2022 00:22:59 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-66.dyn.eolo.it. [146.241.115.66])
        by smtp.gmail.com with ESMTPSA id d12-20020adfa40c000000b0020c5253d924sm8528009wra.112.2022.05.03.00.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 00:22:59 -0700 (PDT)
Message-ID: <0497ce2acd2a1b1745962fe266c56f547af1189d.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] net: macb: use NAPI for TX completion path
From:   Paolo Abeni <pabeni@redhat.com>
To:     Robert Hancock <robert.hancock@calian.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "tomas.melin@vaisala.com" <tomas.melin@vaisala.com>
Date:   Tue, 03 May 2022 09:22:57 +0200
In-Reply-To: <555eee6a7f6661b12de7bd5373e7835a0dc43b65.camel@calian.com>
References: <20220429223122.3642255-1-robert.hancock@calian.com>
         <20220429223122.3642255-3-robert.hancock@calian.com>
         <555eee6a7f6661b12de7bd5373e7835a0dc43b65.camel@calian.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-04-29 at 23:09 +0000, Robert Hancock wrote:
> On Fri, 2022-04-29 at 16:31 -0600, Robert Hancock wrote:
> > This driver was using the TX IRQ handler to perform all TX completion
> > tasks. Under heavy TX network load, this can cause significant irqs-off
> > latencies (found to be in the hundreds of microseconds using ftrace).
> > This can cause other issues, such as overrunning serial UART FIFOs when
> > using high baud rates with limited UART FIFO sizes.
> > 
> > Switch to using the NAPI poll handler to perform the TX completion work
> > to get this out of hard IRQ context and avoid the IRQ latency impact.
> > 
> > The TX Used Bit Read interrupt (TXUBR) handling also needs to be moved
> > into the NAPI poll handler to maintain the proper order of operations. A
> > flag is used to notify the poll handler that a UBR condition needs to be
> > handled. The macb_tx_restart handler has had some locking added for global
> > register access, since this could now potentially happen concurrently on
> > different queues.
> > 
> > Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> > ---
> >  drivers/net/ethernet/cadence/macb.h      |   1 +
> >  drivers/net/ethernet/cadence/macb_main.c | 138 +++++++++++++----------
> >  2 files changed, 80 insertions(+), 59 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/cadence/macb.h
> > b/drivers/net/ethernet/cadence/macb.h
> > index f0a7d8396a4a..5355cef95a9b 100644
> > --- a/drivers/net/ethernet/cadence/macb.h
> > +++ b/drivers/net/ethernet/cadence/macb.h
> > @@ -1209,6 +1209,7 @@ struct macb_queue {
> >  	struct macb_tx_skb	*tx_skb;
> >  	dma_addr_t		tx_ring_dma;
> >  	struct work_struct	tx_error_task;
> > +	bool			txubr_pending;
> >  
> >  	dma_addr_t		rx_ring_dma;
> >  	dma_addr_t		rx_buffers_dma;
> > diff --git a/drivers/net/ethernet/cadence/macb_main.c
> > b/drivers/net/ethernet/cadence/macb_main.c
> > index 160dc5ad84ae..1cb8afb8ef0d 100644
> > --- a/drivers/net/ethernet/cadence/macb_main.c
> > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > @@ -959,7 +959,7 @@ static int macb_halt_tx(struct macb *bp)
> >  	return -ETIMEDOUT;
> >  }
> >  
> > -static void macb_tx_unmap(struct macb *bp, struct macb_tx_skb *tx_skb)
> > +static void macb_tx_unmap(struct macb *bp, struct macb_tx_skb *tx_skb, int
> > budget)
> >  {
> >  	if (tx_skb->mapping) {
> >  		if (tx_skb->mapped_as_page)
> > @@ -972,7 +972,7 @@ static void macb_tx_unmap(struct macb *bp, struct
> > macb_tx_skb *tx_skb)
> >  	}
> >  
> >  	if (tx_skb->skb) {
> > -		dev_kfree_skb_any(tx_skb->skb);
> > +		napi_consume_skb(tx_skb->skb, budget);
> >  		tx_skb->skb = NULL;
> >  	}
> >  }
> > @@ -1025,12 +1025,13 @@ static void macb_tx_error_task(struct work_struct
> > *work)
> >  		    (unsigned int)(queue - bp->queues),
> >  		    queue->tx_tail, queue->tx_head);
> >  
> > -	/* Prevent the queue IRQ handlers from running: each of them may call
> > -	 * macb_tx_interrupt(), which in turn may call netif_wake_subqueue().
> > +	/* Prevent the queue NAPI poll from running, as it calls
> > +	 * macb_tx_complete(), which in turn may call netif_wake_subqueue().
> >  	 * As explained below, we have to halt the transmission before updating
> >  	 * TBQP registers so we call netif_tx_stop_all_queues() to notify the
> >  	 * network engine about the macb/gem being halted.
> >  	 */
> > +	napi_disable(&queue->napi);
> >  	spin_lock_irqsave(&bp->lock, flags);
> >  
> >  	/* Make sure nobody is trying to queue up new packets */
> > @@ -1058,7 +1059,7 @@ static void macb_tx_error_task(struct work_struct
> > *work)
> >  		if (ctrl & MACB_BIT(TX_USED)) {
> >  			/* skb is set for the last buffer of the frame */
> >  			while (!skb) {
> > -				macb_tx_unmap(bp, tx_skb);
> > +				macb_tx_unmap(bp, tx_skb, 0);
> >  				tail++;
> >  				tx_skb = macb_tx_skb(queue, tail);
> >  				skb = tx_skb->skb;
> > @@ -1088,7 +1089,7 @@ static void macb_tx_error_task(struct work_struct
> > *work)
> >  			desc->ctrl = ctrl | MACB_BIT(TX_USED);
> >  		}
> >  
> > -		macb_tx_unmap(bp, tx_skb);
> > +		macb_tx_unmap(bp, tx_skb, 0);
> >  	}
> >  
> >  	/* Set end of TX queue */
> > @@ -1118,25 +1119,28 @@ static void macb_tx_error_task(struct work_struct
> > *work)
> >  	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
> >  
> >  	spin_unlock_irqrestore(&bp->lock, flags);
> > +	napi_enable(&queue->napi);
> >  }
> >  
> > -static void macb_tx_interrupt(struct macb_queue *queue)
> > +static bool macb_tx_complete_pending(struct macb_queue *queue)
> > +{
> > +	if (queue->tx_head != queue->tx_tail) {
> > +		/* Make hw descriptor updates visible to CPU */
> > +		rmb();
> > +
> > +		if (macb_tx_desc(queue, queue->tx_tail)->ctrl &
> > MACB_BIT(TX_USED))
> > +			return true;
> > +	}
> > +	return false;
> > +}
> > +
> > +static void macb_tx_complete(struct macb_queue *queue, int budget)
> >  {
> >  	unsigned int tail;
> >  	unsigned int head;
> > -	u32 status;
> >  	struct macb *bp = queue->bp;
> >  	u16 queue_index = queue - bp->queues;
> >  
> > -	status = macb_readl(bp, TSR);
> > -	macb_writel(bp, TSR, status);
> > -
> > -	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
> > -		queue_writel(queue, ISR, MACB_BIT(TCOMP));
> > -
> > -	netdev_vdbg(bp->dev, "macb_tx_interrupt status = 0x%03lx\n",
> > -		    (unsigned long)status);
> > -
> >  	head = queue->tx_head;
> >  	for (tail = queue->tx_tail; tail != head; tail++) {
> >  		struct macb_tx_skb	*tx_skb;
> > @@ -1182,7 +1186,7 @@ static void macb_tx_interrupt(struct macb_queue *queue)
> >  			}
> >  
> >  			/* Now we can safely release resources */
> > -			macb_tx_unmap(bp, tx_skb);
> > +			macb_tx_unmap(bp, tx_skb, budget);
> >  
> >  			/* skb is set only for the last buffer of the frame.
> >  			 * WARNING: at this point skb has been freed by
> > @@ -1569,23 +1573,55 @@ static bool macb_rx_pending(struct macb_queue *queue)
> >  	return (desc->addr & MACB_BIT(RX_USED)) != 0;
> >  }
> >  
> > +static void macb_tx_restart(struct macb_queue *queue)
> > +{
> > +	unsigned int head = queue->tx_head;
> > +	unsigned int tail = queue->tx_tail;
> > +	struct macb *bp = queue->bp;
> > +	unsigned int head_idx, tbqp;
> > +
> > +	if (head == tail)
> > +		return;
> > +
> > +	tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
> > +	tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
> > +	head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, head));
> > +
> > +	if (tbqp == head_idx)
> > +		return;
> > +
> > +	spin_lock_irq(&bp->lock);
> > +	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
> > +	spin_unlock_irq(&bp->lock);
> > +}
> > +
> >  static int macb_poll(struct napi_struct *napi, int budget)
> >  {
> >  	struct macb_queue *queue = container_of(napi, struct macb_queue, napi);
> >  	struct macb *bp = queue->bp;
> >  	int work_done;
> >  
> > +	macb_tx_complete(queue, budget);
> > +
> > +	rmb(); // ensure txubr_pending is up to date
> > +	if (queue->txubr_pending) {
> > +		queue->txubr_pending = false;
> > +		netdev_vdbg(bp->dev, "poll: tx restart\n");
> > +		macb_tx_restart(queue);
> > +	}
> > +
> 
> Thinking about this a bit more, I wonder if we could just do this tx_restart
> call unconditionally here? Then we wouldn't need this txubr_pending flag at
> all. CCing Tomas Melin who worked on this tx_restart code recently.

Looking only at the code, and lacking the NIC specs, the two
alternative look functionally equivalent.

Performance wise it could matter. It depends on the relative cost of
ISR+memory barriers vs restarting TX  - removing txubr_pending you will
trade the former for the latter.

I guess the easier way to check is doing performance comparisons with
the 2 options. I hope you have the relevant H/W handy ;)

Thanks,

Paolo

