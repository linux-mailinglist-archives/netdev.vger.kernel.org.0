Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38302EF8D4
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 21:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbhAHURF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 15:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729368AbhAHURD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 15:17:03 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93027C0612FF
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 12:16:20 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id r9so10955061ioo.7
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 12:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JxLqkk42jTtbkrCXBk4LQLnq5f1cF9SNxn9PWZ+rG9o=;
        b=fUkb19X8+ue3SJacHn0WfI9ExD/QdyriO1e7IUkdh1Rc28A0bY8rJnkwD4jbcALHcc
         vk1uoKt3R3fFzv7OuMH5LDQ9uwyN2tydls4y/AxPKUbSyBApG6hG/tmVtBVBOvBFoJY9
         jX0ZCCa1Ir3cN8AGd6RKZw0FFaCtZll8oUhxe8lY/RUixr5tf5YW8qaIOjBYqr9kcY/s
         OYrcfluH6DZmx5QgWL/c3XmvNEDqCqoRmtB2zYcopTOEygNuEUTTp5sKDcccgkVfm5zX
         TBZq05yz03DL94gdSBSPa4Pq0RG2Gi7fzLthIu7edzqV3bAhxiinyLNio3CCFBBKiHNr
         JCBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JxLqkk42jTtbkrCXBk4LQLnq5f1cF9SNxn9PWZ+rG9o=;
        b=L4n7YfC07kJiEpWELa5YvZEfBHiyVb2lWdi7zDgAbe7evw1F7F6GYgyw5eP4dQk1sD
         vO12SMBQMUx876BeDHmynrAHQJV+D9IfikP+rGhMNmTLgDfuBLpgip5OoBmkd6/9mBLU
         2ywTHtgVLt6/ZuLcM0p4RcRUshGXVdn8OlLy0bmn3XmZl584ydSDIV7WmT+4lWZuYN1D
         iTh/u+Zb437z0zNenp3C3Xz4cAo4ZjXQrgkwAG0SVI1aAEIue46ADeY2SawzZTIII7VF
         x8j4bcqdsBDAqFzYDUlq2yeV+lViiGu31QlSd0BSa3OjN0lJDckiHdIAse4aY4CZ8ihN
         LSsg==
X-Gm-Message-State: AOAM531e7ndglbB4oaKiF8TOtNJExDf2gxtjKlNgNtdeYtNY+3Up8EF5
        jCF267wSpdaOQ85tdJTx2YGsHg==
X-Google-Smtp-Source: ABdhPJzBMVnK82HVkHSa5l6cgbzbaR/2WVtM1ThhGbCnW/6cYCd7kvv3k00Q5RZx1s1FoVUhW6J43g==
X-Received: by 2002:a6b:b205:: with SMTP id b5mr6552718iof.190.1610136979905;
        Fri, 08 Jan 2021 12:16:19 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id q5sm7572105ilg.62.2021.01.08.12.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 12:16:19 -0800 (PST)
Subject: Re: [PATCH net 2/2] net: ipa: re-enable NAPI before enabling
 interrupt
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210107214325.7077-1-elder@linaro.org>
 <20210107214325.7077-3-elder@linaro.org>
 <20210107183803.47308e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <49105454-8f5e-6fa6-bdef-fa68c4510d62@linaro.org>
Date:   Fri, 8 Jan 2021 14:16:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210107183803.47308e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/21 8:38 PM, Jakub Kicinski wrote:
> On Thu,  7 Jan 2021 15:43:25 -0600 Alex Elder wrote:
>> @@ -743,21 +743,21 @@ static void gsi_channel_freeze(struct gsi_channel *channel)
>>   	set_bit(GSI_CHANNEL_FLAG_STOPPING, channel->flags);
>>   	smp_mb__after_atomic();	/* Ensure gsi_channel_poll() sees new value */
>>   
>> -	napi_disable(&channel->napi);
>> -
>>   	gsi_irq_ieob_disable(channel->gsi, channel->evt_ring_id);
>> +
>> +	napi_disable(&channel->napi);
>>   }
> 
> So patch 1 is entirely for the purpose of keeping the code symmetric
> here? I can't think of other reason why masking this IRQ couldn't be
> left after NAPI is disabled, and that should work as you expect.

No, that is not the purpose of the first patch.

But regardless, I'm really glad you pushed back on this
because it made me step back and re-evaluate in a different
way what was happening during suspend.  Your earlier response
(about what happens during napi_disable()) also helped me to
see there's probably something *else* wrong with how the
driver is stopping channels.

I was going to go into more detail here but for now
let me just rescind this series.  I will be reworking
the channel stop/suspend logic and will send that work
out when it's tested and ready.

Thanks.

					-Alex

>>   /* Allow transactions to be used on the channel again. */
>>   static void gsi_channel_thaw(struct gsi_channel *channel)
>>   {
>> -	gsi_irq_ieob_enable(channel->gsi, channel->evt_ring_id);
>> -
>>   	/* Allow the NAPI poll loop to re-enable interrupts again */
>>   	clear_bit(GSI_CHANNEL_FLAG_STOPPING, channel->flags);
>>   	smp_mb__after_atomic();	/* Ensure gsi_channel_poll() sees new value */
>>   
>>   	napi_enable(&channel->napi);
>> +
>> +	gsi_irq_ieob_enable(channel->gsi, channel->evt_ring_id);
>>   }

