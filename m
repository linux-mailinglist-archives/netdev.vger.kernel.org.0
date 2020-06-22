Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EBD203B93
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 17:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbgFVPxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 11:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgFVPxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 11:53:03 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E33C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 08:53:03 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id d6so23895pjs.3
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 08:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mB+HxRuCm0P9xytyvFaTZPk7/skMf1wQkvrlo/87lMs=;
        b=tXG9vwVFoajp3yxChJg75qmjQamraYhsFVwTeL7a7qWe/rBkU0aEsys53orJfPzKkz
         zyEMWbPEg2eQXgv5XQ2wjxvyCM0mRwlsNqCkMcZF9J1mYWNgIk8lEYJ+GaPfVHr0x091
         jl/rusWAtCSyHGiN/br0uTQegau99Oyzf5EF/ez04fV3oBeAugAcYt0wnOzNbdPYQa3u
         Nksqb52GKDjiozfGeNHIEbwmv48gNKrNodYfp2QDAumhe314C02JurWFjCUAky7o1Xto
         utoOWSc/bpusthcjvPNZF90EQtiIMZX1JHoUDLP2BJB7keB044EafoP83xZEO6CM6Mvp
         SVsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mB+HxRuCm0P9xytyvFaTZPk7/skMf1wQkvrlo/87lMs=;
        b=QVvs+sRZUMCANsr8N3oyWdT5gvc9vVSkOelJDVGCIxsOYsNU73eFB4K/ceDU+KpjCx
         41kQbc/0A0Z/2Y7Jx61O3VIkrgTB2/h+frh1ZgEbbE5/ITa7o/YSl9iWIsfN1WUSbUXB
         PZYLPqPnwKXBbCytAmvIOfXRqayOgfE2AAdHu2U0BcICzhQQcmbBP0UABwlyC4G6Sgn1
         jJid8VlaGPWkLngJp2NLxjgRORQ8LRw7S8SWOJVgB6ENacRDylExYgke/nU/dMSUvlYv
         MLJ0W4/rlmCRF6vzV29YhHlHx6aFoDQMmySPuXkBjDGCDKNmeWAAxhPRgJo/wWZf9PJT
         dzUA==
X-Gm-Message-State: AOAM5314kBsTGrzB/KwsP62qiU1xTkaxYTXkqq0bm23ruuCPmsOBZjeh
        utGK0WuAiA30tiRYUC8nTsg=
X-Google-Smtp-Source: ABdhPJyNGQs9nAlmTcqnFrPKMMk+5ENIvLali6CTo6S45pT7F3zzHZ0zb7nY9rNikJIFOr9DHSpSuA==
X-Received: by 2002:a17:90a:ac05:: with SMTP id o5mr19478274pjq.228.1592841183466;
        Mon, 22 Jun 2020 08:53:03 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id lt14sm13709880pjb.52.2020.06.22.08.53.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 08:53:02 -0700 (PDT)
Subject: Re: [PATCH net] net: Do not clear the socket TX queue in
 sock_orphan()
To:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>
References: <1592748544-41555-1-git-send-email-tariqt@mellanox.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4254dfec-0901-73c4-a1f5-c6609db2baec@gmail.com>
Date:   Mon, 22 Jun 2020 08:53:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <1592748544-41555-1-git-send-email-tariqt@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/21/20 7:09 AM, Tariq Toukan wrote:
> sock_orphan() call to sk_set_socket() implies clearing the sock TX queue.
> This might cause unexpected out-of-order transmit, as outstanding packets
> can pick a different TX queue and bypass the ones already queued.
> This is undesired in general. More specifically, it breaks the in-order
> scheduling property guarantee for device-offloaded TLS sockets.
> 
> Introduce a function variation __sk_set_socket() that does not clear
> the TX queue, and call it from sock_orphan().
> All other callers of sk_set_socket() do not operate on an active socket,
> so they do not need this change.
> 
> Fixes: e022f0b4a03f ("net: Introduce sk_tx_queue_mapping")
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Reviewed-by: Boris Pismenny <borisp@mellanox.com>
> ---
>  include/net/sock.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> Please queue for -stable.
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index c53cc42b5ab9..23e43f3d79f0 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1846,10 +1846,15 @@ static inline int sk_rx_queue_get(const struct sock *sk)
>  }
>  #endif
>  
> +static inline void __sk_set_socket(struct sock *sk, struct socket *sock)
> +{
> +	sk->sk_socket = sock;
> +}
> +
>  static inline void sk_set_socket(struct sock *sk, struct socket *sock)
>  {
>  	sk_tx_queue_clear(sk);
> -	sk->sk_socket = sock;
> +	__sk_set_socket(sk, sock);
>  }
>  

Hmm...

I think we should have a single sk_set_socket() call, and remove
the sk_tx_queue_clear() from it.

sk_tx_queue_clear() should be put where it is needed, instead of being hidden
in sk_set_socket()

diff --git a/include/net/sock.h b/include/net/sock.h
index c53cc42b5ab92d0062519e60435b85c75564a967..3428619faae4340485b200f49d9cce4fb09086b3 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1848,7 +1848,6 @@ static inline int sk_rx_queue_get(const struct sock *sk)
 
 static inline void sk_set_socket(struct sock *sk, struct socket *sock)
 {
-       sk_tx_queue_clear(sk);
        sk->sk_socket = sock;
 }
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 6c4acf1f0220b1f925ebcfaa847632ec0dbe0b9b..134de0d37f77ba781b2b3341c94a97a1b2d57a2d 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1767,6 +1767,7 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
                cgroup_sk_alloc(&sk->sk_cgrp_data);
                sock_update_classid(&sk->sk_cgrp_data);
                sock_update_netprioidx(&sk->sk_cgrp_data);
+               sk_tx_queue_clear(sk);
        }
 
        return sk;
@@ -1990,6 +1991,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
                 */
                sk_refcnt_debug_inc(newsk);
                sk_set_socket(newsk, NULL);
+               sk_tx_queue_clear(newsk);
                RCU_INIT_POINTER(newsk->sk_wq, NULL);
 
                if (newsk->sk_prot->sockets_allocated)

