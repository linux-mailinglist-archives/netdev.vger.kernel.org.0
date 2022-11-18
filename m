Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE99462F150
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 10:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241307AbiKRJgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 04:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbiKRJgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 04:36:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DB1B1DB
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 01:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668764112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2t5/ODphO1h5MB0YJPBr17tpcprttLy5noDFHHXrKp4=;
        b=TGvI84tf4MLhPyF6f0yUfsUjFNlRWJnF7UYbI9bd4mGkhP7nV9x+AtidnSMls6fieRL+Uj
        FXj/LUSl0XszKvHYpDNHF4BI11VmyjRm8vWYLmzM8ZuaQ2JqJM+GW5xz/HeIf89aDH0onb
        wshyvzJ6xjrRx/VAcG3Iis372icFTG8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-230-EhP6BaK6NoGBP1I2b3kCgA-1; Fri, 18 Nov 2022 04:35:11 -0500
X-MC-Unique: EhP6BaK6NoGBP1I2b3kCgA-1
Received: by mail-wr1-f70.google.com with SMTP id d23-20020adfa417000000b002364a31b7c9so1364723wra.15
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 01:35:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2t5/ODphO1h5MB0YJPBr17tpcprttLy5noDFHHXrKp4=;
        b=EdEpphdVWfsn5OX13EM6E0wZsZJfvzU7un/y3+qoxnfuicG69nOWPPVtufwqflEW1/
         5GKXlqnVT04ffdbJLkOiWgtN2i2ycHi1U+1y8jrJ2ov05XvxNA7A77GV8NhvwFZe6ep5
         ossO0MB1Y5es4VCumz52NPlSlk20cFxLXwxZS6OxO79LjMzNTMoJQuQFUXxkkt0upZXT
         3d+4Fwk+XE37rYvHEW5FBUhmRIMB/aeoZvCnQSOwDqU+k5M1F+zwrFmnoAgkiGDddn88
         YqsxPjSD32dsiVryVBXBJlQUkuPJiwza685vcwuVjkg9J50BlFAiT2h1sNNLV9SU0vch
         cPSw==
X-Gm-Message-State: ANoB5pl02FVemd+Kk69p+VHTzNunjbydFmvA1Gzi1hUcasecJq+/ir02
        kBGirfhmhl/rlOwM9neR30hizJIfxbQX8x99jpXiOFApqNmOnJmLFh8n3jn0Z+M/9owtM+mmbdC
        YLQenHAo2JzUcCiHV
X-Received: by 2002:a5d:48c3:0:b0:241:784b:1b7f with SMTP id p3-20020a5d48c3000000b00241784b1b7fmr3895708wrs.38.1668764110103;
        Fri, 18 Nov 2022 01:35:10 -0800 (PST)
X-Google-Smtp-Source: AA0mqf51rmExaLG1D4wy/bRqxx3ttdDvnw2drAiSTXKRzDL71uKkOjQIPC1q2m0al2R1rBRiblcP7g==
X-Received: by 2002:a5d:48c3:0:b0:241:784b:1b7f with SMTP id p3-20020a5d48c3000000b00241784b1b7fmr3895690wrs.38.1668764109746;
        Fri, 18 Nov 2022 01:35:09 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id l13-20020a5d668d000000b00236488f62d6sm3063206wru.79.2022.11.18.01.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 01:35:09 -0800 (PST)
Message-ID: <d55e881a95e144e82b90225d6834e99fb9a91248.camel@redhat.com>
Subject: Re: [PATCH v1 net] net: Return errno in sk->sk_prot->get_port().
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Christoph Paasch <cpaasch@apple.com>,
        Florian Westphal <fw@strlen.de>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev
Date:   Fri, 18 Nov 2022 10:35:07 +0100
In-Reply-To: <20221117184723.29318-1-kuniyu@amazon.com>
References: <20221117184723.29318-1-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-11-17 at 10:47 -0800, Kuniyuki Iwashima wrote:
> We assume the correct errno is -EADDRINUSE when sk->sk_prot->get_port()
> fails, so some ->get_port() functions return just 1 on failure and the
> callers return -EADDRINUSE instead.
> 
> However, mptcp_get_port() can return -EINVAL.  Let's not ignore the error.

Note that such return value is on a WARN_ON_ONCE() check. I think such
condition is actually an overzealot error checking and we could
possibly/likelly remove it in the future.

Still the change below IMHO makes the code cleaner, so I'm not
opposing. Possibly could be targeting net-next instead.

