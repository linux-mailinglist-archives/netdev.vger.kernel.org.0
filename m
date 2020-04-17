Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093611ADDAB
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 14:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbgDQM5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 08:57:39 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:48125 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729034AbgDQM5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 08:57:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587128258; x=1618664258;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Ew4XnWdKx8Yo/vg5CuEUoLqg3uZ1q1ugduFZ1gg4Zo0=;
  b=CSeYgX9Xl01m84dldnWoCkbNrv+QjuKPi9xOZYkGdMDXGmjW3iGKMIjS
   L0mNzWl0+gxE/CiE6zHlAkkXE4XttJOOtDO2lqRL/EBXV/bk2WV5FcPZ1
   OPwCTjioMyFI6xUVnSLm3620ELmfonDDK8vLMSu5uM52wTadHiq5jvPda
   UvmZ/d7pKKAYUbb3zG6cC3fkJwY0+tOuhafeOLltMmuC878aLAv/yujkQ
   zjoLQfPFKolQROXyLvNYuAoYYppxiAkHev/DovV1TyzTXKt2wPkNe+IkD
   9Iai9ZskD67hc96T4egCT8fPjX6HCxcH50vh2kF/0eX80bNW3glBGRxv2
   w==;
IronPort-SDR: 0mHhU6xW5jYa0gqmqanFE4tSK3UAVzOjw5acDrYaN7LBhfWb2ovNjS/kDasbC4xXs5LIKWQPh7
 8VSh2K2JUOckp2khKniaon5rvj0lFIvNq5rOIALJkLXowIIMQo/lZPgHk/IbxioFj2GCqVHYfj
 llBltPxhXq8/XnDfoeXkdyfMjQJK0Mwbl7jVzwCjx/rUvLttPnllJTXPH0C71xPls41rQ12wz5
 v4nt8j/10W4Aq2dXuHy4RIPGYSd4HOHEm2rez52b+GOKYzJeHFon/tyBOShuntwjlA+gA+FipR
 3Jc=
X-IronPort-AV: E=Sophos;i="5.72,395,1580799600"; 
   d="scan'208";a="9536051"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Apr 2020 05:57:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 17 Apr 2020 05:57:37 -0700
Received: from [10.205.29.56] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Fri, 17 Apr 2020 05:57:12 -0700
Subject: Re: [PATCH 4/5] net: macb: WoL support for GEM type of Ethernet
 controller
To:     Florian Fainelli <f.fainelli@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <pthombar@cadence.com>, <sergio.prado@e-labworks.com>,
        <antoine.tenart@bootlin.com>, <linux@armlinux.org.uk>,
        <andrew@lunn.ch>, <michal.simek@xilinx.com>
References: <cover.1587058078.git.nicolas.ferre@microchip.com>
 <56bb7a742093cec160c4465c808778a14b2607e7.1587058078.git.nicolas.ferre@microchip.com>
 <6fc99e01-6d64-4248-3627-aa14a914df72@gmail.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <ef8b4010-956f-6e66-dbda-7c9999fec813@microchip.com>
Date:   Fri, 17 Apr 2020 14:57:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <6fc99e01-6d64-4248-3627-aa14a914df72@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian,

Thank you for your review of the series!


On 16/04/2020 at 21:25, Florian Fainelli wrote:
> On 4/16/2020 10:44 AM, nicolas.ferre@microchip.com wrote:
>> From: Nicolas Ferre <nicolas.ferre@microchip.com>
>>
>> Adapt the Wake-on-Lan feature to the Cadence GEM Ethernet controller.
>> This controller has different register layout and cannot be handled by
>> previous code.
>> We disable completely interrupts on all the queues but the queue 0.
>> Handling of WoL interrupt is done in another interrupt handler
>> positioned depending on the controller version used, just between
>> suspend() and resume() calls.
>> It allows to lower pressure on the generic interrupt hot path by
>> removing the need to handle 2 tests for each IRQ: the first figuring out
>> the controller revision, the second for actually knowing if the WoL bit
>> is set.
>>
>> Queue management in suspend()/resume() functions inspired from RFC patch
>> by Harini Katakam <harinik@xilinx.com>, thanks!
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
>> ---
> 
> [snip]
> 
>>
>> +static irqreturn_t gem_wol_interrupt(int irq, void *dev_id)
>> +{
>> +     struct macb_queue *queue = dev_id;
>> +     struct macb *bp = queue->bp;
>> +     u32 status;
>> +
>> +     status = queue_readl(queue, ISR);
>> +
>> +     if (unlikely(!status))
>> +             return IRQ_NONE;
>> +
>> +     spin_lock(&bp->lock);
>> +
>> +     if (status & GEM_BIT(WOL)) {
>> +             queue_writel(queue, IDR, GEM_BIT(WOL));
>> +             gem_writel(bp, WOL, 0);
>> +             netdev_vdbg(bp->dev, "GEM WoL: queue = %u, isr = 0x%08lx\n",
>> +                         (unsigned int)(queue - bp->queues),
>> +                         (unsigned long)status);
>> +             if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
>> +                     queue_writel(queue, ISR, GEM_BIT(WOL));
> 
> You would also need a pm_wakeup_event() call here to record that this
> device did wake-up the system.

Oh yes, indeed that's missing. I'll add it to my v2.

Thanks. Best regards,
   Nicolas


-- 
Nicolas Ferre
