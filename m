Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F87460574
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 10:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356977AbhK1JcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 04:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356986AbhK1JaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 04:30:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA68C061574;
        Sun, 28 Nov 2021 01:27:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 651CAB80B32;
        Sun, 28 Nov 2021 09:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2040EC004E1;
        Sun, 28 Nov 2021 09:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638091618;
        bh=FG7LziXTNR9pOZpPTgkq7GwwV41CUyDUZpq1gYQc6yc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WHZM00gaLoig9ClUH0mJYJQoBnbCTzYJRl6GEsSR2wRe8tc2K5kRsOTgtDgasMRK8
         WcmtRDbiu9IrGgzUi1hZXzSg0RWWAQGf1uHhtw0wYDHyicnd4DzHcq30+PGA2GEnpj
         +/7Tsz0YiawugyEiYbU97jr8p5NJI+JTCLgsfzR4tto8FiaJB3VawhrxJuGxPxv19X
         hGqPW93wuy+UVRrsh6DBFFFVHKQCFYfZRDSs273JU7NOZ3br0smu4jgk+bO6v4po9B
         yUm6vm1CNphN9JA+0YbR4Zt4+fXHawNZpXVGd/6+JFLgHzT+FwxHZluC8cyxu6XBmb
         MT5lK/RBCKJ2g==
Date:   Sun, 28 Nov 2021 11:26:54 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Parav Pandit <parav@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Wan Jiabing <wanjiabing@vivo.com>, Eli Cohen <elic@nvidia.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: SF, silence an uninitialized variable
 warning
Message-ID: <YaNLXvuDBnX1LU4y@unreal>
References: <20211127141953.GD24002@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211127141953.GD24002@kili>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 27, 2021 at 05:19:53PM +0300, Dan Carpenter wrote:
> This code sometimes calls mlx5_sf_hw_table_hwc_init() when "ext_base_id"
> is uninitialized.  It's not used on that path, but it generates a static
> checker warning to pass uninitialized variables to another function.
> It may also generate runtime UBSan  warnings depending on if the
> mlx5_sf_hw_table_hwc_init() function is inlined or not.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
