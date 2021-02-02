Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A001B30B4D7
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 02:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhBBBuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 20:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhBBBuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 20:50:01 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32765C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 17:49:21 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id j25so21155893oii.0
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 17:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RGKproBEA7VT58cEHKM/tL0SEKFZzt6zt0E3Yp9HmSY=;
        b=ZhdZTZdeWygzKLSRHsjIvWhcSks44tg0kS8gOTY5zowD7/Z2hpiQWEpxCOmixYg8F5
         ZU7AoVPGdqvTdr0BUsW78KNLEZajldWw9gY5Wy53jE8lrR/sfP1/fmhM6Uzxcd1SBsjt
         W+0Gy24Ltgig0KPsVvdnGAQ+XxWV3rJsCtGKsQqzj3fM9V+EozNYICgtioLr7XEkYNqm
         sx2xiNdpZjeOAU0hbQsd4jpIuVdmI6NOku/rAPWSnkXeqOLSMee4CWQdv3MUWXm1hOhL
         JBe6vcrQettNlMs7OdW4sUNXAsRTOCtboeR/Z5PDSyNfd7SIkwnEZu2eZeo5ujLm8CU8
         vP2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RGKproBEA7VT58cEHKM/tL0SEKFZzt6zt0E3Yp9HmSY=;
        b=YCqiwfvcicOI7xIPuXv4gg/KCGmSCVC/xTMqN2x97EOBu5crkkpEbDPo87xTLvSE/7
         NYAnlr0fVmIhpmRSLnXTK2hDPHwECx1fU1MYt9cZGtFnXMN9qfo5rK1ZDoDRts0dDab/
         Dkpk0GlYwAHeaAELjjuA9gp7Jpl+GksGn+m+u4jrPzl4Q27yjuFkehhMsL/dkBrv1j84
         jOyR0fQbuRIqN6Hs8urYM30BrBbY3QjenROgYUJTsZBtJejeULwsZ0mzFKw5q/OhepB8
         goz771kGWbBvri2bkV7N/GkOSIKH0A2bl1DjxfiK32RUgt715f9Ihzg6rAVFdqvB4D1w
         wvCg==
X-Gm-Message-State: AOAM533237pNmlUsYgQ4Pi2YwzjB6o9uEZkj1VnPujcSPwyl4GAFM9hb
        IeIhTaS3vUztZOnIksLmqlc=
X-Google-Smtp-Source: ABdhPJzQkV4ucJyT62F5+k/xeLj2yUv407L4WHmNU/kiGaNnCzzb4RiLbjNmq6ox/OaVnmQq63BWlw==
X-Received: by 2002:aca:a894:: with SMTP id r142mr1112153oie.62.1612230560654;
        Mon, 01 Feb 2021 17:49:20 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id h18sm4263503otr.66.2021.02.01.17.49.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 17:49:19 -0800 (PST)
Subject: Re: [PATCH net-next v2 01/10] netdevsim: fib: Convert the current
 occupancy to an atomic variable
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        jiri@nvidia.com, amcohen@nvidia.com, roopa@nvidia.com,
        bpoirier@nvidia.com, sharpd@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20210201194757.3463461-1-idosch@idosch.org>
 <20210201194757.3463461-2-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3a86a371-b4d5-325a-1557-ea7a8c25ff23@gmail.com>
Date:   Mon, 1 Feb 2021 18:49:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210201194757.3463461-2-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/21 12:47 PM, Ido Schimmel wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> When route is added/deleted, the appropriate counter is increased/decreased
> to maintain number of routes.
> 
> User can limit the number of routes and then according to the appropriate
> counter, adding more routes than the limitation is forbidden.
> 
> Currently, there is one lock which protects hashtable, list and accounting.
> 
> Handling the counters will be performed from both atomic context and
> non-atomic context, while the hashtable and the list will be used only from
> non-atomic context and therefore will be protected by a separate lock.
> 
> Protect accounting by using an atomic variable, so lock is not needed.
> 
> v2:
> * Use atomic64_sub() in nsim_nexthop_account()'s error path
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  drivers/net/netdevsim/fib.c | 55 ++++++++++++++++++-------------------
>  1 file changed, 27 insertions(+), 28 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


