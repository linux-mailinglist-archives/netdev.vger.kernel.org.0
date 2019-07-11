Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A17651AE
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 08:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfGKGCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 02:02:13 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33591 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbfGKGCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 02:02:13 -0400
Received: by mail-lj1-f195.google.com with SMTP id h10so4491058ljg.0
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 23:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5wfpCOZ83nI7HCRBNZYdSqgK08vpf3gVcSTnau6UYac=;
        b=BcNT1qKADluKUbaLesg1b4t+d4/iFYu5N8uvYFQrG2v7R4F/dqtkef3BhfnifY1XED
         uXCUzTzxiPb8fHnKmsGuGRQSGqeTp3WhYhS0adjv8D/cAjxgmZqFEd8Za/ZVPdpDzwAz
         Pko4W66+AGPjlyfXom/A7dW0sv9+sMcG+UTLB8cYN4Fz6E4e40Uf758G3DOP7j1kVNms
         a39z8cLDtR3qDXhyIsdfPJ2CWxz7Y42b4yEo+vifNNaraJ/Wx8T/bh3xYto7nl3I8waI
         BM7pf6kV+6OcUTwokyPlJQPiarEVIiVFwMn9Q341AoonwERkgPQA5aL7NyG3h+5U8ZaM
         O1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5wfpCOZ83nI7HCRBNZYdSqgK08vpf3gVcSTnau6UYac=;
        b=IvAn2ajLgBh1zbzas1o8GwvHYA+/q+xcRbFTyh2n6fps/9qnYC3S6h38EZEkdwEesp
         TMKesVfG/dZg4RL0pq9eW6kH09ZuwK35Xb2VyMyVPiHxd6hXvEl8m+PqwhVV8NUjNE6K
         V05a3DcUH3cEugCz1LZh7stW4d3/NnJQ4HitQXDzwaXvi+wKbyPIE2pjWnY1jcn7RoI6
         i4VKifxZaWhYO5zVtkeA4xJM3Q+T6Yo1xxbV3vjhChtj8udwqjUc5s3okhkxoqXJVxNM
         6ipnzHetPFaxfWlOoUwx13vsdb0cFcG2qqGsvVaYQ97OsgoXmlc03K+2BawXzU3VebOE
         zdVg==
X-Gm-Message-State: APjAAAUx0dKNmndBAH4rWWu3n5vYaf45M/W5hTmYGoOxYcrqtAa1+/ZQ
        HtA3gDPJSYY4YgLDSPeoRYWGF88y2r2kr5M4V7M=
X-Google-Smtp-Source: APXvYqw/SKkWcDJJYhzh9Foxv18y0Hev4hCuXDzlEy58M1Sxo6DuPPrWfqWCtEi7kWCI77FTG7mPXUosCqvzTtc9cBI=
X-Received: by 2002:a2e:3604:: with SMTP id d4mr1227030lja.85.1562824931191;
 Wed, 10 Jul 2019 23:02:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190710190502.104010-1-natechancellor@gmail.com>
In-Reply-To: <20190710190502.104010-1-natechancellor@gmail.com>
From:   Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date:   Wed, 10 Jul 2019 23:02:00 -0700
Message-ID: <CALzJLG9Aw=sVPDiewHr+4Jiuaod_1q=10vzMzCUVg-rCCXD6cQ@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5e: Move priv variable into case statement in mlx5e_setup_tc
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Netdev List <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 12:05 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> There is an unused variable warning on arm64 defconfig when
> CONFIG_MLX5_ESWITCH is unset:
>
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c:3467:21: warning:
> unused variable 'priv' [-Wunused-variable]
>         struct mlx5e_priv *priv = netdev_priv(dev);
>                            ^
> 1 warning generated.
>
> Move it down into the case statement where it is used.
>
> Fixes: 4e95bc268b91 ("net: flow_offload: add flow_block_cb_setup_simple()")
> Link: https://github.com/ClangBuiltLinux/linux/issues/597
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 6d0ae87c8ded..651eb714eb5b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -3464,15 +3464,16 @@ static LIST_HEAD(mlx5e_block_cb_list);
>  static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
>                           void *type_data)
>  {
> -       struct mlx5e_priv *priv = netdev_priv(dev);
> -
>         switch (type) {
>  #ifdef CONFIG_MLX5_ESWITCH
> -       case TC_SETUP_BLOCK:
> +       case TC_SETUP_BLOCK: {
> +               struct mlx5e_priv *priv = netdev_priv(dev);
> +
>                 return flow_block_cb_setup_simple(type_data,
>                                                   &mlx5e_block_cb_list,
>                                                   mlx5e_setup_tc_block_cb,
>                                                   priv, priv, true);
> +       }

Hi Nathan,

We have another patch internally that fixes this, and it is already
queued up in my queue.
it works differently as we want to pass priv instead of netdev to
mlx5e_setup_tc_mqprio below,
which will also solve warning ..

So i would like to submit that patch if it is ok with you ?

>  #endif
>         case TC_SETUP_QDISC_MQPRIO:
>                 return mlx5e_setup_tc_mqprio(dev, type_data);
> --
> 2.22.0
>
