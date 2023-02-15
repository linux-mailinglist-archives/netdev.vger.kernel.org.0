Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A20697677
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 07:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbjBOGdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 01:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbjBOGdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 01:33:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8905F23863;
        Tue, 14 Feb 2023 22:33:12 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31F5mN0p011073;
        Wed, 15 Feb 2023 06:32:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Rl7rXF6LWBJNkLng35gISIMIcRatki1ODME5MzWA0Fw=;
 b=BXKLAqQEbGTGLW9cJPzVA3VVRlwWhIc/TWb1Mmgms9VmLSe+Dnm+VFj2FidmtZbOLd4X
 YLNz+YCHsVBvCtbRbOakC2UE90mOL1wANayCt7xChK+Dho/mkMRjvYq67daFErGkmHwc
 h6TTuv0cHb9wdYfISBafCL02FVXQ3YTfo2mfx9Tgv9Funym/YIfRYOR/Zx5mhPOd6hmD
 gGDWGVwmspVo3/Ye5JjbbZmHlwKoqIIgjhyQEayb7+x48T5HFNzJLjTh10Y+T135fAzK
 TnXHm8PHvQTLW7Fa0H6Bf/xs4xnVMXLgIbRDPgYVEVUzXe25Ak89dUGWBOeA63kziIyR 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nrsjrs4gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 06:32:10 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31F6Rnew031362;
        Wed, 15 Feb 2023 06:32:10 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nrsjrs4fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 06:32:09 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31F5cFtM021833;
        Wed, 15 Feb 2023 06:32:08 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([9.208.129.117])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3np2n7bh7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 06:32:08 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31F6W68D61080040
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 06:32:06 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CD7558055;
        Wed, 15 Feb 2023 06:32:06 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B85A958060;
        Wed, 15 Feb 2023 06:32:01 +0000 (GMT)
Received: from [9.211.88.109] (unknown [9.211.88.109])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Feb 2023 06:32:01 +0000 (GMT)
Message-ID: <03e3ee3f-eb1c-e915-b256-e054b4594d68@linux.ibm.com>
Date:   Wed, 15 Feb 2023 07:32:00 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v2 net-next] net: no longer support SOCK_REFCNT_DEBUG
 feature
To:     Jason Xing <kerneljasonxing@gmail.com>, kuniyu@amazon.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org,
        matthieu.baerts@tessares.net, willemdebruijn.kernel@gmail.com,
        nhorman@tuxdriver.com, marcelo.leitner@gmail.com,
        lucien.xin@gmail.com, kgraul@linux.ibm.com, jaka@linux.ibm.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sctp@vger.kernel.org, mptcp@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
