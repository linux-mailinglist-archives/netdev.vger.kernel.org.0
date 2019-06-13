Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9A6445AF
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392935AbfFMQpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730356AbfFMF76 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 01:59:58 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 491CC20896;
        Thu, 13 Jun 2019 05:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560405597;
        bh=UhOc1e8HfkymDz3w+5868jUcXwAJ3watFIXK8zbwly0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O+ZdRKqlzbU0JXkIN0nR4VyP8rXF0iM/xl+qxi/Sx6S6luRB5QRAXNROnVdPRmice
         4deVk3jXKtwkj6CDLJzbbKmWMWwYgE2YzhLuZ6mApM8UCxrSGtlq46RWLrXR8+NkvV
         PIWqVReqYZoAPOfwpGASMj4yrFcqBpGngyiloX68=
Date:   Thu, 13 Jun 2019 08:59:54 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>, Petr Vorel <pvorel@suse.cz>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH mlx5-next v1 1/4] net/mlx5: Declare more strictly devlink
 encap mode
Message-ID: <20190613055954.GV6369@mtr-leonro.mtl.com>
References: <20190612122014.22359-1-leon@kernel.org>
 <20190612122014.22359-2-leon@kernel.org>
 <VI1PR0501MB2271FF8A570DDBBD26CF7100D1EF0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0501MB2271FF8A570DDBBD26CF7100D1EF0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 04:32:25AM +0000, Parav Pandit wrote:
