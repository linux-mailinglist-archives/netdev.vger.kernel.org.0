Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA40C20C4B6
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 00:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgF0WfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 18:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgF0WfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 18:35:10 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BB7C061794
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 15:35:10 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id i14so12664811ejr.9
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 15:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0BrLCvidFZELgIARMU9LVB5eaj4VUWzMyQ3UB7DHga0=;
        b=cexB3DnnKhoe7UA8l7kRsRsUPR1dDyPn3wkaY1IPVJhRw2BzZgnwfp8zp/x3Z00woy
         RDmTQDIPNCG6Ipm0vn69RvU603SXSTQPmFdo3PVxiO16fii/E6XlOlQWPwX3ONRPi8Bv
         gqhjO9qb5/dD07sGn9EGjMbvONHBvQNbQfVPl+J4YtkQZkvexEWVMxQflPb1VrF1Hvb7
         yostAiLCgZy/jM3zw7tlNWQZSvWnv6LQ6kHHLpWyTOPGsMjeeJk3dNT+o0WVybkwjS4+
         fBi12g3E4U3vtQasp82/dZhMKTzQ7v8AHw/IAweCSAjCqwt+EAD4G09KzJ6IuXvlAn5/
         0oYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0BrLCvidFZELgIARMU9LVB5eaj4VUWzMyQ3UB7DHga0=;
        b=emszbYbzBxPU9VIricRlonluRKd0gXR5+usdn8aBLG+UrVvut0RwMHSkXpqmQYTQT0
         Jgt2YBilJWjfsHPOH5KziteFpSGuOIkn3RlJrQ2+TBfFr00GhK1DBBMwh7ckjk1x/XAu
         Hz0/Pfi3NrMFy57UFx3PqTlCvfA3Odt7vQH/dn/0M4NwH3Hy5Xf7X0Ksp1kgvZivcouD
         80vgAgKUKlFyFrEAx47uvNzrpaXId4McUQBIQW3C4fRRrGXBh57GsSKUHJixZwBoazDj
         +yhICBpRT1tJ+0TcoGZd4ReNklqfCbUnir52GV1okuRtXGdtURsTQkdzeqd+eFYi3UYF
         gB1g==
X-Gm-Message-State: AOAM530ekGGjALsU7V4Hv6bmcsL5Kqh806c4pNpBVdUUC92md+3IH9O0
        hQGqc9hCcHbHjH5OuQ9/sKX7Ju7s37CaNj/QvptQOg==
X-Google-Smtp-Source: ABdhPJxVh7gfAyf6WMY/JKtcDLrr/r2GRqHaUmN3cv6IeyIQL8RjxxN8iiG6vXu9/h9mA23ZdfhHtlf76lMqlytwB0s=
X-Received: by 2002:a17:906:b817:: with SMTP id dv23mr7992158ejb.185.1593297308773;
 Sat, 27 Jun 2020 15:35:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200627211727.259569-1-saeedm@mellanox.com> <20200627211727.259569-5-saeedm@mellanox.com>
In-Reply-To: <20200627211727.259569-5-saeedm@mellanox.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Sat, 27 Jun 2020 15:34:57 -0700
Message-ID: <CALx6S37gn4mQx97xXUPpjW4Fm9NxOwfagunhygHrvaGS5Uxs4w@mail.gmail.com>
Subject: Re: [net-next 04/15] net/mlx5e: Receive flow steering framework for
 accelerated TCP flows
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Boris Pismenny <borisp@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 2:19 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> From: Boris Pismenny <borisp@mellanox.com>
>
> The framework allows creating flow tables to steer incoming traffic of
> TCP sockets to the acceleration TIRs.
> This is used in downstream patches for TLS, and will be used in the
> future for other offloads.
>
> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
>  .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  10 +
>  .../mellanox/mlx5/core/en_accel/fs_tcp.c      | 280 ++++++++++++++++++
>  .../mellanox/mlx5/core/en_accel/fs_tcp.h      |  18 ++
>  .../net/ethernet/mellanox/mlx5/core/fs_core.c |   4 +-

Saeed,

What is the relationship between this and RFS, accelerated RFS, and
now PTQ? Is this something that we can generalize in the stack and
support in the driver/device with a simple interface like we do with
aRFS and ndo_rx_flow_steer?

Tom

