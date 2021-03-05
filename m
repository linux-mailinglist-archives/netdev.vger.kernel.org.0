Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6528732F50D
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 22:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhCEVDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 16:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhCEVC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 16:02:58 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CE1C06175F
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 13:02:58 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id p10so3250469ils.9
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 13:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KDZZjAmqxj3nBD/QR2JR4FDldbeTt04JdeJXJxPd6S8=;
        b=XTH+opjF0lun0/BAu4EyV3ZJ3Lsqf7XiX/1rYoibwaP/F3bXcL4IlX4TdPRqoqoHye
         ++d4PzoH3qJZRxxRtwFzkkKpK/M4KGw9Mol9qW8269QqGlkw5EbaXydgP7ukM3iZD2b8
         kdpWXWGqe9u1A9W+eA32UK1wbw2n+xgzWU834=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KDZZjAmqxj3nBD/QR2JR4FDldbeTt04JdeJXJxPd6S8=;
        b=iLRwCajCChxx27VKFAUWw7gk2i2e4rNBwOt8fiu33FiFuojwkYqGucKKG4QWxGE5sr
         6252Sj3L+oujY5DFCKwOnoxMpPI1fWRtXgbEhlOKQBb9MCiEfdYdgtc+TlcmPWbEsjnm
         3O4Z1mthV2GF/AO6P4lHUsCUOtySgDYcQHZnHTTrfOjnL5wvEew1AtStyQd7Jjgy48D5
         Z8P61rI1hB/jUgySi+YvLwhkpeyBbCNJn8qUp8GFyw1F3vaRYaGpiRKU3QxiAeBYlCDq
         85rvcKr3385h4q5iOH1CbjrdKMVGkj+6hARCksH7cF8Z/6WOZ3OzCWhYJzC+DH/tmoA1
         K70Q==
X-Gm-Message-State: AOAM5316367XItNYRj7TNgaFrrzrcMG/6OG7HTPOFCT0dpHMM9BzAXu6
        uAbfhAfQvS+/fQex1YyhsJb9k/JFydgLTA==
X-Google-Smtp-Source: ABdhPJzpMsfXkVcnyFEnz/Jq0GyWKgp/9xROXsc/dvUpGUaLODsc2ftI/xVcjxwRG7yL91yQ+G2t1w==
X-Received: by 2002:a05:6e02:b27:: with SMTP id e7mr10539153ilu.253.1614978177492;
        Fri, 05 Mar 2021 13:02:57 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id k3sm1808484ioj.35.2021.03.05.13.02.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 13:02:56 -0800 (PST)
Subject: Re: [PATCH net-next 2/6] net: qualcomm: rmnet: simplify some byte
 order logic
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alex Elder <elder@linaro.org>
Cc:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, sharathv@codeaurora.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210304223431.15045-1-elder@linaro.org>
 <20210304223431.15045-3-elder@linaro.org> <YEGucXIUQ59UcLrJ@builder.lan>
From:   Alex Elder <elder@ieee.org>
Message-ID: <9f1fb37b-90cb-a855-cfa0-3c0e6a234b48@ieee.org>
Date:   Fri, 5 Mar 2021 15:02:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YEGucXIUQ59UcLrJ@builder.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/21 10:07 PM, Bjorn Andersson wrote:
> On Thu 04 Mar 16:34 CST 2021, Alex Elder wrote:
> 
>> In rmnet_map_ipv4_ul_csum_header() and rmnet_map_ipv6_ul_csum_header()
>> the offset within a packet at which checksumming should commence is
>> calculated.  This calculation involves byte swapping and a forced type
>> conversion that makes it hard to understand.
>>
>> Simplify this by computing the offset in host byte order, then
>> converting the result when assigning it into the header field.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>   .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 22 ++++++++++---------
>>   1 file changed, 12 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
>> index 21d38167f9618..bd1aa11c9ce59 100644
>> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
>> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
>> @@ -197,12 +197,13 @@ rmnet_map_ipv4_ul_csum_header(void *iphdr,
>>   			      struct rmnet_map_ul_csum_header *ul_header,
>>   			      struct sk_buff *skb)
>>   {
>> -	struct iphdr *ip4h = (struct iphdr *)iphdr;
>> -	__be16 *hdr = (__be16 *)ul_header, offset;
>> +	__be16 *hdr = (__be16 *)ul_header;
>> +	struct iphdr *ip4h = iphdr;
>> +	u16 offset;
>> +
>> +	offset = skb_transport_header(skb) - (unsigned char *)iphdr;
>> +	ul_header->csum_start_offset = htons(offset);
>>   
>> -	offset = htons((__force u16)(skb_transport_header(skb) -
> 
> Just curious, why does this require a __force, or even a cast?

The argument to htons() has type __u16.  In this case it
is passed the difference between pointers, which will
have type ptrdiff_t, which is certainly bigger than
16 bits.  I don't think the __force is needed, but the
cast to u16 might just be making the conversion to the
smaller type explicit.  Here too though, I don't think
it's necessary.

					-Alex

> Regardless, your proposed way of writing it is easier to read.
> 
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> 
> Regards,
> Bjorn
> 
>> -				     (unsigned char *)iphdr));
>> -	ul_header->csum_start_offset = offset;
>>   	ul_header->csum_insert_offset = skb->csum_offset;
>>   	ul_header->csum_enabled = 1;
>>   	if (ip4h->protocol == IPPROTO_UDP)
>> @@ -239,12 +240,13 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
>>   			      struct rmnet_map_ul_csum_header *ul_header,
>>   			      struct sk_buff *skb)
>>   {
>> -	struct ipv6hdr *ip6h = (struct ipv6hdr *)ip6hdr;
>> -	__be16 *hdr = (__be16 *)ul_header, offset;
>> +	__be16 *hdr = (__be16 *)ul_header;
>> +	struct ipv6hdr *ip6h = ip6hdr;
>> +	u16 offset;
>> +
>> +	offset = skb_transport_header(skb) - (unsigned char *)ip6hdr;
>> +	ul_header->csum_start_offset = htons(offset);
>>   
>> -	offset = htons((__force u16)(skb_transport_header(skb) -
>> -				     (unsigned char *)ip6hdr));
>> -	ul_header->csum_start_offset = offset;
>>   	ul_header->csum_insert_offset = skb->csum_offset;
>>   	ul_header->csum_enabled = 1;
>>   
>> -- 
>> 2.20.1
>>

