Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201E85BDD22
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 08:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiITG1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 02:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiITG1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 02:27:47 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B4C14036;
        Mon, 19 Sep 2022 23:27:46 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r23so1574695pgr.6;
        Mon, 19 Sep 2022 23:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=hVjUCDSaCdPdJ7NXLFSifGsFadRadfOQWil7zKYvxLI=;
        b=c125V8QjD5o5L+Aqok+dbsA1xQu0n25dsto6FuFHTGqhuM7a30ssy9Bs6qo8NNXIJy
         lYGrqv/UeUKStJwtecVoceKViRqnHW+DfaHZIo7g5ALU1AL2IPxzDLJPoXW9xjoHVrsM
         8x0ZHzaag8QtoAdsJvAD4JTkiMOmgBXcy9UwwJz/TCGwZG7H4UIFiaR18ePdxTgt23GT
         H76eLZ8X1YFQBgMPJ5W/gkScCjmgjeS+PoXSc5PNQZoyFOy4de5ghPSQcAnHWs/tyWHd
         PXqQLUyWa8B0HTxw2CAzWCXoWPIcZtdg734JqkletsmF3w0oX1D54xT/U25BGdZEOYf7
         JRbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=hVjUCDSaCdPdJ7NXLFSifGsFadRadfOQWil7zKYvxLI=;
        b=AWAJuouVQ0/sjkzYjOeGykglNt73gSA3J7dQu9ZBFdre5SgdgWBwfk3fQc9o+fXrW0
         yx5gtFaEVOzfsRWfMydq14QvW3Y9n39aN/GzNv360xug23hCrtRjNomUz0ClSsxMoKTF
         +wkA3+ABTHuVJKFWY9tDq5vdAw2BP/cH0qPOQoMeNIg7CF8PqNg9cbLc3AMQc1V6QPAP
         D1CaByETEiR5czEn/jlYh4dZXTj3jDO+j31hH1eIW88S0+Byka4Ww+kA1+UCtqvx5B3C
         bOCy6DGhxte3hNVrfh7ISrK1MpQX1xDjr/9xtPAFl43+YRrvjpUkcUBcwkFsgp2UfDCU
         tOQw==
X-Gm-Message-State: ACrzQf1bujblJ85mwElZ7r6N2IMk8stk1AFF2C7wFIEPhp3c1HADqAzE
        9WpEwb7XF6rDEDiPn7FojjDDYyNWzqFarPs2csY=
X-Google-Smtp-Source: AMsMyM5s4t8RXN2/xwtdUU0gK/TFlYQcykuRGozpzIEPl1arwy8c3Q8rsEQyaBnVdQYh7nqPZL3CP6d7nL3hQ92w7NE=
X-Received: by 2002:a63:3409:0:b0:438:c9c9:5582 with SMTP id
 b9-20020a633409000000b00438c9c95582mr18570186pga.69.1663655265597; Mon, 19
 Sep 2022 23:27:45 -0700 (PDT)
MIME-Version: 1.0
References: <YyjCBjJch24OT+Ia@ipe420-102>
In-Reply-To: <YyjCBjJch24OT+Ia@ipe420-102>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 20 Sep 2022 08:27:34 +0200
Message-ID: <CAJ8uoz3G05BsmafrkP93sO--3S2MBgA96Dh_40iM8svuPU5qxA@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: inherit need_wakeup flag for shared sockets
To:     Jalal Mostafa <jalal.a.mostapha@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        jonathan.lemon@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
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

On Mon, Sep 19, 2022 at 9:27 PM Jalal Mostafa
<jalal.a.mostapha@gmail.com> wrote:
>
> The flag for need_wakeup is not set for xsks with `XDP_SHARED_UMEM`
> flag and of different queue ids and/or devices. They should inherit
> the flag from the first socket buffer pool since no flags can be
> specified once `XDP_SHARED_UMEM` is specified. The issue is fixed
> by creating a new function `xp_create_and_assign_umem_shared` to
> create xsk_buff_pool for xsks with the shared umem flag set.

Thanks for spotting this Jalal. Though I think we should aim for a
simpler fix. The uses_need_wakeup flag is set by xp_assign_dev(). The
problem here is the function xp_assign_dev_shared() that prepares the
flag parameter for xp_assign_dev().

if (pool->uses_need_wakeup)
                flags |= XDP_USE_NEED_WAKEUP;

Should really be:

if (umem_xs->pool->uses_need_wakeup)
                flags |= XDP_USE_NEED_WAKEUP;

So change the function parameter *umem to *umem_xs, use that in the
function call and do:

flags = umem_xs->umem->zc ? XDP_ZEROCOPY : XDP_COPY;
if (umem_xs->pool->uses_need_wakeup)
          flags |= XDP_USE_NEED_WAKEUP;

What do you think?

> Signed-off-by: Jalal Mostafa <jalal.a.mostapha@gmail.com>
> ---
>  include/net/xsk_buff_pool.h |  2 ++
>  net/xdp/xsk.c               |  3 +--
>  net/xdp/xsk_buff_pool.c     | 15 +++++++++++++++
>  3 files changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index 647722e847b4..917cfef9d355 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -93,6 +93,8 @@ struct xsk_buff_pool {
>  /* AF_XDP core. */
>  struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
>                                                 struct xdp_umem *umem);
> +struct xsk_buff_pool *xp_create_and_assign_umem_shared(struct xdp_sock *xs,
> +                                                      struct xdp_sock *umem_xs);
>  int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
>                   u16 queue_id, u16 flags);
>  int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 5b4ce6ba1bc7..a415db88e8e5 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -946,8 +946,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
>                         /* Share the umem with another socket on another qid
>                          * and/or device.
>                          */
> -                       xs->pool = xp_create_and_assign_umem(xs,
> -                                                            umem_xs->umem);
> +                       xs->pool = xp_create_and_assign_umem_shared(xs, umem_xs);
>                         if (!xs->pool) {
>                                 err = -ENOMEM;
>                                 sockfd_put(sock);
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index a71a8c6edf55..7d5b0bd8d953 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -112,6 +112,21 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
>         return NULL;
>  }
>
> +struct xsk_buff_pool *xp_create_and_assign_umem_shared(struct xdp_sock *xs,
> +                                                      struct xdp_sock *umem_xs)
> +{
> +       struct xdp_umem *umem = umem_xs->umem;
> +       struct xsk_buff_pool *pool = xp_create_and_assign_umem(xs, umem);
> +
> +       if (!pool)
> +               goto out;
> +
> +       pool->uses_need_wakeup = umem_xs->pool->uses_need_wakeup;
> +
> +out:
> +       return pool;
> +}
> +
>  void xp_set_rxq_info(struct xsk_buff_pool *pool, struct xdp_rxq_info *rxq)
>  {
>         u32 i;
> --
> 2.34.1
>
