Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E932340A23
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbhCRQYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbhCRQYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:24:17 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E7BC06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:24:16 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id t6so5408267ilp.11
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cBqnVloDz2yrNkaUjh2OjFQf8EURQRF5ZQWle8mgsU0=;
        b=fHzeKFdIZRJWiHa6viv+Vqn8txrERtx4ITD0meU0v09Yl4mbZZ7VvetQHK8l5dvFQT
         rKekhctx7q8DsqvtCi3FfCwB4TjZNogqJiRvX0EExEoLWmuOyNoWGsoMtTCV7ESloOtm
         0cZVFpA+7Ns6oxBKoWcpx/WnJydPjOKtA2n30=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cBqnVloDz2yrNkaUjh2OjFQf8EURQRF5ZQWle8mgsU0=;
        b=bSXXsLIu9E4jYfdeOtt1YmfDWApB79J19Cwe2HSjqQzz1PF8wO4Y5/HNwys+nMQPkJ
         2aO0WJODYgGz3kIPBdj44sKw4zT5AbgoMM/foRzzYIsi69F4tyCmGhoBATowO72DVAH0
         TM1/80gFFU3Cx/By+ZsTrFy9OjficzXSiB7qv6tA0xp/WbMtSDMx4BoyYi2hUTtHpvgt
         htfIpZrIK22t/+FKx3cohvo+yUOhJgDLqLbdRaOYcY97xq8Oo9bHBHIacCQFdQq3EMSP
         kUj+xVEWN2/9FBNKNtfvg8vhIcOS3lLltv7FPQiwHUgcCPKn834H38lY1bq3ew6xmxis
         IZ1A==
X-Gm-Message-State: AOAM532Jt/UVLiT9TDfzcbhGGizQI8mDjC4JvjDHcslkQSB6z0hi9JAL
        l6i5uDZS/i8SigazXFSxLMChlQ==
X-Google-Smtp-Source: ABdhPJwhGXva4CyBNkSbxMJ4AjQNkCsO4qgkHt7FBzYEYpoYqpp+G1ePnqP/1gr38+qSt0WvJfpkgg==
X-Received: by 2002:a05:6e02:13d4:: with SMTP id v20mr11766979ilj.1.1616084656432;
        Thu, 18 Mar 2021 09:24:16 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id e195sm1173171iof.51.2021.03.18.09.24.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 09:24:15 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/4] net: ipa: use upper_32_bits()
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Alex Elder <elder@linaro.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210318135141.583977-1-elder@linaro.org>
 <20210318135141.583977-3-elder@linaro.org>
 <75a8c09b-783a-6d05-2e56-02bd02ff3ff0@gmail.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <982ded1e-b8da-d017-16bf-1a0d4bb46246@ieee.org>
Date:   Thu, 18 Mar 2021 11:24:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <75a8c09b-783a-6d05-2e56-02bd02ff3ff0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/21 11:03 AM, Florian Fainelli wrote:
> 
> 
> On 3/18/2021 6:51 AM, Alex Elder wrote:
>> Use upper_32_bits() to extract the high-order 32 bits of a DMA
>> address.  This avoids doing a 32-position shift on a DMA address
>> if it happens not to be 64 bits wide.
>>
>> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>> v2: - Switched to use the existing function, as suggested by Florian.
>>
>>   drivers/net/ipa/gsi.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
>> index 2119367b93ea9..82c5a0d431ee5 100644
>> --- a/drivers/net/ipa/gsi.c
>> +++ b/drivers/net/ipa/gsi.c
>> @@ -711,7 +711,7 @@ static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
>>   	val = evt_ring->ring.addr & GENMASK(31, 0);
> 
> Did you want to introduce another patch to use lower_32_bits() for the
> assignment above?

Bah... Yes, I should have done that.  I was really just
focused on the new function I created and didn't need
to.   I'll do as you suggest.

I'll also see if I do that anywhere else in the driver
and will use these functions as well if appropriate.

I'll do so in the same patch 2 of version 3.

Thanks Florian.

					-Alex

> 
>>   	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_2_OFFSET(evt_ring_id));
>>   
>> -	val = evt_ring->ring.addr >> 32;
>> +	val = upper_32_bits(evt_ring->ring.addr);
>>   	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_3_OFFSET(evt_ring_id));
>>   
>>   	/* Enable interrupt moderation by setting the moderation delay */
>> @@ -819,7 +819,7 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
>>   	val = channel->tre_ring.addr & GENMASK(31, 0);
> 
> And likewise?
> 
>>   	iowrite32(val, gsi->virt + GSI_CH_C_CNTXT_2_OFFSET(channel_id));
>>   
>> -	val = channel->tre_ring.addr >> 32;
>> +	val = upper_32_bits(channel->tre_ring.addr);
>>   	iowrite32(val, gsi->virt + GSI_CH_C_CNTXT_3_OFFSET(channel_id));
>>   
>>   	/* Command channel gets low weighted round-robin priority */
>>
> 

