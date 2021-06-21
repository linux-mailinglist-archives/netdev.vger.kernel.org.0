Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1993AE555
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 10:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhFUI4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 04:56:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230232AbhFUI4K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 04:56:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE39C60FE7;
        Mon, 21 Jun 2021 08:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624265636;
        bh=tSx8kLmE8sQrgAhcGOKx5HCEQMnfoRMEpAA/QmGg9I8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mgnTgKk8gP7ONciFIDFw+1KZ2g+y3W2SZEpF4YuWWZ+C4nUs6Uu8Z5WNuLgNL11UM
         JWf1Pn6zsraYVz9j0AytRQA3/Og0kQOZRx6aRTVVN8q84aeqd5zx9xxul1vAHTwWFn
         Or9wuj3bCBi0sCchbGxX4DkFkyaDZ97bE4U4mPsAeV+TnTquOmweY1+CB2W2c8I2Sv
         zKiwFkyKwh+jX8+Mewq6aE1DB+Jq7etEeOz1DULARxmXCIyqpESXVux/7XjnFLomFH
         bM8VEBjiENMbchxYu8jswvUu1fgNr9nSUs5KK5aHJXYaYE1hBGYBXzfAlj369ANicw
         RIiNtO3PcQRjA==
Date:   Mon, 21 Jun 2021 11:53:52 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next] net/mlx5: Use cpumask_available() in
 mlx5_eq_create_generic()
Message-ID: <YNBToF0+eruEG7JL@unreal>
References: <20210618000358.2402567-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618000358.2402567-1-nathan@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 05:03:59PM -0700, Nathan Chancellor wrote:
> When CONFIG_CPUMASK_OFFSTACK is unset, cpumask_var_t is not a pointer
> but a single element array, meaning its address in a structure cannot be
> NULL as long as it is not the first element, which it is not. This
> results in a clang warning:
> 
> drivers/net/ethernet/mellanox/mlx5/core/eq.c:715:14: warning: address of
> array 'param->affinity' will always evaluate to 'true'
> [-Wpointer-bool-conversion]
>         if (!param->affinity)
>             ~~~~~~~~^~~~~~~~
> 1 warning generated.
> 
> The helper cpumask_available was added in commit f7e30f01a9e2 ("cpumask:
> Add helper cpumask_available()") to handle situations like this so use
> it to keep the meaning of the code the same while resolving the warning.
> 
> Fixes: e4e3f24b822f ("net/mlx5: Provide cpumask at EQ creation phase")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1400
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
