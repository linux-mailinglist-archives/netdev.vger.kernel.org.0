Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60FD3E96A0
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 19:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhHKRQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 13:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhHKRQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 13:16:20 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9CCC061765;
        Wed, 11 Aug 2021 10:15:56 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id o20so5568380oiw.12;
        Wed, 11 Aug 2021 10:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+9podQWg+m5HXQLNwUqm5tHEjMFqWq+mY/UarGP+rog=;
        b=lXIkaOv7aXlvMYIqyyt+DqNywuGSpG2oPZ/gIFm/4snjIEGqfS4B/vVgDCAlWxT5/c
         BpEAXXaj1X2kfY6sRXLqkK9f8bUaV+ZJ999OADPPwa69lGmpkXxlDd/HECkL0d/T0zAQ
         xzN004asg24vLKdAPV8a7i4YQjYluBGuSUEpqvJWf8JX1SePzpF/dMV1+9GWEfPeQHz5
         yZvFjN5vbqijsJywjph81L38O3X+fkYZOkTLnXEkjZZ0W9pzL5PvhHeTiRM061TQ/mJj
         R3z+eC2FHFiD4WD+qeamr21lKeLRXredBVnrbgqd2H7fb7GLZ+0N+qAAnaSgCbi/vPfN
         ez1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+9podQWg+m5HXQLNwUqm5tHEjMFqWq+mY/UarGP+rog=;
        b=U6vdbUie0+saYclLWi/+aiwm+pvakJxDxFQJ4fEEJcBjF3MB74Iew2iUcVmlIrWzfQ
         s4fWS6KAZYCPD8YG6p2yH2rqz6HnuRKRDFYELVpKhuAeD1egtoe1VNl+3P2kfaiO3VB5
         brkOGifg21/NUctTywn83Tnaga8i5XqnkgqcC7G1oz8nZBJ0erHEhr7RddvpZnjU4DHV
         4C6Mb9ZqznDJ3L0py/oW13IQxUIkqiBJECWhaQbY3MGU15+ahZNle+wA5jc4c8+FqFP6
         QpX+Pv3IpYgJJv+cAUm+nkmpnqZxWm/+iGulgWjmMh4E33X+9Jbj6EKgImj0FGeHzBHI
         bhZg==
X-Gm-Message-State: AOAM530zqQIjjql23ed1RQiWICSWdTkz65BtkNeuz4SrZTa35T3RMAlK
        bNTslXyWk+QbuBxQ7nj6Cf4=
X-Google-Smtp-Source: ABdhPJxLuvNReubakhJ0DgRoKn9vaibit5YyOvKEMAAH2sy+rf9Y3qE0TSm4vbZKt04citISRrKs7w==
X-Received: by 2002:a54:4406:: with SMTP id k6mr7081131oiw.179.1628702155512;
        Wed, 11 Aug 2021 10:15:55 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id i8sm5360otk.51.2021.08.11.10.15.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 10:15:54 -0700 (PDT)
Subject: Re: [RFCv2 1/9] tcp: authopt: Initial support and key management
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Leonard Crestez <cdleonard@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        open list <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        Dmitry Safonov <dima@arista.com>
References: <cover.1628544649.git.cdleonard@gmail.com>
 <67c1471683200188b96a3f712dd2e8def7978462.1628544649.git.cdleonard@gmail.com>
 <CAJwJo6aicw_KGQSM5U1=0X11QfuNf2dMATErSymytmpf75W=tA@mail.gmail.com>
 <1e2848fb-1538-94aa-0431-636fa314a36d@gmail.com>
 <68749e37-8e29-7a51-2186-7692f5fd6a79@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ac911d47-eef7-c97b-9a77-f386546b56e8@gmail.com>
