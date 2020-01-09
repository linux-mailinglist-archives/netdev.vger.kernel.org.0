Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA3501356ED
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 11:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730194AbgAIKcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 05:32:15 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:44165 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730167AbgAIKcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 05:32:09 -0500
Received: by mail-yw1-f68.google.com with SMTP id t141so2480339ywc.11
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 02:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z5nQ4am/whoyjhFBZzpPY6Fj7uyiRLVJF8ozpqJIS80=;
        b=vMM5dlwHQ/jv+68HuQDmsj3zwBGYMlew1lT41NUa1fqoQwfkVhtzG2vbZozjh3caO8
         pG+QeV5IO0pP5L4xPbSi0X3Onp1487FFQOJBoORHWiiCHwzEE5/G7Y9PbHmQdgTzGPBM
         l6/BGc4tujUL4q+zEoz7aedP2OtQMEM0UG9BDhh7jPXOA92we5ba8M8qC3WXv3uexP7b
         3phQ3eZpEGYTgO03XTp1v7Qe827zgoBQsFouyyK/SHvCq3H9t1jx8rTYV2qcWM5sXvhG
         5q8wK2+rFwfhLisOy77TnCiasniWvcq1wQPB67ugD54u6XFtRe4+T+2ZTVTsPrXhBeBX
         pEFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z5nQ4am/whoyjhFBZzpPY6Fj7uyiRLVJF8ozpqJIS80=;
        b=WssRXLe4wUSeQXjGBfVM66X1Wifve+6AX7YQWmJoFV3FPbaEdaCxYuPKvZdQQfqyI3
         RK49bX2GBQ40rUpdQgQlOKDxeEeex5zclgWZY/3HRS8wJ8C2IDQrHbjbEqSnhN+N2IR1
         edK/6YLa5/8MABuaiz1MLkrQJvNYeKckjzWVZn0lPLFYsrhulO0kM9UwlFSNxUHEqEBn
         fZsX9m6WE8VZ2ZSoV6zLenp2b3MZcNvlZYhxVkVwdl8QAF7KjfYIy3iBcmO5ARCgx8Wv
         ejUptk8CjSZ3QkQZiLaR3hlZY4yRIMGAMF/BbY9KFLaKMmYXThSBQvBaESZzNR7HN4kx
         GIpg==
X-Gm-Message-State: APjAAAV8uc2ohCoY9UdIhVzptLuifIVnoFZ3M3f7U00NcTySkj0uyPM5
        WTX6w59Q90i6gvV4opkfzn67n8L2+niLC5jjIg1OJQ==
X-Google-Smtp-Source: APXvYqyakPkQ8+OdSyvg7qLb/u6D4i9wsgT9UF4oh9upoVJORqY20zlQvBuRDATAOW3QezCVZ/zvmm1vWm4DVfNpYNE=
X-Received: by 2002:a81:7a07:: with SMTP id v7mr6779522ywc.109.1578565928495;
 Thu, 09 Jan 2020 02:32:08 -0800 (PST)
MIME-Version: 1.0
References: <1578390738-30712-1-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1578390738-30712-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Thu, 9 Jan 2020 12:31:57 +0200
Message-ID: <CAJ3xEMgR-pzqPCpt_SDiGr57sdgezWV3kW67CQzTXLk4TKRCmA@mail.gmail.com>
Subject: Re: [PATCH net-next] net/mlx5e: Don't allow forwarding between uplink
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Saeed Mahameed <saeedm@dev.mellanox.co.il>,
        Roi Dayan <roid@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 7, 2020 at 11:52 AM <xiangxia.m.yue@gmail.com> wrote:

> We can install forwarding packets rule between uplink
> in eswitchdev mode, as show below. But the hardware does
> not do that as expected (mlnx_perf -i $PF1, we can't get
> the counter of the PF1). By the way, if we add the uplink

yeah, IMOH there's probably a firmware bug under which installation
of this rule doesn't fail but as you said the traffic doesn't pass.

We don't fail the rule b/c due to what we call "merged eswitch"
which is a building block of the uplink LAG and  ECMP configurations
that we do support, the driver lets you install a flow from (say) VF0
on PF/uplink0 to uplink1 etc.

Talking to Roi, he prefers to further investigate / open a case to the FW
and later see if/how to block this rule in the driver.

> PF0, PF1 to Open vSwitch and enable hw-offload, the rules
> can be offloaded but not work fine too. This patch add a
> check and if so return -EOPNOTSUPP.
>
> $ tc filter add dev $PF0 protocol all parent ffff: prio 1 handle 1 \
>     flower skip_sw action mirred egress redirect dev $PF1
>
> $ tc -d -s filter show dev $PF0 ingress
>     skip_sw
>     in_hw in_hw_count 1
>     action order 1: mirred (Egress Redirect to device enp130s0f1) stolen
>         ...
>         Sent 408954 bytes 4173 pkt (dropped 0, overlimits 0 requeues 0)
>         Sent hardware 408954 bytes 4173 pkt
>         ...
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |  7 ++++++-
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.h |  1 +
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  | 16 +++++++++++++---
>  3 files changed, 20 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index f175cb2..63fad66 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -1434,10 +1434,15 @@ static struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
>         .ndo_set_features        = mlx5e_set_features,
>  };
>
> +bool mlx5e_eswitch_uplink_rep(struct net_device *netdev)
> +{
> +       return netdev->netdev_ops == &mlx5e_netdev_ops_uplink_rep;
> +}
> +
>  bool mlx5e_eswitch_rep(struct net_device *netdev)
>  {
>         if (netdev->netdev_ops == &mlx5e_netdev_ops_rep ||
> -           netdev->netdev_ops == &mlx5e_netdev_ops_uplink_rep)
> +           mlx5e_eswitch_uplink_rep(netdev))
>                 return true;
>
>         return false;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
> index 31f83c8..282c64b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
> @@ -198,6 +198,7 @@ void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
>
>  void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
>
> +bool mlx5e_eswitch_uplink_rep(struct net_device *netdev);
>  bool mlx5e_eswitch_rep(struct net_device *netdev);
>
>  #else /* CONFIG_MLX5_ESWITCH */
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index f91e057e..b2c18fa 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -3214,6 +3214,10 @@ static int add_vlan_pop_action(struct mlx5e_priv *priv,
>  bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
>                                     struct net_device *out_dev)
>  {
> +       if (mlx5e_eswitch_uplink_rep(priv->netdev) &&
> +           mlx5e_eswitch_uplink_rep(out_dev))
> +               return false;
> +
>         if (is_merged_eswitch_dev(priv, out_dev))
>                 return true;
>
> @@ -3339,9 +3343,15 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>
>                                 if (!mlx5e_is_valid_eswitch_fwd_dev(priv, out_dev)) {
>                                         NL_SET_ERR_MSG_MOD(extack,
> -                                                          "devices are not on same switch HW, can't offload forwarding");
> -                                       pr_err("devices %s %s not on same switch HW, can't offload forwarding\n",
> -                                              priv->netdev->name, out_dev->name);
> +                                                          "devices are both uplink "
> +                                                          "or not on same switch HW, "
> +                                                          "can't offload forwarding");
> +                                       pr_err("devices %s %s are both uplink "
> +                                              "or not on same switch HW, "
> +                                              "can't offload forwarding\n",
> +                                              priv->netdev->name,
> +                                              out_dev->name);
> +
>                                         return -EOPNOTSUPP;
>                                 }
>
> --
> 1.8.3.1
>
