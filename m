Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950323CC96F
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 15:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbhGROBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 10:01:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60453 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230461AbhGROBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 10:01:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626616703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=19v5D8bRVm+lStdjgUon0q9aeP8opTApQap714gjX7U=;
        b=bbH3KmwZ4E3/yyqFAD7Ifp12Kpvzwf3onioPvhaKzVKYHnlyrwZtz1fXuCN9UPnAs8MM5+
        BSMi/7nHtcWyKukdHSt5uVDJ9ZnWqG3mOMspnJUa+5XYNfalI6EGPEkJWSQW3c2+4UCs72
        u41LzJ68QhMxdL7+S8tCm8SR6oyaeAE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-mg_t3WbBPnSAYU-k5niKbA-1; Sun, 18 Jul 2021 09:58:22 -0400
X-MC-Unique: mg_t3WbBPnSAYU-k5niKbA-1
Received: by mail-wm1-f69.google.com with SMTP id i7-20020a05600c3547b0290229a389ceb2so3285761wmq.0
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 06:58:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=19v5D8bRVm+lStdjgUon0q9aeP8opTApQap714gjX7U=;
        b=AugO7ZoBbyvE7URlDz+QBU5YVaBYx94Dn5cPD+HAr2FNC1pSQsAw2Tc45ytgSN6tkj
         KAHUO3K5kOlEGAd+y4aq+yNuJDQpTIybsgJ6NNDJ8zUDy7vkkR5J2kQrskcycTNetGJ5
         JjWNlTE93H7nBIjx9G3WhhZ55W4pqdjReJcICLDqTFPeYg38rk6ypWwRBAB3ISiS0GG3
         5zt7GZxVo+pe4edcCuODdqxOXvh0muJA8kzG3bUX3KTtKBoyzB3Pt4w+58QMqBjgYC9s
         z6MvybFZoVJiiGJq1wl7bwv86Dqk4DhgSym5JDhp9odTtjNa6tlA6Vt7u9+FA9SDEleC
         xwXQ==
X-Gm-Message-State: AOAM5327C5YaQVt1GSeteQDZed2vlEJFdp9N+zY/jQcfPwpo+uEJw8sA
        tA92C2f4ShBNP2hQv3BAFnJiOKzdWNasnW1NzPXl0PdsYIfG6zz7t5jxOTTQ8a6TODu/9SdW0WL
        ehtepEiFZPy83qZT8
X-Received: by 2002:a5d:6889:: with SMTP id h9mr5083522wru.80.1626616701139;
        Sun, 18 Jul 2021 06:58:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwF7QfXkH4VrgcY96cSNBnRG8DR0SNMZ2/Sbv43p7XU/OxiIQSeCAAcCG8kp14LFV47h3tTuA==
X-Received: by 2002:a5d:6889:: with SMTP id h9mr5083506wru.80.1626616700970;
        Sun, 18 Jul 2021 06:58:20 -0700 (PDT)
Received: from redhat.com ([2.55.29.175])
        by smtp.gmail.com with ESMTPSA id o18sm16881198wrx.21.2021.07.18.06.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jul 2021 06:58:20 -0700 (PDT)
Date:   Sun, 18 Jul 2021 09:58:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Tal Gilboa <talgi@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH mlx5-next] IB/mlx5: Rename is_apu_thread_cq function to
 is_apu_cq
Message-ID: <20210718095805-mutt-send-email-mst@kernel.org>
References: <0e3364dab7e0e4eea5423878b01aa42470be8d36.1626609184.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e3364dab7e0e4eea5423878b01aa42470be8d36.1626609184.git.leonro@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 18, 2021 at 02:54:13PM +0300, Leon Romanovsky wrote:
> From: Tal Gilboa <talgi@nvidia.com>
> 
> is_apu_thread_cq() used to detect CQs which are attached to APU
> threads. This was extended to support other elements as well,
> so the function was renamed to is_apu_cq().
> 
> c_eqn_or_apu_element was extended from 8 bits to 32 bits, which wan't
> reflected when the APU support was first introduced.
> 
> Signed-off-by: Tal Gilboa <talgi@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

