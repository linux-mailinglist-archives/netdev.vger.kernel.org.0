Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BD83FCD6A
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 21:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhHaTFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 15:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhHaTFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 15:05:21 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD807C061575;
        Tue, 31 Aug 2021 12:04:23 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id n5so644681wro.12;
        Tue, 31 Aug 2021 12:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B5uVyKLNWhfX33mRagoPROdJlSl7ZtW8OYmRZysKsaw=;
        b=Lgq9rCDdjZ00K4U+kAn67iLHwtxXEqmx4jyy5gWT5fP0dWAR1ejoRKTw+J6lkHMVQm
         Ghho8S0nlhYc63iBeU+nx6kJjUzmxW6lYVYJWij0PWuAexg9j8xIvuzie4CfYCrTkhlv
         yxeP6sDUpvAbizHd5jFcVB9qKffuNIpMMPnflcUIBT7x3rpifTZenjF84wmKi4tWfpjT
         8AS9Sg+mxihpAnv4r93AWBeV/yYZ0+0cOcwtvF6WvPY5AeDKAqrTUp/RoG+lhKLMrUQs
         LKWe8J61dlRzA+bK9Ur+AlqKpJ6U41nrBdSKYx8Ur2FAv7vYstMLKDu/w0HybvGxSoZR
         zmcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B5uVyKLNWhfX33mRagoPROdJlSl7ZtW8OYmRZysKsaw=;
        b=XtMmYvphZIflmrUeAU9tlINULILcxgIdKtIHPA/mZshOIanVAD/789V4uDcTlXoyzM
         CREsCBCRTqE1hhYPuzgsCvPoGGELAy99+oaYRT3KiTizjuQ4eTnEfMCd//XKLa4sbquN
         4EN4STO1SkTBuUcLixq7rchIk5bxJvzvmfJSMqu8crkIkk6M72s1lp6M5iPh4mAHrmo8
         4kJ3seIVtpJLpUkpM9uLJTzk/tBUOU3XzTtshC73RDVZUnDnavXx14D7N4ZQADK8K/bT
         MXB7aJZsNTcg8U1JGCDfiLEghpARZeHGUgKAfvb655zF6OffnaE0cLzys/nmskuaFHAD
         A10g==
X-Gm-Message-State: AOAM531aSS9ald7L6wiBYlUgrNFhSSS4ysZgh3Bivm73PFsdsf+NJE3V
        uq3Ie89AxvOhS+jTuSaovbU=
X-Google-Smtp-Source: ABdhPJwb7Vt0bBOnzlKywb3CaKHbdGi9I/NIJDCfk2uELycYcKxnVqd0YHTMSqfsJz9039ylUL8Kkw==
X-Received: by 2002:a5d:560e:: with SMTP id l14mr19927263wrv.205.1630436662162;
        Tue, 31 Aug 2021 12:04:22 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id b13sm18408739wrf.86.2021.08.31.12.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 12:04:21 -0700 (PDT)
Subject: Re: [RFCv3 01/15] tcp: authopt: Initial support and key management
To:     Leonard Crestez <cdleonard@gmail.com>,
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
 <090898ac6f3345ec02999858c65c2ebb8cd274a8.1629840814.git.cdleonard@gmail.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
Message-ID: <b93d21fa-13aa-20d9-0747-c443ccf2c5d5@gmail.com>
Date:   Tue, 31 Aug 2021 20:04:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <090898ac6f3345ec02999858c65c2ebb8cd274a8.1629840814.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leonard,

