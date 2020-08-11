Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE0A241D47
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 17:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgHKPfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 11:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728873AbgHKPfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 11:35:10 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A8FC06174A;
        Tue, 11 Aug 2020 08:35:10 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a79so7802842pfa.8;
        Tue, 11 Aug 2020 08:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3NcJIBT/HlNiF+P77zhcDLzGnLCscXOa/4/7lUf9iqM=;
        b=FIwU9pLX0UbNCO538H8fmYvlUbsTl60KwRFBfeAm5vZlim5Iahw161peY3VQNcCR/8
         E0ZB8V4/WCJsK089AviUFqN6z7Q0YeYiidosMjeABDGUAD4qaEbh4sj7F9Z3I4/XZHim
         Xf/guEnD6/ndc6Ir8drf5/RBiEATEd2cdoYdYoZmQ6ZMvCflb4YIgn106S/hDN27NLyt
         HIdU2iMzmHJ0ZsmElypigGUiHwFDO/Lzk0VgXpOjE2MiucX9J3dKPIg36kPXVHWjEg7z
         3AMzoLbAb7uKM3WwhgU9NQuMdp1H/C4iUzJFQ9cFHPO4yxdAJAicQ4ZXjccM/Rg6TR8B
         9wHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3NcJIBT/HlNiF+P77zhcDLzGnLCscXOa/4/7lUf9iqM=;
        b=HtDmsmLiwBjyFHStJWWPsiYnpAPlZywilXxtysRwUuNJztKBJoa5U8emsHcM20EQZH
         pveA/mch8mBDXmUgCTylPdtDVYu+MrCJb1Gx8Fv1+SrqF18qVAO/mIevnFuU5oi4i5ni
         C+Ho+mo93c0cbU/kwCq64+GC+cZztHj2srgcXIL5ZSinTaenO006Vf+Rye1DruVElxjo
         xMXuwUYhWxKlyjK9rGrxmvYPxinfWuUuwL+GxRhgegzWrITBGx2PLLqettKZY5Sw5OCh
         xmjV0rxxvq3gtNF5TwOGI+hDShBAf8i+jJRVugyKq775vVPtFCmj0Q/MxM1ykha6+K/j
         NrUw==
X-Gm-Message-State: AOAM532KNLIqR2il8LZdcboDAq3TVxFeeRwxpyKKIbZHRUVpWqv3qnEU
        FkCK8qIoSLkLe+az8Ja+E7QHGqYZ
X-Google-Smtp-Source: ABdhPJy4Zd68AFxP2oFzRzoPRHbEG6FpLJxG9EfSIOQIKo4lAlCzjnkLp6QHpSx4okspQPqrflSi7w==
X-Received: by 2002:a63:a517:: with SMTP id n23mr1273054pgf.122.1597160109738;
        Tue, 11 Aug 2020 08:35:09 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id u24sm25768448pfm.20.2020.08.11.08.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 08:35:09 -0700 (PDT)
Subject: Re: [PATCH] net: eliminate meaningless memcpy to data in
 pskb_carve_inside_nonlinear()
To:     linmiaohe <linmiaohe@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pshelar@ovn.org" <pshelar@ovn.org>,
        "martin.varghese@nokia.com" <martin.varghese@nokia.com>,
        "fw@strlen.de" <fw@strlen.de>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "shmulik@metanetworks.com" <shmulik@metanetworks.com>,
        "kyk.segfault@gmail.com" <kyk.segfault@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <40a0b4ba22ff499686a2521998767ae5@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9684c26c-9f26-5a7f-3d17-d180afff432c@gmail.com>
Date:   Tue, 11 Aug 2020 08:35:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <40a0b4ba22ff499686a2521998767ae5@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/11/20 5:10 AM, linmiaohe wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> On 8/10/20 5:28 AM, Miaohe Lin wrote:
>>> The skb_shared_info part of the data is assigned in the following 
>>> loop. It is meaningless to do a memcpy here.
>>>
>>
>> Reminder : net-next is CLOSED.
>>
> 
> Thanks for your remind. I would wait for it open.
> 
>> This is not correct. We still have to copy _something_
>>
>> Something like :
>>
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c index 2828f6d5ba898a5e50ccce45589bf1370e474b0f..1c0519426c7ba4b04377fc8054c4223c135879ab 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -5953,8 +5953,8 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
>>        size = SKB_WITH_OVERHEAD(ksize(data));
>>
>>        memcpy((struct skb_shared_info *)(data + size),
>> -              skb_shinfo(skb), offsetof(struct skb_shared_info,
>> -                                        frags[skb_shinfo(skb)->nr_frags]));
>> +              skb_shinfo(skb), offsetof(struct skb_shared_info, 
>> + frags[0]));
>> +
>>        if (skb_orphan_frags(skb, gfp_mask)) {
>>                kfree(data);
>>                return -ENOMEM;
>>
> 
> This looks good. Will send a patch v2 soon. May I add a suggested-by tag of you ?

I would advise not using Suggested-by, as this would imply I suggested the idea of changing
this function in the first place.

I will add a Reviewed-by:  eventually if your v2 submission looks fine to me.

Thanks.


> Many thanks.
> 
