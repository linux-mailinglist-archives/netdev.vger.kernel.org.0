Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A71733FB80
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 23:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhCQWtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 18:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhCQWtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 18:49:51 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3EDC06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:49:50 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id t18so3099876iln.3
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A76Ll2cPy1caYrVV3BwNuFe9RGXU0Tlri1xHjMBctEo=;
        b=DoMVUsaB0b3+ZrpeqKQ7oBIrIRIqzmcSim6CbL4noy2UthcD1OxtEHyiGvP3c9IuLS
         6nASGOLuYyRLsZvZMnHAZHG9/zdVbvpwyBEzLx8G0J+UcvZD8yctBt4AmggfU2i/zHVS
         S7AHJBEppg55gxejMxHiOTb+APl4+Pwv4Opo8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A76Ll2cPy1caYrVV3BwNuFe9RGXU0Tlri1xHjMBctEo=;
        b=ugFsWHwaOl59qTdtE0BB6bVJkI2VJiWyVA9pSzIPhpR6vAVNUmBcN8DqZwKRdE5Wkf
         7yd0tyBECoSGyJgq/DYjk35SbzXffnp6MG9RlQYl+OrTEEaxRAWpB1ezQDE8algTLPMH
         92v1xq9snf0EIVYtw19iYvAwnXV9kvqqWt0J63LG/XzEH6HRWyCVS0AGNrnYpg+5QwKi
         uzZ88o4N9cupCSXdwN/A7qkd9d/ePAu6kYVt1axMx7c5NxM0tbCzM+UMzjqfajelCUQc
         jirLqO+lTqELUSgSIWrAAN7d+k47zPv2Sk7cojWFaVDeLUL59udaUtjv/ydevGC60xpu
         GyaA==
X-Gm-Message-State: AOAM533rtQ6SWkgj7B2jeeoZuJOTI+BbHLP9HAm0vjGB6Ed71Z27bJ5M
        igYV1IEsMeTJmfnhOz5QHwV0XA==
X-Google-Smtp-Source: ABdhPJzYZibsyqKxbBpc2XiQZ6pO8hjBPmHN47BGQP81qejjd7X6baLkfpqzjIm8xey2f/FpKN3P7A==
X-Received: by 2002:a05:6e02:174b:: with SMTP id y11mr9475632ill.152.1616021390375;
        Wed, 17 Mar 2021 15:49:50 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id v3sm181671ioh.25.2021.03.17.15.49.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 15:49:49 -0700 (PDT)
Subject: Re: [PATCH net-next 2/4] net: ipa: introduce dma_addr_high32()
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Alex Elder <elder@linaro.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210317222946.118125-1-elder@linaro.org>
 <20210317222946.118125-3-elder@linaro.org>
 <36b9977b-32b1-eb4a-0056-4f742e3fe4d6@gmail.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <60106d7b-ad70-01fa-9f90-fe384cc428f8@ieee.org>
Date:   Wed, 17 Mar 2021 17:49:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <36b9977b-32b1-eb4a-0056-4f742e3fe4d6@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/21 5:47 PM, Florian Fainelli wrote:
>> +/* Encapsulate extracting high-order 32 bits of DMA address */
>> +static u32 dma_addr_high32(dma_addr_t addr)
>> +{
>> +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
>> +	return (u32)(addr >> 32);
> You can probably use upper_32bits() here...

Where is that defined?  I'd be glad to use it.	-Alex

