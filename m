Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00D953F83C
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 10:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbiFGIdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 04:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiFGIdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 04:33:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 724201D329
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 01:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654590791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EzwQtb8w1C/N7Jw5D50jvsHI9SGPY1aRhAZRFbxt0I4=;
        b=aEU2mTJUK0seSPw6vp0VLycGV1b3e7l30LcaR2FsW+PBocIK6XmHeAegUDApVGzLcdnFBe
        qSl/774tQRpNMYhyBNyfzqZ7Qa0J4uUGEwEz0Wk57NzO06sK9wF3qxj40pjFwf4/RsxkFS
        BPlRhbDaUvnpgMbJ9ND+1kr8MokEPdM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-wdoTdls9Ol-88pV_04FY6Q-1; Tue, 07 Jun 2022 04:33:10 -0400
X-MC-Unique: wdoTdls9Ol-88pV_04FY6Q-1
Received: by mail-wm1-f70.google.com with SMTP id k5-20020a05600c0b4500b003941ca130f9so5521850wmr.0
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 01:33:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=EzwQtb8w1C/N7Jw5D50jvsHI9SGPY1aRhAZRFbxt0I4=;
        b=c+/IBGYLtsSbFrZvVg5dSXFtYALsUQxOtbGMjKkcuP4tjGVTVCxbJSk4uBH+LrvLes
         Ixlu7la9tEgCKuMXaZhF+CNpLfVOOC7OJAPMmmaPukH+QVQhGnceQ+8tlsvj9qfUoObA
         tBf55Q6XDK2zd8fXMLy6o5wzfQTKrQTBqvN2yQXUD98rLPdO/XWIFF4d1BBJzP0WIUha
         8fhkr+4CO6hrJYtDla3v649zJrLvZtekjD0/Vi01dofCSkTL7ypp3IAwhvkoRHG2KY2H
         BZrVCPECawOiMB1dFOAXzumh+geWhcQinmsV5w9R2fb3cLiYTRmHH2aQUR+WYdprmfP/
         JwsQ==
X-Gm-Message-State: AOAM532knu10o78XiDeeuL062xzMSLw+NOlIfLQ02F9QXw11gFjLLPyk
        5nh28D1sdq+9vrKMYi8RS9hLdbmW7RhOlYGnlu97BTsUiMLwL5XEONfeNiIFKCN4HnUNM9tDeFo
        Aezaiu/7T/LQJRq3Z
X-Received: by 2002:adf:fe8c:0:b0:215:a70d:53ff with SMTP id l12-20020adffe8c000000b00215a70d53ffmr18153298wrr.138.1654590788779;
        Tue, 07 Jun 2022 01:33:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzq1v3iVE2HbO4eEEUZAMjS3J4D2ZtRCKGFgftOCdAqaVd6oq9ThoAU4XMGKFn8Wp66PWk3Nw==
X-Received: by 2002:adf:fe8c:0:b0:215:a70d:53ff with SMTP id l12-20020adffe8c000000b00215a70d53ffmr18153271wrr.138.1654590788443;
        Tue, 07 Jun 2022 01:33:08 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id c7-20020a05600c0a4700b003973c54bd69sm27265130wmq.1.2022.06.07.01.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 01:33:07 -0700 (PDT)
Message-ID: <e73d11bde2d8ead36296d814ba555e60880ce9be.camel@redhat.com>
Subject: Re: [PATCH net-next v2 1/2] net: Update bhash2 when socket's rcv
 saddr changes
From:   Paolo Abeni <pabeni@redhat.com>
To:     Joanne Koong <joannelkoong@gmail.com>, netdev@vger.kernel.org
Cc:     edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net,
        syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Date:   Tue, 07 Jun 2022 10:33:06 +0200
In-Reply-To: <20220602165101.3188482-2-joannelkoong@gmail.com>
References: <20220602165101.3188482-1-joannelkoong@gmail.com>
         <20220602165101.3188482-2-joannelkoong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 2022-06-02 at 09:51 -0700, Joanne Koong wrote:
