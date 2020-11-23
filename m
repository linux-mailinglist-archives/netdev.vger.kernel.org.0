Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B302C0301
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 11:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgKWKKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 05:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgKWKKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 05:10:00 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF98AC0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 02:09:59 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id bj5so7790583plb.4
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 02:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vz5OQ2DxoYXYRZB2CCFGSGjbBdZ/Cxd2LHpsd7WJgXw=;
        b=YknmvFKVc0DTH4DhbrEaHXqGVaKW6slE7ZrJv05CNYnVWomhh3HaQJecVCIyWKWuUE
         UZtRIDEC5yYXeM7IDWzTClbnivylhUV7hLBYb3tliLex7t0LO57uXKujhLp0U0CjxFJ4
         FtztnXjXsVeKwkMn14jaCfT5wbeRlQ43oy1NYzcV819BrrD8mLiU+Qv2gSxSGSQCRjjE
         2glFWAKvawfpWE8EBt3jzC4lO5aIoiQ+L0XsLyPP6IiG+7EDyX56DjmjoFA1s4hny0YH
         thDomEgoxgd40zA+XGU8xMIJb7BYP1puPd6vk6Q1wy1XyNhng75UEaZ3kCkOk3/yCQrG
         Zo9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vz5OQ2DxoYXYRZB2CCFGSGjbBdZ/Cxd2LHpsd7WJgXw=;
        b=nrA7dC4VD35lc0aH8FrnWg1IlFoek1lZbayoF8KDRjpZJLdB6DGuJOkIhbjLk9qPai
         Y1q3CIGN3Yu4gbISTTgy8PUqVbNwHAYv5zo7LjjLXvrw5s9fGJrgf/8CKqeVL3JWN9fq
         IDoOh0jVzhmboUlzb4s/EUPhyKxFSfIzYxLE35beBKSwcwPUprycYzlXAvbmxpSrLXd0
         7H1Zuj82c9og9X1N3JDkRGz50haGw6lHbH2KiHKCRUU+B4Qmox7YL44Dro/lDK3uwYDT
         SvGistp0n6USMosBhqBa4V4HV9fgN2DiZYP4XxFNd5cBxGiAb78ijjASaIwhTv60sY8L
         kSvg==
X-Gm-Message-State: AOAM530lzuhuqC/vs3CCTFTios2jWQa/T40qfThrrgwzdUjQ4JBOrHQa
        IPSZPvpxPNftRSU+BfL/BPGG1xtAY/TchDcfYRXcDKgoqbYAMg==
X-Google-Smtp-Source: ABdhPJwWRJLcs1FayQx/wc38zxnSC164FcdKpLpIocYnh+GV/ypzTrMvM1x7ymOtRo3UYuUE22KmDT9NkbSiZImx++E=
X-Received: by 2002:a17:902:be07:b029:da:c5e:81b6 with SMTP id
 r7-20020a170902be07b02900da0c5e81b6mr3260665pls.43.1606126199511; Mon, 23 Nov
 2020 02:09:59 -0800 (PST)
MIME-Version: 1.0
References: <1606035891-6797-1-git-send-email-yanjunz@nvidia.com>
In-Reply-To: <1606035891-6797-1-git-send-email-yanjunz@nvidia.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 23 Nov 2020 11:09:48 +0100
Message-ID: <CAJ8uoz033qSMR3HcFKULJX=BEYW3v_UR=uJwOVcrXFzpwc-uqQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] xdp: compact the function xsk_map_inc
To:     Zhu Yanjun <yanjunz@nvidia.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 22, 2020 at 10:07 AM Zhu Yanjun <yanjunz@nvidia.com> wrote:
>
> From: Zhu Yanjun <zyjzyj2000@gmail.com>
>
> The function xsk_map_inc always returns zero. As such, changing the
> return type to void and removing the test code.
>
> Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
> Signed-off-by: Zhu Yanjun <yanjunz@nvidia.com>
> ---
>  net/xdp/xsk.c    |    1 -
>  net/xdp/xsk.h    |    2 +-
>  net/xdp/xskmap.c |   10 ++--------
>  3 files changed, 3 insertions(+), 10 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index cfbec39..c1b8a88 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -548,7 +548,6 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
>         node = list_first_entry_or_null(&xs->map_list, struct xsk_map_node,
>                                         node);
>         if (node) {
> -               WARN_ON(xsk_map_inc(node->map));
>                 map = node->map;
>                 *map_entry = node->map_entry;
>         }
> diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
> index b9e896c..766b9e2 100644
> --- a/net/xdp/xsk.h
> +++ b/net/xdp/xsk.h
> @@ -41,7 +41,7 @@ struct xsk_map_node {
>
>  void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
>                              struct xdp_sock **map_entry);
> -int xsk_map_inc(struct xsk_map *map);
> +void xsk_map_inc(struct xsk_map *map);
>  void xsk_map_put(struct xsk_map *map);
>  void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id);
>  int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
> diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
> index 49da2b8..c7dd94a 100644
> --- a/net/xdp/xskmap.c
> +++ b/net/xdp/xskmap.c
> @@ -11,10 +11,9 @@
>
>  #include "xsk.h"
>
> -int xsk_map_inc(struct xsk_map *map)
> +void xsk_map_inc(struct xsk_map *map)
>  {
>         bpf_map_inc(&map->map);
> -       return 0;
>  }

Thank you Yanjun for your cleanup. I think we can take this one step
further and remove the function xsk_map_inc completely and use
bpf_map_inc directly in the code. Could you please do this and submit
a v2?

>  void xsk_map_put(struct xsk_map *map)
> @@ -26,17 +25,12 @@ void xsk_map_put(struct xsk_map *map)
>                                                struct xdp_sock **map_entry)
>  {
>         struct xsk_map_node *node;
> -       int err;
>
>         node = kzalloc(sizeof(*node), GFP_ATOMIC | __GFP_NOWARN);
>         if (!node)
>                 return ERR_PTR(-ENOMEM);
>
> -       err = xsk_map_inc(map);
> -       if (err) {
> -               kfree(node);
> -               return ERR_PTR(err);
> -       }
> +       xsk_map_inc(map);
>
>         node->map = map;
>         node->map_entry = map_entry;
> --
> 1.7.1
>
