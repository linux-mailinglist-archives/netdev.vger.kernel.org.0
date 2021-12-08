Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C70546D003
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 10:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhLHJ2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 04:28:37 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39884 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhLHJ2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 04:28:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B90B2CE2072;
        Wed,  8 Dec 2021 09:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E08C00446;
        Wed,  8 Dec 2021 09:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638955501;
        bh=6xhtfzE6UiqSxOQ5YZZjARa2MlHDs6b2pFCcQl6FPcU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wtuj18hycXdjT31VTBwwkNoIL45gmP+G7soWYZGePUXJu0SivBe+juPyPfRBFFR0l
         XpqyfCBO+Vz/AWTSUSXqclyYGRg9pIMrTUcrGKOixpCAvBkj6g/4g36nu0U+2udSnd
         l8Yc/CY3sJ2t7QMgxOzRjJFPlFBE5AllI76p6GNh5UXM/csZLEWvdkfZltbuf+Lagm
         SzdzWyEnmfETui1OcLFqwCU8sFZCttjeNBskC9yT4NVqexYfiHeBrtQFSILElpvpEX
         D9TC3oxcQkK8+wCgb/D7Bk/dRHwUKpu+2mhrJNd9f9K7An0WANDqRWUdHU2apGYvCf
         XLTcpFn5o+6Ug==
Date:   Wed, 8 Dec 2021 11:24:57 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shay Drory <shayd@nvidia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, jiri@nvidia.com,
        saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH net-next v2 6/6] net/mlx5: Let user configure max_macs
 generic param
Message-ID: <YbB56UwaCOGO3VX+@unreal>
References: <20211208070350.13305-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208070350.13305-1-shayd@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 09:03:50AM +0200, Shay Drory wrote:
> Currently, max_macs is taking 70Kbytes of memory per function. This
> size is not needed in all use cases, and is critical with large scale.
> Hence, allow user to configure the number of max_macs.
> 
> For example, to reduce the number of max_macs to 1, execute::
> $ devlink dev param set pci/0000:00:0b.0 name max_macs value 1 \
>               cmode driverinit
> $ devlink dev reload pci/0000:00:0b.0
> 
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> ---
>  Documentation/networking/devlink/mlx5.rst     |  3 +
>  .../net/ethernet/mellanox/mlx5/core/devlink.c | 67 +++++++++++++++++++
>  .../net/ethernet/mellanox/mlx5/core/main.c    | 21 ++++++
>  include/linux/mlx5/mlx5_ifc.h                 |  2 +-
>  4 files changed, 92 insertions(+), 1 deletion(-)

<...>

> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
> index fbaab440a484..e9db12aae8f9 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -1621,7 +1621,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
>  
>  	u8         ext_stride_num_range[0x1];
>  	u8         roce_rw_supported[0x1];
> -	u8         reserved_at_3a2[0x1];
> +	u8         log_max_current_uc_list_wr_supported[0x1];
>  	u8         log_max_stride_sz_rq[0x5];
>  	u8         reserved_at_3a8[0x3];
>  	u8         log_min_stride_sz_rq[0x5];


All IFC changes should be in separate patch and need to go to shared branch (mlx5-next).

Thanks

> -- 
> 2.21.3
> 
