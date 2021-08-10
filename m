Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603633E847A
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 22:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhHJUmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 16:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhHJUmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 16:42:21 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1485C0613C1;
        Tue, 10 Aug 2021 13:41:58 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id p38so653230lfa.0;
        Tue, 10 Aug 2021 13:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nKhLAb4umTTJACgLUcsJlhO3k1D9regGXKa5BGSl818=;
        b=fgOF1ZMev8Y0rP0BhpVW3dsHB7/Tw0AGgkkBJY46myYp9c8bSH1HMExPbdSqodaKzE
         hm4QPMVka4g9g3DPkiJIVqTQayKk6AjNJKCR5YEzlTtobAEbcLCSthGcQEYeHbL+J7+f
         d+PDFaqe1u3JwiULmi3ZT4QFNxkoeEdbSDhauQ+BuGeuEBHUKjeyvQaRDIM9gytgvKGT
         Fatop+t+LhP87dkfZCff2xRiXwvLQ2WCHGc1xG3KAJPTBpNkd5cECREJ4HrG2QqzzeNK
         YgdTNVcsQiHaWoCCUh9UTHlHKDFt4OpS7vYuwecX6vpRX4jXWz5kfy2rB6a7tAvnQ14Q
         nTPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nKhLAb4umTTJACgLUcsJlhO3k1D9regGXKa5BGSl818=;
        b=AAoM1nLEH12lG9U+OnUnbtwc/v+CqZhFDSZpKZHjlx8uEWlv05v43aWd+VjTnw51Gu
         3OjRnYyr1mk3M24ZyjqQLKavnxk4ku9tq5ZP+FU976Gv1EOv+DxBDznQAniik+QgBRqt
         WABEpvAJzqjsuWah1QLq36Z9jmt5XiykQMfVLfu77VLPS8h4D1fN27Hmi1DpsSlMw/5R
         nkG4WL1L9yriUMcowptSrAiJhUmhB6qPUp8dWduaj8onTUU23HgBVZB8q7d5EpduEGWP
         jmlyAhQc3+Z8wdYpSG9lbI+bnxMhsePpCQnnMAGApTi+I0jGg/rfduoDYLQtQ7G3KTLP
         p9XA==
X-Gm-Message-State: AOAM530d43j9bbF0dCCCaaPyURtuRBU0Vlt8TovjjzmskCjYLEIA8flh
        F27OHezRwFly+ANIrhnnL8SnC0zHIPJaSLJBepM=
X-Google-Smtp-Source: ABdhPJys95T5j3RjzdvwwJQyFj9EE1L20fkOTA9YCx84H4R4EPuwZLnhlLK926/ReioWEsZuEqLKbIzxpAfhQCvrFps=
X-Received: by 2002:a05:6512:1148:: with SMTP id m8mr22563882lfg.53.1628628117045;
 Tue, 10 Aug 2021 13:41:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1628544649.git.cdleonard@gmail.com> <67c1471683200188b96a3f712dd2e8def7978462.1628544649.git.cdleonard@gmail.com>
In-Reply-To: <67c1471683200188b96a3f712dd2e8def7978462.1628544649.git.cdleonard@gmail.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
Date:   Tue, 10 Aug 2021 21:41:46 +0100
Message-ID: <CAJwJo6aicw_KGQSM5U1=0X11QfuNf2dMATErSymytmpf75W=tA@mail.gmail.com>
Subject: Re: [RFCv2 1/9] tcp: authopt: Initial support and key management
To:     Leonard Crestez <cdleonard@gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leonard,

