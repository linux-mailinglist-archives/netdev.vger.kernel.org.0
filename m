Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5926459A0
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiLGMKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiLGMKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:10:48 -0500
Received: from serv108.segi.ulg.ac.be (serv108.segi.ulg.ac.be [139.165.32.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD26736C66;
        Wed,  7 Dec 2022 04:10:46 -0800 (PST)
Received: from [192.168.1.62] (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 56932200DBB3;
        Wed,  7 Dec 2022 13:10:45 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 56932200DBB3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1670415045;
        bh=z1bRtHorjKVQmxkQtm9H7dafDq0EWeh3vQ0UTqSTFJs=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=EO/p3UqmaYeYCfdniV1S6VFvaIqTLa2s/8v8Jm4P2Xw8wQa+yHyLKbStTnQlYXLPL
         YrfmVLbJ0jN8bq1YBXwTKcRNswPTt1NjJq0qNaJHNQbOEOfu+WbjfuOWdMG62W5Dke
         ElM82rYx+2olVvXlFZJM+0KPJzQ0MVR+3Yo2pLe1CBIhcezud77i5yPDzo8zScyWbp
         TC3ytvYod7DziKE3O2oV03cZdH6KiZ4vIoaRJj+Jcj7xggPV7/2QlvmIFkI4OPKqkw
         U81rL5OdxV0yFO336wV/5S96wJOVUvzAytmLRNMGafIgxYBYfVyfRsxJxwE4A4ZPdR
         k9FEwDztV+lug==
Message-ID: <d9269f66-17ee-2682-3a0a-94cbdc985614@uliege.be>
Date:   Wed, 7 Dec 2022 13:10:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC net] Fixes: b63c5478e9cb ("ipv6: ioam: Support for Queue
 depth data field")
Content-Language: en-US
From:   Justin Iurman <justin.iurman@uliege.be>
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
In-Reply-To: <1328d117-70b5-b03c-c0be-cd046d728d53@uliege.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/22 13:07, Justin Iurman wrote:
> On 12/6/22 21:43, Jakub Kicinski wrote:
>> On Mon, 5 Dec 2022 21:44:09 +0100 Justin Iurman wrote:
>>>> Please revert this patch.
>>>>
>>>> Many people use FQ qdisc, where packets are waiting for their Earliest
>>>> Departure Time to be released.
>>>
>>> The IOAM queue depth is a very important value and is already used.
>>
>> Can you say more about the use? What signal do you derive from it?
>> I do track qlen on Meta's servers but haven't found a strong use
>> for it yet (I did for backlog drops but not the qlen itself).
> 
> The specification goal of the queue depth was initially to be able to 
> track the entire path with a detailed view for packets or flows (kind of 
> a zoom on the interface to have details about its queues). With the 
> current definition/implementation of the queue depth, if only one queue 
> is congested, you're able to know it. Which doesn't necessarily mean 
> that all queues are full, but this one is and there might be something 
> going on. And this is something operators might want to be able to 
> detect precisely, for a lot of use cases depending on the situation. On 
> the contrary, if all queues are full, then you could deduce that as well 
> for each queue separately, as soon as a packet is assigned to it. So I 
> think that with "queue depth = sum(queues)", you don't have details and 
> you're not able to detect a single queue congestion, while with "queue 
> depth = queue" you could detect both. One might argue that it's fine to 
> only have the aggregation in some situation. I'd say that we might need 
> both, actually. Which is technically possible (even though expensive, as 
> Eric mentioned) thanks to the way it is specified by the RFC, where some 
> freedom was intentionally given. I could come up with a solution for that.
> 
>>>> Also, the draft says:
>>>>
>>>> 5.4.2.7.  queue depth
>>>>
>>>>      The "queue depth" field is a 4-octet unsigned integer field.  This
>>>>      field indicates the current length of the egress interface 
>>>> queue of
>>>>      the interface from where the packet is forwarded out.  The queue
>>>>      depth is expressed as the current amount of memory buffers used by
>>>>      the queue (a packet could consume one or more memory buffers,
>>>>      depending on its size).
>>>>
>>>>       0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
>>>>      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>>>>      |                       queue depth                             |
>>>>      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>>>>
>>>>
>>>> It is relatively clear that the egress interface is the aggregate
>>>> egress interface,
>>>> not a subset of the interface.
>>>
>>> Correct, even though the definition of an interface in RFC 9197 is quite
>>> abstract (see the end of section 4.4.2.2: "[...] could represent a
>>> physical interface, a virtual or logical interface, or even a queue").
>>>
>>>> If you have 32 TX queues on a NIC, all of them being backlogged 
>>>> (line rate),
>>>> sensing the queue length of one of the queues would give a 97% error
>>>> on the measure.
>>>
>>> Why would it? Not sure I get your idea based on that example.
>>
>> Because it measures the length of a single queue not the device.
> 
> Yep, I figured that out after the off-list discussion we've had with Eric.
> 
> So my plan would be, if you all agree with, to correct and repost this 
> patch to fix the NULL qdisc issue. Then, I'd come with a solution to 
> allow both (with and without aggregation of queues) and post it on 
> net-next. But again, if the consensus is to revert this patch (which I 
> think would bring no benefit IMHO), then so be it. Thoughts?

And by "revert this patch", I meant revert b63c5478e9cb, sorry.
