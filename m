Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F4C3F7AA0
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 18:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241759AbhHYQdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 12:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241646AbhHYQdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 12:33:33 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA217C0613CF;
        Wed, 25 Aug 2021 09:32:47 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id u3so52846889ejz.1;
        Wed, 25 Aug 2021 09:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vvAn8Qq1yUHd991dRWHMu/nzZChgKVNVamGBLSj0MkU=;
        b=LyYU6ViIKtar+uf/3IZB+IZZr5DI8TEd/YudslRBZy9+/8CrzD2fzAP43QA/yZIIE5
         WEO+kujpYaencwfXKNz0tQdQbLbTgvSiTbNsOWWARORLoA2w3jGaV1/SaYM6tg446TEa
         eJ7p+op2YIrlYucEpIUNswJ2NvE0qRPBXny4aCY1Beui7DDdsDmdhPik0Q7JnYUWLeN9
         Z8R7SNFjEP2kwv+GVOdSTRSOJkNiNwpKDNMY8FzlCetE/IQ2q57FhZ9KDVhZjO3VtjWw
         1njM1uRmePgg6WL0CKfSI3dlra8zXXjElqEyT3k8Ck10oORi3Optn7U8b9/DAWxoY2Hf
         PBLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vvAn8Qq1yUHd991dRWHMu/nzZChgKVNVamGBLSj0MkU=;
        b=ZVb/VNFIaNJNkwBdk+tHRsawxTUYp+bwUyKosiyChPdW68aysuQrluCAJFz99oTuJ1
         BGcWcZKuev5QUssLKV2UxvL8G1tUNpTEQrnbVmFoD5PQqBJ0oqOaNe4P9gltPat7FSsR
         8wHrJdxhYIsgv65HkPnBSEFpwuZz3S8KsqoHIZxu0xizTmSNo8lqafQqoiU7RLK94Al1
         tKNKjQdcsvyNFkpzSx+3g6B6VIep8UuYeEmUpNvT2lz5MMr1JpUpp4P/Z9hFUkmfaMTk
         vorUDsgEhHyqiimmaLJDz9PoFCMKLtm0sfe5x+EoTykH/s9ADsJckVS46k6aUgCdyN5N
         y4BQ==
X-Gm-Message-State: AOAM530ZnAvUFaHeou+ooKP+IA2F+F783POR7livd/nERaBZoTbiIzOq
        lHGaAKbv+V33dlwoQuzloNY=
X-Google-Smtp-Source: ABdhPJw4Ao1UW1KM0SEPv7AkWoGmf/32vUDSlbCVniZSY/5NkINPR5SiUGknu9m6JqndOvEi9n74Yg==
X-Received: by 2002:a17:906:e82:: with SMTP id p2mr23089746ejf.50.1629909166464;
        Wed, 25 Aug 2021 09:32:46 -0700 (PDT)
Received: from ?IPv6:2a04:241e:502:1d80:f02c:a1bd:70b1:fe95? ([2a04:241e:502:1d80:f02c:a1bd:70b1:fe95])
        by smtp.gmail.com with ESMTPSA id x15sm78312ejc.59.2021.08.25.09.32.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 09:32:45 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
Subject: Re: [RFCv3 07/15] tcp: authopt: Hook into tcp core
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>
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
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>
References: <cover.1629840814.git.cdleonard@gmail.com>
 <73b11222e312a60a17ccaeabbd0e96732289defc.1629840814.git.cdleonard@gmail.com>
 <3fc7b060-0ed9-eb73-92c0-0765fe4cb414@gmail.com>
