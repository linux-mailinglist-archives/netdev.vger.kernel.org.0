Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D32745ADAC
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 21:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbhKWU7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 15:59:40 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:16486 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbhKWU7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 15:59:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637700809;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=Q+DkUziyd5A/+y6V3V4Ix0YFQ8f32VgpRK5LfdXkPlw=;
    b=HJPMP05mf22uELtFTqWUquQdwMlYZ8Wowlqc0KRigW2RPX78CMdWEXb5LuGazDfLKL
    aNNBoYIFalbJvJIQjEEdtylQ1cwwq6tNmu0Gwr9b3ob0KVdIDyPaF6Xch66o9Cy/DMnU
    WtTcMlHMGzUzqkkOb59AcP0rg5hrbYKQ9Nra9Lr81/oLHxGQnfoM2fUDjT2KpPxZycEm
    rIfVVaC244WOoyAYUawkWww/S4yKGR58ZeTMduKbJp8t4AVRgK2aWEOd4aZRgKQV3J9z
    4glBiXiJCItB2X8UQ1Ks53cnHq02qpf4Ip2AekRJY4zu+VuoiQ3xzM3jwHcV0eQuIhVO
    sagA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.34.6 AUTH)
    with ESMTPSA id a04d59xANKrT6ZV
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 23 Nov 2021 21:53:29 +0100 (CET)
Subject: Re: [PATCH] can: bittiming: replace CAN units with the SI metric
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
References: <20211119161850.202094-1-mailhol.vincent@wanadoo.fr>
 <38544770-9e5f-1b1b-1f0a-a7ff1719327d@hartkopp.net>
 <CAMZ6RqJobmUnAMUjnaqYh0jsOPw7-PwiF+bF79hy6h+8SCuuDg@mail.gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <73c3b9cb-3b46-1523-d926-4bdf86de3fb8@hartkopp.net>
Date:   Tue, 23 Nov 2021 21:53:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAMZ6RqJobmUnAMUjnaqYh0jsOPw7-PwiF+bF79hy6h+8SCuuDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent,

On 22.11.21 03:22, Vincent MAILHOL wrote:
> Le lun. 22 nov. 2021 à 03:27, Oliver Hartkopp <socketcan@hartkopp.net> a écrit :


>>>    #include <linux/kernel.h>
>>> +#include <linux/units.h>
>>>    #include <asm/unaligned.h>
>>>
>>>    #include "es58x_core.h"
>>> @@ -469,8 +470,8 @@ const struct es58x_parameters es581_4_param = {
>>>        .bittiming_const = &es581_4_bittiming_const,
>>>        .data_bittiming_const = NULL,
>>>        .tdc_const = NULL,
>>> -     .bitrate_max = 1 * CAN_MBPS,
>>> -     .clock = {.freq = 50 * CAN_MHZ},
>>> +     .bitrate_max = 1 * MEGA,
>>> +     .clock = {.freq = 50 * MEGA},
>>
>> IMO we are losing information here.
>>
>> It feels you suggest to replace MHz with M.
> 
> When I introduced the CAN_{K,M}BPS and CAN_MHZ macros, my primary
> intent was to avoid having to write more than five zeros in a
> row (because the human brain is bad at counting those). And the
> KILO/MEGA prefixes perfectly cover that intent.
> 
> You are correct to say that the information of the unit is
> lost. But I assume this information to be implicit (frequencies
> are in Hz, baudrate are in bits/second). So yes, I suggest
> replacing MHz with M.
> 
> Do you really think that people will be confused by this change?

It is not about confusing people but about the quality of documentation 
and readability.

> 
> I am not strongly opposed to keeping it either (hey, I was the
> one who introduced it in the first place). I just think that
> using linux/units.h is sufficient.
> 
>> So where is the Hz information then?
> 
> It is in the comment of can_clock:freq :)
> 
> https://elixir.bootlin.com/linux/v5.15/source/include/uapi/linux/can/netlink.h#L63

Haha, you are funny ;-)

But the fact that you provide this URL shows that the information is not 
found or easily accessible when someone reads the code here.

>>> -     .bitrate_max = 8 * CAN_MBPS,
>>> -     .clock = {.freq = 80 * CAN_MHZ},
>>> +     .bitrate_max = 8 * MEGA,
>>> +     .clock = {.freq = 80 * MEGA},

What about

+     .bitrate_max = 8 * MEGA, /* bits per second */
+     .clock = {.freq = 80 * MEGA}, /* Hz */

which uses the SI constants but maintains the unit?

Best regards,
Oliver

