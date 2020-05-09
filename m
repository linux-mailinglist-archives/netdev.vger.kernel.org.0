Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58541CC4B1
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 23:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgEIVUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 17:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgEIVUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 17:20:40 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7499FC061A0C
        for <netdev@vger.kernel.org>; Sat,  9 May 2020 14:20:40 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id u11so5527979iow.4
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 14:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+xj/Y/zWB4lVUu6CUBMG5wqC3IQ4fTkBYR1Rj2yVv1c=;
        b=U5lN6cg/6BESmG/AUp4Vb12MUULgKMPycTkQVGRVBUsdjTi6/LYRp1MgjFi+biBzsX
         r8B0qAPXpXkOpFL+bKNQ5aKWsMR9p11pfJNK/iQF2Kb9h+bk08UtKC+mzVYH0GQxjnT5
         z+fkxRA3tohMhjsQpK9y5pHdB77ivecoH0TF0KFhRSidh8NXQh6ehQxhIiKuAiMzZ07R
         oxtdgDKZ/5MixLTsxN/P3hVAyIdvBN2uy3EDqEMv5HdGhwHHiOSbjmw+rXGhYM/IUYci
         CjHC2vCf3HxYQqxlaLKYz6Q9Ykw2t9+4+z3jsJtoLFgBedvYjqCzJvD4LMLgrU0KxfBX
         84jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+xj/Y/zWB4lVUu6CUBMG5wqC3IQ4fTkBYR1Rj2yVv1c=;
        b=GNunzYBbZIx6cQm1/E9j6nEL+hCo6tyCTM+ig1BjECZm7qY9+VXwLTczKa6gYtAU5H
         0CcbumFXktv80tVoVaX2EJ795FMOCn7t3SKfueKoDnz7ofFmTghy2BBrq+E63ECVv0UB
         UsUGVoqC23/u9K9mFUjfsmeozfFD8XuLq5xRKHsbVzieaSJF5lwZpIpMjh3iK4j3k61Z
         6/mwcrcQFqNIc2zaJRKfHRu46uLfhFh4QFPZww673GZTgfa2n7yZPvOC9G39ttR2+ttM
         J5+QR1ASE4qKA2DUDM2facuLcsXXkd2NGT+l1w0g1VoP2y84pjTDK5FHNBnSHs2HUglL
         vIVA==
X-Gm-Message-State: AGi0PubVC/Pmmme1DOz02+Dj+yfWdL8uxA4bfK0oibUcKs88EylC75WR
        KpL031MXuWGS1EBY1LWjyCcFGwMo
X-Google-Smtp-Source: APiQypKP7/qTI3rzrOwLCSSbfXJs9bAg3kEot7JAS+fBa00i30ShdRI+yVBqZ/rc+oyGAnRWTkkzyg==
X-Received: by 2002:a6b:d10f:: with SMTP id l15mr8784968iob.143.1589059239523;
        Sat, 09 May 2020 14:20:39 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:d4f4:54fc:fab0:ac04? ([2601:282:803:7700:d4f4:54fc:fab0:ac04])
        by smtp.googlemail.com with ESMTPSA id k2sm2379819ioq.20.2020.05.09.14.20.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 14:20:38 -0700 (PDT)
Subject: Re: [PATCH] net-icmp: make icmp{,v6} (ping) sockets available to all
 by default
To:     Ido Schimmel <idosch@idosch.org>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>
References: <20200508234223.118254-1-zenczykowski@gmail.com>
 <20200509191536.GA370521@splinter>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a4fefa7c-8e8a-6975-aa06-b71ba1885f7b@gmail.com>
Date:   Sat, 9 May 2020 15:20:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200509191536.GA370521@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/20 1:15 PM, Ido Schimmel wrote:
> 
> This will unfortunately cause regressions with VRFs because they don't
> work correctly with ping sockets. Simple example:

Thanks for catching this, Ido.

> 
> diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> index 535427292194..8463b0e9e811 100644
> --- a/net/ipv4/ping.c
> +++ b/net/ipv4/ping.c
> @@ -297,6 +297,7 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
>         struct net *net = sock_net(sk);
>         if (sk->sk_family == AF_INET) {
>                 struct sockaddr_in *addr = (struct sockaddr_in *) uaddr;
> +               u32 tb_id = RT_TABLE_LOCAL;
>                 int chk_addr_ret;
>  
>                 if (addr_len < sizeof(*addr))
> @@ -310,7 +311,15 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
>                 pr_debug("ping_check_bind_addr(sk=%p,addr=%pI4,port=%d)\n",
>                          sk, &addr->sin_addr.s_addr, ntohs(addr->sin_port));
>  
> -               chk_addr_ret = inet_addr_type(net, addr->sin_addr.s_addr);
> +               if (sk->sk_bound_dev_if) {

that's the key point - checking sk->sk_bound_dev_if.

> +                       tb_id = l3mdev_fib_table_by_index(net,
> +                                                         sk->sk_bound_dev_if);
> +                       if (!tb_id)
> +                               tb_id = RT_TABLE_LOCAL;
> +               }
> +
> +               chk_addr_ret = inet_addr_type_table(net, addr->sin_addr.s_addr,
> +                                                   tb_id);
>  
>                 if (addr->sin_addr.s_addr == htonl(INADDR_ANY))
>                         chk_addr_ret = RTN_LOCAL;
> 

From a scan of the ipv4/ping.c code, ping_v4_sendmsg also does not
acknowledge sk->sk_bound_dev_if.
