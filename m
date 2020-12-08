Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE0B2D26CE
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgLHJDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728591AbgLHJDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:03:00 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DFCC06179C
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 01:02:20 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id m19so23500742ejj.11
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 01:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D292rnchnagOWW2nrkDLX5KQjbRLYsh4Pq7aFW+b4P0=;
        b=jJJ9a1eREXY/Zp+bSKAKPZsEo+YNdU2Q+1VaskhhOMVr3iKhmEAa2t+CvOVTKWpr4f
         YaKwUoL4AG8/gOso24uvacDF4SAI+gpEWr07kIiQBN/I/cDzFrXBALU3RKeZw1+IpIgX
         Up3Yaj0+jQ0wzRTzrRdzI3+l0zs5bHrzk0DMniMJCg7X2IvjhVGuvsfDql/1BgOpBqMv
         jxL+7mxpAdZN11qzIU3Eo5bOEA6VzA0VEkQv9TncL6reEqLLmbjcKZ8eonRMzmnD1oJw
         BQaQORn0RDZCA0OGBYTsX+CDa3ZijRce2+iQ3WeRiRUP0LPLw/mtZhY2tNgSDdB75gSi
         EDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=D292rnchnagOWW2nrkDLX5KQjbRLYsh4Pq7aFW+b4P0=;
        b=avhEMRDo+Cp0zAE1XD8Bj5x95n8Jq8HTIZT3xwD5y0bGEJatfvKY6/8BOPptoEoxpD
         uEBZR/ZIjyfYzMKRaU0e7fulaTFiQ5TTg3yEkXe1iNy4M9/xsY/TcRVeRrcrBOEb3Itd
         ImhLqNfxc6sL/vSruKduMCgZSO/44yz2L7O3NcpjA7bY50E42xJkVuMQgJvE81/cjJDv
         +obGkVUeD+Z6FoiD21xh7w5POQXq9z5UG1a0ihZvUinOQAHygohId0GztvqCy4VEGmGC
         Tn0/oL0p3BlQl7BW4gD3yPVVsueDglzywIKzIoYvcbe5X/riYyGpJXa83xo8QVy1TSk7
         Fu0Q==
X-Gm-Message-State: AOAM531OsdK5Z3+VK6XFGfEjeTSm/CdxOOPl6aZAibAW9cxNE/Bz+Hr/
        uX5C+QYESTD9WI3azP6PHf7WlkObf4nPOQ==
X-Google-Smtp-Source: ABdhPJzJSs1flUXfzucgSX7a5NileHk4PEQCXlXqFqC0mXTbOD7XWzFU4HGhEUrPl+lUL/lFySPF6Q==
X-Received: by 2002:a17:907:3f9e:: with SMTP id hr30mr22330553ejc.258.1607418138431;
        Tue, 08 Dec 2020 01:02:18 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:8c20:be83:b3f:b8b9? ([2a01:e0a:410:bb00:8c20:be83:b3f:b8b9])
        by smtp.gmail.com with ESMTPSA id n22sm16261112edr.11.2020.12.08.01.02.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 01:02:17 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2] xfrm: interface: Don't hide plain packets from
 netfilter
To:     Phil Sutter <phil@nwl.cc>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201207134309.16762-1-phil@nwl.cc>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <9d9cb6dc-32a3-ff1a-5111-7688ce7a2897@6wind.com>
Date:   Tue, 8 Dec 2020 10:02:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201207134309.16762-1-phil@nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 07/12/2020 à 14:43, Phil Sutter a écrit :
> With an IPsec tunnel without dedicated interface, netfilter sees locally
> generated packets twice as they exit the physical interface: Once as "the
> inner packet" with IPsec context attached and once as the encrypted
> (ESP) packet.
> 
> With xfrm_interface, the inner packet did not traverse NF_INET_LOCAL_OUT
> hook anymore, making it impossible to match on both inner header values
> and associated IPsec data from that hook.
> 
> Fix this by looping packets transmitted from xfrm_interface through
> NF_INET_LOCAL_OUT before passing them on to dst_output(), which makes
> behaviour consistent again from netfilter's point of view.
> 
> Fixes: f203b76d78092 ("xfrm: Add virtual xfrm interfaces")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - Extend recipients list, no code changes.
> ---
>  net/xfrm/xfrm_interface.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
> index aa4cdcf69d471..24af61c95b4d4 100644
> --- a/net/xfrm/xfrm_interface.c
> +++ b/net/xfrm/xfrm_interface.c
> @@ -317,7 +317,8 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
>  	skb_dst_set(skb, dst);
>  	skb->dev = tdev;
>  
> -	err = dst_output(xi->net, skb->sk, skb);
> +	err = NF_HOOK(skb_dst(skb)->ops->family, NF_INET_LOCAL_OUT, xi->net,
skb->protocol must be correctly set, maybe better to use it instead of
skb_dst(skb)->ops->family?

> +		      skb->sk, skb, NULL, skb_dst(skb)->dev, dst_output);
And here, tdev instead of skb_dst(skb)->dev ?

>  	if (net_xmit_eval(err) == 0) {
>  		struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
>  
> 
