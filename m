Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B76217F26
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 07:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgGHFhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 01:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbgGHFhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 01:37:00 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BAAC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 22:37:00 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id cv18so1706457pjb.1
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 22:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iQ0s+f+qOwOgQI/+GSXD9lx6A4B0HuYm4YVpNa8JzNs=;
        b=nhe4o4zY8grlUBu81fCgjol4Op/CyOoV9YLIit54E8LPSf00iLhIjBEeubsjPHmzY2
         oW9ox55J2tl2XQSfPeglRVlJyWt2bq1EQCP6eAoT4w/2vRbt4HvdUwtvKYRDqtGE5iOV
         73hUQ79s65iG9I27l0PATEkqK2/XsrWb2ZUwypVycdeQIj/ScEPVCXt/fEK91C0GBWNd
         kNX+HGTekErsNDJsI6JFR/E3lo217mECQjxtd92gNvQMA/xNCy8hHx3L0wSeEX0lisPr
         VqVmp/TuBoTxaht6ezqamKCSbIhRwLqm5SAFiAacBGB13awY41dotmzmgy/5RcEMUW7T
         18Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iQ0s+f+qOwOgQI/+GSXD9lx6A4B0HuYm4YVpNa8JzNs=;
        b=dAu2Ge3HYAjNB2/0fdroon5NBHGbgavIZhFeZoNKS/jSYx8j5uHOn5roNixnq6xPF/
         GF16dR2LO1sdmzvmBK86cUNAJWSsGMkqGU2+A/5K5hQurCDjQS8O8K2aPgxWA3V+S0E0
         FjOh5ZEP2YGldpPY41aPKmNSdGKB46gWSNtVA/7sfszb7r87nF6LOywKnSMGsOd/lMWp
         IjKncQvJVYg06c84nQ4yPNNUvzzGqFuciuzBPDuEkmCrJxh+ddFnLhk2jed79os+V5MT
         zG58vzpHwReQzoQvgAI7FGuT5y8EAledWnrb/FjIvfmJNuPg0bXbiOgVYOTv12wEJQvV
         Ctfw==
X-Gm-Message-State: AOAM530DfEF8Z5mzf8GZc4TlTnrzuoN2ChWGhWmZTixtupd2Fel4XmFD
        5RblIKsFUrRJnGXWSlB2ktcHPhaS
X-Google-Smtp-Source: ABdhPJyVl2mk5Kq1JuUOWEE72RoHyYoQ/7Kbgd8EjU+H748zcAWWqCiRlYhv8A+C16rCWqCfRVZO9g==
X-Received: by 2002:a17:902:bb95:: with SMTP id m21mr8044117pls.41.1594186619964;
        Tue, 07 Jul 2020 22:36:59 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id v22sm10643442pfe.48.2020.07.07.22.36.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 22:36:59 -0700 (PDT)
Subject: Re: [RFC net-next 2/2] net: disable UDP GSO feature when CSUM is
 disabled
To:     Huazhong Tan <tanhuazhong@huawei.com>, davem@davemloft.net,
        willemb@google.com
Cc:     netdev@vger.kernel.org, linuxarm@huawei.com, kuba@kernel.org
References: <1594180136-15912-1-git-send-email-tanhuazhong@huawei.com>
 <1594180136-15912-3-git-send-email-tanhuazhong@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7d7ed503-3d23-29f6-0fbe-b240064d4eea@gmail.com>
Date:   Tue, 7 Jul 2020 22:36:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1594180136-15912-3-git-send-email-tanhuazhong@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/20 8:48 PM, Huazhong Tan wrote:
> Since UDP GSO feature is depended on checksum offload, so disable
> UDP GSO feature when CSUM is disabled, then from user-space also
> can see UDP GSO feature is disabled.
> 
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> ---
>  net/core/dev.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c02bae9..dcb6b35 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9095,6 +9095,12 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
>  		features &= ~NETIF_F_TSO6;
>  	}
>  
> +	if ((features & NETIF_F_GSO_UDP_L4) && !(features & NETIF_F_HW_CSUM) &&
> +	    (!(features & NETIF_F_IP_CSUM) || !(features & NETIF_F_IPV6_CSUM))) {

This would prevent a device providing IPv4 checksum only (no IPv6 csum support) from sending IPv4 UDP GSO packets ?

> +		netdev_dbg(dev, "Dropping UDP GSO features since no CSUM feature.\n");
> +		features &= ~NETIF_F_GSO_UDP_L4;
> +	}
> +
>  	/* TSO with IPv4 ID mangling requires IPv4 TSO be enabled */
>  	if ((features & NETIF_F_TSO_MANGLEID) && !(features & NETIF_F_TSO))
>  		features &= ~NETIF_F_TSO_MANGLEID;
> 
