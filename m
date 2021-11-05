Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7EE445D41
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 02:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhKEBZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 21:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhKEBZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 21:25:10 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EC2C061714;
        Thu,  4 Nov 2021 18:22:31 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id b184-20020a1c1bc1000000b0033140bf8dd5so5453326wmb.5;
        Thu, 04 Nov 2021 18:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SLnnbrtMHtKbdTFjn0/cgFPnGOzXZjXisxXELw1s/tE=;
        b=g/nx8bR6C1aHJgc2XPHBETGyeNH1xR6pC24lfysfM53iN2Przw8zztZAEyJ8LGv88T
         NXAN/cBgKSIGHcwYPATtgiKaIv3e2WVdM3iNUaZhEfzDZ7AOwW5EJAfezG2ElCuDdULm
         wMRnVIMpd3b3nf1Qm28n7u/OgQGkhP1ikkl+1ddFhwGtc9ODoYZmziS6MZWNC1WqjcMm
         pmA3cuG6mdcgB1nLCqDt2d5aik5HVK0OYKQCMX9Xcs0tB4WdwmQv5L90z1HmYrYBTg1x
         +7Gg4/UbqbPL8vMPkyl4GbWfTduOercmegg4WSSZgpzAmpEOG01WEtqNJCUrV9kzfxi+
         o/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SLnnbrtMHtKbdTFjn0/cgFPnGOzXZjXisxXELw1s/tE=;
        b=j9pO8L633sl0Zg+6vJGx24KVYeNde3jv+9jMIg7OBuTCxs3CQ9EtOn34oG1qU2QiyV
         66hldVI/3Vo841KYSw1mS+8xEW2sMTj3YrrFGxjQIiXm07CKLaEALaMx9rgnDVr8oSxY
         SpD5B0wIbWcQlqAxVr9eS6+NCvzEKK7fEadBK0JGOle49I9WCL8ihRkI+EHwR7QCxAlm
         Qy4N7ncfzyfJPcuW9377NTdGxfg6GD1t5m+qMro4AHP1aIYLhx6MLDxnV6JM/Zvw6PeP
         MPMgEwBMsomSGPIDMi91CDY1vDwgNpOoRF1dMSWau+w4DLy6S+V+hHxeC/GfFakvBBx0
         jdGw==
X-Gm-Message-State: AOAM531k6o4CNfmchdvyvviI3JOxViI4Rk9akgOBv9pY8bNEo2g63/rv
        BT9El7rcsnst0IRvwounbes=
X-Google-Smtp-Source: ABdhPJzaHeSt9WmG5hywsdxM3iRAB7np2FMyH9cay7JfOOMPABFibQgtsFIowz4CW//+DCur9dY3EA==
X-Received: by 2002:a1c:c91a:: with SMTP id f26mr27198007wmb.89.1636075350302;
        Thu, 04 Nov 2021 18:22:30 -0700 (PDT)
Received: from ?IPV6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id f18sm6519388wre.7.2021.11.04.18.22.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 18:22:29 -0700 (PDT)
Message-ID: <e7f0449a-2bad-99ad-4737-016a0e6b8b84@gmail.com>
Date:   Fri, 5 Nov 2021 01:22:28 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 01/25] tcp: authopt: Initial support and key management
Content-Language: en-US
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>
References: <cover.1635784253.git.cdleonard@gmail.com>
 <51044c39f2e4331f2609484d28c756e2a9db5144.1635784253.git.cdleonard@gmail.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
In-Reply-To: <51044c39f2e4331f2609484d28c756e2a9db5144.1635784253.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leonard,

On 11/1/21 16:34, Leonard Crestez wrote:
[..]
> +struct tcp_authopt_key {
> +	/** @flags: Combination of &enum tcp_authopt_key_flag */
> +	__u32	flags;
> +	/** @send_id: keyid value for send */
> +	__u8	send_id;
> +	/** @recv_id: keyid value for receive */
> +	__u8	recv_id;
> +	/** @alg: One of &enum tcp_authopt_alg */
> +	__u8	alg;
> +	/** @keylen: Length of the key buffer */
> +	__u8	keylen;
> +	/** @key: Secret key */
> +	__u8	key[TCP_AUTHOPT_MAXKEYLEN];
> +	/**
> +	 * @addr: Key is only valid for this address
> +	 *
> +	 * Ignored unless TCP_AUTHOPT_KEY_ADDR_BIND flag is set
> +	 */
> +	struct __kernel_sockaddr_storage addr;
> +};
[..]
> +/* Free key nicely, for living sockets */
> +static void tcp_authopt_key_del(struct sock *sk,
> +				struct tcp_authopt_info *info,
> +				struct tcp_authopt_key_info *key)
> +{
> +	sock_owned_by_me(sk);
> +	hlist_del_rcu(&key->node);
> +	atomic_sub(sizeof(*key), &sk->sk_omem_alloc);
> +	kfree_rcu(key, rcu);
> +}
[..]
> +#define TCP_AUTHOPT_KEY_KNOWN_FLAGS ( \
> +	TCP_AUTHOPT_KEY_DEL | \
> +	TCP_AUTHOPT_KEY_EXCLUDE_OPTS | \
> +	TCP_AUTHOPT_KEY_ADDR_BIND)
> +
> +int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
> +{
[..]
> +	/* Delete is a special case: */
> +	if (opt.flags & TCP_AUTHOPT_KEY_DEL) {
> +		info = rcu_dereference_check(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
> +		if (!info)
> +			return -ENOENT;
> +		key_info = tcp_authopt_key_lookup_exact(sk, info, &opt);
> +		if (!key_info)
> +			return -ENOENT;
> +		tcp_authopt_key_del(sk, info, key_info);
> +		return 0;

I remember we discussed it in RFC, that removing a key that's currently
in use may result in random MKT to be used.

I think, it's possible to make this API a bit more predictable if:
- DEL command fails to remove a key that is current/receive_next;
- opt.flags has CURR/NEXT flag that has corresponding `u8 current_key`
and `u8 receive_next` values. As socket lock is held - that makes
current_key/receive_next change atomic with deletion of an existing key
that might have been in use.

In result user may remove a key that's not in use or has to set new
current/next. Which avoids the issue with random MKT being used to sign
segments.

Thanks,
          Dmitry
