Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61B53E5A1C
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 14:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240660AbhHJMjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 08:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238837AbhHJMjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 08:39:51 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E41C0613D3;
        Tue, 10 Aug 2021 05:39:28 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id b11so9928179wrx.6;
        Tue, 10 Aug 2021 05:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZSRzoSA2t8YRZ5fOx5Fbc4xPbuPuUn7naOlSon+TzSs=;
        b=lWFwkmvNI3RaxR9qgSL8YegqndgVbubiGzxNg+N1f7nkcNmiJPERvkhcmBcqPpMYjj
         TtEIaURzPoeg5fvcwsHwujIHtMJipMHSMMpruHESKm2erGSPHcLxV1HPC0B7BMilRop4
         BQUIFWa1Jm4HZg9YAh7/5tKaHxyk+sdq+Xm7q1MRoA2KB3AVlAIwmvXs1tnwxrd0OXaG
         7CDfltKti2dnc6oARCe+bejx/fzw9bvvoPKgASTdOhvkSBhGGSNRz6GccR7yPNj/LQ75
         9J/oN995B/KFgWc2n5R3zSwFc8Mq4cWXWqH7aLdAG1yFMlvodXVPePj+fc7qXwI//dZD
         UdPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZSRzoSA2t8YRZ5fOx5Fbc4xPbuPuUn7naOlSon+TzSs=;
        b=TilHSuhzYk2EiOFemY/X07c+towgElgP2Eq+foH1qoLz9z3vCmsecbIa9+ls+neNsO
         yYTBDETNm64ydla+fJaWTC1IT8Ovs8OQSX2/4qc/UvhC1nvqSWTXEfAp71lvawX4iDA7
         fd22mk/g9ovPvNpdmdWt3GKbKX5fu4z8UFK70ZqYo2VXQ4oTR6tL4ddyDCadlSPfHF7V
         OKBLtyhSVRDv+r29Dxd2yN/G/KFdZpB2eZTPXlgPH7HGbv4o+52nXl7QcSlNH9FrJfcz
         GRXlOj/LXkHnx2+61DtTJ/qYLmXB54IVkv76gTu+dqjrZnGvcKryK7GaK8y29zuQMQx7
         7ckA==
X-Gm-Message-State: AOAM533S/1gp1aZJneN6ZDA0Go8b2tYQG3GoNpcnLYkrSlGVYGURCfWa
        +DMoJ5H3dcPSdsx+o8JX8WXirjdAuA4v3UGEPHY=
X-Google-Smtp-Source: ABdhPJycm2GkV6tG6c/VlZ4zPJikCSjwOWConK+i3Dja3Nyxa1Lzm0qFgRnV2GfpYZi6LSfiBF6TniOly6cBKI8kSUg=
X-Received: by 2002:adf:ef4b:: with SMTP id c11mr30465219wrp.35.1628599167553;
 Tue, 10 Aug 2021 05:39:27 -0700 (PDT)
MIME-Version: 1.0
References: <6859503f7e3e6cd706bf01ef06f1cae8c0b0970b.1628449004.git.leonro@nvidia.com>
In-Reply-To: <6859503f7e3e6cd706bf01ef06f1cae8c0b0970b.1628449004.git.leonro@nvidia.com>
From:   Prabhakar Kushwaha <prabhakar.pkin@gmail.com>
Date:   Tue, 10 Aug 2021 18:08:51 +0530
Message-ID: <CAJ2QiJLJk73RDS_XwQ0FY0ODq9qXbmiEZ2Y8Fkz9vVheK4he8g@mail.gmail.com>
Subject: Re: [PATCH net-next] devlink: Set device as early as possible
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Linu Cherian <lcherian@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org, linux-staging@lists.linux.dev,
        Manish Chopra <manishc@marvell.com>,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Shai Malin <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>, rtoshniwal@marvell.com,
        Omkar Kulkarni <okulkarni@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

