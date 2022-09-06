Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806FB5AF6BF
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiIFV0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiIFV0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:26:34 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81507AC267
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 14:26:32 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id bh13so11767532pgb.4
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 14:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=fXR7wd9XOhQXziloS4Z0ntAtXlpwshSvzjJ2McH0gO8=;
        b=QAwkIm4waZcrLFXf41r2nagEZKgPiU9i+vujQMXo943hpdqLo7kXbNa5CL7nVt0s2j
         eSuNe8Qq9M9yszbQ6Jvy8TfpT3aDUkffnaLWN98jvglCHsJWx6JkZPyud+Am94bIMwiN
         uf9+8/IOcRZpfH3jhC/z2DUmh3LHwKobrPAsjTu2AR9/HTruD8hWE4fBbLLajgt33aTk
         ueAKs8wTDuVjupSYrMIHpuPfWwMqLsJ77haHVkL6IeTM2F+f+IbmUjLI/MHs5IP9GHUt
         Y+fO6/fVeMbhrbkLjAF3nZSTXR9gbUDuyl5VB+Pq5WsnGo8Sr0p9gDuudQYfT/sTleEi
         VGkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=fXR7wd9XOhQXziloS4Z0ntAtXlpwshSvzjJ2McH0gO8=;
        b=yRZCcAZd36Lyko8ruOYzcw41y3kZhsYX9IB6/C3+Bwcw+N1ebKlRdpQag3aeQPj4UX
         sPTh4GZde0Kn1tStbVMtqOFDweBRLDquH4F+Eu6fW51j8ZYLumRyzBMgMLOkaa0NGOtT
         EKCIxNc2jioZ6f/b5pge0w3nYIQvV7oYZxEu+5ZbwnwUrr0tIuc5ePc49HwIaWAFAdgZ
         yjAmXP70u56JAxZIXR1H4bxKlSSxcC5mi+ulLGyouFgxbJjrvNuJqT8tq3xHH0INmd2p
         VnVv8CuRr9+CA3z0X6NHFp3L2K5r/CoIiz5+E2c7f2aenZTI/QgdmktyH6IjpjYxccYs
         Rugw==
X-Gm-Message-State: ACgBeo0p0AdIFMjtAWvb7JerGuw5/vOL1aPnV5nBJi6rmgDeP2f11ztV
        3D00eeo5DfLOuFpOmMZj1iU=
X-Google-Smtp-Source: AA6agR5qEwmX7uq+UfuAVigbKyj2PnCMX81YbhmPjAMzdgWe0uZvGwbu7NqUQPpRq+ecCMrBTl13UQ==
X-Received: by 2002:a05:6a00:13a7:b0:538:39fc:ddc0 with SMTP id t39-20020a056a0013a700b0053839fcddc0mr380883pfg.8.1662499591893;
        Tue, 06 Sep 2022 14:26:31 -0700 (PDT)
Received: from ?IPV6:2620:15c:2c1:200:9caf:2138:b117:a81e? ([2620:15c:2c1:200:9caf:2138:b117:a81e])
        by smtp.gmail.com with ESMTPSA id n16-20020a63a510000000b0042fe1914e26sm2336437pgf.37.2022.09.06.14.26.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 14:26:31 -0700 (PDT)
Message-ID: <5b5f038e-6d5b-48c7-5ca7-41188dfadfae@gmail.com>
Date:   Tue, 6 Sep 2022 14:26:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 net-next 2/6] tcp: Don't allocate tcp_death_row outside
 of struct netns_ipv4.
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
References: <20220906162423.44410-1-kuniyu@amazon.com>
 <20220906162423.44410-3-kuniyu@amazon.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220906162423.44410-3-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/6/22 09:24, Kuniyuki Iwashima wrote:
