Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958A77CB8B
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 20:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfGaSK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 14:10:56 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41318 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbfGaSK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 14:10:56 -0400
Received: by mail-pf1-f193.google.com with SMTP id m30so32325569pff.8;
        Wed, 31 Jul 2019 11:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=pep2268SUKB+oWlWvHH34A9NbLrS2fXz4pQLCTwbYWI=;
        b=CqC09YWPPepmuNLh0VzhrFZ1t1Hi5zWWRBHXho8B6yypZqlBw6s9ECSPnhQKR1bcnI
         6gQgnSXBc1pGFjvXGmWCbepyZvSmzXDyROSY3QRC+fIKBJ1foIE8xjZ4vqjrQfnMUWGO
         N7tZQ+b1EGDrDhDxjrtza+vklYWSpiBO5UfhAeDDxEVDmf+MFW/AZ1rsaOz6eOUxcPpU
         8aTHDaq5rHfHwE0wA0M5cc0Iw5OFNeYdVMnhQCoaGGMNuMnXuc4PxdGmftDV4HWOZQEc
         5yI5Hg5S8SZtHmpQ4M2ju2rDhIFpQR4yODHR8iUklK4Px96YcKDyxOTH4LKVZcGE+FXT
         aaUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=pep2268SUKB+oWlWvHH34A9NbLrS2fXz4pQLCTwbYWI=;
        b=JOtKvZVUa6yDWUIH/WN6POW3GkEhHxMPLvgBrVP+oAJ7AfusFgX0WQ4uuTMcltWjeX
         4krGr/5HG+SEj82nv026NMytEuBGyMb5cuW7YOvFYmOXy6tX0w2odtMuDiXRtrAmnfLI
         PD/o2NnPFP7x8LEuRJdLXnO5ZXOAcB/uCVlOLsQZj6SdFwh9W335jEbT6KUZtbK8TRkT
         eClJtRLwd4GkvlcsG4CmLjxOtF0VVtQ+wnkolqIxkmrkxMVD2GQ3U9SsoqXX2Jd81k5r
         B50ZJA6WvsNGIx/1UHtOiYEqEtlBblSFYUmPV7G7x0tpONNZXPVQvboBNJ5n5ey5a23w
         PUAQ==
X-Gm-Message-State: APjAAAXaxoJ1YK3cH8Mv7wJW+MhEqLWPbRQjX+kxT8ok+NjG52d4abwY
        nBiPiaCvg1hjW+0mrdo3QWM=
X-Google-Smtp-Source: APXvYqzH2NroFGz5G8oll9tbUUshmLQKnLFfUoZu2sdIPVV4Cx4Qp/Sb7+vBrNOGxHGUUggjy3ua0w==
X-Received: by 2002:a63:c118:: with SMTP id w24mr113486551pgf.347.1564596655215;
        Wed, 31 Jul 2019 11:10:55 -0700 (PDT)
Received: from [172.26.116.133] ([2620:10d:c090:180::1:768c])
        by smtp.gmail.com with ESMTPSA id l124sm69027565pgl.54.2019.07.31.11.10.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 11:10:54 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v4 07/11] mlx5e: modify driver for handling
 offsets
Date:   Wed, 31 Jul 2019 11:10:52 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <7568C727-8F36-4127-9D86-A4C37494C55D@gmail.com>
In-Reply-To: <20190730085400.10376-8-kevin.laatz@intel.com>
References: <20190724051043.14348-1-kevin.laatz@intel.com>
 <20190730085400.10376-1-kevin.laatz@intel.com>
 <20190730085400.10376-8-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30 Jul 2019, at 1:53, Kevin Laatz wrote:

> With the addition of the unaligned chunks option, we need to make sure 
> we
> handle the offsets accordingly based on the mode we are currently 
> running
> in. This patch modifies the driver to appropriately mask the address 
> for
> each case.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
>
> ---
> v3:
>   - Use new helper function to handle offset
>
> v4:
>   - fixed headroom addition to handle. Using 
> xsk_umem_adjust_headroom()
>     now.
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c    | 8 ++++++--
>  drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c | 3 ++-
>  2 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c 
> b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index b0b982cf69bb..d5245893d2c8 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -122,6 +122,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct 
> mlx5e_dma_info *di,
>  		      void *va, u16 *rx_headroom, u32 *len, bool xsk)
>  {
>  	struct bpf_prog *prog = READ_ONCE(rq->xdp_prog);
> +	struct xdp_umem *umem = rq->umem;
>  	struct xdp_buff xdp;
>  	u32 act;
>  	int err;
> @@ -138,8 +139,11 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct 
> mlx5e_dma_info *di,
>  	xdp.rxq = &rq->xdp_rxq;
>
>  	act = bpf_prog_run_xdp(prog, &xdp);
> -	if (xsk)
> -		xdp.handle += xdp.data - xdp.data_hard_start;
> +	if (xsk) {
> +		u64 off = xdp.data - xdp.data_hard_start;
> +
> +		xdp.handle = xsk_umem_handle_offset(umem, xdp.handle, off);

Shouldn't this be xdp_umem_adjust_offset()?


> +	}
>  	switch (act) {
>  	case XDP_PASS:
>  		*rx_headroom = xdp.data - xdp.data_hard_start;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c 
> b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> index 6a55573ec8f2..7c49a66d28c9 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> @@ -24,7 +24,8 @@ int mlx5e_xsk_page_alloc_umem(struct mlx5e_rq *rq,
>  	if (!xsk_umem_peek_addr_rq(umem, &handle))
>  		return -ENOMEM;
>
> -	dma_info->xsk.handle = handle + rq->buff.umem_headroom;
> +	dma_info->xsk.handle = xsk_umem_adjust_offset(umem, handle,
> +						      rq->buff.umem_headroom);
>  	dma_info->xsk.data = xdp_umem_get_data(umem, dma_info->xsk.handle);
>
>  	/* No need to add headroom to the DMA address. In striding RQ case, 
> we
> -- 
> 2.17.1
