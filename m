Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 988D8761B7
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 11:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfGZJVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 05:21:22 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33698 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfGZJVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 05:21:22 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so53749026wru.0
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 02:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rg6liGE7Xe5Eny9GwF05J9Y2Gg6qiVmmlIS0z2M9AS8=;
        b=hAj9bL7hkhKsw30qHY5Nf36Mnyp4gFKJayMwRRo87NbpAmNaqhN4nAtCzD0OYZnKSJ
         WFuv/LaD35l2w5wQnh1WuC2YcDm0YowhoTreeJ5vzUO/h4IVEEwNLk5SmTH+9AcgtPxh
         zUTV2UfAT5jte3+kgEO4mliLieXj8K7DmWrf88NwExCRpzbMx6jGZfl7rRhvLIkK+wMR
         mt0RhTLInWnXYOYJ2YSPHHggEYe5eZNQeoq9rLX9PmLCXqgLXVSCJK7g1DQCphAWXzvN
         F9PcVhhZeiaGTzWd/KfBbI13D/j1QDk+N7h7vZ3qc4b9uDX+Ieq3OueuI+ZkK5Ng7qHS
         ynow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=rg6liGE7Xe5Eny9GwF05J9Y2Gg6qiVmmlIS0z2M9AS8=;
        b=ui28pckP5CR/EIX6MOn3j25Lc6HyayCb0Mp1mDTY3E9VyImwwQeYVV3X7z+ClH99cr
         hvHpiIV5vtkk1Vq0TiSrBBzrDvlcfxqm5R+jNiD9f2kUSkMkyhYn3iksDUgo0/kNFakW
         p6GIF2p9XGU7u8uaHN8Bmsl88se6rvAkW1Rd0Il6fsq/I69VSjKFOCXaGvsVMW9KdyoQ
         BAAyyKINnvNoaMQcz7KdqsZBRqCoSgT6yHEXb5Gl+BCrIE1QftFOGz1QW92pbgnwHtL1
         TvPEU/cL6Khdhl9hcJ7Ti6+eZ4wEAEecLaAGFo3V3GIlUrAnAcTiJexHEXC5JC3LREd4
         SHmQ==
X-Gm-Message-State: APjAAAW3PB0k9MSb7nY9Gls4c0kXbCoMykmyhdpxDRWRX520DQwW1cUE
        HubmMtcoW59d2ksqgktYyOPMCA==
X-Google-Smtp-Source: APXvYqwDO4urFG+RW2RDSJPPmyJAWpxvecy/fGHur6arOBQcJDc593v3T70IgrP1yS6jyEzh6slVeA==
X-Received: by 2002:adf:eacf:: with SMTP id o15mr15300851wrn.171.1564132879891;
        Fri, 26 Jul 2019 02:21:19 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:9d:caad:2868:a68c? ([2a01:e35:8b63:dc30:9d:caad:2868:a68c])
        by smtp.gmail.com with ESMTPSA id t24sm46674717wmj.14.2019.07.26.02.21.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 02:21:18 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 2/2] net: ipv6: Fix a possible null-pointer dereference in
 vti6_link_config()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190726080321.4466-1-baijiaju1990@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <6b583833-bbb1-dd59-2c83-eda747a58481@6wind.com>
Date:   Fri, 26 Jul 2019 11:21:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190726080321.4466-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 26/07/2019 à 10:03, Jia-Ju Bai a écrit :
> In vti6_link_config(), there is an if statement on line 649 to check
> whether rt is NULL:
>     if (rt)
> 
> When rt is NULL, it is used on line 651:
>     ip6_rt_put(rt);
>         dst_release(&rt->dst);
> 
> Thus, a possible null-pointer dereference may occur.
> 
> To fix this bug, ip6_rt_put() is called when rt is not NULL.
> 
> This bug is found by a static analysis tool STCheck written by us.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  net/ipv6/ip6_vti.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
> index 024db17386d2..572647205c52 100644
> --- a/net/ipv6/ip6_vti.c
> +++ b/net/ipv6/ip6_vti.c
> @@ -646,9 +646,10 @@ static void vti6_link_config(struct ip6_tnl *t, bool keep_mtu)
>  						 &p->raddr, &p->laddr,
>  						 p->link, NULL, strict);
>  
> -		if (rt)
> +		if (rt) {
>  			tdev = rt->dst.dev;
> -		ip6_rt_put(rt);
> +			ip6_rt_put(rt);
> +		}
Please, look at ip6_rt_put(), it is explicitly stated that it can be called with
rt == NULL.
