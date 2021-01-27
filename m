Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD2A305F07
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 16:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235463AbhA0PDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 10:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235315AbhA0PAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 10:00:35 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54668C061788
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 06:54:45 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id a1so2017773ilr.5
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 06:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sTdyNYkze+hI+OFRZCPwqiZbewY8o758U81yg52mX4M=;
        b=q8pB9egRttgWsLnscO5G4bYRpXSZAEr3Czk7HDYKghXyYGkiR66u90ioZFw7tahaDB
         CRGEkXinK6SxoxNHkCZVsQBD9lx8K9iIfwCaFFI2JewouxfQOryXga8qneDuVLCvyMeh
         arIMCS6QW8H6wS49vnLZvbTB7u3t3Mhk5LAJtuxVabZRSEafRpP5DAE2ABVKbfqAhSIw
         Xh3Ro1U23HmvBdQsN9sAkGVktk4YcULQJndthgOAd5l6CIazx6bo6unngx1qigZFlvft
         OABmeGgEvmJAJFBTkgBVz4lUcIweqDeHE4Hclkon06Fyfy36GeiimnRdN+9yrwYyhaSd
         Yv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sTdyNYkze+hI+OFRZCPwqiZbewY8o758U81yg52mX4M=;
        b=UtjGPf+aUPn+/++FyQGjRVlp9MNOssY4rT3LySHP7/eWjUXv8AOUFfys9m0eFxmBQP
         dycP/cPJdYw9CY4xnk0xN4n6R14PvPEvGjZRM75WjCjtE+jG8CO9ZYsfxLhW8m7geJjz
         vRFlrcYp6bDlLgCDt74ACdpmCsk0Ijq3V8XoiagtNnmz5Ar1B7Jo181BYewOFJNzPUTc
         lJVCSSh91/TZNr+5zfIzRQrx7bsWtiCb2EmHdSVEhmZY9dbbccoLMbnUFtRHHeMr9b8v
         77i5NSCYyfBj3r8kr6z2Z/wLnygFXS1fJtfiqNSUFp4EkcQe5u1qiycFz8PqfGLBaFyO
         cosw==
X-Gm-Message-State: AOAM531lcPd3aA2Cb28i4vhnRMwAd4dBN74sOOR5VUtK2m+GXjrYbQgD
        uw9T1ofryJUHNS44BmgQgJXckSs/NPTHx6t/7L69ig==
X-Google-Smtp-Source: ABdhPJym5YHdk7S2GBOskLrJaJULn2+Xd5bDT5AbmWnQMa5r6J68lPTVZvdEBa+glr+j4eSggYZNORX6z7pePV/Rzf4=
X-Received: by 2002:a92:d8c2:: with SMTP id l2mr9200045ilo.216.1611759284256;
 Wed, 27 Jan 2021 06:54:44 -0800 (PST)
MIME-Version: 1.0
References: <20210127125018.7059-1-kuniyu@amazon.co.jp>
In-Reply-To: <20210127125018.7059-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 27 Jan 2021 15:54:32 +0100
Message-ID: <CANn89iJF_LOMDj9RZAe0QDkkJwCs7CgFA4KMijs5siz904DSzg@mail.gmail.com>
Subject: Re: [PATCH net] net: Remove redundant calls of sk_tx_queue_clear().
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Amit Shah <aams@amazon.de>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 1:50 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> The commit 41b14fb8724d ("net: Do not clear the sock TX queue in
> sk_set_socket()") removes sk_tx_queue_clear() from sk_set_socket() and adds
> it instead in sk_alloc() and sk_clone_lock() to fix an issue introduced in
> the commit e022f0b4a03f ("net: Introduce sk_tx_queue_mapping"). However,
> the original commit had already put sk_tx_queue_clear() in sk_prot_alloc():
> the callee of sk_alloc() and sk_clone_lock(). Thus sk_tx_queue_clear() is
> called twice in each path currently.

Are you sure ?

I do not clearly see the sk_tx_queue_clear() call from the cloning part.

Please elaborate.

In any case, this seems to be a candidate for net-next, this is not
fixing a bug,
this would be an optimization at most, and potentially adding a bug.

So if you resend this patch, you can mention the old commit in the changelog,
but do not add a dubious Fixes: tag


>
> This patch removes the redundant calls of sk_tx_queue_clear() in sk_alloc()
> and sk_clone_lock().
>
> Fixes: 41b14fb8724d ("net: Do not clear the sock TX queue in sk_set_socket()")
> CC: Tariq Toukan <tariqt@mellanox.com>
> CC: Boris Pismenny <borisp@mellanox.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Reviewed-by: Amit Shah <aams@amazon.de>
> ---
>  net/core/sock.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/net/core/sock.c b/net/core/sock.c
> index bbcd4b97eddd..5c665ee14159 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1759,7 +1759,6 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
>                 cgroup_sk_alloc(&sk->sk_cgrp_data);
>                 sock_update_classid(&sk->sk_cgrp_data);
>                 sock_update_netprioidx(&sk->sk_cgrp_data);
> -               sk_tx_queue_clear(sk);
>         }
>
>         return sk;
> @@ -1983,7 +1982,6 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
>                  */
>                 sk_refcnt_debug_inc(newsk);
>                 sk_set_socket(newsk, NULL);
> -               sk_tx_queue_clear(newsk);
>                 RCU_INIT_POINTER(newsk->sk_wq, NULL);
>
>                 if (newsk->sk_prot->sockets_allocated)
> --
> 2.17.2 (Apple Git-113)
>
