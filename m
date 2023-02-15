Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5116069759B
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 05:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbjBOE44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 23:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBOE4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 23:56:55 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3119305D5;
        Tue, 14 Feb 2023 20:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1676437014; x=1707973014;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N67n0EQAQm+DUJNJ4Imhx9KFbs2DRD8zoaytDC7vlD4=;
  b=FXtdzCi+OIV89c8/XKVYpOIvYAet4jsVxky1FkwiiBzWi6yNgDwo/tCW
   yWH1KcEGqw407ya4tK/3U95chsh8Yt1Jdvn7WrBAbT3i9JVd6ocOAjmSS
   YdSmqpwjvKeRkMtjv3gWmota0E3H53PixIH2Vpo2Y/nn9g6nyTt3fz8/B
   w=;
X-IronPort-AV: E=Sophos;i="5.97,298,1669075200"; 
   d="scan'208";a="292950557"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 04:56:49 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com (Postfix) with ESMTPS id C7604810D0;
        Wed, 15 Feb 2023 04:56:46 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Wed, 15 Feb 2023 04:56:46 +0000
Received: from 88665a182662.ant.amazon.com.com (10.119.90.83) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 15 Feb 2023 04:56:41 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kerneljasonxing@gmail.com>
CC:     <bjorn@kernel.org>, <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <dsahern@kernel.org>, <edumazet@google.com>, <jaka@linux.ibm.com>,
        <jonathan.lemon@gmail.com>, <kernelxing@tencent.com>,
        <kgraul@linux.ibm.com>, <kuba@kernel.org>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-sctp@vger.kernel.org>, <lucien.xin@gmail.com>,
        <maciej.fijalkowski@intel.com>, <magnus.karlsson@intel.com>,
        <marcelo.leitner@gmail.com>, <matthieu.baerts@tessares.net>,
        <mptcp@lists.linux.dev>, <netdev@vger.kernel.org>,
        <nhorman@tuxdriver.com>, <pabeni@redhat.com>,
        <wenjia@linux.ibm.com>, <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH v2 net-next] net: no longer support SOCK_REFCNT_DEBUG feature
Date:   Tue, 14 Feb 2023 20:56:30 -0800
Message-ID: <20230215045630.85835-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230214041410.6295-1-kerneljasonxing@gmail.com>
References: <20230214041410.6295-1-kerneljasonxing@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.119.90.83]
X-ClientProxiedBy: EX19D046UWA003.ant.amazon.com (10.13.139.18) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 14 Feb 2023 12:14:10 +0800
> From: Jason Xing <kernelxing@tencent.com>
> 
> Commit e48c414ee61f ("[INET]: Generalise the TCP sock ID lookup routines")
> commented out the definition of SOCK_REFCNT_DEBUG in 2005 and later another
> commit 463c84b97f24 ("[NET]: Introduce inet_connection_sock") removed it.
> Since we could track all of them through bpf and kprobe related tools
> and the feature could print loads of information which might not be
> that helpful even under a little bit pressure, the whole feature which
> has been inactive for many years is no longer supported.
> 
> Link: https://lore.kernel.org/lkml/20230211065153.54116-1-kerneljasonxing@gmail.com/
> Suggested-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Signed-off-by: Jason Xing <kernelxing@tencent.com>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thanks!


