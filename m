Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697C91AE39B
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgDQRRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:17:35 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:27205 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729089AbgDQRR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 13:17:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587143848; x=1618679848;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Z97YOUsyGakXRlsIeAgnyUr2EaXM9GuayVOBY7SPxZQ=;
  b=CNNTU61mVIuFePxf0sgViSpdqguKUDYIxUp0RfORBS1WCjndc85mXJI7
   EjcsmeDhF2eZf4fxcK+0f/UUpeFJLxBSnVt2r8wzVVzZ6BpXy1JdTuLzd
   P/Kzl3VKK3jYM8FEG8ZQuT2kLOcwLB2+XawugfAmlDVrUk+ofs1kGNsZB
   0BfjFskuttSRBmNKfrSS/tgSqYvHdDtNgWzuIvavu8m9V5LMxMEATXjtY
   1CarkbDrqcKmuvP8kz8ZEV/+oh+D4IG98mjaUcYQZKJpOyFONyoYw4ChY
   MwAVIlE6nI78uCuPYfBrUFTP6dnyPSluQ9ktFAxfsl3QMAYv0k26e8O+e
   A==;
IronPort-SDR: 2IIOiNY0TIQc5JY3syiYgx9veibgSIDFWqVrAw4gP5rQmScuOeqMwWeSQnU5PNv41NA3s7nLmT
 N8uv3OkbkBi/1gpYfsEViAWgwvSEeouk8YbKj+fGplpShSgSDnu0kRLh1vDu8KTkoUULv3H6Ly
 XSWx/5gOVUHMaWYVVLPfYL8Q/LZinTaV14+QBnzstDFhmx1Iazzs5dd+fEBE6x1lbRZqzF7KZo
 qbGYDZsA9vu5fgoEQSg4wOoNDsa6QDTyCNWJtFM70j7lGzKGYM3MjjLf/WNZqFaPBvodYpkbRe
 MKY=
X-IronPort-AV: E=Sophos;i="5.72,395,1580799600"; 
   d="scan'208";a="73717575"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Apr 2020 10:14:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 17 Apr 2020 10:14:04 -0700
Received: from [10.171.246.39] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Fri, 17 Apr 2020 10:14:20 -0700
Subject: Re: [PATCH 4/5] net: macb: WoL support for GEM type of Ethernet
 controller
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>, <f.fainelli@gmail.com>,
        <linux@armlinux.org.uk>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <pthombar@cadence.com>, <sergio.prado@e-labworks.com>,
        <antoine.tenart@bootlin.com>, <andrew@lunn.ch>,
        <michal.simek@xilinx.com>
References: <cover.1587058078.git.nicolas.ferre@microchip.com>
 <56bb7a742093cec160c4465c808778a14b2607e7.1587058078.git.nicolas.ferre@microchip.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <61762f4b-03fa-5484-334e-8515eed485e2@microchip.com>
Date:   Fri, 17 Apr 2020 19:14:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <56bb7a742093cec160c4465c808778a14b2607e7.1587058078.git.nicolas.ferre@microchip.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/04/2020 at 19:44, nicolas.ferre@microchip.com wrote:
> From: Nicolas Ferre <nicolas.ferre@microchip.com>
> 
> Adapt the Wake-on-Lan feature to the Cadence GEM Ethernet controller.
> This controller has different register layout and cannot be handled by
> previous code.
> We disable completely interrupts on all the queues but the queue 0.
> Handling of WoL interrupt is done in another interrupt handler
> positioned depending on the controller version used, just between
> suspend() and resume() calls.
> It allows to lower pressure on the generic interrupt hot path by
> removing the need to handle 2 tests for each IRQ: the first figuring out
> the controller revision, the second for actually knowing if the WoL bit
> is set.
> 
> Queue management in suspend()/resume() functions inspired from RFC patch
> by Harini Katakam <harinik@xilinx.com>, thanks!
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> ---
>   drivers/net/ethernet/cadence/macb.h      |   3 +
>   drivers/net/ethernet/cadence/macb_main.c | 121 ++++++++++++++++++++---
>   2 files changed, 109 insertions(+), 15 deletions(-)

[..]

