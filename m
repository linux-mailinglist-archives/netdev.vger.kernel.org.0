Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313602CF184
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730752AbgLDQE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727476AbgLDQE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 11:04:57 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95D2C061A4F;
        Fri,  4 Dec 2020 08:04:11 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id f11so6646769oij.6;
        Fri, 04 Dec 2020 08:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7VB+1jc8g1YKQDZ8tdwVKRM6JUO1hOAxFjhrxOv7Ha8=;
        b=oYeKFh7PN26SksKDvZYaQhyJ4U9sv1XYyFaz3Si5suGo+MHMzuqrEtrV2zaEoXk8Eo
         BG/9UJccFx0ycuLp4OUdFVmuqZP3XdgdEr/f3Vz3MH4K2ei6aaABA5c0WSSXDapoJtWY
         xabA08Wl8nbuPqFrLuHN80fpfs05m60BZGZSYBRF0/YdWPhCvZXOXfmr7i5GjJqxJqcQ
         +W8VdhUBnq1y8HnhWReqZbwxvhZpDjOvwPs45ERX4G2DitvRHy7vrtqwh55Eye0+hHBp
         CROp49Zhvr9aWpibomDvxoMZcVclakZfl3BCNldOv6dNpTBPYrkH7uJcfRqje9rg4yho
         PeUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7VB+1jc8g1YKQDZ8tdwVKRM6JUO1hOAxFjhrxOv7Ha8=;
        b=mjgcgfrbNcjRhzCxfLrarJjRy3jwnaHhstwVhhL1/BARr8hWqECFqNBqxDhFNaiH3o
         Lwa2C0kZkH9ZWG1fgOvK/NteCpKE3JWejryRFHhXGniee1QHzYIW4PzUe7UmzrMbjOVw
         xJvla0KdtEWffXM6+pZF4biblFLFOHIyN/kU8qkRGVvDiIy61jegYMBNyylkWGX3+T0z
         m1ABZm79liifXX2BoAKKtBcqZgH+3UPytG6m32fH+Tb0AJBe/ESMEh7ZeqLPAnqO4Rw7
         ZVtri5AUG5nETL6hH1e8guVttYzJDhF7SAI/nG9ltaOUcfuNlaECMOch2hqKLTTGiNc7
         5jSA==
X-Gm-Message-State: AOAM531unZMF6iCtjqUr7o0w4UATFhvVo+SZxDqoK5yZ7xPeuScIii9H
        lnY+zTiuBriRMymjwSb3LgJ7JPuhGDA=
X-Google-Smtp-Source: ABdhPJy/EcSAqx5/dZhCWfycrGimVrqMujdUp9H8l5yQfG+dmJDjQ0+zaBFO9xBMF3+dIKT7c3aSBw==
X-Received: by 2002:aca:d887:: with SMTP id p129mr3832647oig.156.1607097851085;
        Fri, 04 Dec 2020 08:04:11 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id r12sm714558ooo.25.2020.12.04.08.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 08:04:10 -0800 (PST)
Subject: Re: [PATCH net] ipv4: fix error return code in rtm_to_fib_config()
To:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1607071695-33740-1-git-send-email-zhangchangzhong@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d525d028-582d-2cea-5507-db43ee9f9fe3@gmail.com>
Date:   Fri, 4 Dec 2020 09:04:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <1607071695-33740-1-git-send-email-zhangchangzhong@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/20 1:48 AM, Zhang Changzhong wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: d15662682db2 ("ipv4: Allow ipv6 gateway with ipv4 routes")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  net/ipv4/fib_frontend.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index b87140a..cdf6ec5 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -825,7 +825,7 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
>  	if (has_gw && has_via) {
>  		NL_SET_ERR_MSG(extack,
>  			       "Nexthop configuration can not contain both GATEWAY and VIA");
> -		goto errout;
> +		return -EINVAL;
>  	}
>  
>  	return 0;
> 

Thanks for the patch.

Reviewed-by: David Ahern <dsahern@kernel.org>
