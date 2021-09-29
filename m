Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F1E41C623
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 15:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344352AbhI2N5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 09:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244987AbhI2N5d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 09:57:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93920613D1;
        Wed, 29 Sep 2021 13:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632923752;
        bh=40noVjUADcTFuL18AWlGlA5AqcgIKtJPa+QjlNndmaA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TXfiJIOjDYkjlTD+FmCDLSeBSzFecqoscMatnM7hRJz6j32y6GJB5hP8vfTt6JtQw
         gn9IlvE39J2vPbTRVUjz/jaT1L06lP4uP3LB0zCIkKE19K7ZX7zpsQT4XmXdM9B3iy
         n2nfvYiL7HU7s8inrnWIlJkpF247sn7mwN75YafcAT+/81FgXfryg4c2QAJFCt3D9j
         ZSL6MbbLr8QpNIW+tnfQcnHcw8vhN2rd8/kZZ/1VvZZr/OQDqKCuAkkyMyIRCyYbsS
         0inDhEXaYXr29LaGJbQDn0nEnUJH5BtJeJ6S5lwBpW7pky/dWO5mnEJNlMzLVnU0ir
         pugj5/zEYMKlg==
Date:   Wed, 29 Sep 2021 06:55:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Eric Dumazet <eric.dumazet@gmail.com>,
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
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Manish Chopra <manishc@marvell.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@nvidia.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
        Shannon Nelson <snelson@pensando.io>,
        Shay Drory <shayd@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v1 4/5] net/mlx5: Register separate reload
 devlink ops for multiport device
Message-ID: <20210929065549.43b13203@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a8bf9a036fe0a590df830a77a31cc81c355f525d.1632916329.git.leonro@nvidia.com>
References: <cover.1632916329.git.leonro@nvidia.com>
        <a8bf9a036fe0a590df830a77a31cc81c355f525d.1632916329.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 15:00:45 +0300 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> Mulitport slave device doesn't support devlink reload, so instead of
> complicating initialization flow with devlink_reload_enable() which
> will be removed in next patch, set specialized devlink ops callbacks
> for reload operations.
>=20
> This fixes an error when reload counters exposed (and equal zero) for
> the mode that is not supported at all.
>=20
> Fixes: d89ddaae1766 ("net/mlx5: Disable devlink reload for multi port sla=
ve device")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/=
net/ethernet/mellanox/mlx5/core/devlink.c
> index 47c9f7f5bb79..e85eca6976a9 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> @@ -309,14 +309,17 @@ static struct devlink_ops mlx5_devlink_ops =3D {
>  #endif
>  	.flash_update =3D mlx5_devlink_flash_update,
>  	.info_get =3D mlx5_devlink_info_get,
> +	.trap_init =3D mlx5_devlink_trap_init,
> +	.trap_fini =3D mlx5_devlink_trap_fini,
> +	.trap_action_set =3D mlx5_devlink_trap_action_set,
> +};
> +
> +static struct devlink_ops mlx5_devlink_reload =3D {
>  	.reload_actions =3D BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
>  			  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
>  	.reload_limits =3D BIT(DEVLINK_RELOAD_LIMIT_NO_RESET),
>  	.reload_down =3D mlx5_devlink_reload_down,
>  	.reload_up =3D mlx5_devlink_reload_up,
> -	.trap_init =3D mlx5_devlink_trap_init,
> -	.trap_fini =3D mlx5_devlink_trap_fini,
> -	.trap_action_set =3D mlx5_devlink_trap_action_set,
>  };
> =20
>  void mlx5_devlink_trap_report(struct mlx5_core_dev *dev, int trap_id, st=
ruct sk_buff *skb,
> @@ -791,6 +794,7 @@ static void mlx5_devlink_traps_unregister(struct devl=
ink *devlink)
> =20
>  int mlx5_devlink_register(struct devlink *devlink)
>  {
> +	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
>  	int err;
> =20
>  	err =3D devlink_params_register(devlink, mlx5_devlink_params,
> @@ -808,6 +812,9 @@ int mlx5_devlink_register(struct devlink *devlink)
>  	if (err)
>  		goto traps_reg_err;
> =20
> +	if (!mlx5_core_is_mp_slave(dev))
> +		devlink_set_ops(devlink, &mlx5_devlink_reload);

Does this work? Where do you make a copy of the ops? =F0=9F=A4=94 You can't=
 modify
the driver-global ops, to state the obvious.
