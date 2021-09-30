Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D4341D100
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 03:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347642AbhI3Bif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 21:38:35 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.183]:40692 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347601AbhI3Bie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 21:38:34 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.51.27])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1AF5A2A0064;
        Thu, 30 Sep 2021 01:36:52 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C3432600070;
        Thu, 30 Sep 2021 01:36:51 +0000 (UTC)
Received: from [192.168.1.115] (unknown [206.214.234.211])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 176CE13C2B0;
        Wed, 29 Sep 2021 18:36:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 176CE13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1632965811;
        bh=Y86CkdyUSWUyevWPqAQxLIVrkoMjCBCmweBRs/WBn54=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=ZnUKgNYx/sCadQSIra73FzhNu/ra2pa3q7B2vEo89RVksEirsHL914XT86BFN9N4M
         /ZoQQRgowTT2xrvjnpTMLWHPuNZrtNu/Pex95+xuADCwSmUEQYxeU6LGNr8PnVYgpD
         47vCQcztxBD3ctQuNakU4ciXiX0CaNFVyjCGRfVY=
Subject: Re: 5.15-rc3+ crash in fq-codel?
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>
References: <dfa032f3-18f2-22a3-80bf-f0f570892478@candelatech.com>
 <b6e8155e-7fae-16b0-59f0-2a2e6f5142de@gmail.com>
 <00e495ba-391e-6ad8-94a2-930fbc826a37@candelatech.com>
 <296232ac-e7ed-6e3c-36b9-ed430a21f632@candelatech.com>
 <7e87883e-42f5-2341-ab67-9f1614fb8b86@candelatech.com>
 <7f1d67f1-3a2c-2e74-bb86-c02a56370526@gmail.com>
 <88bc8a03-da44-fc15-f032-fe5cb592958b@candelatech.com>
 <b537053d-498d-928b-8ca0-e9daf5909128@gmail.com>
 <f3f1378d-6839-cd23-9e2c-4668947c2345@gmail.com>
 <41b4221b-be68-da96-8cbf-4297bb7ba821@gmail.com>
 <8768df9e-f1f6-db25-15d8-cabed2346f32@candelatech.com>
 <b7df0abb-8bdd-6348-a60a-75a66d6a9d91@candelatech.com>
 <c4000c2a-8894-c3f5-9497-82bce4615be1@gmail.com>
 <aa633585-0f0d-edf2-5659-72a49c1061c6@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <7a896ce5-ff52-0c44-752c-f6d238d6d8d9@candelatech.com>
Date:   Wed, 29 Sep 2021 18:36:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <aa633585-0f0d-edf2-5659-72a49c1061c6@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 8bit
X-MDID: 1632965812-uz3SdBa0JIRO
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/21 5:40 PM, Eric Dumazet wrote:
> 
> 
> On 9/29/21 5:29 PM, Eric Dumazet wrote:
>>
>>
>> On 9/29/21 5:04 PM, Ben Greear wrote:
>>> On 9/29/21 4:48 PM, Ben Greear wrote:
>>>> On 9/29/21 4:42 PM, Eric Dumazet wrote:
>>>>>
>>>>>
>>>>> On 9/29/21 4:28 PM, Eric Dumazet wrote:
>>>>>>
>>>>>
>>>>>>
>>>>>> Actually the bug seems to be in pktgen, vs NET_XMIT_CN
>>>>>>
>>>>>> You probably would hit the same issues with other qdisc also using NET_XMIT_CN
>>>>>>
>>>>>
>>>>> I would try the following patch :
>>>>>
>>>>> diff --git a/net/core/pktgen.c b/net/core/pktgen.c
>>>>> index a3d74e2704c42e3bec1aa502b911c1b952a56cf1..0a2d9534f8d08d1da5dfc68c631f3a07f95c6f77 100644
>>>>> --- a/net/core/pktgen.c
>>>>> +++ b/net/core/pktgen.c
>>>>> @@ -3567,6 +3567,7 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
>>>>>           case NET_XMIT_DROP:
>>>>>           case NET_XMIT_CN:
>>>>>                   /* skb has been consumed */
>>>>> +               pkt_dev->last_ok = 1;
>>>>>                   pkt_dev->errors++;
>>>>>                   break;
>>>>>           default: /* Drivers are not supposed to return other values! */
>>>
>>> While patching my variant of pktgen, I took a look at the 'default' case.  I think
>>> it should probably go above NET_XMIT_DROP and fallthrough into the consumed pkt path?
>>>
>>> Although, probably not a big deal since only bugs elsewhere would hit that path, and
>>> we don't really know if skb would be consumed in that case or not.
>>>
>>
>> This is probably dead code after commit
>>
>> commit f466dba1832f05006cf6caa9be41fb98d11cb848    pktgen: ndo_start_xmit can return NET_XMIT_xxx values
>>
>> So this does not really matter anymore.
>>
>>
> 
> Alternative would be the following patch.
> NET_XMIT_CN means the packet has been queued for transmit,
> but that we might have dropped prior packets.
> 
> Probably not a big deal to make the difference in pktgen.
> 
> diff --git a/net/core/pktgen.c b/net/core/pktgen.c
> index a3d74e2704c42e3bec1aa502b911c1b952a56cf1..5c612cbc74c790f64aff5ce602843378284c7119 100644
> --- a/net/core/pktgen.c
> +++ b/net/core/pktgen.c
> @@ -3557,6 +3557,7 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
>   
>          switch (ret) {
>          case NETDEV_TX_OK:
> +       case NET_XMIT_CN:
>                  pkt_dev->last_ok = 1;
>                  pkt_dev->sofar++;
>                  pkt_dev->seq_num++;
> @@ -3565,8 +3566,8 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
>                          goto xmit_more;
>                  break;
>          case NET_XMIT_DROP:
> -       case NET_XMIT_CN:
>                  /* skb has been consumed */
> +               pkt_dev->last_ok = 1;
>                  pkt_dev->errors++;
>                  break;
>          default: /* Drivers are not supposed to return other values! */
> 

Yes, I like that the XMIT_CN then means to increment the seq_num, though for my own purposes,
I wouldn't want to increment the sofar++ in that case (and maybe not do other logic in that case),
since we know at least something dropped.

For fq-codel, seems that XMIT_CN could mean that the attempted packet actually was queued
for xmit, but at least some other packets were purged.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
