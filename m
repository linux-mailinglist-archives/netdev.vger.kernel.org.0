Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591B8210AF3
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 14:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbgGAMTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 08:19:46 -0400
Received: from mail.efficios.com ([167.114.26.124]:50208 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730063AbgGAMTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 08:19:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id A354A2CD6E7;
        Wed,  1 Jul 2020 08:19:42 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 2FJk1-xrNm4E; Wed,  1 Jul 2020 08:19:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 4A8AD2CD572;
        Wed,  1 Jul 2020 08:19:42 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 4A8AD2CD572
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1593605982;
        bh=YXoF5PUmxWXzp2LmHg4Wgh13FE3P4zYYtwXrHzfqq3Y=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=sG39cyUal96uC6mVyehepRr4pm1czvIHFsUGOd53n/dOX2qwq+HAY1AYOll43FKKK
         aLuZoGCMngJoRBScUGKntC5NT2sInb2Eh8EG2FT8QXfZVR4/kojqte6y6KA83fzKVL
         WFgTHC3EULUyItFTiDhFMGZgVgN9jjWwoNoge6dDRMkSxcq/587EsdxMPEJi9RtYul
         PPSZGqHYpt3+gngE0EmiaxVZr6Gx1mJQeLWvBcW2zWhTOWd/bZ9RyHfuA9YUMzNiNU
         nW+fcJm7c+MLyrTZaCM/0+juW8g5yPVmeI9N43OiiPOGCGvDyxqG6ceJ2/RfFq/OlS
         K5lGL6JG5BUow==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 8b3X4FPEW-Fj; Wed,  1 Jul 2020 08:19:42 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 3BB862CD987;
        Wed,  1 Jul 2020 08:19:42 -0400 (EDT)
Date:   Wed, 1 Jul 2020 08:19:42 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Message-ID: <338284155.18826.1593605982156.JavaMail.zimbra@efficios.com>
In-Reply-To: <CANn89iKnf6=RFd-XRjPv=qaU8P-LGCBcw6JU5Ywwb16gU2iQqQ@mail.gmail.com>
References: <CANn89iLPqtJG0iESCHF+RcOjo95ukan1oSzjkPjoSJgKpO2wSQ@mail.gmail.com> <20200701020211.GA6875@gondor.apana.org.au> <CANn89iKP-evuLxeLo6p_98T+FuJ-J5YaMTRG230nqj3R=43tVA@mail.gmail.com> <20200701022241.GA7167@gondor.apana.org.au> <CANn89iLKZQAtpejcLHmOu3dsrGf5eyFfHc8JqoMNYisRPWQ8kQ@mail.gmail.com> <20200701025843.GA7254@gondor.apana.org.au> <CANn89iKnf6=RFd-XRjPv=qaU8P-LGCBcw6JU5Ywwb16gU2iQqQ@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3945 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3928)
Thread-Topic: TCP_MD5SIG on established sockets
Thread-Index: DVmdKoIdfg8hNWwm7FgIos17cuNI0g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jun 30, 2020, at 11:36 PM, Eric Dumazet edumazet@google.com wrote:

> On Tue, Jun 30, 2020 at 7:59 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>
>> On Tue, Jun 30, 2020 at 07:30:43PM -0700, Eric Dumazet wrote:
>> >
>> > I made this clear in the changelog, do we want comments all over the places ?
>> > Do not get me wrong, we had this bug for years and suddenly this is a
>> > big deal...
>>
>> I thought you were adding a new pair of smp_rmb/smp_wmb.  If they
>> already exist in the code then I agree it's not a big deal.  But
>> adding a new pair of bogus smp_Xmb's is bad for maintenance.
>>
> 
> If I knew so many people were excited about TCP / MD5, I would have
> posted all my patches on lkml ;)
> 
> Without the smp_wmb() we would still need something to prevent KMSAN
> from detecting that we read uninitialized bytes,
> if key->keylen is increased.  (initial content of key->key[] is garbage)
> 
> Something like this :

The approach below looks good to me, but you'll also need to annotate
both tcp_md5_hash_key and tcp_md5_do_add with __no_kcsan or use
data_race(expr) to let the concurrency sanitizer know that there is
a known data race which is there on purpose (triggered by memcpy in tcp_md5_do_add
and somewhere within crypto_ahash_update). See Documentation/dev-tools/kcsan.rst
for details.

Thanks,

Mathieu

> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index
> f111660453241692a17c881dd6dc2910a1236263..c3af8180c7049d5c4987bf5c67e4aff2ed6967c9
> 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4033,11 +4033,9 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
> 
> int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct
> tcp_md5sig_key *key)
> {
> -       u8 keylen = key->keylen;
> +       u8 keylen = READ_ONCE(key->keylen); /* paired with
> WRITE_ONCE() in tcp_md5_do_add */
>        struct scatterlist sg;
> 
> -       smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
> -
>        sg_init_one(&sg, key->key, keylen);
>        ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
>        return crypto_ahash_update(hp->md5_req);
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index
> 99916fcc15ca0be12c2c133ff40516f79e6fdf7f..0d08e0134335a21d23702e6a5c24a0f2b3c61c6f
> 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1114,9 +1114,13 @@ int tcp_md5_do_add(struct sock *sk, const union
> tcp_md5_addr *addr,
>                /* Pre-existing entry - just update that one. */
>                memcpy(key->key, newkey, newkeylen);
> 
> -               smp_wmb(); /* pairs with smp_rmb() in tcp_md5_hash_key() */
> +               /* Pairs with READ_ONCE() in tcp_md5_hash_key().
> +                * Also note that a reader could catch new key->keylen value
> +                * but old key->key[], this is the reason we use __GFP_ZERO
> +                * at sock_kmalloc() time below these lines.
> +                */
> +               WRITE_ONCE(key->keylen, newkeylen);
> 
> -               key->keylen = newkeylen;
>                return 0;
>        }
> 
> @@ -1132,7 +1136,7 @@ int tcp_md5_do_add(struct sock *sk, const union
> tcp_md5_addr *addr,
>                rcu_assign_pointer(tp->md5sig_info, md5sig);
>        }
> 
> -       key = sock_kmalloc(sk, sizeof(*key), gfp);
> +       key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
>        if (!key)
>                return -ENOMEM;
>         if (!tcp_alloc_md5sig_pool()) {

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
