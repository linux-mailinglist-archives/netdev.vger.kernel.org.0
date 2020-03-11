Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF15118114C
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 08:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgCKHAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 03:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:32800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgCKHAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 03:00:13 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAE0C20873;
        Wed, 11 Mar 2020 07:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583910012;
        bh=/6cQd4hts3gfr9WVs9lQpGGunRJhWCCe0xntAfrfvD0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D6lf+ymlypW+82IE80OgN42xS32HuZY/X4LY2NhGp6LknZ7ojoSXz7e3uoY+YDTBX
         OFdI2vMa9WwS5KStwzDRZztdMmrwGWUblgjBUzhhVovsgXY8Ylfp/VsJKo70GTynGp
         3dx76vymYve2EWiJgSLGPHj0HqrM17Y3yetqPqso=
Date:   Wed, 11 Mar 2020 09:00:08 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH -next 003/491] MELLANOX MLX5 core VPI driver: Use
 fallthrough;
Message-ID: <20200311070008.GE4215@unreal>
References: <cover.1583896344.git.joe@perches.com>
 <3ce4519315294b9738abe6a78e2737f49af9a653.1583896347.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ce4519315294b9738abe6a78e2737f49af9a653.1583896347.git.joe@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 09:51:17PM -0700, Joe Perches wrote:
> Convert the various uses of fallthrough comments to fallthrough;
>
> Done via script
> Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe.com/
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h         | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c          | 4 ++--
>  drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c      | 2 +-
>  .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c          | 8 ++++----
>  drivers/net/ethernet/mellanox/mlx5/core/vport.c           | 2 +-
>  6 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> index a226277..2a1cc2 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> @@ -223,7 +223,7 @@ mlx5e_set_eseg_swp(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg,
>  	switch (swp_spec->tun_l4_proto) {
>  	case IPPROTO_UDP:
>  		eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L4_UDP;
> -		/* fall through */
> +		fallthrough;
>  	case IPPROTO_TCP:
>  		eseg->swp_inner_l4_offset = skb_inner_transport_offset(skb) / 2;
>  		break;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index f049e0a..f74e50 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -167,11 +167,11 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
>  		return true;
>  	default:
>  		bpf_warn_invalid_xdp_action(act);
> -		/* fall through */
> +		fallthrough;
>  	case XDP_ABORTED:
>  xdp_abort:
>  		trace_xdp_exception(rq->netdev, prog, act);
> -		/* fall through */
> +		fallthrough;
>  	case XDP_DROP:
>  		rq->stats->xdp_drop++;
>  		return true;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> index 01539b8..8a3376a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
> @@ -225,7 +225,7 @@ int mlx5e_ethtool_get_sset_count(struct mlx5e_priv *priv, int sset)
>  		return MLX5E_NUM_PFLAGS;
>  	case ETH_SS_TEST:
>  		return mlx5e_self_test_num(priv);
> -	/* fallthrough */
> +		fallthrough;

This should be removed, there is return before.

>  	default:
>  		return -EOPNOTSUPP;
>  	}
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index 4b5b661..033454 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -2426,7 +2426,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
>  	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
>  		if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE)
>  			return 0;
> -		/* fall through */
> +		fallthrough;
>  	case MLX5_CAP_INLINE_MODE_L2:
>  		NL_SET_ERR_MSG_MOD(extack, "Inline mode can't be set");
>  		return -EOPNOTSUPP;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
> index 416676..a40e43 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
> @@ -199,13 +199,13 @@ static void mlx5_lag_fib_update(struct work_struct *work)
>  	/* Protect internal structures from changes */
>  	rtnl_lock();
>  	switch (fib_work->event) {
> -	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
> +	case FIB_EVENT_ENTRY_REPLACE:
>  	case FIB_EVENT_ENTRY_DEL:
>  		mlx5_lag_fib_route_event(ldev, fib_work->event,
>  					 fib_work->fen_info.fi);
>  		fib_info_put(fib_work->fen_info.fi);
>  		break;
> -	case FIB_EVENT_NH_ADD: /* fall through */
> +	case FIB_EVENT_NH_ADD:
>  	case FIB_EVENT_NH_DEL:
>  		fib_nh = fib_work->fnh_info.fib_nh;
>  		mlx5_lag_fib_nexthop_event(ldev,
> @@ -256,7 +256,7 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
>  		return NOTIFY_DONE;
>
>  	switch (event) {
> -	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
> +	case FIB_EVENT_ENTRY_REPLACE:
>  	case FIB_EVENT_ENTRY_DEL:
>  		fen_info = container_of(info, struct fib_entry_notifier_info,
>  					info);
> @@ -279,7 +279,7 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
>  		 */
>  		fib_info_hold(fib_work->fen_info.fi);
>  		break;
> -	case FIB_EVENT_NH_ADD: /* fall through */
> +	case FIB_EVENT_NH_ADD:
>  	case FIB_EVENT_NH_DEL:
>  		fnh_info = container_of(info, struct fib_nh_notifier_info,
>  					info);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> index 1faac31f..aea1065 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
> @@ -125,7 +125,7 @@ void mlx5_query_min_inline(struct mlx5_core_dev *mdev,
>  	case MLX5_CAP_INLINE_MODE_VPORT_CONTEXT:
>  		if (!mlx5_query_nic_vport_min_inline(mdev, 0, min_inline_mode))
>  			break;
> -		/* fall through */
> +		fallthrough;
>  	case MLX5_CAP_INLINE_MODE_L2:
>  		*min_inline_mode = MLX5_INLINE_MODE_L2;
>  		break;
> --
> 2.24.0
>
