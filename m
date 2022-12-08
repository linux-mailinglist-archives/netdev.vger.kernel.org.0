Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69AEC646FF5
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 13:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiLHMsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 07:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiLHMsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 07:48:03 -0500
Received: from serv108.segi.ulg.ac.be (serv108.segi.ulg.ac.be [139.165.32.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08848E03C;
        Thu,  8 Dec 2022 04:47:56 -0800 (PST)
Received: from [192.168.1.62] (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 17312200F808;
        Thu,  8 Dec 2022 13:47:51 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 17312200F808
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1670503671;
        bh=9TKnWiK17TX0hRM16//Xc7kqS9ZHyCg6RgPTp/wd11U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=CfV/H4Ctrf4nwD6aOORQRNSNglYsdH6ZJr2ZUCNtt6dyrdfYyXA22EVj1GNVS2pNx
         6zNvJdW6i5mlfawEenZw/yiaoh65w5ek3xnnaVglNBa+BVetk8YFX8YoAMqkaDfBVu
         F4DNqAIZUrHj1WRXJ7J/soB8GYskCX9Po7KDfaKAAwkT1X72Es/2HkNhLweBRhwKLR
         vz4gtuG8tiJvay6cKEQAbNB5WB3tWb7672NDZxQQeY6cuWysNSuxzJoey1w/IwkPsV
         6hvumVckygQyLjfgIzmahP8tt8TgyQsQNGcF4eTwVENjf6w4E9F4tUV3sXB2+QII5F
         wr3xosgLAN52Q==
Message-ID: <748a406d-642c-9aff-305d-bc3b8dfd0bed@uliege.be>
Date:   Thu, 8 Dec 2022 13:47:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC net] Fixes: b63c5478e9cb ("ipv6: ioam: Support for Queue
 depth data field")
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, stable@vger.kernel.org
References: <20221205153557.28549-1-justin.iurman@uliege.be>
 <CANn89iLjGnyh0GgW_5kkMQJBCi-KfgwyvZwT1ou2FMY4ZDcMXw@mail.gmail.com>
 <CANn89iK3hMpJQ1w4peg2g35W+Oi3t499C5rUv7rcwzYtxDGBuw@mail.gmail.com>
 <a8dcb88c-16be-058b-b890-5d479d22c8a8@uliege.be>
 <CANn89iKgeVFRAstW3QRwOdn8SV_EbHqcKYqmoWT6m5nGQwPWUg@mail.gmail.com>
 <d579c817-50c7-5bd5-4b28-f044daabf7f6@uliege.be>
 <20221206124342.7f429399@kernel.org>
 <1328d117-70b5-b03c-c0be-cd046d728d53@uliege.be>
 <20221207160418.68e408c3@kernel.org>
From:   Justin Iurman <justin.iurman@uliege.be>
In-Reply-To: <20221207160418.68e408c3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/22 01:04, Jakub Kicinski wrote:
> On Wed, 7 Dec 2022 13:07:18 +0100 Justin Iurman wrote:
>>> Can you say more about the use? What signal do you derive from it?
>>> I do track qlen on Meta's servers but haven't found a strong use
>>> for it yet (I did for backlog drops but not the qlen itself).
>>
>> The specification goal of the queue depth was initially to be able to
>> track the entire path with a detailed view for packets or flows (kind of
>> a zoom on the interface to have details about its queues). With the
>> current definition/implementation of the queue depth, if only one queue
>> is congested, you're able to know it. Which doesn't necessarily mean
>> that all queues are full, but this one is and there might be something
>> going on. And this is something operators might want to be able to
>> detect precisely, for a lot of use cases depending on the situation. On
>> the contrary, if all queues are full, then you could deduce that as well
>> for each queue separately, as soon as a packet is assigned to it. So I
>> think that with "queue depth = sum(queues)", you don't have details and
>> you're not able to detect a single queue congestion, while with "queue
>> depth = queue" you could detect both. One might argue that it's fine to
>> only have the aggregation in some situation. I'd say that we might need
>> both, actually. Which is technically possible (even though expensive, as
>> Eric mentioned) thanks to the way it is specified by the RFC, where some
>> freedom was intentionally given. I could come up with a solution for that.
> 
> Understood. My hope was that by now there was some in-field experience
> which could help us judge how much signal can one derive from a single
> queue. Or a user that could attest.

I asked the people concerned. I'll get back to you.

>>> Because it measures the length of a single queue not the device.
>>
>> Yep, I figured that out after the off-list discussion we've had with Eric.
>>
>> So my plan would be, if you all agree with, to correct and repost this
>> patch to fix the NULL qdisc issue. Then, I'd come with a solution to
>> allow both (with and without aggregation of queues) and post it on
>> net-next. But again, if the consensus is to revert this patch (which I
>> think would bring no benefit IMHO), then so be it. Thoughts?
> 
> To summarize - we have reservations about correctness and about

Ack. And this is exactly why I proposed the alternative of having both 
solutions implemented (i.e., a specific queue depth or an aggregation of 
queues per interface).

> breaking layering (ip6 calling down to net/sched).

Indeed. Funny enough, this one's going to be hard to beat. How 
frustrating when the value to be retrieved is there, but cannot be used. 
Especially when it's probably one of the most important metric from 
IOAM. I guess it's the price to pay when dealing with telemetry over 
multiple layers. Anyway...

> You can stick to your approach, respost and see if any of the other
> maintainer is willing to pick this up (i.e. missed this nack).
> If you ask for my option I'll side with Eric
Got it, thanks.
