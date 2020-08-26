Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0199C2537E0
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgHZTID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbgHZTHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 15:07:55 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6F4C061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:07:55 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id v6so3257221iow.11
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iz6QCzFzgK/mjyMM7rU0MxEWgTPLy7MWPnc4Q6QOsIQ=;
        b=rF44OPQfo7tVMLRFinsiWsbM2a+moAR0w1oRGzw5Ka4TzbOdYDbB7zhmjMoCiP/9hj
         wybcIT/4jAbKj27w6Xhiji3sO2fHNLScpICrjfgBnJL3w7NBt3hJcyrje828CPcbR+rU
         ca5nPIaALQom0+awdtsaCzyPaNpyVno2BzDRuk8e7iW2eelBcoX5yfb6Q4t6QyK/AWRj
         LuPAhFG7nL+Q+oqbVOkxf2Gq+GVdgmnRhwypH2TV2Mh23ugNZ6NPYfbnc850tlTOWD0Y
         LLjaFE2JSkqi1WSqbCj8M+cG/KeLY3WyxUCpnEx51OWGa+h8E8Gg4jF7DT3VfPOUTRMB
         z8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iz6QCzFzgK/mjyMM7rU0MxEWgTPLy7MWPnc4Q6QOsIQ=;
        b=BLR/gB9zfTRd76hNAj2+siT+11X4d/KwMb2ThPI3USXSXMnaR8rneaspH8swm+nf10
         liWFfj83kkBoFVIhuvquMLyCvwTWcOptc5N8yxgaYP2wzrXtuxg00/vwdrPFX6J2F0RH
         wmCfv4KpR+hcpuHCl6Kl1okuL4a42iY9Q4+tjqJeabPDEFmJLc+cG5wfN2MMjrsFS1uy
         YOHXghSihWigTmLEKxTaVXpgDhXW808NXcOYz63dU4+LMIWZUhPIAjSjydsmnbStMDiY
         ldZZiRwMpFms06wN0j0Q4qu2HtY5/ebHIjZXbUt3I1+nvVWzLikS1OFpauqwWOui1PUi
         9Thw==
X-Gm-Message-State: AOAM533UAMCzTv973r9+AuyMWIuE+WNLxZy+qyO3tOi55HkEdVEDGo34
        PTzGznZD17x6C1do2bu782g=
X-Google-Smtp-Source: ABdhPJx+zrmmMseLlVm0Q03AJaDUldYvz3wF11k4hHL34+QJ66bQ55g8DSM4w0UphWlJt13OSv1EBg==
X-Received: by 2002:a5d:9051:: with SMTP id v17mr13701514ioq.88.1598468874894;
        Wed, 26 Aug 2020 12:07:54 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:305a:ae30:42e4:e2ca])
        by smtp.googlemail.com with ESMTPSA id 187sm1539834iow.34.2020.08.26.12.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 12:07:54 -0700 (PDT)
Subject: Re: [PATCH net-next 2/7] ipv4: nexthop: Use nla_put_be32() for
 NHA_GATEWAY
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20200826164857.1029764-1-idosch@idosch.org>
 <20200826164857.1029764-3-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d2c12c9b-5959-1beb-3c2c-445f86aad306@gmail.com>
Date:   Wed, 26 Aug 2020 13:07:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826164857.1029764-3-idosch@idosch.org>
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
> The code correctly uses nla_get_be32() to get the payload of the
> attribute, but incorrectly uses nla_put_u32() to add the attribute to
> the payload. This results in the following warning:
> 
> net/ipv4/nexthop.c:279:59: warning: incorrect type in argument 3 (different base types)
> net/ipv4/nexthop.c:279:59:    expected unsigned int [usertype] value
> net/ipv4/nexthop.c:279:59:    got restricted __be32 [usertype] ipv4
> 
> Suppress the warning by using nla_put_be32().
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index d13730ff9aeb..0823643a7dec 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -276,7 +276,7 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
>  	case AF_INET:
>  		fib_nh = &nhi->fib_nh;
>  		if (fib_nh->fib_nh_gw_family &&
> -		    nla_put_u32(skb, NHA_GATEWAY, fib_nh->fib_nh_gw4))
> +		    nla_put_be32(skb, NHA_GATEWAY, fib_nh->fib_nh_gw4))
>  			goto nla_put_failure;
>  		break;
>  
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
