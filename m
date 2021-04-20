Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FED33660E5
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 22:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbhDTU3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 16:29:01 -0400
Received: from gateway34.websitewelcome.com ([192.185.148.142]:24882 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233891AbhDTU3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 16:29:00 -0400
X-Greylist: delayed 1386 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2021 16:29:00 EDT
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id A8B851966E7
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 15:05:19 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id YwcZlPWc6mJLsYwcZlmbQu; Tue, 20 Apr 2021 15:05:19 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uvJy4av23Scx/8w1MGTm9f6+b9FqV28bLS31Q0G/3KY=; b=i9X9nUUm10QLC6LQcmxJTAFmLo
        KJ9T/PVn/Tb7BHfJvSfWKKAcf+YvmJRCOdijLDNlAQoIbvvGtZTKE4qA7MiKuhq2d4NdrX1UUINa9
        L6qUWajUVdmD6b8WpByQFTzXy3b/DDvJLNV8382lfzyxdemliI6pfU4nhjmyGQOJb51pdBk9MEk3P
        BcuVzQmImlhIDVI1CwAI/zhbbLuNX/aU9mCzt2TByncHw462LAMklPa+9dz/GHzO0e4KNW/6DXzvo
        dJApuUwc+OyzdnSx15nyoMsxhZMLeP0EX3s9RvRKD7fbya+RN7J79WtgypcG8MekNM8nNRaZdoOof
        HjXGm7LA==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:48912 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lYwcV-002VCy-0C; Tue, 20 Apr 2021 15:05:15 -0500
Subject: Re: [PATCH RESEND][next] ipv4: Fix fall-through warnings for Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210305090205.GA139036@embeddedor>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <ef931d13-896f-0b9c-bb8c-1b710b0164af@embeddedor.com>
Date:   Tue, 20 Apr 2021 15:05:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210305090205.GA139036@embeddedor>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lYwcV-002VCy-0C
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:48912
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 8
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Friendly ping: who can take this, please?

Thanks
--
Gustavo

On 3/5/21 03:02, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
> warnings by explicitly adding multiple break statements instead of just
> letting the code fall through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  net/ipv4/ah4.c           | 1 +
>  net/ipv4/esp4.c          | 1 +
>  net/ipv4/fib_semantics.c | 1 +
>  net/ipv4/ip_vti.c        | 1 +
>  net/ipv4/ipcomp.c        | 1 +
>  5 files changed, 5 insertions(+)
> 
> diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
> index 36ed85bf2ad5..fab0958c41be 100644
> --- a/net/ipv4/ah4.c
> +++ b/net/ipv4/ah4.c
> @@ -450,6 +450,7 @@ static int ah4_err(struct sk_buff *skb, u32 info)
>  	case ICMP_DEST_UNREACH:
>  		if (icmp_hdr(skb)->code != ICMP_FRAG_NEEDED)
>  			return 0;
> +		break;
>  	case ICMP_REDIRECT:
>  		break;
>  	default:
> diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
> index 4b834bbf95e0..6cb3ecad04b8 100644
> --- a/net/ipv4/esp4.c
> +++ b/net/ipv4/esp4.c
> @@ -982,6 +982,7 @@ static int esp4_err(struct sk_buff *skb, u32 info)
>  	case ICMP_DEST_UNREACH:
>  		if (icmp_hdr(skb)->code != ICMP_FRAG_NEEDED)
>  			return 0;
> +		break;
>  	case ICMP_REDIRECT:
>  		break;
>  	default:
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index a632b66bc13a..4c0c33e4710d 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -1874,6 +1874,7 @@ static int call_fib_nh_notifiers(struct fib_nh *nh,
>  		    (nh->fib_nh_flags & RTNH_F_DEAD))
>  			return call_fib4_notifiers(dev_net(nh->fib_nh_dev),
>  						   event_type, &info.info);
> +		break;
>  	default:
>  		break;
>  	}
> diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
> index 31c6c6d99d5e..eb560eecee08 100644
> --- a/net/ipv4/ip_vti.c
> +++ b/net/ipv4/ip_vti.c
> @@ -351,6 +351,7 @@ static int vti4_err(struct sk_buff *skb, u32 info)
>  	case ICMP_DEST_UNREACH:
>  		if (icmp_hdr(skb)->code != ICMP_FRAG_NEEDED)
>  			return 0;
> +		break;
>  	case ICMP_REDIRECT:
>  		break;
>  	default:
> diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
> index b42683212c65..bbb56f5e06dd 100644
> --- a/net/ipv4/ipcomp.c
> +++ b/net/ipv4/ipcomp.c
> @@ -31,6 +31,7 @@ static int ipcomp4_err(struct sk_buff *skb, u32 info)
>  	case ICMP_DEST_UNREACH:
>  		if (icmp_hdr(skb)->code != ICMP_FRAG_NEEDED)
>  			return 0;
> +		break;
>  	case ICMP_REDIRECT:
>  		break;
>  	default:
> 
