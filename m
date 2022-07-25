Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AEE57FA64
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 09:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiGYHnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 03:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiGYHnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 03:43:04 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC59512A90
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 00:43:03 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id sz17so19033807ejc.9
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 00:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=upMEmh+I6YGZG6c6EtpIGF8esGPJ+kf2J+SaVLbY2I8=;
        b=rEUkYjeXEtLqLitKufIF/+JMoLRGiStjaP6GGVJDdi4iNhj4M4CLvV/6xyNL9CzwvA
         5TRAs6YiDwKzOvASRhb89b+nR7JmZ+BgTSaM05KIS5vfNmj8V7i3CXf2IekscTvmwTMR
         8baikAG3zAEHoeIecgcQSyy6WkhaJLrtan6jx1eM6ZUBRKnIsMtcst7ZHpc18g1FGs/j
         rJfwdCECRKN4PAka0+bnscS8zRR/9PJes1X0CprM30757PFrin3tH0sNkeF7AV1zD4wo
         FMb9pwNeqCR9yVeYI6bfTzU6El+c7DOw2dK68ZqIIt4vUdUWv1h8A1jEjAcmE5M8UPDm
         dbyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=upMEmh+I6YGZG6c6EtpIGF8esGPJ+kf2J+SaVLbY2I8=;
        b=T2eqwspst+fngRM9qkSDfIGjMPQOH81aWRpDmiB8541p3mp/mRplNnBoNgDem7zqUW
         8g9pDs/6yFu6bdHwkktOF5v53OegtmR0y4RSx/4lmG9mczFo2fjCv9HRNc1VW+4UYcqb
         OlmbJY6fjhe2NJD9deOzBhnmtgGLb6DkfVGvgYzqx2R3dvCMMN6UolKUR46Bux+IpYJN
         BLQK/0CIFSgyuTvWdW0FwInvJtoNYec2gErW3nsB4FSGBUoKcUZekWkBUyru0Ota0dIP
         ymhy1BkL16JZbDLrWZIJXc7IFSlQ0YxKznQ8OF6w+XYm28wnXzhN68CN2Wu5dIINhC6m
         QOew==
X-Gm-Message-State: AJIora/8hsn+RM+RZcYGSNVLcHyrJMx3V9nAVSUaxpGc7CyKQBbf5xdh
        LSl1VSwXDkotFJ2Hekq92KWjvg==
X-Google-Smtp-Source: AGRyM1skybWbDLS44Ol93Ugr6CHiFaJsDXTxjCIdLCP+KH4CRn6Q/07x/QWWtpXmRg0kI0Lty8ItqA==
X-Received: by 2002:a17:907:75d3:b0:72b:48de:e540 with SMTP id jl19-20020a17090775d300b0072b48dee540mr9370069ejc.547.1658734982328;
        Mon, 25 Jul 2022 00:43:02 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id mc9-20020a170906eb4900b00715a02874acsm5092356ejb.35.2022.07.25.00.43.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 00:43:01 -0700 (PDT)
Message-ID: <fdc3a288-c342-1c6d-4cf0-640bbfd44f56@blackwall.org>
Date:   Mon, 25 Jul 2022 10:43:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net] bridge: Do not send empty IFLA_AF_SPEC attribute
Content-Language: en-US
To:     Benjamin Poirier <bpoirier@nvidia.com>, netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <20220725001236.95062-1-bpoirier@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220725001236.95062-1-bpoirier@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/07/2022 03:12, Benjamin Poirier wrote:
> After commit b6c02ef54913 ("bridge: Netlink interface fix."),
> br_fill_ifinfo() started to send an empty IFLA_AF_SPEC attribute when a
> bridge vlan dump is requested but an interface does not have any vlans
> configured.
> 
> iproute2 ignores such an empty attribute since commit b262a9becbcb
> ("bridge: Fix output with empty vlan lists") but older iproute2 versions as
> well as other utilities have their output changed by the cited kernel
> commit, resulting in failed test cases. Regardless, emitting an empty
> attribute is pointless and inefficient.
> 
> Avoid this change by canceling the attribute if no AF_SPEC data was added.
> 
> Fixes: b6c02ef54913 ("bridge: Netlink interface fix.")
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
> ---
>  net/bridge/br_netlink.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index bb01776d2d88..c96509c442a5 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -589,9 +589,13 @@ static int br_fill_ifinfo(struct sk_buff *skb,
>  	}
>  
>  done:
> +	if (af) {
> +		if (nlmsg_get_pos(skb) - (void *)af > nla_attr_size(0))
> +			nla_nest_end(skb, af);
> +		else
> +			nla_nest_cancel(skb, af);
> +	}
>  
> -	if (af)
> -		nla_nest_end(skb, af);
>  	nlmsg_end(skb, nlh);
>  	return 0;
>  

br_fill_ifinfo has been a mess, at some point we have to refactor it.

Anyway, thanks for the patch:
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

