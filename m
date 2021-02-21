Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9706F3208EF
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 07:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbhBUGMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 01:12:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhBUGMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Feb 2021 01:12:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF2EC64EB4;
        Sun, 21 Feb 2021 06:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613887902;
        bh=EEU0w1b40Cz+bhOACpKtWV1r+Gem+0S1XIa7M+XT4MM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q7K1Rw4MoZQ3r9xV0pveWtuICLEDZT3SAYj45vqxTpJ/l4oeYuc8uct5qT/AAjury
         6czGx2sCF7rrVUV/UcDr6AayT49PXBu6l1VyhpLG3/cOSL2kysqzbhi8qDj7oq0MO2
         pQSWxySGR7s4wA7fvpuZaaHqcDuHjWy3wnJ8Dcdk2P8tr9NN9nctNKVoKog2Mj9C3n
         toY7AL9aJBP7MmLkdLP7DWP2+MQpWZXRk73ewco/R9NsxlvFlL52NqAsrXGa7rnAjw
         cmZQw2DhzNhpGPDPOJz0V0KjJdXIFdtYuZaYI1F7Fm4Xz0ssrAOn4ghXu68/NrX1Pj
         KRs1SgW0cbUjA==
Date:   Sun, 21 Feb 2021 08:11:38 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        "Pavel Machek (CIP)" <pavel@denx.de>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH mellanox-tree] net/mlx5: prevent an integer underflow in
 mlx5_perout_configure()
Message-ID: <YDH5muwFJB9eyDhL@unreal>
References: <YC+LoAcvcQSWLLKX@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YC+LoAcvcQSWLLKX@mwanda>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 12:57:52PM +0300, Dan Carpenter wrote:
> The value of "sec" comes from the user.  Negative values will lead to
> shift wrapping inside the perout_conf_real_time() function and triggger
> a UBSan warning.
>
> Add a check and return -EINVAL to prevent that from happening.
>
> Fixes: 432119de33d9 ("net/mlx5: Add cyc2time HW translation mode support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Saeed, I think this goes through your git tree and you will send a pull
> request to the networking?
>
> From static analysis.  Not tested.
>
>  drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
