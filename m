Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE7F418362
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 18:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbhIYQkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 12:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhIYQkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 12:40:19 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D6AC061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 09:38:44 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id r26so19158716oij.2
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 09:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bKSN4HHTJChgmVKLTkIwXL90MqFLSJfDkcIsviMfeCE=;
        b=DyvqTuwzQjhEvVu274qPkbmaF0E1k6QDFi2fJzUwSp1Rm+Otijfx8JBATK131fbKZD
         +Ae3HbnI7DB6xCQDye/SKHJ/XngroFxNdCba33Vo4BS7J2h6bhP1LhfP2T10M7VtL4oZ
         ZxSWLWT2yLVqmuVkfrVxAbQMkG7SOsefK7aX+wAdjKQhHUICWjypM09mH6UMIr0+8979
         IKD8ZUUhWt44JixWw7dgfIVeqMX/v68pApJxVRZdk0rHo2S3EiCBPXxc95RpqkDoNXIF
         jyhV9VBtfbB/0xgBerFhJS9qcr5DEBCEb9/bPrlk7P4g43wkcIAkQvCObrJ2FjX18xkX
         fsag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bKSN4HHTJChgmVKLTkIwXL90MqFLSJfDkcIsviMfeCE=;
        b=dvCOGKqeG2UHuSFFQMEPMfdAVG0CchiaGznxR2rMmtJZLlUMgPakOFYMtMMrRap0bs
         Gi6tAgfvbHDZDBHMMVzqxF3710YE8phU7pZd1uTH2tZ70ezRwTXhyUG7vHyiNWAr87gJ
         M/ioDLNFlk37ciPYflLIDzitB/ztXYeI2DKcgxlXgqchPrQeeIYKdStKAc8Y63BPUqV+
         BJGIorPE23S8ZAcm6qkTWj1TuLtP4wyM9DH63sRHiVjFR9rvoQYWgGap2QSKqvMePnO0
         r0m37k7r5AELkYTU+Oz3s6sl7jJ5xadZnZrOlwQhheZf/qf5BjInEXb1QzYFDWOpTPxj
         Q6yA==
X-Gm-Message-State: AOAM532WN9OqvYA1usnNmrm0y5R+GDzshcAD1l3qXgo6L165qPDQV/2x
        nAne4hAvEsRI8/+FFqkPPoiCRcl/Sl2qGg==
X-Google-Smtp-Source: ABdhPJwalab4DvkkRBCQ3L+ZjaOL1Jt6kPNr9ObQZF4B6E71cdrsbm1gLnSbDG6M/doPXh2K1W0Fkg==
X-Received: by 2002:aca:e004:: with SMTP id x4mr5866914oig.155.1632587923320;
        Sat, 25 Sep 2021 09:38:43 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id l25sm3113043ooh.22.2021.09.25.09.38.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Sep 2021 09:38:42 -0700 (PDT)
Subject: Re: [PATCH net-next v3 2/3] net: ipv6: check return value of
 rhashtable_init
To:     MichelleJin <shjy180909@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        johannes@sipsolutions.net
Cc:     saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        paulb@nvidia.com, ozsh@nvidia.com, vladbu@nvidia.com,
        lariel@nvidia.com, cmi@nvidia.com, netdev@vger.kernel.org
References: <20210925061037.4555-1-shjy180909@gmail.com>
 <20210925061037.4555-3-shjy180909@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <23ffeeb2-6795-dcb5-8bfb-9e385d9960d9@gmail.com>
Date:   Sat, 25 Sep 2021 10:38:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210925061037.4555-3-shjy180909@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/25/21 12:10 AM, MichelleJin wrote:
> diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
> index 687d95dce085..a78554993163 100644
> --- a/net/ipv6/seg6_hmac.c
> +++ b/net/ipv6/seg6_hmac.c
> @@ -403,9 +403,13 @@ EXPORT_SYMBOL(seg6_hmac_init);
>  
>  int __net_init seg6_hmac_net_init(struct net *net)
>  {
> +	int err;
> +
>  	struct seg6_pernet_data *sdata = seg6_pernet(net);
>  
> -	rhashtable_init(&sdata->hmac_infos, &rht_params);
> +	err = rhashtable_init(&sdata->hmac_infos, &rht_params);
> +	if (err)
> +		return err;
>  
>  	return 0;

Just:

return rhashtable_init(&sdata->hmac_infos, &rht_params);
