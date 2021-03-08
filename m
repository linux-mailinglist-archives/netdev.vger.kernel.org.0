Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFBB331042
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 15:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhCHN7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 08:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhCHN7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 08:59:23 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D12C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 05:59:22 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id o9so9983020iow.6
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 05:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RrfFrVlJXrD0qlVjZppxY1yxenrTchbettf2aSdQaoQ=;
        b=UHirQizG++bUj/EOjI+wCV2Ab1bzTkXKpjtnVK6ONN0TS+vXlx/IX7v0k4YLWbRmTq
         QRTiyF1XAsBx4l+SKdGcwdlXr9B6S2o6UiOb4QKgzHeuK3nwh9QFbYylp/9LxyGkmkeS
         jXP+YNL5ThIBd/tUO/yAZXqHb6WfCs2tZExjy2jWGSp3hIPq5nC6RRZKOoShw7GdLxoe
         7r1CJHaBsU3uTQnW0oRPxINy07kxCUWuXAL+FHF32qBeJWexXDORUlLoIXJyjCE98MCY
         NRQyBwt8zGiaX3W90kD/HjWjAeKoXkviB2CYQGMeJkz8wIOXEqSUzWfej+04w/Q7/XJf
         EPCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RrfFrVlJXrD0qlVjZppxY1yxenrTchbettf2aSdQaoQ=;
        b=c4eZmYllFXXNNa7xmcMLoybcZERVX16bwvmOEJUFmenqXblI4lpIDE0i3bdI64RULs
         O+WWbiZ15y8xhCdG4myZx/fMd7y80Hyl4vJ5ioTnURiogHL71V1pjeJj37Xz5++XowsM
         fttUDVxgHfZnAHqYoH/4ANLxQjEoP5fn9MACrHtEkHuOO5kQ7jwIrywr14YutuVGPrgu
         yG/US42/sa8SSg3Dg8pNbgjaTfedxO6Z8/JoOTN1Ru6sDWKfb71GrohIba29xAB7eBYT
         TBRRtrZlkeDqojswwuIWG6Bl85y/pF+ARXczxNZ16NuIrGxPGnpnHXdTFEhq1VchKR/4
         qbNA==
X-Gm-Message-State: AOAM533iWCaGm8eYu5LD7/OUQyr4DG7vYxLPuJ8BwWb6CfikYe4dxmrR
        s/NeY3V1GorSwDth9pKToyeHdQ==
X-Google-Smtp-Source: ABdhPJzm3b7hFrpCi3p3+IRNVknzQES2Mgs6fipheAGA/fi/jiGjK3ASQFSsSkWL+gAHYiuTwD6Q1Q==
X-Received: by 2002:a02:294e:: with SMTP id p75mr23126028jap.34.1615211962310;
        Mon, 08 Mar 2021 05:59:22 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id v19sm6261456ilj.60.2021.03.08.05.59.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 05:59:21 -0800 (PST)
Subject: Re: [PATCH net-next v2 6/6] net: qualcomm: rmnet: don't use C
 bit-fields in rmnet checksum header
To:     David Laight <David.Laight@ACULAB.COM>,
        "subashab@codeaurora.org" <subashab@codeaurora.org>,
        "stranche@codeaurora.org" <stranche@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     "sharathv@codeaurora.org" <sharathv@codeaurora.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "cpratapa@codeaurora.org" <cpratapa@codeaurora.org>,
        "elder@kernel.org" <elder@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
References: <20210306031550.26530-1-elder@linaro.org>
 <20210306031550.26530-7-elder@linaro.org>
 <498c301f517749fdbc9d3ff5529d71a6@AcuMS.aculab.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <cc8e3bb0-81f0-070b-5b70-342dc172a1a2@linaro.org>
Date:   Mon, 8 Mar 2021 07:59:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <498c301f517749fdbc9d3ff5529d71a6@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/21 4:18 AM, David Laight wrote:
> From: Alex Elder
>> Sent: 06 March 2021 03:16
>>
>> Replace the use of C bit-fields in the rmnet_map_ul_csum_header
>> structure with a single two-byte (big endian) structure member,
>> and use field masks to encode or get values within it.
>>
>> Previously rmnet_map_ipv4_ul_csum_header() would update values in
>> the host byte-order fields, and then forcibly fix their byte order
>> using a combination of byte order operations and types.
>>
>> Instead, just compute the value that needs to go into the new
>> structure member and save it with a simple byte-order conversion.
>>
>> Make similar simplifications in rmnet_map_ipv6_ul_csum_header().
>>
>> Finally, in rmnet_map_checksum_uplink_packet() a set of assignments
>> zeroes every field in the upload checksum header.  Replace that with
>> a single memset() operation.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> Reported-by: kernel test robot <lkp@intel.com>
>> ---
>> v2: Fixed to use u16_encode_bits() instead of be16_encode_bits().
>>
>>   .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 34 ++++++-------------
>>   include/linux/if_rmnet.h                      | 21 ++++++------
>>   2 files changed, 21 insertions(+), 34 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
>> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
>> index 29d485b868a65..b76ad48da7325 100644
>> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
>> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
>> @@ -198,23 +198,19 @@ rmnet_map_ipv4_ul_csum_header(void *iphdr,
>>   			      struct rmnet_map_ul_csum_header *ul_header,
>>   			      struct sk_buff *skb)
>>   {
>> -	__be16 *hdr = (__be16 *)ul_header;
>>   	struct iphdr *ip4h = iphdr;
>>   	u16 offset;
>> +	u16 val;
>>
>>   	offset = skb_transport_header(skb) - (unsigned char *)iphdr;
>>   	ul_header->csum_start_offset = htons(offset);
>>
>> -	ul_header->csum_insert_offset = skb->csum_offset;
>> -	ul_header->csum_enabled = 1;
>> +	val = u16_encode_bits(1, MAP_CSUM_UL_ENABLED_FMASK);
>>   	if (ip4h->protocol == IPPROTO_UDP)
>> -		ul_header->udp_ind = 1;
>> -	else
>> -		ul_header->udp_ind = 0;
>> +		val |= u16_encode_bits(1, MAP_CSUM_UL_UDP_FMASK);
>> +	val |= u16_encode_bits(skb->csum_offset, MAP_CSUM_UL_OFFSET_FMASK);
>>
>> -	/* Changing remaining fields to network order */
>> -	hdr++;
>> -	*hdr = htons((__force u16)*hdr);
>> +	ul_header->csum_info = htons(val);
> 
> Isn't this potentially misaligned?

At first I thought you were talking about column alignment.

The short answer:  Yes (at least it's possible)!  And
that's a problem elsewhere in the driver.  I noticed
that before and confirmed that unaligned accesses *do*
occur in this driver.

I would want to fix that comprehensively (and separate
from this patch), and not just in this one spot.  I have
not done it because I am not set up to readily test the
change; unaligned access does not cause a fault on aarch64
(or at least on the platforms I'm using).

Sort of related, I have been meaning to eliminate the
pointless __aligned(1) tags on rmnet structures defined
in <linux/if_rmnet.h>.  It wouldn't hurt to use __packed,
though I think they're all 4 or 8 bytes naturally anyway.
Perhaps marking them __aligned(4) would help identify
potential unaligned accesses?

Anyway, assuming you're not talking about tab stops, yes
it's possible this assignment is misaligned.  But it's a
bigger problem than what you point out.  I will take this
as a sign that I'm not the only one who has this concern,
meaning I should maybe bump the priority on getting this
alignment thing fixed.

					-Alex

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

