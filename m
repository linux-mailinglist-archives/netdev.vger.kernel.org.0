Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520206321A
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 09:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfGIHas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 03:30:48 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35647 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfGIHar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 03:30:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id l2so2044742wmg.0;
        Tue, 09 Jul 2019 00:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HtgNUo24y4FqBctjL3218NVQPuN/56YuJChVYp5PRBk=;
        b=FjE/qYpi6P0oeSfyeaMJV/O9D0GqPxGz8qAHKiQ9fWqa00ETmAIAeEbS8VrhI4e3Yx
         feU81cOIZqfmkZ8N3m0xUMbb1bCADkU+7t94bc6D1xbj/QWJqqT1ZdmSn9eJoXe2+ZuE
         mlRflprj6L2Jn1SkjJVd+25I1x1XCtopkbgKLjyVY3oZvlqEcKqiUKWQlKxhVKUnCdhL
         EW2RWXsnKvOrFPtQf3kBJNT/T8mmyx9wWWLuF5EtoKSLQAWK/1ftf6Rw5aBfoVQThxF5
         8UsgLJSD2Xbz1ZHw2fJZBe/G7+iw2b0UjFslL5Rwm/UStTvdT16e0RUCmEJTmH2Z8ecw
         biwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HtgNUo24y4FqBctjL3218NVQPuN/56YuJChVYp5PRBk=;
        b=av04G7gaiGjySx0omeTU7p3xRQfSMNOvpg4rT2yQAzCkPYz7++MOpZv2t4aXN8P+vj
         zoEV5tVMqrNTE0S5PVJkz9majo8fzfrM1kIDmgGhhfwwBiUbzanVgxV/N50QMLHaA2l2
         dEdyrQBXk7f2jzB53tV+Rw7vF2pOV7bfIvYKNCQZd5sy9sf/CmgDWcKUnLYtFPO/IGJ6
         SVUS9piqqBiygeuLxRT7bkYvEM3x5vsgrNywTrkWg8sD9t04v36NeTPY2TZ9aBPiyR8t
         Lsb2oo/yrnYTi/e263pzm8tce3PpQ/udim8nuQLYKREpiUSHXelb3IGFkmb9K7UVhrBi
         sl1g==
X-Gm-Message-State: APjAAAWtfrfqYY/SYIax00mtCmLUXTPxjgJLOPaMb1wXoaKZFOcjXMq0
        0XB4mIkYyJpFUBDtROv/UvsJxALk
X-Google-Smtp-Source: APXvYqy5YzRMOYjaDMUJJzclFCHw2U2Fywzo8XJQ1cFPTZT5NJGKRqxXT4kB2KQbb74YNUMTYIHoVw==
X-Received: by 2002:a1c:1f41:: with SMTP id f62mr21014804wmf.176.1562657445444;
        Tue, 09 Jul 2019 00:30:45 -0700 (PDT)
Received: from [192.168.8.147] (179.162.185.81.rev.sfr.net. [81.185.162.179])
        by smtp.gmail.com with ESMTPSA id c12sm17647627wrd.21.2019.07.09.00.30.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 00:30:44 -0700 (PDT)
Subject: Re: [PATCH] tipc: ensure skb->lock is initialised
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "jon.maloy@ericsson.com" <jon.maloy@ericsson.com>,
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
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b862a74b-9f1e-fb64-0641-550a83b64664@gmail.com>
Date:   Tue, 9 Jul 2019 09:30:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <87fd2150548041219fc42bce80b63c9c@svr-chch-ex1.atlnz.lc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/19 11:13 PM, Chris Packham wrote:
> On 9/07/19 8:43 AM, Chris Packham wrote:
>> On 8/07/19 8:18 PM, Eric Dumazet wrote:
>>>
>>>
>>> On 7/8/19 12:53 AM, Chris Packham wrote:
>>>> tipc_named_node_up() creates a skb list. It passes the list to
>>>> tipc_node_xmit() which has some code paths that can call
>>>> skb_queue_purge() which relies on the list->lock being initialised.
>>>> Ensure tipc_named_node_up() uses skb_queue_head_init() so that the lock
>>>> is explicitly initialised.
>>>>
>>>> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
>>>
>>> I would rather change the faulty skb_queue_purge() to __skb_queue_purge()
>>>
>>
>> Makes sense. I'll look at that for v2.
>>
> 
> Actually maybe not. tipc_rcast_xmit(), tipc_node_xmit_skb(), 
> tipc_send_group_msg(), __tipc_sendmsg(), __tipc_sendstream(), and 
> tipc_sk_timeout() all use skb_queue_head_init(). So my original change 
> brings tipc_named_node_up() into line with them.
> 
> I think it should be safe for tipc_node_xmit() to use 
> __skb_queue_purge() since all the callers seem to have exclusive access 
> to the list of skbs. It still seems that the callers should all use 
> skb_queue_head_init() for consistency.
> 

No, tipc does not use the list lock (it relies on the socket lock)
 and therefore should consistently use __skb_queue_head_init()
instead of skb_queue_head_init()

Using a spinlock to protect a local list makes no sense really,
it spreads false sense of correctness.

tipc_link_xmit() for example never acquires the spinlock,
yet uses skb_peek() and __skb_dequeue()

It is time to clean all this mess.



