Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 559A2806ED
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 17:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbfHCPCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 11:02:49 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:36531 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbfHCPCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 11:02:49 -0400
Received: by mail-io1-f65.google.com with SMTP id o9so55109541iom.3;
        Sat, 03 Aug 2019 08:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fo/kv+brWQ1flp7Vdkb8WoUBvAMa5Whd0L9OkVELuTQ=;
        b=PMPGtK8UFs07wgyVwxnfAQyx3EFb0wXBwNBqjDExProlToHDrO8vJ1hKOZY4+mtnY6
         EK1ULx/2yyTfRyW9lgo5KJwuJInKH2ClW5dsywvBbP+XNueqGOhItEYmxJNtP/DihL3j
         elV0Eh6W7RGnsfDsdt6UEcjakmGtslXbd3KiADHYYA+eGl2ne/yQJn0fJtvRFYrAysdc
         iJuLr3jxvoTZdXNjRUq60+UxbKic/xv1cG+Ph0uhlKsk45vC/7P8RTm/CmUkgMX+9qVS
         7pgB+Hi9W/JvahVts2rVeUCj3cf4QrWmrZt4Do/UV3DFbVDMZwwP5SO9eMKY8ZSUkb+t
         yq8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fo/kv+brWQ1flp7Vdkb8WoUBvAMa5Whd0L9OkVELuTQ=;
        b=Erh04UxC24116R9oFA/aP+VpEpTOVqY/aSFHC0qQLuqSyGK0P3Z0b1b6oLUOWYU81D
         0wK1PLucb5pM6hiVon+lSeYLLAbvRIc7VA6i27kE/7Xw2z3ZNxbhRp6D+hTAdTt3kshX
         aTd87x2dYl6PQXmZnPWMWp0pLxoVK6Hp7/jemE82+O/+1shVdvyNh6y5oB1qgnWvwZaH
         Cl/+U7pSabiWVHS38kabH1FH32nN54L1/rOJJhWvHULXzrHWvWn1Gy9QrGrFcecMT3tk
         9xzD0qnkH9LuxDICS5ZVOxHMXnJWvepXPZbWjhHZAlfbDRMl47umVzRIMT923rb+/qIo
         BKAg==
X-Gm-Message-State: APjAAAW17REctFgznjxIqvuznV1dbubB2BU0hYl+g6hM0BgXs070ylD1
        Hu+XjGKdXj3RCjKHLKEKXBQlNGzZvkzWX34V5MJntY/g
X-Google-Smtp-Source: APXvYqxcf3eS9deQHUBrGtW7fFUKmTKrSFL7EwRO762escS+44kEsee8qFfmBQ4ZGsZsDRuvdb/3GYwhCE5lb9mohnE=
X-Received: by 2002:a5d:968b:: with SMTP id m11mr84322526ion.16.1564844567923;
 Sat, 03 Aug 2019 08:02:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190802151316.16011-1-colin.king@canonical.com>
In-Reply-To: <20190802151316.16011-1-colin.king@canonical.com>
From:   Parav Pandit <pandit.parav@gmail.com>
Date:   Sat, 3 Aug 2019 20:32:37 +0530
Message-ID: <CAG53R5VvSwYYVhSLpLpGyrPt6emLy_YCDBPjzWSng9EpVcQDoQ@mail.gmail.com>
Subject: Re: [PATCH][net-next][V2] net/mlx5: remove self-assignment on esw->dev
To:     Colin King <colin.king@canonical.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma <linux-rdma@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 3, 2019 at 7:54 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> There is a self assignment of esw->dev to itself, clean this up by
> removing it. Also make dev a const pointer.
>
> Addresses-Coverity: ("Self assignment")
> Fixes: 6cedde451399 ("net/mlx5: E-Switch, Verify support QoS element type")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>
> V2: make dev const
>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> index f4ace5f8e884..de0894b695e3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> @@ -1413,7 +1413,7 @@ static int esw_vport_egress_config(struct mlx5_eswitch *esw,
>
>  static bool element_type_supported(struct mlx5_eswitch *esw, int type)
>  {
> -       struct mlx5_core_dev *dev = esw->dev = esw->dev;
> +       const struct mlx5_core_dev *dev = esw->dev;
>
>         switch (type) {
>         case SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR:
> --
> 2.20.1
>
Reviewed-by: Parav Pandit <parav@mellanox.com>
