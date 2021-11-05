Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED51445FF9
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 08:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhKEHGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 03:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhKEHGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 03:06:48 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88261C061714;
        Fri,  5 Nov 2021 00:04:08 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g10so29654665edj.1;
        Fri, 05 Nov 2021 00:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uErSkFGzeM8H3+Sqc3m448tWfyPBrOCZMfdSZgMnye4=;
        b=kwDfKNnck7hFNb3vBaby/1aCcPh8sERGy3dhWwmGCW95u0fPNZrpHCrrW/hOnB2sAj
         /3grGAeeSQPAD3hjPzCSr8865Vpn5Ok7whtteEBldhNH7efR4tNAjzPvKneNiw6rjPNL
         HVMoNcivpdHoBv0A4DgnpH/n71YQXjSez8dNcYhKHPXW+wUYW5VXhk/3hCPCwBACkfnH
         3lh1JFIFLQRSQlYKv1YtXhs4kz25ufIrpwgQ7cN9nWB58XKAutadQwAHZIxM/VgH9VMS
         w4DWI5EmKR2KQ/+jCAOrOzgWX1zFQ2FiDVZ9QchekeUha1uSEvZKliQAB1X5JYmALPLX
         YhkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uErSkFGzeM8H3+Sqc3m448tWfyPBrOCZMfdSZgMnye4=;
        b=B8E6vwztvPUWbLsbbGB+qIYxtRznwr6Ffunx/jqiKfus/TDBfs1T7kEiU537rxg/D6
         CyEFlek9Z0f8/r11TvRjZFUgTvCpGGEBx1wPzDgWAFz6P43oFh3nO3ozkhmU9E7wBqxg
         oJhl6uKj3KK/B/n/B36ika9FfXhXL5LLieSwV0Y+uRxQY71NvVoKw87oNX9a6cVZWR4Y
         WEkQ5uzIVQ0pDpuWyWthep5F/AujL7IEjv9ryC91xOdRXSqj9aMLsNiW29tGEJOrwTNG
         2AlBVtHP/4xgjyjrj8eJjJve/WcikiMWPA1KLDkKxfl4awLDsYiLpSSfZa6WoT2FTiqI
         ZVHQ==
X-Gm-Message-State: AOAM532pOODd1YFo/AKF9Hnsf3ZL2ugzIXsnRVueuHswAFFRk5J5PY+U
        KXoNjAAj4IDoNBKCM4TT8mU=
X-Google-Smtp-Source: ABdhPJxNAgAxziZymsBFlfeJlroXyfWc2H6/dDorw9k9IAVoY5ecOV/DHrPUKRp3HrJspSx4dfYhhw==
X-Received: by 2002:a05:6402:26d3:: with SMTP id x19mr41362488edd.279.1636095847162;
        Fri, 05 Nov 2021 00:04:07 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3800:fafc:6a7c:c046:18f4? ([2a04:241e:501:3800:fafc:6a7c:c046:18f4])
        by smtp.gmail.com with ESMTPSA id g21sm4027897edw.86.2021.11.05.00.04.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 00:04:06 -0700 (PDT)
Subject: Re: [PATCH v2 01/25] tcp: authopt: Initial support and key management
To:     Dmitry Safonov <0x7f454c46@gmail.com>
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
 <e7f0449a-2bad-99ad-4737-016a0e6b8b84@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <4e4e7337-dbd7-b857-b164-960b75b1e21b@gmail.com>
Date:   Fri, 5 Nov 2021 09:04:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <e7f0449a-2bad-99ad-4737-016a0e6b8b84@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/21 3:22 AM, Dmitry Safonov wrote:
> Hi Leonard,
> 
> On 11/1/21 16:34, Leonard Crestez wrote:
> [..]
>> +struct tcp_authopt_key {
>> +	/** @flags: Combination of &enum tcp_authopt_key_flag */
>> +	__u32	flags;
>> +	/** @send_id: keyid value for send */
>> +	__u8	send_id;
>> +	/** @recv_id: keyid value for receive */
>> +	__u8	recv_id;
>> +	/** @alg: One of &enum tcp_authopt_alg */
>> +	__u8	alg;
>> +	/** @keylen: Length of the key buffer */
>> +	__u8	keylen;
>> +	/** @key: Secret key */
>> +	__u8	key[TCP_AUTHOPT_MAXKEYLEN];
>> +	/**
>> +	 * @addr: Key is only valid for this address
>> +	 *
>> +	 * Ignored unless TCP_AUTHOPT_KEY_ADDR_BIND flag is set
>> +	 */
>> +	struct __kernel_sockaddr_storage addr;
>> +};
> [..]
>> +/* Free key nicely, for living sockets */
>> +static void tcp_authopt_key_del(struct sock *sk,
>> +				struct tcp_authopt_info *info,
>> +				struct tcp_authopt_key_info *key)
>> +{
>> +	sock_owned_by_me(sk);
>> +	hlist_del_rcu(&key->node);
>> +	atomic_sub(sizeof(*key), &sk->sk_omem_alloc);
>> +	kfree_rcu(key, rcu);
>> +}
> [..]
>> +#define TCP_AUTHOPT_KEY_KNOWN_FLAGS ( \
>> +	TCP_AUTHOPT_KEY_DEL | \
>> +	TCP_AUTHOPT_KEY_EXCLUDE_OPTS | \
>> +	TCP_AUTHOPT_KEY_ADDR_BIND)
>> +
>> +int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
>> +{
> [..]
>> +	/* Delete is a special case: */
>> +	if (opt.flags & TCP_AUTHOPT_KEY_DEL) {
>> +		info = rcu_dereference_check(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
>> +		if (!info)
>> +			return -ENOENT;
>> +		key_info = tcp_authopt_key_lookup_exact(sk, info, &opt);
>> +		if (!key_info)
>> +			return -ENOENT;
>> +		tcp_authopt_key_del(sk, info, key_info);
>> +		return 0;
> 
> I remember we discussed it in RFC, that removing a key that's currently
> in use may result in random MKT to be used.
> 
> I think, it's possible to make this API a bit more predictable if:
> - DEL command fails to remove a key that is current/receive_next;
> - opt.flags has CURR/NEXT flag that has corresponding `u8 current_key`
> and `u8 receive_next` values. As socket lock is held - that makes
> current_key/receive_next change atomic with deletion of an existing key
> that might have been in use.
> 
> In result user may remove a key that's not in use or has to set new
> current/next. Which avoids the issue with random MKT being used to sign
> segments.

The MKT used to sign segments is already essentially random unless the 
user makes a deliberate choice. This is what happens if you add two keys 
an call connect(). But why is this a problem?

Applications which want to deliberately control the send key can do so 
with TCP_AUTHOPT_FLAG_LOCK_KEYID. If that flag is not set then the key 
with send_id == recv_rnextkeyid is preffered as suggested by the RFC, or 
a random one on connect.

I think your suggestion would force additional complexity on all 
applications for no clear gain.

Key selection controls are only added much later in the series, this is 
also part of the effort to split the code into readable patches. See 
this patch:

https://lore.kernel.org/netdev/2dc569c0d60c80c26aafcaa201ba5b5ec53ce6bd.1635784253.git.cdleonard@gmail.com/

Removing a key while traffic is happening shouldn't cause failures in 
recv or send code; this takes some effort but is also required to 
prevent auth failures when a socket is closed and transitions to 
timewait. I attempted to ensure this by only doing rcu_dereference for 
tcp_authopt_info and tcp_authopt_key_info once per packet.

--
Regards,
Leonard
