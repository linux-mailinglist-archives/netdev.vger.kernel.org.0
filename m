Return-Path: <netdev+bounces-12220-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59259736C65
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:54:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13E672811E9
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45E39154A2;
	Tue, 20 Jun 2023 12:54:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391741FA1
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 12:54:17 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945FA19AE
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 05:53:58 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f97e08b012so27278315e9.3
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 05:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20221208.gappssmtp.com; s=20221208; t=1687265637; x=1689857637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QJGugi0AoabsZM3ADn8QpFKvMhK21X8XWjMetdJYSPU=;
        b=Lht61qXUpxtai5L5IfulLN94cqNusPntIL+h8rcY1xltCkiEe1IGAJQc47LeIelySy
         WWIHngkQza38G5ogNO2OUYupMBZ+NbsBnbbh8T+7OqDyHWN+e/tIgHn/56ORmaHQx4qx
         yWVEr7CvAk4uaOhTHANLUhxuSshqAbvRIto4bEBWP/Rp7ro2+/UisMuNdXg++Bsssuye
         mIhFkyfXnqmY2ioYhKBRt8tK32KS8yPXjJWN0OqYg8q/7sbfPrk3xatz+SP+h51fm9bo
         E8b99WmF7z5Jmrpe62J2spzoC333IbnyVxXtBCz1gPd48PXtr5qrEtzTiXvXea5NGCvk
         U+vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687265637; x=1689857637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QJGugi0AoabsZM3ADn8QpFKvMhK21X8XWjMetdJYSPU=;
        b=Wc62Dxshhf48xtO66saV/bkPsTzUBvDNAWf/dwipCF+2y8ZJk5nUVWuY82923+OvXu
         4tGU7kjFKtMUT2mIhgZg+i6rUx4uuNQfF0MfwYCBOvvHN5e421K3wZHWclajMehTz+iz
         8gqVd2IFnK9Go5ER8Sh7w3AMk6/054iu2PFMyB/lw3pngwZ+lumBxegB2pIjxF1LRdTh
         Ka1zafMn4gaFk/fVr6Ybf8MeJ0mImw2thJaPul2o2ldlmfdNneLB82VoVVbOXezGUq/a
         mPI4j0EKrtedllc0HUMN8Qo8P2IOZP4Co1ojxgN0mIueRCq3Y8ouaS32lQtzC3nez0Ev
         iTqw==
X-Gm-Message-State: AC+VfDxHUcYwc6hFMhp9WwYx+6XUgHlmFdyTEwRyUhL9mdKfA6nMGR1a
	T4Aws90+Czp7yzb/zrVHO0BXKg==
X-Google-Smtp-Source: ACHHUZ6tQZPVmLhAqhmDZQg0KdDRUiLm3xx8V0N71PFIBHCK/ZEboUT51Ct62OpdZNMLZMZS5XZdZg==
X-Received: by 2002:a7b:ce87:0:b0:3f9:b35:bf7f with SMTP id q7-20020a7bce87000000b003f90b35bf7fmr5757912wmj.41.1687265636860;
        Tue, 20 Jun 2023 05:53:56 -0700 (PDT)
Received: from blmsp ([2001:4090:a245:802c:bc2b:8db8:9210:41eb])
        by smtp.gmail.com with ESMTPSA id 24-20020a05600c22d800b003f8c5ceeb77sm2297241wmg.21.2023.06.20.05.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 05:53:56 -0700 (PDT)
Date: Tue, 20 Jun 2023 14:53:54 +0200
From: Markus Schneider-Pargmann <msp@baylibre.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
	Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
	linux-can@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 13/16] can: m_can: Introduce a tx_fifo_in_flight
 counter
Message-ID: <20230620125354.ipok6i43lvow66t4@blmsp>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-14-msp@baylibre.com>
 <ZBSPJHkcLG7gkZ7I@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZBSPJHkcLG7gkZ7I@corigine.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon,

On Fri, Mar 17, 2023 at 05:02:44PM +0100, Simon Horman wrote:
> On Wed, Mar 15, 2023 at 12:05:43PM +0100, Markus Schneider-Pargmann wrote:
> > Keep track of the number of transmits in flight.
> > 
> > This patch prepares the driver to control the network interface queue
> > based on this counter. By itself this counter be
> > implemented with an atomic, but as we need to do other things in the
> > critical sections later I am using a spinlock instead.
> > 
> > Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>

Thank you for all your reviews, very helpful.

> 
> Nit, assuming the values are always positive, I think
> that unsigned might be a more appropriate type than int
> for the tx_fifo_in_flight field, and associated function
> parameters and local variables.

I agree that tx_fifo_in_flight is and should always be a positive value.
However as the code is operating with ++ and -- exclusively I would
personally prefer int here as that shows off-by-one errors much easier
in case there are any at some point.

Is that fine for you?

Best,
Markus

