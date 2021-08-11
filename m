Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8B23E8BCF
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 10:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbhHKI3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 04:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbhHKI3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 04:29:32 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB36DC061765;
        Wed, 11 Aug 2021 01:29:08 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id u3so2725417ejz.1;
        Wed, 11 Aug 2021 01:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NntPd5X42amzQgNYocL1DyskN8Znm7XmJf8O1MQKlFk=;
        b=puS97pwVJK9szTxhHHdqW5H5AMYKK5EvyrkyZzrinlN0N1QExCk8kcpu5ZrxfTAkpp
         BarGuBFJxqyAkq4q5ERQmQQMGG3hbmMZD1o2fw4KbvrCj4HmpGy9j694CLjBXntqUZJ0
         IBUznLFGXZyNm7+bp4/oFGlipDRBCNKCxcatgUbg+ra3RDorHWtVWHD8MaXktMt0zEDV
         MnOCwZ+HFXkas7R9nEusK27Q242WsKrISuziRwO52BOBVcuWAqq9RhouiYOQ1yEiavFK
         BqQ1ZGdB/JNrJkweV1WMyammEZlrNrNTMCPz10UmnMutFDN/50SIhMosGG9NgdzZw1i9
         dF3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NntPd5X42amzQgNYocL1DyskN8Znm7XmJf8O1MQKlFk=;
        b=amemCbg5Sdrz6a2y3DoBz+Fo1JpgbQSCWXl8Vib96c53Kh6ZPCnc+VIMiZxjSbfaJC
         pTv7GfxoVHrs8a6igJNpZFmQfeEmf0W19DCVPfoiS6WvgelEh1Qn9b9Dol4G8muwI3lY
         nAKmX4MtYEZjJZF4qk54efBrSHV2n7W6SNhn3iYD7zHVDAdfRTD2Lr3wLDdmi5mAMpRj
         mwXUrbBmLOhHmEwWN0P4pcgdjyLGR7TBGccm7KNEEucbpuTCJt2wiOLIXm0eJgIBy6BE
         sjIt9J1vCFhKDbXo6gUqpYdDIFRvwkV96HYSfJsh0smpuDQxscknT38A76HkxfueKFYN
         182w==
X-Gm-Message-State: AOAM532CjN/NbaYiPn3IfMv4q13Vvx5hIdmte5rqj+zm/f2iDoTyVdeN
        rtOWA5Nf0Qcb1+Ju//Xccy8=
X-Google-Smtp-Source: ABdhPJzWg2HcDE/dGBSWo2RTlMyD/QNjMkiKWNZYelipkDY4wBONNNV7zxIoRQEah5mq2ah8HgUm3A==
X-Received: by 2002:a17:906:c006:: with SMTP id e6mr2552207ejz.510.1628670547121;
        Wed, 11 Aug 2021 01:29:07 -0700 (PDT)
Received: from ?IPv6:2a04:241e:502:1d80:3c60:dccf:9a8c:741b? ([2a04:241e:502:1d80:3c60:dccf:9a8c:741b])
        by smtp.gmail.com with ESMTPSA id cn28sm4895147edb.18.2021.08.11.01.29.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 01:29:06 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
