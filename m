Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DED1E089A
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 10:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731353AbgEYIS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 04:18:26 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:47235 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgEYISY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 04:18:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1590394703; x=1621930703;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=6Y1kKLNvw5tHAyMcE8lhbasGho0U1mzPQDK1AoxNCKM=;
  b=mduQi4wjhtmky9onc17blmJeEDp2V/jlJJwbP9NPSWDEetsCtTT1G3NT
   WTVdsHOMjLiuUJrQVOlnDcl6q+pRQXAZr1SDMVy6kdnF/JxUz4FqM9qYd
   qEMlk5Ak8mM/BcSIVbl2aqnATEB4DTUmHv0LMDxTxfq/Ur7/DFIhIHa9g
   zq+3/0u17S6eOPKg5snT/odxQmaDko0gtJAVn1fesa0WUIKd0H6R4bz9S
   biUwuMTxHG5J9I5d+DyElT5Jk3sKgGsne2VyPh+j82BJFn6FsbJ3p29MM
   yQ+x0wCZMGoC8fG6rnDYct+0dY7QK1NzUhhHhD24/i86o5jW0jP/bErVP
   Q==;
IronPort-SDR: QCE16gf6KIchmmRAPv5H+Yck0P/9pBdRqngXm6N5t+pR/zMqFjatY9X2LyUdUM8avC4nnNnReC
 J3xZ4DE7o6c47z45PfCz796HoKAHI7VtDBivaOUBKiaWKQEy8mgMj18/WUm+vgTZEkDOY9vcX3
 731ASHcxE0A3er6HmVuSAdHSUdcWbmhxJTiELkep/wDIMKkvh8ZD2pQkzKSagAiveCkzVJqNB3
 3HVKCHkZB0oo/lKT7m/x0n+hCBru1RT3k5jqlNU3q+NoDzTVTYXqDAoOq+D0H9LJJQYf7NLm0Z
 OAw=
X-IronPort-AV: E=Sophos;i="5.73,432,1583218800"; 
   d="scan'208";a="13411380"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 May 2020 01:18:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 25 May 2020 01:18:24 -0700
Received: from [10.205.29.90] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 25 May 2020 01:18:12 -0700
Subject: Re: [PATCH v4 1/5] net: macb: fix wakeup test in runtime
 suspend/resume routines
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <f.fainelli@gmail.com>,
        "Russell King - ARM Linux admin" <linux@armlinux.org.uk>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>, <linux-kernel@vger.kernel.org>,
        <harini.katakam@xilinx.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>
References: <cover.1588763703.git.nicolas.ferre@microchip.com>
 <dc30ff1d17cb5a75ddd10966eab001f67ac744ef.1588763703.git.nicolas.ferre@microchip.com>
 <20200506131843.22cf1dab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <347c9a4f-8a01-a931-c9d5-536339337f8a@microchip.com>
Organization: microchip
Message-ID: <e43e7ed6-c78a-7995-3f46-0bdbf32f361c@microchip.com>
Date:   Mon, 25 May 2020 10:18:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <347c9a4f-8a01-a931-c9d5-536339337f8a@microchip.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/05/2020 at 12:03, Nicolas Ferre wrote:
> On 06/05/2020 at 22:18, Jakub Kicinski wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> On Wed, 6 May 2020 13:37:37 +0200 nicolas.ferre@microchip.com wrote:
>>> From: Nicolas Ferre <nicolas.ferre@microchip.com>
>>>
>>> Use the proper struct device pointer to check if the wakeup flag
>>> and wakeup source are positioned.
>>> Use the one passed by function call which is equivalent to
>>> &bp->dev->dev.parent.
>>>
>>> It's preventing the trigger of a spurious interrupt in case the
>>> Wake-on-Lan feature is used.
>>>
>>> Fixes: bc1109d04c39 ("net: macb: Add pm runtime support")
>>
>>           Fixes tag: Fixes: bc1109d04c39 ("net: macb: Add pm runtime support")
>>           Has these problem(s):
>>                   - Target SHA1 does not exist
> 
> Indeed, it's:
> Fixes: d54f89af6cc4 ("net: macb: Add pm runtime support")
> 
> David: do I have to respin or you can modify it?

David, all, I'm about to resend this series (alternative to "ping"), 
however:

1/ Now that it's late in the cycle, I'd like that you tell me if I 
rebase on net-next because it isn't not sensible to queue such (non 
urgeent) changes at rc7

2/ I didn't get answers from Russell and can't tell if there's a better 
way of handling underlying phylink error of phylink_ethtool_set_wol() in 
patch 3/5

Best regards,
   Nicolas

>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
>>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>>> Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
>>> Cc: Harini Katakam <harini.katakam@xilinx.com>
>>> ---
>>>    drivers/net/ethernet/cadence/macb_main.c | 4 ++--
>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
>>> index 36290a8e2a84..d11fae37d46b 100644
>>> --- a/drivers/net/ethernet/cadence/macb_main.c
>>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>>> @@ -4616,7 +4616,7 @@ static int __maybe_unused macb_runtime_suspend(struct device *dev)
>>>         struct net_device *netdev = dev_get_drvdata(dev);
>>>         struct macb *bp = netdev_priv(netdev);
>>>
>>> -     if (!(device_may_wakeup(&bp->dev->dev))) {
>>> +     if (!(device_may_wakeup(dev))) {
>>>                 clk_disable_unprepare(bp->tx_clk);
>>>                 clk_disable_unprepare(bp->hclk);
>>>                 clk_disable_unprepare(bp->pclk);
>>> @@ -4632,7 +4632,7 @@ static int __maybe_unused macb_runtime_resume(struct device *dev)
>>>         struct net_device *netdev = dev_get_drvdata(dev);
>>>         struct macb *bp = netdev_priv(netdev);
>>>
>>> -     if (!(device_may_wakeup(&bp->dev->dev))) {
>>> +     if (!(device_may_wakeup(dev))) {
>>>                 clk_prepare_enable(bp->pclk);
>>>                 clk_prepare_enable(bp->hclk);
>>>                 clk_prepare_enable(bp->tx_clk);
>>
> 
> 


-- 
Nicolas Ferre
