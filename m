Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9777C308A3E
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 17:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhA2QcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 11:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhA2Qbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 11:31:32 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FD3C061573;
        Fri, 29 Jan 2021 08:22:50 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id e70so9084688ote.11;
        Fri, 29 Jan 2021 08:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FRrYeh/eZSmBAGMtTw4vFQ8VoilGhVsEkxG9XZTvSwI=;
        b=QlApMYe3ic9XesBmbvwddvBFQHvM4BFy4eJiGlLZYmuXzQIBGAxiNTpv00/1OF3ckM
         dVfEy2cQDPrzye/pzLiWvtzfcArA56elZ1arXPwQOG7op23NpW2Jqd4bo+Plp+wXqGzv
         8RXN0mmcc7FA+dyBrf3R9ri+w585c8dnFezUj6DWXz0WLrr5lX3XvBf7YdNmgk984a+f
         Yfed4oDNljdo35B9mTaPJcFQcxzDKlz+rxOHALhFE5f/fiXnaEaz/lZl0xCF46uL3e1p
         jSICqpnIcHrRnRm4i7zA+sVHIW+83BB5RS32A1V7nwV9BrkSIYXBsI9haNWZ6palzeFp
         oMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FRrYeh/eZSmBAGMtTw4vFQ8VoilGhVsEkxG9XZTvSwI=;
        b=aG/cV6ex714LxB25NOpnSdn9X22PJSxkZe3u2ofNJ/rRc0GcndccmMvcJIMcumzEJU
         euMxHWHAxNif+fSOTJAzfDaPHuBiXd8/4ZZMzVPMf5cQ65ROppadsf9o5gykEvRJYv4y
         OQQc8XDre742GCINRxHwN/BHPBc3XhdeD2xnA6OxticOa9yjEh+Bw+DrL/QZzcOoN+Vj
         sALcuYqCR38FMJuVbCPOw4sHVOQwgbSxO9dBClH92bzvbkBzubZkFZUTeC1sQxd97FSX
         ASnVGeKIazlRxnlyUM1FMVhvjCv9J23TbiioxDlDk0gFqus1KSVjKWqO7FpGQnvEqwxw
         8PJw==
X-Gm-Message-State: AOAM5305vO06kUchUBwzTrRGJ8sfTFKu52YHaGh5zW5VvMgFz2CFrFmg
        LE2EJdyLHrut9m82hpKhEYw=
X-Google-Smtp-Source: ABdhPJzlSK6Tew4vLwPxx9HJZjXLiWpJYgtp1Vbk2KMwwVOU1gRxl3rLPK6wbACMX+Zn/Kp/x92j3Q==
X-Received: by 2002:a9d:5d02:: with SMTP id b2mr3359460oti.148.1611937369848;
        Fri, 29 Jan 2021 08:22:49 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id w11sm2229540otl.13.2021.01.29.08.22.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jan 2021 08:22:49 -0800 (PST)
Subject: Re: [PATCH iproute-next v2] devlink: add support for port params
 get/set
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        netdev@vger.kernel.org
Cc:     jiri@nvidia.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        kuba@kernel.org
References: <20210125134838.22439-1-oleksandr.mazur@plvision.eu>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5a96437d-a1d4-8535-e9c1-fd29b1eb8166@gmail.com>
Date:   Fri, 29 Jan 2021 09:22:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125134838.22439-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/21 6:48 AM, Oleksandr Mazur wrote:
> Add implementation for the port parameters getting/setting.
> Add bash completion for port param.
> Add man description for port param.
> 

Add example commands here - both set and show. Include a json version of
the show.

> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> ---
> V2:
>     1) Add bash completion for port param;
>     2) Add man decsription / examples for port param;
> 
>  bash-completion/devlink |  55 ++++++++
>  devlink/devlink.c       | 275 +++++++++++++++++++++++++++++++++++++++-
>  man/man8/devlink-port.8 |  65 ++++++++++
>  3 files changed, 389 insertions(+), 6 deletions(-)
> 

> diff --git a/devlink/devlink.c b/devlink/devlink.c
> index a2e06644..0fc1d4f0 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c
> @@ -2706,7 +2706,8 @@ static void pr_out_param_value(struct dl *dl, const char *nla_name,
>  	}
>  }
>  
> -static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array)
> +static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array,
> +			 bool is_port_param)
>  {
>  	struct nlattr *nla_param[DEVLINK_ATTR_MAX + 1] = {};
>  	struct nlattr *param_value_attr;
> @@ -2714,6 +2715,7 @@ static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array)
>  	int nla_type;
>  	int err;
>  
> +

stray newline here


