Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3C31AE61C
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 21:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbgDQTnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 15:43:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730449AbgDQTnG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 15:43:06 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9015206D9;
        Fri, 17 Apr 2020 19:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587152585;
        bh=MWFT/mUQ9kyME+mBDMhSiNJUXSwy4Ih1HosaUqnRnBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aHqtvvAoAtWDE5NhmZZuNMWNEOhNcuiQ18egv77V8TX2Wb+HqVIxF1SB6+UHM+Sg8
         UedzwnGGejqiRdTegRDsNEIQVQHgb7n0f3G2+L0Wh1RbOiu/m2AWmHZay/mpzSarVn
         eaIJeGRRLGC6NolzgB8Tc2caHzLzUumhzLmUQwos=
Date:   Fri, 17 Apr 2020 22:43:00 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     gregkh@linuxfoundation.org, jgg@ziepe.ca,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC PATCH v5 14/16] RDMA/irdma: Add ABI definitions
Message-ID: <20200417194300.GC3083@unreal>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-15-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417171251.1533371-15-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 10:12:49AM -0700, Jeff Kirsher wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
>
> Add ABI definitions for irdma.
>
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  include/uapi/rdma/irdma-abi.h | 140 ++++++++++++++++++++++++++++++++++
>  1 file changed, 140 insertions(+)
>  create mode 100644 include/uapi/rdma/irdma-abi.h
>
> diff --git a/include/uapi/rdma/irdma-abi.h b/include/uapi/rdma/irdma-abi.h
> new file mode 100644
> index 000000000000..2eb253220161
> --- /dev/null
> +++ b/include/uapi/rdma/irdma-abi.h
> @@ -0,0 +1,140 @@
> +/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
> +/*
> + * Copyright (c) 2006 - 2019 Intel Corporation.  All rights reserved.
> + * Copyright (c) 2005 Topspin Communications.  All rights reserved.
> + * Copyright (c) 2005 Cisco Systems.  All rights reserved.
> + * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
> + */
> +
> +#ifndef IRDMA_ABI_H
> +#define IRDMA_ABI_H
> +
> +#include <linux/types.h>
> +
> +/* irdma must support legacy GEN_1 i40iw kernel
> + * and user-space whose last ABI ver is 5
> + */
> +#define IRDMA_ABI_VER 6
> +
> +enum irdma_memreg_type {
> +	IW_MEMREG_TYPE_MEM  = 0,
> +	IW_MEMREG_TYPE_QP   = 1,
> +	IW_MEMREG_TYPE_CQ   = 2,
> +	IW_MEMREG_TYPE_RSVD = 3,
> +	IW_MEMREG_TYPE_MW   = 4,
> +};
> +
> +struct irdma_alloc_ucontext_req {
> +	__u32 rsvd32;
> +	__u8 userspace_ver;
> +	__u8 rsvd8[3];
> +};
> +
> +struct i40iw_alloc_ucontext_req {
> +	__u32 rsvd32;
> +	__u8 userspace_ver;
> +	__u8 rsvd8[3];
> +};
> +
> +struct irdma_alloc_ucontext_resp {
> +	__aligned_u64 feature_flags;
> +	__aligned_u64 db_mmap_key;
> +	__u32 max_hw_wq_frags;
> +	__u32 max_hw_read_sges;
> +	__u32 max_hw_inline;
> +	__u32 max_hw_rq_quanta;
> +	__u32 max_hw_wq_quanta;
> +	__u32 min_hw_cq_size;
> +	__u32 max_hw_cq_size;
> +	__u32 rsvd1[7];
> +	__u16 max_hw_sq_chunk;
> +	__u16 rsvd2[11];
> +	__u8 kernel_ver;

Why do you need to copy this kernel_ver from i40iw?
Especially given the fact that i40iw didn't use it too much
 120 static int i40iw_alloc_ucontext(struct ib_ucontext *uctx,
 121                                 struct ib_udata *udata)
 <...>
 140         uresp.kernel_ver = req.userspace_ver;

> +	__u8 hw_rev;
> +	__u8 rsvd3[6];
> +};
> +
> +struct i40iw_alloc_ucontext_resp {
> +	__u32 max_pds;
> +	__u32 max_qps;
> +	__u32 wq_size; /* size of the WQs (SQ+RQ) in the mmaped area */
> +	__u8 kernel_ver;
> +	__u8 rsvd[3];
> +};
> +
> +struct irdma_alloc_pd_resp {
> +	__u32 pd_id;
> +	__u8 rsvd[4];
> +};
> +
> +struct irdma_resize_cq_req {
> +	__aligned_u64 user_cq_buffer;
> +};
> +
> +struct irdma_create_cq_req {
> +	__aligned_u64 user_cq_buf;
> +	__aligned_u64 user_shadow_area;
> +};
> +
> +struct irdma_create_qp_req {
> +	__aligned_u64 user_wqe_bufs;
> +	__aligned_u64 user_compl_ctx;
> +};
> +
> +struct i40iw_create_qp_req {
> +	__aligned_u64 user_wqe_bufs;
> +	__aligned_u64 user_compl_ctx;
> +};
> +
> +struct irdma_mem_reg_req {
> +	__u16 reg_type; /* Memory, QP or CQ */
> +	__u16 cq_pages;
> +	__u16 rq_pages;
> +	__u16 sq_pages;
> +};
> +
> +struct irdma_modify_qp_req {
> +	__u8 sq_flush;
> +	__u8 rq_flush;
> +	__u8 rsvd[6];
> +};
> +
> +struct irdma_create_cq_resp {
> +	__u32 cq_id;
> +	__u32 cq_size;
> +};
> +
> +struct irdma_create_qp_resp {
> +	__u32 qp_id;
> +	__u32 actual_sq_size;
> +	__u32 actual_rq_size;
> +	__u32 irdma_drv_opt;
> +	__u32 qp_caps;
> +	__u16 rsvd1;
> +	__u8 lsmm;
> +	__u8 rsvd2;
> +};
> +
> +struct i40iw_create_qp_resp {
> +	__u32 qp_id;
> +	__u32 actual_sq_size;
> +	__u32 actual_rq_size;
> +	__u32 i40iw_drv_opt;
> +	__u16 push_idx;
> +	__u8 lsmm;
> +	__u8 rsvd;
> +};
> +
> +struct irdma_modify_qp_resp {
> +	__aligned_u64 push_wqe_mmap_key;
> +	__aligned_u64 push_db_mmap_key;
> +	__u16 push_offset;
> +	__u8 push_valid;
> +	__u8 rsvd[5];
> +};
> +
> +struct irdma_create_ah_resp {
> +	__u32 ah_id;
> +	__u8 rsvd[4];
> +};
> +#endif /* IRDMA_ABI_H */
> --
> 2.25.2
>
