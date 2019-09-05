Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D526AAB76
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 20:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391437AbfIEStJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 14:49:09 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36570 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391424AbfIEStI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 14:49:08 -0400
Received: by mail-wr1-f67.google.com with SMTP id y19so3981925wrd.3
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 11:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xQniiTwVco7xvOlj75jt1pG4KaCruGDU+fZtYV4pADE=;
        b=YyszYXUYxTSlWt//fw18ofLcQP9xDYG4Z0rqSokNQK9xPf8zO+8OUlJBXayce20FDY
         LyJ07swNIsmQQ/2LYuttREBIbi2Ol69Qw4JK90FGMDi3nRyKRDdahFbw7PkedEjZ0TYG
         9FybWNku1RW6JT+ERrePIblbhFam1Rr6sk2QTwiLXZbsrgfpAXz7afEfiRYI+/ycK+/C
         RgZ7rntzgrB7F5sSisocKFEUGfg9/ySl9Gt058Qa8+7vxHYw+VGQXiwPbp/Gumw7Bp7L
         jvRAmBcXaQq9iL0oGmQtgU2t78ViUTpz3ryqO+nQ43yhL4TDIUdqSITeh+glMTdM4Vog
         HYUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xQniiTwVco7xvOlj75jt1pG4KaCruGDU+fZtYV4pADE=;
        b=aqT75sevWoZHZ6jYZSQgwuXi+WBuct1wwQFlJ5J1DMM9cpI6SRDmfCBkGswRqHN7j4
         YeI+wdEKymuFB1G0F1y5/rq2lBRuB6YxXRsYTkFlr5GImaRsDzb3RI59yqISrHXst+as
         DshCdIpl2bTtNx7JNHjluNYCANUK0ajDQJZxw1XK47tG74pN9Vf3ZWPUPREr12n8cOUc
         m6vP4TPxkBZqipmJtTq5Yqv2+fba/7U9TMFUdf/dNJshGOa3Bfkt0uuzhWgX2wYQpfPz
         Q0585EDYbH4H7RWF+AVps3usXhusXt0UfdVpRG/JDFYEn8rlNF8FgZP7apnPqUOp9KDz
         O6lA==
X-Gm-Message-State: APjAAAWeJS7pw0z3919ch1CLACkKPUbJXt3VC7t3xs440JhkneXvAsiy
        n+e1MWA0MXwFCXyCOlzA2S6JPSQU
X-Google-Smtp-Source: APXvYqyvs7MnhF4gAjwAJyXQvAbQiaBcu2FO0GWeN2+oW+xlRyvUC4XdEi/9liXJDjajMM9wueRMpg==
X-Received: by 2002:adf:dc81:: with SMTP id r1mr3825746wrj.52.1567709346780;
        Thu, 05 Sep 2019 11:49:06 -0700 (PDT)
Received: from [192.168.8.147] (163.175.185.81.rev.sfr.net. [81.185.175.163])
        by smtp.gmail.com with ESMTPSA id f15sm3271171wml.8.2019.09.05.11.49.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Sep 2019 11:49:06 -0700 (PDT)
Subject: Re: [PATCH v2] net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128
 local route (and others)
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Lorenzo Colitti <lorenzo@google.com>
References: <565e386f-e72a-73db-1f34-fedb5190658a@gmail.com>
 <20190902162336.240405-1-zenczykowski@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <98b8a95f-245a-0bdf-6a4c-c07a372d4d0f@gmail.com>
Date:   Thu, 5 Sep 2019 20:49:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190902162336.240405-1-zenczykowski@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/19 6:23 PM, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> There is a subtle change in behaviour introduced by:
>   commit c7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43
>   'ipv6: Change addrconf_f6i_alloc to use ip6_route_info_create'
> 
> Before that patch /proc/net/ipv6_route includes:
> 00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001 lo
> 
> Afterwards /proc/net/ipv6_route includes:
> 00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80240001 lo
> 
> ie. the above commit causes the ::1/128 local (automatic) route to be flagged with RTF_ADDRCONF (0x040000).
> 
> AFAICT, this is incorrect since these routes are *not* coming from RA's.
> 
> As such, this patch restores the old behaviour.
> 
> Fixes: c7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> ---
>  net/ipv6/route.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 558c6c68855f..516b2e568dae 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -4365,13 +4365,14 @@ struct fib6_info *addrconf_f6i_alloc(struct net *net,
>  	struct fib6_config cfg = {
>  		.fc_table = l3mdev_fib_table(idev->dev) ? : RT6_TABLE_LOCAL,
>  		.fc_ifindex = idev->dev->ifindex,
> -		.fc_flags = RTF_UP | RTF_ADDRCONF | RTF_NONEXTHOP,
> +		.fc_flags = RTF_UP | RTF_NONEXTHOP,
>  		.fc_dst = *addr,
>  		.fc_dst_len = 128,
>  		.fc_protocol = RTPROT_KERNEL,
>  		.fc_nlinfo.nl_net = net,
>  		.fc_ignore_dev_down = true,
>  	};
> +	struct fib6_info *f6i;
>  
>  	if (anycast) {
>  		cfg.fc_type = RTN_ANYCAST;
> @@ -4381,7 +4382,10 @@ struct fib6_info *addrconf_f6i_alloc(struct net *net,
>  		cfg.fc_flags |= RTF_LOCAL;
>  	}
>  
> -	return ip6_route_info_create(&cfg, gfp_flags, NULL);
> +	f6i = ip6_route_info_create(&cfg, gfp_flags, NULL);
> +	if (f6i)
> +		f6i->dst_nocount = true;

Shouldn't it use 

	if (!IS_ERR(f6i))
		f6i->dst_nocount = true;

???


> +	return f6i;
>  }
>  
>  /* remove deleted ip from prefsrc entries */
> 
