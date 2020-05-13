Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F2B1D1749
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 16:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388815AbgEMOQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 10:16:10 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:38722 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731192AbgEMOQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 10:16:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1589379368; x=1620915368;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=UzkFgk4KxPXdtpumytvjaT9DH3n8QRgbvV1ZsZ7ca9s=;
  b=ZCqbDqjwfFrgaa0bDcK+j5Voj+1Cqbe9ukQQwmgHOXq/9TgJkgKBdcwD
   qrnUZA8eQHNmbDzi3xFlQROaubIrNeCjsiYT3/vQmjoiJ/PtKAXhJuDRU
   6DIYkTO3qxPpgte3AZ8ncmRKC+ZVZBxzmtG1PPzClHWuNcEC/kIjy8ssB
   Ae6Ao1LKkbpq4a00CXP91T4oCQmf1pdCU9ATVPcJlPGGqeMGDrGN9uXda
   99vPx/Y2XSHw3ATFME8s4dDzjDrwJsuf6MrvkBscSfiiWprGBOcoNZbNn
   G9P0BuD8ZqCeov6HdsLa1kBKvT8JJc8XQLo6ApEMVSkgF24E4ouwZ2kx0
   g==;
IronPort-SDR: BAhFBmj8YgfLl9K0CKFV6Il6Sh3mNN5rA25bxiNtKTAFHTSbtw1UbUhFshasWmVsDmrUmh34OF
 6V6JPqzxQ5e8fH9gJdbnXvkZS6ueKYbciyV84JBVSLybdKYySn2h39eApCA4yGMqbwSyCzbvRi
 1WXiyYmrxUPcL+c0JEmHlzOMbdn7wFxc14zIurUdvC/9by6sHYiDbdrj8O1lTqx48LSTISNCGK
 0mHXOw7MbZRfa8sRz171/iir+iS1yWQeYULipTTL777gBlA/OFTceROHJB1SQfarxYRdJrax7o
 v7g=
X-IronPort-AV: E=Sophos;i="5.73,388,1583218800"; 
   d="scan'208";a="76511186"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 May 2020 07:16:08 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 13 May 2020 07:16:08 -0700
Received: from [10.171.246.28] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 13 May 2020 07:16:05 -0700
Subject: Re: [PATCH v4 3/5] net: macb: fix macb_get/set_wol() when moving to
 phylink
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        <f.fainelli@gmail.com>, <antoine.tenart@bootlin.com>,
        <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <cover.1588763703.git.nicolas.ferre@microchip.com>
 <4aeebe901fde6db70a5ca12b10e793dd2ee6ce60.1588763703.git.nicolas.ferre@microchip.com>
 <20200513130536.GI1551@shell.armlinux.org.uk>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <c0bc2167-e49e-1026-94e3-cb5931755389@microchip.com>
Date:   Wed, 13 May 2020 16:16:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200513130536.GI1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Russell,

Thanks for the feedback.

On 13/05/2020 at 15:05, Russell King - ARM Linux admin wrote:
> On Wed, May 06, 2020 at 01:37:39PM +0200, nicolas.ferre@microchip.com wrote:
>> From: Nicolas Ferre <nicolas.ferre@microchip.com>
>>
>> Keep previous function goals and integrate phylink actions to them.
>>
>> phylink_ethtool_get_wol() is not enough to figure out if Ethernet driver
>> supports Wake-on-Lan.
>> Initialization of "supported" and "wolopts" members is done in phylink
>> function, no need to keep them in calling function.
>>
>> phylink_ethtool_set_wol() return value is not enough to determine
>> if WoL is enabled for the calling Ethernet driver. Call it first
>> but don't rely on its return value as most of simple PHY drivers
>> don't implement a set_wol() function.
>>
>> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>> Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
>> Cc: Harini Katakam <harini.katakam@xilinx.com>
>> Cc: Antoine Tenart <antoine.tenart@bootlin.com>
>> ---
>>   drivers/net/ethernet/cadence/macb_main.c | 18 ++++++++++--------
>>   1 file changed, 10 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
>> index 53e81ab048ae..24c044dc7fa0 100644
>> --- a/drivers/net/ethernet/cadence/macb_main.c
>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>> @@ -2817,21 +2817,23 @@ static void macb_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
>>   {
>>        struct macb *bp = netdev_priv(netdev);
>>
>> -     wol->supported = 0;
>> -     wol->wolopts = 0;
>> -
>> -     if (bp->wol & MACB_WOL_HAS_MAGIC_PACKET)
>> +     if (bp->wol & MACB_WOL_HAS_MAGIC_PACKET) {
>>                phylink_ethtool_get_wol(bp->phylink, wol);
>> +             wol->supported |= WAKE_MAGIC;
>> +
>> +             if (bp->wol & MACB_WOL_ENABLED)
>> +                     wol->wolopts |= WAKE_MAGIC;
>> +     }
>>   }
>>
>>   static int macb_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
>>   {
>>        struct macb *bp = netdev_priv(netdev);
>> -     int ret;
>>
>> -     ret = phylink_ethtool_set_wol(bp->phylink, wol);
>> -     if (!ret)
>> -             return 0;
>> +     /* Pass the order to phylink layer.
>> +      * Don't test return value as set_wol() is often not supported.
>> +      */
>> +     phylink_ethtool_set_wol(bp->phylink, wol);
> 
> If this returns an error, does that mean WOL works or does it not?

In my use case (simple phy: "Micrel KSZ8081"), if I have the error 
"-EOPNOTSUPP", it simply means that this phy driver doesn't have the 
set_wol() function. But on the MAC side, I can perfectly wake-up on WoL 
event as the phy acts as a pass-through.

> Note that if set_wol() is not supported, this will return -EOPNOTSUPP.
> What about other errors?

True, I don't manage them. But for now this patch is a fix that only 
reverts to previous behavior. In other terms, it only fixes the regression.

But can I make the difference, and how, between?
1/ the phy doesn't support WoL and could prevent the WoL to happen on 
the MAC
2/ the phy doesn't implement (yet) the set_wol() function, if MAC can 
manage, it's fine


> If you want to just ignore the case where it's not supported, then
> this looks like a sledge hammer to crack a nut.

Do you suggest that I just don't call phylink_ethtool_set_wol() at all?

But what if the underlying phy does support WoL?

Best regards,
-- 
Nicolas Ferre
