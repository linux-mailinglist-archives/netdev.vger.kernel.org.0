Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993A6428062
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 12:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhJJKFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 06:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231192AbhJJKFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 06:05:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8C6660F92;
        Sun, 10 Oct 2021 10:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633860223;
        bh=o2SZAeyo0LTn4nX1V2bIT59RoNIlKcGwC6k2nikfsYk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JGaWf2+KSMSmxQ7sc1z5qhvWJuZ+k4GFZ8S+mUGBMGYi0K6gSRFhAnerstcjOog0C
         Lw8BKKal6+hV6ZvK/5UqU4MoDuHi+onYA9uF+ld6tQxR++dDSbAIbKUm18ctSa+Yme
         D64Y7oX/+nExZADKojyKZjaRIHZVsmEfMMC8qsJTrtoXACIkoGbReyJIfZAvecIH6j
         kIc3ZsVxCYzICxYMeeoM/TZWjYESTjtYOjhWTHSJRR/HcDkxOjXLg5HvgPCJeQ74Oz
         cUkLryaVN2lTDFIRe8ycyIM3dcp6RRxmHMh7UBJdVxMnZSZfwjTtz8kIl8r32R9Gum
         K+yn8x87Xhuyw==
Date:   Sun, 10 Oct 2021 13:03:39 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     thomas.lendacky@amd.com, davem@davemloft.net, kuba@kernel.org,
        rmody@marvell.com, skalluru@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        hkelam@marvell.com, sbhatta@marvell.com, tariqt@nvidia.com,
        saeedm@nvidia.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ethernet: Remove redundant 'flush_workqueue()' calls
Message-ID: <YWK6e2+hDGS9xblC@unreal>
References: <3dadac919f6f4a991953965ddbb975f2586e6ecf.1633848953.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3dadac919f6f4a991953965ddbb975f2586e6ecf.1633848953.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 09:01:32AM +0200, Christophe JAILLET wrote:
> 'destroy_workqueue()' already drains the queue before destroying it, so
> there is no need to flush it explicitly.
> 
> Remove the redundant 'flush_workqueue()' calls.
> 
> This was generated with coccinelle:
> 
> @@
> expression E;
> @@
> - 	flush_workqueue(E);
> 	destroy_workqueue(E);
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/amd/xgbe/xgbe-drv.c                 | 2 --
>  drivers/net/ethernet/brocade/bna/bnad.c                  | 1 -
>  drivers/net/ethernet/cavium/liquidio/lio_core.c          | 1 -
>  drivers/net/ethernet/emulex/benet/be_main.c              | 1 -
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.c          | 1 -
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.c          | 2 --
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c      | 1 -
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c     | 1 -
>  drivers/net/ethernet/mellanox/mlx4/cmd.c                 | 2 --
>  drivers/net/ethernet/mellanox/mlx4/en_main.c             | 1 -
>  drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 1 -
>  drivers/net/ethernet/qlogic/qed/qed_sriov.c              | 1 -
>  12 files changed, 15 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com> #mlx*
