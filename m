Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A62D2B5449
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbgKPW1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbgKPW1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 17:27:53 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D84EC0613CF;
        Mon, 16 Nov 2020 14:27:53 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id t9so20399276edq.8;
        Mon, 16 Nov 2020 14:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iLbFaxcZtvef08Mzr8UqS8KoKu5hGYRojS9TGSmj9sU=;
        b=rmy3UbquKvfScxFsFyBk/yaTm3ax16ix35yaIV5BK9RtNEq/T05qjfCFDVqdsPv9uK
         6oIeZ2x0pVK+CoZ8vIU7SDp5Z6LwujvBn7rQW8U+QQQ4X6JB8yKrcNFroUMZTHfcFzg8
         KTDB/Q5NvjjfaSv8QaBouMQqCxW2gsUUEAl1dim5Q14bnLbUXhhAcG8qJxyXV7aisOqp
         5Wn2spUCtAiJ6U6/R0KycdwSQ6EAlcxQPXampYgKGbj4RaF1MptNcKLJ7v5pVDUYu2QG
         vBXKsu9STY6lszhBUfq+mkGG+FgTen9u8yCnEFurltUKX/FiXV7p3PYmfKSQQw8wAR7j
         b4Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iLbFaxcZtvef08Mzr8UqS8KoKu5hGYRojS9TGSmj9sU=;
        b=U6GG0vOSXSEVmd9+IqUYFPEqp6TgsQtDX7aP1OIRLFDEg8M1M7zhDbOIXEHkRbfs22
         dkH7tNwsR8a5Sajmo4ZToIVeIwue4Pgy7YGorqVPNpyfgubWCrhwlWHIcYTN3doXqgZY
         CJplRIiVKwCPwHhAwK0AVXxES4IKHKab4Wy+782ydB/H5HaFA0bvheMPiWP1XE71ruSN
         A1Lzzyf8eYlPpT6ky8HSUQfSt7A7qujogY0nHy1pjF6FusxRC+bDZK6mCS0iONIKRazA
         JjYshVn/8HChD/hXWANxC5cGGJtxgnXlPSb8l1DQkI2cclOMFwoT0Q1Kguc5n4ODocYS
         F5Rw==
X-Gm-Message-State: AOAM532rS8ERy2F8GT/TZgbvjsalHAmRho+RgiQ9LMCrMU1f77XZWrBt
        X9hN5gE24fEKvYBg5jhUlTIyvofhnng=
X-Google-Smtp-Source: ABdhPJyYdAfIpjxBLlyaK0aU8qkVIC04BTB6lcZPe+aKY5JzWQ4Dh0vGfueeiy3eppz5E/u7G1zq4A==
X-Received: by 2002:a50:fd15:: with SMTP id i21mr17244380eds.127.1605565671923;
        Mon, 16 Nov 2020 14:27:51 -0800 (PST)
Received: from ltop.local ([2a02:a03f:b7fe:f700:a141:d91b:1f47:d972])
        by smtp.gmail.com with ESMTPSA id f25sm5289440ejr.120.2020.11.16.14.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 14:27:51 -0800 (PST)
Date:   Mon, 16 Nov 2020 23:27:50 +0100
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-sparse@vger.kernel.org
Subject: Re: [PATCH net-next] net: add annotation for sock_{lock,unlock}_fast
Message-ID: <20201116222750.nmfyxnj6jvd3rww4@ltop.local>
References: <95cf587fe96127884e555f695fe519d50e63cc17.1605522868.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95cf587fe96127884e555f695fe519d50e63cc17.1605522868.git.pabeni@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 11:36:39AM +0100, Paolo Abeni wrote:
> The static checker is fooled by the non-static locking scheme
> implemented by the mentioned helpers.
> Let's make its life easier adding some unconditional annotation
> so that the helpers are now interpreted as a plain spinlock from
> sparse.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  include/net/sock.h | 9 ++++++---
>  net/core/sock.c    | 3 ++-
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 1d29aeae74fd..60d321c6b5a5 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1595,7 +1595,8 @@ void release_sock(struct sock *sk);
>  				SINGLE_DEPTH_NESTING)
>  #define bh_unlock_sock(__sk)	spin_unlock(&((__sk)->sk_lock.slock))
>  
> -bool lock_sock_fast(struct sock *sk);
> +bool lock_sock_fast(struct sock *sk) __acquires(&sk->sk_lock.slock);
> +

Good.

>  /**
>   * unlock_sock_fast - complement of lock_sock_fast
>   * @sk: socket
> @@ -1606,10 +1607,12 @@ bool lock_sock_fast(struct sock *sk);
>   */
>  static inline void unlock_sock_fast(struct sock *sk, bool slow)
>  {
> -	if (slow)
> +	if (slow) {
>  		release_sock(sk);
> -	else
> +		__release(&sk->sk_lock.slock);

The correct solution would be to annotate the declaration of
release_sock() with '__releases(&sk->sk_lock.slock)'.

>  /* Used by processes to "lock" a socket state, so that
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 727ea1cc633c..9badbe7bb4e4 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -3078,7 +3078,7 @@ EXPORT_SYMBOL(release_sock);
>   *
>   *   sk_lock.slock unlocked, owned = 1, BH enabled
>   */
> -bool lock_sock_fast(struct sock *sk)
> +bool lock_sock_fast(struct sock *sk) __acquires(&sk->sk_lock.slock)
>  {
>  	might_sleep();
>  	spin_lock_bh(&sk->sk_lock.slock);
> @@ -3096,6 +3096,7 @@ bool lock_sock_fast(struct sock *sk)
>  	 * The sk_lock has mutex_lock() semantics here:
>  	 */
>  	mutex_acquire(&sk->sk_lock.dep_map, 0, 0, _RET_IP_);
> +	__acquire(&sk->sk_lock.slock);

OK, given that the mutexes are not annotated.

-- Luc 
