Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BC2444AB2
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 23:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhKCWLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 18:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhKCWLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 18:11:49 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4FFC061714;
        Wed,  3 Nov 2021 15:09:11 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id j21so14333553edt.11;
        Wed, 03 Nov 2021 15:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JxvBCwtXVXA51PB27K0Ro1MmZW49I6nP4/hLBFQaZd8=;
        b=krgBuisZb09mEwLw+B+dmxnZoWYQkVtQfjNc79p4OKmGvMUfJ8rACv2CKi5KO9qon9
         8YpT0SE1MMc8NfvY7+/EkosYALGjC6bjbOXEPHTru7tVC4GC4m7UBwniDJ1llitpuD75
         pkrDC+AMXUt03w2jWRjeZhDEvOo57IotZBK6HiNfjuXF9rJm3g94jlxia/LB6iKk0ONg
         e+zNEeEfh1ZcD0GVp7TBHmvk+u4EQuZtCAf4SotcqUrjTZ7ndR+qqsHbZ4qoRWJYchIN
         iSen3ibo88IZAhq4E5T4ZkzrnlK7/ci+zBzfHyrAgxBhp6S22aNy822/WoMkxVhl1jMz
         q8lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JxvBCwtXVXA51PB27K0Ro1MmZW49I6nP4/hLBFQaZd8=;
        b=6/P/V/PwK3LdBfZ701Cx8XMgHh39Um/Li/gdusb29/9k1oYSsUxswsUMe5dB/ZmPLj
         KsmkEwgQZiAJ29cjQMgcGsMEv5q8TWPISN98lMEaYTtphttVwiTwcIqKtjPERFvxbY5u
         Gq/xhL6W0521mqi/P3YuyFAjSoszHYh9avTupv+gl+FHxrjX2ThcEQrBqHv0gGQjpiER
         3lDGW0A8cAtVeI+9xB5G/6Af9zmxOfiHgbhr0vEBHapDTRx81ZmJJWNx0WvXy6aEDcm6
         xrXMcsck0EtQPuFieLfeaPgcK/wL0BwM52LU8hca4qIHB/7PlGsYMHFOZGjr2n0R8HP/
         C+fw==
X-Gm-Message-State: AOAM532URXrgZ36jVmkAONmoQRPUx1/xOrjV9vy6jtE/gbh3sRe2Q08q
        iSyaH7b/RoEmbpUFJoY/lbw=
X-Google-Smtp-Source: ABdhPJx8XaLDNsJvZj4imt4IzENs57wp69x8BY7X9LPY6E4e/5R+YYtvVLv+POy+ouW19wV3U6I73A==
X-Received: by 2002:a17:906:4301:: with SMTP id j1mr56868762ejm.551.1635977350532;
        Wed, 03 Nov 2021 15:09:10 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3800:dd98:1fb5:16b3:cb28? ([2a04:241e:501:3800:dd98:1fb5:16b3:cb28])
        by smtp.gmail.com with ESMTPSA id bw25sm1772870ejb.20.2021.11.03.15.09.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 15:09:10 -0700 (PDT)
Subject: Re: [PATCH v2 12/25] tcp: ipv6: Add AO signing for
 tcp_v6_send_response
To:     David Ahern <dsahern@gmail.com>
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
        linux-kernel@vger.kernel.org,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
References: <cover.1635784253.git.cdleonard@gmail.com>
 <f9ff27ecc4aabd8ed89d5dfe5195c9cda1e7dc9f.1635784253.git.cdleonard@gmail.com>
 <37c1a2c7-3bfa-d36d-075f-a0065b8a05c1@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <cfa350ef-1051-3793-503b-0163bb600c3f@gmail.com>
