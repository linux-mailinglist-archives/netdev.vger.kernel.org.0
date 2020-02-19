Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1AE4163D6C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 08:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgBSHOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 02:14:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:49454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgBSHOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 02:14:40 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EA1A208C4;
        Wed, 19 Feb 2020 07:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582096479;
        bh=vDPiNf+B0mf5gkVuFamqWW9yxNxqLXftA3SmpYPSvTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nuLNKQV1Cz08LTtUOVLhz7T4TSOwokH2pAiny1j1ceNqqD+M1ZkvwUaLXmAr7zSu4
         9nECNM4SJ4uAoAsY7PBNTk43AIPiTBIHDNGJ3EG0gFRe5fMFslb5Iktmt71/EwjBGo
         2Zt6l207M3t8eM6n0CfKlF9Ru11Y+d2S/Uv1Ujgg=
Date:   Wed, 19 Feb 2020 09:14:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Boris Pismenny <borisp@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net/mlx5e: Replace zero-length array with
 flexible-array member
Message-ID: <20200219071435.GE15239@unreal>
References: <20200218203114.GA27096@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218203114.GA27096@embeddedor>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 02:31:14PM -0600, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
>
> struct foo {
>         int stuff;
>         struct boo array[];
> };
>
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
>
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
>
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
>
> This issue was found with the help of Coccinelle.
>
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en.h          | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c  | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h | 4 ++--
>  4 files changed, 5 insertions(+), 5 deletions(-)
>

Thanks, applied to mlx5-next.
