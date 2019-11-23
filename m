Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B75107FAF
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 18:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfKWRxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 12:53:39 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35409 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbfKWRxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 12:53:38 -0500
Received: by mail-pl1-f193.google.com with SMTP id s10so4613526plp.2
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 09:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZI1kclYC3V5oe3ghcpnoAPJ2p8mvDPPDP7Q9LyIs2CY=;
        b=JmA865UncInS6OCWKKHSZEc8t+P+czd02uictokOkJzeHJ8zR65yofIdFNOOBcYkQN
         gKmvYeTgJ6JFda4Wd+ZZBWle10soNqCU/gJ1Een24AvL0F6s02GxRn4QevzT4CTlzAvi
         5MR+hnvX1IZp7qtNDnKbzTCeUmxo7WJMqkPsQCLDVzI72PgST/D0y2g5N0BiJS0E0prk
         ppPsfx+Cggsdm43nVszozb3hIj2kOW7HAPQjuz2V8It2xIfq7m1zXwEe/tgjylbcceqB
         a48Tts2UrysO3pmVe6BAtu7cSSvxqJ3yMgLnoqA+FBpRMNU5YTjbmDcNOrgW01TlZuEo
         fNKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZI1kclYC3V5oe3ghcpnoAPJ2p8mvDPPDP7Q9LyIs2CY=;
        b=RtESRAR3urslkYu5sOZeKtbmdYzLDO1bCh1UySxJXIEZK8+bqA7M/zZG0PxAvxiq+g
         pOaY/K91piF2ia8IkLQoW1+dDdLWlW4uC1l1seJFH8stl3wReLnKsUm4Gs4NOR1SXXdd
         EPmb3590XRlTpmV25/XOk8uXHAFq7EAUmUX5K89cecSO8Reh11b5hZLfefI5bUqwep0S
         gZSqdiQqYp2K5Uo9uGUoGhwDtpUTSZ4R5TJf33KH4ljYCz1wua8cn/3zV/zCXqpIqHJG
         CJ+TIjiYtyuiHm1g7OxI2ltks1R8vWQ9OsBNJ+evXF31yDwTRLpjZ6yPjtQJny3rQrgh
         8VJQ==
X-Gm-Message-State: APjAAAWXr7eLxr4B/TArohBKxit82CiVSYJF4vhjlgmKm6bXvxoEGPC/
        ctc/ft2HlqZnqjbYFw4Dpjk+tinI
X-Google-Smtp-Source: APXvYqx6UCDFLf/25M//8Lcfw3Ahssqe+OluMwTaaq+dSZbkzswxRY3CSFllmdewZD69gFeo4b8PAQ==
X-Received: by 2002:a17:90a:8d0d:: with SMTP id c13mr26712569pjo.68.1574531616127;
        Sat, 23 Nov 2019 09:53:36 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id h23sm2630843pgg.58.2019.11.23.09.53.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 09:53:35 -0800 (PST)
Subject: Re: [PATCH] net: ip/tnl: Set iph->id only when don't fragment is not
 set
To:     Oliver Herms <oliver.peter.herms@gmail.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org
References: <20191123145817.GA22321@fuckup>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fa37491f-3604-bd3b-7518-dab654b641b6@gmail.com>
Date:   Sat, 23 Nov 2019 09:53:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191123145817.GA22321@fuckup>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/23/19 6:58 AM, Oliver Herms wrote:
> In IPv4 the identification field ensures that fragments of different datagrams
> are not mixed by the receiver. Packets with Don't Fragment (DF) flag set are not
> to be fragmented in transit and thus don't need an identification.

Official sources for this assertion please, so that we can double check if you
implemented the proper avoidance ?

> Calculating the identification takes significant CPU time.
> This patch will increase IP tunneling performance by ~10% unless DF is not set.
> However, DF is set by default which is best practice.
> 
> Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
> ---
>  net/ipv4/ip_tunnel_core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
> index 1452a97914a0..8636c1e0e7b7 100644
> --- a/net/ipv4/ip_tunnel_core.c
> +++ b/net/ipv4/ip_tunnel_core.c
> @@ -73,7 +73,9 @@ void iptunnel_xmit(struct sock *sk, struct rtable *rt, struct sk_buff *skb,
>  	iph->daddr	=	dst;
>  	iph->saddr	=	src;
>  	iph->ttl	=	ttl;
> -	__ip_select_ident(net, iph, skb_shinfo(skb)->gso_segs ?: 1);
> +
> +	if (unlikely((iph->frag_off & htons(IP_DF)) == false))

This unlikely() seems wrong to me.

You do not know what are the odds of IP_DF being set or not.



> +		__ip_select_ident(net, iph, skb_shinfo(skb)->gso_segs ?: 1);
>  
>  	err = ip_local_out(net, sk, skb);
>  
> 

So we are going to send 2 bytes with garbage if we do not call __ip_select_ident()

This would cause various security threats, since the garbage might reveal a secret.

