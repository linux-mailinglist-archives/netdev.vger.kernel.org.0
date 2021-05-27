Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E487F3931E6
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 17:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbhE0PLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 11:11:42 -0400
Received: from mga06.intel.com ([134.134.136.31]:49130 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235409AbhE0PLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 11:11:37 -0400
IronPort-SDR: ck1LiCcellxJF00fXeT+iCiZlmKMaDwM8+FDn8IaOcRR6TpFdA3rToSGn2O7gDyaWNOZwbiboz
 Z2nlOfLpjriQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="263956575"
X-IronPort-AV: E=Sophos;i="5.82,334,1613462400"; 
   d="scan'208";a="263956575"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 08:08:47 -0700
IronPort-SDR: Wj929PUHpl8sBYnB2olrul2/4w69SoSFv3GcjDKcMhOdbr0Tj1iG3tjPCIVfFzuZO7zBDTeuUx
 U2ZLGBMOiqtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,334,1613462400"; 
   d="scan'208";a="480620895"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga002.fm.intel.com with ESMTP; 27 May 2021 08:08:43 -0700
Date:   Thu, 27 May 2021 16:55:49 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] bpf: devmap: remove redundant assignment of
 variable drops
Message-ID: <20210527145549.GA7570@ranger.igk.intel.com>
References: <20210527143637.795393-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527143637.795393-1-colin.king@canonical.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 03:36:37PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable drops is being assigned a value that is never
> read, it is being updated later on. The assignment is redundant and
> can be removed.

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Would help if you would have CCed me given the fact that hour ago I
confirmed that it could be removed :p but no big deal.

Thanks!

> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  kernel/bpf/devmap.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index f9148daab0e3..fe3873b5d13d 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -388,8 +388,6 @@ static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
>  		to_send = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
>  		if (!to_send)
>  			goto out;
> -
> -		drops = cnt - to_send;
>  	}
>  
>  	sent = dev->netdev_ops->ndo_xdp_xmit(dev, to_send, bq->q, flags);
> -- 
> 2.31.1
> 
