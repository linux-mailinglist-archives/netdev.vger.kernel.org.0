Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAD44160EE
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241561AbhIWOXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237749AbhIWOXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:23:42 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F9AC061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 07:22:10 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id c42-20020a05683034aa00b0051f4b99c40cso8820615otu.0
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 07:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VwbKBeuynrwb4IlxkHIAzw9pZ7y8LYcrpnXPRfhxjVQ=;
        b=Js0Sj2s52lOSkl27E5mByR5xEcYYI3e8znCX38PTYnj58Cv7sdrZ1DjXuTkSwgIiNz
         fFdGyORrd3ToFy2ww1H1i6y3OTBl7RZP01c1R6FGmeAQnsPsjJ/RD6Icltl04BpQd4JA
         pDkeTxvcLiwDOups/KLOdMfR1r32y2D0mlDhNeBRkY2oiDFc16UF8lsOQSqW6Nnm9Adn
         7B3ZMR+ATX3jYQswBZ5VnsqaVO8t9a9BuaXZ7zqeI+YvxxDSWi9mp9WuE5T8UAfMkc4H
         p8lZ5hZ+MVV5E338Zw13ynr8zKFvyayS9QHQxQkBB4Blh/ZGHs95v95Gc0aCcxefVReG
         DoOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VwbKBeuynrwb4IlxkHIAzw9pZ7y8LYcrpnXPRfhxjVQ=;
        b=Z53tgcsRWgPa0PAHNc23l0DNtzsy9ETM+PXadQNDsusOmOOTbJsZDiW4qq3Lvq9CuL
         R5ErTul15hZPRaZw4gBrsjMlcBKW61kUgvAEfZ7roXSc7p/FZJtCgmOxfmn/0+TqCbTI
         szhJnKqCfzdR6tx53qjEmgd/kwxagPwtJ70dLl/OAOY03VWh8yurPyPFwBPFYPIKlnwR
         JcTdpzPoVxyZIZf5XPpHWoq7IykUbrhgqBW7F4lEzNCDtOejN1SH88YrS3gAOSdfsmo6
         HcZFH9SWXcB69IqkHoh3IwMIxylx3utB57JDJvYpz3rM6k87eKIKRR9niNsWxSK8p3Ci
         dx4w==
X-Gm-Message-State: AOAM533qWGzRgnxwQKvYK0J0kogQwKciCla2osKa7mTPwd18zoeQo7JG
        lRpfZe6nczMqMmIq5RYDyxM=
X-Google-Smtp-Source: ABdhPJzcwzIQt7XLyzA61pV03YJNkY+BUZPEsxprXY5UFYrbER8gQ1VakgWJiUXjd7gUdntBxkeVkw==
X-Received: by 2002:a05:6830:1d43:: with SMTP id p3mr4371254oth.80.1632406930276;
        Thu, 23 Sep 2021 07:22:10 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id a8sm1349084otv.14.2021.09.23.07.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 07:22:09 -0700 (PDT)
Subject: Re: [PATCH net v2] net: ipv4: Fix rtnexthop len when RTA_FLOW is
 present
To:     Xiao Liang <shaw.leon@gmail.com>, netdev <netdev@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
References: <20210923072246.351699-1-shaw.leon@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ec59cfd5-97fa-d254-c3b2-3775c216770d@gmail.com>
Date:   Thu, 23 Sep 2021 08:22:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210923072246.351699-1-shaw.leon@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 1:22 AM, Xiao Liang wrote:
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index b42c429cebbe..e9818faaff4d 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -1661,7 +1661,7 @@ EXPORT_SYMBOL_GPL(fib_nexthop_info);
>  
>  #if IS_ENABLED(CONFIG_IP_ROUTE_MULTIPATH) || IS_ENABLED(CONFIG_IPV6)
>  int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
> -		    int nh_weight, u8 rt_family)
> +		    int nh_weight, u8 rt_family, u32 nh_tclassid)
>  {
>  	const struct net_device *dev = nhc->nhc_dev;
>  	struct rtnexthop *rtnh;
> @@ -1679,6 +1679,12 @@ int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
>  
>  	rtnh->rtnh_flags = flags;
>  
> +#ifdef CONFIG_IP_ROUTE_CLASSID
> +	if (nh_tclassid &&
> +	    nla_put_u32(skb, RTA_FLOW, nh_tclassid))
> +		goto nla_put_failure;
> +#endif

I think we can drop the ifdef here if 0 is always passed when the CONFIG
is not enabled.

> +
>  	/* length of rtnetlink header + attributes */
>  	rtnh->rtnh_len = nlmsg_get_pos(skb) - (void *)rtnh;
>  
> @@ -1707,13 +1713,8 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
>  
>  	for_nexthops(fi) {
>  		if (fib_add_nexthop(skb, &nh->nh_common, nh->fib_nh_weight,
> -				    AF_INET) < 0)
> +				    AF_INET, nh->nh_tclassid) < 0)

This will fail to compile if the CONFIG is not enabled. Use a temp variable:
		__u32 nh_tclassid = 0;

#ifdef CONFIG_IP_ROUTE_CLASSID
        	nh_tclassid = nh->nh_tclassid
#endif

then pass that to fib_add_nexthop

>  			goto nla_put_failure;
> -#ifdef CONFIG_IP_ROUTE_CLASSID
> -		if (nh->nh_tclassid &&
> -		    nla_put_u32(skb, RTA_FLOW, nh->nh_tclassid))
> -			goto nla_put_failure;
> -#endif
>  	} endfor_nexthops(fi);
>  
>  mp_end:



