Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC04AD95D7
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 17:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405088AbfJPPlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 11:41:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36912 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404969AbfJPPlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 11:41:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id p1so14520489pgi.4
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 08:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=hJu/ZkDUj81pOk6uJ30ATxM6LGigHB7ZmulbOxHFLHk=;
        b=f86zujduc8/bIIgWCrN9mywnPKjHTPt9RfUYLv3LdpotVACpSJVT7qmLnCqWOQt8qX
         rFR8/o9UnhuwiuqQeq8W2GQ/dw/ZfAL2/I6FP1qfGL16noTn6IEyRr2JKlAVlpMrT9oR
         4fOf0pyqhHrVeA8a3uL0g6J54aCmD/DChP03zL/wCFb18DzLyiPLuSWTnsVUHcQzbjAd
         xoycEppaso87USm4LdYKWP9BUPnpYtzShQgD1XvyItZcO8n3SFC3QpJG0VmLmipqds6G
         DETLXjJOUZmqBtgXThzgOR5P+gMEh8d1+bUJXzBdctFPL2OwmtgFYNBxZEuSZMHObKUX
         +xKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hJu/ZkDUj81pOk6uJ30ATxM6LGigHB7ZmulbOxHFLHk=;
        b=MIyIlg+L6p6uCfmIcjxFY54k1rmky0rmEMzr3LlufULFJbykkGaxNZG/0NOKmYX9LU
         bz5s1X0lBbhtkLhjaLxSeovjUiLYwGmX8fibQXENGjxxzqRAKieIgswVDxPjbvXMaH5U
         BmPC/z7Wqg0TCw4zMFHDQAMVYAvg5GM+PCTf3R4qmodaqqw50qRgN2PJye8zsa0GV4V8
         X8jpDtucpYfrI6ZuRjLtjijs1K3WKPN+LCrqpHfJ80qY65rEGNciKMNxe9kRhTfT3GT4
         MWuNs6M+o7t8gEvWepv/bnnpxidgVEyM58BEfAFmJykVhq5g1N630h7r6pkM+J9GoaJ2
         32yA==
X-Gm-Message-State: APjAAAVk1X7L/V2xU8BIYXlbgeySPEvsA6zQEDufNf+lz+eG8AItPG/0
        Df/Z1oDQrmHNHW6AHEQfwhceNBcf
X-Google-Smtp-Source: APXvYqywVEvp1FmDf+xZvgr8HcJyBVU7fdTH8jN+tCkUMfDlMJL4ZlZyGgTpTjWnM77Xp8dkGpqRMg==
X-Received: by 2002:a65:6394:: with SMTP id h20mr44772660pgv.272.1571240459210;
        Wed, 16 Oct 2019 08:40:59 -0700 (PDT)
Received: from [192.168.84.99] (94.sub-166-161-180.myvzw.com. [166.161.180.94])
        by smtp.gmail.com with ESMTPSA id i126sm24467854pfc.29.2019.10.16.08.40.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 08:40:58 -0700 (PDT)
Subject: Re: big ICMP requests get disrupted on IPSec tunnel activation
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "Bartschies, Thomas" <Thomas.Bartschies@cvk.de>,
        'David Ahern' <dsahern@gmail.com>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
References: <EB8510AA7A943D43916A72C9B8F4181F62A096BF@cvk038.intra.cvk.de>
 <24354e08-fa07-9383-e8ba-7350b40d3171@gmail.com>
Message-ID: <df90f3cf-69d6-dae6-a394-b92a3fc379bb@gmail.com>
Date:   Wed, 16 Oct 2019 08:40:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <24354e08-fa07-9383-e8ba-7350b40d3171@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/16/19 8:31 AM, Eric Dumazet wrote:
> 
> 
> On 10/16/19 5:57 AM, Bartschies, Thomas wrote:
>> Hello,
>>
>> did another test. This time I've changed the order. First triggered the IPSec policy and then tried to ping in parallel with a big packet size.
>> Could also reproduce the issue, but the trace was completely different. May be this time I've got the trace for the problematic connection?
>>
> 
> This one was probably a false positive.
> 
> The other one, I finally understood what was going on.
> 
> You told us you removed netfilter, but it seems you still have the ip defrag modules there.
> 
> (For a pure fowarding node, no reassembly-defrag should be needed)
> 
> When ip_forward() is used, it correctly clears skb->tstamp
> 
> But later, ip_do_fragment() might re-use the skbs found attached to the master skb
> and we do not init properly their skb->tstamp 
> 
> The master skb->tstamp should be copied to the children.
> 
> I will send a patch asap.
> 
> Thanks.
> 

Can you try :

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 28fca408812c5576fc4ea957c1c4dec97ec8faf3..c880229a01712ba5a9ed413f8aab2b56dfe93c82 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -808,6 +808,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
        if (skb_has_frag_list(skb)) {
                struct sk_buff *frag, *frag2;
                unsigned int first_len = skb_pagelen(skb);
+               ktime_t tstamp = skb->tstamp;
 
                if (first_len - hlen > mtu ||
                    ((first_len - hlen) & 7) ||
@@ -846,6 +847,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
                                ip_fraglist_prepare(skb, &iter);
                        }
 
+                       skb->tstamp = tstamp;
                        err = output(net, sk, skb);
 
                        if (!err)
