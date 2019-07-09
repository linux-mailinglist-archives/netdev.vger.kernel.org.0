Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE606372E
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfGINpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:45:36 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44477 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfGINpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 09:45:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so9939845wrf.11;
        Tue, 09 Jul 2019 06:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WoOafQCA+SKQoC197BJQPKhoNGwN0GTGPnMhrXbSqsY=;
        b=JqrLe8hLX3vXecb9fN+lSl3VceukltpW7iONEOWHMfWuvftTwnQTzDrRtpIq86BnTo
         6oUWzHhWA6iSgm/Ua+Cpz0dncARYLe04rUP4rPAXvVCtY28zKRQGW6QZRzG2ZGpEPeUS
         NeCBhT3XMXIFoICUd5tUZqJlxZKWj/Xy1DHIMHzF+3jwxiXbf5qbY4+zKO+6Sg+0n+Uk
         1Vo7xMFx/U2pDIaUEbV4XCMHa0IzrvkYbTzOGquArrNNSsoSbrz9hzNdYzbv41/34J4Z
         WwpGLLId/AUGjV9IzE/CAYkoO9v5Ta5V7My/gTq81TZvLSRdL5HluZpPkeOtGe1mlF5k
         XEZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WoOafQCA+SKQoC197BJQPKhoNGwN0GTGPnMhrXbSqsY=;
        b=sokIQLqXkLQ30MqVf8wbWzjXGtMIWdPSDjwGptrILIG0g/a0TAhpWMgjIsRyGSFpiE
         i3lJq7X+ovvWLqji/VCvBcDcunyL+ieCBnUpDmDBquxT3QoiiQ5OSgdCdXEJhiQyn7m9
         rdKK8KUktcHAM+APloaabzYod3pySygNQVYkvr7DkVSW15hO5iWzDKW+JpCURbjjWv33
         50RoFj6yovU7ogRL8fUcGPruvIhJxS26FjfnvE5YkT8vVL/v9xCy8YPTV2MZw3zWGFGx
         I+sRt4glOlCYD+mkKQoE1mvyP3t/YuwXoVeWlT+f6rWhPcDoQpXF8dqTMkJIb5CraF3n
         zUeQ==
X-Gm-Message-State: APjAAAUVEK4wbyQNv/77eRyKHsoWgS37NXhtkm1jo3P72CQxWYNIsdOu
        SclStVv3uFyGbBh33rodWmIo+ztt
X-Google-Smtp-Source: APXvYqw/XmDMK7cCCa7XSBY+rpaZf+lJHJTm3SWicQ/MOFP93fyo4mnqumuHjqdyYmAAkkrTN4xxMA==
X-Received: by 2002:adf:f591:: with SMTP id f17mr26252881wro.119.1562679933912;
        Tue, 09 Jul 2019 06:45:33 -0700 (PDT)
Received: from [192.168.8.147] (179.162.185.81.rev.sfr.net. [81.185.162.179])
        by smtp.gmail.com with ESMTPSA id x6sm20911824wrt.63.2019.07.09.06.45.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 06:45:33 -0700 (PDT)
Subject: Re: [PATCH] tipc: ensure skb->lock is initialised
To:     Jon Maloy <jon.maloy@ericsson.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190707225328.15852-1-chris.packham@alliedtelesis.co.nz>
 <2298b9eb-100f-6130-60c4-0e5e2c7b84d1@gmail.com>
 <361940337b0d4833a5634ddd1e1896a9@svr-chch-ex1.atlnz.lc>
 <87fd2150548041219fc42bce80b63c9c@svr-chch-ex1.atlnz.lc>
 <b862a74b-9f1e-fb64-0641-550a83b64664@gmail.com>
 <MN2PR15MB35811151C4A627C0AF364CAC9AF10@MN2PR15MB3581.namprd15.prod.outlook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ef9a2ec1-1413-e8f9-1193-d53cf8ee52ba@gmail.com>
Date:   Tue, 9 Jul 2019 15:45:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <MN2PR15MB35811151C4A627C0AF364CAC9AF10@MN2PR15MB3581.namprd15.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/19 3:25 PM, Jon Maloy wrote:
> 
> 
>> -----Original Message-----
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>> Sent: 9-Jul-19 03:31
>> To: Chris Packham <Chris.Packham@alliedtelesis.co.nz>; Eric Dumazet
>> <eric.dumazet@gmail.com>; Jon Maloy <jon.maloy@ericsson.com>;
>> ying.xue@windriver.com; davem@davemloft.net
>> Cc: netdev@vger.kernel.org; tipc-discussion@lists.sourceforge.net; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH] tipc: ensure skb->lock is initialised
>>
>>
>>
>> On 7/8/19 11:13 PM, Chris Packham wrote:
>>> On 9/07/19 8:43 AM, Chris Packham wrote:
>>>> On 8/07/19 8:18 PM, Eric Dumazet wrote:
>>>>>
>>>>>
>>>>> On 7/8/19 12:53 AM, Chris Packham wrote:
>>>>>> tipc_named_node_up() creates a skb list. It passes the list to
>>>>>> tipc_node_xmit() which has some code paths that can call
>>>>>> skb_queue_purge() which relies on the list->lock being initialised.
>>>>>> Ensure tipc_named_node_up() uses skb_queue_head_init() so that the
>>>>>> lock is explicitly initialised.
>>>>>>
>>>>>> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
>>>>>
>>>>> I would rather change the faulty skb_queue_purge() to
>>>>> __skb_queue_purge()
>>>>>
>>>>
>>>> Makes sense. I'll look at that for v2.
>>>>
>>>
>>> Actually maybe not. tipc_rcast_xmit(), tipc_node_xmit_skb(),
>>> tipc_send_group_msg(), __tipc_sendmsg(), __tipc_sendstream(), and
>>> tipc_sk_timeout() all use skb_queue_head_init(). So my original change
>>> brings tipc_named_node_up() into line with them.
>>>
>>> I think it should be safe for tipc_node_xmit() to use
>>> __skb_queue_purge() since all the callers seem to have exclusive
>>> access to the list of skbs. It still seems that the callers should all
>>> use
>>> skb_queue_head_init() for consistency.
> 
> I agree with that.
> 
>>>
>>
>> No, tipc does not use the list lock (it relies on the socket lock)  and therefore
>> should consistently use __skb_queue_head_init() instead of
>> skb_queue_head_init()
> 
> TIPC is using the list lock at message reception within the scope of tipc_sk_rcv()/tipc_skb_peek_port(), so it is fundamental that the lock always is correctly initialized.

Where is the lock acquired, why was it only acquired by queue purge and not normal dequeues ???

> 
>>
> [...]
>>
>> tipc_link_xmit() for example never acquires the spinlock, yet uses skb_peek()
>> and __skb_dequeue()
> 
> 
> You should look at tipc_node_xmit instead. Node local messages are sent directly to tipc_sk_rcv(), and never go through tipc_link_xmit()

tipc_node_xmit() calls tipc_link_xmit() eventually, right ?

Please show me where the head->lock is acquired, and why it needed.

If this is mandatory, then more fixes are needed than just initializing the lock for lockdep purposes.