On 8/24/21 10:34 PM, Leonard Crestez wrote:
[..]
> --- /dev/null
> +++ b/include/net/tcp_authopt.h
> @@ -0,0 +1,65 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef _LINUX_TCP_AUTHOPT_H
> +#define _LINUX_TCP_AUTHOPT_H
> +
> +#include <uapi/linux/tcp.h>
> +
> +/**
> + * struct tcp_authopt_key_info - Representation of a Master Key Tuple as per RFC5925
> + *
> + * Key structure lifetime is only protected by RCU so readers needs to hold a
> + * single rcu_read_lock until they're done with the key.
> + */
> +struct tcp_authopt_key_info {
> +	struct hlist_node node;
> +	struct rcu_head rcu;
> +	/* Local identifier */
> +	u32 local_id;

It's unused now, can be removed.

[..]
> +
> +/**
> + * enum tcp_authopt_key_flag - flags for `tcp_authopt.flags`
> + *
> + * @TCP_AUTHOPT_KEY_DEL: Delete the key by local_id and ignore all other fields.
                                              ^
By send_id and recv_id.
Also, tcp_authopt_key_match_exact() seems to check
TCP_AUTHOPT_KEY_ADDR_BIND. I wounder if that makes sense to relax it in
case of TCP_AUTHOPT_KEY_DEL to match only send_id/recv_id if addr isn't
specified (no hard feelings about it, though).

[..]
> +#ifdef CONFIG_TCP_AUTHOPT
> +	case TCP_AUTHOPT: {
> +		struct tcp_authopt info;
> +
> +		if (get_user(len, optlen))
> +			return -EFAULT;
> +
> +		lock_sock(sk);
> +		tcp_get_authopt_val(sk, &info);
> +		release_sock(sk);
> +
> +		len = min_t(unsigned int, len, sizeof(info));
> +		if (put_user(len, optlen))
> +			return -EFAULT;
> +		if (copy_to_user(optval, &info, len))
> +			return -EFAULT;
> +		return 0;

Failed tcp_get_authopt_val() lookup in:
:       if (!info)
:               return -EINVAL;

will leak uninitialized kernel memory from stack.
ASLR guys defeated.

[..]
> +#define TCP_AUTHOPT_KNOWN_FLAGS ( \
> +	TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED)
> +
> +int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
> +{
> +	struct tcp_authopt opt;
> +	struct tcp_authopt_info *info;
> +
> +	sock_owned_by_me(sk);
> +
> +	/* If userspace optlen is too short fill the rest with zeros */
> +	if (optlen > sizeof(opt))
> +		return -EINVAL;

More like
:	if (unlikely(len > sizeof(opt))) {
:		err = check_zeroed_user(optval + sizeof(opt),
:					len - sizeof(opt));
:		if (err < 1)
:			return err == 0 ? -EINVAL : err;
:		len = sizeof(opt);
:		if (put_user(len, optlen))
:			return -EFAULT;
:	}

> +	memset(&opt, 0, sizeof(opt));
> +	if (copy_from_sockptr(&opt, optval, optlen))
> +		return -EFAULT;
> +
> +	if (opt.flags & ~TCP_AUTHOPT_KNOWN_FLAGS)
> +		return -EINVAL;
> +
> +	info = __tcp_authopt_info_get_or_create(sk);
> +	if (IS_ERR(info))
> +		return PTR_ERR(info);
> +
> +	info->flags = opt.flags & TCP_AUTHOPT_KNOWN_FLAGS;
> +
> +	return 0;
> +}

[..]
> +int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
> +{
> +	struct tcp_authopt_key opt;
> +	struct tcp_authopt_info *info;
> +	struct tcp_authopt_key_info *key_info;
> +
> +	sock_owned_by_me(sk);
> +
> +	/* If userspace optlen is too short fill the rest with zeros */
> +	if (optlen > sizeof(opt))
> +		return -EINVAL;

Ditto

> +	memset(&opt, 0, sizeof(opt));
> +	if (copy_from_sockptr(&opt, optval, optlen))
> +		return -EFAULT;
> +
> +	if (opt.flags & ~TCP_AUTHOPT_KEY_KNOWN_FLAGS)
> +		return -EINVAL;
> +
> +	if (opt.keylen > TCP_AUTHOPT_MAXKEYLEN)
> +		return -EINVAL;
> +
> +	/* Delete is a special case: */
> +	if (opt.flags & TCP_AUTHOPT_KEY_DEL) {
> +		info = rcu_dereference_check(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
> +		if (!info)
> +			return -ENOENT;
> +		key_info = tcp_authopt_key_lookup_exact(sk, info, &opt);
> +		if (!key_info)
> +			return -ENOENT;
> +		tcp_authopt_key_del(sk, info, key_info);

Doesn't seem to be safe together with tcp_authopt_select_key().
A key can be in use at this moment - you have to add checks for it.

> +		return 0;
> +	}
> +
> +	/* check key family */
> +	if (opt.flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
> +		if (sk->sk_family != opt.addr.ss_family)
> +			return -EINVAL;
> +	}
> +
> +	/* Initialize tcp_authopt_info if not already set */
> +	info = __tcp_authopt_info_get_or_create(sk);
> +	if (IS_ERR(info))
> +		return PTR_ERR(info);
> +
> +	/* If an old key exists with exact ID then remove and replace.
> +	 * RCU-protected readers might observe both and pick any.
> +	 */
> +	key_info = tcp_authopt_key_lookup_exact(sk, info, &opt);
> +	if (key_info)
> +		tcp_authopt_key_del(sk, info, key_info);
> +	key_info = sock_kmalloc(sk, sizeof(*key_info), GFP_KERNEL | __GFP_ZERO);
> +	if (!key_info)
> +		return -ENOMEM;

So, you may end up without any key.
Also, replacing a key is not at all safe: you may receive old segments
which you in turn will discard and reset the connection.

I think the limitation RFC puts on removing keys in use and replacing
existing keys are actually reasonable. Probably, it'd be better to
enforce "key in use => desired key is different (or key_outdated flag)
=> key not in use => key may be removed" life-cycle of MKT.

Thanks,
            Dmitry