> ---
> v2:
> 1) change the title and body message.
> 2) remove the whole feature instead suggested by Kuniyuki Iwashima.
> ---
>  include/net/sock.h              | 28 ----------------------------
>  net/core/sock.c                 | 13 -------------
>  net/ipv4/af_inet.c              |  3 ---
>  net/ipv4/inet_connection_sock.c |  2 --
>  net/ipv4/inet_timewait_sock.c   |  3 ---
>  net/ipv6/af_inet6.c             | 10 ----------
>  net/ipv6/ipv6_sockglue.c        | 12 ------------
>  net/mptcp/protocol.c            |  1 -
>  net/packet/af_packet.c          |  4 ----
>  net/sctp/ipv6.c                 |  2 --
>  net/sctp/protocol.c             |  2 --
>  net/smc/af_smc.c                |  3 ---
>  net/xdp/xsk.c                   |  4 ----
>  13 files changed, 87 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index dcd72e6285b2..e6369068a7bb 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1349,9 +1349,6 @@ struct proto {
>  	char			name[32];
>  
>  	struct list_head	node;
> -#ifdef SOCK_REFCNT_DEBUG
> -	atomic_t		socks;
> -#endif
>  	int			(*diag_destroy)(struct sock *sk, int err);
>  } __randomize_layout;
>  
> @@ -1359,31 +1356,6 @@ int proto_register(struct proto *prot, int alloc_slab);
>  void proto_unregister(struct proto *prot);
>  int sock_load_diag_module(int family, int protocol);
>  
> -#ifdef SOCK_REFCNT_DEBUG
> -static inline void sk_refcnt_debug_inc(struct sock *sk)
> -{
> -	atomic_inc(&sk->sk_prot->socks);
> -}
> -
> -static inline void sk_refcnt_debug_dec(struct sock *sk)
> -{
> -	atomic_dec(&sk->sk_prot->socks);
> -	printk(KERN_DEBUG "%s socket %p released, %d are still alive\n",
> -	       sk->sk_prot->name, sk, atomic_read(&sk->sk_prot->socks));
> -}
> -
> -static inline void sk_refcnt_debug_release(const struct sock *sk)
> -{
> -	if (refcount_read(&sk->sk_refcnt) != 1)
> -		printk(KERN_DEBUG "Destruction of the %s socket %p delayed, refcnt=%d\n",
> -		       sk->sk_prot->name, sk, refcount_read(&sk->sk_refcnt));
> -}
> -#else /* SOCK_REFCNT_DEBUG */
> -#define sk_refcnt_debug_inc(sk) do { } while (0)
> -#define sk_refcnt_debug_dec(sk) do { } while (0)
> -#define sk_refcnt_debug_release(sk) do { } while (0)
> -#endif /* SOCK_REFCNT_DEBUG */
> -
>  INDIRECT_CALLABLE_DECLARE(bool tcp_stream_memory_free(const struct sock *sk, int wake));
>  
>  static inline int sk_forward_alloc_get(const struct sock *sk)
> diff --git a/net/core/sock.c b/net/core/sock.c
> index f954d5893e79..be7b29d97637 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2338,17 +2338,6 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
>  	smp_wmb();
>  	refcount_set(&newsk->sk_refcnt, 2);
>  
> -	/* Increment the counter in the same struct proto as the master
> -	 * sock (sk_refcnt_debug_inc uses newsk->sk_prot->socks, that
> -	 * is the same as sk->sk_prot->socks, as this field was copied
> -	 * with memcpy).
> -	 *
> -	 * This _changes_ the previous behaviour, where
> -	 * tcp_create_openreq_child always was incrementing the
> -	 * equivalent to tcp_prot->socks (inet_sock_nr), so this have
> -	 * to be taken into account in all callers. -acme
> -	 */
> -	sk_refcnt_debug_inc(newsk);
>  	sk_set_socket(newsk, NULL);
>  	sk_tx_queue_clear(newsk);
>  	RCU_INIT_POINTER(newsk->sk_wq, NULL);
> @@ -3696,8 +3685,6 @@ void sk_common_release(struct sock *sk)
>  
>  	xfrm_sk_free_policy(sk);
>  
> -	sk_refcnt_debug_release(sk);
> -
>  	sock_put(sk);
>  }
>  EXPORT_SYMBOL(sk_common_release);
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 6c0ec2789943..f46a3924c440 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -156,7 +156,6 @@ void inet_sock_destruct(struct sock *sk)
>  	kfree(rcu_dereference_protected(inet->inet_opt, 1));
>  	dst_release(rcu_dereference_protected(sk->sk_dst_cache, 1));
>  	dst_release(rcu_dereference_protected(sk->sk_rx_dst, 1));
> -	sk_refcnt_debug_dec(sk);
>  }
>  EXPORT_SYMBOL(inet_sock_destruct);
>  
> @@ -356,8 +355,6 @@ static int inet_create(struct net *net, struct socket *sock, int protocol,
>  	inet->mc_list	= NULL;
>  	inet->rcv_tos	= 0;
>  
> -	sk_refcnt_debug_inc(sk);
> -
>  	if (inet->inet_num) {
>  		/* It assumes that any protocol which allows
>  		 * the user to assign a number at socket
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index d1f837579398..64be59d93b04 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -1178,8 +1178,6 @@ void inet_csk_destroy_sock(struct sock *sk)
>  
>  	xfrm_sk_free_policy(sk);
>  
> -	sk_refcnt_debug_release(sk);
> -
>  	this_cpu_dec(*sk->sk_prot->orphan_count);
>  
>  	sock_put(sk);
> diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> index beed32fff484..40052414c7c7 100644
> --- a/net/ipv4/inet_timewait_sock.c
> +++ b/net/ipv4/inet_timewait_sock.c
> @@ -77,9 +77,6 @@ void inet_twsk_free(struct inet_timewait_sock *tw)
>  {
>  	struct module *owner = tw->tw_prot->owner;
>  	twsk_destructor((struct sock *)tw);
> -#ifdef SOCK_REFCNT_DEBUG
> -	pr_debug("%s timewait_sock %p released\n", tw->tw_prot->name, tw);
> -#endif
>  	kmem_cache_free(tw->tw_prot->twsk_prot->twsk_slab, tw);
>  	module_put(owner);
>  }
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index fee9163382c2..c93f2e865fea 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -238,16 +238,6 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
>  		inet->pmtudisc = IP_PMTUDISC_DONT;
>  	else
>  		inet->pmtudisc = IP_PMTUDISC_WANT;
> -	/*
> -	 * Increment only the relevant sk_prot->socks debug field, this changes
> -	 * the previous behaviour of incrementing both the equivalent to
> -	 * answer->prot->socks (inet6_sock_nr) and inet_sock_nr.
> -	 *
> -	 * This allows better debug granularity as we'll know exactly how many
> -	 * UDPv6, TCPv6, etc socks were allocated, not the sum of all IPv6
> -	 * transport protocol socks. -acme
> -	 */
> -	sk_refcnt_debug_inc(sk);
>  
>  	if (inet->inet_num) {
>  		/* It assumes that any protocol which allows
> diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> index 9ce51680290b..2917dd8d198c 100644
> --- a/net/ipv6/ipv6_sockglue.c
> +++ b/net/ipv6/ipv6_sockglue.c
> @@ -464,13 +464,6 @@ int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>  			__ipv6_sock_mc_close(sk);
>  			__ipv6_sock_ac_close(sk);
>  
> -			/*
> -			 * Sock is moving from IPv6 to IPv4 (sk_prot), so
> -			 * remove it from the refcnt debug socks count in the
> -			 * original family...
> -			 */
> -			sk_refcnt_debug_dec(sk);
> -
>  			if (sk->sk_protocol == IPPROTO_TCP) {
>  				struct inet_connection_sock *icsk = inet_csk(sk);
>  
> @@ -507,11 +500,6 @@ int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>  
>  			inet6_cleanup_sock(sk);
>  
> -			/*
> -			 * ... and add it to the refcnt debug socks count
> -			 * in the new family. -acme
> -			 */
> -			sk_refcnt_debug_inc(sk);
>  			module_put(THIS_MODULE);
>  			retv = 0;
>  			break;
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index 8cd6cc67c2c5..e913752df112 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -2876,7 +2876,6 @@ static void __mptcp_destroy_sock(struct sock *sk)
>  	sk_stream_kill_queues(sk);
>  	xfrm_sk_free_policy(sk);
>  
> -	sk_refcnt_debug_release(sk);
>  	sock_put(sk);
>  }
>  
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index b5ab98ca2511..a4c8f86ac12a 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -1335,8 +1335,6 @@ static void packet_sock_destruct(struct sock *sk)
>  		pr_err("Attempt to release alive packet socket: %p\n", sk);
>  		return;
>  	}
> -
> -	sk_refcnt_debug_dec(sk);
>  }
>  
>  static bool fanout_flow_is_huge(struct packet_sock *po, struct sk_buff *skb)
> @@ -3172,7 +3170,6 @@ static int packet_release(struct socket *sock)
>  
>  	skb_queue_purge(&sk->sk_receive_queue);
>  	packet_free_pending(po);
> -	sk_refcnt_debug_release(sk);
>  
>  	sock_put(sk);
>  	return 0;
> @@ -3362,7 +3359,6 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
>  	packet_cached_dev_reset(po);
>  
>  	sk->sk_destruct = packet_sock_destruct;
> -	sk_refcnt_debug_inc(sk);
>  
>  	/*
>  	 *	Attach a protocol block
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index 097bd60ce964..62b436a2c8fe 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -807,8 +807,6 @@ static struct sock *sctp_v6_create_accept_sk(struct sock *sk,
>  
>  	newsk->sk_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
>  
> -	sk_refcnt_debug_inc(newsk);
> -
>  	if (newsk->sk_prot->init(newsk)) {
>  		sk_common_release(newsk);
>  		newsk = NULL;
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 909a89a1cff4..c365df24ad33 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -601,8 +601,6 @@ static struct sock *sctp_v4_create_accept_sk(struct sock *sk,
>  
>  	newinet->inet_daddr = asoc->peer.primary_addr.v4.sin_addr.s_addr;
>  
> -	sk_refcnt_debug_inc(newsk);
> -
>  	if (newsk->sk_prot->init(newsk)) {
>  		sk_common_release(newsk);
>  		newsk = NULL;
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index e12d4fa5aece..c594312e22cd 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -359,8 +359,6 @@ static void smc_destruct(struct sock *sk)
>  		return;
>  	if (!sock_flag(sk, SOCK_DEAD))
>  		return;
> -
> -	sk_refcnt_debug_dec(sk);
>  }
>  
>  static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
> @@ -389,7 +387,6 @@ static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
>  	spin_lock_init(&smc->accept_q_lock);
>  	spin_lock_init(&smc->conn.send_lock);
>  	sk->sk_prot->hash(sk);
> -	sk_refcnt_debug_inc(sk);
>  	mutex_init(&smc->clcsock_release_lock);
>  	smc_init_saved_callbacks(smc);
>  
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 9f0561b67c12..a245c1b4a21b 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -845,7 +845,6 @@ static int xsk_release(struct socket *sock)
>  	sock_orphan(sk);
>  	sock->sk = NULL;
>  
> -	sk_refcnt_debug_release(sk);
>  	sock_put(sk);
>  
>  	return 0;
> @@ -1396,8 +1395,6 @@ static void xsk_destruct(struct sock *sk)
>  
>  	if (!xp_put_pool(xs->pool))
>  		xdp_put_umem(xs->umem, !xs->pool);
> -
> -	sk_refcnt_debug_dec(sk);
>  }
>  
>  static int xsk_create(struct net *net, struct socket *sock, int protocol,
> @@ -1427,7 +1424,6 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
>  	sk->sk_family = PF_XDP;
>  
>  	sk->sk_destruct = xsk_destruct;
> -	sk_refcnt_debug_inc(sk);
>  
>  	sock_set_flag(sk, SOCK_RCU_FREE);
>  
> -- 
> 2.37.3