References: <20230214041410.6295-1-kerneljasonxing@gmail.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <20230214041410.6295-1-kerneljasonxing@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Pcp-bJnTVwt1iEf6N0RUIdd2DO1waOzf
X-Proofpoint-ORIG-GUID: 4v5xmJbdVfXHC6Qc8ehG2eC1MpDKIpqG
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_02,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 clxscore=1011 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150058
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14.02.23 05:14, Jason Xing wrote:
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
> ---
> v2:
> 1) change the title and body message.
> 2) remove the whole feature instead suggested by Kuniyuki Iwashima.
> ---
>   include/net/sock.h              | 28 ----------------------------
>   net/core/sock.c                 | 13 -------------
>   net/ipv4/af_inet.c              |  3 ---
>   net/ipv4/inet_connection_sock.c |  2 --
>   net/ipv4/inet_timewait_sock.c   |  3 ---
>   net/ipv6/af_inet6.c             | 10 ----------
>   net/ipv6/ipv6_sockglue.c        | 12 ------------
>   net/mptcp/protocol.c            |  1 -
>   net/packet/af_packet.c          |  4 ----
>   net/sctp/ipv6.c                 |  2 --
>   net/sctp/protocol.c             |  2 --
>   net/smc/af_smc.c                |  3 ---
>   net/xdp/xsk.c                   |  4 ----
>   13 files changed, 87 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index dcd72e6285b2..e6369068a7bb 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1349,9 +1349,6 @@ struct proto {
>   	char			name[32];
>   
>   	struct list_head	node;
> -#ifdef SOCK_REFCNT_DEBUG
> -	atomic_t		socks;
> -#endif
>   	int			(*diag_destroy)(struct sock *sk, int err);
>   } __randomize_layout;
>   
> @@ -1359,31 +1356,6 @@ int proto_register(struct proto *prot, int alloc_slab);
>   void proto_unregister(struct proto *prot);
>   int sock_load_diag_module(int family, int protocol);
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
>   INDIRECT_CALLABLE_DECLARE(bool tcp_stream_memory_free(const struct sock *sk, int wake));
>   
>   static inline int sk_forward_alloc_get(const struct sock *sk)
> diff --git a/net/core/sock.c b/net/core/sock.c
> index f954d5893e79..be7b29d97637 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2338,17 +2338,6 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
>   	smp_wmb();
>   	refcount_set(&newsk->sk_refcnt, 2);
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
>   	sk_set_socket(newsk, NULL);
>   	sk_tx_queue_clear(newsk);
>   	RCU_INIT_POINTER(newsk->sk_wq, NULL);
> @@ -3696,8 +3685,6 @@ void sk_common_release(struct sock *sk)
>   
>   	xfrm_sk_free_policy(sk);
>   
> -	sk_refcnt_debug_release(sk);
> -
>   	sock_put(sk);
>   }
>   EXPORT_SYMBOL(sk_common_release);
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 6c0ec2789943..f46a3924c440 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -156,7 +156,6 @@ void inet_sock_destruct(struct sock *sk)
>   	kfree(rcu_dereference_protected(inet->inet_opt, 1));
>   	dst_release(rcu_dereference_protected(sk->sk_dst_cache, 1));
>   	dst_release(rcu_dereference_protected(sk->sk_rx_dst, 1));
> -	sk_refcnt_debug_dec(sk);
>   }
>   EXPORT_SYMBOL(inet_sock_destruct);
>   
> @@ -356,8 +355,6 @@ static int inet_create(struct net *net, struct socket *sock, int protocol,
>   	inet->mc_list	= NULL;
>   	inet->rcv_tos	= 0;
>   
> -	sk_refcnt_debug_inc(sk);
> -
>   	if (inet->inet_num) {
>   		/* It assumes that any protocol which allows
>   		 * the user to assign a number at socket
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index d1f837579398..64be59d93b04 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -1178,8 +1178,6 @@ void inet_csk_destroy_sock(struct sock *sk)
>   
>   	xfrm_sk_free_policy(sk);
>   
> -	sk_refcnt_debug_release(sk);
> -
>   	this_cpu_dec(*sk->sk_prot->orphan_count);
>   
>   	sock_put(sk);
> diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> index beed32fff484..40052414c7c7 100644
> --- a/net/ipv4/inet_timewait_sock.c
> +++ b/net/ipv4/inet_timewait_sock.c
> @@ -77,9 +77,6 @@ void inet_twsk_free(struct inet_timewait_sock *tw)
>   {
>   	struct module *owner = tw->tw_prot->owner;
>   	twsk_destructor((struct sock *)tw);
> -#ifdef SOCK_REFCNT_DEBUG
> -	pr_debug("%s timewait_sock %p released\n", tw->tw_prot->name, tw);
> -#endif
>   	kmem_cache_free(tw->tw_prot->twsk_prot->twsk_slab, tw);
>   	module_put(owner);
>   }
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index fee9163382c2..c93f2e865fea 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -238,16 +238,6 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
>   		inet->pmtudisc = IP_PMTUDISC_DONT;
>   	else
>   		inet->pmtudisc = IP_PMTUDISC_WANT;
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
>   	if (inet->inet_num) {
>   		/* It assumes that any protocol which allows
> diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> index 9ce51680290b..2917dd8d198c 100644
> --- a/net/ipv6/ipv6_sockglue.c
> +++ b/net/ipv6/ipv6_sockglue.c
> @@ -464,13 +464,6 @@ int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>   			__ipv6_sock_mc_close(sk);
>   			__ipv6_sock_ac_close(sk);
>   
> -			/*
> -			 * Sock is moving from IPv6 to IPv4 (sk_prot), so
> -			 * remove it from the refcnt debug socks count in the
> -			 * original family...
> -			 */
> -			sk_refcnt_debug_dec(sk);
> -
>   			if (sk->sk_protocol == IPPROTO_TCP) {
>   				struct inet_connection_sock *icsk = inet_csk(sk);
>   
> @@ -507,11 +500,6 @@ int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>   
>   			inet6_cleanup_sock(sk);
>   
> -			/*
> -			 * ... and add it to the refcnt debug socks count
> -			 * in the new family. -acme
> -			 */
> -			sk_refcnt_debug_inc(sk);
>   			module_put(THIS_MODULE);
>   			retv = 0;
>   			break;
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index 8cd6cc67c2c5..e913752df112 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -2876,7 +2876,6 @@ static void __mptcp_destroy_sock(struct sock *sk)
>   	sk_stream_kill_queues(sk);
>   	xfrm_sk_free_policy(sk);
>   
> -	sk_refcnt_debug_release(sk);
>   	sock_put(sk);
>   }
>   
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index b5ab98ca2511..a4c8f86ac12a 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -1335,8 +1335,6 @@ static void packet_sock_destruct(struct sock *sk)
>   		pr_err("Attempt to release alive packet socket: %p\n", sk);
>   		return;
>   	}
> -
> -	sk_refcnt_debug_dec(sk);
>   }
>   
>   static bool fanout_flow_is_huge(struct packet_sock *po, struct sk_buff *skb)
> @@ -3172,7 +3170,6 @@ static int packet_release(struct socket *sock)
>   
>   	skb_queue_purge(&sk->sk_receive_queue);
>   	packet_free_pending(po);
> -	sk_refcnt_debug_release(sk);
>   
>   	sock_put(sk);
>   	return 0;
> @@ -3362,7 +3359,6 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
>   	packet_cached_dev_reset(po);
>   
>   	sk->sk_destruct = packet_sock_destruct;
> -	sk_refcnt_debug_inc(sk);
>   
>   	/*
>   	 *	Attach a protocol block
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index 097bd60ce964..62b436a2c8fe 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -807,8 +807,6 @@ static struct sock *sctp_v6_create_accept_sk(struct sock *sk,
>   
>   	newsk->sk_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
>   
> -	sk_refcnt_debug_inc(newsk);
> -
>   	if (newsk->sk_prot->init(newsk)) {
>   		sk_common_release(newsk);
>   		newsk = NULL;
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 909a89a1cff4..c365df24ad33 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -601,8 +601,6 @@ static struct sock *sctp_v4_create_accept_sk(struct sock *sk,
>   
>   	newinet->inet_daddr = asoc->peer.primary_addr.v4.sin_addr.s_addr;
>   
> -	sk_refcnt_debug_inc(newsk);
> -
>   	if (newsk->sk_prot->init(newsk)) {
>   		sk_common_release(newsk);
>   		newsk = NULL;
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index e12d4fa5aece..c594312e22cd 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -359,8 +359,6 @@ static void smc_destruct(struct sock *sk)
>   		return;
>   	if (!sock_flag(sk, SOCK_DEAD))
>   		return;
> -
> -	sk_refcnt_debug_dec(sk);
>   }
>   
>   static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
> @@ -389,7 +387,6 @@ static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
>   	spin_lock_init(&smc->accept_q_lock);
>   	spin_lock_init(&smc->conn.send_lock);
>   	sk->sk_prot->hash(sk);
> -	sk_refcnt_debug_inc(sk);
>   	mutex_init(&smc->clcsock_release_lock);
>   	smc_init_saved_callbacks(smc);
>   

Acked-by: Wenjia Zhang <wenjia@linux.ibm.com>

> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 9f0561b67c12..a245c1b4a21b 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -845,7 +845,6 @@ static int xsk_release(struct socket *sock)
>   	sock_orphan(sk);
>   	sock->sk = NULL;
>   
> -	sk_refcnt_debug_release(sk);
>   	sock_put(sk);
>   
>   	return 0;
> @@ -1396,8 +1395,6 @@ static void xsk_destruct(struct sock *sk)
>   
>   	if (!xp_put_pool(xs->pool))
>   		xdp_put_umem(xs->umem, !xs->pool);
> -
> -	sk_refcnt_debug_dec(sk);
>   }
>   
>   static int xsk_create(struct net *net, struct socket *sock, int protocol,
> @@ -1427,7 +1424,6 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
>   	sk->sk_family = PF_XDP;
>   
>   	sk->sk_destruct = xsk_destruct;
> -	sk_refcnt_debug_inc(sk);
>   
>   	sock_set_flag(sk, SOCK_RCU_FREE);
>   