>  5 files changed, 311 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
> index b61e47bc16e8..8ffa1325a18f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
> @@ -74,7 +74,7 @@ mlx5_core-$(CONFIG_MLX5_EN_IPSEC) += en_accel/ipsec.o en_accel/ipsec_rxtx.o \
>                                      en_accel/ipsec_stats.o
>
>  mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/tls.o en_accel/tls_rxtx.o en_accel/tls_stats.o \
> -                                  en_accel/ktls.o en_accel/ktls_tx.o
> +                                  en_accel/ktls.o en_accel/ktls_tx.o en_accel/fs_tcp.o
>
>  mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o \
>                                         steering/dr_matcher.o steering/dr_rule.o \
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
> index c633579474c3..385cbff1caf1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
> @@ -123,6 +123,9 @@ enum {
>         MLX5E_L2_FT_LEVEL,
>         MLX5E_TTC_FT_LEVEL,
>         MLX5E_INNER_TTC_FT_LEVEL,
> +#ifdef CONFIG_MLX5_EN_TLS
> +       MLX5E_ACCEL_FS_TCP_FT_LEVEL,
> +#endif
>  #ifdef CONFIG_MLX5_EN_ARFS
>         MLX5E_ARFS_FT_LEVEL
>  #endif
> @@ -216,6 +219,10 @@ static inline int mlx5e_arfs_enable(struct mlx5e_priv *priv) { return -EOPNOTSUP
>  static inline int mlx5e_arfs_disable(struct mlx5e_priv *priv) {        return -EOPNOTSUPP; }
>  #endif
>
> +#ifdef CONFIG_MLX5_EN_TLS
> +struct mlx5e_accel_fs_tcp;
> +#endif
> +
>  struct mlx5e_flow_steering {
>         struct mlx5_flow_namespace      *ns;
>  #ifdef CONFIG_MLX5_EN_RXNFC
> @@ -229,6 +236,9 @@ struct mlx5e_flow_steering {
>  #ifdef CONFIG_MLX5_EN_ARFS
>         struct mlx5e_arfs_tables        arfs;
>  #endif
> +#ifdef CONFIG_MLX5_EN_TLS
> +       struct mlx5e_accel_fs_tcp      *accel_tcp;
> +#endif
>  };
>
>  struct ttc_params {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
> new file mode 100644
> index 000000000000..a0e9082e15b0
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
> @@ -0,0 +1,280 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
> +
> +#include <linux/netdevice.h>
> +#include "en_accel/fs_tcp.h"
> +#include "fs_core.h"
> +
> +enum accel_fs_tcp_type {
> +       ACCEL_FS_IPV4_TCP,
> +       ACCEL_FS_IPV6_TCP,
> +       ACCEL_FS_TCP_NUM_TYPES,
> +};
> +
> +struct mlx5e_accel_fs_tcp {
> +       struct mlx5e_flow_table tables[ACCEL_FS_TCP_NUM_TYPES];
> +       struct mlx5_flow_handle *default_rules[ACCEL_FS_TCP_NUM_TYPES];
> +};
> +
> +static enum mlx5e_traffic_types fs_accel2tt(enum accel_fs_tcp_type i)
> +{
> +       switch (i) {
> +       case ACCEL_FS_IPV4_TCP:
> +               return MLX5E_TT_IPV4_TCP;
> +       default: /* ACCEL_FS_IPV6_TCP */
> +               return MLX5E_TT_IPV6_TCP;
> +       }
> +}
> +
> +static int accel_fs_tcp_add_default_rule(struct mlx5e_priv *priv,
> +                                        enum accel_fs_tcp_type type)
> +{
> +       struct mlx5e_flow_table *accel_fs_t;
> +       struct mlx5_flow_destination dest;
> +       struct mlx5e_accel_fs_tcp *fs_tcp;
> +       MLX5_DECLARE_FLOW_ACT(flow_act);
> +       struct mlx5_flow_handle *rule;
> +       int err = 0;
> +
> +       fs_tcp = priv->fs.accel_tcp;
> +       accel_fs_t = &fs_tcp->tables[type];
> +
> +       dest = mlx5e_ttc_get_default_dest(priv, fs_accel2tt(type));
> +       rule = mlx5_add_flow_rules(accel_fs_t->t, NULL, &flow_act, &dest, 1);
> +       if (IS_ERR(rule)) {
> +               err = PTR_ERR(rule);
> +               netdev_err(priv->netdev,
> +                          "%s: add default rule failed, accel_fs type=%d, err %d\n",
> +                          __func__, type, err);
> +               return err;
> +       }
> +
> +       fs_tcp->default_rules[type] = rule;
> +       return 0;
> +}
> +
> +#define MLX5E_ACCEL_FS_TCP_NUM_GROUPS  (2)
> +#define MLX5E_ACCEL_FS_TCP_GROUP1_SIZE (BIT(16) - 1)
> +#define MLX5E_ACCEL_FS_TCP_GROUP2_SIZE (BIT(0))
> +#define MLX5E_ACCEL_FS_TCP_TABLE_SIZE  (MLX5E_ACCEL_FS_TCP_GROUP1_SIZE +\
> +                                        MLX5E_ACCEL_FS_TCP_GROUP2_SIZE)
> +static int accel_fs_tcp_create_groups(struct mlx5e_flow_table *ft,
> +                                     enum accel_fs_tcp_type type)
> +{
> +       int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
> +       void *outer_headers_c;
> +       int ix = 0;
> +       u32 *in;
> +       int err;
> +       u8 *mc;
> +
> +       ft->g = kcalloc(MLX5E_ACCEL_FS_TCP_NUM_GROUPS, sizeof(*ft->g), GFP_KERNEL);
> +       in = kvzalloc(inlen, GFP_KERNEL);
> +       if  (!in || !ft->g) {
> +               kvfree(ft->g);
> +               kvfree(in);
> +               return -ENOMEM;
> +       }
> +
> +       mc = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
> +       outer_headers_c = MLX5_ADDR_OF(fte_match_param, mc, outer_headers);
> +       MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c, ip_protocol);
> +       MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c, ip_version);
> +
> +       switch (type) {
> +       case ACCEL_FS_IPV4_TCP:
> +       case ACCEL_FS_IPV6_TCP:
> +               MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c, tcp_dport);
> +               MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c, tcp_sport);
> +               break;
> +       default:
> +               err = -EINVAL;
> +               goto out;
> +       }
> +
> +       switch (type) {
> +       case ACCEL_FS_IPV4_TCP:
> +               MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c,
> +                                src_ipv4_src_ipv6.ipv4_layout.ipv4);
> +               MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c,
> +                                dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
> +               break;
> +       case ACCEL_FS_IPV6_TCP:
> +               memset(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_c,
> +                                   src_ipv4_src_ipv6.ipv6_layout.ipv6),
> +                      0xff, 16);
> +               memset(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_c,
> +                                   dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
> +                      0xff, 16);
> +               break;
> +       default:
> +               err = -EINVAL;
> +               goto out;
> +       }
> +
> +       MLX5_SET_CFG(in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
> +       MLX5_SET_CFG(in, start_flow_index, ix);
> +       ix += MLX5E_ACCEL_FS_TCP_GROUP1_SIZE;
> +       MLX5_SET_CFG(in, end_flow_index, ix - 1);
> +       ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
> +       if (IS_ERR(ft->g[ft->num_groups]))
> +               goto err;
> +       ft->num_groups++;
> +
> +       /* Default Flow Group */
> +       memset(in, 0, inlen);
> +       MLX5_SET_CFG(in, start_flow_index, ix);
> +       ix += MLX5E_ACCEL_FS_TCP_GROUP2_SIZE;
> +       MLX5_SET_CFG(in, end_flow_index, ix - 1);
> +       ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
> +       if (IS_ERR(ft->g[ft->num_groups]))
> +               goto err;
> +       ft->num_groups++;
> +
> +       kvfree(in);
> +       return 0;
> +
> +err:
> +       err = PTR_ERR(ft->g[ft->num_groups]);
> +       ft->g[ft->num_groups] = NULL;
> +out:
> +       kvfree(in);
> +
> +       return err;
> +}
> +
> +static int accel_fs_tcp_create_table(struct mlx5e_priv *priv, enum accel_fs_tcp_type type)
> +{
> +       struct mlx5e_flow_table *ft = &priv->fs.accel_tcp->tables[type];
> +       struct mlx5_flow_table_attr ft_attr = {};
> +       int err;
> +
> +       ft->num_groups = 0;
> +
> +       ft_attr.max_fte = MLX5E_ACCEL_FS_TCP_TABLE_SIZE;
> +       ft_attr.level = MLX5E_ACCEL_FS_TCP_FT_LEVEL;
> +       ft_attr.prio = MLX5E_NIC_PRIO;
> +
> +       ft->t = mlx5_create_flow_table(priv->fs.ns, &ft_attr);
> +       if (IS_ERR(ft->t)) {
> +               err = PTR_ERR(ft->t);
> +               ft->t = NULL;
> +               return err;
> +       }
> +
> +       netdev_dbg(priv->netdev, "Created fs accel table id %u level %u\n",
> +                  ft->t->id, ft->t->level);
> +
> +       err = accel_fs_tcp_create_groups(ft, type);
> +       if (err)
> +               goto err;
> +
> +       err = accel_fs_tcp_add_default_rule(priv, type);
> +       if (err)
> +               goto err;
> +
> +       return 0;
> +err:
> +       mlx5e_destroy_flow_table(ft);
> +       return err;
> +}
> +
> +static int accel_fs_tcp_disable(struct mlx5e_priv *priv)
> +{
> +       int err, i;
> +
> +       for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++) {
> +               /* Modify ttc rules destination to point back to the indir TIRs */
> +               err = mlx5e_ttc_fwd_default_dest(priv, fs_accel2tt(i));
> +               if (err) {
> +                       netdev_err(priv->netdev,
> +                                  "%s: modify ttc[%d] default destination failed, err(%d)\n",
> +                                  __func__, fs_accel2tt(i), err);
> +                       return err;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +static int accel_fs_tcp_enable(struct mlx5e_priv *priv)
> +{
> +       struct mlx5_flow_destination dest = {};
> +       int err, i;
> +
> +       dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
> +       for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++) {
> +               dest.ft = priv->fs.accel_tcp->tables[i].t;
> +
> +               /* Modify ttc rules destination to point on the accel_fs FTs */
> +               err = mlx5e_ttc_fwd_dest(priv, fs_accel2tt(i), &dest);
> +               if (err) {
> +                       netdev_err(priv->netdev,
> +                                  "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
> +                                  __func__, fs_accel2tt(i), err);
> +                       return err;
> +               }
> +       }
> +       return 0;
> +}
> +
> +static void accel_fs_tcp_destroy_table(struct mlx5e_priv *priv, int i)
> +{
> +       struct mlx5e_accel_fs_tcp *fs_tcp;
> +
> +       fs_tcp = priv->fs.accel_tcp;
> +       if (IS_ERR_OR_NULL(fs_tcp->tables[i].t))
> +               return;
> +
> +       mlx5_del_flow_rules(fs_tcp->default_rules[i]);
> +       mlx5e_destroy_flow_table(&fs_tcp->tables[i]);
> +       fs_tcp->tables[i].t = NULL;
> +}
> +
> +void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv)
> +{
> +       int i;
> +
> +       if (!priv->fs.accel_tcp)
> +               return;
> +
> +       accel_fs_tcp_disable(priv);
> +
> +       for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
> +               accel_fs_tcp_destroy_table(priv, i);
> +
> +       kfree(priv->fs.accel_tcp);
> +       priv->fs.accel_tcp = NULL;
> +}
> +
> +int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv)
> +{
> +       int i, err;
> +
> +       if (!MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ft_field_support.outer_ip_version))
> +               return -EOPNOTSUPP;
> +
> +       priv->fs.accel_tcp = kzalloc(sizeof(*priv->fs.accel_tcp), GFP_KERNEL);
> +       if (!priv->fs.accel_tcp)
> +               return -ENOMEM;
> +
> +       for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++) {
> +               err = accel_fs_tcp_create_table(priv, i);
> +               if (err)
> +                       goto err_destroy_tables;
> +       }
> +
> +       err = accel_fs_tcp_enable(priv);
> +       if (err)
> +               goto err_destroy_tables;
> +
> +       return 0;
> +
> +err_destroy_tables:
> +       while (--i >= 0)
> +               accel_fs_tcp_destroy_table(priv, i);
> +
> +       kfree(priv->fs.accel_tcp);
> +       priv->fs.accel_tcp = NULL;
> +       return err;
> +}
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
> new file mode 100644
> index 000000000000..0df53473550a
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
> @@ -0,0 +1,18 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
> +/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
> +
> +#ifndef __MLX5E_ACCEL_FS_TCP_H__
> +#define __MLX5E_ACCEL_FS_TCP_H__
> +
> +#include "en.h"
> +
> +#ifdef CONFIG_MLX5_EN_TLS
> +int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv);
> +void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv);
> +#else
> +static inline int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv) { return 0; }
> +static inline void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv) {}
> +#endif
> +
> +#endif /* __MLX5E_ACCEL_FS_TCP_H__ */
> +
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
> index e47a66983935..785b2960d6b5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
> @@ -105,8 +105,8 @@
>  #define ETHTOOL_PRIO_NUM_LEVELS 1
>  #define ETHTOOL_NUM_PRIOS 11
>  #define ETHTOOL_MIN_LEVEL (KERNEL_MIN_LEVEL + ETHTOOL_NUM_PRIOS)
> -/* Vlan, mac, ttc, inner ttc, aRFS */
> -#define KERNEL_NIC_PRIO_NUM_LEVELS 5
> +/* Vlan, mac, ttc, inner ttc, {aRFS/accel} */
> +#define KERNEL_NIC_PRIO_NUM_LEVELS 6
>  #define KERNEL_NIC_NUM_PRIOS 1
>  /* One more level for tc */
>  #define KERNEL_MIN_LEVEL (KERNEL_NIC_PRIO_NUM_LEVELS + 1)
> --
> 2.26.2
>
