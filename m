Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D902E467BC3
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 17:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382127AbhLCQxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 11:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbhLCQxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 11:53:22 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F0DC061353
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 08:49:58 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so4052509otg.4
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 08:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OctAell+QrZ+fINl7Nrc+moNP5AbyyoUFsl4BTXpG0s=;
        b=ii3XUCi5Na/6FbOJOxV8HIpJvBdAwMrj/5wfoQIROWmM1tvXkcZNAUfdjMO4Eq7KYT
         /jRlAMdybvwnnKY0BqzIzOLul1Nm5duGx/tnJzTSpty8T+RR4XxgMZ0BmdDF2LPFzhhp
         27wp4/XQ9EaS6ToqB2yxuz/28wPc8wlIhH6ojWMZfL7XrWWVEjkzK25sGsjlJbNzPvyc
         BECyOcjoK3jYybT6cYAd3W4NOVKev9JF9MEnIYTGCAxsaztaJu4mAc9C9WDSCh2rW5mG
         PNTcvn1RY7EAYNH4OtQAeINKIjVUtSYo/tjrjser9mj6/JORNjonIRnR/hzDs6Jk4zzQ
         ogvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OctAell+QrZ+fINl7Nrc+moNP5AbyyoUFsl4BTXpG0s=;
        b=42zqeejbLIKocGz/EuY38PXbXYg4UZvXalB8T8savf/4WLAiDow6GQNW0mRHRHWSkc
         wQwijlqEzLxoj7xoeqw1I5aRdNfyl0r3T0SoK4jWT9nSQQa4RaXLFFjLR2lnBcmeNvbF
         /VvfGCmxlJEMqZkQNsCt3ROa+6gLIwOImf6LvWRnTZeuf/ewQFkc1ioAvZSES0TMXvAf
         CUiDyvCv58xX+4nRT6tTockWUb62QH+SK1cZsIHRxX7Rey7Sk2TVcxOzR6q/le7C6qcR
         GfeyDWKxf6Cy5mfTC4bGCCiP2XU6CpWHdODTvqLmzZY6sE9p82qJQjbCygJ7LO7ZgHUf
         W8og==
X-Gm-Message-State: AOAM533A8IrDBTNRVboooNAe27tcvvng112ifqh7BPNCx1igerPsSGE9
        JdEeAk0r7AL0jZOOciHy6Fo=
X-Google-Smtp-Source: ABdhPJxlTjxrayhWTNgmWvSZoSsO7I3U8NFsId1sdReZXwRPDl+CInEvEDld9PY5l8DDxe2DEDHEyA==
X-Received: by 2002:a9d:2648:: with SMTP id a66mr16690500otb.65.1638550198194;
        Fri, 03 Dec 2021 08:49:58 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id bi20sm871184oib.29.2021.12.03.08.49.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 08:49:57 -0800 (PST)
Message-ID: <387a41d6-6e7e-1512-a263-51e7e002baa4@gmail.com>
Date:   Fri, 3 Dec 2021 09:49:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [[PATCH net-next v3] 3/3] udp6: Use Segment Routing Header for
 dest address if present
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
References: <20211203162926.3680281-1-andrew@lunn.ch>
 <20211203162926.3680281-4-andrew@lunn.ch>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211203162926.3680281-4-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/3/21 9:29 AM, Andrew Lunn wrote:
> diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
> index 73aaabf0e966..4fd7d3793c1b 100644
> --- a/net/ipv6/seg6.c
> +++ b/net/ipv6/seg6.c
> @@ -134,6 +134,27 @@ void seg6_icmp_srh(struct sk_buff *skb, struct inet6_skb_parm *opt)
>  	skb->network_header = network_header;
>  }
>  
> +/* If the packet which invoked an ICMP error contains an SRH return
> + * the true destination address from within the SRH, otherwise use the
> + * destination address in the IP header.
> + */
> +const struct in6_addr *seg6_get_daddr(struct sk_buff *skb,
> +				      struct inet6_skb_parm *opt)
> +{
> +	/* ipv6_hdr() does not work here, since this IP header is
> +	 * nested inside an ICMP error report packet
> +	 */
> +	const struct ipv6hdr *hdr = (const struct ipv6hdr *)skb->data;
> +	struct ipv6_sr_hdr *srh;
> +
> +	if (opt->flags & IP6SKB_SEG6) {
> +		srh = (struct ipv6_sr_hdr *)(skb->data + opt->srhoff);
> +		return  &srh->segments[0];
> +	}
> +
> +	return &hdr->daddr;
> +}
> +
>  static struct genl_family seg6_genl_family;
>  
>  static const struct nla_policy seg6_genl_policy[SEG6_ATTR_MAX + 1] = {
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 6a0e569f0bb8..47125d83920a 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -40,6 +40,7 @@
>  #include <net/transp_v6.h>
>  #include <net/ip6_route.h>
>  #include <net/raw.h>
> +#include <net/seg6.h>
>  #include <net/tcp_states.h>
>  #include <net/ip6_checksum.h>
>  #include <net/ip6_tunnel.h>
> @@ -560,8 +561,8 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
>  {
>  	struct ipv6_pinfo *np;
>  	const struct ipv6hdr *hdr = (const struct ipv6hdr *)skb->data;
> +	const struct in6_addr *daddr = seg6_get_daddr(skb, opt);
>  	const struct in6_addr *saddr = &hdr->saddr;
> -	const struct in6_addr *daddr = &hdr->daddr;
>  	struct udphdr *uh = (struct udphdr *)(skb->data+offset);
>  	bool tunnel = false;
>  	struct sock *sk;
> 

I was thinking something like:

	const struct in6_addr *daddr

	daddr = seg6_get_daddr(skb, opt) ? : &hdr->daddr;

where seg6_get_daddr returns NULL if it is not returning an address due
to SR6 and in that case the lookup uses the daddr from the ipv6 hdr.
That keeps the SR6 logic independent.