> We will soon introduce an optional per-netns ehash and access hash
> tables via net->ipv4.tcp_death_row->hashinfo instead of &tcp_hashinfo
> in most places.
>
> It could harm the fast path because dereferences of two fields in net
> and tcp_death_row might incur two extra cache line misses.  To save one
> dereference, let's place tcp_death_row back in netns_ipv4 and fetch
> hashinfo via net->ipv4.tcp_death_row"."hashinfo.
>
> Note tcp_death_row was initially placed in netns_ipv4, and commit
> fbb8295248e1 ("tcp: allocate tcp_death_row outside of struct netns_ipv4")
> changed it to a pointer so that we can fire TIME_WAIT timers after freeing
> net.  However, we don't do so after commit 04c494e68a13 ("Revert "tcp/dccp:
> get rid of inet_twsk_purge()""), so we need not define tcp_death_row as a
> pointer.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>   include/net/netns/ipv4.h      |  3 ++-
>   net/dccp/minisocks.c          |  2 +-
>   net/ipv4/inet_timewait_sock.c |  4 +---
>   net/ipv4/proc.c               |  2 +-
>   net/ipv4/sysctl_net_ipv4.c    |  8 ++------
>   net/ipv4/tcp_ipv4.c           | 14 +++-----------
>   net/ipv4/tcp_minisocks.c      |  2 +-
>   net/ipv6/tcp_ipv6.c           |  2 +-
>   8 files changed, 12 insertions(+), 25 deletions(-)
>
> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index 6320a76cefdc..2c7df93e3403 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -34,6 +34,7 @@ struct inet_hashinfo;
>   struct inet_timewait_death_row {
>   	refcount_t		tw_refcount;
>   
> +	/* Padding to avoid false sharing, tw_refcount can be often written */
>   	struct inet_hashinfo 	*hashinfo ____cacheline_aligned_in_smp;
>   	int			sysctl_max_tw_buckets;
>   };
> @@ -41,7 +42,7 @@ struct inet_timewait_death_row {
>   struct tcp_fastopen_context;
>   
>   struct netns_ipv4 {
> -	struct inet_timewait_death_row *tcp_death_row;
> +	struct inet_timewait_death_row tcp_death_row;
>   
>   #ifdef CONFIG_SYSCTL
>   	struct ctl_table_header	*forw_hdr;
> diff --git a/net/dccp/minisocks.c b/net/dccp/minisocks.c
> index 64d805b27add..39f408d44da5 100644
> --- a/net/dccp/minisocks.c
> +++ b/net/dccp/minisocks.c
> @@ -22,7 +22,7 @@
>   #include "feat.h"
>   
>   struct inet_timewait_death_row dccp_death_row = {
> -	.tw_refcount = REFCOUNT_INIT(1),
> +	.tw_refcount = REFCOUNT_INIT(0),


I do not see how this can possibly work.

If the initial (TCP/DCCP) tw_refcount value is 0, then the first attempt

doing a refcount_inc() will trigger a warning/crash.

Have you looked at dmesg/syslog when testing your patch ?

It should contain a loud warning...


>   	.sysctl_max_tw_buckets = NR_FILE * 2,
>   	.hashinfo	= &dccp_hashinfo,
>   };
> diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> index 47ccc343c9fb..71d3bb0abf6c 100644
> --- a/net/ipv4/inet_timewait_sock.c
> +++ b/net/ipv4/inet_timewait_sock.c
> @@ -59,9 +59,7 @@ static void inet_twsk_kill(struct inet_timewait_sock *tw)
>   	inet_twsk_bind_unhash(tw, hashinfo);
>   	spin_unlock(&bhead->lock);
>   
> -	if (refcount_dec_and_test(&tw->tw_dr->tw_refcount))
> -		kfree(tw->tw_dr);
> -
> +	refcount_dec(&tw->tw_dr->tw_refcount);
>   	inet_twsk_put(tw);
>   }
>   
> diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
> index 0088a4c64d77..37508be97393 100644
> --- a/net/ipv4/proc.c
> +++ b/net/ipv4/proc.c
> @@ -59,7 +59,7 @@ static int sockstat_seq_show(struct seq_file *seq, void *v)
>   	socket_seq_show(seq);
>   	seq_printf(seq, "TCP: inuse %d orphan %d tw %d alloc %d mem %ld\n",
>   		   sock_prot_inuse_get(net, &tcp_prot), orphans,
> -		   refcount_read(&net->ipv4.tcp_death_row->tw_refcount) - 1,


I think your patch changes too many things.

Please leave the refcount base value at 1, not 0 :/


> +		   refcount_read(&net->ipv4.tcp_death_row.tw_refcount),
>   		   sockets, proto_memory_allocated(&tcp_prot));
>   	seq_printf(seq, "UDP: inuse %d mem %ld\n",
>   		   sock_prot_inuse_get(net, &udp_prot),
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 5490c285668b..4d7c110c772f 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -530,10 +530,9 @@ static struct ctl_table ipv4_table[] = {
>   };
>   
>   static struct ctl_table ipv4_net_table[] = {
> -	/* tcp_max_tw_buckets must be first in this table. */
>   	{
>   		.procname	= "tcp_max_tw_buckets",
> -/*		.data		= &init_net.ipv4.tcp_death_row.sysctl_max_tw_buckets, */
> +		.data		= &init_net.ipv4.tcp_death_row.sysctl_max_tw_buckets,
>   		.maxlen		= sizeof(int),
>   		.mode		= 0644,
>   		.proc_handler	= proc_dointvec
> @@ -1361,8 +1360,7 @@ static __net_init int ipv4_sysctl_init_net(struct net *net)
>   		if (!table)
>   			goto err_alloc;
>   
> -		/* skip first entry (sysctl_max_tw_buckets) */
> -		for (i = 1; i < ARRAY_SIZE(ipv4_net_table) - 1; i++) {
> +		for (i = 0; i < ARRAY_SIZE(ipv4_net_table) - 1; i++) {
>   			if (table[i].data) {
>   				/* Update the variables to point into
>   				 * the current struct net
> @@ -1377,8 +1375,6 @@ static __net_init int ipv4_sysctl_init_net(struct net *net)
>   		}
>   	}
>   
> -	table[0].data = &net->ipv4.tcp_death_row->sysctl_max_tw_buckets;
> -
>   	net->ipv4.ipv4_hdr = register_net_sysctl(net, "net/ipv4", table);
>   	if (!net->ipv4.ipv4_hdr)
>   		goto err_reg;
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index a07243f66d4c..e2a6511218f8 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -292,7 +292,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>   	 * complete initialization after this.
>   	 */
>   	tcp_set_state(sk, TCP_SYN_SENT);
> -	tcp_death_row = net->ipv4.tcp_death_row;
> +	tcp_death_row = &net->ipv4.tcp_death_row;
>   	err = inet_hash_connect(tcp_death_row, sk);
>   	if (err)
>   		goto failure;
> @@ -3091,13 +3091,9 @@ EXPORT_SYMBOL(tcp_prot);
>   
>   static void __net_exit tcp_sk_exit(struct net *net)
>   {
> -	struct inet_timewait_death_row *tcp_death_row = net->ipv4.tcp_death_row;
> -
>   	if (net->ipv4.tcp_congestion_control)
>   		bpf_module_put(net->ipv4.tcp_congestion_control,
>   			       net->ipv4.tcp_congestion_control->owner);
> -	if (refcount_dec_and_test(&tcp_death_row->tw_refcount))
> -		kfree(tcp_death_row);

We might add a debug check about tw_refcount being 1 at this point.

WARN_ON_ONCE(!refcount_dec_and_test(&net->ipv4.tcp_death_row.tw_refcount)));


>   }
>   
>   static int __net_init tcp_sk_init(struct net *net)
> @@ -3129,13 +3125,9 @@ static int __net_init tcp_sk_init(struct net *net)
>   	net->ipv4.sysctl_tcp_tw_reuse = 2;
>   	net->ipv4.sysctl_tcp_no_ssthresh_metrics_save = 1;
>   
> -	net->ipv4.tcp_death_row = kzalloc(sizeof(struct inet_timewait_death_row), GFP_KERNEL);
> -	if (!net->ipv4.tcp_death_row)
> -		return -ENOMEM;
> -	refcount_set(&net->ipv4.tcp_death_row->tw_refcount, 1);
>   	cnt = tcp_hashinfo.ehash_mask + 1;
> -	net->ipv4.tcp_death_row->sysctl_max_tw_buckets = cnt / 2;
> -	net->ipv4.tcp_death_row->hashinfo = &tcp_hashinfo;
> +	net->ipv4.tcp_death_row.sysctl_max_tw_buckets = cnt / 2;
> +	net->ipv4.tcp_death_row.hashinfo = &tcp_hashinfo;
>   
>   	net->ipv4.sysctl_max_syn_backlog = max(128, cnt / 128);
>   	net->ipv4.sysctl_tcp_sack = 1;
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index 80ce27f8f77e..8bddb2a78b21 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -250,7 +250,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
>   	struct net *net = sock_net(sk);
>   	struct inet_timewait_sock *tw;
>   
> -	tw = inet_twsk_alloc(sk, net->ipv4.tcp_death_row, state);
> +	tw = inet_twsk_alloc(sk, &net->ipv4.tcp_death_row, state);
>   
>   	if (tw) {
>   		struct tcp_timewait_sock *tcptw = tcp_twsk((struct sock *)tw);
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 5c562d69fddf..eb1da7a63fbb 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -325,7 +325,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>   	inet->inet_dport = usin->sin6_port;
>   
>   	tcp_set_state(sk, TCP_SYN_SENT);
> -	tcp_death_row = net->ipv4.tcp_death_row;
> +	tcp_death_row = &net->ipv4.tcp_death_row;
>   	err = inet6_hash_connect(tcp_death_row, sk);
>   	if (err)
>   		goto late_failure;
