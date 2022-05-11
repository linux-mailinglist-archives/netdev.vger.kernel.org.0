Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C52523671
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 16:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245441AbiEKO6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 10:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244533AbiEKO6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 10:58:06 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9FC20F4C6;
        Wed, 11 May 2022 07:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1652281071;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=xaR6s5/QWptKMXOs5sooqJ3794ArNGAXxaZwjDyLBPo=;
    b=LEDCh8kMG+ELS3FDK2MfiSK2mxTqus3ky7xLwfN9SLuEW8lTukm9YjP1F8TNol+ZK1
    1JFPZH/+nFX+AbmC3+g8N1qUME4meOPEeOaiNLJUvO5koaHRGOLVW3UEk3+Z3qd7Ws1c
    XcraidpU/1W9+jWegmV/JFayi2nf023bKy4agL0yWkng2L9L/4rsLiW3i9TAt5+54GNr
    MLVFDHR7KB4cjJc6eVNkoROSZ2JDhbFhwXL2jmNQ859QdqfCNo9KGrhISqfuVITkEoOW
    ZnQgi9SNtX4k3HqrOdBYImwDTV7QI1Lg5HeQlaMH3n1wV6h+r0GGaJZFR2CmJqry27H0
    lj2Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdBqPeOuh2koeKQvJnLjhchY2TXGXhEF98MlNg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cff:5b00:9642:f755:5daa:777e]
    by smtp.strato.de (RZmta 47.42.2 AUTH)
    with ESMTPSA id 4544c9y4BEvoybs
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 11 May 2022 16:57:50 +0200 (CEST)
Message-ID: <3c6bf83c-0d91-ea43-1a5d-27df7db1fb08@hartkopp.net>
Date:   Wed, 11 May 2022 16:57:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 1/1] can: skb: add and set local_origin flag
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Devid Antonio Filoni <devid.filoni@egluetechnologies.com>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
References: <20220511121913.2696181-1-o.rempel@pengutronix.de>
 <b631b022-72d5-9160-fd13-f33c80dbbe59@hartkopp.net>
 <20220511132421.7o5a3po32l3w2wcr@pengutronix.de>
 <20220511143620.kphwgp2vhjyoecs5@pengutronix.de>
 <002d234f-a7d6-7b1a-72f4-157d7a283446@hartkopp.net>
 <20220511145437.oezwkcprqiv5lfda@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220511145437.oezwkcprqiv5lfda@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/22 16:54, Marc Kleine-Budde wrote:
> On 11.05.2022 16:50:06, Oliver Hartkopp wrote:
>>
>>
>> On 5/11/22 16:36, Marc Kleine-Budde wrote:
>>> On 11.05.2022 15:24:21, Marc Kleine-Budde wrote:
>>>> On 11.05.2022 14:38:32, Oliver Hartkopp wrote:
>>>>> IMO this patch does not work as intended.
>>>>>
>>>>> You probably need to revisit every place where can_skb_reserve() is used,
>>>>> e.g. in raw_sendmsg().
>>>>
>>>> And the loopback for devices that don't support IFF_ECHO:
>>>>
>>>> | https://elixir.bootlin.com/linux/latest/source/net/can/af_can.c#L257
>>>
>>> BTW: There is a bug with interfaces that don't support IFF_ECHO.
>>>
>>> Assume an invalid CAN frame is passed to can_send() on an interface that
>>> doesn't support IFF_ECHO. The above mentioned code does happily generate
>>> an echo frame and it's send, even if the driver drops it, due to
>>> can_dropped_invalid_skb(dev, skb).
>>>
>>> The echoed back CAN frame is treated in raw_rcv() as if the headroom is valid:
>>>
>>> | https://elixir.bootlin.com/linux/v5.17.6/source/net/can/raw.c#L138
>>>
>>> But as far as I can see the can_skb_headroom_valid() check never has
>>> been done. What about this patch?
>>>
>>> index 1fb49d51b25d..fda4807ad165 100644
>>> --- a/net/can/af_can.c
>>> +++ b/net/can/af_can.c
>>> @@ -255,6 +255,9 @@ int can_send(struct sk_buff *skb, int loop)
>>>                    */
>>>                   if (!(skb->dev->flags & IFF_ECHO)) {
>>> +                       if (can_dropped_invalid_skb(dev, skb))
>>> +                               return -EINVAL;
>>> +
>>
>> Good point!
>>
>> But please check the rest of the code.
>> You need 'goto inval_skb;' instead of the return ;-)
> 
> Why? To free the skb? That's what can_dropped_invalid_skb() does, too:
> 
> | https://elixir.bootlin.com/linux/v5.17.6/source/include/linux/can/skb.h#L130
> 

My bad!

Pointing you not reading the code ... should better have looked myself :-D

