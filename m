Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48E5441B38
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 13:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbhKAMhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 08:37:04 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:51994 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbhKAMhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 08:37:03 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1A1CY6Lu028035;
        Mon, 1 Nov 2021 07:34:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1635770046;
        bh=2Dhqwp2VHR7P9ZPJwLgpz4Qzx8OY3hgfn0aos4yZ/e4=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=HhPYgDB+ziXEovCWTyutvLrYOLvOaIvjSeihQM5OGBAGzLSKDDpt3qBm8akQQDuod
         8uKfSXVYMDYLpoVG9EY2Agn4EMFu0OmSBjXiqx2gkUkeeZAi0m4sIT17hbuViVp2WC
         xHb7idj4uwNce/48XiV58gnzPAuu6f6CGNCJik1s=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1A1CY6N2049734
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 1 Nov 2021 07:34:06 -0500
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 1
 Nov 2021 07:34:06 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 1 Nov 2021 07:34:06 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1A1CY2em078198;
        Mon, 1 Nov 2021 07:34:03 -0500
Subject: Re: [PATCH] net: davinci_emac: Fix interrupt pacing disable
To:     Maxim Kiselev <bigunclemax@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Colin Ian King <colin.king@canonical.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Michael Walle <michael@walle.cc>, Sriram <srk@ti.com>,
        <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20211101092134.3357661-1-bigunclemax@gmail.com>
 <717f9769-aac5-d005-e15a-a6a2ff61bb69@ti.com>
 <CALHCpMg1fHjZFfkEnFmUUrvDLFweQ-4aLX4k2hy24hRm2KiAYA@mail.gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <11d3fca6-3389-b7e3-1296-968bb367c302@ti.com>
Date:   Mon, 1 Nov 2021 14:33:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CALHCpMg1fHjZFfkEnFmUUrvDLFweQ-4aLX4k2hy24hRm2KiAYA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/11/2021 14:05, Maxim Kiselev wrote:
> Yes, I can write 0 to INTCTRL for ` case EMAC_VERSION_2` but we also
> need to handle `default case`
	
pls, do not top post.

