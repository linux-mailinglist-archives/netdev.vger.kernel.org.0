Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 451DB38E24
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 16:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbfFGOyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 10:54:38 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44023 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728203AbfFGOyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 10:54:37 -0400
Received: by mail-pl1-f196.google.com with SMTP id cl9so921947plb.10;
        Fri, 07 Jun 2019 07:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ayg8bLfZdRmKvdUAgj8C1iwRELXb44aAKvSMCEk7jqQ=;
        b=JpD/7CFXwl2NnI7fB+8KkOGs+7RTMZ2DHsCbblnZMR4WJIoCRie9ANA9Z/UGK+BHQY
         ZWH/8QTVhphYWRn7N74xWjJygmFlWSXckeGzwFstVBSCeYbmGGxr//ZRAmDE2sfXEWTL
         pNSM4SWG4dqhBQxJy+Jm8f8C4OyIq7RSa3y+0KPhnaydKxAvN4NoLDKPAr1BTYjrY4Lf
         hCiToojSM22GyCEQ/i7SdHLvNir70LnY3W50u6+Ym1xm28lXafEqda8L8ZQm5zqk7CrI
         1h5AfjkJT2/o/WrV9szXqlf9cRIoYIQ/KAA8RbMi3g/NMzP0wxDp/QT2tYqAXl+tVG/F
         UwRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ayg8bLfZdRmKvdUAgj8C1iwRELXb44aAKvSMCEk7jqQ=;
        b=dql7FlmMMTv7BJbJ6aXsI10XeLisurhW3aSHZfUAb/Cgkje0R5cts69fF5KBAvgYe4
         u67uCNehxFsr4U75tNC1flkH1cXCm5tOogP3vMgb+hWHqi2Ln3WW1VRC9xcqxKMAQ3Xp
         T1g13zx2liBDDvtUZg9XqX4b+o1CI9p4AK1MqY+QoAjGZwzrqKqrk5OgGBFa2T6g6mFA
         k6tpGqT0KAuRCNea8pvwOzaXd5QTyKjpd+FAIIfTyaPHjDIwIpL978sAHkqtAH6D9CBY
         hLXN2ZLQ69LvwuoqnnSdOikk0fUbEB8P5XJoHnNo33MWyKVpjJHYVXOAAPQC6WARmD9N
         EtJw==
X-Gm-Message-State: APjAAAWPxn9DfgYgTGT0jrKrxjptNUsDKWleiO+e0nK16g5avhS0ep+h
        JWQEXtuU07Cidcq/JdrYRwxE5oxfnmA=
X-Google-Smtp-Source: APXvYqxIPCcBUTtJIzXXA10NNXfGPr/w08PjE1YTxEfbA0p6MnWu0v7VUeyMdfMYarxPrzJNvrr1yQ==
X-Received: by 2002:a17:902:294a:: with SMTP id g68mr57169540plb.169.1559919276852;
        Fri, 07 Jun 2019 07:54:36 -0700 (PDT)
Received: from [172.27.227.216] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id ce3sm2258443pjb.11.2019.06.07.07.54.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 07:54:35 -0700 (PDT)
Subject: Re: [PATCH next] nexthop: off by one in nexthop_mpath_select()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20190607135636.GB16718@mwanda>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0e02a744-f28e-e206-032b-a0ffac9f7311@gmail.com>
Date:   Fri, 7 Jun 2019 08:54:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190607135636.GB16718@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/19 7:56 AM, Dan Carpenter wrote:
> The nhg->nh_entries[] array is allocated in nexthop_grp_alloc() and it
> has nhg->num_nh elements so this check should be >= instead of >.
> 
> Fixes: f88d8ea67fbd ("ipv6: Plumb support for nexthop object in a fib6_info")

Wrong fixes. The helper was added by 430a049190de so it should be

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  include/net/nexthop.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> index aff7b2410057..e019ed9b3dc3 100644
> --- a/include/net/nexthop.h
> +++ b/include/net/nexthop.h
> @@ -160,7 +160,7 @@ struct nexthop *nexthop_mpath_select(const struct nexthop *nh, int nhsel)
>  	/* for_nexthops macros in fib_semantics.c grabs a pointer to
>  	 * the nexthop before checking nhsel
>  	 */
> -	if (nhsel > nhg->num_nh)
> +	if (nhsel >= nhg->num_nh)
>  		return NULL;
>  
>  	return nhg->nh_entries[nhsel].nh;
> 

Thanks for the patch.

Reviewed-by: David Ahern <dsahern@gmail.com>
