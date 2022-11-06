Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A179261E581
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 20:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiKFTS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 14:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiKFTS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 14:18:58 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169C6BC38;
        Sun,  6 Nov 2022 11:18:57 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id kt23so25090248ejc.7;
        Sun, 06 Nov 2022 11:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R6ktwVsrXY/lIOSJHwdf2G6lUxvlfVMNzHCVZrdS9jM=;
        b=AcYg7SxvOjMpW8TYba1jGLxkW5mJtqNQ4SMDtN6buysOoQWjaS51l99kGWUOm0CXSQ
         /q9ZcuI/9niTgFcbecLWqnqkLqQI1J/76pv9QK7jaGhYgfevMoaAQ1oryZu7tKFVRSRf
         wCLCM72SmLt41np4LIFcWTBdUMETDVNje5u81zz+msyLBsypgYc8kk9T+yLacX+Wn/y9
         9bfoY2gCcRs3j/9fDfah1ocrxwFY6giJny/Ih3kMzfDtKfMyqsvIbvHEq0Xk2IEUYafU
         lstmKSGwjOJeCSrL4QKipZfO/7DdFfnrgQC56QWgcZBqxY9ibzL842/PRSM3NEqkCOvI
         7YLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R6ktwVsrXY/lIOSJHwdf2G6lUxvlfVMNzHCVZrdS9jM=;
        b=1FO6kN1Z5SG+/ywFkjEHI7CukjlcqF/nDPSLdRnQehw+2fJ62yUoaCadlcoFqlsfT8
         qpv8zTh7xMwWwdHDPbqdLzwJDFZ56H2Tgis15RgvwpBTQWfMvJzfcseNd6D+WHXKSNxR
         fs+6IjBSf27MNsXga2gGyBcUsNWuCslnXEdzaPrrzSF1GcjyBbwXAmKrWWCh6Ed9AADs
         IeqHsGkZitz/p//UuJfd7qp+fsbSdkShDWTXHD75GDyv0z9maw9GblnUoQcXQAx3s0Ym
         JQC4hjoEpBeR+hyGmzQaByGiDbqk4hsHveDqQTsTu3gzFnqZVZGVvVcHwN/n75r1r20N
         Cf5Q==
X-Gm-Message-State: ACrzQf2pz7hZ4ogfJqnt5ZTgC69eLF9Z7MiWdqAVMnI8v9P7fjGix6r6
        Hoiq9Zbji9OjRv8/eKgWYZaIh0ZjWY6oD82Rn64=
X-Google-Smtp-Source: AMsMyM5oWohBpZefD5gpRZQCHp72vaaoTFNLblYOA5B9Lt2coEd3zLecHm/LloZbT+nHcF8+k0xTu7erSGFukB0MvQc=
X-Received: by 2002:a17:907:a4e:b0:77d:94d:8148 with SMTP id
 be14-20020a1709070a4e00b0077d094d8148mr42658210ejc.607.1667762335397; Sun, 06
 Nov 2022 11:18:55 -0800 (PST)
