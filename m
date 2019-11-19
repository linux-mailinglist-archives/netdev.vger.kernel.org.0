Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBE2102E04
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 22:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfKSVJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 16:09:19 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44868 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfKSVJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 16:09:19 -0500
Received: by mail-pl1-f195.google.com with SMTP id az9so12524190plb.11;
        Tue, 19 Nov 2019 13:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=540qf/bm5KNNA99hBGUVZOgA79LIDKy75tuXaffYbt4=;
        b=oKGpGWgynQH9ILYGsyHsX31+GjtrcYbP9aVt91ZRjLLzZhK/UGcnwlnPPwjaTFpY5v
         DqGFcB8M3yVBV3u19g31aeIoAKp0SiOeibtGsMi7uFN20gMBrrFH32nHDFegSsqPmpHP
         cnydPu1sG+uq3t7cOUcDFNOC7sr65zdgkGYswFOGN61LUCZOhGUdR/feNrGEWsZGk7qh
         ZleCpfaEl6dxmb7gwoF/Xgv9aTBg1d5ln/zjA4xLazUGVukTDJjbkokVOMixQMpKi7EO
         qmLWrxzi0AVT8iUTDeIMaEWR9r5gVU21r2KYcNHHARCAHqHNLQz25bPA2gHu9aSRYpV3
         dU2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=540qf/bm5KNNA99hBGUVZOgA79LIDKy75tuXaffYbt4=;
        b=MPvKIBdi1QKCTgSRZOChgghkhECmEFam8rO8mdDjFRAf1Hqz+kCQZcyRHlWaBD4IXD
         DqY4JnnjY+fwUwW8/Z42Ib74hYr2JaF90B5AJ7lI2QwKMTz+JEhqKYzVYmKkuFk5Fj1E
         cC2rtnKKECh26WRefdUKawZUE4raUunN4rjMB7uLe6DU9IRdPMITF02vXqax4DyKoHDa
         EU79GRbMaVNq97msKYzT8hEBWHblUkYLgYo5IAaodOGV/S7V89Fq+cVPgPufOoJfkItZ
         tov1u/rM5mCB1loqdfCeV9Q8BQ/4GNbOGJ6S0uvFze0Ua5WOc6ApyHtKzzCsuZxmyJUs
         WUrw==
X-Gm-Message-State: APjAAAWFfM6kBRQ30Q5sjMGQkiixYsSmcTWsVmLWKX1pfey5Q2jDWQ7x
        QBYPQNsr/dgMY4ISj/w4YSY=
X-Google-Smtp-Source: APXvYqzKTah3FltRWuH5uhmLTEFkDzCBgApiVxtKBu7r5/lKFfyo2Piv4hieGubZghGC8/y9Q2LAeQ==
X-Received: by 2002:a17:90a:3522:: with SMTP id q31mr9154747pjb.18.1574197758251;
        Tue, 19 Nov 2019 13:09:18 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id y24sm28215358pfr.116.2019.11.19.13.09.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 13:09:17 -0800 (PST)
Subject: Re: KMSAN: uninit-value in can_receive
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        syzbot <syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com>,
        davem@davemloft.net, glider@google.com, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000005c08d10597a3a05d@google.com>
 <a5f73d92-fdf2-2590-c863-39a181dca8e1@hartkopp.net>
 <deedd609-6f3b-8035-47e1-252ab221faa1@pengutronix.de>
 <7934bc2b-597f-0bb3-be2d-32f3b07b4de9@hartkopp.net>
 <7f5c4546-0c1a-86ae-581e-0203b5fca446@pengutronix.de>
 <1f7d6ea7-152e-ff18-549c-b196d8b5e3a7@hartkopp.net>
 <9e06266a-67f3-7352-7b87-2b9144c7c9a9@gmail.com>
 <3142c032-e46a-531c-d1b8-d532e5b403a6@hartkopp.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <92c04159-b83a-3e33-91da-25a727a692d0@gmail.com>
Date:   Tue, 19 Nov 2019 13:09:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <3142c032-e46a-531c-d1b8-d532e5b403a6@hartkopp.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/19/19 12:24 PM, Oliver Hartkopp wrote:
> Hi Eric,
> 
> On 19/11/2019 17.53, Eric Dumazet wrote:
>>
>>
>> On 11/18/19 11:35 PM, Oliver Hartkopp wrote:
>>>
>>
>>>
>>> See ioctl$ifreq https://syzkaller.appspot.com/x/log.txt?x=14563416e00000
>>>
>>> 23:11:34 executing program 2:
>>> r0 = socket(0x200000000000011, 0x3, 0x0)
>>> ioctl$ifreq_SIOCGIFINDEX_vcan(r0, 0x8933, &(0x7f0000000040)={'vxcan1\x00', <r1=>0x0})
>>> bind$packet(r0, &(0x7f0000000300)={0x11, 0xc, r1}, 0x14)
>>> sendmmsg(r0, &(0x7f0000000d00), 0x400004e, 0x0)
>>>
>>> We only can receive skbs from (v(x))can devices.
>>> No matter if someone wrote to them via PF_CAN or PF_PACKET.
>>> We check for ETH_P_CAN(FD) type and ARPHRD_CAN dev type at rx time.
>>
>> And what entity sets the can_skb_prv(skb)->skbcnt to zero exactly ?
>>
>>>
>>>>> We additionally might think about introducing a check whether we have a
>>>>> can_skb_reserve() created skbuff.
>>>>>
>>>>> But even if someone forged a skbuff without this reserved space the
>>>>> access to can_skb_prv(skb)->skbcnt would point into some CAN frame
>>>>> content - which is still no access to uninitialized content, right?
>>>
>>> So this question remains still valid whether we have a false positive from KMSAN here.
>>
>> I do not believe it is a false positive.
>>
>> It seems CAN relies on some properties of low level drivers using alloc_can_skb() or similar function.
>>
>> Why not simply fix this like that ?
>>
>> diff --git a/net/can/af_can.c b/net/can/af_can.c
>> index 128d37a4c2e0ba5d8db69fcceec8cbd6a79380df..3e71a78d82af84caaacd0ef512b5e894efbf4852 100644
>> --- a/net/can/af_can.c
>> +++ b/net/can/af_can.c
>> @@ -647,8 +647,9 @@ static void can_receive(struct sk_buff *skb, struct net_device *dev)
>>          pkg_stats->rx_frames_delta++;
>>            /* create non-zero unique skb identifier together with *skb */
>> -       while (!(can_skb_prv(skb)->skbcnt))
>> +       do {
>>                  can_skb_prv(skb)->skbcnt = atomic_inc_return(&skbcounter);
>> +       } while (!(can_skb_prv(skb)->skbcnt));
>>            rcu_read_lock();
>>   
> 
> Please check commit d3b58c47d330d ("can: replace timestamp as unique skb attribute").

Oh well... This notion of 'unique skb attribute' is interesting...

> 
> can_skb_prv(skb)->skbcnt is set to 0 at skb creation time when sending CAN frames from local host or receiving CAN frames from a real CAN interface.

We can not enforce this to happen with a virtual interface.

> 
> When a CAN skb is received by the net layer the *first* time it gets a unique value which we need for a per-cpu filter mechanism in raw_rcv().
> 
> So where's the problem to check for (!(can_skb_prv(skb)->skbcnt)) in a while statement? I can't see a chance for an uninitialized value there.

You have to make sure the packet has been properly cooked by a 'real CAN interface' then, and reject them if not.


