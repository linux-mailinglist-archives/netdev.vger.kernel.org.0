Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE3D2A7F9A
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 14:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbgKENXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 08:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730754AbgKENW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 08:22:59 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA709C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 05:22:57 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id gn41so2583950ejc.4
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 05:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NXEmDyugiQy81X2/+JmsJEqBR5RWIR1GF9id9VokGD0=;
        b=K/Ek58aGxvgi8HgoiX+FvpFV9f6f1Jrm9vnaZy6Tz0G3vIacVHp1pECBK6A1ZM73Iw
         vrxaRuVsDU3M7/U066/aHdYjep79LJ9JycxVbv1YJ+0XI1N55MzuxP4gw9gdlKoQZRk8
         Acvf6VApbWzxktLFibDBvI3w/FVIdYfWmQzcEfhZTGbcINV3XAsrMspZLcAyCIiSjR08
         3eSNABx/LFiS3xgIhRoC+EnCTUjHO8KCseNL4bXa2qaU2wJISfzHeMneqdhMOp7ZqDub
         S1t1k7pNuCr/6NZZb/qWrZpJCqV+3xwRcIvNc6LkOW+WdhyTwPWDflZAsq+JaCX0m396
         a87A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NXEmDyugiQy81X2/+JmsJEqBR5RWIR1GF9id9VokGD0=;
        b=gUQKwyP1NszQu1yMnrSQ0jdxa/sEYcyWM8577jJC4s7rnoiPY4hpryFpW1tXUVp3yo
         Awo2pMxE/mslAwsgfnudGHsM9wDfa/P3G+rdv4CBZ0Cl/qDF1x8iZMTR4EtOFF8ICDH6
         kvQct6x9t36Lx8zPVrP2x80UfxVXCEQ8ypow7iJK6FPQYtKtWXcq97BeoIi1UDk0SEKr
         Op2QvGWeBDV2inJNbN0uXNYFI79ZNcflvFb8/MwKwcZeHhtsS6e024MOJYjJEwl0RYtf
         I3efUj+1Q/ERHnHxSs8YBakp13qdiNgc3dTA5psmGmzPDK+5KiCDOO6d+cf90YVuqOyx
         /MRA==
X-Gm-Message-State: AOAM531k50RaJfr1ZjFiWSf2G0VN0cR1TVi/uAwejusaS6yXFFu+2JRy
        i21ToaXwMgqa9Ad0/DgPeEsSq0pIGU0=
X-Google-Smtp-Source: ABdhPJx2lbk82hJzMu5fYMQoTKFocEWRv2MMo686pBdi30KDPYiLO675Y2yTr56wCPEPJ31vrY5rWA==
X-Received: by 2002:a17:906:74c5:: with SMTP id z5mr2207958ejl.227.1604582576466;
        Thu, 05 Nov 2020 05:22:56 -0800 (PST)
Received: from [192.168.0.113] ([77.125.10.93])
        by smtp.gmail.com with ESMTPSA id w1sm935898ejv.82.2020.11.05.05.22.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 05:22:55 -0800 (PST)
Subject: Re: [PATCH net] net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is
 disabled
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
References: <20201104102141.3489-1-tariqt@nvidia.com>
 <20201104132521.2f7c3690@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <2f95eb05-6a2e-de29-4fd8-1dcff0ab0cfa@gmail.com>
Date:   Thu, 5 Nov 2020 15:22:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201104132521.2f7c3690@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/2020 11:25 PM, Jakub Kicinski wrote:
> On Wed,  4 Nov 2020 12:21:41 +0200 Tariq Toukan wrote:
>> With NETIF_F_HW_TLS_TX packets are encrypted in HW. This cannot be
>> logically done when HW_CSUM offload is off.
> 
> Right. Do you expect drivers to nack clearing NETIF_F_HW_TLS_TX when
> there are active connections, then?  I don't think NFP does.  We either
> gotta return -EBUSY when there are offloaded connections, or at least
> clearly document the expected behavior.
> 

As I see from code, today drivers and TLS stack allow clearing 
NETIF_F_HW_TLS_TX without doing anything to change behavior in existing 
sockets, so they continue to do HW offload. Only new sockets will be 
affected.
I think the same behavior should apply when NETIF_F_HW_TLS_TX is cleared 
implicitly (due to clearing HW_CSUM).

If the existing behavior is not expected, and we should force fallback 
to SW kTLS for existing sockets, then I think this should be fixed 
independently to this patch, as it introduces no new regression.

What do you think?

>> Fixes: 2342a8512a1e ("net: Add TLS TX offload features")
>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>> Reviewed-by: Boris Pismenny <borisp@nvidia.com>
> 
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 82dc6b48e45f..5f72ea17d3f7 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -9588,6 +9588,11 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
>>   		}
>>   	}
>>   
>> +	if ((features & NETIF_F_HW_TLS_TX) && !(features & NETIF_F_HW_CSUM)) {
>> +		netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
>> +		features &= ~NETIF_F_HW_TLS_TX;
>> +	}
