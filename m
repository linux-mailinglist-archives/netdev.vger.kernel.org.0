Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987CC33FB95
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 00:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhCQXAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 19:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhCQXAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 19:00:37 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529C9C06174A;
        Wed, 17 Mar 2021 16:00:37 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id ay2so307867plb.3;
        Wed, 17 Mar 2021 16:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ABRHOOheaMINYIMrHGEwVWjZcN70G4FjLeqvPEUMGCo=;
        b=ffiEau6NV/APxGPPbIypZ8AyHY05odvzkIX+S8c7+sIJHzcFVnfmLkO1+xc/F8PKEx
         BASbzkVcJw+nmDY6giJBnnVwzLuC+KZTeORbeHK1t/GTXDiwgK2IXVgLDAcI4rDFS5se
         YY7U9XvJXU7u5u3Q17G0Ebm4chKzyoJ0KYpEtKuaqpf68NW2tZxlsmeiAeSesDtga3AD
         HKK90MIEABiWmSdvaE0oiD3RyMKzrvNOmjp308HLEFDiWU2qjCopKjcQmkDAZIizQx7P
         FmBCOFQrx3/oDqG+tlijvgALo03fsuNb0Vp8oTjjIQ3h97bzoLlvZ/nVOAlILwA5jGEb
         ByNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ABRHOOheaMINYIMrHGEwVWjZcN70G4FjLeqvPEUMGCo=;
        b=rAWQctPbhTeEPVxW3KMtNTGNny35xibZguBt5GWaRODYGqYvagFn57nUVrunil7X9R
         tD+B/P4ApmPuwcfUGw406rAAWWiQcaTZccOVJc/tbzkrtSV5QOTXhB89hjOvQnVhvfkA
         flXtUUxABdYpCsGeWm9dBzyYXkxJ9ROoNxthCpH49FvmabDvXwKn8cgdoPYLxnADmh+g
         WzhYMIplc/gfcN9L2ZzYXi83GtB23PmKf1zYdVPXDZtY9dASWEtPDeR9RLQ5WGyzdkNx
         IZUWH7N2FOX6UEOpI2VwQ5DeMRtsfjbsIKzulLbiHyICcUh7FGSslfpwlY/DoL1xI1XD
         9t1Q==
X-Gm-Message-State: AOAM530t470SeR4xuM2eVbSTQeHN+50z7AMyEuuTOfAdFtjJjRvL12Gb
        7LA8asnw4m3mTQKxdJCpJLxaGNPcwWY=
X-Google-Smtp-Source: ABdhPJznGZKGKEa5XqIMudc0oQ5typGg7oQuUL7ROTYtHmTvFLPbGtSqf1LACM9X861H8p42Fd8sFA==
X-Received: by 2002:a17:90a:55ca:: with SMTP id o10mr1044291pjm.173.1616022036281;
        Wed, 17 Mar 2021 16:00:36 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q14sm143334pff.94.2021.03.17.16.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 16:00:35 -0700 (PDT)
Subject: Re: [PATCH net-next 2/4] net: ipa: introduce dma_addr_high32()
To:     Alex Elder <elder@ieee.org>, Alex Elder <elder@linaro.org>,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210317222946.118125-1-elder@linaro.org>
 <20210317222946.118125-3-elder@linaro.org>
 <36b9977b-32b1-eb4a-0056-4f742e3fe4d6@gmail.com>
 <60106d7b-ad70-01fa-9f90-fe384cc428f8@ieee.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f0215cf7-3a62-421c-28bf-17aa4e197b9b@gmail.com>
Date:   Wed, 17 Mar 2021 16:00:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <60106d7b-ad70-01fa-9f90-fe384cc428f8@ieee.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/17/2021 3:49 PM, Alex Elder wrote:
> On 3/17/21 5:47 PM, Florian Fainelli wrote:
>>> +/* Encapsulate extracting high-order 32 bits of DMA address */
>>> +static u32 dma_addr_high32(dma_addr_t addr)
>>> +{
>>> +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
>>> +    return (u32)(addr >> 32);
>> You can probably use upper_32bits() here...
> 
> Where is that defined?  I'd be glad to use it.    -Alex

include/linux/kernel.h, and it is upper_32_bits() and lower_32_bits()
sorry about the missing space.
-- 
Florian
