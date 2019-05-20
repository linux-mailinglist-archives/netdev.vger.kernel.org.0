Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C6E24214
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 22:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfETUYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 16:24:45 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:42443 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfETUYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 16:24:45 -0400
Received: by mail-yw1-f65.google.com with SMTP id s5so6375018ywd.9
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 13:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t2iJLLQCyJHs2H4OQ24HaVpIJQX2QU3zhKUF5k72x1c=;
        b=fn4xr/kt76lqUhw8oHIyRjLjKu+OfETjMMSEViOyxqF9sVmn/qDK5X7vsJgpJWvykz
         oD7OO81cHZJyscQWe4Pe3y131S4sOoR8s5CNhxyGhrEK7Ze9X1YvSCm5ZvQaxn1qrB83
         nO3RCef0cBjyRzFuQ/sZUCg5/R1wIfQ4+t3WeH/ORdTv+NHvcmQaZqxzriIWpL61vbXt
         x+3Rt2H8GMn0YwrC4tBYXuM2WJvPq24xMDePM2rNLhkDOm69UThD9diYYYyjTg3nvMnS
         efXgBy/H+NOcOKjYx1sAgA1HnXFsxugvvTh22zLhg3FQzTv+/bbfEUB8qGuKLyB7u0FQ
         A/Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t2iJLLQCyJHs2H4OQ24HaVpIJQX2QU3zhKUF5k72x1c=;
        b=Co4AgFR/55NnyJ7fHlN+dGMD2mOj4RUHBpspkYzrHPX6gSBLr7A7ShpzSy0Dpr7xta
         zcOO5AxoHL2X08Kr8h6xM5Qvf0Kwsrag+7L6nNDsTKB6Zrcdl4XX/1rEEtnPhDaoIBxp
         fjZwBVgP+tx8EwsX3nOrcCBRthhijsnqsDyPsXDUKw+3GL+sgRz0H6WCQDj8jDy08qse
         ErPxlNxOmDIIy6cD8Y5yU9rS7Ej/wNwpmG8aV9yZD2F6A9Z+fkkCUtiaevVAfESnJT0A
         jdwUS1KB50pbxQhtaz6AANCUzFEgOsm9tiG0FdN7Z403N1Vz8wSt1LT9aOPu4M5ChBWI
         Om+A==
X-Gm-Message-State: APjAAAUeM6R2sn2uwkvpE6sFkOIvAeoKDI7mD47PUwDFkDyF63eJ1zA1
        9IqTXKIRiB3qh9FXjOvjbwOe2m8wcR9BJhEc95G2gxO+
X-Google-Smtp-Source: APXvYqzAaEeCjCWC6/jaZCLoHcHtXcPKL+EpgOyuSGGlP5F/GfWTQryGqWbW9xqYOElq5/6v5VcF/kwEscA3UtoQMk8=
X-Received: by 2002:a81:241:: with SMTP id 62mr36361254ywc.109.1558383884783;
 Mon, 20 May 2019 13:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <1558140881-91716-1-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1558140881-91716-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Mon, 20 May 2019 23:24:33 +0300
Message-ID: <CAJ3xEMhAEMBBW=s_iWA=qD23w8q4PWzWT-QowGBNtCJJzHUysA@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5e: Allow removing representors netdev to other namespace
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 20, 2019 at 3:19 PM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> At most case, we use the ConnectX-5 NIC on compute node for VMs,
> but we will offload forwarding rules to NICs on gateway node.
> On the gateway node, we will install multiple NICs and set them to
> different dockers which contain different net namespace, different
> routing table. In this way, we can specify the agent process on one
> docker. More dockers mean more high throughput.

The vport (uplink and VF) representor netdev stands for the e-switch
side of things. If you put different
vport devices to different namespaces, you will not be able to forward
between them. It's the NIC side of things
(VF netdevice) which can/should be put to namespaces.

For example, with SW veth devices, suppose I we have two pairs
(v0,v1), (v2, v3) -- we create
a SW switch (linux bridge, ovs) with the uplink and v0/v2 as ports all
in a single name space
and we map v1 and v3 into application containers.

I am missing how can you make any use with vport reps belonging to the
same HW e-switch
on different name-spaces, maybe send chart?


>
> The commit abd3277287c7 ("net/mlx5e: Disallow changing name-space for VF representors")
> disallow it, but we can change it now for gateway use case.
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index 91e24f1..15e932f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -1409,7 +1409,7 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev)
>         netdev->watchdog_timeo    = 15 * HZ;
>
>
> -       netdev->features         |= NETIF_F_HW_TC | NETIF_F_NETNS_LOCAL;
> +       netdev->features         |= NETIF_F_HW_TC;
>         netdev->hw_features      |= NETIF_F_HW_TC;
>
>         netdev->hw_features    |= NETIF_F_SG;
> --
> 1.8.3.1
>
