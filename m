Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4EAA2537E8
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgHZTK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgHZTKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 15:10:55 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D7BC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:10:54 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id e11so2740137ils.10
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xrqtIK21B5DYUM4Ma+HFKpK6EpktDF+hVH38+prxLWM=;
        b=LJ5DqZr12aWAKSxJomhvjWrn0KQX+MQcH+hwv4Js4Qcxgi9+ExIvBxhNO99ABzCnSP
         lF1PO3ZdO9/2jLplRLQTCHobU20iJcGUIM46SvQcF8pf58ghBqlUjH3O1F8PExz3Ujri
         CHy4cBQULoo108eyBnccDfcRbzRGIkTEPUQXb1alt0B8RiGYZdZsSyxKkmSsHsW+hGEz
         FAAPabIQEiBdAod9ZBBJH/TXrnS4mnJLe7sZu6+ZPsdOBBGWOGGm/iB23KYnG73Gv/ep
         zO8wepkPsvv1d2k5sHH6W/HiZg8k4bo7OOgpTOrghA/LHXwRL+JTViQN+xE3luQ93mu+
         582Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xrqtIK21B5DYUM4Ma+HFKpK6EpktDF+hVH38+prxLWM=;
        b=oRac6jXermd3nRZoQb4EuWZoxsD0bWcxt8tZ8PpHgOH6IINSp8HV8Hm5b2avFUatZd
         7DokTqDANNpYKggU++6aHDruTtOYIw2srdm5d5MohIxOPA4sgdYkQ6dLaRpnLlPdW/6e
         X4ZZ1x5R0sehC0O13BiOvPrEJe7ZPVORT6wvot8CBHFGl6thwrmxr92JMUJy9YkLPZen
         EIfHvgUklcQyeRcOAjUKiTWwUAkot67ftAhg6HJFXm/RLjNBkjp0xZwymXgaMJZS0KHi
         eIn8vK4I2wx6Q7RqmbyBkozd4Bb0OmHRSeCQWzEJK3YqgJQ+8FFfTDvakL1S9U/P0Ysi
         AnRw==
X-Gm-Message-State: AOAM5324GS+aFT6oLQn1U8jYlWhIQEnYZ+10i+SFBB7o6CMigNNbSjUS
        zuaMw1uvlMJNRSwYe0iRHKrBEIwPXlKgDw==
X-Google-Smtp-Source: ABdhPJxv4vJ5fTFpe5O87uL+Ci9A/WLj1fHFgScmsR8wYhfMIF4cGxMXXeCYWf6Jk64L6zjjNiFKJw==
X-Received: by 2002:a92:d089:: with SMTP id h9mr13173116ilh.60.1598469053176;
        Wed, 26 Aug 2020 12:10:53 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:305a:ae30:42e4:e2ca])
        by smtp.googlemail.com with ESMTPSA id p3sm198448ilq.59.2020.08.26.12.10.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 12:10:52 -0700 (PDT)
Subject: Re: [PATCH net-next 3/7] ipv4: nexthop: Remove unnecessary
 rtnl_dereference()
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20200826164857.1029764-1-idosch@idosch.org>
 <20200826164857.1029764-4-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3e7866d6-b088-7141-182a-da1bb6011619@gmail.com>
Date:   Wed, 26 Aug 2020 13:10:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826164857.1029764-4-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/20 10:48 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The pointer is not RCU protected, so remove the unnecessary
> rtnl_dereference(). This suppresses the following warning:
> 
> net/ipv4/nexthop.c:1101:24: error: incompatible types in comparison expression (different address spaces):
> net/ipv4/nexthop.c:1101:24:    struct rb_node [noderef] __rcu *
> net/ipv4/nexthop.c:1101:24:    struct rb_node *
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 0823643a7dec..1b736e3e1baa 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -1098,7 +1098,7 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
>  	while (1) {
>  		struct nexthop *nh;
>  
> -		next = rtnl_dereference(*pp);
> +		next = *pp;
>  		if (!next)
>  			break;
>  
> 

A left over from initial attempts to convert connected routes to nexthops.

Reviewed-by: David Ahern <dsahern@gmail.com>