Thanks,

Paolo

> Note the only exception is inet_autobind(), all of whose callers return
> -EAGAIN instead.
> 
> Fixes: cec37a6e41aa ("mptcp: Handle MP_CAPABLE options for outgoing connections")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  net/ipv4/af_inet.c              | 4 ++--
>  net/ipv4/inet_connection_sock.c | 7 ++++---
>  net/ipv4/ping.c                 | 2 +-
>  net/ipv4/udp.c                  | 2 +-
>  net/ipv6/af_inet6.c             | 4 ++--
>  5 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 4728087c42a5..4799eb55c830 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -522,9 +522,9 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
>  	/* Make sure we are allowed to bind here. */
>  	if (snum || !(inet->bind_address_no_port ||
>  		      (flags & BIND_FORCE_ADDRESS_NO_PORT))) {
> -		if (sk->sk_prot->get_port(sk, snum)) {
> +		err = sk->sk_prot->get_port(sk, snum);
> +		if (err) {
>  			inet->inet_saddr = inet->inet_rcv_saddr = 0;
> -			err = -EADDRINUSE;
>  			goto out_release_sock;
>  		}
>  		if (!(flags & BIND_FROM_BPF)) {
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 4e84ed21d16f..4a34bc7cb15e 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -471,11 +471,11 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
>  	bool reuse = sk->sk_reuse && sk->sk_state != TCP_LISTEN;
>  	bool found_port = false, check_bind_conflict = true;
>  	bool bhash_created = false, bhash2_created = false;
> +	int ret = -EADDRINUSE, port = snum, l3mdev;
>  	struct inet_bind_hashbucket *head, *head2;
>  	struct inet_bind2_bucket *tb2 = NULL;
>  	struct inet_bind_bucket *tb = NULL;
>  	bool head2_lock_acquired = false;
> -	int ret = 1, port = snum, l3mdev;
>  	struct net *net = sock_net(sk);
>  
>  	l3mdev = inet_sk_bound_l3mdev(sk);
> @@ -1186,7 +1186,7 @@ int inet_csk_listen_start(struct sock *sk)
>  {
>  	struct inet_connection_sock *icsk = inet_csk(sk);
>  	struct inet_sock *inet = inet_sk(sk);
> -	int err = -EADDRINUSE;
> +	int err;
>  
>  	reqsk_queue_alloc(&icsk->icsk_accept_queue);
>  
> @@ -1202,7 +1202,8 @@ int inet_csk_listen_start(struct sock *sk)
>  	 * after validation is complete.
>  	 */
>  	inet_sk_state_store(sk, TCP_LISTEN);
> -	if (!sk->sk_prot->get_port(sk, inet->inet_num)) {
> +	err = sk->sk_prot->get_port(sk, inet->inet_num);
> +	if (!err) {
>  		inet->inet_sport = htons(inet->inet_num);
>  
>  		sk_dst_reset(sk);
> diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> index bde333b24837..bb9854c2b7a1 100644
> --- a/net/ipv4/ping.c
> +++ b/net/ipv4/ping.c
> @@ -138,7 +138,7 @@ int ping_get_port(struct sock *sk, unsigned short ident)
>  
>  fail:
>  	spin_unlock(&ping_table.lock);
> -	return 1;
> +	return -EADDRINUSE;
>  }
>  EXPORT_SYMBOL_GPL(ping_get_port);
>  
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 6a320a614e54..b30137f48fff 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -234,7 +234,7 @@ int udp_lib_get_port(struct sock *sk, unsigned short snum,
>  {
>  	struct udp_hslot *hslot, *hslot2;
>  	struct udp_table *udptable = sk->sk_prot->h.udp_table;
> -	int    error = 1;
> +	int error = -EADDRINUSE;
>  	struct net *net = sock_net(sk);
>  
>  	if (!snum) {
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index 024191004982..7b0cd54da452 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -409,10 +409,10 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
>  	/* Make sure we are allowed to bind here. */
>  	if (snum || !(inet->bind_address_no_port ||
>  		      (flags & BIND_FORCE_ADDRESS_NO_PORT))) {
> -		if (sk->sk_prot->get_port(sk, snum)) {
> +		err = sk->sk_prot->get_port(sk, snum);
> +		if (err) {
>  			sk->sk_ipv6only = saved_ipv6only;
>  			inet_reset_saddr(sk);
> -			err = -EADDRINUSE;
>  			goto out;
>  		}
>  		if (!(flags & BIND_FROM_BPF)) {

Th

