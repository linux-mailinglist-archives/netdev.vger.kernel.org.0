Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3862E364D
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 12:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgL1LQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 06:16:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727019AbgL1LQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 06:16:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BD2F22583;
        Mon, 28 Dec 2020 11:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609154136;
        bh=p/d9NYlRf2ZDsjuZYUJr8g6BtTGtaBFrKLIAM/vqTPs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MORuj9xwiOPBco/0e42u+QXr446Q86w1dpcRwtrz91efiB24qedqo35x0YJe/qQRR
         tHAhtqC2v4hR8Ti3Ap7j+vj80PFK8s0A/xNmkzZYGn0NfW7zlsTxBP8EwOMkTlMw9i
         q8GMNI4sSsmpzTaFoCFTcbUbEIYxV+OeMseb8xH94nqgLoOmu3h69iedGqonu/jxzy
         SlyAUuyw4MwGz37V+7hguuHn0w456xOinnH7y9A3PZ4SbCjPIPF43GTGNNNl2T0o2i
         pyZBDDfYeOHC2LLNrEUdW9R0R8SGNlBNrLeHxYC466pQT8viCFMgmQe2f1sS3WE57F
         QEhRUNT5ttFQA==
Date:   Mon, 28 Dec 2020 13:15:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Gal Pressman <galp@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] net/mlx5e: Fix two double free cases
Message-ID: <20201228111532.GJ4457@unreal>
References: <20201228084840.5013-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228084840.5013-1-dinghao.liu@zju.edu.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 04:48:40PM +0800, Dinghao Liu wrote:
> mlx5e_create_ttc_table_groups() frees ft->g on failure of
> kvzalloc(), but such failure will be caught by its caller
> in mlx5e_create_ttc_table() and ft->g will be freed again
> in mlx5e_destroy_flow_table(). The same issue also occurs
> in mlx5e_create_ttc_table_groups(). Set ft->g to NULL after
> kfree() to avoid double free.
>
> Fixes: 7b3722fa9ef64 ("net/mlx5e: Support RSS for GRE tunneled packets")
> Fixes: 33cfaaa8f36ff ("net/mlx5e: Split the main flow steering table")
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> ---
>
> Changelog:
>
> v2: - Set ft->g to NULL after kfree() instead of removing kfree().
>       Refine commit message.
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 2 ++
>  1 file changed, 2 insertions(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
