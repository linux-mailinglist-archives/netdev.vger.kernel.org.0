Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52FA13F6BFF
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 00:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbhHXXAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 19:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhHXXAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 19:00:09 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A259C061757;
        Tue, 24 Aug 2021 15:59:25 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id qe12-20020a17090b4f8c00b00179321cbae7so3440402pjb.2;
        Tue, 24 Aug 2021 15:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jW6s0UH3czXV7VY41p0swKwwK/tCbyWQImnToFU8DNY=;
        b=o91KUFcWpn4Fhhb0HSkdWfuiVgRCu23d0R4jucu/ShOtei5aFoZSoOU/hGGA8t4zVa
         jRr9jEPsRqN7sqIxUjnjt0Vjnxp+YL1Ig18Yx2tkn/GowtaksqLLUbzPuDnT+iKZJV0x
         ErXlfyQrepOmTqTr6qN7A3Q0N/1ZUws0OujEYPseBWv9mED1Iv84F9gVne4s6q9NjE8Z
         Y4OLJwKddjy+35KEvzMuM1EkaMY5piC/zkHjbFeFps+02Bf+xp+A4RIgICzXX9mJWDuH
         ryyDznYyS47qNE5XN5/bzSYHedeSmUovh1ECTnVDwUPPfqXTelGZWu8q1E7x/kOpFvG9
         +fjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jW6s0UH3czXV7VY41p0swKwwK/tCbyWQImnToFU8DNY=;
        b=LGs4b2VYFTnlkVL1Gl1h+4/ERF7/MIhRNsv30gpOCPd8cZ+T+aZHFi29cUFfIp7ARz
         tyNFDM4S1jzk8P6TXuB/InIJ66gKzDOBbMXtpX8zXEhKr74SK2unDdPdFxhTVO9iR6XJ
         YS9NivGG4P/JGPx6WwAv3z1BRyvURa2TuNxgdIgz7ziGndUpqM/xr+VxyoOSPts9XH/d
         BTfIKBysDb+ohtFKg4L0ZywD9s/cBqXq2bNb+U5uRiY0lR3y2/G5KTl63O1g7QMybcCh
         smuw0jRhYSitIq6TSvIB5k7p321oKuSCmLpX8EPOBD0o5ixgXg1wjuy+2P04GTFqcM2T
         mYAA==
X-Gm-Message-State: AOAM5327B66BcU9G4CBRO+08RFAZF+mhOb/PwVGXhD3QpZj43wK1zo1S
        qtHWO1fcDSMFSq1iFXF1tkvmc4el1BI=
X-Google-Smtp-Source: ABdhPJxLptCJ2/6AC5pqw17mW4n3y8a1yEfVMszth1KVfQ/6/ugcppkf6pJ32Zgj6B9dGh+K4wP47w==
X-Received: by 2002:a17:902:fe81:b0:133:851e:5923 with SMTP id x1-20020a170902fe8100b00133851e5923mr13554640plm.25.1629845964290;
        Tue, 24 Aug 2021 15:59:24 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id z4sm3420297pjl.53.2021.08.24.15.59.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 15:59:23 -0700 (PDT)
Subject: Re: [RFCv3 07/15] tcp: authopt: Hook into tcp core
To:     Leonard Crestez <cdleonard@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1629840814.git.cdleonard@gmail.com>
 <73b11222e312a60a17ccaeabbd0e96732289defc.1629840814.git.cdleonard@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3fc7b060-0ed9-eb73-92c0-0765fe4cb414@gmail.com>