> 
> That notwithstanding,
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> > ---
> >  drivers/net/can/m_can/m_can.c | 41 ++++++++++++++++++++++++++++++++++-
> >  drivers/net/can/m_can/m_can.h |  4 ++++
> >  2 files changed, 44 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> > index 27d36bcc094c..4ad8f08f8284 100644
> > --- a/drivers/net/can/m_can/m_can.c
> > +++ b/drivers/net/can/m_can/m_can.c
> > @@ -442,6 +442,7 @@ static u32 m_can_get_timestamp(struct m_can_classdev *cdev)
> >  static void m_can_clean(struct net_device *net)
> >  {
> >  	struct m_can_classdev *cdev = netdev_priv(net);
> > +	unsigned long irqflags;
> >  
> >  	for (int i = 0; i != cdev->tx_fifo_size; ++i) {
> >  		if (!cdev->tx_ops[i].skb)
> > @@ -453,6 +454,10 @@ static void m_can_clean(struct net_device *net)
> >  
> >  	for (int i = 0; i != cdev->can.echo_skb_max; ++i)
> >  		can_free_echo_skb(cdev->net, i, NULL);
> > +
> > +	spin_lock_irqsave(&cdev->tx_handling_spinlock, irqflags);
> > +	cdev->tx_fifo_in_flight = 0;
> > +	spin_unlock_irqrestore(&cdev->tx_handling_spinlock, irqflags);
> >  }
> >  
> >  /* For peripherals, pass skb to rx-offload, which will push skb from
> > @@ -1023,6 +1028,24 @@ static void m_can_tx_update_stats(struct m_can_classdev *cdev,
> >  	stats->tx_packets++;
> >  }
> >  
> > +static void m_can_finish_tx(struct m_can_classdev *cdev, int transmitted)
> > +{
> > +	unsigned long irqflags;
> > +
> > +	spin_lock_irqsave(&cdev->tx_handling_spinlock, irqflags);
> > +	cdev->tx_fifo_in_flight -= transmitted;
> > +	spin_unlock_irqrestore(&cdev->tx_handling_spinlock, irqflags);
> > +}
> > +
> > +static void m_can_start_tx(struct m_can_classdev *cdev)
> > +{
> > +	unsigned long irqflags;
> > +
> > +	spin_lock_irqsave(&cdev->tx_handling_spinlock, irqflags);
> > +	++cdev->tx_fifo_in_flight;
> > +	spin_unlock_irqrestore(&cdev->tx_handling_spinlock, irqflags);
> > +}
> > +
> >  static int m_can_echo_tx_event(struct net_device *dev)
> >  {
> >  	u32 txe_count = 0;
> > @@ -1032,6 +1055,7 @@ static int m_can_echo_tx_event(struct net_device *dev)
> >  	int i = 0;
> >  	int err = 0;
> >  	unsigned int msg_mark;
> > +	int processed = 0;
> >  
> >  	struct m_can_classdev *cdev = netdev_priv(dev);
> >  
> > @@ -1061,12 +1085,15 @@ static int m_can_echo_tx_event(struct net_device *dev)
> >  
> >  		/* update stats */
> >  		m_can_tx_update_stats(cdev, msg_mark, timestamp);
> > +		++processed;
> >  	}
> >  
> >  	if (ack_fgi != -1)
> >  		m_can_write(cdev, M_CAN_TXEFA, FIELD_PREP(TXEFA_EFAI_MASK,
> >  							  ack_fgi));
> >  
> > +	m_can_finish_tx(cdev, processed);
> > +
> >  	return err;
> >  }
> >  
> > @@ -1161,6 +1188,7 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
> >  				timestamp = m_can_get_timestamp(cdev);
> >  			m_can_tx_update_stats(cdev, 0, timestamp);
> >  			netif_wake_queue(dev);
> > +			m_can_finish_tx(cdev, 1);
> >  		}
> >  	} else  {
> >  		if (ir & (IR_TEFN | IR_TEFW)) {
> > @@ -1846,11 +1874,22 @@ static netdev_tx_t m_can_start_peripheral_xmit(struct m_can_classdev *cdev,
> >  	}
> >  
> >  	netif_stop_queue(cdev->net);
> > +
> > +	m_can_start_tx(cdev);
> > +
> >  	m_can_tx_queue_skb(cdev, skb);
> >  
> >  	return NETDEV_TX_OK;
> >  }
> >  
> > +static netdev_tx_t m_can_start_fast_xmit(struct m_can_classdev *cdev,
> > +					 struct sk_buff *skb)
> > +{
> > +	m_can_start_tx(cdev);
> > +
> > +	return m_can_tx_handler(cdev, skb);
> > +}
> > +
> >  static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
> >  				    struct net_device *dev)
> >  {
> > @@ -1862,7 +1901,7 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
> >  	if (cdev->is_peripheral)
> >  		return m_can_start_peripheral_xmit(cdev, skb);
> >  	else
> > -		return m_can_tx_handler(cdev, skb);
> > +		return m_can_start_fast_xmit(cdev, skb);
> >  }
> >  
> >  static int m_can_open(struct net_device *dev)
> > diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
> > index 2e1a52980a18..e230cf320a6c 100644
> > --- a/drivers/net/can/m_can/m_can.h
> > +++ b/drivers/net/can/m_can/m_can.h
> > @@ -109,6 +109,10 @@ struct m_can_classdev {
> >  	// Store this internally to avoid fetch delays on peripheral chips
> >  	int tx_fifo_putidx;
> >  
> > +	/* Protects shared state between start_xmit and m_can_isr */
> > +	spinlock_t tx_handling_spinlock;
> > +	int tx_fifo_in_flight;
> > +
> >  	struct m_can_tx_op *tx_ops;
> >  	int tx_fifo_size;
> >  	int next_tx_op;
> > -- 
> > 2.39.2
> > 

