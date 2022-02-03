Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08EC44A80F5
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 10:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238352AbiBCJHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 04:07:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32444 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234046AbiBCJHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 04:07:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643879258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LpZ1yLCzt0SUTLL2VOHFWqxbBRvJ8Nde4NokIeNHuPE=;
        b=Geug6VIF0OxUNTxjQdixJHoPbPw4g3ilG2LTjCvd4c8HA9IbBW2YrGy3p1VBgagbNcaNxj
        R3emGIeNv4Q6w8tAbu+HDYNEcP1bFukAUEw7UQQQEDnjFB2DqdOl98vwZSF4KtMevmb2wy
        mvaNwa8lHVElznzpwqOxSXrloOoT7n0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-4X_aggSWOZaLchhvg33HFg-1; Thu, 03 Feb 2022 04:07:37 -0500
X-MC-Unique: 4X_aggSWOZaLchhvg33HFg-1
Received: by mail-qv1-f70.google.com with SMTP id jo10-20020a056214500a00b00421ce742399so1881689qvb.14
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 01:07:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=LpZ1yLCzt0SUTLL2VOHFWqxbBRvJ8Nde4NokIeNHuPE=;
        b=rWCZbg9YBzG5FPck5KBQGCpyhVRcOQ+qWYKfRo6bssRfAzt3KOB3cq4AU3awi1G9Jj
         M9qq4e/ZVdnzMCROyXe6Uk6v1GOc2DPJF0U1B/9G+1iUTSJSlDt4opJvg/fHSIyEhj1p
         RUCCtIpLR/g+qlKBUDJaXfpy6ISg5W5sNREnvuNlz9ZSTTFQ958ceWlQzIX+EjaBMvJD
         fLAEALd0DSlvi0XTuhPLl6k30NvVgV2Qn3hsDrj8Zz4HcwuFIsEDUQXrVkE4eezeizgL
         VaU6dSPsrP5D+0ARi6gi/J7knK0qgjcfEb1rPELpUwHvRCcBX4X6VtEmJ8lsSqb7rz89
         nJcQ==
X-Gm-Message-State: AOAM5326hIyjzbciwTAev/kx82gqXeIPEn7edRTJYMVblP9M98TVE6BQ
        awgqNaX2yDK+g+U3//dB0KBiCsiRc9t0WR3JlAhC2Zlo8S8E6Y7ZhMrmd1CPNlGcSoEbXM2FHIC
        6fD+xmyzdq+k4b6vm
X-Received: by 2002:a05:6214:29cd:: with SMTP id gh13mr30241702qvb.14.1643879256742;
        Thu, 03 Feb 2022 01:07:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxtIvexuA5TBToAr8I4B70x2qtWEvj+bzVAhZtZfgSVeA+mBiwbWO1NGNSU090+kHHKoV3ONQ==
X-Received: by 2002:a05:6214:29cd:: with SMTP id gh13mr30241690qvb.14.1643879256520;
        Thu, 03 Feb 2022 01:07:36 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id s14sm13507247qkp.79.2022.02.03.01.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 01:07:35 -0800 (PST)
Message-ID: <cefef8b5dfd8f5944e74f5f6bf09692f4984db6a.camel@redhat.com>
Subject: Re: [PATCH net-next 08/15] ipv6: Add hop-by-hop header to
 jumbograms in ip6_output
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>
Date:   Thu, 03 Feb 2022 10:07:32 +0100
In-Reply-To: <20220203015140.3022854-9-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
         <20220203015140.3022854-9-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-02-02 at 17:51 -0800, Eric Dumazet wrote:
> From: Coco Li <lixiaoyan@google.com>
> 
> Instead of simply forcing a 0 payload_len in IPv6 header,
> implement RFC 2675 and insert a custom extension header.
> 
> Note that only TCP stack is currently potentially generating
> jumbograms, and that this extension header is purely local,
> it wont be sent on a physical link.
> 
> This is needed so that packet capture (tcpdump and friends)
> can properly dissect these large packets.
> 
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/linux/ipv6.h  |  1 +
>  net/ipv6/ip6_output.c | 22 ++++++++++++++++++++--
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
> index 1e0f8a31f3de175659dca9ecee9f97d8b01e2b68..d3fb87e1589997570cde9cb5d92b2222008a229d 100644
> --- a/include/linux/ipv6.h
> +++ b/include/linux/ipv6.h
> @@ -144,6 +144,7 @@ struct inet6_skb_parm {
>  #define IP6SKB_L3SLAVE         64
>  #define IP6SKB_JUMBOGRAM      128
>  #define IP6SKB_SEG6	      256
> +#define IP6SKB_FAKEJUMBO      512
>  };
>  
>  #if defined(CONFIG_NET_L3_MASTER_DEV)
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index 0c6c971ce0a58b50f8a9349b8507dffac9c7818c..f78ba145620560e5d7cb25aaf16fec61ddd9ed40 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -180,7 +180,9 @@ static int __ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff
>  #endif
>  
>  	mtu = ip6_skb_dst_mtu(skb);
> -	if (skb_is_gso(skb) && !skb_gso_validate_network_len(skb, mtu))
> +	if (skb_is_gso(skb) &&
> +	    !(IP6CB(skb)->flags & IP6SKB_FAKEJUMBO) &&
> +	    !skb_gso_validate_network_len(skb, mtu))
>  		return ip6_finish_output_gso_slowpath_drop(net, sk, skb, mtu);

If I read correctly jumbogram with gso len not fitting the egress
device MTU will not be fragmented, as opposed to plain old GSO packets.
Am I correct? why fragmentation is not needed for jumbogram?

Thanks!

Paolo

