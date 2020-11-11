Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8F22AF086
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 13:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgKKM0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 07:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgKKM0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 07:26:00 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A142C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 04:26:00 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id dk16so2464065ejb.12
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 04:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oM65/gACAp76+1LBiEToRmHWPw7u8ehBjf4gPtAaBuE=;
        b=EnFDscrAKUQUfZYJFRQLn21WuEcOOXNQeXdXkz2LFhfTjQbaJ0iRs+JHPjqZOG82yD
         md9FmRaP1m0qCIFR10w+OEOKHMYSOm0xzPRyd9LUqWTNhrsfg63bPtphG5ZpcR93kTQV
         ka50u/O0nSCrPxuH5LJ0vYaEWba6HKC4MS9g5tfjAGPW/L7GFDQ5ZUvcYNLl0vy2dUfU
         wLUDoTBkyxfIamPgedp5fQwxE0wnX/u/kawLuwxp8YkmbT6UE7H3uayrUeEQANCNqQJe
         +zuUjAKhcO0yfv2CExC6kACpyH2qgCcvK1LcofU+ZAVL4Ee/400PAIOYFxpO4NchjdLj
         lf9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oM65/gACAp76+1LBiEToRmHWPw7u8ehBjf4gPtAaBuE=;
        b=eIE8xcidG94HcQGeqHJ9EFRHmWhLAa0zko/Sv/6qmLBEeO1ZfgPy4/vdd9ruDmOOjU
         SsPE9Mdsq0BiAb6WssxHTTMBBXMib4B22NmmE4EjxDQ+1Km0rcPFMEHJi46FyAtj4CA4
         yl9w18e9fpknG6fZUXXy6h6sIQwqxUHno/+iBv9saCIq+lJlLGCAEZm+2jBXNgYAd8AA
         mFerDta0pdpl5sV39ViYm2S4Kx5TurhEC+5eeZQ61JbQbVvxkYYVV4KDQ7FccOt/7veH
         JmAm8OvqvLN7kXZemHMdvshF5bqf6TBIeIFloZdiyeoYpujqyPCIUgr+qwvEGctq/Dwq
         qUcQ==
X-Gm-Message-State: AOAM531Pw+euIYM7LH3iTOmQsWTlEkpi8J0++i+kc2s5PGIum3GYjqrf
        NbBV3DgKPY0uvLlvQ9xN6eTlkdUOMR0NFg==
X-Google-Smtp-Source: ABdhPJyr7vjYvN/ddOXKLoGNIOSF7RK4/A5BQuSdhSHBx9DdClPwejhFfbeTCjWjS8H6Svu6ez9Dkg==
X-Received: by 2002:a17:906:6b82:: with SMTP id l2mr24304875ejr.241.1605097558926;
        Wed, 11 Nov 2020 04:25:58 -0800 (PST)
Received: from [10.21.182.137] ([212.23.236.67])
        by smtp.gmail.com with ESMTPSA id ld21sm788048ejb.104.2020.11.11.04.25.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 04:25:58 -0800 (PST)
Subject: Re: [PATCH net V2] net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is
 disabled
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, tariqt@nvidia.com
References: <20201108144309.31699-1-tariqt@nvidia.com>
 <20201110154428.06094336@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <83a73a18-d03b-c763-2b4f-b0c7e6cd14fc@gmail.com>
Date:   Wed, 11 Nov 2020 14:25:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201110154428.06094336@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/11/2020 1:44 AM, Jakub Kicinski wrote:
> On Sun,  8 Nov 2020 16:43:09 +0200 Tariq Toukan wrote:
>> @@ -528,3 +528,7 @@ Drivers should ignore the changes to TLS the device feature flags.
>>   These flags will be acted upon accordingly by the core ``ktls`` code.
>>   TLS device feature flags only control adding of new TLS connection
>>   offloads, old connections will remain active after flags are cleared.
>> +
>> +The TLS encryption cannot be offloaded to device if checksum calculation
>> +is not, hence the TLS TX device feature flag is cleared when HW_CSUM is
>> +disabled.
> 
> This makes it sound like the driver will fall back to software crypto
> if L4 csum offload gets disabled, is this your intention?
> 
> Seems at odds with the paragraph above it.
> 

Actually, TLS feature bit acts on new connections, while CSUM feature 
bit acts immediately, so for old connections we still have a gap.

I think of adding logic in netif_skb_features or tls_validate_xmit_skb, 
but it's not trivial.

I'll resubmit when i figure out a clean way that covers all cases and is 
consistent with TLS feature bit behavior.

Regards,
Tariq


>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 9499a414d67e..26c9b059cade 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -9584,6 +9584,11 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
>>   		}
>>   	}
>>   
>> +	if ((features & NETIF_F_HW_TLS_TX) && !(features & NETIF_F_HW_CSUM)) {
>> +		netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
>> +		features &= ~NETIF_F_HW_TLS_TX;
>> +	}
>> +
>>   	return features;
>>   }
>>   
> 
