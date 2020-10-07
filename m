Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC9528649E
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 18:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgJGQhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 12:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgJGQht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 12:37:49 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3124AC061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 09:37:48 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z1so2954437wrt.3
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 09:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=slinBX2NAQyePyuzTo17S6np5p2MyRZE8ge6rGClDsE=;
        b=mCkvP2JqXlEi7eia3dH9Fmzx1o2gwguFpU2CZmYIP8Tzf2UVoPNvpxn02Fqti7Ftxz
         V9Q6oXweDs9Ju8VgBVDqdSQaz2auhml6cCqFOXs7wjpiyhIfYgq38dshRdopFZ1I+UoJ
         9pdzNCrbF6Mth7DY7bH+g3mXrIzqWJtAVflLWZHUBZUH2e/U8uecpDp0bwTvzlXKKf+y
         xWVFaPASjNMJSgbFG35Yyhghb6QPUxGS3rxNq5W8/pFYyv6lDJCl9yel5kwbqWKWD16X
         2kK+SVYG/boHnpAW8E17viFi/6kW6PtTdRiOhSP/ZCX3B+yWtZTJlXUfuWrBLRQ0Zq8I
         rkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=slinBX2NAQyePyuzTo17S6np5p2MyRZE8ge6rGClDsE=;
        b=d6urJxnZIbZIfhJNl38jZ+h8vykokNAspY3oKoca7NwV778wY9qoeCvcHuJHxJI+xT
         h1uywdFxw9NNSD1FOZ1clqtHJaHJOCXbsM2APM9CkXe1M7iOs0D2XRTTQV8EEunbHPUI
         Sv0KkWj3+aCVhwBloNDkl1sCom7C6AkEMmR2UyAOs0rVtOekgWEdUKrjH/AX+BOw1WS3
         GFEgJp+TfRhepFb/txB+9D3vPqLfgf5lyOOEeTZITlc0a8qTbihvsXp3oXWX3RkfEDdn
         S0oqno5kErfJTZ9MDQ7CwnfCe05L0gL00FV5c5a4kPa5umSDmPK8sJmEefFj7vEXCerA
         rMfw==
X-Gm-Message-State: AOAM532VfkZKTUH7tRfcdvmw8e9YJepTC7oB/rgUS/g9IbKEZDXtmK8l
        a0BYmS/qX219q3MgJcDew+jw8bqTSe4=
X-Google-Smtp-Source: ABdhPJzw0QObcpZ0yQmDqd4QYrxgJWbf4GTxNZFGTuSQT7i8m70ukiccRoAJTtdu5PB8cJ7f/sj6Dw==
X-Received: by 2002:a5d:6ac6:: with SMTP id u6mr4471154wrw.65.1602088666572;
        Wed, 07 Oct 2020 09:37:46 -0700 (PDT)
Received: from [192.168.8.147] ([37.172.158.5])
        by smtp.gmail.com with ESMTPSA id u2sm3802827wre.7.2020.10.07.09.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 09:37:46 -0700 (PDT)
Subject: Re: net: Initialize return value in gro_cells_receive
To:     Gregory Rose <gvrose8192@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Netdev <netdev@vger.kernel.org>
References: <e595fd44-cf8a-ce14-8cc8-e3ecd4e8922a@gmail.com>
 <9c6415e4-9d3b-2ba9-494a-c24316ec60c4@gmail.com>
 <03e2fd9c-e4c9-cff4-90c9-99ea9d3a5713@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d1e206e5-7049-82bb-3507-6f0436e47fa8@gmail.com>
Date:   Wed, 7 Oct 2020 18:37:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <03e2fd9c-e4c9-cff4-90c9-99ea9d3a5713@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/7/20 5:50 PM, Gregory Rose wrote:
> 
> 
> On 10/7/2020 1:21 AM, Eric Dumazet wrote:
>>
>>
>> On 10/6/20 8:53 PM, Gregory Rose wrote:
>>> The 'res' return value is uninitalized and may be returned with
>>> some random value.  Initialize to NET_RX_DROP as the default
>>> return value.
>>>
>>> Signed-off-by: Greg Rose <gvrose8192@gmail.com>
>>>
>>> diff --git a/net/core/gro_cells.c b/net/core/gro_cells.c
>>> index e095fb871d91..4e835960db07 100644
>>> --- a/net/core/gro_cells.c
>>> +++ b/net/core/gro_cells.c
>>> @@ -13,7 +13,7 @@ int gro_cells_receive(struct gro_cells *gcells, struct sk_buff *skb)
>>>   {
>>>          struct net_device *dev = skb->dev;
>>>          struct gro_cell *cell;
>>> -       int res;
>>> +       int res = NET_RX_DROP;
>>>
>>>          rcu_read_lock();
>>>          if (unlikely(!(dev->flags & IFF_UP)))
>>
>> I do not think this is needed.
>>
>> Also, when/if sending a patch fixing a bug, we require a Fixes: tag.
>>
>> Thanks.
>>
> If it's not needed then feel free to ignore it.  It just looked like
> the unlikely case returns without setting the return value.

Can you elaborate ? I do not see this problem in current upstream code.

If a compiler gave you a warning, please give its version, thanks.