>
>
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Wednesday, June 12, 2019 5:50 PM
> > To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
> > <jgg@mellanox.com>
> > Cc: Leon Romanovsky <leonro@mellanox.com>; RDMA mailing list <linux-
> > rdma@vger.kernel.org>; Maor Gottlieb <maorg@mellanox.com>; Mark Bloch
> > <markb@mellanox.com>; Parav Pandit <parav@mellanox.com>; Petr Vorel
> > <pvorel@suse.cz>; Saeed Mahameed <saeedm@mellanox.com>; linux-
> > netdev <netdev@vger.kernel.org>; Jiri Pirko <jiri@mellanox.com>
> > Subject: [PATCH mlx5-next v1 1/4] net/mlx5: Declare more strictly devlink
> > encap mode
> >
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Devlink has UAPI declaration for encap mode, so there is no need to be
> > loose on the data get/set by drivers.
> >
> > Update call sites to use enum devlink_eswitch_encap_mode instead of plain
> > u8.
> >
> > Suggested-by: Parav Pandit <parav@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/eswitch.h         | 8 +++++---
> >  .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 6 ++++--
> >  include/net/devlink.h                                     | 6 ++++--
> >  net/core/devlink.c                                        | 6 ++++--
> >  4 files changed, 17 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> > b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> > index ed3fad689ec9..e264dfc64a6e 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> > @@ -175,7 +175,7 @@ struct mlx5_esw_offload {
> >  	DECLARE_HASHTABLE(mod_hdr_tbl, 8);
> >  	u8 inline_mode;
> >  	u64 num_flows;
> > -	u8 encap;
> > +	enum devlink_eswitch_encap_mode encap;
> >  };
> >
> >  /* E-Switch MC FDB table hash node */
> > @@ -356,9 +356,11 @@ int mlx5_devlink_eswitch_inline_mode_set(struct
> > devlink *devlink, u8 mode,
> >  					 struct netlink_ext_ack *extack);
> >  int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8
> > *mode);  int mlx5_eswitch_inline_mode_get(struct mlx5_eswitch *esw, int
> > nvfs, u8 *mode); -int mlx5_devlink_eswitch_encap_mode_set(struct devlink
> > *devlink, u8 encap,
> > +int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
> > +					enum devlink_eswitch_encap_mode
> > encap,
> >  					struct netlink_ext_ack *extack);
> > -int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink, u8
> > *encap);
> > +int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
> > +					enum devlink_eswitch_encap_mode
> > *encap);
> >  void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8
> > rep_type);
> >
> >  int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw, diff --git
> > a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > index e09ae27485ee..f1571163143d 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> > @@ -2137,7 +2137,8 @@ int mlx5_eswitch_inline_mode_get(struct
> > mlx5_eswitch *esw, int nvfs, u8 *mode)
> >  	return 0;
> >  }
> >
> > -int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink, u8
> > encap,
> > +int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
> > +					enum devlink_eswitch_encap_mode
> > encap,
> >  					struct netlink_ext_ack *extack)
> >  {
> >  	struct mlx5_core_dev *dev = devlink_priv(devlink); @@ -2186,7
> > +2187,8 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink
> > *devlink, u8 encap,
> >  	return err;
> >  }
> >
> > -int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink, u8
> > *encap)
> > +int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
> > +					enum devlink_eswitch_encap_mode
> > *encap)
> >  {
> >  	struct mlx5_core_dev *dev = devlink_priv(devlink);
> >  	struct mlx5_eswitch *esw = dev->priv.eswitch; diff --git
> > a/include/net/devlink.h b/include/net/devlink.h index
> > 1c4adfb4195a..7a34fc586def 100644
> > --- a/include/net/devlink.h
> > +++ b/include/net/devlink.h
> > @@ -530,8 +530,10 @@ struct devlink_ops {
> >  	int (*eswitch_inline_mode_get)(struct devlink *devlink, u8
> > *p_inline_mode);
> >  	int (*eswitch_inline_mode_set)(struct devlink *devlink, u8
> > inline_mode,
> >  				       struct netlink_ext_ack *extack);
> > -	int (*eswitch_encap_mode_get)(struct devlink *devlink, u8
> > *p_encap_mode);
> > -	int (*eswitch_encap_mode_set)(struct devlink *devlink, u8
> > encap_mode,
> > +	int (*eswitch_encap_mode_get)(struct devlink *devlink,
> > +				      enum devlink_eswitch_encap_mode
> > *p_encap_mode);
> > +	int (*eswitch_encap_mode_set)(struct devlink *devlink,
> > +				      enum devlink_eswitch_encap_mode
> > encap_mode,
> >  				      struct netlink_ext_ack *extack);
> >  	int (*info_get)(struct devlink *devlink, struct devlink_info_req *req,
> >  			struct netlink_ext_ack *extack);
> > diff --git a/net/core/devlink.c b/net/core/devlink.c index
> > d43bc52b8840..47ae69363b07 100644
> > --- a/net/core/devlink.c
> > +++ b/net/core/devlink.c
> > @@ -1552,7 +1552,8 @@ static int devlink_nl_eswitch_fill(struct sk_buff
> > *msg, struct devlink *devlink,
> >  				   u32 seq, int flags)
> >  {
> >  	const struct devlink_ops *ops = devlink->ops;
> > -	u8 inline_mode, encap_mode;
> > +	enum devlink_eswitch_encap_mode encap_mode;
> > +	u8 inline_mode;
> >  	void *hdr;
> >  	int err = 0;
> >  	u16 mode;
> > @@ -1628,7 +1629,8 @@ static int devlink_nl_cmd_eswitch_set_doit(struct
> > sk_buff *skb,  {
> >  	struct devlink *devlink = info->user_ptr[0];
> >  	const struct devlink_ops *ops = devlink->ops;
> > -	u8 inline_mode, encap_mode;
> > +	enum devlink_eswitch_encap_mode encap_mode;
> > +	u8 inline_mode;
> >  	int err = 0;
> >  	u16 mode;
> >
> > --
> > 2.20.1
>
> Netdev follows reverse Christmas tree, but otherwise,

It was before this patch, if Jiri is ok with that, I'll change this
"const struct devlink_ops *ops = devlink->ops;" line while I'll apply
this patchset to mlx5-net. If not, I'll leave it as is.

> Reviewed-by: Parav Pandit <parav@mellanox.com>

Thanks

>