Message-ID: <07c44a66-1db3-1136-8894-731dafb0d2d7@gmail.com>
Date:   Wed, 25 Aug 2021 19:32:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3fc7b060-0ed9-eb73-92c0-0765fe4cb414@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.08.2021 01:59, Eric Dumazet wrote:
> On 8/24/21 2:34 PM, Leonard Crestez wrote:
>> The tcp_authopt features exposes a minimal interface to the rest of the
>> TCP stack. Only a few functions are exposed and if the feature is
>> disabled they return neutral values, avoiding ifdefs in the rest of the
>> code.
>>
>> Add calls into tcp authopt from send, receive and accept code.
>>
>> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
>> ---
>>   include/net/tcp_authopt.h |  56 +++++++++
>>   net/ipv4/tcp_authopt.c    | 246 ++++++++++++++++++++++++++++++++++++++
>>   net/ipv4/tcp_input.c      |  17 +++
>>   net/ipv4/tcp_ipv4.c       |   3 +
>>   net/ipv4/tcp_minisocks.c  |   2 +
>>   net/ipv4/tcp_output.c     |  74 +++++++++++-
>>   net/ipv6/tcp_ipv6.c       |   4 +
>>   7 files changed, 401 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
>> index c9ee2059b442..61db268f36f8 100644
>> --- a/include/net/tcp_authopt.h
>> +++ b/include/net/tcp_authopt.h
>> @@ -21,10 +21,11 @@ struct tcp_authopt_key_info {
>>   	/* Wire identifiers */
>>   	u8 send_id, recv_id;
>>   	u8 alg_id;
>>   	u8 keylen;
>>   	u8 key[TCP_AUTHOPT_MAXKEYLEN];
>> +	u8 maclen;
> 
> I do not see maclen being enforced to 12, or a multiple of 4 ?

For both current algorithms the maclen value is 12. I just implemented 
RFC5926, there is no way to control this from userspace.

> This means that later [2], tcp_authopt_hash() will leave up to 3
> unitialized bytes in the TCP options, sent to the wire.
> 
> This is a  security issue, since we will leak kernel memory.

Filling the remainder with zeroes does make sense, or at least 
WARN_ON(maclen != 4) so that it's obvious to anyone who attempts to 
extend the algorithms.

>> +struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct tcp_authopt_info *info,
>> +						     const struct sock *addr_sk,
>> +						     int send_id)
>> +{
>> +	struct tcp_authopt_key_info *result = NULL;
>> +	struct tcp_authopt_key_info *key;
>> +
>> +	hlist_for_each_entry_rcu(key, &info->head, node, 0) {
>> +		if (send_id >= 0 && key->send_id != send_id)
>> +			continue;
>> +		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
>> +			if (addr_sk->sk_family == AF_INET) {
>> +				struct sockaddr_in *key_addr = (struct sockaddr_in *)&key->addr;
>> +				const struct in_addr *daddr =
>> +					(const struct in_addr *)&addr_sk->sk_daddr;
> 
> Why a cast is needed ? sk_daddr is a __be32, no need to cast it to in_addr
>> +
>> +				if (WARN_ON(key_addr->sin_family != AF_INET))
> 
> Why a WARN_ON() is used ? If we expect this to trigger, then at minimumum WARN_ON_ONCE() please.
> 
>> +					continue;
>> +				if (memcmp(daddr, &key_addr->sin_addr, sizeof(*daddr)))
>> +					continue;
> 
> Using memcmp() to compare two __be32 is overkill.
> 
>> +			}
>> +			if (addr_sk->sk_family == AF_INET6) {
>> +				struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
>> +				const struct in6_addr *daddr = &addr_sk->sk_v6_daddr;
> 
> Not sure why a variable is used, you need it once.
> 
>> +
>> +				if (WARN_ON(key_addr->sin6_family != AF_INET6))
>> +					continue;
>> +				if (memcmp(daddr, &key_addr->sin6_addr, sizeof(*daddr)))
> 
> ipv6_addr_equal() should be faster.

OK, I will replace the comparisons.

Checking address family is mostly paranoia on my part, I don't know if a 
real scenario exists for AF mismatch. Still need to check ipv4-mapped 
ipv6 addresses, not sure if those can receive ipv4 skbs on an ipv6 socket.

>> +struct tcp_authopt_key_info *tcp_authopt_select_key(const struct sock *sk,
>> +						    const struct sock *addr_sk,
>> +						    u8 *rnextkeyid)
>> +{
>> +	struct tcp_authopt_info *info;
>> +
>> +	info = rcu_dereference(tcp_sk(sk)->authopt_info);
> 
> distro kernels will have CONFIG_TCP_AUTHOPT set, meaning
> that we will add a cache line miss for every incoming TCP packet
> even on hosts not using any RFC5925 TCP flow.
> 
> For TCP MD5 we are using a static key, to avoid this extra cost.

OK, will add a static_key.

The check for "does socket have tcp_authopt" also belongs in an inline 
wrapper, similar to inbound check

>> +int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct request_sock *req)
>> +{
>> +	struct tcp_authopt_info *old_info;
>> +	struct tcp_authopt_info *new_info;
>> +	int err;
>> +
>> +	old_info = rcu_dereference(tcp_sk(oldsk)->authopt_info);
>> +	if (!old_info)
>> +		return 0;
>> +
>> +	new_info = kmalloc(sizeof(*new_info), GFP_ATOMIC | __GFP_ZERO);
> 
> kzalloc() is your friend. (same remark for your other patches, where you are using __GFP_ZERO)
> Also see additional comment [1]

OK
> 
>> +	if (!new_info)
>> +		return -ENOMEM;
>> +
>> +	sk_nocaps_add(newsk, NETIF_F_GSO_MASK);
>> +	new_info->src_isn = tcp_rsk(req)->snt_isn;
>> +	new_info->dst_isn = tcp_rsk(req)->rcv_isn;
>> +	INIT_HLIST_HEAD(&new_info->head);
>> +	err = tcp_authopt_clone_keys(newsk, oldsk, new_info, old_info);
>> +	if (err) {
>> +		__tcp_authopt_info_free(newsk, new_info);
> 
> 		Are we leaving in place old value of newsk->authopt_info ?
> 		If this is copied from the listener, I think you need
> 		to add a tcp_sk(newsk)->authopt_info = NULL;
> 		before the kzalloc() call done above.

Yes, authopt_info should be set to NULL on error because keeping the 
listen socket's value is wrong and dangerous (double free).

Leaving authopt_info NULL or malloc failure is still possible dangerous 
because it means all keys are ignored and accepted. Not clear how we 
could cause tcp_create_openreq_child to fail instead.

This is a problem in a few other parts: if cryptography fails the 
outbound MAC is filled with zeros because there's not obvious way to 
make TX fail at that point.

>> +	err = __tcp_authopt_calc_mac(sk, skb, key, false, macbuf);
>> +	if (err) {
>> +		/* If mac calculation fails and caller doesn't handle the error
>> +		 * try to make it obvious inside the packet.
>> +		 */
>> +		memset(hash_location, 0, key->maclen);
>> +		return err;
>> +	}
>> +	memcpy(hash_location, macbuf, key->maclen);
> 
> 
> [2]
> This is the place were we do not make sure to clear the padding bytes
> (if key->maclen is not a multiple of 4)

Yes. It might make sense to fix in caller because it's the caller which 
decides to align options.
