Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08AE2A83A2
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 17:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729862AbgKEQiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 11:38:15 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:49995 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgKEQiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 11:38:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1604594296; x=1636130296;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=mqAdJ2KfOPnjde9ZlddFYrhmUwlxdWalTxq1g3IyYFQ=;
  b=knvHq/xwHVDiNIcXIrOpTIgM84GdHac6bpMvUyAcSJ47WPrmrUq3BbCc
   NiiG5xY0Rwh7xz5FRUL9aHjZO1o1e0xAvHs1b6NAatE89WuHXX7xn24d2
   YuYqm3Y1/Steh9Yo/yqwXohYpNrIFyxF9njh5g2ZdU6T91FoKNi/Cc1YN
   iS4CQ+TywAAt4SIkdFO9DTVifbbnwLC99tz8sytq32n6JTaUPxlyunB/C
   IlMPVbTUqfqwjtVQxJyvivjZcymZD9pORJ9KGeWqdkSWtI7K+pGM1d2lr
   UZdDTdIrBO4tf26LEfkVE0mYKICWQmYj03gzS6YIk8AQRLhDi53ys4Lyv
   g==;
IronPort-SDR: 4GisP0zetLOqo2UB5E5J+Jy2u6xheVedAWQo4AS5IWSD6r8TFlckFzP+EIKAfEG02s7pzN8XAp
 Z+qYEAtciEFQgfjgDtMlxT/0vamI+H0LYZCkBSy2I3COfvH4pefcHDUXKzt/GpLktD4ajeOaTR
 T3j59xLuFt3J/HdRFwcV6WjrFryOJn2Srj2fhJgTWFRhBLDezeZp+gNjVW5e2TWHfWzKP5JIR3
 Qnjd7UeU/gtdUyRIdjc2amSLSN7tuEmeqBVHvwlgvyhE7kE9z5fOH8vVbaUsG0Hjv3EZ3UGS8p
 jHw=
X-IronPort-AV: E=Sophos;i="5.77,453,1596524400"; 
   d="scan'208";a="97332249"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Nov 2020 09:38:15 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 5 Nov 2020 09:38:13 -0700
Received: from [10.171.246.99] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 5 Nov 2020 09:38:09 -0700
Subject: Re: [PATCH] net: macb: fix NULL dereference due to no pcs_config
 method
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Parshuram Thombare <pthombar@cadence.com>, <kuba@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <Claudiu.Beznea@microchip.com>, <Santiago.Esteban@microchip.com>,
        <andrew@lunn.ch>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <harini.katakam@xilinx.com>,
        <michal.simek@xilinx.com>
References: <1604587039-5646-1-git-send-email-pthombar@cadence.com>
 <6873cf12-456b-c121-037b-d2c5a6138cb3@microchip.com>
 <20201105154856.GN1551@shell.armlinux.org.uk>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <ef62fed6-3701-314f-9712-ef53142095a8@microchip.com>
Date:   Thu, 5 Nov 2020 17:38:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201105154856.GN1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/11/2020 at 16:48, Russell King - ARM Linux admin wrote:
> On Thu, Nov 05, 2020 at 04:22:18PM +0100, Nicolas Ferre wrote:
>> On 05/11/2020 at 15:37, Parshuram Thombare wrote:
>>> This patch fixes NULL pointer dereference due to NULL pcs_config
>>> in pcs_ops.
>>>
>>> Fixes: e4e143e26ce8 ("net: macb: add support for high speed interface")
>>
>> What is this tag? In linux-next? As patch is not yet in Linus' tree, you
>> cannot refer to it like this.
>>
>>> Reported-by: Nicolas Ferre <Nicolas.Ferre@microchip.com>
>>> Link: https://lkml.org/lkml/2020/11/4/482
>>
>> You might need to change this to a "lore" link:
>> https://lore.kernel.org/netdev/2db854c7-9ffb-328a-f346-f68982723d29@microchip.com/
>>
>>> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
>>
>> This fix looks a bit weird to me. What about proposing a patch to Russell
>> like the chunk that you already identified in function
>> phylink_major_config()?
> 
> No thanks. macb is currently the only case where a stub implementation
> for pcs_config() is required, which only occurs because the only
> appropriate protocol supported there is SGMII and not 1000base-X as
> well.

Got it.

>>> ---
>>>    drivers/net/ethernet/cadence/macb_main.c | 17 +++++++++++++++--
>>>    1 file changed, 15 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
>>> index b7bc160..130a5af 100644
>>> --- a/drivers/net/ethernet/cadence/macb_main.c
>>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>>> @@ -633,6 +633,15 @@ static void macb_pcs_an_restart(struct phylink_pcs *pcs)
>>>           /* Not supported */
>>>    }
>>>
>>> +static int macb_pcs_config(struct phylink_pcs *pcs,
>>> +                          unsigned int mode,
>>> +                          phy_interface_t interface,
>>> +                          const unsigned long *advertising,
>>> +                          bool permit_pause_to_mac)
>>> +{
>>> +       return 0;
>>> +}
>>
>> Russell, is the requirement for this void function intended?
> 
> In response to v3 of the patch on 21st October, I said, and I quote:
> 
>    I think all that needs to happen is a pcs_ops for the non-10GBASE-R
>    mode which moves macb_mac_pcs_get_state() and macb_mac_an_restart()
>    to it, and implements a stub pcs_config(). So it should be simple
>    to do.
> 
> Obviously, my advice was not followed, I didn't spot the lack of it
> in v4 (sorry), and the result is the NULL pointer oops.

Fair enough. So Parshuram I'll add my ack tag when you re-send your 
patch with little issues fixed.

Thanks for your help Russell.

Best regards,
   Nicolas
-- 
Nicolas Ferre