Date:   Thu, 4 Nov 2021 00:09:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <37c1a2c7-3bfa-d36d-075f-a0065b8a05c1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/21 4:44 AM, David Ahern wrote:
> On 11/1/21 10:34 AM, Leonard Crestez wrote:
>> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
>> index 96a29caf56c7..68f9545e4347 100644
>> --- a/net/ipv6/tcp_ipv6.c
>> +++ b/net/ipv6/tcp_ipv6.c
>> @@ -902,13 +902,37 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
>>   	struct sock *ctl_sk = net->ipv6.tcp_sk;
>>   	unsigned int tot_len = sizeof(struct tcphdr);
>>   	__be32 mrst = 0, *topt;
>>   	struct dst_entry *dst;
>>   	__u32 mark = 0;
>> +#ifdef CONFIG_TCP_AUTHOPT
>> +	struct tcp_authopt_info *authopt_info = NULL;
>> +	struct tcp_authopt_key_info *authopt_key_info = NULL;
>> +	u8 authopt_rnextkeyid;
>> +#endif
>>   
>>   	if (tsecr)
>>   		tot_len += TCPOLEN_TSTAMP_ALIGNED;
>> +#ifdef CONFIG_TCP_AUTHOPT
> 
> I realize MD5 is done this way, but new code can always strive to be
> better. Put this and the one below in helpers such that this logic is in
> the authopt.h file and the intrusion here is a one liner that either
> compiles in or out based on the config setting.

It's not very easy to separate the AO-specific parts here. Key lookup 
determines packet allocation length and whether MD5 should also be 
attempted (RFC claims adding both is invalid). The result of the key 
lookup is the used later to sign bits of the packet.

The IPv4 equivalent is even worse because no explicit reply SKB is 
allocated.

I can try to split tcp_authopt_pick_key_for_response_v6 and 
tcp_authopt_sign_response_v6.

>> +	/* Key lookup before SKB allocation */
>> +	if (static_branch_unlikely(&tcp_authopt_needed) && sk) {
>> +		if (sk->sk_state == TCP_TIME_WAIT)
>> +			authopt_info = tcp_twsk(sk)->tw_authopt_info;
>> +		else
>> +			authopt_info = rcu_dereference(tcp_sk(sk)->authopt_info);
>> +
>> +		if (authopt_info) {
>> +			authopt_key_info = __tcp_authopt_select_key(sk, authopt_info, sk,
>> +								    &authopt_rnextkeyid);
>> +			if (authopt_key_info) {
>> +				tot_len += TCPOLEN_AUTHOPT_OUTPUT;
>> +				/* Don't use MD5 */
>> +				key = NULL;
>> +			}
>> +		}
>> +	}
>> +#endif
>>   #ifdef CONFIG_TCP_MD5SIG
>>   	if (key)
>>   		tot_len += TCPOLEN_MD5SIG_ALIGNED;
>>   #endif
>>   
>> @@ -961,10 +985,24 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
>>   		tcp_v6_md5_hash_hdr((__u8 *)topt, key,
>>   				    &ipv6_hdr(skb)->saddr,
>>   				    &ipv6_hdr(skb)->daddr, t1);
>>   	}
>>   #endif
>> +#ifdef CONFIG_TCP_AUTHOPT
>> +	/* Compute the TCP-AO mac. Unlike in the ipv4 case we have a real SKB */
>> +	if (static_branch_unlikely(&tcp_authopt_needed) && authopt_key_info) {
>> +		*topt++ = htonl((TCPOPT_AUTHOPT << 24) |
>> +				(TCPOLEN_AUTHOPT_OUTPUT << 16) |
>> +				(authopt_key_info->send_id << 8) |
>> +				(authopt_rnextkeyid));
>> +		tcp_authopt_hash((char *)topt,
>> +				 authopt_key_info,
>> +				 authopt_info,
>> +				 (struct sock *)sk,
>> +				 buff);
>> +	}
>> +#endif
>>   
>>   	memset(&fl6, 0, sizeof(fl6));
>>   	fl6.daddr = ipv6_hdr(skb)->saddr;
>>   	fl6.saddr = ipv6_hdr(skb)->daddr;
>>   	fl6.flowlabel = label;
>>
> 