Subject: Re: [RFCv2 1/9] tcp: authopt: Initial support and key management
To:     Dmitry Safonov <0x7f454c46@gmail.com>
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
Message-ID: <1e2848fb-1538-94aa-0431-636fa314a36d@gmail.com>
Date:   Wed, 11 Aug 2021 11:29:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAJwJo6aicw_KGQSM5U1=0X11QfuNf2dMATErSymytmpf75W=tA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/10/21 11:41 PM, Dmitry Safonov wrote:
> Hi Leonard,
> 
> On Tue, 10 Aug 2021 at 02:50, Leonard Crestez <cdleonard@gmail.com> wrote:
> [..]
>> +/* Representation of a Master Key Tuple as per RFC5925 */
>> +struct tcp_authopt_key_info {
>> +       struct hlist_node node;
>> +       /* Local identifier */
>> +       u32 local_id;
> 
> There is no local_id in RFC5925, what's that?
> An MKT is identified by (send_id, recv_id), together with
> (src_addr/src_port, dst_addr/dst_port).
> Why introducing something new to already complicated RFC?

It was there to simplify user interface and initial implementation.

But it seems that BGP listeners already needs to support multiple 
keychains for different peers so identifying the key by (send_id, 
recv_id, binding) is easier for userspace to work with. Otherwise they 
need to create their own local_id mapping internally.

>> +       u32 flags;
>> +       /* Wire identifiers */
>> +       u8 send_id, recv_id;
>> +       u8 alg_id;
>> +       u8 keylen;
>> +       u8 key[TCP_AUTHOPT_MAXKEYLEN];
>> +       struct rcu_head rcu;
> 
> This is unaligned and will add padding.

Not clear padding matters. Moving rcu_head higher would avoid it, is 
that what you're suggesting.

> I wonder if it's also worth saving some bytes by something like
> struct tcp_ao_key *key;
> 
> With
> struct tcp_ao_key {
>        u8 keylen;
>        u8 key[0];
> };
> 
> Hmm?

This increases memory management complexity for very minor gains. Very 
few tcp_authopt_key will ever be created.

>> +       struct sockaddr_storage addr;
>> +};
>> +
>> +/* Per-socket information regarding tcp_authopt */
>> +struct tcp_authopt_info {
>> +       /* List of tcp_authopt_key_info */
>> +       struct hlist_head head;
>> +       u32 flags;
>> +       u32 src_isn;
>> +       u32 dst_isn;
>> +       struct rcu_head rcu;
> 
> Ditto, adds padding on 64-bit.
> 
> [..]
>> +++ b/include/uapi/linux/tcp.h
>> @@ -126,10 +126,12 @@ enum {
>>   #define TCP_INQ                        36      /* Notify bytes available to read as a cmsg on read */
>>
>>   #define TCP_CM_INQ             TCP_INQ
>>
>>   #define TCP_TX_DELAY           37      /* delay outgoing packets by XX usec */
>> +#define TCP_AUTHOPT                    38      /* TCP Authentication Option (RFC2385) */
>> +#define TCP_AUTHOPT_KEY                39      /* TCP Authentication Option update key (RFC2385) */
> 
> RFC2385 is md5 one.
> Also, should there be TCP_AUTHOPT_ADD_KEY, TCP_AUTHOPT_DELTE_KEY
> instead of using flags inside setsocketopt()? (no hard feelings)

Fixed RFC reference.

TCP_AUTHOPT_DELETE_KEY could be clearer, I just wanted to avoid bloating 
the sockopt space. But there's not any scarcity.

For reference tcp_md5 handles key deletion based on keylen == 0. This 
seems wrong to me, an empty key is in fact valid though not realistic.

If local_id is removed in favor of "full match on id and binding" then 
the delete sockopt would still need most of a full struct 
tcp_authopt_key anyway.

> [..]
>> +/**
>> + * enum tcp_authopt_flag - flags for `tcp_authopt.flags`
>> + */
>> +enum tcp_authopt_flag {
>> +       /**
>> +        * @TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED:
>> +        *      Configure behavior of segments with TCP-AO coming from hosts for which no
>> +        *      key is configured. The default recommended by RFC is to silently accept
>> +        *      such connections.
>> +        */
>> +       TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED = (1 << 2),
>> +};
>> +
>> +/**
>> + * struct tcp_authopt - Per-socket options related to TCP Authentication Option
>> + */
>> +struct tcp_authopt {
>> +       /** @flags: Combination of &enum tcp_authopt_flag */
>> +       __u32   flags;
>> +};
> 
> I'm not sure what's the use of enum here, probably: > #define TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED BIT(2)

This is an enum because it looks nice in kernel-doc. I couldn't find a 
way to attach docs to a macro and include it somewhere else. BTW, the 
enum gains more members later.

As for BIT() it doesn't see to be allowed in uapi and there were recent 
changes removing such usage.

> [..]
>> +struct tcp_authopt_key {
>> +       /** @flags: Combination of &enum tcp_authopt_key_flag */
>> +       __u32   flags;
>> +       /** @local_id: Local identifier */
>> +       __u32   local_id;
>> +       /** @send_id: keyid value for send */
>> +       __u8    send_id;
>> +       /** @recv_id: keyid value for receive */
>> +       __u8    recv_id;
>> +       /** @alg: One of &enum tcp_authopt_alg */
>> +       __u8    alg;
>> +       /** @keylen: Length of the key buffer */
>> +       __u8    keylen;
>> +       /** @key: Secret key */
>> +       __u8    key[TCP_AUTHOPT_MAXKEYLEN];
>> +       /**
>> +        * @addr: Key is only valid for this address
>> +        *
>> +        * Ignored unless TCP_AUTHOPT_KEY_ADDR_BIND flag is set
>> +        */
>> +       struct __kernel_sockaddr_storage addr;
>> +};
> 
> It'll be an ABI if this is accepted. As it is - it can't support RFC5925 fully.
> Extending syscall ABI is painful. I think, even the initial ABI *must* support
> all possible features of the RFC.
> In other words, there must be src_addr, src_port, dst_addr and dst_port.
> I can see from docs you've written you don't want to support a mix of different
> addr/port MKTs, so you can return -EINVAL or -ENOTSUPP for any value
> but zero.
> This will create an ABI that can be later extended to fully support RFC.

RFC states that MKT connection identifiers can be specified using ranges 
and wildcards and the details are up to the implementation. Keys are 
*NOT* just bound to a classical TCP 4-tuple.

* src_addr and src_port is implicit in socket binding. Maybe in theory 
src_addr they could apply for a server socket bound to 0.0.0.0:PORT but 
userspace can just open more sockets.
* dst_port is not supported by MD5 and I can't think of any useful 
usecase. This is either well known (179 for BGP) or auto-allocated.
* tcp_md5 was recently enhanced allow a "prefixlen" for addr and 
"l3mdev" ifindex binding.

This last point shows that the binding features people require can't be 
easily predicted in advance so it's better to allow the rules to be 
extended.

> The same is about key: I don't think you need to define/use tcp_authopt_alg.
> Just use algo name - that way TCP-AO will automatically be able to use
> any algo supported by crypto engine.
> See how xfrm does it, e.g.:
> struct xfrm_algo_auth {
>      char        alg_name[64];
>      unsigned int    alg_key_len;    /* in bits */
>      unsigned int    alg_trunc_len;  /* in bits */
>      char        alg_key[0];
> };
> 
> So you can let a user chose maclen instead of hard-coding it.
> Much more extendable than what you propose.

This complicates ABI and implementation with features that are not 
needed. I'd much rather only expose an enum of real-world tcp-ao algorithms.

> [..]
>> +#ifdef CONFIG_TCP_AUTHOPT
>> +       case TCP_AUTHOPT: {
>> +               struct tcp_authopt info;
>> +
>> +               if (get_user(len, optlen))
>> +                       return -EFAULT;
>> +
>> +               lock_sock(sk);
>> +               tcp_get_authopt_val(sk, &info);
>> +               release_sock(sk);
>> +
>> +               len = min_t(unsigned int, len, sizeof(info));
>> +               if (put_user(len, optlen))
>> +                       return -EFAULT;
>> +               if (copy_to_user(optval, &info, len))
>> +                       return -EFAULT;
>> +               return 0;
>> +       }
> 
> I'm pretty sure it's not a good choice to write partly tcp_authopt.
> And a user has no way to check what's the correct len on this kernel.
> Instead of len = min_t(unsigned int, len, sizeof(info)), it should be
> if (len != sizeof(info))
>      return -EINVAL;

Purpose is to allow sockopts to grow as md5 has grown.

> [..]
>> +int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
>> +{
>> +       struct tcp_authopt opt;
>> +       struct tcp_authopt_info *info;
>> +
>> +       WARN_ON(!lockdep_sock_is_held(sk));
> 
> sock_owned_by_me(sk)

Yes, this seems better. I think there are several socket locking 
mistakes in later commits. The patch adding support for detailed keyid 
control probably needs bh_lock_sock to avoid races between key selection 
and caching on send and key manipulation by userspace.

>> +       /* If userspace optlen is too short fill the rest with zeros */
>> +       if (optlen > sizeof(opt))
>> +               return -EINVAL;
>> +       memset(&opt, 0, sizeof(opt));
> 
> it's 4 bytes, why not just (optlen != sizeof(opt))?

It's extended in a later commit to add detailed keyid control.

> [..]
>> +int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
>> +{
>> +       struct tcp_sock *tp = tcp_sk(sk);
>> +       struct tcp_authopt_info *info;
>> +
>> +       WARN_ON(!lockdep_sock_is_held(sk));
> 
> sock_owned_by_me(sk)
> 
> [..]
>> +int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
>> +{
>> +       struct tcp_authopt_key opt;
>> +       struct tcp_authopt_info *info;
>> +       struct tcp_authopt_key_info *key_info;
>> +
>> +       /* If userspace optlen is too short fill the rest with zeros */
>> +       if (optlen > sizeof(opt))
>> +               return -EINVAL;
>> +       memset(&opt, 0, sizeof(opt));
>> +       if (copy_from_sockptr(&opt, optval, optlen))
>> +               return -EFAULT;
> 
> Again, not a good practice to zero-extend struct. Enforce proper size
> with -EINVAL.
> 
> [..]
>> +       /* Initialize tcp_authopt_info if not already set */
>> +       info = __tcp_authopt_info_get_or_create(sk);
>> +       if (IS_ERR(info))
>> +               return PTR_ERR(info);
>> +
>> +       /* check key family */
>> +       if (opt.flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
>> +               if (sk->sk_family != opt.addr.ss_family)
>> +                       return -EINVAL;
>> +       }
> 
> Probably, can be in the reverse order, so that
> __tcp_authopt_info_get_or_create()
> won't allocate memory.

OK. It only saves a tiny bit of memory on API misuse.

>> +       /* If an old value exists for same local_id it is deleted */
>> +       key_info = __tcp_authopt_key_info_lookup(sk, info, opt.local_id);
>> +       if (key_info)
>> +               tcp_authopt_key_del(sk, info, key_info);
>> +       key_info = sock_kmalloc(sk, sizeof(*key_info), GFP_KERNEL | __GFP_ZERO);
>> +       if (!key_info)
>> +               return -ENOMEM;
> 
> 1. You don't need sock_kmalloc() together with tcp_authopt_key_del().
>      It just frees the memory and allocates it back straight away - no
> sense in doing that.

The list is scanned in multiple places in later commits using nothing 
but an rcu_read_lock, this means that keys can't be updated in-place.

> 2. I think RFC says you must not allow a user to change an existing key:
>> MKT parameters are not changed. Instead, new MKTs can be installed, and a connection
>> can change which MKT it uses.
> 
> IIUC, it means that one can't just change an existing MKT, but one can
> remove and later
> add MKT with the same (send_id, recv_id, src_addr/port, dst_addr/port).
> 
> So, a reasonable thing to do:
> if (key_info)
>      return -EEXIST.

You're right, making the user delete keys explicitly is better.

--
Regards,
Leonard