vdpa bits
Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/infiniband/hw/mlx5/cq.c                            | 2 +-
>  drivers/infiniband/hw/mlx5/devx.c                          | 7 +++----
>  drivers/net/ethernet/mellanox/mlx5/core/cq.c               | 3 ++-
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c          | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c        | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 2 +-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c                          | 2 +-
>  include/linux/mlx5/mlx5_ifc.h                              | 5 ++---
>  8 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> index aef87a7c01ff..464e6a1ecdb0 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -997,7 +997,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>  				  MLX5_IB_CQ_PR_FLAGS_CQE_128_PAD));
>  	MLX5_SET(cqc, cqc, log_cq_size, ilog2(entries));
>  	MLX5_SET(cqc, cqc, uar_page, index);
> -	MLX5_SET(cqc, cqc, c_eqn, eqn);
> +	MLX5_SET(cqc, cqc, c_eqn_or_apu_element, eqn);
>  	MLX5_SET64(cqc, cqc, dbr_addr, cq->db.dma);
>  	if (cq->create_flags & IB_UVERBS_CQ_FLAGS_IGNORE_OVERRUN)
>  		MLX5_SET(cqc, cqc, oi, 1);
> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
> index edcac8b3f384..31f5f4c73d25 100644
> --- a/drivers/infiniband/hw/mlx5/devx.c
> +++ b/drivers/infiniband/hw/mlx5/devx.c
> @@ -1437,11 +1437,10 @@ static void devx_cq_comp(struct mlx5_core_cq *mcq, struct mlx5_eqe *eqe)
>  	rcu_read_unlock();
>  }
>  
> -static bool is_apu_thread_cq(struct mlx5_ib_dev *dev, const void *in)
> +static bool is_apu_cq(struct mlx5_ib_dev *dev, const void *in)
>  {
>  	if (!MLX5_CAP_GEN(dev->mdev, apu) ||
> -	    !MLX5_GET(cqc, MLX5_ADDR_OF(create_cq_in, in, cq_context),
> -		      apu_thread_cq))
> +	    !MLX5_GET(cqc, MLX5_ADDR_OF(create_cq_in, in, cq_context), apu_cq))
>  		return false;
>  
>  	return true;
> @@ -1501,7 +1500,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
>  		err = mlx5_core_create_dct(dev, &obj->core_dct, cmd_in,
>  					   cmd_in_len, cmd_out, cmd_out_len);
>  	} else if (opcode == MLX5_CMD_OP_CREATE_CQ &&
> -		   !is_apu_thread_cq(dev, cmd_in)) {
> +		   !is_apu_cq(dev, cmd_in)) {
>  		obj->flags |= DEVX_OBJ_FLAGS_CQ;
>  		obj->core_cq.comp = devx_cq_comp;
>  		err = mlx5_core_create_cq(dev->mdev, &obj->core_cq,
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
> index df3e4938ecdd..99ec278d0370 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
> @@ -89,7 +89,8 @@ static void mlx5_add_cq_to_tasklet(struct mlx5_core_cq *cq,
>  int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
>  			u32 *in, int inlen, u32 *out, int outlen)
>  {
> -	int eqn = MLX5_GET(cqc, MLX5_ADDR_OF(create_cq_in, in, cq_context), c_eqn);
> +	int eqn = MLX5_GET(cqc, MLX5_ADDR_OF(create_cq_in, in, cq_context),
> +			   c_eqn_or_apu_element);
>  	u32 din[MLX5_ST_SZ_DW(destroy_cq_in)] = {};
>  	struct mlx5_eq_comp *eq;
>  	int err;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index c47603a952f3..308ccace48d0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -1626,7 +1626,7 @@ static int mlx5e_create_cq(struct mlx5e_cq *cq, struct mlx5e_cq_param *param)
>  				  (__be64 *)MLX5_ADDR_OF(create_cq_in, in, pas));
>  
>  	MLX5_SET(cqc,   cqc, cq_period_mode, param->cq_period_mode);
> -	MLX5_SET(cqc,   cqc, c_eqn,         eqn);
> +	MLX5_SET(cqc,   cqc, c_eqn_or_apu_element, eqn);
>  	MLX5_SET(cqc,   cqc, uar_page,      mdev->priv.uar->index);
>  	MLX5_SET(cqc,   cqc, log_page_size, cq->wq_ctrl.buf.page_shift -
>  					    MLX5_ADAPTER_PAGE_SHIFT);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
> index 6f78716ff321..9bb4944820df 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
> @@ -454,7 +454,7 @@ static int mlx5_fpga_conn_create_cq(struct mlx5_fpga_conn *conn, int cq_size)
>  
>  	cqc = MLX5_ADDR_OF(create_cq_in, in, cq_context);
>  	MLX5_SET(cqc, cqc, log_cq_size, ilog2(cq_size));
> -	MLX5_SET(cqc, cqc, c_eqn, eqn);
> +	MLX5_SET(cqc, cqc, c_eqn_or_apu_element, eqn);
>  	MLX5_SET(cqc, cqc, uar_page, fdev->conn_res.uar->index);
>  	MLX5_SET(cqc, cqc, log_page_size, conn->cq.wq_ctrl.buf.page_shift -
>  			   MLX5_ADAPTER_PAGE_SHIFT);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
> index d1300b16d054..a4a3ee87a903 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
> @@ -790,7 +790,7 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
>  
>  	cqc = MLX5_ADDR_OF(create_cq_in, in, cq_context);
>  	MLX5_SET(cqc, cqc, log_cq_size, ilog2(ncqe));
> -	MLX5_SET(cqc, cqc, c_eqn, eqn);
> +	MLX5_SET(cqc, cqc, c_eqn_or_apu_element, eqn);
>  	MLX5_SET(cqc, cqc, uar_page, uar->index);
>  	MLX5_SET(cqc, cqc, log_page_size, cq->wq_ctrl.buf.page_shift -
>  		 MLX5_ADAPTER_PAGE_SHIFT);
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 0121c7c49396..83fa3c26cbd2 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -573,7 +573,7 @@ static int cq_create(struct mlx5_vdpa_net *ndev, u16 idx, u32 num_ent)
>  	cqc = MLX5_ADDR_OF(create_cq_in, in, cq_context);
>  	MLX5_SET(cqc, cqc, log_cq_size, ilog2(num_ent));
>  	MLX5_SET(cqc, cqc, uar_page, ndev->mvdev.res.uar->index);
> -	MLX5_SET(cqc, cqc, c_eqn, eqn);
> +	MLX5_SET(cqc, cqc, c_eqn_or_apu_element, eqn);
>  	MLX5_SET64(cqc, cqc, dbr_addr, vcq->db.dma);
>  
>  	err = mlx5_core_create_cq(mdev, &vcq->mcq, in, inlen, out, sizeof(out));
> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
> index c980eab89867..e93f16b87312 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -3923,7 +3923,7 @@ struct mlx5_ifc_cqc_bits {
>  	u8         status[0x4];
>  	u8         reserved_at_4[0x2];
>  	u8         dbr_umem_valid[0x1];
> -	u8         apu_thread_cq[0x1];
> +	u8         apu_cq[0x1];
>  	u8         cqe_sz[0x3];
>  	u8         cc[0x1];
>  	u8         reserved_at_c[0x1];
> @@ -3949,8 +3949,7 @@ struct mlx5_ifc_cqc_bits {
>  	u8         cq_period[0xc];
>  	u8         cq_max_count[0x10];
>  
> -	u8         reserved_at_a0[0x18];
> -	u8         c_eqn[0x8];
> +	u8         c_eqn_or_apu_element[0x20];
>  
>  	u8         reserved_at_c0[0x3];
>  	u8         log_page_size[0x5];
> -- 
> 2.31.1

