Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C90A3406E7
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 14:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhCRNdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 09:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhCRNdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 09:33:37 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB90C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 06:33:37 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id z136so2269990iof.10
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 06:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7vXZ+Ewk3h6WQoE1dpSc6RxoUarL55TFRk0svxaHjcA=;
        b=tTtSWzIEpbhkosQ+izZbQgCdo6jsD7PlI1BJcJCR0vGK3DcF02paQyZXJ49Ev+QXbs
         LSAtWX5Kj2T2io/LmIUV7vM7Lkvv1dtmGc8e/tm+mgem0xhdOWiaRJhp7oNsVFdgWKB2
         aHnYYUJGgbShTty1/UwgJDCm9CnfiCueqhHZQcBpergKTZWCgtDOviWcxVLFGAPsOmsG
         jC+zEJxvVfpdIDAK9TPfMyz+WeOcDP1bTFlzPmdrHQv3ACD8DzXrzfaziXqc+uH4MBQ/
         SVqAktd3+fcn/v4uAAfc5MYCNo9buMNGQFvvmT0NeWxr1C1D2mIMVVfJ9wA9xh4VNEY8
         Yp1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7vXZ+Ewk3h6WQoE1dpSc6RxoUarL55TFRk0svxaHjcA=;
        b=d068kWbUvJ+7dJ+5U0OLEHx6TeGjDuER32Fh4+ldbeiMCyLGrRgs263LeuHCkmN0Sk
         RBMN/Ntj2T6+W8DTOJjSyecFq3Sa87QECU5ADLuudxQqy5rdCEja+MlxAk0K7rmiMkma
         cpSSRerV4nl9MXU4fK1mCQEGSPHtw0Ci0H/NajYsOFsT3I06OMjZxZOFApXL8EU9YUgW
         Cpy4y3/WnztP03ctyI2iXn3deukMHpmgww+pLC/tJLkN1ZoQ7hYk3vWBgNj2La6Gvuw9
         zoreca9llicLrDZWlxOZR3c/5ICZ09G09rYzmcadUvwD8VodCwO4Xck7Kncq4HtSYPHo
         yl1w==
X-Gm-Message-State: AOAM531LKvDYSsniV850m1agia6iRQw+7zbmpTxdp6BDtwEewSlAUxq3
        N+HLEibFuIMyj7hpO5cMsZolOQ==
X-Google-Smtp-Source: ABdhPJyfdR7y0YUEJuPHSd/qhkfAAU8dj/2B1byFgsMpH8dN7BgJoj9P7a8TvBwAFtnZt6J7A1P8Bw==
X-Received: by 2002:a02:b890:: with SMTP id p16mr6760602jam.138.1616074416669;
        Thu, 18 Mar 2021 06:33:36 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id d2sm1143893ilm.7.2021.03.18.06.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 06:33:36 -0700 (PDT)
Subject: Re: [PATCH net-next 2/4] net: ipa: introduce dma_addr_high32()
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Alex Elder <elder@ieee.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210317222946.118125-1-elder@linaro.org>
 <20210317222946.118125-3-elder@linaro.org>
 <36b9977b-32b1-eb4a-0056-4f742e3fe4d6@gmail.com>
 <60106d7b-ad70-01fa-9f90-fe384cc428f8@ieee.org>
 <f0215cf7-3a62-421c-28bf-17aa4e197b9b@gmail.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <6afe045d-7157-2b7f-1dcc-0eddcf77d8a1@linaro.org>
Date:   Thu, 18 Mar 2021 08:33:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <f0215cf7-3a62-421c-28bf-17aa4e197b9b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/21 6:00 PM, Florian Fainelli wrote:
> 
> 
> On 3/17/2021 3:49 PM, Alex Elder wrote:
>> On 3/17/21 5:47 PM, Florian Fainelli wrote:
>>>> +/* Encapsulate extracting high-order 32 bits of DMA address */
>>>> +static u32 dma_addr_high32(dma_addr_t addr)
>>>> +{
>>>> +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
>>>> +    return (u32)(addr >> 32);
>>> You can probably use upper_32bits() here...
>>
>> Where is that defined?  I'd be glad to use it.    -Alex
> 
> include/linux/kernel.h, and it is upper_32_bits() and lower_32_bits()
> sorry about the missing space.

That's nice.  I'll still use a separate commit (and will
credit you with the suggestion) but it will be much smaller.

Thanks.  I'll post v2 shortly.

					-Alex

