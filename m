Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F07330F4E
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 14:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhCHNeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 08:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhCHNdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 08:33:55 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF67C06174A;
        Mon,  8 Mar 2021 05:33:54 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id 7so11505781wrz.0;
        Mon, 08 Mar 2021 05:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n57syK0cdSMLZVKIc634t3IzWzqmv7GZYhdhr3kqpC8=;
        b=C/RAdyu/tjxgmW7D+h7G/edqg1AzO2jFOTJ6Q1qjnD4qzePGUivkZAQEz5v0WvyoZT
         El3GIA9FJe/utA4rt4zTnICoy87RgWXnaBEZP10NSoYjvZSt/DJ5NQWq1dyuEuq5IWEi
         K5wA1aHofJDWvvaX1LVQEXMndDkhjCCyDLLnZxRMWHW0Pp8UdTzrnui4QiBMF4h53ILA
         4XZ8iNQDt5XqiU7lEDYNB9hHLYdDBdGrUV7bSZwHTQ2UuBOF6fFeQcKwoLBy+e6g4fBI
         V033tSNR19RsbXaZFt6KHyc1llaTJOmz3bWEj8uWNcu3nz9L0vH4SbVcM+FrI8JhA+L+
         v8lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n57syK0cdSMLZVKIc634t3IzWzqmv7GZYhdhr3kqpC8=;
        b=Mo5csQT7lGD0/SNByUEj215m6hpM62Cx0VaMCyo0LcEs6Ksy+wCd1Z53lbmNn4HYBn
         Ec2daHg75DmCZUfxcD7s+KiJnFj+nFxS1m7owSFBKNTjqbykEtODFt4ItLs/BbBBgqxo
         73ug5rl+0R/gqoTZPS01Q5EhuP2COrfJCh5dtOJ7HKxKilE3ATTw2BSv7p72nbml9iyv
         uaq6bbHlrQo9Z0PXyijp4JdnxyqaqMXYpnM76wanimkEMjTaHkilBYj11MhtOpxVPIm8
         qJPmwWi0PE1WSS21W9iNamC6G7wlisBgsUu9tgsWJQCQswtqBhFGb0vxSvmwWPEB6wrn
         ayDg==
X-Gm-Message-State: AOAM533W0NSKSfEAiS2gJEGDxTB6ZPTiYhrjIj5YpsQJV50a116G3NqL
        lFe6xXceAOtFYGrL1Y0r51o=
X-Google-Smtp-Source: ABdhPJx3fSbJKU5NXNDrIvwdWxWrB6Nmhghk2oweyX0Nlkr+B+ISTgUxSekLWsxI4gTm8Y70qTNcXQ==
X-Received: by 2002:adf:dc91:: with SMTP id r17mr22923163wrj.293.1615210433335;
        Mon, 08 Mar 2021 05:33:53 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:bb00:7cd5:578:8a4c:b83b? (p200300ea8f1fbb007cd505788a4cb83b.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:7cd5:578:8a4c:b83b])
        by smtp.googlemail.com with ESMTPSA id j12sm18706211wrx.59.2021.03.08.05.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 05:33:52 -0800 (PST)
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org, stefan@datenfreihafen.org
References: <20210308093106.9748-1-baijiaju1990@gmail.com>
 <d373b42c-0057-48b3-4667-bfa53a99f040@gmail.com>
 <3634b7c6-340b-3d6d-ccce-c2a95319ca9e@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: ieee802154: fix error return code of dgram_sendmsg()
Message-ID: <44ee06c9-b99c-8758-a045-ea7d17a6dbf3@gmail.com>
Date:   Mon, 8 Mar 2021 14:33:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <3634b7c6-340b-3d6d-ccce-c2a95319ca9e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.03.2021 13:18, Jia-Ju Bai wrote:
> 
> 
> On 2021/3/8 18:19, Heiner Kallweit wrote:
>> On 08.03.2021 10:31, Jia-Ju Bai wrote:
>>> When sock_alloc_send_skb() returns NULL to skb, no error return code of
>>> dgram_sendmsg() is assigned.
>>> To fix this bug, err is assigned with -ENOMEM in this case.
>>>
>> Please stop sending such nonsense. Basically all such patches you
>> sent so far are false positives. You have to start thinking,
>> don't blindly trust your robot.
>> In the case here the err variable is populated by sock_alloc_send_skb().
> 
> Ah, sorry, it is my fault :(
> I did not notice that the err variable is populated by sock_alloc_send_skb().
> I will think more carefully before sending patches.
> 
> By the way, I wonder how to report and discuss possible bugs that I am not quite sure of?
> Some people told me that sending patches is better than reporting bugs via Bugzilla, so I write the patches of these possible bugs...
> Do you have any advice?
> 

If you're quite sure that something is a bug then sending a patch is fine.
Your submissions more or less all being false positives shows that this
takes more than just forwarding bot findings, especially if you have no
idea yet regarding the quality of the bot.
Alternatively you can contact the maintainer and respective mailing list.
But again, maintainers typically are very busy and you should have done
all you can to analyze the suspected bug.

What I'd do being in your shoes:
Take the first 10 findings of a new bot and analyze in detail whether
findings are correct or false positives. Of course this means you
need to get familiar with the affected code in the respective driver.
If false positive ratio is > 5% I wouldn't send out patches w/o more
detailed analysis per finding.

Worst case a maintainer is busy and can't review your submission in time,
and the incorrect fix is applied and breaks the driver.
Typically this shouldn't happen however because Dave/Jakub won't apply
a patch w/o Ack from the respective maintainer.

Disclaimer:
I can only speak for myself. Other maintainers may see this differently.

> Thanks a lot!
> 
> 
> Best wishes,
> Jia-Ju Bai
>>
>>> Fixes: 78f821b64826 ("ieee802154: socket: put handling into one file")
>>> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
>>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>>> ---
>>>   net/ieee802154/socket.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
>>> index a45a0401adc5..a750b37c7e73 100644
>>> --- a/net/ieee802154/socket.c
>>> +++ b/net/ieee802154/socket.c
>>> @@ -642,8 +642,10 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>>>       skb = sock_alloc_send_skb(sk, hlen + tlen + size,
>>>                     msg->msg_flags & MSG_DONTWAIT,
>>>                     &err);
>>> -    if (!skb)
>>> +    if (!skb) {
>>> +        err = -ENOMEM;
>>>           goto out_dev;
>>> +    }
>>>         skb_reserve(skb, hlen);
>>>  
> 

