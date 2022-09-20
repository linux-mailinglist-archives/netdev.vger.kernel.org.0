Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1475BE72A
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 15:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiITNeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 09:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiITNef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 09:34:35 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D746DCD4;
        Tue, 20 Sep 2022 06:34:30 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o70-20020a17090a0a4c00b00202f898fa86so2500611pjo.2;
        Tue, 20 Sep 2022 06:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Ud1zLgXH9AoOTKaYWX8ixkpv9cvGKhiKEy3m7R2TJr0=;
        b=WmGMJacRaa9mKwkL/FSCqBD9WAcWHIA5mGjDhAoJiZpWncEvQivRiD6ahlCswCWTUZ
         U54lVxtiFuoQBn9t59ANs9QkriEcbNFYaqIm08Pup2x8i7b7emBxog5ODGweq/EpXfQM
         yNE2AVwS63/au95MYlXofk8aiTkYOtgUjF//YJRxLXjSdVcVDYNkkk2WZt6/O0MrQ4Ui
         p3NmZ8bGWEWkTNLZdqSpenux7bC9RGFRC3Dox+4WpGrkmpN6er2FJozi59IC8xv+ulHB
         OIo2IRe5e6OlBxpDLgGfkpKMxz78H5I5P392Vu6ZTJbgnphl4Oq6W9UWMxCP42se1aWQ
         574Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Ud1zLgXH9AoOTKaYWX8ixkpv9cvGKhiKEy3m7R2TJr0=;
        b=IttLIa37k6bRZQnXSHFWk3gG1E0nFtOZw4bP35CXL3IqFvok305WmqU0rw8YPK4dqD
         Df+bsg1EH/eTkKEykpEaWYAZ9CgcnssCz3YFBsCLnnyLyMvmgRHPC9WIUqLY+NWl/+Nm
         l/fgS6E9a+tzlQQ10e00Sxczf0CTMJm1jp1bkJNFJc2O8JQVPwyWED27JaB1j0g5Kf9A
         qp2lR7DPy800lGV0K9QusA2VQCWlMUmOnigt3oJQX24t9z+Ki/SQQrialsdcjzZjqgMb
         HYJikhEYj2nurQn0OeJNjX8tae7P06R7+7s7Zfok5O7fZIosz+AD7iV9dS48JsC99HOk
         eDog==
X-Gm-Message-State: ACrzQf2H5P3T0jNNT9TSRnTPoSNxIBTO0RR0x83938/08XarZuW7dMyu
        aerLUW1Ndmp7YVAUYsvHBuZgpcC8SwSTwm5ksjfBEbMpAc/k+mDy
X-Google-Smtp-Source: AMsMyM6E2HA8/leiFEFaY65VyvtF6eRZ91zeoQsTy0Ppg6zZHbNuIAQVLLwESFu05DhZpCyeFbQBE9tu9E+Ha1VFluA=
X-Received: by 2002:a17:903:32cf:b0:178:3d49:45b0 with SMTP id
 i15-20020a17090332cf00b001783d4945b0mr4853354plr.5.1663680870272; Tue, 20 Sep
 2022 06:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <Yymq2WLA6q6TxnNq@ipe420-102>
In-Reply-To: <Yymq2WLA6q6TxnNq@ipe420-102>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 20 Sep 2022 15:34:19 +0200
Message-ID: <CAJ8uoz2D9mGjZzo6SmAWtgbb0A3AB_Nk4eYXajenv3VDBA11=A@mail.gmail.com>
Subject: Re: [PATCH bpf v2] xsk: inherit need_wakeup flag for shared sockets
To:     Jalal Mostafa <jalal.a.mostapha@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        jonathan.lemon@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, daniel@iogearbox.net,
        linux-kernel@vger.kernel.org, jalal.mostafa@kit.edu
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 1:58 PM Jalal Mostafa
<jalal.a.mostapha@gmail.com> wrote:
>
> The flag for need_wakeup is not set for xsks with `XDP_SHARED_UMEM`
> flag and of different queue ids and/or devices. They should inherit
> the flag from the first socket buffer pool since no flags can be
> specified once `XDP_SHARED_UMEM` is specified. The issue is fixed
> by creating a new function `xp_create_and_assign_umem_shared` to
> create xsk_buff_pool for xsks with the shared umem flag set.

Thanks!

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Fixes: b5aea28dca134 ("xsk: Add shared umem support between queue ids")
> Signed-off-by: Jalal Mostafa <jalal.a.mostapha@gmail.com>
> ---
>  include/net/xsk_buff_pool.h | 2 +-
>  net/xdp/xsk.c               | 4 ++--
>  net/xdp/xsk_buff_pool.c     | 5 +++--
>  3 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index 647722e847b4..f787c3f524b0 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -95,7 +95,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
>                                                 struct xdp_umem *umem);
>  int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
>                   u16 queue_id, u16 flags);
> -int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
> +int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *umem_xs,
>                          struct net_device *dev, u16 queue_id);
>  int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs);
>  void xp_destroy(struct xsk_buff_pool *pool);
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 5b4ce6ba1bc7..7bada4e8460b 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -954,8 +954,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>                                 goto out_unlock;
>                         }
>
> -                       err = xp_assign_dev_shared(xs->pool, umem_xs->umem,
> -                                                  dev, qid);
> +                       err = xp_assign_dev_shared(xs->pool, umem_xs, dev,
> +                                                  qid);
>                         if (err) {
>                                 xp_destroy(xs->pool);
>                                 xs->pool = NULL;
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index a71a8c6edf55..ed6c71826d31 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -212,17 +212,18 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
>         return err;
>  }
>
> -int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
> +int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *umem_xs,
>                          struct net_device *dev, u16 queue_id)
>  {
>         u16 flags;
> +       struct xdp_umem *umem = umem_xs->umem;
>
>         /* One fill and completion ring required for each queue id. */
>         if (!pool->fq || !pool->cq)
>                 return -EINVAL;
>
>         flags = umem->zc ? XDP_ZEROCOPY : XDP_COPY;
> -       if (pool->uses_need_wakeup)
> +       if (umem_xs->pool->uses_need_wakeup)
>                 flags |= XDP_USE_NEED_WAKEUP;
>
>         return xp_assign_dev(pool, dev, queue_id, flags);
> --
> 2.34.1
>