On Tue, 10 Aug 2021 at 02:50, Leonard Crestez <cdleonard@gmail.com> wrote:
[..]
> +/* Representation of a Master Key Tuple as per RFC5925 */
> +struct tcp_authopt_key_info {
> +       struct hlist_node node;
> +       /* Local identifier */
> +       u32 local_id;

There is no local_id in RFC5925, what's that?
An MKT is identified by (send_id, recv_id), together with
(src_addr/src_port, dst_addr/dst_port).
Why introducing something new to already complicated RFC?

> +       u32 flags;
> +       /* Wire identifiers */
> +       u8 send_id, recv_id;
> +       u8 alg_id;
> +       u8 keylen;
> +       u8 key[TCP_AUTHOPT_MAXKEYLEN];
> +       struct rcu_head rcu;

This is unaligned and will add padding.
I wonder if it's also worth saving some bytes by something like
struct tcp_ao_key *key;

With
struct tcp_ao_key {
      u8 keylen;
      u8 key[0];
};

Hmm?

> +       struct sockaddr_storage addr;
> +};
> +
> +/* Per-socket information regarding tcp_authopt */
> +struct tcp_authopt_info {
> +       /* List of tcp_authopt_key_info */
> +       struct hlist_head head;
> +       u32 flags;
> +       u32 src_isn;
> +       u32 dst_isn;
> +       struct rcu_head rcu;

Ditto, adds padding on 64-bit.

[..]
> +++ b/include/uapi/linux/tcp.h
> @@ -126,10 +126,12 @@ enum {
>  #define TCP_INQ                        36      /* Notify bytes available to read as a cmsg on read */
>
>  #define TCP_CM_INQ             TCP_INQ
>
>  #define TCP_TX_DELAY           37      /* delay outgoing packets by XX usec */
> +#define TCP_AUTHOPT                    38      /* TCP Authentication Option (RFC2385) */
> +#define TCP_AUTHOPT_KEY                39      /* TCP Authentication Option update key (RFC2385) */

RFC2385 is md5 one.
Also, should there be TCP_AUTHOPT_ADD_KEY, TCP_AUTHOPT_DELTE_KEY
instead of using flags inside setsocketopt()? (no hard feelings)

[..]
> +/**
> + * enum tcp_authopt_flag - flags for `tcp_authopt.flags`
> + */
> +enum tcp_authopt_flag {
> +       /**
> +        * @TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED:
> +        *      Configure behavior of segments with TCP-AO coming from hosts for which no
> +        *      key is configured. The default recommended by RFC is to silently accept
> +        *      such connections.
> +        */
> +       TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED = (1 << 2),
> +};
> +
> +/**
> + * struct tcp_authopt - Per-socket options related to TCP Authentication Option
> + */
> +struct tcp_authopt {
> +       /** @flags: Combination of &enum tcp_authopt_flag */
> +       __u32   flags;
> +};

I'm not sure what's the use of enum here, probably:
#define TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED BIT(2)

[..]
> +struct tcp_authopt_key {
> +       /** @flags: Combination of &enum tcp_authopt_key_flag */
> +       __u32   flags;
> +       /** @local_id: Local identifier */
> +       __u32   local_id;
> +       /** @send_id: keyid value for send */
> +       __u8    send_id;
> +       /** @recv_id: keyid value for receive */
> +       __u8    recv_id;
> +       /** @alg: One of &enum tcp_authopt_alg */
> +       __u8    alg;
> +       /** @keylen: Length of the key buffer */
> +       __u8    keylen;
> +       /** @key: Secret key */
> +       __u8    key[TCP_AUTHOPT_MAXKEYLEN];
> +       /**
> +        * @addr: Key is only valid for this address
> +        *
> +        * Ignored unless TCP_AUTHOPT_KEY_ADDR_BIND flag is set
> +        */
> +       struct __kernel_sockaddr_storage addr;
> +};

It'll be an ABI if this is accepted. As it is - it can't support RFC5925 fully.
Extending syscall ABI is painful. I think, even the initial ABI *must* support
all possible features of the RFC.
In other words, there must be src_addr, src_port, dst_addr and dst_port.
I can see from docs you've written you don't want to support a mix of different
addr/port MKTs, so you can return -EINVAL or -ENOTSUPP for any value
but zero.
This will create an ABI that can be later extended to fully support RFC.

The same is about key: I don't think you need to define/use tcp_authopt_alg.
Just use algo name - that way TCP-AO will automatically be able to use
any algo supported by crypto engine.
See how xfrm does it, e.g.:
struct xfrm_algo_auth {
    char        alg_name[64];
    unsigned int    alg_key_len;    /* in bits */
    unsigned int    alg_trunc_len;  /* in bits */
    char        alg_key[0];
};

So you can let a user chose maclen instead of hard-coding it.
Much more extendable than what you propose.

[..]
> +#ifdef CONFIG_TCP_AUTHOPT
> +       case TCP_AUTHOPT: {
> +               struct tcp_authopt info;
> +
> +               if (get_user(len, optlen))
> +                       return -EFAULT;
> +
> +               lock_sock(sk);
> +               tcp_get_authopt_val(sk, &info);
> +               release_sock(sk);
> +
> +               len = min_t(unsigned int, len, sizeof(info));
> +               if (put_user(len, optlen))
> +                       return -EFAULT;
> +               if (copy_to_user(optval, &info, len))
> +                       return -EFAULT;
> +               return 0;
> +       }

I'm pretty sure it's not a good choice to write partly tcp_authopt.
And a user has no way to check what's the correct len on this kernel.
Instead of len = min_t(unsigned int, len, sizeof(info)), it should be
if (len != sizeof(info))
    return -EINVAL;

[..]
> +int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
> +{
> +       struct tcp_authopt opt;
> +       struct tcp_authopt_info *info;
> +
> +       WARN_ON(!lockdep_sock_is_held(sk));

sock_owned_by_me(sk)

> +
> +       /* If userspace optlen is too short fill the rest with zeros */
> +       if (optlen > sizeof(opt))
> +               return -EINVAL;
> +       memset(&opt, 0, sizeof(opt));

it's 4 bytes, why not just (optlen != sizeof(opt))?

[..]
> +int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
> +{
> +       struct tcp_sock *tp = tcp_sk(sk);
> +       struct tcp_authopt_info *info;
> +
> +       WARN_ON(!lockdep_sock_is_held(sk));

sock_owned_by_me(sk)

[..]
> +int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
> +{
> +       struct tcp_authopt_key opt;
> +       struct tcp_authopt_info *info;
> +       struct tcp_authopt_key_info *key_info;
> +
> +       /* If userspace optlen is too short fill the rest with zeros */
> +       if (optlen > sizeof(opt))
> +               return -EINVAL;
> +       memset(&opt, 0, sizeof(opt));
> +       if (copy_from_sockptr(&opt, optval, optlen))
> +               return -EFAULT;

Again, not a good practice to zero-extend struct. Enforce proper size
with -EINVAL.

[..]
> +       /* Initialize tcp_authopt_info if not already set */
> +       info = __tcp_authopt_info_get_or_create(sk);
> +       if (IS_ERR(info))
> +               return PTR_ERR(info);
> +
> +       /* check key family */
> +       if (opt.flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
> +               if (sk->sk_family != opt.addr.ss_family)
> +                       return -EINVAL;
> +       }

Probably, can be in the reverse order, so that
__tcp_authopt_info_get_or_create()
won't allocate memory.

> +       /* If an old value exists for same local_id it is deleted */
> +       key_info = __tcp_authopt_key_info_lookup(sk, info, opt.local_id);
> +       if (key_info)
> +               tcp_authopt_key_del(sk, info, key_info);
> +       key_info = sock_kmalloc(sk, sizeof(*key_info), GFP_KERNEL | __GFP_ZERO);
> +       if (!key_info)
> +               return -ENOMEM;

1. You don't need sock_kmalloc() together with tcp_authopt_key_del().
    It just frees the memory and allocates it back straight away - no
sense in doing that.
2. I think RFC says you must not allow a user to change an existing key:
> MKT parameters are not changed. Instead, new MKTs can be installed, and a connection
> can change which MKT it uses.

IIUC, it means that one can't just change an existing MKT, but one can
remove and later
add MKT with the same (send_id, recv_id, src_addr/port, dst_addr/port).

So, a reasonable thing to do:
if (key_info)
    return -EEXIST.

Thanks,
             Dmitry
