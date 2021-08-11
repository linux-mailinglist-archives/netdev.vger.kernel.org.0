Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182423E9857
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 21:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhHKTJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 15:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhHKTJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 15:09:26 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63194C061765;
        Wed, 11 Aug 2021 12:09:02 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id bo19so5294655edb.9;
        Wed, 11 Aug 2021 12:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/kx99l4AFREz6kWtSe9Q0SS4hFkwUFel+RKAC9QtMoo=;
        b=FraEamM/2irn/3FwdHRonPpAyqpBozB2aShfvrFtpJgDVkgT0jP742F/xL1whVNt8+
         +hEnpthv1sdtAbZ4wxtXoaSrYeIjHwMO/94o8SYzZr6NEs1gPYvTDkGRkN3SqV9BJlay
         k37WwgYRCiUry6CY5SkJehxa/LYyIvFTiHOB27EtMekizRwv8Vz8bjsmbAnPW8T16TZ3
         /BW5c2hn260Y6GeR9OAwAOS8kCDV2muCgWdP14sskdK8MPPW7z6QDHSkDK7i/uhgMbjF
         YIMwApRYJZQfsd8J1OOzkBPFOyG0DUWT6szlnRWKBwL2qS6qdsecyd2664KRHbwEK0BM
         3xkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/kx99l4AFREz6kWtSe9Q0SS4hFkwUFel+RKAC9QtMoo=;
        b=rGH7HIrQXRMF4/coQ/BS5WikKbyD7u1Lp5PTi8TTQcRfCoyYfOdpR0HXIiBpdprxeH
         PYiT+eP3ohnNlAZanUJ3BKoNqd+VRDBtSbxWYZHvbxfE6VfzxSybsr/KQ6Tg+YOa01pH
         VgSa7P5QKvEq8vHAVrvETJcecGuXUFeK08jd0MKVydAHrRQiqF4HcEYqKoCTkq0vElfn
         P5hRmwCUOaU2sqmZqaqO+eRVeZ30aAAmHZZI5PGMsM64lCwpyTsG6x/l1QfY12ecUJJ8
         2jhV43czbFgbf9xLOC+Z7TyvIVcvh2VmCJnBwEMVTrQkg3xrybbPjIEhMv+d6+qCtLUo
         GptA==
X-Gm-Message-State: AOAM533chReNKlj2QZGTQa9iyUaRMTdRig8NgSqxlyVsoKTcu9NYYqeI
        266VQflk8vHu0rJ1Kif+iYA=
X-Google-Smtp-Source: ABdhPJxiLXCb7e9rw5zJfAOg0IgJGT1m8l2QjGXe1StGYsjdZc6FYZznaZTEVN7VjSI9Od9COnyUpg==
X-Received: by 2002:a05:6402:202:: with SMTP id t2mr529833edv.116.1628708940905;
        Wed, 11 Aug 2021 12:09:00 -0700 (PDT)
Received: from ?IPv6:2a04:241e:502:1d80:48ac:8fee:19a2:adc6? ([2a04:241e:502:1d80:48ac:8fee:19a2:adc6])
        by smtp.gmail.com with ESMTPSA id p3sm100314ejy.20.2021.08.11.12.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 12:09:00 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
Subject: Re: [RFCv2 1/9] tcp: authopt: Initial support and key management
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Leonard Crestez <cdleonard@gmail.com>,
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
        open list <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        Dmitry Safonov <dima@arista.com>
References: <cover.1628544649.git.cdleonard@gmail.com>
 <67c1471683200188b96a3f712dd2e8def7978462.1628544649.git.cdleonard@gmail.com>
 <CAJwJo6aicw_KGQSM5U1=0X11QfuNf2dMATErSymytmpf75W=tA@mail.gmail.com>
 <1e2848fb-1538-94aa-0431-636fa314a36d@gmail.com>
 <68749e37-8e29-7a51-2186-7692f5fd6a79@gmail.com>
