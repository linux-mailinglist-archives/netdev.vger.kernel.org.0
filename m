Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E025E5245A0
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 08:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350141AbiELGXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 02:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350286AbiELGXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 02:23:43 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154AA57128;
        Wed, 11 May 2022 23:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1652336612;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:References:Cc:To:From:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ZkBIc6Q0gdXP/pnup3PEDcuxEaaZqb9pnmXBD1pB/hs=;
    b=E3yNUkKGbNwForlz0XMhl2Eb4xLzU299V/ZfyWT6DFFir7OT3n/nU4bpVZfQpnXvaT
    Of1ObQ5uHY0/f4vKiW1t523oUUqRrZSGVUXjhNjFEuRhHSVdWM3yk6GNgQY7GoRZjO+W
    Ho4mXXS4iyIxFOlQM28vlRfG2SdA2ITosBw69RHs92ufSMO/0v47Vjqq71pDbBAlDPyU
    z2/JMO9zkJ/IDJTeBNg1cMcauCQO+4gqEeA9a12QgXY3zFfP9XC2eVQI3h/meik48IZC
    lfaRFBPgFRZ/GqOP6Bdg8i4rwDvxTn7L97PSwHTrtaxjitIT+O3v3wk9YJ3K9DSWv5S4
    8N6g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdBqPeOuh2krLEWFUg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cff:5b00::b82]
    by smtp.strato.de (RZmta 47.42.2 AUTH)
    with ESMTPSA id 4544c9y4C6NWzZI
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 12 May 2022 08:23:32 +0200 (CEST)
Message-ID: <f6cb7e44-226b-cffb-d907-9014075cdcb5@hartkopp.net>
Date:   Thu, 12 May 2022 08:23:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/1] can: skb: add and set local_origin flag
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
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
 <3c6bf83c-0d91-ea43-1a5d-27df7db1fb08@hartkopp.net>
In-Reply-To: <3c6bf83c-0d91-ea43-1a5d-27df7db1fb08@hartkopp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On 11.05.22 16:57, Oliver Hartkopp wrote:
> 
> 
> On 5/11/22 16:54, Marc Kleine-Budde wrote:
>> On 11.05.2022 16:50:06, Oliver Hartkopp wrote:
>>>
>>>
>>> On 5/11/22 16:36, Marc Kleine-Budde wrote:
>>>> On 11.05.2022 15:24:21, Marc Kleine-Budde wrote:
>>>>> On 11.05.2022 14:38:32, Oliver Hartkopp wrote:
>>>>>> IMO this patch does not work as intended.
>>>>>>
>>>>>> You probably need to revisit every place where can_skb_reserve() 
>>>>>> is used,
>>>>>> e.g. in raw_sendmsg().
>>>>>
>>>>> And the loopback for devices that don't support IFF_ECHO:
>>>>>
>>>>> | https://elixir.bootlin.com/linux/latest/source/net/can/af_can.c#L257
>>>>
>>>> BTW: There is a bug with interfaces that don't support IFF_ECHO.
>>>>
>>>> Assume an invalid CAN frame is passed to can_send() on an interface 
>>>> that
>>>> doesn't support IFF_ECHO. The above mentioned code does happily 
>>>> generate
>>>> an echo frame and it's send, even if the driver drops it, due to
>>>> can_dropped_invalid_skb(dev, skb).
>>>>
>>>> The echoed back CAN frame is treated in raw_rcv() as if the headroom 
>>>> is valid:
I double checked that code and when I didn't miss anything all the 
callers of can_send() (e.g. raw_sendmsg()) are creating valid skbs.

https://elixir.bootlin.com/linux/v5.17.6/A/ident/can_send

>>>>
>>>> | https://elixir.bootlin.com/linux/v5.17.6/source/net/can/raw.c#L138
>>>>
>>>> But as far as I can see the can_skb_headroom_valid() check never has
>>>> been done. What about this patch?
>>>>
>>>> index 1fb49d51b25d..fda4807ad165 100644
>>>> --- a/net/can/af_can.c
>>>> +++ b/net/can/af_can.c
>>>> @@ -255,6 +255,9 @@ int can_send(struct sk_buff *skb, int loop)
>>>>                    */
>>>>                   if (!(skb->dev->flags & IFF_ECHO)) {
>>>> +                       if (can_dropped_invalid_skb(dev, skb))
>>>> +                               return -EINVAL;
>>>> +

That would make this change unnecessary, right?

IIRC the reason for can_dropped_invalid_skb() is to prove valid skbs for 
CAN interface drivers when CAN frame skbs are created e.g. with 
PF_PACKET sockets.

Best,
Oliver


>>>
>>> Good point!
>>>
>>> But please check the rest of the code.
>>> You need 'goto inval_skb;' instead of the return ;-)
>>
>> Why? To free the skb? That's what can_dropped_invalid_skb() does, too:
>>
>> | 
>> https://elixir.bootlin.com/linux/v5.17.6/source/include/linux/can/skb.h#L130 
>>
>>
> 
> My bad!
> 
> Pointing you not reading the code ... should better have looked myself :-D
> 