Date:   Tue, 24 Aug 2021 15:59:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <73b11222e312a60a17ccaeabbd0e96732289defc.1629840814.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/24/21 2:34 PM, Leonard Crestez wrote:
> The tcp_authopt features exposes a minimal interface to the rest of the
> TCP stack. Only a few functions are exposed and if the feature is
> disabled they return neutral values, avoiding ifdefs in the rest of the
> code.
> 
> Add calls into tcp authopt from send, receive and accept code.
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  include/net/tcp_authopt.h |  56 +++++++++
>  net/ipv4/tcp_authopt.c    | 246 ++++++++++++++++++++++++++++++++++++++
>  net/ipv4/tcp_input.c      |  17 +++
>  net/ipv4/tcp_ipv4.c       |   3 +
>  net/ipv4/tcp_minisocks.c  |   2 +
>  net/ipv4/tcp_output.c     |  74 +++++++++++-
>  net/ipv6/tcp_ipv6.c       |   4 +
>  7 files changed, 401 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
> index c9ee2059b442..61db268f36f8 100644
> --- a/include/net/tcp_authopt.h
> +++ b/include/net/tcp_authopt.h
> @@ -21,10 +21,11 @@ struct tcp_authopt_key_info {
>  	/* Wire identifiers */
>  	u8 send_id, recv_id;
>  	u8 alg_id;
>  	u8 keylen;
>  	u8 key[TCP_AUTHOPT_MAXKEYLEN];
> +	u8 maclen;

I do not see maclen being enforced to 12, or a multiple of 4 ?

This means that later [2], tcp_authopt_hash() will leave up to 3
unitialized bytes in the TCP options, sent to the wire.

This is a  security issue, since we will leak kernel memory.

>  	struct sockaddr_storage addr;
>  	struct tcp_authopt_alg_imp *alg;
>  };
>  
>  /**
> @@ -41,15 +42,53 @@ struct tcp_authopt_info {
>  	u32 src_isn;
>  	u32 dst_isn;
>  };
>  
>  #ifdef CONFIG_TCP_AUTHOPT
> +struct tcp_authopt_key_info *tcp_authopt_select_key(const struct sock *sk,
> +						    const struct sock *addr_sk,
> +						    u8 *rnextkeyid);
>  void tcp_authopt_clear(struct sock *sk);
>  int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
>  int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key);
>  int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen);
> +int tcp_authopt_hash(
> +		char *hash_location,
> +		struct tcp_authopt_key_info *key,
> +		struct sock *sk, struct sk_buff *skb);
> +int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct request_sock *req);
> +static inline int tcp_authopt_openreq(
> +		struct sock *newsk,
> +		const struct sock *oldsk,
> +		struct request_sock *req)
> +{
> +	if (!rcu_dereference(tcp_sk(oldsk)->authopt_info))
> +		return 0;
> +	else
> +		return __tcp_authopt_openreq(newsk, oldsk, req);
> +}
> +int __tcp_authopt_inbound_check(
> +		struct sock *sk,
> +		struct sk_buff *skb,
> +		struct tcp_authopt_info *info);
> +static inline int tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb)
> +{
> +	struct tcp_authopt_info *info = rcu_dereference(tcp_sk(sk)->authopt_info);
> +
> +	if (info)
> +		return __tcp_authopt_inbound_check(sk, skb, info);
> +	else
> +		return 0;
> +}
>  #else
> +static inline struct tcp_authopt_key_info *tcp_authopt_select_key(
> +		const struct sock *sk,
> +		const struct sock *addr_sk,
> +		u8 *rnextkeyid)
> +{
> +	return NULL;
> +}
>  static inline int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
>  {
>  	return -ENOPROTOOPT;
>  }
>  static inline int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key)
> @@ -61,8 +100,25 @@ static inline void tcp_authopt_clear(struct sock *sk)
>  }
>  static inline int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
>  {
>  	return -ENOPROTOOPT;
>  }
> +static inline int tcp_authopt_hash(
> +		char *hash_location,
> +		struct tcp_authopt_key_info *key,
> +		struct sock *sk, struct sk_buff *skb)
> +{
> +	return -EINVAL;
> +}
> +static inline int tcp_authopt_openreq(struct sock *newsk,
> +				      const struct sock *oldsk,
> +				      struct request_sock *req)
> +{
> +	return 0;
> +}
> +static inline int tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb)
> +{
> +	return 0;
> +}
>  #endif
>  
>  #endif /* _LINUX_TCP_AUTHOPT_H */
> diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
> index 2a3463ad6896..af777244d098 100644
> --- a/net/ipv4/tcp_authopt.c
> +++ b/net/ipv4/tcp_authopt.c
> @@ -203,10 +203,71 @@ static struct tcp_authopt_key_info *tcp_authopt_key_lookup_exact(const struct so
>  			return key_info;
>  
>  	return NULL;
>  }
>  
> +struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct tcp_authopt_info *info,
> +						     const struct sock *addr_sk,
> +						     int send_id)
> +{
> +	struct tcp_authopt_key_info *result = NULL;
> +	struct tcp_authopt_key_info *key;
> +
> +	hlist_for_each_entry_rcu(key, &info->head, node, 0) {
> +		if (send_id >= 0 && key->send_id != send_id)
> +			continue;
> +		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
> +			if (addr_sk->sk_family == AF_INET) {
> +				struct sockaddr_in *key_addr = (struct sockaddr_in *)&key->addr;
> +				const struct in_addr *daddr =
> +					(const struct in_addr *)&addr_sk->sk_daddr;

Why a cast is needed ? sk_daddr is a __be32, no need to cast it to in_addr
> +
> +				if (WARN_ON(key_addr->sin_family != AF_INET))

Why a WARN_ON() is used ? If we expect this to trigger, then at minimumum WARN_ON_ONCE() please.

> +					continue;
> +				if (memcmp(daddr, &key_addr->sin_addr, sizeof(*daddr)))
> +					continue;

Using memcmp() to compare two __be32 is overkill.

> +			}
> +			if (addr_sk->sk_family == AF_INET6) {
> +				struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
> +				const struct in6_addr *daddr = &addr_sk->sk_v6_daddr;

Not sure why a variable is used, you need it once.

> +
> +				if (WARN_ON(key_addr->sin6_family != AF_INET6))
> +					continue;
> +				if (memcmp(daddr, &key_addr->sin6_addr, sizeof(*daddr)))

ipv6_addr_equal() should be faster.

> +					continue;
> +			}
> +		}
> +		if (result && net_ratelimit())
> +			pr_warn("ambiguous tcp authentication keys configured for send\n");
> +		result = key;
> +	}
> +
> +	return result;
> +}
> +
> +/**
> + * tcp_authopt_select_key - select key for sending
> + *
> + * addr_sk is the sock used for comparing daddr, it is only different from sk in
> + * the synack case.
> + *
> + * Result is protected by RCU and can't be stored, it may only be passed to
> + * tcp_authopt_hash and only under a single rcu_read_lock.
> + */
> +struct tcp_authopt_key_info *tcp_authopt_select_key(const struct sock *sk,
> +						    const struct sock *addr_sk,
> +						    u8 *rnextkeyid)
> +{
> +	struct tcp_authopt_info *info;
> +
> +	info = rcu_dereference(tcp_sk(sk)->authopt_info);

distro kernels will have CONFIG_TCP_AUTHOPT set, meaning
that we will add a cache line miss for every incoming TCP packet
even on hosts not using any RFC5925 TCP flow.

For TCP MD5 we are using a static key, to avoid this extra cost.

> +	if (!info)
> +		return NULL;
> +
> +	return tcp_authopt_lookup_send(info, addr_sk, -1);
> +}
> +
>  static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk)
>  {
>  	struct tcp_sock *tp = tcp_sk(sk);
>  	struct tcp_authopt_info *info;
>  
> @@ -387,16 +448,69 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
>  	key_info->recv_id = opt.recv_id;
>  	key_info->alg_id = opt.alg;
>  	key_info->alg = alg;
>  	key_info->keylen = opt.keylen;
>  	memcpy(key_info->key, opt.key, opt.keylen);
> +	key_info->maclen = alg->maclen;
>  	memcpy(&key_info->addr, &opt.addr, sizeof(key_info->addr));
>  	hlist_add_head_rcu(&key_info->node, &info->head);
>  
>  	return 0;
>  }
>  
> +static int tcp_authopt_clone_keys(struct sock *newsk,
> +				  const struct sock *oldsk,
> +				  struct tcp_authopt_info *new_info,
> +				  struct tcp_authopt_info *old_info)
> +{
> +	struct tcp_authopt_key_info *old_key;
> +	struct tcp_authopt_key_info *new_key;
> +
> +	hlist_for_each_entry_rcu(old_key, &old_info->head, node, lockdep_sock_is_held(sk)) {
> +		new_key = sock_kmalloc(newsk, sizeof(*new_key), GFP_ATOMIC);
> +		if (!new_key)
> +			return -ENOMEM;
> +		memcpy(new_key, old_key, sizeof(*new_key));
> +		tcp_authopt_alg_incref(old_key->alg);
> +		hlist_add_head_rcu(&new_key->node, &new_info->head);
> +	}
> +
> +	return 0;
> +}
> +
> +/** Called to create accepted sockets.
> + *
> + *  Need to copy authopt info from listen socket.
> + */
> +int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct request_sock *req)
> +{
> +	struct tcp_authopt_info *old_info;
> +	struct tcp_authopt_info *new_info;
> +	int err;
> +
> +	old_info = rcu_dereference(tcp_sk(oldsk)->authopt_info);
> +	if (!old_info)
> +		return 0;
> +
> +	new_info = kmalloc(sizeof(*new_info), GFP_ATOMIC | __GFP_ZERO);

kzalloc() is your friend. (same remark for your other patches, where you are using __GFP_ZERO)
Also see additional comment [1]

> +	if (!new_info)
> +		return -ENOMEM;
> +
> +	sk_nocaps_add(newsk, NETIF_F_GSO_MASK);
> +	new_info->src_isn = tcp_rsk(req)->snt_isn;
> +	new_info->dst_isn = tcp_rsk(req)->rcv_isn;
> +	INIT_HLIST_HEAD(&new_info->head);
> +	err = tcp_authopt_clone_keys(newsk, oldsk, new_info, old_info);
> +	if (err) {
> +		__tcp_authopt_info_free(newsk, new_info);

[1]
		Are we leaving in place old value of newsk->authopt_info ?
		If this is copied from the listener, I think you need
		to add a tcp_sk(newsk)->authopt_info = NULL;
		before the kzalloc() call done above.

			

> +		return err;
> +	}
> +	rcu_assign_pointer(tcp_sk(newsk)->authopt_info, new_info);
> +
> +	return 0;
> +}
> +
>  /* feed traffic key into shash */
>  static int tcp_authopt_shash_traffic_key(struct shash_desc *desc,
>  					 struct sock *sk,
>  					 struct sk_buff *skb,
>  					 bool input,
> @@ -815,10 +929,16 @@ static int tcp_authopt_hash_packet(struct crypto_shash *tfm,
>  		return err;
>  
>  	return crypto_shash_final(desc, macbuf);
>  }
>  
> +/**
> + * __tcp_authopt_calc_mac - Compute packet MAC using key
> + *
> + * @macbuf: output buffer. Must be large enough to fit the digestsize of the
> + * 			underlying transform before truncation. Please use TCP_AUTHOPT_MAXMACBUF
> + */
>  int __tcp_authopt_calc_mac(struct sock *sk,
>  			   struct sk_buff *skb,
>  			   struct tcp_authopt_key_info *key,
>  			   bool input,
>  			   char *macbuf)
> @@ -859,5 +979,131 @@ int __tcp_authopt_calc_mac(struct sock *sk,
>  
>  out:
>  	tcp_authopt_put_mac_shash(key, mac_tfm);
>  	return err;
>  }
> +
> +/**
> + * tcp_authopt_hash - fill in the mac
> + *
> + * The key must come from tcp_authopt_select_key.
> + */
> +int tcp_authopt_hash(char *hash_location,
> +		     struct tcp_authopt_key_info *key,
> +		     struct sock *sk,
> +		     struct sk_buff *skb)
> +{
> +	/* MAC inside option is truncated to 12 bytes but crypto API needs output
> +	 * buffer to be large enough so we use a buffer on the stack.
> +	 */
> +	u8 macbuf[TCP_AUTHOPT_MAXMACBUF];
> +	int err;
> +
> +	if (WARN_ON(key->maclen > sizeof(macbuf)))
> +		return -ENOBUFS;
> +
> +	err = __tcp_authopt_calc_mac(sk, skb, key, false, macbuf);
> +	if (err) {
> +		/* If mac calculation fails and caller doesn't handle the error
> +		 * try to make it obvious inside the packet.
> +		 */
> +		memset(hash_location, 0, key->maclen);
> +		return err;
> +	}
> +	memcpy(hash_location, macbuf, key->maclen);


[2]
This is the place were we do not make sure to clear the padding bytes
(if key->maclen is not a multiple of 4)


> +
> +	return 0;
> +}
> +
> +static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
> +							    struct sk_buff *skb,
> +							    struct tcp_authopt_info *info,
> +							    int recv_id)
> +{
> +	struct tcp_authopt_key_info *result = NULL;
> +	struct tcp_authopt_key_info *key;
> +
> +	/* multiple matches will cause occasional failures */
> +	hlist_for_each_entry_rcu(key, &info->head, node, 0) {
> +		if (recv_id >= 0 && key->recv_id != recv_id)
> +			continue;
> +		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
> +			if (sk->sk_family == AF_INET) {
> +				struct sockaddr_in *key_addr = (struct sockaddr_in *)&key->addr;
> +				struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
> +
> +				if (WARN_ON(key_addr->sin_family != AF_INET))
> +					continue;
> +				if (WARN_ON(iph->version != 4))
> +					continue;
> +				if (memcmp(&iph->saddr, &key_addr->sin_addr, sizeof(iph->saddr)))
> +					continue;
> +			}
> +			if (sk->sk_family == AF_INET6) {
> +				struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
> +				struct ipv6hdr *iph = (struct ipv6hdr *)skb_network_header(skb);
> +
> +				if (WARN_ON(key_addr->sin6_family != AF_INET6))
> +					continue;
> +				if (WARN_ON(iph->version != 6))
> +					continue;
> +				if (memcmp(&iph->saddr, &key_addr->sin6_addr, sizeof(iph->saddr)))
> +					continue;
> +			}
> +		}
> +		if (result && net_ratelimit())
> +			pr_warn("ambiguous tcp authentication keys configured for receive\n");
> +		result = key;
> +	}
> +
> +	return result;
> +}
> +
> +int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp_authopt_info *info)
> +{
> +	struct tcphdr *th = (struct tcphdr *)skb_transport_header(skb);
> +	struct tcphdr_authopt *opt;
> +	struct tcp_authopt_key_info *key;
> +	u8 macbuf[TCP_AUTHOPT_MAXMACBUF];
> +	int err;
> +
> +	opt = (struct tcphdr_authopt *)tcp_authopt_find_option(th);
> +	key = tcp_authopt_lookup_recv(sk, skb, info, opt ? opt->keyid : -1);
> +
> +	/* nothing found or expected */
> +	if (!opt && !key)
> +		return 0;
> +	if (!opt && key) {
> +		net_info_ratelimited("TCP Authentication Missing\n");
> +		return -EINVAL;
> +	}
> +	if (opt && !key) {
> +		/* RFC5925 Section 7.3:
> +		 * A TCP-AO implementation MUST allow for configuration of the behavior
> +		 * of segments with TCP-AO but that do not match an MKT. The initial
> +		 * default of this configuration SHOULD be to silently accept such
> +		 * connections.
> +		 */
> +		if (info->flags & TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED) {
> +			net_info_ratelimited("TCP Authentication Unexpected: Rejected\n");
> +			return -EINVAL;
> +		} else {
> +			net_info_ratelimited("TCP Authentication Unexpected: Accepted\n");
> +			return 0;
> +		}
> +	}
> +
> +	/* bad inbound key len */
> +	if (key->maclen + 4 != opt->len)
> +		return -EINVAL;
> +
> +	err = __tcp_authopt_calc_mac(sk, skb, key, true, macbuf);
> +	if (err)
> +		return err;
> +
> +	if (memcmp(macbuf, opt->mac, key->maclen)) {
> +		net_info_ratelimited("TCP Authentication Failed\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 3f7bd7ae7d7a..e0b51b2f747f 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -70,10 +70,11 @@
>  #include <linux/sysctl.h>
>  #include <linux/kernel.h>
>  #include <linux/prefetch.h>
>  #include <net/dst.h>
>  #include <net/tcp.h>
> +#include <net/tcp_authopt.h>
>  #include <net/inet_common.h>
>  #include <linux/ipsec.h>
>  #include <asm/unaligned.h>
>  #include <linux/errqueue.h>
>  #include <trace/events/tcp.h>
> @@ -5967,18 +5968,34 @@ void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb)
>  	if (!icsk->icsk_ca_initialized)
>  		tcp_init_congestion_control(sk);
>  	tcp_init_buffer_space(sk);
>  }
>  
> +static void tcp_authopt_finish_connect(struct sock *sk, struct sk_buff *skb)
> +{
> +#ifdef CONFIG_TCP_AUTHOPT
> +	struct tcp_authopt_info *info;
> +
> +	info = rcu_dereference_protected(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
> +	if (!info)
> +		return;
> +
> +	info->src_isn = ntohl(tcp_hdr(skb)->ack_seq) - 1;
> +	info->dst_isn = ntohl(tcp_hdr(skb)->seq);
> +#endif
> +}
> +
>  void tcp_finish_connect(struct sock *sk, struct sk_buff *skb)
>  {
>  	struct tcp_sock *tp = tcp_sk(sk);
>  	struct inet_connection_sock *icsk = inet_csk(sk);
>  
>  	tcp_set_state(sk, TCP_ESTABLISHED);
>  	icsk->icsk_ack.lrcvtime = tcp_jiffies32;
>  
> +	tcp_authopt_finish_connect(sk, skb);
> +
>  	if (skb) {
>  		icsk->icsk_af_ops->sk_rx_dst_set(sk, skb);
>  		security_inet_conn_established(sk, skb);
>  		sk_mark_napi_id(sk, skb);
>  	}
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 1348615c7576..a1d39183908c 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2060,10 +2060,13 @@ int tcp_v4_rcv(struct sk_buff *skb)
>  		goto discard_and_relse;
>  
>  	if (tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))
>  		goto discard_and_relse;
>  
> +	if (tcp_authopt_inbound_check(sk, skb))
> +		goto discard_and_relse;
> +
>  	nf_reset_ct(skb);
>  
>  	if (tcp_filter(sk, skb))
>  		goto discard_and_relse;
>  	th = (const struct tcphdr *)skb->data;
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index 0a4f3f16140a..4d7d86547b0e 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -24,10 +24,11 @@
>  #include <linux/slab.h>
>  #include <linux/sysctl.h>
>  #include <linux/workqueue.h>
>  #include <linux/static_key.h>
>  #include <net/tcp.h>
> +#include <net/tcp_authopt.h>
>  #include <net/inet_common.h>
>  #include <net/xfrm.h>
>  #include <net/busy_poll.h>
>  
>  static bool tcp_in_window(u32 seq, u32 end_seq, u32 s_win, u32 e_win)
> @@ -539,10 +540,11 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
>  #ifdef CONFIG_TCP_MD5SIG
>  	newtp->md5sig_info = NULL;	/*XXX*/
>  	if (newtp->af_specific->md5_lookup(sk, newsk))
>  		newtp->tcp_header_len += TCPOLEN_MD5SIG_ALIGNED;
>  #endif
> +	tcp_authopt_openreq(newsk, sk, req);
>  	if (skb->len >= TCP_MSS_DEFAULT + newtp->tcp_header_len)
>  		newicsk->icsk_ack.last_seg_size = skb->len - newtp->tcp_header_len;
>  	newtp->rx_opt.mss_clamp = req->mss;
>  	tcp_ecn_openreq_child(newtp, req);
>  	newtp->fastopen_req = NULL;
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 6d72f3ea48c4..6d73bee349c9 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -37,10 +37,11 @@
>  
>  #define pr_fmt(fmt) "TCP: " fmt
>  
>  #include <net/tcp.h>
>  #include <net/mptcp.h>
> +#include <net/tcp_authopt.h>
>  
>  #include <linux/compiler.h>
>  #include <linux/gfp.h>
>  #include <linux/module.h>
>  #include <linux/static_key.h>
> @@ -411,10 +412,11 @@ static inline bool tcp_urg_mode(const struct tcp_sock *tp)
>  
>  #define OPTION_SACK_ADVERTISE	(1 << 0)
>  #define OPTION_TS		(1 << 1)
>  #define OPTION_MD5		(1 << 2)
>  #define OPTION_WSCALE		(1 << 3)
> +#define OPTION_AUTHOPT		(1 << 4)
>  #define OPTION_FAST_OPEN_COOKIE	(1 << 8)
>  #define OPTION_SMC		(1 << 9)
>  #define OPTION_MPTCP		(1 << 10)
>  
>  static void smc_options_write(__be32 *ptr, u16 *options)
> @@ -435,16 +437,21 @@ static void smc_options_write(__be32 *ptr, u16 *options)
>  struct tcp_out_options {
>  	u16 options;		/* bit field of OPTION_* */
>  	u16 mss;		/* 0 to disable */
>  	u8 ws;			/* window scale, 0 to disable */
>  	u8 num_sack_blocks;	/* number of SACK blocks to include */
> -	u8 hash_size;		/* bytes in hash_location */
>  	u8 bpf_opt_len;		/* length of BPF hdr option */
> +#ifdef CONFIG_TCP_AUTHOPT
> +	u8 authopt_rnextkeyid; /* rnextkey */
> +#endif
>  	__u8 *hash_location;	/* temporary pointer, overloaded */
>  	__u32 tsval, tsecr;	/* need to include OPTION_TS */
>  	struct tcp_fastopen_cookie *fastopen_cookie;	/* Fast open cookie */
>  	struct mptcp_out_options mptcp;
> +#ifdef CONFIG_TCP_AUTHOPT
> +	struct tcp_authopt_key_info *authopt_key;
> +#endif
>  };
>  
>  static void mptcp_options_write(__be32 *ptr, const struct tcp_sock *tp,
>  				struct tcp_out_options *opts)
>  {
> @@ -617,10 +624,24 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
>  		/* overload cookie hash location */
>  		opts->hash_location = (__u8 *)ptr;
>  		ptr += 4;
>  	}
>  
> +#ifdef CONFIG_TCP_AUTHOPT
> +	if (unlikely(OPTION_AUTHOPT & options)) {
> +		struct tcp_authopt_key_info *key = opts->authopt_key;
> +
> +		WARN_ON(!key);
> +		*ptr++ = htonl((TCPOPT_AUTHOPT << 24) | ((4 + key->maclen) << 16) |
> +			       (key->send_id << 8) | opts->authopt_rnextkeyid);
> +		/* overload cookie hash location */
> +		opts->hash_location = (__u8 *)ptr;
> +		/* maclen is currently always 12 but try to align nicely anyway. */
> +		ptr += (key->maclen + 3) / 4;
> +	}
> +#endif
> +
>  	if (unlikely(opts->mss)) {
>  		*ptr++ = htonl((TCPOPT_MSS << 24) |
>  			       (TCPOLEN_MSS << 16) |
>  			       opts->mss);
>  	}
> @@ -752,10 +773,28 @@ static void mptcp_set_option_cond(const struct request_sock *req,
>  			}
>  		}
>  	}
>  }
>  
> +static int tcp_authopt_init_options(const struct sock *sk,
> +				    const struct sock *addr_sk,
> +				    struct tcp_out_options *opts)
> +{
> +#ifdef CONFIG_TCP_AUTHOPT
> +	struct tcp_authopt_key_info *key;
> +
> +	key = tcp_authopt_select_key(sk, addr_sk, &opts->authopt_rnextkeyid);
> +	if (key) {
> +		opts->options |= OPTION_AUTHOPT;
> +		opts->authopt_key = key;
> +		return 4 + key->maclen;
> +	}
> +#endif
> +
> +	return 0;
> +}
> +
>  /* Compute TCP options for SYN packets. This is not the final
>   * network wire format yet.
>   */
>  static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
>  				struct tcp_out_options *opts,
> @@ -774,10 +813,11 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
>  			opts->options |= OPTION_MD5;
>  			remaining -= TCPOLEN_MD5SIG_ALIGNED;
>  		}
>  	}
>  #endif
> +	remaining -= tcp_authopt_init_options(sk, sk, opts);
>  
>  	/* We always get an MSS option.  The option bytes which will be seen in
>  	 * normal data packets should timestamps be used, must be in the MSS
>  	 * advertised.  But we subtract them from tp->mss_cache so that
>  	 * calculations in tcp_sendmsg are simpler etc.  So account for this
> @@ -862,10 +902,11 @@ static unsigned int tcp_synack_options(const struct sock *sk,
>  		 */
>  		if (synack_type != TCP_SYNACK_COOKIE)
>  			ireq->tstamp_ok &= !ireq->sack_ok;
>  	}
>  #endif
> +	remaining -= tcp_authopt_init_options(sk, req_to_sk(req), opts);
>  
>  	/* We always send an MSS option. */
>  	opts->mss = mss;
>  	remaining -= TCPOLEN_MSS_ALIGNED;
>  
> @@ -930,10 +971,11 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
>  			opts->options |= OPTION_MD5;
>  			size += TCPOLEN_MD5SIG_ALIGNED;
>  		}
>  	}
>  #endif
> +	size += tcp_authopt_init_options(sk, sk, opts);
>  
>  	if (likely(tp->rx_opt.tstamp_ok)) {
>  		opts->options |= OPTION_TS;
>  		opts->tsval = skb ? tcp_skb_timestamp(skb) + tp->tsoffset : 0;
>  		opts->tsecr = tp->rx_opt.ts_recent;
> @@ -1277,10 +1319,14 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
>  
>  	inet = inet_sk(sk);
>  	tcb = TCP_SKB_CB(skb);
>  	memset(&opts, 0, sizeof(opts));
>  
> +#ifdef CONFIG_TCP_AUTHOPT
> +	/* for tcp_authopt_init_options inside tcp_syn_options or tcp_established_options */
> +	rcu_read_lock();
> +#endif
>  	if (unlikely(tcb->tcp_flags & TCPHDR_SYN)) {
>  		tcp_options_size = tcp_syn_options(sk, skb, &opts, &md5);
>  	} else {
>  		tcp_options_size = tcp_established_options(sk, skb, &opts,
>  							   &md5);
> @@ -1365,10 +1411,17 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
>  		sk_nocaps_add(sk, NETIF_F_GSO_MASK);
>  		tp->af_specific->calc_md5_hash(opts.hash_location,
>  					       md5, sk, skb);
>  	}
>  #endif
> +#ifdef CONFIG_TCP_AUTHOPT
> +	if (opts.authopt_key) {
> +		sk_nocaps_add(sk, NETIF_F_GSO_MASK);
> +		tcp_authopt_hash(opts.hash_location, opts.authopt_key, sk, skb);
> +	}
> +	rcu_read_unlock();
> +#endif
>  
>  	/* BPF prog is the last one writing header option */
>  	bpf_skops_write_hdr_opt(sk, skb, NULL, NULL, 0, &opts);
>  
>  	INDIRECT_CALL_INET(icsk->icsk_af_ops->send_check,
> @@ -1836,12 +1889,21 @@ unsigned int tcp_current_mss(struct sock *sk)
>  		u32 mtu = dst_mtu(dst);
>  		if (mtu != inet_csk(sk)->icsk_pmtu_cookie)
>  			mss_now = tcp_sync_mss(sk, mtu);
>  	}
>  
> +#ifdef CONFIG_TCP_AUTHOPT
> +	/* Even if the result is not used rcu_read_lock is required when scanning for
> +	 * tcp authentication keys. Otherwise lockdep will complain.
> +	 */
> +	rcu_read_lock();
> +#endif
>  	header_len = tcp_established_options(sk, NULL, &opts, &md5) +
>  		     sizeof(struct tcphdr);
> +#ifdef CONFIG_TCP_AUTHOPT
> +	rcu_read_unlock();
> +#endif
>  	/* The mss_cache is sized based on tp->tcp_header_len, which assumes
>  	 * some common options. If this is an odd packet (because we have SACK
>  	 * blocks etc) then our calculated header_len will be different, and
>  	 * we have to adjust mss_now correspondingly */
>  	if (header_len != tp->tcp_header_len) {
> @@ -3566,10 +3628,14 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
>  	}
>  
>  #ifdef CONFIG_TCP_MD5SIG
>  	rcu_read_lock();
>  	md5 = tcp_rsk(req)->af_specific->req_md5_lookup(sk, req_to_sk(req));
> +#endif
> +#ifdef CONFIG_TCP_AUTHOPT
> +	/* for tcp_authopt_init_options inside tcp_synack_options */
> +	rcu_read_lock();
>  #endif
>  	skb_set_hash(skb, tcp_rsk(req)->txhash, PKT_HASH_TYPE_L4);
>  	/* bpf program will be interested in the tcp_flags */
>  	TCP_SKB_CB(skb)->tcp_flags = TCPHDR_SYN | TCPHDR_ACK;
>  	tcp_header_size = tcp_synack_options(sk, req, mss, skb, &opts, md5,
> @@ -3603,10 +3669,16 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
>  	if (md5)
>  		tcp_rsk(req)->af_specific->calc_md5_hash(opts.hash_location,
>  					       md5, req_to_sk(req), skb);
>  	rcu_read_unlock();
>  #endif
> +#ifdef CONFIG_TCP_AUTHOPT
> +	/* If signature fails we do nothing */
> +	if (opts.authopt_key)
> +		tcp_authopt_hash(opts.hash_location, opts.authopt_key, req_to_sk(req), skb);
> +	rcu_read_unlock();
> +#endif
>  
>  	bpf_skops_write_hdr_opt((struct sock *)sk, skb, req, syn_skb,
>  				synack_type, &opts);
>  
>  	skb->skb_mstamp_ns = now;
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 0ce52d46e4f8..51381a9c2bd5 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -40,10 +40,11 @@
>  #include <linux/icmpv6.h>
>  #include <linux/random.h>
>  #include <linux/indirect_call_wrapper.h>
>  
>  #include <net/tcp.h>
> +#include <net/tcp_authopt.h>
>  #include <net/ndisc.h>
>  #include <net/inet6_hashtables.h>
>  #include <net/inet6_connection_sock.h>
>  #include <net/ipv6.h>
>  #include <net/transp_v6.h>
> @@ -1733,10 +1734,13 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
>  		goto discard_and_relse;
>  
>  	if (tcp_v6_inbound_md5_hash(sk, skb, dif, sdif))
>  		goto discard_and_relse;
>  
> +	if (tcp_authopt_inbound_check(sk, skb))
> +		goto discard_and_relse;
> +
>  	if (tcp_filter(sk, skb))
>  		goto discard_and_relse;
>  	th = (const struct tcphdr *)skb->data;
>  	hdr = ipv6_hdr(skb);
>  	tcp_v6_fill_cb(skb, hdr, th);
> 
