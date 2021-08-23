Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236C03F4A1D
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 13:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbhHWLxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 07:53:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235953AbhHWLxH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 07:53:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D704A6103B;
        Mon, 23 Aug 2021 11:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629719545;
        bh=tEkKKQqjz5puZ5bUi2Vk4is1+z6fFRhVviR+ykAgSWM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vNT5ZA/7YWVPCTRiXQF5MgqFreCeDO4cOd/0l7Z8/q0VAhxAgaSANuC4uycwpX6pj
         YQfKduA3ENRbZJFFAgxtVH702vjqS0eA1FO4ulM8pxBgjZ5baDio10C/QqqQCBn6Kp
         sszxijQ5NKbt0dss+1fFCq1S6nM4i0ZgW+jUa3I71/SUHLhV1EDncqcItbEV4D1LLC
         TNz36Fy1ns0HK4R70jwYZuILmgfzMTW0phn//fPoWwLgIt3xOsI1g3bZ7THWqqYWH/
         4UDkqfP0l4giH7TRsciymTk91M0CH4bY+c8YxdA64sQSCriX8kFEB7PqflFspmNZUv
         5CnB1O1pkf5nA==
Date:   Mon, 23 Aug 2021 14:52:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shai Malin <smalin@marvell.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, aelior@marvell.com, malin1024@gmail.com,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH] qed: Enable RDMA relaxed ordering
Message-ID: <YSOL9TNeLy3uHma6@unreal>
References: <20210822185448.12053-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210822185448.12053-1-smalin@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+RDMA

Jakub, David

Can we please ask that everything directly or indirectly related to RDMA
will be sent to linux-rdma@ too?

On Sun, Aug 22, 2021 at 09:54:48PM +0300, Shai Malin wrote:
> Enable the RoCE and iWARP FW relaxed ordering.
> 
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_rdma.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> index 4f4b79250a2b..496092655f26 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> @@ -643,6 +643,8 @@ static int qed_rdma_start_fw(struct qed_hwfn *p_hwfn,
>  				    cnq_id);
>  	}
>  
> +	p_params_header->relaxed_ordering = 1;

Maybe it is only description that needs to be updated, but I would
expect to see call to pcie_relaxed_ordering_enabled() before setting
relaxed_ordering to always true.

If we are talking about RDMA, the IB_ACCESS_RELAXED_ORDERING flag should
be taken into account too.

Thanks

> +
>  	return qed_spq_post(p_hwfn, p_ent, NULL);
>  }
>  
> -- 
> 2.22.0
> 
