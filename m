Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB78146F6E
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgAWRSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:18:42 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:50901 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbgAWRSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 12:18:41 -0500
Received: by mail-pj1-f65.google.com with SMTP id r67so1494540pjb.0;
        Thu, 23 Jan 2020 09:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nxx5unrQ+dpzFU606H47zaLtZOuGy3CKKngWO6U1V/Q=;
        b=JPYAj+NtrlwAR6+4Kc+mM6OdVkAVRUZd93UivgJ1bbdYxjfuWNDmY1r6QYTA+3qjD/
         B+9h4PvEu2KossTmmTKV+hQuC2zGUqyRFHM2lnlNGATU7bWJO/50ziIGjG8UPpOVZYC9
         pPkUEuQ26tymD3Einv0KGFWzcNDECkUXnCuh3Jv4iqt5Mad8lRA9jxH8lys8KckUhKbA
         1LV+xvtbp4szU/7tmSWBhB1pk2wWBW6INTYFzJs5ywmTGlUMAaYEr+hIzai2LVkPfpB8
         1JtNfvjz+gz3WPTr2hMltTTTdtbxytOt5+ERceHV1mHfWvlAzTxudFeozgq/khE4fgdI
         9KDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nxx5unrQ+dpzFU606H47zaLtZOuGy3CKKngWO6U1V/Q=;
        b=S8UC4qkwxvNEeO34k/GXqmKjC8osabncwAs/t7UDzAZ3UHxQqL/G1FdIdyYeN6BPXo
         yPZJODJlM3j4EAd6MCBUyhwpdqXj0YiH5pFAARi3Oy3GeWzRyK+GrP2AECxHBFnbAVov
         yERicEV6f2A8yezoZgCO1xeBC+eozGQE5velurXKgbnj+D0A0Ub9Ib900XOfj6HJbhm4
         UWbknJI/WX3DfIZVWZV6Hn4H/hiAfqElf4Ce0MjnYXr6nlWvZelkniWXSC8s926nSKuf
         7b44m6RP/lZ3GzlCBJRTOkR+EwpEjLzhuolJ+ybwlZPJADc+ER6wXdbvz0sUPncHqrTW
         ry7w==
X-Gm-Message-State: APjAAAWq2SGMyh/1Pc7SIBx/193sHcxCwJB9Lioldwwa8liJklN565kA
        xVJi89EmxILh8LtNVeivij4=
X-Google-Smtp-Source: APXvYqz6xQmDP5LCut3w4LoNTLTsP5ELddtUYcap0D31AdDlji4jaBXFGI15QIXbjE7AsEooiSt29g==
X-Received: by 2002:a17:90a:804a:: with SMTP id e10mr5701058pjw.41.1579799921188;
        Thu, 23 Jan 2020 09:18:41 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id s18sm3347075pfh.179.2020.01.23.09.18.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 09:18:40 -0800 (PST)
Subject: Re: [PATCH bpf-next v4 02/12] net, sk_msg: Annotate lockless access
 to sk_prot on clone
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
References: <20200123155534.114313-1-jakub@cloudflare.com>
 <20200123155534.114313-3-jakub@cloudflare.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a6bf279e-a998-84ab-4371-cd6c1ccbca5d@gmail.com>
Date:   Thu, 23 Jan 2020 09:18:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200123155534.114313-3-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/23/20 7:55 AM, Jakub Sitnicki wrote:
> sk_msg and ULP frameworks override protocol callbacks pointer in
> sk->sk_prot, while tcp accesses it locklessly when cloning the listening
> socket, that is with neither sk_lock nor sk_callback_lock held.
> 
> Once we enable use of listening sockets with sockmap (and hence sk_msg),
> there will be shared access to sk->sk_prot if socket is getting cloned
> while being inserted/deleted to/from the sockmap from another CPU:
> 
> Read side:
> 
> tcp_v4_rcv
>   sk = __inet_lookup_skb(...)
>   tcp_check_req(sk)
>     inet_csk(sk)->icsk_af_ops->syn_recv_sock
>       tcp_v4_syn_recv_sock
>         tcp_create_openreq_child
>           inet_csk_clone_lock
>             sk_clone_lock
>               READ_ONCE(sk->sk_prot)
> 
> Write side:
> 
> sock_map_ops->map_update_elem
>   sock_map_update_elem
>     sock_map_update_common
>       sock_map_link_no_progs
>         tcp_bpf_init
>           tcp_bpf_update_sk_prot
>             sk_psock_update_proto
>               WRITE_ONCE(sk->sk_prot, ops)
> 
> sock_map_ops->map_delete_elem
>   sock_map_delete_elem
>     __sock_map_delete
>      sock_map_unref
>        sk_psock_put
>          sk_psock_drop
>            sk_psock_restore_proto
>              tcp_update_ulp
>                WRITE_ONCE(sk->sk_prot, proto)
> 
> Mark the shared access with READ_ONCE/WRITE_ONCE annotations.
> 
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  include/linux/skmsg.h | 3 ++-
>  net/core/sock.c       | 5 +++--
>  net/ipv4/tcp_bpf.c    | 4 +++-
>  net/ipv4/tcp_ulp.c    | 3 ++-
>  net/tls/tls_main.c    | 3 ++-
>  5 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 41ea1258d15e..55c834a5c25e 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -352,7 +352,8 @@ static inline void sk_psock_update_proto(struct sock *sk,
>  	psock->saved_write_space = sk->sk_write_space;
>  
>  	psock->sk_proto = sk->sk_prot;
> -	sk->sk_prot = ops;
> +	/* Pairs with lockless read in sk_clone_lock() */
> +	WRITE_ONCE(sk->sk_prot, ops);


Note there are dozens of calls like

if (sk->sk_prot->handler)
    sk->sk_prot->handler(...);

Some of them being done lockless.

I know it is painful, but presumably we need

const struct proto *ops = READ_ONCE(sk->sk_prot);

if (ops->handler)
    ops->handler(....);