> 
> пн, 1 нояб. 2021 г. в 14:54, Grygorii Strashko <grygorii.strashko@ti.com>:
>>
>>
>>
>> On 01/11/2021 11:21, Maxim Kiselev wrote:
>>> This patch allows to use 0 for `coal->rx_coalesce_usecs` param to
>>> disable rx irq coalescing.
>>>
>>> Previously we could enable rx irq coalescing via ethtool
>>> (For ex: `ethtool -C eth0 rx-usecs 2000`) but we couldn't disable
>>> it because this part rejects 0 value:
>>>
>>>          if (!coal->rx_coalesce_usecs)
>>>                  return -EINVAL;
>>>
>>> Fixes: 84da2658a619 ("TI DaVinci EMAC : Implement interrupt pacing
>>> functionality.")
>>>
>>> Signed-off-by: Maxim Kiselev <bigunclemax@gmail.com>
>>> ---
>>>    drivers/net/ethernet/ti/davinci_emac.c | 77 ++++++++++++++------------
>>>    1 file changed, 41 insertions(+), 36 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
>>> index e8291d8488391..a3a02c4e5eb68 100644
>>> --- a/drivers/net/ethernet/ti/davinci_emac.c
>>> +++ b/drivers/net/ethernet/ti/davinci_emac.c
>>> @@ -417,46 +417,47 @@ static int emac_set_coalesce(struct net_device *ndev,
>>>                             struct netlink_ext_ack *extack)
>>>    {
>>>        struct emac_priv *priv = netdev_priv(ndev);
>>> -     u32 int_ctrl, num_interrupts = 0;
>>> +     u32 int_ctrl = 0, num_interrupts = 0;
>>>        u32 prescale = 0, addnl_dvdr = 1, coal_intvl = 0;
>>>
>>> -     if (!coal->rx_coalesce_usecs)
>>> -             return -EINVAL;
>>> -
>>>        coal_intvl = coal->rx_coalesce_usecs;
>>
>> Wouldn't be more simple if you just handle !coal->rx_coalesce_usecs here and exit?
>> it seems you can just write 0 t0 INTCTRL.

nothing prevents you from handling all cases here, like

if (!coal->rx_coalesce_usecs)
	switch (priv->version) {
	case EMAC_VERSION_2:
		emac_ctrl_write(EMAC_DM646X_CMINTCTRL, 0);
		break;
	default:
		emac_ctrl_write(EMAC_CTRL_EWINTTCNT, 0);
		break;
	}

	return 0;
}

No?

>>
>>>
>>>        switch (priv->version) {
>>>        case EMAC_VERSION_2:
>>> -             int_ctrl =  emac_ctrl_read(EMAC_DM646X_CMINTCTRL);
>>> -             prescale = priv->bus_freq_mhz * 4;
>>> -
>>> -             if (coal_intvl < EMAC_DM646X_CMINTMIN_INTVL)
>>> -                     coal_intvl = EMAC_DM646X_CMINTMIN_INTVL;
>>> -
>>> -             if (coal_intvl > EMAC_DM646X_CMINTMAX_INTVL) {
>>> -                     /*
>>> -                      * Interrupt pacer works with 4us Pulse, we can
>>> -                      * throttle further by dilating the 4us pulse.
>>> -                      */
>>> -                     addnl_dvdr = EMAC_DM646X_INTPRESCALE_MASK / prescale;
>>> -
>>> -                     if (addnl_dvdr > 1) {
>>> -                             prescale *= addnl_dvdr;
>>> -                             if (coal_intvl > (EMAC_DM646X_CMINTMAX_INTVL
>>> -                                                     * addnl_dvdr))
>>> -                                     coal_intvl = (EMAC_DM646X_CMINTMAX_INTVL
>>> -                                                     * addnl_dvdr);
>>> -                     } else {
>>> -                             addnl_dvdr = 1;
>>> -                             coal_intvl = EMAC_DM646X_CMINTMAX_INTVL;
>>> +             if (coal->rx_coalesce_usecs) {
>>> +                     int_ctrl =  emac_ctrl_read(EMAC_DM646X_CMINTCTRL);
>>> +                     prescale = priv->bus_freq_mhz * 4;
>>> +
>>> +                     if (coal_intvl < EMAC_DM646X_CMINTMIN_INTVL)
>>> +                             coal_intvl = EMAC_DM646X_CMINTMIN_INTVL;
>>> +
>>> +                     if (coal_intvl > EMAC_DM646X_CMINTMAX_INTVL) {
>>> +                             /*
>>> +                              * Interrupt pacer works with 4us Pulse, we can
>>> +                              * throttle further by dilating the 4us pulse.
>>> +                              */
>>> +                             addnl_dvdr =
>>> +                                     EMAC_DM646X_INTPRESCALE_MASK / prescale;
>>> +
>>> +                             if (addnl_dvdr > 1) {
>>> +                                     prescale *= addnl_dvdr;
>>> +                                     if (coal_intvl > (EMAC_DM646X_CMINTMAX_INTVL
>>> +                                                             * addnl_dvdr))
>>> +                                             coal_intvl = (EMAC_DM646X_CMINTMAX_INTVL
>>> +                                                             * addnl_dvdr);
>>> +                             } else {
>>> +                                     addnl_dvdr = 1;
>>> +                                     coal_intvl = EMAC_DM646X_CMINTMAX_INTVL;
>>> +                             }
>>>                        }
>>> -             }
>>>
>>> -             num_interrupts = (1000 * addnl_dvdr) / coal_intvl;
>>> +                     num_interrupts = (1000 * addnl_dvdr) / coal_intvl;
>>> +
>>> +                     int_ctrl |= EMAC_DM646X_INTPACEEN;
>>> +                     int_ctrl &= (~EMAC_DM646X_INTPRESCALE_MASK);
>>> +                     int_ctrl |= (prescale & EMAC_DM646X_INTPRESCALE_MASK);
>>> +             }
>>>
>>> -             int_ctrl |= EMAC_DM646X_INTPACEEN;
>>> -             int_ctrl &= (~EMAC_DM646X_INTPRESCALE_MASK);
>>> -             int_ctrl |= (prescale & EMAC_DM646X_INTPRESCALE_MASK);
>>>                emac_ctrl_write(EMAC_DM646X_CMINTCTRL, int_ctrl);
>>>
>>>                emac_ctrl_write(EMAC_DM646X_CMRXINTMAX, num_interrupts);
>>> @@ -466,17 +467,21 @@ static int emac_set_coalesce(struct net_device *ndev,
>>>        default:
>>>                int_ctrl = emac_ctrl_read(EMAC_CTRL_EWINTTCNT);
>>>                int_ctrl &= (~EMAC_DM644X_EWINTCNT_MASK);
>>> -             prescale = coal_intvl * priv->bus_freq_mhz;
>>> -             if (prescale > EMAC_DM644X_EWINTCNT_MASK) {
>>> -                     prescale = EMAC_DM644X_EWINTCNT_MASK;
>>> -                     coal_intvl = prescale / priv->bus_freq_mhz;
>>> +
>>> +             if (coal->rx_coalesce_usecs) {
>>> +                     prescale = coal_intvl * priv->bus_freq_mhz;
>>> +                     if (prescale > EMAC_DM644X_EWINTCNT_MASK) {
>>> +                             prescale = EMAC_DM644X_EWINTCNT_MASK;
>>> +                             coal_intvl = prescale / priv->bus_freq_mhz;
>>> +                     }
>>>                }
>>> +
>>>                emac_ctrl_write(EMAC_CTRL_EWINTTCNT, (int_ctrl | prescale));
>>>
>>>                break;
>>>        }
>>>
>>> -     printk(KERN_INFO"Set coalesce to %d usecs.\n", coal_intvl);
>>> +     netdev_info(ndev, "Set coalesce to %d usecs.\n", coal_intvl);
>>>        priv->coal_intvl = coal_intvl;
>>>
>>>        return 0;
>>>
>>
>> --
>> Best regards,
>> grygorii

-- 
Best regards,
grygorii