> @@ -4534,23 +4564,56 @@ static int __maybe_unused macb_suspend(struct device *dev)
>   	struct macb_queue *queue = bp->queues;
>   	unsigned long flags;
>   	unsigned int q;
> +	int err;
>   
>   	if (!netif_running(netdev))
>   		return 0;
>   
>   	if (bp->wol & MACB_WOL_ENABLED) {
> -		macb_writel(bp, IER, MACB_BIT(WOL));
> -		macb_writel(bp, WOL, MACB_BIT(MAG));
> -		enable_irq_wake(bp->queues[0].irq);
> -		netif_device_detach(netdev);
> -	} else {
> -		netif_device_detach(netdev);
> +		spin_lock_irqsave(&bp->lock, flags);
> +		/* Flush all status bits */
> +		macb_writel(bp, TSR, -1);
> +		macb_writel(bp, RSR, -1);
>   		for (q = 0, queue = bp->queues; q < bp->num_queues;
> -		     ++q, ++queue)
> -			napi_disable(&queue->napi);
> -		rtnl_lock();
> -		phylink_stop(bp->phylink);
> -		rtnl_unlock();
> +		     ++q, ++queue) {
> +			/* Disable all interrupts */
> +			queue_writel(queue, IDR, -1);
> +			queue_readl(queue, ISR);
> +			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
> +				queue_writel(queue, ISR, -1);
> +		}
> +		/* Change interrupt handler and
> +		 * Enable WoL IRQ on queue 0
> +		 */
> +		if (macb_is_gem(bp)) {
> +			devm_free_irq(dev, bp->queues[0].irq, bp->queues);
> +			err = devm_request_irq(dev, bp->queues[0].irq, gem_wol_interrupt,
> +					       IRQF_SHARED, netdev->name, bp->queues);
> +			if (err) {
> +				dev_err(dev,
> +					"Unable to request IRQ %d (error %d)\n",
> +					bp->queues[0].irq, err);
> +				return err;
> +			}
> +			queue_writel(bp->queues, IER, GEM_BIT(WOL));
> +			gem_writel(bp, WOL, MACB_BIT(MAG));
> +		} else {
> +			queue_writel(bp->queues, IER, MACB_BIT(WOL));
> +			macb_writel(bp, WOL, MACB_BIT(MAG));
> +		}
> +		spin_unlock_irqrestore(&bp->lock, flags);
> +
> +		enable_irq_wake(bp->queues[0].irq);
> +	}
> +
> +	netif_device_detach(netdev);
> +	for (q = 0, queue = bp->queues; q < bp->num_queues;
> +	     ++q, ++queue)
> +		napi_disable(&queue->napi);
> +
> +	if (!(bp->wol & MACB_WOL_ENABLED)) {
> +		phy_stop(netdev->phydev);
> +		phy_suspend(netdev->phydev);

Bug here: you must read:

		rtnl_lock();
		phylink_stop(bp->phylink);
		rtnl_unlock();

Instead of the 2 previous lines. I'll correct in v2.

Sorry for the regression.


>   		spin_lock_irqsave(&bp->lock, flags);
>   		macb_reset_hw(bp);
>   		spin_unlock_irqrestore(&bp->lock, flags);
> @@ -4575,20 +4638,48 @@ static int __maybe_unused macb_resume(struct device *dev)

[..]
BTW: I have issue having a real resume event from the phy with this 
series. I'm investigating that but didn't find anything for now.

Observation #1: when the WoL is not enabled, I don't have link issue. 
But the path in suspend/resume is far more intrusive in phy state.

Observation #2: when WoL is enabled, I need to do a full ifdown/ifup 
sequence for gain access again to the link:

ip link show eth0
2: eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast 
state DOWN mode DEFAULT group default qlen 1000
     link/ether 54:10:ec:be:50:b0 brd ff:ff:ff:ff:ff:ff

ifdown eth0 && ifup eth0

ip link show eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast 
state UP mode DEFAULT group default qlen 1000
     link/ether 54:10:ec:be:50:b0 brd ff:ff:ff:ff:ff:ff

Observation #3: I didn't experience this behavior while playing with the 
WoL on my 4.19 kernel before porting to Mainline.

Best regards,
-- 
Nicolas Ferre
