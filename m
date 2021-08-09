Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3C33E43E8
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbhHIKZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233528AbhHIKZD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 06:25:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B4E61040;
        Mon,  9 Aug 2021 10:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628504683;
        bh=9BBKDTS07td8A7S6bve7pzzNUdy10fPIdNkCSvTkLPk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RxMf6SV3I6lb045FkXbQtkUJ2vALIX3HwVa4b5UIjuIw/kvgbO+FLxxXoEUScprDs
         iMdqrpeg+7iIXoLAz92uKJG5nTB01Gq45TrPKZkOnJaOmqaEtjMRvx0RQ7CvF3G67s
         PHeKwl3QA0TQL2E/EPLY8oHj2Mj+GyaT58Ir5sdMXrBLdR+p3xQcZIBH3ZxL6s0Rh+
         FNk3+xfxFxBgUGOjtcaAV31AcIvhhF6IhjFKeko97gROf238ZqM2fgrGeoHfSKQYWj
         Z1ICYHLW/kI3cexChe7McbUDC4G47XIsDTKy14J25SAvvQW9XdJg5uFrUMDRits+ut
         zW2qeXbbBu5Pw==
Date:   Mon, 9 Aug 2021 13:24:38 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: Make use of pr_warn()
Message-ID: <YRECZn/N9qSQkhKu@unreal>
References: <20210809090843.2456-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809090843.2456-1-caihuoqing@baidu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 05:08:43PM +0800, Cai Huoqing wrote:
> to replace printk(KERN_WARNING ...) with pr_warn() kindly
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index e5c4344a114e..ab7c059e630f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -2702,7 +2702,7 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
>  		if (s_mask && a_mask) {
>  			NL_SET_ERR_MSG_MOD(extack,
>  					   "can't set and add to the same HW field");
> -			printk(KERN_WARNING "mlx5: can't set and add to the same HW field (%x)\n", f->field);
> +			pr_warn("mlx5: can't set and add to the same HW field (%x)\n", f->field);

It should be "mlx5_core_warn(priv->mdev, ....") and not pr_warn.

>  			return -EOPNOTSUPP;
>  		}
>  
> @@ -2741,8 +2741,8 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
>  		if (first < next_z && next_z < last) {
>  			NL_SET_ERR_MSG_MOD(extack,
>  					   "rewrite of few sub-fields isn't supported");
> -			printk(KERN_WARNING "mlx5: rewrite of few sub-fields (mask %lx) isn't offloaded\n",
> -			       mask);
> +			pr_warn("mlx5: rewrite of few sub-fields (mask %lx) isn't offloaded\n",
> +				mask);

ditto

Thanks

>  			return -EOPNOTSUPP;
>  		}
>  
> -- 
> 2.25.1
> 