On Mon, Aug 9, 2021 at 12:33 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> All kernel devlink implementations call to devlink_alloc() during
> initialization routine for specific device which is used later as
> a parent device for devlink_register().
>
> Such late device assignment causes to the situation which requires us to
> call to device_register() before setting other parameters, but that call
> opens devlink to the world and makes accessible for the netlink users.
>
> Any attempt to move devlink_register() to be the last call generates the
> following error due to access to the devlink->dev pointer.
>
> [    8.758862]  devlink_nl_param_fill+0x2e8/0xe50
> [    8.760305]  devlink_param_notify+0x6d/0x180
> [    8.760435]  __devlink_params_register+0x2f1/0x670
> [    8.760558]  devlink_params_register+0x1e/0x20
>
> The simple change of API to set devlink device in the devlink_alloc()
> instead of devlink_register() fixes all this above and ensures that
> prior to call to devlink_register() everything already set.
>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  9 ++++---
>  .../net/ethernet/cavium/liquidio/lio_main.c   |  5 ++--
>  .../freescale/dpaa2/dpaa2-eth-devlink.c       |  5 ++--
>  .../hisilicon/hns3/hns3pf/hclge_devlink.c     |  4 +--
>  .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |  7 ++---
>  .../net/ethernet/huawei/hinic/hinic_devlink.c |  8 +++---
>  .../net/ethernet/huawei/hinic/hinic_devlink.h |  4 +--
>  .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  2 +-
>  .../net/ethernet/huawei/hinic/hinic_main.c    |  2 +-
>  drivers/net/ethernet/intel/ice/ice_devlink.c  |  4 +--
>  .../marvell/octeontx2/af/rvu_devlink.c        |  5 ++--
>  .../marvell/prestera/prestera_devlink.c       |  7 ++---
>  .../marvell/prestera/prestera_devlink.h       |  2 +-
>  .../ethernet/marvell/prestera/prestera_main.c |  2 +-
>  drivers/net/ethernet/mellanox/mlx4/main.c     |  4 +--
>  .../net/ethernet/mellanox/mlx5/core/devlink.c |  9 ++++---
>  .../net/ethernet/mellanox/mlx5/core/devlink.h |  4 +--
>  .../net/ethernet/mellanox/mlx5/core/main.c    |  4 +--
>  .../mellanox/mlx5/core/sf/dev/driver.c        |  2 +-
>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  5 ++--
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c    |  5 ++--
>  drivers/net/ethernet/netronome/nfp/nfp_main.c |  2 +-
>  .../net/ethernet/netronome/nfp/nfp_net_main.c |  2 +-
>  .../ethernet/pensando/ionic/ionic_devlink.c   |  4 +--
>  drivers/net/ethernet/qlogic/qed/qed_devlink.c |  5 ++--
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  4 +--
>  drivers/net/ethernet/ti/cpsw_new.c            |  4 +--
>  drivers/net/netdevsim/dev.c                   |  4 +--
>  drivers/ptp/ptp_ocp.c                         | 26 +++----------------
>  drivers/staging/qlge/qlge_main.c              |  5 ++--
>  include/net/devlink.h                         | 10 ++++---
>  net/core/devlink.c                            | 15 +++++------
>  net/dsa/dsa2.c                                |  5 ++--
>  33 files changed, 91 insertions(+), 94 deletions(-)
>

<snip>

>
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index ccbfb3a844aa..0236c77f2fd0 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1544,13 +1544,15 @@ struct net *devlink_net(const struct devlink *devlink);
>   * Drivers that operate on real HW must use devlink_alloc() instead.
>   */
>  struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
> -                                size_t priv_size, struct net *net);
> +                                size_t priv_size, struct net *net,
> +                                struct device *dev);
>  static inline struct devlink *devlink_alloc(const struct devlink_ops *ops,
> -                                           size_t priv_size)
> +                                           size_t priv_size,
> +                                           struct device *dev)
>  {
> -       return devlink_alloc_ns(ops, priv_size, &init_net);
> +       return devlink_alloc_ns(ops, priv_size, &init_net, dev);
>  }
> -int devlink_register(struct devlink *devlink, struct device *dev);
> +int devlink_register(struct devlink *devlink);
>  void devlink_unregister(struct devlink *devlink);
>  void devlink_reload_enable(struct devlink *devlink);
>  void devlink_reload_disable(struct devlink *devlink);
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index ee95eee8d0ed..d3b16dd9f64e 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -8768,24 +8768,26 @@ static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
>   *     @ops: ops
>   *     @priv_size: size of user private data
>   *     @net: net namespace
> + *     @dev: parent device
>   *
>   *     Allocate new devlink instance resources, including devlink index
>   *     and name.
>   */
>  struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
> -                                size_t priv_size, struct net *net)
> +                                size_t priv_size, struct net *net,
> +                                struct device *dev)
>  {
>         struct devlink *devlink;
>
> -       if (WARN_ON(!ops))
> -               return NULL;
> -
> +       WARN_ON(!ops || !dev);
>         if (!devlink_reload_actions_valid(ops))
>                 return NULL;
>
>         devlink = kzalloc(sizeof(*devlink) + priv_size, GFP_KERNEL);
>         if (!devlink)
>                 return NULL;
> +
> +       devlink->dev = dev;
>         devlink->ops = ops;
>         xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
>         write_pnet(&devlink->_net, net);
> @@ -8810,12 +8812,9 @@ EXPORT_SYMBOL_GPL(devlink_alloc_ns);
>   *     devlink_register - Register devlink instance
>   *
>   *     @devlink: devlink
> - *     @dev: parent device
>   */

This patch is converting devlink_alloc() to devlink_alloc_register().

There are 2 APIs: devlink_alloc() and devlink_register().
Both APIs can be used in a scenario,
              Where devlink_alloc() can be done by code written around
one struct dev and used by another struct dev.
or
This scenario is not even a valid scenario?

> -int devlink_register(struct devlink *devlink, struct device *dev)
> +int devlink_register(struct devlink *devlink)
>  {
> -       WARN_ON(devlink->dev);
> -       devlink->dev = dev;
>         mutex_lock(&devlink_mutex);
>         list_add_tail(&devlink->list, &devlink_list);
>         devlink_notify(devlink, DEVLINK_CMD_NEW);

Considering device registration has been moved to devlink_alloc().
Can the remaining code of devlink_register() be also moved in devlink_alloc()?

--pk
