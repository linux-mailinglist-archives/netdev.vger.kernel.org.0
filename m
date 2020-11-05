Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E3E2A866A
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgKESuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729783AbgKESuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:50:03 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D35C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 10:50:02 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id gi3so532128pjb.3
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 10:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=kqVKLmHoZkQ3RXokt8N4IaqrMDPkFVHAMTjrhFVBIAs=;
        b=ecgg5vEU9Qg921ot42bR2A1BXDpVPUKS7hBKfZID70AwowG5fSxmnZFyNNJUEPzLU/
         gfDV0SNQOEo1vIEKtxK7QqIdIC8t32Q6bxGAWIbGo/h2FBnN6/OlgU8jg/UdGcARQ9c+
         O9FBZHL3vhKbWGIhKCYOY6QDK08qmxlFafsS0EKwvmxGadScVt4E/h8WtyfxvhvBX6Tf
         4zxQZoYatgZXjgHUNiWMcMYhl669B31AwA4zohqi/PkCgc0UyWOwGEmBn1ZzY3kwFoMv
         kUrGrfbb79gXUIj8T5AncbmDdHCIHlL/uNb7YCzEjNH9Bk3R5KrnDua3ujBmK5eviSRQ
         l8ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=kqVKLmHoZkQ3RXokt8N4IaqrMDPkFVHAMTjrhFVBIAs=;
        b=deI2JHkOfbEdDDY6qwMBkD9QO5MsoXqZK6+KrAbQEFxaOcEVXl2z7fDFA+2UFcSHrF
         cEwBgjGcZL59NPtySvp22Y8GJdnGdOl0mi9qlIt11ZQfL9M8xTepX+zniLv2DvMP++Po
         d70FtTE+dIfKURZ8ef1hM3NiEJlLpyvcsm95xz9H7XvKM3U1NNrSxe9jgVdtEt0ZNabt
         WPDRlBQknBdmhzwNm5/uigfUn1+krPtZ/cHhB70tF/8gqVymf2g6U8/csRpSNw4SnSzq
         dhQ9HexfQc8rTK+eSNNTMSjph29HJx5uR2MwuFa5d2VadJtZAxAca6bgAEonsPbxr86A
         u61Q==
X-Gm-Message-State: AOAM531fSKftDlEzD4nsidmiEJhWaXaI9IgOg6/mUKJZoc+m5ZDOTGFq
        cBrf6Ao6UK0NyzP4odsrs+F/SyDzR5nyIw==
X-Google-Smtp-Source: ABdhPJwpdDqj5kth/DGq46HOiWXLOghJQSFwNUMmGAt/XM7El3rFQ3W+sCpTUMA94xhGZ0TgPTsiNA==
X-Received: by 2002:a17:902:b58f:b029:d4:dbdf:a6da with SMTP id a15-20020a170902b58fb02900d4dbdfa6damr3533207pls.12.1604602202479;
        Thu, 05 Nov 2020 10:50:02 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id b16sm3244989pju.16.2020.11.05.10.50.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 10:50:02 -0800 (PST)
Subject: Re: [PATCH net-next 5/6] ionic: use mc sync for multicast filters
To:     Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
References: <20201104223354.63856-1-snelson@pensando.io>
 <20201104223354.63856-6-snelson@pensando.io>
 <def8bcc5da4c10e021aff6a756ddcbf4487057f6.camel@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <694cb96c-1a88-289e-4f5b-25e29ae1a433@pensando.io>
Date:   Thu, 5 Nov 2020 10:50:00 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <def8bcc5da4c10e021aff6a756ddcbf4487057f6.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/20 5:18 PM, Saeed Mahameed wrote:
> On Wed, 2020-11-04 at 14:33 -0800, Shannon Nelson wrote:
>> We should be using the multicast sync routines for the
>> multicast filters.
>>
>> Fixes: 1800eee16676 ("net: ionic: Replace in_interrupt() usage.")
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/net/ethernet/pensando/ionic/ionic_lif.c | 10 +++++++++-
>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> index 28044240caf2..a58bb572b23b 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>> @@ -1158,6 +1158,14 @@ static void ionic_dev_uc_sync(struct
>> net_device *netdev, bool from_ndo)
>>   
>>   }
>>   
>> +static void ionic_dev_mc_sync(struct net_device *netdev, bool
>> from_ndo)
>> +{
>> +	if (from_ndo)
>> +		__dev_mc_sync(netdev, ionic_ndo_addr_add,
>> ionic_ndo_addr_del);
>> +	else
>> +		__dev_mc_sync(netdev, ionic_addr_add, ionic_addr_del);
>> +}
>> +
> I don't see any point of this function since it is used in one place.
> just unfold it in the caller and you will endup with less code.
>
> also keep in mind passing boolean to functions is usually a bad idea,
> and only complicates things, keep things simple and explicit, let the
> caller do what is necessary to be done, so if you must do this if
> condition, do it at the caller level.
>
> and for a future patch i strongly recommend to remove this from_ndo
> flag, it is really straight forward to do for this function
> 1) you can just pass _addr_add/del function pointers directly
> to ionic_set_rx_mode
> 2) remove _ionic_lif_rx_mode from ionic_set_rx_mode and unfold it in
> the caller since the function is basically one giant if condition which
> is called only from two places.

This was specifically following work that was done a couple of weeks ago 
by Thomas Gleixner et al to clean up questionable uses of 
in_interrupt(), similar to how they used booleans to patch mlx5 and 
other drivers.  They split this out, but later I noticed this issue with 
how multicast got handled.  I agree, I'm not thrilled with the new 
booleans either, which is part of the reason for patch 6/6 in this series.

Yes, I can pull these back into ionic_set_rx_mode() for a v2 patch, 
which will clean up some of this.

I'll look at those future patch ideas: (2) is easy enough and I might 
just add it to this patch series, but I'm not sure about (1) yet, partly 
because I like the current separation of knowledge.

Thanks,
sln

>
>>   static void ionic_set_rx_mode(struct net_device *netdev, bool
>> from_ndo)
>>   {
>>   	struct ionic_lif *lif = netdev_priv(netdev);
>> @@ -1189,7 +1197,7 @@ static void ionic_set_rx_mode(struct net_device
>> *netdev, bool from_ndo)
>>   	}
>>   
>>   	/* same for multicast */
>> -	ionic_dev_uc_sync(netdev, from_ndo);
>> +	ionic_dev_mc_sync(netdev, from_ndo);
>>   	nfilters = le32_to_cpu(lif->identity->eth.max_mcast_filters);
>>   	if (netdev_mc_count(netdev) > nfilters) {
>>   		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;