MIME-Version: 1.0
References: <20221103172419.20977-1-kuniyu@amazon.com>
In-Reply-To: <20221103172419.20977-1-kuniyu@amazon.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Sun, 6 Nov 2022 11:18:44 -0800
Message-ID: <CAJnrk1ZF_0vG0gS0cVVjZSaiKpCFCbw3=C9twQqy-n9qPjoBiQ@mail.gmail.com>
Subject: Re: [PATCH v1 net] dccp/tcp: Reset saddr on failure after inet6?_hash_connect().
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Arnaldo Carvalho de Melo <acme@mandriva.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        dccp@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 3, 2022 at 10:24 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> When connect() is called on a socket bound to the wildcard address,
> we change the socket's saddr to a local address.  If the socket
> fails to connect() to the destination, we have to reset the saddr.
>
> However, when an error occurs after inet_hash6?_connect() in
> (dccp|tcp)_v[46]_conect(), we forget to reset saddr and leave
> the socket bound to the address.
>
> From the user's point of view, whether saddr is reset or not varies
> with errno.  Let's fix this inconsistent behaviour.
>
> Note that with this patch, the repro [0] will trigger the WARN_ON()
> in inet_csk_get_port() again, but this patch is not buggy and rather
> fixes a bug papering over the bhash2's bug [1] for which we need
> another fix.
>
> For the record, the repro causes -EADDRNOTAVAIL in inet_hash6_connect()
> by this sequence:
>
>   s1 = socket()
>   s1.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
>   s1.bind(('127.0.0.1', 10000))
>   s1.sendto(b'hello', MSG_FASTOPEN, (('127.0.0.1', 10000)))
>   # or s1.connect(('127.0.0.1', 10000))
>
>   s2 = socket()
>   s2.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
>   s2.bind(('0.0.0.0', 10000))
>   s2.connect(('127.0.0.1', 10000))  # -EADDRNOTAVAIL
>
>   s2.listen(32)  # WARN_ON(inet_csk(sk)->icsk_bind2_hash != tb2);
>
> [0]: https://syzkaller.appspot.com/bug?extid=015d756bbd1f8b5c8f09
> [1]: https://lore.kernel.org/netdev/20221029001249.86337-1-kuniyu@amazon.com/
>
> Fixes: 3df80d9320bc ("[DCCP]: Introduce DCCPv6")
> Fixes: 7c657876b63c ("[DCCP]: Initial implementation")
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  net/dccp/ipv4.c     | 2 ++
>  net/dccp/ipv6.c     | 2 ++
>  net/ipv4/tcp_ipv4.c | 2 ++
>  net/ipv6/tcp_ipv6.c | 2 ++
>  4 files changed, 8 insertions(+)
>
> diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> index 713b7b8dad7e..40640c26680e 100644
> --- a/net/dccp/ipv4.c
> +++ b/net/dccp/ipv4.c
> @@ -157,6 +157,8 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>          * This unhashes the socket and releases the local port, if necessary.
>          */
>         dccp_set_state(sk, DCCP_CLOSED);
> +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +               inet_reset_saddr(sk);
>         ip_rt_put(rt);
>         sk->sk_route_caps = 0;
>         inet->inet_dport = 0;
> diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> index e57b43006074..626166cb6d7e 100644
> --- a/net/dccp/ipv6.c
> +++ b/net/dccp/ipv6.c
> @@ -985,6 +985,8 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>
>  late_failure:
>         dccp_set_state(sk, DCCP_CLOSED);
> +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +               inet_reset_saddr(sk);
>         __sk_dst_reset(sk);
>  failure:
>         inet->inet_dport = 0;
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 87d440f47a70..6a3a732b584d 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -343,6 +343,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>          * if necessary.
>          */
>         tcp_set_state(sk, TCP_CLOSE);
> +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +               inet_reset_saddr(sk);
>         ip_rt_put(rt);
>         sk->sk_route_caps = 0;
>         inet->inet_dport = 0;
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 2a3f9296df1e..81b396e5cf79 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -359,6 +359,8 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>
>  late_failure:
>         tcp_set_state(sk, TCP_CLOSE);
> +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +               inet_reset_saddr(sk);
>  failure:
>         inet->inet_dport = 0;
>         sk->sk_route_caps = 0;
> --
> 2.30.2
>

inet_reset_saddr() sets both inet_saddr and inet_rcv_saddr to 0, but I
think there are some edge cases where when dccp/tcp_v4/6_connect() is
called, inet_saddr is 0 but inet_rcv_saddr is not, which means we'd
need to reset inet_rcv_saddr to its original value. The example case
I'm looking at is  __inet_bind() where if the request is to bind to a
multicast address,

    inet->inet_rcv_saddr = inet->inet_saddr = addr->sin_addr.s_addr;
    if (chk_addr_ret == RTN_MULTICAST || chk_addr_ret == RTN_BROADCAST)
        inet->inet_saddr = 0;  /* Use device */
