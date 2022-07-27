Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F4E5833FE
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 22:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbiG0UP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 16:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiG0UPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 16:15:25 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848504F6AB;
        Wed, 27 Jul 2022 13:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1658952734;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=zf3hu7M3LvvEmzfKZIjNzdc/JfMNFzqSTpMxpu54JFk=;
    b=NWM1ZklkAQkxY8sVcrnmQ6XqisOoSiNw3AKr/n8DDwn3BbXMnSTJ6IBpYBZKjtOI8e
    CRTt13uKFhHTSE0iSIO7yEOUnGKPn0slpRIlnanx9Dz8ITIvRnbJB0BLegWv2d97cWP5
    ImUbDxO3TlK/KLBxMhqe5OqF/ceUxqh/V+5rMNvkYGEScLj71qwsS+ZczsdC2PFPynkd
    2IJ9dTHCtUP9WFRH/E+eWhYmV7p0QPQE6iS3QpUzpGNYr3f7xuXy/rxbrMTo+aGoYeaq
    7ZxiJWh9If1eQ2Iy/6QGSPL9vKbkgYn3VISp3K6QkKLaXtFURBkGXoS1lwwOdXXkaCdX
    Fc4w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytJSr63tDxrw=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d100::b82]
    by smtp.strato.de (RZmta 47.47.0 AUTH)
    with ESMTPSA id Icb1b0y6RKCD5ow
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 27 Jul 2022 22:12:13 +0200 (CEST)
Message-ID: <fb31bfeb-e7bc-c7f8-db2c-f8d0c531af99@hartkopp.net>
Date:   Wed, 27 Jul 2022 22:12:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH v3 8/9] can: slcan: add support to set bit time
 register (btr)
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>, Max Staudt <max@enpas.org>
Cc:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
References: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
 <20220726210217.3368497-9-dario.binacchi@amarulasolutions.com>
 <20220727113054.ffcckzlcipcxer2c@pengutronix.de>
 <20220727192839.707a3453.max@enpas.org>
 <20220727182414.3mysdeam7mtnqyfx@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220727182414.3mysdeam7mtnqyfx@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27.07.22 20:24, Marc Kleine-Budde wrote:
> On 27.07.2022 19:28:39, Max Staudt wrote:
>> On Wed, 27 Jul 2022 13:30:54 +0200
>> Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>>
>>> As far as I understand, setting the btr is an alternative way to set the
>>> bitrate, right? I don't like the idea of poking arbitrary values into a
>>> hardware from user space.
>>
>> I agree with Marc here.
>>
>> This is a modification across the whole stack, specific to a single
>> device, when there are ways around.
>>
>> If I understand correctly, the CAN232 "S" command sets one of the fixed
>> bitrates, whereas "s" sets the two BTR registers. Now the question is,
>> what do BTR0/BTR1 mean, and what are they? If they are merely a divider
>> in a CAN controller's master clock, like in ELM327, then you could
>>
>>    a) Calculate the BTR values from the bitrate userspace requests, or
> 
> Most of the other CAN drivers write the BTR values into the register of
> the hardware. How are these BTR values transported into the driver?
> 
> There are 2 ways:
> 
> 1) - user space configures a bitrate
>     - the kernel calculates with the "struct can_bittiming_const" [1] given
>       by driver and the CAN clock rate the low level timing parameters.
> 
>       [1] https://elixir.bootlin.com/linux/v5.18/source/include/uapi/linux/can/netlink.h#L47
> 
> 2) - user space configures low level bit timing parameter
>       (Sample point in one-tenth of a percent, Time quanta (TQ) in
>        nanoseconds, Propagation segment in TQs, Phase buffer segment 1 in
>        TQs, Phase buffer segment 2 in TQs, Synchronisation jump width in
>        TQs)
>      - the kernel calculates the Bit-rate prescaler from the given TQ and
>        CAN clock rate
> 
> Both ways result in a fully calculated "struct can_bittiming" [2]. The
> driver translates this into the hardware specific BTR values and writes
> the into the registers.
> 
> If you know the CAN clock and the bit timing const parameters of the
> slcan's BTR register you can make use of the automatic BTR calculation,
> too. Maybe the framework needs some tweaking if the driver supports both
> fixed CAN bit rate _and_ "struct can_bittiming_const".
> 
> [2] https://elixir.bootlin.com/linux/v5.18/source/include/uapi/linux/can/netlink.h#L31
> 
>>    b) pre-calculate a huge table of possible bitrates and present them
>>       all to userspace. Sounds horrible, but that's what I did in can327,
>>       haha. Maybe I should have reigned them in a little, to the most
>>       useful values.
> 
> If your adapter only supports fixed values, then that's the only way to
> go.
> 
>>    c) just limit the bitrates to whatever seems most useful (like the
>>       "S" command's table), and let users complain if they really need
>>       something else. In the meantime, they are still free to slcand or
>>       minicom to their heart's content before attaching slcan, thanks to
>>       your backwards compatibility efforts.
> 
> In the early stages of the non-mainline CAN framework we had tables for
> BTR values for some fixed bit rates, but that turned out to be not
> scaleable.

The Microchip CAN BUS Analyzer Tool is another example for fixed bitrates:

https://elixir.bootlin.com/linux/v5.18.14/source/drivers/net/can/usb/mcba_usb.c#L156

So this might be the way to go here too ...

Best regards,
Oliver

> 
>> In short, to me, this isn't a deal breaker for your patch series.
> 
> Marc
> 
