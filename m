Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7C03B810C
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 13:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbhF3LFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 07:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbhF3LFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 07:05:34 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E2FC06175F
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 04:03:05 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id i4so4332212ybe.2
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 04:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d+YReNfrn+My6MDFsEwu0i1PD0fj98FTmiER+oq8EEw=;
        b=O0F4mQ7TW8eCorQS/KggtcA3XG8b//n0jyjvjvDUide7BKe4L0TLOIbJkVji41E1Mv
         cx14tKQlg0+uinPaaLy8/4aqeRNLX4FTOETrAdf6Mf+LNoqE06DeWFv+qZh4h8J1xx0a
         Y8lYu4YkMo/Lt4h4J6kz6dyaaA/zptvxt6PR2Hgl5YNk4xjcLxb5jXXA7zzC1z0kvv8X
         dCyPx0rzLpzoU6LwMNRHT/9/7GIkNLNQfBBHfK57xzD8V0MjHaz+GX6Sau5fF/+VBg7O
         9jOnw9ZFyyDraguIMlHNIRQ72Yb56fyDBbOZpu/z7HV81zDHcG/kooASlSjCPsZPsLUT
         NaqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d+YReNfrn+My6MDFsEwu0i1PD0fj98FTmiER+oq8EEw=;
        b=e5fujlj5idRpQxpEQf9vMDH+EJqeS/D6SsNnF7pTr+GRNTNxzIJgfE4D8nMs7UooEs
         nY4zFcDgpwqyPgVprjwO60bG0+DR+nKmpNDZYM2BEDZaRaOpSZRkcQTfL9bA/Bnkyu+g
         u/juxV66J5a/J7vP0XWOg2wUhYma7hqI61y8Cc861k8LOA25uekqsJUZaki+WInWhY0U
         N+URSb2vsp7MDKiJaL1+8/QVbX4H93iFURgfMH3+T68sFrN2DbKpYf4U42kjGnodzgNr
         3MoCAWflyfMdCiYQUZr74+IPnlWVE869deUs3l4Cua4diZXj3h2zEVQ1Q4Zl+H8+7vWL
         UHQg==
X-Gm-Message-State: AOAM530DoyIqom3jKDeDd65OzuFhA740xynsahFdudb0fzKj+eMzJf1R
        znuBGBiAGKeyni6/2oY8BSQP2nyg0iC+ECzt90HO8A==
X-Google-Smtp-Source: ABdhPJwrrqzx1XPekwwxSUGhBbvWSAE/6iMN0chVuS1LN4hSNUSx0uUaMlBjn0ofNXn4moedbQpgiX+kn81SBqgokuo=
X-Received: by 2002:a25:6e82:: with SMTP id j124mr42144554ybc.132.1625050984283;
 Wed, 30 Jun 2021 04:03:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210630051118.2212-1-yajun.deng@linux.dev>
In-Reply-To: <20210630051118.2212-1-yajun.deng@linux.dev>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 30 Jun 2021 13:02:53 +0200
Message-ID: <CANn89iJp8NoGeqP47u22tXpO78gzQoJBQQ4dpSdGb+v_dZ9kPQ@mail.gmail.com>
Subject: Re: [PATCH] net: core: Modify alloc_size in alloc_netdev_mqs()
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, andriin@fb.com,
        atenart@kernel.org, alobakin@pm.me, ast@kernel.org,
        daniel@iogearbox.net, weiwan@google.com, ap420073@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 7:11 AM Yajun Deng <yajun.deng@linux.dev> wrote:
>
> Use ALIGN for 'struct net_device', and remove the unneeded
> 'NETDEV_ALIGN - 1'. This can save a few bytes. and modify
> the pr_err content when txqs < 1.

I think that in old times (maybe still today), SLAB debugging could
lead to not unaligned allocated zones.
The forced alignment for netdev structures came in
commit f346af6a27c0cea99522213cb813fd30489136e2 ("net_device and
netdev private struct allocation improvements.")
in linux-2.6.3 (back in 2004)

This supposedly was a win in itself, otherwise Al Viro would not have
spent time on this.

>
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/core/dev.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c253c2aafe97..c42a682a624d 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -10789,7 +10789,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
>         BUG_ON(strlen(name) >= sizeof(dev->name));
>
>         if (txqs < 1) {
> -               pr_err("alloc_netdev: Unable to allocate device with zero queues\n");
> +               pr_err("alloc_netdev: Unable to allocate device with zero TX queues\n");
>                 return NULL;
>         }
>
> @@ -10798,14 +10798,12 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
>                 return NULL;
>         }
>
> -       alloc_size = sizeof(struct net_device);
> +       /* ensure 32-byte alignment of struct net_device*/
> +       alloc_size = ALIGN(sizeof(struct net_device), NETDEV_ALIGN);

This is not really needed, because struct net_device is cache line
aligned already on SMP builds.

>         if (sizeof_priv) {
>                 /* ensure 32-byte alignment of private area */
> -               alloc_size = ALIGN(alloc_size, NETDEV_ALIGN);
> -               alloc_size += sizeof_priv;
> +               alloc_size += ALIGN(sizeof_priv, NETDEV_ALIGN);

No longer needed, the private area starts at the end of struct net_device, whose
size is a multiple of cache line.

Really I doubt this makes sense anymore these days, we have hundreds
of structures in the kernel
that would need a similar handling if SLAB/SLUB was doing silly things.

I would simply do :

alloc_size += sizeof_priv;


>         }
> -       /* ensure 32-byte alignment of whole construct */
> -       alloc_size += NETDEV_ALIGN - 1;
>
>         p = kvzalloc(alloc_size, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>         if (!p)
> --
> 2.32.0
>