> Commit d5a42de8bdbe ("net: Add a second bind table hashed by port and
> address") added a second bind table, bhash2, that hashes by a socket's port
> and rcv address.
> 
> However, there are two cases where the socket's rcv saddr can change
> after it has been binded:
> 
> 1) The case where there is a bind() call on "::" (IPADDR_ANY) and then
> a connect() call. The kernel will assign the socket an address when it
> handles the connect()
> 
> 2) In inet_sk_reselect_saddr(), which is called when rerouting fails
> when rebuilding the sk header (invoked by inet_sk_rebuild_header)
> 
> In these two cases, we need to update the bhash2 table by removing the
> entry for the old address, and adding a new entry reflecting the updated
> address.
> 
> Reported-by: syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com
> Fixes: d5a42de8bdbe ("net: Add a second bind table hashed by port and address")
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/inet_hashtables.h |  6 ++-
>  include/net/ipv6.h            |  2 +-
>  net/dccp/ipv4.c               | 10 +++--
>  net/dccp/ipv6.c               |  4 +-
>  net/ipv4/af_inet.c            |  7 +++-
>  net/ipv4/inet_hashtables.c    | 70 ++++++++++++++++++++++++++++++++---
>  net/ipv4/tcp_ipv4.c           |  8 +++-
>  net/ipv6/inet6_hashtables.c   |  4 +-
>  net/ipv6/tcp_ipv6.c           |  4 +-
>  9 files changed, 97 insertions(+), 18 deletions(-)
> 
> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> index a0887b70967b..2c331ce6ca73 100644
> --- a/include/net/inet_hashtables.h
> +++ b/include/net/inet_hashtables.h
> @@ -448,11 +448,13 @@ static inline void sk_rcv_saddr_set(struct sock *sk, __be32 addr)
>  }
>  
>  int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> -			struct sock *sk, u64 port_offset,
> +			struct sock *sk, u64 port_offset, bool prev_inaddr_any,
>  			int (*check_established)(struct inet_timewait_death_row *,
>  						 struct sock *, __u16,
>  						 struct inet_timewait_sock **));
>  
>  int inet_hash_connect(struct inet_timewait_death_row *death_row,
> -		      struct sock *sk);
> +		      struct sock *sk, bool prev_inaddr_any);
> +
> +int inet_bhash2_update_saddr(struct sock *sk);
>  #endif /* _INET_HASHTABLES_H */
> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> index 5b38bf1a586b..6a50aca56d50 100644
> --- a/include/net/ipv6.h
> +++ b/include/net/ipv6.h
> @@ -1187,7 +1187,7 @@ int inet6_compat_ioctl(struct socket *sock, unsigned int cmd,
>  		unsigned long arg);
>  
>  int inet6_hash_connect(struct inet_timewait_death_row *death_row,
> -			      struct sock *sk);
> +		       struct sock *sk, bool prev_inaddr_any);
>  int inet6_sendmsg(struct socket *sock, struct msghdr *msg, size_t size);
>  int inet6_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>  		  int flags);
> diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> index da6e3b20cd75..37a8bc3ee49e 100644
> --- a/net/dccp/ipv4.c
> +++ b/net/dccp/ipv4.c
> @@ -47,12 +47,13 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  	const struct sockaddr_in *usin = (struct sockaddr_in *)uaddr;
>  	struct inet_sock *inet = inet_sk(sk);
>  	struct dccp_sock *dp = dccp_sk(sk);
> +	struct ip_options_rcu *inet_opt;
>  	__be16 orig_sport, orig_dport;
> +	bool prev_inaddr_any = false;
>  	__be32 daddr, nexthop;
>  	struct flowi4 *fl4;
>  	struct rtable *rt;
>  	int err;
> -	struct ip_options_rcu *inet_opt;
>  
>  	dp->dccps_role = DCCP_ROLE_CLIENT;
>  
> @@ -89,8 +90,11 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  	if (inet_opt == NULL || !inet_opt->opt.srr)
>  		daddr = fl4->daddr;
>  
> -	if (inet->inet_saddr == 0)
> +	if (inet->inet_saddr == 0) {
>  		inet->inet_saddr = fl4->saddr;
> +		prev_inaddr_any = true;
> +	}
> +
>  	sk_rcv_saddr_set(sk, inet->inet_saddr);
>  	inet->inet_dport = usin->sin_port;
>  	sk_daddr_set(sk, daddr);
> @@ -105,7 +109,7 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  	 * complete initialization after this.
>  	 */
>  	dccp_set_state(sk, DCCP_REQUESTING);
> -	err = inet_hash_connect(&dccp_death_row, sk);
> +	err = inet_hash_connect(&dccp_death_row, sk, prev_inaddr_any);
>  	if (err != 0)
>  		goto failure;
>  
> diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> index fd44638ec16b..03013522acab 100644
> --- a/net/dccp/ipv6.c
> +++ b/net/dccp/ipv6.c
> @@ -824,6 +824,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  	struct ipv6_pinfo *np = inet6_sk(sk);
>  	struct dccp_sock *dp = dccp_sk(sk);
>  	struct in6_addr *saddr = NULL, *final_p, final;
> +	bool prev_inaddr_any = false;
>  	struct ipv6_txoptions *opt;
>  	struct flowi6 fl6;
>  	struct dst_entry *dst;
> @@ -936,6 +937,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  	if (saddr == NULL) {
>  		saddr = &fl6.saddr;
>  		sk->sk_v6_rcv_saddr = *saddr;
> +		prev_inaddr_any = true;
>  	}
>  
>  	/* set the source address */
> @@ -951,7 +953,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  	inet->inet_dport = usin->sin6_port;
>  
>  	dccp_set_state(sk, DCCP_REQUESTING);
> -	err = inet6_hash_connect(&dccp_death_row, sk);
> +	err = inet6_hash_connect(&dccp_death_row, sk, prev_inaddr_any);
>  	if (err)
>  		goto late_failure;
>  
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 93da9f783bec..ad627a99ff9d 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1221,10 +1221,11 @@ static int inet_sk_reselect_saddr(struct sock *sk)
>  	struct inet_sock *inet = inet_sk(sk);
>  	__be32 old_saddr = inet->inet_saddr;
>  	__be32 daddr = inet->inet_daddr;
> +	struct ip_options_rcu *inet_opt;
>  	struct flowi4 *fl4;
>  	struct rtable *rt;
>  	__be32 new_saddr;
> -	struct ip_options_rcu *inet_opt;
> +	int err;
>  
>  	inet_opt = rcu_dereference_protected(inet->inet_opt,
>  					     lockdep_sock_is_held(sk));
> @@ -1253,6 +1254,10 @@ static int inet_sk_reselect_saddr(struct sock *sk)
>  
>  	inet->inet_saddr = inet->inet_rcv_saddr = new_saddr;
>  
> +	err = inet_bhash2_update_saddr(sk);
> +	if (err)
> +		return err;
> +
>  	/*
>  	 * XXX The only one ugly spot where we need to
>  	 * XXX really change the sockets identity after
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index e8de5e699b3f..592b70663a3b 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -826,6 +826,55 @@ inet_bind2_bucket_find(struct inet_hashinfo *hinfo, struct net *net,
>  	return bhash2;
>  }
>  
> +/* the lock for the socket's corresponding bhash entry must be held */
> +static int __inet_bhash2_update_saddr(struct sock *sk,
> +				      struct inet_hashinfo *hinfo,
> +				      struct net *net, int port, int l3mdev)
> +{
> +	struct inet_bind2_hashbucket *head2;
> +	struct inet_bind2_bucket *tb2;
> +
> +	tb2 = inet_bind2_bucket_find(hinfo, net, port, l3mdev, sk,
> +				     &head2);
> +	if (!tb2) {
> +		tb2 = inet_bind2_bucket_create(hinfo->bind2_bucket_cachep,
> +					       net, head2, port, l3mdev, sk);
> +		if (!tb2)
> +			return -ENOMEM;
> +	}
> +
> +	/* Remove the socket's old entry from bhash2 */
> +	__sk_del_bind2_node(sk);
> +
> +	sk_add_bind2_node(sk, &tb2->owners);
> +	inet_csk(sk)->icsk_bind2_hash = tb2;
> +
> +	return 0;
> +}
> +
> +/* This should be called if/when a socket's rcv saddr changes after it has
> + * been binded.
> + */
> +int inet_bhash2_update_saddr(struct sock *sk)
> +{
> +	struct inet_hashinfo *hinfo = sk->sk_prot->h.hashinfo;
> +	int l3mdev = inet_sk_bound_l3mdev(sk);
> +	struct inet_bind_hashbucket *head;
> +	int port = inet_sk(sk)->inet_num;
> +	struct net *net = sock_net(sk);
> +	int err;
> +
> +	head = &hinfo->bhash[inet_bhashfn(net, port, hinfo->bhash_size)];
> +
> +	spin_lock_bh(&head->lock);
> +
> +	err = __inet_bhash2_update_saddr(sk, hinfo, net, port, l3mdev);
> +
> +	spin_unlock_bh(&head->lock);
> +
> +	return err;
> +}
> +
>  /* RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm
>   * Note that we use 32bit integers (vs RFC 'short integers')
>   * because 2^16 is not a multiple of num_ephemeral and this
> @@ -840,7 +889,7 @@ inet_bind2_bucket_find(struct inet_hashinfo *hinfo, struct net *net,
>  static u32 *table_perturb;
>  
>  int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> -		struct sock *sk, u64 port_offset,
> +		struct sock *sk, u64 port_offset, bool prev_inaddr_any,
>  		int (*check_established)(struct inet_timewait_death_row *,
>  			struct sock *, __u16, struct inet_timewait_sock **))
>  {
> @@ -858,11 +907,24 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>  	int l3mdev;
>  	u32 index;
>  
> +	l3mdev = inet_sk_bound_l3mdev(sk);
> +
>  	if (port) {
>  		head = &hinfo->bhash[inet_bhashfn(net, port,
>  						  hinfo->bhash_size)];
>  		tb = inet_csk(sk)->icsk_bind_hash;
> +
>  		spin_lock_bh(&head->lock);
> +
> +		if (prev_inaddr_any) {
> +			ret = __inet_bhash2_update_saddr(sk, hinfo, net, port,
> +							 l3mdev);
> +			if (ret) {
> +				spin_unlock_bh(&head->lock);
> +				return ret;
> +			}
> +		}
> +
>  		if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
>  			inet_ehash_nolisten(sk, NULL, NULL);
>  			spin_unlock_bh(&head->lock);
> @@ -875,8 +937,6 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>  		return ret;
>  	}
>  
> -	l3mdev = inet_sk_bound_l3mdev(sk);
> -
>  	inet_get_local_port_range(net, &low, &high);
>  	high++; /* [32768, 60999] -> [32768, 61000[ */
>  	remaining = high - low;
> @@ -987,13 +1047,13 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>   * Bind a port for a connect operation and hash it.
>   */
>  int inet_hash_connect(struct inet_timewait_death_row *death_row,
> -		      struct sock *sk)
> +		      struct sock *sk, bool prev_inaddr_any)
>  {
>  	u64 port_offset = 0;
>  
>  	if (!inet_sk(sk)->inet_num)
>  		port_offset = inet_sk_port_offset(sk);
> -	return __inet_hash_connect(death_row, sk, port_offset,
> +	return __inet_hash_connect(death_row, sk, port_offset, prev_inaddr_any,
>  				   __inet_check_established);
>  }
>  EXPORT_SYMBOL_GPL(inet_hash_connect);
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index dac2650f3863..adf8d750933d 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -203,6 +203,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  	struct inet_sock *inet = inet_sk(sk);
>  	struct tcp_sock *tp = tcp_sk(sk);
>  	__be16 orig_sport, orig_dport;
> +	bool prev_inaddr_any = false;
>  	__be32 daddr, nexthop;
>  	struct flowi4 *fl4;
>  	struct rtable *rt;
> @@ -246,8 +247,11 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  	if (!inet_opt || !inet_opt->opt.srr)
>  		daddr = fl4->daddr;
>  
> -	if (!inet->inet_saddr)
> +	if (!inet->inet_saddr) {
>  		inet->inet_saddr = fl4->saddr;
> +		prev_inaddr_any = true;
> +	}
> +
>  	sk_rcv_saddr_set(sk, inet->inet_saddr);
>  
>  	if (tp->rx_opt.ts_recent_stamp && inet->inet_daddr != daddr) {
> @@ -273,7 +277,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  	 * complete initialization after this.
>  	 */
>  	tcp_set_state(sk, TCP_SYN_SENT);
> -	err = inet_hash_connect(tcp_death_row, sk);
> +	err = inet_hash_connect(tcp_death_row, sk, prev_inaddr_any);
>  	if (err)
>  		goto failure;
>  
> diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
> index 7d53d62783b1..c87c5933f3be 100644
> --- a/net/ipv6/inet6_hashtables.c
> +++ b/net/ipv6/inet6_hashtables.c
> @@ -317,13 +317,13 @@ static u64 inet6_sk_port_offset(const struct sock *sk)
>  }
>  
>  int inet6_hash_connect(struct inet_timewait_death_row *death_row,
> -		       struct sock *sk)
> +		       struct sock *sk, bool prev_inaddr_any)
>  {
>  	u64 port_offset = 0;
>  
>  	if (!inet_sk(sk)->inet_num)
>  		port_offset = inet6_sk_port_offset(sk);
> -	return __inet_hash_connect(death_row, sk, port_offset,
> +	return __inet_hash_connect(death_row, sk, port_offset, prev_inaddr_any,
>  				   __inet6_check_established);
>  }
>  EXPORT_SYMBOL_GPL(inet6_hash_connect);
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index f37dd4aa91c6..81e3312c2a97 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -152,6 +152,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  	struct ipv6_pinfo *np = tcp_inet6_sk(sk);
>  	struct tcp_sock *tp = tcp_sk(sk);
>  	struct in6_addr *saddr = NULL, *final_p, final;
> +	bool prev_inaddr_any = false;
>  	struct ipv6_txoptions *opt;
>  	struct flowi6 fl6;
>  	struct dst_entry *dst;
> @@ -289,6 +290,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  	if (!saddr) {
>  		saddr = &fl6.saddr;
>  		sk->sk_v6_rcv_saddr = *saddr;
> +		prev_inaddr_any = true;
>  	}
>  
>  	/* set the source address */
> @@ -309,7 +311,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  
>  	tcp_set_state(sk, TCP_SYN_SENT);
>  	tcp_death_row = sock_net(sk)->ipv4.tcp_death_row;
> -	err = inet6_hash_connect(tcp_death_row, sk);
> +	err = inet6_hash_connect(tcp_death_row, sk, prev_inaddr_any);
>  	if (err)
>  		goto late_failure;
>  

I'm sorry for the late notice, but it looks like that the mptcp
syzkaller instance is still hitting the Warning in icsk_get_port on top
of the v1 of this series:

https://github.com/multipath-tcp/mptcp_net-next/issues/279

and the change in v2 should not address that. @Mat could you please
confirm the above?

Dumb question: I don't understand how the locking in bhash2 works.
Could you explain that? 

What happens when 2 different processes bind different sockets on
different ports (with different bhash buckets) using different
addresses so that they hit the same bhash2 bucket? AFAICS each process
will use a different lock and access/modification to bhash2 could
happen simultaneusly?

Thanks!

Paolo


