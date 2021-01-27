Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E353064B8
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhA0UCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbhA0UBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:01:23 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A394AC061574
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 12:00:42 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id n6so3947640edt.10
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 12:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FXwquj96jKT4zekJI80I+RGX6Xw5dYxfkrJfuL5iI1A=;
        b=rEU5k/92felUVepax7sA88glKq/Iv4oocQBGfkTH+p8ko4rCScnu2d3Gu8F2B4puHM
         J1Fn42Y57Q5/eNfbKzYQAg73b1VOm7S8ZSSX0cY/x+eBFfmKOPaZJNSWCXZjm6vnCNoC
         gyiDlXtcES/4DIsDPor94vbeMQE8kVx7jR2gj2C3QWcbFsRjt8q4lLzDlDAjTk7Jtt2Y
         gnR9CcX3i4T7Ex8sIwqNSv+gqKVykQ+K4kCqBGJGVEBi+i9uPyVKOg1y9YV6dpJSSseg
         BMG8CekT+T7RH9vdBIjx09q0XNXYhefmFS2Ni/4HKxXwbBeU5p8gHtgNIypkq/L+gX0P
         Ozuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FXwquj96jKT4zekJI80I+RGX6Xw5dYxfkrJfuL5iI1A=;
        b=hNkjhHf/+I+JmKsFopWerfSqVPcSad3utSPCqT75NyD1YXNaRX0a8INJvIS1gVN8Et
         v2er51lK6G/TRifRyD3lc7VrwTyvvBbamqbukEullp168N23JlWYVMwsSTy8Qn/4rl1J
         F4vs6xQ5B8CVqqicY+Y54AORLXeqXlitFmaYKHtE3PpPispnVEbMZ/WlM8165aiUvW6n
         t9HIruPwCX5S8kLFVBcLv0I1eqWHfnJjzelnIYdD7rH8UAEj4orJq0fNyioc9JaPMl28
         clZW5c5jyCVGPMmgOFaHba/JdG6bAePTdWNP5L76j2E3v9OLm7Lv1xWB1/bX56IfX5bI
         kB/Q==
X-Gm-Message-State: AOAM533np4UTib73vOJmAfKbj823c1p2ezGjq4duWidwZHtKlEsau8ed
        IqzRHc6vvicXvIRHebuw7eqKlsNgyo/OeVL04/OLjTTc
X-Google-Smtp-Source: ABdhPJxB9UlbFBYdNfbo95eQSYiZTwUvjqmzuH6ujcbWvqmmCwiQNoPhwk0V8cI3lZpz3BtHhLbha8Ez/A6kFV+KZ1w=
X-Received: by 2002:aa7:d1d7:: with SMTP id g23mr10573132edp.6.1611777641449;
 Wed, 27 Jan 2021 12:00:41 -0800 (PST)
MIME-Version: 1.0
References: <20210126234345.202096-1-saeedm@nvidia.com> <20210126234345.202096-12-saeedm@nvidia.com>
In-Reply-To: <20210126234345.202096-12-saeedm@nvidia.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 15:00:04 -0500
Message-ID: <CAF=yD-+DGf_PAQzWScXR7O2J5WY2G5maxMbDQQCNbJXYE6R1Mw@mail.gmail.com>
Subject: Re: [net 11/12] net/mlx5e: Revert parameters on errors when changing
 MTU and LRO state without reset
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 3:58 AM Saeed Mahameed <saeedm@nvidia.com> wrote:
>
> From: Maxim Mikityanskiy <maximmi@mellanox.com>
>
> Sometimes, channel params are changed without recreating the channels.
> It happens in two basic cases: when the channels are closed, and when
> the parameter being changed doesn't affect how channels are configured.
> Such changes invoke a hardware command that might fail. The whole
> operation should be reverted in such cases, but the code that restores
> the parameters' values in the driver was missing. This commit adds this
> handling.
>
> Fixes: 2e20a151205b ("net/mlx5e: Fail safe mtu and lro setting")
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en_main.c | 30 +++++++++++++------
>  1 file changed, 21 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index ac76d32bad7d..a9d824a9cb05 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -3764,7 +3764,7 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
>         struct mlx5e_priv *priv = netdev_priv(netdev);
>         struct mlx5_core_dev *mdev = priv->mdev;
>         struct mlx5e_channels new_channels = {};
> -       struct mlx5e_params *old_params;
> +       struct mlx5e_params *cur_params;
>         int err = 0;
>         bool reset;
>
> @@ -3777,8 +3777,8 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
>                 goto out;
>         }
>
> -       old_params = &priv->channels.params;
> -       if (enable && !MLX5E_GET_PFLAG(old_params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
> +       cur_params = &priv->channels.params;
> +       if (enable && !MLX5E_GET_PFLAG(cur_params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
>                 netdev_warn(netdev, "can't set LRO with legacy RQ\n");
>                 err = -EINVAL;
>                 goto out;
> @@ -3786,18 +3786,23 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
>
>         reset = test_bit(MLX5E_STATE_OPENED, &priv->state);
>
> -       new_channels.params = *old_params;
> +       new_channels.params = *cur_params;
>         new_channels.params.lro_en = enable;
>
> -       if (old_params->rq_wq_type != MLX5_WQ_TYPE_CYCLIC) {
> -               if (mlx5e_rx_mpwqe_is_linear_skb(mdev, old_params, NULL) ==
> +       if (cur_params->rq_wq_type != MLX5_WQ_TYPE_CYCLIC) {
> +               if (mlx5e_rx_mpwqe_is_linear_skb(mdev, cur_params, NULL) ==
>                     mlx5e_rx_mpwqe_is_linear_skb(mdev, &new_channels.params, NULL))
>                         reset = false;
>         }
>
>         if (!reset) {
> -               *old_params = new_channels.params;
> +               struct mlx5e_params old_params;
> +
> +               old_params = *cur_params;
> +               *cur_params = new_channels.params;
>                 err = mlx5e_modify_tirs_lro(priv);
> +               if (err)
> +                       *cur_params = old_params;

No need to explicitly save and restore all params if the only one
changed is lro_en?
