Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FBC6752B1
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 11:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjATKm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 05:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjATKmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 05:42:25 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B81A7935
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:42:22 -0800 (PST)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1pIoqa-00084W-3b; Fri, 20 Jan 2023 11:42:12 +0100
Message-ID: <55b34928-e5b0-7ab7-fa40-5ae73d05a269@pengutronix.de>
Date:   Fri, 20 Jan 2023 11:42:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net] net: dsa: microchip: fix probe of I2C-connected
 KSZ8563
Content-Language: en-US
To:     Arun.Ramadoss@microchip.com, olteanv@gmail.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        kuba@kernel.org, Woojung.Huh@microchip.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, pabeni@redhat.com, ore@pengutronix.de,
        edumazet@google.com
References: <20230119131014.1228773-1-a.fatoum@pengutronix.de>
 <64af7536214a55f3edb30d5f7ec54184cac1048c.camel@microchip.com>
 <a2d900dd-7a03-1185-75be-a4ac54ccf6e8@pengutronix.de>
 <a453da7bd4e1a0ea1da7cb1da4fa9b2c73a10a44.camel@microchip.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <a453da7bd4e1a0ea1da7cb1da4fa9b2c73a10a44.camel@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.01.23 11:38, Arun.Ramadoss@microchip.com wrote:
> On Fri, 2023-01-20 at 08:57 +0100, Ahmad Fatoum wrote:
>>> In this commit, there is no KSZ8563 member in struct
>>> ksz_switch_chips.
>>> Whether the fixes should be to this commit "net: dsa: microchip:
>>> add
>>> separate struct ksz_chip_data for KSZ8563" where the member is
>>> introduced.
>>
>> I disagree. eee16b147121 introduced the check that made my device
>> not probe anymore, so that's what's referenced in Fixes:. Commit
>> b44908095612 should have had a Fixes: pointing at eee16b147121
>> as well, so users don't miss it. But if they miss it, they
>> will notice this at build-time anyway.
> 
> The KSZ9893, KSZ9563 and KSZ8563 all has the same chip id 0x00989300.
> They belong to 3 port switch family. Differentiation is done based on
> 0x1F register. In the commit eee16b147121, there is no differentiation
> based on 0x1F, device is selected based on chip id, all the three chips
> will be identified as ksz9893 only. After the commit b44908095612,
> KSZ8563 chips is identified based on 0x1F register.

Thanks for the elaboration. I see it now. I will send a v2
with revised commit messages and Fixes:. Should I include
your Reviewed-by: with the commit message rewritten?

Cheers,
Ahmad

> 
>>
>> Cheers,
>> Ahmad
>>
>>>
>>>> chip
>>>> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
>>>> ---
>>>>  drivers/net/dsa/microchip/ksz9477_i2c.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c
>>>> b/drivers/net/dsa/microchip/ksz9477_i2c.c
>>>> index c1a633ca1e6d..e315f669ec06 100644
>>>> --- a/drivers/net/dsa/microchip/ksz9477_i2c.c
>>>> +++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
>>>> @@ -104,7 +104,7 @@ static const struct of_device_id
>>>> ksz9477_dt_ids[]
>>>> = {
>>>>         },
>>>>         {
>>>>                 .compatible = "microchip,ksz8563",
>>>> -               .data = &ksz_switch_chips[KSZ9893]
>>>> +               .data = &ksz_switch_chips[KSZ8563]
>>>>         },
>>>>         {
>>>>                 .compatible = "microchip,ksz9567",
>>>> --
>>>> 2.30.2
>>>>
>>
>> --
>> Pengutronix
>> e.K.                           |                             |
>> Steuerwalder Str. 21                       | 
>> http://www.pengutronix.de/e/  |
>> 31137 Hildesheim, Germany                  | Phone: +49-5121-206917-
>> 0    |
>> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-
>> 5555 |
>>

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