Date:   Wed, 11 Aug 2021 11:15:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <68749e37-8e29-7a51-2186-7692f5fd6a79@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/21 8:31 AM, Dmitry Safonov wrote:
> On 8/11/21 9:29 AM, Leonard Crestez wrote:
>> On 8/10/21 11:41 PM, Dmitry Safonov wrote:
> [..]
>>>> +       u32 flags;
>>>> +       /* Wire identifiers */
>>>> +       u8 send_id, recv_id;
>>>> +       u8 alg_id;
>>>> +       u8 keylen;
>>>> +       u8 key[TCP_AUTHOPT_MAXKEYLEN];
>>>> +       struct rcu_head rcu;
>>>
>>> This is unaligned and will add padding.
>>
>> Not clear padding matters. Moving rcu_head higher would avoid it, is
>> that what you're suggesting.
> 
> Yes.
> 
>>> I wonder if it's also worth saving some bytes by something like
>>> struct tcp_ao_key *key;
>>>
>>> With
>>> struct tcp_ao_key {
>>>        u8 keylen;
>>>        u8 key[0];
>>> };
>>>
>>> Hmm?
>>
>> This increases memory management complexity for very minor gains. Very
>> few tcp_authopt_key will ever be created.
> 
> The change doesn't seem to be big, like:
> --- a/net/ipv4/tcp_authopt.c
> +++ b/net/ipv4/tcp_authopt.c
> @@ -422,8 +422,16 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t
> optval, unsig>
>         key_info = __tcp_authopt_key_info_lookup(sk, info, opt.local_id);
>         if (key_info)
>                 tcp_authopt_key_del(sk, info, key_info);
> +
> +       key = sock_kmalloc(sk, sizeof(*key) + opt.keylen, GFP_KERNEL |
> __GFP_ZERO);
> +       if (!key) {
> +               tcp_authopt_alg_release(alg);
> +               return -ENOMEM;
> +       }
> +
>         key_info = sock_kmalloc(sk, sizeof(*key_info), GFP_KERNEL |
> __GFP_ZERO);
>         if (!key_info) {
> +               sock_kfree_s(sk, key, sizeof(*key) + opt.keylen);
>                 tcp_authopt_alg_release(alg);
>                 return -ENOMEM;
>         }
> 
> I don't know, probably it'll be enough for every user to limit their
> keys by length of 80, but if one day it won't be enough - this ABI will
> be painful to extend.
> 
> [..]
>>>> +#define TCP_AUTHOPT                    38      /* TCP Authentication
>>>> Option (RFC2385) */
>>>> +#define TCP_AUTHOPT_KEY                39      /* TCP Authentication
>>>> Option update key (RFC2385) */
>>>
>>> RFC2385 is md5 one.
>>> Also, should there be TCP_AUTHOPT_ADD_KEY, TCP_AUTHOPT_DELTE_KEY
>>> instead of using flags inside setsocketopt()? (no hard feelings)
>>
>> Fixed RFC reference.
>>
>> TCP_AUTHOPT_DELETE_KEY could be clearer, I just wanted to avoid bloating
>> the sockopt space. But there's not any scarcity.
>>
>> For reference tcp_md5 handles key deletion based on keylen == 0. This
>> seems wrong to me, an empty key is in fact valid though not realistic.
>>
>> If local_id is removed in favor of "full match on id and binding" then
>> the delete sockopt would still need most of a full struct
>> tcp_authopt_key anyway.
> 
> Sounds like a plan.
> 
> [..]>> I'm not sure what's the use of enum here, probably: > #define
>>> TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED BIT(2)
>>
>> This is an enum because it looks nice in kernel-doc. I couldn't find a
>> way to attach docs to a macro and include it somewhere else.
> 
> Yeah, ok, seems like good justification.
> 
>> BTW, the enum gains more members later.
>>
>> As for BIT() it doesn't see to be allowed in uapi and there were recent
>> changes removing such usage.
> 
> Ok, I just saw it's still used in include/uapi, but not aware of the
> removal.
> 
>>
>>> [..]
>>>> +struct tcp_authopt_key {
>>>> +       /** @flags: Combination of &enum tcp_authopt_key_flag */
>>>> +       __u32   flags;
>>>> +       /** @local_id: Local identifier */
>>>> +       __u32   local_id;
>>>> +       /** @send_id: keyid value for send */
>>>> +       __u8    send_id;
>>>> +       /** @recv_id: keyid value for receive */
>>>> +       __u8    recv_id;
>>>> +       /** @alg: One of &enum tcp_authopt_alg */
>>>> +       __u8    alg;
>>>> +       /** @keylen: Length of the key buffer */
>>>> +       __u8    keylen;
>>>> +       /** @key: Secret key */
>>>> +       __u8    key[TCP_AUTHOPT_MAXKEYLEN];
>>>> +       /**
>>>> +        * @addr: Key is only valid for this address
>>>> +        *
>>>> +        * Ignored unless TCP_AUTHOPT_KEY_ADDR_BIND flag is set
>>>> +        */
>>>> +       struct __kernel_sockaddr_storage addr;
>>>> +};
>>>
>>> It'll be an ABI if this is accepted. As it is - it can't support
>>> RFC5925 fully.
>>> Extending syscall ABI is painful. I think, even the initial ABI *must*
>>> support
>>> all possible features of the RFC.
>>> In other words, there must be src_addr, src_port, dst_addr and dst_port.
>>> I can see from docs you've written you don't want to support a mix of
>>> different
>>> addr/port MKTs, so you can return -EINVAL or -ENOTSUPP for any value
>>> but zero.
>>> This will create an ABI that can be later extended to fully support RFC.
>>
>> RFC states that MKT connection identifiers can be specified using ranges
>> and wildcards and the details are up to the implementation. Keys are
>> *NOT* just bound to a classical TCP 4-tuple.
>>
>> * src_addr and src_port is implicit in socket binding. Maybe in theory
>> src_addr they could apply for a server socket bound to 0.0.0.0:PORT but
>> userspace can just open more sockets.
>> * dst_port is not supported by MD5 and I can't think of any useful
>> usecase. This is either well known (179 for BGP) or auto-allocated.
>> * tcp_md5 was recently enhanced allow a "prefixlen" for addr and
>> "l3mdev" ifindex binding.
>>
>> This last point shows that the binding features people require can't be
>> easily predicted in advance so it's better to allow the rules to be
>> extended.
> 
> Yeah, I see both changes you mention went on easy way as they reused
> existing paddings in the ABI structures.
> Ok, if you don't want to reserve src_addr/src_port/dst_addr/dst_port,
> than how about reserving some space for those instead?
> 
>>> The same is about key: I don't think you need to define/use
>>> tcp_authopt_alg.
>>> Just use algo name - that way TCP-AO will automatically be able to use
>>> any algo supported by crypto engine.
>>> See how xfrm does it, e.g.:
>>> struct xfrm_algo_auth {
>>>      char        alg_name[64];
>>>      unsigned int    alg_key_len;    /* in bits */
>>>      unsigned int    alg_trunc_len;  /* in bits */
>>>      char        alg_key[0];
>>> };
>>>
>>> So you can let a user chose maclen instead of hard-coding it.
>>> Much more extendable than what you propose.
>>
>> This complicates ABI and implementation with features that are not
>> needed. I'd much rather only expose an enum of real-world tcp-ao
>> algorithms.
> 
> I see it exactly the opposite way: a new enum unnecessary complicates
> ABI, instead of passing alg_name[] to crypto engine. No need to add any
> support in tcp-ao as the algorithms are already provided by kernel.
> That is how it transparently works for ipsec, why not for tcp-ao?
> 
>>
>>> [..]
>>>> +#ifdef CONFIG_TCP_AUTHOPT
>>>> +       case TCP_AUTHOPT: {
>>>> +               struct tcp_authopt info;
>>>> +
>>>> +               if (get_user(len, optlen))
>>>> +                       return -EFAULT;
>>>> +
>>>> +               lock_sock(sk);
>>>> +               tcp_get_authopt_val(sk, &info);
>>>> +               release_sock(sk);
>>>> +
>>>> +               len = min_t(unsigned int, len, sizeof(info));
>>>> +               if (put_user(len, optlen))
>>>> +                       return -EFAULT;
>>>> +               if (copy_to_user(optval, &info, len))
>>>> +                       return -EFAULT;
>>>> +               return 0;
>>>> +       }
>>>
>>> I'm pretty sure it's not a good choice to write partly tcp_authopt.
>>> And a user has no way to check what's the correct len on this kernel.
>>> Instead of len = min_t(unsigned int, len, sizeof(info)), it should be
>>> if (len != sizeof(info))
>>>      return -EINVAL;
>>
>> Purpose is to allow sockopts to grow as md5 has grown.
> 
> md5 has not grown. See above.

MD5 uapi has - e.g., 8917a777be3ba and  6b102db50cdde. We want similar
capabilities for growth with this API.

> 
> Another issue with your approach
> 
> +       /* If userspace optlen is too short fill the rest with zeros */
> +       if (optlen > sizeof(opt))
> +               return -EINVAL;
> +       memset(&opt, 0, sizeof(opt));
> +       if (copy_from_sockptr(&opt, optval, optlen))
> +               return -EFAULT;
> 
> is that userspace compiled with updated/grew structure will fail on
> older kernel. So, no extension without breaking something is possible.
> Which also reminds me that currently you don't validate (opt.flags) for
> unknown by kernel flags.
> 
> Extending syscalls is impossible without breaking userspace if ABI is
> not designed with extensibility in mind. That was quite a big problem,
> and still is. Please, read this carefully:
> https://lwn.net/Articles/830666/
> 
> That is why I'm suggesting you all those changes that will be harder to
> fix when/if your patches get accepted.
> As an example how it should work see in copy_clone_args_from_user().
> 

Look at how TCP_ZEROCOPY_RECEIVE has grown over releases as an example
of how to properly handle this.