Message-ID: <44e5ae2b-0a9c-b5bc-19d2-f037de061944@gmail.com>
Date:   Wed, 11 Aug 2021 22:08:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <68749e37-8e29-7a51-2186-7692f5fd6a79@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.08.2021 17:31, Dmitry Safonov wrote:
> On 8/11/21 9:29 AM, Leonard Crestez wrote:
>> On 8/10/21 11:41 PM, Dmitry Safonov wrote:
>>> I wonder if it's also worth saving some bytes by something like
>>> struct tcp_ao_key *key;
>>>
>>> With
>>> struct tcp_ao_key {
>>>         u8 keylen;
>>>         u8 key[0];
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
>          key_info = __tcp_authopt_key_info_lookup(sk, info, opt.local_id);
>          if (key_info)
>                  tcp_authopt_key_del(sk, info, key_info);
> +
> +       key = sock_kmalloc(sk, sizeof(*key) + opt.keylen, GFP_KERNEL |
> __GFP_ZERO);
> +       if (!key) {
> +               tcp_authopt_alg_release(alg);
> +               return -ENOMEM;
> +       }
> +
>          key_info = sock_kmalloc(sk, sizeof(*key_info), GFP_KERNEL |
> __GFP_ZERO);
>          if (!key_info) {
> +               sock_kfree_s(sk, key, sizeof(*key) + opt.keylen);
>                  tcp_authopt_alg_release(alg);
>                  return -ENOMEM;
>          }
> 
> I don't know, probably it'll be enough for every user to limit their
> keys by length of 80, but if one day it won't be enough - this ABI will
> be painful to extend.

struct tcp_authopt_key also needs to be modified and a separate 
copy_from_user is required. It's not very complicated but not very 
useful either.

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

My idea was that each additional binding featurs can be added as a new 
bit flag in tcp_authopt_key_flag and the structure extended. Older 
applications won't pass the flag and kernel will silently accept the 
shorter optval and you get compatibility.

As far as I can tell MD5 supports binding in 3 ways:

1) By dst ip address
2) By dst ip address and prefixlen
3) By ifindex for vrfs

Current version of tcp_authopt only supports (1) but I think adding the 
other methods isn't actually difficult at all.

I'd rather not guess at future features by adding unused fields.

>>> The same is about key: I don't think you need to define/use
>>> tcp_authopt_alg.
>>> Just use algo name - that way TCP-AO will automatically be able to use
>>> any algo supported by crypto engine.
>>> See how xfrm does it, e.g.:
>>> struct xfrm_algo_auth {
>>>       char        alg_name[64];
>>>       unsigned int    alg_key_len;    /* in bits */
>>>       unsigned int    alg_trunc_len;  /* in bits */
>>>       char        alg_key[0];
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

The TCP Authentication Option standard has been out there for many many 
years now and alternative algorithms are not widely used. I think cisco 
has a third algorithm? What you're asking for is a large extension of 
the IETF standard.

If you look at the rest of this series I had a lot of trouble with 
crypto tfm allocation context so I had to create per-cpu pool, similar 
to tcp-md5. Should I potentially create a pool for each alg known to 
crypto-api?

Letting use control algorithms and traffickey and mac lengths creates 
new potential avenues for privilege escalation that need to be checked.

As much as possible I would like to avoid exposing the linux crypto api 
through TCP sockopts.

I was also thinking of having a non-namespaced sysctl to disable 
tcp_authopt by default for security reasons. Unless you're running a 
router you should never let userspace touch these options.

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
>>>       return -EINVAL;
>>
>> Purpose is to allow sockopts to grow as md5 has grown.
> 
> md5 has not grown. See above.
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

Userspace that needs new features and also compatibility with older 
kernels could check something like uname.

I think this is already a problem with md5: passing 
TCP_MD5SIG_FLAG_PREFIX on an old kernel simply won't take effect and 
that's fine.

The bigger concern is to ensure that old binaries work without changes.

> Which also reminds me that currently you don't validate (opt.flags) for
> unknown by kernel flags.

Not sure what you mean, it is explicitly only known flags that are 
copied from userspace. I can make setsockopt return an error on unknown 
flags, this will make new apps fail more explicitly on old kernels.

> Extending syscalls is impossible without breaking userspace if ABI is
> not designed with extensibility in mind. That was quite a big problem,
> and still is. Please, read this carefully:
> https://lwn.net/Articles/830666/
> 
> That is why I'm suggesting you all those changes that will be harder to
> fix when/if your patches get accepted.

Both of the sockopt structs have a "flags" field and structure expansion 
will be accompanied by new flags. Is this not sufficient for compatibility?
