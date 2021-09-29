Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBEC41C684
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 16:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343930AbhI2OSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 10:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343948AbhI2OSM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 10:18:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCAB4613A7;
        Wed, 29 Sep 2021 14:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632924991;
        bh=x8PJgYHBfZYy5vbHjr7vMOaIkyPKYTkxWVBFHp1eeg4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BGIbu/AGlYFcQKLeJl04hR8MvgPE1d1akDokD6itR1bgBlPElkeaHjQx8b9s1Ymuz
         rnHg724w0U0TGgmuRYa1eHCai5JMHXj1ifyKegB++KTqB9iDoVdgTVgfLotJ2/TyZ1
         DdN68VCwdXXxT36Ly3efz3HJ7qZrHrvX8gytj8GGpcIzpSiVG/hgUDV10GzodN1g6k
         u4zFNgbjNcTbb7weVWrq/JWAijjVLRXb0DSPhop90H1FXzaKPMywXqIfoKSG7c9a9r
         gVLcnKb/RmxNGe/jznBrXa/HEsVN11EVYbKMjwGBXJikb4RfhdhQo91BWLcVObrTWp
         +X4HpqZlazHNQ==
Date:   Wed, 29 Sep 2021 17:16:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
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
Message-ID: <YVR1PKQjsBfvUTPU@unreal>
References: <cover.1632916329.git.leonro@nvidia.com>
 <a8bf9a036fe0a590df830a77a31cc81c355f525d.1632916329.git.leonro@nvidia.com>
 <20210929065549.43b13203@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210929065549.43b13203@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 06:55:49AM -0700, Jakub Kicinski wrote:
> On Wed, 29 Sep 2021 15:00:45 +0300 Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Mulitport slave device doesn't support devlink reload, so instead of
> > complicating initialization flow with devlink_reload_enable() which
> > will be removed in next patch, set specialized devlink ops callbacks
> > for reload operations.
> > 
> > This fixes an error when reload counters exposed (and equal zero) for
> > the mode that is not supported at all.
> > 
> > Fixes: d89ddaae1766 ("net/mlx5: Disable devlink reload for multi port slave device")
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> > index 47c9f7f5bb79..e85eca6976a9 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> > @@ -309,14 +309,17 @@ static struct devlink_ops mlx5_devlink_ops = {
> >  #endif
> >  	.flash_update = mlx5_devlink_flash_update,
> >  	.info_get = mlx5_devlink_info_get,
> > +	.trap_init = mlx5_devlink_trap_init,
> > +	.trap_fini = mlx5_devlink_trap_fini,
> > +	.trap_action_set = mlx5_devlink_trap_action_set,
> > +};
> > +
> > +static struct devlink_ops mlx5_devlink_reload = {
> >  	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
> >  			  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
> >  	.reload_limits = BIT(DEVLINK_RELOAD_LIMIT_NO_RESET),
> >  	.reload_down = mlx5_devlink_reload_down,
> >  	.reload_up = mlx5_devlink_reload_up,
> > -	.trap_init = mlx5_devlink_trap_init,
> > -	.trap_fini = mlx5_devlink_trap_fini,
> > -	.trap_action_set = mlx5_devlink_trap_action_set,
> >  };
> >  
> >  void mlx5_devlink_trap_report(struct mlx5_core_dev *dev, int trap_id, struct sk_buff *skb,
> > @@ -791,6 +794,7 @@ static void mlx5_devlink_traps_unregister(struct devlink *devlink)
> >  
> >  int mlx5_devlink_register(struct devlink *devlink)
> >  {
> > +	struct mlx5_core_dev *dev = devlink_priv(devlink);
> >  	int err;
> >  
> >  	err = devlink_params_register(devlink, mlx5_devlink_params,
> > @@ -808,6 +812,9 @@ int mlx5_devlink_register(struct devlink *devlink)
> >  	if (err)
> >  		goto traps_reg_err;
> >  
> > +	if (!mlx5_core_is_mp_slave(dev))
> > +		devlink_set_ops(devlink, &mlx5_devlink_reload);
> 
> Does this work? Where do you make a copy of the ops? 🤔 You can't modify
> the driver-global ops, to state the obvious.

devlink_ops pointer is not constant at this stage, so why can't I copy
reload_* pointers to the "main" devlink ops?

I wanted to avoid to copy all pointers.

Thanks
